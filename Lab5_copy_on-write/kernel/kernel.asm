
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8f013103          	ld	sp,-1808(sp) # 800088f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	187050ef          	jal	ra,8000599c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <addrefcount>:
  struct spinlock lock;
  struct run *freelist;
} kmem;

void addrefcount(uint64 pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  if (pa >= PHYSTOP) {
    80000028:	47c5                	li	a5,17
    8000002a:	07ee                	slli	a5,a5,0x1b
    8000002c:	04f57163          	bgeu	a0,a5,8000006e <addrefcount+0x52>
    80000030:	84aa                	mv	s1,a0
    panic("addref: pa too big");
  }
  acquire(&kmem.lock);
    80000032:	00009917          	auipc	s2,0x9
    80000036:	90e90913          	addi	s2,s2,-1778 # 80008940 <kmem>
    8000003a:	854a                	mv	a0,s2
    8000003c:	00006097          	auipc	ra,0x6
    80000040:	360080e7          	jalr	864(ra) # 8000639c <acquire>
  referenceCount[pa/PGSIZE]++;
    80000044:	80b1                	srli	s1,s1,0xc
    80000046:	048a                	slli	s1,s1,0x2
    80000048:	00009797          	auipc	a5,0x9
    8000004c:	91878793          	addi	a5,a5,-1768 # 80008960 <referenceCount>
    80000050:	94be                	add	s1,s1,a5
    80000052:	409c                	lw	a5,0(s1)
    80000054:	2785                	addiw	a5,a5,1
    80000056:	c09c                	sw	a5,0(s1)
  release(&kmem.lock);
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3f6080e7          	jalr	1014(ra) # 80006450 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("addref: pa too big");
    8000006e:	00008517          	auipc	a0,0x8
    80000072:	fa250513          	addi	a0,a0,-94 # 80008010 <etext+0x10>
    80000076:	00006097          	auipc	ra,0x6
    8000007a:	ddc080e7          	jalr	-548(ra) # 80005e52 <panic>

000000008000007e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000007e:	7179                	addi	sp,sp,-48
    80000080:	f406                	sd	ra,40(sp)
    80000082:	f022                	sd	s0,32(sp)
    80000084:	ec26                	sd	s1,24(sp)
    80000086:	e84a                	sd	s2,16(sp)
    80000088:	e44e                	sd	s3,8(sp)
    8000008a:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000008c:	03451793          	slli	a5,a0,0x34
    80000090:	e3bd                	bnez	a5,800000f6 <kfree+0x78>
    80000092:	84aa                	mv	s1,a0
    80000094:	00242797          	auipc	a5,0x242
    80000098:	d1c78793          	addi	a5,a5,-740 # 80241db0 <end>
    8000009c:	04f56d63          	bltu	a0,a5,800000f6 <kfree+0x78>
    800000a0:	47c5                	li	a5,17
    800000a2:	07ee                	slli	a5,a5,0x1b
    800000a4:	04f57963          	bgeu	a0,a5,800000f6 <kfree+0x78>
    panic("kfree");

  acquire(&kmem.lock);
    800000a8:	00009997          	auipc	s3,0x9
    800000ac:	89898993          	addi	s3,s3,-1896 # 80008940 <kmem>
    800000b0:	854e                	mv	a0,s3
    800000b2:	00006097          	auipc	ra,0x6
    800000b6:	2ea080e7          	jalr	746(ra) # 8000639c <acquire>
  referenceCount[(uint64)pa/PGSIZE]--; // new!
    800000ba:	00c4d913          	srli	s2,s1,0xc
    800000be:	00291793          	slli	a5,s2,0x2
    800000c2:	00009917          	auipc	s2,0x9
    800000c6:	89e90913          	addi	s2,s2,-1890 # 80008960 <referenceCount>
    800000ca:	993e                	add	s2,s2,a5
    800000cc:	00092783          	lw	a5,0(s2)
    800000d0:	37fd                	addiw	a5,a5,-1
    800000d2:	00f92023          	sw	a5,0(s2)
  release(&kmem.lock);
    800000d6:	854e                	mv	a0,s3
    800000d8:	00006097          	auipc	ra,0x6
    800000dc:	378080e7          	jalr	888(ra) # 80006450 <release>
  if(referenceCount[(uint64)pa/PGSIZE] > 0) // new!
    800000e0:	00092783          	lw	a5,0(s2)
    800000e4:	02f05163          	blez	a5,80000106 <kfree+0x88>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    800000e8:	70a2                	ld	ra,40(sp)
    800000ea:	7402                	ld	s0,32(sp)
    800000ec:	64e2                	ld	s1,24(sp)
    800000ee:	6942                	ld	s2,16(sp)
    800000f0:	69a2                	ld	s3,8(sp)
    800000f2:	6145                	addi	sp,sp,48
    800000f4:	8082                	ret
    panic("kfree");
    800000f6:	00008517          	auipc	a0,0x8
    800000fa:	f3250513          	addi	a0,a0,-206 # 80008028 <etext+0x28>
    800000fe:	00006097          	auipc	ra,0x6
    80000102:	d54080e7          	jalr	-684(ra) # 80005e52 <panic>
  memset(pa, 1, PGSIZE);
    80000106:	6605                	lui	a2,0x1
    80000108:	4585                	li	a1,1
    8000010a:	8526                	mv	a0,s1
    8000010c:	00000097          	auipc	ra,0x0
    80000110:	144080e7          	jalr	324(ra) # 80000250 <memset>
  acquire(&kmem.lock);
    80000114:	854e                	mv	a0,s3
    80000116:	00006097          	auipc	ra,0x6
    8000011a:	286080e7          	jalr	646(ra) # 8000639c <acquire>
  r->next = kmem.freelist;
    8000011e:	0189b783          	ld	a5,24(s3)
    80000122:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000124:	0099bc23          	sd	s1,24(s3)
  release(&kmem.lock);
    80000128:	854e                	mv	a0,s3
    8000012a:	00006097          	auipc	ra,0x6
    8000012e:	326080e7          	jalr	806(ra) # 80006450 <release>
    80000132:	bf5d                	j	800000e8 <kfree+0x6a>

0000000080000134 <freerange>:
{
    80000134:	7139                	addi	sp,sp,-64
    80000136:	fc06                	sd	ra,56(sp)
    80000138:	f822                	sd	s0,48(sp)
    8000013a:	f426                	sd	s1,40(sp)
    8000013c:	f04a                	sd	s2,32(sp)
    8000013e:	ec4e                	sd	s3,24(sp)
    80000140:	e852                	sd	s4,16(sp)
    80000142:	e456                	sd	s5,8(sp)
    80000144:	e05a                	sd	s6,0(sp)
    80000146:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000148:	6785                	lui	a5,0x1
    8000014a:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000014e:	9526                	add	a0,a0,s1
    80000150:	74fd                	lui	s1,0xfffff
    80000152:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000154:	97a6                	add	a5,a5,s1
    80000156:	02f5ea63          	bltu	a1,a5,8000018a <freerange+0x56>
    8000015a:	892e                	mv	s2,a1
    referenceCount[(uint64)p/PGSIZE] = 1; //newnew!
    8000015c:	00009b17          	auipc	s6,0x9
    80000160:	804b0b13          	addi	s6,s6,-2044 # 80008960 <referenceCount>
    80000164:	4a85                	li	s5,1
    80000166:	6a05                	lui	s4,0x1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000168:	6989                	lui	s3,0x2
    referenceCount[(uint64)p/PGSIZE] = 1; //newnew!
    8000016a:	00c4d793          	srli	a5,s1,0xc
    8000016e:	078a                	slli	a5,a5,0x2
    80000170:	97da                	add	a5,a5,s6
    80000172:	0157a023          	sw	s5,0(a5)
    kfree(p);
    80000176:	8526                	mv	a0,s1
    80000178:	00000097          	auipc	ra,0x0
    8000017c:	f06080e7          	jalr	-250(ra) # 8000007e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000180:	87a6                	mv	a5,s1
    80000182:	94d2                	add	s1,s1,s4
    80000184:	97ce                	add	a5,a5,s3
    80000186:	fef972e3          	bgeu	s2,a5,8000016a <freerange+0x36>
}
    8000018a:	70e2                	ld	ra,56(sp)
    8000018c:	7442                	ld	s0,48(sp)
    8000018e:	74a2                	ld	s1,40(sp)
    80000190:	7902                	ld	s2,32(sp)
    80000192:	69e2                	ld	s3,24(sp)
    80000194:	6a42                	ld	s4,16(sp)
    80000196:	6aa2                	ld	s5,8(sp)
    80000198:	6b02                	ld	s6,0(sp)
    8000019a:	6121                	addi	sp,sp,64
    8000019c:	8082                	ret

000000008000019e <kinit>:
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e406                	sd	ra,8(sp)
    800001a2:	e022                	sd	s0,0(sp)
    800001a4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001a6:	00008597          	auipc	a1,0x8
    800001aa:	e8a58593          	addi	a1,a1,-374 # 80008030 <etext+0x30>
    800001ae:	00008517          	auipc	a0,0x8
    800001b2:	79250513          	addi	a0,a0,1938 # 80008940 <kmem>
    800001b6:	00006097          	auipc	ra,0x6
    800001ba:	156080e7          	jalr	342(ra) # 8000630c <initlock>
  freerange(end, (void*)PHYSTOP);
    800001be:	45c5                	li	a1,17
    800001c0:	05ee                	slli	a1,a1,0x1b
    800001c2:	00242517          	auipc	a0,0x242
    800001c6:	bee50513          	addi	a0,a0,-1042 # 80241db0 <end>
    800001ca:	00000097          	auipc	ra,0x0
    800001ce:	f6a080e7          	jalr	-150(ra) # 80000134 <freerange>
}
    800001d2:	60a2                	ld	ra,8(sp)
    800001d4:	6402                	ld	s0,0(sp)
    800001d6:	0141                	addi	sp,sp,16
    800001d8:	8082                	ret

00000000800001da <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001da:	1101                	addi	sp,sp,-32
    800001dc:	ec06                	sd	ra,24(sp)
    800001de:	e822                	sd	s0,16(sp)
    800001e0:	e426                	sd	s1,8(sp)
    800001e2:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001e4:	00008497          	auipc	s1,0x8
    800001e8:	75c48493          	addi	s1,s1,1884 # 80008940 <kmem>
    800001ec:	8526                	mv	a0,s1
    800001ee:	00006097          	auipc	ra,0x6
    800001f2:	1ae080e7          	jalr	430(ra) # 8000639c <acquire>
  r = kmem.freelist;
    800001f6:	6c84                	ld	s1,24(s1)
  if(r){
    800001f8:	c0b9                	beqz	s1,8000023e <kalloc+0x64>
    kmem.freelist = r->next;
    800001fa:	609c                	ld	a5,0(s1)
    800001fc:	00008517          	auipc	a0,0x8
    80000200:	74450513          	addi	a0,a0,1860 # 80008940 <kmem>
    80000204:	ed1c                	sd	a5,24(a0)
  }
  release(&kmem.lock);
    80000206:	00006097          	auipc	ra,0x6
    8000020a:	24a080e7          	jalr	586(ra) # 80006450 <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000020e:	6605                	lui	a2,0x1
    80000210:	4595                	li	a1,5
    80000212:	8526                	mv	a0,s1
    80000214:	00000097          	auipc	ra,0x0
    80000218:	03c080e7          	jalr	60(ra) # 80000250 <memset>
    referenceCount[(uint64)r/PGSIZE] = 1; //newnew!
    8000021c:	00c4d793          	srli	a5,s1,0xc
    80000220:	00279713          	slli	a4,a5,0x2
    80000224:	00008797          	auipc	a5,0x8
    80000228:	73c78793          	addi	a5,a5,1852 # 80008960 <referenceCount>
    8000022c:	97ba                	add	a5,a5,a4
    8000022e:	4705                	li	a4,1
    80000230:	c398                	sw	a4,0(a5)
  }
  return (void*)r;
}
    80000232:	8526                	mv	a0,s1
    80000234:	60e2                	ld	ra,24(sp)
    80000236:	6442                	ld	s0,16(sp)
    80000238:	64a2                	ld	s1,8(sp)
    8000023a:	6105                	addi	sp,sp,32
    8000023c:	8082                	ret
  release(&kmem.lock);
    8000023e:	00008517          	auipc	a0,0x8
    80000242:	70250513          	addi	a0,a0,1794 # 80008940 <kmem>
    80000246:	00006097          	auipc	ra,0x6
    8000024a:	20a080e7          	jalr	522(ra) # 80006450 <release>
  if(r){
    8000024e:	b7d5                	j	80000232 <kalloc+0x58>

0000000080000250 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000256:	ce09                	beqz	a2,80000270 <memset+0x20>
    80000258:	87aa                	mv	a5,a0
    8000025a:	fff6071b          	addiw	a4,a2,-1
    8000025e:	1702                	slli	a4,a4,0x20
    80000260:	9301                	srli	a4,a4,0x20
    80000262:	0705                	addi	a4,a4,1
    80000264:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000266:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000026a:	0785                	addi	a5,a5,1
    8000026c:	fee79de3          	bne	a5,a4,80000266 <memset+0x16>
  }
  return dst;
}
    80000270:	6422                	ld	s0,8(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret

0000000080000276 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000027c:	ca05                	beqz	a2,800002ac <memcmp+0x36>
    8000027e:	fff6069b          	addiw	a3,a2,-1
    80000282:	1682                	slli	a3,a3,0x20
    80000284:	9281                	srli	a3,a3,0x20
    80000286:	0685                	addi	a3,a3,1
    80000288:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000028a:	00054783          	lbu	a5,0(a0)
    8000028e:	0005c703          	lbu	a4,0(a1)
    80000292:	00e79863          	bne	a5,a4,800002a2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000296:	0505                	addi	a0,a0,1
    80000298:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000029a:	fed518e3          	bne	a0,a3,8000028a <memcmp+0x14>
  }

  return 0;
    8000029e:	4501                	li	a0,0
    800002a0:	a019                	j	800002a6 <memcmp+0x30>
      return *s1 - *s2;
    800002a2:	40e7853b          	subw	a0,a5,a4
}
    800002a6:	6422                	ld	s0,8(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret
  return 0;
    800002ac:	4501                	li	a0,0
    800002ae:	bfe5                	j	800002a6 <memcmp+0x30>

00000000800002b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002b0:	1141                	addi	sp,sp,-16
    800002b2:	e422                	sd	s0,8(sp)
    800002b4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002b6:	ca0d                	beqz	a2,800002e8 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002b8:	00a5f963          	bgeu	a1,a0,800002ca <memmove+0x1a>
    800002bc:	02061693          	slli	a3,a2,0x20
    800002c0:	9281                	srli	a3,a3,0x20
    800002c2:	00d58733          	add	a4,a1,a3
    800002c6:	02e56463          	bltu	a0,a4,800002ee <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002ca:	fff6079b          	addiw	a5,a2,-1
    800002ce:	1782                	slli	a5,a5,0x20
    800002d0:	9381                	srli	a5,a5,0x20
    800002d2:	0785                	addi	a5,a5,1
    800002d4:	97ae                	add	a5,a5,a1
    800002d6:	872a                	mv	a4,a0
      *d++ = *s++;
    800002d8:	0585                	addi	a1,a1,1
    800002da:	0705                	addi	a4,a4,1
    800002dc:	fff5c683          	lbu	a3,-1(a1)
    800002e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002e4:	fef59ae3          	bne	a1,a5,800002d8 <memmove+0x28>

  return dst;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret
    d += n;
    800002ee:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002f0:	fff6079b          	addiw	a5,a2,-1
    800002f4:	1782                	slli	a5,a5,0x20
    800002f6:	9381                	srli	a5,a5,0x20
    800002f8:	fff7c793          	not	a5,a5
    800002fc:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002fe:	177d                	addi	a4,a4,-1
    80000300:	16fd                	addi	a3,a3,-1
    80000302:	00074603          	lbu	a2,0(a4)
    80000306:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000030a:	fef71ae3          	bne	a4,a5,800002fe <memmove+0x4e>
    8000030e:	bfe9                	j	800002e8 <memmove+0x38>

0000000080000310 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000310:	1141                	addi	sp,sp,-16
    80000312:	e406                	sd	ra,8(sp)
    80000314:	e022                	sd	s0,0(sp)
    80000316:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000318:	00000097          	auipc	ra,0x0
    8000031c:	f98080e7          	jalr	-104(ra) # 800002b0 <memmove>
}
    80000320:	60a2                	ld	ra,8(sp)
    80000322:	6402                	ld	s0,0(sp)
    80000324:	0141                	addi	sp,sp,16
    80000326:	8082                	ret

0000000080000328 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000328:	1141                	addi	sp,sp,-16
    8000032a:	e422                	sd	s0,8(sp)
    8000032c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000032e:	ce11                	beqz	a2,8000034a <strncmp+0x22>
    80000330:	00054783          	lbu	a5,0(a0)
    80000334:	cf89                	beqz	a5,8000034e <strncmp+0x26>
    80000336:	0005c703          	lbu	a4,0(a1)
    8000033a:	00f71a63          	bne	a4,a5,8000034e <strncmp+0x26>
    n--, p++, q++;
    8000033e:	367d                	addiw	a2,a2,-1
    80000340:	0505                	addi	a0,a0,1
    80000342:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000344:	f675                	bnez	a2,80000330 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000346:	4501                	li	a0,0
    80000348:	a809                	j	8000035a <strncmp+0x32>
    8000034a:	4501                	li	a0,0
    8000034c:	a039                	j	8000035a <strncmp+0x32>
  if(n == 0)
    8000034e:	ca09                	beqz	a2,80000360 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000350:	00054503          	lbu	a0,0(a0)
    80000354:	0005c783          	lbu	a5,0(a1)
    80000358:	9d1d                	subw	a0,a0,a5
}
    8000035a:	6422                	ld	s0,8(sp)
    8000035c:	0141                	addi	sp,sp,16
    8000035e:	8082                	ret
    return 0;
    80000360:	4501                	li	a0,0
    80000362:	bfe5                	j	8000035a <strncmp+0x32>

0000000080000364 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000364:	1141                	addi	sp,sp,-16
    80000366:	e422                	sd	s0,8(sp)
    80000368:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000036a:	872a                	mv	a4,a0
    8000036c:	8832                	mv	a6,a2
    8000036e:	367d                	addiw	a2,a2,-1
    80000370:	01005963          	blez	a6,80000382 <strncpy+0x1e>
    80000374:	0705                	addi	a4,a4,1
    80000376:	0005c783          	lbu	a5,0(a1)
    8000037a:	fef70fa3          	sb	a5,-1(a4)
    8000037e:	0585                	addi	a1,a1,1
    80000380:	f7f5                	bnez	a5,8000036c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000382:	00c05d63          	blez	a2,8000039c <strncpy+0x38>
    80000386:	86ba                	mv	a3,a4
    *s++ = 0;
    80000388:	0685                	addi	a3,a3,1
    8000038a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000038e:	fff6c793          	not	a5,a3
    80000392:	9fb9                	addw	a5,a5,a4
    80000394:	010787bb          	addw	a5,a5,a6
    80000398:	fef048e3          	bgtz	a5,80000388 <strncpy+0x24>
  return os;
}
    8000039c:	6422                	ld	s0,8(sp)
    8000039e:	0141                	addi	sp,sp,16
    800003a0:	8082                	ret

00000000800003a2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003a2:	1141                	addi	sp,sp,-16
    800003a4:	e422                	sd	s0,8(sp)
    800003a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003a8:	02c05363          	blez	a2,800003ce <safestrcpy+0x2c>
    800003ac:	fff6069b          	addiw	a3,a2,-1
    800003b0:	1682                	slli	a3,a3,0x20
    800003b2:	9281                	srli	a3,a3,0x20
    800003b4:	96ae                	add	a3,a3,a1
    800003b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003b8:	00d58963          	beq	a1,a3,800003ca <safestrcpy+0x28>
    800003bc:	0585                	addi	a1,a1,1
    800003be:	0785                	addi	a5,a5,1
    800003c0:	fff5c703          	lbu	a4,-1(a1)
    800003c4:	fee78fa3          	sb	a4,-1(a5)
    800003c8:	fb65                	bnez	a4,800003b8 <safestrcpy+0x16>
    ;
  *s = 0;
    800003ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800003ce:	6422                	ld	s0,8(sp)
    800003d0:	0141                	addi	sp,sp,16
    800003d2:	8082                	ret

00000000800003d4 <strlen>:

int
strlen(const char *s)
{
    800003d4:	1141                	addi	sp,sp,-16
    800003d6:	e422                	sd	s0,8(sp)
    800003d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003da:	00054783          	lbu	a5,0(a0)
    800003de:	cf91                	beqz	a5,800003fa <strlen+0x26>
    800003e0:	0505                	addi	a0,a0,1
    800003e2:	87aa                	mv	a5,a0
    800003e4:	4685                	li	a3,1
    800003e6:	9e89                	subw	a3,a3,a0
    800003e8:	00f6853b          	addw	a0,a3,a5
    800003ec:	0785                	addi	a5,a5,1
    800003ee:	fff7c703          	lbu	a4,-1(a5)
    800003f2:	fb7d                	bnez	a4,800003e8 <strlen+0x14>
    ;
  return n;
}
    800003f4:	6422                	ld	s0,8(sp)
    800003f6:	0141                	addi	sp,sp,16
    800003f8:	8082                	ret
  for(n = 0; s[n]; n++)
    800003fa:	4501                	li	a0,0
    800003fc:	bfe5                	j	800003f4 <strlen+0x20>

00000000800003fe <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003fe:	1141                	addi	sp,sp,-16
    80000400:	e406                	sd	ra,8(sp)
    80000402:	e022                	sd	s0,0(sp)
    80000404:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000406:	00001097          	auipc	ra,0x1
    8000040a:	bc4080e7          	jalr	-1084(ra) # 80000fca <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000040e:	00008717          	auipc	a4,0x8
    80000412:	50270713          	addi	a4,a4,1282 # 80008910 <started>
  if(cpuid() == 0){
    80000416:	c139                	beqz	a0,8000045c <main+0x5e>
    while(started == 0)
    80000418:	431c                	lw	a5,0(a4)
    8000041a:	2781                	sext.w	a5,a5
    8000041c:	dff5                	beqz	a5,80000418 <main+0x1a>
      ;
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000422:	00001097          	auipc	ra,0x1
    80000426:	ba8080e7          	jalr	-1112(ra) # 80000fca <cpuid>
    8000042a:	85aa                	mv	a1,a0
    8000042c:	00008517          	auipc	a0,0x8
    80000430:	c2450513          	addi	a0,a0,-988 # 80008050 <etext+0x50>
    80000434:	00006097          	auipc	ra,0x6
    80000438:	a68080e7          	jalr	-1432(ra) # 80005e9c <printf>
    kvminithart();    // turn on paging
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	0d8080e7          	jalr	216(ra) # 80000514 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000444:	00002097          	auipc	ra,0x2
    80000448:	84e080e7          	jalr	-1970(ra) # 80001c92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000044c:	00005097          	auipc	ra,0x5
    80000450:	ea4080e7          	jalr	-348(ra) # 800052f0 <plicinithart>
  }

  scheduler();        
    80000454:	00001097          	auipc	ra,0x1
    80000458:	098080e7          	jalr	152(ra) # 800014ec <scheduler>
    consoleinit();
    8000045c:	00006097          	auipc	ra,0x6
    80000460:	908080e7          	jalr	-1784(ra) # 80005d64 <consoleinit>
    printfinit();
    80000464:	00006097          	auipc	ra,0x6
    80000468:	c1e080e7          	jalr	-994(ra) # 80006082 <printfinit>
    printf("\n");
    8000046c:	00008517          	auipc	a0,0x8
    80000470:	bf450513          	addi	a0,a0,-1036 # 80008060 <etext+0x60>
    80000474:	00006097          	auipc	ra,0x6
    80000478:	a28080e7          	jalr	-1496(ra) # 80005e9c <printf>
    printf("xv6 kernel is booting\n");
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bbc50513          	addi	a0,a0,-1092 # 80008038 <etext+0x38>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	a18080e7          	jalr	-1512(ra) # 80005e9c <printf>
    printf("\n");
    8000048c:	00008517          	auipc	a0,0x8
    80000490:	bd450513          	addi	a0,a0,-1068 # 80008060 <etext+0x60>
    80000494:	00006097          	auipc	ra,0x6
    80000498:	a08080e7          	jalr	-1528(ra) # 80005e9c <printf>
    kinit();         // physical page allocator
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	d02080e7          	jalr	-766(ra) # 8000019e <kinit>
    kvminit();       // create kernel page table
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	34a080e7          	jalr	842(ra) # 800007ee <kvminit>
    kvminithart();   // turn on paging
    800004ac:	00000097          	auipc	ra,0x0
    800004b0:	068080e7          	jalr	104(ra) # 80000514 <kvminithart>
    procinit();      // process table
    800004b4:	00001097          	auipc	ra,0x1
    800004b8:	a62080e7          	jalr	-1438(ra) # 80000f16 <procinit>
    trapinit();      // trap vectors
    800004bc:	00001097          	auipc	ra,0x1
    800004c0:	7ae080e7          	jalr	1966(ra) # 80001c6a <trapinit>
    trapinithart();  // install kernel trap vector
    800004c4:	00001097          	auipc	ra,0x1
    800004c8:	7ce080e7          	jalr	1998(ra) # 80001c92 <trapinithart>
    plicinit();      // set up interrupt controller
    800004cc:	00005097          	auipc	ra,0x5
    800004d0:	e0e080e7          	jalr	-498(ra) # 800052da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004d4:	00005097          	auipc	ra,0x5
    800004d8:	e1c080e7          	jalr	-484(ra) # 800052f0 <plicinithart>
    binit();         // buffer cache
    800004dc:	00002097          	auipc	ra,0x2
    800004e0:	fd2080e7          	jalr	-46(ra) # 800024ae <binit>
    iinit();         // inode table
    800004e4:	00002097          	auipc	ra,0x2
    800004e8:	676080e7          	jalr	1654(ra) # 80002b5a <iinit>
    fileinit();      // file table
    800004ec:	00003097          	auipc	ra,0x3
    800004f0:	614080e7          	jalr	1556(ra) # 80003b00 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004f4:	00005097          	auipc	ra,0x5
    800004f8:	f04080e7          	jalr	-252(ra) # 800053f8 <virtio_disk_init>
    userinit();      // first user process
    800004fc:	00001097          	auipc	ra,0x1
    80000500:	dd6080e7          	jalr	-554(ra) # 800012d2 <userinit>
    __sync_synchronize();
    80000504:	0ff0000f          	fence
    started = 1;
    80000508:	4785                	li	a5,1
    8000050a:	00008717          	auipc	a4,0x8
    8000050e:	40f72323          	sw	a5,1030(a4) # 80008910 <started>
    80000512:	b789                	j	80000454 <main+0x56>

0000000080000514 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000514:	1141                	addi	sp,sp,-16
    80000516:	e422                	sd	s0,8(sp)
    80000518:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000051a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000051e:	00008797          	auipc	a5,0x8
    80000522:	3fa7b783          	ld	a5,1018(a5) # 80008918 <kernel_pagetable>
    80000526:	83b1                	srli	a5,a5,0xc
    80000528:	577d                	li	a4,-1
    8000052a:	177e                	slli	a4,a4,0x3f
    8000052c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000052e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000532:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000536:	6422                	ld	s0,8(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret

000000008000053c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000053c:	7139                	addi	sp,sp,-64
    8000053e:	fc06                	sd	ra,56(sp)
    80000540:	f822                	sd	s0,48(sp)
    80000542:	f426                	sd	s1,40(sp)
    80000544:	f04a                	sd	s2,32(sp)
    80000546:	ec4e                	sd	s3,24(sp)
    80000548:	e852                	sd	s4,16(sp)
    8000054a:	e456                	sd	s5,8(sp)
    8000054c:	e05a                	sd	s6,0(sp)
    8000054e:	0080                	addi	s0,sp,64
    80000550:	84aa                	mv	s1,a0
    80000552:	89ae                	mv	s3,a1
    80000554:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000556:	57fd                	li	a5,-1
    80000558:	83e9                	srli	a5,a5,0x1a
    8000055a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000055c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000055e:	04b7f263          	bgeu	a5,a1,800005a2 <walk+0x66>
    panic("walk");
    80000562:	00008517          	auipc	a0,0x8
    80000566:	b0650513          	addi	a0,a0,-1274 # 80008068 <etext+0x68>
    8000056a:	00006097          	auipc	ra,0x6
    8000056e:	8e8080e7          	jalr	-1816(ra) # 80005e52 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000572:	060a8663          	beqz	s5,800005de <walk+0xa2>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	c64080e7          	jalr	-924(ra) # 800001da <kalloc>
    8000057e:	84aa                	mv	s1,a0
    80000580:	c529                	beqz	a0,800005ca <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000582:	6605                	lui	a2,0x1
    80000584:	4581                	li	a1,0
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	cca080e7          	jalr	-822(ra) # 80000250 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000058e:	00c4d793          	srli	a5,s1,0xc
    80000592:	07aa                	slli	a5,a5,0xa
    80000594:	0017e793          	ori	a5,a5,1
    80000598:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000059c:	3a5d                	addiw	s4,s4,-9
    8000059e:	036a0063          	beq	s4,s6,800005be <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005a2:	0149d933          	srl	s2,s3,s4
    800005a6:	1ff97913          	andi	s2,s2,511
    800005aa:	090e                	slli	s2,s2,0x3
    800005ac:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005ae:	00093483          	ld	s1,0(s2)
    800005b2:	0014f793          	andi	a5,s1,1
    800005b6:	dfd5                	beqz	a5,80000572 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005b8:	80a9                	srli	s1,s1,0xa
    800005ba:	04b2                	slli	s1,s1,0xc
    800005bc:	b7c5                	j	8000059c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005be:	00c9d513          	srli	a0,s3,0xc
    800005c2:	1ff57513          	andi	a0,a0,511
    800005c6:	050e                	slli	a0,a0,0x3
    800005c8:	9526                	add	a0,a0,s1
}
    800005ca:	70e2                	ld	ra,56(sp)
    800005cc:	7442                	ld	s0,48(sp)
    800005ce:	74a2                	ld	s1,40(sp)
    800005d0:	7902                	ld	s2,32(sp)
    800005d2:	69e2                	ld	s3,24(sp)
    800005d4:	6a42                	ld	s4,16(sp)
    800005d6:	6aa2                	ld	s5,8(sp)
    800005d8:	6b02                	ld	s6,0(sp)
    800005da:	6121                	addi	sp,sp,64
    800005dc:	8082                	ret
        return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7ed                	j	800005ca <walk+0x8e>

00000000800005e2 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005e2:	57fd                	li	a5,-1
    800005e4:	83e9                	srli	a5,a5,0x1a
    800005e6:	00b7f463          	bgeu	a5,a1,800005ee <walkaddr+0xc>
    return 0;
    800005ea:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005ec:	8082                	ret
{
    800005ee:	1141                	addi	sp,sp,-16
    800005f0:	e406                	sd	ra,8(sp)
    800005f2:	e022                	sd	s0,0(sp)
    800005f4:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005f6:	4601                	li	a2,0
    800005f8:	00000097          	auipc	ra,0x0
    800005fc:	f44080e7          	jalr	-188(ra) # 8000053c <walk>
  if(pte == 0)
    80000600:	c105                	beqz	a0,80000620 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000602:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000604:	0117f693          	andi	a3,a5,17
    80000608:	4745                	li	a4,17
    return 0;
    8000060a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000060c:	00e68663          	beq	a3,a4,80000618 <walkaddr+0x36>
}
    80000610:	60a2                	ld	ra,8(sp)
    80000612:	6402                	ld	s0,0(sp)
    80000614:	0141                	addi	sp,sp,16
    80000616:	8082                	ret
  pa = PTE2PA(*pte);
    80000618:	00a7d513          	srli	a0,a5,0xa
    8000061c:	0532                	slli	a0,a0,0xc
  return pa;
    8000061e:	bfcd                	j	80000610 <walkaddr+0x2e>
    return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7fd                	j	80000610 <walkaddr+0x2e>

0000000080000624 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000624:	715d                	addi	sp,sp,-80
    80000626:	e486                	sd	ra,72(sp)
    80000628:	e0a2                	sd	s0,64(sp)
    8000062a:	fc26                	sd	s1,56(sp)
    8000062c:	f84a                	sd	s2,48(sp)
    8000062e:	f44e                	sd	s3,40(sp)
    80000630:	f052                	sd	s4,32(sp)
    80000632:	ec56                	sd	s5,24(sp)
    80000634:	e85a                	sd	s6,16(sp)
    80000636:	e45e                	sd	s7,8(sp)
    80000638:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000063a:	03459793          	slli	a5,a1,0x34
    8000063e:	e385                	bnez	a5,8000065e <mappages+0x3a>
    80000640:	8aaa                	mv	s5,a0
    80000642:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000644:	03461793          	slli	a5,a2,0x34
    80000648:	e39d                	bnez	a5,8000066e <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    8000064a:	ca15                	beqz	a2,8000067e <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000064c:	79fd                	lui	s3,0xfffff
    8000064e:	964e                	add	a2,a2,s3
    80000650:	00b609b3          	add	s3,a2,a1
  a = va;
    80000654:	892e                	mv	s2,a1
    80000656:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000065a:	6b85                	lui	s7,0x1
    8000065c:	a091                	j	800006a0 <mappages+0x7c>
    panic("mappages: va not aligned");
    8000065e:	00008517          	auipc	a0,0x8
    80000662:	a1250513          	addi	a0,a0,-1518 # 80008070 <etext+0x70>
    80000666:	00005097          	auipc	ra,0x5
    8000066a:	7ec080e7          	jalr	2028(ra) # 80005e52 <panic>
    panic("mappages: size not aligned");
    8000066e:	00008517          	auipc	a0,0x8
    80000672:	a2250513          	addi	a0,a0,-1502 # 80008090 <etext+0x90>
    80000676:	00005097          	auipc	ra,0x5
    8000067a:	7dc080e7          	jalr	2012(ra) # 80005e52 <panic>
    panic("mappages: size");
    8000067e:	00008517          	auipc	a0,0x8
    80000682:	a3250513          	addi	a0,a0,-1486 # 800080b0 <etext+0xb0>
    80000686:	00005097          	auipc	ra,0x5
    8000068a:	7cc080e7          	jalr	1996(ra) # 80005e52 <panic>
      panic("mappages: remap");
    8000068e:	00008517          	auipc	a0,0x8
    80000692:	a3250513          	addi	a0,a0,-1486 # 800080c0 <etext+0xc0>
    80000696:	00005097          	auipc	ra,0x5
    8000069a:	7bc080e7          	jalr	1980(ra) # 80005e52 <panic>
    a += PGSIZE;
    8000069e:	995e                	add	s2,s2,s7
  for(;;){
    800006a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800006a4:	4605                	li	a2,1
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8556                	mv	a0,s5
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	e92080e7          	jalr	-366(ra) # 8000053c <walk>
    800006b2:	cd19                	beqz	a0,800006d0 <mappages+0xac>
    if(*pte & PTE_V)
    800006b4:	611c                	ld	a5,0(a0)
    800006b6:	8b85                	andi	a5,a5,1
    800006b8:	fbf9                	bnez	a5,8000068e <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006ba:	80b1                	srli	s1,s1,0xc
    800006bc:	04aa                	slli	s1,s1,0xa
    800006be:	0164e4b3          	or	s1,s1,s6
    800006c2:	0014e493          	ori	s1,s1,1
    800006c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800006c8:	fd391be3          	bne	s2,s3,8000069e <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    800006cc:	4501                	li	a0,0
    800006ce:	a011                	j	800006d2 <mappages+0xae>
      return -1;
    800006d0:	557d                	li	a0,-1
}
    800006d2:	60a6                	ld	ra,72(sp)
    800006d4:	6406                	ld	s0,64(sp)
    800006d6:	74e2                	ld	s1,56(sp)
    800006d8:	7942                	ld	s2,48(sp)
    800006da:	79a2                	ld	s3,40(sp)
    800006dc:	7a02                	ld	s4,32(sp)
    800006de:	6ae2                	ld	s5,24(sp)
    800006e0:	6b42                	ld	s6,16(sp)
    800006e2:	6ba2                	ld	s7,8(sp)
    800006e4:	6161                	addi	sp,sp,80
    800006e6:	8082                	ret

00000000800006e8 <kvmmap>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
    800006f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006f2:	86b2                	mv	a3,a2
    800006f4:	863e                	mv	a2,a5
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f2e080e7          	jalr	-210(ra) # 80000624 <mappages>
    800006fe:	e509                	bnez	a0,80000708 <kvmmap+0x20>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret
    panic("kvmmap");
    80000708:	00008517          	auipc	a0,0x8
    8000070c:	9c850513          	addi	a0,a0,-1592 # 800080d0 <etext+0xd0>
    80000710:	00005097          	auipc	ra,0x5
    80000714:	742080e7          	jalr	1858(ra) # 80005e52 <panic>

0000000080000718 <kvmmake>:
{
    80000718:	1101                	addi	sp,sp,-32
    8000071a:	ec06                	sd	ra,24(sp)
    8000071c:	e822                	sd	s0,16(sp)
    8000071e:	e426                	sd	s1,8(sp)
    80000720:	e04a                	sd	s2,0(sp)
    80000722:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000724:	00000097          	auipc	ra,0x0
    80000728:	ab6080e7          	jalr	-1354(ra) # 800001da <kalloc>
    8000072c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	00000097          	auipc	ra,0x0
    80000736:	b1e080e7          	jalr	-1250(ra) # 80000250 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000073a:	4719                	li	a4,6
    8000073c:	6685                	lui	a3,0x1
    8000073e:	10000637          	lui	a2,0x10000
    80000742:	100005b7          	lui	a1,0x10000
    80000746:	8526                	mv	a0,s1
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	fa0080e7          	jalr	-96(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000750:	4719                	li	a4,6
    80000752:	6685                	lui	a3,0x1
    80000754:	10001637          	lui	a2,0x10001
    80000758:	100015b7          	lui	a1,0x10001
    8000075c:	8526                	mv	a0,s1
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	f8a080e7          	jalr	-118(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000766:	4719                	li	a4,6
    80000768:	004006b7          	lui	a3,0x400
    8000076c:	0c000637          	lui	a2,0xc000
    80000770:	0c0005b7          	lui	a1,0xc000
    80000774:	8526                	mv	a0,s1
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	f72080e7          	jalr	-142(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000077e:	00008917          	auipc	s2,0x8
    80000782:	88290913          	addi	s2,s2,-1918 # 80008000 <etext>
    80000786:	4729                	li	a4,10
    80000788:	80008697          	auipc	a3,0x80008
    8000078c:	87868693          	addi	a3,a3,-1928 # 8000 <_entry-0x7fff8000>
    80000790:	4605                	li	a2,1
    80000792:	067e                	slli	a2,a2,0x1f
    80000794:	85b2                	mv	a1,a2
    80000796:	8526                	mv	a0,s1
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	f50080e7          	jalr	-176(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007a0:	4719                	li	a4,6
    800007a2:	46c5                	li	a3,17
    800007a4:	06ee                	slli	a3,a3,0x1b
    800007a6:	412686b3          	sub	a3,a3,s2
    800007aa:	864a                	mv	a2,s2
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8526                	mv	a0,s1
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	f38080e7          	jalr	-200(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007b8:	4729                	li	a4,10
    800007ba:	6685                	lui	a3,0x1
    800007bc:	00007617          	auipc	a2,0x7
    800007c0:	84460613          	addi	a2,a2,-1980 # 80007000 <_trampoline>
    800007c4:	040005b7          	lui	a1,0x4000
    800007c8:	15fd                	addi	a1,a1,-1
    800007ca:	05b2                	slli	a1,a1,0xc
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	f1a080e7          	jalr	-230(ra) # 800006e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007d6:	8526                	mv	a0,s1
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	6a8080e7          	jalr	1704(ra) # 80000e80 <proc_mapstacks>
}
    800007e0:	8526                	mv	a0,s1
    800007e2:	60e2                	ld	ra,24(sp)
    800007e4:	6442                	ld	s0,16(sp)
    800007e6:	64a2                	ld	s1,8(sp)
    800007e8:	6902                	ld	s2,0(sp)
    800007ea:	6105                	addi	sp,sp,32
    800007ec:	8082                	ret

00000000800007ee <kvminit>:
{
    800007ee:	1141                	addi	sp,sp,-16
    800007f0:	e406                	sd	ra,8(sp)
    800007f2:	e022                	sd	s0,0(sp)
    800007f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	f22080e7          	jalr	-222(ra) # 80000718 <kvmmake>
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	10a7bd23          	sd	a0,282(a5) # 80008918 <kernel_pagetable>
}
    80000806:	60a2                	ld	ra,8(sp)
    80000808:	6402                	ld	s0,0(sp)
    8000080a:	0141                	addi	sp,sp,16
    8000080c:	8082                	ret

000000008000080e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000080e:	715d                	addi	sp,sp,-80
    80000810:	e486                	sd	ra,72(sp)
    80000812:	e0a2                	sd	s0,64(sp)
    80000814:	fc26                	sd	s1,56(sp)
    80000816:	f84a                	sd	s2,48(sp)
    80000818:	f44e                	sd	s3,40(sp)
    8000081a:	f052                	sd	s4,32(sp)
    8000081c:	ec56                	sd	s5,24(sp)
    8000081e:	e85a                	sd	s6,16(sp)
    80000820:	e45e                	sd	s7,8(sp)
    80000822:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000824:	03459793          	slli	a5,a1,0x34
    80000828:	e795                	bnez	a5,80000854 <uvmunmap+0x46>
    8000082a:	8a2a                	mv	s4,a0
    8000082c:	892e                	mv	s2,a1
    8000082e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000830:	0632                	slli	a2,a2,0xc
    80000832:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000836:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000838:	6b05                	lui	s6,0x1
    8000083a:	0735e863          	bltu	a1,s3,800008aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000083e:	60a6                	ld	ra,72(sp)
    80000840:	6406                	ld	s0,64(sp)
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	7a02                	ld	s4,32(sp)
    8000084a:	6ae2                	ld	s5,24(sp)
    8000084c:	6b42                	ld	s6,16(sp)
    8000084e:	6ba2                	ld	s7,8(sp)
    80000850:	6161                	addi	sp,sp,80
    80000852:	8082                	ret
    panic("uvmunmap: not aligned");
    80000854:	00008517          	auipc	a0,0x8
    80000858:	88450513          	addi	a0,a0,-1916 # 800080d8 <etext+0xd8>
    8000085c:	00005097          	auipc	ra,0x5
    80000860:	5f6080e7          	jalr	1526(ra) # 80005e52 <panic>
      panic("uvmunmap: walk");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	88c50513          	addi	a0,a0,-1908 # 800080f0 <etext+0xf0>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	5e6080e7          	jalr	1510(ra) # 80005e52 <panic>
      panic("uvmunmap: not mapped");
    80000874:	00008517          	auipc	a0,0x8
    80000878:	88c50513          	addi	a0,a0,-1908 # 80008100 <etext+0x100>
    8000087c:	00005097          	auipc	ra,0x5
    80000880:	5d6080e7          	jalr	1494(ra) # 80005e52 <panic>
      panic("uvmunmap: not a leaf");
    80000884:	00008517          	auipc	a0,0x8
    80000888:	89450513          	addi	a0,a0,-1900 # 80008118 <etext+0x118>
    8000088c:	00005097          	auipc	ra,0x5
    80000890:	5c6080e7          	jalr	1478(ra) # 80005e52 <panic>
      uint64 pa = PTE2PA(*pte);
    80000894:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000896:	0532                	slli	a0,a0,0xc
    80000898:	fffff097          	auipc	ra,0xfffff
    8000089c:	7e6080e7          	jalr	2022(ra) # 8000007e <kfree>
    *pte = 0;
    800008a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a4:	995a                	add	s2,s2,s6
    800008a6:	f9397ce3          	bgeu	s2,s3,8000083e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008aa:	4601                	li	a2,0
    800008ac:	85ca                	mv	a1,s2
    800008ae:	8552                	mv	a0,s4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	c8c080e7          	jalr	-884(ra) # 8000053c <walk>
    800008b8:	84aa                	mv	s1,a0
    800008ba:	d54d                	beqz	a0,80000864 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008bc:	6108                	ld	a0,0(a0)
    800008be:	00157793          	andi	a5,a0,1
    800008c2:	dbcd                	beqz	a5,80000874 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c4:	3ff57793          	andi	a5,a0,1023
    800008c8:	fb778ee3          	beq	a5,s7,80000884 <uvmunmap+0x76>
    if(do_free){
    800008cc:	fc0a8ae3          	beqz	s5,800008a0 <uvmunmap+0x92>
    800008d0:	b7d1                	j	80000894 <uvmunmap+0x86>

00000000800008d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008d2:	1101                	addi	sp,sp,-32
    800008d4:	ec06                	sd	ra,24(sp)
    800008d6:	e822                	sd	s0,16(sp)
    800008d8:	e426                	sd	s1,8(sp)
    800008da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	8fe080e7          	jalr	-1794(ra) # 800001da <kalloc>
    800008e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008e6:	c519                	beqz	a0,800008f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008e8:	6605                	lui	a2,0x1
    800008ea:	4581                	li	a1,0
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	964080e7          	jalr	-1692(ra) # 80000250 <memset>
  return pagetable;
}
    800008f4:	8526                	mv	a0,s1
    800008f6:	60e2                	ld	ra,24(sp)
    800008f8:	6442                	ld	s0,16(sp)
    800008fa:	64a2                	ld	s1,8(sp)
    800008fc:	6105                	addi	sp,sp,32
    800008fe:	8082                	ret

0000000080000900 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000900:	7179                	addi	sp,sp,-48
    80000902:	f406                	sd	ra,40(sp)
    80000904:	f022                	sd	s0,32(sp)
    80000906:	ec26                	sd	s1,24(sp)
    80000908:	e84a                	sd	s2,16(sp)
    8000090a:	e44e                	sd	s3,8(sp)
    8000090c:	e052                	sd	s4,0(sp)
    8000090e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000910:	6785                	lui	a5,0x1
    80000912:	04f67863          	bgeu	a2,a5,80000962 <uvmfirst+0x62>
    80000916:	8a2a                	mv	s4,a0
    80000918:	89ae                	mv	s3,a1
    8000091a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	8be080e7          	jalr	-1858(ra) # 800001da <kalloc>
    80000924:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000926:	6605                	lui	a2,0x1
    80000928:	4581                	li	a1,0
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	926080e7          	jalr	-1754(ra) # 80000250 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000932:	4779                	li	a4,30
    80000934:	86ca                	mv	a3,s2
    80000936:	6605                	lui	a2,0x1
    80000938:	4581                	li	a1,0
    8000093a:	8552                	mv	a0,s4
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ce8080e7          	jalr	-792(ra) # 80000624 <mappages>
  memmove(mem, src, sz);
    80000944:	8626                	mv	a2,s1
    80000946:	85ce                	mv	a1,s3
    80000948:	854a                	mv	a0,s2
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	966080e7          	jalr	-1690(ra) # 800002b0 <memmove>
}
    80000952:	70a2                	ld	ra,40(sp)
    80000954:	7402                	ld	s0,32(sp)
    80000956:	64e2                	ld	s1,24(sp)
    80000958:	6942                	ld	s2,16(sp)
    8000095a:	69a2                	ld	s3,8(sp)
    8000095c:	6a02                	ld	s4,0(sp)
    8000095e:	6145                	addi	sp,sp,48
    80000960:	8082                	ret
    panic("uvmfirst: more than a page");
    80000962:	00007517          	auipc	a0,0x7
    80000966:	7ce50513          	addi	a0,a0,1998 # 80008130 <etext+0x130>
    8000096a:	00005097          	auipc	ra,0x5
    8000096e:	4e8080e7          	jalr	1256(ra) # 80005e52 <panic>

0000000080000972 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000972:	1101                	addi	sp,sp,-32
    80000974:	ec06                	sd	ra,24(sp)
    80000976:	e822                	sd	s0,16(sp)
    80000978:	e426                	sd	s1,8(sp)
    8000097a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000097c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000097e:	00b67d63          	bgeu	a2,a1,80000998 <uvmdealloc+0x26>
    80000982:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000984:	6785                	lui	a5,0x1
    80000986:	17fd                	addi	a5,a5,-1
    80000988:	00f60733          	add	a4,a2,a5
    8000098c:	767d                	lui	a2,0xfffff
    8000098e:	8f71                	and	a4,a4,a2
    80000990:	97ae                	add	a5,a5,a1
    80000992:	8ff1                	and	a5,a5,a2
    80000994:	00f76863          	bltu	a4,a5,800009a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000998:	8526                	mv	a0,s1
    8000099a:	60e2                	ld	ra,24(sp)
    8000099c:	6442                	ld	s0,16(sp)
    8000099e:	64a2                	ld	s1,8(sp)
    800009a0:	6105                	addi	sp,sp,32
    800009a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009a4:	8f99                	sub	a5,a5,a4
    800009a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009a8:	4685                	li	a3,1
    800009aa:	0007861b          	sext.w	a2,a5
    800009ae:	85ba                	mv	a1,a4
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	e5e080e7          	jalr	-418(ra) # 8000080e <uvmunmap>
    800009b8:	b7c5                	j	80000998 <uvmdealloc+0x26>

00000000800009ba <uvmalloc>:
  if(newsz < oldsz)
    800009ba:	0ab66563          	bltu	a2,a1,80000a64 <uvmalloc+0xaa>
{
    800009be:	7139                	addi	sp,sp,-64
    800009c0:	fc06                	sd	ra,56(sp)
    800009c2:	f822                	sd	s0,48(sp)
    800009c4:	f426                	sd	s1,40(sp)
    800009c6:	f04a                	sd	s2,32(sp)
    800009c8:	ec4e                	sd	s3,24(sp)
    800009ca:	e852                	sd	s4,16(sp)
    800009cc:	e456                	sd	s5,8(sp)
    800009ce:	e05a                	sd	s6,0(sp)
    800009d0:	0080                	addi	s0,sp,64
    800009d2:	8aaa                	mv	s5,a0
    800009d4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009d6:	6985                	lui	s3,0x1
    800009d8:	19fd                	addi	s3,s3,-1
    800009da:	95ce                	add	a1,a1,s3
    800009dc:	79fd                	lui	s3,0xfffff
    800009de:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009e2:	08c9f363          	bgeu	s3,a2,80000a68 <uvmalloc+0xae>
    800009e6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800009e8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009ec:	fffff097          	auipc	ra,0xfffff
    800009f0:	7ee080e7          	jalr	2030(ra) # 800001da <kalloc>
    800009f4:	84aa                	mv	s1,a0
    if(mem == 0){
    800009f6:	c51d                	beqz	a0,80000a24 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800009f8:	6605                	lui	a2,0x1
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	854080e7          	jalr	-1964(ra) # 80000250 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a04:	875a                	mv	a4,s6
    80000a06:	86a6                	mv	a3,s1
    80000a08:	6605                	lui	a2,0x1
    80000a0a:	85ca                	mv	a1,s2
    80000a0c:	8556                	mv	a0,s5
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	c16080e7          	jalr	-1002(ra) # 80000624 <mappages>
    80000a16:	e90d                	bnez	a0,80000a48 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a18:	6785                	lui	a5,0x1
    80000a1a:	993e                	add	s2,s2,a5
    80000a1c:	fd4968e3          	bltu	s2,s4,800009ec <uvmalloc+0x32>
  return newsz;
    80000a20:	8552                	mv	a0,s4
    80000a22:	a809                	j	80000a34 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a24:	864e                	mv	a2,s3
    80000a26:	85ca                	mv	a1,s2
    80000a28:	8556                	mv	a0,s5
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	f48080e7          	jalr	-184(ra) # 80000972 <uvmdealloc>
      return 0;
    80000a32:	4501                	li	a0,0
}
    80000a34:	70e2                	ld	ra,56(sp)
    80000a36:	7442                	ld	s0,48(sp)
    80000a38:	74a2                	ld	s1,40(sp)
    80000a3a:	7902                	ld	s2,32(sp)
    80000a3c:	69e2                	ld	s3,24(sp)
    80000a3e:	6a42                	ld	s4,16(sp)
    80000a40:	6aa2                	ld	s5,8(sp)
    80000a42:	6b02                	ld	s6,0(sp)
    80000a44:	6121                	addi	sp,sp,64
    80000a46:	8082                	ret
      kfree(mem);
    80000a48:	8526                	mv	a0,s1
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	634080e7          	jalr	1588(ra) # 8000007e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a52:	864e                	mv	a2,s3
    80000a54:	85ca                	mv	a1,s2
    80000a56:	8556                	mv	a0,s5
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	f1a080e7          	jalr	-230(ra) # 80000972 <uvmdealloc>
      return 0;
    80000a60:	4501                	li	a0,0
    80000a62:	bfc9                	j	80000a34 <uvmalloc+0x7a>
    return oldsz;
    80000a64:	852e                	mv	a0,a1
}
    80000a66:	8082                	ret
  return newsz;
    80000a68:	8532                	mv	a0,a2
    80000a6a:	b7e9                	j	80000a34 <uvmalloc+0x7a>

0000000080000a6c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a6c:	7179                	addi	sp,sp,-48
    80000a6e:	f406                	sd	ra,40(sp)
    80000a70:	f022                	sd	s0,32(sp)
    80000a72:	ec26                	sd	s1,24(sp)
    80000a74:	e84a                	sd	s2,16(sp)
    80000a76:	e44e                	sd	s3,8(sp)
    80000a78:	e052                	sd	s4,0(sp)
    80000a7a:	1800                	addi	s0,sp,48
    80000a7c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a7e:	84aa                	mv	s1,a0
    80000a80:	6905                	lui	s2,0x1
    80000a82:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a84:	4985                	li	s3,1
    80000a86:	a821                	j	80000a9e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a88:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a8a:	0532                	slli	a0,a0,0xc
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	fe0080e7          	jalr	-32(ra) # 80000a6c <freewalk>
      pagetable[i] = 0;
    80000a94:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a98:	04a1                	addi	s1,s1,8
    80000a9a:	03248163          	beq	s1,s2,80000abc <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a9e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa0:	00f57793          	andi	a5,a0,15
    80000aa4:	ff3782e3          	beq	a5,s3,80000a88 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000aa8:	8905                	andi	a0,a0,1
    80000aaa:	d57d                	beqz	a0,80000a98 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000aac:	00007517          	auipc	a0,0x7
    80000ab0:	6a450513          	addi	a0,a0,1700 # 80008150 <etext+0x150>
    80000ab4:	00005097          	auipc	ra,0x5
    80000ab8:	39e080e7          	jalr	926(ra) # 80005e52 <panic>
    }
  }
  kfree((void*)pagetable);
    80000abc:	8552                	mv	a0,s4
    80000abe:	fffff097          	auipc	ra,0xfffff
    80000ac2:	5c0080e7          	jalr	1472(ra) # 8000007e <kfree>
}
    80000ac6:	70a2                	ld	ra,40(sp)
    80000ac8:	7402                	ld	s0,32(sp)
    80000aca:	64e2                	ld	s1,24(sp)
    80000acc:	6942                	ld	s2,16(sp)
    80000ace:	69a2                	ld	s3,8(sp)
    80000ad0:	6a02                	ld	s4,0(sp)
    80000ad2:	6145                	addi	sp,sp,48
    80000ad4:	8082                	ret

0000000080000ad6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ad6:	1101                	addi	sp,sp,-32
    80000ad8:	ec06                	sd	ra,24(sp)
    80000ada:	e822                	sd	s0,16(sp)
    80000adc:	e426                	sd	s1,8(sp)
    80000ade:	1000                	addi	s0,sp,32
    80000ae0:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ae2:	e999                	bnez	a1,80000af8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	f86080e7          	jalr	-122(ra) # 80000a6c <freewalk>
}
    80000aee:	60e2                	ld	ra,24(sp)
    80000af0:	6442                	ld	s0,16(sp)
    80000af2:	64a2                	ld	s1,8(sp)
    80000af4:	6105                	addi	sp,sp,32
    80000af6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000af8:	6605                	lui	a2,0x1
    80000afa:	167d                	addi	a2,a2,-1
    80000afc:	962e                	add	a2,a2,a1
    80000afe:	4685                	li	a3,1
    80000b00:	8231                	srli	a2,a2,0xc
    80000b02:	4581                	li	a1,0
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	d0a080e7          	jalr	-758(ra) # 8000080e <uvmunmap>
    80000b0c:	bfe1                	j	80000ae4 <uvmfree+0xe>

0000000080000b0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  //char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b0e:	c671                	beqz	a2,80000bda <uvmcopy+0xcc>
{
    80000b10:	7139                	addi	sp,sp,-64
    80000b12:	fc06                	sd	ra,56(sp)
    80000b14:	f822                	sd	s0,48(sp)
    80000b16:	f426                	sd	s1,40(sp)
    80000b18:	f04a                	sd	s2,32(sp)
    80000b1a:	ec4e                	sd	s3,24(sp)
    80000b1c:	e852                	sd	s4,16(sp)
    80000b1e:	e456                	sd	s5,8(sp)
    80000b20:	e05a                	sd	s6,0(sp)
    80000b22:	0080                	addi	s0,sp,64
    80000b24:	8aaa                	mv	s5,a0
    80000b26:	8a2e                	mv	s4,a1
    80000b28:	89b2                	mv	s3,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b2a:	4901                	li	s2,0
    80000b2c:	a891                	j	80000b80 <uvmcopy+0x72>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000b2e:	00007517          	auipc	a0,0x7
    80000b32:	63250513          	addi	a0,a0,1586 # 80008160 <etext+0x160>
    80000b36:	00005097          	auipc	ra,0x5
    80000b3a:	31c080e7          	jalr	796(ra) # 80005e52 <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000b3e:	00007517          	auipc	a0,0x7
    80000b42:	64250513          	addi	a0,a0,1602 # 80008180 <etext+0x180>
    80000b46:	00005097          	auipc	ra,0x5
    80000b4a:	30c080e7          	jalr	780(ra) # 80005e52 <panic>

    if (*pte & PTE_W) {
      *pte = *pte & ~PTE_W;
      *pte = *pte | PTE_RSW;
    }
    pa = PTE2PA(*pte);
    80000b4e:	00053b03          	ld	s6,0(a0)
    80000b52:	00ab5493          	srli	s1,s6,0xa
    80000b56:	04b2                	slli	s1,s1,0xc
    flags = PTE_FLAGS(*pte);
    addrefcount((uint64)pa);
    80000b58:	8526                	mv	a0,s1
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	4c2080e7          	jalr	1218(ra) # 8000001c <addrefcount>


    //if((mem = kalloc()) == 0)
      //goto err;
    //memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000b62:	3ffb7713          	andi	a4,s6,1023
    80000b66:	86a6                	mv	a3,s1
    80000b68:	6605                	lui	a2,0x1
    80000b6a:	85ca                	mv	a1,s2
    80000b6c:	8552                	mv	a0,s4
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	ab6080e7          	jalr	-1354(ra) # 80000624 <mappages>
    80000b76:	e90d                	bnez	a0,80000ba8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b78:	6785                	lui	a5,0x1
    80000b7a:	993e                	add	s2,s2,a5
    80000b7c:	05397563          	bgeu	s2,s3,80000bc6 <uvmcopy+0xb8>
    if((pte = walk(old, i, 0)) == 0)
    80000b80:	4601                	li	a2,0
    80000b82:	85ca                	mv	a1,s2
    80000b84:	8556                	mv	a0,s5
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	9b6080e7          	jalr	-1610(ra) # 8000053c <walk>
    80000b8e:	d145                	beqz	a0,80000b2e <uvmcopy+0x20>
    if((*pte & PTE_V) == 0)
    80000b90:	611c                	ld	a5,0(a0)
    80000b92:	0017f713          	andi	a4,a5,1
    80000b96:	d745                	beqz	a4,80000b3e <uvmcopy+0x30>
    if (*pte & PTE_W) {
    80000b98:	0047f713          	andi	a4,a5,4
    80000b9c:	db4d                	beqz	a4,80000b4e <uvmcopy+0x40>
      *pte = *pte & ~PTE_W;
    80000b9e:	9bed                	andi	a5,a5,-5
      *pte = *pte | PTE_RSW;
    80000ba0:	1007e793          	ori	a5,a5,256
    80000ba4:	e11c                	sd	a5,0(a0)
    80000ba6:	b765                	j	80000b4e <uvmcopy+0x40>
      kfree((void*)pa);
    80000ba8:	8526                	mv	a0,s1
    80000baa:	fffff097          	auipc	ra,0xfffff
    80000bae:	4d4080e7          	jalr	1236(ra) # 8000007e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bb2:	4685                	li	a3,1
    80000bb4:	00c95613          	srli	a2,s2,0xc
    80000bb8:	4581                	li	a1,0
    80000bba:	8552                	mv	a0,s4
    80000bbc:	00000097          	auipc	ra,0x0
    80000bc0:	c52080e7          	jalr	-942(ra) # 8000080e <uvmunmap>
  return -1;
    80000bc4:	557d                	li	a0,-1
}
    80000bc6:	70e2                	ld	ra,56(sp)
    80000bc8:	7442                	ld	s0,48(sp)
    80000bca:	74a2                	ld	s1,40(sp)
    80000bcc:	7902                	ld	s2,32(sp)
    80000bce:	69e2                	ld	s3,24(sp)
    80000bd0:	6a42                	ld	s4,16(sp)
    80000bd2:	6aa2                	ld	s5,8(sp)
    80000bd4:	6b02                	ld	s6,0(sp)
    80000bd6:	6121                	addi	sp,sp,64
    80000bd8:	8082                	ret
  return 0;
    80000bda:	4501                	li	a0,0
}
    80000bdc:	8082                	ret

0000000080000bde <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bde:	1141                	addi	sp,sp,-16
    80000be0:	e406                	sd	ra,8(sp)
    80000be2:	e022                	sd	s0,0(sp)
    80000be4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000be6:	4601                	li	a2,0
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	954080e7          	jalr	-1708(ra) # 8000053c <walk>
  if(pte == 0)
    80000bf0:	c901                	beqz	a0,80000c00 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bf2:	611c                	ld	a5,0(a0)
    80000bf4:	9bbd                	andi	a5,a5,-17
    80000bf6:	e11c                	sd	a5,0(a0)
}
    80000bf8:	60a2                	ld	ra,8(sp)
    80000bfa:	6402                	ld	s0,0(sp)
    80000bfc:	0141                	addi	sp,sp,16
    80000bfe:	8082                	ret
    panic("uvmclear");
    80000c00:	00007517          	auipc	a0,0x7
    80000c04:	5a050513          	addi	a0,a0,1440 # 800081a0 <etext+0x1a0>
    80000c08:	00005097          	auipc	ra,0x5
    80000c0c:	24a080e7          	jalr	586(ra) # 80005e52 <panic>

0000000080000c10 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000c10:	cee5                	beqz	a3,80000d08 <copyout+0xf8>
{
    80000c12:	7119                	addi	sp,sp,-128
    80000c14:	fc86                	sd	ra,120(sp)
    80000c16:	f8a2                	sd	s0,112(sp)
    80000c18:	f4a6                	sd	s1,104(sp)
    80000c1a:	f0ca                	sd	s2,96(sp)
    80000c1c:	ecce                	sd	s3,88(sp)
    80000c1e:	e8d2                	sd	s4,80(sp)
    80000c20:	e4d6                	sd	s5,72(sp)
    80000c22:	e0da                	sd	s6,64(sp)
    80000c24:	fc5e                	sd	s7,56(sp)
    80000c26:	f862                	sd	s8,48(sp)
    80000c28:	f466                	sd	s9,40(sp)
    80000c2a:	f06a                	sd	s10,32(sp)
    80000c2c:	ec6e                	sd	s11,24(sp)
    80000c2e:	0100                	addi	s0,sp,128
    80000c30:	8c2a                	mv	s8,a0
    80000c32:	8aae                	mv	s5,a1
    80000c34:	8b32                	mv	s6,a2
    80000c36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c38:	74fd                	lui	s1,0xfffff
    80000c3a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000c3c:	57fd                	li	a5,-1
    80000c3e:	83e9                	srli	a5,a5,0x1a
    80000c40:	0c97e663          	bltu	a5,s1,80000d0c <copyout+0xfc>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80000c44:	4d45                	li	s10,17
      return -1;
    pa0 = PTE2PA(*pte);


    if (((*pte & PTE_W) == 0) && (*pte & PTE_RSW)) //new!
    80000c46:	10000d93          	li	s11,256
    if(va0 >= MAXVA)
    80000c4a:	8cbe                	mv	s9,a5
    80000c4c:	a8ad                	j	80000cc6 <copyout+0xb6>
    {
      char *mem;
      if ((mem = kalloc()) == 0) {
    80000c4e:	fffff097          	auipc	ra,0xfffff
    80000c52:	58c080e7          	jalr	1420(ra) # 800001da <kalloc>
    80000c56:	8baa                	mv	s7,a0
    80000c58:	c165                	beqz	a0,80000d38 <copyout+0x128>
        return -1;
      }
      memmove(mem, (char*)pa0, PGSIZE);
    80000c5a:	6605                	lui	a2,0x1
    80000c5c:	85d2                	mv	a1,s4
    80000c5e:	fffff097          	auipc	ra,0xfffff
    80000c62:	652080e7          	jalr	1618(ra) # 800002b0 <memmove>
      uint flags = PTE_FLAGS(*pte);
    80000c66:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000c6a:	3ff7f793          	andi	a5,a5,1023
    80000c6e:	f8f43423          	sd	a5,-120(s0)
      uvmunmap(pagetable, va0, 1, 1);
    80000c72:	4685                	li	a3,1
    80000c74:	4605                	li	a2,1
    80000c76:	85a6                	mv	a1,s1
    80000c78:	8562                	mv	a0,s8
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	b94080e7          	jalr	-1132(ra) # 8000080e <uvmunmap>
      *pte = (PA2PTE((uint64)mem) | flags | PTE_W);
    80000c82:	8a5e                	mv	s4,s7
    80000c84:	00cbdb93          	srli	s7,s7,0xc
    80000c88:	0baa                	slli	s7,s7,0xa
    80000c8a:	f8843783          	ld	a5,-120(s0)
    80000c8e:	0177ebb3          	or	s7,a5,s7
      *pte &= ~PTE_RSW;
    80000c92:	effbfb93          	andi	s7,s7,-257
    80000c96:	004beb93          	ori	s7,s7,4
    80000c9a:	01793023          	sd	s7,0(s2)
      //kfree((void*)pa0);
      pa0 = (uint64)mem;
    80000c9e:	a899                	j	80000cf4 <copyout+0xe4>
      return -1;

    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ca0:	409a8533          	sub	a0,s5,s1
    80000ca4:	000b861b          	sext.w	a2,s7
    80000ca8:	85da                	mv	a1,s6
    80000caa:	9552                	add	a0,a0,s4
    80000cac:	fffff097          	auipc	ra,0xfffff
    80000cb0:	604080e7          	jalr	1540(ra) # 800002b0 <memmove>

    len -= n;
    80000cb4:	417989b3          	sub	s3,s3,s7
    src += n;
    80000cb8:	9b5e                	add	s6,s6,s7
  while(len > 0){
    80000cba:	04098563          	beqz	s3,80000d04 <copyout+0xf4>
    if(va0 >= MAXVA)
    80000cbe:	052ce963          	bltu	s9,s2,80000d10 <copyout+0x100>
    va0 = PGROUNDDOWN(dstva);
    80000cc2:	84ca                	mv	s1,s2
    dstva = va0 + PGSIZE;
    80000cc4:	8aca                	mv	s5,s2
    pte = walk(pagetable, va0, 0);
    80000cc6:	4601                	li	a2,0
    80000cc8:	85a6                	mv	a1,s1
    80000cca:	8562                	mv	a0,s8
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	870080e7          	jalr	-1936(ra) # 8000053c <walk>
    80000cd4:	892a                	mv	s2,a0
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80000cd6:	cd1d                	beqz	a0,80000d14 <copyout+0x104>
    80000cd8:	611c                	ld	a5,0(a0)
    80000cda:	0117f713          	andi	a4,a5,17
    80000cde:	05a71b63          	bne	a4,s10,80000d34 <copyout+0x124>
    pa0 = PTE2PA(*pte);
    80000ce2:	00a7da13          	srli	s4,a5,0xa
    80000ce6:	0a32                	slli	s4,s4,0xc
    if (((*pte & PTE_W) == 0) && (*pte & PTE_RSW)) //new!
    80000ce8:	1047f713          	andi	a4,a5,260
    80000cec:	f7b701e3          	beq	a4,s11,80000c4e <copyout+0x3e>
    else if((*pte & PTE_W) == 0)
    80000cf0:	8b91                	andi	a5,a5,4
    80000cf2:	c7a9                	beqz	a5,80000d3c <copyout+0x12c>
    n = PGSIZE - (dstva - va0);
    80000cf4:	6905                	lui	s2,0x1
    80000cf6:	9926                	add	s2,s2,s1
    80000cf8:	41590bb3          	sub	s7,s2,s5
    if(n > len)
    80000cfc:	fb79f2e3          	bgeu	s3,s7,80000ca0 <copyout+0x90>
    80000d00:	8bce                	mv	s7,s3
    80000d02:	bf79                	j	80000ca0 <copyout+0x90>
  }
  return 0;
    80000d04:	4501                	li	a0,0
    80000d06:	a801                	j	80000d16 <copyout+0x106>
    80000d08:	4501                	li	a0,0
}
    80000d0a:	8082                	ret
      return -1;
    80000d0c:	557d                	li	a0,-1
    80000d0e:	a021                	j	80000d16 <copyout+0x106>
    80000d10:	557d                	li	a0,-1
    80000d12:	a011                	j	80000d16 <copyout+0x106>
      return -1;
    80000d14:	557d                	li	a0,-1
}
    80000d16:	70e6                	ld	ra,120(sp)
    80000d18:	7446                	ld	s0,112(sp)
    80000d1a:	74a6                	ld	s1,104(sp)
    80000d1c:	7906                	ld	s2,96(sp)
    80000d1e:	69e6                	ld	s3,88(sp)
    80000d20:	6a46                	ld	s4,80(sp)
    80000d22:	6aa6                	ld	s5,72(sp)
    80000d24:	6b06                	ld	s6,64(sp)
    80000d26:	7be2                	ld	s7,56(sp)
    80000d28:	7c42                	ld	s8,48(sp)
    80000d2a:	7ca2                	ld	s9,40(sp)
    80000d2c:	7d02                	ld	s10,32(sp)
    80000d2e:	6de2                	ld	s11,24(sp)
    80000d30:	6109                	addi	sp,sp,128
    80000d32:	8082                	ret
      return -1;
    80000d34:	557d                	li	a0,-1
    80000d36:	b7c5                	j	80000d16 <copyout+0x106>
        return -1;
    80000d38:	557d                	li	a0,-1
    80000d3a:	bff1                	j	80000d16 <copyout+0x106>
      return -1;
    80000d3c:	557d                	li	a0,-1
    80000d3e:	bfe1                	j	80000d16 <copyout+0x106>

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
    80000d78:	53c080e7          	jalr	1340(ra) # 800002b0 <memmove>

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
    80000d96:	850080e7          	jalr	-1968(ra) # 800005e2 <walkaddr>
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
    80000e24:	fffff097          	auipc	ra,0xfffff
    80000e28:	7be080e7          	jalr	1982(ra) # 800005e2 <walkaddr>
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
    80000e96:	00228497          	auipc	s1,0x228
    80000e9a:	efa48493          	addi	s1,s1,-262 # 80228d90 <proc>
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
    80000eb0:	0022ea17          	auipc	s4,0x22e
    80000eb4:	8e0a0a13          	addi	s4,s4,-1824 # 8022e790 <tickslock>
    char *pa = kalloc();
    80000eb8:	fffff097          	auipc	ra,0xfffff
    80000ebc:	322080e7          	jalr	802(ra) # 800001da <kalloc>
    80000ec0:	862a                	mv	a2,a0
    if(pa == 0)
    80000ec2:	c131                	beqz	a0,80000f06 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ec4:	416485b3          	sub	a1,s1,s6
    80000ec8:	858d                	srai	a1,a1,0x3
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
    80000ee6:	806080e7          	jalr	-2042(ra) # 800006e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eea:	16848493          	addi	s1,s1,360
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
    80000f0a:	2aa50513          	addi	a0,a0,682 # 800081b0 <etext+0x1b0>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	f44080e7          	jalr	-188(ra) # 80005e52 <panic>

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
    80000f2e:	28e58593          	addi	a1,a1,654 # 800081b8 <etext+0x1b8>
    80000f32:	00228517          	auipc	a0,0x228
    80000f36:	a2e50513          	addi	a0,a0,-1490 # 80228960 <pid_lock>
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	3d2080e7          	jalr	978(ra) # 8000630c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f42:	00007597          	auipc	a1,0x7
    80000f46:	27e58593          	addi	a1,a1,638 # 800081c0 <etext+0x1c0>
    80000f4a:	00228517          	auipc	a0,0x228
    80000f4e:	a2e50513          	addi	a0,a0,-1490 # 80228978 <wait_lock>
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	3ba080e7          	jalr	954(ra) # 8000630c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5a:	00228497          	auipc	s1,0x228
    80000f5e:	e3648493          	addi	s1,s1,-458 # 80228d90 <proc>
      initlock(&p->lock, "proc");
    80000f62:	00007b17          	auipc	s6,0x7
    80000f66:	26eb0b13          	addi	s6,s6,622 # 800081d0 <etext+0x1d0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f6a:	8aa6                	mv	s5,s1
    80000f6c:	00007a17          	auipc	s4,0x7
    80000f70:	094a0a13          	addi	s4,s4,148 # 80008000 <etext>
    80000f74:	04000937          	lui	s2,0x4000
    80000f78:	197d                	addi	s2,s2,-1
    80000f7a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7c:	0022e997          	auipc	s3,0x22e
    80000f80:	81498993          	addi	s3,s3,-2028 # 8022e790 <tickslock>
      initlock(&p->lock, "proc");
    80000f84:	85da                	mv	a1,s6
    80000f86:	8526                	mv	a0,s1
    80000f88:	00005097          	auipc	ra,0x5
    80000f8c:	384080e7          	jalr	900(ra) # 8000630c <initlock>
      p->state = UNUSED;
    80000f90:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f94:	415487b3          	sub	a5,s1,s5
    80000f98:	878d                	srai	a5,a5,0x3
    80000f9a:	000a3703          	ld	a4,0(s4)
    80000f9e:	02e787b3          	mul	a5,a5,a4
    80000fa2:	2785                	addiw	a5,a5,1
    80000fa4:	00d7979b          	slliw	a5,a5,0xd
    80000fa8:	40f907b3          	sub	a5,s2,a5
    80000fac:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fae:	16848493          	addi	s1,s1,360
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
    80000fe6:	00228517          	auipc	a0,0x228
    80000fea:	9aa50513          	addi	a0,a0,-1622 # 80228990 <cpus>
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
    80001004:	350080e7          	jalr	848(ra) # 80006350 <push_off>
    80001008:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000100a:	2781                	sext.w	a5,a5
    8000100c:	079e                	slli	a5,a5,0x7
    8000100e:	00228717          	auipc	a4,0x228
    80001012:	95270713          	addi	a4,a4,-1710 # 80228960 <pid_lock>
    80001016:	97ba                	add	a5,a5,a4
    80001018:	7b84                	ld	s1,48(a5)
  pop_off();
    8000101a:	00005097          	auipc	ra,0x5
    8000101e:	3d6080e7          	jalr	982(ra) # 800063f0 <pop_off>
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
    8000103e:	00005097          	auipc	ra,0x5
    80001042:	412080e7          	jalr	1042(ra) # 80006450 <release>

  if (first) {
    80001046:	00008797          	auipc	a5,0x8
    8000104a:	85a7a783          	lw	a5,-1958(a5) # 800088a0 <first.1680>
    8000104e:	eb89                	bnez	a5,80001060 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001050:	00001097          	auipc	ra,0x1
    80001054:	cf2080e7          	jalr	-782(ra) # 80001d42 <usertrapret>
}
    80001058:	60a2                	ld	ra,8(sp)
    8000105a:	6402                	ld	s0,0(sp)
    8000105c:	0141                	addi	sp,sp,16
    8000105e:	8082                	ret
    fsinit(ROOTDEV);
    80001060:	4505                	li	a0,1
    80001062:	00002097          	auipc	ra,0x2
    80001066:	a78080e7          	jalr	-1416(ra) # 80002ada <fsinit>
    first = 0;
    8000106a:	00008797          	auipc	a5,0x8
    8000106e:	8207ab23          	sw	zero,-1994(a5) # 800088a0 <first.1680>
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
    80001084:	00228917          	auipc	s2,0x228
    80001088:	8dc90913          	addi	s2,s2,-1828 # 80228960 <pid_lock>
    8000108c:	854a                	mv	a0,s2
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	30e080e7          	jalr	782(ra) # 8000639c <acquire>
  pid = nextpid;
    80001096:	00008797          	auipc	a5,0x8
    8000109a:	80e78793          	addi	a5,a5,-2034 # 800088a4 <nextpid>
    8000109e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010a0:	0014871b          	addiw	a4,s1,1
    800010a4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010a6:	854a                	mv	a0,s2
    800010a8:	00005097          	auipc	ra,0x5
    800010ac:	3a8080e7          	jalr	936(ra) # 80006450 <release>
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
    800010d0:	806080e7          	jalr	-2042(ra) # 800008d2 <uvmcreate>
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
    800010f0:	538080e7          	jalr	1336(ra) # 80000624 <mappages>
    800010f4:	02054863          	bltz	a0,80001124 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010f8:	4719                	li	a4,6
    800010fa:	05893683          	ld	a3,88(s2)
    800010fe:	6605                	lui	a2,0x1
    80001100:	020005b7          	lui	a1,0x2000
    80001104:	15fd                	addi	a1,a1,-1
    80001106:	05b6                	slli	a1,a1,0xd
    80001108:	8526                	mv	a0,s1
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	51a080e7          	jalr	1306(ra) # 80000624 <mappages>
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
    8000112c:	9ae080e7          	jalr	-1618(ra) # 80000ad6 <uvmfree>
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
    80001146:	6cc080e7          	jalr	1740(ra) # 8000080e <uvmunmap>
    uvmfree(pagetable, 0);
    8000114a:	4581                	li	a1,0
    8000114c:	8526                	mv	a0,s1
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	988080e7          	jalr	-1656(ra) # 80000ad6 <uvmfree>
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
    8000117a:	698080e7          	jalr	1688(ra) # 8000080e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000117e:	4681                	li	a3,0
    80001180:	4605                	li	a2,1
    80001182:	020005b7          	lui	a1,0x2000
    80001186:	15fd                	addi	a1,a1,-1
    80001188:	05b6                	slli	a1,a1,0xd
    8000118a:	8526                	mv	a0,s1
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	682080e7          	jalr	1666(ra) # 8000080e <uvmunmap>
  uvmfree(pagetable, sz);
    80001194:	85ca                	mv	a1,s2
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	93e080e7          	jalr	-1730(ra) # 80000ad6 <uvmfree>
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
    800011b8:	6d28                	ld	a0,88(a0)
    800011ba:	c509                	beqz	a0,800011c4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	ec2080e7          	jalr	-318(ra) # 8000007e <kfree>
  p->trapframe = 0;
    800011c4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011c8:	68a8                	ld	a0,80(s1)
    800011ca:	c511                	beqz	a0,800011d6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011cc:	64ac                	ld	a1,72(s1)
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f8c080e7          	jalr	-116(ra) # 8000115a <proc_freepagetable>
  p->pagetable = 0;
    800011d6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011da:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011de:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011e2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011e6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011ea:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011ee:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011f2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011f6:	0004ac23          	sw	zero,24(s1)
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
    80001210:	00228497          	auipc	s1,0x228
    80001214:	b8048493          	addi	s1,s1,-1152 # 80228d90 <proc>
    80001218:	0022d917          	auipc	s2,0x22d
    8000121c:	57890913          	addi	s2,s2,1400 # 8022e790 <tickslock>
    acquire(&p->lock);
    80001220:	8526                	mv	a0,s1
    80001222:	00005097          	auipc	ra,0x5
    80001226:	17a080e7          	jalr	378(ra) # 8000639c <acquire>
    if(p->state == UNUSED) {
    8000122a:	4c9c                	lw	a5,24(s1)
    8000122c:	cf81                	beqz	a5,80001244 <allocproc+0x40>
      release(&p->lock);
    8000122e:	8526                	mv	a0,s1
    80001230:	00005097          	auipc	ra,0x5
    80001234:	220080e7          	jalr	544(ra) # 80006450 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001238:	16848493          	addi	s1,s1,360
    8000123c:	ff2492e3          	bne	s1,s2,80001220 <allocproc+0x1c>
  return 0;
    80001240:	4481                	li	s1,0
    80001242:	a889                	j	80001294 <allocproc+0x90>
  p->pid = allocpid();
    80001244:	00000097          	auipc	ra,0x0
    80001248:	e34080e7          	jalr	-460(ra) # 80001078 <allocpid>
    8000124c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000124e:	4785                	li	a5,1
    80001250:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	f88080e7          	jalr	-120(ra) # 800001da <kalloc>
    8000125a:	892a                	mv	s2,a0
    8000125c:	eca8                	sd	a0,88(s1)
    8000125e:	c131                	beqz	a0,800012a2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001260:	8526                	mv	a0,s1
    80001262:	00000097          	auipc	ra,0x0
    80001266:	e5c080e7          	jalr	-420(ra) # 800010be <proc_pagetable>
    8000126a:	892a                	mv	s2,a0
    8000126c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000126e:	c531                	beqz	a0,800012ba <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001270:	07000613          	li	a2,112
    80001274:	4581                	li	a1,0
    80001276:	06048513          	addi	a0,s1,96
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	fd6080e7          	jalr	-42(ra) # 80000250 <memset>
  p->context.ra = (uint64)forkret;
    80001282:	00000797          	auipc	a5,0x0
    80001286:	dac78793          	addi	a5,a5,-596 # 8000102e <forkret>
    8000128a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000128c:	60bc                	ld	a5,64(s1)
    8000128e:	6705                	lui	a4,0x1
    80001290:	97ba                	add	a5,a5,a4
    80001292:	f4bc                	sd	a5,104(s1)
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
    800012b2:	1a2080e7          	jalr	418(ra) # 80006450 <release>
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
    800012ca:	18a080e7          	jalr	394(ra) # 80006450 <release>
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
    800012ea:	62a7bd23          	sd	a0,1594(a5) # 80008920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012ee:	03400613          	li	a2,52
    800012f2:	00007597          	auipc	a1,0x7
    800012f6:	5be58593          	addi	a1,a1,1470 # 800088b0 <initcode>
    800012fa:	6928                	ld	a0,80(a0)
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	604080e7          	jalr	1540(ra) # 80000900 <uvmfirst>
  p->sz = PGSIZE;
    80001304:	6785                	lui	a5,0x1
    80001306:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001308:	6cb8                	ld	a4,88(s1)
    8000130a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000130e:	6cb8                	ld	a4,88(s1)
    80001310:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001312:	4641                	li	a2,16
    80001314:	00007597          	auipc	a1,0x7
    80001318:	ec458593          	addi	a1,a1,-316 # 800081d8 <etext+0x1d8>
    8000131c:	15848513          	addi	a0,s1,344
    80001320:	fffff097          	auipc	ra,0xfffff
    80001324:	082080e7          	jalr	130(ra) # 800003a2 <safestrcpy>
  p->cwd = namei("/");
    80001328:	00007517          	auipc	a0,0x7
    8000132c:	ec050513          	addi	a0,a0,-320 # 800081e8 <etext+0x1e8>
    80001330:	00002097          	auipc	ra,0x2
    80001334:	1cc080e7          	jalr	460(ra) # 800034fc <namei>
    80001338:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000133c:	478d                	li	a5,3
    8000133e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001340:	8526                	mv	a0,s1
    80001342:	00005097          	auipc	ra,0x5
    80001346:	10e080e7          	jalr	270(ra) # 80006450 <release>
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
    8000136c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000136e:	01204c63          	bgtz	s2,80001386 <growproc+0x32>
  } else if(n < 0){
    80001372:	02094663          	bltz	s2,8000139e <growproc+0x4a>
  p->sz = sz;
    80001376:	e4ac                	sd	a1,72(s1)
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
    8000138c:	6928                	ld	a0,80(a0)
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	62c080e7          	jalr	1580(ra) # 800009ba <uvmalloc>
    80001396:	85aa                	mv	a1,a0
    80001398:	fd79                	bnez	a0,80001376 <growproc+0x22>
      return -1;
    8000139a:	557d                	li	a0,-1
    8000139c:	bff9                	j	8000137a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000139e:	00b90633          	add	a2,s2,a1
    800013a2:	6928                	ld	a0,80(a0)
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	5ce080e7          	jalr	1486(ra) # 80000972 <uvmdealloc>
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
    800013d8:	04893603          	ld	a2,72(s2)
    800013dc:	692c                	ld	a1,80(a0)
    800013de:	05093503          	ld	a0,80(s2)
    800013e2:	fffff097          	auipc	ra,0xfffff
    800013e6:	72c080e7          	jalr	1836(ra) # 80000b0e <uvmcopy>
    800013ea:	04054663          	bltz	a0,80001436 <fork+0x86>
  np->sz = p->sz;
    800013ee:	04893783          	ld	a5,72(s2)
    800013f2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013f6:	05893683          	ld	a3,88(s2)
    800013fa:	87b6                	mv	a5,a3
    800013fc:	0589b703          	ld	a4,88(s3)
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
    80001424:	0589b783          	ld	a5,88(s3)
    80001428:	0607b823          	sd	zero,112(a5)
    8000142c:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001430:	15000a13          	li	s4,336
    80001434:	a03d                	j	80001462 <fork+0xb2>
    freeproc(np);
    80001436:	854e                	mv	a0,s3
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	d74080e7          	jalr	-652(ra) # 800011ac <freeproc>
    release(&np->lock);
    80001440:	854e                	mv	a0,s3
    80001442:	00005097          	auipc	ra,0x5
    80001446:	00e080e7          	jalr	14(ra) # 80006450 <release>
    return -1;
    8000144a:	5a7d                	li	s4,-1
    8000144c:	a069                	j	800014d6 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000144e:	00002097          	auipc	ra,0x2
    80001452:	744080e7          	jalr	1860(ra) # 80003b92 <filedup>
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
    8000146c:	15093503          	ld	a0,336(s2)
    80001470:	00002097          	auipc	ra,0x2
    80001474:	8a8080e7          	jalr	-1880(ra) # 80002d18 <idup>
    80001478:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000147c:	4641                	li	a2,16
    8000147e:	15890593          	addi	a1,s2,344
    80001482:	15898513          	addi	a0,s3,344
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	f1c080e7          	jalr	-228(ra) # 800003a2 <safestrcpy>
  pid = np->pid;
    8000148e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001492:	854e                	mv	a0,s3
    80001494:	00005097          	auipc	ra,0x5
    80001498:	fbc080e7          	jalr	-68(ra) # 80006450 <release>
  acquire(&wait_lock);
    8000149c:	00227497          	auipc	s1,0x227
    800014a0:	4dc48493          	addi	s1,s1,1244 # 80228978 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	ef6080e7          	jalr	-266(ra) # 8000639c <acquire>
  np->parent = p;
    800014ae:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014b2:	8526                	mv	a0,s1
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	f9c080e7          	jalr	-100(ra) # 80006450 <release>
  acquire(&np->lock);
    800014bc:	854e                	mv	a0,s3
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	ede080e7          	jalr	-290(ra) # 8000639c <acquire>
  np->state = RUNNABLE;
    800014c6:	478d                	li	a5,3
    800014c8:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014cc:	854e                	mv	a0,s3
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	f82080e7          	jalr	-126(ra) # 80006450 <release>
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
    80001508:	00227717          	auipc	a4,0x227
    8000150c:	45870713          	addi	a4,a4,1112 # 80228960 <pid_lock>
    80001510:	9756                	add	a4,a4,s5
    80001512:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001516:	00227717          	auipc	a4,0x227
    8000151a:	48270713          	addi	a4,a4,1154 # 80228998 <cpus+0x8>
    8000151e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001520:	498d                	li	s3,3
        p->state = RUNNING;
    80001522:	4b11                	li	s6,4
        c->proc = p;
    80001524:	079e                	slli	a5,a5,0x7
    80001526:	00227a17          	auipc	s4,0x227
    8000152a:	43aa0a13          	addi	s4,s4,1082 # 80228960 <pid_lock>
    8000152e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001530:	0022d917          	auipc	s2,0x22d
    80001534:	26090913          	addi	s2,s2,608 # 8022e790 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001538:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001540:	10079073          	csrw	sstatus,a5
    80001544:	00228497          	auipc	s1,0x228
    80001548:	84c48493          	addi	s1,s1,-1972 # 80228d90 <proc>
    8000154c:	a03d                	j	8000157a <scheduler+0x8e>
        p->state = RUNNING;
    8000154e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001552:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001556:	06048593          	addi	a1,s1,96
    8000155a:	8556                	mv	a0,s5
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	6a4080e7          	jalr	1700(ra) # 80001c00 <swtch>
        c->proc = 0;
    80001564:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001568:	8526                	mv	a0,s1
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	ee6080e7          	jalr	-282(ra) # 80006450 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	16848493          	addi	s1,s1,360
    80001576:	fd2481e3          	beq	s1,s2,80001538 <scheduler+0x4c>
      acquire(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	e20080e7          	jalr	-480(ra) # 8000639c <acquire>
      if(p->state == RUNNABLE) {
    80001584:	4c9c                	lw	a5,24(s1)
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
    800015a8:	d7e080e7          	jalr	-642(ra) # 80006322 <holding>
    800015ac:	c93d                	beqz	a0,80001622 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ae:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015b0:	2781                	sext.w	a5,a5
    800015b2:	079e                	slli	a5,a5,0x7
    800015b4:	00227717          	auipc	a4,0x227
    800015b8:	3ac70713          	addi	a4,a4,940 # 80228960 <pid_lock>
    800015bc:	97ba                	add	a5,a5,a4
    800015be:	0a87a703          	lw	a4,168(a5)
    800015c2:	4785                	li	a5,1
    800015c4:	06f71763          	bne	a4,a5,80001632 <sched+0xa6>
  if(p->state == RUNNING)
    800015c8:	4c98                	lw	a4,24(s1)
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
    800015da:	00227917          	auipc	s2,0x227
    800015de:	38690913          	addi	s2,s2,902 # 80228960 <pid_lock>
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	97ca                	add	a5,a5,s2
    800015e8:	0ac7a983          	lw	s3,172(a5)
    800015ec:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ee:	2781                	sext.w	a5,a5
    800015f0:	079e                	slli	a5,a5,0x7
    800015f2:	00227597          	auipc	a1,0x227
    800015f6:	3a658593          	addi	a1,a1,934 # 80228998 <cpus+0x8>
    800015fa:	95be                	add	a1,a1,a5
    800015fc:	06048513          	addi	a0,s1,96
    80001600:	00000097          	auipc	ra,0x0
    80001604:	600080e7          	jalr	1536(ra) # 80001c00 <swtch>
    80001608:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000160a:	2781                	sext.w	a5,a5
    8000160c:	079e                	slli	a5,a5,0x7
    8000160e:	97ca                	add	a5,a5,s2
    80001610:	0b37a623          	sw	s3,172(a5)
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
    80001626:	bce50513          	addi	a0,a0,-1074 # 800081f0 <etext+0x1f0>
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	828080e7          	jalr	-2008(ra) # 80005e52 <panic>
    panic("sched locks");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	bce50513          	addi	a0,a0,-1074 # 80008200 <etext+0x200>
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	818080e7          	jalr	-2024(ra) # 80005e52 <panic>
    panic("sched running");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	bce50513          	addi	a0,a0,-1074 # 80008210 <etext+0x210>
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	808080e7          	jalr	-2040(ra) # 80005e52 <panic>
    panic("sched interruptible");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	bce50513          	addi	a0,a0,-1074 # 80008220 <etext+0x220>
    8000165a:	00004097          	auipc	ra,0x4
    8000165e:	7f8080e7          	jalr	2040(ra) # 80005e52 <panic>

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
    8000167a:	d26080e7          	jalr	-730(ra) # 8000639c <acquire>
  p->state = RUNNABLE;
    8000167e:	478d                	li	a5,3
    80001680:	cc9c                	sw	a5,24(s1)
  sched();
    80001682:	00000097          	auipc	ra,0x0
    80001686:	f0a080e7          	jalr	-246(ra) # 8000158c <sched>
  release(&p->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	dc4080e7          	jalr	-572(ra) # 80006450 <release>
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
    800016be:	ce2080e7          	jalr	-798(ra) # 8000639c <acquire>
  release(lk);
    800016c2:	854a                	mv	a0,s2
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	d8c080e7          	jalr	-628(ra) # 80006450 <release>

  // Go to sleep.
  p->chan = chan;
    800016cc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016d0:	4789                	li	a5,2
    800016d2:	cc9c                	sw	a5,24(s1)

  sched();
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	eb8080e7          	jalr	-328(ra) # 8000158c <sched>

  // Tidy up.
  p->chan = 0;
    800016dc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016e0:	8526                	mv	a0,s1
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	d6e080e7          	jalr	-658(ra) # 80006450 <release>
  acquire(lk);
    800016ea:	854a                	mv	a0,s2
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	cb0080e7          	jalr	-848(ra) # 8000639c <acquire>
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
    80001716:	00227497          	auipc	s1,0x227
    8000171a:	67a48493          	addi	s1,s1,1658 # 80228d90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000171e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001720:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	0022d917          	auipc	s2,0x22d
    80001726:	06e90913          	addi	s2,s2,110 # 8022e790 <tickslock>
    8000172a:	a821                	j	80001742 <wakeup+0x40>
        p->state = RUNNABLE;
    8000172c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	d1e080e7          	jalr	-738(ra) # 80006450 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000173a:	16848493          	addi	s1,s1,360
    8000173e:	03248463          	beq	s1,s2,80001766 <wakeup+0x64>
    if(p != myproc()){
    80001742:	00000097          	auipc	ra,0x0
    80001746:	8b4080e7          	jalr	-1868(ra) # 80000ff6 <myproc>
    8000174a:	fea488e3          	beq	s1,a0,8000173a <wakeup+0x38>
      acquire(&p->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	c4c080e7          	jalr	-948(ra) # 8000639c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001758:	4c9c                	lw	a5,24(s1)
    8000175a:	fd379be3          	bne	a5,s3,80001730 <wakeup+0x2e>
    8000175e:	709c                	ld	a5,32(s1)
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
    8000178a:	00227497          	auipc	s1,0x227
    8000178e:	60648493          	addi	s1,s1,1542 # 80228d90 <proc>
      pp->parent = initproc;
    80001792:	00007a17          	auipc	s4,0x7
    80001796:	18ea0a13          	addi	s4,s4,398 # 80008920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179a:	0022d997          	auipc	s3,0x22d
    8000179e:	ff698993          	addi	s3,s3,-10 # 8022e790 <tickslock>
    800017a2:	a029                	j	800017ac <reparent+0x34>
    800017a4:	16848493          	addi	s1,s1,360
    800017a8:	01348d63          	beq	s1,s3,800017c2 <reparent+0x4a>
    if(pp->parent == p){
    800017ac:	7c9c                	ld	a5,56(s1)
    800017ae:	ff279be3          	bne	a5,s2,800017a4 <reparent+0x2c>
      pp->parent = initproc;
    800017b2:	000a3503          	ld	a0,0(s4)
    800017b6:	fc88                	sd	a0,56(s1)
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
    800017f2:	1327b783          	ld	a5,306(a5) # 80008920 <initproc>
    800017f6:	0d050493          	addi	s1,a0,208
    800017fa:	15050913          	addi	s2,a0,336
    800017fe:	02a79363          	bne	a5,a0,80001824 <exit+0x52>
    panic("init exiting");
    80001802:	00007517          	auipc	a0,0x7
    80001806:	a3650513          	addi	a0,a0,-1482 # 80008238 <etext+0x238>
    8000180a:	00004097          	auipc	ra,0x4
    8000180e:	648080e7          	jalr	1608(ra) # 80005e52 <panic>
      fileclose(f);
    80001812:	00002097          	auipc	ra,0x2
    80001816:	3d2080e7          	jalr	978(ra) # 80003be4 <fileclose>
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
    8000182e:	eee080e7          	jalr	-274(ra) # 80003718 <begin_op>
  iput(p->cwd);
    80001832:	1509b503          	ld	a0,336(s3)
    80001836:	00001097          	auipc	ra,0x1
    8000183a:	6da080e7          	jalr	1754(ra) # 80002f10 <iput>
  end_op();
    8000183e:	00002097          	auipc	ra,0x2
    80001842:	f5a080e7          	jalr	-166(ra) # 80003798 <end_op>
  p->cwd = 0;
    80001846:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000184a:	00227497          	auipc	s1,0x227
    8000184e:	12e48493          	addi	s1,s1,302 # 80228978 <wait_lock>
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	b48080e7          	jalr	-1208(ra) # 8000639c <acquire>
  reparent(p);
    8000185c:	854e                	mv	a0,s3
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	f1a080e7          	jalr	-230(ra) # 80001778 <reparent>
  wakeup(p->parent);
    80001866:	0389b503          	ld	a0,56(s3)
    8000186a:	00000097          	auipc	ra,0x0
    8000186e:	e98080e7          	jalr	-360(ra) # 80001702 <wakeup>
  acquire(&p->lock);
    80001872:	854e                	mv	a0,s3
    80001874:	00005097          	auipc	ra,0x5
    80001878:	b28080e7          	jalr	-1240(ra) # 8000639c <acquire>
  p->xstate = status;
    8000187c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001880:	4795                	li	a5,5
    80001882:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	bc8080e7          	jalr	-1080(ra) # 80006450 <release>
  sched();
    80001890:	00000097          	auipc	ra,0x0
    80001894:	cfc080e7          	jalr	-772(ra) # 8000158c <sched>
  panic("zombie exit");
    80001898:	00007517          	auipc	a0,0x7
    8000189c:	9b050513          	addi	a0,a0,-1616 # 80008248 <etext+0x248>
    800018a0:	00004097          	auipc	ra,0x4
    800018a4:	5b2080e7          	jalr	1458(ra) # 80005e52 <panic>

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
    800018b8:	00227497          	auipc	s1,0x227
    800018bc:	4d848493          	addi	s1,s1,1240 # 80228d90 <proc>
    800018c0:	0022d997          	auipc	s3,0x22d
    800018c4:	ed098993          	addi	s3,s3,-304 # 8022e790 <tickslock>
    acquire(&p->lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	ad2080e7          	jalr	-1326(ra) # 8000639c <acquire>
    if(p->pid == pid){
    800018d2:	589c                	lw	a5,48(s1)
    800018d4:	01278d63          	beq	a5,s2,800018ee <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	b76080e7          	jalr	-1162(ra) # 80006450 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018e2:	16848493          	addi	s1,s1,360
    800018e6:	ff3491e3          	bne	s1,s3,800018c8 <kill+0x20>
  }
  return -1;
    800018ea:	557d                	li	a0,-1
    800018ec:	a829                	j	80001906 <kill+0x5e>
      p->killed = 1;
    800018ee:	4785                	li	a5,1
    800018f0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018f2:	4c98                	lw	a4,24(s1)
    800018f4:	4789                	li	a5,2
    800018f6:	00f70f63          	beq	a4,a5,80001914 <kill+0x6c>
      release(&p->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	b54080e7          	jalr	-1196(ra) # 80006450 <release>
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
    80001916:	cc9c                	sw	a5,24(s1)
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
    8000192a:	a76080e7          	jalr	-1418(ra) # 8000639c <acquire>
  p->killed = 1;
    8000192e:	4785                	li	a5,1
    80001930:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00005097          	auipc	ra,0x5
    80001938:	b1c080e7          	jalr	-1252(ra) # 80006450 <release>
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
    80001958:	a48080e7          	jalr	-1464(ra) # 8000639c <acquire>
  k = p->killed;
    8000195c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001960:	8526                	mv	a0,s1
    80001962:	00005097          	auipc	ra,0x5
    80001966:	aee080e7          	jalr	-1298(ra) # 80006450 <release>
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
    8000199c:	00227517          	auipc	a0,0x227
    800019a0:	fdc50513          	addi	a0,a0,-36 # 80228978 <wait_lock>
    800019a4:	00005097          	auipc	ra,0x5
    800019a8:	9f8080e7          	jalr	-1544(ra) # 8000639c <acquire>
    havekids = 0;
    800019ac:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019ae:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019b0:	0022d997          	auipc	s3,0x22d
    800019b4:	de098993          	addi	s3,s3,-544 # 8022e790 <tickslock>
        havekids = 1;
    800019b8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019ba:	00227c17          	auipc	s8,0x227
    800019be:	fbec0c13          	addi	s8,s8,-66 # 80228978 <wait_lock>
    havekids = 0;
    800019c2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019c4:	00227497          	auipc	s1,0x227
    800019c8:	3cc48493          	addi	s1,s1,972 # 80228d90 <proc>
    800019cc:	a0bd                	j	80001a3a <wait+0xc2>
          pid = pp->pid;
    800019ce:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019d2:	000b0e63          	beqz	s6,800019ee <wait+0x76>
    800019d6:	4691                	li	a3,4
    800019d8:	02c48613          	addi	a2,s1,44
    800019dc:	85da                	mv	a1,s6
    800019de:	05093503          	ld	a0,80(s2)
    800019e2:	fffff097          	auipc	ra,0xfffff
    800019e6:	22e080e7          	jalr	558(ra) # 80000c10 <copyout>
    800019ea:	02054563          	bltz	a0,80001a14 <wait+0x9c>
          freeproc(pp);
    800019ee:	8526                	mv	a0,s1
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	7bc080e7          	jalr	1980(ra) # 800011ac <freeproc>
          release(&pp->lock);
    800019f8:	8526                	mv	a0,s1
    800019fa:	00005097          	auipc	ra,0x5
    800019fe:	a56080e7          	jalr	-1450(ra) # 80006450 <release>
          release(&wait_lock);
    80001a02:	00227517          	auipc	a0,0x227
    80001a06:	f7650513          	addi	a0,a0,-138 # 80228978 <wait_lock>
    80001a0a:	00005097          	auipc	ra,0x5
    80001a0e:	a46080e7          	jalr	-1466(ra) # 80006450 <release>
          return pid;
    80001a12:	a0b5                	j	80001a7e <wait+0x106>
            release(&pp->lock);
    80001a14:	8526                	mv	a0,s1
    80001a16:	00005097          	auipc	ra,0x5
    80001a1a:	a3a080e7          	jalr	-1478(ra) # 80006450 <release>
            release(&wait_lock);
    80001a1e:	00227517          	auipc	a0,0x227
    80001a22:	f5a50513          	addi	a0,a0,-166 # 80228978 <wait_lock>
    80001a26:	00005097          	auipc	ra,0x5
    80001a2a:	a2a080e7          	jalr	-1494(ra) # 80006450 <release>
            return -1;
    80001a2e:	59fd                	li	s3,-1
    80001a30:	a0b9                	j	80001a7e <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a32:	16848493          	addi	s1,s1,360
    80001a36:	03348463          	beq	s1,s3,80001a5e <wait+0xe6>
      if(pp->parent == p){
    80001a3a:	7c9c                	ld	a5,56(s1)
    80001a3c:	ff279be3          	bne	a5,s2,80001a32 <wait+0xba>
        acquire(&pp->lock);
    80001a40:	8526                	mv	a0,s1
    80001a42:	00005097          	auipc	ra,0x5
    80001a46:	95a080e7          	jalr	-1702(ra) # 8000639c <acquire>
        if(pp->state == ZOMBIE){
    80001a4a:	4c9c                	lw	a5,24(s1)
    80001a4c:	f94781e3          	beq	a5,s4,800019ce <wait+0x56>
        release(&pp->lock);
    80001a50:	8526                	mv	a0,s1
    80001a52:	00005097          	auipc	ra,0x5
    80001a56:	9fe080e7          	jalr	-1538(ra) # 80006450 <release>
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
    80001a6c:	00227517          	auipc	a0,0x227
    80001a70:	f0c50513          	addi	a0,a0,-244 # 80228978 <wait_lock>
    80001a74:	00005097          	auipc	ra,0x5
    80001a78:	9dc080e7          	jalr	-1572(ra) # 80006450 <release>
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
    80001ace:	6928                	ld	a0,80(a0)
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	140080e7          	jalr	320(ra) # 80000c10 <copyout>
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
    80001af0:	ffffe097          	auipc	ra,0xffffe
    80001af4:	7c0080e7          	jalr	1984(ra) # 800002b0 <memmove>
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
    80001b24:	6928                	ld	a0,80(a0)
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
    80001b4a:	76a080e7          	jalr	1898(ra) # 800002b0 <memmove>
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
    80001b68:	00006517          	auipc	a0,0x6
    80001b6c:	4f850513          	addi	a0,a0,1272 # 80008060 <etext+0x60>
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	32c080e7          	jalr	812(ra) # 80005e9c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b78:	00227497          	auipc	s1,0x227
    80001b7c:	37048493          	addi	s1,s1,880 # 80228ee8 <proc+0x158>
    80001b80:	0022d917          	auipc	s2,0x22d
    80001b84:	d6890913          	addi	s2,s2,-664 # 8022e8e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b88:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b8a:	00006997          	auipc	s3,0x6
    80001b8e:	6ce98993          	addi	s3,s3,1742 # 80008258 <etext+0x258>
    printf("%d %s %s", p->pid, state, p->name);
    80001b92:	00006a97          	auipc	s5,0x6
    80001b96:	6cea8a93          	addi	s5,s5,1742 # 80008260 <etext+0x260>
    printf("\n");
    80001b9a:	00006a17          	auipc	s4,0x6
    80001b9e:	4c6a0a13          	addi	s4,s4,1222 # 80008060 <etext+0x60>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba2:	00006b97          	auipc	s7,0x6
    80001ba6:	6feb8b93          	addi	s7,s7,1790 # 800082a0 <states.1724>
    80001baa:	a00d                	j	80001bcc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bac:	ed86a583          	lw	a1,-296(a3)
    80001bb0:	8556                	mv	a0,s5
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	2ea080e7          	jalr	746(ra) # 80005e9c <printf>
    printf("\n");
    80001bba:	8552                	mv	a0,s4
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	2e0080e7          	jalr	736(ra) # 80005e9c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bc4:	16848493          	addi	s1,s1,360
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
    80001c76:	65e58593          	addi	a1,a1,1630 # 800082d0 <states.1724+0x30>
    80001c7a:	0022d517          	auipc	a0,0x22d
    80001c7e:	b1650513          	addi	a0,a0,-1258 # 8022e790 <tickslock>
    80001c82:	00004097          	auipc	ra,0x4
    80001c86:	68a080e7          	jalr	1674(ra) # 8000630c <initlock>
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
    80001c9c:	58878793          	addi	a5,a5,1416 # 80005220 <kernelvec>
    80001ca0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ca4:	6422                	ld	s0,8(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <cowhandler>:

int
cowhandler(pagetable_t pagetable, uint64 va)
{
    va = PGROUNDDOWN(va);
    80001caa:	77fd                	lui	a5,0xfffff
    80001cac:	8dfd                	and	a1,a1,a5
    char *mem;
    if (va >= MAXVA)
    80001cae:	57fd                	li	a5,-1
    80001cb0:	83e9                	srli	a5,a5,0x1a
    80001cb2:	08b7e063          	bltu	a5,a1,80001d32 <cowhandler+0x88>
{
    80001cb6:	7179                	addi	sp,sp,-48
    80001cb8:	f406                	sd	ra,40(sp)
    80001cba:	f022                	sd	s0,32(sp)
    80001cbc:	ec26                	sd	s1,24(sp)
    80001cbe:	e84a                	sd	s2,16(sp)
    80001cc0:	e44e                	sd	s3,8(sp)
    80001cc2:	1800                	addi	s0,sp,48
      return -1;
    pte_t *pte = walk(pagetable, va, 0);
    80001cc4:	4601                	li	a2,0
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	876080e7          	jalr	-1930(ra) # 8000053c <walk>
    80001cce:	892a                	mv	s2,a0
    if (pte == 0)
    80001cd0:	c13d                	beqz	a0,80001d36 <cowhandler+0x8c>
      return -1;
    if ((*pte & PTE_RSW) == 0 || (*pte & PTE_V) == 0) {
    80001cd2:	611c                	ld	a5,0(a0)
    80001cd4:	1017f793          	andi	a5,a5,257
    80001cd8:	10100713          	li	a4,257
    80001cdc:	04e79f63          	bne	a5,a4,80001d3a <cowhandler+0x90>
      return -1;
    }
    if ((mem = kalloc()) == 0) {
    80001ce0:	ffffe097          	auipc	ra,0xffffe
    80001ce4:	4fa080e7          	jalr	1274(ra) # 800001da <kalloc>
    80001ce8:	84aa                	mv	s1,a0
    80001cea:	c931                	beqz	a0,80001d3e <cowhandler+0x94>
      return -1;
    }
    uint64 pa = PTE2PA(*pte);
    80001cec:	00093983          	ld	s3,0(s2)
    80001cf0:	00a9d993          	srli	s3,s3,0xa
    80001cf4:	09b2                	slli	s3,s3,0xc
    memmove((char*)mem, (char*)pa, PGSIZE);
    80001cf6:	6605                	lui	a2,0x1
    80001cf8:	85ce                	mv	a1,s3
    80001cfa:	ffffe097          	auipc	ra,0xffffe
    80001cfe:	5b6080e7          	jalr	1462(ra) # 800002b0 <memmove>
    uint64 flags = PTE_FLAGS(*pte);
    *pte = (PA2PTE(mem) | flags | PTE_W);
    80001d02:	80b1                	srli	s1,s1,0xc
    80001d04:	04aa                	slli	s1,s1,0xa
    uint64 flags = PTE_FLAGS(*pte);
    80001d06:	00093783          	ld	a5,0(s2)
    *pte = (PA2PTE(mem) | flags | PTE_W);
    80001d0a:	2ff7f793          	andi	a5,a5,767
    *pte &= ~PTE_RSW;
    80001d0e:	8cdd                	or	s1,s1,a5
    80001d10:	0044e493          	ori	s1,s1,4
    80001d14:	00993023          	sd	s1,0(s2)
    kfree((void*)pa);
    80001d18:	854e                	mv	a0,s3
    80001d1a:	ffffe097          	auipc	ra,0xffffe
    80001d1e:	364080e7          	jalr	868(ra) # 8000007e <kfree>
    return 0;
    80001d22:	4501                	li	a0,0
}
    80001d24:	70a2                	ld	ra,40(sp)
    80001d26:	7402                	ld	s0,32(sp)
    80001d28:	64e2                	ld	s1,24(sp)
    80001d2a:	6942                	ld	s2,16(sp)
    80001d2c:	69a2                	ld	s3,8(sp)
    80001d2e:	6145                	addi	sp,sp,48
    80001d30:	8082                	ret
      return -1;
    80001d32:	557d                	li	a0,-1
}
    80001d34:	8082                	ret
      return -1;
    80001d36:	557d                	li	a0,-1
    80001d38:	b7f5                	j	80001d24 <cowhandler+0x7a>
      return -1;
    80001d3a:	557d                	li	a0,-1
    80001d3c:	b7e5                	j	80001d24 <cowhandler+0x7a>
      return -1;
    80001d3e:	557d                	li	a0,-1
    80001d40:	b7d5                	j	80001d24 <cowhandler+0x7a>

0000000080001d42 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d42:	1141                	addi	sp,sp,-16
    80001d44:	e406                	sd	ra,8(sp)
    80001d46:	e022                	sd	s0,0(sp)
    80001d48:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	2ac080e7          	jalr	684(ra) # 80000ff6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d56:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d58:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d5c:	00005617          	auipc	a2,0x5
    80001d60:	2a460613          	addi	a2,a2,676 # 80007000 <_trampoline>
    80001d64:	00005697          	auipc	a3,0x5
    80001d68:	29c68693          	addi	a3,a3,668 # 80007000 <_trampoline>
    80001d6c:	8e91                	sub	a3,a3,a2
    80001d6e:	040007b7          	lui	a5,0x4000
    80001d72:	17fd                	addi	a5,a5,-1
    80001d74:	07b2                	slli	a5,a5,0xc
    80001d76:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d78:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d7e:	180026f3          	csrr	a3,satp
    80001d82:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d84:	6d38                	ld	a4,88(a0)
    80001d86:	6134                	ld	a3,64(a0)
    80001d88:	6585                	lui	a1,0x1
    80001d8a:	96ae                	add	a3,a3,a1
    80001d8c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d8e:	6d38                	ld	a4,88(a0)
    80001d90:	00000697          	auipc	a3,0x0
    80001d94:	13068693          	addi	a3,a3,304 # 80001ec0 <usertrap>
    80001d98:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d9a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d9c:	8692                	mv	a3,tp
    80001d9e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001da4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001da8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dac:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001db0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001db2:	6f18                	ld	a4,24(a4)
    80001db4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001db8:	6928                	ld	a0,80(a0)
    80001dba:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001dbc:	00005717          	auipc	a4,0x5
    80001dc0:	2e070713          	addi	a4,a4,736 # 8000709c <userret>
    80001dc4:	8f11                	sub	a4,a4,a2
    80001dc6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001dc8:	577d                	li	a4,-1
    80001dca:	177e                	slli	a4,a4,0x3f
    80001dcc:	8d59                	or	a0,a0,a4
    80001dce:	9782                	jalr	a5
}
    80001dd0:	60a2                	ld	ra,8(sp)
    80001dd2:	6402                	ld	s0,0(sp)
    80001dd4:	0141                	addi	sp,sp,16
    80001dd6:	8082                	ret

0000000080001dd8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dd8:	1101                	addi	sp,sp,-32
    80001dda:	ec06                	sd	ra,24(sp)
    80001ddc:	e822                	sd	s0,16(sp)
    80001dde:	e426                	sd	s1,8(sp)
    80001de0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001de2:	0022d497          	auipc	s1,0x22d
    80001de6:	9ae48493          	addi	s1,s1,-1618 # 8022e790 <tickslock>
    80001dea:	8526                	mv	a0,s1
    80001dec:	00004097          	auipc	ra,0x4
    80001df0:	5b0080e7          	jalr	1456(ra) # 8000639c <acquire>
  ticks++;
    80001df4:	00007517          	auipc	a0,0x7
    80001df8:	b3450513          	addi	a0,a0,-1228 # 80008928 <ticks>
    80001dfc:	411c                	lw	a5,0(a0)
    80001dfe:	2785                	addiw	a5,a5,1
    80001e00:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	900080e7          	jalr	-1792(ra) # 80001702 <wakeup>
  release(&tickslock);
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	644080e7          	jalr	1604(ra) # 80006450 <release>
}
    80001e14:	60e2                	ld	ra,24(sp)
    80001e16:	6442                	ld	s0,16(sp)
    80001e18:	64a2                	ld	s1,8(sp)
    80001e1a:	6105                	addi	sp,sp,32
    80001e1c:	8082                	ret

0000000080001e1e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e1e:	1101                	addi	sp,sp,-32
    80001e20:	ec06                	sd	ra,24(sp)
    80001e22:	e822                	sd	s0,16(sp)
    80001e24:	e426                	sd	s1,8(sp)
    80001e26:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e28:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e2c:	00074d63          	bltz	a4,80001e46 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e30:	57fd                	li	a5,-1
    80001e32:	17fe                	slli	a5,a5,0x3f
    80001e34:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e36:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e38:	06f70363          	beq	a4,a5,80001e9e <devintr+0x80>
  }
}
    80001e3c:	60e2                	ld	ra,24(sp)
    80001e3e:	6442                	ld	s0,16(sp)
    80001e40:	64a2                	ld	s1,8(sp)
    80001e42:	6105                	addi	sp,sp,32
    80001e44:	8082                	ret
     (scause & 0xff) == 9){
    80001e46:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e4a:	46a5                	li	a3,9
    80001e4c:	fed792e3          	bne	a5,a3,80001e30 <devintr+0x12>
    int irq = plic_claim();
    80001e50:	00003097          	auipc	ra,0x3
    80001e54:	4d8080e7          	jalr	1240(ra) # 80005328 <plic_claim>
    80001e58:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e5a:	47a9                	li	a5,10
    80001e5c:	02f50763          	beq	a0,a5,80001e8a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e60:	4785                	li	a5,1
    80001e62:	02f50963          	beq	a0,a5,80001e94 <devintr+0x76>
    return 1;
    80001e66:	4505                	li	a0,1
    } else if(irq){
    80001e68:	d8f1                	beqz	s1,80001e3c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e6a:	85a6                	mv	a1,s1
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	46c50513          	addi	a0,a0,1132 # 800082d8 <states.1724+0x38>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	028080e7          	jalr	40(ra) # 80005e9c <printf>
      plic_complete(irq);
    80001e7c:	8526                	mv	a0,s1
    80001e7e:	00003097          	auipc	ra,0x3
    80001e82:	4ce080e7          	jalr	1230(ra) # 8000534c <plic_complete>
    return 1;
    80001e86:	4505                	li	a0,1
    80001e88:	bf55                	j	80001e3c <devintr+0x1e>
      uartintr();
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	432080e7          	jalr	1074(ra) # 800062bc <uartintr>
    80001e92:	b7ed                	j	80001e7c <devintr+0x5e>
      virtio_disk_intr();
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	9e2080e7          	jalr	-1566(ra) # 80005876 <virtio_disk_intr>
    80001e9c:	b7c5                	j	80001e7c <devintr+0x5e>
    if(cpuid() == 0){
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	12c080e7          	jalr	300(ra) # 80000fca <cpuid>
    80001ea6:	c901                	beqz	a0,80001eb6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ea8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001eac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001eae:	14479073          	csrw	sip,a5
    return 2;
    80001eb2:	4509                	li	a0,2
    80001eb4:	b761                	j	80001e3c <devintr+0x1e>
      clockintr();
    80001eb6:	00000097          	auipc	ra,0x0
    80001eba:	f22080e7          	jalr	-222(ra) # 80001dd8 <clockintr>
    80001ebe:	b7ed                	j	80001ea8 <devintr+0x8a>

0000000080001ec0 <usertrap>:
{
    80001ec0:	1101                	addi	sp,sp,-32
    80001ec2:	ec06                	sd	ra,24(sp)
    80001ec4:	e822                	sd	s0,16(sp)
    80001ec6:	e426                	sd	s1,8(sp)
    80001ec8:	e04a                	sd	s2,0(sp)
    80001eca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ecc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ed0:	1007f793          	andi	a5,a5,256
    80001ed4:	e3b5                	bnez	a5,80001f38 <usertrap+0x78>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ed6:	00003797          	auipc	a5,0x3
    80001eda:	34a78793          	addi	a5,a5,842 # 80005220 <kernelvec>
    80001ede:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	114080e7          	jalr	276(ra) # 80000ff6 <myproc>
    80001eea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001eec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eee:	14102773          	csrr	a4,sepc
    80001ef2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ef8:	47a1                	li	a5,8
    80001efa:	04f70763          	beq	a4,a5,80001f48 <usertrap+0x88>
  } else if((which_dev = devintr()) != 0){
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	f20080e7          	jalr	-224(ra) # 80001e1e <devintr>
    80001f06:	892a                	mv	s2,a0
    80001f08:	ed61                	bnez	a0,80001fe0 <usertrap+0x120>
    80001f0a:	14202773          	csrr	a4,scause
  else if(r_scause() == 15)
    80001f0e:	47bd                	li	a5,15
    80001f10:	08f71b63          	bne	a4,a5,80001fa6 <usertrap+0xe6>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f14:	14302973          	csrr	s2,stval
    if (va >= p->sz)
    80001f18:	64bc                	ld	a5,72(s1)
    80001f1a:	08f97063          	bgeu	s2,a5,80001f9a <usertrap+0xda>
    int ret = cowhandler(p->pagetable, va);
    80001f1e:	85ca                	mv	a1,s2
    80001f20:	68a8                	ld	a0,80(s1)
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	d88080e7          	jalr	-632(ra) # 80001caa <cowhandler>
    if (ret != 0)
    80001f2a:	c131                	beqz	a0,80001f6e <usertrap+0xae>
      setkilled(p);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	9ec080e7          	jalr	-1556(ra) # 8000191a <setkilled>
    80001f36:	a825                	j	80001f6e <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	3c050513          	addi	a0,a0,960 # 800082f8 <states.1724+0x58>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	f12080e7          	jalr	-238(ra) # 80005e52 <panic>
    if(killed(p))
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	9fe080e7          	jalr	-1538(ra) # 80001946 <killed>
    80001f50:	ed1d                	bnez	a0,80001f8e <usertrap+0xce>
    p->trapframe->epc += 4;
    80001f52:	6cb8                	ld	a4,88(s1)
    80001f54:	6f1c                	ld	a5,24(a4)
    80001f56:	0791                	addi	a5,a5,4
    80001f58:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f5a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f62:	10079073          	csrw	sstatus,a5
    syscall();
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	2ee080e7          	jalr	750(ra) # 80002254 <syscall>
  if(killed(p))
    80001f6e:	8526                	mv	a0,s1
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	9d6080e7          	jalr	-1578(ra) # 80001946 <killed>
    80001f78:	e93d                	bnez	a0,80001fee <usertrap+0x12e>
  usertrapret();
    80001f7a:	00000097          	auipc	ra,0x0
    80001f7e:	dc8080e7          	jalr	-568(ra) # 80001d42 <usertrapret>
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6902                	ld	s2,0(sp)
    80001f8a:	6105                	addi	sp,sp,32
    80001f8c:	8082                	ret
      exit(-1);
    80001f8e:	557d                	li	a0,-1
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	842080e7          	jalr	-1982(ra) # 800017d2 <exit>
    80001f98:	bf6d                	j	80001f52 <usertrap+0x92>
      setkilled(p);
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	97e080e7          	jalr	-1666(ra) # 8000191a <setkilled>
    80001fa4:	bfad                	j	80001f1e <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fa6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001faa:	5890                	lw	a2,48(s1)
    80001fac:	00006517          	auipc	a0,0x6
    80001fb0:	36c50513          	addi	a0,a0,876 # 80008318 <states.1724+0x78>
    80001fb4:	00004097          	auipc	ra,0x4
    80001fb8:	ee8080e7          	jalr	-280(ra) # 80005e9c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fbc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fc0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fc4:	00006517          	auipc	a0,0x6
    80001fc8:	38450513          	addi	a0,a0,900 # 80008348 <states.1724+0xa8>
    80001fcc:	00004097          	auipc	ra,0x4
    80001fd0:	ed0080e7          	jalr	-304(ra) # 80005e9c <printf>
    setkilled(p);
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	944080e7          	jalr	-1724(ra) # 8000191a <setkilled>
    80001fde:	bf41                	j	80001f6e <usertrap+0xae>
  if(killed(p))
    80001fe0:	8526                	mv	a0,s1
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	964080e7          	jalr	-1692(ra) # 80001946 <killed>
    80001fea:	c901                	beqz	a0,80001ffa <usertrap+0x13a>
    80001fec:	a011                	j	80001ff0 <usertrap+0x130>
    80001fee:	4901                	li	s2,0
    exit(-1);
    80001ff0:	557d                	li	a0,-1
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	7e0080e7          	jalr	2016(ra) # 800017d2 <exit>
  if(which_dev == 2)
    80001ffa:	4789                	li	a5,2
    80001ffc:	f6f91fe3          	bne	s2,a5,80001f7a <usertrap+0xba>
    yield();
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	662080e7          	jalr	1634(ra) # 80001662 <yield>
    80002008:	bf8d                	j	80001f7a <usertrap+0xba>

000000008000200a <kerneltrap>:
{
    8000200a:	7179                	addi	sp,sp,-48
    8000200c:	f406                	sd	ra,40(sp)
    8000200e:	f022                	sd	s0,32(sp)
    80002010:	ec26                	sd	s1,24(sp)
    80002012:	e84a                	sd	s2,16(sp)
    80002014:	e44e                	sd	s3,8(sp)
    80002016:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002018:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000201c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002020:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002024:	1004f793          	andi	a5,s1,256
    80002028:	cb85                	beqz	a5,80002058 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000202a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000202e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002030:	ef85                	bnez	a5,80002068 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002032:	00000097          	auipc	ra,0x0
    80002036:	dec080e7          	jalr	-532(ra) # 80001e1e <devintr>
    8000203a:	cd1d                	beqz	a0,80002078 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000203c:	4789                	li	a5,2
    8000203e:	06f50a63          	beq	a0,a5,800020b2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002042:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002046:	10049073          	csrw	sstatus,s1
}
    8000204a:	70a2                	ld	ra,40(sp)
    8000204c:	7402                	ld	s0,32(sp)
    8000204e:	64e2                	ld	s1,24(sp)
    80002050:	6942                	ld	s2,16(sp)
    80002052:	69a2                	ld	s3,8(sp)
    80002054:	6145                	addi	sp,sp,48
    80002056:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	31050513          	addi	a0,a0,784 # 80008368 <states.1724+0xc8>
    80002060:	00004097          	auipc	ra,0x4
    80002064:	df2080e7          	jalr	-526(ra) # 80005e52 <panic>
    panic("kerneltrap: interrupts enabled");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	32850513          	addi	a0,a0,808 # 80008390 <states.1724+0xf0>
    80002070:	00004097          	auipc	ra,0x4
    80002074:	de2080e7          	jalr	-542(ra) # 80005e52 <panic>
    printf("scause %p\n", scause);
    80002078:	85ce                	mv	a1,s3
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	33650513          	addi	a0,a0,822 # 800083b0 <states.1724+0x110>
    80002082:	00004097          	auipc	ra,0x4
    80002086:	e1a080e7          	jalr	-486(ra) # 80005e9c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000208a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000208e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002092:	00006517          	auipc	a0,0x6
    80002096:	32e50513          	addi	a0,a0,814 # 800083c0 <states.1724+0x120>
    8000209a:	00004097          	auipc	ra,0x4
    8000209e:	e02080e7          	jalr	-510(ra) # 80005e9c <printf>
    panic("kerneltrap");
    800020a2:	00006517          	auipc	a0,0x6
    800020a6:	33650513          	addi	a0,a0,822 # 800083d8 <states.1724+0x138>
    800020aa:	00004097          	auipc	ra,0x4
    800020ae:	da8080e7          	jalr	-600(ra) # 80005e52 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	f44080e7          	jalr	-188(ra) # 80000ff6 <myproc>
    800020ba:	d541                	beqz	a0,80002042 <kerneltrap+0x38>
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	f3a080e7          	jalr	-198(ra) # 80000ff6 <myproc>
    800020c4:	4d18                	lw	a4,24(a0)
    800020c6:	4791                	li	a5,4
    800020c8:	f6f71de3          	bne	a4,a5,80002042 <kerneltrap+0x38>
    yield();
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	596080e7          	jalr	1430(ra) # 80001662 <yield>
    800020d4:	b7bd                	j	80002042 <kerneltrap+0x38>

00000000800020d6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	e426                	sd	s1,8(sp)
    800020de:	1000                	addi	s0,sp,32
    800020e0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	f14080e7          	jalr	-236(ra) # 80000ff6 <myproc>
  switch (n) {
    800020ea:	4795                	li	a5,5
    800020ec:	0497e163          	bltu	a5,s1,8000212e <argraw+0x58>
    800020f0:	048a                	slli	s1,s1,0x2
    800020f2:	00006717          	auipc	a4,0x6
    800020f6:	31e70713          	addi	a4,a4,798 # 80008410 <states.1724+0x170>
    800020fa:	94ba                	add	s1,s1,a4
    800020fc:	409c                	lw	a5,0(s1)
    800020fe:	97ba                	add	a5,a5,a4
    80002100:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002102:	6d3c                	ld	a5,88(a0)
    80002104:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002106:	60e2                	ld	ra,24(sp)
    80002108:	6442                	ld	s0,16(sp)
    8000210a:	64a2                	ld	s1,8(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret
    return p->trapframe->a1;
    80002110:	6d3c                	ld	a5,88(a0)
    80002112:	7fa8                	ld	a0,120(a5)
    80002114:	bfcd                	j	80002106 <argraw+0x30>
    return p->trapframe->a2;
    80002116:	6d3c                	ld	a5,88(a0)
    80002118:	63c8                	ld	a0,128(a5)
    8000211a:	b7f5                	j	80002106 <argraw+0x30>
    return p->trapframe->a3;
    8000211c:	6d3c                	ld	a5,88(a0)
    8000211e:	67c8                	ld	a0,136(a5)
    80002120:	b7dd                	j	80002106 <argraw+0x30>
    return p->trapframe->a4;
    80002122:	6d3c                	ld	a5,88(a0)
    80002124:	6bc8                	ld	a0,144(a5)
    80002126:	b7c5                	j	80002106 <argraw+0x30>
    return p->trapframe->a5;
    80002128:	6d3c                	ld	a5,88(a0)
    8000212a:	6fc8                	ld	a0,152(a5)
    8000212c:	bfe9                	j	80002106 <argraw+0x30>
  panic("argraw");
    8000212e:	00006517          	auipc	a0,0x6
    80002132:	2ba50513          	addi	a0,a0,698 # 800083e8 <states.1724+0x148>
    80002136:	00004097          	auipc	ra,0x4
    8000213a:	d1c080e7          	jalr	-740(ra) # 80005e52 <panic>

000000008000213e <fetchaddr>:
{
    8000213e:	1101                	addi	sp,sp,-32
    80002140:	ec06                	sd	ra,24(sp)
    80002142:	e822                	sd	s0,16(sp)
    80002144:	e426                	sd	s1,8(sp)
    80002146:	e04a                	sd	s2,0(sp)
    80002148:	1000                	addi	s0,sp,32
    8000214a:	84aa                	mv	s1,a0
    8000214c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	ea8080e7          	jalr	-344(ra) # 80000ff6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002156:	653c                	ld	a5,72(a0)
    80002158:	02f4f863          	bgeu	s1,a5,80002188 <fetchaddr+0x4a>
    8000215c:	00848713          	addi	a4,s1,8
    80002160:	02e7e663          	bltu	a5,a4,8000218c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002164:	46a1                	li	a3,8
    80002166:	8626                	mv	a2,s1
    80002168:	85ca                	mv	a1,s2
    8000216a:	6928                	ld	a0,80(a0)
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	bd4080e7          	jalr	-1068(ra) # 80000d40 <copyin>
    80002174:	00a03533          	snez	a0,a0
    80002178:	40a00533          	neg	a0,a0
}
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	64a2                	ld	s1,8(sp)
    80002182:	6902                	ld	s2,0(sp)
    80002184:	6105                	addi	sp,sp,32
    80002186:	8082                	ret
    return -1;
    80002188:	557d                	li	a0,-1
    8000218a:	bfcd                	j	8000217c <fetchaddr+0x3e>
    8000218c:	557d                	li	a0,-1
    8000218e:	b7fd                	j	8000217c <fetchaddr+0x3e>

0000000080002190 <fetchstr>:
{
    80002190:	7179                	addi	sp,sp,-48
    80002192:	f406                	sd	ra,40(sp)
    80002194:	f022                	sd	s0,32(sp)
    80002196:	ec26                	sd	s1,24(sp)
    80002198:	e84a                	sd	s2,16(sp)
    8000219a:	e44e                	sd	s3,8(sp)
    8000219c:	1800                	addi	s0,sp,48
    8000219e:	892a                	mv	s2,a0
    800021a0:	84ae                	mv	s1,a1
    800021a2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	e52080e7          	jalr	-430(ra) # 80000ff6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800021ac:	86ce                	mv	a3,s3
    800021ae:	864a                	mv	a2,s2
    800021b0:	85a6                	mv	a1,s1
    800021b2:	6928                	ld	a0,80(a0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	c18080e7          	jalr	-1000(ra) # 80000dcc <copyinstr>
    800021bc:	00054e63          	bltz	a0,800021d8 <fetchstr+0x48>
  return strlen(buf);
    800021c0:	8526                	mv	a0,s1
    800021c2:	ffffe097          	auipc	ra,0xffffe
    800021c6:	212080e7          	jalr	530(ra) # 800003d4 <strlen>
}
    800021ca:	70a2                	ld	ra,40(sp)
    800021cc:	7402                	ld	s0,32(sp)
    800021ce:	64e2                	ld	s1,24(sp)
    800021d0:	6942                	ld	s2,16(sp)
    800021d2:	69a2                	ld	s3,8(sp)
    800021d4:	6145                	addi	sp,sp,48
    800021d6:	8082                	ret
    return -1;
    800021d8:	557d                	li	a0,-1
    800021da:	bfc5                	j	800021ca <fetchstr+0x3a>

00000000800021dc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	e426                	sd	s1,8(sp)
    800021e4:	1000                	addi	s0,sp,32
    800021e6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	eee080e7          	jalr	-274(ra) # 800020d6 <argraw>
    800021f0:	c088                	sw	a0,0(s1)
}
    800021f2:	60e2                	ld	ra,24(sp)
    800021f4:	6442                	ld	s0,16(sp)
    800021f6:	64a2                	ld	s1,8(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret

00000000800021fc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	e426                	sd	s1,8(sp)
    80002204:	1000                	addi	s0,sp,32
    80002206:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	ece080e7          	jalr	-306(ra) # 800020d6 <argraw>
    80002210:	e088                	sd	a0,0(s1)
}
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	64a2                	ld	s1,8(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000221c:	7179                	addi	sp,sp,-48
    8000221e:	f406                	sd	ra,40(sp)
    80002220:	f022                	sd	s0,32(sp)
    80002222:	ec26                	sd	s1,24(sp)
    80002224:	e84a                	sd	s2,16(sp)
    80002226:	1800                	addi	s0,sp,48
    80002228:	84ae                	mv	s1,a1
    8000222a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000222c:	fd840593          	addi	a1,s0,-40
    80002230:	00000097          	auipc	ra,0x0
    80002234:	fcc080e7          	jalr	-52(ra) # 800021fc <argaddr>
  return fetchstr(addr, buf, max);
    80002238:	864a                	mv	a2,s2
    8000223a:	85a6                	mv	a1,s1
    8000223c:	fd843503          	ld	a0,-40(s0)
    80002240:	00000097          	auipc	ra,0x0
    80002244:	f50080e7          	jalr	-176(ra) # 80002190 <fetchstr>
}
    80002248:	70a2                	ld	ra,40(sp)
    8000224a:	7402                	ld	s0,32(sp)
    8000224c:	64e2                	ld	s1,24(sp)
    8000224e:	6942                	ld	s2,16(sp)
    80002250:	6145                	addi	sp,sp,48
    80002252:	8082                	ret

0000000080002254 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002254:	1101                	addi	sp,sp,-32
    80002256:	ec06                	sd	ra,24(sp)
    80002258:	e822                	sd	s0,16(sp)
    8000225a:	e426                	sd	s1,8(sp)
    8000225c:	e04a                	sd	s2,0(sp)
    8000225e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	d96080e7          	jalr	-618(ra) # 80000ff6 <myproc>
    80002268:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000226a:	05853903          	ld	s2,88(a0)
    8000226e:	0a893783          	ld	a5,168(s2)
    80002272:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002276:	37fd                	addiw	a5,a5,-1
    80002278:	4751                	li	a4,20
    8000227a:	00f76f63          	bltu	a4,a5,80002298 <syscall+0x44>
    8000227e:	00369713          	slli	a4,a3,0x3
    80002282:	00006797          	auipc	a5,0x6
    80002286:	1a678793          	addi	a5,a5,422 # 80008428 <syscalls>
    8000228a:	97ba                	add	a5,a5,a4
    8000228c:	639c                	ld	a5,0(a5)
    8000228e:	c789                	beqz	a5,80002298 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002290:	9782                	jalr	a5
    80002292:	06a93823          	sd	a0,112(s2)
    80002296:	a839                	j	800022b4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002298:	15848613          	addi	a2,s1,344
    8000229c:	588c                	lw	a1,48(s1)
    8000229e:	00006517          	auipc	a0,0x6
    800022a2:	15250513          	addi	a0,a0,338 # 800083f0 <states.1724+0x150>
    800022a6:	00004097          	auipc	ra,0x4
    800022aa:	bf6080e7          	jalr	-1034(ra) # 80005e9c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022ae:	6cbc                	ld	a5,88(s1)
    800022b0:	577d                	li	a4,-1
    800022b2:	fbb8                	sd	a4,112(a5)
  }
}
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	64a2                	ld	s1,8(sp)
    800022ba:	6902                	ld	s2,0(sp)
    800022bc:	6105                	addi	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800022c0:	1101                	addi	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800022c8:	fec40593          	addi	a1,s0,-20
    800022cc:	4501                	li	a0,0
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	f0e080e7          	jalr	-242(ra) # 800021dc <argint>
  exit(n);
    800022d6:	fec42503          	lw	a0,-20(s0)
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	4f8080e7          	jalr	1272(ra) # 800017d2 <exit>
  return 0;  // not reached
}
    800022e2:	4501                	li	a0,0
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret

00000000800022ec <sys_getpid>:

uint64
sys_getpid(void)
{
    800022ec:	1141                	addi	sp,sp,-16
    800022ee:	e406                	sd	ra,8(sp)
    800022f0:	e022                	sd	s0,0(sp)
    800022f2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	d02080e7          	jalr	-766(ra) # 80000ff6 <myproc>
}
    800022fc:	5908                	lw	a0,48(a0)
    800022fe:	60a2                	ld	ra,8(sp)
    80002300:	6402                	ld	s0,0(sp)
    80002302:	0141                	addi	sp,sp,16
    80002304:	8082                	ret

0000000080002306 <sys_fork>:

uint64
sys_fork(void)
{
    80002306:	1141                	addi	sp,sp,-16
    80002308:	e406                	sd	ra,8(sp)
    8000230a:	e022                	sd	s0,0(sp)
    8000230c:	0800                	addi	s0,sp,16
  return fork();
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	0a2080e7          	jalr	162(ra) # 800013b0 <fork>
}
    80002316:	60a2                	ld	ra,8(sp)
    80002318:	6402                	ld	s0,0(sp)
    8000231a:	0141                	addi	sp,sp,16
    8000231c:	8082                	ret

000000008000231e <sys_wait>:

uint64
sys_wait(void)
{
    8000231e:	1101                	addi	sp,sp,-32
    80002320:	ec06                	sd	ra,24(sp)
    80002322:	e822                	sd	s0,16(sp)
    80002324:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002326:	fe840593          	addi	a1,s0,-24
    8000232a:	4501                	li	a0,0
    8000232c:	00000097          	auipc	ra,0x0
    80002330:	ed0080e7          	jalr	-304(ra) # 800021fc <argaddr>
  return wait(p);
    80002334:	fe843503          	ld	a0,-24(s0)
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	640080e7          	jalr	1600(ra) # 80001978 <wait>
}
    80002340:	60e2                	ld	ra,24(sp)
    80002342:	6442                	ld	s0,16(sp)
    80002344:	6105                	addi	sp,sp,32
    80002346:	8082                	ret

0000000080002348 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002348:	7179                	addi	sp,sp,-48
    8000234a:	f406                	sd	ra,40(sp)
    8000234c:	f022                	sd	s0,32(sp)
    8000234e:	ec26                	sd	s1,24(sp)
    80002350:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002352:	fdc40593          	addi	a1,s0,-36
    80002356:	4501                	li	a0,0
    80002358:	00000097          	auipc	ra,0x0
    8000235c:	e84080e7          	jalr	-380(ra) # 800021dc <argint>
  addr = myproc()->sz;
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	c96080e7          	jalr	-874(ra) # 80000ff6 <myproc>
    80002368:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000236a:	fdc42503          	lw	a0,-36(s0)
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	fe6080e7          	jalr	-26(ra) # 80001354 <growproc>
    80002376:	00054863          	bltz	a0,80002386 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000237a:	8526                	mv	a0,s1
    8000237c:	70a2                	ld	ra,40(sp)
    8000237e:	7402                	ld	s0,32(sp)
    80002380:	64e2                	ld	s1,24(sp)
    80002382:	6145                	addi	sp,sp,48
    80002384:	8082                	ret
    return -1;
    80002386:	54fd                	li	s1,-1
    80002388:	bfcd                	j	8000237a <sys_sbrk+0x32>

000000008000238a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000238a:	7139                	addi	sp,sp,-64
    8000238c:	fc06                	sd	ra,56(sp)
    8000238e:	f822                	sd	s0,48(sp)
    80002390:	f426                	sd	s1,40(sp)
    80002392:	f04a                	sd	s2,32(sp)
    80002394:	ec4e                	sd	s3,24(sp)
    80002396:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002398:	fcc40593          	addi	a1,s0,-52
    8000239c:	4501                	li	a0,0
    8000239e:	00000097          	auipc	ra,0x0
    800023a2:	e3e080e7          	jalr	-450(ra) # 800021dc <argint>
  if(n < 0)
    800023a6:	fcc42783          	lw	a5,-52(s0)
    800023aa:	0607cf63          	bltz	a5,80002428 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800023ae:	0022c517          	auipc	a0,0x22c
    800023b2:	3e250513          	addi	a0,a0,994 # 8022e790 <tickslock>
    800023b6:	00004097          	auipc	ra,0x4
    800023ba:	fe6080e7          	jalr	-26(ra) # 8000639c <acquire>
  ticks0 = ticks;
    800023be:	00006917          	auipc	s2,0x6
    800023c2:	56a92903          	lw	s2,1386(s2) # 80008928 <ticks>
  while(ticks - ticks0 < n){
    800023c6:	fcc42783          	lw	a5,-52(s0)
    800023ca:	cf9d                	beqz	a5,80002408 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023cc:	0022c997          	auipc	s3,0x22c
    800023d0:	3c498993          	addi	s3,s3,964 # 8022e790 <tickslock>
    800023d4:	00006497          	auipc	s1,0x6
    800023d8:	55448493          	addi	s1,s1,1364 # 80008928 <ticks>
    if(killed(myproc())){
    800023dc:	fffff097          	auipc	ra,0xfffff
    800023e0:	c1a080e7          	jalr	-998(ra) # 80000ff6 <myproc>
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	562080e7          	jalr	1378(ra) # 80001946 <killed>
    800023ec:	e129                	bnez	a0,8000242e <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800023ee:	85ce                	mv	a1,s3
    800023f0:	8526                	mv	a0,s1
    800023f2:	fffff097          	auipc	ra,0xfffff
    800023f6:	2ac080e7          	jalr	684(ra) # 8000169e <sleep>
  while(ticks - ticks0 < n){
    800023fa:	409c                	lw	a5,0(s1)
    800023fc:	412787bb          	subw	a5,a5,s2
    80002400:	fcc42703          	lw	a4,-52(s0)
    80002404:	fce7ece3          	bltu	a5,a4,800023dc <sys_sleep+0x52>
  }
  release(&tickslock);
    80002408:	0022c517          	auipc	a0,0x22c
    8000240c:	38850513          	addi	a0,a0,904 # 8022e790 <tickslock>
    80002410:	00004097          	auipc	ra,0x4
    80002414:	040080e7          	jalr	64(ra) # 80006450 <release>
  return 0;
    80002418:	4501                	li	a0,0
}
    8000241a:	70e2                	ld	ra,56(sp)
    8000241c:	7442                	ld	s0,48(sp)
    8000241e:	74a2                	ld	s1,40(sp)
    80002420:	7902                	ld	s2,32(sp)
    80002422:	69e2                	ld	s3,24(sp)
    80002424:	6121                	addi	sp,sp,64
    80002426:	8082                	ret
    n = 0;
    80002428:	fc042623          	sw	zero,-52(s0)
    8000242c:	b749                	j	800023ae <sys_sleep+0x24>
      release(&tickslock);
    8000242e:	0022c517          	auipc	a0,0x22c
    80002432:	36250513          	addi	a0,a0,866 # 8022e790 <tickslock>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	01a080e7          	jalr	26(ra) # 80006450 <release>
      return -1;
    8000243e:	557d                	li	a0,-1
    80002440:	bfe9                	j	8000241a <sys_sleep+0x90>

0000000080002442 <sys_kill>:

uint64
sys_kill(void)
{
    80002442:	1101                	addi	sp,sp,-32
    80002444:	ec06                	sd	ra,24(sp)
    80002446:	e822                	sd	s0,16(sp)
    80002448:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000244a:	fec40593          	addi	a1,s0,-20
    8000244e:	4501                	li	a0,0
    80002450:	00000097          	auipc	ra,0x0
    80002454:	d8c080e7          	jalr	-628(ra) # 800021dc <argint>
  return kill(pid);
    80002458:	fec42503          	lw	a0,-20(s0)
    8000245c:	fffff097          	auipc	ra,0xfffff
    80002460:	44c080e7          	jalr	1100(ra) # 800018a8 <kill>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	6105                	addi	sp,sp,32
    8000246a:	8082                	ret

000000008000246c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000246c:	1101                	addi	sp,sp,-32
    8000246e:	ec06                	sd	ra,24(sp)
    80002470:	e822                	sd	s0,16(sp)
    80002472:	e426                	sd	s1,8(sp)
    80002474:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002476:	0022c517          	auipc	a0,0x22c
    8000247a:	31a50513          	addi	a0,a0,794 # 8022e790 <tickslock>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	f1e080e7          	jalr	-226(ra) # 8000639c <acquire>
  xticks = ticks;
    80002486:	00006497          	auipc	s1,0x6
    8000248a:	4a24a483          	lw	s1,1186(s1) # 80008928 <ticks>
  release(&tickslock);
    8000248e:	0022c517          	auipc	a0,0x22c
    80002492:	30250513          	addi	a0,a0,770 # 8022e790 <tickslock>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	fba080e7          	jalr	-70(ra) # 80006450 <release>
  return xticks;
}
    8000249e:	02049513          	slli	a0,s1,0x20
    800024a2:	9101                	srli	a0,a0,0x20
    800024a4:	60e2                	ld	ra,24(sp)
    800024a6:	6442                	ld	s0,16(sp)
    800024a8:	64a2                	ld	s1,8(sp)
    800024aa:	6105                	addi	sp,sp,32
    800024ac:	8082                	ret

00000000800024ae <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024ae:	7179                	addi	sp,sp,-48
    800024b0:	f406                	sd	ra,40(sp)
    800024b2:	f022                	sd	s0,32(sp)
    800024b4:	ec26                	sd	s1,24(sp)
    800024b6:	e84a                	sd	s2,16(sp)
    800024b8:	e44e                	sd	s3,8(sp)
    800024ba:	e052                	sd	s4,0(sp)
    800024bc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024be:	00006597          	auipc	a1,0x6
    800024c2:	01a58593          	addi	a1,a1,26 # 800084d8 <syscalls+0xb0>
    800024c6:	0022c517          	auipc	a0,0x22c
    800024ca:	2e250513          	addi	a0,a0,738 # 8022e7a8 <bcache>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	e3e080e7          	jalr	-450(ra) # 8000630c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024d6:	00234797          	auipc	a5,0x234
    800024da:	2d278793          	addi	a5,a5,722 # 802367a8 <bcache+0x8000>
    800024de:	00234717          	auipc	a4,0x234
    800024e2:	53270713          	addi	a4,a4,1330 # 80236a10 <bcache+0x8268>
    800024e6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024ea:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ee:	0022c497          	auipc	s1,0x22c
    800024f2:	2d248493          	addi	s1,s1,722 # 8022e7c0 <bcache+0x18>
    b->next = bcache.head.next;
    800024f6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024f8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024fa:	00006a17          	auipc	s4,0x6
    800024fe:	fe6a0a13          	addi	s4,s4,-26 # 800084e0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002502:	2b893783          	ld	a5,696(s2)
    80002506:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002508:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000250c:	85d2                	mv	a1,s4
    8000250e:	01048513          	addi	a0,s1,16
    80002512:	00001097          	auipc	ra,0x1
    80002516:	4c4080e7          	jalr	1220(ra) # 800039d6 <initsleeplock>
    bcache.head.next->prev = b;
    8000251a:	2b893783          	ld	a5,696(s2)
    8000251e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002520:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002524:	45848493          	addi	s1,s1,1112
    80002528:	fd349de3          	bne	s1,s3,80002502 <binit+0x54>
  }
}
    8000252c:	70a2                	ld	ra,40(sp)
    8000252e:	7402                	ld	s0,32(sp)
    80002530:	64e2                	ld	s1,24(sp)
    80002532:	6942                	ld	s2,16(sp)
    80002534:	69a2                	ld	s3,8(sp)
    80002536:	6a02                	ld	s4,0(sp)
    80002538:	6145                	addi	sp,sp,48
    8000253a:	8082                	ret

000000008000253c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000253c:	7179                	addi	sp,sp,-48
    8000253e:	f406                	sd	ra,40(sp)
    80002540:	f022                	sd	s0,32(sp)
    80002542:	ec26                	sd	s1,24(sp)
    80002544:	e84a                	sd	s2,16(sp)
    80002546:	e44e                	sd	s3,8(sp)
    80002548:	1800                	addi	s0,sp,48
    8000254a:	89aa                	mv	s3,a0
    8000254c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000254e:	0022c517          	auipc	a0,0x22c
    80002552:	25a50513          	addi	a0,a0,602 # 8022e7a8 <bcache>
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	e46080e7          	jalr	-442(ra) # 8000639c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000255e:	00234497          	auipc	s1,0x234
    80002562:	5024b483          	ld	s1,1282(s1) # 80236a60 <bcache+0x82b8>
    80002566:	00234797          	auipc	a5,0x234
    8000256a:	4aa78793          	addi	a5,a5,1194 # 80236a10 <bcache+0x8268>
    8000256e:	02f48f63          	beq	s1,a5,800025ac <bread+0x70>
    80002572:	873e                	mv	a4,a5
    80002574:	a021                	j	8000257c <bread+0x40>
    80002576:	68a4                	ld	s1,80(s1)
    80002578:	02e48a63          	beq	s1,a4,800025ac <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000257c:	449c                	lw	a5,8(s1)
    8000257e:	ff379ce3          	bne	a5,s3,80002576 <bread+0x3a>
    80002582:	44dc                	lw	a5,12(s1)
    80002584:	ff2799e3          	bne	a5,s2,80002576 <bread+0x3a>
      b->refcnt++;
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	2785                	addiw	a5,a5,1
    8000258c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000258e:	0022c517          	auipc	a0,0x22c
    80002592:	21a50513          	addi	a0,a0,538 # 8022e7a8 <bcache>
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	eba080e7          	jalr	-326(ra) # 80006450 <release>
      acquiresleep(&b->lock);
    8000259e:	01048513          	addi	a0,s1,16
    800025a2:	00001097          	auipc	ra,0x1
    800025a6:	46e080e7          	jalr	1134(ra) # 80003a10 <acquiresleep>
      return b;
    800025aa:	a8b9                	j	80002608 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025ac:	00234497          	auipc	s1,0x234
    800025b0:	4ac4b483          	ld	s1,1196(s1) # 80236a58 <bcache+0x82b0>
    800025b4:	00234797          	auipc	a5,0x234
    800025b8:	45c78793          	addi	a5,a5,1116 # 80236a10 <bcache+0x8268>
    800025bc:	00f48863          	beq	s1,a5,800025cc <bread+0x90>
    800025c0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025c2:	40bc                	lw	a5,64(s1)
    800025c4:	cf81                	beqz	a5,800025dc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025c6:	64a4                	ld	s1,72(s1)
    800025c8:	fee49de3          	bne	s1,a4,800025c2 <bread+0x86>
  panic("bget: no buffers");
    800025cc:	00006517          	auipc	a0,0x6
    800025d0:	f1c50513          	addi	a0,a0,-228 # 800084e8 <syscalls+0xc0>
    800025d4:	00004097          	auipc	ra,0x4
    800025d8:	87e080e7          	jalr	-1922(ra) # 80005e52 <panic>
      b->dev = dev;
    800025dc:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025e0:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025e4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025e8:	4785                	li	a5,1
    800025ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ec:	0022c517          	auipc	a0,0x22c
    800025f0:	1bc50513          	addi	a0,a0,444 # 8022e7a8 <bcache>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	e5c080e7          	jalr	-420(ra) # 80006450 <release>
      acquiresleep(&b->lock);
    800025fc:	01048513          	addi	a0,s1,16
    80002600:	00001097          	auipc	ra,0x1
    80002604:	410080e7          	jalr	1040(ra) # 80003a10 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002608:	409c                	lw	a5,0(s1)
    8000260a:	cb89                	beqz	a5,8000261c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000260c:	8526                	mv	a0,s1
    8000260e:	70a2                	ld	ra,40(sp)
    80002610:	7402                	ld	s0,32(sp)
    80002612:	64e2                	ld	s1,24(sp)
    80002614:	6942                	ld	s2,16(sp)
    80002616:	69a2                	ld	s3,8(sp)
    80002618:	6145                	addi	sp,sp,48
    8000261a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000261c:	4581                	li	a1,0
    8000261e:	8526                	mv	a0,s1
    80002620:	00003097          	auipc	ra,0x3
    80002624:	fc8080e7          	jalr	-56(ra) # 800055e8 <virtio_disk_rw>
    b->valid = 1;
    80002628:	4785                	li	a5,1
    8000262a:	c09c                	sw	a5,0(s1)
  return b;
    8000262c:	b7c5                	j	8000260c <bread+0xd0>

000000008000262e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000262e:	1101                	addi	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	e426                	sd	s1,8(sp)
    80002636:	1000                	addi	s0,sp,32
    80002638:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000263a:	0541                	addi	a0,a0,16
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	46e080e7          	jalr	1134(ra) # 80003aaa <holdingsleep>
    80002644:	cd01                	beqz	a0,8000265c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002646:	4585                	li	a1,1
    80002648:	8526                	mv	a0,s1
    8000264a:	00003097          	auipc	ra,0x3
    8000264e:	f9e080e7          	jalr	-98(ra) # 800055e8 <virtio_disk_rw>
}
    80002652:	60e2                	ld	ra,24(sp)
    80002654:	6442                	ld	s0,16(sp)
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	6105                	addi	sp,sp,32
    8000265a:	8082                	ret
    panic("bwrite");
    8000265c:	00006517          	auipc	a0,0x6
    80002660:	ea450513          	addi	a0,a0,-348 # 80008500 <syscalls+0xd8>
    80002664:	00003097          	auipc	ra,0x3
    80002668:	7ee080e7          	jalr	2030(ra) # 80005e52 <panic>

000000008000266c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000266c:	1101                	addi	sp,sp,-32
    8000266e:	ec06                	sd	ra,24(sp)
    80002670:	e822                	sd	s0,16(sp)
    80002672:	e426                	sd	s1,8(sp)
    80002674:	e04a                	sd	s2,0(sp)
    80002676:	1000                	addi	s0,sp,32
    80002678:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000267a:	01050913          	addi	s2,a0,16
    8000267e:	854a                	mv	a0,s2
    80002680:	00001097          	auipc	ra,0x1
    80002684:	42a080e7          	jalr	1066(ra) # 80003aaa <holdingsleep>
    80002688:	c92d                	beqz	a0,800026fa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000268a:	854a                	mv	a0,s2
    8000268c:	00001097          	auipc	ra,0x1
    80002690:	3da080e7          	jalr	986(ra) # 80003a66 <releasesleep>

  acquire(&bcache.lock);
    80002694:	0022c517          	auipc	a0,0x22c
    80002698:	11450513          	addi	a0,a0,276 # 8022e7a8 <bcache>
    8000269c:	00004097          	auipc	ra,0x4
    800026a0:	d00080e7          	jalr	-768(ra) # 8000639c <acquire>
  b->refcnt--;
    800026a4:	40bc                	lw	a5,64(s1)
    800026a6:	37fd                	addiw	a5,a5,-1
    800026a8:	0007871b          	sext.w	a4,a5
    800026ac:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026ae:	eb05                	bnez	a4,800026de <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026b0:	68bc                	ld	a5,80(s1)
    800026b2:	64b8                	ld	a4,72(s1)
    800026b4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026b6:	64bc                	ld	a5,72(s1)
    800026b8:	68b8                	ld	a4,80(s1)
    800026ba:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026bc:	00234797          	auipc	a5,0x234
    800026c0:	0ec78793          	addi	a5,a5,236 # 802367a8 <bcache+0x8000>
    800026c4:	2b87b703          	ld	a4,696(a5)
    800026c8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026ca:	00234717          	auipc	a4,0x234
    800026ce:	34670713          	addi	a4,a4,838 # 80236a10 <bcache+0x8268>
    800026d2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026d4:	2b87b703          	ld	a4,696(a5)
    800026d8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026da:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026de:	0022c517          	auipc	a0,0x22c
    800026e2:	0ca50513          	addi	a0,a0,202 # 8022e7a8 <bcache>
    800026e6:	00004097          	auipc	ra,0x4
    800026ea:	d6a080e7          	jalr	-662(ra) # 80006450 <release>
}
    800026ee:	60e2                	ld	ra,24(sp)
    800026f0:	6442                	ld	s0,16(sp)
    800026f2:	64a2                	ld	s1,8(sp)
    800026f4:	6902                	ld	s2,0(sp)
    800026f6:	6105                	addi	sp,sp,32
    800026f8:	8082                	ret
    panic("brelse");
    800026fa:	00006517          	auipc	a0,0x6
    800026fe:	e0e50513          	addi	a0,a0,-498 # 80008508 <syscalls+0xe0>
    80002702:	00003097          	auipc	ra,0x3
    80002706:	750080e7          	jalr	1872(ra) # 80005e52 <panic>

000000008000270a <bpin>:

void
bpin(struct buf *b) {
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	1000                	addi	s0,sp,32
    80002714:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002716:	0022c517          	auipc	a0,0x22c
    8000271a:	09250513          	addi	a0,a0,146 # 8022e7a8 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	c7e080e7          	jalr	-898(ra) # 8000639c <acquire>
  b->refcnt++;
    80002726:	40bc                	lw	a5,64(s1)
    80002728:	2785                	addiw	a5,a5,1
    8000272a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000272c:	0022c517          	auipc	a0,0x22c
    80002730:	07c50513          	addi	a0,a0,124 # 8022e7a8 <bcache>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	d1c080e7          	jalr	-740(ra) # 80006450 <release>
}
    8000273c:	60e2                	ld	ra,24(sp)
    8000273e:	6442                	ld	s0,16(sp)
    80002740:	64a2                	ld	s1,8(sp)
    80002742:	6105                	addi	sp,sp,32
    80002744:	8082                	ret

0000000080002746 <bunpin>:

void
bunpin(struct buf *b) {
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002752:	0022c517          	auipc	a0,0x22c
    80002756:	05650513          	addi	a0,a0,86 # 8022e7a8 <bcache>
    8000275a:	00004097          	auipc	ra,0x4
    8000275e:	c42080e7          	jalr	-958(ra) # 8000639c <acquire>
  b->refcnt--;
    80002762:	40bc                	lw	a5,64(s1)
    80002764:	37fd                	addiw	a5,a5,-1
    80002766:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002768:	0022c517          	auipc	a0,0x22c
    8000276c:	04050513          	addi	a0,a0,64 # 8022e7a8 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	ce0080e7          	jalr	-800(ra) # 80006450 <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	e04a                	sd	s2,0(sp)
    8000278c:	1000                	addi	s0,sp,32
    8000278e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002790:	00d5d59b          	srliw	a1,a1,0xd
    80002794:	00234797          	auipc	a5,0x234
    80002798:	6f07a783          	lw	a5,1776(a5) # 80236e84 <sb+0x1c>
    8000279c:	9dbd                	addw	a1,a1,a5
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	d9e080e7          	jalr	-610(ra) # 8000253c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027a6:	0074f713          	andi	a4,s1,7
    800027aa:	4785                	li	a5,1
    800027ac:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027b0:	14ce                	slli	s1,s1,0x33
    800027b2:	90d9                	srli	s1,s1,0x36
    800027b4:	00950733          	add	a4,a0,s1
    800027b8:	05874703          	lbu	a4,88(a4)
    800027bc:	00e7f6b3          	and	a3,a5,a4
    800027c0:	c69d                	beqz	a3,800027ee <bfree+0x6c>
    800027c2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027c4:	94aa                	add	s1,s1,a0
    800027c6:	fff7c793          	not	a5,a5
    800027ca:	8ff9                	and	a5,a5,a4
    800027cc:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027d0:	00001097          	auipc	ra,0x1
    800027d4:	120080e7          	jalr	288(ra) # 800038f0 <log_write>
  brelse(bp);
    800027d8:	854a                	mv	a0,s2
    800027da:	00000097          	auipc	ra,0x0
    800027de:	e92080e7          	jalr	-366(ra) # 8000266c <brelse>
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6902                	ld	s2,0(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret
    panic("freeing free block");
    800027ee:	00006517          	auipc	a0,0x6
    800027f2:	d2250513          	addi	a0,a0,-734 # 80008510 <syscalls+0xe8>
    800027f6:	00003097          	auipc	ra,0x3
    800027fa:	65c080e7          	jalr	1628(ra) # 80005e52 <panic>

00000000800027fe <balloc>:
{
    800027fe:	711d                	addi	sp,sp,-96
    80002800:	ec86                	sd	ra,88(sp)
    80002802:	e8a2                	sd	s0,80(sp)
    80002804:	e4a6                	sd	s1,72(sp)
    80002806:	e0ca                	sd	s2,64(sp)
    80002808:	fc4e                	sd	s3,56(sp)
    8000280a:	f852                	sd	s4,48(sp)
    8000280c:	f456                	sd	s5,40(sp)
    8000280e:	f05a                	sd	s6,32(sp)
    80002810:	ec5e                	sd	s7,24(sp)
    80002812:	e862                	sd	s8,16(sp)
    80002814:	e466                	sd	s9,8(sp)
    80002816:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002818:	00234797          	auipc	a5,0x234
    8000281c:	6547a783          	lw	a5,1620(a5) # 80236e6c <sb+0x4>
    80002820:	10078163          	beqz	a5,80002922 <balloc+0x124>
    80002824:	8baa                	mv	s7,a0
    80002826:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002828:	00234b17          	auipc	s6,0x234
    8000282c:	640b0b13          	addi	s6,s6,1600 # 80236e68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002830:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002832:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002834:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002836:	6c89                	lui	s9,0x2
    80002838:	a061                	j	800028c0 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000283a:	974a                	add	a4,a4,s2
    8000283c:	8fd5                	or	a5,a5,a3
    8000283e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002842:	854a                	mv	a0,s2
    80002844:	00001097          	auipc	ra,0x1
    80002848:	0ac080e7          	jalr	172(ra) # 800038f0 <log_write>
        brelse(bp);
    8000284c:	854a                	mv	a0,s2
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	e1e080e7          	jalr	-482(ra) # 8000266c <brelse>
  bp = bread(dev, bno);
    80002856:	85a6                	mv	a1,s1
    80002858:	855e                	mv	a0,s7
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	ce2080e7          	jalr	-798(ra) # 8000253c <bread>
    80002862:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002864:	40000613          	li	a2,1024
    80002868:	4581                	li	a1,0
    8000286a:	05850513          	addi	a0,a0,88
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	9e2080e7          	jalr	-1566(ra) # 80000250 <memset>
  log_write(bp);
    80002876:	854a                	mv	a0,s2
    80002878:	00001097          	auipc	ra,0x1
    8000287c:	078080e7          	jalr	120(ra) # 800038f0 <log_write>
  brelse(bp);
    80002880:	854a                	mv	a0,s2
    80002882:	00000097          	auipc	ra,0x0
    80002886:	dea080e7          	jalr	-534(ra) # 8000266c <brelse>
}
    8000288a:	8526                	mv	a0,s1
    8000288c:	60e6                	ld	ra,88(sp)
    8000288e:	6446                	ld	s0,80(sp)
    80002890:	64a6                	ld	s1,72(sp)
    80002892:	6906                	ld	s2,64(sp)
    80002894:	79e2                	ld	s3,56(sp)
    80002896:	7a42                	ld	s4,48(sp)
    80002898:	7aa2                	ld	s5,40(sp)
    8000289a:	7b02                	ld	s6,32(sp)
    8000289c:	6be2                	ld	s7,24(sp)
    8000289e:	6c42                	ld	s8,16(sp)
    800028a0:	6ca2                	ld	s9,8(sp)
    800028a2:	6125                	addi	sp,sp,96
    800028a4:	8082                	ret
    brelse(bp);
    800028a6:	854a                	mv	a0,s2
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	dc4080e7          	jalr	-572(ra) # 8000266c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028b0:	015c87bb          	addw	a5,s9,s5
    800028b4:	00078a9b          	sext.w	s5,a5
    800028b8:	004b2703          	lw	a4,4(s6)
    800028bc:	06eaf363          	bgeu	s5,a4,80002922 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800028c0:	41fad79b          	sraiw	a5,s5,0x1f
    800028c4:	0137d79b          	srliw	a5,a5,0x13
    800028c8:	015787bb          	addw	a5,a5,s5
    800028cc:	40d7d79b          	sraiw	a5,a5,0xd
    800028d0:	01cb2583          	lw	a1,28(s6)
    800028d4:	9dbd                	addw	a1,a1,a5
    800028d6:	855e                	mv	a0,s7
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	c64080e7          	jalr	-924(ra) # 8000253c <bread>
    800028e0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e2:	004b2503          	lw	a0,4(s6)
    800028e6:	000a849b          	sext.w	s1,s5
    800028ea:	8662                	mv	a2,s8
    800028ec:	faa4fde3          	bgeu	s1,a0,800028a6 <balloc+0xa8>
      m = 1 << (bi % 8);
    800028f0:	41f6579b          	sraiw	a5,a2,0x1f
    800028f4:	01d7d69b          	srliw	a3,a5,0x1d
    800028f8:	00c6873b          	addw	a4,a3,a2
    800028fc:	00777793          	andi	a5,a4,7
    80002900:	9f95                	subw	a5,a5,a3
    80002902:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002906:	4037571b          	sraiw	a4,a4,0x3
    8000290a:	00e906b3          	add	a3,s2,a4
    8000290e:	0586c683          	lbu	a3,88(a3)
    80002912:	00d7f5b3          	and	a1,a5,a3
    80002916:	d195                	beqz	a1,8000283a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002918:	2605                	addiw	a2,a2,1
    8000291a:	2485                	addiw	s1,s1,1
    8000291c:	fd4618e3          	bne	a2,s4,800028ec <balloc+0xee>
    80002920:	b759                	j	800028a6 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002922:	00006517          	auipc	a0,0x6
    80002926:	c0650513          	addi	a0,a0,-1018 # 80008528 <syscalls+0x100>
    8000292a:	00003097          	auipc	ra,0x3
    8000292e:	572080e7          	jalr	1394(ra) # 80005e9c <printf>
  return 0;
    80002932:	4481                	li	s1,0
    80002934:	bf99                	j	8000288a <balloc+0x8c>

0000000080002936 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002936:	7179                	addi	sp,sp,-48
    80002938:	f406                	sd	ra,40(sp)
    8000293a:	f022                	sd	s0,32(sp)
    8000293c:	ec26                	sd	s1,24(sp)
    8000293e:	e84a                	sd	s2,16(sp)
    80002940:	e44e                	sd	s3,8(sp)
    80002942:	e052                	sd	s4,0(sp)
    80002944:	1800                	addi	s0,sp,48
    80002946:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002948:	47ad                	li	a5,11
    8000294a:	02b7e763          	bltu	a5,a1,80002978 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000294e:	02059493          	slli	s1,a1,0x20
    80002952:	9081                	srli	s1,s1,0x20
    80002954:	048a                	slli	s1,s1,0x2
    80002956:	94aa                	add	s1,s1,a0
    80002958:	0504a903          	lw	s2,80(s1)
    8000295c:	06091e63          	bnez	s2,800029d8 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002960:	4108                	lw	a0,0(a0)
    80002962:	00000097          	auipc	ra,0x0
    80002966:	e9c080e7          	jalr	-356(ra) # 800027fe <balloc>
    8000296a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000296e:	06090563          	beqz	s2,800029d8 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002972:	0524a823          	sw	s2,80(s1)
    80002976:	a08d                	j	800029d8 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002978:	ff45849b          	addiw	s1,a1,-12
    8000297c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002980:	0ff00793          	li	a5,255
    80002984:	08e7e563          	bltu	a5,a4,80002a0e <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002988:	08052903          	lw	s2,128(a0)
    8000298c:	00091d63          	bnez	s2,800029a6 <bmap+0x70>
      addr = balloc(ip->dev);
    80002990:	4108                	lw	a0,0(a0)
    80002992:	00000097          	auipc	ra,0x0
    80002996:	e6c080e7          	jalr	-404(ra) # 800027fe <balloc>
    8000299a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000299e:	02090d63          	beqz	s2,800029d8 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029a2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029a6:	85ca                	mv	a1,s2
    800029a8:	0009a503          	lw	a0,0(s3)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	b90080e7          	jalr	-1136(ra) # 8000253c <bread>
    800029b4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029b6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029ba:	02049593          	slli	a1,s1,0x20
    800029be:	9181                	srli	a1,a1,0x20
    800029c0:	058a                	slli	a1,a1,0x2
    800029c2:	00b784b3          	add	s1,a5,a1
    800029c6:	0004a903          	lw	s2,0(s1)
    800029ca:	02090063          	beqz	s2,800029ea <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029ce:	8552                	mv	a0,s4
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	c9c080e7          	jalr	-868(ra) # 8000266c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029d8:	854a                	mv	a0,s2
    800029da:	70a2                	ld	ra,40(sp)
    800029dc:	7402                	ld	s0,32(sp)
    800029de:	64e2                	ld	s1,24(sp)
    800029e0:	6942                	ld	s2,16(sp)
    800029e2:	69a2                	ld	s3,8(sp)
    800029e4:	6a02                	ld	s4,0(sp)
    800029e6:	6145                	addi	sp,sp,48
    800029e8:	8082                	ret
      addr = balloc(ip->dev);
    800029ea:	0009a503          	lw	a0,0(s3)
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	e10080e7          	jalr	-496(ra) # 800027fe <balloc>
    800029f6:	0005091b          	sext.w	s2,a0
      if(addr){
    800029fa:	fc090ae3          	beqz	s2,800029ce <bmap+0x98>
        a[bn] = addr;
    800029fe:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a02:	8552                	mv	a0,s4
    80002a04:	00001097          	auipc	ra,0x1
    80002a08:	eec080e7          	jalr	-276(ra) # 800038f0 <log_write>
    80002a0c:	b7c9                	j	800029ce <bmap+0x98>
  panic("bmap: out of range");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	b3250513          	addi	a0,a0,-1230 # 80008540 <syscalls+0x118>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	43c080e7          	jalr	1084(ra) # 80005e52 <panic>

0000000080002a1e <iget>:
{
    80002a1e:	7179                	addi	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	e052                	sd	s4,0(sp)
    80002a2c:	1800                	addi	s0,sp,48
    80002a2e:	89aa                	mv	s3,a0
    80002a30:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a32:	00234517          	auipc	a0,0x234
    80002a36:	45650513          	addi	a0,a0,1110 # 80236e88 <itable>
    80002a3a:	00004097          	auipc	ra,0x4
    80002a3e:	962080e7          	jalr	-1694(ra) # 8000639c <acquire>
  empty = 0;
    80002a42:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a44:	00234497          	auipc	s1,0x234
    80002a48:	45c48493          	addi	s1,s1,1116 # 80236ea0 <itable+0x18>
    80002a4c:	00236697          	auipc	a3,0x236
    80002a50:	ee468693          	addi	a3,a3,-284 # 80238930 <log>
    80002a54:	a039                	j	80002a62 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a56:	02090b63          	beqz	s2,80002a8c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5a:	08848493          	addi	s1,s1,136
    80002a5e:	02d48a63          	beq	s1,a3,80002a92 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a62:	449c                	lw	a5,8(s1)
    80002a64:	fef059e3          	blez	a5,80002a56 <iget+0x38>
    80002a68:	4098                	lw	a4,0(s1)
    80002a6a:	ff3716e3          	bne	a4,s3,80002a56 <iget+0x38>
    80002a6e:	40d8                	lw	a4,4(s1)
    80002a70:	ff4713e3          	bne	a4,s4,80002a56 <iget+0x38>
      ip->ref++;
    80002a74:	2785                	addiw	a5,a5,1
    80002a76:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a78:	00234517          	auipc	a0,0x234
    80002a7c:	41050513          	addi	a0,a0,1040 # 80236e88 <itable>
    80002a80:	00004097          	auipc	ra,0x4
    80002a84:	9d0080e7          	jalr	-1584(ra) # 80006450 <release>
      return ip;
    80002a88:	8926                	mv	s2,s1
    80002a8a:	a03d                	j	80002ab8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a8c:	f7f9                	bnez	a5,80002a5a <iget+0x3c>
    80002a8e:	8926                	mv	s2,s1
    80002a90:	b7e9                	j	80002a5a <iget+0x3c>
  if(empty == 0)
    80002a92:	02090c63          	beqz	s2,80002aca <iget+0xac>
  ip->dev = dev;
    80002a96:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a9a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a9e:	4785                	li	a5,1
    80002aa0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aa4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002aa8:	00234517          	auipc	a0,0x234
    80002aac:	3e050513          	addi	a0,a0,992 # 80236e88 <itable>
    80002ab0:	00004097          	auipc	ra,0x4
    80002ab4:	9a0080e7          	jalr	-1632(ra) # 80006450 <release>
}
    80002ab8:	854a                	mv	a0,s2
    80002aba:	70a2                	ld	ra,40(sp)
    80002abc:	7402                	ld	s0,32(sp)
    80002abe:	64e2                	ld	s1,24(sp)
    80002ac0:	6942                	ld	s2,16(sp)
    80002ac2:	69a2                	ld	s3,8(sp)
    80002ac4:	6a02                	ld	s4,0(sp)
    80002ac6:	6145                	addi	sp,sp,48
    80002ac8:	8082                	ret
    panic("iget: no inodes");
    80002aca:	00006517          	auipc	a0,0x6
    80002ace:	a8e50513          	addi	a0,a0,-1394 # 80008558 <syscalls+0x130>
    80002ad2:	00003097          	auipc	ra,0x3
    80002ad6:	380080e7          	jalr	896(ra) # 80005e52 <panic>

0000000080002ada <fsinit>:
fsinit(int dev) {
    80002ada:	7179                	addi	sp,sp,-48
    80002adc:	f406                	sd	ra,40(sp)
    80002ade:	f022                	sd	s0,32(sp)
    80002ae0:	ec26                	sd	s1,24(sp)
    80002ae2:	e84a                	sd	s2,16(sp)
    80002ae4:	e44e                	sd	s3,8(sp)
    80002ae6:	1800                	addi	s0,sp,48
    80002ae8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aea:	4585                	li	a1,1
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	a50080e7          	jalr	-1456(ra) # 8000253c <bread>
    80002af4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002af6:	00234997          	auipc	s3,0x234
    80002afa:	37298993          	addi	s3,s3,882 # 80236e68 <sb>
    80002afe:	02000613          	li	a2,32
    80002b02:	05850593          	addi	a1,a0,88
    80002b06:	854e                	mv	a0,s3
    80002b08:	ffffd097          	auipc	ra,0xffffd
    80002b0c:	7a8080e7          	jalr	1960(ra) # 800002b0 <memmove>
  brelse(bp);
    80002b10:	8526                	mv	a0,s1
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	b5a080e7          	jalr	-1190(ra) # 8000266c <brelse>
  if(sb.magic != FSMAGIC)
    80002b1a:	0009a703          	lw	a4,0(s3)
    80002b1e:	102037b7          	lui	a5,0x10203
    80002b22:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b26:	02f71263          	bne	a4,a5,80002b4a <fsinit+0x70>
  initlog(dev, &sb);
    80002b2a:	00234597          	auipc	a1,0x234
    80002b2e:	33e58593          	addi	a1,a1,830 # 80236e68 <sb>
    80002b32:	854a                	mv	a0,s2
    80002b34:	00001097          	auipc	ra,0x1
    80002b38:	b40080e7          	jalr	-1216(ra) # 80003674 <initlog>
}
    80002b3c:	70a2                	ld	ra,40(sp)
    80002b3e:	7402                	ld	s0,32(sp)
    80002b40:	64e2                	ld	s1,24(sp)
    80002b42:	6942                	ld	s2,16(sp)
    80002b44:	69a2                	ld	s3,8(sp)
    80002b46:	6145                	addi	sp,sp,48
    80002b48:	8082                	ret
    panic("invalid file system");
    80002b4a:	00006517          	auipc	a0,0x6
    80002b4e:	a1e50513          	addi	a0,a0,-1506 # 80008568 <syscalls+0x140>
    80002b52:	00003097          	auipc	ra,0x3
    80002b56:	300080e7          	jalr	768(ra) # 80005e52 <panic>

0000000080002b5a <iinit>:
{
    80002b5a:	7179                	addi	sp,sp,-48
    80002b5c:	f406                	sd	ra,40(sp)
    80002b5e:	f022                	sd	s0,32(sp)
    80002b60:	ec26                	sd	s1,24(sp)
    80002b62:	e84a                	sd	s2,16(sp)
    80002b64:	e44e                	sd	s3,8(sp)
    80002b66:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b68:	00006597          	auipc	a1,0x6
    80002b6c:	a1858593          	addi	a1,a1,-1512 # 80008580 <syscalls+0x158>
    80002b70:	00234517          	auipc	a0,0x234
    80002b74:	31850513          	addi	a0,a0,792 # 80236e88 <itable>
    80002b78:	00003097          	auipc	ra,0x3
    80002b7c:	794080e7          	jalr	1940(ra) # 8000630c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b80:	00234497          	auipc	s1,0x234
    80002b84:	33048493          	addi	s1,s1,816 # 80236eb0 <itable+0x28>
    80002b88:	00236997          	auipc	s3,0x236
    80002b8c:	db898993          	addi	s3,s3,-584 # 80238940 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b90:	00006917          	auipc	s2,0x6
    80002b94:	9f890913          	addi	s2,s2,-1544 # 80008588 <syscalls+0x160>
    80002b98:	85ca                	mv	a1,s2
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	00001097          	auipc	ra,0x1
    80002ba0:	e3a080e7          	jalr	-454(ra) # 800039d6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ba4:	08848493          	addi	s1,s1,136
    80002ba8:	ff3498e3          	bne	s1,s3,80002b98 <iinit+0x3e>
}
    80002bac:	70a2                	ld	ra,40(sp)
    80002bae:	7402                	ld	s0,32(sp)
    80002bb0:	64e2                	ld	s1,24(sp)
    80002bb2:	6942                	ld	s2,16(sp)
    80002bb4:	69a2                	ld	s3,8(sp)
    80002bb6:	6145                	addi	sp,sp,48
    80002bb8:	8082                	ret

0000000080002bba <ialloc>:
{
    80002bba:	715d                	addi	sp,sp,-80
    80002bbc:	e486                	sd	ra,72(sp)
    80002bbe:	e0a2                	sd	s0,64(sp)
    80002bc0:	fc26                	sd	s1,56(sp)
    80002bc2:	f84a                	sd	s2,48(sp)
    80002bc4:	f44e                	sd	s3,40(sp)
    80002bc6:	f052                	sd	s4,32(sp)
    80002bc8:	ec56                	sd	s5,24(sp)
    80002bca:	e85a                	sd	s6,16(sp)
    80002bcc:	e45e                	sd	s7,8(sp)
    80002bce:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd0:	00234717          	auipc	a4,0x234
    80002bd4:	2a472703          	lw	a4,676(a4) # 80236e74 <sb+0xc>
    80002bd8:	4785                	li	a5,1
    80002bda:	04e7fa63          	bgeu	a5,a4,80002c2e <ialloc+0x74>
    80002bde:	8aaa                	mv	s5,a0
    80002be0:	8bae                	mv	s7,a1
    80002be2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002be4:	00234a17          	auipc	s4,0x234
    80002be8:	284a0a13          	addi	s4,s4,644 # 80236e68 <sb>
    80002bec:	00048b1b          	sext.w	s6,s1
    80002bf0:	0044d593          	srli	a1,s1,0x4
    80002bf4:	018a2783          	lw	a5,24(s4)
    80002bf8:	9dbd                	addw	a1,a1,a5
    80002bfa:	8556                	mv	a0,s5
    80002bfc:	00000097          	auipc	ra,0x0
    80002c00:	940080e7          	jalr	-1728(ra) # 8000253c <bread>
    80002c04:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c06:	05850993          	addi	s3,a0,88
    80002c0a:	00f4f793          	andi	a5,s1,15
    80002c0e:	079a                	slli	a5,a5,0x6
    80002c10:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c12:	00099783          	lh	a5,0(s3)
    80002c16:	c3a1                	beqz	a5,80002c56 <ialloc+0x9c>
    brelse(bp);
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	a54080e7          	jalr	-1452(ra) # 8000266c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c20:	0485                	addi	s1,s1,1
    80002c22:	00ca2703          	lw	a4,12(s4)
    80002c26:	0004879b          	sext.w	a5,s1
    80002c2a:	fce7e1e3          	bltu	a5,a4,80002bec <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c2e:	00006517          	auipc	a0,0x6
    80002c32:	96250513          	addi	a0,a0,-1694 # 80008590 <syscalls+0x168>
    80002c36:	00003097          	auipc	ra,0x3
    80002c3a:	266080e7          	jalr	614(ra) # 80005e9c <printf>
  return 0;
    80002c3e:	4501                	li	a0,0
}
    80002c40:	60a6                	ld	ra,72(sp)
    80002c42:	6406                	ld	s0,64(sp)
    80002c44:	74e2                	ld	s1,56(sp)
    80002c46:	7942                	ld	s2,48(sp)
    80002c48:	79a2                	ld	s3,40(sp)
    80002c4a:	7a02                	ld	s4,32(sp)
    80002c4c:	6ae2                	ld	s5,24(sp)
    80002c4e:	6b42                	ld	s6,16(sp)
    80002c50:	6ba2                	ld	s7,8(sp)
    80002c52:	6161                	addi	sp,sp,80
    80002c54:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c56:	04000613          	li	a2,64
    80002c5a:	4581                	li	a1,0
    80002c5c:	854e                	mv	a0,s3
    80002c5e:	ffffd097          	auipc	ra,0xffffd
    80002c62:	5f2080e7          	jalr	1522(ra) # 80000250 <memset>
      dip->type = type;
    80002c66:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c6a:	854a                	mv	a0,s2
    80002c6c:	00001097          	auipc	ra,0x1
    80002c70:	c84080e7          	jalr	-892(ra) # 800038f0 <log_write>
      brelse(bp);
    80002c74:	854a                	mv	a0,s2
    80002c76:	00000097          	auipc	ra,0x0
    80002c7a:	9f6080e7          	jalr	-1546(ra) # 8000266c <brelse>
      return iget(dev, inum);
    80002c7e:	85da                	mv	a1,s6
    80002c80:	8556                	mv	a0,s5
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	d9c080e7          	jalr	-612(ra) # 80002a1e <iget>
    80002c8a:	bf5d                	j	80002c40 <ialloc+0x86>

0000000080002c8c <iupdate>:
{
    80002c8c:	1101                	addi	sp,sp,-32
    80002c8e:	ec06                	sd	ra,24(sp)
    80002c90:	e822                	sd	s0,16(sp)
    80002c92:	e426                	sd	s1,8(sp)
    80002c94:	e04a                	sd	s2,0(sp)
    80002c96:	1000                	addi	s0,sp,32
    80002c98:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c9a:	415c                	lw	a5,4(a0)
    80002c9c:	0047d79b          	srliw	a5,a5,0x4
    80002ca0:	00234597          	auipc	a1,0x234
    80002ca4:	1e05a583          	lw	a1,480(a1) # 80236e80 <sb+0x18>
    80002ca8:	9dbd                	addw	a1,a1,a5
    80002caa:	4108                	lw	a0,0(a0)
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	890080e7          	jalr	-1904(ra) # 8000253c <bread>
    80002cb4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cb6:	05850793          	addi	a5,a0,88
    80002cba:	40c8                	lw	a0,4(s1)
    80002cbc:	893d                	andi	a0,a0,15
    80002cbe:	051a                	slli	a0,a0,0x6
    80002cc0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cc2:	04449703          	lh	a4,68(s1)
    80002cc6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cca:	04649703          	lh	a4,70(s1)
    80002cce:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cd2:	04849703          	lh	a4,72(s1)
    80002cd6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cda:	04a49703          	lh	a4,74(s1)
    80002cde:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ce2:	44f8                	lw	a4,76(s1)
    80002ce4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ce6:	03400613          	li	a2,52
    80002cea:	05048593          	addi	a1,s1,80
    80002cee:	0531                	addi	a0,a0,12
    80002cf0:	ffffd097          	auipc	ra,0xffffd
    80002cf4:	5c0080e7          	jalr	1472(ra) # 800002b0 <memmove>
  log_write(bp);
    80002cf8:	854a                	mv	a0,s2
    80002cfa:	00001097          	auipc	ra,0x1
    80002cfe:	bf6080e7          	jalr	-1034(ra) # 800038f0 <log_write>
  brelse(bp);
    80002d02:	854a                	mv	a0,s2
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	968080e7          	jalr	-1688(ra) # 8000266c <brelse>
}
    80002d0c:	60e2                	ld	ra,24(sp)
    80002d0e:	6442                	ld	s0,16(sp)
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	6902                	ld	s2,0(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret

0000000080002d18 <idup>:
{
    80002d18:	1101                	addi	sp,sp,-32
    80002d1a:	ec06                	sd	ra,24(sp)
    80002d1c:	e822                	sd	s0,16(sp)
    80002d1e:	e426                	sd	s1,8(sp)
    80002d20:	1000                	addi	s0,sp,32
    80002d22:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d24:	00234517          	auipc	a0,0x234
    80002d28:	16450513          	addi	a0,a0,356 # 80236e88 <itable>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	670080e7          	jalr	1648(ra) # 8000639c <acquire>
  ip->ref++;
    80002d34:	449c                	lw	a5,8(s1)
    80002d36:	2785                	addiw	a5,a5,1
    80002d38:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d3a:	00234517          	auipc	a0,0x234
    80002d3e:	14e50513          	addi	a0,a0,334 # 80236e88 <itable>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	70e080e7          	jalr	1806(ra) # 80006450 <release>
}
    80002d4a:	8526                	mv	a0,s1
    80002d4c:	60e2                	ld	ra,24(sp)
    80002d4e:	6442                	ld	s0,16(sp)
    80002d50:	64a2                	ld	s1,8(sp)
    80002d52:	6105                	addi	sp,sp,32
    80002d54:	8082                	ret

0000000080002d56 <ilock>:
{
    80002d56:	1101                	addi	sp,sp,-32
    80002d58:	ec06                	sd	ra,24(sp)
    80002d5a:	e822                	sd	s0,16(sp)
    80002d5c:	e426                	sd	s1,8(sp)
    80002d5e:	e04a                	sd	s2,0(sp)
    80002d60:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d62:	c115                	beqz	a0,80002d86 <ilock+0x30>
    80002d64:	84aa                	mv	s1,a0
    80002d66:	451c                	lw	a5,8(a0)
    80002d68:	00f05f63          	blez	a5,80002d86 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d6c:	0541                	addi	a0,a0,16
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	ca2080e7          	jalr	-862(ra) # 80003a10 <acquiresleep>
  if(ip->valid == 0){
    80002d76:	40bc                	lw	a5,64(s1)
    80002d78:	cf99                	beqz	a5,80002d96 <ilock+0x40>
}
    80002d7a:	60e2                	ld	ra,24(sp)
    80002d7c:	6442                	ld	s0,16(sp)
    80002d7e:	64a2                	ld	s1,8(sp)
    80002d80:	6902                	ld	s2,0(sp)
    80002d82:	6105                	addi	sp,sp,32
    80002d84:	8082                	ret
    panic("ilock");
    80002d86:	00006517          	auipc	a0,0x6
    80002d8a:	82250513          	addi	a0,a0,-2014 # 800085a8 <syscalls+0x180>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	0c4080e7          	jalr	196(ra) # 80005e52 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d96:	40dc                	lw	a5,4(s1)
    80002d98:	0047d79b          	srliw	a5,a5,0x4
    80002d9c:	00234597          	auipc	a1,0x234
    80002da0:	0e45a583          	lw	a1,228(a1) # 80236e80 <sb+0x18>
    80002da4:	9dbd                	addw	a1,a1,a5
    80002da6:	4088                	lw	a0,0(s1)
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	794080e7          	jalr	1940(ra) # 8000253c <bread>
    80002db0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db2:	05850593          	addi	a1,a0,88
    80002db6:	40dc                	lw	a5,4(s1)
    80002db8:	8bbd                	andi	a5,a5,15
    80002dba:	079a                	slli	a5,a5,0x6
    80002dbc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dbe:	00059783          	lh	a5,0(a1)
    80002dc2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dc6:	00259783          	lh	a5,2(a1)
    80002dca:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002dce:	00459783          	lh	a5,4(a1)
    80002dd2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dd6:	00659783          	lh	a5,6(a1)
    80002dda:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002dde:	459c                	lw	a5,8(a1)
    80002de0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002de2:	03400613          	li	a2,52
    80002de6:	05b1                	addi	a1,a1,12
    80002de8:	05048513          	addi	a0,s1,80
    80002dec:	ffffd097          	auipc	ra,0xffffd
    80002df0:	4c4080e7          	jalr	1220(ra) # 800002b0 <memmove>
    brelse(bp);
    80002df4:	854a                	mv	a0,s2
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	876080e7          	jalr	-1930(ra) # 8000266c <brelse>
    ip->valid = 1;
    80002dfe:	4785                	li	a5,1
    80002e00:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e02:	04449783          	lh	a5,68(s1)
    80002e06:	fbb5                	bnez	a5,80002d7a <ilock+0x24>
      panic("ilock: no type");
    80002e08:	00005517          	auipc	a0,0x5
    80002e0c:	7a850513          	addi	a0,a0,1960 # 800085b0 <syscalls+0x188>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	042080e7          	jalr	66(ra) # 80005e52 <panic>

0000000080002e18 <iunlock>:
{
    80002e18:	1101                	addi	sp,sp,-32
    80002e1a:	ec06                	sd	ra,24(sp)
    80002e1c:	e822                	sd	s0,16(sp)
    80002e1e:	e426                	sd	s1,8(sp)
    80002e20:	e04a                	sd	s2,0(sp)
    80002e22:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e24:	c905                	beqz	a0,80002e54 <iunlock+0x3c>
    80002e26:	84aa                	mv	s1,a0
    80002e28:	01050913          	addi	s2,a0,16
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	00001097          	auipc	ra,0x1
    80002e32:	c7c080e7          	jalr	-900(ra) # 80003aaa <holdingsleep>
    80002e36:	cd19                	beqz	a0,80002e54 <iunlock+0x3c>
    80002e38:	449c                	lw	a5,8(s1)
    80002e3a:	00f05d63          	blez	a5,80002e54 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e3e:	854a                	mv	a0,s2
    80002e40:	00001097          	auipc	ra,0x1
    80002e44:	c26080e7          	jalr	-986(ra) # 80003a66 <releasesleep>
}
    80002e48:	60e2                	ld	ra,24(sp)
    80002e4a:	6442                	ld	s0,16(sp)
    80002e4c:	64a2                	ld	s1,8(sp)
    80002e4e:	6902                	ld	s2,0(sp)
    80002e50:	6105                	addi	sp,sp,32
    80002e52:	8082                	ret
    panic("iunlock");
    80002e54:	00005517          	auipc	a0,0x5
    80002e58:	76c50513          	addi	a0,a0,1900 # 800085c0 <syscalls+0x198>
    80002e5c:	00003097          	auipc	ra,0x3
    80002e60:	ff6080e7          	jalr	-10(ra) # 80005e52 <panic>

0000000080002e64 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e64:	7179                	addi	sp,sp,-48
    80002e66:	f406                	sd	ra,40(sp)
    80002e68:	f022                	sd	s0,32(sp)
    80002e6a:	ec26                	sd	s1,24(sp)
    80002e6c:	e84a                	sd	s2,16(sp)
    80002e6e:	e44e                	sd	s3,8(sp)
    80002e70:	e052                	sd	s4,0(sp)
    80002e72:	1800                	addi	s0,sp,48
    80002e74:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e76:	05050493          	addi	s1,a0,80
    80002e7a:	08050913          	addi	s2,a0,128
    80002e7e:	a021                	j	80002e86 <itrunc+0x22>
    80002e80:	0491                	addi	s1,s1,4
    80002e82:	01248d63          	beq	s1,s2,80002e9c <itrunc+0x38>
    if(ip->addrs[i]){
    80002e86:	408c                	lw	a1,0(s1)
    80002e88:	dde5                	beqz	a1,80002e80 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e8a:	0009a503          	lw	a0,0(s3)
    80002e8e:	00000097          	auipc	ra,0x0
    80002e92:	8f4080e7          	jalr	-1804(ra) # 80002782 <bfree>
      ip->addrs[i] = 0;
    80002e96:	0004a023          	sw	zero,0(s1)
    80002e9a:	b7dd                	j	80002e80 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e9c:	0809a583          	lw	a1,128(s3)
    80002ea0:	e185                	bnez	a1,80002ec0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ea2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ea6:	854e                	mv	a0,s3
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	de4080e7          	jalr	-540(ra) # 80002c8c <iupdate>
}
    80002eb0:	70a2                	ld	ra,40(sp)
    80002eb2:	7402                	ld	s0,32(sp)
    80002eb4:	64e2                	ld	s1,24(sp)
    80002eb6:	6942                	ld	s2,16(sp)
    80002eb8:	69a2                	ld	s3,8(sp)
    80002eba:	6a02                	ld	s4,0(sp)
    80002ebc:	6145                	addi	sp,sp,48
    80002ebe:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ec0:	0009a503          	lw	a0,0(s3)
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	678080e7          	jalr	1656(ra) # 8000253c <bread>
    80002ecc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ece:	05850493          	addi	s1,a0,88
    80002ed2:	45850913          	addi	s2,a0,1112
    80002ed6:	a811                	j	80002eea <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ed8:	0009a503          	lw	a0,0(s3)
    80002edc:	00000097          	auipc	ra,0x0
    80002ee0:	8a6080e7          	jalr	-1882(ra) # 80002782 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ee4:	0491                	addi	s1,s1,4
    80002ee6:	01248563          	beq	s1,s2,80002ef0 <itrunc+0x8c>
      if(a[j])
    80002eea:	408c                	lw	a1,0(s1)
    80002eec:	dde5                	beqz	a1,80002ee4 <itrunc+0x80>
    80002eee:	b7ed                	j	80002ed8 <itrunc+0x74>
    brelse(bp);
    80002ef0:	8552                	mv	a0,s4
    80002ef2:	fffff097          	auipc	ra,0xfffff
    80002ef6:	77a080e7          	jalr	1914(ra) # 8000266c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002efa:	0809a583          	lw	a1,128(s3)
    80002efe:	0009a503          	lw	a0,0(s3)
    80002f02:	00000097          	auipc	ra,0x0
    80002f06:	880080e7          	jalr	-1920(ra) # 80002782 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f0a:	0809a023          	sw	zero,128(s3)
    80002f0e:	bf51                	j	80002ea2 <itrunc+0x3e>

0000000080002f10 <iput>:
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	e04a                	sd	s2,0(sp)
    80002f1a:	1000                	addi	s0,sp,32
    80002f1c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f1e:	00234517          	auipc	a0,0x234
    80002f22:	f6a50513          	addi	a0,a0,-150 # 80236e88 <itable>
    80002f26:	00003097          	auipc	ra,0x3
    80002f2a:	476080e7          	jalr	1142(ra) # 8000639c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f2e:	4498                	lw	a4,8(s1)
    80002f30:	4785                	li	a5,1
    80002f32:	02f70363          	beq	a4,a5,80002f58 <iput+0x48>
  ip->ref--;
    80002f36:	449c                	lw	a5,8(s1)
    80002f38:	37fd                	addiw	a5,a5,-1
    80002f3a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f3c:	00234517          	auipc	a0,0x234
    80002f40:	f4c50513          	addi	a0,a0,-180 # 80236e88 <itable>
    80002f44:	00003097          	auipc	ra,0x3
    80002f48:	50c080e7          	jalr	1292(ra) # 80006450 <release>
}
    80002f4c:	60e2                	ld	ra,24(sp)
    80002f4e:	6442                	ld	s0,16(sp)
    80002f50:	64a2                	ld	s1,8(sp)
    80002f52:	6902                	ld	s2,0(sp)
    80002f54:	6105                	addi	sp,sp,32
    80002f56:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f58:	40bc                	lw	a5,64(s1)
    80002f5a:	dff1                	beqz	a5,80002f36 <iput+0x26>
    80002f5c:	04a49783          	lh	a5,74(s1)
    80002f60:	fbf9                	bnez	a5,80002f36 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f62:	01048913          	addi	s2,s1,16
    80002f66:	854a                	mv	a0,s2
    80002f68:	00001097          	auipc	ra,0x1
    80002f6c:	aa8080e7          	jalr	-1368(ra) # 80003a10 <acquiresleep>
    release(&itable.lock);
    80002f70:	00234517          	auipc	a0,0x234
    80002f74:	f1850513          	addi	a0,a0,-232 # 80236e88 <itable>
    80002f78:	00003097          	auipc	ra,0x3
    80002f7c:	4d8080e7          	jalr	1240(ra) # 80006450 <release>
    itrunc(ip);
    80002f80:	8526                	mv	a0,s1
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	ee2080e7          	jalr	-286(ra) # 80002e64 <itrunc>
    ip->type = 0;
    80002f8a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f8e:	8526                	mv	a0,s1
    80002f90:	00000097          	auipc	ra,0x0
    80002f94:	cfc080e7          	jalr	-772(ra) # 80002c8c <iupdate>
    ip->valid = 0;
    80002f98:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f9c:	854a                	mv	a0,s2
    80002f9e:	00001097          	auipc	ra,0x1
    80002fa2:	ac8080e7          	jalr	-1336(ra) # 80003a66 <releasesleep>
    acquire(&itable.lock);
    80002fa6:	00234517          	auipc	a0,0x234
    80002faa:	ee250513          	addi	a0,a0,-286 # 80236e88 <itable>
    80002fae:	00003097          	auipc	ra,0x3
    80002fb2:	3ee080e7          	jalr	1006(ra) # 8000639c <acquire>
    80002fb6:	b741                	j	80002f36 <iput+0x26>

0000000080002fb8 <iunlockput>:
{
    80002fb8:	1101                	addi	sp,sp,-32
    80002fba:	ec06                	sd	ra,24(sp)
    80002fbc:	e822                	sd	s0,16(sp)
    80002fbe:	e426                	sd	s1,8(sp)
    80002fc0:	1000                	addi	s0,sp,32
    80002fc2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fc4:	00000097          	auipc	ra,0x0
    80002fc8:	e54080e7          	jalr	-428(ra) # 80002e18 <iunlock>
  iput(ip);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	f42080e7          	jalr	-190(ra) # 80002f10 <iput>
}
    80002fd6:	60e2                	ld	ra,24(sp)
    80002fd8:	6442                	ld	s0,16(sp)
    80002fda:	64a2                	ld	s1,8(sp)
    80002fdc:	6105                	addi	sp,sp,32
    80002fde:	8082                	ret

0000000080002fe0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fe0:	1141                	addi	sp,sp,-16
    80002fe2:	e422                	sd	s0,8(sp)
    80002fe4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fe6:	411c                	lw	a5,0(a0)
    80002fe8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fea:	415c                	lw	a5,4(a0)
    80002fec:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fee:	04451783          	lh	a5,68(a0)
    80002ff2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ff6:	04a51783          	lh	a5,74(a0)
    80002ffa:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ffe:	04c56783          	lwu	a5,76(a0)
    80003002:	e99c                	sd	a5,16(a1)
}
    80003004:	6422                	ld	s0,8(sp)
    80003006:	0141                	addi	sp,sp,16
    80003008:	8082                	ret

000000008000300a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000300a:	457c                	lw	a5,76(a0)
    8000300c:	0ed7e963          	bltu	a5,a3,800030fe <readi+0xf4>
{
    80003010:	7159                	addi	sp,sp,-112
    80003012:	f486                	sd	ra,104(sp)
    80003014:	f0a2                	sd	s0,96(sp)
    80003016:	eca6                	sd	s1,88(sp)
    80003018:	e8ca                	sd	s2,80(sp)
    8000301a:	e4ce                	sd	s3,72(sp)
    8000301c:	e0d2                	sd	s4,64(sp)
    8000301e:	fc56                	sd	s5,56(sp)
    80003020:	f85a                	sd	s6,48(sp)
    80003022:	f45e                	sd	s7,40(sp)
    80003024:	f062                	sd	s8,32(sp)
    80003026:	ec66                	sd	s9,24(sp)
    80003028:	e86a                	sd	s10,16(sp)
    8000302a:	e46e                	sd	s11,8(sp)
    8000302c:	1880                	addi	s0,sp,112
    8000302e:	8b2a                	mv	s6,a0
    80003030:	8bae                	mv	s7,a1
    80003032:	8a32                	mv	s4,a2
    80003034:	84b6                	mv	s1,a3
    80003036:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003038:	9f35                	addw	a4,a4,a3
    return 0;
    8000303a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000303c:	0ad76063          	bltu	a4,a3,800030dc <readi+0xd2>
  if(off + n > ip->size)
    80003040:	00e7f463          	bgeu	a5,a4,80003048 <readi+0x3e>
    n = ip->size - off;
    80003044:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003048:	0a0a8963          	beqz	s5,800030fa <readi+0xf0>
    8000304c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000304e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003052:	5c7d                	li	s8,-1
    80003054:	a82d                	j	8000308e <readi+0x84>
    80003056:	020d1d93          	slli	s11,s10,0x20
    8000305a:	020ddd93          	srli	s11,s11,0x20
    8000305e:	05890613          	addi	a2,s2,88
    80003062:	86ee                	mv	a3,s11
    80003064:	963a                	add	a2,a2,a4
    80003066:	85d2                	mv	a1,s4
    80003068:	855e                	mv	a0,s7
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	a3c080e7          	jalr	-1476(ra) # 80001aa6 <either_copyout>
    80003072:	05850d63          	beq	a0,s8,800030cc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003076:	854a                	mv	a0,s2
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	5f4080e7          	jalr	1524(ra) # 8000266c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003080:	013d09bb          	addw	s3,s10,s3
    80003084:	009d04bb          	addw	s1,s10,s1
    80003088:	9a6e                	add	s4,s4,s11
    8000308a:	0559f763          	bgeu	s3,s5,800030d8 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    8000308e:	00a4d59b          	srliw	a1,s1,0xa
    80003092:	855a                	mv	a0,s6
    80003094:	00000097          	auipc	ra,0x0
    80003098:	8a2080e7          	jalr	-1886(ra) # 80002936 <bmap>
    8000309c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030a0:	cd85                	beqz	a1,800030d8 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030a2:	000b2503          	lw	a0,0(s6)
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	496080e7          	jalr	1174(ra) # 8000253c <bread>
    800030ae:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b0:	3ff4f713          	andi	a4,s1,1023
    800030b4:	40ec87bb          	subw	a5,s9,a4
    800030b8:	413a86bb          	subw	a3,s5,s3
    800030bc:	8d3e                	mv	s10,a5
    800030be:	2781                	sext.w	a5,a5
    800030c0:	0006861b          	sext.w	a2,a3
    800030c4:	f8f679e3          	bgeu	a2,a5,80003056 <readi+0x4c>
    800030c8:	8d36                	mv	s10,a3
    800030ca:	b771                	j	80003056 <readi+0x4c>
      brelse(bp);
    800030cc:	854a                	mv	a0,s2
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	59e080e7          	jalr	1438(ra) # 8000266c <brelse>
      tot = -1;
    800030d6:	59fd                	li	s3,-1
  }
  return tot;
    800030d8:	0009851b          	sext.w	a0,s3
}
    800030dc:	70a6                	ld	ra,104(sp)
    800030de:	7406                	ld	s0,96(sp)
    800030e0:	64e6                	ld	s1,88(sp)
    800030e2:	6946                	ld	s2,80(sp)
    800030e4:	69a6                	ld	s3,72(sp)
    800030e6:	6a06                	ld	s4,64(sp)
    800030e8:	7ae2                	ld	s5,56(sp)
    800030ea:	7b42                	ld	s6,48(sp)
    800030ec:	7ba2                	ld	s7,40(sp)
    800030ee:	7c02                	ld	s8,32(sp)
    800030f0:	6ce2                	ld	s9,24(sp)
    800030f2:	6d42                	ld	s10,16(sp)
    800030f4:	6da2                	ld	s11,8(sp)
    800030f6:	6165                	addi	sp,sp,112
    800030f8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030fa:	89d6                	mv	s3,s5
    800030fc:	bff1                	j	800030d8 <readi+0xce>
    return 0;
    800030fe:	4501                	li	a0,0
}
    80003100:	8082                	ret

0000000080003102 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003102:	457c                	lw	a5,76(a0)
    80003104:	10d7e863          	bltu	a5,a3,80003214 <writei+0x112>
{
    80003108:	7159                	addi	sp,sp,-112
    8000310a:	f486                	sd	ra,104(sp)
    8000310c:	f0a2                	sd	s0,96(sp)
    8000310e:	eca6                	sd	s1,88(sp)
    80003110:	e8ca                	sd	s2,80(sp)
    80003112:	e4ce                	sd	s3,72(sp)
    80003114:	e0d2                	sd	s4,64(sp)
    80003116:	fc56                	sd	s5,56(sp)
    80003118:	f85a                	sd	s6,48(sp)
    8000311a:	f45e                	sd	s7,40(sp)
    8000311c:	f062                	sd	s8,32(sp)
    8000311e:	ec66                	sd	s9,24(sp)
    80003120:	e86a                	sd	s10,16(sp)
    80003122:	e46e                	sd	s11,8(sp)
    80003124:	1880                	addi	s0,sp,112
    80003126:	8aaa                	mv	s5,a0
    80003128:	8bae                	mv	s7,a1
    8000312a:	8a32                	mv	s4,a2
    8000312c:	8936                	mv	s2,a3
    8000312e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003130:	00e687bb          	addw	a5,a3,a4
    80003134:	0ed7e263          	bltu	a5,a3,80003218 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003138:	00043737          	lui	a4,0x43
    8000313c:	0ef76063          	bltu	a4,a5,8000321c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003140:	0c0b0863          	beqz	s6,80003210 <writei+0x10e>
    80003144:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003146:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000314a:	5c7d                	li	s8,-1
    8000314c:	a091                	j	80003190 <writei+0x8e>
    8000314e:	020d1d93          	slli	s11,s10,0x20
    80003152:	020ddd93          	srli	s11,s11,0x20
    80003156:	05848513          	addi	a0,s1,88
    8000315a:	86ee                	mv	a3,s11
    8000315c:	8652                	mv	a2,s4
    8000315e:	85de                	mv	a1,s7
    80003160:	953a                	add	a0,a0,a4
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	99a080e7          	jalr	-1638(ra) # 80001afc <either_copyin>
    8000316a:	07850263          	beq	a0,s8,800031ce <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000316e:	8526                	mv	a0,s1
    80003170:	00000097          	auipc	ra,0x0
    80003174:	780080e7          	jalr	1920(ra) # 800038f0 <log_write>
    brelse(bp);
    80003178:	8526                	mv	a0,s1
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	4f2080e7          	jalr	1266(ra) # 8000266c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003182:	013d09bb          	addw	s3,s10,s3
    80003186:	012d093b          	addw	s2,s10,s2
    8000318a:	9a6e                	add	s4,s4,s11
    8000318c:	0569f663          	bgeu	s3,s6,800031d8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003190:	00a9559b          	srliw	a1,s2,0xa
    80003194:	8556                	mv	a0,s5
    80003196:	fffff097          	auipc	ra,0xfffff
    8000319a:	7a0080e7          	jalr	1952(ra) # 80002936 <bmap>
    8000319e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031a2:	c99d                	beqz	a1,800031d8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031a4:	000aa503          	lw	a0,0(s5)
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	394080e7          	jalr	916(ra) # 8000253c <bread>
    800031b0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b2:	3ff97713          	andi	a4,s2,1023
    800031b6:	40ec87bb          	subw	a5,s9,a4
    800031ba:	413b06bb          	subw	a3,s6,s3
    800031be:	8d3e                	mv	s10,a5
    800031c0:	2781                	sext.w	a5,a5
    800031c2:	0006861b          	sext.w	a2,a3
    800031c6:	f8f674e3          	bgeu	a2,a5,8000314e <writei+0x4c>
    800031ca:	8d36                	mv	s10,a3
    800031cc:	b749                	j	8000314e <writei+0x4c>
      brelse(bp);
    800031ce:	8526                	mv	a0,s1
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	49c080e7          	jalr	1180(ra) # 8000266c <brelse>
  }

  if(off > ip->size)
    800031d8:	04caa783          	lw	a5,76(s5)
    800031dc:	0127f463          	bgeu	a5,s2,800031e4 <writei+0xe2>
    ip->size = off;
    800031e0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031e4:	8556                	mv	a0,s5
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	aa6080e7          	jalr	-1370(ra) # 80002c8c <iupdate>

  return tot;
    800031ee:	0009851b          	sext.w	a0,s3
}
    800031f2:	70a6                	ld	ra,104(sp)
    800031f4:	7406                	ld	s0,96(sp)
    800031f6:	64e6                	ld	s1,88(sp)
    800031f8:	6946                	ld	s2,80(sp)
    800031fa:	69a6                	ld	s3,72(sp)
    800031fc:	6a06                	ld	s4,64(sp)
    800031fe:	7ae2                	ld	s5,56(sp)
    80003200:	7b42                	ld	s6,48(sp)
    80003202:	7ba2                	ld	s7,40(sp)
    80003204:	7c02                	ld	s8,32(sp)
    80003206:	6ce2                	ld	s9,24(sp)
    80003208:	6d42                	ld	s10,16(sp)
    8000320a:	6da2                	ld	s11,8(sp)
    8000320c:	6165                	addi	sp,sp,112
    8000320e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003210:	89da                	mv	s3,s6
    80003212:	bfc9                	j	800031e4 <writei+0xe2>
    return -1;
    80003214:	557d                	li	a0,-1
}
    80003216:	8082                	ret
    return -1;
    80003218:	557d                	li	a0,-1
    8000321a:	bfe1                	j	800031f2 <writei+0xf0>
    return -1;
    8000321c:	557d                	li	a0,-1
    8000321e:	bfd1                	j	800031f2 <writei+0xf0>

0000000080003220 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003220:	1141                	addi	sp,sp,-16
    80003222:	e406                	sd	ra,8(sp)
    80003224:	e022                	sd	s0,0(sp)
    80003226:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003228:	4639                	li	a2,14
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	0fe080e7          	jalr	254(ra) # 80000328 <strncmp>
}
    80003232:	60a2                	ld	ra,8(sp)
    80003234:	6402                	ld	s0,0(sp)
    80003236:	0141                	addi	sp,sp,16
    80003238:	8082                	ret

000000008000323a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000323a:	7139                	addi	sp,sp,-64
    8000323c:	fc06                	sd	ra,56(sp)
    8000323e:	f822                	sd	s0,48(sp)
    80003240:	f426                	sd	s1,40(sp)
    80003242:	f04a                	sd	s2,32(sp)
    80003244:	ec4e                	sd	s3,24(sp)
    80003246:	e852                	sd	s4,16(sp)
    80003248:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000324a:	04451703          	lh	a4,68(a0)
    8000324e:	4785                	li	a5,1
    80003250:	00f71a63          	bne	a4,a5,80003264 <dirlookup+0x2a>
    80003254:	892a                	mv	s2,a0
    80003256:	89ae                	mv	s3,a1
    80003258:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325a:	457c                	lw	a5,76(a0)
    8000325c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000325e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003260:	e79d                	bnez	a5,8000328e <dirlookup+0x54>
    80003262:	a8a5                	j	800032da <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003264:	00005517          	auipc	a0,0x5
    80003268:	36450513          	addi	a0,a0,868 # 800085c8 <syscalls+0x1a0>
    8000326c:	00003097          	auipc	ra,0x3
    80003270:	be6080e7          	jalr	-1050(ra) # 80005e52 <panic>
      panic("dirlookup read");
    80003274:	00005517          	auipc	a0,0x5
    80003278:	36c50513          	addi	a0,a0,876 # 800085e0 <syscalls+0x1b8>
    8000327c:	00003097          	auipc	ra,0x3
    80003280:	bd6080e7          	jalr	-1066(ra) # 80005e52 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003284:	24c1                	addiw	s1,s1,16
    80003286:	04c92783          	lw	a5,76(s2)
    8000328a:	04f4f763          	bgeu	s1,a5,800032d8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000328e:	4741                	li	a4,16
    80003290:	86a6                	mv	a3,s1
    80003292:	fc040613          	addi	a2,s0,-64
    80003296:	4581                	li	a1,0
    80003298:	854a                	mv	a0,s2
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	d70080e7          	jalr	-656(ra) # 8000300a <readi>
    800032a2:	47c1                	li	a5,16
    800032a4:	fcf518e3          	bne	a0,a5,80003274 <dirlookup+0x3a>
    if(de.inum == 0)
    800032a8:	fc045783          	lhu	a5,-64(s0)
    800032ac:	dfe1                	beqz	a5,80003284 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032ae:	fc240593          	addi	a1,s0,-62
    800032b2:	854e                	mv	a0,s3
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	f6c080e7          	jalr	-148(ra) # 80003220 <namecmp>
    800032bc:	f561                	bnez	a0,80003284 <dirlookup+0x4a>
      if(poff)
    800032be:	000a0463          	beqz	s4,800032c6 <dirlookup+0x8c>
        *poff = off;
    800032c2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032c6:	fc045583          	lhu	a1,-64(s0)
    800032ca:	00092503          	lw	a0,0(s2)
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	750080e7          	jalr	1872(ra) # 80002a1e <iget>
    800032d6:	a011                	j	800032da <dirlookup+0xa0>
  return 0;
    800032d8:	4501                	li	a0,0
}
    800032da:	70e2                	ld	ra,56(sp)
    800032dc:	7442                	ld	s0,48(sp)
    800032de:	74a2                	ld	s1,40(sp)
    800032e0:	7902                	ld	s2,32(sp)
    800032e2:	69e2                	ld	s3,24(sp)
    800032e4:	6a42                	ld	s4,16(sp)
    800032e6:	6121                	addi	sp,sp,64
    800032e8:	8082                	ret

00000000800032ea <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032ea:	711d                	addi	sp,sp,-96
    800032ec:	ec86                	sd	ra,88(sp)
    800032ee:	e8a2                	sd	s0,80(sp)
    800032f0:	e4a6                	sd	s1,72(sp)
    800032f2:	e0ca                	sd	s2,64(sp)
    800032f4:	fc4e                	sd	s3,56(sp)
    800032f6:	f852                	sd	s4,48(sp)
    800032f8:	f456                	sd	s5,40(sp)
    800032fa:	f05a                	sd	s6,32(sp)
    800032fc:	ec5e                	sd	s7,24(sp)
    800032fe:	e862                	sd	s8,16(sp)
    80003300:	e466                	sd	s9,8(sp)
    80003302:	1080                	addi	s0,sp,96
    80003304:	84aa                	mv	s1,a0
    80003306:	8b2e                	mv	s6,a1
    80003308:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000330a:	00054703          	lbu	a4,0(a0)
    8000330e:	02f00793          	li	a5,47
    80003312:	02f70363          	beq	a4,a5,80003338 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003316:	ffffe097          	auipc	ra,0xffffe
    8000331a:	ce0080e7          	jalr	-800(ra) # 80000ff6 <myproc>
    8000331e:	15053503          	ld	a0,336(a0)
    80003322:	00000097          	auipc	ra,0x0
    80003326:	9f6080e7          	jalr	-1546(ra) # 80002d18 <idup>
    8000332a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000332c:	02f00913          	li	s2,47
  len = path - s;
    80003330:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003332:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003334:	4c05                	li	s8,1
    80003336:	a865                	j	800033ee <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003338:	4585                	li	a1,1
    8000333a:	4505                	li	a0,1
    8000333c:	fffff097          	auipc	ra,0xfffff
    80003340:	6e2080e7          	jalr	1762(ra) # 80002a1e <iget>
    80003344:	89aa                	mv	s3,a0
    80003346:	b7dd                	j	8000332c <namex+0x42>
      iunlockput(ip);
    80003348:	854e                	mv	a0,s3
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	c6e080e7          	jalr	-914(ra) # 80002fb8 <iunlockput>
      return 0;
    80003352:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003354:	854e                	mv	a0,s3
    80003356:	60e6                	ld	ra,88(sp)
    80003358:	6446                	ld	s0,80(sp)
    8000335a:	64a6                	ld	s1,72(sp)
    8000335c:	6906                	ld	s2,64(sp)
    8000335e:	79e2                	ld	s3,56(sp)
    80003360:	7a42                	ld	s4,48(sp)
    80003362:	7aa2                	ld	s5,40(sp)
    80003364:	7b02                	ld	s6,32(sp)
    80003366:	6be2                	ld	s7,24(sp)
    80003368:	6c42                	ld	s8,16(sp)
    8000336a:	6ca2                	ld	s9,8(sp)
    8000336c:	6125                	addi	sp,sp,96
    8000336e:	8082                	ret
      iunlock(ip);
    80003370:	854e                	mv	a0,s3
    80003372:	00000097          	auipc	ra,0x0
    80003376:	aa6080e7          	jalr	-1370(ra) # 80002e18 <iunlock>
      return ip;
    8000337a:	bfe9                	j	80003354 <namex+0x6a>
      iunlockput(ip);
    8000337c:	854e                	mv	a0,s3
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	c3a080e7          	jalr	-966(ra) # 80002fb8 <iunlockput>
      return 0;
    80003386:	89d2                	mv	s3,s4
    80003388:	b7f1                	j	80003354 <namex+0x6a>
  len = path - s;
    8000338a:	40b48633          	sub	a2,s1,a1
    8000338e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003392:	094cd463          	bge	s9,s4,8000341a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003396:	4639                	li	a2,14
    80003398:	8556                	mv	a0,s5
    8000339a:	ffffd097          	auipc	ra,0xffffd
    8000339e:	f16080e7          	jalr	-234(ra) # 800002b0 <memmove>
  while(*path == '/')
    800033a2:	0004c783          	lbu	a5,0(s1)
    800033a6:	01279763          	bne	a5,s2,800033b4 <namex+0xca>
    path++;
    800033aa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	ff278de3          	beq	a5,s2,800033aa <namex+0xc0>
    ilock(ip);
    800033b4:	854e                	mv	a0,s3
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	9a0080e7          	jalr	-1632(ra) # 80002d56 <ilock>
    if(ip->type != T_DIR){
    800033be:	04499783          	lh	a5,68(s3)
    800033c2:	f98793e3          	bne	a5,s8,80003348 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033c6:	000b0563          	beqz	s6,800033d0 <namex+0xe6>
    800033ca:	0004c783          	lbu	a5,0(s1)
    800033ce:	d3cd                	beqz	a5,80003370 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033d0:	865e                	mv	a2,s7
    800033d2:	85d6                	mv	a1,s5
    800033d4:	854e                	mv	a0,s3
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	e64080e7          	jalr	-412(ra) # 8000323a <dirlookup>
    800033de:	8a2a                	mv	s4,a0
    800033e0:	dd51                	beqz	a0,8000337c <namex+0x92>
    iunlockput(ip);
    800033e2:	854e                	mv	a0,s3
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	bd4080e7          	jalr	-1068(ra) # 80002fb8 <iunlockput>
    ip = next;
    800033ec:	89d2                	mv	s3,s4
  while(*path == '/')
    800033ee:	0004c783          	lbu	a5,0(s1)
    800033f2:	05279763          	bne	a5,s2,80003440 <namex+0x156>
    path++;
    800033f6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033f8:	0004c783          	lbu	a5,0(s1)
    800033fc:	ff278de3          	beq	a5,s2,800033f6 <namex+0x10c>
  if(*path == 0)
    80003400:	c79d                	beqz	a5,8000342e <namex+0x144>
    path++;
    80003402:	85a6                	mv	a1,s1
  len = path - s;
    80003404:	8a5e                	mv	s4,s7
    80003406:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003408:	01278963          	beq	a5,s2,8000341a <namex+0x130>
    8000340c:	dfbd                	beqz	a5,8000338a <namex+0xa0>
    path++;
    8000340e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003410:	0004c783          	lbu	a5,0(s1)
    80003414:	ff279ce3          	bne	a5,s2,8000340c <namex+0x122>
    80003418:	bf8d                	j	8000338a <namex+0xa0>
    memmove(name, s, len);
    8000341a:	2601                	sext.w	a2,a2
    8000341c:	8556                	mv	a0,s5
    8000341e:	ffffd097          	auipc	ra,0xffffd
    80003422:	e92080e7          	jalr	-366(ra) # 800002b0 <memmove>
    name[len] = 0;
    80003426:	9a56                	add	s4,s4,s5
    80003428:	000a0023          	sb	zero,0(s4)
    8000342c:	bf9d                	j	800033a2 <namex+0xb8>
  if(nameiparent){
    8000342e:	f20b03e3          	beqz	s6,80003354 <namex+0x6a>
    iput(ip);
    80003432:	854e                	mv	a0,s3
    80003434:	00000097          	auipc	ra,0x0
    80003438:	adc080e7          	jalr	-1316(ra) # 80002f10 <iput>
    return 0;
    8000343c:	4981                	li	s3,0
    8000343e:	bf19                	j	80003354 <namex+0x6a>
  if(*path == 0)
    80003440:	d7fd                	beqz	a5,8000342e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003442:	0004c783          	lbu	a5,0(s1)
    80003446:	85a6                	mv	a1,s1
    80003448:	b7d1                	j	8000340c <namex+0x122>

000000008000344a <dirlink>:
{
    8000344a:	7139                	addi	sp,sp,-64
    8000344c:	fc06                	sd	ra,56(sp)
    8000344e:	f822                	sd	s0,48(sp)
    80003450:	f426                	sd	s1,40(sp)
    80003452:	f04a                	sd	s2,32(sp)
    80003454:	ec4e                	sd	s3,24(sp)
    80003456:	e852                	sd	s4,16(sp)
    80003458:	0080                	addi	s0,sp,64
    8000345a:	892a                	mv	s2,a0
    8000345c:	8a2e                	mv	s4,a1
    8000345e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003460:	4601                	li	a2,0
    80003462:	00000097          	auipc	ra,0x0
    80003466:	dd8080e7          	jalr	-552(ra) # 8000323a <dirlookup>
    8000346a:	e93d                	bnez	a0,800034e0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000346c:	04c92483          	lw	s1,76(s2)
    80003470:	c49d                	beqz	s1,8000349e <dirlink+0x54>
    80003472:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003474:	4741                	li	a4,16
    80003476:	86a6                	mv	a3,s1
    80003478:	fc040613          	addi	a2,s0,-64
    8000347c:	4581                	li	a1,0
    8000347e:	854a                	mv	a0,s2
    80003480:	00000097          	auipc	ra,0x0
    80003484:	b8a080e7          	jalr	-1142(ra) # 8000300a <readi>
    80003488:	47c1                	li	a5,16
    8000348a:	06f51163          	bne	a0,a5,800034ec <dirlink+0xa2>
    if(de.inum == 0)
    8000348e:	fc045783          	lhu	a5,-64(s0)
    80003492:	c791                	beqz	a5,8000349e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003494:	24c1                	addiw	s1,s1,16
    80003496:	04c92783          	lw	a5,76(s2)
    8000349a:	fcf4ede3          	bltu	s1,a5,80003474 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000349e:	4639                	li	a2,14
    800034a0:	85d2                	mv	a1,s4
    800034a2:	fc240513          	addi	a0,s0,-62
    800034a6:	ffffd097          	auipc	ra,0xffffd
    800034aa:	ebe080e7          	jalr	-322(ra) # 80000364 <strncpy>
  de.inum = inum;
    800034ae:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b2:	4741                	li	a4,16
    800034b4:	86a6                	mv	a3,s1
    800034b6:	fc040613          	addi	a2,s0,-64
    800034ba:	4581                	li	a1,0
    800034bc:	854a                	mv	a0,s2
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	c44080e7          	jalr	-956(ra) # 80003102 <writei>
    800034c6:	1541                	addi	a0,a0,-16
    800034c8:	00a03533          	snez	a0,a0
    800034cc:	40a00533          	neg	a0,a0
}
    800034d0:	70e2                	ld	ra,56(sp)
    800034d2:	7442                	ld	s0,48(sp)
    800034d4:	74a2                	ld	s1,40(sp)
    800034d6:	7902                	ld	s2,32(sp)
    800034d8:	69e2                	ld	s3,24(sp)
    800034da:	6a42                	ld	s4,16(sp)
    800034dc:	6121                	addi	sp,sp,64
    800034de:	8082                	ret
    iput(ip);
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	a30080e7          	jalr	-1488(ra) # 80002f10 <iput>
    return -1;
    800034e8:	557d                	li	a0,-1
    800034ea:	b7dd                	j	800034d0 <dirlink+0x86>
      panic("dirlink read");
    800034ec:	00005517          	auipc	a0,0x5
    800034f0:	10450513          	addi	a0,a0,260 # 800085f0 <syscalls+0x1c8>
    800034f4:	00003097          	auipc	ra,0x3
    800034f8:	95e080e7          	jalr	-1698(ra) # 80005e52 <panic>

00000000800034fc <namei>:

struct inode*
namei(char *path)
{
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003504:	fe040613          	addi	a2,s0,-32
    80003508:	4581                	li	a1,0
    8000350a:	00000097          	auipc	ra,0x0
    8000350e:	de0080e7          	jalr	-544(ra) # 800032ea <namex>
}
    80003512:	60e2                	ld	ra,24(sp)
    80003514:	6442                	ld	s0,16(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret

000000008000351a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000351a:	1141                	addi	sp,sp,-16
    8000351c:	e406                	sd	ra,8(sp)
    8000351e:	e022                	sd	s0,0(sp)
    80003520:	0800                	addi	s0,sp,16
    80003522:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003524:	4585                	li	a1,1
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	dc4080e7          	jalr	-572(ra) # 800032ea <namex>
}
    8000352e:	60a2                	ld	ra,8(sp)
    80003530:	6402                	ld	s0,0(sp)
    80003532:	0141                	addi	sp,sp,16
    80003534:	8082                	ret

0000000080003536 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003536:	1101                	addi	sp,sp,-32
    80003538:	ec06                	sd	ra,24(sp)
    8000353a:	e822                	sd	s0,16(sp)
    8000353c:	e426                	sd	s1,8(sp)
    8000353e:	e04a                	sd	s2,0(sp)
    80003540:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003542:	00235917          	auipc	s2,0x235
    80003546:	3ee90913          	addi	s2,s2,1006 # 80238930 <log>
    8000354a:	01892583          	lw	a1,24(s2)
    8000354e:	02892503          	lw	a0,40(s2)
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	fea080e7          	jalr	-22(ra) # 8000253c <bread>
    8000355a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000355c:	02c92683          	lw	a3,44(s2)
    80003560:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003562:	02d05763          	blez	a3,80003590 <write_head+0x5a>
    80003566:	00235797          	auipc	a5,0x235
    8000356a:	3fa78793          	addi	a5,a5,1018 # 80238960 <log+0x30>
    8000356e:	05c50713          	addi	a4,a0,92
    80003572:	36fd                	addiw	a3,a3,-1
    80003574:	1682                	slli	a3,a3,0x20
    80003576:	9281                	srli	a3,a3,0x20
    80003578:	068a                	slli	a3,a3,0x2
    8000357a:	00235617          	auipc	a2,0x235
    8000357e:	3ea60613          	addi	a2,a2,1002 # 80238964 <log+0x34>
    80003582:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003584:	4390                	lw	a2,0(a5)
    80003586:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003588:	0791                	addi	a5,a5,4
    8000358a:	0711                	addi	a4,a4,4
    8000358c:	fed79ce3          	bne	a5,a3,80003584 <write_head+0x4e>
  }
  bwrite(buf);
    80003590:	8526                	mv	a0,s1
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	09c080e7          	jalr	156(ra) # 8000262e <bwrite>
  brelse(buf);
    8000359a:	8526                	mv	a0,s1
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	0d0080e7          	jalr	208(ra) # 8000266c <brelse>
}
    800035a4:	60e2                	ld	ra,24(sp)
    800035a6:	6442                	ld	s0,16(sp)
    800035a8:	64a2                	ld	s1,8(sp)
    800035aa:	6902                	ld	s2,0(sp)
    800035ac:	6105                	addi	sp,sp,32
    800035ae:	8082                	ret

00000000800035b0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b0:	00235797          	auipc	a5,0x235
    800035b4:	3ac7a783          	lw	a5,940(a5) # 8023895c <log+0x2c>
    800035b8:	0af05d63          	blez	a5,80003672 <install_trans+0xc2>
{
    800035bc:	7139                	addi	sp,sp,-64
    800035be:	fc06                	sd	ra,56(sp)
    800035c0:	f822                	sd	s0,48(sp)
    800035c2:	f426                	sd	s1,40(sp)
    800035c4:	f04a                	sd	s2,32(sp)
    800035c6:	ec4e                	sd	s3,24(sp)
    800035c8:	e852                	sd	s4,16(sp)
    800035ca:	e456                	sd	s5,8(sp)
    800035cc:	e05a                	sd	s6,0(sp)
    800035ce:	0080                	addi	s0,sp,64
    800035d0:	8b2a                	mv	s6,a0
    800035d2:	00235a97          	auipc	s5,0x235
    800035d6:	38ea8a93          	addi	s5,s5,910 # 80238960 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035da:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035dc:	00235997          	auipc	s3,0x235
    800035e0:	35498993          	addi	s3,s3,852 # 80238930 <log>
    800035e4:	a035                	j	80003610 <install_trans+0x60>
      bunpin(dbuf);
    800035e6:	8526                	mv	a0,s1
    800035e8:	fffff097          	auipc	ra,0xfffff
    800035ec:	15e080e7          	jalr	350(ra) # 80002746 <bunpin>
    brelse(lbuf);
    800035f0:	854a                	mv	a0,s2
    800035f2:	fffff097          	auipc	ra,0xfffff
    800035f6:	07a080e7          	jalr	122(ra) # 8000266c <brelse>
    brelse(dbuf);
    800035fa:	8526                	mv	a0,s1
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	070080e7          	jalr	112(ra) # 8000266c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003604:	2a05                	addiw	s4,s4,1
    80003606:	0a91                	addi	s5,s5,4
    80003608:	02c9a783          	lw	a5,44(s3)
    8000360c:	04fa5963          	bge	s4,a5,8000365e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003610:	0189a583          	lw	a1,24(s3)
    80003614:	014585bb          	addw	a1,a1,s4
    80003618:	2585                	addiw	a1,a1,1
    8000361a:	0289a503          	lw	a0,40(s3)
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	f1e080e7          	jalr	-226(ra) # 8000253c <bread>
    80003626:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003628:	000aa583          	lw	a1,0(s5)
    8000362c:	0289a503          	lw	a0,40(s3)
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	f0c080e7          	jalr	-244(ra) # 8000253c <bread>
    80003638:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000363a:	40000613          	li	a2,1024
    8000363e:	05890593          	addi	a1,s2,88
    80003642:	05850513          	addi	a0,a0,88
    80003646:	ffffd097          	auipc	ra,0xffffd
    8000364a:	c6a080e7          	jalr	-918(ra) # 800002b0 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000364e:	8526                	mv	a0,s1
    80003650:	fffff097          	auipc	ra,0xfffff
    80003654:	fde080e7          	jalr	-34(ra) # 8000262e <bwrite>
    if(recovering == 0)
    80003658:	f80b1ce3          	bnez	s6,800035f0 <install_trans+0x40>
    8000365c:	b769                	j	800035e6 <install_trans+0x36>
}
    8000365e:	70e2                	ld	ra,56(sp)
    80003660:	7442                	ld	s0,48(sp)
    80003662:	74a2                	ld	s1,40(sp)
    80003664:	7902                	ld	s2,32(sp)
    80003666:	69e2                	ld	s3,24(sp)
    80003668:	6a42                	ld	s4,16(sp)
    8000366a:	6aa2                	ld	s5,8(sp)
    8000366c:	6b02                	ld	s6,0(sp)
    8000366e:	6121                	addi	sp,sp,64
    80003670:	8082                	ret
    80003672:	8082                	ret

0000000080003674 <initlog>:
{
    80003674:	7179                	addi	sp,sp,-48
    80003676:	f406                	sd	ra,40(sp)
    80003678:	f022                	sd	s0,32(sp)
    8000367a:	ec26                	sd	s1,24(sp)
    8000367c:	e84a                	sd	s2,16(sp)
    8000367e:	e44e                	sd	s3,8(sp)
    80003680:	1800                	addi	s0,sp,48
    80003682:	892a                	mv	s2,a0
    80003684:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003686:	00235497          	auipc	s1,0x235
    8000368a:	2aa48493          	addi	s1,s1,682 # 80238930 <log>
    8000368e:	00005597          	auipc	a1,0x5
    80003692:	f7258593          	addi	a1,a1,-142 # 80008600 <syscalls+0x1d8>
    80003696:	8526                	mv	a0,s1
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	c74080e7          	jalr	-908(ra) # 8000630c <initlock>
  log.start = sb->logstart;
    800036a0:	0149a583          	lw	a1,20(s3)
    800036a4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036a6:	0109a783          	lw	a5,16(s3)
    800036aa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036ac:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036b0:	854a                	mv	a0,s2
    800036b2:	fffff097          	auipc	ra,0xfffff
    800036b6:	e8a080e7          	jalr	-374(ra) # 8000253c <bread>
  log.lh.n = lh->n;
    800036ba:	4d3c                	lw	a5,88(a0)
    800036bc:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036be:	02f05563          	blez	a5,800036e8 <initlog+0x74>
    800036c2:	05c50713          	addi	a4,a0,92
    800036c6:	00235697          	auipc	a3,0x235
    800036ca:	29a68693          	addi	a3,a3,666 # 80238960 <log+0x30>
    800036ce:	37fd                	addiw	a5,a5,-1
    800036d0:	1782                	slli	a5,a5,0x20
    800036d2:	9381                	srli	a5,a5,0x20
    800036d4:	078a                	slli	a5,a5,0x2
    800036d6:	06050613          	addi	a2,a0,96
    800036da:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036dc:	4310                	lw	a2,0(a4)
    800036de:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036e0:	0711                	addi	a4,a4,4
    800036e2:	0691                	addi	a3,a3,4
    800036e4:	fef71ce3          	bne	a4,a5,800036dc <initlog+0x68>
  brelse(buf);
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	f84080e7          	jalr	-124(ra) # 8000266c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036f0:	4505                	li	a0,1
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	ebe080e7          	jalr	-322(ra) # 800035b0 <install_trans>
  log.lh.n = 0;
    800036fa:	00235797          	auipc	a5,0x235
    800036fe:	2607a123          	sw	zero,610(a5) # 8023895c <log+0x2c>
  write_head(); // clear the log
    80003702:	00000097          	auipc	ra,0x0
    80003706:	e34080e7          	jalr	-460(ra) # 80003536 <write_head>
}
    8000370a:	70a2                	ld	ra,40(sp)
    8000370c:	7402                	ld	s0,32(sp)
    8000370e:	64e2                	ld	s1,24(sp)
    80003710:	6942                	ld	s2,16(sp)
    80003712:	69a2                	ld	s3,8(sp)
    80003714:	6145                	addi	sp,sp,48
    80003716:	8082                	ret

0000000080003718 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003718:	1101                	addi	sp,sp,-32
    8000371a:	ec06                	sd	ra,24(sp)
    8000371c:	e822                	sd	s0,16(sp)
    8000371e:	e426                	sd	s1,8(sp)
    80003720:	e04a                	sd	s2,0(sp)
    80003722:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003724:	00235517          	auipc	a0,0x235
    80003728:	20c50513          	addi	a0,a0,524 # 80238930 <log>
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	c70080e7          	jalr	-912(ra) # 8000639c <acquire>
  while(1){
    if(log.committing){
    80003734:	00235497          	auipc	s1,0x235
    80003738:	1fc48493          	addi	s1,s1,508 # 80238930 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000373c:	4979                	li	s2,30
    8000373e:	a039                	j	8000374c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003740:	85a6                	mv	a1,s1
    80003742:	8526                	mv	a0,s1
    80003744:	ffffe097          	auipc	ra,0xffffe
    80003748:	f5a080e7          	jalr	-166(ra) # 8000169e <sleep>
    if(log.committing){
    8000374c:	50dc                	lw	a5,36(s1)
    8000374e:	fbed                	bnez	a5,80003740 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003750:	509c                	lw	a5,32(s1)
    80003752:	0017871b          	addiw	a4,a5,1
    80003756:	0007069b          	sext.w	a3,a4
    8000375a:	0027179b          	slliw	a5,a4,0x2
    8000375e:	9fb9                	addw	a5,a5,a4
    80003760:	0017979b          	slliw	a5,a5,0x1
    80003764:	54d8                	lw	a4,44(s1)
    80003766:	9fb9                	addw	a5,a5,a4
    80003768:	00f95963          	bge	s2,a5,8000377a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000376c:	85a6                	mv	a1,s1
    8000376e:	8526                	mv	a0,s1
    80003770:	ffffe097          	auipc	ra,0xffffe
    80003774:	f2e080e7          	jalr	-210(ra) # 8000169e <sleep>
    80003778:	bfd1                	j	8000374c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000377a:	00235517          	auipc	a0,0x235
    8000377e:	1b650513          	addi	a0,a0,438 # 80238930 <log>
    80003782:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003784:	00003097          	auipc	ra,0x3
    80003788:	ccc080e7          	jalr	-820(ra) # 80006450 <release>
      break;
    }
  }
}
    8000378c:	60e2                	ld	ra,24(sp)
    8000378e:	6442                	ld	s0,16(sp)
    80003790:	64a2                	ld	s1,8(sp)
    80003792:	6902                	ld	s2,0(sp)
    80003794:	6105                	addi	sp,sp,32
    80003796:	8082                	ret

0000000080003798 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003798:	7139                	addi	sp,sp,-64
    8000379a:	fc06                	sd	ra,56(sp)
    8000379c:	f822                	sd	s0,48(sp)
    8000379e:	f426                	sd	s1,40(sp)
    800037a0:	f04a                	sd	s2,32(sp)
    800037a2:	ec4e                	sd	s3,24(sp)
    800037a4:	e852                	sd	s4,16(sp)
    800037a6:	e456                	sd	s5,8(sp)
    800037a8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037aa:	00235497          	auipc	s1,0x235
    800037ae:	18648493          	addi	s1,s1,390 # 80238930 <log>
    800037b2:	8526                	mv	a0,s1
    800037b4:	00003097          	auipc	ra,0x3
    800037b8:	be8080e7          	jalr	-1048(ra) # 8000639c <acquire>
  log.outstanding -= 1;
    800037bc:	509c                	lw	a5,32(s1)
    800037be:	37fd                	addiw	a5,a5,-1
    800037c0:	0007891b          	sext.w	s2,a5
    800037c4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037c6:	50dc                	lw	a5,36(s1)
    800037c8:	efb9                	bnez	a5,80003826 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ca:	06091663          	bnez	s2,80003836 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037ce:	00235497          	auipc	s1,0x235
    800037d2:	16248493          	addi	s1,s1,354 # 80238930 <log>
    800037d6:	4785                	li	a5,1
    800037d8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037da:	8526                	mv	a0,s1
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	c74080e7          	jalr	-908(ra) # 80006450 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037e4:	54dc                	lw	a5,44(s1)
    800037e6:	06f04763          	bgtz	a5,80003854 <end_op+0xbc>
    acquire(&log.lock);
    800037ea:	00235497          	auipc	s1,0x235
    800037ee:	14648493          	addi	s1,s1,326 # 80238930 <log>
    800037f2:	8526                	mv	a0,s1
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	ba8080e7          	jalr	-1112(ra) # 8000639c <acquire>
    log.committing = 0;
    800037fc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003800:	8526                	mv	a0,s1
    80003802:	ffffe097          	auipc	ra,0xffffe
    80003806:	f00080e7          	jalr	-256(ra) # 80001702 <wakeup>
    release(&log.lock);
    8000380a:	8526                	mv	a0,s1
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	c44080e7          	jalr	-956(ra) # 80006450 <release>
}
    80003814:	70e2                	ld	ra,56(sp)
    80003816:	7442                	ld	s0,48(sp)
    80003818:	74a2                	ld	s1,40(sp)
    8000381a:	7902                	ld	s2,32(sp)
    8000381c:	69e2                	ld	s3,24(sp)
    8000381e:	6a42                	ld	s4,16(sp)
    80003820:	6aa2                	ld	s5,8(sp)
    80003822:	6121                	addi	sp,sp,64
    80003824:	8082                	ret
    panic("log.committing");
    80003826:	00005517          	auipc	a0,0x5
    8000382a:	de250513          	addi	a0,a0,-542 # 80008608 <syscalls+0x1e0>
    8000382e:	00002097          	auipc	ra,0x2
    80003832:	624080e7          	jalr	1572(ra) # 80005e52 <panic>
    wakeup(&log);
    80003836:	00235497          	auipc	s1,0x235
    8000383a:	0fa48493          	addi	s1,s1,250 # 80238930 <log>
    8000383e:	8526                	mv	a0,s1
    80003840:	ffffe097          	auipc	ra,0xffffe
    80003844:	ec2080e7          	jalr	-318(ra) # 80001702 <wakeup>
  release(&log.lock);
    80003848:	8526                	mv	a0,s1
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	c06080e7          	jalr	-1018(ra) # 80006450 <release>
  if(do_commit){
    80003852:	b7c9                	j	80003814 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003854:	00235a97          	auipc	s5,0x235
    80003858:	10ca8a93          	addi	s5,s5,268 # 80238960 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000385c:	00235a17          	auipc	s4,0x235
    80003860:	0d4a0a13          	addi	s4,s4,212 # 80238930 <log>
    80003864:	018a2583          	lw	a1,24(s4)
    80003868:	012585bb          	addw	a1,a1,s2
    8000386c:	2585                	addiw	a1,a1,1
    8000386e:	028a2503          	lw	a0,40(s4)
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	cca080e7          	jalr	-822(ra) # 8000253c <bread>
    8000387a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000387c:	000aa583          	lw	a1,0(s5)
    80003880:	028a2503          	lw	a0,40(s4)
    80003884:	fffff097          	auipc	ra,0xfffff
    80003888:	cb8080e7          	jalr	-840(ra) # 8000253c <bread>
    8000388c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000388e:	40000613          	li	a2,1024
    80003892:	05850593          	addi	a1,a0,88
    80003896:	05848513          	addi	a0,s1,88
    8000389a:	ffffd097          	auipc	ra,0xffffd
    8000389e:	a16080e7          	jalr	-1514(ra) # 800002b0 <memmove>
    bwrite(to);  // write the log
    800038a2:	8526                	mv	a0,s1
    800038a4:	fffff097          	auipc	ra,0xfffff
    800038a8:	d8a080e7          	jalr	-630(ra) # 8000262e <bwrite>
    brelse(from);
    800038ac:	854e                	mv	a0,s3
    800038ae:	fffff097          	auipc	ra,0xfffff
    800038b2:	dbe080e7          	jalr	-578(ra) # 8000266c <brelse>
    brelse(to);
    800038b6:	8526                	mv	a0,s1
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	db4080e7          	jalr	-588(ra) # 8000266c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038c0:	2905                	addiw	s2,s2,1
    800038c2:	0a91                	addi	s5,s5,4
    800038c4:	02ca2783          	lw	a5,44(s4)
    800038c8:	f8f94ee3          	blt	s2,a5,80003864 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038cc:	00000097          	auipc	ra,0x0
    800038d0:	c6a080e7          	jalr	-918(ra) # 80003536 <write_head>
    install_trans(0); // Now install writes to home locations
    800038d4:	4501                	li	a0,0
    800038d6:	00000097          	auipc	ra,0x0
    800038da:	cda080e7          	jalr	-806(ra) # 800035b0 <install_trans>
    log.lh.n = 0;
    800038de:	00235797          	auipc	a5,0x235
    800038e2:	0607af23          	sw	zero,126(a5) # 8023895c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	c50080e7          	jalr	-944(ra) # 80003536 <write_head>
    800038ee:	bdf5                	j	800037ea <end_op+0x52>

00000000800038f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec06                	sd	ra,24(sp)
    800038f4:	e822                	sd	s0,16(sp)
    800038f6:	e426                	sd	s1,8(sp)
    800038f8:	e04a                	sd	s2,0(sp)
    800038fa:	1000                	addi	s0,sp,32
    800038fc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038fe:	00235917          	auipc	s2,0x235
    80003902:	03290913          	addi	s2,s2,50 # 80238930 <log>
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	a94080e7          	jalr	-1388(ra) # 8000639c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003910:	02c92603          	lw	a2,44(s2)
    80003914:	47f5                	li	a5,29
    80003916:	06c7c563          	blt	a5,a2,80003980 <log_write+0x90>
    8000391a:	00235797          	auipc	a5,0x235
    8000391e:	0327a783          	lw	a5,50(a5) # 8023894c <log+0x1c>
    80003922:	37fd                	addiw	a5,a5,-1
    80003924:	04f65e63          	bge	a2,a5,80003980 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003928:	00235797          	auipc	a5,0x235
    8000392c:	0287a783          	lw	a5,40(a5) # 80238950 <log+0x20>
    80003930:	06f05063          	blez	a5,80003990 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003934:	4781                	li	a5,0
    80003936:	06c05563          	blez	a2,800039a0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000393a:	44cc                	lw	a1,12(s1)
    8000393c:	00235717          	auipc	a4,0x235
    80003940:	02470713          	addi	a4,a4,36 # 80238960 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003944:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003946:	4314                	lw	a3,0(a4)
    80003948:	04b68c63          	beq	a3,a1,800039a0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000394c:	2785                	addiw	a5,a5,1
    8000394e:	0711                	addi	a4,a4,4
    80003950:	fef61be3          	bne	a2,a5,80003946 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003954:	0621                	addi	a2,a2,8
    80003956:	060a                	slli	a2,a2,0x2
    80003958:	00235797          	auipc	a5,0x235
    8000395c:	fd878793          	addi	a5,a5,-40 # 80238930 <log>
    80003960:	963e                	add	a2,a2,a5
    80003962:	44dc                	lw	a5,12(s1)
    80003964:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003966:	8526                	mv	a0,s1
    80003968:	fffff097          	auipc	ra,0xfffff
    8000396c:	da2080e7          	jalr	-606(ra) # 8000270a <bpin>
    log.lh.n++;
    80003970:	00235717          	auipc	a4,0x235
    80003974:	fc070713          	addi	a4,a4,-64 # 80238930 <log>
    80003978:	575c                	lw	a5,44(a4)
    8000397a:	2785                	addiw	a5,a5,1
    8000397c:	d75c                	sw	a5,44(a4)
    8000397e:	a835                	j	800039ba <log_write+0xca>
    panic("too big a transaction");
    80003980:	00005517          	auipc	a0,0x5
    80003984:	c9850513          	addi	a0,a0,-872 # 80008618 <syscalls+0x1f0>
    80003988:	00002097          	auipc	ra,0x2
    8000398c:	4ca080e7          	jalr	1226(ra) # 80005e52 <panic>
    panic("log_write outside of trans");
    80003990:	00005517          	auipc	a0,0x5
    80003994:	ca050513          	addi	a0,a0,-864 # 80008630 <syscalls+0x208>
    80003998:	00002097          	auipc	ra,0x2
    8000399c:	4ba080e7          	jalr	1210(ra) # 80005e52 <panic>
  log.lh.block[i] = b->blockno;
    800039a0:	00878713          	addi	a4,a5,8
    800039a4:	00271693          	slli	a3,a4,0x2
    800039a8:	00235717          	auipc	a4,0x235
    800039ac:	f8870713          	addi	a4,a4,-120 # 80238930 <log>
    800039b0:	9736                	add	a4,a4,a3
    800039b2:	44d4                	lw	a3,12(s1)
    800039b4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039b6:	faf608e3          	beq	a2,a5,80003966 <log_write+0x76>
  }
  release(&log.lock);
    800039ba:	00235517          	auipc	a0,0x235
    800039be:	f7650513          	addi	a0,a0,-138 # 80238930 <log>
    800039c2:	00003097          	auipc	ra,0x3
    800039c6:	a8e080e7          	jalr	-1394(ra) # 80006450 <release>
}
    800039ca:	60e2                	ld	ra,24(sp)
    800039cc:	6442                	ld	s0,16(sp)
    800039ce:	64a2                	ld	s1,8(sp)
    800039d0:	6902                	ld	s2,0(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret

00000000800039d6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039d6:	1101                	addi	sp,sp,-32
    800039d8:	ec06                	sd	ra,24(sp)
    800039da:	e822                	sd	s0,16(sp)
    800039dc:	e426                	sd	s1,8(sp)
    800039de:	e04a                	sd	s2,0(sp)
    800039e0:	1000                	addi	s0,sp,32
    800039e2:	84aa                	mv	s1,a0
    800039e4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039e6:	00005597          	auipc	a1,0x5
    800039ea:	c6a58593          	addi	a1,a1,-918 # 80008650 <syscalls+0x228>
    800039ee:	0521                	addi	a0,a0,8
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	91c080e7          	jalr	-1764(ra) # 8000630c <initlock>
  lk->name = name;
    800039f8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a00:	0204a423          	sw	zero,40(s1)
}
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6902                	ld	s2,0(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a10:	1101                	addi	sp,sp,-32
    80003a12:	ec06                	sd	ra,24(sp)
    80003a14:	e822                	sd	s0,16(sp)
    80003a16:	e426                	sd	s1,8(sp)
    80003a18:	e04a                	sd	s2,0(sp)
    80003a1a:	1000                	addi	s0,sp,32
    80003a1c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1e:	00850913          	addi	s2,a0,8
    80003a22:	854a                	mv	a0,s2
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	978080e7          	jalr	-1672(ra) # 8000639c <acquire>
  while (lk->locked) {
    80003a2c:	409c                	lw	a5,0(s1)
    80003a2e:	cb89                	beqz	a5,80003a40 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a30:	85ca                	mv	a1,s2
    80003a32:	8526                	mv	a0,s1
    80003a34:	ffffe097          	auipc	ra,0xffffe
    80003a38:	c6a080e7          	jalr	-918(ra) # 8000169e <sleep>
  while (lk->locked) {
    80003a3c:	409c                	lw	a5,0(s1)
    80003a3e:	fbed                	bnez	a5,80003a30 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a40:	4785                	li	a5,1
    80003a42:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	5b2080e7          	jalr	1458(ra) # 80000ff6 <myproc>
    80003a4c:	591c                	lw	a5,48(a0)
    80003a4e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a50:	854a                	mv	a0,s2
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	9fe080e7          	jalr	-1538(ra) # 80006450 <release>
}
    80003a5a:	60e2                	ld	ra,24(sp)
    80003a5c:	6442                	ld	s0,16(sp)
    80003a5e:	64a2                	ld	s1,8(sp)
    80003a60:	6902                	ld	s2,0(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret

0000000080003a66 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	e426                	sd	s1,8(sp)
    80003a6e:	e04a                	sd	s2,0(sp)
    80003a70:	1000                	addi	s0,sp,32
    80003a72:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a74:	00850913          	addi	s2,a0,8
    80003a78:	854a                	mv	a0,s2
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	922080e7          	jalr	-1758(ra) # 8000639c <acquire>
  lk->locked = 0;
    80003a82:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a86:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	ffffe097          	auipc	ra,0xffffe
    80003a90:	c76080e7          	jalr	-906(ra) # 80001702 <wakeup>
  release(&lk->lk);
    80003a94:	854a                	mv	a0,s2
    80003a96:	00003097          	auipc	ra,0x3
    80003a9a:	9ba080e7          	jalr	-1606(ra) # 80006450 <release>
}
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	64a2                	ld	s1,8(sp)
    80003aa4:	6902                	ld	s2,0(sp)
    80003aa6:	6105                	addi	sp,sp,32
    80003aa8:	8082                	ret

0000000080003aaa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003aaa:	7179                	addi	sp,sp,-48
    80003aac:	f406                	sd	ra,40(sp)
    80003aae:	f022                	sd	s0,32(sp)
    80003ab0:	ec26                	sd	s1,24(sp)
    80003ab2:	e84a                	sd	s2,16(sp)
    80003ab4:	e44e                	sd	s3,8(sp)
    80003ab6:	1800                	addi	s0,sp,48
    80003ab8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aba:	00850913          	addi	s2,a0,8
    80003abe:	854a                	mv	a0,s2
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	8dc080e7          	jalr	-1828(ra) # 8000639c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ac8:	409c                	lw	a5,0(s1)
    80003aca:	ef99                	bnez	a5,80003ae8 <holdingsleep+0x3e>
    80003acc:	4481                	li	s1,0
  release(&lk->lk);
    80003ace:	854a                	mv	a0,s2
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	980080e7          	jalr	-1664(ra) # 80006450 <release>
  return r;
}
    80003ad8:	8526                	mv	a0,s1
    80003ada:	70a2                	ld	ra,40(sp)
    80003adc:	7402                	ld	s0,32(sp)
    80003ade:	64e2                	ld	s1,24(sp)
    80003ae0:	6942                	ld	s2,16(sp)
    80003ae2:	69a2                	ld	s3,8(sp)
    80003ae4:	6145                	addi	sp,sp,48
    80003ae6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae8:	0284a983          	lw	s3,40(s1)
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	50a080e7          	jalr	1290(ra) # 80000ff6 <myproc>
    80003af4:	5904                	lw	s1,48(a0)
    80003af6:	413484b3          	sub	s1,s1,s3
    80003afa:	0014b493          	seqz	s1,s1
    80003afe:	bfc1                	j	80003ace <holdingsleep+0x24>

0000000080003b00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b00:	1141                	addi	sp,sp,-16
    80003b02:	e406                	sd	ra,8(sp)
    80003b04:	e022                	sd	s0,0(sp)
    80003b06:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b08:	00005597          	auipc	a1,0x5
    80003b0c:	b5858593          	addi	a1,a1,-1192 # 80008660 <syscalls+0x238>
    80003b10:	00235517          	auipc	a0,0x235
    80003b14:	f6850513          	addi	a0,a0,-152 # 80238a78 <ftable>
    80003b18:	00002097          	auipc	ra,0x2
    80003b1c:	7f4080e7          	jalr	2036(ra) # 8000630c <initlock>
}
    80003b20:	60a2                	ld	ra,8(sp)
    80003b22:	6402                	ld	s0,0(sp)
    80003b24:	0141                	addi	sp,sp,16
    80003b26:	8082                	ret

0000000080003b28 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b28:	1101                	addi	sp,sp,-32
    80003b2a:	ec06                	sd	ra,24(sp)
    80003b2c:	e822                	sd	s0,16(sp)
    80003b2e:	e426                	sd	s1,8(sp)
    80003b30:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b32:	00235517          	auipc	a0,0x235
    80003b36:	f4650513          	addi	a0,a0,-186 # 80238a78 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	862080e7          	jalr	-1950(ra) # 8000639c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b42:	00235497          	auipc	s1,0x235
    80003b46:	f4e48493          	addi	s1,s1,-178 # 80238a90 <ftable+0x18>
    80003b4a:	00236717          	auipc	a4,0x236
    80003b4e:	ee670713          	addi	a4,a4,-282 # 80239a30 <disk>
    if(f->ref == 0){
    80003b52:	40dc                	lw	a5,4(s1)
    80003b54:	cf99                	beqz	a5,80003b72 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b56:	02848493          	addi	s1,s1,40
    80003b5a:	fee49ce3          	bne	s1,a4,80003b52 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b5e:	00235517          	auipc	a0,0x235
    80003b62:	f1a50513          	addi	a0,a0,-230 # 80238a78 <ftable>
    80003b66:	00003097          	auipc	ra,0x3
    80003b6a:	8ea080e7          	jalr	-1814(ra) # 80006450 <release>
  return 0;
    80003b6e:	4481                	li	s1,0
    80003b70:	a819                	j	80003b86 <filealloc+0x5e>
      f->ref = 1;
    80003b72:	4785                	li	a5,1
    80003b74:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b76:	00235517          	auipc	a0,0x235
    80003b7a:	f0250513          	addi	a0,a0,-254 # 80238a78 <ftable>
    80003b7e:	00003097          	auipc	ra,0x3
    80003b82:	8d2080e7          	jalr	-1838(ra) # 80006450 <release>
}
    80003b86:	8526                	mv	a0,s1
    80003b88:	60e2                	ld	ra,24(sp)
    80003b8a:	6442                	ld	s0,16(sp)
    80003b8c:	64a2                	ld	s1,8(sp)
    80003b8e:	6105                	addi	sp,sp,32
    80003b90:	8082                	ret

0000000080003b92 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b92:	1101                	addi	sp,sp,-32
    80003b94:	ec06                	sd	ra,24(sp)
    80003b96:	e822                	sd	s0,16(sp)
    80003b98:	e426                	sd	s1,8(sp)
    80003b9a:	1000                	addi	s0,sp,32
    80003b9c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b9e:	00235517          	auipc	a0,0x235
    80003ba2:	eda50513          	addi	a0,a0,-294 # 80238a78 <ftable>
    80003ba6:	00002097          	auipc	ra,0x2
    80003baa:	7f6080e7          	jalr	2038(ra) # 8000639c <acquire>
  if(f->ref < 1)
    80003bae:	40dc                	lw	a5,4(s1)
    80003bb0:	02f05263          	blez	a5,80003bd4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bb4:	2785                	addiw	a5,a5,1
    80003bb6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bb8:	00235517          	auipc	a0,0x235
    80003bbc:	ec050513          	addi	a0,a0,-320 # 80238a78 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	890080e7          	jalr	-1904(ra) # 80006450 <release>
  return f;
}
    80003bc8:	8526                	mv	a0,s1
    80003bca:	60e2                	ld	ra,24(sp)
    80003bcc:	6442                	ld	s0,16(sp)
    80003bce:	64a2                	ld	s1,8(sp)
    80003bd0:	6105                	addi	sp,sp,32
    80003bd2:	8082                	ret
    panic("filedup");
    80003bd4:	00005517          	auipc	a0,0x5
    80003bd8:	a9450513          	addi	a0,a0,-1388 # 80008668 <syscalls+0x240>
    80003bdc:	00002097          	auipc	ra,0x2
    80003be0:	276080e7          	jalr	630(ra) # 80005e52 <panic>

0000000080003be4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003be4:	7139                	addi	sp,sp,-64
    80003be6:	fc06                	sd	ra,56(sp)
    80003be8:	f822                	sd	s0,48(sp)
    80003bea:	f426                	sd	s1,40(sp)
    80003bec:	f04a                	sd	s2,32(sp)
    80003bee:	ec4e                	sd	s3,24(sp)
    80003bf0:	e852                	sd	s4,16(sp)
    80003bf2:	e456                	sd	s5,8(sp)
    80003bf4:	0080                	addi	s0,sp,64
    80003bf6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bf8:	00235517          	auipc	a0,0x235
    80003bfc:	e8050513          	addi	a0,a0,-384 # 80238a78 <ftable>
    80003c00:	00002097          	auipc	ra,0x2
    80003c04:	79c080e7          	jalr	1948(ra) # 8000639c <acquire>
  if(f->ref < 1)
    80003c08:	40dc                	lw	a5,4(s1)
    80003c0a:	06f05163          	blez	a5,80003c6c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c0e:	37fd                	addiw	a5,a5,-1
    80003c10:	0007871b          	sext.w	a4,a5
    80003c14:	c0dc                	sw	a5,4(s1)
    80003c16:	06e04363          	bgtz	a4,80003c7c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c1a:	0004a903          	lw	s2,0(s1)
    80003c1e:	0094ca83          	lbu	s5,9(s1)
    80003c22:	0104ba03          	ld	s4,16(s1)
    80003c26:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c2a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c2e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c32:	00235517          	auipc	a0,0x235
    80003c36:	e4650513          	addi	a0,a0,-442 # 80238a78 <ftable>
    80003c3a:	00003097          	auipc	ra,0x3
    80003c3e:	816080e7          	jalr	-2026(ra) # 80006450 <release>

  if(ff.type == FD_PIPE){
    80003c42:	4785                	li	a5,1
    80003c44:	04f90d63          	beq	s2,a5,80003c9e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c48:	3979                	addiw	s2,s2,-2
    80003c4a:	4785                	li	a5,1
    80003c4c:	0527e063          	bltu	a5,s2,80003c8c <fileclose+0xa8>
    begin_op();
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	ac8080e7          	jalr	-1336(ra) # 80003718 <begin_op>
    iput(ff.ip);
    80003c58:	854e                	mv	a0,s3
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	2b6080e7          	jalr	694(ra) # 80002f10 <iput>
    end_op();
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	b36080e7          	jalr	-1226(ra) # 80003798 <end_op>
    80003c6a:	a00d                	j	80003c8c <fileclose+0xa8>
    panic("fileclose");
    80003c6c:	00005517          	auipc	a0,0x5
    80003c70:	a0450513          	addi	a0,a0,-1532 # 80008670 <syscalls+0x248>
    80003c74:	00002097          	auipc	ra,0x2
    80003c78:	1de080e7          	jalr	478(ra) # 80005e52 <panic>
    release(&ftable.lock);
    80003c7c:	00235517          	auipc	a0,0x235
    80003c80:	dfc50513          	addi	a0,a0,-516 # 80238a78 <ftable>
    80003c84:	00002097          	auipc	ra,0x2
    80003c88:	7cc080e7          	jalr	1996(ra) # 80006450 <release>
  }
}
    80003c8c:	70e2                	ld	ra,56(sp)
    80003c8e:	7442                	ld	s0,48(sp)
    80003c90:	74a2                	ld	s1,40(sp)
    80003c92:	7902                	ld	s2,32(sp)
    80003c94:	69e2                	ld	s3,24(sp)
    80003c96:	6a42                	ld	s4,16(sp)
    80003c98:	6aa2                	ld	s5,8(sp)
    80003c9a:	6121                	addi	sp,sp,64
    80003c9c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c9e:	85d6                	mv	a1,s5
    80003ca0:	8552                	mv	a0,s4
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	34c080e7          	jalr	844(ra) # 80003fee <pipeclose>
    80003caa:	b7cd                	j	80003c8c <fileclose+0xa8>

0000000080003cac <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cac:	715d                	addi	sp,sp,-80
    80003cae:	e486                	sd	ra,72(sp)
    80003cb0:	e0a2                	sd	s0,64(sp)
    80003cb2:	fc26                	sd	s1,56(sp)
    80003cb4:	f84a                	sd	s2,48(sp)
    80003cb6:	f44e                	sd	s3,40(sp)
    80003cb8:	0880                	addi	s0,sp,80
    80003cba:	84aa                	mv	s1,a0
    80003cbc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cbe:	ffffd097          	auipc	ra,0xffffd
    80003cc2:	338080e7          	jalr	824(ra) # 80000ff6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cc6:	409c                	lw	a5,0(s1)
    80003cc8:	37f9                	addiw	a5,a5,-2
    80003cca:	4705                	li	a4,1
    80003ccc:	04f76763          	bltu	a4,a5,80003d1a <filestat+0x6e>
    80003cd0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cd2:	6c88                	ld	a0,24(s1)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	082080e7          	jalr	130(ra) # 80002d56 <ilock>
    stati(f->ip, &st);
    80003cdc:	fb840593          	addi	a1,s0,-72
    80003ce0:	6c88                	ld	a0,24(s1)
    80003ce2:	fffff097          	auipc	ra,0xfffff
    80003ce6:	2fe080e7          	jalr	766(ra) # 80002fe0 <stati>
    iunlock(f->ip);
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	12c080e7          	jalr	300(ra) # 80002e18 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cf4:	46e1                	li	a3,24
    80003cf6:	fb840613          	addi	a2,s0,-72
    80003cfa:	85ce                	mv	a1,s3
    80003cfc:	05093503          	ld	a0,80(s2)
    80003d00:	ffffd097          	auipc	ra,0xffffd
    80003d04:	f10080e7          	jalr	-240(ra) # 80000c10 <copyout>
    80003d08:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d0c:	60a6                	ld	ra,72(sp)
    80003d0e:	6406                	ld	s0,64(sp)
    80003d10:	74e2                	ld	s1,56(sp)
    80003d12:	7942                	ld	s2,48(sp)
    80003d14:	79a2                	ld	s3,40(sp)
    80003d16:	6161                	addi	sp,sp,80
    80003d18:	8082                	ret
  return -1;
    80003d1a:	557d                	li	a0,-1
    80003d1c:	bfc5                	j	80003d0c <filestat+0x60>

0000000080003d1e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d1e:	7179                	addi	sp,sp,-48
    80003d20:	f406                	sd	ra,40(sp)
    80003d22:	f022                	sd	s0,32(sp)
    80003d24:	ec26                	sd	s1,24(sp)
    80003d26:	e84a                	sd	s2,16(sp)
    80003d28:	e44e                	sd	s3,8(sp)
    80003d2a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d2c:	00854783          	lbu	a5,8(a0)
    80003d30:	c3d5                	beqz	a5,80003dd4 <fileread+0xb6>
    80003d32:	84aa                	mv	s1,a0
    80003d34:	89ae                	mv	s3,a1
    80003d36:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d38:	411c                	lw	a5,0(a0)
    80003d3a:	4705                	li	a4,1
    80003d3c:	04e78963          	beq	a5,a4,80003d8e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d40:	470d                	li	a4,3
    80003d42:	04e78d63          	beq	a5,a4,80003d9c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d46:	4709                	li	a4,2
    80003d48:	06e79e63          	bne	a5,a4,80003dc4 <fileread+0xa6>
    ilock(f->ip);
    80003d4c:	6d08                	ld	a0,24(a0)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	008080e7          	jalr	8(ra) # 80002d56 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d56:	874a                	mv	a4,s2
    80003d58:	5094                	lw	a3,32(s1)
    80003d5a:	864e                	mv	a2,s3
    80003d5c:	4585                	li	a1,1
    80003d5e:	6c88                	ld	a0,24(s1)
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	2aa080e7          	jalr	682(ra) # 8000300a <readi>
    80003d68:	892a                	mv	s2,a0
    80003d6a:	00a05563          	blez	a0,80003d74 <fileread+0x56>
      f->off += r;
    80003d6e:	509c                	lw	a5,32(s1)
    80003d70:	9fa9                	addw	a5,a5,a0
    80003d72:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d74:	6c88                	ld	a0,24(s1)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	0a2080e7          	jalr	162(ra) # 80002e18 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d7e:	854a                	mv	a0,s2
    80003d80:	70a2                	ld	ra,40(sp)
    80003d82:	7402                	ld	s0,32(sp)
    80003d84:	64e2                	ld	s1,24(sp)
    80003d86:	6942                	ld	s2,16(sp)
    80003d88:	69a2                	ld	s3,8(sp)
    80003d8a:	6145                	addi	sp,sp,48
    80003d8c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d8e:	6908                	ld	a0,16(a0)
    80003d90:	00000097          	auipc	ra,0x0
    80003d94:	3ce080e7          	jalr	974(ra) # 8000415e <piperead>
    80003d98:	892a                	mv	s2,a0
    80003d9a:	b7d5                	j	80003d7e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d9c:	02451783          	lh	a5,36(a0)
    80003da0:	03079693          	slli	a3,a5,0x30
    80003da4:	92c1                	srli	a3,a3,0x30
    80003da6:	4725                	li	a4,9
    80003da8:	02d76863          	bltu	a4,a3,80003dd8 <fileread+0xba>
    80003dac:	0792                	slli	a5,a5,0x4
    80003dae:	00235717          	auipc	a4,0x235
    80003db2:	c2a70713          	addi	a4,a4,-982 # 802389d8 <devsw>
    80003db6:	97ba                	add	a5,a5,a4
    80003db8:	639c                	ld	a5,0(a5)
    80003dba:	c38d                	beqz	a5,80003ddc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dbc:	4505                	li	a0,1
    80003dbe:	9782                	jalr	a5
    80003dc0:	892a                	mv	s2,a0
    80003dc2:	bf75                	j	80003d7e <fileread+0x60>
    panic("fileread");
    80003dc4:	00005517          	auipc	a0,0x5
    80003dc8:	8bc50513          	addi	a0,a0,-1860 # 80008680 <syscalls+0x258>
    80003dcc:	00002097          	auipc	ra,0x2
    80003dd0:	086080e7          	jalr	134(ra) # 80005e52 <panic>
    return -1;
    80003dd4:	597d                	li	s2,-1
    80003dd6:	b765                	j	80003d7e <fileread+0x60>
      return -1;
    80003dd8:	597d                	li	s2,-1
    80003dda:	b755                	j	80003d7e <fileread+0x60>
    80003ddc:	597d                	li	s2,-1
    80003dde:	b745                	j	80003d7e <fileread+0x60>

0000000080003de0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003de0:	715d                	addi	sp,sp,-80
    80003de2:	e486                	sd	ra,72(sp)
    80003de4:	e0a2                	sd	s0,64(sp)
    80003de6:	fc26                	sd	s1,56(sp)
    80003de8:	f84a                	sd	s2,48(sp)
    80003dea:	f44e                	sd	s3,40(sp)
    80003dec:	f052                	sd	s4,32(sp)
    80003dee:	ec56                	sd	s5,24(sp)
    80003df0:	e85a                	sd	s6,16(sp)
    80003df2:	e45e                	sd	s7,8(sp)
    80003df4:	e062                	sd	s8,0(sp)
    80003df6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003df8:	00954783          	lbu	a5,9(a0)
    80003dfc:	10078663          	beqz	a5,80003f08 <filewrite+0x128>
    80003e00:	892a                	mv	s2,a0
    80003e02:	8aae                	mv	s5,a1
    80003e04:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e06:	411c                	lw	a5,0(a0)
    80003e08:	4705                	li	a4,1
    80003e0a:	02e78263          	beq	a5,a4,80003e2e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e0e:	470d                	li	a4,3
    80003e10:	02e78663          	beq	a5,a4,80003e3c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e14:	4709                	li	a4,2
    80003e16:	0ee79163          	bne	a5,a4,80003ef8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e1a:	0ac05d63          	blez	a2,80003ed4 <filewrite+0xf4>
    int i = 0;
    80003e1e:	4981                	li	s3,0
    80003e20:	6b05                	lui	s6,0x1
    80003e22:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e26:	6b85                	lui	s7,0x1
    80003e28:	c00b8b9b          	addiw	s7,s7,-1024
    80003e2c:	a861                	j	80003ec4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e2e:	6908                	ld	a0,16(a0)
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	22e080e7          	jalr	558(ra) # 8000405e <pipewrite>
    80003e38:	8a2a                	mv	s4,a0
    80003e3a:	a045                	j	80003eda <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e3c:	02451783          	lh	a5,36(a0)
    80003e40:	03079693          	slli	a3,a5,0x30
    80003e44:	92c1                	srli	a3,a3,0x30
    80003e46:	4725                	li	a4,9
    80003e48:	0cd76263          	bltu	a4,a3,80003f0c <filewrite+0x12c>
    80003e4c:	0792                	slli	a5,a5,0x4
    80003e4e:	00235717          	auipc	a4,0x235
    80003e52:	b8a70713          	addi	a4,a4,-1142 # 802389d8 <devsw>
    80003e56:	97ba                	add	a5,a5,a4
    80003e58:	679c                	ld	a5,8(a5)
    80003e5a:	cbdd                	beqz	a5,80003f10 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e5c:	4505                	li	a0,1
    80003e5e:	9782                	jalr	a5
    80003e60:	8a2a                	mv	s4,a0
    80003e62:	a8a5                	j	80003eda <filewrite+0xfa>
    80003e64:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	8b0080e7          	jalr	-1872(ra) # 80003718 <begin_op>
      ilock(f->ip);
    80003e70:	01893503          	ld	a0,24(s2)
    80003e74:	fffff097          	auipc	ra,0xfffff
    80003e78:	ee2080e7          	jalr	-286(ra) # 80002d56 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e7c:	8762                	mv	a4,s8
    80003e7e:	02092683          	lw	a3,32(s2)
    80003e82:	01598633          	add	a2,s3,s5
    80003e86:	4585                	li	a1,1
    80003e88:	01893503          	ld	a0,24(s2)
    80003e8c:	fffff097          	auipc	ra,0xfffff
    80003e90:	276080e7          	jalr	630(ra) # 80003102 <writei>
    80003e94:	84aa                	mv	s1,a0
    80003e96:	00a05763          	blez	a0,80003ea4 <filewrite+0xc4>
        f->off += r;
    80003e9a:	02092783          	lw	a5,32(s2)
    80003e9e:	9fa9                	addw	a5,a5,a0
    80003ea0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ea4:	01893503          	ld	a0,24(s2)
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	f70080e7          	jalr	-144(ra) # 80002e18 <iunlock>
      end_op();
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	8e8080e7          	jalr	-1816(ra) # 80003798 <end_op>

      if(r != n1){
    80003eb8:	009c1f63          	bne	s8,s1,80003ed6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ebc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ec0:	0149db63          	bge	s3,s4,80003ed6 <filewrite+0xf6>
      int n1 = n - i;
    80003ec4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ec8:	84be                	mv	s1,a5
    80003eca:	2781                	sext.w	a5,a5
    80003ecc:	f8fb5ce3          	bge	s6,a5,80003e64 <filewrite+0x84>
    80003ed0:	84de                	mv	s1,s7
    80003ed2:	bf49                	j	80003e64 <filewrite+0x84>
    int i = 0;
    80003ed4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ed6:	013a1f63          	bne	s4,s3,80003ef4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eda:	8552                	mv	a0,s4
    80003edc:	60a6                	ld	ra,72(sp)
    80003ede:	6406                	ld	s0,64(sp)
    80003ee0:	74e2                	ld	s1,56(sp)
    80003ee2:	7942                	ld	s2,48(sp)
    80003ee4:	79a2                	ld	s3,40(sp)
    80003ee6:	7a02                	ld	s4,32(sp)
    80003ee8:	6ae2                	ld	s5,24(sp)
    80003eea:	6b42                	ld	s6,16(sp)
    80003eec:	6ba2                	ld	s7,8(sp)
    80003eee:	6c02                	ld	s8,0(sp)
    80003ef0:	6161                	addi	sp,sp,80
    80003ef2:	8082                	ret
    ret = (i == n ? n : -1);
    80003ef4:	5a7d                	li	s4,-1
    80003ef6:	b7d5                	j	80003eda <filewrite+0xfa>
    panic("filewrite");
    80003ef8:	00004517          	auipc	a0,0x4
    80003efc:	79850513          	addi	a0,a0,1944 # 80008690 <syscalls+0x268>
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	f52080e7          	jalr	-174(ra) # 80005e52 <panic>
    return -1;
    80003f08:	5a7d                	li	s4,-1
    80003f0a:	bfc1                	j	80003eda <filewrite+0xfa>
      return -1;
    80003f0c:	5a7d                	li	s4,-1
    80003f0e:	b7f1                	j	80003eda <filewrite+0xfa>
    80003f10:	5a7d                	li	s4,-1
    80003f12:	b7e1                	j	80003eda <filewrite+0xfa>

0000000080003f14 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f14:	7179                	addi	sp,sp,-48
    80003f16:	f406                	sd	ra,40(sp)
    80003f18:	f022                	sd	s0,32(sp)
    80003f1a:	ec26                	sd	s1,24(sp)
    80003f1c:	e84a                	sd	s2,16(sp)
    80003f1e:	e44e                	sd	s3,8(sp)
    80003f20:	e052                	sd	s4,0(sp)
    80003f22:	1800                	addi	s0,sp,48
    80003f24:	84aa                	mv	s1,a0
    80003f26:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f28:	0005b023          	sd	zero,0(a1)
    80003f2c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	bf8080e7          	jalr	-1032(ra) # 80003b28 <filealloc>
    80003f38:	e088                	sd	a0,0(s1)
    80003f3a:	c551                	beqz	a0,80003fc6 <pipealloc+0xb2>
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	bec080e7          	jalr	-1044(ra) # 80003b28 <filealloc>
    80003f44:	00aa3023          	sd	a0,0(s4)
    80003f48:	c92d                	beqz	a0,80003fba <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f4a:	ffffc097          	auipc	ra,0xffffc
    80003f4e:	290080e7          	jalr	656(ra) # 800001da <kalloc>
    80003f52:	892a                	mv	s2,a0
    80003f54:	c125                	beqz	a0,80003fb4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f56:	4985                	li	s3,1
    80003f58:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f5c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f60:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f64:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f68:	00004597          	auipc	a1,0x4
    80003f6c:	73858593          	addi	a1,a1,1848 # 800086a0 <syscalls+0x278>
    80003f70:	00002097          	auipc	ra,0x2
    80003f74:	39c080e7          	jalr	924(ra) # 8000630c <initlock>
  (*f0)->type = FD_PIPE;
    80003f78:	609c                	ld	a5,0(s1)
    80003f7a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f7e:	609c                	ld	a5,0(s1)
    80003f80:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f84:	609c                	ld	a5,0(s1)
    80003f86:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f8a:	609c                	ld	a5,0(s1)
    80003f8c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f90:	000a3783          	ld	a5,0(s4)
    80003f94:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f98:	000a3783          	ld	a5,0(s4)
    80003f9c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fa0:	000a3783          	ld	a5,0(s4)
    80003fa4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fa8:	000a3783          	ld	a5,0(s4)
    80003fac:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fb0:	4501                	li	a0,0
    80003fb2:	a025                	j	80003fda <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fb4:	6088                	ld	a0,0(s1)
    80003fb6:	e501                	bnez	a0,80003fbe <pipealloc+0xaa>
    80003fb8:	a039                	j	80003fc6 <pipealloc+0xb2>
    80003fba:	6088                	ld	a0,0(s1)
    80003fbc:	c51d                	beqz	a0,80003fea <pipealloc+0xd6>
    fileclose(*f0);
    80003fbe:	00000097          	auipc	ra,0x0
    80003fc2:	c26080e7          	jalr	-986(ra) # 80003be4 <fileclose>
  if(*f1)
    80003fc6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fca:	557d                	li	a0,-1
  if(*f1)
    80003fcc:	c799                	beqz	a5,80003fda <pipealloc+0xc6>
    fileclose(*f1);
    80003fce:	853e                	mv	a0,a5
    80003fd0:	00000097          	auipc	ra,0x0
    80003fd4:	c14080e7          	jalr	-1004(ra) # 80003be4 <fileclose>
  return -1;
    80003fd8:	557d                	li	a0,-1
}
    80003fda:	70a2                	ld	ra,40(sp)
    80003fdc:	7402                	ld	s0,32(sp)
    80003fde:	64e2                	ld	s1,24(sp)
    80003fe0:	6942                	ld	s2,16(sp)
    80003fe2:	69a2                	ld	s3,8(sp)
    80003fe4:	6a02                	ld	s4,0(sp)
    80003fe6:	6145                	addi	sp,sp,48
    80003fe8:	8082                	ret
  return -1;
    80003fea:	557d                	li	a0,-1
    80003fec:	b7fd                	j	80003fda <pipealloc+0xc6>

0000000080003fee <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fee:	1101                	addi	sp,sp,-32
    80003ff0:	ec06                	sd	ra,24(sp)
    80003ff2:	e822                	sd	s0,16(sp)
    80003ff4:	e426                	sd	s1,8(sp)
    80003ff6:	e04a                	sd	s2,0(sp)
    80003ff8:	1000                	addi	s0,sp,32
    80003ffa:	84aa                	mv	s1,a0
    80003ffc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	39e080e7          	jalr	926(ra) # 8000639c <acquire>
  if(writable){
    80004006:	02090d63          	beqz	s2,80004040 <pipeclose+0x52>
    pi->writeopen = 0;
    8000400a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000400e:	21848513          	addi	a0,s1,536
    80004012:	ffffd097          	auipc	ra,0xffffd
    80004016:	6f0080e7          	jalr	1776(ra) # 80001702 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000401a:	2204b783          	ld	a5,544(s1)
    8000401e:	eb95                	bnez	a5,80004052 <pipeclose+0x64>
    release(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00002097          	auipc	ra,0x2
    80004026:	42e080e7          	jalr	1070(ra) # 80006450 <release>
    kfree((char*)pi);
    8000402a:	8526                	mv	a0,s1
    8000402c:	ffffc097          	auipc	ra,0xffffc
    80004030:	052080e7          	jalr	82(ra) # 8000007e <kfree>
  } else
    release(&pi->lock);
}
    80004034:	60e2                	ld	ra,24(sp)
    80004036:	6442                	ld	s0,16(sp)
    80004038:	64a2                	ld	s1,8(sp)
    8000403a:	6902                	ld	s2,0(sp)
    8000403c:	6105                	addi	sp,sp,32
    8000403e:	8082                	ret
    pi->readopen = 0;
    80004040:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004044:	21c48513          	addi	a0,s1,540
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	6ba080e7          	jalr	1722(ra) # 80001702 <wakeup>
    80004050:	b7e9                	j	8000401a <pipeclose+0x2c>
    release(&pi->lock);
    80004052:	8526                	mv	a0,s1
    80004054:	00002097          	auipc	ra,0x2
    80004058:	3fc080e7          	jalr	1020(ra) # 80006450 <release>
}
    8000405c:	bfe1                	j	80004034 <pipeclose+0x46>

000000008000405e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000405e:	7159                	addi	sp,sp,-112
    80004060:	f486                	sd	ra,104(sp)
    80004062:	f0a2                	sd	s0,96(sp)
    80004064:	eca6                	sd	s1,88(sp)
    80004066:	e8ca                	sd	s2,80(sp)
    80004068:	e4ce                	sd	s3,72(sp)
    8000406a:	e0d2                	sd	s4,64(sp)
    8000406c:	fc56                	sd	s5,56(sp)
    8000406e:	f85a                	sd	s6,48(sp)
    80004070:	f45e                	sd	s7,40(sp)
    80004072:	f062                	sd	s8,32(sp)
    80004074:	ec66                	sd	s9,24(sp)
    80004076:	1880                	addi	s0,sp,112
    80004078:	84aa                	mv	s1,a0
    8000407a:	8aae                	mv	s5,a1
    8000407c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	f78080e7          	jalr	-136(ra) # 80000ff6 <myproc>
    80004086:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004088:	8526                	mv	a0,s1
    8000408a:	00002097          	auipc	ra,0x2
    8000408e:	312080e7          	jalr	786(ra) # 8000639c <acquire>
  while(i < n){
    80004092:	0d405463          	blez	s4,8000415a <pipewrite+0xfc>
    80004096:	8ba6                	mv	s7,s1
  int i = 0;
    80004098:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000409a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000409c:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040a0:	21c48c13          	addi	s8,s1,540
    800040a4:	a08d                	j	80004106 <pipewrite+0xa8>
      release(&pi->lock);
    800040a6:	8526                	mv	a0,s1
    800040a8:	00002097          	auipc	ra,0x2
    800040ac:	3a8080e7          	jalr	936(ra) # 80006450 <release>
      return -1;
    800040b0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040b2:	854a                	mv	a0,s2
    800040b4:	70a6                	ld	ra,104(sp)
    800040b6:	7406                	ld	s0,96(sp)
    800040b8:	64e6                	ld	s1,88(sp)
    800040ba:	6946                	ld	s2,80(sp)
    800040bc:	69a6                	ld	s3,72(sp)
    800040be:	6a06                	ld	s4,64(sp)
    800040c0:	7ae2                	ld	s5,56(sp)
    800040c2:	7b42                	ld	s6,48(sp)
    800040c4:	7ba2                	ld	s7,40(sp)
    800040c6:	7c02                	ld	s8,32(sp)
    800040c8:	6ce2                	ld	s9,24(sp)
    800040ca:	6165                	addi	sp,sp,112
    800040cc:	8082                	ret
      wakeup(&pi->nread);
    800040ce:	8566                	mv	a0,s9
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	632080e7          	jalr	1586(ra) # 80001702 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040d8:	85de                	mv	a1,s7
    800040da:	8562                	mv	a0,s8
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	5c2080e7          	jalr	1474(ra) # 8000169e <sleep>
    800040e4:	a839                	j	80004102 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040e6:	21c4a783          	lw	a5,540(s1)
    800040ea:	0017871b          	addiw	a4,a5,1
    800040ee:	20e4ae23          	sw	a4,540(s1)
    800040f2:	1ff7f793          	andi	a5,a5,511
    800040f6:	97a6                	add	a5,a5,s1
    800040f8:	f9f44703          	lbu	a4,-97(s0)
    800040fc:	00e78c23          	sb	a4,24(a5)
      i++;
    80004100:	2905                	addiw	s2,s2,1
  while(i < n){
    80004102:	05495063          	bge	s2,s4,80004142 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004106:	2204a783          	lw	a5,544(s1)
    8000410a:	dfd1                	beqz	a5,800040a6 <pipewrite+0x48>
    8000410c:	854e                	mv	a0,s3
    8000410e:	ffffe097          	auipc	ra,0xffffe
    80004112:	838080e7          	jalr	-1992(ra) # 80001946 <killed>
    80004116:	f941                	bnez	a0,800040a6 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004118:	2184a783          	lw	a5,536(s1)
    8000411c:	21c4a703          	lw	a4,540(s1)
    80004120:	2007879b          	addiw	a5,a5,512
    80004124:	faf705e3          	beq	a4,a5,800040ce <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004128:	4685                	li	a3,1
    8000412a:	01590633          	add	a2,s2,s5
    8000412e:	f9f40593          	addi	a1,s0,-97
    80004132:	0509b503          	ld	a0,80(s3)
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	c0a080e7          	jalr	-1014(ra) # 80000d40 <copyin>
    8000413e:	fb6514e3          	bne	a0,s6,800040e6 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004142:	21848513          	addi	a0,s1,536
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	5bc080e7          	jalr	1468(ra) # 80001702 <wakeup>
  release(&pi->lock);
    8000414e:	8526                	mv	a0,s1
    80004150:	00002097          	auipc	ra,0x2
    80004154:	300080e7          	jalr	768(ra) # 80006450 <release>
  return i;
    80004158:	bfa9                	j	800040b2 <pipewrite+0x54>
  int i = 0;
    8000415a:	4901                	li	s2,0
    8000415c:	b7dd                	j	80004142 <pipewrite+0xe4>

000000008000415e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000415e:	715d                	addi	sp,sp,-80
    80004160:	e486                	sd	ra,72(sp)
    80004162:	e0a2                	sd	s0,64(sp)
    80004164:	fc26                	sd	s1,56(sp)
    80004166:	f84a                	sd	s2,48(sp)
    80004168:	f44e                	sd	s3,40(sp)
    8000416a:	f052                	sd	s4,32(sp)
    8000416c:	ec56                	sd	s5,24(sp)
    8000416e:	e85a                	sd	s6,16(sp)
    80004170:	0880                	addi	s0,sp,80
    80004172:	84aa                	mv	s1,a0
    80004174:	892e                	mv	s2,a1
    80004176:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	e7e080e7          	jalr	-386(ra) # 80000ff6 <myproc>
    80004180:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004182:	8b26                	mv	s6,s1
    80004184:	8526                	mv	a0,s1
    80004186:	00002097          	auipc	ra,0x2
    8000418a:	216080e7          	jalr	534(ra) # 8000639c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000418e:	2184a703          	lw	a4,536(s1)
    80004192:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004196:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000419a:	02f71763          	bne	a4,a5,800041c8 <piperead+0x6a>
    8000419e:	2244a783          	lw	a5,548(s1)
    800041a2:	c39d                	beqz	a5,800041c8 <piperead+0x6a>
    if(killed(pr)){
    800041a4:	8552                	mv	a0,s4
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	7a0080e7          	jalr	1952(ra) # 80001946 <killed>
    800041ae:	e941                	bnez	a0,8000423e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b0:	85da                	mv	a1,s6
    800041b2:	854e                	mv	a0,s3
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	4ea080e7          	jalr	1258(ra) # 8000169e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041bc:	2184a703          	lw	a4,536(s1)
    800041c0:	21c4a783          	lw	a5,540(s1)
    800041c4:	fcf70de3          	beq	a4,a5,8000419e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c8:	09505263          	blez	s5,8000424c <piperead+0xee>
    800041cc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041ce:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041d0:	2184a783          	lw	a5,536(s1)
    800041d4:	21c4a703          	lw	a4,540(s1)
    800041d8:	02f70d63          	beq	a4,a5,80004212 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041dc:	0017871b          	addiw	a4,a5,1
    800041e0:	20e4ac23          	sw	a4,536(s1)
    800041e4:	1ff7f793          	andi	a5,a5,511
    800041e8:	97a6                	add	a5,a5,s1
    800041ea:	0187c783          	lbu	a5,24(a5)
    800041ee:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041f2:	4685                	li	a3,1
    800041f4:	fbf40613          	addi	a2,s0,-65
    800041f8:	85ca                	mv	a1,s2
    800041fa:	050a3503          	ld	a0,80(s4)
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	a12080e7          	jalr	-1518(ra) # 80000c10 <copyout>
    80004206:	01650663          	beq	a0,s6,80004212 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000420a:	2985                	addiw	s3,s3,1
    8000420c:	0905                	addi	s2,s2,1
    8000420e:	fd3a91e3          	bne	s5,s3,800041d0 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004212:	21c48513          	addi	a0,s1,540
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	4ec080e7          	jalr	1260(ra) # 80001702 <wakeup>
  release(&pi->lock);
    8000421e:	8526                	mv	a0,s1
    80004220:	00002097          	auipc	ra,0x2
    80004224:	230080e7          	jalr	560(ra) # 80006450 <release>
  return i;
}
    80004228:	854e                	mv	a0,s3
    8000422a:	60a6                	ld	ra,72(sp)
    8000422c:	6406                	ld	s0,64(sp)
    8000422e:	74e2                	ld	s1,56(sp)
    80004230:	7942                	ld	s2,48(sp)
    80004232:	79a2                	ld	s3,40(sp)
    80004234:	7a02                	ld	s4,32(sp)
    80004236:	6ae2                	ld	s5,24(sp)
    80004238:	6b42                	ld	s6,16(sp)
    8000423a:	6161                	addi	sp,sp,80
    8000423c:	8082                	ret
      release(&pi->lock);
    8000423e:	8526                	mv	a0,s1
    80004240:	00002097          	auipc	ra,0x2
    80004244:	210080e7          	jalr	528(ra) # 80006450 <release>
      return -1;
    80004248:	59fd                	li	s3,-1
    8000424a:	bff9                	j	80004228 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424c:	4981                	li	s3,0
    8000424e:	b7d1                	j	80004212 <piperead+0xb4>

0000000080004250 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004250:	1141                	addi	sp,sp,-16
    80004252:	e422                	sd	s0,8(sp)
    80004254:	0800                	addi	s0,sp,16
    80004256:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004258:	8905                	andi	a0,a0,1
    8000425a:	c111                	beqz	a0,8000425e <flags2perm+0xe>
      perm = PTE_X;
    8000425c:	4521                	li	a0,8
    if(flags & 0x2)
    8000425e:	8b89                	andi	a5,a5,2
    80004260:	c399                	beqz	a5,80004266 <flags2perm+0x16>
      perm |= PTE_W;
    80004262:	00456513          	ori	a0,a0,4
    return perm;
}
    80004266:	6422                	ld	s0,8(sp)
    80004268:	0141                	addi	sp,sp,16
    8000426a:	8082                	ret

000000008000426c <exec>:

int
exec(char *path, char **argv)
{
    8000426c:	df010113          	addi	sp,sp,-528
    80004270:	20113423          	sd	ra,520(sp)
    80004274:	20813023          	sd	s0,512(sp)
    80004278:	ffa6                	sd	s1,504(sp)
    8000427a:	fbca                	sd	s2,496(sp)
    8000427c:	f7ce                	sd	s3,488(sp)
    8000427e:	f3d2                	sd	s4,480(sp)
    80004280:	efd6                	sd	s5,472(sp)
    80004282:	ebda                	sd	s6,464(sp)
    80004284:	e7de                	sd	s7,456(sp)
    80004286:	e3e2                	sd	s8,448(sp)
    80004288:	ff66                	sd	s9,440(sp)
    8000428a:	fb6a                	sd	s10,432(sp)
    8000428c:	f76e                	sd	s11,424(sp)
    8000428e:	0c00                	addi	s0,sp,528
    80004290:	84aa                	mv	s1,a0
    80004292:	dea43c23          	sd	a0,-520(s0)
    80004296:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	d5c080e7          	jalr	-676(ra) # 80000ff6 <myproc>
    800042a2:	892a                	mv	s2,a0

  begin_op();
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	474080e7          	jalr	1140(ra) # 80003718 <begin_op>

  if((ip = namei(path)) == 0){
    800042ac:	8526                	mv	a0,s1
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	24e080e7          	jalr	590(ra) # 800034fc <namei>
    800042b6:	c92d                	beqz	a0,80004328 <exec+0xbc>
    800042b8:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042ba:	fffff097          	auipc	ra,0xfffff
    800042be:	a9c080e7          	jalr	-1380(ra) # 80002d56 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042c2:	04000713          	li	a4,64
    800042c6:	4681                	li	a3,0
    800042c8:	e5040613          	addi	a2,s0,-432
    800042cc:	4581                	li	a1,0
    800042ce:	8526                	mv	a0,s1
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	d3a080e7          	jalr	-710(ra) # 8000300a <readi>
    800042d8:	04000793          	li	a5,64
    800042dc:	00f51a63          	bne	a0,a5,800042f0 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042e0:	e5042703          	lw	a4,-432(s0)
    800042e4:	464c47b7          	lui	a5,0x464c4
    800042e8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ec:	04f70463          	beq	a4,a5,80004334 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042f0:	8526                	mv	a0,s1
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	cc6080e7          	jalr	-826(ra) # 80002fb8 <iunlockput>
    end_op();
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	49e080e7          	jalr	1182(ra) # 80003798 <end_op>
  }
  return -1;
    80004302:	557d                	li	a0,-1
}
    80004304:	20813083          	ld	ra,520(sp)
    80004308:	20013403          	ld	s0,512(sp)
    8000430c:	74fe                	ld	s1,504(sp)
    8000430e:	795e                	ld	s2,496(sp)
    80004310:	79be                	ld	s3,488(sp)
    80004312:	7a1e                	ld	s4,480(sp)
    80004314:	6afe                	ld	s5,472(sp)
    80004316:	6b5e                	ld	s6,464(sp)
    80004318:	6bbe                	ld	s7,456(sp)
    8000431a:	6c1e                	ld	s8,448(sp)
    8000431c:	7cfa                	ld	s9,440(sp)
    8000431e:	7d5a                	ld	s10,432(sp)
    80004320:	7dba                	ld	s11,424(sp)
    80004322:	21010113          	addi	sp,sp,528
    80004326:	8082                	ret
    end_op();
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	470080e7          	jalr	1136(ra) # 80003798 <end_op>
    return -1;
    80004330:	557d                	li	a0,-1
    80004332:	bfc9                	j	80004304 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004334:	854a                	mv	a0,s2
    80004336:	ffffd097          	auipc	ra,0xffffd
    8000433a:	d88080e7          	jalr	-632(ra) # 800010be <proc_pagetable>
    8000433e:	8baa                	mv	s7,a0
    80004340:	d945                	beqz	a0,800042f0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004342:	e7042983          	lw	s3,-400(s0)
    80004346:	e8845783          	lhu	a5,-376(s0)
    8000434a:	c7ad                	beqz	a5,800043b4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000434c:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000434e:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004350:	6c85                	lui	s9,0x1
    80004352:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004356:	def43823          	sd	a5,-528(s0)
    8000435a:	ac0d                	j	8000458c <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000435c:	00004517          	auipc	a0,0x4
    80004360:	34c50513          	addi	a0,a0,844 # 800086a8 <syscalls+0x280>
    80004364:	00002097          	auipc	ra,0x2
    80004368:	aee080e7          	jalr	-1298(ra) # 80005e52 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000436c:	8756                	mv	a4,s5
    8000436e:	012d86bb          	addw	a3,s11,s2
    80004372:	4581                	li	a1,0
    80004374:	8526                	mv	a0,s1
    80004376:	fffff097          	auipc	ra,0xfffff
    8000437a:	c94080e7          	jalr	-876(ra) # 8000300a <readi>
    8000437e:	2501                	sext.w	a0,a0
    80004380:	1aaa9a63          	bne	s5,a0,80004534 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004384:	6785                	lui	a5,0x1
    80004386:	0127893b          	addw	s2,a5,s2
    8000438a:	77fd                	lui	a5,0xfffff
    8000438c:	01478a3b          	addw	s4,a5,s4
    80004390:	1f897563          	bgeu	s2,s8,8000457a <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004394:	02091593          	slli	a1,s2,0x20
    80004398:	9181                	srli	a1,a1,0x20
    8000439a:	95ea                	add	a1,a1,s10
    8000439c:	855e                	mv	a0,s7
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	244080e7          	jalr	580(ra) # 800005e2 <walkaddr>
    800043a6:	862a                	mv	a2,a0
    if(pa == 0)
    800043a8:	d955                	beqz	a0,8000435c <exec+0xf0>
      n = PGSIZE;
    800043aa:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043ac:	fd9a70e3          	bgeu	s4,s9,8000436c <exec+0x100>
      n = sz - i;
    800043b0:	8ad2                	mv	s5,s4
    800043b2:	bf6d                	j	8000436c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b4:	4a01                	li	s4,0
  iunlockput(ip);
    800043b6:	8526                	mv	a0,s1
    800043b8:	fffff097          	auipc	ra,0xfffff
    800043bc:	c00080e7          	jalr	-1024(ra) # 80002fb8 <iunlockput>
  end_op();
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	3d8080e7          	jalr	984(ra) # 80003798 <end_op>
  p = myproc();
    800043c8:	ffffd097          	auipc	ra,0xffffd
    800043cc:	c2e080e7          	jalr	-978(ra) # 80000ff6 <myproc>
    800043d0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043d2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043d6:	6785                	lui	a5,0x1
    800043d8:	17fd                	addi	a5,a5,-1
    800043da:	9a3e                	add	s4,s4,a5
    800043dc:	757d                	lui	a0,0xfffff
    800043de:	00aa77b3          	and	a5,s4,a0
    800043e2:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043e6:	4691                	li	a3,4
    800043e8:	6609                	lui	a2,0x2
    800043ea:	963e                	add	a2,a2,a5
    800043ec:	85be                	mv	a1,a5
    800043ee:	855e                	mv	a0,s7
    800043f0:	ffffc097          	auipc	ra,0xffffc
    800043f4:	5ca080e7          	jalr	1482(ra) # 800009ba <uvmalloc>
    800043f8:	8b2a                	mv	s6,a0
  ip = 0;
    800043fa:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043fc:	12050c63          	beqz	a0,80004534 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004400:	75f9                	lui	a1,0xffffe
    80004402:	95aa                	add	a1,a1,a0
    80004404:	855e                	mv	a0,s7
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	7d8080e7          	jalr	2008(ra) # 80000bde <uvmclear>
  stackbase = sp - PGSIZE;
    8000440e:	7c7d                	lui	s8,0xfffff
    80004410:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004412:	e0043783          	ld	a5,-512(s0)
    80004416:	6388                	ld	a0,0(a5)
    80004418:	c535                	beqz	a0,80004484 <exec+0x218>
    8000441a:	e9040993          	addi	s3,s0,-368
    8000441e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004422:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	fb0080e7          	jalr	-80(ra) # 800003d4 <strlen>
    8000442c:	2505                	addiw	a0,a0,1
    8000442e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004432:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004436:	13896663          	bltu	s2,s8,80004562 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000443a:	e0043d83          	ld	s11,-512(s0)
    8000443e:	000dba03          	ld	s4,0(s11)
    80004442:	8552                	mv	a0,s4
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	f90080e7          	jalr	-112(ra) # 800003d4 <strlen>
    8000444c:	0015069b          	addiw	a3,a0,1
    80004450:	8652                	mv	a2,s4
    80004452:	85ca                	mv	a1,s2
    80004454:	855e                	mv	a0,s7
    80004456:	ffffc097          	auipc	ra,0xffffc
    8000445a:	7ba080e7          	jalr	1978(ra) # 80000c10 <copyout>
    8000445e:	10054663          	bltz	a0,8000456a <exec+0x2fe>
    ustack[argc] = sp;
    80004462:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004466:	0485                	addi	s1,s1,1
    80004468:	008d8793          	addi	a5,s11,8
    8000446c:	e0f43023          	sd	a5,-512(s0)
    80004470:	008db503          	ld	a0,8(s11)
    80004474:	c911                	beqz	a0,80004488 <exec+0x21c>
    if(argc >= MAXARG)
    80004476:	09a1                	addi	s3,s3,8
    80004478:	fb3c96e3          	bne	s9,s3,80004424 <exec+0x1b8>
  sz = sz1;
    8000447c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004480:	4481                	li	s1,0
    80004482:	a84d                	j	80004534 <exec+0x2c8>
  sp = sz;
    80004484:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004486:	4481                	li	s1,0
  ustack[argc] = 0;
    80004488:	00349793          	slli	a5,s1,0x3
    8000448c:	f9040713          	addi	a4,s0,-112
    80004490:	97ba                	add	a5,a5,a4
    80004492:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004496:	00148693          	addi	a3,s1,1
    8000449a:	068e                	slli	a3,a3,0x3
    8000449c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044a0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044a4:	01897663          	bgeu	s2,s8,800044b0 <exec+0x244>
  sz = sz1;
    800044a8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ac:	4481                	li	s1,0
    800044ae:	a059                	j	80004534 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044b0:	e9040613          	addi	a2,s0,-368
    800044b4:	85ca                	mv	a1,s2
    800044b6:	855e                	mv	a0,s7
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	758080e7          	jalr	1880(ra) # 80000c10 <copyout>
    800044c0:	0a054963          	bltz	a0,80004572 <exec+0x306>
  p->trapframe->a1 = sp;
    800044c4:	058ab783          	ld	a5,88(s5)
    800044c8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044cc:	df843783          	ld	a5,-520(s0)
    800044d0:	0007c703          	lbu	a4,0(a5)
    800044d4:	cf11                	beqz	a4,800044f0 <exec+0x284>
    800044d6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044d8:	02f00693          	li	a3,47
    800044dc:	a039                	j	800044ea <exec+0x27e>
      last = s+1;
    800044de:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044e2:	0785                	addi	a5,a5,1
    800044e4:	fff7c703          	lbu	a4,-1(a5)
    800044e8:	c701                	beqz	a4,800044f0 <exec+0x284>
    if(*s == '/')
    800044ea:	fed71ce3          	bne	a4,a3,800044e2 <exec+0x276>
    800044ee:	bfc5                	j	800044de <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800044f0:	4641                	li	a2,16
    800044f2:	df843583          	ld	a1,-520(s0)
    800044f6:	158a8513          	addi	a0,s5,344
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	ea8080e7          	jalr	-344(ra) # 800003a2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004502:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004506:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000450a:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000450e:	058ab783          	ld	a5,88(s5)
    80004512:	e6843703          	ld	a4,-408(s0)
    80004516:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004518:	058ab783          	ld	a5,88(s5)
    8000451c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004520:	85ea                	mv	a1,s10
    80004522:	ffffd097          	auipc	ra,0xffffd
    80004526:	c38080e7          	jalr	-968(ra) # 8000115a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000452a:	0004851b          	sext.w	a0,s1
    8000452e:	bbd9                	j	80004304 <exec+0x98>
    80004530:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004534:	e0843583          	ld	a1,-504(s0)
    80004538:	855e                	mv	a0,s7
    8000453a:	ffffd097          	auipc	ra,0xffffd
    8000453e:	c20080e7          	jalr	-992(ra) # 8000115a <proc_freepagetable>
  if(ip){
    80004542:	da0497e3          	bnez	s1,800042f0 <exec+0x84>
  return -1;
    80004546:	557d                	li	a0,-1
    80004548:	bb75                	j	80004304 <exec+0x98>
    8000454a:	e1443423          	sd	s4,-504(s0)
    8000454e:	b7dd                	j	80004534 <exec+0x2c8>
    80004550:	e1443423          	sd	s4,-504(s0)
    80004554:	b7c5                	j	80004534 <exec+0x2c8>
    80004556:	e1443423          	sd	s4,-504(s0)
    8000455a:	bfe9                	j	80004534 <exec+0x2c8>
    8000455c:	e1443423          	sd	s4,-504(s0)
    80004560:	bfd1                	j	80004534 <exec+0x2c8>
  sz = sz1;
    80004562:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004566:	4481                	li	s1,0
    80004568:	b7f1                	j	80004534 <exec+0x2c8>
  sz = sz1;
    8000456a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000456e:	4481                	li	s1,0
    80004570:	b7d1                	j	80004534 <exec+0x2c8>
  sz = sz1;
    80004572:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004576:	4481                	li	s1,0
    80004578:	bf75                	j	80004534 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000457a:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000457e:	2b05                	addiw	s6,s6,1
    80004580:	0389899b          	addiw	s3,s3,56
    80004584:	e8845783          	lhu	a5,-376(s0)
    80004588:	e2fb57e3          	bge	s6,a5,800043b6 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000458c:	2981                	sext.w	s3,s3
    8000458e:	03800713          	li	a4,56
    80004592:	86ce                	mv	a3,s3
    80004594:	e1840613          	addi	a2,s0,-488
    80004598:	4581                	li	a1,0
    8000459a:	8526                	mv	a0,s1
    8000459c:	fffff097          	auipc	ra,0xfffff
    800045a0:	a6e080e7          	jalr	-1426(ra) # 8000300a <readi>
    800045a4:	03800793          	li	a5,56
    800045a8:	f8f514e3          	bne	a0,a5,80004530 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800045ac:	e1842783          	lw	a5,-488(s0)
    800045b0:	4705                	li	a4,1
    800045b2:	fce796e3          	bne	a5,a4,8000457e <exec+0x312>
    if(ph.memsz < ph.filesz)
    800045b6:	e4043903          	ld	s2,-448(s0)
    800045ba:	e3843783          	ld	a5,-456(s0)
    800045be:	f8f966e3          	bltu	s2,a5,8000454a <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045c2:	e2843783          	ld	a5,-472(s0)
    800045c6:	993e                	add	s2,s2,a5
    800045c8:	f8f964e3          	bltu	s2,a5,80004550 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800045cc:	df043703          	ld	a4,-528(s0)
    800045d0:	8ff9                	and	a5,a5,a4
    800045d2:	f3d1                	bnez	a5,80004556 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045d4:	e1c42503          	lw	a0,-484(s0)
    800045d8:	00000097          	auipc	ra,0x0
    800045dc:	c78080e7          	jalr	-904(ra) # 80004250 <flags2perm>
    800045e0:	86aa                	mv	a3,a0
    800045e2:	864a                	mv	a2,s2
    800045e4:	85d2                	mv	a1,s4
    800045e6:	855e                	mv	a0,s7
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	3d2080e7          	jalr	978(ra) # 800009ba <uvmalloc>
    800045f0:	e0a43423          	sd	a0,-504(s0)
    800045f4:	d525                	beqz	a0,8000455c <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045f6:	e2843d03          	ld	s10,-472(s0)
    800045fa:	e2042d83          	lw	s11,-480(s0)
    800045fe:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004602:	f60c0ce3          	beqz	s8,8000457a <exec+0x30e>
    80004606:	8a62                	mv	s4,s8
    80004608:	4901                	li	s2,0
    8000460a:	b369                	j	80004394 <exec+0x128>

000000008000460c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000460c:	7179                	addi	sp,sp,-48
    8000460e:	f406                	sd	ra,40(sp)
    80004610:	f022                	sd	s0,32(sp)
    80004612:	ec26                	sd	s1,24(sp)
    80004614:	e84a                	sd	s2,16(sp)
    80004616:	1800                	addi	s0,sp,48
    80004618:	892e                	mv	s2,a1
    8000461a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000461c:	fdc40593          	addi	a1,s0,-36
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	bbc080e7          	jalr	-1092(ra) # 800021dc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004628:	fdc42703          	lw	a4,-36(s0)
    8000462c:	47bd                	li	a5,15
    8000462e:	02e7eb63          	bltu	a5,a4,80004664 <argfd+0x58>
    80004632:	ffffd097          	auipc	ra,0xffffd
    80004636:	9c4080e7          	jalr	-1596(ra) # 80000ff6 <myproc>
    8000463a:	fdc42703          	lw	a4,-36(s0)
    8000463e:	01a70793          	addi	a5,a4,26
    80004642:	078e                	slli	a5,a5,0x3
    80004644:	953e                	add	a0,a0,a5
    80004646:	611c                	ld	a5,0(a0)
    80004648:	c385                	beqz	a5,80004668 <argfd+0x5c>
    return -1;
  if(pfd)
    8000464a:	00090463          	beqz	s2,80004652 <argfd+0x46>
    *pfd = fd;
    8000464e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004652:	4501                	li	a0,0
  if(pf)
    80004654:	c091                	beqz	s1,80004658 <argfd+0x4c>
    *pf = f;
    80004656:	e09c                	sd	a5,0(s1)
}
    80004658:	70a2                	ld	ra,40(sp)
    8000465a:	7402                	ld	s0,32(sp)
    8000465c:	64e2                	ld	s1,24(sp)
    8000465e:	6942                	ld	s2,16(sp)
    80004660:	6145                	addi	sp,sp,48
    80004662:	8082                	ret
    return -1;
    80004664:	557d                	li	a0,-1
    80004666:	bfcd                	j	80004658 <argfd+0x4c>
    80004668:	557d                	li	a0,-1
    8000466a:	b7fd                	j	80004658 <argfd+0x4c>

000000008000466c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000466c:	1101                	addi	sp,sp,-32
    8000466e:	ec06                	sd	ra,24(sp)
    80004670:	e822                	sd	s0,16(sp)
    80004672:	e426                	sd	s1,8(sp)
    80004674:	1000                	addi	s0,sp,32
    80004676:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004678:	ffffd097          	auipc	ra,0xffffd
    8000467c:	97e080e7          	jalr	-1666(ra) # 80000ff6 <myproc>
    80004680:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004682:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdbd320>
    80004686:	4501                	li	a0,0
    80004688:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000468a:	6398                	ld	a4,0(a5)
    8000468c:	cb19                	beqz	a4,800046a2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000468e:	2505                	addiw	a0,a0,1
    80004690:	07a1                	addi	a5,a5,8
    80004692:	fed51ce3          	bne	a0,a3,8000468a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004696:	557d                	li	a0,-1
}
    80004698:	60e2                	ld	ra,24(sp)
    8000469a:	6442                	ld	s0,16(sp)
    8000469c:	64a2                	ld	s1,8(sp)
    8000469e:	6105                	addi	sp,sp,32
    800046a0:	8082                	ret
      p->ofile[fd] = f;
    800046a2:	01a50793          	addi	a5,a0,26
    800046a6:	078e                	slli	a5,a5,0x3
    800046a8:	963e                	add	a2,a2,a5
    800046aa:	e204                	sd	s1,0(a2)
      return fd;
    800046ac:	b7f5                	j	80004698 <fdalloc+0x2c>

00000000800046ae <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ae:	715d                	addi	sp,sp,-80
    800046b0:	e486                	sd	ra,72(sp)
    800046b2:	e0a2                	sd	s0,64(sp)
    800046b4:	fc26                	sd	s1,56(sp)
    800046b6:	f84a                	sd	s2,48(sp)
    800046b8:	f44e                	sd	s3,40(sp)
    800046ba:	f052                	sd	s4,32(sp)
    800046bc:	ec56                	sd	s5,24(sp)
    800046be:	e85a                	sd	s6,16(sp)
    800046c0:	0880                	addi	s0,sp,80
    800046c2:	8b2e                	mv	s6,a1
    800046c4:	89b2                	mv	s3,a2
    800046c6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046c8:	fb040593          	addi	a1,s0,-80
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	e4e080e7          	jalr	-434(ra) # 8000351a <nameiparent>
    800046d4:	84aa                	mv	s1,a0
    800046d6:	16050063          	beqz	a0,80004836 <create+0x188>
    return 0;

  ilock(dp);
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	67c080e7          	jalr	1660(ra) # 80002d56 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046e2:	4601                	li	a2,0
    800046e4:	fb040593          	addi	a1,s0,-80
    800046e8:	8526                	mv	a0,s1
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	b50080e7          	jalr	-1200(ra) # 8000323a <dirlookup>
    800046f2:	8aaa                	mv	s5,a0
    800046f4:	c931                	beqz	a0,80004748 <create+0x9a>
    iunlockput(dp);
    800046f6:	8526                	mv	a0,s1
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	8c0080e7          	jalr	-1856(ra) # 80002fb8 <iunlockput>
    ilock(ip);
    80004700:	8556                	mv	a0,s5
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	654080e7          	jalr	1620(ra) # 80002d56 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000470a:	000b059b          	sext.w	a1,s6
    8000470e:	4789                	li	a5,2
    80004710:	02f59563          	bne	a1,a5,8000473a <create+0x8c>
    80004714:	044ad783          	lhu	a5,68(s5)
    80004718:	37f9                	addiw	a5,a5,-2
    8000471a:	17c2                	slli	a5,a5,0x30
    8000471c:	93c1                	srli	a5,a5,0x30
    8000471e:	4705                	li	a4,1
    80004720:	00f76d63          	bltu	a4,a5,8000473a <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004724:	8556                	mv	a0,s5
    80004726:	60a6                	ld	ra,72(sp)
    80004728:	6406                	ld	s0,64(sp)
    8000472a:	74e2                	ld	s1,56(sp)
    8000472c:	7942                	ld	s2,48(sp)
    8000472e:	79a2                	ld	s3,40(sp)
    80004730:	7a02                	ld	s4,32(sp)
    80004732:	6ae2                	ld	s5,24(sp)
    80004734:	6b42                	ld	s6,16(sp)
    80004736:	6161                	addi	sp,sp,80
    80004738:	8082                	ret
    iunlockput(ip);
    8000473a:	8556                	mv	a0,s5
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	87c080e7          	jalr	-1924(ra) # 80002fb8 <iunlockput>
    return 0;
    80004744:	4a81                	li	s5,0
    80004746:	bff9                	j	80004724 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004748:	85da                	mv	a1,s6
    8000474a:	4088                	lw	a0,0(s1)
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	46e080e7          	jalr	1134(ra) # 80002bba <ialloc>
    80004754:	8a2a                	mv	s4,a0
    80004756:	c921                	beqz	a0,800047a6 <create+0xf8>
  ilock(ip);
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	5fe080e7          	jalr	1534(ra) # 80002d56 <ilock>
  ip->major = major;
    80004760:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004764:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004768:	4785                	li	a5,1
    8000476a:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    8000476e:	8552                	mv	a0,s4
    80004770:	ffffe097          	auipc	ra,0xffffe
    80004774:	51c080e7          	jalr	1308(ra) # 80002c8c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004778:	000b059b          	sext.w	a1,s6
    8000477c:	4785                	li	a5,1
    8000477e:	02f58b63          	beq	a1,a5,800047b4 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004782:	004a2603          	lw	a2,4(s4)
    80004786:	fb040593          	addi	a1,s0,-80
    8000478a:	8526                	mv	a0,s1
    8000478c:	fffff097          	auipc	ra,0xfffff
    80004790:	cbe080e7          	jalr	-834(ra) # 8000344a <dirlink>
    80004794:	06054f63          	bltz	a0,80004812 <create+0x164>
  iunlockput(dp);
    80004798:	8526                	mv	a0,s1
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	81e080e7          	jalr	-2018(ra) # 80002fb8 <iunlockput>
  return ip;
    800047a2:	8ad2                	mv	s5,s4
    800047a4:	b741                	j	80004724 <create+0x76>
    iunlockput(dp);
    800047a6:	8526                	mv	a0,s1
    800047a8:	fffff097          	auipc	ra,0xfffff
    800047ac:	810080e7          	jalr	-2032(ra) # 80002fb8 <iunlockput>
    return 0;
    800047b0:	8ad2                	mv	s5,s4
    800047b2:	bf8d                	j	80004724 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047b4:	004a2603          	lw	a2,4(s4)
    800047b8:	00004597          	auipc	a1,0x4
    800047bc:	f1058593          	addi	a1,a1,-240 # 800086c8 <syscalls+0x2a0>
    800047c0:	8552                	mv	a0,s4
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	c88080e7          	jalr	-888(ra) # 8000344a <dirlink>
    800047ca:	04054463          	bltz	a0,80004812 <create+0x164>
    800047ce:	40d0                	lw	a2,4(s1)
    800047d0:	00004597          	auipc	a1,0x4
    800047d4:	f0058593          	addi	a1,a1,-256 # 800086d0 <syscalls+0x2a8>
    800047d8:	8552                	mv	a0,s4
    800047da:	fffff097          	auipc	ra,0xfffff
    800047de:	c70080e7          	jalr	-912(ra) # 8000344a <dirlink>
    800047e2:	02054863          	bltz	a0,80004812 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800047e6:	004a2603          	lw	a2,4(s4)
    800047ea:	fb040593          	addi	a1,s0,-80
    800047ee:	8526                	mv	a0,s1
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	c5a080e7          	jalr	-934(ra) # 8000344a <dirlink>
    800047f8:	00054d63          	bltz	a0,80004812 <create+0x164>
    dp->nlink++;  // for ".."
    800047fc:	04a4d783          	lhu	a5,74(s1)
    80004800:	2785                	addiw	a5,a5,1
    80004802:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004806:	8526                	mv	a0,s1
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	484080e7          	jalr	1156(ra) # 80002c8c <iupdate>
    80004810:	b761                	j	80004798 <create+0xea>
  ip->nlink = 0;
    80004812:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004816:	8552                	mv	a0,s4
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	474080e7          	jalr	1140(ra) # 80002c8c <iupdate>
  iunlockput(ip);
    80004820:	8552                	mv	a0,s4
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	796080e7          	jalr	1942(ra) # 80002fb8 <iunlockput>
  iunlockput(dp);
    8000482a:	8526                	mv	a0,s1
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	78c080e7          	jalr	1932(ra) # 80002fb8 <iunlockput>
  return 0;
    80004834:	bdc5                	j	80004724 <create+0x76>
    return 0;
    80004836:	8aaa                	mv	s5,a0
    80004838:	b5f5                	j	80004724 <create+0x76>

000000008000483a <sys_dup>:
{
    8000483a:	7179                	addi	sp,sp,-48
    8000483c:	f406                	sd	ra,40(sp)
    8000483e:	f022                	sd	s0,32(sp)
    80004840:	ec26                	sd	s1,24(sp)
    80004842:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004844:	fd840613          	addi	a2,s0,-40
    80004848:	4581                	li	a1,0
    8000484a:	4501                	li	a0,0
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	dc0080e7          	jalr	-576(ra) # 8000460c <argfd>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004856:	02054363          	bltz	a0,8000487c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000485a:	fd843503          	ld	a0,-40(s0)
    8000485e:	00000097          	auipc	ra,0x0
    80004862:	e0e080e7          	jalr	-498(ra) # 8000466c <fdalloc>
    80004866:	84aa                	mv	s1,a0
    return -1;
    80004868:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000486a:	00054963          	bltz	a0,8000487c <sys_dup+0x42>
  filedup(f);
    8000486e:	fd843503          	ld	a0,-40(s0)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	320080e7          	jalr	800(ra) # 80003b92 <filedup>
  return fd;
    8000487a:	87a6                	mv	a5,s1
}
    8000487c:	853e                	mv	a0,a5
    8000487e:	70a2                	ld	ra,40(sp)
    80004880:	7402                	ld	s0,32(sp)
    80004882:	64e2                	ld	s1,24(sp)
    80004884:	6145                	addi	sp,sp,48
    80004886:	8082                	ret

0000000080004888 <sys_read>:
{
    80004888:	7179                	addi	sp,sp,-48
    8000488a:	f406                	sd	ra,40(sp)
    8000488c:	f022                	sd	s0,32(sp)
    8000488e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004890:	fd840593          	addi	a1,s0,-40
    80004894:	4505                	li	a0,1
    80004896:	ffffe097          	auipc	ra,0xffffe
    8000489a:	966080e7          	jalr	-1690(ra) # 800021fc <argaddr>
  argint(2, &n);
    8000489e:	fe440593          	addi	a1,s0,-28
    800048a2:	4509                	li	a0,2
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	938080e7          	jalr	-1736(ra) # 800021dc <argint>
  if(argfd(0, 0, &f) < 0)
    800048ac:	fe840613          	addi	a2,s0,-24
    800048b0:	4581                	li	a1,0
    800048b2:	4501                	li	a0,0
    800048b4:	00000097          	auipc	ra,0x0
    800048b8:	d58080e7          	jalr	-680(ra) # 8000460c <argfd>
    800048bc:	87aa                	mv	a5,a0
    return -1;
    800048be:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048c0:	0007cc63          	bltz	a5,800048d8 <sys_read+0x50>
  return fileread(f, p, n);
    800048c4:	fe442603          	lw	a2,-28(s0)
    800048c8:	fd843583          	ld	a1,-40(s0)
    800048cc:	fe843503          	ld	a0,-24(s0)
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	44e080e7          	jalr	1102(ra) # 80003d1e <fileread>
}
    800048d8:	70a2                	ld	ra,40(sp)
    800048da:	7402                	ld	s0,32(sp)
    800048dc:	6145                	addi	sp,sp,48
    800048de:	8082                	ret

00000000800048e0 <sys_write>:
{
    800048e0:	7179                	addi	sp,sp,-48
    800048e2:	f406                	sd	ra,40(sp)
    800048e4:	f022                	sd	s0,32(sp)
    800048e6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048e8:	fd840593          	addi	a1,s0,-40
    800048ec:	4505                	li	a0,1
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	90e080e7          	jalr	-1778(ra) # 800021fc <argaddr>
  argint(2, &n);
    800048f6:	fe440593          	addi	a1,s0,-28
    800048fa:	4509                	li	a0,2
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	8e0080e7          	jalr	-1824(ra) # 800021dc <argint>
  if(argfd(0, 0, &f) < 0)
    80004904:	fe840613          	addi	a2,s0,-24
    80004908:	4581                	li	a1,0
    8000490a:	4501                	li	a0,0
    8000490c:	00000097          	auipc	ra,0x0
    80004910:	d00080e7          	jalr	-768(ra) # 8000460c <argfd>
    80004914:	87aa                	mv	a5,a0
    return -1;
    80004916:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004918:	0007cc63          	bltz	a5,80004930 <sys_write+0x50>
  return filewrite(f, p, n);
    8000491c:	fe442603          	lw	a2,-28(s0)
    80004920:	fd843583          	ld	a1,-40(s0)
    80004924:	fe843503          	ld	a0,-24(s0)
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	4b8080e7          	jalr	1208(ra) # 80003de0 <filewrite>
}
    80004930:	70a2                	ld	ra,40(sp)
    80004932:	7402                	ld	s0,32(sp)
    80004934:	6145                	addi	sp,sp,48
    80004936:	8082                	ret

0000000080004938 <sys_close>:
{
    80004938:	1101                	addi	sp,sp,-32
    8000493a:	ec06                	sd	ra,24(sp)
    8000493c:	e822                	sd	s0,16(sp)
    8000493e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004940:	fe040613          	addi	a2,s0,-32
    80004944:	fec40593          	addi	a1,s0,-20
    80004948:	4501                	li	a0,0
    8000494a:	00000097          	auipc	ra,0x0
    8000494e:	cc2080e7          	jalr	-830(ra) # 8000460c <argfd>
    return -1;
    80004952:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004954:	02054463          	bltz	a0,8000497c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004958:	ffffc097          	auipc	ra,0xffffc
    8000495c:	69e080e7          	jalr	1694(ra) # 80000ff6 <myproc>
    80004960:	fec42783          	lw	a5,-20(s0)
    80004964:	07e9                	addi	a5,a5,26
    80004966:	078e                	slli	a5,a5,0x3
    80004968:	97aa                	add	a5,a5,a0
    8000496a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000496e:	fe043503          	ld	a0,-32(s0)
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	272080e7          	jalr	626(ra) # 80003be4 <fileclose>
  return 0;
    8000497a:	4781                	li	a5,0
}
    8000497c:	853e                	mv	a0,a5
    8000497e:	60e2                	ld	ra,24(sp)
    80004980:	6442                	ld	s0,16(sp)
    80004982:	6105                	addi	sp,sp,32
    80004984:	8082                	ret

0000000080004986 <sys_fstat>:
{
    80004986:	1101                	addi	sp,sp,-32
    80004988:	ec06                	sd	ra,24(sp)
    8000498a:	e822                	sd	s0,16(sp)
    8000498c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000498e:	fe040593          	addi	a1,s0,-32
    80004992:	4505                	li	a0,1
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	868080e7          	jalr	-1944(ra) # 800021fc <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000499c:	fe840613          	addi	a2,s0,-24
    800049a0:	4581                	li	a1,0
    800049a2:	4501                	li	a0,0
    800049a4:	00000097          	auipc	ra,0x0
    800049a8:	c68080e7          	jalr	-920(ra) # 8000460c <argfd>
    800049ac:	87aa                	mv	a5,a0
    return -1;
    800049ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049b0:	0007ca63          	bltz	a5,800049c4 <sys_fstat+0x3e>
  return filestat(f, st);
    800049b4:	fe043583          	ld	a1,-32(s0)
    800049b8:	fe843503          	ld	a0,-24(s0)
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	2f0080e7          	jalr	752(ra) # 80003cac <filestat>
}
    800049c4:	60e2                	ld	ra,24(sp)
    800049c6:	6442                	ld	s0,16(sp)
    800049c8:	6105                	addi	sp,sp,32
    800049ca:	8082                	ret

00000000800049cc <sys_link>:
{
    800049cc:	7169                	addi	sp,sp,-304
    800049ce:	f606                	sd	ra,296(sp)
    800049d0:	f222                	sd	s0,288(sp)
    800049d2:	ee26                	sd	s1,280(sp)
    800049d4:	ea4a                	sd	s2,272(sp)
    800049d6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d8:	08000613          	li	a2,128
    800049dc:	ed040593          	addi	a1,s0,-304
    800049e0:	4501                	li	a0,0
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	83a080e7          	jalr	-1990(ra) # 8000221c <argstr>
    return -1;
    800049ea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ec:	10054e63          	bltz	a0,80004b08 <sys_link+0x13c>
    800049f0:	08000613          	li	a2,128
    800049f4:	f5040593          	addi	a1,s0,-176
    800049f8:	4505                	li	a0,1
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	822080e7          	jalr	-2014(ra) # 8000221c <argstr>
    return -1;
    80004a02:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a04:	10054263          	bltz	a0,80004b08 <sys_link+0x13c>
  begin_op();
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	d10080e7          	jalr	-752(ra) # 80003718 <begin_op>
  if((ip = namei(old)) == 0){
    80004a10:	ed040513          	addi	a0,s0,-304
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	ae8080e7          	jalr	-1304(ra) # 800034fc <namei>
    80004a1c:	84aa                	mv	s1,a0
    80004a1e:	c551                	beqz	a0,80004aaa <sys_link+0xde>
  ilock(ip);
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	336080e7          	jalr	822(ra) # 80002d56 <ilock>
  if(ip->type == T_DIR){
    80004a28:	04449703          	lh	a4,68(s1)
    80004a2c:	4785                	li	a5,1
    80004a2e:	08f70463          	beq	a4,a5,80004ab6 <sys_link+0xea>
  ip->nlink++;
    80004a32:	04a4d783          	lhu	a5,74(s1)
    80004a36:	2785                	addiw	a5,a5,1
    80004a38:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a3c:	8526                	mv	a0,s1
    80004a3e:	ffffe097          	auipc	ra,0xffffe
    80004a42:	24e080e7          	jalr	590(ra) # 80002c8c <iupdate>
  iunlock(ip);
    80004a46:	8526                	mv	a0,s1
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	3d0080e7          	jalr	976(ra) # 80002e18 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a50:	fd040593          	addi	a1,s0,-48
    80004a54:	f5040513          	addi	a0,s0,-176
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	ac2080e7          	jalr	-1342(ra) # 8000351a <nameiparent>
    80004a60:	892a                	mv	s2,a0
    80004a62:	c935                	beqz	a0,80004ad6 <sys_link+0x10a>
  ilock(dp);
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	2f2080e7          	jalr	754(ra) # 80002d56 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a6c:	00092703          	lw	a4,0(s2)
    80004a70:	409c                	lw	a5,0(s1)
    80004a72:	04f71d63          	bne	a4,a5,80004acc <sys_link+0x100>
    80004a76:	40d0                	lw	a2,4(s1)
    80004a78:	fd040593          	addi	a1,s0,-48
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	9cc080e7          	jalr	-1588(ra) # 8000344a <dirlink>
    80004a86:	04054363          	bltz	a0,80004acc <sys_link+0x100>
  iunlockput(dp);
    80004a8a:	854a                	mv	a0,s2
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	52c080e7          	jalr	1324(ra) # 80002fb8 <iunlockput>
  iput(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	47a080e7          	jalr	1146(ra) # 80002f10 <iput>
  end_op();
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	cfa080e7          	jalr	-774(ra) # 80003798 <end_op>
  return 0;
    80004aa6:	4781                	li	a5,0
    80004aa8:	a085                	j	80004b08 <sys_link+0x13c>
    end_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	cee080e7          	jalr	-786(ra) # 80003798 <end_op>
    return -1;
    80004ab2:	57fd                	li	a5,-1
    80004ab4:	a891                	j	80004b08 <sys_link+0x13c>
    iunlockput(ip);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	500080e7          	jalr	1280(ra) # 80002fb8 <iunlockput>
    end_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	cd8080e7          	jalr	-808(ra) # 80003798 <end_op>
    return -1;
    80004ac8:	57fd                	li	a5,-1
    80004aca:	a83d                	j	80004b08 <sys_link+0x13c>
    iunlockput(dp);
    80004acc:	854a                	mv	a0,s2
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	4ea080e7          	jalr	1258(ra) # 80002fb8 <iunlockput>
  ilock(ip);
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	27e080e7          	jalr	638(ra) # 80002d56 <ilock>
  ip->nlink--;
    80004ae0:	04a4d783          	lhu	a5,74(s1)
    80004ae4:	37fd                	addiw	a5,a5,-1
    80004ae6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	1a0080e7          	jalr	416(ra) # 80002c8c <iupdate>
  iunlockput(ip);
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	4c2080e7          	jalr	1218(ra) # 80002fb8 <iunlockput>
  end_op();
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	c9a080e7          	jalr	-870(ra) # 80003798 <end_op>
  return -1;
    80004b06:	57fd                	li	a5,-1
}
    80004b08:	853e                	mv	a0,a5
    80004b0a:	70b2                	ld	ra,296(sp)
    80004b0c:	7412                	ld	s0,288(sp)
    80004b0e:	64f2                	ld	s1,280(sp)
    80004b10:	6952                	ld	s2,272(sp)
    80004b12:	6155                	addi	sp,sp,304
    80004b14:	8082                	ret

0000000080004b16 <sys_unlink>:
{
    80004b16:	7151                	addi	sp,sp,-240
    80004b18:	f586                	sd	ra,232(sp)
    80004b1a:	f1a2                	sd	s0,224(sp)
    80004b1c:	eda6                	sd	s1,216(sp)
    80004b1e:	e9ca                	sd	s2,208(sp)
    80004b20:	e5ce                	sd	s3,200(sp)
    80004b22:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b24:	08000613          	li	a2,128
    80004b28:	f3040593          	addi	a1,s0,-208
    80004b2c:	4501                	li	a0,0
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	6ee080e7          	jalr	1774(ra) # 8000221c <argstr>
    80004b36:	18054163          	bltz	a0,80004cb8 <sys_unlink+0x1a2>
  begin_op();
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	bde080e7          	jalr	-1058(ra) # 80003718 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b42:	fb040593          	addi	a1,s0,-80
    80004b46:	f3040513          	addi	a0,s0,-208
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	9d0080e7          	jalr	-1584(ra) # 8000351a <nameiparent>
    80004b52:	84aa                	mv	s1,a0
    80004b54:	c979                	beqz	a0,80004c2a <sys_unlink+0x114>
  ilock(dp);
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	200080e7          	jalr	512(ra) # 80002d56 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b5e:	00004597          	auipc	a1,0x4
    80004b62:	b6a58593          	addi	a1,a1,-1174 # 800086c8 <syscalls+0x2a0>
    80004b66:	fb040513          	addi	a0,s0,-80
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	6b6080e7          	jalr	1718(ra) # 80003220 <namecmp>
    80004b72:	14050a63          	beqz	a0,80004cc6 <sys_unlink+0x1b0>
    80004b76:	00004597          	auipc	a1,0x4
    80004b7a:	b5a58593          	addi	a1,a1,-1190 # 800086d0 <syscalls+0x2a8>
    80004b7e:	fb040513          	addi	a0,s0,-80
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	69e080e7          	jalr	1694(ra) # 80003220 <namecmp>
    80004b8a:	12050e63          	beqz	a0,80004cc6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b8e:	f2c40613          	addi	a2,s0,-212
    80004b92:	fb040593          	addi	a1,s0,-80
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	6a2080e7          	jalr	1698(ra) # 8000323a <dirlookup>
    80004ba0:	892a                	mv	s2,a0
    80004ba2:	12050263          	beqz	a0,80004cc6 <sys_unlink+0x1b0>
  ilock(ip);
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	1b0080e7          	jalr	432(ra) # 80002d56 <ilock>
  if(ip->nlink < 1)
    80004bae:	04a91783          	lh	a5,74(s2)
    80004bb2:	08f05263          	blez	a5,80004c36 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bb6:	04491703          	lh	a4,68(s2)
    80004bba:	4785                	li	a5,1
    80004bbc:	08f70563          	beq	a4,a5,80004c46 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bc0:	4641                	li	a2,16
    80004bc2:	4581                	li	a1,0
    80004bc4:	fc040513          	addi	a0,s0,-64
    80004bc8:	ffffb097          	auipc	ra,0xffffb
    80004bcc:	688080e7          	jalr	1672(ra) # 80000250 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bd0:	4741                	li	a4,16
    80004bd2:	f2c42683          	lw	a3,-212(s0)
    80004bd6:	fc040613          	addi	a2,s0,-64
    80004bda:	4581                	li	a1,0
    80004bdc:	8526                	mv	a0,s1
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	524080e7          	jalr	1316(ra) # 80003102 <writei>
    80004be6:	47c1                	li	a5,16
    80004be8:	0af51563          	bne	a0,a5,80004c92 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bec:	04491703          	lh	a4,68(s2)
    80004bf0:	4785                	li	a5,1
    80004bf2:	0af70863          	beq	a4,a5,80004ca2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	3c0080e7          	jalr	960(ra) # 80002fb8 <iunlockput>
  ip->nlink--;
    80004c00:	04a95783          	lhu	a5,74(s2)
    80004c04:	37fd                	addiw	a5,a5,-1
    80004c06:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	080080e7          	jalr	128(ra) # 80002c8c <iupdate>
  iunlockput(ip);
    80004c14:	854a                	mv	a0,s2
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	3a2080e7          	jalr	930(ra) # 80002fb8 <iunlockput>
  end_op();
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	b7a080e7          	jalr	-1158(ra) # 80003798 <end_op>
  return 0;
    80004c26:	4501                	li	a0,0
    80004c28:	a84d                	j	80004cda <sys_unlink+0x1c4>
    end_op();
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	b6e080e7          	jalr	-1170(ra) # 80003798 <end_op>
    return -1;
    80004c32:	557d                	li	a0,-1
    80004c34:	a05d                	j	80004cda <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c36:	00004517          	auipc	a0,0x4
    80004c3a:	aa250513          	addi	a0,a0,-1374 # 800086d8 <syscalls+0x2b0>
    80004c3e:	00001097          	auipc	ra,0x1
    80004c42:	214080e7          	jalr	532(ra) # 80005e52 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c46:	04c92703          	lw	a4,76(s2)
    80004c4a:	02000793          	li	a5,32
    80004c4e:	f6e7f9e3          	bgeu	a5,a4,80004bc0 <sys_unlink+0xaa>
    80004c52:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c56:	4741                	li	a4,16
    80004c58:	86ce                	mv	a3,s3
    80004c5a:	f1840613          	addi	a2,s0,-232
    80004c5e:	4581                	li	a1,0
    80004c60:	854a                	mv	a0,s2
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	3a8080e7          	jalr	936(ra) # 8000300a <readi>
    80004c6a:	47c1                	li	a5,16
    80004c6c:	00f51b63          	bne	a0,a5,80004c82 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c70:	f1845783          	lhu	a5,-232(s0)
    80004c74:	e7a1                	bnez	a5,80004cbc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c76:	29c1                	addiw	s3,s3,16
    80004c78:	04c92783          	lw	a5,76(s2)
    80004c7c:	fcf9ede3          	bltu	s3,a5,80004c56 <sys_unlink+0x140>
    80004c80:	b781                	j	80004bc0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c82:	00004517          	auipc	a0,0x4
    80004c86:	a6e50513          	addi	a0,a0,-1426 # 800086f0 <syscalls+0x2c8>
    80004c8a:	00001097          	auipc	ra,0x1
    80004c8e:	1c8080e7          	jalr	456(ra) # 80005e52 <panic>
    panic("unlink: writei");
    80004c92:	00004517          	auipc	a0,0x4
    80004c96:	a7650513          	addi	a0,a0,-1418 # 80008708 <syscalls+0x2e0>
    80004c9a:	00001097          	auipc	ra,0x1
    80004c9e:	1b8080e7          	jalr	440(ra) # 80005e52 <panic>
    dp->nlink--;
    80004ca2:	04a4d783          	lhu	a5,74(s1)
    80004ca6:	37fd                	addiw	a5,a5,-1
    80004ca8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cac:	8526                	mv	a0,s1
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	fde080e7          	jalr	-34(ra) # 80002c8c <iupdate>
    80004cb6:	b781                	j	80004bf6 <sys_unlink+0xe0>
    return -1;
    80004cb8:	557d                	li	a0,-1
    80004cba:	a005                	j	80004cda <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	2fa080e7          	jalr	762(ra) # 80002fb8 <iunlockput>
  iunlockput(dp);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	2f0080e7          	jalr	752(ra) # 80002fb8 <iunlockput>
  end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	ac8080e7          	jalr	-1336(ra) # 80003798 <end_op>
  return -1;
    80004cd8:	557d                	li	a0,-1
}
    80004cda:	70ae                	ld	ra,232(sp)
    80004cdc:	740e                	ld	s0,224(sp)
    80004cde:	64ee                	ld	s1,216(sp)
    80004ce0:	694e                	ld	s2,208(sp)
    80004ce2:	69ae                	ld	s3,200(sp)
    80004ce4:	616d                	addi	sp,sp,240
    80004ce6:	8082                	ret

0000000080004ce8 <sys_open>:

uint64
sys_open(void)
{
    80004ce8:	7131                	addi	sp,sp,-192
    80004cea:	fd06                	sd	ra,184(sp)
    80004cec:	f922                	sd	s0,176(sp)
    80004cee:	f526                	sd	s1,168(sp)
    80004cf0:	f14a                	sd	s2,160(sp)
    80004cf2:	ed4e                	sd	s3,152(sp)
    80004cf4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cf6:	f4c40593          	addi	a1,s0,-180
    80004cfa:	4505                	li	a0,1
    80004cfc:	ffffd097          	auipc	ra,0xffffd
    80004d00:	4e0080e7          	jalr	1248(ra) # 800021dc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d04:	08000613          	li	a2,128
    80004d08:	f5040593          	addi	a1,s0,-176
    80004d0c:	4501                	li	a0,0
    80004d0e:	ffffd097          	auipc	ra,0xffffd
    80004d12:	50e080e7          	jalr	1294(ra) # 8000221c <argstr>
    80004d16:	87aa                	mv	a5,a0
    return -1;
    80004d18:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d1a:	0a07c963          	bltz	a5,80004dcc <sys_open+0xe4>

  begin_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	9fa080e7          	jalr	-1542(ra) # 80003718 <begin_op>

  if(omode & O_CREATE){
    80004d26:	f4c42783          	lw	a5,-180(s0)
    80004d2a:	2007f793          	andi	a5,a5,512
    80004d2e:	cfc5                	beqz	a5,80004de6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d30:	4681                	li	a3,0
    80004d32:	4601                	li	a2,0
    80004d34:	4589                	li	a1,2
    80004d36:	f5040513          	addi	a0,s0,-176
    80004d3a:	00000097          	auipc	ra,0x0
    80004d3e:	974080e7          	jalr	-1676(ra) # 800046ae <create>
    80004d42:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d44:	c959                	beqz	a0,80004dda <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d46:	04449703          	lh	a4,68(s1)
    80004d4a:	478d                	li	a5,3
    80004d4c:	00f71763          	bne	a4,a5,80004d5a <sys_open+0x72>
    80004d50:	0464d703          	lhu	a4,70(s1)
    80004d54:	47a5                	li	a5,9
    80004d56:	0ce7ed63          	bltu	a5,a4,80004e30 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	dce080e7          	jalr	-562(ra) # 80003b28 <filealloc>
    80004d62:	89aa                	mv	s3,a0
    80004d64:	10050363          	beqz	a0,80004e6a <sys_open+0x182>
    80004d68:	00000097          	auipc	ra,0x0
    80004d6c:	904080e7          	jalr	-1788(ra) # 8000466c <fdalloc>
    80004d70:	892a                	mv	s2,a0
    80004d72:	0e054763          	bltz	a0,80004e60 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d76:	04449703          	lh	a4,68(s1)
    80004d7a:	478d                	li	a5,3
    80004d7c:	0cf70563          	beq	a4,a5,80004e46 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d80:	4789                	li	a5,2
    80004d82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d8a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d8e:	f4c42783          	lw	a5,-180(s0)
    80004d92:	0017c713          	xori	a4,a5,1
    80004d96:	8b05                	andi	a4,a4,1
    80004d98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d9c:	0037f713          	andi	a4,a5,3
    80004da0:	00e03733          	snez	a4,a4
    80004da4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004da8:	4007f793          	andi	a5,a5,1024
    80004dac:	c791                	beqz	a5,80004db8 <sys_open+0xd0>
    80004dae:	04449703          	lh	a4,68(s1)
    80004db2:	4789                	li	a5,2
    80004db4:	0af70063          	beq	a4,a5,80004e54 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004db8:	8526                	mv	a0,s1
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	05e080e7          	jalr	94(ra) # 80002e18 <iunlock>
  end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	9d6080e7          	jalr	-1578(ra) # 80003798 <end_op>

  return fd;
    80004dca:	854a                	mv	a0,s2
}
    80004dcc:	70ea                	ld	ra,184(sp)
    80004dce:	744a                	ld	s0,176(sp)
    80004dd0:	74aa                	ld	s1,168(sp)
    80004dd2:	790a                	ld	s2,160(sp)
    80004dd4:	69ea                	ld	s3,152(sp)
    80004dd6:	6129                	addi	sp,sp,192
    80004dd8:	8082                	ret
      end_op();
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	9be080e7          	jalr	-1602(ra) # 80003798 <end_op>
      return -1;
    80004de2:	557d                	li	a0,-1
    80004de4:	b7e5                	j	80004dcc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004de6:	f5040513          	addi	a0,s0,-176
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	712080e7          	jalr	1810(ra) # 800034fc <namei>
    80004df2:	84aa                	mv	s1,a0
    80004df4:	c905                	beqz	a0,80004e24 <sys_open+0x13c>
    ilock(ip);
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	f60080e7          	jalr	-160(ra) # 80002d56 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dfe:	04449703          	lh	a4,68(s1)
    80004e02:	4785                	li	a5,1
    80004e04:	f4f711e3          	bne	a4,a5,80004d46 <sys_open+0x5e>
    80004e08:	f4c42783          	lw	a5,-180(s0)
    80004e0c:	d7b9                	beqz	a5,80004d5a <sys_open+0x72>
      iunlockput(ip);
    80004e0e:	8526                	mv	a0,s1
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	1a8080e7          	jalr	424(ra) # 80002fb8 <iunlockput>
      end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	980080e7          	jalr	-1664(ra) # 80003798 <end_op>
      return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	b76d                	j	80004dcc <sys_open+0xe4>
      end_op();
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	974080e7          	jalr	-1676(ra) # 80003798 <end_op>
      return -1;
    80004e2c:	557d                	li	a0,-1
    80004e2e:	bf79                	j	80004dcc <sys_open+0xe4>
    iunlockput(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	186080e7          	jalr	390(ra) # 80002fb8 <iunlockput>
    end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	95e080e7          	jalr	-1698(ra) # 80003798 <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	b761                	j	80004dcc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e46:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e4a:	04649783          	lh	a5,70(s1)
    80004e4e:	02f99223          	sh	a5,36(s3)
    80004e52:	bf25                	j	80004d8a <sys_open+0xa2>
    itrunc(ip);
    80004e54:	8526                	mv	a0,s1
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	00e080e7          	jalr	14(ra) # 80002e64 <itrunc>
    80004e5e:	bfa9                	j	80004db8 <sys_open+0xd0>
      fileclose(f);
    80004e60:	854e                	mv	a0,s3
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	d82080e7          	jalr	-638(ra) # 80003be4 <fileclose>
    iunlockput(ip);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	14c080e7          	jalr	332(ra) # 80002fb8 <iunlockput>
    end_op();
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	924080e7          	jalr	-1756(ra) # 80003798 <end_op>
    return -1;
    80004e7c:	557d                	li	a0,-1
    80004e7e:	b7b9                	j	80004dcc <sys_open+0xe4>

0000000080004e80 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e80:	7175                	addi	sp,sp,-144
    80004e82:	e506                	sd	ra,136(sp)
    80004e84:	e122                	sd	s0,128(sp)
    80004e86:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	890080e7          	jalr	-1904(ra) # 80003718 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e90:	08000613          	li	a2,128
    80004e94:	f7040593          	addi	a1,s0,-144
    80004e98:	4501                	li	a0,0
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	382080e7          	jalr	898(ra) # 8000221c <argstr>
    80004ea2:	02054963          	bltz	a0,80004ed4 <sys_mkdir+0x54>
    80004ea6:	4681                	li	a3,0
    80004ea8:	4601                	li	a2,0
    80004eaa:	4585                	li	a1,1
    80004eac:	f7040513          	addi	a0,s0,-144
    80004eb0:	fffff097          	auipc	ra,0xfffff
    80004eb4:	7fe080e7          	jalr	2046(ra) # 800046ae <create>
    80004eb8:	cd11                	beqz	a0,80004ed4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	0fe080e7          	jalr	254(ra) # 80002fb8 <iunlockput>
  end_op();
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	8d6080e7          	jalr	-1834(ra) # 80003798 <end_op>
  return 0;
    80004eca:	4501                	li	a0,0
}
    80004ecc:	60aa                	ld	ra,136(sp)
    80004ece:	640a                	ld	s0,128(sp)
    80004ed0:	6149                	addi	sp,sp,144
    80004ed2:	8082                	ret
    end_op();
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	8c4080e7          	jalr	-1852(ra) # 80003798 <end_op>
    return -1;
    80004edc:	557d                	li	a0,-1
    80004ede:	b7fd                	j	80004ecc <sys_mkdir+0x4c>

0000000080004ee0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ee0:	7135                	addi	sp,sp,-160
    80004ee2:	ed06                	sd	ra,152(sp)
    80004ee4:	e922                	sd	s0,144(sp)
    80004ee6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	830080e7          	jalr	-2000(ra) # 80003718 <begin_op>
  argint(1, &major);
    80004ef0:	f6c40593          	addi	a1,s0,-148
    80004ef4:	4505                	li	a0,1
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	2e6080e7          	jalr	742(ra) # 800021dc <argint>
  argint(2, &minor);
    80004efe:	f6840593          	addi	a1,s0,-152
    80004f02:	4509                	li	a0,2
    80004f04:	ffffd097          	auipc	ra,0xffffd
    80004f08:	2d8080e7          	jalr	728(ra) # 800021dc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f0c:	08000613          	li	a2,128
    80004f10:	f7040593          	addi	a1,s0,-144
    80004f14:	4501                	li	a0,0
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	306080e7          	jalr	774(ra) # 8000221c <argstr>
    80004f1e:	02054b63          	bltz	a0,80004f54 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f22:	f6841683          	lh	a3,-152(s0)
    80004f26:	f6c41603          	lh	a2,-148(s0)
    80004f2a:	458d                	li	a1,3
    80004f2c:	f7040513          	addi	a0,s0,-144
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	77e080e7          	jalr	1918(ra) # 800046ae <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f38:	cd11                	beqz	a0,80004f54 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f3a:	ffffe097          	auipc	ra,0xffffe
    80004f3e:	07e080e7          	jalr	126(ra) # 80002fb8 <iunlockput>
  end_op();
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	856080e7          	jalr	-1962(ra) # 80003798 <end_op>
  return 0;
    80004f4a:	4501                	li	a0,0
}
    80004f4c:	60ea                	ld	ra,152(sp)
    80004f4e:	644a                	ld	s0,144(sp)
    80004f50:	610d                	addi	sp,sp,160
    80004f52:	8082                	ret
    end_op();
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	844080e7          	jalr	-1980(ra) # 80003798 <end_op>
    return -1;
    80004f5c:	557d                	li	a0,-1
    80004f5e:	b7fd                	j	80004f4c <sys_mknod+0x6c>

0000000080004f60 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f60:	7135                	addi	sp,sp,-160
    80004f62:	ed06                	sd	ra,152(sp)
    80004f64:	e922                	sd	s0,144(sp)
    80004f66:	e526                	sd	s1,136(sp)
    80004f68:	e14a                	sd	s2,128(sp)
    80004f6a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	08a080e7          	jalr	138(ra) # 80000ff6 <myproc>
    80004f74:	892a                	mv	s2,a0
  
  begin_op();
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	7a2080e7          	jalr	1954(ra) # 80003718 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f7e:	08000613          	li	a2,128
    80004f82:	f6040593          	addi	a1,s0,-160
    80004f86:	4501                	li	a0,0
    80004f88:	ffffd097          	auipc	ra,0xffffd
    80004f8c:	294080e7          	jalr	660(ra) # 8000221c <argstr>
    80004f90:	04054b63          	bltz	a0,80004fe6 <sys_chdir+0x86>
    80004f94:	f6040513          	addi	a0,s0,-160
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	564080e7          	jalr	1380(ra) # 800034fc <namei>
    80004fa0:	84aa                	mv	s1,a0
    80004fa2:	c131                	beqz	a0,80004fe6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fa4:	ffffe097          	auipc	ra,0xffffe
    80004fa8:	db2080e7          	jalr	-590(ra) # 80002d56 <ilock>
  if(ip->type != T_DIR){
    80004fac:	04449703          	lh	a4,68(s1)
    80004fb0:	4785                	li	a5,1
    80004fb2:	04f71063          	bne	a4,a5,80004ff2 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fb6:	8526                	mv	a0,s1
    80004fb8:	ffffe097          	auipc	ra,0xffffe
    80004fbc:	e60080e7          	jalr	-416(ra) # 80002e18 <iunlock>
  iput(p->cwd);
    80004fc0:	15093503          	ld	a0,336(s2)
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	f4c080e7          	jalr	-180(ra) # 80002f10 <iput>
  end_op();
    80004fcc:	ffffe097          	auipc	ra,0xffffe
    80004fd0:	7cc080e7          	jalr	1996(ra) # 80003798 <end_op>
  p->cwd = ip;
    80004fd4:	14993823          	sd	s1,336(s2)
  return 0;
    80004fd8:	4501                	li	a0,0
}
    80004fda:	60ea                	ld	ra,152(sp)
    80004fdc:	644a                	ld	s0,144(sp)
    80004fde:	64aa                	ld	s1,136(sp)
    80004fe0:	690a                	ld	s2,128(sp)
    80004fe2:	610d                	addi	sp,sp,160
    80004fe4:	8082                	ret
    end_op();
    80004fe6:	ffffe097          	auipc	ra,0xffffe
    80004fea:	7b2080e7          	jalr	1970(ra) # 80003798 <end_op>
    return -1;
    80004fee:	557d                	li	a0,-1
    80004ff0:	b7ed                	j	80004fda <sys_chdir+0x7a>
    iunlockput(ip);
    80004ff2:	8526                	mv	a0,s1
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	fc4080e7          	jalr	-60(ra) # 80002fb8 <iunlockput>
    end_op();
    80004ffc:	ffffe097          	auipc	ra,0xffffe
    80005000:	79c080e7          	jalr	1948(ra) # 80003798 <end_op>
    return -1;
    80005004:	557d                	li	a0,-1
    80005006:	bfd1                	j	80004fda <sys_chdir+0x7a>

0000000080005008 <sys_exec>:

uint64
sys_exec(void)
{
    80005008:	7145                	addi	sp,sp,-464
    8000500a:	e786                	sd	ra,456(sp)
    8000500c:	e3a2                	sd	s0,448(sp)
    8000500e:	ff26                	sd	s1,440(sp)
    80005010:	fb4a                	sd	s2,432(sp)
    80005012:	f74e                	sd	s3,424(sp)
    80005014:	f352                	sd	s4,416(sp)
    80005016:	ef56                	sd	s5,408(sp)
    80005018:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000501a:	e3840593          	addi	a1,s0,-456
    8000501e:	4505                	li	a0,1
    80005020:	ffffd097          	auipc	ra,0xffffd
    80005024:	1dc080e7          	jalr	476(ra) # 800021fc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005028:	08000613          	li	a2,128
    8000502c:	f4040593          	addi	a1,s0,-192
    80005030:	4501                	li	a0,0
    80005032:	ffffd097          	auipc	ra,0xffffd
    80005036:	1ea080e7          	jalr	490(ra) # 8000221c <argstr>
    8000503a:	87aa                	mv	a5,a0
    return -1;
    8000503c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000503e:	0c07c263          	bltz	a5,80005102 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005042:	10000613          	li	a2,256
    80005046:	4581                	li	a1,0
    80005048:	e4040513          	addi	a0,s0,-448
    8000504c:	ffffb097          	auipc	ra,0xffffb
    80005050:	204080e7          	jalr	516(ra) # 80000250 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005054:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005058:	89a6                	mv	s3,s1
    8000505a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000505c:	02000a13          	li	s4,32
    80005060:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005064:	00391513          	slli	a0,s2,0x3
    80005068:	e3040593          	addi	a1,s0,-464
    8000506c:	e3843783          	ld	a5,-456(s0)
    80005070:	953e                	add	a0,a0,a5
    80005072:	ffffd097          	auipc	ra,0xffffd
    80005076:	0cc080e7          	jalr	204(ra) # 8000213e <fetchaddr>
    8000507a:	02054a63          	bltz	a0,800050ae <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    8000507e:	e3043783          	ld	a5,-464(s0)
    80005082:	c3b9                	beqz	a5,800050c8 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005084:	ffffb097          	auipc	ra,0xffffb
    80005088:	156080e7          	jalr	342(ra) # 800001da <kalloc>
    8000508c:	85aa                	mv	a1,a0
    8000508e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005092:	cd11                	beqz	a0,800050ae <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005094:	6605                	lui	a2,0x1
    80005096:	e3043503          	ld	a0,-464(s0)
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	0f6080e7          	jalr	246(ra) # 80002190 <fetchstr>
    800050a2:	00054663          	bltz	a0,800050ae <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050a6:	0905                	addi	s2,s2,1
    800050a8:	09a1                	addi	s3,s3,8
    800050aa:	fb491be3          	bne	s2,s4,80005060 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ae:	10048913          	addi	s2,s1,256
    800050b2:	6088                	ld	a0,0(s1)
    800050b4:	c531                	beqz	a0,80005100 <sys_exec+0xf8>
    kfree(argv[i]);
    800050b6:	ffffb097          	auipc	ra,0xffffb
    800050ba:	fc8080e7          	jalr	-56(ra) # 8000007e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050be:	04a1                	addi	s1,s1,8
    800050c0:	ff2499e3          	bne	s1,s2,800050b2 <sys_exec+0xaa>
  return -1;
    800050c4:	557d                	li	a0,-1
    800050c6:	a835                	j	80005102 <sys_exec+0xfa>
      argv[i] = 0;
    800050c8:	0a8e                	slli	s5,s5,0x3
    800050ca:	fc040793          	addi	a5,s0,-64
    800050ce:	9abe                	add	s5,s5,a5
    800050d0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050d4:	e4040593          	addi	a1,s0,-448
    800050d8:	f4040513          	addi	a0,s0,-192
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	190080e7          	jalr	400(ra) # 8000426c <exec>
    800050e4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e6:	10048993          	addi	s3,s1,256
    800050ea:	6088                	ld	a0,0(s1)
    800050ec:	c901                	beqz	a0,800050fc <sys_exec+0xf4>
    kfree(argv[i]);
    800050ee:	ffffb097          	auipc	ra,0xffffb
    800050f2:	f90080e7          	jalr	-112(ra) # 8000007e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f6:	04a1                	addi	s1,s1,8
    800050f8:	ff3499e3          	bne	s1,s3,800050ea <sys_exec+0xe2>
  return ret;
    800050fc:	854a                	mv	a0,s2
    800050fe:	a011                	j	80005102 <sys_exec+0xfa>
  return -1;
    80005100:	557d                	li	a0,-1
}
    80005102:	60be                	ld	ra,456(sp)
    80005104:	641e                	ld	s0,448(sp)
    80005106:	74fa                	ld	s1,440(sp)
    80005108:	795a                	ld	s2,432(sp)
    8000510a:	79ba                	ld	s3,424(sp)
    8000510c:	7a1a                	ld	s4,416(sp)
    8000510e:	6afa                	ld	s5,408(sp)
    80005110:	6179                	addi	sp,sp,464
    80005112:	8082                	ret

0000000080005114 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005114:	7139                	addi	sp,sp,-64
    80005116:	fc06                	sd	ra,56(sp)
    80005118:	f822                	sd	s0,48(sp)
    8000511a:	f426                	sd	s1,40(sp)
    8000511c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000511e:	ffffc097          	auipc	ra,0xffffc
    80005122:	ed8080e7          	jalr	-296(ra) # 80000ff6 <myproc>
    80005126:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005128:	fd840593          	addi	a1,s0,-40
    8000512c:	4501                	li	a0,0
    8000512e:	ffffd097          	auipc	ra,0xffffd
    80005132:	0ce080e7          	jalr	206(ra) # 800021fc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005136:	fc840593          	addi	a1,s0,-56
    8000513a:	fd040513          	addi	a0,s0,-48
    8000513e:	fffff097          	auipc	ra,0xfffff
    80005142:	dd6080e7          	jalr	-554(ra) # 80003f14 <pipealloc>
    return -1;
    80005146:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005148:	0c054463          	bltz	a0,80005210 <sys_pipe+0xfc>
  fd0 = -1;
    8000514c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005150:	fd043503          	ld	a0,-48(s0)
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	518080e7          	jalr	1304(ra) # 8000466c <fdalloc>
    8000515c:	fca42223          	sw	a0,-60(s0)
    80005160:	08054b63          	bltz	a0,800051f6 <sys_pipe+0xe2>
    80005164:	fc843503          	ld	a0,-56(s0)
    80005168:	fffff097          	auipc	ra,0xfffff
    8000516c:	504080e7          	jalr	1284(ra) # 8000466c <fdalloc>
    80005170:	fca42023          	sw	a0,-64(s0)
    80005174:	06054863          	bltz	a0,800051e4 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005178:	4691                	li	a3,4
    8000517a:	fc440613          	addi	a2,s0,-60
    8000517e:	fd843583          	ld	a1,-40(s0)
    80005182:	68a8                	ld	a0,80(s1)
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	a8c080e7          	jalr	-1396(ra) # 80000c10 <copyout>
    8000518c:	02054063          	bltz	a0,800051ac <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005190:	4691                	li	a3,4
    80005192:	fc040613          	addi	a2,s0,-64
    80005196:	fd843583          	ld	a1,-40(s0)
    8000519a:	0591                	addi	a1,a1,4
    8000519c:	68a8                	ld	a0,80(s1)
    8000519e:	ffffc097          	auipc	ra,0xffffc
    800051a2:	a72080e7          	jalr	-1422(ra) # 80000c10 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051a6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051a8:	06055463          	bgez	a0,80005210 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051ac:	fc442783          	lw	a5,-60(s0)
    800051b0:	07e9                	addi	a5,a5,26
    800051b2:	078e                	slli	a5,a5,0x3
    800051b4:	97a6                	add	a5,a5,s1
    800051b6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ba:	fc042503          	lw	a0,-64(s0)
    800051be:	0569                	addi	a0,a0,26
    800051c0:	050e                	slli	a0,a0,0x3
    800051c2:	94aa                	add	s1,s1,a0
    800051c4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051c8:	fd043503          	ld	a0,-48(s0)
    800051cc:	fffff097          	auipc	ra,0xfffff
    800051d0:	a18080e7          	jalr	-1512(ra) # 80003be4 <fileclose>
    fileclose(wf);
    800051d4:	fc843503          	ld	a0,-56(s0)
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	a0c080e7          	jalr	-1524(ra) # 80003be4 <fileclose>
    return -1;
    800051e0:	57fd                	li	a5,-1
    800051e2:	a03d                	j	80005210 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051e4:	fc442783          	lw	a5,-60(s0)
    800051e8:	0007c763          	bltz	a5,800051f6 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051ec:	07e9                	addi	a5,a5,26
    800051ee:	078e                	slli	a5,a5,0x3
    800051f0:	94be                	add	s1,s1,a5
    800051f2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051f6:	fd043503          	ld	a0,-48(s0)
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	9ea080e7          	jalr	-1558(ra) # 80003be4 <fileclose>
    fileclose(wf);
    80005202:	fc843503          	ld	a0,-56(s0)
    80005206:	fffff097          	auipc	ra,0xfffff
    8000520a:	9de080e7          	jalr	-1570(ra) # 80003be4 <fileclose>
    return -1;
    8000520e:	57fd                	li	a5,-1
}
    80005210:	853e                	mv	a0,a5
    80005212:	70e2                	ld	ra,56(sp)
    80005214:	7442                	ld	s0,48(sp)
    80005216:	74a2                	ld	s1,40(sp)
    80005218:	6121                	addi	sp,sp,64
    8000521a:	8082                	ret
    8000521c:	0000                	unimp
	...

0000000080005220 <kernelvec>:
    80005220:	7111                	addi	sp,sp,-256
    80005222:	e006                	sd	ra,0(sp)
    80005224:	e40a                	sd	sp,8(sp)
    80005226:	e80e                	sd	gp,16(sp)
    80005228:	ec12                	sd	tp,24(sp)
    8000522a:	f016                	sd	t0,32(sp)
    8000522c:	f41a                	sd	t1,40(sp)
    8000522e:	f81e                	sd	t2,48(sp)
    80005230:	fc22                	sd	s0,56(sp)
    80005232:	e0a6                	sd	s1,64(sp)
    80005234:	e4aa                	sd	a0,72(sp)
    80005236:	e8ae                	sd	a1,80(sp)
    80005238:	ecb2                	sd	a2,88(sp)
    8000523a:	f0b6                	sd	a3,96(sp)
    8000523c:	f4ba                	sd	a4,104(sp)
    8000523e:	f8be                	sd	a5,112(sp)
    80005240:	fcc2                	sd	a6,120(sp)
    80005242:	e146                	sd	a7,128(sp)
    80005244:	e54a                	sd	s2,136(sp)
    80005246:	e94e                	sd	s3,144(sp)
    80005248:	ed52                	sd	s4,152(sp)
    8000524a:	f156                	sd	s5,160(sp)
    8000524c:	f55a                	sd	s6,168(sp)
    8000524e:	f95e                	sd	s7,176(sp)
    80005250:	fd62                	sd	s8,184(sp)
    80005252:	e1e6                	sd	s9,192(sp)
    80005254:	e5ea                	sd	s10,200(sp)
    80005256:	e9ee                	sd	s11,208(sp)
    80005258:	edf2                	sd	t3,216(sp)
    8000525a:	f1f6                	sd	t4,224(sp)
    8000525c:	f5fa                	sd	t5,232(sp)
    8000525e:	f9fe                	sd	t6,240(sp)
    80005260:	dabfc0ef          	jal	ra,8000200a <kerneltrap>
    80005264:	6082                	ld	ra,0(sp)
    80005266:	6122                	ld	sp,8(sp)
    80005268:	61c2                	ld	gp,16(sp)
    8000526a:	7282                	ld	t0,32(sp)
    8000526c:	7322                	ld	t1,40(sp)
    8000526e:	73c2                	ld	t2,48(sp)
    80005270:	7462                	ld	s0,56(sp)
    80005272:	6486                	ld	s1,64(sp)
    80005274:	6526                	ld	a0,72(sp)
    80005276:	65c6                	ld	a1,80(sp)
    80005278:	6666                	ld	a2,88(sp)
    8000527a:	7686                	ld	a3,96(sp)
    8000527c:	7726                	ld	a4,104(sp)
    8000527e:	77c6                	ld	a5,112(sp)
    80005280:	7866                	ld	a6,120(sp)
    80005282:	688a                	ld	a7,128(sp)
    80005284:	692a                	ld	s2,136(sp)
    80005286:	69ca                	ld	s3,144(sp)
    80005288:	6a6a                	ld	s4,152(sp)
    8000528a:	7a8a                	ld	s5,160(sp)
    8000528c:	7b2a                	ld	s6,168(sp)
    8000528e:	7bca                	ld	s7,176(sp)
    80005290:	7c6a                	ld	s8,184(sp)
    80005292:	6c8e                	ld	s9,192(sp)
    80005294:	6d2e                	ld	s10,200(sp)
    80005296:	6dce                	ld	s11,208(sp)
    80005298:	6e6e                	ld	t3,216(sp)
    8000529a:	7e8e                	ld	t4,224(sp)
    8000529c:	7f2e                	ld	t5,232(sp)
    8000529e:	7fce                	ld	t6,240(sp)
    800052a0:	6111                	addi	sp,sp,256
    800052a2:	10200073          	sret
    800052a6:	00000013          	nop
    800052aa:	00000013          	nop
    800052ae:	0001                	nop

00000000800052b0 <timervec>:
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	e10c                	sd	a1,0(a0)
    800052b6:	e510                	sd	a2,8(a0)
    800052b8:	e914                	sd	a3,16(a0)
    800052ba:	6d0c                	ld	a1,24(a0)
    800052bc:	7110                	ld	a2,32(a0)
    800052be:	6194                	ld	a3,0(a1)
    800052c0:	96b2                	add	a3,a3,a2
    800052c2:	e194                	sd	a3,0(a1)
    800052c4:	4589                	li	a1,2
    800052c6:	14459073          	csrw	sip,a1
    800052ca:	6914                	ld	a3,16(a0)
    800052cc:	6510                	ld	a2,8(a0)
    800052ce:	610c                	ld	a1,0(a0)
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	30200073          	mret
	...

00000000800052da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e422                	sd	s0,8(sp)
    800052de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052e0:	0c0007b7          	lui	a5,0xc000
    800052e4:	4705                	li	a4,1
    800052e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052e8:	c3d8                	sw	a4,4(a5)
}
    800052ea:	6422                	ld	s0,8(sp)
    800052ec:	0141                	addi	sp,sp,16
    800052ee:	8082                	ret

00000000800052f0 <plicinithart>:

void
plicinithart(void)
{
    800052f0:	1141                	addi	sp,sp,-16
    800052f2:	e406                	sd	ra,8(sp)
    800052f4:	e022                	sd	s0,0(sp)
    800052f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	cd2080e7          	jalr	-814(ra) # 80000fca <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005300:	0085171b          	slliw	a4,a0,0x8
    80005304:	0c0027b7          	lui	a5,0xc002
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	40200713          	li	a4,1026
    8000530e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005312:	00d5151b          	slliw	a0,a0,0xd
    80005316:	0c2017b7          	lui	a5,0xc201
    8000531a:	953e                	add	a0,a0,a5
    8000531c:	00052023          	sw	zero,0(a0)
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005328:	1141                	addi	sp,sp,-16
    8000532a:	e406                	sd	ra,8(sp)
    8000532c:	e022                	sd	s0,0(sp)
    8000532e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	c9a080e7          	jalr	-870(ra) # 80000fca <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005338:	00d5179b          	slliw	a5,a0,0xd
    8000533c:	0c201537          	lui	a0,0xc201
    80005340:	953e                	add	a0,a0,a5
  return irq;
}
    80005342:	4148                	lw	a0,4(a0)
    80005344:	60a2                	ld	ra,8(sp)
    80005346:	6402                	ld	s0,0(sp)
    80005348:	0141                	addi	sp,sp,16
    8000534a:	8082                	ret

000000008000534c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000534c:	1101                	addi	sp,sp,-32
    8000534e:	ec06                	sd	ra,24(sp)
    80005350:	e822                	sd	s0,16(sp)
    80005352:	e426                	sd	s1,8(sp)
    80005354:	1000                	addi	s0,sp,32
    80005356:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	c72080e7          	jalr	-910(ra) # 80000fca <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005360:	00d5151b          	slliw	a0,a0,0xd
    80005364:	0c2017b7          	lui	a5,0xc201
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	c3c4                	sw	s1,4(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret

0000000080005376 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005376:	1141                	addi	sp,sp,-16
    80005378:	e406                	sd	ra,8(sp)
    8000537a:	e022                	sd	s0,0(sp)
    8000537c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000537e:	479d                	li	a5,7
    80005380:	04a7cc63          	blt	a5,a0,800053d8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005384:	00234797          	auipc	a5,0x234
    80005388:	6ac78793          	addi	a5,a5,1708 # 80239a30 <disk>
    8000538c:	97aa                	add	a5,a5,a0
    8000538e:	0187c783          	lbu	a5,24(a5)
    80005392:	ebb9                	bnez	a5,800053e8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005394:	00451613          	slli	a2,a0,0x4
    80005398:	00234797          	auipc	a5,0x234
    8000539c:	69878793          	addi	a5,a5,1688 # 80239a30 <disk>
    800053a0:	6394                	ld	a3,0(a5)
    800053a2:	96b2                	add	a3,a3,a2
    800053a4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053a8:	6398                	ld	a4,0(a5)
    800053aa:	9732                	add	a4,a4,a2
    800053ac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053b0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053b4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053b8:	953e                	add	a0,a0,a5
    800053ba:	4785                	li	a5,1
    800053bc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800053c0:	00234517          	auipc	a0,0x234
    800053c4:	68850513          	addi	a0,a0,1672 # 80239a48 <disk+0x18>
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	33a080e7          	jalr	826(ra) # 80001702 <wakeup>
}
    800053d0:	60a2                	ld	ra,8(sp)
    800053d2:	6402                	ld	s0,0(sp)
    800053d4:	0141                	addi	sp,sp,16
    800053d6:	8082                	ret
    panic("free_desc 1");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	34050513          	addi	a0,a0,832 # 80008718 <syscalls+0x2f0>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	a72080e7          	jalr	-1422(ra) # 80005e52 <panic>
    panic("free_desc 2");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	34050513          	addi	a0,a0,832 # 80008728 <syscalls+0x300>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	a62080e7          	jalr	-1438(ra) # 80005e52 <panic>

00000000800053f8 <virtio_disk_init>:
{
    800053f8:	1101                	addi	sp,sp,-32
    800053fa:	ec06                	sd	ra,24(sp)
    800053fc:	e822                	sd	s0,16(sp)
    800053fe:	e426                	sd	s1,8(sp)
    80005400:	e04a                	sd	s2,0(sp)
    80005402:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005404:	00003597          	auipc	a1,0x3
    80005408:	33458593          	addi	a1,a1,820 # 80008738 <syscalls+0x310>
    8000540c:	00234517          	auipc	a0,0x234
    80005410:	74c50513          	addi	a0,a0,1868 # 80239b58 <disk+0x128>
    80005414:	00001097          	auipc	ra,0x1
    80005418:	ef8080e7          	jalr	-264(ra) # 8000630c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000541c:	100017b7          	lui	a5,0x10001
    80005420:	4398                	lw	a4,0(a5)
    80005422:	2701                	sext.w	a4,a4
    80005424:	747277b7          	lui	a5,0x74727
    80005428:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000542c:	14f71e63          	bne	a4,a5,80005588 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005430:	100017b7          	lui	a5,0x10001
    80005434:	43dc                	lw	a5,4(a5)
    80005436:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005438:	4709                	li	a4,2
    8000543a:	14e79763          	bne	a5,a4,80005588 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000543e:	100017b7          	lui	a5,0x10001
    80005442:	479c                	lw	a5,8(a5)
    80005444:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005446:	14e79163          	bne	a5,a4,80005588 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000544a:	100017b7          	lui	a5,0x10001
    8000544e:	47d8                	lw	a4,12(a5)
    80005450:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005452:	554d47b7          	lui	a5,0x554d4
    80005456:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000545a:	12f71763          	bne	a4,a5,80005588 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000545e:	100017b7          	lui	a5,0x10001
    80005462:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005466:	4705                	li	a4,1
    80005468:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000546a:	470d                	li	a4,3
    8000546c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000546e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005470:	c7ffe737          	lui	a4,0xc7ffe
    80005474:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc9af>
    80005478:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000547a:	2701                	sext.w	a4,a4
    8000547c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547e:	472d                	li	a4,11
    80005480:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005482:	0707a903          	lw	s2,112(a5)
    80005486:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005488:	00897793          	andi	a5,s2,8
    8000548c:	10078663          	beqz	a5,80005598 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005498:	43fc                	lw	a5,68(a5)
    8000549a:	2781                	sext.w	a5,a5
    8000549c:	10079663          	bnez	a5,800055a8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054a0:	100017b7          	lui	a5,0x10001
    800054a4:	5bdc                	lw	a5,52(a5)
    800054a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054a8:	10078863          	beqz	a5,800055b8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800054ac:	471d                	li	a4,7
    800054ae:	10f77d63          	bgeu	a4,a5,800055c8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800054b2:	ffffb097          	auipc	ra,0xffffb
    800054b6:	d28080e7          	jalr	-728(ra) # 800001da <kalloc>
    800054ba:	00234497          	auipc	s1,0x234
    800054be:	57648493          	addi	s1,s1,1398 # 80239a30 <disk>
    800054c2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054c4:	ffffb097          	auipc	ra,0xffffb
    800054c8:	d16080e7          	jalr	-746(ra) # 800001da <kalloc>
    800054cc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054ce:	ffffb097          	auipc	ra,0xffffb
    800054d2:	d0c080e7          	jalr	-756(ra) # 800001da <kalloc>
    800054d6:	87aa                	mv	a5,a0
    800054d8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054da:	6088                	ld	a0,0(s1)
    800054dc:	cd75                	beqz	a0,800055d8 <virtio_disk_init+0x1e0>
    800054de:	00234717          	auipc	a4,0x234
    800054e2:	55a73703          	ld	a4,1370(a4) # 80239a38 <disk+0x8>
    800054e6:	cb6d                	beqz	a4,800055d8 <virtio_disk_init+0x1e0>
    800054e8:	cbe5                	beqz	a5,800055d8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800054ea:	6605                	lui	a2,0x1
    800054ec:	4581                	li	a1,0
    800054ee:	ffffb097          	auipc	ra,0xffffb
    800054f2:	d62080e7          	jalr	-670(ra) # 80000250 <memset>
  memset(disk.avail, 0, PGSIZE);
    800054f6:	00234497          	auipc	s1,0x234
    800054fa:	53a48493          	addi	s1,s1,1338 # 80239a30 <disk>
    800054fe:	6605                	lui	a2,0x1
    80005500:	4581                	li	a1,0
    80005502:	6488                	ld	a0,8(s1)
    80005504:	ffffb097          	auipc	ra,0xffffb
    80005508:	d4c080e7          	jalr	-692(ra) # 80000250 <memset>
  memset(disk.used, 0, PGSIZE);
    8000550c:	6605                	lui	a2,0x1
    8000550e:	4581                	li	a1,0
    80005510:	6888                	ld	a0,16(s1)
    80005512:	ffffb097          	auipc	ra,0xffffb
    80005516:	d3e080e7          	jalr	-706(ra) # 80000250 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000551a:	100017b7          	lui	a5,0x10001
    8000551e:	4721                	li	a4,8
    80005520:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005522:	4098                	lw	a4,0(s1)
    80005524:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005528:	40d8                	lw	a4,4(s1)
    8000552a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000552e:	6498                	ld	a4,8(s1)
    80005530:	0007069b          	sext.w	a3,a4
    80005534:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005538:	9701                	srai	a4,a4,0x20
    8000553a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000553e:	6898                	ld	a4,16(s1)
    80005540:	0007069b          	sext.w	a3,a4
    80005544:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005548:	9701                	srai	a4,a4,0x20
    8000554a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000554e:	4685                	li	a3,1
    80005550:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005552:	4705                	li	a4,1
    80005554:	00d48c23          	sb	a3,24(s1)
    80005558:	00e48ca3          	sb	a4,25(s1)
    8000555c:	00e48d23          	sb	a4,26(s1)
    80005560:	00e48da3          	sb	a4,27(s1)
    80005564:	00e48e23          	sb	a4,28(s1)
    80005568:	00e48ea3          	sb	a4,29(s1)
    8000556c:	00e48f23          	sb	a4,30(s1)
    80005570:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005574:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005578:	0727a823          	sw	s2,112(a5)
}
    8000557c:	60e2                	ld	ra,24(sp)
    8000557e:	6442                	ld	s0,16(sp)
    80005580:	64a2                	ld	s1,8(sp)
    80005582:	6902                	ld	s2,0(sp)
    80005584:	6105                	addi	sp,sp,32
    80005586:	8082                	ret
    panic("could not find virtio disk");
    80005588:	00003517          	auipc	a0,0x3
    8000558c:	1c050513          	addi	a0,a0,448 # 80008748 <syscalls+0x320>
    80005590:	00001097          	auipc	ra,0x1
    80005594:	8c2080e7          	jalr	-1854(ra) # 80005e52 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005598:	00003517          	auipc	a0,0x3
    8000559c:	1d050513          	addi	a0,a0,464 # 80008768 <syscalls+0x340>
    800055a0:	00001097          	auipc	ra,0x1
    800055a4:	8b2080e7          	jalr	-1870(ra) # 80005e52 <panic>
    panic("virtio disk should not be ready");
    800055a8:	00003517          	auipc	a0,0x3
    800055ac:	1e050513          	addi	a0,a0,480 # 80008788 <syscalls+0x360>
    800055b0:	00001097          	auipc	ra,0x1
    800055b4:	8a2080e7          	jalr	-1886(ra) # 80005e52 <panic>
    panic("virtio disk has no queue 0");
    800055b8:	00003517          	auipc	a0,0x3
    800055bc:	1f050513          	addi	a0,a0,496 # 800087a8 <syscalls+0x380>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	892080e7          	jalr	-1902(ra) # 80005e52 <panic>
    panic("virtio disk max queue too short");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	20050513          	addi	a0,a0,512 # 800087c8 <syscalls+0x3a0>
    800055d0:	00001097          	auipc	ra,0x1
    800055d4:	882080e7          	jalr	-1918(ra) # 80005e52 <panic>
    panic("virtio disk kalloc");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	21050513          	addi	a0,a0,528 # 800087e8 <syscalls+0x3c0>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	872080e7          	jalr	-1934(ra) # 80005e52 <panic>

00000000800055e8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055e8:	7159                	addi	sp,sp,-112
    800055ea:	f486                	sd	ra,104(sp)
    800055ec:	f0a2                	sd	s0,96(sp)
    800055ee:	eca6                	sd	s1,88(sp)
    800055f0:	e8ca                	sd	s2,80(sp)
    800055f2:	e4ce                	sd	s3,72(sp)
    800055f4:	e0d2                	sd	s4,64(sp)
    800055f6:	fc56                	sd	s5,56(sp)
    800055f8:	f85a                	sd	s6,48(sp)
    800055fa:	f45e                	sd	s7,40(sp)
    800055fc:	f062                	sd	s8,32(sp)
    800055fe:	ec66                	sd	s9,24(sp)
    80005600:	e86a                	sd	s10,16(sp)
    80005602:	1880                	addi	s0,sp,112
    80005604:	892a                	mv	s2,a0
    80005606:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005608:	00c52c83          	lw	s9,12(a0)
    8000560c:	001c9c9b          	slliw	s9,s9,0x1
    80005610:	1c82                	slli	s9,s9,0x20
    80005612:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005616:	00234517          	auipc	a0,0x234
    8000561a:	54250513          	addi	a0,a0,1346 # 80239b58 <disk+0x128>
    8000561e:	00001097          	auipc	ra,0x1
    80005622:	d7e080e7          	jalr	-642(ra) # 8000639c <acquire>
  for(int i = 0; i < 3; i++){
    80005626:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005628:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000562a:	00234b17          	auipc	s6,0x234
    8000562e:	406b0b13          	addi	s6,s6,1030 # 80239a30 <disk>
  for(int i = 0; i < 3; i++){
    80005632:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005634:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005636:	00234c17          	auipc	s8,0x234
    8000563a:	522c0c13          	addi	s8,s8,1314 # 80239b58 <disk+0x128>
    8000563e:	a8b5                	j	800056ba <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005640:	00fb06b3          	add	a3,s6,a5
    80005644:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005648:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000564a:	0207c563          	bltz	a5,80005674 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000564e:	2485                	addiw	s1,s1,1
    80005650:	0711                	addi	a4,a4,4
    80005652:	1f548a63          	beq	s1,s5,80005846 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005656:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005658:	00234697          	auipc	a3,0x234
    8000565c:	3d868693          	addi	a3,a3,984 # 80239a30 <disk>
    80005660:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005662:	0186c583          	lbu	a1,24(a3)
    80005666:	fde9                	bnez	a1,80005640 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005668:	2785                	addiw	a5,a5,1
    8000566a:	0685                	addi	a3,a3,1
    8000566c:	ff779be3          	bne	a5,s7,80005662 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005670:	57fd                	li	a5,-1
    80005672:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005674:	02905a63          	blez	s1,800056a8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005678:	f9042503          	lw	a0,-112(s0)
    8000567c:	00000097          	auipc	ra,0x0
    80005680:	cfa080e7          	jalr	-774(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    80005684:	4785                	li	a5,1
    80005686:	0297d163          	bge	a5,s1,800056a8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000568a:	f9442503          	lw	a0,-108(s0)
    8000568e:	00000097          	auipc	ra,0x0
    80005692:	ce8080e7          	jalr	-792(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    80005696:	4789                	li	a5,2
    80005698:	0097d863          	bge	a5,s1,800056a8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000569c:	f9842503          	lw	a0,-104(s0)
    800056a0:	00000097          	auipc	ra,0x0
    800056a4:	cd6080e7          	jalr	-810(ra) # 80005376 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056a8:	85e2                	mv	a1,s8
    800056aa:	00234517          	auipc	a0,0x234
    800056ae:	39e50513          	addi	a0,a0,926 # 80239a48 <disk+0x18>
    800056b2:	ffffc097          	auipc	ra,0xffffc
    800056b6:	fec080e7          	jalr	-20(ra) # 8000169e <sleep>
  for(int i = 0; i < 3; i++){
    800056ba:	f9040713          	addi	a4,s0,-112
    800056be:	84ce                	mv	s1,s3
    800056c0:	bf59                	j	80005656 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056c2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800056c6:	00479693          	slli	a3,a5,0x4
    800056ca:	00234797          	auipc	a5,0x234
    800056ce:	36678793          	addi	a5,a5,870 # 80239a30 <disk>
    800056d2:	97b6                	add	a5,a5,a3
    800056d4:	4685                	li	a3,1
    800056d6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056d8:	00234597          	auipc	a1,0x234
    800056dc:	35858593          	addi	a1,a1,856 # 80239a30 <disk>
    800056e0:	00a60793          	addi	a5,a2,10
    800056e4:	0792                	slli	a5,a5,0x4
    800056e6:	97ae                	add	a5,a5,a1
    800056e8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800056ec:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056f0:	f6070693          	addi	a3,a4,-160
    800056f4:	619c                	ld	a5,0(a1)
    800056f6:	97b6                	add	a5,a5,a3
    800056f8:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056fa:	6188                	ld	a0,0(a1)
    800056fc:	96aa                	add	a3,a3,a0
    800056fe:	47c1                	li	a5,16
    80005700:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005702:	4785                	li	a5,1
    80005704:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005708:	f9442783          	lw	a5,-108(s0)
    8000570c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005710:	0792                	slli	a5,a5,0x4
    80005712:	953e                	add	a0,a0,a5
    80005714:	05890693          	addi	a3,s2,88
    80005718:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000571a:	6188                	ld	a0,0(a1)
    8000571c:	97aa                	add	a5,a5,a0
    8000571e:	40000693          	li	a3,1024
    80005722:	c794                	sw	a3,8(a5)
  if(write)
    80005724:	100d0d63          	beqz	s10,8000583e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005728:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000572c:	00c7d683          	lhu	a3,12(a5)
    80005730:	0016e693          	ori	a3,a3,1
    80005734:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005738:	f9842583          	lw	a1,-104(s0)
    8000573c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005740:	00234697          	auipc	a3,0x234
    80005744:	2f068693          	addi	a3,a3,752 # 80239a30 <disk>
    80005748:	00260793          	addi	a5,a2,2
    8000574c:	0792                	slli	a5,a5,0x4
    8000574e:	97b6                	add	a5,a5,a3
    80005750:	587d                	li	a6,-1
    80005752:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005756:	0592                	slli	a1,a1,0x4
    80005758:	952e                	add	a0,a0,a1
    8000575a:	f9070713          	addi	a4,a4,-112
    8000575e:	9736                	add	a4,a4,a3
    80005760:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005762:	6298                	ld	a4,0(a3)
    80005764:	972e                	add	a4,a4,a1
    80005766:	4585                	li	a1,1
    80005768:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000576a:	4509                	li	a0,2
    8000576c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005770:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005774:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005778:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000577c:	6698                	ld	a4,8(a3)
    8000577e:	00275783          	lhu	a5,2(a4)
    80005782:	8b9d                	andi	a5,a5,7
    80005784:	0786                	slli	a5,a5,0x1
    80005786:	97ba                	add	a5,a5,a4
    80005788:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000578c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005790:	6698                	ld	a4,8(a3)
    80005792:	00275783          	lhu	a5,2(a4)
    80005796:	2785                	addiw	a5,a5,1
    80005798:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000579c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057a0:	100017b7          	lui	a5,0x10001
    800057a4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057a8:	00492703          	lw	a4,4(s2)
    800057ac:	4785                	li	a5,1
    800057ae:	02f71163          	bne	a4,a5,800057d0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800057b2:	00234997          	auipc	s3,0x234
    800057b6:	3a698993          	addi	s3,s3,934 # 80239b58 <disk+0x128>
  while(b->disk == 1) {
    800057ba:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057bc:	85ce                	mv	a1,s3
    800057be:	854a                	mv	a0,s2
    800057c0:	ffffc097          	auipc	ra,0xffffc
    800057c4:	ede080e7          	jalr	-290(ra) # 8000169e <sleep>
  while(b->disk == 1) {
    800057c8:	00492783          	lw	a5,4(s2)
    800057cc:	fe9788e3          	beq	a5,s1,800057bc <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800057d0:	f9042903          	lw	s2,-112(s0)
    800057d4:	00290793          	addi	a5,s2,2
    800057d8:	00479713          	slli	a4,a5,0x4
    800057dc:	00234797          	auipc	a5,0x234
    800057e0:	25478793          	addi	a5,a5,596 # 80239a30 <disk>
    800057e4:	97ba                	add	a5,a5,a4
    800057e6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ea:	00234997          	auipc	s3,0x234
    800057ee:	24698993          	addi	s3,s3,582 # 80239a30 <disk>
    800057f2:	00491713          	slli	a4,s2,0x4
    800057f6:	0009b783          	ld	a5,0(s3)
    800057fa:	97ba                	add	a5,a5,a4
    800057fc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005800:	854a                	mv	a0,s2
    80005802:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005806:	00000097          	auipc	ra,0x0
    8000580a:	b70080e7          	jalr	-1168(ra) # 80005376 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000580e:	8885                	andi	s1,s1,1
    80005810:	f0ed                	bnez	s1,800057f2 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005812:	00234517          	auipc	a0,0x234
    80005816:	34650513          	addi	a0,a0,838 # 80239b58 <disk+0x128>
    8000581a:	00001097          	auipc	ra,0x1
    8000581e:	c36080e7          	jalr	-970(ra) # 80006450 <release>
}
    80005822:	70a6                	ld	ra,104(sp)
    80005824:	7406                	ld	s0,96(sp)
    80005826:	64e6                	ld	s1,88(sp)
    80005828:	6946                	ld	s2,80(sp)
    8000582a:	69a6                	ld	s3,72(sp)
    8000582c:	6a06                	ld	s4,64(sp)
    8000582e:	7ae2                	ld	s5,56(sp)
    80005830:	7b42                	ld	s6,48(sp)
    80005832:	7ba2                	ld	s7,40(sp)
    80005834:	7c02                	ld	s8,32(sp)
    80005836:	6ce2                	ld	s9,24(sp)
    80005838:	6d42                	ld	s10,16(sp)
    8000583a:	6165                	addi	sp,sp,112
    8000583c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000583e:	4689                	li	a3,2
    80005840:	00d79623          	sh	a3,12(a5)
    80005844:	b5e5                	j	8000572c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005846:	f9042603          	lw	a2,-112(s0)
    8000584a:	00a60713          	addi	a4,a2,10
    8000584e:	0712                	slli	a4,a4,0x4
    80005850:	00234517          	auipc	a0,0x234
    80005854:	1e850513          	addi	a0,a0,488 # 80239a38 <disk+0x8>
    80005858:	953a                	add	a0,a0,a4
  if(write)
    8000585a:	e60d14e3          	bnez	s10,800056c2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000585e:	00a60793          	addi	a5,a2,10
    80005862:	00479693          	slli	a3,a5,0x4
    80005866:	00234797          	auipc	a5,0x234
    8000586a:	1ca78793          	addi	a5,a5,458 # 80239a30 <disk>
    8000586e:	97b6                	add	a5,a5,a3
    80005870:	0007a423          	sw	zero,8(a5)
    80005874:	b595                	j	800056d8 <virtio_disk_rw+0xf0>

0000000080005876 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005876:	1101                	addi	sp,sp,-32
    80005878:	ec06                	sd	ra,24(sp)
    8000587a:	e822                	sd	s0,16(sp)
    8000587c:	e426                	sd	s1,8(sp)
    8000587e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005880:	00234497          	auipc	s1,0x234
    80005884:	1b048493          	addi	s1,s1,432 # 80239a30 <disk>
    80005888:	00234517          	auipc	a0,0x234
    8000588c:	2d050513          	addi	a0,a0,720 # 80239b58 <disk+0x128>
    80005890:	00001097          	auipc	ra,0x1
    80005894:	b0c080e7          	jalr	-1268(ra) # 8000639c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005898:	10001737          	lui	a4,0x10001
    8000589c:	533c                	lw	a5,96(a4)
    8000589e:	8b8d                	andi	a5,a5,3
    800058a0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058a2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058a6:	689c                	ld	a5,16(s1)
    800058a8:	0204d703          	lhu	a4,32(s1)
    800058ac:	0027d783          	lhu	a5,2(a5)
    800058b0:	04f70863          	beq	a4,a5,80005900 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058b4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058b8:	6898                	ld	a4,16(s1)
    800058ba:	0204d783          	lhu	a5,32(s1)
    800058be:	8b9d                	andi	a5,a5,7
    800058c0:	078e                	slli	a5,a5,0x3
    800058c2:	97ba                	add	a5,a5,a4
    800058c4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058c6:	00278713          	addi	a4,a5,2
    800058ca:	0712                	slli	a4,a4,0x4
    800058cc:	9726                	add	a4,a4,s1
    800058ce:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058d2:	e721                	bnez	a4,8000591a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058d4:	0789                	addi	a5,a5,2
    800058d6:	0792                	slli	a5,a5,0x4
    800058d8:	97a6                	add	a5,a5,s1
    800058da:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058dc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058e0:	ffffc097          	auipc	ra,0xffffc
    800058e4:	e22080e7          	jalr	-478(ra) # 80001702 <wakeup>

    disk.used_idx += 1;
    800058e8:	0204d783          	lhu	a5,32(s1)
    800058ec:	2785                	addiw	a5,a5,1
    800058ee:	17c2                	slli	a5,a5,0x30
    800058f0:	93c1                	srli	a5,a5,0x30
    800058f2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058f6:	6898                	ld	a4,16(s1)
    800058f8:	00275703          	lhu	a4,2(a4)
    800058fc:	faf71ce3          	bne	a4,a5,800058b4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005900:	00234517          	auipc	a0,0x234
    80005904:	25850513          	addi	a0,a0,600 # 80239b58 <disk+0x128>
    80005908:	00001097          	auipc	ra,0x1
    8000590c:	b48080e7          	jalr	-1208(ra) # 80006450 <release>
}
    80005910:	60e2                	ld	ra,24(sp)
    80005912:	6442                	ld	s0,16(sp)
    80005914:	64a2                	ld	s1,8(sp)
    80005916:	6105                	addi	sp,sp,32
    80005918:	8082                	ret
      panic("virtio_disk_intr status");
    8000591a:	00003517          	auipc	a0,0x3
    8000591e:	ee650513          	addi	a0,a0,-282 # 80008800 <syscalls+0x3d8>
    80005922:	00000097          	auipc	ra,0x0
    80005926:	530080e7          	jalr	1328(ra) # 80005e52 <panic>

000000008000592a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000592a:	1141                	addi	sp,sp,-16
    8000592c:	e422                	sd	s0,8(sp)
    8000592e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005930:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005934:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005938:	0037979b          	slliw	a5,a5,0x3
    8000593c:	02004737          	lui	a4,0x2004
    80005940:	97ba                	add	a5,a5,a4
    80005942:	0200c737          	lui	a4,0x200c
    80005946:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000594a:	000f4637          	lui	a2,0xf4
    8000594e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005952:	95b2                	add	a1,a1,a2
    80005954:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005956:	00269713          	slli	a4,a3,0x2
    8000595a:	9736                	add	a4,a4,a3
    8000595c:	00371693          	slli	a3,a4,0x3
    80005960:	00234717          	auipc	a4,0x234
    80005964:	21070713          	addi	a4,a4,528 # 80239b70 <timer_scratch>
    80005968:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000596a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000596c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000596e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005972:	00000797          	auipc	a5,0x0
    80005976:	93e78793          	addi	a5,a5,-1730 # 800052b0 <timervec>
    8000597a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000597e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005982:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005986:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000598a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000598e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005992:	30479073          	csrw	mie,a5
}
    80005996:	6422                	ld	s0,8(sp)
    80005998:	0141                	addi	sp,sp,16
    8000599a:	8082                	ret

000000008000599c <start>:
{
    8000599c:	1141                	addi	sp,sp,-16
    8000599e:	e406                	sd	ra,8(sp)
    800059a0:	e022                	sd	s0,0(sp)
    800059a2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059a4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059a8:	7779                	lui	a4,0xffffe
    800059aa:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca4f>
    800059ae:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059b0:	6705                	lui	a4,0x1
    800059b2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059b6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059b8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059bc:	ffffb797          	auipc	a5,0xffffb
    800059c0:	a4278793          	addi	a5,a5,-1470 # 800003fe <main>
    800059c4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059c8:	4781                	li	a5,0
    800059ca:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059ce:	67c1                	lui	a5,0x10
    800059d0:	17fd                	addi	a5,a5,-1
    800059d2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059d6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059da:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059de:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059e2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059e6:	57fd                	li	a5,-1
    800059e8:	83a9                	srli	a5,a5,0xa
    800059ea:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059ee:	47bd                	li	a5,15
    800059f0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	f36080e7          	jalr	-202(ra) # 8000592a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059fc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a00:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a02:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a04:	30200073          	mret
}
    80005a08:	60a2                	ld	ra,8(sp)
    80005a0a:	6402                	ld	s0,0(sp)
    80005a0c:	0141                	addi	sp,sp,16
    80005a0e:	8082                	ret

0000000080005a10 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a10:	715d                	addi	sp,sp,-80
    80005a12:	e486                	sd	ra,72(sp)
    80005a14:	e0a2                	sd	s0,64(sp)
    80005a16:	fc26                	sd	s1,56(sp)
    80005a18:	f84a                	sd	s2,48(sp)
    80005a1a:	f44e                	sd	s3,40(sp)
    80005a1c:	f052                	sd	s4,32(sp)
    80005a1e:	ec56                	sd	s5,24(sp)
    80005a20:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a22:	04c05663          	blez	a2,80005a6e <consolewrite+0x5e>
    80005a26:	8a2a                	mv	s4,a0
    80005a28:	84ae                	mv	s1,a1
    80005a2a:	89b2                	mv	s3,a2
    80005a2c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a2e:	5afd                	li	s5,-1
    80005a30:	4685                	li	a3,1
    80005a32:	8626                	mv	a2,s1
    80005a34:	85d2                	mv	a1,s4
    80005a36:	fbf40513          	addi	a0,s0,-65
    80005a3a:	ffffc097          	auipc	ra,0xffffc
    80005a3e:	0c2080e7          	jalr	194(ra) # 80001afc <either_copyin>
    80005a42:	01550c63          	beq	a0,s5,80005a5a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a46:	fbf44503          	lbu	a0,-65(s0)
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	794080e7          	jalr	1940(ra) # 800061de <uartputc>
  for(i = 0; i < n; i++){
    80005a52:	2905                	addiw	s2,s2,1
    80005a54:	0485                	addi	s1,s1,1
    80005a56:	fd299de3          	bne	s3,s2,80005a30 <consolewrite+0x20>
  }

  return i;
}
    80005a5a:	854a                	mv	a0,s2
    80005a5c:	60a6                	ld	ra,72(sp)
    80005a5e:	6406                	ld	s0,64(sp)
    80005a60:	74e2                	ld	s1,56(sp)
    80005a62:	7942                	ld	s2,48(sp)
    80005a64:	79a2                	ld	s3,40(sp)
    80005a66:	7a02                	ld	s4,32(sp)
    80005a68:	6ae2                	ld	s5,24(sp)
    80005a6a:	6161                	addi	sp,sp,80
    80005a6c:	8082                	ret
  for(i = 0; i < n; i++){
    80005a6e:	4901                	li	s2,0
    80005a70:	b7ed                	j	80005a5a <consolewrite+0x4a>

0000000080005a72 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a72:	7119                	addi	sp,sp,-128
    80005a74:	fc86                	sd	ra,120(sp)
    80005a76:	f8a2                	sd	s0,112(sp)
    80005a78:	f4a6                	sd	s1,104(sp)
    80005a7a:	f0ca                	sd	s2,96(sp)
    80005a7c:	ecce                	sd	s3,88(sp)
    80005a7e:	e8d2                	sd	s4,80(sp)
    80005a80:	e4d6                	sd	s5,72(sp)
    80005a82:	e0da                	sd	s6,64(sp)
    80005a84:	fc5e                	sd	s7,56(sp)
    80005a86:	f862                	sd	s8,48(sp)
    80005a88:	f466                	sd	s9,40(sp)
    80005a8a:	f06a                	sd	s10,32(sp)
    80005a8c:	ec6e                	sd	s11,24(sp)
    80005a8e:	0100                	addi	s0,sp,128
    80005a90:	8b2a                	mv	s6,a0
    80005a92:	8aae                	mv	s5,a1
    80005a94:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a96:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a9a:	0023c517          	auipc	a0,0x23c
    80005a9e:	21650513          	addi	a0,a0,534 # 80241cb0 <cons>
    80005aa2:	00001097          	auipc	ra,0x1
    80005aa6:	8fa080e7          	jalr	-1798(ra) # 8000639c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005aaa:	0023c497          	auipc	s1,0x23c
    80005aae:	20648493          	addi	s1,s1,518 # 80241cb0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ab2:	89a6                	mv	s3,s1
    80005ab4:	0023c917          	auipc	s2,0x23c
    80005ab8:	29490913          	addi	s2,s2,660 # 80241d48 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005abc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005abe:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005ac0:	4da9                	li	s11,10
  while(n > 0){
    80005ac2:	07405b63          	blez	s4,80005b38 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005ac6:	0984a783          	lw	a5,152(s1)
    80005aca:	09c4a703          	lw	a4,156(s1)
    80005ace:	02f71763          	bne	a4,a5,80005afc <consoleread+0x8a>
      if(killed(myproc())){
    80005ad2:	ffffb097          	auipc	ra,0xffffb
    80005ad6:	524080e7          	jalr	1316(ra) # 80000ff6 <myproc>
    80005ada:	ffffc097          	auipc	ra,0xffffc
    80005ade:	e6c080e7          	jalr	-404(ra) # 80001946 <killed>
    80005ae2:	e535                	bnez	a0,80005b4e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005ae4:	85ce                	mv	a1,s3
    80005ae6:	854a                	mv	a0,s2
    80005ae8:	ffffc097          	auipc	ra,0xffffc
    80005aec:	bb6080e7          	jalr	-1098(ra) # 8000169e <sleep>
    while(cons.r == cons.w){
    80005af0:	0984a783          	lw	a5,152(s1)
    80005af4:	09c4a703          	lw	a4,156(s1)
    80005af8:	fcf70de3          	beq	a4,a5,80005ad2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005afc:	0017871b          	addiw	a4,a5,1
    80005b00:	08e4ac23          	sw	a4,152(s1)
    80005b04:	07f7f713          	andi	a4,a5,127
    80005b08:	9726                	add	a4,a4,s1
    80005b0a:	01874703          	lbu	a4,24(a4)
    80005b0e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b12:	079c0663          	beq	s8,s9,80005b7e <consoleread+0x10c>
    cbuf = c;
    80005b16:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b1a:	4685                	li	a3,1
    80005b1c:	f8f40613          	addi	a2,s0,-113
    80005b20:	85d6                	mv	a1,s5
    80005b22:	855a                	mv	a0,s6
    80005b24:	ffffc097          	auipc	ra,0xffffc
    80005b28:	f82080e7          	jalr	-126(ra) # 80001aa6 <either_copyout>
    80005b2c:	01a50663          	beq	a0,s10,80005b38 <consoleread+0xc6>
    dst++;
    80005b30:	0a85                	addi	s5,s5,1
    --n;
    80005b32:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b34:	f9bc17e3          	bne	s8,s11,80005ac2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b38:	0023c517          	auipc	a0,0x23c
    80005b3c:	17850513          	addi	a0,a0,376 # 80241cb0 <cons>
    80005b40:	00001097          	auipc	ra,0x1
    80005b44:	910080e7          	jalr	-1776(ra) # 80006450 <release>

  return target - n;
    80005b48:	414b853b          	subw	a0,s7,s4
    80005b4c:	a811                	j	80005b60 <consoleread+0xee>
        release(&cons.lock);
    80005b4e:	0023c517          	auipc	a0,0x23c
    80005b52:	16250513          	addi	a0,a0,354 # 80241cb0 <cons>
    80005b56:	00001097          	auipc	ra,0x1
    80005b5a:	8fa080e7          	jalr	-1798(ra) # 80006450 <release>
        return -1;
    80005b5e:	557d                	li	a0,-1
}
    80005b60:	70e6                	ld	ra,120(sp)
    80005b62:	7446                	ld	s0,112(sp)
    80005b64:	74a6                	ld	s1,104(sp)
    80005b66:	7906                	ld	s2,96(sp)
    80005b68:	69e6                	ld	s3,88(sp)
    80005b6a:	6a46                	ld	s4,80(sp)
    80005b6c:	6aa6                	ld	s5,72(sp)
    80005b6e:	6b06                	ld	s6,64(sp)
    80005b70:	7be2                	ld	s7,56(sp)
    80005b72:	7c42                	ld	s8,48(sp)
    80005b74:	7ca2                	ld	s9,40(sp)
    80005b76:	7d02                	ld	s10,32(sp)
    80005b78:	6de2                	ld	s11,24(sp)
    80005b7a:	6109                	addi	sp,sp,128
    80005b7c:	8082                	ret
      if(n < target){
    80005b7e:	000a071b          	sext.w	a4,s4
    80005b82:	fb777be3          	bgeu	a4,s7,80005b38 <consoleread+0xc6>
        cons.r--;
    80005b86:	0023c717          	auipc	a4,0x23c
    80005b8a:	1cf72123          	sw	a5,450(a4) # 80241d48 <cons+0x98>
    80005b8e:	b76d                	j	80005b38 <consoleread+0xc6>

0000000080005b90 <consputc>:
{
    80005b90:	1141                	addi	sp,sp,-16
    80005b92:	e406                	sd	ra,8(sp)
    80005b94:	e022                	sd	s0,0(sp)
    80005b96:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b98:	10000793          	li	a5,256
    80005b9c:	00f50a63          	beq	a0,a5,80005bb0 <consputc+0x20>
    uartputc_sync(c);
    80005ba0:	00000097          	auipc	ra,0x0
    80005ba4:	564080e7          	jalr	1380(ra) # 80006104 <uartputc_sync>
}
    80005ba8:	60a2                	ld	ra,8(sp)
    80005baa:	6402                	ld	s0,0(sp)
    80005bac:	0141                	addi	sp,sp,16
    80005bae:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bb0:	4521                	li	a0,8
    80005bb2:	00000097          	auipc	ra,0x0
    80005bb6:	552080e7          	jalr	1362(ra) # 80006104 <uartputc_sync>
    80005bba:	02000513          	li	a0,32
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	546080e7          	jalr	1350(ra) # 80006104 <uartputc_sync>
    80005bc6:	4521                	li	a0,8
    80005bc8:	00000097          	auipc	ra,0x0
    80005bcc:	53c080e7          	jalr	1340(ra) # 80006104 <uartputc_sync>
    80005bd0:	bfe1                	j	80005ba8 <consputc+0x18>

0000000080005bd2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bd2:	1101                	addi	sp,sp,-32
    80005bd4:	ec06                	sd	ra,24(sp)
    80005bd6:	e822                	sd	s0,16(sp)
    80005bd8:	e426                	sd	s1,8(sp)
    80005bda:	e04a                	sd	s2,0(sp)
    80005bdc:	1000                	addi	s0,sp,32
    80005bde:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005be0:	0023c517          	auipc	a0,0x23c
    80005be4:	0d050513          	addi	a0,a0,208 # 80241cb0 <cons>
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	7b4080e7          	jalr	1972(ra) # 8000639c <acquire>

  switch(c){
    80005bf0:	47d5                	li	a5,21
    80005bf2:	0af48663          	beq	s1,a5,80005c9e <consoleintr+0xcc>
    80005bf6:	0297ca63          	blt	a5,s1,80005c2a <consoleintr+0x58>
    80005bfa:	47a1                	li	a5,8
    80005bfc:	0ef48763          	beq	s1,a5,80005cea <consoleintr+0x118>
    80005c00:	47c1                	li	a5,16
    80005c02:	10f49a63          	bne	s1,a5,80005d16 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c06:	ffffc097          	auipc	ra,0xffffc
    80005c0a:	f4c080e7          	jalr	-180(ra) # 80001b52 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c0e:	0023c517          	auipc	a0,0x23c
    80005c12:	0a250513          	addi	a0,a0,162 # 80241cb0 <cons>
    80005c16:	00001097          	auipc	ra,0x1
    80005c1a:	83a080e7          	jalr	-1990(ra) # 80006450 <release>
}
    80005c1e:	60e2                	ld	ra,24(sp)
    80005c20:	6442                	ld	s0,16(sp)
    80005c22:	64a2                	ld	s1,8(sp)
    80005c24:	6902                	ld	s2,0(sp)
    80005c26:	6105                	addi	sp,sp,32
    80005c28:	8082                	ret
  switch(c){
    80005c2a:	07f00793          	li	a5,127
    80005c2e:	0af48e63          	beq	s1,a5,80005cea <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c32:	0023c717          	auipc	a4,0x23c
    80005c36:	07e70713          	addi	a4,a4,126 # 80241cb0 <cons>
    80005c3a:	0a072783          	lw	a5,160(a4)
    80005c3e:	09872703          	lw	a4,152(a4)
    80005c42:	9f99                	subw	a5,a5,a4
    80005c44:	07f00713          	li	a4,127
    80005c48:	fcf763e3          	bltu	a4,a5,80005c0e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c4c:	47b5                	li	a5,13
    80005c4e:	0cf48763          	beq	s1,a5,80005d1c <consoleintr+0x14a>
      consputc(c);
    80005c52:	8526                	mv	a0,s1
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	f3c080e7          	jalr	-196(ra) # 80005b90 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c5c:	0023c797          	auipc	a5,0x23c
    80005c60:	05478793          	addi	a5,a5,84 # 80241cb0 <cons>
    80005c64:	0a07a683          	lw	a3,160(a5)
    80005c68:	0016871b          	addiw	a4,a3,1
    80005c6c:	0007061b          	sext.w	a2,a4
    80005c70:	0ae7a023          	sw	a4,160(a5)
    80005c74:	07f6f693          	andi	a3,a3,127
    80005c78:	97b6                	add	a5,a5,a3
    80005c7a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c7e:	47a9                	li	a5,10
    80005c80:	0cf48563          	beq	s1,a5,80005d4a <consoleintr+0x178>
    80005c84:	4791                	li	a5,4
    80005c86:	0cf48263          	beq	s1,a5,80005d4a <consoleintr+0x178>
    80005c8a:	0023c797          	auipc	a5,0x23c
    80005c8e:	0be7a783          	lw	a5,190(a5) # 80241d48 <cons+0x98>
    80005c92:	9f1d                	subw	a4,a4,a5
    80005c94:	08000793          	li	a5,128
    80005c98:	f6f71be3          	bne	a4,a5,80005c0e <consoleintr+0x3c>
    80005c9c:	a07d                	j	80005d4a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c9e:	0023c717          	auipc	a4,0x23c
    80005ca2:	01270713          	addi	a4,a4,18 # 80241cb0 <cons>
    80005ca6:	0a072783          	lw	a5,160(a4)
    80005caa:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cae:	0023c497          	auipc	s1,0x23c
    80005cb2:	00248493          	addi	s1,s1,2 # 80241cb0 <cons>
    while(cons.e != cons.w &&
    80005cb6:	4929                	li	s2,10
    80005cb8:	f4f70be3          	beq	a4,a5,80005c0e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cbc:	37fd                	addiw	a5,a5,-1
    80005cbe:	07f7f713          	andi	a4,a5,127
    80005cc2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cc4:	01874703          	lbu	a4,24(a4)
    80005cc8:	f52703e3          	beq	a4,s2,80005c0e <consoleintr+0x3c>
      cons.e--;
    80005ccc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cd0:	10000513          	li	a0,256
    80005cd4:	00000097          	auipc	ra,0x0
    80005cd8:	ebc080e7          	jalr	-324(ra) # 80005b90 <consputc>
    while(cons.e != cons.w &&
    80005cdc:	0a04a783          	lw	a5,160(s1)
    80005ce0:	09c4a703          	lw	a4,156(s1)
    80005ce4:	fcf71ce3          	bne	a4,a5,80005cbc <consoleintr+0xea>
    80005ce8:	b71d                	j	80005c0e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cea:	0023c717          	auipc	a4,0x23c
    80005cee:	fc670713          	addi	a4,a4,-58 # 80241cb0 <cons>
    80005cf2:	0a072783          	lw	a5,160(a4)
    80005cf6:	09c72703          	lw	a4,156(a4)
    80005cfa:	f0f70ae3          	beq	a4,a5,80005c0e <consoleintr+0x3c>
      cons.e--;
    80005cfe:	37fd                	addiw	a5,a5,-1
    80005d00:	0023c717          	auipc	a4,0x23c
    80005d04:	04f72823          	sw	a5,80(a4) # 80241d50 <cons+0xa0>
      consputc(BACKSPACE);
    80005d08:	10000513          	li	a0,256
    80005d0c:	00000097          	auipc	ra,0x0
    80005d10:	e84080e7          	jalr	-380(ra) # 80005b90 <consputc>
    80005d14:	bded                	j	80005c0e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d16:	ee048ce3          	beqz	s1,80005c0e <consoleintr+0x3c>
    80005d1a:	bf21                	j	80005c32 <consoleintr+0x60>
      consputc(c);
    80005d1c:	4529                	li	a0,10
    80005d1e:	00000097          	auipc	ra,0x0
    80005d22:	e72080e7          	jalr	-398(ra) # 80005b90 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d26:	0023c797          	auipc	a5,0x23c
    80005d2a:	f8a78793          	addi	a5,a5,-118 # 80241cb0 <cons>
    80005d2e:	0a07a703          	lw	a4,160(a5)
    80005d32:	0017069b          	addiw	a3,a4,1
    80005d36:	0006861b          	sext.w	a2,a3
    80005d3a:	0ad7a023          	sw	a3,160(a5)
    80005d3e:	07f77713          	andi	a4,a4,127
    80005d42:	97ba                	add	a5,a5,a4
    80005d44:	4729                	li	a4,10
    80005d46:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d4a:	0023c797          	auipc	a5,0x23c
    80005d4e:	00c7a123          	sw	a2,2(a5) # 80241d4c <cons+0x9c>
        wakeup(&cons.r);
    80005d52:	0023c517          	auipc	a0,0x23c
    80005d56:	ff650513          	addi	a0,a0,-10 # 80241d48 <cons+0x98>
    80005d5a:	ffffc097          	auipc	ra,0xffffc
    80005d5e:	9a8080e7          	jalr	-1624(ra) # 80001702 <wakeup>
    80005d62:	b575                	j	80005c0e <consoleintr+0x3c>

0000000080005d64 <consoleinit>:

void
consoleinit(void)
{
    80005d64:	1141                	addi	sp,sp,-16
    80005d66:	e406                	sd	ra,8(sp)
    80005d68:	e022                	sd	s0,0(sp)
    80005d6a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d6c:	00003597          	auipc	a1,0x3
    80005d70:	aac58593          	addi	a1,a1,-1364 # 80008818 <syscalls+0x3f0>
    80005d74:	0023c517          	auipc	a0,0x23c
    80005d78:	f3c50513          	addi	a0,a0,-196 # 80241cb0 <cons>
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	590080e7          	jalr	1424(ra) # 8000630c <initlock>

  uartinit();
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	330080e7          	jalr	816(ra) # 800060b4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d8c:	00233797          	auipc	a5,0x233
    80005d90:	c4c78793          	addi	a5,a5,-948 # 802389d8 <devsw>
    80005d94:	00000717          	auipc	a4,0x0
    80005d98:	cde70713          	addi	a4,a4,-802 # 80005a72 <consoleread>
    80005d9c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d9e:	00000717          	auipc	a4,0x0
    80005da2:	c7270713          	addi	a4,a4,-910 # 80005a10 <consolewrite>
    80005da6:	ef98                	sd	a4,24(a5)
}
    80005da8:	60a2                	ld	ra,8(sp)
    80005daa:	6402                	ld	s0,0(sp)
    80005dac:	0141                	addi	sp,sp,16
    80005dae:	8082                	ret

0000000080005db0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005db0:	7179                	addi	sp,sp,-48
    80005db2:	f406                	sd	ra,40(sp)
    80005db4:	f022                	sd	s0,32(sp)
    80005db6:	ec26                	sd	s1,24(sp)
    80005db8:	e84a                	sd	s2,16(sp)
    80005dba:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dbc:	c219                	beqz	a2,80005dc2 <printint+0x12>
    80005dbe:	08054663          	bltz	a0,80005e4a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005dc2:	2501                	sext.w	a0,a0
    80005dc4:	4881                	li	a7,0
    80005dc6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dca:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dcc:	2581                	sext.w	a1,a1
    80005dce:	00003617          	auipc	a2,0x3
    80005dd2:	a7a60613          	addi	a2,a2,-1414 # 80008848 <digits>
    80005dd6:	883a                	mv	a6,a4
    80005dd8:	2705                	addiw	a4,a4,1
    80005dda:	02b577bb          	remuw	a5,a0,a1
    80005dde:	1782                	slli	a5,a5,0x20
    80005de0:	9381                	srli	a5,a5,0x20
    80005de2:	97b2                	add	a5,a5,a2
    80005de4:	0007c783          	lbu	a5,0(a5)
    80005de8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dec:	0005079b          	sext.w	a5,a0
    80005df0:	02b5553b          	divuw	a0,a0,a1
    80005df4:	0685                	addi	a3,a3,1
    80005df6:	feb7f0e3          	bgeu	a5,a1,80005dd6 <printint+0x26>

  if(sign)
    80005dfa:	00088b63          	beqz	a7,80005e10 <printint+0x60>
    buf[i++] = '-';
    80005dfe:	fe040793          	addi	a5,s0,-32
    80005e02:	973e                	add	a4,a4,a5
    80005e04:	02d00793          	li	a5,45
    80005e08:	fef70823          	sb	a5,-16(a4)
    80005e0c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e10:	02e05763          	blez	a4,80005e3e <printint+0x8e>
    80005e14:	fd040793          	addi	a5,s0,-48
    80005e18:	00e784b3          	add	s1,a5,a4
    80005e1c:	fff78913          	addi	s2,a5,-1
    80005e20:	993a                	add	s2,s2,a4
    80005e22:	377d                	addiw	a4,a4,-1
    80005e24:	1702                	slli	a4,a4,0x20
    80005e26:	9301                	srli	a4,a4,0x20
    80005e28:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e2c:	fff4c503          	lbu	a0,-1(s1)
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	d60080e7          	jalr	-672(ra) # 80005b90 <consputc>
  while(--i >= 0)
    80005e38:	14fd                	addi	s1,s1,-1
    80005e3a:	ff2499e3          	bne	s1,s2,80005e2c <printint+0x7c>
}
    80005e3e:	70a2                	ld	ra,40(sp)
    80005e40:	7402                	ld	s0,32(sp)
    80005e42:	64e2                	ld	s1,24(sp)
    80005e44:	6942                	ld	s2,16(sp)
    80005e46:	6145                	addi	sp,sp,48
    80005e48:	8082                	ret
    x = -xx;
    80005e4a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e4e:	4885                	li	a7,1
    x = -xx;
    80005e50:	bf9d                	j	80005dc6 <printint+0x16>

0000000080005e52 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e52:	1101                	addi	sp,sp,-32
    80005e54:	ec06                	sd	ra,24(sp)
    80005e56:	e822                	sd	s0,16(sp)
    80005e58:	e426                	sd	s1,8(sp)
    80005e5a:	1000                	addi	s0,sp,32
    80005e5c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e5e:	0023c797          	auipc	a5,0x23c
    80005e62:	f007a923          	sw	zero,-238(a5) # 80241d70 <pr+0x18>
  printf("panic: ");
    80005e66:	00003517          	auipc	a0,0x3
    80005e6a:	9ba50513          	addi	a0,a0,-1606 # 80008820 <syscalls+0x3f8>
    80005e6e:	00000097          	auipc	ra,0x0
    80005e72:	02e080e7          	jalr	46(ra) # 80005e9c <printf>
  printf(s);
    80005e76:	8526                	mv	a0,s1
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	024080e7          	jalr	36(ra) # 80005e9c <printf>
  printf("\n");
    80005e80:	00002517          	auipc	a0,0x2
    80005e84:	1e050513          	addi	a0,a0,480 # 80008060 <etext+0x60>
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	014080e7          	jalr	20(ra) # 80005e9c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e90:	4785                	li	a5,1
    80005e92:	00003717          	auipc	a4,0x3
    80005e96:	a8f72d23          	sw	a5,-1382(a4) # 8000892c <panicked>
  for(;;)
    80005e9a:	a001                	j	80005e9a <panic+0x48>

0000000080005e9c <printf>:
{
    80005e9c:	7131                	addi	sp,sp,-192
    80005e9e:	fc86                	sd	ra,120(sp)
    80005ea0:	f8a2                	sd	s0,112(sp)
    80005ea2:	f4a6                	sd	s1,104(sp)
    80005ea4:	f0ca                	sd	s2,96(sp)
    80005ea6:	ecce                	sd	s3,88(sp)
    80005ea8:	e8d2                	sd	s4,80(sp)
    80005eaa:	e4d6                	sd	s5,72(sp)
    80005eac:	e0da                	sd	s6,64(sp)
    80005eae:	fc5e                	sd	s7,56(sp)
    80005eb0:	f862                	sd	s8,48(sp)
    80005eb2:	f466                	sd	s9,40(sp)
    80005eb4:	f06a                	sd	s10,32(sp)
    80005eb6:	ec6e                	sd	s11,24(sp)
    80005eb8:	0100                	addi	s0,sp,128
    80005eba:	8a2a                	mv	s4,a0
    80005ebc:	e40c                	sd	a1,8(s0)
    80005ebe:	e810                	sd	a2,16(s0)
    80005ec0:	ec14                	sd	a3,24(s0)
    80005ec2:	f018                	sd	a4,32(s0)
    80005ec4:	f41c                	sd	a5,40(s0)
    80005ec6:	03043823          	sd	a6,48(s0)
    80005eca:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ece:	0023cd97          	auipc	s11,0x23c
    80005ed2:	ea2dad83          	lw	s11,-350(s11) # 80241d70 <pr+0x18>
  if(locking)
    80005ed6:	020d9b63          	bnez	s11,80005f0c <printf+0x70>
  if (fmt == 0)
    80005eda:	040a0263          	beqz	s4,80005f1e <printf+0x82>
  va_start(ap, fmt);
    80005ede:	00840793          	addi	a5,s0,8
    80005ee2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ee6:	000a4503          	lbu	a0,0(s4)
    80005eea:	16050263          	beqz	a0,8000604e <printf+0x1b2>
    80005eee:	4481                	li	s1,0
    if(c != '%'){
    80005ef0:	02500a93          	li	s5,37
    switch(c){
    80005ef4:	07000b13          	li	s6,112
  consputc('x');
    80005ef8:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005efa:	00003b97          	auipc	s7,0x3
    80005efe:	94eb8b93          	addi	s7,s7,-1714 # 80008848 <digits>
    switch(c){
    80005f02:	07300c93          	li	s9,115
    80005f06:	06400c13          	li	s8,100
    80005f0a:	a82d                	j	80005f44 <printf+0xa8>
    acquire(&pr.lock);
    80005f0c:	0023c517          	auipc	a0,0x23c
    80005f10:	e4c50513          	addi	a0,a0,-436 # 80241d58 <pr>
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	488080e7          	jalr	1160(ra) # 8000639c <acquire>
    80005f1c:	bf7d                	j	80005eda <printf+0x3e>
    panic("null fmt");
    80005f1e:	00003517          	auipc	a0,0x3
    80005f22:	91250513          	addi	a0,a0,-1774 # 80008830 <syscalls+0x408>
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	f2c080e7          	jalr	-212(ra) # 80005e52 <panic>
      consputc(c);
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	c62080e7          	jalr	-926(ra) # 80005b90 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f36:	2485                	addiw	s1,s1,1
    80005f38:	009a07b3          	add	a5,s4,s1
    80005f3c:	0007c503          	lbu	a0,0(a5)
    80005f40:	10050763          	beqz	a0,8000604e <printf+0x1b2>
    if(c != '%'){
    80005f44:	ff5515e3          	bne	a0,s5,80005f2e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f48:	2485                	addiw	s1,s1,1
    80005f4a:	009a07b3          	add	a5,s4,s1
    80005f4e:	0007c783          	lbu	a5,0(a5)
    80005f52:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f56:	cfe5                	beqz	a5,8000604e <printf+0x1b2>
    switch(c){
    80005f58:	05678a63          	beq	a5,s6,80005fac <printf+0x110>
    80005f5c:	02fb7663          	bgeu	s6,a5,80005f88 <printf+0xec>
    80005f60:	09978963          	beq	a5,s9,80005ff2 <printf+0x156>
    80005f64:	07800713          	li	a4,120
    80005f68:	0ce79863          	bne	a5,a4,80006038 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f6c:	f8843783          	ld	a5,-120(s0)
    80005f70:	00878713          	addi	a4,a5,8
    80005f74:	f8e43423          	sd	a4,-120(s0)
    80005f78:	4605                	li	a2,1
    80005f7a:	85ea                	mv	a1,s10
    80005f7c:	4388                	lw	a0,0(a5)
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	e32080e7          	jalr	-462(ra) # 80005db0 <printint>
      break;
    80005f86:	bf45                	j	80005f36 <printf+0x9a>
    switch(c){
    80005f88:	0b578263          	beq	a5,s5,8000602c <printf+0x190>
    80005f8c:	0b879663          	bne	a5,s8,80006038 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f90:	f8843783          	ld	a5,-120(s0)
    80005f94:	00878713          	addi	a4,a5,8
    80005f98:	f8e43423          	sd	a4,-120(s0)
    80005f9c:	4605                	li	a2,1
    80005f9e:	45a9                	li	a1,10
    80005fa0:	4388                	lw	a0,0(a5)
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	e0e080e7          	jalr	-498(ra) # 80005db0 <printint>
      break;
    80005faa:	b771                	j	80005f36 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fac:	f8843783          	ld	a5,-120(s0)
    80005fb0:	00878713          	addi	a4,a5,8
    80005fb4:	f8e43423          	sd	a4,-120(s0)
    80005fb8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005fbc:	03000513          	li	a0,48
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	bd0080e7          	jalr	-1072(ra) # 80005b90 <consputc>
  consputc('x');
    80005fc8:	07800513          	li	a0,120
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	bc4080e7          	jalr	-1084(ra) # 80005b90 <consputc>
    80005fd4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fd6:	03c9d793          	srli	a5,s3,0x3c
    80005fda:	97de                	add	a5,a5,s7
    80005fdc:	0007c503          	lbu	a0,0(a5)
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	bb0080e7          	jalr	-1104(ra) # 80005b90 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fe8:	0992                	slli	s3,s3,0x4
    80005fea:	397d                	addiw	s2,s2,-1
    80005fec:	fe0915e3          	bnez	s2,80005fd6 <printf+0x13a>
    80005ff0:	b799                	j	80005f36 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ff2:	f8843783          	ld	a5,-120(s0)
    80005ff6:	00878713          	addi	a4,a5,8
    80005ffa:	f8e43423          	sd	a4,-120(s0)
    80005ffe:	0007b903          	ld	s2,0(a5)
    80006002:	00090e63          	beqz	s2,8000601e <printf+0x182>
      for(; *s; s++)
    80006006:	00094503          	lbu	a0,0(s2)
    8000600a:	d515                	beqz	a0,80005f36 <printf+0x9a>
        consputc(*s);
    8000600c:	00000097          	auipc	ra,0x0
    80006010:	b84080e7          	jalr	-1148(ra) # 80005b90 <consputc>
      for(; *s; s++)
    80006014:	0905                	addi	s2,s2,1
    80006016:	00094503          	lbu	a0,0(s2)
    8000601a:	f96d                	bnez	a0,8000600c <printf+0x170>
    8000601c:	bf29                	j	80005f36 <printf+0x9a>
        s = "(null)";
    8000601e:	00003917          	auipc	s2,0x3
    80006022:	80a90913          	addi	s2,s2,-2038 # 80008828 <syscalls+0x400>
      for(; *s; s++)
    80006026:	02800513          	li	a0,40
    8000602a:	b7cd                	j	8000600c <printf+0x170>
      consputc('%');
    8000602c:	8556                	mv	a0,s5
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	b62080e7          	jalr	-1182(ra) # 80005b90 <consputc>
      break;
    80006036:	b701                	j	80005f36 <printf+0x9a>
      consputc('%');
    80006038:	8556                	mv	a0,s5
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	b56080e7          	jalr	-1194(ra) # 80005b90 <consputc>
      consputc(c);
    80006042:	854a                	mv	a0,s2
    80006044:	00000097          	auipc	ra,0x0
    80006048:	b4c080e7          	jalr	-1204(ra) # 80005b90 <consputc>
      break;
    8000604c:	b5ed                	j	80005f36 <printf+0x9a>
  if(locking)
    8000604e:	020d9163          	bnez	s11,80006070 <printf+0x1d4>
}
    80006052:	70e6                	ld	ra,120(sp)
    80006054:	7446                	ld	s0,112(sp)
    80006056:	74a6                	ld	s1,104(sp)
    80006058:	7906                	ld	s2,96(sp)
    8000605a:	69e6                	ld	s3,88(sp)
    8000605c:	6a46                	ld	s4,80(sp)
    8000605e:	6aa6                	ld	s5,72(sp)
    80006060:	6b06                	ld	s6,64(sp)
    80006062:	7be2                	ld	s7,56(sp)
    80006064:	7c42                	ld	s8,48(sp)
    80006066:	7ca2                	ld	s9,40(sp)
    80006068:	7d02                	ld	s10,32(sp)
    8000606a:	6de2                	ld	s11,24(sp)
    8000606c:	6129                	addi	sp,sp,192
    8000606e:	8082                	ret
    release(&pr.lock);
    80006070:	0023c517          	auipc	a0,0x23c
    80006074:	ce850513          	addi	a0,a0,-792 # 80241d58 <pr>
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	3d8080e7          	jalr	984(ra) # 80006450 <release>
}
    80006080:	bfc9                	j	80006052 <printf+0x1b6>

0000000080006082 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006082:	1101                	addi	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000608c:	0023c497          	auipc	s1,0x23c
    80006090:	ccc48493          	addi	s1,s1,-820 # 80241d58 <pr>
    80006094:	00002597          	auipc	a1,0x2
    80006098:	7ac58593          	addi	a1,a1,1964 # 80008840 <syscalls+0x418>
    8000609c:	8526                	mv	a0,s1
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	26e080e7          	jalr	622(ra) # 8000630c <initlock>
  pr.locking = 1;
    800060a6:	4785                	li	a5,1
    800060a8:	cc9c                	sw	a5,24(s1)
}
    800060aa:	60e2                	ld	ra,24(sp)
    800060ac:	6442                	ld	s0,16(sp)
    800060ae:	64a2                	ld	s1,8(sp)
    800060b0:	6105                	addi	sp,sp,32
    800060b2:	8082                	ret

00000000800060b4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060b4:	1141                	addi	sp,sp,-16
    800060b6:	e406                	sd	ra,8(sp)
    800060b8:	e022                	sd	s0,0(sp)
    800060ba:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060bc:	100007b7          	lui	a5,0x10000
    800060c0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060c4:	f8000713          	li	a4,-128
    800060c8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060cc:	470d                	li	a4,3
    800060ce:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060d2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060d6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060da:	469d                	li	a3,7
    800060dc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060e0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060e4:	00002597          	auipc	a1,0x2
    800060e8:	77c58593          	addi	a1,a1,1916 # 80008860 <digits+0x18>
    800060ec:	0023c517          	auipc	a0,0x23c
    800060f0:	c8c50513          	addi	a0,a0,-884 # 80241d78 <uart_tx_lock>
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	218080e7          	jalr	536(ra) # 8000630c <initlock>
}
    800060fc:	60a2                	ld	ra,8(sp)
    800060fe:	6402                	ld	s0,0(sp)
    80006100:	0141                	addi	sp,sp,16
    80006102:	8082                	ret

0000000080006104 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006104:	1101                	addi	sp,sp,-32
    80006106:	ec06                	sd	ra,24(sp)
    80006108:	e822                	sd	s0,16(sp)
    8000610a:	e426                	sd	s1,8(sp)
    8000610c:	1000                	addi	s0,sp,32
    8000610e:	84aa                	mv	s1,a0
  push_off();
    80006110:	00000097          	auipc	ra,0x0
    80006114:	240080e7          	jalr	576(ra) # 80006350 <push_off>

  if(panicked){
    80006118:	00003797          	auipc	a5,0x3
    8000611c:	8147a783          	lw	a5,-2028(a5) # 8000892c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006120:	10000737          	lui	a4,0x10000
  if(panicked){
    80006124:	c391                	beqz	a5,80006128 <uartputc_sync+0x24>
    for(;;)
    80006126:	a001                	j	80006126 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006128:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000612c:	0ff7f793          	andi	a5,a5,255
    80006130:	0207f793          	andi	a5,a5,32
    80006134:	dbf5                	beqz	a5,80006128 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006136:	0ff4f793          	andi	a5,s1,255
    8000613a:	10000737          	lui	a4,0x10000
    8000613e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006142:	00000097          	auipc	ra,0x0
    80006146:	2ae080e7          	jalr	686(ra) # 800063f0 <pop_off>
}
    8000614a:	60e2                	ld	ra,24(sp)
    8000614c:	6442                	ld	s0,16(sp)
    8000614e:	64a2                	ld	s1,8(sp)
    80006150:	6105                	addi	sp,sp,32
    80006152:	8082                	ret

0000000080006154 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006154:	00002717          	auipc	a4,0x2
    80006158:	7dc73703          	ld	a4,2012(a4) # 80008930 <uart_tx_r>
    8000615c:	00002797          	auipc	a5,0x2
    80006160:	7dc7b783          	ld	a5,2012(a5) # 80008938 <uart_tx_w>
    80006164:	06e78c63          	beq	a5,a4,800061dc <uartstart+0x88>
{
    80006168:	7139                	addi	sp,sp,-64
    8000616a:	fc06                	sd	ra,56(sp)
    8000616c:	f822                	sd	s0,48(sp)
    8000616e:	f426                	sd	s1,40(sp)
    80006170:	f04a                	sd	s2,32(sp)
    80006172:	ec4e                	sd	s3,24(sp)
    80006174:	e852                	sd	s4,16(sp)
    80006176:	e456                	sd	s5,8(sp)
    80006178:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000617a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000617e:	0023ca17          	auipc	s4,0x23c
    80006182:	bfaa0a13          	addi	s4,s4,-1030 # 80241d78 <uart_tx_lock>
    uart_tx_r += 1;
    80006186:	00002497          	auipc	s1,0x2
    8000618a:	7aa48493          	addi	s1,s1,1962 # 80008930 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000618e:	00002997          	auipc	s3,0x2
    80006192:	7aa98993          	addi	s3,s3,1962 # 80008938 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006196:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000619a:	0ff7f793          	andi	a5,a5,255
    8000619e:	0207f793          	andi	a5,a5,32
    800061a2:	c785                	beqz	a5,800061ca <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061a4:	01f77793          	andi	a5,a4,31
    800061a8:	97d2                	add	a5,a5,s4
    800061aa:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061ae:	0705                	addi	a4,a4,1
    800061b0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061b2:	8526                	mv	a0,s1
    800061b4:	ffffb097          	auipc	ra,0xffffb
    800061b8:	54e080e7          	jalr	1358(ra) # 80001702 <wakeup>
    
    WriteReg(THR, c);
    800061bc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061c0:	6098                	ld	a4,0(s1)
    800061c2:	0009b783          	ld	a5,0(s3)
    800061c6:	fce798e3          	bne	a5,a4,80006196 <uartstart+0x42>
  }
}
    800061ca:	70e2                	ld	ra,56(sp)
    800061cc:	7442                	ld	s0,48(sp)
    800061ce:	74a2                	ld	s1,40(sp)
    800061d0:	7902                	ld	s2,32(sp)
    800061d2:	69e2                	ld	s3,24(sp)
    800061d4:	6a42                	ld	s4,16(sp)
    800061d6:	6aa2                	ld	s5,8(sp)
    800061d8:	6121                	addi	sp,sp,64
    800061da:	8082                	ret
    800061dc:	8082                	ret

00000000800061de <uartputc>:
{
    800061de:	7179                	addi	sp,sp,-48
    800061e0:	f406                	sd	ra,40(sp)
    800061e2:	f022                	sd	s0,32(sp)
    800061e4:	ec26                	sd	s1,24(sp)
    800061e6:	e84a                	sd	s2,16(sp)
    800061e8:	e44e                	sd	s3,8(sp)
    800061ea:	e052                	sd	s4,0(sp)
    800061ec:	1800                	addi	s0,sp,48
    800061ee:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061f0:	0023c517          	auipc	a0,0x23c
    800061f4:	b8850513          	addi	a0,a0,-1144 # 80241d78 <uart_tx_lock>
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	1a4080e7          	jalr	420(ra) # 8000639c <acquire>
  if(panicked){
    80006200:	00002797          	auipc	a5,0x2
    80006204:	72c7a783          	lw	a5,1836(a5) # 8000892c <panicked>
    80006208:	e7c9                	bnez	a5,80006292 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000620a:	00002797          	auipc	a5,0x2
    8000620e:	72e7b783          	ld	a5,1838(a5) # 80008938 <uart_tx_w>
    80006212:	00002717          	auipc	a4,0x2
    80006216:	71e73703          	ld	a4,1822(a4) # 80008930 <uart_tx_r>
    8000621a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000621e:	0023ca17          	auipc	s4,0x23c
    80006222:	b5aa0a13          	addi	s4,s4,-1190 # 80241d78 <uart_tx_lock>
    80006226:	00002497          	auipc	s1,0x2
    8000622a:	70a48493          	addi	s1,s1,1802 # 80008930 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622e:	00002917          	auipc	s2,0x2
    80006232:	70a90913          	addi	s2,s2,1802 # 80008938 <uart_tx_w>
    80006236:	00f71f63          	bne	a4,a5,80006254 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000623a:	85d2                	mv	a1,s4
    8000623c:	8526                	mv	a0,s1
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	460080e7          	jalr	1120(ra) # 8000169e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006246:	00093783          	ld	a5,0(s2)
    8000624a:	6098                	ld	a4,0(s1)
    8000624c:	02070713          	addi	a4,a4,32
    80006250:	fef705e3          	beq	a4,a5,8000623a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006254:	0023c497          	auipc	s1,0x23c
    80006258:	b2448493          	addi	s1,s1,-1244 # 80241d78 <uart_tx_lock>
    8000625c:	01f7f713          	andi	a4,a5,31
    80006260:	9726                	add	a4,a4,s1
    80006262:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006266:	0785                	addi	a5,a5,1
    80006268:	00002717          	auipc	a4,0x2
    8000626c:	6cf73823          	sd	a5,1744(a4) # 80008938 <uart_tx_w>
  uartstart();
    80006270:	00000097          	auipc	ra,0x0
    80006274:	ee4080e7          	jalr	-284(ra) # 80006154 <uartstart>
  release(&uart_tx_lock);
    80006278:	8526                	mv	a0,s1
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	1d6080e7          	jalr	470(ra) # 80006450 <release>
}
    80006282:	70a2                	ld	ra,40(sp)
    80006284:	7402                	ld	s0,32(sp)
    80006286:	64e2                	ld	s1,24(sp)
    80006288:	6942                	ld	s2,16(sp)
    8000628a:	69a2                	ld	s3,8(sp)
    8000628c:	6a02                	ld	s4,0(sp)
    8000628e:	6145                	addi	sp,sp,48
    80006290:	8082                	ret
    for(;;)
    80006292:	a001                	j	80006292 <uartputc+0xb4>

0000000080006294 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006294:	1141                	addi	sp,sp,-16
    80006296:	e422                	sd	s0,8(sp)
    80006298:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000629a:	100007b7          	lui	a5,0x10000
    8000629e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062a2:	8b85                	andi	a5,a5,1
    800062a4:	cb91                	beqz	a5,800062b8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062a6:	100007b7          	lui	a5,0x10000
    800062aa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062ae:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062b2:	6422                	ld	s0,8(sp)
    800062b4:	0141                	addi	sp,sp,16
    800062b6:	8082                	ret
    return -1;
    800062b8:	557d                	li	a0,-1
    800062ba:	bfe5                	j	800062b2 <uartgetc+0x1e>

00000000800062bc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062bc:	1101                	addi	sp,sp,-32
    800062be:	ec06                	sd	ra,24(sp)
    800062c0:	e822                	sd	s0,16(sp)
    800062c2:	e426                	sd	s1,8(sp)
    800062c4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062c6:	54fd                	li	s1,-1
    int c = uartgetc();
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	fcc080e7          	jalr	-52(ra) # 80006294 <uartgetc>
    if(c == -1)
    800062d0:	00950763          	beq	a0,s1,800062de <uartintr+0x22>
      break;
    consoleintr(c);
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	8fe080e7          	jalr	-1794(ra) # 80005bd2 <consoleintr>
  while(1){
    800062dc:	b7f5                	j	800062c8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062de:	0023c497          	auipc	s1,0x23c
    800062e2:	a9a48493          	addi	s1,s1,-1382 # 80241d78 <uart_tx_lock>
    800062e6:	8526                	mv	a0,s1
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	0b4080e7          	jalr	180(ra) # 8000639c <acquire>
  uartstart();
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	e64080e7          	jalr	-412(ra) # 80006154 <uartstart>
  release(&uart_tx_lock);
    800062f8:	8526                	mv	a0,s1
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	156080e7          	jalr	342(ra) # 80006450 <release>
}
    80006302:	60e2                	ld	ra,24(sp)
    80006304:	6442                	ld	s0,16(sp)
    80006306:	64a2                	ld	s1,8(sp)
    80006308:	6105                	addi	sp,sp,32
    8000630a:	8082                	ret

000000008000630c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000630c:	1141                	addi	sp,sp,-16
    8000630e:	e422                	sd	s0,8(sp)
    80006310:	0800                	addi	s0,sp,16
  lk->name = name;
    80006312:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006314:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006318:	00053823          	sd	zero,16(a0)
}
    8000631c:	6422                	ld	s0,8(sp)
    8000631e:	0141                	addi	sp,sp,16
    80006320:	8082                	ret

0000000080006322 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006322:	411c                	lw	a5,0(a0)
    80006324:	e399                	bnez	a5,8000632a <holding+0x8>
    80006326:	4501                	li	a0,0
  return r;
}
    80006328:	8082                	ret
{
    8000632a:	1101                	addi	sp,sp,-32
    8000632c:	ec06                	sd	ra,24(sp)
    8000632e:	e822                	sd	s0,16(sp)
    80006330:	e426                	sd	s1,8(sp)
    80006332:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006334:	6904                	ld	s1,16(a0)
    80006336:	ffffb097          	auipc	ra,0xffffb
    8000633a:	ca4080e7          	jalr	-860(ra) # 80000fda <mycpu>
    8000633e:	40a48533          	sub	a0,s1,a0
    80006342:	00153513          	seqz	a0,a0
}
    80006346:	60e2                	ld	ra,24(sp)
    80006348:	6442                	ld	s0,16(sp)
    8000634a:	64a2                	ld	s1,8(sp)
    8000634c:	6105                	addi	sp,sp,32
    8000634e:	8082                	ret

0000000080006350 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006350:	1101                	addi	sp,sp,-32
    80006352:	ec06                	sd	ra,24(sp)
    80006354:	e822                	sd	s0,16(sp)
    80006356:	e426                	sd	s1,8(sp)
    80006358:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000635a:	100024f3          	csrr	s1,sstatus
    8000635e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006362:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006364:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006368:	ffffb097          	auipc	ra,0xffffb
    8000636c:	c72080e7          	jalr	-910(ra) # 80000fda <mycpu>
    80006370:	5d3c                	lw	a5,120(a0)
    80006372:	cf89                	beqz	a5,8000638c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006374:	ffffb097          	auipc	ra,0xffffb
    80006378:	c66080e7          	jalr	-922(ra) # 80000fda <mycpu>
    8000637c:	5d3c                	lw	a5,120(a0)
    8000637e:	2785                	addiw	a5,a5,1
    80006380:	dd3c                	sw	a5,120(a0)
}
    80006382:	60e2                	ld	ra,24(sp)
    80006384:	6442                	ld	s0,16(sp)
    80006386:	64a2                	ld	s1,8(sp)
    80006388:	6105                	addi	sp,sp,32
    8000638a:	8082                	ret
    mycpu()->intena = old;
    8000638c:	ffffb097          	auipc	ra,0xffffb
    80006390:	c4e080e7          	jalr	-946(ra) # 80000fda <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006394:	8085                	srli	s1,s1,0x1
    80006396:	8885                	andi	s1,s1,1
    80006398:	dd64                	sw	s1,124(a0)
    8000639a:	bfe9                	j	80006374 <push_off+0x24>

000000008000639c <acquire>:
{
    8000639c:	1101                	addi	sp,sp,-32
    8000639e:	ec06                	sd	ra,24(sp)
    800063a0:	e822                	sd	s0,16(sp)
    800063a2:	e426                	sd	s1,8(sp)
    800063a4:	1000                	addi	s0,sp,32
    800063a6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	fa8080e7          	jalr	-88(ra) # 80006350 <push_off>
  if(holding(lk))
    800063b0:	8526                	mv	a0,s1
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	f70080e7          	jalr	-144(ra) # 80006322 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ba:	4705                	li	a4,1
  if(holding(lk))
    800063bc:	e115                	bnez	a0,800063e0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063be:	87ba                	mv	a5,a4
    800063c0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063c4:	2781                	sext.w	a5,a5
    800063c6:	ffe5                	bnez	a5,800063be <acquire+0x22>
  __sync_synchronize();
    800063c8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	c0e080e7          	jalr	-1010(ra) # 80000fda <mycpu>
    800063d4:	e888                	sd	a0,16(s1)
}
    800063d6:	60e2                	ld	ra,24(sp)
    800063d8:	6442                	ld	s0,16(sp)
    800063da:	64a2                	ld	s1,8(sp)
    800063dc:	6105                	addi	sp,sp,32
    800063de:	8082                	ret
    panic("acquire");
    800063e0:	00002517          	auipc	a0,0x2
    800063e4:	48850513          	addi	a0,a0,1160 # 80008868 <digits+0x20>
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	a6a080e7          	jalr	-1430(ra) # 80005e52 <panic>

00000000800063f0 <pop_off>:

void
pop_off(void)
{
    800063f0:	1141                	addi	sp,sp,-16
    800063f2:	e406                	sd	ra,8(sp)
    800063f4:	e022                	sd	s0,0(sp)
    800063f6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063f8:	ffffb097          	auipc	ra,0xffffb
    800063fc:	be2080e7          	jalr	-1054(ra) # 80000fda <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006400:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006404:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006406:	e78d                	bnez	a5,80006430 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006408:	5d3c                	lw	a5,120(a0)
    8000640a:	02f05b63          	blez	a5,80006440 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000640e:	37fd                	addiw	a5,a5,-1
    80006410:	0007871b          	sext.w	a4,a5
    80006414:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006416:	eb09                	bnez	a4,80006428 <pop_off+0x38>
    80006418:	5d7c                	lw	a5,124(a0)
    8000641a:	c799                	beqz	a5,80006428 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000641c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006420:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006424:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006428:	60a2                	ld	ra,8(sp)
    8000642a:	6402                	ld	s0,0(sp)
    8000642c:	0141                	addi	sp,sp,16
    8000642e:	8082                	ret
    panic("pop_off - interruptible");
    80006430:	00002517          	auipc	a0,0x2
    80006434:	44050513          	addi	a0,a0,1088 # 80008870 <digits+0x28>
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	a1a080e7          	jalr	-1510(ra) # 80005e52 <panic>
    panic("pop_off");
    80006440:	00002517          	auipc	a0,0x2
    80006444:	44850513          	addi	a0,a0,1096 # 80008888 <digits+0x40>
    80006448:	00000097          	auipc	ra,0x0
    8000644c:	a0a080e7          	jalr	-1526(ra) # 80005e52 <panic>

0000000080006450 <release>:
{
    80006450:	1101                	addi	sp,sp,-32
    80006452:	ec06                	sd	ra,24(sp)
    80006454:	e822                	sd	s0,16(sp)
    80006456:	e426                	sd	s1,8(sp)
    80006458:	1000                	addi	s0,sp,32
    8000645a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000645c:	00000097          	auipc	ra,0x0
    80006460:	ec6080e7          	jalr	-314(ra) # 80006322 <holding>
    80006464:	c115                	beqz	a0,80006488 <release+0x38>
  lk->cpu = 0;
    80006466:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000646a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000646e:	0f50000f          	fence	iorw,ow
    80006472:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006476:	00000097          	auipc	ra,0x0
    8000647a:	f7a080e7          	jalr	-134(ra) # 800063f0 <pop_off>
}
    8000647e:	60e2                	ld	ra,24(sp)
    80006480:	6442                	ld	s0,16(sp)
    80006482:	64a2                	ld	s1,8(sp)
    80006484:	6105                	addi	sp,sp,32
    80006486:	8082                	ret
    panic("release");
    80006488:	00002517          	auipc	a0,0x2
    8000648c:	40850513          	addi	a0,a0,1032 # 80008890 <digits+0x48>
    80006490:	00000097          	auipc	ra,0x0
    80006494:	9c2080e7          	jalr	-1598(ra) # 80005e52 <panic>
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
