
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1f7050ef          	jal	ra,80005a0c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fe078793          	addi	a5,a5,-32 # 80022010 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	95090913          	addi	s2,s2,-1712 # 800089a0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3b2080e7          	jalr	946(ra) # 8000640c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	452080e7          	jalr	1106(ra) # 800064c0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	e38080e7          	jalr	-456(ra) # 80005ec2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	8b450513          	addi	a0,a0,-1868 # 800089a0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	288080e7          	jalr	648(ra) # 8000637c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	f1050513          	addi	a0,a0,-240 # 80022010 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	87e48493          	addi	s1,s1,-1922 # 800089a0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	2e0080e7          	jalr	736(ra) # 8000640c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	86650513          	addi	a0,a0,-1946 # 800089a0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	37c080e7          	jalr	892(ra) # 800064c0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	83a50513          	addi	a0,a0,-1990 # 800089a0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	352080e7          	jalr	850(ra) # 800064c0 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	c4a080e7          	jalr	-950(ra) # 80000f78 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	62a70713          	addi	a4,a4,1578 # 80008960 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	c2e080e7          	jalr	-978(ra) # 80000f78 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	bb0080e7          	jalr	-1104(ra) # 80005f0c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	98a080e7          	jalr	-1654(ra) # 80001cf6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	fec080e7          	jalr	-20(ra) # 80005360 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	1d4080e7          	jalr	468(ra) # 80001550 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a50080e7          	jalr	-1456(ra) # 80005dd4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	d66080e7          	jalr	-666(ra) # 800060f2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	b70080e7          	jalr	-1168(ra) # 80005f0c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	b60080e7          	jalr	-1184(ra) # 80005f0c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	b50080e7          	jalr	-1200(ra) # 80005f0c <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	34a080e7          	jalr	842(ra) # 80000716 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	aea080e7          	jalr	-1302(ra) # 80000ec6 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	8ea080e7          	jalr	-1814(ra) # 80001cce <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	90a080e7          	jalr	-1782(ra) # 80001cf6 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f56080e7          	jalr	-170(ra) # 8000534a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f64080e7          	jalr	-156(ra) # 80005360 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	0fa080e7          	jalr	250(ra) # 800024fe <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	79e080e7          	jalr	1950(ra) # 80002baa <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	73c080e7          	jalr	1852(ra) # 80003b50 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	04c080e7          	jalr	76(ra) # 80005468 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	f12080e7          	jalr	-238(ra) # 80001336 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	52f72723          	sw	a5,1326(a4) # 80008960 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	52a7b783          	ld	a5,1322(a5) # 80008970 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	a30080e7          	jalr	-1488(ra) # 80005ec2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000562:	03459793          	slli	a5,a1,0x34
    80000566:	e385                	bnez	a5,80000586 <mappages+0x3a>
    80000568:	8aaa                	mv	s5,a0
    8000056a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000056c:	03461793          	slli	a5,a2,0x34
    80000570:	e39d                	bnez	a5,80000596 <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    80000572:	ca15                	beqz	a2,800005a6 <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000574:	79fd                	lui	s3,0xfffff
    80000576:	964e                	add	a2,a2,s3
    80000578:	00b609b3          	add	s3,a2,a1
  a = va;
    8000057c:	892e                	mv	s2,a1
    8000057e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000582:	6b85                	lui	s7,0x1
    80000584:	a091                	j	800005c8 <mappages+0x7c>
    panic("mappages: va not aligned");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ad250513          	addi	a0,a0,-1326 # 80008058 <etext+0x58>
    8000058e:	00006097          	auipc	ra,0x6
    80000592:	934080e7          	jalr	-1740(ra) # 80005ec2 <panic>
    panic("mappages: size not aligned");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ae250513          	addi	a0,a0,-1310 # 80008078 <etext+0x78>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	924080e7          	jalr	-1756(ra) # 80005ec2 <panic>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	af250513          	addi	a0,a0,-1294 # 80008098 <etext+0x98>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	914080e7          	jalr	-1772(ra) # 80005ec2 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	af250513          	addi	a0,a0,-1294 # 800080a8 <etext+0xa8>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	904080e7          	jalr	-1788(ra) # 80005ec2 <panic>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
  for(;;){
    800005c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	4605                	li	a2,1
    800005ce:	85ca                	mv	a1,s2
    800005d0:	8556                	mv	a0,s5
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	e92080e7          	jalr	-366(ra) # 80000464 <walk>
    800005da:	cd19                	beqz	a0,800005f8 <mappages+0xac>
    if(*pte & PTE_V)
    800005dc:	611c                	ld	a5,0(a0)
    800005de:	8b85                	andi	a5,a5,1
    800005e0:	fbf9                	bnez	a5,800005b6 <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e2:	80b1                	srli	s1,s1,0xc
    800005e4:	04aa                	slli	s1,s1,0xa
    800005e6:	0164e4b3          	or	s1,s1,s6
    800005ea:	0014e493          	ori	s1,s1,1
    800005ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800005f0:	fd391be3          	bne	s2,s3,800005c6 <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	a011                	j	800005fa <mappages+0xae>
      return -1;
    800005f8:	557d                	li	a0,-1
}
    800005fa:	60a6                	ld	ra,72(sp)
    800005fc:	6406                	ld	s0,64(sp)
    800005fe:	74e2                	ld	s1,56(sp)
    80000600:	7942                	ld	s2,48(sp)
    80000602:	79a2                	ld	s3,40(sp)
    80000604:	7a02                	ld	s4,32(sp)
    80000606:	6ae2                	ld	s5,24(sp)
    80000608:	6b42                	ld	s6,16(sp)
    8000060a:	6ba2                	ld	s7,8(sp)
    8000060c:	6161                	addi	sp,sp,80
    8000060e:	8082                	ret

0000000080000610 <kvmmap>:
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    80000618:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061a:	86b2                	mv	a3,a2
    8000061c:	863e                	mv	a2,a5
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f2e080e7          	jalr	-210(ra) # 8000054c <mappages>
    80000626:	e509                	bnez	a0,80000630 <kvmmap+0x20>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
    panic("kvmmap");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a8850513          	addi	a0,a0,-1400 # 800080b8 <etext+0xb8>
    80000638:	00006097          	auipc	ra,0x6
    8000063c:	88a080e7          	jalr	-1910(ra) # 80005ec2 <panic>

0000000080000640 <kvmmake>:
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	e04a                	sd	s2,0(sp)
    8000064a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	acc080e7          	jalr	-1332(ra) # 80000118 <kalloc>
    80000654:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000656:	6605                	lui	a2,0x1
    80000658:	4581                	li	a1,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	b1e080e7          	jalr	-1250(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10000637          	lui	a2,0x10000
    8000066a:	100005b7          	lui	a1,0x10000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	fa0080e7          	jalr	-96(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	6685                	lui	a3,0x1
    8000067c:	10001637          	lui	a2,0x10001
    80000680:	100015b7          	lui	a1,0x10001
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f8a080e7          	jalr	-118(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	004006b7          	lui	a3,0x400
    80000694:	0c000637          	lui	a2,0xc000
    80000698:	0c0005b7          	lui	a1,0xc000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f72080e7          	jalr	-142(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a6:	00008917          	auipc	s2,0x8
    800006aa:	95a90913          	addi	s2,s2,-1702 # 80008000 <etext>
    800006ae:	4729                	li	a4,10
    800006b0:	80008697          	auipc	a3,0x80008
    800006b4:	95068693          	addi	a3,a3,-1712 # 8000 <_entry-0x7fff8000>
    800006b8:	4605                	li	a2,1
    800006ba:	067e                	slli	a2,a2,0x1f
    800006bc:	85b2                	mv	a1,a2
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f50080e7          	jalr	-176(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	46c5                	li	a3,17
    800006cc:	06ee                	slli	a3,a3,0x1b
    800006ce:	412686b3          	sub	a3,a3,s2
    800006d2:	864a                	mv	a2,s2
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f38080e7          	jalr	-200(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e0:	4729                	li	a4,10
    800006e2:	6685                	lui	a3,0x1
    800006e4:	00007617          	auipc	a2,0x7
    800006e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800006ec:	040005b7          	lui	a1,0x4000
    800006f0:	15fd                	addi	a1,a1,-1
    800006f2:	05b2                	slli	a1,a1,0xc
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f1a080e7          	jalr	-230(ra) # 80000610 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	732080e7          	jalr	1842(ra) # 80000e32 <proc_mapstacks>
}
    80000708:	8526                	mv	a0,s1
    8000070a:	60e2                	ld	ra,24(sp)
    8000070c:	6442                	ld	s0,16(sp)
    8000070e:	64a2                	ld	s1,8(sp)
    80000710:	6902                	ld	s2,0(sp)
    80000712:	6105                	addi	sp,sp,32
    80000714:	8082                	ret

0000000080000716 <kvminit>:
{
    80000716:	1141                	addi	sp,sp,-16
    80000718:	e406                	sd	ra,8(sp)
    8000071a:	e022                	sd	s0,0(sp)
    8000071c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f22080e7          	jalr	-222(ra) # 80000640 <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	24a7b523          	sd	a0,586(a5) # 80008970 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000736:	715d                	addi	sp,sp,-80
    80000738:	e486                	sd	ra,72(sp)
    8000073a:	e0a2                	sd	s0,64(sp)
    8000073c:	fc26                	sd	s1,56(sp)
    8000073e:	f84a                	sd	s2,48(sp)
    80000740:	f44e                	sd	s3,40(sp)
    80000742:	f052                	sd	s4,32(sp)
    80000744:	ec56                	sd	s5,24(sp)
    80000746:	e85a                	sd	s6,16(sp)
    80000748:	e45e                	sd	s7,8(sp)
    8000074a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074c:	03459793          	slli	a5,a1,0x34
    80000750:	e795                	bnez	a5,8000077c <uvmunmap+0x46>
    80000752:	8a2a                	mv	s4,a0
    80000754:	892e                	mv	s2,a1
    80000756:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	0632                	slli	a2,a2,0xc
    8000075a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000760:	6b05                	lui	s6,0x1
    80000762:	0735e863          	bltu	a1,s3,800007d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000766:	60a6                	ld	ra,72(sp)
    80000768:	6406                	ld	s0,64(sp)
    8000076a:	74e2                	ld	s1,56(sp)
    8000076c:	7942                	ld	s2,48(sp)
    8000076e:	79a2                	ld	s3,40(sp)
    80000770:	7a02                	ld	s4,32(sp)
    80000772:	6ae2                	ld	s5,24(sp)
    80000774:	6b42                	ld	s6,16(sp)
    80000776:	6ba2                	ld	s7,8(sp)
    80000778:	6161                	addi	sp,sp,80
    8000077a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	73e080e7          	jalr	1854(ra) # 80005ec2 <panic>
      panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	94c50513          	addi	a0,a0,-1716 # 800080d8 <etext+0xd8>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	72e080e7          	jalr	1838(ra) # 80005ec2 <panic>
      panic("uvmunmap: not mapped");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	94c50513          	addi	a0,a0,-1716 # 800080e8 <etext+0xe8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	71e080e7          	jalr	1822(ra) # 80005ec2 <panic>
      panic("uvmunmap: not a leaf");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	95450513          	addi	a0,a0,-1708 # 80008100 <etext+0x100>
    800007b4:	00005097          	auipc	ra,0x5
    800007b8:	70e080e7          	jalr	1806(ra) # 80005ec2 <panic>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    *pte = 0;
    800007c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007cc:	995a                	add	s2,s2,s6
    800007ce:	f9397ce3          	bgeu	s2,s3,80000766 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d2:	4601                	li	a2,0
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8552                	mv	a0,s4
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	c8c080e7          	jalr	-884(ra) # 80000464 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	d54d                	beqz	a0,8000078c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e4:	6108                	ld	a0,0(a0)
    800007e6:	00157793          	andi	a5,a0,1
    800007ea:	dbcd                	beqz	a5,8000079c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff57793          	andi	a5,a0,1023
    800007f0:	fb778ee3          	beq	a5,s7,800007ac <uvmunmap+0x76>
    if(do_free){
    800007f4:	fc0a8ae3          	beqz	s5,800007c8 <uvmunmap+0x92>
    800007f8:	b7d1                	j	800007bc <uvmunmap+0x86>

00000000800007fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000804:	00000097          	auipc	ra,0x0
    80000808:	914080e7          	jalr	-1772(ra) # 80000118 <kalloc>
    8000080c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080e:	c519                	beqz	a0,8000081c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000810:	6605                	lui	a2,0x1
    80000812:	4581                	li	a1,0
    80000814:	00000097          	auipc	ra,0x0
    80000818:	964080e7          	jalr	-1692(ra) # 80000178 <memset>
  return pagetable;
}
    8000081c:	8526                	mv	a0,s1
    8000081e:	60e2                	ld	ra,24(sp)
    80000820:	6442                	ld	s0,16(sp)
    80000822:	64a2                	ld	s1,8(sp)
    80000824:	6105                	addi	sp,sp,32
    80000826:	8082                	ret

0000000080000828 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000828:	7179                	addi	sp,sp,-48
    8000082a:	f406                	sd	ra,40(sp)
    8000082c:	f022                	sd	s0,32(sp)
    8000082e:	ec26                	sd	s1,24(sp)
    80000830:	e84a                	sd	s2,16(sp)
    80000832:	e44e                	sd	s3,8(sp)
    80000834:	e052                	sd	s4,0(sp)
    80000836:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000838:	6785                	lui	a5,0x1
    8000083a:	04f67863          	bgeu	a2,a5,8000088a <uvmfirst+0x62>
    8000083e:	8a2a                	mv	s4,a0
    80000840:	89ae                	mv	s3,a1
    80000842:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	8d4080e7          	jalr	-1836(ra) # 80000118 <kalloc>
    8000084c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084e:	6605                	lui	a2,0x1
    80000850:	4581                	li	a1,0
    80000852:	00000097          	auipc	ra,0x0
    80000856:	926080e7          	jalr	-1754(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085a:	4779                	li	a4,30
    8000085c:	86ca                	mv	a3,s2
    8000085e:	6605                	lui	a2,0x1
    80000860:	4581                	li	a1,0
    80000862:	8552                	mv	a0,s4
    80000864:	00000097          	auipc	ra,0x0
    80000868:	ce8080e7          	jalr	-792(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    8000086c:	8626                	mv	a2,s1
    8000086e:	85ce                	mv	a1,s3
    80000870:	854a                	mv	a0,s2
    80000872:	00000097          	auipc	ra,0x0
    80000876:	966080e7          	jalr	-1690(ra) # 800001d8 <memmove>
}
    8000087a:	70a2                	ld	ra,40(sp)
    8000087c:	7402                	ld	s0,32(sp)
    8000087e:	64e2                	ld	s1,24(sp)
    80000880:	6942                	ld	s2,16(sp)
    80000882:	69a2                	ld	s3,8(sp)
    80000884:	6a02                	ld	s4,0(sp)
    80000886:	6145                	addi	sp,sp,48
    80000888:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	88e50513          	addi	a0,a0,-1906 # 80008118 <etext+0x118>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	630080e7          	jalr	1584(ra) # 80005ec2 <panic>

000000008000089a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089a:	1101                	addi	sp,sp,-32
    8000089c:	ec06                	sd	ra,24(sp)
    8000089e:	e822                	sd	s0,16(sp)
    800008a0:	e426                	sd	s1,8(sp)
    800008a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a6:	00b67d63          	bgeu	a2,a1,800008c0 <uvmdealloc+0x26>
    800008aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ac:	6785                	lui	a5,0x1
    800008ae:	17fd                	addi	a5,a5,-1
    800008b0:	00f60733          	add	a4,a2,a5
    800008b4:	767d                	lui	a2,0xfffff
    800008b6:	8f71                	and	a4,a4,a2
    800008b8:	97ae                	add	a5,a5,a1
    800008ba:	8ff1                	and	a5,a5,a2
    800008bc:	00f76863          	bltu	a4,a5,800008cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c0:	8526                	mv	a0,s1
    800008c2:	60e2                	ld	ra,24(sp)
    800008c4:	6442                	ld	s0,16(sp)
    800008c6:	64a2                	ld	s1,8(sp)
    800008c8:	6105                	addi	sp,sp,32
    800008ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008cc:	8f99                	sub	a5,a5,a4
    800008ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d0:	4685                	li	a3,1
    800008d2:	0007861b          	sext.w	a2,a5
    800008d6:	85ba                	mv	a1,a4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	e5e080e7          	jalr	-418(ra) # 80000736 <uvmunmap>
    800008e0:	b7c5                	j	800008c0 <uvmdealloc+0x26>

00000000800008e2 <uvmalloc>:
  if(newsz < oldsz)
    800008e2:	0ab66563          	bltu	a2,a1,8000098c <uvmalloc+0xaa>
{
    800008e6:	7139                	addi	sp,sp,-64
    800008e8:	fc06                	sd	ra,56(sp)
    800008ea:	f822                	sd	s0,48(sp)
    800008ec:	f426                	sd	s1,40(sp)
    800008ee:	f04a                	sd	s2,32(sp)
    800008f0:	ec4e                	sd	s3,24(sp)
    800008f2:	e852                	sd	s4,16(sp)
    800008f4:	e456                	sd	s5,8(sp)
    800008f6:	e05a                	sd	s6,0(sp)
    800008f8:	0080                	addi	s0,sp,64
    800008fa:	8aaa                	mv	s5,a0
    800008fc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fe:	6985                	lui	s3,0x1
    80000900:	19fd                	addi	s3,s3,-1
    80000902:	95ce                	add	a1,a1,s3
    80000904:	79fd                	lui	s3,0xfffff
    80000906:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	08c9f363          	bgeu	s3,a2,80000990 <uvmalloc+0xae>
    8000090e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000910:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000914:	00000097          	auipc	ra,0x0
    80000918:	804080e7          	jalr	-2044(ra) # 80000118 <kalloc>
    8000091c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091e:	c51d                	beqz	a0,8000094c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000920:	6605                	lui	a2,0x1
    80000922:	4581                	li	a1,0
    80000924:	00000097          	auipc	ra,0x0
    80000928:	854080e7          	jalr	-1964(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092c:	875a                	mv	a4,s6
    8000092e:	86a6                	mv	a3,s1
    80000930:	6605                	lui	a2,0x1
    80000932:	85ca                	mv	a1,s2
    80000934:	8556                	mv	a0,s5
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	c16080e7          	jalr	-1002(ra) # 8000054c <mappages>
    8000093e:	e90d                	bnez	a0,80000970 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000940:	6785                	lui	a5,0x1
    80000942:	993e                	add	s2,s2,a5
    80000944:	fd4968e3          	bltu	s2,s4,80000914 <uvmalloc+0x32>
  return newsz;
    80000948:	8552                	mv	a0,s4
    8000094a:	a809                	j	8000095c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000094c:	864e                	mv	a2,s3
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	f48080e7          	jalr	-184(ra) # 8000089a <uvmdealloc>
      return 0;
    8000095a:	4501                	li	a0,0
}
    8000095c:	70e2                	ld	ra,56(sp)
    8000095e:	7442                	ld	s0,48(sp)
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	69e2                	ld	s3,24(sp)
    80000966:	6a42                	ld	s4,16(sp)
    80000968:	6aa2                	ld	s5,8(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret
      kfree(mem);
    80000970:	8526                	mv	a0,s1
    80000972:	fffff097          	auipc	ra,0xfffff
    80000976:	6aa080e7          	jalr	1706(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097a:	864e                	mv	a2,s3
    8000097c:	85ca                	mv	a1,s2
    8000097e:	8556                	mv	a0,s5
    80000980:	00000097          	auipc	ra,0x0
    80000984:	f1a080e7          	jalr	-230(ra) # 8000089a <uvmdealloc>
      return 0;
    80000988:	4501                	li	a0,0
    8000098a:	bfc9                	j	8000095c <uvmalloc+0x7a>
    return oldsz;
    8000098c:	852e                	mv	a0,a1
}
    8000098e:	8082                	ret
  return newsz;
    80000990:	8532                	mv	a0,a2
    80000992:	b7e9                	j	8000095c <uvmalloc+0x7a>

0000000080000994 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000994:	7179                	addi	sp,sp,-48
    80000996:	f406                	sd	ra,40(sp)
    80000998:	f022                	sd	s0,32(sp)
    8000099a:	ec26                	sd	s1,24(sp)
    8000099c:	e84a                	sd	s2,16(sp)
    8000099e:	e44e                	sd	s3,8(sp)
    800009a0:	e052                	sd	s4,0(sp)
    800009a2:	1800                	addi	s0,sp,48
    800009a4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a6:	84aa                	mv	s1,a0
    800009a8:	6905                	lui	s2,0x1
    800009aa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ac:	4985                	li	s3,1
    800009ae:	a821                	j	800009c6 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009b0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009b2:	0532                	slli	a0,a0,0xc
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	fe0080e7          	jalr	-32(ra) # 80000994 <freewalk>
      pagetable[i] = 0;
    800009bc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009c0:	04a1                	addi	s1,s1,8
    800009c2:	03248163          	beq	s1,s2,800009e4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009c6:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c8:	00f57793          	andi	a5,a0,15
    800009cc:	ff3782e3          	beq	a5,s3,800009b0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009d0:	8905                	andi	a0,a0,1
    800009d2:	d57d                	beqz	a0,800009c0 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009d4:	00007517          	auipc	a0,0x7
    800009d8:	76450513          	addi	a0,a0,1892 # 80008138 <etext+0x138>
    800009dc:	00005097          	auipc	ra,0x5
    800009e0:	4e6080e7          	jalr	1254(ra) # 80005ec2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009e4:	8552                	mv	a0,s4
    800009e6:	fffff097          	auipc	ra,0xfffff
    800009ea:	636080e7          	jalr	1590(ra) # 8000001c <kfree>
}
    800009ee:	70a2                	ld	ra,40(sp)
    800009f0:	7402                	ld	s0,32(sp)
    800009f2:	64e2                	ld	s1,24(sp)
    800009f4:	6942                	ld	s2,16(sp)
    800009f6:	69a2                	ld	s3,8(sp)
    800009f8:	6a02                	ld	s4,0(sp)
    800009fa:	6145                	addi	sp,sp,48
    800009fc:	8082                	ret

00000000800009fe <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
    80000a08:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a0a:	e999                	bnez	a1,80000a20 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	f86080e7          	jalr	-122(ra) # 80000994 <freewalk>
}
    80000a16:	60e2                	ld	ra,24(sp)
    80000a18:	6442                	ld	s0,16(sp)
    80000a1a:	64a2                	ld	s1,8(sp)
    80000a1c:	6105                	addi	sp,sp,32
    80000a1e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	167d                	addi	a2,a2,-1
    80000a24:	962e                	add	a2,a2,a1
    80000a26:	4685                	li	a3,1
    80000a28:	8231                	srli	a2,a2,0xc
    80000a2a:	4581                	li	a1,0
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	d0a080e7          	jalr	-758(ra) # 80000736 <uvmunmap>
    80000a34:	bfe1                	j	80000a0c <uvmfree+0xe>

0000000080000a36 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	c679                	beqz	a2,80000b04 <uvmcopy+0xce>
{
    80000a38:	715d                	addi	sp,sp,-80
    80000a3a:	e486                	sd	ra,72(sp)
    80000a3c:	e0a2                	sd	s0,64(sp)
    80000a3e:	fc26                	sd	s1,56(sp)
    80000a40:	f84a                	sd	s2,48(sp)
    80000a42:	f44e                	sd	s3,40(sp)
    80000a44:	f052                	sd	s4,32(sp)
    80000a46:	ec56                	sd	s5,24(sp)
    80000a48:	e85a                	sd	s6,16(sp)
    80000a4a:	e45e                	sd	s7,8(sp)
    80000a4c:	0880                	addi	s0,sp,80
    80000a4e:	8b2a                	mv	s6,a0
    80000a50:	8aae                	mv	s5,a1
    80000a52:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a56:	4601                	li	a2,0
    80000a58:	85ce                	mv	a1,s3
    80000a5a:	855a                	mv	a0,s6
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	a08080e7          	jalr	-1528(ra) # 80000464 <walk>
    80000a64:	c531                	beqz	a0,80000ab0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a66:	6118                	ld	a4,0(a0)
    80000a68:	00177793          	andi	a5,a4,1
    80000a6c:	cbb1                	beqz	a5,80000ac0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6e:	00a75593          	srli	a1,a4,0xa
    80000a72:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a76:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	69e080e7          	jalr	1694(ra) # 80000118 <kalloc>
    80000a82:	892a                	mv	s2,a0
    80000a84:	c939                	beqz	a0,80000ada <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a86:	6605                	lui	a2,0x1
    80000a88:	85de                	mv	a1,s7
    80000a8a:	fffff097          	auipc	ra,0xfffff
    80000a8e:	74e080e7          	jalr	1870(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a92:	8726                	mv	a4,s1
    80000a94:	86ca                	mv	a3,s2
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85ce                	mv	a1,s3
    80000a9a:	8556                	mv	a0,s5
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	ab0080e7          	jalr	-1360(ra) # 8000054c <mappages>
    80000aa4:	e515                	bnez	a0,80000ad0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa6:	6785                	lui	a5,0x1
    80000aa8:	99be                	add	s3,s3,a5
    80000aaa:	fb49e6e3          	bltu	s3,s4,80000a56 <uvmcopy+0x20>
    80000aae:	a081                	j	80000aee <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	69850513          	addi	a0,a0,1688 # 80008148 <etext+0x148>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	40a080e7          	jalr	1034(ra) # 80005ec2 <panic>
      panic("uvmcopy: page not present");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	6a850513          	addi	a0,a0,1704 # 80008168 <etext+0x168>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	3fa080e7          	jalr	1018(ra) # 80005ec2 <panic>
      kfree(mem);
    80000ad0:	854a                	mv	a0,s2
    80000ad2:	fffff097          	auipc	ra,0xfffff
    80000ad6:	54a080e7          	jalr	1354(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ada:	4685                	li	a3,1
    80000adc:	00c9d613          	srli	a2,s3,0xc
    80000ae0:	4581                	li	a1,0
    80000ae2:	8556                	mv	a0,s5
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	c52080e7          	jalr	-942(ra) # 80000736 <uvmunmap>
  return -1;
    80000aec:	557d                	li	a0,-1
}
    80000aee:	60a6                	ld	ra,72(sp)
    80000af0:	6406                	ld	s0,64(sp)
    80000af2:	74e2                	ld	s1,56(sp)
    80000af4:	7942                	ld	s2,48(sp)
    80000af6:	79a2                	ld	s3,40(sp)
    80000af8:	7a02                	ld	s4,32(sp)
    80000afa:	6ae2                	ld	s5,24(sp)
    80000afc:	6b42                	ld	s6,16(sp)
    80000afe:	6ba2                	ld	s7,8(sp)
    80000b00:	6161                	addi	sp,sp,80
    80000b02:	8082                	ret
  return 0;
    80000b04:	4501                	li	a0,0
}
    80000b06:	8082                	ret

0000000080000b08 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b08:	1141                	addi	sp,sp,-16
    80000b0a:	e406                	sd	ra,8(sp)
    80000b0c:	e022                	sd	s0,0(sp)
    80000b0e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b10:	4601                	li	a2,0
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	952080e7          	jalr	-1710(ra) # 80000464 <walk>
  if(pte == 0)
    80000b1a:	c901                	beqz	a0,80000b2a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1c:	611c                	ld	a5,0(a0)
    80000b1e:	9bbd                	andi	a5,a5,-17
    80000b20:	e11c                	sd	a5,0(a0)
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret
    panic("uvmclear");
    80000b2a:	00007517          	auipc	a0,0x7
    80000b2e:	65e50513          	addi	a0,a0,1630 # 80008188 <etext+0x188>
    80000b32:	00005097          	auipc	ra,0x5
    80000b36:	390080e7          	jalr	912(ra) # 80005ec2 <panic>

0000000080000b3a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b3a:	cac9                	beqz	a3,80000bcc <copyout+0x92>
{
    80000b3c:	711d                	addi	sp,sp,-96
    80000b3e:	ec86                	sd	ra,88(sp)
    80000b40:	e8a2                	sd	s0,80(sp)
    80000b42:	e4a6                	sd	s1,72(sp)
    80000b44:	e0ca                	sd	s2,64(sp)
    80000b46:	fc4e                	sd	s3,56(sp)
    80000b48:	f852                	sd	s4,48(sp)
    80000b4a:	f456                	sd	s5,40(sp)
    80000b4c:	f05a                	sd	s6,32(sp)
    80000b4e:	ec5e                	sd	s7,24(sp)
    80000b50:	e862                	sd	s8,16(sp)
    80000b52:	e466                	sd	s9,8(sp)
    80000b54:	e06a                	sd	s10,0(sp)
    80000b56:	1080                	addi	s0,sp,96
    80000b58:	8baa                	mv	s7,a0
    80000b5a:	8aae                	mv	s5,a1
    80000b5c:	8b32                	mv	s6,a2
    80000b5e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b60:	74fd                	lui	s1,0xfffff
    80000b62:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b64:	57fd                	li	a5,-1
    80000b66:	83e9                	srli	a5,a5,0x1a
    80000b68:	0697e463          	bltu	a5,s1,80000bd0 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b6c:	4cd5                	li	s9,21
    80000b6e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b70:	8c3e                	mv	s8,a5
    80000b72:	a035                	j	80000b9e <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b74:	83a9                	srli	a5,a5,0xa
    80000b76:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b78:	409a8533          	sub	a0,s5,s1
    80000b7c:	0009061b          	sext.w	a2,s2
    80000b80:	85da                	mv	a1,s6
    80000b82:	953e                	add	a0,a0,a5
    80000b84:	fffff097          	auipc	ra,0xfffff
    80000b88:	654080e7          	jalr	1620(ra) # 800001d8 <memmove>

    len -= n;
    80000b8c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b90:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b92:	02098b63          	beqz	s3,80000bc8 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b96:	034c6f63          	bltu	s8,s4,80000bd4 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b9a:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b9c:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b9e:	4601                	li	a2,0
    80000ba0:	85a6                	mv	a1,s1
    80000ba2:	855e                	mv	a0,s7
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	8c0080e7          	jalr	-1856(ra) # 80000464 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bac:	c515                	beqz	a0,80000bd8 <copyout+0x9e>
    80000bae:	611c                	ld	a5,0(a0)
    80000bb0:	0157f713          	andi	a4,a5,21
    80000bb4:	05971163          	bne	a4,s9,80000bf6 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb8:	01a48a33          	add	s4,s1,s10
    80000bbc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bc0:	fb29fae3          	bgeu	s3,s2,80000b74 <copyout+0x3a>
    80000bc4:	894e                	mv	s2,s3
    80000bc6:	b77d                	j	80000b74 <copyout+0x3a>
  }
  return 0;
    80000bc8:	4501                	li	a0,0
    80000bca:	a801                	j	80000bda <copyout+0xa0>
    80000bcc:	4501                	li	a0,0
}
    80000bce:	8082                	ret
      return -1;
    80000bd0:	557d                	li	a0,-1
    80000bd2:	a021                	j	80000bda <copyout+0xa0>
    80000bd4:	557d                	li	a0,-1
    80000bd6:	a011                	j	80000bda <copyout+0xa0>
      return -1;
    80000bd8:	557d                	li	a0,-1
}
    80000bda:	60e6                	ld	ra,88(sp)
    80000bdc:	6446                	ld	s0,80(sp)
    80000bde:	64a6                	ld	s1,72(sp)
    80000be0:	6906                	ld	s2,64(sp)
    80000be2:	79e2                	ld	s3,56(sp)
    80000be4:	7a42                	ld	s4,48(sp)
    80000be6:	7aa2                	ld	s5,40(sp)
    80000be8:	7b02                	ld	s6,32(sp)
    80000bea:	6be2                	ld	s7,24(sp)
    80000bec:	6c42                	ld	s8,16(sp)
    80000bee:	6ca2                	ld	s9,8(sp)
    80000bf0:	6d02                	ld	s10,0(sp)
    80000bf2:	6125                	addi	sp,sp,96
    80000bf4:	8082                	ret
      return -1;
    80000bf6:	557d                	li	a0,-1
    80000bf8:	b7cd                	j	80000bda <copyout+0xa0>

0000000080000bfa <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bfa:	c6bd                	beqz	a3,80000c68 <copyin+0x6e>
{
    80000bfc:	715d                	addi	sp,sp,-80
    80000bfe:	e486                	sd	ra,72(sp)
    80000c00:	e0a2                	sd	s0,64(sp)
    80000c02:	fc26                	sd	s1,56(sp)
    80000c04:	f84a                	sd	s2,48(sp)
    80000c06:	f44e                	sd	s3,40(sp)
    80000c08:	f052                	sd	s4,32(sp)
    80000c0a:	ec56                	sd	s5,24(sp)
    80000c0c:	e85a                	sd	s6,16(sp)
    80000c0e:	e45e                	sd	s7,8(sp)
    80000c10:	e062                	sd	s8,0(sp)
    80000c12:	0880                	addi	s0,sp,80
    80000c14:	8b2a                	mv	s6,a0
    80000c16:	8a2e                	mv	s4,a1
    80000c18:	8c32                	mv	s8,a2
    80000c1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1e:	6a85                	lui	s5,0x1
    80000c20:	a015                	j	80000c44 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c22:	9562                	add	a0,a0,s8
    80000c24:	0004861b          	sext.w	a2,s1
    80000c28:	412505b3          	sub	a1,a0,s2
    80000c2c:	8552                	mv	a0,s4
    80000c2e:	fffff097          	auipc	ra,0xfffff
    80000c32:	5aa080e7          	jalr	1450(ra) # 800001d8 <memmove>

    len -= n;
    80000c36:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c3a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c40:	02098263          	beqz	s3,80000c64 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c44:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c48:	85ca                	mv	a1,s2
    80000c4a:	855a                	mv	a0,s6
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	8be080e7          	jalr	-1858(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c54:	cd01                	beqz	a0,80000c6c <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c56:	418904b3          	sub	s1,s2,s8
    80000c5a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c5c:	fc99f3e3          	bgeu	s3,s1,80000c22 <copyin+0x28>
    80000c60:	84ce                	mv	s1,s3
    80000c62:	b7c1                	j	80000c22 <copyin+0x28>
  }
  return 0;
    80000c64:	4501                	li	a0,0
    80000c66:	a021                	j	80000c6e <copyin+0x74>
    80000c68:	4501                	li	a0,0
}
    80000c6a:	8082                	ret
      return -1;
    80000c6c:	557d                	li	a0,-1
}
    80000c6e:	60a6                	ld	ra,72(sp)
    80000c70:	6406                	ld	s0,64(sp)
    80000c72:	74e2                	ld	s1,56(sp)
    80000c74:	7942                	ld	s2,48(sp)
    80000c76:	79a2                	ld	s3,40(sp)
    80000c78:	7a02                	ld	s4,32(sp)
    80000c7a:	6ae2                	ld	s5,24(sp)
    80000c7c:	6b42                	ld	s6,16(sp)
    80000c7e:	6ba2                	ld	s7,8(sp)
    80000c80:	6c02                	ld	s8,0(sp)
    80000c82:	6161                	addi	sp,sp,80
    80000c84:	8082                	ret

0000000080000c86 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c86:	c6c5                	beqz	a3,80000d2e <copyinstr+0xa8>
{
    80000c88:	715d                	addi	sp,sp,-80
    80000c8a:	e486                	sd	ra,72(sp)
    80000c8c:	e0a2                	sd	s0,64(sp)
    80000c8e:	fc26                	sd	s1,56(sp)
    80000c90:	f84a                	sd	s2,48(sp)
    80000c92:	f44e                	sd	s3,40(sp)
    80000c94:	f052                	sd	s4,32(sp)
    80000c96:	ec56                	sd	s5,24(sp)
    80000c98:	e85a                	sd	s6,16(sp)
    80000c9a:	e45e                	sd	s7,8(sp)
    80000c9c:	0880                	addi	s0,sp,80
    80000c9e:	8a2a                	mv	s4,a0
    80000ca0:	8b2e                	mv	s6,a1
    80000ca2:	8bb2                	mv	s7,a2
    80000ca4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca8:	6985                	lui	s3,0x1
    80000caa:	a035                	j	80000cd6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb2:	0017b793          	seqz	a5,a5
    80000cb6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cba:	60a6                	ld	ra,72(sp)
    80000cbc:	6406                	ld	s0,64(sp)
    80000cbe:	74e2                	ld	s1,56(sp)
    80000cc0:	7942                	ld	s2,48(sp)
    80000cc2:	79a2                	ld	s3,40(sp)
    80000cc4:	7a02                	ld	s4,32(sp)
    80000cc6:	6ae2                	ld	s5,24(sp)
    80000cc8:	6b42                	ld	s6,16(sp)
    80000cca:	6ba2                	ld	s7,8(sp)
    80000ccc:	6161                	addi	sp,sp,80
    80000cce:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd4:	c8a9                	beqz	s1,80000d26 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cda:	85ca                	mv	a1,s2
    80000cdc:	8552                	mv	a0,s4
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	82c080e7          	jalr	-2004(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000ce6:	c131                	beqz	a0,80000d2a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce8:	41790833          	sub	a6,s2,s7
    80000cec:	984e                	add	a6,a6,s3
    if(n > max)
    80000cee:	0104f363          	bgeu	s1,a6,80000cf4 <copyinstr+0x6e>
    80000cf2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf4:	955e                	add	a0,a0,s7
    80000cf6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cfa:	fc080be3          	beqz	a6,80000cd0 <copyinstr+0x4a>
    80000cfe:	985a                	add	a6,a6,s6
    80000d00:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d02:	41650633          	sub	a2,a0,s6
    80000d06:	14fd                	addi	s1,s1,-1
    80000d08:	9b26                	add	s6,s6,s1
    80000d0a:	00f60733          	add	a4,a2,a5
    80000d0e:	00074703          	lbu	a4,0(a4)
    80000d12:	df49                	beqz	a4,80000cac <copyinstr+0x26>
        *dst = *p;
    80000d14:	00e78023          	sb	a4,0(a5)
      --max;
    80000d18:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d1c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d1e:	ff0796e3          	bne	a5,a6,80000d0a <copyinstr+0x84>
      dst++;
    80000d22:	8b42                	mv	s6,a6
    80000d24:	b775                	j	80000cd0 <copyinstr+0x4a>
    80000d26:	4781                	li	a5,0
    80000d28:	b769                	j	80000cb2 <copyinstr+0x2c>
      return -1;
    80000d2a:	557d                	li	a0,-1
    80000d2c:	b779                	j	80000cba <copyinstr+0x34>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	0017b793          	seqz	a5,a5
    80000d34:	40f00533          	neg	a0,a5
}
    80000d38:	8082                	ret

0000000080000d3a <vmprint>:

int pageDeep = 0;

void vmprint(pagetable_t pagetable){ // new!
    80000d3a:	711d                	addi	sp,sp,-96
    80000d3c:	ec86                	sd	ra,88(sp)
    80000d3e:	e8a2                	sd	s0,80(sp)
    80000d40:	e4a6                	sd	s1,72(sp)
    80000d42:	e0ca                	sd	s2,64(sp)
    80000d44:	fc4e                	sd	s3,56(sp)
    80000d46:	f852                	sd	s4,48(sp)
    80000d48:	f456                	sd	s5,40(sp)
    80000d4a:	f05a                	sd	s6,32(sp)
    80000d4c:	ec5e                	sd	s7,24(sp)
    80000d4e:	e862                	sd	s8,16(sp)
    80000d50:	e466                	sd	s9,8(sp)
    80000d52:	e06a                	sd	s10,0(sp)
    80000d54:	1080                	addi	s0,sp,96
    80000d56:	8aaa                	mv	s5,a0
  if (pageDeep == 0){
    80000d58:	00008797          	auipc	a5,0x8
    80000d5c:	c107a783          	lw	a5,-1008(a5) # 80008968 <pageDeep>
    80000d60:	c39d                	beqz	a5,80000d86 <vmprint+0x4c>
void vmprint(pagetable_t pagetable){ // new!
    80000d62:	4981                	li	s3,0
    pageDeep = 1;
  }
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if(pte & PTE_V){ //current page
      for(int i = 0; i < pageDeep; i++)
    80000d64:	00008a17          	auipc	s4,0x8
    80000d68:	c04a0a13          	addi	s4,s4,-1020 # 80008968 <pageDeep>
        printf("..");
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d6c:	00007c97          	auipc	s9,0x7
    80000d70:	444c8c93          	addi	s9,s9,1092 # 800081b0 <etext+0x1b0>
      for(int i = 0; i < pageDeep; i++)
    80000d74:	4d01                	li	s10,0
        printf("..");
    80000d76:	00007b17          	auipc	s6,0x7
    80000d7a:	432b0b13          	addi	s6,s6,1074 # 800081a8 <etext+0x1a8>
    }
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){ //search child pages
    80000d7e:	4c05                	li	s8,1
  for(int i = 0; i < 512; i++){
    80000d80:	20000b93          	li	s7,512
    80000d84:	a091                	j	80000dc8 <vmprint+0x8e>
    printf("page table %p\n", pagetable);
    80000d86:	85aa                	mv	a1,a0
    80000d88:	00007517          	auipc	a0,0x7
    80000d8c:	41050513          	addi	a0,a0,1040 # 80008198 <etext+0x198>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	17c080e7          	jalr	380(ra) # 80005f0c <printf>
    pageDeep = 1;
    80000d98:	4785                	li	a5,1
    80000d9a:	00008717          	auipc	a4,0x8
    80000d9e:	bcf72723          	sw	a5,-1074(a4) # 80008968 <pageDeep>
    80000da2:	b7c1                	j	80000d62 <vmprint+0x28>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000da4:	00a95693          	srli	a3,s2,0xa
    80000da8:	06b2                	slli	a3,a3,0xc
    80000daa:	864a                	mv	a2,s2
    80000dac:	85ce                	mv	a1,s3
    80000dae:	8566                	mv	a0,s9
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	15c080e7          	jalr	348(ra) # 80005f0c <printf>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){ //search child pages
    80000db8:	00f97793          	andi	a5,s2,15
    80000dbc:	03878b63          	beq	a5,s8,80000df2 <vmprint+0xb8>
  for(int i = 0; i < 512; i++){
    80000dc0:	2985                	addiw	s3,s3,1
    80000dc2:	0aa1                	addi	s5,s5,8
    80000dc4:	05798963          	beq	s3,s7,80000e16 <vmprint+0xdc>
    pte_t pte = pagetable[i];
    80000dc8:	000ab903          	ld	s2,0(s5) # fffffffffffff000 <end+0xffffffff7ffdcff0>
    if(pte & PTE_V){ //current page
    80000dcc:	00197793          	andi	a5,s2,1
    80000dd0:	d7e5                	beqz	a5,80000db8 <vmprint+0x7e>
      for(int i = 0; i < pageDeep; i++)
    80000dd2:	000a2783          	lw	a5,0(s4)
    80000dd6:	fcf057e3          	blez	a5,80000da4 <vmprint+0x6a>
    80000dda:	84ea                	mv	s1,s10
        printf("..");
    80000ddc:	855a                	mv	a0,s6
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	12e080e7          	jalr	302(ra) # 80005f0c <printf>
      for(int i = 0; i < pageDeep; i++)
    80000de6:	2485                	addiw	s1,s1,1
    80000de8:	000a2783          	lw	a5,0(s4)
    80000dec:	fef4c8e3          	blt	s1,a5,80000ddc <vmprint+0xa2>
    80000df0:	bf55                	j	80000da4 <vmprint+0x6a>
      // this PTE points to a lower-level page table.
      pageDeep++;
    80000df2:	000a2783          	lw	a5,0(s4)
    80000df6:	2785                	addiw	a5,a5,1
    80000df8:	00fa2023          	sw	a5,0(s4)
      uint64 child = PTE2PA(pte);
    80000dfc:	00a95513          	srli	a0,s2,0xa
      vmprint((pagetable_t)child); //recursive in child
    80000e00:	0532                	slli	a0,a0,0xc
    80000e02:	00000097          	auipc	ra,0x0
    80000e06:	f38080e7          	jalr	-200(ra) # 80000d3a <vmprint>
      pageDeep--;
    80000e0a:	000a2783          	lw	a5,0(s4)
    80000e0e:	37fd                	addiw	a5,a5,-1
    80000e10:	00fa2023          	sw	a5,0(s4)
    80000e14:	b775                	j	80000dc0 <vmprint+0x86>
    }
  }

}
    80000e16:	60e6                	ld	ra,88(sp)
    80000e18:	6446                	ld	s0,80(sp)
    80000e1a:	64a6                	ld	s1,72(sp)
    80000e1c:	6906                	ld	s2,64(sp)
    80000e1e:	79e2                	ld	s3,56(sp)
    80000e20:	7a42                	ld	s4,48(sp)
    80000e22:	7aa2                	ld	s5,40(sp)
    80000e24:	7b02                	ld	s6,32(sp)
    80000e26:	6be2                	ld	s7,24(sp)
    80000e28:	6c42                	ld	s8,16(sp)
    80000e2a:	6ca2                	ld	s9,8(sp)
    80000e2c:	6d02                	ld	s10,0(sp)
    80000e2e:	6125                	addi	sp,sp,96
    80000e30:	8082                	ret

0000000080000e32 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e32:	7139                	addi	sp,sp,-64
    80000e34:	fc06                	sd	ra,56(sp)
    80000e36:	f822                	sd	s0,48(sp)
    80000e38:	f426                	sd	s1,40(sp)
    80000e3a:	f04a                	sd	s2,32(sp)
    80000e3c:	ec4e                	sd	s3,24(sp)
    80000e3e:	e852                	sd	s4,16(sp)
    80000e40:	e456                	sd	s5,8(sp)
    80000e42:	e05a                	sd	s6,0(sp)
    80000e44:	0080                	addi	s0,sp,64
    80000e46:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e48:	00008497          	auipc	s1,0x8
    80000e4c:	fa848493          	addi	s1,s1,-88 # 80008df0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e50:	8b26                	mv	s6,s1
    80000e52:	00007a97          	auipc	s5,0x7
    80000e56:	1aea8a93          	addi	s5,s5,430 # 80008000 <etext>
    80000e5a:	01000937          	lui	s2,0x1000
    80000e5e:	197d                	addi	s2,s2,-1
    80000e60:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	0000ea17          	auipc	s4,0xe
    80000e66:	b8ea0a13          	addi	s4,s4,-1138 # 8000e9f0 <tickslock>
    char *pa = kalloc();
    80000e6a:	fffff097          	auipc	ra,0xfffff
    80000e6e:	2ae080e7          	jalr	686(ra) # 80000118 <kalloc>
    80000e72:	862a                	mv	a2,a0
    if(pa == 0)
    80000e74:	c129                	beqz	a0,80000eb6 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e76:	416485b3          	sub	a1,s1,s6
    80000e7a:	8591                	srai	a1,a1,0x4
    80000e7c:	000ab783          	ld	a5,0(s5)
    80000e80:	02f585b3          	mul	a1,a1,a5
    80000e84:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e88:	4719                	li	a4,6
    80000e8a:	6685                	lui	a3,0x1
    80000e8c:	40b905b3          	sub	a1,s2,a1
    80000e90:	854e                	mv	a0,s3
    80000e92:	fffff097          	auipc	ra,0xfffff
    80000e96:	77e080e7          	jalr	1918(ra) # 80000610 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9a:	17048493          	addi	s1,s1,368
    80000e9e:	fd4496e3          	bne	s1,s4,80000e6a <proc_mapstacks+0x38>
  }
}
    80000ea2:	70e2                	ld	ra,56(sp)
    80000ea4:	7442                	ld	s0,48(sp)
    80000ea6:	74a2                	ld	s1,40(sp)
    80000ea8:	7902                	ld	s2,32(sp)
    80000eaa:	69e2                	ld	s3,24(sp)
    80000eac:	6a42                	ld	s4,16(sp)
    80000eae:	6aa2                	ld	s5,8(sp)
    80000eb0:	6b02                	ld	s6,0(sp)
    80000eb2:	6121                	addi	sp,sp,64
    80000eb4:	8082                	ret
      panic("kalloc");
    80000eb6:	00007517          	auipc	a0,0x7
    80000eba:	31250513          	addi	a0,a0,786 # 800081c8 <etext+0x1c8>
    80000ebe:	00005097          	auipc	ra,0x5
    80000ec2:	004080e7          	jalr	4(ra) # 80005ec2 <panic>

0000000080000ec6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000ec6:	7139                	addi	sp,sp,-64
    80000ec8:	fc06                	sd	ra,56(sp)
    80000eca:	f822                	sd	s0,48(sp)
    80000ecc:	f426                	sd	s1,40(sp)
    80000ece:	f04a                	sd	s2,32(sp)
    80000ed0:	ec4e                	sd	s3,24(sp)
    80000ed2:	e852                	sd	s4,16(sp)
    80000ed4:	e456                	sd	s5,8(sp)
    80000ed6:	e05a                	sd	s6,0(sp)
    80000ed8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eda:	00007597          	auipc	a1,0x7
    80000ede:	2f658593          	addi	a1,a1,758 # 800081d0 <etext+0x1d0>
    80000ee2:	00008517          	auipc	a0,0x8
    80000ee6:	ade50513          	addi	a0,a0,-1314 # 800089c0 <pid_lock>
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	492080e7          	jalr	1170(ra) # 8000637c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ef2:	00007597          	auipc	a1,0x7
    80000ef6:	2e658593          	addi	a1,a1,742 # 800081d8 <etext+0x1d8>
    80000efa:	00008517          	auipc	a0,0x8
    80000efe:	ade50513          	addi	a0,a0,-1314 # 800089d8 <wait_lock>
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	47a080e7          	jalr	1146(ra) # 8000637c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0a:	00008497          	auipc	s1,0x8
    80000f0e:	ee648493          	addi	s1,s1,-282 # 80008df0 <proc>
      initlock(&p->lock, "proc");
    80000f12:	00007b17          	auipc	s6,0x7
    80000f16:	2d6b0b13          	addi	s6,s6,726 # 800081e8 <etext+0x1e8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f1a:	8aa6                	mv	s5,s1
    80000f1c:	00007a17          	auipc	s4,0x7
    80000f20:	0e4a0a13          	addi	s4,s4,228 # 80008000 <etext>
    80000f24:	01000937          	lui	s2,0x1000
    80000f28:	197d                	addi	s2,s2,-1
    80000f2a:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2c:	0000e997          	auipc	s3,0xe
    80000f30:	ac498993          	addi	s3,s3,-1340 # 8000e9f0 <tickslock>
      initlock(&p->lock, "proc");
    80000f34:	85da                	mv	a1,s6
    80000f36:	8526                	mv	a0,s1
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	444080e7          	jalr	1092(ra) # 8000637c <initlock>
      p->state = UNUSED;
    80000f40:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f44:	415487b3          	sub	a5,s1,s5
    80000f48:	8791                	srai	a5,a5,0x4
    80000f4a:	000a3703          	ld	a4,0(s4)
    80000f4e:	02e787b3          	mul	a5,a5,a4
    80000f52:	00d7979b          	slliw	a5,a5,0xd
    80000f56:	40f907b3          	sub	a5,s2,a5
    80000f5a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5c:	17048493          	addi	s1,s1,368
    80000f60:	fd349ae3          	bne	s1,s3,80000f34 <procinit+0x6e>
  }
}
    80000f64:	70e2                	ld	ra,56(sp)
    80000f66:	7442                	ld	s0,48(sp)
    80000f68:	74a2                	ld	s1,40(sp)
    80000f6a:	7902                	ld	s2,32(sp)
    80000f6c:	69e2                	ld	s3,24(sp)
    80000f6e:	6a42                	ld	s4,16(sp)
    80000f70:	6aa2                	ld	s5,8(sp)
    80000f72:	6b02                	ld	s6,0(sp)
    80000f74:	6121                	addi	sp,sp,64
    80000f76:	8082                	ret

0000000080000f78 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f78:	1141                	addi	sp,sp,-16
    80000f7a:	e422                	sd	s0,8(sp)
    80000f7c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f7e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f80:	2501                	sext.w	a0,a0
    80000f82:	6422                	ld	s0,8(sp)
    80000f84:	0141                	addi	sp,sp,16
    80000f86:	8082                	ret

0000000080000f88 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f88:	1141                	addi	sp,sp,-16
    80000f8a:	e422                	sd	s0,8(sp)
    80000f8c:	0800                	addi	s0,sp,16
    80000f8e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f90:	2781                	sext.w	a5,a5
    80000f92:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f94:	00008517          	auipc	a0,0x8
    80000f98:	a5c50513          	addi	a0,a0,-1444 # 800089f0 <cpus>
    80000f9c:	953e                	add	a0,a0,a5
    80000f9e:	6422                	ld	s0,8(sp)
    80000fa0:	0141                	addi	sp,sp,16
    80000fa2:	8082                	ret

0000000080000fa4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	1000                	addi	s0,sp,32
  push_off();
    80000fae:	00005097          	auipc	ra,0x5
    80000fb2:	412080e7          	jalr	1042(ra) # 800063c0 <push_off>
    80000fb6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fb8:	2781                	sext.w	a5,a5
    80000fba:	079e                	slli	a5,a5,0x7
    80000fbc:	00008717          	auipc	a4,0x8
    80000fc0:	a0470713          	addi	a4,a4,-1532 # 800089c0 <pid_lock>
    80000fc4:	97ba                	add	a5,a5,a4
    80000fc6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	498080e7          	jalr	1176(ra) # 80006460 <pop_off>
  return p;
}
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	60e2                	ld	ra,24(sp)
    80000fd4:	6442                	ld	s0,16(sp)
    80000fd6:	64a2                	ld	s1,8(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fdc:	1141                	addi	sp,sp,-16
    80000fde:	e406                	sd	ra,8(sp)
    80000fe0:	e022                	sd	s0,0(sp)
    80000fe2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fe4:	00000097          	auipc	ra,0x0
    80000fe8:	fc0080e7          	jalr	-64(ra) # 80000fa4 <myproc>
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	4d4080e7          	jalr	1236(ra) # 800064c0 <release>

  if (first) {
    80000ff4:	00008797          	auipc	a5,0x8
    80000ff8:	8fc7a783          	lw	a5,-1796(a5) # 800088f0 <first.1683>
    80000ffc:	eb89                	bnez	a5,8000100e <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000ffe:	00001097          	auipc	ra,0x1
    80001002:	d10080e7          	jalr	-752(ra) # 80001d0e <usertrapret>
}
    80001006:	60a2                	ld	ra,8(sp)
    80001008:	6402                	ld	s0,0(sp)
    8000100a:	0141                	addi	sp,sp,16
    8000100c:	8082                	ret
    fsinit(ROOTDEV);
    8000100e:	4505                	li	a0,1
    80001010:	00002097          	auipc	ra,0x2
    80001014:	b1a080e7          	jalr	-1254(ra) # 80002b2a <fsinit>
    first = 0;
    80001018:	00008797          	auipc	a5,0x8
    8000101c:	8c07ac23          	sw	zero,-1832(a5) # 800088f0 <first.1683>
    __sync_synchronize();
    80001020:	0ff0000f          	fence
    80001024:	bfe9                	j	80000ffe <forkret+0x22>

0000000080001026 <allocpid>:
{
    80001026:	1101                	addi	sp,sp,-32
    80001028:	ec06                	sd	ra,24(sp)
    8000102a:	e822                	sd	s0,16(sp)
    8000102c:	e426                	sd	s1,8(sp)
    8000102e:	e04a                	sd	s2,0(sp)
    80001030:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001032:	00008917          	auipc	s2,0x8
    80001036:	98e90913          	addi	s2,s2,-1650 # 800089c0 <pid_lock>
    8000103a:	854a                	mv	a0,s2
    8000103c:	00005097          	auipc	ra,0x5
    80001040:	3d0080e7          	jalr	976(ra) # 8000640c <acquire>
  pid = nextpid;
    80001044:	00008797          	auipc	a5,0x8
    80001048:	8b078793          	addi	a5,a5,-1872 # 800088f4 <nextpid>
    8000104c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000104e:	0014871b          	addiw	a4,s1,1
    80001052:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001054:	854a                	mv	a0,s2
    80001056:	00005097          	auipc	ra,0x5
    8000105a:	46a080e7          	jalr	1130(ra) # 800064c0 <release>
}
    8000105e:	8526                	mv	a0,s1
    80001060:	60e2                	ld	ra,24(sp)
    80001062:	6442                	ld	s0,16(sp)
    80001064:	64a2                	ld	s1,8(sp)
    80001066:	6902                	ld	s2,0(sp)
    80001068:	6105                	addi	sp,sp,32
    8000106a:	8082                	ret

000000008000106c <proc_pagetable>:
{
    8000106c:	1101                	addi	sp,sp,-32
    8000106e:	ec06                	sd	ra,24(sp)
    80001070:	e822                	sd	s0,16(sp)
    80001072:	e426                	sd	s1,8(sp)
    80001074:	e04a                	sd	s2,0(sp)
    80001076:	1000                	addi	s0,sp,32
    80001078:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000107a:	fffff097          	auipc	ra,0xfffff
    8000107e:	780080e7          	jalr	1920(ra) # 800007fa <uvmcreate>
    80001082:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001084:	cd39                	beqz	a0,800010e2 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001086:	4729                	li	a4,10
    80001088:	00006697          	auipc	a3,0x6
    8000108c:	f7868693          	addi	a3,a3,-136 # 80007000 <_trampoline>
    80001090:	6605                	lui	a2,0x1
    80001092:	040005b7          	lui	a1,0x4000
    80001096:	15fd                	addi	a1,a1,-1
    80001098:	05b2                	slli	a1,a1,0xc
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	4b2080e7          	jalr	1202(ra) # 8000054c <mappages>
    800010a2:	04054763          	bltz	a0,800010f0 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010a6:	4719                	li	a4,6
    800010a8:	05893683          	ld	a3,88(s2)
    800010ac:	6605                	lui	a2,0x1
    800010ae:	020005b7          	lui	a1,0x2000
    800010b2:	15fd                	addi	a1,a1,-1
    800010b4:	05b6                	slli	a1,a1,0xd
    800010b6:	8526                	mv	a0,s1
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	494080e7          	jalr	1172(ra) # 8000054c <mappages>
    800010c0:	04054063          	bltz	a0,80001100 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    800010c4:	4749                	li	a4,18
    800010c6:	16893683          	ld	a3,360(s2)
    800010ca:	6605                	lui	a2,0x1
    800010cc:	040005b7          	lui	a1,0x4000
    800010d0:	15f5                	addi	a1,a1,-3
    800010d2:	05b2                	slli	a1,a1,0xc
    800010d4:	8526                	mv	a0,s1
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	476080e7          	jalr	1142(ra) # 8000054c <mappages>
    800010de:	04054463          	bltz	a0,80001126 <proc_pagetable+0xba>
}
    800010e2:	8526                	mv	a0,s1
    800010e4:	60e2                	ld	ra,24(sp)
    800010e6:	6442                	ld	s0,16(sp)
    800010e8:	64a2                	ld	s1,8(sp)
    800010ea:	6902                	ld	s2,0(sp)
    800010ec:	6105                	addi	sp,sp,32
    800010ee:	8082                	ret
    uvmfree(pagetable, 0);
    800010f0:	4581                	li	a1,0
    800010f2:	8526                	mv	a0,s1
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	90a080e7          	jalr	-1782(ra) # 800009fe <uvmfree>
    return 0;
    800010fc:	4481                	li	s1,0
    800010fe:	b7d5                	j	800010e2 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001100:	4681                	li	a3,0
    80001102:	4605                	li	a2,1
    80001104:	040005b7          	lui	a1,0x4000
    80001108:	15fd                	addi	a1,a1,-1
    8000110a:	05b2                	slli	a1,a1,0xc
    8000110c:	8526                	mv	a0,s1
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	628080e7          	jalr	1576(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    80001116:	4581                	li	a1,0
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	8e4080e7          	jalr	-1820(ra) # 800009fe <uvmfree>
    return 0;
    80001122:	4481                	li	s1,0
    80001124:	bf7d                	j	800010e2 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001126:	4681                	li	a3,0
    80001128:	4605                	li	a2,1
    8000112a:	040005b7          	lui	a1,0x4000
    8000112e:	15fd                	addi	a1,a1,-1
    80001130:	05b2                	slli	a1,a1,0xc
    80001132:	8526                	mv	a0,s1
    80001134:	fffff097          	auipc	ra,0xfffff
    80001138:	602080e7          	jalr	1538(ra) # 80000736 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000113c:	4681                	li	a3,0
    8000113e:	4605                	li	a2,1
    80001140:	020005b7          	lui	a1,0x2000
    80001144:	15fd                	addi	a1,a1,-1
    80001146:	05b6                	slli	a1,a1,0xd
    80001148:	8526                	mv	a0,s1
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	5ec080e7          	jalr	1516(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    80001152:	4581                	li	a1,0
    80001154:	8526                	mv	a0,s1
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	8a8080e7          	jalr	-1880(ra) # 800009fe <uvmfree>
    return 0;
    8000115e:	4481                	li	s1,0
    80001160:	b749                	j	800010e2 <proc_pagetable+0x76>

0000000080001162 <proc_freepagetable>:
{
    80001162:	7179                	addi	sp,sp,-48
    80001164:	f406                	sd	ra,40(sp)
    80001166:	f022                	sd	s0,32(sp)
    80001168:	ec26                	sd	s1,24(sp)
    8000116a:	e84a                	sd	s2,16(sp)
    8000116c:	e44e                	sd	s3,8(sp)
    8000116e:	1800                	addi	s0,sp,48
    80001170:	84aa                	mv	s1,a0
    80001172:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001174:	4681                	li	a3,0
    80001176:	4605                	li	a2,1
    80001178:	04000937          	lui	s2,0x4000
    8000117c:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001180:	05b2                	slli	a1,a1,0xc
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	5b4080e7          	jalr	1460(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000118a:	4681                	li	a3,0
    8000118c:	4605                	li	a2,1
    8000118e:	020005b7          	lui	a1,0x2000
    80001192:	15fd                	addi	a1,a1,-1
    80001194:	05b6                	slli	a1,a1,0xd
    80001196:	8526                	mv	a0,s1
    80001198:	fffff097          	auipc	ra,0xfffff
    8000119c:	59e080e7          	jalr	1438(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800011a0:	4681                	li	a3,0
    800011a2:	4605                	li	a2,1
    800011a4:	1975                	addi	s2,s2,-3
    800011a6:	00c91593          	slli	a1,s2,0xc
    800011aa:	8526                	mv	a0,s1
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	58a080e7          	jalr	1418(ra) # 80000736 <uvmunmap>
  uvmfree(pagetable, sz);
    800011b4:	85ce                	mv	a1,s3
    800011b6:	8526                	mv	a0,s1
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	846080e7          	jalr	-1978(ra) # 800009fe <uvmfree>
}
    800011c0:	70a2                	ld	ra,40(sp)
    800011c2:	7402                	ld	s0,32(sp)
    800011c4:	64e2                	ld	s1,24(sp)
    800011c6:	6942                	ld	s2,16(sp)
    800011c8:	69a2                	ld	s3,8(sp)
    800011ca:	6145                	addi	sp,sp,48
    800011cc:	8082                	ret

00000000800011ce <freeproc>:
{
    800011ce:	1101                	addi	sp,sp,-32
    800011d0:	ec06                	sd	ra,24(sp)
    800011d2:	e822                	sd	s0,16(sp)
    800011d4:	e426                	sd	s1,8(sp)
    800011d6:	1000                	addi	s0,sp,32
    800011d8:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011da:	6d28                	ld	a0,88(a0)
    800011dc:	c509                	beqz	a0,800011e6 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	e3e080e7          	jalr	-450(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011e6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011ea:	68a8                	ld	a0,80(s1)
    800011ec:	c511                	beqz	a0,800011f8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011ee:	64ac                	ld	a1,72(s1)
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	f72080e7          	jalr	-142(ra) # 80001162 <proc_freepagetable>
  p->pagetable = 0;
    800011f8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011fc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001200:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001204:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001208:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000120c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001210:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001214:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001218:	0004ac23          	sw	zero,24(s1)
  if(p->sharedpage)
    8000121c:	1684b503          	ld	a0,360(s1)
    80001220:	c509                	beqz	a0,8000122a <freeproc+0x5c>
    kfree((void *)p->sharedpage);
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	dfa080e7          	jalr	-518(ra) # 8000001c <kfree>
  p->sharedpage = 0;
    8000122a:	1604b423          	sd	zero,360(s1)
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6105                	addi	sp,sp,32
    80001236:	8082                	ret

0000000080001238 <allocproc>:
{
    80001238:	1101                	addi	sp,sp,-32
    8000123a:	ec06                	sd	ra,24(sp)
    8000123c:	e822                	sd	s0,16(sp)
    8000123e:	e426                	sd	s1,8(sp)
    80001240:	e04a                	sd	s2,0(sp)
    80001242:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001244:	00008497          	auipc	s1,0x8
    80001248:	bac48493          	addi	s1,s1,-1108 # 80008df0 <proc>
    8000124c:	0000d917          	auipc	s2,0xd
    80001250:	7a490913          	addi	s2,s2,1956 # 8000e9f0 <tickslock>
    acquire(&p->lock);
    80001254:	8526                	mv	a0,s1
    80001256:	00005097          	auipc	ra,0x5
    8000125a:	1b6080e7          	jalr	438(ra) # 8000640c <acquire>
    if(p->state == UNUSED) {
    8000125e:	4c9c                	lw	a5,24(s1)
    80001260:	cf81                	beqz	a5,80001278 <allocproc+0x40>
      release(&p->lock);
    80001262:	8526                	mv	a0,s1
    80001264:	00005097          	auipc	ra,0x5
    80001268:	25c080e7          	jalr	604(ra) # 800064c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000126c:	17048493          	addi	s1,s1,368
    80001270:	ff2492e3          	bne	s1,s2,80001254 <allocproc+0x1c>
  return 0;
    80001274:	4481                	li	s1,0
    80001276:	a0ad                	j	800012e0 <allocproc+0xa8>
  p->pid = allocpid();
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	dae080e7          	jalr	-594(ra) # 80001026 <allocpid>
    80001280:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001282:	4785                	li	a5,1
    80001284:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	e92080e7          	jalr	-366(ra) # 80000118 <kalloc>
    8000128e:	892a                	mv	s2,a0
    80001290:	eca8                	sd	a0,88(s1)
    80001292:	cd31                	beqz	a0,800012ee <allocproc+0xb6>
  if((p->sharedpage = (struct usyscall *)kalloc()) == 0){
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	e84080e7          	jalr	-380(ra) # 80000118 <kalloc>
    8000129c:	892a                	mv	s2,a0
    8000129e:	16a4b423          	sd	a0,360(s1)
    800012a2:	c135                	beqz	a0,80001306 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	dc6080e7          	jalr	-570(ra) # 8000106c <proc_pagetable>
    800012ae:	892a                	mv	s2,a0
    800012b0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012b2:	c535                	beqz	a0,8000131e <allocproc+0xe6>
  memset(&p->context, 0, sizeof(p->context));
    800012b4:	07000613          	li	a2,112
    800012b8:	4581                	li	a1,0
    800012ba:	06048513          	addi	a0,s1,96
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	eba080e7          	jalr	-326(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800012c6:	00000797          	auipc	a5,0x0
    800012ca:	d1678793          	addi	a5,a5,-746 # 80000fdc <forkret>
    800012ce:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012d0:	60bc                	ld	a5,64(s1)
    800012d2:	6705                	lui	a4,0x1
    800012d4:	97ba                	add	a5,a5,a4
    800012d6:	f4bc                	sd	a5,104(s1)
  p->sharedpage->pid = p->pid;
    800012d8:	1684b783          	ld	a5,360(s1)
    800012dc:	5898                	lw	a4,48(s1)
    800012de:	c398                	sw	a4,0(a5)
}
    800012e0:	8526                	mv	a0,s1
    800012e2:	60e2                	ld	ra,24(sp)
    800012e4:	6442                	ld	s0,16(sp)
    800012e6:	64a2                	ld	s1,8(sp)
    800012e8:	6902                	ld	s2,0(sp)
    800012ea:	6105                	addi	sp,sp,32
    800012ec:	8082                	ret
    freeproc(p);
    800012ee:	8526                	mv	a0,s1
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	ede080e7          	jalr	-290(ra) # 800011ce <freeproc>
    release(&p->lock);
    800012f8:	8526                	mv	a0,s1
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	1c6080e7          	jalr	454(ra) # 800064c0 <release>
    return 0;
    80001302:	84ca                	mv	s1,s2
    80001304:	bff1                	j	800012e0 <allocproc+0xa8>
    freeproc(p);
    80001306:	8526                	mv	a0,s1
    80001308:	00000097          	auipc	ra,0x0
    8000130c:	ec6080e7          	jalr	-314(ra) # 800011ce <freeproc>
    release(&p->lock);
    80001310:	8526                	mv	a0,s1
    80001312:	00005097          	auipc	ra,0x5
    80001316:	1ae080e7          	jalr	430(ra) # 800064c0 <release>
    return 0;
    8000131a:	84ca                	mv	s1,s2
    8000131c:	b7d1                	j	800012e0 <allocproc+0xa8>
    freeproc(p);
    8000131e:	8526                	mv	a0,s1
    80001320:	00000097          	auipc	ra,0x0
    80001324:	eae080e7          	jalr	-338(ra) # 800011ce <freeproc>
    release(&p->lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	196080e7          	jalr	406(ra) # 800064c0 <release>
    return 0;
    80001332:	84ca                	mv	s1,s2
    80001334:	b775                	j	800012e0 <allocproc+0xa8>

0000000080001336 <userinit>:
{
    80001336:	1101                	addi	sp,sp,-32
    80001338:	ec06                	sd	ra,24(sp)
    8000133a:	e822                	sd	s0,16(sp)
    8000133c:	e426                	sd	s1,8(sp)
    8000133e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001340:	00000097          	auipc	ra,0x0
    80001344:	ef8080e7          	jalr	-264(ra) # 80001238 <allocproc>
    80001348:	84aa                	mv	s1,a0
  initproc = p;
    8000134a:	00007797          	auipc	a5,0x7
    8000134e:	62a7b723          	sd	a0,1582(a5) # 80008978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001352:	03400613          	li	a2,52
    80001356:	00007597          	auipc	a1,0x7
    8000135a:	5aa58593          	addi	a1,a1,1450 # 80008900 <initcode>
    8000135e:	6928                	ld	a0,80(a0)
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	4c8080e7          	jalr	1224(ra) # 80000828 <uvmfirst>
  p->sz = PGSIZE;
    80001368:	6785                	lui	a5,0x1
    8000136a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000136c:	6cb8                	ld	a4,88(s1)
    8000136e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001372:	6cb8                	ld	a4,88(s1)
    80001374:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001376:	4641                	li	a2,16
    80001378:	00007597          	auipc	a1,0x7
    8000137c:	e7858593          	addi	a1,a1,-392 # 800081f0 <etext+0x1f0>
    80001380:	15848513          	addi	a0,s1,344
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	f46080e7          	jalr	-186(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000138c:	00007517          	auipc	a0,0x7
    80001390:	e7450513          	addi	a0,a0,-396 # 80008200 <etext+0x200>
    80001394:	00002097          	auipc	ra,0x2
    80001398:	1b8080e7          	jalr	440(ra) # 8000354c <namei>
    8000139c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013a0:	478d                	li	a5,3
    800013a2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00005097          	auipc	ra,0x5
    800013aa:	11a080e7          	jalr	282(ra) # 800064c0 <release>
}
    800013ae:	60e2                	ld	ra,24(sp)
    800013b0:	6442                	ld	s0,16(sp)
    800013b2:	64a2                	ld	s1,8(sp)
    800013b4:	6105                	addi	sp,sp,32
    800013b6:	8082                	ret

00000000800013b8 <growproc>:
{
    800013b8:	1101                	addi	sp,sp,-32
    800013ba:	ec06                	sd	ra,24(sp)
    800013bc:	e822                	sd	s0,16(sp)
    800013be:	e426                	sd	s1,8(sp)
    800013c0:	e04a                	sd	s2,0(sp)
    800013c2:	1000                	addi	s0,sp,32
    800013c4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	bde080e7          	jalr	-1058(ra) # 80000fa4 <myproc>
    800013ce:	84aa                	mv	s1,a0
  sz = p->sz;
    800013d0:	652c                	ld	a1,72(a0)
  if(n > 0){
    800013d2:	01204c63          	bgtz	s2,800013ea <growproc+0x32>
  } else if(n < 0){
    800013d6:	02094663          	bltz	s2,80001402 <growproc+0x4a>
  p->sz = sz;
    800013da:	e4ac                	sd	a1,72(s1)
  return 0;
    800013dc:	4501                	li	a0,0
}
    800013de:	60e2                	ld	ra,24(sp)
    800013e0:	6442                	ld	s0,16(sp)
    800013e2:	64a2                	ld	s1,8(sp)
    800013e4:	6902                	ld	s2,0(sp)
    800013e6:	6105                	addi	sp,sp,32
    800013e8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800013ea:	4691                	li	a3,4
    800013ec:	00b90633          	add	a2,s2,a1
    800013f0:	6928                	ld	a0,80(a0)
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	4f0080e7          	jalr	1264(ra) # 800008e2 <uvmalloc>
    800013fa:	85aa                	mv	a1,a0
    800013fc:	fd79                	bnez	a0,800013da <growproc+0x22>
      return -1;
    800013fe:	557d                	li	a0,-1
    80001400:	bff9                	j	800013de <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001402:	00b90633          	add	a2,s2,a1
    80001406:	6928                	ld	a0,80(a0)
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	492080e7          	jalr	1170(ra) # 8000089a <uvmdealloc>
    80001410:	85aa                	mv	a1,a0
    80001412:	b7e1                	j	800013da <growproc+0x22>

0000000080001414 <fork>:
{
    80001414:	7179                	addi	sp,sp,-48
    80001416:	f406                	sd	ra,40(sp)
    80001418:	f022                	sd	s0,32(sp)
    8000141a:	ec26                	sd	s1,24(sp)
    8000141c:	e84a                	sd	s2,16(sp)
    8000141e:	e44e                	sd	s3,8(sp)
    80001420:	e052                	sd	s4,0(sp)
    80001422:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001424:	00000097          	auipc	ra,0x0
    80001428:	b80080e7          	jalr	-1152(ra) # 80000fa4 <myproc>
    8000142c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	e0a080e7          	jalr	-502(ra) # 80001238 <allocproc>
    80001436:	10050b63          	beqz	a0,8000154c <fork+0x138>
    8000143a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000143c:	04893603          	ld	a2,72(s2)
    80001440:	692c                	ld	a1,80(a0)
    80001442:	05093503          	ld	a0,80(s2)
    80001446:	fffff097          	auipc	ra,0xfffff
    8000144a:	5f0080e7          	jalr	1520(ra) # 80000a36 <uvmcopy>
    8000144e:	04054663          	bltz	a0,8000149a <fork+0x86>
  np->sz = p->sz;
    80001452:	04893783          	ld	a5,72(s2)
    80001456:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000145a:	05893683          	ld	a3,88(s2)
    8000145e:	87b6                	mv	a5,a3
    80001460:	0589b703          	ld	a4,88(s3)
    80001464:	12068693          	addi	a3,a3,288
    80001468:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000146c:	6788                	ld	a0,8(a5)
    8000146e:	6b8c                	ld	a1,16(a5)
    80001470:	6f90                	ld	a2,24(a5)
    80001472:	01073023          	sd	a6,0(a4)
    80001476:	e708                	sd	a0,8(a4)
    80001478:	eb0c                	sd	a1,16(a4)
    8000147a:	ef10                	sd	a2,24(a4)
    8000147c:	02078793          	addi	a5,a5,32
    80001480:	02070713          	addi	a4,a4,32
    80001484:	fed792e3          	bne	a5,a3,80001468 <fork+0x54>
  np->trapframe->a0 = 0;
    80001488:	0589b783          	ld	a5,88(s3)
    8000148c:	0607b823          	sd	zero,112(a5)
    80001490:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001494:	15000a13          	li	s4,336
    80001498:	a03d                	j	800014c6 <fork+0xb2>
    freeproc(np);
    8000149a:	854e                	mv	a0,s3
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	d32080e7          	jalr	-718(ra) # 800011ce <freeproc>
    release(&np->lock);
    800014a4:	854e                	mv	a0,s3
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	01a080e7          	jalr	26(ra) # 800064c0 <release>
    return -1;
    800014ae:	5a7d                	li	s4,-1
    800014b0:	a069                	j	8000153a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800014b2:	00002097          	auipc	ra,0x2
    800014b6:	730080e7          	jalr	1840(ra) # 80003be2 <filedup>
    800014ba:	009987b3          	add	a5,s3,s1
    800014be:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014c0:	04a1                	addi	s1,s1,8
    800014c2:	01448763          	beq	s1,s4,800014d0 <fork+0xbc>
    if(p->ofile[i])
    800014c6:	009907b3          	add	a5,s2,s1
    800014ca:	6388                	ld	a0,0(a5)
    800014cc:	f17d                	bnez	a0,800014b2 <fork+0x9e>
    800014ce:	bfcd                	j	800014c0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800014d0:	15093503          	ld	a0,336(s2)
    800014d4:	00002097          	auipc	ra,0x2
    800014d8:	894080e7          	jalr	-1900(ra) # 80002d68 <idup>
    800014dc:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014e0:	4641                	li	a2,16
    800014e2:	15890593          	addi	a1,s2,344
    800014e6:	15898513          	addi	a0,s3,344
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	de0080e7          	jalr	-544(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800014f2:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014f6:	854e                	mv	a0,s3
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	fc8080e7          	jalr	-56(ra) # 800064c0 <release>
  acquire(&wait_lock);
    80001500:	00007497          	auipc	s1,0x7
    80001504:	4d848493          	addi	s1,s1,1240 # 800089d8 <wait_lock>
    80001508:	8526                	mv	a0,s1
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	f02080e7          	jalr	-254(ra) # 8000640c <acquire>
  np->parent = p;
    80001512:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001516:	8526                	mv	a0,s1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	fa8080e7          	jalr	-88(ra) # 800064c0 <release>
  acquire(&np->lock);
    80001520:	854e                	mv	a0,s3
    80001522:	00005097          	auipc	ra,0x5
    80001526:	eea080e7          	jalr	-278(ra) # 8000640c <acquire>
  np->state = RUNNABLE;
    8000152a:	478d                	li	a5,3
    8000152c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001530:	854e                	mv	a0,s3
    80001532:	00005097          	auipc	ra,0x5
    80001536:	f8e080e7          	jalr	-114(ra) # 800064c0 <release>
}
    8000153a:	8552                	mv	a0,s4
    8000153c:	70a2                	ld	ra,40(sp)
    8000153e:	7402                	ld	s0,32(sp)
    80001540:	64e2                	ld	s1,24(sp)
    80001542:	6942                	ld	s2,16(sp)
    80001544:	69a2                	ld	s3,8(sp)
    80001546:	6a02                	ld	s4,0(sp)
    80001548:	6145                	addi	sp,sp,48
    8000154a:	8082                	ret
    return -1;
    8000154c:	5a7d                	li	s4,-1
    8000154e:	b7f5                	j	8000153a <fork+0x126>

0000000080001550 <scheduler>:
{
    80001550:	7139                	addi	sp,sp,-64
    80001552:	fc06                	sd	ra,56(sp)
    80001554:	f822                	sd	s0,48(sp)
    80001556:	f426                	sd	s1,40(sp)
    80001558:	f04a                	sd	s2,32(sp)
    8000155a:	ec4e                	sd	s3,24(sp)
    8000155c:	e852                	sd	s4,16(sp)
    8000155e:	e456                	sd	s5,8(sp)
    80001560:	e05a                	sd	s6,0(sp)
    80001562:	0080                	addi	s0,sp,64
    80001564:	8792                	mv	a5,tp
  int id = r_tp();
    80001566:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001568:	00779a93          	slli	s5,a5,0x7
    8000156c:	00007717          	auipc	a4,0x7
    80001570:	45470713          	addi	a4,a4,1108 # 800089c0 <pid_lock>
    80001574:	9756                	add	a4,a4,s5
    80001576:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000157a:	00007717          	auipc	a4,0x7
    8000157e:	47e70713          	addi	a4,a4,1150 # 800089f8 <cpus+0x8>
    80001582:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001584:	498d                	li	s3,3
        p->state = RUNNING;
    80001586:	4b11                	li	s6,4
        c->proc = p;
    80001588:	079e                	slli	a5,a5,0x7
    8000158a:	00007a17          	auipc	s4,0x7
    8000158e:	436a0a13          	addi	s4,s4,1078 # 800089c0 <pid_lock>
    80001592:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001594:	0000d917          	auipc	s2,0xd
    80001598:	45c90913          	addi	s2,s2,1116 # 8000e9f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000159c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015a4:	10079073          	csrw	sstatus,a5
    800015a8:	00008497          	auipc	s1,0x8
    800015ac:	84848493          	addi	s1,s1,-1976 # 80008df0 <proc>
    800015b0:	a03d                	j	800015de <scheduler+0x8e>
        p->state = RUNNING;
    800015b2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015b6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015ba:	06048593          	addi	a1,s1,96
    800015be:	8556                	mv	a0,s5
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	6a4080e7          	jalr	1700(ra) # 80001c64 <swtch>
        c->proc = 0;
    800015c8:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015cc:	8526                	mv	a0,s1
    800015ce:	00005097          	auipc	ra,0x5
    800015d2:	ef2080e7          	jalr	-270(ra) # 800064c0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015d6:	17048493          	addi	s1,s1,368
    800015da:	fd2481e3          	beq	s1,s2,8000159c <scheduler+0x4c>
      acquire(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	e2c080e7          	jalr	-468(ra) # 8000640c <acquire>
      if(p->state == RUNNABLE) {
    800015e8:	4c9c                	lw	a5,24(s1)
    800015ea:	ff3791e3          	bne	a5,s3,800015cc <scheduler+0x7c>
    800015ee:	b7d1                	j	800015b2 <scheduler+0x62>

00000000800015f0 <sched>:
{
    800015f0:	7179                	addi	sp,sp,-48
    800015f2:	f406                	sd	ra,40(sp)
    800015f4:	f022                	sd	s0,32(sp)
    800015f6:	ec26                	sd	s1,24(sp)
    800015f8:	e84a                	sd	s2,16(sp)
    800015fa:	e44e                	sd	s3,8(sp)
    800015fc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	9a6080e7          	jalr	-1626(ra) # 80000fa4 <myproc>
    80001606:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	d8a080e7          	jalr	-630(ra) # 80006392 <holding>
    80001610:	c93d                	beqz	a0,80001686 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001612:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	00007717          	auipc	a4,0x7
    8000161c:	3a870713          	addi	a4,a4,936 # 800089c0 <pid_lock>
    80001620:	97ba                	add	a5,a5,a4
    80001622:	0a87a703          	lw	a4,168(a5)
    80001626:	4785                	li	a5,1
    80001628:	06f71763          	bne	a4,a5,80001696 <sched+0xa6>
  if(p->state == RUNNING)
    8000162c:	4c98                	lw	a4,24(s1)
    8000162e:	4791                	li	a5,4
    80001630:	06f70b63          	beq	a4,a5,800016a6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001634:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001638:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000163a:	efb5                	bnez	a5,800016b6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000163c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000163e:	00007917          	auipc	s2,0x7
    80001642:	38290913          	addi	s2,s2,898 # 800089c0 <pid_lock>
    80001646:	2781                	sext.w	a5,a5
    80001648:	079e                	slli	a5,a5,0x7
    8000164a:	97ca                	add	a5,a5,s2
    8000164c:	0ac7a983          	lw	s3,172(a5)
    80001650:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001652:	2781                	sext.w	a5,a5
    80001654:	079e                	slli	a5,a5,0x7
    80001656:	00007597          	auipc	a1,0x7
    8000165a:	3a258593          	addi	a1,a1,930 # 800089f8 <cpus+0x8>
    8000165e:	95be                	add	a1,a1,a5
    80001660:	06048513          	addi	a0,s1,96
    80001664:	00000097          	auipc	ra,0x0
    80001668:	600080e7          	jalr	1536(ra) # 80001c64 <swtch>
    8000166c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000166e:	2781                	sext.w	a5,a5
    80001670:	079e                	slli	a5,a5,0x7
    80001672:	97ca                	add	a5,a5,s2
    80001674:	0b37a623          	sw	s3,172(a5)
}
    80001678:	70a2                	ld	ra,40(sp)
    8000167a:	7402                	ld	s0,32(sp)
    8000167c:	64e2                	ld	s1,24(sp)
    8000167e:	6942                	ld	s2,16(sp)
    80001680:	69a2                	ld	s3,8(sp)
    80001682:	6145                	addi	sp,sp,48
    80001684:	8082                	ret
    panic("sched p->lock");
    80001686:	00007517          	auipc	a0,0x7
    8000168a:	b8250513          	addi	a0,a0,-1150 # 80008208 <etext+0x208>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	834080e7          	jalr	-1996(ra) # 80005ec2 <panic>
    panic("sched locks");
    80001696:	00007517          	auipc	a0,0x7
    8000169a:	b8250513          	addi	a0,a0,-1150 # 80008218 <etext+0x218>
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	824080e7          	jalr	-2012(ra) # 80005ec2 <panic>
    panic("sched running");
    800016a6:	00007517          	auipc	a0,0x7
    800016aa:	b8250513          	addi	a0,a0,-1150 # 80008228 <etext+0x228>
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	814080e7          	jalr	-2028(ra) # 80005ec2 <panic>
    panic("sched interruptible");
    800016b6:	00007517          	auipc	a0,0x7
    800016ba:	b8250513          	addi	a0,a0,-1150 # 80008238 <etext+0x238>
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	804080e7          	jalr	-2044(ra) # 80005ec2 <panic>

00000000800016c6 <yield>:
{
    800016c6:	1101                	addi	sp,sp,-32
    800016c8:	ec06                	sd	ra,24(sp)
    800016ca:	e822                	sd	s0,16(sp)
    800016cc:	e426                	sd	s1,8(sp)
    800016ce:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016d0:	00000097          	auipc	ra,0x0
    800016d4:	8d4080e7          	jalr	-1836(ra) # 80000fa4 <myproc>
    800016d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016da:	00005097          	auipc	ra,0x5
    800016de:	d32080e7          	jalr	-718(ra) # 8000640c <acquire>
  p->state = RUNNABLE;
    800016e2:	478d                	li	a5,3
    800016e4:	cc9c                	sw	a5,24(s1)
  sched();
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	f0a080e7          	jalr	-246(ra) # 800015f0 <sched>
  release(&p->lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	dd0080e7          	jalr	-560(ra) # 800064c0 <release>
}
    800016f8:	60e2                	ld	ra,24(sp)
    800016fa:	6442                	ld	s0,16(sp)
    800016fc:	64a2                	ld	s1,8(sp)
    800016fe:	6105                	addi	sp,sp,32
    80001700:	8082                	ret

0000000080001702 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001702:	7179                	addi	sp,sp,-48
    80001704:	f406                	sd	ra,40(sp)
    80001706:	f022                	sd	s0,32(sp)
    80001708:	ec26                	sd	s1,24(sp)
    8000170a:	e84a                	sd	s2,16(sp)
    8000170c:	e44e                	sd	s3,8(sp)
    8000170e:	1800                	addi	s0,sp,48
    80001710:	89aa                	mv	s3,a0
    80001712:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001714:	00000097          	auipc	ra,0x0
    80001718:	890080e7          	jalr	-1904(ra) # 80000fa4 <myproc>
    8000171c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	cee080e7          	jalr	-786(ra) # 8000640c <acquire>
  release(lk);
    80001726:	854a                	mv	a0,s2
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	d98080e7          	jalr	-616(ra) # 800064c0 <release>

  // Go to sleep.
  p->chan = chan;
    80001730:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001734:	4789                	li	a5,2
    80001736:	cc9c                	sw	a5,24(s1)

  sched();
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	eb8080e7          	jalr	-328(ra) # 800015f0 <sched>

  // Tidy up.
  p->chan = 0;
    80001740:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001744:	8526                	mv	a0,s1
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	d7a080e7          	jalr	-646(ra) # 800064c0 <release>
  acquire(lk);
    8000174e:	854a                	mv	a0,s2
    80001750:	00005097          	auipc	ra,0x5
    80001754:	cbc080e7          	jalr	-836(ra) # 8000640c <acquire>
}
    80001758:	70a2                	ld	ra,40(sp)
    8000175a:	7402                	ld	s0,32(sp)
    8000175c:	64e2                	ld	s1,24(sp)
    8000175e:	6942                	ld	s2,16(sp)
    80001760:	69a2                	ld	s3,8(sp)
    80001762:	6145                	addi	sp,sp,48
    80001764:	8082                	ret

0000000080001766 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	0080                	addi	s0,sp,64
    80001778:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000177a:	00007497          	auipc	s1,0x7
    8000177e:	67648493          	addi	s1,s1,1654 # 80008df0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001782:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001784:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001786:	0000d917          	auipc	s2,0xd
    8000178a:	26a90913          	addi	s2,s2,618 # 8000e9f0 <tickslock>
    8000178e:	a821                	j	800017a6 <wakeup+0x40>
        p->state = RUNNABLE;
    80001790:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001794:	8526                	mv	a0,s1
    80001796:	00005097          	auipc	ra,0x5
    8000179a:	d2a080e7          	jalr	-726(ra) # 800064c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	17048493          	addi	s1,s1,368
    800017a2:	03248463          	beq	s1,s2,800017ca <wakeup+0x64>
    if(p != myproc()){
    800017a6:	fffff097          	auipc	ra,0xfffff
    800017aa:	7fe080e7          	jalr	2046(ra) # 80000fa4 <myproc>
    800017ae:	fea488e3          	beq	s1,a0,8000179e <wakeup+0x38>
      acquire(&p->lock);
    800017b2:	8526                	mv	a0,s1
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	c58080e7          	jalr	-936(ra) # 8000640c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017bc:	4c9c                	lw	a5,24(s1)
    800017be:	fd379be3          	bne	a5,s3,80001794 <wakeup+0x2e>
    800017c2:	709c                	ld	a5,32(s1)
    800017c4:	fd4798e3          	bne	a5,s4,80001794 <wakeup+0x2e>
    800017c8:	b7e1                	j	80001790 <wakeup+0x2a>
    }
  }
}
    800017ca:	70e2                	ld	ra,56(sp)
    800017cc:	7442                	ld	s0,48(sp)
    800017ce:	74a2                	ld	s1,40(sp)
    800017d0:	7902                	ld	s2,32(sp)
    800017d2:	69e2                	ld	s3,24(sp)
    800017d4:	6a42                	ld	s4,16(sp)
    800017d6:	6aa2                	ld	s5,8(sp)
    800017d8:	6121                	addi	sp,sp,64
    800017da:	8082                	ret

00000000800017dc <reparent>:
{
    800017dc:	7179                	addi	sp,sp,-48
    800017de:	f406                	sd	ra,40(sp)
    800017e0:	f022                	sd	s0,32(sp)
    800017e2:	ec26                	sd	s1,24(sp)
    800017e4:	e84a                	sd	s2,16(sp)
    800017e6:	e44e                	sd	s3,8(sp)
    800017e8:	e052                	sd	s4,0(sp)
    800017ea:	1800                	addi	s0,sp,48
    800017ec:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ee:	00007497          	auipc	s1,0x7
    800017f2:	60248493          	addi	s1,s1,1538 # 80008df0 <proc>
      pp->parent = initproc;
    800017f6:	00007a17          	auipc	s4,0x7
    800017fa:	182a0a13          	addi	s4,s4,386 # 80008978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017fe:	0000d997          	auipc	s3,0xd
    80001802:	1f298993          	addi	s3,s3,498 # 8000e9f0 <tickslock>
    80001806:	a029                	j	80001810 <reparent+0x34>
    80001808:	17048493          	addi	s1,s1,368
    8000180c:	01348d63          	beq	s1,s3,80001826 <reparent+0x4a>
    if(pp->parent == p){
    80001810:	7c9c                	ld	a5,56(s1)
    80001812:	ff279be3          	bne	a5,s2,80001808 <reparent+0x2c>
      pp->parent = initproc;
    80001816:	000a3503          	ld	a0,0(s4)
    8000181a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	f4a080e7          	jalr	-182(ra) # 80001766 <wakeup>
    80001824:	b7d5                	j	80001808 <reparent+0x2c>
}
    80001826:	70a2                	ld	ra,40(sp)
    80001828:	7402                	ld	s0,32(sp)
    8000182a:	64e2                	ld	s1,24(sp)
    8000182c:	6942                	ld	s2,16(sp)
    8000182e:	69a2                	ld	s3,8(sp)
    80001830:	6a02                	ld	s4,0(sp)
    80001832:	6145                	addi	sp,sp,48
    80001834:	8082                	ret

0000000080001836 <exit>:
{
    80001836:	7179                	addi	sp,sp,-48
    80001838:	f406                	sd	ra,40(sp)
    8000183a:	f022                	sd	s0,32(sp)
    8000183c:	ec26                	sd	s1,24(sp)
    8000183e:	e84a                	sd	s2,16(sp)
    80001840:	e44e                	sd	s3,8(sp)
    80001842:	e052                	sd	s4,0(sp)
    80001844:	1800                	addi	s0,sp,48
    80001846:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	75c080e7          	jalr	1884(ra) # 80000fa4 <myproc>
    80001850:	89aa                	mv	s3,a0
  if(p == initproc)
    80001852:	00007797          	auipc	a5,0x7
    80001856:	1267b783          	ld	a5,294(a5) # 80008978 <initproc>
    8000185a:	0d050493          	addi	s1,a0,208
    8000185e:	15050913          	addi	s2,a0,336
    80001862:	02a79363          	bne	a5,a0,80001888 <exit+0x52>
    panic("init exiting");
    80001866:	00007517          	auipc	a0,0x7
    8000186a:	9ea50513          	addi	a0,a0,-1558 # 80008250 <etext+0x250>
    8000186e:	00004097          	auipc	ra,0x4
    80001872:	654080e7          	jalr	1620(ra) # 80005ec2 <panic>
      fileclose(f);
    80001876:	00002097          	auipc	ra,0x2
    8000187a:	3be080e7          	jalr	958(ra) # 80003c34 <fileclose>
      p->ofile[fd] = 0;
    8000187e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001882:	04a1                	addi	s1,s1,8
    80001884:	01248563          	beq	s1,s2,8000188e <exit+0x58>
    if(p->ofile[fd]){
    80001888:	6088                	ld	a0,0(s1)
    8000188a:	f575                	bnez	a0,80001876 <exit+0x40>
    8000188c:	bfdd                	j	80001882 <exit+0x4c>
  begin_op();
    8000188e:	00002097          	auipc	ra,0x2
    80001892:	eda080e7          	jalr	-294(ra) # 80003768 <begin_op>
  iput(p->cwd);
    80001896:	1509b503          	ld	a0,336(s3)
    8000189a:	00001097          	auipc	ra,0x1
    8000189e:	6c6080e7          	jalr	1734(ra) # 80002f60 <iput>
  end_op();
    800018a2:	00002097          	auipc	ra,0x2
    800018a6:	f46080e7          	jalr	-186(ra) # 800037e8 <end_op>
  p->cwd = 0;
    800018aa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018ae:	00007497          	auipc	s1,0x7
    800018b2:	12a48493          	addi	s1,s1,298 # 800089d8 <wait_lock>
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	b54080e7          	jalr	-1196(ra) # 8000640c <acquire>
  reparent(p);
    800018c0:	854e                	mv	a0,s3
    800018c2:	00000097          	auipc	ra,0x0
    800018c6:	f1a080e7          	jalr	-230(ra) # 800017dc <reparent>
  wakeup(p->parent);
    800018ca:	0389b503          	ld	a0,56(s3)
    800018ce:	00000097          	auipc	ra,0x0
    800018d2:	e98080e7          	jalr	-360(ra) # 80001766 <wakeup>
  acquire(&p->lock);
    800018d6:	854e                	mv	a0,s3
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	b34080e7          	jalr	-1228(ra) # 8000640c <acquire>
  p->xstate = status;
    800018e0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018e4:	4795                	li	a5,5
    800018e6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	bd4080e7          	jalr	-1068(ra) # 800064c0 <release>
  sched();
    800018f4:	00000097          	auipc	ra,0x0
    800018f8:	cfc080e7          	jalr	-772(ra) # 800015f0 <sched>
  panic("zombie exit");
    800018fc:	00007517          	auipc	a0,0x7
    80001900:	96450513          	addi	a0,a0,-1692 # 80008260 <etext+0x260>
    80001904:	00004097          	auipc	ra,0x4
    80001908:	5be080e7          	jalr	1470(ra) # 80005ec2 <panic>

000000008000190c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	e84a                	sd	s2,16(sp)
    80001916:	e44e                	sd	s3,8(sp)
    80001918:	1800                	addi	s0,sp,48
    8000191a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000191c:	00007497          	auipc	s1,0x7
    80001920:	4d448493          	addi	s1,s1,1236 # 80008df0 <proc>
    80001924:	0000d997          	auipc	s3,0xd
    80001928:	0cc98993          	addi	s3,s3,204 # 8000e9f0 <tickslock>
    acquire(&p->lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	ade080e7          	jalr	-1314(ra) # 8000640c <acquire>
    if(p->pid == pid){
    80001936:	589c                	lw	a5,48(s1)
    80001938:	01278d63          	beq	a5,s2,80001952 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000193c:	8526                	mv	a0,s1
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	b82080e7          	jalr	-1150(ra) # 800064c0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001946:	17048493          	addi	s1,s1,368
    8000194a:	ff3491e3          	bne	s1,s3,8000192c <kill+0x20>
  }
  return -1;
    8000194e:	557d                	li	a0,-1
    80001950:	a829                	j	8000196a <kill+0x5e>
      p->killed = 1;
    80001952:	4785                	li	a5,1
    80001954:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001956:	4c98                	lw	a4,24(s1)
    80001958:	4789                	li	a5,2
    8000195a:	00f70f63          	beq	a4,a5,80001978 <kill+0x6c>
      release(&p->lock);
    8000195e:	8526                	mv	a0,s1
    80001960:	00005097          	auipc	ra,0x5
    80001964:	b60080e7          	jalr	-1184(ra) # 800064c0 <release>
      return 0;
    80001968:	4501                	li	a0,0
}
    8000196a:	70a2                	ld	ra,40(sp)
    8000196c:	7402                	ld	s0,32(sp)
    8000196e:	64e2                	ld	s1,24(sp)
    80001970:	6942                	ld	s2,16(sp)
    80001972:	69a2                	ld	s3,8(sp)
    80001974:	6145                	addi	sp,sp,48
    80001976:	8082                	ret
        p->state = RUNNABLE;
    80001978:	478d                	li	a5,3
    8000197a:	cc9c                	sw	a5,24(s1)
    8000197c:	b7cd                	j	8000195e <kill+0x52>

000000008000197e <setkilled>:

void
setkilled(struct proc *p)
{
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	e426                	sd	s1,8(sp)
    80001986:	1000                	addi	s0,sp,32
    80001988:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	a82080e7          	jalr	-1406(ra) # 8000640c <acquire>
  p->killed = 1;
    80001992:	4785                	li	a5,1
    80001994:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001996:	8526                	mv	a0,s1
    80001998:	00005097          	auipc	ra,0x5
    8000199c:	b28080e7          	jalr	-1240(ra) # 800064c0 <release>
}
    800019a0:	60e2                	ld	ra,24(sp)
    800019a2:	6442                	ld	s0,16(sp)
    800019a4:	64a2                	ld	s1,8(sp)
    800019a6:	6105                	addi	sp,sp,32
    800019a8:	8082                	ret

00000000800019aa <killed>:

int
killed(struct proc *p)
{
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	e04a                	sd	s2,0(sp)
    800019b4:	1000                	addi	s0,sp,32
    800019b6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019b8:	00005097          	auipc	ra,0x5
    800019bc:	a54080e7          	jalr	-1452(ra) # 8000640c <acquire>
  k = p->killed;
    800019c0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019c4:	8526                	mv	a0,s1
    800019c6:	00005097          	auipc	ra,0x5
    800019ca:	afa080e7          	jalr	-1286(ra) # 800064c0 <release>
  return k;
}
    800019ce:	854a                	mv	a0,s2
    800019d0:	60e2                	ld	ra,24(sp)
    800019d2:	6442                	ld	s0,16(sp)
    800019d4:	64a2                	ld	s1,8(sp)
    800019d6:	6902                	ld	s2,0(sp)
    800019d8:	6105                	addi	sp,sp,32
    800019da:	8082                	ret

00000000800019dc <wait>:
{
    800019dc:	715d                	addi	sp,sp,-80
    800019de:	e486                	sd	ra,72(sp)
    800019e0:	e0a2                	sd	s0,64(sp)
    800019e2:	fc26                	sd	s1,56(sp)
    800019e4:	f84a                	sd	s2,48(sp)
    800019e6:	f44e                	sd	s3,40(sp)
    800019e8:	f052                	sd	s4,32(sp)
    800019ea:	ec56                	sd	s5,24(sp)
    800019ec:	e85a                	sd	s6,16(sp)
    800019ee:	e45e                	sd	s7,8(sp)
    800019f0:	e062                	sd	s8,0(sp)
    800019f2:	0880                	addi	s0,sp,80
    800019f4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	5ae080e7          	jalr	1454(ra) # 80000fa4 <myproc>
    800019fe:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a00:	00007517          	auipc	a0,0x7
    80001a04:	fd850513          	addi	a0,a0,-40 # 800089d8 <wait_lock>
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	a04080e7          	jalr	-1532(ra) # 8000640c <acquire>
    havekids = 0;
    80001a10:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a12:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a14:	0000d997          	auipc	s3,0xd
    80001a18:	fdc98993          	addi	s3,s3,-36 # 8000e9f0 <tickslock>
        havekids = 1;
    80001a1c:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a1e:	00007c17          	auipc	s8,0x7
    80001a22:	fbac0c13          	addi	s8,s8,-70 # 800089d8 <wait_lock>
    havekids = 0;
    80001a26:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a28:	00007497          	auipc	s1,0x7
    80001a2c:	3c848493          	addi	s1,s1,968 # 80008df0 <proc>
    80001a30:	a0bd                	j	80001a9e <wait+0xc2>
          pid = pp->pid;
    80001a32:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a36:	000b0e63          	beqz	s6,80001a52 <wait+0x76>
    80001a3a:	4691                	li	a3,4
    80001a3c:	02c48613          	addi	a2,s1,44
    80001a40:	85da                	mv	a1,s6
    80001a42:	05093503          	ld	a0,80(s2)
    80001a46:	fffff097          	auipc	ra,0xfffff
    80001a4a:	0f4080e7          	jalr	244(ra) # 80000b3a <copyout>
    80001a4e:	02054563          	bltz	a0,80001a78 <wait+0x9c>
          freeproc(pp);
    80001a52:	8526                	mv	a0,s1
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	77a080e7          	jalr	1914(ra) # 800011ce <freeproc>
          release(&pp->lock);
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	00005097          	auipc	ra,0x5
    80001a62:	a62080e7          	jalr	-1438(ra) # 800064c0 <release>
          release(&wait_lock);
    80001a66:	00007517          	auipc	a0,0x7
    80001a6a:	f7250513          	addi	a0,a0,-142 # 800089d8 <wait_lock>
    80001a6e:	00005097          	auipc	ra,0x5
    80001a72:	a52080e7          	jalr	-1454(ra) # 800064c0 <release>
          return pid;
    80001a76:	a0b5                	j	80001ae2 <wait+0x106>
            release(&pp->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	a46080e7          	jalr	-1466(ra) # 800064c0 <release>
            release(&wait_lock);
    80001a82:	00007517          	auipc	a0,0x7
    80001a86:	f5650513          	addi	a0,a0,-170 # 800089d8 <wait_lock>
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	a36080e7          	jalr	-1482(ra) # 800064c0 <release>
            return -1;
    80001a92:	59fd                	li	s3,-1
    80001a94:	a0b9                	j	80001ae2 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a96:	17048493          	addi	s1,s1,368
    80001a9a:	03348463          	beq	s1,s3,80001ac2 <wait+0xe6>
      if(pp->parent == p){
    80001a9e:	7c9c                	ld	a5,56(s1)
    80001aa0:	ff279be3          	bne	a5,s2,80001a96 <wait+0xba>
        acquire(&pp->lock);
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	00005097          	auipc	ra,0x5
    80001aaa:	966080e7          	jalr	-1690(ra) # 8000640c <acquire>
        if(pp->state == ZOMBIE){
    80001aae:	4c9c                	lw	a5,24(s1)
    80001ab0:	f94781e3          	beq	a5,s4,80001a32 <wait+0x56>
        release(&pp->lock);
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	00005097          	auipc	ra,0x5
    80001aba:	a0a080e7          	jalr	-1526(ra) # 800064c0 <release>
        havekids = 1;
    80001abe:	8756                	mv	a4,s5
    80001ac0:	bfd9                	j	80001a96 <wait+0xba>
    if(!havekids || killed(p)){
    80001ac2:	c719                	beqz	a4,80001ad0 <wait+0xf4>
    80001ac4:	854a                	mv	a0,s2
    80001ac6:	00000097          	auipc	ra,0x0
    80001aca:	ee4080e7          	jalr	-284(ra) # 800019aa <killed>
    80001ace:	c51d                	beqz	a0,80001afc <wait+0x120>
      release(&wait_lock);
    80001ad0:	00007517          	auipc	a0,0x7
    80001ad4:	f0850513          	addi	a0,a0,-248 # 800089d8 <wait_lock>
    80001ad8:	00005097          	auipc	ra,0x5
    80001adc:	9e8080e7          	jalr	-1560(ra) # 800064c0 <release>
      return -1;
    80001ae0:	59fd                	li	s3,-1
}
    80001ae2:	854e                	mv	a0,s3
    80001ae4:	60a6                	ld	ra,72(sp)
    80001ae6:	6406                	ld	s0,64(sp)
    80001ae8:	74e2                	ld	s1,56(sp)
    80001aea:	7942                	ld	s2,48(sp)
    80001aec:	79a2                	ld	s3,40(sp)
    80001aee:	7a02                	ld	s4,32(sp)
    80001af0:	6ae2                	ld	s5,24(sp)
    80001af2:	6b42                	ld	s6,16(sp)
    80001af4:	6ba2                	ld	s7,8(sp)
    80001af6:	6c02                	ld	s8,0(sp)
    80001af8:	6161                	addi	sp,sp,80
    80001afa:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001afc:	85e2                	mv	a1,s8
    80001afe:	854a                	mv	a0,s2
    80001b00:	00000097          	auipc	ra,0x0
    80001b04:	c02080e7          	jalr	-1022(ra) # 80001702 <sleep>
    havekids = 0;
    80001b08:	bf39                	j	80001a26 <wait+0x4a>

0000000080001b0a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b0a:	7179                	addi	sp,sp,-48
    80001b0c:	f406                	sd	ra,40(sp)
    80001b0e:	f022                	sd	s0,32(sp)
    80001b10:	ec26                	sd	s1,24(sp)
    80001b12:	e84a                	sd	s2,16(sp)
    80001b14:	e44e                	sd	s3,8(sp)
    80001b16:	e052                	sd	s4,0(sp)
    80001b18:	1800                	addi	s0,sp,48
    80001b1a:	84aa                	mv	s1,a0
    80001b1c:	892e                	mv	s2,a1
    80001b1e:	89b2                	mv	s3,a2
    80001b20:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	482080e7          	jalr	1154(ra) # 80000fa4 <myproc>
  if(user_dst){
    80001b2a:	c08d                	beqz	s1,80001b4c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b2c:	86d2                	mv	a3,s4
    80001b2e:	864e                	mv	a2,s3
    80001b30:	85ca                	mv	a1,s2
    80001b32:	6928                	ld	a0,80(a0)
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	006080e7          	jalr	6(ra) # 80000b3a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b3c:	70a2                	ld	ra,40(sp)
    80001b3e:	7402                	ld	s0,32(sp)
    80001b40:	64e2                	ld	s1,24(sp)
    80001b42:	6942                	ld	s2,16(sp)
    80001b44:	69a2                	ld	s3,8(sp)
    80001b46:	6a02                	ld	s4,0(sp)
    80001b48:	6145                	addi	sp,sp,48
    80001b4a:	8082                	ret
    memmove((char *)dst, src, len);
    80001b4c:	000a061b          	sext.w	a2,s4
    80001b50:	85ce                	mv	a1,s3
    80001b52:	854a                	mv	a0,s2
    80001b54:	ffffe097          	auipc	ra,0xffffe
    80001b58:	684080e7          	jalr	1668(ra) # 800001d8 <memmove>
    return 0;
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	bff9                	j	80001b3c <either_copyout+0x32>

0000000080001b60 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b60:	7179                	addi	sp,sp,-48
    80001b62:	f406                	sd	ra,40(sp)
    80001b64:	f022                	sd	s0,32(sp)
    80001b66:	ec26                	sd	s1,24(sp)
    80001b68:	e84a                	sd	s2,16(sp)
    80001b6a:	e44e                	sd	s3,8(sp)
    80001b6c:	e052                	sd	s4,0(sp)
    80001b6e:	1800                	addi	s0,sp,48
    80001b70:	892a                	mv	s2,a0
    80001b72:	84ae                	mv	s1,a1
    80001b74:	89b2                	mv	s3,a2
    80001b76:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	42c080e7          	jalr	1068(ra) # 80000fa4 <myproc>
  if(user_src){
    80001b80:	c08d                	beqz	s1,80001ba2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b82:	86d2                	mv	a3,s4
    80001b84:	864e                	mv	a2,s3
    80001b86:	85ca                	mv	a1,s2
    80001b88:	6928                	ld	a0,80(a0)
    80001b8a:	fffff097          	auipc	ra,0xfffff
    80001b8e:	070080e7          	jalr	112(ra) # 80000bfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b92:	70a2                	ld	ra,40(sp)
    80001b94:	7402                	ld	s0,32(sp)
    80001b96:	64e2                	ld	s1,24(sp)
    80001b98:	6942                	ld	s2,16(sp)
    80001b9a:	69a2                	ld	s3,8(sp)
    80001b9c:	6a02                	ld	s4,0(sp)
    80001b9e:	6145                	addi	sp,sp,48
    80001ba0:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ba2:	000a061b          	sext.w	a2,s4
    80001ba6:	85ce                	mv	a1,s3
    80001ba8:	854a                	mv	a0,s2
    80001baa:	ffffe097          	auipc	ra,0xffffe
    80001bae:	62e080e7          	jalr	1582(ra) # 800001d8 <memmove>
    return 0;
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	bff9                	j	80001b92 <either_copyin+0x32>

0000000080001bb6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bb6:	715d                	addi	sp,sp,-80
    80001bb8:	e486                	sd	ra,72(sp)
    80001bba:	e0a2                	sd	s0,64(sp)
    80001bbc:	fc26                	sd	s1,56(sp)
    80001bbe:	f84a                	sd	s2,48(sp)
    80001bc0:	f44e                	sd	s3,40(sp)
    80001bc2:	f052                	sd	s4,32(sp)
    80001bc4:	ec56                	sd	s5,24(sp)
    80001bc6:	e85a                	sd	s6,16(sp)
    80001bc8:	e45e                	sd	s7,8(sp)
    80001bca:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bcc:	00006517          	auipc	a0,0x6
    80001bd0:	47c50513          	addi	a0,a0,1148 # 80008048 <etext+0x48>
    80001bd4:	00004097          	auipc	ra,0x4
    80001bd8:	338080e7          	jalr	824(ra) # 80005f0c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bdc:	00007497          	auipc	s1,0x7
    80001be0:	36c48493          	addi	s1,s1,876 # 80008f48 <proc+0x158>
    80001be4:	0000d917          	auipc	s2,0xd
    80001be8:	f6490913          	addi	s2,s2,-156 # 8000eb48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bec:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bee:	00006997          	auipc	s3,0x6
    80001bf2:	68298993          	addi	s3,s3,1666 # 80008270 <etext+0x270>
    printf("%d %s %s", p->pid, state, p->name);
    80001bf6:	00006a97          	auipc	s5,0x6
    80001bfa:	682a8a93          	addi	s5,s5,1666 # 80008278 <etext+0x278>
    printf("\n");
    80001bfe:	00006a17          	auipc	s4,0x6
    80001c02:	44aa0a13          	addi	s4,s4,1098 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c06:	00006b97          	auipc	s7,0x6
    80001c0a:	6b2b8b93          	addi	s7,s7,1714 # 800082b8 <states.1727>
    80001c0e:	a00d                	j	80001c30 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c10:	ed86a583          	lw	a1,-296(a3)
    80001c14:	8556                	mv	a0,s5
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	2f6080e7          	jalr	758(ra) # 80005f0c <printf>
    printf("\n");
    80001c1e:	8552                	mv	a0,s4
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	2ec080e7          	jalr	748(ra) # 80005f0c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c28:	17048493          	addi	s1,s1,368
    80001c2c:	03248163          	beq	s1,s2,80001c4e <procdump+0x98>
    if(p->state == UNUSED)
    80001c30:	86a6                	mv	a3,s1
    80001c32:	ec04a783          	lw	a5,-320(s1)
    80001c36:	dbed                	beqz	a5,80001c28 <procdump+0x72>
      state = "???";
    80001c38:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c3a:	fcfb6be3          	bltu	s6,a5,80001c10 <procdump+0x5a>
    80001c3e:	1782                	slli	a5,a5,0x20
    80001c40:	9381                	srli	a5,a5,0x20
    80001c42:	078e                	slli	a5,a5,0x3
    80001c44:	97de                	add	a5,a5,s7
    80001c46:	6390                	ld	a2,0(a5)
    80001c48:	f661                	bnez	a2,80001c10 <procdump+0x5a>
      state = "???";
    80001c4a:	864e                	mv	a2,s3
    80001c4c:	b7d1                	j	80001c10 <procdump+0x5a>
  }
}
    80001c4e:	60a6                	ld	ra,72(sp)
    80001c50:	6406                	ld	s0,64(sp)
    80001c52:	74e2                	ld	s1,56(sp)
    80001c54:	7942                	ld	s2,48(sp)
    80001c56:	79a2                	ld	s3,40(sp)
    80001c58:	7a02                	ld	s4,32(sp)
    80001c5a:	6ae2                	ld	s5,24(sp)
    80001c5c:	6b42                	ld	s6,16(sp)
    80001c5e:	6ba2                	ld	s7,8(sp)
    80001c60:	6161                	addi	sp,sp,80
    80001c62:	8082                	ret

0000000080001c64 <swtch>:
    80001c64:	00153023          	sd	ra,0(a0)
    80001c68:	00253423          	sd	sp,8(a0)
    80001c6c:	e900                	sd	s0,16(a0)
    80001c6e:	ed04                	sd	s1,24(a0)
    80001c70:	03253023          	sd	s2,32(a0)
    80001c74:	03353423          	sd	s3,40(a0)
    80001c78:	03453823          	sd	s4,48(a0)
    80001c7c:	03553c23          	sd	s5,56(a0)
    80001c80:	05653023          	sd	s6,64(a0)
    80001c84:	05753423          	sd	s7,72(a0)
    80001c88:	05853823          	sd	s8,80(a0)
    80001c8c:	05953c23          	sd	s9,88(a0)
    80001c90:	07a53023          	sd	s10,96(a0)
    80001c94:	07b53423          	sd	s11,104(a0)
    80001c98:	0005b083          	ld	ra,0(a1)
    80001c9c:	0085b103          	ld	sp,8(a1)
    80001ca0:	6980                	ld	s0,16(a1)
    80001ca2:	6d84                	ld	s1,24(a1)
    80001ca4:	0205b903          	ld	s2,32(a1)
    80001ca8:	0285b983          	ld	s3,40(a1)
    80001cac:	0305ba03          	ld	s4,48(a1)
    80001cb0:	0385ba83          	ld	s5,56(a1)
    80001cb4:	0405bb03          	ld	s6,64(a1)
    80001cb8:	0485bb83          	ld	s7,72(a1)
    80001cbc:	0505bc03          	ld	s8,80(a1)
    80001cc0:	0585bc83          	ld	s9,88(a1)
    80001cc4:	0605bd03          	ld	s10,96(a1)
    80001cc8:	0685bd83          	ld	s11,104(a1)
    80001ccc:	8082                	ret

0000000080001cce <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cce:	1141                	addi	sp,sp,-16
    80001cd0:	e406                	sd	ra,8(sp)
    80001cd2:	e022                	sd	s0,0(sp)
    80001cd4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cd6:	00006597          	auipc	a1,0x6
    80001cda:	61258593          	addi	a1,a1,1554 # 800082e8 <states.1727+0x30>
    80001cde:	0000d517          	auipc	a0,0xd
    80001ce2:	d1250513          	addi	a0,a0,-750 # 8000e9f0 <tickslock>
    80001ce6:	00004097          	auipc	ra,0x4
    80001cea:	696080e7          	jalr	1686(ra) # 8000637c <initlock>
}
    80001cee:	60a2                	ld	ra,8(sp)
    80001cf0:	6402                	ld	s0,0(sp)
    80001cf2:	0141                	addi	sp,sp,16
    80001cf4:	8082                	ret

0000000080001cf6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cf6:	1141                	addi	sp,sp,-16
    80001cf8:	e422                	sd	s0,8(sp)
    80001cfa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfc:	00003797          	auipc	a5,0x3
    80001d00:	59478793          	addi	a5,a5,1428 # 80005290 <kernelvec>
    80001d04:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d08:	6422                	ld	s0,8(sp)
    80001d0a:	0141                	addi	sp,sp,16
    80001d0c:	8082                	ret

0000000080001d0e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d0e:	1141                	addi	sp,sp,-16
    80001d10:	e406                	sd	ra,8(sp)
    80001d12:	e022                	sd	s0,0(sp)
    80001d14:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	28e080e7          	jalr	654(ra) # 80000fa4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d22:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d24:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d28:	00005617          	auipc	a2,0x5
    80001d2c:	2d860613          	addi	a2,a2,728 # 80007000 <_trampoline>
    80001d30:	00005697          	auipc	a3,0x5
    80001d34:	2d068693          	addi	a3,a3,720 # 80007000 <_trampoline>
    80001d38:	8e91                	sub	a3,a3,a2
    80001d3a:	040007b7          	lui	a5,0x4000
    80001d3e:	17fd                	addi	a5,a5,-1
    80001d40:	07b2                	slli	a5,a5,0xc
    80001d42:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d44:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d48:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d4a:	180026f3          	csrr	a3,satp
    80001d4e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d50:	6d38                	ld	a4,88(a0)
    80001d52:	6134                	ld	a3,64(a0)
    80001d54:	6585                	lui	a1,0x1
    80001d56:	96ae                	add	a3,a3,a1
    80001d58:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d5a:	6d38                	ld	a4,88(a0)
    80001d5c:	00000697          	auipc	a3,0x0
    80001d60:	13068693          	addi	a3,a3,304 # 80001e8c <usertrap>
    80001d64:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d66:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d68:	8692                	mv	a3,tp
    80001d6a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d70:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d74:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d78:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d7e:	6f18                	ld	a4,24(a4)
    80001d80:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d84:	6928                	ld	a0,80(a0)
    80001d86:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d88:	00005717          	auipc	a4,0x5
    80001d8c:	31470713          	addi	a4,a4,788 # 8000709c <userret>
    80001d90:	8f11                	sub	a4,a4,a2
    80001d92:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d94:	577d                	li	a4,-1
    80001d96:	177e                	slli	a4,a4,0x3f
    80001d98:	8d59                	or	a0,a0,a4
    80001d9a:	9782                	jalr	a5
}
    80001d9c:	60a2                	ld	ra,8(sp)
    80001d9e:	6402                	ld	s0,0(sp)
    80001da0:	0141                	addi	sp,sp,16
    80001da2:	8082                	ret

0000000080001da4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001da4:	1101                	addi	sp,sp,-32
    80001da6:	ec06                	sd	ra,24(sp)
    80001da8:	e822                	sd	s0,16(sp)
    80001daa:	e426                	sd	s1,8(sp)
    80001dac:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001dae:	0000d497          	auipc	s1,0xd
    80001db2:	c4248493          	addi	s1,s1,-958 # 8000e9f0 <tickslock>
    80001db6:	8526                	mv	a0,s1
    80001db8:	00004097          	auipc	ra,0x4
    80001dbc:	654080e7          	jalr	1620(ra) # 8000640c <acquire>
  ticks++;
    80001dc0:	00007517          	auipc	a0,0x7
    80001dc4:	bc050513          	addi	a0,a0,-1088 # 80008980 <ticks>
    80001dc8:	411c                	lw	a5,0(a0)
    80001dca:	2785                	addiw	a5,a5,1
    80001dcc:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	998080e7          	jalr	-1640(ra) # 80001766 <wakeup>
  release(&tickslock);
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	6e8080e7          	jalr	1768(ra) # 800064c0 <release>
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	64a2                	ld	s1,8(sp)
    80001de6:	6105                	addi	sp,sp,32
    80001de8:	8082                	ret

0000000080001dea <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001dea:	1101                	addi	sp,sp,-32
    80001dec:	ec06                	sd	ra,24(sp)
    80001dee:	e822                	sd	s0,16(sp)
    80001df0:	e426                	sd	s1,8(sp)
    80001df2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001df8:	00074d63          	bltz	a4,80001e12 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001dfc:	57fd                	li	a5,-1
    80001dfe:	17fe                	slli	a5,a5,0x3f
    80001e00:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e02:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e04:	06f70363          	beq	a4,a5,80001e6a <devintr+0x80>
  }
}
    80001e08:	60e2                	ld	ra,24(sp)
    80001e0a:	6442                	ld	s0,16(sp)
    80001e0c:	64a2                	ld	s1,8(sp)
    80001e0e:	6105                	addi	sp,sp,32
    80001e10:	8082                	ret
     (scause & 0xff) == 9){
    80001e12:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e16:	46a5                	li	a3,9
    80001e18:	fed792e3          	bne	a5,a3,80001dfc <devintr+0x12>
    int irq = plic_claim();
    80001e1c:	00003097          	auipc	ra,0x3
    80001e20:	57c080e7          	jalr	1404(ra) # 80005398 <plic_claim>
    80001e24:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e26:	47a9                	li	a5,10
    80001e28:	02f50763          	beq	a0,a5,80001e56 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e2c:	4785                	li	a5,1
    80001e2e:	02f50963          	beq	a0,a5,80001e60 <devintr+0x76>
    return 1;
    80001e32:	4505                	li	a0,1
    } else if(irq){
    80001e34:	d8f1                	beqz	s1,80001e08 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e36:	85a6                	mv	a1,s1
    80001e38:	00006517          	auipc	a0,0x6
    80001e3c:	4b850513          	addi	a0,a0,1208 # 800082f0 <states.1727+0x38>
    80001e40:	00004097          	auipc	ra,0x4
    80001e44:	0cc080e7          	jalr	204(ra) # 80005f0c <printf>
      plic_complete(irq);
    80001e48:	8526                	mv	a0,s1
    80001e4a:	00003097          	auipc	ra,0x3
    80001e4e:	572080e7          	jalr	1394(ra) # 800053bc <plic_complete>
    return 1;
    80001e52:	4505                	li	a0,1
    80001e54:	bf55                	j	80001e08 <devintr+0x1e>
      uartintr();
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	4d6080e7          	jalr	1238(ra) # 8000632c <uartintr>
    80001e5e:	b7ed                	j	80001e48 <devintr+0x5e>
      virtio_disk_intr();
    80001e60:	00004097          	auipc	ra,0x4
    80001e64:	a86080e7          	jalr	-1402(ra) # 800058e6 <virtio_disk_intr>
    80001e68:	b7c5                	j	80001e48 <devintr+0x5e>
    if(cpuid() == 0){
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	10e080e7          	jalr	270(ra) # 80000f78 <cpuid>
    80001e72:	c901                	beqz	a0,80001e82 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e74:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e78:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e7a:	14479073          	csrw	sip,a5
    return 2;
    80001e7e:	4509                	li	a0,2
    80001e80:	b761                	j	80001e08 <devintr+0x1e>
      clockintr();
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	f22080e7          	jalr	-222(ra) # 80001da4 <clockintr>
    80001e8a:	b7ed                	j	80001e74 <devintr+0x8a>

0000000080001e8c <usertrap>:
{
    80001e8c:	1101                	addi	sp,sp,-32
    80001e8e:	ec06                	sd	ra,24(sp)
    80001e90:	e822                	sd	s0,16(sp)
    80001e92:	e426                	sd	s1,8(sp)
    80001e94:	e04a                	sd	s2,0(sp)
    80001e96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e98:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e9c:	1007f793          	andi	a5,a5,256
    80001ea0:	e3b1                	bnez	a5,80001ee4 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ea2:	00003797          	auipc	a5,0x3
    80001ea6:	3ee78793          	addi	a5,a5,1006 # 80005290 <kernelvec>
    80001eaa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	0f6080e7          	jalr	246(ra) # 80000fa4 <myproc>
    80001eb6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001eb8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eba:	14102773          	csrr	a4,sepc
    80001ebe:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ec0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ec4:	47a1                	li	a5,8
    80001ec6:	02f70763          	beq	a4,a5,80001ef4 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	f20080e7          	jalr	-224(ra) # 80001dea <devintr>
    80001ed2:	892a                	mv	s2,a0
    80001ed4:	c151                	beqz	a0,80001f58 <usertrap+0xcc>
  if(killed(p))
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	ad2080e7          	jalr	-1326(ra) # 800019aa <killed>
    80001ee0:	c929                	beqz	a0,80001f32 <usertrap+0xa6>
    80001ee2:	a099                	j	80001f28 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001ee4:	00006517          	auipc	a0,0x6
    80001ee8:	42c50513          	addi	a0,a0,1068 # 80008310 <states.1727+0x58>
    80001eec:	00004097          	auipc	ra,0x4
    80001ef0:	fd6080e7          	jalr	-42(ra) # 80005ec2 <panic>
    if(killed(p))
    80001ef4:	00000097          	auipc	ra,0x0
    80001ef8:	ab6080e7          	jalr	-1354(ra) # 800019aa <killed>
    80001efc:	e921                	bnez	a0,80001f4c <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001efe:	6cb8                	ld	a4,88(s1)
    80001f00:	6f1c                	ld	a5,24(a4)
    80001f02:	0791                	addi	a5,a5,4
    80001f04:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f0a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f0e:	10079073          	csrw	sstatus,a5
    syscall();
    80001f12:	00000097          	auipc	ra,0x0
    80001f16:	2d4080e7          	jalr	724(ra) # 800021e6 <syscall>
  if(killed(p))
    80001f1a:	8526                	mv	a0,s1
    80001f1c:	00000097          	auipc	ra,0x0
    80001f20:	a8e080e7          	jalr	-1394(ra) # 800019aa <killed>
    80001f24:	c911                	beqz	a0,80001f38 <usertrap+0xac>
    80001f26:	4901                	li	s2,0
    exit(-1);
    80001f28:	557d                	li	a0,-1
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	90c080e7          	jalr	-1780(ra) # 80001836 <exit>
  if(which_dev == 2)
    80001f32:	4789                	li	a5,2
    80001f34:	04f90f63          	beq	s2,a5,80001f92 <usertrap+0x106>
  usertrapret();
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	dd6080e7          	jalr	-554(ra) # 80001d0e <usertrapret>
}
    80001f40:	60e2                	ld	ra,24(sp)
    80001f42:	6442                	ld	s0,16(sp)
    80001f44:	64a2                	ld	s1,8(sp)
    80001f46:	6902                	ld	s2,0(sp)
    80001f48:	6105                	addi	sp,sp,32
    80001f4a:	8082                	ret
      exit(-1);
    80001f4c:	557d                	li	a0,-1
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	8e8080e7          	jalr	-1816(ra) # 80001836 <exit>
    80001f56:	b765                	j	80001efe <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f58:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f5c:	5890                	lw	a2,48(s1)
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	3d250513          	addi	a0,a0,978 # 80008330 <states.1727+0x78>
    80001f66:	00004097          	auipc	ra,0x4
    80001f6a:	fa6080e7          	jalr	-90(ra) # 80005f0c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f6e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f72:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f76:	00006517          	auipc	a0,0x6
    80001f7a:	3ea50513          	addi	a0,a0,1002 # 80008360 <states.1727+0xa8>
    80001f7e:	00004097          	auipc	ra,0x4
    80001f82:	f8e080e7          	jalr	-114(ra) # 80005f0c <printf>
    setkilled(p);
    80001f86:	8526                	mv	a0,s1
    80001f88:	00000097          	auipc	ra,0x0
    80001f8c:	9f6080e7          	jalr	-1546(ra) # 8000197e <setkilled>
    80001f90:	b769                	j	80001f1a <usertrap+0x8e>
    yield();
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	734080e7          	jalr	1844(ra) # 800016c6 <yield>
    80001f9a:	bf79                	j	80001f38 <usertrap+0xac>

0000000080001f9c <kerneltrap>:
{
    80001f9c:	7179                	addi	sp,sp,-48
    80001f9e:	f406                	sd	ra,40(sp)
    80001fa0:	f022                	sd	s0,32(sp)
    80001fa2:	ec26                	sd	s1,24(sp)
    80001fa4:	e84a                	sd	s2,16(sp)
    80001fa6:	e44e                	sd	s3,8(sp)
    80001fa8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001faa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fb2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fb6:	1004f793          	andi	a5,s1,256
    80001fba:	cb85                	beqz	a5,80001fea <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fbc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fc0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fc2:	ef85                	bnez	a5,80001ffa <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fc4:	00000097          	auipc	ra,0x0
    80001fc8:	e26080e7          	jalr	-474(ra) # 80001dea <devintr>
    80001fcc:	cd1d                	beqz	a0,8000200a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fce:	4789                	li	a5,2
    80001fd0:	06f50a63          	beq	a0,a5,80002044 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fd4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fd8:	10049073          	csrw	sstatus,s1
}
    80001fdc:	70a2                	ld	ra,40(sp)
    80001fde:	7402                	ld	s0,32(sp)
    80001fe0:	64e2                	ld	s1,24(sp)
    80001fe2:	6942                	ld	s2,16(sp)
    80001fe4:	69a2                	ld	s3,8(sp)
    80001fe6:	6145                	addi	sp,sp,48
    80001fe8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	39650513          	addi	a0,a0,918 # 80008380 <states.1727+0xc8>
    80001ff2:	00004097          	auipc	ra,0x4
    80001ff6:	ed0080e7          	jalr	-304(ra) # 80005ec2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	3ae50513          	addi	a0,a0,942 # 800083a8 <states.1727+0xf0>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	ec0080e7          	jalr	-320(ra) # 80005ec2 <panic>
    printf("scause %p\n", scause);
    8000200a:	85ce                	mv	a1,s3
    8000200c:	00006517          	auipc	a0,0x6
    80002010:	3bc50513          	addi	a0,a0,956 # 800083c8 <states.1727+0x110>
    80002014:	00004097          	auipc	ra,0x4
    80002018:	ef8080e7          	jalr	-264(ra) # 80005f0c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000201c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002020:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002024:	00006517          	auipc	a0,0x6
    80002028:	3b450513          	addi	a0,a0,948 # 800083d8 <states.1727+0x120>
    8000202c:	00004097          	auipc	ra,0x4
    80002030:	ee0080e7          	jalr	-288(ra) # 80005f0c <printf>
    panic("kerneltrap");
    80002034:	00006517          	auipc	a0,0x6
    80002038:	3bc50513          	addi	a0,a0,956 # 800083f0 <states.1727+0x138>
    8000203c:	00004097          	auipc	ra,0x4
    80002040:	e86080e7          	jalr	-378(ra) # 80005ec2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	f60080e7          	jalr	-160(ra) # 80000fa4 <myproc>
    8000204c:	d541                	beqz	a0,80001fd4 <kerneltrap+0x38>
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	f56080e7          	jalr	-170(ra) # 80000fa4 <myproc>
    80002056:	4d18                	lw	a4,24(a0)
    80002058:	4791                	li	a5,4
    8000205a:	f6f71de3          	bne	a4,a5,80001fd4 <kerneltrap+0x38>
    yield();
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	668080e7          	jalr	1640(ra) # 800016c6 <yield>
    80002066:	b7bd                	j	80001fd4 <kerneltrap+0x38>

0000000080002068 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	1000                	addi	s0,sp,32
    80002072:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	f30080e7          	jalr	-208(ra) # 80000fa4 <myproc>
  switch (n) {
    8000207c:	4795                	li	a5,5
    8000207e:	0497e163          	bltu	a5,s1,800020c0 <argraw+0x58>
    80002082:	048a                	slli	s1,s1,0x2
    80002084:	00006717          	auipc	a4,0x6
    80002088:	3a470713          	addi	a4,a4,932 # 80008428 <states.1727+0x170>
    8000208c:	94ba                	add	s1,s1,a4
    8000208e:	409c                	lw	a5,0(s1)
    80002090:	97ba                	add	a5,a5,a4
    80002092:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002094:	6d3c                	ld	a5,88(a0)
    80002096:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret
    return p->trapframe->a1;
    800020a2:	6d3c                	ld	a5,88(a0)
    800020a4:	7fa8                	ld	a0,120(a5)
    800020a6:	bfcd                	j	80002098 <argraw+0x30>
    return p->trapframe->a2;
    800020a8:	6d3c                	ld	a5,88(a0)
    800020aa:	63c8                	ld	a0,128(a5)
    800020ac:	b7f5                	j	80002098 <argraw+0x30>
    return p->trapframe->a3;
    800020ae:	6d3c                	ld	a5,88(a0)
    800020b0:	67c8                	ld	a0,136(a5)
    800020b2:	b7dd                	j	80002098 <argraw+0x30>
    return p->trapframe->a4;
    800020b4:	6d3c                	ld	a5,88(a0)
    800020b6:	6bc8                	ld	a0,144(a5)
    800020b8:	b7c5                	j	80002098 <argraw+0x30>
    return p->trapframe->a5;
    800020ba:	6d3c                	ld	a5,88(a0)
    800020bc:	6fc8                	ld	a0,152(a5)
    800020be:	bfe9                	j	80002098 <argraw+0x30>
  panic("argraw");
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	34050513          	addi	a0,a0,832 # 80008400 <states.1727+0x148>
    800020c8:	00004097          	auipc	ra,0x4
    800020cc:	dfa080e7          	jalr	-518(ra) # 80005ec2 <panic>

00000000800020d0 <fetchaddr>:
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	e04a                	sd	s2,0(sp)
    800020da:	1000                	addi	s0,sp,32
    800020dc:	84aa                	mv	s1,a0
    800020de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	ec4080e7          	jalr	-316(ra) # 80000fa4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800020e8:	653c                	ld	a5,72(a0)
    800020ea:	02f4f863          	bgeu	s1,a5,8000211a <fetchaddr+0x4a>
    800020ee:	00848713          	addi	a4,s1,8
    800020f2:	02e7e663          	bltu	a5,a4,8000211e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020f6:	46a1                	li	a3,8
    800020f8:	8626                	mv	a2,s1
    800020fa:	85ca                	mv	a1,s2
    800020fc:	6928                	ld	a0,80(a0)
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	afc080e7          	jalr	-1284(ra) # 80000bfa <copyin>
    80002106:	00a03533          	snez	a0,a0
    8000210a:	40a00533          	neg	a0,a0
}
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	64a2                	ld	s1,8(sp)
    80002114:	6902                	ld	s2,0(sp)
    80002116:	6105                	addi	sp,sp,32
    80002118:	8082                	ret
    return -1;
    8000211a:	557d                	li	a0,-1
    8000211c:	bfcd                	j	8000210e <fetchaddr+0x3e>
    8000211e:	557d                	li	a0,-1
    80002120:	b7fd                	j	8000210e <fetchaddr+0x3e>

0000000080002122 <fetchstr>:
{
    80002122:	7179                	addi	sp,sp,-48
    80002124:	f406                	sd	ra,40(sp)
    80002126:	f022                	sd	s0,32(sp)
    80002128:	ec26                	sd	s1,24(sp)
    8000212a:	e84a                	sd	s2,16(sp)
    8000212c:	e44e                	sd	s3,8(sp)
    8000212e:	1800                	addi	s0,sp,48
    80002130:	892a                	mv	s2,a0
    80002132:	84ae                	mv	s1,a1
    80002134:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	e6e080e7          	jalr	-402(ra) # 80000fa4 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000213e:	86ce                	mv	a3,s3
    80002140:	864a                	mv	a2,s2
    80002142:	85a6                	mv	a1,s1
    80002144:	6928                	ld	a0,80(a0)
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	b40080e7          	jalr	-1216(ra) # 80000c86 <copyinstr>
    8000214e:	00054e63          	bltz	a0,8000216a <fetchstr+0x48>
  return strlen(buf);
    80002152:	8526                	mv	a0,s1
    80002154:	ffffe097          	auipc	ra,0xffffe
    80002158:	1a8080e7          	jalr	424(ra) # 800002fc <strlen>
}
    8000215c:	70a2                	ld	ra,40(sp)
    8000215e:	7402                	ld	s0,32(sp)
    80002160:	64e2                	ld	s1,24(sp)
    80002162:	6942                	ld	s2,16(sp)
    80002164:	69a2                	ld	s3,8(sp)
    80002166:	6145                	addi	sp,sp,48
    80002168:	8082                	ret
    return -1;
    8000216a:	557d                	li	a0,-1
    8000216c:	bfc5                	j	8000215c <fetchstr+0x3a>

000000008000216e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	1000                	addi	s0,sp,32
    80002178:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	eee080e7          	jalr	-274(ra) # 80002068 <argraw>
    80002182:	c088                	sw	a0,0(s1)
}
    80002184:	60e2                	ld	ra,24(sp)
    80002186:	6442                	ld	s0,16(sp)
    80002188:	64a2                	ld	s1,8(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret

000000008000218e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000218e:	1101                	addi	sp,sp,-32
    80002190:	ec06                	sd	ra,24(sp)
    80002192:	e822                	sd	s0,16(sp)
    80002194:	e426                	sd	s1,8(sp)
    80002196:	1000                	addi	s0,sp,32
    80002198:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	ece080e7          	jalr	-306(ra) # 80002068 <argraw>
    800021a2:	e088                	sd	a0,0(s1)
}
    800021a4:	60e2                	ld	ra,24(sp)
    800021a6:	6442                	ld	s0,16(sp)
    800021a8:	64a2                	ld	s1,8(sp)
    800021aa:	6105                	addi	sp,sp,32
    800021ac:	8082                	ret

00000000800021ae <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021ae:	7179                	addi	sp,sp,-48
    800021b0:	f406                	sd	ra,40(sp)
    800021b2:	f022                	sd	s0,32(sp)
    800021b4:	ec26                	sd	s1,24(sp)
    800021b6:	e84a                	sd	s2,16(sp)
    800021b8:	1800                	addi	s0,sp,48
    800021ba:	84ae                	mv	s1,a1
    800021bc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800021be:	fd840593          	addi	a1,s0,-40
    800021c2:	00000097          	auipc	ra,0x0
    800021c6:	fcc080e7          	jalr	-52(ra) # 8000218e <argaddr>
  return fetchstr(addr, buf, max);
    800021ca:	864a                	mv	a2,s2
    800021cc:	85a6                	mv	a1,s1
    800021ce:	fd843503          	ld	a0,-40(s0)
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	f50080e7          	jalr	-176(ra) # 80002122 <fetchstr>
}
    800021da:	70a2                	ld	ra,40(sp)
    800021dc:	7402                	ld	s0,32(sp)
    800021de:	64e2                	ld	s1,24(sp)
    800021e0:	6942                	ld	s2,16(sp)
    800021e2:	6145                	addi	sp,sp,48
    800021e4:	8082                	ret

00000000800021e6 <syscall>:



void
syscall(void)
{
    800021e6:	1101                	addi	sp,sp,-32
    800021e8:	ec06                	sd	ra,24(sp)
    800021ea:	e822                	sd	s0,16(sp)
    800021ec:	e426                	sd	s1,8(sp)
    800021ee:	e04a                	sd	s2,0(sp)
    800021f0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	db2080e7          	jalr	-590(ra) # 80000fa4 <myproc>
    800021fa:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021fc:	05853903          	ld	s2,88(a0)
    80002200:	0a893783          	ld	a5,168(s2)
    80002204:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002208:	37fd                	addiw	a5,a5,-1
    8000220a:	4775                	li	a4,29
    8000220c:	00f76f63          	bltu	a4,a5,8000222a <syscall+0x44>
    80002210:	00369713          	slli	a4,a3,0x3
    80002214:	00006797          	auipc	a5,0x6
    80002218:	22c78793          	addi	a5,a5,556 # 80008440 <syscalls>
    8000221c:	97ba                	add	a5,a5,a4
    8000221e:	639c                	ld	a5,0(a5)
    80002220:	c789                	beqz	a5,8000222a <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002222:	9782                	jalr	a5
    80002224:	06a93823          	sd	a0,112(s2)
    80002228:	a839                	j	80002246 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000222a:	15848613          	addi	a2,s1,344
    8000222e:	588c                	lw	a1,48(s1)
    80002230:	00006517          	auipc	a0,0x6
    80002234:	1d850513          	addi	a0,a0,472 # 80008408 <states.1727+0x150>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	cd4080e7          	jalr	-812(ra) # 80005f0c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002240:	6cbc                	ld	a5,88(s1)
    80002242:	577d                	li	a4,-1
    80002244:	fbb8                	sd	a4,112(a5)
  }
}
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	64a2                	ld	s1,8(sp)
    8000224c:	6902                	ld	s2,0(sp)
    8000224e:	6105                	addi	sp,sp,32
    80002250:	8082                	ret

0000000080002252 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002252:	1101                	addi	sp,sp,-32
    80002254:	ec06                	sd	ra,24(sp)
    80002256:	e822                	sd	s0,16(sp)
    80002258:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000225a:	fec40593          	addi	a1,s0,-20
    8000225e:	4501                	li	a0,0
    80002260:	00000097          	auipc	ra,0x0
    80002264:	f0e080e7          	jalr	-242(ra) # 8000216e <argint>
  exit(n);
    80002268:	fec42503          	lw	a0,-20(s0)
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	5ca080e7          	jalr	1482(ra) # 80001836 <exit>
  return 0;  // not reached
}
    80002274:	4501                	li	a0,0
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	6105                	addi	sp,sp,32
    8000227c:	8082                	ret

000000008000227e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000227e:	1141                	addi	sp,sp,-16
    80002280:	e406                	sd	ra,8(sp)
    80002282:	e022                	sd	s0,0(sp)
    80002284:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	d1e080e7          	jalr	-738(ra) # 80000fa4 <myproc>
}
    8000228e:	5908                	lw	a0,48(a0)
    80002290:	60a2                	ld	ra,8(sp)
    80002292:	6402                	ld	s0,0(sp)
    80002294:	0141                	addi	sp,sp,16
    80002296:	8082                	ret

0000000080002298 <sys_fork>:

uint64
sys_fork(void)
{
    80002298:	1141                	addi	sp,sp,-16
    8000229a:	e406                	sd	ra,8(sp)
    8000229c:	e022                	sd	s0,0(sp)
    8000229e:	0800                	addi	s0,sp,16
  return fork();
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	174080e7          	jalr	372(ra) # 80001414 <fork>
}
    800022a8:	60a2                	ld	ra,8(sp)
    800022aa:	6402                	ld	s0,0(sp)
    800022ac:	0141                	addi	sp,sp,16
    800022ae:	8082                	ret

00000000800022b0 <sys_wait>:

uint64
sys_wait(void)
{
    800022b0:	1101                	addi	sp,sp,-32
    800022b2:	ec06                	sd	ra,24(sp)
    800022b4:	e822                	sd	s0,16(sp)
    800022b6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022b8:	fe840593          	addi	a1,s0,-24
    800022bc:	4501                	li	a0,0
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	ed0080e7          	jalr	-304(ra) # 8000218e <argaddr>
  return wait(p);
    800022c6:	fe843503          	ld	a0,-24(s0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	712080e7          	jalr	1810(ra) # 800019dc <wait>
}
    800022d2:	60e2                	ld	ra,24(sp)
    800022d4:	6442                	ld	s0,16(sp)
    800022d6:	6105                	addi	sp,sp,32
    800022d8:	8082                	ret

00000000800022da <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022da:	7179                	addi	sp,sp,-48
    800022dc:	f406                	sd	ra,40(sp)
    800022de:	f022                	sd	s0,32(sp)
    800022e0:	ec26                	sd	s1,24(sp)
    800022e2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800022e4:	fdc40593          	addi	a1,s0,-36
    800022e8:	4501                	li	a0,0
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	e84080e7          	jalr	-380(ra) # 8000216e <argint>
  addr = myproc()->sz;
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	cb2080e7          	jalr	-846(ra) # 80000fa4 <myproc>
    800022fa:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800022fc:	fdc42503          	lw	a0,-36(s0)
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	0b8080e7          	jalr	184(ra) # 800013b8 <growproc>
    80002308:	00054863          	bltz	a0,80002318 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000230c:	8526                	mv	a0,s1
    8000230e:	70a2                	ld	ra,40(sp)
    80002310:	7402                	ld	s0,32(sp)
    80002312:	64e2                	ld	s1,24(sp)
    80002314:	6145                	addi	sp,sp,48
    80002316:	8082                	ret
    return -1;
    80002318:	54fd                	li	s1,-1
    8000231a:	bfcd                	j	8000230c <sys_sbrk+0x32>

000000008000231c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000231c:	7139                	addi	sp,sp,-64
    8000231e:	fc06                	sd	ra,56(sp)
    80002320:	f822                	sd	s0,48(sp)
    80002322:	f426                	sd	s1,40(sp)
    80002324:	f04a                	sd	s2,32(sp)
    80002326:	ec4e                	sd	s3,24(sp)
    80002328:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    8000232a:	fcc40593          	addi	a1,s0,-52
    8000232e:	4501                	li	a0,0
    80002330:	00000097          	auipc	ra,0x0
    80002334:	e3e080e7          	jalr	-450(ra) # 8000216e <argint>
  acquire(&tickslock);
    80002338:	0000c517          	auipc	a0,0xc
    8000233c:	6b850513          	addi	a0,a0,1720 # 8000e9f0 <tickslock>
    80002340:	00004097          	auipc	ra,0x4
    80002344:	0cc080e7          	jalr	204(ra) # 8000640c <acquire>
  ticks0 = ticks;
    80002348:	00006917          	auipc	s2,0x6
    8000234c:	63892903          	lw	s2,1592(s2) # 80008980 <ticks>
  while(ticks - ticks0 < n){
    80002350:	fcc42783          	lw	a5,-52(s0)
    80002354:	cf9d                	beqz	a5,80002392 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002356:	0000c997          	auipc	s3,0xc
    8000235a:	69a98993          	addi	s3,s3,1690 # 8000e9f0 <tickslock>
    8000235e:	00006497          	auipc	s1,0x6
    80002362:	62248493          	addi	s1,s1,1570 # 80008980 <ticks>
    if(killed(myproc())){
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	c3e080e7          	jalr	-962(ra) # 80000fa4 <myproc>
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	63c080e7          	jalr	1596(ra) # 800019aa <killed>
    80002376:	ed15                	bnez	a0,800023b2 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002378:	85ce                	mv	a1,s3
    8000237a:	8526                	mv	a0,s1
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	386080e7          	jalr	902(ra) # 80001702 <sleep>
  while(ticks - ticks0 < n){
    80002384:	409c                	lw	a5,0(s1)
    80002386:	412787bb          	subw	a5,a5,s2
    8000238a:	fcc42703          	lw	a4,-52(s0)
    8000238e:	fce7ece3          	bltu	a5,a4,80002366 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002392:	0000c517          	auipc	a0,0xc
    80002396:	65e50513          	addi	a0,a0,1630 # 8000e9f0 <tickslock>
    8000239a:	00004097          	auipc	ra,0x4
    8000239e:	126080e7          	jalr	294(ra) # 800064c0 <release>
  return 0;
    800023a2:	4501                	li	a0,0
}
    800023a4:	70e2                	ld	ra,56(sp)
    800023a6:	7442                	ld	s0,48(sp)
    800023a8:	74a2                	ld	s1,40(sp)
    800023aa:	7902                	ld	s2,32(sp)
    800023ac:	69e2                	ld	s3,24(sp)
    800023ae:	6121                	addi	sp,sp,64
    800023b0:	8082                	ret
      release(&tickslock);
    800023b2:	0000c517          	auipc	a0,0xc
    800023b6:	63e50513          	addi	a0,a0,1598 # 8000e9f0 <tickslock>
    800023ba:	00004097          	auipc	ra,0x4
    800023be:	106080e7          	jalr	262(ra) # 800064c0 <release>
      return -1;
    800023c2:	557d                	li	a0,-1
    800023c4:	b7c5                	j	800023a4 <sys_sleep+0x88>

00000000800023c6 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800023c6:	715d                	addi	sp,sp,-80
    800023c8:	e486                	sd	ra,72(sp)
    800023ca:	e0a2                	sd	s0,64(sp)
    800023cc:	fc26                	sd	s1,56(sp)
    800023ce:	f84a                	sd	s2,48(sp)
    800023d0:	f44e                	sd	s3,40(sp)
    800023d2:	f052                	sd	s4,32(sp)
    800023d4:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  //new!
  uint64 va;           //virtual address
  int pagenum;         //number of pagetable
  uint64 bufaddr;     //buffer address
  uint64 bitmask = 0;      //store bitmask
    800023d6:	fa043823          	sd	zero,-80(s0)

  argaddr(0,&va);
    800023da:	fc840593          	addi	a1,s0,-56
    800023de:	4501                	li	a0,0
    800023e0:	00000097          	auipc	ra,0x0
    800023e4:	dae080e7          	jalr	-594(ra) # 8000218e <argaddr>
  argint(1,&pagenum);
    800023e8:	fc440593          	addi	a1,s0,-60
    800023ec:	4505                	li	a0,1
    800023ee:	00000097          	auipc	ra,0x0
    800023f2:	d80080e7          	jalr	-640(ra) # 8000216e <argint>
  argaddr(2,&bufaddr);
    800023f6:	fb840593          	addi	a1,s0,-72
    800023fa:	4509                	li	a0,2
    800023fc:	00000097          	auipc	ra,0x0
    80002400:	d92080e7          	jalr	-622(ra) # 8000218e <argaddr>

  struct proc *cur_proc = myproc(); //get current process
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	ba0080e7          	jalr	-1120(ra) # 80000fa4 <myproc>
    8000240c:	892a                	mv	s2,a0

  for(int i = 0;i<pagenum;i++)
    8000240e:	fc442783          	lw	a5,-60(s0)
    80002412:	04f05b63          	blez	a5,80002468 <sys_pgaccess+0xa2>
    80002416:	4481                	li	s1,0
  {
    pte_t *pte = walk(cur_proc->pagetable, va+i*PGSIZE, 0);
    if ((*pte) & PTE_A)
      bitmask = bitmask | (1L << i);
    80002418:	4985                	li	s3,1
    8000241a:	a821                	j	80002432 <sys_pgaccess+0x6c>
    *pte = ~(*pte & PTE_A) & *pte;
    8000241c:	611c                	ld	a5,0(a0)
    8000241e:	fbf7f793          	andi	a5,a5,-65
    80002422:	e11c                	sd	a5,0(a0)
  for(int i = 0;i<pagenum;i++)
    80002424:	0485                	addi	s1,s1,1
    80002426:	fc442703          	lw	a4,-60(s0)
    8000242a:	0004879b          	sext.w	a5,s1
    8000242e:	02e7dd63          	bge	a5,a4,80002468 <sys_pgaccess+0xa2>
    80002432:	00048a1b          	sext.w	s4,s1
    pte_t *pte = walk(cur_proc->pagetable, va+i*PGSIZE, 0);
    80002436:	00c49593          	slli	a1,s1,0xc
    8000243a:	4601                	li	a2,0
    8000243c:	fc843783          	ld	a5,-56(s0)
    80002440:	95be                	add	a1,a1,a5
    80002442:	05093503          	ld	a0,80(s2)
    80002446:	ffffe097          	auipc	ra,0xffffe
    8000244a:	01e080e7          	jalr	30(ra) # 80000464 <walk>
    if ((*pte) & PTE_A)
    8000244e:	611c                	ld	a5,0(a0)
    80002450:	0407f793          	andi	a5,a5,64
    80002454:	d7e1                	beqz	a5,8000241c <sys_pgaccess+0x56>
      bitmask = bitmask | (1L << i);
    80002456:	01499a33          	sll	s4,s3,s4
    8000245a:	fb043783          	ld	a5,-80(s0)
    8000245e:	0147ea33          	or	s4,a5,s4
    80002462:	fb443823          	sd	s4,-80(s0)
    80002466:	bf5d                	j	8000241c <sys_pgaccess+0x56>
  }
  if (copyout(cur_proc->pagetable, bufaddr, (char *) &bitmask, sizeof(bitmask)) < 0)
    80002468:	46a1                	li	a3,8
    8000246a:	fb040613          	addi	a2,s0,-80
    8000246e:	fb843583          	ld	a1,-72(s0)
    80002472:	05093503          	ld	a0,80(s2)
    80002476:	ffffe097          	auipc	ra,0xffffe
    8000247a:	6c4080e7          	jalr	1732(ra) # 80000b3a <copyout>
    return -1;
  return 0;
}
    8000247e:	41f5551b          	sraiw	a0,a0,0x1f
    80002482:	60a6                	ld	ra,72(sp)
    80002484:	6406                	ld	s0,64(sp)
    80002486:	74e2                	ld	s1,56(sp)
    80002488:	7942                	ld	s2,48(sp)
    8000248a:	79a2                	ld	s3,40(sp)
    8000248c:	7a02                	ld	s4,32(sp)
    8000248e:	6161                	addi	sp,sp,80
    80002490:	8082                	ret

0000000080002492 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002492:	1101                	addi	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000249a:	fec40593          	addi	a1,s0,-20
    8000249e:	4501                	li	a0,0
    800024a0:	00000097          	auipc	ra,0x0
    800024a4:	cce080e7          	jalr	-818(ra) # 8000216e <argint>
  return kill(pid);
    800024a8:	fec42503          	lw	a0,-20(s0)
    800024ac:	fffff097          	auipc	ra,0xfffff
    800024b0:	460080e7          	jalr	1120(ra) # 8000190c <kill>
}
    800024b4:	60e2                	ld	ra,24(sp)
    800024b6:	6442                	ld	s0,16(sp)
    800024b8:	6105                	addi	sp,sp,32
    800024ba:	8082                	ret

00000000800024bc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024bc:	1101                	addi	sp,sp,-32
    800024be:	ec06                	sd	ra,24(sp)
    800024c0:	e822                	sd	s0,16(sp)
    800024c2:	e426                	sd	s1,8(sp)
    800024c4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024c6:	0000c517          	auipc	a0,0xc
    800024ca:	52a50513          	addi	a0,a0,1322 # 8000e9f0 <tickslock>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	f3e080e7          	jalr	-194(ra) # 8000640c <acquire>
  xticks = ticks;
    800024d6:	00006497          	auipc	s1,0x6
    800024da:	4aa4a483          	lw	s1,1194(s1) # 80008980 <ticks>
  release(&tickslock);
    800024de:	0000c517          	auipc	a0,0xc
    800024e2:	51250513          	addi	a0,a0,1298 # 8000e9f0 <tickslock>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	fda080e7          	jalr	-38(ra) # 800064c0 <release>
  return xticks;
}
    800024ee:	02049513          	slli	a0,s1,0x20
    800024f2:	9101                	srli	a0,a0,0x20
    800024f4:	60e2                	ld	ra,24(sp)
    800024f6:	6442                	ld	s0,16(sp)
    800024f8:	64a2                	ld	s1,8(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret

00000000800024fe <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024fe:	7179                	addi	sp,sp,-48
    80002500:	f406                	sd	ra,40(sp)
    80002502:	f022                	sd	s0,32(sp)
    80002504:	ec26                	sd	s1,24(sp)
    80002506:	e84a                	sd	s2,16(sp)
    80002508:	e44e                	sd	s3,8(sp)
    8000250a:	e052                	sd	s4,0(sp)
    8000250c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000250e:	00006597          	auipc	a1,0x6
    80002512:	02a58593          	addi	a1,a1,42 # 80008538 <syscalls+0xf8>
    80002516:	0000c517          	auipc	a0,0xc
    8000251a:	4f250513          	addi	a0,a0,1266 # 8000ea08 <bcache>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	e5e080e7          	jalr	-418(ra) # 8000637c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002526:	00014797          	auipc	a5,0x14
    8000252a:	4e278793          	addi	a5,a5,1250 # 80016a08 <bcache+0x8000>
    8000252e:	00014717          	auipc	a4,0x14
    80002532:	74270713          	addi	a4,a4,1858 # 80016c70 <bcache+0x8268>
    80002536:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000253a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000253e:	0000c497          	auipc	s1,0xc
    80002542:	4e248493          	addi	s1,s1,1250 # 8000ea20 <bcache+0x18>
    b->next = bcache.head.next;
    80002546:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002548:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000254a:	00006a17          	auipc	s4,0x6
    8000254e:	ff6a0a13          	addi	s4,s4,-10 # 80008540 <syscalls+0x100>
    b->next = bcache.head.next;
    80002552:	2b893783          	ld	a5,696(s2)
    80002556:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002558:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000255c:	85d2                	mv	a1,s4
    8000255e:	01048513          	addi	a0,s1,16
    80002562:	00001097          	auipc	ra,0x1
    80002566:	4c4080e7          	jalr	1220(ra) # 80003a26 <initsleeplock>
    bcache.head.next->prev = b;
    8000256a:	2b893783          	ld	a5,696(s2)
    8000256e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002570:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002574:	45848493          	addi	s1,s1,1112
    80002578:	fd349de3          	bne	s1,s3,80002552 <binit+0x54>
  }
}
    8000257c:	70a2                	ld	ra,40(sp)
    8000257e:	7402                	ld	s0,32(sp)
    80002580:	64e2                	ld	s1,24(sp)
    80002582:	6942                	ld	s2,16(sp)
    80002584:	69a2                	ld	s3,8(sp)
    80002586:	6a02                	ld	s4,0(sp)
    80002588:	6145                	addi	sp,sp,48
    8000258a:	8082                	ret

000000008000258c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000258c:	7179                	addi	sp,sp,-48
    8000258e:	f406                	sd	ra,40(sp)
    80002590:	f022                	sd	s0,32(sp)
    80002592:	ec26                	sd	s1,24(sp)
    80002594:	e84a                	sd	s2,16(sp)
    80002596:	e44e                	sd	s3,8(sp)
    80002598:	1800                	addi	s0,sp,48
    8000259a:	89aa                	mv	s3,a0
    8000259c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000259e:	0000c517          	auipc	a0,0xc
    800025a2:	46a50513          	addi	a0,a0,1130 # 8000ea08 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	e66080e7          	jalr	-410(ra) # 8000640c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025ae:	00014497          	auipc	s1,0x14
    800025b2:	7124b483          	ld	s1,1810(s1) # 80016cc0 <bcache+0x82b8>
    800025b6:	00014797          	auipc	a5,0x14
    800025ba:	6ba78793          	addi	a5,a5,1722 # 80016c70 <bcache+0x8268>
    800025be:	02f48f63          	beq	s1,a5,800025fc <bread+0x70>
    800025c2:	873e                	mv	a4,a5
    800025c4:	a021                	j	800025cc <bread+0x40>
    800025c6:	68a4                	ld	s1,80(s1)
    800025c8:	02e48a63          	beq	s1,a4,800025fc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025cc:	449c                	lw	a5,8(s1)
    800025ce:	ff379ce3          	bne	a5,s3,800025c6 <bread+0x3a>
    800025d2:	44dc                	lw	a5,12(s1)
    800025d4:	ff2799e3          	bne	a5,s2,800025c6 <bread+0x3a>
      b->refcnt++;
    800025d8:	40bc                	lw	a5,64(s1)
    800025da:	2785                	addiw	a5,a5,1
    800025dc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025de:	0000c517          	auipc	a0,0xc
    800025e2:	42a50513          	addi	a0,a0,1066 # 8000ea08 <bcache>
    800025e6:	00004097          	auipc	ra,0x4
    800025ea:	eda080e7          	jalr	-294(ra) # 800064c0 <release>
      acquiresleep(&b->lock);
    800025ee:	01048513          	addi	a0,s1,16
    800025f2:	00001097          	auipc	ra,0x1
    800025f6:	46e080e7          	jalr	1134(ra) # 80003a60 <acquiresleep>
      return b;
    800025fa:	a8b9                	j	80002658 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025fc:	00014497          	auipc	s1,0x14
    80002600:	6bc4b483          	ld	s1,1724(s1) # 80016cb8 <bcache+0x82b0>
    80002604:	00014797          	auipc	a5,0x14
    80002608:	66c78793          	addi	a5,a5,1644 # 80016c70 <bcache+0x8268>
    8000260c:	00f48863          	beq	s1,a5,8000261c <bread+0x90>
    80002610:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002612:	40bc                	lw	a5,64(s1)
    80002614:	cf81                	beqz	a5,8000262c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002616:	64a4                	ld	s1,72(s1)
    80002618:	fee49de3          	bne	s1,a4,80002612 <bread+0x86>
  panic("bget: no buffers");
    8000261c:	00006517          	auipc	a0,0x6
    80002620:	f2c50513          	addi	a0,a0,-212 # 80008548 <syscalls+0x108>
    80002624:	00004097          	auipc	ra,0x4
    80002628:	89e080e7          	jalr	-1890(ra) # 80005ec2 <panic>
      b->dev = dev;
    8000262c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002630:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002634:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002638:	4785                	li	a5,1
    8000263a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000263c:	0000c517          	auipc	a0,0xc
    80002640:	3cc50513          	addi	a0,a0,972 # 8000ea08 <bcache>
    80002644:	00004097          	auipc	ra,0x4
    80002648:	e7c080e7          	jalr	-388(ra) # 800064c0 <release>
      acquiresleep(&b->lock);
    8000264c:	01048513          	addi	a0,s1,16
    80002650:	00001097          	auipc	ra,0x1
    80002654:	410080e7          	jalr	1040(ra) # 80003a60 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002658:	409c                	lw	a5,0(s1)
    8000265a:	cb89                	beqz	a5,8000266c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000265c:	8526                	mv	a0,s1
    8000265e:	70a2                	ld	ra,40(sp)
    80002660:	7402                	ld	s0,32(sp)
    80002662:	64e2                	ld	s1,24(sp)
    80002664:	6942                	ld	s2,16(sp)
    80002666:	69a2                	ld	s3,8(sp)
    80002668:	6145                	addi	sp,sp,48
    8000266a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000266c:	4581                	li	a1,0
    8000266e:	8526                	mv	a0,s1
    80002670:	00003097          	auipc	ra,0x3
    80002674:	fe8080e7          	jalr	-24(ra) # 80005658 <virtio_disk_rw>
    b->valid = 1;
    80002678:	4785                	li	a5,1
    8000267a:	c09c                	sw	a5,0(s1)
  return b;
    8000267c:	b7c5                	j	8000265c <bread+0xd0>

000000008000267e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000267e:	1101                	addi	sp,sp,-32
    80002680:	ec06                	sd	ra,24(sp)
    80002682:	e822                	sd	s0,16(sp)
    80002684:	e426                	sd	s1,8(sp)
    80002686:	1000                	addi	s0,sp,32
    80002688:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000268a:	0541                	addi	a0,a0,16
    8000268c:	00001097          	auipc	ra,0x1
    80002690:	46e080e7          	jalr	1134(ra) # 80003afa <holdingsleep>
    80002694:	cd01                	beqz	a0,800026ac <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002696:	4585                	li	a1,1
    80002698:	8526                	mv	a0,s1
    8000269a:	00003097          	auipc	ra,0x3
    8000269e:	fbe080e7          	jalr	-66(ra) # 80005658 <virtio_disk_rw>
}
    800026a2:	60e2                	ld	ra,24(sp)
    800026a4:	6442                	ld	s0,16(sp)
    800026a6:	64a2                	ld	s1,8(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret
    panic("bwrite");
    800026ac:	00006517          	auipc	a0,0x6
    800026b0:	eb450513          	addi	a0,a0,-332 # 80008560 <syscalls+0x120>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	80e080e7          	jalr	-2034(ra) # 80005ec2 <panic>

00000000800026bc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026bc:	1101                	addi	sp,sp,-32
    800026be:	ec06                	sd	ra,24(sp)
    800026c0:	e822                	sd	s0,16(sp)
    800026c2:	e426                	sd	s1,8(sp)
    800026c4:	e04a                	sd	s2,0(sp)
    800026c6:	1000                	addi	s0,sp,32
    800026c8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026ca:	01050913          	addi	s2,a0,16
    800026ce:	854a                	mv	a0,s2
    800026d0:	00001097          	auipc	ra,0x1
    800026d4:	42a080e7          	jalr	1066(ra) # 80003afa <holdingsleep>
    800026d8:	c92d                	beqz	a0,8000274a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026da:	854a                	mv	a0,s2
    800026dc:	00001097          	auipc	ra,0x1
    800026e0:	3da080e7          	jalr	986(ra) # 80003ab6 <releasesleep>

  acquire(&bcache.lock);
    800026e4:	0000c517          	auipc	a0,0xc
    800026e8:	32450513          	addi	a0,a0,804 # 8000ea08 <bcache>
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	d20080e7          	jalr	-736(ra) # 8000640c <acquire>
  b->refcnt--;
    800026f4:	40bc                	lw	a5,64(s1)
    800026f6:	37fd                	addiw	a5,a5,-1
    800026f8:	0007871b          	sext.w	a4,a5
    800026fc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026fe:	eb05                	bnez	a4,8000272e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002700:	68bc                	ld	a5,80(s1)
    80002702:	64b8                	ld	a4,72(s1)
    80002704:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002706:	64bc                	ld	a5,72(s1)
    80002708:	68b8                	ld	a4,80(s1)
    8000270a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000270c:	00014797          	auipc	a5,0x14
    80002710:	2fc78793          	addi	a5,a5,764 # 80016a08 <bcache+0x8000>
    80002714:	2b87b703          	ld	a4,696(a5)
    80002718:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000271a:	00014717          	auipc	a4,0x14
    8000271e:	55670713          	addi	a4,a4,1366 # 80016c70 <bcache+0x8268>
    80002722:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002724:	2b87b703          	ld	a4,696(a5)
    80002728:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000272a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000272e:	0000c517          	auipc	a0,0xc
    80002732:	2da50513          	addi	a0,a0,730 # 8000ea08 <bcache>
    80002736:	00004097          	auipc	ra,0x4
    8000273a:	d8a080e7          	jalr	-630(ra) # 800064c0 <release>
}
    8000273e:	60e2                	ld	ra,24(sp)
    80002740:	6442                	ld	s0,16(sp)
    80002742:	64a2                	ld	s1,8(sp)
    80002744:	6902                	ld	s2,0(sp)
    80002746:	6105                	addi	sp,sp,32
    80002748:	8082                	ret
    panic("brelse");
    8000274a:	00006517          	auipc	a0,0x6
    8000274e:	e1e50513          	addi	a0,a0,-482 # 80008568 <syscalls+0x128>
    80002752:	00003097          	auipc	ra,0x3
    80002756:	770080e7          	jalr	1904(ra) # 80005ec2 <panic>

000000008000275a <bpin>:

void
bpin(struct buf *b) {
    8000275a:	1101                	addi	sp,sp,-32
    8000275c:	ec06                	sd	ra,24(sp)
    8000275e:	e822                	sd	s0,16(sp)
    80002760:	e426                	sd	s1,8(sp)
    80002762:	1000                	addi	s0,sp,32
    80002764:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002766:	0000c517          	auipc	a0,0xc
    8000276a:	2a250513          	addi	a0,a0,674 # 8000ea08 <bcache>
    8000276e:	00004097          	auipc	ra,0x4
    80002772:	c9e080e7          	jalr	-866(ra) # 8000640c <acquire>
  b->refcnt++;
    80002776:	40bc                	lw	a5,64(s1)
    80002778:	2785                	addiw	a5,a5,1
    8000277a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000277c:	0000c517          	auipc	a0,0xc
    80002780:	28c50513          	addi	a0,a0,652 # 8000ea08 <bcache>
    80002784:	00004097          	auipc	ra,0x4
    80002788:	d3c080e7          	jalr	-708(ra) # 800064c0 <release>
}
    8000278c:	60e2                	ld	ra,24(sp)
    8000278e:	6442                	ld	s0,16(sp)
    80002790:	64a2                	ld	s1,8(sp)
    80002792:	6105                	addi	sp,sp,32
    80002794:	8082                	ret

0000000080002796 <bunpin>:

void
bunpin(struct buf *b) {
    80002796:	1101                	addi	sp,sp,-32
    80002798:	ec06                	sd	ra,24(sp)
    8000279a:	e822                	sd	s0,16(sp)
    8000279c:	e426                	sd	s1,8(sp)
    8000279e:	1000                	addi	s0,sp,32
    800027a0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027a2:	0000c517          	auipc	a0,0xc
    800027a6:	26650513          	addi	a0,a0,614 # 8000ea08 <bcache>
    800027aa:	00004097          	auipc	ra,0x4
    800027ae:	c62080e7          	jalr	-926(ra) # 8000640c <acquire>
  b->refcnt--;
    800027b2:	40bc                	lw	a5,64(s1)
    800027b4:	37fd                	addiw	a5,a5,-1
    800027b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027b8:	0000c517          	auipc	a0,0xc
    800027bc:	25050513          	addi	a0,a0,592 # 8000ea08 <bcache>
    800027c0:	00004097          	auipc	ra,0x4
    800027c4:	d00080e7          	jalr	-768(ra) # 800064c0 <release>
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret

00000000800027d2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027d2:	1101                	addi	sp,sp,-32
    800027d4:	ec06                	sd	ra,24(sp)
    800027d6:	e822                	sd	s0,16(sp)
    800027d8:	e426                	sd	s1,8(sp)
    800027da:	e04a                	sd	s2,0(sp)
    800027dc:	1000                	addi	s0,sp,32
    800027de:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027e0:	00d5d59b          	srliw	a1,a1,0xd
    800027e4:	00015797          	auipc	a5,0x15
    800027e8:	9007a783          	lw	a5,-1792(a5) # 800170e4 <sb+0x1c>
    800027ec:	9dbd                	addw	a1,a1,a5
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	d9e080e7          	jalr	-610(ra) # 8000258c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027f6:	0074f713          	andi	a4,s1,7
    800027fa:	4785                	li	a5,1
    800027fc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002800:	14ce                	slli	s1,s1,0x33
    80002802:	90d9                	srli	s1,s1,0x36
    80002804:	00950733          	add	a4,a0,s1
    80002808:	05874703          	lbu	a4,88(a4)
    8000280c:	00e7f6b3          	and	a3,a5,a4
    80002810:	c69d                	beqz	a3,8000283e <bfree+0x6c>
    80002812:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002814:	94aa                	add	s1,s1,a0
    80002816:	fff7c793          	not	a5,a5
    8000281a:	8ff9                	and	a5,a5,a4
    8000281c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002820:	00001097          	auipc	ra,0x1
    80002824:	120080e7          	jalr	288(ra) # 80003940 <log_write>
  brelse(bp);
    80002828:	854a                	mv	a0,s2
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	e92080e7          	jalr	-366(ra) # 800026bc <brelse>
}
    80002832:	60e2                	ld	ra,24(sp)
    80002834:	6442                	ld	s0,16(sp)
    80002836:	64a2                	ld	s1,8(sp)
    80002838:	6902                	ld	s2,0(sp)
    8000283a:	6105                	addi	sp,sp,32
    8000283c:	8082                	ret
    panic("freeing free block");
    8000283e:	00006517          	auipc	a0,0x6
    80002842:	d3250513          	addi	a0,a0,-718 # 80008570 <syscalls+0x130>
    80002846:	00003097          	auipc	ra,0x3
    8000284a:	67c080e7          	jalr	1660(ra) # 80005ec2 <panic>

000000008000284e <balloc>:
{
    8000284e:	711d                	addi	sp,sp,-96
    80002850:	ec86                	sd	ra,88(sp)
    80002852:	e8a2                	sd	s0,80(sp)
    80002854:	e4a6                	sd	s1,72(sp)
    80002856:	e0ca                	sd	s2,64(sp)
    80002858:	fc4e                	sd	s3,56(sp)
    8000285a:	f852                	sd	s4,48(sp)
    8000285c:	f456                	sd	s5,40(sp)
    8000285e:	f05a                	sd	s6,32(sp)
    80002860:	ec5e                	sd	s7,24(sp)
    80002862:	e862                	sd	s8,16(sp)
    80002864:	e466                	sd	s9,8(sp)
    80002866:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002868:	00015797          	auipc	a5,0x15
    8000286c:	8647a783          	lw	a5,-1948(a5) # 800170cc <sb+0x4>
    80002870:	10078163          	beqz	a5,80002972 <balloc+0x124>
    80002874:	8baa                	mv	s7,a0
    80002876:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002878:	00015b17          	auipc	s6,0x15
    8000287c:	850b0b13          	addi	s6,s6,-1968 # 800170c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002880:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002882:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002884:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002886:	6c89                	lui	s9,0x2
    80002888:	a061                	j	80002910 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000288a:	974a                	add	a4,a4,s2
    8000288c:	8fd5                	or	a5,a5,a3
    8000288e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002892:	854a                	mv	a0,s2
    80002894:	00001097          	auipc	ra,0x1
    80002898:	0ac080e7          	jalr	172(ra) # 80003940 <log_write>
        brelse(bp);
    8000289c:	854a                	mv	a0,s2
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	e1e080e7          	jalr	-482(ra) # 800026bc <brelse>
  bp = bread(dev, bno);
    800028a6:	85a6                	mv	a1,s1
    800028a8:	855e                	mv	a0,s7
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	ce2080e7          	jalr	-798(ra) # 8000258c <bread>
    800028b2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028b4:	40000613          	li	a2,1024
    800028b8:	4581                	li	a1,0
    800028ba:	05850513          	addi	a0,a0,88
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	8ba080e7          	jalr	-1862(ra) # 80000178 <memset>
  log_write(bp);
    800028c6:	854a                	mv	a0,s2
    800028c8:	00001097          	auipc	ra,0x1
    800028cc:	078080e7          	jalr	120(ra) # 80003940 <log_write>
  brelse(bp);
    800028d0:	854a                	mv	a0,s2
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	dea080e7          	jalr	-534(ra) # 800026bc <brelse>
}
    800028da:	8526                	mv	a0,s1
    800028dc:	60e6                	ld	ra,88(sp)
    800028de:	6446                	ld	s0,80(sp)
    800028e0:	64a6                	ld	s1,72(sp)
    800028e2:	6906                	ld	s2,64(sp)
    800028e4:	79e2                	ld	s3,56(sp)
    800028e6:	7a42                	ld	s4,48(sp)
    800028e8:	7aa2                	ld	s5,40(sp)
    800028ea:	7b02                	ld	s6,32(sp)
    800028ec:	6be2                	ld	s7,24(sp)
    800028ee:	6c42                	ld	s8,16(sp)
    800028f0:	6ca2                	ld	s9,8(sp)
    800028f2:	6125                	addi	sp,sp,96
    800028f4:	8082                	ret
    brelse(bp);
    800028f6:	854a                	mv	a0,s2
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	dc4080e7          	jalr	-572(ra) # 800026bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002900:	015c87bb          	addw	a5,s9,s5
    80002904:	00078a9b          	sext.w	s5,a5
    80002908:	004b2703          	lw	a4,4(s6)
    8000290c:	06eaf363          	bgeu	s5,a4,80002972 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002910:	41fad79b          	sraiw	a5,s5,0x1f
    80002914:	0137d79b          	srliw	a5,a5,0x13
    80002918:	015787bb          	addw	a5,a5,s5
    8000291c:	40d7d79b          	sraiw	a5,a5,0xd
    80002920:	01cb2583          	lw	a1,28(s6)
    80002924:	9dbd                	addw	a1,a1,a5
    80002926:	855e                	mv	a0,s7
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	c64080e7          	jalr	-924(ra) # 8000258c <bread>
    80002930:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002932:	004b2503          	lw	a0,4(s6)
    80002936:	000a849b          	sext.w	s1,s5
    8000293a:	8662                	mv	a2,s8
    8000293c:	faa4fde3          	bgeu	s1,a0,800028f6 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002940:	41f6579b          	sraiw	a5,a2,0x1f
    80002944:	01d7d69b          	srliw	a3,a5,0x1d
    80002948:	00c6873b          	addw	a4,a3,a2
    8000294c:	00777793          	andi	a5,a4,7
    80002950:	9f95                	subw	a5,a5,a3
    80002952:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002956:	4037571b          	sraiw	a4,a4,0x3
    8000295a:	00e906b3          	add	a3,s2,a4
    8000295e:	0586c683          	lbu	a3,88(a3)
    80002962:	00d7f5b3          	and	a1,a5,a3
    80002966:	d195                	beqz	a1,8000288a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002968:	2605                	addiw	a2,a2,1
    8000296a:	2485                	addiw	s1,s1,1
    8000296c:	fd4618e3          	bne	a2,s4,8000293c <balloc+0xee>
    80002970:	b759                	j	800028f6 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002972:	00006517          	auipc	a0,0x6
    80002976:	c1650513          	addi	a0,a0,-1002 # 80008588 <syscalls+0x148>
    8000297a:	00003097          	auipc	ra,0x3
    8000297e:	592080e7          	jalr	1426(ra) # 80005f0c <printf>
  return 0;
    80002982:	4481                	li	s1,0
    80002984:	bf99                	j	800028da <balloc+0x8c>

0000000080002986 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002986:	7179                	addi	sp,sp,-48
    80002988:	f406                	sd	ra,40(sp)
    8000298a:	f022                	sd	s0,32(sp)
    8000298c:	ec26                	sd	s1,24(sp)
    8000298e:	e84a                	sd	s2,16(sp)
    80002990:	e44e                	sd	s3,8(sp)
    80002992:	e052                	sd	s4,0(sp)
    80002994:	1800                	addi	s0,sp,48
    80002996:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002998:	47ad                	li	a5,11
    8000299a:	02b7e763          	bltu	a5,a1,800029c8 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000299e:	02059493          	slli	s1,a1,0x20
    800029a2:	9081                	srli	s1,s1,0x20
    800029a4:	048a                	slli	s1,s1,0x2
    800029a6:	94aa                	add	s1,s1,a0
    800029a8:	0504a903          	lw	s2,80(s1)
    800029ac:	06091e63          	bnez	s2,80002a28 <bmap+0xa2>
      addr = balloc(ip->dev);
    800029b0:	4108                	lw	a0,0(a0)
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	e9c080e7          	jalr	-356(ra) # 8000284e <balloc>
    800029ba:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029be:	06090563          	beqz	s2,80002a28 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800029c2:	0524a823          	sw	s2,80(s1)
    800029c6:	a08d                	j	80002a28 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800029c8:	ff45849b          	addiw	s1,a1,-12
    800029cc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029d0:	0ff00793          	li	a5,255
    800029d4:	08e7e563          	bltu	a5,a4,80002a5e <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029d8:	08052903          	lw	s2,128(a0)
    800029dc:	00091d63          	bnez	s2,800029f6 <bmap+0x70>
      addr = balloc(ip->dev);
    800029e0:	4108                	lw	a0,0(a0)
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	e6c080e7          	jalr	-404(ra) # 8000284e <balloc>
    800029ea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029ee:	02090d63          	beqz	s2,80002a28 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029f2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029f6:	85ca                	mv	a1,s2
    800029f8:	0009a503          	lw	a0,0(s3)
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	b90080e7          	jalr	-1136(ra) # 8000258c <bread>
    80002a04:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a06:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a0a:	02049593          	slli	a1,s1,0x20
    80002a0e:	9181                	srli	a1,a1,0x20
    80002a10:	058a                	slli	a1,a1,0x2
    80002a12:	00b784b3          	add	s1,a5,a1
    80002a16:	0004a903          	lw	s2,0(s1)
    80002a1a:	02090063          	beqz	s2,80002a3a <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a1e:	8552                	mv	a0,s4
    80002a20:	00000097          	auipc	ra,0x0
    80002a24:	c9c080e7          	jalr	-868(ra) # 800026bc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a28:	854a                	mv	a0,s2
    80002a2a:	70a2                	ld	ra,40(sp)
    80002a2c:	7402                	ld	s0,32(sp)
    80002a2e:	64e2                	ld	s1,24(sp)
    80002a30:	6942                	ld	s2,16(sp)
    80002a32:	69a2                	ld	s3,8(sp)
    80002a34:	6a02                	ld	s4,0(sp)
    80002a36:	6145                	addi	sp,sp,48
    80002a38:	8082                	ret
      addr = balloc(ip->dev);
    80002a3a:	0009a503          	lw	a0,0(s3)
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	e10080e7          	jalr	-496(ra) # 8000284e <balloc>
    80002a46:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a4a:	fc090ae3          	beqz	s2,80002a1e <bmap+0x98>
        a[bn] = addr;
    80002a4e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a52:	8552                	mv	a0,s4
    80002a54:	00001097          	auipc	ra,0x1
    80002a58:	eec080e7          	jalr	-276(ra) # 80003940 <log_write>
    80002a5c:	b7c9                	j	80002a1e <bmap+0x98>
  panic("bmap: out of range");
    80002a5e:	00006517          	auipc	a0,0x6
    80002a62:	b4250513          	addi	a0,a0,-1214 # 800085a0 <syscalls+0x160>
    80002a66:	00003097          	auipc	ra,0x3
    80002a6a:	45c080e7          	jalr	1116(ra) # 80005ec2 <panic>

0000000080002a6e <iget>:
{
    80002a6e:	7179                	addi	sp,sp,-48
    80002a70:	f406                	sd	ra,40(sp)
    80002a72:	f022                	sd	s0,32(sp)
    80002a74:	ec26                	sd	s1,24(sp)
    80002a76:	e84a                	sd	s2,16(sp)
    80002a78:	e44e                	sd	s3,8(sp)
    80002a7a:	e052                	sd	s4,0(sp)
    80002a7c:	1800                	addi	s0,sp,48
    80002a7e:	89aa                	mv	s3,a0
    80002a80:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a82:	00014517          	auipc	a0,0x14
    80002a86:	66650513          	addi	a0,a0,1638 # 800170e8 <itable>
    80002a8a:	00004097          	auipc	ra,0x4
    80002a8e:	982080e7          	jalr	-1662(ra) # 8000640c <acquire>
  empty = 0;
    80002a92:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a94:	00014497          	auipc	s1,0x14
    80002a98:	66c48493          	addi	s1,s1,1644 # 80017100 <itable+0x18>
    80002a9c:	00016697          	auipc	a3,0x16
    80002aa0:	0f468693          	addi	a3,a3,244 # 80018b90 <log>
    80002aa4:	a039                	j	80002ab2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa6:	02090b63          	beqz	s2,80002adc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002aaa:	08848493          	addi	s1,s1,136
    80002aae:	02d48a63          	beq	s1,a3,80002ae2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ab2:	449c                	lw	a5,8(s1)
    80002ab4:	fef059e3          	blez	a5,80002aa6 <iget+0x38>
    80002ab8:	4098                	lw	a4,0(s1)
    80002aba:	ff3716e3          	bne	a4,s3,80002aa6 <iget+0x38>
    80002abe:	40d8                	lw	a4,4(s1)
    80002ac0:	ff4713e3          	bne	a4,s4,80002aa6 <iget+0x38>
      ip->ref++;
    80002ac4:	2785                	addiw	a5,a5,1
    80002ac6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ac8:	00014517          	auipc	a0,0x14
    80002acc:	62050513          	addi	a0,a0,1568 # 800170e8 <itable>
    80002ad0:	00004097          	auipc	ra,0x4
    80002ad4:	9f0080e7          	jalr	-1552(ra) # 800064c0 <release>
      return ip;
    80002ad8:	8926                	mv	s2,s1
    80002ada:	a03d                	j	80002b08 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002adc:	f7f9                	bnez	a5,80002aaa <iget+0x3c>
    80002ade:	8926                	mv	s2,s1
    80002ae0:	b7e9                	j	80002aaa <iget+0x3c>
  if(empty == 0)
    80002ae2:	02090c63          	beqz	s2,80002b1a <iget+0xac>
  ip->dev = dev;
    80002ae6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aea:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aee:	4785                	li	a5,1
    80002af0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002af4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002af8:	00014517          	auipc	a0,0x14
    80002afc:	5f050513          	addi	a0,a0,1520 # 800170e8 <itable>
    80002b00:	00004097          	auipc	ra,0x4
    80002b04:	9c0080e7          	jalr	-1600(ra) # 800064c0 <release>
}
    80002b08:	854a                	mv	a0,s2
    80002b0a:	70a2                	ld	ra,40(sp)
    80002b0c:	7402                	ld	s0,32(sp)
    80002b0e:	64e2                	ld	s1,24(sp)
    80002b10:	6942                	ld	s2,16(sp)
    80002b12:	69a2                	ld	s3,8(sp)
    80002b14:	6a02                	ld	s4,0(sp)
    80002b16:	6145                	addi	sp,sp,48
    80002b18:	8082                	ret
    panic("iget: no inodes");
    80002b1a:	00006517          	auipc	a0,0x6
    80002b1e:	a9e50513          	addi	a0,a0,-1378 # 800085b8 <syscalls+0x178>
    80002b22:	00003097          	auipc	ra,0x3
    80002b26:	3a0080e7          	jalr	928(ra) # 80005ec2 <panic>

0000000080002b2a <fsinit>:
fsinit(int dev) {
    80002b2a:	7179                	addi	sp,sp,-48
    80002b2c:	f406                	sd	ra,40(sp)
    80002b2e:	f022                	sd	s0,32(sp)
    80002b30:	ec26                	sd	s1,24(sp)
    80002b32:	e84a                	sd	s2,16(sp)
    80002b34:	e44e                	sd	s3,8(sp)
    80002b36:	1800                	addi	s0,sp,48
    80002b38:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b3a:	4585                	li	a1,1
    80002b3c:	00000097          	auipc	ra,0x0
    80002b40:	a50080e7          	jalr	-1456(ra) # 8000258c <bread>
    80002b44:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b46:	00014997          	auipc	s3,0x14
    80002b4a:	58298993          	addi	s3,s3,1410 # 800170c8 <sb>
    80002b4e:	02000613          	li	a2,32
    80002b52:	05850593          	addi	a1,a0,88
    80002b56:	854e                	mv	a0,s3
    80002b58:	ffffd097          	auipc	ra,0xffffd
    80002b5c:	680080e7          	jalr	1664(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b60:	8526                	mv	a0,s1
    80002b62:	00000097          	auipc	ra,0x0
    80002b66:	b5a080e7          	jalr	-1190(ra) # 800026bc <brelse>
  if(sb.magic != FSMAGIC)
    80002b6a:	0009a703          	lw	a4,0(s3)
    80002b6e:	102037b7          	lui	a5,0x10203
    80002b72:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b76:	02f71263          	bne	a4,a5,80002b9a <fsinit+0x70>
  initlog(dev, &sb);
    80002b7a:	00014597          	auipc	a1,0x14
    80002b7e:	54e58593          	addi	a1,a1,1358 # 800170c8 <sb>
    80002b82:	854a                	mv	a0,s2
    80002b84:	00001097          	auipc	ra,0x1
    80002b88:	b40080e7          	jalr	-1216(ra) # 800036c4 <initlog>
}
    80002b8c:	70a2                	ld	ra,40(sp)
    80002b8e:	7402                	ld	s0,32(sp)
    80002b90:	64e2                	ld	s1,24(sp)
    80002b92:	6942                	ld	s2,16(sp)
    80002b94:	69a2                	ld	s3,8(sp)
    80002b96:	6145                	addi	sp,sp,48
    80002b98:	8082                	ret
    panic("invalid file system");
    80002b9a:	00006517          	auipc	a0,0x6
    80002b9e:	a2e50513          	addi	a0,a0,-1490 # 800085c8 <syscalls+0x188>
    80002ba2:	00003097          	auipc	ra,0x3
    80002ba6:	320080e7          	jalr	800(ra) # 80005ec2 <panic>

0000000080002baa <iinit>:
{
    80002baa:	7179                	addi	sp,sp,-48
    80002bac:	f406                	sd	ra,40(sp)
    80002bae:	f022                	sd	s0,32(sp)
    80002bb0:	ec26                	sd	s1,24(sp)
    80002bb2:	e84a                	sd	s2,16(sp)
    80002bb4:	e44e                	sd	s3,8(sp)
    80002bb6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bb8:	00006597          	auipc	a1,0x6
    80002bbc:	a2858593          	addi	a1,a1,-1496 # 800085e0 <syscalls+0x1a0>
    80002bc0:	00014517          	auipc	a0,0x14
    80002bc4:	52850513          	addi	a0,a0,1320 # 800170e8 <itable>
    80002bc8:	00003097          	auipc	ra,0x3
    80002bcc:	7b4080e7          	jalr	1972(ra) # 8000637c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bd0:	00014497          	auipc	s1,0x14
    80002bd4:	54048493          	addi	s1,s1,1344 # 80017110 <itable+0x28>
    80002bd8:	00016997          	auipc	s3,0x16
    80002bdc:	fc898993          	addi	s3,s3,-56 # 80018ba0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002be0:	00006917          	auipc	s2,0x6
    80002be4:	a0890913          	addi	s2,s2,-1528 # 800085e8 <syscalls+0x1a8>
    80002be8:	85ca                	mv	a1,s2
    80002bea:	8526                	mv	a0,s1
    80002bec:	00001097          	auipc	ra,0x1
    80002bf0:	e3a080e7          	jalr	-454(ra) # 80003a26 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bf4:	08848493          	addi	s1,s1,136
    80002bf8:	ff3498e3          	bne	s1,s3,80002be8 <iinit+0x3e>
}
    80002bfc:	70a2                	ld	ra,40(sp)
    80002bfe:	7402                	ld	s0,32(sp)
    80002c00:	64e2                	ld	s1,24(sp)
    80002c02:	6942                	ld	s2,16(sp)
    80002c04:	69a2                	ld	s3,8(sp)
    80002c06:	6145                	addi	sp,sp,48
    80002c08:	8082                	ret

0000000080002c0a <ialloc>:
{
    80002c0a:	715d                	addi	sp,sp,-80
    80002c0c:	e486                	sd	ra,72(sp)
    80002c0e:	e0a2                	sd	s0,64(sp)
    80002c10:	fc26                	sd	s1,56(sp)
    80002c12:	f84a                	sd	s2,48(sp)
    80002c14:	f44e                	sd	s3,40(sp)
    80002c16:	f052                	sd	s4,32(sp)
    80002c18:	ec56                	sd	s5,24(sp)
    80002c1a:	e85a                	sd	s6,16(sp)
    80002c1c:	e45e                	sd	s7,8(sp)
    80002c1e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c20:	00014717          	auipc	a4,0x14
    80002c24:	4b472703          	lw	a4,1204(a4) # 800170d4 <sb+0xc>
    80002c28:	4785                	li	a5,1
    80002c2a:	04e7fa63          	bgeu	a5,a4,80002c7e <ialloc+0x74>
    80002c2e:	8aaa                	mv	s5,a0
    80002c30:	8bae                	mv	s7,a1
    80002c32:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c34:	00014a17          	auipc	s4,0x14
    80002c38:	494a0a13          	addi	s4,s4,1172 # 800170c8 <sb>
    80002c3c:	00048b1b          	sext.w	s6,s1
    80002c40:	0044d593          	srli	a1,s1,0x4
    80002c44:	018a2783          	lw	a5,24(s4)
    80002c48:	9dbd                	addw	a1,a1,a5
    80002c4a:	8556                	mv	a0,s5
    80002c4c:	00000097          	auipc	ra,0x0
    80002c50:	940080e7          	jalr	-1728(ra) # 8000258c <bread>
    80002c54:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c56:	05850993          	addi	s3,a0,88
    80002c5a:	00f4f793          	andi	a5,s1,15
    80002c5e:	079a                	slli	a5,a5,0x6
    80002c60:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c62:	00099783          	lh	a5,0(s3)
    80002c66:	c3a1                	beqz	a5,80002ca6 <ialloc+0x9c>
    brelse(bp);
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	a54080e7          	jalr	-1452(ra) # 800026bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c70:	0485                	addi	s1,s1,1
    80002c72:	00ca2703          	lw	a4,12(s4)
    80002c76:	0004879b          	sext.w	a5,s1
    80002c7a:	fce7e1e3          	bltu	a5,a4,80002c3c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c7e:	00006517          	auipc	a0,0x6
    80002c82:	97250513          	addi	a0,a0,-1678 # 800085f0 <syscalls+0x1b0>
    80002c86:	00003097          	auipc	ra,0x3
    80002c8a:	286080e7          	jalr	646(ra) # 80005f0c <printf>
  return 0;
    80002c8e:	4501                	li	a0,0
}
    80002c90:	60a6                	ld	ra,72(sp)
    80002c92:	6406                	ld	s0,64(sp)
    80002c94:	74e2                	ld	s1,56(sp)
    80002c96:	7942                	ld	s2,48(sp)
    80002c98:	79a2                	ld	s3,40(sp)
    80002c9a:	7a02                	ld	s4,32(sp)
    80002c9c:	6ae2                	ld	s5,24(sp)
    80002c9e:	6b42                	ld	s6,16(sp)
    80002ca0:	6ba2                	ld	s7,8(sp)
    80002ca2:	6161                	addi	sp,sp,80
    80002ca4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ca6:	04000613          	li	a2,64
    80002caa:	4581                	li	a1,0
    80002cac:	854e                	mv	a0,s3
    80002cae:	ffffd097          	auipc	ra,0xffffd
    80002cb2:	4ca080e7          	jalr	1226(ra) # 80000178 <memset>
      dip->type = type;
    80002cb6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	c84080e7          	jalr	-892(ra) # 80003940 <log_write>
      brelse(bp);
    80002cc4:	854a                	mv	a0,s2
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	9f6080e7          	jalr	-1546(ra) # 800026bc <brelse>
      return iget(dev, inum);
    80002cce:	85da                	mv	a1,s6
    80002cd0:	8556                	mv	a0,s5
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	d9c080e7          	jalr	-612(ra) # 80002a6e <iget>
    80002cda:	bf5d                	j	80002c90 <ialloc+0x86>

0000000080002cdc <iupdate>:
{
    80002cdc:	1101                	addi	sp,sp,-32
    80002cde:	ec06                	sd	ra,24(sp)
    80002ce0:	e822                	sd	s0,16(sp)
    80002ce2:	e426                	sd	s1,8(sp)
    80002ce4:	e04a                	sd	s2,0(sp)
    80002ce6:	1000                	addi	s0,sp,32
    80002ce8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cea:	415c                	lw	a5,4(a0)
    80002cec:	0047d79b          	srliw	a5,a5,0x4
    80002cf0:	00014597          	auipc	a1,0x14
    80002cf4:	3f05a583          	lw	a1,1008(a1) # 800170e0 <sb+0x18>
    80002cf8:	9dbd                	addw	a1,a1,a5
    80002cfa:	4108                	lw	a0,0(a0)
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	890080e7          	jalr	-1904(ra) # 8000258c <bread>
    80002d04:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d06:	05850793          	addi	a5,a0,88
    80002d0a:	40c8                	lw	a0,4(s1)
    80002d0c:	893d                	andi	a0,a0,15
    80002d0e:	051a                	slli	a0,a0,0x6
    80002d10:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d12:	04449703          	lh	a4,68(s1)
    80002d16:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d1a:	04649703          	lh	a4,70(s1)
    80002d1e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d22:	04849703          	lh	a4,72(s1)
    80002d26:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d2a:	04a49703          	lh	a4,74(s1)
    80002d2e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d32:	44f8                	lw	a4,76(s1)
    80002d34:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d36:	03400613          	li	a2,52
    80002d3a:	05048593          	addi	a1,s1,80
    80002d3e:	0531                	addi	a0,a0,12
    80002d40:	ffffd097          	auipc	ra,0xffffd
    80002d44:	498080e7          	jalr	1176(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d48:	854a                	mv	a0,s2
    80002d4a:	00001097          	auipc	ra,0x1
    80002d4e:	bf6080e7          	jalr	-1034(ra) # 80003940 <log_write>
  brelse(bp);
    80002d52:	854a                	mv	a0,s2
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	968080e7          	jalr	-1688(ra) # 800026bc <brelse>
}
    80002d5c:	60e2                	ld	ra,24(sp)
    80002d5e:	6442                	ld	s0,16(sp)
    80002d60:	64a2                	ld	s1,8(sp)
    80002d62:	6902                	ld	s2,0(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret

0000000080002d68 <idup>:
{
    80002d68:	1101                	addi	sp,sp,-32
    80002d6a:	ec06                	sd	ra,24(sp)
    80002d6c:	e822                	sd	s0,16(sp)
    80002d6e:	e426                	sd	s1,8(sp)
    80002d70:	1000                	addi	s0,sp,32
    80002d72:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d74:	00014517          	auipc	a0,0x14
    80002d78:	37450513          	addi	a0,a0,884 # 800170e8 <itable>
    80002d7c:	00003097          	auipc	ra,0x3
    80002d80:	690080e7          	jalr	1680(ra) # 8000640c <acquire>
  ip->ref++;
    80002d84:	449c                	lw	a5,8(s1)
    80002d86:	2785                	addiw	a5,a5,1
    80002d88:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d8a:	00014517          	auipc	a0,0x14
    80002d8e:	35e50513          	addi	a0,a0,862 # 800170e8 <itable>
    80002d92:	00003097          	auipc	ra,0x3
    80002d96:	72e080e7          	jalr	1838(ra) # 800064c0 <release>
}
    80002d9a:	8526                	mv	a0,s1
    80002d9c:	60e2                	ld	ra,24(sp)
    80002d9e:	6442                	ld	s0,16(sp)
    80002da0:	64a2                	ld	s1,8(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret

0000000080002da6 <ilock>:
{
    80002da6:	1101                	addi	sp,sp,-32
    80002da8:	ec06                	sd	ra,24(sp)
    80002daa:	e822                	sd	s0,16(sp)
    80002dac:	e426                	sd	s1,8(sp)
    80002dae:	e04a                	sd	s2,0(sp)
    80002db0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002db2:	c115                	beqz	a0,80002dd6 <ilock+0x30>
    80002db4:	84aa                	mv	s1,a0
    80002db6:	451c                	lw	a5,8(a0)
    80002db8:	00f05f63          	blez	a5,80002dd6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002dbc:	0541                	addi	a0,a0,16
    80002dbe:	00001097          	auipc	ra,0x1
    80002dc2:	ca2080e7          	jalr	-862(ra) # 80003a60 <acquiresleep>
  if(ip->valid == 0){
    80002dc6:	40bc                	lw	a5,64(s1)
    80002dc8:	cf99                	beqz	a5,80002de6 <ilock+0x40>
}
    80002dca:	60e2                	ld	ra,24(sp)
    80002dcc:	6442                	ld	s0,16(sp)
    80002dce:	64a2                	ld	s1,8(sp)
    80002dd0:	6902                	ld	s2,0(sp)
    80002dd2:	6105                	addi	sp,sp,32
    80002dd4:	8082                	ret
    panic("ilock");
    80002dd6:	00006517          	auipc	a0,0x6
    80002dda:	83250513          	addi	a0,a0,-1998 # 80008608 <syscalls+0x1c8>
    80002dde:	00003097          	auipc	ra,0x3
    80002de2:	0e4080e7          	jalr	228(ra) # 80005ec2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002de6:	40dc                	lw	a5,4(s1)
    80002de8:	0047d79b          	srliw	a5,a5,0x4
    80002dec:	00014597          	auipc	a1,0x14
    80002df0:	2f45a583          	lw	a1,756(a1) # 800170e0 <sb+0x18>
    80002df4:	9dbd                	addw	a1,a1,a5
    80002df6:	4088                	lw	a0,0(s1)
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	794080e7          	jalr	1940(ra) # 8000258c <bread>
    80002e00:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e02:	05850593          	addi	a1,a0,88
    80002e06:	40dc                	lw	a5,4(s1)
    80002e08:	8bbd                	andi	a5,a5,15
    80002e0a:	079a                	slli	a5,a5,0x6
    80002e0c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e0e:	00059783          	lh	a5,0(a1)
    80002e12:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e16:	00259783          	lh	a5,2(a1)
    80002e1a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e1e:	00459783          	lh	a5,4(a1)
    80002e22:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e26:	00659783          	lh	a5,6(a1)
    80002e2a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e2e:	459c                	lw	a5,8(a1)
    80002e30:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e32:	03400613          	li	a2,52
    80002e36:	05b1                	addi	a1,a1,12
    80002e38:	05048513          	addi	a0,s1,80
    80002e3c:	ffffd097          	auipc	ra,0xffffd
    80002e40:	39c080e7          	jalr	924(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e44:	854a                	mv	a0,s2
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	876080e7          	jalr	-1930(ra) # 800026bc <brelse>
    ip->valid = 1;
    80002e4e:	4785                	li	a5,1
    80002e50:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e52:	04449783          	lh	a5,68(s1)
    80002e56:	fbb5                	bnez	a5,80002dca <ilock+0x24>
      panic("ilock: no type");
    80002e58:	00005517          	auipc	a0,0x5
    80002e5c:	7b850513          	addi	a0,a0,1976 # 80008610 <syscalls+0x1d0>
    80002e60:	00003097          	auipc	ra,0x3
    80002e64:	062080e7          	jalr	98(ra) # 80005ec2 <panic>

0000000080002e68 <iunlock>:
{
    80002e68:	1101                	addi	sp,sp,-32
    80002e6a:	ec06                	sd	ra,24(sp)
    80002e6c:	e822                	sd	s0,16(sp)
    80002e6e:	e426                	sd	s1,8(sp)
    80002e70:	e04a                	sd	s2,0(sp)
    80002e72:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e74:	c905                	beqz	a0,80002ea4 <iunlock+0x3c>
    80002e76:	84aa                	mv	s1,a0
    80002e78:	01050913          	addi	s2,a0,16
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00001097          	auipc	ra,0x1
    80002e82:	c7c080e7          	jalr	-900(ra) # 80003afa <holdingsleep>
    80002e86:	cd19                	beqz	a0,80002ea4 <iunlock+0x3c>
    80002e88:	449c                	lw	a5,8(s1)
    80002e8a:	00f05d63          	blez	a5,80002ea4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e8e:	854a                	mv	a0,s2
    80002e90:	00001097          	auipc	ra,0x1
    80002e94:	c26080e7          	jalr	-986(ra) # 80003ab6 <releasesleep>
}
    80002e98:	60e2                	ld	ra,24(sp)
    80002e9a:	6442                	ld	s0,16(sp)
    80002e9c:	64a2                	ld	s1,8(sp)
    80002e9e:	6902                	ld	s2,0(sp)
    80002ea0:	6105                	addi	sp,sp,32
    80002ea2:	8082                	ret
    panic("iunlock");
    80002ea4:	00005517          	auipc	a0,0x5
    80002ea8:	77c50513          	addi	a0,a0,1916 # 80008620 <syscalls+0x1e0>
    80002eac:	00003097          	auipc	ra,0x3
    80002eb0:	016080e7          	jalr	22(ra) # 80005ec2 <panic>

0000000080002eb4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eb4:	7179                	addi	sp,sp,-48
    80002eb6:	f406                	sd	ra,40(sp)
    80002eb8:	f022                	sd	s0,32(sp)
    80002eba:	ec26                	sd	s1,24(sp)
    80002ebc:	e84a                	sd	s2,16(sp)
    80002ebe:	e44e                	sd	s3,8(sp)
    80002ec0:	e052                	sd	s4,0(sp)
    80002ec2:	1800                	addi	s0,sp,48
    80002ec4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ec6:	05050493          	addi	s1,a0,80
    80002eca:	08050913          	addi	s2,a0,128
    80002ece:	a021                	j	80002ed6 <itrunc+0x22>
    80002ed0:	0491                	addi	s1,s1,4
    80002ed2:	01248d63          	beq	s1,s2,80002eec <itrunc+0x38>
    if(ip->addrs[i]){
    80002ed6:	408c                	lw	a1,0(s1)
    80002ed8:	dde5                	beqz	a1,80002ed0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002eda:	0009a503          	lw	a0,0(s3)
    80002ede:	00000097          	auipc	ra,0x0
    80002ee2:	8f4080e7          	jalr	-1804(ra) # 800027d2 <bfree>
      ip->addrs[i] = 0;
    80002ee6:	0004a023          	sw	zero,0(s1)
    80002eea:	b7dd                	j	80002ed0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eec:	0809a583          	lw	a1,128(s3)
    80002ef0:	e185                	bnez	a1,80002f10 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ef2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ef6:	854e                	mv	a0,s3
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	de4080e7          	jalr	-540(ra) # 80002cdc <iupdate>
}
    80002f00:	70a2                	ld	ra,40(sp)
    80002f02:	7402                	ld	s0,32(sp)
    80002f04:	64e2                	ld	s1,24(sp)
    80002f06:	6942                	ld	s2,16(sp)
    80002f08:	69a2                	ld	s3,8(sp)
    80002f0a:	6a02                	ld	s4,0(sp)
    80002f0c:	6145                	addi	sp,sp,48
    80002f0e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f10:	0009a503          	lw	a0,0(s3)
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	678080e7          	jalr	1656(ra) # 8000258c <bread>
    80002f1c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f1e:	05850493          	addi	s1,a0,88
    80002f22:	45850913          	addi	s2,a0,1112
    80002f26:	a811                	j	80002f3a <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f28:	0009a503          	lw	a0,0(s3)
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	8a6080e7          	jalr	-1882(ra) # 800027d2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f34:	0491                	addi	s1,s1,4
    80002f36:	01248563          	beq	s1,s2,80002f40 <itrunc+0x8c>
      if(a[j])
    80002f3a:	408c                	lw	a1,0(s1)
    80002f3c:	dde5                	beqz	a1,80002f34 <itrunc+0x80>
    80002f3e:	b7ed                	j	80002f28 <itrunc+0x74>
    brelse(bp);
    80002f40:	8552                	mv	a0,s4
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	77a080e7          	jalr	1914(ra) # 800026bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f4a:	0809a583          	lw	a1,128(s3)
    80002f4e:	0009a503          	lw	a0,0(s3)
    80002f52:	00000097          	auipc	ra,0x0
    80002f56:	880080e7          	jalr	-1920(ra) # 800027d2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f5a:	0809a023          	sw	zero,128(s3)
    80002f5e:	bf51                	j	80002ef2 <itrunc+0x3e>

0000000080002f60 <iput>:
{
    80002f60:	1101                	addi	sp,sp,-32
    80002f62:	ec06                	sd	ra,24(sp)
    80002f64:	e822                	sd	s0,16(sp)
    80002f66:	e426                	sd	s1,8(sp)
    80002f68:	e04a                	sd	s2,0(sp)
    80002f6a:	1000                	addi	s0,sp,32
    80002f6c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f6e:	00014517          	auipc	a0,0x14
    80002f72:	17a50513          	addi	a0,a0,378 # 800170e8 <itable>
    80002f76:	00003097          	auipc	ra,0x3
    80002f7a:	496080e7          	jalr	1174(ra) # 8000640c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f7e:	4498                	lw	a4,8(s1)
    80002f80:	4785                	li	a5,1
    80002f82:	02f70363          	beq	a4,a5,80002fa8 <iput+0x48>
  ip->ref--;
    80002f86:	449c                	lw	a5,8(s1)
    80002f88:	37fd                	addiw	a5,a5,-1
    80002f8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f8c:	00014517          	auipc	a0,0x14
    80002f90:	15c50513          	addi	a0,a0,348 # 800170e8 <itable>
    80002f94:	00003097          	auipc	ra,0x3
    80002f98:	52c080e7          	jalr	1324(ra) # 800064c0 <release>
}
    80002f9c:	60e2                	ld	ra,24(sp)
    80002f9e:	6442                	ld	s0,16(sp)
    80002fa0:	64a2                	ld	s1,8(sp)
    80002fa2:	6902                	ld	s2,0(sp)
    80002fa4:	6105                	addi	sp,sp,32
    80002fa6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa8:	40bc                	lw	a5,64(s1)
    80002faa:	dff1                	beqz	a5,80002f86 <iput+0x26>
    80002fac:	04a49783          	lh	a5,74(s1)
    80002fb0:	fbf9                	bnez	a5,80002f86 <iput+0x26>
    acquiresleep(&ip->lock);
    80002fb2:	01048913          	addi	s2,s1,16
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	00001097          	auipc	ra,0x1
    80002fbc:	aa8080e7          	jalr	-1368(ra) # 80003a60 <acquiresleep>
    release(&itable.lock);
    80002fc0:	00014517          	auipc	a0,0x14
    80002fc4:	12850513          	addi	a0,a0,296 # 800170e8 <itable>
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	4f8080e7          	jalr	1272(ra) # 800064c0 <release>
    itrunc(ip);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	ee2080e7          	jalr	-286(ra) # 80002eb4 <itrunc>
    ip->type = 0;
    80002fda:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fde:	8526                	mv	a0,s1
    80002fe0:	00000097          	auipc	ra,0x0
    80002fe4:	cfc080e7          	jalr	-772(ra) # 80002cdc <iupdate>
    ip->valid = 0;
    80002fe8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fec:	854a                	mv	a0,s2
    80002fee:	00001097          	auipc	ra,0x1
    80002ff2:	ac8080e7          	jalr	-1336(ra) # 80003ab6 <releasesleep>
    acquire(&itable.lock);
    80002ff6:	00014517          	auipc	a0,0x14
    80002ffa:	0f250513          	addi	a0,a0,242 # 800170e8 <itable>
    80002ffe:	00003097          	auipc	ra,0x3
    80003002:	40e080e7          	jalr	1038(ra) # 8000640c <acquire>
    80003006:	b741                	j	80002f86 <iput+0x26>

0000000080003008 <iunlockput>:
{
    80003008:	1101                	addi	sp,sp,-32
    8000300a:	ec06                	sd	ra,24(sp)
    8000300c:	e822                	sd	s0,16(sp)
    8000300e:	e426                	sd	s1,8(sp)
    80003010:	1000                	addi	s0,sp,32
    80003012:	84aa                	mv	s1,a0
  iunlock(ip);
    80003014:	00000097          	auipc	ra,0x0
    80003018:	e54080e7          	jalr	-428(ra) # 80002e68 <iunlock>
  iput(ip);
    8000301c:	8526                	mv	a0,s1
    8000301e:	00000097          	auipc	ra,0x0
    80003022:	f42080e7          	jalr	-190(ra) # 80002f60 <iput>
}
    80003026:	60e2                	ld	ra,24(sp)
    80003028:	6442                	ld	s0,16(sp)
    8000302a:	64a2                	ld	s1,8(sp)
    8000302c:	6105                	addi	sp,sp,32
    8000302e:	8082                	ret

0000000080003030 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003030:	1141                	addi	sp,sp,-16
    80003032:	e422                	sd	s0,8(sp)
    80003034:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003036:	411c                	lw	a5,0(a0)
    80003038:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000303a:	415c                	lw	a5,4(a0)
    8000303c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000303e:	04451783          	lh	a5,68(a0)
    80003042:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003046:	04a51783          	lh	a5,74(a0)
    8000304a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000304e:	04c56783          	lwu	a5,76(a0)
    80003052:	e99c                	sd	a5,16(a1)
}
    80003054:	6422                	ld	s0,8(sp)
    80003056:	0141                	addi	sp,sp,16
    80003058:	8082                	ret

000000008000305a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000305a:	457c                	lw	a5,76(a0)
    8000305c:	0ed7e963          	bltu	a5,a3,8000314e <readi+0xf4>
{
    80003060:	7159                	addi	sp,sp,-112
    80003062:	f486                	sd	ra,104(sp)
    80003064:	f0a2                	sd	s0,96(sp)
    80003066:	eca6                	sd	s1,88(sp)
    80003068:	e8ca                	sd	s2,80(sp)
    8000306a:	e4ce                	sd	s3,72(sp)
    8000306c:	e0d2                	sd	s4,64(sp)
    8000306e:	fc56                	sd	s5,56(sp)
    80003070:	f85a                	sd	s6,48(sp)
    80003072:	f45e                	sd	s7,40(sp)
    80003074:	f062                	sd	s8,32(sp)
    80003076:	ec66                	sd	s9,24(sp)
    80003078:	e86a                	sd	s10,16(sp)
    8000307a:	e46e                	sd	s11,8(sp)
    8000307c:	1880                	addi	s0,sp,112
    8000307e:	8b2a                	mv	s6,a0
    80003080:	8bae                	mv	s7,a1
    80003082:	8a32                	mv	s4,a2
    80003084:	84b6                	mv	s1,a3
    80003086:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003088:	9f35                	addw	a4,a4,a3
    return 0;
    8000308a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000308c:	0ad76063          	bltu	a4,a3,8000312c <readi+0xd2>
  if(off + n > ip->size)
    80003090:	00e7f463          	bgeu	a5,a4,80003098 <readi+0x3e>
    n = ip->size - off;
    80003094:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003098:	0a0a8963          	beqz	s5,8000314a <readi+0xf0>
    8000309c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030a2:	5c7d                	li	s8,-1
    800030a4:	a82d                	j	800030de <readi+0x84>
    800030a6:	020d1d93          	slli	s11,s10,0x20
    800030aa:	020ddd93          	srli	s11,s11,0x20
    800030ae:	05890613          	addi	a2,s2,88
    800030b2:	86ee                	mv	a3,s11
    800030b4:	963a                	add	a2,a2,a4
    800030b6:	85d2                	mv	a1,s4
    800030b8:	855e                	mv	a0,s7
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	a50080e7          	jalr	-1456(ra) # 80001b0a <either_copyout>
    800030c2:	05850d63          	beq	a0,s8,8000311c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030c6:	854a                	mv	a0,s2
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	5f4080e7          	jalr	1524(ra) # 800026bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d0:	013d09bb          	addw	s3,s10,s3
    800030d4:	009d04bb          	addw	s1,s10,s1
    800030d8:	9a6e                	add	s4,s4,s11
    800030da:	0559f763          	bgeu	s3,s5,80003128 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030de:	00a4d59b          	srliw	a1,s1,0xa
    800030e2:	855a                	mv	a0,s6
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	8a2080e7          	jalr	-1886(ra) # 80002986 <bmap>
    800030ec:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030f0:	cd85                	beqz	a1,80003128 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030f2:	000b2503          	lw	a0,0(s6)
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	496080e7          	jalr	1174(ra) # 8000258c <bread>
    800030fe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003100:	3ff4f713          	andi	a4,s1,1023
    80003104:	40ec87bb          	subw	a5,s9,a4
    80003108:	413a86bb          	subw	a3,s5,s3
    8000310c:	8d3e                	mv	s10,a5
    8000310e:	2781                	sext.w	a5,a5
    80003110:	0006861b          	sext.w	a2,a3
    80003114:	f8f679e3          	bgeu	a2,a5,800030a6 <readi+0x4c>
    80003118:	8d36                	mv	s10,a3
    8000311a:	b771                	j	800030a6 <readi+0x4c>
      brelse(bp);
    8000311c:	854a                	mv	a0,s2
    8000311e:	fffff097          	auipc	ra,0xfffff
    80003122:	59e080e7          	jalr	1438(ra) # 800026bc <brelse>
      tot = -1;
    80003126:	59fd                	li	s3,-1
  }
  return tot;
    80003128:	0009851b          	sext.w	a0,s3
}
    8000312c:	70a6                	ld	ra,104(sp)
    8000312e:	7406                	ld	s0,96(sp)
    80003130:	64e6                	ld	s1,88(sp)
    80003132:	6946                	ld	s2,80(sp)
    80003134:	69a6                	ld	s3,72(sp)
    80003136:	6a06                	ld	s4,64(sp)
    80003138:	7ae2                	ld	s5,56(sp)
    8000313a:	7b42                	ld	s6,48(sp)
    8000313c:	7ba2                	ld	s7,40(sp)
    8000313e:	7c02                	ld	s8,32(sp)
    80003140:	6ce2                	ld	s9,24(sp)
    80003142:	6d42                	ld	s10,16(sp)
    80003144:	6da2                	ld	s11,8(sp)
    80003146:	6165                	addi	sp,sp,112
    80003148:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000314a:	89d6                	mv	s3,s5
    8000314c:	bff1                	j	80003128 <readi+0xce>
    return 0;
    8000314e:	4501                	li	a0,0
}
    80003150:	8082                	ret

0000000080003152 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003152:	457c                	lw	a5,76(a0)
    80003154:	10d7e863          	bltu	a5,a3,80003264 <writei+0x112>
{
    80003158:	7159                	addi	sp,sp,-112
    8000315a:	f486                	sd	ra,104(sp)
    8000315c:	f0a2                	sd	s0,96(sp)
    8000315e:	eca6                	sd	s1,88(sp)
    80003160:	e8ca                	sd	s2,80(sp)
    80003162:	e4ce                	sd	s3,72(sp)
    80003164:	e0d2                	sd	s4,64(sp)
    80003166:	fc56                	sd	s5,56(sp)
    80003168:	f85a                	sd	s6,48(sp)
    8000316a:	f45e                	sd	s7,40(sp)
    8000316c:	f062                	sd	s8,32(sp)
    8000316e:	ec66                	sd	s9,24(sp)
    80003170:	e86a                	sd	s10,16(sp)
    80003172:	e46e                	sd	s11,8(sp)
    80003174:	1880                	addi	s0,sp,112
    80003176:	8aaa                	mv	s5,a0
    80003178:	8bae                	mv	s7,a1
    8000317a:	8a32                	mv	s4,a2
    8000317c:	8936                	mv	s2,a3
    8000317e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003180:	00e687bb          	addw	a5,a3,a4
    80003184:	0ed7e263          	bltu	a5,a3,80003268 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003188:	00043737          	lui	a4,0x43
    8000318c:	0ef76063          	bltu	a4,a5,8000326c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003190:	0c0b0863          	beqz	s6,80003260 <writei+0x10e>
    80003194:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003196:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000319a:	5c7d                	li	s8,-1
    8000319c:	a091                	j	800031e0 <writei+0x8e>
    8000319e:	020d1d93          	slli	s11,s10,0x20
    800031a2:	020ddd93          	srli	s11,s11,0x20
    800031a6:	05848513          	addi	a0,s1,88
    800031aa:	86ee                	mv	a3,s11
    800031ac:	8652                	mv	a2,s4
    800031ae:	85de                	mv	a1,s7
    800031b0:	953a                	add	a0,a0,a4
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	9ae080e7          	jalr	-1618(ra) # 80001b60 <either_copyin>
    800031ba:	07850263          	beq	a0,s8,8000321e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031be:	8526                	mv	a0,s1
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	780080e7          	jalr	1920(ra) # 80003940 <log_write>
    brelse(bp);
    800031c8:	8526                	mv	a0,s1
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	4f2080e7          	jalr	1266(ra) # 800026bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d2:	013d09bb          	addw	s3,s10,s3
    800031d6:	012d093b          	addw	s2,s10,s2
    800031da:	9a6e                	add	s4,s4,s11
    800031dc:	0569f663          	bgeu	s3,s6,80003228 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031e0:	00a9559b          	srliw	a1,s2,0xa
    800031e4:	8556                	mv	a0,s5
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	7a0080e7          	jalr	1952(ra) # 80002986 <bmap>
    800031ee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031f2:	c99d                	beqz	a1,80003228 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031f4:	000aa503          	lw	a0,0(s5)
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	394080e7          	jalr	916(ra) # 8000258c <bread>
    80003200:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003202:	3ff97713          	andi	a4,s2,1023
    80003206:	40ec87bb          	subw	a5,s9,a4
    8000320a:	413b06bb          	subw	a3,s6,s3
    8000320e:	8d3e                	mv	s10,a5
    80003210:	2781                	sext.w	a5,a5
    80003212:	0006861b          	sext.w	a2,a3
    80003216:	f8f674e3          	bgeu	a2,a5,8000319e <writei+0x4c>
    8000321a:	8d36                	mv	s10,a3
    8000321c:	b749                	j	8000319e <writei+0x4c>
      brelse(bp);
    8000321e:	8526                	mv	a0,s1
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	49c080e7          	jalr	1180(ra) # 800026bc <brelse>
  }

  if(off > ip->size)
    80003228:	04caa783          	lw	a5,76(s5)
    8000322c:	0127f463          	bgeu	a5,s2,80003234 <writei+0xe2>
    ip->size = off;
    80003230:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003234:	8556                	mv	a0,s5
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	aa6080e7          	jalr	-1370(ra) # 80002cdc <iupdate>

  return tot;
    8000323e:	0009851b          	sext.w	a0,s3
}
    80003242:	70a6                	ld	ra,104(sp)
    80003244:	7406                	ld	s0,96(sp)
    80003246:	64e6                	ld	s1,88(sp)
    80003248:	6946                	ld	s2,80(sp)
    8000324a:	69a6                	ld	s3,72(sp)
    8000324c:	6a06                	ld	s4,64(sp)
    8000324e:	7ae2                	ld	s5,56(sp)
    80003250:	7b42                	ld	s6,48(sp)
    80003252:	7ba2                	ld	s7,40(sp)
    80003254:	7c02                	ld	s8,32(sp)
    80003256:	6ce2                	ld	s9,24(sp)
    80003258:	6d42                	ld	s10,16(sp)
    8000325a:	6da2                	ld	s11,8(sp)
    8000325c:	6165                	addi	sp,sp,112
    8000325e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003260:	89da                	mv	s3,s6
    80003262:	bfc9                	j	80003234 <writei+0xe2>
    return -1;
    80003264:	557d                	li	a0,-1
}
    80003266:	8082                	ret
    return -1;
    80003268:	557d                	li	a0,-1
    8000326a:	bfe1                	j	80003242 <writei+0xf0>
    return -1;
    8000326c:	557d                	li	a0,-1
    8000326e:	bfd1                	j	80003242 <writei+0xf0>

0000000080003270 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003270:	1141                	addi	sp,sp,-16
    80003272:	e406                	sd	ra,8(sp)
    80003274:	e022                	sd	s0,0(sp)
    80003276:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003278:	4639                	li	a2,14
    8000327a:	ffffd097          	auipc	ra,0xffffd
    8000327e:	fd6080e7          	jalr	-42(ra) # 80000250 <strncmp>
}
    80003282:	60a2                	ld	ra,8(sp)
    80003284:	6402                	ld	s0,0(sp)
    80003286:	0141                	addi	sp,sp,16
    80003288:	8082                	ret

000000008000328a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000328a:	7139                	addi	sp,sp,-64
    8000328c:	fc06                	sd	ra,56(sp)
    8000328e:	f822                	sd	s0,48(sp)
    80003290:	f426                	sd	s1,40(sp)
    80003292:	f04a                	sd	s2,32(sp)
    80003294:	ec4e                	sd	s3,24(sp)
    80003296:	e852                	sd	s4,16(sp)
    80003298:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000329a:	04451703          	lh	a4,68(a0)
    8000329e:	4785                	li	a5,1
    800032a0:	00f71a63          	bne	a4,a5,800032b4 <dirlookup+0x2a>
    800032a4:	892a                	mv	s2,a0
    800032a6:	89ae                	mv	s3,a1
    800032a8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032aa:	457c                	lw	a5,76(a0)
    800032ac:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032ae:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b0:	e79d                	bnez	a5,800032de <dirlookup+0x54>
    800032b2:	a8a5                	j	8000332a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032b4:	00005517          	auipc	a0,0x5
    800032b8:	37450513          	addi	a0,a0,884 # 80008628 <syscalls+0x1e8>
    800032bc:	00003097          	auipc	ra,0x3
    800032c0:	c06080e7          	jalr	-1018(ra) # 80005ec2 <panic>
      panic("dirlookup read");
    800032c4:	00005517          	auipc	a0,0x5
    800032c8:	37c50513          	addi	a0,a0,892 # 80008640 <syscalls+0x200>
    800032cc:	00003097          	auipc	ra,0x3
    800032d0:	bf6080e7          	jalr	-1034(ra) # 80005ec2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d4:	24c1                	addiw	s1,s1,16
    800032d6:	04c92783          	lw	a5,76(s2)
    800032da:	04f4f763          	bgeu	s1,a5,80003328 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032de:	4741                	li	a4,16
    800032e0:	86a6                	mv	a3,s1
    800032e2:	fc040613          	addi	a2,s0,-64
    800032e6:	4581                	li	a1,0
    800032e8:	854a                	mv	a0,s2
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	d70080e7          	jalr	-656(ra) # 8000305a <readi>
    800032f2:	47c1                	li	a5,16
    800032f4:	fcf518e3          	bne	a0,a5,800032c4 <dirlookup+0x3a>
    if(de.inum == 0)
    800032f8:	fc045783          	lhu	a5,-64(s0)
    800032fc:	dfe1                	beqz	a5,800032d4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032fe:	fc240593          	addi	a1,s0,-62
    80003302:	854e                	mv	a0,s3
    80003304:	00000097          	auipc	ra,0x0
    80003308:	f6c080e7          	jalr	-148(ra) # 80003270 <namecmp>
    8000330c:	f561                	bnez	a0,800032d4 <dirlookup+0x4a>
      if(poff)
    8000330e:	000a0463          	beqz	s4,80003316 <dirlookup+0x8c>
        *poff = off;
    80003312:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003316:	fc045583          	lhu	a1,-64(s0)
    8000331a:	00092503          	lw	a0,0(s2)
    8000331e:	fffff097          	auipc	ra,0xfffff
    80003322:	750080e7          	jalr	1872(ra) # 80002a6e <iget>
    80003326:	a011                	j	8000332a <dirlookup+0xa0>
  return 0;
    80003328:	4501                	li	a0,0
}
    8000332a:	70e2                	ld	ra,56(sp)
    8000332c:	7442                	ld	s0,48(sp)
    8000332e:	74a2                	ld	s1,40(sp)
    80003330:	7902                	ld	s2,32(sp)
    80003332:	69e2                	ld	s3,24(sp)
    80003334:	6a42                	ld	s4,16(sp)
    80003336:	6121                	addi	sp,sp,64
    80003338:	8082                	ret

000000008000333a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000333a:	711d                	addi	sp,sp,-96
    8000333c:	ec86                	sd	ra,88(sp)
    8000333e:	e8a2                	sd	s0,80(sp)
    80003340:	e4a6                	sd	s1,72(sp)
    80003342:	e0ca                	sd	s2,64(sp)
    80003344:	fc4e                	sd	s3,56(sp)
    80003346:	f852                	sd	s4,48(sp)
    80003348:	f456                	sd	s5,40(sp)
    8000334a:	f05a                	sd	s6,32(sp)
    8000334c:	ec5e                	sd	s7,24(sp)
    8000334e:	e862                	sd	s8,16(sp)
    80003350:	e466                	sd	s9,8(sp)
    80003352:	1080                	addi	s0,sp,96
    80003354:	84aa                	mv	s1,a0
    80003356:	8b2e                	mv	s6,a1
    80003358:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000335a:	00054703          	lbu	a4,0(a0)
    8000335e:	02f00793          	li	a5,47
    80003362:	02f70363          	beq	a4,a5,80003388 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003366:	ffffe097          	auipc	ra,0xffffe
    8000336a:	c3e080e7          	jalr	-962(ra) # 80000fa4 <myproc>
    8000336e:	15053503          	ld	a0,336(a0)
    80003372:	00000097          	auipc	ra,0x0
    80003376:	9f6080e7          	jalr	-1546(ra) # 80002d68 <idup>
    8000337a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000337c:	02f00913          	li	s2,47
  len = path - s;
    80003380:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003382:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003384:	4c05                	li	s8,1
    80003386:	a865                	j	8000343e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003388:	4585                	li	a1,1
    8000338a:	4505                	li	a0,1
    8000338c:	fffff097          	auipc	ra,0xfffff
    80003390:	6e2080e7          	jalr	1762(ra) # 80002a6e <iget>
    80003394:	89aa                	mv	s3,a0
    80003396:	b7dd                	j	8000337c <namex+0x42>
      iunlockput(ip);
    80003398:	854e                	mv	a0,s3
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	c6e080e7          	jalr	-914(ra) # 80003008 <iunlockput>
      return 0;
    800033a2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033a4:	854e                	mv	a0,s3
    800033a6:	60e6                	ld	ra,88(sp)
    800033a8:	6446                	ld	s0,80(sp)
    800033aa:	64a6                	ld	s1,72(sp)
    800033ac:	6906                	ld	s2,64(sp)
    800033ae:	79e2                	ld	s3,56(sp)
    800033b0:	7a42                	ld	s4,48(sp)
    800033b2:	7aa2                	ld	s5,40(sp)
    800033b4:	7b02                	ld	s6,32(sp)
    800033b6:	6be2                	ld	s7,24(sp)
    800033b8:	6c42                	ld	s8,16(sp)
    800033ba:	6ca2                	ld	s9,8(sp)
    800033bc:	6125                	addi	sp,sp,96
    800033be:	8082                	ret
      iunlock(ip);
    800033c0:	854e                	mv	a0,s3
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	aa6080e7          	jalr	-1370(ra) # 80002e68 <iunlock>
      return ip;
    800033ca:	bfe9                	j	800033a4 <namex+0x6a>
      iunlockput(ip);
    800033cc:	854e                	mv	a0,s3
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	c3a080e7          	jalr	-966(ra) # 80003008 <iunlockput>
      return 0;
    800033d6:	89d2                	mv	s3,s4
    800033d8:	b7f1                	j	800033a4 <namex+0x6a>
  len = path - s;
    800033da:	40b48633          	sub	a2,s1,a1
    800033de:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033e2:	094cd463          	bge	s9,s4,8000346a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033e6:	4639                	li	a2,14
    800033e8:	8556                	mv	a0,s5
    800033ea:	ffffd097          	auipc	ra,0xffffd
    800033ee:	dee080e7          	jalr	-530(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033f2:	0004c783          	lbu	a5,0(s1)
    800033f6:	01279763          	bne	a5,s2,80003404 <namex+0xca>
    path++;
    800033fa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033fc:	0004c783          	lbu	a5,0(s1)
    80003400:	ff278de3          	beq	a5,s2,800033fa <namex+0xc0>
    ilock(ip);
    80003404:	854e                	mv	a0,s3
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	9a0080e7          	jalr	-1632(ra) # 80002da6 <ilock>
    if(ip->type != T_DIR){
    8000340e:	04499783          	lh	a5,68(s3)
    80003412:	f98793e3          	bne	a5,s8,80003398 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003416:	000b0563          	beqz	s6,80003420 <namex+0xe6>
    8000341a:	0004c783          	lbu	a5,0(s1)
    8000341e:	d3cd                	beqz	a5,800033c0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003420:	865e                	mv	a2,s7
    80003422:	85d6                	mv	a1,s5
    80003424:	854e                	mv	a0,s3
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	e64080e7          	jalr	-412(ra) # 8000328a <dirlookup>
    8000342e:	8a2a                	mv	s4,a0
    80003430:	dd51                	beqz	a0,800033cc <namex+0x92>
    iunlockput(ip);
    80003432:	854e                	mv	a0,s3
    80003434:	00000097          	auipc	ra,0x0
    80003438:	bd4080e7          	jalr	-1068(ra) # 80003008 <iunlockput>
    ip = next;
    8000343c:	89d2                	mv	s3,s4
  while(*path == '/')
    8000343e:	0004c783          	lbu	a5,0(s1)
    80003442:	05279763          	bne	a5,s2,80003490 <namex+0x156>
    path++;
    80003446:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003448:	0004c783          	lbu	a5,0(s1)
    8000344c:	ff278de3          	beq	a5,s2,80003446 <namex+0x10c>
  if(*path == 0)
    80003450:	c79d                	beqz	a5,8000347e <namex+0x144>
    path++;
    80003452:	85a6                	mv	a1,s1
  len = path - s;
    80003454:	8a5e                	mv	s4,s7
    80003456:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003458:	01278963          	beq	a5,s2,8000346a <namex+0x130>
    8000345c:	dfbd                	beqz	a5,800033da <namex+0xa0>
    path++;
    8000345e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003460:	0004c783          	lbu	a5,0(s1)
    80003464:	ff279ce3          	bne	a5,s2,8000345c <namex+0x122>
    80003468:	bf8d                	j	800033da <namex+0xa0>
    memmove(name, s, len);
    8000346a:	2601                	sext.w	a2,a2
    8000346c:	8556                	mv	a0,s5
    8000346e:	ffffd097          	auipc	ra,0xffffd
    80003472:	d6a080e7          	jalr	-662(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003476:	9a56                	add	s4,s4,s5
    80003478:	000a0023          	sb	zero,0(s4)
    8000347c:	bf9d                	j	800033f2 <namex+0xb8>
  if(nameiparent){
    8000347e:	f20b03e3          	beqz	s6,800033a4 <namex+0x6a>
    iput(ip);
    80003482:	854e                	mv	a0,s3
    80003484:	00000097          	auipc	ra,0x0
    80003488:	adc080e7          	jalr	-1316(ra) # 80002f60 <iput>
    return 0;
    8000348c:	4981                	li	s3,0
    8000348e:	bf19                	j	800033a4 <namex+0x6a>
  if(*path == 0)
    80003490:	d7fd                	beqz	a5,8000347e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003492:	0004c783          	lbu	a5,0(s1)
    80003496:	85a6                	mv	a1,s1
    80003498:	b7d1                	j	8000345c <namex+0x122>

000000008000349a <dirlink>:
{
    8000349a:	7139                	addi	sp,sp,-64
    8000349c:	fc06                	sd	ra,56(sp)
    8000349e:	f822                	sd	s0,48(sp)
    800034a0:	f426                	sd	s1,40(sp)
    800034a2:	f04a                	sd	s2,32(sp)
    800034a4:	ec4e                	sd	s3,24(sp)
    800034a6:	e852                	sd	s4,16(sp)
    800034a8:	0080                	addi	s0,sp,64
    800034aa:	892a                	mv	s2,a0
    800034ac:	8a2e                	mv	s4,a1
    800034ae:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034b0:	4601                	li	a2,0
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	dd8080e7          	jalr	-552(ra) # 8000328a <dirlookup>
    800034ba:	e93d                	bnez	a0,80003530 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034bc:	04c92483          	lw	s1,76(s2)
    800034c0:	c49d                	beqz	s1,800034ee <dirlink+0x54>
    800034c2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c4:	4741                	li	a4,16
    800034c6:	86a6                	mv	a3,s1
    800034c8:	fc040613          	addi	a2,s0,-64
    800034cc:	4581                	li	a1,0
    800034ce:	854a                	mv	a0,s2
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	b8a080e7          	jalr	-1142(ra) # 8000305a <readi>
    800034d8:	47c1                	li	a5,16
    800034da:	06f51163          	bne	a0,a5,8000353c <dirlink+0xa2>
    if(de.inum == 0)
    800034de:	fc045783          	lhu	a5,-64(s0)
    800034e2:	c791                	beqz	a5,800034ee <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e4:	24c1                	addiw	s1,s1,16
    800034e6:	04c92783          	lw	a5,76(s2)
    800034ea:	fcf4ede3          	bltu	s1,a5,800034c4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034ee:	4639                	li	a2,14
    800034f0:	85d2                	mv	a1,s4
    800034f2:	fc240513          	addi	a0,s0,-62
    800034f6:	ffffd097          	auipc	ra,0xffffd
    800034fa:	d96080e7          	jalr	-618(ra) # 8000028c <strncpy>
  de.inum = inum;
    800034fe:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003502:	4741                	li	a4,16
    80003504:	86a6                	mv	a3,s1
    80003506:	fc040613          	addi	a2,s0,-64
    8000350a:	4581                	li	a1,0
    8000350c:	854a                	mv	a0,s2
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	c44080e7          	jalr	-956(ra) # 80003152 <writei>
    80003516:	1541                	addi	a0,a0,-16
    80003518:	00a03533          	snez	a0,a0
    8000351c:	40a00533          	neg	a0,a0
}
    80003520:	70e2                	ld	ra,56(sp)
    80003522:	7442                	ld	s0,48(sp)
    80003524:	74a2                	ld	s1,40(sp)
    80003526:	7902                	ld	s2,32(sp)
    80003528:	69e2                	ld	s3,24(sp)
    8000352a:	6a42                	ld	s4,16(sp)
    8000352c:	6121                	addi	sp,sp,64
    8000352e:	8082                	ret
    iput(ip);
    80003530:	00000097          	auipc	ra,0x0
    80003534:	a30080e7          	jalr	-1488(ra) # 80002f60 <iput>
    return -1;
    80003538:	557d                	li	a0,-1
    8000353a:	b7dd                	j	80003520 <dirlink+0x86>
      panic("dirlink read");
    8000353c:	00005517          	auipc	a0,0x5
    80003540:	11450513          	addi	a0,a0,276 # 80008650 <syscalls+0x210>
    80003544:	00003097          	auipc	ra,0x3
    80003548:	97e080e7          	jalr	-1666(ra) # 80005ec2 <panic>

000000008000354c <namei>:

struct inode*
namei(char *path)
{
    8000354c:	1101                	addi	sp,sp,-32
    8000354e:	ec06                	sd	ra,24(sp)
    80003550:	e822                	sd	s0,16(sp)
    80003552:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003554:	fe040613          	addi	a2,s0,-32
    80003558:	4581                	li	a1,0
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	de0080e7          	jalr	-544(ra) # 8000333a <namex>
}
    80003562:	60e2                	ld	ra,24(sp)
    80003564:	6442                	ld	s0,16(sp)
    80003566:	6105                	addi	sp,sp,32
    80003568:	8082                	ret

000000008000356a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000356a:	1141                	addi	sp,sp,-16
    8000356c:	e406                	sd	ra,8(sp)
    8000356e:	e022                	sd	s0,0(sp)
    80003570:	0800                	addi	s0,sp,16
    80003572:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003574:	4585                	li	a1,1
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	dc4080e7          	jalr	-572(ra) # 8000333a <namex>
}
    8000357e:	60a2                	ld	ra,8(sp)
    80003580:	6402                	ld	s0,0(sp)
    80003582:	0141                	addi	sp,sp,16
    80003584:	8082                	ret

0000000080003586 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003586:	1101                	addi	sp,sp,-32
    80003588:	ec06                	sd	ra,24(sp)
    8000358a:	e822                	sd	s0,16(sp)
    8000358c:	e426                	sd	s1,8(sp)
    8000358e:	e04a                	sd	s2,0(sp)
    80003590:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003592:	00015917          	auipc	s2,0x15
    80003596:	5fe90913          	addi	s2,s2,1534 # 80018b90 <log>
    8000359a:	01892583          	lw	a1,24(s2)
    8000359e:	02892503          	lw	a0,40(s2)
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	fea080e7          	jalr	-22(ra) # 8000258c <bread>
    800035aa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035ac:	02c92683          	lw	a3,44(s2)
    800035b0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035b2:	02d05763          	blez	a3,800035e0 <write_head+0x5a>
    800035b6:	00015797          	auipc	a5,0x15
    800035ba:	60a78793          	addi	a5,a5,1546 # 80018bc0 <log+0x30>
    800035be:	05c50713          	addi	a4,a0,92
    800035c2:	36fd                	addiw	a3,a3,-1
    800035c4:	1682                	slli	a3,a3,0x20
    800035c6:	9281                	srli	a3,a3,0x20
    800035c8:	068a                	slli	a3,a3,0x2
    800035ca:	00015617          	auipc	a2,0x15
    800035ce:	5fa60613          	addi	a2,a2,1530 # 80018bc4 <log+0x34>
    800035d2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035d4:	4390                	lw	a2,0(a5)
    800035d6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035d8:	0791                	addi	a5,a5,4
    800035da:	0711                	addi	a4,a4,4
    800035dc:	fed79ce3          	bne	a5,a3,800035d4 <write_head+0x4e>
  }
  bwrite(buf);
    800035e0:	8526                	mv	a0,s1
    800035e2:	fffff097          	auipc	ra,0xfffff
    800035e6:	09c080e7          	jalr	156(ra) # 8000267e <bwrite>
  brelse(buf);
    800035ea:	8526                	mv	a0,s1
    800035ec:	fffff097          	auipc	ra,0xfffff
    800035f0:	0d0080e7          	jalr	208(ra) # 800026bc <brelse>
}
    800035f4:	60e2                	ld	ra,24(sp)
    800035f6:	6442                	ld	s0,16(sp)
    800035f8:	64a2                	ld	s1,8(sp)
    800035fa:	6902                	ld	s2,0(sp)
    800035fc:	6105                	addi	sp,sp,32
    800035fe:	8082                	ret

0000000080003600 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003600:	00015797          	auipc	a5,0x15
    80003604:	5bc7a783          	lw	a5,1468(a5) # 80018bbc <log+0x2c>
    80003608:	0af05d63          	blez	a5,800036c2 <install_trans+0xc2>
{
    8000360c:	7139                	addi	sp,sp,-64
    8000360e:	fc06                	sd	ra,56(sp)
    80003610:	f822                	sd	s0,48(sp)
    80003612:	f426                	sd	s1,40(sp)
    80003614:	f04a                	sd	s2,32(sp)
    80003616:	ec4e                	sd	s3,24(sp)
    80003618:	e852                	sd	s4,16(sp)
    8000361a:	e456                	sd	s5,8(sp)
    8000361c:	e05a                	sd	s6,0(sp)
    8000361e:	0080                	addi	s0,sp,64
    80003620:	8b2a                	mv	s6,a0
    80003622:	00015a97          	auipc	s5,0x15
    80003626:	59ea8a93          	addi	s5,s5,1438 # 80018bc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000362a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000362c:	00015997          	auipc	s3,0x15
    80003630:	56498993          	addi	s3,s3,1380 # 80018b90 <log>
    80003634:	a035                	j	80003660 <install_trans+0x60>
      bunpin(dbuf);
    80003636:	8526                	mv	a0,s1
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	15e080e7          	jalr	350(ra) # 80002796 <bunpin>
    brelse(lbuf);
    80003640:	854a                	mv	a0,s2
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	07a080e7          	jalr	122(ra) # 800026bc <brelse>
    brelse(dbuf);
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	070080e7          	jalr	112(ra) # 800026bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003654:	2a05                	addiw	s4,s4,1
    80003656:	0a91                	addi	s5,s5,4
    80003658:	02c9a783          	lw	a5,44(s3)
    8000365c:	04fa5963          	bge	s4,a5,800036ae <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003660:	0189a583          	lw	a1,24(s3)
    80003664:	014585bb          	addw	a1,a1,s4
    80003668:	2585                	addiw	a1,a1,1
    8000366a:	0289a503          	lw	a0,40(s3)
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	f1e080e7          	jalr	-226(ra) # 8000258c <bread>
    80003676:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003678:	000aa583          	lw	a1,0(s5)
    8000367c:	0289a503          	lw	a0,40(s3)
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	f0c080e7          	jalr	-244(ra) # 8000258c <bread>
    80003688:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000368a:	40000613          	li	a2,1024
    8000368e:	05890593          	addi	a1,s2,88
    80003692:	05850513          	addi	a0,a0,88
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	b42080e7          	jalr	-1214(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000369e:	8526                	mv	a0,s1
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	fde080e7          	jalr	-34(ra) # 8000267e <bwrite>
    if(recovering == 0)
    800036a8:	f80b1ce3          	bnez	s6,80003640 <install_trans+0x40>
    800036ac:	b769                	j	80003636 <install_trans+0x36>
}
    800036ae:	70e2                	ld	ra,56(sp)
    800036b0:	7442                	ld	s0,48(sp)
    800036b2:	74a2                	ld	s1,40(sp)
    800036b4:	7902                	ld	s2,32(sp)
    800036b6:	69e2                	ld	s3,24(sp)
    800036b8:	6a42                	ld	s4,16(sp)
    800036ba:	6aa2                	ld	s5,8(sp)
    800036bc:	6b02                	ld	s6,0(sp)
    800036be:	6121                	addi	sp,sp,64
    800036c0:	8082                	ret
    800036c2:	8082                	ret

00000000800036c4 <initlog>:
{
    800036c4:	7179                	addi	sp,sp,-48
    800036c6:	f406                	sd	ra,40(sp)
    800036c8:	f022                	sd	s0,32(sp)
    800036ca:	ec26                	sd	s1,24(sp)
    800036cc:	e84a                	sd	s2,16(sp)
    800036ce:	e44e                	sd	s3,8(sp)
    800036d0:	1800                	addi	s0,sp,48
    800036d2:	892a                	mv	s2,a0
    800036d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036d6:	00015497          	auipc	s1,0x15
    800036da:	4ba48493          	addi	s1,s1,1210 # 80018b90 <log>
    800036de:	00005597          	auipc	a1,0x5
    800036e2:	f8258593          	addi	a1,a1,-126 # 80008660 <syscalls+0x220>
    800036e6:	8526                	mv	a0,s1
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	c94080e7          	jalr	-876(ra) # 8000637c <initlock>
  log.start = sb->logstart;
    800036f0:	0149a583          	lw	a1,20(s3)
    800036f4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036f6:	0109a783          	lw	a5,16(s3)
    800036fa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036fc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003700:	854a                	mv	a0,s2
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	e8a080e7          	jalr	-374(ra) # 8000258c <bread>
  log.lh.n = lh->n;
    8000370a:	4d3c                	lw	a5,88(a0)
    8000370c:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000370e:	02f05563          	blez	a5,80003738 <initlog+0x74>
    80003712:	05c50713          	addi	a4,a0,92
    80003716:	00015697          	auipc	a3,0x15
    8000371a:	4aa68693          	addi	a3,a3,1194 # 80018bc0 <log+0x30>
    8000371e:	37fd                	addiw	a5,a5,-1
    80003720:	1782                	slli	a5,a5,0x20
    80003722:	9381                	srli	a5,a5,0x20
    80003724:	078a                	slli	a5,a5,0x2
    80003726:	06050613          	addi	a2,a0,96
    8000372a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000372c:	4310                	lw	a2,0(a4)
    8000372e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003730:	0711                	addi	a4,a4,4
    80003732:	0691                	addi	a3,a3,4
    80003734:	fef71ce3          	bne	a4,a5,8000372c <initlog+0x68>
  brelse(buf);
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	f84080e7          	jalr	-124(ra) # 800026bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003740:	4505                	li	a0,1
    80003742:	00000097          	auipc	ra,0x0
    80003746:	ebe080e7          	jalr	-322(ra) # 80003600 <install_trans>
  log.lh.n = 0;
    8000374a:	00015797          	auipc	a5,0x15
    8000374e:	4607a923          	sw	zero,1138(a5) # 80018bbc <log+0x2c>
  write_head(); // clear the log
    80003752:	00000097          	auipc	ra,0x0
    80003756:	e34080e7          	jalr	-460(ra) # 80003586 <write_head>
}
    8000375a:	70a2                	ld	ra,40(sp)
    8000375c:	7402                	ld	s0,32(sp)
    8000375e:	64e2                	ld	s1,24(sp)
    80003760:	6942                	ld	s2,16(sp)
    80003762:	69a2                	ld	s3,8(sp)
    80003764:	6145                	addi	sp,sp,48
    80003766:	8082                	ret

0000000080003768 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003768:	1101                	addi	sp,sp,-32
    8000376a:	ec06                	sd	ra,24(sp)
    8000376c:	e822                	sd	s0,16(sp)
    8000376e:	e426                	sd	s1,8(sp)
    80003770:	e04a                	sd	s2,0(sp)
    80003772:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003774:	00015517          	auipc	a0,0x15
    80003778:	41c50513          	addi	a0,a0,1052 # 80018b90 <log>
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	c90080e7          	jalr	-880(ra) # 8000640c <acquire>
  while(1){
    if(log.committing){
    80003784:	00015497          	auipc	s1,0x15
    80003788:	40c48493          	addi	s1,s1,1036 # 80018b90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000378c:	4979                	li	s2,30
    8000378e:	a039                	j	8000379c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003790:	85a6                	mv	a1,s1
    80003792:	8526                	mv	a0,s1
    80003794:	ffffe097          	auipc	ra,0xffffe
    80003798:	f6e080e7          	jalr	-146(ra) # 80001702 <sleep>
    if(log.committing){
    8000379c:	50dc                	lw	a5,36(s1)
    8000379e:	fbed                	bnez	a5,80003790 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a0:	509c                	lw	a5,32(s1)
    800037a2:	0017871b          	addiw	a4,a5,1
    800037a6:	0007069b          	sext.w	a3,a4
    800037aa:	0027179b          	slliw	a5,a4,0x2
    800037ae:	9fb9                	addw	a5,a5,a4
    800037b0:	0017979b          	slliw	a5,a5,0x1
    800037b4:	54d8                	lw	a4,44(s1)
    800037b6:	9fb9                	addw	a5,a5,a4
    800037b8:	00f95963          	bge	s2,a5,800037ca <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037bc:	85a6                	mv	a1,s1
    800037be:	8526                	mv	a0,s1
    800037c0:	ffffe097          	auipc	ra,0xffffe
    800037c4:	f42080e7          	jalr	-190(ra) # 80001702 <sleep>
    800037c8:	bfd1                	j	8000379c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037ca:	00015517          	auipc	a0,0x15
    800037ce:	3c650513          	addi	a0,a0,966 # 80018b90 <log>
    800037d2:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037d4:	00003097          	auipc	ra,0x3
    800037d8:	cec080e7          	jalr	-788(ra) # 800064c0 <release>
      break;
    }
  }
}
    800037dc:	60e2                	ld	ra,24(sp)
    800037de:	6442                	ld	s0,16(sp)
    800037e0:	64a2                	ld	s1,8(sp)
    800037e2:	6902                	ld	s2,0(sp)
    800037e4:	6105                	addi	sp,sp,32
    800037e6:	8082                	ret

00000000800037e8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037e8:	7139                	addi	sp,sp,-64
    800037ea:	fc06                	sd	ra,56(sp)
    800037ec:	f822                	sd	s0,48(sp)
    800037ee:	f426                	sd	s1,40(sp)
    800037f0:	f04a                	sd	s2,32(sp)
    800037f2:	ec4e                	sd	s3,24(sp)
    800037f4:	e852                	sd	s4,16(sp)
    800037f6:	e456                	sd	s5,8(sp)
    800037f8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037fa:	00015497          	auipc	s1,0x15
    800037fe:	39648493          	addi	s1,s1,918 # 80018b90 <log>
    80003802:	8526                	mv	a0,s1
    80003804:	00003097          	auipc	ra,0x3
    80003808:	c08080e7          	jalr	-1016(ra) # 8000640c <acquire>
  log.outstanding -= 1;
    8000380c:	509c                	lw	a5,32(s1)
    8000380e:	37fd                	addiw	a5,a5,-1
    80003810:	0007891b          	sext.w	s2,a5
    80003814:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003816:	50dc                	lw	a5,36(s1)
    80003818:	efb9                	bnez	a5,80003876 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000381a:	06091663          	bnez	s2,80003886 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000381e:	00015497          	auipc	s1,0x15
    80003822:	37248493          	addi	s1,s1,882 # 80018b90 <log>
    80003826:	4785                	li	a5,1
    80003828:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000382a:	8526                	mv	a0,s1
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	c94080e7          	jalr	-876(ra) # 800064c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003834:	54dc                	lw	a5,44(s1)
    80003836:	06f04763          	bgtz	a5,800038a4 <end_op+0xbc>
    acquire(&log.lock);
    8000383a:	00015497          	auipc	s1,0x15
    8000383e:	35648493          	addi	s1,s1,854 # 80018b90 <log>
    80003842:	8526                	mv	a0,s1
    80003844:	00003097          	auipc	ra,0x3
    80003848:	bc8080e7          	jalr	-1080(ra) # 8000640c <acquire>
    log.committing = 0;
    8000384c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003850:	8526                	mv	a0,s1
    80003852:	ffffe097          	auipc	ra,0xffffe
    80003856:	f14080e7          	jalr	-236(ra) # 80001766 <wakeup>
    release(&log.lock);
    8000385a:	8526                	mv	a0,s1
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	c64080e7          	jalr	-924(ra) # 800064c0 <release>
}
    80003864:	70e2                	ld	ra,56(sp)
    80003866:	7442                	ld	s0,48(sp)
    80003868:	74a2                	ld	s1,40(sp)
    8000386a:	7902                	ld	s2,32(sp)
    8000386c:	69e2                	ld	s3,24(sp)
    8000386e:	6a42                	ld	s4,16(sp)
    80003870:	6aa2                	ld	s5,8(sp)
    80003872:	6121                	addi	sp,sp,64
    80003874:	8082                	ret
    panic("log.committing");
    80003876:	00005517          	auipc	a0,0x5
    8000387a:	df250513          	addi	a0,a0,-526 # 80008668 <syscalls+0x228>
    8000387e:	00002097          	auipc	ra,0x2
    80003882:	644080e7          	jalr	1604(ra) # 80005ec2 <panic>
    wakeup(&log);
    80003886:	00015497          	auipc	s1,0x15
    8000388a:	30a48493          	addi	s1,s1,778 # 80018b90 <log>
    8000388e:	8526                	mv	a0,s1
    80003890:	ffffe097          	auipc	ra,0xffffe
    80003894:	ed6080e7          	jalr	-298(ra) # 80001766 <wakeup>
  release(&log.lock);
    80003898:	8526                	mv	a0,s1
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	c26080e7          	jalr	-986(ra) # 800064c0 <release>
  if(do_commit){
    800038a2:	b7c9                	j	80003864 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a4:	00015a97          	auipc	s5,0x15
    800038a8:	31ca8a93          	addi	s5,s5,796 # 80018bc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038ac:	00015a17          	auipc	s4,0x15
    800038b0:	2e4a0a13          	addi	s4,s4,740 # 80018b90 <log>
    800038b4:	018a2583          	lw	a1,24(s4)
    800038b8:	012585bb          	addw	a1,a1,s2
    800038bc:	2585                	addiw	a1,a1,1
    800038be:	028a2503          	lw	a0,40(s4)
    800038c2:	fffff097          	auipc	ra,0xfffff
    800038c6:	cca080e7          	jalr	-822(ra) # 8000258c <bread>
    800038ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038cc:	000aa583          	lw	a1,0(s5)
    800038d0:	028a2503          	lw	a0,40(s4)
    800038d4:	fffff097          	auipc	ra,0xfffff
    800038d8:	cb8080e7          	jalr	-840(ra) # 8000258c <bread>
    800038dc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038de:	40000613          	li	a2,1024
    800038e2:	05850593          	addi	a1,a0,88
    800038e6:	05848513          	addi	a0,s1,88
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	8ee080e7          	jalr	-1810(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800038f2:	8526                	mv	a0,s1
    800038f4:	fffff097          	auipc	ra,0xfffff
    800038f8:	d8a080e7          	jalr	-630(ra) # 8000267e <bwrite>
    brelse(from);
    800038fc:	854e                	mv	a0,s3
    800038fe:	fffff097          	auipc	ra,0xfffff
    80003902:	dbe080e7          	jalr	-578(ra) # 800026bc <brelse>
    brelse(to);
    80003906:	8526                	mv	a0,s1
    80003908:	fffff097          	auipc	ra,0xfffff
    8000390c:	db4080e7          	jalr	-588(ra) # 800026bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003910:	2905                	addiw	s2,s2,1
    80003912:	0a91                	addi	s5,s5,4
    80003914:	02ca2783          	lw	a5,44(s4)
    80003918:	f8f94ee3          	blt	s2,a5,800038b4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000391c:	00000097          	auipc	ra,0x0
    80003920:	c6a080e7          	jalr	-918(ra) # 80003586 <write_head>
    install_trans(0); // Now install writes to home locations
    80003924:	4501                	li	a0,0
    80003926:	00000097          	auipc	ra,0x0
    8000392a:	cda080e7          	jalr	-806(ra) # 80003600 <install_trans>
    log.lh.n = 0;
    8000392e:	00015797          	auipc	a5,0x15
    80003932:	2807a723          	sw	zero,654(a5) # 80018bbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003936:	00000097          	auipc	ra,0x0
    8000393a:	c50080e7          	jalr	-944(ra) # 80003586 <write_head>
    8000393e:	bdf5                	j	8000383a <end_op+0x52>

0000000080003940 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003940:	1101                	addi	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	e426                	sd	s1,8(sp)
    80003948:	e04a                	sd	s2,0(sp)
    8000394a:	1000                	addi	s0,sp,32
    8000394c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000394e:	00015917          	auipc	s2,0x15
    80003952:	24290913          	addi	s2,s2,578 # 80018b90 <log>
    80003956:	854a                	mv	a0,s2
    80003958:	00003097          	auipc	ra,0x3
    8000395c:	ab4080e7          	jalr	-1356(ra) # 8000640c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003960:	02c92603          	lw	a2,44(s2)
    80003964:	47f5                	li	a5,29
    80003966:	06c7c563          	blt	a5,a2,800039d0 <log_write+0x90>
    8000396a:	00015797          	auipc	a5,0x15
    8000396e:	2427a783          	lw	a5,578(a5) # 80018bac <log+0x1c>
    80003972:	37fd                	addiw	a5,a5,-1
    80003974:	04f65e63          	bge	a2,a5,800039d0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003978:	00015797          	auipc	a5,0x15
    8000397c:	2387a783          	lw	a5,568(a5) # 80018bb0 <log+0x20>
    80003980:	06f05063          	blez	a5,800039e0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003984:	4781                	li	a5,0
    80003986:	06c05563          	blez	a2,800039f0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000398a:	44cc                	lw	a1,12(s1)
    8000398c:	00015717          	auipc	a4,0x15
    80003990:	23470713          	addi	a4,a4,564 # 80018bc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003994:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003996:	4314                	lw	a3,0(a4)
    80003998:	04b68c63          	beq	a3,a1,800039f0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000399c:	2785                	addiw	a5,a5,1
    8000399e:	0711                	addi	a4,a4,4
    800039a0:	fef61be3          	bne	a2,a5,80003996 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039a4:	0621                	addi	a2,a2,8
    800039a6:	060a                	slli	a2,a2,0x2
    800039a8:	00015797          	auipc	a5,0x15
    800039ac:	1e878793          	addi	a5,a5,488 # 80018b90 <log>
    800039b0:	963e                	add	a2,a2,a5
    800039b2:	44dc                	lw	a5,12(s1)
    800039b4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039b6:	8526                	mv	a0,s1
    800039b8:	fffff097          	auipc	ra,0xfffff
    800039bc:	da2080e7          	jalr	-606(ra) # 8000275a <bpin>
    log.lh.n++;
    800039c0:	00015717          	auipc	a4,0x15
    800039c4:	1d070713          	addi	a4,a4,464 # 80018b90 <log>
    800039c8:	575c                	lw	a5,44(a4)
    800039ca:	2785                	addiw	a5,a5,1
    800039cc:	d75c                	sw	a5,44(a4)
    800039ce:	a835                	j	80003a0a <log_write+0xca>
    panic("too big a transaction");
    800039d0:	00005517          	auipc	a0,0x5
    800039d4:	ca850513          	addi	a0,a0,-856 # 80008678 <syscalls+0x238>
    800039d8:	00002097          	auipc	ra,0x2
    800039dc:	4ea080e7          	jalr	1258(ra) # 80005ec2 <panic>
    panic("log_write outside of trans");
    800039e0:	00005517          	auipc	a0,0x5
    800039e4:	cb050513          	addi	a0,a0,-848 # 80008690 <syscalls+0x250>
    800039e8:	00002097          	auipc	ra,0x2
    800039ec:	4da080e7          	jalr	1242(ra) # 80005ec2 <panic>
  log.lh.block[i] = b->blockno;
    800039f0:	00878713          	addi	a4,a5,8
    800039f4:	00271693          	slli	a3,a4,0x2
    800039f8:	00015717          	auipc	a4,0x15
    800039fc:	19870713          	addi	a4,a4,408 # 80018b90 <log>
    80003a00:	9736                	add	a4,a4,a3
    80003a02:	44d4                	lw	a3,12(s1)
    80003a04:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a06:	faf608e3          	beq	a2,a5,800039b6 <log_write+0x76>
  }
  release(&log.lock);
    80003a0a:	00015517          	auipc	a0,0x15
    80003a0e:	18650513          	addi	a0,a0,390 # 80018b90 <log>
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	aae080e7          	jalr	-1362(ra) # 800064c0 <release>
}
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6902                	ld	s2,0(sp)
    80003a22:	6105                	addi	sp,sp,32
    80003a24:	8082                	ret

0000000080003a26 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a26:	1101                	addi	sp,sp,-32
    80003a28:	ec06                	sd	ra,24(sp)
    80003a2a:	e822                	sd	s0,16(sp)
    80003a2c:	e426                	sd	s1,8(sp)
    80003a2e:	e04a                	sd	s2,0(sp)
    80003a30:	1000                	addi	s0,sp,32
    80003a32:	84aa                	mv	s1,a0
    80003a34:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a36:	00005597          	auipc	a1,0x5
    80003a3a:	c7a58593          	addi	a1,a1,-902 # 800086b0 <syscalls+0x270>
    80003a3e:	0521                	addi	a0,a0,8
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	93c080e7          	jalr	-1732(ra) # 8000637c <initlock>
  lk->name = name;
    80003a48:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a4c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a50:	0204a423          	sw	zero,40(s1)
}
    80003a54:	60e2                	ld	ra,24(sp)
    80003a56:	6442                	ld	s0,16(sp)
    80003a58:	64a2                	ld	s1,8(sp)
    80003a5a:	6902                	ld	s2,0(sp)
    80003a5c:	6105                	addi	sp,sp,32
    80003a5e:	8082                	ret

0000000080003a60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a60:	1101                	addi	sp,sp,-32
    80003a62:	ec06                	sd	ra,24(sp)
    80003a64:	e822                	sd	s0,16(sp)
    80003a66:	e426                	sd	s1,8(sp)
    80003a68:	e04a                	sd	s2,0(sp)
    80003a6a:	1000                	addi	s0,sp,32
    80003a6c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a6e:	00850913          	addi	s2,a0,8
    80003a72:	854a                	mv	a0,s2
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	998080e7          	jalr	-1640(ra) # 8000640c <acquire>
  while (lk->locked) {
    80003a7c:	409c                	lw	a5,0(s1)
    80003a7e:	cb89                	beqz	a5,80003a90 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a80:	85ca                	mv	a1,s2
    80003a82:	8526                	mv	a0,s1
    80003a84:	ffffe097          	auipc	ra,0xffffe
    80003a88:	c7e080e7          	jalr	-898(ra) # 80001702 <sleep>
  while (lk->locked) {
    80003a8c:	409c                	lw	a5,0(s1)
    80003a8e:	fbed                	bnez	a5,80003a80 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a90:	4785                	li	a5,1
    80003a92:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a94:	ffffd097          	auipc	ra,0xffffd
    80003a98:	510080e7          	jalr	1296(ra) # 80000fa4 <myproc>
    80003a9c:	591c                	lw	a5,48(a0)
    80003a9e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003aa0:	854a                	mv	a0,s2
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	a1e080e7          	jalr	-1506(ra) # 800064c0 <release>
}
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6902                	ld	s2,0(sp)
    80003ab2:	6105                	addi	sp,sp,32
    80003ab4:	8082                	ret

0000000080003ab6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ab6:	1101                	addi	sp,sp,-32
    80003ab8:	ec06                	sd	ra,24(sp)
    80003aba:	e822                	sd	s0,16(sp)
    80003abc:	e426                	sd	s1,8(sp)
    80003abe:	e04a                	sd	s2,0(sp)
    80003ac0:	1000                	addi	s0,sp,32
    80003ac2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ac4:	00850913          	addi	s2,a0,8
    80003ac8:	854a                	mv	a0,s2
    80003aca:	00003097          	auipc	ra,0x3
    80003ace:	942080e7          	jalr	-1726(ra) # 8000640c <acquire>
  lk->locked = 0;
    80003ad2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ad6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ada:	8526                	mv	a0,s1
    80003adc:	ffffe097          	auipc	ra,0xffffe
    80003ae0:	c8a080e7          	jalr	-886(ra) # 80001766 <wakeup>
  release(&lk->lk);
    80003ae4:	854a                	mv	a0,s2
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	9da080e7          	jalr	-1574(ra) # 800064c0 <release>
}
    80003aee:	60e2                	ld	ra,24(sp)
    80003af0:	6442                	ld	s0,16(sp)
    80003af2:	64a2                	ld	s1,8(sp)
    80003af4:	6902                	ld	s2,0(sp)
    80003af6:	6105                	addi	sp,sp,32
    80003af8:	8082                	ret

0000000080003afa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003afa:	7179                	addi	sp,sp,-48
    80003afc:	f406                	sd	ra,40(sp)
    80003afe:	f022                	sd	s0,32(sp)
    80003b00:	ec26                	sd	s1,24(sp)
    80003b02:	e84a                	sd	s2,16(sp)
    80003b04:	e44e                	sd	s3,8(sp)
    80003b06:	1800                	addi	s0,sp,48
    80003b08:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b0a:	00850913          	addi	s2,a0,8
    80003b0e:	854a                	mv	a0,s2
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	8fc080e7          	jalr	-1796(ra) # 8000640c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b18:	409c                	lw	a5,0(s1)
    80003b1a:	ef99                	bnez	a5,80003b38 <holdingsleep+0x3e>
    80003b1c:	4481                	li	s1,0
  release(&lk->lk);
    80003b1e:	854a                	mv	a0,s2
    80003b20:	00003097          	auipc	ra,0x3
    80003b24:	9a0080e7          	jalr	-1632(ra) # 800064c0 <release>
  return r;
}
    80003b28:	8526                	mv	a0,s1
    80003b2a:	70a2                	ld	ra,40(sp)
    80003b2c:	7402                	ld	s0,32(sp)
    80003b2e:	64e2                	ld	s1,24(sp)
    80003b30:	6942                	ld	s2,16(sp)
    80003b32:	69a2                	ld	s3,8(sp)
    80003b34:	6145                	addi	sp,sp,48
    80003b36:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b38:	0284a983          	lw	s3,40(s1)
    80003b3c:	ffffd097          	auipc	ra,0xffffd
    80003b40:	468080e7          	jalr	1128(ra) # 80000fa4 <myproc>
    80003b44:	5904                	lw	s1,48(a0)
    80003b46:	413484b3          	sub	s1,s1,s3
    80003b4a:	0014b493          	seqz	s1,s1
    80003b4e:	bfc1                	j	80003b1e <holdingsleep+0x24>

0000000080003b50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b50:	1141                	addi	sp,sp,-16
    80003b52:	e406                	sd	ra,8(sp)
    80003b54:	e022                	sd	s0,0(sp)
    80003b56:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b58:	00005597          	auipc	a1,0x5
    80003b5c:	b6858593          	addi	a1,a1,-1176 # 800086c0 <syscalls+0x280>
    80003b60:	00015517          	auipc	a0,0x15
    80003b64:	17850513          	addi	a0,a0,376 # 80018cd8 <ftable>
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	814080e7          	jalr	-2028(ra) # 8000637c <initlock>
}
    80003b70:	60a2                	ld	ra,8(sp)
    80003b72:	6402                	ld	s0,0(sp)
    80003b74:	0141                	addi	sp,sp,16
    80003b76:	8082                	ret

0000000080003b78 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b78:	1101                	addi	sp,sp,-32
    80003b7a:	ec06                	sd	ra,24(sp)
    80003b7c:	e822                	sd	s0,16(sp)
    80003b7e:	e426                	sd	s1,8(sp)
    80003b80:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b82:	00015517          	auipc	a0,0x15
    80003b86:	15650513          	addi	a0,a0,342 # 80018cd8 <ftable>
    80003b8a:	00003097          	auipc	ra,0x3
    80003b8e:	882080e7          	jalr	-1918(ra) # 8000640c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b92:	00015497          	auipc	s1,0x15
    80003b96:	15e48493          	addi	s1,s1,350 # 80018cf0 <ftable+0x18>
    80003b9a:	00016717          	auipc	a4,0x16
    80003b9e:	0f670713          	addi	a4,a4,246 # 80019c90 <disk>
    if(f->ref == 0){
    80003ba2:	40dc                	lw	a5,4(s1)
    80003ba4:	cf99                	beqz	a5,80003bc2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ba6:	02848493          	addi	s1,s1,40
    80003baa:	fee49ce3          	bne	s1,a4,80003ba2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bae:	00015517          	auipc	a0,0x15
    80003bb2:	12a50513          	addi	a0,a0,298 # 80018cd8 <ftable>
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	90a080e7          	jalr	-1782(ra) # 800064c0 <release>
  return 0;
    80003bbe:	4481                	li	s1,0
    80003bc0:	a819                	j	80003bd6 <filealloc+0x5e>
      f->ref = 1;
    80003bc2:	4785                	li	a5,1
    80003bc4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bc6:	00015517          	auipc	a0,0x15
    80003bca:	11250513          	addi	a0,a0,274 # 80018cd8 <ftable>
    80003bce:	00003097          	auipc	ra,0x3
    80003bd2:	8f2080e7          	jalr	-1806(ra) # 800064c0 <release>
}
    80003bd6:	8526                	mv	a0,s1
    80003bd8:	60e2                	ld	ra,24(sp)
    80003bda:	6442                	ld	s0,16(sp)
    80003bdc:	64a2                	ld	s1,8(sp)
    80003bde:	6105                	addi	sp,sp,32
    80003be0:	8082                	ret

0000000080003be2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003be2:	1101                	addi	sp,sp,-32
    80003be4:	ec06                	sd	ra,24(sp)
    80003be6:	e822                	sd	s0,16(sp)
    80003be8:	e426                	sd	s1,8(sp)
    80003bea:	1000                	addi	s0,sp,32
    80003bec:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bee:	00015517          	auipc	a0,0x15
    80003bf2:	0ea50513          	addi	a0,a0,234 # 80018cd8 <ftable>
    80003bf6:	00003097          	auipc	ra,0x3
    80003bfa:	816080e7          	jalr	-2026(ra) # 8000640c <acquire>
  if(f->ref < 1)
    80003bfe:	40dc                	lw	a5,4(s1)
    80003c00:	02f05263          	blez	a5,80003c24 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c04:	2785                	addiw	a5,a5,1
    80003c06:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c08:	00015517          	auipc	a0,0x15
    80003c0c:	0d050513          	addi	a0,a0,208 # 80018cd8 <ftable>
    80003c10:	00003097          	auipc	ra,0x3
    80003c14:	8b0080e7          	jalr	-1872(ra) # 800064c0 <release>
  return f;
}
    80003c18:	8526                	mv	a0,s1
    80003c1a:	60e2                	ld	ra,24(sp)
    80003c1c:	6442                	ld	s0,16(sp)
    80003c1e:	64a2                	ld	s1,8(sp)
    80003c20:	6105                	addi	sp,sp,32
    80003c22:	8082                	ret
    panic("filedup");
    80003c24:	00005517          	auipc	a0,0x5
    80003c28:	aa450513          	addi	a0,a0,-1372 # 800086c8 <syscalls+0x288>
    80003c2c:	00002097          	auipc	ra,0x2
    80003c30:	296080e7          	jalr	662(ra) # 80005ec2 <panic>

0000000080003c34 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c34:	7139                	addi	sp,sp,-64
    80003c36:	fc06                	sd	ra,56(sp)
    80003c38:	f822                	sd	s0,48(sp)
    80003c3a:	f426                	sd	s1,40(sp)
    80003c3c:	f04a                	sd	s2,32(sp)
    80003c3e:	ec4e                	sd	s3,24(sp)
    80003c40:	e852                	sd	s4,16(sp)
    80003c42:	e456                	sd	s5,8(sp)
    80003c44:	0080                	addi	s0,sp,64
    80003c46:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c48:	00015517          	auipc	a0,0x15
    80003c4c:	09050513          	addi	a0,a0,144 # 80018cd8 <ftable>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	7bc080e7          	jalr	1980(ra) # 8000640c <acquire>
  if(f->ref < 1)
    80003c58:	40dc                	lw	a5,4(s1)
    80003c5a:	06f05163          	blez	a5,80003cbc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c5e:	37fd                	addiw	a5,a5,-1
    80003c60:	0007871b          	sext.w	a4,a5
    80003c64:	c0dc                	sw	a5,4(s1)
    80003c66:	06e04363          	bgtz	a4,80003ccc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c6a:	0004a903          	lw	s2,0(s1)
    80003c6e:	0094ca83          	lbu	s5,9(s1)
    80003c72:	0104ba03          	ld	s4,16(s1)
    80003c76:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c7a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c7e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c82:	00015517          	auipc	a0,0x15
    80003c86:	05650513          	addi	a0,a0,86 # 80018cd8 <ftable>
    80003c8a:	00003097          	auipc	ra,0x3
    80003c8e:	836080e7          	jalr	-1994(ra) # 800064c0 <release>

  if(ff.type == FD_PIPE){
    80003c92:	4785                	li	a5,1
    80003c94:	04f90d63          	beq	s2,a5,80003cee <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c98:	3979                	addiw	s2,s2,-2
    80003c9a:	4785                	li	a5,1
    80003c9c:	0527e063          	bltu	a5,s2,80003cdc <fileclose+0xa8>
    begin_op();
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	ac8080e7          	jalr	-1336(ra) # 80003768 <begin_op>
    iput(ff.ip);
    80003ca8:	854e                	mv	a0,s3
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	2b6080e7          	jalr	694(ra) # 80002f60 <iput>
    end_op();
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	b36080e7          	jalr	-1226(ra) # 800037e8 <end_op>
    80003cba:	a00d                	j	80003cdc <fileclose+0xa8>
    panic("fileclose");
    80003cbc:	00005517          	auipc	a0,0x5
    80003cc0:	a1450513          	addi	a0,a0,-1516 # 800086d0 <syscalls+0x290>
    80003cc4:	00002097          	auipc	ra,0x2
    80003cc8:	1fe080e7          	jalr	510(ra) # 80005ec2 <panic>
    release(&ftable.lock);
    80003ccc:	00015517          	auipc	a0,0x15
    80003cd0:	00c50513          	addi	a0,a0,12 # 80018cd8 <ftable>
    80003cd4:	00002097          	auipc	ra,0x2
    80003cd8:	7ec080e7          	jalr	2028(ra) # 800064c0 <release>
  }
}
    80003cdc:	70e2                	ld	ra,56(sp)
    80003cde:	7442                	ld	s0,48(sp)
    80003ce0:	74a2                	ld	s1,40(sp)
    80003ce2:	7902                	ld	s2,32(sp)
    80003ce4:	69e2                	ld	s3,24(sp)
    80003ce6:	6a42                	ld	s4,16(sp)
    80003ce8:	6aa2                	ld	s5,8(sp)
    80003cea:	6121                	addi	sp,sp,64
    80003cec:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cee:	85d6                	mv	a1,s5
    80003cf0:	8552                	mv	a0,s4
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	34c080e7          	jalr	844(ra) # 8000403e <pipeclose>
    80003cfa:	b7cd                	j	80003cdc <fileclose+0xa8>

0000000080003cfc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cfc:	715d                	addi	sp,sp,-80
    80003cfe:	e486                	sd	ra,72(sp)
    80003d00:	e0a2                	sd	s0,64(sp)
    80003d02:	fc26                	sd	s1,56(sp)
    80003d04:	f84a                	sd	s2,48(sp)
    80003d06:	f44e                	sd	s3,40(sp)
    80003d08:	0880                	addi	s0,sp,80
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d0e:	ffffd097          	auipc	ra,0xffffd
    80003d12:	296080e7          	jalr	662(ra) # 80000fa4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d16:	409c                	lw	a5,0(s1)
    80003d18:	37f9                	addiw	a5,a5,-2
    80003d1a:	4705                	li	a4,1
    80003d1c:	04f76763          	bltu	a4,a5,80003d6a <filestat+0x6e>
    80003d20:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d22:	6c88                	ld	a0,24(s1)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	082080e7          	jalr	130(ra) # 80002da6 <ilock>
    stati(f->ip, &st);
    80003d2c:	fb840593          	addi	a1,s0,-72
    80003d30:	6c88                	ld	a0,24(s1)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	2fe080e7          	jalr	766(ra) # 80003030 <stati>
    iunlock(f->ip);
    80003d3a:	6c88                	ld	a0,24(s1)
    80003d3c:	fffff097          	auipc	ra,0xfffff
    80003d40:	12c080e7          	jalr	300(ra) # 80002e68 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d44:	46e1                	li	a3,24
    80003d46:	fb840613          	addi	a2,s0,-72
    80003d4a:	85ce                	mv	a1,s3
    80003d4c:	05093503          	ld	a0,80(s2)
    80003d50:	ffffd097          	auipc	ra,0xffffd
    80003d54:	dea080e7          	jalr	-534(ra) # 80000b3a <copyout>
    80003d58:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d5c:	60a6                	ld	ra,72(sp)
    80003d5e:	6406                	ld	s0,64(sp)
    80003d60:	74e2                	ld	s1,56(sp)
    80003d62:	7942                	ld	s2,48(sp)
    80003d64:	79a2                	ld	s3,40(sp)
    80003d66:	6161                	addi	sp,sp,80
    80003d68:	8082                	ret
  return -1;
    80003d6a:	557d                	li	a0,-1
    80003d6c:	bfc5                	j	80003d5c <filestat+0x60>

0000000080003d6e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d6e:	7179                	addi	sp,sp,-48
    80003d70:	f406                	sd	ra,40(sp)
    80003d72:	f022                	sd	s0,32(sp)
    80003d74:	ec26                	sd	s1,24(sp)
    80003d76:	e84a                	sd	s2,16(sp)
    80003d78:	e44e                	sd	s3,8(sp)
    80003d7a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d7c:	00854783          	lbu	a5,8(a0)
    80003d80:	c3d5                	beqz	a5,80003e24 <fileread+0xb6>
    80003d82:	84aa                	mv	s1,a0
    80003d84:	89ae                	mv	s3,a1
    80003d86:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d88:	411c                	lw	a5,0(a0)
    80003d8a:	4705                	li	a4,1
    80003d8c:	04e78963          	beq	a5,a4,80003dde <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d90:	470d                	li	a4,3
    80003d92:	04e78d63          	beq	a5,a4,80003dec <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d96:	4709                	li	a4,2
    80003d98:	06e79e63          	bne	a5,a4,80003e14 <fileread+0xa6>
    ilock(f->ip);
    80003d9c:	6d08                	ld	a0,24(a0)
    80003d9e:	fffff097          	auipc	ra,0xfffff
    80003da2:	008080e7          	jalr	8(ra) # 80002da6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003da6:	874a                	mv	a4,s2
    80003da8:	5094                	lw	a3,32(s1)
    80003daa:	864e                	mv	a2,s3
    80003dac:	4585                	li	a1,1
    80003dae:	6c88                	ld	a0,24(s1)
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	2aa080e7          	jalr	682(ra) # 8000305a <readi>
    80003db8:	892a                	mv	s2,a0
    80003dba:	00a05563          	blez	a0,80003dc4 <fileread+0x56>
      f->off += r;
    80003dbe:	509c                	lw	a5,32(s1)
    80003dc0:	9fa9                	addw	a5,a5,a0
    80003dc2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dc4:	6c88                	ld	a0,24(s1)
    80003dc6:	fffff097          	auipc	ra,0xfffff
    80003dca:	0a2080e7          	jalr	162(ra) # 80002e68 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003dce:	854a                	mv	a0,s2
    80003dd0:	70a2                	ld	ra,40(sp)
    80003dd2:	7402                	ld	s0,32(sp)
    80003dd4:	64e2                	ld	s1,24(sp)
    80003dd6:	6942                	ld	s2,16(sp)
    80003dd8:	69a2                	ld	s3,8(sp)
    80003dda:	6145                	addi	sp,sp,48
    80003ddc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dde:	6908                	ld	a0,16(a0)
    80003de0:	00000097          	auipc	ra,0x0
    80003de4:	3ce080e7          	jalr	974(ra) # 800041ae <piperead>
    80003de8:	892a                	mv	s2,a0
    80003dea:	b7d5                	j	80003dce <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dec:	02451783          	lh	a5,36(a0)
    80003df0:	03079693          	slli	a3,a5,0x30
    80003df4:	92c1                	srli	a3,a3,0x30
    80003df6:	4725                	li	a4,9
    80003df8:	02d76863          	bltu	a4,a3,80003e28 <fileread+0xba>
    80003dfc:	0792                	slli	a5,a5,0x4
    80003dfe:	00015717          	auipc	a4,0x15
    80003e02:	e3a70713          	addi	a4,a4,-454 # 80018c38 <devsw>
    80003e06:	97ba                	add	a5,a5,a4
    80003e08:	639c                	ld	a5,0(a5)
    80003e0a:	c38d                	beqz	a5,80003e2c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e0c:	4505                	li	a0,1
    80003e0e:	9782                	jalr	a5
    80003e10:	892a                	mv	s2,a0
    80003e12:	bf75                	j	80003dce <fileread+0x60>
    panic("fileread");
    80003e14:	00005517          	auipc	a0,0x5
    80003e18:	8cc50513          	addi	a0,a0,-1844 # 800086e0 <syscalls+0x2a0>
    80003e1c:	00002097          	auipc	ra,0x2
    80003e20:	0a6080e7          	jalr	166(ra) # 80005ec2 <panic>
    return -1;
    80003e24:	597d                	li	s2,-1
    80003e26:	b765                	j	80003dce <fileread+0x60>
      return -1;
    80003e28:	597d                	li	s2,-1
    80003e2a:	b755                	j	80003dce <fileread+0x60>
    80003e2c:	597d                	li	s2,-1
    80003e2e:	b745                	j	80003dce <fileread+0x60>

0000000080003e30 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e30:	715d                	addi	sp,sp,-80
    80003e32:	e486                	sd	ra,72(sp)
    80003e34:	e0a2                	sd	s0,64(sp)
    80003e36:	fc26                	sd	s1,56(sp)
    80003e38:	f84a                	sd	s2,48(sp)
    80003e3a:	f44e                	sd	s3,40(sp)
    80003e3c:	f052                	sd	s4,32(sp)
    80003e3e:	ec56                	sd	s5,24(sp)
    80003e40:	e85a                	sd	s6,16(sp)
    80003e42:	e45e                	sd	s7,8(sp)
    80003e44:	e062                	sd	s8,0(sp)
    80003e46:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e48:	00954783          	lbu	a5,9(a0)
    80003e4c:	10078663          	beqz	a5,80003f58 <filewrite+0x128>
    80003e50:	892a                	mv	s2,a0
    80003e52:	8aae                	mv	s5,a1
    80003e54:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e56:	411c                	lw	a5,0(a0)
    80003e58:	4705                	li	a4,1
    80003e5a:	02e78263          	beq	a5,a4,80003e7e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e5e:	470d                	li	a4,3
    80003e60:	02e78663          	beq	a5,a4,80003e8c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e64:	4709                	li	a4,2
    80003e66:	0ee79163          	bne	a5,a4,80003f48 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e6a:	0ac05d63          	blez	a2,80003f24 <filewrite+0xf4>
    int i = 0;
    80003e6e:	4981                	li	s3,0
    80003e70:	6b05                	lui	s6,0x1
    80003e72:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e76:	6b85                	lui	s7,0x1
    80003e78:	c00b8b9b          	addiw	s7,s7,-1024
    80003e7c:	a861                	j	80003f14 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e7e:	6908                	ld	a0,16(a0)
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	22e080e7          	jalr	558(ra) # 800040ae <pipewrite>
    80003e88:	8a2a                	mv	s4,a0
    80003e8a:	a045                	j	80003f2a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e8c:	02451783          	lh	a5,36(a0)
    80003e90:	03079693          	slli	a3,a5,0x30
    80003e94:	92c1                	srli	a3,a3,0x30
    80003e96:	4725                	li	a4,9
    80003e98:	0cd76263          	bltu	a4,a3,80003f5c <filewrite+0x12c>
    80003e9c:	0792                	slli	a5,a5,0x4
    80003e9e:	00015717          	auipc	a4,0x15
    80003ea2:	d9a70713          	addi	a4,a4,-614 # 80018c38 <devsw>
    80003ea6:	97ba                	add	a5,a5,a4
    80003ea8:	679c                	ld	a5,8(a5)
    80003eaa:	cbdd                	beqz	a5,80003f60 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003eac:	4505                	li	a0,1
    80003eae:	9782                	jalr	a5
    80003eb0:	8a2a                	mv	s4,a0
    80003eb2:	a8a5                	j	80003f2a <filewrite+0xfa>
    80003eb4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	8b0080e7          	jalr	-1872(ra) # 80003768 <begin_op>
      ilock(f->ip);
    80003ec0:	01893503          	ld	a0,24(s2)
    80003ec4:	fffff097          	auipc	ra,0xfffff
    80003ec8:	ee2080e7          	jalr	-286(ra) # 80002da6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ecc:	8762                	mv	a4,s8
    80003ece:	02092683          	lw	a3,32(s2)
    80003ed2:	01598633          	add	a2,s3,s5
    80003ed6:	4585                	li	a1,1
    80003ed8:	01893503          	ld	a0,24(s2)
    80003edc:	fffff097          	auipc	ra,0xfffff
    80003ee0:	276080e7          	jalr	630(ra) # 80003152 <writei>
    80003ee4:	84aa                	mv	s1,a0
    80003ee6:	00a05763          	blez	a0,80003ef4 <filewrite+0xc4>
        f->off += r;
    80003eea:	02092783          	lw	a5,32(s2)
    80003eee:	9fa9                	addw	a5,a5,a0
    80003ef0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ef4:	01893503          	ld	a0,24(s2)
    80003ef8:	fffff097          	auipc	ra,0xfffff
    80003efc:	f70080e7          	jalr	-144(ra) # 80002e68 <iunlock>
      end_op();
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	8e8080e7          	jalr	-1816(ra) # 800037e8 <end_op>

      if(r != n1){
    80003f08:	009c1f63          	bne	s8,s1,80003f26 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f0c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f10:	0149db63          	bge	s3,s4,80003f26 <filewrite+0xf6>
      int n1 = n - i;
    80003f14:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f18:	84be                	mv	s1,a5
    80003f1a:	2781                	sext.w	a5,a5
    80003f1c:	f8fb5ce3          	bge	s6,a5,80003eb4 <filewrite+0x84>
    80003f20:	84de                	mv	s1,s7
    80003f22:	bf49                	j	80003eb4 <filewrite+0x84>
    int i = 0;
    80003f24:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f26:	013a1f63          	bne	s4,s3,80003f44 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f2a:	8552                	mv	a0,s4
    80003f2c:	60a6                	ld	ra,72(sp)
    80003f2e:	6406                	ld	s0,64(sp)
    80003f30:	74e2                	ld	s1,56(sp)
    80003f32:	7942                	ld	s2,48(sp)
    80003f34:	79a2                	ld	s3,40(sp)
    80003f36:	7a02                	ld	s4,32(sp)
    80003f38:	6ae2                	ld	s5,24(sp)
    80003f3a:	6b42                	ld	s6,16(sp)
    80003f3c:	6ba2                	ld	s7,8(sp)
    80003f3e:	6c02                	ld	s8,0(sp)
    80003f40:	6161                	addi	sp,sp,80
    80003f42:	8082                	ret
    ret = (i == n ? n : -1);
    80003f44:	5a7d                	li	s4,-1
    80003f46:	b7d5                	j	80003f2a <filewrite+0xfa>
    panic("filewrite");
    80003f48:	00004517          	auipc	a0,0x4
    80003f4c:	7a850513          	addi	a0,a0,1960 # 800086f0 <syscalls+0x2b0>
    80003f50:	00002097          	auipc	ra,0x2
    80003f54:	f72080e7          	jalr	-142(ra) # 80005ec2 <panic>
    return -1;
    80003f58:	5a7d                	li	s4,-1
    80003f5a:	bfc1                	j	80003f2a <filewrite+0xfa>
      return -1;
    80003f5c:	5a7d                	li	s4,-1
    80003f5e:	b7f1                	j	80003f2a <filewrite+0xfa>
    80003f60:	5a7d                	li	s4,-1
    80003f62:	b7e1                	j	80003f2a <filewrite+0xfa>

0000000080003f64 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f64:	7179                	addi	sp,sp,-48
    80003f66:	f406                	sd	ra,40(sp)
    80003f68:	f022                	sd	s0,32(sp)
    80003f6a:	ec26                	sd	s1,24(sp)
    80003f6c:	e84a                	sd	s2,16(sp)
    80003f6e:	e44e                	sd	s3,8(sp)
    80003f70:	e052                	sd	s4,0(sp)
    80003f72:	1800                	addi	s0,sp,48
    80003f74:	84aa                	mv	s1,a0
    80003f76:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f78:	0005b023          	sd	zero,0(a1)
    80003f7c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	bf8080e7          	jalr	-1032(ra) # 80003b78 <filealloc>
    80003f88:	e088                	sd	a0,0(s1)
    80003f8a:	c551                	beqz	a0,80004016 <pipealloc+0xb2>
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	bec080e7          	jalr	-1044(ra) # 80003b78 <filealloc>
    80003f94:	00aa3023          	sd	a0,0(s4)
    80003f98:	c92d                	beqz	a0,8000400a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f9a:	ffffc097          	auipc	ra,0xffffc
    80003f9e:	17e080e7          	jalr	382(ra) # 80000118 <kalloc>
    80003fa2:	892a                	mv	s2,a0
    80003fa4:	c125                	beqz	a0,80004004 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fa6:	4985                	li	s3,1
    80003fa8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fac:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fb0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fb4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fb8:	00004597          	auipc	a1,0x4
    80003fbc:	74858593          	addi	a1,a1,1864 # 80008700 <syscalls+0x2c0>
    80003fc0:	00002097          	auipc	ra,0x2
    80003fc4:	3bc080e7          	jalr	956(ra) # 8000637c <initlock>
  (*f0)->type = FD_PIPE;
    80003fc8:	609c                	ld	a5,0(s1)
    80003fca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fce:	609c                	ld	a5,0(s1)
    80003fd0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fd4:	609c                	ld	a5,0(s1)
    80003fd6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fda:	609c                	ld	a5,0(s1)
    80003fdc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fe0:	000a3783          	ld	a5,0(s4)
    80003fe4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fe8:	000a3783          	ld	a5,0(s4)
    80003fec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ff0:	000a3783          	ld	a5,0(s4)
    80003ff4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ff8:	000a3783          	ld	a5,0(s4)
    80003ffc:	0127b823          	sd	s2,16(a5)
  return 0;
    80004000:	4501                	li	a0,0
    80004002:	a025                	j	8000402a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004004:	6088                	ld	a0,0(s1)
    80004006:	e501                	bnez	a0,8000400e <pipealloc+0xaa>
    80004008:	a039                	j	80004016 <pipealloc+0xb2>
    8000400a:	6088                	ld	a0,0(s1)
    8000400c:	c51d                	beqz	a0,8000403a <pipealloc+0xd6>
    fileclose(*f0);
    8000400e:	00000097          	auipc	ra,0x0
    80004012:	c26080e7          	jalr	-986(ra) # 80003c34 <fileclose>
  if(*f1)
    80004016:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000401a:	557d                	li	a0,-1
  if(*f1)
    8000401c:	c799                	beqz	a5,8000402a <pipealloc+0xc6>
    fileclose(*f1);
    8000401e:	853e                	mv	a0,a5
    80004020:	00000097          	auipc	ra,0x0
    80004024:	c14080e7          	jalr	-1004(ra) # 80003c34 <fileclose>
  return -1;
    80004028:	557d                	li	a0,-1
}
    8000402a:	70a2                	ld	ra,40(sp)
    8000402c:	7402                	ld	s0,32(sp)
    8000402e:	64e2                	ld	s1,24(sp)
    80004030:	6942                	ld	s2,16(sp)
    80004032:	69a2                	ld	s3,8(sp)
    80004034:	6a02                	ld	s4,0(sp)
    80004036:	6145                	addi	sp,sp,48
    80004038:	8082                	ret
  return -1;
    8000403a:	557d                	li	a0,-1
    8000403c:	b7fd                	j	8000402a <pipealloc+0xc6>

000000008000403e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000403e:	1101                	addi	sp,sp,-32
    80004040:	ec06                	sd	ra,24(sp)
    80004042:	e822                	sd	s0,16(sp)
    80004044:	e426                	sd	s1,8(sp)
    80004046:	e04a                	sd	s2,0(sp)
    80004048:	1000                	addi	s0,sp,32
    8000404a:	84aa                	mv	s1,a0
    8000404c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000404e:	00002097          	auipc	ra,0x2
    80004052:	3be080e7          	jalr	958(ra) # 8000640c <acquire>
  if(writable){
    80004056:	02090d63          	beqz	s2,80004090 <pipeclose+0x52>
    pi->writeopen = 0;
    8000405a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000405e:	21848513          	addi	a0,s1,536
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	704080e7          	jalr	1796(ra) # 80001766 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000406a:	2204b783          	ld	a5,544(s1)
    8000406e:	eb95                	bnez	a5,800040a2 <pipeclose+0x64>
    release(&pi->lock);
    80004070:	8526                	mv	a0,s1
    80004072:	00002097          	auipc	ra,0x2
    80004076:	44e080e7          	jalr	1102(ra) # 800064c0 <release>
    kfree((char*)pi);
    8000407a:	8526                	mv	a0,s1
    8000407c:	ffffc097          	auipc	ra,0xffffc
    80004080:	fa0080e7          	jalr	-96(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004084:	60e2                	ld	ra,24(sp)
    80004086:	6442                	ld	s0,16(sp)
    80004088:	64a2                	ld	s1,8(sp)
    8000408a:	6902                	ld	s2,0(sp)
    8000408c:	6105                	addi	sp,sp,32
    8000408e:	8082                	ret
    pi->readopen = 0;
    80004090:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004094:	21c48513          	addi	a0,s1,540
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	6ce080e7          	jalr	1742(ra) # 80001766 <wakeup>
    800040a0:	b7e9                	j	8000406a <pipeclose+0x2c>
    release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	41c080e7          	jalr	1052(ra) # 800064c0 <release>
}
    800040ac:	bfe1                	j	80004084 <pipeclose+0x46>

00000000800040ae <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040ae:	7159                	addi	sp,sp,-112
    800040b0:	f486                	sd	ra,104(sp)
    800040b2:	f0a2                	sd	s0,96(sp)
    800040b4:	eca6                	sd	s1,88(sp)
    800040b6:	e8ca                	sd	s2,80(sp)
    800040b8:	e4ce                	sd	s3,72(sp)
    800040ba:	e0d2                	sd	s4,64(sp)
    800040bc:	fc56                	sd	s5,56(sp)
    800040be:	f85a                	sd	s6,48(sp)
    800040c0:	f45e                	sd	s7,40(sp)
    800040c2:	f062                	sd	s8,32(sp)
    800040c4:	ec66                	sd	s9,24(sp)
    800040c6:	1880                	addi	s0,sp,112
    800040c8:	84aa                	mv	s1,a0
    800040ca:	8aae                	mv	s5,a1
    800040cc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	ed6080e7          	jalr	-298(ra) # 80000fa4 <myproc>
    800040d6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040d8:	8526                	mv	a0,s1
    800040da:	00002097          	auipc	ra,0x2
    800040de:	332080e7          	jalr	818(ra) # 8000640c <acquire>
  while(i < n){
    800040e2:	0d405463          	blez	s4,800041aa <pipewrite+0xfc>
    800040e6:	8ba6                	mv	s7,s1
  int i = 0;
    800040e8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ea:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040ec:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040f0:	21c48c13          	addi	s8,s1,540
    800040f4:	a08d                	j	80004156 <pipewrite+0xa8>
      release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	3c8080e7          	jalr	968(ra) # 800064c0 <release>
      return -1;
    80004100:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004102:	854a                	mv	a0,s2
    80004104:	70a6                	ld	ra,104(sp)
    80004106:	7406                	ld	s0,96(sp)
    80004108:	64e6                	ld	s1,88(sp)
    8000410a:	6946                	ld	s2,80(sp)
    8000410c:	69a6                	ld	s3,72(sp)
    8000410e:	6a06                	ld	s4,64(sp)
    80004110:	7ae2                	ld	s5,56(sp)
    80004112:	7b42                	ld	s6,48(sp)
    80004114:	7ba2                	ld	s7,40(sp)
    80004116:	7c02                	ld	s8,32(sp)
    80004118:	6ce2                	ld	s9,24(sp)
    8000411a:	6165                	addi	sp,sp,112
    8000411c:	8082                	ret
      wakeup(&pi->nread);
    8000411e:	8566                	mv	a0,s9
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	646080e7          	jalr	1606(ra) # 80001766 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004128:	85de                	mv	a1,s7
    8000412a:	8562                	mv	a0,s8
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	5d6080e7          	jalr	1494(ra) # 80001702 <sleep>
    80004134:	a839                	j	80004152 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004136:	21c4a783          	lw	a5,540(s1)
    8000413a:	0017871b          	addiw	a4,a5,1
    8000413e:	20e4ae23          	sw	a4,540(s1)
    80004142:	1ff7f793          	andi	a5,a5,511
    80004146:	97a6                	add	a5,a5,s1
    80004148:	f9f44703          	lbu	a4,-97(s0)
    8000414c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004150:	2905                	addiw	s2,s2,1
  while(i < n){
    80004152:	05495063          	bge	s2,s4,80004192 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004156:	2204a783          	lw	a5,544(s1)
    8000415a:	dfd1                	beqz	a5,800040f6 <pipewrite+0x48>
    8000415c:	854e                	mv	a0,s3
    8000415e:	ffffe097          	auipc	ra,0xffffe
    80004162:	84c080e7          	jalr	-1972(ra) # 800019aa <killed>
    80004166:	f941                	bnez	a0,800040f6 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004168:	2184a783          	lw	a5,536(s1)
    8000416c:	21c4a703          	lw	a4,540(s1)
    80004170:	2007879b          	addiw	a5,a5,512
    80004174:	faf705e3          	beq	a4,a5,8000411e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004178:	4685                	li	a3,1
    8000417a:	01590633          	add	a2,s2,s5
    8000417e:	f9f40593          	addi	a1,s0,-97
    80004182:	0509b503          	ld	a0,80(s3)
    80004186:	ffffd097          	auipc	ra,0xffffd
    8000418a:	a74080e7          	jalr	-1420(ra) # 80000bfa <copyin>
    8000418e:	fb6514e3          	bne	a0,s6,80004136 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004192:	21848513          	addi	a0,s1,536
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	5d0080e7          	jalr	1488(ra) # 80001766 <wakeup>
  release(&pi->lock);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	320080e7          	jalr	800(ra) # 800064c0 <release>
  return i;
    800041a8:	bfa9                	j	80004102 <pipewrite+0x54>
  int i = 0;
    800041aa:	4901                	li	s2,0
    800041ac:	b7dd                	j	80004192 <pipewrite+0xe4>

00000000800041ae <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041ae:	715d                	addi	sp,sp,-80
    800041b0:	e486                	sd	ra,72(sp)
    800041b2:	e0a2                	sd	s0,64(sp)
    800041b4:	fc26                	sd	s1,56(sp)
    800041b6:	f84a                	sd	s2,48(sp)
    800041b8:	f44e                	sd	s3,40(sp)
    800041ba:	f052                	sd	s4,32(sp)
    800041bc:	ec56                	sd	s5,24(sp)
    800041be:	e85a                	sd	s6,16(sp)
    800041c0:	0880                	addi	s0,sp,80
    800041c2:	84aa                	mv	s1,a0
    800041c4:	892e                	mv	s2,a1
    800041c6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041c8:	ffffd097          	auipc	ra,0xffffd
    800041cc:	ddc080e7          	jalr	-548(ra) # 80000fa4 <myproc>
    800041d0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041d2:	8b26                	mv	s6,s1
    800041d4:	8526                	mv	a0,s1
    800041d6:	00002097          	auipc	ra,0x2
    800041da:	236080e7          	jalr	566(ra) # 8000640c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041de:	2184a703          	lw	a4,536(s1)
    800041e2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041e6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ea:	02f71763          	bne	a4,a5,80004218 <piperead+0x6a>
    800041ee:	2244a783          	lw	a5,548(s1)
    800041f2:	c39d                	beqz	a5,80004218 <piperead+0x6a>
    if(killed(pr)){
    800041f4:	8552                	mv	a0,s4
    800041f6:	ffffd097          	auipc	ra,0xffffd
    800041fa:	7b4080e7          	jalr	1972(ra) # 800019aa <killed>
    800041fe:	e941                	bnez	a0,8000428e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004200:	85da                	mv	a1,s6
    80004202:	854e                	mv	a0,s3
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	4fe080e7          	jalr	1278(ra) # 80001702 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000420c:	2184a703          	lw	a4,536(s1)
    80004210:	21c4a783          	lw	a5,540(s1)
    80004214:	fcf70de3          	beq	a4,a5,800041ee <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004218:	09505263          	blez	s5,8000429c <piperead+0xee>
    8000421c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000421e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004220:	2184a783          	lw	a5,536(s1)
    80004224:	21c4a703          	lw	a4,540(s1)
    80004228:	02f70d63          	beq	a4,a5,80004262 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000422c:	0017871b          	addiw	a4,a5,1
    80004230:	20e4ac23          	sw	a4,536(s1)
    80004234:	1ff7f793          	andi	a5,a5,511
    80004238:	97a6                	add	a5,a5,s1
    8000423a:	0187c783          	lbu	a5,24(a5)
    8000423e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004242:	4685                	li	a3,1
    80004244:	fbf40613          	addi	a2,s0,-65
    80004248:	85ca                	mv	a1,s2
    8000424a:	050a3503          	ld	a0,80(s4)
    8000424e:	ffffd097          	auipc	ra,0xffffd
    80004252:	8ec080e7          	jalr	-1812(ra) # 80000b3a <copyout>
    80004256:	01650663          	beq	a0,s6,80004262 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000425a:	2985                	addiw	s3,s3,1
    8000425c:	0905                	addi	s2,s2,1
    8000425e:	fd3a91e3          	bne	s5,s3,80004220 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004262:	21c48513          	addi	a0,s1,540
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	500080e7          	jalr	1280(ra) # 80001766 <wakeup>
  release(&pi->lock);
    8000426e:	8526                	mv	a0,s1
    80004270:	00002097          	auipc	ra,0x2
    80004274:	250080e7          	jalr	592(ra) # 800064c0 <release>
  return i;
}
    80004278:	854e                	mv	a0,s3
    8000427a:	60a6                	ld	ra,72(sp)
    8000427c:	6406                	ld	s0,64(sp)
    8000427e:	74e2                	ld	s1,56(sp)
    80004280:	7942                	ld	s2,48(sp)
    80004282:	79a2                	ld	s3,40(sp)
    80004284:	7a02                	ld	s4,32(sp)
    80004286:	6ae2                	ld	s5,24(sp)
    80004288:	6b42                	ld	s6,16(sp)
    8000428a:	6161                	addi	sp,sp,80
    8000428c:	8082                	ret
      release(&pi->lock);
    8000428e:	8526                	mv	a0,s1
    80004290:	00002097          	auipc	ra,0x2
    80004294:	230080e7          	jalr	560(ra) # 800064c0 <release>
      return -1;
    80004298:	59fd                	li	s3,-1
    8000429a:	bff9                	j	80004278 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000429c:	4981                	li	s3,0
    8000429e:	b7d1                	j	80004262 <piperead+0xb4>

00000000800042a0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800042a0:	1141                	addi	sp,sp,-16
    800042a2:	e422                	sd	s0,8(sp)
    800042a4:	0800                	addi	s0,sp,16
    800042a6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800042a8:	8905                	andi	a0,a0,1
    800042aa:	c111                	beqz	a0,800042ae <flags2perm+0xe>
      perm = PTE_X;
    800042ac:	4521                	li	a0,8
    if(flags & 0x2)
    800042ae:	8b89                	andi	a5,a5,2
    800042b0:	c399                	beqz	a5,800042b6 <flags2perm+0x16>
      perm |= PTE_W;
    800042b2:	00456513          	ori	a0,a0,4
    return perm;
}
    800042b6:	6422                	ld	s0,8(sp)
    800042b8:	0141                	addi	sp,sp,16
    800042ba:	8082                	ret

00000000800042bc <exec>:

int
exec(char *path, char **argv)
{
    800042bc:	df010113          	addi	sp,sp,-528
    800042c0:	20113423          	sd	ra,520(sp)
    800042c4:	20813023          	sd	s0,512(sp)
    800042c8:	ffa6                	sd	s1,504(sp)
    800042ca:	fbca                	sd	s2,496(sp)
    800042cc:	f7ce                	sd	s3,488(sp)
    800042ce:	f3d2                	sd	s4,480(sp)
    800042d0:	efd6                	sd	s5,472(sp)
    800042d2:	ebda                	sd	s6,464(sp)
    800042d4:	e7de                	sd	s7,456(sp)
    800042d6:	e3e2                	sd	s8,448(sp)
    800042d8:	ff66                	sd	s9,440(sp)
    800042da:	fb6a                	sd	s10,432(sp)
    800042dc:	f76e                	sd	s11,424(sp)
    800042de:	0c00                	addi	s0,sp,528
    800042e0:	84aa                	mv	s1,a0
    800042e2:	dea43c23          	sd	a0,-520(s0)
    800042e6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	cba080e7          	jalr	-838(ra) # 80000fa4 <myproc>
    800042f2:	892a                	mv	s2,a0

  begin_op();
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	474080e7          	jalr	1140(ra) # 80003768 <begin_op>

  if((ip = namei(path)) == 0){
    800042fc:	8526                	mv	a0,s1
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	24e080e7          	jalr	590(ra) # 8000354c <namei>
    80004306:	c92d                	beqz	a0,80004378 <exec+0xbc>
    80004308:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	a9c080e7          	jalr	-1380(ra) # 80002da6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004312:	04000713          	li	a4,64
    80004316:	4681                	li	a3,0
    80004318:	e5040613          	addi	a2,s0,-432
    8000431c:	4581                	li	a1,0
    8000431e:	8526                	mv	a0,s1
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	d3a080e7          	jalr	-710(ra) # 8000305a <readi>
    80004328:	04000793          	li	a5,64
    8000432c:	00f51a63          	bne	a0,a5,80004340 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004330:	e5042703          	lw	a4,-432(s0)
    80004334:	464c47b7          	lui	a5,0x464c4
    80004338:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000433c:	04f70463          	beq	a4,a5,80004384 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004340:	8526                	mv	a0,s1
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	cc6080e7          	jalr	-826(ra) # 80003008 <iunlockput>
    end_op();
    8000434a:	fffff097          	auipc	ra,0xfffff
    8000434e:	49e080e7          	jalr	1182(ra) # 800037e8 <end_op>
  }
  return -1;
    80004352:	557d                	li	a0,-1
}
    80004354:	20813083          	ld	ra,520(sp)
    80004358:	20013403          	ld	s0,512(sp)
    8000435c:	74fe                	ld	s1,504(sp)
    8000435e:	795e                	ld	s2,496(sp)
    80004360:	79be                	ld	s3,488(sp)
    80004362:	7a1e                	ld	s4,480(sp)
    80004364:	6afe                	ld	s5,472(sp)
    80004366:	6b5e                	ld	s6,464(sp)
    80004368:	6bbe                	ld	s7,456(sp)
    8000436a:	6c1e                	ld	s8,448(sp)
    8000436c:	7cfa                	ld	s9,440(sp)
    8000436e:	7d5a                	ld	s10,432(sp)
    80004370:	7dba                	ld	s11,424(sp)
    80004372:	21010113          	addi	sp,sp,528
    80004376:	8082                	ret
    end_op();
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	470080e7          	jalr	1136(ra) # 800037e8 <end_op>
    return -1;
    80004380:	557d                	li	a0,-1
    80004382:	bfc9                	j	80004354 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004384:	854a                	mv	a0,s2
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	ce6080e7          	jalr	-794(ra) # 8000106c <proc_pagetable>
    8000438e:	8baa                	mv	s7,a0
    80004390:	d945                	beqz	a0,80004340 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004392:	e7042983          	lw	s3,-400(s0)
    80004396:	e8845783          	lhu	a5,-376(s0)
    8000439a:	c7ad                	beqz	a5,80004404 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000439c:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000439e:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800043a0:	6c85                	lui	s9,0x1
    800043a2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043a6:	def43823          	sd	a5,-528(s0)
    800043aa:	a4a9                	j	800045f4 <exec+0x338>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043ac:	00004517          	auipc	a0,0x4
    800043b0:	35c50513          	addi	a0,a0,860 # 80008708 <syscalls+0x2c8>
    800043b4:	00002097          	auipc	ra,0x2
    800043b8:	b0e080e7          	jalr	-1266(ra) # 80005ec2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043bc:	8756                	mv	a4,s5
    800043be:	012d86bb          	addw	a3,s11,s2
    800043c2:	4581                	li	a1,0
    800043c4:	8526                	mv	a0,s1
    800043c6:	fffff097          	auipc	ra,0xfffff
    800043ca:	c94080e7          	jalr	-876(ra) # 8000305a <readi>
    800043ce:	2501                	sext.w	a0,a0
    800043d0:	1caa9663          	bne	s5,a0,8000459c <exec+0x2e0>
  for(i = 0; i < sz; i += PGSIZE){
    800043d4:	6785                	lui	a5,0x1
    800043d6:	0127893b          	addw	s2,a5,s2
    800043da:	77fd                	lui	a5,0xfffff
    800043dc:	01478a3b          	addw	s4,a5,s4
    800043e0:	21897163          	bgeu	s2,s8,800045e2 <exec+0x326>
    pa = walkaddr(pagetable, va + i);
    800043e4:	02091593          	slli	a1,s2,0x20
    800043e8:	9181                	srli	a1,a1,0x20
    800043ea:	95ea                	add	a1,a1,s10
    800043ec:	855e                	mv	a0,s7
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	11c080e7          	jalr	284(ra) # 8000050a <walkaddr>
    800043f6:	862a                	mv	a2,a0
    if(pa == 0)
    800043f8:	d955                	beqz	a0,800043ac <exec+0xf0>
      n = PGSIZE;
    800043fa:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043fc:	fd9a70e3          	bgeu	s4,s9,800043bc <exec+0x100>
      n = sz - i;
    80004400:	8ad2                	mv	s5,s4
    80004402:	bf6d                	j	800043bc <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004404:	4a01                	li	s4,0
  iunlockput(ip);
    80004406:	8526                	mv	a0,s1
    80004408:	fffff097          	auipc	ra,0xfffff
    8000440c:	c00080e7          	jalr	-1024(ra) # 80003008 <iunlockput>
  end_op();
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	3d8080e7          	jalr	984(ra) # 800037e8 <end_op>
  p = myproc();
    80004418:	ffffd097          	auipc	ra,0xffffd
    8000441c:	b8c080e7          	jalr	-1140(ra) # 80000fa4 <myproc>
    80004420:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004422:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004426:	6785                	lui	a5,0x1
    80004428:	17fd                	addi	a5,a5,-1
    8000442a:	9a3e                	add	s4,s4,a5
    8000442c:	757d                	lui	a0,0xfffff
    8000442e:	00aa77b3          	and	a5,s4,a0
    80004432:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004436:	4691                	li	a3,4
    80004438:	6609                	lui	a2,0x2
    8000443a:	963e                	add	a2,a2,a5
    8000443c:	85be                	mv	a1,a5
    8000443e:	855e                	mv	a0,s7
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	4a2080e7          	jalr	1186(ra) # 800008e2 <uvmalloc>
    80004448:	8b2a                	mv	s6,a0
  ip = 0;
    8000444a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000444c:	14050863          	beqz	a0,8000459c <exec+0x2e0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004450:	75f9                	lui	a1,0xffffe
    80004452:	95aa                	add	a1,a1,a0
    80004454:	855e                	mv	a0,s7
    80004456:	ffffc097          	auipc	ra,0xffffc
    8000445a:	6b2080e7          	jalr	1714(ra) # 80000b08 <uvmclear>
  stackbase = sp - PGSIZE;
    8000445e:	7c7d                	lui	s8,0xfffff
    80004460:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004462:	e0043783          	ld	a5,-512(s0)
    80004466:	6388                	ld	a0,0(a5)
    80004468:	c535                	beqz	a0,800044d4 <exec+0x218>
    8000446a:	e9040993          	addi	s3,s0,-368
    8000446e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004472:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004474:	ffffc097          	auipc	ra,0xffffc
    80004478:	e88080e7          	jalr	-376(ra) # 800002fc <strlen>
    8000447c:	2505                	addiw	a0,a0,1
    8000447e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004482:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004486:	15896263          	bltu	s2,s8,800045ca <exec+0x30e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000448a:	e0043d83          	ld	s11,-512(s0)
    8000448e:	000dba03          	ld	s4,0(s11)
    80004492:	8552                	mv	a0,s4
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	e68080e7          	jalr	-408(ra) # 800002fc <strlen>
    8000449c:	0015069b          	addiw	a3,a0,1
    800044a0:	8652                	mv	a2,s4
    800044a2:	85ca                	mv	a1,s2
    800044a4:	855e                	mv	a0,s7
    800044a6:	ffffc097          	auipc	ra,0xffffc
    800044aa:	694080e7          	jalr	1684(ra) # 80000b3a <copyout>
    800044ae:	12054263          	bltz	a0,800045d2 <exec+0x316>
    ustack[argc] = sp;
    800044b2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044b6:	0485                	addi	s1,s1,1
    800044b8:	008d8793          	addi	a5,s11,8
    800044bc:	e0f43023          	sd	a5,-512(s0)
    800044c0:	008db503          	ld	a0,8(s11)
    800044c4:	c911                	beqz	a0,800044d8 <exec+0x21c>
    if(argc >= MAXARG)
    800044c6:	09a1                	addi	s3,s3,8
    800044c8:	fb3c96e3          	bne	s9,s3,80004474 <exec+0x1b8>
  sz = sz1;
    800044cc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044d0:	4481                	li	s1,0
    800044d2:	a0e9                	j	8000459c <exec+0x2e0>
  sp = sz;
    800044d4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044d6:	4481                	li	s1,0
  ustack[argc] = 0;
    800044d8:	00349793          	slli	a5,s1,0x3
    800044dc:	f9040713          	addi	a4,s0,-112
    800044e0:	97ba                	add	a5,a5,a4
    800044e2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044e6:	00148693          	addi	a3,s1,1
    800044ea:	068e                	slli	a3,a3,0x3
    800044ec:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044f0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044f4:	01897663          	bgeu	s2,s8,80004500 <exec+0x244>
  sz = sz1;
    800044f8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044fc:	4481                	li	s1,0
    800044fe:	a879                	j	8000459c <exec+0x2e0>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004500:	e9040613          	addi	a2,s0,-368
    80004504:	85ca                	mv	a1,s2
    80004506:	855e                	mv	a0,s7
    80004508:	ffffc097          	auipc	ra,0xffffc
    8000450c:	632080e7          	jalr	1586(ra) # 80000b3a <copyout>
    80004510:	0c054563          	bltz	a0,800045da <exec+0x31e>
  p->trapframe->a1 = sp;
    80004514:	058ab783          	ld	a5,88(s5)
    80004518:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000451c:	df843783          	ld	a5,-520(s0)
    80004520:	0007c703          	lbu	a4,0(a5)
    80004524:	cf11                	beqz	a4,80004540 <exec+0x284>
    80004526:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004528:	02f00693          	li	a3,47
    8000452c:	a039                	j	8000453a <exec+0x27e>
      last = s+1;
    8000452e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004532:	0785                	addi	a5,a5,1
    80004534:	fff7c703          	lbu	a4,-1(a5)
    80004538:	c701                	beqz	a4,80004540 <exec+0x284>
    if(*s == '/')
    8000453a:	fed71ce3          	bne	a4,a3,80004532 <exec+0x276>
    8000453e:	bfc5                	j	8000452e <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004540:	4641                	li	a2,16
    80004542:	df843583          	ld	a1,-520(s0)
    80004546:	158a8513          	addi	a0,s5,344
    8000454a:	ffffc097          	auipc	ra,0xffffc
    8000454e:	d80080e7          	jalr	-640(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004552:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004556:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000455a:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000455e:	058ab783          	ld	a5,88(s5)
    80004562:	e6843703          	ld	a4,-408(s0)
    80004566:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004568:	058ab783          	ld	a5,88(s5)
    8000456c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004570:	85ea                	mv	a1,s10
    80004572:	ffffd097          	auipc	ra,0xffffd
    80004576:	bf0080e7          	jalr	-1040(ra) # 80001162 <proc_freepagetable>
  if(p->pid==1)
    8000457a:	030aa703          	lw	a4,48(s5)
    8000457e:	4785                	li	a5,1
    80004580:	00f70563          	beq	a4,a5,8000458a <exec+0x2ce>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004584:	0004851b          	sext.w	a0,s1
    80004588:	b3f1                	j	80004354 <exec+0x98>
    vmprint(p->pagetable); // new
    8000458a:	050ab503          	ld	a0,80(s5)
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	7ac080e7          	jalr	1964(ra) # 80000d3a <vmprint>
    80004596:	b7fd                	j	80004584 <exec+0x2c8>
    80004598:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000459c:	e0843583          	ld	a1,-504(s0)
    800045a0:	855e                	mv	a0,s7
    800045a2:	ffffd097          	auipc	ra,0xffffd
    800045a6:	bc0080e7          	jalr	-1088(ra) # 80001162 <proc_freepagetable>
  if(ip){
    800045aa:	d8049be3          	bnez	s1,80004340 <exec+0x84>
  return -1;
    800045ae:	557d                	li	a0,-1
    800045b0:	b355                	j	80004354 <exec+0x98>
    800045b2:	e1443423          	sd	s4,-504(s0)
    800045b6:	b7dd                	j	8000459c <exec+0x2e0>
    800045b8:	e1443423          	sd	s4,-504(s0)
    800045bc:	b7c5                	j	8000459c <exec+0x2e0>
    800045be:	e1443423          	sd	s4,-504(s0)
    800045c2:	bfe9                	j	8000459c <exec+0x2e0>
    800045c4:	e1443423          	sd	s4,-504(s0)
    800045c8:	bfd1                	j	8000459c <exec+0x2e0>
  sz = sz1;
    800045ca:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045ce:	4481                	li	s1,0
    800045d0:	b7f1                	j	8000459c <exec+0x2e0>
  sz = sz1;
    800045d2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045d6:	4481                	li	s1,0
    800045d8:	b7d1                	j	8000459c <exec+0x2e0>
  sz = sz1;
    800045da:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045de:	4481                	li	s1,0
    800045e0:	bf75                	j	8000459c <exec+0x2e0>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045e2:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045e6:	2b05                	addiw	s6,s6,1
    800045e8:	0389899b          	addiw	s3,s3,56
    800045ec:	e8845783          	lhu	a5,-376(s0)
    800045f0:	e0fb5be3          	bge	s6,a5,80004406 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045f4:	2981                	sext.w	s3,s3
    800045f6:	03800713          	li	a4,56
    800045fa:	86ce                	mv	a3,s3
    800045fc:	e1840613          	addi	a2,s0,-488
    80004600:	4581                	li	a1,0
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	a56080e7          	jalr	-1450(ra) # 8000305a <readi>
    8000460c:	03800793          	li	a5,56
    80004610:	f8f514e3          	bne	a0,a5,80004598 <exec+0x2dc>
    if(ph.type != ELF_PROG_LOAD)
    80004614:	e1842783          	lw	a5,-488(s0)
    80004618:	4705                	li	a4,1
    8000461a:	fce796e3          	bne	a5,a4,800045e6 <exec+0x32a>
    if(ph.memsz < ph.filesz)
    8000461e:	e4043903          	ld	s2,-448(s0)
    80004622:	e3843783          	ld	a5,-456(s0)
    80004626:	f8f966e3          	bltu	s2,a5,800045b2 <exec+0x2f6>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000462a:	e2843783          	ld	a5,-472(s0)
    8000462e:	993e                	add	s2,s2,a5
    80004630:	f8f964e3          	bltu	s2,a5,800045b8 <exec+0x2fc>
    if(ph.vaddr % PGSIZE != 0)
    80004634:	df043703          	ld	a4,-528(s0)
    80004638:	8ff9                	and	a5,a5,a4
    8000463a:	f3d1                	bnez	a5,800045be <exec+0x302>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000463c:	e1c42503          	lw	a0,-484(s0)
    80004640:	00000097          	auipc	ra,0x0
    80004644:	c60080e7          	jalr	-928(ra) # 800042a0 <flags2perm>
    80004648:	86aa                	mv	a3,a0
    8000464a:	864a                	mv	a2,s2
    8000464c:	85d2                	mv	a1,s4
    8000464e:	855e                	mv	a0,s7
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	292080e7          	jalr	658(ra) # 800008e2 <uvmalloc>
    80004658:	e0a43423          	sd	a0,-504(s0)
    8000465c:	d525                	beqz	a0,800045c4 <exec+0x308>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000465e:	e2843d03          	ld	s10,-472(s0)
    80004662:	e2042d83          	lw	s11,-480(s0)
    80004666:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000466a:	f60c0ce3          	beqz	s8,800045e2 <exec+0x326>
    8000466e:	8a62                	mv	s4,s8
    80004670:	4901                	li	s2,0
    80004672:	bb8d                	j	800043e4 <exec+0x128>

0000000080004674 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004674:	7179                	addi	sp,sp,-48
    80004676:	f406                	sd	ra,40(sp)
    80004678:	f022                	sd	s0,32(sp)
    8000467a:	ec26                	sd	s1,24(sp)
    8000467c:	e84a                	sd	s2,16(sp)
    8000467e:	1800                	addi	s0,sp,48
    80004680:	892e                	mv	s2,a1
    80004682:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004684:	fdc40593          	addi	a1,s0,-36
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	ae6080e7          	jalr	-1306(ra) # 8000216e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004690:	fdc42703          	lw	a4,-36(s0)
    80004694:	47bd                	li	a5,15
    80004696:	02e7eb63          	bltu	a5,a4,800046cc <argfd+0x58>
    8000469a:	ffffd097          	auipc	ra,0xffffd
    8000469e:	90a080e7          	jalr	-1782(ra) # 80000fa4 <myproc>
    800046a2:	fdc42703          	lw	a4,-36(s0)
    800046a6:	01a70793          	addi	a5,a4,26
    800046aa:	078e                	slli	a5,a5,0x3
    800046ac:	953e                	add	a0,a0,a5
    800046ae:	611c                	ld	a5,0(a0)
    800046b0:	c385                	beqz	a5,800046d0 <argfd+0x5c>
    return -1;
  if(pfd)
    800046b2:	00090463          	beqz	s2,800046ba <argfd+0x46>
    *pfd = fd;
    800046b6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046ba:	4501                	li	a0,0
  if(pf)
    800046bc:	c091                	beqz	s1,800046c0 <argfd+0x4c>
    *pf = f;
    800046be:	e09c                	sd	a5,0(s1)
}
    800046c0:	70a2                	ld	ra,40(sp)
    800046c2:	7402                	ld	s0,32(sp)
    800046c4:	64e2                	ld	s1,24(sp)
    800046c6:	6942                	ld	s2,16(sp)
    800046c8:	6145                	addi	sp,sp,48
    800046ca:	8082                	ret
    return -1;
    800046cc:	557d                	li	a0,-1
    800046ce:	bfcd                	j	800046c0 <argfd+0x4c>
    800046d0:	557d                	li	a0,-1
    800046d2:	b7fd                	j	800046c0 <argfd+0x4c>

00000000800046d4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046d4:	1101                	addi	sp,sp,-32
    800046d6:	ec06                	sd	ra,24(sp)
    800046d8:	e822                	sd	s0,16(sp)
    800046da:	e426                	sd	s1,8(sp)
    800046dc:	1000                	addi	s0,sp,32
    800046de:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046e0:	ffffd097          	auipc	ra,0xffffd
    800046e4:	8c4080e7          	jalr	-1852(ra) # 80000fa4 <myproc>
    800046e8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046ea:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd0c0>
    800046ee:	4501                	li	a0,0
    800046f0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046f2:	6398                	ld	a4,0(a5)
    800046f4:	cb19                	beqz	a4,8000470a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046f6:	2505                	addiw	a0,a0,1
    800046f8:	07a1                	addi	a5,a5,8
    800046fa:	fed51ce3          	bne	a0,a3,800046f2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046fe:	557d                	li	a0,-1
}
    80004700:	60e2                	ld	ra,24(sp)
    80004702:	6442                	ld	s0,16(sp)
    80004704:	64a2                	ld	s1,8(sp)
    80004706:	6105                	addi	sp,sp,32
    80004708:	8082                	ret
      p->ofile[fd] = f;
    8000470a:	01a50793          	addi	a5,a0,26
    8000470e:	078e                	slli	a5,a5,0x3
    80004710:	963e                	add	a2,a2,a5
    80004712:	e204                	sd	s1,0(a2)
      return fd;
    80004714:	b7f5                	j	80004700 <fdalloc+0x2c>

0000000080004716 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004716:	715d                	addi	sp,sp,-80
    80004718:	e486                	sd	ra,72(sp)
    8000471a:	e0a2                	sd	s0,64(sp)
    8000471c:	fc26                	sd	s1,56(sp)
    8000471e:	f84a                	sd	s2,48(sp)
    80004720:	f44e                	sd	s3,40(sp)
    80004722:	f052                	sd	s4,32(sp)
    80004724:	ec56                	sd	s5,24(sp)
    80004726:	e85a                	sd	s6,16(sp)
    80004728:	0880                	addi	s0,sp,80
    8000472a:	8b2e                	mv	s6,a1
    8000472c:	89b2                	mv	s3,a2
    8000472e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004730:	fb040593          	addi	a1,s0,-80
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	e36080e7          	jalr	-458(ra) # 8000356a <nameiparent>
    8000473c:	84aa                	mv	s1,a0
    8000473e:	16050063          	beqz	a0,8000489e <create+0x188>
    return 0;

  ilock(dp);
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	664080e7          	jalr	1636(ra) # 80002da6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000474a:	4601                	li	a2,0
    8000474c:	fb040593          	addi	a1,s0,-80
    80004750:	8526                	mv	a0,s1
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	b38080e7          	jalr	-1224(ra) # 8000328a <dirlookup>
    8000475a:	8aaa                	mv	s5,a0
    8000475c:	c931                	beqz	a0,800047b0 <create+0x9a>
    iunlockput(dp);
    8000475e:	8526                	mv	a0,s1
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	8a8080e7          	jalr	-1880(ra) # 80003008 <iunlockput>
    ilock(ip);
    80004768:	8556                	mv	a0,s5
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	63c080e7          	jalr	1596(ra) # 80002da6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004772:	000b059b          	sext.w	a1,s6
    80004776:	4789                	li	a5,2
    80004778:	02f59563          	bne	a1,a5,800047a2 <create+0x8c>
    8000477c:	044ad783          	lhu	a5,68(s5)
    80004780:	37f9                	addiw	a5,a5,-2
    80004782:	17c2                	slli	a5,a5,0x30
    80004784:	93c1                	srli	a5,a5,0x30
    80004786:	4705                	li	a4,1
    80004788:	00f76d63          	bltu	a4,a5,800047a2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000478c:	8556                	mv	a0,s5
    8000478e:	60a6                	ld	ra,72(sp)
    80004790:	6406                	ld	s0,64(sp)
    80004792:	74e2                	ld	s1,56(sp)
    80004794:	7942                	ld	s2,48(sp)
    80004796:	79a2                	ld	s3,40(sp)
    80004798:	7a02                	ld	s4,32(sp)
    8000479a:	6ae2                	ld	s5,24(sp)
    8000479c:	6b42                	ld	s6,16(sp)
    8000479e:	6161                	addi	sp,sp,80
    800047a0:	8082                	ret
    iunlockput(ip);
    800047a2:	8556                	mv	a0,s5
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	864080e7          	jalr	-1948(ra) # 80003008 <iunlockput>
    return 0;
    800047ac:	4a81                	li	s5,0
    800047ae:	bff9                	j	8000478c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800047b0:	85da                	mv	a1,s6
    800047b2:	4088                	lw	a0,0(s1)
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	456080e7          	jalr	1110(ra) # 80002c0a <ialloc>
    800047bc:	8a2a                	mv	s4,a0
    800047be:	c921                	beqz	a0,8000480e <create+0xf8>
  ilock(ip);
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	5e6080e7          	jalr	1510(ra) # 80002da6 <ilock>
  ip->major = major;
    800047c8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047cc:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047d0:	4785                	li	a5,1
    800047d2:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800047d6:	8552                	mv	a0,s4
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	504080e7          	jalr	1284(ra) # 80002cdc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047e0:	000b059b          	sext.w	a1,s6
    800047e4:	4785                	li	a5,1
    800047e6:	02f58b63          	beq	a1,a5,8000481c <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ea:	004a2603          	lw	a2,4(s4)
    800047ee:	fb040593          	addi	a1,s0,-80
    800047f2:	8526                	mv	a0,s1
    800047f4:	fffff097          	auipc	ra,0xfffff
    800047f8:	ca6080e7          	jalr	-858(ra) # 8000349a <dirlink>
    800047fc:	06054f63          	bltz	a0,8000487a <create+0x164>
  iunlockput(dp);
    80004800:	8526                	mv	a0,s1
    80004802:	fffff097          	auipc	ra,0xfffff
    80004806:	806080e7          	jalr	-2042(ra) # 80003008 <iunlockput>
  return ip;
    8000480a:	8ad2                	mv	s5,s4
    8000480c:	b741                	j	8000478c <create+0x76>
    iunlockput(dp);
    8000480e:	8526                	mv	a0,s1
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	7f8080e7          	jalr	2040(ra) # 80003008 <iunlockput>
    return 0;
    80004818:	8ad2                	mv	s5,s4
    8000481a:	bf8d                	j	8000478c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000481c:	004a2603          	lw	a2,4(s4)
    80004820:	00004597          	auipc	a1,0x4
    80004824:	f0858593          	addi	a1,a1,-248 # 80008728 <syscalls+0x2e8>
    80004828:	8552                	mv	a0,s4
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	c70080e7          	jalr	-912(ra) # 8000349a <dirlink>
    80004832:	04054463          	bltz	a0,8000487a <create+0x164>
    80004836:	40d0                	lw	a2,4(s1)
    80004838:	00004597          	auipc	a1,0x4
    8000483c:	97058593          	addi	a1,a1,-1680 # 800081a8 <etext+0x1a8>
    80004840:	8552                	mv	a0,s4
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	c58080e7          	jalr	-936(ra) # 8000349a <dirlink>
    8000484a:	02054863          	bltz	a0,8000487a <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000484e:	004a2603          	lw	a2,4(s4)
    80004852:	fb040593          	addi	a1,s0,-80
    80004856:	8526                	mv	a0,s1
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	c42080e7          	jalr	-958(ra) # 8000349a <dirlink>
    80004860:	00054d63          	bltz	a0,8000487a <create+0x164>
    dp->nlink++;  // for ".."
    80004864:	04a4d783          	lhu	a5,74(s1)
    80004868:	2785                	addiw	a5,a5,1
    8000486a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000486e:	8526                	mv	a0,s1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	46c080e7          	jalr	1132(ra) # 80002cdc <iupdate>
    80004878:	b761                	j	80004800 <create+0xea>
  ip->nlink = 0;
    8000487a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000487e:	8552                	mv	a0,s4
    80004880:	ffffe097          	auipc	ra,0xffffe
    80004884:	45c080e7          	jalr	1116(ra) # 80002cdc <iupdate>
  iunlockput(ip);
    80004888:	8552                	mv	a0,s4
    8000488a:	ffffe097          	auipc	ra,0xffffe
    8000488e:	77e080e7          	jalr	1918(ra) # 80003008 <iunlockput>
  iunlockput(dp);
    80004892:	8526                	mv	a0,s1
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	774080e7          	jalr	1908(ra) # 80003008 <iunlockput>
  return 0;
    8000489c:	bdc5                	j	8000478c <create+0x76>
    return 0;
    8000489e:	8aaa                	mv	s5,a0
    800048a0:	b5f5                	j	8000478c <create+0x76>

00000000800048a2 <sys_dup>:
{
    800048a2:	7179                	addi	sp,sp,-48
    800048a4:	f406                	sd	ra,40(sp)
    800048a6:	f022                	sd	s0,32(sp)
    800048a8:	ec26                	sd	s1,24(sp)
    800048aa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048ac:	fd840613          	addi	a2,s0,-40
    800048b0:	4581                	li	a1,0
    800048b2:	4501                	li	a0,0
    800048b4:	00000097          	auipc	ra,0x0
    800048b8:	dc0080e7          	jalr	-576(ra) # 80004674 <argfd>
    return -1;
    800048bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048be:	02054363          	bltz	a0,800048e4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048c2:	fd843503          	ld	a0,-40(s0)
    800048c6:	00000097          	auipc	ra,0x0
    800048ca:	e0e080e7          	jalr	-498(ra) # 800046d4 <fdalloc>
    800048ce:	84aa                	mv	s1,a0
    return -1;
    800048d0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048d2:	00054963          	bltz	a0,800048e4 <sys_dup+0x42>
  filedup(f);
    800048d6:	fd843503          	ld	a0,-40(s0)
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	308080e7          	jalr	776(ra) # 80003be2 <filedup>
  return fd;
    800048e2:	87a6                	mv	a5,s1
}
    800048e4:	853e                	mv	a0,a5
    800048e6:	70a2                	ld	ra,40(sp)
    800048e8:	7402                	ld	s0,32(sp)
    800048ea:	64e2                	ld	s1,24(sp)
    800048ec:	6145                	addi	sp,sp,48
    800048ee:	8082                	ret

00000000800048f0 <sys_read>:
{
    800048f0:	7179                	addi	sp,sp,-48
    800048f2:	f406                	sd	ra,40(sp)
    800048f4:	f022                	sd	s0,32(sp)
    800048f6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048f8:	fd840593          	addi	a1,s0,-40
    800048fc:	4505                	li	a0,1
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	890080e7          	jalr	-1904(ra) # 8000218e <argaddr>
  argint(2, &n);
    80004906:	fe440593          	addi	a1,s0,-28
    8000490a:	4509                	li	a0,2
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	862080e7          	jalr	-1950(ra) # 8000216e <argint>
  if(argfd(0, 0, &f) < 0)
    80004914:	fe840613          	addi	a2,s0,-24
    80004918:	4581                	li	a1,0
    8000491a:	4501                	li	a0,0
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	d58080e7          	jalr	-680(ra) # 80004674 <argfd>
    80004924:	87aa                	mv	a5,a0
    return -1;
    80004926:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004928:	0007cc63          	bltz	a5,80004940 <sys_read+0x50>
  return fileread(f, p, n);
    8000492c:	fe442603          	lw	a2,-28(s0)
    80004930:	fd843583          	ld	a1,-40(s0)
    80004934:	fe843503          	ld	a0,-24(s0)
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	436080e7          	jalr	1078(ra) # 80003d6e <fileread>
}
    80004940:	70a2                	ld	ra,40(sp)
    80004942:	7402                	ld	s0,32(sp)
    80004944:	6145                	addi	sp,sp,48
    80004946:	8082                	ret

0000000080004948 <sys_write>:
{
    80004948:	7179                	addi	sp,sp,-48
    8000494a:	f406                	sd	ra,40(sp)
    8000494c:	f022                	sd	s0,32(sp)
    8000494e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004950:	fd840593          	addi	a1,s0,-40
    80004954:	4505                	li	a0,1
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	838080e7          	jalr	-1992(ra) # 8000218e <argaddr>
  argint(2, &n);
    8000495e:	fe440593          	addi	a1,s0,-28
    80004962:	4509                	li	a0,2
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	80a080e7          	jalr	-2038(ra) # 8000216e <argint>
  if(argfd(0, 0, &f) < 0)
    8000496c:	fe840613          	addi	a2,s0,-24
    80004970:	4581                	li	a1,0
    80004972:	4501                	li	a0,0
    80004974:	00000097          	auipc	ra,0x0
    80004978:	d00080e7          	jalr	-768(ra) # 80004674 <argfd>
    8000497c:	87aa                	mv	a5,a0
    return -1;
    8000497e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004980:	0007cc63          	bltz	a5,80004998 <sys_write+0x50>
  return filewrite(f, p, n);
    80004984:	fe442603          	lw	a2,-28(s0)
    80004988:	fd843583          	ld	a1,-40(s0)
    8000498c:	fe843503          	ld	a0,-24(s0)
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	4a0080e7          	jalr	1184(ra) # 80003e30 <filewrite>
}
    80004998:	70a2                	ld	ra,40(sp)
    8000499a:	7402                	ld	s0,32(sp)
    8000499c:	6145                	addi	sp,sp,48
    8000499e:	8082                	ret

00000000800049a0 <sys_close>:
{
    800049a0:	1101                	addi	sp,sp,-32
    800049a2:	ec06                	sd	ra,24(sp)
    800049a4:	e822                	sd	s0,16(sp)
    800049a6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a8:	fe040613          	addi	a2,s0,-32
    800049ac:	fec40593          	addi	a1,s0,-20
    800049b0:	4501                	li	a0,0
    800049b2:	00000097          	auipc	ra,0x0
    800049b6:	cc2080e7          	jalr	-830(ra) # 80004674 <argfd>
    return -1;
    800049ba:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049bc:	02054463          	bltz	a0,800049e4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049c0:	ffffc097          	auipc	ra,0xffffc
    800049c4:	5e4080e7          	jalr	1508(ra) # 80000fa4 <myproc>
    800049c8:	fec42783          	lw	a5,-20(s0)
    800049cc:	07e9                	addi	a5,a5,26
    800049ce:	078e                	slli	a5,a5,0x3
    800049d0:	97aa                	add	a5,a5,a0
    800049d2:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049d6:	fe043503          	ld	a0,-32(s0)
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	25a080e7          	jalr	602(ra) # 80003c34 <fileclose>
  return 0;
    800049e2:	4781                	li	a5,0
}
    800049e4:	853e                	mv	a0,a5
    800049e6:	60e2                	ld	ra,24(sp)
    800049e8:	6442                	ld	s0,16(sp)
    800049ea:	6105                	addi	sp,sp,32
    800049ec:	8082                	ret

00000000800049ee <sys_fstat>:
{
    800049ee:	1101                	addi	sp,sp,-32
    800049f0:	ec06                	sd	ra,24(sp)
    800049f2:	e822                	sd	s0,16(sp)
    800049f4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049f6:	fe040593          	addi	a1,s0,-32
    800049fa:	4505                	li	a0,1
    800049fc:	ffffd097          	auipc	ra,0xffffd
    80004a00:	792080e7          	jalr	1938(ra) # 8000218e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a04:	fe840613          	addi	a2,s0,-24
    80004a08:	4581                	li	a1,0
    80004a0a:	4501                	li	a0,0
    80004a0c:	00000097          	auipc	ra,0x0
    80004a10:	c68080e7          	jalr	-920(ra) # 80004674 <argfd>
    80004a14:	87aa                	mv	a5,a0
    return -1;
    80004a16:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a18:	0007ca63          	bltz	a5,80004a2c <sys_fstat+0x3e>
  return filestat(f, st);
    80004a1c:	fe043583          	ld	a1,-32(s0)
    80004a20:	fe843503          	ld	a0,-24(s0)
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	2d8080e7          	jalr	728(ra) # 80003cfc <filestat>
}
    80004a2c:	60e2                	ld	ra,24(sp)
    80004a2e:	6442                	ld	s0,16(sp)
    80004a30:	6105                	addi	sp,sp,32
    80004a32:	8082                	ret

0000000080004a34 <sys_link>:
{
    80004a34:	7169                	addi	sp,sp,-304
    80004a36:	f606                	sd	ra,296(sp)
    80004a38:	f222                	sd	s0,288(sp)
    80004a3a:	ee26                	sd	s1,280(sp)
    80004a3c:	ea4a                	sd	s2,272(sp)
    80004a3e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a40:	08000613          	li	a2,128
    80004a44:	ed040593          	addi	a1,s0,-304
    80004a48:	4501                	li	a0,0
    80004a4a:	ffffd097          	auipc	ra,0xffffd
    80004a4e:	764080e7          	jalr	1892(ra) # 800021ae <argstr>
    return -1;
    80004a52:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a54:	10054e63          	bltz	a0,80004b70 <sys_link+0x13c>
    80004a58:	08000613          	li	a2,128
    80004a5c:	f5040593          	addi	a1,s0,-176
    80004a60:	4505                	li	a0,1
    80004a62:	ffffd097          	auipc	ra,0xffffd
    80004a66:	74c080e7          	jalr	1868(ra) # 800021ae <argstr>
    return -1;
    80004a6a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a6c:	10054263          	bltz	a0,80004b70 <sys_link+0x13c>
  begin_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	cf8080e7          	jalr	-776(ra) # 80003768 <begin_op>
  if((ip = namei(old)) == 0){
    80004a78:	ed040513          	addi	a0,s0,-304
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	ad0080e7          	jalr	-1328(ra) # 8000354c <namei>
    80004a84:	84aa                	mv	s1,a0
    80004a86:	c551                	beqz	a0,80004b12 <sys_link+0xde>
  ilock(ip);
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	31e080e7          	jalr	798(ra) # 80002da6 <ilock>
  if(ip->type == T_DIR){
    80004a90:	04449703          	lh	a4,68(s1)
    80004a94:	4785                	li	a5,1
    80004a96:	08f70463          	beq	a4,a5,80004b1e <sys_link+0xea>
  ip->nlink++;
    80004a9a:	04a4d783          	lhu	a5,74(s1)
    80004a9e:	2785                	addiw	a5,a5,1
    80004aa0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	236080e7          	jalr	566(ra) # 80002cdc <iupdate>
  iunlock(ip);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	3b8080e7          	jalr	952(ra) # 80002e68 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ab8:	fd040593          	addi	a1,s0,-48
    80004abc:	f5040513          	addi	a0,s0,-176
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	aaa080e7          	jalr	-1366(ra) # 8000356a <nameiparent>
    80004ac8:	892a                	mv	s2,a0
    80004aca:	c935                	beqz	a0,80004b3e <sys_link+0x10a>
  ilock(dp);
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	2da080e7          	jalr	730(ra) # 80002da6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ad4:	00092703          	lw	a4,0(s2)
    80004ad8:	409c                	lw	a5,0(s1)
    80004ada:	04f71d63          	bne	a4,a5,80004b34 <sys_link+0x100>
    80004ade:	40d0                	lw	a2,4(s1)
    80004ae0:	fd040593          	addi	a1,s0,-48
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	9b4080e7          	jalr	-1612(ra) # 8000349a <dirlink>
    80004aee:	04054363          	bltz	a0,80004b34 <sys_link+0x100>
  iunlockput(dp);
    80004af2:	854a                	mv	a0,s2
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	514080e7          	jalr	1300(ra) # 80003008 <iunlockput>
  iput(ip);
    80004afc:	8526                	mv	a0,s1
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	462080e7          	jalr	1122(ra) # 80002f60 <iput>
  end_op();
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	ce2080e7          	jalr	-798(ra) # 800037e8 <end_op>
  return 0;
    80004b0e:	4781                	li	a5,0
    80004b10:	a085                	j	80004b70 <sys_link+0x13c>
    end_op();
    80004b12:	fffff097          	auipc	ra,0xfffff
    80004b16:	cd6080e7          	jalr	-810(ra) # 800037e8 <end_op>
    return -1;
    80004b1a:	57fd                	li	a5,-1
    80004b1c:	a891                	j	80004b70 <sys_link+0x13c>
    iunlockput(ip);
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	4e8080e7          	jalr	1256(ra) # 80003008 <iunlockput>
    end_op();
    80004b28:	fffff097          	auipc	ra,0xfffff
    80004b2c:	cc0080e7          	jalr	-832(ra) # 800037e8 <end_op>
    return -1;
    80004b30:	57fd                	li	a5,-1
    80004b32:	a83d                	j	80004b70 <sys_link+0x13c>
    iunlockput(dp);
    80004b34:	854a                	mv	a0,s2
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	4d2080e7          	jalr	1234(ra) # 80003008 <iunlockput>
  ilock(ip);
    80004b3e:	8526                	mv	a0,s1
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	266080e7          	jalr	614(ra) # 80002da6 <ilock>
  ip->nlink--;
    80004b48:	04a4d783          	lhu	a5,74(s1)
    80004b4c:	37fd                	addiw	a5,a5,-1
    80004b4e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	188080e7          	jalr	392(ra) # 80002cdc <iupdate>
  iunlockput(ip);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	4aa080e7          	jalr	1194(ra) # 80003008 <iunlockput>
  end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	c82080e7          	jalr	-894(ra) # 800037e8 <end_op>
  return -1;
    80004b6e:	57fd                	li	a5,-1
}
    80004b70:	853e                	mv	a0,a5
    80004b72:	70b2                	ld	ra,296(sp)
    80004b74:	7412                	ld	s0,288(sp)
    80004b76:	64f2                	ld	s1,280(sp)
    80004b78:	6952                	ld	s2,272(sp)
    80004b7a:	6155                	addi	sp,sp,304
    80004b7c:	8082                	ret

0000000080004b7e <sys_unlink>:
{
    80004b7e:	7151                	addi	sp,sp,-240
    80004b80:	f586                	sd	ra,232(sp)
    80004b82:	f1a2                	sd	s0,224(sp)
    80004b84:	eda6                	sd	s1,216(sp)
    80004b86:	e9ca                	sd	s2,208(sp)
    80004b88:	e5ce                	sd	s3,200(sp)
    80004b8a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b8c:	08000613          	li	a2,128
    80004b90:	f3040593          	addi	a1,s0,-208
    80004b94:	4501                	li	a0,0
    80004b96:	ffffd097          	auipc	ra,0xffffd
    80004b9a:	618080e7          	jalr	1560(ra) # 800021ae <argstr>
    80004b9e:	18054163          	bltz	a0,80004d20 <sys_unlink+0x1a2>
  begin_op();
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	bc6080e7          	jalr	-1082(ra) # 80003768 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004baa:	fb040593          	addi	a1,s0,-80
    80004bae:	f3040513          	addi	a0,s0,-208
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	9b8080e7          	jalr	-1608(ra) # 8000356a <nameiparent>
    80004bba:	84aa                	mv	s1,a0
    80004bbc:	c979                	beqz	a0,80004c92 <sys_unlink+0x114>
  ilock(dp);
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	1e8080e7          	jalr	488(ra) # 80002da6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bc6:	00004597          	auipc	a1,0x4
    80004bca:	b6258593          	addi	a1,a1,-1182 # 80008728 <syscalls+0x2e8>
    80004bce:	fb040513          	addi	a0,s0,-80
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	69e080e7          	jalr	1694(ra) # 80003270 <namecmp>
    80004bda:	14050a63          	beqz	a0,80004d2e <sys_unlink+0x1b0>
    80004bde:	00003597          	auipc	a1,0x3
    80004be2:	5ca58593          	addi	a1,a1,1482 # 800081a8 <etext+0x1a8>
    80004be6:	fb040513          	addi	a0,s0,-80
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	686080e7          	jalr	1670(ra) # 80003270 <namecmp>
    80004bf2:	12050e63          	beqz	a0,80004d2e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bf6:	f2c40613          	addi	a2,s0,-212
    80004bfa:	fb040593          	addi	a1,s0,-80
    80004bfe:	8526                	mv	a0,s1
    80004c00:	ffffe097          	auipc	ra,0xffffe
    80004c04:	68a080e7          	jalr	1674(ra) # 8000328a <dirlookup>
    80004c08:	892a                	mv	s2,a0
    80004c0a:	12050263          	beqz	a0,80004d2e <sys_unlink+0x1b0>
  ilock(ip);
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	198080e7          	jalr	408(ra) # 80002da6 <ilock>
  if(ip->nlink < 1)
    80004c16:	04a91783          	lh	a5,74(s2)
    80004c1a:	08f05263          	blez	a5,80004c9e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c1e:	04491703          	lh	a4,68(s2)
    80004c22:	4785                	li	a5,1
    80004c24:	08f70563          	beq	a4,a5,80004cae <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c28:	4641                	li	a2,16
    80004c2a:	4581                	li	a1,0
    80004c2c:	fc040513          	addi	a0,s0,-64
    80004c30:	ffffb097          	auipc	ra,0xffffb
    80004c34:	548080e7          	jalr	1352(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c38:	4741                	li	a4,16
    80004c3a:	f2c42683          	lw	a3,-212(s0)
    80004c3e:	fc040613          	addi	a2,s0,-64
    80004c42:	4581                	li	a1,0
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	50c080e7          	jalr	1292(ra) # 80003152 <writei>
    80004c4e:	47c1                	li	a5,16
    80004c50:	0af51563          	bne	a0,a5,80004cfa <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c54:	04491703          	lh	a4,68(s2)
    80004c58:	4785                	li	a5,1
    80004c5a:	0af70863          	beq	a4,a5,80004d0a <sys_unlink+0x18c>
  iunlockput(dp);
    80004c5e:	8526                	mv	a0,s1
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	3a8080e7          	jalr	936(ra) # 80003008 <iunlockput>
  ip->nlink--;
    80004c68:	04a95783          	lhu	a5,74(s2)
    80004c6c:	37fd                	addiw	a5,a5,-1
    80004c6e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c72:	854a                	mv	a0,s2
    80004c74:	ffffe097          	auipc	ra,0xffffe
    80004c78:	068080e7          	jalr	104(ra) # 80002cdc <iupdate>
  iunlockput(ip);
    80004c7c:	854a                	mv	a0,s2
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	38a080e7          	jalr	906(ra) # 80003008 <iunlockput>
  end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	b62080e7          	jalr	-1182(ra) # 800037e8 <end_op>
  return 0;
    80004c8e:	4501                	li	a0,0
    80004c90:	a84d                	j	80004d42 <sys_unlink+0x1c4>
    end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	b56080e7          	jalr	-1194(ra) # 800037e8 <end_op>
    return -1;
    80004c9a:	557d                	li	a0,-1
    80004c9c:	a05d                	j	80004d42 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c9e:	00004517          	auipc	a0,0x4
    80004ca2:	a9250513          	addi	a0,a0,-1390 # 80008730 <syscalls+0x2f0>
    80004ca6:	00001097          	auipc	ra,0x1
    80004caa:	21c080e7          	jalr	540(ra) # 80005ec2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cae:	04c92703          	lw	a4,76(s2)
    80004cb2:	02000793          	li	a5,32
    80004cb6:	f6e7f9e3          	bgeu	a5,a4,80004c28 <sys_unlink+0xaa>
    80004cba:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cbe:	4741                	li	a4,16
    80004cc0:	86ce                	mv	a3,s3
    80004cc2:	f1840613          	addi	a2,s0,-232
    80004cc6:	4581                	li	a1,0
    80004cc8:	854a                	mv	a0,s2
    80004cca:	ffffe097          	auipc	ra,0xffffe
    80004cce:	390080e7          	jalr	912(ra) # 8000305a <readi>
    80004cd2:	47c1                	li	a5,16
    80004cd4:	00f51b63          	bne	a0,a5,80004cea <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cd8:	f1845783          	lhu	a5,-232(s0)
    80004cdc:	e7a1                	bnez	a5,80004d24 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cde:	29c1                	addiw	s3,s3,16
    80004ce0:	04c92783          	lw	a5,76(s2)
    80004ce4:	fcf9ede3          	bltu	s3,a5,80004cbe <sys_unlink+0x140>
    80004ce8:	b781                	j	80004c28 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cea:	00004517          	auipc	a0,0x4
    80004cee:	a5e50513          	addi	a0,a0,-1442 # 80008748 <syscalls+0x308>
    80004cf2:	00001097          	auipc	ra,0x1
    80004cf6:	1d0080e7          	jalr	464(ra) # 80005ec2 <panic>
    panic("unlink: writei");
    80004cfa:	00004517          	auipc	a0,0x4
    80004cfe:	a6650513          	addi	a0,a0,-1434 # 80008760 <syscalls+0x320>
    80004d02:	00001097          	auipc	ra,0x1
    80004d06:	1c0080e7          	jalr	448(ra) # 80005ec2 <panic>
    dp->nlink--;
    80004d0a:	04a4d783          	lhu	a5,74(s1)
    80004d0e:	37fd                	addiw	a5,a5,-1
    80004d10:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d14:	8526                	mv	a0,s1
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	fc6080e7          	jalr	-58(ra) # 80002cdc <iupdate>
    80004d1e:	b781                	j	80004c5e <sys_unlink+0xe0>
    return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	a005                	j	80004d42 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d24:	854a                	mv	a0,s2
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	2e2080e7          	jalr	738(ra) # 80003008 <iunlockput>
  iunlockput(dp);
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	2d8080e7          	jalr	728(ra) # 80003008 <iunlockput>
  end_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	ab0080e7          	jalr	-1360(ra) # 800037e8 <end_op>
  return -1;
    80004d40:	557d                	li	a0,-1
}
    80004d42:	70ae                	ld	ra,232(sp)
    80004d44:	740e                	ld	s0,224(sp)
    80004d46:	64ee                	ld	s1,216(sp)
    80004d48:	694e                	ld	s2,208(sp)
    80004d4a:	69ae                	ld	s3,200(sp)
    80004d4c:	616d                	addi	sp,sp,240
    80004d4e:	8082                	ret

0000000080004d50 <sys_open>:

uint64
sys_open(void)
{
    80004d50:	7131                	addi	sp,sp,-192
    80004d52:	fd06                	sd	ra,184(sp)
    80004d54:	f922                	sd	s0,176(sp)
    80004d56:	f526                	sd	s1,168(sp)
    80004d58:	f14a                	sd	s2,160(sp)
    80004d5a:	ed4e                	sd	s3,152(sp)
    80004d5c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d5e:	f4c40593          	addi	a1,s0,-180
    80004d62:	4505                	li	a0,1
    80004d64:	ffffd097          	auipc	ra,0xffffd
    80004d68:	40a080e7          	jalr	1034(ra) # 8000216e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d6c:	08000613          	li	a2,128
    80004d70:	f5040593          	addi	a1,s0,-176
    80004d74:	4501                	li	a0,0
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	438080e7          	jalr	1080(ra) # 800021ae <argstr>
    80004d7e:	87aa                	mv	a5,a0
    return -1;
    80004d80:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d82:	0a07c963          	bltz	a5,80004e34 <sys_open+0xe4>

  begin_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	9e2080e7          	jalr	-1566(ra) # 80003768 <begin_op>

  if(omode & O_CREATE){
    80004d8e:	f4c42783          	lw	a5,-180(s0)
    80004d92:	2007f793          	andi	a5,a5,512
    80004d96:	cfc5                	beqz	a5,80004e4e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d98:	4681                	li	a3,0
    80004d9a:	4601                	li	a2,0
    80004d9c:	4589                	li	a1,2
    80004d9e:	f5040513          	addi	a0,s0,-176
    80004da2:	00000097          	auipc	ra,0x0
    80004da6:	974080e7          	jalr	-1676(ra) # 80004716 <create>
    80004daa:	84aa                	mv	s1,a0
    if(ip == 0){
    80004dac:	c959                	beqz	a0,80004e42 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dae:	04449703          	lh	a4,68(s1)
    80004db2:	478d                	li	a5,3
    80004db4:	00f71763          	bne	a4,a5,80004dc2 <sys_open+0x72>
    80004db8:	0464d703          	lhu	a4,70(s1)
    80004dbc:	47a5                	li	a5,9
    80004dbe:	0ce7ed63          	bltu	a5,a4,80004e98 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	db6080e7          	jalr	-586(ra) # 80003b78 <filealloc>
    80004dca:	89aa                	mv	s3,a0
    80004dcc:	10050363          	beqz	a0,80004ed2 <sys_open+0x182>
    80004dd0:	00000097          	auipc	ra,0x0
    80004dd4:	904080e7          	jalr	-1788(ra) # 800046d4 <fdalloc>
    80004dd8:	892a                	mv	s2,a0
    80004dda:	0e054763          	bltz	a0,80004ec8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dde:	04449703          	lh	a4,68(s1)
    80004de2:	478d                	li	a5,3
    80004de4:	0cf70563          	beq	a4,a5,80004eae <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004de8:	4789                	li	a5,2
    80004dea:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dee:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004df2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004df6:	f4c42783          	lw	a5,-180(s0)
    80004dfa:	0017c713          	xori	a4,a5,1
    80004dfe:	8b05                	andi	a4,a4,1
    80004e00:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e04:	0037f713          	andi	a4,a5,3
    80004e08:	00e03733          	snez	a4,a4
    80004e0c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e10:	4007f793          	andi	a5,a5,1024
    80004e14:	c791                	beqz	a5,80004e20 <sys_open+0xd0>
    80004e16:	04449703          	lh	a4,68(s1)
    80004e1a:	4789                	li	a5,2
    80004e1c:	0af70063          	beq	a4,a5,80004ebc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e20:	8526                	mv	a0,s1
    80004e22:	ffffe097          	auipc	ra,0xffffe
    80004e26:	046080e7          	jalr	70(ra) # 80002e68 <iunlock>
  end_op();
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	9be080e7          	jalr	-1602(ra) # 800037e8 <end_op>

  return fd;
    80004e32:	854a                	mv	a0,s2
}
    80004e34:	70ea                	ld	ra,184(sp)
    80004e36:	744a                	ld	s0,176(sp)
    80004e38:	74aa                	ld	s1,168(sp)
    80004e3a:	790a                	ld	s2,160(sp)
    80004e3c:	69ea                	ld	s3,152(sp)
    80004e3e:	6129                	addi	sp,sp,192
    80004e40:	8082                	ret
      end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	9a6080e7          	jalr	-1626(ra) # 800037e8 <end_op>
      return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	b7e5                	j	80004e34 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e4e:	f5040513          	addi	a0,s0,-176
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	6fa080e7          	jalr	1786(ra) # 8000354c <namei>
    80004e5a:	84aa                	mv	s1,a0
    80004e5c:	c905                	beqz	a0,80004e8c <sys_open+0x13c>
    ilock(ip);
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	f48080e7          	jalr	-184(ra) # 80002da6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e66:	04449703          	lh	a4,68(s1)
    80004e6a:	4785                	li	a5,1
    80004e6c:	f4f711e3          	bne	a4,a5,80004dae <sys_open+0x5e>
    80004e70:	f4c42783          	lw	a5,-180(s0)
    80004e74:	d7b9                	beqz	a5,80004dc2 <sys_open+0x72>
      iunlockput(ip);
    80004e76:	8526                	mv	a0,s1
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	190080e7          	jalr	400(ra) # 80003008 <iunlockput>
      end_op();
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	968080e7          	jalr	-1688(ra) # 800037e8 <end_op>
      return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	b76d                	j	80004e34 <sys_open+0xe4>
      end_op();
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	95c080e7          	jalr	-1700(ra) # 800037e8 <end_op>
      return -1;
    80004e94:	557d                	li	a0,-1
    80004e96:	bf79                	j	80004e34 <sys_open+0xe4>
    iunlockput(ip);
    80004e98:	8526                	mv	a0,s1
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	16e080e7          	jalr	366(ra) # 80003008 <iunlockput>
    end_op();
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	946080e7          	jalr	-1722(ra) # 800037e8 <end_op>
    return -1;
    80004eaa:	557d                	li	a0,-1
    80004eac:	b761                	j	80004e34 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004eae:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eb2:	04649783          	lh	a5,70(s1)
    80004eb6:	02f99223          	sh	a5,36(s3)
    80004eba:	bf25                	j	80004df2 <sys_open+0xa2>
    itrunc(ip);
    80004ebc:	8526                	mv	a0,s1
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	ff6080e7          	jalr	-10(ra) # 80002eb4 <itrunc>
    80004ec6:	bfa9                	j	80004e20 <sys_open+0xd0>
      fileclose(f);
    80004ec8:	854e                	mv	a0,s3
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	d6a080e7          	jalr	-662(ra) # 80003c34 <fileclose>
    iunlockput(ip);
    80004ed2:	8526                	mv	a0,s1
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	134080e7          	jalr	308(ra) # 80003008 <iunlockput>
    end_op();
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	90c080e7          	jalr	-1780(ra) # 800037e8 <end_op>
    return -1;
    80004ee4:	557d                	li	a0,-1
    80004ee6:	b7b9                	j	80004e34 <sys_open+0xe4>

0000000080004ee8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ee8:	7175                	addi	sp,sp,-144
    80004eea:	e506                	sd	ra,136(sp)
    80004eec:	e122                	sd	s0,128(sp)
    80004eee:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	878080e7          	jalr	-1928(ra) # 80003768 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ef8:	08000613          	li	a2,128
    80004efc:	f7040593          	addi	a1,s0,-144
    80004f00:	4501                	li	a0,0
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	2ac080e7          	jalr	684(ra) # 800021ae <argstr>
    80004f0a:	02054963          	bltz	a0,80004f3c <sys_mkdir+0x54>
    80004f0e:	4681                	li	a3,0
    80004f10:	4601                	li	a2,0
    80004f12:	4585                	li	a1,1
    80004f14:	f7040513          	addi	a0,s0,-144
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	7fe080e7          	jalr	2046(ra) # 80004716 <create>
    80004f20:	cd11                	beqz	a0,80004f3c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	0e6080e7          	jalr	230(ra) # 80003008 <iunlockput>
  end_op();
    80004f2a:	fffff097          	auipc	ra,0xfffff
    80004f2e:	8be080e7          	jalr	-1858(ra) # 800037e8 <end_op>
  return 0;
    80004f32:	4501                	li	a0,0
}
    80004f34:	60aa                	ld	ra,136(sp)
    80004f36:	640a                	ld	s0,128(sp)
    80004f38:	6149                	addi	sp,sp,144
    80004f3a:	8082                	ret
    end_op();
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	8ac080e7          	jalr	-1876(ra) # 800037e8 <end_op>
    return -1;
    80004f44:	557d                	li	a0,-1
    80004f46:	b7fd                	j	80004f34 <sys_mkdir+0x4c>

0000000080004f48 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f48:	7135                	addi	sp,sp,-160
    80004f4a:	ed06                	sd	ra,152(sp)
    80004f4c:	e922                	sd	s0,144(sp)
    80004f4e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	818080e7          	jalr	-2024(ra) # 80003768 <begin_op>
  argint(1, &major);
    80004f58:	f6c40593          	addi	a1,s0,-148
    80004f5c:	4505                	li	a0,1
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	210080e7          	jalr	528(ra) # 8000216e <argint>
  argint(2, &minor);
    80004f66:	f6840593          	addi	a1,s0,-152
    80004f6a:	4509                	li	a0,2
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	202080e7          	jalr	514(ra) # 8000216e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f74:	08000613          	li	a2,128
    80004f78:	f7040593          	addi	a1,s0,-144
    80004f7c:	4501                	li	a0,0
    80004f7e:	ffffd097          	auipc	ra,0xffffd
    80004f82:	230080e7          	jalr	560(ra) # 800021ae <argstr>
    80004f86:	02054b63          	bltz	a0,80004fbc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f8a:	f6841683          	lh	a3,-152(s0)
    80004f8e:	f6c41603          	lh	a2,-148(s0)
    80004f92:	458d                	li	a1,3
    80004f94:	f7040513          	addi	a0,s0,-144
    80004f98:	fffff097          	auipc	ra,0xfffff
    80004f9c:	77e080e7          	jalr	1918(ra) # 80004716 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fa0:	cd11                	beqz	a0,80004fbc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	066080e7          	jalr	102(ra) # 80003008 <iunlockput>
  end_op();
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	83e080e7          	jalr	-1986(ra) # 800037e8 <end_op>
  return 0;
    80004fb2:	4501                	li	a0,0
}
    80004fb4:	60ea                	ld	ra,152(sp)
    80004fb6:	644a                	ld	s0,144(sp)
    80004fb8:	610d                	addi	sp,sp,160
    80004fba:	8082                	ret
    end_op();
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	82c080e7          	jalr	-2004(ra) # 800037e8 <end_op>
    return -1;
    80004fc4:	557d                	li	a0,-1
    80004fc6:	b7fd                	j	80004fb4 <sys_mknod+0x6c>

0000000080004fc8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fc8:	7135                	addi	sp,sp,-160
    80004fca:	ed06                	sd	ra,152(sp)
    80004fcc:	e922                	sd	s0,144(sp)
    80004fce:	e526                	sd	s1,136(sp)
    80004fd0:	e14a                	sd	s2,128(sp)
    80004fd2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fd4:	ffffc097          	auipc	ra,0xffffc
    80004fd8:	fd0080e7          	jalr	-48(ra) # 80000fa4 <myproc>
    80004fdc:	892a                	mv	s2,a0
  
  begin_op();
    80004fde:	ffffe097          	auipc	ra,0xffffe
    80004fe2:	78a080e7          	jalr	1930(ra) # 80003768 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fe6:	08000613          	li	a2,128
    80004fea:	f6040593          	addi	a1,s0,-160
    80004fee:	4501                	li	a0,0
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	1be080e7          	jalr	446(ra) # 800021ae <argstr>
    80004ff8:	04054b63          	bltz	a0,8000504e <sys_chdir+0x86>
    80004ffc:	f6040513          	addi	a0,s0,-160
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	54c080e7          	jalr	1356(ra) # 8000354c <namei>
    80005008:	84aa                	mv	s1,a0
    8000500a:	c131                	beqz	a0,8000504e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000500c:	ffffe097          	auipc	ra,0xffffe
    80005010:	d9a080e7          	jalr	-614(ra) # 80002da6 <ilock>
  if(ip->type != T_DIR){
    80005014:	04449703          	lh	a4,68(s1)
    80005018:	4785                	li	a5,1
    8000501a:	04f71063          	bne	a4,a5,8000505a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000501e:	8526                	mv	a0,s1
    80005020:	ffffe097          	auipc	ra,0xffffe
    80005024:	e48080e7          	jalr	-440(ra) # 80002e68 <iunlock>
  iput(p->cwd);
    80005028:	15093503          	ld	a0,336(s2)
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	f34080e7          	jalr	-204(ra) # 80002f60 <iput>
  end_op();
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	7b4080e7          	jalr	1972(ra) # 800037e8 <end_op>
  p->cwd = ip;
    8000503c:	14993823          	sd	s1,336(s2)
  return 0;
    80005040:	4501                	li	a0,0
}
    80005042:	60ea                	ld	ra,152(sp)
    80005044:	644a                	ld	s0,144(sp)
    80005046:	64aa                	ld	s1,136(sp)
    80005048:	690a                	ld	s2,128(sp)
    8000504a:	610d                	addi	sp,sp,160
    8000504c:	8082                	ret
    end_op();
    8000504e:	ffffe097          	auipc	ra,0xffffe
    80005052:	79a080e7          	jalr	1946(ra) # 800037e8 <end_op>
    return -1;
    80005056:	557d                	li	a0,-1
    80005058:	b7ed                	j	80005042 <sys_chdir+0x7a>
    iunlockput(ip);
    8000505a:	8526                	mv	a0,s1
    8000505c:	ffffe097          	auipc	ra,0xffffe
    80005060:	fac080e7          	jalr	-84(ra) # 80003008 <iunlockput>
    end_op();
    80005064:	ffffe097          	auipc	ra,0xffffe
    80005068:	784080e7          	jalr	1924(ra) # 800037e8 <end_op>
    return -1;
    8000506c:	557d                	li	a0,-1
    8000506e:	bfd1                	j	80005042 <sys_chdir+0x7a>

0000000080005070 <sys_exec>:

uint64
sys_exec(void)
{
    80005070:	7145                	addi	sp,sp,-464
    80005072:	e786                	sd	ra,456(sp)
    80005074:	e3a2                	sd	s0,448(sp)
    80005076:	ff26                	sd	s1,440(sp)
    80005078:	fb4a                	sd	s2,432(sp)
    8000507a:	f74e                	sd	s3,424(sp)
    8000507c:	f352                	sd	s4,416(sp)
    8000507e:	ef56                	sd	s5,408(sp)
    80005080:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005082:	e3840593          	addi	a1,s0,-456
    80005086:	4505                	li	a0,1
    80005088:	ffffd097          	auipc	ra,0xffffd
    8000508c:	106080e7          	jalr	262(ra) # 8000218e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005090:	08000613          	li	a2,128
    80005094:	f4040593          	addi	a1,s0,-192
    80005098:	4501                	li	a0,0
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	114080e7          	jalr	276(ra) # 800021ae <argstr>
    800050a2:	87aa                	mv	a5,a0
    return -1;
    800050a4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800050a6:	0c07c263          	bltz	a5,8000516a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800050aa:	10000613          	li	a2,256
    800050ae:	4581                	li	a1,0
    800050b0:	e4040513          	addi	a0,s0,-448
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	0c4080e7          	jalr	196(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050bc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050c0:	89a6                	mv	s3,s1
    800050c2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050c4:	02000a13          	li	s4,32
    800050c8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050cc:	00391513          	slli	a0,s2,0x3
    800050d0:	e3040593          	addi	a1,s0,-464
    800050d4:	e3843783          	ld	a5,-456(s0)
    800050d8:	953e                	add	a0,a0,a5
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	ff6080e7          	jalr	-10(ra) # 800020d0 <fetchaddr>
    800050e2:	02054a63          	bltz	a0,80005116 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800050e6:	e3043783          	ld	a5,-464(s0)
    800050ea:	c3b9                	beqz	a5,80005130 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050ec:	ffffb097          	auipc	ra,0xffffb
    800050f0:	02c080e7          	jalr	44(ra) # 80000118 <kalloc>
    800050f4:	85aa                	mv	a1,a0
    800050f6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050fa:	cd11                	beqz	a0,80005116 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050fc:	6605                	lui	a2,0x1
    800050fe:	e3043503          	ld	a0,-464(s0)
    80005102:	ffffd097          	auipc	ra,0xffffd
    80005106:	020080e7          	jalr	32(ra) # 80002122 <fetchstr>
    8000510a:	00054663          	bltz	a0,80005116 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    8000510e:	0905                	addi	s2,s2,1
    80005110:	09a1                	addi	s3,s3,8
    80005112:	fb491be3          	bne	s2,s4,800050c8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005116:	10048913          	addi	s2,s1,256
    8000511a:	6088                	ld	a0,0(s1)
    8000511c:	c531                	beqz	a0,80005168 <sys_exec+0xf8>
    kfree(argv[i]);
    8000511e:	ffffb097          	auipc	ra,0xffffb
    80005122:	efe080e7          	jalr	-258(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005126:	04a1                	addi	s1,s1,8
    80005128:	ff2499e3          	bne	s1,s2,8000511a <sys_exec+0xaa>
  return -1;
    8000512c:	557d                	li	a0,-1
    8000512e:	a835                	j	8000516a <sys_exec+0xfa>
      argv[i] = 0;
    80005130:	0a8e                	slli	s5,s5,0x3
    80005132:	fc040793          	addi	a5,s0,-64
    80005136:	9abe                	add	s5,s5,a5
    80005138:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000513c:	e4040593          	addi	a1,s0,-448
    80005140:	f4040513          	addi	a0,s0,-192
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	178080e7          	jalr	376(ra) # 800042bc <exec>
    8000514c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514e:	10048993          	addi	s3,s1,256
    80005152:	6088                	ld	a0,0(s1)
    80005154:	c901                	beqz	a0,80005164 <sys_exec+0xf4>
    kfree(argv[i]);
    80005156:	ffffb097          	auipc	ra,0xffffb
    8000515a:	ec6080e7          	jalr	-314(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000515e:	04a1                	addi	s1,s1,8
    80005160:	ff3499e3          	bne	s1,s3,80005152 <sys_exec+0xe2>
  return ret;
    80005164:	854a                	mv	a0,s2
    80005166:	a011                	j	8000516a <sys_exec+0xfa>
  return -1;
    80005168:	557d                	li	a0,-1
}
    8000516a:	60be                	ld	ra,456(sp)
    8000516c:	641e                	ld	s0,448(sp)
    8000516e:	74fa                	ld	s1,440(sp)
    80005170:	795a                	ld	s2,432(sp)
    80005172:	79ba                	ld	s3,424(sp)
    80005174:	7a1a                	ld	s4,416(sp)
    80005176:	6afa                	ld	s5,408(sp)
    80005178:	6179                	addi	sp,sp,464
    8000517a:	8082                	ret

000000008000517c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000517c:	7139                	addi	sp,sp,-64
    8000517e:	fc06                	sd	ra,56(sp)
    80005180:	f822                	sd	s0,48(sp)
    80005182:	f426                	sd	s1,40(sp)
    80005184:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005186:	ffffc097          	auipc	ra,0xffffc
    8000518a:	e1e080e7          	jalr	-482(ra) # 80000fa4 <myproc>
    8000518e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005190:	fd840593          	addi	a1,s0,-40
    80005194:	4501                	li	a0,0
    80005196:	ffffd097          	auipc	ra,0xffffd
    8000519a:	ff8080e7          	jalr	-8(ra) # 8000218e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000519e:	fc840593          	addi	a1,s0,-56
    800051a2:	fd040513          	addi	a0,s0,-48
    800051a6:	fffff097          	auipc	ra,0xfffff
    800051aa:	dbe080e7          	jalr	-578(ra) # 80003f64 <pipealloc>
    return -1;
    800051ae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051b0:	0c054463          	bltz	a0,80005278 <sys_pipe+0xfc>
  fd0 = -1;
    800051b4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051b8:	fd043503          	ld	a0,-48(s0)
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	518080e7          	jalr	1304(ra) # 800046d4 <fdalloc>
    800051c4:	fca42223          	sw	a0,-60(s0)
    800051c8:	08054b63          	bltz	a0,8000525e <sys_pipe+0xe2>
    800051cc:	fc843503          	ld	a0,-56(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	504080e7          	jalr	1284(ra) # 800046d4 <fdalloc>
    800051d8:	fca42023          	sw	a0,-64(s0)
    800051dc:	06054863          	bltz	a0,8000524c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e0:	4691                	li	a3,4
    800051e2:	fc440613          	addi	a2,s0,-60
    800051e6:	fd843583          	ld	a1,-40(s0)
    800051ea:	68a8                	ld	a0,80(s1)
    800051ec:	ffffc097          	auipc	ra,0xffffc
    800051f0:	94e080e7          	jalr	-1714(ra) # 80000b3a <copyout>
    800051f4:	02054063          	bltz	a0,80005214 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051f8:	4691                	li	a3,4
    800051fa:	fc040613          	addi	a2,s0,-64
    800051fe:	fd843583          	ld	a1,-40(s0)
    80005202:	0591                	addi	a1,a1,4
    80005204:	68a8                	ld	a0,80(s1)
    80005206:	ffffc097          	auipc	ra,0xffffc
    8000520a:	934080e7          	jalr	-1740(ra) # 80000b3a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000520e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005210:	06055463          	bgez	a0,80005278 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005214:	fc442783          	lw	a5,-60(s0)
    80005218:	07e9                	addi	a5,a5,26
    8000521a:	078e                	slli	a5,a5,0x3
    8000521c:	97a6                	add	a5,a5,s1
    8000521e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005222:	fc042503          	lw	a0,-64(s0)
    80005226:	0569                	addi	a0,a0,26
    80005228:	050e                	slli	a0,a0,0x3
    8000522a:	94aa                	add	s1,s1,a0
    8000522c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005230:	fd043503          	ld	a0,-48(s0)
    80005234:	fffff097          	auipc	ra,0xfffff
    80005238:	a00080e7          	jalr	-1536(ra) # 80003c34 <fileclose>
    fileclose(wf);
    8000523c:	fc843503          	ld	a0,-56(s0)
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	9f4080e7          	jalr	-1548(ra) # 80003c34 <fileclose>
    return -1;
    80005248:	57fd                	li	a5,-1
    8000524a:	a03d                	j	80005278 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000524c:	fc442783          	lw	a5,-60(s0)
    80005250:	0007c763          	bltz	a5,8000525e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005254:	07e9                	addi	a5,a5,26
    80005256:	078e                	slli	a5,a5,0x3
    80005258:	94be                	add	s1,s1,a5
    8000525a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000525e:	fd043503          	ld	a0,-48(s0)
    80005262:	fffff097          	auipc	ra,0xfffff
    80005266:	9d2080e7          	jalr	-1582(ra) # 80003c34 <fileclose>
    fileclose(wf);
    8000526a:	fc843503          	ld	a0,-56(s0)
    8000526e:	fffff097          	auipc	ra,0xfffff
    80005272:	9c6080e7          	jalr	-1594(ra) # 80003c34 <fileclose>
    return -1;
    80005276:	57fd                	li	a5,-1
}
    80005278:	853e                	mv	a0,a5
    8000527a:	70e2                	ld	ra,56(sp)
    8000527c:	7442                	ld	s0,48(sp)
    8000527e:	74a2                	ld	s1,40(sp)
    80005280:	6121                	addi	sp,sp,64
    80005282:	8082                	ret
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	ccdfc0ef          	jal	ra,80001f9c <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005358:	c3d8                	sw	a4,4(a5)
}
    8000535a:	6422                	ld	s0,8(sp)
    8000535c:	0141                	addi	sp,sp,16
    8000535e:	8082                	ret

0000000080005360 <plicinithart>:

void
plicinithart(void)
{
    80005360:	1141                	addi	sp,sp,-16
    80005362:	e406                	sd	ra,8(sp)
    80005364:	e022                	sd	s0,0(sp)
    80005366:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	c10080e7          	jalr	-1008(ra) # 80000f78 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	slliw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	slliw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	953e                	add	a0,a0,a5
    8000538c:	00052023          	sw	zero,0(a0)
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	bd8080e7          	jalr	-1064(ra) # 80000f78 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a8:	00d5179b          	slliw	a5,a0,0xd
    800053ac:	0c201537          	lui	a0,0xc201
    800053b0:	953e                	add	a0,a0,a5
  return irq;
}
    800053b2:	4148                	lw	a0,4(a0)
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053bc:	1101                	addi	sp,sp,-32
    800053be:	ec06                	sd	ra,24(sp)
    800053c0:	e822                	sd	s0,16(sp)
    800053c2:	e426                	sd	s1,8(sp)
    800053c4:	1000                	addi	s0,sp,32
    800053c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	bb0080e7          	jalr	-1104(ra) # 80000f78 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d0:	00d5151b          	slliw	a0,a0,0xd
    800053d4:	0c2017b7          	lui	a5,0xc201
    800053d8:	97aa                	add	a5,a5,a0
    800053da:	c3c4                	sw	s1,4(a5)
}
    800053dc:	60e2                	ld	ra,24(sp)
    800053de:	6442                	ld	s0,16(sp)
    800053e0:	64a2                	ld	s1,8(sp)
    800053e2:	6105                	addi	sp,sp,32
    800053e4:	8082                	ret

00000000800053e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053e6:	1141                	addi	sp,sp,-16
    800053e8:	e406                	sd	ra,8(sp)
    800053ea:	e022                	sd	s0,0(sp)
    800053ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ee:	479d                	li	a5,7
    800053f0:	04a7cc63          	blt	a5,a0,80005448 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053f4:	00015797          	auipc	a5,0x15
    800053f8:	89c78793          	addi	a5,a5,-1892 # 80019c90 <disk>
    800053fc:	97aa                	add	a5,a5,a0
    800053fe:	0187c783          	lbu	a5,24(a5)
    80005402:	ebb9                	bnez	a5,80005458 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005404:	00451613          	slli	a2,a0,0x4
    80005408:	00015797          	auipc	a5,0x15
    8000540c:	88878793          	addi	a5,a5,-1912 # 80019c90 <disk>
    80005410:	6394                	ld	a3,0(a5)
    80005412:	96b2                	add	a3,a3,a2
    80005414:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005418:	6398                	ld	a4,0(a5)
    8000541a:	9732                	add	a4,a4,a2
    8000541c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005420:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005424:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005428:	953e                	add	a0,a0,a5
    8000542a:	4785                	li	a5,1
    8000542c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005430:	00015517          	auipc	a0,0x15
    80005434:	87850513          	addi	a0,a0,-1928 # 80019ca8 <disk+0x18>
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	32e080e7          	jalr	814(ra) # 80001766 <wakeup>
}
    80005440:	60a2                	ld	ra,8(sp)
    80005442:	6402                	ld	s0,0(sp)
    80005444:	0141                	addi	sp,sp,16
    80005446:	8082                	ret
    panic("free_desc 1");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	32850513          	addi	a0,a0,808 # 80008770 <syscalls+0x330>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	a72080e7          	jalr	-1422(ra) # 80005ec2 <panic>
    panic("free_desc 2");
    80005458:	00003517          	auipc	a0,0x3
    8000545c:	32850513          	addi	a0,a0,808 # 80008780 <syscalls+0x340>
    80005460:	00001097          	auipc	ra,0x1
    80005464:	a62080e7          	jalr	-1438(ra) # 80005ec2 <panic>

0000000080005468 <virtio_disk_init>:
{
    80005468:	1101                	addi	sp,sp,-32
    8000546a:	ec06                	sd	ra,24(sp)
    8000546c:	e822                	sd	s0,16(sp)
    8000546e:	e426                	sd	s1,8(sp)
    80005470:	e04a                	sd	s2,0(sp)
    80005472:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005474:	00003597          	auipc	a1,0x3
    80005478:	31c58593          	addi	a1,a1,796 # 80008790 <syscalls+0x350>
    8000547c:	00015517          	auipc	a0,0x15
    80005480:	93c50513          	addi	a0,a0,-1732 # 80019db8 <disk+0x128>
    80005484:	00001097          	auipc	ra,0x1
    80005488:	ef8080e7          	jalr	-264(ra) # 8000637c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000548c:	100017b7          	lui	a5,0x10001
    80005490:	4398                	lw	a4,0(a5)
    80005492:	2701                	sext.w	a4,a4
    80005494:	747277b7          	lui	a5,0x74727
    80005498:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000549c:	14f71e63          	bne	a4,a5,800055f8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054a0:	100017b7          	lui	a5,0x10001
    800054a4:	43dc                	lw	a5,4(a5)
    800054a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a8:	4709                	li	a4,2
    800054aa:	14e79763          	bne	a5,a4,800055f8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054ae:	100017b7          	lui	a5,0x10001
    800054b2:	479c                	lw	a5,8(a5)
    800054b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054b6:	14e79163          	bne	a5,a4,800055f8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054ba:	100017b7          	lui	a5,0x10001
    800054be:	47d8                	lw	a4,12(a5)
    800054c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054c2:	554d47b7          	lui	a5,0x554d4
    800054c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054ca:	12f71763          	bne	a4,a5,800055f8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ce:	100017b7          	lui	a5,0x10001
    800054d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054d6:	4705                	li	a4,1
    800054d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054da:	470d                	li	a4,3
    800054dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054de:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054e0:	c7ffe737          	lui	a4,0xc7ffe
    800054e4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc74f>
    800054e8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054ea:	2701                	sext.w	a4,a4
    800054ec:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ee:	472d                	li	a4,11
    800054f0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054f2:	0707a903          	lw	s2,112(a5)
    800054f6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054f8:	00897793          	andi	a5,s2,8
    800054fc:	10078663          	beqz	a5,80005608 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005500:	100017b7          	lui	a5,0x10001
    80005504:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005508:	43fc                	lw	a5,68(a5)
    8000550a:	2781                	sext.w	a5,a5
    8000550c:	10079663          	bnez	a5,80005618 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005510:	100017b7          	lui	a5,0x10001
    80005514:	5bdc                	lw	a5,52(a5)
    80005516:	2781                	sext.w	a5,a5
  if(max == 0)
    80005518:	10078863          	beqz	a5,80005628 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000551c:	471d                	li	a4,7
    8000551e:	10f77d63          	bgeu	a4,a5,80005638 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005522:	ffffb097          	auipc	ra,0xffffb
    80005526:	bf6080e7          	jalr	-1034(ra) # 80000118 <kalloc>
    8000552a:	00014497          	auipc	s1,0x14
    8000552e:	76648493          	addi	s1,s1,1894 # 80019c90 <disk>
    80005532:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005534:	ffffb097          	auipc	ra,0xffffb
    80005538:	be4080e7          	jalr	-1052(ra) # 80000118 <kalloc>
    8000553c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000553e:	ffffb097          	auipc	ra,0xffffb
    80005542:	bda080e7          	jalr	-1062(ra) # 80000118 <kalloc>
    80005546:	87aa                	mv	a5,a0
    80005548:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000554a:	6088                	ld	a0,0(s1)
    8000554c:	cd75                	beqz	a0,80005648 <virtio_disk_init+0x1e0>
    8000554e:	00014717          	auipc	a4,0x14
    80005552:	74a73703          	ld	a4,1866(a4) # 80019c98 <disk+0x8>
    80005556:	cb6d                	beqz	a4,80005648 <virtio_disk_init+0x1e0>
    80005558:	cbe5                	beqz	a5,80005648 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000555a:	6605                	lui	a2,0x1
    8000555c:	4581                	li	a1,0
    8000555e:	ffffb097          	auipc	ra,0xffffb
    80005562:	c1a080e7          	jalr	-998(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005566:	00014497          	auipc	s1,0x14
    8000556a:	72a48493          	addi	s1,s1,1834 # 80019c90 <disk>
    8000556e:	6605                	lui	a2,0x1
    80005570:	4581                	li	a1,0
    80005572:	6488                	ld	a0,8(s1)
    80005574:	ffffb097          	auipc	ra,0xffffb
    80005578:	c04080e7          	jalr	-1020(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000557c:	6605                	lui	a2,0x1
    8000557e:	4581                	li	a1,0
    80005580:	6888                	ld	a0,16(s1)
    80005582:	ffffb097          	auipc	ra,0xffffb
    80005586:	bf6080e7          	jalr	-1034(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000558a:	100017b7          	lui	a5,0x10001
    8000558e:	4721                	li	a4,8
    80005590:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005592:	4098                	lw	a4,0(s1)
    80005594:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005598:	40d8                	lw	a4,4(s1)
    8000559a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000559e:	6498                	ld	a4,8(s1)
    800055a0:	0007069b          	sext.w	a3,a4
    800055a4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055a8:	9701                	srai	a4,a4,0x20
    800055aa:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055ae:	6898                	ld	a4,16(s1)
    800055b0:	0007069b          	sext.w	a3,a4
    800055b4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055b8:	9701                	srai	a4,a4,0x20
    800055ba:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055be:	4685                	li	a3,1
    800055c0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800055c2:	4705                	li	a4,1
    800055c4:	00d48c23          	sb	a3,24(s1)
    800055c8:	00e48ca3          	sb	a4,25(s1)
    800055cc:	00e48d23          	sb	a4,26(s1)
    800055d0:	00e48da3          	sb	a4,27(s1)
    800055d4:	00e48e23          	sb	a4,28(s1)
    800055d8:	00e48ea3          	sb	a4,29(s1)
    800055dc:	00e48f23          	sb	a4,30(s1)
    800055e0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055e8:	0727a823          	sw	s2,112(a5)
}
    800055ec:	60e2                	ld	ra,24(sp)
    800055ee:	6442                	ld	s0,16(sp)
    800055f0:	64a2                	ld	s1,8(sp)
    800055f2:	6902                	ld	s2,0(sp)
    800055f4:	6105                	addi	sp,sp,32
    800055f6:	8082                	ret
    panic("could not find virtio disk");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	1a850513          	addi	a0,a0,424 # 800087a0 <syscalls+0x360>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	8c2080e7          	jalr	-1854(ra) # 80005ec2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	1b850513          	addi	a0,a0,440 # 800087c0 <syscalls+0x380>
    80005610:	00001097          	auipc	ra,0x1
    80005614:	8b2080e7          	jalr	-1870(ra) # 80005ec2 <panic>
    panic("virtio disk should not be ready");
    80005618:	00003517          	auipc	a0,0x3
    8000561c:	1c850513          	addi	a0,a0,456 # 800087e0 <syscalls+0x3a0>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	8a2080e7          	jalr	-1886(ra) # 80005ec2 <panic>
    panic("virtio disk has no queue 0");
    80005628:	00003517          	auipc	a0,0x3
    8000562c:	1d850513          	addi	a0,a0,472 # 80008800 <syscalls+0x3c0>
    80005630:	00001097          	auipc	ra,0x1
    80005634:	892080e7          	jalr	-1902(ra) # 80005ec2 <panic>
    panic("virtio disk max queue too short");
    80005638:	00003517          	auipc	a0,0x3
    8000563c:	1e850513          	addi	a0,a0,488 # 80008820 <syscalls+0x3e0>
    80005640:	00001097          	auipc	ra,0x1
    80005644:	882080e7          	jalr	-1918(ra) # 80005ec2 <panic>
    panic("virtio disk kalloc");
    80005648:	00003517          	auipc	a0,0x3
    8000564c:	1f850513          	addi	a0,a0,504 # 80008840 <syscalls+0x400>
    80005650:	00001097          	auipc	ra,0x1
    80005654:	872080e7          	jalr	-1934(ra) # 80005ec2 <panic>

0000000080005658 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005658:	7159                	addi	sp,sp,-112
    8000565a:	f486                	sd	ra,104(sp)
    8000565c:	f0a2                	sd	s0,96(sp)
    8000565e:	eca6                	sd	s1,88(sp)
    80005660:	e8ca                	sd	s2,80(sp)
    80005662:	e4ce                	sd	s3,72(sp)
    80005664:	e0d2                	sd	s4,64(sp)
    80005666:	fc56                	sd	s5,56(sp)
    80005668:	f85a                	sd	s6,48(sp)
    8000566a:	f45e                	sd	s7,40(sp)
    8000566c:	f062                	sd	s8,32(sp)
    8000566e:	ec66                	sd	s9,24(sp)
    80005670:	e86a                	sd	s10,16(sp)
    80005672:	1880                	addi	s0,sp,112
    80005674:	892a                	mv	s2,a0
    80005676:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005678:	00c52c83          	lw	s9,12(a0)
    8000567c:	001c9c9b          	slliw	s9,s9,0x1
    80005680:	1c82                	slli	s9,s9,0x20
    80005682:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005686:	00014517          	auipc	a0,0x14
    8000568a:	73250513          	addi	a0,a0,1842 # 80019db8 <disk+0x128>
    8000568e:	00001097          	auipc	ra,0x1
    80005692:	d7e080e7          	jalr	-642(ra) # 8000640c <acquire>
  for(int i = 0; i < 3; i++){
    80005696:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005698:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000569a:	00014b17          	auipc	s6,0x14
    8000569e:	5f6b0b13          	addi	s6,s6,1526 # 80019c90 <disk>
  for(int i = 0; i < 3; i++){
    800056a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800056a4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056a6:	00014c17          	auipc	s8,0x14
    800056aa:	712c0c13          	addi	s8,s8,1810 # 80019db8 <disk+0x128>
    800056ae:	a8b5                	j	8000572a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800056b0:	00fb06b3          	add	a3,s6,a5
    800056b4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800056b8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800056ba:	0207c563          	bltz	a5,800056e4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800056be:	2485                	addiw	s1,s1,1
    800056c0:	0711                	addi	a4,a4,4
    800056c2:	1f548a63          	beq	s1,s5,800058b6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800056c6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800056c8:	00014697          	auipc	a3,0x14
    800056cc:	5c868693          	addi	a3,a3,1480 # 80019c90 <disk>
    800056d0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800056d2:	0186c583          	lbu	a1,24(a3)
    800056d6:	fde9                	bnez	a1,800056b0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056d8:	2785                	addiw	a5,a5,1
    800056da:	0685                	addi	a3,a3,1
    800056dc:	ff779be3          	bne	a5,s7,800056d2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056e0:	57fd                	li	a5,-1
    800056e2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800056e4:	02905a63          	blez	s1,80005718 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056e8:	f9042503          	lw	a0,-112(s0)
    800056ec:	00000097          	auipc	ra,0x0
    800056f0:	cfa080e7          	jalr	-774(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    800056f4:	4785                	li	a5,1
    800056f6:	0297d163          	bge	a5,s1,80005718 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056fa:	f9442503          	lw	a0,-108(s0)
    800056fe:	00000097          	auipc	ra,0x0
    80005702:	ce8080e7          	jalr	-792(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005706:	4789                	li	a5,2
    80005708:	0097d863          	bge	a5,s1,80005718 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000570c:	f9842503          	lw	a0,-104(s0)
    80005710:	00000097          	auipc	ra,0x0
    80005714:	cd6080e7          	jalr	-810(ra) # 800053e6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005718:	85e2                	mv	a1,s8
    8000571a:	00014517          	auipc	a0,0x14
    8000571e:	58e50513          	addi	a0,a0,1422 # 80019ca8 <disk+0x18>
    80005722:	ffffc097          	auipc	ra,0xffffc
    80005726:	fe0080e7          	jalr	-32(ra) # 80001702 <sleep>
  for(int i = 0; i < 3; i++){
    8000572a:	f9040713          	addi	a4,s0,-112
    8000572e:	84ce                	mv	s1,s3
    80005730:	bf59                	j	800056c6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005732:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005736:	00479693          	slli	a3,a5,0x4
    8000573a:	00014797          	auipc	a5,0x14
    8000573e:	55678793          	addi	a5,a5,1366 # 80019c90 <disk>
    80005742:	97b6                	add	a5,a5,a3
    80005744:	4685                	li	a3,1
    80005746:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005748:	00014597          	auipc	a1,0x14
    8000574c:	54858593          	addi	a1,a1,1352 # 80019c90 <disk>
    80005750:	00a60793          	addi	a5,a2,10
    80005754:	0792                	slli	a5,a5,0x4
    80005756:	97ae                	add	a5,a5,a1
    80005758:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000575c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005760:	f6070693          	addi	a3,a4,-160
    80005764:	619c                	ld	a5,0(a1)
    80005766:	97b6                	add	a5,a5,a3
    80005768:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000576a:	6188                	ld	a0,0(a1)
    8000576c:	96aa                	add	a3,a3,a0
    8000576e:	47c1                	li	a5,16
    80005770:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005772:	4785                	li	a5,1
    80005774:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005778:	f9442783          	lw	a5,-108(s0)
    8000577c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005780:	0792                	slli	a5,a5,0x4
    80005782:	953e                	add	a0,a0,a5
    80005784:	05890693          	addi	a3,s2,88
    80005788:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000578a:	6188                	ld	a0,0(a1)
    8000578c:	97aa                	add	a5,a5,a0
    8000578e:	40000693          	li	a3,1024
    80005792:	c794                	sw	a3,8(a5)
  if(write)
    80005794:	100d0d63          	beqz	s10,800058ae <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005798:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000579c:	00c7d683          	lhu	a3,12(a5)
    800057a0:	0016e693          	ori	a3,a3,1
    800057a4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800057a8:	f9842583          	lw	a1,-104(s0)
    800057ac:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057b0:	00014697          	auipc	a3,0x14
    800057b4:	4e068693          	addi	a3,a3,1248 # 80019c90 <disk>
    800057b8:	00260793          	addi	a5,a2,2
    800057bc:	0792                	slli	a5,a5,0x4
    800057be:	97b6                	add	a5,a5,a3
    800057c0:	587d                	li	a6,-1
    800057c2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057c6:	0592                	slli	a1,a1,0x4
    800057c8:	952e                	add	a0,a0,a1
    800057ca:	f9070713          	addi	a4,a4,-112
    800057ce:	9736                	add	a4,a4,a3
    800057d0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800057d2:	6298                	ld	a4,0(a3)
    800057d4:	972e                	add	a4,a4,a1
    800057d6:	4585                	li	a1,1
    800057d8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057da:	4509                	li	a0,2
    800057dc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800057e0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057e4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800057e8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057ec:	6698                	ld	a4,8(a3)
    800057ee:	00275783          	lhu	a5,2(a4)
    800057f2:	8b9d                	andi	a5,a5,7
    800057f4:	0786                	slli	a5,a5,0x1
    800057f6:	97ba                	add	a5,a5,a4
    800057f8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800057fc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005800:	6698                	ld	a4,8(a3)
    80005802:	00275783          	lhu	a5,2(a4)
    80005806:	2785                	addiw	a5,a5,1
    80005808:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000580c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005810:	100017b7          	lui	a5,0x10001
    80005814:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005818:	00492703          	lw	a4,4(s2)
    8000581c:	4785                	li	a5,1
    8000581e:	02f71163          	bne	a4,a5,80005840 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005822:	00014997          	auipc	s3,0x14
    80005826:	59698993          	addi	s3,s3,1430 # 80019db8 <disk+0x128>
  while(b->disk == 1) {
    8000582a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000582c:	85ce                	mv	a1,s3
    8000582e:	854a                	mv	a0,s2
    80005830:	ffffc097          	auipc	ra,0xffffc
    80005834:	ed2080e7          	jalr	-302(ra) # 80001702 <sleep>
  while(b->disk == 1) {
    80005838:	00492783          	lw	a5,4(s2)
    8000583c:	fe9788e3          	beq	a5,s1,8000582c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005840:	f9042903          	lw	s2,-112(s0)
    80005844:	00290793          	addi	a5,s2,2
    80005848:	00479713          	slli	a4,a5,0x4
    8000584c:	00014797          	auipc	a5,0x14
    80005850:	44478793          	addi	a5,a5,1092 # 80019c90 <disk>
    80005854:	97ba                	add	a5,a5,a4
    80005856:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000585a:	00014997          	auipc	s3,0x14
    8000585e:	43698993          	addi	s3,s3,1078 # 80019c90 <disk>
    80005862:	00491713          	slli	a4,s2,0x4
    80005866:	0009b783          	ld	a5,0(s3)
    8000586a:	97ba                	add	a5,a5,a4
    8000586c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005870:	854a                	mv	a0,s2
    80005872:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005876:	00000097          	auipc	ra,0x0
    8000587a:	b70080e7          	jalr	-1168(ra) # 800053e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000587e:	8885                	andi	s1,s1,1
    80005880:	f0ed                	bnez	s1,80005862 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005882:	00014517          	auipc	a0,0x14
    80005886:	53650513          	addi	a0,a0,1334 # 80019db8 <disk+0x128>
    8000588a:	00001097          	auipc	ra,0x1
    8000588e:	c36080e7          	jalr	-970(ra) # 800064c0 <release>
}
    80005892:	70a6                	ld	ra,104(sp)
    80005894:	7406                	ld	s0,96(sp)
    80005896:	64e6                	ld	s1,88(sp)
    80005898:	6946                	ld	s2,80(sp)
    8000589a:	69a6                	ld	s3,72(sp)
    8000589c:	6a06                	ld	s4,64(sp)
    8000589e:	7ae2                	ld	s5,56(sp)
    800058a0:	7b42                	ld	s6,48(sp)
    800058a2:	7ba2                	ld	s7,40(sp)
    800058a4:	7c02                	ld	s8,32(sp)
    800058a6:	6ce2                	ld	s9,24(sp)
    800058a8:	6d42                	ld	s10,16(sp)
    800058aa:	6165                	addi	sp,sp,112
    800058ac:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058ae:	4689                	li	a3,2
    800058b0:	00d79623          	sh	a3,12(a5)
    800058b4:	b5e5                	j	8000579c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058b6:	f9042603          	lw	a2,-112(s0)
    800058ba:	00a60713          	addi	a4,a2,10
    800058be:	0712                	slli	a4,a4,0x4
    800058c0:	00014517          	auipc	a0,0x14
    800058c4:	3d850513          	addi	a0,a0,984 # 80019c98 <disk+0x8>
    800058c8:	953a                	add	a0,a0,a4
  if(write)
    800058ca:	e60d14e3          	bnez	s10,80005732 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800058ce:	00a60793          	addi	a5,a2,10
    800058d2:	00479693          	slli	a3,a5,0x4
    800058d6:	00014797          	auipc	a5,0x14
    800058da:	3ba78793          	addi	a5,a5,954 # 80019c90 <disk>
    800058de:	97b6                	add	a5,a5,a3
    800058e0:	0007a423          	sw	zero,8(a5)
    800058e4:	b595                	j	80005748 <virtio_disk_rw+0xf0>

00000000800058e6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058e6:	1101                	addi	sp,sp,-32
    800058e8:	ec06                	sd	ra,24(sp)
    800058ea:	e822                	sd	s0,16(sp)
    800058ec:	e426                	sd	s1,8(sp)
    800058ee:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058f0:	00014497          	auipc	s1,0x14
    800058f4:	3a048493          	addi	s1,s1,928 # 80019c90 <disk>
    800058f8:	00014517          	auipc	a0,0x14
    800058fc:	4c050513          	addi	a0,a0,1216 # 80019db8 <disk+0x128>
    80005900:	00001097          	auipc	ra,0x1
    80005904:	b0c080e7          	jalr	-1268(ra) # 8000640c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005908:	10001737          	lui	a4,0x10001
    8000590c:	533c                	lw	a5,96(a4)
    8000590e:	8b8d                	andi	a5,a5,3
    80005910:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005912:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005916:	689c                	ld	a5,16(s1)
    80005918:	0204d703          	lhu	a4,32(s1)
    8000591c:	0027d783          	lhu	a5,2(a5)
    80005920:	04f70863          	beq	a4,a5,80005970 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005924:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005928:	6898                	ld	a4,16(s1)
    8000592a:	0204d783          	lhu	a5,32(s1)
    8000592e:	8b9d                	andi	a5,a5,7
    80005930:	078e                	slli	a5,a5,0x3
    80005932:	97ba                	add	a5,a5,a4
    80005934:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005936:	00278713          	addi	a4,a5,2
    8000593a:	0712                	slli	a4,a4,0x4
    8000593c:	9726                	add	a4,a4,s1
    8000593e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005942:	e721                	bnez	a4,8000598a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005944:	0789                	addi	a5,a5,2
    80005946:	0792                	slli	a5,a5,0x4
    80005948:	97a6                	add	a5,a5,s1
    8000594a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000594c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005950:	ffffc097          	auipc	ra,0xffffc
    80005954:	e16080e7          	jalr	-490(ra) # 80001766 <wakeup>

    disk.used_idx += 1;
    80005958:	0204d783          	lhu	a5,32(s1)
    8000595c:	2785                	addiw	a5,a5,1
    8000595e:	17c2                	slli	a5,a5,0x30
    80005960:	93c1                	srli	a5,a5,0x30
    80005962:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005966:	6898                	ld	a4,16(s1)
    80005968:	00275703          	lhu	a4,2(a4)
    8000596c:	faf71ce3          	bne	a4,a5,80005924 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005970:	00014517          	auipc	a0,0x14
    80005974:	44850513          	addi	a0,a0,1096 # 80019db8 <disk+0x128>
    80005978:	00001097          	auipc	ra,0x1
    8000597c:	b48080e7          	jalr	-1208(ra) # 800064c0 <release>
}
    80005980:	60e2                	ld	ra,24(sp)
    80005982:	6442                	ld	s0,16(sp)
    80005984:	64a2                	ld	s1,8(sp)
    80005986:	6105                	addi	sp,sp,32
    80005988:	8082                	ret
      panic("virtio_disk_intr status");
    8000598a:	00003517          	auipc	a0,0x3
    8000598e:	ece50513          	addi	a0,a0,-306 # 80008858 <syscalls+0x418>
    80005992:	00000097          	auipc	ra,0x0
    80005996:	530080e7          	jalr	1328(ra) # 80005ec2 <panic>

000000008000599a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000599a:	1141                	addi	sp,sp,-16
    8000599c:	e422                	sd	s0,8(sp)
    8000599e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059a0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059a4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059a8:	0037979b          	slliw	a5,a5,0x3
    800059ac:	02004737          	lui	a4,0x2004
    800059b0:	97ba                	add	a5,a5,a4
    800059b2:	0200c737          	lui	a4,0x200c
    800059b6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059ba:	000f4637          	lui	a2,0xf4
    800059be:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059c2:	95b2                	add	a1,a1,a2
    800059c4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059c6:	00269713          	slli	a4,a3,0x2
    800059ca:	9736                	add	a4,a4,a3
    800059cc:	00371693          	slli	a3,a4,0x3
    800059d0:	00014717          	auipc	a4,0x14
    800059d4:	40070713          	addi	a4,a4,1024 # 80019dd0 <timer_scratch>
    800059d8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059da:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059dc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059de:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059e2:	00000797          	auipc	a5,0x0
    800059e6:	93e78793          	addi	a5,a5,-1730 # 80005320 <timervec>
    800059ea:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059ee:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059f2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059f6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059fa:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059fe:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a02:	30479073          	csrw	mie,a5
}
    80005a06:	6422                	ld	s0,8(sp)
    80005a08:	0141                	addi	sp,sp,16
    80005a0a:	8082                	ret

0000000080005a0c <start>:
{
    80005a0c:	1141                	addi	sp,sp,-16
    80005a0e:	e406                	sd	ra,8(sp)
    80005a10:	e022                	sd	s0,0(sp)
    80005a12:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a14:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a18:	7779                	lui	a4,0xffffe
    80005a1a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7ef>
    80005a1e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a20:	6705                	lui	a4,0x1
    80005a22:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a26:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a28:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a2c:	ffffb797          	auipc	a5,0xffffb
    80005a30:	8fa78793          	addi	a5,a5,-1798 # 80000326 <main>
    80005a34:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a38:	4781                	li	a5,0
    80005a3a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a3e:	67c1                	lui	a5,0x10
    80005a40:	17fd                	addi	a5,a5,-1
    80005a42:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a46:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a4a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a4e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a52:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a56:	57fd                	li	a5,-1
    80005a58:	83a9                	srli	a5,a5,0xa
    80005a5a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a5e:	47bd                	li	a5,15
    80005a60:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a64:	00000097          	auipc	ra,0x0
    80005a68:	f36080e7          	jalr	-202(ra) # 8000599a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a6c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a70:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a72:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a74:	30200073          	mret
}
    80005a78:	60a2                	ld	ra,8(sp)
    80005a7a:	6402                	ld	s0,0(sp)
    80005a7c:	0141                	addi	sp,sp,16
    80005a7e:	8082                	ret

0000000080005a80 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a80:	715d                	addi	sp,sp,-80
    80005a82:	e486                	sd	ra,72(sp)
    80005a84:	e0a2                	sd	s0,64(sp)
    80005a86:	fc26                	sd	s1,56(sp)
    80005a88:	f84a                	sd	s2,48(sp)
    80005a8a:	f44e                	sd	s3,40(sp)
    80005a8c:	f052                	sd	s4,32(sp)
    80005a8e:	ec56                	sd	s5,24(sp)
    80005a90:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a92:	04c05663          	blez	a2,80005ade <consolewrite+0x5e>
    80005a96:	8a2a                	mv	s4,a0
    80005a98:	84ae                	mv	s1,a1
    80005a9a:	89b2                	mv	s3,a2
    80005a9c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a9e:	5afd                	li	s5,-1
    80005aa0:	4685                	li	a3,1
    80005aa2:	8626                	mv	a2,s1
    80005aa4:	85d2                	mv	a1,s4
    80005aa6:	fbf40513          	addi	a0,s0,-65
    80005aaa:	ffffc097          	auipc	ra,0xffffc
    80005aae:	0b6080e7          	jalr	182(ra) # 80001b60 <either_copyin>
    80005ab2:	01550c63          	beq	a0,s5,80005aca <consolewrite+0x4a>
      break;
    uartputc(c);
    80005ab6:	fbf44503          	lbu	a0,-65(s0)
    80005aba:	00000097          	auipc	ra,0x0
    80005abe:	794080e7          	jalr	1940(ra) # 8000624e <uartputc>
  for(i = 0; i < n; i++){
    80005ac2:	2905                	addiw	s2,s2,1
    80005ac4:	0485                	addi	s1,s1,1
    80005ac6:	fd299de3          	bne	s3,s2,80005aa0 <consolewrite+0x20>
  }

  return i;
}
    80005aca:	854a                	mv	a0,s2
    80005acc:	60a6                	ld	ra,72(sp)
    80005ace:	6406                	ld	s0,64(sp)
    80005ad0:	74e2                	ld	s1,56(sp)
    80005ad2:	7942                	ld	s2,48(sp)
    80005ad4:	79a2                	ld	s3,40(sp)
    80005ad6:	7a02                	ld	s4,32(sp)
    80005ad8:	6ae2                	ld	s5,24(sp)
    80005ada:	6161                	addi	sp,sp,80
    80005adc:	8082                	ret
  for(i = 0; i < n; i++){
    80005ade:	4901                	li	s2,0
    80005ae0:	b7ed                	j	80005aca <consolewrite+0x4a>

0000000080005ae2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ae2:	7119                	addi	sp,sp,-128
    80005ae4:	fc86                	sd	ra,120(sp)
    80005ae6:	f8a2                	sd	s0,112(sp)
    80005ae8:	f4a6                	sd	s1,104(sp)
    80005aea:	f0ca                	sd	s2,96(sp)
    80005aec:	ecce                	sd	s3,88(sp)
    80005aee:	e8d2                	sd	s4,80(sp)
    80005af0:	e4d6                	sd	s5,72(sp)
    80005af2:	e0da                	sd	s6,64(sp)
    80005af4:	fc5e                	sd	s7,56(sp)
    80005af6:	f862                	sd	s8,48(sp)
    80005af8:	f466                	sd	s9,40(sp)
    80005afa:	f06a                	sd	s10,32(sp)
    80005afc:	ec6e                	sd	s11,24(sp)
    80005afe:	0100                	addi	s0,sp,128
    80005b00:	8b2a                	mv	s6,a0
    80005b02:	8aae                	mv	s5,a1
    80005b04:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b06:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005b0a:	0001c517          	auipc	a0,0x1c
    80005b0e:	40650513          	addi	a0,a0,1030 # 80021f10 <cons>
    80005b12:	00001097          	auipc	ra,0x1
    80005b16:	8fa080e7          	jalr	-1798(ra) # 8000640c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b1a:	0001c497          	auipc	s1,0x1c
    80005b1e:	3f648493          	addi	s1,s1,1014 # 80021f10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b22:	89a6                	mv	s3,s1
    80005b24:	0001c917          	auipc	s2,0x1c
    80005b28:	48490913          	addi	s2,s2,1156 # 80021fa8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005b2c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b2e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005b30:	4da9                	li	s11,10
  while(n > 0){
    80005b32:	07405b63          	blez	s4,80005ba8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005b36:	0984a783          	lw	a5,152(s1)
    80005b3a:	09c4a703          	lw	a4,156(s1)
    80005b3e:	02f71763          	bne	a4,a5,80005b6c <consoleread+0x8a>
      if(killed(myproc())){
    80005b42:	ffffb097          	auipc	ra,0xffffb
    80005b46:	462080e7          	jalr	1122(ra) # 80000fa4 <myproc>
    80005b4a:	ffffc097          	auipc	ra,0xffffc
    80005b4e:	e60080e7          	jalr	-416(ra) # 800019aa <killed>
    80005b52:	e535                	bnez	a0,80005bbe <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005b54:	85ce                	mv	a1,s3
    80005b56:	854a                	mv	a0,s2
    80005b58:	ffffc097          	auipc	ra,0xffffc
    80005b5c:	baa080e7          	jalr	-1110(ra) # 80001702 <sleep>
    while(cons.r == cons.w){
    80005b60:	0984a783          	lw	a5,152(s1)
    80005b64:	09c4a703          	lw	a4,156(s1)
    80005b68:	fcf70de3          	beq	a4,a5,80005b42 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b6c:	0017871b          	addiw	a4,a5,1
    80005b70:	08e4ac23          	sw	a4,152(s1)
    80005b74:	07f7f713          	andi	a4,a5,127
    80005b78:	9726                	add	a4,a4,s1
    80005b7a:	01874703          	lbu	a4,24(a4)
    80005b7e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b82:	079c0663          	beq	s8,s9,80005bee <consoleread+0x10c>
    cbuf = c;
    80005b86:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b8a:	4685                	li	a3,1
    80005b8c:	f8f40613          	addi	a2,s0,-113
    80005b90:	85d6                	mv	a1,s5
    80005b92:	855a                	mv	a0,s6
    80005b94:	ffffc097          	auipc	ra,0xffffc
    80005b98:	f76080e7          	jalr	-138(ra) # 80001b0a <either_copyout>
    80005b9c:	01a50663          	beq	a0,s10,80005ba8 <consoleread+0xc6>
    dst++;
    80005ba0:	0a85                	addi	s5,s5,1
    --n;
    80005ba2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005ba4:	f9bc17e3          	bne	s8,s11,80005b32 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ba8:	0001c517          	auipc	a0,0x1c
    80005bac:	36850513          	addi	a0,a0,872 # 80021f10 <cons>
    80005bb0:	00001097          	auipc	ra,0x1
    80005bb4:	910080e7          	jalr	-1776(ra) # 800064c0 <release>

  return target - n;
    80005bb8:	414b853b          	subw	a0,s7,s4
    80005bbc:	a811                	j	80005bd0 <consoleread+0xee>
        release(&cons.lock);
    80005bbe:	0001c517          	auipc	a0,0x1c
    80005bc2:	35250513          	addi	a0,a0,850 # 80021f10 <cons>
    80005bc6:	00001097          	auipc	ra,0x1
    80005bca:	8fa080e7          	jalr	-1798(ra) # 800064c0 <release>
        return -1;
    80005bce:	557d                	li	a0,-1
}
    80005bd0:	70e6                	ld	ra,120(sp)
    80005bd2:	7446                	ld	s0,112(sp)
    80005bd4:	74a6                	ld	s1,104(sp)
    80005bd6:	7906                	ld	s2,96(sp)
    80005bd8:	69e6                	ld	s3,88(sp)
    80005bda:	6a46                	ld	s4,80(sp)
    80005bdc:	6aa6                	ld	s5,72(sp)
    80005bde:	6b06                	ld	s6,64(sp)
    80005be0:	7be2                	ld	s7,56(sp)
    80005be2:	7c42                	ld	s8,48(sp)
    80005be4:	7ca2                	ld	s9,40(sp)
    80005be6:	7d02                	ld	s10,32(sp)
    80005be8:	6de2                	ld	s11,24(sp)
    80005bea:	6109                	addi	sp,sp,128
    80005bec:	8082                	ret
      if(n < target){
    80005bee:	000a071b          	sext.w	a4,s4
    80005bf2:	fb777be3          	bgeu	a4,s7,80005ba8 <consoleread+0xc6>
        cons.r--;
    80005bf6:	0001c717          	auipc	a4,0x1c
    80005bfa:	3af72923          	sw	a5,946(a4) # 80021fa8 <cons+0x98>
    80005bfe:	b76d                	j	80005ba8 <consoleread+0xc6>

0000000080005c00 <consputc>:
{
    80005c00:	1141                	addi	sp,sp,-16
    80005c02:	e406                	sd	ra,8(sp)
    80005c04:	e022                	sd	s0,0(sp)
    80005c06:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c08:	10000793          	li	a5,256
    80005c0c:	00f50a63          	beq	a0,a5,80005c20 <consputc+0x20>
    uartputc_sync(c);
    80005c10:	00000097          	auipc	ra,0x0
    80005c14:	564080e7          	jalr	1380(ra) # 80006174 <uartputc_sync>
}
    80005c18:	60a2                	ld	ra,8(sp)
    80005c1a:	6402                	ld	s0,0(sp)
    80005c1c:	0141                	addi	sp,sp,16
    80005c1e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c20:	4521                	li	a0,8
    80005c22:	00000097          	auipc	ra,0x0
    80005c26:	552080e7          	jalr	1362(ra) # 80006174 <uartputc_sync>
    80005c2a:	02000513          	li	a0,32
    80005c2e:	00000097          	auipc	ra,0x0
    80005c32:	546080e7          	jalr	1350(ra) # 80006174 <uartputc_sync>
    80005c36:	4521                	li	a0,8
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	53c080e7          	jalr	1340(ra) # 80006174 <uartputc_sync>
    80005c40:	bfe1                	j	80005c18 <consputc+0x18>

0000000080005c42 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c42:	1101                	addi	sp,sp,-32
    80005c44:	ec06                	sd	ra,24(sp)
    80005c46:	e822                	sd	s0,16(sp)
    80005c48:	e426                	sd	s1,8(sp)
    80005c4a:	e04a                	sd	s2,0(sp)
    80005c4c:	1000                	addi	s0,sp,32
    80005c4e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c50:	0001c517          	auipc	a0,0x1c
    80005c54:	2c050513          	addi	a0,a0,704 # 80021f10 <cons>
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	7b4080e7          	jalr	1972(ra) # 8000640c <acquire>

  switch(c){
    80005c60:	47d5                	li	a5,21
    80005c62:	0af48663          	beq	s1,a5,80005d0e <consoleintr+0xcc>
    80005c66:	0297ca63          	blt	a5,s1,80005c9a <consoleintr+0x58>
    80005c6a:	47a1                	li	a5,8
    80005c6c:	0ef48763          	beq	s1,a5,80005d5a <consoleintr+0x118>
    80005c70:	47c1                	li	a5,16
    80005c72:	10f49a63          	bne	s1,a5,80005d86 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c76:	ffffc097          	auipc	ra,0xffffc
    80005c7a:	f40080e7          	jalr	-192(ra) # 80001bb6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c7e:	0001c517          	auipc	a0,0x1c
    80005c82:	29250513          	addi	a0,a0,658 # 80021f10 <cons>
    80005c86:	00001097          	auipc	ra,0x1
    80005c8a:	83a080e7          	jalr	-1990(ra) # 800064c0 <release>
}
    80005c8e:	60e2                	ld	ra,24(sp)
    80005c90:	6442                	ld	s0,16(sp)
    80005c92:	64a2                	ld	s1,8(sp)
    80005c94:	6902                	ld	s2,0(sp)
    80005c96:	6105                	addi	sp,sp,32
    80005c98:	8082                	ret
  switch(c){
    80005c9a:	07f00793          	li	a5,127
    80005c9e:	0af48e63          	beq	s1,a5,80005d5a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ca2:	0001c717          	auipc	a4,0x1c
    80005ca6:	26e70713          	addi	a4,a4,622 # 80021f10 <cons>
    80005caa:	0a072783          	lw	a5,160(a4)
    80005cae:	09872703          	lw	a4,152(a4)
    80005cb2:	9f99                	subw	a5,a5,a4
    80005cb4:	07f00713          	li	a4,127
    80005cb8:	fcf763e3          	bltu	a4,a5,80005c7e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005cbc:	47b5                	li	a5,13
    80005cbe:	0cf48763          	beq	s1,a5,80005d8c <consoleintr+0x14a>
      consputc(c);
    80005cc2:	8526                	mv	a0,s1
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	f3c080e7          	jalr	-196(ra) # 80005c00 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ccc:	0001c797          	auipc	a5,0x1c
    80005cd0:	24478793          	addi	a5,a5,580 # 80021f10 <cons>
    80005cd4:	0a07a683          	lw	a3,160(a5)
    80005cd8:	0016871b          	addiw	a4,a3,1
    80005cdc:	0007061b          	sext.w	a2,a4
    80005ce0:	0ae7a023          	sw	a4,160(a5)
    80005ce4:	07f6f693          	andi	a3,a3,127
    80005ce8:	97b6                	add	a5,a5,a3
    80005cea:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cee:	47a9                	li	a5,10
    80005cf0:	0cf48563          	beq	s1,a5,80005dba <consoleintr+0x178>
    80005cf4:	4791                	li	a5,4
    80005cf6:	0cf48263          	beq	s1,a5,80005dba <consoleintr+0x178>
    80005cfa:	0001c797          	auipc	a5,0x1c
    80005cfe:	2ae7a783          	lw	a5,686(a5) # 80021fa8 <cons+0x98>
    80005d02:	9f1d                	subw	a4,a4,a5
    80005d04:	08000793          	li	a5,128
    80005d08:	f6f71be3          	bne	a4,a5,80005c7e <consoleintr+0x3c>
    80005d0c:	a07d                	j	80005dba <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005d0e:	0001c717          	auipc	a4,0x1c
    80005d12:	20270713          	addi	a4,a4,514 # 80021f10 <cons>
    80005d16:	0a072783          	lw	a5,160(a4)
    80005d1a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d1e:	0001c497          	auipc	s1,0x1c
    80005d22:	1f248493          	addi	s1,s1,498 # 80021f10 <cons>
    while(cons.e != cons.w &&
    80005d26:	4929                	li	s2,10
    80005d28:	f4f70be3          	beq	a4,a5,80005c7e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d2c:	37fd                	addiw	a5,a5,-1
    80005d2e:	07f7f713          	andi	a4,a5,127
    80005d32:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d34:	01874703          	lbu	a4,24(a4)
    80005d38:	f52703e3          	beq	a4,s2,80005c7e <consoleintr+0x3c>
      cons.e--;
    80005d3c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d40:	10000513          	li	a0,256
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	ebc080e7          	jalr	-324(ra) # 80005c00 <consputc>
    while(cons.e != cons.w &&
    80005d4c:	0a04a783          	lw	a5,160(s1)
    80005d50:	09c4a703          	lw	a4,156(s1)
    80005d54:	fcf71ce3          	bne	a4,a5,80005d2c <consoleintr+0xea>
    80005d58:	b71d                	j	80005c7e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d5a:	0001c717          	auipc	a4,0x1c
    80005d5e:	1b670713          	addi	a4,a4,438 # 80021f10 <cons>
    80005d62:	0a072783          	lw	a5,160(a4)
    80005d66:	09c72703          	lw	a4,156(a4)
    80005d6a:	f0f70ae3          	beq	a4,a5,80005c7e <consoleintr+0x3c>
      cons.e--;
    80005d6e:	37fd                	addiw	a5,a5,-1
    80005d70:	0001c717          	auipc	a4,0x1c
    80005d74:	24f72023          	sw	a5,576(a4) # 80021fb0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d78:	10000513          	li	a0,256
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	e84080e7          	jalr	-380(ra) # 80005c00 <consputc>
    80005d84:	bded                	j	80005c7e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d86:	ee048ce3          	beqz	s1,80005c7e <consoleintr+0x3c>
    80005d8a:	bf21                	j	80005ca2 <consoleintr+0x60>
      consputc(c);
    80005d8c:	4529                	li	a0,10
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	e72080e7          	jalr	-398(ra) # 80005c00 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d96:	0001c797          	auipc	a5,0x1c
    80005d9a:	17a78793          	addi	a5,a5,378 # 80021f10 <cons>
    80005d9e:	0a07a703          	lw	a4,160(a5)
    80005da2:	0017069b          	addiw	a3,a4,1
    80005da6:	0006861b          	sext.w	a2,a3
    80005daa:	0ad7a023          	sw	a3,160(a5)
    80005dae:	07f77713          	andi	a4,a4,127
    80005db2:	97ba                	add	a5,a5,a4
    80005db4:	4729                	li	a4,10
    80005db6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005dba:	0001c797          	auipc	a5,0x1c
    80005dbe:	1ec7a923          	sw	a2,498(a5) # 80021fac <cons+0x9c>
        wakeup(&cons.r);
    80005dc2:	0001c517          	auipc	a0,0x1c
    80005dc6:	1e650513          	addi	a0,a0,486 # 80021fa8 <cons+0x98>
    80005dca:	ffffc097          	auipc	ra,0xffffc
    80005dce:	99c080e7          	jalr	-1636(ra) # 80001766 <wakeup>
    80005dd2:	b575                	j	80005c7e <consoleintr+0x3c>

0000000080005dd4 <consoleinit>:

void
consoleinit(void)
{
    80005dd4:	1141                	addi	sp,sp,-16
    80005dd6:	e406                	sd	ra,8(sp)
    80005dd8:	e022                	sd	s0,0(sp)
    80005dda:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ddc:	00003597          	auipc	a1,0x3
    80005de0:	a9458593          	addi	a1,a1,-1388 # 80008870 <syscalls+0x430>
    80005de4:	0001c517          	auipc	a0,0x1c
    80005de8:	12c50513          	addi	a0,a0,300 # 80021f10 <cons>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	590080e7          	jalr	1424(ra) # 8000637c <initlock>

  uartinit();
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	330080e7          	jalr	816(ra) # 80006124 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dfc:	00013797          	auipc	a5,0x13
    80005e00:	e3c78793          	addi	a5,a5,-452 # 80018c38 <devsw>
    80005e04:	00000717          	auipc	a4,0x0
    80005e08:	cde70713          	addi	a4,a4,-802 # 80005ae2 <consoleread>
    80005e0c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e0e:	00000717          	auipc	a4,0x0
    80005e12:	c7270713          	addi	a4,a4,-910 # 80005a80 <consolewrite>
    80005e16:	ef98                	sd	a4,24(a5)
}
    80005e18:	60a2                	ld	ra,8(sp)
    80005e1a:	6402                	ld	s0,0(sp)
    80005e1c:	0141                	addi	sp,sp,16
    80005e1e:	8082                	ret

0000000080005e20 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e20:	7179                	addi	sp,sp,-48
    80005e22:	f406                	sd	ra,40(sp)
    80005e24:	f022                	sd	s0,32(sp)
    80005e26:	ec26                	sd	s1,24(sp)
    80005e28:	e84a                	sd	s2,16(sp)
    80005e2a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e2c:	c219                	beqz	a2,80005e32 <printint+0x12>
    80005e2e:	08054663          	bltz	a0,80005eba <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005e32:	2501                	sext.w	a0,a0
    80005e34:	4881                	li	a7,0
    80005e36:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e3a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e3c:	2581                	sext.w	a1,a1
    80005e3e:	00003617          	auipc	a2,0x3
    80005e42:	a6260613          	addi	a2,a2,-1438 # 800088a0 <digits>
    80005e46:	883a                	mv	a6,a4
    80005e48:	2705                	addiw	a4,a4,1
    80005e4a:	02b577bb          	remuw	a5,a0,a1
    80005e4e:	1782                	slli	a5,a5,0x20
    80005e50:	9381                	srli	a5,a5,0x20
    80005e52:	97b2                	add	a5,a5,a2
    80005e54:	0007c783          	lbu	a5,0(a5)
    80005e58:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e5c:	0005079b          	sext.w	a5,a0
    80005e60:	02b5553b          	divuw	a0,a0,a1
    80005e64:	0685                	addi	a3,a3,1
    80005e66:	feb7f0e3          	bgeu	a5,a1,80005e46 <printint+0x26>

  if(sign)
    80005e6a:	00088b63          	beqz	a7,80005e80 <printint+0x60>
    buf[i++] = '-';
    80005e6e:	fe040793          	addi	a5,s0,-32
    80005e72:	973e                	add	a4,a4,a5
    80005e74:	02d00793          	li	a5,45
    80005e78:	fef70823          	sb	a5,-16(a4)
    80005e7c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e80:	02e05763          	blez	a4,80005eae <printint+0x8e>
    80005e84:	fd040793          	addi	a5,s0,-48
    80005e88:	00e784b3          	add	s1,a5,a4
    80005e8c:	fff78913          	addi	s2,a5,-1
    80005e90:	993a                	add	s2,s2,a4
    80005e92:	377d                	addiw	a4,a4,-1
    80005e94:	1702                	slli	a4,a4,0x20
    80005e96:	9301                	srli	a4,a4,0x20
    80005e98:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e9c:	fff4c503          	lbu	a0,-1(s1)
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	d60080e7          	jalr	-672(ra) # 80005c00 <consputc>
  while(--i >= 0)
    80005ea8:	14fd                	addi	s1,s1,-1
    80005eaa:	ff2499e3          	bne	s1,s2,80005e9c <printint+0x7c>
}
    80005eae:	70a2                	ld	ra,40(sp)
    80005eb0:	7402                	ld	s0,32(sp)
    80005eb2:	64e2                	ld	s1,24(sp)
    80005eb4:	6942                	ld	s2,16(sp)
    80005eb6:	6145                	addi	sp,sp,48
    80005eb8:	8082                	ret
    x = -xx;
    80005eba:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ebe:	4885                	li	a7,1
    x = -xx;
    80005ec0:	bf9d                	j	80005e36 <printint+0x16>

0000000080005ec2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ec2:	1101                	addi	sp,sp,-32
    80005ec4:	ec06                	sd	ra,24(sp)
    80005ec6:	e822                	sd	s0,16(sp)
    80005ec8:	e426                	sd	s1,8(sp)
    80005eca:	1000                	addi	s0,sp,32
    80005ecc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ece:	0001c797          	auipc	a5,0x1c
    80005ed2:	1007a123          	sw	zero,258(a5) # 80021fd0 <pr+0x18>
  printf("panic: ");
    80005ed6:	00003517          	auipc	a0,0x3
    80005eda:	9a250513          	addi	a0,a0,-1630 # 80008878 <syscalls+0x438>
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	02e080e7          	jalr	46(ra) # 80005f0c <printf>
  printf(s);
    80005ee6:	8526                	mv	a0,s1
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	024080e7          	jalr	36(ra) # 80005f0c <printf>
  printf("\n");
    80005ef0:	00002517          	auipc	a0,0x2
    80005ef4:	15850513          	addi	a0,a0,344 # 80008048 <etext+0x48>
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	014080e7          	jalr	20(ra) # 80005f0c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f00:	4785                	li	a5,1
    80005f02:	00003717          	auipc	a4,0x3
    80005f06:	a8f72123          	sw	a5,-1406(a4) # 80008984 <panicked>
  for(;;)
    80005f0a:	a001                	j	80005f0a <panic+0x48>

0000000080005f0c <printf>:
{
    80005f0c:	7131                	addi	sp,sp,-192
    80005f0e:	fc86                	sd	ra,120(sp)
    80005f10:	f8a2                	sd	s0,112(sp)
    80005f12:	f4a6                	sd	s1,104(sp)
    80005f14:	f0ca                	sd	s2,96(sp)
    80005f16:	ecce                	sd	s3,88(sp)
    80005f18:	e8d2                	sd	s4,80(sp)
    80005f1a:	e4d6                	sd	s5,72(sp)
    80005f1c:	e0da                	sd	s6,64(sp)
    80005f1e:	fc5e                	sd	s7,56(sp)
    80005f20:	f862                	sd	s8,48(sp)
    80005f22:	f466                	sd	s9,40(sp)
    80005f24:	f06a                	sd	s10,32(sp)
    80005f26:	ec6e                	sd	s11,24(sp)
    80005f28:	0100                	addi	s0,sp,128
    80005f2a:	8a2a                	mv	s4,a0
    80005f2c:	e40c                	sd	a1,8(s0)
    80005f2e:	e810                	sd	a2,16(s0)
    80005f30:	ec14                	sd	a3,24(s0)
    80005f32:	f018                	sd	a4,32(s0)
    80005f34:	f41c                	sd	a5,40(s0)
    80005f36:	03043823          	sd	a6,48(s0)
    80005f3a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f3e:	0001cd97          	auipc	s11,0x1c
    80005f42:	092dad83          	lw	s11,146(s11) # 80021fd0 <pr+0x18>
  if(locking)
    80005f46:	020d9b63          	bnez	s11,80005f7c <printf+0x70>
  if (fmt == 0)
    80005f4a:	040a0263          	beqz	s4,80005f8e <printf+0x82>
  va_start(ap, fmt);
    80005f4e:	00840793          	addi	a5,s0,8
    80005f52:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f56:	000a4503          	lbu	a0,0(s4)
    80005f5a:	16050263          	beqz	a0,800060be <printf+0x1b2>
    80005f5e:	4481                	li	s1,0
    if(c != '%'){
    80005f60:	02500a93          	li	s5,37
    switch(c){
    80005f64:	07000b13          	li	s6,112
  consputc('x');
    80005f68:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f6a:	00003b97          	auipc	s7,0x3
    80005f6e:	936b8b93          	addi	s7,s7,-1738 # 800088a0 <digits>
    switch(c){
    80005f72:	07300c93          	li	s9,115
    80005f76:	06400c13          	li	s8,100
    80005f7a:	a82d                	j	80005fb4 <printf+0xa8>
    acquire(&pr.lock);
    80005f7c:	0001c517          	auipc	a0,0x1c
    80005f80:	03c50513          	addi	a0,a0,60 # 80021fb8 <pr>
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	488080e7          	jalr	1160(ra) # 8000640c <acquire>
    80005f8c:	bf7d                	j	80005f4a <printf+0x3e>
    panic("null fmt");
    80005f8e:	00003517          	auipc	a0,0x3
    80005f92:	8fa50513          	addi	a0,a0,-1798 # 80008888 <syscalls+0x448>
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	f2c080e7          	jalr	-212(ra) # 80005ec2 <panic>
      consputc(c);
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	c62080e7          	jalr	-926(ra) # 80005c00 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fa6:	2485                	addiw	s1,s1,1
    80005fa8:	009a07b3          	add	a5,s4,s1
    80005fac:	0007c503          	lbu	a0,0(a5)
    80005fb0:	10050763          	beqz	a0,800060be <printf+0x1b2>
    if(c != '%'){
    80005fb4:	ff5515e3          	bne	a0,s5,80005f9e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005fb8:	2485                	addiw	s1,s1,1
    80005fba:	009a07b3          	add	a5,s4,s1
    80005fbe:	0007c783          	lbu	a5,0(a5)
    80005fc2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005fc6:	cfe5                	beqz	a5,800060be <printf+0x1b2>
    switch(c){
    80005fc8:	05678a63          	beq	a5,s6,8000601c <printf+0x110>
    80005fcc:	02fb7663          	bgeu	s6,a5,80005ff8 <printf+0xec>
    80005fd0:	09978963          	beq	a5,s9,80006062 <printf+0x156>
    80005fd4:	07800713          	li	a4,120
    80005fd8:	0ce79863          	bne	a5,a4,800060a8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005fdc:	f8843783          	ld	a5,-120(s0)
    80005fe0:	00878713          	addi	a4,a5,8
    80005fe4:	f8e43423          	sd	a4,-120(s0)
    80005fe8:	4605                	li	a2,1
    80005fea:	85ea                	mv	a1,s10
    80005fec:	4388                	lw	a0,0(a5)
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	e32080e7          	jalr	-462(ra) # 80005e20 <printint>
      break;
    80005ff6:	bf45                	j	80005fa6 <printf+0x9a>
    switch(c){
    80005ff8:	0b578263          	beq	a5,s5,8000609c <printf+0x190>
    80005ffc:	0b879663          	bne	a5,s8,800060a8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006000:	f8843783          	ld	a5,-120(s0)
    80006004:	00878713          	addi	a4,a5,8
    80006008:	f8e43423          	sd	a4,-120(s0)
    8000600c:	4605                	li	a2,1
    8000600e:	45a9                	li	a1,10
    80006010:	4388                	lw	a0,0(a5)
    80006012:	00000097          	auipc	ra,0x0
    80006016:	e0e080e7          	jalr	-498(ra) # 80005e20 <printint>
      break;
    8000601a:	b771                	j	80005fa6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000601c:	f8843783          	ld	a5,-120(s0)
    80006020:	00878713          	addi	a4,a5,8
    80006024:	f8e43423          	sd	a4,-120(s0)
    80006028:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000602c:	03000513          	li	a0,48
    80006030:	00000097          	auipc	ra,0x0
    80006034:	bd0080e7          	jalr	-1072(ra) # 80005c00 <consputc>
  consputc('x');
    80006038:	07800513          	li	a0,120
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	bc4080e7          	jalr	-1084(ra) # 80005c00 <consputc>
    80006044:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006046:	03c9d793          	srli	a5,s3,0x3c
    8000604a:	97de                	add	a5,a5,s7
    8000604c:	0007c503          	lbu	a0,0(a5)
    80006050:	00000097          	auipc	ra,0x0
    80006054:	bb0080e7          	jalr	-1104(ra) # 80005c00 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006058:	0992                	slli	s3,s3,0x4
    8000605a:	397d                	addiw	s2,s2,-1
    8000605c:	fe0915e3          	bnez	s2,80006046 <printf+0x13a>
    80006060:	b799                	j	80005fa6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006062:	f8843783          	ld	a5,-120(s0)
    80006066:	00878713          	addi	a4,a5,8
    8000606a:	f8e43423          	sd	a4,-120(s0)
    8000606e:	0007b903          	ld	s2,0(a5)
    80006072:	00090e63          	beqz	s2,8000608e <printf+0x182>
      for(; *s; s++)
    80006076:	00094503          	lbu	a0,0(s2)
    8000607a:	d515                	beqz	a0,80005fa6 <printf+0x9a>
        consputc(*s);
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	b84080e7          	jalr	-1148(ra) # 80005c00 <consputc>
      for(; *s; s++)
    80006084:	0905                	addi	s2,s2,1
    80006086:	00094503          	lbu	a0,0(s2)
    8000608a:	f96d                	bnez	a0,8000607c <printf+0x170>
    8000608c:	bf29                	j	80005fa6 <printf+0x9a>
        s = "(null)";
    8000608e:	00002917          	auipc	s2,0x2
    80006092:	7f290913          	addi	s2,s2,2034 # 80008880 <syscalls+0x440>
      for(; *s; s++)
    80006096:	02800513          	li	a0,40
    8000609a:	b7cd                	j	8000607c <printf+0x170>
      consputc('%');
    8000609c:	8556                	mv	a0,s5
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	b62080e7          	jalr	-1182(ra) # 80005c00 <consputc>
      break;
    800060a6:	b701                	j	80005fa6 <printf+0x9a>
      consputc('%');
    800060a8:	8556                	mv	a0,s5
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	b56080e7          	jalr	-1194(ra) # 80005c00 <consputc>
      consputc(c);
    800060b2:	854a                	mv	a0,s2
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	b4c080e7          	jalr	-1204(ra) # 80005c00 <consputc>
      break;
    800060bc:	b5ed                	j	80005fa6 <printf+0x9a>
  if(locking)
    800060be:	020d9163          	bnez	s11,800060e0 <printf+0x1d4>
}
    800060c2:	70e6                	ld	ra,120(sp)
    800060c4:	7446                	ld	s0,112(sp)
    800060c6:	74a6                	ld	s1,104(sp)
    800060c8:	7906                	ld	s2,96(sp)
    800060ca:	69e6                	ld	s3,88(sp)
    800060cc:	6a46                	ld	s4,80(sp)
    800060ce:	6aa6                	ld	s5,72(sp)
    800060d0:	6b06                	ld	s6,64(sp)
    800060d2:	7be2                	ld	s7,56(sp)
    800060d4:	7c42                	ld	s8,48(sp)
    800060d6:	7ca2                	ld	s9,40(sp)
    800060d8:	7d02                	ld	s10,32(sp)
    800060da:	6de2                	ld	s11,24(sp)
    800060dc:	6129                	addi	sp,sp,192
    800060de:	8082                	ret
    release(&pr.lock);
    800060e0:	0001c517          	auipc	a0,0x1c
    800060e4:	ed850513          	addi	a0,a0,-296 # 80021fb8 <pr>
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	3d8080e7          	jalr	984(ra) # 800064c0 <release>
}
    800060f0:	bfc9                	j	800060c2 <printf+0x1b6>

00000000800060f2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060f2:	1101                	addi	sp,sp,-32
    800060f4:	ec06                	sd	ra,24(sp)
    800060f6:	e822                	sd	s0,16(sp)
    800060f8:	e426                	sd	s1,8(sp)
    800060fa:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060fc:	0001c497          	auipc	s1,0x1c
    80006100:	ebc48493          	addi	s1,s1,-324 # 80021fb8 <pr>
    80006104:	00002597          	auipc	a1,0x2
    80006108:	79458593          	addi	a1,a1,1940 # 80008898 <syscalls+0x458>
    8000610c:	8526                	mv	a0,s1
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	26e080e7          	jalr	622(ra) # 8000637c <initlock>
  pr.locking = 1;
    80006116:	4785                	li	a5,1
    80006118:	cc9c                	sw	a5,24(s1)
}
    8000611a:	60e2                	ld	ra,24(sp)
    8000611c:	6442                	ld	s0,16(sp)
    8000611e:	64a2                	ld	s1,8(sp)
    80006120:	6105                	addi	sp,sp,32
    80006122:	8082                	ret

0000000080006124 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006124:	1141                	addi	sp,sp,-16
    80006126:	e406                	sd	ra,8(sp)
    80006128:	e022                	sd	s0,0(sp)
    8000612a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000612c:	100007b7          	lui	a5,0x10000
    80006130:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006134:	f8000713          	li	a4,-128
    80006138:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000613c:	470d                	li	a4,3
    8000613e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006142:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006146:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000614a:	469d                	li	a3,7
    8000614c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006150:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006154:	00002597          	auipc	a1,0x2
    80006158:	76458593          	addi	a1,a1,1892 # 800088b8 <digits+0x18>
    8000615c:	0001c517          	auipc	a0,0x1c
    80006160:	e7c50513          	addi	a0,a0,-388 # 80021fd8 <uart_tx_lock>
    80006164:	00000097          	auipc	ra,0x0
    80006168:	218080e7          	jalr	536(ra) # 8000637c <initlock>
}
    8000616c:	60a2                	ld	ra,8(sp)
    8000616e:	6402                	ld	s0,0(sp)
    80006170:	0141                	addi	sp,sp,16
    80006172:	8082                	ret

0000000080006174 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006174:	1101                	addi	sp,sp,-32
    80006176:	ec06                	sd	ra,24(sp)
    80006178:	e822                	sd	s0,16(sp)
    8000617a:	e426                	sd	s1,8(sp)
    8000617c:	1000                	addi	s0,sp,32
    8000617e:	84aa                	mv	s1,a0
  push_off();
    80006180:	00000097          	auipc	ra,0x0
    80006184:	240080e7          	jalr	576(ra) # 800063c0 <push_off>

  if(panicked){
    80006188:	00002797          	auipc	a5,0x2
    8000618c:	7fc7a783          	lw	a5,2044(a5) # 80008984 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006190:	10000737          	lui	a4,0x10000
  if(panicked){
    80006194:	c391                	beqz	a5,80006198 <uartputc_sync+0x24>
    for(;;)
    80006196:	a001                	j	80006196 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006198:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000619c:	0ff7f793          	andi	a5,a5,255
    800061a0:	0207f793          	andi	a5,a5,32
    800061a4:	dbf5                	beqz	a5,80006198 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061a6:	0ff4f793          	andi	a5,s1,255
    800061aa:	10000737          	lui	a4,0x10000
    800061ae:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	2ae080e7          	jalr	686(ra) # 80006460 <pop_off>
}
    800061ba:	60e2                	ld	ra,24(sp)
    800061bc:	6442                	ld	s0,16(sp)
    800061be:	64a2                	ld	s1,8(sp)
    800061c0:	6105                	addi	sp,sp,32
    800061c2:	8082                	ret

00000000800061c4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061c4:	00002717          	auipc	a4,0x2
    800061c8:	7c473703          	ld	a4,1988(a4) # 80008988 <uart_tx_r>
    800061cc:	00002797          	auipc	a5,0x2
    800061d0:	7c47b783          	ld	a5,1988(a5) # 80008990 <uart_tx_w>
    800061d4:	06e78c63          	beq	a5,a4,8000624c <uartstart+0x88>
{
    800061d8:	7139                	addi	sp,sp,-64
    800061da:	fc06                	sd	ra,56(sp)
    800061dc:	f822                	sd	s0,48(sp)
    800061de:	f426                	sd	s1,40(sp)
    800061e0:	f04a                	sd	s2,32(sp)
    800061e2:	ec4e                	sd	s3,24(sp)
    800061e4:	e852                	sd	s4,16(sp)
    800061e6:	e456                	sd	s5,8(sp)
    800061e8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061ea:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ee:	0001ca17          	auipc	s4,0x1c
    800061f2:	deaa0a13          	addi	s4,s4,-534 # 80021fd8 <uart_tx_lock>
    uart_tx_r += 1;
    800061f6:	00002497          	auipc	s1,0x2
    800061fa:	79248493          	addi	s1,s1,1938 # 80008988 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061fe:	00002997          	auipc	s3,0x2
    80006202:	79298993          	addi	s3,s3,1938 # 80008990 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006206:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000620a:	0ff7f793          	andi	a5,a5,255
    8000620e:	0207f793          	andi	a5,a5,32
    80006212:	c785                	beqz	a5,8000623a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006214:	01f77793          	andi	a5,a4,31
    80006218:	97d2                	add	a5,a5,s4
    8000621a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000621e:	0705                	addi	a4,a4,1
    80006220:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006222:	8526                	mv	a0,s1
    80006224:	ffffb097          	auipc	ra,0xffffb
    80006228:	542080e7          	jalr	1346(ra) # 80001766 <wakeup>
    
    WriteReg(THR, c);
    8000622c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006230:	6098                	ld	a4,0(s1)
    80006232:	0009b783          	ld	a5,0(s3)
    80006236:	fce798e3          	bne	a5,a4,80006206 <uartstart+0x42>
  }
}
    8000623a:	70e2                	ld	ra,56(sp)
    8000623c:	7442                	ld	s0,48(sp)
    8000623e:	74a2                	ld	s1,40(sp)
    80006240:	7902                	ld	s2,32(sp)
    80006242:	69e2                	ld	s3,24(sp)
    80006244:	6a42                	ld	s4,16(sp)
    80006246:	6aa2                	ld	s5,8(sp)
    80006248:	6121                	addi	sp,sp,64
    8000624a:	8082                	ret
    8000624c:	8082                	ret

000000008000624e <uartputc>:
{
    8000624e:	7179                	addi	sp,sp,-48
    80006250:	f406                	sd	ra,40(sp)
    80006252:	f022                	sd	s0,32(sp)
    80006254:	ec26                	sd	s1,24(sp)
    80006256:	e84a                	sd	s2,16(sp)
    80006258:	e44e                	sd	s3,8(sp)
    8000625a:	e052                	sd	s4,0(sp)
    8000625c:	1800                	addi	s0,sp,48
    8000625e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006260:	0001c517          	auipc	a0,0x1c
    80006264:	d7850513          	addi	a0,a0,-648 # 80021fd8 <uart_tx_lock>
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	1a4080e7          	jalr	420(ra) # 8000640c <acquire>
  if(panicked){
    80006270:	00002797          	auipc	a5,0x2
    80006274:	7147a783          	lw	a5,1812(a5) # 80008984 <panicked>
    80006278:	e7c9                	bnez	a5,80006302 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000627a:	00002797          	auipc	a5,0x2
    8000627e:	7167b783          	ld	a5,1814(a5) # 80008990 <uart_tx_w>
    80006282:	00002717          	auipc	a4,0x2
    80006286:	70673703          	ld	a4,1798(a4) # 80008988 <uart_tx_r>
    8000628a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000628e:	0001ca17          	auipc	s4,0x1c
    80006292:	d4aa0a13          	addi	s4,s4,-694 # 80021fd8 <uart_tx_lock>
    80006296:	00002497          	auipc	s1,0x2
    8000629a:	6f248493          	addi	s1,s1,1778 # 80008988 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000629e:	00002917          	auipc	s2,0x2
    800062a2:	6f290913          	addi	s2,s2,1778 # 80008990 <uart_tx_w>
    800062a6:	00f71f63          	bne	a4,a5,800062c4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800062aa:	85d2                	mv	a1,s4
    800062ac:	8526                	mv	a0,s1
    800062ae:	ffffb097          	auipc	ra,0xffffb
    800062b2:	454080e7          	jalr	1108(ra) # 80001702 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062b6:	00093783          	ld	a5,0(s2)
    800062ba:	6098                	ld	a4,0(s1)
    800062bc:	02070713          	addi	a4,a4,32
    800062c0:	fef705e3          	beq	a4,a5,800062aa <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062c4:	0001c497          	auipc	s1,0x1c
    800062c8:	d1448493          	addi	s1,s1,-748 # 80021fd8 <uart_tx_lock>
    800062cc:	01f7f713          	andi	a4,a5,31
    800062d0:	9726                	add	a4,a4,s1
    800062d2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800062d6:	0785                	addi	a5,a5,1
    800062d8:	00002717          	auipc	a4,0x2
    800062dc:	6af73c23          	sd	a5,1720(a4) # 80008990 <uart_tx_w>
  uartstart();
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	ee4080e7          	jalr	-284(ra) # 800061c4 <uartstart>
  release(&uart_tx_lock);
    800062e8:	8526                	mv	a0,s1
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	1d6080e7          	jalr	470(ra) # 800064c0 <release>
}
    800062f2:	70a2                	ld	ra,40(sp)
    800062f4:	7402                	ld	s0,32(sp)
    800062f6:	64e2                	ld	s1,24(sp)
    800062f8:	6942                	ld	s2,16(sp)
    800062fa:	69a2                	ld	s3,8(sp)
    800062fc:	6a02                	ld	s4,0(sp)
    800062fe:	6145                	addi	sp,sp,48
    80006300:	8082                	ret
    for(;;)
    80006302:	a001                	j	80006302 <uartputc+0xb4>

0000000080006304 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006304:	1141                	addi	sp,sp,-16
    80006306:	e422                	sd	s0,8(sp)
    80006308:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000630a:	100007b7          	lui	a5,0x10000
    8000630e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006312:	8b85                	andi	a5,a5,1
    80006314:	cb91                	beqz	a5,80006328 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006316:	100007b7          	lui	a5,0x10000
    8000631a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000631e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006322:	6422                	ld	s0,8(sp)
    80006324:	0141                	addi	sp,sp,16
    80006326:	8082                	ret
    return -1;
    80006328:	557d                	li	a0,-1
    8000632a:	bfe5                	j	80006322 <uartgetc+0x1e>

000000008000632c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000632c:	1101                	addi	sp,sp,-32
    8000632e:	ec06                	sd	ra,24(sp)
    80006330:	e822                	sd	s0,16(sp)
    80006332:	e426                	sd	s1,8(sp)
    80006334:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006336:	54fd                	li	s1,-1
    int c = uartgetc();
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	fcc080e7          	jalr	-52(ra) # 80006304 <uartgetc>
    if(c == -1)
    80006340:	00950763          	beq	a0,s1,8000634e <uartintr+0x22>
      break;
    consoleintr(c);
    80006344:	00000097          	auipc	ra,0x0
    80006348:	8fe080e7          	jalr	-1794(ra) # 80005c42 <consoleintr>
  while(1){
    8000634c:	b7f5                	j	80006338 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000634e:	0001c497          	auipc	s1,0x1c
    80006352:	c8a48493          	addi	s1,s1,-886 # 80021fd8 <uart_tx_lock>
    80006356:	8526                	mv	a0,s1
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	0b4080e7          	jalr	180(ra) # 8000640c <acquire>
  uartstart();
    80006360:	00000097          	auipc	ra,0x0
    80006364:	e64080e7          	jalr	-412(ra) # 800061c4 <uartstart>
  release(&uart_tx_lock);
    80006368:	8526                	mv	a0,s1
    8000636a:	00000097          	auipc	ra,0x0
    8000636e:	156080e7          	jalr	342(ra) # 800064c0 <release>
}
    80006372:	60e2                	ld	ra,24(sp)
    80006374:	6442                	ld	s0,16(sp)
    80006376:	64a2                	ld	s1,8(sp)
    80006378:	6105                	addi	sp,sp,32
    8000637a:	8082                	ret

000000008000637c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000637c:	1141                	addi	sp,sp,-16
    8000637e:	e422                	sd	s0,8(sp)
    80006380:	0800                	addi	s0,sp,16
  lk->name = name;
    80006382:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006384:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006388:	00053823          	sd	zero,16(a0)
}
    8000638c:	6422                	ld	s0,8(sp)
    8000638e:	0141                	addi	sp,sp,16
    80006390:	8082                	ret

0000000080006392 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006392:	411c                	lw	a5,0(a0)
    80006394:	e399                	bnez	a5,8000639a <holding+0x8>
    80006396:	4501                	li	a0,0
  return r;
}
    80006398:	8082                	ret
{
    8000639a:	1101                	addi	sp,sp,-32
    8000639c:	ec06                	sd	ra,24(sp)
    8000639e:	e822                	sd	s0,16(sp)
    800063a0:	e426                	sd	s1,8(sp)
    800063a2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063a4:	6904                	ld	s1,16(a0)
    800063a6:	ffffb097          	auipc	ra,0xffffb
    800063aa:	be2080e7          	jalr	-1054(ra) # 80000f88 <mycpu>
    800063ae:	40a48533          	sub	a0,s1,a0
    800063b2:	00153513          	seqz	a0,a0
}
    800063b6:	60e2                	ld	ra,24(sp)
    800063b8:	6442                	ld	s0,16(sp)
    800063ba:	64a2                	ld	s1,8(sp)
    800063bc:	6105                	addi	sp,sp,32
    800063be:	8082                	ret

00000000800063c0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063c0:	1101                	addi	sp,sp,-32
    800063c2:	ec06                	sd	ra,24(sp)
    800063c4:	e822                	sd	s0,16(sp)
    800063c6:	e426                	sd	s1,8(sp)
    800063c8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063ca:	100024f3          	csrr	s1,sstatus
    800063ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063d2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063d4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063d8:	ffffb097          	auipc	ra,0xffffb
    800063dc:	bb0080e7          	jalr	-1104(ra) # 80000f88 <mycpu>
    800063e0:	5d3c                	lw	a5,120(a0)
    800063e2:	cf89                	beqz	a5,800063fc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063e4:	ffffb097          	auipc	ra,0xffffb
    800063e8:	ba4080e7          	jalr	-1116(ra) # 80000f88 <mycpu>
    800063ec:	5d3c                	lw	a5,120(a0)
    800063ee:	2785                	addiw	a5,a5,1
    800063f0:	dd3c                	sw	a5,120(a0)
}
    800063f2:	60e2                	ld	ra,24(sp)
    800063f4:	6442                	ld	s0,16(sp)
    800063f6:	64a2                	ld	s1,8(sp)
    800063f8:	6105                	addi	sp,sp,32
    800063fa:	8082                	ret
    mycpu()->intena = old;
    800063fc:	ffffb097          	auipc	ra,0xffffb
    80006400:	b8c080e7          	jalr	-1140(ra) # 80000f88 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006404:	8085                	srli	s1,s1,0x1
    80006406:	8885                	andi	s1,s1,1
    80006408:	dd64                	sw	s1,124(a0)
    8000640a:	bfe9                	j	800063e4 <push_off+0x24>

000000008000640c <acquire>:
{
    8000640c:	1101                	addi	sp,sp,-32
    8000640e:	ec06                	sd	ra,24(sp)
    80006410:	e822                	sd	s0,16(sp)
    80006412:	e426                	sd	s1,8(sp)
    80006414:	1000                	addi	s0,sp,32
    80006416:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	fa8080e7          	jalr	-88(ra) # 800063c0 <push_off>
  if(holding(lk))
    80006420:	8526                	mv	a0,s1
    80006422:	00000097          	auipc	ra,0x0
    80006426:	f70080e7          	jalr	-144(ra) # 80006392 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000642a:	4705                	li	a4,1
  if(holding(lk))
    8000642c:	e115                	bnez	a0,80006450 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000642e:	87ba                	mv	a5,a4
    80006430:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006434:	2781                	sext.w	a5,a5
    80006436:	ffe5                	bnez	a5,8000642e <acquire+0x22>
  __sync_synchronize();
    80006438:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000643c:	ffffb097          	auipc	ra,0xffffb
    80006440:	b4c080e7          	jalr	-1204(ra) # 80000f88 <mycpu>
    80006444:	e888                	sd	a0,16(s1)
}
    80006446:	60e2                	ld	ra,24(sp)
    80006448:	6442                	ld	s0,16(sp)
    8000644a:	64a2                	ld	s1,8(sp)
    8000644c:	6105                	addi	sp,sp,32
    8000644e:	8082                	ret
    panic("acquire");
    80006450:	00002517          	auipc	a0,0x2
    80006454:	47050513          	addi	a0,a0,1136 # 800088c0 <digits+0x20>
    80006458:	00000097          	auipc	ra,0x0
    8000645c:	a6a080e7          	jalr	-1430(ra) # 80005ec2 <panic>

0000000080006460 <pop_off>:

void
pop_off(void)
{
    80006460:	1141                	addi	sp,sp,-16
    80006462:	e406                	sd	ra,8(sp)
    80006464:	e022                	sd	s0,0(sp)
    80006466:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006468:	ffffb097          	auipc	ra,0xffffb
    8000646c:	b20080e7          	jalr	-1248(ra) # 80000f88 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006470:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006474:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006476:	e78d                	bnez	a5,800064a0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006478:	5d3c                	lw	a5,120(a0)
    8000647a:	02f05b63          	blez	a5,800064b0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000647e:	37fd                	addiw	a5,a5,-1
    80006480:	0007871b          	sext.w	a4,a5
    80006484:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006486:	eb09                	bnez	a4,80006498 <pop_off+0x38>
    80006488:	5d7c                	lw	a5,124(a0)
    8000648a:	c799                	beqz	a5,80006498 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000648c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006490:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006494:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006498:	60a2                	ld	ra,8(sp)
    8000649a:	6402                	ld	s0,0(sp)
    8000649c:	0141                	addi	sp,sp,16
    8000649e:	8082                	ret
    panic("pop_off - interruptible");
    800064a0:	00002517          	auipc	a0,0x2
    800064a4:	42850513          	addi	a0,a0,1064 # 800088c8 <digits+0x28>
    800064a8:	00000097          	auipc	ra,0x0
    800064ac:	a1a080e7          	jalr	-1510(ra) # 80005ec2 <panic>
    panic("pop_off");
    800064b0:	00002517          	auipc	a0,0x2
    800064b4:	43050513          	addi	a0,a0,1072 # 800088e0 <digits+0x40>
    800064b8:	00000097          	auipc	ra,0x0
    800064bc:	a0a080e7          	jalr	-1526(ra) # 80005ec2 <panic>

00000000800064c0 <release>:
{
    800064c0:	1101                	addi	sp,sp,-32
    800064c2:	ec06                	sd	ra,24(sp)
    800064c4:	e822                	sd	s0,16(sp)
    800064c6:	e426                	sd	s1,8(sp)
    800064c8:	1000                	addi	s0,sp,32
    800064ca:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064cc:	00000097          	auipc	ra,0x0
    800064d0:	ec6080e7          	jalr	-314(ra) # 80006392 <holding>
    800064d4:	c115                	beqz	a0,800064f8 <release+0x38>
  lk->cpu = 0;
    800064d6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064da:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064de:	0f50000f          	fence	iorw,ow
    800064e2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064e6:	00000097          	auipc	ra,0x0
    800064ea:	f7a080e7          	jalr	-134(ra) # 80006460 <pop_off>
}
    800064ee:	60e2                	ld	ra,24(sp)
    800064f0:	6442                	ld	s0,16(sp)
    800064f2:	64a2                	ld	s1,8(sp)
    800064f4:	6105                	addi	sp,sp,32
    800064f6:	8082                	ret
    panic("release");
    800064f8:	00002517          	auipc	a0,0x2
    800064fc:	3f050513          	addi	a0,a0,1008 # 800088e8 <digits+0x48>
    80006500:	00000097          	auipc	ra,0x0
    80006504:	9c2080e7          	jalr	-1598(ra) # 80005ec2 <panic>
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
