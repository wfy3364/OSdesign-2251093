
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9b013103          	ld	sp,-1616(sp) # 800089b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5c7050ef          	jal	ra,80005ddc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c9                	bnez	a5,800000b4 <kfree+0x98>
    80000034:	84aa                	mv	s1,a0
    80000036:	00028797          	auipc	a5,0x28
    8000003a:	c8278793          	addi	a5,a5,-894 # 80027cb8 <end>
    8000003e:	06f56b63          	bltu	a0,a5,800000b4 <kfree+0x98>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57763          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	260080e7          	jalr	608(ra) # 800002ae <memset>

  r = (struct run*)pa;

  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	724080e7          	jalr	1828(ra) # 8000677a <push_off>
  int num = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	f6c080e7          	jalr	-148(ra) # 80000fca <cpuid>
    80000066:	8a2a                	mv	s4,a0
  pop_off();
    80000068:	00006097          	auipc	ra,0x6
    8000006c:	7ce080e7          	jalr	1998(ra) # 80006836 <pop_off>

  acquire(&kmem[num].lock);
    80000070:	00009a97          	auipc	s5,0x9
    80000074:	9a0a8a93          	addi	s5,s5,-1632 # 80008a10 <kmem>
    80000078:	002a1993          	slli	s3,s4,0x2
    8000007c:	01498933          	add	s2,s3,s4
    80000080:	090e                	slli	s2,s2,0x3
    80000082:	9956                	add	s2,s2,s5
    80000084:	854a                	mv	a0,s2
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	740080e7          	jalr	1856(ra) # 800067c6 <acquire>
  r->next = kmem[num].freelist;
    8000008e:	02093783          	ld	a5,32(s2)
    80000092:	e09c                	sd	a5,0(s1)
  kmem[num].freelist = r;
    80000094:	02993023          	sd	s1,32(s2)
  release(&kmem[num].lock);
    80000098:	854a                	mv	a0,s2
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	7fc080e7          	jalr	2044(ra) # 80006896 <release>
}
    800000a2:	70e2                	ld	ra,56(sp)
    800000a4:	7442                	ld	s0,48(sp)
    800000a6:	74a2                	ld	s1,40(sp)
    800000a8:	7902                	ld	s2,32(sp)
    800000aa:	69e2                	ld	s3,24(sp)
    800000ac:	6a42                	ld	s4,16(sp)
    800000ae:	6aa2                	ld	s5,8(sp)
    800000b0:	6121                	addi	sp,sp,64
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f5c50513          	addi	a0,a0,-164 # 80008010 <etext+0x10>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	1d6080e7          	jalr	470(ra) # 80006292 <panic>

00000000800000c4 <freerange>:
{
    800000c4:	7179                	addi	sp,sp,-48
    800000c6:	f406                	sd	ra,40(sp)
    800000c8:	f022                	sd	s0,32(sp)
    800000ca:	ec26                	sd	s1,24(sp)
    800000cc:	e84a                	sd	s2,16(sp)
    800000ce:	e44e                	sd	s3,8(sp)
    800000d0:	e052                	sd	s4,0(sp)
    800000d2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d4:	6785                	lui	a5,0x1
    800000d6:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000da:	94aa                	add	s1,s1,a0
    800000dc:	757d                	lui	a0,0xfffff
    800000de:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3a>
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x28>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7179                	addi	sp,sp,-48
    80000110:	f406                	sd	ra,40(sp)
    80000112:	f022                	sd	s0,32(sp)
    80000114:	ec26                	sd	s1,24(sp)
    80000116:	e84a                	sd	s2,16(sp)
    80000118:	e44e                	sd	s3,8(sp)
    8000011a:	1800                	addi	s0,sp,48
  for(int i = 0;i<NCPU;i++){
    8000011c:	00009497          	auipc	s1,0x9
    80000120:	8f448493          	addi	s1,s1,-1804 # 80008a10 <kmem>
    80000124:	00009997          	auipc	s3,0x9
    80000128:	a2c98993          	addi	s3,s3,-1492 # 80008b50 <pid_lock>
    initlock(&kmem[i].lock, "kmem");
    8000012c:	00008917          	auipc	s2,0x8
    80000130:	eec90913          	addi	s2,s2,-276 # 80008018 <etext+0x18>
    80000134:	85ca                	mv	a1,s2
    80000136:	8526                	mv	a0,s1
    80000138:	00007097          	auipc	ra,0x7
    8000013c:	80a080e7          	jalr	-2038(ra) # 80006942 <initlock>
  for(int i = 0;i<NCPU;i++){
    80000140:	02848493          	addi	s1,s1,40
    80000144:	ff3498e3          	bne	s1,s3,80000134 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    80000148:	45c5                	li	a1,17
    8000014a:	05ee                	slli	a1,a1,0x1b
    8000014c:	00028517          	auipc	a0,0x28
    80000150:	b6c50513          	addi	a0,a0,-1172 # 80027cb8 <end>
    80000154:	00000097          	auipc	ra,0x0
    80000158:	f70080e7          	jalr	-144(ra) # 800000c4 <freerange>
}
    8000015c:	70a2                	ld	ra,40(sp)
    8000015e:	7402                	ld	s0,32(sp)
    80000160:	64e2                	ld	s1,24(sp)
    80000162:	6942                	ld	s2,16(sp)
    80000164:	69a2                	ld	s3,8(sp)
    80000166:	6145                	addi	sp,sp,48
    80000168:	8082                	ret

000000008000016a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000016a:	7139                	addi	sp,sp,-64
    8000016c:	fc06                	sd	ra,56(sp)
    8000016e:	f822                	sd	s0,48(sp)
    80000170:	f426                	sd	s1,40(sp)
    80000172:	f04a                	sd	s2,32(sp)
    80000174:	ec4e                	sd	s3,24(sp)
    80000176:	e852                	sd	s4,16(sp)
    80000178:	e456                	sd	s5,8(sp)
    8000017a:	e05a                	sd	s6,0(sp)
    8000017c:	0080                	addi	s0,sp,64
  struct run *r;

  push_off();
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	5fc080e7          	jalr	1532(ra) # 8000677a <push_off>
  int num = cpuid();
    80000186:	00001097          	auipc	ra,0x1
    8000018a:	e44080e7          	jalr	-444(ra) # 80000fca <cpuid>
    8000018e:	84aa                	mv	s1,a0
  pop_off();
    80000190:	00006097          	auipc	ra,0x6
    80000194:	6a6080e7          	jalr	1702(ra) # 80006836 <pop_off>

  acquire(&kmem[num].lock);
    80000198:	00249793          	slli	a5,s1,0x2
    8000019c:	97a6                	add	a5,a5,s1
    8000019e:	078e                	slli	a5,a5,0x3
    800001a0:	00009917          	auipc	s2,0x9
    800001a4:	87090913          	addi	s2,s2,-1936 # 80008a10 <kmem>
    800001a8:	993e                	add	s2,s2,a5
    800001aa:	854a                	mv	a0,s2
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	61a080e7          	jalr	1562(ra) # 800067c6 <acquire>
  r = kmem[num].freelist;
    800001b4:	02093983          	ld	s3,32(s2)
  if(r)
    800001b8:	02098d63          	beqz	s3,800001f2 <kalloc+0x88>
    kmem[num].freelist = r->next;
    800001bc:	0009b703          	ld	a4,0(s3)
    800001c0:	02e93023          	sd	a4,32(s2)
    }
    r = kmem[num].freelist;
    if(r)
      kmem[num].freelist = r->next;
  }
  release(&kmem[num].lock);
    800001c4:	854a                	mv	a0,s2
    800001c6:	00006097          	auipc	ra,0x6
    800001ca:	6d0080e7          	jalr	1744(ra) # 80006896 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001ce:	6605                	lui	a2,0x1
    800001d0:	4595                	li	a1,5
    800001d2:	854e                	mv	a0,s3
    800001d4:	00000097          	auipc	ra,0x0
    800001d8:	0da080e7          	jalr	218(ra) # 800002ae <memset>
  return (void*)r;
}
    800001dc:	854e                	mv	a0,s3
    800001de:	70e2                	ld	ra,56(sp)
    800001e0:	7442                	ld	s0,48(sp)
    800001e2:	74a2                	ld	s1,40(sp)
    800001e4:	7902                	ld	s2,32(sp)
    800001e6:	69e2                	ld	s3,24(sp)
    800001e8:	6a42                	ld	s4,16(sp)
    800001ea:	6aa2                	ld	s5,8(sp)
    800001ec:	6b02                	ld	s6,0(sp)
    800001ee:	6121                	addi	sp,sp,64
    800001f0:	8082                	ret
    800001f2:	00009a97          	auipc	s5,0x9
    800001f6:	81ea8a93          	addi	s5,s5,-2018 # 80008a10 <kmem>
    for(int i = 0;i < NCPU; i++)
    800001fa:	4981                	li	s3,0
    800001fc:	4b21                	li	s6,8
      if(i == num) //its own
    800001fe:	09348c63          	beq	s1,s3,80000296 <kalloc+0x12c>
      acquire(&kmem[i].lock);
    80000202:	8a56                	mv	s4,s5
    80000204:	8556                	mv	a0,s5
    80000206:	00006097          	auipc	ra,0x6
    8000020a:	5c0080e7          	jalr	1472(ra) # 800067c6 <acquire>
      if(kmem[i].freelist == 0){ //this cpu has no free page
    8000020e:	020ab603          	ld	a2,32(s5)
    80000212:	ce2d                	beqz	a2,8000028c <kalloc+0x122>
    80000214:	87b2                	mv	a5,a2
    80000216:	40000713          	li	a4,1024
        if(temp->next)
    8000021a:	86be                	mv	a3,a5
    8000021c:	639c                	ld	a5,0(a5)
    8000021e:	c781                	beqz	a5,80000226 <kalloc+0xbc>
      for(int j = 0;j < 1024;j++) //steal 1024 pages
    80000220:	377d                	addiw	a4,a4,-1
    80000222:	ff65                	bnez	a4,8000021a <kalloc+0xb0>
        if(temp->next)
    80000224:	86be                	mv	a3,a5
      kmem[num].freelist = kmem[i].freelist;
    80000226:	00008717          	auipc	a4,0x8
    8000022a:	7ea70713          	addi	a4,a4,2026 # 80008a10 <kmem>
    8000022e:	00249793          	slli	a5,s1,0x2
    80000232:	97a6                	add	a5,a5,s1
    80000234:	078e                	slli	a5,a5,0x3
    80000236:	97ba                	add	a5,a5,a4
    80000238:	f390                	sd	a2,32(a5)
      kmem[i].freelist = temp->next;
    8000023a:	6290                	ld	a2,0(a3)
    8000023c:	00299793          	slli	a5,s3,0x2
    80000240:	99be                	add	s3,s3,a5
    80000242:	098e                	slli	s3,s3,0x3
    80000244:	99ba                	add	s3,s3,a4
    80000246:	02c9b023          	sd	a2,32(s3)
      temp->next = 0;
    8000024a:	0006b023          	sd	zero,0(a3)
      release(&kmem[i].lock);
    8000024e:	8552                	mv	a0,s4
    80000250:	00006097          	auipc	ra,0x6
    80000254:	646080e7          	jalr	1606(ra) # 80006896 <release>
    r = kmem[num].freelist;
    80000258:	00249793          	slli	a5,s1,0x2
    8000025c:	97a6                	add	a5,a5,s1
    8000025e:	078e                	slli	a5,a5,0x3
    80000260:	00008717          	auipc	a4,0x8
    80000264:	7b070713          	addi	a4,a4,1968 # 80008a10 <kmem>
    80000268:	97ba                	add	a5,a5,a4
    8000026a:	0207b983          	ld	s3,32(a5)
    if(r)
    8000026e:	02098a63          	beqz	s3,800002a2 <kalloc+0x138>
      kmem[num].freelist = r->next;
    80000272:	0009b703          	ld	a4,0(s3)
    80000276:	00249793          	slli	a5,s1,0x2
    8000027a:	94be                	add	s1,s1,a5
    8000027c:	048e                	slli	s1,s1,0x3
    8000027e:	00008797          	auipc	a5,0x8
    80000282:	79278793          	addi	a5,a5,1938 # 80008a10 <kmem>
    80000286:	94be                	add	s1,s1,a5
    80000288:	f098                	sd	a4,32(s1)
    8000028a:	bf2d                	j	800001c4 <kalloc+0x5a>
        release(&kmem[i].lock);
    8000028c:	8556                	mv	a0,s5
    8000028e:	00006097          	auipc	ra,0x6
    80000292:	608080e7          	jalr	1544(ra) # 80006896 <release>
    for(int i = 0;i < NCPU; i++)
    80000296:	2985                	addiw	s3,s3,1
    80000298:	028a8a93          	addi	s5,s5,40
    8000029c:	f76991e3          	bne	s3,s6,800001fe <kalloc+0x94>
    800002a0:	bf65                	j	80000258 <kalloc+0xee>
  release(&kmem[num].lock);
    800002a2:	854a                	mv	a0,s2
    800002a4:	00006097          	auipc	ra,0x6
    800002a8:	5f2080e7          	jalr	1522(ra) # 80006896 <release>
  if(r)
    800002ac:	bf05                	j	800001dc <kalloc+0x72>

00000000800002ae <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002ae:	1141                	addi	sp,sp,-16
    800002b0:	e422                	sd	s0,8(sp)
    800002b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002b4:	ce09                	beqz	a2,800002ce <memset+0x20>
    800002b6:	87aa                	mv	a5,a0
    800002b8:	fff6071b          	addiw	a4,a2,-1
    800002bc:	1702                	slli	a4,a4,0x20
    800002be:	9301                	srli	a4,a4,0x20
    800002c0:	0705                	addi	a4,a4,1
    800002c2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800002c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002c8:	0785                	addi	a5,a5,1
    800002ca:	fee79de3          	bne	a5,a4,800002c4 <memset+0x16>
  }
  return dst;
}
    800002ce:	6422                	ld	s0,8(sp)
    800002d0:	0141                	addi	sp,sp,16
    800002d2:	8082                	ret

00000000800002d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002d4:	1141                	addi	sp,sp,-16
    800002d6:	e422                	sd	s0,8(sp)
    800002d8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002da:	ca05                	beqz	a2,8000030a <memcmp+0x36>
    800002dc:	fff6069b          	addiw	a3,a2,-1
    800002e0:	1682                	slli	a3,a3,0x20
    800002e2:	9281                	srli	a3,a3,0x20
    800002e4:	0685                	addi	a3,a3,1
    800002e6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002e8:	00054783          	lbu	a5,0(a0)
    800002ec:	0005c703          	lbu	a4,0(a1)
    800002f0:	00e79863          	bne	a5,a4,80000300 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002f4:	0505                	addi	a0,a0,1
    800002f6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002f8:	fed518e3          	bne	a0,a3,800002e8 <memcmp+0x14>
  }

  return 0;
    800002fc:	4501                	li	a0,0
    800002fe:	a019                	j	80000304 <memcmp+0x30>
      return *s1 - *s2;
    80000300:	40e7853b          	subw	a0,a5,a4
}
    80000304:	6422                	ld	s0,8(sp)
    80000306:	0141                	addi	sp,sp,16
    80000308:	8082                	ret
  return 0;
    8000030a:	4501                	li	a0,0
    8000030c:	bfe5                	j	80000304 <memcmp+0x30>

000000008000030e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e422                	sd	s0,8(sp)
    80000312:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000314:	ca0d                	beqz	a2,80000346 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000316:	00a5f963          	bgeu	a1,a0,80000328 <memmove+0x1a>
    8000031a:	02061693          	slli	a3,a2,0x20
    8000031e:	9281                	srli	a3,a3,0x20
    80000320:	00d58733          	add	a4,a1,a3
    80000324:	02e56463          	bltu	a0,a4,8000034c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000328:	fff6079b          	addiw	a5,a2,-1
    8000032c:	1782                	slli	a5,a5,0x20
    8000032e:	9381                	srli	a5,a5,0x20
    80000330:	0785                	addi	a5,a5,1
    80000332:	97ae                	add	a5,a5,a1
    80000334:	872a                	mv	a4,a0
      *d++ = *s++;
    80000336:	0585                	addi	a1,a1,1
    80000338:	0705                	addi	a4,a4,1
    8000033a:	fff5c683          	lbu	a3,-1(a1)
    8000033e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000342:	fef59ae3          	bne	a1,a5,80000336 <memmove+0x28>

  return dst;
}
    80000346:	6422                	ld	s0,8(sp)
    80000348:	0141                	addi	sp,sp,16
    8000034a:	8082                	ret
    d += n;
    8000034c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000034e:	fff6079b          	addiw	a5,a2,-1
    80000352:	1782                	slli	a5,a5,0x20
    80000354:	9381                	srli	a5,a5,0x20
    80000356:	fff7c793          	not	a5,a5
    8000035a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000035c:	177d                	addi	a4,a4,-1
    8000035e:	16fd                	addi	a3,a3,-1
    80000360:	00074603          	lbu	a2,0(a4)
    80000364:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000368:	fef71ae3          	bne	a4,a5,8000035c <memmove+0x4e>
    8000036c:	bfe9                	j	80000346 <memmove+0x38>

000000008000036e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000036e:	1141                	addi	sp,sp,-16
    80000370:	e406                	sd	ra,8(sp)
    80000372:	e022                	sd	s0,0(sp)
    80000374:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000376:	00000097          	auipc	ra,0x0
    8000037a:	f98080e7          	jalr	-104(ra) # 8000030e <memmove>
}
    8000037e:	60a2                	ld	ra,8(sp)
    80000380:	6402                	ld	s0,0(sp)
    80000382:	0141                	addi	sp,sp,16
    80000384:	8082                	ret

0000000080000386 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000386:	1141                	addi	sp,sp,-16
    80000388:	e422                	sd	s0,8(sp)
    8000038a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000038c:	ce11                	beqz	a2,800003a8 <strncmp+0x22>
    8000038e:	00054783          	lbu	a5,0(a0)
    80000392:	cf89                	beqz	a5,800003ac <strncmp+0x26>
    80000394:	0005c703          	lbu	a4,0(a1)
    80000398:	00f71a63          	bne	a4,a5,800003ac <strncmp+0x26>
    n--, p++, q++;
    8000039c:	367d                	addiw	a2,a2,-1
    8000039e:	0505                	addi	a0,a0,1
    800003a0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003a2:	f675                	bnez	a2,8000038e <strncmp+0x8>
  if(n == 0)
    return 0;
    800003a4:	4501                	li	a0,0
    800003a6:	a809                	j	800003b8 <strncmp+0x32>
    800003a8:	4501                	li	a0,0
    800003aa:	a039                	j	800003b8 <strncmp+0x32>
  if(n == 0)
    800003ac:	ca09                	beqz	a2,800003be <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003ae:	00054503          	lbu	a0,0(a0)
    800003b2:	0005c783          	lbu	a5,0(a1)
    800003b6:	9d1d                	subw	a0,a0,a5
}
    800003b8:	6422                	ld	s0,8(sp)
    800003ba:	0141                	addi	sp,sp,16
    800003bc:	8082                	ret
    return 0;
    800003be:	4501                	li	a0,0
    800003c0:	bfe5                	j	800003b8 <strncmp+0x32>

00000000800003c2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003c2:	1141                	addi	sp,sp,-16
    800003c4:	e422                	sd	s0,8(sp)
    800003c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003c8:	872a                	mv	a4,a0
    800003ca:	8832                	mv	a6,a2
    800003cc:	367d                	addiw	a2,a2,-1
    800003ce:	01005963          	blez	a6,800003e0 <strncpy+0x1e>
    800003d2:	0705                	addi	a4,a4,1
    800003d4:	0005c783          	lbu	a5,0(a1)
    800003d8:	fef70fa3          	sb	a5,-1(a4)
    800003dc:	0585                	addi	a1,a1,1
    800003de:	f7f5                	bnez	a5,800003ca <strncpy+0x8>
    ;
  while(n-- > 0)
    800003e0:	00c05d63          	blez	a2,800003fa <strncpy+0x38>
    800003e4:	86ba                	mv	a3,a4
    *s++ = 0;
    800003e6:	0685                	addi	a3,a3,1
    800003e8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003ec:	fff6c793          	not	a5,a3
    800003f0:	9fb9                	addw	a5,a5,a4
    800003f2:	010787bb          	addw	a5,a5,a6
    800003f6:	fef048e3          	bgtz	a5,800003e6 <strncpy+0x24>
  return os;
}
    800003fa:	6422                	ld	s0,8(sp)
    800003fc:	0141                	addi	sp,sp,16
    800003fe:	8082                	ret

0000000080000400 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e422                	sd	s0,8(sp)
    80000404:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000406:	02c05363          	blez	a2,8000042c <safestrcpy+0x2c>
    8000040a:	fff6069b          	addiw	a3,a2,-1
    8000040e:	1682                	slli	a3,a3,0x20
    80000410:	9281                	srli	a3,a3,0x20
    80000412:	96ae                	add	a3,a3,a1
    80000414:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000416:	00d58963          	beq	a1,a3,80000428 <safestrcpy+0x28>
    8000041a:	0585                	addi	a1,a1,1
    8000041c:	0785                	addi	a5,a5,1
    8000041e:	fff5c703          	lbu	a4,-1(a1)
    80000422:	fee78fa3          	sb	a4,-1(a5)
    80000426:	fb65                	bnez	a4,80000416 <safestrcpy+0x16>
    ;
  *s = 0;
    80000428:	00078023          	sb	zero,0(a5)
  return os;
}
    8000042c:	6422                	ld	s0,8(sp)
    8000042e:	0141                	addi	sp,sp,16
    80000430:	8082                	ret

0000000080000432 <strlen>:

int
strlen(const char *s)
{
    80000432:	1141                	addi	sp,sp,-16
    80000434:	e422                	sd	s0,8(sp)
    80000436:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000438:	00054783          	lbu	a5,0(a0)
    8000043c:	cf91                	beqz	a5,80000458 <strlen+0x26>
    8000043e:	0505                	addi	a0,a0,1
    80000440:	87aa                	mv	a5,a0
    80000442:	4685                	li	a3,1
    80000444:	9e89                	subw	a3,a3,a0
    80000446:	00f6853b          	addw	a0,a3,a5
    8000044a:	0785                	addi	a5,a5,1
    8000044c:	fff7c703          	lbu	a4,-1(a5)
    80000450:	fb7d                	bnez	a4,80000446 <strlen+0x14>
    ;
  return n;
}
    80000452:	6422                	ld	s0,8(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret
  for(n = 0; s[n]; n++)
    80000458:	4501                	li	a0,0
    8000045a:	bfe5                	j	80000452 <strlen+0x20>

000000008000045c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000045c:	1101                	addi	sp,sp,-32
    8000045e:	ec06                	sd	ra,24(sp)
    80000460:	e822                	sd	s0,16(sp)
    80000462:	e426                	sd	s1,8(sp)
    80000464:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000466:	00001097          	auipc	ra,0x1
    8000046a:	b64080e7          	jalr	-1180(ra) # 80000fca <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    8000046e:	00008497          	auipc	s1,0x8
    80000472:	56248493          	addi	s1,s1,1378 # 800089d0 <started>
  if(cpuid() == 0){
    80000476:	c531                	beqz	a0,800004c2 <main+0x66>
    while(atomic_read4((int *) &started) == 0)
    80000478:	8526                	mv	a0,s1
    8000047a:	00006097          	auipc	ra,0x6
    8000047e:	548080e7          	jalr	1352(ra) # 800069c2 <atomic_read4>
    80000482:	d97d                	beqz	a0,80000478 <main+0x1c>
      ;
    __sync_synchronize();
    80000484:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	b42080e7          	jalr	-1214(ra) # 80000fca <cpuid>
    80000490:	85aa                	mv	a1,a0
    80000492:	00008517          	auipc	a0,0x8
    80000496:	ba650513          	addi	a0,a0,-1114 # 80008038 <etext+0x38>
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	e42080e7          	jalr	-446(ra) # 800062dc <printf>
    kvminithart();    // turn on paging
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	0e0080e7          	jalr	224(ra) # 80000582 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	7e8080e7          	jalr	2024(ra) # 80001c92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004b2:	00005097          	auipc	ra,0x5
    800004b6:	f0e080e7          	jalr	-242(ra) # 800053c0 <plicinithart>
  }

  scheduler();        
    800004ba:	00001097          	auipc	ra,0x1
    800004be:	032080e7          	jalr	50(ra) # 800014ec <scheduler>
    consoleinit();
    800004c2:	00006097          	auipc	ra,0x6
    800004c6:	ce2080e7          	jalr	-798(ra) # 800061a4 <consoleinit>
    statsinit();
    800004ca:	00005097          	auipc	ra,0x5
    800004ce:	64c080e7          	jalr	1612(ra) # 80005b16 <statsinit>
    printfinit();
    800004d2:	00006097          	auipc	ra,0x6
    800004d6:	ff0080e7          	jalr	-16(ra) # 800064c2 <printfinit>
    printf("\n");
    800004da:	00008517          	auipc	a0,0x8
    800004de:	41e50513          	addi	a0,a0,1054 # 800088f8 <digits+0x88>
    800004e2:	00006097          	auipc	ra,0x6
    800004e6:	dfa080e7          	jalr	-518(ra) # 800062dc <printf>
    printf("xv6 kernel is booting\n");
    800004ea:	00008517          	auipc	a0,0x8
    800004ee:	b3650513          	addi	a0,a0,-1226 # 80008020 <etext+0x20>
    800004f2:	00006097          	auipc	ra,0x6
    800004f6:	dea080e7          	jalr	-534(ra) # 800062dc <printf>
    printf("\n");
    800004fa:	00008517          	auipc	a0,0x8
    800004fe:	3fe50513          	addi	a0,a0,1022 # 800088f8 <digits+0x88>
    80000502:	00006097          	auipc	ra,0x6
    80000506:	dda080e7          	jalr	-550(ra) # 800062dc <printf>
    kinit();         // physical page allocator
    8000050a:	00000097          	auipc	ra,0x0
    8000050e:	c04080e7          	jalr	-1020(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    80000512:	00000097          	auipc	ra,0x0
    80000516:	34a080e7          	jalr	842(ra) # 8000085c <kvminit>
    kvminithart();   // turn on paging
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	068080e7          	jalr	104(ra) # 80000582 <kvminithart>
    procinit();      // process table
    80000522:	00001097          	auipc	ra,0x1
    80000526:	9f4080e7          	jalr	-1548(ra) # 80000f16 <procinit>
    trapinit();      // trap vectors
    8000052a:	00001097          	auipc	ra,0x1
    8000052e:	740080e7          	jalr	1856(ra) # 80001c6a <trapinit>
    trapinithart();  // install kernel trap vector
    80000532:	00001097          	auipc	ra,0x1
    80000536:	760080e7          	jalr	1888(ra) # 80001c92 <trapinithart>
    plicinit();      // set up interrupt controller
    8000053a:	00005097          	auipc	ra,0x5
    8000053e:	e70080e7          	jalr	-400(ra) # 800053aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000542:	00005097          	auipc	ra,0x5
    80000546:	e7e080e7          	jalr	-386(ra) # 800053c0 <plicinithart>
    binit();         // buffer cache
    8000054a:	00002097          	auipc	ra,0x2
    8000054e:	e92080e7          	jalr	-366(ra) # 800023dc <binit>
    iinit();         // inode table
    80000552:	00002097          	auipc	ra,0x2
    80000556:	6b6080e7          	jalr	1718(ra) # 80002c08 <iinit>
    fileinit();      // file table
    8000055a:	00003097          	auipc	ra,0x3
    8000055e:	668080e7          	jalr	1640(ra) # 80003bc2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000562:	00005097          	auipc	ra,0x5
    80000566:	f66080e7          	jalr	-154(ra) # 800054c8 <virtio_disk_init>
    userinit();      // first user process
    8000056a:	00001097          	auipc	ra,0x1
    8000056e:	d68080e7          	jalr	-664(ra) # 800012d2 <userinit>
    __sync_synchronize();
    80000572:	0ff0000f          	fence
    started = 1;
    80000576:	4785                	li	a5,1
    80000578:	00008717          	auipc	a4,0x8
    8000057c:	44f72c23          	sw	a5,1112(a4) # 800089d0 <started>
    80000580:	bf2d                	j	800004ba <main+0x5e>

0000000080000582 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000582:	1141                	addi	sp,sp,-16
    80000584:	e422                	sd	s0,8(sp)
    80000586:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000588:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000058c:	00008797          	auipc	a5,0x8
    80000590:	44c7b783          	ld	a5,1100(a5) # 800089d8 <kernel_pagetable>
    80000594:	83b1                	srli	a5,a5,0xc
    80000596:	577d                	li	a4,-1
    80000598:	177e                	slli	a4,a4,0x3f
    8000059a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000059c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800005a0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800005a4:	6422                	ld	s0,8(sp)
    800005a6:	0141                	addi	sp,sp,16
    800005a8:	8082                	ret

00000000800005aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005aa:	7139                	addi	sp,sp,-64
    800005ac:	fc06                	sd	ra,56(sp)
    800005ae:	f822                	sd	s0,48(sp)
    800005b0:	f426                	sd	s1,40(sp)
    800005b2:	f04a                	sd	s2,32(sp)
    800005b4:	ec4e                	sd	s3,24(sp)
    800005b6:	e852                	sd	s4,16(sp)
    800005b8:	e456                	sd	s5,8(sp)
    800005ba:	e05a                	sd	s6,0(sp)
    800005bc:	0080                	addi	s0,sp,64
    800005be:	84aa                	mv	s1,a0
    800005c0:	89ae                	mv	s3,a1
    800005c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005c4:	57fd                	li	a5,-1
    800005c6:	83e9                	srli	a5,a5,0x1a
    800005c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005cc:	04b7f263          	bgeu	a5,a1,80000610 <walk+0x66>
    panic("walk");
    800005d0:	00008517          	auipc	a0,0x8
    800005d4:	a8050513          	addi	a0,a0,-1408 # 80008050 <etext+0x50>
    800005d8:	00006097          	auipc	ra,0x6
    800005dc:	cba080e7          	jalr	-838(ra) # 80006292 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005e0:	060a8663          	beqz	s5,8000064c <walk+0xa2>
    800005e4:	00000097          	auipc	ra,0x0
    800005e8:	b86080e7          	jalr	-1146(ra) # 8000016a <kalloc>
    800005ec:	84aa                	mv	s1,a0
    800005ee:	c529                	beqz	a0,80000638 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005f0:	6605                	lui	a2,0x1
    800005f2:	4581                	li	a1,0
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	cba080e7          	jalr	-838(ra) # 800002ae <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005fc:	00c4d793          	srli	a5,s1,0xc
    80000600:	07aa                	slli	a5,a5,0xa
    80000602:	0017e793          	ori	a5,a5,1
    80000606:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000060a:	3a5d                	addiw	s4,s4,-9
    8000060c:	036a0063          	beq	s4,s6,8000062c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000610:	0149d933          	srl	s2,s3,s4
    80000614:	1ff97913          	andi	s2,s2,511
    80000618:	090e                	slli	s2,s2,0x3
    8000061a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000061c:	00093483          	ld	s1,0(s2)
    80000620:	0014f793          	andi	a5,s1,1
    80000624:	dfd5                	beqz	a5,800005e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000626:	80a9                	srli	s1,s1,0xa
    80000628:	04b2                	slli	s1,s1,0xc
    8000062a:	b7c5                	j	8000060a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000062c:	00c9d513          	srli	a0,s3,0xc
    80000630:	1ff57513          	andi	a0,a0,511
    80000634:	050e                	slli	a0,a0,0x3
    80000636:	9526                	add	a0,a0,s1
}
    80000638:	70e2                	ld	ra,56(sp)
    8000063a:	7442                	ld	s0,48(sp)
    8000063c:	74a2                	ld	s1,40(sp)
    8000063e:	7902                	ld	s2,32(sp)
    80000640:	69e2                	ld	s3,24(sp)
    80000642:	6a42                	ld	s4,16(sp)
    80000644:	6aa2                	ld	s5,8(sp)
    80000646:	6b02                	ld	s6,0(sp)
    80000648:	6121                	addi	sp,sp,64
    8000064a:	8082                	ret
        return 0;
    8000064c:	4501                	li	a0,0
    8000064e:	b7ed                	j	80000638 <walk+0x8e>

0000000080000650 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000650:	57fd                	li	a5,-1
    80000652:	83e9                	srli	a5,a5,0x1a
    80000654:	00b7f463          	bgeu	a5,a1,8000065c <walkaddr+0xc>
    return 0;
    80000658:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000065a:	8082                	ret
{
    8000065c:	1141                	addi	sp,sp,-16
    8000065e:	e406                	sd	ra,8(sp)
    80000660:	e022                	sd	s0,0(sp)
    80000662:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000664:	4601                	li	a2,0
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	f44080e7          	jalr	-188(ra) # 800005aa <walk>
  if(pte == 0)
    8000066e:	c105                	beqz	a0,8000068e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000670:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000672:	0117f693          	andi	a3,a5,17
    80000676:	4745                	li	a4,17
    return 0;
    80000678:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000067a:	00e68663          	beq	a3,a4,80000686 <walkaddr+0x36>
}
    8000067e:	60a2                	ld	ra,8(sp)
    80000680:	6402                	ld	s0,0(sp)
    80000682:	0141                	addi	sp,sp,16
    80000684:	8082                	ret
  pa = PTE2PA(*pte);
    80000686:	00a7d513          	srli	a0,a5,0xa
    8000068a:	0532                	slli	a0,a0,0xc
  return pa;
    8000068c:	bfcd                	j	8000067e <walkaddr+0x2e>
    return 0;
    8000068e:	4501                	li	a0,0
    80000690:	b7fd                	j	8000067e <walkaddr+0x2e>

0000000080000692 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000692:	715d                	addi	sp,sp,-80
    80000694:	e486                	sd	ra,72(sp)
    80000696:	e0a2                	sd	s0,64(sp)
    80000698:	fc26                	sd	s1,56(sp)
    8000069a:	f84a                	sd	s2,48(sp)
    8000069c:	f44e                	sd	s3,40(sp)
    8000069e:	f052                	sd	s4,32(sp)
    800006a0:	ec56                	sd	s5,24(sp)
    800006a2:	e85a                	sd	s6,16(sp)
    800006a4:	e45e                	sd	s7,8(sp)
    800006a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800006a8:	03459793          	slli	a5,a1,0x34
    800006ac:	e385                	bnez	a5,800006cc <mappages+0x3a>
    800006ae:	8aaa                	mv	s5,a0
    800006b0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800006b2:	03461793          	slli	a5,a2,0x34
    800006b6:	e39d                	bnez	a5,800006dc <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    800006b8:	ca15                	beqz	a2,800006ec <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800006ba:	79fd                	lui	s3,0xfffff
    800006bc:	964e                	add	a2,a2,s3
    800006be:	00b609b3          	add	s3,a2,a1
  a = va;
    800006c2:	892e                	mv	s2,a1
    800006c4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006c8:	6b85                	lui	s7,0x1
    800006ca:	a091                	j	8000070e <mappages+0x7c>
    panic("mappages: va not aligned");
    800006cc:	00008517          	auipc	a0,0x8
    800006d0:	98c50513          	addi	a0,a0,-1652 # 80008058 <etext+0x58>
    800006d4:	00006097          	auipc	ra,0x6
    800006d8:	bbe080e7          	jalr	-1090(ra) # 80006292 <panic>
    panic("mappages: size not aligned");
    800006dc:	00008517          	auipc	a0,0x8
    800006e0:	99c50513          	addi	a0,a0,-1636 # 80008078 <etext+0x78>
    800006e4:	00006097          	auipc	ra,0x6
    800006e8:	bae080e7          	jalr	-1106(ra) # 80006292 <panic>
    panic("mappages: size");
    800006ec:	00008517          	auipc	a0,0x8
    800006f0:	9ac50513          	addi	a0,a0,-1620 # 80008098 <etext+0x98>
    800006f4:	00006097          	auipc	ra,0x6
    800006f8:	b9e080e7          	jalr	-1122(ra) # 80006292 <panic>
      panic("mappages: remap");
    800006fc:	00008517          	auipc	a0,0x8
    80000700:	9ac50513          	addi	a0,a0,-1620 # 800080a8 <etext+0xa8>
    80000704:	00006097          	auipc	ra,0x6
    80000708:	b8e080e7          	jalr	-1138(ra) # 80006292 <panic>
    a += PGSIZE;
    8000070c:	995e                	add	s2,s2,s7
  for(;;){
    8000070e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000712:	4605                	li	a2,1
    80000714:	85ca                	mv	a1,s2
    80000716:	8556                	mv	a0,s5
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	e92080e7          	jalr	-366(ra) # 800005aa <walk>
    80000720:	cd19                	beqz	a0,8000073e <mappages+0xac>
    if(*pte & PTE_V)
    80000722:	611c                	ld	a5,0(a0)
    80000724:	8b85                	andi	a5,a5,1
    80000726:	fbf9                	bnez	a5,800006fc <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000728:	80b1                	srli	s1,s1,0xc
    8000072a:	04aa                	slli	s1,s1,0xa
    8000072c:	0164e4b3          	or	s1,s1,s6
    80000730:	0014e493          	ori	s1,s1,1
    80000734:	e104                	sd	s1,0(a0)
    if(a == last)
    80000736:	fd391be3          	bne	s2,s3,8000070c <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    8000073a:	4501                	li	a0,0
    8000073c:	a011                	j	80000740 <mappages+0xae>
      return -1;
    8000073e:	557d                	li	a0,-1
}
    80000740:	60a6                	ld	ra,72(sp)
    80000742:	6406                	ld	s0,64(sp)
    80000744:	74e2                	ld	s1,56(sp)
    80000746:	7942                	ld	s2,48(sp)
    80000748:	79a2                	ld	s3,40(sp)
    8000074a:	7a02                	ld	s4,32(sp)
    8000074c:	6ae2                	ld	s5,24(sp)
    8000074e:	6b42                	ld	s6,16(sp)
    80000750:	6ba2                	ld	s7,8(sp)
    80000752:	6161                	addi	sp,sp,80
    80000754:	8082                	ret

0000000080000756 <kvmmap>:
{
    80000756:	1141                	addi	sp,sp,-16
    80000758:	e406                	sd	ra,8(sp)
    8000075a:	e022                	sd	s0,0(sp)
    8000075c:	0800                	addi	s0,sp,16
    8000075e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000760:	86b2                	mv	a3,a2
    80000762:	863e                	mv	a2,a5
    80000764:	00000097          	auipc	ra,0x0
    80000768:	f2e080e7          	jalr	-210(ra) # 80000692 <mappages>
    8000076c:	e509                	bnez	a0,80000776 <kvmmap+0x20>
}
    8000076e:	60a2                	ld	ra,8(sp)
    80000770:	6402                	ld	s0,0(sp)
    80000772:	0141                	addi	sp,sp,16
    80000774:	8082                	ret
    panic("kvmmap");
    80000776:	00008517          	auipc	a0,0x8
    8000077a:	94250513          	addi	a0,a0,-1726 # 800080b8 <etext+0xb8>
    8000077e:	00006097          	auipc	ra,0x6
    80000782:	b14080e7          	jalr	-1260(ra) # 80006292 <panic>

0000000080000786 <kvmmake>:
{
    80000786:	1101                	addi	sp,sp,-32
    80000788:	ec06                	sd	ra,24(sp)
    8000078a:	e822                	sd	s0,16(sp)
    8000078c:	e426                	sd	s1,8(sp)
    8000078e:	e04a                	sd	s2,0(sp)
    80000790:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000792:	00000097          	auipc	ra,0x0
    80000796:	9d8080e7          	jalr	-1576(ra) # 8000016a <kalloc>
    8000079a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000079c:	6605                	lui	a2,0x1
    8000079e:	4581                	li	a1,0
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	b0e080e7          	jalr	-1266(ra) # 800002ae <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007a8:	4719                	li	a4,6
    800007aa:	6685                	lui	a3,0x1
    800007ac:	10000637          	lui	a2,0x10000
    800007b0:	100005b7          	lui	a1,0x10000
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	fa0080e7          	jalr	-96(ra) # 80000756 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007be:	4719                	li	a4,6
    800007c0:	6685                	lui	a3,0x1
    800007c2:	10001637          	lui	a2,0x10001
    800007c6:	100015b7          	lui	a1,0x10001
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	f8a080e7          	jalr	-118(ra) # 80000756 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007d4:	4719                	li	a4,6
    800007d6:	004006b7          	lui	a3,0x400
    800007da:	0c000637          	lui	a2,0xc000
    800007de:	0c0005b7          	lui	a1,0xc000
    800007e2:	8526                	mv	a0,s1
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	f72080e7          	jalr	-142(ra) # 80000756 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007ec:	00008917          	auipc	s2,0x8
    800007f0:	81490913          	addi	s2,s2,-2028 # 80008000 <etext>
    800007f4:	4729                	li	a4,10
    800007f6:	80008697          	auipc	a3,0x80008
    800007fa:	80a68693          	addi	a3,a3,-2038 # 8000 <_entry-0x7fff8000>
    800007fe:	4605                	li	a2,1
    80000800:	067e                	slli	a2,a2,0x1f
    80000802:	85b2                	mv	a1,a2
    80000804:	8526                	mv	a0,s1
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	f50080e7          	jalr	-176(ra) # 80000756 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000080e:	4719                	li	a4,6
    80000810:	46c5                	li	a3,17
    80000812:	06ee                	slli	a3,a3,0x1b
    80000814:	412686b3          	sub	a3,a3,s2
    80000818:	864a                	mv	a2,s2
    8000081a:	85ca                	mv	a1,s2
    8000081c:	8526                	mv	a0,s1
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	f38080e7          	jalr	-200(ra) # 80000756 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000826:	4729                	li	a4,10
    80000828:	6685                	lui	a3,0x1
    8000082a:	00006617          	auipc	a2,0x6
    8000082e:	7d660613          	addi	a2,a2,2006 # 80007000 <_trampoline>
    80000832:	040005b7          	lui	a1,0x4000
    80000836:	15fd                	addi	a1,a1,-1
    80000838:	05b2                	slli	a1,a1,0xc
    8000083a:	8526                	mv	a0,s1
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	f1a080e7          	jalr	-230(ra) # 80000756 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000844:	8526                	mv	a0,s1
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	63a080e7          	jalr	1594(ra) # 80000e80 <proc_mapstacks>
}
    8000084e:	8526                	mv	a0,s1
    80000850:	60e2                	ld	ra,24(sp)
    80000852:	6442                	ld	s0,16(sp)
    80000854:	64a2                	ld	s1,8(sp)
    80000856:	6902                	ld	s2,0(sp)
    80000858:	6105                	addi	sp,sp,32
    8000085a:	8082                	ret

000000008000085c <kvminit>:
{
    8000085c:	1141                	addi	sp,sp,-16
    8000085e:	e406                	sd	ra,8(sp)
    80000860:	e022                	sd	s0,0(sp)
    80000862:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000864:	00000097          	auipc	ra,0x0
    80000868:	f22080e7          	jalr	-222(ra) # 80000786 <kvmmake>
    8000086c:	00008797          	auipc	a5,0x8
    80000870:	16a7b623          	sd	a0,364(a5) # 800089d8 <kernel_pagetable>
}
    80000874:	60a2                	ld	ra,8(sp)
    80000876:	6402                	ld	s0,0(sp)
    80000878:	0141                	addi	sp,sp,16
    8000087a:	8082                	ret

000000008000087c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000087c:	715d                	addi	sp,sp,-80
    8000087e:	e486                	sd	ra,72(sp)
    80000880:	e0a2                	sd	s0,64(sp)
    80000882:	fc26                	sd	s1,56(sp)
    80000884:	f84a                	sd	s2,48(sp)
    80000886:	f44e                	sd	s3,40(sp)
    80000888:	f052                	sd	s4,32(sp)
    8000088a:	ec56                	sd	s5,24(sp)
    8000088c:	e85a                	sd	s6,16(sp)
    8000088e:	e45e                	sd	s7,8(sp)
    80000890:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000892:	03459793          	slli	a5,a1,0x34
    80000896:	e795                	bnez	a5,800008c2 <uvmunmap+0x46>
    80000898:	8a2a                	mv	s4,a0
    8000089a:	892e                	mv	s2,a1
    8000089c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000089e:	0632                	slli	a2,a2,0xc
    800008a0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008a4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a6:	6b05                	lui	s6,0x1
    800008a8:	0735e863          	bltu	a1,s3,80000918 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008ac:	60a6                	ld	ra,72(sp)
    800008ae:	6406                	ld	s0,64(sp)
    800008b0:	74e2                	ld	s1,56(sp)
    800008b2:	7942                	ld	s2,48(sp)
    800008b4:	79a2                	ld	s3,40(sp)
    800008b6:	7a02                	ld	s4,32(sp)
    800008b8:	6ae2                	ld	s5,24(sp)
    800008ba:	6b42                	ld	s6,16(sp)
    800008bc:	6ba2                	ld	s7,8(sp)
    800008be:	6161                	addi	sp,sp,80
    800008c0:	8082                	ret
    panic("uvmunmap: not aligned");
    800008c2:	00007517          	auipc	a0,0x7
    800008c6:	7fe50513          	addi	a0,a0,2046 # 800080c0 <etext+0xc0>
    800008ca:	00006097          	auipc	ra,0x6
    800008ce:	9c8080e7          	jalr	-1592(ra) # 80006292 <panic>
      panic("uvmunmap: walk");
    800008d2:	00008517          	auipc	a0,0x8
    800008d6:	80650513          	addi	a0,a0,-2042 # 800080d8 <etext+0xd8>
    800008da:	00006097          	auipc	ra,0x6
    800008de:	9b8080e7          	jalr	-1608(ra) # 80006292 <panic>
      panic("uvmunmap: not mapped");
    800008e2:	00008517          	auipc	a0,0x8
    800008e6:	80650513          	addi	a0,a0,-2042 # 800080e8 <etext+0xe8>
    800008ea:	00006097          	auipc	ra,0x6
    800008ee:	9a8080e7          	jalr	-1624(ra) # 80006292 <panic>
      panic("uvmunmap: not a leaf");
    800008f2:	00008517          	auipc	a0,0x8
    800008f6:	80e50513          	addi	a0,a0,-2034 # 80008100 <etext+0x100>
    800008fa:	00006097          	auipc	ra,0x6
    800008fe:	998080e7          	jalr	-1640(ra) # 80006292 <panic>
      uint64 pa = PTE2PA(*pte);
    80000902:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000904:	0532                	slli	a0,a0,0xc
    80000906:	fffff097          	auipc	ra,0xfffff
    8000090a:	716080e7          	jalr	1814(ra) # 8000001c <kfree>
    *pte = 0;
    8000090e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000912:	995a                	add	s2,s2,s6
    80000914:	f9397ce3          	bgeu	s2,s3,800008ac <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000918:	4601                	li	a2,0
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8552                	mv	a0,s4
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	c8c080e7          	jalr	-884(ra) # 800005aa <walk>
    80000926:	84aa                	mv	s1,a0
    80000928:	d54d                	beqz	a0,800008d2 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000092a:	6108                	ld	a0,0(a0)
    8000092c:	00157793          	andi	a5,a0,1
    80000930:	dbcd                	beqz	a5,800008e2 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000932:	3ff57793          	andi	a5,a0,1023
    80000936:	fb778ee3          	beq	a5,s7,800008f2 <uvmunmap+0x76>
    if(do_free){
    8000093a:	fc0a8ae3          	beqz	s5,8000090e <uvmunmap+0x92>
    8000093e:	b7d1                	j	80000902 <uvmunmap+0x86>

0000000080000940 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000940:	1101                	addi	sp,sp,-32
    80000942:	ec06                	sd	ra,24(sp)
    80000944:	e822                	sd	s0,16(sp)
    80000946:	e426                	sd	s1,8(sp)
    80000948:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	820080e7          	jalr	-2016(ra) # 8000016a <kalloc>
    80000952:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000954:	c519                	beqz	a0,80000962 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000956:	6605                	lui	a2,0x1
    80000958:	4581                	li	a1,0
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	954080e7          	jalr	-1708(ra) # 800002ae <memset>
  return pagetable;
}
    80000962:	8526                	mv	a0,s1
    80000964:	60e2                	ld	ra,24(sp)
    80000966:	6442                	ld	s0,16(sp)
    80000968:	64a2                	ld	s1,8(sp)
    8000096a:	6105                	addi	sp,sp,32
    8000096c:	8082                	ret

000000008000096e <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000096e:	7179                	addi	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000097e:	6785                	lui	a5,0x1
    80000980:	04f67863          	bgeu	a2,a5,800009d0 <uvmfirst+0x62>
    80000984:	8a2a                	mv	s4,a0
    80000986:	89ae                	mv	s3,a1
    80000988:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000098a:	fffff097          	auipc	ra,0xfffff
    8000098e:	7e0080e7          	jalr	2016(ra) # 8000016a <kalloc>
    80000992:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000994:	6605                	lui	a2,0x1
    80000996:	4581                	li	a1,0
    80000998:	00000097          	auipc	ra,0x0
    8000099c:	916080e7          	jalr	-1770(ra) # 800002ae <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009a0:	4779                	li	a4,30
    800009a2:	86ca                	mv	a3,s2
    800009a4:	6605                	lui	a2,0x1
    800009a6:	4581                	li	a1,0
    800009a8:	8552                	mv	a0,s4
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	ce8080e7          	jalr	-792(ra) # 80000692 <mappages>
  memmove(mem, src, sz);
    800009b2:	8626                	mv	a2,s1
    800009b4:	85ce                	mv	a1,s3
    800009b6:	854a                	mv	a0,s2
    800009b8:	00000097          	auipc	ra,0x0
    800009bc:	956080e7          	jalr	-1706(ra) # 8000030e <memmove>
}
    800009c0:	70a2                	ld	ra,40(sp)
    800009c2:	7402                	ld	s0,32(sp)
    800009c4:	64e2                	ld	s1,24(sp)
    800009c6:	6942                	ld	s2,16(sp)
    800009c8:	69a2                	ld	s3,8(sp)
    800009ca:	6a02                	ld	s4,0(sp)
    800009cc:	6145                	addi	sp,sp,48
    800009ce:	8082                	ret
    panic("uvmfirst: more than a page");
    800009d0:	00007517          	auipc	a0,0x7
    800009d4:	74850513          	addi	a0,a0,1864 # 80008118 <etext+0x118>
    800009d8:	00006097          	auipc	ra,0x6
    800009dc:	8ba080e7          	jalr	-1862(ra) # 80006292 <panic>

00000000800009e0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009e0:	1101                	addi	sp,sp,-32
    800009e2:	ec06                	sd	ra,24(sp)
    800009e4:	e822                	sd	s0,16(sp)
    800009e6:	e426                	sd	s1,8(sp)
    800009e8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009ea:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009ec:	00b67d63          	bgeu	a2,a1,80000a06 <uvmdealloc+0x26>
    800009f0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009f2:	6785                	lui	a5,0x1
    800009f4:	17fd                	addi	a5,a5,-1
    800009f6:	00f60733          	add	a4,a2,a5
    800009fa:	767d                	lui	a2,0xfffff
    800009fc:	8f71                	and	a4,a4,a2
    800009fe:	97ae                	add	a5,a5,a1
    80000a00:	8ff1                	and	a5,a5,a2
    80000a02:	00f76863          	bltu	a4,a5,80000a12 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a06:	8526                	mv	a0,s1
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a12:	8f99                	sub	a5,a5,a4
    80000a14:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a16:	4685                	li	a3,1
    80000a18:	0007861b          	sext.w	a2,a5
    80000a1c:	85ba                	mv	a1,a4
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	e5e080e7          	jalr	-418(ra) # 8000087c <uvmunmap>
    80000a26:	b7c5                	j	80000a06 <uvmdealloc+0x26>

0000000080000a28 <uvmalloc>:
  if(newsz < oldsz)
    80000a28:	0ab66563          	bltu	a2,a1,80000ad2 <uvmalloc+0xaa>
{
    80000a2c:	7139                	addi	sp,sp,-64
    80000a2e:	fc06                	sd	ra,56(sp)
    80000a30:	f822                	sd	s0,48(sp)
    80000a32:	f426                	sd	s1,40(sp)
    80000a34:	f04a                	sd	s2,32(sp)
    80000a36:	ec4e                	sd	s3,24(sp)
    80000a38:	e852                	sd	s4,16(sp)
    80000a3a:	e456                	sd	s5,8(sp)
    80000a3c:	e05a                	sd	s6,0(sp)
    80000a3e:	0080                	addi	s0,sp,64
    80000a40:	8aaa                	mv	s5,a0
    80000a42:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a44:	6985                	lui	s3,0x1
    80000a46:	19fd                	addi	s3,s3,-1
    80000a48:	95ce                	add	a1,a1,s3
    80000a4a:	79fd                	lui	s3,0xfffff
    80000a4c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a50:	08c9f363          	bgeu	s3,a2,80000ad6 <uvmalloc+0xae>
    80000a54:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a56:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	710080e7          	jalr	1808(ra) # 8000016a <kalloc>
    80000a62:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a64:	c51d                	beqz	a0,80000a92 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000a66:	6605                	lui	a2,0x1
    80000a68:	4581                	li	a1,0
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	844080e7          	jalr	-1980(ra) # 800002ae <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a72:	875a                	mv	a4,s6
    80000a74:	86a6                	mv	a3,s1
    80000a76:	6605                	lui	a2,0x1
    80000a78:	85ca                	mv	a1,s2
    80000a7a:	8556                	mv	a0,s5
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	c16080e7          	jalr	-1002(ra) # 80000692 <mappages>
    80000a84:	e90d                	bnez	a0,80000ab6 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a86:	6785                	lui	a5,0x1
    80000a88:	993e                	add	s2,s2,a5
    80000a8a:	fd4968e3          	bltu	s2,s4,80000a5a <uvmalloc+0x32>
  return newsz;
    80000a8e:	8552                	mv	a0,s4
    80000a90:	a809                	j	80000aa2 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a92:	864e                	mv	a2,s3
    80000a94:	85ca                	mv	a1,s2
    80000a96:	8556                	mv	a0,s5
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	f48080e7          	jalr	-184(ra) # 800009e0 <uvmdealloc>
      return 0;
    80000aa0:	4501                	li	a0,0
}
    80000aa2:	70e2                	ld	ra,56(sp)
    80000aa4:	7442                	ld	s0,48(sp)
    80000aa6:	74a2                	ld	s1,40(sp)
    80000aa8:	7902                	ld	s2,32(sp)
    80000aaa:	69e2                	ld	s3,24(sp)
    80000aac:	6a42                	ld	s4,16(sp)
    80000aae:	6aa2                	ld	s5,8(sp)
    80000ab0:	6b02                	ld	s6,0(sp)
    80000ab2:	6121                	addi	sp,sp,64
    80000ab4:	8082                	ret
      kfree(mem);
    80000ab6:	8526                	mv	a0,s1
    80000ab8:	fffff097          	auipc	ra,0xfffff
    80000abc:	564080e7          	jalr	1380(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000ac0:	864e                	mv	a2,s3
    80000ac2:	85ca                	mv	a1,s2
    80000ac4:	8556                	mv	a0,s5
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f1a080e7          	jalr	-230(ra) # 800009e0 <uvmdealloc>
      return 0;
    80000ace:	4501                	li	a0,0
    80000ad0:	bfc9                	j	80000aa2 <uvmalloc+0x7a>
    return oldsz;
    80000ad2:	852e                	mv	a0,a1
}
    80000ad4:	8082                	ret
  return newsz;
    80000ad6:	8532                	mv	a0,a2
    80000ad8:	b7e9                	j	80000aa2 <uvmalloc+0x7a>

0000000080000ada <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000ada:	7179                	addi	sp,sp,-48
    80000adc:	f406                	sd	ra,40(sp)
    80000ade:	f022                	sd	s0,32(sp)
    80000ae0:	ec26                	sd	s1,24(sp)
    80000ae2:	e84a                	sd	s2,16(sp)
    80000ae4:	e44e                	sd	s3,8(sp)
    80000ae6:	e052                	sd	s4,0(sp)
    80000ae8:	1800                	addi	s0,sp,48
    80000aea:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000aec:	84aa                	mv	s1,a0
    80000aee:	6905                	lui	s2,0x1
    80000af0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000af2:	4985                	li	s3,1
    80000af4:	a821                	j	80000b0c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000af6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000af8:	0532                	slli	a0,a0,0xc
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	fe0080e7          	jalr	-32(ra) # 80000ada <freewalk>
      pagetable[i] = 0;
    80000b02:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b06:	04a1                	addi	s1,s1,8
    80000b08:	03248163          	beq	s1,s2,80000b2a <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b0c:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b0e:	00f57793          	andi	a5,a0,15
    80000b12:	ff3782e3          	beq	a5,s3,80000af6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b16:	8905                	andi	a0,a0,1
    80000b18:	d57d                	beqz	a0,80000b06 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000b1a:	00007517          	auipc	a0,0x7
    80000b1e:	61e50513          	addi	a0,a0,1566 # 80008138 <etext+0x138>
    80000b22:	00005097          	auipc	ra,0x5
    80000b26:	770080e7          	jalr	1904(ra) # 80006292 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b2a:	8552                	mv	a0,s4
    80000b2c:	fffff097          	auipc	ra,0xfffff
    80000b30:	4f0080e7          	jalr	1264(ra) # 8000001c <kfree>
}
    80000b34:	70a2                	ld	ra,40(sp)
    80000b36:	7402                	ld	s0,32(sp)
    80000b38:	64e2                	ld	s1,24(sp)
    80000b3a:	6942                	ld	s2,16(sp)
    80000b3c:	69a2                	ld	s3,8(sp)
    80000b3e:	6a02                	ld	s4,0(sp)
    80000b40:	6145                	addi	sp,sp,48
    80000b42:	8082                	ret

0000000080000b44 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
    80000b4e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b50:	e999                	bnez	a1,80000b66 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b52:	8526                	mv	a0,s1
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	f86080e7          	jalr	-122(ra) # 80000ada <freewalk>
}
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b66:	6605                	lui	a2,0x1
    80000b68:	167d                	addi	a2,a2,-1
    80000b6a:	962e                	add	a2,a2,a1
    80000b6c:	4685                	li	a3,1
    80000b6e:	8231                	srli	a2,a2,0xc
    80000b70:	4581                	li	a1,0
    80000b72:	00000097          	auipc	ra,0x0
    80000b76:	d0a080e7          	jalr	-758(ra) # 8000087c <uvmunmap>
    80000b7a:	bfe1                	j	80000b52 <uvmfree+0xe>

0000000080000b7c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b7c:	c679                	beqz	a2,80000c4a <uvmcopy+0xce>
{
    80000b7e:	715d                	addi	sp,sp,-80
    80000b80:	e486                	sd	ra,72(sp)
    80000b82:	e0a2                	sd	s0,64(sp)
    80000b84:	fc26                	sd	s1,56(sp)
    80000b86:	f84a                	sd	s2,48(sp)
    80000b88:	f44e                	sd	s3,40(sp)
    80000b8a:	f052                	sd	s4,32(sp)
    80000b8c:	ec56                	sd	s5,24(sp)
    80000b8e:	e85a                	sd	s6,16(sp)
    80000b90:	e45e                	sd	s7,8(sp)
    80000b92:	0880                	addi	s0,sp,80
    80000b94:	8b2a                	mv	s6,a0
    80000b96:	8aae                	mv	s5,a1
    80000b98:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b9a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b9c:	4601                	li	a2,0
    80000b9e:	85ce                	mv	a1,s3
    80000ba0:	855a                	mv	a0,s6
    80000ba2:	00000097          	auipc	ra,0x0
    80000ba6:	a08080e7          	jalr	-1528(ra) # 800005aa <walk>
    80000baa:	c531                	beqz	a0,80000bf6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000bac:	6118                	ld	a4,0(a0)
    80000bae:	00177793          	andi	a5,a4,1
    80000bb2:	cbb1                	beqz	a5,80000c06 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000bb4:	00a75593          	srli	a1,a4,0xa
    80000bb8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000bbc:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000bc0:	fffff097          	auipc	ra,0xfffff
    80000bc4:	5aa080e7          	jalr	1450(ra) # 8000016a <kalloc>
    80000bc8:	892a                	mv	s2,a0
    80000bca:	c939                	beqz	a0,80000c20 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000bcc:	6605                	lui	a2,0x1
    80000bce:	85de                	mv	a1,s7
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	73e080e7          	jalr	1854(ra) # 8000030e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000bd8:	8726                	mv	a4,s1
    80000bda:	86ca                	mv	a3,s2
    80000bdc:	6605                	lui	a2,0x1
    80000bde:	85ce                	mv	a1,s3
    80000be0:	8556                	mv	a0,s5
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	ab0080e7          	jalr	-1360(ra) # 80000692 <mappages>
    80000bea:	e515                	bnez	a0,80000c16 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000bec:	6785                	lui	a5,0x1
    80000bee:	99be                	add	s3,s3,a5
    80000bf0:	fb49e6e3          	bltu	s3,s4,80000b9c <uvmcopy+0x20>
    80000bf4:	a081                	j	80000c34 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000bf6:	00007517          	auipc	a0,0x7
    80000bfa:	55250513          	addi	a0,a0,1362 # 80008148 <etext+0x148>
    80000bfe:	00005097          	auipc	ra,0x5
    80000c02:	694080e7          	jalr	1684(ra) # 80006292 <panic>
      panic("uvmcopy: page not present");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	56250513          	addi	a0,a0,1378 # 80008168 <etext+0x168>
    80000c0e:	00005097          	auipc	ra,0x5
    80000c12:	684080e7          	jalr	1668(ra) # 80006292 <panic>
      kfree(mem);
    80000c16:	854a                	mv	a0,s2
    80000c18:	fffff097          	auipc	ra,0xfffff
    80000c1c:	404080e7          	jalr	1028(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c20:	4685                	li	a3,1
    80000c22:	00c9d613          	srli	a2,s3,0xc
    80000c26:	4581                	li	a1,0
    80000c28:	8556                	mv	a0,s5
    80000c2a:	00000097          	auipc	ra,0x0
    80000c2e:	c52080e7          	jalr	-942(ra) # 8000087c <uvmunmap>
  return -1;
    80000c32:	557d                	li	a0,-1
}
    80000c34:	60a6                	ld	ra,72(sp)
    80000c36:	6406                	ld	s0,64(sp)
    80000c38:	74e2                	ld	s1,56(sp)
    80000c3a:	7942                	ld	s2,48(sp)
    80000c3c:	79a2                	ld	s3,40(sp)
    80000c3e:	7a02                	ld	s4,32(sp)
    80000c40:	6ae2                	ld	s5,24(sp)
    80000c42:	6b42                	ld	s6,16(sp)
    80000c44:	6ba2                	ld	s7,8(sp)
    80000c46:	6161                	addi	sp,sp,80
    80000c48:	8082                	ret
  return 0;
    80000c4a:	4501                	li	a0,0
}
    80000c4c:	8082                	ret

0000000080000c4e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c4e:	1141                	addi	sp,sp,-16
    80000c50:	e406                	sd	ra,8(sp)
    80000c52:	e022                	sd	s0,0(sp)
    80000c54:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c56:	4601                	li	a2,0
    80000c58:	00000097          	auipc	ra,0x0
    80000c5c:	952080e7          	jalr	-1710(ra) # 800005aa <walk>
  if(pte == 0)
    80000c60:	c901                	beqz	a0,80000c70 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c62:	611c                	ld	a5,0(a0)
    80000c64:	9bbd                	andi	a5,a5,-17
    80000c66:	e11c                	sd	a5,0(a0)
}
    80000c68:	60a2                	ld	ra,8(sp)
    80000c6a:	6402                	ld	s0,0(sp)
    80000c6c:	0141                	addi	sp,sp,16
    80000c6e:	8082                	ret
    panic("uvmclear");
    80000c70:	00007517          	auipc	a0,0x7
    80000c74:	51850513          	addi	a0,a0,1304 # 80008188 <etext+0x188>
    80000c78:	00005097          	auipc	ra,0x5
    80000c7c:	61a080e7          	jalr	1562(ra) # 80006292 <panic>

0000000080000c80 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000c80:	cac9                	beqz	a3,80000d12 <copyout+0x92>
{
    80000c82:	711d                	addi	sp,sp,-96
    80000c84:	ec86                	sd	ra,88(sp)
    80000c86:	e8a2                	sd	s0,80(sp)
    80000c88:	e4a6                	sd	s1,72(sp)
    80000c8a:	e0ca                	sd	s2,64(sp)
    80000c8c:	fc4e                	sd	s3,56(sp)
    80000c8e:	f852                	sd	s4,48(sp)
    80000c90:	f456                	sd	s5,40(sp)
    80000c92:	f05a                	sd	s6,32(sp)
    80000c94:	ec5e                	sd	s7,24(sp)
    80000c96:	e862                	sd	s8,16(sp)
    80000c98:	e466                	sd	s9,8(sp)
    80000c9a:	e06a                	sd	s10,0(sp)
    80000c9c:	1080                	addi	s0,sp,96
    80000c9e:	8baa                	mv	s7,a0
    80000ca0:	8aae                	mv	s5,a1
    80000ca2:	8b32                	mv	s6,a2
    80000ca4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000ca6:	74fd                	lui	s1,0xfffff
    80000ca8:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000caa:	57fd                	li	a5,-1
    80000cac:	83e9                	srli	a5,a5,0x1a
    80000cae:	0697e463          	bltu	a5,s1,80000d16 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000cb2:	4cd5                	li	s9,21
    80000cb4:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000cb6:	8c3e                	mv	s8,a5
    80000cb8:	a035                	j	80000ce4 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000cba:	83a9                	srli	a5,a5,0xa
    80000cbc:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cbe:	409a8533          	sub	a0,s5,s1
    80000cc2:	0009061b          	sext.w	a2,s2
    80000cc6:	85da                	mv	a1,s6
    80000cc8:	953e                	add	a0,a0,a5
    80000cca:	fffff097          	auipc	ra,0xfffff
    80000cce:	644080e7          	jalr	1604(ra) # 8000030e <memmove>

    len -= n;
    80000cd2:	412989b3          	sub	s3,s3,s2
    src += n;
    80000cd6:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000cd8:	02098b63          	beqz	s3,80000d0e <copyout+0x8e>
    if(va0 >= MAXVA)
    80000cdc:	034c6f63          	bltu	s8,s4,80000d1a <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000ce0:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000ce2:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000ce4:	4601                	li	a2,0
    80000ce6:	85a6                	mv	a1,s1
    80000ce8:	855e                	mv	a0,s7
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	8c0080e7          	jalr	-1856(ra) # 800005aa <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000cf2:	c515                	beqz	a0,80000d1e <copyout+0x9e>
    80000cf4:	611c                	ld	a5,0(a0)
    80000cf6:	0157f713          	andi	a4,a5,21
    80000cfa:	05971163          	bne	a4,s9,80000d3c <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000cfe:	01a48a33          	add	s4,s1,s10
    80000d02:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000d06:	fb29fae3          	bgeu	s3,s2,80000cba <copyout+0x3a>
    80000d0a:	894e                	mv	s2,s3
    80000d0c:	b77d                	j	80000cba <copyout+0x3a>
  }
  return 0;
    80000d0e:	4501                	li	a0,0
    80000d10:	a801                	j	80000d20 <copyout+0xa0>
    80000d12:	4501                	li	a0,0
}
    80000d14:	8082                	ret
      return -1;
    80000d16:	557d                	li	a0,-1
    80000d18:	a021                	j	80000d20 <copyout+0xa0>
    80000d1a:	557d                	li	a0,-1
    80000d1c:	a011                	j	80000d20 <copyout+0xa0>
      return -1;
    80000d1e:	557d                	li	a0,-1
}
    80000d20:	60e6                	ld	ra,88(sp)
    80000d22:	6446                	ld	s0,80(sp)
    80000d24:	64a6                	ld	s1,72(sp)
    80000d26:	6906                	ld	s2,64(sp)
    80000d28:	79e2                	ld	s3,56(sp)
    80000d2a:	7a42                	ld	s4,48(sp)
    80000d2c:	7aa2                	ld	s5,40(sp)
    80000d2e:	7b02                	ld	s6,32(sp)
    80000d30:	6be2                	ld	s7,24(sp)
    80000d32:	6c42                	ld	s8,16(sp)
    80000d34:	6ca2                	ld	s9,8(sp)
    80000d36:	6d02                	ld	s10,0(sp)
    80000d38:	6125                	addi	sp,sp,96
    80000d3a:	8082                	ret
      return -1;
    80000d3c:	557d                	li	a0,-1
    80000d3e:	b7cd                	j	80000d20 <copyout+0xa0>

0000000080000d40 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d40:	c6bd                	beqz	a3,80000dae <copyin+0x6e>
{
    80000d42:	715d                	addi	sp,sp,-80
    80000d44:	e486                	sd	ra,72(sp)
    80000d46:	e0a2                	sd	s0,64(sp)
    80000d48:	fc26                	sd	s1,56(sp)
    80000d4a:	f84a                	sd	s2,48(sp)
    80000d4c:	f44e                	sd	s3,40(sp)
    80000d4e:	f052                	sd	s4,32(sp)
    80000d50:	ec56                	sd	s5,24(sp)
    80000d52:	e85a                	sd	s6,16(sp)
    80000d54:	e45e                	sd	s7,8(sp)
    80000d56:	e062                	sd	s8,0(sp)
    80000d58:	0880                	addi	s0,sp,80
    80000d5a:	8b2a                	mv	s6,a0
    80000d5c:	8a2e                	mv	s4,a1
    80000d5e:	8c32                	mv	s8,a2
    80000d60:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d62:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d64:	6a85                	lui	s5,0x1
    80000d66:	a015                	j	80000d8a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d68:	9562                	add	a0,a0,s8
    80000d6a:	0004861b          	sext.w	a2,s1
    80000d6e:	412505b3          	sub	a1,a0,s2
    80000d72:	8552                	mv	a0,s4
    80000d74:	fffff097          	auipc	ra,0xfffff
    80000d78:	59a080e7          	jalr	1434(ra) # 8000030e <memmove>

    len -= n;
    80000d7c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d80:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d82:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d86:	02098263          	beqz	s3,80000daa <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d8a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d8e:	85ca                	mv	a1,s2
    80000d90:	855a                	mv	a0,s6
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	8be080e7          	jalr	-1858(ra) # 80000650 <walkaddr>
    if(pa0 == 0)
    80000d9a:	cd01                	beqz	a0,80000db2 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d9c:	418904b3          	sub	s1,s2,s8
    80000da0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000da2:	fc99f3e3          	bgeu	s3,s1,80000d68 <copyin+0x28>
    80000da6:	84ce                	mv	s1,s3
    80000da8:	b7c1                	j	80000d68 <copyin+0x28>
  }
  return 0;
    80000daa:	4501                	li	a0,0
    80000dac:	a021                	j	80000db4 <copyin+0x74>
    80000dae:	4501                	li	a0,0
}
    80000db0:	8082                	ret
      return -1;
    80000db2:	557d                	li	a0,-1
}
    80000db4:	60a6                	ld	ra,72(sp)
    80000db6:	6406                	ld	s0,64(sp)
    80000db8:	74e2                	ld	s1,56(sp)
    80000dba:	7942                	ld	s2,48(sp)
    80000dbc:	79a2                	ld	s3,40(sp)
    80000dbe:	7a02                	ld	s4,32(sp)
    80000dc0:	6ae2                	ld	s5,24(sp)
    80000dc2:	6b42                	ld	s6,16(sp)
    80000dc4:	6ba2                	ld	s7,8(sp)
    80000dc6:	6c02                	ld	s8,0(sp)
    80000dc8:	6161                	addi	sp,sp,80
    80000dca:	8082                	ret

0000000080000dcc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000dcc:	c6c5                	beqz	a3,80000e74 <copyinstr+0xa8>
{
    80000dce:	715d                	addi	sp,sp,-80
    80000dd0:	e486                	sd	ra,72(sp)
    80000dd2:	e0a2                	sd	s0,64(sp)
    80000dd4:	fc26                	sd	s1,56(sp)
    80000dd6:	f84a                	sd	s2,48(sp)
    80000dd8:	f44e                	sd	s3,40(sp)
    80000dda:	f052                	sd	s4,32(sp)
    80000ddc:	ec56                	sd	s5,24(sp)
    80000dde:	e85a                	sd	s6,16(sp)
    80000de0:	e45e                	sd	s7,8(sp)
    80000de2:	0880                	addi	s0,sp,80
    80000de4:	8a2a                	mv	s4,a0
    80000de6:	8b2e                	mv	s6,a1
    80000de8:	8bb2                	mv	s7,a2
    80000dea:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dec:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dee:	6985                	lui	s3,0x1
    80000df0:	a035                	j	80000e1c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000df2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000df6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000df8:	0017b793          	seqz	a5,a5
    80000dfc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e00:	60a6                	ld	ra,72(sp)
    80000e02:	6406                	ld	s0,64(sp)
    80000e04:	74e2                	ld	s1,56(sp)
    80000e06:	7942                	ld	s2,48(sp)
    80000e08:	79a2                	ld	s3,40(sp)
    80000e0a:	7a02                	ld	s4,32(sp)
    80000e0c:	6ae2                	ld	s5,24(sp)
    80000e0e:	6b42                	ld	s6,16(sp)
    80000e10:	6ba2                	ld	s7,8(sp)
    80000e12:	6161                	addi	sp,sp,80
    80000e14:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e16:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e1a:	c8a9                	beqz	s1,80000e6c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000e1c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e20:	85ca                	mv	a1,s2
    80000e22:	8552                	mv	a0,s4
    80000e24:	00000097          	auipc	ra,0x0
    80000e28:	82c080e7          	jalr	-2004(ra) # 80000650 <walkaddr>
    if(pa0 == 0)
    80000e2c:	c131                	beqz	a0,80000e70 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000e2e:	41790833          	sub	a6,s2,s7
    80000e32:	984e                	add	a6,a6,s3
    if(n > max)
    80000e34:	0104f363          	bgeu	s1,a6,80000e3a <copyinstr+0x6e>
    80000e38:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e3a:	955e                	add	a0,a0,s7
    80000e3c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e40:	fc080be3          	beqz	a6,80000e16 <copyinstr+0x4a>
    80000e44:	985a                	add	a6,a6,s6
    80000e46:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e48:	41650633          	sub	a2,a0,s6
    80000e4c:	14fd                	addi	s1,s1,-1
    80000e4e:	9b26                	add	s6,s6,s1
    80000e50:	00f60733          	add	a4,a2,a5
    80000e54:	00074703          	lbu	a4,0(a4)
    80000e58:	df49                	beqz	a4,80000df2 <copyinstr+0x26>
        *dst = *p;
    80000e5a:	00e78023          	sb	a4,0(a5)
      --max;
    80000e5e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e62:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e64:	ff0796e3          	bne	a5,a6,80000e50 <copyinstr+0x84>
      dst++;
    80000e68:	8b42                	mv	s6,a6
    80000e6a:	b775                	j	80000e16 <copyinstr+0x4a>
    80000e6c:	4781                	li	a5,0
    80000e6e:	b769                	j	80000df8 <copyinstr+0x2c>
      return -1;
    80000e70:	557d                	li	a0,-1
    80000e72:	b779                	j	80000e00 <copyinstr+0x34>
  int got_null = 0;
    80000e74:	4781                	li	a5,0
  if(got_null){
    80000e76:	0017b793          	seqz	a5,a5
    80000e7a:	40f00533          	neg	a0,a5
}
    80000e7e:	8082                	ret

0000000080000e80 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e80:	7139                	addi	sp,sp,-64
    80000e82:	fc06                	sd	ra,56(sp)
    80000e84:	f822                	sd	s0,48(sp)
    80000e86:	f426                	sd	s1,40(sp)
    80000e88:	f04a                	sd	s2,32(sp)
    80000e8a:	ec4e                	sd	s3,24(sp)
    80000e8c:	e852                	sd	s4,16(sp)
    80000e8e:	e456                	sd	s5,8(sp)
    80000e90:	e05a                	sd	s6,0(sp)
    80000e92:	0080                	addi	s0,sp,64
    80000e94:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e96:	00008497          	auipc	s1,0x8
    80000e9a:	0fa48493          	addi	s1,s1,250 # 80008f90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e9e:	8b26                	mv	s6,s1
    80000ea0:	00007a97          	auipc	s5,0x7
    80000ea4:	160a8a93          	addi	s5,s5,352 # 80008000 <etext>
    80000ea8:	04000937          	lui	s2,0x4000
    80000eac:	197d                	addi	s2,s2,-1
    80000eae:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb0:	0000ea17          	auipc	s4,0xe
    80000eb4:	ce0a0a13          	addi	s4,s4,-800 # 8000eb90 <tickslock>
    char *pa = kalloc();
    80000eb8:	fffff097          	auipc	ra,0xfffff
    80000ebc:	2b2080e7          	jalr	690(ra) # 8000016a <kalloc>
    80000ec0:	862a                	mv	a2,a0
    if(pa == 0)
    80000ec2:	c131                	beqz	a0,80000f06 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ec4:	416485b3          	sub	a1,s1,s6
    80000ec8:	8591                	srai	a1,a1,0x4
    80000eca:	000ab783          	ld	a5,0(s5)
    80000ece:	02f585b3          	mul	a1,a1,a5
    80000ed2:	2585                	addiw	a1,a1,1
    80000ed4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ed8:	4719                	li	a4,6
    80000eda:	6685                	lui	a3,0x1
    80000edc:	40b905b3          	sub	a1,s2,a1
    80000ee0:	854e                	mv	a0,s3
    80000ee2:	00000097          	auipc	ra,0x0
    80000ee6:	874080e7          	jalr	-1932(ra) # 80000756 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eea:	17048493          	addi	s1,s1,368
    80000eee:	fd4495e3          	bne	s1,s4,80000eb8 <proc_mapstacks+0x38>
  }
}
    80000ef2:	70e2                	ld	ra,56(sp)
    80000ef4:	7442                	ld	s0,48(sp)
    80000ef6:	74a2                	ld	s1,40(sp)
    80000ef8:	7902                	ld	s2,32(sp)
    80000efa:	69e2                	ld	s3,24(sp)
    80000efc:	6a42                	ld	s4,16(sp)
    80000efe:	6aa2                	ld	s5,8(sp)
    80000f00:	6b02                	ld	s6,0(sp)
    80000f02:	6121                	addi	sp,sp,64
    80000f04:	8082                	ret
      panic("kalloc");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	29250513          	addi	a0,a0,658 # 80008198 <etext+0x198>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	384080e7          	jalr	900(ra) # 80006292 <panic>

0000000080000f16 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f16:	7139                	addi	sp,sp,-64
    80000f18:	fc06                	sd	ra,56(sp)
    80000f1a:	f822                	sd	s0,48(sp)
    80000f1c:	f426                	sd	s1,40(sp)
    80000f1e:	f04a                	sd	s2,32(sp)
    80000f20:	ec4e                	sd	s3,24(sp)
    80000f22:	e852                	sd	s4,16(sp)
    80000f24:	e456                	sd	s5,8(sp)
    80000f26:	e05a                	sd	s6,0(sp)
    80000f28:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f2a:	00007597          	auipc	a1,0x7
    80000f2e:	27658593          	addi	a1,a1,630 # 800081a0 <etext+0x1a0>
    80000f32:	00008517          	auipc	a0,0x8
    80000f36:	c1e50513          	addi	a0,a0,-994 # 80008b50 <pid_lock>
    80000f3a:	00006097          	auipc	ra,0x6
    80000f3e:	a08080e7          	jalr	-1528(ra) # 80006942 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f42:	00007597          	auipc	a1,0x7
    80000f46:	26658593          	addi	a1,a1,614 # 800081a8 <etext+0x1a8>
    80000f4a:	00008517          	auipc	a0,0x8
    80000f4e:	c2650513          	addi	a0,a0,-986 # 80008b70 <wait_lock>
    80000f52:	00006097          	auipc	ra,0x6
    80000f56:	9f0080e7          	jalr	-1552(ra) # 80006942 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5a:	00008497          	auipc	s1,0x8
    80000f5e:	03648493          	addi	s1,s1,54 # 80008f90 <proc>
      initlock(&p->lock, "proc");
    80000f62:	00007b17          	auipc	s6,0x7
    80000f66:	256b0b13          	addi	s6,s6,598 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f6a:	8aa6                	mv	s5,s1
    80000f6c:	00007a17          	auipc	s4,0x7
    80000f70:	094a0a13          	addi	s4,s4,148 # 80008000 <etext>
    80000f74:	04000937          	lui	s2,0x4000
    80000f78:	197d                	addi	s2,s2,-1
    80000f7a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7c:	0000e997          	auipc	s3,0xe
    80000f80:	c1498993          	addi	s3,s3,-1004 # 8000eb90 <tickslock>
      initlock(&p->lock, "proc");
    80000f84:	85da                	mv	a1,s6
    80000f86:	8526                	mv	a0,s1
    80000f88:	00006097          	auipc	ra,0x6
    80000f8c:	9ba080e7          	jalr	-1606(ra) # 80006942 <initlock>
      p->state = UNUSED;
    80000f90:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f94:	415487b3          	sub	a5,s1,s5
    80000f98:	8791                	srai	a5,a5,0x4
    80000f9a:	000a3703          	ld	a4,0(s4)
    80000f9e:	02e787b3          	mul	a5,a5,a4
    80000fa2:	2785                	addiw	a5,a5,1
    80000fa4:	00d7979b          	slliw	a5,a5,0xd
    80000fa8:	40f907b3          	sub	a5,s2,a5
    80000fac:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fae:	17048493          	addi	s1,s1,368
    80000fb2:	fd3499e3          	bne	s1,s3,80000f84 <procinit+0x6e>
  }
}
    80000fb6:	70e2                	ld	ra,56(sp)
    80000fb8:	7442                	ld	s0,48(sp)
    80000fba:	74a2                	ld	s1,40(sp)
    80000fbc:	7902                	ld	s2,32(sp)
    80000fbe:	69e2                	ld	s3,24(sp)
    80000fc0:	6a42                	ld	s4,16(sp)
    80000fc2:	6aa2                	ld	s5,8(sp)
    80000fc4:	6b02                	ld	s6,0(sp)
    80000fc6:	6121                	addi	sp,sp,64
    80000fc8:	8082                	ret

0000000080000fca <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fca:	1141                	addi	sp,sp,-16
    80000fcc:	e422                	sd	s0,8(sp)
    80000fce:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fd0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fd2:	2501                	sext.w	a0,a0
    80000fd4:	6422                	ld	s0,8(sp)
    80000fd6:	0141                	addi	sp,sp,16
    80000fd8:	8082                	ret

0000000080000fda <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000fda:	1141                	addi	sp,sp,-16
    80000fdc:	e422                	sd	s0,8(sp)
    80000fde:	0800                	addi	s0,sp,16
    80000fe0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fe2:	2781                	sext.w	a5,a5
    80000fe4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fe6:	00008517          	auipc	a0,0x8
    80000fea:	baa50513          	addi	a0,a0,-1110 # 80008b90 <cpus>
    80000fee:	953e                	add	a0,a0,a5
    80000ff0:	6422                	ld	s0,8(sp)
    80000ff2:	0141                	addi	sp,sp,16
    80000ff4:	8082                	ret

0000000080000ff6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
  push_off();
    80001000:	00005097          	auipc	ra,0x5
    80001004:	77a080e7          	jalr	1914(ra) # 8000677a <push_off>
    80001008:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000100a:	2781                	sext.w	a5,a5
    8000100c:	079e                	slli	a5,a5,0x7
    8000100e:	00008717          	auipc	a4,0x8
    80001012:	b4270713          	addi	a4,a4,-1214 # 80008b50 <pid_lock>
    80001016:	97ba                	add	a5,a5,a4
    80001018:	63a4                	ld	s1,64(a5)
  pop_off();
    8000101a:	00006097          	auipc	ra,0x6
    8000101e:	81c080e7          	jalr	-2020(ra) # 80006836 <pop_off>
  return p;
}
    80001022:	8526                	mv	a0,s1
    80001024:	60e2                	ld	ra,24(sp)
    80001026:	6442                	ld	s0,16(sp)
    80001028:	64a2                	ld	s1,8(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000102e:	1141                	addi	sp,sp,-16
    80001030:	e406                	sd	ra,8(sp)
    80001032:	e022                	sd	s0,0(sp)
    80001034:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	fc0080e7          	jalr	-64(ra) # 80000ff6 <myproc>
    8000103e:	00006097          	auipc	ra,0x6
    80001042:	858080e7          	jalr	-1960(ra) # 80006896 <release>

  if (first) {
    80001046:	00008797          	auipc	a5,0x8
    8000104a:	91a7a783          	lw	a5,-1766(a5) # 80008960 <first.1695>
    8000104e:	eb89                	bnez	a5,80001060 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001050:	00001097          	auipc	ra,0x1
    80001054:	c5a080e7          	jalr	-934(ra) # 80001caa <usertrapret>
}
    80001058:	60a2                	ld	ra,8(sp)
    8000105a:	6402                	ld	s0,0(sp)
    8000105c:	0141                	addi	sp,sp,16
    8000105e:	8082                	ret
    fsinit(ROOTDEV);
    80001060:	4505                	li	a0,1
    80001062:	00002097          	auipc	ra,0x2
    80001066:	b26080e7          	jalr	-1242(ra) # 80002b88 <fsinit>
    first = 0;
    8000106a:	00008797          	auipc	a5,0x8
    8000106e:	8e07ab23          	sw	zero,-1802(a5) # 80008960 <first.1695>
    __sync_synchronize();
    80001072:	0ff0000f          	fence
    80001076:	bfe9                	j	80001050 <forkret+0x22>

0000000080001078 <allocpid>:
{
    80001078:	1101                	addi	sp,sp,-32
    8000107a:	ec06                	sd	ra,24(sp)
    8000107c:	e822                	sd	s0,16(sp)
    8000107e:	e426                	sd	s1,8(sp)
    80001080:	e04a                	sd	s2,0(sp)
    80001082:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001084:	00008917          	auipc	s2,0x8
    80001088:	acc90913          	addi	s2,s2,-1332 # 80008b50 <pid_lock>
    8000108c:	854a                	mv	a0,s2
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	738080e7          	jalr	1848(ra) # 800067c6 <acquire>
  pid = nextpid;
    80001096:	00008797          	auipc	a5,0x8
    8000109a:	8ce78793          	addi	a5,a5,-1842 # 80008964 <nextpid>
    8000109e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010a0:	0014871b          	addiw	a4,s1,1
    800010a4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010a6:	854a                	mv	a0,s2
    800010a8:	00005097          	auipc	ra,0x5
    800010ac:	7ee080e7          	jalr	2030(ra) # 80006896 <release>
}
    800010b0:	8526                	mv	a0,s1
    800010b2:	60e2                	ld	ra,24(sp)
    800010b4:	6442                	ld	s0,16(sp)
    800010b6:	64a2                	ld	s1,8(sp)
    800010b8:	6902                	ld	s2,0(sp)
    800010ba:	6105                	addi	sp,sp,32
    800010bc:	8082                	ret

00000000800010be <proc_pagetable>:
{
    800010be:	1101                	addi	sp,sp,-32
    800010c0:	ec06                	sd	ra,24(sp)
    800010c2:	e822                	sd	s0,16(sp)
    800010c4:	e426                	sd	s1,8(sp)
    800010c6:	e04a                	sd	s2,0(sp)
    800010c8:	1000                	addi	s0,sp,32
    800010ca:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	874080e7          	jalr	-1932(ra) # 80000940 <uvmcreate>
    800010d4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010d6:	c121                	beqz	a0,80001116 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010d8:	4729                	li	a4,10
    800010da:	00006697          	auipc	a3,0x6
    800010de:	f2668693          	addi	a3,a3,-218 # 80007000 <_trampoline>
    800010e2:	6605                	lui	a2,0x1
    800010e4:	040005b7          	lui	a1,0x4000
    800010e8:	15fd                	addi	a1,a1,-1
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	5a6080e7          	jalr	1446(ra) # 80000692 <mappages>
    800010f4:	02054863          	bltz	a0,80001124 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010f8:	4719                	li	a4,6
    800010fa:	06093683          	ld	a3,96(s2)
    800010fe:	6605                	lui	a2,0x1
    80001100:	020005b7          	lui	a1,0x2000
    80001104:	15fd                	addi	a1,a1,-1
    80001106:	05b6                	slli	a1,a1,0xd
    80001108:	8526                	mv	a0,s1
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	588080e7          	jalr	1416(ra) # 80000692 <mappages>
    80001112:	02054163          	bltz	a0,80001134 <proc_pagetable+0x76>
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6902                	ld	s2,0(sp)
    80001120:	6105                	addi	sp,sp,32
    80001122:	8082                	ret
    uvmfree(pagetable, 0);
    80001124:	4581                	li	a1,0
    80001126:	8526                	mv	a0,s1
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	a1c080e7          	jalr	-1508(ra) # 80000b44 <uvmfree>
    return 0;
    80001130:	4481                	li	s1,0
    80001132:	b7d5                	j	80001116 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001134:	4681                	li	a3,0
    80001136:	4605                	li	a2,1
    80001138:	040005b7          	lui	a1,0x4000
    8000113c:	15fd                	addi	a1,a1,-1
    8000113e:	05b2                	slli	a1,a1,0xc
    80001140:	8526                	mv	a0,s1
    80001142:	fffff097          	auipc	ra,0xfffff
    80001146:	73a080e7          	jalr	1850(ra) # 8000087c <uvmunmap>
    uvmfree(pagetable, 0);
    8000114a:	4581                	li	a1,0
    8000114c:	8526                	mv	a0,s1
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	9f6080e7          	jalr	-1546(ra) # 80000b44 <uvmfree>
    return 0;
    80001156:	4481                	li	s1,0
    80001158:	bf7d                	j	80001116 <proc_pagetable+0x58>

000000008000115a <proc_freepagetable>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	e04a                	sd	s2,0(sp)
    80001164:	1000                	addi	s0,sp,32
    80001166:	84aa                	mv	s1,a0
    80001168:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000116a:	4681                	li	a3,0
    8000116c:	4605                	li	a2,1
    8000116e:	040005b7          	lui	a1,0x4000
    80001172:	15fd                	addi	a1,a1,-1
    80001174:	05b2                	slli	a1,a1,0xc
    80001176:	fffff097          	auipc	ra,0xfffff
    8000117a:	706080e7          	jalr	1798(ra) # 8000087c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000117e:	4681                	li	a3,0
    80001180:	4605                	li	a2,1
    80001182:	020005b7          	lui	a1,0x2000
    80001186:	15fd                	addi	a1,a1,-1
    80001188:	05b6                	slli	a1,a1,0xd
    8000118a:	8526                	mv	a0,s1
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	6f0080e7          	jalr	1776(ra) # 8000087c <uvmunmap>
  uvmfree(pagetable, sz);
    80001194:	85ca                	mv	a1,s2
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	9ac080e7          	jalr	-1620(ra) # 80000b44 <uvmfree>
}
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6902                	ld	s2,0(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <freeproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	1000                	addi	s0,sp,32
    800011b6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011b8:	7128                	ld	a0,96(a0)
    800011ba:	c509                	beqz	a0,800011c4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	e60080e7          	jalr	-416(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011c4:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011c8:	6ca8                	ld	a0,88(s1)
    800011ca:	c511                	beqz	a0,800011d6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011cc:	68ac                	ld	a1,80(s1)
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f8c080e7          	jalr	-116(ra) # 8000115a <proc_freepagetable>
  p->pagetable = 0;
    800011d6:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800011da:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800011de:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800011e2:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    800011e6:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011ea:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800011ee:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800011f2:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800011f6:	0204a023          	sw	zero,32(s1)
}
    800011fa:	60e2                	ld	ra,24(sp)
    800011fc:	6442                	ld	s0,16(sp)
    800011fe:	64a2                	ld	s1,8(sp)
    80001200:	6105                	addi	sp,sp,32
    80001202:	8082                	ret

0000000080001204 <allocproc>:
{
    80001204:	1101                	addi	sp,sp,-32
    80001206:	ec06                	sd	ra,24(sp)
    80001208:	e822                	sd	s0,16(sp)
    8000120a:	e426                	sd	s1,8(sp)
    8000120c:	e04a                	sd	s2,0(sp)
    8000120e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001210:	00008497          	auipc	s1,0x8
    80001214:	d8048493          	addi	s1,s1,-640 # 80008f90 <proc>
    80001218:	0000e917          	auipc	s2,0xe
    8000121c:	97890913          	addi	s2,s2,-1672 # 8000eb90 <tickslock>
    acquire(&p->lock);
    80001220:	8526                	mv	a0,s1
    80001222:	00005097          	auipc	ra,0x5
    80001226:	5a4080e7          	jalr	1444(ra) # 800067c6 <acquire>
    if(p->state == UNUSED) {
    8000122a:	509c                	lw	a5,32(s1)
    8000122c:	cf81                	beqz	a5,80001244 <allocproc+0x40>
      release(&p->lock);
    8000122e:	8526                	mv	a0,s1
    80001230:	00005097          	auipc	ra,0x5
    80001234:	666080e7          	jalr	1638(ra) # 80006896 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001238:	17048493          	addi	s1,s1,368
    8000123c:	ff2492e3          	bne	s1,s2,80001220 <allocproc+0x1c>
  return 0;
    80001240:	4481                	li	s1,0
    80001242:	a889                	j	80001294 <allocproc+0x90>
  p->pid = allocpid();
    80001244:	00000097          	auipc	ra,0x0
    80001248:	e34080e7          	jalr	-460(ra) # 80001078 <allocpid>
    8000124c:	dc88                	sw	a0,56(s1)
  p->state = USED;
    8000124e:	4785                	li	a5,1
    80001250:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	f18080e7          	jalr	-232(ra) # 8000016a <kalloc>
    8000125a:	892a                	mv	s2,a0
    8000125c:	f0a8                	sd	a0,96(s1)
    8000125e:	c131                	beqz	a0,800012a2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001260:	8526                	mv	a0,s1
    80001262:	00000097          	auipc	ra,0x0
    80001266:	e5c080e7          	jalr	-420(ra) # 800010be <proc_pagetable>
    8000126a:	892a                	mv	s2,a0
    8000126c:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    8000126e:	c531                	beqz	a0,800012ba <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001270:	07000613          	li	a2,112
    80001274:	4581                	li	a1,0
    80001276:	06848513          	addi	a0,s1,104
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	034080e7          	jalr	52(ra) # 800002ae <memset>
  p->context.ra = (uint64)forkret;
    80001282:	00000797          	auipc	a5,0x0
    80001286:	dac78793          	addi	a5,a5,-596 # 8000102e <forkret>
    8000128a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000128c:	64bc                	ld	a5,72(s1)
    8000128e:	6705                	lui	a4,0x1
    80001290:	97ba                	add	a5,a5,a4
    80001292:	f8bc                	sd	a5,112(s1)
}
    80001294:	8526                	mv	a0,s1
    80001296:	60e2                	ld	ra,24(sp)
    80001298:	6442                	ld	s0,16(sp)
    8000129a:	64a2                	ld	s1,8(sp)
    8000129c:	6902                	ld	s2,0(sp)
    8000129e:	6105                	addi	sp,sp,32
    800012a0:	8082                	ret
    freeproc(p);
    800012a2:	8526                	mv	a0,s1
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	f08080e7          	jalr	-248(ra) # 800011ac <freeproc>
    release(&p->lock);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	5e8080e7          	jalr	1512(ra) # 80006896 <release>
    return 0;
    800012b6:	84ca                	mv	s1,s2
    800012b8:	bff1                	j	80001294 <allocproc+0x90>
    freeproc(p);
    800012ba:	8526                	mv	a0,s1
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	ef0080e7          	jalr	-272(ra) # 800011ac <freeproc>
    release(&p->lock);
    800012c4:	8526                	mv	a0,s1
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	5d0080e7          	jalr	1488(ra) # 80006896 <release>
    return 0;
    800012ce:	84ca                	mv	s1,s2
    800012d0:	b7d1                	j	80001294 <allocproc+0x90>

00000000800012d2 <userinit>:
{
    800012d2:	1101                	addi	sp,sp,-32
    800012d4:	ec06                	sd	ra,24(sp)
    800012d6:	e822                	sd	s0,16(sp)
    800012d8:	e426                	sd	s1,8(sp)
    800012da:	1000                	addi	s0,sp,32
  p = allocproc();
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	f28080e7          	jalr	-216(ra) # 80001204 <allocproc>
    800012e4:	84aa                	mv	s1,a0
  initproc = p;
    800012e6:	00007797          	auipc	a5,0x7
    800012ea:	6ea7bd23          	sd	a0,1786(a5) # 800089e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012ee:	03400613          	li	a2,52
    800012f2:	00007597          	auipc	a1,0x7
    800012f6:	67e58593          	addi	a1,a1,1662 # 80008970 <initcode>
    800012fa:	6d28                	ld	a0,88(a0)
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	672080e7          	jalr	1650(ra) # 8000096e <uvmfirst>
  p->sz = PGSIZE;
    80001304:	6785                	lui	a5,0x1
    80001306:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001308:	70b8                	ld	a4,96(s1)
    8000130a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000130e:	70b8                	ld	a4,96(s1)
    80001310:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001312:	4641                	li	a2,16
    80001314:	00007597          	auipc	a1,0x7
    80001318:	eac58593          	addi	a1,a1,-340 # 800081c0 <etext+0x1c0>
    8000131c:	16048513          	addi	a0,s1,352
    80001320:	fffff097          	auipc	ra,0xfffff
    80001324:	0e0080e7          	jalr	224(ra) # 80000400 <safestrcpy>
  p->cwd = namei("/");
    80001328:	00007517          	auipc	a0,0x7
    8000132c:	ea850513          	addi	a0,a0,-344 # 800081d0 <etext+0x1d0>
    80001330:	00002097          	auipc	ra,0x2
    80001334:	28e080e7          	jalr	654(ra) # 800035be <namei>
    80001338:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000133c:	478d                	li	a5,3
    8000133e:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001340:	8526                	mv	a0,s1
    80001342:	00005097          	auipc	ra,0x5
    80001346:	554080e7          	jalr	1364(ra) # 80006896 <release>
}
    8000134a:	60e2                	ld	ra,24(sp)
    8000134c:	6442                	ld	s0,16(sp)
    8000134e:	64a2                	ld	s1,8(sp)
    80001350:	6105                	addi	sp,sp,32
    80001352:	8082                	ret

0000000080001354 <growproc>:
{
    80001354:	1101                	addi	sp,sp,-32
    80001356:	ec06                	sd	ra,24(sp)
    80001358:	e822                	sd	s0,16(sp)
    8000135a:	e426                	sd	s1,8(sp)
    8000135c:	e04a                	sd	s2,0(sp)
    8000135e:	1000                	addi	s0,sp,32
    80001360:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001362:	00000097          	auipc	ra,0x0
    80001366:	c94080e7          	jalr	-876(ra) # 80000ff6 <myproc>
    8000136a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000136c:	692c                	ld	a1,80(a0)
  if(n > 0){
    8000136e:	01204c63          	bgtz	s2,80001386 <growproc+0x32>
  } else if(n < 0){
    80001372:	02094663          	bltz	s2,8000139e <growproc+0x4a>
  p->sz = sz;
    80001376:	e8ac                	sd	a1,80(s1)
  return 0;
    80001378:	4501                	li	a0,0
}
    8000137a:	60e2                	ld	ra,24(sp)
    8000137c:	6442                	ld	s0,16(sp)
    8000137e:	64a2                	ld	s1,8(sp)
    80001380:	6902                	ld	s2,0(sp)
    80001382:	6105                	addi	sp,sp,32
    80001384:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001386:	4691                	li	a3,4
    80001388:	00b90633          	add	a2,s2,a1
    8000138c:	6d28                	ld	a0,88(a0)
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	69a080e7          	jalr	1690(ra) # 80000a28 <uvmalloc>
    80001396:	85aa                	mv	a1,a0
    80001398:	fd79                	bnez	a0,80001376 <growproc+0x22>
      return -1;
    8000139a:	557d                	li	a0,-1
    8000139c:	bff9                	j	8000137a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000139e:	00b90633          	add	a2,s2,a1
    800013a2:	6d28                	ld	a0,88(a0)
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	63c080e7          	jalr	1596(ra) # 800009e0 <uvmdealloc>
    800013ac:	85aa                	mv	a1,a0
    800013ae:	b7e1                	j	80001376 <growproc+0x22>

00000000800013b0 <fork>:
{
    800013b0:	7179                	addi	sp,sp,-48
    800013b2:	f406                	sd	ra,40(sp)
    800013b4:	f022                	sd	s0,32(sp)
    800013b6:	ec26                	sd	s1,24(sp)
    800013b8:	e84a                	sd	s2,16(sp)
    800013ba:	e44e                	sd	s3,8(sp)
    800013bc:	e052                	sd	s4,0(sp)
    800013be:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	c36080e7          	jalr	-970(ra) # 80000ff6 <myproc>
    800013c8:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	e3a080e7          	jalr	-454(ra) # 80001204 <allocproc>
    800013d2:	10050b63          	beqz	a0,800014e8 <fork+0x138>
    800013d6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013d8:	05093603          	ld	a2,80(s2)
    800013dc:	6d2c                	ld	a1,88(a0)
    800013de:	05893503          	ld	a0,88(s2)
    800013e2:	fffff097          	auipc	ra,0xfffff
    800013e6:	79a080e7          	jalr	1946(ra) # 80000b7c <uvmcopy>
    800013ea:	04054663          	bltz	a0,80001436 <fork+0x86>
  np->sz = p->sz;
    800013ee:	05093783          	ld	a5,80(s2)
    800013f2:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    800013f6:	06093683          	ld	a3,96(s2)
    800013fa:	87b6                	mv	a5,a3
    800013fc:	0609b703          	ld	a4,96(s3)
    80001400:	12068693          	addi	a3,a3,288
    80001404:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001408:	6788                	ld	a0,8(a5)
    8000140a:	6b8c                	ld	a1,16(a5)
    8000140c:	6f90                	ld	a2,24(a5)
    8000140e:	01073023          	sd	a6,0(a4)
    80001412:	e708                	sd	a0,8(a4)
    80001414:	eb0c                	sd	a1,16(a4)
    80001416:	ef10                	sd	a2,24(a4)
    80001418:	02078793          	addi	a5,a5,32
    8000141c:	02070713          	addi	a4,a4,32
    80001420:	fed792e3          	bne	a5,a3,80001404 <fork+0x54>
  np->trapframe->a0 = 0;
    80001424:	0609b783          	ld	a5,96(s3)
    80001428:	0607b823          	sd	zero,112(a5)
    8000142c:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001430:	15800a13          	li	s4,344
    80001434:	a03d                	j	80001462 <fork+0xb2>
    freeproc(np);
    80001436:	854e                	mv	a0,s3
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	d74080e7          	jalr	-652(ra) # 800011ac <freeproc>
    release(&np->lock);
    80001440:	854e                	mv	a0,s3
    80001442:	00005097          	auipc	ra,0x5
    80001446:	454080e7          	jalr	1108(ra) # 80006896 <release>
    return -1;
    8000144a:	5a7d                	li	s4,-1
    8000144c:	a069                	j	800014d6 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000144e:	00003097          	auipc	ra,0x3
    80001452:	806080e7          	jalr	-2042(ra) # 80003c54 <filedup>
    80001456:	009987b3          	add	a5,s3,s1
    8000145a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000145c:	04a1                	addi	s1,s1,8
    8000145e:	01448763          	beq	s1,s4,8000146c <fork+0xbc>
    if(p->ofile[i])
    80001462:	009907b3          	add	a5,s2,s1
    80001466:	6388                	ld	a0,0(a5)
    80001468:	f17d                	bnez	a0,8000144e <fork+0x9e>
    8000146a:	bfcd                	j	8000145c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000146c:	15893503          	ld	a0,344(s2)
    80001470:	00002097          	auipc	ra,0x2
    80001474:	956080e7          	jalr	-1706(ra) # 80002dc6 <idup>
    80001478:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000147c:	4641                	li	a2,16
    8000147e:	16090593          	addi	a1,s2,352
    80001482:	16098513          	addi	a0,s3,352
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	f7a080e7          	jalr	-134(ra) # 80000400 <safestrcpy>
  pid = np->pid;
    8000148e:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    80001492:	854e                	mv	a0,s3
    80001494:	00005097          	auipc	ra,0x5
    80001498:	402080e7          	jalr	1026(ra) # 80006896 <release>
  acquire(&wait_lock);
    8000149c:	00007497          	auipc	s1,0x7
    800014a0:	6d448493          	addi	s1,s1,1748 # 80008b70 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	320080e7          	jalr	800(ra) # 800067c6 <acquire>
  np->parent = p;
    800014ae:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    800014b2:	8526                	mv	a0,s1
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	3e2080e7          	jalr	994(ra) # 80006896 <release>
  acquire(&np->lock);
    800014bc:	854e                	mv	a0,s3
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	308080e7          	jalr	776(ra) # 800067c6 <acquire>
  np->state = RUNNABLE;
    800014c6:	478d                	li	a5,3
    800014c8:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    800014cc:	854e                	mv	a0,s3
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	3c8080e7          	jalr	968(ra) # 80006896 <release>
}
    800014d6:	8552                	mv	a0,s4
    800014d8:	70a2                	ld	ra,40(sp)
    800014da:	7402                	ld	s0,32(sp)
    800014dc:	64e2                	ld	s1,24(sp)
    800014de:	6942                	ld	s2,16(sp)
    800014e0:	69a2                	ld	s3,8(sp)
    800014e2:	6a02                	ld	s4,0(sp)
    800014e4:	6145                	addi	sp,sp,48
    800014e6:	8082                	ret
    return -1;
    800014e8:	5a7d                	li	s4,-1
    800014ea:	b7f5                	j	800014d6 <fork+0x126>

00000000800014ec <scheduler>:
{
    800014ec:	7139                	addi	sp,sp,-64
    800014ee:	fc06                	sd	ra,56(sp)
    800014f0:	f822                	sd	s0,48(sp)
    800014f2:	f426                	sd	s1,40(sp)
    800014f4:	f04a                	sd	s2,32(sp)
    800014f6:	ec4e                	sd	s3,24(sp)
    800014f8:	e852                	sd	s4,16(sp)
    800014fa:	e456                	sd	s5,8(sp)
    800014fc:	e05a                	sd	s6,0(sp)
    800014fe:	0080                	addi	s0,sp,64
    80001500:	8792                	mv	a5,tp
  int id = r_tp();
    80001502:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001504:	00779a93          	slli	s5,a5,0x7
    80001508:	00007717          	auipc	a4,0x7
    8000150c:	64870713          	addi	a4,a4,1608 # 80008b50 <pid_lock>
    80001510:	9756                	add	a4,a4,s5
    80001512:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001516:	00007717          	auipc	a4,0x7
    8000151a:	68270713          	addi	a4,a4,1666 # 80008b98 <cpus+0x8>
    8000151e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001520:	498d                	li	s3,3
        p->state = RUNNING;
    80001522:	4b11                	li	s6,4
        c->proc = p;
    80001524:	079e                	slli	a5,a5,0x7
    80001526:	00007a17          	auipc	s4,0x7
    8000152a:	62aa0a13          	addi	s4,s4,1578 # 80008b50 <pid_lock>
    8000152e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001530:	0000d917          	auipc	s2,0xd
    80001534:	66090913          	addi	s2,s2,1632 # 8000eb90 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001538:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001540:	10079073          	csrw	sstatus,a5
    80001544:	00008497          	auipc	s1,0x8
    80001548:	a4c48493          	addi	s1,s1,-1460 # 80008f90 <proc>
    8000154c:	a03d                	j	8000157a <scheduler+0x8e>
        p->state = RUNNING;
    8000154e:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001552:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    80001556:	06848593          	addi	a1,s1,104
    8000155a:	8556                	mv	a0,s5
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	6a4080e7          	jalr	1700(ra) # 80001c00 <swtch>
        c->proc = 0;
    80001564:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    80001568:	8526                	mv	a0,s1
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	32c080e7          	jalr	812(ra) # 80006896 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	17048493          	addi	s1,s1,368
    80001576:	fd2481e3          	beq	s1,s2,80001538 <scheduler+0x4c>
      acquire(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	24a080e7          	jalr	586(ra) # 800067c6 <acquire>
      if(p->state == RUNNABLE) {
    80001584:	509c                	lw	a5,32(s1)
    80001586:	ff3791e3          	bne	a5,s3,80001568 <scheduler+0x7c>
    8000158a:	b7d1                	j	8000154e <scheduler+0x62>

000000008000158c <sched>:
{
    8000158c:	7179                	addi	sp,sp,-48
    8000158e:	f406                	sd	ra,40(sp)
    80001590:	f022                	sd	s0,32(sp)
    80001592:	ec26                	sd	s1,24(sp)
    80001594:	e84a                	sd	s2,16(sp)
    80001596:	e44e                	sd	s3,8(sp)
    80001598:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	a5c080e7          	jalr	-1444(ra) # 80000ff6 <myproc>
    800015a2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	1a8080e7          	jalr	424(ra) # 8000674c <holding>
    800015ac:	c93d                	beqz	a0,80001622 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ae:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015b0:	2781                	sext.w	a5,a5
    800015b2:	079e                	slli	a5,a5,0x7
    800015b4:	00007717          	auipc	a4,0x7
    800015b8:	59c70713          	addi	a4,a4,1436 # 80008b50 <pid_lock>
    800015bc:	97ba                	add	a5,a5,a4
    800015be:	0b87a703          	lw	a4,184(a5)
    800015c2:	4785                	li	a5,1
    800015c4:	06f71763          	bne	a4,a5,80001632 <sched+0xa6>
  if(p->state == RUNNING)
    800015c8:	5098                	lw	a4,32(s1)
    800015ca:	4791                	li	a5,4
    800015cc:	06f70b63          	beq	a4,a5,80001642 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015d0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015d4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015d6:	efb5                	bnez	a5,80001652 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015da:	00007917          	auipc	s2,0x7
    800015de:	57690913          	addi	s2,s2,1398 # 80008b50 <pid_lock>
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	97ca                	add	a5,a5,s2
    800015e8:	0bc7a983          	lw	s3,188(a5)
    800015ec:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ee:	2781                	sext.w	a5,a5
    800015f0:	079e                	slli	a5,a5,0x7
    800015f2:	00007597          	auipc	a1,0x7
    800015f6:	5a658593          	addi	a1,a1,1446 # 80008b98 <cpus+0x8>
    800015fa:	95be                	add	a1,a1,a5
    800015fc:	06848513          	addi	a0,s1,104
    80001600:	00000097          	auipc	ra,0x0
    80001604:	600080e7          	jalr	1536(ra) # 80001c00 <swtch>
    80001608:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000160a:	2781                	sext.w	a5,a5
    8000160c:	079e                	slli	a5,a5,0x7
    8000160e:	97ca                	add	a5,a5,s2
    80001610:	0b37ae23          	sw	s3,188(a5)
}
    80001614:	70a2                	ld	ra,40(sp)
    80001616:	7402                	ld	s0,32(sp)
    80001618:	64e2                	ld	s1,24(sp)
    8000161a:	6942                	ld	s2,16(sp)
    8000161c:	69a2                	ld	s3,8(sp)
    8000161e:	6145                	addi	sp,sp,48
    80001620:	8082                	ret
    panic("sched p->lock");
    80001622:	00007517          	auipc	a0,0x7
    80001626:	bb650513          	addi	a0,a0,-1098 # 800081d8 <etext+0x1d8>
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	c68080e7          	jalr	-920(ra) # 80006292 <panic>
    panic("sched locks");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	bb650513          	addi	a0,a0,-1098 # 800081e8 <etext+0x1e8>
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	c58080e7          	jalr	-936(ra) # 80006292 <panic>
    panic("sched running");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	bb650513          	addi	a0,a0,-1098 # 800081f8 <etext+0x1f8>
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	c48080e7          	jalr	-952(ra) # 80006292 <panic>
    panic("sched interruptible");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	bb650513          	addi	a0,a0,-1098 # 80008208 <etext+0x208>
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	c38080e7          	jalr	-968(ra) # 80006292 <panic>

0000000080001662 <yield>:
{
    80001662:	1101                	addi	sp,sp,-32
    80001664:	ec06                	sd	ra,24(sp)
    80001666:	e822                	sd	s0,16(sp)
    80001668:	e426                	sd	s1,8(sp)
    8000166a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	98a080e7          	jalr	-1654(ra) # 80000ff6 <myproc>
    80001674:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001676:	00005097          	auipc	ra,0x5
    8000167a:	150080e7          	jalr	336(ra) # 800067c6 <acquire>
  p->state = RUNNABLE;
    8000167e:	478d                	li	a5,3
    80001680:	d09c                	sw	a5,32(s1)
  sched();
    80001682:	00000097          	auipc	ra,0x0
    80001686:	f0a080e7          	jalr	-246(ra) # 8000158c <sched>
  release(&p->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	20a080e7          	jalr	522(ra) # 80006896 <release>
}
    80001694:	60e2                	ld	ra,24(sp)
    80001696:	6442                	ld	s0,16(sp)
    80001698:	64a2                	ld	s1,8(sp)
    8000169a:	6105                	addi	sp,sp,32
    8000169c:	8082                	ret

000000008000169e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000169e:	7179                	addi	sp,sp,-48
    800016a0:	f406                	sd	ra,40(sp)
    800016a2:	f022                	sd	s0,32(sp)
    800016a4:	ec26                	sd	s1,24(sp)
    800016a6:	e84a                	sd	s2,16(sp)
    800016a8:	e44e                	sd	s3,8(sp)
    800016aa:	1800                	addi	s0,sp,48
    800016ac:	89aa                	mv	s3,a0
    800016ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016b0:	00000097          	auipc	ra,0x0
    800016b4:	946080e7          	jalr	-1722(ra) # 80000ff6 <myproc>
    800016b8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	10c080e7          	jalr	268(ra) # 800067c6 <acquire>
  release(lk);
    800016c2:	854a                	mv	a0,s2
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	1d2080e7          	jalr	466(ra) # 80006896 <release>

  // Go to sleep.
  p->chan = chan;
    800016cc:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800016d0:	4789                	li	a5,2
    800016d2:	d09c                	sw	a5,32(s1)

  sched();
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	eb8080e7          	jalr	-328(ra) # 8000158c <sched>

  // Tidy up.
  p->chan = 0;
    800016dc:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016e0:	8526                	mv	a0,s1
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	1b4080e7          	jalr	436(ra) # 80006896 <release>
  acquire(lk);
    800016ea:	854a                	mv	a0,s2
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	0da080e7          	jalr	218(ra) # 800067c6 <acquire>
}
    800016f4:	70a2                	ld	ra,40(sp)
    800016f6:	7402                	ld	s0,32(sp)
    800016f8:	64e2                	ld	s1,24(sp)
    800016fa:	6942                	ld	s2,16(sp)
    800016fc:	69a2                	ld	s3,8(sp)
    800016fe:	6145                	addi	sp,sp,48
    80001700:	8082                	ret

0000000080001702 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001702:	7139                	addi	sp,sp,-64
    80001704:	fc06                	sd	ra,56(sp)
    80001706:	f822                	sd	s0,48(sp)
    80001708:	f426                	sd	s1,40(sp)
    8000170a:	f04a                	sd	s2,32(sp)
    8000170c:	ec4e                	sd	s3,24(sp)
    8000170e:	e852                	sd	s4,16(sp)
    80001710:	e456                	sd	s5,8(sp)
    80001712:	0080                	addi	s0,sp,64
    80001714:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001716:	00008497          	auipc	s1,0x8
    8000171a:	87a48493          	addi	s1,s1,-1926 # 80008f90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000171e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001720:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	0000d917          	auipc	s2,0xd
    80001726:	46e90913          	addi	s2,s2,1134 # 8000eb90 <tickslock>
    8000172a:	a821                	j	80001742 <wakeup+0x40>
        p->state = RUNNABLE;
    8000172c:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	164080e7          	jalr	356(ra) # 80006896 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000173a:	17048493          	addi	s1,s1,368
    8000173e:	03248463          	beq	s1,s2,80001766 <wakeup+0x64>
    if(p != myproc()){
    80001742:	00000097          	auipc	ra,0x0
    80001746:	8b4080e7          	jalr	-1868(ra) # 80000ff6 <myproc>
    8000174a:	fea488e3          	beq	s1,a0,8000173a <wakeup+0x38>
      acquire(&p->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	076080e7          	jalr	118(ra) # 800067c6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001758:	509c                	lw	a5,32(s1)
    8000175a:	fd379be3          	bne	a5,s3,80001730 <wakeup+0x2e>
    8000175e:	749c                	ld	a5,40(s1)
    80001760:	fd4798e3          	bne	a5,s4,80001730 <wakeup+0x2e>
    80001764:	b7e1                	j	8000172c <wakeup+0x2a>
    }
  }
}
    80001766:	70e2                	ld	ra,56(sp)
    80001768:	7442                	ld	s0,48(sp)
    8000176a:	74a2                	ld	s1,40(sp)
    8000176c:	7902                	ld	s2,32(sp)
    8000176e:	69e2                	ld	s3,24(sp)
    80001770:	6a42                	ld	s4,16(sp)
    80001772:	6aa2                	ld	s5,8(sp)
    80001774:	6121                	addi	sp,sp,64
    80001776:	8082                	ret

0000000080001778 <reparent>:
{
    80001778:	7179                	addi	sp,sp,-48
    8000177a:	f406                	sd	ra,40(sp)
    8000177c:	f022                	sd	s0,32(sp)
    8000177e:	ec26                	sd	s1,24(sp)
    80001780:	e84a                	sd	s2,16(sp)
    80001782:	e44e                	sd	s3,8(sp)
    80001784:	e052                	sd	s4,0(sp)
    80001786:	1800                	addi	s0,sp,48
    80001788:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178a:	00008497          	auipc	s1,0x8
    8000178e:	80648493          	addi	s1,s1,-2042 # 80008f90 <proc>
      pp->parent = initproc;
    80001792:	00007a17          	auipc	s4,0x7
    80001796:	24ea0a13          	addi	s4,s4,590 # 800089e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179a:	0000d997          	auipc	s3,0xd
    8000179e:	3f698993          	addi	s3,s3,1014 # 8000eb90 <tickslock>
    800017a2:	a029                	j	800017ac <reparent+0x34>
    800017a4:	17048493          	addi	s1,s1,368
    800017a8:	01348d63          	beq	s1,s3,800017c2 <reparent+0x4a>
    if(pp->parent == p){
    800017ac:	60bc                	ld	a5,64(s1)
    800017ae:	ff279be3          	bne	a5,s2,800017a4 <reparent+0x2c>
      pp->parent = initproc;
    800017b2:	000a3503          	ld	a0,0(s4)
    800017b6:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800017b8:	00000097          	auipc	ra,0x0
    800017bc:	f4a080e7          	jalr	-182(ra) # 80001702 <wakeup>
    800017c0:	b7d5                	j	800017a4 <reparent+0x2c>
}
    800017c2:	70a2                	ld	ra,40(sp)
    800017c4:	7402                	ld	s0,32(sp)
    800017c6:	64e2                	ld	s1,24(sp)
    800017c8:	6942                	ld	s2,16(sp)
    800017ca:	69a2                	ld	s3,8(sp)
    800017cc:	6a02                	ld	s4,0(sp)
    800017ce:	6145                	addi	sp,sp,48
    800017d0:	8082                	ret

00000000800017d2 <exit>:
{
    800017d2:	7179                	addi	sp,sp,-48
    800017d4:	f406                	sd	ra,40(sp)
    800017d6:	f022                	sd	s0,32(sp)
    800017d8:	ec26                	sd	s1,24(sp)
    800017da:	e84a                	sd	s2,16(sp)
    800017dc:	e44e                	sd	s3,8(sp)
    800017de:	e052                	sd	s4,0(sp)
    800017e0:	1800                	addi	s0,sp,48
    800017e2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	812080e7          	jalr	-2030(ra) # 80000ff6 <myproc>
    800017ec:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ee:	00007797          	auipc	a5,0x7
    800017f2:	1f27b783          	ld	a5,498(a5) # 800089e0 <initproc>
    800017f6:	0d850493          	addi	s1,a0,216
    800017fa:	15850913          	addi	s2,a0,344
    800017fe:	02a79363          	bne	a5,a0,80001824 <exit+0x52>
    panic("init exiting");
    80001802:	00007517          	auipc	a0,0x7
    80001806:	a1e50513          	addi	a0,a0,-1506 # 80008220 <etext+0x220>
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	a88080e7          	jalr	-1400(ra) # 80006292 <panic>
      fileclose(f);
    80001812:	00002097          	auipc	ra,0x2
    80001816:	494080e7          	jalr	1172(ra) # 80003ca6 <fileclose>
      p->ofile[fd] = 0;
    8000181a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000181e:	04a1                	addi	s1,s1,8
    80001820:	01248563          	beq	s1,s2,8000182a <exit+0x58>
    if(p->ofile[fd]){
    80001824:	6088                	ld	a0,0(s1)
    80001826:	f575                	bnez	a0,80001812 <exit+0x40>
    80001828:	bfdd                	j	8000181e <exit+0x4c>
  begin_op();
    8000182a:	00002097          	auipc	ra,0x2
    8000182e:	fb0080e7          	jalr	-80(ra) # 800037da <begin_op>
  iput(p->cwd);
    80001832:	1589b503          	ld	a0,344(s3)
    80001836:	00001097          	auipc	ra,0x1
    8000183a:	79c080e7          	jalr	1948(ra) # 80002fd2 <iput>
  end_op();
    8000183e:	00002097          	auipc	ra,0x2
    80001842:	01c080e7          	jalr	28(ra) # 8000385a <end_op>
  p->cwd = 0;
    80001846:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000184a:	00007497          	auipc	s1,0x7
    8000184e:	32648493          	addi	s1,s1,806 # 80008b70 <wait_lock>
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	f72080e7          	jalr	-142(ra) # 800067c6 <acquire>
  reparent(p);
    8000185c:	854e                	mv	a0,s3
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	f1a080e7          	jalr	-230(ra) # 80001778 <reparent>
  wakeup(p->parent);
    80001866:	0409b503          	ld	a0,64(s3)
    8000186a:	00000097          	auipc	ra,0x0
    8000186e:	e98080e7          	jalr	-360(ra) # 80001702 <wakeup>
  acquire(&p->lock);
    80001872:	854e                	mv	a0,s3
    80001874:	00005097          	auipc	ra,0x5
    80001878:	f52080e7          	jalr	-174(ra) # 800067c6 <acquire>
  p->xstate = status;
    8000187c:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001880:	4795                	li	a5,5
    80001882:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	00e080e7          	jalr	14(ra) # 80006896 <release>
  sched();
    80001890:	00000097          	auipc	ra,0x0
    80001894:	cfc080e7          	jalr	-772(ra) # 8000158c <sched>
  panic("zombie exit");
    80001898:	00007517          	auipc	a0,0x7
    8000189c:	99850513          	addi	a0,a0,-1640 # 80008230 <etext+0x230>
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	9f2080e7          	jalr	-1550(ra) # 80006292 <panic>

00000000800018a8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	1800                	addi	s0,sp,48
    800018b6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018b8:	00007497          	auipc	s1,0x7
    800018bc:	6d848493          	addi	s1,s1,1752 # 80008f90 <proc>
    800018c0:	0000d997          	auipc	s3,0xd
    800018c4:	2d098993          	addi	s3,s3,720 # 8000eb90 <tickslock>
    acquire(&p->lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	efc080e7          	jalr	-260(ra) # 800067c6 <acquire>
    if(p->pid == pid){
    800018d2:	5c9c                	lw	a5,56(s1)
    800018d4:	01278d63          	beq	a5,s2,800018ee <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	fbc080e7          	jalr	-68(ra) # 80006896 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018e2:	17048493          	addi	s1,s1,368
    800018e6:	ff3491e3          	bne	s1,s3,800018c8 <kill+0x20>
  }
  return -1;
    800018ea:	557d                	li	a0,-1
    800018ec:	a829                	j	80001906 <kill+0x5e>
      p->killed = 1;
    800018ee:	4785                	li	a5,1
    800018f0:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800018f2:	5098                	lw	a4,32(s1)
    800018f4:	4789                	li	a5,2
    800018f6:	00f70f63          	beq	a4,a5,80001914 <kill+0x6c>
      release(&p->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	f9a080e7          	jalr	-102(ra) # 80006896 <release>
      return 0;
    80001904:	4501                	li	a0,0
}
    80001906:	70a2                	ld	ra,40(sp)
    80001908:	7402                	ld	s0,32(sp)
    8000190a:	64e2                	ld	s1,24(sp)
    8000190c:	6942                	ld	s2,16(sp)
    8000190e:	69a2                	ld	s3,8(sp)
    80001910:	6145                	addi	sp,sp,48
    80001912:	8082                	ret
        p->state = RUNNABLE;
    80001914:	478d                	li	a5,3
    80001916:	d09c                	sw	a5,32(s1)
    80001918:	b7cd                	j	800018fa <kill+0x52>

000000008000191a <setkilled>:

void
setkilled(struct proc *p)
{
    8000191a:	1101                	addi	sp,sp,-32
    8000191c:	ec06                	sd	ra,24(sp)
    8000191e:	e822                	sd	s0,16(sp)
    80001920:	e426                	sd	s1,8(sp)
    80001922:	1000                	addi	s0,sp,32
    80001924:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	ea0080e7          	jalr	-352(ra) # 800067c6 <acquire>
  p->killed = 1;
    8000192e:	4785                	li	a5,1
    80001930:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00005097          	auipc	ra,0x5
    80001938:	f62080e7          	jalr	-158(ra) # 80006896 <release>
}
    8000193c:	60e2                	ld	ra,24(sp)
    8000193e:	6442                	ld	s0,16(sp)
    80001940:	64a2                	ld	s1,8(sp)
    80001942:	6105                	addi	sp,sp,32
    80001944:	8082                	ret

0000000080001946 <killed>:

int
killed(struct proc *p)
{
    80001946:	1101                	addi	sp,sp,-32
    80001948:	ec06                	sd	ra,24(sp)
    8000194a:	e822                	sd	s0,16(sp)
    8000194c:	e426                	sd	s1,8(sp)
    8000194e:	e04a                	sd	s2,0(sp)
    80001950:	1000                	addi	s0,sp,32
    80001952:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001954:	00005097          	auipc	ra,0x5
    80001958:	e72080e7          	jalr	-398(ra) # 800067c6 <acquire>
  k = p->killed;
    8000195c:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    80001960:	8526                	mv	a0,s1
    80001962:	00005097          	auipc	ra,0x5
    80001966:	f34080e7          	jalr	-204(ra) # 80006896 <release>
  return k;
}
    8000196a:	854a                	mv	a0,s2
    8000196c:	60e2                	ld	ra,24(sp)
    8000196e:	6442                	ld	s0,16(sp)
    80001970:	64a2                	ld	s1,8(sp)
    80001972:	6902                	ld	s2,0(sp)
    80001974:	6105                	addi	sp,sp,32
    80001976:	8082                	ret

0000000080001978 <wait>:
{
    80001978:	715d                	addi	sp,sp,-80
    8000197a:	e486                	sd	ra,72(sp)
    8000197c:	e0a2                	sd	s0,64(sp)
    8000197e:	fc26                	sd	s1,56(sp)
    80001980:	f84a                	sd	s2,48(sp)
    80001982:	f44e                	sd	s3,40(sp)
    80001984:	f052                	sd	s4,32(sp)
    80001986:	ec56                	sd	s5,24(sp)
    80001988:	e85a                	sd	s6,16(sp)
    8000198a:	e45e                	sd	s7,8(sp)
    8000198c:	e062                	sd	s8,0(sp)
    8000198e:	0880                	addi	s0,sp,80
    80001990:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	664080e7          	jalr	1636(ra) # 80000ff6 <myproc>
    8000199a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000199c:	00007517          	auipc	a0,0x7
    800019a0:	1d450513          	addi	a0,a0,468 # 80008b70 <wait_lock>
    800019a4:	00005097          	auipc	ra,0x5
    800019a8:	e22080e7          	jalr	-478(ra) # 800067c6 <acquire>
    havekids = 0;
    800019ac:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019ae:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019b0:	0000d997          	auipc	s3,0xd
    800019b4:	1e098993          	addi	s3,s3,480 # 8000eb90 <tickslock>
        havekids = 1;
    800019b8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019ba:	00007c17          	auipc	s8,0x7
    800019be:	1b6c0c13          	addi	s8,s8,438 # 80008b70 <wait_lock>
    havekids = 0;
    800019c2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019c4:	00007497          	auipc	s1,0x7
    800019c8:	5cc48493          	addi	s1,s1,1484 # 80008f90 <proc>
    800019cc:	a0bd                	j	80001a3a <wait+0xc2>
          pid = pp->pid;
    800019ce:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019d2:	000b0e63          	beqz	s6,800019ee <wait+0x76>
    800019d6:	4691                	li	a3,4
    800019d8:	03448613          	addi	a2,s1,52
    800019dc:	85da                	mv	a1,s6
    800019de:	05893503          	ld	a0,88(s2)
    800019e2:	fffff097          	auipc	ra,0xfffff
    800019e6:	29e080e7          	jalr	670(ra) # 80000c80 <copyout>
    800019ea:	02054563          	bltz	a0,80001a14 <wait+0x9c>
          freeproc(pp);
    800019ee:	8526                	mv	a0,s1
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	7bc080e7          	jalr	1980(ra) # 800011ac <freeproc>
          release(&pp->lock);
    800019f8:	8526                	mv	a0,s1
    800019fa:	00005097          	auipc	ra,0x5
    800019fe:	e9c080e7          	jalr	-356(ra) # 80006896 <release>
          release(&wait_lock);
    80001a02:	00007517          	auipc	a0,0x7
    80001a06:	16e50513          	addi	a0,a0,366 # 80008b70 <wait_lock>
    80001a0a:	00005097          	auipc	ra,0x5
    80001a0e:	e8c080e7          	jalr	-372(ra) # 80006896 <release>
          return pid;
    80001a12:	a0b5                	j	80001a7e <wait+0x106>
            release(&pp->lock);
    80001a14:	8526                	mv	a0,s1
    80001a16:	00005097          	auipc	ra,0x5
    80001a1a:	e80080e7          	jalr	-384(ra) # 80006896 <release>
            release(&wait_lock);
    80001a1e:	00007517          	auipc	a0,0x7
    80001a22:	15250513          	addi	a0,a0,338 # 80008b70 <wait_lock>
    80001a26:	00005097          	auipc	ra,0x5
    80001a2a:	e70080e7          	jalr	-400(ra) # 80006896 <release>
            return -1;
    80001a2e:	59fd                	li	s3,-1
    80001a30:	a0b9                	j	80001a7e <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a32:	17048493          	addi	s1,s1,368
    80001a36:	03348463          	beq	s1,s3,80001a5e <wait+0xe6>
      if(pp->parent == p){
    80001a3a:	60bc                	ld	a5,64(s1)
    80001a3c:	ff279be3          	bne	a5,s2,80001a32 <wait+0xba>
        acquire(&pp->lock);
    80001a40:	8526                	mv	a0,s1
    80001a42:	00005097          	auipc	ra,0x5
    80001a46:	d84080e7          	jalr	-636(ra) # 800067c6 <acquire>
        if(pp->state == ZOMBIE){
    80001a4a:	509c                	lw	a5,32(s1)
    80001a4c:	f94781e3          	beq	a5,s4,800019ce <wait+0x56>
        release(&pp->lock);
    80001a50:	8526                	mv	a0,s1
    80001a52:	00005097          	auipc	ra,0x5
    80001a56:	e44080e7          	jalr	-444(ra) # 80006896 <release>
        havekids = 1;
    80001a5a:	8756                	mv	a4,s5
    80001a5c:	bfd9                	j	80001a32 <wait+0xba>
    if(!havekids || killed(p)){
    80001a5e:	c719                	beqz	a4,80001a6c <wait+0xf4>
    80001a60:	854a                	mv	a0,s2
    80001a62:	00000097          	auipc	ra,0x0
    80001a66:	ee4080e7          	jalr	-284(ra) # 80001946 <killed>
    80001a6a:	c51d                	beqz	a0,80001a98 <wait+0x120>
      release(&wait_lock);
    80001a6c:	00007517          	auipc	a0,0x7
    80001a70:	10450513          	addi	a0,a0,260 # 80008b70 <wait_lock>
    80001a74:	00005097          	auipc	ra,0x5
    80001a78:	e22080e7          	jalr	-478(ra) # 80006896 <release>
      return -1;
    80001a7c:	59fd                	li	s3,-1
}
    80001a7e:	854e                	mv	a0,s3
    80001a80:	60a6                	ld	ra,72(sp)
    80001a82:	6406                	ld	s0,64(sp)
    80001a84:	74e2                	ld	s1,56(sp)
    80001a86:	7942                	ld	s2,48(sp)
    80001a88:	79a2                	ld	s3,40(sp)
    80001a8a:	7a02                	ld	s4,32(sp)
    80001a8c:	6ae2                	ld	s5,24(sp)
    80001a8e:	6b42                	ld	s6,16(sp)
    80001a90:	6ba2                	ld	s7,8(sp)
    80001a92:	6c02                	ld	s8,0(sp)
    80001a94:	6161                	addi	sp,sp,80
    80001a96:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a98:	85e2                	mv	a1,s8
    80001a9a:	854a                	mv	a0,s2
    80001a9c:	00000097          	auipc	ra,0x0
    80001aa0:	c02080e7          	jalr	-1022(ra) # 8000169e <sleep>
    havekids = 0;
    80001aa4:	bf39                	j	800019c2 <wait+0x4a>

0000000080001aa6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aa6:	7179                	addi	sp,sp,-48
    80001aa8:	f406                	sd	ra,40(sp)
    80001aaa:	f022                	sd	s0,32(sp)
    80001aac:	ec26                	sd	s1,24(sp)
    80001aae:	e84a                	sd	s2,16(sp)
    80001ab0:	e44e                	sd	s3,8(sp)
    80001ab2:	e052                	sd	s4,0(sp)
    80001ab4:	1800                	addi	s0,sp,48
    80001ab6:	84aa                	mv	s1,a0
    80001ab8:	892e                	mv	s2,a1
    80001aba:	89b2                	mv	s3,a2
    80001abc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	538080e7          	jalr	1336(ra) # 80000ff6 <myproc>
  if(user_dst){
    80001ac6:	c08d                	beqz	s1,80001ae8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ac8:	86d2                	mv	a3,s4
    80001aca:	864e                	mv	a2,s3
    80001acc:	85ca                	mv	a1,s2
    80001ace:	6d28                	ld	a0,88(a0)
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	1b0080e7          	jalr	432(ra) # 80000c80 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ad8:	70a2                	ld	ra,40(sp)
    80001ada:	7402                	ld	s0,32(sp)
    80001adc:	64e2                	ld	s1,24(sp)
    80001ade:	6942                	ld	s2,16(sp)
    80001ae0:	69a2                	ld	s3,8(sp)
    80001ae2:	6a02                	ld	s4,0(sp)
    80001ae4:	6145                	addi	sp,sp,48
    80001ae6:	8082                	ret
    memmove((char *)dst, src, len);
    80001ae8:	000a061b          	sext.w	a2,s4
    80001aec:	85ce                	mv	a1,s3
    80001aee:	854a                	mv	a0,s2
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	81e080e7          	jalr	-2018(ra) # 8000030e <memmove>
    return 0;
    80001af8:	8526                	mv	a0,s1
    80001afa:	bff9                	j	80001ad8 <either_copyout+0x32>

0000000080001afc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001afc:	7179                	addi	sp,sp,-48
    80001afe:	f406                	sd	ra,40(sp)
    80001b00:	f022                	sd	s0,32(sp)
    80001b02:	ec26                	sd	s1,24(sp)
    80001b04:	e84a                	sd	s2,16(sp)
    80001b06:	e44e                	sd	s3,8(sp)
    80001b08:	e052                	sd	s4,0(sp)
    80001b0a:	1800                	addi	s0,sp,48
    80001b0c:	892a                	mv	s2,a0
    80001b0e:	84ae                	mv	s1,a1
    80001b10:	89b2                	mv	s3,a2
    80001b12:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b14:	fffff097          	auipc	ra,0xfffff
    80001b18:	4e2080e7          	jalr	1250(ra) # 80000ff6 <myproc>
  if(user_src){
    80001b1c:	c08d                	beqz	s1,80001b3e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b1e:	86d2                	mv	a3,s4
    80001b20:	864e                	mv	a2,s3
    80001b22:	85ca                	mv	a1,s2
    80001b24:	6d28                	ld	a0,88(a0)
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	21a080e7          	jalr	538(ra) # 80000d40 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b2e:	70a2                	ld	ra,40(sp)
    80001b30:	7402                	ld	s0,32(sp)
    80001b32:	64e2                	ld	s1,24(sp)
    80001b34:	6942                	ld	s2,16(sp)
    80001b36:	69a2                	ld	s3,8(sp)
    80001b38:	6a02                	ld	s4,0(sp)
    80001b3a:	6145                	addi	sp,sp,48
    80001b3c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b3e:	000a061b          	sext.w	a2,s4
    80001b42:	85ce                	mv	a1,s3
    80001b44:	854a                	mv	a0,s2
    80001b46:	ffffe097          	auipc	ra,0xffffe
    80001b4a:	7c8080e7          	jalr	1992(ra) # 8000030e <memmove>
    return 0;
    80001b4e:	8526                	mv	a0,s1
    80001b50:	bff9                	j	80001b2e <either_copyin+0x32>

0000000080001b52 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b52:	715d                	addi	sp,sp,-80
    80001b54:	e486                	sd	ra,72(sp)
    80001b56:	e0a2                	sd	s0,64(sp)
    80001b58:	fc26                	sd	s1,56(sp)
    80001b5a:	f84a                	sd	s2,48(sp)
    80001b5c:	f44e                	sd	s3,40(sp)
    80001b5e:	f052                	sd	s4,32(sp)
    80001b60:	ec56                	sd	s5,24(sp)
    80001b62:	e85a                	sd	s6,16(sp)
    80001b64:	e45e                	sd	s7,8(sp)
    80001b66:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b68:	00007517          	auipc	a0,0x7
    80001b6c:	d9050513          	addi	a0,a0,-624 # 800088f8 <digits+0x88>
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	76c080e7          	jalr	1900(ra) # 800062dc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b78:	00007497          	auipc	s1,0x7
    80001b7c:	57848493          	addi	s1,s1,1400 # 800090f0 <proc+0x160>
    80001b80:	0000d917          	auipc	s2,0xd
    80001b84:	17090913          	addi	s2,s2,368 # 8000ecf0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b88:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b8a:	00006997          	auipc	s3,0x6
    80001b8e:	6b698993          	addi	s3,s3,1718 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001b92:	00006a97          	auipc	s5,0x6
    80001b96:	6b6a8a93          	addi	s5,s5,1718 # 80008248 <etext+0x248>
    printf("\n");
    80001b9a:	00007a17          	auipc	s4,0x7
    80001b9e:	d5ea0a13          	addi	s4,s4,-674 # 800088f8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba2:	00006b97          	auipc	s7,0x6
    80001ba6:	6e6b8b93          	addi	s7,s7,1766 # 80008288 <states.1739>
    80001baa:	a00d                	j	80001bcc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bac:	ed86a583          	lw	a1,-296(a3)
    80001bb0:	8556                	mv	a0,s5
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	72a080e7          	jalr	1834(ra) # 800062dc <printf>
    printf("\n");
    80001bba:	8552                	mv	a0,s4
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	720080e7          	jalr	1824(ra) # 800062dc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bc4:	17048493          	addi	s1,s1,368
    80001bc8:	03248163          	beq	s1,s2,80001bea <procdump+0x98>
    if(p->state == UNUSED)
    80001bcc:	86a6                	mv	a3,s1
    80001bce:	ec04a783          	lw	a5,-320(s1)
    80001bd2:	dbed                	beqz	a5,80001bc4 <procdump+0x72>
      state = "???";
    80001bd4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd6:	fcfb6be3          	bltu	s6,a5,80001bac <procdump+0x5a>
    80001bda:	1782                	slli	a5,a5,0x20
    80001bdc:	9381                	srli	a5,a5,0x20
    80001bde:	078e                	slli	a5,a5,0x3
    80001be0:	97de                	add	a5,a5,s7
    80001be2:	6390                	ld	a2,0(a5)
    80001be4:	f661                	bnez	a2,80001bac <procdump+0x5a>
      state = "???";
    80001be6:	864e                	mv	a2,s3
    80001be8:	b7d1                	j	80001bac <procdump+0x5a>
  }
}
    80001bea:	60a6                	ld	ra,72(sp)
    80001bec:	6406                	ld	s0,64(sp)
    80001bee:	74e2                	ld	s1,56(sp)
    80001bf0:	7942                	ld	s2,48(sp)
    80001bf2:	79a2                	ld	s3,40(sp)
    80001bf4:	7a02                	ld	s4,32(sp)
    80001bf6:	6ae2                	ld	s5,24(sp)
    80001bf8:	6b42                	ld	s6,16(sp)
    80001bfa:	6ba2                	ld	s7,8(sp)
    80001bfc:	6161                	addi	sp,sp,80
    80001bfe:	8082                	ret

0000000080001c00 <swtch>:
    80001c00:	00153023          	sd	ra,0(a0)
    80001c04:	00253423          	sd	sp,8(a0)
    80001c08:	e900                	sd	s0,16(a0)
    80001c0a:	ed04                	sd	s1,24(a0)
    80001c0c:	03253023          	sd	s2,32(a0)
    80001c10:	03353423          	sd	s3,40(a0)
    80001c14:	03453823          	sd	s4,48(a0)
    80001c18:	03553c23          	sd	s5,56(a0)
    80001c1c:	05653023          	sd	s6,64(a0)
    80001c20:	05753423          	sd	s7,72(a0)
    80001c24:	05853823          	sd	s8,80(a0)
    80001c28:	05953c23          	sd	s9,88(a0)
    80001c2c:	07a53023          	sd	s10,96(a0)
    80001c30:	07b53423          	sd	s11,104(a0)
    80001c34:	0005b083          	ld	ra,0(a1)
    80001c38:	0085b103          	ld	sp,8(a1)
    80001c3c:	6980                	ld	s0,16(a1)
    80001c3e:	6d84                	ld	s1,24(a1)
    80001c40:	0205b903          	ld	s2,32(a1)
    80001c44:	0285b983          	ld	s3,40(a1)
    80001c48:	0305ba03          	ld	s4,48(a1)
    80001c4c:	0385ba83          	ld	s5,56(a1)
    80001c50:	0405bb03          	ld	s6,64(a1)
    80001c54:	0485bb83          	ld	s7,72(a1)
    80001c58:	0505bc03          	ld	s8,80(a1)
    80001c5c:	0585bc83          	ld	s9,88(a1)
    80001c60:	0605bd03          	ld	s10,96(a1)
    80001c64:	0685bd83          	ld	s11,104(a1)
    80001c68:	8082                	ret

0000000080001c6a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c6a:	1141                	addi	sp,sp,-16
    80001c6c:	e406                	sd	ra,8(sp)
    80001c6e:	e022                	sd	s0,0(sp)
    80001c70:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c72:	00006597          	auipc	a1,0x6
    80001c76:	64658593          	addi	a1,a1,1606 # 800082b8 <states.1739+0x30>
    80001c7a:	0000d517          	auipc	a0,0xd
    80001c7e:	f1650513          	addi	a0,a0,-234 # 8000eb90 <tickslock>
    80001c82:	00005097          	auipc	ra,0x5
    80001c86:	cc0080e7          	jalr	-832(ra) # 80006942 <initlock>
}
    80001c8a:	60a2                	ld	ra,8(sp)
    80001c8c:	6402                	ld	s0,0(sp)
    80001c8e:	0141                	addi	sp,sp,16
    80001c90:	8082                	ret

0000000080001c92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c92:	1141                	addi	sp,sp,-16
    80001c94:	e422                	sd	s0,8(sp)
    80001c96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c98:	00003797          	auipc	a5,0x3
    80001c9c:	65878793          	addi	a5,a5,1624 # 800052f0 <kernelvec>
    80001ca0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ca4:	6422                	ld	s0,8(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001caa:	1141                	addi	sp,sp,-16
    80001cac:	e406                	sd	ra,8(sp)
    80001cae:	e022                	sd	s0,0(sp)
    80001cb0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	344080e7          	jalr	836(ra) # 80000ff6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cbe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cc4:	00005617          	auipc	a2,0x5
    80001cc8:	33c60613          	addi	a2,a2,828 # 80007000 <_trampoline>
    80001ccc:	00005697          	auipc	a3,0x5
    80001cd0:	33468693          	addi	a3,a3,820 # 80007000 <_trampoline>
    80001cd4:	8e91                	sub	a3,a3,a2
    80001cd6:	040007b7          	lui	a5,0x4000
    80001cda:	17fd                	addi	a5,a5,-1
    80001cdc:	07b2                	slli	a5,a5,0xc
    80001cde:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ce0:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ce4:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ce6:	180026f3          	csrr	a3,satp
    80001cea:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cec:	7138                	ld	a4,96(a0)
    80001cee:	6534                	ld	a3,72(a0)
    80001cf0:	6585                	lui	a1,0x1
    80001cf2:	96ae                	add	a3,a3,a1
    80001cf4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cf6:	7138                	ld	a4,96(a0)
    80001cf8:	00000697          	auipc	a3,0x0
    80001cfc:	13068693          	addi	a3,a3,304 # 80001e28 <usertrap>
    80001d00:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d02:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d04:	8692                	mv	a3,tp
    80001d06:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d0c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d10:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d14:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d18:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d1a:	6f18                	ld	a4,24(a4)
    80001d1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d20:	6d28                	ld	a0,88(a0)
    80001d22:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d24:	00005717          	auipc	a4,0x5
    80001d28:	37870713          	addi	a4,a4,888 # 8000709c <userret>
    80001d2c:	8f11                	sub	a4,a4,a2
    80001d2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d30:	577d                	li	a4,-1
    80001d32:	177e                	slli	a4,a4,0x3f
    80001d34:	8d59                	or	a0,a0,a4
    80001d36:	9782                	jalr	a5
}
    80001d38:	60a2                	ld	ra,8(sp)
    80001d3a:	6402                	ld	s0,0(sp)
    80001d3c:	0141                	addi	sp,sp,16
    80001d3e:	8082                	ret

0000000080001d40 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d4a:	0000d497          	auipc	s1,0xd
    80001d4e:	e4648493          	addi	s1,s1,-442 # 8000eb90 <tickslock>
    80001d52:	8526                	mv	a0,s1
    80001d54:	00005097          	auipc	ra,0x5
    80001d58:	a72080e7          	jalr	-1422(ra) # 800067c6 <acquire>
  ticks++;
    80001d5c:	00007517          	auipc	a0,0x7
    80001d60:	c8c50513          	addi	a0,a0,-884 # 800089e8 <ticks>
    80001d64:	411c                	lw	a5,0(a0)
    80001d66:	2785                	addiw	a5,a5,1
    80001d68:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	998080e7          	jalr	-1640(ra) # 80001702 <wakeup>
  release(&tickslock);
    80001d72:	8526                	mv	a0,s1
    80001d74:	00005097          	auipc	ra,0x5
    80001d78:	b22080e7          	jalr	-1246(ra) # 80006896 <release>
}
    80001d7c:	60e2                	ld	ra,24(sp)
    80001d7e:	6442                	ld	s0,16(sp)
    80001d80:	64a2                	ld	s1,8(sp)
    80001d82:	6105                	addi	sp,sp,32
    80001d84:	8082                	ret

0000000080001d86 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	e426                	sd	s1,8(sp)
    80001d8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d90:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d94:	00074d63          	bltz	a4,80001dae <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d98:	57fd                	li	a5,-1
    80001d9a:	17fe                	slli	a5,a5,0x3f
    80001d9c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d9e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001da0:	06f70363          	beq	a4,a5,80001e06 <devintr+0x80>
  }
}
    80001da4:	60e2                	ld	ra,24(sp)
    80001da6:	6442                	ld	s0,16(sp)
    80001da8:	64a2                	ld	s1,8(sp)
    80001daa:	6105                	addi	sp,sp,32
    80001dac:	8082                	ret
     (scause & 0xff) == 9){
    80001dae:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001db2:	46a5                	li	a3,9
    80001db4:	fed792e3          	bne	a5,a3,80001d98 <devintr+0x12>
    int irq = plic_claim();
    80001db8:	00003097          	auipc	ra,0x3
    80001dbc:	640080e7          	jalr	1600(ra) # 800053f8 <plic_claim>
    80001dc0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dc2:	47a9                	li	a5,10
    80001dc4:	02f50763          	beq	a0,a5,80001df2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dc8:	4785                	li	a5,1
    80001dca:	02f50963          	beq	a0,a5,80001dfc <devintr+0x76>
    return 1;
    80001dce:	4505                	li	a0,1
    } else if(irq){
    80001dd0:	d8f1                	beqz	s1,80001da4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dd2:	85a6                	mv	a1,s1
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	4ec50513          	addi	a0,a0,1260 # 800082c0 <states.1739+0x38>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	500080e7          	jalr	1280(ra) # 800062dc <printf>
      plic_complete(irq);
    80001de4:	8526                	mv	a0,s1
    80001de6:	00003097          	auipc	ra,0x3
    80001dea:	636080e7          	jalr	1590(ra) # 8000541c <plic_complete>
    return 1;
    80001dee:	4505                	li	a0,1
    80001df0:	bf55                	j	80001da4 <devintr+0x1e>
      uartintr();
    80001df2:	00005097          	auipc	ra,0x5
    80001df6:	90a080e7          	jalr	-1782(ra) # 800066fc <uartintr>
    80001dfa:	b7ed                	j	80001de4 <devintr+0x5e>
      virtio_disk_intr();
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	b86080e7          	jalr	-1146(ra) # 80005982 <virtio_disk_intr>
    80001e04:	b7c5                	j	80001de4 <devintr+0x5e>
    if(cpuid() == 0){
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	1c4080e7          	jalr	452(ra) # 80000fca <cpuid>
    80001e0e:	c901                	beqz	a0,80001e1e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e10:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e14:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e16:	14479073          	csrw	sip,a5
    return 2;
    80001e1a:	4509                	li	a0,2
    80001e1c:	b761                	j	80001da4 <devintr+0x1e>
      clockintr();
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	f22080e7          	jalr	-222(ra) # 80001d40 <clockintr>
    80001e26:	b7ed                	j	80001e10 <devintr+0x8a>

0000000080001e28 <usertrap>:
{
    80001e28:	1101                	addi	sp,sp,-32
    80001e2a:	ec06                	sd	ra,24(sp)
    80001e2c:	e822                	sd	s0,16(sp)
    80001e2e:	e426                	sd	s1,8(sp)
    80001e30:	e04a                	sd	s2,0(sp)
    80001e32:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e34:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e38:	1007f793          	andi	a5,a5,256
    80001e3c:	e3b1                	bnez	a5,80001e80 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e3e:	00003797          	auipc	a5,0x3
    80001e42:	4b278793          	addi	a5,a5,1202 # 800052f0 <kernelvec>
    80001e46:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	1ac080e7          	jalr	428(ra) # 80000ff6 <myproc>
    80001e52:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e54:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e56:	14102773          	csrr	a4,sepc
    80001e5a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e60:	47a1                	li	a5,8
    80001e62:	02f70763          	beq	a4,a5,80001e90 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	f20080e7          	jalr	-224(ra) # 80001d86 <devintr>
    80001e6e:	892a                	mv	s2,a0
    80001e70:	c151                	beqz	a0,80001ef4 <usertrap+0xcc>
  if(killed(p))
    80001e72:	8526                	mv	a0,s1
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	ad2080e7          	jalr	-1326(ra) # 80001946 <killed>
    80001e7c:	c929                	beqz	a0,80001ece <usertrap+0xa6>
    80001e7e:	a099                	j	80001ec4 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e80:	00006517          	auipc	a0,0x6
    80001e84:	46050513          	addi	a0,a0,1120 # 800082e0 <states.1739+0x58>
    80001e88:	00004097          	auipc	ra,0x4
    80001e8c:	40a080e7          	jalr	1034(ra) # 80006292 <panic>
    if(killed(p))
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	ab6080e7          	jalr	-1354(ra) # 80001946 <killed>
    80001e98:	e921                	bnez	a0,80001ee8 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e9a:	70b8                	ld	a4,96(s1)
    80001e9c:	6f1c                	ld	a5,24(a4)
    80001e9e:	0791                	addi	a5,a5,4
    80001ea0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ea6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eaa:	10079073          	csrw	sstatus,a5
    syscall();
    80001eae:	00000097          	auipc	ra,0x0
    80001eb2:	2d4080e7          	jalr	724(ra) # 80002182 <syscall>
  if(killed(p))
    80001eb6:	8526                	mv	a0,s1
    80001eb8:	00000097          	auipc	ra,0x0
    80001ebc:	a8e080e7          	jalr	-1394(ra) # 80001946 <killed>
    80001ec0:	c911                	beqz	a0,80001ed4 <usertrap+0xac>
    80001ec2:	4901                	li	s2,0
    exit(-1);
    80001ec4:	557d                	li	a0,-1
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	90c080e7          	jalr	-1780(ra) # 800017d2 <exit>
  if(which_dev == 2)
    80001ece:	4789                	li	a5,2
    80001ed0:	04f90f63          	beq	s2,a5,80001f2e <usertrap+0x106>
  usertrapret();
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	dd6080e7          	jalr	-554(ra) # 80001caa <usertrapret>
}
    80001edc:	60e2                	ld	ra,24(sp)
    80001ede:	6442                	ld	s0,16(sp)
    80001ee0:	64a2                	ld	s1,8(sp)
    80001ee2:	6902                	ld	s2,0(sp)
    80001ee4:	6105                	addi	sp,sp,32
    80001ee6:	8082                	ret
      exit(-1);
    80001ee8:	557d                	li	a0,-1
    80001eea:	00000097          	auipc	ra,0x0
    80001eee:	8e8080e7          	jalr	-1816(ra) # 800017d2 <exit>
    80001ef2:	b765                	j	80001e9a <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ef8:	5c90                	lw	a2,56(s1)
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	40650513          	addi	a0,a0,1030 # 80008300 <states.1739+0x78>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	3da080e7          	jalr	986(ra) # 800062dc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f0e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	41e50513          	addi	a0,a0,1054 # 80008330 <states.1739+0xa8>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	3c2080e7          	jalr	962(ra) # 800062dc <printf>
    setkilled(p);
    80001f22:	8526                	mv	a0,s1
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	9f6080e7          	jalr	-1546(ra) # 8000191a <setkilled>
    80001f2c:	b769                	j	80001eb6 <usertrap+0x8e>
    yield();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	734080e7          	jalr	1844(ra) # 80001662 <yield>
    80001f36:	bf79                	j	80001ed4 <usertrap+0xac>

0000000080001f38 <kerneltrap>:
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	e44e                	sd	s3,8(sp)
    80001f44:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f46:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f4e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f52:	1004f793          	andi	a5,s1,256
    80001f56:	cb85                	beqz	a5,80001f86 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f58:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f5c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f5e:	ef85                	bnez	a5,80001f96 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	e26080e7          	jalr	-474(ra) # 80001d86 <devintr>
    80001f68:	cd1d                	beqz	a0,80001fa6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f6a:	4789                	li	a5,2
    80001f6c:	06f50a63          	beq	a0,a5,80001fe0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f70:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f74:	10049073          	csrw	sstatus,s1
}
    80001f78:	70a2                	ld	ra,40(sp)
    80001f7a:	7402                	ld	s0,32(sp)
    80001f7c:	64e2                	ld	s1,24(sp)
    80001f7e:	6942                	ld	s2,16(sp)
    80001f80:	69a2                	ld	s3,8(sp)
    80001f82:	6145                	addi	sp,sp,48
    80001f84:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f86:	00006517          	auipc	a0,0x6
    80001f8a:	3ca50513          	addi	a0,a0,970 # 80008350 <states.1739+0xc8>
    80001f8e:	00004097          	auipc	ra,0x4
    80001f92:	304080e7          	jalr	772(ra) # 80006292 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f96:	00006517          	auipc	a0,0x6
    80001f9a:	3e250513          	addi	a0,a0,994 # 80008378 <states.1739+0xf0>
    80001f9e:	00004097          	auipc	ra,0x4
    80001fa2:	2f4080e7          	jalr	756(ra) # 80006292 <panic>
    printf("scause %p\n", scause);
    80001fa6:	85ce                	mv	a1,s3
    80001fa8:	00006517          	auipc	a0,0x6
    80001fac:	3f050513          	addi	a0,a0,1008 # 80008398 <states.1739+0x110>
    80001fb0:	00004097          	auipc	ra,0x4
    80001fb4:	32c080e7          	jalr	812(ra) # 800062dc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fbc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fc0:	00006517          	auipc	a0,0x6
    80001fc4:	3e850513          	addi	a0,a0,1000 # 800083a8 <states.1739+0x120>
    80001fc8:	00004097          	auipc	ra,0x4
    80001fcc:	314080e7          	jalr	788(ra) # 800062dc <printf>
    panic("kerneltrap");
    80001fd0:	00006517          	auipc	a0,0x6
    80001fd4:	3f050513          	addi	a0,a0,1008 # 800083c0 <states.1739+0x138>
    80001fd8:	00004097          	auipc	ra,0x4
    80001fdc:	2ba080e7          	jalr	698(ra) # 80006292 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	016080e7          	jalr	22(ra) # 80000ff6 <myproc>
    80001fe8:	d541                	beqz	a0,80001f70 <kerneltrap+0x38>
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	00c080e7          	jalr	12(ra) # 80000ff6 <myproc>
    80001ff2:	5118                	lw	a4,32(a0)
    80001ff4:	4791                	li	a5,4
    80001ff6:	f6f71de3          	bne	a4,a5,80001f70 <kerneltrap+0x38>
    yield();
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	668080e7          	jalr	1640(ra) # 80001662 <yield>
    80002002:	b7bd                	j	80001f70 <kerneltrap+0x38>

0000000080002004 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	fe6080e7          	jalr	-26(ra) # 80000ff6 <myproc>
  switch (n) {
    80002018:	4795                	li	a5,5
    8000201a:	0497e163          	bltu	a5,s1,8000205c <argraw+0x58>
    8000201e:	048a                	slli	s1,s1,0x2
    80002020:	00006717          	auipc	a4,0x6
    80002024:	3d870713          	addi	a4,a4,984 # 800083f8 <states.1739+0x170>
    80002028:	94ba                	add	s1,s1,a4
    8000202a:	409c                	lw	a5,0(s1)
    8000202c:	97ba                	add	a5,a5,a4
    8000202e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002030:	713c                	ld	a5,96(a0)
    80002032:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6105                	addi	sp,sp,32
    8000203c:	8082                	ret
    return p->trapframe->a1;
    8000203e:	713c                	ld	a5,96(a0)
    80002040:	7fa8                	ld	a0,120(a5)
    80002042:	bfcd                	j	80002034 <argraw+0x30>
    return p->trapframe->a2;
    80002044:	713c                	ld	a5,96(a0)
    80002046:	63c8                	ld	a0,128(a5)
    80002048:	b7f5                	j	80002034 <argraw+0x30>
    return p->trapframe->a3;
    8000204a:	713c                	ld	a5,96(a0)
    8000204c:	67c8                	ld	a0,136(a5)
    8000204e:	b7dd                	j	80002034 <argraw+0x30>
    return p->trapframe->a4;
    80002050:	713c                	ld	a5,96(a0)
    80002052:	6bc8                	ld	a0,144(a5)
    80002054:	b7c5                	j	80002034 <argraw+0x30>
    return p->trapframe->a5;
    80002056:	713c                	ld	a5,96(a0)
    80002058:	6fc8                	ld	a0,152(a5)
    8000205a:	bfe9                	j	80002034 <argraw+0x30>
  panic("argraw");
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	37450513          	addi	a0,a0,884 # 800083d0 <states.1739+0x148>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	22e080e7          	jalr	558(ra) # 80006292 <panic>

000000008000206c <fetchaddr>:
{
    8000206c:	1101                	addi	sp,sp,-32
    8000206e:	ec06                	sd	ra,24(sp)
    80002070:	e822                	sd	s0,16(sp)
    80002072:	e426                	sd	s1,8(sp)
    80002074:	e04a                	sd	s2,0(sp)
    80002076:	1000                	addi	s0,sp,32
    80002078:	84aa                	mv	s1,a0
    8000207a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	f7a080e7          	jalr	-134(ra) # 80000ff6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002084:	693c                	ld	a5,80(a0)
    80002086:	02f4f863          	bgeu	s1,a5,800020b6 <fetchaddr+0x4a>
    8000208a:	00848713          	addi	a4,s1,8
    8000208e:	02e7e663          	bltu	a5,a4,800020ba <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002092:	46a1                	li	a3,8
    80002094:	8626                	mv	a2,s1
    80002096:	85ca                	mv	a1,s2
    80002098:	6d28                	ld	a0,88(a0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	ca6080e7          	jalr	-858(ra) # 80000d40 <copyin>
    800020a2:	00a03533          	snez	a0,a0
    800020a6:	40a00533          	neg	a0,a0
}
    800020aa:	60e2                	ld	ra,24(sp)
    800020ac:	6442                	ld	s0,16(sp)
    800020ae:	64a2                	ld	s1,8(sp)
    800020b0:	6902                	ld	s2,0(sp)
    800020b2:	6105                	addi	sp,sp,32
    800020b4:	8082                	ret
    return -1;
    800020b6:	557d                	li	a0,-1
    800020b8:	bfcd                	j	800020aa <fetchaddr+0x3e>
    800020ba:	557d                	li	a0,-1
    800020bc:	b7fd                	j	800020aa <fetchaddr+0x3e>

00000000800020be <fetchstr>:
{
    800020be:	7179                	addi	sp,sp,-48
    800020c0:	f406                	sd	ra,40(sp)
    800020c2:	f022                	sd	s0,32(sp)
    800020c4:	ec26                	sd	s1,24(sp)
    800020c6:	e84a                	sd	s2,16(sp)
    800020c8:	e44e                	sd	s3,8(sp)
    800020ca:	1800                	addi	s0,sp,48
    800020cc:	892a                	mv	s2,a0
    800020ce:	84ae                	mv	s1,a1
    800020d0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	f24080e7          	jalr	-220(ra) # 80000ff6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020da:	86ce                	mv	a3,s3
    800020dc:	864a                	mv	a2,s2
    800020de:	85a6                	mv	a1,s1
    800020e0:	6d28                	ld	a0,88(a0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	cea080e7          	jalr	-790(ra) # 80000dcc <copyinstr>
    800020ea:	00054e63          	bltz	a0,80002106 <fetchstr+0x48>
  return strlen(buf);
    800020ee:	8526                	mv	a0,s1
    800020f0:	ffffe097          	auipc	ra,0xffffe
    800020f4:	342080e7          	jalr	834(ra) # 80000432 <strlen>
}
    800020f8:	70a2                	ld	ra,40(sp)
    800020fa:	7402                	ld	s0,32(sp)
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	6942                	ld	s2,16(sp)
    80002100:	69a2                	ld	s3,8(sp)
    80002102:	6145                	addi	sp,sp,48
    80002104:	8082                	ret
    return -1;
    80002106:	557d                	li	a0,-1
    80002108:	bfc5                	j	800020f8 <fetchstr+0x3a>

000000008000210a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000210a:	1101                	addi	sp,sp,-32
    8000210c:	ec06                	sd	ra,24(sp)
    8000210e:	e822                	sd	s0,16(sp)
    80002110:	e426                	sd	s1,8(sp)
    80002112:	1000                	addi	s0,sp,32
    80002114:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002116:	00000097          	auipc	ra,0x0
    8000211a:	eee080e7          	jalr	-274(ra) # 80002004 <argraw>
    8000211e:	c088                	sw	a0,0(s1)
}
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	64a2                	ld	s1,8(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000212a:	1101                	addi	sp,sp,-32
    8000212c:	ec06                	sd	ra,24(sp)
    8000212e:	e822                	sd	s0,16(sp)
    80002130:	e426                	sd	s1,8(sp)
    80002132:	1000                	addi	s0,sp,32
    80002134:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	ece080e7          	jalr	-306(ra) # 80002004 <argraw>
    8000213e:	e088                	sd	a0,0(s1)
}
    80002140:	60e2                	ld	ra,24(sp)
    80002142:	6442                	ld	s0,16(sp)
    80002144:	64a2                	ld	s1,8(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	e84a                	sd	s2,16(sp)
    80002154:	1800                	addi	s0,sp,48
    80002156:	84ae                	mv	s1,a1
    80002158:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000215a:	fd840593          	addi	a1,s0,-40
    8000215e:	00000097          	auipc	ra,0x0
    80002162:	fcc080e7          	jalr	-52(ra) # 8000212a <argaddr>
  return fetchstr(addr, buf, max);
    80002166:	864a                	mv	a2,s2
    80002168:	85a6                	mv	a1,s1
    8000216a:	fd843503          	ld	a0,-40(s0)
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f50080e7          	jalr	-176(ra) # 800020be <fetchstr>
}
    80002176:	70a2                	ld	ra,40(sp)
    80002178:	7402                	ld	s0,32(sp)
    8000217a:	64e2                	ld	s1,24(sp)
    8000217c:	6942                	ld	s2,16(sp)
    8000217e:	6145                	addi	sp,sp,48
    80002180:	8082                	ret

0000000080002182 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002182:	1101                	addi	sp,sp,-32
    80002184:	ec06                	sd	ra,24(sp)
    80002186:	e822                	sd	s0,16(sp)
    80002188:	e426                	sd	s1,8(sp)
    8000218a:	e04a                	sd	s2,0(sp)
    8000218c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	e68080e7          	jalr	-408(ra) # 80000ff6 <myproc>
    80002196:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002198:	06053903          	ld	s2,96(a0)
    8000219c:	0a893783          	ld	a5,168(s2)
    800021a0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021a4:	37fd                	addiw	a5,a5,-1
    800021a6:	4751                	li	a4,20
    800021a8:	00f76f63          	bltu	a4,a5,800021c6 <syscall+0x44>
    800021ac:	00369713          	slli	a4,a3,0x3
    800021b0:	00006797          	auipc	a5,0x6
    800021b4:	26078793          	addi	a5,a5,608 # 80008410 <syscalls>
    800021b8:	97ba                	add	a5,a5,a4
    800021ba:	639c                	ld	a5,0(a5)
    800021bc:	c789                	beqz	a5,800021c6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021be:	9782                	jalr	a5
    800021c0:	06a93823          	sd	a0,112(s2)
    800021c4:	a839                	j	800021e2 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021c6:	16048613          	addi	a2,s1,352
    800021ca:	5c8c                	lw	a1,56(s1)
    800021cc:	00006517          	auipc	a0,0x6
    800021d0:	20c50513          	addi	a0,a0,524 # 800083d8 <states.1739+0x150>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	108080e7          	jalr	264(ra) # 800062dc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021dc:	70bc                	ld	a5,96(s1)
    800021de:	577d                	li	a4,-1
    800021e0:	fbb8                	sd	a4,112(a5)
  }
}
    800021e2:	60e2                	ld	ra,24(sp)
    800021e4:	6442                	ld	s0,16(sp)
    800021e6:	64a2                	ld	s1,8(sp)
    800021e8:	6902                	ld	s2,0(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret

00000000800021ee <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021ee:	1101                	addi	sp,sp,-32
    800021f0:	ec06                	sd	ra,24(sp)
    800021f2:	e822                	sd	s0,16(sp)
    800021f4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021f6:	fec40593          	addi	a1,s0,-20
    800021fa:	4501                	li	a0,0
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	f0e080e7          	jalr	-242(ra) # 8000210a <argint>
  exit(n);
    80002204:	fec42503          	lw	a0,-20(s0)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	5ca080e7          	jalr	1482(ra) # 800017d2 <exit>
  return 0;  // not reached
}
    80002210:	4501                	li	a0,0
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret

000000008000221a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000221a:	1141                	addi	sp,sp,-16
    8000221c:	e406                	sd	ra,8(sp)
    8000221e:	e022                	sd	s0,0(sp)
    80002220:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	dd4080e7          	jalr	-556(ra) # 80000ff6 <myproc>
}
    8000222a:	5d08                	lw	a0,56(a0)
    8000222c:	60a2                	ld	ra,8(sp)
    8000222e:	6402                	ld	s0,0(sp)
    80002230:	0141                	addi	sp,sp,16
    80002232:	8082                	ret

0000000080002234 <sys_fork>:

uint64
sys_fork(void)
{
    80002234:	1141                	addi	sp,sp,-16
    80002236:	e406                	sd	ra,8(sp)
    80002238:	e022                	sd	s0,0(sp)
    8000223a:	0800                	addi	s0,sp,16
  return fork();
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	174080e7          	jalr	372(ra) # 800013b0 <fork>
}
    80002244:	60a2                	ld	ra,8(sp)
    80002246:	6402                	ld	s0,0(sp)
    80002248:	0141                	addi	sp,sp,16
    8000224a:	8082                	ret

000000008000224c <sys_wait>:

uint64
sys_wait(void)
{
    8000224c:	1101                	addi	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002254:	fe840593          	addi	a1,s0,-24
    80002258:	4501                	li	a0,0
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	ed0080e7          	jalr	-304(ra) # 8000212a <argaddr>
  return wait(p);
    80002262:	fe843503          	ld	a0,-24(s0)
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	712080e7          	jalr	1810(ra) # 80001978 <wait>
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	6105                	addi	sp,sp,32
    80002274:	8082                	ret

0000000080002276 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002276:	7179                	addi	sp,sp,-48
    80002278:	f406                	sd	ra,40(sp)
    8000227a:	f022                	sd	s0,32(sp)
    8000227c:	ec26                	sd	s1,24(sp)
    8000227e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002280:	fdc40593          	addi	a1,s0,-36
    80002284:	4501                	li	a0,0
    80002286:	00000097          	auipc	ra,0x0
    8000228a:	e84080e7          	jalr	-380(ra) # 8000210a <argint>
  addr = myproc()->sz;
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	d68080e7          	jalr	-664(ra) # 80000ff6 <myproc>
    80002296:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002298:	fdc42503          	lw	a0,-36(s0)
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	0b8080e7          	jalr	184(ra) # 80001354 <growproc>
    800022a4:	00054863          	bltz	a0,800022b4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022a8:	8526                	mv	a0,s1
    800022aa:	70a2                	ld	ra,40(sp)
    800022ac:	7402                	ld	s0,32(sp)
    800022ae:	64e2                	ld	s1,24(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret
    return -1;
    800022b4:	54fd                	li	s1,-1
    800022b6:	bfcd                	j	800022a8 <sys_sbrk+0x32>

00000000800022b8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022b8:	7139                	addi	sp,sp,-64
    800022ba:	fc06                	sd	ra,56(sp)
    800022bc:	f822                	sd	s0,48(sp)
    800022be:	f426                	sd	s1,40(sp)
    800022c0:	f04a                	sd	s2,32(sp)
    800022c2:	ec4e                	sd	s3,24(sp)
    800022c4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800022c6:	fcc40593          	addi	a1,s0,-52
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	e3e080e7          	jalr	-450(ra) # 8000210a <argint>
  if(n < 0)
    800022d4:	fcc42783          	lw	a5,-52(s0)
    800022d8:	0607cf63          	bltz	a5,80002356 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800022dc:	0000d517          	auipc	a0,0xd
    800022e0:	8b450513          	addi	a0,a0,-1868 # 8000eb90 <tickslock>
    800022e4:	00004097          	auipc	ra,0x4
    800022e8:	4e2080e7          	jalr	1250(ra) # 800067c6 <acquire>
  ticks0 = ticks;
    800022ec:	00006917          	auipc	s2,0x6
    800022f0:	6fc92903          	lw	s2,1788(s2) # 800089e8 <ticks>
  while(ticks - ticks0 < n){
    800022f4:	fcc42783          	lw	a5,-52(s0)
    800022f8:	cf9d                	beqz	a5,80002336 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022fa:	0000d997          	auipc	s3,0xd
    800022fe:	89698993          	addi	s3,s3,-1898 # 8000eb90 <tickslock>
    80002302:	00006497          	auipc	s1,0x6
    80002306:	6e648493          	addi	s1,s1,1766 # 800089e8 <ticks>
    if(killed(myproc())){
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	cec080e7          	jalr	-788(ra) # 80000ff6 <myproc>
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	634080e7          	jalr	1588(ra) # 80001946 <killed>
    8000231a:	e129                	bnez	a0,8000235c <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000231c:	85ce                	mv	a1,s3
    8000231e:	8526                	mv	a0,s1
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	37e080e7          	jalr	894(ra) # 8000169e <sleep>
  while(ticks - ticks0 < n){
    80002328:	409c                	lw	a5,0(s1)
    8000232a:	412787bb          	subw	a5,a5,s2
    8000232e:	fcc42703          	lw	a4,-52(s0)
    80002332:	fce7ece3          	bltu	a5,a4,8000230a <sys_sleep+0x52>
  }
  release(&tickslock);
    80002336:	0000d517          	auipc	a0,0xd
    8000233a:	85a50513          	addi	a0,a0,-1958 # 8000eb90 <tickslock>
    8000233e:	00004097          	auipc	ra,0x4
    80002342:	558080e7          	jalr	1368(ra) # 80006896 <release>
  return 0;
    80002346:	4501                	li	a0,0
}
    80002348:	70e2                	ld	ra,56(sp)
    8000234a:	7442                	ld	s0,48(sp)
    8000234c:	74a2                	ld	s1,40(sp)
    8000234e:	7902                	ld	s2,32(sp)
    80002350:	69e2                	ld	s3,24(sp)
    80002352:	6121                	addi	sp,sp,64
    80002354:	8082                	ret
    n = 0;
    80002356:	fc042623          	sw	zero,-52(s0)
    8000235a:	b749                	j	800022dc <sys_sleep+0x24>
      release(&tickslock);
    8000235c:	0000d517          	auipc	a0,0xd
    80002360:	83450513          	addi	a0,a0,-1996 # 8000eb90 <tickslock>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	532080e7          	jalr	1330(ra) # 80006896 <release>
      return -1;
    8000236c:	557d                	li	a0,-1
    8000236e:	bfe9                	j	80002348 <sys_sleep+0x90>

0000000080002370 <sys_kill>:

uint64
sys_kill(void)
{
    80002370:	1101                	addi	sp,sp,-32
    80002372:	ec06                	sd	ra,24(sp)
    80002374:	e822                	sd	s0,16(sp)
    80002376:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002378:	fec40593          	addi	a1,s0,-20
    8000237c:	4501                	li	a0,0
    8000237e:	00000097          	auipc	ra,0x0
    80002382:	d8c080e7          	jalr	-628(ra) # 8000210a <argint>
  return kill(pid);
    80002386:	fec42503          	lw	a0,-20(s0)
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	51e080e7          	jalr	1310(ra) # 800018a8 <kill>
}
    80002392:	60e2                	ld	ra,24(sp)
    80002394:	6442                	ld	s0,16(sp)
    80002396:	6105                	addi	sp,sp,32
    80002398:	8082                	ret

000000008000239a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000239a:	1101                	addi	sp,sp,-32
    8000239c:	ec06                	sd	ra,24(sp)
    8000239e:	e822                	sd	s0,16(sp)
    800023a0:	e426                	sd	s1,8(sp)
    800023a2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023a4:	0000c517          	auipc	a0,0xc
    800023a8:	7ec50513          	addi	a0,a0,2028 # 8000eb90 <tickslock>
    800023ac:	00004097          	auipc	ra,0x4
    800023b0:	41a080e7          	jalr	1050(ra) # 800067c6 <acquire>
  xticks = ticks;
    800023b4:	00006497          	auipc	s1,0x6
    800023b8:	6344a483          	lw	s1,1588(s1) # 800089e8 <ticks>
  release(&tickslock);
    800023bc:	0000c517          	auipc	a0,0xc
    800023c0:	7d450513          	addi	a0,a0,2004 # 8000eb90 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	4d2080e7          	jalr	1234(ra) # 80006896 <release>
  return xticks;
}
    800023cc:	02049513          	slli	a0,s1,0x20
    800023d0:	9101                	srli	a0,a0,0x20
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	64a2                	ld	s1,8(sp)
    800023d8:	6105                	addi	sp,sp,32
    800023da:	8082                	ret

00000000800023dc <binit>:
  struct buf head[BUCKET_NUM]; //new!
} bcache;

void
binit(void)
{
    800023dc:	715d                	addi	sp,sp,-80
    800023de:	e486                	sd	ra,72(sp)
    800023e0:	e0a2                	sd	s0,64(sp)
    800023e2:	fc26                	sd	s1,56(sp)
    800023e4:	f84a                	sd	s2,48(sp)
    800023e6:	f44e                	sd	s3,40(sp)
    800023e8:	f052                	sd	s4,32(sp)
    800023ea:	ec56                	sd	s5,24(sp)
    800023ec:	e85a                	sd	s6,16(sp)
    800023ee:	0880                	addi	s0,sp,80
  //struct buf *b;
  char ch[10];
  for(int i = 0;i < BUCKET_NUM;i++){
    800023f0:	0000ca17          	auipc	s4,0xc
    800023f4:	7c0a0a13          	addi	s4,s4,1984 # 8000ebb0 <bcache>
    800023f8:	00015497          	auipc	s1,0x15
    800023fc:	d8848493          	addi	s1,s1,-632 # 80017180 <bcache+0x85d0>
{
    80002400:	89d2                	mv	s3,s4
  for(int i = 0;i < BUCKET_NUM;i++){
    80002402:	4901                	li	s2,0
    snprintf(ch, 10, "bcache_%d", i);
    80002404:	00006b17          	auipc	s6,0x6
    80002408:	0bcb0b13          	addi	s6,s6,188 # 800084c0 <syscalls+0xb0>
  for(int i = 0;i < BUCKET_NUM;i++){
    8000240c:	4ab5                	li	s5,13
    snprintf(ch, 10, "bcache_%d", i);
    8000240e:	86ca                	mv	a3,s2
    80002410:	865a                	mv	a2,s6
    80002412:	45a9                	li	a1,10
    80002414:	fb040513          	addi	a0,s0,-80
    80002418:	00003097          	auipc	ra,0x3
    8000241c:	7da080e7          	jalr	2010(ra) # 80005bf2 <snprintf>
    initlock(&bcache.lock[i], ch);
    80002420:	fb040593          	addi	a1,s0,-80
    80002424:	854e                	mv	a0,s3
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	51c080e7          	jalr	1308(ra) # 80006942 <initlock>
    bcache.head[i].prev = &bcache.head[i];
    8000242e:	e8a4                	sd	s1,80(s1)
    bcache.head[i].next = &bcache.head[i];
    80002430:	eca4                	sd	s1,88(s1)
  for(int i = 0;i < BUCKET_NUM;i++){
    80002432:	2905                	addiw	s2,s2,1
    80002434:	02098993          	addi	s3,s3,32
    80002438:	46848493          	addi	s1,s1,1128
    8000243c:	fd5919e3          	bne	s2,s5,8000240e <binit+0x32>
    80002440:	0000d497          	auipc	s1,0xd
    80002444:	92048493          	addi	s1,s1,-1760 # 8000ed60 <bcache+0x1b0>
    80002448:	6921                	lui	s2,0x8
    8000244a:	5e090913          	addi	s2,s2,1504 # 85e0 <_entry-0x7fff7a20>
    8000244e:	9952                	add	s2,s2,s4

  for(int i = 0;i < NBUF;i++){
    //int hash = HASH(i);
    //bcache.buf[i].next = bcache.head[hash].next;
    //bcache.buf[i].prev = &bcache.head[hash];
    initsleeplock(&bcache.buf[i].lock, "buffer");
    80002450:	00006a17          	auipc	s4,0x6
    80002454:	080a0a13          	addi	s4,s4,128 # 800084d0 <syscalls+0xc0>
    //bcache.head[hash].next->prev = &bcache.buf[i];
    //bcache.head[hash].next = &bcache.buf[i];
    bcache.buf[i].bucket = -1;
    80002458:	59fd                	li	s3,-1
    initsleeplock(&bcache.buf[i].lock, "buffer");
    8000245a:	85d2                	mv	a1,s4
    8000245c:	8526                	mv	a0,s1
    8000245e:	00001097          	auipc	ra,0x1
    80002462:	63a080e7          	jalr	1594(ra) # 80003a98 <initsleeplock>
    bcache.buf[i].bucket = -1;
    80002466:	4534a823          	sw	s3,1104(s1)
  for(int i = 0;i < NBUF;i++){
    8000246a:	46848493          	addi	s1,s1,1128
    8000246e:	ff2496e3          	bne	s1,s2,8000245a <binit+0x7e>
  }

}
    80002472:	60a6                	ld	ra,72(sp)
    80002474:	6406                	ld	s0,64(sp)
    80002476:	74e2                	ld	s1,56(sp)
    80002478:	7942                	ld	s2,48(sp)
    8000247a:	79a2                	ld	s3,40(sp)
    8000247c:	7a02                	ld	s4,32(sp)
    8000247e:	6ae2                	ld	s5,24(sp)
    80002480:	6b42                	ld	s6,16(sp)
    80002482:	6161                	addi	sp,sp,80
    80002484:	8082                	ret

0000000080002486 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002486:	7159                	addi	sp,sp,-112
    80002488:	f486                	sd	ra,104(sp)
    8000248a:	f0a2                	sd	s0,96(sp)
    8000248c:	eca6                	sd	s1,88(sp)
    8000248e:	e8ca                	sd	s2,80(sp)
    80002490:	e4ce                	sd	s3,72(sp)
    80002492:	e0d2                	sd	s4,64(sp)
    80002494:	fc56                	sd	s5,56(sp)
    80002496:	f85a                	sd	s6,48(sp)
    80002498:	f45e                	sd	s7,40(sp)
    8000249a:	f062                	sd	s8,32(sp)
    8000249c:	ec66                	sd	s9,24(sp)
    8000249e:	e86a                	sd	s10,16(sp)
    800024a0:	e46e                	sd	s11,8(sp)
    800024a2:	1880                	addi	s0,sp,112
    800024a4:	8baa                	mv	s7,a0
    800024a6:	8a2e                	mv	s4,a1
  int hash = HASH(blockno);
    800024a8:	4ab5                	li	s5,13
    800024aa:	0355fabb          	remuw	s5,a1,s5
    800024ae:	000a899b          	sext.w	s3,s5
  acquire(&bcache.lock[hash]);
    800024b2:	00599b13          	slli	s6,s3,0x5
    800024b6:	0000c917          	auipc	s2,0xc
    800024ba:	6fa90913          	addi	s2,s2,1786 # 8000ebb0 <bcache>
    800024be:	9b4a                	add	s6,s6,s2
    800024c0:	855a                	mv	a0,s6
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	304080e7          	jalr	772(ra) # 800067c6 <acquire>
  for(b = bcache.head[hash].next; b != &bcache.head[hash]; b = b->next){
    800024ca:	46800713          	li	a4,1128
    800024ce:	02e98733          	mul	a4,s3,a4
    800024d2:	00e906b3          	add	a3,s2,a4
    800024d6:	67a1                	lui	a5,0x8
    800024d8:	96be                	add	a3,a3,a5
    800024da:	6286b683          	ld	a3,1576(a3)
    800024de:	5d078493          	addi	s1,a5,1488 # 85d0 <_entry-0x7fff7a30>
    800024e2:	94ba                	add	s1,s1,a4
    800024e4:	94ca                	add	s1,s1,s2
    800024e6:	04968163          	beq	a3,s1,80002528 <bread+0xa2>
    800024ea:	8936                	mv	s2,a3
    800024ec:	a029                	j	800024f6 <bread+0x70>
    800024ee:	05893903          	ld	s2,88(s2)
    800024f2:	02990b63          	beq	s2,s1,80002528 <bread+0xa2>
    if(b->dev == dev && b->blockno == blockno){
    800024f6:	00892783          	lw	a5,8(s2)
    800024fa:	ff779ae3          	bne	a5,s7,800024ee <bread+0x68>
    800024fe:	00c92783          	lw	a5,12(s2)
    80002502:	ff4796e3          	bne	a5,s4,800024ee <bread+0x68>
      b->refcnt++;
    80002506:	04892783          	lw	a5,72(s2)
    8000250a:	2785                	addiw	a5,a5,1
    8000250c:	04f92423          	sw	a5,72(s2)
      release(&bcache.lock[hash]);
    80002510:	855a                	mv	a0,s6
    80002512:	00004097          	auipc	ra,0x4
    80002516:	384080e7          	jalr	900(ra) # 80006896 <release>
      acquiresleep(&b->lock);
    8000251a:	01090513          	addi	a0,s2,16
    8000251e:	00001097          	auipc	ra,0x1
    80002522:	5b4080e7          	jalr	1460(ra) # 80003ad2 <acquiresleep>
      return b;
    80002526:	aa21                	j	8000263e <bread+0x1b8>
  for (int i = hash; i < NBUF; i+=BUCKET_NUM) {
    80002528:	0000c797          	auipc	a5,0xc
    8000252c:	68878793          	addi	a5,a5,1672 # 8000ebb0 <bcache>
    80002530:	973e                	add	a4,a4,a5
    80002532:	854e                	mv	a0,s3
    80002534:	6791                	lui	a5,0x4
    80002536:	94878793          	addi	a5,a5,-1720 # 3948 <_entry-0x7fffc6b8>
    8000253a:	45f5                	li	a1,29
    if (bcache.buf[i].refcnt==0) {
    8000253c:	1e872603          	lw	a2,488(a4)
    80002540:	c60d                	beqz	a2,8000256a <bread+0xe4>
  for (int i = hash; i < NBUF; i+=BUCKET_NUM) {
    80002542:	2535                	addiw	a0,a0,13
    80002544:	973e                	add	a4,a4,a5
    80002546:	fea5dbe3          	bge	a1,a0,8000253c <bread+0xb6>
  for(int j = (hash + 1) % BUCKET_NUM;j != hash;j = (j + 1) % BUCKET_NUM)
    8000254a:	001a891b          	addiw	s2,s5,1
    8000254e:	47b5                	li	a5,13
    80002550:	02f9693b          	remw	s2,s2,a5
    80002554:	15298b63          	beq	s3,s2,800026aa <bread+0x224>
    acquire(&bcache.lock[j]);
    80002558:	0000cd97          	auipc	s11,0xc
    8000255c:	658d8d93          	addi	s11,s11,1624 # 8000ebb0 <bcache>
    for (int i = j; i < NBUF; i += BUCKET_NUM) {
    80002560:	4cf5                	li	s9,29
    80002562:	6d11                	lui	s10,0x4
    80002564:	948d0d13          	addi	s10,s10,-1720 # 3948 <_entry-0x7fffc6b8>
    80002568:	aa09                	j	8000267a <bread+0x1f4>
      struct buf *buf = &bcache.buf[i];
    8000256a:	46800713          	li	a4,1128
    8000256e:	02e50c33          	mul	s8,a0,a4
    80002572:	1a0c0913          	addi	s2,s8,416
    80002576:	0000cc97          	auipc	s9,0xc
    8000257a:	63ac8c93          	addi	s9,s9,1594 # 8000ebb0 <bcache>
    8000257e:	9966                	add	s2,s2,s9
      buf->dev = dev;
    80002580:	018c87b3          	add	a5,s9,s8
    80002584:	1b77a423          	sw	s7,424(a5)
      buf->blockno = blockno;
    80002588:	1b47a623          	sw	s4,428(a5)
      buf->valid = 0;
    8000258c:	1a07a023          	sw	zero,416(a5)
      buf->refcnt = 1;
    80002590:	4605                	li	a2,1
    80002592:	1ec7a423          	sw	a2,488(a5)
      buf->next = bcache.head[hash].next;
    80002596:	1ed7bc23          	sd	a3,504(a5)
      buf->prev = &bcache.head[hash];
    8000259a:	1e97b823          	sd	s1,496(a5)
      bcache.head[hash].next->prev = buf;
    8000259e:	0526b823          	sd	s2,80(a3)
      bcache.head[hash].next = buf;
    800025a2:	02e989b3          	mul	s3,s3,a4
    800025a6:	99e6                	add	s3,s3,s9
    800025a8:	6721                	lui	a4,0x8
    800025aa:	99ba                	add	s3,s3,a4
    800025ac:	6329b423          	sd	s2,1576(s3)
      bcache.buf[i].bucket = hash;
    800025b0:	6157a023          	sw	s5,1536(a5)
      release(&bcache.lock[hash]);
    800025b4:	855a                	mv	a0,s6
    800025b6:	00004097          	auipc	ra,0x4
    800025ba:	2e0080e7          	jalr	736(ra) # 80006896 <release>
      acquiresleep(&buf->lock);
    800025be:	1b0c0513          	addi	a0,s8,432
    800025c2:	9566                	add	a0,a0,s9
    800025c4:	00001097          	auipc	ra,0x1
    800025c8:	50e080e7          	jalr	1294(ra) # 80003ad2 <acquiresleep>
      return buf;
    800025cc:	a88d                	j	8000263e <bread+0x1b8>
        struct buf *buf = &bcache.buf[i];
    800025ce:	46800713          	li	a4,1128
    800025d2:	02e50cb3          	mul	s9,a0,a4
    800025d6:	1a0c8913          	addi	s2,s9,416
    800025da:	0000cd17          	auipc	s10,0xc
    800025de:	5d6d0d13          	addi	s10,s10,1494 # 8000ebb0 <bcache>
    800025e2:	996a                	add	s2,s2,s10
        buf->dev = dev;
    800025e4:	019d07b3          	add	a5,s10,s9
    800025e8:	1b77a423          	sw	s7,424(a5)
        buf->blockno = blockno;
    800025ec:	1b47a623          	sw	s4,428(a5)
        buf->valid = 0;
    800025f0:	1a07a023          	sw	zero,416(a5)
        buf->refcnt = 1;
    800025f4:	4685                	li	a3,1
    800025f6:	1ed7a423          	sw	a3,488(a5)
        buf->next = bcache.head[hash].next;
    800025fa:	02e989b3          	mul	s3,s3,a4
    800025fe:	99ea                	add	s3,s3,s10
    80002600:	6721                	lui	a4,0x8
    80002602:	99ba                	add	s3,s3,a4
    80002604:	6289b703          	ld	a4,1576(s3)
    80002608:	1ee7bc23          	sd	a4,504(a5)
        buf->prev = &bcache.head[hash];
    8000260c:	1e97b823          	sd	s1,496(a5)
        bcache.head[hash].next->prev = buf;
    80002610:	05273823          	sd	s2,80(a4) # 8050 <_entry-0x7fff7fb0>
        bcache.head[hash].next = buf;
    80002614:	6329b423          	sd	s2,1576(s3)
        bcache.buf[i].bucket = hash;
    80002618:	6157a023          	sw	s5,1536(a5)
        release(&bcache.lock[j]);
    8000261c:	8562                	mv	a0,s8
    8000261e:	00004097          	auipc	ra,0x4
    80002622:	278080e7          	jalr	632(ra) # 80006896 <release>
        release(&bcache.lock[hash]);
    80002626:	855a                	mv	a0,s6
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	26e080e7          	jalr	622(ra) # 80006896 <release>
        acquiresleep(&buf->lock);
    80002630:	1b0c8513          	addi	a0,s9,432
    80002634:	956a                	add	a0,a0,s10
    80002636:	00001097          	auipc	ra,0x1
    8000263a:	49c080e7          	jalr	1180(ra) # 80003ad2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000263e:	00092783          	lw	a5,0(s2)
    80002642:	cfa5                	beqz	a5,800026ba <bread+0x234>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002644:	854a                	mv	a0,s2
    80002646:	70a6                	ld	ra,104(sp)
    80002648:	7406                	ld	s0,96(sp)
    8000264a:	64e6                	ld	s1,88(sp)
    8000264c:	6946                	ld	s2,80(sp)
    8000264e:	69a6                	ld	s3,72(sp)
    80002650:	6a06                	ld	s4,64(sp)
    80002652:	7ae2                	ld	s5,56(sp)
    80002654:	7b42                	ld	s6,48(sp)
    80002656:	7ba2                	ld	s7,40(sp)
    80002658:	7c02                	ld	s8,32(sp)
    8000265a:	6ce2                	ld	s9,24(sp)
    8000265c:	6d42                	ld	s10,16(sp)
    8000265e:	6da2                	ld	s11,8(sp)
    80002660:	6165                	addi	sp,sp,112
    80002662:	8082                	ret
    release(&bcache.lock[j]);
    80002664:	8562                	mv	a0,s8
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	230080e7          	jalr	560(ra) # 80006896 <release>
  for(int j = (hash + 1) % BUCKET_NUM;j != hash;j = (j + 1) % BUCKET_NUM)
    8000266e:	2905                	addiw	s2,s2,1
    80002670:	47b5                	li	a5,13
    80002672:	02f9693b          	remw	s2,s2,a5
    80002676:	03298a63          	beq	s3,s2,800026aa <bread+0x224>
    acquire(&bcache.lock[j]);
    8000267a:	00591c13          	slli	s8,s2,0x5
    8000267e:	9c6e                	add	s8,s8,s11
    80002680:	8562                	mv	a0,s8
    80002682:	00004097          	auipc	ra,0x4
    80002686:	144080e7          	jalr	324(ra) # 800067c6 <acquire>
    for (int i = j; i < NBUF; i += BUCKET_NUM) {
    8000268a:	fd2ccde3          	blt	s9,s2,80002664 <bread+0x1de>
    8000268e:	46800793          	li	a5,1128
    80002692:	02f907b3          	mul	a5,s2,a5
    80002696:	97ee                	add	a5,a5,s11
    80002698:	854a                	mv	a0,s2
      if (bcache.buf[i].refcnt==0) {
    8000269a:	1e87a703          	lw	a4,488(a5)
    8000269e:	db05                	beqz	a4,800025ce <bread+0x148>
    for (int i = j; i < NBUF; i += BUCKET_NUM) {
    800026a0:	2535                	addiw	a0,a0,13
    800026a2:	97ea                	add	a5,a5,s10
    800026a4:	feacdbe3          	bge	s9,a0,8000269a <bread+0x214>
    800026a8:	bf75                	j	80002664 <bread+0x1de>
  panic("bget: no buffers");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e2e50513          	addi	a0,a0,-466 # 800084d8 <syscalls+0xc8>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	be0080e7          	jalr	-1056(ra) # 80006292 <panic>
    virtio_disk_rw(b, 0);
    800026ba:	4581                	li	a1,0
    800026bc:	854a                	mv	a0,s2
    800026be:	00003097          	auipc	ra,0x3
    800026c2:	ffa080e7          	jalr	-6(ra) # 800056b8 <virtio_disk_rw>
    b->valid = 1;
    800026c6:	4785                	li	a5,1
    800026c8:	00f92023          	sw	a5,0(s2)
  return b;
    800026cc:	bfa5                	j	80002644 <bread+0x1be>

00000000800026ce <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026ce:	1101                	addi	sp,sp,-32
    800026d0:	ec06                	sd	ra,24(sp)
    800026d2:	e822                	sd	s0,16(sp)
    800026d4:	e426                	sd	s1,8(sp)
    800026d6:	1000                	addi	s0,sp,32
    800026d8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026da:	0541                	addi	a0,a0,16
    800026dc:	00001097          	auipc	ra,0x1
    800026e0:	490080e7          	jalr	1168(ra) # 80003b6c <holdingsleep>
    800026e4:	cd01                	beqz	a0,800026fc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026e6:	4585                	li	a1,1
    800026e8:	8526                	mv	a0,s1
    800026ea:	00003097          	auipc	ra,0x3
    800026ee:	fce080e7          	jalr	-50(ra) # 800056b8 <virtio_disk_rw>
}
    800026f2:	60e2                	ld	ra,24(sp)
    800026f4:	6442                	ld	s0,16(sp)
    800026f6:	64a2                	ld	s1,8(sp)
    800026f8:	6105                	addi	sp,sp,32
    800026fa:	8082                	ret
    panic("bwrite");
    800026fc:	00006517          	auipc	a0,0x6
    80002700:	df450513          	addi	a0,a0,-524 # 800084f0 <syscalls+0xe0>
    80002704:	00004097          	auipc	ra,0x4
    80002708:	b8e080e7          	jalr	-1138(ra) # 80006292 <panic>

000000008000270c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000270c:	1101                	addi	sp,sp,-32
    8000270e:	ec06                	sd	ra,24(sp)
    80002710:	e822                	sd	s0,16(sp)
    80002712:	e426                	sd	s1,8(sp)
    80002714:	e04a                	sd	s2,0(sp)
    80002716:	1000                	addi	s0,sp,32
    80002718:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000271a:	01050913          	addi	s2,a0,16
    8000271e:	854a                	mv	a0,s2
    80002720:	00001097          	auipc	ra,0x1
    80002724:	44c080e7          	jalr	1100(ra) # 80003b6c <holdingsleep>
    80002728:	c125                	beqz	a0,80002788 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000272a:	854a                	mv	a0,s2
    8000272c:	00001097          	auipc	ra,0x1
    80002730:	3fc080e7          	jalr	1020(ra) # 80003b28 <releasesleep>

  acquire(&bcache.lock[b->bucket]);
    80002734:	4604a783          	lw	a5,1120(s1)
    80002738:	0796                	slli	a5,a5,0x5
    8000273a:	0000c517          	auipc	a0,0xc
    8000273e:	47650513          	addi	a0,a0,1142 # 8000ebb0 <bcache>
    80002742:	953e                	add	a0,a0,a5
    80002744:	00004097          	auipc	ra,0x4
    80002748:	082080e7          	jalr	130(ra) # 800067c6 <acquire>
  b->refcnt--;
    8000274c:	44bc                	lw	a5,72(s1)
    8000274e:	37fd                	addiw	a5,a5,-1
    80002750:	0007871b          	sext.w	a4,a5
    80002754:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    80002756:	e719                	bnez	a4,80002764 <brelse+0x58>
    //printf("release%d\n", hash);
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002758:	6cbc                	ld	a5,88(s1)
    8000275a:	68b8                	ld	a4,80(s1)
    8000275c:	ebb8                	sd	a4,80(a5)
    b->prev->next = b->next;
    8000275e:	68bc                	ld	a5,80(s1)
    80002760:	6cb8                	ld	a4,88(s1)
    80002762:	efb8                	sd	a4,88(a5)
    //b->next = bcache.head[hash].next;
    //b->prev = &bcache.head[hash];
    //bcache.head[hash].next->prev = b;
    //bcache.head[hash].next = b;
  }
  release(&bcache.lock[b->bucket]);
    80002764:	4604a783          	lw	a5,1120(s1)
    80002768:	0796                	slli	a5,a5,0x5
    8000276a:	0000c517          	auipc	a0,0xc
    8000276e:	44650513          	addi	a0,a0,1094 # 8000ebb0 <bcache>
    80002772:	953e                	add	a0,a0,a5
    80002774:	00004097          	auipc	ra,0x4
    80002778:	122080e7          	jalr	290(ra) # 80006896 <release>
}
    8000277c:	60e2                	ld	ra,24(sp)
    8000277e:	6442                	ld	s0,16(sp)
    80002780:	64a2                	ld	s1,8(sp)
    80002782:	6902                	ld	s2,0(sp)
    80002784:	6105                	addi	sp,sp,32
    80002786:	8082                	ret
    panic("brelse");
    80002788:	00006517          	auipc	a0,0x6
    8000278c:	d7050513          	addi	a0,a0,-656 # 800084f8 <syscalls+0xe8>
    80002790:	00004097          	auipc	ra,0x4
    80002794:	b02080e7          	jalr	-1278(ra) # 80006292 <panic>

0000000080002798 <bpin>:

void
bpin(struct buf *b) {
    80002798:	1101                	addi	sp,sp,-32
    8000279a:	ec06                	sd	ra,24(sp)
    8000279c:	e822                	sd	s0,16(sp)
    8000279e:	e426                	sd	s1,8(sp)
    800027a0:	e04a                	sd	s2,0(sp)
    800027a2:	1000                	addi	s0,sp,32
    800027a4:	892a                	mv	s2,a0
  int hash = HASH(b->blockno);
    800027a6:	4544                	lw	s1,12(a0)
  acquire(&bcache.lock[hash]);
    800027a8:	47b5                	li	a5,13
    800027aa:	02f4f4bb          	remuw	s1,s1,a5
    800027ae:	0496                	slli	s1,s1,0x5
    800027b0:	0000c797          	auipc	a5,0xc
    800027b4:	40078793          	addi	a5,a5,1024 # 8000ebb0 <bcache>
    800027b8:	94be                	add	s1,s1,a5
    800027ba:	8526                	mv	a0,s1
    800027bc:	00004097          	auipc	ra,0x4
    800027c0:	00a080e7          	jalr	10(ra) # 800067c6 <acquire>
  b->refcnt++;
    800027c4:	04892783          	lw	a5,72(s2)
    800027c8:	2785                	addiw	a5,a5,1
    800027ca:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[hash]);
    800027ce:	8526                	mv	a0,s1
    800027d0:	00004097          	auipc	ra,0x4
    800027d4:	0c6080e7          	jalr	198(ra) # 80006896 <release>
}
    800027d8:	60e2                	ld	ra,24(sp)
    800027da:	6442                	ld	s0,16(sp)
    800027dc:	64a2                	ld	s1,8(sp)
    800027de:	6902                	ld	s2,0(sp)
    800027e0:	6105                	addi	sp,sp,32
    800027e2:	8082                	ret

00000000800027e4 <bunpin>:

void
bunpin(struct buf *b) {
    800027e4:	1101                	addi	sp,sp,-32
    800027e6:	ec06                	sd	ra,24(sp)
    800027e8:	e822                	sd	s0,16(sp)
    800027ea:	e426                	sd	s1,8(sp)
    800027ec:	e04a                	sd	s2,0(sp)
    800027ee:	1000                	addi	s0,sp,32
    800027f0:	892a                	mv	s2,a0
  int hash = HASH(b->blockno);
    800027f2:	4544                	lw	s1,12(a0)
  acquire(&bcache.lock[hash]);
    800027f4:	47b5                	li	a5,13
    800027f6:	02f4f4bb          	remuw	s1,s1,a5
    800027fa:	0496                	slli	s1,s1,0x5
    800027fc:	0000c797          	auipc	a5,0xc
    80002800:	3b478793          	addi	a5,a5,948 # 8000ebb0 <bcache>
    80002804:	94be                	add	s1,s1,a5
    80002806:	8526                	mv	a0,s1
    80002808:	00004097          	auipc	ra,0x4
    8000280c:	fbe080e7          	jalr	-66(ra) # 800067c6 <acquire>
  b->refcnt--;
    80002810:	04892783          	lw	a5,72(s2)
    80002814:	37fd                	addiw	a5,a5,-1
    80002816:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[hash]);
    8000281a:	8526                	mv	a0,s1
    8000281c:	00004097          	auipc	ra,0x4
    80002820:	07a080e7          	jalr	122(ra) # 80006896 <release>
}
    80002824:	60e2                	ld	ra,24(sp)
    80002826:	6442                	ld	s0,16(sp)
    80002828:	64a2                	ld	s1,8(sp)
    8000282a:	6902                	ld	s2,0(sp)
    8000282c:	6105                	addi	sp,sp,32
    8000282e:	8082                	ret

0000000080002830 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002830:	1101                	addi	sp,sp,-32
    80002832:	ec06                	sd	ra,24(sp)
    80002834:	e822                	sd	s0,16(sp)
    80002836:	e426                	sd	s1,8(sp)
    80002838:	e04a                	sd	s2,0(sp)
    8000283a:	1000                	addi	s0,sp,32
    8000283c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000283e:	00d5d59b          	srliw	a1,a1,0xd
    80002842:	00018797          	auipc	a5,0x18
    80002846:	2a27a783          	lw	a5,674(a5) # 8001aae4 <sb+0x1c>
    8000284a:	9dbd                	addw	a1,a1,a5
    8000284c:	00000097          	auipc	ra,0x0
    80002850:	c3a080e7          	jalr	-966(ra) # 80002486 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002854:	0074f713          	andi	a4,s1,7
    80002858:	4785                	li	a5,1
    8000285a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000285e:	14ce                	slli	s1,s1,0x33
    80002860:	90d9                	srli	s1,s1,0x36
    80002862:	00950733          	add	a4,a0,s1
    80002866:	06074703          	lbu	a4,96(a4)
    8000286a:	00e7f6b3          	and	a3,a5,a4
    8000286e:	c69d                	beqz	a3,8000289c <bfree+0x6c>
    80002870:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002872:	94aa                	add	s1,s1,a0
    80002874:	fff7c793          	not	a5,a5
    80002878:	8ff9                	and	a5,a5,a4
    8000287a:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000287e:	00001097          	auipc	ra,0x1
    80002882:	134080e7          	jalr	308(ra) # 800039b2 <log_write>
  brelse(bp);
    80002886:	854a                	mv	a0,s2
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	e84080e7          	jalr	-380(ra) # 8000270c <brelse>
}
    80002890:	60e2                	ld	ra,24(sp)
    80002892:	6442                	ld	s0,16(sp)
    80002894:	64a2                	ld	s1,8(sp)
    80002896:	6902                	ld	s2,0(sp)
    80002898:	6105                	addi	sp,sp,32
    8000289a:	8082                	ret
    panic("freeing free block");
    8000289c:	00006517          	auipc	a0,0x6
    800028a0:	c6450513          	addi	a0,a0,-924 # 80008500 <syscalls+0xf0>
    800028a4:	00004097          	auipc	ra,0x4
    800028a8:	9ee080e7          	jalr	-1554(ra) # 80006292 <panic>

00000000800028ac <balloc>:
{
    800028ac:	711d                	addi	sp,sp,-96
    800028ae:	ec86                	sd	ra,88(sp)
    800028b0:	e8a2                	sd	s0,80(sp)
    800028b2:	e4a6                	sd	s1,72(sp)
    800028b4:	e0ca                	sd	s2,64(sp)
    800028b6:	fc4e                	sd	s3,56(sp)
    800028b8:	f852                	sd	s4,48(sp)
    800028ba:	f456                	sd	s5,40(sp)
    800028bc:	f05a                	sd	s6,32(sp)
    800028be:	ec5e                	sd	s7,24(sp)
    800028c0:	e862                	sd	s8,16(sp)
    800028c2:	e466                	sd	s9,8(sp)
    800028c4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028c6:	00018797          	auipc	a5,0x18
    800028ca:	2067a783          	lw	a5,518(a5) # 8001aacc <sb+0x4>
    800028ce:	10078163          	beqz	a5,800029d0 <balloc+0x124>
    800028d2:	8baa                	mv	s7,a0
    800028d4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028d6:	00018b17          	auipc	s6,0x18
    800028da:	1f2b0b13          	addi	s6,s6,498 # 8001aac8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028de:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028e0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028e4:	6c89                	lui	s9,0x2
    800028e6:	a061                	j	8000296e <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028e8:	974a                	add	a4,a4,s2
    800028ea:	8fd5                	or	a5,a5,a3
    800028ec:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    800028f0:	854a                	mv	a0,s2
    800028f2:	00001097          	auipc	ra,0x1
    800028f6:	0c0080e7          	jalr	192(ra) # 800039b2 <log_write>
        brelse(bp);
    800028fa:	854a                	mv	a0,s2
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	e10080e7          	jalr	-496(ra) # 8000270c <brelse>
  bp = bread(dev, bno);
    80002904:	85a6                	mv	a1,s1
    80002906:	855e                	mv	a0,s7
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	b7e080e7          	jalr	-1154(ra) # 80002486 <bread>
    80002910:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002912:	40000613          	li	a2,1024
    80002916:	4581                	li	a1,0
    80002918:	06050513          	addi	a0,a0,96
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	992080e7          	jalr	-1646(ra) # 800002ae <memset>
  log_write(bp);
    80002924:	854a                	mv	a0,s2
    80002926:	00001097          	auipc	ra,0x1
    8000292a:	08c080e7          	jalr	140(ra) # 800039b2 <log_write>
  brelse(bp);
    8000292e:	854a                	mv	a0,s2
    80002930:	00000097          	auipc	ra,0x0
    80002934:	ddc080e7          	jalr	-548(ra) # 8000270c <brelse>
}
    80002938:	8526                	mv	a0,s1
    8000293a:	60e6                	ld	ra,88(sp)
    8000293c:	6446                	ld	s0,80(sp)
    8000293e:	64a6                	ld	s1,72(sp)
    80002940:	6906                	ld	s2,64(sp)
    80002942:	79e2                	ld	s3,56(sp)
    80002944:	7a42                	ld	s4,48(sp)
    80002946:	7aa2                	ld	s5,40(sp)
    80002948:	7b02                	ld	s6,32(sp)
    8000294a:	6be2                	ld	s7,24(sp)
    8000294c:	6c42                	ld	s8,16(sp)
    8000294e:	6ca2                	ld	s9,8(sp)
    80002950:	6125                	addi	sp,sp,96
    80002952:	8082                	ret
    brelse(bp);
    80002954:	854a                	mv	a0,s2
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	db6080e7          	jalr	-586(ra) # 8000270c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000295e:	015c87bb          	addw	a5,s9,s5
    80002962:	00078a9b          	sext.w	s5,a5
    80002966:	004b2703          	lw	a4,4(s6)
    8000296a:	06eaf363          	bgeu	s5,a4,800029d0 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000296e:	41fad79b          	sraiw	a5,s5,0x1f
    80002972:	0137d79b          	srliw	a5,a5,0x13
    80002976:	015787bb          	addw	a5,a5,s5
    8000297a:	40d7d79b          	sraiw	a5,a5,0xd
    8000297e:	01cb2583          	lw	a1,28(s6)
    80002982:	9dbd                	addw	a1,a1,a5
    80002984:	855e                	mv	a0,s7
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	b00080e7          	jalr	-1280(ra) # 80002486 <bread>
    8000298e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002990:	004b2503          	lw	a0,4(s6)
    80002994:	000a849b          	sext.w	s1,s5
    80002998:	8662                	mv	a2,s8
    8000299a:	faa4fde3          	bgeu	s1,a0,80002954 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000299e:	41f6579b          	sraiw	a5,a2,0x1f
    800029a2:	01d7d69b          	srliw	a3,a5,0x1d
    800029a6:	00c6873b          	addw	a4,a3,a2
    800029aa:	00777793          	andi	a5,a4,7
    800029ae:	9f95                	subw	a5,a5,a3
    800029b0:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029b4:	4037571b          	sraiw	a4,a4,0x3
    800029b8:	00e906b3          	add	a3,s2,a4
    800029bc:	0606c683          	lbu	a3,96(a3)
    800029c0:	00d7f5b3          	and	a1,a5,a3
    800029c4:	d195                	beqz	a1,800028e8 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029c6:	2605                	addiw	a2,a2,1
    800029c8:	2485                	addiw	s1,s1,1
    800029ca:	fd4618e3          	bne	a2,s4,8000299a <balloc+0xee>
    800029ce:	b759                	j	80002954 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800029d0:	00006517          	auipc	a0,0x6
    800029d4:	b4850513          	addi	a0,a0,-1208 # 80008518 <syscalls+0x108>
    800029d8:	00004097          	auipc	ra,0x4
    800029dc:	904080e7          	jalr	-1788(ra) # 800062dc <printf>
  return 0;
    800029e0:	4481                	li	s1,0
    800029e2:	bf99                	j	80002938 <balloc+0x8c>

00000000800029e4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800029e4:	7179                	addi	sp,sp,-48
    800029e6:	f406                	sd	ra,40(sp)
    800029e8:	f022                	sd	s0,32(sp)
    800029ea:	ec26                	sd	s1,24(sp)
    800029ec:	e84a                	sd	s2,16(sp)
    800029ee:	e44e                	sd	s3,8(sp)
    800029f0:	e052                	sd	s4,0(sp)
    800029f2:	1800                	addi	s0,sp,48
    800029f4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029f6:	47ad                	li	a5,11
    800029f8:	02b7e763          	bltu	a5,a1,80002a26 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800029fc:	02059493          	slli	s1,a1,0x20
    80002a00:	9081                	srli	s1,s1,0x20
    80002a02:	048a                	slli	s1,s1,0x2
    80002a04:	94aa                	add	s1,s1,a0
    80002a06:	0584a903          	lw	s2,88(s1)
    80002a0a:	06091e63          	bnez	s2,80002a86 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002a0e:	4108                	lw	a0,0(a0)
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	e9c080e7          	jalr	-356(ra) # 800028ac <balloc>
    80002a18:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a1c:	06090563          	beqz	s2,80002a86 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002a20:	0524ac23          	sw	s2,88(s1)
    80002a24:	a08d                	j	80002a86 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a26:	ff45849b          	addiw	s1,a1,-12
    80002a2a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a2e:	0ff00793          	li	a5,255
    80002a32:	08e7e563          	bltu	a5,a4,80002abc <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a36:	08852903          	lw	s2,136(a0)
    80002a3a:	00091d63          	bnez	s2,80002a54 <bmap+0x70>
      addr = balloc(ip->dev);
    80002a3e:	4108                	lw	a0,0(a0)
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	e6c080e7          	jalr	-404(ra) # 800028ac <balloc>
    80002a48:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a4c:	02090d63          	beqz	s2,80002a86 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a50:	0929a423          	sw	s2,136(s3)
    }
    bp = bread(ip->dev, addr);
    80002a54:	85ca                	mv	a1,s2
    80002a56:	0009a503          	lw	a0,0(s3)
    80002a5a:	00000097          	auipc	ra,0x0
    80002a5e:	a2c080e7          	jalr	-1492(ra) # 80002486 <bread>
    80002a62:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a64:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002a68:	02049593          	slli	a1,s1,0x20
    80002a6c:	9181                	srli	a1,a1,0x20
    80002a6e:	058a                	slli	a1,a1,0x2
    80002a70:	00b784b3          	add	s1,a5,a1
    80002a74:	0004a903          	lw	s2,0(s1)
    80002a78:	02090063          	beqz	s2,80002a98 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a7c:	8552                	mv	a0,s4
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	c8e080e7          	jalr	-882(ra) # 8000270c <brelse>
    return addr;
  }
  panic("bmap: out of range");
}
    80002a86:	854a                	mv	a0,s2
    80002a88:	70a2                	ld	ra,40(sp)
    80002a8a:	7402                	ld	s0,32(sp)
    80002a8c:	64e2                	ld	s1,24(sp)
    80002a8e:	6942                	ld	s2,16(sp)
    80002a90:	69a2                	ld	s3,8(sp)
    80002a92:	6a02                	ld	s4,0(sp)
    80002a94:	6145                	addi	sp,sp,48
    80002a96:	8082                	ret
      addr = balloc(ip->dev);
    80002a98:	0009a503          	lw	a0,0(s3)
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	e10080e7          	jalr	-496(ra) # 800028ac <balloc>
    80002aa4:	0005091b          	sext.w	s2,a0
      if(addr){
    80002aa8:	fc090ae3          	beqz	s2,80002a7c <bmap+0x98>
        a[bn] = addr;
    80002aac:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ab0:	8552                	mv	a0,s4
    80002ab2:	00001097          	auipc	ra,0x1
    80002ab6:	f00080e7          	jalr	-256(ra) # 800039b2 <log_write>
    80002aba:	b7c9                	j	80002a7c <bmap+0x98>
  panic("bmap: out of range");
    80002abc:	00006517          	auipc	a0,0x6
    80002ac0:	a7450513          	addi	a0,a0,-1420 # 80008530 <syscalls+0x120>
    80002ac4:	00003097          	auipc	ra,0x3
    80002ac8:	7ce080e7          	jalr	1998(ra) # 80006292 <panic>

0000000080002acc <iget>:
{
    80002acc:	7179                	addi	sp,sp,-48
    80002ace:	f406                	sd	ra,40(sp)
    80002ad0:	f022                	sd	s0,32(sp)
    80002ad2:	ec26                	sd	s1,24(sp)
    80002ad4:	e84a                	sd	s2,16(sp)
    80002ad6:	e44e                	sd	s3,8(sp)
    80002ad8:	e052                	sd	s4,0(sp)
    80002ada:	1800                	addi	s0,sp,48
    80002adc:	89aa                	mv	s3,a0
    80002ade:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002ae0:	00018517          	auipc	a0,0x18
    80002ae4:	00850513          	addi	a0,a0,8 # 8001aae8 <itable>
    80002ae8:	00004097          	auipc	ra,0x4
    80002aec:	cde080e7          	jalr	-802(ra) # 800067c6 <acquire>
  empty = 0;
    80002af0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002af2:	00018497          	auipc	s1,0x18
    80002af6:	01648493          	addi	s1,s1,22 # 8001ab08 <itable+0x20>
    80002afa:	0001a697          	auipc	a3,0x1a
    80002afe:	c2e68693          	addi	a3,a3,-978 # 8001c728 <log>
    80002b02:	a039                	j	80002b10 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b04:	02090b63          	beqz	s2,80002b3a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b08:	09048493          	addi	s1,s1,144
    80002b0c:	02d48a63          	beq	s1,a3,80002b40 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b10:	449c                	lw	a5,8(s1)
    80002b12:	fef059e3          	blez	a5,80002b04 <iget+0x38>
    80002b16:	4098                	lw	a4,0(s1)
    80002b18:	ff3716e3          	bne	a4,s3,80002b04 <iget+0x38>
    80002b1c:	40d8                	lw	a4,4(s1)
    80002b1e:	ff4713e3          	bne	a4,s4,80002b04 <iget+0x38>
      ip->ref++;
    80002b22:	2785                	addiw	a5,a5,1
    80002b24:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b26:	00018517          	auipc	a0,0x18
    80002b2a:	fc250513          	addi	a0,a0,-62 # 8001aae8 <itable>
    80002b2e:	00004097          	auipc	ra,0x4
    80002b32:	d68080e7          	jalr	-664(ra) # 80006896 <release>
      return ip;
    80002b36:	8926                	mv	s2,s1
    80002b38:	a03d                	j	80002b66 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b3a:	f7f9                	bnez	a5,80002b08 <iget+0x3c>
    80002b3c:	8926                	mv	s2,s1
    80002b3e:	b7e9                	j	80002b08 <iget+0x3c>
  if(empty == 0)
    80002b40:	02090c63          	beqz	s2,80002b78 <iget+0xac>
  ip->dev = dev;
    80002b44:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b48:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b4c:	4785                	li	a5,1
    80002b4e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b52:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002b56:	00018517          	auipc	a0,0x18
    80002b5a:	f9250513          	addi	a0,a0,-110 # 8001aae8 <itable>
    80002b5e:	00004097          	auipc	ra,0x4
    80002b62:	d38080e7          	jalr	-712(ra) # 80006896 <release>
}
    80002b66:	854a                	mv	a0,s2
    80002b68:	70a2                	ld	ra,40(sp)
    80002b6a:	7402                	ld	s0,32(sp)
    80002b6c:	64e2                	ld	s1,24(sp)
    80002b6e:	6942                	ld	s2,16(sp)
    80002b70:	69a2                	ld	s3,8(sp)
    80002b72:	6a02                	ld	s4,0(sp)
    80002b74:	6145                	addi	sp,sp,48
    80002b76:	8082                	ret
    panic("iget: no inodes");
    80002b78:	00006517          	auipc	a0,0x6
    80002b7c:	9d050513          	addi	a0,a0,-1584 # 80008548 <syscalls+0x138>
    80002b80:	00003097          	auipc	ra,0x3
    80002b84:	712080e7          	jalr	1810(ra) # 80006292 <panic>

0000000080002b88 <fsinit>:
fsinit(int dev) {
    80002b88:	7179                	addi	sp,sp,-48
    80002b8a:	f406                	sd	ra,40(sp)
    80002b8c:	f022                	sd	s0,32(sp)
    80002b8e:	ec26                	sd	s1,24(sp)
    80002b90:	e84a                	sd	s2,16(sp)
    80002b92:	e44e                	sd	s3,8(sp)
    80002b94:	1800                	addi	s0,sp,48
    80002b96:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b98:	4585                	li	a1,1
    80002b9a:	00000097          	auipc	ra,0x0
    80002b9e:	8ec080e7          	jalr	-1812(ra) # 80002486 <bread>
    80002ba2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ba4:	00018997          	auipc	s3,0x18
    80002ba8:	f2498993          	addi	s3,s3,-220 # 8001aac8 <sb>
    80002bac:	02000613          	li	a2,32
    80002bb0:	06050593          	addi	a1,a0,96
    80002bb4:	854e                	mv	a0,s3
    80002bb6:	ffffd097          	auipc	ra,0xffffd
    80002bba:	758080e7          	jalr	1880(ra) # 8000030e <memmove>
  brelse(bp);
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	b4c080e7          	jalr	-1204(ra) # 8000270c <brelse>
  if(sb.magic != FSMAGIC)
    80002bc8:	0009a703          	lw	a4,0(s3)
    80002bcc:	102037b7          	lui	a5,0x10203
    80002bd0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bd4:	02f71263          	bne	a4,a5,80002bf8 <fsinit+0x70>
  initlog(dev, &sb);
    80002bd8:	00018597          	auipc	a1,0x18
    80002bdc:	ef058593          	addi	a1,a1,-272 # 8001aac8 <sb>
    80002be0:	854a                	mv	a0,s2
    80002be2:	00001097          	auipc	ra,0x1
    80002be6:	b54080e7          	jalr	-1196(ra) # 80003736 <initlog>
}
    80002bea:	70a2                	ld	ra,40(sp)
    80002bec:	7402                	ld	s0,32(sp)
    80002bee:	64e2                	ld	s1,24(sp)
    80002bf0:	6942                	ld	s2,16(sp)
    80002bf2:	69a2                	ld	s3,8(sp)
    80002bf4:	6145                	addi	sp,sp,48
    80002bf6:	8082                	ret
    panic("invalid file system");
    80002bf8:	00006517          	auipc	a0,0x6
    80002bfc:	96050513          	addi	a0,a0,-1696 # 80008558 <syscalls+0x148>
    80002c00:	00003097          	auipc	ra,0x3
    80002c04:	692080e7          	jalr	1682(ra) # 80006292 <panic>

0000000080002c08 <iinit>:
{
    80002c08:	7179                	addi	sp,sp,-48
    80002c0a:	f406                	sd	ra,40(sp)
    80002c0c:	f022                	sd	s0,32(sp)
    80002c0e:	ec26                	sd	s1,24(sp)
    80002c10:	e84a                	sd	s2,16(sp)
    80002c12:	e44e                	sd	s3,8(sp)
    80002c14:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c16:	00006597          	auipc	a1,0x6
    80002c1a:	95a58593          	addi	a1,a1,-1702 # 80008570 <syscalls+0x160>
    80002c1e:	00018517          	auipc	a0,0x18
    80002c22:	eca50513          	addi	a0,a0,-310 # 8001aae8 <itable>
    80002c26:	00004097          	auipc	ra,0x4
    80002c2a:	d1c080e7          	jalr	-740(ra) # 80006942 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c2e:	00018497          	auipc	s1,0x18
    80002c32:	eea48493          	addi	s1,s1,-278 # 8001ab18 <itable+0x30>
    80002c36:	0001a997          	auipc	s3,0x1a
    80002c3a:	b0298993          	addi	s3,s3,-1278 # 8001c738 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c3e:	00006917          	auipc	s2,0x6
    80002c42:	93a90913          	addi	s2,s2,-1734 # 80008578 <syscalls+0x168>
    80002c46:	85ca                	mv	a1,s2
    80002c48:	8526                	mv	a0,s1
    80002c4a:	00001097          	auipc	ra,0x1
    80002c4e:	e4e080e7          	jalr	-434(ra) # 80003a98 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c52:	09048493          	addi	s1,s1,144
    80002c56:	ff3498e3          	bne	s1,s3,80002c46 <iinit+0x3e>
}
    80002c5a:	70a2                	ld	ra,40(sp)
    80002c5c:	7402                	ld	s0,32(sp)
    80002c5e:	64e2                	ld	s1,24(sp)
    80002c60:	6942                	ld	s2,16(sp)
    80002c62:	69a2                	ld	s3,8(sp)
    80002c64:	6145                	addi	sp,sp,48
    80002c66:	8082                	ret

0000000080002c68 <ialloc>:
{
    80002c68:	715d                	addi	sp,sp,-80
    80002c6a:	e486                	sd	ra,72(sp)
    80002c6c:	e0a2                	sd	s0,64(sp)
    80002c6e:	fc26                	sd	s1,56(sp)
    80002c70:	f84a                	sd	s2,48(sp)
    80002c72:	f44e                	sd	s3,40(sp)
    80002c74:	f052                	sd	s4,32(sp)
    80002c76:	ec56                	sd	s5,24(sp)
    80002c78:	e85a                	sd	s6,16(sp)
    80002c7a:	e45e                	sd	s7,8(sp)
    80002c7c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c7e:	00018717          	auipc	a4,0x18
    80002c82:	e5672703          	lw	a4,-426(a4) # 8001aad4 <sb+0xc>
    80002c86:	4785                	li	a5,1
    80002c88:	04e7fa63          	bgeu	a5,a4,80002cdc <ialloc+0x74>
    80002c8c:	8aaa                	mv	s5,a0
    80002c8e:	8bae                	mv	s7,a1
    80002c90:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c92:	00018a17          	auipc	s4,0x18
    80002c96:	e36a0a13          	addi	s4,s4,-458 # 8001aac8 <sb>
    80002c9a:	00048b1b          	sext.w	s6,s1
    80002c9e:	0044d593          	srli	a1,s1,0x4
    80002ca2:	018a2783          	lw	a5,24(s4)
    80002ca6:	9dbd                	addw	a1,a1,a5
    80002ca8:	8556                	mv	a0,s5
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	7dc080e7          	jalr	2012(ra) # 80002486 <bread>
    80002cb2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cb4:	06050993          	addi	s3,a0,96
    80002cb8:	00f4f793          	andi	a5,s1,15
    80002cbc:	079a                	slli	a5,a5,0x6
    80002cbe:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cc0:	00099783          	lh	a5,0(s3)
    80002cc4:	c3a1                	beqz	a5,80002d04 <ialloc+0x9c>
    brelse(bp);
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	a46080e7          	jalr	-1466(ra) # 8000270c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cce:	0485                	addi	s1,s1,1
    80002cd0:	00ca2703          	lw	a4,12(s4)
    80002cd4:	0004879b          	sext.w	a5,s1
    80002cd8:	fce7e1e3          	bltu	a5,a4,80002c9a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002cdc:	00006517          	auipc	a0,0x6
    80002ce0:	8a450513          	addi	a0,a0,-1884 # 80008580 <syscalls+0x170>
    80002ce4:	00003097          	auipc	ra,0x3
    80002ce8:	5f8080e7          	jalr	1528(ra) # 800062dc <printf>
  return 0;
    80002cec:	4501                	li	a0,0
}
    80002cee:	60a6                	ld	ra,72(sp)
    80002cf0:	6406                	ld	s0,64(sp)
    80002cf2:	74e2                	ld	s1,56(sp)
    80002cf4:	7942                	ld	s2,48(sp)
    80002cf6:	79a2                	ld	s3,40(sp)
    80002cf8:	7a02                	ld	s4,32(sp)
    80002cfa:	6ae2                	ld	s5,24(sp)
    80002cfc:	6b42                	ld	s6,16(sp)
    80002cfe:	6ba2                	ld	s7,8(sp)
    80002d00:	6161                	addi	sp,sp,80
    80002d02:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d04:	04000613          	li	a2,64
    80002d08:	4581                	li	a1,0
    80002d0a:	854e                	mv	a0,s3
    80002d0c:	ffffd097          	auipc	ra,0xffffd
    80002d10:	5a2080e7          	jalr	1442(ra) # 800002ae <memset>
      dip->type = type;
    80002d14:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d18:	854a                	mv	a0,s2
    80002d1a:	00001097          	auipc	ra,0x1
    80002d1e:	c98080e7          	jalr	-872(ra) # 800039b2 <log_write>
      brelse(bp);
    80002d22:	854a                	mv	a0,s2
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	9e8080e7          	jalr	-1560(ra) # 8000270c <brelse>
      return iget(dev, inum);
    80002d2c:	85da                	mv	a1,s6
    80002d2e:	8556                	mv	a0,s5
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	d9c080e7          	jalr	-612(ra) # 80002acc <iget>
    80002d38:	bf5d                	j	80002cee <ialloc+0x86>

0000000080002d3a <iupdate>:
{
    80002d3a:	1101                	addi	sp,sp,-32
    80002d3c:	ec06                	sd	ra,24(sp)
    80002d3e:	e822                	sd	s0,16(sp)
    80002d40:	e426                	sd	s1,8(sp)
    80002d42:	e04a                	sd	s2,0(sp)
    80002d44:	1000                	addi	s0,sp,32
    80002d46:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d48:	415c                	lw	a5,4(a0)
    80002d4a:	0047d79b          	srliw	a5,a5,0x4
    80002d4e:	00018597          	auipc	a1,0x18
    80002d52:	d925a583          	lw	a1,-622(a1) # 8001aae0 <sb+0x18>
    80002d56:	9dbd                	addw	a1,a1,a5
    80002d58:	4108                	lw	a0,0(a0)
    80002d5a:	fffff097          	auipc	ra,0xfffff
    80002d5e:	72c080e7          	jalr	1836(ra) # 80002486 <bread>
    80002d62:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d64:	06050793          	addi	a5,a0,96
    80002d68:	40c8                	lw	a0,4(s1)
    80002d6a:	893d                	andi	a0,a0,15
    80002d6c:	051a                	slli	a0,a0,0x6
    80002d6e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d70:	04c49703          	lh	a4,76(s1)
    80002d74:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d78:	04e49703          	lh	a4,78(s1)
    80002d7c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d80:	05049703          	lh	a4,80(s1)
    80002d84:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d88:	05249703          	lh	a4,82(s1)
    80002d8c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d90:	48f8                	lw	a4,84(s1)
    80002d92:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d94:	03400613          	li	a2,52
    80002d98:	05848593          	addi	a1,s1,88
    80002d9c:	0531                	addi	a0,a0,12
    80002d9e:	ffffd097          	auipc	ra,0xffffd
    80002da2:	570080e7          	jalr	1392(ra) # 8000030e <memmove>
  log_write(bp);
    80002da6:	854a                	mv	a0,s2
    80002da8:	00001097          	auipc	ra,0x1
    80002dac:	c0a080e7          	jalr	-1014(ra) # 800039b2 <log_write>
  brelse(bp);
    80002db0:	854a                	mv	a0,s2
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	95a080e7          	jalr	-1702(ra) # 8000270c <brelse>
}
    80002dba:	60e2                	ld	ra,24(sp)
    80002dbc:	6442                	ld	s0,16(sp)
    80002dbe:	64a2                	ld	s1,8(sp)
    80002dc0:	6902                	ld	s2,0(sp)
    80002dc2:	6105                	addi	sp,sp,32
    80002dc4:	8082                	ret

0000000080002dc6 <idup>:
{
    80002dc6:	1101                	addi	sp,sp,-32
    80002dc8:	ec06                	sd	ra,24(sp)
    80002dca:	e822                	sd	s0,16(sp)
    80002dcc:	e426                	sd	s1,8(sp)
    80002dce:	1000                	addi	s0,sp,32
    80002dd0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dd2:	00018517          	auipc	a0,0x18
    80002dd6:	d1650513          	addi	a0,a0,-746 # 8001aae8 <itable>
    80002dda:	00004097          	auipc	ra,0x4
    80002dde:	9ec080e7          	jalr	-1556(ra) # 800067c6 <acquire>
  ip->ref++;
    80002de2:	449c                	lw	a5,8(s1)
    80002de4:	2785                	addiw	a5,a5,1
    80002de6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de8:	00018517          	auipc	a0,0x18
    80002dec:	d0050513          	addi	a0,a0,-768 # 8001aae8 <itable>
    80002df0:	00004097          	auipc	ra,0x4
    80002df4:	aa6080e7          	jalr	-1370(ra) # 80006896 <release>
}
    80002df8:	8526                	mv	a0,s1
    80002dfa:	60e2                	ld	ra,24(sp)
    80002dfc:	6442                	ld	s0,16(sp)
    80002dfe:	64a2                	ld	s1,8(sp)
    80002e00:	6105                	addi	sp,sp,32
    80002e02:	8082                	ret

0000000080002e04 <ilock>:
{
    80002e04:	1101                	addi	sp,sp,-32
    80002e06:	ec06                	sd	ra,24(sp)
    80002e08:	e822                	sd	s0,16(sp)
    80002e0a:	e426                	sd	s1,8(sp)
    80002e0c:	e04a                	sd	s2,0(sp)
    80002e0e:	1000                	addi	s0,sp,32
  if(ip == 0 || atomic_read4(&ip->ref) < 1)
    80002e10:	c51d                	beqz	a0,80002e3e <ilock+0x3a>
    80002e12:	84aa                	mv	s1,a0
    80002e14:	0521                	addi	a0,a0,8
    80002e16:	00004097          	auipc	ra,0x4
    80002e1a:	bac080e7          	jalr	-1108(ra) # 800069c2 <atomic_read4>
    80002e1e:	02a05063          	blez	a0,80002e3e <ilock+0x3a>
  acquiresleep(&ip->lock);
    80002e22:	01048513          	addi	a0,s1,16
    80002e26:	00001097          	auipc	ra,0x1
    80002e2a:	cac080e7          	jalr	-852(ra) # 80003ad2 <acquiresleep>
  if(ip->valid == 0){
    80002e2e:	44bc                	lw	a5,72(s1)
    80002e30:	cf99                	beqz	a5,80002e4e <ilock+0x4a>
}
    80002e32:	60e2                	ld	ra,24(sp)
    80002e34:	6442                	ld	s0,16(sp)
    80002e36:	64a2                	ld	s1,8(sp)
    80002e38:	6902                	ld	s2,0(sp)
    80002e3a:	6105                	addi	sp,sp,32
    80002e3c:	8082                	ret
    panic("ilock");
    80002e3e:	00005517          	auipc	a0,0x5
    80002e42:	75a50513          	addi	a0,a0,1882 # 80008598 <syscalls+0x188>
    80002e46:	00003097          	auipc	ra,0x3
    80002e4a:	44c080e7          	jalr	1100(ra) # 80006292 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e4e:	40dc                	lw	a5,4(s1)
    80002e50:	0047d79b          	srliw	a5,a5,0x4
    80002e54:	00018597          	auipc	a1,0x18
    80002e58:	c8c5a583          	lw	a1,-884(a1) # 8001aae0 <sb+0x18>
    80002e5c:	9dbd                	addw	a1,a1,a5
    80002e5e:	4088                	lw	a0,0(s1)
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	626080e7          	jalr	1574(ra) # 80002486 <bread>
    80002e68:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e6a:	06050593          	addi	a1,a0,96
    80002e6e:	40dc                	lw	a5,4(s1)
    80002e70:	8bbd                	andi	a5,a5,15
    80002e72:	079a                	slli	a5,a5,0x6
    80002e74:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e76:	00059783          	lh	a5,0(a1)
    80002e7a:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002e7e:	00259783          	lh	a5,2(a1)
    80002e82:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002e86:	00459783          	lh	a5,4(a1)
    80002e8a:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002e8e:	00659783          	lh	a5,6(a1)
    80002e92:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002e96:	459c                	lw	a5,8(a1)
    80002e98:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e9a:	03400613          	li	a2,52
    80002e9e:	05b1                	addi	a1,a1,12
    80002ea0:	05848513          	addi	a0,s1,88
    80002ea4:	ffffd097          	auipc	ra,0xffffd
    80002ea8:	46a080e7          	jalr	1130(ra) # 8000030e <memmove>
    brelse(bp);
    80002eac:	854a                	mv	a0,s2
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	85e080e7          	jalr	-1954(ra) # 8000270c <brelse>
    ip->valid = 1;
    80002eb6:	4785                	li	a5,1
    80002eb8:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002eba:	04c49783          	lh	a5,76(s1)
    80002ebe:	fbb5                	bnez	a5,80002e32 <ilock+0x2e>
      panic("ilock: no type");
    80002ec0:	00005517          	auipc	a0,0x5
    80002ec4:	6e050513          	addi	a0,a0,1760 # 800085a0 <syscalls+0x190>
    80002ec8:	00003097          	auipc	ra,0x3
    80002ecc:	3ca080e7          	jalr	970(ra) # 80006292 <panic>

0000000080002ed0 <iunlock>:
{
    80002ed0:	1101                	addi	sp,sp,-32
    80002ed2:	ec06                	sd	ra,24(sp)
    80002ed4:	e822                	sd	s0,16(sp)
    80002ed6:	e426                	sd	s1,8(sp)
    80002ed8:	e04a                	sd	s2,0(sp)
    80002eda:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || atomic_read4(&ip->ref) < 1)
    80002edc:	cd0d                	beqz	a0,80002f16 <iunlock+0x46>
    80002ede:	84aa                	mv	s1,a0
    80002ee0:	01050913          	addi	s2,a0,16
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	00001097          	auipc	ra,0x1
    80002eea:	c86080e7          	jalr	-890(ra) # 80003b6c <holdingsleep>
    80002eee:	c505                	beqz	a0,80002f16 <iunlock+0x46>
    80002ef0:	00848513          	addi	a0,s1,8
    80002ef4:	00004097          	auipc	ra,0x4
    80002ef8:	ace080e7          	jalr	-1330(ra) # 800069c2 <atomic_read4>
    80002efc:	00a05d63          	blez	a0,80002f16 <iunlock+0x46>
  releasesleep(&ip->lock);
    80002f00:	854a                	mv	a0,s2
    80002f02:	00001097          	auipc	ra,0x1
    80002f06:	c26080e7          	jalr	-986(ra) # 80003b28 <releasesleep>
}
    80002f0a:	60e2                	ld	ra,24(sp)
    80002f0c:	6442                	ld	s0,16(sp)
    80002f0e:	64a2                	ld	s1,8(sp)
    80002f10:	6902                	ld	s2,0(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret
    panic("iunlock");
    80002f16:	00005517          	auipc	a0,0x5
    80002f1a:	69a50513          	addi	a0,a0,1690 # 800085b0 <syscalls+0x1a0>
    80002f1e:	00003097          	auipc	ra,0x3
    80002f22:	374080e7          	jalr	884(ra) # 80006292 <panic>

0000000080002f26 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f26:	7179                	addi	sp,sp,-48
    80002f28:	f406                	sd	ra,40(sp)
    80002f2a:	f022                	sd	s0,32(sp)
    80002f2c:	ec26                	sd	s1,24(sp)
    80002f2e:	e84a                	sd	s2,16(sp)
    80002f30:	e44e                	sd	s3,8(sp)
    80002f32:	e052                	sd	s4,0(sp)
    80002f34:	1800                	addi	s0,sp,48
    80002f36:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f38:	05850493          	addi	s1,a0,88
    80002f3c:	08850913          	addi	s2,a0,136
    80002f40:	a021                	j	80002f48 <itrunc+0x22>
    80002f42:	0491                	addi	s1,s1,4
    80002f44:	01248d63          	beq	s1,s2,80002f5e <itrunc+0x38>
    if(ip->addrs[i]){
    80002f48:	408c                	lw	a1,0(s1)
    80002f4a:	dde5                	beqz	a1,80002f42 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f4c:	0009a503          	lw	a0,0(s3)
    80002f50:	00000097          	auipc	ra,0x0
    80002f54:	8e0080e7          	jalr	-1824(ra) # 80002830 <bfree>
      ip->addrs[i] = 0;
    80002f58:	0004a023          	sw	zero,0(s1)
    80002f5c:	b7dd                	j	80002f42 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f5e:	0889a583          	lw	a1,136(s3)
    80002f62:	e185                	bnez	a1,80002f82 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  ip->size = 0;
    80002f64:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f68:	854e                	mv	a0,s3
    80002f6a:	00000097          	auipc	ra,0x0
    80002f6e:	dd0080e7          	jalr	-560(ra) # 80002d3a <iupdate>
}
    80002f72:	70a2                	ld	ra,40(sp)
    80002f74:	7402                	ld	s0,32(sp)
    80002f76:	64e2                	ld	s1,24(sp)
    80002f78:	6942                	ld	s2,16(sp)
    80002f7a:	69a2                	ld	s3,8(sp)
    80002f7c:	6a02                	ld	s4,0(sp)
    80002f7e:	6145                	addi	sp,sp,48
    80002f80:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f82:	0009a503          	lw	a0,0(s3)
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	500080e7          	jalr	1280(ra) # 80002486 <bread>
    80002f8e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f90:	06050493          	addi	s1,a0,96
    80002f94:	46050913          	addi	s2,a0,1120
    80002f98:	a811                	j	80002fac <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f9a:	0009a503          	lw	a0,0(s3)
    80002f9e:	00000097          	auipc	ra,0x0
    80002fa2:	892080e7          	jalr	-1902(ra) # 80002830 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002fa6:	0491                	addi	s1,s1,4
    80002fa8:	01248563          	beq	s1,s2,80002fb2 <itrunc+0x8c>
      if(a[j])
    80002fac:	408c                	lw	a1,0(s1)
    80002fae:	dde5                	beqz	a1,80002fa6 <itrunc+0x80>
    80002fb0:	b7ed                	j	80002f9a <itrunc+0x74>
    brelse(bp);
    80002fb2:	8552                	mv	a0,s4
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	758080e7          	jalr	1880(ra) # 8000270c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fbc:	0889a583          	lw	a1,136(s3)
    80002fc0:	0009a503          	lw	a0,0(s3)
    80002fc4:	00000097          	auipc	ra,0x0
    80002fc8:	86c080e7          	jalr	-1940(ra) # 80002830 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fcc:	0809a423          	sw	zero,136(s3)
    80002fd0:	bf51                	j	80002f64 <itrunc+0x3e>

0000000080002fd2 <iput>:
{
    80002fd2:	1101                	addi	sp,sp,-32
    80002fd4:	ec06                	sd	ra,24(sp)
    80002fd6:	e822                	sd	s0,16(sp)
    80002fd8:	e426                	sd	s1,8(sp)
    80002fda:	e04a                	sd	s2,0(sp)
    80002fdc:	1000                	addi	s0,sp,32
    80002fde:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fe0:	00018517          	auipc	a0,0x18
    80002fe4:	b0850513          	addi	a0,a0,-1272 # 8001aae8 <itable>
    80002fe8:	00003097          	auipc	ra,0x3
    80002fec:	7de080e7          	jalr	2014(ra) # 800067c6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ff0:	4498                	lw	a4,8(s1)
    80002ff2:	4785                	li	a5,1
    80002ff4:	02f70363          	beq	a4,a5,8000301a <iput+0x48>
  ip->ref--;
    80002ff8:	449c                	lw	a5,8(s1)
    80002ffa:	37fd                	addiw	a5,a5,-1
    80002ffc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ffe:	00018517          	auipc	a0,0x18
    80003002:	aea50513          	addi	a0,a0,-1302 # 8001aae8 <itable>
    80003006:	00004097          	auipc	ra,0x4
    8000300a:	890080e7          	jalr	-1904(ra) # 80006896 <release>
}
    8000300e:	60e2                	ld	ra,24(sp)
    80003010:	6442                	ld	s0,16(sp)
    80003012:	64a2                	ld	s1,8(sp)
    80003014:	6902                	ld	s2,0(sp)
    80003016:	6105                	addi	sp,sp,32
    80003018:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000301a:	44bc                	lw	a5,72(s1)
    8000301c:	dff1                	beqz	a5,80002ff8 <iput+0x26>
    8000301e:	05249783          	lh	a5,82(s1)
    80003022:	fbf9                	bnez	a5,80002ff8 <iput+0x26>
    acquiresleep(&ip->lock);
    80003024:	01048913          	addi	s2,s1,16
    80003028:	854a                	mv	a0,s2
    8000302a:	00001097          	auipc	ra,0x1
    8000302e:	aa8080e7          	jalr	-1368(ra) # 80003ad2 <acquiresleep>
    release(&itable.lock);
    80003032:	00018517          	auipc	a0,0x18
    80003036:	ab650513          	addi	a0,a0,-1354 # 8001aae8 <itable>
    8000303a:	00004097          	auipc	ra,0x4
    8000303e:	85c080e7          	jalr	-1956(ra) # 80006896 <release>
    itrunc(ip);
    80003042:	8526                	mv	a0,s1
    80003044:	00000097          	auipc	ra,0x0
    80003048:	ee2080e7          	jalr	-286(ra) # 80002f26 <itrunc>
    ip->type = 0;
    8000304c:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003050:	8526                	mv	a0,s1
    80003052:	00000097          	auipc	ra,0x0
    80003056:	ce8080e7          	jalr	-792(ra) # 80002d3a <iupdate>
    ip->valid = 0;
    8000305a:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    8000305e:	854a                	mv	a0,s2
    80003060:	00001097          	auipc	ra,0x1
    80003064:	ac8080e7          	jalr	-1336(ra) # 80003b28 <releasesleep>
    acquire(&itable.lock);
    80003068:	00018517          	auipc	a0,0x18
    8000306c:	a8050513          	addi	a0,a0,-1408 # 8001aae8 <itable>
    80003070:	00003097          	auipc	ra,0x3
    80003074:	756080e7          	jalr	1878(ra) # 800067c6 <acquire>
    80003078:	b741                	j	80002ff8 <iput+0x26>

000000008000307a <iunlockput>:
{
    8000307a:	1101                	addi	sp,sp,-32
    8000307c:	ec06                	sd	ra,24(sp)
    8000307e:	e822                	sd	s0,16(sp)
    80003080:	e426                	sd	s1,8(sp)
    80003082:	1000                	addi	s0,sp,32
    80003084:	84aa                	mv	s1,a0
  iunlock(ip);
    80003086:	00000097          	auipc	ra,0x0
    8000308a:	e4a080e7          	jalr	-438(ra) # 80002ed0 <iunlock>
  iput(ip);
    8000308e:	8526                	mv	a0,s1
    80003090:	00000097          	auipc	ra,0x0
    80003094:	f42080e7          	jalr	-190(ra) # 80002fd2 <iput>
}
    80003098:	60e2                	ld	ra,24(sp)
    8000309a:	6442                	ld	s0,16(sp)
    8000309c:	64a2                	ld	s1,8(sp)
    8000309e:	6105                	addi	sp,sp,32
    800030a0:	8082                	ret

00000000800030a2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030a2:	1141                	addi	sp,sp,-16
    800030a4:	e422                	sd	s0,8(sp)
    800030a6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030a8:	411c                	lw	a5,0(a0)
    800030aa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030ac:	415c                	lw	a5,4(a0)
    800030ae:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030b0:	04c51783          	lh	a5,76(a0)
    800030b4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030b8:	05251783          	lh	a5,82(a0)
    800030bc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030c0:	05456783          	lwu	a5,84(a0)
    800030c4:	e99c                	sd	a5,16(a1)
}
    800030c6:	6422                	ld	s0,8(sp)
    800030c8:	0141                	addi	sp,sp,16
    800030ca:	8082                	ret

00000000800030cc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030cc:	497c                	lw	a5,84(a0)
    800030ce:	0ed7e963          	bltu	a5,a3,800031c0 <readi+0xf4>
{
    800030d2:	7159                	addi	sp,sp,-112
    800030d4:	f486                	sd	ra,104(sp)
    800030d6:	f0a2                	sd	s0,96(sp)
    800030d8:	eca6                	sd	s1,88(sp)
    800030da:	e8ca                	sd	s2,80(sp)
    800030dc:	e4ce                	sd	s3,72(sp)
    800030de:	e0d2                	sd	s4,64(sp)
    800030e0:	fc56                	sd	s5,56(sp)
    800030e2:	f85a                	sd	s6,48(sp)
    800030e4:	f45e                	sd	s7,40(sp)
    800030e6:	f062                	sd	s8,32(sp)
    800030e8:	ec66                	sd	s9,24(sp)
    800030ea:	e86a                	sd	s10,16(sp)
    800030ec:	e46e                	sd	s11,8(sp)
    800030ee:	1880                	addi	s0,sp,112
    800030f0:	8b2a                	mv	s6,a0
    800030f2:	8bae                	mv	s7,a1
    800030f4:	8a32                	mv	s4,a2
    800030f6:	84b6                	mv	s1,a3
    800030f8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800030fa:	9f35                	addw	a4,a4,a3
    return 0;
    800030fc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030fe:	0ad76063          	bltu	a4,a3,8000319e <readi+0xd2>
  if(off + n > ip->size)
    80003102:	00e7f463          	bgeu	a5,a4,8000310a <readi+0x3e>
    n = ip->size - off;
    80003106:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000310a:	0a0a8963          	beqz	s5,800031bc <readi+0xf0>
    8000310e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003110:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003114:	5c7d                	li	s8,-1
    80003116:	a82d                	j	80003150 <readi+0x84>
    80003118:	020d1d93          	slli	s11,s10,0x20
    8000311c:	020ddd93          	srli	s11,s11,0x20
    80003120:	06090613          	addi	a2,s2,96
    80003124:	86ee                	mv	a3,s11
    80003126:	963a                	add	a2,a2,a4
    80003128:	85d2                	mv	a1,s4
    8000312a:	855e                	mv	a0,s7
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	97a080e7          	jalr	-1670(ra) # 80001aa6 <either_copyout>
    80003134:	05850d63          	beq	a0,s8,8000318e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003138:	854a                	mv	a0,s2
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	5d2080e7          	jalr	1490(ra) # 8000270c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003142:	013d09bb          	addw	s3,s10,s3
    80003146:	009d04bb          	addw	s1,s10,s1
    8000314a:	9a6e                	add	s4,s4,s11
    8000314c:	0559f763          	bgeu	s3,s5,8000319a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003150:	00a4d59b          	srliw	a1,s1,0xa
    80003154:	855a                	mv	a0,s6
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	88e080e7          	jalr	-1906(ra) # 800029e4 <bmap>
    8000315e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003162:	cd85                	beqz	a1,8000319a <readi+0xce>
    bp = bread(ip->dev, addr);
    80003164:	000b2503          	lw	a0,0(s6)
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	31e080e7          	jalr	798(ra) # 80002486 <bread>
    80003170:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003172:	3ff4f713          	andi	a4,s1,1023
    80003176:	40ec87bb          	subw	a5,s9,a4
    8000317a:	413a86bb          	subw	a3,s5,s3
    8000317e:	8d3e                	mv	s10,a5
    80003180:	2781                	sext.w	a5,a5
    80003182:	0006861b          	sext.w	a2,a3
    80003186:	f8f679e3          	bgeu	a2,a5,80003118 <readi+0x4c>
    8000318a:	8d36                	mv	s10,a3
    8000318c:	b771                	j	80003118 <readi+0x4c>
      brelse(bp);
    8000318e:	854a                	mv	a0,s2
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	57c080e7          	jalr	1404(ra) # 8000270c <brelse>
      tot = -1;
    80003198:	59fd                	li	s3,-1
  }
  return tot;
    8000319a:	0009851b          	sext.w	a0,s3
}
    8000319e:	70a6                	ld	ra,104(sp)
    800031a0:	7406                	ld	s0,96(sp)
    800031a2:	64e6                	ld	s1,88(sp)
    800031a4:	6946                	ld	s2,80(sp)
    800031a6:	69a6                	ld	s3,72(sp)
    800031a8:	6a06                	ld	s4,64(sp)
    800031aa:	7ae2                	ld	s5,56(sp)
    800031ac:	7b42                	ld	s6,48(sp)
    800031ae:	7ba2                	ld	s7,40(sp)
    800031b0:	7c02                	ld	s8,32(sp)
    800031b2:	6ce2                	ld	s9,24(sp)
    800031b4:	6d42                	ld	s10,16(sp)
    800031b6:	6da2                	ld	s11,8(sp)
    800031b8:	6165                	addi	sp,sp,112
    800031ba:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031bc:	89d6                	mv	s3,s5
    800031be:	bff1                	j	8000319a <readi+0xce>
    return 0;
    800031c0:	4501                	li	a0,0
}
    800031c2:	8082                	ret

00000000800031c4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031c4:	497c                	lw	a5,84(a0)
    800031c6:	10d7e863          	bltu	a5,a3,800032d6 <writei+0x112>
{
    800031ca:	7159                	addi	sp,sp,-112
    800031cc:	f486                	sd	ra,104(sp)
    800031ce:	f0a2                	sd	s0,96(sp)
    800031d0:	eca6                	sd	s1,88(sp)
    800031d2:	e8ca                	sd	s2,80(sp)
    800031d4:	e4ce                	sd	s3,72(sp)
    800031d6:	e0d2                	sd	s4,64(sp)
    800031d8:	fc56                	sd	s5,56(sp)
    800031da:	f85a                	sd	s6,48(sp)
    800031dc:	f45e                	sd	s7,40(sp)
    800031de:	f062                	sd	s8,32(sp)
    800031e0:	ec66                	sd	s9,24(sp)
    800031e2:	e86a                	sd	s10,16(sp)
    800031e4:	e46e                	sd	s11,8(sp)
    800031e6:	1880                	addi	s0,sp,112
    800031e8:	8aaa                	mv	s5,a0
    800031ea:	8bae                	mv	s7,a1
    800031ec:	8a32                	mv	s4,a2
    800031ee:	8936                	mv	s2,a3
    800031f0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800031f2:	00e687bb          	addw	a5,a3,a4
    800031f6:	0ed7e263          	bltu	a5,a3,800032da <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031fa:	00043737          	lui	a4,0x43
    800031fe:	0ef76063          	bltu	a4,a5,800032de <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003202:	0c0b0863          	beqz	s6,800032d2 <writei+0x10e>
    80003206:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003208:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000320c:	5c7d                	li	s8,-1
    8000320e:	a091                	j	80003252 <writei+0x8e>
    80003210:	020d1d93          	slli	s11,s10,0x20
    80003214:	020ddd93          	srli	s11,s11,0x20
    80003218:	06048513          	addi	a0,s1,96
    8000321c:	86ee                	mv	a3,s11
    8000321e:	8652                	mv	a2,s4
    80003220:	85de                	mv	a1,s7
    80003222:	953a                	add	a0,a0,a4
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	8d8080e7          	jalr	-1832(ra) # 80001afc <either_copyin>
    8000322c:	07850263          	beq	a0,s8,80003290 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003230:	8526                	mv	a0,s1
    80003232:	00000097          	auipc	ra,0x0
    80003236:	780080e7          	jalr	1920(ra) # 800039b2 <log_write>
    brelse(bp);
    8000323a:	8526                	mv	a0,s1
    8000323c:	fffff097          	auipc	ra,0xfffff
    80003240:	4d0080e7          	jalr	1232(ra) # 8000270c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003244:	013d09bb          	addw	s3,s10,s3
    80003248:	012d093b          	addw	s2,s10,s2
    8000324c:	9a6e                	add	s4,s4,s11
    8000324e:	0569f663          	bgeu	s3,s6,8000329a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003252:	00a9559b          	srliw	a1,s2,0xa
    80003256:	8556                	mv	a0,s5
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	78c080e7          	jalr	1932(ra) # 800029e4 <bmap>
    80003260:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003264:	c99d                	beqz	a1,8000329a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003266:	000aa503          	lw	a0,0(s5)
    8000326a:	fffff097          	auipc	ra,0xfffff
    8000326e:	21c080e7          	jalr	540(ra) # 80002486 <bread>
    80003272:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003274:	3ff97713          	andi	a4,s2,1023
    80003278:	40ec87bb          	subw	a5,s9,a4
    8000327c:	413b06bb          	subw	a3,s6,s3
    80003280:	8d3e                	mv	s10,a5
    80003282:	2781                	sext.w	a5,a5
    80003284:	0006861b          	sext.w	a2,a3
    80003288:	f8f674e3          	bgeu	a2,a5,80003210 <writei+0x4c>
    8000328c:	8d36                	mv	s10,a3
    8000328e:	b749                	j	80003210 <writei+0x4c>
      brelse(bp);
    80003290:	8526                	mv	a0,s1
    80003292:	fffff097          	auipc	ra,0xfffff
    80003296:	47a080e7          	jalr	1146(ra) # 8000270c <brelse>
  }

  if(off > ip->size)
    8000329a:	054aa783          	lw	a5,84(s5)
    8000329e:	0127f463          	bgeu	a5,s2,800032a6 <writei+0xe2>
    ip->size = off;
    800032a2:	052aaa23          	sw	s2,84(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032a6:	8556                	mv	a0,s5
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	a92080e7          	jalr	-1390(ra) # 80002d3a <iupdate>

  return tot;
    800032b0:	0009851b          	sext.w	a0,s3
}
    800032b4:	70a6                	ld	ra,104(sp)
    800032b6:	7406                	ld	s0,96(sp)
    800032b8:	64e6                	ld	s1,88(sp)
    800032ba:	6946                	ld	s2,80(sp)
    800032bc:	69a6                	ld	s3,72(sp)
    800032be:	6a06                	ld	s4,64(sp)
    800032c0:	7ae2                	ld	s5,56(sp)
    800032c2:	7b42                	ld	s6,48(sp)
    800032c4:	7ba2                	ld	s7,40(sp)
    800032c6:	7c02                	ld	s8,32(sp)
    800032c8:	6ce2                	ld	s9,24(sp)
    800032ca:	6d42                	ld	s10,16(sp)
    800032cc:	6da2                	ld	s11,8(sp)
    800032ce:	6165                	addi	sp,sp,112
    800032d0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032d2:	89da                	mv	s3,s6
    800032d4:	bfc9                	j	800032a6 <writei+0xe2>
    return -1;
    800032d6:	557d                	li	a0,-1
}
    800032d8:	8082                	ret
    return -1;
    800032da:	557d                	li	a0,-1
    800032dc:	bfe1                	j	800032b4 <writei+0xf0>
    return -1;
    800032de:	557d                	li	a0,-1
    800032e0:	bfd1                	j	800032b4 <writei+0xf0>

00000000800032e2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032e2:	1141                	addi	sp,sp,-16
    800032e4:	e406                	sd	ra,8(sp)
    800032e6:	e022                	sd	s0,0(sp)
    800032e8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032ea:	4639                	li	a2,14
    800032ec:	ffffd097          	auipc	ra,0xffffd
    800032f0:	09a080e7          	jalr	154(ra) # 80000386 <strncmp>
}
    800032f4:	60a2                	ld	ra,8(sp)
    800032f6:	6402                	ld	s0,0(sp)
    800032f8:	0141                	addi	sp,sp,16
    800032fa:	8082                	ret

00000000800032fc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032fc:	7139                	addi	sp,sp,-64
    800032fe:	fc06                	sd	ra,56(sp)
    80003300:	f822                	sd	s0,48(sp)
    80003302:	f426                	sd	s1,40(sp)
    80003304:	f04a                	sd	s2,32(sp)
    80003306:	ec4e                	sd	s3,24(sp)
    80003308:	e852                	sd	s4,16(sp)
    8000330a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000330c:	04c51703          	lh	a4,76(a0)
    80003310:	4785                	li	a5,1
    80003312:	00f71a63          	bne	a4,a5,80003326 <dirlookup+0x2a>
    80003316:	892a                	mv	s2,a0
    80003318:	89ae                	mv	s3,a1
    8000331a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000331c:	497c                	lw	a5,84(a0)
    8000331e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003320:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003322:	e79d                	bnez	a5,80003350 <dirlookup+0x54>
    80003324:	a8a5                	j	8000339c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003326:	00005517          	auipc	a0,0x5
    8000332a:	29250513          	addi	a0,a0,658 # 800085b8 <syscalls+0x1a8>
    8000332e:	00003097          	auipc	ra,0x3
    80003332:	f64080e7          	jalr	-156(ra) # 80006292 <panic>
      panic("dirlookup read");
    80003336:	00005517          	auipc	a0,0x5
    8000333a:	29a50513          	addi	a0,a0,666 # 800085d0 <syscalls+0x1c0>
    8000333e:	00003097          	auipc	ra,0x3
    80003342:	f54080e7          	jalr	-172(ra) # 80006292 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003346:	24c1                	addiw	s1,s1,16
    80003348:	05492783          	lw	a5,84(s2)
    8000334c:	04f4f763          	bgeu	s1,a5,8000339a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003350:	4741                	li	a4,16
    80003352:	86a6                	mv	a3,s1
    80003354:	fc040613          	addi	a2,s0,-64
    80003358:	4581                	li	a1,0
    8000335a:	854a                	mv	a0,s2
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	d70080e7          	jalr	-656(ra) # 800030cc <readi>
    80003364:	47c1                	li	a5,16
    80003366:	fcf518e3          	bne	a0,a5,80003336 <dirlookup+0x3a>
    if(de.inum == 0)
    8000336a:	fc045783          	lhu	a5,-64(s0)
    8000336e:	dfe1                	beqz	a5,80003346 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003370:	fc240593          	addi	a1,s0,-62
    80003374:	854e                	mv	a0,s3
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	f6c080e7          	jalr	-148(ra) # 800032e2 <namecmp>
    8000337e:	f561                	bnez	a0,80003346 <dirlookup+0x4a>
      if(poff)
    80003380:	000a0463          	beqz	s4,80003388 <dirlookup+0x8c>
        *poff = off;
    80003384:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003388:	fc045583          	lhu	a1,-64(s0)
    8000338c:	00092503          	lw	a0,0(s2)
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	73c080e7          	jalr	1852(ra) # 80002acc <iget>
    80003398:	a011                	j	8000339c <dirlookup+0xa0>
  return 0;
    8000339a:	4501                	li	a0,0
}
    8000339c:	70e2                	ld	ra,56(sp)
    8000339e:	7442                	ld	s0,48(sp)
    800033a0:	74a2                	ld	s1,40(sp)
    800033a2:	7902                	ld	s2,32(sp)
    800033a4:	69e2                	ld	s3,24(sp)
    800033a6:	6a42                	ld	s4,16(sp)
    800033a8:	6121                	addi	sp,sp,64
    800033aa:	8082                	ret

00000000800033ac <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033ac:	711d                	addi	sp,sp,-96
    800033ae:	ec86                	sd	ra,88(sp)
    800033b0:	e8a2                	sd	s0,80(sp)
    800033b2:	e4a6                	sd	s1,72(sp)
    800033b4:	e0ca                	sd	s2,64(sp)
    800033b6:	fc4e                	sd	s3,56(sp)
    800033b8:	f852                	sd	s4,48(sp)
    800033ba:	f456                	sd	s5,40(sp)
    800033bc:	f05a                	sd	s6,32(sp)
    800033be:	ec5e                	sd	s7,24(sp)
    800033c0:	e862                	sd	s8,16(sp)
    800033c2:	e466                	sd	s9,8(sp)
    800033c4:	1080                	addi	s0,sp,96
    800033c6:	84aa                	mv	s1,a0
    800033c8:	8b2e                	mv	s6,a1
    800033ca:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033cc:	00054703          	lbu	a4,0(a0)
    800033d0:	02f00793          	li	a5,47
    800033d4:	02f70363          	beq	a4,a5,800033fa <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033d8:	ffffe097          	auipc	ra,0xffffe
    800033dc:	c1e080e7          	jalr	-994(ra) # 80000ff6 <myproc>
    800033e0:	15853503          	ld	a0,344(a0)
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	9e2080e7          	jalr	-1566(ra) # 80002dc6 <idup>
    800033ec:	89aa                	mv	s3,a0
  while(*path == '/')
    800033ee:	02f00913          	li	s2,47
  len = path - s;
    800033f2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033f4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033f6:	4c05                	li	s8,1
    800033f8:	a865                	j	800034b0 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033fa:	4585                	li	a1,1
    800033fc:	4505                	li	a0,1
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	6ce080e7          	jalr	1742(ra) # 80002acc <iget>
    80003406:	89aa                	mv	s3,a0
    80003408:	b7dd                	j	800033ee <namex+0x42>
      iunlockput(ip);
    8000340a:	854e                	mv	a0,s3
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	c6e080e7          	jalr	-914(ra) # 8000307a <iunlockput>
      return 0;
    80003414:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003416:	854e                	mv	a0,s3
    80003418:	60e6                	ld	ra,88(sp)
    8000341a:	6446                	ld	s0,80(sp)
    8000341c:	64a6                	ld	s1,72(sp)
    8000341e:	6906                	ld	s2,64(sp)
    80003420:	79e2                	ld	s3,56(sp)
    80003422:	7a42                	ld	s4,48(sp)
    80003424:	7aa2                	ld	s5,40(sp)
    80003426:	7b02                	ld	s6,32(sp)
    80003428:	6be2                	ld	s7,24(sp)
    8000342a:	6c42                	ld	s8,16(sp)
    8000342c:	6ca2                	ld	s9,8(sp)
    8000342e:	6125                	addi	sp,sp,96
    80003430:	8082                	ret
      iunlock(ip);
    80003432:	854e                	mv	a0,s3
    80003434:	00000097          	auipc	ra,0x0
    80003438:	a9c080e7          	jalr	-1380(ra) # 80002ed0 <iunlock>
      return ip;
    8000343c:	bfe9                	j	80003416 <namex+0x6a>
      iunlockput(ip);
    8000343e:	854e                	mv	a0,s3
    80003440:	00000097          	auipc	ra,0x0
    80003444:	c3a080e7          	jalr	-966(ra) # 8000307a <iunlockput>
      return 0;
    80003448:	89d2                	mv	s3,s4
    8000344a:	b7f1                	j	80003416 <namex+0x6a>
  len = path - s;
    8000344c:	40b48633          	sub	a2,s1,a1
    80003450:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003454:	094cd463          	bge	s9,s4,800034dc <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003458:	4639                	li	a2,14
    8000345a:	8556                	mv	a0,s5
    8000345c:	ffffd097          	auipc	ra,0xffffd
    80003460:	eb2080e7          	jalr	-334(ra) # 8000030e <memmove>
  while(*path == '/')
    80003464:	0004c783          	lbu	a5,0(s1)
    80003468:	01279763          	bne	a5,s2,80003476 <namex+0xca>
    path++;
    8000346c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000346e:	0004c783          	lbu	a5,0(s1)
    80003472:	ff278de3          	beq	a5,s2,8000346c <namex+0xc0>
    ilock(ip);
    80003476:	854e                	mv	a0,s3
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	98c080e7          	jalr	-1652(ra) # 80002e04 <ilock>
    if(ip->type != T_DIR){
    80003480:	04c99783          	lh	a5,76(s3)
    80003484:	f98793e3          	bne	a5,s8,8000340a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003488:	000b0563          	beqz	s6,80003492 <namex+0xe6>
    8000348c:	0004c783          	lbu	a5,0(s1)
    80003490:	d3cd                	beqz	a5,80003432 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003492:	865e                	mv	a2,s7
    80003494:	85d6                	mv	a1,s5
    80003496:	854e                	mv	a0,s3
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	e64080e7          	jalr	-412(ra) # 800032fc <dirlookup>
    800034a0:	8a2a                	mv	s4,a0
    800034a2:	dd51                	beqz	a0,8000343e <namex+0x92>
    iunlockput(ip);
    800034a4:	854e                	mv	a0,s3
    800034a6:	00000097          	auipc	ra,0x0
    800034aa:	bd4080e7          	jalr	-1068(ra) # 8000307a <iunlockput>
    ip = next;
    800034ae:	89d2                	mv	s3,s4
  while(*path == '/')
    800034b0:	0004c783          	lbu	a5,0(s1)
    800034b4:	05279763          	bne	a5,s2,80003502 <namex+0x156>
    path++;
    800034b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034ba:	0004c783          	lbu	a5,0(s1)
    800034be:	ff278de3          	beq	a5,s2,800034b8 <namex+0x10c>
  if(*path == 0)
    800034c2:	c79d                	beqz	a5,800034f0 <namex+0x144>
    path++;
    800034c4:	85a6                	mv	a1,s1
  len = path - s;
    800034c6:	8a5e                	mv	s4,s7
    800034c8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800034ca:	01278963          	beq	a5,s2,800034dc <namex+0x130>
    800034ce:	dfbd                	beqz	a5,8000344c <namex+0xa0>
    path++;
    800034d0:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800034d2:	0004c783          	lbu	a5,0(s1)
    800034d6:	ff279ce3          	bne	a5,s2,800034ce <namex+0x122>
    800034da:	bf8d                	j	8000344c <namex+0xa0>
    memmove(name, s, len);
    800034dc:	2601                	sext.w	a2,a2
    800034de:	8556                	mv	a0,s5
    800034e0:	ffffd097          	auipc	ra,0xffffd
    800034e4:	e2e080e7          	jalr	-466(ra) # 8000030e <memmove>
    name[len] = 0;
    800034e8:	9a56                	add	s4,s4,s5
    800034ea:	000a0023          	sb	zero,0(s4)
    800034ee:	bf9d                	j	80003464 <namex+0xb8>
  if(nameiparent){
    800034f0:	f20b03e3          	beqz	s6,80003416 <namex+0x6a>
    iput(ip);
    800034f4:	854e                	mv	a0,s3
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	adc080e7          	jalr	-1316(ra) # 80002fd2 <iput>
    return 0;
    800034fe:	4981                	li	s3,0
    80003500:	bf19                	j	80003416 <namex+0x6a>
  if(*path == 0)
    80003502:	d7fd                	beqz	a5,800034f0 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003504:	0004c783          	lbu	a5,0(s1)
    80003508:	85a6                	mv	a1,s1
    8000350a:	b7d1                	j	800034ce <namex+0x122>

000000008000350c <dirlink>:
{
    8000350c:	7139                	addi	sp,sp,-64
    8000350e:	fc06                	sd	ra,56(sp)
    80003510:	f822                	sd	s0,48(sp)
    80003512:	f426                	sd	s1,40(sp)
    80003514:	f04a                	sd	s2,32(sp)
    80003516:	ec4e                	sd	s3,24(sp)
    80003518:	e852                	sd	s4,16(sp)
    8000351a:	0080                	addi	s0,sp,64
    8000351c:	892a                	mv	s2,a0
    8000351e:	8a2e                	mv	s4,a1
    80003520:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003522:	4601                	li	a2,0
    80003524:	00000097          	auipc	ra,0x0
    80003528:	dd8080e7          	jalr	-552(ra) # 800032fc <dirlookup>
    8000352c:	e93d                	bnez	a0,800035a2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000352e:	05492483          	lw	s1,84(s2)
    80003532:	c49d                	beqz	s1,80003560 <dirlink+0x54>
    80003534:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003536:	4741                	li	a4,16
    80003538:	86a6                	mv	a3,s1
    8000353a:	fc040613          	addi	a2,s0,-64
    8000353e:	4581                	li	a1,0
    80003540:	854a                	mv	a0,s2
    80003542:	00000097          	auipc	ra,0x0
    80003546:	b8a080e7          	jalr	-1142(ra) # 800030cc <readi>
    8000354a:	47c1                	li	a5,16
    8000354c:	06f51163          	bne	a0,a5,800035ae <dirlink+0xa2>
    if(de.inum == 0)
    80003550:	fc045783          	lhu	a5,-64(s0)
    80003554:	c791                	beqz	a5,80003560 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003556:	24c1                	addiw	s1,s1,16
    80003558:	05492783          	lw	a5,84(s2)
    8000355c:	fcf4ede3          	bltu	s1,a5,80003536 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003560:	4639                	li	a2,14
    80003562:	85d2                	mv	a1,s4
    80003564:	fc240513          	addi	a0,s0,-62
    80003568:	ffffd097          	auipc	ra,0xffffd
    8000356c:	e5a080e7          	jalr	-422(ra) # 800003c2 <strncpy>
  de.inum = inum;
    80003570:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003574:	4741                	li	a4,16
    80003576:	86a6                	mv	a3,s1
    80003578:	fc040613          	addi	a2,s0,-64
    8000357c:	4581                	li	a1,0
    8000357e:	854a                	mv	a0,s2
    80003580:	00000097          	auipc	ra,0x0
    80003584:	c44080e7          	jalr	-956(ra) # 800031c4 <writei>
    80003588:	1541                	addi	a0,a0,-16
    8000358a:	00a03533          	snez	a0,a0
    8000358e:	40a00533          	neg	a0,a0
}
    80003592:	70e2                	ld	ra,56(sp)
    80003594:	7442                	ld	s0,48(sp)
    80003596:	74a2                	ld	s1,40(sp)
    80003598:	7902                	ld	s2,32(sp)
    8000359a:	69e2                	ld	s3,24(sp)
    8000359c:	6a42                	ld	s4,16(sp)
    8000359e:	6121                	addi	sp,sp,64
    800035a0:	8082                	ret
    iput(ip);
    800035a2:	00000097          	auipc	ra,0x0
    800035a6:	a30080e7          	jalr	-1488(ra) # 80002fd2 <iput>
    return -1;
    800035aa:	557d                	li	a0,-1
    800035ac:	b7dd                	j	80003592 <dirlink+0x86>
      panic("dirlink read");
    800035ae:	00005517          	auipc	a0,0x5
    800035b2:	03250513          	addi	a0,a0,50 # 800085e0 <syscalls+0x1d0>
    800035b6:	00003097          	auipc	ra,0x3
    800035ba:	cdc080e7          	jalr	-804(ra) # 80006292 <panic>

00000000800035be <namei>:

struct inode*
namei(char *path)
{
    800035be:	1101                	addi	sp,sp,-32
    800035c0:	ec06                	sd	ra,24(sp)
    800035c2:	e822                	sd	s0,16(sp)
    800035c4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035c6:	fe040613          	addi	a2,s0,-32
    800035ca:	4581                	li	a1,0
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	de0080e7          	jalr	-544(ra) # 800033ac <namex>
}
    800035d4:	60e2                	ld	ra,24(sp)
    800035d6:	6442                	ld	s0,16(sp)
    800035d8:	6105                	addi	sp,sp,32
    800035da:	8082                	ret

00000000800035dc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035dc:	1141                	addi	sp,sp,-16
    800035de:	e406                	sd	ra,8(sp)
    800035e0:	e022                	sd	s0,0(sp)
    800035e2:	0800                	addi	s0,sp,16
    800035e4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035e6:	4585                	li	a1,1
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	dc4080e7          	jalr	-572(ra) # 800033ac <namex>
}
    800035f0:	60a2                	ld	ra,8(sp)
    800035f2:	6402                	ld	s0,0(sp)
    800035f4:	0141                	addi	sp,sp,16
    800035f6:	8082                	ret

00000000800035f8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035f8:	1101                	addi	sp,sp,-32
    800035fa:	ec06                	sd	ra,24(sp)
    800035fc:	e822                	sd	s0,16(sp)
    800035fe:	e426                	sd	s1,8(sp)
    80003600:	e04a                	sd	s2,0(sp)
    80003602:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003604:	00019917          	auipc	s2,0x19
    80003608:	12490913          	addi	s2,s2,292 # 8001c728 <log>
    8000360c:	02092583          	lw	a1,32(s2)
    80003610:	03092503          	lw	a0,48(s2)
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	e72080e7          	jalr	-398(ra) # 80002486 <bread>
    8000361c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000361e:	03492683          	lw	a3,52(s2)
    80003622:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003624:	02d05763          	blez	a3,80003652 <write_head+0x5a>
    80003628:	00019797          	auipc	a5,0x19
    8000362c:	13878793          	addi	a5,a5,312 # 8001c760 <log+0x38>
    80003630:	06450713          	addi	a4,a0,100
    80003634:	36fd                	addiw	a3,a3,-1
    80003636:	1682                	slli	a3,a3,0x20
    80003638:	9281                	srli	a3,a3,0x20
    8000363a:	068a                	slli	a3,a3,0x2
    8000363c:	00019617          	auipc	a2,0x19
    80003640:	12860613          	addi	a2,a2,296 # 8001c764 <log+0x3c>
    80003644:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003646:	4390                	lw	a2,0(a5)
    80003648:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000364a:	0791                	addi	a5,a5,4
    8000364c:	0711                	addi	a4,a4,4
    8000364e:	fed79ce3          	bne	a5,a3,80003646 <write_head+0x4e>
  }
  bwrite(buf);
    80003652:	8526                	mv	a0,s1
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	07a080e7          	jalr	122(ra) # 800026ce <bwrite>
  brelse(buf);
    8000365c:	8526                	mv	a0,s1
    8000365e:	fffff097          	auipc	ra,0xfffff
    80003662:	0ae080e7          	jalr	174(ra) # 8000270c <brelse>
}
    80003666:	60e2                	ld	ra,24(sp)
    80003668:	6442                	ld	s0,16(sp)
    8000366a:	64a2                	ld	s1,8(sp)
    8000366c:	6902                	ld	s2,0(sp)
    8000366e:	6105                	addi	sp,sp,32
    80003670:	8082                	ret

0000000080003672 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003672:	00019797          	auipc	a5,0x19
    80003676:	0ea7a783          	lw	a5,234(a5) # 8001c75c <log+0x34>
    8000367a:	0af05d63          	blez	a5,80003734 <install_trans+0xc2>
{
    8000367e:	7139                	addi	sp,sp,-64
    80003680:	fc06                	sd	ra,56(sp)
    80003682:	f822                	sd	s0,48(sp)
    80003684:	f426                	sd	s1,40(sp)
    80003686:	f04a                	sd	s2,32(sp)
    80003688:	ec4e                	sd	s3,24(sp)
    8000368a:	e852                	sd	s4,16(sp)
    8000368c:	e456                	sd	s5,8(sp)
    8000368e:	e05a                	sd	s6,0(sp)
    80003690:	0080                	addi	s0,sp,64
    80003692:	8b2a                	mv	s6,a0
    80003694:	00019a97          	auipc	s5,0x19
    80003698:	0cca8a93          	addi	s5,s5,204 # 8001c760 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000369c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000369e:	00019997          	auipc	s3,0x19
    800036a2:	08a98993          	addi	s3,s3,138 # 8001c728 <log>
    800036a6:	a035                	j	800036d2 <install_trans+0x60>
      bunpin(dbuf);
    800036a8:	8526                	mv	a0,s1
    800036aa:	fffff097          	auipc	ra,0xfffff
    800036ae:	13a080e7          	jalr	314(ra) # 800027e4 <bunpin>
    brelse(lbuf);
    800036b2:	854a                	mv	a0,s2
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	058080e7          	jalr	88(ra) # 8000270c <brelse>
    brelse(dbuf);
    800036bc:	8526                	mv	a0,s1
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	04e080e7          	jalr	78(ra) # 8000270c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c6:	2a05                	addiw	s4,s4,1
    800036c8:	0a91                	addi	s5,s5,4
    800036ca:	0349a783          	lw	a5,52(s3)
    800036ce:	04fa5963          	bge	s4,a5,80003720 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036d2:	0209a583          	lw	a1,32(s3)
    800036d6:	014585bb          	addw	a1,a1,s4
    800036da:	2585                	addiw	a1,a1,1
    800036dc:	0309a503          	lw	a0,48(s3)
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	da6080e7          	jalr	-602(ra) # 80002486 <bread>
    800036e8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036ea:	000aa583          	lw	a1,0(s5)
    800036ee:	0309a503          	lw	a0,48(s3)
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	d94080e7          	jalr	-620(ra) # 80002486 <bread>
    800036fa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036fc:	40000613          	li	a2,1024
    80003700:	06090593          	addi	a1,s2,96
    80003704:	06050513          	addi	a0,a0,96
    80003708:	ffffd097          	auipc	ra,0xffffd
    8000370c:	c06080e7          	jalr	-1018(ra) # 8000030e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003710:	8526                	mv	a0,s1
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	fbc080e7          	jalr	-68(ra) # 800026ce <bwrite>
    if(recovering == 0)
    8000371a:	f80b1ce3          	bnez	s6,800036b2 <install_trans+0x40>
    8000371e:	b769                	j	800036a8 <install_trans+0x36>
}
    80003720:	70e2                	ld	ra,56(sp)
    80003722:	7442                	ld	s0,48(sp)
    80003724:	74a2                	ld	s1,40(sp)
    80003726:	7902                	ld	s2,32(sp)
    80003728:	69e2                	ld	s3,24(sp)
    8000372a:	6a42                	ld	s4,16(sp)
    8000372c:	6aa2                	ld	s5,8(sp)
    8000372e:	6b02                	ld	s6,0(sp)
    80003730:	6121                	addi	sp,sp,64
    80003732:	8082                	ret
    80003734:	8082                	ret

0000000080003736 <initlog>:
{
    80003736:	7179                	addi	sp,sp,-48
    80003738:	f406                	sd	ra,40(sp)
    8000373a:	f022                	sd	s0,32(sp)
    8000373c:	ec26                	sd	s1,24(sp)
    8000373e:	e84a                	sd	s2,16(sp)
    80003740:	e44e                	sd	s3,8(sp)
    80003742:	1800                	addi	s0,sp,48
    80003744:	892a                	mv	s2,a0
    80003746:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003748:	00019497          	auipc	s1,0x19
    8000374c:	fe048493          	addi	s1,s1,-32 # 8001c728 <log>
    80003750:	00005597          	auipc	a1,0x5
    80003754:	ea058593          	addi	a1,a1,-352 # 800085f0 <syscalls+0x1e0>
    80003758:	8526                	mv	a0,s1
    8000375a:	00003097          	auipc	ra,0x3
    8000375e:	1e8080e7          	jalr	488(ra) # 80006942 <initlock>
  log.start = sb->logstart;
    80003762:	0149a583          	lw	a1,20(s3)
    80003766:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    80003768:	0109a783          	lw	a5,16(s3)
    8000376c:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    8000376e:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003772:	854a                	mv	a0,s2
    80003774:	fffff097          	auipc	ra,0xfffff
    80003778:	d12080e7          	jalr	-750(ra) # 80002486 <bread>
  log.lh.n = lh->n;
    8000377c:	513c                	lw	a5,96(a0)
    8000377e:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003780:	02f05563          	blez	a5,800037aa <initlog+0x74>
    80003784:	06450713          	addi	a4,a0,100
    80003788:	00019697          	auipc	a3,0x19
    8000378c:	fd868693          	addi	a3,a3,-40 # 8001c760 <log+0x38>
    80003790:	37fd                	addiw	a5,a5,-1
    80003792:	1782                	slli	a5,a5,0x20
    80003794:	9381                	srli	a5,a5,0x20
    80003796:	078a                	slli	a5,a5,0x2
    80003798:	06850613          	addi	a2,a0,104
    8000379c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000379e:	4310                	lw	a2,0(a4)
    800037a0:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800037a2:	0711                	addi	a4,a4,4
    800037a4:	0691                	addi	a3,a3,4
    800037a6:	fef71ce3          	bne	a4,a5,8000379e <initlog+0x68>
  brelse(buf);
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	f62080e7          	jalr	-158(ra) # 8000270c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037b2:	4505                	li	a0,1
    800037b4:	00000097          	auipc	ra,0x0
    800037b8:	ebe080e7          	jalr	-322(ra) # 80003672 <install_trans>
  log.lh.n = 0;
    800037bc:	00019797          	auipc	a5,0x19
    800037c0:	fa07a023          	sw	zero,-96(a5) # 8001c75c <log+0x34>
  write_head(); // clear the log
    800037c4:	00000097          	auipc	ra,0x0
    800037c8:	e34080e7          	jalr	-460(ra) # 800035f8 <write_head>
}
    800037cc:	70a2                	ld	ra,40(sp)
    800037ce:	7402                	ld	s0,32(sp)
    800037d0:	64e2                	ld	s1,24(sp)
    800037d2:	6942                	ld	s2,16(sp)
    800037d4:	69a2                	ld	s3,8(sp)
    800037d6:	6145                	addi	sp,sp,48
    800037d8:	8082                	ret

00000000800037da <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037e6:	00019517          	auipc	a0,0x19
    800037ea:	f4250513          	addi	a0,a0,-190 # 8001c728 <log>
    800037ee:	00003097          	auipc	ra,0x3
    800037f2:	fd8080e7          	jalr	-40(ra) # 800067c6 <acquire>
  while(1){
    if(log.committing){
    800037f6:	00019497          	auipc	s1,0x19
    800037fa:	f3248493          	addi	s1,s1,-206 # 8001c728 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037fe:	4979                	li	s2,30
    80003800:	a039                	j	8000380e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003802:	85a6                	mv	a1,s1
    80003804:	8526                	mv	a0,s1
    80003806:	ffffe097          	auipc	ra,0xffffe
    8000380a:	e98080e7          	jalr	-360(ra) # 8000169e <sleep>
    if(log.committing){
    8000380e:	54dc                	lw	a5,44(s1)
    80003810:	fbed                	bnez	a5,80003802 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003812:	549c                	lw	a5,40(s1)
    80003814:	0017871b          	addiw	a4,a5,1
    80003818:	0007069b          	sext.w	a3,a4
    8000381c:	0027179b          	slliw	a5,a4,0x2
    80003820:	9fb9                	addw	a5,a5,a4
    80003822:	0017979b          	slliw	a5,a5,0x1
    80003826:	58d8                	lw	a4,52(s1)
    80003828:	9fb9                	addw	a5,a5,a4
    8000382a:	00f95963          	bge	s2,a5,8000383c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000382e:	85a6                	mv	a1,s1
    80003830:	8526                	mv	a0,s1
    80003832:	ffffe097          	auipc	ra,0xffffe
    80003836:	e6c080e7          	jalr	-404(ra) # 8000169e <sleep>
    8000383a:	bfd1                	j	8000380e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000383c:	00019517          	auipc	a0,0x19
    80003840:	eec50513          	addi	a0,a0,-276 # 8001c728 <log>
    80003844:	d514                	sw	a3,40(a0)
      release(&log.lock);
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	050080e7          	jalr	80(ra) # 80006896 <release>
      break;
    }
  }
}
    8000384e:	60e2                	ld	ra,24(sp)
    80003850:	6442                	ld	s0,16(sp)
    80003852:	64a2                	ld	s1,8(sp)
    80003854:	6902                	ld	s2,0(sp)
    80003856:	6105                	addi	sp,sp,32
    80003858:	8082                	ret

000000008000385a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000385a:	7139                	addi	sp,sp,-64
    8000385c:	fc06                	sd	ra,56(sp)
    8000385e:	f822                	sd	s0,48(sp)
    80003860:	f426                	sd	s1,40(sp)
    80003862:	f04a                	sd	s2,32(sp)
    80003864:	ec4e                	sd	s3,24(sp)
    80003866:	e852                	sd	s4,16(sp)
    80003868:	e456                	sd	s5,8(sp)
    8000386a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000386c:	00019497          	auipc	s1,0x19
    80003870:	ebc48493          	addi	s1,s1,-324 # 8001c728 <log>
    80003874:	8526                	mv	a0,s1
    80003876:	00003097          	auipc	ra,0x3
    8000387a:	f50080e7          	jalr	-176(ra) # 800067c6 <acquire>
  log.outstanding -= 1;
    8000387e:	549c                	lw	a5,40(s1)
    80003880:	37fd                	addiw	a5,a5,-1
    80003882:	0007891b          	sext.w	s2,a5
    80003886:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003888:	54dc                	lw	a5,44(s1)
    8000388a:	efb9                	bnez	a5,800038e8 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000388c:	06091663          	bnez	s2,800038f8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003890:	00019497          	auipc	s1,0x19
    80003894:	e9848493          	addi	s1,s1,-360 # 8001c728 <log>
    80003898:	4785                	li	a5,1
    8000389a:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000389c:	8526                	mv	a0,s1
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	ff8080e7          	jalr	-8(ra) # 80006896 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038a6:	58dc                	lw	a5,52(s1)
    800038a8:	06f04763          	bgtz	a5,80003916 <end_op+0xbc>
    acquire(&log.lock);
    800038ac:	00019497          	auipc	s1,0x19
    800038b0:	e7c48493          	addi	s1,s1,-388 # 8001c728 <log>
    800038b4:	8526                	mv	a0,s1
    800038b6:	00003097          	auipc	ra,0x3
    800038ba:	f10080e7          	jalr	-240(ra) # 800067c6 <acquire>
    log.committing = 0;
    800038be:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    800038c2:	8526                	mv	a0,s1
    800038c4:	ffffe097          	auipc	ra,0xffffe
    800038c8:	e3e080e7          	jalr	-450(ra) # 80001702 <wakeup>
    release(&log.lock);
    800038cc:	8526                	mv	a0,s1
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	fc8080e7          	jalr	-56(ra) # 80006896 <release>
}
    800038d6:	70e2                	ld	ra,56(sp)
    800038d8:	7442                	ld	s0,48(sp)
    800038da:	74a2                	ld	s1,40(sp)
    800038dc:	7902                	ld	s2,32(sp)
    800038de:	69e2                	ld	s3,24(sp)
    800038e0:	6a42                	ld	s4,16(sp)
    800038e2:	6aa2                	ld	s5,8(sp)
    800038e4:	6121                	addi	sp,sp,64
    800038e6:	8082                	ret
    panic("log.committing");
    800038e8:	00005517          	auipc	a0,0x5
    800038ec:	d1050513          	addi	a0,a0,-752 # 800085f8 <syscalls+0x1e8>
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	9a2080e7          	jalr	-1630(ra) # 80006292 <panic>
    wakeup(&log);
    800038f8:	00019497          	auipc	s1,0x19
    800038fc:	e3048493          	addi	s1,s1,-464 # 8001c728 <log>
    80003900:	8526                	mv	a0,s1
    80003902:	ffffe097          	auipc	ra,0xffffe
    80003906:	e00080e7          	jalr	-512(ra) # 80001702 <wakeup>
  release(&log.lock);
    8000390a:	8526                	mv	a0,s1
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	f8a080e7          	jalr	-118(ra) # 80006896 <release>
  if(do_commit){
    80003914:	b7c9                	j	800038d6 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003916:	00019a97          	auipc	s5,0x19
    8000391a:	e4aa8a93          	addi	s5,s5,-438 # 8001c760 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000391e:	00019a17          	auipc	s4,0x19
    80003922:	e0aa0a13          	addi	s4,s4,-502 # 8001c728 <log>
    80003926:	020a2583          	lw	a1,32(s4)
    8000392a:	012585bb          	addw	a1,a1,s2
    8000392e:	2585                	addiw	a1,a1,1
    80003930:	030a2503          	lw	a0,48(s4)
    80003934:	fffff097          	auipc	ra,0xfffff
    80003938:	b52080e7          	jalr	-1198(ra) # 80002486 <bread>
    8000393c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000393e:	000aa583          	lw	a1,0(s5)
    80003942:	030a2503          	lw	a0,48(s4)
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	b40080e7          	jalr	-1216(ra) # 80002486 <bread>
    8000394e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003950:	40000613          	li	a2,1024
    80003954:	06050593          	addi	a1,a0,96
    80003958:	06048513          	addi	a0,s1,96
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	9b2080e7          	jalr	-1614(ra) # 8000030e <memmove>
    bwrite(to);  // write the log
    80003964:	8526                	mv	a0,s1
    80003966:	fffff097          	auipc	ra,0xfffff
    8000396a:	d68080e7          	jalr	-664(ra) # 800026ce <bwrite>
    brelse(from);
    8000396e:	854e                	mv	a0,s3
    80003970:	fffff097          	auipc	ra,0xfffff
    80003974:	d9c080e7          	jalr	-612(ra) # 8000270c <brelse>
    brelse(to);
    80003978:	8526                	mv	a0,s1
    8000397a:	fffff097          	auipc	ra,0xfffff
    8000397e:	d92080e7          	jalr	-622(ra) # 8000270c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003982:	2905                	addiw	s2,s2,1
    80003984:	0a91                	addi	s5,s5,4
    80003986:	034a2783          	lw	a5,52(s4)
    8000398a:	f8f94ee3          	blt	s2,a5,80003926 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000398e:	00000097          	auipc	ra,0x0
    80003992:	c6a080e7          	jalr	-918(ra) # 800035f8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003996:	4501                	li	a0,0
    80003998:	00000097          	auipc	ra,0x0
    8000399c:	cda080e7          	jalr	-806(ra) # 80003672 <install_trans>
    log.lh.n = 0;
    800039a0:	00019797          	auipc	a5,0x19
    800039a4:	da07ae23          	sw	zero,-580(a5) # 8001c75c <log+0x34>
    write_head();    // Erase the transaction from the log
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	c50080e7          	jalr	-944(ra) # 800035f8 <write_head>
    800039b0:	bdf5                	j	800038ac <end_op+0x52>

00000000800039b2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	e04a                	sd	s2,0(sp)
    800039bc:	1000                	addi	s0,sp,32
    800039be:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039c0:	00019917          	auipc	s2,0x19
    800039c4:	d6890913          	addi	s2,s2,-664 # 8001c728 <log>
    800039c8:	854a                	mv	a0,s2
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	dfc080e7          	jalr	-516(ra) # 800067c6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039d2:	03492603          	lw	a2,52(s2)
    800039d6:	47f5                	li	a5,29
    800039d8:	06c7c563          	blt	a5,a2,80003a42 <log_write+0x90>
    800039dc:	00019797          	auipc	a5,0x19
    800039e0:	d707a783          	lw	a5,-656(a5) # 8001c74c <log+0x24>
    800039e4:	37fd                	addiw	a5,a5,-1
    800039e6:	04f65e63          	bge	a2,a5,80003a42 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039ea:	00019797          	auipc	a5,0x19
    800039ee:	d667a783          	lw	a5,-666(a5) # 8001c750 <log+0x28>
    800039f2:	06f05063          	blez	a5,80003a52 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039f6:	4781                	li	a5,0
    800039f8:	06c05563          	blez	a2,80003a62 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039fc:	44cc                	lw	a1,12(s1)
    800039fe:	00019717          	auipc	a4,0x19
    80003a02:	d6270713          	addi	a4,a4,-670 # 8001c760 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003a06:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a08:	4314                	lw	a3,0(a4)
    80003a0a:	04b68c63          	beq	a3,a1,80003a62 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a0e:	2785                	addiw	a5,a5,1
    80003a10:	0711                	addi	a4,a4,4
    80003a12:	fef61be3          	bne	a2,a5,80003a08 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a16:	0631                	addi	a2,a2,12
    80003a18:	060a                	slli	a2,a2,0x2
    80003a1a:	00019797          	auipc	a5,0x19
    80003a1e:	d0e78793          	addi	a5,a5,-754 # 8001c728 <log>
    80003a22:	963e                	add	a2,a2,a5
    80003a24:	44dc                	lw	a5,12(s1)
    80003a26:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a28:	8526                	mv	a0,s1
    80003a2a:	fffff097          	auipc	ra,0xfffff
    80003a2e:	d6e080e7          	jalr	-658(ra) # 80002798 <bpin>
    log.lh.n++;
    80003a32:	00019717          	auipc	a4,0x19
    80003a36:	cf670713          	addi	a4,a4,-778 # 8001c728 <log>
    80003a3a:	5b5c                	lw	a5,52(a4)
    80003a3c:	2785                	addiw	a5,a5,1
    80003a3e:	db5c                	sw	a5,52(a4)
    80003a40:	a835                	j	80003a7c <log_write+0xca>
    panic("too big a transaction");
    80003a42:	00005517          	auipc	a0,0x5
    80003a46:	bc650513          	addi	a0,a0,-1082 # 80008608 <syscalls+0x1f8>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	848080e7          	jalr	-1976(ra) # 80006292 <panic>
    panic("log_write outside of trans");
    80003a52:	00005517          	auipc	a0,0x5
    80003a56:	bce50513          	addi	a0,a0,-1074 # 80008620 <syscalls+0x210>
    80003a5a:	00003097          	auipc	ra,0x3
    80003a5e:	838080e7          	jalr	-1992(ra) # 80006292 <panic>
  log.lh.block[i] = b->blockno;
    80003a62:	00c78713          	addi	a4,a5,12
    80003a66:	00271693          	slli	a3,a4,0x2
    80003a6a:	00019717          	auipc	a4,0x19
    80003a6e:	cbe70713          	addi	a4,a4,-834 # 8001c728 <log>
    80003a72:	9736                	add	a4,a4,a3
    80003a74:	44d4                	lw	a3,12(s1)
    80003a76:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a78:	faf608e3          	beq	a2,a5,80003a28 <log_write+0x76>
  }
  release(&log.lock);
    80003a7c:	00019517          	auipc	a0,0x19
    80003a80:	cac50513          	addi	a0,a0,-852 # 8001c728 <log>
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	e12080e7          	jalr	-494(ra) # 80006896 <release>
}
    80003a8c:	60e2                	ld	ra,24(sp)
    80003a8e:	6442                	ld	s0,16(sp)
    80003a90:	64a2                	ld	s1,8(sp)
    80003a92:	6902                	ld	s2,0(sp)
    80003a94:	6105                	addi	sp,sp,32
    80003a96:	8082                	ret

0000000080003a98 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a98:	1101                	addi	sp,sp,-32
    80003a9a:	ec06                	sd	ra,24(sp)
    80003a9c:	e822                	sd	s0,16(sp)
    80003a9e:	e426                	sd	s1,8(sp)
    80003aa0:	e04a                	sd	s2,0(sp)
    80003aa2:	1000                	addi	s0,sp,32
    80003aa4:	84aa                	mv	s1,a0
    80003aa6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003aa8:	00005597          	auipc	a1,0x5
    80003aac:	b9858593          	addi	a1,a1,-1128 # 80008640 <syscalls+0x230>
    80003ab0:	0521                	addi	a0,a0,8
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	e90080e7          	jalr	-368(ra) # 80006942 <initlock>
  lk->name = name;
    80003aba:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003abe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ac2:	0204a823          	sw	zero,48(s1)
}
    80003ac6:	60e2                	ld	ra,24(sp)
    80003ac8:	6442                	ld	s0,16(sp)
    80003aca:	64a2                	ld	s1,8(sp)
    80003acc:	6902                	ld	s2,0(sp)
    80003ace:	6105                	addi	sp,sp,32
    80003ad0:	8082                	ret

0000000080003ad2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ad2:	1101                	addi	sp,sp,-32
    80003ad4:	ec06                	sd	ra,24(sp)
    80003ad6:	e822                	sd	s0,16(sp)
    80003ad8:	e426                	sd	s1,8(sp)
    80003ada:	e04a                	sd	s2,0(sp)
    80003adc:	1000                	addi	s0,sp,32
    80003ade:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ae0:	00850913          	addi	s2,a0,8
    80003ae4:	854a                	mv	a0,s2
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	ce0080e7          	jalr	-800(ra) # 800067c6 <acquire>
  while (lk->locked) {
    80003aee:	409c                	lw	a5,0(s1)
    80003af0:	cb89                	beqz	a5,80003b02 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003af2:	85ca                	mv	a1,s2
    80003af4:	8526                	mv	a0,s1
    80003af6:	ffffe097          	auipc	ra,0xffffe
    80003afa:	ba8080e7          	jalr	-1112(ra) # 8000169e <sleep>
  while (lk->locked) {
    80003afe:	409c                	lw	a5,0(s1)
    80003b00:	fbed                	bnez	a5,80003af2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b02:	4785                	li	a5,1
    80003b04:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	4f0080e7          	jalr	1264(ra) # 80000ff6 <myproc>
    80003b0e:	5d1c                	lw	a5,56(a0)
    80003b10:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003b12:	854a                	mv	a0,s2
    80003b14:	00003097          	auipc	ra,0x3
    80003b18:	d82080e7          	jalr	-638(ra) # 80006896 <release>
}
    80003b1c:	60e2                	ld	ra,24(sp)
    80003b1e:	6442                	ld	s0,16(sp)
    80003b20:	64a2                	ld	s1,8(sp)
    80003b22:	6902                	ld	s2,0(sp)
    80003b24:	6105                	addi	sp,sp,32
    80003b26:	8082                	ret

0000000080003b28 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b28:	1101                	addi	sp,sp,-32
    80003b2a:	ec06                	sd	ra,24(sp)
    80003b2c:	e822                	sd	s0,16(sp)
    80003b2e:	e426                	sd	s1,8(sp)
    80003b30:	e04a                	sd	s2,0(sp)
    80003b32:	1000                	addi	s0,sp,32
    80003b34:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b36:	00850913          	addi	s2,a0,8
    80003b3a:	854a                	mv	a0,s2
    80003b3c:	00003097          	auipc	ra,0x3
    80003b40:	c8a080e7          	jalr	-886(ra) # 800067c6 <acquire>
  lk->locked = 0;
    80003b44:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b48:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003b4c:	8526                	mv	a0,s1
    80003b4e:	ffffe097          	auipc	ra,0xffffe
    80003b52:	bb4080e7          	jalr	-1100(ra) # 80001702 <wakeup>
  release(&lk->lk);
    80003b56:	854a                	mv	a0,s2
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	d3e080e7          	jalr	-706(ra) # 80006896 <release>
}
    80003b60:	60e2                	ld	ra,24(sp)
    80003b62:	6442                	ld	s0,16(sp)
    80003b64:	64a2                	ld	s1,8(sp)
    80003b66:	6902                	ld	s2,0(sp)
    80003b68:	6105                	addi	sp,sp,32
    80003b6a:	8082                	ret

0000000080003b6c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b6c:	7179                	addi	sp,sp,-48
    80003b6e:	f406                	sd	ra,40(sp)
    80003b70:	f022                	sd	s0,32(sp)
    80003b72:	ec26                	sd	s1,24(sp)
    80003b74:	e84a                	sd	s2,16(sp)
    80003b76:	e44e                	sd	s3,8(sp)
    80003b78:	1800                	addi	s0,sp,48
    80003b7a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b7c:	00850913          	addi	s2,a0,8
    80003b80:	854a                	mv	a0,s2
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	c44080e7          	jalr	-956(ra) # 800067c6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b8a:	409c                	lw	a5,0(s1)
    80003b8c:	ef99                	bnez	a5,80003baa <holdingsleep+0x3e>
    80003b8e:	4481                	li	s1,0
  release(&lk->lk);
    80003b90:	854a                	mv	a0,s2
    80003b92:	00003097          	auipc	ra,0x3
    80003b96:	d04080e7          	jalr	-764(ra) # 80006896 <release>
  return r;
}
    80003b9a:	8526                	mv	a0,s1
    80003b9c:	70a2                	ld	ra,40(sp)
    80003b9e:	7402                	ld	s0,32(sp)
    80003ba0:	64e2                	ld	s1,24(sp)
    80003ba2:	6942                	ld	s2,16(sp)
    80003ba4:	69a2                	ld	s3,8(sp)
    80003ba6:	6145                	addi	sp,sp,48
    80003ba8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003baa:	0304a983          	lw	s3,48(s1)
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	448080e7          	jalr	1096(ra) # 80000ff6 <myproc>
    80003bb6:	5d04                	lw	s1,56(a0)
    80003bb8:	413484b3          	sub	s1,s1,s3
    80003bbc:	0014b493          	seqz	s1,s1
    80003bc0:	bfc1                	j	80003b90 <holdingsleep+0x24>

0000000080003bc2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bc2:	1141                	addi	sp,sp,-16
    80003bc4:	e406                	sd	ra,8(sp)
    80003bc6:	e022                	sd	s0,0(sp)
    80003bc8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bca:	00005597          	auipc	a1,0x5
    80003bce:	a8658593          	addi	a1,a1,-1402 # 80008650 <syscalls+0x240>
    80003bd2:	00019517          	auipc	a0,0x19
    80003bd6:	ca650513          	addi	a0,a0,-858 # 8001c878 <ftable>
    80003bda:	00003097          	auipc	ra,0x3
    80003bde:	d68080e7          	jalr	-664(ra) # 80006942 <initlock>
}
    80003be2:	60a2                	ld	ra,8(sp)
    80003be4:	6402                	ld	s0,0(sp)
    80003be6:	0141                	addi	sp,sp,16
    80003be8:	8082                	ret

0000000080003bea <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bea:	1101                	addi	sp,sp,-32
    80003bec:	ec06                	sd	ra,24(sp)
    80003bee:	e822                	sd	s0,16(sp)
    80003bf0:	e426                	sd	s1,8(sp)
    80003bf2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bf4:	00019517          	auipc	a0,0x19
    80003bf8:	c8450513          	addi	a0,a0,-892 # 8001c878 <ftable>
    80003bfc:	00003097          	auipc	ra,0x3
    80003c00:	bca080e7          	jalr	-1078(ra) # 800067c6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c04:	00019497          	auipc	s1,0x19
    80003c08:	c9448493          	addi	s1,s1,-876 # 8001c898 <ftable+0x20>
    80003c0c:	0001a717          	auipc	a4,0x1a
    80003c10:	c2c70713          	addi	a4,a4,-980 # 8001d838 <disk>
    if(f->ref == 0){
    80003c14:	40dc                	lw	a5,4(s1)
    80003c16:	cf99                	beqz	a5,80003c34 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c18:	02848493          	addi	s1,s1,40
    80003c1c:	fee49ce3          	bne	s1,a4,80003c14 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c20:	00019517          	auipc	a0,0x19
    80003c24:	c5850513          	addi	a0,a0,-936 # 8001c878 <ftable>
    80003c28:	00003097          	auipc	ra,0x3
    80003c2c:	c6e080e7          	jalr	-914(ra) # 80006896 <release>
  return 0;
    80003c30:	4481                	li	s1,0
    80003c32:	a819                	j	80003c48 <filealloc+0x5e>
      f->ref = 1;
    80003c34:	4785                	li	a5,1
    80003c36:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c38:	00019517          	auipc	a0,0x19
    80003c3c:	c4050513          	addi	a0,a0,-960 # 8001c878 <ftable>
    80003c40:	00003097          	auipc	ra,0x3
    80003c44:	c56080e7          	jalr	-938(ra) # 80006896 <release>
}
    80003c48:	8526                	mv	a0,s1
    80003c4a:	60e2                	ld	ra,24(sp)
    80003c4c:	6442                	ld	s0,16(sp)
    80003c4e:	64a2                	ld	s1,8(sp)
    80003c50:	6105                	addi	sp,sp,32
    80003c52:	8082                	ret

0000000080003c54 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c54:	1101                	addi	sp,sp,-32
    80003c56:	ec06                	sd	ra,24(sp)
    80003c58:	e822                	sd	s0,16(sp)
    80003c5a:	e426                	sd	s1,8(sp)
    80003c5c:	1000                	addi	s0,sp,32
    80003c5e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c60:	00019517          	auipc	a0,0x19
    80003c64:	c1850513          	addi	a0,a0,-1000 # 8001c878 <ftable>
    80003c68:	00003097          	auipc	ra,0x3
    80003c6c:	b5e080e7          	jalr	-1186(ra) # 800067c6 <acquire>
  if(f->ref < 1)
    80003c70:	40dc                	lw	a5,4(s1)
    80003c72:	02f05263          	blez	a5,80003c96 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c76:	2785                	addiw	a5,a5,1
    80003c78:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c7a:	00019517          	auipc	a0,0x19
    80003c7e:	bfe50513          	addi	a0,a0,-1026 # 8001c878 <ftable>
    80003c82:	00003097          	auipc	ra,0x3
    80003c86:	c14080e7          	jalr	-1004(ra) # 80006896 <release>
  return f;
}
    80003c8a:	8526                	mv	a0,s1
    80003c8c:	60e2                	ld	ra,24(sp)
    80003c8e:	6442                	ld	s0,16(sp)
    80003c90:	64a2                	ld	s1,8(sp)
    80003c92:	6105                	addi	sp,sp,32
    80003c94:	8082                	ret
    panic("filedup");
    80003c96:	00005517          	auipc	a0,0x5
    80003c9a:	9c250513          	addi	a0,a0,-1598 # 80008658 <syscalls+0x248>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	5f4080e7          	jalr	1524(ra) # 80006292 <panic>

0000000080003ca6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ca6:	7139                	addi	sp,sp,-64
    80003ca8:	fc06                	sd	ra,56(sp)
    80003caa:	f822                	sd	s0,48(sp)
    80003cac:	f426                	sd	s1,40(sp)
    80003cae:	f04a                	sd	s2,32(sp)
    80003cb0:	ec4e                	sd	s3,24(sp)
    80003cb2:	e852                	sd	s4,16(sp)
    80003cb4:	e456                	sd	s5,8(sp)
    80003cb6:	0080                	addi	s0,sp,64
    80003cb8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cba:	00019517          	auipc	a0,0x19
    80003cbe:	bbe50513          	addi	a0,a0,-1090 # 8001c878 <ftable>
    80003cc2:	00003097          	auipc	ra,0x3
    80003cc6:	b04080e7          	jalr	-1276(ra) # 800067c6 <acquire>
  if(f->ref < 1)
    80003cca:	40dc                	lw	a5,4(s1)
    80003ccc:	06f05163          	blez	a5,80003d2e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cd0:	37fd                	addiw	a5,a5,-1
    80003cd2:	0007871b          	sext.w	a4,a5
    80003cd6:	c0dc                	sw	a5,4(s1)
    80003cd8:	06e04363          	bgtz	a4,80003d3e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cdc:	0004a903          	lw	s2,0(s1)
    80003ce0:	0094ca83          	lbu	s5,9(s1)
    80003ce4:	0104ba03          	ld	s4,16(s1)
    80003ce8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cec:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cf0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cf4:	00019517          	auipc	a0,0x19
    80003cf8:	b8450513          	addi	a0,a0,-1148 # 8001c878 <ftable>
    80003cfc:	00003097          	auipc	ra,0x3
    80003d00:	b9a080e7          	jalr	-1126(ra) # 80006896 <release>

  if(ff.type == FD_PIPE){
    80003d04:	4785                	li	a5,1
    80003d06:	04f90d63          	beq	s2,a5,80003d60 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d0a:	3979                	addiw	s2,s2,-2
    80003d0c:	4785                	li	a5,1
    80003d0e:	0527e063          	bltu	a5,s2,80003d4e <fileclose+0xa8>
    begin_op();
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	ac8080e7          	jalr	-1336(ra) # 800037da <begin_op>
    iput(ff.ip);
    80003d1a:	854e                	mv	a0,s3
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	2b6080e7          	jalr	694(ra) # 80002fd2 <iput>
    end_op();
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	b36080e7          	jalr	-1226(ra) # 8000385a <end_op>
    80003d2c:	a00d                	j	80003d4e <fileclose+0xa8>
    panic("fileclose");
    80003d2e:	00005517          	auipc	a0,0x5
    80003d32:	93250513          	addi	a0,a0,-1742 # 80008660 <syscalls+0x250>
    80003d36:	00002097          	auipc	ra,0x2
    80003d3a:	55c080e7          	jalr	1372(ra) # 80006292 <panic>
    release(&ftable.lock);
    80003d3e:	00019517          	auipc	a0,0x19
    80003d42:	b3a50513          	addi	a0,a0,-1222 # 8001c878 <ftable>
    80003d46:	00003097          	auipc	ra,0x3
    80003d4a:	b50080e7          	jalr	-1200(ra) # 80006896 <release>
  }
}
    80003d4e:	70e2                	ld	ra,56(sp)
    80003d50:	7442                	ld	s0,48(sp)
    80003d52:	74a2                	ld	s1,40(sp)
    80003d54:	7902                	ld	s2,32(sp)
    80003d56:	69e2                	ld	s3,24(sp)
    80003d58:	6a42                	ld	s4,16(sp)
    80003d5a:	6aa2                	ld	s5,8(sp)
    80003d5c:	6121                	addi	sp,sp,64
    80003d5e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d60:	85d6                	mv	a1,s5
    80003d62:	8552                	mv	a0,s4
    80003d64:	00000097          	auipc	ra,0x0
    80003d68:	34c080e7          	jalr	844(ra) # 800040b0 <pipeclose>
    80003d6c:	b7cd                	j	80003d4e <fileclose+0xa8>

0000000080003d6e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d6e:	715d                	addi	sp,sp,-80
    80003d70:	e486                	sd	ra,72(sp)
    80003d72:	e0a2                	sd	s0,64(sp)
    80003d74:	fc26                	sd	s1,56(sp)
    80003d76:	f84a                	sd	s2,48(sp)
    80003d78:	f44e                	sd	s3,40(sp)
    80003d7a:	0880                	addi	s0,sp,80
    80003d7c:	84aa                	mv	s1,a0
    80003d7e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d80:	ffffd097          	auipc	ra,0xffffd
    80003d84:	276080e7          	jalr	630(ra) # 80000ff6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d88:	409c                	lw	a5,0(s1)
    80003d8a:	37f9                	addiw	a5,a5,-2
    80003d8c:	4705                	li	a4,1
    80003d8e:	04f76763          	bltu	a4,a5,80003ddc <filestat+0x6e>
    80003d92:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d94:	6c88                	ld	a0,24(s1)
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	06e080e7          	jalr	110(ra) # 80002e04 <ilock>
    stati(f->ip, &st);
    80003d9e:	fb840593          	addi	a1,s0,-72
    80003da2:	6c88                	ld	a0,24(s1)
    80003da4:	fffff097          	auipc	ra,0xfffff
    80003da8:	2fe080e7          	jalr	766(ra) # 800030a2 <stati>
    iunlock(f->ip);
    80003dac:	6c88                	ld	a0,24(s1)
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	122080e7          	jalr	290(ra) # 80002ed0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003db6:	46e1                	li	a3,24
    80003db8:	fb840613          	addi	a2,s0,-72
    80003dbc:	85ce                	mv	a1,s3
    80003dbe:	05893503          	ld	a0,88(s2)
    80003dc2:	ffffd097          	auipc	ra,0xffffd
    80003dc6:	ebe080e7          	jalr	-322(ra) # 80000c80 <copyout>
    80003dca:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003dce:	60a6                	ld	ra,72(sp)
    80003dd0:	6406                	ld	s0,64(sp)
    80003dd2:	74e2                	ld	s1,56(sp)
    80003dd4:	7942                	ld	s2,48(sp)
    80003dd6:	79a2                	ld	s3,40(sp)
    80003dd8:	6161                	addi	sp,sp,80
    80003dda:	8082                	ret
  return -1;
    80003ddc:	557d                	li	a0,-1
    80003dde:	bfc5                	j	80003dce <filestat+0x60>

0000000080003de0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003de0:	7179                	addi	sp,sp,-48
    80003de2:	f406                	sd	ra,40(sp)
    80003de4:	f022                	sd	s0,32(sp)
    80003de6:	ec26                	sd	s1,24(sp)
    80003de8:	e84a                	sd	s2,16(sp)
    80003dea:	e44e                	sd	s3,8(sp)
    80003dec:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dee:	00854783          	lbu	a5,8(a0)
    80003df2:	c3d5                	beqz	a5,80003e96 <fileread+0xb6>
    80003df4:	84aa                	mv	s1,a0
    80003df6:	89ae                	mv	s3,a1
    80003df8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dfa:	411c                	lw	a5,0(a0)
    80003dfc:	4705                	li	a4,1
    80003dfe:	04e78963          	beq	a5,a4,80003e50 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e02:	470d                	li	a4,3
    80003e04:	04e78d63          	beq	a5,a4,80003e5e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e08:	4709                	li	a4,2
    80003e0a:	06e79e63          	bne	a5,a4,80003e86 <fileread+0xa6>
    ilock(f->ip);
    80003e0e:	6d08                	ld	a0,24(a0)
    80003e10:	fffff097          	auipc	ra,0xfffff
    80003e14:	ff4080e7          	jalr	-12(ra) # 80002e04 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e18:	874a                	mv	a4,s2
    80003e1a:	5094                	lw	a3,32(s1)
    80003e1c:	864e                	mv	a2,s3
    80003e1e:	4585                	li	a1,1
    80003e20:	6c88                	ld	a0,24(s1)
    80003e22:	fffff097          	auipc	ra,0xfffff
    80003e26:	2aa080e7          	jalr	682(ra) # 800030cc <readi>
    80003e2a:	892a                	mv	s2,a0
    80003e2c:	00a05563          	blez	a0,80003e36 <fileread+0x56>
      f->off += r;
    80003e30:	509c                	lw	a5,32(s1)
    80003e32:	9fa9                	addw	a5,a5,a0
    80003e34:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e36:	6c88                	ld	a0,24(s1)
    80003e38:	fffff097          	auipc	ra,0xfffff
    80003e3c:	098080e7          	jalr	152(ra) # 80002ed0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e40:	854a                	mv	a0,s2
    80003e42:	70a2                	ld	ra,40(sp)
    80003e44:	7402                	ld	s0,32(sp)
    80003e46:	64e2                	ld	s1,24(sp)
    80003e48:	6942                	ld	s2,16(sp)
    80003e4a:	69a2                	ld	s3,8(sp)
    80003e4c:	6145                	addi	sp,sp,48
    80003e4e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e50:	6908                	ld	a0,16(a0)
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	3d8080e7          	jalr	984(ra) # 8000422a <piperead>
    80003e5a:	892a                	mv	s2,a0
    80003e5c:	b7d5                	j	80003e40 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e5e:	02451783          	lh	a5,36(a0)
    80003e62:	03079693          	slli	a3,a5,0x30
    80003e66:	92c1                	srli	a3,a3,0x30
    80003e68:	4725                	li	a4,9
    80003e6a:	02d76863          	bltu	a4,a3,80003e9a <fileread+0xba>
    80003e6e:	0792                	slli	a5,a5,0x4
    80003e70:	00019717          	auipc	a4,0x19
    80003e74:	96870713          	addi	a4,a4,-1688 # 8001c7d8 <devsw>
    80003e78:	97ba                	add	a5,a5,a4
    80003e7a:	639c                	ld	a5,0(a5)
    80003e7c:	c38d                	beqz	a5,80003e9e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e7e:	4505                	li	a0,1
    80003e80:	9782                	jalr	a5
    80003e82:	892a                	mv	s2,a0
    80003e84:	bf75                	j	80003e40 <fileread+0x60>
    panic("fileread");
    80003e86:	00004517          	auipc	a0,0x4
    80003e8a:	7ea50513          	addi	a0,a0,2026 # 80008670 <syscalls+0x260>
    80003e8e:	00002097          	auipc	ra,0x2
    80003e92:	404080e7          	jalr	1028(ra) # 80006292 <panic>
    return -1;
    80003e96:	597d                	li	s2,-1
    80003e98:	b765                	j	80003e40 <fileread+0x60>
      return -1;
    80003e9a:	597d                	li	s2,-1
    80003e9c:	b755                	j	80003e40 <fileread+0x60>
    80003e9e:	597d                	li	s2,-1
    80003ea0:	b745                	j	80003e40 <fileread+0x60>

0000000080003ea2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003ea2:	715d                	addi	sp,sp,-80
    80003ea4:	e486                	sd	ra,72(sp)
    80003ea6:	e0a2                	sd	s0,64(sp)
    80003ea8:	fc26                	sd	s1,56(sp)
    80003eaa:	f84a                	sd	s2,48(sp)
    80003eac:	f44e                	sd	s3,40(sp)
    80003eae:	f052                	sd	s4,32(sp)
    80003eb0:	ec56                	sd	s5,24(sp)
    80003eb2:	e85a                	sd	s6,16(sp)
    80003eb4:	e45e                	sd	s7,8(sp)
    80003eb6:	e062                	sd	s8,0(sp)
    80003eb8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003eba:	00954783          	lbu	a5,9(a0)
    80003ebe:	10078663          	beqz	a5,80003fca <filewrite+0x128>
    80003ec2:	892a                	mv	s2,a0
    80003ec4:	8aae                	mv	s5,a1
    80003ec6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ec8:	411c                	lw	a5,0(a0)
    80003eca:	4705                	li	a4,1
    80003ecc:	02e78263          	beq	a5,a4,80003ef0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ed0:	470d                	li	a4,3
    80003ed2:	02e78663          	beq	a5,a4,80003efe <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ed6:	4709                	li	a4,2
    80003ed8:	0ee79163          	bne	a5,a4,80003fba <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003edc:	0ac05d63          	blez	a2,80003f96 <filewrite+0xf4>
    int i = 0;
    80003ee0:	4981                	li	s3,0
    80003ee2:	6b05                	lui	s6,0x1
    80003ee4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ee8:	6b85                	lui	s7,0x1
    80003eea:	c00b8b9b          	addiw	s7,s7,-1024
    80003eee:	a861                	j	80003f86 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ef0:	6908                	ld	a0,16(a0)
    80003ef2:	00000097          	auipc	ra,0x0
    80003ef6:	238080e7          	jalr	568(ra) # 8000412a <pipewrite>
    80003efa:	8a2a                	mv	s4,a0
    80003efc:	a045                	j	80003f9c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003efe:	02451783          	lh	a5,36(a0)
    80003f02:	03079693          	slli	a3,a5,0x30
    80003f06:	92c1                	srli	a3,a3,0x30
    80003f08:	4725                	li	a4,9
    80003f0a:	0cd76263          	bltu	a4,a3,80003fce <filewrite+0x12c>
    80003f0e:	0792                	slli	a5,a5,0x4
    80003f10:	00019717          	auipc	a4,0x19
    80003f14:	8c870713          	addi	a4,a4,-1848 # 8001c7d8 <devsw>
    80003f18:	97ba                	add	a5,a5,a4
    80003f1a:	679c                	ld	a5,8(a5)
    80003f1c:	cbdd                	beqz	a5,80003fd2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f1e:	4505                	li	a0,1
    80003f20:	9782                	jalr	a5
    80003f22:	8a2a                	mv	s4,a0
    80003f24:	a8a5                	j	80003f9c <filewrite+0xfa>
    80003f26:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f2a:	00000097          	auipc	ra,0x0
    80003f2e:	8b0080e7          	jalr	-1872(ra) # 800037da <begin_op>
      ilock(f->ip);
    80003f32:	01893503          	ld	a0,24(s2)
    80003f36:	fffff097          	auipc	ra,0xfffff
    80003f3a:	ece080e7          	jalr	-306(ra) # 80002e04 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f3e:	8762                	mv	a4,s8
    80003f40:	02092683          	lw	a3,32(s2)
    80003f44:	01598633          	add	a2,s3,s5
    80003f48:	4585                	li	a1,1
    80003f4a:	01893503          	ld	a0,24(s2)
    80003f4e:	fffff097          	auipc	ra,0xfffff
    80003f52:	276080e7          	jalr	630(ra) # 800031c4 <writei>
    80003f56:	84aa                	mv	s1,a0
    80003f58:	00a05763          	blez	a0,80003f66 <filewrite+0xc4>
        f->off += r;
    80003f5c:	02092783          	lw	a5,32(s2)
    80003f60:	9fa9                	addw	a5,a5,a0
    80003f62:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f66:	01893503          	ld	a0,24(s2)
    80003f6a:	fffff097          	auipc	ra,0xfffff
    80003f6e:	f66080e7          	jalr	-154(ra) # 80002ed0 <iunlock>
      end_op();
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	8e8080e7          	jalr	-1816(ra) # 8000385a <end_op>

      if(r != n1){
    80003f7a:	009c1f63          	bne	s8,s1,80003f98 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f7e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f82:	0149db63          	bge	s3,s4,80003f98 <filewrite+0xf6>
      int n1 = n - i;
    80003f86:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f8a:	84be                	mv	s1,a5
    80003f8c:	2781                	sext.w	a5,a5
    80003f8e:	f8fb5ce3          	bge	s6,a5,80003f26 <filewrite+0x84>
    80003f92:	84de                	mv	s1,s7
    80003f94:	bf49                	j	80003f26 <filewrite+0x84>
    int i = 0;
    80003f96:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f98:	013a1f63          	bne	s4,s3,80003fb6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f9c:	8552                	mv	a0,s4
    80003f9e:	60a6                	ld	ra,72(sp)
    80003fa0:	6406                	ld	s0,64(sp)
    80003fa2:	74e2                	ld	s1,56(sp)
    80003fa4:	7942                	ld	s2,48(sp)
    80003fa6:	79a2                	ld	s3,40(sp)
    80003fa8:	7a02                	ld	s4,32(sp)
    80003faa:	6ae2                	ld	s5,24(sp)
    80003fac:	6b42                	ld	s6,16(sp)
    80003fae:	6ba2                	ld	s7,8(sp)
    80003fb0:	6c02                	ld	s8,0(sp)
    80003fb2:	6161                	addi	sp,sp,80
    80003fb4:	8082                	ret
    ret = (i == n ? n : -1);
    80003fb6:	5a7d                	li	s4,-1
    80003fb8:	b7d5                	j	80003f9c <filewrite+0xfa>
    panic("filewrite");
    80003fba:	00004517          	auipc	a0,0x4
    80003fbe:	6c650513          	addi	a0,a0,1734 # 80008680 <syscalls+0x270>
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	2d0080e7          	jalr	720(ra) # 80006292 <panic>
    return -1;
    80003fca:	5a7d                	li	s4,-1
    80003fcc:	bfc1                	j	80003f9c <filewrite+0xfa>
      return -1;
    80003fce:	5a7d                	li	s4,-1
    80003fd0:	b7f1                	j	80003f9c <filewrite+0xfa>
    80003fd2:	5a7d                	li	s4,-1
    80003fd4:	b7e1                	j	80003f9c <filewrite+0xfa>

0000000080003fd6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fd6:	7179                	addi	sp,sp,-48
    80003fd8:	f406                	sd	ra,40(sp)
    80003fda:	f022                	sd	s0,32(sp)
    80003fdc:	ec26                	sd	s1,24(sp)
    80003fde:	e84a                	sd	s2,16(sp)
    80003fe0:	e44e                	sd	s3,8(sp)
    80003fe2:	e052                	sd	s4,0(sp)
    80003fe4:	1800                	addi	s0,sp,48
    80003fe6:	84aa                	mv	s1,a0
    80003fe8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fea:	0005b023          	sd	zero,0(a1)
    80003fee:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ff2:	00000097          	auipc	ra,0x0
    80003ff6:	bf8080e7          	jalr	-1032(ra) # 80003bea <filealloc>
    80003ffa:	e088                	sd	a0,0(s1)
    80003ffc:	c551                	beqz	a0,80004088 <pipealloc+0xb2>
    80003ffe:	00000097          	auipc	ra,0x0
    80004002:	bec080e7          	jalr	-1044(ra) # 80003bea <filealloc>
    80004006:	00aa3023          	sd	a0,0(s4)
    8000400a:	c92d                	beqz	a0,8000407c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000400c:	ffffc097          	auipc	ra,0xffffc
    80004010:	15e080e7          	jalr	350(ra) # 8000016a <kalloc>
    80004014:	892a                	mv	s2,a0
    80004016:	c125                	beqz	a0,80004076 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004018:	4985                	li	s3,1
    8000401a:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    8000401e:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004022:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004026:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    8000402a:	00004597          	auipc	a1,0x4
    8000402e:	66658593          	addi	a1,a1,1638 # 80008690 <syscalls+0x280>
    80004032:	00003097          	auipc	ra,0x3
    80004036:	910080e7          	jalr	-1776(ra) # 80006942 <initlock>
  (*f0)->type = FD_PIPE;
    8000403a:	609c                	ld	a5,0(s1)
    8000403c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004040:	609c                	ld	a5,0(s1)
    80004042:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004046:	609c                	ld	a5,0(s1)
    80004048:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000404c:	609c                	ld	a5,0(s1)
    8000404e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004052:	000a3783          	ld	a5,0(s4)
    80004056:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000405a:	000a3783          	ld	a5,0(s4)
    8000405e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004062:	000a3783          	ld	a5,0(s4)
    80004066:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000406a:	000a3783          	ld	a5,0(s4)
    8000406e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004072:	4501                	li	a0,0
    80004074:	a025                	j	8000409c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004076:	6088                	ld	a0,0(s1)
    80004078:	e501                	bnez	a0,80004080 <pipealloc+0xaa>
    8000407a:	a039                	j	80004088 <pipealloc+0xb2>
    8000407c:	6088                	ld	a0,0(s1)
    8000407e:	c51d                	beqz	a0,800040ac <pipealloc+0xd6>
    fileclose(*f0);
    80004080:	00000097          	auipc	ra,0x0
    80004084:	c26080e7          	jalr	-986(ra) # 80003ca6 <fileclose>
  if(*f1)
    80004088:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000408c:	557d                	li	a0,-1
  if(*f1)
    8000408e:	c799                	beqz	a5,8000409c <pipealloc+0xc6>
    fileclose(*f1);
    80004090:	853e                	mv	a0,a5
    80004092:	00000097          	auipc	ra,0x0
    80004096:	c14080e7          	jalr	-1004(ra) # 80003ca6 <fileclose>
  return -1;
    8000409a:	557d                	li	a0,-1
}
    8000409c:	70a2                	ld	ra,40(sp)
    8000409e:	7402                	ld	s0,32(sp)
    800040a0:	64e2                	ld	s1,24(sp)
    800040a2:	6942                	ld	s2,16(sp)
    800040a4:	69a2                	ld	s3,8(sp)
    800040a6:	6a02                	ld	s4,0(sp)
    800040a8:	6145                	addi	sp,sp,48
    800040aa:	8082                	ret
  return -1;
    800040ac:	557d                	li	a0,-1
    800040ae:	b7fd                	j	8000409c <pipealloc+0xc6>

00000000800040b0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800040b0:	1101                	addi	sp,sp,-32
    800040b2:	ec06                	sd	ra,24(sp)
    800040b4:	e822                	sd	s0,16(sp)
    800040b6:	e426                	sd	s1,8(sp)
    800040b8:	e04a                	sd	s2,0(sp)
    800040ba:	1000                	addi	s0,sp,32
    800040bc:	84aa                	mv	s1,a0
    800040be:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040c0:	00002097          	auipc	ra,0x2
    800040c4:	706080e7          	jalr	1798(ra) # 800067c6 <acquire>
  if(writable){
    800040c8:	04090263          	beqz	s2,8000410c <pipeclose+0x5c>
    pi->writeopen = 0;
    800040cc:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    800040d0:	22048513          	addi	a0,s1,544
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	62e080e7          	jalr	1582(ra) # 80001702 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040dc:	2284b783          	ld	a5,552(s1)
    800040e0:	ef9d                	bnez	a5,8000411e <pipeclose+0x6e>
    release(&pi->lock);
    800040e2:	8526                	mv	a0,s1
    800040e4:	00002097          	auipc	ra,0x2
    800040e8:	7b2080e7          	jalr	1970(ra) # 80006896 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    800040ec:	8526                	mv	a0,s1
    800040ee:	00002097          	auipc	ra,0x2
    800040f2:	7f0080e7          	jalr	2032(ra) # 800068de <freelock>
#endif    
    kfree((char*)pi);
    800040f6:	8526                	mv	a0,s1
    800040f8:	ffffc097          	auipc	ra,0xffffc
    800040fc:	f24080e7          	jalr	-220(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004100:	60e2                	ld	ra,24(sp)
    80004102:	6442                	ld	s0,16(sp)
    80004104:	64a2                	ld	s1,8(sp)
    80004106:	6902                	ld	s2,0(sp)
    80004108:	6105                	addi	sp,sp,32
    8000410a:	8082                	ret
    pi->readopen = 0;
    8000410c:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004110:	22448513          	addi	a0,s1,548
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	5ee080e7          	jalr	1518(ra) # 80001702 <wakeup>
    8000411c:	b7c1                	j	800040dc <pipeclose+0x2c>
    release(&pi->lock);
    8000411e:	8526                	mv	a0,s1
    80004120:	00002097          	auipc	ra,0x2
    80004124:	776080e7          	jalr	1910(ra) # 80006896 <release>
}
    80004128:	bfe1                	j	80004100 <pipeclose+0x50>

000000008000412a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000412a:	7159                	addi	sp,sp,-112
    8000412c:	f486                	sd	ra,104(sp)
    8000412e:	f0a2                	sd	s0,96(sp)
    80004130:	eca6                	sd	s1,88(sp)
    80004132:	e8ca                	sd	s2,80(sp)
    80004134:	e4ce                	sd	s3,72(sp)
    80004136:	e0d2                	sd	s4,64(sp)
    80004138:	fc56                	sd	s5,56(sp)
    8000413a:	f85a                	sd	s6,48(sp)
    8000413c:	f45e                	sd	s7,40(sp)
    8000413e:	f062                	sd	s8,32(sp)
    80004140:	ec66                	sd	s9,24(sp)
    80004142:	1880                	addi	s0,sp,112
    80004144:	84aa                	mv	s1,a0
    80004146:	8aae                	mv	s5,a1
    80004148:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	eac080e7          	jalr	-340(ra) # 80000ff6 <myproc>
    80004152:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004154:	8526                	mv	a0,s1
    80004156:	00002097          	auipc	ra,0x2
    8000415a:	670080e7          	jalr	1648(ra) # 800067c6 <acquire>
  while(i < n){
    8000415e:	0d405463          	blez	s4,80004226 <pipewrite+0xfc>
    80004162:	8ba6                	mv	s7,s1
  int i = 0;
    80004164:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004166:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004168:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    8000416c:	22448c13          	addi	s8,s1,548
    80004170:	a08d                	j	800041d2 <pipewrite+0xa8>
      release(&pi->lock);
    80004172:	8526                	mv	a0,s1
    80004174:	00002097          	auipc	ra,0x2
    80004178:	722080e7          	jalr	1826(ra) # 80006896 <release>
      return -1;
    8000417c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000417e:	854a                	mv	a0,s2
    80004180:	70a6                	ld	ra,104(sp)
    80004182:	7406                	ld	s0,96(sp)
    80004184:	64e6                	ld	s1,88(sp)
    80004186:	6946                	ld	s2,80(sp)
    80004188:	69a6                	ld	s3,72(sp)
    8000418a:	6a06                	ld	s4,64(sp)
    8000418c:	7ae2                	ld	s5,56(sp)
    8000418e:	7b42                	ld	s6,48(sp)
    80004190:	7ba2                	ld	s7,40(sp)
    80004192:	7c02                	ld	s8,32(sp)
    80004194:	6ce2                	ld	s9,24(sp)
    80004196:	6165                	addi	sp,sp,112
    80004198:	8082                	ret
      wakeup(&pi->nread);
    8000419a:	8566                	mv	a0,s9
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	566080e7          	jalr	1382(ra) # 80001702 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041a4:	85de                	mv	a1,s7
    800041a6:	8562                	mv	a0,s8
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	4f6080e7          	jalr	1270(ra) # 8000169e <sleep>
    800041b0:	a839                	j	800041ce <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041b2:	2244a783          	lw	a5,548(s1)
    800041b6:	0017871b          	addiw	a4,a5,1
    800041ba:	22e4a223          	sw	a4,548(s1)
    800041be:	1ff7f793          	andi	a5,a5,511
    800041c2:	97a6                	add	a5,a5,s1
    800041c4:	f9f44703          	lbu	a4,-97(s0)
    800041c8:	02e78023          	sb	a4,32(a5)
      i++;
    800041cc:	2905                	addiw	s2,s2,1
  while(i < n){
    800041ce:	05495063          	bge	s2,s4,8000420e <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    800041d2:	2284a783          	lw	a5,552(s1)
    800041d6:	dfd1                	beqz	a5,80004172 <pipewrite+0x48>
    800041d8:	854e                	mv	a0,s3
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	76c080e7          	jalr	1900(ra) # 80001946 <killed>
    800041e2:	f941                	bnez	a0,80004172 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041e4:	2204a783          	lw	a5,544(s1)
    800041e8:	2244a703          	lw	a4,548(s1)
    800041ec:	2007879b          	addiw	a5,a5,512
    800041f0:	faf705e3          	beq	a4,a5,8000419a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041f4:	4685                	li	a3,1
    800041f6:	01590633          	add	a2,s2,s5
    800041fa:	f9f40593          	addi	a1,s0,-97
    800041fe:	0589b503          	ld	a0,88(s3)
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	b3e080e7          	jalr	-1218(ra) # 80000d40 <copyin>
    8000420a:	fb6514e3          	bne	a0,s6,800041b2 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000420e:	22048513          	addi	a0,s1,544
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	4f0080e7          	jalr	1264(ra) # 80001702 <wakeup>
  release(&pi->lock);
    8000421a:	8526                	mv	a0,s1
    8000421c:	00002097          	auipc	ra,0x2
    80004220:	67a080e7          	jalr	1658(ra) # 80006896 <release>
  return i;
    80004224:	bfa9                	j	8000417e <pipewrite+0x54>
  int i = 0;
    80004226:	4901                	li	s2,0
    80004228:	b7dd                	j	8000420e <pipewrite+0xe4>

000000008000422a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000422a:	715d                	addi	sp,sp,-80
    8000422c:	e486                	sd	ra,72(sp)
    8000422e:	e0a2                	sd	s0,64(sp)
    80004230:	fc26                	sd	s1,56(sp)
    80004232:	f84a                	sd	s2,48(sp)
    80004234:	f44e                	sd	s3,40(sp)
    80004236:	f052                	sd	s4,32(sp)
    80004238:	ec56                	sd	s5,24(sp)
    8000423a:	e85a                	sd	s6,16(sp)
    8000423c:	0880                	addi	s0,sp,80
    8000423e:	84aa                	mv	s1,a0
    80004240:	892e                	mv	s2,a1
    80004242:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	db2080e7          	jalr	-590(ra) # 80000ff6 <myproc>
    8000424c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000424e:	8b26                	mv	s6,s1
    80004250:	8526                	mv	a0,s1
    80004252:	00002097          	auipc	ra,0x2
    80004256:	574080e7          	jalr	1396(ra) # 800067c6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000425a:	2204a703          	lw	a4,544(s1)
    8000425e:	2244a783          	lw	a5,548(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004262:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004266:	02f71763          	bne	a4,a5,80004294 <piperead+0x6a>
    8000426a:	22c4a783          	lw	a5,556(s1)
    8000426e:	c39d                	beqz	a5,80004294 <piperead+0x6a>
    if(killed(pr)){
    80004270:	8552                	mv	a0,s4
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	6d4080e7          	jalr	1748(ra) # 80001946 <killed>
    8000427a:	e941                	bnez	a0,8000430a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000427c:	85da                	mv	a1,s6
    8000427e:	854e                	mv	a0,s3
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	41e080e7          	jalr	1054(ra) # 8000169e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004288:	2204a703          	lw	a4,544(s1)
    8000428c:	2244a783          	lw	a5,548(s1)
    80004290:	fcf70de3          	beq	a4,a5,8000426a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004294:	09505263          	blez	s5,80004318 <piperead+0xee>
    80004298:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000429a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000429c:	2204a783          	lw	a5,544(s1)
    800042a0:	2244a703          	lw	a4,548(s1)
    800042a4:	02f70d63          	beq	a4,a5,800042de <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042a8:	0017871b          	addiw	a4,a5,1
    800042ac:	22e4a023          	sw	a4,544(s1)
    800042b0:	1ff7f793          	andi	a5,a5,511
    800042b4:	97a6                	add	a5,a5,s1
    800042b6:	0207c783          	lbu	a5,32(a5)
    800042ba:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042be:	4685                	li	a3,1
    800042c0:	fbf40613          	addi	a2,s0,-65
    800042c4:	85ca                	mv	a1,s2
    800042c6:	058a3503          	ld	a0,88(s4)
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	9b6080e7          	jalr	-1610(ra) # 80000c80 <copyout>
    800042d2:	01650663          	beq	a0,s6,800042de <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042d6:	2985                	addiw	s3,s3,1
    800042d8:	0905                	addi	s2,s2,1
    800042da:	fd3a91e3          	bne	s5,s3,8000429c <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042de:	22448513          	addi	a0,s1,548
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	420080e7          	jalr	1056(ra) # 80001702 <wakeup>
  release(&pi->lock);
    800042ea:	8526                	mv	a0,s1
    800042ec:	00002097          	auipc	ra,0x2
    800042f0:	5aa080e7          	jalr	1450(ra) # 80006896 <release>
  return i;
}
    800042f4:	854e                	mv	a0,s3
    800042f6:	60a6                	ld	ra,72(sp)
    800042f8:	6406                	ld	s0,64(sp)
    800042fa:	74e2                	ld	s1,56(sp)
    800042fc:	7942                	ld	s2,48(sp)
    800042fe:	79a2                	ld	s3,40(sp)
    80004300:	7a02                	ld	s4,32(sp)
    80004302:	6ae2                	ld	s5,24(sp)
    80004304:	6b42                	ld	s6,16(sp)
    80004306:	6161                	addi	sp,sp,80
    80004308:	8082                	ret
      release(&pi->lock);
    8000430a:	8526                	mv	a0,s1
    8000430c:	00002097          	auipc	ra,0x2
    80004310:	58a080e7          	jalr	1418(ra) # 80006896 <release>
      return -1;
    80004314:	59fd                	li	s3,-1
    80004316:	bff9                	j	800042f4 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004318:	4981                	li	s3,0
    8000431a:	b7d1                	j	800042de <piperead+0xb4>

000000008000431c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000431c:	1141                	addi	sp,sp,-16
    8000431e:	e422                	sd	s0,8(sp)
    80004320:	0800                	addi	s0,sp,16
    80004322:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004324:	8905                	andi	a0,a0,1
    80004326:	c111                	beqz	a0,8000432a <flags2perm+0xe>
      perm = PTE_X;
    80004328:	4521                	li	a0,8
    if(flags & 0x2)
    8000432a:	8b89                	andi	a5,a5,2
    8000432c:	c399                	beqz	a5,80004332 <flags2perm+0x16>
      perm |= PTE_W;
    8000432e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004332:	6422                	ld	s0,8(sp)
    80004334:	0141                	addi	sp,sp,16
    80004336:	8082                	ret

0000000080004338 <exec>:

int
exec(char *path, char **argv)
{
    80004338:	df010113          	addi	sp,sp,-528
    8000433c:	20113423          	sd	ra,520(sp)
    80004340:	20813023          	sd	s0,512(sp)
    80004344:	ffa6                	sd	s1,504(sp)
    80004346:	fbca                	sd	s2,496(sp)
    80004348:	f7ce                	sd	s3,488(sp)
    8000434a:	f3d2                	sd	s4,480(sp)
    8000434c:	efd6                	sd	s5,472(sp)
    8000434e:	ebda                	sd	s6,464(sp)
    80004350:	e7de                	sd	s7,456(sp)
    80004352:	e3e2                	sd	s8,448(sp)
    80004354:	ff66                	sd	s9,440(sp)
    80004356:	fb6a                	sd	s10,432(sp)
    80004358:	f76e                	sd	s11,424(sp)
    8000435a:	0c00                	addi	s0,sp,528
    8000435c:	84aa                	mv	s1,a0
    8000435e:	dea43c23          	sd	a0,-520(s0)
    80004362:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004366:	ffffd097          	auipc	ra,0xffffd
    8000436a:	c90080e7          	jalr	-880(ra) # 80000ff6 <myproc>
    8000436e:	892a                	mv	s2,a0

  begin_op();
    80004370:	fffff097          	auipc	ra,0xfffff
    80004374:	46a080e7          	jalr	1130(ra) # 800037da <begin_op>

  if((ip = namei(path)) == 0){
    80004378:	8526                	mv	a0,s1
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	244080e7          	jalr	580(ra) # 800035be <namei>
    80004382:	c92d                	beqz	a0,800043f4 <exec+0xbc>
    80004384:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004386:	fffff097          	auipc	ra,0xfffff
    8000438a:	a7e080e7          	jalr	-1410(ra) # 80002e04 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000438e:	04000713          	li	a4,64
    80004392:	4681                	li	a3,0
    80004394:	e5040613          	addi	a2,s0,-432
    80004398:	4581                	li	a1,0
    8000439a:	8526                	mv	a0,s1
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	d30080e7          	jalr	-720(ra) # 800030cc <readi>
    800043a4:	04000793          	li	a5,64
    800043a8:	00f51a63          	bne	a0,a5,800043bc <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800043ac:	e5042703          	lw	a4,-432(s0)
    800043b0:	464c47b7          	lui	a5,0x464c4
    800043b4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043b8:	04f70463          	beq	a4,a5,80004400 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043bc:	8526                	mv	a0,s1
    800043be:	fffff097          	auipc	ra,0xfffff
    800043c2:	cbc080e7          	jalr	-836(ra) # 8000307a <iunlockput>
    end_op();
    800043c6:	fffff097          	auipc	ra,0xfffff
    800043ca:	494080e7          	jalr	1172(ra) # 8000385a <end_op>
  }
  return -1;
    800043ce:	557d                	li	a0,-1
}
    800043d0:	20813083          	ld	ra,520(sp)
    800043d4:	20013403          	ld	s0,512(sp)
    800043d8:	74fe                	ld	s1,504(sp)
    800043da:	795e                	ld	s2,496(sp)
    800043dc:	79be                	ld	s3,488(sp)
    800043de:	7a1e                	ld	s4,480(sp)
    800043e0:	6afe                	ld	s5,472(sp)
    800043e2:	6b5e                	ld	s6,464(sp)
    800043e4:	6bbe                	ld	s7,456(sp)
    800043e6:	6c1e                	ld	s8,448(sp)
    800043e8:	7cfa                	ld	s9,440(sp)
    800043ea:	7d5a                	ld	s10,432(sp)
    800043ec:	7dba                	ld	s11,424(sp)
    800043ee:	21010113          	addi	sp,sp,528
    800043f2:	8082                	ret
    end_op();
    800043f4:	fffff097          	auipc	ra,0xfffff
    800043f8:	466080e7          	jalr	1126(ra) # 8000385a <end_op>
    return -1;
    800043fc:	557d                	li	a0,-1
    800043fe:	bfc9                	j	800043d0 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004400:	854a                	mv	a0,s2
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	cbc080e7          	jalr	-836(ra) # 800010be <proc_pagetable>
    8000440a:	8baa                	mv	s7,a0
    8000440c:	d945                	beqz	a0,800043bc <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000440e:	e7042983          	lw	s3,-400(s0)
    80004412:	e8845783          	lhu	a5,-376(s0)
    80004416:	c7ad                	beqz	a5,80004480 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004418:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000441a:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000441c:	6c85                	lui	s9,0x1
    8000441e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004422:	def43823          	sd	a5,-528(s0)
    80004426:	ac0d                	j	80004658 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004428:	00004517          	auipc	a0,0x4
    8000442c:	27050513          	addi	a0,a0,624 # 80008698 <syscalls+0x288>
    80004430:	00002097          	auipc	ra,0x2
    80004434:	e62080e7          	jalr	-414(ra) # 80006292 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004438:	8756                	mv	a4,s5
    8000443a:	012d86bb          	addw	a3,s11,s2
    8000443e:	4581                	li	a1,0
    80004440:	8526                	mv	a0,s1
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	c8a080e7          	jalr	-886(ra) # 800030cc <readi>
    8000444a:	2501                	sext.w	a0,a0
    8000444c:	1aaa9a63          	bne	s5,a0,80004600 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004450:	6785                	lui	a5,0x1
    80004452:	0127893b          	addw	s2,a5,s2
    80004456:	77fd                	lui	a5,0xfffff
    80004458:	01478a3b          	addw	s4,a5,s4
    8000445c:	1f897563          	bgeu	s2,s8,80004646 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004460:	02091593          	slli	a1,s2,0x20
    80004464:	9181                	srli	a1,a1,0x20
    80004466:	95ea                	add	a1,a1,s10
    80004468:	855e                	mv	a0,s7
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	1e6080e7          	jalr	486(ra) # 80000650 <walkaddr>
    80004472:	862a                	mv	a2,a0
    if(pa == 0)
    80004474:	d955                	beqz	a0,80004428 <exec+0xf0>
      n = PGSIZE;
    80004476:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004478:	fd9a70e3          	bgeu	s4,s9,80004438 <exec+0x100>
      n = sz - i;
    8000447c:	8ad2                	mv	s5,s4
    8000447e:	bf6d                	j	80004438 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004480:	4a01                	li	s4,0
  iunlockput(ip);
    80004482:	8526                	mv	a0,s1
    80004484:	fffff097          	auipc	ra,0xfffff
    80004488:	bf6080e7          	jalr	-1034(ra) # 8000307a <iunlockput>
  end_op();
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	3ce080e7          	jalr	974(ra) # 8000385a <end_op>
  p = myproc();
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	b62080e7          	jalr	-1182(ra) # 80000ff6 <myproc>
    8000449c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000449e:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800044a2:	6785                	lui	a5,0x1
    800044a4:	17fd                	addi	a5,a5,-1
    800044a6:	9a3e                	add	s4,s4,a5
    800044a8:	757d                	lui	a0,0xfffff
    800044aa:	00aa77b3          	and	a5,s4,a0
    800044ae:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800044b2:	4691                	li	a3,4
    800044b4:	6609                	lui	a2,0x2
    800044b6:	963e                	add	a2,a2,a5
    800044b8:	85be                	mv	a1,a5
    800044ba:	855e                	mv	a0,s7
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	56c080e7          	jalr	1388(ra) # 80000a28 <uvmalloc>
    800044c4:	8b2a                	mv	s6,a0
  ip = 0;
    800044c6:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800044c8:	12050c63          	beqz	a0,80004600 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044cc:	75f9                	lui	a1,0xffffe
    800044ce:	95aa                	add	a1,a1,a0
    800044d0:	855e                	mv	a0,s7
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	77c080e7          	jalr	1916(ra) # 80000c4e <uvmclear>
  stackbase = sp - PGSIZE;
    800044da:	7c7d                	lui	s8,0xfffff
    800044dc:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800044de:	e0043783          	ld	a5,-512(s0)
    800044e2:	6388                	ld	a0,0(a5)
    800044e4:	c535                	beqz	a0,80004550 <exec+0x218>
    800044e6:	e9040993          	addi	s3,s0,-368
    800044ea:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044ee:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	f42080e7          	jalr	-190(ra) # 80000432 <strlen>
    800044f8:	2505                	addiw	a0,a0,1
    800044fa:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044fe:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004502:	13896663          	bltu	s2,s8,8000462e <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004506:	e0043d83          	ld	s11,-512(s0)
    8000450a:	000dba03          	ld	s4,0(s11)
    8000450e:	8552                	mv	a0,s4
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	f22080e7          	jalr	-222(ra) # 80000432 <strlen>
    80004518:	0015069b          	addiw	a3,a0,1
    8000451c:	8652                	mv	a2,s4
    8000451e:	85ca                	mv	a1,s2
    80004520:	855e                	mv	a0,s7
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	75e080e7          	jalr	1886(ra) # 80000c80 <copyout>
    8000452a:	10054663          	bltz	a0,80004636 <exec+0x2fe>
    ustack[argc] = sp;
    8000452e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004532:	0485                	addi	s1,s1,1
    80004534:	008d8793          	addi	a5,s11,8
    80004538:	e0f43023          	sd	a5,-512(s0)
    8000453c:	008db503          	ld	a0,8(s11)
    80004540:	c911                	beqz	a0,80004554 <exec+0x21c>
    if(argc >= MAXARG)
    80004542:	09a1                	addi	s3,s3,8
    80004544:	fb3c96e3          	bne	s9,s3,800044f0 <exec+0x1b8>
  sz = sz1;
    80004548:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000454c:	4481                	li	s1,0
    8000454e:	a84d                	j	80004600 <exec+0x2c8>
  sp = sz;
    80004550:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004552:	4481                	li	s1,0
  ustack[argc] = 0;
    80004554:	00349793          	slli	a5,s1,0x3
    80004558:	f9040713          	addi	a4,s0,-112
    8000455c:	97ba                	add	a5,a5,a4
    8000455e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004562:	00148693          	addi	a3,s1,1
    80004566:	068e                	slli	a3,a3,0x3
    80004568:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000456c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004570:	01897663          	bgeu	s2,s8,8000457c <exec+0x244>
  sz = sz1;
    80004574:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004578:	4481                	li	s1,0
    8000457a:	a059                	j	80004600 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000457c:	e9040613          	addi	a2,s0,-368
    80004580:	85ca                	mv	a1,s2
    80004582:	855e                	mv	a0,s7
    80004584:	ffffc097          	auipc	ra,0xffffc
    80004588:	6fc080e7          	jalr	1788(ra) # 80000c80 <copyout>
    8000458c:	0a054963          	bltz	a0,8000463e <exec+0x306>
  p->trapframe->a1 = sp;
    80004590:	060ab783          	ld	a5,96(s5)
    80004594:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004598:	df843783          	ld	a5,-520(s0)
    8000459c:	0007c703          	lbu	a4,0(a5)
    800045a0:	cf11                	beqz	a4,800045bc <exec+0x284>
    800045a2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045a4:	02f00693          	li	a3,47
    800045a8:	a039                	j	800045b6 <exec+0x27e>
      last = s+1;
    800045aa:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045ae:	0785                	addi	a5,a5,1
    800045b0:	fff7c703          	lbu	a4,-1(a5)
    800045b4:	c701                	beqz	a4,800045bc <exec+0x284>
    if(*s == '/')
    800045b6:	fed71ce3          	bne	a4,a3,800045ae <exec+0x276>
    800045ba:	bfc5                	j	800045aa <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800045bc:	4641                	li	a2,16
    800045be:	df843583          	ld	a1,-520(s0)
    800045c2:	160a8513          	addi	a0,s5,352
    800045c6:	ffffc097          	auipc	ra,0xffffc
    800045ca:	e3a080e7          	jalr	-454(ra) # 80000400 <safestrcpy>
  oldpagetable = p->pagetable;
    800045ce:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800045d2:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    800045d6:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045da:	060ab783          	ld	a5,96(s5)
    800045de:	e6843703          	ld	a4,-408(s0)
    800045e2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045e4:	060ab783          	ld	a5,96(s5)
    800045e8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045ec:	85ea                	mv	a1,s10
    800045ee:	ffffd097          	auipc	ra,0xffffd
    800045f2:	b6c080e7          	jalr	-1172(ra) # 8000115a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045f6:	0004851b          	sext.w	a0,s1
    800045fa:	bbd9                	j	800043d0 <exec+0x98>
    800045fc:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004600:	e0843583          	ld	a1,-504(s0)
    80004604:	855e                	mv	a0,s7
    80004606:	ffffd097          	auipc	ra,0xffffd
    8000460a:	b54080e7          	jalr	-1196(ra) # 8000115a <proc_freepagetable>
  if(ip){
    8000460e:	da0497e3          	bnez	s1,800043bc <exec+0x84>
  return -1;
    80004612:	557d                	li	a0,-1
    80004614:	bb75                	j	800043d0 <exec+0x98>
    80004616:	e1443423          	sd	s4,-504(s0)
    8000461a:	b7dd                	j	80004600 <exec+0x2c8>
    8000461c:	e1443423          	sd	s4,-504(s0)
    80004620:	b7c5                	j	80004600 <exec+0x2c8>
    80004622:	e1443423          	sd	s4,-504(s0)
    80004626:	bfe9                	j	80004600 <exec+0x2c8>
    80004628:	e1443423          	sd	s4,-504(s0)
    8000462c:	bfd1                	j	80004600 <exec+0x2c8>
  sz = sz1;
    8000462e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004632:	4481                	li	s1,0
    80004634:	b7f1                	j	80004600 <exec+0x2c8>
  sz = sz1;
    80004636:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000463a:	4481                	li	s1,0
    8000463c:	b7d1                	j	80004600 <exec+0x2c8>
  sz = sz1;
    8000463e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004642:	4481                	li	s1,0
    80004644:	bf75                	j	80004600 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004646:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000464a:	2b05                	addiw	s6,s6,1
    8000464c:	0389899b          	addiw	s3,s3,56
    80004650:	e8845783          	lhu	a5,-376(s0)
    80004654:	e2fb57e3          	bge	s6,a5,80004482 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004658:	2981                	sext.w	s3,s3
    8000465a:	03800713          	li	a4,56
    8000465e:	86ce                	mv	a3,s3
    80004660:	e1840613          	addi	a2,s0,-488
    80004664:	4581                	li	a1,0
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	a64080e7          	jalr	-1436(ra) # 800030cc <readi>
    80004670:	03800793          	li	a5,56
    80004674:	f8f514e3          	bne	a0,a5,800045fc <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004678:	e1842783          	lw	a5,-488(s0)
    8000467c:	4705                	li	a4,1
    8000467e:	fce796e3          	bne	a5,a4,8000464a <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004682:	e4043903          	ld	s2,-448(s0)
    80004686:	e3843783          	ld	a5,-456(s0)
    8000468a:	f8f966e3          	bltu	s2,a5,80004616 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000468e:	e2843783          	ld	a5,-472(s0)
    80004692:	993e                	add	s2,s2,a5
    80004694:	f8f964e3          	bltu	s2,a5,8000461c <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004698:	df043703          	ld	a4,-528(s0)
    8000469c:	8ff9                	and	a5,a5,a4
    8000469e:	f3d1                	bnez	a5,80004622 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046a0:	e1c42503          	lw	a0,-484(s0)
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	c78080e7          	jalr	-904(ra) # 8000431c <flags2perm>
    800046ac:	86aa                	mv	a3,a0
    800046ae:	864a                	mv	a2,s2
    800046b0:	85d2                	mv	a1,s4
    800046b2:	855e                	mv	a0,s7
    800046b4:	ffffc097          	auipc	ra,0xffffc
    800046b8:	374080e7          	jalr	884(ra) # 80000a28 <uvmalloc>
    800046bc:	e0a43423          	sd	a0,-504(s0)
    800046c0:	d525                	beqz	a0,80004628 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046c2:	e2843d03          	ld	s10,-472(s0)
    800046c6:	e2042d83          	lw	s11,-480(s0)
    800046ca:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046ce:	f60c0ce3          	beqz	s8,80004646 <exec+0x30e>
    800046d2:	8a62                	mv	s4,s8
    800046d4:	4901                	li	s2,0
    800046d6:	b369                	j	80004460 <exec+0x128>

00000000800046d8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046d8:	7179                	addi	sp,sp,-48
    800046da:	f406                	sd	ra,40(sp)
    800046dc:	f022                	sd	s0,32(sp)
    800046de:	ec26                	sd	s1,24(sp)
    800046e0:	e84a                	sd	s2,16(sp)
    800046e2:	1800                	addi	s0,sp,48
    800046e4:	892e                	mv	s2,a1
    800046e6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800046e8:	fdc40593          	addi	a1,s0,-36
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	a1e080e7          	jalr	-1506(ra) # 8000210a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046f4:	fdc42703          	lw	a4,-36(s0)
    800046f8:	47bd                	li	a5,15
    800046fa:	02e7eb63          	bltu	a5,a4,80004730 <argfd+0x58>
    800046fe:	ffffd097          	auipc	ra,0xffffd
    80004702:	8f8080e7          	jalr	-1800(ra) # 80000ff6 <myproc>
    80004706:	fdc42703          	lw	a4,-36(s0)
    8000470a:	01a70793          	addi	a5,a4,26
    8000470e:	078e                	slli	a5,a5,0x3
    80004710:	953e                	add	a0,a0,a5
    80004712:	651c                	ld	a5,8(a0)
    80004714:	c385                	beqz	a5,80004734 <argfd+0x5c>
    return -1;
  if(pfd)
    80004716:	00090463          	beqz	s2,8000471e <argfd+0x46>
    *pfd = fd;
    8000471a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000471e:	4501                	li	a0,0
  if(pf)
    80004720:	c091                	beqz	s1,80004724 <argfd+0x4c>
    *pf = f;
    80004722:	e09c                	sd	a5,0(s1)
}
    80004724:	70a2                	ld	ra,40(sp)
    80004726:	7402                	ld	s0,32(sp)
    80004728:	64e2                	ld	s1,24(sp)
    8000472a:	6942                	ld	s2,16(sp)
    8000472c:	6145                	addi	sp,sp,48
    8000472e:	8082                	ret
    return -1;
    80004730:	557d                	li	a0,-1
    80004732:	bfcd                	j	80004724 <argfd+0x4c>
    80004734:	557d                	li	a0,-1
    80004736:	b7fd                	j	80004724 <argfd+0x4c>

0000000080004738 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004738:	1101                	addi	sp,sp,-32
    8000473a:	ec06                	sd	ra,24(sp)
    8000473c:	e822                	sd	s0,16(sp)
    8000473e:	e426                	sd	s1,8(sp)
    80004740:	1000                	addi	s0,sp,32
    80004742:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004744:	ffffd097          	auipc	ra,0xffffd
    80004748:	8b2080e7          	jalr	-1870(ra) # 80000ff6 <myproc>
    8000474c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000474e:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd7420>
    80004752:	4501                	li	a0,0
    80004754:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004756:	6398                	ld	a4,0(a5)
    80004758:	cb19                	beqz	a4,8000476e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000475a:	2505                	addiw	a0,a0,1
    8000475c:	07a1                	addi	a5,a5,8
    8000475e:	fed51ce3          	bne	a0,a3,80004756 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004762:	557d                	li	a0,-1
}
    80004764:	60e2                	ld	ra,24(sp)
    80004766:	6442                	ld	s0,16(sp)
    80004768:	64a2                	ld	s1,8(sp)
    8000476a:	6105                	addi	sp,sp,32
    8000476c:	8082                	ret
      p->ofile[fd] = f;
    8000476e:	01a50793          	addi	a5,a0,26
    80004772:	078e                	slli	a5,a5,0x3
    80004774:	963e                	add	a2,a2,a5
    80004776:	e604                	sd	s1,8(a2)
      return fd;
    80004778:	b7f5                	j	80004764 <fdalloc+0x2c>

000000008000477a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000477a:	715d                	addi	sp,sp,-80
    8000477c:	e486                	sd	ra,72(sp)
    8000477e:	e0a2                	sd	s0,64(sp)
    80004780:	fc26                	sd	s1,56(sp)
    80004782:	f84a                	sd	s2,48(sp)
    80004784:	f44e                	sd	s3,40(sp)
    80004786:	f052                	sd	s4,32(sp)
    80004788:	ec56                	sd	s5,24(sp)
    8000478a:	e85a                	sd	s6,16(sp)
    8000478c:	0880                	addi	s0,sp,80
    8000478e:	8b2e                	mv	s6,a1
    80004790:	89b2                	mv	s3,a2
    80004792:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004794:	fb040593          	addi	a1,s0,-80
    80004798:	fffff097          	auipc	ra,0xfffff
    8000479c:	e44080e7          	jalr	-444(ra) # 800035dc <nameiparent>
    800047a0:	84aa                	mv	s1,a0
    800047a2:	16050063          	beqz	a0,80004902 <create+0x188>
    return 0;

  ilock(dp);
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	65e080e7          	jalr	1630(ra) # 80002e04 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047ae:	4601                	li	a2,0
    800047b0:	fb040593          	addi	a1,s0,-80
    800047b4:	8526                	mv	a0,s1
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	b46080e7          	jalr	-1210(ra) # 800032fc <dirlookup>
    800047be:	8aaa                	mv	s5,a0
    800047c0:	c931                	beqz	a0,80004814 <create+0x9a>
    iunlockput(dp);
    800047c2:	8526                	mv	a0,s1
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	8b6080e7          	jalr	-1866(ra) # 8000307a <iunlockput>
    ilock(ip);
    800047cc:	8556                	mv	a0,s5
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	636080e7          	jalr	1590(ra) # 80002e04 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047d6:	000b059b          	sext.w	a1,s6
    800047da:	4789                	li	a5,2
    800047dc:	02f59563          	bne	a1,a5,80004806 <create+0x8c>
    800047e0:	04cad783          	lhu	a5,76(s5)
    800047e4:	37f9                	addiw	a5,a5,-2
    800047e6:	17c2                	slli	a5,a5,0x30
    800047e8:	93c1                	srli	a5,a5,0x30
    800047ea:	4705                	li	a4,1
    800047ec:	00f76d63          	bltu	a4,a5,80004806 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800047f0:	8556                	mv	a0,s5
    800047f2:	60a6                	ld	ra,72(sp)
    800047f4:	6406                	ld	s0,64(sp)
    800047f6:	74e2                	ld	s1,56(sp)
    800047f8:	7942                	ld	s2,48(sp)
    800047fa:	79a2                	ld	s3,40(sp)
    800047fc:	7a02                	ld	s4,32(sp)
    800047fe:	6ae2                	ld	s5,24(sp)
    80004800:	6b42                	ld	s6,16(sp)
    80004802:	6161                	addi	sp,sp,80
    80004804:	8082                	ret
    iunlockput(ip);
    80004806:	8556                	mv	a0,s5
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	872080e7          	jalr	-1934(ra) # 8000307a <iunlockput>
    return 0;
    80004810:	4a81                	li	s5,0
    80004812:	bff9                	j	800047f0 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004814:	85da                	mv	a1,s6
    80004816:	4088                	lw	a0,0(s1)
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	450080e7          	jalr	1104(ra) # 80002c68 <ialloc>
    80004820:	8a2a                	mv	s4,a0
    80004822:	c921                	beqz	a0,80004872 <create+0xf8>
  ilock(ip);
    80004824:	ffffe097          	auipc	ra,0xffffe
    80004828:	5e0080e7          	jalr	1504(ra) # 80002e04 <ilock>
  ip->major = major;
    8000482c:	053a1723          	sh	s3,78(s4)
  ip->minor = minor;
    80004830:	052a1823          	sh	s2,80(s4)
  ip->nlink = 1;
    80004834:	4785                	li	a5,1
    80004836:	04fa1923          	sh	a5,82(s4)
  iupdate(ip);
    8000483a:	8552                	mv	a0,s4
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	4fe080e7          	jalr	1278(ra) # 80002d3a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004844:	000b059b          	sext.w	a1,s6
    80004848:	4785                	li	a5,1
    8000484a:	02f58b63          	beq	a1,a5,80004880 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000484e:	004a2603          	lw	a2,4(s4)
    80004852:	fb040593          	addi	a1,s0,-80
    80004856:	8526                	mv	a0,s1
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	cb4080e7          	jalr	-844(ra) # 8000350c <dirlink>
    80004860:	06054f63          	bltz	a0,800048de <create+0x164>
  iunlockput(dp);
    80004864:	8526                	mv	a0,s1
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	814080e7          	jalr	-2028(ra) # 8000307a <iunlockput>
  return ip;
    8000486e:	8ad2                	mv	s5,s4
    80004870:	b741                	j	800047f0 <create+0x76>
    iunlockput(dp);
    80004872:	8526                	mv	a0,s1
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	806080e7          	jalr	-2042(ra) # 8000307a <iunlockput>
    return 0;
    8000487c:	8ad2                	mv	s5,s4
    8000487e:	bf8d                	j	800047f0 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004880:	004a2603          	lw	a2,4(s4)
    80004884:	00004597          	auipc	a1,0x4
    80004888:	e3458593          	addi	a1,a1,-460 # 800086b8 <syscalls+0x2a8>
    8000488c:	8552                	mv	a0,s4
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	c7e080e7          	jalr	-898(ra) # 8000350c <dirlink>
    80004896:	04054463          	bltz	a0,800048de <create+0x164>
    8000489a:	40d0                	lw	a2,4(s1)
    8000489c:	00004597          	auipc	a1,0x4
    800048a0:	e2458593          	addi	a1,a1,-476 # 800086c0 <syscalls+0x2b0>
    800048a4:	8552                	mv	a0,s4
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	c66080e7          	jalr	-922(ra) # 8000350c <dirlink>
    800048ae:	02054863          	bltz	a0,800048de <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800048b2:	004a2603          	lw	a2,4(s4)
    800048b6:	fb040593          	addi	a1,s0,-80
    800048ba:	8526                	mv	a0,s1
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	c50080e7          	jalr	-944(ra) # 8000350c <dirlink>
    800048c4:	00054d63          	bltz	a0,800048de <create+0x164>
    dp->nlink++;  // for ".."
    800048c8:	0524d783          	lhu	a5,82(s1)
    800048cc:	2785                	addiw	a5,a5,1
    800048ce:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	466080e7          	jalr	1126(ra) # 80002d3a <iupdate>
    800048dc:	b761                	j	80004864 <create+0xea>
  ip->nlink = 0;
    800048de:	040a1923          	sh	zero,82(s4)
  iupdate(ip);
    800048e2:	8552                	mv	a0,s4
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	456080e7          	jalr	1110(ra) # 80002d3a <iupdate>
  iunlockput(ip);
    800048ec:	8552                	mv	a0,s4
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	78c080e7          	jalr	1932(ra) # 8000307a <iunlockput>
  iunlockput(dp);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	782080e7          	jalr	1922(ra) # 8000307a <iunlockput>
  return 0;
    80004900:	bdc5                	j	800047f0 <create+0x76>
    return 0;
    80004902:	8aaa                	mv	s5,a0
    80004904:	b5f5                	j	800047f0 <create+0x76>

0000000080004906 <sys_dup>:
{
    80004906:	7179                	addi	sp,sp,-48
    80004908:	f406                	sd	ra,40(sp)
    8000490a:	f022                	sd	s0,32(sp)
    8000490c:	ec26                	sd	s1,24(sp)
    8000490e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004910:	fd840613          	addi	a2,s0,-40
    80004914:	4581                	li	a1,0
    80004916:	4501                	li	a0,0
    80004918:	00000097          	auipc	ra,0x0
    8000491c:	dc0080e7          	jalr	-576(ra) # 800046d8 <argfd>
    return -1;
    80004920:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004922:	02054363          	bltz	a0,80004948 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004926:	fd843503          	ld	a0,-40(s0)
    8000492a:	00000097          	auipc	ra,0x0
    8000492e:	e0e080e7          	jalr	-498(ra) # 80004738 <fdalloc>
    80004932:	84aa                	mv	s1,a0
    return -1;
    80004934:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004936:	00054963          	bltz	a0,80004948 <sys_dup+0x42>
  filedup(f);
    8000493a:	fd843503          	ld	a0,-40(s0)
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	316080e7          	jalr	790(ra) # 80003c54 <filedup>
  return fd;
    80004946:	87a6                	mv	a5,s1
}
    80004948:	853e                	mv	a0,a5
    8000494a:	70a2                	ld	ra,40(sp)
    8000494c:	7402                	ld	s0,32(sp)
    8000494e:	64e2                	ld	s1,24(sp)
    80004950:	6145                	addi	sp,sp,48
    80004952:	8082                	ret

0000000080004954 <sys_read>:
{
    80004954:	7179                	addi	sp,sp,-48
    80004956:	f406                	sd	ra,40(sp)
    80004958:	f022                	sd	s0,32(sp)
    8000495a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000495c:	fd840593          	addi	a1,s0,-40
    80004960:	4505                	li	a0,1
    80004962:	ffffd097          	auipc	ra,0xffffd
    80004966:	7c8080e7          	jalr	1992(ra) # 8000212a <argaddr>
  argint(2, &n);
    8000496a:	fe440593          	addi	a1,s0,-28
    8000496e:	4509                	li	a0,2
    80004970:	ffffd097          	auipc	ra,0xffffd
    80004974:	79a080e7          	jalr	1946(ra) # 8000210a <argint>
  if(argfd(0, 0, &f) < 0)
    80004978:	fe840613          	addi	a2,s0,-24
    8000497c:	4581                	li	a1,0
    8000497e:	4501                	li	a0,0
    80004980:	00000097          	auipc	ra,0x0
    80004984:	d58080e7          	jalr	-680(ra) # 800046d8 <argfd>
    80004988:	87aa                	mv	a5,a0
    return -1;
    8000498a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000498c:	0007cc63          	bltz	a5,800049a4 <sys_read+0x50>
  return fileread(f, p, n);
    80004990:	fe442603          	lw	a2,-28(s0)
    80004994:	fd843583          	ld	a1,-40(s0)
    80004998:	fe843503          	ld	a0,-24(s0)
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	444080e7          	jalr	1092(ra) # 80003de0 <fileread>
}
    800049a4:	70a2                	ld	ra,40(sp)
    800049a6:	7402                	ld	s0,32(sp)
    800049a8:	6145                	addi	sp,sp,48
    800049aa:	8082                	ret

00000000800049ac <sys_write>:
{
    800049ac:	7179                	addi	sp,sp,-48
    800049ae:	f406                	sd	ra,40(sp)
    800049b0:	f022                	sd	s0,32(sp)
    800049b2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049b4:	fd840593          	addi	a1,s0,-40
    800049b8:	4505                	li	a0,1
    800049ba:	ffffd097          	auipc	ra,0xffffd
    800049be:	770080e7          	jalr	1904(ra) # 8000212a <argaddr>
  argint(2, &n);
    800049c2:	fe440593          	addi	a1,s0,-28
    800049c6:	4509                	li	a0,2
    800049c8:	ffffd097          	auipc	ra,0xffffd
    800049cc:	742080e7          	jalr	1858(ra) # 8000210a <argint>
  if(argfd(0, 0, &f) < 0)
    800049d0:	fe840613          	addi	a2,s0,-24
    800049d4:	4581                	li	a1,0
    800049d6:	4501                	li	a0,0
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	d00080e7          	jalr	-768(ra) # 800046d8 <argfd>
    800049e0:	87aa                	mv	a5,a0
    return -1;
    800049e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049e4:	0007cc63          	bltz	a5,800049fc <sys_write+0x50>
  return filewrite(f, p, n);
    800049e8:	fe442603          	lw	a2,-28(s0)
    800049ec:	fd843583          	ld	a1,-40(s0)
    800049f0:	fe843503          	ld	a0,-24(s0)
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	4ae080e7          	jalr	1198(ra) # 80003ea2 <filewrite>
}
    800049fc:	70a2                	ld	ra,40(sp)
    800049fe:	7402                	ld	s0,32(sp)
    80004a00:	6145                	addi	sp,sp,48
    80004a02:	8082                	ret

0000000080004a04 <sys_close>:
{
    80004a04:	1101                	addi	sp,sp,-32
    80004a06:	ec06                	sd	ra,24(sp)
    80004a08:	e822                	sd	s0,16(sp)
    80004a0a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a0c:	fe040613          	addi	a2,s0,-32
    80004a10:	fec40593          	addi	a1,s0,-20
    80004a14:	4501                	li	a0,0
    80004a16:	00000097          	auipc	ra,0x0
    80004a1a:	cc2080e7          	jalr	-830(ra) # 800046d8 <argfd>
    return -1;
    80004a1e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a20:	02054463          	bltz	a0,80004a48 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a24:	ffffc097          	auipc	ra,0xffffc
    80004a28:	5d2080e7          	jalr	1490(ra) # 80000ff6 <myproc>
    80004a2c:	fec42783          	lw	a5,-20(s0)
    80004a30:	07e9                	addi	a5,a5,26
    80004a32:	078e                	slli	a5,a5,0x3
    80004a34:	97aa                	add	a5,a5,a0
    80004a36:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80004a3a:	fe043503          	ld	a0,-32(s0)
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	268080e7          	jalr	616(ra) # 80003ca6 <fileclose>
  return 0;
    80004a46:	4781                	li	a5,0
}
    80004a48:	853e                	mv	a0,a5
    80004a4a:	60e2                	ld	ra,24(sp)
    80004a4c:	6442                	ld	s0,16(sp)
    80004a4e:	6105                	addi	sp,sp,32
    80004a50:	8082                	ret

0000000080004a52 <sys_fstat>:
{
    80004a52:	1101                	addi	sp,sp,-32
    80004a54:	ec06                	sd	ra,24(sp)
    80004a56:	e822                	sd	s0,16(sp)
    80004a58:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004a5a:	fe040593          	addi	a1,s0,-32
    80004a5e:	4505                	li	a0,1
    80004a60:	ffffd097          	auipc	ra,0xffffd
    80004a64:	6ca080e7          	jalr	1738(ra) # 8000212a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a68:	fe840613          	addi	a2,s0,-24
    80004a6c:	4581                	li	a1,0
    80004a6e:	4501                	li	a0,0
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	c68080e7          	jalr	-920(ra) # 800046d8 <argfd>
    80004a78:	87aa                	mv	a5,a0
    return -1;
    80004a7a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a7c:	0007ca63          	bltz	a5,80004a90 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a80:	fe043583          	ld	a1,-32(s0)
    80004a84:	fe843503          	ld	a0,-24(s0)
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	2e6080e7          	jalr	742(ra) # 80003d6e <filestat>
}
    80004a90:	60e2                	ld	ra,24(sp)
    80004a92:	6442                	ld	s0,16(sp)
    80004a94:	6105                	addi	sp,sp,32
    80004a96:	8082                	ret

0000000080004a98 <sys_link>:
{
    80004a98:	7169                	addi	sp,sp,-304
    80004a9a:	f606                	sd	ra,296(sp)
    80004a9c:	f222                	sd	s0,288(sp)
    80004a9e:	ee26                	sd	s1,280(sp)
    80004aa0:	ea4a                	sd	s2,272(sp)
    80004aa2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aa4:	08000613          	li	a2,128
    80004aa8:	ed040593          	addi	a1,s0,-304
    80004aac:	4501                	li	a0,0
    80004aae:	ffffd097          	auipc	ra,0xffffd
    80004ab2:	69c080e7          	jalr	1692(ra) # 8000214a <argstr>
    return -1;
    80004ab6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ab8:	10054e63          	bltz	a0,80004bd4 <sys_link+0x13c>
    80004abc:	08000613          	li	a2,128
    80004ac0:	f5040593          	addi	a1,s0,-176
    80004ac4:	4505                	li	a0,1
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	684080e7          	jalr	1668(ra) # 8000214a <argstr>
    return -1;
    80004ace:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ad0:	10054263          	bltz	a0,80004bd4 <sys_link+0x13c>
  begin_op();
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	d06080e7          	jalr	-762(ra) # 800037da <begin_op>
  if((ip = namei(old)) == 0){
    80004adc:	ed040513          	addi	a0,s0,-304
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	ade080e7          	jalr	-1314(ra) # 800035be <namei>
    80004ae8:	84aa                	mv	s1,a0
    80004aea:	c551                	beqz	a0,80004b76 <sys_link+0xde>
  ilock(ip);
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	318080e7          	jalr	792(ra) # 80002e04 <ilock>
  if(ip->type == T_DIR){
    80004af4:	04c49703          	lh	a4,76(s1)
    80004af8:	4785                	li	a5,1
    80004afa:	08f70463          	beq	a4,a5,80004b82 <sys_link+0xea>
  ip->nlink++;
    80004afe:	0524d783          	lhu	a5,82(s1)
    80004b02:	2785                	addiw	a5,a5,1
    80004b04:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	230080e7          	jalr	560(ra) # 80002d3a <iupdate>
  iunlock(ip);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	3bc080e7          	jalr	956(ra) # 80002ed0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b1c:	fd040593          	addi	a1,s0,-48
    80004b20:	f5040513          	addi	a0,s0,-176
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	ab8080e7          	jalr	-1352(ra) # 800035dc <nameiparent>
    80004b2c:	892a                	mv	s2,a0
    80004b2e:	c935                	beqz	a0,80004ba2 <sys_link+0x10a>
  ilock(dp);
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	2d4080e7          	jalr	724(ra) # 80002e04 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b38:	00092703          	lw	a4,0(s2)
    80004b3c:	409c                	lw	a5,0(s1)
    80004b3e:	04f71d63          	bne	a4,a5,80004b98 <sys_link+0x100>
    80004b42:	40d0                	lw	a2,4(s1)
    80004b44:	fd040593          	addi	a1,s0,-48
    80004b48:	854a                	mv	a0,s2
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	9c2080e7          	jalr	-1598(ra) # 8000350c <dirlink>
    80004b52:	04054363          	bltz	a0,80004b98 <sys_link+0x100>
  iunlockput(dp);
    80004b56:	854a                	mv	a0,s2
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	522080e7          	jalr	1314(ra) # 8000307a <iunlockput>
  iput(ip);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	470080e7          	jalr	1136(ra) # 80002fd2 <iput>
  end_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	cf0080e7          	jalr	-784(ra) # 8000385a <end_op>
  return 0;
    80004b72:	4781                	li	a5,0
    80004b74:	a085                	j	80004bd4 <sys_link+0x13c>
    end_op();
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	ce4080e7          	jalr	-796(ra) # 8000385a <end_op>
    return -1;
    80004b7e:	57fd                	li	a5,-1
    80004b80:	a891                	j	80004bd4 <sys_link+0x13c>
    iunlockput(ip);
    80004b82:	8526                	mv	a0,s1
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	4f6080e7          	jalr	1270(ra) # 8000307a <iunlockput>
    end_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	cce080e7          	jalr	-818(ra) # 8000385a <end_op>
    return -1;
    80004b94:	57fd                	li	a5,-1
    80004b96:	a83d                	j	80004bd4 <sys_link+0x13c>
    iunlockput(dp);
    80004b98:	854a                	mv	a0,s2
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	4e0080e7          	jalr	1248(ra) # 8000307a <iunlockput>
  ilock(ip);
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	260080e7          	jalr	608(ra) # 80002e04 <ilock>
  ip->nlink--;
    80004bac:	0524d783          	lhu	a5,82(s1)
    80004bb0:	37fd                	addiw	a5,a5,-1
    80004bb2:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004bb6:	8526                	mv	a0,s1
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	182080e7          	jalr	386(ra) # 80002d3a <iupdate>
  iunlockput(ip);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	4b8080e7          	jalr	1208(ra) # 8000307a <iunlockput>
  end_op();
    80004bca:	fffff097          	auipc	ra,0xfffff
    80004bce:	c90080e7          	jalr	-880(ra) # 8000385a <end_op>
  return -1;
    80004bd2:	57fd                	li	a5,-1
}
    80004bd4:	853e                	mv	a0,a5
    80004bd6:	70b2                	ld	ra,296(sp)
    80004bd8:	7412                	ld	s0,288(sp)
    80004bda:	64f2                	ld	s1,280(sp)
    80004bdc:	6952                	ld	s2,272(sp)
    80004bde:	6155                	addi	sp,sp,304
    80004be0:	8082                	ret

0000000080004be2 <sys_unlink>:
{
    80004be2:	7151                	addi	sp,sp,-240
    80004be4:	f586                	sd	ra,232(sp)
    80004be6:	f1a2                	sd	s0,224(sp)
    80004be8:	eda6                	sd	s1,216(sp)
    80004bea:	e9ca                	sd	s2,208(sp)
    80004bec:	e5ce                	sd	s3,200(sp)
    80004bee:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bf0:	08000613          	li	a2,128
    80004bf4:	f3040593          	addi	a1,s0,-208
    80004bf8:	4501                	li	a0,0
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	550080e7          	jalr	1360(ra) # 8000214a <argstr>
    80004c02:	18054163          	bltz	a0,80004d84 <sys_unlink+0x1a2>
  begin_op();
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	bd4080e7          	jalr	-1068(ra) # 800037da <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c0e:	fb040593          	addi	a1,s0,-80
    80004c12:	f3040513          	addi	a0,s0,-208
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	9c6080e7          	jalr	-1594(ra) # 800035dc <nameiparent>
    80004c1e:	84aa                	mv	s1,a0
    80004c20:	c979                	beqz	a0,80004cf6 <sys_unlink+0x114>
  ilock(dp);
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	1e2080e7          	jalr	482(ra) # 80002e04 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c2a:	00004597          	auipc	a1,0x4
    80004c2e:	a8e58593          	addi	a1,a1,-1394 # 800086b8 <syscalls+0x2a8>
    80004c32:	fb040513          	addi	a0,s0,-80
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	6ac080e7          	jalr	1708(ra) # 800032e2 <namecmp>
    80004c3e:	14050a63          	beqz	a0,80004d92 <sys_unlink+0x1b0>
    80004c42:	00004597          	auipc	a1,0x4
    80004c46:	a7e58593          	addi	a1,a1,-1410 # 800086c0 <syscalls+0x2b0>
    80004c4a:	fb040513          	addi	a0,s0,-80
    80004c4e:	ffffe097          	auipc	ra,0xffffe
    80004c52:	694080e7          	jalr	1684(ra) # 800032e2 <namecmp>
    80004c56:	12050e63          	beqz	a0,80004d92 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c5a:	f2c40613          	addi	a2,s0,-212
    80004c5e:	fb040593          	addi	a1,s0,-80
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	698080e7          	jalr	1688(ra) # 800032fc <dirlookup>
    80004c6c:	892a                	mv	s2,a0
    80004c6e:	12050263          	beqz	a0,80004d92 <sys_unlink+0x1b0>
  ilock(ip);
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	192080e7          	jalr	402(ra) # 80002e04 <ilock>
  if(ip->nlink < 1)
    80004c7a:	05291783          	lh	a5,82(s2)
    80004c7e:	08f05263          	blez	a5,80004d02 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c82:	04c91703          	lh	a4,76(s2)
    80004c86:	4785                	li	a5,1
    80004c88:	08f70563          	beq	a4,a5,80004d12 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c8c:	4641                	li	a2,16
    80004c8e:	4581                	li	a1,0
    80004c90:	fc040513          	addi	a0,s0,-64
    80004c94:	ffffb097          	auipc	ra,0xffffb
    80004c98:	61a080e7          	jalr	1562(ra) # 800002ae <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c9c:	4741                	li	a4,16
    80004c9e:	f2c42683          	lw	a3,-212(s0)
    80004ca2:	fc040613          	addi	a2,s0,-64
    80004ca6:	4581                	li	a1,0
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	51a080e7          	jalr	1306(ra) # 800031c4 <writei>
    80004cb2:	47c1                	li	a5,16
    80004cb4:	0af51563          	bne	a0,a5,80004d5e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004cb8:	04c91703          	lh	a4,76(s2)
    80004cbc:	4785                	li	a5,1
    80004cbe:	0af70863          	beq	a4,a5,80004d6e <sys_unlink+0x18c>
  iunlockput(dp);
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	3b6080e7          	jalr	950(ra) # 8000307a <iunlockput>
  ip->nlink--;
    80004ccc:	05295783          	lhu	a5,82(s2)
    80004cd0:	37fd                	addiw	a5,a5,-1
    80004cd2:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004cd6:	854a                	mv	a0,s2
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	062080e7          	jalr	98(ra) # 80002d3a <iupdate>
  iunlockput(ip);
    80004ce0:	854a                	mv	a0,s2
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	398080e7          	jalr	920(ra) # 8000307a <iunlockput>
  end_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	b70080e7          	jalr	-1168(ra) # 8000385a <end_op>
  return 0;
    80004cf2:	4501                	li	a0,0
    80004cf4:	a84d                	j	80004da6 <sys_unlink+0x1c4>
    end_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	b64080e7          	jalr	-1180(ra) # 8000385a <end_op>
    return -1;
    80004cfe:	557d                	li	a0,-1
    80004d00:	a05d                	j	80004da6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004d02:	00004517          	auipc	a0,0x4
    80004d06:	9c650513          	addi	a0,a0,-1594 # 800086c8 <syscalls+0x2b8>
    80004d0a:	00001097          	auipc	ra,0x1
    80004d0e:	588080e7          	jalr	1416(ra) # 80006292 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d12:	05492703          	lw	a4,84(s2)
    80004d16:	02000793          	li	a5,32
    80004d1a:	f6e7f9e3          	bgeu	a5,a4,80004c8c <sys_unlink+0xaa>
    80004d1e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d22:	4741                	li	a4,16
    80004d24:	86ce                	mv	a3,s3
    80004d26:	f1840613          	addi	a2,s0,-232
    80004d2a:	4581                	li	a1,0
    80004d2c:	854a                	mv	a0,s2
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	39e080e7          	jalr	926(ra) # 800030cc <readi>
    80004d36:	47c1                	li	a5,16
    80004d38:	00f51b63          	bne	a0,a5,80004d4e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d3c:	f1845783          	lhu	a5,-232(s0)
    80004d40:	e7a1                	bnez	a5,80004d88 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d42:	29c1                	addiw	s3,s3,16
    80004d44:	05492783          	lw	a5,84(s2)
    80004d48:	fcf9ede3          	bltu	s3,a5,80004d22 <sys_unlink+0x140>
    80004d4c:	b781                	j	80004c8c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d4e:	00004517          	auipc	a0,0x4
    80004d52:	99250513          	addi	a0,a0,-1646 # 800086e0 <syscalls+0x2d0>
    80004d56:	00001097          	auipc	ra,0x1
    80004d5a:	53c080e7          	jalr	1340(ra) # 80006292 <panic>
    panic("unlink: writei");
    80004d5e:	00004517          	auipc	a0,0x4
    80004d62:	99a50513          	addi	a0,a0,-1638 # 800086f8 <syscalls+0x2e8>
    80004d66:	00001097          	auipc	ra,0x1
    80004d6a:	52c080e7          	jalr	1324(ra) # 80006292 <panic>
    dp->nlink--;
    80004d6e:	0524d783          	lhu	a5,82(s1)
    80004d72:	37fd                	addiw	a5,a5,-1
    80004d74:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004d78:	8526                	mv	a0,s1
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	fc0080e7          	jalr	-64(ra) # 80002d3a <iupdate>
    80004d82:	b781                	j	80004cc2 <sys_unlink+0xe0>
    return -1;
    80004d84:	557d                	li	a0,-1
    80004d86:	a005                	j	80004da6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d88:	854a                	mv	a0,s2
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	2f0080e7          	jalr	752(ra) # 8000307a <iunlockput>
  iunlockput(dp);
    80004d92:	8526                	mv	a0,s1
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	2e6080e7          	jalr	742(ra) # 8000307a <iunlockput>
  end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	abe080e7          	jalr	-1346(ra) # 8000385a <end_op>
  return -1;
    80004da4:	557d                	li	a0,-1
}
    80004da6:	70ae                	ld	ra,232(sp)
    80004da8:	740e                	ld	s0,224(sp)
    80004daa:	64ee                	ld	s1,216(sp)
    80004dac:	694e                	ld	s2,208(sp)
    80004dae:	69ae                	ld	s3,200(sp)
    80004db0:	616d                	addi	sp,sp,240
    80004db2:	8082                	ret

0000000080004db4 <sys_open>:

uint64
sys_open(void)
{
    80004db4:	7131                	addi	sp,sp,-192
    80004db6:	fd06                	sd	ra,184(sp)
    80004db8:	f922                	sd	s0,176(sp)
    80004dba:	f526                	sd	s1,168(sp)
    80004dbc:	f14a                	sd	s2,160(sp)
    80004dbe:	ed4e                	sd	s3,152(sp)
    80004dc0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004dc2:	f4c40593          	addi	a1,s0,-180
    80004dc6:	4505                	li	a0,1
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	342080e7          	jalr	834(ra) # 8000210a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dd0:	08000613          	li	a2,128
    80004dd4:	f5040593          	addi	a1,s0,-176
    80004dd8:	4501                	li	a0,0
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	370080e7          	jalr	880(ra) # 8000214a <argstr>
    80004de2:	87aa                	mv	a5,a0
    return -1;
    80004de4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004de6:	0a07c963          	bltz	a5,80004e98 <sys_open+0xe4>

  begin_op();
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	9f0080e7          	jalr	-1552(ra) # 800037da <begin_op>

  if(omode & O_CREATE){
    80004df2:	f4c42783          	lw	a5,-180(s0)
    80004df6:	2007f793          	andi	a5,a5,512
    80004dfa:	cfc5                	beqz	a5,80004eb2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004dfc:	4681                	li	a3,0
    80004dfe:	4601                	li	a2,0
    80004e00:	4589                	li	a1,2
    80004e02:	f5040513          	addi	a0,s0,-176
    80004e06:	00000097          	auipc	ra,0x0
    80004e0a:	974080e7          	jalr	-1676(ra) # 8000477a <create>
    80004e0e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004e10:	c959                	beqz	a0,80004ea6 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e12:	04c49703          	lh	a4,76(s1)
    80004e16:	478d                	li	a5,3
    80004e18:	00f71763          	bne	a4,a5,80004e26 <sys_open+0x72>
    80004e1c:	04e4d703          	lhu	a4,78(s1)
    80004e20:	47a5                	li	a5,9
    80004e22:	0ce7ed63          	bltu	a5,a4,80004efc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	dc4080e7          	jalr	-572(ra) # 80003bea <filealloc>
    80004e2e:	89aa                	mv	s3,a0
    80004e30:	10050363          	beqz	a0,80004f36 <sys_open+0x182>
    80004e34:	00000097          	auipc	ra,0x0
    80004e38:	904080e7          	jalr	-1788(ra) # 80004738 <fdalloc>
    80004e3c:	892a                	mv	s2,a0
    80004e3e:	0e054763          	bltz	a0,80004f2c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e42:	04c49703          	lh	a4,76(s1)
    80004e46:	478d                	li	a5,3
    80004e48:	0cf70563          	beq	a4,a5,80004f12 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e4c:	4789                	li	a5,2
    80004e4e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e52:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e56:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e5a:	f4c42783          	lw	a5,-180(s0)
    80004e5e:	0017c713          	xori	a4,a5,1
    80004e62:	8b05                	andi	a4,a4,1
    80004e64:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e68:	0037f713          	andi	a4,a5,3
    80004e6c:	00e03733          	snez	a4,a4
    80004e70:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e74:	4007f793          	andi	a5,a5,1024
    80004e78:	c791                	beqz	a5,80004e84 <sys_open+0xd0>
    80004e7a:	04c49703          	lh	a4,76(s1)
    80004e7e:	4789                	li	a5,2
    80004e80:	0af70063          	beq	a4,a5,80004f20 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e84:	8526                	mv	a0,s1
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	04a080e7          	jalr	74(ra) # 80002ed0 <iunlock>
  end_op();
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	9cc080e7          	jalr	-1588(ra) # 8000385a <end_op>

  return fd;
    80004e96:	854a                	mv	a0,s2
}
    80004e98:	70ea                	ld	ra,184(sp)
    80004e9a:	744a                	ld	s0,176(sp)
    80004e9c:	74aa                	ld	s1,168(sp)
    80004e9e:	790a                	ld	s2,160(sp)
    80004ea0:	69ea                	ld	s3,152(sp)
    80004ea2:	6129                	addi	sp,sp,192
    80004ea4:	8082                	ret
      end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	9b4080e7          	jalr	-1612(ra) # 8000385a <end_op>
      return -1;
    80004eae:	557d                	li	a0,-1
    80004eb0:	b7e5                	j	80004e98 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004eb2:	f5040513          	addi	a0,s0,-176
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	708080e7          	jalr	1800(ra) # 800035be <namei>
    80004ebe:	84aa                	mv	s1,a0
    80004ec0:	c905                	beqz	a0,80004ef0 <sys_open+0x13c>
    ilock(ip);
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	f42080e7          	jalr	-190(ra) # 80002e04 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004eca:	04c49703          	lh	a4,76(s1)
    80004ece:	4785                	li	a5,1
    80004ed0:	f4f711e3          	bne	a4,a5,80004e12 <sys_open+0x5e>
    80004ed4:	f4c42783          	lw	a5,-180(s0)
    80004ed8:	d7b9                	beqz	a5,80004e26 <sys_open+0x72>
      iunlockput(ip);
    80004eda:	8526                	mv	a0,s1
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	19e080e7          	jalr	414(ra) # 8000307a <iunlockput>
      end_op();
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	976080e7          	jalr	-1674(ra) # 8000385a <end_op>
      return -1;
    80004eec:	557d                	li	a0,-1
    80004eee:	b76d                	j	80004e98 <sys_open+0xe4>
      end_op();
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	96a080e7          	jalr	-1686(ra) # 8000385a <end_op>
      return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	bf79                	j	80004e98 <sys_open+0xe4>
    iunlockput(ip);
    80004efc:	8526                	mv	a0,s1
    80004efe:	ffffe097          	auipc	ra,0xffffe
    80004f02:	17c080e7          	jalr	380(ra) # 8000307a <iunlockput>
    end_op();
    80004f06:	fffff097          	auipc	ra,0xfffff
    80004f0a:	954080e7          	jalr	-1708(ra) # 8000385a <end_op>
    return -1;
    80004f0e:	557d                	li	a0,-1
    80004f10:	b761                	j	80004e98 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f12:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f16:	04e49783          	lh	a5,78(s1)
    80004f1a:	02f99223          	sh	a5,36(s3)
    80004f1e:	bf25                	j	80004e56 <sys_open+0xa2>
    itrunc(ip);
    80004f20:	8526                	mv	a0,s1
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	004080e7          	jalr	4(ra) # 80002f26 <itrunc>
    80004f2a:	bfa9                	j	80004e84 <sys_open+0xd0>
      fileclose(f);
    80004f2c:	854e                	mv	a0,s3
    80004f2e:	fffff097          	auipc	ra,0xfffff
    80004f32:	d78080e7          	jalr	-648(ra) # 80003ca6 <fileclose>
    iunlockput(ip);
    80004f36:	8526                	mv	a0,s1
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	142080e7          	jalr	322(ra) # 8000307a <iunlockput>
    end_op();
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	91a080e7          	jalr	-1766(ra) # 8000385a <end_op>
    return -1;
    80004f48:	557d                	li	a0,-1
    80004f4a:	b7b9                	j	80004e98 <sys_open+0xe4>

0000000080004f4c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f4c:	7175                	addi	sp,sp,-144
    80004f4e:	e506                	sd	ra,136(sp)
    80004f50:	e122                	sd	s0,128(sp)
    80004f52:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	886080e7          	jalr	-1914(ra) # 800037da <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f5c:	08000613          	li	a2,128
    80004f60:	f7040593          	addi	a1,s0,-144
    80004f64:	4501                	li	a0,0
    80004f66:	ffffd097          	auipc	ra,0xffffd
    80004f6a:	1e4080e7          	jalr	484(ra) # 8000214a <argstr>
    80004f6e:	02054963          	bltz	a0,80004fa0 <sys_mkdir+0x54>
    80004f72:	4681                	li	a3,0
    80004f74:	4601                	li	a2,0
    80004f76:	4585                	li	a1,1
    80004f78:	f7040513          	addi	a0,s0,-144
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	7fe080e7          	jalr	2046(ra) # 8000477a <create>
    80004f84:	cd11                	beqz	a0,80004fa0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	0f4080e7          	jalr	244(ra) # 8000307a <iunlockput>
  end_op();
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	8cc080e7          	jalr	-1844(ra) # 8000385a <end_op>
  return 0;
    80004f96:	4501                	li	a0,0
}
    80004f98:	60aa                	ld	ra,136(sp)
    80004f9a:	640a                	ld	s0,128(sp)
    80004f9c:	6149                	addi	sp,sp,144
    80004f9e:	8082                	ret
    end_op();
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	8ba080e7          	jalr	-1862(ra) # 8000385a <end_op>
    return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	b7fd                	j	80004f98 <sys_mkdir+0x4c>

0000000080004fac <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fac:	7135                	addi	sp,sp,-160
    80004fae:	ed06                	sd	ra,152(sp)
    80004fb0:	e922                	sd	s0,144(sp)
    80004fb2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	826080e7          	jalr	-2010(ra) # 800037da <begin_op>
  argint(1, &major);
    80004fbc:	f6c40593          	addi	a1,s0,-148
    80004fc0:	4505                	li	a0,1
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	148080e7          	jalr	328(ra) # 8000210a <argint>
  argint(2, &minor);
    80004fca:	f6840593          	addi	a1,s0,-152
    80004fce:	4509                	li	a0,2
    80004fd0:	ffffd097          	auipc	ra,0xffffd
    80004fd4:	13a080e7          	jalr	314(ra) # 8000210a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fd8:	08000613          	li	a2,128
    80004fdc:	f7040593          	addi	a1,s0,-144
    80004fe0:	4501                	li	a0,0
    80004fe2:	ffffd097          	auipc	ra,0xffffd
    80004fe6:	168080e7          	jalr	360(ra) # 8000214a <argstr>
    80004fea:	02054b63          	bltz	a0,80005020 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fee:	f6841683          	lh	a3,-152(s0)
    80004ff2:	f6c41603          	lh	a2,-148(s0)
    80004ff6:	458d                	li	a1,3
    80004ff8:	f7040513          	addi	a0,s0,-144
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	77e080e7          	jalr	1918(ra) # 8000477a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005004:	cd11                	beqz	a0,80005020 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	074080e7          	jalr	116(ra) # 8000307a <iunlockput>
  end_op();
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	84c080e7          	jalr	-1972(ra) # 8000385a <end_op>
  return 0;
    80005016:	4501                	li	a0,0
}
    80005018:	60ea                	ld	ra,152(sp)
    8000501a:	644a                	ld	s0,144(sp)
    8000501c:	610d                	addi	sp,sp,160
    8000501e:	8082                	ret
    end_op();
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	83a080e7          	jalr	-1990(ra) # 8000385a <end_op>
    return -1;
    80005028:	557d                	li	a0,-1
    8000502a:	b7fd                	j	80005018 <sys_mknod+0x6c>

000000008000502c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000502c:	7135                	addi	sp,sp,-160
    8000502e:	ed06                	sd	ra,152(sp)
    80005030:	e922                	sd	s0,144(sp)
    80005032:	e526                	sd	s1,136(sp)
    80005034:	e14a                	sd	s2,128(sp)
    80005036:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005038:	ffffc097          	auipc	ra,0xffffc
    8000503c:	fbe080e7          	jalr	-66(ra) # 80000ff6 <myproc>
    80005040:	892a                	mv	s2,a0
  
  begin_op();
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	798080e7          	jalr	1944(ra) # 800037da <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000504a:	08000613          	li	a2,128
    8000504e:	f6040593          	addi	a1,s0,-160
    80005052:	4501                	li	a0,0
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	0f6080e7          	jalr	246(ra) # 8000214a <argstr>
    8000505c:	04054b63          	bltz	a0,800050b2 <sys_chdir+0x86>
    80005060:	f6040513          	addi	a0,s0,-160
    80005064:	ffffe097          	auipc	ra,0xffffe
    80005068:	55a080e7          	jalr	1370(ra) # 800035be <namei>
    8000506c:	84aa                	mv	s1,a0
    8000506e:	c131                	beqz	a0,800050b2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005070:	ffffe097          	auipc	ra,0xffffe
    80005074:	d94080e7          	jalr	-620(ra) # 80002e04 <ilock>
  if(ip->type != T_DIR){
    80005078:	04c49703          	lh	a4,76(s1)
    8000507c:	4785                	li	a5,1
    8000507e:	04f71063          	bne	a4,a5,800050be <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005082:	8526                	mv	a0,s1
    80005084:	ffffe097          	auipc	ra,0xffffe
    80005088:	e4c080e7          	jalr	-436(ra) # 80002ed0 <iunlock>
  iput(p->cwd);
    8000508c:	15893503          	ld	a0,344(s2)
    80005090:	ffffe097          	auipc	ra,0xffffe
    80005094:	f42080e7          	jalr	-190(ra) # 80002fd2 <iput>
  end_op();
    80005098:	ffffe097          	auipc	ra,0xffffe
    8000509c:	7c2080e7          	jalr	1986(ra) # 8000385a <end_op>
  p->cwd = ip;
    800050a0:	14993c23          	sd	s1,344(s2)
  return 0;
    800050a4:	4501                	li	a0,0
}
    800050a6:	60ea                	ld	ra,152(sp)
    800050a8:	644a                	ld	s0,144(sp)
    800050aa:	64aa                	ld	s1,136(sp)
    800050ac:	690a                	ld	s2,128(sp)
    800050ae:	610d                	addi	sp,sp,160
    800050b0:	8082                	ret
    end_op();
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	7a8080e7          	jalr	1960(ra) # 8000385a <end_op>
    return -1;
    800050ba:	557d                	li	a0,-1
    800050bc:	b7ed                	j	800050a6 <sys_chdir+0x7a>
    iunlockput(ip);
    800050be:	8526                	mv	a0,s1
    800050c0:	ffffe097          	auipc	ra,0xffffe
    800050c4:	fba080e7          	jalr	-70(ra) # 8000307a <iunlockput>
    end_op();
    800050c8:	ffffe097          	auipc	ra,0xffffe
    800050cc:	792080e7          	jalr	1938(ra) # 8000385a <end_op>
    return -1;
    800050d0:	557d                	li	a0,-1
    800050d2:	bfd1                	j	800050a6 <sys_chdir+0x7a>

00000000800050d4 <sys_exec>:

uint64
sys_exec(void)
{
    800050d4:	7145                	addi	sp,sp,-464
    800050d6:	e786                	sd	ra,456(sp)
    800050d8:	e3a2                	sd	s0,448(sp)
    800050da:	ff26                	sd	s1,440(sp)
    800050dc:	fb4a                	sd	s2,432(sp)
    800050de:	f74e                	sd	s3,424(sp)
    800050e0:	f352                	sd	s4,416(sp)
    800050e2:	ef56                	sd	s5,408(sp)
    800050e4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050e6:	e3840593          	addi	a1,s0,-456
    800050ea:	4505                	li	a0,1
    800050ec:	ffffd097          	auipc	ra,0xffffd
    800050f0:	03e080e7          	jalr	62(ra) # 8000212a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800050f4:	08000613          	li	a2,128
    800050f8:	f4040593          	addi	a1,s0,-192
    800050fc:	4501                	li	a0,0
    800050fe:	ffffd097          	auipc	ra,0xffffd
    80005102:	04c080e7          	jalr	76(ra) # 8000214a <argstr>
    80005106:	87aa                	mv	a5,a0
    return -1;
    80005108:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000510a:	0c07c263          	bltz	a5,800051ce <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000510e:	10000613          	li	a2,256
    80005112:	4581                	li	a1,0
    80005114:	e4040513          	addi	a0,s0,-448
    80005118:	ffffb097          	auipc	ra,0xffffb
    8000511c:	196080e7          	jalr	406(ra) # 800002ae <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005120:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005124:	89a6                	mv	s3,s1
    80005126:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005128:	02000a13          	li	s4,32
    8000512c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005130:	00391513          	slli	a0,s2,0x3
    80005134:	e3040593          	addi	a1,s0,-464
    80005138:	e3843783          	ld	a5,-456(s0)
    8000513c:	953e                	add	a0,a0,a5
    8000513e:	ffffd097          	auipc	ra,0xffffd
    80005142:	f2e080e7          	jalr	-210(ra) # 8000206c <fetchaddr>
    80005146:	02054a63          	bltz	a0,8000517a <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    8000514a:	e3043783          	ld	a5,-464(s0)
    8000514e:	c3b9                	beqz	a5,80005194 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005150:	ffffb097          	auipc	ra,0xffffb
    80005154:	01a080e7          	jalr	26(ra) # 8000016a <kalloc>
    80005158:	85aa                	mv	a1,a0
    8000515a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000515e:	cd11                	beqz	a0,8000517a <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005160:	6605                	lui	a2,0x1
    80005162:	e3043503          	ld	a0,-464(s0)
    80005166:	ffffd097          	auipc	ra,0xffffd
    8000516a:	f58080e7          	jalr	-168(ra) # 800020be <fetchstr>
    8000516e:	00054663          	bltz	a0,8000517a <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005172:	0905                	addi	s2,s2,1
    80005174:	09a1                	addi	s3,s3,8
    80005176:	fb491be3          	bne	s2,s4,8000512c <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000517a:	10048913          	addi	s2,s1,256
    8000517e:	6088                	ld	a0,0(s1)
    80005180:	c531                	beqz	a0,800051cc <sys_exec+0xf8>
    kfree(argv[i]);
    80005182:	ffffb097          	auipc	ra,0xffffb
    80005186:	e9a080e7          	jalr	-358(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000518a:	04a1                	addi	s1,s1,8
    8000518c:	ff2499e3          	bne	s1,s2,8000517e <sys_exec+0xaa>
  return -1;
    80005190:	557d                	li	a0,-1
    80005192:	a835                	j	800051ce <sys_exec+0xfa>
      argv[i] = 0;
    80005194:	0a8e                	slli	s5,s5,0x3
    80005196:	fc040793          	addi	a5,s0,-64
    8000519a:	9abe                	add	s5,s5,a5
    8000519c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800051a0:	e4040593          	addi	a1,s0,-448
    800051a4:	f4040513          	addi	a0,s0,-192
    800051a8:	fffff097          	auipc	ra,0xfffff
    800051ac:	190080e7          	jalr	400(ra) # 80004338 <exec>
    800051b0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b2:	10048993          	addi	s3,s1,256
    800051b6:	6088                	ld	a0,0(s1)
    800051b8:	c901                	beqz	a0,800051c8 <sys_exec+0xf4>
    kfree(argv[i]);
    800051ba:	ffffb097          	auipc	ra,0xffffb
    800051be:	e62080e7          	jalr	-414(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051c2:	04a1                	addi	s1,s1,8
    800051c4:	ff3499e3          	bne	s1,s3,800051b6 <sys_exec+0xe2>
  return ret;
    800051c8:	854a                	mv	a0,s2
    800051ca:	a011                	j	800051ce <sys_exec+0xfa>
  return -1;
    800051cc:	557d                	li	a0,-1
}
    800051ce:	60be                	ld	ra,456(sp)
    800051d0:	641e                	ld	s0,448(sp)
    800051d2:	74fa                	ld	s1,440(sp)
    800051d4:	795a                	ld	s2,432(sp)
    800051d6:	79ba                	ld	s3,424(sp)
    800051d8:	7a1a                	ld	s4,416(sp)
    800051da:	6afa                	ld	s5,408(sp)
    800051dc:	6179                	addi	sp,sp,464
    800051de:	8082                	ret

00000000800051e0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051e0:	7139                	addi	sp,sp,-64
    800051e2:	fc06                	sd	ra,56(sp)
    800051e4:	f822                	sd	s0,48(sp)
    800051e6:	f426                	sd	s1,40(sp)
    800051e8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	e0c080e7          	jalr	-500(ra) # 80000ff6 <myproc>
    800051f2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051f4:	fd840593          	addi	a1,s0,-40
    800051f8:	4501                	li	a0,0
    800051fa:	ffffd097          	auipc	ra,0xffffd
    800051fe:	f30080e7          	jalr	-208(ra) # 8000212a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005202:	fc840593          	addi	a1,s0,-56
    80005206:	fd040513          	addi	a0,s0,-48
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	dcc080e7          	jalr	-564(ra) # 80003fd6 <pipealloc>
    return -1;
    80005212:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005214:	0c054463          	bltz	a0,800052dc <sys_pipe+0xfc>
  fd0 = -1;
    80005218:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000521c:	fd043503          	ld	a0,-48(s0)
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	518080e7          	jalr	1304(ra) # 80004738 <fdalloc>
    80005228:	fca42223          	sw	a0,-60(s0)
    8000522c:	08054b63          	bltz	a0,800052c2 <sys_pipe+0xe2>
    80005230:	fc843503          	ld	a0,-56(s0)
    80005234:	fffff097          	auipc	ra,0xfffff
    80005238:	504080e7          	jalr	1284(ra) # 80004738 <fdalloc>
    8000523c:	fca42023          	sw	a0,-64(s0)
    80005240:	06054863          	bltz	a0,800052b0 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005244:	4691                	li	a3,4
    80005246:	fc440613          	addi	a2,s0,-60
    8000524a:	fd843583          	ld	a1,-40(s0)
    8000524e:	6ca8                	ld	a0,88(s1)
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	a30080e7          	jalr	-1488(ra) # 80000c80 <copyout>
    80005258:	02054063          	bltz	a0,80005278 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000525c:	4691                	li	a3,4
    8000525e:	fc040613          	addi	a2,s0,-64
    80005262:	fd843583          	ld	a1,-40(s0)
    80005266:	0591                	addi	a1,a1,4
    80005268:	6ca8                	ld	a0,88(s1)
    8000526a:	ffffc097          	auipc	ra,0xffffc
    8000526e:	a16080e7          	jalr	-1514(ra) # 80000c80 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005272:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005274:	06055463          	bgez	a0,800052dc <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005278:	fc442783          	lw	a5,-60(s0)
    8000527c:	07e9                	addi	a5,a5,26
    8000527e:	078e                	slli	a5,a5,0x3
    80005280:	97a6                	add	a5,a5,s1
    80005282:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005286:	fc042503          	lw	a0,-64(s0)
    8000528a:	0569                	addi	a0,a0,26
    8000528c:	050e                	slli	a0,a0,0x3
    8000528e:	94aa                	add	s1,s1,a0
    80005290:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005294:	fd043503          	ld	a0,-48(s0)
    80005298:	fffff097          	auipc	ra,0xfffff
    8000529c:	a0e080e7          	jalr	-1522(ra) # 80003ca6 <fileclose>
    fileclose(wf);
    800052a0:	fc843503          	ld	a0,-56(s0)
    800052a4:	fffff097          	auipc	ra,0xfffff
    800052a8:	a02080e7          	jalr	-1534(ra) # 80003ca6 <fileclose>
    return -1;
    800052ac:	57fd                	li	a5,-1
    800052ae:	a03d                	j	800052dc <sys_pipe+0xfc>
    if(fd0 >= 0)
    800052b0:	fc442783          	lw	a5,-60(s0)
    800052b4:	0007c763          	bltz	a5,800052c2 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800052b8:	07e9                	addi	a5,a5,26
    800052ba:	078e                	slli	a5,a5,0x3
    800052bc:	94be                	add	s1,s1,a5
    800052be:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800052c2:	fd043503          	ld	a0,-48(s0)
    800052c6:	fffff097          	auipc	ra,0xfffff
    800052ca:	9e0080e7          	jalr	-1568(ra) # 80003ca6 <fileclose>
    fileclose(wf);
    800052ce:	fc843503          	ld	a0,-56(s0)
    800052d2:	fffff097          	auipc	ra,0xfffff
    800052d6:	9d4080e7          	jalr	-1580(ra) # 80003ca6 <fileclose>
    return -1;
    800052da:	57fd                	li	a5,-1
}
    800052dc:	853e                	mv	a0,a5
    800052de:	70e2                	ld	ra,56(sp)
    800052e0:	7442                	ld	s0,48(sp)
    800052e2:	74a2                	ld	s1,40(sp)
    800052e4:	6121                	addi	sp,sp,64
    800052e6:	8082                	ret
	...

00000000800052f0 <kernelvec>:
    800052f0:	7111                	addi	sp,sp,-256
    800052f2:	e006                	sd	ra,0(sp)
    800052f4:	e40a                	sd	sp,8(sp)
    800052f6:	e80e                	sd	gp,16(sp)
    800052f8:	ec12                	sd	tp,24(sp)
    800052fa:	f016                	sd	t0,32(sp)
    800052fc:	f41a                	sd	t1,40(sp)
    800052fe:	f81e                	sd	t2,48(sp)
    80005300:	fc22                	sd	s0,56(sp)
    80005302:	e0a6                	sd	s1,64(sp)
    80005304:	e4aa                	sd	a0,72(sp)
    80005306:	e8ae                	sd	a1,80(sp)
    80005308:	ecb2                	sd	a2,88(sp)
    8000530a:	f0b6                	sd	a3,96(sp)
    8000530c:	f4ba                	sd	a4,104(sp)
    8000530e:	f8be                	sd	a5,112(sp)
    80005310:	fcc2                	sd	a6,120(sp)
    80005312:	e146                	sd	a7,128(sp)
    80005314:	e54a                	sd	s2,136(sp)
    80005316:	e94e                	sd	s3,144(sp)
    80005318:	ed52                	sd	s4,152(sp)
    8000531a:	f156                	sd	s5,160(sp)
    8000531c:	f55a                	sd	s6,168(sp)
    8000531e:	f95e                	sd	s7,176(sp)
    80005320:	fd62                	sd	s8,184(sp)
    80005322:	e1e6                	sd	s9,192(sp)
    80005324:	e5ea                	sd	s10,200(sp)
    80005326:	e9ee                	sd	s11,208(sp)
    80005328:	edf2                	sd	t3,216(sp)
    8000532a:	f1f6                	sd	t4,224(sp)
    8000532c:	f5fa                	sd	t5,232(sp)
    8000532e:	f9fe                	sd	t6,240(sp)
    80005330:	c09fc0ef          	jal	ra,80001f38 <kerneltrap>
    80005334:	6082                	ld	ra,0(sp)
    80005336:	6122                	ld	sp,8(sp)
    80005338:	61c2                	ld	gp,16(sp)
    8000533a:	7282                	ld	t0,32(sp)
    8000533c:	7322                	ld	t1,40(sp)
    8000533e:	73c2                	ld	t2,48(sp)
    80005340:	7462                	ld	s0,56(sp)
    80005342:	6486                	ld	s1,64(sp)
    80005344:	6526                	ld	a0,72(sp)
    80005346:	65c6                	ld	a1,80(sp)
    80005348:	6666                	ld	a2,88(sp)
    8000534a:	7686                	ld	a3,96(sp)
    8000534c:	7726                	ld	a4,104(sp)
    8000534e:	77c6                	ld	a5,112(sp)
    80005350:	7866                	ld	a6,120(sp)
    80005352:	688a                	ld	a7,128(sp)
    80005354:	692a                	ld	s2,136(sp)
    80005356:	69ca                	ld	s3,144(sp)
    80005358:	6a6a                	ld	s4,152(sp)
    8000535a:	7a8a                	ld	s5,160(sp)
    8000535c:	7b2a                	ld	s6,168(sp)
    8000535e:	7bca                	ld	s7,176(sp)
    80005360:	7c6a                	ld	s8,184(sp)
    80005362:	6c8e                	ld	s9,192(sp)
    80005364:	6d2e                	ld	s10,200(sp)
    80005366:	6dce                	ld	s11,208(sp)
    80005368:	6e6e                	ld	t3,216(sp)
    8000536a:	7e8e                	ld	t4,224(sp)
    8000536c:	7f2e                	ld	t5,232(sp)
    8000536e:	7fce                	ld	t6,240(sp)
    80005370:	6111                	addi	sp,sp,256
    80005372:	10200073          	sret
    80005376:	00000013          	nop
    8000537a:	00000013          	nop
    8000537e:	0001                	nop

0000000080005380 <timervec>:
    80005380:	34051573          	csrrw	a0,mscratch,a0
    80005384:	e10c                	sd	a1,0(a0)
    80005386:	e510                	sd	a2,8(a0)
    80005388:	e914                	sd	a3,16(a0)
    8000538a:	6d0c                	ld	a1,24(a0)
    8000538c:	7110                	ld	a2,32(a0)
    8000538e:	6194                	ld	a3,0(a1)
    80005390:	96b2                	add	a3,a3,a2
    80005392:	e194                	sd	a3,0(a1)
    80005394:	4589                	li	a1,2
    80005396:	14459073          	csrw	sip,a1
    8000539a:	6914                	ld	a3,16(a0)
    8000539c:	6510                	ld	a2,8(a0)
    8000539e:	610c                	ld	a1,0(a0)
    800053a0:	34051573          	csrrw	a0,mscratch,a0
    800053a4:	30200073          	mret
	...

00000000800053aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053aa:	1141                	addi	sp,sp,-16
    800053ac:	e422                	sd	s0,8(sp)
    800053ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053b0:	0c0007b7          	lui	a5,0xc000
    800053b4:	4705                	li	a4,1
    800053b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053b8:	c3d8                	sw	a4,4(a5)
}
    800053ba:	6422                	ld	s0,8(sp)
    800053bc:	0141                	addi	sp,sp,16
    800053be:	8082                	ret

00000000800053c0 <plicinithart>:

void
plicinithart(void)
{
    800053c0:	1141                	addi	sp,sp,-16
    800053c2:	e406                	sd	ra,8(sp)
    800053c4:	e022                	sd	s0,0(sp)
    800053c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	c02080e7          	jalr	-1022(ra) # 80000fca <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053d0:	0085171b          	slliw	a4,a0,0x8
    800053d4:	0c0027b7          	lui	a5,0xc002
    800053d8:	97ba                	add	a5,a5,a4
    800053da:	40200713          	li	a4,1026
    800053de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053e2:	00d5151b          	slliw	a0,a0,0xd
    800053e6:	0c2017b7          	lui	a5,0xc201
    800053ea:	953e                	add	a0,a0,a5
    800053ec:	00052023          	sw	zero,0(a0)
}
    800053f0:	60a2                	ld	ra,8(sp)
    800053f2:	6402                	ld	s0,0(sp)
    800053f4:	0141                	addi	sp,sp,16
    800053f6:	8082                	ret

00000000800053f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053f8:	1141                	addi	sp,sp,-16
    800053fa:	e406                	sd	ra,8(sp)
    800053fc:	e022                	sd	s0,0(sp)
    800053fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005400:	ffffc097          	auipc	ra,0xffffc
    80005404:	bca080e7          	jalr	-1078(ra) # 80000fca <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005408:	00d5179b          	slliw	a5,a0,0xd
    8000540c:	0c201537          	lui	a0,0xc201
    80005410:	953e                	add	a0,a0,a5
  return irq;
}
    80005412:	4148                	lw	a0,4(a0)
    80005414:	60a2                	ld	ra,8(sp)
    80005416:	6402                	ld	s0,0(sp)
    80005418:	0141                	addi	sp,sp,16
    8000541a:	8082                	ret

000000008000541c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000541c:	1101                	addi	sp,sp,-32
    8000541e:	ec06                	sd	ra,24(sp)
    80005420:	e822                	sd	s0,16(sp)
    80005422:	e426                	sd	s1,8(sp)
    80005424:	1000                	addi	s0,sp,32
    80005426:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	ba2080e7          	jalr	-1118(ra) # 80000fca <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005430:	00d5151b          	slliw	a0,a0,0xd
    80005434:	0c2017b7          	lui	a5,0xc201
    80005438:	97aa                	add	a5,a5,a0
    8000543a:	c3c4                	sw	s1,4(a5)
}
    8000543c:	60e2                	ld	ra,24(sp)
    8000543e:	6442                	ld	s0,16(sp)
    80005440:	64a2                	ld	s1,8(sp)
    80005442:	6105                	addi	sp,sp,32
    80005444:	8082                	ret

0000000080005446 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005446:	1141                	addi	sp,sp,-16
    80005448:	e406                	sd	ra,8(sp)
    8000544a:	e022                	sd	s0,0(sp)
    8000544c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000544e:	479d                	li	a5,7
    80005450:	04a7cc63          	blt	a5,a0,800054a8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005454:	00018797          	auipc	a5,0x18
    80005458:	3e478793          	addi	a5,a5,996 # 8001d838 <disk>
    8000545c:	97aa                	add	a5,a5,a0
    8000545e:	0187c783          	lbu	a5,24(a5)
    80005462:	ebb9                	bnez	a5,800054b8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005464:	00451613          	slli	a2,a0,0x4
    80005468:	00018797          	auipc	a5,0x18
    8000546c:	3d078793          	addi	a5,a5,976 # 8001d838 <disk>
    80005470:	6394                	ld	a3,0(a5)
    80005472:	96b2                	add	a3,a3,a2
    80005474:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005478:	6398                	ld	a4,0(a5)
    8000547a:	9732                	add	a4,a4,a2
    8000547c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005480:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005484:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005488:	953e                	add	a0,a0,a5
    8000548a:	4785                	li	a5,1
    8000548c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005490:	00018517          	auipc	a0,0x18
    80005494:	3c050513          	addi	a0,a0,960 # 8001d850 <disk+0x18>
    80005498:	ffffc097          	auipc	ra,0xffffc
    8000549c:	26a080e7          	jalr	618(ra) # 80001702 <wakeup>
}
    800054a0:	60a2                	ld	ra,8(sp)
    800054a2:	6402                	ld	s0,0(sp)
    800054a4:	0141                	addi	sp,sp,16
    800054a6:	8082                	ret
    panic("free_desc 1");
    800054a8:	00003517          	auipc	a0,0x3
    800054ac:	26050513          	addi	a0,a0,608 # 80008708 <syscalls+0x2f8>
    800054b0:	00001097          	auipc	ra,0x1
    800054b4:	de2080e7          	jalr	-542(ra) # 80006292 <panic>
    panic("free_desc 2");
    800054b8:	00003517          	auipc	a0,0x3
    800054bc:	26050513          	addi	a0,a0,608 # 80008718 <syscalls+0x308>
    800054c0:	00001097          	auipc	ra,0x1
    800054c4:	dd2080e7          	jalr	-558(ra) # 80006292 <panic>

00000000800054c8 <virtio_disk_init>:
{
    800054c8:	1101                	addi	sp,sp,-32
    800054ca:	ec06                	sd	ra,24(sp)
    800054cc:	e822                	sd	s0,16(sp)
    800054ce:	e426                	sd	s1,8(sp)
    800054d0:	e04a                	sd	s2,0(sp)
    800054d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054d4:	00003597          	auipc	a1,0x3
    800054d8:	25458593          	addi	a1,a1,596 # 80008728 <syscalls+0x318>
    800054dc:	00018517          	auipc	a0,0x18
    800054e0:	48450513          	addi	a0,a0,1156 # 8001d960 <disk+0x128>
    800054e4:	00001097          	auipc	ra,0x1
    800054e8:	45e080e7          	jalr	1118(ra) # 80006942 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054ec:	100017b7          	lui	a5,0x10001
    800054f0:	4398                	lw	a4,0(a5)
    800054f2:	2701                	sext.w	a4,a4
    800054f4:	747277b7          	lui	a5,0x74727
    800054f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054fc:	14f71e63          	bne	a4,a5,80005658 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005500:	100017b7          	lui	a5,0x10001
    80005504:	43dc                	lw	a5,4(a5)
    80005506:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005508:	4709                	li	a4,2
    8000550a:	14e79763          	bne	a5,a4,80005658 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000550e:	100017b7          	lui	a5,0x10001
    80005512:	479c                	lw	a5,8(a5)
    80005514:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005516:	14e79163          	bne	a5,a4,80005658 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000551a:	100017b7          	lui	a5,0x10001
    8000551e:	47d8                	lw	a4,12(a5)
    80005520:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005522:	554d47b7          	lui	a5,0x554d4
    80005526:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000552a:	12f71763          	bne	a4,a5,80005658 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000552e:	100017b7          	lui	a5,0x10001
    80005532:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005536:	4705                	li	a4,1
    80005538:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000553a:	470d                	li	a4,3
    8000553c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000553e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005540:	c7ffe737          	lui	a4,0xc7ffe
    80005544:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd6aa7>
    80005548:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000554a:	2701                	sext.w	a4,a4
    8000554c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000554e:	472d                	li	a4,11
    80005550:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005552:	0707a903          	lw	s2,112(a5)
    80005556:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005558:	00897793          	andi	a5,s2,8
    8000555c:	10078663          	beqz	a5,80005668 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005560:	100017b7          	lui	a5,0x10001
    80005564:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005568:	43fc                	lw	a5,68(a5)
    8000556a:	2781                	sext.w	a5,a5
    8000556c:	10079663          	bnez	a5,80005678 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005570:	100017b7          	lui	a5,0x10001
    80005574:	5bdc                	lw	a5,52(a5)
    80005576:	2781                	sext.w	a5,a5
  if(max == 0)
    80005578:	10078863          	beqz	a5,80005688 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000557c:	471d                	li	a4,7
    8000557e:	10f77d63          	bgeu	a4,a5,80005698 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005582:	ffffb097          	auipc	ra,0xffffb
    80005586:	be8080e7          	jalr	-1048(ra) # 8000016a <kalloc>
    8000558a:	00018497          	auipc	s1,0x18
    8000558e:	2ae48493          	addi	s1,s1,686 # 8001d838 <disk>
    80005592:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005594:	ffffb097          	auipc	ra,0xffffb
    80005598:	bd6080e7          	jalr	-1066(ra) # 8000016a <kalloc>
    8000559c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000559e:	ffffb097          	auipc	ra,0xffffb
    800055a2:	bcc080e7          	jalr	-1076(ra) # 8000016a <kalloc>
    800055a6:	87aa                	mv	a5,a0
    800055a8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800055aa:	6088                	ld	a0,0(s1)
    800055ac:	cd75                	beqz	a0,800056a8 <virtio_disk_init+0x1e0>
    800055ae:	00018717          	auipc	a4,0x18
    800055b2:	29273703          	ld	a4,658(a4) # 8001d840 <disk+0x8>
    800055b6:	cb6d                	beqz	a4,800056a8 <virtio_disk_init+0x1e0>
    800055b8:	cbe5                	beqz	a5,800056a8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800055ba:	6605                	lui	a2,0x1
    800055bc:	4581                	li	a1,0
    800055be:	ffffb097          	auipc	ra,0xffffb
    800055c2:	cf0080e7          	jalr	-784(ra) # 800002ae <memset>
  memset(disk.avail, 0, PGSIZE);
    800055c6:	00018497          	auipc	s1,0x18
    800055ca:	27248493          	addi	s1,s1,626 # 8001d838 <disk>
    800055ce:	6605                	lui	a2,0x1
    800055d0:	4581                	li	a1,0
    800055d2:	6488                	ld	a0,8(s1)
    800055d4:	ffffb097          	auipc	ra,0xffffb
    800055d8:	cda080e7          	jalr	-806(ra) # 800002ae <memset>
  memset(disk.used, 0, PGSIZE);
    800055dc:	6605                	lui	a2,0x1
    800055de:	4581                	li	a1,0
    800055e0:	6888                	ld	a0,16(s1)
    800055e2:	ffffb097          	auipc	ra,0xffffb
    800055e6:	ccc080e7          	jalr	-820(ra) # 800002ae <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ea:	100017b7          	lui	a5,0x10001
    800055ee:	4721                	li	a4,8
    800055f0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055f2:	4098                	lw	a4,0(s1)
    800055f4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055f8:	40d8                	lw	a4,4(s1)
    800055fa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055fe:	6498                	ld	a4,8(s1)
    80005600:	0007069b          	sext.w	a3,a4
    80005604:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005608:	9701                	srai	a4,a4,0x20
    8000560a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000560e:	6898                	ld	a4,16(s1)
    80005610:	0007069b          	sext.w	a3,a4
    80005614:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005618:	9701                	srai	a4,a4,0x20
    8000561a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000561e:	4685                	li	a3,1
    80005620:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005622:	4705                	li	a4,1
    80005624:	00d48c23          	sb	a3,24(s1)
    80005628:	00e48ca3          	sb	a4,25(s1)
    8000562c:	00e48d23          	sb	a4,26(s1)
    80005630:	00e48da3          	sb	a4,27(s1)
    80005634:	00e48e23          	sb	a4,28(s1)
    80005638:	00e48ea3          	sb	a4,29(s1)
    8000563c:	00e48f23          	sb	a4,30(s1)
    80005640:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005644:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005648:	0727a823          	sw	s2,112(a5)
}
    8000564c:	60e2                	ld	ra,24(sp)
    8000564e:	6442                	ld	s0,16(sp)
    80005650:	64a2                	ld	s1,8(sp)
    80005652:	6902                	ld	s2,0(sp)
    80005654:	6105                	addi	sp,sp,32
    80005656:	8082                	ret
    panic("could not find virtio disk");
    80005658:	00003517          	auipc	a0,0x3
    8000565c:	0e050513          	addi	a0,a0,224 # 80008738 <syscalls+0x328>
    80005660:	00001097          	auipc	ra,0x1
    80005664:	c32080e7          	jalr	-974(ra) # 80006292 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005668:	00003517          	auipc	a0,0x3
    8000566c:	0f050513          	addi	a0,a0,240 # 80008758 <syscalls+0x348>
    80005670:	00001097          	auipc	ra,0x1
    80005674:	c22080e7          	jalr	-990(ra) # 80006292 <panic>
    panic("virtio disk should not be ready");
    80005678:	00003517          	auipc	a0,0x3
    8000567c:	10050513          	addi	a0,a0,256 # 80008778 <syscalls+0x368>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	c12080e7          	jalr	-1006(ra) # 80006292 <panic>
    panic("virtio disk has no queue 0");
    80005688:	00003517          	auipc	a0,0x3
    8000568c:	11050513          	addi	a0,a0,272 # 80008798 <syscalls+0x388>
    80005690:	00001097          	auipc	ra,0x1
    80005694:	c02080e7          	jalr	-1022(ra) # 80006292 <panic>
    panic("virtio disk max queue too short");
    80005698:	00003517          	auipc	a0,0x3
    8000569c:	12050513          	addi	a0,a0,288 # 800087b8 <syscalls+0x3a8>
    800056a0:	00001097          	auipc	ra,0x1
    800056a4:	bf2080e7          	jalr	-1038(ra) # 80006292 <panic>
    panic("virtio disk kalloc");
    800056a8:	00003517          	auipc	a0,0x3
    800056ac:	13050513          	addi	a0,a0,304 # 800087d8 <syscalls+0x3c8>
    800056b0:	00001097          	auipc	ra,0x1
    800056b4:	be2080e7          	jalr	-1054(ra) # 80006292 <panic>

00000000800056b8 <virtio_disk_rw>:
}
#endif

void
virtio_disk_rw(struct buf *b, int write)
{
    800056b8:	7159                	addi	sp,sp,-112
    800056ba:	f486                	sd	ra,104(sp)
    800056bc:	f0a2                	sd	s0,96(sp)
    800056be:	eca6                	sd	s1,88(sp)
    800056c0:	e8ca                	sd	s2,80(sp)
    800056c2:	e4ce                	sd	s3,72(sp)
    800056c4:	e0d2                	sd	s4,64(sp)
    800056c6:	fc56                	sd	s5,56(sp)
    800056c8:	f85a                	sd	s6,48(sp)
    800056ca:	f45e                	sd	s7,40(sp)
    800056cc:	f062                	sd	s8,32(sp)
    800056ce:	ec66                	sd	s9,24(sp)
    800056d0:	e86a                	sd	s10,16(sp)
    800056d2:	1880                	addi	s0,sp,112
    800056d4:	892a                	mv	s2,a0
    800056d6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056d8:	00c52c83          	lw	s9,12(a0)

  acquire(&disk.vdisk_lock);
    800056dc:	00018517          	auipc	a0,0x18
    800056e0:	28450513          	addi	a0,a0,644 # 8001d960 <disk+0x128>
    800056e4:	00001097          	auipc	ra,0x1
    800056e8:	0e2080e7          	jalr	226(ra) # 800067c6 <acquire>
  for(int i = 0; i < NBUF; i++){
    800056ec:	00018717          	auipc	a4,0x18
    800056f0:	29470713          	addi	a4,a4,660 # 8001d980 <xbufs>
    800056f4:	4781                	li	a5,0
    800056f6:	4679                	li	a2,30
    if(xbufs[i] == b){
    800056f8:	6314                	ld	a3,0(a4)
    800056fa:	02d90763          	beq	s2,a3,80005728 <virtio_disk_rw+0x70>
    if(xbufs[i] == 0){
    800056fe:	ce89                	beqz	a3,80005718 <virtio_disk_rw+0x60>
  for(int i = 0; i < NBUF; i++){
    80005700:	2785                	addiw	a5,a5,1
    80005702:	0721                	addi	a4,a4,8
    80005704:	fec79ae3          	bne	a5,a2,800056f8 <virtio_disk_rw+0x40>
  panic("more than NBUF bufs");
    80005708:	00003517          	auipc	a0,0x3
    8000570c:	0e850513          	addi	a0,a0,232 # 800087f0 <syscalls+0x3e0>
    80005710:	00001097          	auipc	ra,0x1
    80005714:	b82080e7          	jalr	-1150(ra) # 80006292 <panic>
      xbufs[i] = b;
    80005718:	078e                	slli	a5,a5,0x3
    8000571a:	00018717          	auipc	a4,0x18
    8000571e:	11e70713          	addi	a4,a4,286 # 8001d838 <disk>
    80005722:	97ba                	add	a5,a5,a4
    80005724:	1527b423          	sd	s2,328(a5)
  for(int i = 0; i < 3; i++){
    80005728:	4b81                	li	s7,0
  for(int i = 0; i < NUM; i++){
    8000572a:	4b21                	li	s6,8
      disk.free[i] = 0;
    8000572c:	00018a97          	auipc	s5,0x18
    80005730:	10ca8a93          	addi	s5,s5,268 # 8001d838 <disk>
  for(int i = 0; i < 3; i++){
    80005734:	4a0d                	li	s4,3
  for(int i = 0; i < NUM; i++){
    80005736:	89de                	mv	s3,s7
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005738:	00018c17          	auipc	s8,0x18
    8000573c:	228c0c13          	addi	s8,s8,552 # 8001d960 <disk+0x128>
    80005740:	a8b5                	j	800057bc <virtio_disk_rw+0x104>
      disk.free[i] = 0;
    80005742:	00fa8733          	add	a4,s5,a5
    80005746:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000574a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000574c:	0207c563          	bltz	a5,80005776 <virtio_disk_rw+0xbe>
  for(int i = 0; i < 3; i++){
    80005750:	2485                	addiw	s1,s1,1
    80005752:	0691                	addi	a3,a3,4
    80005754:	1f448f63          	beq	s1,s4,80005952 <virtio_disk_rw+0x29a>
    idx[i] = alloc_desc();
    80005758:	8636                	mv	a2,a3
  for(int i = 0; i < NUM; i++){
    8000575a:	00018717          	auipc	a4,0x18
    8000575e:	0de70713          	addi	a4,a4,222 # 8001d838 <disk>
    80005762:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005764:	01874583          	lbu	a1,24(a4)
    80005768:	fde9                	bnez	a1,80005742 <virtio_disk_rw+0x8a>
  for(int i = 0; i < NUM; i++){
    8000576a:	2785                	addiw	a5,a5,1
    8000576c:	0705                	addi	a4,a4,1
    8000576e:	ff679be3          	bne	a5,s6,80005764 <virtio_disk_rw+0xac>
    idx[i] = alloc_desc();
    80005772:	57fd                	li	a5,-1
    80005774:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005776:	02905a63          	blez	s1,800057aa <virtio_disk_rw+0xf2>
        free_desc(idx[j]);
    8000577a:	f9042503          	lw	a0,-112(s0)
    8000577e:	00000097          	auipc	ra,0x0
    80005782:	cc8080e7          	jalr	-824(ra) # 80005446 <free_desc>
      for(int j = 0; j < i; j++)
    80005786:	4785                	li	a5,1
    80005788:	0297d163          	bge	a5,s1,800057aa <virtio_disk_rw+0xf2>
        free_desc(idx[j]);
    8000578c:	f9442503          	lw	a0,-108(s0)
    80005790:	00000097          	auipc	ra,0x0
    80005794:	cb6080e7          	jalr	-842(ra) # 80005446 <free_desc>
      for(int j = 0; j < i; j++)
    80005798:	4789                	li	a5,2
    8000579a:	0097d863          	bge	a5,s1,800057aa <virtio_disk_rw+0xf2>
        free_desc(idx[j]);
    8000579e:	f9842503          	lw	a0,-104(s0)
    800057a2:	00000097          	auipc	ra,0x0
    800057a6:	ca4080e7          	jalr	-860(ra) # 80005446 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057aa:	85e2                	mv	a1,s8
    800057ac:	00018517          	auipc	a0,0x18
    800057b0:	0a450513          	addi	a0,a0,164 # 8001d850 <disk+0x18>
    800057b4:	ffffc097          	auipc	ra,0xffffc
    800057b8:	eea080e7          	jalr	-278(ra) # 8000169e <sleep>
  for(int i = 0; i < 3; i++){
    800057bc:	f9040693          	addi	a3,s0,-112
    800057c0:	84de                	mv	s1,s7
    800057c2:	bf59                	j	80005758 <virtio_disk_rw+0xa0>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800057c4:	00a58793          	addi	a5,a1,10
    800057c8:	00479693          	slli	a3,a5,0x4
    800057cc:	00018797          	auipc	a5,0x18
    800057d0:	06c78793          	addi	a5,a5,108 # 8001d838 <disk>
    800057d4:	97b6                	add	a5,a5,a3
    800057d6:	4685                	li	a3,1
    800057d8:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057da:	00018617          	auipc	a2,0x18
    800057de:	05e60613          	addi	a2,a2,94 # 8001d838 <disk>
    800057e2:	00a58793          	addi	a5,a1,10
    800057e6:	0792                	slli	a5,a5,0x4
    800057e8:	97b2                	add	a5,a5,a2
    800057ea:	0007a623          	sw	zero,12(a5)
  uint64 sector = b->blockno * (BSIZE / 512);
    800057ee:	001c9c9b          	slliw	s9,s9,0x1
    800057f2:	1c82                	slli	s9,s9,0x20
    800057f4:	020cdc93          	srli	s9,s9,0x20
    800057f8:	0197b823          	sd	s9,16(a5)
  buf0->sector = sector;

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057fc:	f6070693          	addi	a3,a4,-160
    80005800:	621c                	ld	a5,0(a2)
    80005802:	97b6                	add	a5,a5,a3
    80005804:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005806:	6208                	ld	a0,0(a2)
    80005808:	96aa                	add	a3,a3,a0
    8000580a:	47c1                	li	a5,16
    8000580c:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000580e:	4785                	li	a5,1
    80005810:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005814:	f9442783          	lw	a5,-108(s0)
    80005818:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000581c:	0792                	slli	a5,a5,0x4
    8000581e:	953e                	add	a0,a0,a5
    80005820:	06090693          	addi	a3,s2,96
    80005824:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80005826:	6208                	ld	a0,0(a2)
    80005828:	97aa                	add	a5,a5,a0
    8000582a:	40000693          	li	a3,1024
    8000582e:	c794                	sw	a3,8(a5)
  if(write)
    80005830:	100d0d63          	beqz	s10,8000594a <virtio_disk_rw+0x292>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005834:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005838:	00c7d683          	lhu	a3,12(a5)
    8000583c:	0016e693          	ori	a3,a3,1
    80005840:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005844:	f9842603          	lw	a2,-104(s0)
    80005848:	00c79723          	sh	a2,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000584c:	00018697          	auipc	a3,0x18
    80005850:	fec68693          	addi	a3,a3,-20 # 8001d838 <disk>
    80005854:	00258793          	addi	a5,a1,2
    80005858:	0792                	slli	a5,a5,0x4
    8000585a:	97b6                	add	a5,a5,a3
    8000585c:	587d                	li	a6,-1
    8000585e:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005862:	0612                	slli	a2,a2,0x4
    80005864:	9532                	add	a0,a0,a2
    80005866:	f9070713          	addi	a4,a4,-112
    8000586a:	9736                	add	a4,a4,a3
    8000586c:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    8000586e:	6298                	ld	a4,0(a3)
    80005870:	9732                	add	a4,a4,a2
    80005872:	4605                	li	a2,1
    80005874:	c710                	sw	a2,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005876:	4509                	li	a0,2
    80005878:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    8000587c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005880:	00c92223          	sw	a2,4(s2)
  disk.info[idx[0]].b = b;
    80005884:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005888:	6698                	ld	a4,8(a3)
    8000588a:	00275783          	lhu	a5,2(a4)
    8000588e:	8b9d                	andi	a5,a5,7
    80005890:	0786                	slli	a5,a5,0x1
    80005892:	97ba                	add	a5,a5,a4
    80005894:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005898:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000589c:	6698                	ld	a4,8(a3)
    8000589e:	00275783          	lhu	a5,2(a4)
    800058a2:	2785                	addiw	a5,a5,1
    800058a4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058a8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058ac:	100017b7          	lui	a5,0x10001
    800058b0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800058b4:	00492703          	lw	a4,4(s2)
    800058b8:	4785                	li	a5,1
    800058ba:	02f71163          	bne	a4,a5,800058dc <virtio_disk_rw+0x224>
    sleep(b, &disk.vdisk_lock);
    800058be:	00018997          	auipc	s3,0x18
    800058c2:	0a298993          	addi	s3,s3,162 # 8001d960 <disk+0x128>
  while(b->disk == 1) {
    800058c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800058c8:	85ce                	mv	a1,s3
    800058ca:	854a                	mv	a0,s2
    800058cc:	ffffc097          	auipc	ra,0xffffc
    800058d0:	dd2080e7          	jalr	-558(ra) # 8000169e <sleep>
  while(b->disk == 1) {
    800058d4:	00492783          	lw	a5,4(s2)
    800058d8:	fe9788e3          	beq	a5,s1,800058c8 <virtio_disk_rw+0x210>
  }

  disk.info[idx[0]].b = 0;
    800058dc:	f9042903          	lw	s2,-112(s0)
    800058e0:	00290793          	addi	a5,s2,2
    800058e4:	00479713          	slli	a4,a5,0x4
    800058e8:	00018797          	auipc	a5,0x18
    800058ec:	f5078793          	addi	a5,a5,-176 # 8001d838 <disk>
    800058f0:	97ba                	add	a5,a5,a4
    800058f2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058f6:	00018997          	auipc	s3,0x18
    800058fa:	f4298993          	addi	s3,s3,-190 # 8001d838 <disk>
    800058fe:	00491713          	slli	a4,s2,0x4
    80005902:	0009b783          	ld	a5,0(s3)
    80005906:	97ba                	add	a5,a5,a4
    80005908:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000590c:	854a                	mv	a0,s2
    8000590e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005912:	00000097          	auipc	ra,0x0
    80005916:	b34080e7          	jalr	-1228(ra) # 80005446 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000591a:	8885                	andi	s1,s1,1
    8000591c:	f0ed                	bnez	s1,800058fe <virtio_disk_rw+0x246>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000591e:	00018517          	auipc	a0,0x18
    80005922:	04250513          	addi	a0,a0,66 # 8001d960 <disk+0x128>
    80005926:	00001097          	auipc	ra,0x1
    8000592a:	f70080e7          	jalr	-144(ra) # 80006896 <release>
}
    8000592e:	70a6                	ld	ra,104(sp)
    80005930:	7406                	ld	s0,96(sp)
    80005932:	64e6                	ld	s1,88(sp)
    80005934:	6946                	ld	s2,80(sp)
    80005936:	69a6                	ld	s3,72(sp)
    80005938:	6a06                	ld	s4,64(sp)
    8000593a:	7ae2                	ld	s5,56(sp)
    8000593c:	7b42                	ld	s6,48(sp)
    8000593e:	7ba2                	ld	s7,40(sp)
    80005940:	7c02                	ld	s8,32(sp)
    80005942:	6ce2                	ld	s9,24(sp)
    80005944:	6d42                	ld	s10,16(sp)
    80005946:	6165                	addi	sp,sp,112
    80005948:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000594a:	4689                	li	a3,2
    8000594c:	00d79623          	sh	a3,12(a5)
    80005950:	b5e5                	j	80005838 <virtio_disk_rw+0x180>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005952:	f9042583          	lw	a1,-112(s0)
    80005956:	00a58713          	addi	a4,a1,10
    8000595a:	0712                	slli	a4,a4,0x4
    8000595c:	00018517          	auipc	a0,0x18
    80005960:	ee450513          	addi	a0,a0,-284 # 8001d840 <disk+0x8>
    80005964:	953a                	add	a0,a0,a4
  if(write)
    80005966:	e40d1fe3          	bnez	s10,800057c4 <virtio_disk_rw+0x10c>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000596a:	00a58793          	addi	a5,a1,10
    8000596e:	00479693          	slli	a3,a5,0x4
    80005972:	00018797          	auipc	a5,0x18
    80005976:	ec678793          	addi	a5,a5,-314 # 8001d838 <disk>
    8000597a:	97b6                	add	a5,a5,a3
    8000597c:	0007a423          	sw	zero,8(a5)
    80005980:	bda9                	j	800057da <virtio_disk_rw+0x122>

0000000080005982 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005982:	1101                	addi	sp,sp,-32
    80005984:	ec06                	sd	ra,24(sp)
    80005986:	e822                	sd	s0,16(sp)
    80005988:	e426                	sd	s1,8(sp)
    8000598a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000598c:	00018497          	auipc	s1,0x18
    80005990:	eac48493          	addi	s1,s1,-340 # 8001d838 <disk>
    80005994:	00018517          	auipc	a0,0x18
    80005998:	fcc50513          	addi	a0,a0,-52 # 8001d960 <disk+0x128>
    8000599c:	00001097          	auipc	ra,0x1
    800059a0:	e2a080e7          	jalr	-470(ra) # 800067c6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059a4:	10001737          	lui	a4,0x10001
    800059a8:	533c                	lw	a5,96(a4)
    800059aa:	8b8d                	andi	a5,a5,3
    800059ac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059ae:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059b2:	689c                	ld	a5,16(s1)
    800059b4:	0204d703          	lhu	a4,32(s1)
    800059b8:	0027d783          	lhu	a5,2(a5)
    800059bc:	04f70863          	beq	a4,a5,80005a0c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800059c0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059c4:	6898                	ld	a4,16(s1)
    800059c6:	0204d783          	lhu	a5,32(s1)
    800059ca:	8b9d                	andi	a5,a5,7
    800059cc:	078e                	slli	a5,a5,0x3
    800059ce:	97ba                	add	a5,a5,a4
    800059d0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059d2:	00278713          	addi	a4,a5,2
    800059d6:	0712                	slli	a4,a4,0x4
    800059d8:	9726                	add	a4,a4,s1
    800059da:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800059de:	e721                	bnez	a4,80005a26 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800059e0:	0789                	addi	a5,a5,2
    800059e2:	0792                	slli	a5,a5,0x4
    800059e4:	97a6                	add	a5,a5,s1
    800059e6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800059e8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059ec:	ffffc097          	auipc	ra,0xffffc
    800059f0:	d16080e7          	jalr	-746(ra) # 80001702 <wakeup>

    disk.used_idx += 1;
    800059f4:	0204d783          	lhu	a5,32(s1)
    800059f8:	2785                	addiw	a5,a5,1
    800059fa:	17c2                	slli	a5,a5,0x30
    800059fc:	93c1                	srli	a5,a5,0x30
    800059fe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a02:	6898                	ld	a4,16(s1)
    80005a04:	00275703          	lhu	a4,2(a4)
    80005a08:	faf71ce3          	bne	a4,a5,800059c0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a0c:	00018517          	auipc	a0,0x18
    80005a10:	f5450513          	addi	a0,a0,-172 # 8001d960 <disk+0x128>
    80005a14:	00001097          	auipc	ra,0x1
    80005a18:	e82080e7          	jalr	-382(ra) # 80006896 <release>
}
    80005a1c:	60e2                	ld	ra,24(sp)
    80005a1e:	6442                	ld	s0,16(sp)
    80005a20:	64a2                	ld	s1,8(sp)
    80005a22:	6105                	addi	sp,sp,32
    80005a24:	8082                	ret
      panic("virtio_disk_intr status");
    80005a26:	00003517          	auipc	a0,0x3
    80005a2a:	de250513          	addi	a0,a0,-542 # 80008808 <syscalls+0x3f8>
    80005a2e:	00001097          	auipc	ra,0x1
    80005a32:	864080e7          	jalr	-1948(ra) # 80006292 <panic>

0000000080005a36 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005a36:	1141                	addi	sp,sp,-16
    80005a38:	e422                	sd	s0,8(sp)
    80005a3a:	0800                	addi	s0,sp,16
  return -1;
}
    80005a3c:	557d                	li	a0,-1
    80005a3e:	6422                	ld	s0,8(sp)
    80005a40:	0141                	addi	sp,sp,16
    80005a42:	8082                	ret

0000000080005a44 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005a44:	7179                	addi	sp,sp,-48
    80005a46:	f406                	sd	ra,40(sp)
    80005a48:	f022                	sd	s0,32(sp)
    80005a4a:	ec26                	sd	s1,24(sp)
    80005a4c:	e84a                	sd	s2,16(sp)
    80005a4e:	e44e                	sd	s3,8(sp)
    80005a50:	e052                	sd	s4,0(sp)
    80005a52:	1800                	addi	s0,sp,48
    80005a54:	892a                	mv	s2,a0
    80005a56:	89ae                	mv	s3,a1
    80005a58:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80005a5a:	00018517          	auipc	a0,0x18
    80005a5e:	01650513          	addi	a0,a0,22 # 8001da70 <stats>
    80005a62:	00001097          	auipc	ra,0x1
    80005a66:	d64080e7          	jalr	-668(ra) # 800067c6 <acquire>

  if(stats.sz == 0) {
    80005a6a:	00019797          	auipc	a5,0x19
    80005a6e:	0267a783          	lw	a5,38(a5) # 8001ea90 <stats+0x1020>
    80005a72:	cbb5                	beqz	a5,80005ae6 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005a74:	00019797          	auipc	a5,0x19
    80005a78:	ffc78793          	addi	a5,a5,-4 # 8001ea70 <stats+0x1000>
    80005a7c:	53d8                	lw	a4,36(a5)
    80005a7e:	539c                	lw	a5,32(a5)
    80005a80:	9f99                	subw	a5,a5,a4
    80005a82:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005a86:	06d05e63          	blez	a3,80005b02 <statsread+0xbe>
    if(m > n)
    80005a8a:	8a3e                	mv	s4,a5
    80005a8c:	00d4d363          	bge	s1,a3,80005a92 <statsread+0x4e>
    80005a90:	8a26                	mv	s4,s1
    80005a92:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005a96:	86a6                	mv	a3,s1
    80005a98:	00018617          	auipc	a2,0x18
    80005a9c:	ff860613          	addi	a2,a2,-8 # 8001da90 <stats+0x20>
    80005aa0:	963a                	add	a2,a2,a4
    80005aa2:	85ce                	mv	a1,s3
    80005aa4:	854a                	mv	a0,s2
    80005aa6:	ffffc097          	auipc	ra,0xffffc
    80005aaa:	000080e7          	jalr	ra # 80001aa6 <either_copyout>
    80005aae:	57fd                	li	a5,-1
    80005ab0:	00f50a63          	beq	a0,a5,80005ac4 <statsread+0x80>
      stats.off += m;
    80005ab4:	00019717          	auipc	a4,0x19
    80005ab8:	fbc70713          	addi	a4,a4,-68 # 8001ea70 <stats+0x1000>
    80005abc:	535c                	lw	a5,36(a4)
    80005abe:	014787bb          	addw	a5,a5,s4
    80005ac2:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005ac4:	00018517          	auipc	a0,0x18
    80005ac8:	fac50513          	addi	a0,a0,-84 # 8001da70 <stats>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	dca080e7          	jalr	-566(ra) # 80006896 <release>
  return m;
}
    80005ad4:	8526                	mv	a0,s1
    80005ad6:	70a2                	ld	ra,40(sp)
    80005ad8:	7402                	ld	s0,32(sp)
    80005ada:	64e2                	ld	s1,24(sp)
    80005adc:	6942                	ld	s2,16(sp)
    80005ade:	69a2                	ld	s3,8(sp)
    80005ae0:	6a02                	ld	s4,0(sp)
    80005ae2:	6145                	addi	sp,sp,48
    80005ae4:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005ae6:	6585                	lui	a1,0x1
    80005ae8:	00018517          	auipc	a0,0x18
    80005aec:	fa850513          	addi	a0,a0,-88 # 8001da90 <stats+0x20>
    80005af0:	00001097          	auipc	ra,0x1
    80005af4:	f18080e7          	jalr	-232(ra) # 80006a08 <statslock>
    80005af8:	00019797          	auipc	a5,0x19
    80005afc:	f8a7ac23          	sw	a0,-104(a5) # 8001ea90 <stats+0x1020>
    80005b00:	bf95                	j	80005a74 <statsread+0x30>
    stats.sz = 0;
    80005b02:	00019797          	auipc	a5,0x19
    80005b06:	f6e78793          	addi	a5,a5,-146 # 8001ea70 <stats+0x1000>
    80005b0a:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005b0e:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005b12:	54fd                	li	s1,-1
    80005b14:	bf45                	j	80005ac4 <statsread+0x80>

0000000080005b16 <statsinit>:

void
statsinit(void)
{
    80005b16:	1141                	addi	sp,sp,-16
    80005b18:	e406                	sd	ra,8(sp)
    80005b1a:	e022                	sd	s0,0(sp)
    80005b1c:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005b1e:	00003597          	auipc	a1,0x3
    80005b22:	d0258593          	addi	a1,a1,-766 # 80008820 <syscalls+0x410>
    80005b26:	00018517          	auipc	a0,0x18
    80005b2a:	f4a50513          	addi	a0,a0,-182 # 8001da70 <stats>
    80005b2e:	00001097          	auipc	ra,0x1
    80005b32:	e14080e7          	jalr	-492(ra) # 80006942 <initlock>

  devsw[STATS].read = statsread;
    80005b36:	00017797          	auipc	a5,0x17
    80005b3a:	ca278793          	addi	a5,a5,-862 # 8001c7d8 <devsw>
    80005b3e:	00000717          	auipc	a4,0x0
    80005b42:	f0670713          	addi	a4,a4,-250 # 80005a44 <statsread>
    80005b46:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005b48:	00000717          	auipc	a4,0x0
    80005b4c:	eee70713          	addi	a4,a4,-274 # 80005a36 <statswrite>
    80005b50:	f798                	sd	a4,40(a5)
}
    80005b52:	60a2                	ld	ra,8(sp)
    80005b54:	6402                	ld	s0,0(sp)
    80005b56:	0141                	addi	sp,sp,16
    80005b58:	8082                	ret

0000000080005b5a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005b5a:	1101                	addi	sp,sp,-32
    80005b5c:	ec22                	sd	s0,24(sp)
    80005b5e:	1000                	addi	s0,sp,32
    80005b60:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005b62:	c299                	beqz	a3,80005b68 <sprintint+0xe>
    80005b64:	0805c163          	bltz	a1,80005be6 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005b68:	2581                	sext.w	a1,a1
    80005b6a:	4301                	li	t1,0

  i = 0;
    80005b6c:	fe040713          	addi	a4,s0,-32
    80005b70:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005b72:	2601                	sext.w	a2,a2
    80005b74:	00003697          	auipc	a3,0x3
    80005b78:	ccc68693          	addi	a3,a3,-820 # 80008840 <digits>
    80005b7c:	88aa                	mv	a7,a0
    80005b7e:	2505                	addiw	a0,a0,1
    80005b80:	02c5f7bb          	remuw	a5,a1,a2
    80005b84:	1782                	slli	a5,a5,0x20
    80005b86:	9381                	srli	a5,a5,0x20
    80005b88:	97b6                	add	a5,a5,a3
    80005b8a:	0007c783          	lbu	a5,0(a5)
    80005b8e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005b92:	0005879b          	sext.w	a5,a1
    80005b96:	02c5d5bb          	divuw	a1,a1,a2
    80005b9a:	0705                	addi	a4,a4,1
    80005b9c:	fec7f0e3          	bgeu	a5,a2,80005b7c <sprintint+0x22>

  if(sign)
    80005ba0:	00030b63          	beqz	t1,80005bb6 <sprintint+0x5c>
    buf[i++] = '-';
    80005ba4:	ff040793          	addi	a5,s0,-16
    80005ba8:	97aa                	add	a5,a5,a0
    80005baa:	02d00713          	li	a4,45
    80005bae:	fee78823          	sb	a4,-16(a5)
    80005bb2:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005bb6:	02a05c63          	blez	a0,80005bee <sprintint+0x94>
    80005bba:	fe040793          	addi	a5,s0,-32
    80005bbe:	00a78733          	add	a4,a5,a0
    80005bc2:	87c2                	mv	a5,a6
    80005bc4:	0805                	addi	a6,a6,1
    80005bc6:	fff5061b          	addiw	a2,a0,-1
    80005bca:	1602                	slli	a2,a2,0x20
    80005bcc:	9201                	srli	a2,a2,0x20
    80005bce:	9642                	add	a2,a2,a6
  *s = c;
    80005bd0:	fff74683          	lbu	a3,-1(a4)
    80005bd4:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005bd8:	177d                	addi	a4,a4,-1
    80005bda:	0785                	addi	a5,a5,1
    80005bdc:	fec79ae3          	bne	a5,a2,80005bd0 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005be0:	6462                	ld	s0,24(sp)
    80005be2:	6105                	addi	sp,sp,32
    80005be4:	8082                	ret
    x = -xx;
    80005be6:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005bea:	4305                	li	t1,1
    x = -xx;
    80005bec:	b741                	j	80005b6c <sprintint+0x12>
  while(--i >= 0)
    80005bee:	4501                	li	a0,0
    80005bf0:	bfc5                	j	80005be0 <sprintint+0x86>

0000000080005bf2 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005bf2:	7171                	addi	sp,sp,-176
    80005bf4:	fc86                	sd	ra,120(sp)
    80005bf6:	f8a2                	sd	s0,112(sp)
    80005bf8:	f4a6                	sd	s1,104(sp)
    80005bfa:	f0ca                	sd	s2,96(sp)
    80005bfc:	ecce                	sd	s3,88(sp)
    80005bfe:	e8d2                	sd	s4,80(sp)
    80005c00:	e4d6                	sd	s5,72(sp)
    80005c02:	e0da                	sd	s6,64(sp)
    80005c04:	fc5e                	sd	s7,56(sp)
    80005c06:	f862                	sd	s8,48(sp)
    80005c08:	f466                	sd	s9,40(sp)
    80005c0a:	f06a                	sd	s10,32(sp)
    80005c0c:	ec6e                	sd	s11,24(sp)
    80005c0e:	0100                	addi	s0,sp,128
    80005c10:	e414                	sd	a3,8(s0)
    80005c12:	e818                	sd	a4,16(s0)
    80005c14:	ec1c                	sd	a5,24(s0)
    80005c16:	03043023          	sd	a6,32(s0)
    80005c1a:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005c1e:	ca0d                	beqz	a2,80005c50 <snprintf+0x5e>
    80005c20:	8baa                	mv	s7,a0
    80005c22:	89ae                	mv	s3,a1
    80005c24:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005c26:	00840793          	addi	a5,s0,8
    80005c2a:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005c2e:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005c30:	4901                	li	s2,0
    80005c32:	02b05763          	blez	a1,80005c60 <snprintf+0x6e>
    if(c != '%'){
    80005c36:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005c3a:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005c3e:	02800d93          	li	s11,40
  *s = c;
    80005c42:	02500d13          	li	s10,37
    switch(c){
    80005c46:	07800c93          	li	s9,120
    80005c4a:	06400c13          	li	s8,100
    80005c4e:	a01d                	j	80005c74 <snprintf+0x82>
    panic("null fmt");
    80005c50:	00003517          	auipc	a0,0x3
    80005c54:	be050513          	addi	a0,a0,-1056 # 80008830 <syscalls+0x420>
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	63a080e7          	jalr	1594(ra) # 80006292 <panic>
  int off = 0;
    80005c60:	4481                	li	s1,0
    80005c62:	a86d                	j	80005d1c <snprintf+0x12a>
  *s = c;
    80005c64:	009b8733          	add	a4,s7,s1
    80005c68:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c6c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005c6e:	2905                	addiw	s2,s2,1
    80005c70:	0b34d663          	bge	s1,s3,80005d1c <snprintf+0x12a>
    80005c74:	012a07b3          	add	a5,s4,s2
    80005c78:	0007c783          	lbu	a5,0(a5)
    80005c7c:	0007871b          	sext.w	a4,a5
    80005c80:	cfd1                	beqz	a5,80005d1c <snprintf+0x12a>
    if(c != '%'){
    80005c82:	ff5711e3          	bne	a4,s5,80005c64 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005c86:	2905                	addiw	s2,s2,1
    80005c88:	012a07b3          	add	a5,s4,s2
    80005c8c:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005c90:	c7d1                	beqz	a5,80005d1c <snprintf+0x12a>
    switch(c){
    80005c92:	05678c63          	beq	a5,s6,80005cea <snprintf+0xf8>
    80005c96:	02fb6763          	bltu	s6,a5,80005cc4 <snprintf+0xd2>
    80005c9a:	0b578763          	beq	a5,s5,80005d48 <snprintf+0x156>
    80005c9e:	0b879b63          	bne	a5,s8,80005d54 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005ca2:	f8843783          	ld	a5,-120(s0)
    80005ca6:	00878713          	addi	a4,a5,8
    80005caa:	f8e43423          	sd	a4,-120(s0)
    80005cae:	4685                	li	a3,1
    80005cb0:	4629                	li	a2,10
    80005cb2:	438c                	lw	a1,0(a5)
    80005cb4:	009b8533          	add	a0,s7,s1
    80005cb8:	00000097          	auipc	ra,0x0
    80005cbc:	ea2080e7          	jalr	-350(ra) # 80005b5a <sprintint>
    80005cc0:	9ca9                	addw	s1,s1,a0
      break;
    80005cc2:	b775                	j	80005c6e <snprintf+0x7c>
    switch(c){
    80005cc4:	09979863          	bne	a5,s9,80005d54 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005cc8:	f8843783          	ld	a5,-120(s0)
    80005ccc:	00878713          	addi	a4,a5,8
    80005cd0:	f8e43423          	sd	a4,-120(s0)
    80005cd4:	4685                	li	a3,1
    80005cd6:	4641                	li	a2,16
    80005cd8:	438c                	lw	a1,0(a5)
    80005cda:	009b8533          	add	a0,s7,s1
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	e7c080e7          	jalr	-388(ra) # 80005b5a <sprintint>
    80005ce6:	9ca9                	addw	s1,s1,a0
      break;
    80005ce8:	b759                	j	80005c6e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005cea:	f8843783          	ld	a5,-120(s0)
    80005cee:	00878713          	addi	a4,a5,8
    80005cf2:	f8e43423          	sd	a4,-120(s0)
    80005cf6:	639c                	ld	a5,0(a5)
    80005cf8:	c3b1                	beqz	a5,80005d3c <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005cfa:	0007c703          	lbu	a4,0(a5)
    80005cfe:	db25                	beqz	a4,80005c6e <snprintf+0x7c>
    80005d00:	0134de63          	bge	s1,s3,80005d1c <snprintf+0x12a>
    80005d04:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005d08:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005d0c:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005d0e:	0785                	addi	a5,a5,1
    80005d10:	0007c703          	lbu	a4,0(a5)
    80005d14:	df29                	beqz	a4,80005c6e <snprintf+0x7c>
    80005d16:	0685                	addi	a3,a3,1
    80005d18:	fe9998e3          	bne	s3,s1,80005d08 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005d1c:	8526                	mv	a0,s1
    80005d1e:	70e6                	ld	ra,120(sp)
    80005d20:	7446                	ld	s0,112(sp)
    80005d22:	74a6                	ld	s1,104(sp)
    80005d24:	7906                	ld	s2,96(sp)
    80005d26:	69e6                	ld	s3,88(sp)
    80005d28:	6a46                	ld	s4,80(sp)
    80005d2a:	6aa6                	ld	s5,72(sp)
    80005d2c:	6b06                	ld	s6,64(sp)
    80005d2e:	7be2                	ld	s7,56(sp)
    80005d30:	7c42                	ld	s8,48(sp)
    80005d32:	7ca2                	ld	s9,40(sp)
    80005d34:	7d02                	ld	s10,32(sp)
    80005d36:	6de2                	ld	s11,24(sp)
    80005d38:	614d                	addi	sp,sp,176
    80005d3a:	8082                	ret
        s = "(null)";
    80005d3c:	00003797          	auipc	a5,0x3
    80005d40:	aec78793          	addi	a5,a5,-1300 # 80008828 <syscalls+0x418>
      for(; *s && off < sz; s++)
    80005d44:	876e                	mv	a4,s11
    80005d46:	bf6d                	j	80005d00 <snprintf+0x10e>
  *s = c;
    80005d48:	009b87b3          	add	a5,s7,s1
    80005d4c:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005d50:	2485                	addiw	s1,s1,1
      break;
    80005d52:	bf31                	j	80005c6e <snprintf+0x7c>
  *s = c;
    80005d54:	009b8733          	add	a4,s7,s1
    80005d58:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005d5c:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005d60:	975e                	add	a4,a4,s7
    80005d62:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005d66:	2489                	addiw	s1,s1,2
      break;
    80005d68:	b719                	j	80005c6e <snprintf+0x7c>

0000000080005d6a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d6a:	1141                	addi	sp,sp,-16
    80005d6c:	e422                	sd	s0,8(sp)
    80005d6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d70:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d74:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d78:	0037979b          	slliw	a5,a5,0x3
    80005d7c:	02004737          	lui	a4,0x2004
    80005d80:	97ba                	add	a5,a5,a4
    80005d82:	0200c737          	lui	a4,0x200c
    80005d86:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005d8a:	000f4637          	lui	a2,0xf4
    80005d8e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d92:	95b2                	add	a1,a1,a2
    80005d94:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d96:	00269713          	slli	a4,a3,0x2
    80005d9a:	9736                	add	a4,a4,a3
    80005d9c:	00371693          	slli	a3,a4,0x3
    80005da0:	00019717          	auipc	a4,0x19
    80005da4:	d0070713          	addi	a4,a4,-768 # 8001eaa0 <timer_scratch>
    80005da8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005daa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005dac:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005dae:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005db2:	fffff797          	auipc	a5,0xfffff
    80005db6:	5ce78793          	addi	a5,a5,1486 # 80005380 <timervec>
    80005dba:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005dbe:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005dc2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005dc6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005dca:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005dce:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005dd2:	30479073          	csrw	mie,a5
}
    80005dd6:	6422                	ld	s0,8(sp)
    80005dd8:	0141                	addi	sp,sp,16
    80005dda:	8082                	ret

0000000080005ddc <start>:
{
    80005ddc:	1141                	addi	sp,sp,-16
    80005dde:	e406                	sd	ra,8(sp)
    80005de0:	e022                	sd	s0,0(sp)
    80005de2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005de4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005de8:	7779                	lui	a4,0xffffe
    80005dea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd6b47>
    80005dee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005df0:	6705                	lui	a4,0x1
    80005df2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005df6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005df8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005dfc:	ffffa797          	auipc	a5,0xffffa
    80005e00:	66078793          	addi	a5,a5,1632 # 8000045c <main>
    80005e04:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e08:	4781                	li	a5,0
    80005e0a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e0e:	67c1                	lui	a5,0x10
    80005e10:	17fd                	addi	a5,a5,-1
    80005e12:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005e16:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005e1a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005e1e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005e22:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005e26:	57fd                	li	a5,-1
    80005e28:	83a9                	srli	a5,a5,0xa
    80005e2a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005e2e:	47bd                	li	a5,15
    80005e30:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	f36080e7          	jalr	-202(ra) # 80005d6a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005e3c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005e40:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005e42:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e44:	30200073          	mret
}
    80005e48:	60a2                	ld	ra,8(sp)
    80005e4a:	6402                	ld	s0,0(sp)
    80005e4c:	0141                	addi	sp,sp,16
    80005e4e:	8082                	ret

0000000080005e50 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e50:	715d                	addi	sp,sp,-80
    80005e52:	e486                	sd	ra,72(sp)
    80005e54:	e0a2                	sd	s0,64(sp)
    80005e56:	fc26                	sd	s1,56(sp)
    80005e58:	f84a                	sd	s2,48(sp)
    80005e5a:	f44e                	sd	s3,40(sp)
    80005e5c:	f052                	sd	s4,32(sp)
    80005e5e:	ec56                	sd	s5,24(sp)
    80005e60:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e62:	04c05663          	blez	a2,80005eae <consolewrite+0x5e>
    80005e66:	8a2a                	mv	s4,a0
    80005e68:	84ae                	mv	s1,a1
    80005e6a:	89b2                	mv	s3,a2
    80005e6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e6e:	5afd                	li	s5,-1
    80005e70:	4685                	li	a3,1
    80005e72:	8626                	mv	a2,s1
    80005e74:	85d2                	mv	a1,s4
    80005e76:	fbf40513          	addi	a0,s0,-65
    80005e7a:	ffffc097          	auipc	ra,0xffffc
    80005e7e:	c82080e7          	jalr	-894(ra) # 80001afc <either_copyin>
    80005e82:	01550c63          	beq	a0,s5,80005e9a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005e86:	fbf44503          	lbu	a0,-65(s0)
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	794080e7          	jalr	1940(ra) # 8000661e <uartputc>
  for(i = 0; i < n; i++){
    80005e92:	2905                	addiw	s2,s2,1
    80005e94:	0485                	addi	s1,s1,1
    80005e96:	fd299de3          	bne	s3,s2,80005e70 <consolewrite+0x20>
  }

  return i;
}
    80005e9a:	854a                	mv	a0,s2
    80005e9c:	60a6                	ld	ra,72(sp)
    80005e9e:	6406                	ld	s0,64(sp)
    80005ea0:	74e2                	ld	s1,56(sp)
    80005ea2:	7942                	ld	s2,48(sp)
    80005ea4:	79a2                	ld	s3,40(sp)
    80005ea6:	7a02                	ld	s4,32(sp)
    80005ea8:	6ae2                	ld	s5,24(sp)
    80005eaa:	6161                	addi	sp,sp,80
    80005eac:	8082                	ret
  for(i = 0; i < n; i++){
    80005eae:	4901                	li	s2,0
    80005eb0:	b7ed                	j	80005e9a <consolewrite+0x4a>

0000000080005eb2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005eb2:	7119                	addi	sp,sp,-128
    80005eb4:	fc86                	sd	ra,120(sp)
    80005eb6:	f8a2                	sd	s0,112(sp)
    80005eb8:	f4a6                	sd	s1,104(sp)
    80005eba:	f0ca                	sd	s2,96(sp)
    80005ebc:	ecce                	sd	s3,88(sp)
    80005ebe:	e8d2                	sd	s4,80(sp)
    80005ec0:	e4d6                	sd	s5,72(sp)
    80005ec2:	e0da                	sd	s6,64(sp)
    80005ec4:	fc5e                	sd	s7,56(sp)
    80005ec6:	f862                	sd	s8,48(sp)
    80005ec8:	f466                	sd	s9,40(sp)
    80005eca:	f06a                	sd	s10,32(sp)
    80005ecc:	ec6e                	sd	s11,24(sp)
    80005ece:	0100                	addi	s0,sp,128
    80005ed0:	8b2a                	mv	s6,a0
    80005ed2:	8aae                	mv	s5,a1
    80005ed4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ed6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005eda:	00021517          	auipc	a0,0x21
    80005ede:	d0650513          	addi	a0,a0,-762 # 80026be0 <cons>
    80005ee2:	00001097          	auipc	ra,0x1
    80005ee6:	8e4080e7          	jalr	-1820(ra) # 800067c6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005eea:	00021497          	auipc	s1,0x21
    80005eee:	cf648493          	addi	s1,s1,-778 # 80026be0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ef2:	89a6                	mv	s3,s1
    80005ef4:	00021917          	auipc	s2,0x21
    80005ef8:	d8c90913          	addi	s2,s2,-628 # 80026c80 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005efc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005efe:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005f00:	4da9                	li	s11,10
  while(n > 0){
    80005f02:	07405b63          	blez	s4,80005f78 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005f06:	0a04a783          	lw	a5,160(s1)
    80005f0a:	0a44a703          	lw	a4,164(s1)
    80005f0e:	02f71763          	bne	a4,a5,80005f3c <consoleread+0x8a>
      if(killed(myproc())){
    80005f12:	ffffb097          	auipc	ra,0xffffb
    80005f16:	0e4080e7          	jalr	228(ra) # 80000ff6 <myproc>
    80005f1a:	ffffc097          	auipc	ra,0xffffc
    80005f1e:	a2c080e7          	jalr	-1492(ra) # 80001946 <killed>
    80005f22:	e535                	bnez	a0,80005f8e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005f24:	85ce                	mv	a1,s3
    80005f26:	854a                	mv	a0,s2
    80005f28:	ffffb097          	auipc	ra,0xffffb
    80005f2c:	776080e7          	jalr	1910(ra) # 8000169e <sleep>
    while(cons.r == cons.w){
    80005f30:	0a04a783          	lw	a5,160(s1)
    80005f34:	0a44a703          	lw	a4,164(s1)
    80005f38:	fcf70de3          	beq	a4,a5,80005f12 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005f3c:	0017871b          	addiw	a4,a5,1
    80005f40:	0ae4a023          	sw	a4,160(s1)
    80005f44:	07f7f713          	andi	a4,a5,127
    80005f48:	9726                	add	a4,a4,s1
    80005f4a:	02074703          	lbu	a4,32(a4)
    80005f4e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005f52:	079c0663          	beq	s8,s9,80005fbe <consoleread+0x10c>
    cbuf = c;
    80005f56:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f5a:	4685                	li	a3,1
    80005f5c:	f8f40613          	addi	a2,s0,-113
    80005f60:	85d6                	mv	a1,s5
    80005f62:	855a                	mv	a0,s6
    80005f64:	ffffc097          	auipc	ra,0xffffc
    80005f68:	b42080e7          	jalr	-1214(ra) # 80001aa6 <either_copyout>
    80005f6c:	01a50663          	beq	a0,s10,80005f78 <consoleread+0xc6>
    dst++;
    80005f70:	0a85                	addi	s5,s5,1
    --n;
    80005f72:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005f74:	f9bc17e3          	bne	s8,s11,80005f02 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005f78:	00021517          	auipc	a0,0x21
    80005f7c:	c6850513          	addi	a0,a0,-920 # 80026be0 <cons>
    80005f80:	00001097          	auipc	ra,0x1
    80005f84:	916080e7          	jalr	-1770(ra) # 80006896 <release>

  return target - n;
    80005f88:	414b853b          	subw	a0,s7,s4
    80005f8c:	a811                	j	80005fa0 <consoleread+0xee>
        release(&cons.lock);
    80005f8e:	00021517          	auipc	a0,0x21
    80005f92:	c5250513          	addi	a0,a0,-942 # 80026be0 <cons>
    80005f96:	00001097          	auipc	ra,0x1
    80005f9a:	900080e7          	jalr	-1792(ra) # 80006896 <release>
        return -1;
    80005f9e:	557d                	li	a0,-1
}
    80005fa0:	70e6                	ld	ra,120(sp)
    80005fa2:	7446                	ld	s0,112(sp)
    80005fa4:	74a6                	ld	s1,104(sp)
    80005fa6:	7906                	ld	s2,96(sp)
    80005fa8:	69e6                	ld	s3,88(sp)
    80005faa:	6a46                	ld	s4,80(sp)
    80005fac:	6aa6                	ld	s5,72(sp)
    80005fae:	6b06                	ld	s6,64(sp)
    80005fb0:	7be2                	ld	s7,56(sp)
    80005fb2:	7c42                	ld	s8,48(sp)
    80005fb4:	7ca2                	ld	s9,40(sp)
    80005fb6:	7d02                	ld	s10,32(sp)
    80005fb8:	6de2                	ld	s11,24(sp)
    80005fba:	6109                	addi	sp,sp,128
    80005fbc:	8082                	ret
      if(n < target){
    80005fbe:	000a071b          	sext.w	a4,s4
    80005fc2:	fb777be3          	bgeu	a4,s7,80005f78 <consoleread+0xc6>
        cons.r--;
    80005fc6:	00021717          	auipc	a4,0x21
    80005fca:	caf72d23          	sw	a5,-838(a4) # 80026c80 <cons+0xa0>
    80005fce:	b76d                	j	80005f78 <consoleread+0xc6>

0000000080005fd0 <consputc>:
{
    80005fd0:	1141                	addi	sp,sp,-16
    80005fd2:	e406                	sd	ra,8(sp)
    80005fd4:	e022                	sd	s0,0(sp)
    80005fd6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005fd8:	10000793          	li	a5,256
    80005fdc:	00f50a63          	beq	a0,a5,80005ff0 <consputc+0x20>
    uartputc_sync(c);
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	564080e7          	jalr	1380(ra) # 80006544 <uartputc_sync>
}
    80005fe8:	60a2                	ld	ra,8(sp)
    80005fea:	6402                	ld	s0,0(sp)
    80005fec:	0141                	addi	sp,sp,16
    80005fee:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ff0:	4521                	li	a0,8
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	552080e7          	jalr	1362(ra) # 80006544 <uartputc_sync>
    80005ffa:	02000513          	li	a0,32
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	546080e7          	jalr	1350(ra) # 80006544 <uartputc_sync>
    80006006:	4521                	li	a0,8
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	53c080e7          	jalr	1340(ra) # 80006544 <uartputc_sync>
    80006010:	bfe1                	j	80005fe8 <consputc+0x18>

0000000080006012 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006012:	1101                	addi	sp,sp,-32
    80006014:	ec06                	sd	ra,24(sp)
    80006016:	e822                	sd	s0,16(sp)
    80006018:	e426                	sd	s1,8(sp)
    8000601a:	e04a                	sd	s2,0(sp)
    8000601c:	1000                	addi	s0,sp,32
    8000601e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006020:	00021517          	auipc	a0,0x21
    80006024:	bc050513          	addi	a0,a0,-1088 # 80026be0 <cons>
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	79e080e7          	jalr	1950(ra) # 800067c6 <acquire>

  switch(c){
    80006030:	47d5                	li	a5,21
    80006032:	0af48663          	beq	s1,a5,800060de <consoleintr+0xcc>
    80006036:	0297ca63          	blt	a5,s1,8000606a <consoleintr+0x58>
    8000603a:	47a1                	li	a5,8
    8000603c:	0ef48763          	beq	s1,a5,8000612a <consoleintr+0x118>
    80006040:	47c1                	li	a5,16
    80006042:	10f49a63          	bne	s1,a5,80006156 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80006046:	ffffc097          	auipc	ra,0xffffc
    8000604a:	b0c080e7          	jalr	-1268(ra) # 80001b52 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000604e:	00021517          	auipc	a0,0x21
    80006052:	b9250513          	addi	a0,a0,-1134 # 80026be0 <cons>
    80006056:	00001097          	auipc	ra,0x1
    8000605a:	840080e7          	jalr	-1984(ra) # 80006896 <release>
}
    8000605e:	60e2                	ld	ra,24(sp)
    80006060:	6442                	ld	s0,16(sp)
    80006062:	64a2                	ld	s1,8(sp)
    80006064:	6902                	ld	s2,0(sp)
    80006066:	6105                	addi	sp,sp,32
    80006068:	8082                	ret
  switch(c){
    8000606a:	07f00793          	li	a5,127
    8000606e:	0af48e63          	beq	s1,a5,8000612a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006072:	00021717          	auipc	a4,0x21
    80006076:	b6e70713          	addi	a4,a4,-1170 # 80026be0 <cons>
    8000607a:	0a872783          	lw	a5,168(a4)
    8000607e:	0a072703          	lw	a4,160(a4)
    80006082:	9f99                	subw	a5,a5,a4
    80006084:	07f00713          	li	a4,127
    80006088:	fcf763e3          	bltu	a4,a5,8000604e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000608c:	47b5                	li	a5,13
    8000608e:	0cf48763          	beq	s1,a5,8000615c <consoleintr+0x14a>
      consputc(c);
    80006092:	8526                	mv	a0,s1
    80006094:	00000097          	auipc	ra,0x0
    80006098:	f3c080e7          	jalr	-196(ra) # 80005fd0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000609c:	00021797          	auipc	a5,0x21
    800060a0:	b4478793          	addi	a5,a5,-1212 # 80026be0 <cons>
    800060a4:	0a87a683          	lw	a3,168(a5)
    800060a8:	0016871b          	addiw	a4,a3,1
    800060ac:	0007061b          	sext.w	a2,a4
    800060b0:	0ae7a423          	sw	a4,168(a5)
    800060b4:	07f6f693          	andi	a3,a3,127
    800060b8:	97b6                	add	a5,a5,a3
    800060ba:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800060be:	47a9                	li	a5,10
    800060c0:	0cf48563          	beq	s1,a5,8000618a <consoleintr+0x178>
    800060c4:	4791                	li	a5,4
    800060c6:	0cf48263          	beq	s1,a5,8000618a <consoleintr+0x178>
    800060ca:	00021797          	auipc	a5,0x21
    800060ce:	bb67a783          	lw	a5,-1098(a5) # 80026c80 <cons+0xa0>
    800060d2:	9f1d                	subw	a4,a4,a5
    800060d4:	08000793          	li	a5,128
    800060d8:	f6f71be3          	bne	a4,a5,8000604e <consoleintr+0x3c>
    800060dc:	a07d                	j	8000618a <consoleintr+0x178>
    while(cons.e != cons.w &&
    800060de:	00021717          	auipc	a4,0x21
    800060e2:	b0270713          	addi	a4,a4,-1278 # 80026be0 <cons>
    800060e6:	0a872783          	lw	a5,168(a4)
    800060ea:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800060ee:	00021497          	auipc	s1,0x21
    800060f2:	af248493          	addi	s1,s1,-1294 # 80026be0 <cons>
    while(cons.e != cons.w &&
    800060f6:	4929                	li	s2,10
    800060f8:	f4f70be3          	beq	a4,a5,8000604e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800060fc:	37fd                	addiw	a5,a5,-1
    800060fe:	07f7f713          	andi	a4,a5,127
    80006102:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006104:	02074703          	lbu	a4,32(a4)
    80006108:	f52703e3          	beq	a4,s2,8000604e <consoleintr+0x3c>
      cons.e--;
    8000610c:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80006110:	10000513          	li	a0,256
    80006114:	00000097          	auipc	ra,0x0
    80006118:	ebc080e7          	jalr	-324(ra) # 80005fd0 <consputc>
    while(cons.e != cons.w &&
    8000611c:	0a84a783          	lw	a5,168(s1)
    80006120:	0a44a703          	lw	a4,164(s1)
    80006124:	fcf71ce3          	bne	a4,a5,800060fc <consoleintr+0xea>
    80006128:	b71d                	j	8000604e <consoleintr+0x3c>
    if(cons.e != cons.w){
    8000612a:	00021717          	auipc	a4,0x21
    8000612e:	ab670713          	addi	a4,a4,-1354 # 80026be0 <cons>
    80006132:	0a872783          	lw	a5,168(a4)
    80006136:	0a472703          	lw	a4,164(a4)
    8000613a:	f0f70ae3          	beq	a4,a5,8000604e <consoleintr+0x3c>
      cons.e--;
    8000613e:	37fd                	addiw	a5,a5,-1
    80006140:	00021717          	auipc	a4,0x21
    80006144:	b4f72423          	sw	a5,-1208(a4) # 80026c88 <cons+0xa8>
      consputc(BACKSPACE);
    80006148:	10000513          	li	a0,256
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	e84080e7          	jalr	-380(ra) # 80005fd0 <consputc>
    80006154:	bded                	j	8000604e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006156:	ee048ce3          	beqz	s1,8000604e <consoleintr+0x3c>
    8000615a:	bf21                	j	80006072 <consoleintr+0x60>
      consputc(c);
    8000615c:	4529                	li	a0,10
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	e72080e7          	jalr	-398(ra) # 80005fd0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006166:	00021797          	auipc	a5,0x21
    8000616a:	a7a78793          	addi	a5,a5,-1414 # 80026be0 <cons>
    8000616e:	0a87a703          	lw	a4,168(a5)
    80006172:	0017069b          	addiw	a3,a4,1
    80006176:	0006861b          	sext.w	a2,a3
    8000617a:	0ad7a423          	sw	a3,168(a5)
    8000617e:	07f77713          	andi	a4,a4,127
    80006182:	97ba                	add	a5,a5,a4
    80006184:	4729                	li	a4,10
    80006186:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    8000618a:	00021797          	auipc	a5,0x21
    8000618e:	aec7ad23          	sw	a2,-1286(a5) # 80026c84 <cons+0xa4>
        wakeup(&cons.r);
    80006192:	00021517          	auipc	a0,0x21
    80006196:	aee50513          	addi	a0,a0,-1298 # 80026c80 <cons+0xa0>
    8000619a:	ffffb097          	auipc	ra,0xffffb
    8000619e:	568080e7          	jalr	1384(ra) # 80001702 <wakeup>
    800061a2:	b575                	j	8000604e <consoleintr+0x3c>

00000000800061a4 <consoleinit>:

void
consoleinit(void)
{
    800061a4:	1141                	addi	sp,sp,-16
    800061a6:	e406                	sd	ra,8(sp)
    800061a8:	e022                	sd	s0,0(sp)
    800061aa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800061ac:	00002597          	auipc	a1,0x2
    800061b0:	6ac58593          	addi	a1,a1,1708 # 80008858 <digits+0x18>
    800061b4:	00021517          	auipc	a0,0x21
    800061b8:	a2c50513          	addi	a0,a0,-1492 # 80026be0 <cons>
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	786080e7          	jalr	1926(ra) # 80006942 <initlock>

  uartinit();
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	330080e7          	jalr	816(ra) # 800064f4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800061cc:	00016797          	auipc	a5,0x16
    800061d0:	60c78793          	addi	a5,a5,1548 # 8001c7d8 <devsw>
    800061d4:	00000717          	auipc	a4,0x0
    800061d8:	cde70713          	addi	a4,a4,-802 # 80005eb2 <consoleread>
    800061dc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800061de:	00000717          	auipc	a4,0x0
    800061e2:	c7270713          	addi	a4,a4,-910 # 80005e50 <consolewrite>
    800061e6:	ef98                	sd	a4,24(a5)
}
    800061e8:	60a2                	ld	ra,8(sp)
    800061ea:	6402                	ld	s0,0(sp)
    800061ec:	0141                	addi	sp,sp,16
    800061ee:	8082                	ret

00000000800061f0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800061f0:	7179                	addi	sp,sp,-48
    800061f2:	f406                	sd	ra,40(sp)
    800061f4:	f022                	sd	s0,32(sp)
    800061f6:	ec26                	sd	s1,24(sp)
    800061f8:	e84a                	sd	s2,16(sp)
    800061fa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800061fc:	c219                	beqz	a2,80006202 <printint+0x12>
    800061fe:	08054663          	bltz	a0,8000628a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006202:	2501                	sext.w	a0,a0
    80006204:	4881                	li	a7,0
    80006206:	fd040693          	addi	a3,s0,-48

  i = 0;
    8000620a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000620c:	2581                	sext.w	a1,a1
    8000620e:	00002617          	auipc	a2,0x2
    80006212:	66260613          	addi	a2,a2,1634 # 80008870 <digits>
    80006216:	883a                	mv	a6,a4
    80006218:	2705                	addiw	a4,a4,1
    8000621a:	02b577bb          	remuw	a5,a0,a1
    8000621e:	1782                	slli	a5,a5,0x20
    80006220:	9381                	srli	a5,a5,0x20
    80006222:	97b2                	add	a5,a5,a2
    80006224:	0007c783          	lbu	a5,0(a5)
    80006228:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000622c:	0005079b          	sext.w	a5,a0
    80006230:	02b5553b          	divuw	a0,a0,a1
    80006234:	0685                	addi	a3,a3,1
    80006236:	feb7f0e3          	bgeu	a5,a1,80006216 <printint+0x26>

  if(sign)
    8000623a:	00088b63          	beqz	a7,80006250 <printint+0x60>
    buf[i++] = '-';
    8000623e:	fe040793          	addi	a5,s0,-32
    80006242:	973e                	add	a4,a4,a5
    80006244:	02d00793          	li	a5,45
    80006248:	fef70823          	sb	a5,-16(a4)
    8000624c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006250:	02e05763          	blez	a4,8000627e <printint+0x8e>
    80006254:	fd040793          	addi	a5,s0,-48
    80006258:	00e784b3          	add	s1,a5,a4
    8000625c:	fff78913          	addi	s2,a5,-1
    80006260:	993a                	add	s2,s2,a4
    80006262:	377d                	addiw	a4,a4,-1
    80006264:	1702                	slli	a4,a4,0x20
    80006266:	9301                	srli	a4,a4,0x20
    80006268:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000626c:	fff4c503          	lbu	a0,-1(s1)
    80006270:	00000097          	auipc	ra,0x0
    80006274:	d60080e7          	jalr	-672(ra) # 80005fd0 <consputc>
  while(--i >= 0)
    80006278:	14fd                	addi	s1,s1,-1
    8000627a:	ff2499e3          	bne	s1,s2,8000626c <printint+0x7c>
}
    8000627e:	70a2                	ld	ra,40(sp)
    80006280:	7402                	ld	s0,32(sp)
    80006282:	64e2                	ld	s1,24(sp)
    80006284:	6942                	ld	s2,16(sp)
    80006286:	6145                	addi	sp,sp,48
    80006288:	8082                	ret
    x = -xx;
    8000628a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000628e:	4885                	li	a7,1
    x = -xx;
    80006290:	bf9d                	j	80006206 <printint+0x16>

0000000080006292 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006292:	1101                	addi	sp,sp,-32
    80006294:	ec06                	sd	ra,24(sp)
    80006296:	e822                	sd	s0,16(sp)
    80006298:	e426                	sd	s1,8(sp)
    8000629a:	1000                	addi	s0,sp,32
    8000629c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000629e:	00021797          	auipc	a5,0x21
    800062a2:	a007a923          	sw	zero,-1518(a5) # 80026cb0 <pr+0x20>
  printf("panic: ");
    800062a6:	00002517          	auipc	a0,0x2
    800062aa:	5ba50513          	addi	a0,a0,1466 # 80008860 <digits+0x20>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	02e080e7          	jalr	46(ra) # 800062dc <printf>
  printf(s);
    800062b6:	8526                	mv	a0,s1
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	024080e7          	jalr	36(ra) # 800062dc <printf>
  printf("\n");
    800062c0:	00002517          	auipc	a0,0x2
    800062c4:	63850513          	addi	a0,a0,1592 # 800088f8 <digits+0x88>
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	014080e7          	jalr	20(ra) # 800062dc <printf>
  panicked = 1; // freeze uart output from other CPUs
    800062d0:	4785                	li	a5,1
    800062d2:	00002717          	auipc	a4,0x2
    800062d6:	70f72f23          	sw	a5,1822(a4) # 800089f0 <panicked>
  for(;;)
    800062da:	a001                	j	800062da <panic+0x48>

00000000800062dc <printf>:
{
    800062dc:	7131                	addi	sp,sp,-192
    800062de:	fc86                	sd	ra,120(sp)
    800062e0:	f8a2                	sd	s0,112(sp)
    800062e2:	f4a6                	sd	s1,104(sp)
    800062e4:	f0ca                	sd	s2,96(sp)
    800062e6:	ecce                	sd	s3,88(sp)
    800062e8:	e8d2                	sd	s4,80(sp)
    800062ea:	e4d6                	sd	s5,72(sp)
    800062ec:	e0da                	sd	s6,64(sp)
    800062ee:	fc5e                	sd	s7,56(sp)
    800062f0:	f862                	sd	s8,48(sp)
    800062f2:	f466                	sd	s9,40(sp)
    800062f4:	f06a                	sd	s10,32(sp)
    800062f6:	ec6e                	sd	s11,24(sp)
    800062f8:	0100                	addi	s0,sp,128
    800062fa:	8a2a                	mv	s4,a0
    800062fc:	e40c                	sd	a1,8(s0)
    800062fe:	e810                	sd	a2,16(s0)
    80006300:	ec14                	sd	a3,24(s0)
    80006302:	f018                	sd	a4,32(s0)
    80006304:	f41c                	sd	a5,40(s0)
    80006306:	03043823          	sd	a6,48(s0)
    8000630a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000630e:	00021d97          	auipc	s11,0x21
    80006312:	9a2dad83          	lw	s11,-1630(s11) # 80026cb0 <pr+0x20>
  if(locking)
    80006316:	020d9b63          	bnez	s11,8000634c <printf+0x70>
  if (fmt == 0)
    8000631a:	040a0263          	beqz	s4,8000635e <printf+0x82>
  va_start(ap, fmt);
    8000631e:	00840793          	addi	a5,s0,8
    80006322:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006326:	000a4503          	lbu	a0,0(s4)
    8000632a:	16050263          	beqz	a0,8000648e <printf+0x1b2>
    8000632e:	4481                	li	s1,0
    if(c != '%'){
    80006330:	02500a93          	li	s5,37
    switch(c){
    80006334:	07000b13          	li	s6,112
  consputc('x');
    80006338:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000633a:	00002b97          	auipc	s7,0x2
    8000633e:	536b8b93          	addi	s7,s7,1334 # 80008870 <digits>
    switch(c){
    80006342:	07300c93          	li	s9,115
    80006346:	06400c13          	li	s8,100
    8000634a:	a82d                	j	80006384 <printf+0xa8>
    acquire(&pr.lock);
    8000634c:	00021517          	auipc	a0,0x21
    80006350:	94450513          	addi	a0,a0,-1724 # 80026c90 <pr>
    80006354:	00000097          	auipc	ra,0x0
    80006358:	472080e7          	jalr	1138(ra) # 800067c6 <acquire>
    8000635c:	bf7d                	j	8000631a <printf+0x3e>
    panic("null fmt");
    8000635e:	00002517          	auipc	a0,0x2
    80006362:	4d250513          	addi	a0,a0,1234 # 80008830 <syscalls+0x420>
    80006366:	00000097          	auipc	ra,0x0
    8000636a:	f2c080e7          	jalr	-212(ra) # 80006292 <panic>
      consputc(c);
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	c62080e7          	jalr	-926(ra) # 80005fd0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006376:	2485                	addiw	s1,s1,1
    80006378:	009a07b3          	add	a5,s4,s1
    8000637c:	0007c503          	lbu	a0,0(a5)
    80006380:	10050763          	beqz	a0,8000648e <printf+0x1b2>
    if(c != '%'){
    80006384:	ff5515e3          	bne	a0,s5,8000636e <printf+0x92>
    c = fmt[++i] & 0xff;
    80006388:	2485                	addiw	s1,s1,1
    8000638a:	009a07b3          	add	a5,s4,s1
    8000638e:	0007c783          	lbu	a5,0(a5)
    80006392:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006396:	cfe5                	beqz	a5,8000648e <printf+0x1b2>
    switch(c){
    80006398:	05678a63          	beq	a5,s6,800063ec <printf+0x110>
    8000639c:	02fb7663          	bgeu	s6,a5,800063c8 <printf+0xec>
    800063a0:	09978963          	beq	a5,s9,80006432 <printf+0x156>
    800063a4:	07800713          	li	a4,120
    800063a8:	0ce79863          	bne	a5,a4,80006478 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800063ac:	f8843783          	ld	a5,-120(s0)
    800063b0:	00878713          	addi	a4,a5,8
    800063b4:	f8e43423          	sd	a4,-120(s0)
    800063b8:	4605                	li	a2,1
    800063ba:	85ea                	mv	a1,s10
    800063bc:	4388                	lw	a0,0(a5)
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	e32080e7          	jalr	-462(ra) # 800061f0 <printint>
      break;
    800063c6:	bf45                	j	80006376 <printf+0x9a>
    switch(c){
    800063c8:	0b578263          	beq	a5,s5,8000646c <printf+0x190>
    800063cc:	0b879663          	bne	a5,s8,80006478 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800063d0:	f8843783          	ld	a5,-120(s0)
    800063d4:	00878713          	addi	a4,a5,8
    800063d8:	f8e43423          	sd	a4,-120(s0)
    800063dc:	4605                	li	a2,1
    800063de:	45a9                	li	a1,10
    800063e0:	4388                	lw	a0,0(a5)
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	e0e080e7          	jalr	-498(ra) # 800061f0 <printint>
      break;
    800063ea:	b771                	j	80006376 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800063ec:	f8843783          	ld	a5,-120(s0)
    800063f0:	00878713          	addi	a4,a5,8
    800063f4:	f8e43423          	sd	a4,-120(s0)
    800063f8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800063fc:	03000513          	li	a0,48
    80006400:	00000097          	auipc	ra,0x0
    80006404:	bd0080e7          	jalr	-1072(ra) # 80005fd0 <consputc>
  consputc('x');
    80006408:	07800513          	li	a0,120
    8000640c:	00000097          	auipc	ra,0x0
    80006410:	bc4080e7          	jalr	-1084(ra) # 80005fd0 <consputc>
    80006414:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006416:	03c9d793          	srli	a5,s3,0x3c
    8000641a:	97de                	add	a5,a5,s7
    8000641c:	0007c503          	lbu	a0,0(a5)
    80006420:	00000097          	auipc	ra,0x0
    80006424:	bb0080e7          	jalr	-1104(ra) # 80005fd0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006428:	0992                	slli	s3,s3,0x4
    8000642a:	397d                	addiw	s2,s2,-1
    8000642c:	fe0915e3          	bnez	s2,80006416 <printf+0x13a>
    80006430:	b799                	j	80006376 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006432:	f8843783          	ld	a5,-120(s0)
    80006436:	00878713          	addi	a4,a5,8
    8000643a:	f8e43423          	sd	a4,-120(s0)
    8000643e:	0007b903          	ld	s2,0(a5)
    80006442:	00090e63          	beqz	s2,8000645e <printf+0x182>
      for(; *s; s++)
    80006446:	00094503          	lbu	a0,0(s2)
    8000644a:	d515                	beqz	a0,80006376 <printf+0x9a>
        consputc(*s);
    8000644c:	00000097          	auipc	ra,0x0
    80006450:	b84080e7          	jalr	-1148(ra) # 80005fd0 <consputc>
      for(; *s; s++)
    80006454:	0905                	addi	s2,s2,1
    80006456:	00094503          	lbu	a0,0(s2)
    8000645a:	f96d                	bnez	a0,8000644c <printf+0x170>
    8000645c:	bf29                	j	80006376 <printf+0x9a>
        s = "(null)";
    8000645e:	00002917          	auipc	s2,0x2
    80006462:	3ca90913          	addi	s2,s2,970 # 80008828 <syscalls+0x418>
      for(; *s; s++)
    80006466:	02800513          	li	a0,40
    8000646a:	b7cd                	j	8000644c <printf+0x170>
      consputc('%');
    8000646c:	8556                	mv	a0,s5
    8000646e:	00000097          	auipc	ra,0x0
    80006472:	b62080e7          	jalr	-1182(ra) # 80005fd0 <consputc>
      break;
    80006476:	b701                	j	80006376 <printf+0x9a>
      consputc('%');
    80006478:	8556                	mv	a0,s5
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	b56080e7          	jalr	-1194(ra) # 80005fd0 <consputc>
      consputc(c);
    80006482:	854a                	mv	a0,s2
    80006484:	00000097          	auipc	ra,0x0
    80006488:	b4c080e7          	jalr	-1204(ra) # 80005fd0 <consputc>
      break;
    8000648c:	b5ed                	j	80006376 <printf+0x9a>
  if(locking)
    8000648e:	020d9163          	bnez	s11,800064b0 <printf+0x1d4>
}
    80006492:	70e6                	ld	ra,120(sp)
    80006494:	7446                	ld	s0,112(sp)
    80006496:	74a6                	ld	s1,104(sp)
    80006498:	7906                	ld	s2,96(sp)
    8000649a:	69e6                	ld	s3,88(sp)
    8000649c:	6a46                	ld	s4,80(sp)
    8000649e:	6aa6                	ld	s5,72(sp)
    800064a0:	6b06                	ld	s6,64(sp)
    800064a2:	7be2                	ld	s7,56(sp)
    800064a4:	7c42                	ld	s8,48(sp)
    800064a6:	7ca2                	ld	s9,40(sp)
    800064a8:	7d02                	ld	s10,32(sp)
    800064aa:	6de2                	ld	s11,24(sp)
    800064ac:	6129                	addi	sp,sp,192
    800064ae:	8082                	ret
    release(&pr.lock);
    800064b0:	00020517          	auipc	a0,0x20
    800064b4:	7e050513          	addi	a0,a0,2016 # 80026c90 <pr>
    800064b8:	00000097          	auipc	ra,0x0
    800064bc:	3de080e7          	jalr	990(ra) # 80006896 <release>
}
    800064c0:	bfc9                	j	80006492 <printf+0x1b6>

00000000800064c2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800064c2:	1101                	addi	sp,sp,-32
    800064c4:	ec06                	sd	ra,24(sp)
    800064c6:	e822                	sd	s0,16(sp)
    800064c8:	e426                	sd	s1,8(sp)
    800064ca:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800064cc:	00020497          	auipc	s1,0x20
    800064d0:	7c448493          	addi	s1,s1,1988 # 80026c90 <pr>
    800064d4:	00002597          	auipc	a1,0x2
    800064d8:	39458593          	addi	a1,a1,916 # 80008868 <digits+0x28>
    800064dc:	8526                	mv	a0,s1
    800064de:	00000097          	auipc	ra,0x0
    800064e2:	464080e7          	jalr	1124(ra) # 80006942 <initlock>
  pr.locking = 1;
    800064e6:	4785                	li	a5,1
    800064e8:	d09c                	sw	a5,32(s1)
}
    800064ea:	60e2                	ld	ra,24(sp)
    800064ec:	6442                	ld	s0,16(sp)
    800064ee:	64a2                	ld	s1,8(sp)
    800064f0:	6105                	addi	sp,sp,32
    800064f2:	8082                	ret

00000000800064f4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800064f4:	1141                	addi	sp,sp,-16
    800064f6:	e406                	sd	ra,8(sp)
    800064f8:	e022                	sd	s0,0(sp)
    800064fa:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800064fc:	100007b7          	lui	a5,0x10000
    80006500:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006504:	f8000713          	li	a4,-128
    80006508:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000650c:	470d                	li	a4,3
    8000650e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006512:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006516:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000651a:	469d                	li	a3,7
    8000651c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006520:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006524:	00002597          	auipc	a1,0x2
    80006528:	36458593          	addi	a1,a1,868 # 80008888 <digits+0x18>
    8000652c:	00020517          	auipc	a0,0x20
    80006530:	78c50513          	addi	a0,a0,1932 # 80026cb8 <uart_tx_lock>
    80006534:	00000097          	auipc	ra,0x0
    80006538:	40e080e7          	jalr	1038(ra) # 80006942 <initlock>
}
    8000653c:	60a2                	ld	ra,8(sp)
    8000653e:	6402                	ld	s0,0(sp)
    80006540:	0141                	addi	sp,sp,16
    80006542:	8082                	ret

0000000080006544 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006544:	1101                	addi	sp,sp,-32
    80006546:	ec06                	sd	ra,24(sp)
    80006548:	e822                	sd	s0,16(sp)
    8000654a:	e426                	sd	s1,8(sp)
    8000654c:	1000                	addi	s0,sp,32
    8000654e:	84aa                	mv	s1,a0
  push_off();
    80006550:	00000097          	auipc	ra,0x0
    80006554:	22a080e7          	jalr	554(ra) # 8000677a <push_off>

  if(panicked){
    80006558:	00002797          	auipc	a5,0x2
    8000655c:	4987a783          	lw	a5,1176(a5) # 800089f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006560:	10000737          	lui	a4,0x10000
  if(panicked){
    80006564:	c391                	beqz	a5,80006568 <uartputc_sync+0x24>
    for(;;)
    80006566:	a001                	j	80006566 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006568:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000656c:	0ff7f793          	andi	a5,a5,255
    80006570:	0207f793          	andi	a5,a5,32
    80006574:	dbf5                	beqz	a5,80006568 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006576:	0ff4f793          	andi	a5,s1,255
    8000657a:	10000737          	lui	a4,0x10000
    8000657e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006582:	00000097          	auipc	ra,0x0
    80006586:	2b4080e7          	jalr	692(ra) # 80006836 <pop_off>
}
    8000658a:	60e2                	ld	ra,24(sp)
    8000658c:	6442                	ld	s0,16(sp)
    8000658e:	64a2                	ld	s1,8(sp)
    80006590:	6105                	addi	sp,sp,32
    80006592:	8082                	ret

0000000080006594 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006594:	00002717          	auipc	a4,0x2
    80006598:	46473703          	ld	a4,1124(a4) # 800089f8 <uart_tx_r>
    8000659c:	00002797          	auipc	a5,0x2
    800065a0:	4647b783          	ld	a5,1124(a5) # 80008a00 <uart_tx_w>
    800065a4:	06e78c63          	beq	a5,a4,8000661c <uartstart+0x88>
{
    800065a8:	7139                	addi	sp,sp,-64
    800065aa:	fc06                	sd	ra,56(sp)
    800065ac:	f822                	sd	s0,48(sp)
    800065ae:	f426                	sd	s1,40(sp)
    800065b0:	f04a                	sd	s2,32(sp)
    800065b2:	ec4e                	sd	s3,24(sp)
    800065b4:	e852                	sd	s4,16(sp)
    800065b6:	e456                	sd	s5,8(sp)
    800065b8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065ba:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065be:	00020a17          	auipc	s4,0x20
    800065c2:	6faa0a13          	addi	s4,s4,1786 # 80026cb8 <uart_tx_lock>
    uart_tx_r += 1;
    800065c6:	00002497          	auipc	s1,0x2
    800065ca:	43248493          	addi	s1,s1,1074 # 800089f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800065ce:	00002997          	auipc	s3,0x2
    800065d2:	43298993          	addi	s3,s3,1074 # 80008a00 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065d6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800065da:	0ff7f793          	andi	a5,a5,255
    800065de:	0207f793          	andi	a5,a5,32
    800065e2:	c785                	beqz	a5,8000660a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065e4:	01f77793          	andi	a5,a4,31
    800065e8:	97d2                	add	a5,a5,s4
    800065ea:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    800065ee:	0705                	addi	a4,a4,1
    800065f0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800065f2:	8526                	mv	a0,s1
    800065f4:	ffffb097          	auipc	ra,0xffffb
    800065f8:	10e080e7          	jalr	270(ra) # 80001702 <wakeup>
    
    WriteReg(THR, c);
    800065fc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006600:	6098                	ld	a4,0(s1)
    80006602:	0009b783          	ld	a5,0(s3)
    80006606:	fce798e3          	bne	a5,a4,800065d6 <uartstart+0x42>
  }
}
    8000660a:	70e2                	ld	ra,56(sp)
    8000660c:	7442                	ld	s0,48(sp)
    8000660e:	74a2                	ld	s1,40(sp)
    80006610:	7902                	ld	s2,32(sp)
    80006612:	69e2                	ld	s3,24(sp)
    80006614:	6a42                	ld	s4,16(sp)
    80006616:	6aa2                	ld	s5,8(sp)
    80006618:	6121                	addi	sp,sp,64
    8000661a:	8082                	ret
    8000661c:	8082                	ret

000000008000661e <uartputc>:
{
    8000661e:	7179                	addi	sp,sp,-48
    80006620:	f406                	sd	ra,40(sp)
    80006622:	f022                	sd	s0,32(sp)
    80006624:	ec26                	sd	s1,24(sp)
    80006626:	e84a                	sd	s2,16(sp)
    80006628:	e44e                	sd	s3,8(sp)
    8000662a:	e052                	sd	s4,0(sp)
    8000662c:	1800                	addi	s0,sp,48
    8000662e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006630:	00020517          	auipc	a0,0x20
    80006634:	68850513          	addi	a0,a0,1672 # 80026cb8 <uart_tx_lock>
    80006638:	00000097          	auipc	ra,0x0
    8000663c:	18e080e7          	jalr	398(ra) # 800067c6 <acquire>
  if(panicked){
    80006640:	00002797          	auipc	a5,0x2
    80006644:	3b07a783          	lw	a5,944(a5) # 800089f0 <panicked>
    80006648:	e7c9                	bnez	a5,800066d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000664a:	00002797          	auipc	a5,0x2
    8000664e:	3b67b783          	ld	a5,950(a5) # 80008a00 <uart_tx_w>
    80006652:	00002717          	auipc	a4,0x2
    80006656:	3a673703          	ld	a4,934(a4) # 800089f8 <uart_tx_r>
    8000665a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000665e:	00020a17          	auipc	s4,0x20
    80006662:	65aa0a13          	addi	s4,s4,1626 # 80026cb8 <uart_tx_lock>
    80006666:	00002497          	auipc	s1,0x2
    8000666a:	39248493          	addi	s1,s1,914 # 800089f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000666e:	00002917          	auipc	s2,0x2
    80006672:	39290913          	addi	s2,s2,914 # 80008a00 <uart_tx_w>
    80006676:	00f71f63          	bne	a4,a5,80006694 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000667a:	85d2                	mv	a1,s4
    8000667c:	8526                	mv	a0,s1
    8000667e:	ffffb097          	auipc	ra,0xffffb
    80006682:	020080e7          	jalr	32(ra) # 8000169e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006686:	00093783          	ld	a5,0(s2)
    8000668a:	6098                	ld	a4,0(s1)
    8000668c:	02070713          	addi	a4,a4,32
    80006690:	fef705e3          	beq	a4,a5,8000667a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006694:	00020497          	auipc	s1,0x20
    80006698:	62448493          	addi	s1,s1,1572 # 80026cb8 <uart_tx_lock>
    8000669c:	01f7f713          	andi	a4,a5,31
    800066a0:	9726                	add	a4,a4,s1
    800066a2:	03370023          	sb	s3,32(a4)
  uart_tx_w += 1;
    800066a6:	0785                	addi	a5,a5,1
    800066a8:	00002717          	auipc	a4,0x2
    800066ac:	34f73c23          	sd	a5,856(a4) # 80008a00 <uart_tx_w>
  uartstart();
    800066b0:	00000097          	auipc	ra,0x0
    800066b4:	ee4080e7          	jalr	-284(ra) # 80006594 <uartstart>
  release(&uart_tx_lock);
    800066b8:	8526                	mv	a0,s1
    800066ba:	00000097          	auipc	ra,0x0
    800066be:	1dc080e7          	jalr	476(ra) # 80006896 <release>
}
    800066c2:	70a2                	ld	ra,40(sp)
    800066c4:	7402                	ld	s0,32(sp)
    800066c6:	64e2                	ld	s1,24(sp)
    800066c8:	6942                	ld	s2,16(sp)
    800066ca:	69a2                	ld	s3,8(sp)
    800066cc:	6a02                	ld	s4,0(sp)
    800066ce:	6145                	addi	sp,sp,48
    800066d0:	8082                	ret
    for(;;)
    800066d2:	a001                	j	800066d2 <uartputc+0xb4>

00000000800066d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800066d4:	1141                	addi	sp,sp,-16
    800066d6:	e422                	sd	s0,8(sp)
    800066d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800066da:	100007b7          	lui	a5,0x10000
    800066de:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800066e2:	8b85                	andi	a5,a5,1
    800066e4:	cb91                	beqz	a5,800066f8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800066e6:	100007b7          	lui	a5,0x10000
    800066ea:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800066ee:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800066f2:	6422                	ld	s0,8(sp)
    800066f4:	0141                	addi	sp,sp,16
    800066f6:	8082                	ret
    return -1;
    800066f8:	557d                	li	a0,-1
    800066fa:	bfe5                	j	800066f2 <uartgetc+0x1e>

00000000800066fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800066fc:	1101                	addi	sp,sp,-32
    800066fe:	ec06                	sd	ra,24(sp)
    80006700:	e822                	sd	s0,16(sp)
    80006702:	e426                	sd	s1,8(sp)
    80006704:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006706:	54fd                	li	s1,-1
    int c = uartgetc();
    80006708:	00000097          	auipc	ra,0x0
    8000670c:	fcc080e7          	jalr	-52(ra) # 800066d4 <uartgetc>
    if(c == -1)
    80006710:	00950763          	beq	a0,s1,8000671e <uartintr+0x22>
      break;
    consoleintr(c);
    80006714:	00000097          	auipc	ra,0x0
    80006718:	8fe080e7          	jalr	-1794(ra) # 80006012 <consoleintr>
  while(1){
    8000671c:	b7f5                	j	80006708 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000671e:	00020497          	auipc	s1,0x20
    80006722:	59a48493          	addi	s1,s1,1434 # 80026cb8 <uart_tx_lock>
    80006726:	8526                	mv	a0,s1
    80006728:	00000097          	auipc	ra,0x0
    8000672c:	09e080e7          	jalr	158(ra) # 800067c6 <acquire>
  uartstart();
    80006730:	00000097          	auipc	ra,0x0
    80006734:	e64080e7          	jalr	-412(ra) # 80006594 <uartstart>
  release(&uart_tx_lock);
    80006738:	8526                	mv	a0,s1
    8000673a:	00000097          	auipc	ra,0x0
    8000673e:	15c080e7          	jalr	348(ra) # 80006896 <release>
}
    80006742:	60e2                	ld	ra,24(sp)
    80006744:	6442                	ld	s0,16(sp)
    80006746:	64a2                	ld	s1,8(sp)
    80006748:	6105                	addi	sp,sp,32
    8000674a:	8082                	ret

000000008000674c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000674c:	411c                	lw	a5,0(a0)
    8000674e:	e399                	bnez	a5,80006754 <holding+0x8>
    80006750:	4501                	li	a0,0
  return r;
}
    80006752:	8082                	ret
{
    80006754:	1101                	addi	sp,sp,-32
    80006756:	ec06                	sd	ra,24(sp)
    80006758:	e822                	sd	s0,16(sp)
    8000675a:	e426                	sd	s1,8(sp)
    8000675c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000675e:	6904                	ld	s1,16(a0)
    80006760:	ffffb097          	auipc	ra,0xffffb
    80006764:	87a080e7          	jalr	-1926(ra) # 80000fda <mycpu>
    80006768:	40a48533          	sub	a0,s1,a0
    8000676c:	00153513          	seqz	a0,a0
}
    80006770:	60e2                	ld	ra,24(sp)
    80006772:	6442                	ld	s0,16(sp)
    80006774:	64a2                	ld	s1,8(sp)
    80006776:	6105                	addi	sp,sp,32
    80006778:	8082                	ret

000000008000677a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000677a:	1101                	addi	sp,sp,-32
    8000677c:	ec06                	sd	ra,24(sp)
    8000677e:	e822                	sd	s0,16(sp)
    80006780:	e426                	sd	s1,8(sp)
    80006782:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006784:	100024f3          	csrr	s1,sstatus
    80006788:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000678c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000678e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006792:	ffffb097          	auipc	ra,0xffffb
    80006796:	848080e7          	jalr	-1976(ra) # 80000fda <mycpu>
    8000679a:	5d3c                	lw	a5,120(a0)
    8000679c:	cf89                	beqz	a5,800067b6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000679e:	ffffb097          	auipc	ra,0xffffb
    800067a2:	83c080e7          	jalr	-1988(ra) # 80000fda <mycpu>
    800067a6:	5d3c                	lw	a5,120(a0)
    800067a8:	2785                	addiw	a5,a5,1
    800067aa:	dd3c                	sw	a5,120(a0)
}
    800067ac:	60e2                	ld	ra,24(sp)
    800067ae:	6442                	ld	s0,16(sp)
    800067b0:	64a2                	ld	s1,8(sp)
    800067b2:	6105                	addi	sp,sp,32
    800067b4:	8082                	ret
    mycpu()->intena = old;
    800067b6:	ffffb097          	auipc	ra,0xffffb
    800067ba:	824080e7          	jalr	-2012(ra) # 80000fda <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800067be:	8085                	srli	s1,s1,0x1
    800067c0:	8885                	andi	s1,s1,1
    800067c2:	dd64                	sw	s1,124(a0)
    800067c4:	bfe9                	j	8000679e <push_off+0x24>

00000000800067c6 <acquire>:
{
    800067c6:	1101                	addi	sp,sp,-32
    800067c8:	ec06                	sd	ra,24(sp)
    800067ca:	e822                	sd	s0,16(sp)
    800067cc:	e426                	sd	s1,8(sp)
    800067ce:	1000                	addi	s0,sp,32
    800067d0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800067d2:	00000097          	auipc	ra,0x0
    800067d6:	fa8080e7          	jalr	-88(ra) # 8000677a <push_off>
  if(holding(lk))
    800067da:	8526                	mv	a0,s1
    800067dc:	00000097          	auipc	ra,0x0
    800067e0:	f70080e7          	jalr	-144(ra) # 8000674c <holding>
    800067e4:	e911                	bnez	a0,800067f8 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800067e6:	4785                	li	a5,1
    800067e8:	01c48713          	addi	a4,s1,28
    800067ec:	0f50000f          	fence	iorw,ow
    800067f0:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800067f4:	4705                	li	a4,1
    800067f6:	a839                	j	80006814 <acquire+0x4e>
    panic("acquire");
    800067f8:	00002517          	auipc	a0,0x2
    800067fc:	09850513          	addi	a0,a0,152 # 80008890 <digits+0x20>
    80006800:	00000097          	auipc	ra,0x0
    80006804:	a92080e7          	jalr	-1390(ra) # 80006292 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006808:	01848793          	addi	a5,s1,24
    8000680c:	0f50000f          	fence	iorw,ow
    80006810:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006814:	87ba                	mv	a5,a4
    80006816:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000681a:	2781                	sext.w	a5,a5
    8000681c:	f7f5                	bnez	a5,80006808 <acquire+0x42>
  __sync_synchronize();
    8000681e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006822:	ffffa097          	auipc	ra,0xffffa
    80006826:	7b8080e7          	jalr	1976(ra) # 80000fda <mycpu>
    8000682a:	e888                	sd	a0,16(s1)
}
    8000682c:	60e2                	ld	ra,24(sp)
    8000682e:	6442                	ld	s0,16(sp)
    80006830:	64a2                	ld	s1,8(sp)
    80006832:	6105                	addi	sp,sp,32
    80006834:	8082                	ret

0000000080006836 <pop_off>:

void
pop_off(void)
{
    80006836:	1141                	addi	sp,sp,-16
    80006838:	e406                	sd	ra,8(sp)
    8000683a:	e022                	sd	s0,0(sp)
    8000683c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000683e:	ffffa097          	auipc	ra,0xffffa
    80006842:	79c080e7          	jalr	1948(ra) # 80000fda <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006846:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000684a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000684c:	e78d                	bnez	a5,80006876 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000684e:	5d3c                	lw	a5,120(a0)
    80006850:	02f05b63          	blez	a5,80006886 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006854:	37fd                	addiw	a5,a5,-1
    80006856:	0007871b          	sext.w	a4,a5
    8000685a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000685c:	eb09                	bnez	a4,8000686e <pop_off+0x38>
    8000685e:	5d7c                	lw	a5,124(a0)
    80006860:	c799                	beqz	a5,8000686e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006862:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006866:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000686a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000686e:	60a2                	ld	ra,8(sp)
    80006870:	6402                	ld	s0,0(sp)
    80006872:	0141                	addi	sp,sp,16
    80006874:	8082                	ret
    panic("pop_off - interruptible");
    80006876:	00002517          	auipc	a0,0x2
    8000687a:	02250513          	addi	a0,a0,34 # 80008898 <digits+0x28>
    8000687e:	00000097          	auipc	ra,0x0
    80006882:	a14080e7          	jalr	-1516(ra) # 80006292 <panic>
    panic("pop_off");
    80006886:	00002517          	auipc	a0,0x2
    8000688a:	02a50513          	addi	a0,a0,42 # 800088b0 <digits+0x40>
    8000688e:	00000097          	auipc	ra,0x0
    80006892:	a04080e7          	jalr	-1532(ra) # 80006292 <panic>

0000000080006896 <release>:
{
    80006896:	1101                	addi	sp,sp,-32
    80006898:	ec06                	sd	ra,24(sp)
    8000689a:	e822                	sd	s0,16(sp)
    8000689c:	e426                	sd	s1,8(sp)
    8000689e:	1000                	addi	s0,sp,32
    800068a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800068a2:	00000097          	auipc	ra,0x0
    800068a6:	eaa080e7          	jalr	-342(ra) # 8000674c <holding>
    800068aa:	c115                	beqz	a0,800068ce <release+0x38>
  lk->cpu = 0;
    800068ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800068b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800068b4:	0f50000f          	fence	iorw,ow
    800068b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800068bc:	00000097          	auipc	ra,0x0
    800068c0:	f7a080e7          	jalr	-134(ra) # 80006836 <pop_off>
}
    800068c4:	60e2                	ld	ra,24(sp)
    800068c6:	6442                	ld	s0,16(sp)
    800068c8:	64a2                	ld	s1,8(sp)
    800068ca:	6105                	addi	sp,sp,32
    800068cc:	8082                	ret
    panic("release");
    800068ce:	00002517          	auipc	a0,0x2
    800068d2:	fea50513          	addi	a0,a0,-22 # 800088b8 <digits+0x48>
    800068d6:	00000097          	auipc	ra,0x0
    800068da:	9bc080e7          	jalr	-1604(ra) # 80006292 <panic>

00000000800068de <freelock>:
{
    800068de:	1101                	addi	sp,sp,-32
    800068e0:	ec06                	sd	ra,24(sp)
    800068e2:	e822                	sd	s0,16(sp)
    800068e4:	e426                	sd	s1,8(sp)
    800068e6:	1000                	addi	s0,sp,32
    800068e8:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800068ea:	00020517          	auipc	a0,0x20
    800068ee:	40e50513          	addi	a0,a0,1038 # 80026cf8 <lock_locks>
    800068f2:	00000097          	auipc	ra,0x0
    800068f6:	ed4080e7          	jalr	-300(ra) # 800067c6 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800068fa:	00020717          	auipc	a4,0x20
    800068fe:	41e70713          	addi	a4,a4,1054 # 80026d18 <locks>
    80006902:	4781                	li	a5,0
    80006904:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006908:	6314                	ld	a3,0(a4)
    8000690a:	00968763          	beq	a3,s1,80006918 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    8000690e:	2785                	addiw	a5,a5,1
    80006910:	0721                	addi	a4,a4,8
    80006912:	fec79be3          	bne	a5,a2,80006908 <freelock+0x2a>
    80006916:	a809                	j	80006928 <freelock+0x4a>
      locks[i] = 0;
    80006918:	078e                	slli	a5,a5,0x3
    8000691a:	00020717          	auipc	a4,0x20
    8000691e:	3fe70713          	addi	a4,a4,1022 # 80026d18 <locks>
    80006922:	97ba                	add	a5,a5,a4
    80006924:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006928:	00020517          	auipc	a0,0x20
    8000692c:	3d050513          	addi	a0,a0,976 # 80026cf8 <lock_locks>
    80006930:	00000097          	auipc	ra,0x0
    80006934:	f66080e7          	jalr	-154(ra) # 80006896 <release>
}
    80006938:	60e2                	ld	ra,24(sp)
    8000693a:	6442                	ld	s0,16(sp)
    8000693c:	64a2                	ld	s1,8(sp)
    8000693e:	6105                	addi	sp,sp,32
    80006940:	8082                	ret

0000000080006942 <initlock>:
{
    80006942:	1101                	addi	sp,sp,-32
    80006944:	ec06                	sd	ra,24(sp)
    80006946:	e822                	sd	s0,16(sp)
    80006948:	e426                	sd	s1,8(sp)
    8000694a:	1000                	addi	s0,sp,32
    8000694c:	84aa                	mv	s1,a0
  lk->name = name;
    8000694e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006950:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006954:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006958:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    8000695c:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    80006960:	00020517          	auipc	a0,0x20
    80006964:	39850513          	addi	a0,a0,920 # 80026cf8 <lock_locks>
    80006968:	00000097          	auipc	ra,0x0
    8000696c:	e5e080e7          	jalr	-418(ra) # 800067c6 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006970:	00020717          	auipc	a4,0x20
    80006974:	3a870713          	addi	a4,a4,936 # 80026d18 <locks>
    80006978:	4781                	li	a5,0
    8000697a:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    8000697e:	6310                	ld	a2,0(a4)
    80006980:	ce09                	beqz	a2,8000699a <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    80006982:	2785                	addiw	a5,a5,1
    80006984:	0721                	addi	a4,a4,8
    80006986:	fed79ce3          	bne	a5,a3,8000697e <initlock+0x3c>
  panic("findslot");
    8000698a:	00002517          	auipc	a0,0x2
    8000698e:	f3650513          	addi	a0,a0,-202 # 800088c0 <digits+0x50>
    80006992:	00000097          	auipc	ra,0x0
    80006996:	900080e7          	jalr	-1792(ra) # 80006292 <panic>
      locks[i] = lk;
    8000699a:	078e                	slli	a5,a5,0x3
    8000699c:	00020717          	auipc	a4,0x20
    800069a0:	37c70713          	addi	a4,a4,892 # 80026d18 <locks>
    800069a4:	97ba                	add	a5,a5,a4
    800069a6:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    800069a8:	00020517          	auipc	a0,0x20
    800069ac:	35050513          	addi	a0,a0,848 # 80026cf8 <lock_locks>
    800069b0:	00000097          	auipc	ra,0x0
    800069b4:	ee6080e7          	jalr	-282(ra) # 80006896 <release>
}
    800069b8:	60e2                	ld	ra,24(sp)
    800069ba:	6442                	ld	s0,16(sp)
    800069bc:	64a2                	ld	s1,8(sp)
    800069be:	6105                	addi	sp,sp,32
    800069c0:	8082                	ret

00000000800069c2 <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    800069c2:	1141                	addi	sp,sp,-16
    800069c4:	e422                	sd	s0,8(sp)
    800069c6:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800069c8:	0ff0000f          	fence
    800069cc:	4108                	lw	a0,0(a0)
    800069ce:	0ff0000f          	fence
  return val;
}
    800069d2:	2501                	sext.w	a0,a0
    800069d4:	6422                	ld	s0,8(sp)
    800069d6:	0141                	addi	sp,sp,16
    800069d8:	8082                	ret

00000000800069da <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    800069da:	4e5c                	lw	a5,28(a2)
    800069dc:	00f04463          	bgtz	a5,800069e4 <snprint_lock+0xa>
  int n = 0;
    800069e0:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    800069e2:	8082                	ret
{
    800069e4:	1141                	addi	sp,sp,-16
    800069e6:	e406                	sd	ra,8(sp)
    800069e8:	e022                	sd	s0,0(sp)
    800069ea:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    800069ec:	4e18                	lw	a4,24(a2)
    800069ee:	6614                	ld	a3,8(a2)
    800069f0:	00002617          	auipc	a2,0x2
    800069f4:	ee060613          	addi	a2,a2,-288 # 800088d0 <digits+0x60>
    800069f8:	fffff097          	auipc	ra,0xfffff
    800069fc:	1fa080e7          	jalr	506(ra) # 80005bf2 <snprintf>
}
    80006a00:	60a2                	ld	ra,8(sp)
    80006a02:	6402                	ld	s0,0(sp)
    80006a04:	0141                	addi	sp,sp,16
    80006a06:	8082                	ret

0000000080006a08 <statslock>:

int
statslock(char *buf, int sz) {
    80006a08:	7159                	addi	sp,sp,-112
    80006a0a:	f486                	sd	ra,104(sp)
    80006a0c:	f0a2                	sd	s0,96(sp)
    80006a0e:	eca6                	sd	s1,88(sp)
    80006a10:	e8ca                	sd	s2,80(sp)
    80006a12:	e4ce                	sd	s3,72(sp)
    80006a14:	e0d2                	sd	s4,64(sp)
    80006a16:	fc56                	sd	s5,56(sp)
    80006a18:	f85a                	sd	s6,48(sp)
    80006a1a:	f45e                	sd	s7,40(sp)
    80006a1c:	f062                	sd	s8,32(sp)
    80006a1e:	ec66                	sd	s9,24(sp)
    80006a20:	e86a                	sd	s10,16(sp)
    80006a22:	e46e                	sd	s11,8(sp)
    80006a24:	1880                	addi	s0,sp,112
    80006a26:	8aaa                	mv	s5,a0
    80006a28:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    80006a2a:	00020517          	auipc	a0,0x20
    80006a2e:	2ce50513          	addi	a0,a0,718 # 80026cf8 <lock_locks>
    80006a32:	00000097          	auipc	ra,0x0
    80006a36:	d94080e7          	jalr	-620(ra) # 800067c6 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a3a:	00002617          	auipc	a2,0x2
    80006a3e:	ec660613          	addi	a2,a2,-314 # 80008900 <digits+0x90>
    80006a42:	85da                	mv	a1,s6
    80006a44:	8556                	mv	a0,s5
    80006a46:	fffff097          	auipc	ra,0xfffff
    80006a4a:	1ac080e7          	jalr	428(ra) # 80005bf2 <snprintf>
    80006a4e:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006a50:	00020c97          	auipc	s9,0x20
    80006a54:	2c8c8c93          	addi	s9,s9,712 # 80026d18 <locks>
    80006a58:	00021c17          	auipc	s8,0x21
    80006a5c:	260c0c13          	addi	s8,s8,608 # 80027cb8 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a60:	84e6                	mv	s1,s9
  int tot = 0;
    80006a62:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a64:	00002b97          	auipc	s7,0x2
    80006a68:	ebcb8b93          	addi	s7,s7,-324 # 80008920 <digits+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a6c:	00001d17          	auipc	s10,0x1
    80006a70:	5acd0d13          	addi	s10,s10,1452 # 80008018 <etext+0x18>
    80006a74:	a01d                	j	80006a9a <statslock+0x92>
      tot += locks[i]->nts;
    80006a76:	0009b603          	ld	a2,0(s3)
    80006a7a:	4e1c                	lw	a5,24(a2)
    80006a7c:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006a80:	412b05bb          	subw	a1,s6,s2
    80006a84:	012a8533          	add	a0,s5,s2
    80006a88:	00000097          	auipc	ra,0x0
    80006a8c:	f52080e7          	jalr	-174(ra) # 800069da <snprint_lock>
    80006a90:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006a94:	04a1                	addi	s1,s1,8
    80006a96:	05848763          	beq	s1,s8,80006ae4 <statslock+0xdc>
    if(locks[i] == 0)
    80006a9a:	89a6                	mv	s3,s1
    80006a9c:	609c                	ld	a5,0(s1)
    80006a9e:	c3b9                	beqz	a5,80006ae4 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006aa0:	0087bd83          	ld	s11,8(a5)
    80006aa4:	855e                	mv	a0,s7
    80006aa6:	ffffa097          	auipc	ra,0xffffa
    80006aaa:	98c080e7          	jalr	-1652(ra) # 80000432 <strlen>
    80006aae:	0005061b          	sext.w	a2,a0
    80006ab2:	85de                	mv	a1,s7
    80006ab4:	856e                	mv	a0,s11
    80006ab6:	ffffa097          	auipc	ra,0xffffa
    80006aba:	8d0080e7          	jalr	-1840(ra) # 80000386 <strncmp>
    80006abe:	dd45                	beqz	a0,80006a76 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006ac0:	609c                	ld	a5,0(s1)
    80006ac2:	0087bd83          	ld	s11,8(a5)
    80006ac6:	856a                	mv	a0,s10
    80006ac8:	ffffa097          	auipc	ra,0xffffa
    80006acc:	96a080e7          	jalr	-1686(ra) # 80000432 <strlen>
    80006ad0:	0005061b          	sext.w	a2,a0
    80006ad4:	85ea                	mv	a1,s10
    80006ad6:	856e                	mv	a0,s11
    80006ad8:	ffffa097          	auipc	ra,0xffffa
    80006adc:	8ae080e7          	jalr	-1874(ra) # 80000386 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006ae0:	f955                	bnez	a0,80006a94 <statslock+0x8c>
    80006ae2:	bf51                	j	80006a76 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006ae4:	00002617          	auipc	a2,0x2
    80006ae8:	e4460613          	addi	a2,a2,-444 # 80008928 <digits+0xb8>
    80006aec:	412b05bb          	subw	a1,s6,s2
    80006af0:	012a8533          	add	a0,s5,s2
    80006af4:	fffff097          	auipc	ra,0xfffff
    80006af8:	0fe080e7          	jalr	254(ra) # 80005bf2 <snprintf>
    80006afc:	012509bb          	addw	s3,a0,s2
    80006b00:	4b95                	li	s7,5
  int last = 100000000;
    80006b02:	05f5e537          	lui	a0,0x5f5e
    80006b06:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006b0a:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006b0c:	00020497          	auipc	s1,0x20
    80006b10:	20c48493          	addi	s1,s1,524 # 80026d18 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006b14:	1f400913          	li	s2,500
    80006b18:	a881                	j	80006b68 <statslock+0x160>
    80006b1a:	2705                	addiw	a4,a4,1
    80006b1c:	06a1                	addi	a3,a3,8
    80006b1e:	03270063          	beq	a4,s2,80006b3e <statslock+0x136>
      if(locks[i] == 0)
    80006b22:	629c                	ld	a5,0(a3)
    80006b24:	cf89                	beqz	a5,80006b3e <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006b26:	4f90                	lw	a2,24(a5)
    80006b28:	00359793          	slli	a5,a1,0x3
    80006b2c:	97a6                	add	a5,a5,s1
    80006b2e:	639c                	ld	a5,0(a5)
    80006b30:	4f9c                	lw	a5,24(a5)
    80006b32:	fec7d4e3          	bge	a5,a2,80006b1a <statslock+0x112>
    80006b36:	fea652e3          	bge	a2,a0,80006b1a <statslock+0x112>
    80006b3a:	85ba                	mv	a1,a4
    80006b3c:	bff9                	j	80006b1a <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006b3e:	058e                	slli	a1,a1,0x3
    80006b40:	00b48d33          	add	s10,s1,a1
    80006b44:	000d3603          	ld	a2,0(s10)
    80006b48:	413b05bb          	subw	a1,s6,s3
    80006b4c:	013a8533          	add	a0,s5,s3
    80006b50:	00000097          	auipc	ra,0x0
    80006b54:	e8a080e7          	jalr	-374(ra) # 800069da <snprint_lock>
    80006b58:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006b5c:	000d3783          	ld	a5,0(s10)
    80006b60:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006b62:	3bfd                	addiw	s7,s7,-1
    80006b64:	000b8663          	beqz	s7,80006b70 <statslock+0x168>
  int tot = 0;
    80006b68:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006b6a:	8762                	mv	a4,s8
    int top = 0;
    80006b6c:	85e2                	mv	a1,s8
    80006b6e:	bf55                	j	80006b22 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006b70:	86d2                	mv	a3,s4
    80006b72:	00002617          	auipc	a2,0x2
    80006b76:	dd660613          	addi	a2,a2,-554 # 80008948 <digits+0xd8>
    80006b7a:	413b05bb          	subw	a1,s6,s3
    80006b7e:	013a8533          	add	a0,s5,s3
    80006b82:	fffff097          	auipc	ra,0xfffff
    80006b86:	070080e7          	jalr	112(ra) # 80005bf2 <snprintf>
    80006b8a:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006b8e:	00020517          	auipc	a0,0x20
    80006b92:	16a50513          	addi	a0,a0,362 # 80026cf8 <lock_locks>
    80006b96:	00000097          	auipc	ra,0x0
    80006b9a:	d00080e7          	jalr	-768(ra) # 80006896 <release>
  return n;
}
    80006b9e:	854e                	mv	a0,s3
    80006ba0:	70a6                	ld	ra,104(sp)
    80006ba2:	7406                	ld	s0,96(sp)
    80006ba4:	64e6                	ld	s1,88(sp)
    80006ba6:	6946                	ld	s2,80(sp)
    80006ba8:	69a6                	ld	s3,72(sp)
    80006baa:	6a06                	ld	s4,64(sp)
    80006bac:	7ae2                	ld	s5,56(sp)
    80006bae:	7b42                	ld	s6,48(sp)
    80006bb0:	7ba2                	ld	s7,40(sp)
    80006bb2:	7c02                	ld	s8,32(sp)
    80006bb4:	6ce2                	ld	s9,24(sp)
    80006bb6:	6d42                	ld	s10,16(sp)
    80006bb8:	6da2                	ld	s11,8(sp)
    80006bba:	6165                	addi	sp,sp,112
    80006bbc:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
