
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	92013103          	ld	sp,-1760(sp) # 80009920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c6060ef          	jal	ra,800067dc <start>

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
    80000030:	00023797          	auipc	a5,0x23
    80000034:	43078793          	addi	a5,a5,1072 # 80023460 <end>
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
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	94090913          	addi	s2,s2,-1728 # 80009990 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	182080e7          	jalr	386(ra) # 800071dc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	222080e7          	jalr	546(ra) # 80007290 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	c08080e7          	jalr	-1016(ra) # 80006c92 <panic>

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
    800000e4:	00009597          	auipc	a1,0x9
    800000e8:	f3458593          	addi	a1,a1,-204 # 80009018 <etext+0x18>
    800000ec:	0000a517          	auipc	a0,0xa
    800000f0:	8a450513          	addi	a0,a0,-1884 # 80009990 <kmem>
    800000f4:	00007097          	auipc	ra,0x7
    800000f8:	058080e7          	jalr	88(ra) # 8000714c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00023517          	auipc	a0,0x23
    80000104:	36050513          	addi	a0,a0,864 # 80023460 <end>
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
    80000122:	0000a497          	auipc	s1,0xa
    80000126:	86e48493          	addi	s1,s1,-1938 # 80009990 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00007097          	auipc	ra,0x7
    80000130:	0b0080e7          	jalr	176(ra) # 800071dc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	0000a517          	auipc	a0,0xa
    8000013e:	85650513          	addi	a0,a0,-1962 # 80009990 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00007097          	auipc	ra,0x7
    80000148:	14c080e7          	jalr	332(ra) # 80007290 <release>

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
    80000166:	0000a517          	auipc	a0,0xa
    8000016a:	82a50513          	addi	a0,a0,-2006 # 80009990 <kmem>
    8000016e:	00007097          	auipc	ra,0x7
    80000172:	122080e7          	jalr	290(ra) # 80007290 <release>
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
    80000326:	1101                	addi	sp,sp,-32
    80000328:	ec06                	sd	ra,24(sp)
    8000032a:	e822                	sd	s0,16(sp)
    8000032c:	e426                	sd	s1,8(sp)
    8000032e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000330:	00001097          	auipc	ra,0x1
    80000334:	b8c080e7          	jalr	-1140(ra) # 80000ebc <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    80000338:	00009497          	auipc	s1,0x9
    8000033c:	60848493          	addi	s1,s1,1544 # 80009940 <started>
  if(cpuid() == 0){
    80000340:	c531                	beqz	a0,8000038c <main+0x66>
    while(atomic_read4((int *) &started) == 0)
    80000342:	8526                	mv	a0,s1
    80000344:	00007097          	auipc	ra,0x7
    80000348:	f94080e7          	jalr	-108(ra) # 800072d8 <atomic_read4>
    8000034c:	d97d                	beqz	a0,80000342 <main+0x1c>
      ;
    __sync_synchronize();
    8000034e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000352:	00001097          	auipc	ra,0x1
    80000356:	b6a080e7          	jalr	-1174(ra) # 80000ebc <cpuid>
    8000035a:	85aa                	mv	a1,a0
    8000035c:	00009517          	auipc	a0,0x9
    80000360:	cdc50513          	addi	a0,a0,-804 # 80009038 <etext+0x38>
    80000364:	00007097          	auipc	ra,0x7
    80000368:	978080e7          	jalr	-1672(ra) # 80006cdc <printf>
    kvminithart();    // turn on paging
    8000036c:	00000097          	auipc	ra,0x0
    80000370:	0e8080e7          	jalr	232(ra) # 80000454 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000374:	00002097          	auipc	ra,0x2
    80000378:	810080e7          	jalr	-2032(ra) # 80001b84 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	e68080e7          	jalr	-408(ra) # 800051e4 <plicinithart>
  }

  scheduler();        
    80000384:	00001097          	auipc	ra,0x1
    80000388:	05a080e7          	jalr	90(ra) # 800013de <scheduler>
    consoleinit();
    8000038c:	00007097          	auipc	ra,0x7
    80000390:	818080e7          	jalr	-2024(ra) # 80006ba4 <consoleinit>
    printfinit();
    80000394:	00007097          	auipc	ra,0x7
    80000398:	b2e080e7          	jalr	-1234(ra) # 80006ec2 <printfinit>
    printf("\n");
    8000039c:	00009517          	auipc	a0,0x9
    800003a0:	cac50513          	addi	a0,a0,-852 # 80009048 <etext+0x48>
    800003a4:	00007097          	auipc	ra,0x7
    800003a8:	938080e7          	jalr	-1736(ra) # 80006cdc <printf>
    printf("xv6 kernel is booting\n");
    800003ac:	00009517          	auipc	a0,0x9
    800003b0:	c7450513          	addi	a0,a0,-908 # 80009020 <etext+0x20>
    800003b4:	00007097          	auipc	ra,0x7
    800003b8:	928080e7          	jalr	-1752(ra) # 80006cdc <printf>
    printf("\n");
    800003bc:	00009517          	auipc	a0,0x9
    800003c0:	c8c50513          	addi	a0,a0,-884 # 80009048 <etext+0x48>
    800003c4:	00007097          	auipc	ra,0x7
    800003c8:	918080e7          	jalr	-1768(ra) # 80006cdc <printf>
    kinit();         // physical page allocator
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	d10080e7          	jalr	-752(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	366080e7          	jalr	870(ra) # 8000073a <kvminit>
    kvminithart();   // turn on paging
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	078080e7          	jalr	120(ra) # 80000454 <kvminithart>
    procinit();      // process table
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	a26080e7          	jalr	-1498(ra) # 80000e0a <procinit>
    trapinit();      // trap vectors
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	770080e7          	jalr	1904(ra) # 80001b5c <trapinit>
    trapinithart();  // install kernel trap vector
    800003f4:	00001097          	auipc	ra,0x1
    800003f8:	790080e7          	jalr	1936(ra) # 80001b84 <trapinithart>
    plicinit();      // set up interrupt controller
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	dbe080e7          	jalr	-578(ra) # 800051ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000404:	00005097          	auipc	ra,0x5
    80000408:	de0080e7          	jalr	-544(ra) # 800051e4 <plicinithart>
    binit();         // buffer cache
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	ed4080e7          	jalr	-300(ra) # 800022e0 <binit>
    iinit();         // inode table
    80000414:	00002097          	auipc	ra,0x2
    80000418:	578080e7          	jalr	1400(ra) # 8000298c <iinit>
    fileinit();      // file table
    8000041c:	00003097          	auipc	ra,0x3
    80000420:	516080e7          	jalr	1302(ra) # 80003932 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000424:	00005097          	auipc	ra,0x5
    80000428:	ece080e7          	jalr	-306(ra) # 800052f2 <virtio_disk_init>
    pci_init();
    8000042c:	00006097          	auipc	ra,0x6
    80000430:	2b0080e7          	jalr	688(ra) # 800066dc <pci_init>
    sockinit();
    80000434:	00006097          	auipc	ra,0x6
    80000438:	e9e080e7          	jalr	-354(ra) # 800062d2 <sockinit>
    userinit();      // first user process
    8000043c:	00001097          	auipc	ra,0x1
    80000440:	d88080e7          	jalr	-632(ra) # 800011c4 <userinit>
    __sync_synchronize();
    80000444:	0ff0000f          	fence
    started = 1;
    80000448:	4785                	li	a5,1
    8000044a:	00009717          	auipc	a4,0x9
    8000044e:	4ef72b23          	sw	a5,1270(a4) # 80009940 <started>
    80000452:	bf0d                	j	80000384 <main+0x5e>

0000000080000454 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000454:	1141                	addi	sp,sp,-16
    80000456:	e422                	sd	s0,8(sp)
    80000458:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000045e:	00009797          	auipc	a5,0x9
    80000462:	4ea7b783          	ld	a5,1258(a5) # 80009948 <kernel_pagetable>
    80000466:	83b1                	srli	a5,a5,0xc
    80000468:	577d                	li	a4,-1
    8000046a:	177e                	slli	a4,a4,0x3f
    8000046c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000046e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000472:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000476:	6422                	ld	s0,8(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f426                	sd	s1,40(sp)
    80000484:	f04a                	sd	s2,32(sp)
    80000486:	ec4e                	sd	s3,24(sp)
    80000488:	e852                	sd	s4,16(sp)
    8000048a:	e456                	sd	s5,8(sp)
    8000048c:	e05a                	sd	s6,0(sp)
    8000048e:	0080                	addi	s0,sp,64
    80000490:	84aa                	mv	s1,a0
    80000492:	89ae                	mv	s3,a1
    80000494:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000496:	57fd                	li	a5,-1
    80000498:	83e9                	srli	a5,a5,0x1a
    8000049a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000049c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000049e:	04b7f263          	bgeu	a5,a1,800004e2 <walk+0x66>
    panic("walk");
    800004a2:	00009517          	auipc	a0,0x9
    800004a6:	bae50513          	addi	a0,a0,-1106 # 80009050 <etext+0x50>
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	7e8080e7          	jalr	2024(ra) # 80006c92 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004b2:	060a8663          	beqz	s5,8000051e <walk+0xa2>
    800004b6:	00000097          	auipc	ra,0x0
    800004ba:	c62080e7          	jalr	-926(ra) # 80000118 <kalloc>
    800004be:	84aa                	mv	s1,a0
    800004c0:	c529                	beqz	a0,8000050a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004c2:	6605                	lui	a2,0x1
    800004c4:	4581                	li	a1,0
    800004c6:	00000097          	auipc	ra,0x0
    800004ca:	cb2080e7          	jalr	-846(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ce:	00c4d793          	srli	a5,s1,0xc
    800004d2:	07aa                	slli	a5,a5,0xa
    800004d4:	0017e793          	ori	a5,a5,1
    800004d8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004dc:	3a5d                	addiw	s4,s4,-9
    800004de:	036a0063          	beq	s4,s6,800004fe <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e2:	0149d933          	srl	s2,s3,s4
    800004e6:	1ff97913          	andi	s2,s2,511
    800004ea:	090e                	slli	s2,s2,0x3
    800004ec:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ee:	00093483          	ld	s1,0(s2)
    800004f2:	0014f793          	andi	a5,s1,1
    800004f6:	dfd5                	beqz	a5,800004b2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f8:	80a9                	srli	s1,s1,0xa
    800004fa:	04b2                	slli	s1,s1,0xc
    800004fc:	b7c5                	j	800004dc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004fe:	00c9d513          	srli	a0,s3,0xc
    80000502:	1ff57513          	andi	a0,a0,511
    80000506:	050e                	slli	a0,a0,0x3
    80000508:	9526                	add	a0,a0,s1
}
    8000050a:	70e2                	ld	ra,56(sp)
    8000050c:	7442                	ld	s0,48(sp)
    8000050e:	74a2                	ld	s1,40(sp)
    80000510:	7902                	ld	s2,32(sp)
    80000512:	69e2                	ld	s3,24(sp)
    80000514:	6a42                	ld	s4,16(sp)
    80000516:	6aa2                	ld	s5,8(sp)
    80000518:	6b02                	ld	s6,0(sp)
    8000051a:	6121                	addi	sp,sp,64
    8000051c:	8082                	ret
        return 0;
    8000051e:	4501                	li	a0,0
    80000520:	b7ed                	j	8000050a <walk+0x8e>

0000000080000522 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000522:	57fd                	li	a5,-1
    80000524:	83e9                	srli	a5,a5,0x1a
    80000526:	00b7f463          	bgeu	a5,a1,8000052e <walkaddr+0xc>
    return 0;
    8000052a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000052c:	8082                	ret
{
    8000052e:	1141                	addi	sp,sp,-16
    80000530:	e406                	sd	ra,8(sp)
    80000532:	e022                	sd	s0,0(sp)
    80000534:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000536:	4601                	li	a2,0
    80000538:	00000097          	auipc	ra,0x0
    8000053c:	f44080e7          	jalr	-188(ra) # 8000047c <walk>
  if(pte == 0)
    80000540:	c105                	beqz	a0,80000560 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000542:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000544:	0117f693          	andi	a3,a5,17
    80000548:	4745                	li	a4,17
    return 0;
    8000054a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000054c:	00e68663          	beq	a3,a4,80000558 <walkaddr+0x36>
}
    80000550:	60a2                	ld	ra,8(sp)
    80000552:	6402                	ld	s0,0(sp)
    80000554:	0141                	addi	sp,sp,16
    80000556:	8082                	ret
  pa = PTE2PA(*pte);
    80000558:	00a7d513          	srli	a0,a5,0xa
    8000055c:	0532                	slli	a0,a0,0xc
  return pa;
    8000055e:	bfcd                	j	80000550 <walkaddr+0x2e>
    return 0;
    80000560:	4501                	li	a0,0
    80000562:	b7fd                	j	80000550 <walkaddr+0x2e>

0000000080000564 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000564:	715d                	addi	sp,sp,-80
    80000566:	e486                	sd	ra,72(sp)
    80000568:	e0a2                	sd	s0,64(sp)
    8000056a:	fc26                	sd	s1,56(sp)
    8000056c:	f84a                	sd	s2,48(sp)
    8000056e:	f44e                	sd	s3,40(sp)
    80000570:	f052                	sd	s4,32(sp)
    80000572:	ec56                	sd	s5,24(sp)
    80000574:	e85a                	sd	s6,16(sp)
    80000576:	e45e                	sd	s7,8(sp)
    80000578:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000057a:	c205                	beqz	a2,8000059a <mappages+0x36>
    8000057c:	8aaa                	mv	s5,a0
    8000057e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000580:	77fd                	lui	a5,0xfffff
    80000582:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000586:	15fd                	addi	a1,a1,-1
    80000588:	00c589b3          	add	s3,a1,a2
    8000058c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000590:	8952                	mv	s2,s4
    80000592:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000596:	6b85                	lui	s7,0x1
    80000598:	a015                	j	800005bc <mappages+0x58>
    panic("mappages: size");
    8000059a:	00009517          	auipc	a0,0x9
    8000059e:	abe50513          	addi	a0,a0,-1346 # 80009058 <etext+0x58>
    800005a2:	00006097          	auipc	ra,0x6
    800005a6:	6f0080e7          	jalr	1776(ra) # 80006c92 <panic>
      panic("mappages: remap");
    800005aa:	00009517          	auipc	a0,0x9
    800005ae:	abe50513          	addi	a0,a0,-1346 # 80009068 <etext+0x68>
    800005b2:	00006097          	auipc	ra,0x6
    800005b6:	6e0080e7          	jalr	1760(ra) # 80006c92 <panic>
    a += PGSIZE;
    800005ba:	995e                	add	s2,s2,s7
  for(;;){
    800005bc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c0:	4605                	li	a2,1
    800005c2:	85ca                	mv	a1,s2
    800005c4:	8556                	mv	a0,s5
    800005c6:	00000097          	auipc	ra,0x0
    800005ca:	eb6080e7          	jalr	-330(ra) # 8000047c <walk>
    800005ce:	cd19                	beqz	a0,800005ec <mappages+0x88>
    if(*pte & PTE_V)
    800005d0:	611c                	ld	a5,0(a0)
    800005d2:	8b85                	andi	a5,a5,1
    800005d4:	fbf9                	bnez	a5,800005aa <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d6:	80b1                	srli	s1,s1,0xc
    800005d8:	04aa                	slli	s1,s1,0xa
    800005da:	0164e4b3          	or	s1,s1,s6
    800005de:	0014e493          	ori	s1,s1,1
    800005e2:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e4:	fd391be3          	bne	s2,s3,800005ba <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005e8:	4501                	li	a0,0
    800005ea:	a011                	j	800005ee <mappages+0x8a>
      return -1;
    800005ec:	557d                	li	a0,-1
}
    800005ee:	60a6                	ld	ra,72(sp)
    800005f0:	6406                	ld	s0,64(sp)
    800005f2:	74e2                	ld	s1,56(sp)
    800005f4:	7942                	ld	s2,48(sp)
    800005f6:	79a2                	ld	s3,40(sp)
    800005f8:	7a02                	ld	s4,32(sp)
    800005fa:	6ae2                	ld	s5,24(sp)
    800005fc:	6b42                	ld	s6,16(sp)
    800005fe:	6ba2                	ld	s7,8(sp)
    80000600:	6161                	addi	sp,sp,80
    80000602:	8082                	ret

0000000080000604 <kvmmap>:
{
    80000604:	1141                	addi	sp,sp,-16
    80000606:	e406                	sd	ra,8(sp)
    80000608:	e022                	sd	s0,0(sp)
    8000060a:	0800                	addi	s0,sp,16
    8000060c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060e:	86b2                	mv	a3,a2
    80000610:	863e                	mv	a2,a5
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f52080e7          	jalr	-174(ra) # 80000564 <mappages>
    8000061a:	e509                	bnez	a0,80000624 <kvmmap+0x20>
}
    8000061c:	60a2                	ld	ra,8(sp)
    8000061e:	6402                	ld	s0,0(sp)
    80000620:	0141                	addi	sp,sp,16
    80000622:	8082                	ret
    panic("kvmmap");
    80000624:	00009517          	auipc	a0,0x9
    80000628:	a5450513          	addi	a0,a0,-1452 # 80009078 <etext+0x78>
    8000062c:	00006097          	auipc	ra,0x6
    80000630:	666080e7          	jalr	1638(ra) # 80006c92 <panic>

0000000080000634 <kvmmake>:
{
    80000634:	1101                	addi	sp,sp,-32
    80000636:	ec06                	sd	ra,24(sp)
    80000638:	e822                	sd	s0,16(sp)
    8000063a:	e426                	sd	s1,8(sp)
    8000063c:	e04a                	sd	s2,0(sp)
    8000063e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000640:	00000097          	auipc	ra,0x0
    80000644:	ad8080e7          	jalr	-1320(ra) # 80000118 <kalloc>
    80000648:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000064a:	6605                	lui	a2,0x1
    8000064c:	4581                	li	a1,0
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	b2a080e7          	jalr	-1238(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000656:	4719                	li	a4,6
    80000658:	6685                	lui	a3,0x1
    8000065a:	10000637          	lui	a2,0x10000
    8000065e:	100005b7          	lui	a1,0x10000
    80000662:	8526                	mv	a0,s1
    80000664:	00000097          	auipc	ra,0x0
    80000668:	fa0080e7          	jalr	-96(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066c:	4719                	li	a4,6
    8000066e:	6685                	lui	a3,0x1
    80000670:	10001637          	lui	a2,0x10001
    80000674:	100015b7          	lui	a1,0x10001
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f8a080e7          	jalr	-118(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000682:	4719                	li	a4,6
    80000684:	100006b7          	lui	a3,0x10000
    80000688:	30000637          	lui	a2,0x30000
    8000068c:	300005b7          	lui	a1,0x30000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f72080e7          	jalr	-142(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	000206b7          	lui	a3,0x20
    800006a0:	40000637          	lui	a2,0x40000
    800006a4:	400005b7          	lui	a1,0x40000
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f5a080e7          	jalr	-166(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b2:	4719                	li	a4,6
    800006b4:	004006b7          	lui	a3,0x400
    800006b8:	0c000637          	lui	a2,0xc000
    800006bc:	0c0005b7          	lui	a1,0xc000
    800006c0:	8526                	mv	a0,s1
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	f42080e7          	jalr	-190(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ca:	00009917          	auipc	s2,0x9
    800006ce:	93690913          	addi	s2,s2,-1738 # 80009000 <etext>
    800006d2:	4729                	li	a4,10
    800006d4:	80009697          	auipc	a3,0x80009
    800006d8:	92c68693          	addi	a3,a3,-1748 # 9000 <_entry-0x7fff7000>
    800006dc:	4605                	li	a2,1
    800006de:	067e                	slli	a2,a2,0x1f
    800006e0:	85b2                	mv	a1,a2
    800006e2:	8526                	mv	a0,s1
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	f20080e7          	jalr	-224(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ec:	4719                	li	a4,6
    800006ee:	46c5                	li	a3,17
    800006f0:	06ee                	slli	a3,a3,0x1b
    800006f2:	412686b3          	sub	a3,a3,s2
    800006f6:	864a                	mv	a2,s2
    800006f8:	85ca                	mv	a1,s2
    800006fa:	8526                	mv	a0,s1
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	f08080e7          	jalr	-248(ra) # 80000604 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000704:	4729                	li	a4,10
    80000706:	6685                	lui	a3,0x1
    80000708:	00008617          	auipc	a2,0x8
    8000070c:	8f860613          	addi	a2,a2,-1800 # 80008000 <_trampoline>
    80000710:	040005b7          	lui	a1,0x4000
    80000714:	15fd                	addi	a1,a1,-1
    80000716:	05b2                	slli	a1,a1,0xc
    80000718:	8526                	mv	a0,s1
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	eea080e7          	jalr	-278(ra) # 80000604 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000722:	8526                	mv	a0,s1
    80000724:	00000097          	auipc	ra,0x0
    80000728:	652080e7          	jalr	1618(ra) # 80000d76 <proc_mapstacks>
}
    8000072c:	8526                	mv	a0,s1
    8000072e:	60e2                	ld	ra,24(sp)
    80000730:	6442                	ld	s0,16(sp)
    80000732:	64a2                	ld	s1,8(sp)
    80000734:	6902                	ld	s2,0(sp)
    80000736:	6105                	addi	sp,sp,32
    80000738:	8082                	ret

000000008000073a <kvminit>:
{
    8000073a:	1141                	addi	sp,sp,-16
    8000073c:	e406                	sd	ra,8(sp)
    8000073e:	e022                	sd	s0,0(sp)
    80000740:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000742:	00000097          	auipc	ra,0x0
    80000746:	ef2080e7          	jalr	-270(ra) # 80000634 <kvmmake>
    8000074a:	00009797          	auipc	a5,0x9
    8000074e:	1ea7bf23          	sd	a0,510(a5) # 80009948 <kernel_pagetable>
}
    80000752:	60a2                	ld	ra,8(sp)
    80000754:	6402                	ld	s0,0(sp)
    80000756:	0141                	addi	sp,sp,16
    80000758:	8082                	ret

000000008000075a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000075a:	715d                	addi	sp,sp,-80
    8000075c:	e486                	sd	ra,72(sp)
    8000075e:	e0a2                	sd	s0,64(sp)
    80000760:	fc26                	sd	s1,56(sp)
    80000762:	f84a                	sd	s2,48(sp)
    80000764:	f44e                	sd	s3,40(sp)
    80000766:	f052                	sd	s4,32(sp)
    80000768:	ec56                	sd	s5,24(sp)
    8000076a:	e85a                	sd	s6,16(sp)
    8000076c:	e45e                	sd	s7,8(sp)
    8000076e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000770:	03459793          	slli	a5,a1,0x34
    80000774:	e795                	bnez	a5,800007a0 <uvmunmap+0x46>
    80000776:	8a2a                	mv	s4,a0
    80000778:	892e                	mv	s2,a1
    8000077a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	0632                	slli	a2,a2,0xc
    8000077e:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000782:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	6b05                	lui	s6,0x1
    80000786:	0935e263          	bltu	a1,s3,8000080a <uvmunmap+0xb0>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000078a:	60a6                	ld	ra,72(sp)
    8000078c:	6406                	ld	s0,64(sp)
    8000078e:	74e2                	ld	s1,56(sp)
    80000790:	7942                	ld	s2,48(sp)
    80000792:	79a2                	ld	s3,40(sp)
    80000794:	7a02                	ld	s4,32(sp)
    80000796:	6ae2                	ld	s5,24(sp)
    80000798:	6b42                	ld	s6,16(sp)
    8000079a:	6ba2                	ld	s7,8(sp)
    8000079c:	6161                	addi	sp,sp,80
    8000079e:	8082                	ret
    panic("uvmunmap: not aligned");
    800007a0:	00009517          	auipc	a0,0x9
    800007a4:	8e050513          	addi	a0,a0,-1824 # 80009080 <etext+0x80>
    800007a8:	00006097          	auipc	ra,0x6
    800007ac:	4ea080e7          	jalr	1258(ra) # 80006c92 <panic>
      panic("uvmunmap: walk");
    800007b0:	00009517          	auipc	a0,0x9
    800007b4:	8e850513          	addi	a0,a0,-1816 # 80009098 <etext+0x98>
    800007b8:	00006097          	auipc	ra,0x6
    800007bc:	4da080e7          	jalr	1242(ra) # 80006c92 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007c0:	862a                	mv	a2,a0
    800007c2:	85ca                	mv	a1,s2
    800007c4:	00009517          	auipc	a0,0x9
    800007c8:	8e450513          	addi	a0,a0,-1820 # 800090a8 <etext+0xa8>
    800007cc:	00006097          	auipc	ra,0x6
    800007d0:	510080e7          	jalr	1296(ra) # 80006cdc <printf>
      panic("uvmunmap: not mapped");
    800007d4:	00009517          	auipc	a0,0x9
    800007d8:	8e450513          	addi	a0,a0,-1820 # 800090b8 <etext+0xb8>
    800007dc:	00006097          	auipc	ra,0x6
    800007e0:	4b6080e7          	jalr	1206(ra) # 80006c92 <panic>
      panic("uvmunmap: not a leaf");
    800007e4:	00009517          	auipc	a0,0x9
    800007e8:	8ec50513          	addi	a0,a0,-1812 # 800090d0 <etext+0xd0>
    800007ec:	00006097          	auipc	ra,0x6
    800007f0:	4a6080e7          	jalr	1190(ra) # 80006c92 <panic>
      uint64 pa = PTE2PA(*pte);
    800007f4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007f6:	0532                	slli	a0,a0,0xc
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	824080e7          	jalr	-2012(ra) # 8000001c <kfree>
    *pte = 0;
    80000800:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000804:	995a                	add	s2,s2,s6
    80000806:	f93972e3          	bgeu	s2,s3,8000078a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000080a:	4601                	li	a2,0
    8000080c:	85ca                	mv	a1,s2
    8000080e:	8552                	mv	a0,s4
    80000810:	00000097          	auipc	ra,0x0
    80000814:	c6c080e7          	jalr	-916(ra) # 8000047c <walk>
    80000818:	84aa                	mv	s1,a0
    8000081a:	d959                	beqz	a0,800007b0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    8000081c:	6108                	ld	a0,0(a0)
    8000081e:	00157793          	andi	a5,a0,1
    80000822:	dfd9                	beqz	a5,800007c0 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000824:	3ff57793          	andi	a5,a0,1023
    80000828:	fb778ee3          	beq	a5,s7,800007e4 <uvmunmap+0x8a>
    if(do_free){
    8000082c:	fc0a8ae3          	beqz	s5,80000800 <uvmunmap+0xa6>
    80000830:	b7d1                	j	800007f4 <uvmunmap+0x9a>

0000000080000832 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000832:	1101                	addi	sp,sp,-32
    80000834:	ec06                	sd	ra,24(sp)
    80000836:	e822                	sd	s0,16(sp)
    80000838:	e426                	sd	s1,8(sp)
    8000083a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	8dc080e7          	jalr	-1828(ra) # 80000118 <kalloc>
    80000844:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000846:	c519                	beqz	a0,80000854 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000848:	6605                	lui	a2,0x1
    8000084a:	4581                	li	a1,0
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	92c080e7          	jalr	-1748(ra) # 80000178 <memset>
  return pagetable;
}
    80000854:	8526                	mv	a0,s1
    80000856:	60e2                	ld	ra,24(sp)
    80000858:	6442                	ld	s0,16(sp)
    8000085a:	64a2                	ld	s1,8(sp)
    8000085c:	6105                	addi	sp,sp,32
    8000085e:	8082                	ret

0000000080000860 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000860:	7179                	addi	sp,sp,-48
    80000862:	f406                	sd	ra,40(sp)
    80000864:	f022                	sd	s0,32(sp)
    80000866:	ec26                	sd	s1,24(sp)
    80000868:	e84a                	sd	s2,16(sp)
    8000086a:	e44e                	sd	s3,8(sp)
    8000086c:	e052                	sd	s4,0(sp)
    8000086e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000870:	6785                	lui	a5,0x1
    80000872:	04f67863          	bgeu	a2,a5,800008c2 <uvmfirst+0x62>
    80000876:	8a2a                	mv	s4,a0
    80000878:	89ae                	mv	s3,a1
    8000087a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000087c:	00000097          	auipc	ra,0x0
    80000880:	89c080e7          	jalr	-1892(ra) # 80000118 <kalloc>
    80000884:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000886:	6605                	lui	a2,0x1
    80000888:	4581                	li	a1,0
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	8ee080e7          	jalr	-1810(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000892:	4779                	li	a4,30
    80000894:	86ca                	mv	a3,s2
    80000896:	6605                	lui	a2,0x1
    80000898:	4581                	li	a1,0
    8000089a:	8552                	mv	a0,s4
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	cc8080e7          	jalr	-824(ra) # 80000564 <mappages>
  memmove(mem, src, sz);
    800008a4:	8626                	mv	a2,s1
    800008a6:	85ce                	mv	a1,s3
    800008a8:	854a                	mv	a0,s2
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	92e080e7          	jalr	-1746(ra) # 800001d8 <memmove>
}
    800008b2:	70a2                	ld	ra,40(sp)
    800008b4:	7402                	ld	s0,32(sp)
    800008b6:	64e2                	ld	s1,24(sp)
    800008b8:	6942                	ld	s2,16(sp)
    800008ba:	69a2                	ld	s3,8(sp)
    800008bc:	6a02                	ld	s4,0(sp)
    800008be:	6145                	addi	sp,sp,48
    800008c0:	8082                	ret
    panic("uvmfirst: more than a page");
    800008c2:	00009517          	auipc	a0,0x9
    800008c6:	82650513          	addi	a0,a0,-2010 # 800090e8 <etext+0xe8>
    800008ca:	00006097          	auipc	ra,0x6
    800008ce:	3c8080e7          	jalr	968(ra) # 80006c92 <panic>

00000000800008d2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008d2:	1101                	addi	sp,sp,-32
    800008d4:	ec06                	sd	ra,24(sp)
    800008d6:	e822                	sd	s0,16(sp)
    800008d8:	e426                	sd	s1,8(sp)
    800008da:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008dc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008de:	00b67d63          	bgeu	a2,a1,800008f8 <uvmdealloc+0x26>
    800008e2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008e4:	6785                	lui	a5,0x1
    800008e6:	17fd                	addi	a5,a5,-1
    800008e8:	00f60733          	add	a4,a2,a5
    800008ec:	767d                	lui	a2,0xfffff
    800008ee:	8f71                	and	a4,a4,a2
    800008f0:	97ae                	add	a5,a5,a1
    800008f2:	8ff1                	and	a5,a5,a2
    800008f4:	00f76863          	bltu	a4,a5,80000904 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008f8:	8526                	mv	a0,s1
    800008fa:	60e2                	ld	ra,24(sp)
    800008fc:	6442                	ld	s0,16(sp)
    800008fe:	64a2                	ld	s1,8(sp)
    80000900:	6105                	addi	sp,sp,32
    80000902:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000904:	8f99                	sub	a5,a5,a4
    80000906:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000908:	4685                	li	a3,1
    8000090a:	0007861b          	sext.w	a2,a5
    8000090e:	85ba                	mv	a1,a4
    80000910:	00000097          	auipc	ra,0x0
    80000914:	e4a080e7          	jalr	-438(ra) # 8000075a <uvmunmap>
    80000918:	b7c5                	j	800008f8 <uvmdealloc+0x26>

000000008000091a <uvmalloc>:
  if(newsz < oldsz)
    8000091a:	0ab66563          	bltu	a2,a1,800009c4 <uvmalloc+0xaa>
{
    8000091e:	7139                	addi	sp,sp,-64
    80000920:	fc06                	sd	ra,56(sp)
    80000922:	f822                	sd	s0,48(sp)
    80000924:	f426                	sd	s1,40(sp)
    80000926:	f04a                	sd	s2,32(sp)
    80000928:	ec4e                	sd	s3,24(sp)
    8000092a:	e852                	sd	s4,16(sp)
    8000092c:	e456                	sd	s5,8(sp)
    8000092e:	e05a                	sd	s6,0(sp)
    80000930:	0080                	addi	s0,sp,64
    80000932:	8aaa                	mv	s5,a0
    80000934:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000936:	6985                	lui	s3,0x1
    80000938:	19fd                	addi	s3,s3,-1
    8000093a:	95ce                	add	a1,a1,s3
    8000093c:	79fd                	lui	s3,0xfffff
    8000093e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	08c9f363          	bgeu	s3,a2,800009c8 <uvmalloc+0xae>
    80000946:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000948:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000094c:	fffff097          	auipc	ra,0xfffff
    80000950:	7cc080e7          	jalr	1996(ra) # 80000118 <kalloc>
    80000954:	84aa                	mv	s1,a0
    if(mem == 0){
    80000956:	c51d                	beqz	a0,80000984 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000958:	6605                	lui	a2,0x1
    8000095a:	4581                	li	a1,0
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	81c080e7          	jalr	-2020(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000964:	875a                	mv	a4,s6
    80000966:	86a6                	mv	a3,s1
    80000968:	6605                	lui	a2,0x1
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	bf6080e7          	jalr	-1034(ra) # 80000564 <mappages>
    80000976:	e90d                	bnez	a0,800009a8 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000978:	6785                	lui	a5,0x1
    8000097a:	993e                	add	s2,s2,a5
    8000097c:	fd4968e3          	bltu	s2,s4,8000094c <uvmalloc+0x32>
  return newsz;
    80000980:	8552                	mv	a0,s4
    80000982:	a809                	j	80000994 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000984:	864e                	mv	a2,s3
    80000986:	85ca                	mv	a1,s2
    80000988:	8556                	mv	a0,s5
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	f48080e7          	jalr	-184(ra) # 800008d2 <uvmdealloc>
      return 0;
    80000992:	4501                	li	a0,0
}
    80000994:	70e2                	ld	ra,56(sp)
    80000996:	7442                	ld	s0,48(sp)
    80000998:	74a2                	ld	s1,40(sp)
    8000099a:	7902                	ld	s2,32(sp)
    8000099c:	69e2                	ld	s3,24(sp)
    8000099e:	6a42                	ld	s4,16(sp)
    800009a0:	6aa2                	ld	s5,8(sp)
    800009a2:	6b02                	ld	s6,0(sp)
    800009a4:	6121                	addi	sp,sp,64
    800009a6:	8082                	ret
      kfree(mem);
    800009a8:	8526                	mv	a0,s1
    800009aa:	fffff097          	auipc	ra,0xfffff
    800009ae:	672080e7          	jalr	1650(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009b2:	864e                	mv	a2,s3
    800009b4:	85ca                	mv	a1,s2
    800009b6:	8556                	mv	a0,s5
    800009b8:	00000097          	auipc	ra,0x0
    800009bc:	f1a080e7          	jalr	-230(ra) # 800008d2 <uvmdealloc>
      return 0;
    800009c0:	4501                	li	a0,0
    800009c2:	bfc9                	j	80000994 <uvmalloc+0x7a>
    return oldsz;
    800009c4:	852e                	mv	a0,a1
}
    800009c6:	8082                	ret
  return newsz;
    800009c8:	8532                	mv	a0,a2
    800009ca:	b7e9                	j	80000994 <uvmalloc+0x7a>

00000000800009cc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009cc:	7179                	addi	sp,sp,-48
    800009ce:	f406                	sd	ra,40(sp)
    800009d0:	f022                	sd	s0,32(sp)
    800009d2:	ec26                	sd	s1,24(sp)
    800009d4:	e84a                	sd	s2,16(sp)
    800009d6:	e44e                	sd	s3,8(sp)
    800009d8:	e052                	sd	s4,0(sp)
    800009da:	1800                	addi	s0,sp,48
    800009dc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009de:	84aa                	mv	s1,a0
    800009e0:	6905                	lui	s2,0x1
    800009e2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e4:	4985                	li	s3,1
    800009e6:	a821                	j	800009fe <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009e8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009ea:	0532                	slli	a0,a0,0xc
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	fe0080e7          	jalr	-32(ra) # 800009cc <freewalk>
      pagetable[i] = 0;
    800009f4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009f8:	04a1                	addi	s1,s1,8
    800009fa:	03248163          	beq	s1,s2,80000a1c <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009fe:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a00:	00f57793          	andi	a5,a0,15
    80000a04:	ff3782e3          	beq	a5,s3,800009e8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a08:	8905                	andi	a0,a0,1
    80000a0a:	d57d                	beqz	a0,800009f8 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a0c:	00008517          	auipc	a0,0x8
    80000a10:	6fc50513          	addi	a0,a0,1788 # 80009108 <etext+0x108>
    80000a14:	00006097          	auipc	ra,0x6
    80000a18:	27e080e7          	jalr	638(ra) # 80006c92 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a1c:	8552                	mv	a0,s4
    80000a1e:	fffff097          	auipc	ra,0xfffff
    80000a22:	5fe080e7          	jalr	1534(ra) # 8000001c <kfree>
}
    80000a26:	70a2                	ld	ra,40(sp)
    80000a28:	7402                	ld	s0,32(sp)
    80000a2a:	64e2                	ld	s1,24(sp)
    80000a2c:	6942                	ld	s2,16(sp)
    80000a2e:	69a2                	ld	s3,8(sp)
    80000a30:	6a02                	ld	s4,0(sp)
    80000a32:	6145                	addi	sp,sp,48
    80000a34:	8082                	ret

0000000080000a36 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a36:	1101                	addi	sp,sp,-32
    80000a38:	ec06                	sd	ra,24(sp)
    80000a3a:	e822                	sd	s0,16(sp)
    80000a3c:	e426                	sd	s1,8(sp)
    80000a3e:	1000                	addi	s0,sp,32
    80000a40:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a42:	e999                	bnez	a1,80000a58 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a44:	8526                	mv	a0,s1
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	f86080e7          	jalr	-122(ra) # 800009cc <freewalk>
}
    80000a4e:	60e2                	ld	ra,24(sp)
    80000a50:	6442                	ld	s0,16(sp)
    80000a52:	64a2                	ld	s1,8(sp)
    80000a54:	6105                	addi	sp,sp,32
    80000a56:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a58:	6605                	lui	a2,0x1
    80000a5a:	167d                	addi	a2,a2,-1
    80000a5c:	962e                	add	a2,a2,a1
    80000a5e:	4685                	li	a3,1
    80000a60:	8231                	srli	a2,a2,0xc
    80000a62:	4581                	li	a1,0
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	cf6080e7          	jalr	-778(ra) # 8000075a <uvmunmap>
    80000a6c:	bfe1                	j	80000a44 <uvmfree+0xe>

0000000080000a6e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	c679                	beqz	a2,80000b3c <uvmcopy+0xce>
{
    80000a70:	715d                	addi	sp,sp,-80
    80000a72:	e486                	sd	ra,72(sp)
    80000a74:	e0a2                	sd	s0,64(sp)
    80000a76:	fc26                	sd	s1,56(sp)
    80000a78:	f84a                	sd	s2,48(sp)
    80000a7a:	f44e                	sd	s3,40(sp)
    80000a7c:	f052                	sd	s4,32(sp)
    80000a7e:	ec56                	sd	s5,24(sp)
    80000a80:	e85a                	sd	s6,16(sp)
    80000a82:	e45e                	sd	s7,8(sp)
    80000a84:	0880                	addi	s0,sp,80
    80000a86:	8b2a                	mv	s6,a0
    80000a88:	8aae                	mv	s5,a1
    80000a8a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a8c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a8e:	4601                	li	a2,0
    80000a90:	85ce                	mv	a1,s3
    80000a92:	855a                	mv	a0,s6
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	9e8080e7          	jalr	-1560(ra) # 8000047c <walk>
    80000a9c:	c531                	beqz	a0,80000ae8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a9e:	6118                	ld	a4,0(a0)
    80000aa0:	00177793          	andi	a5,a4,1
    80000aa4:	cbb1                	beqz	a5,80000af8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aa6:	00a75593          	srli	a1,a4,0xa
    80000aaa:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000aae:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ab2:	fffff097          	auipc	ra,0xfffff
    80000ab6:	666080e7          	jalr	1638(ra) # 80000118 <kalloc>
    80000aba:	892a                	mv	s2,a0
    80000abc:	c939                	beqz	a0,80000b12 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000abe:	6605                	lui	a2,0x1
    80000ac0:	85de                	mv	a1,s7
    80000ac2:	fffff097          	auipc	ra,0xfffff
    80000ac6:	716080e7          	jalr	1814(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aca:	8726                	mv	a4,s1
    80000acc:	86ca                	mv	a3,s2
    80000ace:	6605                	lui	a2,0x1
    80000ad0:	85ce                	mv	a1,s3
    80000ad2:	8556                	mv	a0,s5
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	a90080e7          	jalr	-1392(ra) # 80000564 <mappages>
    80000adc:	e515                	bnez	a0,80000b08 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ade:	6785                	lui	a5,0x1
    80000ae0:	99be                	add	s3,s3,a5
    80000ae2:	fb49e6e3          	bltu	s3,s4,80000a8e <uvmcopy+0x20>
    80000ae6:	a081                	j	80000b26 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ae8:	00008517          	auipc	a0,0x8
    80000aec:	63050513          	addi	a0,a0,1584 # 80009118 <etext+0x118>
    80000af0:	00006097          	auipc	ra,0x6
    80000af4:	1a2080e7          	jalr	418(ra) # 80006c92 <panic>
      panic("uvmcopy: page not present");
    80000af8:	00008517          	auipc	a0,0x8
    80000afc:	64050513          	addi	a0,a0,1600 # 80009138 <etext+0x138>
    80000b00:	00006097          	auipc	ra,0x6
    80000b04:	192080e7          	jalr	402(ra) # 80006c92 <panic>
      kfree(mem);
    80000b08:	854a                	mv	a0,s2
    80000b0a:	fffff097          	auipc	ra,0xfffff
    80000b0e:	512080e7          	jalr	1298(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b12:	4685                	li	a3,1
    80000b14:	00c9d613          	srli	a2,s3,0xc
    80000b18:	4581                	li	a1,0
    80000b1a:	8556                	mv	a0,s5
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	c3e080e7          	jalr	-962(ra) # 8000075a <uvmunmap>
  return -1;
    80000b24:	557d                	li	a0,-1
}
    80000b26:	60a6                	ld	ra,72(sp)
    80000b28:	6406                	ld	s0,64(sp)
    80000b2a:	74e2                	ld	s1,56(sp)
    80000b2c:	7942                	ld	s2,48(sp)
    80000b2e:	79a2                	ld	s3,40(sp)
    80000b30:	7a02                	ld	s4,32(sp)
    80000b32:	6ae2                	ld	s5,24(sp)
    80000b34:	6b42                	ld	s6,16(sp)
    80000b36:	6ba2                	ld	s7,8(sp)
    80000b38:	6161                	addi	sp,sp,80
    80000b3a:	8082                	ret
  return 0;
    80000b3c:	4501                	li	a0,0
}
    80000b3e:	8082                	ret

0000000080000b40 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b40:	1141                	addi	sp,sp,-16
    80000b42:	e406                	sd	ra,8(sp)
    80000b44:	e022                	sd	s0,0(sp)
    80000b46:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b48:	4601                	li	a2,0
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	932080e7          	jalr	-1742(ra) # 8000047c <walk>
  if(pte == 0)
    80000b52:	c901                	beqz	a0,80000b62 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b54:	611c                	ld	a5,0(a0)
    80000b56:	9bbd                	andi	a5,a5,-17
    80000b58:	e11c                	sd	a5,0(a0)
}
    80000b5a:	60a2                	ld	ra,8(sp)
    80000b5c:	6402                	ld	s0,0(sp)
    80000b5e:	0141                	addi	sp,sp,16
    80000b60:	8082                	ret
    panic("uvmclear");
    80000b62:	00008517          	auipc	a0,0x8
    80000b66:	5f650513          	addi	a0,a0,1526 # 80009158 <etext+0x158>
    80000b6a:	00006097          	auipc	ra,0x6
    80000b6e:	128080e7          	jalr	296(ra) # 80006c92 <panic>

0000000080000b72 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b72:	cad1                	beqz	a3,80000c06 <copyout+0x94>
{
    80000b74:	711d                	addi	sp,sp,-96
    80000b76:	ec86                	sd	ra,88(sp)
    80000b78:	e8a2                	sd	s0,80(sp)
    80000b7a:	e4a6                	sd	s1,72(sp)
    80000b7c:	e0ca                	sd	s2,64(sp)
    80000b7e:	fc4e                	sd	s3,56(sp)
    80000b80:	f852                	sd	s4,48(sp)
    80000b82:	f456                	sd	s5,40(sp)
    80000b84:	f05a                	sd	s6,32(sp)
    80000b86:	ec5e                	sd	s7,24(sp)
    80000b88:	e862                	sd	s8,16(sp)
    80000b8a:	e466                	sd	s9,8(sp)
    80000b8c:	1080                	addi	s0,sp,96
    80000b8e:	8b2a                	mv	s6,a0
    80000b90:	8a2e                	mv	s4,a1
    80000b92:	8ab2                	mv	s5,a2
    80000b94:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b96:	74fd                	lui	s1,0xfffff
    80000b98:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000b9a:	57fd                	li	a5,-1
    80000b9c:	83e9                	srli	a5,a5,0x1a
    80000b9e:	0697e663          	bltu	a5,s1,80000c0a <copyout+0x98>
    80000ba2:	6c05                	lui	s8,0x1
    80000ba4:	8bbe                	mv	s7,a5
    80000ba6:	a025                	j	80000bce <copyout+0x5c>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ba8:	409a04b3          	sub	s1,s4,s1
    80000bac:	0009061b          	sext.w	a2,s2
    80000bb0:	85d6                	mv	a1,s5
    80000bb2:	9526                	add	a0,a0,s1
    80000bb4:	fffff097          	auipc	ra,0xfffff
    80000bb8:	624080e7          	jalr	1572(ra) # 800001d8 <memmove>

    len -= n;
    80000bbc:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bc0:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000bc2:	04098063          	beqz	s3,80000c02 <copyout+0x90>
    if (va0 >= MAXVA)
    80000bc6:	059be463          	bltu	s7,s9,80000c0e <copyout+0x9c>
    va0 = PGROUNDDOWN(dstva);
    80000bca:	84e6                	mv	s1,s9
    dstva = va0 + PGSIZE;
    80000bcc:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000bce:	4601                	li	a2,0
    80000bd0:	85a6                	mv	a1,s1
    80000bd2:	855a                	mv	a0,s6
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	8a8080e7          	jalr	-1880(ra) # 8000047c <walk>
    80000bdc:	c91d                	beqz	a0,80000c12 <copyout+0xa0>
    if((*pte & PTE_W) == 0)
    80000bde:	611c                	ld	a5,0(a0)
    80000be0:	8b91                	andi	a5,a5,4
    80000be2:	c7b1                	beqz	a5,80000c2e <copyout+0xbc>
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85a6                	mv	a1,s1
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	93a080e7          	jalr	-1734(ra) # 80000522 <walkaddr>
    if(pa0 == 0)
    80000bf0:	c129                	beqz	a0,80000c32 <copyout+0xc0>
    n = PGSIZE - (dstva - va0);
    80000bf2:	01848cb3          	add	s9,s1,s8
    80000bf6:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000bfa:	fb29f7e3          	bgeu	s3,s2,80000ba8 <copyout+0x36>
    80000bfe:	894e                	mv	s2,s3
    80000c00:	b765                	j	80000ba8 <copyout+0x36>
  }
  return 0;
    80000c02:	4501                	li	a0,0
    80000c04:	a801                	j	80000c14 <copyout+0xa2>
    80000c06:	4501                	li	a0,0
}
    80000c08:	8082                	ret
      return -1;
    80000c0a:	557d                	li	a0,-1
    80000c0c:	a021                	j	80000c14 <copyout+0xa2>
    80000c0e:	557d                	li	a0,-1
    80000c10:	a011                	j	80000c14 <copyout+0xa2>
      return -1;
    80000c12:	557d                	li	a0,-1
}
    80000c14:	60e6                	ld	ra,88(sp)
    80000c16:	6446                	ld	s0,80(sp)
    80000c18:	64a6                	ld	s1,72(sp)
    80000c1a:	6906                	ld	s2,64(sp)
    80000c1c:	79e2                	ld	s3,56(sp)
    80000c1e:	7a42                	ld	s4,48(sp)
    80000c20:	7aa2                	ld	s5,40(sp)
    80000c22:	7b02                	ld	s6,32(sp)
    80000c24:	6be2                	ld	s7,24(sp)
    80000c26:	6c42                	ld	s8,16(sp)
    80000c28:	6ca2                	ld	s9,8(sp)
    80000c2a:	6125                	addi	sp,sp,96
    80000c2c:	8082                	ret
      return -1;
    80000c2e:	557d                	li	a0,-1
    80000c30:	b7d5                	j	80000c14 <copyout+0xa2>
      return -1;
    80000c32:	557d                	li	a0,-1
    80000c34:	b7c5                	j	80000c14 <copyout+0xa2>

0000000080000c36 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000c36:	c6bd                	beqz	a3,80000ca4 <copyin+0x6e>
{
    80000c38:	715d                	addi	sp,sp,-80
    80000c3a:	e486                	sd	ra,72(sp)
    80000c3c:	e0a2                	sd	s0,64(sp)
    80000c3e:	fc26                	sd	s1,56(sp)
    80000c40:	f84a                	sd	s2,48(sp)
    80000c42:	f44e                	sd	s3,40(sp)
    80000c44:	f052                	sd	s4,32(sp)
    80000c46:	ec56                	sd	s5,24(sp)
    80000c48:	e85a                	sd	s6,16(sp)
    80000c4a:	e45e                	sd	s7,8(sp)
    80000c4c:	e062                	sd	s8,0(sp)
    80000c4e:	0880                	addi	s0,sp,80
    80000c50:	8b2a                	mv	s6,a0
    80000c52:	8a2e                	mv	s4,a1
    80000c54:	8c32                	mv	s8,a2
    80000c56:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c58:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c5a:	6a85                	lui	s5,0x1
    80000c5c:	a015                	j	80000c80 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c5e:	9562                	add	a0,a0,s8
    80000c60:	0004861b          	sext.w	a2,s1
    80000c64:	412505b3          	sub	a1,a0,s2
    80000c68:	8552                	mv	a0,s4
    80000c6a:	fffff097          	auipc	ra,0xfffff
    80000c6e:	56e080e7          	jalr	1390(ra) # 800001d8 <memmove>

    len -= n;
    80000c72:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c76:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c78:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c7c:	02098263          	beqz	s3,80000ca0 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c80:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c84:	85ca                	mv	a1,s2
    80000c86:	855a                	mv	a0,s6
    80000c88:	00000097          	auipc	ra,0x0
    80000c8c:	89a080e7          	jalr	-1894(ra) # 80000522 <walkaddr>
    if(pa0 == 0)
    80000c90:	cd01                	beqz	a0,80000ca8 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c92:	418904b3          	sub	s1,s2,s8
    80000c96:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c98:	fc99f3e3          	bgeu	s3,s1,80000c5e <copyin+0x28>
    80000c9c:	84ce                	mv	s1,s3
    80000c9e:	b7c1                	j	80000c5e <copyin+0x28>
  }
  return 0;
    80000ca0:	4501                	li	a0,0
    80000ca2:	a021                	j	80000caa <copyin+0x74>
    80000ca4:	4501                	li	a0,0
}
    80000ca6:	8082                	ret
      return -1;
    80000ca8:	557d                	li	a0,-1
}
    80000caa:	60a6                	ld	ra,72(sp)
    80000cac:	6406                	ld	s0,64(sp)
    80000cae:	74e2                	ld	s1,56(sp)
    80000cb0:	7942                	ld	s2,48(sp)
    80000cb2:	79a2                	ld	s3,40(sp)
    80000cb4:	7a02                	ld	s4,32(sp)
    80000cb6:	6ae2                	ld	s5,24(sp)
    80000cb8:	6b42                	ld	s6,16(sp)
    80000cba:	6ba2                	ld	s7,8(sp)
    80000cbc:	6c02                	ld	s8,0(sp)
    80000cbe:	6161                	addi	sp,sp,80
    80000cc0:	8082                	ret

0000000080000cc2 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cc2:	c6c5                	beqz	a3,80000d6a <copyinstr+0xa8>
{
    80000cc4:	715d                	addi	sp,sp,-80
    80000cc6:	e486                	sd	ra,72(sp)
    80000cc8:	e0a2                	sd	s0,64(sp)
    80000cca:	fc26                	sd	s1,56(sp)
    80000ccc:	f84a                	sd	s2,48(sp)
    80000cce:	f44e                	sd	s3,40(sp)
    80000cd0:	f052                	sd	s4,32(sp)
    80000cd2:	ec56                	sd	s5,24(sp)
    80000cd4:	e85a                	sd	s6,16(sp)
    80000cd6:	e45e                	sd	s7,8(sp)
    80000cd8:	0880                	addi	s0,sp,80
    80000cda:	8a2a                	mv	s4,a0
    80000cdc:	8b2e                	mv	s6,a1
    80000cde:	8bb2                	mv	s7,a2
    80000ce0:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ce2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ce4:	6985                	lui	s3,0x1
    80000ce6:	a035                	j	80000d12 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ce8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cec:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cee:	0017b793          	seqz	a5,a5
    80000cf2:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cf6:	60a6                	ld	ra,72(sp)
    80000cf8:	6406                	ld	s0,64(sp)
    80000cfa:	74e2                	ld	s1,56(sp)
    80000cfc:	7942                	ld	s2,48(sp)
    80000cfe:	79a2                	ld	s3,40(sp)
    80000d00:	7a02                	ld	s4,32(sp)
    80000d02:	6ae2                	ld	s5,24(sp)
    80000d04:	6b42                	ld	s6,16(sp)
    80000d06:	6ba2                	ld	s7,8(sp)
    80000d08:	6161                	addi	sp,sp,80
    80000d0a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d0c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d10:	c8a9                	beqz	s1,80000d62 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d12:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d16:	85ca                	mv	a1,s2
    80000d18:	8552                	mv	a0,s4
    80000d1a:	00000097          	auipc	ra,0x0
    80000d1e:	808080e7          	jalr	-2040(ra) # 80000522 <walkaddr>
    if(pa0 == 0)
    80000d22:	c131                	beqz	a0,80000d66 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d24:	41790833          	sub	a6,s2,s7
    80000d28:	984e                	add	a6,a6,s3
    if(n > max)
    80000d2a:	0104f363          	bgeu	s1,a6,80000d30 <copyinstr+0x6e>
    80000d2e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d30:	955e                	add	a0,a0,s7
    80000d32:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d36:	fc080be3          	beqz	a6,80000d0c <copyinstr+0x4a>
    80000d3a:	985a                	add	a6,a6,s6
    80000d3c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d3e:	41650633          	sub	a2,a0,s6
    80000d42:	14fd                	addi	s1,s1,-1
    80000d44:	9b26                	add	s6,s6,s1
    80000d46:	00f60733          	add	a4,a2,a5
    80000d4a:	00074703          	lbu	a4,0(a4)
    80000d4e:	df49                	beqz	a4,80000ce8 <copyinstr+0x26>
        *dst = *p;
    80000d50:	00e78023          	sb	a4,0(a5)
      --max;
    80000d54:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d58:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d5a:	ff0796e3          	bne	a5,a6,80000d46 <copyinstr+0x84>
      dst++;
    80000d5e:	8b42                	mv	s6,a6
    80000d60:	b775                	j	80000d0c <copyinstr+0x4a>
    80000d62:	4781                	li	a5,0
    80000d64:	b769                	j	80000cee <copyinstr+0x2c>
      return -1;
    80000d66:	557d                	li	a0,-1
    80000d68:	b779                	j	80000cf6 <copyinstr+0x34>
  int got_null = 0;
    80000d6a:	4781                	li	a5,0
  if(got_null){
    80000d6c:	0017b793          	seqz	a5,a5
    80000d70:	40f00533          	neg	a0,a5
}
    80000d74:	8082                	ret

0000000080000d76 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d76:	7139                	addi	sp,sp,-64
    80000d78:	fc06                	sd	ra,56(sp)
    80000d7a:	f822                	sd	s0,48(sp)
    80000d7c:	f426                	sd	s1,40(sp)
    80000d7e:	f04a                	sd	s2,32(sp)
    80000d80:	ec4e                	sd	s3,24(sp)
    80000d82:	e852                	sd	s4,16(sp)
    80000d84:	e456                	sd	s5,8(sp)
    80000d86:	e05a                	sd	s6,0(sp)
    80000d88:	0080                	addi	s0,sp,64
    80000d8a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8c:	00009497          	auipc	s1,0x9
    80000d90:	05448493          	addi	s1,s1,84 # 80009de0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d94:	8b26                	mv	s6,s1
    80000d96:	00008a97          	auipc	s5,0x8
    80000d9a:	26aa8a93          	addi	s5,s5,618 # 80009000 <etext>
    80000d9e:	01000937          	lui	s2,0x1000
    80000da2:	197d                	addi	s2,s2,-1
    80000da4:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da6:	0000fa17          	auipc	s4,0xf
    80000daa:	a3aa0a13          	addi	s4,s4,-1478 # 8000f7e0 <tickslock>
    char *pa = kalloc();
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	36a080e7          	jalr	874(ra) # 80000118 <kalloc>
    80000db6:	862a                	mv	a2,a0
    if(pa == 0)
    80000db8:	c129                	beqz	a0,80000dfa <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000dba:	416485b3          	sub	a1,s1,s6
    80000dbe:	858d                	srai	a1,a1,0x3
    80000dc0:	000ab783          	ld	a5,0(s5)
    80000dc4:	02f585b3          	mul	a1,a1,a5
    80000dc8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dcc:	4719                	li	a4,6
    80000dce:	6685                	lui	a3,0x1
    80000dd0:	40b905b3          	sub	a1,s2,a1
    80000dd4:	854e                	mv	a0,s3
    80000dd6:	00000097          	auipc	ra,0x0
    80000dda:	82e080e7          	jalr	-2002(ra) # 80000604 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dde:	16848493          	addi	s1,s1,360
    80000de2:	fd4496e3          	bne	s1,s4,80000dae <proc_mapstacks+0x38>
  }
}
    80000de6:	70e2                	ld	ra,56(sp)
    80000de8:	7442                	ld	s0,48(sp)
    80000dea:	74a2                	ld	s1,40(sp)
    80000dec:	7902                	ld	s2,32(sp)
    80000dee:	69e2                	ld	s3,24(sp)
    80000df0:	6a42                	ld	s4,16(sp)
    80000df2:	6aa2                	ld	s5,8(sp)
    80000df4:	6b02                	ld	s6,0(sp)
    80000df6:	6121                	addi	sp,sp,64
    80000df8:	8082                	ret
      panic("kalloc");
    80000dfa:	00008517          	auipc	a0,0x8
    80000dfe:	36e50513          	addi	a0,a0,878 # 80009168 <etext+0x168>
    80000e02:	00006097          	auipc	ra,0x6
    80000e06:	e90080e7          	jalr	-368(ra) # 80006c92 <panic>

0000000080000e0a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e0a:	7139                	addi	sp,sp,-64
    80000e0c:	fc06                	sd	ra,56(sp)
    80000e0e:	f822                	sd	s0,48(sp)
    80000e10:	f426                	sd	s1,40(sp)
    80000e12:	f04a                	sd	s2,32(sp)
    80000e14:	ec4e                	sd	s3,24(sp)
    80000e16:	e852                	sd	s4,16(sp)
    80000e18:	e456                	sd	s5,8(sp)
    80000e1a:	e05a                	sd	s6,0(sp)
    80000e1c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e1e:	00008597          	auipc	a1,0x8
    80000e22:	35258593          	addi	a1,a1,850 # 80009170 <etext+0x170>
    80000e26:	00009517          	auipc	a0,0x9
    80000e2a:	b8a50513          	addi	a0,a0,-1142 # 800099b0 <pid_lock>
    80000e2e:	00006097          	auipc	ra,0x6
    80000e32:	31e080e7          	jalr	798(ra) # 8000714c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e36:	00008597          	auipc	a1,0x8
    80000e3a:	34258593          	addi	a1,a1,834 # 80009178 <etext+0x178>
    80000e3e:	00009517          	auipc	a0,0x9
    80000e42:	b8a50513          	addi	a0,a0,-1142 # 800099c8 <wait_lock>
    80000e46:	00006097          	auipc	ra,0x6
    80000e4a:	306080e7          	jalr	774(ra) # 8000714c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4e:	00009497          	auipc	s1,0x9
    80000e52:	f9248493          	addi	s1,s1,-110 # 80009de0 <proc>
      initlock(&p->lock, "proc");
    80000e56:	00008b17          	auipc	s6,0x8
    80000e5a:	332b0b13          	addi	s6,s6,818 # 80009188 <etext+0x188>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e5e:	8aa6                	mv	s5,s1
    80000e60:	00008a17          	auipc	s4,0x8
    80000e64:	1a0a0a13          	addi	s4,s4,416 # 80009000 <etext>
    80000e68:	01000937          	lui	s2,0x1000
    80000e6c:	197d                	addi	s2,s2,-1
    80000e6e:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e70:	0000f997          	auipc	s3,0xf
    80000e74:	97098993          	addi	s3,s3,-1680 # 8000f7e0 <tickslock>
      initlock(&p->lock, "proc");
    80000e78:	85da                	mv	a1,s6
    80000e7a:	8526                	mv	a0,s1
    80000e7c:	00006097          	auipc	ra,0x6
    80000e80:	2d0080e7          	jalr	720(ra) # 8000714c <initlock>
      p->state = UNUSED;
    80000e84:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e88:	415487b3          	sub	a5,s1,s5
    80000e8c:	878d                	srai	a5,a5,0x3
    80000e8e:	000a3703          	ld	a4,0(s4)
    80000e92:	02e787b3          	mul	a5,a5,a4
    80000e96:	00d7979b          	slliw	a5,a5,0xd
    80000e9a:	40f907b3          	sub	a5,s2,a5
    80000e9e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea0:	16848493          	addi	s1,s1,360
    80000ea4:	fd349ae3          	bne	s1,s3,80000e78 <procinit+0x6e>
  }
}
    80000ea8:	70e2                	ld	ra,56(sp)
    80000eaa:	7442                	ld	s0,48(sp)
    80000eac:	74a2                	ld	s1,40(sp)
    80000eae:	7902                	ld	s2,32(sp)
    80000eb0:	69e2                	ld	s3,24(sp)
    80000eb2:	6a42                	ld	s4,16(sp)
    80000eb4:	6aa2                	ld	s5,8(sp)
    80000eb6:	6b02                	ld	s6,0(sp)
    80000eb8:	6121                	addi	sp,sp,64
    80000eba:	8082                	ret

0000000080000ebc <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ebc:	1141                	addi	sp,sp,-16
    80000ebe:	e422                	sd	s0,8(sp)
    80000ec0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ec2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ec4:	2501                	sext.w	a0,a0
    80000ec6:	6422                	ld	s0,8(sp)
    80000ec8:	0141                	addi	sp,sp,16
    80000eca:	8082                	ret

0000000080000ecc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000ecc:	1141                	addi	sp,sp,-16
    80000ece:	e422                	sd	s0,8(sp)
    80000ed0:	0800                	addi	s0,sp,16
    80000ed2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ed4:	2781                	sext.w	a5,a5
    80000ed6:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ed8:	00009517          	auipc	a0,0x9
    80000edc:	b0850513          	addi	a0,a0,-1272 # 800099e0 <cpus>
    80000ee0:	953e                	add	a0,a0,a5
    80000ee2:	6422                	ld	s0,8(sp)
    80000ee4:	0141                	addi	sp,sp,16
    80000ee6:	8082                	ret

0000000080000ee8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ee8:	1101                	addi	sp,sp,-32
    80000eea:	ec06                	sd	ra,24(sp)
    80000eec:	e822                	sd	s0,16(sp)
    80000eee:	e426                	sd	s1,8(sp)
    80000ef0:	1000                	addi	s0,sp,32
  push_off();
    80000ef2:	00006097          	auipc	ra,0x6
    80000ef6:	29e080e7          	jalr	670(ra) # 80007190 <push_off>
    80000efa:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000efc:	2781                	sext.w	a5,a5
    80000efe:	079e                	slli	a5,a5,0x7
    80000f00:	00009717          	auipc	a4,0x9
    80000f04:	ab070713          	addi	a4,a4,-1360 # 800099b0 <pid_lock>
    80000f08:	97ba                	add	a5,a5,a4
    80000f0a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f0c:	00006097          	auipc	ra,0x6
    80000f10:	324080e7          	jalr	804(ra) # 80007230 <pop_off>
  return p;
}
    80000f14:	8526                	mv	a0,s1
    80000f16:	60e2                	ld	ra,24(sp)
    80000f18:	6442                	ld	s0,16(sp)
    80000f1a:	64a2                	ld	s1,8(sp)
    80000f1c:	6105                	addi	sp,sp,32
    80000f1e:	8082                	ret

0000000080000f20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f20:	1141                	addi	sp,sp,-16
    80000f22:	e406                	sd	ra,8(sp)
    80000f24:	e022                	sd	s0,0(sp)
    80000f26:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	fc0080e7          	jalr	-64(ra) # 80000ee8 <myproc>
    80000f30:	00006097          	auipc	ra,0x6
    80000f34:	360080e7          	jalr	864(ra) # 80007290 <release>

  if (first) {
    80000f38:	00009797          	auipc	a5,0x9
    80000f3c:	9887a783          	lw	a5,-1656(a5) # 800098c0 <first.1726>
    80000f40:	eb89                	bnez	a5,80000f52 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f42:	00001097          	auipc	ra,0x1
    80000f46:	c5a080e7          	jalr	-934(ra) # 80001b9c <usertrapret>
}
    80000f4a:	60a2                	ld	ra,8(sp)
    80000f4c:	6402                	ld	s0,0(sp)
    80000f4e:	0141                	addi	sp,sp,16
    80000f50:	8082                	ret
    fsinit(ROOTDEV);
    80000f52:	4505                	li	a0,1
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	9b8080e7          	jalr	-1608(ra) # 8000290c <fsinit>
    first = 0;
    80000f5c:	00009797          	auipc	a5,0x9
    80000f60:	9607a223          	sw	zero,-1692(a5) # 800098c0 <first.1726>
    __sync_synchronize();
    80000f64:	0ff0000f          	fence
    80000f68:	bfe9                	j	80000f42 <forkret+0x22>

0000000080000f6a <allocpid>:
{
    80000f6a:	1101                	addi	sp,sp,-32
    80000f6c:	ec06                	sd	ra,24(sp)
    80000f6e:	e822                	sd	s0,16(sp)
    80000f70:	e426                	sd	s1,8(sp)
    80000f72:	e04a                	sd	s2,0(sp)
    80000f74:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f76:	00009917          	auipc	s2,0x9
    80000f7a:	a3a90913          	addi	s2,s2,-1478 # 800099b0 <pid_lock>
    80000f7e:	854a                	mv	a0,s2
    80000f80:	00006097          	auipc	ra,0x6
    80000f84:	25c080e7          	jalr	604(ra) # 800071dc <acquire>
  pid = nextpid;
    80000f88:	00009797          	auipc	a5,0x9
    80000f8c:	93c78793          	addi	a5,a5,-1732 # 800098c4 <nextpid>
    80000f90:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f92:	0014871b          	addiw	a4,s1,1
    80000f96:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f98:	854a                	mv	a0,s2
    80000f9a:	00006097          	auipc	ra,0x6
    80000f9e:	2f6080e7          	jalr	758(ra) # 80007290 <release>
}
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	60e2                	ld	ra,24(sp)
    80000fa6:	6442                	ld	s0,16(sp)
    80000fa8:	64a2                	ld	s1,8(sp)
    80000faa:	6902                	ld	s2,0(sp)
    80000fac:	6105                	addi	sp,sp,32
    80000fae:	8082                	ret

0000000080000fb0 <proc_pagetable>:
{
    80000fb0:	1101                	addi	sp,sp,-32
    80000fb2:	ec06                	sd	ra,24(sp)
    80000fb4:	e822                	sd	s0,16(sp)
    80000fb6:	e426                	sd	s1,8(sp)
    80000fb8:	e04a                	sd	s2,0(sp)
    80000fba:	1000                	addi	s0,sp,32
    80000fbc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fbe:	00000097          	auipc	ra,0x0
    80000fc2:	874080e7          	jalr	-1932(ra) # 80000832 <uvmcreate>
    80000fc6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fc8:	c121                	beqz	a0,80001008 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fca:	4729                	li	a4,10
    80000fcc:	00007697          	auipc	a3,0x7
    80000fd0:	03468693          	addi	a3,a3,52 # 80008000 <_trampoline>
    80000fd4:	6605                	lui	a2,0x1
    80000fd6:	040005b7          	lui	a1,0x4000
    80000fda:	15fd                	addi	a1,a1,-1
    80000fdc:	05b2                	slli	a1,a1,0xc
    80000fde:	fffff097          	auipc	ra,0xfffff
    80000fe2:	586080e7          	jalr	1414(ra) # 80000564 <mappages>
    80000fe6:	02054863          	bltz	a0,80001016 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fea:	4719                	li	a4,6
    80000fec:	05893683          	ld	a3,88(s2)
    80000ff0:	6605                	lui	a2,0x1
    80000ff2:	020005b7          	lui	a1,0x2000
    80000ff6:	15fd                	addi	a1,a1,-1
    80000ff8:	05b6                	slli	a1,a1,0xd
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	568080e7          	jalr	1384(ra) # 80000564 <mappages>
    80001004:	02054163          	bltz	a0,80001026 <proc_pagetable+0x76>
}
    80001008:	8526                	mv	a0,s1
    8000100a:	60e2                	ld	ra,24(sp)
    8000100c:	6442                	ld	s0,16(sp)
    8000100e:	64a2                	ld	s1,8(sp)
    80001010:	6902                	ld	s2,0(sp)
    80001012:	6105                	addi	sp,sp,32
    80001014:	8082                	ret
    uvmfree(pagetable, 0);
    80001016:	4581                	li	a1,0
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	a1c080e7          	jalr	-1508(ra) # 80000a36 <uvmfree>
    return 0;
    80001022:	4481                	li	s1,0
    80001024:	b7d5                	j	80001008 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001026:	4681                	li	a3,0
    80001028:	4605                	li	a2,1
    8000102a:	040005b7          	lui	a1,0x4000
    8000102e:	15fd                	addi	a1,a1,-1
    80001030:	05b2                	slli	a1,a1,0xc
    80001032:	8526                	mv	a0,s1
    80001034:	fffff097          	auipc	ra,0xfffff
    80001038:	726080e7          	jalr	1830(ra) # 8000075a <uvmunmap>
    uvmfree(pagetable, 0);
    8000103c:	4581                	li	a1,0
    8000103e:	8526                	mv	a0,s1
    80001040:	00000097          	auipc	ra,0x0
    80001044:	9f6080e7          	jalr	-1546(ra) # 80000a36 <uvmfree>
    return 0;
    80001048:	4481                	li	s1,0
    8000104a:	bf7d                	j	80001008 <proc_pagetable+0x58>

000000008000104c <proc_freepagetable>:
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	e04a                	sd	s2,0(sp)
    80001056:	1000                	addi	s0,sp,32
    80001058:	84aa                	mv	s1,a0
    8000105a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000105c:	4681                	li	a3,0
    8000105e:	4605                	li	a2,1
    80001060:	040005b7          	lui	a1,0x4000
    80001064:	15fd                	addi	a1,a1,-1
    80001066:	05b2                	slli	a1,a1,0xc
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	6f2080e7          	jalr	1778(ra) # 8000075a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001070:	4681                	li	a3,0
    80001072:	4605                	li	a2,1
    80001074:	020005b7          	lui	a1,0x2000
    80001078:	15fd                	addi	a1,a1,-1
    8000107a:	05b6                	slli	a1,a1,0xd
    8000107c:	8526                	mv	a0,s1
    8000107e:	fffff097          	auipc	ra,0xfffff
    80001082:	6dc080e7          	jalr	1756(ra) # 8000075a <uvmunmap>
  uvmfree(pagetable, sz);
    80001086:	85ca                	mv	a1,s2
    80001088:	8526                	mv	a0,s1
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	9ac080e7          	jalr	-1620(ra) # 80000a36 <uvmfree>
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6902                	ld	s2,0(sp)
    8000109a:	6105                	addi	sp,sp,32
    8000109c:	8082                	ret

000000008000109e <freeproc>:
{
    8000109e:	1101                	addi	sp,sp,-32
    800010a0:	ec06                	sd	ra,24(sp)
    800010a2:	e822                	sd	s0,16(sp)
    800010a4:	e426                	sd	s1,8(sp)
    800010a6:	1000                	addi	s0,sp,32
    800010a8:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010aa:	6d28                	ld	a0,88(a0)
    800010ac:	c509                	beqz	a0,800010b6 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	f6e080e7          	jalr	-146(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010b6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010ba:	68a8                	ld	a0,80(s1)
    800010bc:	c511                	beqz	a0,800010c8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010be:	64ac                	ld	a1,72(s1)
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	f8c080e7          	jalr	-116(ra) # 8000104c <proc_freepagetable>
  p->pagetable = 0;
    800010c8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010cc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010d0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010d4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010d8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010dc:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010e0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010e4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010e8:	0004ac23          	sw	zero,24(s1)
}
    800010ec:	60e2                	ld	ra,24(sp)
    800010ee:	6442                	ld	s0,16(sp)
    800010f0:	64a2                	ld	s1,8(sp)
    800010f2:	6105                	addi	sp,sp,32
    800010f4:	8082                	ret

00000000800010f6 <allocproc>:
{
    800010f6:	1101                	addi	sp,sp,-32
    800010f8:	ec06                	sd	ra,24(sp)
    800010fa:	e822                	sd	s0,16(sp)
    800010fc:	e426                	sd	s1,8(sp)
    800010fe:	e04a                	sd	s2,0(sp)
    80001100:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001102:	00009497          	auipc	s1,0x9
    80001106:	cde48493          	addi	s1,s1,-802 # 80009de0 <proc>
    8000110a:	0000e917          	auipc	s2,0xe
    8000110e:	6d690913          	addi	s2,s2,1750 # 8000f7e0 <tickslock>
    acquire(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00006097          	auipc	ra,0x6
    80001118:	0c8080e7          	jalr	200(ra) # 800071dc <acquire>
    if(p->state == UNUSED) {
    8000111c:	4c9c                	lw	a5,24(s1)
    8000111e:	cf81                	beqz	a5,80001136 <allocproc+0x40>
      release(&p->lock);
    80001120:	8526                	mv	a0,s1
    80001122:	00006097          	auipc	ra,0x6
    80001126:	16e080e7          	jalr	366(ra) # 80007290 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000112a:	16848493          	addi	s1,s1,360
    8000112e:	ff2492e3          	bne	s1,s2,80001112 <allocproc+0x1c>
  return 0;
    80001132:	4481                	li	s1,0
    80001134:	a889                	j	80001186 <allocproc+0x90>
  p->pid = allocpid();
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	e34080e7          	jalr	-460(ra) # 80000f6a <allocpid>
    8000113e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001140:	4785                	li	a5,1
    80001142:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	fd4080e7          	jalr	-44(ra) # 80000118 <kalloc>
    8000114c:	892a                	mv	s2,a0
    8000114e:	eca8                	sd	a0,88(s1)
    80001150:	c131                	beqz	a0,80001194 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	e5c080e7          	jalr	-420(ra) # 80000fb0 <proc_pagetable>
    8000115c:	892a                	mv	s2,a0
    8000115e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001160:	c531                	beqz	a0,800011ac <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001162:	07000613          	li	a2,112
    80001166:	4581                	li	a1,0
    80001168:	06048513          	addi	a0,s1,96
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	00c080e7          	jalr	12(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001174:	00000797          	auipc	a5,0x0
    80001178:	dac78793          	addi	a5,a5,-596 # 80000f20 <forkret>
    8000117c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000117e:	60bc                	ld	a5,64(s1)
    80001180:	6705                	lui	a4,0x1
    80001182:	97ba                	add	a5,a5,a4
    80001184:	f4bc                	sd	a5,104(s1)
}
    80001186:	8526                	mv	a0,s1
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret
    freeproc(p);
    80001194:	8526                	mv	a0,s1
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	f08080e7          	jalr	-248(ra) # 8000109e <freeproc>
    release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00006097          	auipc	ra,0x6
    800011a4:	0f0080e7          	jalr	240(ra) # 80007290 <release>
    return 0;
    800011a8:	84ca                	mv	s1,s2
    800011aa:	bff1                	j	80001186 <allocproc+0x90>
    freeproc(p);
    800011ac:	8526                	mv	a0,s1
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	ef0080e7          	jalr	-272(ra) # 8000109e <freeproc>
    release(&p->lock);
    800011b6:	8526                	mv	a0,s1
    800011b8:	00006097          	auipc	ra,0x6
    800011bc:	0d8080e7          	jalr	216(ra) # 80007290 <release>
    return 0;
    800011c0:	84ca                	mv	s1,s2
    800011c2:	b7d1                	j	80001186 <allocproc+0x90>

00000000800011c4 <userinit>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f28080e7          	jalr	-216(ra) # 800010f6 <allocproc>
    800011d6:	84aa                	mv	s1,a0
  initproc = p;
    800011d8:	00008797          	auipc	a5,0x8
    800011dc:	76a7bc23          	sd	a0,1912(a5) # 80009950 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011e0:	03400613          	li	a2,52
    800011e4:	00008597          	auipc	a1,0x8
    800011e8:	6fc58593          	addi	a1,a1,1788 # 800098e0 <initcode>
    800011ec:	6928                	ld	a0,80(a0)
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	672080e7          	jalr	1650(ra) # 80000860 <uvmfirst>
  p->sz = PGSIZE;
    800011f6:	6785                	lui	a5,0x1
    800011f8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011fa:	6cb8                	ld	a4,88(s1)
    800011fc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001200:	6cb8                	ld	a4,88(s1)
    80001202:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001204:	4641                	li	a2,16
    80001206:	00008597          	auipc	a1,0x8
    8000120a:	f8a58593          	addi	a1,a1,-118 # 80009190 <etext+0x190>
    8000120e:	15848513          	addi	a0,s1,344
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	0b8080e7          	jalr	184(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000121a:	00008517          	auipc	a0,0x8
    8000121e:	f8650513          	addi	a0,a0,-122 # 800091a0 <etext+0x1a0>
    80001222:	00002097          	auipc	ra,0x2
    80001226:	10c080e7          	jalr	268(ra) # 8000332e <namei>
    8000122a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000122e:	478d                	li	a5,3
    80001230:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001232:	8526                	mv	a0,s1
    80001234:	00006097          	auipc	ra,0x6
    80001238:	05c080e7          	jalr	92(ra) # 80007290 <release>
}
    8000123c:	60e2                	ld	ra,24(sp)
    8000123e:	6442                	ld	s0,16(sp)
    80001240:	64a2                	ld	s1,8(sp)
    80001242:	6105                	addi	sp,sp,32
    80001244:	8082                	ret

0000000080001246 <growproc>:
{
    80001246:	1101                	addi	sp,sp,-32
    80001248:	ec06                	sd	ra,24(sp)
    8000124a:	e822                	sd	s0,16(sp)
    8000124c:	e426                	sd	s1,8(sp)
    8000124e:	e04a                	sd	s2,0(sp)
    80001250:	1000                	addi	s0,sp,32
    80001252:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001254:	00000097          	auipc	ra,0x0
    80001258:	c94080e7          	jalr	-876(ra) # 80000ee8 <myproc>
    8000125c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000125e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001260:	01204c63          	bgtz	s2,80001278 <growproc+0x32>
  } else if(n < 0){
    80001264:	02094663          	bltz	s2,80001290 <growproc+0x4a>
  p->sz = sz;
    80001268:	e4ac                	sd	a1,72(s1)
  return 0;
    8000126a:	4501                	li	a0,0
}
    8000126c:	60e2                	ld	ra,24(sp)
    8000126e:	6442                	ld	s0,16(sp)
    80001270:	64a2                	ld	s1,8(sp)
    80001272:	6902                	ld	s2,0(sp)
    80001274:	6105                	addi	sp,sp,32
    80001276:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001278:	4691                	li	a3,4
    8000127a:	00b90633          	add	a2,s2,a1
    8000127e:	6928                	ld	a0,80(a0)
    80001280:	fffff097          	auipc	ra,0xfffff
    80001284:	69a080e7          	jalr	1690(ra) # 8000091a <uvmalloc>
    80001288:	85aa                	mv	a1,a0
    8000128a:	fd79                	bnez	a0,80001268 <growproc+0x22>
      return -1;
    8000128c:	557d                	li	a0,-1
    8000128e:	bff9                	j	8000126c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001290:	00b90633          	add	a2,s2,a1
    80001294:	6928                	ld	a0,80(a0)
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	63c080e7          	jalr	1596(ra) # 800008d2 <uvmdealloc>
    8000129e:	85aa                	mv	a1,a0
    800012a0:	b7e1                	j	80001268 <growproc+0x22>

00000000800012a2 <fork>:
{
    800012a2:	7179                	addi	sp,sp,-48
    800012a4:	f406                	sd	ra,40(sp)
    800012a6:	f022                	sd	s0,32(sp)
    800012a8:	ec26                	sd	s1,24(sp)
    800012aa:	e84a                	sd	s2,16(sp)
    800012ac:	e44e                	sd	s3,8(sp)
    800012ae:	e052                	sd	s4,0(sp)
    800012b0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	c36080e7          	jalr	-970(ra) # 80000ee8 <myproc>
    800012ba:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	e3a080e7          	jalr	-454(ra) # 800010f6 <allocproc>
    800012c4:	10050b63          	beqz	a0,800013da <fork+0x138>
    800012c8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012ca:	04893603          	ld	a2,72(s2)
    800012ce:	692c                	ld	a1,80(a0)
    800012d0:	05093503          	ld	a0,80(s2)
    800012d4:	fffff097          	auipc	ra,0xfffff
    800012d8:	79a080e7          	jalr	1946(ra) # 80000a6e <uvmcopy>
    800012dc:	04054663          	bltz	a0,80001328 <fork+0x86>
  np->sz = p->sz;
    800012e0:	04893783          	ld	a5,72(s2)
    800012e4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012e8:	05893683          	ld	a3,88(s2)
    800012ec:	87b6                	mv	a5,a3
    800012ee:	0589b703          	ld	a4,88(s3)
    800012f2:	12068693          	addi	a3,a3,288
    800012f6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012fa:	6788                	ld	a0,8(a5)
    800012fc:	6b8c                	ld	a1,16(a5)
    800012fe:	6f90                	ld	a2,24(a5)
    80001300:	01073023          	sd	a6,0(a4)
    80001304:	e708                	sd	a0,8(a4)
    80001306:	eb0c                	sd	a1,16(a4)
    80001308:	ef10                	sd	a2,24(a4)
    8000130a:	02078793          	addi	a5,a5,32
    8000130e:	02070713          	addi	a4,a4,32
    80001312:	fed792e3          	bne	a5,a3,800012f6 <fork+0x54>
  np->trapframe->a0 = 0;
    80001316:	0589b783          	ld	a5,88(s3)
    8000131a:	0607b823          	sd	zero,112(a5)
    8000131e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001322:	15000a13          	li	s4,336
    80001326:	a03d                	j	80001354 <fork+0xb2>
    freeproc(np);
    80001328:	854e                	mv	a0,s3
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	d74080e7          	jalr	-652(ra) # 8000109e <freeproc>
    release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00006097          	auipc	ra,0x6
    80001338:	f5c080e7          	jalr	-164(ra) # 80007290 <release>
    return -1;
    8000133c:	5a7d                	li	s4,-1
    8000133e:	a069                	j	800013c8 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001340:	00002097          	auipc	ra,0x2
    80001344:	684080e7          	jalr	1668(ra) # 800039c4 <filedup>
    80001348:	009987b3          	add	a5,s3,s1
    8000134c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000134e:	04a1                	addi	s1,s1,8
    80001350:	01448763          	beq	s1,s4,8000135e <fork+0xbc>
    if(p->ofile[i])
    80001354:	009907b3          	add	a5,s2,s1
    80001358:	6388                	ld	a0,0(a5)
    8000135a:	f17d                	bnez	a0,80001340 <fork+0x9e>
    8000135c:	bfcd                	j	8000134e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000135e:	15093503          	ld	a0,336(s2)
    80001362:	00001097          	auipc	ra,0x1
    80001366:	7e8080e7          	jalr	2024(ra) # 80002b4a <idup>
    8000136a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000136e:	4641                	li	a2,16
    80001370:	15890593          	addi	a1,s2,344
    80001374:	15898513          	addi	a0,s3,344
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	f52080e7          	jalr	-174(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001380:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001384:	854e                	mv	a0,s3
    80001386:	00006097          	auipc	ra,0x6
    8000138a:	f0a080e7          	jalr	-246(ra) # 80007290 <release>
  acquire(&wait_lock);
    8000138e:	00008497          	auipc	s1,0x8
    80001392:	63a48493          	addi	s1,s1,1594 # 800099c8 <wait_lock>
    80001396:	8526                	mv	a0,s1
    80001398:	00006097          	auipc	ra,0x6
    8000139c:	e44080e7          	jalr	-444(ra) # 800071dc <acquire>
  np->parent = p;
    800013a0:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00006097          	auipc	ra,0x6
    800013aa:	eea080e7          	jalr	-278(ra) # 80007290 <release>
  acquire(&np->lock);
    800013ae:	854e                	mv	a0,s3
    800013b0:	00006097          	auipc	ra,0x6
    800013b4:	e2c080e7          	jalr	-468(ra) # 800071dc <acquire>
  np->state = RUNNABLE;
    800013b8:	478d                	li	a5,3
    800013ba:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013be:	854e                	mv	a0,s3
    800013c0:	00006097          	auipc	ra,0x6
    800013c4:	ed0080e7          	jalr	-304(ra) # 80007290 <release>
}
    800013c8:	8552                	mv	a0,s4
    800013ca:	70a2                	ld	ra,40(sp)
    800013cc:	7402                	ld	s0,32(sp)
    800013ce:	64e2                	ld	s1,24(sp)
    800013d0:	6942                	ld	s2,16(sp)
    800013d2:	69a2                	ld	s3,8(sp)
    800013d4:	6a02                	ld	s4,0(sp)
    800013d6:	6145                	addi	sp,sp,48
    800013d8:	8082                	ret
    return -1;
    800013da:	5a7d                	li	s4,-1
    800013dc:	b7f5                	j	800013c8 <fork+0x126>

00000000800013de <scheduler>:
{
    800013de:	7139                	addi	sp,sp,-64
    800013e0:	fc06                	sd	ra,56(sp)
    800013e2:	f822                	sd	s0,48(sp)
    800013e4:	f426                	sd	s1,40(sp)
    800013e6:	f04a                	sd	s2,32(sp)
    800013e8:	ec4e                	sd	s3,24(sp)
    800013ea:	e852                	sd	s4,16(sp)
    800013ec:	e456                	sd	s5,8(sp)
    800013ee:	e05a                	sd	s6,0(sp)
    800013f0:	0080                	addi	s0,sp,64
    800013f2:	8792                	mv	a5,tp
  int id = r_tp();
    800013f4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013f6:	00779a93          	slli	s5,a5,0x7
    800013fa:	00008717          	auipc	a4,0x8
    800013fe:	5b670713          	addi	a4,a4,1462 # 800099b0 <pid_lock>
    80001402:	9756                	add	a4,a4,s5
    80001404:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001408:	00008717          	auipc	a4,0x8
    8000140c:	5e070713          	addi	a4,a4,1504 # 800099e8 <cpus+0x8>
    80001410:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001412:	498d                	li	s3,3
        p->state = RUNNING;
    80001414:	4b11                	li	s6,4
        c->proc = p;
    80001416:	079e                	slli	a5,a5,0x7
    80001418:	00008a17          	auipc	s4,0x8
    8000141c:	598a0a13          	addi	s4,s4,1432 # 800099b0 <pid_lock>
    80001420:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001422:	0000e917          	auipc	s2,0xe
    80001426:	3be90913          	addi	s2,s2,958 # 8000f7e0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000142e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001432:	10079073          	csrw	sstatus,a5
    80001436:	00009497          	auipc	s1,0x9
    8000143a:	9aa48493          	addi	s1,s1,-1622 # 80009de0 <proc>
    8000143e:	a03d                	j	8000146c <scheduler+0x8e>
        p->state = RUNNING;
    80001440:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001444:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001448:	06048593          	addi	a1,s1,96
    8000144c:	8556                	mv	a0,s5
    8000144e:	00000097          	auipc	ra,0x0
    80001452:	6a4080e7          	jalr	1700(ra) # 80001af2 <swtch>
        c->proc = 0;
    80001456:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000145a:	8526                	mv	a0,s1
    8000145c:	00006097          	auipc	ra,0x6
    80001460:	e34080e7          	jalr	-460(ra) # 80007290 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001464:	16848493          	addi	s1,s1,360
    80001468:	fd2481e3          	beq	s1,s2,8000142a <scheduler+0x4c>
      acquire(&p->lock);
    8000146c:	8526                	mv	a0,s1
    8000146e:	00006097          	auipc	ra,0x6
    80001472:	d6e080e7          	jalr	-658(ra) # 800071dc <acquire>
      if(p->state == RUNNABLE) {
    80001476:	4c9c                	lw	a5,24(s1)
    80001478:	ff3791e3          	bne	a5,s3,8000145a <scheduler+0x7c>
    8000147c:	b7d1                	j	80001440 <scheduler+0x62>

000000008000147e <sched>:
{
    8000147e:	7179                	addi	sp,sp,-48
    80001480:	f406                	sd	ra,40(sp)
    80001482:	f022                	sd	s0,32(sp)
    80001484:	ec26                	sd	s1,24(sp)
    80001486:	e84a                	sd	s2,16(sp)
    80001488:	e44e                	sd	s3,8(sp)
    8000148a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000148c:	00000097          	auipc	ra,0x0
    80001490:	a5c080e7          	jalr	-1444(ra) # 80000ee8 <myproc>
    80001494:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001496:	00006097          	auipc	ra,0x6
    8000149a:	ccc080e7          	jalr	-820(ra) # 80007162 <holding>
    8000149e:	c93d                	beqz	a0,80001514 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014a2:	2781                	sext.w	a5,a5
    800014a4:	079e                	slli	a5,a5,0x7
    800014a6:	00008717          	auipc	a4,0x8
    800014aa:	50a70713          	addi	a4,a4,1290 # 800099b0 <pid_lock>
    800014ae:	97ba                	add	a5,a5,a4
    800014b0:	0a87a703          	lw	a4,168(a5)
    800014b4:	4785                	li	a5,1
    800014b6:	06f71763          	bne	a4,a5,80001524 <sched+0xa6>
  if(p->state == RUNNING)
    800014ba:	4c98                	lw	a4,24(s1)
    800014bc:	4791                	li	a5,4
    800014be:	06f70b63          	beq	a4,a5,80001534 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014c6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014c8:	efb5                	bnez	a5,80001544 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ca:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014cc:	00008917          	auipc	s2,0x8
    800014d0:	4e490913          	addi	s2,s2,1252 # 800099b0 <pid_lock>
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	97ca                	add	a5,a5,s2
    800014da:	0ac7a983          	lw	s3,172(a5)
    800014de:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014e0:	2781                	sext.w	a5,a5
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	00008597          	auipc	a1,0x8
    800014e8:	50458593          	addi	a1,a1,1284 # 800099e8 <cpus+0x8>
    800014ec:	95be                	add	a1,a1,a5
    800014ee:	06048513          	addi	a0,s1,96
    800014f2:	00000097          	auipc	ra,0x0
    800014f6:	600080e7          	jalr	1536(ra) # 80001af2 <swtch>
    800014fa:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014fc:	2781                	sext.w	a5,a5
    800014fe:	079e                	slli	a5,a5,0x7
    80001500:	97ca                	add	a5,a5,s2
    80001502:	0b37a623          	sw	s3,172(a5)
}
    80001506:	70a2                	ld	ra,40(sp)
    80001508:	7402                	ld	s0,32(sp)
    8000150a:	64e2                	ld	s1,24(sp)
    8000150c:	6942                	ld	s2,16(sp)
    8000150e:	69a2                	ld	s3,8(sp)
    80001510:	6145                	addi	sp,sp,48
    80001512:	8082                	ret
    panic("sched p->lock");
    80001514:	00008517          	auipc	a0,0x8
    80001518:	c9450513          	addi	a0,a0,-876 # 800091a8 <etext+0x1a8>
    8000151c:	00005097          	auipc	ra,0x5
    80001520:	776080e7          	jalr	1910(ra) # 80006c92 <panic>
    panic("sched locks");
    80001524:	00008517          	auipc	a0,0x8
    80001528:	c9450513          	addi	a0,a0,-876 # 800091b8 <etext+0x1b8>
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	766080e7          	jalr	1894(ra) # 80006c92 <panic>
    panic("sched running");
    80001534:	00008517          	auipc	a0,0x8
    80001538:	c9450513          	addi	a0,a0,-876 # 800091c8 <etext+0x1c8>
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	756080e7          	jalr	1878(ra) # 80006c92 <panic>
    panic("sched interruptible");
    80001544:	00008517          	auipc	a0,0x8
    80001548:	c9450513          	addi	a0,a0,-876 # 800091d8 <etext+0x1d8>
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	746080e7          	jalr	1862(ra) # 80006c92 <panic>

0000000080001554 <yield>:
{
    80001554:	1101                	addi	sp,sp,-32
    80001556:	ec06                	sd	ra,24(sp)
    80001558:	e822                	sd	s0,16(sp)
    8000155a:	e426                	sd	s1,8(sp)
    8000155c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	98a080e7          	jalr	-1654(ra) # 80000ee8 <myproc>
    80001566:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001568:	00006097          	auipc	ra,0x6
    8000156c:	c74080e7          	jalr	-908(ra) # 800071dc <acquire>
  p->state = RUNNABLE;
    80001570:	478d                	li	a5,3
    80001572:	cc9c                	sw	a5,24(s1)
  sched();
    80001574:	00000097          	auipc	ra,0x0
    80001578:	f0a080e7          	jalr	-246(ra) # 8000147e <sched>
  release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	00006097          	auipc	ra,0x6
    80001582:	d12080e7          	jalr	-750(ra) # 80007290 <release>
}
    80001586:	60e2                	ld	ra,24(sp)
    80001588:	6442                	ld	s0,16(sp)
    8000158a:	64a2                	ld	s1,8(sp)
    8000158c:	6105                	addi	sp,sp,32
    8000158e:	8082                	ret

0000000080001590 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001590:	7179                	addi	sp,sp,-48
    80001592:	f406                	sd	ra,40(sp)
    80001594:	f022                	sd	s0,32(sp)
    80001596:	ec26                	sd	s1,24(sp)
    80001598:	e84a                	sd	s2,16(sp)
    8000159a:	e44e                	sd	s3,8(sp)
    8000159c:	1800                	addi	s0,sp,48
    8000159e:	89aa                	mv	s3,a0
    800015a0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015a2:	00000097          	auipc	ra,0x0
    800015a6:	946080e7          	jalr	-1722(ra) # 80000ee8 <myproc>
    800015aa:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015ac:	00006097          	auipc	ra,0x6
    800015b0:	c30080e7          	jalr	-976(ra) # 800071dc <acquire>
  release(lk);
    800015b4:	854a                	mv	a0,s2
    800015b6:	00006097          	auipc	ra,0x6
    800015ba:	cda080e7          	jalr	-806(ra) # 80007290 <release>

  // Go to sleep.
  p->chan = chan;
    800015be:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015c2:	4789                	li	a5,2
    800015c4:	cc9c                	sw	a5,24(s1)

  sched();
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	eb8080e7          	jalr	-328(ra) # 8000147e <sched>

  // Tidy up.
  p->chan = 0;
    800015ce:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015d2:	8526                	mv	a0,s1
    800015d4:	00006097          	auipc	ra,0x6
    800015d8:	cbc080e7          	jalr	-836(ra) # 80007290 <release>
  acquire(lk);
    800015dc:	854a                	mv	a0,s2
    800015de:	00006097          	auipc	ra,0x6
    800015e2:	bfe080e7          	jalr	-1026(ra) # 800071dc <acquire>
}
    800015e6:	70a2                	ld	ra,40(sp)
    800015e8:	7402                	ld	s0,32(sp)
    800015ea:	64e2                	ld	s1,24(sp)
    800015ec:	6942                	ld	s2,16(sp)
    800015ee:	69a2                	ld	s3,8(sp)
    800015f0:	6145                	addi	sp,sp,48
    800015f2:	8082                	ret

00000000800015f4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015f4:	7139                	addi	sp,sp,-64
    800015f6:	fc06                	sd	ra,56(sp)
    800015f8:	f822                	sd	s0,48(sp)
    800015fa:	f426                	sd	s1,40(sp)
    800015fc:	f04a                	sd	s2,32(sp)
    800015fe:	ec4e                	sd	s3,24(sp)
    80001600:	e852                	sd	s4,16(sp)
    80001602:	e456                	sd	s5,8(sp)
    80001604:	0080                	addi	s0,sp,64
    80001606:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001608:	00008497          	auipc	s1,0x8
    8000160c:	7d848493          	addi	s1,s1,2008 # 80009de0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001610:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001612:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001614:	0000e917          	auipc	s2,0xe
    80001618:	1cc90913          	addi	s2,s2,460 # 8000f7e0 <tickslock>
    8000161c:	a821                	j	80001634 <wakeup+0x40>
        p->state = RUNNABLE;
    8000161e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001622:	8526                	mv	a0,s1
    80001624:	00006097          	auipc	ra,0x6
    80001628:	c6c080e7          	jalr	-916(ra) # 80007290 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000162c:	16848493          	addi	s1,s1,360
    80001630:	03248463          	beq	s1,s2,80001658 <wakeup+0x64>
    if(p != myproc()){
    80001634:	00000097          	auipc	ra,0x0
    80001638:	8b4080e7          	jalr	-1868(ra) # 80000ee8 <myproc>
    8000163c:	fea488e3          	beq	s1,a0,8000162c <wakeup+0x38>
      acquire(&p->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00006097          	auipc	ra,0x6
    80001646:	b9a080e7          	jalr	-1126(ra) # 800071dc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000164a:	4c9c                	lw	a5,24(s1)
    8000164c:	fd379be3          	bne	a5,s3,80001622 <wakeup+0x2e>
    80001650:	709c                	ld	a5,32(s1)
    80001652:	fd4798e3          	bne	a5,s4,80001622 <wakeup+0x2e>
    80001656:	b7e1                	j	8000161e <wakeup+0x2a>
    }
  }
}
    80001658:	70e2                	ld	ra,56(sp)
    8000165a:	7442                	ld	s0,48(sp)
    8000165c:	74a2                	ld	s1,40(sp)
    8000165e:	7902                	ld	s2,32(sp)
    80001660:	69e2                	ld	s3,24(sp)
    80001662:	6a42                	ld	s4,16(sp)
    80001664:	6aa2                	ld	s5,8(sp)
    80001666:	6121                	addi	sp,sp,64
    80001668:	8082                	ret

000000008000166a <reparent>:
{
    8000166a:	7179                	addi	sp,sp,-48
    8000166c:	f406                	sd	ra,40(sp)
    8000166e:	f022                	sd	s0,32(sp)
    80001670:	ec26                	sd	s1,24(sp)
    80001672:	e84a                	sd	s2,16(sp)
    80001674:	e44e                	sd	s3,8(sp)
    80001676:	e052                	sd	s4,0(sp)
    80001678:	1800                	addi	s0,sp,48
    8000167a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000167c:	00008497          	auipc	s1,0x8
    80001680:	76448493          	addi	s1,s1,1892 # 80009de0 <proc>
      pp->parent = initproc;
    80001684:	00008a17          	auipc	s4,0x8
    80001688:	2cca0a13          	addi	s4,s4,716 # 80009950 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000168c:	0000e997          	auipc	s3,0xe
    80001690:	15498993          	addi	s3,s3,340 # 8000f7e0 <tickslock>
    80001694:	a029                	j	8000169e <reparent+0x34>
    80001696:	16848493          	addi	s1,s1,360
    8000169a:	01348d63          	beq	s1,s3,800016b4 <reparent+0x4a>
    if(pp->parent == p){
    8000169e:	7c9c                	ld	a5,56(s1)
    800016a0:	ff279be3          	bne	a5,s2,80001696 <reparent+0x2c>
      pp->parent = initproc;
    800016a4:	000a3503          	ld	a0,0(s4)
    800016a8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	f4a080e7          	jalr	-182(ra) # 800015f4 <wakeup>
    800016b2:	b7d5                	j	80001696 <reparent+0x2c>
}
    800016b4:	70a2                	ld	ra,40(sp)
    800016b6:	7402                	ld	s0,32(sp)
    800016b8:	64e2                	ld	s1,24(sp)
    800016ba:	6942                	ld	s2,16(sp)
    800016bc:	69a2                	ld	s3,8(sp)
    800016be:	6a02                	ld	s4,0(sp)
    800016c0:	6145                	addi	sp,sp,48
    800016c2:	8082                	ret

00000000800016c4 <exit>:
{
    800016c4:	7179                	addi	sp,sp,-48
    800016c6:	f406                	sd	ra,40(sp)
    800016c8:	f022                	sd	s0,32(sp)
    800016ca:	ec26                	sd	s1,24(sp)
    800016cc:	e84a                	sd	s2,16(sp)
    800016ce:	e44e                	sd	s3,8(sp)
    800016d0:	e052                	sd	s4,0(sp)
    800016d2:	1800                	addi	s0,sp,48
    800016d4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016d6:	00000097          	auipc	ra,0x0
    800016da:	812080e7          	jalr	-2030(ra) # 80000ee8 <myproc>
    800016de:	89aa                	mv	s3,a0
  if(p == initproc)
    800016e0:	00008797          	auipc	a5,0x8
    800016e4:	2707b783          	ld	a5,624(a5) # 80009950 <initproc>
    800016e8:	0d050493          	addi	s1,a0,208
    800016ec:	15050913          	addi	s2,a0,336
    800016f0:	02a79363          	bne	a5,a0,80001716 <exit+0x52>
    panic("init exiting");
    800016f4:	00008517          	auipc	a0,0x8
    800016f8:	afc50513          	addi	a0,a0,-1284 # 800091f0 <etext+0x1f0>
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	596080e7          	jalr	1430(ra) # 80006c92 <panic>
      fileclose(f);
    80001704:	00002097          	auipc	ra,0x2
    80001708:	312080e7          	jalr	786(ra) # 80003a16 <fileclose>
      p->ofile[fd] = 0;
    8000170c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001710:	04a1                	addi	s1,s1,8
    80001712:	01248563          	beq	s1,s2,8000171c <exit+0x58>
    if(p->ofile[fd]){
    80001716:	6088                	ld	a0,0(s1)
    80001718:	f575                	bnez	a0,80001704 <exit+0x40>
    8000171a:	bfdd                	j	80001710 <exit+0x4c>
  begin_op();
    8000171c:	00002097          	auipc	ra,0x2
    80001720:	e2e080e7          	jalr	-466(ra) # 8000354a <begin_op>
  iput(p->cwd);
    80001724:	1509b503          	ld	a0,336(s3)
    80001728:	00001097          	auipc	ra,0x1
    8000172c:	61a080e7          	jalr	1562(ra) # 80002d42 <iput>
  end_op();
    80001730:	00002097          	auipc	ra,0x2
    80001734:	e9a080e7          	jalr	-358(ra) # 800035ca <end_op>
  p->cwd = 0;
    80001738:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000173c:	00008497          	auipc	s1,0x8
    80001740:	28c48493          	addi	s1,s1,652 # 800099c8 <wait_lock>
    80001744:	8526                	mv	a0,s1
    80001746:	00006097          	auipc	ra,0x6
    8000174a:	a96080e7          	jalr	-1386(ra) # 800071dc <acquire>
  reparent(p);
    8000174e:	854e                	mv	a0,s3
    80001750:	00000097          	auipc	ra,0x0
    80001754:	f1a080e7          	jalr	-230(ra) # 8000166a <reparent>
  wakeup(p->parent);
    80001758:	0389b503          	ld	a0,56(s3)
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	e98080e7          	jalr	-360(ra) # 800015f4 <wakeup>
  acquire(&p->lock);
    80001764:	854e                	mv	a0,s3
    80001766:	00006097          	auipc	ra,0x6
    8000176a:	a76080e7          	jalr	-1418(ra) # 800071dc <acquire>
  p->xstate = status;
    8000176e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001772:	4795                	li	a5,5
    80001774:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001778:	8526                	mv	a0,s1
    8000177a:	00006097          	auipc	ra,0x6
    8000177e:	b16080e7          	jalr	-1258(ra) # 80007290 <release>
  sched();
    80001782:	00000097          	auipc	ra,0x0
    80001786:	cfc080e7          	jalr	-772(ra) # 8000147e <sched>
  panic("zombie exit");
    8000178a:	00008517          	auipc	a0,0x8
    8000178e:	a7650513          	addi	a0,a0,-1418 # 80009200 <etext+0x200>
    80001792:	00005097          	auipc	ra,0x5
    80001796:	500080e7          	jalr	1280(ra) # 80006c92 <panic>

000000008000179a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000179a:	7179                	addi	sp,sp,-48
    8000179c:	f406                	sd	ra,40(sp)
    8000179e:	f022                	sd	s0,32(sp)
    800017a0:	ec26                	sd	s1,24(sp)
    800017a2:	e84a                	sd	s2,16(sp)
    800017a4:	e44e                	sd	s3,8(sp)
    800017a6:	1800                	addi	s0,sp,48
    800017a8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017aa:	00008497          	auipc	s1,0x8
    800017ae:	63648493          	addi	s1,s1,1590 # 80009de0 <proc>
    800017b2:	0000e997          	auipc	s3,0xe
    800017b6:	02e98993          	addi	s3,s3,46 # 8000f7e0 <tickslock>
    acquire(&p->lock);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00006097          	auipc	ra,0x6
    800017c0:	a20080e7          	jalr	-1504(ra) # 800071dc <acquire>
    if(p->pid == pid){
    800017c4:	589c                	lw	a5,48(s1)
    800017c6:	01278d63          	beq	a5,s2,800017e0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00006097          	auipc	ra,0x6
    800017d0:	ac4080e7          	jalr	-1340(ra) # 80007290 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017d4:	16848493          	addi	s1,s1,360
    800017d8:	ff3491e3          	bne	s1,s3,800017ba <kill+0x20>
  }
  return -1;
    800017dc:	557d                	li	a0,-1
    800017de:	a829                	j	800017f8 <kill+0x5e>
      p->killed = 1;
    800017e0:	4785                	li	a5,1
    800017e2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017e4:	4c98                	lw	a4,24(s1)
    800017e6:	4789                	li	a5,2
    800017e8:	00f70f63          	beq	a4,a5,80001806 <kill+0x6c>
      release(&p->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00006097          	auipc	ra,0x6
    800017f2:	aa2080e7          	jalr	-1374(ra) # 80007290 <release>
      return 0;
    800017f6:	4501                	li	a0,0
}
    800017f8:	70a2                	ld	ra,40(sp)
    800017fa:	7402                	ld	s0,32(sp)
    800017fc:	64e2                	ld	s1,24(sp)
    800017fe:	6942                	ld	s2,16(sp)
    80001800:	69a2                	ld	s3,8(sp)
    80001802:	6145                	addi	sp,sp,48
    80001804:	8082                	ret
        p->state = RUNNABLE;
    80001806:	478d                	li	a5,3
    80001808:	cc9c                	sw	a5,24(s1)
    8000180a:	b7cd                	j	800017ec <kill+0x52>

000000008000180c <setkilled>:

void
setkilled(struct proc *p)
{
    8000180c:	1101                	addi	sp,sp,-32
    8000180e:	ec06                	sd	ra,24(sp)
    80001810:	e822                	sd	s0,16(sp)
    80001812:	e426                	sd	s1,8(sp)
    80001814:	1000                	addi	s0,sp,32
    80001816:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001818:	00006097          	auipc	ra,0x6
    8000181c:	9c4080e7          	jalr	-1596(ra) # 800071dc <acquire>
  p->killed = 1;
    80001820:	4785                	li	a5,1
    80001822:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001824:	8526                	mv	a0,s1
    80001826:	00006097          	auipc	ra,0x6
    8000182a:	a6a080e7          	jalr	-1430(ra) # 80007290 <release>
}
    8000182e:	60e2                	ld	ra,24(sp)
    80001830:	6442                	ld	s0,16(sp)
    80001832:	64a2                	ld	s1,8(sp)
    80001834:	6105                	addi	sp,sp,32
    80001836:	8082                	ret

0000000080001838 <killed>:

int
killed(struct proc *p)
{
    80001838:	1101                	addi	sp,sp,-32
    8000183a:	ec06                	sd	ra,24(sp)
    8000183c:	e822                	sd	s0,16(sp)
    8000183e:	e426                	sd	s1,8(sp)
    80001840:	e04a                	sd	s2,0(sp)
    80001842:	1000                	addi	s0,sp,32
    80001844:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001846:	00006097          	auipc	ra,0x6
    8000184a:	996080e7          	jalr	-1642(ra) # 800071dc <acquire>
  k = p->killed;
    8000184e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00006097          	auipc	ra,0x6
    80001858:	a3c080e7          	jalr	-1476(ra) # 80007290 <release>
  return k;
}
    8000185c:	854a                	mv	a0,s2
    8000185e:	60e2                	ld	ra,24(sp)
    80001860:	6442                	ld	s0,16(sp)
    80001862:	64a2                	ld	s1,8(sp)
    80001864:	6902                	ld	s2,0(sp)
    80001866:	6105                	addi	sp,sp,32
    80001868:	8082                	ret

000000008000186a <wait>:
{
    8000186a:	715d                	addi	sp,sp,-80
    8000186c:	e486                	sd	ra,72(sp)
    8000186e:	e0a2                	sd	s0,64(sp)
    80001870:	fc26                	sd	s1,56(sp)
    80001872:	f84a                	sd	s2,48(sp)
    80001874:	f44e                	sd	s3,40(sp)
    80001876:	f052                	sd	s4,32(sp)
    80001878:	ec56                	sd	s5,24(sp)
    8000187a:	e85a                	sd	s6,16(sp)
    8000187c:	e45e                	sd	s7,8(sp)
    8000187e:	e062                	sd	s8,0(sp)
    80001880:	0880                	addi	s0,sp,80
    80001882:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001884:	fffff097          	auipc	ra,0xfffff
    80001888:	664080e7          	jalr	1636(ra) # 80000ee8 <myproc>
    8000188c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000188e:	00008517          	auipc	a0,0x8
    80001892:	13a50513          	addi	a0,a0,314 # 800099c8 <wait_lock>
    80001896:	00006097          	auipc	ra,0x6
    8000189a:	946080e7          	jalr	-1722(ra) # 800071dc <acquire>
    havekids = 0;
    8000189e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018a0:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018a2:	0000e997          	auipc	s3,0xe
    800018a6:	f3e98993          	addi	s3,s3,-194 # 8000f7e0 <tickslock>
        havekids = 1;
    800018aa:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018ac:	00008c17          	auipc	s8,0x8
    800018b0:	11cc0c13          	addi	s8,s8,284 # 800099c8 <wait_lock>
    havekids = 0;
    800018b4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b6:	00008497          	auipc	s1,0x8
    800018ba:	52a48493          	addi	s1,s1,1322 # 80009de0 <proc>
    800018be:	a0bd                	j	8000192c <wait+0xc2>
          pid = pp->pid;
    800018c0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018c4:	000b0e63          	beqz	s6,800018e0 <wait+0x76>
    800018c8:	4691                	li	a3,4
    800018ca:	02c48613          	addi	a2,s1,44
    800018ce:	85da                	mv	a1,s6
    800018d0:	05093503          	ld	a0,80(s2)
    800018d4:	fffff097          	auipc	ra,0xfffff
    800018d8:	29e080e7          	jalr	670(ra) # 80000b72 <copyout>
    800018dc:	02054563          	bltz	a0,80001906 <wait+0x9c>
          freeproc(pp);
    800018e0:	8526                	mv	a0,s1
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	7bc080e7          	jalr	1980(ra) # 8000109e <freeproc>
          release(&pp->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00006097          	auipc	ra,0x6
    800018f0:	9a4080e7          	jalr	-1628(ra) # 80007290 <release>
          release(&wait_lock);
    800018f4:	00008517          	auipc	a0,0x8
    800018f8:	0d450513          	addi	a0,a0,212 # 800099c8 <wait_lock>
    800018fc:	00006097          	auipc	ra,0x6
    80001900:	994080e7          	jalr	-1644(ra) # 80007290 <release>
          return pid;
    80001904:	a0b5                	j	80001970 <wait+0x106>
            release(&pp->lock);
    80001906:	8526                	mv	a0,s1
    80001908:	00006097          	auipc	ra,0x6
    8000190c:	988080e7          	jalr	-1656(ra) # 80007290 <release>
            release(&wait_lock);
    80001910:	00008517          	auipc	a0,0x8
    80001914:	0b850513          	addi	a0,a0,184 # 800099c8 <wait_lock>
    80001918:	00006097          	auipc	ra,0x6
    8000191c:	978080e7          	jalr	-1672(ra) # 80007290 <release>
            return -1;
    80001920:	59fd                	li	s3,-1
    80001922:	a0b9                	j	80001970 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001924:	16848493          	addi	s1,s1,360
    80001928:	03348463          	beq	s1,s3,80001950 <wait+0xe6>
      if(pp->parent == p){
    8000192c:	7c9c                	ld	a5,56(s1)
    8000192e:	ff279be3          	bne	a5,s2,80001924 <wait+0xba>
        acquire(&pp->lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00006097          	auipc	ra,0x6
    80001938:	8a8080e7          	jalr	-1880(ra) # 800071dc <acquire>
        if(pp->state == ZOMBIE){
    8000193c:	4c9c                	lw	a5,24(s1)
    8000193e:	f94781e3          	beq	a5,s4,800018c0 <wait+0x56>
        release(&pp->lock);
    80001942:	8526                	mv	a0,s1
    80001944:	00006097          	auipc	ra,0x6
    80001948:	94c080e7          	jalr	-1716(ra) # 80007290 <release>
        havekids = 1;
    8000194c:	8756                	mv	a4,s5
    8000194e:	bfd9                	j	80001924 <wait+0xba>
    if(!havekids || killed(p)){
    80001950:	c719                	beqz	a4,8000195e <wait+0xf4>
    80001952:	854a                	mv	a0,s2
    80001954:	00000097          	auipc	ra,0x0
    80001958:	ee4080e7          	jalr	-284(ra) # 80001838 <killed>
    8000195c:	c51d                	beqz	a0,8000198a <wait+0x120>
      release(&wait_lock);
    8000195e:	00008517          	auipc	a0,0x8
    80001962:	06a50513          	addi	a0,a0,106 # 800099c8 <wait_lock>
    80001966:	00006097          	auipc	ra,0x6
    8000196a:	92a080e7          	jalr	-1750(ra) # 80007290 <release>
      return -1;
    8000196e:	59fd                	li	s3,-1
}
    80001970:	854e                	mv	a0,s3
    80001972:	60a6                	ld	ra,72(sp)
    80001974:	6406                	ld	s0,64(sp)
    80001976:	74e2                	ld	s1,56(sp)
    80001978:	7942                	ld	s2,48(sp)
    8000197a:	79a2                	ld	s3,40(sp)
    8000197c:	7a02                	ld	s4,32(sp)
    8000197e:	6ae2                	ld	s5,24(sp)
    80001980:	6b42                	ld	s6,16(sp)
    80001982:	6ba2                	ld	s7,8(sp)
    80001984:	6c02                	ld	s8,0(sp)
    80001986:	6161                	addi	sp,sp,80
    80001988:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000198a:	85e2                	mv	a1,s8
    8000198c:	854a                	mv	a0,s2
    8000198e:	00000097          	auipc	ra,0x0
    80001992:	c02080e7          	jalr	-1022(ra) # 80001590 <sleep>
    havekids = 0;
    80001996:	bf39                	j	800018b4 <wait+0x4a>

0000000080001998 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001998:	7179                	addi	sp,sp,-48
    8000199a:	f406                	sd	ra,40(sp)
    8000199c:	f022                	sd	s0,32(sp)
    8000199e:	ec26                	sd	s1,24(sp)
    800019a0:	e84a                	sd	s2,16(sp)
    800019a2:	e44e                	sd	s3,8(sp)
    800019a4:	e052                	sd	s4,0(sp)
    800019a6:	1800                	addi	s0,sp,48
    800019a8:	84aa                	mv	s1,a0
    800019aa:	892e                	mv	s2,a1
    800019ac:	89b2                	mv	s3,a2
    800019ae:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	538080e7          	jalr	1336(ra) # 80000ee8 <myproc>
  if(user_dst){
    800019b8:	c08d                	beqz	s1,800019da <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019ba:	86d2                	mv	a3,s4
    800019bc:	864e                	mv	a2,s3
    800019be:	85ca                	mv	a1,s2
    800019c0:	6928                	ld	a0,80(a0)
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	1b0080e7          	jalr	432(ra) # 80000b72 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019ca:	70a2                	ld	ra,40(sp)
    800019cc:	7402                	ld	s0,32(sp)
    800019ce:	64e2                	ld	s1,24(sp)
    800019d0:	6942                	ld	s2,16(sp)
    800019d2:	69a2                	ld	s3,8(sp)
    800019d4:	6a02                	ld	s4,0(sp)
    800019d6:	6145                	addi	sp,sp,48
    800019d8:	8082                	ret
    memmove((char *)dst, src, len);
    800019da:	000a061b          	sext.w	a2,s4
    800019de:	85ce                	mv	a1,s3
    800019e0:	854a                	mv	a0,s2
    800019e2:	ffffe097          	auipc	ra,0xffffe
    800019e6:	7f6080e7          	jalr	2038(ra) # 800001d8 <memmove>
    return 0;
    800019ea:	8526                	mv	a0,s1
    800019ec:	bff9                	j	800019ca <either_copyout+0x32>

00000000800019ee <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019ee:	7179                	addi	sp,sp,-48
    800019f0:	f406                	sd	ra,40(sp)
    800019f2:	f022                	sd	s0,32(sp)
    800019f4:	ec26                	sd	s1,24(sp)
    800019f6:	e84a                	sd	s2,16(sp)
    800019f8:	e44e                	sd	s3,8(sp)
    800019fa:	e052                	sd	s4,0(sp)
    800019fc:	1800                	addi	s0,sp,48
    800019fe:	892a                	mv	s2,a0
    80001a00:	84ae                	mv	s1,a1
    80001a02:	89b2                	mv	s3,a2
    80001a04:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a06:	fffff097          	auipc	ra,0xfffff
    80001a0a:	4e2080e7          	jalr	1250(ra) # 80000ee8 <myproc>
  if(user_src){
    80001a0e:	c08d                	beqz	s1,80001a30 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a10:	86d2                	mv	a3,s4
    80001a12:	864e                	mv	a2,s3
    80001a14:	85ca                	mv	a1,s2
    80001a16:	6928                	ld	a0,80(a0)
    80001a18:	fffff097          	auipc	ra,0xfffff
    80001a1c:	21e080e7          	jalr	542(ra) # 80000c36 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a20:	70a2                	ld	ra,40(sp)
    80001a22:	7402                	ld	s0,32(sp)
    80001a24:	64e2                	ld	s1,24(sp)
    80001a26:	6942                	ld	s2,16(sp)
    80001a28:	69a2                	ld	s3,8(sp)
    80001a2a:	6a02                	ld	s4,0(sp)
    80001a2c:	6145                	addi	sp,sp,48
    80001a2e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a30:	000a061b          	sext.w	a2,s4
    80001a34:	85ce                	mv	a1,s3
    80001a36:	854a                	mv	a0,s2
    80001a38:	ffffe097          	auipc	ra,0xffffe
    80001a3c:	7a0080e7          	jalr	1952(ra) # 800001d8 <memmove>
    return 0;
    80001a40:	8526                	mv	a0,s1
    80001a42:	bff9                	j	80001a20 <either_copyin+0x32>

0000000080001a44 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a44:	715d                	addi	sp,sp,-80
    80001a46:	e486                	sd	ra,72(sp)
    80001a48:	e0a2                	sd	s0,64(sp)
    80001a4a:	fc26                	sd	s1,56(sp)
    80001a4c:	f84a                	sd	s2,48(sp)
    80001a4e:	f44e                	sd	s3,40(sp)
    80001a50:	f052                	sd	s4,32(sp)
    80001a52:	ec56                	sd	s5,24(sp)
    80001a54:	e85a                	sd	s6,16(sp)
    80001a56:	e45e                	sd	s7,8(sp)
    80001a58:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a5a:	00007517          	auipc	a0,0x7
    80001a5e:	5ee50513          	addi	a0,a0,1518 # 80009048 <etext+0x48>
    80001a62:	00005097          	auipc	ra,0x5
    80001a66:	27a080e7          	jalr	634(ra) # 80006cdc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a6a:	00008497          	auipc	s1,0x8
    80001a6e:	4ce48493          	addi	s1,s1,1230 # 80009f38 <proc+0x158>
    80001a72:	0000e917          	auipc	s2,0xe
    80001a76:	ec690913          	addi	s2,s2,-314 # 8000f938 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a7a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a7c:	00007997          	auipc	s3,0x7
    80001a80:	79498993          	addi	s3,s3,1940 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001a84:	00007a97          	auipc	s5,0x7
    80001a88:	794a8a93          	addi	s5,s5,1940 # 80009218 <etext+0x218>
    printf("\n");
    80001a8c:	00007a17          	auipc	s4,0x7
    80001a90:	5bca0a13          	addi	s4,s4,1468 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a94:	00007b97          	auipc	s7,0x7
    80001a98:	7c4b8b93          	addi	s7,s7,1988 # 80009258 <states.1770>
    80001a9c:	a00d                	j	80001abe <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a9e:	ed86a583          	lw	a1,-296(a3)
    80001aa2:	8556                	mv	a0,s5
    80001aa4:	00005097          	auipc	ra,0x5
    80001aa8:	238080e7          	jalr	568(ra) # 80006cdc <printf>
    printf("\n");
    80001aac:	8552                	mv	a0,s4
    80001aae:	00005097          	auipc	ra,0x5
    80001ab2:	22e080e7          	jalr	558(ra) # 80006cdc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ab6:	16848493          	addi	s1,s1,360
    80001aba:	03248163          	beq	s1,s2,80001adc <procdump+0x98>
    if(p->state == UNUSED)
    80001abe:	86a6                	mv	a3,s1
    80001ac0:	ec04a783          	lw	a5,-320(s1)
    80001ac4:	dbed                	beqz	a5,80001ab6 <procdump+0x72>
      state = "???";
    80001ac6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ac8:	fcfb6be3          	bltu	s6,a5,80001a9e <procdump+0x5a>
    80001acc:	1782                	slli	a5,a5,0x20
    80001ace:	9381                	srli	a5,a5,0x20
    80001ad0:	078e                	slli	a5,a5,0x3
    80001ad2:	97de                	add	a5,a5,s7
    80001ad4:	6390                	ld	a2,0(a5)
    80001ad6:	f661                	bnez	a2,80001a9e <procdump+0x5a>
      state = "???";
    80001ad8:	864e                	mv	a2,s3
    80001ada:	b7d1                	j	80001a9e <procdump+0x5a>
  }
}
    80001adc:	60a6                	ld	ra,72(sp)
    80001ade:	6406                	ld	s0,64(sp)
    80001ae0:	74e2                	ld	s1,56(sp)
    80001ae2:	7942                	ld	s2,48(sp)
    80001ae4:	79a2                	ld	s3,40(sp)
    80001ae6:	7a02                	ld	s4,32(sp)
    80001ae8:	6ae2                	ld	s5,24(sp)
    80001aea:	6b42                	ld	s6,16(sp)
    80001aec:	6ba2                	ld	s7,8(sp)
    80001aee:	6161                	addi	sp,sp,80
    80001af0:	8082                	ret

0000000080001af2 <swtch>:
    80001af2:	00153023          	sd	ra,0(a0)
    80001af6:	00253423          	sd	sp,8(a0)
    80001afa:	e900                	sd	s0,16(a0)
    80001afc:	ed04                	sd	s1,24(a0)
    80001afe:	03253023          	sd	s2,32(a0)
    80001b02:	03353423          	sd	s3,40(a0)
    80001b06:	03453823          	sd	s4,48(a0)
    80001b0a:	03553c23          	sd	s5,56(a0)
    80001b0e:	05653023          	sd	s6,64(a0)
    80001b12:	05753423          	sd	s7,72(a0)
    80001b16:	05853823          	sd	s8,80(a0)
    80001b1a:	05953c23          	sd	s9,88(a0)
    80001b1e:	07a53023          	sd	s10,96(a0)
    80001b22:	07b53423          	sd	s11,104(a0)
    80001b26:	0005b083          	ld	ra,0(a1)
    80001b2a:	0085b103          	ld	sp,8(a1)
    80001b2e:	6980                	ld	s0,16(a1)
    80001b30:	6d84                	ld	s1,24(a1)
    80001b32:	0205b903          	ld	s2,32(a1)
    80001b36:	0285b983          	ld	s3,40(a1)
    80001b3a:	0305ba03          	ld	s4,48(a1)
    80001b3e:	0385ba83          	ld	s5,56(a1)
    80001b42:	0405bb03          	ld	s6,64(a1)
    80001b46:	0485bb83          	ld	s7,72(a1)
    80001b4a:	0505bc03          	ld	s8,80(a1)
    80001b4e:	0585bc83          	ld	s9,88(a1)
    80001b52:	0605bd03          	ld	s10,96(a1)
    80001b56:	0685bd83          	ld	s11,104(a1)
    80001b5a:	8082                	ret

0000000080001b5c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b5c:	1141                	addi	sp,sp,-16
    80001b5e:	e406                	sd	ra,8(sp)
    80001b60:	e022                	sd	s0,0(sp)
    80001b62:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b64:	00007597          	auipc	a1,0x7
    80001b68:	72458593          	addi	a1,a1,1828 # 80009288 <states.1770+0x30>
    80001b6c:	0000e517          	auipc	a0,0xe
    80001b70:	c7450513          	addi	a0,a0,-908 # 8000f7e0 <tickslock>
    80001b74:	00005097          	auipc	ra,0x5
    80001b78:	5d8080e7          	jalr	1496(ra) # 8000714c <initlock>
}
    80001b7c:	60a2                	ld	ra,8(sp)
    80001b7e:	6402                	ld	s0,0(sp)
    80001b80:	0141                	addi	sp,sp,16
    80001b82:	8082                	ret

0000000080001b84 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b84:	1141                	addi	sp,sp,-16
    80001b86:	e422                	sd	s0,8(sp)
    80001b88:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b8a:	00003797          	auipc	a5,0x3
    80001b8e:	57678793          	addi	a5,a5,1398 # 80005100 <kernelvec>
    80001b92:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b96:	6422                	ld	s0,8(sp)
    80001b98:	0141                	addi	sp,sp,16
    80001b9a:	8082                	ret

0000000080001b9c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b9c:	1141                	addi	sp,sp,-16
    80001b9e:	e406                	sd	ra,8(sp)
    80001ba0:	e022                	sd	s0,0(sp)
    80001ba2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	344080e7          	jalr	836(ra) # 80000ee8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bb0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bb6:	00006617          	auipc	a2,0x6
    80001bba:	44a60613          	addi	a2,a2,1098 # 80008000 <_trampoline>
    80001bbe:	00006697          	auipc	a3,0x6
    80001bc2:	44268693          	addi	a3,a3,1090 # 80008000 <_trampoline>
    80001bc6:	8e91                	sub	a3,a3,a2
    80001bc8:	040007b7          	lui	a5,0x4000
    80001bcc:	17fd                	addi	a5,a5,-1
    80001bce:	07b2                	slli	a5,a5,0xc
    80001bd0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bd2:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bd6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bd8:	180026f3          	csrr	a3,satp
    80001bdc:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bde:	6d38                	ld	a4,88(a0)
    80001be0:	6134                	ld	a3,64(a0)
    80001be2:	6585                	lui	a1,0x1
    80001be4:	96ae                	add	a3,a3,a1
    80001be6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001be8:	6d38                	ld	a4,88(a0)
    80001bea:	00000697          	auipc	a3,0x0
    80001bee:	14268693          	addi	a3,a3,322 # 80001d2c <usertrap>
    80001bf2:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bf4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bf6:	8692                	mv	a3,tp
    80001bf8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bfa:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bfe:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c02:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c06:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c0a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c0c:	6f18                	ld	a4,24(a4)
    80001c0e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c12:	6928                	ld	a0,80(a0)
    80001c14:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c16:	00006717          	auipc	a4,0x6
    80001c1a:	48670713          	addi	a4,a4,1158 # 8000809c <userret>
    80001c1e:	8f11                	sub	a4,a4,a2
    80001c20:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c22:	577d                	li	a4,-1
    80001c24:	177e                	slli	a4,a4,0x3f
    80001c26:	8d59                	or	a0,a0,a4
    80001c28:	9782                	jalr	a5
}
    80001c2a:	60a2                	ld	ra,8(sp)
    80001c2c:	6402                	ld	s0,0(sp)
    80001c2e:	0141                	addi	sp,sp,16
    80001c30:	8082                	ret

0000000080001c32 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c3c:	0000e497          	auipc	s1,0xe
    80001c40:	ba448493          	addi	s1,s1,-1116 # 8000f7e0 <tickslock>
    80001c44:	8526                	mv	a0,s1
    80001c46:	00005097          	auipc	ra,0x5
    80001c4a:	596080e7          	jalr	1430(ra) # 800071dc <acquire>
  ticks++;
    80001c4e:	00008517          	auipc	a0,0x8
    80001c52:	d0a50513          	addi	a0,a0,-758 # 80009958 <ticks>
    80001c56:	411c                	lw	a5,0(a0)
    80001c58:	2785                	addiw	a5,a5,1
    80001c5a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	998080e7          	jalr	-1640(ra) # 800015f4 <wakeup>
  release(&tickslock);
    80001c64:	8526                	mv	a0,s1
    80001c66:	00005097          	auipc	ra,0x5
    80001c6a:	62a080e7          	jalr	1578(ra) # 80007290 <release>
}
    80001c6e:	60e2                	ld	ra,24(sp)
    80001c70:	6442                	ld	s0,16(sp)
    80001c72:	64a2                	ld	s1,8(sp)
    80001c74:	6105                	addi	sp,sp,32
    80001c76:	8082                	ret

0000000080001c78 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c78:	1101                	addi	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c82:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c86:	00074d63          	bltz	a4,80001ca0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c8a:	57fd                	li	a5,-1
    80001c8c:	17fe                	slli	a5,a5,0x3f
    80001c8e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c90:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c92:	06f70c63          	beq	a4,a5,80001d0a <devintr+0x92>
  }
}
    80001c96:	60e2                	ld	ra,24(sp)
    80001c98:	6442                	ld	s0,16(sp)
    80001c9a:	64a2                	ld	s1,8(sp)
    80001c9c:	6105                	addi	sp,sp,32
    80001c9e:	8082                	ret
     (scause & 0xff) == 9){
    80001ca0:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001ca4:	46a5                	li	a3,9
    80001ca6:	fed792e3          	bne	a5,a3,80001c8a <devintr+0x12>
    int irq = plic_claim();
    80001caa:	00003097          	auipc	ra,0x3
    80001cae:	578080e7          	jalr	1400(ra) # 80005222 <plic_claim>
    80001cb2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cb4:	47a9                	li	a5,10
    80001cb6:	02f50563          	beq	a0,a5,80001ce0 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001cba:	4785                	li	a5,1
    80001cbc:	02f50d63          	beq	a0,a5,80001cf6 <devintr+0x7e>
    else if(irq == E1000_IRQ){
    80001cc0:	02100793          	li	a5,33
    80001cc4:	02f50e63          	beq	a0,a5,80001d00 <devintr+0x88>
    return 1;
    80001cc8:	4505                	li	a0,1
    else if(irq){
    80001cca:	d4f1                	beqz	s1,80001c96 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ccc:	85a6                	mv	a1,s1
    80001cce:	00007517          	auipc	a0,0x7
    80001cd2:	5c250513          	addi	a0,a0,1474 # 80009290 <states.1770+0x38>
    80001cd6:	00005097          	auipc	ra,0x5
    80001cda:	006080e7          	jalr	6(ra) # 80006cdc <printf>
    80001cde:	a029                	j	80001ce8 <devintr+0x70>
      uartintr();
    80001ce0:	00005097          	auipc	ra,0x5
    80001ce4:	41c080e7          	jalr	1052(ra) # 800070fc <uartintr>
      plic_complete(irq);
    80001ce8:	8526                	mv	a0,s1
    80001cea:	00003097          	auipc	ra,0x3
    80001cee:	55c080e7          	jalr	1372(ra) # 80005246 <plic_complete>
    return 1;
    80001cf2:	4505                	li	a0,1
    80001cf4:	b74d                	j	80001c96 <devintr+0x1e>
      virtio_disk_intr();
    80001cf6:	00004097          	auipc	ra,0x4
    80001cfa:	a7a080e7          	jalr	-1414(ra) # 80005770 <virtio_disk_intr>
    80001cfe:	b7ed                	j	80001ce8 <devintr+0x70>
      e1000_intr();
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	d92080e7          	jalr	-622(ra) # 80005a92 <e1000_intr>
    80001d08:	b7c5                	j	80001ce8 <devintr+0x70>
    if(cpuid() == 0){
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	1b2080e7          	jalr	434(ra) # 80000ebc <cpuid>
    80001d12:	c901                	beqz	a0,80001d22 <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d14:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d1a:	14479073          	csrw	sip,a5
    return 2;
    80001d1e:	4509                	li	a0,2
    80001d20:	bf9d                	j	80001c96 <devintr+0x1e>
      clockintr();
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	f10080e7          	jalr	-240(ra) # 80001c32 <clockintr>
    80001d2a:	b7ed                	j	80001d14 <devintr+0x9c>

0000000080001d2c <usertrap>:
{
    80001d2c:	1101                	addi	sp,sp,-32
    80001d2e:	ec06                	sd	ra,24(sp)
    80001d30:	e822                	sd	s0,16(sp)
    80001d32:	e426                	sd	s1,8(sp)
    80001d34:	e04a                	sd	s2,0(sp)
    80001d36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d3c:	1007f793          	andi	a5,a5,256
    80001d40:	e3b1                	bnez	a5,80001d84 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d42:	00003797          	auipc	a5,0x3
    80001d46:	3be78793          	addi	a5,a5,958 # 80005100 <kernelvec>
    80001d4a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	19a080e7          	jalr	410(ra) # 80000ee8 <myproc>
    80001d56:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d58:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d5a:	14102773          	csrr	a4,sepc
    80001d5e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d60:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d64:	47a1                	li	a5,8
    80001d66:	02f70763          	beq	a4,a5,80001d94 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	f0e080e7          	jalr	-242(ra) # 80001c78 <devintr>
    80001d72:	892a                	mv	s2,a0
    80001d74:	c151                	beqz	a0,80001df8 <usertrap+0xcc>
  if(killed(p))
    80001d76:	8526                	mv	a0,s1
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	ac0080e7          	jalr	-1344(ra) # 80001838 <killed>
    80001d80:	c929                	beqz	a0,80001dd2 <usertrap+0xa6>
    80001d82:	a099                	j	80001dc8 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d84:	00007517          	auipc	a0,0x7
    80001d88:	52c50513          	addi	a0,a0,1324 # 800092b0 <states.1770+0x58>
    80001d8c:	00005097          	auipc	ra,0x5
    80001d90:	f06080e7          	jalr	-250(ra) # 80006c92 <panic>
    if(killed(p))
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	aa4080e7          	jalr	-1372(ra) # 80001838 <killed>
    80001d9c:	e921                	bnez	a0,80001dec <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d9e:	6cb8                	ld	a4,88(s1)
    80001da0:	6f1c                	ld	a5,24(a4)
    80001da2:	0791                	addi	a5,a5,4
    80001da4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001daa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dae:	10079073          	csrw	sstatus,a5
    syscall();
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	2d4080e7          	jalr	724(ra) # 80002086 <syscall>
  if(killed(p))
    80001dba:	8526                	mv	a0,s1
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	a7c080e7          	jalr	-1412(ra) # 80001838 <killed>
    80001dc4:	c911                	beqz	a0,80001dd8 <usertrap+0xac>
    80001dc6:	4901                	li	s2,0
    exit(-1);
    80001dc8:	557d                	li	a0,-1
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	8fa080e7          	jalr	-1798(ra) # 800016c4 <exit>
  if(which_dev == 2)
    80001dd2:	4789                	li	a5,2
    80001dd4:	04f90f63          	beq	s2,a5,80001e32 <usertrap+0x106>
  usertrapret();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	dc4080e7          	jalr	-572(ra) # 80001b9c <usertrapret>
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	64a2                	ld	s1,8(sp)
    80001de6:	6902                	ld	s2,0(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret
      exit(-1);
    80001dec:	557d                	li	a0,-1
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	8d6080e7          	jalr	-1834(ra) # 800016c4 <exit>
    80001df6:	b765                	j	80001d9e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dfc:	5890                	lw	a2,48(s1)
    80001dfe:	00007517          	auipc	a0,0x7
    80001e02:	4d250513          	addi	a0,a0,1234 # 800092d0 <states.1770+0x78>
    80001e06:	00005097          	auipc	ra,0x5
    80001e0a:	ed6080e7          	jalr	-298(ra) # 80006cdc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e12:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e16:	00007517          	auipc	a0,0x7
    80001e1a:	4ea50513          	addi	a0,a0,1258 # 80009300 <states.1770+0xa8>
    80001e1e:	00005097          	auipc	ra,0x5
    80001e22:	ebe080e7          	jalr	-322(ra) # 80006cdc <printf>
    setkilled(p);
    80001e26:	8526                	mv	a0,s1
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	9e4080e7          	jalr	-1564(ra) # 8000180c <setkilled>
    80001e30:	b769                	j	80001dba <usertrap+0x8e>
    yield();
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	722080e7          	jalr	1826(ra) # 80001554 <yield>
    80001e3a:	bf79                	j	80001dd8 <usertrap+0xac>

0000000080001e3c <kerneltrap>:
{
    80001e3c:	7179                	addi	sp,sp,-48
    80001e3e:	f406                	sd	ra,40(sp)
    80001e40:	f022                	sd	s0,32(sp)
    80001e42:	ec26                	sd	s1,24(sp)
    80001e44:	e84a                	sd	s2,16(sp)
    80001e46:	e44e                	sd	s3,8(sp)
    80001e48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e52:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e56:	1004f793          	andi	a5,s1,256
    80001e5a:	cb85                	beqz	a5,80001e8a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e60:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e62:	ef85                	bnez	a5,80001e9a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	e14080e7          	jalr	-492(ra) # 80001c78 <devintr>
    80001e6c:	cd1d                	beqz	a0,80001eaa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e6e:	4789                	li	a5,2
    80001e70:	06f50a63          	beq	a0,a5,80001ee4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e74:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e78:	10049073          	csrw	sstatus,s1
}
    80001e7c:	70a2                	ld	ra,40(sp)
    80001e7e:	7402                	ld	s0,32(sp)
    80001e80:	64e2                	ld	s1,24(sp)
    80001e82:	6942                	ld	s2,16(sp)
    80001e84:	69a2                	ld	s3,8(sp)
    80001e86:	6145                	addi	sp,sp,48
    80001e88:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e8a:	00007517          	auipc	a0,0x7
    80001e8e:	49650513          	addi	a0,a0,1174 # 80009320 <states.1770+0xc8>
    80001e92:	00005097          	auipc	ra,0x5
    80001e96:	e00080e7          	jalr	-512(ra) # 80006c92 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e9a:	00007517          	auipc	a0,0x7
    80001e9e:	4ae50513          	addi	a0,a0,1198 # 80009348 <states.1770+0xf0>
    80001ea2:	00005097          	auipc	ra,0x5
    80001ea6:	df0080e7          	jalr	-528(ra) # 80006c92 <panic>
    printf("scause %p\n", scause);
    80001eaa:	85ce                	mv	a1,s3
    80001eac:	00007517          	auipc	a0,0x7
    80001eb0:	4bc50513          	addi	a0,a0,1212 # 80009368 <states.1770+0x110>
    80001eb4:	00005097          	auipc	ra,0x5
    80001eb8:	e28080e7          	jalr	-472(ra) # 80006cdc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ebc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ec4:	00007517          	auipc	a0,0x7
    80001ec8:	4b450513          	addi	a0,a0,1204 # 80009378 <states.1770+0x120>
    80001ecc:	00005097          	auipc	ra,0x5
    80001ed0:	e10080e7          	jalr	-496(ra) # 80006cdc <printf>
    panic("kerneltrap");
    80001ed4:	00007517          	auipc	a0,0x7
    80001ed8:	4bc50513          	addi	a0,a0,1212 # 80009390 <states.1770+0x138>
    80001edc:	00005097          	auipc	ra,0x5
    80001ee0:	db6080e7          	jalr	-586(ra) # 80006c92 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	004080e7          	jalr	4(ra) # 80000ee8 <myproc>
    80001eec:	d541                	beqz	a0,80001e74 <kerneltrap+0x38>
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	ffa080e7          	jalr	-6(ra) # 80000ee8 <myproc>
    80001ef6:	4d18                	lw	a4,24(a0)
    80001ef8:	4791                	li	a5,4
    80001efa:	f6f71de3          	bne	a4,a5,80001e74 <kerneltrap+0x38>
    yield();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	656080e7          	jalr	1622(ra) # 80001554 <yield>
    80001f06:	b7bd                	j	80001e74 <kerneltrap+0x38>

0000000080001f08 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f08:	1101                	addi	sp,sp,-32
    80001f0a:	ec06                	sd	ra,24(sp)
    80001f0c:	e822                	sd	s0,16(sp)
    80001f0e:	e426                	sd	s1,8(sp)
    80001f10:	1000                	addi	s0,sp,32
    80001f12:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	fd4080e7          	jalr	-44(ra) # 80000ee8 <myproc>
  switch (n) {
    80001f1c:	4795                	li	a5,5
    80001f1e:	0497e163          	bltu	a5,s1,80001f60 <argraw+0x58>
    80001f22:	048a                	slli	s1,s1,0x2
    80001f24:	00007717          	auipc	a4,0x7
    80001f28:	4a470713          	addi	a4,a4,1188 # 800093c8 <states.1770+0x170>
    80001f2c:	94ba                	add	s1,s1,a4
    80001f2e:	409c                	lw	a5,0(s1)
    80001f30:	97ba                	add	a5,a5,a4
    80001f32:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f34:	6d3c                	ld	a5,88(a0)
    80001f36:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f38:	60e2                	ld	ra,24(sp)
    80001f3a:	6442                	ld	s0,16(sp)
    80001f3c:	64a2                	ld	s1,8(sp)
    80001f3e:	6105                	addi	sp,sp,32
    80001f40:	8082                	ret
    return p->trapframe->a1;
    80001f42:	6d3c                	ld	a5,88(a0)
    80001f44:	7fa8                	ld	a0,120(a5)
    80001f46:	bfcd                	j	80001f38 <argraw+0x30>
    return p->trapframe->a2;
    80001f48:	6d3c                	ld	a5,88(a0)
    80001f4a:	63c8                	ld	a0,128(a5)
    80001f4c:	b7f5                	j	80001f38 <argraw+0x30>
    return p->trapframe->a3;
    80001f4e:	6d3c                	ld	a5,88(a0)
    80001f50:	67c8                	ld	a0,136(a5)
    80001f52:	b7dd                	j	80001f38 <argraw+0x30>
    return p->trapframe->a4;
    80001f54:	6d3c                	ld	a5,88(a0)
    80001f56:	6bc8                	ld	a0,144(a5)
    80001f58:	b7c5                	j	80001f38 <argraw+0x30>
    return p->trapframe->a5;
    80001f5a:	6d3c                	ld	a5,88(a0)
    80001f5c:	6fc8                	ld	a0,152(a5)
    80001f5e:	bfe9                	j	80001f38 <argraw+0x30>
  panic("argraw");
    80001f60:	00007517          	auipc	a0,0x7
    80001f64:	44050513          	addi	a0,a0,1088 # 800093a0 <states.1770+0x148>
    80001f68:	00005097          	auipc	ra,0x5
    80001f6c:	d2a080e7          	jalr	-726(ra) # 80006c92 <panic>

0000000080001f70 <fetchaddr>:
{
    80001f70:	1101                	addi	sp,sp,-32
    80001f72:	ec06                	sd	ra,24(sp)
    80001f74:	e822                	sd	s0,16(sp)
    80001f76:	e426                	sd	s1,8(sp)
    80001f78:	e04a                	sd	s2,0(sp)
    80001f7a:	1000                	addi	s0,sp,32
    80001f7c:	84aa                	mv	s1,a0
    80001f7e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	f68080e7          	jalr	-152(ra) # 80000ee8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f88:	653c                	ld	a5,72(a0)
    80001f8a:	02f4f863          	bgeu	s1,a5,80001fba <fetchaddr+0x4a>
    80001f8e:	00848713          	addi	a4,s1,8
    80001f92:	02e7e663          	bltu	a5,a4,80001fbe <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f96:	46a1                	li	a3,8
    80001f98:	8626                	mv	a2,s1
    80001f9a:	85ca                	mv	a1,s2
    80001f9c:	6928                	ld	a0,80(a0)
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	c98080e7          	jalr	-872(ra) # 80000c36 <copyin>
    80001fa6:	00a03533          	snez	a0,a0
    80001faa:	40a00533          	neg	a0,a0
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6902                	ld	s2,0(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret
    return -1;
    80001fba:	557d                	li	a0,-1
    80001fbc:	bfcd                	j	80001fae <fetchaddr+0x3e>
    80001fbe:	557d                	li	a0,-1
    80001fc0:	b7fd                	j	80001fae <fetchaddr+0x3e>

0000000080001fc2 <fetchstr>:
{
    80001fc2:	7179                	addi	sp,sp,-48
    80001fc4:	f406                	sd	ra,40(sp)
    80001fc6:	f022                	sd	s0,32(sp)
    80001fc8:	ec26                	sd	s1,24(sp)
    80001fca:	e84a                	sd	s2,16(sp)
    80001fcc:	e44e                	sd	s3,8(sp)
    80001fce:	1800                	addi	s0,sp,48
    80001fd0:	892a                	mv	s2,a0
    80001fd2:	84ae                	mv	s1,a1
    80001fd4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	f12080e7          	jalr	-238(ra) # 80000ee8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fde:	86ce                	mv	a3,s3
    80001fe0:	864a                	mv	a2,s2
    80001fe2:	85a6                	mv	a1,s1
    80001fe4:	6928                	ld	a0,80(a0)
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	cdc080e7          	jalr	-804(ra) # 80000cc2 <copyinstr>
    80001fee:	00054e63          	bltz	a0,8000200a <fetchstr+0x48>
  return strlen(buf);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	ffffe097          	auipc	ra,0xffffe
    80001ff8:	308080e7          	jalr	776(ra) # 800002fc <strlen>
}
    80001ffc:	70a2                	ld	ra,40(sp)
    80001ffe:	7402                	ld	s0,32(sp)
    80002000:	64e2                	ld	s1,24(sp)
    80002002:	6942                	ld	s2,16(sp)
    80002004:	69a2                	ld	s3,8(sp)
    80002006:	6145                	addi	sp,sp,48
    80002008:	8082                	ret
    return -1;
    8000200a:	557d                	li	a0,-1
    8000200c:	bfc5                	j	80001ffc <fetchstr+0x3a>

000000008000200e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000200e:	1101                	addi	sp,sp,-32
    80002010:	ec06                	sd	ra,24(sp)
    80002012:	e822                	sd	s0,16(sp)
    80002014:	e426                	sd	s1,8(sp)
    80002016:	1000                	addi	s0,sp,32
    80002018:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	eee080e7          	jalr	-274(ra) # 80001f08 <argraw>
    80002022:	c088                	sw	a0,0(s1)
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret

000000008000202e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000202e:	1101                	addi	sp,sp,-32
    80002030:	ec06                	sd	ra,24(sp)
    80002032:	e822                	sd	s0,16(sp)
    80002034:	e426                	sd	s1,8(sp)
    80002036:	1000                	addi	s0,sp,32
    80002038:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	ece080e7          	jalr	-306(ra) # 80001f08 <argraw>
    80002042:	e088                	sd	a0,0(s1)
}
    80002044:	60e2                	ld	ra,24(sp)
    80002046:	6442                	ld	s0,16(sp)
    80002048:	64a2                	ld	s1,8(sp)
    8000204a:	6105                	addi	sp,sp,32
    8000204c:	8082                	ret

000000008000204e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000204e:	7179                	addi	sp,sp,-48
    80002050:	f406                	sd	ra,40(sp)
    80002052:	f022                	sd	s0,32(sp)
    80002054:	ec26                	sd	s1,24(sp)
    80002056:	e84a                	sd	s2,16(sp)
    80002058:	1800                	addi	s0,sp,48
    8000205a:	84ae                	mv	s1,a1
    8000205c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000205e:	fd840593          	addi	a1,s0,-40
    80002062:	00000097          	auipc	ra,0x0
    80002066:	fcc080e7          	jalr	-52(ra) # 8000202e <argaddr>
  return fetchstr(addr, buf, max);
    8000206a:	864a                	mv	a2,s2
    8000206c:	85a6                	mv	a1,s1
    8000206e:	fd843503          	ld	a0,-40(s0)
    80002072:	00000097          	auipc	ra,0x0
    80002076:	f50080e7          	jalr	-176(ra) # 80001fc2 <fetchstr>
}
    8000207a:	70a2                	ld	ra,40(sp)
    8000207c:	7402                	ld	s0,32(sp)
    8000207e:	64e2                	ld	s1,24(sp)
    80002080:	6942                	ld	s2,16(sp)
    80002082:	6145                	addi	sp,sp,48
    80002084:	8082                	ret

0000000080002086 <syscall>:



void
syscall(void)
{
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	e04a                	sd	s2,0(sp)
    80002090:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	e56080e7          	jalr	-426(ra) # 80000ee8 <myproc>
    8000209a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000209c:	05853903          	ld	s2,88(a0)
    800020a0:	0a893783          	ld	a5,168(s2)
    800020a4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020a8:	37fd                	addiw	a5,a5,-1
    800020aa:	4771                	li	a4,28
    800020ac:	00f76f63          	bltu	a4,a5,800020ca <syscall+0x44>
    800020b0:	00369713          	slli	a4,a3,0x3
    800020b4:	00007797          	auipc	a5,0x7
    800020b8:	32c78793          	addi	a5,a5,812 # 800093e0 <syscalls>
    800020bc:	97ba                	add	a5,a5,a4
    800020be:	639c                	ld	a5,0(a5)
    800020c0:	c789                	beqz	a5,800020ca <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020c2:	9782                	jalr	a5
    800020c4:	06a93823          	sd	a0,112(s2)
    800020c8:	a839                	j	800020e6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ca:	15848613          	addi	a2,s1,344
    800020ce:	588c                	lw	a1,48(s1)
    800020d0:	00007517          	auipc	a0,0x7
    800020d4:	2d850513          	addi	a0,a0,728 # 800093a8 <states.1770+0x150>
    800020d8:	00005097          	auipc	ra,0x5
    800020dc:	c04080e7          	jalr	-1020(ra) # 80006cdc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020e0:	6cbc                	ld	a5,88(s1)
    800020e2:	577d                	li	a4,-1
    800020e4:	fbb8                	sd	a4,112(a5)
  }
}
    800020e6:	60e2                	ld	ra,24(sp)
    800020e8:	6442                	ld	s0,16(sp)
    800020ea:	64a2                	ld	s1,8(sp)
    800020ec:	6902                	ld	s2,0(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020fa:	fec40593          	addi	a1,s0,-20
    800020fe:	4501                	li	a0,0
    80002100:	00000097          	auipc	ra,0x0
    80002104:	f0e080e7          	jalr	-242(ra) # 8000200e <argint>
  exit(n);
    80002108:	fec42503          	lw	a0,-20(s0)
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	5b8080e7          	jalr	1464(ra) # 800016c4 <exit>
  return 0;  // not reached
}
    80002114:	4501                	li	a0,0
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000211e:	1141                	addi	sp,sp,-16
    80002120:	e406                	sd	ra,8(sp)
    80002122:	e022                	sd	s0,0(sp)
    80002124:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	dc2080e7          	jalr	-574(ra) # 80000ee8 <myproc>
}
    8000212e:	5908                	lw	a0,48(a0)
    80002130:	60a2                	ld	ra,8(sp)
    80002132:	6402                	ld	s0,0(sp)
    80002134:	0141                	addi	sp,sp,16
    80002136:	8082                	ret

0000000080002138 <sys_fork>:

uint64
sys_fork(void)
{
    80002138:	1141                	addi	sp,sp,-16
    8000213a:	e406                	sd	ra,8(sp)
    8000213c:	e022                	sd	s0,0(sp)
    8000213e:	0800                	addi	s0,sp,16
  return fork();
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	162080e7          	jalr	354(ra) # 800012a2 <fork>
}
    80002148:	60a2                	ld	ra,8(sp)
    8000214a:	6402                	ld	s0,0(sp)
    8000214c:	0141                	addi	sp,sp,16
    8000214e:	8082                	ret

0000000080002150 <sys_wait>:

uint64
sys_wait(void)
{
    80002150:	1101                	addi	sp,sp,-32
    80002152:	ec06                	sd	ra,24(sp)
    80002154:	e822                	sd	s0,16(sp)
    80002156:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002158:	fe840593          	addi	a1,s0,-24
    8000215c:	4501                	li	a0,0
    8000215e:	00000097          	auipc	ra,0x0
    80002162:	ed0080e7          	jalr	-304(ra) # 8000202e <argaddr>
  return wait(p);
    80002166:	fe843503          	ld	a0,-24(s0)
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	700080e7          	jalr	1792(ra) # 8000186a <wait>
}
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	6105                	addi	sp,sp,32
    80002178:	8082                	ret

000000008000217a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000217a:	7179                	addi	sp,sp,-48
    8000217c:	f406                	sd	ra,40(sp)
    8000217e:	f022                	sd	s0,32(sp)
    80002180:	ec26                	sd	s1,24(sp)
    80002182:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002184:	fdc40593          	addi	a1,s0,-36
    80002188:	4501                	li	a0,0
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	e84080e7          	jalr	-380(ra) # 8000200e <argint>
  addr = myproc()->sz;
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	d56080e7          	jalr	-682(ra) # 80000ee8 <myproc>
    8000219a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000219c:	fdc42503          	lw	a0,-36(s0)
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	0a6080e7          	jalr	166(ra) # 80001246 <growproc>
    800021a8:	00054863          	bltz	a0,800021b8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021ac:	8526                	mv	a0,s1
    800021ae:	70a2                	ld	ra,40(sp)
    800021b0:	7402                	ld	s0,32(sp)
    800021b2:	64e2                	ld	s1,24(sp)
    800021b4:	6145                	addi	sp,sp,48
    800021b6:	8082                	ret
    return -1;
    800021b8:	54fd                	li	s1,-1
    800021ba:	bfcd                	j	800021ac <sys_sbrk+0x32>

00000000800021bc <sys_sleep>:

uint64
sys_sleep(void)
{
    800021bc:	7139                	addi	sp,sp,-64
    800021be:	fc06                	sd	ra,56(sp)
    800021c0:	f822                	sd	s0,48(sp)
    800021c2:	f426                	sd	s1,40(sp)
    800021c4:	f04a                	sd	s2,32(sp)
    800021c6:	ec4e                	sd	s3,24(sp)
    800021c8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021ca:	fcc40593          	addi	a1,s0,-52
    800021ce:	4501                	li	a0,0
    800021d0:	00000097          	auipc	ra,0x0
    800021d4:	e3e080e7          	jalr	-450(ra) # 8000200e <argint>
  if(n < 0)
    800021d8:	fcc42783          	lw	a5,-52(s0)
    800021dc:	0607cf63          	bltz	a5,8000225a <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021e0:	0000d517          	auipc	a0,0xd
    800021e4:	60050513          	addi	a0,a0,1536 # 8000f7e0 <tickslock>
    800021e8:	00005097          	auipc	ra,0x5
    800021ec:	ff4080e7          	jalr	-12(ra) # 800071dc <acquire>
  ticks0 = ticks;
    800021f0:	00007917          	auipc	s2,0x7
    800021f4:	76892903          	lw	s2,1896(s2) # 80009958 <ticks>
  while(ticks - ticks0 < n){
    800021f8:	fcc42783          	lw	a5,-52(s0)
    800021fc:	cf9d                	beqz	a5,8000223a <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021fe:	0000d997          	auipc	s3,0xd
    80002202:	5e298993          	addi	s3,s3,1506 # 8000f7e0 <tickslock>
    80002206:	00007497          	auipc	s1,0x7
    8000220a:	75248493          	addi	s1,s1,1874 # 80009958 <ticks>
    if(killed(myproc())){
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	cda080e7          	jalr	-806(ra) # 80000ee8 <myproc>
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	622080e7          	jalr	1570(ra) # 80001838 <killed>
    8000221e:	e129                	bnez	a0,80002260 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002220:	85ce                	mv	a1,s3
    80002222:	8526                	mv	a0,s1
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	36c080e7          	jalr	876(ra) # 80001590 <sleep>
  while(ticks - ticks0 < n){
    8000222c:	409c                	lw	a5,0(s1)
    8000222e:	412787bb          	subw	a5,a5,s2
    80002232:	fcc42703          	lw	a4,-52(s0)
    80002236:	fce7ece3          	bltu	a5,a4,8000220e <sys_sleep+0x52>
  }
  release(&tickslock);
    8000223a:	0000d517          	auipc	a0,0xd
    8000223e:	5a650513          	addi	a0,a0,1446 # 8000f7e0 <tickslock>
    80002242:	00005097          	auipc	ra,0x5
    80002246:	04e080e7          	jalr	78(ra) # 80007290 <release>
  return 0;
    8000224a:	4501                	li	a0,0
}
    8000224c:	70e2                	ld	ra,56(sp)
    8000224e:	7442                	ld	s0,48(sp)
    80002250:	74a2                	ld	s1,40(sp)
    80002252:	7902                	ld	s2,32(sp)
    80002254:	69e2                	ld	s3,24(sp)
    80002256:	6121                	addi	sp,sp,64
    80002258:	8082                	ret
    n = 0;
    8000225a:	fc042623          	sw	zero,-52(s0)
    8000225e:	b749                	j	800021e0 <sys_sleep+0x24>
      release(&tickslock);
    80002260:	0000d517          	auipc	a0,0xd
    80002264:	58050513          	addi	a0,a0,1408 # 8000f7e0 <tickslock>
    80002268:	00005097          	auipc	ra,0x5
    8000226c:	028080e7          	jalr	40(ra) # 80007290 <release>
      return -1;
    80002270:	557d                	li	a0,-1
    80002272:	bfe9                	j	8000224c <sys_sleep+0x90>

0000000080002274 <sys_kill>:

uint64
sys_kill(void)
{
    80002274:	1101                	addi	sp,sp,-32
    80002276:	ec06                	sd	ra,24(sp)
    80002278:	e822                	sd	s0,16(sp)
    8000227a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000227c:	fec40593          	addi	a1,s0,-20
    80002280:	4501                	li	a0,0
    80002282:	00000097          	auipc	ra,0x0
    80002286:	d8c080e7          	jalr	-628(ra) # 8000200e <argint>
  return kill(pid);
    8000228a:	fec42503          	lw	a0,-20(s0)
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	50c080e7          	jalr	1292(ra) # 8000179a <kill>
}
    80002296:	60e2                	ld	ra,24(sp)
    80002298:	6442                	ld	s0,16(sp)
    8000229a:	6105                	addi	sp,sp,32
    8000229c:	8082                	ret

000000008000229e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000229e:	1101                	addi	sp,sp,-32
    800022a0:	ec06                	sd	ra,24(sp)
    800022a2:	e822                	sd	s0,16(sp)
    800022a4:	e426                	sd	s1,8(sp)
    800022a6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022a8:	0000d517          	auipc	a0,0xd
    800022ac:	53850513          	addi	a0,a0,1336 # 8000f7e0 <tickslock>
    800022b0:	00005097          	auipc	ra,0x5
    800022b4:	f2c080e7          	jalr	-212(ra) # 800071dc <acquire>
  xticks = ticks;
    800022b8:	00007497          	auipc	s1,0x7
    800022bc:	6a04a483          	lw	s1,1696(s1) # 80009958 <ticks>
  release(&tickslock);
    800022c0:	0000d517          	auipc	a0,0xd
    800022c4:	52050513          	addi	a0,a0,1312 # 8000f7e0 <tickslock>
    800022c8:	00005097          	auipc	ra,0x5
    800022cc:	fc8080e7          	jalr	-56(ra) # 80007290 <release>
  return xticks;
}
    800022d0:	02049513          	slli	a0,s1,0x20
    800022d4:	9101                	srli	a0,a0,0x20
    800022d6:	60e2                	ld	ra,24(sp)
    800022d8:	6442                	ld	s0,16(sp)
    800022da:	64a2                	ld	s1,8(sp)
    800022dc:	6105                	addi	sp,sp,32
    800022de:	8082                	ret

00000000800022e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022e0:	7179                	addi	sp,sp,-48
    800022e2:	f406                	sd	ra,40(sp)
    800022e4:	f022                	sd	s0,32(sp)
    800022e6:	ec26                	sd	s1,24(sp)
    800022e8:	e84a                	sd	s2,16(sp)
    800022ea:	e44e                	sd	s3,8(sp)
    800022ec:	e052                	sd	s4,0(sp)
    800022ee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022f0:	00007597          	auipc	a1,0x7
    800022f4:	1e058593          	addi	a1,a1,480 # 800094d0 <syscalls+0xf0>
    800022f8:	0000d517          	auipc	a0,0xd
    800022fc:	50050513          	addi	a0,a0,1280 # 8000f7f8 <bcache>
    80002300:	00005097          	auipc	ra,0x5
    80002304:	e4c080e7          	jalr	-436(ra) # 8000714c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002308:	00015797          	auipc	a5,0x15
    8000230c:	4f078793          	addi	a5,a5,1264 # 800177f8 <bcache+0x8000>
    80002310:	00015717          	auipc	a4,0x15
    80002314:	75070713          	addi	a4,a4,1872 # 80017a60 <bcache+0x8268>
    80002318:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000231c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002320:	0000d497          	auipc	s1,0xd
    80002324:	4f048493          	addi	s1,s1,1264 # 8000f810 <bcache+0x18>
    b->next = bcache.head.next;
    80002328:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000232a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000232c:	00007a17          	auipc	s4,0x7
    80002330:	1aca0a13          	addi	s4,s4,428 # 800094d8 <syscalls+0xf8>
    b->next = bcache.head.next;
    80002334:	2b893783          	ld	a5,696(s2)
    80002338:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000233a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000233e:	85d2                	mv	a1,s4
    80002340:	01048513          	addi	a0,s1,16
    80002344:	00001097          	auipc	ra,0x1
    80002348:	4c4080e7          	jalr	1220(ra) # 80003808 <initsleeplock>
    bcache.head.next->prev = b;
    8000234c:	2b893783          	ld	a5,696(s2)
    80002350:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002352:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002356:	45848493          	addi	s1,s1,1112
    8000235a:	fd349de3          	bne	s1,s3,80002334 <binit+0x54>
  }
}
    8000235e:	70a2                	ld	ra,40(sp)
    80002360:	7402                	ld	s0,32(sp)
    80002362:	64e2                	ld	s1,24(sp)
    80002364:	6942                	ld	s2,16(sp)
    80002366:	69a2                	ld	s3,8(sp)
    80002368:	6a02                	ld	s4,0(sp)
    8000236a:	6145                	addi	sp,sp,48
    8000236c:	8082                	ret

000000008000236e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000236e:	7179                	addi	sp,sp,-48
    80002370:	f406                	sd	ra,40(sp)
    80002372:	f022                	sd	s0,32(sp)
    80002374:	ec26                	sd	s1,24(sp)
    80002376:	e84a                	sd	s2,16(sp)
    80002378:	e44e                	sd	s3,8(sp)
    8000237a:	1800                	addi	s0,sp,48
    8000237c:	89aa                	mv	s3,a0
    8000237e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002380:	0000d517          	auipc	a0,0xd
    80002384:	47850513          	addi	a0,a0,1144 # 8000f7f8 <bcache>
    80002388:	00005097          	auipc	ra,0x5
    8000238c:	e54080e7          	jalr	-428(ra) # 800071dc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002390:	00015497          	auipc	s1,0x15
    80002394:	7204b483          	ld	s1,1824(s1) # 80017ab0 <bcache+0x82b8>
    80002398:	00015797          	auipc	a5,0x15
    8000239c:	6c878793          	addi	a5,a5,1736 # 80017a60 <bcache+0x8268>
    800023a0:	02f48f63          	beq	s1,a5,800023de <bread+0x70>
    800023a4:	873e                	mv	a4,a5
    800023a6:	a021                	j	800023ae <bread+0x40>
    800023a8:	68a4                	ld	s1,80(s1)
    800023aa:	02e48a63          	beq	s1,a4,800023de <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023ae:	449c                	lw	a5,8(s1)
    800023b0:	ff379ce3          	bne	a5,s3,800023a8 <bread+0x3a>
    800023b4:	44dc                	lw	a5,12(s1)
    800023b6:	ff2799e3          	bne	a5,s2,800023a8 <bread+0x3a>
      b->refcnt++;
    800023ba:	40bc                	lw	a5,64(s1)
    800023bc:	2785                	addiw	a5,a5,1
    800023be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023c0:	0000d517          	auipc	a0,0xd
    800023c4:	43850513          	addi	a0,a0,1080 # 8000f7f8 <bcache>
    800023c8:	00005097          	auipc	ra,0x5
    800023cc:	ec8080e7          	jalr	-312(ra) # 80007290 <release>
      acquiresleep(&b->lock);
    800023d0:	01048513          	addi	a0,s1,16
    800023d4:	00001097          	auipc	ra,0x1
    800023d8:	46e080e7          	jalr	1134(ra) # 80003842 <acquiresleep>
      return b;
    800023dc:	a8b9                	j	8000243a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023de:	00015497          	auipc	s1,0x15
    800023e2:	6ca4b483          	ld	s1,1738(s1) # 80017aa8 <bcache+0x82b0>
    800023e6:	00015797          	auipc	a5,0x15
    800023ea:	67a78793          	addi	a5,a5,1658 # 80017a60 <bcache+0x8268>
    800023ee:	00f48863          	beq	s1,a5,800023fe <bread+0x90>
    800023f2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023f4:	40bc                	lw	a5,64(s1)
    800023f6:	cf81                	beqz	a5,8000240e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023f8:	64a4                	ld	s1,72(s1)
    800023fa:	fee49de3          	bne	s1,a4,800023f4 <bread+0x86>
  panic("bget: no buffers");
    800023fe:	00007517          	auipc	a0,0x7
    80002402:	0e250513          	addi	a0,a0,226 # 800094e0 <syscalls+0x100>
    80002406:	00005097          	auipc	ra,0x5
    8000240a:	88c080e7          	jalr	-1908(ra) # 80006c92 <panic>
      b->dev = dev;
    8000240e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002412:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002416:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000241a:	4785                	li	a5,1
    8000241c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000241e:	0000d517          	auipc	a0,0xd
    80002422:	3da50513          	addi	a0,a0,986 # 8000f7f8 <bcache>
    80002426:	00005097          	auipc	ra,0x5
    8000242a:	e6a080e7          	jalr	-406(ra) # 80007290 <release>
      acquiresleep(&b->lock);
    8000242e:	01048513          	addi	a0,s1,16
    80002432:	00001097          	auipc	ra,0x1
    80002436:	410080e7          	jalr	1040(ra) # 80003842 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000243a:	409c                	lw	a5,0(s1)
    8000243c:	cb89                	beqz	a5,8000244e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000243e:	8526                	mv	a0,s1
    80002440:	70a2                	ld	ra,40(sp)
    80002442:	7402                	ld	s0,32(sp)
    80002444:	64e2                	ld	s1,24(sp)
    80002446:	6942                	ld	s2,16(sp)
    80002448:	69a2                	ld	s3,8(sp)
    8000244a:	6145                	addi	sp,sp,48
    8000244c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000244e:	4581                	li	a1,0
    80002450:	8526                	mv	a0,s1
    80002452:	00003097          	auipc	ra,0x3
    80002456:	090080e7          	jalr	144(ra) # 800054e2 <virtio_disk_rw>
    b->valid = 1;
    8000245a:	4785                	li	a5,1
    8000245c:	c09c                	sw	a5,0(s1)
  return b;
    8000245e:	b7c5                	j	8000243e <bread+0xd0>

0000000080002460 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002460:	1101                	addi	sp,sp,-32
    80002462:	ec06                	sd	ra,24(sp)
    80002464:	e822                	sd	s0,16(sp)
    80002466:	e426                	sd	s1,8(sp)
    80002468:	1000                	addi	s0,sp,32
    8000246a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000246c:	0541                	addi	a0,a0,16
    8000246e:	00001097          	auipc	ra,0x1
    80002472:	46e080e7          	jalr	1134(ra) # 800038dc <holdingsleep>
    80002476:	cd01                	beqz	a0,8000248e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002478:	4585                	li	a1,1
    8000247a:	8526                	mv	a0,s1
    8000247c:	00003097          	auipc	ra,0x3
    80002480:	066080e7          	jalr	102(ra) # 800054e2 <virtio_disk_rw>
}
    80002484:	60e2                	ld	ra,24(sp)
    80002486:	6442                	ld	s0,16(sp)
    80002488:	64a2                	ld	s1,8(sp)
    8000248a:	6105                	addi	sp,sp,32
    8000248c:	8082                	ret
    panic("bwrite");
    8000248e:	00007517          	auipc	a0,0x7
    80002492:	06a50513          	addi	a0,a0,106 # 800094f8 <syscalls+0x118>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	7fc080e7          	jalr	2044(ra) # 80006c92 <panic>

000000008000249e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000249e:	1101                	addi	sp,sp,-32
    800024a0:	ec06                	sd	ra,24(sp)
    800024a2:	e822                	sd	s0,16(sp)
    800024a4:	e426                	sd	s1,8(sp)
    800024a6:	e04a                	sd	s2,0(sp)
    800024a8:	1000                	addi	s0,sp,32
    800024aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ac:	01050913          	addi	s2,a0,16
    800024b0:	854a                	mv	a0,s2
    800024b2:	00001097          	auipc	ra,0x1
    800024b6:	42a080e7          	jalr	1066(ra) # 800038dc <holdingsleep>
    800024ba:	c92d                	beqz	a0,8000252c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024bc:	854a                	mv	a0,s2
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	3da080e7          	jalr	986(ra) # 80003898 <releasesleep>

  acquire(&bcache.lock);
    800024c6:	0000d517          	auipc	a0,0xd
    800024ca:	33250513          	addi	a0,a0,818 # 8000f7f8 <bcache>
    800024ce:	00005097          	auipc	ra,0x5
    800024d2:	d0e080e7          	jalr	-754(ra) # 800071dc <acquire>
  b->refcnt--;
    800024d6:	40bc                	lw	a5,64(s1)
    800024d8:	37fd                	addiw	a5,a5,-1
    800024da:	0007871b          	sext.w	a4,a5
    800024de:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024e0:	eb05                	bnez	a4,80002510 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024e2:	68bc                	ld	a5,80(s1)
    800024e4:	64b8                	ld	a4,72(s1)
    800024e6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024e8:	64bc                	ld	a5,72(s1)
    800024ea:	68b8                	ld	a4,80(s1)
    800024ec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024ee:	00015797          	auipc	a5,0x15
    800024f2:	30a78793          	addi	a5,a5,778 # 800177f8 <bcache+0x8000>
    800024f6:	2b87b703          	ld	a4,696(a5)
    800024fa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024fc:	00015717          	auipc	a4,0x15
    80002500:	56470713          	addi	a4,a4,1380 # 80017a60 <bcache+0x8268>
    80002504:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002506:	2b87b703          	ld	a4,696(a5)
    8000250a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000250c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002510:	0000d517          	auipc	a0,0xd
    80002514:	2e850513          	addi	a0,a0,744 # 8000f7f8 <bcache>
    80002518:	00005097          	auipc	ra,0x5
    8000251c:	d78080e7          	jalr	-648(ra) # 80007290 <release>
}
    80002520:	60e2                	ld	ra,24(sp)
    80002522:	6442                	ld	s0,16(sp)
    80002524:	64a2                	ld	s1,8(sp)
    80002526:	6902                	ld	s2,0(sp)
    80002528:	6105                	addi	sp,sp,32
    8000252a:	8082                	ret
    panic("brelse");
    8000252c:	00007517          	auipc	a0,0x7
    80002530:	fd450513          	addi	a0,a0,-44 # 80009500 <syscalls+0x120>
    80002534:	00004097          	auipc	ra,0x4
    80002538:	75e080e7          	jalr	1886(ra) # 80006c92 <panic>

000000008000253c <bpin>:

void
bpin(struct buf *b) {
    8000253c:	1101                	addi	sp,sp,-32
    8000253e:	ec06                	sd	ra,24(sp)
    80002540:	e822                	sd	s0,16(sp)
    80002542:	e426                	sd	s1,8(sp)
    80002544:	1000                	addi	s0,sp,32
    80002546:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002548:	0000d517          	auipc	a0,0xd
    8000254c:	2b050513          	addi	a0,a0,688 # 8000f7f8 <bcache>
    80002550:	00005097          	auipc	ra,0x5
    80002554:	c8c080e7          	jalr	-884(ra) # 800071dc <acquire>
  b->refcnt++;
    80002558:	40bc                	lw	a5,64(s1)
    8000255a:	2785                	addiw	a5,a5,1
    8000255c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000255e:	0000d517          	auipc	a0,0xd
    80002562:	29a50513          	addi	a0,a0,666 # 8000f7f8 <bcache>
    80002566:	00005097          	auipc	ra,0x5
    8000256a:	d2a080e7          	jalr	-726(ra) # 80007290 <release>
}
    8000256e:	60e2                	ld	ra,24(sp)
    80002570:	6442                	ld	s0,16(sp)
    80002572:	64a2                	ld	s1,8(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret

0000000080002578 <bunpin>:

void
bunpin(struct buf *b) {
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	1000                	addi	s0,sp,32
    80002582:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002584:	0000d517          	auipc	a0,0xd
    80002588:	27450513          	addi	a0,a0,628 # 8000f7f8 <bcache>
    8000258c:	00005097          	auipc	ra,0x5
    80002590:	c50080e7          	jalr	-944(ra) # 800071dc <acquire>
  b->refcnt--;
    80002594:	40bc                	lw	a5,64(s1)
    80002596:	37fd                	addiw	a5,a5,-1
    80002598:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000259a:	0000d517          	auipc	a0,0xd
    8000259e:	25e50513          	addi	a0,a0,606 # 8000f7f8 <bcache>
    800025a2:	00005097          	auipc	ra,0x5
    800025a6:	cee080e7          	jalr	-786(ra) # 80007290 <release>
}
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret

00000000800025b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025b4:	1101                	addi	sp,sp,-32
    800025b6:	ec06                	sd	ra,24(sp)
    800025b8:	e822                	sd	s0,16(sp)
    800025ba:	e426                	sd	s1,8(sp)
    800025bc:	e04a                	sd	s2,0(sp)
    800025be:	1000                	addi	s0,sp,32
    800025c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025c2:	00d5d59b          	srliw	a1,a1,0xd
    800025c6:	00016797          	auipc	a5,0x16
    800025ca:	90e7a783          	lw	a5,-1778(a5) # 80017ed4 <sb+0x1c>
    800025ce:	9dbd                	addw	a1,a1,a5
    800025d0:	00000097          	auipc	ra,0x0
    800025d4:	d9e080e7          	jalr	-610(ra) # 8000236e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025d8:	0074f713          	andi	a4,s1,7
    800025dc:	4785                	li	a5,1
    800025de:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025e2:	14ce                	slli	s1,s1,0x33
    800025e4:	90d9                	srli	s1,s1,0x36
    800025e6:	00950733          	add	a4,a0,s1
    800025ea:	05874703          	lbu	a4,88(a4)
    800025ee:	00e7f6b3          	and	a3,a5,a4
    800025f2:	c69d                	beqz	a3,80002620 <bfree+0x6c>
    800025f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025f6:	94aa                	add	s1,s1,a0
    800025f8:	fff7c793          	not	a5,a5
    800025fc:	8ff9                	and	a5,a5,a4
    800025fe:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002602:	00001097          	auipc	ra,0x1
    80002606:	120080e7          	jalr	288(ra) # 80003722 <log_write>
  brelse(bp);
    8000260a:	854a                	mv	a0,s2
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	e92080e7          	jalr	-366(ra) # 8000249e <brelse>
}
    80002614:	60e2                	ld	ra,24(sp)
    80002616:	6442                	ld	s0,16(sp)
    80002618:	64a2                	ld	s1,8(sp)
    8000261a:	6902                	ld	s2,0(sp)
    8000261c:	6105                	addi	sp,sp,32
    8000261e:	8082                	ret
    panic("freeing free block");
    80002620:	00007517          	auipc	a0,0x7
    80002624:	ee850513          	addi	a0,a0,-280 # 80009508 <syscalls+0x128>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	66a080e7          	jalr	1642(ra) # 80006c92 <panic>

0000000080002630 <balloc>:
{
    80002630:	711d                	addi	sp,sp,-96
    80002632:	ec86                	sd	ra,88(sp)
    80002634:	e8a2                	sd	s0,80(sp)
    80002636:	e4a6                	sd	s1,72(sp)
    80002638:	e0ca                	sd	s2,64(sp)
    8000263a:	fc4e                	sd	s3,56(sp)
    8000263c:	f852                	sd	s4,48(sp)
    8000263e:	f456                	sd	s5,40(sp)
    80002640:	f05a                	sd	s6,32(sp)
    80002642:	ec5e                	sd	s7,24(sp)
    80002644:	e862                	sd	s8,16(sp)
    80002646:	e466                	sd	s9,8(sp)
    80002648:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000264a:	00016797          	auipc	a5,0x16
    8000264e:	8727a783          	lw	a5,-1934(a5) # 80017ebc <sb+0x4>
    80002652:	10078163          	beqz	a5,80002754 <balloc+0x124>
    80002656:	8baa                	mv	s7,a0
    80002658:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000265a:	00016b17          	auipc	s6,0x16
    8000265e:	85eb0b13          	addi	s6,s6,-1954 # 80017eb8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002662:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002664:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002666:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002668:	6c89                	lui	s9,0x2
    8000266a:	a061                	j	800026f2 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000266c:	974a                	add	a4,a4,s2
    8000266e:	8fd5                	or	a5,a5,a3
    80002670:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002674:	854a                	mv	a0,s2
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	0ac080e7          	jalr	172(ra) # 80003722 <log_write>
        brelse(bp);
    8000267e:	854a                	mv	a0,s2
    80002680:	00000097          	auipc	ra,0x0
    80002684:	e1e080e7          	jalr	-482(ra) # 8000249e <brelse>
  bp = bread(dev, bno);
    80002688:	85a6                	mv	a1,s1
    8000268a:	855e                	mv	a0,s7
    8000268c:	00000097          	auipc	ra,0x0
    80002690:	ce2080e7          	jalr	-798(ra) # 8000236e <bread>
    80002694:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002696:	40000613          	li	a2,1024
    8000269a:	4581                	li	a1,0
    8000269c:	05850513          	addi	a0,a0,88
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	ad8080e7          	jalr	-1320(ra) # 80000178 <memset>
  log_write(bp);
    800026a8:	854a                	mv	a0,s2
    800026aa:	00001097          	auipc	ra,0x1
    800026ae:	078080e7          	jalr	120(ra) # 80003722 <log_write>
  brelse(bp);
    800026b2:	854a                	mv	a0,s2
    800026b4:	00000097          	auipc	ra,0x0
    800026b8:	dea080e7          	jalr	-534(ra) # 8000249e <brelse>
}
    800026bc:	8526                	mv	a0,s1
    800026be:	60e6                	ld	ra,88(sp)
    800026c0:	6446                	ld	s0,80(sp)
    800026c2:	64a6                	ld	s1,72(sp)
    800026c4:	6906                	ld	s2,64(sp)
    800026c6:	79e2                	ld	s3,56(sp)
    800026c8:	7a42                	ld	s4,48(sp)
    800026ca:	7aa2                	ld	s5,40(sp)
    800026cc:	7b02                	ld	s6,32(sp)
    800026ce:	6be2                	ld	s7,24(sp)
    800026d0:	6c42                	ld	s8,16(sp)
    800026d2:	6ca2                	ld	s9,8(sp)
    800026d4:	6125                	addi	sp,sp,96
    800026d6:	8082                	ret
    brelse(bp);
    800026d8:	854a                	mv	a0,s2
    800026da:	00000097          	auipc	ra,0x0
    800026de:	dc4080e7          	jalr	-572(ra) # 8000249e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e2:	015c87bb          	addw	a5,s9,s5
    800026e6:	00078a9b          	sext.w	s5,a5
    800026ea:	004b2703          	lw	a4,4(s6)
    800026ee:	06eaf363          	bgeu	s5,a4,80002754 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800026f2:	41fad79b          	sraiw	a5,s5,0x1f
    800026f6:	0137d79b          	srliw	a5,a5,0x13
    800026fa:	015787bb          	addw	a5,a5,s5
    800026fe:	40d7d79b          	sraiw	a5,a5,0xd
    80002702:	01cb2583          	lw	a1,28(s6)
    80002706:	9dbd                	addw	a1,a1,a5
    80002708:	855e                	mv	a0,s7
    8000270a:	00000097          	auipc	ra,0x0
    8000270e:	c64080e7          	jalr	-924(ra) # 8000236e <bread>
    80002712:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002714:	004b2503          	lw	a0,4(s6)
    80002718:	000a849b          	sext.w	s1,s5
    8000271c:	8662                	mv	a2,s8
    8000271e:	faa4fde3          	bgeu	s1,a0,800026d8 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002722:	41f6579b          	sraiw	a5,a2,0x1f
    80002726:	01d7d69b          	srliw	a3,a5,0x1d
    8000272a:	00c6873b          	addw	a4,a3,a2
    8000272e:	00777793          	andi	a5,a4,7
    80002732:	9f95                	subw	a5,a5,a3
    80002734:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002738:	4037571b          	sraiw	a4,a4,0x3
    8000273c:	00e906b3          	add	a3,s2,a4
    80002740:	0586c683          	lbu	a3,88(a3)
    80002744:	00d7f5b3          	and	a1,a5,a3
    80002748:	d195                	beqz	a1,8000266c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000274a:	2605                	addiw	a2,a2,1
    8000274c:	2485                	addiw	s1,s1,1
    8000274e:	fd4618e3          	bne	a2,s4,8000271e <balloc+0xee>
    80002752:	b759                	j	800026d8 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002754:	00007517          	auipc	a0,0x7
    80002758:	dcc50513          	addi	a0,a0,-564 # 80009520 <syscalls+0x140>
    8000275c:	00004097          	auipc	ra,0x4
    80002760:	580080e7          	jalr	1408(ra) # 80006cdc <printf>
  return 0;
    80002764:	4481                	li	s1,0
    80002766:	bf99                	j	800026bc <balloc+0x8c>

0000000080002768 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002768:	7179                	addi	sp,sp,-48
    8000276a:	f406                	sd	ra,40(sp)
    8000276c:	f022                	sd	s0,32(sp)
    8000276e:	ec26                	sd	s1,24(sp)
    80002770:	e84a                	sd	s2,16(sp)
    80002772:	e44e                	sd	s3,8(sp)
    80002774:	e052                	sd	s4,0(sp)
    80002776:	1800                	addi	s0,sp,48
    80002778:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000277a:	47ad                	li	a5,11
    8000277c:	02b7e763          	bltu	a5,a1,800027aa <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002780:	02059493          	slli	s1,a1,0x20
    80002784:	9081                	srli	s1,s1,0x20
    80002786:	048a                	slli	s1,s1,0x2
    80002788:	94aa                	add	s1,s1,a0
    8000278a:	0504a903          	lw	s2,80(s1)
    8000278e:	06091e63          	bnez	s2,8000280a <bmap+0xa2>
      addr = balloc(ip->dev);
    80002792:	4108                	lw	a0,0(a0)
    80002794:	00000097          	auipc	ra,0x0
    80002798:	e9c080e7          	jalr	-356(ra) # 80002630 <balloc>
    8000279c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027a0:	06090563          	beqz	s2,8000280a <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800027a4:	0524a823          	sw	s2,80(s1)
    800027a8:	a08d                	j	8000280a <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027aa:	ff45849b          	addiw	s1,a1,-12
    800027ae:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027b2:	0ff00793          	li	a5,255
    800027b6:	08e7e563          	bltu	a5,a4,80002840 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027ba:	08052903          	lw	s2,128(a0)
    800027be:	00091d63          	bnez	s2,800027d8 <bmap+0x70>
      addr = balloc(ip->dev);
    800027c2:	4108                	lw	a0,0(a0)
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	e6c080e7          	jalr	-404(ra) # 80002630 <balloc>
    800027cc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027d0:	02090d63          	beqz	s2,8000280a <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800027d4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027d8:	85ca                	mv	a1,s2
    800027da:	0009a503          	lw	a0,0(s3)
    800027de:	00000097          	auipc	ra,0x0
    800027e2:	b90080e7          	jalr	-1136(ra) # 8000236e <bread>
    800027e6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027e8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ec:	02049593          	slli	a1,s1,0x20
    800027f0:	9181                	srli	a1,a1,0x20
    800027f2:	058a                	slli	a1,a1,0x2
    800027f4:	00b784b3          	add	s1,a5,a1
    800027f8:	0004a903          	lw	s2,0(s1)
    800027fc:	02090063          	beqz	s2,8000281c <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002800:	8552                	mv	a0,s4
    80002802:	00000097          	auipc	ra,0x0
    80002806:	c9c080e7          	jalr	-868(ra) # 8000249e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000280a:	854a                	mv	a0,s2
    8000280c:	70a2                	ld	ra,40(sp)
    8000280e:	7402                	ld	s0,32(sp)
    80002810:	64e2                	ld	s1,24(sp)
    80002812:	6942                	ld	s2,16(sp)
    80002814:	69a2                	ld	s3,8(sp)
    80002816:	6a02                	ld	s4,0(sp)
    80002818:	6145                	addi	sp,sp,48
    8000281a:	8082                	ret
      addr = balloc(ip->dev);
    8000281c:	0009a503          	lw	a0,0(s3)
    80002820:	00000097          	auipc	ra,0x0
    80002824:	e10080e7          	jalr	-496(ra) # 80002630 <balloc>
    80002828:	0005091b          	sext.w	s2,a0
      if(addr){
    8000282c:	fc090ae3          	beqz	s2,80002800 <bmap+0x98>
        a[bn] = addr;
    80002830:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002834:	8552                	mv	a0,s4
    80002836:	00001097          	auipc	ra,0x1
    8000283a:	eec080e7          	jalr	-276(ra) # 80003722 <log_write>
    8000283e:	b7c9                	j	80002800 <bmap+0x98>
  panic("bmap: out of range");
    80002840:	00007517          	auipc	a0,0x7
    80002844:	cf850513          	addi	a0,a0,-776 # 80009538 <syscalls+0x158>
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	44a080e7          	jalr	1098(ra) # 80006c92 <panic>

0000000080002850 <iget>:
{
    80002850:	7179                	addi	sp,sp,-48
    80002852:	f406                	sd	ra,40(sp)
    80002854:	f022                	sd	s0,32(sp)
    80002856:	ec26                	sd	s1,24(sp)
    80002858:	e84a                	sd	s2,16(sp)
    8000285a:	e44e                	sd	s3,8(sp)
    8000285c:	e052                	sd	s4,0(sp)
    8000285e:	1800                	addi	s0,sp,48
    80002860:	89aa                	mv	s3,a0
    80002862:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002864:	00015517          	auipc	a0,0x15
    80002868:	67450513          	addi	a0,a0,1652 # 80017ed8 <itable>
    8000286c:	00005097          	auipc	ra,0x5
    80002870:	970080e7          	jalr	-1680(ra) # 800071dc <acquire>
  empty = 0;
    80002874:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002876:	00015497          	auipc	s1,0x15
    8000287a:	67a48493          	addi	s1,s1,1658 # 80017ef0 <itable+0x18>
    8000287e:	00017697          	auipc	a3,0x17
    80002882:	10268693          	addi	a3,a3,258 # 80019980 <log>
    80002886:	a039                	j	80002894 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002888:	02090b63          	beqz	s2,800028be <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000288c:	08848493          	addi	s1,s1,136
    80002890:	02d48a63          	beq	s1,a3,800028c4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002894:	449c                	lw	a5,8(s1)
    80002896:	fef059e3          	blez	a5,80002888 <iget+0x38>
    8000289a:	4098                	lw	a4,0(s1)
    8000289c:	ff3716e3          	bne	a4,s3,80002888 <iget+0x38>
    800028a0:	40d8                	lw	a4,4(s1)
    800028a2:	ff4713e3          	bne	a4,s4,80002888 <iget+0x38>
      ip->ref++;
    800028a6:	2785                	addiw	a5,a5,1
    800028a8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028aa:	00015517          	auipc	a0,0x15
    800028ae:	62e50513          	addi	a0,a0,1582 # 80017ed8 <itable>
    800028b2:	00005097          	auipc	ra,0x5
    800028b6:	9de080e7          	jalr	-1570(ra) # 80007290 <release>
      return ip;
    800028ba:	8926                	mv	s2,s1
    800028bc:	a03d                	j	800028ea <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028be:	f7f9                	bnez	a5,8000288c <iget+0x3c>
    800028c0:	8926                	mv	s2,s1
    800028c2:	b7e9                	j	8000288c <iget+0x3c>
  if(empty == 0)
    800028c4:	02090c63          	beqz	s2,800028fc <iget+0xac>
  ip->dev = dev;
    800028c8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028cc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028d0:	4785                	li	a5,1
    800028d2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028d6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028da:	00015517          	auipc	a0,0x15
    800028de:	5fe50513          	addi	a0,a0,1534 # 80017ed8 <itable>
    800028e2:	00005097          	auipc	ra,0x5
    800028e6:	9ae080e7          	jalr	-1618(ra) # 80007290 <release>
}
    800028ea:	854a                	mv	a0,s2
    800028ec:	70a2                	ld	ra,40(sp)
    800028ee:	7402                	ld	s0,32(sp)
    800028f0:	64e2                	ld	s1,24(sp)
    800028f2:	6942                	ld	s2,16(sp)
    800028f4:	69a2                	ld	s3,8(sp)
    800028f6:	6a02                	ld	s4,0(sp)
    800028f8:	6145                	addi	sp,sp,48
    800028fa:	8082                	ret
    panic("iget: no inodes");
    800028fc:	00007517          	auipc	a0,0x7
    80002900:	c5450513          	addi	a0,a0,-940 # 80009550 <syscalls+0x170>
    80002904:	00004097          	auipc	ra,0x4
    80002908:	38e080e7          	jalr	910(ra) # 80006c92 <panic>

000000008000290c <fsinit>:
fsinit(int dev) {
    8000290c:	7179                	addi	sp,sp,-48
    8000290e:	f406                	sd	ra,40(sp)
    80002910:	f022                	sd	s0,32(sp)
    80002912:	ec26                	sd	s1,24(sp)
    80002914:	e84a                	sd	s2,16(sp)
    80002916:	e44e                	sd	s3,8(sp)
    80002918:	1800                	addi	s0,sp,48
    8000291a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000291c:	4585                	li	a1,1
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	a50080e7          	jalr	-1456(ra) # 8000236e <bread>
    80002926:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002928:	00015997          	auipc	s3,0x15
    8000292c:	59098993          	addi	s3,s3,1424 # 80017eb8 <sb>
    80002930:	02000613          	li	a2,32
    80002934:	05850593          	addi	a1,a0,88
    80002938:	854e                	mv	a0,s3
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	89e080e7          	jalr	-1890(ra) # 800001d8 <memmove>
  brelse(bp);
    80002942:	8526                	mv	a0,s1
    80002944:	00000097          	auipc	ra,0x0
    80002948:	b5a080e7          	jalr	-1190(ra) # 8000249e <brelse>
  if(sb.magic != FSMAGIC)
    8000294c:	0009a703          	lw	a4,0(s3)
    80002950:	102037b7          	lui	a5,0x10203
    80002954:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002958:	02f71263          	bne	a4,a5,8000297c <fsinit+0x70>
  initlog(dev, &sb);
    8000295c:	00015597          	auipc	a1,0x15
    80002960:	55c58593          	addi	a1,a1,1372 # 80017eb8 <sb>
    80002964:	854a                	mv	a0,s2
    80002966:	00001097          	auipc	ra,0x1
    8000296a:	b40080e7          	jalr	-1216(ra) # 800034a6 <initlog>
}
    8000296e:	70a2                	ld	ra,40(sp)
    80002970:	7402                	ld	s0,32(sp)
    80002972:	64e2                	ld	s1,24(sp)
    80002974:	6942                	ld	s2,16(sp)
    80002976:	69a2                	ld	s3,8(sp)
    80002978:	6145                	addi	sp,sp,48
    8000297a:	8082                	ret
    panic("invalid file system");
    8000297c:	00007517          	auipc	a0,0x7
    80002980:	be450513          	addi	a0,a0,-1052 # 80009560 <syscalls+0x180>
    80002984:	00004097          	auipc	ra,0x4
    80002988:	30e080e7          	jalr	782(ra) # 80006c92 <panic>

000000008000298c <iinit>:
{
    8000298c:	7179                	addi	sp,sp,-48
    8000298e:	f406                	sd	ra,40(sp)
    80002990:	f022                	sd	s0,32(sp)
    80002992:	ec26                	sd	s1,24(sp)
    80002994:	e84a                	sd	s2,16(sp)
    80002996:	e44e                	sd	s3,8(sp)
    80002998:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000299a:	00007597          	auipc	a1,0x7
    8000299e:	bde58593          	addi	a1,a1,-1058 # 80009578 <syscalls+0x198>
    800029a2:	00015517          	auipc	a0,0x15
    800029a6:	53650513          	addi	a0,a0,1334 # 80017ed8 <itable>
    800029aa:	00004097          	auipc	ra,0x4
    800029ae:	7a2080e7          	jalr	1954(ra) # 8000714c <initlock>
  for(i = 0; i < NINODE; i++) {
    800029b2:	00015497          	auipc	s1,0x15
    800029b6:	54e48493          	addi	s1,s1,1358 # 80017f00 <itable+0x28>
    800029ba:	00017997          	auipc	s3,0x17
    800029be:	fd698993          	addi	s3,s3,-42 # 80019990 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029c2:	00007917          	auipc	s2,0x7
    800029c6:	bbe90913          	addi	s2,s2,-1090 # 80009580 <syscalls+0x1a0>
    800029ca:	85ca                	mv	a1,s2
    800029cc:	8526                	mv	a0,s1
    800029ce:	00001097          	auipc	ra,0x1
    800029d2:	e3a080e7          	jalr	-454(ra) # 80003808 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029d6:	08848493          	addi	s1,s1,136
    800029da:	ff3498e3          	bne	s1,s3,800029ca <iinit+0x3e>
}
    800029de:	70a2                	ld	ra,40(sp)
    800029e0:	7402                	ld	s0,32(sp)
    800029e2:	64e2                	ld	s1,24(sp)
    800029e4:	6942                	ld	s2,16(sp)
    800029e6:	69a2                	ld	s3,8(sp)
    800029e8:	6145                	addi	sp,sp,48
    800029ea:	8082                	ret

00000000800029ec <ialloc>:
{
    800029ec:	715d                	addi	sp,sp,-80
    800029ee:	e486                	sd	ra,72(sp)
    800029f0:	e0a2                	sd	s0,64(sp)
    800029f2:	fc26                	sd	s1,56(sp)
    800029f4:	f84a                	sd	s2,48(sp)
    800029f6:	f44e                	sd	s3,40(sp)
    800029f8:	f052                	sd	s4,32(sp)
    800029fa:	ec56                	sd	s5,24(sp)
    800029fc:	e85a                	sd	s6,16(sp)
    800029fe:	e45e                	sd	s7,8(sp)
    80002a00:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a02:	00015717          	auipc	a4,0x15
    80002a06:	4c272703          	lw	a4,1218(a4) # 80017ec4 <sb+0xc>
    80002a0a:	4785                	li	a5,1
    80002a0c:	04e7fa63          	bgeu	a5,a4,80002a60 <ialloc+0x74>
    80002a10:	8aaa                	mv	s5,a0
    80002a12:	8bae                	mv	s7,a1
    80002a14:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a16:	00015a17          	auipc	s4,0x15
    80002a1a:	4a2a0a13          	addi	s4,s4,1186 # 80017eb8 <sb>
    80002a1e:	00048b1b          	sext.w	s6,s1
    80002a22:	0044d593          	srli	a1,s1,0x4
    80002a26:	018a2783          	lw	a5,24(s4)
    80002a2a:	9dbd                	addw	a1,a1,a5
    80002a2c:	8556                	mv	a0,s5
    80002a2e:	00000097          	auipc	ra,0x0
    80002a32:	940080e7          	jalr	-1728(ra) # 8000236e <bread>
    80002a36:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a38:	05850993          	addi	s3,a0,88
    80002a3c:	00f4f793          	andi	a5,s1,15
    80002a40:	079a                	slli	a5,a5,0x6
    80002a42:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a44:	00099783          	lh	a5,0(s3)
    80002a48:	c3a1                	beqz	a5,80002a88 <ialloc+0x9c>
    brelse(bp);
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	a54080e7          	jalr	-1452(ra) # 8000249e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a52:	0485                	addi	s1,s1,1
    80002a54:	00ca2703          	lw	a4,12(s4)
    80002a58:	0004879b          	sext.w	a5,s1
    80002a5c:	fce7e1e3          	bltu	a5,a4,80002a1e <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a60:	00007517          	auipc	a0,0x7
    80002a64:	b2850513          	addi	a0,a0,-1240 # 80009588 <syscalls+0x1a8>
    80002a68:	00004097          	auipc	ra,0x4
    80002a6c:	274080e7          	jalr	628(ra) # 80006cdc <printf>
  return 0;
    80002a70:	4501                	li	a0,0
}
    80002a72:	60a6                	ld	ra,72(sp)
    80002a74:	6406                	ld	s0,64(sp)
    80002a76:	74e2                	ld	s1,56(sp)
    80002a78:	7942                	ld	s2,48(sp)
    80002a7a:	79a2                	ld	s3,40(sp)
    80002a7c:	7a02                	ld	s4,32(sp)
    80002a7e:	6ae2                	ld	s5,24(sp)
    80002a80:	6b42                	ld	s6,16(sp)
    80002a82:	6ba2                	ld	s7,8(sp)
    80002a84:	6161                	addi	sp,sp,80
    80002a86:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a88:	04000613          	li	a2,64
    80002a8c:	4581                	li	a1,0
    80002a8e:	854e                	mv	a0,s3
    80002a90:	ffffd097          	auipc	ra,0xffffd
    80002a94:	6e8080e7          	jalr	1768(ra) # 80000178 <memset>
      dip->type = type;
    80002a98:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a9c:	854a                	mv	a0,s2
    80002a9e:	00001097          	auipc	ra,0x1
    80002aa2:	c84080e7          	jalr	-892(ra) # 80003722 <log_write>
      brelse(bp);
    80002aa6:	854a                	mv	a0,s2
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	9f6080e7          	jalr	-1546(ra) # 8000249e <brelse>
      return iget(dev, inum);
    80002ab0:	85da                	mv	a1,s6
    80002ab2:	8556                	mv	a0,s5
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	d9c080e7          	jalr	-612(ra) # 80002850 <iget>
    80002abc:	bf5d                	j	80002a72 <ialloc+0x86>

0000000080002abe <iupdate>:
{
    80002abe:	1101                	addi	sp,sp,-32
    80002ac0:	ec06                	sd	ra,24(sp)
    80002ac2:	e822                	sd	s0,16(sp)
    80002ac4:	e426                	sd	s1,8(sp)
    80002ac6:	e04a                	sd	s2,0(sp)
    80002ac8:	1000                	addi	s0,sp,32
    80002aca:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002acc:	415c                	lw	a5,4(a0)
    80002ace:	0047d79b          	srliw	a5,a5,0x4
    80002ad2:	00015597          	auipc	a1,0x15
    80002ad6:	3fe5a583          	lw	a1,1022(a1) # 80017ed0 <sb+0x18>
    80002ada:	9dbd                	addw	a1,a1,a5
    80002adc:	4108                	lw	a0,0(a0)
    80002ade:	00000097          	auipc	ra,0x0
    80002ae2:	890080e7          	jalr	-1904(ra) # 8000236e <bread>
    80002ae6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ae8:	05850793          	addi	a5,a0,88
    80002aec:	40c8                	lw	a0,4(s1)
    80002aee:	893d                	andi	a0,a0,15
    80002af0:	051a                	slli	a0,a0,0x6
    80002af2:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002af4:	04449703          	lh	a4,68(s1)
    80002af8:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002afc:	04649703          	lh	a4,70(s1)
    80002b00:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b04:	04849703          	lh	a4,72(s1)
    80002b08:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b0c:	04a49703          	lh	a4,74(s1)
    80002b10:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b14:	44f8                	lw	a4,76(s1)
    80002b16:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b18:	03400613          	li	a2,52
    80002b1c:	05048593          	addi	a1,s1,80
    80002b20:	0531                	addi	a0,a0,12
    80002b22:	ffffd097          	auipc	ra,0xffffd
    80002b26:	6b6080e7          	jalr	1718(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b2a:	854a                	mv	a0,s2
    80002b2c:	00001097          	auipc	ra,0x1
    80002b30:	bf6080e7          	jalr	-1034(ra) # 80003722 <log_write>
  brelse(bp);
    80002b34:	854a                	mv	a0,s2
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	968080e7          	jalr	-1688(ra) # 8000249e <brelse>
}
    80002b3e:	60e2                	ld	ra,24(sp)
    80002b40:	6442                	ld	s0,16(sp)
    80002b42:	64a2                	ld	s1,8(sp)
    80002b44:	6902                	ld	s2,0(sp)
    80002b46:	6105                	addi	sp,sp,32
    80002b48:	8082                	ret

0000000080002b4a <idup>:
{
    80002b4a:	1101                	addi	sp,sp,-32
    80002b4c:	ec06                	sd	ra,24(sp)
    80002b4e:	e822                	sd	s0,16(sp)
    80002b50:	e426                	sd	s1,8(sp)
    80002b52:	1000                	addi	s0,sp,32
    80002b54:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b56:	00015517          	auipc	a0,0x15
    80002b5a:	38250513          	addi	a0,a0,898 # 80017ed8 <itable>
    80002b5e:	00004097          	auipc	ra,0x4
    80002b62:	67e080e7          	jalr	1662(ra) # 800071dc <acquire>
  ip->ref++;
    80002b66:	449c                	lw	a5,8(s1)
    80002b68:	2785                	addiw	a5,a5,1
    80002b6a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b6c:	00015517          	auipc	a0,0x15
    80002b70:	36c50513          	addi	a0,a0,876 # 80017ed8 <itable>
    80002b74:	00004097          	auipc	ra,0x4
    80002b78:	71c080e7          	jalr	1820(ra) # 80007290 <release>
}
    80002b7c:	8526                	mv	a0,s1
    80002b7e:	60e2                	ld	ra,24(sp)
    80002b80:	6442                	ld	s0,16(sp)
    80002b82:	64a2                	ld	s1,8(sp)
    80002b84:	6105                	addi	sp,sp,32
    80002b86:	8082                	ret

0000000080002b88 <ilock>:
{
    80002b88:	1101                	addi	sp,sp,-32
    80002b8a:	ec06                	sd	ra,24(sp)
    80002b8c:	e822                	sd	s0,16(sp)
    80002b8e:	e426                	sd	s1,8(sp)
    80002b90:	e04a                	sd	s2,0(sp)
    80002b92:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b94:	c115                	beqz	a0,80002bb8 <ilock+0x30>
    80002b96:	84aa                	mv	s1,a0
    80002b98:	451c                	lw	a5,8(a0)
    80002b9a:	00f05f63          	blez	a5,80002bb8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b9e:	0541                	addi	a0,a0,16
    80002ba0:	00001097          	auipc	ra,0x1
    80002ba4:	ca2080e7          	jalr	-862(ra) # 80003842 <acquiresleep>
  if(ip->valid == 0){
    80002ba8:	40bc                	lw	a5,64(s1)
    80002baa:	cf99                	beqz	a5,80002bc8 <ilock+0x40>
}
    80002bac:	60e2                	ld	ra,24(sp)
    80002bae:	6442                	ld	s0,16(sp)
    80002bb0:	64a2                	ld	s1,8(sp)
    80002bb2:	6902                	ld	s2,0(sp)
    80002bb4:	6105                	addi	sp,sp,32
    80002bb6:	8082                	ret
    panic("ilock");
    80002bb8:	00007517          	auipc	a0,0x7
    80002bbc:	9e850513          	addi	a0,a0,-1560 # 800095a0 <syscalls+0x1c0>
    80002bc0:	00004097          	auipc	ra,0x4
    80002bc4:	0d2080e7          	jalr	210(ra) # 80006c92 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc8:	40dc                	lw	a5,4(s1)
    80002bca:	0047d79b          	srliw	a5,a5,0x4
    80002bce:	00015597          	auipc	a1,0x15
    80002bd2:	3025a583          	lw	a1,770(a1) # 80017ed0 <sb+0x18>
    80002bd6:	9dbd                	addw	a1,a1,a5
    80002bd8:	4088                	lw	a0,0(s1)
    80002bda:	fffff097          	auipc	ra,0xfffff
    80002bde:	794080e7          	jalr	1940(ra) # 8000236e <bread>
    80002be2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be4:	05850593          	addi	a1,a0,88
    80002be8:	40dc                	lw	a5,4(s1)
    80002bea:	8bbd                	andi	a5,a5,15
    80002bec:	079a                	slli	a5,a5,0x6
    80002bee:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bf0:	00059783          	lh	a5,0(a1)
    80002bf4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bf8:	00259783          	lh	a5,2(a1)
    80002bfc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c00:	00459783          	lh	a5,4(a1)
    80002c04:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c08:	00659783          	lh	a5,6(a1)
    80002c0c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c10:	459c                	lw	a5,8(a1)
    80002c12:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c14:	03400613          	li	a2,52
    80002c18:	05b1                	addi	a1,a1,12
    80002c1a:	05048513          	addi	a0,s1,80
    80002c1e:	ffffd097          	auipc	ra,0xffffd
    80002c22:	5ba080e7          	jalr	1466(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c26:	854a                	mv	a0,s2
    80002c28:	00000097          	auipc	ra,0x0
    80002c2c:	876080e7          	jalr	-1930(ra) # 8000249e <brelse>
    ip->valid = 1;
    80002c30:	4785                	li	a5,1
    80002c32:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c34:	04449783          	lh	a5,68(s1)
    80002c38:	fbb5                	bnez	a5,80002bac <ilock+0x24>
      panic("ilock: no type");
    80002c3a:	00007517          	auipc	a0,0x7
    80002c3e:	96e50513          	addi	a0,a0,-1682 # 800095a8 <syscalls+0x1c8>
    80002c42:	00004097          	auipc	ra,0x4
    80002c46:	050080e7          	jalr	80(ra) # 80006c92 <panic>

0000000080002c4a <iunlock>:
{
    80002c4a:	1101                	addi	sp,sp,-32
    80002c4c:	ec06                	sd	ra,24(sp)
    80002c4e:	e822                	sd	s0,16(sp)
    80002c50:	e426                	sd	s1,8(sp)
    80002c52:	e04a                	sd	s2,0(sp)
    80002c54:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c56:	c905                	beqz	a0,80002c86 <iunlock+0x3c>
    80002c58:	84aa                	mv	s1,a0
    80002c5a:	01050913          	addi	s2,a0,16
    80002c5e:	854a                	mv	a0,s2
    80002c60:	00001097          	auipc	ra,0x1
    80002c64:	c7c080e7          	jalr	-900(ra) # 800038dc <holdingsleep>
    80002c68:	cd19                	beqz	a0,80002c86 <iunlock+0x3c>
    80002c6a:	449c                	lw	a5,8(s1)
    80002c6c:	00f05d63          	blez	a5,80002c86 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c70:	854a                	mv	a0,s2
    80002c72:	00001097          	auipc	ra,0x1
    80002c76:	c26080e7          	jalr	-986(ra) # 80003898 <releasesleep>
}
    80002c7a:	60e2                	ld	ra,24(sp)
    80002c7c:	6442                	ld	s0,16(sp)
    80002c7e:	64a2                	ld	s1,8(sp)
    80002c80:	6902                	ld	s2,0(sp)
    80002c82:	6105                	addi	sp,sp,32
    80002c84:	8082                	ret
    panic("iunlock");
    80002c86:	00007517          	auipc	a0,0x7
    80002c8a:	93250513          	addi	a0,a0,-1742 # 800095b8 <syscalls+0x1d8>
    80002c8e:	00004097          	auipc	ra,0x4
    80002c92:	004080e7          	jalr	4(ra) # 80006c92 <panic>

0000000080002c96 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c96:	7179                	addi	sp,sp,-48
    80002c98:	f406                	sd	ra,40(sp)
    80002c9a:	f022                	sd	s0,32(sp)
    80002c9c:	ec26                	sd	s1,24(sp)
    80002c9e:	e84a                	sd	s2,16(sp)
    80002ca0:	e44e                	sd	s3,8(sp)
    80002ca2:	e052                	sd	s4,0(sp)
    80002ca4:	1800                	addi	s0,sp,48
    80002ca6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ca8:	05050493          	addi	s1,a0,80
    80002cac:	08050913          	addi	s2,a0,128
    80002cb0:	a021                	j	80002cb8 <itrunc+0x22>
    80002cb2:	0491                	addi	s1,s1,4
    80002cb4:	01248d63          	beq	s1,s2,80002cce <itrunc+0x38>
    if(ip->addrs[i]){
    80002cb8:	408c                	lw	a1,0(s1)
    80002cba:	dde5                	beqz	a1,80002cb2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cbc:	0009a503          	lw	a0,0(s3)
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	8f4080e7          	jalr	-1804(ra) # 800025b4 <bfree>
      ip->addrs[i] = 0;
    80002cc8:	0004a023          	sw	zero,0(s1)
    80002ccc:	b7dd                	j	80002cb2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cce:	0809a583          	lw	a1,128(s3)
    80002cd2:	e185                	bnez	a1,80002cf2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cd4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cd8:	854e                	mv	a0,s3
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	de4080e7          	jalr	-540(ra) # 80002abe <iupdate>
}
    80002ce2:	70a2                	ld	ra,40(sp)
    80002ce4:	7402                	ld	s0,32(sp)
    80002ce6:	64e2                	ld	s1,24(sp)
    80002ce8:	6942                	ld	s2,16(sp)
    80002cea:	69a2                	ld	s3,8(sp)
    80002cec:	6a02                	ld	s4,0(sp)
    80002cee:	6145                	addi	sp,sp,48
    80002cf0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cf2:	0009a503          	lw	a0,0(s3)
    80002cf6:	fffff097          	auipc	ra,0xfffff
    80002cfa:	678080e7          	jalr	1656(ra) # 8000236e <bread>
    80002cfe:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d00:	05850493          	addi	s1,a0,88
    80002d04:	45850913          	addi	s2,a0,1112
    80002d08:	a811                	j	80002d1c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d0a:	0009a503          	lw	a0,0(s3)
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	8a6080e7          	jalr	-1882(ra) # 800025b4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d16:	0491                	addi	s1,s1,4
    80002d18:	01248563          	beq	s1,s2,80002d22 <itrunc+0x8c>
      if(a[j])
    80002d1c:	408c                	lw	a1,0(s1)
    80002d1e:	dde5                	beqz	a1,80002d16 <itrunc+0x80>
    80002d20:	b7ed                	j	80002d0a <itrunc+0x74>
    brelse(bp);
    80002d22:	8552                	mv	a0,s4
    80002d24:	fffff097          	auipc	ra,0xfffff
    80002d28:	77a080e7          	jalr	1914(ra) # 8000249e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d2c:	0809a583          	lw	a1,128(s3)
    80002d30:	0009a503          	lw	a0,0(s3)
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	880080e7          	jalr	-1920(ra) # 800025b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d3c:	0809a023          	sw	zero,128(s3)
    80002d40:	bf51                	j	80002cd4 <itrunc+0x3e>

0000000080002d42 <iput>:
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	e426                	sd	s1,8(sp)
    80002d4a:	e04a                	sd	s2,0(sp)
    80002d4c:	1000                	addi	s0,sp,32
    80002d4e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d50:	00015517          	auipc	a0,0x15
    80002d54:	18850513          	addi	a0,a0,392 # 80017ed8 <itable>
    80002d58:	00004097          	auipc	ra,0x4
    80002d5c:	484080e7          	jalr	1156(ra) # 800071dc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d60:	4498                	lw	a4,8(s1)
    80002d62:	4785                	li	a5,1
    80002d64:	02f70363          	beq	a4,a5,80002d8a <iput+0x48>
  ip->ref--;
    80002d68:	449c                	lw	a5,8(s1)
    80002d6a:	37fd                	addiw	a5,a5,-1
    80002d6c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d6e:	00015517          	auipc	a0,0x15
    80002d72:	16a50513          	addi	a0,a0,362 # 80017ed8 <itable>
    80002d76:	00004097          	auipc	ra,0x4
    80002d7a:	51a080e7          	jalr	1306(ra) # 80007290 <release>
}
    80002d7e:	60e2                	ld	ra,24(sp)
    80002d80:	6442                	ld	s0,16(sp)
    80002d82:	64a2                	ld	s1,8(sp)
    80002d84:	6902                	ld	s2,0(sp)
    80002d86:	6105                	addi	sp,sp,32
    80002d88:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d8a:	40bc                	lw	a5,64(s1)
    80002d8c:	dff1                	beqz	a5,80002d68 <iput+0x26>
    80002d8e:	04a49783          	lh	a5,74(s1)
    80002d92:	fbf9                	bnez	a5,80002d68 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d94:	01048913          	addi	s2,s1,16
    80002d98:	854a                	mv	a0,s2
    80002d9a:	00001097          	auipc	ra,0x1
    80002d9e:	aa8080e7          	jalr	-1368(ra) # 80003842 <acquiresleep>
    release(&itable.lock);
    80002da2:	00015517          	auipc	a0,0x15
    80002da6:	13650513          	addi	a0,a0,310 # 80017ed8 <itable>
    80002daa:	00004097          	auipc	ra,0x4
    80002dae:	4e6080e7          	jalr	1254(ra) # 80007290 <release>
    itrunc(ip);
    80002db2:	8526                	mv	a0,s1
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	ee2080e7          	jalr	-286(ra) # 80002c96 <itrunc>
    ip->type = 0;
    80002dbc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dc0:	8526                	mv	a0,s1
    80002dc2:	00000097          	auipc	ra,0x0
    80002dc6:	cfc080e7          	jalr	-772(ra) # 80002abe <iupdate>
    ip->valid = 0;
    80002dca:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00001097          	auipc	ra,0x1
    80002dd4:	ac8080e7          	jalr	-1336(ra) # 80003898 <releasesleep>
    acquire(&itable.lock);
    80002dd8:	00015517          	auipc	a0,0x15
    80002ddc:	10050513          	addi	a0,a0,256 # 80017ed8 <itable>
    80002de0:	00004097          	auipc	ra,0x4
    80002de4:	3fc080e7          	jalr	1020(ra) # 800071dc <acquire>
    80002de8:	b741                	j	80002d68 <iput+0x26>

0000000080002dea <iunlockput>:
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	1000                	addi	s0,sp,32
    80002df4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	e54080e7          	jalr	-428(ra) # 80002c4a <iunlock>
  iput(ip);
    80002dfe:	8526                	mv	a0,s1
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	f42080e7          	jalr	-190(ra) # 80002d42 <iput>
}
    80002e08:	60e2                	ld	ra,24(sp)
    80002e0a:	6442                	ld	s0,16(sp)
    80002e0c:	64a2                	ld	s1,8(sp)
    80002e0e:	6105                	addi	sp,sp,32
    80002e10:	8082                	ret

0000000080002e12 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e12:	1141                	addi	sp,sp,-16
    80002e14:	e422                	sd	s0,8(sp)
    80002e16:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e18:	411c                	lw	a5,0(a0)
    80002e1a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e1c:	415c                	lw	a5,4(a0)
    80002e1e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e20:	04451783          	lh	a5,68(a0)
    80002e24:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e28:	04a51783          	lh	a5,74(a0)
    80002e2c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e30:	04c56783          	lwu	a5,76(a0)
    80002e34:	e99c                	sd	a5,16(a1)
}
    80002e36:	6422                	ld	s0,8(sp)
    80002e38:	0141                	addi	sp,sp,16
    80002e3a:	8082                	ret

0000000080002e3c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e3c:	457c                	lw	a5,76(a0)
    80002e3e:	0ed7e963          	bltu	a5,a3,80002f30 <readi+0xf4>
{
    80002e42:	7159                	addi	sp,sp,-112
    80002e44:	f486                	sd	ra,104(sp)
    80002e46:	f0a2                	sd	s0,96(sp)
    80002e48:	eca6                	sd	s1,88(sp)
    80002e4a:	e8ca                	sd	s2,80(sp)
    80002e4c:	e4ce                	sd	s3,72(sp)
    80002e4e:	e0d2                	sd	s4,64(sp)
    80002e50:	fc56                	sd	s5,56(sp)
    80002e52:	f85a                	sd	s6,48(sp)
    80002e54:	f45e                	sd	s7,40(sp)
    80002e56:	f062                	sd	s8,32(sp)
    80002e58:	ec66                	sd	s9,24(sp)
    80002e5a:	e86a                	sd	s10,16(sp)
    80002e5c:	e46e                	sd	s11,8(sp)
    80002e5e:	1880                	addi	s0,sp,112
    80002e60:	8b2a                	mv	s6,a0
    80002e62:	8bae                	mv	s7,a1
    80002e64:	8a32                	mv	s4,a2
    80002e66:	84b6                	mv	s1,a3
    80002e68:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e6a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e6c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e6e:	0ad76063          	bltu	a4,a3,80002f0e <readi+0xd2>
  if(off + n > ip->size)
    80002e72:	00e7f463          	bgeu	a5,a4,80002e7a <readi+0x3e>
    n = ip->size - off;
    80002e76:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e7a:	0a0a8963          	beqz	s5,80002f2c <readi+0xf0>
    80002e7e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e80:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e84:	5c7d                	li	s8,-1
    80002e86:	a82d                	j	80002ec0 <readi+0x84>
    80002e88:	020d1d93          	slli	s11,s10,0x20
    80002e8c:	020ddd93          	srli	s11,s11,0x20
    80002e90:	05890613          	addi	a2,s2,88
    80002e94:	86ee                	mv	a3,s11
    80002e96:	963a                	add	a2,a2,a4
    80002e98:	85d2                	mv	a1,s4
    80002e9a:	855e                	mv	a0,s7
    80002e9c:	fffff097          	auipc	ra,0xfffff
    80002ea0:	afc080e7          	jalr	-1284(ra) # 80001998 <either_copyout>
    80002ea4:	05850d63          	beq	a0,s8,80002efe <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ea8:	854a                	mv	a0,s2
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	5f4080e7          	jalr	1524(ra) # 8000249e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb2:	013d09bb          	addw	s3,s10,s3
    80002eb6:	009d04bb          	addw	s1,s10,s1
    80002eba:	9a6e                	add	s4,s4,s11
    80002ebc:	0559f763          	bgeu	s3,s5,80002f0a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ec0:	00a4d59b          	srliw	a1,s1,0xa
    80002ec4:	855a                	mv	a0,s6
    80002ec6:	00000097          	auipc	ra,0x0
    80002eca:	8a2080e7          	jalr	-1886(ra) # 80002768 <bmap>
    80002ece:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ed2:	cd85                	beqz	a1,80002f0a <readi+0xce>
    bp = bread(ip->dev, addr);
    80002ed4:	000b2503          	lw	a0,0(s6)
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	496080e7          	jalr	1174(ra) # 8000236e <bread>
    80002ee0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee2:	3ff4f713          	andi	a4,s1,1023
    80002ee6:	40ec87bb          	subw	a5,s9,a4
    80002eea:	413a86bb          	subw	a3,s5,s3
    80002eee:	8d3e                	mv	s10,a5
    80002ef0:	2781                	sext.w	a5,a5
    80002ef2:	0006861b          	sext.w	a2,a3
    80002ef6:	f8f679e3          	bgeu	a2,a5,80002e88 <readi+0x4c>
    80002efa:	8d36                	mv	s10,a3
    80002efc:	b771                	j	80002e88 <readi+0x4c>
      brelse(bp);
    80002efe:	854a                	mv	a0,s2
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	59e080e7          	jalr	1438(ra) # 8000249e <brelse>
      tot = -1;
    80002f08:	59fd                	li	s3,-1
  }
  return tot;
    80002f0a:	0009851b          	sext.w	a0,s3
}
    80002f0e:	70a6                	ld	ra,104(sp)
    80002f10:	7406                	ld	s0,96(sp)
    80002f12:	64e6                	ld	s1,88(sp)
    80002f14:	6946                	ld	s2,80(sp)
    80002f16:	69a6                	ld	s3,72(sp)
    80002f18:	6a06                	ld	s4,64(sp)
    80002f1a:	7ae2                	ld	s5,56(sp)
    80002f1c:	7b42                	ld	s6,48(sp)
    80002f1e:	7ba2                	ld	s7,40(sp)
    80002f20:	7c02                	ld	s8,32(sp)
    80002f22:	6ce2                	ld	s9,24(sp)
    80002f24:	6d42                	ld	s10,16(sp)
    80002f26:	6da2                	ld	s11,8(sp)
    80002f28:	6165                	addi	sp,sp,112
    80002f2a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f2c:	89d6                	mv	s3,s5
    80002f2e:	bff1                	j	80002f0a <readi+0xce>
    return 0;
    80002f30:	4501                	li	a0,0
}
    80002f32:	8082                	ret

0000000080002f34 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f34:	457c                	lw	a5,76(a0)
    80002f36:	10d7e863          	bltu	a5,a3,80003046 <writei+0x112>
{
    80002f3a:	7159                	addi	sp,sp,-112
    80002f3c:	f486                	sd	ra,104(sp)
    80002f3e:	f0a2                	sd	s0,96(sp)
    80002f40:	eca6                	sd	s1,88(sp)
    80002f42:	e8ca                	sd	s2,80(sp)
    80002f44:	e4ce                	sd	s3,72(sp)
    80002f46:	e0d2                	sd	s4,64(sp)
    80002f48:	fc56                	sd	s5,56(sp)
    80002f4a:	f85a                	sd	s6,48(sp)
    80002f4c:	f45e                	sd	s7,40(sp)
    80002f4e:	f062                	sd	s8,32(sp)
    80002f50:	ec66                	sd	s9,24(sp)
    80002f52:	e86a                	sd	s10,16(sp)
    80002f54:	e46e                	sd	s11,8(sp)
    80002f56:	1880                	addi	s0,sp,112
    80002f58:	8aaa                	mv	s5,a0
    80002f5a:	8bae                	mv	s7,a1
    80002f5c:	8a32                	mv	s4,a2
    80002f5e:	8936                	mv	s2,a3
    80002f60:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f62:	00e687bb          	addw	a5,a3,a4
    80002f66:	0ed7e263          	bltu	a5,a3,8000304a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f6a:	00043737          	lui	a4,0x43
    80002f6e:	0ef76063          	bltu	a4,a5,8000304e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f72:	0c0b0863          	beqz	s6,80003042 <writei+0x10e>
    80002f76:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f78:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f7c:	5c7d                	li	s8,-1
    80002f7e:	a091                	j	80002fc2 <writei+0x8e>
    80002f80:	020d1d93          	slli	s11,s10,0x20
    80002f84:	020ddd93          	srli	s11,s11,0x20
    80002f88:	05848513          	addi	a0,s1,88
    80002f8c:	86ee                	mv	a3,s11
    80002f8e:	8652                	mv	a2,s4
    80002f90:	85de                	mv	a1,s7
    80002f92:	953a                	add	a0,a0,a4
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	a5a080e7          	jalr	-1446(ra) # 800019ee <either_copyin>
    80002f9c:	07850263          	beq	a0,s8,80003000 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fa0:	8526                	mv	a0,s1
    80002fa2:	00000097          	auipc	ra,0x0
    80002fa6:	780080e7          	jalr	1920(ra) # 80003722 <log_write>
    brelse(bp);
    80002faa:	8526                	mv	a0,s1
    80002fac:	fffff097          	auipc	ra,0xfffff
    80002fb0:	4f2080e7          	jalr	1266(ra) # 8000249e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fb4:	013d09bb          	addw	s3,s10,s3
    80002fb8:	012d093b          	addw	s2,s10,s2
    80002fbc:	9a6e                	add	s4,s4,s11
    80002fbe:	0569f663          	bgeu	s3,s6,8000300a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002fc2:	00a9559b          	srliw	a1,s2,0xa
    80002fc6:	8556                	mv	a0,s5
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	7a0080e7          	jalr	1952(ra) # 80002768 <bmap>
    80002fd0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fd4:	c99d                	beqz	a1,8000300a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002fd6:	000aa503          	lw	a0,0(s5)
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	394080e7          	jalr	916(ra) # 8000236e <bread>
    80002fe2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe4:	3ff97713          	andi	a4,s2,1023
    80002fe8:	40ec87bb          	subw	a5,s9,a4
    80002fec:	413b06bb          	subw	a3,s6,s3
    80002ff0:	8d3e                	mv	s10,a5
    80002ff2:	2781                	sext.w	a5,a5
    80002ff4:	0006861b          	sext.w	a2,a3
    80002ff8:	f8f674e3          	bgeu	a2,a5,80002f80 <writei+0x4c>
    80002ffc:	8d36                	mv	s10,a3
    80002ffe:	b749                	j	80002f80 <writei+0x4c>
      brelse(bp);
    80003000:	8526                	mv	a0,s1
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	49c080e7          	jalr	1180(ra) # 8000249e <brelse>
  }

  if(off > ip->size)
    8000300a:	04caa783          	lw	a5,76(s5)
    8000300e:	0127f463          	bgeu	a5,s2,80003016 <writei+0xe2>
    ip->size = off;
    80003012:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003016:	8556                	mv	a0,s5
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	aa6080e7          	jalr	-1370(ra) # 80002abe <iupdate>

  return tot;
    80003020:	0009851b          	sext.w	a0,s3
}
    80003024:	70a6                	ld	ra,104(sp)
    80003026:	7406                	ld	s0,96(sp)
    80003028:	64e6                	ld	s1,88(sp)
    8000302a:	6946                	ld	s2,80(sp)
    8000302c:	69a6                	ld	s3,72(sp)
    8000302e:	6a06                	ld	s4,64(sp)
    80003030:	7ae2                	ld	s5,56(sp)
    80003032:	7b42                	ld	s6,48(sp)
    80003034:	7ba2                	ld	s7,40(sp)
    80003036:	7c02                	ld	s8,32(sp)
    80003038:	6ce2                	ld	s9,24(sp)
    8000303a:	6d42                	ld	s10,16(sp)
    8000303c:	6da2                	ld	s11,8(sp)
    8000303e:	6165                	addi	sp,sp,112
    80003040:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003042:	89da                	mv	s3,s6
    80003044:	bfc9                	j	80003016 <writei+0xe2>
    return -1;
    80003046:	557d                	li	a0,-1
}
    80003048:	8082                	ret
    return -1;
    8000304a:	557d                	li	a0,-1
    8000304c:	bfe1                	j	80003024 <writei+0xf0>
    return -1;
    8000304e:	557d                	li	a0,-1
    80003050:	bfd1                	j	80003024 <writei+0xf0>

0000000080003052 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003052:	1141                	addi	sp,sp,-16
    80003054:	e406                	sd	ra,8(sp)
    80003056:	e022                	sd	s0,0(sp)
    80003058:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000305a:	4639                	li	a2,14
    8000305c:	ffffd097          	auipc	ra,0xffffd
    80003060:	1f4080e7          	jalr	500(ra) # 80000250 <strncmp>
}
    80003064:	60a2                	ld	ra,8(sp)
    80003066:	6402                	ld	s0,0(sp)
    80003068:	0141                	addi	sp,sp,16
    8000306a:	8082                	ret

000000008000306c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000306c:	7139                	addi	sp,sp,-64
    8000306e:	fc06                	sd	ra,56(sp)
    80003070:	f822                	sd	s0,48(sp)
    80003072:	f426                	sd	s1,40(sp)
    80003074:	f04a                	sd	s2,32(sp)
    80003076:	ec4e                	sd	s3,24(sp)
    80003078:	e852                	sd	s4,16(sp)
    8000307a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000307c:	04451703          	lh	a4,68(a0)
    80003080:	4785                	li	a5,1
    80003082:	00f71a63          	bne	a4,a5,80003096 <dirlookup+0x2a>
    80003086:	892a                	mv	s2,a0
    80003088:	89ae                	mv	s3,a1
    8000308a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000308c:	457c                	lw	a5,76(a0)
    8000308e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003090:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003092:	e79d                	bnez	a5,800030c0 <dirlookup+0x54>
    80003094:	a8a5                	j	8000310c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003096:	00006517          	auipc	a0,0x6
    8000309a:	52a50513          	addi	a0,a0,1322 # 800095c0 <syscalls+0x1e0>
    8000309e:	00004097          	auipc	ra,0x4
    800030a2:	bf4080e7          	jalr	-1036(ra) # 80006c92 <panic>
      panic("dirlookup read");
    800030a6:	00006517          	auipc	a0,0x6
    800030aa:	53250513          	addi	a0,a0,1330 # 800095d8 <syscalls+0x1f8>
    800030ae:	00004097          	auipc	ra,0x4
    800030b2:	be4080e7          	jalr	-1052(ra) # 80006c92 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b6:	24c1                	addiw	s1,s1,16
    800030b8:	04c92783          	lw	a5,76(s2)
    800030bc:	04f4f763          	bgeu	s1,a5,8000310a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030c0:	4741                	li	a4,16
    800030c2:	86a6                	mv	a3,s1
    800030c4:	fc040613          	addi	a2,s0,-64
    800030c8:	4581                	li	a1,0
    800030ca:	854a                	mv	a0,s2
    800030cc:	00000097          	auipc	ra,0x0
    800030d0:	d70080e7          	jalr	-656(ra) # 80002e3c <readi>
    800030d4:	47c1                	li	a5,16
    800030d6:	fcf518e3          	bne	a0,a5,800030a6 <dirlookup+0x3a>
    if(de.inum == 0)
    800030da:	fc045783          	lhu	a5,-64(s0)
    800030de:	dfe1                	beqz	a5,800030b6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030e0:	fc240593          	addi	a1,s0,-62
    800030e4:	854e                	mv	a0,s3
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	f6c080e7          	jalr	-148(ra) # 80003052 <namecmp>
    800030ee:	f561                	bnez	a0,800030b6 <dirlookup+0x4a>
      if(poff)
    800030f0:	000a0463          	beqz	s4,800030f8 <dirlookup+0x8c>
        *poff = off;
    800030f4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030f8:	fc045583          	lhu	a1,-64(s0)
    800030fc:	00092503          	lw	a0,0(s2)
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	750080e7          	jalr	1872(ra) # 80002850 <iget>
    80003108:	a011                	j	8000310c <dirlookup+0xa0>
  return 0;
    8000310a:	4501                	li	a0,0
}
    8000310c:	70e2                	ld	ra,56(sp)
    8000310e:	7442                	ld	s0,48(sp)
    80003110:	74a2                	ld	s1,40(sp)
    80003112:	7902                	ld	s2,32(sp)
    80003114:	69e2                	ld	s3,24(sp)
    80003116:	6a42                	ld	s4,16(sp)
    80003118:	6121                	addi	sp,sp,64
    8000311a:	8082                	ret

000000008000311c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000311c:	711d                	addi	sp,sp,-96
    8000311e:	ec86                	sd	ra,88(sp)
    80003120:	e8a2                	sd	s0,80(sp)
    80003122:	e4a6                	sd	s1,72(sp)
    80003124:	e0ca                	sd	s2,64(sp)
    80003126:	fc4e                	sd	s3,56(sp)
    80003128:	f852                	sd	s4,48(sp)
    8000312a:	f456                	sd	s5,40(sp)
    8000312c:	f05a                	sd	s6,32(sp)
    8000312e:	ec5e                	sd	s7,24(sp)
    80003130:	e862                	sd	s8,16(sp)
    80003132:	e466                	sd	s9,8(sp)
    80003134:	1080                	addi	s0,sp,96
    80003136:	84aa                	mv	s1,a0
    80003138:	8b2e                	mv	s6,a1
    8000313a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000313c:	00054703          	lbu	a4,0(a0)
    80003140:	02f00793          	li	a5,47
    80003144:	02f70363          	beq	a4,a5,8000316a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003148:	ffffe097          	auipc	ra,0xffffe
    8000314c:	da0080e7          	jalr	-608(ra) # 80000ee8 <myproc>
    80003150:	15053503          	ld	a0,336(a0)
    80003154:	00000097          	auipc	ra,0x0
    80003158:	9f6080e7          	jalr	-1546(ra) # 80002b4a <idup>
    8000315c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000315e:	02f00913          	li	s2,47
  len = path - s;
    80003162:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003164:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003166:	4c05                	li	s8,1
    80003168:	a865                	j	80003220 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000316a:	4585                	li	a1,1
    8000316c:	4505                	li	a0,1
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	6e2080e7          	jalr	1762(ra) # 80002850 <iget>
    80003176:	89aa                	mv	s3,a0
    80003178:	b7dd                	j	8000315e <namex+0x42>
      iunlockput(ip);
    8000317a:	854e                	mv	a0,s3
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	c6e080e7          	jalr	-914(ra) # 80002dea <iunlockput>
      return 0;
    80003184:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003186:	854e                	mv	a0,s3
    80003188:	60e6                	ld	ra,88(sp)
    8000318a:	6446                	ld	s0,80(sp)
    8000318c:	64a6                	ld	s1,72(sp)
    8000318e:	6906                	ld	s2,64(sp)
    80003190:	79e2                	ld	s3,56(sp)
    80003192:	7a42                	ld	s4,48(sp)
    80003194:	7aa2                	ld	s5,40(sp)
    80003196:	7b02                	ld	s6,32(sp)
    80003198:	6be2                	ld	s7,24(sp)
    8000319a:	6c42                	ld	s8,16(sp)
    8000319c:	6ca2                	ld	s9,8(sp)
    8000319e:	6125                	addi	sp,sp,96
    800031a0:	8082                	ret
      iunlock(ip);
    800031a2:	854e                	mv	a0,s3
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	aa6080e7          	jalr	-1370(ra) # 80002c4a <iunlock>
      return ip;
    800031ac:	bfe9                	j	80003186 <namex+0x6a>
      iunlockput(ip);
    800031ae:	854e                	mv	a0,s3
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	c3a080e7          	jalr	-966(ra) # 80002dea <iunlockput>
      return 0;
    800031b8:	89d2                	mv	s3,s4
    800031ba:	b7f1                	j	80003186 <namex+0x6a>
  len = path - s;
    800031bc:	40b48633          	sub	a2,s1,a1
    800031c0:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031c4:	094cd463          	bge	s9,s4,8000324c <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031c8:	4639                	li	a2,14
    800031ca:	8556                	mv	a0,s5
    800031cc:	ffffd097          	auipc	ra,0xffffd
    800031d0:	00c080e7          	jalr	12(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031d4:	0004c783          	lbu	a5,0(s1)
    800031d8:	01279763          	bne	a5,s2,800031e6 <namex+0xca>
    path++;
    800031dc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031de:	0004c783          	lbu	a5,0(s1)
    800031e2:	ff278de3          	beq	a5,s2,800031dc <namex+0xc0>
    ilock(ip);
    800031e6:	854e                	mv	a0,s3
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	9a0080e7          	jalr	-1632(ra) # 80002b88 <ilock>
    if(ip->type != T_DIR){
    800031f0:	04499783          	lh	a5,68(s3)
    800031f4:	f98793e3          	bne	a5,s8,8000317a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800031f8:	000b0563          	beqz	s6,80003202 <namex+0xe6>
    800031fc:	0004c783          	lbu	a5,0(s1)
    80003200:	d3cd                	beqz	a5,800031a2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003202:	865e                	mv	a2,s7
    80003204:	85d6                	mv	a1,s5
    80003206:	854e                	mv	a0,s3
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	e64080e7          	jalr	-412(ra) # 8000306c <dirlookup>
    80003210:	8a2a                	mv	s4,a0
    80003212:	dd51                	beqz	a0,800031ae <namex+0x92>
    iunlockput(ip);
    80003214:	854e                	mv	a0,s3
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	bd4080e7          	jalr	-1068(ra) # 80002dea <iunlockput>
    ip = next;
    8000321e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003220:	0004c783          	lbu	a5,0(s1)
    80003224:	05279763          	bne	a5,s2,80003272 <namex+0x156>
    path++;
    80003228:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000322a:	0004c783          	lbu	a5,0(s1)
    8000322e:	ff278de3          	beq	a5,s2,80003228 <namex+0x10c>
  if(*path == 0)
    80003232:	c79d                	beqz	a5,80003260 <namex+0x144>
    path++;
    80003234:	85a6                	mv	a1,s1
  len = path - s;
    80003236:	8a5e                	mv	s4,s7
    80003238:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000323a:	01278963          	beq	a5,s2,8000324c <namex+0x130>
    8000323e:	dfbd                	beqz	a5,800031bc <namex+0xa0>
    path++;
    80003240:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003242:	0004c783          	lbu	a5,0(s1)
    80003246:	ff279ce3          	bne	a5,s2,8000323e <namex+0x122>
    8000324a:	bf8d                	j	800031bc <namex+0xa0>
    memmove(name, s, len);
    8000324c:	2601                	sext.w	a2,a2
    8000324e:	8556                	mv	a0,s5
    80003250:	ffffd097          	auipc	ra,0xffffd
    80003254:	f88080e7          	jalr	-120(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003258:	9a56                	add	s4,s4,s5
    8000325a:	000a0023          	sb	zero,0(s4)
    8000325e:	bf9d                	j	800031d4 <namex+0xb8>
  if(nameiparent){
    80003260:	f20b03e3          	beqz	s6,80003186 <namex+0x6a>
    iput(ip);
    80003264:	854e                	mv	a0,s3
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	adc080e7          	jalr	-1316(ra) # 80002d42 <iput>
    return 0;
    8000326e:	4981                	li	s3,0
    80003270:	bf19                	j	80003186 <namex+0x6a>
  if(*path == 0)
    80003272:	d7fd                	beqz	a5,80003260 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003274:	0004c783          	lbu	a5,0(s1)
    80003278:	85a6                	mv	a1,s1
    8000327a:	b7d1                	j	8000323e <namex+0x122>

000000008000327c <dirlink>:
{
    8000327c:	7139                	addi	sp,sp,-64
    8000327e:	fc06                	sd	ra,56(sp)
    80003280:	f822                	sd	s0,48(sp)
    80003282:	f426                	sd	s1,40(sp)
    80003284:	f04a                	sd	s2,32(sp)
    80003286:	ec4e                	sd	s3,24(sp)
    80003288:	e852                	sd	s4,16(sp)
    8000328a:	0080                	addi	s0,sp,64
    8000328c:	892a                	mv	s2,a0
    8000328e:	8a2e                	mv	s4,a1
    80003290:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003292:	4601                	li	a2,0
    80003294:	00000097          	auipc	ra,0x0
    80003298:	dd8080e7          	jalr	-552(ra) # 8000306c <dirlookup>
    8000329c:	e93d                	bnez	a0,80003312 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000329e:	04c92483          	lw	s1,76(s2)
    800032a2:	c49d                	beqz	s1,800032d0 <dirlink+0x54>
    800032a4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a6:	4741                	li	a4,16
    800032a8:	86a6                	mv	a3,s1
    800032aa:	fc040613          	addi	a2,s0,-64
    800032ae:	4581                	li	a1,0
    800032b0:	854a                	mv	a0,s2
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	b8a080e7          	jalr	-1142(ra) # 80002e3c <readi>
    800032ba:	47c1                	li	a5,16
    800032bc:	06f51163          	bne	a0,a5,8000331e <dirlink+0xa2>
    if(de.inum == 0)
    800032c0:	fc045783          	lhu	a5,-64(s0)
    800032c4:	c791                	beqz	a5,800032d0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c6:	24c1                	addiw	s1,s1,16
    800032c8:	04c92783          	lw	a5,76(s2)
    800032cc:	fcf4ede3          	bltu	s1,a5,800032a6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032d0:	4639                	li	a2,14
    800032d2:	85d2                	mv	a1,s4
    800032d4:	fc240513          	addi	a0,s0,-62
    800032d8:	ffffd097          	auipc	ra,0xffffd
    800032dc:	fb4080e7          	jalr	-76(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032e0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e4:	4741                	li	a4,16
    800032e6:	86a6                	mv	a3,s1
    800032e8:	fc040613          	addi	a2,s0,-64
    800032ec:	4581                	li	a1,0
    800032ee:	854a                	mv	a0,s2
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	c44080e7          	jalr	-956(ra) # 80002f34 <writei>
    800032f8:	1541                	addi	a0,a0,-16
    800032fa:	00a03533          	snez	a0,a0
    800032fe:	40a00533          	neg	a0,a0
}
    80003302:	70e2                	ld	ra,56(sp)
    80003304:	7442                	ld	s0,48(sp)
    80003306:	74a2                	ld	s1,40(sp)
    80003308:	7902                	ld	s2,32(sp)
    8000330a:	69e2                	ld	s3,24(sp)
    8000330c:	6a42                	ld	s4,16(sp)
    8000330e:	6121                	addi	sp,sp,64
    80003310:	8082                	ret
    iput(ip);
    80003312:	00000097          	auipc	ra,0x0
    80003316:	a30080e7          	jalr	-1488(ra) # 80002d42 <iput>
    return -1;
    8000331a:	557d                	li	a0,-1
    8000331c:	b7dd                	j	80003302 <dirlink+0x86>
      panic("dirlink read");
    8000331e:	00006517          	auipc	a0,0x6
    80003322:	2ca50513          	addi	a0,a0,714 # 800095e8 <syscalls+0x208>
    80003326:	00004097          	auipc	ra,0x4
    8000332a:	96c080e7          	jalr	-1684(ra) # 80006c92 <panic>

000000008000332e <namei>:

struct inode*
namei(char *path)
{
    8000332e:	1101                	addi	sp,sp,-32
    80003330:	ec06                	sd	ra,24(sp)
    80003332:	e822                	sd	s0,16(sp)
    80003334:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003336:	fe040613          	addi	a2,s0,-32
    8000333a:	4581                	li	a1,0
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	de0080e7          	jalr	-544(ra) # 8000311c <namex>
}
    80003344:	60e2                	ld	ra,24(sp)
    80003346:	6442                	ld	s0,16(sp)
    80003348:	6105                	addi	sp,sp,32
    8000334a:	8082                	ret

000000008000334c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000334c:	1141                	addi	sp,sp,-16
    8000334e:	e406                	sd	ra,8(sp)
    80003350:	e022                	sd	s0,0(sp)
    80003352:	0800                	addi	s0,sp,16
    80003354:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003356:	4585                	li	a1,1
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	dc4080e7          	jalr	-572(ra) # 8000311c <namex>
}
    80003360:	60a2                	ld	ra,8(sp)
    80003362:	6402                	ld	s0,0(sp)
    80003364:	0141                	addi	sp,sp,16
    80003366:	8082                	ret

0000000080003368 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	e04a                	sd	s2,0(sp)
    80003372:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003374:	00016917          	auipc	s2,0x16
    80003378:	60c90913          	addi	s2,s2,1548 # 80019980 <log>
    8000337c:	01892583          	lw	a1,24(s2)
    80003380:	02892503          	lw	a0,40(s2)
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	fea080e7          	jalr	-22(ra) # 8000236e <bread>
    8000338c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000338e:	02c92683          	lw	a3,44(s2)
    80003392:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003394:	02d05763          	blez	a3,800033c2 <write_head+0x5a>
    80003398:	00016797          	auipc	a5,0x16
    8000339c:	61878793          	addi	a5,a5,1560 # 800199b0 <log+0x30>
    800033a0:	05c50713          	addi	a4,a0,92
    800033a4:	36fd                	addiw	a3,a3,-1
    800033a6:	1682                	slli	a3,a3,0x20
    800033a8:	9281                	srli	a3,a3,0x20
    800033aa:	068a                	slli	a3,a3,0x2
    800033ac:	00016617          	auipc	a2,0x16
    800033b0:	60860613          	addi	a2,a2,1544 # 800199b4 <log+0x34>
    800033b4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033b6:	4390                	lw	a2,0(a5)
    800033b8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033ba:	0791                	addi	a5,a5,4
    800033bc:	0711                	addi	a4,a4,4
    800033be:	fed79ce3          	bne	a5,a3,800033b6 <write_head+0x4e>
  }
  bwrite(buf);
    800033c2:	8526                	mv	a0,s1
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	09c080e7          	jalr	156(ra) # 80002460 <bwrite>
  brelse(buf);
    800033cc:	8526                	mv	a0,s1
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	0d0080e7          	jalr	208(ra) # 8000249e <brelse>
}
    800033d6:	60e2                	ld	ra,24(sp)
    800033d8:	6442                	ld	s0,16(sp)
    800033da:	64a2                	ld	s1,8(sp)
    800033dc:	6902                	ld	s2,0(sp)
    800033de:	6105                	addi	sp,sp,32
    800033e0:	8082                	ret

00000000800033e2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e2:	00016797          	auipc	a5,0x16
    800033e6:	5ca7a783          	lw	a5,1482(a5) # 800199ac <log+0x2c>
    800033ea:	0af05d63          	blez	a5,800034a4 <install_trans+0xc2>
{
    800033ee:	7139                	addi	sp,sp,-64
    800033f0:	fc06                	sd	ra,56(sp)
    800033f2:	f822                	sd	s0,48(sp)
    800033f4:	f426                	sd	s1,40(sp)
    800033f6:	f04a                	sd	s2,32(sp)
    800033f8:	ec4e                	sd	s3,24(sp)
    800033fa:	e852                	sd	s4,16(sp)
    800033fc:	e456                	sd	s5,8(sp)
    800033fe:	e05a                	sd	s6,0(sp)
    80003400:	0080                	addi	s0,sp,64
    80003402:	8b2a                	mv	s6,a0
    80003404:	00016a97          	auipc	s5,0x16
    80003408:	5aca8a93          	addi	s5,s5,1452 # 800199b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000340c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000340e:	00016997          	auipc	s3,0x16
    80003412:	57298993          	addi	s3,s3,1394 # 80019980 <log>
    80003416:	a035                	j	80003442 <install_trans+0x60>
      bunpin(dbuf);
    80003418:	8526                	mv	a0,s1
    8000341a:	fffff097          	auipc	ra,0xfffff
    8000341e:	15e080e7          	jalr	350(ra) # 80002578 <bunpin>
    brelse(lbuf);
    80003422:	854a                	mv	a0,s2
    80003424:	fffff097          	auipc	ra,0xfffff
    80003428:	07a080e7          	jalr	122(ra) # 8000249e <brelse>
    brelse(dbuf);
    8000342c:	8526                	mv	a0,s1
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	070080e7          	jalr	112(ra) # 8000249e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003436:	2a05                	addiw	s4,s4,1
    80003438:	0a91                	addi	s5,s5,4
    8000343a:	02c9a783          	lw	a5,44(s3)
    8000343e:	04fa5963          	bge	s4,a5,80003490 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003442:	0189a583          	lw	a1,24(s3)
    80003446:	014585bb          	addw	a1,a1,s4
    8000344a:	2585                	addiw	a1,a1,1
    8000344c:	0289a503          	lw	a0,40(s3)
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	f1e080e7          	jalr	-226(ra) # 8000236e <bread>
    80003458:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000345a:	000aa583          	lw	a1,0(s5)
    8000345e:	0289a503          	lw	a0,40(s3)
    80003462:	fffff097          	auipc	ra,0xfffff
    80003466:	f0c080e7          	jalr	-244(ra) # 8000236e <bread>
    8000346a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000346c:	40000613          	li	a2,1024
    80003470:	05890593          	addi	a1,s2,88
    80003474:	05850513          	addi	a0,a0,88
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	d60080e7          	jalr	-672(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003480:	8526                	mv	a0,s1
    80003482:	fffff097          	auipc	ra,0xfffff
    80003486:	fde080e7          	jalr	-34(ra) # 80002460 <bwrite>
    if(recovering == 0)
    8000348a:	f80b1ce3          	bnez	s6,80003422 <install_trans+0x40>
    8000348e:	b769                	j	80003418 <install_trans+0x36>
}
    80003490:	70e2                	ld	ra,56(sp)
    80003492:	7442                	ld	s0,48(sp)
    80003494:	74a2                	ld	s1,40(sp)
    80003496:	7902                	ld	s2,32(sp)
    80003498:	69e2                	ld	s3,24(sp)
    8000349a:	6a42                	ld	s4,16(sp)
    8000349c:	6aa2                	ld	s5,8(sp)
    8000349e:	6b02                	ld	s6,0(sp)
    800034a0:	6121                	addi	sp,sp,64
    800034a2:	8082                	ret
    800034a4:	8082                	ret

00000000800034a6 <initlog>:
{
    800034a6:	7179                	addi	sp,sp,-48
    800034a8:	f406                	sd	ra,40(sp)
    800034aa:	f022                	sd	s0,32(sp)
    800034ac:	ec26                	sd	s1,24(sp)
    800034ae:	e84a                	sd	s2,16(sp)
    800034b0:	e44e                	sd	s3,8(sp)
    800034b2:	1800                	addi	s0,sp,48
    800034b4:	892a                	mv	s2,a0
    800034b6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034b8:	00016497          	auipc	s1,0x16
    800034bc:	4c848493          	addi	s1,s1,1224 # 80019980 <log>
    800034c0:	00006597          	auipc	a1,0x6
    800034c4:	13858593          	addi	a1,a1,312 # 800095f8 <syscalls+0x218>
    800034c8:	8526                	mv	a0,s1
    800034ca:	00004097          	auipc	ra,0x4
    800034ce:	c82080e7          	jalr	-894(ra) # 8000714c <initlock>
  log.start = sb->logstart;
    800034d2:	0149a583          	lw	a1,20(s3)
    800034d6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034d8:	0109a783          	lw	a5,16(s3)
    800034dc:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034de:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034e2:	854a                	mv	a0,s2
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	e8a080e7          	jalr	-374(ra) # 8000236e <bread>
  log.lh.n = lh->n;
    800034ec:	4d3c                	lw	a5,88(a0)
    800034ee:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034f0:	02f05563          	blez	a5,8000351a <initlog+0x74>
    800034f4:	05c50713          	addi	a4,a0,92
    800034f8:	00016697          	auipc	a3,0x16
    800034fc:	4b868693          	addi	a3,a3,1208 # 800199b0 <log+0x30>
    80003500:	37fd                	addiw	a5,a5,-1
    80003502:	1782                	slli	a5,a5,0x20
    80003504:	9381                	srli	a5,a5,0x20
    80003506:	078a                	slli	a5,a5,0x2
    80003508:	06050613          	addi	a2,a0,96
    8000350c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000350e:	4310                	lw	a2,0(a4)
    80003510:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003512:	0711                	addi	a4,a4,4
    80003514:	0691                	addi	a3,a3,4
    80003516:	fef71ce3          	bne	a4,a5,8000350e <initlog+0x68>
  brelse(buf);
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	f84080e7          	jalr	-124(ra) # 8000249e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003522:	4505                	li	a0,1
    80003524:	00000097          	auipc	ra,0x0
    80003528:	ebe080e7          	jalr	-322(ra) # 800033e2 <install_trans>
  log.lh.n = 0;
    8000352c:	00016797          	auipc	a5,0x16
    80003530:	4807a023          	sw	zero,1152(a5) # 800199ac <log+0x2c>
  write_head(); // clear the log
    80003534:	00000097          	auipc	ra,0x0
    80003538:	e34080e7          	jalr	-460(ra) # 80003368 <write_head>
}
    8000353c:	70a2                	ld	ra,40(sp)
    8000353e:	7402                	ld	s0,32(sp)
    80003540:	64e2                	ld	s1,24(sp)
    80003542:	6942                	ld	s2,16(sp)
    80003544:	69a2                	ld	s3,8(sp)
    80003546:	6145                	addi	sp,sp,48
    80003548:	8082                	ret

000000008000354a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000354a:	1101                	addi	sp,sp,-32
    8000354c:	ec06                	sd	ra,24(sp)
    8000354e:	e822                	sd	s0,16(sp)
    80003550:	e426                	sd	s1,8(sp)
    80003552:	e04a                	sd	s2,0(sp)
    80003554:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003556:	00016517          	auipc	a0,0x16
    8000355a:	42a50513          	addi	a0,a0,1066 # 80019980 <log>
    8000355e:	00004097          	auipc	ra,0x4
    80003562:	c7e080e7          	jalr	-898(ra) # 800071dc <acquire>
  while(1){
    if(log.committing){
    80003566:	00016497          	auipc	s1,0x16
    8000356a:	41a48493          	addi	s1,s1,1050 # 80019980 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000356e:	4979                	li	s2,30
    80003570:	a039                	j	8000357e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003572:	85a6                	mv	a1,s1
    80003574:	8526                	mv	a0,s1
    80003576:	ffffe097          	auipc	ra,0xffffe
    8000357a:	01a080e7          	jalr	26(ra) # 80001590 <sleep>
    if(log.committing){
    8000357e:	50dc                	lw	a5,36(s1)
    80003580:	fbed                	bnez	a5,80003572 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003582:	509c                	lw	a5,32(s1)
    80003584:	0017871b          	addiw	a4,a5,1
    80003588:	0007069b          	sext.w	a3,a4
    8000358c:	0027179b          	slliw	a5,a4,0x2
    80003590:	9fb9                	addw	a5,a5,a4
    80003592:	0017979b          	slliw	a5,a5,0x1
    80003596:	54d8                	lw	a4,44(s1)
    80003598:	9fb9                	addw	a5,a5,a4
    8000359a:	00f95963          	bge	s2,a5,800035ac <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000359e:	85a6                	mv	a1,s1
    800035a0:	8526                	mv	a0,s1
    800035a2:	ffffe097          	auipc	ra,0xffffe
    800035a6:	fee080e7          	jalr	-18(ra) # 80001590 <sleep>
    800035aa:	bfd1                	j	8000357e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ac:	00016517          	auipc	a0,0x16
    800035b0:	3d450513          	addi	a0,a0,980 # 80019980 <log>
    800035b4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035b6:	00004097          	auipc	ra,0x4
    800035ba:	cda080e7          	jalr	-806(ra) # 80007290 <release>
      break;
    }
  }
}
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6902                	ld	s2,0(sp)
    800035c6:	6105                	addi	sp,sp,32
    800035c8:	8082                	ret

00000000800035ca <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035ca:	7139                	addi	sp,sp,-64
    800035cc:	fc06                	sd	ra,56(sp)
    800035ce:	f822                	sd	s0,48(sp)
    800035d0:	f426                	sd	s1,40(sp)
    800035d2:	f04a                	sd	s2,32(sp)
    800035d4:	ec4e                	sd	s3,24(sp)
    800035d6:	e852                	sd	s4,16(sp)
    800035d8:	e456                	sd	s5,8(sp)
    800035da:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035dc:	00016497          	auipc	s1,0x16
    800035e0:	3a448493          	addi	s1,s1,932 # 80019980 <log>
    800035e4:	8526                	mv	a0,s1
    800035e6:	00004097          	auipc	ra,0x4
    800035ea:	bf6080e7          	jalr	-1034(ra) # 800071dc <acquire>
  log.outstanding -= 1;
    800035ee:	509c                	lw	a5,32(s1)
    800035f0:	37fd                	addiw	a5,a5,-1
    800035f2:	0007891b          	sext.w	s2,a5
    800035f6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035f8:	50dc                	lw	a5,36(s1)
    800035fa:	efb9                	bnez	a5,80003658 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035fc:	06091663          	bnez	s2,80003668 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003600:	00016497          	auipc	s1,0x16
    80003604:	38048493          	addi	s1,s1,896 # 80019980 <log>
    80003608:	4785                	li	a5,1
    8000360a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000360c:	8526                	mv	a0,s1
    8000360e:	00004097          	auipc	ra,0x4
    80003612:	c82080e7          	jalr	-894(ra) # 80007290 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003616:	54dc                	lw	a5,44(s1)
    80003618:	06f04763          	bgtz	a5,80003686 <end_op+0xbc>
    acquire(&log.lock);
    8000361c:	00016497          	auipc	s1,0x16
    80003620:	36448493          	addi	s1,s1,868 # 80019980 <log>
    80003624:	8526                	mv	a0,s1
    80003626:	00004097          	auipc	ra,0x4
    8000362a:	bb6080e7          	jalr	-1098(ra) # 800071dc <acquire>
    log.committing = 0;
    8000362e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003632:	8526                	mv	a0,s1
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	fc0080e7          	jalr	-64(ra) # 800015f4 <wakeup>
    release(&log.lock);
    8000363c:	8526                	mv	a0,s1
    8000363e:	00004097          	auipc	ra,0x4
    80003642:	c52080e7          	jalr	-942(ra) # 80007290 <release>
}
    80003646:	70e2                	ld	ra,56(sp)
    80003648:	7442                	ld	s0,48(sp)
    8000364a:	74a2                	ld	s1,40(sp)
    8000364c:	7902                	ld	s2,32(sp)
    8000364e:	69e2                	ld	s3,24(sp)
    80003650:	6a42                	ld	s4,16(sp)
    80003652:	6aa2                	ld	s5,8(sp)
    80003654:	6121                	addi	sp,sp,64
    80003656:	8082                	ret
    panic("log.committing");
    80003658:	00006517          	auipc	a0,0x6
    8000365c:	fa850513          	addi	a0,a0,-88 # 80009600 <syscalls+0x220>
    80003660:	00003097          	auipc	ra,0x3
    80003664:	632080e7          	jalr	1586(ra) # 80006c92 <panic>
    wakeup(&log);
    80003668:	00016497          	auipc	s1,0x16
    8000366c:	31848493          	addi	s1,s1,792 # 80019980 <log>
    80003670:	8526                	mv	a0,s1
    80003672:	ffffe097          	auipc	ra,0xffffe
    80003676:	f82080e7          	jalr	-126(ra) # 800015f4 <wakeup>
  release(&log.lock);
    8000367a:	8526                	mv	a0,s1
    8000367c:	00004097          	auipc	ra,0x4
    80003680:	c14080e7          	jalr	-1004(ra) # 80007290 <release>
  if(do_commit){
    80003684:	b7c9                	j	80003646 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003686:	00016a97          	auipc	s5,0x16
    8000368a:	32aa8a93          	addi	s5,s5,810 # 800199b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000368e:	00016a17          	auipc	s4,0x16
    80003692:	2f2a0a13          	addi	s4,s4,754 # 80019980 <log>
    80003696:	018a2583          	lw	a1,24(s4)
    8000369a:	012585bb          	addw	a1,a1,s2
    8000369e:	2585                	addiw	a1,a1,1
    800036a0:	028a2503          	lw	a0,40(s4)
    800036a4:	fffff097          	auipc	ra,0xfffff
    800036a8:	cca080e7          	jalr	-822(ra) # 8000236e <bread>
    800036ac:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036ae:	000aa583          	lw	a1,0(s5)
    800036b2:	028a2503          	lw	a0,40(s4)
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	cb8080e7          	jalr	-840(ra) # 8000236e <bread>
    800036be:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036c0:	40000613          	li	a2,1024
    800036c4:	05850593          	addi	a1,a0,88
    800036c8:	05848513          	addi	a0,s1,88
    800036cc:	ffffd097          	auipc	ra,0xffffd
    800036d0:	b0c080e7          	jalr	-1268(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036d4:	8526                	mv	a0,s1
    800036d6:	fffff097          	auipc	ra,0xfffff
    800036da:	d8a080e7          	jalr	-630(ra) # 80002460 <bwrite>
    brelse(from);
    800036de:	854e                	mv	a0,s3
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	dbe080e7          	jalr	-578(ra) # 8000249e <brelse>
    brelse(to);
    800036e8:	8526                	mv	a0,s1
    800036ea:	fffff097          	auipc	ra,0xfffff
    800036ee:	db4080e7          	jalr	-588(ra) # 8000249e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f2:	2905                	addiw	s2,s2,1
    800036f4:	0a91                	addi	s5,s5,4
    800036f6:	02ca2783          	lw	a5,44(s4)
    800036fa:	f8f94ee3          	blt	s2,a5,80003696 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036fe:	00000097          	auipc	ra,0x0
    80003702:	c6a080e7          	jalr	-918(ra) # 80003368 <write_head>
    install_trans(0); // Now install writes to home locations
    80003706:	4501                	li	a0,0
    80003708:	00000097          	auipc	ra,0x0
    8000370c:	cda080e7          	jalr	-806(ra) # 800033e2 <install_trans>
    log.lh.n = 0;
    80003710:	00016797          	auipc	a5,0x16
    80003714:	2807ae23          	sw	zero,668(a5) # 800199ac <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	c50080e7          	jalr	-944(ra) # 80003368 <write_head>
    80003720:	bdf5                	j	8000361c <end_op+0x52>

0000000080003722 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003722:	1101                	addi	sp,sp,-32
    80003724:	ec06                	sd	ra,24(sp)
    80003726:	e822                	sd	s0,16(sp)
    80003728:	e426                	sd	s1,8(sp)
    8000372a:	e04a                	sd	s2,0(sp)
    8000372c:	1000                	addi	s0,sp,32
    8000372e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003730:	00016917          	auipc	s2,0x16
    80003734:	25090913          	addi	s2,s2,592 # 80019980 <log>
    80003738:	854a                	mv	a0,s2
    8000373a:	00004097          	auipc	ra,0x4
    8000373e:	aa2080e7          	jalr	-1374(ra) # 800071dc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003742:	02c92603          	lw	a2,44(s2)
    80003746:	47f5                	li	a5,29
    80003748:	06c7c563          	blt	a5,a2,800037b2 <log_write+0x90>
    8000374c:	00016797          	auipc	a5,0x16
    80003750:	2507a783          	lw	a5,592(a5) # 8001999c <log+0x1c>
    80003754:	37fd                	addiw	a5,a5,-1
    80003756:	04f65e63          	bge	a2,a5,800037b2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000375a:	00016797          	auipc	a5,0x16
    8000375e:	2467a783          	lw	a5,582(a5) # 800199a0 <log+0x20>
    80003762:	06f05063          	blez	a5,800037c2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003766:	4781                	li	a5,0
    80003768:	06c05563          	blez	a2,800037d2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000376c:	44cc                	lw	a1,12(s1)
    8000376e:	00016717          	auipc	a4,0x16
    80003772:	24270713          	addi	a4,a4,578 # 800199b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003776:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003778:	4314                	lw	a3,0(a4)
    8000377a:	04b68c63          	beq	a3,a1,800037d2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000377e:	2785                	addiw	a5,a5,1
    80003780:	0711                	addi	a4,a4,4
    80003782:	fef61be3          	bne	a2,a5,80003778 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003786:	0621                	addi	a2,a2,8
    80003788:	060a                	slli	a2,a2,0x2
    8000378a:	00016797          	auipc	a5,0x16
    8000378e:	1f678793          	addi	a5,a5,502 # 80019980 <log>
    80003792:	963e                	add	a2,a2,a5
    80003794:	44dc                	lw	a5,12(s1)
    80003796:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003798:	8526                	mv	a0,s1
    8000379a:	fffff097          	auipc	ra,0xfffff
    8000379e:	da2080e7          	jalr	-606(ra) # 8000253c <bpin>
    log.lh.n++;
    800037a2:	00016717          	auipc	a4,0x16
    800037a6:	1de70713          	addi	a4,a4,478 # 80019980 <log>
    800037aa:	575c                	lw	a5,44(a4)
    800037ac:	2785                	addiw	a5,a5,1
    800037ae:	d75c                	sw	a5,44(a4)
    800037b0:	a835                	j	800037ec <log_write+0xca>
    panic("too big a transaction");
    800037b2:	00006517          	auipc	a0,0x6
    800037b6:	e5e50513          	addi	a0,a0,-418 # 80009610 <syscalls+0x230>
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	4d8080e7          	jalr	1240(ra) # 80006c92 <panic>
    panic("log_write outside of trans");
    800037c2:	00006517          	auipc	a0,0x6
    800037c6:	e6650513          	addi	a0,a0,-410 # 80009628 <syscalls+0x248>
    800037ca:	00003097          	auipc	ra,0x3
    800037ce:	4c8080e7          	jalr	1224(ra) # 80006c92 <panic>
  log.lh.block[i] = b->blockno;
    800037d2:	00878713          	addi	a4,a5,8
    800037d6:	00271693          	slli	a3,a4,0x2
    800037da:	00016717          	auipc	a4,0x16
    800037de:	1a670713          	addi	a4,a4,422 # 80019980 <log>
    800037e2:	9736                	add	a4,a4,a3
    800037e4:	44d4                	lw	a3,12(s1)
    800037e6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037e8:	faf608e3          	beq	a2,a5,80003798 <log_write+0x76>
  }
  release(&log.lock);
    800037ec:	00016517          	auipc	a0,0x16
    800037f0:	19450513          	addi	a0,a0,404 # 80019980 <log>
    800037f4:	00004097          	auipc	ra,0x4
    800037f8:	a9c080e7          	jalr	-1380(ra) # 80007290 <release>
}
    800037fc:	60e2                	ld	ra,24(sp)
    800037fe:	6442                	ld	s0,16(sp)
    80003800:	64a2                	ld	s1,8(sp)
    80003802:	6902                	ld	s2,0(sp)
    80003804:	6105                	addi	sp,sp,32
    80003806:	8082                	ret

0000000080003808 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003808:	1101                	addi	sp,sp,-32
    8000380a:	ec06                	sd	ra,24(sp)
    8000380c:	e822                	sd	s0,16(sp)
    8000380e:	e426                	sd	s1,8(sp)
    80003810:	e04a                	sd	s2,0(sp)
    80003812:	1000                	addi	s0,sp,32
    80003814:	84aa                	mv	s1,a0
    80003816:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003818:	00006597          	auipc	a1,0x6
    8000381c:	e3058593          	addi	a1,a1,-464 # 80009648 <syscalls+0x268>
    80003820:	0521                	addi	a0,a0,8
    80003822:	00004097          	auipc	ra,0x4
    80003826:	92a080e7          	jalr	-1750(ra) # 8000714c <initlock>
  lk->name = name;
    8000382a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000382e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003832:	0204a423          	sw	zero,40(s1)
}
    80003836:	60e2                	ld	ra,24(sp)
    80003838:	6442                	ld	s0,16(sp)
    8000383a:	64a2                	ld	s1,8(sp)
    8000383c:	6902                	ld	s2,0(sp)
    8000383e:	6105                	addi	sp,sp,32
    80003840:	8082                	ret

0000000080003842 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003842:	1101                	addi	sp,sp,-32
    80003844:	ec06                	sd	ra,24(sp)
    80003846:	e822                	sd	s0,16(sp)
    80003848:	e426                	sd	s1,8(sp)
    8000384a:	e04a                	sd	s2,0(sp)
    8000384c:	1000                	addi	s0,sp,32
    8000384e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003850:	00850913          	addi	s2,a0,8
    80003854:	854a                	mv	a0,s2
    80003856:	00004097          	auipc	ra,0x4
    8000385a:	986080e7          	jalr	-1658(ra) # 800071dc <acquire>
  while (lk->locked) {
    8000385e:	409c                	lw	a5,0(s1)
    80003860:	cb89                	beqz	a5,80003872 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003862:	85ca                	mv	a1,s2
    80003864:	8526                	mv	a0,s1
    80003866:	ffffe097          	auipc	ra,0xffffe
    8000386a:	d2a080e7          	jalr	-726(ra) # 80001590 <sleep>
  while (lk->locked) {
    8000386e:	409c                	lw	a5,0(s1)
    80003870:	fbed                	bnez	a5,80003862 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003872:	4785                	li	a5,1
    80003874:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003876:	ffffd097          	auipc	ra,0xffffd
    8000387a:	672080e7          	jalr	1650(ra) # 80000ee8 <myproc>
    8000387e:	591c                	lw	a5,48(a0)
    80003880:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003882:	854a                	mv	a0,s2
    80003884:	00004097          	auipc	ra,0x4
    80003888:	a0c080e7          	jalr	-1524(ra) # 80007290 <release>
}
    8000388c:	60e2                	ld	ra,24(sp)
    8000388e:	6442                	ld	s0,16(sp)
    80003890:	64a2                	ld	s1,8(sp)
    80003892:	6902                	ld	s2,0(sp)
    80003894:	6105                	addi	sp,sp,32
    80003896:	8082                	ret

0000000080003898 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003898:	1101                	addi	sp,sp,-32
    8000389a:	ec06                	sd	ra,24(sp)
    8000389c:	e822                	sd	s0,16(sp)
    8000389e:	e426                	sd	s1,8(sp)
    800038a0:	e04a                	sd	s2,0(sp)
    800038a2:	1000                	addi	s0,sp,32
    800038a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038a6:	00850913          	addi	s2,a0,8
    800038aa:	854a                	mv	a0,s2
    800038ac:	00004097          	auipc	ra,0x4
    800038b0:	930080e7          	jalr	-1744(ra) # 800071dc <acquire>
  lk->locked = 0;
    800038b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038bc:	8526                	mv	a0,s1
    800038be:	ffffe097          	auipc	ra,0xffffe
    800038c2:	d36080e7          	jalr	-714(ra) # 800015f4 <wakeup>
  release(&lk->lk);
    800038c6:	854a                	mv	a0,s2
    800038c8:	00004097          	auipc	ra,0x4
    800038cc:	9c8080e7          	jalr	-1592(ra) # 80007290 <release>
}
    800038d0:	60e2                	ld	ra,24(sp)
    800038d2:	6442                	ld	s0,16(sp)
    800038d4:	64a2                	ld	s1,8(sp)
    800038d6:	6902                	ld	s2,0(sp)
    800038d8:	6105                	addi	sp,sp,32
    800038da:	8082                	ret

00000000800038dc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038dc:	7179                	addi	sp,sp,-48
    800038de:	f406                	sd	ra,40(sp)
    800038e0:	f022                	sd	s0,32(sp)
    800038e2:	ec26                	sd	s1,24(sp)
    800038e4:	e84a                	sd	s2,16(sp)
    800038e6:	e44e                	sd	s3,8(sp)
    800038e8:	1800                	addi	s0,sp,48
    800038ea:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038ec:	00850913          	addi	s2,a0,8
    800038f0:	854a                	mv	a0,s2
    800038f2:	00004097          	auipc	ra,0x4
    800038f6:	8ea080e7          	jalr	-1814(ra) # 800071dc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038fa:	409c                	lw	a5,0(s1)
    800038fc:	ef99                	bnez	a5,8000391a <holdingsleep+0x3e>
    800038fe:	4481                	li	s1,0
  release(&lk->lk);
    80003900:	854a                	mv	a0,s2
    80003902:	00004097          	auipc	ra,0x4
    80003906:	98e080e7          	jalr	-1650(ra) # 80007290 <release>
  return r;
}
    8000390a:	8526                	mv	a0,s1
    8000390c:	70a2                	ld	ra,40(sp)
    8000390e:	7402                	ld	s0,32(sp)
    80003910:	64e2                	ld	s1,24(sp)
    80003912:	6942                	ld	s2,16(sp)
    80003914:	69a2                	ld	s3,8(sp)
    80003916:	6145                	addi	sp,sp,48
    80003918:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000391a:	0284a983          	lw	s3,40(s1)
    8000391e:	ffffd097          	auipc	ra,0xffffd
    80003922:	5ca080e7          	jalr	1482(ra) # 80000ee8 <myproc>
    80003926:	5904                	lw	s1,48(a0)
    80003928:	413484b3          	sub	s1,s1,s3
    8000392c:	0014b493          	seqz	s1,s1
    80003930:	bfc1                	j	80003900 <holdingsleep+0x24>

0000000080003932 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003932:	1141                	addi	sp,sp,-16
    80003934:	e406                	sd	ra,8(sp)
    80003936:	e022                	sd	s0,0(sp)
    80003938:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000393a:	00006597          	auipc	a1,0x6
    8000393e:	d1e58593          	addi	a1,a1,-738 # 80009658 <syscalls+0x278>
    80003942:	00016517          	auipc	a0,0x16
    80003946:	18650513          	addi	a0,a0,390 # 80019ac8 <ftable>
    8000394a:	00004097          	auipc	ra,0x4
    8000394e:	802080e7          	jalr	-2046(ra) # 8000714c <initlock>
}
    80003952:	60a2                	ld	ra,8(sp)
    80003954:	6402                	ld	s0,0(sp)
    80003956:	0141                	addi	sp,sp,16
    80003958:	8082                	ret

000000008000395a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000395a:	1101                	addi	sp,sp,-32
    8000395c:	ec06                	sd	ra,24(sp)
    8000395e:	e822                	sd	s0,16(sp)
    80003960:	e426                	sd	s1,8(sp)
    80003962:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003964:	00016517          	auipc	a0,0x16
    80003968:	16450513          	addi	a0,a0,356 # 80019ac8 <ftable>
    8000396c:	00004097          	auipc	ra,0x4
    80003970:	870080e7          	jalr	-1936(ra) # 800071dc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003974:	00016497          	auipc	s1,0x16
    80003978:	16c48493          	addi	s1,s1,364 # 80019ae0 <ftable+0x18>
    8000397c:	00017717          	auipc	a4,0x17
    80003980:	42470713          	addi	a4,a4,1060 # 8001ada0 <disk>
    if(f->ref == 0){
    80003984:	40dc                	lw	a5,4(s1)
    80003986:	cf99                	beqz	a5,800039a4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003988:	03048493          	addi	s1,s1,48
    8000398c:	fee49ce3          	bne	s1,a4,80003984 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003990:	00016517          	auipc	a0,0x16
    80003994:	13850513          	addi	a0,a0,312 # 80019ac8 <ftable>
    80003998:	00004097          	auipc	ra,0x4
    8000399c:	8f8080e7          	jalr	-1800(ra) # 80007290 <release>
  return 0;
    800039a0:	4481                	li	s1,0
    800039a2:	a819                	j	800039b8 <filealloc+0x5e>
      f->ref = 1;
    800039a4:	4785                	li	a5,1
    800039a6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039a8:	00016517          	auipc	a0,0x16
    800039ac:	12050513          	addi	a0,a0,288 # 80019ac8 <ftable>
    800039b0:	00004097          	auipc	ra,0x4
    800039b4:	8e0080e7          	jalr	-1824(ra) # 80007290 <release>
}
    800039b8:	8526                	mv	a0,s1
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec06                	sd	ra,24(sp)
    800039c8:	e822                	sd	s0,16(sp)
    800039ca:	e426                	sd	s1,8(sp)
    800039cc:	1000                	addi	s0,sp,32
    800039ce:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039d0:	00016517          	auipc	a0,0x16
    800039d4:	0f850513          	addi	a0,a0,248 # 80019ac8 <ftable>
    800039d8:	00004097          	auipc	ra,0x4
    800039dc:	804080e7          	jalr	-2044(ra) # 800071dc <acquire>
  if(f->ref < 1)
    800039e0:	40dc                	lw	a5,4(s1)
    800039e2:	02f05263          	blez	a5,80003a06 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039e6:	2785                	addiw	a5,a5,1
    800039e8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039ea:	00016517          	auipc	a0,0x16
    800039ee:	0de50513          	addi	a0,a0,222 # 80019ac8 <ftable>
    800039f2:	00004097          	auipc	ra,0x4
    800039f6:	89e080e7          	jalr	-1890(ra) # 80007290 <release>
  return f;
}
    800039fa:	8526                	mv	a0,s1
    800039fc:	60e2                	ld	ra,24(sp)
    800039fe:	6442                	ld	s0,16(sp)
    80003a00:	64a2                	ld	s1,8(sp)
    80003a02:	6105                	addi	sp,sp,32
    80003a04:	8082                	ret
    panic("filedup");
    80003a06:	00006517          	auipc	a0,0x6
    80003a0a:	c5a50513          	addi	a0,a0,-934 # 80009660 <syscalls+0x280>
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	284080e7          	jalr	644(ra) # 80006c92 <panic>

0000000080003a16 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a16:	7139                	addi	sp,sp,-64
    80003a18:	fc06                	sd	ra,56(sp)
    80003a1a:	f822                	sd	s0,48(sp)
    80003a1c:	f426                	sd	s1,40(sp)
    80003a1e:	f04a                	sd	s2,32(sp)
    80003a20:	ec4e                	sd	s3,24(sp)
    80003a22:	e852                	sd	s4,16(sp)
    80003a24:	e456                	sd	s5,8(sp)
    80003a26:	e05a                	sd	s6,0(sp)
    80003a28:	0080                	addi	s0,sp,64
    80003a2a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a2c:	00016517          	auipc	a0,0x16
    80003a30:	09c50513          	addi	a0,a0,156 # 80019ac8 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	7a8080e7          	jalr	1960(ra) # 800071dc <acquire>
  if(f->ref < 1)
    80003a3c:	40dc                	lw	a5,4(s1)
    80003a3e:	04f05f63          	blez	a5,80003a9c <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    80003a42:	37fd                	addiw	a5,a5,-1
    80003a44:	0007871b          	sext.w	a4,a5
    80003a48:	c0dc                	sw	a5,4(s1)
    80003a4a:	06e04163          	bgtz	a4,80003aac <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a4e:	0004a903          	lw	s2,0(s1)
    80003a52:	0094ca83          	lbu	s5,9(s1)
    80003a56:	0104ba03          	ld	s4,16(s1)
    80003a5a:	0184b983          	ld	s3,24(s1)
    80003a5e:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    80003a62:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a66:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a6a:	00016517          	auipc	a0,0x16
    80003a6e:	05e50513          	addi	a0,a0,94 # 80019ac8 <ftable>
    80003a72:	00004097          	auipc	ra,0x4
    80003a76:	81e080e7          	jalr	-2018(ra) # 80007290 <release>

  if(ff.type == FD_PIPE){
    80003a7a:	4785                	li	a5,1
    80003a7c:	04f90a63          	beq	s2,a5,80003ad0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a80:	ffe9079b          	addiw	a5,s2,-2
    80003a84:	4705                	li	a4,1
    80003a86:	04f77c63          	bgeu	a4,a5,80003ade <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a8a:	4791                	li	a5,4
    80003a8c:	02f91863          	bne	s2,a5,80003abc <fileclose+0xa6>
    sockclose(ff.sock);
    80003a90:	855a                	mv	a0,s6
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	98e080e7          	jalr	-1650(ra) # 80006420 <sockclose>
    80003a9a:	a00d                	j	80003abc <fileclose+0xa6>
    panic("fileclose");
    80003a9c:	00006517          	auipc	a0,0x6
    80003aa0:	bcc50513          	addi	a0,a0,-1076 # 80009668 <syscalls+0x288>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	1ee080e7          	jalr	494(ra) # 80006c92 <panic>
    release(&ftable.lock);
    80003aac:	00016517          	auipc	a0,0x16
    80003ab0:	01c50513          	addi	a0,a0,28 # 80019ac8 <ftable>
    80003ab4:	00003097          	auipc	ra,0x3
    80003ab8:	7dc080e7          	jalr	2012(ra) # 80007290 <release>
  }
#endif
}
    80003abc:	70e2                	ld	ra,56(sp)
    80003abe:	7442                	ld	s0,48(sp)
    80003ac0:	74a2                	ld	s1,40(sp)
    80003ac2:	7902                	ld	s2,32(sp)
    80003ac4:	69e2                	ld	s3,24(sp)
    80003ac6:	6a42                	ld	s4,16(sp)
    80003ac8:	6aa2                	ld	s5,8(sp)
    80003aca:	6b02                	ld	s6,0(sp)
    80003acc:	6121                	addi	sp,sp,64
    80003ace:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ad0:	85d6                	mv	a1,s5
    80003ad2:	8552                	mv	a0,s4
    80003ad4:	00000097          	auipc	ra,0x0
    80003ad8:	37c080e7          	jalr	892(ra) # 80003e50 <pipeclose>
    80003adc:	b7c5                	j	80003abc <fileclose+0xa6>
    begin_op();
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	a6c080e7          	jalr	-1428(ra) # 8000354a <begin_op>
    iput(ff.ip);
    80003ae6:	854e                	mv	a0,s3
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	25a080e7          	jalr	602(ra) # 80002d42 <iput>
    end_op();
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	ada080e7          	jalr	-1318(ra) # 800035ca <end_op>
    80003af8:	b7d1                	j	80003abc <fileclose+0xa6>

0000000080003afa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003afa:	715d                	addi	sp,sp,-80
    80003afc:	e486                	sd	ra,72(sp)
    80003afe:	e0a2                	sd	s0,64(sp)
    80003b00:	fc26                	sd	s1,56(sp)
    80003b02:	f84a                	sd	s2,48(sp)
    80003b04:	f44e                	sd	s3,40(sp)
    80003b06:	0880                	addi	s0,sp,80
    80003b08:	84aa                	mv	s1,a0
    80003b0a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b0c:	ffffd097          	auipc	ra,0xffffd
    80003b10:	3dc080e7          	jalr	988(ra) # 80000ee8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b14:	409c                	lw	a5,0(s1)
    80003b16:	37f9                	addiw	a5,a5,-2
    80003b18:	4705                	li	a4,1
    80003b1a:	04f76763          	bltu	a4,a5,80003b68 <filestat+0x6e>
    80003b1e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b20:	6c88                	ld	a0,24(s1)
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	066080e7          	jalr	102(ra) # 80002b88 <ilock>
    stati(f->ip, &st);
    80003b2a:	fb840593          	addi	a1,s0,-72
    80003b2e:	6c88                	ld	a0,24(s1)
    80003b30:	fffff097          	auipc	ra,0xfffff
    80003b34:	2e2080e7          	jalr	738(ra) # 80002e12 <stati>
    iunlock(f->ip);
    80003b38:	6c88                	ld	a0,24(s1)
    80003b3a:	fffff097          	auipc	ra,0xfffff
    80003b3e:	110080e7          	jalr	272(ra) # 80002c4a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b42:	46e1                	li	a3,24
    80003b44:	fb840613          	addi	a2,s0,-72
    80003b48:	85ce                	mv	a1,s3
    80003b4a:	05093503          	ld	a0,80(s2)
    80003b4e:	ffffd097          	auipc	ra,0xffffd
    80003b52:	024080e7          	jalr	36(ra) # 80000b72 <copyout>
    80003b56:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b5a:	60a6                	ld	ra,72(sp)
    80003b5c:	6406                	ld	s0,64(sp)
    80003b5e:	74e2                	ld	s1,56(sp)
    80003b60:	7942                	ld	s2,48(sp)
    80003b62:	79a2                	ld	s3,40(sp)
    80003b64:	6161                	addi	sp,sp,80
    80003b66:	8082                	ret
  return -1;
    80003b68:	557d                	li	a0,-1
    80003b6a:	bfc5                	j	80003b5a <filestat+0x60>

0000000080003b6c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b6c:	7179                	addi	sp,sp,-48
    80003b6e:	f406                	sd	ra,40(sp)
    80003b70:	f022                	sd	s0,32(sp)
    80003b72:	ec26                	sd	s1,24(sp)
    80003b74:	e84a                	sd	s2,16(sp)
    80003b76:	e44e                	sd	s3,8(sp)
    80003b78:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b7a:	00854783          	lbu	a5,8(a0)
    80003b7e:	cfc5                	beqz	a5,80003c36 <fileread+0xca>
    80003b80:	84aa                	mv	s1,a0
    80003b82:	89ae                	mv	s3,a1
    80003b84:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b86:	411c                	lw	a5,0(a0)
    80003b88:	4705                	li	a4,1
    80003b8a:	02e78963          	beq	a5,a4,80003bbc <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b8e:	470d                	li	a4,3
    80003b90:	02e78d63          	beq	a5,a4,80003bca <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b94:	4709                	li	a4,2
    80003b96:	04e78e63          	beq	a5,a4,80003bf2 <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b9a:	4711                	li	a4,4
    80003b9c:	08e79563          	bne	a5,a4,80003c26 <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003ba0:	7108                	ld	a0,32(a0)
    80003ba2:	00003097          	auipc	ra,0x3
    80003ba6:	90e080e7          	jalr	-1778(ra) # 800064b0 <sockread>
    80003baa:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003bac:	854a                	mv	a0,s2
    80003bae:	70a2                	ld	ra,40(sp)
    80003bb0:	7402                	ld	s0,32(sp)
    80003bb2:	64e2                	ld	s1,24(sp)
    80003bb4:	6942                	ld	s2,16(sp)
    80003bb6:	69a2                	ld	s3,8(sp)
    80003bb8:	6145                	addi	sp,sp,48
    80003bba:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bbc:	6908                	ld	a0,16(a0)
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	402080e7          	jalr	1026(ra) # 80003fc0 <piperead>
    80003bc6:	892a                	mv	s2,a0
    80003bc8:	b7d5                	j	80003bac <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bca:	02c51783          	lh	a5,44(a0)
    80003bce:	03079693          	slli	a3,a5,0x30
    80003bd2:	92c1                	srli	a3,a3,0x30
    80003bd4:	4725                	li	a4,9
    80003bd6:	06d76263          	bltu	a4,a3,80003c3a <fileread+0xce>
    80003bda:	0792                	slli	a5,a5,0x4
    80003bdc:	00016717          	auipc	a4,0x16
    80003be0:	e4c70713          	addi	a4,a4,-436 # 80019a28 <devsw>
    80003be4:	97ba                	add	a5,a5,a4
    80003be6:	639c                	ld	a5,0(a5)
    80003be8:	cbb9                	beqz	a5,80003c3e <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003bea:	4505                	li	a0,1
    80003bec:	9782                	jalr	a5
    80003bee:	892a                	mv	s2,a0
    80003bf0:	bf75                	j	80003bac <fileread+0x40>
    ilock(f->ip);
    80003bf2:	6d08                	ld	a0,24(a0)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	f94080e7          	jalr	-108(ra) # 80002b88 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bfc:	874a                	mv	a4,s2
    80003bfe:	5494                	lw	a3,40(s1)
    80003c00:	864e                	mv	a2,s3
    80003c02:	4585                	li	a1,1
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	236080e7          	jalr	566(ra) # 80002e3c <readi>
    80003c0e:	892a                	mv	s2,a0
    80003c10:	00a05563          	blez	a0,80003c1a <fileread+0xae>
      f->off += r;
    80003c14:	549c                	lw	a5,40(s1)
    80003c16:	9fa9                	addw	a5,a5,a0
    80003c18:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003c1a:	6c88                	ld	a0,24(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	02e080e7          	jalr	46(ra) # 80002c4a <iunlock>
    80003c24:	b761                	j	80003bac <fileread+0x40>
    panic("fileread");
    80003c26:	00006517          	auipc	a0,0x6
    80003c2a:	a5250513          	addi	a0,a0,-1454 # 80009678 <syscalls+0x298>
    80003c2e:	00003097          	auipc	ra,0x3
    80003c32:	064080e7          	jalr	100(ra) # 80006c92 <panic>
    return -1;
    80003c36:	597d                	li	s2,-1
    80003c38:	bf95                	j	80003bac <fileread+0x40>
      return -1;
    80003c3a:	597d                	li	s2,-1
    80003c3c:	bf85                	j	80003bac <fileread+0x40>
    80003c3e:	597d                	li	s2,-1
    80003c40:	b7b5                	j	80003bac <fileread+0x40>

0000000080003c42 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c42:	00954783          	lbu	a5,9(a0)
    80003c46:	12078263          	beqz	a5,80003d6a <filewrite+0x128>
{
    80003c4a:	715d                	addi	sp,sp,-80
    80003c4c:	e486                	sd	ra,72(sp)
    80003c4e:	e0a2                	sd	s0,64(sp)
    80003c50:	fc26                	sd	s1,56(sp)
    80003c52:	f84a                	sd	s2,48(sp)
    80003c54:	f44e                	sd	s3,40(sp)
    80003c56:	f052                	sd	s4,32(sp)
    80003c58:	ec56                	sd	s5,24(sp)
    80003c5a:	e85a                	sd	s6,16(sp)
    80003c5c:	e45e                	sd	s7,8(sp)
    80003c5e:	e062                	sd	s8,0(sp)
    80003c60:	0880                	addi	s0,sp,80
    80003c62:	84aa                	mv	s1,a0
    80003c64:	8aae                	mv	s5,a1
    80003c66:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c68:	411c                	lw	a5,0(a0)
    80003c6a:	4705                	li	a4,1
    80003c6c:	02e78c63          	beq	a5,a4,80003ca4 <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c70:	470d                	li	a4,3
    80003c72:	02e78f63          	beq	a5,a4,80003cb0 <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c76:	4709                	li	a4,2
    80003c78:	04e78f63          	beq	a5,a4,80003cd6 <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003c7c:	4711                	li	a4,4
    80003c7e:	0ce79e63          	bne	a5,a4,80003d5a <filewrite+0x118>
    ret = sockwrite(f->sock, addr, n);
    80003c82:	7108                	ld	a0,32(a0)
    80003c84:	00003097          	auipc	ra,0x3
    80003c88:	8fc080e7          	jalr	-1796(ra) # 80006580 <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c8c:	60a6                	ld	ra,72(sp)
    80003c8e:	6406                	ld	s0,64(sp)
    80003c90:	74e2                	ld	s1,56(sp)
    80003c92:	7942                	ld	s2,48(sp)
    80003c94:	79a2                	ld	s3,40(sp)
    80003c96:	7a02                	ld	s4,32(sp)
    80003c98:	6ae2                	ld	s5,24(sp)
    80003c9a:	6b42                	ld	s6,16(sp)
    80003c9c:	6ba2                	ld	s7,8(sp)
    80003c9e:	6c02                	ld	s8,0(sp)
    80003ca0:	6161                	addi	sp,sp,80
    80003ca2:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003ca4:	6908                	ld	a0,16(a0)
    80003ca6:	00000097          	auipc	ra,0x0
    80003caa:	21a080e7          	jalr	538(ra) # 80003ec0 <pipewrite>
    80003cae:	bff9                	j	80003c8c <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cb0:	02c51783          	lh	a5,44(a0)
    80003cb4:	03079693          	slli	a3,a5,0x30
    80003cb8:	92c1                	srli	a3,a3,0x30
    80003cba:	4725                	li	a4,9
    80003cbc:	0ad76963          	bltu	a4,a3,80003d6e <filewrite+0x12c>
    80003cc0:	0792                	slli	a5,a5,0x4
    80003cc2:	00016717          	auipc	a4,0x16
    80003cc6:	d6670713          	addi	a4,a4,-666 # 80019a28 <devsw>
    80003cca:	97ba                	add	a5,a5,a4
    80003ccc:	679c                	ld	a5,8(a5)
    80003cce:	c3d5                	beqz	a5,80003d72 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cd0:	4505                	li	a0,1
    80003cd2:	9782                	jalr	a5
    80003cd4:	bf65                	j	80003c8c <filewrite+0x4a>
    while(i < n){
    80003cd6:	06c05c63          	blez	a2,80003d4e <filewrite+0x10c>
    int i = 0;
    80003cda:	4981                	li	s3,0
    80003cdc:	6b05                	lui	s6,0x1
    80003cde:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ce2:	6b85                	lui	s7,0x1
    80003ce4:	c00b8b9b          	addiw	s7,s7,-1024
    80003ce8:	a899                	j	80003d3e <filewrite+0xfc>
    80003cea:	00090c1b          	sext.w	s8,s2
      begin_op();
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	85c080e7          	jalr	-1956(ra) # 8000354a <begin_op>
      ilock(f->ip);
    80003cf6:	6c88                	ld	a0,24(s1)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	e90080e7          	jalr	-368(ra) # 80002b88 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d00:	8762                	mv	a4,s8
    80003d02:	5494                	lw	a3,40(s1)
    80003d04:	01598633          	add	a2,s3,s5
    80003d08:	4585                	li	a1,1
    80003d0a:	6c88                	ld	a0,24(s1)
    80003d0c:	fffff097          	auipc	ra,0xfffff
    80003d10:	228080e7          	jalr	552(ra) # 80002f34 <writei>
    80003d14:	892a                	mv	s2,a0
    80003d16:	00a05563          	blez	a0,80003d20 <filewrite+0xde>
        f->off += r;
    80003d1a:	549c                	lw	a5,40(s1)
    80003d1c:	9fa9                	addw	a5,a5,a0
    80003d1e:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003d20:	6c88                	ld	a0,24(s1)
    80003d22:	fffff097          	auipc	ra,0xfffff
    80003d26:	f28080e7          	jalr	-216(ra) # 80002c4a <iunlock>
      end_op();
    80003d2a:	00000097          	auipc	ra,0x0
    80003d2e:	8a0080e7          	jalr	-1888(ra) # 800035ca <end_op>
      if(r != n1){
    80003d32:	012c1f63          	bne	s8,s2,80003d50 <filewrite+0x10e>
      i += r;
    80003d36:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80003d3a:	0149db63          	bge	s3,s4,80003d50 <filewrite+0x10e>
      int n1 = n - i;
    80003d3e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d42:	893e                	mv	s2,a5
    80003d44:	2781                	sext.w	a5,a5
    80003d46:	fafb52e3          	bge	s6,a5,80003cea <filewrite+0xa8>
    80003d4a:	895e                	mv	s2,s7
    80003d4c:	bf79                	j	80003cea <filewrite+0xa8>
    int i = 0;
    80003d4e:	4981                	li	s3,0
    ret = (i == n ? n : -1);
    80003d50:	8552                	mv	a0,s4
    80003d52:	f33a0de3          	beq	s4,s3,80003c8c <filewrite+0x4a>
    80003d56:	557d                	li	a0,-1
    80003d58:	bf15                	j	80003c8c <filewrite+0x4a>
    panic("filewrite");
    80003d5a:	00006517          	auipc	a0,0x6
    80003d5e:	92e50513          	addi	a0,a0,-1746 # 80009688 <syscalls+0x2a8>
    80003d62:	00003097          	auipc	ra,0x3
    80003d66:	f30080e7          	jalr	-208(ra) # 80006c92 <panic>
    return -1;
    80003d6a:	557d                	li	a0,-1
}
    80003d6c:	8082                	ret
      return -1;
    80003d6e:	557d                	li	a0,-1
    80003d70:	bf31                	j	80003c8c <filewrite+0x4a>
    80003d72:	557d                	li	a0,-1
    80003d74:	bf21                	j	80003c8c <filewrite+0x4a>

0000000080003d76 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d76:	7179                	addi	sp,sp,-48
    80003d78:	f406                	sd	ra,40(sp)
    80003d7a:	f022                	sd	s0,32(sp)
    80003d7c:	ec26                	sd	s1,24(sp)
    80003d7e:	e84a                	sd	s2,16(sp)
    80003d80:	e44e                	sd	s3,8(sp)
    80003d82:	e052                	sd	s4,0(sp)
    80003d84:	1800                	addi	s0,sp,48
    80003d86:	84aa                	mv	s1,a0
    80003d88:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d8a:	0005b023          	sd	zero,0(a1)
    80003d8e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	bc8080e7          	jalr	-1080(ra) # 8000395a <filealloc>
    80003d9a:	e088                	sd	a0,0(s1)
    80003d9c:	c551                	beqz	a0,80003e28 <pipealloc+0xb2>
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	bbc080e7          	jalr	-1092(ra) # 8000395a <filealloc>
    80003da6:	00aa3023          	sd	a0,0(s4)
    80003daa:	c92d                	beqz	a0,80003e1c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dac:	ffffc097          	auipc	ra,0xffffc
    80003db0:	36c080e7          	jalr	876(ra) # 80000118 <kalloc>
    80003db4:	892a                	mv	s2,a0
    80003db6:	c125                	beqz	a0,80003e16 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003db8:	4985                	li	s3,1
    80003dba:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dbe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dc2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dc6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dca:	00006597          	auipc	a1,0x6
    80003dce:	8ce58593          	addi	a1,a1,-1842 # 80009698 <syscalls+0x2b8>
    80003dd2:	00003097          	auipc	ra,0x3
    80003dd6:	37a080e7          	jalr	890(ra) # 8000714c <initlock>
  (*f0)->type = FD_PIPE;
    80003dda:	609c                	ld	a5,0(s1)
    80003ddc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003de0:	609c                	ld	a5,0(s1)
    80003de2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003de6:	609c                	ld	a5,0(s1)
    80003de8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dec:	609c                	ld	a5,0(s1)
    80003dee:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003df2:	000a3783          	ld	a5,0(s4)
    80003df6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dfa:	000a3783          	ld	a5,0(s4)
    80003dfe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e02:	000a3783          	ld	a5,0(s4)
    80003e06:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e0a:	000a3783          	ld	a5,0(s4)
    80003e0e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e12:	4501                	li	a0,0
    80003e14:	a025                	j	80003e3c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e16:	6088                	ld	a0,0(s1)
    80003e18:	e501                	bnez	a0,80003e20 <pipealloc+0xaa>
    80003e1a:	a039                	j	80003e28 <pipealloc+0xb2>
    80003e1c:	6088                	ld	a0,0(s1)
    80003e1e:	c51d                	beqz	a0,80003e4c <pipealloc+0xd6>
    fileclose(*f0);
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	bf6080e7          	jalr	-1034(ra) # 80003a16 <fileclose>
  if(*f1)
    80003e28:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e2c:	557d                	li	a0,-1
  if(*f1)
    80003e2e:	c799                	beqz	a5,80003e3c <pipealloc+0xc6>
    fileclose(*f1);
    80003e30:	853e                	mv	a0,a5
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	be4080e7          	jalr	-1052(ra) # 80003a16 <fileclose>
  return -1;
    80003e3a:	557d                	li	a0,-1
}
    80003e3c:	70a2                	ld	ra,40(sp)
    80003e3e:	7402                	ld	s0,32(sp)
    80003e40:	64e2                	ld	s1,24(sp)
    80003e42:	6942                	ld	s2,16(sp)
    80003e44:	69a2                	ld	s3,8(sp)
    80003e46:	6a02                	ld	s4,0(sp)
    80003e48:	6145                	addi	sp,sp,48
    80003e4a:	8082                	ret
  return -1;
    80003e4c:	557d                	li	a0,-1
    80003e4e:	b7fd                	j	80003e3c <pipealloc+0xc6>

0000000080003e50 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e50:	1101                	addi	sp,sp,-32
    80003e52:	ec06                	sd	ra,24(sp)
    80003e54:	e822                	sd	s0,16(sp)
    80003e56:	e426                	sd	s1,8(sp)
    80003e58:	e04a                	sd	s2,0(sp)
    80003e5a:	1000                	addi	s0,sp,32
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e60:	00003097          	auipc	ra,0x3
    80003e64:	37c080e7          	jalr	892(ra) # 800071dc <acquire>
  if(writable){
    80003e68:	02090d63          	beqz	s2,80003ea2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e6c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e70:	21848513          	addi	a0,s1,536
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	780080e7          	jalr	1920(ra) # 800015f4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e7c:	2204b783          	ld	a5,544(s1)
    80003e80:	eb95                	bnez	a5,80003eb4 <pipeclose+0x64>
    release(&pi->lock);
    80003e82:	8526                	mv	a0,s1
    80003e84:	00003097          	auipc	ra,0x3
    80003e88:	40c080e7          	jalr	1036(ra) # 80007290 <release>
    kfree((char*)pi);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	ffffc097          	auipc	ra,0xffffc
    80003e92:	18e080e7          	jalr	398(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e96:	60e2                	ld	ra,24(sp)
    80003e98:	6442                	ld	s0,16(sp)
    80003e9a:	64a2                	ld	s1,8(sp)
    80003e9c:	6902                	ld	s2,0(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret
    pi->readopen = 0;
    80003ea2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ea6:	21c48513          	addi	a0,s1,540
    80003eaa:	ffffd097          	auipc	ra,0xffffd
    80003eae:	74a080e7          	jalr	1866(ra) # 800015f4 <wakeup>
    80003eb2:	b7e9                	j	80003e7c <pipeclose+0x2c>
    release(&pi->lock);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	00003097          	auipc	ra,0x3
    80003eba:	3da080e7          	jalr	986(ra) # 80007290 <release>
}
    80003ebe:	bfe1                	j	80003e96 <pipeclose+0x46>

0000000080003ec0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ec0:	7159                	addi	sp,sp,-112
    80003ec2:	f486                	sd	ra,104(sp)
    80003ec4:	f0a2                	sd	s0,96(sp)
    80003ec6:	eca6                	sd	s1,88(sp)
    80003ec8:	e8ca                	sd	s2,80(sp)
    80003eca:	e4ce                	sd	s3,72(sp)
    80003ecc:	e0d2                	sd	s4,64(sp)
    80003ece:	fc56                	sd	s5,56(sp)
    80003ed0:	f85a                	sd	s6,48(sp)
    80003ed2:	f45e                	sd	s7,40(sp)
    80003ed4:	f062                	sd	s8,32(sp)
    80003ed6:	ec66                	sd	s9,24(sp)
    80003ed8:	1880                	addi	s0,sp,112
    80003eda:	84aa                	mv	s1,a0
    80003edc:	8aae                	mv	s5,a1
    80003ede:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ee0:	ffffd097          	auipc	ra,0xffffd
    80003ee4:	008080e7          	jalr	8(ra) # 80000ee8 <myproc>
    80003ee8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eea:	8526                	mv	a0,s1
    80003eec:	00003097          	auipc	ra,0x3
    80003ef0:	2f0080e7          	jalr	752(ra) # 800071dc <acquire>
  while(i < n){
    80003ef4:	0d405463          	blez	s4,80003fbc <pipewrite+0xfc>
    80003ef8:	8ba6                	mv	s7,s1
  int i = 0;
    80003efa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003efc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003efe:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f02:	21c48c13          	addi	s8,s1,540
    80003f06:	a08d                	j	80003f68 <pipewrite+0xa8>
      release(&pi->lock);
    80003f08:	8526                	mv	a0,s1
    80003f0a:	00003097          	auipc	ra,0x3
    80003f0e:	386080e7          	jalr	902(ra) # 80007290 <release>
      return -1;
    80003f12:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f14:	854a                	mv	a0,s2
    80003f16:	70a6                	ld	ra,104(sp)
    80003f18:	7406                	ld	s0,96(sp)
    80003f1a:	64e6                	ld	s1,88(sp)
    80003f1c:	6946                	ld	s2,80(sp)
    80003f1e:	69a6                	ld	s3,72(sp)
    80003f20:	6a06                	ld	s4,64(sp)
    80003f22:	7ae2                	ld	s5,56(sp)
    80003f24:	7b42                	ld	s6,48(sp)
    80003f26:	7ba2                	ld	s7,40(sp)
    80003f28:	7c02                	ld	s8,32(sp)
    80003f2a:	6ce2                	ld	s9,24(sp)
    80003f2c:	6165                	addi	sp,sp,112
    80003f2e:	8082                	ret
      wakeup(&pi->nread);
    80003f30:	8566                	mv	a0,s9
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	6c2080e7          	jalr	1730(ra) # 800015f4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f3a:	85de                	mv	a1,s7
    80003f3c:	8562                	mv	a0,s8
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	652080e7          	jalr	1618(ra) # 80001590 <sleep>
    80003f46:	a839                	j	80003f64 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f48:	21c4a783          	lw	a5,540(s1)
    80003f4c:	0017871b          	addiw	a4,a5,1
    80003f50:	20e4ae23          	sw	a4,540(s1)
    80003f54:	1ff7f793          	andi	a5,a5,511
    80003f58:	97a6                	add	a5,a5,s1
    80003f5a:	f9f44703          	lbu	a4,-97(s0)
    80003f5e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f62:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f64:	05495063          	bge	s2,s4,80003fa4 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003f68:	2204a783          	lw	a5,544(s1)
    80003f6c:	dfd1                	beqz	a5,80003f08 <pipewrite+0x48>
    80003f6e:	854e                	mv	a0,s3
    80003f70:	ffffe097          	auipc	ra,0xffffe
    80003f74:	8c8080e7          	jalr	-1848(ra) # 80001838 <killed>
    80003f78:	f941                	bnez	a0,80003f08 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f7a:	2184a783          	lw	a5,536(s1)
    80003f7e:	21c4a703          	lw	a4,540(s1)
    80003f82:	2007879b          	addiw	a5,a5,512
    80003f86:	faf705e3          	beq	a4,a5,80003f30 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f8a:	4685                	li	a3,1
    80003f8c:	01590633          	add	a2,s2,s5
    80003f90:	f9f40593          	addi	a1,s0,-97
    80003f94:	0509b503          	ld	a0,80(s3)
    80003f98:	ffffd097          	auipc	ra,0xffffd
    80003f9c:	c9e080e7          	jalr	-866(ra) # 80000c36 <copyin>
    80003fa0:	fb6514e3          	bne	a0,s6,80003f48 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fa4:	21848513          	addi	a0,s1,536
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	64c080e7          	jalr	1612(ra) # 800015f4 <wakeup>
  release(&pi->lock);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	00003097          	auipc	ra,0x3
    80003fb6:	2de080e7          	jalr	734(ra) # 80007290 <release>
  return i;
    80003fba:	bfa9                	j	80003f14 <pipewrite+0x54>
  int i = 0;
    80003fbc:	4901                	li	s2,0
    80003fbe:	b7dd                	j	80003fa4 <pipewrite+0xe4>

0000000080003fc0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fc0:	715d                	addi	sp,sp,-80
    80003fc2:	e486                	sd	ra,72(sp)
    80003fc4:	e0a2                	sd	s0,64(sp)
    80003fc6:	fc26                	sd	s1,56(sp)
    80003fc8:	f84a                	sd	s2,48(sp)
    80003fca:	f44e                	sd	s3,40(sp)
    80003fcc:	f052                	sd	s4,32(sp)
    80003fce:	ec56                	sd	s5,24(sp)
    80003fd0:	e85a                	sd	s6,16(sp)
    80003fd2:	0880                	addi	s0,sp,80
    80003fd4:	84aa                	mv	s1,a0
    80003fd6:	892e                	mv	s2,a1
    80003fd8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	f0e080e7          	jalr	-242(ra) # 80000ee8 <myproc>
    80003fe2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe4:	8b26                	mv	s6,s1
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	00003097          	auipc	ra,0x3
    80003fec:	1f4080e7          	jalr	500(ra) # 800071dc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff0:	2184a703          	lw	a4,536(s1)
    80003ff4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffc:	02f71763          	bne	a4,a5,8000402a <piperead+0x6a>
    80004000:	2244a783          	lw	a5,548(s1)
    80004004:	c39d                	beqz	a5,8000402a <piperead+0x6a>
    if(killed(pr)){
    80004006:	8552                	mv	a0,s4
    80004008:	ffffe097          	auipc	ra,0xffffe
    8000400c:	830080e7          	jalr	-2000(ra) # 80001838 <killed>
    80004010:	e941                	bnez	a0,800040a0 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004012:	85da                	mv	a1,s6
    80004014:	854e                	mv	a0,s3
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	57a080e7          	jalr	1402(ra) # 80001590 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401e:	2184a703          	lw	a4,536(s1)
    80004022:	21c4a783          	lw	a5,540(s1)
    80004026:	fcf70de3          	beq	a4,a5,80004000 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000402a:	09505263          	blez	s5,800040ae <piperead+0xee>
    8000402e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004030:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004032:	2184a783          	lw	a5,536(s1)
    80004036:	21c4a703          	lw	a4,540(s1)
    8000403a:	02f70d63          	beq	a4,a5,80004074 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000403e:	0017871b          	addiw	a4,a5,1
    80004042:	20e4ac23          	sw	a4,536(s1)
    80004046:	1ff7f793          	andi	a5,a5,511
    8000404a:	97a6                	add	a5,a5,s1
    8000404c:	0187c783          	lbu	a5,24(a5)
    80004050:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004054:	4685                	li	a3,1
    80004056:	fbf40613          	addi	a2,s0,-65
    8000405a:	85ca                	mv	a1,s2
    8000405c:	050a3503          	ld	a0,80(s4)
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	b12080e7          	jalr	-1262(ra) # 80000b72 <copyout>
    80004068:	01650663          	beq	a0,s6,80004074 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000406c:	2985                	addiw	s3,s3,1
    8000406e:	0905                	addi	s2,s2,1
    80004070:	fd3a91e3          	bne	s5,s3,80004032 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004074:	21c48513          	addi	a0,s1,540
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	57c080e7          	jalr	1404(ra) # 800015f4 <wakeup>
  release(&pi->lock);
    80004080:	8526                	mv	a0,s1
    80004082:	00003097          	auipc	ra,0x3
    80004086:	20e080e7          	jalr	526(ra) # 80007290 <release>
  return i;
}
    8000408a:	854e                	mv	a0,s3
    8000408c:	60a6                	ld	ra,72(sp)
    8000408e:	6406                	ld	s0,64(sp)
    80004090:	74e2                	ld	s1,56(sp)
    80004092:	7942                	ld	s2,48(sp)
    80004094:	79a2                	ld	s3,40(sp)
    80004096:	7a02                	ld	s4,32(sp)
    80004098:	6ae2                	ld	s5,24(sp)
    8000409a:	6b42                	ld	s6,16(sp)
    8000409c:	6161                	addi	sp,sp,80
    8000409e:	8082                	ret
      release(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00003097          	auipc	ra,0x3
    800040a6:	1ee080e7          	jalr	494(ra) # 80007290 <release>
      return -1;
    800040aa:	59fd                	li	s3,-1
    800040ac:	bff9                	j	8000408a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ae:	4981                	li	s3,0
    800040b0:	b7d1                	j	80004074 <piperead+0xb4>

00000000800040b2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040b2:	1141                	addi	sp,sp,-16
    800040b4:	e422                	sd	s0,8(sp)
    800040b6:	0800                	addi	s0,sp,16
    800040b8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040ba:	8905                	andi	a0,a0,1
    800040bc:	c111                	beqz	a0,800040c0 <flags2perm+0xe>
      perm = PTE_X;
    800040be:	4521                	li	a0,8
    if(flags & 0x2)
    800040c0:	8b89                	andi	a5,a5,2
    800040c2:	c399                	beqz	a5,800040c8 <flags2perm+0x16>
      perm |= PTE_W;
    800040c4:	00456513          	ori	a0,a0,4
    return perm;
}
    800040c8:	6422                	ld	s0,8(sp)
    800040ca:	0141                	addi	sp,sp,16
    800040cc:	8082                	ret

00000000800040ce <exec>:

int
exec(char *path, char **argv)
{
    800040ce:	df010113          	addi	sp,sp,-528
    800040d2:	20113423          	sd	ra,520(sp)
    800040d6:	20813023          	sd	s0,512(sp)
    800040da:	ffa6                	sd	s1,504(sp)
    800040dc:	fbca                	sd	s2,496(sp)
    800040de:	f7ce                	sd	s3,488(sp)
    800040e0:	f3d2                	sd	s4,480(sp)
    800040e2:	efd6                	sd	s5,472(sp)
    800040e4:	ebda                	sd	s6,464(sp)
    800040e6:	e7de                	sd	s7,456(sp)
    800040e8:	e3e2                	sd	s8,448(sp)
    800040ea:	ff66                	sd	s9,440(sp)
    800040ec:	fb6a                	sd	s10,432(sp)
    800040ee:	f76e                	sd	s11,424(sp)
    800040f0:	0c00                	addi	s0,sp,528
    800040f2:	84aa                	mv	s1,a0
    800040f4:	dea43c23          	sd	a0,-520(s0)
    800040f8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	dec080e7          	jalr	-532(ra) # 80000ee8 <myproc>
    80004104:	892a                	mv	s2,a0

  begin_op();
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	444080e7          	jalr	1092(ra) # 8000354a <begin_op>

  if((ip = namei(path)) == 0){
    8000410e:	8526                	mv	a0,s1
    80004110:	fffff097          	auipc	ra,0xfffff
    80004114:	21e080e7          	jalr	542(ra) # 8000332e <namei>
    80004118:	c92d                	beqz	a0,8000418a <exec+0xbc>
    8000411a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	a6c080e7          	jalr	-1428(ra) # 80002b88 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004124:	04000713          	li	a4,64
    80004128:	4681                	li	a3,0
    8000412a:	e5040613          	addi	a2,s0,-432
    8000412e:	4581                	li	a1,0
    80004130:	8526                	mv	a0,s1
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	d0a080e7          	jalr	-758(ra) # 80002e3c <readi>
    8000413a:	04000793          	li	a5,64
    8000413e:	00f51a63          	bne	a0,a5,80004152 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004142:	e5042703          	lw	a4,-432(s0)
    80004146:	464c47b7          	lui	a5,0x464c4
    8000414a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000414e:	04f70463          	beq	a4,a5,80004196 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004152:	8526                	mv	a0,s1
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	c96080e7          	jalr	-874(ra) # 80002dea <iunlockput>
    end_op();
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	46e080e7          	jalr	1134(ra) # 800035ca <end_op>
  }
  return -1;
    80004164:	557d                	li	a0,-1
}
    80004166:	20813083          	ld	ra,520(sp)
    8000416a:	20013403          	ld	s0,512(sp)
    8000416e:	74fe                	ld	s1,504(sp)
    80004170:	795e                	ld	s2,496(sp)
    80004172:	79be                	ld	s3,488(sp)
    80004174:	7a1e                	ld	s4,480(sp)
    80004176:	6afe                	ld	s5,472(sp)
    80004178:	6b5e                	ld	s6,464(sp)
    8000417a:	6bbe                	ld	s7,456(sp)
    8000417c:	6c1e                	ld	s8,448(sp)
    8000417e:	7cfa                	ld	s9,440(sp)
    80004180:	7d5a                	ld	s10,432(sp)
    80004182:	7dba                	ld	s11,424(sp)
    80004184:	21010113          	addi	sp,sp,528
    80004188:	8082                	ret
    end_op();
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	440080e7          	jalr	1088(ra) # 800035ca <end_op>
    return -1;
    80004192:	557d                	li	a0,-1
    80004194:	bfc9                	j	80004166 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004196:	854a                	mv	a0,s2
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	e18080e7          	jalr	-488(ra) # 80000fb0 <proc_pagetable>
    800041a0:	8baa                	mv	s7,a0
    800041a2:	d945                	beqz	a0,80004152 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a4:	e7042983          	lw	s3,-400(s0)
    800041a8:	e8845783          	lhu	a5,-376(s0)
    800041ac:	c7ad                	beqz	a5,80004216 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ae:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b0:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800041b2:	6c85                	lui	s9,0x1
    800041b4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041b8:	def43823          	sd	a5,-528(s0)
    800041bc:	ac0d                	j	800043ee <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041be:	00005517          	auipc	a0,0x5
    800041c2:	4e250513          	addi	a0,a0,1250 # 800096a0 <syscalls+0x2c0>
    800041c6:	00003097          	auipc	ra,0x3
    800041ca:	acc080e7          	jalr	-1332(ra) # 80006c92 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ce:	8756                	mv	a4,s5
    800041d0:	012d86bb          	addw	a3,s11,s2
    800041d4:	4581                	li	a1,0
    800041d6:	8526                	mv	a0,s1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	c64080e7          	jalr	-924(ra) # 80002e3c <readi>
    800041e0:	2501                	sext.w	a0,a0
    800041e2:	1aaa9a63          	bne	s5,a0,80004396 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800041e6:	6785                	lui	a5,0x1
    800041e8:	0127893b          	addw	s2,a5,s2
    800041ec:	77fd                	lui	a5,0xfffff
    800041ee:	01478a3b          	addw	s4,a5,s4
    800041f2:	1f897563          	bgeu	s2,s8,800043dc <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800041f6:	02091593          	slli	a1,s2,0x20
    800041fa:	9181                	srli	a1,a1,0x20
    800041fc:	95ea                	add	a1,a1,s10
    800041fe:	855e                	mv	a0,s7
    80004200:	ffffc097          	auipc	ra,0xffffc
    80004204:	322080e7          	jalr	802(ra) # 80000522 <walkaddr>
    80004208:	862a                	mv	a2,a0
    if(pa == 0)
    8000420a:	d955                	beqz	a0,800041be <exec+0xf0>
      n = PGSIZE;
    8000420c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000420e:	fd9a70e3          	bgeu	s4,s9,800041ce <exec+0x100>
      n = sz - i;
    80004212:	8ad2                	mv	s5,s4
    80004214:	bf6d                	j	800041ce <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004216:	4a01                	li	s4,0
  iunlockput(ip);
    80004218:	8526                	mv	a0,s1
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	bd0080e7          	jalr	-1072(ra) # 80002dea <iunlockput>
  end_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	3a8080e7          	jalr	936(ra) # 800035ca <end_op>
  p = myproc();
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	cbe080e7          	jalr	-834(ra) # 80000ee8 <myproc>
    80004232:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004234:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004238:	6785                	lui	a5,0x1
    8000423a:	17fd                	addi	a5,a5,-1
    8000423c:	9a3e                	add	s4,s4,a5
    8000423e:	757d                	lui	a0,0xfffff
    80004240:	00aa77b3          	and	a5,s4,a0
    80004244:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004248:	4691                	li	a3,4
    8000424a:	6609                	lui	a2,0x2
    8000424c:	963e                	add	a2,a2,a5
    8000424e:	85be                	mv	a1,a5
    80004250:	855e                	mv	a0,s7
    80004252:	ffffc097          	auipc	ra,0xffffc
    80004256:	6c8080e7          	jalr	1736(ra) # 8000091a <uvmalloc>
    8000425a:	8b2a                	mv	s6,a0
  ip = 0;
    8000425c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000425e:	12050c63          	beqz	a0,80004396 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004262:	75f9                	lui	a1,0xffffe
    80004264:	95aa                	add	a1,a1,a0
    80004266:	855e                	mv	a0,s7
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	8d8080e7          	jalr	-1832(ra) # 80000b40 <uvmclear>
  stackbase = sp - PGSIZE;
    80004270:	7c7d                	lui	s8,0xfffff
    80004272:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004274:	e0043783          	ld	a5,-512(s0)
    80004278:	6388                	ld	a0,0(a5)
    8000427a:	c535                	beqz	a0,800042e6 <exec+0x218>
    8000427c:	e9040993          	addi	s3,s0,-368
    80004280:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004284:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004286:	ffffc097          	auipc	ra,0xffffc
    8000428a:	076080e7          	jalr	118(ra) # 800002fc <strlen>
    8000428e:	2505                	addiw	a0,a0,1
    80004290:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004294:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004298:	13896663          	bltu	s2,s8,800043c4 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000429c:	e0043d83          	ld	s11,-512(s0)
    800042a0:	000dba03          	ld	s4,0(s11)
    800042a4:	8552                	mv	a0,s4
    800042a6:	ffffc097          	auipc	ra,0xffffc
    800042aa:	056080e7          	jalr	86(ra) # 800002fc <strlen>
    800042ae:	0015069b          	addiw	a3,a0,1
    800042b2:	8652                	mv	a2,s4
    800042b4:	85ca                	mv	a1,s2
    800042b6:	855e                	mv	a0,s7
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	8ba080e7          	jalr	-1862(ra) # 80000b72 <copyout>
    800042c0:	10054663          	bltz	a0,800043cc <exec+0x2fe>
    ustack[argc] = sp;
    800042c4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042c8:	0485                	addi	s1,s1,1
    800042ca:	008d8793          	addi	a5,s11,8
    800042ce:	e0f43023          	sd	a5,-512(s0)
    800042d2:	008db503          	ld	a0,8(s11)
    800042d6:	c911                	beqz	a0,800042ea <exec+0x21c>
    if(argc >= MAXARG)
    800042d8:	09a1                	addi	s3,s3,8
    800042da:	fb3c96e3          	bne	s9,s3,80004286 <exec+0x1b8>
  sz = sz1;
    800042de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042e2:	4481                	li	s1,0
    800042e4:	a84d                	j	80004396 <exec+0x2c8>
  sp = sz;
    800042e6:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042e8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042ea:	00349793          	slli	a5,s1,0x3
    800042ee:	f9040713          	addi	a4,s0,-112
    800042f2:	97ba                	add	a5,a5,a4
    800042f4:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042f8:	00148693          	addi	a3,s1,1
    800042fc:	068e                	slli	a3,a3,0x3
    800042fe:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004302:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004306:	01897663          	bgeu	s2,s8,80004312 <exec+0x244>
  sz = sz1;
    8000430a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000430e:	4481                	li	s1,0
    80004310:	a059                	j	80004396 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004312:	e9040613          	addi	a2,s0,-368
    80004316:	85ca                	mv	a1,s2
    80004318:	855e                	mv	a0,s7
    8000431a:	ffffd097          	auipc	ra,0xffffd
    8000431e:	858080e7          	jalr	-1960(ra) # 80000b72 <copyout>
    80004322:	0a054963          	bltz	a0,800043d4 <exec+0x306>
  p->trapframe->a1 = sp;
    80004326:	058ab783          	ld	a5,88(s5)
    8000432a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000432e:	df843783          	ld	a5,-520(s0)
    80004332:	0007c703          	lbu	a4,0(a5)
    80004336:	cf11                	beqz	a4,80004352 <exec+0x284>
    80004338:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000433a:	02f00693          	li	a3,47
    8000433e:	a039                	j	8000434c <exec+0x27e>
      last = s+1;
    80004340:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004344:	0785                	addi	a5,a5,1
    80004346:	fff7c703          	lbu	a4,-1(a5)
    8000434a:	c701                	beqz	a4,80004352 <exec+0x284>
    if(*s == '/')
    8000434c:	fed71ce3          	bne	a4,a3,80004344 <exec+0x276>
    80004350:	bfc5                	j	80004340 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004352:	4641                	li	a2,16
    80004354:	df843583          	ld	a1,-520(s0)
    80004358:	158a8513          	addi	a0,s5,344
    8000435c:	ffffc097          	auipc	ra,0xffffc
    80004360:	f6e080e7          	jalr	-146(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004364:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004368:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000436c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004370:	058ab783          	ld	a5,88(s5)
    80004374:	e6843703          	ld	a4,-408(s0)
    80004378:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000437a:	058ab783          	ld	a5,88(s5)
    8000437e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004382:	85ea                	mv	a1,s10
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	cc8080e7          	jalr	-824(ra) # 8000104c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000438c:	0004851b          	sext.w	a0,s1
    80004390:	bbd9                	j	80004166 <exec+0x98>
    80004392:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004396:	e0843583          	ld	a1,-504(s0)
    8000439a:	855e                	mv	a0,s7
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	cb0080e7          	jalr	-848(ra) # 8000104c <proc_freepagetable>
  if(ip){
    800043a4:	da0497e3          	bnez	s1,80004152 <exec+0x84>
  return -1;
    800043a8:	557d                	li	a0,-1
    800043aa:	bb75                	j	80004166 <exec+0x98>
    800043ac:	e1443423          	sd	s4,-504(s0)
    800043b0:	b7dd                	j	80004396 <exec+0x2c8>
    800043b2:	e1443423          	sd	s4,-504(s0)
    800043b6:	b7c5                	j	80004396 <exec+0x2c8>
    800043b8:	e1443423          	sd	s4,-504(s0)
    800043bc:	bfe9                	j	80004396 <exec+0x2c8>
    800043be:	e1443423          	sd	s4,-504(s0)
    800043c2:	bfd1                	j	80004396 <exec+0x2c8>
  sz = sz1;
    800043c4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c8:	4481                	li	s1,0
    800043ca:	b7f1                	j	80004396 <exec+0x2c8>
  sz = sz1;
    800043cc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d0:	4481                	li	s1,0
    800043d2:	b7d1                	j	80004396 <exec+0x2c8>
  sz = sz1;
    800043d4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d8:	4481                	li	s1,0
    800043da:	bf75                	j	80004396 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043dc:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e0:	2b05                	addiw	s6,s6,1
    800043e2:	0389899b          	addiw	s3,s3,56
    800043e6:	e8845783          	lhu	a5,-376(s0)
    800043ea:	e2fb57e3          	bge	s6,a5,80004218 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043ee:	2981                	sext.w	s3,s3
    800043f0:	03800713          	li	a4,56
    800043f4:	86ce                	mv	a3,s3
    800043f6:	e1840613          	addi	a2,s0,-488
    800043fa:	4581                	li	a1,0
    800043fc:	8526                	mv	a0,s1
    800043fe:	fffff097          	auipc	ra,0xfffff
    80004402:	a3e080e7          	jalr	-1474(ra) # 80002e3c <readi>
    80004406:	03800793          	li	a5,56
    8000440a:	f8f514e3          	bne	a0,a5,80004392 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    8000440e:	e1842783          	lw	a5,-488(s0)
    80004412:	4705                	li	a4,1
    80004414:	fce796e3          	bne	a5,a4,800043e0 <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004418:	e4043903          	ld	s2,-448(s0)
    8000441c:	e3843783          	ld	a5,-456(s0)
    80004420:	f8f966e3          	bltu	s2,a5,800043ac <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004424:	e2843783          	ld	a5,-472(s0)
    80004428:	993e                	add	s2,s2,a5
    8000442a:	f8f964e3          	bltu	s2,a5,800043b2 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    8000442e:	df043703          	ld	a4,-528(s0)
    80004432:	8ff9                	and	a5,a5,a4
    80004434:	f3d1                	bnez	a5,800043b8 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004436:	e1c42503          	lw	a0,-484(s0)
    8000443a:	00000097          	auipc	ra,0x0
    8000443e:	c78080e7          	jalr	-904(ra) # 800040b2 <flags2perm>
    80004442:	86aa                	mv	a3,a0
    80004444:	864a                	mv	a2,s2
    80004446:	85d2                	mv	a1,s4
    80004448:	855e                	mv	a0,s7
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	4d0080e7          	jalr	1232(ra) # 8000091a <uvmalloc>
    80004452:	e0a43423          	sd	a0,-504(s0)
    80004456:	d525                	beqz	a0,800043be <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004458:	e2843d03          	ld	s10,-472(s0)
    8000445c:	e2042d83          	lw	s11,-480(s0)
    80004460:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004464:	f60c0ce3          	beqz	s8,800043dc <exec+0x30e>
    80004468:	8a62                	mv	s4,s8
    8000446a:	4901                	li	s2,0
    8000446c:	b369                	j	800041f6 <exec+0x128>

000000008000446e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000446e:	7179                	addi	sp,sp,-48
    80004470:	f406                	sd	ra,40(sp)
    80004472:	f022                	sd	s0,32(sp)
    80004474:	ec26                	sd	s1,24(sp)
    80004476:	e84a                	sd	s2,16(sp)
    80004478:	1800                	addi	s0,sp,48
    8000447a:	892e                	mv	s2,a1
    8000447c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000447e:	fdc40593          	addi	a1,s0,-36
    80004482:	ffffe097          	auipc	ra,0xffffe
    80004486:	b8c080e7          	jalr	-1140(ra) # 8000200e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000448a:	fdc42703          	lw	a4,-36(s0)
    8000448e:	47bd                	li	a5,15
    80004490:	02e7eb63          	bltu	a5,a4,800044c6 <argfd+0x58>
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	a54080e7          	jalr	-1452(ra) # 80000ee8 <myproc>
    8000449c:	fdc42703          	lw	a4,-36(s0)
    800044a0:	01a70793          	addi	a5,a4,26
    800044a4:	078e                	slli	a5,a5,0x3
    800044a6:	953e                	add	a0,a0,a5
    800044a8:	611c                	ld	a5,0(a0)
    800044aa:	c385                	beqz	a5,800044ca <argfd+0x5c>
    return -1;
  if(pfd)
    800044ac:	00090463          	beqz	s2,800044b4 <argfd+0x46>
    *pfd = fd;
    800044b0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044b4:	4501                	li	a0,0
  if(pf)
    800044b6:	c091                	beqz	s1,800044ba <argfd+0x4c>
    *pf = f;
    800044b8:	e09c                	sd	a5,0(s1)
}
    800044ba:	70a2                	ld	ra,40(sp)
    800044bc:	7402                	ld	s0,32(sp)
    800044be:	64e2                	ld	s1,24(sp)
    800044c0:	6942                	ld	s2,16(sp)
    800044c2:	6145                	addi	sp,sp,48
    800044c4:	8082                	ret
    return -1;
    800044c6:	557d                	li	a0,-1
    800044c8:	bfcd                	j	800044ba <argfd+0x4c>
    800044ca:	557d                	li	a0,-1
    800044cc:	b7fd                	j	800044ba <argfd+0x4c>

00000000800044ce <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ce:	1101                	addi	sp,sp,-32
    800044d0:	ec06                	sd	ra,24(sp)
    800044d2:	e822                	sd	s0,16(sp)
    800044d4:	e426                	sd	s1,8(sp)
    800044d6:	1000                	addi	s0,sp,32
    800044d8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	a0e080e7          	jalr	-1522(ra) # 80000ee8 <myproc>
    800044e2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044e4:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdbc70>
    800044e8:	4501                	li	a0,0
    800044ea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044ec:	6398                	ld	a4,0(a5)
    800044ee:	cb19                	beqz	a4,80004504 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044f0:	2505                	addiw	a0,a0,1
    800044f2:	07a1                	addi	a5,a5,8
    800044f4:	fed51ce3          	bne	a0,a3,800044ec <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044f8:	557d                	li	a0,-1
}
    800044fa:	60e2                	ld	ra,24(sp)
    800044fc:	6442                	ld	s0,16(sp)
    800044fe:	64a2                	ld	s1,8(sp)
    80004500:	6105                	addi	sp,sp,32
    80004502:	8082                	ret
      p->ofile[fd] = f;
    80004504:	01a50793          	addi	a5,a0,26
    80004508:	078e                	slli	a5,a5,0x3
    8000450a:	963e                	add	a2,a2,a5
    8000450c:	e204                	sd	s1,0(a2)
      return fd;
    8000450e:	b7f5                	j	800044fa <fdalloc+0x2c>

0000000080004510 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004510:	715d                	addi	sp,sp,-80
    80004512:	e486                	sd	ra,72(sp)
    80004514:	e0a2                	sd	s0,64(sp)
    80004516:	fc26                	sd	s1,56(sp)
    80004518:	f84a                	sd	s2,48(sp)
    8000451a:	f44e                	sd	s3,40(sp)
    8000451c:	f052                	sd	s4,32(sp)
    8000451e:	ec56                	sd	s5,24(sp)
    80004520:	e85a                	sd	s6,16(sp)
    80004522:	0880                	addi	s0,sp,80
    80004524:	8b2e                	mv	s6,a1
    80004526:	89b2                	mv	s3,a2
    80004528:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000452a:	fb040593          	addi	a1,s0,-80
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	e1e080e7          	jalr	-482(ra) # 8000334c <nameiparent>
    80004536:	84aa                	mv	s1,a0
    80004538:	16050063          	beqz	a0,80004698 <create+0x188>
    return 0;

  ilock(dp);
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	64c080e7          	jalr	1612(ra) # 80002b88 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004544:	4601                	li	a2,0
    80004546:	fb040593          	addi	a1,s0,-80
    8000454a:	8526                	mv	a0,s1
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	b20080e7          	jalr	-1248(ra) # 8000306c <dirlookup>
    80004554:	8aaa                	mv	s5,a0
    80004556:	c931                	beqz	a0,800045aa <create+0x9a>
    iunlockput(dp);
    80004558:	8526                	mv	a0,s1
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	890080e7          	jalr	-1904(ra) # 80002dea <iunlockput>
    ilock(ip);
    80004562:	8556                	mv	a0,s5
    80004564:	ffffe097          	auipc	ra,0xffffe
    80004568:	624080e7          	jalr	1572(ra) # 80002b88 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000456c:	000b059b          	sext.w	a1,s6
    80004570:	4789                	li	a5,2
    80004572:	02f59563          	bne	a1,a5,8000459c <create+0x8c>
    80004576:	044ad783          	lhu	a5,68(s5)
    8000457a:	37f9                	addiw	a5,a5,-2
    8000457c:	17c2                	slli	a5,a5,0x30
    8000457e:	93c1                	srli	a5,a5,0x30
    80004580:	4705                	li	a4,1
    80004582:	00f76d63          	bltu	a4,a5,8000459c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004586:	8556                	mv	a0,s5
    80004588:	60a6                	ld	ra,72(sp)
    8000458a:	6406                	ld	s0,64(sp)
    8000458c:	74e2                	ld	s1,56(sp)
    8000458e:	7942                	ld	s2,48(sp)
    80004590:	79a2                	ld	s3,40(sp)
    80004592:	7a02                	ld	s4,32(sp)
    80004594:	6ae2                	ld	s5,24(sp)
    80004596:	6b42                	ld	s6,16(sp)
    80004598:	6161                	addi	sp,sp,80
    8000459a:	8082                	ret
    iunlockput(ip);
    8000459c:	8556                	mv	a0,s5
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	84c080e7          	jalr	-1972(ra) # 80002dea <iunlockput>
    return 0;
    800045a6:	4a81                	li	s5,0
    800045a8:	bff9                	j	80004586 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045aa:	85da                	mv	a1,s6
    800045ac:	4088                	lw	a0,0(s1)
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	43e080e7          	jalr	1086(ra) # 800029ec <ialloc>
    800045b6:	8a2a                	mv	s4,a0
    800045b8:	c921                	beqz	a0,80004608 <create+0xf8>
  ilock(ip);
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	5ce080e7          	jalr	1486(ra) # 80002b88 <ilock>
  ip->major = major;
    800045c2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045c6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045ca:	4785                	li	a5,1
    800045cc:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800045d0:	8552                	mv	a0,s4
    800045d2:	ffffe097          	auipc	ra,0xffffe
    800045d6:	4ec080e7          	jalr	1260(ra) # 80002abe <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045da:	000b059b          	sext.w	a1,s6
    800045de:	4785                	li	a5,1
    800045e0:	02f58b63          	beq	a1,a5,80004616 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e4:	004a2603          	lw	a2,4(s4)
    800045e8:	fb040593          	addi	a1,s0,-80
    800045ec:	8526                	mv	a0,s1
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	c8e080e7          	jalr	-882(ra) # 8000327c <dirlink>
    800045f6:	06054f63          	bltz	a0,80004674 <create+0x164>
  iunlockput(dp);
    800045fa:	8526                	mv	a0,s1
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	7ee080e7          	jalr	2030(ra) # 80002dea <iunlockput>
  return ip;
    80004604:	8ad2                	mv	s5,s4
    80004606:	b741                	j	80004586 <create+0x76>
    iunlockput(dp);
    80004608:	8526                	mv	a0,s1
    8000460a:	ffffe097          	auipc	ra,0xffffe
    8000460e:	7e0080e7          	jalr	2016(ra) # 80002dea <iunlockput>
    return 0;
    80004612:	8ad2                	mv	s5,s4
    80004614:	bf8d                	j	80004586 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004616:	004a2603          	lw	a2,4(s4)
    8000461a:	00005597          	auipc	a1,0x5
    8000461e:	0a658593          	addi	a1,a1,166 # 800096c0 <syscalls+0x2e0>
    80004622:	8552                	mv	a0,s4
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	c58080e7          	jalr	-936(ra) # 8000327c <dirlink>
    8000462c:	04054463          	bltz	a0,80004674 <create+0x164>
    80004630:	40d0                	lw	a2,4(s1)
    80004632:	00005597          	auipc	a1,0x5
    80004636:	09658593          	addi	a1,a1,150 # 800096c8 <syscalls+0x2e8>
    8000463a:	8552                	mv	a0,s4
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	c40080e7          	jalr	-960(ra) # 8000327c <dirlink>
    80004644:	02054863          	bltz	a0,80004674 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004648:	004a2603          	lw	a2,4(s4)
    8000464c:	fb040593          	addi	a1,s0,-80
    80004650:	8526                	mv	a0,s1
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	c2a080e7          	jalr	-982(ra) # 8000327c <dirlink>
    8000465a:	00054d63          	bltz	a0,80004674 <create+0x164>
    dp->nlink++;  // for ".."
    8000465e:	04a4d783          	lhu	a5,74(s1)
    80004662:	2785                	addiw	a5,a5,1
    80004664:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004668:	8526                	mv	a0,s1
    8000466a:	ffffe097          	auipc	ra,0xffffe
    8000466e:	454080e7          	jalr	1108(ra) # 80002abe <iupdate>
    80004672:	b761                	j	800045fa <create+0xea>
  ip->nlink = 0;
    80004674:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004678:	8552                	mv	a0,s4
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	444080e7          	jalr	1092(ra) # 80002abe <iupdate>
  iunlockput(ip);
    80004682:	8552                	mv	a0,s4
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	766080e7          	jalr	1894(ra) # 80002dea <iunlockput>
  iunlockput(dp);
    8000468c:	8526                	mv	a0,s1
    8000468e:	ffffe097          	auipc	ra,0xffffe
    80004692:	75c080e7          	jalr	1884(ra) # 80002dea <iunlockput>
  return 0;
    80004696:	bdc5                	j	80004586 <create+0x76>
    return 0;
    80004698:	8aaa                	mv	s5,a0
    8000469a:	b5f5                	j	80004586 <create+0x76>

000000008000469c <sys_dup>:
{
    8000469c:	7179                	addi	sp,sp,-48
    8000469e:	f406                	sd	ra,40(sp)
    800046a0:	f022                	sd	s0,32(sp)
    800046a2:	ec26                	sd	s1,24(sp)
    800046a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046a6:	fd840613          	addi	a2,s0,-40
    800046aa:	4581                	li	a1,0
    800046ac:	4501                	li	a0,0
    800046ae:	00000097          	auipc	ra,0x0
    800046b2:	dc0080e7          	jalr	-576(ra) # 8000446e <argfd>
    return -1;
    800046b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046b8:	02054363          	bltz	a0,800046de <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046bc:	fd843503          	ld	a0,-40(s0)
    800046c0:	00000097          	auipc	ra,0x0
    800046c4:	e0e080e7          	jalr	-498(ra) # 800044ce <fdalloc>
    800046c8:	84aa                	mv	s1,a0
    return -1;
    800046ca:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046cc:	00054963          	bltz	a0,800046de <sys_dup+0x42>
  filedup(f);
    800046d0:	fd843503          	ld	a0,-40(s0)
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	2f0080e7          	jalr	752(ra) # 800039c4 <filedup>
  return fd;
    800046dc:	87a6                	mv	a5,s1
}
    800046de:	853e                	mv	a0,a5
    800046e0:	70a2                	ld	ra,40(sp)
    800046e2:	7402                	ld	s0,32(sp)
    800046e4:	64e2                	ld	s1,24(sp)
    800046e6:	6145                	addi	sp,sp,48
    800046e8:	8082                	ret

00000000800046ea <sys_read>:
{
    800046ea:	7179                	addi	sp,sp,-48
    800046ec:	f406                	sd	ra,40(sp)
    800046ee:	f022                	sd	s0,32(sp)
    800046f0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046f2:	fd840593          	addi	a1,s0,-40
    800046f6:	4505                	li	a0,1
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	936080e7          	jalr	-1738(ra) # 8000202e <argaddr>
  argint(2, &n);
    80004700:	fe440593          	addi	a1,s0,-28
    80004704:	4509                	li	a0,2
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	908080e7          	jalr	-1784(ra) # 8000200e <argint>
  if(argfd(0, 0, &f) < 0)
    8000470e:	fe840613          	addi	a2,s0,-24
    80004712:	4581                	li	a1,0
    80004714:	4501                	li	a0,0
    80004716:	00000097          	auipc	ra,0x0
    8000471a:	d58080e7          	jalr	-680(ra) # 8000446e <argfd>
    8000471e:	87aa                	mv	a5,a0
    return -1;
    80004720:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004722:	0007cc63          	bltz	a5,8000473a <sys_read+0x50>
  return fileread(f, p, n);
    80004726:	fe442603          	lw	a2,-28(s0)
    8000472a:	fd843583          	ld	a1,-40(s0)
    8000472e:	fe843503          	ld	a0,-24(s0)
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	43a080e7          	jalr	1082(ra) # 80003b6c <fileread>
}
    8000473a:	70a2                	ld	ra,40(sp)
    8000473c:	7402                	ld	s0,32(sp)
    8000473e:	6145                	addi	sp,sp,48
    80004740:	8082                	ret

0000000080004742 <sys_write>:
{
    80004742:	7179                	addi	sp,sp,-48
    80004744:	f406                	sd	ra,40(sp)
    80004746:	f022                	sd	s0,32(sp)
    80004748:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000474a:	fd840593          	addi	a1,s0,-40
    8000474e:	4505                	li	a0,1
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	8de080e7          	jalr	-1826(ra) # 8000202e <argaddr>
  argint(2, &n);
    80004758:	fe440593          	addi	a1,s0,-28
    8000475c:	4509                	li	a0,2
    8000475e:	ffffe097          	auipc	ra,0xffffe
    80004762:	8b0080e7          	jalr	-1872(ra) # 8000200e <argint>
  if(argfd(0, 0, &f) < 0)
    80004766:	fe840613          	addi	a2,s0,-24
    8000476a:	4581                	li	a1,0
    8000476c:	4501                	li	a0,0
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	d00080e7          	jalr	-768(ra) # 8000446e <argfd>
    80004776:	87aa                	mv	a5,a0
    return -1;
    80004778:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000477a:	0007cc63          	bltz	a5,80004792 <sys_write+0x50>
  return filewrite(f, p, n);
    8000477e:	fe442603          	lw	a2,-28(s0)
    80004782:	fd843583          	ld	a1,-40(s0)
    80004786:	fe843503          	ld	a0,-24(s0)
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	4b8080e7          	jalr	1208(ra) # 80003c42 <filewrite>
}
    80004792:	70a2                	ld	ra,40(sp)
    80004794:	7402                	ld	s0,32(sp)
    80004796:	6145                	addi	sp,sp,48
    80004798:	8082                	ret

000000008000479a <sys_close>:
{
    8000479a:	1101                	addi	sp,sp,-32
    8000479c:	ec06                	sd	ra,24(sp)
    8000479e:	e822                	sd	s0,16(sp)
    800047a0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047a2:	fe040613          	addi	a2,s0,-32
    800047a6:	fec40593          	addi	a1,s0,-20
    800047aa:	4501                	li	a0,0
    800047ac:	00000097          	auipc	ra,0x0
    800047b0:	cc2080e7          	jalr	-830(ra) # 8000446e <argfd>
    return -1;
    800047b4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047b6:	02054463          	bltz	a0,800047de <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ba:	ffffc097          	auipc	ra,0xffffc
    800047be:	72e080e7          	jalr	1838(ra) # 80000ee8 <myproc>
    800047c2:	fec42783          	lw	a5,-20(s0)
    800047c6:	07e9                	addi	a5,a5,26
    800047c8:	078e                	slli	a5,a5,0x3
    800047ca:	97aa                	add	a5,a5,a0
    800047cc:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047d0:	fe043503          	ld	a0,-32(s0)
    800047d4:	fffff097          	auipc	ra,0xfffff
    800047d8:	242080e7          	jalr	578(ra) # 80003a16 <fileclose>
  return 0;
    800047dc:	4781                	li	a5,0
}
    800047de:	853e                	mv	a0,a5
    800047e0:	60e2                	ld	ra,24(sp)
    800047e2:	6442                	ld	s0,16(sp)
    800047e4:	6105                	addi	sp,sp,32
    800047e6:	8082                	ret

00000000800047e8 <sys_fstat>:
{
    800047e8:	1101                	addi	sp,sp,-32
    800047ea:	ec06                	sd	ra,24(sp)
    800047ec:	e822                	sd	s0,16(sp)
    800047ee:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800047f0:	fe040593          	addi	a1,s0,-32
    800047f4:	4505                	li	a0,1
    800047f6:	ffffe097          	auipc	ra,0xffffe
    800047fa:	838080e7          	jalr	-1992(ra) # 8000202e <argaddr>
  if(argfd(0, 0, &f) < 0)
    800047fe:	fe840613          	addi	a2,s0,-24
    80004802:	4581                	li	a1,0
    80004804:	4501                	li	a0,0
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	c68080e7          	jalr	-920(ra) # 8000446e <argfd>
    8000480e:	87aa                	mv	a5,a0
    return -1;
    80004810:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004812:	0007ca63          	bltz	a5,80004826 <sys_fstat+0x3e>
  return filestat(f, st);
    80004816:	fe043583          	ld	a1,-32(s0)
    8000481a:	fe843503          	ld	a0,-24(s0)
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	2dc080e7          	jalr	732(ra) # 80003afa <filestat>
}
    80004826:	60e2                	ld	ra,24(sp)
    80004828:	6442                	ld	s0,16(sp)
    8000482a:	6105                	addi	sp,sp,32
    8000482c:	8082                	ret

000000008000482e <sys_link>:
{
    8000482e:	7169                	addi	sp,sp,-304
    80004830:	f606                	sd	ra,296(sp)
    80004832:	f222                	sd	s0,288(sp)
    80004834:	ee26                	sd	s1,280(sp)
    80004836:	ea4a                	sd	s2,272(sp)
    80004838:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000483a:	08000613          	li	a2,128
    8000483e:	ed040593          	addi	a1,s0,-304
    80004842:	4501                	li	a0,0
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	80a080e7          	jalr	-2038(ra) # 8000204e <argstr>
    return -1;
    8000484c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484e:	10054e63          	bltz	a0,8000496a <sys_link+0x13c>
    80004852:	08000613          	li	a2,128
    80004856:	f5040593          	addi	a1,s0,-176
    8000485a:	4505                	li	a0,1
    8000485c:	ffffd097          	auipc	ra,0xffffd
    80004860:	7f2080e7          	jalr	2034(ra) # 8000204e <argstr>
    return -1;
    80004864:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004866:	10054263          	bltz	a0,8000496a <sys_link+0x13c>
  begin_op();
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	ce0080e7          	jalr	-800(ra) # 8000354a <begin_op>
  if((ip = namei(old)) == 0){
    80004872:	ed040513          	addi	a0,s0,-304
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	ab8080e7          	jalr	-1352(ra) # 8000332e <namei>
    8000487e:	84aa                	mv	s1,a0
    80004880:	c551                	beqz	a0,8000490c <sys_link+0xde>
  ilock(ip);
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	306080e7          	jalr	774(ra) # 80002b88 <ilock>
  if(ip->type == T_DIR){
    8000488a:	04449703          	lh	a4,68(s1)
    8000488e:	4785                	li	a5,1
    80004890:	08f70463          	beq	a4,a5,80004918 <sys_link+0xea>
  ip->nlink++;
    80004894:	04a4d783          	lhu	a5,74(s1)
    80004898:	2785                	addiw	a5,a5,1
    8000489a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000489e:	8526                	mv	a0,s1
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	21e080e7          	jalr	542(ra) # 80002abe <iupdate>
  iunlock(ip);
    800048a8:	8526                	mv	a0,s1
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	3a0080e7          	jalr	928(ra) # 80002c4a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048b2:	fd040593          	addi	a1,s0,-48
    800048b6:	f5040513          	addi	a0,s0,-176
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	a92080e7          	jalr	-1390(ra) # 8000334c <nameiparent>
    800048c2:	892a                	mv	s2,a0
    800048c4:	c935                	beqz	a0,80004938 <sys_link+0x10a>
  ilock(dp);
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	2c2080e7          	jalr	706(ra) # 80002b88 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048ce:	00092703          	lw	a4,0(s2)
    800048d2:	409c                	lw	a5,0(s1)
    800048d4:	04f71d63          	bne	a4,a5,8000492e <sys_link+0x100>
    800048d8:	40d0                	lw	a2,4(s1)
    800048da:	fd040593          	addi	a1,s0,-48
    800048de:	854a                	mv	a0,s2
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	99c080e7          	jalr	-1636(ra) # 8000327c <dirlink>
    800048e8:	04054363          	bltz	a0,8000492e <sys_link+0x100>
  iunlockput(dp);
    800048ec:	854a                	mv	a0,s2
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	4fc080e7          	jalr	1276(ra) # 80002dea <iunlockput>
  iput(ip);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	44a080e7          	jalr	1098(ra) # 80002d42 <iput>
  end_op();
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	cca080e7          	jalr	-822(ra) # 800035ca <end_op>
  return 0;
    80004908:	4781                	li	a5,0
    8000490a:	a085                	j	8000496a <sys_link+0x13c>
    end_op();
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	cbe080e7          	jalr	-834(ra) # 800035ca <end_op>
    return -1;
    80004914:	57fd                	li	a5,-1
    80004916:	a891                	j	8000496a <sys_link+0x13c>
    iunlockput(ip);
    80004918:	8526                	mv	a0,s1
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	4d0080e7          	jalr	1232(ra) # 80002dea <iunlockput>
    end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	ca8080e7          	jalr	-856(ra) # 800035ca <end_op>
    return -1;
    8000492a:	57fd                	li	a5,-1
    8000492c:	a83d                	j	8000496a <sys_link+0x13c>
    iunlockput(dp);
    8000492e:	854a                	mv	a0,s2
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	4ba080e7          	jalr	1210(ra) # 80002dea <iunlockput>
  ilock(ip);
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	24e080e7          	jalr	590(ra) # 80002b88 <ilock>
  ip->nlink--;
    80004942:	04a4d783          	lhu	a5,74(s1)
    80004946:	37fd                	addiw	a5,a5,-1
    80004948:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	170080e7          	jalr	368(ra) # 80002abe <iupdate>
  iunlockput(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	492080e7          	jalr	1170(ra) # 80002dea <iunlockput>
  end_op();
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	c6a080e7          	jalr	-918(ra) # 800035ca <end_op>
  return -1;
    80004968:	57fd                	li	a5,-1
}
    8000496a:	853e                	mv	a0,a5
    8000496c:	70b2                	ld	ra,296(sp)
    8000496e:	7412                	ld	s0,288(sp)
    80004970:	64f2                	ld	s1,280(sp)
    80004972:	6952                	ld	s2,272(sp)
    80004974:	6155                	addi	sp,sp,304
    80004976:	8082                	ret

0000000080004978 <sys_unlink>:
{
    80004978:	7151                	addi	sp,sp,-240
    8000497a:	f586                	sd	ra,232(sp)
    8000497c:	f1a2                	sd	s0,224(sp)
    8000497e:	eda6                	sd	s1,216(sp)
    80004980:	e9ca                	sd	s2,208(sp)
    80004982:	e5ce                	sd	s3,200(sp)
    80004984:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004986:	08000613          	li	a2,128
    8000498a:	f3040593          	addi	a1,s0,-208
    8000498e:	4501                	li	a0,0
    80004990:	ffffd097          	auipc	ra,0xffffd
    80004994:	6be080e7          	jalr	1726(ra) # 8000204e <argstr>
    80004998:	18054163          	bltz	a0,80004b1a <sys_unlink+0x1a2>
  begin_op();
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	bae080e7          	jalr	-1106(ra) # 8000354a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049a4:	fb040593          	addi	a1,s0,-80
    800049a8:	f3040513          	addi	a0,s0,-208
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	9a0080e7          	jalr	-1632(ra) # 8000334c <nameiparent>
    800049b4:	84aa                	mv	s1,a0
    800049b6:	c979                	beqz	a0,80004a8c <sys_unlink+0x114>
  ilock(dp);
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	1d0080e7          	jalr	464(ra) # 80002b88 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049c0:	00005597          	auipc	a1,0x5
    800049c4:	d0058593          	addi	a1,a1,-768 # 800096c0 <syscalls+0x2e0>
    800049c8:	fb040513          	addi	a0,s0,-80
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	686080e7          	jalr	1670(ra) # 80003052 <namecmp>
    800049d4:	14050a63          	beqz	a0,80004b28 <sys_unlink+0x1b0>
    800049d8:	00005597          	auipc	a1,0x5
    800049dc:	cf058593          	addi	a1,a1,-784 # 800096c8 <syscalls+0x2e8>
    800049e0:	fb040513          	addi	a0,s0,-80
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	66e080e7          	jalr	1646(ra) # 80003052 <namecmp>
    800049ec:	12050e63          	beqz	a0,80004b28 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049f0:	f2c40613          	addi	a2,s0,-212
    800049f4:	fb040593          	addi	a1,s0,-80
    800049f8:	8526                	mv	a0,s1
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	672080e7          	jalr	1650(ra) # 8000306c <dirlookup>
    80004a02:	892a                	mv	s2,a0
    80004a04:	12050263          	beqz	a0,80004b28 <sys_unlink+0x1b0>
  ilock(ip);
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	180080e7          	jalr	384(ra) # 80002b88 <ilock>
  if(ip->nlink < 1)
    80004a10:	04a91783          	lh	a5,74(s2)
    80004a14:	08f05263          	blez	a5,80004a98 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a18:	04491703          	lh	a4,68(s2)
    80004a1c:	4785                	li	a5,1
    80004a1e:	08f70563          	beq	a4,a5,80004aa8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a22:	4641                	li	a2,16
    80004a24:	4581                	li	a1,0
    80004a26:	fc040513          	addi	a0,s0,-64
    80004a2a:	ffffb097          	auipc	ra,0xffffb
    80004a2e:	74e080e7          	jalr	1870(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a32:	4741                	li	a4,16
    80004a34:	f2c42683          	lw	a3,-212(s0)
    80004a38:	fc040613          	addi	a2,s0,-64
    80004a3c:	4581                	li	a1,0
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	4f4080e7          	jalr	1268(ra) # 80002f34 <writei>
    80004a48:	47c1                	li	a5,16
    80004a4a:	0af51563          	bne	a0,a5,80004af4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a4e:	04491703          	lh	a4,68(s2)
    80004a52:	4785                	li	a5,1
    80004a54:	0af70863          	beq	a4,a5,80004b04 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	390080e7          	jalr	912(ra) # 80002dea <iunlockput>
  ip->nlink--;
    80004a62:	04a95783          	lhu	a5,74(s2)
    80004a66:	37fd                	addiw	a5,a5,-1
    80004a68:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	050080e7          	jalr	80(ra) # 80002abe <iupdate>
  iunlockput(ip);
    80004a76:	854a                	mv	a0,s2
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	372080e7          	jalr	882(ra) # 80002dea <iunlockput>
  end_op();
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	b4a080e7          	jalr	-1206(ra) # 800035ca <end_op>
  return 0;
    80004a88:	4501                	li	a0,0
    80004a8a:	a84d                	j	80004b3c <sys_unlink+0x1c4>
    end_op();
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	b3e080e7          	jalr	-1218(ra) # 800035ca <end_op>
    return -1;
    80004a94:	557d                	li	a0,-1
    80004a96:	a05d                	j	80004b3c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a98:	00005517          	auipc	a0,0x5
    80004a9c:	c3850513          	addi	a0,a0,-968 # 800096d0 <syscalls+0x2f0>
    80004aa0:	00002097          	auipc	ra,0x2
    80004aa4:	1f2080e7          	jalr	498(ra) # 80006c92 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa8:	04c92703          	lw	a4,76(s2)
    80004aac:	02000793          	li	a5,32
    80004ab0:	f6e7f9e3          	bgeu	a5,a4,80004a22 <sys_unlink+0xaa>
    80004ab4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab8:	4741                	li	a4,16
    80004aba:	86ce                	mv	a3,s3
    80004abc:	f1840613          	addi	a2,s0,-232
    80004ac0:	4581                	li	a1,0
    80004ac2:	854a                	mv	a0,s2
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	378080e7          	jalr	888(ra) # 80002e3c <readi>
    80004acc:	47c1                	li	a5,16
    80004ace:	00f51b63          	bne	a0,a5,80004ae4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ad2:	f1845783          	lhu	a5,-232(s0)
    80004ad6:	e7a1                	bnez	a5,80004b1e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ad8:	29c1                	addiw	s3,s3,16
    80004ada:	04c92783          	lw	a5,76(s2)
    80004ade:	fcf9ede3          	bltu	s3,a5,80004ab8 <sys_unlink+0x140>
    80004ae2:	b781                	j	80004a22 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ae4:	00005517          	auipc	a0,0x5
    80004ae8:	c0450513          	addi	a0,a0,-1020 # 800096e8 <syscalls+0x308>
    80004aec:	00002097          	auipc	ra,0x2
    80004af0:	1a6080e7          	jalr	422(ra) # 80006c92 <panic>
    panic("unlink: writei");
    80004af4:	00005517          	auipc	a0,0x5
    80004af8:	c0c50513          	addi	a0,a0,-1012 # 80009700 <syscalls+0x320>
    80004afc:	00002097          	auipc	ra,0x2
    80004b00:	196080e7          	jalr	406(ra) # 80006c92 <panic>
    dp->nlink--;
    80004b04:	04a4d783          	lhu	a5,74(s1)
    80004b08:	37fd                	addiw	a5,a5,-1
    80004b0a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	fae080e7          	jalr	-82(ra) # 80002abe <iupdate>
    80004b18:	b781                	j	80004a58 <sys_unlink+0xe0>
    return -1;
    80004b1a:	557d                	li	a0,-1
    80004b1c:	a005                	j	80004b3c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b1e:	854a                	mv	a0,s2
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	2ca080e7          	jalr	714(ra) # 80002dea <iunlockput>
  iunlockput(dp);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	2c0080e7          	jalr	704(ra) # 80002dea <iunlockput>
  end_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	a98080e7          	jalr	-1384(ra) # 800035ca <end_op>
  return -1;
    80004b3a:	557d                	li	a0,-1
}
    80004b3c:	70ae                	ld	ra,232(sp)
    80004b3e:	740e                	ld	s0,224(sp)
    80004b40:	64ee                	ld	s1,216(sp)
    80004b42:	694e                	ld	s2,208(sp)
    80004b44:	69ae                	ld	s3,200(sp)
    80004b46:	616d                	addi	sp,sp,240
    80004b48:	8082                	ret

0000000080004b4a <sys_open>:

uint64
sys_open(void)
{
    80004b4a:	7131                	addi	sp,sp,-192
    80004b4c:	fd06                	sd	ra,184(sp)
    80004b4e:	f922                	sd	s0,176(sp)
    80004b50:	f526                	sd	s1,168(sp)
    80004b52:	f14a                	sd	s2,160(sp)
    80004b54:	ed4e                	sd	s3,152(sp)
    80004b56:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b58:	f4c40593          	addi	a1,s0,-180
    80004b5c:	4505                	li	a0,1
    80004b5e:	ffffd097          	auipc	ra,0xffffd
    80004b62:	4b0080e7          	jalr	1200(ra) # 8000200e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b66:	08000613          	li	a2,128
    80004b6a:	f5040593          	addi	a1,s0,-176
    80004b6e:	4501                	li	a0,0
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	4de080e7          	jalr	1246(ra) # 8000204e <argstr>
    80004b78:	87aa                	mv	a5,a0
    return -1;
    80004b7a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b7c:	0a07c963          	bltz	a5,80004c2e <sys_open+0xe4>

  begin_op();
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	9ca080e7          	jalr	-1590(ra) # 8000354a <begin_op>

  if(omode & O_CREATE){
    80004b88:	f4c42783          	lw	a5,-180(s0)
    80004b8c:	2007f793          	andi	a5,a5,512
    80004b90:	cfc5                	beqz	a5,80004c48 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b92:	4681                	li	a3,0
    80004b94:	4601                	li	a2,0
    80004b96:	4589                	li	a1,2
    80004b98:	f5040513          	addi	a0,s0,-176
    80004b9c:	00000097          	auipc	ra,0x0
    80004ba0:	974080e7          	jalr	-1676(ra) # 80004510 <create>
    80004ba4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ba6:	c959                	beqz	a0,80004c3c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ba8:	04449703          	lh	a4,68(s1)
    80004bac:	478d                	li	a5,3
    80004bae:	00f71763          	bne	a4,a5,80004bbc <sys_open+0x72>
    80004bb2:	0464d703          	lhu	a4,70(s1)
    80004bb6:	47a5                	li	a5,9
    80004bb8:	0ce7ed63          	bltu	a5,a4,80004c92 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	d9e080e7          	jalr	-610(ra) # 8000395a <filealloc>
    80004bc4:	89aa                	mv	s3,a0
    80004bc6:	10050363          	beqz	a0,80004ccc <sys_open+0x182>
    80004bca:	00000097          	auipc	ra,0x0
    80004bce:	904080e7          	jalr	-1788(ra) # 800044ce <fdalloc>
    80004bd2:	892a                	mv	s2,a0
    80004bd4:	0e054763          	bltz	a0,80004cc2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bd8:	04449703          	lh	a4,68(s1)
    80004bdc:	478d                	li	a5,3
    80004bde:	0cf70563          	beq	a4,a5,80004ca8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004be2:	4789                	li	a5,2
    80004be4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004be8:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004bec:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bf0:	f4c42783          	lw	a5,-180(s0)
    80004bf4:	0017c713          	xori	a4,a5,1
    80004bf8:	8b05                	andi	a4,a4,1
    80004bfa:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bfe:	0037f713          	andi	a4,a5,3
    80004c02:	00e03733          	snez	a4,a4
    80004c06:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c0a:	4007f793          	andi	a5,a5,1024
    80004c0e:	c791                	beqz	a5,80004c1a <sys_open+0xd0>
    80004c10:	04449703          	lh	a4,68(s1)
    80004c14:	4789                	li	a5,2
    80004c16:	0af70063          	beq	a4,a5,80004cb6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	02e080e7          	jalr	46(ra) # 80002c4a <iunlock>
  end_op();
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	9a6080e7          	jalr	-1626(ra) # 800035ca <end_op>

  return fd;
    80004c2c:	854a                	mv	a0,s2
}
    80004c2e:	70ea                	ld	ra,184(sp)
    80004c30:	744a                	ld	s0,176(sp)
    80004c32:	74aa                	ld	s1,168(sp)
    80004c34:	790a                	ld	s2,160(sp)
    80004c36:	69ea                	ld	s3,152(sp)
    80004c38:	6129                	addi	sp,sp,192
    80004c3a:	8082                	ret
      end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	98e080e7          	jalr	-1650(ra) # 800035ca <end_op>
      return -1;
    80004c44:	557d                	li	a0,-1
    80004c46:	b7e5                	j	80004c2e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c48:	f5040513          	addi	a0,s0,-176
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	6e2080e7          	jalr	1762(ra) # 8000332e <namei>
    80004c54:	84aa                	mv	s1,a0
    80004c56:	c905                	beqz	a0,80004c86 <sys_open+0x13c>
    ilock(ip);
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	f30080e7          	jalr	-208(ra) # 80002b88 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c60:	04449703          	lh	a4,68(s1)
    80004c64:	4785                	li	a5,1
    80004c66:	f4f711e3          	bne	a4,a5,80004ba8 <sys_open+0x5e>
    80004c6a:	f4c42783          	lw	a5,-180(s0)
    80004c6e:	d7b9                	beqz	a5,80004bbc <sys_open+0x72>
      iunlockput(ip);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	178080e7          	jalr	376(ra) # 80002dea <iunlockput>
      end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	950080e7          	jalr	-1712(ra) # 800035ca <end_op>
      return -1;
    80004c82:	557d                	li	a0,-1
    80004c84:	b76d                	j	80004c2e <sys_open+0xe4>
      end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	944080e7          	jalr	-1724(ra) # 800035ca <end_op>
      return -1;
    80004c8e:	557d                	li	a0,-1
    80004c90:	bf79                	j	80004c2e <sys_open+0xe4>
    iunlockput(ip);
    80004c92:	8526                	mv	a0,s1
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	156080e7          	jalr	342(ra) # 80002dea <iunlockput>
    end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	92e080e7          	jalr	-1746(ra) # 800035ca <end_op>
    return -1;
    80004ca4:	557d                	li	a0,-1
    80004ca6:	b761                	j	80004c2e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ca8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cac:	04649783          	lh	a5,70(s1)
    80004cb0:	02f99623          	sh	a5,44(s3)
    80004cb4:	bf25                	j	80004bec <sys_open+0xa2>
    itrunc(ip);
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	ffffe097          	auipc	ra,0xffffe
    80004cbc:	fde080e7          	jalr	-34(ra) # 80002c96 <itrunc>
    80004cc0:	bfa9                	j	80004c1a <sys_open+0xd0>
      fileclose(f);
    80004cc2:	854e                	mv	a0,s3
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	d52080e7          	jalr	-686(ra) # 80003a16 <fileclose>
    iunlockput(ip);
    80004ccc:	8526                	mv	a0,s1
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	11c080e7          	jalr	284(ra) # 80002dea <iunlockput>
    end_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	8f4080e7          	jalr	-1804(ra) # 800035ca <end_op>
    return -1;
    80004cde:	557d                	li	a0,-1
    80004ce0:	b7b9                	j	80004c2e <sys_open+0xe4>

0000000080004ce2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ce2:	7175                	addi	sp,sp,-144
    80004ce4:	e506                	sd	ra,136(sp)
    80004ce6:	e122                	sd	s0,128(sp)
    80004ce8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	860080e7          	jalr	-1952(ra) # 8000354a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cf2:	08000613          	li	a2,128
    80004cf6:	f7040593          	addi	a1,s0,-144
    80004cfa:	4501                	li	a0,0
    80004cfc:	ffffd097          	auipc	ra,0xffffd
    80004d00:	352080e7          	jalr	850(ra) # 8000204e <argstr>
    80004d04:	02054963          	bltz	a0,80004d36 <sys_mkdir+0x54>
    80004d08:	4681                	li	a3,0
    80004d0a:	4601                	li	a2,0
    80004d0c:	4585                	li	a1,1
    80004d0e:	f7040513          	addi	a0,s0,-144
    80004d12:	fffff097          	auipc	ra,0xfffff
    80004d16:	7fe080e7          	jalr	2046(ra) # 80004510 <create>
    80004d1a:	cd11                	beqz	a0,80004d36 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	0ce080e7          	jalr	206(ra) # 80002dea <iunlockput>
  end_op();
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	8a6080e7          	jalr	-1882(ra) # 800035ca <end_op>
  return 0;
    80004d2c:	4501                	li	a0,0
}
    80004d2e:	60aa                	ld	ra,136(sp)
    80004d30:	640a                	ld	s0,128(sp)
    80004d32:	6149                	addi	sp,sp,144
    80004d34:	8082                	ret
    end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	894080e7          	jalr	-1900(ra) # 800035ca <end_op>
    return -1;
    80004d3e:	557d                	li	a0,-1
    80004d40:	b7fd                	j	80004d2e <sys_mkdir+0x4c>

0000000080004d42 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d42:	7135                	addi	sp,sp,-160
    80004d44:	ed06                	sd	ra,152(sp)
    80004d46:	e922                	sd	s0,144(sp)
    80004d48:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	800080e7          	jalr	-2048(ra) # 8000354a <begin_op>
  argint(1, &major);
    80004d52:	f6c40593          	addi	a1,s0,-148
    80004d56:	4505                	li	a0,1
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	2b6080e7          	jalr	694(ra) # 8000200e <argint>
  argint(2, &minor);
    80004d60:	f6840593          	addi	a1,s0,-152
    80004d64:	4509                	li	a0,2
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	2a8080e7          	jalr	680(ra) # 8000200e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d6e:	08000613          	li	a2,128
    80004d72:	f7040593          	addi	a1,s0,-144
    80004d76:	4501                	li	a0,0
    80004d78:	ffffd097          	auipc	ra,0xffffd
    80004d7c:	2d6080e7          	jalr	726(ra) # 8000204e <argstr>
    80004d80:	02054b63          	bltz	a0,80004db6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d84:	f6841683          	lh	a3,-152(s0)
    80004d88:	f6c41603          	lh	a2,-148(s0)
    80004d8c:	458d                	li	a1,3
    80004d8e:	f7040513          	addi	a0,s0,-144
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	77e080e7          	jalr	1918(ra) # 80004510 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d9a:	cd11                	beqz	a0,80004db6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	04e080e7          	jalr	78(ra) # 80002dea <iunlockput>
  end_op();
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	826080e7          	jalr	-2010(ra) # 800035ca <end_op>
  return 0;
    80004dac:	4501                	li	a0,0
}
    80004dae:	60ea                	ld	ra,152(sp)
    80004db0:	644a                	ld	s0,144(sp)
    80004db2:	610d                	addi	sp,sp,160
    80004db4:	8082                	ret
    end_op();
    80004db6:	fffff097          	auipc	ra,0xfffff
    80004dba:	814080e7          	jalr	-2028(ra) # 800035ca <end_op>
    return -1;
    80004dbe:	557d                	li	a0,-1
    80004dc0:	b7fd                	j	80004dae <sys_mknod+0x6c>

0000000080004dc2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dc2:	7135                	addi	sp,sp,-160
    80004dc4:	ed06                	sd	ra,152(sp)
    80004dc6:	e922                	sd	s0,144(sp)
    80004dc8:	e526                	sd	s1,136(sp)
    80004dca:	e14a                	sd	s2,128(sp)
    80004dcc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dce:	ffffc097          	auipc	ra,0xffffc
    80004dd2:	11a080e7          	jalr	282(ra) # 80000ee8 <myproc>
    80004dd6:	892a                	mv	s2,a0
  
  begin_op();
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	772080e7          	jalr	1906(ra) # 8000354a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004de0:	08000613          	li	a2,128
    80004de4:	f6040593          	addi	a1,s0,-160
    80004de8:	4501                	li	a0,0
    80004dea:	ffffd097          	auipc	ra,0xffffd
    80004dee:	264080e7          	jalr	612(ra) # 8000204e <argstr>
    80004df2:	04054b63          	bltz	a0,80004e48 <sys_chdir+0x86>
    80004df6:	f6040513          	addi	a0,s0,-160
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	534080e7          	jalr	1332(ra) # 8000332e <namei>
    80004e02:	84aa                	mv	s1,a0
    80004e04:	c131                	beqz	a0,80004e48 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	d82080e7          	jalr	-638(ra) # 80002b88 <ilock>
  if(ip->type != T_DIR){
    80004e0e:	04449703          	lh	a4,68(s1)
    80004e12:	4785                	li	a5,1
    80004e14:	04f71063          	bne	a4,a5,80004e54 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e18:	8526                	mv	a0,s1
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	e30080e7          	jalr	-464(ra) # 80002c4a <iunlock>
  iput(p->cwd);
    80004e22:	15093503          	ld	a0,336(s2)
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	f1c080e7          	jalr	-228(ra) # 80002d42 <iput>
  end_op();
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	79c080e7          	jalr	1948(ra) # 800035ca <end_op>
  p->cwd = ip;
    80004e36:	14993823          	sd	s1,336(s2)
  return 0;
    80004e3a:	4501                	li	a0,0
}
    80004e3c:	60ea                	ld	ra,152(sp)
    80004e3e:	644a                	ld	s0,144(sp)
    80004e40:	64aa                	ld	s1,136(sp)
    80004e42:	690a                	ld	s2,128(sp)
    80004e44:	610d                	addi	sp,sp,160
    80004e46:	8082                	ret
    end_op();
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	782080e7          	jalr	1922(ra) # 800035ca <end_op>
    return -1;
    80004e50:	557d                	li	a0,-1
    80004e52:	b7ed                	j	80004e3c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e54:	8526                	mv	a0,s1
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	f94080e7          	jalr	-108(ra) # 80002dea <iunlockput>
    end_op();
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	76c080e7          	jalr	1900(ra) # 800035ca <end_op>
    return -1;
    80004e66:	557d                	li	a0,-1
    80004e68:	bfd1                	j	80004e3c <sys_chdir+0x7a>

0000000080004e6a <sys_exec>:

uint64
sys_exec(void)
{
    80004e6a:	7145                	addi	sp,sp,-464
    80004e6c:	e786                	sd	ra,456(sp)
    80004e6e:	e3a2                	sd	s0,448(sp)
    80004e70:	ff26                	sd	s1,440(sp)
    80004e72:	fb4a                	sd	s2,432(sp)
    80004e74:	f74e                	sd	s3,424(sp)
    80004e76:	f352                	sd	s4,416(sp)
    80004e78:	ef56                	sd	s5,408(sp)
    80004e7a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e7c:	e3840593          	addi	a1,s0,-456
    80004e80:	4505                	li	a0,1
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	1ac080e7          	jalr	428(ra) # 8000202e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e8a:	08000613          	li	a2,128
    80004e8e:	f4040593          	addi	a1,s0,-192
    80004e92:	4501                	li	a0,0
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	1ba080e7          	jalr	442(ra) # 8000204e <argstr>
    80004e9c:	87aa                	mv	a5,a0
    return -1;
    80004e9e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ea0:	0c07c263          	bltz	a5,80004f64 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ea4:	10000613          	li	a2,256
    80004ea8:	4581                	li	a1,0
    80004eaa:	e4040513          	addi	a0,s0,-448
    80004eae:	ffffb097          	auipc	ra,0xffffb
    80004eb2:	2ca080e7          	jalr	714(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eb6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eba:	89a6                	mv	s3,s1
    80004ebc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ebe:	02000a13          	li	s4,32
    80004ec2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ec6:	00391513          	slli	a0,s2,0x3
    80004eca:	e3040593          	addi	a1,s0,-464
    80004ece:	e3843783          	ld	a5,-456(s0)
    80004ed2:	953e                	add	a0,a0,a5
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	09c080e7          	jalr	156(ra) # 80001f70 <fetchaddr>
    80004edc:	02054a63          	bltz	a0,80004f10 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ee0:	e3043783          	ld	a5,-464(s0)
    80004ee4:	c3b9                	beqz	a5,80004f2a <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ee6:	ffffb097          	auipc	ra,0xffffb
    80004eea:	232080e7          	jalr	562(ra) # 80000118 <kalloc>
    80004eee:	85aa                	mv	a1,a0
    80004ef0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef4:	cd11                	beqz	a0,80004f10 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ef6:	6605                	lui	a2,0x1
    80004ef8:	e3043503          	ld	a0,-464(s0)
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	0c6080e7          	jalr	198(ra) # 80001fc2 <fetchstr>
    80004f04:	00054663          	bltz	a0,80004f10 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f08:	0905                	addi	s2,s2,1
    80004f0a:	09a1                	addi	s3,s3,8
    80004f0c:	fb491be3          	bne	s2,s4,80004ec2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f10:	10048913          	addi	s2,s1,256
    80004f14:	6088                	ld	a0,0(s1)
    80004f16:	c531                	beqz	a0,80004f62 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f18:	ffffb097          	auipc	ra,0xffffb
    80004f1c:	104080e7          	jalr	260(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f20:	04a1                	addi	s1,s1,8
    80004f22:	ff2499e3          	bne	s1,s2,80004f14 <sys_exec+0xaa>
  return -1;
    80004f26:	557d                	li	a0,-1
    80004f28:	a835                	j	80004f64 <sys_exec+0xfa>
      argv[i] = 0;
    80004f2a:	0a8e                	slli	s5,s5,0x3
    80004f2c:	fc040793          	addi	a5,s0,-64
    80004f30:	9abe                	add	s5,s5,a5
    80004f32:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f36:	e4040593          	addi	a1,s0,-448
    80004f3a:	f4040513          	addi	a0,s0,-192
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	190080e7          	jalr	400(ra) # 800040ce <exec>
    80004f46:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f48:	10048993          	addi	s3,s1,256
    80004f4c:	6088                	ld	a0,0(s1)
    80004f4e:	c901                	beqz	a0,80004f5e <sys_exec+0xf4>
    kfree(argv[i]);
    80004f50:	ffffb097          	auipc	ra,0xffffb
    80004f54:	0cc080e7          	jalr	204(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f58:	04a1                	addi	s1,s1,8
    80004f5a:	ff3499e3          	bne	s1,s3,80004f4c <sys_exec+0xe2>
  return ret;
    80004f5e:	854a                	mv	a0,s2
    80004f60:	a011                	j	80004f64 <sys_exec+0xfa>
  return -1;
    80004f62:	557d                	li	a0,-1
}
    80004f64:	60be                	ld	ra,456(sp)
    80004f66:	641e                	ld	s0,448(sp)
    80004f68:	74fa                	ld	s1,440(sp)
    80004f6a:	795a                	ld	s2,432(sp)
    80004f6c:	79ba                	ld	s3,424(sp)
    80004f6e:	7a1a                	ld	s4,416(sp)
    80004f70:	6afa                	ld	s5,408(sp)
    80004f72:	6179                	addi	sp,sp,464
    80004f74:	8082                	ret

0000000080004f76 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f76:	7139                	addi	sp,sp,-64
    80004f78:	fc06                	sd	ra,56(sp)
    80004f7a:	f822                	sd	s0,48(sp)
    80004f7c:	f426                	sd	s1,40(sp)
    80004f7e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	f68080e7          	jalr	-152(ra) # 80000ee8 <myproc>
    80004f88:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f8a:	fd840593          	addi	a1,s0,-40
    80004f8e:	4501                	li	a0,0
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	09e080e7          	jalr	158(ra) # 8000202e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f98:	fc840593          	addi	a1,s0,-56
    80004f9c:	fd040513          	addi	a0,s0,-48
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	dd6080e7          	jalr	-554(ra) # 80003d76 <pipealloc>
    return -1;
    80004fa8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004faa:	0c054463          	bltz	a0,80005072 <sys_pipe+0xfc>
  fd0 = -1;
    80004fae:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fb2:	fd043503          	ld	a0,-48(s0)
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	518080e7          	jalr	1304(ra) # 800044ce <fdalloc>
    80004fbe:	fca42223          	sw	a0,-60(s0)
    80004fc2:	08054b63          	bltz	a0,80005058 <sys_pipe+0xe2>
    80004fc6:	fc843503          	ld	a0,-56(s0)
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	504080e7          	jalr	1284(ra) # 800044ce <fdalloc>
    80004fd2:	fca42023          	sw	a0,-64(s0)
    80004fd6:	06054863          	bltz	a0,80005046 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fda:	4691                	li	a3,4
    80004fdc:	fc440613          	addi	a2,s0,-60
    80004fe0:	fd843583          	ld	a1,-40(s0)
    80004fe4:	68a8                	ld	a0,80(s1)
    80004fe6:	ffffc097          	auipc	ra,0xffffc
    80004fea:	b8c080e7          	jalr	-1140(ra) # 80000b72 <copyout>
    80004fee:	02054063          	bltz	a0,8000500e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ff2:	4691                	li	a3,4
    80004ff4:	fc040613          	addi	a2,s0,-64
    80004ff8:	fd843583          	ld	a1,-40(s0)
    80004ffc:	0591                	addi	a1,a1,4
    80004ffe:	68a8                	ld	a0,80(s1)
    80005000:	ffffc097          	auipc	ra,0xffffc
    80005004:	b72080e7          	jalr	-1166(ra) # 80000b72 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005008:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000500a:	06055463          	bgez	a0,80005072 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000500e:	fc442783          	lw	a5,-60(s0)
    80005012:	07e9                	addi	a5,a5,26
    80005014:	078e                	slli	a5,a5,0x3
    80005016:	97a6                	add	a5,a5,s1
    80005018:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000501c:	fc042503          	lw	a0,-64(s0)
    80005020:	0569                	addi	a0,a0,26
    80005022:	050e                	slli	a0,a0,0x3
    80005024:	94aa                	add	s1,s1,a0
    80005026:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000502a:	fd043503          	ld	a0,-48(s0)
    8000502e:	fffff097          	auipc	ra,0xfffff
    80005032:	9e8080e7          	jalr	-1560(ra) # 80003a16 <fileclose>
    fileclose(wf);
    80005036:	fc843503          	ld	a0,-56(s0)
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	9dc080e7          	jalr	-1572(ra) # 80003a16 <fileclose>
    return -1;
    80005042:	57fd                	li	a5,-1
    80005044:	a03d                	j	80005072 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005046:	fc442783          	lw	a5,-60(s0)
    8000504a:	0007c763          	bltz	a5,80005058 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000504e:	07e9                	addi	a5,a5,26
    80005050:	078e                	slli	a5,a5,0x3
    80005052:	94be                	add	s1,s1,a5
    80005054:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005058:	fd043503          	ld	a0,-48(s0)
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	9ba080e7          	jalr	-1606(ra) # 80003a16 <fileclose>
    fileclose(wf);
    80005064:	fc843503          	ld	a0,-56(s0)
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	9ae080e7          	jalr	-1618(ra) # 80003a16 <fileclose>
    return -1;
    80005070:	57fd                	li	a5,-1
}
    80005072:	853e                	mv	a0,a5
    80005074:	70e2                	ld	ra,56(sp)
    80005076:	7442                	ld	s0,48(sp)
    80005078:	74a2                	ld	s1,40(sp)
    8000507a:	6121                	addi	sp,sp,64
    8000507c:	8082                	ret

000000008000507e <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    8000507e:	7179                	addi	sp,sp,-48
    80005080:	f406                	sd	ra,40(sp)
    80005082:	f022                	sd	s0,32(sp)
    80005084:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  argint(0, (int*)&raddr);
    80005086:	fe440593          	addi	a1,s0,-28
    8000508a:	4501                	li	a0,0
    8000508c:	ffffd097          	auipc	ra,0xffffd
    80005090:	f82080e7          	jalr	-126(ra) # 8000200e <argint>
  argint(1, (int*)&lport);
    80005094:	fdc40593          	addi	a1,s0,-36
    80005098:	4505                	li	a0,1
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	f74080e7          	jalr	-140(ra) # 8000200e <argint>
  argint(2, (int*)&rport);
    800050a2:	fe040593          	addi	a1,s0,-32
    800050a6:	4509                	li	a0,2
    800050a8:	ffffd097          	auipc	ra,0xffffd
    800050ac:	f66080e7          	jalr	-154(ra) # 8000200e <argint>

  if(sockalloc(&f, raddr, lport, rport) < 0)
    800050b0:	fe045683          	lhu	a3,-32(s0)
    800050b4:	fdc45603          	lhu	a2,-36(s0)
    800050b8:	fe442583          	lw	a1,-28(s0)
    800050bc:	fe840513          	addi	a0,s0,-24
    800050c0:	00001097          	auipc	ra,0x1
    800050c4:	23a080e7          	jalr	570(ra) # 800062fa <sockalloc>
    800050c8:	02054663          	bltz	a0,800050f4 <sys_connect+0x76>
    return -1;
  if((fd=fdalloc(f)) < 0){
    800050cc:	fe843503          	ld	a0,-24(s0)
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	3fe080e7          	jalr	1022(ra) # 800044ce <fdalloc>
    800050d8:	00054663          	bltz	a0,800050e4 <sys_connect+0x66>
    fileclose(f);
    return -1;
  }

  return fd;
}
    800050dc:	70a2                	ld	ra,40(sp)
    800050de:	7402                	ld	s0,32(sp)
    800050e0:	6145                	addi	sp,sp,48
    800050e2:	8082                	ret
    fileclose(f);
    800050e4:	fe843503          	ld	a0,-24(s0)
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	92e080e7          	jalr	-1746(ra) # 80003a16 <fileclose>
    return -1;
    800050f0:	557d                	li	a0,-1
    800050f2:	b7ed                	j	800050dc <sys_connect+0x5e>
    return -1;
    800050f4:	557d                	li	a0,-1
    800050f6:	b7dd                	j	800050dc <sys_connect+0x5e>
	...

0000000080005100 <kernelvec>:
    80005100:	7111                	addi	sp,sp,-256
    80005102:	e006                	sd	ra,0(sp)
    80005104:	e40a                	sd	sp,8(sp)
    80005106:	e80e                	sd	gp,16(sp)
    80005108:	ec12                	sd	tp,24(sp)
    8000510a:	f016                	sd	t0,32(sp)
    8000510c:	f41a                	sd	t1,40(sp)
    8000510e:	f81e                	sd	t2,48(sp)
    80005110:	fc22                	sd	s0,56(sp)
    80005112:	e0a6                	sd	s1,64(sp)
    80005114:	e4aa                	sd	a0,72(sp)
    80005116:	e8ae                	sd	a1,80(sp)
    80005118:	ecb2                	sd	a2,88(sp)
    8000511a:	f0b6                	sd	a3,96(sp)
    8000511c:	f4ba                	sd	a4,104(sp)
    8000511e:	f8be                	sd	a5,112(sp)
    80005120:	fcc2                	sd	a6,120(sp)
    80005122:	e146                	sd	a7,128(sp)
    80005124:	e54a                	sd	s2,136(sp)
    80005126:	e94e                	sd	s3,144(sp)
    80005128:	ed52                	sd	s4,152(sp)
    8000512a:	f156                	sd	s5,160(sp)
    8000512c:	f55a                	sd	s6,168(sp)
    8000512e:	f95e                	sd	s7,176(sp)
    80005130:	fd62                	sd	s8,184(sp)
    80005132:	e1e6                	sd	s9,192(sp)
    80005134:	e5ea                	sd	s10,200(sp)
    80005136:	e9ee                	sd	s11,208(sp)
    80005138:	edf2                	sd	t3,216(sp)
    8000513a:	f1f6                	sd	t4,224(sp)
    8000513c:	f5fa                	sd	t5,232(sp)
    8000513e:	f9fe                	sd	t6,240(sp)
    80005140:	cfdfc0ef          	jal	ra,80001e3c <kerneltrap>
    80005144:	6082                	ld	ra,0(sp)
    80005146:	6122                	ld	sp,8(sp)
    80005148:	61c2                	ld	gp,16(sp)
    8000514a:	7282                	ld	t0,32(sp)
    8000514c:	7322                	ld	t1,40(sp)
    8000514e:	73c2                	ld	t2,48(sp)
    80005150:	7462                	ld	s0,56(sp)
    80005152:	6486                	ld	s1,64(sp)
    80005154:	6526                	ld	a0,72(sp)
    80005156:	65c6                	ld	a1,80(sp)
    80005158:	6666                	ld	a2,88(sp)
    8000515a:	7686                	ld	a3,96(sp)
    8000515c:	7726                	ld	a4,104(sp)
    8000515e:	77c6                	ld	a5,112(sp)
    80005160:	7866                	ld	a6,120(sp)
    80005162:	688a                	ld	a7,128(sp)
    80005164:	692a                	ld	s2,136(sp)
    80005166:	69ca                	ld	s3,144(sp)
    80005168:	6a6a                	ld	s4,152(sp)
    8000516a:	7a8a                	ld	s5,160(sp)
    8000516c:	7b2a                	ld	s6,168(sp)
    8000516e:	7bca                	ld	s7,176(sp)
    80005170:	7c6a                	ld	s8,184(sp)
    80005172:	6c8e                	ld	s9,192(sp)
    80005174:	6d2e                	ld	s10,200(sp)
    80005176:	6dce                	ld	s11,208(sp)
    80005178:	6e6e                	ld	t3,216(sp)
    8000517a:	7e8e                	ld	t4,224(sp)
    8000517c:	7f2e                	ld	t5,232(sp)
    8000517e:	7fce                	ld	t6,240(sp)
    80005180:	6111                	addi	sp,sp,256
    80005182:	10200073          	sret
    80005186:	00000013          	nop
    8000518a:	00000013          	nop
    8000518e:	0001                	nop

0000000080005190 <timervec>:
    80005190:	34051573          	csrrw	a0,mscratch,a0
    80005194:	e10c                	sd	a1,0(a0)
    80005196:	e510                	sd	a2,8(a0)
    80005198:	e914                	sd	a3,16(a0)
    8000519a:	6d0c                	ld	a1,24(a0)
    8000519c:	7110                	ld	a2,32(a0)
    8000519e:	6194                	ld	a3,0(a1)
    800051a0:	96b2                	add	a3,a3,a2
    800051a2:	e194                	sd	a3,0(a1)
    800051a4:	4589                	li	a1,2
    800051a6:	14459073          	csrw	sip,a1
    800051aa:	6914                	ld	a3,16(a0)
    800051ac:	6510                	ld	a2,8(a0)
    800051ae:	610c                	ld	a1,0(a0)
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	30200073          	mret
	...

00000000800051ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ba:	1141                	addi	sp,sp,-16
    800051bc:	e422                	sd	s0,8(sp)
    800051be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051c0:	0c0007b7          	lui	a5,0xc000
    800051c4:	4705                	li	a4,1
    800051c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051c8:	c3d8                	sw	a4,4(a5)
    800051ca:	0791                	addi	a5,a5,4
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    800051cc:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    800051ce:	0c000737          	lui	a4,0xc000
    800051d2:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    800051d6:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    800051d8:	0791                	addi	a5,a5,4
    800051da:	fee79ee3          	bne	a5,a4,800051d6 <plicinit+0x1c>
  }
#endif  
}
    800051de:	6422                	ld	s0,8(sp)
    800051e0:	0141                	addi	sp,sp,16
    800051e2:	8082                	ret

00000000800051e4 <plicinithart>:

void
plicinithart(void)
{
    800051e4:	1141                	addi	sp,sp,-16
    800051e6:	e406                	sd	ra,8(sp)
    800051e8:	e022                	sd	s0,0(sp)
    800051ea:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051ec:	ffffc097          	auipc	ra,0xffffc
    800051f0:	cd0080e7          	jalr	-816(ra) # 80000ebc <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051f4:	0085171b          	slliw	a4,a0,0x8
    800051f8:	0c0027b7          	lui	a5,0xc002
    800051fc:	97ba                	add	a5,a5,a4
    800051fe:	40200713          	li	a4,1026
    80005202:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80005206:	577d                	li	a4,-1
    80005208:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000520c:	00d5151b          	slliw	a0,a0,0xd
    80005210:	0c2017b7          	lui	a5,0xc201
    80005214:	953e                	add	a0,a0,a5
    80005216:	00052023          	sw	zero,0(a0)
}
    8000521a:	60a2                	ld	ra,8(sp)
    8000521c:	6402                	ld	s0,0(sp)
    8000521e:	0141                	addi	sp,sp,16
    80005220:	8082                	ret

0000000080005222 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005222:	1141                	addi	sp,sp,-16
    80005224:	e406                	sd	ra,8(sp)
    80005226:	e022                	sd	s0,0(sp)
    80005228:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000522a:	ffffc097          	auipc	ra,0xffffc
    8000522e:	c92080e7          	jalr	-878(ra) # 80000ebc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005232:	00d5179b          	slliw	a5,a0,0xd
    80005236:	0c201537          	lui	a0,0xc201
    8000523a:	953e                	add	a0,a0,a5
  return irq;
}
    8000523c:	4148                	lw	a0,4(a0)
    8000523e:	60a2                	ld	ra,8(sp)
    80005240:	6402                	ld	s0,0(sp)
    80005242:	0141                	addi	sp,sp,16
    80005244:	8082                	ret

0000000080005246 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005246:	1101                	addi	sp,sp,-32
    80005248:	ec06                	sd	ra,24(sp)
    8000524a:	e822                	sd	s0,16(sp)
    8000524c:	e426                	sd	s1,8(sp)
    8000524e:	1000                	addi	s0,sp,32
    80005250:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005252:	ffffc097          	auipc	ra,0xffffc
    80005256:	c6a080e7          	jalr	-918(ra) # 80000ebc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000525a:	00d5151b          	slliw	a0,a0,0xd
    8000525e:	0c2017b7          	lui	a5,0xc201
    80005262:	97aa                	add	a5,a5,a0
    80005264:	c3c4                	sw	s1,4(a5)
}
    80005266:	60e2                	ld	ra,24(sp)
    80005268:	6442                	ld	s0,16(sp)
    8000526a:	64a2                	ld	s1,8(sp)
    8000526c:	6105                	addi	sp,sp,32
    8000526e:	8082                	ret

0000000080005270 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005270:	1141                	addi	sp,sp,-16
    80005272:	e406                	sd	ra,8(sp)
    80005274:	e022                	sd	s0,0(sp)
    80005276:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005278:	479d                	li	a5,7
    8000527a:	04a7cc63          	blt	a5,a0,800052d2 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    8000527e:	00016797          	auipc	a5,0x16
    80005282:	b2278793          	addi	a5,a5,-1246 # 8001ada0 <disk>
    80005286:	97aa                	add	a5,a5,a0
    80005288:	0187c783          	lbu	a5,24(a5)
    8000528c:	ebb9                	bnez	a5,800052e2 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000528e:	00451613          	slli	a2,a0,0x4
    80005292:	00016797          	auipc	a5,0x16
    80005296:	b0e78793          	addi	a5,a5,-1266 # 8001ada0 <disk>
    8000529a:	6394                	ld	a3,0(a5)
    8000529c:	96b2                	add	a3,a3,a2
    8000529e:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052a2:	6398                	ld	a4,0(a5)
    800052a4:	9732                	add	a4,a4,a2
    800052a6:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052aa:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052ae:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052b2:	953e                	add	a0,a0,a5
    800052b4:	4785                	li	a5,1
    800052b6:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800052ba:	00016517          	auipc	a0,0x16
    800052be:	afe50513          	addi	a0,a0,-1282 # 8001adb8 <disk+0x18>
    800052c2:	ffffc097          	auipc	ra,0xffffc
    800052c6:	332080e7          	jalr	818(ra) # 800015f4 <wakeup>
}
    800052ca:	60a2                	ld	ra,8(sp)
    800052cc:	6402                	ld	s0,0(sp)
    800052ce:	0141                	addi	sp,sp,16
    800052d0:	8082                	ret
    panic("free_desc 1");
    800052d2:	00004517          	auipc	a0,0x4
    800052d6:	43e50513          	addi	a0,a0,1086 # 80009710 <syscalls+0x330>
    800052da:	00002097          	auipc	ra,0x2
    800052de:	9b8080e7          	jalr	-1608(ra) # 80006c92 <panic>
    panic("free_desc 2");
    800052e2:	00004517          	auipc	a0,0x4
    800052e6:	43e50513          	addi	a0,a0,1086 # 80009720 <syscalls+0x340>
    800052ea:	00002097          	auipc	ra,0x2
    800052ee:	9a8080e7          	jalr	-1624(ra) # 80006c92 <panic>

00000000800052f2 <virtio_disk_init>:
{
    800052f2:	1101                	addi	sp,sp,-32
    800052f4:	ec06                	sd	ra,24(sp)
    800052f6:	e822                	sd	s0,16(sp)
    800052f8:	e426                	sd	s1,8(sp)
    800052fa:	e04a                	sd	s2,0(sp)
    800052fc:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052fe:	00004597          	auipc	a1,0x4
    80005302:	43258593          	addi	a1,a1,1074 # 80009730 <syscalls+0x350>
    80005306:	00016517          	auipc	a0,0x16
    8000530a:	bc250513          	addi	a0,a0,-1086 # 8001aec8 <disk+0x128>
    8000530e:	00002097          	auipc	ra,0x2
    80005312:	e3e080e7          	jalr	-450(ra) # 8000714c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	4398                	lw	a4,0(a5)
    8000531c:	2701                	sext.w	a4,a4
    8000531e:	747277b7          	lui	a5,0x74727
    80005322:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005326:	14f71e63          	bne	a4,a5,80005482 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000532a:	100017b7          	lui	a5,0x10001
    8000532e:	43dc                	lw	a5,4(a5)
    80005330:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005332:	4709                	li	a4,2
    80005334:	14e79763          	bne	a5,a4,80005482 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005338:	100017b7          	lui	a5,0x10001
    8000533c:	479c                	lw	a5,8(a5)
    8000533e:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005340:	14e79163          	bne	a5,a4,80005482 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005344:	100017b7          	lui	a5,0x10001
    80005348:	47d8                	lw	a4,12(a5)
    8000534a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000534c:	554d47b7          	lui	a5,0x554d4
    80005350:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005354:	12f71763          	bne	a4,a5,80005482 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005358:	100017b7          	lui	a5,0x10001
    8000535c:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005360:	4705                	li	a4,1
    80005362:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005364:	470d                	li	a4,3
    80005366:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005368:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000536a:	c7ffe737          	lui	a4,0xc7ffe
    8000536e:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb2ff>
    80005372:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005374:	2701                	sext.w	a4,a4
    80005376:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005378:	472d                	li	a4,11
    8000537a:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000537c:	0707a903          	lw	s2,112(a5)
    80005380:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005382:	00897793          	andi	a5,s2,8
    80005386:	10078663          	beqz	a5,80005492 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000538a:	100017b7          	lui	a5,0x10001
    8000538e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005392:	43fc                	lw	a5,68(a5)
    80005394:	2781                	sext.w	a5,a5
    80005396:	10079663          	bnez	a5,800054a2 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000539a:	100017b7          	lui	a5,0x10001
    8000539e:	5bdc                	lw	a5,52(a5)
    800053a0:	2781                	sext.w	a5,a5
  if(max == 0)
    800053a2:	10078863          	beqz	a5,800054b2 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800053a6:	471d                	li	a4,7
    800053a8:	10f77d63          	bgeu	a4,a5,800054c2 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800053ac:	ffffb097          	auipc	ra,0xffffb
    800053b0:	d6c080e7          	jalr	-660(ra) # 80000118 <kalloc>
    800053b4:	00016497          	auipc	s1,0x16
    800053b8:	9ec48493          	addi	s1,s1,-1556 # 8001ada0 <disk>
    800053bc:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053be:	ffffb097          	auipc	ra,0xffffb
    800053c2:	d5a080e7          	jalr	-678(ra) # 80000118 <kalloc>
    800053c6:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053c8:	ffffb097          	auipc	ra,0xffffb
    800053cc:	d50080e7          	jalr	-688(ra) # 80000118 <kalloc>
    800053d0:	87aa                	mv	a5,a0
    800053d2:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053d4:	6088                	ld	a0,0(s1)
    800053d6:	cd75                	beqz	a0,800054d2 <virtio_disk_init+0x1e0>
    800053d8:	00016717          	auipc	a4,0x16
    800053dc:	9d073703          	ld	a4,-1584(a4) # 8001ada8 <disk+0x8>
    800053e0:	cb6d                	beqz	a4,800054d2 <virtio_disk_init+0x1e0>
    800053e2:	cbe5                	beqz	a5,800054d2 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800053e4:	6605                	lui	a2,0x1
    800053e6:	4581                	li	a1,0
    800053e8:	ffffb097          	auipc	ra,0xffffb
    800053ec:	d90080e7          	jalr	-624(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800053f0:	00016497          	auipc	s1,0x16
    800053f4:	9b048493          	addi	s1,s1,-1616 # 8001ada0 <disk>
    800053f8:	6605                	lui	a2,0x1
    800053fa:	4581                	li	a1,0
    800053fc:	6488                	ld	a0,8(s1)
    800053fe:	ffffb097          	auipc	ra,0xffffb
    80005402:	d7a080e7          	jalr	-646(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    80005406:	6605                	lui	a2,0x1
    80005408:	4581                	li	a1,0
    8000540a:	6888                	ld	a0,16(s1)
    8000540c:	ffffb097          	auipc	ra,0xffffb
    80005410:	d6c080e7          	jalr	-660(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	4721                	li	a4,8
    8000541a:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000541c:	4098                	lw	a4,0(s1)
    8000541e:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005422:	40d8                	lw	a4,4(s1)
    80005424:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005428:	6498                	ld	a4,8(s1)
    8000542a:	0007069b          	sext.w	a3,a4
    8000542e:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005432:	9701                	srai	a4,a4,0x20
    80005434:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005438:	6898                	ld	a4,16(s1)
    8000543a:	0007069b          	sext.w	a3,a4
    8000543e:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005442:	9701                	srai	a4,a4,0x20
    80005444:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005448:	4685                	li	a3,1
    8000544a:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    8000544c:	4705                	li	a4,1
    8000544e:	00d48c23          	sb	a3,24(s1)
    80005452:	00e48ca3          	sb	a4,25(s1)
    80005456:	00e48d23          	sb	a4,26(s1)
    8000545a:	00e48da3          	sb	a4,27(s1)
    8000545e:	00e48e23          	sb	a4,28(s1)
    80005462:	00e48ea3          	sb	a4,29(s1)
    80005466:	00e48f23          	sb	a4,30(s1)
    8000546a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000546e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005472:	0727a823          	sw	s2,112(a5)
}
    80005476:	60e2                	ld	ra,24(sp)
    80005478:	6442                	ld	s0,16(sp)
    8000547a:	64a2                	ld	s1,8(sp)
    8000547c:	6902                	ld	s2,0(sp)
    8000547e:	6105                	addi	sp,sp,32
    80005480:	8082                	ret
    panic("could not find virtio disk");
    80005482:	00004517          	auipc	a0,0x4
    80005486:	2be50513          	addi	a0,a0,702 # 80009740 <syscalls+0x360>
    8000548a:	00002097          	auipc	ra,0x2
    8000548e:	808080e7          	jalr	-2040(ra) # 80006c92 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005492:	00004517          	auipc	a0,0x4
    80005496:	2ce50513          	addi	a0,a0,718 # 80009760 <syscalls+0x380>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	7f8080e7          	jalr	2040(ra) # 80006c92 <panic>
    panic("virtio disk should not be ready");
    800054a2:	00004517          	auipc	a0,0x4
    800054a6:	2de50513          	addi	a0,a0,734 # 80009780 <syscalls+0x3a0>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	7e8080e7          	jalr	2024(ra) # 80006c92 <panic>
    panic("virtio disk has no queue 0");
    800054b2:	00004517          	auipc	a0,0x4
    800054b6:	2ee50513          	addi	a0,a0,750 # 800097a0 <syscalls+0x3c0>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	7d8080e7          	jalr	2008(ra) # 80006c92 <panic>
    panic("virtio disk max queue too short");
    800054c2:	00004517          	auipc	a0,0x4
    800054c6:	2fe50513          	addi	a0,a0,766 # 800097c0 <syscalls+0x3e0>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	7c8080e7          	jalr	1992(ra) # 80006c92 <panic>
    panic("virtio disk kalloc");
    800054d2:	00004517          	auipc	a0,0x4
    800054d6:	30e50513          	addi	a0,a0,782 # 800097e0 <syscalls+0x400>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	7b8080e7          	jalr	1976(ra) # 80006c92 <panic>

00000000800054e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054e2:	7159                	addi	sp,sp,-112
    800054e4:	f486                	sd	ra,104(sp)
    800054e6:	f0a2                	sd	s0,96(sp)
    800054e8:	eca6                	sd	s1,88(sp)
    800054ea:	e8ca                	sd	s2,80(sp)
    800054ec:	e4ce                	sd	s3,72(sp)
    800054ee:	e0d2                	sd	s4,64(sp)
    800054f0:	fc56                	sd	s5,56(sp)
    800054f2:	f85a                	sd	s6,48(sp)
    800054f4:	f45e                	sd	s7,40(sp)
    800054f6:	f062                	sd	s8,32(sp)
    800054f8:	ec66                	sd	s9,24(sp)
    800054fa:	e86a                	sd	s10,16(sp)
    800054fc:	1880                	addi	s0,sp,112
    800054fe:	892a                	mv	s2,a0
    80005500:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005502:	00c52c83          	lw	s9,12(a0)
    80005506:	001c9c9b          	slliw	s9,s9,0x1
    8000550a:	1c82                	slli	s9,s9,0x20
    8000550c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005510:	00016517          	auipc	a0,0x16
    80005514:	9b850513          	addi	a0,a0,-1608 # 8001aec8 <disk+0x128>
    80005518:	00002097          	auipc	ra,0x2
    8000551c:	cc4080e7          	jalr	-828(ra) # 800071dc <acquire>
  for(int i = 0; i < 3; i++){
    80005520:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005522:	4ba1                	li	s7,8
      disk.free[i] = 0;
    80005524:	00016b17          	auipc	s6,0x16
    80005528:	87cb0b13          	addi	s6,s6,-1924 # 8001ada0 <disk>
  for(int i = 0; i < 3; i++){
    8000552c:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    8000552e:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005530:	00016c17          	auipc	s8,0x16
    80005534:	998c0c13          	addi	s8,s8,-1640 # 8001aec8 <disk+0x128>
    80005538:	a8b5                	j	800055b4 <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    8000553a:	00fb06b3          	add	a3,s6,a5
    8000553e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005542:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005544:	0207c563          	bltz	a5,8000556e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005548:	2485                	addiw	s1,s1,1
    8000554a:	0711                	addi	a4,a4,4
    8000554c:	1f548a63          	beq	s1,s5,80005740 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005550:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005552:	00016697          	auipc	a3,0x16
    80005556:	84e68693          	addi	a3,a3,-1970 # 8001ada0 <disk>
    8000555a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000555c:	0186c583          	lbu	a1,24(a3)
    80005560:	fde9                	bnez	a1,8000553a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005562:	2785                	addiw	a5,a5,1
    80005564:	0685                	addi	a3,a3,1
    80005566:	ff779be3          	bne	a5,s7,8000555c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000556a:	57fd                	li	a5,-1
    8000556c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000556e:	02905a63          	blez	s1,800055a2 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005572:	f9042503          	lw	a0,-112(s0)
    80005576:	00000097          	auipc	ra,0x0
    8000557a:	cfa080e7          	jalr	-774(ra) # 80005270 <free_desc>
      for(int j = 0; j < i; j++)
    8000557e:	4785                	li	a5,1
    80005580:	0297d163          	bge	a5,s1,800055a2 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005584:	f9442503          	lw	a0,-108(s0)
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	ce8080e7          	jalr	-792(ra) # 80005270 <free_desc>
      for(int j = 0; j < i; j++)
    80005590:	4789                	li	a5,2
    80005592:	0097d863          	bge	a5,s1,800055a2 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005596:	f9842503          	lw	a0,-104(s0)
    8000559a:	00000097          	auipc	ra,0x0
    8000559e:	cd6080e7          	jalr	-810(ra) # 80005270 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055a2:	85e2                	mv	a1,s8
    800055a4:	00016517          	auipc	a0,0x16
    800055a8:	81450513          	addi	a0,a0,-2028 # 8001adb8 <disk+0x18>
    800055ac:	ffffc097          	auipc	ra,0xffffc
    800055b0:	fe4080e7          	jalr	-28(ra) # 80001590 <sleep>
  for(int i = 0; i < 3; i++){
    800055b4:	f9040713          	addi	a4,s0,-112
    800055b8:	84ce                	mv	s1,s3
    800055ba:	bf59                	j	80005550 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055bc:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800055c0:	00479693          	slli	a3,a5,0x4
    800055c4:	00015797          	auipc	a5,0x15
    800055c8:	7dc78793          	addi	a5,a5,2012 # 8001ada0 <disk>
    800055cc:	97b6                	add	a5,a5,a3
    800055ce:	4685                	li	a3,1
    800055d0:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055d2:	00015597          	auipc	a1,0x15
    800055d6:	7ce58593          	addi	a1,a1,1998 # 8001ada0 <disk>
    800055da:	00a60793          	addi	a5,a2,10
    800055de:	0792                	slli	a5,a5,0x4
    800055e0:	97ae                	add	a5,a5,a1
    800055e2:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800055e6:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ea:	f6070693          	addi	a3,a4,-160
    800055ee:	619c                	ld	a5,0(a1)
    800055f0:	97b6                	add	a5,a5,a3
    800055f2:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055f4:	6188                	ld	a0,0(a1)
    800055f6:	96aa                	add	a3,a3,a0
    800055f8:	47c1                	li	a5,16
    800055fa:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055fc:	4785                	li	a5,1
    800055fe:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005602:	f9442783          	lw	a5,-108(s0)
    80005606:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000560a:	0792                	slli	a5,a5,0x4
    8000560c:	953e                	add	a0,a0,a5
    8000560e:	05890693          	addi	a3,s2,88
    80005612:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80005614:	6188                	ld	a0,0(a1)
    80005616:	97aa                	add	a5,a5,a0
    80005618:	40000693          	li	a3,1024
    8000561c:	c794                	sw	a3,8(a5)
  if(write)
    8000561e:	100d0d63          	beqz	s10,80005738 <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005622:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005626:	00c7d683          	lhu	a3,12(a5)
    8000562a:	0016e693          	ori	a3,a3,1
    8000562e:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005632:	f9842583          	lw	a1,-104(s0)
    80005636:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000563a:	00015697          	auipc	a3,0x15
    8000563e:	76668693          	addi	a3,a3,1894 # 8001ada0 <disk>
    80005642:	00260793          	addi	a5,a2,2
    80005646:	0792                	slli	a5,a5,0x4
    80005648:	97b6                	add	a5,a5,a3
    8000564a:	587d                	li	a6,-1
    8000564c:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005650:	0592                	slli	a1,a1,0x4
    80005652:	952e                	add	a0,a0,a1
    80005654:	f9070713          	addi	a4,a4,-112
    80005658:	9736                	add	a4,a4,a3
    8000565a:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    8000565c:	6298                	ld	a4,0(a3)
    8000565e:	972e                	add	a4,a4,a1
    80005660:	4585                	li	a1,1
    80005662:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005664:	4509                	li	a0,2
    80005666:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    8000566a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000566e:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005672:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005676:	6698                	ld	a4,8(a3)
    80005678:	00275783          	lhu	a5,2(a4)
    8000567c:	8b9d                	andi	a5,a5,7
    8000567e:	0786                	slli	a5,a5,0x1
    80005680:	97ba                	add	a5,a5,a4
    80005682:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    80005686:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000568a:	6698                	ld	a4,8(a3)
    8000568c:	00275783          	lhu	a5,2(a4)
    80005690:	2785                	addiw	a5,a5,1
    80005692:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005696:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000569a:	100017b7          	lui	a5,0x10001
    8000569e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056a2:	00492703          	lw	a4,4(s2)
    800056a6:	4785                	li	a5,1
    800056a8:	02f71163          	bne	a4,a5,800056ca <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800056ac:	00016997          	auipc	s3,0x16
    800056b0:	81c98993          	addi	s3,s3,-2020 # 8001aec8 <disk+0x128>
  while(b->disk == 1) {
    800056b4:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056b6:	85ce                	mv	a1,s3
    800056b8:	854a                	mv	a0,s2
    800056ba:	ffffc097          	auipc	ra,0xffffc
    800056be:	ed6080e7          	jalr	-298(ra) # 80001590 <sleep>
  while(b->disk == 1) {
    800056c2:	00492783          	lw	a5,4(s2)
    800056c6:	fe9788e3          	beq	a5,s1,800056b6 <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800056ca:	f9042903          	lw	s2,-112(s0)
    800056ce:	00290793          	addi	a5,s2,2
    800056d2:	00479713          	slli	a4,a5,0x4
    800056d6:	00015797          	auipc	a5,0x15
    800056da:	6ca78793          	addi	a5,a5,1738 # 8001ada0 <disk>
    800056de:	97ba                	add	a5,a5,a4
    800056e0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056e4:	00015997          	auipc	s3,0x15
    800056e8:	6bc98993          	addi	s3,s3,1724 # 8001ada0 <disk>
    800056ec:	00491713          	slli	a4,s2,0x4
    800056f0:	0009b783          	ld	a5,0(s3)
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056fa:	854a                	mv	a0,s2
    800056fc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005700:	00000097          	auipc	ra,0x0
    80005704:	b70080e7          	jalr	-1168(ra) # 80005270 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005708:	8885                	andi	s1,s1,1
    8000570a:	f0ed                	bnez	s1,800056ec <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000570c:	00015517          	auipc	a0,0x15
    80005710:	7bc50513          	addi	a0,a0,1980 # 8001aec8 <disk+0x128>
    80005714:	00002097          	auipc	ra,0x2
    80005718:	b7c080e7          	jalr	-1156(ra) # 80007290 <release>
}
    8000571c:	70a6                	ld	ra,104(sp)
    8000571e:	7406                	ld	s0,96(sp)
    80005720:	64e6                	ld	s1,88(sp)
    80005722:	6946                	ld	s2,80(sp)
    80005724:	69a6                	ld	s3,72(sp)
    80005726:	6a06                	ld	s4,64(sp)
    80005728:	7ae2                	ld	s5,56(sp)
    8000572a:	7b42                	ld	s6,48(sp)
    8000572c:	7ba2                	ld	s7,40(sp)
    8000572e:	7c02                	ld	s8,32(sp)
    80005730:	6ce2                	ld	s9,24(sp)
    80005732:	6d42                	ld	s10,16(sp)
    80005734:	6165                	addi	sp,sp,112
    80005736:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005738:	4689                	li	a3,2
    8000573a:	00d79623          	sh	a3,12(a5)
    8000573e:	b5e5                	j	80005626 <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005740:	f9042603          	lw	a2,-112(s0)
    80005744:	00a60713          	addi	a4,a2,10
    80005748:	0712                	slli	a4,a4,0x4
    8000574a:	00015517          	auipc	a0,0x15
    8000574e:	65e50513          	addi	a0,a0,1630 # 8001ada8 <disk+0x8>
    80005752:	953a                	add	a0,a0,a4
  if(write)
    80005754:	e60d14e3          	bnez	s10,800055bc <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005758:	00a60793          	addi	a5,a2,10
    8000575c:	00479693          	slli	a3,a5,0x4
    80005760:	00015797          	auipc	a5,0x15
    80005764:	64078793          	addi	a5,a5,1600 # 8001ada0 <disk>
    80005768:	97b6                	add	a5,a5,a3
    8000576a:	0007a423          	sw	zero,8(a5)
    8000576e:	b595                	j	800055d2 <virtio_disk_rw+0xf0>

0000000080005770 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005770:	1101                	addi	sp,sp,-32
    80005772:	ec06                	sd	ra,24(sp)
    80005774:	e822                	sd	s0,16(sp)
    80005776:	e426                	sd	s1,8(sp)
    80005778:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000577a:	00015497          	auipc	s1,0x15
    8000577e:	62648493          	addi	s1,s1,1574 # 8001ada0 <disk>
    80005782:	00015517          	auipc	a0,0x15
    80005786:	74650513          	addi	a0,a0,1862 # 8001aec8 <disk+0x128>
    8000578a:	00002097          	auipc	ra,0x2
    8000578e:	a52080e7          	jalr	-1454(ra) # 800071dc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005792:	10001737          	lui	a4,0x10001
    80005796:	533c                	lw	a5,96(a4)
    80005798:	8b8d                	andi	a5,a5,3
    8000579a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000579c:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057a0:	689c                	ld	a5,16(s1)
    800057a2:	0204d703          	lhu	a4,32(s1)
    800057a6:	0027d783          	lhu	a5,2(a5)
    800057aa:	04f70863          	beq	a4,a5,800057fa <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057ae:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057b2:	6898                	ld	a4,16(s1)
    800057b4:	0204d783          	lhu	a5,32(s1)
    800057b8:	8b9d                	andi	a5,a5,7
    800057ba:	078e                	slli	a5,a5,0x3
    800057bc:	97ba                	add	a5,a5,a4
    800057be:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057c0:	00278713          	addi	a4,a5,2
    800057c4:	0712                	slli	a4,a4,0x4
    800057c6:	9726                	add	a4,a4,s1
    800057c8:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057cc:	e721                	bnez	a4,80005814 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057ce:	0789                	addi	a5,a5,2
    800057d0:	0792                	slli	a5,a5,0x4
    800057d2:	97a6                	add	a5,a5,s1
    800057d4:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057d6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057da:	ffffc097          	auipc	ra,0xffffc
    800057de:	e1a080e7          	jalr	-486(ra) # 800015f4 <wakeup>

    disk.used_idx += 1;
    800057e2:	0204d783          	lhu	a5,32(s1)
    800057e6:	2785                	addiw	a5,a5,1
    800057e8:	17c2                	slli	a5,a5,0x30
    800057ea:	93c1                	srli	a5,a5,0x30
    800057ec:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057f0:	6898                	ld	a4,16(s1)
    800057f2:	00275703          	lhu	a4,2(a4)
    800057f6:	faf71ce3          	bne	a4,a5,800057ae <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057fa:	00015517          	auipc	a0,0x15
    800057fe:	6ce50513          	addi	a0,a0,1742 # 8001aec8 <disk+0x128>
    80005802:	00002097          	auipc	ra,0x2
    80005806:	a8e080e7          	jalr	-1394(ra) # 80007290 <release>
}
    8000580a:	60e2                	ld	ra,24(sp)
    8000580c:	6442                	ld	s0,16(sp)
    8000580e:	64a2                	ld	s1,8(sp)
    80005810:	6105                	addi	sp,sp,32
    80005812:	8082                	ret
      panic("virtio_disk_intr status");
    80005814:	00004517          	auipc	a0,0x4
    80005818:	fe450513          	addi	a0,a0,-28 # 800097f8 <syscalls+0x418>
    8000581c:	00001097          	auipc	ra,0x1
    80005820:	476080e7          	jalr	1142(ra) # 80006c92 <panic>

0000000080005824 <e1000_init>:
// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
    80005824:	7179                	addi	sp,sp,-48
    80005826:	f406                	sd	ra,40(sp)
    80005828:	f022                	sd	s0,32(sp)
    8000582a:	ec26                	sd	s1,24(sp)
    8000582c:	e84a                	sd	s2,16(sp)
    8000582e:	e44e                	sd	s3,8(sp)
    80005830:	1800                	addi	s0,sp,48
    80005832:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80005834:	00004597          	auipc	a1,0x4
    80005838:	fdc58593          	addi	a1,a1,-36 # 80009810 <syscalls+0x430>
    8000583c:	00015517          	auipc	a0,0x15
    80005840:	6a450513          	addi	a0,a0,1700 # 8001aee0 <e1000_lock>
    80005844:	00002097          	auipc	ra,0x2
    80005848:	908080e7          	jalr	-1784(ra) # 8000714c <initlock>

  regs = xregs;
    8000584c:	00004797          	auipc	a5,0x4
    80005850:	1097ba23          	sd	s1,276(a5) # 80009960 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80005854:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80005858:	409c                	lw	a5,0(s1)
    8000585a:	00400737          	lui	a4,0x400
    8000585e:	8fd9                	or	a5,a5,a4
    80005860:	2781                	sext.w	a5,a5
    80005862:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80005864:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80005868:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    8000586c:	10000613          	li	a2,256
    80005870:	4581                	li	a1,0
    80005872:	00015517          	auipc	a0,0x15
    80005876:	68e50513          	addi	a0,a0,1678 # 8001af00 <tx_ring>
    8000587a:	ffffb097          	auipc	ra,0xffffb
    8000587e:	8fe080e7          	jalr	-1794(ra) # 80000178 <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005882:	00015717          	auipc	a4,0x15
    80005886:	68a70713          	addi	a4,a4,1674 # 8001af0c <tx_ring+0xc>
    8000588a:	00015797          	auipc	a5,0x15
    8000588e:	77678793          	addi	a5,a5,1910 # 8001b000 <tx_mbufs>
    80005892:	00015617          	auipc	a2,0x15
    80005896:	7ee60613          	addi	a2,a2,2030 # 8001b080 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    8000589a:	4685                	li	a3,1
    8000589c:	00d70023          	sb	a3,0(a4)
    tx_mbufs[i] = 0;
    800058a0:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    800058a4:	0741                	addi	a4,a4,16
    800058a6:	07a1                	addi	a5,a5,8
    800058a8:	fec79ae3          	bne	a5,a2,8000589c <e1000_init+0x78>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    800058ac:	00015717          	auipc	a4,0x15
    800058b0:	65470713          	addi	a4,a4,1620 # 8001af00 <tx_ring>
    800058b4:	00004797          	auipc	a5,0x4
    800058b8:	0ac7b783          	ld	a5,172(a5) # 80009960 <regs>
    800058bc:	6691                	lui	a3,0x4
    800058be:	97b6                	add	a5,a5,a3
    800058c0:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    800058c4:	10000713          	li	a4,256
    800058c8:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    800058cc:	8007ac23          	sw	zero,-2024(a5)
    800058d0:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    800058d4:	00015917          	auipc	s2,0x15
    800058d8:	7ac90913          	addi	s2,s2,1964 # 8001b080 <rx_ring>
    800058dc:	10000613          	li	a2,256
    800058e0:	4581                	li	a1,0
    800058e2:	854a                	mv	a0,s2
    800058e4:	ffffb097          	auipc	ra,0xffffb
    800058e8:	894080e7          	jalr	-1900(ra) # 80000178 <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    800058ec:	00016497          	auipc	s1,0x16
    800058f0:	89448493          	addi	s1,s1,-1900 # 8001b180 <rx_mbufs>
    800058f4:	00016997          	auipc	s3,0x16
    800058f8:	90c98993          	addi	s3,s3,-1780 # 8001b200 <lock>
    rx_mbufs[i] = mbufalloc(0);
    800058fc:	4501                	li	a0,0
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	416080e7          	jalr	1046(ra) # 80005d14 <mbufalloc>
    80005906:	e088                	sd	a0,0(s1)
    if (!rx_mbufs[i])
    80005908:	c945                	beqz	a0,800059b8 <e1000_init+0x194>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
    8000590a:	651c                	ld	a5,8(a0)
    8000590c:	00f93023          	sd	a5,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005910:	04a1                	addi	s1,s1,8
    80005912:	0941                	addi	s2,s2,16
    80005914:	ff3494e3          	bne	s1,s3,800058fc <e1000_init+0xd8>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80005918:	00004697          	auipc	a3,0x4
    8000591c:	0486b683          	ld	a3,72(a3) # 80009960 <regs>
    80005920:	00015717          	auipc	a4,0x15
    80005924:	76070713          	addi	a4,a4,1888 # 8001b080 <rx_ring>
    80005928:	678d                	lui	a5,0x3
    8000592a:	97b6                	add	a5,a5,a3
    8000592c:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80005930:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80005934:	473d                	li	a4,15
    80005936:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    8000593a:	10000713          	li	a4,256
    8000593e:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005942:	6715                	lui	a4,0x5
    80005944:	00e68633          	add	a2,a3,a4
    80005948:	120057b7          	lui	a5,0x12005
    8000594c:	4527879b          	addiw	a5,a5,1106
    80005950:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80005954:	800057b7          	lui	a5,0x80005
    80005958:	6347879b          	addiw	a5,a5,1588
    8000595c:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80005960:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    80005964:	97b6                	add	a5,a5,a3
    80005966:	40070713          	addi	a4,a4,1024
    8000596a:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    8000596c:	0007a023          	sw	zero,0(a5) # ffffffff80005000 <end+0xfffffffefffe1ba0>
  for (int i = 0; i < 4096/32; i++)
    80005970:	0791                	addi	a5,a5,4
    80005972:	fee79de3          	bne	a5,a4,8000596c <e1000_init+0x148>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    80005976:	000407b7          	lui	a5,0x40
    8000597a:	10a7879b          	addiw	a5,a5,266
    8000597e:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    80005982:	006027b7          	lui	a5,0x602
    80005986:	27a9                	addiw	a5,a5,10
    80005988:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    8000598c:	040087b7          	lui	a5,0x4008
    80005990:	2789                	addiw	a5,a5,2
    80005992:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    80005996:	678d                	lui	a5,0x3
    80005998:	97b6                	add	a5,a5,a3
    8000599a:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    8000599e:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    800059a2:	08000793          	li	a5,128
    800059a6:	0cf6a823          	sw	a5,208(a3)
}
    800059aa:	70a2                	ld	ra,40(sp)
    800059ac:	7402                	ld	s0,32(sp)
    800059ae:	64e2                	ld	s1,24(sp)
    800059b0:	6942                	ld	s2,16(sp)
    800059b2:	69a2                	ld	s3,8(sp)
    800059b4:	6145                	addi	sp,sp,48
    800059b6:	8082                	ret
      panic("e1000");
    800059b8:	00004517          	auipc	a0,0x4
    800059bc:	e5850513          	addi	a0,a0,-424 # 80009810 <syscalls+0x430>
    800059c0:	00001097          	auipc	ra,0x1
    800059c4:	2d2080e7          	jalr	722(ra) # 80006c92 <panic>

00000000800059c8 <e1000_transmit>:

int
e1000_transmit(struct mbuf *m)
{
    800059c8:	7179                	addi	sp,sp,-48
    800059ca:	f406                	sd	ra,40(sp)
    800059cc:	f022                	sd	s0,32(sp)
    800059ce:	ec26                	sd	s1,24(sp)
    800059d0:	e84a                	sd	s2,16(sp)
    800059d2:	e44e                	sd	s3,8(sp)
    800059d4:	e052                	sd	s4,0(sp)
    800059d6:	1800                	addi	s0,sp,48
    800059d8:	892a                	mv	s2,a0
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.

  acquire(&e1000_lock);
    800059da:	00015a17          	auipc	s4,0x15
    800059de:	506a0a13          	addi	s4,s4,1286 # 8001aee0 <e1000_lock>
    800059e2:	8552                	mv	a0,s4
    800059e4:	00001097          	auipc	ra,0x1
    800059e8:	7f8080e7          	jalr	2040(ra) # 800071dc <acquire>
  uint64 tdt = regs[E1000_TDT];
    800059ec:	00004797          	auipc	a5,0x4
    800059f0:	f747b783          	ld	a5,-140(a5) # 80009960 <regs>
    800059f4:	6711                	lui	a4,0x4
    800059f6:	97ba                	add	a5,a5,a4
    800059f8:	8187a483          	lw	s1,-2024(a5)
    800059fc:	02049993          	slli	s3,s1,0x20
  uint64 index = tdt % TX_RING_SIZE;
    80005a00:	88bd                	andi	s1,s1,15

  if((tx_ring[index].status & E1000_TXD_STAT_DD) == 0){
    80005a02:	00449793          	slli	a5,s1,0x4
    80005a06:	9a3e                	add	s4,s4,a5
    80005a08:	02ca4783          	lbu	a5,44(s4)
    80005a0c:	8b85                	andi	a5,a5,1
    80005a0e:	c3c1                	beqz	a5,80005a8e <e1000_transmit+0xc6>
    80005a10:	0209d993          	srli	s3,s3,0x20
    return -1;
  }

  if(tx_mbufs[index] != 0){
    80005a14:	00349713          	slli	a4,s1,0x3
    80005a18:	00015797          	auipc	a5,0x15
    80005a1c:	4c878793          	addi	a5,a5,1224 # 8001aee0 <e1000_lock>
    80005a20:	97ba                	add	a5,a5,a4
    80005a22:	1207b503          	ld	a0,288(a5)
    80005a26:	c509                	beqz	a0,80005a30 <e1000_transmit+0x68>
    mbuffree(tx_mbufs[index]);
    80005a28:	00000097          	auipc	ra,0x0
    80005a2c:	344080e7          	jalr	836(ra) # 80005d6c <mbuffree>
  }

  tx_mbufs[index] = m;
    80005a30:	00015517          	auipc	a0,0x15
    80005a34:	4b050513          	addi	a0,a0,1200 # 8001aee0 <e1000_lock>
    80005a38:	00349793          	slli	a5,s1,0x3
    80005a3c:	97aa                	add	a5,a5,a0
    80005a3e:	1327b023          	sd	s2,288(a5)
  tx_ring[index].addr = (uint64)m->head;
    80005a42:	0492                	slli	s1,s1,0x4
    80005a44:	94aa                	add	s1,s1,a0
    80005a46:	00893783          	ld	a5,8(s2)
    80005a4a:	f09c                	sd	a5,32(s1)
  tx_ring[index].length = (uint16)m->len;
    80005a4c:	01092783          	lw	a5,16(s2)
    80005a50:	02f49423          	sh	a5,40(s1)
  tx_ring[index].cmd = (uint8)(E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS);
    80005a54:	47a5                	li	a5,9
    80005a56:	02f485a3          	sb	a5,43(s1)
  tx_ring[index].status = 0;
    80005a5a:	02048623          	sb	zero,44(s1)


  tdt = (tdt + 1) % TX_RING_SIZE;
    80005a5e:	0985                	addi	s3,s3,1
  regs[E1000_TDT] = tdt;
    80005a60:	00f9f993          	andi	s3,s3,15
    80005a64:	00004797          	auipc	a5,0x4
    80005a68:	efc7b783          	ld	a5,-260(a5) # 80009960 <regs>
    80005a6c:	6711                	lui	a4,0x4
    80005a6e:	97ba                	add	a5,a5,a4
    80005a70:	8137ac23          	sw	s3,-2024(a5)
  release(&e1000_lock);
    80005a74:	00002097          	auipc	ra,0x2
    80005a78:	81c080e7          	jalr	-2020(ra) # 80007290 <release>

  return 0;
    80005a7c:	4501                	li	a0,0

}
    80005a7e:	70a2                	ld	ra,40(sp)
    80005a80:	7402                	ld	s0,32(sp)
    80005a82:	64e2                	ld	s1,24(sp)
    80005a84:	6942                	ld	s2,16(sp)
    80005a86:	69a2                	ld	s3,8(sp)
    80005a88:	6a02                	ld	s4,0(sp)
    80005a8a:	6145                	addi	sp,sp,48
    80005a8c:	8082                	ret
    return -1;
    80005a8e:	557d                	li	a0,-1
    80005a90:	b7fd                	j	80005a7e <e1000_transmit+0xb6>

0000000080005a92 <e1000_intr>:

}

void
e1000_intr(void)
{
    80005a92:	715d                	addi	sp,sp,-80
    80005a94:	e486                	sd	ra,72(sp)
    80005a96:	e0a2                	sd	s0,64(sp)
    80005a98:	fc26                	sd	s1,56(sp)
    80005a9a:	f84a                	sd	s2,48(sp)
    80005a9c:	f44e                	sd	s3,40(sp)
    80005a9e:	f052                	sd	s4,32(sp)
    80005aa0:	ec56                	sd	s5,24(sp)
    80005aa2:	e85a                	sd	s6,16(sp)
    80005aa4:	e45e                	sd	s7,8(sp)
    80005aa6:	0880                	addi	s0,sp,80
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005aa8:	00004797          	auipc	a5,0x4
    80005aac:	eb87b783          	ld	a5,-328(a5) # 80009960 <regs>
    80005ab0:	577d                	li	a4,-1
    80005ab2:	0ce7a023          	sw	a4,192(a5)
  uint64 rdt = regs[E1000_RDT];
    80005ab6:	670d                	lui	a4,0x3
    80005ab8:	97ba                	add	a5,a5,a4
    80005aba:	8187a483          	lw	s1,-2024(a5)
  uint64 index = (rdt + 1) % RX_RING_SIZE;
    80005abe:	0485                	addi	s1,s1,1
    80005ac0:	88bd                	andi	s1,s1,15
  while((rx_ring[index].status & E1000_RXD_STAT_DD) != 0)
    80005ac2:	00449713          	slli	a4,s1,0x4
    80005ac6:	00015797          	auipc	a5,0x15
    80005aca:	41a78793          	addi	a5,a5,1050 # 8001aee0 <e1000_lock>
    80005ace:	97ba                	add	a5,a5,a4
    80005ad0:	1ac7c783          	lbu	a5,428(a5)
    80005ad4:	8b85                	andi	a5,a5,1
    80005ad6:	c3d1                	beqz	a5,80005b5a <e1000_intr+0xc8>
    acquire(&e1000_lock);
    80005ad8:	00015997          	auipc	s3,0x15
    80005adc:	40898993          	addi	s3,s3,1032 # 8001aee0 <e1000_lock>
    regs[E1000_RDT] = index;
    80005ae0:	00004b17          	auipc	s6,0x4
    80005ae4:	e80b0b13          	addi	s6,s6,-384 # 80009960 <regs>
    80005ae8:	6a8d                	lui	s5,0x3
    acquire(&e1000_lock);
    80005aea:	854e                	mv	a0,s3
    80005aec:	00001097          	auipc	ra,0x1
    80005af0:	6f0080e7          	jalr	1776(ra) # 800071dc <acquire>
    struct mbuf* mbuf = rx_mbufs[index];
    80005af4:	00349a13          	slli	s4,s1,0x3
    80005af8:	9a4e                	add	s4,s4,s3
    80005afa:	2a0a3b83          	ld	s7,672(s4)
    mbuf->len = rx_ring[index].length;
    80005afe:	00449913          	slli	s2,s1,0x4
    80005b02:	994e                	add	s2,s2,s3
    80005b04:	1a895783          	lhu	a5,424(s2)
    80005b08:	00fba823          	sw	a5,16(s7) # 1010 <_entry-0x7fffeff0>
    rx_mbufs[index] = mbufalloc(0);
    80005b0c:	4501                	li	a0,0
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	206080e7          	jalr	518(ra) # 80005d14 <mbufalloc>
    80005b16:	2aaa3023          	sd	a0,672(s4)
    rx_ring[index].addr = (uint64)rx_mbufs[index]->head;
    80005b1a:	651c                	ld	a5,8(a0)
    80005b1c:	1af93023          	sd	a5,416(s2)
    rx_ring[index].status = 0;
    80005b20:	1a090623          	sb	zero,428(s2)
    release(&e1000_lock);
    80005b24:	854e                	mv	a0,s3
    80005b26:	00001097          	auipc	ra,0x1
    80005b2a:	76a080e7          	jalr	1898(ra) # 80007290 <release>
    net_rx(mbuf);
    80005b2e:	855e                	mv	a0,s7
    80005b30:	00000097          	auipc	ra,0x0
    80005b34:	3b0080e7          	jalr	944(ra) # 80005ee0 <net_rx>
    regs[E1000_RDT] = index;
    80005b38:	000b3783          	ld	a5,0(s6)
    80005b3c:	2481                	sext.w	s1,s1
    80005b3e:	97d6                	add	a5,a5,s5
    80005b40:	8097ac23          	sw	s1,-2024(a5)
    index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005b44:	8187a483          	lw	s1,-2024(a5)
    80005b48:	2485                	addiw	s1,s1,1
    80005b4a:	88bd                	andi	s1,s1,15
  while((rx_ring[index].status & E1000_RXD_STAT_DD) != 0)
    80005b4c:	00449793          	slli	a5,s1,0x4
    80005b50:	97ce                	add	a5,a5,s3
    80005b52:	1ac7c783          	lbu	a5,428(a5)
    80005b56:	8b85                	andi	a5,a5,1
    80005b58:	fbc9                	bnez	a5,80005aea <e1000_intr+0x58>

  e1000_recv();
}
    80005b5a:	60a6                	ld	ra,72(sp)
    80005b5c:	6406                	ld	s0,64(sp)
    80005b5e:	74e2                	ld	s1,56(sp)
    80005b60:	7942                	ld	s2,48(sp)
    80005b62:	79a2                	ld	s3,40(sp)
    80005b64:	7a02                	ld	s4,32(sp)
    80005b66:	6ae2                	ld	s5,24(sp)
    80005b68:	6b42                	ld	s6,16(sp)
    80005b6a:	6ba2                	ld	s7,8(sp)
    80005b6c:	6161                	addi	sp,sp,80
    80005b6e:	8082                	ret

0000000080005b70 <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005b70:	1101                	addi	sp,sp,-32
    80005b72:	ec22                	sd	s0,24(sp)
    80005b74:	1000                	addi	s0,sp,32
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;
    80005b76:	fe041723          	sh	zero,-18(s0)
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005b7a:	4785                	li	a5,1
    80005b7c:	04b7d963          	bge	a5,a1,80005bce <in_cksum+0x5e>
    80005b80:	ffe5879b          	addiw	a5,a1,-2
    80005b84:	0017d61b          	srliw	a2,a5,0x1
    80005b88:	0017d71b          	srliw	a4,a5,0x1
    80005b8c:	0705                	addi	a4,a4,1
    80005b8e:	0706                	slli	a4,a4,0x1
    80005b90:	972a                	add	a4,a4,a0
  unsigned int sum = 0;
    80005b92:	4781                	li	a5,0
    sum += *w++;
    80005b94:	0509                	addi	a0,a0,2
    80005b96:	ffe55683          	lhu	a3,-2(a0)
    80005b9a:	9fb5                	addw	a5,a5,a3
  while (nleft > 1)  {
    80005b9c:	fee51ce3          	bne	a0,a4,80005b94 <in_cksum+0x24>
    80005ba0:	35f9                	addiw	a1,a1,-2
    80005ba2:	0016169b          	slliw	a3,a2,0x1
    80005ba6:	9d95                	subw	a1,a1,a3
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005ba8:	4685                	li	a3,1
    80005baa:	02d58563          	beq	a1,a3,80005bd4 <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005bae:	03079513          	slli	a0,a5,0x30
    80005bb2:	9141                	srli	a0,a0,0x30
    80005bb4:	0107d79b          	srliw	a5,a5,0x10
    80005bb8:	9fa9                	addw	a5,a5,a0
  sum += (sum >> 16);
    80005bba:	0107d51b          	srliw	a0,a5,0x10
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005bbe:	9d3d                	addw	a0,a0,a5
    80005bc0:	fff54513          	not	a0,a0
  return answer;
}
    80005bc4:	1542                	slli	a0,a0,0x30
    80005bc6:	9141                	srli	a0,a0,0x30
    80005bc8:	6462                	ld	s0,24(sp)
    80005bca:	6105                	addi	sp,sp,32
    80005bcc:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005bce:	872a                	mv	a4,a0
  unsigned int sum = 0;
    80005bd0:	4781                	li	a5,0
    80005bd2:	bfd9                	j	80005ba8 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005bd4:	00074703          	lbu	a4,0(a4) # 3000 <_entry-0x7fffd000>
    80005bd8:	fee40723          	sb	a4,-18(s0)
    sum += answer;
    80005bdc:	fee45703          	lhu	a4,-18(s0)
    80005be0:	9fb9                	addw	a5,a5,a4
    80005be2:	b7f1                	j	80005bae <in_cksum+0x3e>

0000000080005be4 <mbufpull>:
{
    80005be4:	1141                	addi	sp,sp,-16
    80005be6:	e422                	sd	s0,8(sp)
    80005be8:	0800                	addi	s0,sp,16
    80005bea:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005bec:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005bee:	4b98                	lw	a4,16(a5)
    80005bf0:	00b76b63          	bltu	a4,a1,80005c06 <mbufpull+0x22>
  m->len -= len;
    80005bf4:	9f0d                	subw	a4,a4,a1
    80005bf6:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005bf8:	1582                	slli	a1,a1,0x20
    80005bfa:	9181                	srli	a1,a1,0x20
    80005bfc:	95aa                	add	a1,a1,a0
    80005bfe:	e78c                	sd	a1,8(a5)
}
    80005c00:	6422                	ld	s0,8(sp)
    80005c02:	0141                	addi	sp,sp,16
    80005c04:	8082                	ret
    return 0;
    80005c06:	4501                	li	a0,0
    80005c08:	bfe5                	j	80005c00 <mbufpull+0x1c>

0000000080005c0a <mbufpush>:
{
    80005c0a:	87aa                	mv	a5,a0
  m->head -= len;
    80005c0c:	02059713          	slli	a4,a1,0x20
    80005c10:	9301                	srli	a4,a4,0x20
    80005c12:	6508                	ld	a0,8(a0)
    80005c14:	8d19                	sub	a0,a0,a4
    80005c16:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005c18:	01478713          	addi	a4,a5,20
    80005c1c:	00e56663          	bltu	a0,a4,80005c28 <mbufpush+0x1e>
  m->len += len;
    80005c20:	4b98                	lw	a4,16(a5)
    80005c22:	9db9                	addw	a1,a1,a4
    80005c24:	cb8c                	sw	a1,16(a5)
}
    80005c26:	8082                	ret
{
    80005c28:	1141                	addi	sp,sp,-16
    80005c2a:	e406                	sd	ra,8(sp)
    80005c2c:	e022                	sd	s0,0(sp)
    80005c2e:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005c30:	00004517          	auipc	a0,0x4
    80005c34:	be850513          	addi	a0,a0,-1048 # 80009818 <syscalls+0x438>
    80005c38:	00001097          	auipc	ra,0x1
    80005c3c:	05a080e7          	jalr	90(ra) # 80006c92 <panic>

0000000080005c40 <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005c40:	7179                	addi	sp,sp,-48
    80005c42:	f406                	sd	ra,40(sp)
    80005c44:	f022                	sd	s0,32(sp)
    80005c46:	ec26                	sd	s1,24(sp)
    80005c48:	e84a                	sd	s2,16(sp)
    80005c4a:	e44e                	sd	s3,8(sp)
    80005c4c:	1800                	addi	s0,sp,48
    80005c4e:	89aa                	mv	s3,a0
    80005c50:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005c52:	45b9                	li	a1,14
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	fb6080e7          	jalr	-74(ra) # 80005c0a <mbufpush>
    80005c5c:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005c5e:	4619                	li	a2,6
    80005c60:	00004597          	auipc	a1,0x4
    80005c64:	c7058593          	addi	a1,a1,-912 # 800098d0 <local_mac>
    80005c68:	0519                	addi	a0,a0,6
    80005c6a:	ffffa097          	auipc	ra,0xffffa
    80005c6e:	56e080e7          	jalr	1390(ra) # 800001d8 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005c72:	4619                	li	a2,6
    80005c74:	00004597          	auipc	a1,0x4
    80005c78:	c5458593          	addi	a1,a1,-940 # 800098c8 <broadcast_mac>
    80005c7c:	8526                	mv	a0,s1
    80005c7e:	ffffa097          	auipc	ra,0xffffa
    80005c82:	55a080e7          	jalr	1370(ra) # 800001d8 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005c86:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005c8a:	00f48623          	sb	a5,12(s1)
    80005c8e:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005c92:	854e                	mv	a0,s3
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	d34080e7          	jalr	-716(ra) # 800059c8 <e1000_transmit>
    80005c9c:	e901                	bnez	a0,80005cac <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005c9e:	70a2                	ld	ra,40(sp)
    80005ca0:	7402                	ld	s0,32(sp)
    80005ca2:	64e2                	ld	s1,24(sp)
    80005ca4:	6942                	ld	s2,16(sp)
    80005ca6:	69a2                	ld	s3,8(sp)
    80005ca8:	6145                	addi	sp,sp,48
    80005caa:	8082                	ret
  kfree(m);
    80005cac:	854e                	mv	a0,s3
    80005cae:	ffffa097          	auipc	ra,0xffffa
    80005cb2:	36e080e7          	jalr	878(ra) # 8000001c <kfree>
}
    80005cb6:	b7e5                	j	80005c9e <net_tx_eth+0x5e>

0000000080005cb8 <mbufput>:
{
    80005cb8:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005cba:	4918                	lw	a4,16(a0)
    80005cbc:	02071693          	slli	a3,a4,0x20
    80005cc0:	9281                	srli	a3,a3,0x20
    80005cc2:	6508                	ld	a0,8(a0)
    80005cc4:	9536                	add	a0,a0,a3
  m->len += len;
    80005cc6:	9f2d                	addw	a4,a4,a1
    80005cc8:	0007069b          	sext.w	a3,a4
    80005ccc:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005cce:	6785                	lui	a5,0x1
    80005cd0:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005cd4:	00d7e363          	bltu	a5,a3,80005cda <mbufput+0x22>
}
    80005cd8:	8082                	ret
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e406                	sd	ra,8(sp)
    80005cde:	e022                	sd	s0,0(sp)
    80005ce0:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005ce2:	00004517          	auipc	a0,0x4
    80005ce6:	b4650513          	addi	a0,a0,-1210 # 80009828 <syscalls+0x448>
    80005cea:	00001097          	auipc	ra,0x1
    80005cee:	fa8080e7          	jalr	-88(ra) # 80006c92 <panic>

0000000080005cf2 <mbuftrim>:
{
    80005cf2:	1141                	addi	sp,sp,-16
    80005cf4:	e422                	sd	s0,8(sp)
    80005cf6:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005cf8:	491c                	lw	a5,16(a0)
    80005cfa:	00b7eb63          	bltu	a5,a1,80005d10 <mbuftrim+0x1e>
  m->len -= len;
    80005cfe:	9f8d                	subw	a5,a5,a1
    80005d00:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005d02:	1782                	slli	a5,a5,0x20
    80005d04:	9381                	srli	a5,a5,0x20
    80005d06:	6508                	ld	a0,8(a0)
    80005d08:	953e                	add	a0,a0,a5
}
    80005d0a:	6422                	ld	s0,8(sp)
    80005d0c:	0141                	addi	sp,sp,16
    80005d0e:	8082                	ret
    return 0;
    80005d10:	4501                	li	a0,0
    80005d12:	bfe5                	j	80005d0a <mbuftrim+0x18>

0000000080005d14 <mbufalloc>:
{
    80005d14:	1101                	addi	sp,sp,-32
    80005d16:	ec06                	sd	ra,24(sp)
    80005d18:	e822                	sd	s0,16(sp)
    80005d1a:	e426                	sd	s1,8(sp)
    80005d1c:	e04a                	sd	s2,0(sp)
    80005d1e:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005d20:	6785                	lui	a5,0x1
    80005d22:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005d26:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005d28:	02a7eb63          	bltu	a5,a0,80005d5e <mbufalloc+0x4a>
    80005d2c:	84aa                	mv	s1,a0
  m = kalloc();
    80005d2e:	ffffa097          	auipc	ra,0xffffa
    80005d32:	3ea080e7          	jalr	1002(ra) # 80000118 <kalloc>
    80005d36:	892a                	mv	s2,a0
  if (m == 0)
    80005d38:	c11d                	beqz	a0,80005d5e <mbufalloc+0x4a>
  m->next = 0;
    80005d3a:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005d3e:	0551                	addi	a0,a0,20
    80005d40:	1482                	slli	s1,s1,0x20
    80005d42:	9081                	srli	s1,s1,0x20
    80005d44:	94aa                	add	s1,s1,a0
    80005d46:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005d4a:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005d4e:	6605                	lui	a2,0x1
    80005d50:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005d54:	4581                	li	a1,0
    80005d56:	ffffa097          	auipc	ra,0xffffa
    80005d5a:	422080e7          	jalr	1058(ra) # 80000178 <memset>
}
    80005d5e:	854a                	mv	a0,s2
    80005d60:	60e2                	ld	ra,24(sp)
    80005d62:	6442                	ld	s0,16(sp)
    80005d64:	64a2                	ld	s1,8(sp)
    80005d66:	6902                	ld	s2,0(sp)
    80005d68:	6105                	addi	sp,sp,32
    80005d6a:	8082                	ret

0000000080005d6c <mbuffree>:
{
    80005d6c:	1141                	addi	sp,sp,-16
    80005d6e:	e406                	sd	ra,8(sp)
    80005d70:	e022                	sd	s0,0(sp)
    80005d72:	0800                	addi	s0,sp,16
  kfree(m);
    80005d74:	ffffa097          	auipc	ra,0xffffa
    80005d78:	2a8080e7          	jalr	680(ra) # 8000001c <kfree>
}
    80005d7c:	60a2                	ld	ra,8(sp)
    80005d7e:	6402                	ld	s0,0(sp)
    80005d80:	0141                	addi	sp,sp,16
    80005d82:	8082                	ret

0000000080005d84 <mbufq_pushtail>:
{
    80005d84:	1141                	addi	sp,sp,-16
    80005d86:	e422                	sd	s0,8(sp)
    80005d88:	0800                	addi	s0,sp,16
  m->next = 0;
    80005d8a:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005d8e:	611c                	ld	a5,0(a0)
    80005d90:	c799                	beqz	a5,80005d9e <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005d92:	651c                	ld	a5,8(a0)
    80005d94:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005d96:	e50c                	sd	a1,8(a0)
}
    80005d98:	6422                	ld	s0,8(sp)
    80005d9a:	0141                	addi	sp,sp,16
    80005d9c:	8082                	ret
    q->head = q->tail = m;
    80005d9e:	e50c                	sd	a1,8(a0)
    80005da0:	e10c                	sd	a1,0(a0)
    return;
    80005da2:	bfdd                	j	80005d98 <mbufq_pushtail+0x14>

0000000080005da4 <mbufq_pophead>:
{
    80005da4:	1141                	addi	sp,sp,-16
    80005da6:	e422                	sd	s0,8(sp)
    80005da8:	0800                	addi	s0,sp,16
    80005daa:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005dac:	6108                	ld	a0,0(a0)
  if (!head)
    80005dae:	c119                	beqz	a0,80005db4 <mbufq_pophead+0x10>
  q->head = head->next;
    80005db0:	6118                	ld	a4,0(a0)
    80005db2:	e398                	sd	a4,0(a5)
}
    80005db4:	6422                	ld	s0,8(sp)
    80005db6:	0141                	addi	sp,sp,16
    80005db8:	8082                	ret

0000000080005dba <mbufq_empty>:
{
    80005dba:	1141                	addi	sp,sp,-16
    80005dbc:	e422                	sd	s0,8(sp)
    80005dbe:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005dc0:	6108                	ld	a0,0(a0)
}
    80005dc2:	00153513          	seqz	a0,a0
    80005dc6:	6422                	ld	s0,8(sp)
    80005dc8:	0141                	addi	sp,sp,16
    80005dca:	8082                	ret

0000000080005dcc <mbufq_init>:
{
    80005dcc:	1141                	addi	sp,sp,-16
    80005dce:	e422                	sd	s0,8(sp)
    80005dd0:	0800                	addi	s0,sp,16
  q->head = 0;
    80005dd2:	00053023          	sd	zero,0(a0)
}
    80005dd6:	6422                	ld	s0,8(sp)
    80005dd8:	0141                	addi	sp,sp,16
    80005dda:	8082                	ret

0000000080005ddc <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005ddc:	7179                	addi	sp,sp,-48
    80005dde:	f406                	sd	ra,40(sp)
    80005de0:	f022                	sd	s0,32(sp)
    80005de2:	ec26                	sd	s1,24(sp)
    80005de4:	e84a                	sd	s2,16(sp)
    80005de6:	e44e                	sd	s3,8(sp)
    80005de8:	e052                	sd	s4,0(sp)
    80005dea:	1800                	addi	s0,sp,48
    80005dec:	8a2a                	mv	s4,a0
    80005dee:	892e                	mv	s2,a1
    80005df0:	89b2                	mv	s3,a2
    80005df2:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005df4:	45a1                	li	a1,8
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	e14080e7          	jalr	-492(ra) # 80005c0a <mbufpush>
    80005dfe:	0089d61b          	srliw	a2,s3,0x8
    80005e02:	0089999b          	slliw	s3,s3,0x8
    80005e06:	00c9e9b3          	or	s3,s3,a2
  udphdr->sport = htons(sport);
    80005e0a:	01351023          	sh	s3,0(a0)
    80005e0e:	0084d69b          	srliw	a3,s1,0x8
    80005e12:	0084949b          	slliw	s1,s1,0x8
    80005e16:	8cd5                	or	s1,s1,a3
  udphdr->dport = htons(dport);
    80005e18:	00951123          	sh	s1,2(a0)
  udphdr->ulen = htons(m->len);
    80005e1c:	010a2783          	lw	a5,16(s4)
    80005e20:	0087d713          	srli	a4,a5,0x8
    80005e24:	0087979b          	slliw	a5,a5,0x8
    80005e28:	0ff77713          	andi	a4,a4,255
    80005e2c:	8fd9                	or	a5,a5,a4
    80005e2e:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005e32:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005e36:	45d1                	li	a1,20
    80005e38:	8552                	mv	a0,s4
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	dd0080e7          	jalr	-560(ra) # 80005c0a <mbufpush>
    80005e42:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005e44:	4651                	li	a2,20
    80005e46:	4581                	li	a1,0
    80005e48:	ffffa097          	auipc	ra,0xffffa
    80005e4c:	330080e7          	jalr	816(ra) # 80000178 <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005e50:	04500793          	li	a5,69
    80005e54:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005e58:	47c5                	li	a5,17
    80005e5a:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005e5e:	0f0207b7          	lui	a5,0xf020
    80005e62:	27a9                	addiw	a5,a5,10
    80005e64:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005e66:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005e6a:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005e6e:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005e70:	0089171b          	slliw	a4,s2,0x8
    80005e74:	00ff06b7          	lui	a3,0xff0
    80005e78:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005e7a:	8fd9                	or	a5,a5,a4
    80005e7c:	0089591b          	srliw	s2,s2,0x8
    80005e80:	65c1                	lui	a1,0x10
    80005e82:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005e86:	00b97933          	and	s2,s2,a1
    80005e8a:	0127e933          	or	s2,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005e8e:	0124a823          	sw	s2,16(s1)
  iphdr->ip_len = htons(m->len);
    80005e92:	010a2783          	lw	a5,16(s4)
  return (((val & 0x00ffU) << 8) |
    80005e96:	0087d713          	srli	a4,a5,0x8
    80005e9a:	0087979b          	slliw	a5,a5,0x8
    80005e9e:	0ff77713          	andi	a4,a4,255
    80005ea2:	8fd9                	or	a5,a5,a4
    80005ea4:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005ea8:	06400793          	li	a5,100
    80005eac:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005eb0:	45d1                	li	a1,20
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	cbc080e7          	jalr	-836(ra) # 80005b70 <in_cksum>
    80005ebc:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005ec0:	6585                	lui	a1,0x1
    80005ec2:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005ec6:	8552                	mv	a0,s4
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	d78080e7          	jalr	-648(ra) # 80005c40 <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005ed0:	70a2                	ld	ra,40(sp)
    80005ed2:	7402                	ld	s0,32(sp)
    80005ed4:	64e2                	ld	s1,24(sp)
    80005ed6:	6942                	ld	s2,16(sp)
    80005ed8:	69a2                	ld	s3,8(sp)
    80005eda:	6a02                	ld	s4,0(sp)
    80005edc:	6145                	addi	sp,sp,48
    80005ede:	8082                	ret

0000000080005ee0 <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005ee0:	715d                	addi	sp,sp,-80
    80005ee2:	e486                	sd	ra,72(sp)
    80005ee4:	e0a2                	sd	s0,64(sp)
    80005ee6:	fc26                	sd	s1,56(sp)
    80005ee8:	f84a                	sd	s2,48(sp)
    80005eea:	f44e                	sd	s3,40(sp)
    80005eec:	f052                	sd	s4,32(sp)
    80005eee:	ec56                	sd	s5,24(sp)
    80005ef0:	0880                	addi	s0,sp,80
    80005ef2:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005ef4:	45b9                	li	a1,14
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	cee080e7          	jalr	-786(ra) # 80005be4 <mbufpull>
  if (!ethhdr) {
    80005efe:	c521                	beqz	a0,80005f46 <net_rx+0x66>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005f00:	00c54783          	lbu	a5,12(a0)
    80005f04:	00d54703          	lbu	a4,13(a0)
    80005f08:	0722                	slli	a4,a4,0x8
    80005f0a:	8fd9                	or	a5,a5,a4
    80005f0c:	0087979b          	slliw	a5,a5,0x8
    80005f10:	8321                	srli	a4,a4,0x8
    80005f12:	8fd9                	or	a5,a5,a4
    80005f14:	17c2                	slli	a5,a5,0x30
    80005f16:	93c1                	srli	a5,a5,0x30
  if (type == ETHTYPE_IP)
    80005f18:	8007871b          	addiw	a4,a5,-2048
    80005f1c:	cb1d                	beqz	a4,80005f52 <net_rx+0x72>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005f1e:	2781                	sext.w	a5,a5
    80005f20:	6705                	lui	a4,0x1
    80005f22:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    80005f26:	18e78e63          	beq	a5,a4,800060c2 <net_rx+0x1e2>
  kfree(m);
    80005f2a:	8526                	mv	a0,s1
    80005f2c:	ffffa097          	auipc	ra,0xffffa
    80005f30:	0f0080e7          	jalr	240(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005f34:	60a6                	ld	ra,72(sp)
    80005f36:	6406                	ld	s0,64(sp)
    80005f38:	74e2                	ld	s1,56(sp)
    80005f3a:	7942                	ld	s2,48(sp)
    80005f3c:	79a2                	ld	s3,40(sp)
    80005f3e:	7a02                	ld	s4,32(sp)
    80005f40:	6ae2                	ld	s5,24(sp)
    80005f42:	6161                	addi	sp,sp,80
    80005f44:	8082                	ret
  kfree(m);
    80005f46:	8526                	mv	a0,s1
    80005f48:	ffffa097          	auipc	ra,0xffffa
    80005f4c:	0d4080e7          	jalr	212(ra) # 8000001c <kfree>
}
    80005f50:	b7d5                	j	80005f34 <net_rx+0x54>
  iphdr = mbufpullhdr(m, *iphdr);
    80005f52:	45d1                	li	a1,20
    80005f54:	8526                	mv	a0,s1
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	c8e080e7          	jalr	-882(ra) # 80005be4 <mbufpull>
    80005f5e:	892a                	mv	s2,a0
  if (!iphdr)
    80005f60:	c519                	beqz	a0,80005f6e <net_rx+0x8e>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005f62:	00054703          	lbu	a4,0(a0)
    80005f66:	04500793          	li	a5,69
    80005f6a:	00f70863          	beq	a4,a5,80005f7a <net_rx+0x9a>
  kfree(m);
    80005f6e:	8526                	mv	a0,s1
    80005f70:	ffffa097          	auipc	ra,0xffffa
    80005f74:	0ac080e7          	jalr	172(ra) # 8000001c <kfree>
}
    80005f78:	bf75                	j	80005f34 <net_rx+0x54>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005f7a:	45d1                	li	a1,20
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	bf4080e7          	jalr	-1036(ra) # 80005b70 <in_cksum>
    80005f84:	f56d                	bnez	a0,80005f6e <net_rx+0x8e>
    80005f86:	00695783          	lhu	a5,6(s2)
    80005f8a:	0087d713          	srli	a4,a5,0x8
    80005f8e:	0087979b          	slliw	a5,a5,0x8
    80005f92:	0ff77713          	andi	a4,a4,255
    80005f96:	8fd9                	or	a5,a5,a4
  if (htons(iphdr->ip_off) != 0)
    80005f98:	17c2                	slli	a5,a5,0x30
    80005f9a:	93c1                	srli	a5,a5,0x30
    80005f9c:	fbe9                	bnez	a5,80005f6e <net_rx+0x8e>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005f9e:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005fa2:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005fa6:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005faa:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005fac:	0087169b          	slliw	a3,a4,0x8
    80005fb0:	00ff0637          	lui	a2,0xff0
    80005fb4:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005fb6:	8fd5                	or	a5,a5,a3
    80005fb8:	0087571b          	srliw	a4,a4,0x8
    80005fbc:	66c1                	lui	a3,0x10
    80005fbe:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005fc2:	8f75                	and	a4,a4,a3
    80005fc4:	8fd9                	or	a5,a5,a4
    80005fc6:	2781                	sext.w	a5,a5
    80005fc8:	0a000737          	lui	a4,0xa000
    80005fcc:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005fd0:	f8e79fe3          	bne	a5,a4,80005f6e <net_rx+0x8e>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005fd4:	00994703          	lbu	a4,9(s2)
    80005fd8:	47c5                	li	a5,17
    80005fda:	f8f71ae3          	bne	a4,a5,80005f6e <net_rx+0x8e>
  return (((val & 0x00ffU) << 8) |
    80005fde:	00295783          	lhu	a5,2(s2)
    80005fe2:	0087d713          	srli	a4,a5,0x8
    80005fe6:	0087999b          	slliw	s3,a5,0x8
    80005fea:	0ff77793          	andi	a5,a4,255
    80005fee:	00f9e9b3          	or	s3,s3,a5
    80005ff2:	19c2                	slli	s3,s3,0x30
    80005ff4:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005ff8:	fec9879b          	addiw	a5,s3,-20
    80005ffc:	03079a13          	slli	s4,a5,0x30
    80006000:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80006004:	45a1                	li	a1,8
    80006006:	8526                	mv	a0,s1
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	bdc080e7          	jalr	-1060(ra) # 80005be4 <mbufpull>
    80006010:	8aaa                	mv	s5,a0
  if (!udphdr)
    80006012:	c915                	beqz	a0,80006046 <net_rx+0x166>
    80006014:	00455783          	lhu	a5,4(a0)
    80006018:	0087d713          	srli	a4,a5,0x8
    8000601c:	0087979b          	slliw	a5,a5,0x8
    80006020:	0ff77713          	andi	a4,a4,255
    80006024:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80006026:	2a01                	sext.w	s4,s4
    80006028:	17c2                	slli	a5,a5,0x30
    8000602a:	93c1                	srli	a5,a5,0x30
    8000602c:	00fa1d63          	bne	s4,a5,80006046 <net_rx+0x166>
  len -= sizeof(*udphdr);
    80006030:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80006034:	0107979b          	slliw	a5,a5,0x10
    80006038:	0107d79b          	srliw	a5,a5,0x10
    8000603c:	0007871b          	sext.w	a4,a5
    80006040:	488c                	lw	a1,16(s1)
    80006042:	00e5f863          	bgeu	a1,a4,80006052 <net_rx+0x172>
  kfree(m);
    80006046:	8526                	mv	a0,s1
    80006048:	ffffa097          	auipc	ra,0xffffa
    8000604c:	fd4080e7          	jalr	-44(ra) # 8000001c <kfree>
}
    80006050:	b5d5                	j	80005f34 <net_rx+0x54>
  mbuftrim(m, m->len - len);
    80006052:	9d9d                	subw	a1,a1,a5
    80006054:	8526                	mv	a0,s1
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	c9c080e7          	jalr	-868(ra) # 80005cf2 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    8000605e:	00c92783          	lw	a5,12(s2)
    80006062:	000ad703          	lhu	a4,0(s5) # 3000 <_entry-0x7fffd000>
    80006066:	00875693          	srli	a3,a4,0x8
    8000606a:	0087171b          	slliw	a4,a4,0x8
    8000606e:	0ff6f693          	andi	a3,a3,255
    80006072:	8ed9                	or	a3,a3,a4
    80006074:	002ad703          	lhu	a4,2(s5)
    80006078:	00875613          	srli	a2,a4,0x8
    8000607c:	0087171b          	slliw	a4,a4,0x8
    80006080:	0ff67613          	andi	a2,a2,255
    80006084:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80006086:	0187971b          	slliw	a4,a5,0x18
          ((val & 0xff000000UL) >> 24));
    8000608a:	0187d59b          	srliw	a1,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000608e:	8f4d                	or	a4,a4,a1
          ((val & 0x0000ff00UL) << 8) |
    80006090:	0087959b          	slliw	a1,a5,0x8
    80006094:	00ff0537          	lui	a0,0xff0
    80006098:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) |
    8000609a:	8f4d                	or	a4,a4,a1
    8000609c:	0087d79b          	srliw	a5,a5,0x8
    800060a0:	65c1                	lui	a1,0x10
    800060a2:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    800060a6:	8fed                	and	a5,a5,a1
    800060a8:	8fd9                	or	a5,a5,a4
  sockrecvudp(m, sip, dport, sport);
    800060aa:	16c2                	slli	a3,a3,0x30
    800060ac:	92c1                	srli	a3,a3,0x30
    800060ae:	1642                	slli	a2,a2,0x30
    800060b0:	9241                	srli	a2,a2,0x30
    800060b2:	0007859b          	sext.w	a1,a5
    800060b6:	8526                	mv	a0,s1
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	55c080e7          	jalr	1372(ra) # 80006614 <sockrecvudp>
  return;
    800060c0:	bd95                	j	80005f34 <net_rx+0x54>
  arphdr = mbufpullhdr(m, *arphdr);
    800060c2:	45f1                	li	a1,28
    800060c4:	8526                	mv	a0,s1
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	b1e080e7          	jalr	-1250(ra) # 80005be4 <mbufpull>
    800060ce:	892a                	mv	s2,a0
  if (!arphdr)
    800060d0:	c179                	beqz	a0,80006196 <net_rx+0x2b6>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    800060d2:	00054783          	lbu	a5,0(a0) # ff0000 <_entry-0x7f010000>
    800060d6:	00154703          	lbu	a4,1(a0)
    800060da:	0722                	slli	a4,a4,0x8
    800060dc:	8fd9                	or	a5,a5,a4
  return (((val & 0x00ffU) << 8) |
    800060de:	0087979b          	slliw	a5,a5,0x8
    800060e2:	8321                	srli	a4,a4,0x8
    800060e4:	8fd9                	or	a5,a5,a4
    800060e6:	17c2                	slli	a5,a5,0x30
    800060e8:	93c1                	srli	a5,a5,0x30
    800060ea:	4705                	li	a4,1
    800060ec:	0ae79563          	bne	a5,a4,80006196 <net_rx+0x2b6>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    800060f0:	00254783          	lbu	a5,2(a0)
    800060f4:	00354703          	lbu	a4,3(a0)
    800060f8:	0722                	slli	a4,a4,0x8
    800060fa:	8fd9                	or	a5,a5,a4
    800060fc:	0087979b          	slliw	a5,a5,0x8
    80006100:	8321                	srli	a4,a4,0x8
    80006102:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80006104:	0107979b          	slliw	a5,a5,0x10
    80006108:	0107d79b          	srliw	a5,a5,0x10
    8000610c:	8007879b          	addiw	a5,a5,-2048
    80006110:	e3d9                	bnez	a5,80006196 <net_rx+0x2b6>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80006112:	00454703          	lbu	a4,4(a0)
    80006116:	4799                	li	a5,6
    80006118:	06f71f63          	bne	a4,a5,80006196 <net_rx+0x2b6>
      arphdr->hln != ETHADDR_LEN ||
    8000611c:	00554703          	lbu	a4,5(a0)
    80006120:	4791                	li	a5,4
    80006122:	06f71a63          	bne	a4,a5,80006196 <net_rx+0x2b6>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80006126:	00654783          	lbu	a5,6(a0)
    8000612a:	00754703          	lbu	a4,7(a0)
    8000612e:	0722                	slli	a4,a4,0x8
    80006130:	8fd9                	or	a5,a5,a4
    80006132:	0087979b          	slliw	a5,a5,0x8
    80006136:	8321                	srli	a4,a4,0x8
    80006138:	8fd9                	or	a5,a5,a4
    8000613a:	17c2                	slli	a5,a5,0x30
    8000613c:	93c1                	srli	a5,a5,0x30
    8000613e:	4705                	li	a4,1
    80006140:	04e79b63          	bne	a5,a4,80006196 <net_rx+0x2b6>
  tip = ntohl(arphdr->tip); // target IP address
    80006144:	01854783          	lbu	a5,24(a0)
    80006148:	01954703          	lbu	a4,25(a0)
    8000614c:	0722                	slli	a4,a4,0x8
    8000614e:	8f5d                	or	a4,a4,a5
    80006150:	01a54783          	lbu	a5,26(a0)
    80006154:	07c2                	slli	a5,a5,0x10
    80006156:	8f5d                	or	a4,a4,a5
    80006158:	01b54783          	lbu	a5,27(a0)
    8000615c:	07e2                	slli	a5,a5,0x18
    8000615e:	8fd9                	or	a5,a5,a4
    80006160:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    80006164:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006168:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000616c:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    8000616e:	0087169b          	slliw	a3,a4,0x8
    80006172:	00ff0637          	lui	a2,0xff0
    80006176:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80006178:	8fd5                	or	a5,a5,a3
    8000617a:	0087571b          	srliw	a4,a4,0x8
    8000617e:	66c1                	lui	a3,0x10
    80006180:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80006184:	8f75                	and	a4,a4,a3
    80006186:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80006188:	2781                	sext.w	a5,a5
    8000618a:	0a000737          	lui	a4,0xa000
    8000618e:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80006192:	00e78863          	beq	a5,a4,800061a2 <net_rx+0x2c2>
  kfree(m);
    80006196:	8526                	mv	a0,s1
    80006198:	ffffa097          	auipc	ra,0xffffa
    8000619c:	e84080e7          	jalr	-380(ra) # 8000001c <kfree>
}
    800061a0:	bb51                	j	80005f34 <net_rx+0x54>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    800061a2:	4619                	li	a2,6
    800061a4:	00850593          	addi	a1,a0,8
    800061a8:	fb840513          	addi	a0,s0,-72
    800061ac:	ffffa097          	auipc	ra,0xffffa
    800061b0:	02c080e7          	jalr	44(ra) # 800001d8 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    800061b4:	00e94783          	lbu	a5,14(s2)
    800061b8:	00f94703          	lbu	a4,15(s2)
    800061bc:	0722                	slli	a4,a4,0x8
    800061be:	8f5d                	or	a4,a4,a5
    800061c0:	01094783          	lbu	a5,16(s2)
    800061c4:	07c2                	slli	a5,a5,0x10
    800061c6:	8f5d                	or	a4,a4,a5
    800061c8:	01194783          	lbu	a5,17(s2)
    800061cc:	07e2                	slli	a5,a5,0x18
    800061ce:	8fd9                	or	a5,a5,a4
    800061d0:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800061d4:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800061d8:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800061dc:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    800061e0:	0087179b          	slliw	a5,a4,0x8
    800061e4:	00ff06b7          	lui	a3,0xff0
    800061e8:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800061ea:	00f96933          	or	s2,s2,a5
    800061ee:	0087579b          	srliw	a5,a4,0x8
    800061f2:	6741                	lui	a4,0x10
    800061f4:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    800061f8:	8ff9                	and	a5,a5,a4
    800061fa:	00f96933          	or	s2,s2,a5
    800061fe:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80006200:	08000513          	li	a0,128
    80006204:	00000097          	auipc	ra,0x0
    80006208:	b10080e7          	jalr	-1264(ra) # 80005d14 <mbufalloc>
    8000620c:	8a2a                	mv	s4,a0
  if (!m)
    8000620e:	d541                	beqz	a0,80006196 <net_rx+0x2b6>
  arphdr = mbufputhdr(m, *arphdr);
    80006210:	45f1                	li	a1,28
    80006212:	00000097          	auipc	ra,0x0
    80006216:	aa6080e7          	jalr	-1370(ra) # 80005cb8 <mbufput>
    8000621a:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    8000621c:	00050023          	sb	zero,0(a0)
    80006220:	4785                	li	a5,1
    80006222:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    80006226:	47a1                	li	a5,8
    80006228:	00f50123          	sb	a5,2(a0)
    8000622c:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    80006230:	4799                	li	a5,6
    80006232:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    80006236:	4791                	li	a5,4
    80006238:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    8000623c:	00050323          	sb	zero,6(a0)
    80006240:	4a89                	li	s5,2
    80006242:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    80006246:	4619                	li	a2,6
    80006248:	00003597          	auipc	a1,0x3
    8000624c:	68858593          	addi	a1,a1,1672 # 800098d0 <local_mac>
    80006250:	0521                	addi	a0,a0,8
    80006252:	ffffa097          	auipc	ra,0xffffa
    80006256:	f86080e7          	jalr	-122(ra) # 800001d8 <memmove>
  arphdr->sip = htonl(local_ip);
    8000625a:	47a9                	li	a5,10
    8000625c:	00f98723          	sb	a5,14(s3)
    80006260:	000987a3          	sb	zero,15(s3)
    80006264:	01598823          	sb	s5,16(s3)
    80006268:	47bd                	li	a5,15
    8000626a:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    8000626e:	4619                	li	a2,6
    80006270:	fb840593          	addi	a1,s0,-72
    80006274:	01298513          	addi	a0,s3,18
    80006278:	ffffa097          	auipc	ra,0xffffa
    8000627c:	f60080e7          	jalr	-160(ra) # 800001d8 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    80006280:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    80006284:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006288:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    8000628a:	0089179b          	slliw	a5,s2,0x8
    8000628e:	00ff06b7          	lui	a3,0xff0
    80006292:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80006294:	8f5d                	or	a4,a4,a5
    80006296:	0089579b          	srliw	a5,s2,0x8
    8000629a:	66c1                	lui	a3,0x10
    8000629c:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800062a0:	8ff5                	and	a5,a5,a3
    800062a2:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    800062a4:	00e98c23          	sb	a4,24(s3)
    800062a8:	0087d71b          	srliw	a4,a5,0x8
    800062ac:	00e98ca3          	sb	a4,25(s3)
    800062b0:	0107d71b          	srliw	a4,a5,0x10
    800062b4:	00e98d23          	sb	a4,26(s3)
    800062b8:	0187d79b          	srliw	a5,a5,0x18
    800062bc:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    800062c0:	6585                	lui	a1,0x1
    800062c2:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    800062c6:	8552                	mv	a0,s4
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	978080e7          	jalr	-1672(ra) # 80005c40 <net_tx_eth>
  return 0;
    800062d0:	b5d9                	j	80006196 <net_rx+0x2b6>

00000000800062d2 <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    800062d2:	1141                	addi	sp,sp,-16
    800062d4:	e406                	sd	ra,8(sp)
    800062d6:	e022                	sd	s0,0(sp)
    800062d8:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    800062da:	00003597          	auipc	a1,0x3
    800062de:	55658593          	addi	a1,a1,1366 # 80009830 <syscalls+0x450>
    800062e2:	00015517          	auipc	a0,0x15
    800062e6:	f1e50513          	addi	a0,a0,-226 # 8001b200 <lock>
    800062ea:	00001097          	auipc	ra,0x1
    800062ee:	e62080e7          	jalr	-414(ra) # 8000714c <initlock>
}
    800062f2:	60a2                	ld	ra,8(sp)
    800062f4:	6402                	ld	s0,0(sp)
    800062f6:	0141                	addi	sp,sp,16
    800062f8:	8082                	ret

00000000800062fa <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    800062fa:	7139                	addi	sp,sp,-64
    800062fc:	fc06                	sd	ra,56(sp)
    800062fe:	f822                	sd	s0,48(sp)
    80006300:	f426                	sd	s1,40(sp)
    80006302:	f04a                	sd	s2,32(sp)
    80006304:	ec4e                	sd	s3,24(sp)
    80006306:	e852                	sd	s4,16(sp)
    80006308:	e456                	sd	s5,8(sp)
    8000630a:	0080                	addi	s0,sp,64
    8000630c:	892a                	mv	s2,a0
    8000630e:	84ae                	mv	s1,a1
    80006310:	8a32                	mv	s4,a2
    80006312:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    80006314:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    80006318:	ffffd097          	auipc	ra,0xffffd
    8000631c:	642080e7          	jalr	1602(ra) # 8000395a <filealloc>
    80006320:	00a93023          	sd	a0,0(s2)
    80006324:	c975                	beqz	a0,80006418 <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    80006326:	ffffa097          	auipc	ra,0xffffa
    8000632a:	df2080e7          	jalr	-526(ra) # 80000118 <kalloc>
    8000632e:	8aaa                	mv	s5,a0
    80006330:	c15d                	beqz	a0,800063d6 <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    80006332:	c504                	sw	s1,8(a0)
  si->lport = lport;
    80006334:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    80006338:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    8000633c:	00003597          	auipc	a1,0x3
    80006340:	4fc58593          	addi	a1,a1,1276 # 80009838 <syscalls+0x458>
    80006344:	0541                	addi	a0,a0,16
    80006346:	00001097          	auipc	ra,0x1
    8000634a:	e06080e7          	jalr	-506(ra) # 8000714c <initlock>
  mbufq_init(&si->rxq);
    8000634e:	028a8513          	addi	a0,s5,40
    80006352:	00000097          	auipc	ra,0x0
    80006356:	a7a080e7          	jalr	-1414(ra) # 80005dcc <mbufq_init>
  (*f)->type = FD_SOCK;
    8000635a:	00093783          	ld	a5,0(s2)
    8000635e:	4711                	li	a4,4
    80006360:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    80006362:	00093703          	ld	a4,0(s2)
    80006366:	4785                	li	a5,1
    80006368:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    8000636c:	00093703          	ld	a4,0(s2)
    80006370:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    80006374:	00093783          	ld	a5,0(s2)
    80006378:	0357b023          	sd	s5,32(a5) # f020020 <_entry-0x70fdffe0>

  // add to list of sockets
  acquire(&lock);
    8000637c:	00015517          	auipc	a0,0x15
    80006380:	e8450513          	addi	a0,a0,-380 # 8001b200 <lock>
    80006384:	00001097          	auipc	ra,0x1
    80006388:	e58080e7          	jalr	-424(ra) # 800071dc <acquire>
  pos = sockets;
    8000638c:	00003597          	auipc	a1,0x3
    80006390:	5dc5b583          	ld	a1,1500(a1) # 80009968 <sockets>
  while (pos) {
    80006394:	c9b1                	beqz	a1,800063e8 <sockalloc+0xee>
  pos = sockets;
    80006396:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    80006398:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    8000639c:	0009869b          	sext.w	a3,s3
    800063a0:	a019                	j	800063a6 <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    800063a2:	639c                	ld	a5,0(a5)
  while (pos) {
    800063a4:	c3b1                	beqz	a5,800063e8 <sockalloc+0xee>
    if (pos->raddr == raddr &&
    800063a6:	4798                	lw	a4,8(a5)
    800063a8:	fe971de3          	bne	a4,s1,800063a2 <sockalloc+0xa8>
    800063ac:	00c7d703          	lhu	a4,12(a5)
    800063b0:	fec719e3          	bne	a4,a2,800063a2 <sockalloc+0xa8>
        pos->lport == lport &&
    800063b4:	00e7d703          	lhu	a4,14(a5)
    800063b8:	fed715e3          	bne	a4,a3,800063a2 <sockalloc+0xa8>
      release(&lock);
    800063bc:	00015517          	auipc	a0,0x15
    800063c0:	e4450513          	addi	a0,a0,-444 # 8001b200 <lock>
    800063c4:	00001097          	auipc	ra,0x1
    800063c8:	ecc080e7          	jalr	-308(ra) # 80007290 <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    800063cc:	8556                	mv	a0,s5
    800063ce:	ffffa097          	auipc	ra,0xffffa
    800063d2:	c4e080e7          	jalr	-946(ra) # 8000001c <kfree>
  if (*f)
    800063d6:	00093503          	ld	a0,0(s2)
    800063da:	c129                	beqz	a0,8000641c <sockalloc+0x122>
    fileclose(*f);
    800063dc:	ffffd097          	auipc	ra,0xffffd
    800063e0:	63a080e7          	jalr	1594(ra) # 80003a16 <fileclose>
  return -1;
    800063e4:	557d                	li	a0,-1
    800063e6:	a005                	j	80006406 <sockalloc+0x10c>
  si->next = sockets;
    800063e8:	00bab023          	sd	a1,0(s5)
  sockets = si;
    800063ec:	00003797          	auipc	a5,0x3
    800063f0:	5757be23          	sd	s5,1404(a5) # 80009968 <sockets>
  release(&lock);
    800063f4:	00015517          	auipc	a0,0x15
    800063f8:	e0c50513          	addi	a0,a0,-500 # 8001b200 <lock>
    800063fc:	00001097          	auipc	ra,0x1
    80006400:	e94080e7          	jalr	-364(ra) # 80007290 <release>
  return 0;
    80006404:	4501                	li	a0,0
}
    80006406:	70e2                	ld	ra,56(sp)
    80006408:	7442                	ld	s0,48(sp)
    8000640a:	74a2                	ld	s1,40(sp)
    8000640c:	7902                	ld	s2,32(sp)
    8000640e:	69e2                	ld	s3,24(sp)
    80006410:	6a42                	ld	s4,16(sp)
    80006412:	6aa2                	ld	s5,8(sp)
    80006414:	6121                	addi	sp,sp,64
    80006416:	8082                	ret
  return -1;
    80006418:	557d                	li	a0,-1
    8000641a:	b7f5                	j	80006406 <sockalloc+0x10c>
    8000641c:	557d                	li	a0,-1
    8000641e:	b7e5                	j	80006406 <sockalloc+0x10c>

0000000080006420 <sockclose>:

void
sockclose(struct sock *si)
{
    80006420:	1101                	addi	sp,sp,-32
    80006422:	ec06                	sd	ra,24(sp)
    80006424:	e822                	sd	s0,16(sp)
    80006426:	e426                	sd	s1,8(sp)
    80006428:	e04a                	sd	s2,0(sp)
    8000642a:	1000                	addi	s0,sp,32
    8000642c:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    8000642e:	00015517          	auipc	a0,0x15
    80006432:	dd250513          	addi	a0,a0,-558 # 8001b200 <lock>
    80006436:	00001097          	auipc	ra,0x1
    8000643a:	da6080e7          	jalr	-602(ra) # 800071dc <acquire>
  pos = &sockets;
    8000643e:	00003797          	auipc	a5,0x3
    80006442:	52a7b783          	ld	a5,1322(a5) # 80009968 <sockets>
  while (*pos) {
    80006446:	cb99                	beqz	a5,8000645c <sockclose+0x3c>
    if (*pos == si){
    80006448:	02f90563          	beq	s2,a5,80006472 <sockclose+0x52>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    8000644c:	873e                	mv	a4,a5
    8000644e:	639c                	ld	a5,0(a5)
  while (*pos) {
    80006450:	c791                	beqz	a5,8000645c <sockclose+0x3c>
    if (*pos == si){
    80006452:	fef91de3          	bne	s2,a5,8000644c <sockclose+0x2c>
      *pos = si->next;
    80006456:	00093783          	ld	a5,0(s2)
    8000645a:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    8000645c:	00015517          	auipc	a0,0x15
    80006460:	da450513          	addi	a0,a0,-604 # 8001b200 <lock>
    80006464:	00001097          	auipc	ra,0x1
    80006468:	e2c080e7          	jalr	-468(ra) # 80007290 <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    8000646c:	02890493          	addi	s1,s2,40
    80006470:	a839                	j	8000648e <sockclose+0x6e>
  pos = &sockets;
    80006472:	00003717          	auipc	a4,0x3
    80006476:	4f670713          	addi	a4,a4,1270 # 80009968 <sockets>
    8000647a:	bff1                	j	80006456 <sockclose+0x36>
    m = mbufq_pophead(&si->rxq);
    8000647c:	8526                	mv	a0,s1
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	926080e7          	jalr	-1754(ra) # 80005da4 <mbufq_pophead>
    mbuffree(m);
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	8e6080e7          	jalr	-1818(ra) # 80005d6c <mbuffree>
  while (!mbufq_empty(&si->rxq)) {
    8000648e:	8526                	mv	a0,s1
    80006490:	00000097          	auipc	ra,0x0
    80006494:	92a080e7          	jalr	-1750(ra) # 80005dba <mbufq_empty>
    80006498:	d175                	beqz	a0,8000647c <sockclose+0x5c>
  }

  kfree((char*)si);
    8000649a:	854a                	mv	a0,s2
    8000649c:	ffffa097          	auipc	ra,0xffffa
    800064a0:	b80080e7          	jalr	-1152(ra) # 8000001c <kfree>
}
    800064a4:	60e2                	ld	ra,24(sp)
    800064a6:	6442                	ld	s0,16(sp)
    800064a8:	64a2                	ld	s1,8(sp)
    800064aa:	6902                	ld	s2,0(sp)
    800064ac:	6105                	addi	sp,sp,32
    800064ae:	8082                	ret

00000000800064b0 <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    800064b0:	7139                	addi	sp,sp,-64
    800064b2:	fc06                	sd	ra,56(sp)
    800064b4:	f822                	sd	s0,48(sp)
    800064b6:	f426                	sd	s1,40(sp)
    800064b8:	f04a                	sd	s2,32(sp)
    800064ba:	ec4e                	sd	s3,24(sp)
    800064bc:	e852                	sd	s4,16(sp)
    800064be:	e456                	sd	s5,8(sp)
    800064c0:	0080                	addi	s0,sp,64
    800064c2:	84aa                	mv	s1,a0
    800064c4:	8a2e                	mv	s4,a1
    800064c6:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    800064c8:	ffffb097          	auipc	ra,0xffffb
    800064cc:	a20080e7          	jalr	-1504(ra) # 80000ee8 <myproc>
    800064d0:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    800064d2:	01048993          	addi	s3,s1,16
    800064d6:	854e                	mv	a0,s3
    800064d8:	00001097          	auipc	ra,0x1
    800064dc:	d04080e7          	jalr	-764(ra) # 800071dc <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    800064e0:	02848493          	addi	s1,s1,40
    800064e4:	8526                	mv	a0,s1
    800064e6:	00000097          	auipc	ra,0x0
    800064ea:	8d4080e7          	jalr	-1836(ra) # 80005dba <mbufq_empty>
    800064ee:	c919                	beqz	a0,80006504 <sockread+0x54>
    800064f0:	02892783          	lw	a5,40(s2)
    800064f4:	eba5                	bnez	a5,80006564 <sockread+0xb4>
    sleep(&si->rxq, &si->lock);
    800064f6:	85ce                	mv	a1,s3
    800064f8:	8526                	mv	a0,s1
    800064fa:	ffffb097          	auipc	ra,0xffffb
    800064fe:	096080e7          	jalr	150(ra) # 80001590 <sleep>
    80006502:	b7cd                	j	800064e4 <sockread+0x34>
  }
  if (pr->killed) {
    80006504:	02892783          	lw	a5,40(s2)
    80006508:	efb1                	bnez	a5,80006564 <sockread+0xb4>
    release(&si->lock);
    return -1;
  }
  m = mbufq_pophead(&si->rxq);
    8000650a:	8526                	mv	a0,s1
    8000650c:	00000097          	auipc	ra,0x0
    80006510:	898080e7          	jalr	-1896(ra) # 80005da4 <mbufq_pophead>
    80006514:	84aa                	mv	s1,a0
  release(&si->lock);
    80006516:	854e                	mv	a0,s3
    80006518:	00001097          	auipc	ra,0x1
    8000651c:	d78080e7          	jalr	-648(ra) # 80007290 <release>

  len = m->len;
    80006520:	489c                	lw	a5,16(s1)
  if (len > n)
    80006522:	89be                	mv	s3,a5
    80006524:	00fad363          	bge	s5,a5,8000652a <sockread+0x7a>
    80006528:	89d6                	mv	s3,s5
    8000652a:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    8000652c:	86ce                	mv	a3,s3
    8000652e:	6490                	ld	a2,8(s1)
    80006530:	85d2                	mv	a1,s4
    80006532:	05093503          	ld	a0,80(s2)
    80006536:	ffffa097          	auipc	ra,0xffffa
    8000653a:	63c080e7          	jalr	1596(ra) # 80000b72 <copyout>
    8000653e:	892a                	mv	s2,a0
    80006540:	57fd                	li	a5,-1
    80006542:	02f50863          	beq	a0,a5,80006572 <sockread+0xc2>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    80006546:	8526                	mv	a0,s1
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	824080e7          	jalr	-2012(ra) # 80005d6c <mbuffree>
  return len;
}
    80006550:	854e                	mv	a0,s3
    80006552:	70e2                	ld	ra,56(sp)
    80006554:	7442                	ld	s0,48(sp)
    80006556:	74a2                	ld	s1,40(sp)
    80006558:	7902                	ld	s2,32(sp)
    8000655a:	69e2                	ld	s3,24(sp)
    8000655c:	6a42                	ld	s4,16(sp)
    8000655e:	6aa2                	ld	s5,8(sp)
    80006560:	6121                	addi	sp,sp,64
    80006562:	8082                	ret
    release(&si->lock);
    80006564:	854e                	mv	a0,s3
    80006566:	00001097          	auipc	ra,0x1
    8000656a:	d2a080e7          	jalr	-726(ra) # 80007290 <release>
    return -1;
    8000656e:	59fd                	li	s3,-1
    80006570:	b7c5                	j	80006550 <sockread+0xa0>
    mbuffree(m);
    80006572:	8526                	mv	a0,s1
    80006574:	fffff097          	auipc	ra,0xfffff
    80006578:	7f8080e7          	jalr	2040(ra) # 80005d6c <mbuffree>
    return -1;
    8000657c:	89ca                	mv	s3,s2
    8000657e:	bfc9                	j	80006550 <sockread+0xa0>

0000000080006580 <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    80006580:	7139                	addi	sp,sp,-64
    80006582:	fc06                	sd	ra,56(sp)
    80006584:	f822                	sd	s0,48(sp)
    80006586:	f426                	sd	s1,40(sp)
    80006588:	f04a                	sd	s2,32(sp)
    8000658a:	ec4e                	sd	s3,24(sp)
    8000658c:	e852                	sd	s4,16(sp)
    8000658e:	e456                	sd	s5,8(sp)
    80006590:	0080                	addi	s0,sp,64
    80006592:	8aaa                	mv	s5,a0
    80006594:	89ae                	mv	s3,a1
    80006596:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    80006598:	ffffb097          	auipc	ra,0xffffb
    8000659c:	950080e7          	jalr	-1712(ra) # 80000ee8 <myproc>
    800065a0:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    800065a2:	08000513          	li	a0,128
    800065a6:	fffff097          	auipc	ra,0xfffff
    800065aa:	76e080e7          	jalr	1902(ra) # 80005d14 <mbufalloc>
  if (!m)
    800065ae:	c12d                	beqz	a0,80006610 <sockwrite+0x90>
    800065b0:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    800065b2:	050a3a03          	ld	s4,80(s4)
    800065b6:	85ca                	mv	a1,s2
    800065b8:	fffff097          	auipc	ra,0xfffff
    800065bc:	700080e7          	jalr	1792(ra) # 80005cb8 <mbufput>
    800065c0:	85aa                	mv	a1,a0
    800065c2:	86ca                	mv	a3,s2
    800065c4:	864e                	mv	a2,s3
    800065c6:	8552                	mv	a0,s4
    800065c8:	ffffa097          	auipc	ra,0xffffa
    800065cc:	66e080e7          	jalr	1646(ra) # 80000c36 <copyin>
    800065d0:	89aa                	mv	s3,a0
    800065d2:	57fd                	li	a5,-1
    800065d4:	02f50863          	beq	a0,a5,80006604 <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    800065d8:	00ead683          	lhu	a3,14(s5)
    800065dc:	00cad603          	lhu	a2,12(s5)
    800065e0:	008aa583          	lw	a1,8(s5)
    800065e4:	8526                	mv	a0,s1
    800065e6:	fffff097          	auipc	ra,0xfffff
    800065ea:	7f6080e7          	jalr	2038(ra) # 80005ddc <net_tx_udp>
  return n;
    800065ee:	89ca                	mv	s3,s2
}
    800065f0:	854e                	mv	a0,s3
    800065f2:	70e2                	ld	ra,56(sp)
    800065f4:	7442                	ld	s0,48(sp)
    800065f6:	74a2                	ld	s1,40(sp)
    800065f8:	7902                	ld	s2,32(sp)
    800065fa:	69e2                	ld	s3,24(sp)
    800065fc:	6a42                	ld	s4,16(sp)
    800065fe:	6aa2                	ld	s5,8(sp)
    80006600:	6121                	addi	sp,sp,64
    80006602:	8082                	ret
    mbuffree(m);
    80006604:	8526                	mv	a0,s1
    80006606:	fffff097          	auipc	ra,0xfffff
    8000660a:	766080e7          	jalr	1894(ra) # 80005d6c <mbuffree>
    return -1;
    8000660e:	b7cd                	j	800065f0 <sockwrite+0x70>
    return -1;
    80006610:	59fd                	li	s3,-1
    80006612:	bff9                	j	800065f0 <sockwrite+0x70>

0000000080006614 <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    80006614:	7139                	addi	sp,sp,-64
    80006616:	fc06                	sd	ra,56(sp)
    80006618:	f822                	sd	s0,48(sp)
    8000661a:	f426                	sd	s1,40(sp)
    8000661c:	f04a                	sd	s2,32(sp)
    8000661e:	ec4e                	sd	s3,24(sp)
    80006620:	e852                	sd	s4,16(sp)
    80006622:	e456                	sd	s5,8(sp)
    80006624:	0080                	addi	s0,sp,64
    80006626:	8a2a                	mv	s4,a0
    80006628:	892e                	mv	s2,a1
    8000662a:	89b2                	mv	s3,a2
    8000662c:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    8000662e:	00015517          	auipc	a0,0x15
    80006632:	bd250513          	addi	a0,a0,-1070 # 8001b200 <lock>
    80006636:	00001097          	auipc	ra,0x1
    8000663a:	ba6080e7          	jalr	-1114(ra) # 800071dc <acquire>
  si = sockets;
    8000663e:	00003497          	auipc	s1,0x3
    80006642:	32a4b483          	ld	s1,810(s1) # 80009968 <sockets>
  while (si) {
    80006646:	c4ad                	beqz	s1,800066b0 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    80006648:	0009871b          	sext.w	a4,s3
    8000664c:	000a869b          	sext.w	a3,s5
    80006650:	a019                	j	80006656 <sockrecvudp+0x42>
      goto found;
    si = si->next;
    80006652:	6084                	ld	s1,0(s1)
  while (si) {
    80006654:	ccb1                	beqz	s1,800066b0 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    80006656:	449c                	lw	a5,8(s1)
    80006658:	ff279de3          	bne	a5,s2,80006652 <sockrecvudp+0x3e>
    8000665c:	00c4d783          	lhu	a5,12(s1)
    80006660:	fee799e3          	bne	a5,a4,80006652 <sockrecvudp+0x3e>
    80006664:	00e4d783          	lhu	a5,14(s1)
    80006668:	fed795e3          	bne	a5,a3,80006652 <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    8000666c:	01048913          	addi	s2,s1,16
    80006670:	854a                	mv	a0,s2
    80006672:	00001097          	auipc	ra,0x1
    80006676:	b6a080e7          	jalr	-1174(ra) # 800071dc <acquire>
  mbufq_pushtail(&si->rxq, m);
    8000667a:	02848493          	addi	s1,s1,40
    8000667e:	85d2                	mv	a1,s4
    80006680:	8526                	mv	a0,s1
    80006682:	fffff097          	auipc	ra,0xfffff
    80006686:	702080e7          	jalr	1794(ra) # 80005d84 <mbufq_pushtail>
  wakeup(&si->rxq);
    8000668a:	8526                	mv	a0,s1
    8000668c:	ffffb097          	auipc	ra,0xffffb
    80006690:	f68080e7          	jalr	-152(ra) # 800015f4 <wakeup>
  release(&si->lock);
    80006694:	854a                	mv	a0,s2
    80006696:	00001097          	auipc	ra,0x1
    8000669a:	bfa080e7          	jalr	-1030(ra) # 80007290 <release>
  release(&lock);
    8000669e:	00015517          	auipc	a0,0x15
    800066a2:	b6250513          	addi	a0,a0,-1182 # 8001b200 <lock>
    800066a6:	00001097          	auipc	ra,0x1
    800066aa:	bea080e7          	jalr	-1046(ra) # 80007290 <release>
    800066ae:	a831                	j	800066ca <sockrecvudp+0xb6>
  release(&lock);
    800066b0:	00015517          	auipc	a0,0x15
    800066b4:	b5050513          	addi	a0,a0,-1200 # 8001b200 <lock>
    800066b8:	00001097          	auipc	ra,0x1
    800066bc:	bd8080e7          	jalr	-1064(ra) # 80007290 <release>
  mbuffree(m);
    800066c0:	8552                	mv	a0,s4
    800066c2:	fffff097          	auipc	ra,0xfffff
    800066c6:	6aa080e7          	jalr	1706(ra) # 80005d6c <mbuffree>
}
    800066ca:	70e2                	ld	ra,56(sp)
    800066cc:	7442                	ld	s0,48(sp)
    800066ce:	74a2                	ld	s1,40(sp)
    800066d0:	7902                	ld	s2,32(sp)
    800066d2:	69e2                	ld	s3,24(sp)
    800066d4:	6a42                	ld	s4,16(sp)
    800066d6:	6aa2                	ld	s5,8(sp)
    800066d8:	6121                	addi	sp,sp,64
    800066da:	8082                	ret

00000000800066dc <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    800066dc:	715d                	addi	sp,sp,-80
    800066de:	e486                	sd	ra,72(sp)
    800066e0:	e0a2                	sd	s0,64(sp)
    800066e2:	fc26                	sd	s1,56(sp)
    800066e4:	f84a                	sd	s2,48(sp)
    800066e6:	f44e                	sd	s3,40(sp)
    800066e8:	f052                	sd	s4,32(sp)
    800066ea:	ec56                	sd	s5,24(sp)
    800066ec:	e85a                	sd	s6,16(sp)
    800066ee:	e45e                	sd	s7,8(sp)
    800066f0:	0880                	addi	s0,sp,80
    800066f2:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    800066f6:	100e8937          	lui	s2,0x100e8
    800066fa:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    800066fe:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80006700:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80006702:	40000b37          	lui	s6,0x40000
    80006706:	6a09                	lui	s4,0x2
  for(int dev = 0; dev < 32; dev++){
    80006708:	300409b7          	lui	s3,0x30040
    8000670c:	a821                	j	80006724 <pci_init+0x48>
      base[4+0] = e1000_regs;
    8000670e:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    80006712:	40000537          	lui	a0,0x40000
    80006716:	fffff097          	auipc	ra,0xfffff
    8000671a:	10e080e7          	jalr	270(ra) # 80005824 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    8000671e:	94d2                	add	s1,s1,s4
    80006720:	03348a63          	beq	s1,s3,80006754 <pci_init+0x78>
    volatile uint32 *base = ecam + off;
    80006724:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80006726:	409c                	lw	a5,0(s1)
    80006728:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    8000672a:	ff279ae3          	bne	a5,s2,8000671e <pci_init+0x42>
      base[1] = 7;
    8000672e:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80006732:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    80006736:	01048793          	addi	a5,s1,16
    8000673a:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    8000673e:	4398                	lw	a4,0(a5)
    80006740:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    80006742:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    80006746:	0ff0000f          	fence
        base[4+i] = old;
    8000674a:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    8000674c:	0791                	addi	a5,a5,4
    8000674e:	fec798e3          	bne	a5,a2,8000673e <pci_init+0x62>
    80006752:	bf75                	j	8000670e <pci_init+0x32>
    }
  }
}
    80006754:	60a6                	ld	ra,72(sp)
    80006756:	6406                	ld	s0,64(sp)
    80006758:	74e2                	ld	s1,56(sp)
    8000675a:	7942                	ld	s2,48(sp)
    8000675c:	79a2                	ld	s3,40(sp)
    8000675e:	7a02                	ld	s4,32(sp)
    80006760:	6ae2                	ld	s5,24(sp)
    80006762:	6b42                	ld	s6,16(sp)
    80006764:	6ba2                	ld	s7,8(sp)
    80006766:	6161                	addi	sp,sp,80
    80006768:	8082                	ret

000000008000676a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000676a:	1141                	addi	sp,sp,-16
    8000676c:	e422                	sd	s0,8(sp)
    8000676e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006770:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80006774:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80006778:	0037979b          	slliw	a5,a5,0x3
    8000677c:	02004737          	lui	a4,0x2004
    80006780:	97ba                	add	a5,a5,a4
    80006782:	0200c737          	lui	a4,0x200c
    80006786:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000678a:	000f4637          	lui	a2,0xf4
    8000678e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006792:	95b2                	add	a1,a1,a2
    80006794:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80006796:	00269713          	slli	a4,a3,0x2
    8000679a:	9736                	add	a4,a4,a3
    8000679c:	00371693          	slli	a3,a4,0x3
    800067a0:	00015717          	auipc	a4,0x15
    800067a4:	a8070713          	addi	a4,a4,-1408 # 8001b220 <timer_scratch>
    800067a8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800067aa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800067ac:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800067ae:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800067b2:	fffff797          	auipc	a5,0xfffff
    800067b6:	9de78793          	addi	a5,a5,-1570 # 80005190 <timervec>
    800067ba:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800067be:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800067c2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800067c6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800067ca:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800067ce:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800067d2:	30479073          	csrw	mie,a5
}
    800067d6:	6422                	ld	s0,8(sp)
    800067d8:	0141                	addi	sp,sp,16
    800067da:	8082                	ret

00000000800067dc <start>:
{
    800067dc:	1141                	addi	sp,sp,-16
    800067de:	e406                	sd	ra,8(sp)
    800067e0:	e022                	sd	s0,0(sp)
    800067e2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800067e4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800067e8:	7779                	lui	a4,0xffffe
    800067ea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb39f>
    800067ee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800067f0:	6705                	lui	a4,0x1
    800067f2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800067f6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800067f8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800067fc:	ffffa797          	auipc	a5,0xffffa
    80006800:	b2a78793          	addi	a5,a5,-1238 # 80000326 <main>
    80006804:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80006808:	4781                	li	a5,0
    8000680a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000680e:	67c1                	lui	a5,0x10
    80006810:	17fd                	addi	a5,a5,-1
    80006812:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80006816:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000681a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000681e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80006822:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80006826:	57fd                	li	a5,-1
    80006828:	83a9                	srli	a5,a5,0xa
    8000682a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000682e:	47bd                	li	a5,15
    80006830:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80006834:	00000097          	auipc	ra,0x0
    80006838:	f36080e7          	jalr	-202(ra) # 8000676a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000683c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80006840:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80006842:	823e                	mv	tp,a5
  asm volatile("mret");
    80006844:	30200073          	mret
}
    80006848:	60a2                	ld	ra,8(sp)
    8000684a:	6402                	ld	s0,0(sp)
    8000684c:	0141                	addi	sp,sp,16
    8000684e:	8082                	ret

0000000080006850 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80006850:	715d                	addi	sp,sp,-80
    80006852:	e486                	sd	ra,72(sp)
    80006854:	e0a2                	sd	s0,64(sp)
    80006856:	fc26                	sd	s1,56(sp)
    80006858:	f84a                	sd	s2,48(sp)
    8000685a:	f44e                	sd	s3,40(sp)
    8000685c:	f052                	sd	s4,32(sp)
    8000685e:	ec56                	sd	s5,24(sp)
    80006860:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80006862:	04c05663          	blez	a2,800068ae <consolewrite+0x5e>
    80006866:	8a2a                	mv	s4,a0
    80006868:	84ae                	mv	s1,a1
    8000686a:	89b2                	mv	s3,a2
    8000686c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000686e:	5afd                	li	s5,-1
    80006870:	4685                	li	a3,1
    80006872:	8626                	mv	a2,s1
    80006874:	85d2                	mv	a1,s4
    80006876:	fbf40513          	addi	a0,s0,-65
    8000687a:	ffffb097          	auipc	ra,0xffffb
    8000687e:	174080e7          	jalr	372(ra) # 800019ee <either_copyin>
    80006882:	01550c63          	beq	a0,s5,8000689a <consolewrite+0x4a>
      break;
    uartputc(c);
    80006886:	fbf44503          	lbu	a0,-65(s0)
    8000688a:	00000097          	auipc	ra,0x0
    8000688e:	794080e7          	jalr	1940(ra) # 8000701e <uartputc>
  for(i = 0; i < n; i++){
    80006892:	2905                	addiw	s2,s2,1
    80006894:	0485                	addi	s1,s1,1
    80006896:	fd299de3          	bne	s3,s2,80006870 <consolewrite+0x20>
  }

  return i;
}
    8000689a:	854a                	mv	a0,s2
    8000689c:	60a6                	ld	ra,72(sp)
    8000689e:	6406                	ld	s0,64(sp)
    800068a0:	74e2                	ld	s1,56(sp)
    800068a2:	7942                	ld	s2,48(sp)
    800068a4:	79a2                	ld	s3,40(sp)
    800068a6:	7a02                	ld	s4,32(sp)
    800068a8:	6ae2                	ld	s5,24(sp)
    800068aa:	6161                	addi	sp,sp,80
    800068ac:	8082                	ret
  for(i = 0; i < n; i++){
    800068ae:	4901                	li	s2,0
    800068b0:	b7ed                	j	8000689a <consolewrite+0x4a>

00000000800068b2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800068b2:	7119                	addi	sp,sp,-128
    800068b4:	fc86                	sd	ra,120(sp)
    800068b6:	f8a2                	sd	s0,112(sp)
    800068b8:	f4a6                	sd	s1,104(sp)
    800068ba:	f0ca                	sd	s2,96(sp)
    800068bc:	ecce                	sd	s3,88(sp)
    800068be:	e8d2                	sd	s4,80(sp)
    800068c0:	e4d6                	sd	s5,72(sp)
    800068c2:	e0da                	sd	s6,64(sp)
    800068c4:	fc5e                	sd	s7,56(sp)
    800068c6:	f862                	sd	s8,48(sp)
    800068c8:	f466                	sd	s9,40(sp)
    800068ca:	f06a                	sd	s10,32(sp)
    800068cc:	ec6e                	sd	s11,24(sp)
    800068ce:	0100                	addi	s0,sp,128
    800068d0:	8b2a                	mv	s6,a0
    800068d2:	8aae                	mv	s5,a1
    800068d4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800068d6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800068da:	0001d517          	auipc	a0,0x1d
    800068de:	a8650513          	addi	a0,a0,-1402 # 80023360 <cons>
    800068e2:	00001097          	auipc	ra,0x1
    800068e6:	8fa080e7          	jalr	-1798(ra) # 800071dc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800068ea:	0001d497          	auipc	s1,0x1d
    800068ee:	a7648493          	addi	s1,s1,-1418 # 80023360 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800068f2:	89a6                	mv	s3,s1
    800068f4:	0001d917          	auipc	s2,0x1d
    800068f8:	b0490913          	addi	s2,s2,-1276 # 800233f8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800068fc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800068fe:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80006900:	4da9                	li	s11,10
  while(n > 0){
    80006902:	07405b63          	blez	s4,80006978 <consoleread+0xc6>
    while(cons.r == cons.w){
    80006906:	0984a783          	lw	a5,152(s1)
    8000690a:	09c4a703          	lw	a4,156(s1)
    8000690e:	02f71763          	bne	a4,a5,8000693c <consoleread+0x8a>
      if(killed(myproc())){
    80006912:	ffffa097          	auipc	ra,0xffffa
    80006916:	5d6080e7          	jalr	1494(ra) # 80000ee8 <myproc>
    8000691a:	ffffb097          	auipc	ra,0xffffb
    8000691e:	f1e080e7          	jalr	-226(ra) # 80001838 <killed>
    80006922:	e535                	bnez	a0,8000698e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80006924:	85ce                	mv	a1,s3
    80006926:	854a                	mv	a0,s2
    80006928:	ffffb097          	auipc	ra,0xffffb
    8000692c:	c68080e7          	jalr	-920(ra) # 80001590 <sleep>
    while(cons.r == cons.w){
    80006930:	0984a783          	lw	a5,152(s1)
    80006934:	09c4a703          	lw	a4,156(s1)
    80006938:	fcf70de3          	beq	a4,a5,80006912 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000693c:	0017871b          	addiw	a4,a5,1
    80006940:	08e4ac23          	sw	a4,152(s1)
    80006944:	07f7f713          	andi	a4,a5,127
    80006948:	9726                	add	a4,a4,s1
    8000694a:	01874703          	lbu	a4,24(a4)
    8000694e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80006952:	079c0663          	beq	s8,s9,800069be <consoleread+0x10c>
    cbuf = c;
    80006956:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000695a:	4685                	li	a3,1
    8000695c:	f8f40613          	addi	a2,s0,-113
    80006960:	85d6                	mv	a1,s5
    80006962:	855a                	mv	a0,s6
    80006964:	ffffb097          	auipc	ra,0xffffb
    80006968:	034080e7          	jalr	52(ra) # 80001998 <either_copyout>
    8000696c:	01a50663          	beq	a0,s10,80006978 <consoleread+0xc6>
    dst++;
    80006970:	0a85                	addi	s5,s5,1
    --n;
    80006972:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80006974:	f9bc17e3          	bne	s8,s11,80006902 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80006978:	0001d517          	auipc	a0,0x1d
    8000697c:	9e850513          	addi	a0,a0,-1560 # 80023360 <cons>
    80006980:	00001097          	auipc	ra,0x1
    80006984:	910080e7          	jalr	-1776(ra) # 80007290 <release>

  return target - n;
    80006988:	414b853b          	subw	a0,s7,s4
    8000698c:	a811                	j	800069a0 <consoleread+0xee>
        release(&cons.lock);
    8000698e:	0001d517          	auipc	a0,0x1d
    80006992:	9d250513          	addi	a0,a0,-1582 # 80023360 <cons>
    80006996:	00001097          	auipc	ra,0x1
    8000699a:	8fa080e7          	jalr	-1798(ra) # 80007290 <release>
        return -1;
    8000699e:	557d                	li	a0,-1
}
    800069a0:	70e6                	ld	ra,120(sp)
    800069a2:	7446                	ld	s0,112(sp)
    800069a4:	74a6                	ld	s1,104(sp)
    800069a6:	7906                	ld	s2,96(sp)
    800069a8:	69e6                	ld	s3,88(sp)
    800069aa:	6a46                	ld	s4,80(sp)
    800069ac:	6aa6                	ld	s5,72(sp)
    800069ae:	6b06                	ld	s6,64(sp)
    800069b0:	7be2                	ld	s7,56(sp)
    800069b2:	7c42                	ld	s8,48(sp)
    800069b4:	7ca2                	ld	s9,40(sp)
    800069b6:	7d02                	ld	s10,32(sp)
    800069b8:	6de2                	ld	s11,24(sp)
    800069ba:	6109                	addi	sp,sp,128
    800069bc:	8082                	ret
      if(n < target){
    800069be:	000a071b          	sext.w	a4,s4
    800069c2:	fb777be3          	bgeu	a4,s7,80006978 <consoleread+0xc6>
        cons.r--;
    800069c6:	0001d717          	auipc	a4,0x1d
    800069ca:	a2f72923          	sw	a5,-1486(a4) # 800233f8 <cons+0x98>
    800069ce:	b76d                	j	80006978 <consoleread+0xc6>

00000000800069d0 <consputc>:
{
    800069d0:	1141                	addi	sp,sp,-16
    800069d2:	e406                	sd	ra,8(sp)
    800069d4:	e022                	sd	s0,0(sp)
    800069d6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800069d8:	10000793          	li	a5,256
    800069dc:	00f50a63          	beq	a0,a5,800069f0 <consputc+0x20>
    uartputc_sync(c);
    800069e0:	00000097          	auipc	ra,0x0
    800069e4:	564080e7          	jalr	1380(ra) # 80006f44 <uartputc_sync>
}
    800069e8:	60a2                	ld	ra,8(sp)
    800069ea:	6402                	ld	s0,0(sp)
    800069ec:	0141                	addi	sp,sp,16
    800069ee:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800069f0:	4521                	li	a0,8
    800069f2:	00000097          	auipc	ra,0x0
    800069f6:	552080e7          	jalr	1362(ra) # 80006f44 <uartputc_sync>
    800069fa:	02000513          	li	a0,32
    800069fe:	00000097          	auipc	ra,0x0
    80006a02:	546080e7          	jalr	1350(ra) # 80006f44 <uartputc_sync>
    80006a06:	4521                	li	a0,8
    80006a08:	00000097          	auipc	ra,0x0
    80006a0c:	53c080e7          	jalr	1340(ra) # 80006f44 <uartputc_sync>
    80006a10:	bfe1                	j	800069e8 <consputc+0x18>

0000000080006a12 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006a12:	1101                	addi	sp,sp,-32
    80006a14:	ec06                	sd	ra,24(sp)
    80006a16:	e822                	sd	s0,16(sp)
    80006a18:	e426                	sd	s1,8(sp)
    80006a1a:	e04a                	sd	s2,0(sp)
    80006a1c:	1000                	addi	s0,sp,32
    80006a1e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006a20:	0001d517          	auipc	a0,0x1d
    80006a24:	94050513          	addi	a0,a0,-1728 # 80023360 <cons>
    80006a28:	00000097          	auipc	ra,0x0
    80006a2c:	7b4080e7          	jalr	1972(ra) # 800071dc <acquire>

  switch(c){
    80006a30:	47d5                	li	a5,21
    80006a32:	0af48663          	beq	s1,a5,80006ade <consoleintr+0xcc>
    80006a36:	0297ca63          	blt	a5,s1,80006a6a <consoleintr+0x58>
    80006a3a:	47a1                	li	a5,8
    80006a3c:	0ef48763          	beq	s1,a5,80006b2a <consoleintr+0x118>
    80006a40:	47c1                	li	a5,16
    80006a42:	10f49a63          	bne	s1,a5,80006b56 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80006a46:	ffffb097          	auipc	ra,0xffffb
    80006a4a:	ffe080e7          	jalr	-2(ra) # 80001a44 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006a4e:	0001d517          	auipc	a0,0x1d
    80006a52:	91250513          	addi	a0,a0,-1774 # 80023360 <cons>
    80006a56:	00001097          	auipc	ra,0x1
    80006a5a:	83a080e7          	jalr	-1990(ra) # 80007290 <release>
}
    80006a5e:	60e2                	ld	ra,24(sp)
    80006a60:	6442                	ld	s0,16(sp)
    80006a62:	64a2                	ld	s1,8(sp)
    80006a64:	6902                	ld	s2,0(sp)
    80006a66:	6105                	addi	sp,sp,32
    80006a68:	8082                	ret
  switch(c){
    80006a6a:	07f00793          	li	a5,127
    80006a6e:	0af48e63          	beq	s1,a5,80006b2a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006a72:	0001d717          	auipc	a4,0x1d
    80006a76:	8ee70713          	addi	a4,a4,-1810 # 80023360 <cons>
    80006a7a:	0a072783          	lw	a5,160(a4)
    80006a7e:	09872703          	lw	a4,152(a4)
    80006a82:	9f99                	subw	a5,a5,a4
    80006a84:	07f00713          	li	a4,127
    80006a88:	fcf763e3          	bltu	a4,a5,80006a4e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006a8c:	47b5                	li	a5,13
    80006a8e:	0cf48763          	beq	s1,a5,80006b5c <consoleintr+0x14a>
      consputc(c);
    80006a92:	8526                	mv	a0,s1
    80006a94:	00000097          	auipc	ra,0x0
    80006a98:	f3c080e7          	jalr	-196(ra) # 800069d0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006a9c:	0001d797          	auipc	a5,0x1d
    80006aa0:	8c478793          	addi	a5,a5,-1852 # 80023360 <cons>
    80006aa4:	0a07a683          	lw	a3,160(a5)
    80006aa8:	0016871b          	addiw	a4,a3,1
    80006aac:	0007061b          	sext.w	a2,a4
    80006ab0:	0ae7a023          	sw	a4,160(a5)
    80006ab4:	07f6f693          	andi	a3,a3,127
    80006ab8:	97b6                	add	a5,a5,a3
    80006aba:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80006abe:	47a9                	li	a5,10
    80006ac0:	0cf48563          	beq	s1,a5,80006b8a <consoleintr+0x178>
    80006ac4:	4791                	li	a5,4
    80006ac6:	0cf48263          	beq	s1,a5,80006b8a <consoleintr+0x178>
    80006aca:	0001d797          	auipc	a5,0x1d
    80006ace:	92e7a783          	lw	a5,-1746(a5) # 800233f8 <cons+0x98>
    80006ad2:	9f1d                	subw	a4,a4,a5
    80006ad4:	08000793          	li	a5,128
    80006ad8:	f6f71be3          	bne	a4,a5,80006a4e <consoleintr+0x3c>
    80006adc:	a07d                	j	80006b8a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006ade:	0001d717          	auipc	a4,0x1d
    80006ae2:	88270713          	addi	a4,a4,-1918 # 80023360 <cons>
    80006ae6:	0a072783          	lw	a5,160(a4)
    80006aea:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006aee:	0001d497          	auipc	s1,0x1d
    80006af2:	87248493          	addi	s1,s1,-1934 # 80023360 <cons>
    while(cons.e != cons.w &&
    80006af6:	4929                	li	s2,10
    80006af8:	f4f70be3          	beq	a4,a5,80006a4e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006afc:	37fd                	addiw	a5,a5,-1
    80006afe:	07f7f713          	andi	a4,a5,127
    80006b02:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006b04:	01874703          	lbu	a4,24(a4)
    80006b08:	f52703e3          	beq	a4,s2,80006a4e <consoleintr+0x3c>
      cons.e--;
    80006b0c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006b10:	10000513          	li	a0,256
    80006b14:	00000097          	auipc	ra,0x0
    80006b18:	ebc080e7          	jalr	-324(ra) # 800069d0 <consputc>
    while(cons.e != cons.w &&
    80006b1c:	0a04a783          	lw	a5,160(s1)
    80006b20:	09c4a703          	lw	a4,156(s1)
    80006b24:	fcf71ce3          	bne	a4,a5,80006afc <consoleintr+0xea>
    80006b28:	b71d                	j	80006a4e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006b2a:	0001d717          	auipc	a4,0x1d
    80006b2e:	83670713          	addi	a4,a4,-1994 # 80023360 <cons>
    80006b32:	0a072783          	lw	a5,160(a4)
    80006b36:	09c72703          	lw	a4,156(a4)
    80006b3a:	f0f70ae3          	beq	a4,a5,80006a4e <consoleintr+0x3c>
      cons.e--;
    80006b3e:	37fd                	addiw	a5,a5,-1
    80006b40:	0001d717          	auipc	a4,0x1d
    80006b44:	8cf72023          	sw	a5,-1856(a4) # 80023400 <cons+0xa0>
      consputc(BACKSPACE);
    80006b48:	10000513          	li	a0,256
    80006b4c:	00000097          	auipc	ra,0x0
    80006b50:	e84080e7          	jalr	-380(ra) # 800069d0 <consputc>
    80006b54:	bded                	j	80006a4e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006b56:	ee048ce3          	beqz	s1,80006a4e <consoleintr+0x3c>
    80006b5a:	bf21                	j	80006a72 <consoleintr+0x60>
      consputc(c);
    80006b5c:	4529                	li	a0,10
    80006b5e:	00000097          	auipc	ra,0x0
    80006b62:	e72080e7          	jalr	-398(ra) # 800069d0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006b66:	0001c797          	auipc	a5,0x1c
    80006b6a:	7fa78793          	addi	a5,a5,2042 # 80023360 <cons>
    80006b6e:	0a07a703          	lw	a4,160(a5)
    80006b72:	0017069b          	addiw	a3,a4,1
    80006b76:	0006861b          	sext.w	a2,a3
    80006b7a:	0ad7a023          	sw	a3,160(a5)
    80006b7e:	07f77713          	andi	a4,a4,127
    80006b82:	97ba                	add	a5,a5,a4
    80006b84:	4729                	li	a4,10
    80006b86:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006b8a:	0001d797          	auipc	a5,0x1d
    80006b8e:	86c7a923          	sw	a2,-1934(a5) # 800233fc <cons+0x9c>
        wakeup(&cons.r);
    80006b92:	0001d517          	auipc	a0,0x1d
    80006b96:	86650513          	addi	a0,a0,-1946 # 800233f8 <cons+0x98>
    80006b9a:	ffffb097          	auipc	ra,0xffffb
    80006b9e:	a5a080e7          	jalr	-1446(ra) # 800015f4 <wakeup>
    80006ba2:	b575                	j	80006a4e <consoleintr+0x3c>

0000000080006ba4 <consoleinit>:

void
consoleinit(void)
{
    80006ba4:	1141                	addi	sp,sp,-16
    80006ba6:	e406                	sd	ra,8(sp)
    80006ba8:	e022                	sd	s0,0(sp)
    80006baa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006bac:	00003597          	auipc	a1,0x3
    80006bb0:	c9458593          	addi	a1,a1,-876 # 80009840 <syscalls+0x460>
    80006bb4:	0001c517          	auipc	a0,0x1c
    80006bb8:	7ac50513          	addi	a0,a0,1964 # 80023360 <cons>
    80006bbc:	00000097          	auipc	ra,0x0
    80006bc0:	590080e7          	jalr	1424(ra) # 8000714c <initlock>

  uartinit();
    80006bc4:	00000097          	auipc	ra,0x0
    80006bc8:	330080e7          	jalr	816(ra) # 80006ef4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006bcc:	00013797          	auipc	a5,0x13
    80006bd0:	e5c78793          	addi	a5,a5,-420 # 80019a28 <devsw>
    80006bd4:	00000717          	auipc	a4,0x0
    80006bd8:	cde70713          	addi	a4,a4,-802 # 800068b2 <consoleread>
    80006bdc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006bde:	00000717          	auipc	a4,0x0
    80006be2:	c7270713          	addi	a4,a4,-910 # 80006850 <consolewrite>
    80006be6:	ef98                	sd	a4,24(a5)
}
    80006be8:	60a2                	ld	ra,8(sp)
    80006bea:	6402                	ld	s0,0(sp)
    80006bec:	0141                	addi	sp,sp,16
    80006bee:	8082                	ret

0000000080006bf0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006bf0:	7179                	addi	sp,sp,-48
    80006bf2:	f406                	sd	ra,40(sp)
    80006bf4:	f022                	sd	s0,32(sp)
    80006bf6:	ec26                	sd	s1,24(sp)
    80006bf8:	e84a                	sd	s2,16(sp)
    80006bfa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006bfc:	c219                	beqz	a2,80006c02 <printint+0x12>
    80006bfe:	08054663          	bltz	a0,80006c8a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006c02:	2501                	sext.w	a0,a0
    80006c04:	4881                	li	a7,0
    80006c06:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006c0a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006c0c:	2581                	sext.w	a1,a1
    80006c0e:	00003617          	auipc	a2,0x3
    80006c12:	c6260613          	addi	a2,a2,-926 # 80009870 <digits>
    80006c16:	883a                	mv	a6,a4
    80006c18:	2705                	addiw	a4,a4,1
    80006c1a:	02b577bb          	remuw	a5,a0,a1
    80006c1e:	1782                	slli	a5,a5,0x20
    80006c20:	9381                	srli	a5,a5,0x20
    80006c22:	97b2                	add	a5,a5,a2
    80006c24:	0007c783          	lbu	a5,0(a5)
    80006c28:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006c2c:	0005079b          	sext.w	a5,a0
    80006c30:	02b5553b          	divuw	a0,a0,a1
    80006c34:	0685                	addi	a3,a3,1
    80006c36:	feb7f0e3          	bgeu	a5,a1,80006c16 <printint+0x26>

  if(sign)
    80006c3a:	00088b63          	beqz	a7,80006c50 <printint+0x60>
    buf[i++] = '-';
    80006c3e:	fe040793          	addi	a5,s0,-32
    80006c42:	973e                	add	a4,a4,a5
    80006c44:	02d00793          	li	a5,45
    80006c48:	fef70823          	sb	a5,-16(a4)
    80006c4c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006c50:	02e05763          	blez	a4,80006c7e <printint+0x8e>
    80006c54:	fd040793          	addi	a5,s0,-48
    80006c58:	00e784b3          	add	s1,a5,a4
    80006c5c:	fff78913          	addi	s2,a5,-1
    80006c60:	993a                	add	s2,s2,a4
    80006c62:	377d                	addiw	a4,a4,-1
    80006c64:	1702                	slli	a4,a4,0x20
    80006c66:	9301                	srli	a4,a4,0x20
    80006c68:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006c6c:	fff4c503          	lbu	a0,-1(s1)
    80006c70:	00000097          	auipc	ra,0x0
    80006c74:	d60080e7          	jalr	-672(ra) # 800069d0 <consputc>
  while(--i >= 0)
    80006c78:	14fd                	addi	s1,s1,-1
    80006c7a:	ff2499e3          	bne	s1,s2,80006c6c <printint+0x7c>
}
    80006c7e:	70a2                	ld	ra,40(sp)
    80006c80:	7402                	ld	s0,32(sp)
    80006c82:	64e2                	ld	s1,24(sp)
    80006c84:	6942                	ld	s2,16(sp)
    80006c86:	6145                	addi	sp,sp,48
    80006c88:	8082                	ret
    x = -xx;
    80006c8a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006c8e:	4885                	li	a7,1
    x = -xx;
    80006c90:	bf9d                	j	80006c06 <printint+0x16>

0000000080006c92 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006c92:	1101                	addi	sp,sp,-32
    80006c94:	ec06                	sd	ra,24(sp)
    80006c96:	e822                	sd	s0,16(sp)
    80006c98:	e426                	sd	s1,8(sp)
    80006c9a:	1000                	addi	s0,sp,32
    80006c9c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006c9e:	0001c797          	auipc	a5,0x1c
    80006ca2:	7807a123          	sw	zero,1922(a5) # 80023420 <pr+0x18>
  printf("panic: ");
    80006ca6:	00003517          	auipc	a0,0x3
    80006caa:	ba250513          	addi	a0,a0,-1118 # 80009848 <syscalls+0x468>
    80006cae:	00000097          	auipc	ra,0x0
    80006cb2:	02e080e7          	jalr	46(ra) # 80006cdc <printf>
  printf(s);
    80006cb6:	8526                	mv	a0,s1
    80006cb8:	00000097          	auipc	ra,0x0
    80006cbc:	024080e7          	jalr	36(ra) # 80006cdc <printf>
  printf("\n");
    80006cc0:	00002517          	auipc	a0,0x2
    80006cc4:	38850513          	addi	a0,a0,904 # 80009048 <etext+0x48>
    80006cc8:	00000097          	auipc	ra,0x0
    80006ccc:	014080e7          	jalr	20(ra) # 80006cdc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006cd0:	4785                	li	a5,1
    80006cd2:	00003717          	auipc	a4,0x3
    80006cd6:	c8f72f23          	sw	a5,-866(a4) # 80009970 <panicked>
  for(;;)
    80006cda:	a001                	j	80006cda <panic+0x48>

0000000080006cdc <printf>:
{
    80006cdc:	7131                	addi	sp,sp,-192
    80006cde:	fc86                	sd	ra,120(sp)
    80006ce0:	f8a2                	sd	s0,112(sp)
    80006ce2:	f4a6                	sd	s1,104(sp)
    80006ce4:	f0ca                	sd	s2,96(sp)
    80006ce6:	ecce                	sd	s3,88(sp)
    80006ce8:	e8d2                	sd	s4,80(sp)
    80006cea:	e4d6                	sd	s5,72(sp)
    80006cec:	e0da                	sd	s6,64(sp)
    80006cee:	fc5e                	sd	s7,56(sp)
    80006cf0:	f862                	sd	s8,48(sp)
    80006cf2:	f466                	sd	s9,40(sp)
    80006cf4:	f06a                	sd	s10,32(sp)
    80006cf6:	ec6e                	sd	s11,24(sp)
    80006cf8:	0100                	addi	s0,sp,128
    80006cfa:	8a2a                	mv	s4,a0
    80006cfc:	e40c                	sd	a1,8(s0)
    80006cfe:	e810                	sd	a2,16(s0)
    80006d00:	ec14                	sd	a3,24(s0)
    80006d02:	f018                	sd	a4,32(s0)
    80006d04:	f41c                	sd	a5,40(s0)
    80006d06:	03043823          	sd	a6,48(s0)
    80006d0a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006d0e:	0001cd97          	auipc	s11,0x1c
    80006d12:	712dad83          	lw	s11,1810(s11) # 80023420 <pr+0x18>
  if(locking)
    80006d16:	020d9b63          	bnez	s11,80006d4c <printf+0x70>
  if (fmt == 0)
    80006d1a:	040a0263          	beqz	s4,80006d5e <printf+0x82>
  va_start(ap, fmt);
    80006d1e:	00840793          	addi	a5,s0,8
    80006d22:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006d26:	000a4503          	lbu	a0,0(s4) # 2000 <_entry-0x7fffe000>
    80006d2a:	16050263          	beqz	a0,80006e8e <printf+0x1b2>
    80006d2e:	4481                	li	s1,0
    if(c != '%'){
    80006d30:	02500a93          	li	s5,37
    switch(c){
    80006d34:	07000b13          	li	s6,112
  consputc('x');
    80006d38:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006d3a:	00003b97          	auipc	s7,0x3
    80006d3e:	b36b8b93          	addi	s7,s7,-1226 # 80009870 <digits>
    switch(c){
    80006d42:	07300c93          	li	s9,115
    80006d46:	06400c13          	li	s8,100
    80006d4a:	a82d                	j	80006d84 <printf+0xa8>
    acquire(&pr.lock);
    80006d4c:	0001c517          	auipc	a0,0x1c
    80006d50:	6bc50513          	addi	a0,a0,1724 # 80023408 <pr>
    80006d54:	00000097          	auipc	ra,0x0
    80006d58:	488080e7          	jalr	1160(ra) # 800071dc <acquire>
    80006d5c:	bf7d                	j	80006d1a <printf+0x3e>
    panic("null fmt");
    80006d5e:	00003517          	auipc	a0,0x3
    80006d62:	afa50513          	addi	a0,a0,-1286 # 80009858 <syscalls+0x478>
    80006d66:	00000097          	auipc	ra,0x0
    80006d6a:	f2c080e7          	jalr	-212(ra) # 80006c92 <panic>
      consputc(c);
    80006d6e:	00000097          	auipc	ra,0x0
    80006d72:	c62080e7          	jalr	-926(ra) # 800069d0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006d76:	2485                	addiw	s1,s1,1
    80006d78:	009a07b3          	add	a5,s4,s1
    80006d7c:	0007c503          	lbu	a0,0(a5)
    80006d80:	10050763          	beqz	a0,80006e8e <printf+0x1b2>
    if(c != '%'){
    80006d84:	ff5515e3          	bne	a0,s5,80006d6e <printf+0x92>
    c = fmt[++i] & 0xff;
    80006d88:	2485                	addiw	s1,s1,1
    80006d8a:	009a07b3          	add	a5,s4,s1
    80006d8e:	0007c783          	lbu	a5,0(a5)
    80006d92:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006d96:	cfe5                	beqz	a5,80006e8e <printf+0x1b2>
    switch(c){
    80006d98:	05678a63          	beq	a5,s6,80006dec <printf+0x110>
    80006d9c:	02fb7663          	bgeu	s6,a5,80006dc8 <printf+0xec>
    80006da0:	09978963          	beq	a5,s9,80006e32 <printf+0x156>
    80006da4:	07800713          	li	a4,120
    80006da8:	0ce79863          	bne	a5,a4,80006e78 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006dac:	f8843783          	ld	a5,-120(s0)
    80006db0:	00878713          	addi	a4,a5,8
    80006db4:	f8e43423          	sd	a4,-120(s0)
    80006db8:	4605                	li	a2,1
    80006dba:	85ea                	mv	a1,s10
    80006dbc:	4388                	lw	a0,0(a5)
    80006dbe:	00000097          	auipc	ra,0x0
    80006dc2:	e32080e7          	jalr	-462(ra) # 80006bf0 <printint>
      break;
    80006dc6:	bf45                	j	80006d76 <printf+0x9a>
    switch(c){
    80006dc8:	0b578263          	beq	a5,s5,80006e6c <printf+0x190>
    80006dcc:	0b879663          	bne	a5,s8,80006e78 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006dd0:	f8843783          	ld	a5,-120(s0)
    80006dd4:	00878713          	addi	a4,a5,8
    80006dd8:	f8e43423          	sd	a4,-120(s0)
    80006ddc:	4605                	li	a2,1
    80006dde:	45a9                	li	a1,10
    80006de0:	4388                	lw	a0,0(a5)
    80006de2:	00000097          	auipc	ra,0x0
    80006de6:	e0e080e7          	jalr	-498(ra) # 80006bf0 <printint>
      break;
    80006dea:	b771                	j	80006d76 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006dec:	f8843783          	ld	a5,-120(s0)
    80006df0:	00878713          	addi	a4,a5,8
    80006df4:	f8e43423          	sd	a4,-120(s0)
    80006df8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006dfc:	03000513          	li	a0,48
    80006e00:	00000097          	auipc	ra,0x0
    80006e04:	bd0080e7          	jalr	-1072(ra) # 800069d0 <consputc>
  consputc('x');
    80006e08:	07800513          	li	a0,120
    80006e0c:	00000097          	auipc	ra,0x0
    80006e10:	bc4080e7          	jalr	-1084(ra) # 800069d0 <consputc>
    80006e14:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006e16:	03c9d793          	srli	a5,s3,0x3c
    80006e1a:	97de                	add	a5,a5,s7
    80006e1c:	0007c503          	lbu	a0,0(a5)
    80006e20:	00000097          	auipc	ra,0x0
    80006e24:	bb0080e7          	jalr	-1104(ra) # 800069d0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006e28:	0992                	slli	s3,s3,0x4
    80006e2a:	397d                	addiw	s2,s2,-1
    80006e2c:	fe0915e3          	bnez	s2,80006e16 <printf+0x13a>
    80006e30:	b799                	j	80006d76 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006e32:	f8843783          	ld	a5,-120(s0)
    80006e36:	00878713          	addi	a4,a5,8
    80006e3a:	f8e43423          	sd	a4,-120(s0)
    80006e3e:	0007b903          	ld	s2,0(a5)
    80006e42:	00090e63          	beqz	s2,80006e5e <printf+0x182>
      for(; *s; s++)
    80006e46:	00094503          	lbu	a0,0(s2)
    80006e4a:	d515                	beqz	a0,80006d76 <printf+0x9a>
        consputc(*s);
    80006e4c:	00000097          	auipc	ra,0x0
    80006e50:	b84080e7          	jalr	-1148(ra) # 800069d0 <consputc>
      for(; *s; s++)
    80006e54:	0905                	addi	s2,s2,1
    80006e56:	00094503          	lbu	a0,0(s2)
    80006e5a:	f96d                	bnez	a0,80006e4c <printf+0x170>
    80006e5c:	bf29                	j	80006d76 <printf+0x9a>
        s = "(null)";
    80006e5e:	00003917          	auipc	s2,0x3
    80006e62:	9f290913          	addi	s2,s2,-1550 # 80009850 <syscalls+0x470>
      for(; *s; s++)
    80006e66:	02800513          	li	a0,40
    80006e6a:	b7cd                	j	80006e4c <printf+0x170>
      consputc('%');
    80006e6c:	8556                	mv	a0,s5
    80006e6e:	00000097          	auipc	ra,0x0
    80006e72:	b62080e7          	jalr	-1182(ra) # 800069d0 <consputc>
      break;
    80006e76:	b701                	j	80006d76 <printf+0x9a>
      consputc('%');
    80006e78:	8556                	mv	a0,s5
    80006e7a:	00000097          	auipc	ra,0x0
    80006e7e:	b56080e7          	jalr	-1194(ra) # 800069d0 <consputc>
      consputc(c);
    80006e82:	854a                	mv	a0,s2
    80006e84:	00000097          	auipc	ra,0x0
    80006e88:	b4c080e7          	jalr	-1204(ra) # 800069d0 <consputc>
      break;
    80006e8c:	b5ed                	j	80006d76 <printf+0x9a>
  if(locking)
    80006e8e:	020d9163          	bnez	s11,80006eb0 <printf+0x1d4>
}
    80006e92:	70e6                	ld	ra,120(sp)
    80006e94:	7446                	ld	s0,112(sp)
    80006e96:	74a6                	ld	s1,104(sp)
    80006e98:	7906                	ld	s2,96(sp)
    80006e9a:	69e6                	ld	s3,88(sp)
    80006e9c:	6a46                	ld	s4,80(sp)
    80006e9e:	6aa6                	ld	s5,72(sp)
    80006ea0:	6b06                	ld	s6,64(sp)
    80006ea2:	7be2                	ld	s7,56(sp)
    80006ea4:	7c42                	ld	s8,48(sp)
    80006ea6:	7ca2                	ld	s9,40(sp)
    80006ea8:	7d02                	ld	s10,32(sp)
    80006eaa:	6de2                	ld	s11,24(sp)
    80006eac:	6129                	addi	sp,sp,192
    80006eae:	8082                	ret
    release(&pr.lock);
    80006eb0:	0001c517          	auipc	a0,0x1c
    80006eb4:	55850513          	addi	a0,a0,1368 # 80023408 <pr>
    80006eb8:	00000097          	auipc	ra,0x0
    80006ebc:	3d8080e7          	jalr	984(ra) # 80007290 <release>
}
    80006ec0:	bfc9                	j	80006e92 <printf+0x1b6>

0000000080006ec2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006ec2:	1101                	addi	sp,sp,-32
    80006ec4:	ec06                	sd	ra,24(sp)
    80006ec6:	e822                	sd	s0,16(sp)
    80006ec8:	e426                	sd	s1,8(sp)
    80006eca:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006ecc:	0001c497          	auipc	s1,0x1c
    80006ed0:	53c48493          	addi	s1,s1,1340 # 80023408 <pr>
    80006ed4:	00003597          	auipc	a1,0x3
    80006ed8:	99458593          	addi	a1,a1,-1644 # 80009868 <syscalls+0x488>
    80006edc:	8526                	mv	a0,s1
    80006ede:	00000097          	auipc	ra,0x0
    80006ee2:	26e080e7          	jalr	622(ra) # 8000714c <initlock>
  pr.locking = 1;
    80006ee6:	4785                	li	a5,1
    80006ee8:	cc9c                	sw	a5,24(s1)
}
    80006eea:	60e2                	ld	ra,24(sp)
    80006eec:	6442                	ld	s0,16(sp)
    80006eee:	64a2                	ld	s1,8(sp)
    80006ef0:	6105                	addi	sp,sp,32
    80006ef2:	8082                	ret

0000000080006ef4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006ef4:	1141                	addi	sp,sp,-16
    80006ef6:	e406                	sd	ra,8(sp)
    80006ef8:	e022                	sd	s0,0(sp)
    80006efa:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006efc:	100007b7          	lui	a5,0x10000
    80006f00:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006f04:	f8000713          	li	a4,-128
    80006f08:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006f0c:	470d                	li	a4,3
    80006f0e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006f12:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006f16:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006f1a:	469d                	li	a3,7
    80006f1c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006f20:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006f24:	00003597          	auipc	a1,0x3
    80006f28:	96458593          	addi	a1,a1,-1692 # 80009888 <digits+0x18>
    80006f2c:	0001c517          	auipc	a0,0x1c
    80006f30:	4fc50513          	addi	a0,a0,1276 # 80023428 <uart_tx_lock>
    80006f34:	00000097          	auipc	ra,0x0
    80006f38:	218080e7          	jalr	536(ra) # 8000714c <initlock>
}
    80006f3c:	60a2                	ld	ra,8(sp)
    80006f3e:	6402                	ld	s0,0(sp)
    80006f40:	0141                	addi	sp,sp,16
    80006f42:	8082                	ret

0000000080006f44 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006f44:	1101                	addi	sp,sp,-32
    80006f46:	ec06                	sd	ra,24(sp)
    80006f48:	e822                	sd	s0,16(sp)
    80006f4a:	e426                	sd	s1,8(sp)
    80006f4c:	1000                	addi	s0,sp,32
    80006f4e:	84aa                	mv	s1,a0
  push_off();
    80006f50:	00000097          	auipc	ra,0x0
    80006f54:	240080e7          	jalr	576(ra) # 80007190 <push_off>

  if(panicked){
    80006f58:	00003797          	auipc	a5,0x3
    80006f5c:	a187a783          	lw	a5,-1512(a5) # 80009970 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006f60:	10000737          	lui	a4,0x10000
  if(panicked){
    80006f64:	c391                	beqz	a5,80006f68 <uartputc_sync+0x24>
    for(;;)
    80006f66:	a001                	j	80006f66 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006f68:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006f6c:	0ff7f793          	andi	a5,a5,255
    80006f70:	0207f793          	andi	a5,a5,32
    80006f74:	dbf5                	beqz	a5,80006f68 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006f76:	0ff4f793          	andi	a5,s1,255
    80006f7a:	10000737          	lui	a4,0x10000
    80006f7e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006f82:	00000097          	auipc	ra,0x0
    80006f86:	2ae080e7          	jalr	686(ra) # 80007230 <pop_off>
}
    80006f8a:	60e2                	ld	ra,24(sp)
    80006f8c:	6442                	ld	s0,16(sp)
    80006f8e:	64a2                	ld	s1,8(sp)
    80006f90:	6105                	addi	sp,sp,32
    80006f92:	8082                	ret

0000000080006f94 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006f94:	00003717          	auipc	a4,0x3
    80006f98:	9e473703          	ld	a4,-1564(a4) # 80009978 <uart_tx_r>
    80006f9c:	00003797          	auipc	a5,0x3
    80006fa0:	9e47b783          	ld	a5,-1564(a5) # 80009980 <uart_tx_w>
    80006fa4:	06e78c63          	beq	a5,a4,8000701c <uartstart+0x88>
{
    80006fa8:	7139                	addi	sp,sp,-64
    80006faa:	fc06                	sd	ra,56(sp)
    80006fac:	f822                	sd	s0,48(sp)
    80006fae:	f426                	sd	s1,40(sp)
    80006fb0:	f04a                	sd	s2,32(sp)
    80006fb2:	ec4e                	sd	s3,24(sp)
    80006fb4:	e852                	sd	s4,16(sp)
    80006fb6:	e456                	sd	s5,8(sp)
    80006fb8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006fba:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006fbe:	0001ca17          	auipc	s4,0x1c
    80006fc2:	46aa0a13          	addi	s4,s4,1130 # 80023428 <uart_tx_lock>
    uart_tx_r += 1;
    80006fc6:	00003497          	auipc	s1,0x3
    80006fca:	9b248493          	addi	s1,s1,-1614 # 80009978 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006fce:	00003997          	auipc	s3,0x3
    80006fd2:	9b298993          	addi	s3,s3,-1614 # 80009980 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006fd6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006fda:	0ff7f793          	andi	a5,a5,255
    80006fde:	0207f793          	andi	a5,a5,32
    80006fe2:	c785                	beqz	a5,8000700a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006fe4:	01f77793          	andi	a5,a4,31
    80006fe8:	97d2                	add	a5,a5,s4
    80006fea:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006fee:	0705                	addi	a4,a4,1
    80006ff0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006ff2:	8526                	mv	a0,s1
    80006ff4:	ffffa097          	auipc	ra,0xffffa
    80006ff8:	600080e7          	jalr	1536(ra) # 800015f4 <wakeup>
    
    WriteReg(THR, c);
    80006ffc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80007000:	6098                	ld	a4,0(s1)
    80007002:	0009b783          	ld	a5,0(s3)
    80007006:	fce798e3          	bne	a5,a4,80006fd6 <uartstart+0x42>
  }
}
    8000700a:	70e2                	ld	ra,56(sp)
    8000700c:	7442                	ld	s0,48(sp)
    8000700e:	74a2                	ld	s1,40(sp)
    80007010:	7902                	ld	s2,32(sp)
    80007012:	69e2                	ld	s3,24(sp)
    80007014:	6a42                	ld	s4,16(sp)
    80007016:	6aa2                	ld	s5,8(sp)
    80007018:	6121                	addi	sp,sp,64
    8000701a:	8082                	ret
    8000701c:	8082                	ret

000000008000701e <uartputc>:
{
    8000701e:	7179                	addi	sp,sp,-48
    80007020:	f406                	sd	ra,40(sp)
    80007022:	f022                	sd	s0,32(sp)
    80007024:	ec26                	sd	s1,24(sp)
    80007026:	e84a                	sd	s2,16(sp)
    80007028:	e44e                	sd	s3,8(sp)
    8000702a:	e052                	sd	s4,0(sp)
    8000702c:	1800                	addi	s0,sp,48
    8000702e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80007030:	0001c517          	auipc	a0,0x1c
    80007034:	3f850513          	addi	a0,a0,1016 # 80023428 <uart_tx_lock>
    80007038:	00000097          	auipc	ra,0x0
    8000703c:	1a4080e7          	jalr	420(ra) # 800071dc <acquire>
  if(panicked){
    80007040:	00003797          	auipc	a5,0x3
    80007044:	9307a783          	lw	a5,-1744(a5) # 80009970 <panicked>
    80007048:	e7c9                	bnez	a5,800070d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000704a:	00003797          	auipc	a5,0x3
    8000704e:	9367b783          	ld	a5,-1738(a5) # 80009980 <uart_tx_w>
    80007052:	00003717          	auipc	a4,0x3
    80007056:	92673703          	ld	a4,-1754(a4) # 80009978 <uart_tx_r>
    8000705a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000705e:	0001ca17          	auipc	s4,0x1c
    80007062:	3caa0a13          	addi	s4,s4,970 # 80023428 <uart_tx_lock>
    80007066:	00003497          	auipc	s1,0x3
    8000706a:	91248493          	addi	s1,s1,-1774 # 80009978 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000706e:	00003917          	auipc	s2,0x3
    80007072:	91290913          	addi	s2,s2,-1774 # 80009980 <uart_tx_w>
    80007076:	00f71f63          	bne	a4,a5,80007094 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000707a:	85d2                	mv	a1,s4
    8000707c:	8526                	mv	a0,s1
    8000707e:	ffffa097          	auipc	ra,0xffffa
    80007082:	512080e7          	jalr	1298(ra) # 80001590 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80007086:	00093783          	ld	a5,0(s2)
    8000708a:	6098                	ld	a4,0(s1)
    8000708c:	02070713          	addi	a4,a4,32
    80007090:	fef705e3          	beq	a4,a5,8000707a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80007094:	0001c497          	auipc	s1,0x1c
    80007098:	39448493          	addi	s1,s1,916 # 80023428 <uart_tx_lock>
    8000709c:	01f7f713          	andi	a4,a5,31
    800070a0:	9726                	add	a4,a4,s1
    800070a2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800070a6:	0785                	addi	a5,a5,1
    800070a8:	00003717          	auipc	a4,0x3
    800070ac:	8cf73c23          	sd	a5,-1832(a4) # 80009980 <uart_tx_w>
  uartstart();
    800070b0:	00000097          	auipc	ra,0x0
    800070b4:	ee4080e7          	jalr	-284(ra) # 80006f94 <uartstart>
  release(&uart_tx_lock);
    800070b8:	8526                	mv	a0,s1
    800070ba:	00000097          	auipc	ra,0x0
    800070be:	1d6080e7          	jalr	470(ra) # 80007290 <release>
}
    800070c2:	70a2                	ld	ra,40(sp)
    800070c4:	7402                	ld	s0,32(sp)
    800070c6:	64e2                	ld	s1,24(sp)
    800070c8:	6942                	ld	s2,16(sp)
    800070ca:	69a2                	ld	s3,8(sp)
    800070cc:	6a02                	ld	s4,0(sp)
    800070ce:	6145                	addi	sp,sp,48
    800070d0:	8082                	ret
    for(;;)
    800070d2:	a001                	j	800070d2 <uartputc+0xb4>

00000000800070d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800070d4:	1141                	addi	sp,sp,-16
    800070d6:	e422                	sd	s0,8(sp)
    800070d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800070da:	100007b7          	lui	a5,0x10000
    800070de:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800070e2:	8b85                	andi	a5,a5,1
    800070e4:	cb91                	beqz	a5,800070f8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800070e6:	100007b7          	lui	a5,0x10000
    800070ea:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800070ee:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800070f2:	6422                	ld	s0,8(sp)
    800070f4:	0141                	addi	sp,sp,16
    800070f6:	8082                	ret
    return -1;
    800070f8:	557d                	li	a0,-1
    800070fa:	bfe5                	j	800070f2 <uartgetc+0x1e>

00000000800070fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800070fc:	1101                	addi	sp,sp,-32
    800070fe:	ec06                	sd	ra,24(sp)
    80007100:	e822                	sd	s0,16(sp)
    80007102:	e426                	sd	s1,8(sp)
    80007104:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80007106:	54fd                	li	s1,-1
    int c = uartgetc();
    80007108:	00000097          	auipc	ra,0x0
    8000710c:	fcc080e7          	jalr	-52(ra) # 800070d4 <uartgetc>
    if(c == -1)
    80007110:	00950763          	beq	a0,s1,8000711e <uartintr+0x22>
      break;
    consoleintr(c);
    80007114:	00000097          	auipc	ra,0x0
    80007118:	8fe080e7          	jalr	-1794(ra) # 80006a12 <consoleintr>
  while(1){
    8000711c:	b7f5                	j	80007108 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000711e:	0001c497          	auipc	s1,0x1c
    80007122:	30a48493          	addi	s1,s1,778 # 80023428 <uart_tx_lock>
    80007126:	8526                	mv	a0,s1
    80007128:	00000097          	auipc	ra,0x0
    8000712c:	0b4080e7          	jalr	180(ra) # 800071dc <acquire>
  uartstart();
    80007130:	00000097          	auipc	ra,0x0
    80007134:	e64080e7          	jalr	-412(ra) # 80006f94 <uartstart>
  release(&uart_tx_lock);
    80007138:	8526                	mv	a0,s1
    8000713a:	00000097          	auipc	ra,0x0
    8000713e:	156080e7          	jalr	342(ra) # 80007290 <release>
}
    80007142:	60e2                	ld	ra,24(sp)
    80007144:	6442                	ld	s0,16(sp)
    80007146:	64a2                	ld	s1,8(sp)
    80007148:	6105                	addi	sp,sp,32
    8000714a:	8082                	ret

000000008000714c <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    8000714c:	1141                	addi	sp,sp,-16
    8000714e:	e422                	sd	s0,8(sp)
    80007150:	0800                	addi	s0,sp,16
  lk->name = name;
    80007152:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80007154:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80007158:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    8000715c:	6422                	ld	s0,8(sp)
    8000715e:	0141                	addi	sp,sp,16
    80007160:	8082                	ret

0000000080007162 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80007162:	411c                	lw	a5,0(a0)
    80007164:	e399                	bnez	a5,8000716a <holding+0x8>
    80007166:	4501                	li	a0,0
  return r;
}
    80007168:	8082                	ret
{
    8000716a:	1101                	addi	sp,sp,-32
    8000716c:	ec06                	sd	ra,24(sp)
    8000716e:	e822                	sd	s0,16(sp)
    80007170:	e426                	sd	s1,8(sp)
    80007172:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80007174:	6904                	ld	s1,16(a0)
    80007176:	ffffa097          	auipc	ra,0xffffa
    8000717a:	d56080e7          	jalr	-682(ra) # 80000ecc <mycpu>
    8000717e:	40a48533          	sub	a0,s1,a0
    80007182:	00153513          	seqz	a0,a0
}
    80007186:	60e2                	ld	ra,24(sp)
    80007188:	6442                	ld	s0,16(sp)
    8000718a:	64a2                	ld	s1,8(sp)
    8000718c:	6105                	addi	sp,sp,32
    8000718e:	8082                	ret

0000000080007190 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80007190:	1101                	addi	sp,sp,-32
    80007192:	ec06                	sd	ra,24(sp)
    80007194:	e822                	sd	s0,16(sp)
    80007196:	e426                	sd	s1,8(sp)
    80007198:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000719a:	100024f3          	csrr	s1,sstatus
    8000719e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800071a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800071a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800071a8:	ffffa097          	auipc	ra,0xffffa
    800071ac:	d24080e7          	jalr	-732(ra) # 80000ecc <mycpu>
    800071b0:	5d3c                	lw	a5,120(a0)
    800071b2:	cf89                	beqz	a5,800071cc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800071b4:	ffffa097          	auipc	ra,0xffffa
    800071b8:	d18080e7          	jalr	-744(ra) # 80000ecc <mycpu>
    800071bc:	5d3c                	lw	a5,120(a0)
    800071be:	2785                	addiw	a5,a5,1
    800071c0:	dd3c                	sw	a5,120(a0)
}
    800071c2:	60e2                	ld	ra,24(sp)
    800071c4:	6442                	ld	s0,16(sp)
    800071c6:	64a2                	ld	s1,8(sp)
    800071c8:	6105                	addi	sp,sp,32
    800071ca:	8082                	ret
    mycpu()->intena = old;
    800071cc:	ffffa097          	auipc	ra,0xffffa
    800071d0:	d00080e7          	jalr	-768(ra) # 80000ecc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800071d4:	8085                	srli	s1,s1,0x1
    800071d6:	8885                	andi	s1,s1,1
    800071d8:	dd64                	sw	s1,124(a0)
    800071da:	bfe9                	j	800071b4 <push_off+0x24>

00000000800071dc <acquire>:
{
    800071dc:	1101                	addi	sp,sp,-32
    800071de:	ec06                	sd	ra,24(sp)
    800071e0:	e822                	sd	s0,16(sp)
    800071e2:	e426                	sd	s1,8(sp)
    800071e4:	1000                	addi	s0,sp,32
    800071e6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800071e8:	00000097          	auipc	ra,0x0
    800071ec:	fa8080e7          	jalr	-88(ra) # 80007190 <push_off>
  if(holding(lk))
    800071f0:	8526                	mv	a0,s1
    800071f2:	00000097          	auipc	ra,0x0
    800071f6:	f70080e7          	jalr	-144(ra) # 80007162 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800071fa:	4705                	li	a4,1
  if(holding(lk))
    800071fc:	e115                	bnez	a0,80007220 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800071fe:	87ba                	mv	a5,a4
    80007200:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80007204:	2781                	sext.w	a5,a5
    80007206:	ffe5                	bnez	a5,800071fe <acquire+0x22>
  __sync_synchronize();
    80007208:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000720c:	ffffa097          	auipc	ra,0xffffa
    80007210:	cc0080e7          	jalr	-832(ra) # 80000ecc <mycpu>
    80007214:	e888                	sd	a0,16(s1)
}
    80007216:	60e2                	ld	ra,24(sp)
    80007218:	6442                	ld	s0,16(sp)
    8000721a:	64a2                	ld	s1,8(sp)
    8000721c:	6105                	addi	sp,sp,32
    8000721e:	8082                	ret
    panic("acquire");
    80007220:	00002517          	auipc	a0,0x2
    80007224:	67050513          	addi	a0,a0,1648 # 80009890 <digits+0x20>
    80007228:	00000097          	auipc	ra,0x0
    8000722c:	a6a080e7          	jalr	-1430(ra) # 80006c92 <panic>

0000000080007230 <pop_off>:

void
pop_off(void)
{
    80007230:	1141                	addi	sp,sp,-16
    80007232:	e406                	sd	ra,8(sp)
    80007234:	e022                	sd	s0,0(sp)
    80007236:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80007238:	ffffa097          	auipc	ra,0xffffa
    8000723c:	c94080e7          	jalr	-876(ra) # 80000ecc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007240:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80007244:	8b89                	andi	a5,a5,2
  if(intr_get())
    80007246:	e78d                	bnez	a5,80007270 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80007248:	5d3c                	lw	a5,120(a0)
    8000724a:	02f05b63          	blez	a5,80007280 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000724e:	37fd                	addiw	a5,a5,-1
    80007250:	0007871b          	sext.w	a4,a5
    80007254:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80007256:	eb09                	bnez	a4,80007268 <pop_off+0x38>
    80007258:	5d7c                	lw	a5,124(a0)
    8000725a:	c799                	beqz	a5,80007268 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000725c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80007260:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80007264:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80007268:	60a2                	ld	ra,8(sp)
    8000726a:	6402                	ld	s0,0(sp)
    8000726c:	0141                	addi	sp,sp,16
    8000726e:	8082                	ret
    panic("pop_off - interruptible");
    80007270:	00002517          	auipc	a0,0x2
    80007274:	62850513          	addi	a0,a0,1576 # 80009898 <digits+0x28>
    80007278:	00000097          	auipc	ra,0x0
    8000727c:	a1a080e7          	jalr	-1510(ra) # 80006c92 <panic>
    panic("pop_off");
    80007280:	00002517          	auipc	a0,0x2
    80007284:	63050513          	addi	a0,a0,1584 # 800098b0 <digits+0x40>
    80007288:	00000097          	auipc	ra,0x0
    8000728c:	a0a080e7          	jalr	-1526(ra) # 80006c92 <panic>

0000000080007290 <release>:
{
    80007290:	1101                	addi	sp,sp,-32
    80007292:	ec06                	sd	ra,24(sp)
    80007294:	e822                	sd	s0,16(sp)
    80007296:	e426                	sd	s1,8(sp)
    80007298:	1000                	addi	s0,sp,32
    8000729a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000729c:	00000097          	auipc	ra,0x0
    800072a0:	ec6080e7          	jalr	-314(ra) # 80007162 <holding>
    800072a4:	c115                	beqz	a0,800072c8 <release+0x38>
  lk->cpu = 0;
    800072a6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800072aa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800072ae:	0f50000f          	fence	iorw,ow
    800072b2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800072b6:	00000097          	auipc	ra,0x0
    800072ba:	f7a080e7          	jalr	-134(ra) # 80007230 <pop_off>
}
    800072be:	60e2                	ld	ra,24(sp)
    800072c0:	6442                	ld	s0,16(sp)
    800072c2:	64a2                	ld	s1,8(sp)
    800072c4:	6105                	addi	sp,sp,32
    800072c6:	8082                	ret
    panic("release");
    800072c8:	00002517          	auipc	a0,0x2
    800072cc:	5f050513          	addi	a0,a0,1520 # 800098b8 <digits+0x48>
    800072d0:	00000097          	auipc	ra,0x0
    800072d4:	9c2080e7          	jalr	-1598(ra) # 80006c92 <panic>

00000000800072d8 <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    800072d8:	1141                	addi	sp,sp,-16
    800072da:	e422                	sd	s0,8(sp)
    800072dc:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800072de:	0ff0000f          	fence
    800072e2:	4108                	lw	a0,0(a0)
    800072e4:	0ff0000f          	fence
  return val;
}
    800072e8:	2501                	sext.w	a0,a0
    800072ea:	6422                	ld	s0,8(sp)
    800072ec:	0141                	addi	sp,sp,16
    800072ee:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
