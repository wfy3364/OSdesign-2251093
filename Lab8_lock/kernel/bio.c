// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define BUCKET_NUM 13    // number of buckets
#define HASH(num) (num % BUCKET_NUM)

int testnum = 0;

struct {
  struct spinlock lock[BUCKET_NUM]; //new!
  struct buf buf[NBUF];
  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head[BUCKET_NUM]; //new!
} bcache;

void
binit(void)
{
  //struct buf *b;
  char ch[10];
  for(int i = 0;i < BUCKET_NUM;i++){
    snprintf(ch, 10, "bcache_%d", i);
    initlock(&bcache.lock[i], ch);
    bcache.head[i].prev = &bcache.head[i];
    bcache.head[i].next = &bcache.head[i];
  }

  for(int i = 0;i < NBUF;i++){
    //int hash = HASH(i);
    //bcache.buf[i].next = bcache.head[hash].next;
    //bcache.buf[i].prev = &bcache.head[hash];
    initsleeplock(&bcache.buf[i].lock, "buffer");
    //bcache.head[hash].next->prev = &bcache.buf[i];
    //bcache.head[hash].next = &bcache.buf[i];
    bcache.buf[i].bucket = -1;
  }

}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int hash = HASH(blockno);
  acquire(&bcache.lock[hash]);
  // Is the block already cached?
  for(b = bcache.head[hash].next; b != &bcache.head[hash]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock[hash]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  for (int i = hash; i < NBUF; i+=BUCKET_NUM) {
    if (bcache.buf[i].refcnt==0) {
      struct buf *buf = &bcache.buf[i];
      buf->dev = dev;
      buf->blockno = blockno;
      buf->valid = 0;
      buf->refcnt = 1;

      buf->next = bcache.head[hash].next;
      buf->prev = &bcache.head[hash];
      bcache.head[hash].next->prev = buf;
      bcache.head[hash].next = buf;

      bcache.buf[i].bucket = hash;

      release(&bcache.lock[hash]);
      acquiresleep(&buf->lock);
      return buf;
    }
  }


  for(int j = (hash + 1) % BUCKET_NUM;j != hash;j = (j + 1) % BUCKET_NUM)
  {
    acquire(&bcache.lock[j]);
    for (int i = j; i < NBUF; i += BUCKET_NUM) {
      if (bcache.buf[i].refcnt==0) {
        struct buf *buf = &bcache.buf[i];
        buf->dev = dev;
        buf->blockno = blockno;
        buf->valid = 0;
        buf->refcnt = 1;

        buf->next = bcache.head[hash].next;
        buf->prev = &bcache.head[hash];
        bcache.head[hash].next->prev = buf;
        bcache.head[hash].next = buf;

        bcache.buf[i].bucket = hash;

        release(&bcache.lock[j]);
        release(&bcache.lock[hash]);
        acquiresleep(&buf->lock);
        return buf;
      }
    }
    release(&bcache.lock[j]);
  }

  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock[b->bucket]);
  b->refcnt--;
  if (b->refcnt == 0) {
    //printf("release%d\n", hash);
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    //b->next = bcache.head[hash].next;
    //b->prev = &bcache.head[hash];
    //bcache.head[hash].next->prev = b;
    //bcache.head[hash].next = b;
  }
  release(&bcache.lock[b->bucket]);
}

void
bpin(struct buf *b) {
  int hash = HASH(b->blockno);
  acquire(&bcache.lock[hash]);
  b->refcnt++;
  release(&bcache.lock[hash]);
}

void
bunpin(struct buf *b) {
  int hash = HASH(b->blockno);
  acquire(&bcache.lock[hash]);
  b->refcnt--;
  release(&bcache.lock[hash]);
}


