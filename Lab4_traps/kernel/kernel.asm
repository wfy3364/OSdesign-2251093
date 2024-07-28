
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	90013103          	ld	sp,-1792(sp) # 80008900 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	107050ef          	jal	ra,8000591c <start>

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
    80000030:	00027797          	auipc	a5,0x27
    80000034:	b9078793          	addi	a5,a5,-1136 # 80026bc0 <end>
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
    80000054:	90090913          	addi	s2,s2,-1792 # 80008950 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	31e080e7          	jalr	798(ra) # 80006378 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3be080e7          	jalr	958(ra) # 8000642c <release>
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
    8000008e:	d48080e7          	jalr	-696(ra) # 80005dd2 <panic>

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
    800000f0:	86450513          	addi	a0,a0,-1948 # 80008950 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	1f4080e7          	jalr	500(ra) # 800062e8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00027517          	auipc	a0,0x27
    80000104:	ac050513          	addi	a0,a0,-1344 # 80026bc0 <end>
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
    80000126:	82e48493          	addi	s1,s1,-2002 # 80008950 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	24c080e7          	jalr	588(ra) # 80006378 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	81650513          	addi	a0,a0,-2026 # 80008950 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2e8080e7          	jalr	744(ra) # 8000642c <release>

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
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	7ea50513          	addi	a0,a0,2026 # 80008950 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2be080e7          	jalr	702(ra) # 8000642c <release>
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
    80000332:	b58080e7          	jalr	-1192(ra) # 80000e86 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	5ea70713          	addi	a4,a4,1514 # 80008920 <started>
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
    8000034e:	b3c080e7          	jalr	-1220(ra) # 80000e86 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ac0080e7          	jalr	-1344(ra) # 80005e1c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	82e080e7          	jalr	-2002(ra) # 80001b9a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	efc080e7          	jalr	-260(ra) # 80005270 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	056080e7          	jalr	86(ra) # 800013d2 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	960080e7          	jalr	-1696(ra) # 80005ce4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c76080e7          	jalr	-906(ra) # 80006002 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a80080e7          	jalr	-1408(ra) # 80005e1c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a70080e7          	jalr	-1424(ra) # 80005e1c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a60080e7          	jalr	-1440(ra) # 80005e1c <printf>
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
    800003e0:	9f4080e7          	jalr	-1548(ra) # 80000dd0 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	78e080e7          	jalr	1934(ra) # 80001b72 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	7ae080e7          	jalr	1966(ra) # 80001b9a <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e66080e7          	jalr	-410(ra) # 8000525a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	e74080e7          	jalr	-396(ra) # 80005270 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	016080e7          	jalr	22(ra) # 8000241a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	6ba080e7          	jalr	1722(ra) # 80002ac6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	65c080e7          	jalr	1628(ra) # 80003a70 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	f5c080e7          	jalr	-164(ra) # 80005378 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d80080e7          	jalr	-640(ra) # 800011a4 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	4ef72723          	sw	a5,1262(a4) # 80008920 <started>
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
    8000044a:	4e27b783          	ld	a5,1250(a5) # 80008928 <kernel_pagetable>
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
    80000496:	940080e7          	jalr	-1728(ra) # 80005dd2 <panic>
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
    80000592:	844080e7          	jalr	-1980(ra) # 80005dd2 <panic>
    panic("mappages: size not aligned");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ae250513          	addi	a0,a0,-1310 # 80008078 <etext+0x78>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	834080e7          	jalr	-1996(ra) # 80005dd2 <panic>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	af250513          	addi	a0,a0,-1294 # 80008098 <etext+0x98>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	824080e7          	jalr	-2012(ra) # 80005dd2 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	af250513          	addi	a0,a0,-1294 # 800080a8 <etext+0xa8>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	814080e7          	jalr	-2028(ra) # 80005dd2 <panic>
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
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	79a080e7          	jalr	1946(ra) # 80005dd2 <panic>

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
    80000704:	63a080e7          	jalr	1594(ra) # 80000d3a <proc_mapstacks>
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
    8000072a:	20a7b123          	sd	a0,514(a5) # 80008928 <kernel_pagetable>
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
    80000788:	64e080e7          	jalr	1614(ra) # 80005dd2 <panic>
      panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	94c50513          	addi	a0,a0,-1716 # 800080d8 <etext+0xd8>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	63e080e7          	jalr	1598(ra) # 80005dd2 <panic>
      panic("uvmunmap: not mapped");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	94c50513          	addi	a0,a0,-1716 # 800080e8 <etext+0xe8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	62e080e7          	jalr	1582(ra) # 80005dd2 <panic>
      panic("uvmunmap: not a leaf");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	95450513          	addi	a0,a0,-1708 # 80008100 <etext+0x100>
    800007b4:	00005097          	auipc	ra,0x5
    800007b8:	61e080e7          	jalr	1566(ra) # 80005dd2 <panic>
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
    80000896:	540080e7          	jalr	1344(ra) # 80005dd2 <panic>

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
    800009e0:	3f6080e7          	jalr	1014(ra) # 80005dd2 <panic>
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
    80000abc:	31a080e7          	jalr	794(ra) # 80005dd2 <panic>
      panic("uvmcopy: page not present");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	6a850513          	addi	a0,a0,1704 # 80008168 <etext+0x168>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	30a080e7          	jalr	778(ra) # 80005dd2 <panic>
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
    80000b36:	2a0080e7          	jalr	672(ra) # 80005dd2 <panic>

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

0000000080000d3a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d3a:	7139                	addi	sp,sp,-64
    80000d3c:	fc06                	sd	ra,56(sp)
    80000d3e:	f822                	sd	s0,48(sp)
    80000d40:	f426                	sd	s1,40(sp)
    80000d42:	f04a                	sd	s2,32(sp)
    80000d44:	ec4e                	sd	s3,24(sp)
    80000d46:	e852                	sd	s4,16(sp)
    80000d48:	e456                	sd	s5,8(sp)
    80000d4a:	e05a                	sd	s6,0(sp)
    80000d4c:	0080                	addi	s0,sp,64
    80000d4e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	00008497          	auipc	s1,0x8
    80000d54:	05048493          	addi	s1,s1,80 # 80008da0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d58:	8b26                	mv	s6,s1
    80000d5a:	00007a97          	auipc	s5,0x7
    80000d5e:	2a6a8a93          	addi	s5,s5,678 # 80008000 <etext>
    80000d62:	04000937          	lui	s2,0x4000
    80000d66:	197d                	addi	s2,s2,-1
    80000d68:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d6a:	00013a17          	auipc	s4,0x13
    80000d6e:	836a0a13          	addi	s4,s4,-1994 # 800135a0 <tickslock>
    char *pa = kalloc();
    80000d72:	fffff097          	auipc	ra,0xfffff
    80000d76:	3a6080e7          	jalr	934(ra) # 80000118 <kalloc>
    80000d7a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d7c:	c131                	beqz	a0,80000dc0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d7e:	416485b3          	sub	a1,s1,s6
    80000d82:	8595                	srai	a1,a1,0x5
    80000d84:	000ab783          	ld	a5,0(s5)
    80000d88:	02f585b3          	mul	a1,a1,a5
    80000d8c:	2585                	addiw	a1,a1,1
    80000d8e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d92:	4719                	li	a4,6
    80000d94:	6685                	lui	a3,0x1
    80000d96:	40b905b3          	sub	a1,s2,a1
    80000d9a:	854e                	mv	a0,s3
    80000d9c:	00000097          	auipc	ra,0x0
    80000da0:	874080e7          	jalr	-1932(ra) # 80000610 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da4:	2a048493          	addi	s1,s1,672
    80000da8:	fd4495e3          	bne	s1,s4,80000d72 <proc_mapstacks+0x38>
  }
}
    80000dac:	70e2                	ld	ra,56(sp)
    80000dae:	7442                	ld	s0,48(sp)
    80000db0:	74a2                	ld	s1,40(sp)
    80000db2:	7902                	ld	s2,32(sp)
    80000db4:	69e2                	ld	s3,24(sp)
    80000db6:	6a42                	ld	s4,16(sp)
    80000db8:	6aa2                	ld	s5,8(sp)
    80000dba:	6b02                	ld	s6,0(sp)
    80000dbc:	6121                	addi	sp,sp,64
    80000dbe:	8082                	ret
      panic("kalloc");
    80000dc0:	00007517          	auipc	a0,0x7
    80000dc4:	3d850513          	addi	a0,a0,984 # 80008198 <etext+0x198>
    80000dc8:	00005097          	auipc	ra,0x5
    80000dcc:	00a080e7          	jalr	10(ra) # 80005dd2 <panic>

0000000080000dd0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dd0:	7139                	addi	sp,sp,-64
    80000dd2:	fc06                	sd	ra,56(sp)
    80000dd4:	f822                	sd	s0,48(sp)
    80000dd6:	f426                	sd	s1,40(sp)
    80000dd8:	f04a                	sd	s2,32(sp)
    80000dda:	ec4e                	sd	s3,24(sp)
    80000ddc:	e852                	sd	s4,16(sp)
    80000dde:	e456                	sd	s5,8(sp)
    80000de0:	e05a                	sd	s6,0(sp)
    80000de2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000de4:	00007597          	auipc	a1,0x7
    80000de8:	3bc58593          	addi	a1,a1,956 # 800081a0 <etext+0x1a0>
    80000dec:	00008517          	auipc	a0,0x8
    80000df0:	b8450513          	addi	a0,a0,-1148 # 80008970 <pid_lock>
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	4f4080e7          	jalr	1268(ra) # 800062e8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dfc:	00007597          	auipc	a1,0x7
    80000e00:	3ac58593          	addi	a1,a1,940 # 800081a8 <etext+0x1a8>
    80000e04:	00008517          	auipc	a0,0x8
    80000e08:	b8450513          	addi	a0,a0,-1148 # 80008988 <wait_lock>
    80000e0c:	00005097          	auipc	ra,0x5
    80000e10:	4dc080e7          	jalr	1244(ra) # 800062e8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e14:	00008497          	auipc	s1,0x8
    80000e18:	f8c48493          	addi	s1,s1,-116 # 80008da0 <proc>
      initlock(&p->lock, "proc");
    80000e1c:	00007b17          	auipc	s6,0x7
    80000e20:	39cb0b13          	addi	s6,s6,924 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e24:	8aa6                	mv	s5,s1
    80000e26:	00007a17          	auipc	s4,0x7
    80000e2a:	1daa0a13          	addi	s4,s4,474 # 80008000 <etext>
    80000e2e:	04000937          	lui	s2,0x4000
    80000e32:	197d                	addi	s2,s2,-1
    80000e34:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	00012997          	auipc	s3,0x12
    80000e3a:	76a98993          	addi	s3,s3,1898 # 800135a0 <tickslock>
      initlock(&p->lock, "proc");
    80000e3e:	85da                	mv	a1,s6
    80000e40:	8526                	mv	a0,s1
    80000e42:	00005097          	auipc	ra,0x5
    80000e46:	4a6080e7          	jalr	1190(ra) # 800062e8 <initlock>
      p->state = UNUSED;
    80000e4a:	1404aa23          	sw	zero,340(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e4e:	415487b3          	sub	a5,s1,s5
    80000e52:	8795                	srai	a5,a5,0x5
    80000e54:	000a3703          	ld	a4,0(s4)
    80000e58:	02e787b3          	mul	a5,a5,a4
    80000e5c:	2785                	addiw	a5,a5,1
    80000e5e:	00d7979b          	slliw	a5,a5,0xd
    80000e62:	40f907b3          	sub	a5,s2,a5
    80000e66:	16f4bc23          	sd	a5,376(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e6a:	2a048493          	addi	s1,s1,672
    80000e6e:	fd3498e3          	bne	s1,s3,80000e3e <procinit+0x6e>
  }
}
    80000e72:	70e2                	ld	ra,56(sp)
    80000e74:	7442                	ld	s0,48(sp)
    80000e76:	74a2                	ld	s1,40(sp)
    80000e78:	7902                	ld	s2,32(sp)
    80000e7a:	69e2                	ld	s3,24(sp)
    80000e7c:	6a42                	ld	s4,16(sp)
    80000e7e:	6aa2                	ld	s5,8(sp)
    80000e80:	6b02                	ld	s6,0(sp)
    80000e82:	6121                	addi	sp,sp,64
    80000e84:	8082                	ret

0000000080000e86 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e86:	1141                	addi	sp,sp,-16
    80000e88:	e422                	sd	s0,8(sp)
    80000e8a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e8c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e8e:	2501                	sext.w	a0,a0
    80000e90:	6422                	ld	s0,8(sp)
    80000e92:	0141                	addi	sp,sp,16
    80000e94:	8082                	ret

0000000080000e96 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e96:	1141                	addi	sp,sp,-16
    80000e98:	e422                	sd	s0,8(sp)
    80000e9a:	0800                	addi	s0,sp,16
    80000e9c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e9e:	2781                	sext.w	a5,a5
    80000ea0:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ea2:	00008517          	auipc	a0,0x8
    80000ea6:	afe50513          	addi	a0,a0,-1282 # 800089a0 <cpus>
    80000eaa:	953e                	add	a0,a0,a5
    80000eac:	6422                	ld	s0,8(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret

0000000080000eb2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eb2:	1101                	addi	sp,sp,-32
    80000eb4:	ec06                	sd	ra,24(sp)
    80000eb6:	e822                	sd	s0,16(sp)
    80000eb8:	e426                	sd	s1,8(sp)
    80000eba:	1000                	addi	s0,sp,32
  push_off();
    80000ebc:	00005097          	auipc	ra,0x5
    80000ec0:	470080e7          	jalr	1136(ra) # 8000632c <push_off>
    80000ec4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	079e                	slli	a5,a5,0x7
    80000eca:	00008717          	auipc	a4,0x8
    80000ece:	aa670713          	addi	a4,a4,-1370 # 80008970 <pid_lock>
    80000ed2:	97ba                	add	a5,a5,a4
    80000ed4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	4f6080e7          	jalr	1270(ra) # 800063cc <pop_off>
  return p;
}
    80000ede:	8526                	mv	a0,s1
    80000ee0:	60e2                	ld	ra,24(sp)
    80000ee2:	6442                	ld	s0,16(sp)
    80000ee4:	64a2                	ld	s1,8(sp)
    80000ee6:	6105                	addi	sp,sp,32
    80000ee8:	8082                	ret

0000000080000eea <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e406                	sd	ra,8(sp)
    80000eee:	e022                	sd	s0,0(sp)
    80000ef0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ef2:	00000097          	auipc	ra,0x0
    80000ef6:	fc0080e7          	jalr	-64(ra) # 80000eb2 <myproc>
    80000efa:	00005097          	auipc	ra,0x5
    80000efe:	532080e7          	jalr	1330(ra) # 8000642c <release>

  if (first) {
    80000f02:	00008797          	auipc	a5,0x8
    80000f06:	9ae7a783          	lw	a5,-1618(a5) # 800088b0 <first.1688>
    80000f0a:	eb89                	bnez	a5,80000f1c <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f0c:	00001097          	auipc	ra,0x1
    80000f10:	ca6080e7          	jalr	-858(ra) # 80001bb2 <usertrapret>
}
    80000f14:	60a2                	ld	ra,8(sp)
    80000f16:	6402                	ld	s0,0(sp)
    80000f18:	0141                	addi	sp,sp,16
    80000f1a:	8082                	ret
    fsinit(ROOTDEV);
    80000f1c:	4505                	li	a0,1
    80000f1e:	00002097          	auipc	ra,0x2
    80000f22:	b28080e7          	jalr	-1240(ra) # 80002a46 <fsinit>
    first = 0;
    80000f26:	00008797          	auipc	a5,0x8
    80000f2a:	9807a523          	sw	zero,-1654(a5) # 800088b0 <first.1688>
    __sync_synchronize();
    80000f2e:	0ff0000f          	fence
    80000f32:	bfe9                	j	80000f0c <forkret+0x22>

0000000080000f34 <allocpid>:
{
    80000f34:	1101                	addi	sp,sp,-32
    80000f36:	ec06                	sd	ra,24(sp)
    80000f38:	e822                	sd	s0,16(sp)
    80000f3a:	e426                	sd	s1,8(sp)
    80000f3c:	e04a                	sd	s2,0(sp)
    80000f3e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f40:	00008917          	auipc	s2,0x8
    80000f44:	a3090913          	addi	s2,s2,-1488 # 80008970 <pid_lock>
    80000f48:	854a                	mv	a0,s2
    80000f4a:	00005097          	auipc	ra,0x5
    80000f4e:	42e080e7          	jalr	1070(ra) # 80006378 <acquire>
  pid = nextpid;
    80000f52:	00008797          	auipc	a5,0x8
    80000f56:	96278793          	addi	a5,a5,-1694 # 800088b4 <nextpid>
    80000f5a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f5c:	0014871b          	addiw	a4,s1,1
    80000f60:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f62:	854a                	mv	a0,s2
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	4c8080e7          	jalr	1224(ra) # 8000642c <release>
}
    80000f6c:	8526                	mv	a0,s1
    80000f6e:	60e2                	ld	ra,24(sp)
    80000f70:	6442                	ld	s0,16(sp)
    80000f72:	64a2                	ld	s1,8(sp)
    80000f74:	6902                	ld	s2,0(sp)
    80000f76:	6105                	addi	sp,sp,32
    80000f78:	8082                	ret

0000000080000f7a <proc_pagetable>:
{
    80000f7a:	1101                	addi	sp,sp,-32
    80000f7c:	ec06                	sd	ra,24(sp)
    80000f7e:	e822                	sd	s0,16(sp)
    80000f80:	e426                	sd	s1,8(sp)
    80000f82:	e04a                	sd	s2,0(sp)
    80000f84:	1000                	addi	s0,sp,32
    80000f86:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f88:	00000097          	auipc	ra,0x0
    80000f8c:	872080e7          	jalr	-1934(ra) # 800007fa <uvmcreate>
    80000f90:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f92:	c121                	beqz	a0,80000fd2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f94:	4729                	li	a4,10
    80000f96:	00006697          	auipc	a3,0x6
    80000f9a:	06a68693          	addi	a3,a3,106 # 80007000 <_trampoline>
    80000f9e:	6605                	lui	a2,0x1
    80000fa0:	040005b7          	lui	a1,0x4000
    80000fa4:	15fd                	addi	a1,a1,-1
    80000fa6:	05b2                	slli	a1,a1,0xc
    80000fa8:	fffff097          	auipc	ra,0xfffff
    80000fac:	5a4080e7          	jalr	1444(ra) # 8000054c <mappages>
    80000fb0:	02054863          	bltz	a0,80000fe0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fb4:	4719                	li	a4,6
    80000fb6:	19093683          	ld	a3,400(s2)
    80000fba:	6605                	lui	a2,0x1
    80000fbc:	020005b7          	lui	a1,0x2000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b6                	slli	a1,a1,0xd
    80000fc4:	8526                	mv	a0,s1
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	586080e7          	jalr	1414(ra) # 8000054c <mappages>
    80000fce:	02054163          	bltz	a0,80000ff0 <proc_pagetable+0x76>
}
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6902                	ld	s2,0(sp)
    80000fdc:	6105                	addi	sp,sp,32
    80000fde:	8082                	ret
    uvmfree(pagetable, 0);
    80000fe0:	4581                	li	a1,0
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	00000097          	auipc	ra,0x0
    80000fe8:	a1a080e7          	jalr	-1510(ra) # 800009fe <uvmfree>
    return 0;
    80000fec:	4481                	li	s1,0
    80000fee:	b7d5                	j	80000fd2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ff0:	4681                	li	a3,0
    80000ff2:	4605                	li	a2,1
    80000ff4:	040005b7          	lui	a1,0x4000
    80000ff8:	15fd                	addi	a1,a1,-1
    80000ffa:	05b2                	slli	a1,a1,0xc
    80000ffc:	8526                	mv	a0,s1
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	738080e7          	jalr	1848(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    80001006:	4581                	li	a1,0
    80001008:	8526                	mv	a0,s1
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	9f4080e7          	jalr	-1548(ra) # 800009fe <uvmfree>
    return 0;
    80001012:	4481                	li	s1,0
    80001014:	bf7d                	j	80000fd2 <proc_pagetable+0x58>

0000000080001016 <proc_freepagetable>:
{
    80001016:	1101                	addi	sp,sp,-32
    80001018:	ec06                	sd	ra,24(sp)
    8000101a:	e822                	sd	s0,16(sp)
    8000101c:	e426                	sd	s1,8(sp)
    8000101e:	e04a                	sd	s2,0(sp)
    80001020:	1000                	addi	s0,sp,32
    80001022:	84aa                	mv	s1,a0
    80001024:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001026:	4681                	li	a3,0
    80001028:	4605                	li	a2,1
    8000102a:	040005b7          	lui	a1,0x4000
    8000102e:	15fd                	addi	a1,a1,-1
    80001030:	05b2                	slli	a1,a1,0xc
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	704080e7          	jalr	1796(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000103a:	4681                	li	a3,0
    8000103c:	4605                	li	a2,1
    8000103e:	020005b7          	lui	a1,0x2000
    80001042:	15fd                	addi	a1,a1,-1
    80001044:	05b6                	slli	a1,a1,0xd
    80001046:	8526                	mv	a0,s1
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	6ee080e7          	jalr	1774(ra) # 80000736 <uvmunmap>
  uvmfree(pagetable, sz);
    80001050:	85ca                	mv	a1,s2
    80001052:	8526                	mv	a0,s1
    80001054:	00000097          	auipc	ra,0x0
    80001058:	9aa080e7          	jalr	-1622(ra) # 800009fe <uvmfree>
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6902                	ld	s2,0(sp)
    80001064:	6105                	addi	sp,sp,32
    80001066:	8082                	ret

0000000080001068 <freeproc>:
{
    80001068:	1101                	addi	sp,sp,-32
    8000106a:	ec06                	sd	ra,24(sp)
    8000106c:	e822                	sd	s0,16(sp)
    8000106e:	e426                	sd	s1,8(sp)
    80001070:	1000                	addi	s0,sp,32
    80001072:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001074:	19053503          	ld	a0,400(a0)
    80001078:	c509                	beqz	a0,80001082 <freeproc+0x1a>
    kfree((void*)p->trapframe);
    8000107a:	fffff097          	auipc	ra,0xfffff
    8000107e:	fa2080e7          	jalr	-94(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001082:	1804b823          	sd	zero,400(s1)
  if(p->pagetable)
    80001086:	1884b503          	ld	a0,392(s1)
    8000108a:	c519                	beqz	a0,80001098 <freeproc+0x30>
    proc_freepagetable(p->pagetable, p->sz);
    8000108c:	1804b583          	ld	a1,384(s1)
    80001090:	00000097          	auipc	ra,0x0
    80001094:	f86080e7          	jalr	-122(ra) # 80001016 <proc_freepagetable>
  p->pagetable = 0;
    80001098:	1804b423          	sd	zero,392(s1)
  p->sz = 0;
    8000109c:	1804b023          	sd	zero,384(s1)
  p->pid = 0;
    800010a0:	1604a423          	sw	zero,360(s1)
  p->parent = 0;
    800010a4:	1604b823          	sd	zero,368(s1)
  p->name[0] = 0;
    800010a8:	28048823          	sb	zero,656(s1)
  p->chan = 0;
    800010ac:	1404bc23          	sd	zero,344(s1)
  p->killed = 0;
    800010b0:	1604a023          	sw	zero,352(s1)
  p->xstate = 0;
    800010b4:	1604a223          	sw	zero,356(s1)
  p->state = UNUSED;
    800010b8:	1404aa23          	sw	zero,340(s1)
}
    800010bc:	60e2                	ld	ra,24(sp)
    800010be:	6442                	ld	s0,16(sp)
    800010c0:	64a2                	ld	s1,8(sp)
    800010c2:	6105                	addi	sp,sp,32
    800010c4:	8082                	ret

00000000800010c6 <allocproc>:
{
    800010c6:	1101                	addi	sp,sp,-32
    800010c8:	ec06                	sd	ra,24(sp)
    800010ca:	e822                	sd	s0,16(sp)
    800010cc:	e426                	sd	s1,8(sp)
    800010ce:	e04a                	sd	s2,0(sp)
    800010d0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d2:	00008497          	auipc	s1,0x8
    800010d6:	cce48493          	addi	s1,s1,-818 # 80008da0 <proc>
    800010da:	00012917          	auipc	s2,0x12
    800010de:	4c690913          	addi	s2,s2,1222 # 800135a0 <tickslock>
    acquire(&p->lock);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00005097          	auipc	ra,0x5
    800010e8:	294080e7          	jalr	660(ra) # 80006378 <acquire>
    if(p->state == UNUSED) {
    800010ec:	1544a783          	lw	a5,340(s1)
    800010f0:	cf81                	beqz	a5,80001108 <allocproc+0x42>
      release(&p->lock);
    800010f2:	8526                	mv	a0,s1
    800010f4:	00005097          	auipc	ra,0x5
    800010f8:	338080e7          	jalr	824(ra) # 8000642c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010fc:	2a048493          	addi	s1,s1,672
    80001100:	ff2491e3          	bne	s1,s2,800010e2 <allocproc+0x1c>
  return 0;
    80001104:	4481                	li	s1,0
    80001106:	a085                	j	80001166 <allocproc+0xa0>
  p->pid = allocpid();
    80001108:	00000097          	auipc	ra,0x0
    8000110c:	e2c080e7          	jalr	-468(ra) # 80000f34 <allocpid>
    80001110:	16a4a423          	sw	a0,360(s1)
  p->state = USED;
    80001114:	4785                	li	a5,1
    80001116:	14f4aa23          	sw	a5,340(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	ffe080e7          	jalr	-2(ra) # 80000118 <kalloc>
    80001122:	892a                	mv	s2,a0
    80001124:	18a4b823          	sd	a0,400(s1)
    80001128:	c531                	beqz	a0,80001174 <allocproc+0xae>
  p->pagetable = proc_pagetable(p);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	e4e080e7          	jalr	-434(ra) # 80000f7a <proc_pagetable>
    80001134:	892a                	mv	s2,a0
    80001136:	18a4b423          	sd	a0,392(s1)
  if(p->pagetable == 0){
    8000113a:	c929                	beqz	a0,8000118c <allocproc+0xc6>
  memset(&p->context, 0, sizeof(p->context));
    8000113c:	07000613          	li	a2,112
    80001140:	4581                	li	a1,0
    80001142:	19848513          	addi	a0,s1,408
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	032080e7          	jalr	50(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000114e:	00000797          	auipc	a5,0x0
    80001152:	d9c78793          	addi	a5,a5,-612 # 80000eea <forkret>
    80001156:	18f4bc23          	sd	a5,408(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000115a:	1784b783          	ld	a5,376(s1)
    8000115e:	6705                	lui	a4,0x1
    80001160:	97ba                	add	a5,a5,a4
    80001162:	1af4b023          	sd	a5,416(s1)
}
    80001166:	8526                	mv	a0,s1
    80001168:	60e2                	ld	ra,24(sp)
    8000116a:	6442                	ld	s0,16(sp)
    8000116c:	64a2                	ld	s1,8(sp)
    8000116e:	6902                	ld	s2,0(sp)
    80001170:	6105                	addi	sp,sp,32
    80001172:	8082                	ret
    freeproc(p);
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	ef2080e7          	jalr	-270(ra) # 80001068 <freeproc>
    release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	2ac080e7          	jalr	684(ra) # 8000642c <release>
    return 0;
    80001188:	84ca                	mv	s1,s2
    8000118a:	bff1                	j	80001166 <allocproc+0xa0>
    freeproc(p);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	eda080e7          	jalr	-294(ra) # 80001068 <freeproc>
    release(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	294080e7          	jalr	660(ra) # 8000642c <release>
    return 0;
    800011a0:	84ca                	mv	s1,s2
    800011a2:	b7d1                	j	80001166 <allocproc+0xa0>

00000000800011a4 <userinit>:
{
    800011a4:	1101                	addi	sp,sp,-32
    800011a6:	ec06                	sd	ra,24(sp)
    800011a8:	e822                	sd	s0,16(sp)
    800011aa:	e426                	sd	s1,8(sp)
    800011ac:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	f18080e7          	jalr	-232(ra) # 800010c6 <allocproc>
    800011b6:	84aa                	mv	s1,a0
  initproc = p;
    800011b8:	00007797          	auipc	a5,0x7
    800011bc:	76a7bc23          	sd	a0,1912(a5) # 80008930 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011c0:	03400613          	li	a2,52
    800011c4:	00007597          	auipc	a1,0x7
    800011c8:	6fc58593          	addi	a1,a1,1788 # 800088c0 <initcode>
    800011cc:	18853503          	ld	a0,392(a0)
    800011d0:	fffff097          	auipc	ra,0xfffff
    800011d4:	658080e7          	jalr	1624(ra) # 80000828 <uvmfirst>
  p->sz = PGSIZE;
    800011d8:	6785                	lui	a5,0x1
    800011da:	18f4b023          	sd	a5,384(s1)
  p->trapframe->epc = 0;      // user program counter
    800011de:	1904b703          	ld	a4,400(s1)
    800011e2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011e6:	1904b703          	ld	a4,400(s1)
    800011ea:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ec:	4641                	li	a2,16
    800011ee:	00007597          	auipc	a1,0x7
    800011f2:	fd258593          	addi	a1,a1,-46 # 800081c0 <etext+0x1c0>
    800011f6:	29048513          	addi	a0,s1,656
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	0d0080e7          	jalr	208(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001202:	00007517          	auipc	a0,0x7
    80001206:	fce50513          	addi	a0,a0,-50 # 800081d0 <etext+0x1d0>
    8000120a:	00002097          	auipc	ra,0x2
    8000120e:	25e080e7          	jalr	606(ra) # 80003468 <namei>
    80001212:	28a4b423          	sd	a0,648(s1)
  p->state = RUNNABLE;
    80001216:	478d                	li	a5,3
    80001218:	14f4aa23          	sw	a5,340(s1)
  release(&p->lock);
    8000121c:	8526                	mv	a0,s1
    8000121e:	00005097          	auipc	ra,0x5
    80001222:	20e080e7          	jalr	526(ra) # 8000642c <release>
}
    80001226:	60e2                	ld	ra,24(sp)
    80001228:	6442                	ld	s0,16(sp)
    8000122a:	64a2                	ld	s1,8(sp)
    8000122c:	6105                	addi	sp,sp,32
    8000122e:	8082                	ret

0000000080001230 <growproc>:
{
    80001230:	1101                	addi	sp,sp,-32
    80001232:	ec06                	sd	ra,24(sp)
    80001234:	e822                	sd	s0,16(sp)
    80001236:	e426                	sd	s1,8(sp)
    80001238:	e04a                	sd	s2,0(sp)
    8000123a:	1000                	addi	s0,sp,32
    8000123c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	c74080e7          	jalr	-908(ra) # 80000eb2 <myproc>
    80001246:	84aa                	mv	s1,a0
  sz = p->sz;
    80001248:	18053583          	ld	a1,384(a0)
  if(n > 0){
    8000124c:	01204d63          	bgtz	s2,80001266 <growproc+0x36>
  } else if(n < 0){
    80001250:	02094863          	bltz	s2,80001280 <growproc+0x50>
  p->sz = sz;
    80001254:	18b4b023          	sd	a1,384(s1)
  return 0;
    80001258:	4501                	li	a0,0
}
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6902                	ld	s2,0(sp)
    80001262:	6105                	addi	sp,sp,32
    80001264:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001266:	4691                	li	a3,4
    80001268:	00b90633          	add	a2,s2,a1
    8000126c:	18853503          	ld	a0,392(a0)
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	672080e7          	jalr	1650(ra) # 800008e2 <uvmalloc>
    80001278:	85aa                	mv	a1,a0
    8000127a:	fd69                	bnez	a0,80001254 <growproc+0x24>
      return -1;
    8000127c:	557d                	li	a0,-1
    8000127e:	bff1                	j	8000125a <growproc+0x2a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001280:	00b90633          	add	a2,s2,a1
    80001284:	18853503          	ld	a0,392(a0)
    80001288:	fffff097          	auipc	ra,0xfffff
    8000128c:	612080e7          	jalr	1554(ra) # 8000089a <uvmdealloc>
    80001290:	85aa                	mv	a1,a0
    80001292:	b7c9                	j	80001254 <growproc+0x24>

0000000080001294 <fork>:
{
    80001294:	7179                	addi	sp,sp,-48
    80001296:	f406                	sd	ra,40(sp)
    80001298:	f022                	sd	s0,32(sp)
    8000129a:	ec26                	sd	s1,24(sp)
    8000129c:	e84a                	sd	s2,16(sp)
    8000129e:	e44e                	sd	s3,8(sp)
    800012a0:	e052                	sd	s4,0(sp)
    800012a2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	c0e080e7          	jalr	-1010(ra) # 80000eb2 <myproc>
    800012ac:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	e18080e7          	jalr	-488(ra) # 800010c6 <allocproc>
    800012b6:	10050c63          	beqz	a0,800013ce <fork+0x13a>
    800012ba:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012bc:	18093603          	ld	a2,384(s2)
    800012c0:	18853583          	ld	a1,392(a0)
    800012c4:	18893503          	ld	a0,392(s2)
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	76e080e7          	jalr	1902(ra) # 80000a36 <uvmcopy>
    800012d0:	04054663          	bltz	a0,8000131c <fork+0x88>
  np->sz = p->sz;
    800012d4:	18093783          	ld	a5,384(s2)
    800012d8:	18f9b023          	sd	a5,384(s3)
  *(np->trapframe) = *(p->trapframe);
    800012dc:	19093683          	ld	a3,400(s2)
    800012e0:	87b6                	mv	a5,a3
    800012e2:	1909b703          	ld	a4,400(s3)
    800012e6:	12068693          	addi	a3,a3,288
    800012ea:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ee:	6788                	ld	a0,8(a5)
    800012f0:	6b8c                	ld	a1,16(a5)
    800012f2:	6f90                	ld	a2,24(a5)
    800012f4:	01073023          	sd	a6,0(a4)
    800012f8:	e708                	sd	a0,8(a4)
    800012fa:	eb0c                	sd	a1,16(a4)
    800012fc:	ef10                	sd	a2,24(a4)
    800012fe:	02078793          	addi	a5,a5,32
    80001302:	02070713          	addi	a4,a4,32
    80001306:	fed792e3          	bne	a5,a3,800012ea <fork+0x56>
  np->trapframe->a0 = 0;
    8000130a:	1909b783          	ld	a5,400(s3)
    8000130e:	0607b823          	sd	zero,112(a5)
    80001312:	20800493          	li	s1,520
  for(i = 0; i < NOFILE; i++)
    80001316:	28800a13          	li	s4,648
    8000131a:	a03d                	j	80001348 <fork+0xb4>
    freeproc(np);
    8000131c:	854e                	mv	a0,s3
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	d4a080e7          	jalr	-694(ra) # 80001068 <freeproc>
    release(&np->lock);
    80001326:	854e                	mv	a0,s3
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	104080e7          	jalr	260(ra) # 8000642c <release>
    return -1;
    80001330:	5a7d                	li	s4,-1
    80001332:	a069                	j	800013bc <fork+0x128>
      np->ofile[i] = filedup(p->ofile[i]);
    80001334:	00002097          	auipc	ra,0x2
    80001338:	7ce080e7          	jalr	1998(ra) # 80003b02 <filedup>
    8000133c:	009987b3          	add	a5,s3,s1
    80001340:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001342:	04a1                	addi	s1,s1,8
    80001344:	01448763          	beq	s1,s4,80001352 <fork+0xbe>
    if(p->ofile[i])
    80001348:	009907b3          	add	a5,s2,s1
    8000134c:	6388                	ld	a0,0(a5)
    8000134e:	f17d                	bnez	a0,80001334 <fork+0xa0>
    80001350:	bfcd                	j	80001342 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001352:	28893503          	ld	a0,648(s2)
    80001356:	00002097          	auipc	ra,0x2
    8000135a:	92e080e7          	jalr	-1746(ra) # 80002c84 <idup>
    8000135e:	28a9b423          	sd	a0,648(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001362:	4641                	li	a2,16
    80001364:	29090593          	addi	a1,s2,656
    80001368:	29098513          	addi	a0,s3,656
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	f5e080e7          	jalr	-162(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001374:	1689aa03          	lw	s4,360(s3)
  release(&np->lock);
    80001378:	854e                	mv	a0,s3
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	0b2080e7          	jalr	178(ra) # 8000642c <release>
  acquire(&wait_lock);
    80001382:	00007497          	auipc	s1,0x7
    80001386:	60648493          	addi	s1,s1,1542 # 80008988 <wait_lock>
    8000138a:	8526                	mv	a0,s1
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	fec080e7          	jalr	-20(ra) # 80006378 <acquire>
  np->parent = p;
    80001394:	1729b823          	sd	s2,368(s3)
  release(&wait_lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	00005097          	auipc	ra,0x5
    8000139e:	092080e7          	jalr	146(ra) # 8000642c <release>
  acquire(&np->lock);
    800013a2:	854e                	mv	a0,s3
    800013a4:	00005097          	auipc	ra,0x5
    800013a8:	fd4080e7          	jalr	-44(ra) # 80006378 <acquire>
  np->state = RUNNABLE;
    800013ac:	478d                	li	a5,3
    800013ae:	14f9aa23          	sw	a5,340(s3)
  release(&np->lock);
    800013b2:	854e                	mv	a0,s3
    800013b4:	00005097          	auipc	ra,0x5
    800013b8:	078080e7          	jalr	120(ra) # 8000642c <release>
}
    800013bc:	8552                	mv	a0,s4
    800013be:	70a2                	ld	ra,40(sp)
    800013c0:	7402                	ld	s0,32(sp)
    800013c2:	64e2                	ld	s1,24(sp)
    800013c4:	6942                	ld	s2,16(sp)
    800013c6:	69a2                	ld	s3,8(sp)
    800013c8:	6a02                	ld	s4,0(sp)
    800013ca:	6145                	addi	sp,sp,48
    800013cc:	8082                	ret
    return -1;
    800013ce:	5a7d                	li	s4,-1
    800013d0:	b7f5                	j	800013bc <fork+0x128>

00000000800013d2 <scheduler>:
{
    800013d2:	7139                	addi	sp,sp,-64
    800013d4:	fc06                	sd	ra,56(sp)
    800013d6:	f822                	sd	s0,48(sp)
    800013d8:	f426                	sd	s1,40(sp)
    800013da:	f04a                	sd	s2,32(sp)
    800013dc:	ec4e                	sd	s3,24(sp)
    800013de:	e852                	sd	s4,16(sp)
    800013e0:	e456                	sd	s5,8(sp)
    800013e2:	e05a                	sd	s6,0(sp)
    800013e4:	0080                	addi	s0,sp,64
    800013e6:	8792                	mv	a5,tp
  int id = r_tp();
    800013e8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ea:	00779a93          	slli	s5,a5,0x7
    800013ee:	00007717          	auipc	a4,0x7
    800013f2:	58270713          	addi	a4,a4,1410 # 80008970 <pid_lock>
    800013f6:	9756                	add	a4,a4,s5
    800013f8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fc:	00007717          	auipc	a4,0x7
    80001400:	5ac70713          	addi	a4,a4,1452 # 800089a8 <cpus+0x8>
    80001404:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001406:	498d                	li	s3,3
        p->state = RUNNING;
    80001408:	4b11                	li	s6,4
        c->proc = p;
    8000140a:	079e                	slli	a5,a5,0x7
    8000140c:	00007a17          	auipc	s4,0x7
    80001410:	564a0a13          	addi	s4,s4,1380 # 80008970 <pid_lock>
    80001414:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	00012917          	auipc	s2,0x12
    8000141a:	18a90913          	addi	s2,s2,394 # 800135a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000141e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001422:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001426:	10079073          	csrw	sstatus,a5
    8000142a:	00008497          	auipc	s1,0x8
    8000142e:	97648493          	addi	s1,s1,-1674 # 80008da0 <proc>
    80001432:	a03d                	j	80001460 <scheduler+0x8e>
        p->state = RUNNING;
    80001434:	1564aa23          	sw	s6,340(s1)
        c->proc = p;
    80001438:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000143c:	19848593          	addi	a1,s1,408
    80001440:	8556                	mv	a0,s5
    80001442:	00000097          	auipc	ra,0x0
    80001446:	6c6080e7          	jalr	1734(ra) # 80001b08 <swtch>
        c->proc = 0;
    8000144a:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000144e:	8526                	mv	a0,s1
    80001450:	00005097          	auipc	ra,0x5
    80001454:	fdc080e7          	jalr	-36(ra) # 8000642c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001458:	2a048493          	addi	s1,s1,672
    8000145c:	fd2481e3          	beq	s1,s2,8000141e <scheduler+0x4c>
      acquire(&p->lock);
    80001460:	8526                	mv	a0,s1
    80001462:	00005097          	auipc	ra,0x5
    80001466:	f16080e7          	jalr	-234(ra) # 80006378 <acquire>
      if(p->state == RUNNABLE) {
    8000146a:	1544a783          	lw	a5,340(s1)
    8000146e:	ff3790e3          	bne	a5,s3,8000144e <scheduler+0x7c>
    80001472:	b7c9                	j	80001434 <scheduler+0x62>

0000000080001474 <sched>:
{
    80001474:	7179                	addi	sp,sp,-48
    80001476:	f406                	sd	ra,40(sp)
    80001478:	f022                	sd	s0,32(sp)
    8000147a:	ec26                	sd	s1,24(sp)
    8000147c:	e84a                	sd	s2,16(sp)
    8000147e:	e44e                	sd	s3,8(sp)
    80001480:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001482:	00000097          	auipc	ra,0x0
    80001486:	a30080e7          	jalr	-1488(ra) # 80000eb2 <myproc>
    8000148a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	e72080e7          	jalr	-398(ra) # 800062fe <holding>
    80001494:	cd25                	beqz	a0,8000150c <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001496:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	00007717          	auipc	a4,0x7
    800014a0:	4d470713          	addi	a4,a4,1236 # 80008970 <pid_lock>
    800014a4:	97ba                	add	a5,a5,a4
    800014a6:	0a87a703          	lw	a4,168(a5)
    800014aa:	4785                	li	a5,1
    800014ac:	06f71863          	bne	a4,a5,8000151c <sched+0xa8>
  if(p->state == RUNNING)
    800014b0:	1544a703          	lw	a4,340(s1)
    800014b4:	4791                	li	a5,4
    800014b6:	06f70b63          	beq	a4,a5,8000152c <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014be:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014c0:	efb5                	bnez	a5,8000153c <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014c2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c4:	00007917          	auipc	s2,0x7
    800014c8:	4ac90913          	addi	s2,s2,1196 # 80008970 <pid_lock>
    800014cc:	2781                	sext.w	a5,a5
    800014ce:	079e                	slli	a5,a5,0x7
    800014d0:	97ca                	add	a5,a5,s2
    800014d2:	0ac7a983          	lw	s3,172(a5)
    800014d6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d8:	2781                	sext.w	a5,a5
    800014da:	079e                	slli	a5,a5,0x7
    800014dc:	00007597          	auipc	a1,0x7
    800014e0:	4cc58593          	addi	a1,a1,1228 # 800089a8 <cpus+0x8>
    800014e4:	95be                	add	a1,a1,a5
    800014e6:	19848513          	addi	a0,s1,408
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	61e080e7          	jalr	1566(ra) # 80001b08 <swtch>
    800014f2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f4:	2781                	sext.w	a5,a5
    800014f6:	079e                	slli	a5,a5,0x7
    800014f8:	97ca                	add	a5,a5,s2
    800014fa:	0b37a623          	sw	s3,172(a5)
}
    800014fe:	70a2                	ld	ra,40(sp)
    80001500:	7402                	ld	s0,32(sp)
    80001502:	64e2                	ld	s1,24(sp)
    80001504:	6942                	ld	s2,16(sp)
    80001506:	69a2                	ld	s3,8(sp)
    80001508:	6145                	addi	sp,sp,48
    8000150a:	8082                	ret
    panic("sched p->lock");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	ccc50513          	addi	a0,a0,-820 # 800081d8 <etext+0x1d8>
    80001514:	00005097          	auipc	ra,0x5
    80001518:	8be080e7          	jalr	-1858(ra) # 80005dd2 <panic>
    panic("sched locks");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	ccc50513          	addi	a0,a0,-820 # 800081e8 <etext+0x1e8>
    80001524:	00005097          	auipc	ra,0x5
    80001528:	8ae080e7          	jalr	-1874(ra) # 80005dd2 <panic>
    panic("sched running");
    8000152c:	00007517          	auipc	a0,0x7
    80001530:	ccc50513          	addi	a0,a0,-820 # 800081f8 <etext+0x1f8>
    80001534:	00005097          	auipc	ra,0x5
    80001538:	89e080e7          	jalr	-1890(ra) # 80005dd2 <panic>
    panic("sched interruptible");
    8000153c:	00007517          	auipc	a0,0x7
    80001540:	ccc50513          	addi	a0,a0,-820 # 80008208 <etext+0x208>
    80001544:	00005097          	auipc	ra,0x5
    80001548:	88e080e7          	jalr	-1906(ra) # 80005dd2 <panic>

000000008000154c <yield>:
{
    8000154c:	1101                	addi	sp,sp,-32
    8000154e:	ec06                	sd	ra,24(sp)
    80001550:	e822                	sd	s0,16(sp)
    80001552:	e426                	sd	s1,8(sp)
    80001554:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	95c080e7          	jalr	-1700(ra) # 80000eb2 <myproc>
    8000155e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001560:	00005097          	auipc	ra,0x5
    80001564:	e18080e7          	jalr	-488(ra) # 80006378 <acquire>
  p->state = RUNNABLE;
    80001568:	478d                	li	a5,3
    8000156a:	14f4aa23          	sw	a5,340(s1)
  sched();
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	f06080e7          	jalr	-250(ra) # 80001474 <sched>
  release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	eb4080e7          	jalr	-332(ra) # 8000642c <release>
}
    80001580:	60e2                	ld	ra,24(sp)
    80001582:	6442                	ld	s0,16(sp)
    80001584:	64a2                	ld	s1,8(sp)
    80001586:	6105                	addi	sp,sp,32
    80001588:	8082                	ret

000000008000158a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000158a:	7179                	addi	sp,sp,-48
    8000158c:	f406                	sd	ra,40(sp)
    8000158e:	f022                	sd	s0,32(sp)
    80001590:	ec26                	sd	s1,24(sp)
    80001592:	e84a                	sd	s2,16(sp)
    80001594:	e44e                	sd	s3,8(sp)
    80001596:	1800                	addi	s0,sp,48
    80001598:	89aa                	mv	s3,a0
    8000159a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	916080e7          	jalr	-1770(ra) # 80000eb2 <myproc>
    800015a4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	dd2080e7          	jalr	-558(ra) # 80006378 <acquire>
  release(lk);
    800015ae:	854a                	mv	a0,s2
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	e7c080e7          	jalr	-388(ra) # 8000642c <release>

  // Go to sleep.
  p->chan = chan;
    800015b8:	1534bc23          	sd	s3,344(s1)
  p->state = SLEEPING;
    800015bc:	4789                	li	a5,2
    800015be:	14f4aa23          	sw	a5,340(s1)

  sched();
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	eb2080e7          	jalr	-334(ra) # 80001474 <sched>

  // Tidy up.
  p->chan = 0;
    800015ca:	1404bc23          	sd	zero,344(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	e5c080e7          	jalr	-420(ra) # 8000642c <release>
  acquire(lk);
    800015d8:	854a                	mv	a0,s2
    800015da:	00005097          	auipc	ra,0x5
    800015de:	d9e080e7          	jalr	-610(ra) # 80006378 <acquire>
}
    800015e2:	70a2                	ld	ra,40(sp)
    800015e4:	7402                	ld	s0,32(sp)
    800015e6:	64e2                	ld	s1,24(sp)
    800015e8:	6942                	ld	s2,16(sp)
    800015ea:	69a2                	ld	s3,8(sp)
    800015ec:	6145                	addi	sp,sp,48
    800015ee:	8082                	ret

00000000800015f0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015f0:	7139                	addi	sp,sp,-64
    800015f2:	fc06                	sd	ra,56(sp)
    800015f4:	f822                	sd	s0,48(sp)
    800015f6:	f426                	sd	s1,40(sp)
    800015f8:	f04a                	sd	s2,32(sp)
    800015fa:	ec4e                	sd	s3,24(sp)
    800015fc:	e852                	sd	s4,16(sp)
    800015fe:	e456                	sd	s5,8(sp)
    80001600:	0080                	addi	s0,sp,64
    80001602:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001604:	00007497          	auipc	s1,0x7
    80001608:	79c48493          	addi	s1,s1,1948 # 80008da0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000160c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000160e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001610:	00012917          	auipc	s2,0x12
    80001614:	f9090913          	addi	s2,s2,-112 # 800135a0 <tickslock>
    80001618:	a821                	j	80001630 <wakeup+0x40>
        p->state = RUNNABLE;
    8000161a:	1554aa23          	sw	s5,340(s1)
      }
      release(&p->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	00005097          	auipc	ra,0x5
    80001624:	e0c080e7          	jalr	-500(ra) # 8000642c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001628:	2a048493          	addi	s1,s1,672
    8000162c:	03248663          	beq	s1,s2,80001658 <wakeup+0x68>
    if(p != myproc()){
    80001630:	00000097          	auipc	ra,0x0
    80001634:	882080e7          	jalr	-1918(ra) # 80000eb2 <myproc>
    80001638:	fea488e3          	beq	s1,a0,80001628 <wakeup+0x38>
      acquire(&p->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	d3a080e7          	jalr	-710(ra) # 80006378 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001646:	1544a783          	lw	a5,340(s1)
    8000164a:	fd379ae3          	bne	a5,s3,8000161e <wakeup+0x2e>
    8000164e:	1584b783          	ld	a5,344(s1)
    80001652:	fd4796e3          	bne	a5,s4,8000161e <wakeup+0x2e>
    80001656:	b7d1                	j	8000161a <wakeup+0x2a>
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
    8000167c:	00007497          	auipc	s1,0x7
    80001680:	72448493          	addi	s1,s1,1828 # 80008da0 <proc>
      pp->parent = initproc;
    80001684:	00007a17          	auipc	s4,0x7
    80001688:	2aca0a13          	addi	s4,s4,684 # 80008930 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000168c:	00012997          	auipc	s3,0x12
    80001690:	f1498993          	addi	s3,s3,-236 # 800135a0 <tickslock>
    80001694:	a029                	j	8000169e <reparent+0x34>
    80001696:	2a048493          	addi	s1,s1,672
    8000169a:	01348f63          	beq	s1,s3,800016b8 <reparent+0x4e>
    if(pp->parent == p){
    8000169e:	1704b783          	ld	a5,368(s1)
    800016a2:	ff279ae3          	bne	a5,s2,80001696 <reparent+0x2c>
      pp->parent = initproc;
    800016a6:	000a3503          	ld	a0,0(s4)
    800016aa:	16a4b823          	sd	a0,368(s1)
      wakeup(initproc);
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	f42080e7          	jalr	-190(ra) # 800015f0 <wakeup>
    800016b6:	b7c5                	j	80001696 <reparent+0x2c>
}
    800016b8:	70a2                	ld	ra,40(sp)
    800016ba:	7402                	ld	s0,32(sp)
    800016bc:	64e2                	ld	s1,24(sp)
    800016be:	6942                	ld	s2,16(sp)
    800016c0:	69a2                	ld	s3,8(sp)
    800016c2:	6a02                	ld	s4,0(sp)
    800016c4:	6145                	addi	sp,sp,48
    800016c6:	8082                	ret

00000000800016c8 <exit>:
{
    800016c8:	7179                	addi	sp,sp,-48
    800016ca:	f406                	sd	ra,40(sp)
    800016cc:	f022                	sd	s0,32(sp)
    800016ce:	ec26                	sd	s1,24(sp)
    800016d0:	e84a                	sd	s2,16(sp)
    800016d2:	e44e                	sd	s3,8(sp)
    800016d4:	e052                	sd	s4,0(sp)
    800016d6:	1800                	addi	s0,sp,48
    800016d8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	7d8080e7          	jalr	2008(ra) # 80000eb2 <myproc>
    800016e2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016e4:	00007797          	auipc	a5,0x7
    800016e8:	24c7b783          	ld	a5,588(a5) # 80008930 <initproc>
    800016ec:	20850493          	addi	s1,a0,520
    800016f0:	28850913          	addi	s2,a0,648
    800016f4:	02a79363          	bne	a5,a0,8000171a <exit+0x52>
    panic("init exiting");
    800016f8:	00007517          	auipc	a0,0x7
    800016fc:	b2850513          	addi	a0,a0,-1240 # 80008220 <etext+0x220>
    80001700:	00004097          	auipc	ra,0x4
    80001704:	6d2080e7          	jalr	1746(ra) # 80005dd2 <panic>
      fileclose(f);
    80001708:	00002097          	auipc	ra,0x2
    8000170c:	44c080e7          	jalr	1100(ra) # 80003b54 <fileclose>
      p->ofile[fd] = 0;
    80001710:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001714:	04a1                	addi	s1,s1,8
    80001716:	01248563          	beq	s1,s2,80001720 <exit+0x58>
    if(p->ofile[fd]){
    8000171a:	6088                	ld	a0,0(s1)
    8000171c:	f575                	bnez	a0,80001708 <exit+0x40>
    8000171e:	bfdd                	j	80001714 <exit+0x4c>
  begin_op();
    80001720:	00002097          	auipc	ra,0x2
    80001724:	f64080e7          	jalr	-156(ra) # 80003684 <begin_op>
  iput(p->cwd);
    80001728:	2889b503          	ld	a0,648(s3)
    8000172c:	00001097          	auipc	ra,0x1
    80001730:	750080e7          	jalr	1872(ra) # 80002e7c <iput>
  end_op();
    80001734:	00002097          	auipc	ra,0x2
    80001738:	fd0080e7          	jalr	-48(ra) # 80003704 <end_op>
  p->cwd = 0;
    8000173c:	2809b423          	sd	zero,648(s3)
  acquire(&wait_lock);
    80001740:	00007497          	auipc	s1,0x7
    80001744:	24848493          	addi	s1,s1,584 # 80008988 <wait_lock>
    80001748:	8526                	mv	a0,s1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	c2e080e7          	jalr	-978(ra) # 80006378 <acquire>
  reparent(p);
    80001752:	854e                	mv	a0,s3
    80001754:	00000097          	auipc	ra,0x0
    80001758:	f16080e7          	jalr	-234(ra) # 8000166a <reparent>
  wakeup(p->parent);
    8000175c:	1709b503          	ld	a0,368(s3)
    80001760:	00000097          	auipc	ra,0x0
    80001764:	e90080e7          	jalr	-368(ra) # 800015f0 <wakeup>
  acquire(&p->lock);
    80001768:	854e                	mv	a0,s3
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	c0e080e7          	jalr	-1010(ra) # 80006378 <acquire>
  p->xstate = status;
    80001772:	1749a223          	sw	s4,356(s3)
  p->state = ZOMBIE;
    80001776:	4795                	li	a5,5
    80001778:	14f9aa23          	sw	a5,340(s3)
  release(&wait_lock);
    8000177c:	8526                	mv	a0,s1
    8000177e:	00005097          	auipc	ra,0x5
    80001782:	cae080e7          	jalr	-850(ra) # 8000642c <release>
  sched();
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	cee080e7          	jalr	-786(ra) # 80001474 <sched>
  panic("zombie exit");
    8000178e:	00007517          	auipc	a0,0x7
    80001792:	aa250513          	addi	a0,a0,-1374 # 80008230 <etext+0x230>
    80001796:	00004097          	auipc	ra,0x4
    8000179a:	63c080e7          	jalr	1596(ra) # 80005dd2 <panic>

000000008000179e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000179e:	7179                	addi	sp,sp,-48
    800017a0:	f406                	sd	ra,40(sp)
    800017a2:	f022                	sd	s0,32(sp)
    800017a4:	ec26                	sd	s1,24(sp)
    800017a6:	e84a                	sd	s2,16(sp)
    800017a8:	e44e                	sd	s3,8(sp)
    800017aa:	1800                	addi	s0,sp,48
    800017ac:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017ae:	00007497          	auipc	s1,0x7
    800017b2:	5f248493          	addi	s1,s1,1522 # 80008da0 <proc>
    800017b6:	00012997          	auipc	s3,0x12
    800017ba:	dea98993          	addi	s3,s3,-534 # 800135a0 <tickslock>
    acquire(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	bb8080e7          	jalr	-1096(ra) # 80006378 <acquire>
    if(p->pid == pid){
    800017c8:	1684a783          	lw	a5,360(s1)
    800017cc:	01278d63          	beq	a5,s2,800017e6 <kill+0x48>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017d0:	8526                	mv	a0,s1
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	c5a080e7          	jalr	-934(ra) # 8000642c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017da:	2a048493          	addi	s1,s1,672
    800017de:	ff3490e3          	bne	s1,s3,800017be <kill+0x20>
  }
  return -1;
    800017e2:	557d                	li	a0,-1
    800017e4:	a839                	j	80001802 <kill+0x64>
      p->killed = 1;
    800017e6:	4785                	li	a5,1
    800017e8:	16f4a023          	sw	a5,352(s1)
      if(p->state == SLEEPING){
    800017ec:	1544a703          	lw	a4,340(s1)
    800017f0:	4789                	li	a5,2
    800017f2:	00f70f63          	beq	a4,a5,80001810 <kill+0x72>
      release(&p->lock);
    800017f6:	8526                	mv	a0,s1
    800017f8:	00005097          	auipc	ra,0x5
    800017fc:	c34080e7          	jalr	-972(ra) # 8000642c <release>
      return 0;
    80001800:	4501                	li	a0,0
}
    80001802:	70a2                	ld	ra,40(sp)
    80001804:	7402                	ld	s0,32(sp)
    80001806:	64e2                	ld	s1,24(sp)
    80001808:	6942                	ld	s2,16(sp)
    8000180a:	69a2                	ld	s3,8(sp)
    8000180c:	6145                	addi	sp,sp,48
    8000180e:	8082                	ret
        p->state = RUNNABLE;
    80001810:	478d                	li	a5,3
    80001812:	14f4aa23          	sw	a5,340(s1)
    80001816:	b7c5                	j	800017f6 <kill+0x58>

0000000080001818 <setkilled>:

void
setkilled(struct proc *p)
{
    80001818:	1101                	addi	sp,sp,-32
    8000181a:	ec06                	sd	ra,24(sp)
    8000181c:	e822                	sd	s0,16(sp)
    8000181e:	e426                	sd	s1,8(sp)
    80001820:	1000                	addi	s0,sp,32
    80001822:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001824:	00005097          	auipc	ra,0x5
    80001828:	b54080e7          	jalr	-1196(ra) # 80006378 <acquire>
  p->killed = 1;
    8000182c:	4785                	li	a5,1
    8000182e:	16f4a023          	sw	a5,352(s1)
  release(&p->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	bf8080e7          	jalr	-1032(ra) # 8000642c <release>
}
    8000183c:	60e2                	ld	ra,24(sp)
    8000183e:	6442                	ld	s0,16(sp)
    80001840:	64a2                	ld	s1,8(sp)
    80001842:	6105                	addi	sp,sp,32
    80001844:	8082                	ret

0000000080001846 <killed>:

int
killed(struct proc *p)
{
    80001846:	1101                	addi	sp,sp,-32
    80001848:	ec06                	sd	ra,24(sp)
    8000184a:	e822                	sd	s0,16(sp)
    8000184c:	e426                	sd	s1,8(sp)
    8000184e:	e04a                	sd	s2,0(sp)
    80001850:	1000                	addi	s0,sp,32
    80001852:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001854:	00005097          	auipc	ra,0x5
    80001858:	b24080e7          	jalr	-1244(ra) # 80006378 <acquire>
  k = p->killed;
    8000185c:	1604a903          	lw	s2,352(s1)
  release(&p->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	bca080e7          	jalr	-1078(ra) # 8000642c <release>
  return k;
}
    8000186a:	854a                	mv	a0,s2
    8000186c:	60e2                	ld	ra,24(sp)
    8000186e:	6442                	ld	s0,16(sp)
    80001870:	64a2                	ld	s1,8(sp)
    80001872:	6902                	ld	s2,0(sp)
    80001874:	6105                	addi	sp,sp,32
    80001876:	8082                	ret

0000000080001878 <wait>:
{
    80001878:	715d                	addi	sp,sp,-80
    8000187a:	e486                	sd	ra,72(sp)
    8000187c:	e0a2                	sd	s0,64(sp)
    8000187e:	fc26                	sd	s1,56(sp)
    80001880:	f84a                	sd	s2,48(sp)
    80001882:	f44e                	sd	s3,40(sp)
    80001884:	f052                	sd	s4,32(sp)
    80001886:	ec56                	sd	s5,24(sp)
    80001888:	e85a                	sd	s6,16(sp)
    8000188a:	e45e                	sd	s7,8(sp)
    8000188c:	e062                	sd	s8,0(sp)
    8000188e:	0880                	addi	s0,sp,80
    80001890:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	620080e7          	jalr	1568(ra) # 80000eb2 <myproc>
    8000189a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000189c:	00007517          	auipc	a0,0x7
    800018a0:	0ec50513          	addi	a0,a0,236 # 80008988 <wait_lock>
    800018a4:	00005097          	auipc	ra,0x5
    800018a8:	ad4080e7          	jalr	-1324(ra) # 80006378 <acquire>
    havekids = 0;
    800018ac:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018ae:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b0:	00012997          	auipc	s3,0x12
    800018b4:	cf098993          	addi	s3,s3,-784 # 800135a0 <tickslock>
        havekids = 1;
    800018b8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018ba:	00007c17          	auipc	s8,0x7
    800018be:	0cec0c13          	addi	s8,s8,206 # 80008988 <wait_lock>
    havekids = 0;
    800018c2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c4:	00007497          	auipc	s1,0x7
    800018c8:	4dc48493          	addi	s1,s1,1244 # 80008da0 <proc>
    800018cc:	a0bd                	j	8000193a <wait+0xc2>
          pid = pp->pid;
    800018ce:	1684a983          	lw	s3,360(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018d2:	000b0e63          	beqz	s6,800018ee <wait+0x76>
    800018d6:	4691                	li	a3,4
    800018d8:	16448613          	addi	a2,s1,356
    800018dc:	85da                	mv	a1,s6
    800018de:	18893503          	ld	a0,392(s2)
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	258080e7          	jalr	600(ra) # 80000b3a <copyout>
    800018ea:	02054563          	bltz	a0,80001914 <wait+0x9c>
          freeproc(pp);
    800018ee:	8526                	mv	a0,s1
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	778080e7          	jalr	1912(ra) # 80001068 <freeproc>
          release(&pp->lock);
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	b32080e7          	jalr	-1230(ra) # 8000642c <release>
          release(&wait_lock);
    80001902:	00007517          	auipc	a0,0x7
    80001906:	08650513          	addi	a0,a0,134 # 80008988 <wait_lock>
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	b22080e7          	jalr	-1246(ra) # 8000642c <release>
          return pid;
    80001912:	a885                	j	80001982 <wait+0x10a>
            release(&pp->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	b16080e7          	jalr	-1258(ra) # 8000642c <release>
            release(&wait_lock);
    8000191e:	00007517          	auipc	a0,0x7
    80001922:	06a50513          	addi	a0,a0,106 # 80008988 <wait_lock>
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	b06080e7          	jalr	-1274(ra) # 8000642c <release>
            return -1;
    8000192e:	59fd                	li	s3,-1
    80001930:	a889                	j	80001982 <wait+0x10a>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001932:	2a048493          	addi	s1,s1,672
    80001936:	03348663          	beq	s1,s3,80001962 <wait+0xea>
      if(pp->parent == p){
    8000193a:	1704b783          	ld	a5,368(s1)
    8000193e:	ff279ae3          	bne	a5,s2,80001932 <wait+0xba>
        acquire(&pp->lock);
    80001942:	8526                	mv	a0,s1
    80001944:	00005097          	auipc	ra,0x5
    80001948:	a34080e7          	jalr	-1484(ra) # 80006378 <acquire>
        if(pp->state == ZOMBIE){
    8000194c:	1544a783          	lw	a5,340(s1)
    80001950:	f7478fe3          	beq	a5,s4,800018ce <wait+0x56>
        release(&pp->lock);
    80001954:	8526                	mv	a0,s1
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	ad6080e7          	jalr	-1322(ra) # 8000642c <release>
        havekids = 1;
    8000195e:	8756                	mv	a4,s5
    80001960:	bfc9                	j	80001932 <wait+0xba>
    if(!havekids || killed(p)){
    80001962:	c719                	beqz	a4,80001970 <wait+0xf8>
    80001964:	854a                	mv	a0,s2
    80001966:	00000097          	auipc	ra,0x0
    8000196a:	ee0080e7          	jalr	-288(ra) # 80001846 <killed>
    8000196e:	c51d                	beqz	a0,8000199c <wait+0x124>
      release(&wait_lock);
    80001970:	00007517          	auipc	a0,0x7
    80001974:	01850513          	addi	a0,a0,24 # 80008988 <wait_lock>
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	ab4080e7          	jalr	-1356(ra) # 8000642c <release>
      return -1;
    80001980:	59fd                	li	s3,-1
}
    80001982:	854e                	mv	a0,s3
    80001984:	60a6                	ld	ra,72(sp)
    80001986:	6406                	ld	s0,64(sp)
    80001988:	74e2                	ld	s1,56(sp)
    8000198a:	7942                	ld	s2,48(sp)
    8000198c:	79a2                	ld	s3,40(sp)
    8000198e:	7a02                	ld	s4,32(sp)
    80001990:	6ae2                	ld	s5,24(sp)
    80001992:	6b42                	ld	s6,16(sp)
    80001994:	6ba2                	ld	s7,8(sp)
    80001996:	6c02                	ld	s8,0(sp)
    80001998:	6161                	addi	sp,sp,80
    8000199a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000199c:	85e2                	mv	a1,s8
    8000199e:	854a                	mv	a0,s2
    800019a0:	00000097          	auipc	ra,0x0
    800019a4:	bea080e7          	jalr	-1046(ra) # 8000158a <sleep>
    havekids = 0;
    800019a8:	bf29                	j	800018c2 <wait+0x4a>

00000000800019aa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019aa:	7179                	addi	sp,sp,-48
    800019ac:	f406                	sd	ra,40(sp)
    800019ae:	f022                	sd	s0,32(sp)
    800019b0:	ec26                	sd	s1,24(sp)
    800019b2:	e84a                	sd	s2,16(sp)
    800019b4:	e44e                	sd	s3,8(sp)
    800019b6:	e052                	sd	s4,0(sp)
    800019b8:	1800                	addi	s0,sp,48
    800019ba:	84aa                	mv	s1,a0
    800019bc:	892e                	mv	s2,a1
    800019be:	89b2                	mv	s3,a2
    800019c0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	4f0080e7          	jalr	1264(ra) # 80000eb2 <myproc>
  if(user_dst){
    800019ca:	c095                	beqz	s1,800019ee <either_copyout+0x44>
    return copyout(p->pagetable, dst, src, len);
    800019cc:	86d2                	mv	a3,s4
    800019ce:	864e                	mv	a2,s3
    800019d0:	85ca                	mv	a1,s2
    800019d2:	18853503          	ld	a0,392(a0)
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	164080e7          	jalr	356(ra) # 80000b3a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019de:	70a2                	ld	ra,40(sp)
    800019e0:	7402                	ld	s0,32(sp)
    800019e2:	64e2                	ld	s1,24(sp)
    800019e4:	6942                	ld	s2,16(sp)
    800019e6:	69a2                	ld	s3,8(sp)
    800019e8:	6a02                	ld	s4,0(sp)
    800019ea:	6145                	addi	sp,sp,48
    800019ec:	8082                	ret
    memmove((char *)dst, src, len);
    800019ee:	000a061b          	sext.w	a2,s4
    800019f2:	85ce                	mv	a1,s3
    800019f4:	854a                	mv	a0,s2
    800019f6:	ffffe097          	auipc	ra,0xffffe
    800019fa:	7e2080e7          	jalr	2018(ra) # 800001d8 <memmove>
    return 0;
    800019fe:	8526                	mv	a0,s1
    80001a00:	bff9                	j	800019de <either_copyout+0x34>

0000000080001a02 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a02:	7179                	addi	sp,sp,-48
    80001a04:	f406                	sd	ra,40(sp)
    80001a06:	f022                	sd	s0,32(sp)
    80001a08:	ec26                	sd	s1,24(sp)
    80001a0a:	e84a                	sd	s2,16(sp)
    80001a0c:	e44e                	sd	s3,8(sp)
    80001a0e:	e052                	sd	s4,0(sp)
    80001a10:	1800                	addi	s0,sp,48
    80001a12:	892a                	mv	s2,a0
    80001a14:	84ae                	mv	s1,a1
    80001a16:	89b2                	mv	s3,a2
    80001a18:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	498080e7          	jalr	1176(ra) # 80000eb2 <myproc>
  if(user_src){
    80001a22:	c095                	beqz	s1,80001a46 <either_copyin+0x44>
    return copyin(p->pagetable, dst, src, len);
    80001a24:	86d2                	mv	a3,s4
    80001a26:	864e                	mv	a2,s3
    80001a28:	85ca                	mv	a1,s2
    80001a2a:	18853503          	ld	a0,392(a0)
    80001a2e:	fffff097          	auipc	ra,0xfffff
    80001a32:	1cc080e7          	jalr	460(ra) # 80000bfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a36:	70a2                	ld	ra,40(sp)
    80001a38:	7402                	ld	s0,32(sp)
    80001a3a:	64e2                	ld	s1,24(sp)
    80001a3c:	6942                	ld	s2,16(sp)
    80001a3e:	69a2                	ld	s3,8(sp)
    80001a40:	6a02                	ld	s4,0(sp)
    80001a42:	6145                	addi	sp,sp,48
    80001a44:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a46:	000a061b          	sext.w	a2,s4
    80001a4a:	85ce                	mv	a1,s3
    80001a4c:	854a                	mv	a0,s2
    80001a4e:	ffffe097          	auipc	ra,0xffffe
    80001a52:	78a080e7          	jalr	1930(ra) # 800001d8 <memmove>
    return 0;
    80001a56:	8526                	mv	a0,s1
    80001a58:	bff9                	j	80001a36 <either_copyin+0x34>

0000000080001a5a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a5a:	715d                	addi	sp,sp,-80
    80001a5c:	e486                	sd	ra,72(sp)
    80001a5e:	e0a2                	sd	s0,64(sp)
    80001a60:	fc26                	sd	s1,56(sp)
    80001a62:	f84a                	sd	s2,48(sp)
    80001a64:	f44e                	sd	s3,40(sp)
    80001a66:	f052                	sd	s4,32(sp)
    80001a68:	ec56                	sd	s5,24(sp)
    80001a6a:	e85a                	sd	s6,16(sp)
    80001a6c:	e45e                	sd	s7,8(sp)
    80001a6e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a70:	00006517          	auipc	a0,0x6
    80001a74:	5d850513          	addi	a0,a0,1496 # 80008048 <etext+0x48>
    80001a78:	00004097          	auipc	ra,0x4
    80001a7c:	3a4080e7          	jalr	932(ra) # 80005e1c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a80:	00007497          	auipc	s1,0x7
    80001a84:	5b048493          	addi	s1,s1,1456 # 80009030 <proc+0x290>
    80001a88:	00012917          	auipc	s2,0x12
    80001a8c:	da890913          	addi	s2,s2,-600 # 80013830 <bcache+0x278>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a90:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a92:	00006997          	auipc	s3,0x6
    80001a96:	7ae98993          	addi	s3,s3,1966 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a9a:	00006a97          	auipc	s5,0x6
    80001a9e:	7aea8a93          	addi	s5,s5,1966 # 80008248 <etext+0x248>
    printf("\n");
    80001aa2:	00006a17          	auipc	s4,0x6
    80001aa6:	5a6a0a13          	addi	s4,s4,1446 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aaa:	00006b97          	auipc	s7,0x6
    80001aae:	7deb8b93          	addi	s7,s7,2014 # 80008288 <states.1732>
    80001ab2:	a00d                	j	80001ad4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ab4:	ed86a583          	lw	a1,-296(a3)
    80001ab8:	8556                	mv	a0,s5
    80001aba:	00004097          	auipc	ra,0x4
    80001abe:	362080e7          	jalr	866(ra) # 80005e1c <printf>
    printf("\n");
    80001ac2:	8552                	mv	a0,s4
    80001ac4:	00004097          	auipc	ra,0x4
    80001ac8:	358080e7          	jalr	856(ra) # 80005e1c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001acc:	2a048493          	addi	s1,s1,672
    80001ad0:	03248163          	beq	s1,s2,80001af2 <procdump+0x98>
    if(p->state == UNUSED)
    80001ad4:	86a6                	mv	a3,s1
    80001ad6:	ec44a783          	lw	a5,-316(s1)
    80001ada:	dbed                	beqz	a5,80001acc <procdump+0x72>
      state = "???";
    80001adc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ade:	fcfb6be3          	bltu	s6,a5,80001ab4 <procdump+0x5a>
    80001ae2:	1782                	slli	a5,a5,0x20
    80001ae4:	9381                	srli	a5,a5,0x20
    80001ae6:	078e                	slli	a5,a5,0x3
    80001ae8:	97de                	add	a5,a5,s7
    80001aea:	6390                	ld	a2,0(a5)
    80001aec:	f661                	bnez	a2,80001ab4 <procdump+0x5a>
      state = "???";
    80001aee:	864e                	mv	a2,s3
    80001af0:	b7d1                	j	80001ab4 <procdump+0x5a>
  }
}
    80001af2:	60a6                	ld	ra,72(sp)
    80001af4:	6406                	ld	s0,64(sp)
    80001af6:	74e2                	ld	s1,56(sp)
    80001af8:	7942                	ld	s2,48(sp)
    80001afa:	79a2                	ld	s3,40(sp)
    80001afc:	7a02                	ld	s4,32(sp)
    80001afe:	6ae2                	ld	s5,24(sp)
    80001b00:	6b42                	ld	s6,16(sp)
    80001b02:	6ba2                	ld	s7,8(sp)
    80001b04:	6161                	addi	sp,sp,80
    80001b06:	8082                	ret

0000000080001b08 <swtch>:
    80001b08:	00153023          	sd	ra,0(a0)
    80001b0c:	00253423          	sd	sp,8(a0)
    80001b10:	e900                	sd	s0,16(a0)
    80001b12:	ed04                	sd	s1,24(a0)
    80001b14:	03253023          	sd	s2,32(a0)
    80001b18:	03353423          	sd	s3,40(a0)
    80001b1c:	03453823          	sd	s4,48(a0)
    80001b20:	03553c23          	sd	s5,56(a0)
    80001b24:	05653023          	sd	s6,64(a0)
    80001b28:	05753423          	sd	s7,72(a0)
    80001b2c:	05853823          	sd	s8,80(a0)
    80001b30:	05953c23          	sd	s9,88(a0)
    80001b34:	07a53023          	sd	s10,96(a0)
    80001b38:	07b53423          	sd	s11,104(a0)
    80001b3c:	0005b083          	ld	ra,0(a1)
    80001b40:	0085b103          	ld	sp,8(a1)
    80001b44:	6980                	ld	s0,16(a1)
    80001b46:	6d84                	ld	s1,24(a1)
    80001b48:	0205b903          	ld	s2,32(a1)
    80001b4c:	0285b983          	ld	s3,40(a1)
    80001b50:	0305ba03          	ld	s4,48(a1)
    80001b54:	0385ba83          	ld	s5,56(a1)
    80001b58:	0405bb03          	ld	s6,64(a1)
    80001b5c:	0485bb83          	ld	s7,72(a1)
    80001b60:	0505bc03          	ld	s8,80(a1)
    80001b64:	0585bc83          	ld	s9,88(a1)
    80001b68:	0605bd03          	ld	s10,96(a1)
    80001b6c:	0685bd83          	ld	s11,104(a1)
    80001b70:	8082                	ret

0000000080001b72 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b72:	1141                	addi	sp,sp,-16
    80001b74:	e406                	sd	ra,8(sp)
    80001b76:	e022                	sd	s0,0(sp)
    80001b78:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b7a:	00006597          	auipc	a1,0x6
    80001b7e:	73e58593          	addi	a1,a1,1854 # 800082b8 <states.1732+0x30>
    80001b82:	00012517          	auipc	a0,0x12
    80001b86:	a1e50513          	addi	a0,a0,-1506 # 800135a0 <tickslock>
    80001b8a:	00004097          	auipc	ra,0x4
    80001b8e:	75e080e7          	jalr	1886(ra) # 800062e8 <initlock>
}
    80001b92:	60a2                	ld	ra,8(sp)
    80001b94:	6402                	ld	s0,0(sp)
    80001b96:	0141                	addi	sp,sp,16
    80001b98:	8082                	ret

0000000080001b9a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b9a:	1141                	addi	sp,sp,-16
    80001b9c:	e422                	sd	s0,8(sp)
    80001b9e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ba0:	00003797          	auipc	a5,0x3
    80001ba4:	60078793          	addi	a5,a5,1536 # 800051a0 <kernelvec>
    80001ba8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bac:	6422                	ld	s0,8(sp)
    80001bae:	0141                	addi	sp,sp,16
    80001bb0:	8082                	ret

0000000080001bb2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bb2:	1141                	addi	sp,sp,-16
    80001bb4:	e406                	sd	ra,8(sp)
    80001bb6:	e022                	sd	s0,0(sp)
    80001bb8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	2f8080e7          	jalr	760(ra) # 80000eb2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bcc:	00005617          	auipc	a2,0x5
    80001bd0:	43460613          	addi	a2,a2,1076 # 80007000 <_trampoline>
    80001bd4:	00005697          	auipc	a3,0x5
    80001bd8:	42c68693          	addi	a3,a3,1068 # 80007000 <_trampoline>
    80001bdc:	8e91                	sub	a3,a3,a2
    80001bde:	040007b7          	lui	a5,0x4000
    80001be2:	17fd                	addi	a5,a5,-1
    80001be4:	07b2                	slli	a5,a5,0xc
    80001be6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001be8:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bec:	19053703          	ld	a4,400(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bf0:	180026f3          	csrr	a3,satp
    80001bf4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bf6:	19053703          	ld	a4,400(a0)
    80001bfa:	17853683          	ld	a3,376(a0)
    80001bfe:	6585                	lui	a1,0x1
    80001c00:	96ae                	add	a3,a3,a1
    80001c02:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c04:	19053703          	ld	a4,400(a0)
    80001c08:	00000697          	auipc	a3,0x0
    80001c0c:	13668693          	addi	a3,a3,310 # 80001d3e <usertrap>
    80001c10:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c12:	19053703          	ld	a4,400(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c16:	8692                	mv	a3,tp
    80001c18:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c1a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c1e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c22:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c26:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c2a:	19053703          	ld	a4,400(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c2e:	6f18                	ld	a4,24(a4)
    80001c30:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c34:	18853503          	ld	a0,392(a0)
    80001c38:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c3a:	00005717          	auipc	a4,0x5
    80001c3e:	46270713          	addi	a4,a4,1122 # 8000709c <userret>
    80001c42:	8f11                	sub	a4,a4,a2
    80001c44:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c46:	577d                	li	a4,-1
    80001c48:	177e                	slli	a4,a4,0x3f
    80001c4a:	8d59                	or	a0,a0,a4
    80001c4c:	9782                	jalr	a5
}
    80001c4e:	60a2                	ld	ra,8(sp)
    80001c50:	6402                	ld	s0,0(sp)
    80001c52:	0141                	addi	sp,sp,16
    80001c54:	8082                	ret

0000000080001c56 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c60:	00012497          	auipc	s1,0x12
    80001c64:	94048493          	addi	s1,s1,-1728 # 800135a0 <tickslock>
    80001c68:	8526                	mv	a0,s1
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	70e080e7          	jalr	1806(ra) # 80006378 <acquire>
  ticks++;
    80001c72:	00007517          	auipc	a0,0x7
    80001c76:	cc650513          	addi	a0,a0,-826 # 80008938 <ticks>
    80001c7a:	411c                	lw	a5,0(a0)
    80001c7c:	2785                	addiw	a5,a5,1
    80001c7e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	970080e7          	jalr	-1680(ra) # 800015f0 <wakeup>
  release(&tickslock);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	7a2080e7          	jalr	1954(ra) # 8000642c <release>
}
    80001c92:	60e2                	ld	ra,24(sp)
    80001c94:	6442                	ld	s0,16(sp)
    80001c96:	64a2                	ld	s1,8(sp)
    80001c98:	6105                	addi	sp,sp,32
    80001c9a:	8082                	ret

0000000080001c9c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c9c:	1101                	addi	sp,sp,-32
    80001c9e:	ec06                	sd	ra,24(sp)
    80001ca0:	e822                	sd	s0,16(sp)
    80001ca2:	e426                	sd	s1,8(sp)
    80001ca4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001caa:	00074d63          	bltz	a4,80001cc4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cae:	57fd                	li	a5,-1
    80001cb0:	17fe                	slli	a5,a5,0x3f
    80001cb2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cb4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cb6:	06f70363          	beq	a4,a5,80001d1c <devintr+0x80>
  }
}
    80001cba:	60e2                	ld	ra,24(sp)
    80001cbc:	6442                	ld	s0,16(sp)
    80001cbe:	64a2                	ld	s1,8(sp)
    80001cc0:	6105                	addi	sp,sp,32
    80001cc2:	8082                	ret
     (scause & 0xff) == 9){
    80001cc4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cc8:	46a5                	li	a3,9
    80001cca:	fed792e3          	bne	a5,a3,80001cae <devintr+0x12>
    int irq = plic_claim();
    80001cce:	00003097          	auipc	ra,0x3
    80001cd2:	5da080e7          	jalr	1498(ra) # 800052a8 <plic_claim>
    80001cd6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cd8:	47a9                	li	a5,10
    80001cda:	02f50763          	beq	a0,a5,80001d08 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cde:	4785                	li	a5,1
    80001ce0:	02f50963          	beq	a0,a5,80001d12 <devintr+0x76>
    return 1;
    80001ce4:	4505                	li	a0,1
    } else if(irq){
    80001ce6:	d8f1                	beqz	s1,80001cba <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ce8:	85a6                	mv	a1,s1
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5d650513          	addi	a0,a0,1494 # 800082c0 <states.1732+0x38>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	12a080e7          	jalr	298(ra) # 80005e1c <printf>
      plic_complete(irq);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	00003097          	auipc	ra,0x3
    80001d00:	5d0080e7          	jalr	1488(ra) # 800052cc <plic_complete>
    return 1;
    80001d04:	4505                	li	a0,1
    80001d06:	bf55                	j	80001cba <devintr+0x1e>
      uartintr();
    80001d08:	00004097          	auipc	ra,0x4
    80001d0c:	590080e7          	jalr	1424(ra) # 80006298 <uartintr>
    80001d10:	b7ed                	j	80001cfa <devintr+0x5e>
      virtio_disk_intr();
    80001d12:	00004097          	auipc	ra,0x4
    80001d16:	ae4080e7          	jalr	-1308(ra) # 800057f6 <virtio_disk_intr>
    80001d1a:	b7c5                	j	80001cfa <devintr+0x5e>
    if(cpuid() == 0){
    80001d1c:	fffff097          	auipc	ra,0xfffff
    80001d20:	16a080e7          	jalr	362(ra) # 80000e86 <cpuid>
    80001d24:	c901                	beqz	a0,80001d34 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d26:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d2a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d2c:	14479073          	csrw	sip,a5
    return 2;
    80001d30:	4509                	li	a0,2
    80001d32:	b761                	j	80001cba <devintr+0x1e>
      clockintr();
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	f22080e7          	jalr	-222(ra) # 80001c56 <clockintr>
    80001d3c:	b7ed                	j	80001d26 <devintr+0x8a>

0000000080001d3e <usertrap>:
{
    80001d3e:	1101                	addi	sp,sp,-32
    80001d40:	ec06                	sd	ra,24(sp)
    80001d42:	e822                	sd	s0,16(sp)
    80001d44:	e426                	sd	s1,8(sp)
    80001d46:	e04a                	sd	s2,0(sp)
    80001d48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d4e:	1007f793          	andi	a5,a5,256
    80001d52:	e3b9                	bnez	a5,80001d98 <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d54:	00003797          	auipc	a5,0x3
    80001d58:	44c78793          	addi	a5,a5,1100 # 800051a0 <kernelvec>
    80001d5c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	152080e7          	jalr	338(ra) # 80000eb2 <myproc>
    80001d68:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d6a:	19053783          	ld	a5,400(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6e:	14102773          	csrr	a4,sepc
    80001d72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d78:	47a1                	li	a5,8
    80001d7a:	02f70763          	beq	a4,a5,80001da8 <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	f1e080e7          	jalr	-226(ra) # 80001c9c <devintr>
    80001d86:	892a                	mv	s2,a0
    80001d88:	c159                	beqz	a0,80001e0e <usertrap+0xd0>
  if(killed(p))
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	aba080e7          	jalr	-1350(ra) # 80001846 <killed>
    80001d94:	c931                	beqz	a0,80001de8 <usertrap+0xaa>
    80001d96:	a0a1                	j	80001dde <usertrap+0xa0>
    panic("usertrap: not from user mode");
    80001d98:	00006517          	auipc	a0,0x6
    80001d9c:	54850513          	addi	a0,a0,1352 # 800082e0 <states.1732+0x58>
    80001da0:	00004097          	auipc	ra,0x4
    80001da4:	032080e7          	jalr	50(ra) # 80005dd2 <panic>
    if(killed(p))
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	a9e080e7          	jalr	-1378(ra) # 80001846 <killed>
    80001db0:	e929                	bnez	a0,80001e02 <usertrap+0xc4>
    p->trapframe->epc += 4;
    80001db2:	1904b703          	ld	a4,400(s1)
    80001db6:	6f1c                	ld	a5,24(a4)
    80001db8:	0791                	addi	a5,a5,4
    80001dba:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dc0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc4:	10079073          	csrw	sstatus,a5
    syscall();
    80001dc8:	00000097          	auipc	ra,0x0
    80001dcc:	346080e7          	jalr	838(ra) # 8000210e <syscall>
  if(killed(p))
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	a74080e7          	jalr	-1420(ra) # 80001846 <killed>
    80001dda:	c911                	beqz	a0,80001dee <usertrap+0xb0>
    80001ddc:	4901                	li	s2,0
    exit(-1);
    80001dde:	557d                	li	a0,-1
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	8e8080e7          	jalr	-1816(ra) # 800016c8 <exit>
  if(which_dev == 2)
    80001de8:	4789                	li	a5,2
    80001dea:	06f90063          	beq	s2,a5,80001e4a <usertrap+0x10c>
  usertrapret();
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	dc4080e7          	jalr	-572(ra) # 80001bb2 <usertrapret>
}
    80001df6:	60e2                	ld	ra,24(sp)
    80001df8:	6442                	ld	s0,16(sp)
    80001dfa:	64a2                	ld	s1,8(sp)
    80001dfc:	6902                	ld	s2,0(sp)
    80001dfe:	6105                	addi	sp,sp,32
    80001e00:	8082                	ret
      exit(-1);
    80001e02:	557d                	li	a0,-1
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	8c4080e7          	jalr	-1852(ra) # 800016c8 <exit>
    80001e0c:	b75d                	j	80001db2 <usertrap+0x74>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e12:	1684a603          	lw	a2,360(s1)
    80001e16:	00006517          	auipc	a0,0x6
    80001e1a:	4ea50513          	addi	a0,a0,1258 # 80008300 <states.1732+0x78>
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	ffe080e7          	jalr	-2(ra) # 80005e1c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e26:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e2a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	50250513          	addi	a0,a0,1282 # 80008330 <states.1732+0xa8>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	fe6080e7          	jalr	-26(ra) # 80005e1c <printf>
    setkilled(p);
    80001e3e:	8526                	mv	a0,s1
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	9d8080e7          	jalr	-1576(ra) # 80001818 <setkilled>
    80001e48:	b761                	j	80001dd0 <usertrap+0x92>
    struct proc *p1 = myproc();
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	068080e7          	jalr	104(ra) # 80000eb2 <myproc>
    p1->passed_ticks++;
    80001e52:	551c                	lw	a5,40(a0)
    80001e54:	2785                	addiw	a5,a5,1
    80001e56:	0007871b          	sext.w	a4,a5
    80001e5a:	d51c                	sw	a5,40(a0)
    if(p1->passed_ticks == p1->alarm_interval && p1->isreturn) //call alarm() function
    80001e5c:	4d1c                	lw	a5,24(a0)
    80001e5e:	00e78763          	beq	a5,a4,80001e6c <usertrap+0x12e>
    yield();
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	6ea080e7          	jalr	1770(ra) # 8000154c <yield>
    80001e6a:	b751                	j	80001dee <usertrap+0xb0>
    if(p1->passed_ticks == p1->alarm_interval && p1->isreturn) //call alarm() function
    80001e6c:	15052783          	lw	a5,336(a0)
    80001e70:	dbed                	beqz	a5,80001e62 <usertrap+0x124>
      p1->isreturn = 0;
    80001e72:	14052823          	sw	zero,336(a0)
      p1->passed_ticks = 0;
    80001e76:	02052423          	sw	zero,40(a0)
      p1->save = *p1->trapframe;
    80001e7a:	19053883          	ld	a7,400(a0)
    80001e7e:	87c6                	mv	a5,a7
    80001e80:	03050713          	addi	a4,a0,48
    80001e84:	12088313          	addi	t1,a7,288
    80001e88:	0007b803          	ld	a6,0(a5)
    80001e8c:	678c                	ld	a1,8(a5)
    80001e8e:	6b90                	ld	a2,16(a5)
    80001e90:	6f94                	ld	a3,24(a5)
    80001e92:	01073023          	sd	a6,0(a4)
    80001e96:	e70c                	sd	a1,8(a4)
    80001e98:	eb10                	sd	a2,16(a4)
    80001e9a:	ef14                	sd	a3,24(a4)
    80001e9c:	02078793          	addi	a5,a5,32
    80001ea0:	02070713          	addi	a4,a4,32
    80001ea4:	fe6792e3          	bne	a5,t1,80001e88 <usertrap+0x14a>
      p1->trapframe->epc = p1->handler_pointer; //go to periodic
    80001ea8:	711c                	ld	a5,32(a0)
    80001eaa:	00f8bc23          	sd	a5,24(a7)
    80001eae:	bf55                	j	80001e62 <usertrap+0x124>

0000000080001eb0 <kerneltrap>:
{
    80001eb0:	7179                	addi	sp,sp,-48
    80001eb2:	f406                	sd	ra,40(sp)
    80001eb4:	f022                	sd	s0,32(sp)
    80001eb6:	ec26                	sd	s1,24(sp)
    80001eb8:	e84a                	sd	s2,16(sp)
    80001eba:	e44e                	sd	s3,8(sp)
    80001ebc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ebe:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ec6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001eca:	1004f793          	andi	a5,s1,256
    80001ece:	cb85                	beqz	a5,80001efe <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ed4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ed6:	ef85                	bnez	a5,80001f0e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	dc4080e7          	jalr	-572(ra) # 80001c9c <devintr>
    80001ee0:	cd1d                	beqz	a0,80001f1e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee2:	4789                	li	a5,2
    80001ee4:	06f50a63          	beq	a0,a5,80001f58 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ee8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eec:	10049073          	csrw	sstatus,s1
}
    80001ef0:	70a2                	ld	ra,40(sp)
    80001ef2:	7402                	ld	s0,32(sp)
    80001ef4:	64e2                	ld	s1,24(sp)
    80001ef6:	6942                	ld	s2,16(sp)
    80001ef8:	69a2                	ld	s3,8(sp)
    80001efa:	6145                	addi	sp,sp,48
    80001efc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	45250513          	addi	a0,a0,1106 # 80008350 <states.1732+0xc8>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	ecc080e7          	jalr	-308(ra) # 80005dd2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f0e:	00006517          	auipc	a0,0x6
    80001f12:	46a50513          	addi	a0,a0,1130 # 80008378 <states.1732+0xf0>
    80001f16:	00004097          	auipc	ra,0x4
    80001f1a:	ebc080e7          	jalr	-324(ra) # 80005dd2 <panic>
    printf("scause %p\n", scause);
    80001f1e:	85ce                	mv	a1,s3
    80001f20:	00006517          	auipc	a0,0x6
    80001f24:	47850513          	addi	a0,a0,1144 # 80008398 <states.1732+0x110>
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	ef4080e7          	jalr	-268(ra) # 80005e1c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f30:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f34:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	47050513          	addi	a0,a0,1136 # 800083a8 <states.1732+0x120>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	edc080e7          	jalr	-292(ra) # 80005e1c <printf>
    panic("kerneltrap");
    80001f48:	00006517          	auipc	a0,0x6
    80001f4c:	47850513          	addi	a0,a0,1144 # 800083c0 <states.1732+0x138>
    80001f50:	00004097          	auipc	ra,0x4
    80001f54:	e82080e7          	jalr	-382(ra) # 80005dd2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	f5a080e7          	jalr	-166(ra) # 80000eb2 <myproc>
    80001f60:	d541                	beqz	a0,80001ee8 <kerneltrap+0x38>
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	f50080e7          	jalr	-176(ra) # 80000eb2 <myproc>
    80001f6a:	15452703          	lw	a4,340(a0)
    80001f6e:	4791                	li	a5,4
    80001f70:	f6f71ce3          	bne	a4,a5,80001ee8 <kerneltrap+0x38>
    yield();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	5d8080e7          	jalr	1496(ra) # 8000154c <yield>
    80001f7c:	b7b5                	j	80001ee8 <kerneltrap+0x38>

0000000080001f7e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f7e:	1101                	addi	sp,sp,-32
    80001f80:	ec06                	sd	ra,24(sp)
    80001f82:	e822                	sd	s0,16(sp)
    80001f84:	e426                	sd	s1,8(sp)
    80001f86:	1000                	addi	s0,sp,32
    80001f88:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	f28080e7          	jalr	-216(ra) # 80000eb2 <myproc>
  switch (n) {
    80001f92:	4795                	li	a5,5
    80001f94:	0497e763          	bltu	a5,s1,80001fe2 <argraw+0x64>
    80001f98:	048a                	slli	s1,s1,0x2
    80001f9a:	00006717          	auipc	a4,0x6
    80001f9e:	45e70713          	addi	a4,a4,1118 # 800083f8 <states.1732+0x170>
    80001fa2:	94ba                	add	s1,s1,a4
    80001fa4:	409c                	lw	a5,0(s1)
    80001fa6:	97ba                	add	a5,a5,a4
    80001fa8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001faa:	19053783          	ld	a5,400(a0)
    80001fae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fb0:	60e2                	ld	ra,24(sp)
    80001fb2:	6442                	ld	s0,16(sp)
    80001fb4:	64a2                	ld	s1,8(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret
    return p->trapframe->a1;
    80001fba:	19053783          	ld	a5,400(a0)
    80001fbe:	7fa8                	ld	a0,120(a5)
    80001fc0:	bfc5                	j	80001fb0 <argraw+0x32>
    return p->trapframe->a2;
    80001fc2:	19053783          	ld	a5,400(a0)
    80001fc6:	63c8                	ld	a0,128(a5)
    80001fc8:	b7e5                	j	80001fb0 <argraw+0x32>
    return p->trapframe->a3;
    80001fca:	19053783          	ld	a5,400(a0)
    80001fce:	67c8                	ld	a0,136(a5)
    80001fd0:	b7c5                	j	80001fb0 <argraw+0x32>
    return p->trapframe->a4;
    80001fd2:	19053783          	ld	a5,400(a0)
    80001fd6:	6bc8                	ld	a0,144(a5)
    80001fd8:	bfe1                	j	80001fb0 <argraw+0x32>
    return p->trapframe->a5;
    80001fda:	19053783          	ld	a5,400(a0)
    80001fde:	6fc8                	ld	a0,152(a5)
    80001fe0:	bfc1                	j	80001fb0 <argraw+0x32>
  panic("argraw");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	3ee50513          	addi	a0,a0,1006 # 800083d0 <states.1732+0x148>
    80001fea:	00004097          	auipc	ra,0x4
    80001fee:	de8080e7          	jalr	-536(ra) # 80005dd2 <panic>

0000000080001ff2 <fetchaddr>:
{
    80001ff2:	1101                	addi	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	e04a                	sd	s2,0(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84aa                	mv	s1,a0
    80002000:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	eb0080e7          	jalr	-336(ra) # 80000eb2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000200a:	18053783          	ld	a5,384(a0)
    8000200e:	02f4f963          	bgeu	s1,a5,80002040 <fetchaddr+0x4e>
    80002012:	00848713          	addi	a4,s1,8
    80002016:	02e7e763          	bltu	a5,a4,80002044 <fetchaddr+0x52>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000201a:	46a1                	li	a3,8
    8000201c:	8626                	mv	a2,s1
    8000201e:	85ca                	mv	a1,s2
    80002020:	18853503          	ld	a0,392(a0)
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	bd6080e7          	jalr	-1066(ra) # 80000bfa <copyin>
    8000202c:	00a03533          	snez	a0,a0
    80002030:	40a00533          	neg	a0,a0
}
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6902                	ld	s2,0(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret
    return -1;
    80002040:	557d                	li	a0,-1
    80002042:	bfcd                	j	80002034 <fetchaddr+0x42>
    80002044:	557d                	li	a0,-1
    80002046:	b7fd                	j	80002034 <fetchaddr+0x42>

0000000080002048 <fetchstr>:
{
    80002048:	7179                	addi	sp,sp,-48
    8000204a:	f406                	sd	ra,40(sp)
    8000204c:	f022                	sd	s0,32(sp)
    8000204e:	ec26                	sd	s1,24(sp)
    80002050:	e84a                	sd	s2,16(sp)
    80002052:	e44e                	sd	s3,8(sp)
    80002054:	1800                	addi	s0,sp,48
    80002056:	892a                	mv	s2,a0
    80002058:	84ae                	mv	s1,a1
    8000205a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	e56080e7          	jalr	-426(ra) # 80000eb2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002064:	86ce                	mv	a3,s3
    80002066:	864a                	mv	a2,s2
    80002068:	85a6                	mv	a1,s1
    8000206a:	18853503          	ld	a0,392(a0)
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	c18080e7          	jalr	-1000(ra) # 80000c86 <copyinstr>
    80002076:	00054e63          	bltz	a0,80002092 <fetchstr+0x4a>
  return strlen(buf);
    8000207a:	8526                	mv	a0,s1
    8000207c:	ffffe097          	auipc	ra,0xffffe
    80002080:	280080e7          	jalr	640(ra) # 800002fc <strlen>
}
    80002084:	70a2                	ld	ra,40(sp)
    80002086:	7402                	ld	s0,32(sp)
    80002088:	64e2                	ld	s1,24(sp)
    8000208a:	6942                	ld	s2,16(sp)
    8000208c:	69a2                	ld	s3,8(sp)
    8000208e:	6145                	addi	sp,sp,48
    80002090:	8082                	ret
    return -1;
    80002092:	557d                	li	a0,-1
    80002094:	bfc5                	j	80002084 <fetchstr+0x3c>

0000000080002096 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002096:	1101                	addi	sp,sp,-32
    80002098:	ec06                	sd	ra,24(sp)
    8000209a:	e822                	sd	s0,16(sp)
    8000209c:	e426                	sd	s1,8(sp)
    8000209e:	1000                	addi	s0,sp,32
    800020a0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020a2:	00000097          	auipc	ra,0x0
    800020a6:	edc080e7          	jalr	-292(ra) # 80001f7e <argraw>
    800020aa:	c088                	sw	a0,0(s1)
}
    800020ac:	60e2                	ld	ra,24(sp)
    800020ae:	6442                	ld	s0,16(sp)
    800020b0:	64a2                	ld	s1,8(sp)
    800020b2:	6105                	addi	sp,sp,32
    800020b4:	8082                	ret

00000000800020b6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	1000                	addi	s0,sp,32
    800020c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	ebc080e7          	jalr	-324(ra) # 80001f7e <argraw>
    800020ca:	e088                	sd	a0,0(s1)
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	64a2                	ld	s1,8(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020d6:	7179                	addi	sp,sp,-48
    800020d8:	f406                	sd	ra,40(sp)
    800020da:	f022                	sd	s0,32(sp)
    800020dc:	ec26                	sd	s1,24(sp)
    800020de:	e84a                	sd	s2,16(sp)
    800020e0:	1800                	addi	s0,sp,48
    800020e2:	84ae                	mv	s1,a1
    800020e4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020e6:	fd840593          	addi	a1,s0,-40
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	fcc080e7          	jalr	-52(ra) # 800020b6 <argaddr>
  return fetchstr(addr, buf, max);
    800020f2:	864a                	mv	a2,s2
    800020f4:	85a6                	mv	a1,s1
    800020f6:	fd843503          	ld	a0,-40(s0)
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	f4e080e7          	jalr	-178(ra) # 80002048 <fetchstr>
}
    80002102:	70a2                	ld	ra,40(sp)
    80002104:	7402                	ld	s0,32(sp)
    80002106:	64e2                	ld	s1,24(sp)
    80002108:	6942                	ld	s2,16(sp)
    8000210a:	6145                	addi	sp,sp,48
    8000210c:	8082                	ret

000000008000210e <syscall>:
[SYS_sigreturn] sys_sigreturn, //new!
};

void
syscall(void)
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	e04a                	sd	s2,0(sp)
    80002118:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	d98080e7          	jalr	-616(ra) # 80000eb2 <myproc>
    80002122:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002124:	19053903          	ld	s2,400(a0)
    80002128:	0a893783          	ld	a5,168(s2)
    8000212c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002130:	37fd                	addiw	a5,a5,-1
    80002132:	4759                	li	a4,22
    80002134:	00f76f63          	bltu	a4,a5,80002152 <syscall+0x44>
    80002138:	00369713          	slli	a4,a3,0x3
    8000213c:	00006797          	auipc	a5,0x6
    80002140:	2d478793          	addi	a5,a5,724 # 80008410 <syscalls>
    80002144:	97ba                	add	a5,a5,a4
    80002146:	639c                	ld	a5,0(a5)
    80002148:	c789                	beqz	a5,80002152 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000214a:	9782                	jalr	a5
    8000214c:	06a93823          	sd	a0,112(s2)
    80002150:	a00d                	j	80002172 <syscall+0x64>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002152:	29048613          	addi	a2,s1,656
    80002156:	1684a583          	lw	a1,360(s1)
    8000215a:	00006517          	auipc	a0,0x6
    8000215e:	27e50513          	addi	a0,a0,638 # 800083d8 <states.1732+0x150>
    80002162:	00004097          	auipc	ra,0x4
    80002166:	cba080e7          	jalr	-838(ra) # 80005e1c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000216a:	1904b783          	ld	a5,400(s1)
    8000216e:	577d                	li	a4,-1
    80002170:	fbb8                	sd	a4,112(a5)
  }
}
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	64a2                	ld	s1,8(sp)
    80002178:	6902                	ld	s2,0(sp)
    8000217a:	6105                	addi	sp,sp,32
    8000217c:	8082                	ret

000000008000217e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000217e:	1101                	addi	sp,sp,-32
    80002180:	ec06                	sd	ra,24(sp)
    80002182:	e822                	sd	s0,16(sp)
    80002184:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002186:	fec40593          	addi	a1,s0,-20
    8000218a:	4501                	li	a0,0
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	f0a080e7          	jalr	-246(ra) # 80002096 <argint>
  exit(n);
    80002194:	fec42503          	lw	a0,-20(s0)
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	530080e7          	jalr	1328(ra) # 800016c8 <exit>
  return 0;  // not reached
}
    800021a0:	4501                	li	a0,0
    800021a2:	60e2                	ld	ra,24(sp)
    800021a4:	6442                	ld	s0,16(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <sys_getpid>:

uint64
sys_getpid(void)
{
    800021aa:	1141                	addi	sp,sp,-16
    800021ac:	e406                	sd	ra,8(sp)
    800021ae:	e022                	sd	s0,0(sp)
    800021b0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	d00080e7          	jalr	-768(ra) # 80000eb2 <myproc>
}
    800021ba:	16852503          	lw	a0,360(a0)
    800021be:	60a2                	ld	ra,8(sp)
    800021c0:	6402                	ld	s0,0(sp)
    800021c2:	0141                	addi	sp,sp,16
    800021c4:	8082                	ret

00000000800021c6 <sys_fork>:

uint64
sys_fork(void)
{
    800021c6:	1141                	addi	sp,sp,-16
    800021c8:	e406                	sd	ra,8(sp)
    800021ca:	e022                	sd	s0,0(sp)
    800021cc:	0800                	addi	s0,sp,16
  return fork();
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	0c6080e7          	jalr	198(ra) # 80001294 <fork>
}
    800021d6:	60a2                	ld	ra,8(sp)
    800021d8:	6402                	ld	s0,0(sp)
    800021da:	0141                	addi	sp,sp,16
    800021dc:	8082                	ret

00000000800021de <sys_wait>:

uint64
sys_wait(void)
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021e6:	fe840593          	addi	a1,s0,-24
    800021ea:	4501                	li	a0,0
    800021ec:	00000097          	auipc	ra,0x0
    800021f0:	eca080e7          	jalr	-310(ra) # 800020b6 <argaddr>
  return wait(p);
    800021f4:	fe843503          	ld	a0,-24(s0)
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	680080e7          	jalr	1664(ra) # 80001878 <wait>
}
    80002200:	60e2                	ld	ra,24(sp)
    80002202:	6442                	ld	s0,16(sp)
    80002204:	6105                	addi	sp,sp,32
    80002206:	8082                	ret

0000000080002208 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002208:	7179                	addi	sp,sp,-48
    8000220a:	f406                	sd	ra,40(sp)
    8000220c:	f022                	sd	s0,32(sp)
    8000220e:	ec26                	sd	s1,24(sp)
    80002210:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002212:	fdc40593          	addi	a1,s0,-36
    80002216:	4501                	li	a0,0
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	e7e080e7          	jalr	-386(ra) # 80002096 <argint>
  addr = myproc()->sz;
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	c92080e7          	jalr	-878(ra) # 80000eb2 <myproc>
    80002228:	18053483          	ld	s1,384(a0)
  if(growproc(n) < 0)
    8000222c:	fdc42503          	lw	a0,-36(s0)
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	000080e7          	jalr	ra # 80001230 <growproc>
    80002238:	00054863          	bltz	a0,80002248 <sys_sbrk+0x40>
    return -1;
  return addr;
}
    8000223c:	8526                	mv	a0,s1
    8000223e:	70a2                	ld	ra,40(sp)
    80002240:	7402                	ld	s0,32(sp)
    80002242:	64e2                	ld	s1,24(sp)
    80002244:	6145                	addi	sp,sp,48
    80002246:	8082                	ret
    return -1;
    80002248:	54fd                	li	s1,-1
    8000224a:	bfcd                	j	8000223c <sys_sbrk+0x34>

000000008000224c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000224c:	7139                	addi	sp,sp,-64
    8000224e:	fc06                	sd	ra,56(sp)
    80002250:	f822                	sd	s0,48(sp)
    80002252:	f426                	sd	s1,40(sp)
    80002254:	f04a                	sd	s2,32(sp)
    80002256:	ec4e                	sd	s3,24(sp)
    80002258:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  backtrace();
    8000225a:	00004097          	auipc	ra,0x4
    8000225e:	dda080e7          	jalr	-550(ra) # 80006034 <backtrace>

  argint(0, &n);
    80002262:	fcc40593          	addi	a1,s0,-52
    80002266:	4501                	li	a0,0
    80002268:	00000097          	auipc	ra,0x0
    8000226c:	e2e080e7          	jalr	-466(ra) # 80002096 <argint>
  if(n < 0)
    80002270:	fcc42783          	lw	a5,-52(s0)
    80002274:	0607cf63          	bltz	a5,800022f2 <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    80002278:	00011517          	auipc	a0,0x11
    8000227c:	32850513          	addi	a0,a0,808 # 800135a0 <tickslock>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	0f8080e7          	jalr	248(ra) # 80006378 <acquire>
  ticks0 = ticks;
    80002288:	00006917          	auipc	s2,0x6
    8000228c:	6b092903          	lw	s2,1712(s2) # 80008938 <ticks>
  while(ticks - ticks0 < n){
    80002290:	fcc42783          	lw	a5,-52(s0)
    80002294:	cf9d                	beqz	a5,800022d2 <sys_sleep+0x86>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002296:	00011997          	auipc	s3,0x11
    8000229a:	30a98993          	addi	s3,s3,778 # 800135a0 <tickslock>
    8000229e:	00006497          	auipc	s1,0x6
    800022a2:	69a48493          	addi	s1,s1,1690 # 80008938 <ticks>
    if(killed(myproc())){
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	c0c080e7          	jalr	-1012(ra) # 80000eb2 <myproc>
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	598080e7          	jalr	1432(ra) # 80001846 <killed>
    800022b6:	e129                	bnez	a0,800022f8 <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    800022b8:	85ce                	mv	a1,s3
    800022ba:	8526                	mv	a0,s1
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	2ce080e7          	jalr	718(ra) # 8000158a <sleep>
  while(ticks - ticks0 < n){
    800022c4:	409c                	lw	a5,0(s1)
    800022c6:	412787bb          	subw	a5,a5,s2
    800022ca:	fcc42703          	lw	a4,-52(s0)
    800022ce:	fce7ece3          	bltu	a5,a4,800022a6 <sys_sleep+0x5a>
  }
  release(&tickslock);
    800022d2:	00011517          	auipc	a0,0x11
    800022d6:	2ce50513          	addi	a0,a0,718 # 800135a0 <tickslock>
    800022da:	00004097          	auipc	ra,0x4
    800022de:	152080e7          	jalr	338(ra) # 8000642c <release>
  return 0;
    800022e2:	4501                	li	a0,0
}
    800022e4:	70e2                	ld	ra,56(sp)
    800022e6:	7442                	ld	s0,48(sp)
    800022e8:	74a2                	ld	s1,40(sp)
    800022ea:	7902                	ld	s2,32(sp)
    800022ec:	69e2                	ld	s3,24(sp)
    800022ee:	6121                	addi	sp,sp,64
    800022f0:	8082                	ret
    n = 0;
    800022f2:	fc042623          	sw	zero,-52(s0)
    800022f6:	b749                	j	80002278 <sys_sleep+0x2c>
      release(&tickslock);
    800022f8:	00011517          	auipc	a0,0x11
    800022fc:	2a850513          	addi	a0,a0,680 # 800135a0 <tickslock>
    80002300:	00004097          	auipc	ra,0x4
    80002304:	12c080e7          	jalr	300(ra) # 8000642c <release>
      return -1;
    80002308:	557d                	li	a0,-1
    8000230a:	bfe9                	j	800022e4 <sys_sleep+0x98>

000000008000230c <sys_kill>:

uint64
sys_kill(void)
{
    8000230c:	1101                	addi	sp,sp,-32
    8000230e:	ec06                	sd	ra,24(sp)
    80002310:	e822                	sd	s0,16(sp)
    80002312:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002314:	fec40593          	addi	a1,s0,-20
    80002318:	4501                	li	a0,0
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	d7c080e7          	jalr	-644(ra) # 80002096 <argint>
  return kill(pid);
    80002322:	fec42503          	lw	a0,-20(s0)
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	478080e7          	jalr	1144(ra) # 8000179e <kill>
}
    8000232e:	60e2                	ld	ra,24(sp)
    80002330:	6442                	ld	s0,16(sp)
    80002332:	6105                	addi	sp,sp,32
    80002334:	8082                	ret

0000000080002336 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002336:	1101                	addi	sp,sp,-32
    80002338:	ec06                	sd	ra,24(sp)
    8000233a:	e822                	sd	s0,16(sp)
    8000233c:	e426                	sd	s1,8(sp)
    8000233e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002340:	00011517          	auipc	a0,0x11
    80002344:	26050513          	addi	a0,a0,608 # 800135a0 <tickslock>
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	030080e7          	jalr	48(ra) # 80006378 <acquire>
  xticks = ticks;
    80002350:	00006497          	auipc	s1,0x6
    80002354:	5e84a483          	lw	s1,1512(s1) # 80008938 <ticks>
  release(&tickslock);
    80002358:	00011517          	auipc	a0,0x11
    8000235c:	24850513          	addi	a0,a0,584 # 800135a0 <tickslock>
    80002360:	00004097          	auipc	ra,0x4
    80002364:	0cc080e7          	jalr	204(ra) # 8000642c <release>
  return xticks;
}
    80002368:	02049513          	slli	a0,s1,0x20
    8000236c:	9101                	srli	a0,a0,0x20
    8000236e:	60e2                	ld	ra,24(sp)
    80002370:	6442                	ld	s0,16(sp)
    80002372:	64a2                	ld	s1,8(sp)
    80002374:	6105                	addi	sp,sp,32
    80002376:	8082                	ret

0000000080002378 <sys_sigreturn>:

uint64 sys_sigreturn(void) //new!
{
    80002378:	1141                	addi	sp,sp,-16
    8000237a:	e406                	sd	ra,8(sp)
    8000237c:	e022                	sd	s0,0(sp)
    8000237e:	0800                	addi	s0,sp,16
  struct proc* proc = myproc();
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	b32080e7          	jalr	-1230(ra) # 80000eb2 <myproc>
  *proc->trapframe = proc->save;
    80002388:	03050793          	addi	a5,a0,48
    8000238c:	19053703          	ld	a4,400(a0)
    80002390:	15050693          	addi	a3,a0,336
    80002394:	0007b883          	ld	a7,0(a5)
    80002398:	0087b803          	ld	a6,8(a5)
    8000239c:	6b8c                	ld	a1,16(a5)
    8000239e:	6f90                	ld	a2,24(a5)
    800023a0:	01173023          	sd	a7,0(a4)
    800023a4:	01073423          	sd	a6,8(a4)
    800023a8:	eb0c                	sd	a1,16(a4)
    800023aa:	ef10                	sd	a2,24(a4)
    800023ac:	02078793          	addi	a5,a5,32
    800023b0:	02070713          	addi	a4,a4,32
    800023b4:	fed790e3          	bne	a5,a3,80002394 <sys_sigreturn+0x1c>
  proc->isreturn = 1; // true
    800023b8:	4785                	li	a5,1
    800023ba:	14f52823          	sw	a5,336(a0)
  return proc->trapframe->a0;
    800023be:	19053783          	ld	a5,400(a0)
}
    800023c2:	7ba8                	ld	a0,112(a5)
    800023c4:	60a2                	ld	ra,8(sp)
    800023c6:	6402                	ld	s0,0(sp)
    800023c8:	0141                	addi	sp,sp,16
    800023ca:	8082                	ret

00000000800023cc <sys_sigalarm>:

uint64 sys_sigalarm(void) //new!
{
    800023cc:	7179                	addi	sp,sp,-48
    800023ce:	f406                	sd	ra,40(sp)
    800023d0:	f022                	sd	s0,32(sp)
    800023d2:	ec26                	sd	s1,24(sp)
    800023d4:	1800                	addi	s0,sp,48
  int alarm_interval;
  uint64 handler_pointer;
  struct proc* alarmproc = myproc();
    800023d6:	fffff097          	auipc	ra,0xfffff
    800023da:	adc080e7          	jalr	-1316(ra) # 80000eb2 <myproc>
    800023de:	84aa                	mv	s1,a0
  argint(0, &alarm_interval);
    800023e0:	fdc40593          	addi	a1,s0,-36
    800023e4:	4501                	li	a0,0
    800023e6:	00000097          	auipc	ra,0x0
    800023ea:	cb0080e7          	jalr	-848(ra) # 80002096 <argint>
  argaddr(1, &handler_pointer);
    800023ee:	fd040593          	addi	a1,s0,-48
    800023f2:	4505                	li	a0,1
    800023f4:	00000097          	auipc	ra,0x0
    800023f8:	cc2080e7          	jalr	-830(ra) # 800020b6 <argaddr>

  alarmproc->alarm_interval = alarm_interval;
    800023fc:	fdc42783          	lw	a5,-36(s0)
    80002400:	cc9c                	sw	a5,24(s1)
  alarmproc->handler_pointer = handler_pointer;
    80002402:	fd043783          	ld	a5,-48(s0)
    80002406:	f09c                	sd	a5,32(s1)
  alarmproc->isreturn = 1;
    80002408:	4785                	li	a5,1
    8000240a:	14f4a823          	sw	a5,336(s1)
  return 0;
}
    8000240e:	4501                	li	a0,0
    80002410:	70a2                	ld	ra,40(sp)
    80002412:	7402                	ld	s0,32(sp)
    80002414:	64e2                	ld	s1,24(sp)
    80002416:	6145                	addi	sp,sp,48
    80002418:	8082                	ret

000000008000241a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000241a:	7179                	addi	sp,sp,-48
    8000241c:	f406                	sd	ra,40(sp)
    8000241e:	f022                	sd	s0,32(sp)
    80002420:	ec26                	sd	s1,24(sp)
    80002422:	e84a                	sd	s2,16(sp)
    80002424:	e44e                	sd	s3,8(sp)
    80002426:	e052                	sd	s4,0(sp)
    80002428:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000242a:	00006597          	auipc	a1,0x6
    8000242e:	0a658593          	addi	a1,a1,166 # 800084d0 <syscalls+0xc0>
    80002432:	00011517          	auipc	a0,0x11
    80002436:	18650513          	addi	a0,a0,390 # 800135b8 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	eae080e7          	jalr	-338(ra) # 800062e8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002442:	00019797          	auipc	a5,0x19
    80002446:	17678793          	addi	a5,a5,374 # 8001b5b8 <bcache+0x8000>
    8000244a:	00019717          	auipc	a4,0x19
    8000244e:	3d670713          	addi	a4,a4,982 # 8001b820 <bcache+0x8268>
    80002452:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002456:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000245a:	00011497          	auipc	s1,0x11
    8000245e:	17648493          	addi	s1,s1,374 # 800135d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002462:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002464:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002466:	00006a17          	auipc	s4,0x6
    8000246a:	072a0a13          	addi	s4,s4,114 # 800084d8 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000246e:	2b893783          	ld	a5,696(s2)
    80002472:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002474:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002478:	85d2                	mv	a1,s4
    8000247a:	01048513          	addi	a0,s1,16
    8000247e:	00001097          	auipc	ra,0x1
    80002482:	4c4080e7          	jalr	1220(ra) # 80003942 <initsleeplock>
    bcache.head.next->prev = b;
    80002486:	2b893783          	ld	a5,696(s2)
    8000248a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000248c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002490:	45848493          	addi	s1,s1,1112
    80002494:	fd349de3          	bne	s1,s3,8000246e <binit+0x54>
  }
}
    80002498:	70a2                	ld	ra,40(sp)
    8000249a:	7402                	ld	s0,32(sp)
    8000249c:	64e2                	ld	s1,24(sp)
    8000249e:	6942                	ld	s2,16(sp)
    800024a0:	69a2                	ld	s3,8(sp)
    800024a2:	6a02                	ld	s4,0(sp)
    800024a4:	6145                	addi	sp,sp,48
    800024a6:	8082                	ret

00000000800024a8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024a8:	7179                	addi	sp,sp,-48
    800024aa:	f406                	sd	ra,40(sp)
    800024ac:	f022                	sd	s0,32(sp)
    800024ae:	ec26                	sd	s1,24(sp)
    800024b0:	e84a                	sd	s2,16(sp)
    800024b2:	e44e                	sd	s3,8(sp)
    800024b4:	1800                	addi	s0,sp,48
    800024b6:	89aa                	mv	s3,a0
    800024b8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024ba:	00011517          	auipc	a0,0x11
    800024be:	0fe50513          	addi	a0,a0,254 # 800135b8 <bcache>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	eb6080e7          	jalr	-330(ra) # 80006378 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024ca:	00019497          	auipc	s1,0x19
    800024ce:	3a64b483          	ld	s1,934(s1) # 8001b870 <bcache+0x82b8>
    800024d2:	00019797          	auipc	a5,0x19
    800024d6:	34e78793          	addi	a5,a5,846 # 8001b820 <bcache+0x8268>
    800024da:	02f48f63          	beq	s1,a5,80002518 <bread+0x70>
    800024de:	873e                	mv	a4,a5
    800024e0:	a021                	j	800024e8 <bread+0x40>
    800024e2:	68a4                	ld	s1,80(s1)
    800024e4:	02e48a63          	beq	s1,a4,80002518 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024e8:	449c                	lw	a5,8(s1)
    800024ea:	ff379ce3          	bne	a5,s3,800024e2 <bread+0x3a>
    800024ee:	44dc                	lw	a5,12(s1)
    800024f0:	ff2799e3          	bne	a5,s2,800024e2 <bread+0x3a>
      b->refcnt++;
    800024f4:	40bc                	lw	a5,64(s1)
    800024f6:	2785                	addiw	a5,a5,1
    800024f8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024fa:	00011517          	auipc	a0,0x11
    800024fe:	0be50513          	addi	a0,a0,190 # 800135b8 <bcache>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	f2a080e7          	jalr	-214(ra) # 8000642c <release>
      acquiresleep(&b->lock);
    8000250a:	01048513          	addi	a0,s1,16
    8000250e:	00001097          	auipc	ra,0x1
    80002512:	46e080e7          	jalr	1134(ra) # 8000397c <acquiresleep>
      return b;
    80002516:	a8b9                	j	80002574 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002518:	00019497          	auipc	s1,0x19
    8000251c:	3504b483          	ld	s1,848(s1) # 8001b868 <bcache+0x82b0>
    80002520:	00019797          	auipc	a5,0x19
    80002524:	30078793          	addi	a5,a5,768 # 8001b820 <bcache+0x8268>
    80002528:	00f48863          	beq	s1,a5,80002538 <bread+0x90>
    8000252c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000252e:	40bc                	lw	a5,64(s1)
    80002530:	cf81                	beqz	a5,80002548 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002532:	64a4                	ld	s1,72(s1)
    80002534:	fee49de3          	bne	s1,a4,8000252e <bread+0x86>
  panic("bget: no buffers");
    80002538:	00006517          	auipc	a0,0x6
    8000253c:	fa850513          	addi	a0,a0,-88 # 800084e0 <syscalls+0xd0>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	892080e7          	jalr	-1902(ra) # 80005dd2 <panic>
      b->dev = dev;
    80002548:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000254c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002550:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002554:	4785                	li	a5,1
    80002556:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002558:	00011517          	auipc	a0,0x11
    8000255c:	06050513          	addi	a0,a0,96 # 800135b8 <bcache>
    80002560:	00004097          	auipc	ra,0x4
    80002564:	ecc080e7          	jalr	-308(ra) # 8000642c <release>
      acquiresleep(&b->lock);
    80002568:	01048513          	addi	a0,s1,16
    8000256c:	00001097          	auipc	ra,0x1
    80002570:	410080e7          	jalr	1040(ra) # 8000397c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002574:	409c                	lw	a5,0(s1)
    80002576:	cb89                	beqz	a5,80002588 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002578:	8526                	mv	a0,s1
    8000257a:	70a2                	ld	ra,40(sp)
    8000257c:	7402                	ld	s0,32(sp)
    8000257e:	64e2                	ld	s1,24(sp)
    80002580:	6942                	ld	s2,16(sp)
    80002582:	69a2                	ld	s3,8(sp)
    80002584:	6145                	addi	sp,sp,48
    80002586:	8082                	ret
    virtio_disk_rw(b, 0);
    80002588:	4581                	li	a1,0
    8000258a:	8526                	mv	a0,s1
    8000258c:	00003097          	auipc	ra,0x3
    80002590:	fdc080e7          	jalr	-36(ra) # 80005568 <virtio_disk_rw>
    b->valid = 1;
    80002594:	4785                	li	a5,1
    80002596:	c09c                	sw	a5,0(s1)
  return b;
    80002598:	b7c5                	j	80002578 <bread+0xd0>

000000008000259a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	1000                	addi	s0,sp,32
    800025a4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a6:	0541                	addi	a0,a0,16
    800025a8:	00001097          	auipc	ra,0x1
    800025ac:	470080e7          	jalr	1136(ra) # 80003a18 <holdingsleep>
    800025b0:	cd01                	beqz	a0,800025c8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025b2:	4585                	li	a1,1
    800025b4:	8526                	mv	a0,s1
    800025b6:	00003097          	auipc	ra,0x3
    800025ba:	fb2080e7          	jalr	-78(ra) # 80005568 <virtio_disk_rw>
}
    800025be:	60e2                	ld	ra,24(sp)
    800025c0:	6442                	ld	s0,16(sp)
    800025c2:	64a2                	ld	s1,8(sp)
    800025c4:	6105                	addi	sp,sp,32
    800025c6:	8082                	ret
    panic("bwrite");
    800025c8:	00006517          	auipc	a0,0x6
    800025cc:	f3050513          	addi	a0,a0,-208 # 800084f8 <syscalls+0xe8>
    800025d0:	00004097          	auipc	ra,0x4
    800025d4:	802080e7          	jalr	-2046(ra) # 80005dd2 <panic>

00000000800025d8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025d8:	1101                	addi	sp,sp,-32
    800025da:	ec06                	sd	ra,24(sp)
    800025dc:	e822                	sd	s0,16(sp)
    800025de:	e426                	sd	s1,8(sp)
    800025e0:	e04a                	sd	s2,0(sp)
    800025e2:	1000                	addi	s0,sp,32
    800025e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025e6:	01050913          	addi	s2,a0,16
    800025ea:	854a                	mv	a0,s2
    800025ec:	00001097          	auipc	ra,0x1
    800025f0:	42c080e7          	jalr	1068(ra) # 80003a18 <holdingsleep>
    800025f4:	c92d                	beqz	a0,80002666 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025f6:	854a                	mv	a0,s2
    800025f8:	00001097          	auipc	ra,0x1
    800025fc:	3dc080e7          	jalr	988(ra) # 800039d4 <releasesleep>

  acquire(&bcache.lock);
    80002600:	00011517          	auipc	a0,0x11
    80002604:	fb850513          	addi	a0,a0,-72 # 800135b8 <bcache>
    80002608:	00004097          	auipc	ra,0x4
    8000260c:	d70080e7          	jalr	-656(ra) # 80006378 <acquire>
  b->refcnt--;
    80002610:	40bc                	lw	a5,64(s1)
    80002612:	37fd                	addiw	a5,a5,-1
    80002614:	0007871b          	sext.w	a4,a5
    80002618:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000261a:	eb05                	bnez	a4,8000264a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000261c:	68bc                	ld	a5,80(s1)
    8000261e:	64b8                	ld	a4,72(s1)
    80002620:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002622:	64bc                	ld	a5,72(s1)
    80002624:	68b8                	ld	a4,80(s1)
    80002626:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002628:	00019797          	auipc	a5,0x19
    8000262c:	f9078793          	addi	a5,a5,-112 # 8001b5b8 <bcache+0x8000>
    80002630:	2b87b703          	ld	a4,696(a5)
    80002634:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002636:	00019717          	auipc	a4,0x19
    8000263a:	1ea70713          	addi	a4,a4,490 # 8001b820 <bcache+0x8268>
    8000263e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002640:	2b87b703          	ld	a4,696(a5)
    80002644:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002646:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000264a:	00011517          	auipc	a0,0x11
    8000264e:	f6e50513          	addi	a0,a0,-146 # 800135b8 <bcache>
    80002652:	00004097          	auipc	ra,0x4
    80002656:	dda080e7          	jalr	-550(ra) # 8000642c <release>
}
    8000265a:	60e2                	ld	ra,24(sp)
    8000265c:	6442                	ld	s0,16(sp)
    8000265e:	64a2                	ld	s1,8(sp)
    80002660:	6902                	ld	s2,0(sp)
    80002662:	6105                	addi	sp,sp,32
    80002664:	8082                	ret
    panic("brelse");
    80002666:	00006517          	auipc	a0,0x6
    8000266a:	e9a50513          	addi	a0,a0,-358 # 80008500 <syscalls+0xf0>
    8000266e:	00003097          	auipc	ra,0x3
    80002672:	764080e7          	jalr	1892(ra) # 80005dd2 <panic>

0000000080002676 <bpin>:

void
bpin(struct buf *b) {
    80002676:	1101                	addi	sp,sp,-32
    80002678:	ec06                	sd	ra,24(sp)
    8000267a:	e822                	sd	s0,16(sp)
    8000267c:	e426                	sd	s1,8(sp)
    8000267e:	1000                	addi	s0,sp,32
    80002680:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002682:	00011517          	auipc	a0,0x11
    80002686:	f3650513          	addi	a0,a0,-202 # 800135b8 <bcache>
    8000268a:	00004097          	auipc	ra,0x4
    8000268e:	cee080e7          	jalr	-786(ra) # 80006378 <acquire>
  b->refcnt++;
    80002692:	40bc                	lw	a5,64(s1)
    80002694:	2785                	addiw	a5,a5,1
    80002696:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002698:	00011517          	auipc	a0,0x11
    8000269c:	f2050513          	addi	a0,a0,-224 # 800135b8 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	d8c080e7          	jalr	-628(ra) # 8000642c <release>
}
    800026a8:	60e2                	ld	ra,24(sp)
    800026aa:	6442                	ld	s0,16(sp)
    800026ac:	64a2                	ld	s1,8(sp)
    800026ae:	6105                	addi	sp,sp,32
    800026b0:	8082                	ret

00000000800026b2 <bunpin>:

void
bunpin(struct buf *b) {
    800026b2:	1101                	addi	sp,sp,-32
    800026b4:	ec06                	sd	ra,24(sp)
    800026b6:	e822                	sd	s0,16(sp)
    800026b8:	e426                	sd	s1,8(sp)
    800026ba:	1000                	addi	s0,sp,32
    800026bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026be:	00011517          	auipc	a0,0x11
    800026c2:	efa50513          	addi	a0,a0,-262 # 800135b8 <bcache>
    800026c6:	00004097          	auipc	ra,0x4
    800026ca:	cb2080e7          	jalr	-846(ra) # 80006378 <acquire>
  b->refcnt--;
    800026ce:	40bc                	lw	a5,64(s1)
    800026d0:	37fd                	addiw	a5,a5,-1
    800026d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026d4:	00011517          	auipc	a0,0x11
    800026d8:	ee450513          	addi	a0,a0,-284 # 800135b8 <bcache>
    800026dc:	00004097          	auipc	ra,0x4
    800026e0:	d50080e7          	jalr	-688(ra) # 8000642c <release>
}
    800026e4:	60e2                	ld	ra,24(sp)
    800026e6:	6442                	ld	s0,16(sp)
    800026e8:	64a2                	ld	s1,8(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret

00000000800026ee <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026ee:	1101                	addi	sp,sp,-32
    800026f0:	ec06                	sd	ra,24(sp)
    800026f2:	e822                	sd	s0,16(sp)
    800026f4:	e426                	sd	s1,8(sp)
    800026f6:	e04a                	sd	s2,0(sp)
    800026f8:	1000                	addi	s0,sp,32
    800026fa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026fc:	00d5d59b          	srliw	a1,a1,0xd
    80002700:	00019797          	auipc	a5,0x19
    80002704:	5947a783          	lw	a5,1428(a5) # 8001bc94 <sb+0x1c>
    80002708:	9dbd                	addw	a1,a1,a5
    8000270a:	00000097          	auipc	ra,0x0
    8000270e:	d9e080e7          	jalr	-610(ra) # 800024a8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002712:	0074f713          	andi	a4,s1,7
    80002716:	4785                	li	a5,1
    80002718:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000271c:	14ce                	slli	s1,s1,0x33
    8000271e:	90d9                	srli	s1,s1,0x36
    80002720:	00950733          	add	a4,a0,s1
    80002724:	05874703          	lbu	a4,88(a4)
    80002728:	00e7f6b3          	and	a3,a5,a4
    8000272c:	c69d                	beqz	a3,8000275a <bfree+0x6c>
    8000272e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002730:	94aa                	add	s1,s1,a0
    80002732:	fff7c793          	not	a5,a5
    80002736:	8ff9                	and	a5,a5,a4
    80002738:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000273c:	00001097          	auipc	ra,0x1
    80002740:	120080e7          	jalr	288(ra) # 8000385c <log_write>
  brelse(bp);
    80002744:	854a                	mv	a0,s2
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	e92080e7          	jalr	-366(ra) # 800025d8 <brelse>
}
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6902                	ld	s2,0(sp)
    80002756:	6105                	addi	sp,sp,32
    80002758:	8082                	ret
    panic("freeing free block");
    8000275a:	00006517          	auipc	a0,0x6
    8000275e:	dae50513          	addi	a0,a0,-594 # 80008508 <syscalls+0xf8>
    80002762:	00003097          	auipc	ra,0x3
    80002766:	670080e7          	jalr	1648(ra) # 80005dd2 <panic>

000000008000276a <balloc>:
{
    8000276a:	711d                	addi	sp,sp,-96
    8000276c:	ec86                	sd	ra,88(sp)
    8000276e:	e8a2                	sd	s0,80(sp)
    80002770:	e4a6                	sd	s1,72(sp)
    80002772:	e0ca                	sd	s2,64(sp)
    80002774:	fc4e                	sd	s3,56(sp)
    80002776:	f852                	sd	s4,48(sp)
    80002778:	f456                	sd	s5,40(sp)
    8000277a:	f05a                	sd	s6,32(sp)
    8000277c:	ec5e                	sd	s7,24(sp)
    8000277e:	e862                	sd	s8,16(sp)
    80002780:	e466                	sd	s9,8(sp)
    80002782:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002784:	00019797          	auipc	a5,0x19
    80002788:	4f87a783          	lw	a5,1272(a5) # 8001bc7c <sb+0x4>
    8000278c:	10078163          	beqz	a5,8000288e <balloc+0x124>
    80002790:	8baa                	mv	s7,a0
    80002792:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002794:	00019b17          	auipc	s6,0x19
    80002798:	4e4b0b13          	addi	s6,s6,1252 # 8001bc78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000279e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027a0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027a2:	6c89                	lui	s9,0x2
    800027a4:	a061                	j	8000282c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027a6:	974a                	add	a4,a4,s2
    800027a8:	8fd5                	or	a5,a5,a3
    800027aa:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800027ae:	854a                	mv	a0,s2
    800027b0:	00001097          	auipc	ra,0x1
    800027b4:	0ac080e7          	jalr	172(ra) # 8000385c <log_write>
        brelse(bp);
    800027b8:	854a                	mv	a0,s2
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	e1e080e7          	jalr	-482(ra) # 800025d8 <brelse>
  bp = bread(dev, bno);
    800027c2:	85a6                	mv	a1,s1
    800027c4:	855e                	mv	a0,s7
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	ce2080e7          	jalr	-798(ra) # 800024a8 <bread>
    800027ce:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027d0:	40000613          	li	a2,1024
    800027d4:	4581                	li	a1,0
    800027d6:	05850513          	addi	a0,a0,88
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	99e080e7          	jalr	-1634(ra) # 80000178 <memset>
  log_write(bp);
    800027e2:	854a                	mv	a0,s2
    800027e4:	00001097          	auipc	ra,0x1
    800027e8:	078080e7          	jalr	120(ra) # 8000385c <log_write>
  brelse(bp);
    800027ec:	854a                	mv	a0,s2
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	dea080e7          	jalr	-534(ra) # 800025d8 <brelse>
}
    800027f6:	8526                	mv	a0,s1
    800027f8:	60e6                	ld	ra,88(sp)
    800027fa:	6446                	ld	s0,80(sp)
    800027fc:	64a6                	ld	s1,72(sp)
    800027fe:	6906                	ld	s2,64(sp)
    80002800:	79e2                	ld	s3,56(sp)
    80002802:	7a42                	ld	s4,48(sp)
    80002804:	7aa2                	ld	s5,40(sp)
    80002806:	7b02                	ld	s6,32(sp)
    80002808:	6be2                	ld	s7,24(sp)
    8000280a:	6c42                	ld	s8,16(sp)
    8000280c:	6ca2                	ld	s9,8(sp)
    8000280e:	6125                	addi	sp,sp,96
    80002810:	8082                	ret
    brelse(bp);
    80002812:	854a                	mv	a0,s2
    80002814:	00000097          	auipc	ra,0x0
    80002818:	dc4080e7          	jalr	-572(ra) # 800025d8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000281c:	015c87bb          	addw	a5,s9,s5
    80002820:	00078a9b          	sext.w	s5,a5
    80002824:	004b2703          	lw	a4,4(s6)
    80002828:	06eaf363          	bgeu	s5,a4,8000288e <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000282c:	41fad79b          	sraiw	a5,s5,0x1f
    80002830:	0137d79b          	srliw	a5,a5,0x13
    80002834:	015787bb          	addw	a5,a5,s5
    80002838:	40d7d79b          	sraiw	a5,a5,0xd
    8000283c:	01cb2583          	lw	a1,28(s6)
    80002840:	9dbd                	addw	a1,a1,a5
    80002842:	855e                	mv	a0,s7
    80002844:	00000097          	auipc	ra,0x0
    80002848:	c64080e7          	jalr	-924(ra) # 800024a8 <bread>
    8000284c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284e:	004b2503          	lw	a0,4(s6)
    80002852:	000a849b          	sext.w	s1,s5
    80002856:	8662                	mv	a2,s8
    80002858:	faa4fde3          	bgeu	s1,a0,80002812 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000285c:	41f6579b          	sraiw	a5,a2,0x1f
    80002860:	01d7d69b          	srliw	a3,a5,0x1d
    80002864:	00c6873b          	addw	a4,a3,a2
    80002868:	00777793          	andi	a5,a4,7
    8000286c:	9f95                	subw	a5,a5,a3
    8000286e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002872:	4037571b          	sraiw	a4,a4,0x3
    80002876:	00e906b3          	add	a3,s2,a4
    8000287a:	0586c683          	lbu	a3,88(a3)
    8000287e:	00d7f5b3          	and	a1,a5,a3
    80002882:	d195                	beqz	a1,800027a6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002884:	2605                	addiw	a2,a2,1
    80002886:	2485                	addiw	s1,s1,1
    80002888:	fd4618e3          	bne	a2,s4,80002858 <balloc+0xee>
    8000288c:	b759                	j	80002812 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000288e:	00006517          	auipc	a0,0x6
    80002892:	c9250513          	addi	a0,a0,-878 # 80008520 <syscalls+0x110>
    80002896:	00003097          	auipc	ra,0x3
    8000289a:	586080e7          	jalr	1414(ra) # 80005e1c <printf>
  return 0;
    8000289e:	4481                	li	s1,0
    800028a0:	bf99                	j	800027f6 <balloc+0x8c>

00000000800028a2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800028a2:	7179                	addi	sp,sp,-48
    800028a4:	f406                	sd	ra,40(sp)
    800028a6:	f022                	sd	s0,32(sp)
    800028a8:	ec26                	sd	s1,24(sp)
    800028aa:	e84a                	sd	s2,16(sp)
    800028ac:	e44e                	sd	s3,8(sp)
    800028ae:	e052                	sd	s4,0(sp)
    800028b0:	1800                	addi	s0,sp,48
    800028b2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028b4:	47ad                	li	a5,11
    800028b6:	02b7e763          	bltu	a5,a1,800028e4 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800028ba:	02059493          	slli	s1,a1,0x20
    800028be:	9081                	srli	s1,s1,0x20
    800028c0:	048a                	slli	s1,s1,0x2
    800028c2:	94aa                	add	s1,s1,a0
    800028c4:	0504a903          	lw	s2,80(s1)
    800028c8:	06091e63          	bnez	s2,80002944 <bmap+0xa2>
      addr = balloc(ip->dev);
    800028cc:	4108                	lw	a0,0(a0)
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	e9c080e7          	jalr	-356(ra) # 8000276a <balloc>
    800028d6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028da:	06090563          	beqz	s2,80002944 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800028de:	0524a823          	sw	s2,80(s1)
    800028e2:	a08d                	j	80002944 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028e4:	ff45849b          	addiw	s1,a1,-12
    800028e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028ec:	0ff00793          	li	a5,255
    800028f0:	08e7e563          	bltu	a5,a4,8000297a <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028f4:	08052903          	lw	s2,128(a0)
    800028f8:	00091d63          	bnez	s2,80002912 <bmap+0x70>
      addr = balloc(ip->dev);
    800028fc:	4108                	lw	a0,0(a0)
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	e6c080e7          	jalr	-404(ra) # 8000276a <balloc>
    80002906:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000290a:	02090d63          	beqz	s2,80002944 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000290e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002912:	85ca                	mv	a1,s2
    80002914:	0009a503          	lw	a0,0(s3)
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	b90080e7          	jalr	-1136(ra) # 800024a8 <bread>
    80002920:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002922:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002926:	02049593          	slli	a1,s1,0x20
    8000292a:	9181                	srli	a1,a1,0x20
    8000292c:	058a                	slli	a1,a1,0x2
    8000292e:	00b784b3          	add	s1,a5,a1
    80002932:	0004a903          	lw	s2,0(s1)
    80002936:	02090063          	beqz	s2,80002956 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000293a:	8552                	mv	a0,s4
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	c9c080e7          	jalr	-868(ra) # 800025d8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002944:	854a                	mv	a0,s2
    80002946:	70a2                	ld	ra,40(sp)
    80002948:	7402                	ld	s0,32(sp)
    8000294a:	64e2                	ld	s1,24(sp)
    8000294c:	6942                	ld	s2,16(sp)
    8000294e:	69a2                	ld	s3,8(sp)
    80002950:	6a02                	ld	s4,0(sp)
    80002952:	6145                	addi	sp,sp,48
    80002954:	8082                	ret
      addr = balloc(ip->dev);
    80002956:	0009a503          	lw	a0,0(s3)
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	e10080e7          	jalr	-496(ra) # 8000276a <balloc>
    80002962:	0005091b          	sext.w	s2,a0
      if(addr){
    80002966:	fc090ae3          	beqz	s2,8000293a <bmap+0x98>
        a[bn] = addr;
    8000296a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000296e:	8552                	mv	a0,s4
    80002970:	00001097          	auipc	ra,0x1
    80002974:	eec080e7          	jalr	-276(ra) # 8000385c <log_write>
    80002978:	b7c9                	j	8000293a <bmap+0x98>
  panic("bmap: out of range");
    8000297a:	00006517          	auipc	a0,0x6
    8000297e:	bbe50513          	addi	a0,a0,-1090 # 80008538 <syscalls+0x128>
    80002982:	00003097          	auipc	ra,0x3
    80002986:	450080e7          	jalr	1104(ra) # 80005dd2 <panic>

000000008000298a <iget>:
{
    8000298a:	7179                	addi	sp,sp,-48
    8000298c:	f406                	sd	ra,40(sp)
    8000298e:	f022                	sd	s0,32(sp)
    80002990:	ec26                	sd	s1,24(sp)
    80002992:	e84a                	sd	s2,16(sp)
    80002994:	e44e                	sd	s3,8(sp)
    80002996:	e052                	sd	s4,0(sp)
    80002998:	1800                	addi	s0,sp,48
    8000299a:	89aa                	mv	s3,a0
    8000299c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000299e:	00019517          	auipc	a0,0x19
    800029a2:	2fa50513          	addi	a0,a0,762 # 8001bc98 <itable>
    800029a6:	00004097          	auipc	ra,0x4
    800029aa:	9d2080e7          	jalr	-1582(ra) # 80006378 <acquire>
  empty = 0;
    800029ae:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029b0:	00019497          	auipc	s1,0x19
    800029b4:	30048493          	addi	s1,s1,768 # 8001bcb0 <itable+0x18>
    800029b8:	0001b697          	auipc	a3,0x1b
    800029bc:	d8868693          	addi	a3,a3,-632 # 8001d740 <log>
    800029c0:	a039                	j	800029ce <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029c2:	02090b63          	beqz	s2,800029f8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029c6:	08848493          	addi	s1,s1,136
    800029ca:	02d48a63          	beq	s1,a3,800029fe <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029ce:	449c                	lw	a5,8(s1)
    800029d0:	fef059e3          	blez	a5,800029c2 <iget+0x38>
    800029d4:	4098                	lw	a4,0(s1)
    800029d6:	ff3716e3          	bne	a4,s3,800029c2 <iget+0x38>
    800029da:	40d8                	lw	a4,4(s1)
    800029dc:	ff4713e3          	bne	a4,s4,800029c2 <iget+0x38>
      ip->ref++;
    800029e0:	2785                	addiw	a5,a5,1
    800029e2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029e4:	00019517          	auipc	a0,0x19
    800029e8:	2b450513          	addi	a0,a0,692 # 8001bc98 <itable>
    800029ec:	00004097          	auipc	ra,0x4
    800029f0:	a40080e7          	jalr	-1472(ra) # 8000642c <release>
      return ip;
    800029f4:	8926                	mv	s2,s1
    800029f6:	a03d                	j	80002a24 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029f8:	f7f9                	bnez	a5,800029c6 <iget+0x3c>
    800029fa:	8926                	mv	s2,s1
    800029fc:	b7e9                	j	800029c6 <iget+0x3c>
  if(empty == 0)
    800029fe:	02090c63          	beqz	s2,80002a36 <iget+0xac>
  ip->dev = dev;
    80002a02:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a06:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a0a:	4785                	li	a5,1
    80002a0c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a10:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a14:	00019517          	auipc	a0,0x19
    80002a18:	28450513          	addi	a0,a0,644 # 8001bc98 <itable>
    80002a1c:	00004097          	auipc	ra,0x4
    80002a20:	a10080e7          	jalr	-1520(ra) # 8000642c <release>
}
    80002a24:	854a                	mv	a0,s2
    80002a26:	70a2                	ld	ra,40(sp)
    80002a28:	7402                	ld	s0,32(sp)
    80002a2a:	64e2                	ld	s1,24(sp)
    80002a2c:	6942                	ld	s2,16(sp)
    80002a2e:	69a2                	ld	s3,8(sp)
    80002a30:	6a02                	ld	s4,0(sp)
    80002a32:	6145                	addi	sp,sp,48
    80002a34:	8082                	ret
    panic("iget: no inodes");
    80002a36:	00006517          	auipc	a0,0x6
    80002a3a:	b1a50513          	addi	a0,a0,-1254 # 80008550 <syscalls+0x140>
    80002a3e:	00003097          	auipc	ra,0x3
    80002a42:	394080e7          	jalr	916(ra) # 80005dd2 <panic>

0000000080002a46 <fsinit>:
fsinit(int dev) {
    80002a46:	7179                	addi	sp,sp,-48
    80002a48:	f406                	sd	ra,40(sp)
    80002a4a:	f022                	sd	s0,32(sp)
    80002a4c:	ec26                	sd	s1,24(sp)
    80002a4e:	e84a                	sd	s2,16(sp)
    80002a50:	e44e                	sd	s3,8(sp)
    80002a52:	1800                	addi	s0,sp,48
    80002a54:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a56:	4585                	li	a1,1
    80002a58:	00000097          	auipc	ra,0x0
    80002a5c:	a50080e7          	jalr	-1456(ra) # 800024a8 <bread>
    80002a60:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a62:	00019997          	auipc	s3,0x19
    80002a66:	21698993          	addi	s3,s3,534 # 8001bc78 <sb>
    80002a6a:	02000613          	li	a2,32
    80002a6e:	05850593          	addi	a1,a0,88
    80002a72:	854e                	mv	a0,s3
    80002a74:	ffffd097          	auipc	ra,0xffffd
    80002a78:	764080e7          	jalr	1892(ra) # 800001d8 <memmove>
  brelse(bp);
    80002a7c:	8526                	mv	a0,s1
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	b5a080e7          	jalr	-1190(ra) # 800025d8 <brelse>
  if(sb.magic != FSMAGIC)
    80002a86:	0009a703          	lw	a4,0(s3)
    80002a8a:	102037b7          	lui	a5,0x10203
    80002a8e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a92:	02f71263          	bne	a4,a5,80002ab6 <fsinit+0x70>
  initlog(dev, &sb);
    80002a96:	00019597          	auipc	a1,0x19
    80002a9a:	1e258593          	addi	a1,a1,482 # 8001bc78 <sb>
    80002a9e:	854a                	mv	a0,s2
    80002aa0:	00001097          	auipc	ra,0x1
    80002aa4:	b40080e7          	jalr	-1216(ra) # 800035e0 <initlog>
}
    80002aa8:	70a2                	ld	ra,40(sp)
    80002aaa:	7402                	ld	s0,32(sp)
    80002aac:	64e2                	ld	s1,24(sp)
    80002aae:	6942                	ld	s2,16(sp)
    80002ab0:	69a2                	ld	s3,8(sp)
    80002ab2:	6145                	addi	sp,sp,48
    80002ab4:	8082                	ret
    panic("invalid file system");
    80002ab6:	00006517          	auipc	a0,0x6
    80002aba:	aaa50513          	addi	a0,a0,-1366 # 80008560 <syscalls+0x150>
    80002abe:	00003097          	auipc	ra,0x3
    80002ac2:	314080e7          	jalr	788(ra) # 80005dd2 <panic>

0000000080002ac6 <iinit>:
{
    80002ac6:	7179                	addi	sp,sp,-48
    80002ac8:	f406                	sd	ra,40(sp)
    80002aca:	f022                	sd	s0,32(sp)
    80002acc:	ec26                	sd	s1,24(sp)
    80002ace:	e84a                	sd	s2,16(sp)
    80002ad0:	e44e                	sd	s3,8(sp)
    80002ad2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ad4:	00006597          	auipc	a1,0x6
    80002ad8:	aa458593          	addi	a1,a1,-1372 # 80008578 <syscalls+0x168>
    80002adc:	00019517          	auipc	a0,0x19
    80002ae0:	1bc50513          	addi	a0,a0,444 # 8001bc98 <itable>
    80002ae4:	00004097          	auipc	ra,0x4
    80002ae8:	804080e7          	jalr	-2044(ra) # 800062e8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aec:	00019497          	auipc	s1,0x19
    80002af0:	1d448493          	addi	s1,s1,468 # 8001bcc0 <itable+0x28>
    80002af4:	0001b997          	auipc	s3,0x1b
    80002af8:	c5c98993          	addi	s3,s3,-932 # 8001d750 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002afc:	00006917          	auipc	s2,0x6
    80002b00:	a8490913          	addi	s2,s2,-1404 # 80008580 <syscalls+0x170>
    80002b04:	85ca                	mv	a1,s2
    80002b06:	8526                	mv	a0,s1
    80002b08:	00001097          	auipc	ra,0x1
    80002b0c:	e3a080e7          	jalr	-454(ra) # 80003942 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b10:	08848493          	addi	s1,s1,136
    80002b14:	ff3498e3          	bne	s1,s3,80002b04 <iinit+0x3e>
}
    80002b18:	70a2                	ld	ra,40(sp)
    80002b1a:	7402                	ld	s0,32(sp)
    80002b1c:	64e2                	ld	s1,24(sp)
    80002b1e:	6942                	ld	s2,16(sp)
    80002b20:	69a2                	ld	s3,8(sp)
    80002b22:	6145                	addi	sp,sp,48
    80002b24:	8082                	ret

0000000080002b26 <ialloc>:
{
    80002b26:	715d                	addi	sp,sp,-80
    80002b28:	e486                	sd	ra,72(sp)
    80002b2a:	e0a2                	sd	s0,64(sp)
    80002b2c:	fc26                	sd	s1,56(sp)
    80002b2e:	f84a                	sd	s2,48(sp)
    80002b30:	f44e                	sd	s3,40(sp)
    80002b32:	f052                	sd	s4,32(sp)
    80002b34:	ec56                	sd	s5,24(sp)
    80002b36:	e85a                	sd	s6,16(sp)
    80002b38:	e45e                	sd	s7,8(sp)
    80002b3a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b3c:	00019717          	auipc	a4,0x19
    80002b40:	14872703          	lw	a4,328(a4) # 8001bc84 <sb+0xc>
    80002b44:	4785                	li	a5,1
    80002b46:	04e7fa63          	bgeu	a5,a4,80002b9a <ialloc+0x74>
    80002b4a:	8aaa                	mv	s5,a0
    80002b4c:	8bae                	mv	s7,a1
    80002b4e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b50:	00019a17          	auipc	s4,0x19
    80002b54:	128a0a13          	addi	s4,s4,296 # 8001bc78 <sb>
    80002b58:	00048b1b          	sext.w	s6,s1
    80002b5c:	0044d593          	srli	a1,s1,0x4
    80002b60:	018a2783          	lw	a5,24(s4)
    80002b64:	9dbd                	addw	a1,a1,a5
    80002b66:	8556                	mv	a0,s5
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	940080e7          	jalr	-1728(ra) # 800024a8 <bread>
    80002b70:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b72:	05850993          	addi	s3,a0,88
    80002b76:	00f4f793          	andi	a5,s1,15
    80002b7a:	079a                	slli	a5,a5,0x6
    80002b7c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b7e:	00099783          	lh	a5,0(s3)
    80002b82:	c3a1                	beqz	a5,80002bc2 <ialloc+0x9c>
    brelse(bp);
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	a54080e7          	jalr	-1452(ra) # 800025d8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b8c:	0485                	addi	s1,s1,1
    80002b8e:	00ca2703          	lw	a4,12(s4)
    80002b92:	0004879b          	sext.w	a5,s1
    80002b96:	fce7e1e3          	bltu	a5,a4,80002b58 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b9a:	00006517          	auipc	a0,0x6
    80002b9e:	9ee50513          	addi	a0,a0,-1554 # 80008588 <syscalls+0x178>
    80002ba2:	00003097          	auipc	ra,0x3
    80002ba6:	27a080e7          	jalr	634(ra) # 80005e1c <printf>
  return 0;
    80002baa:	4501                	li	a0,0
}
    80002bac:	60a6                	ld	ra,72(sp)
    80002bae:	6406                	ld	s0,64(sp)
    80002bb0:	74e2                	ld	s1,56(sp)
    80002bb2:	7942                	ld	s2,48(sp)
    80002bb4:	79a2                	ld	s3,40(sp)
    80002bb6:	7a02                	ld	s4,32(sp)
    80002bb8:	6ae2                	ld	s5,24(sp)
    80002bba:	6b42                	ld	s6,16(sp)
    80002bbc:	6ba2                	ld	s7,8(sp)
    80002bbe:	6161                	addi	sp,sp,80
    80002bc0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002bc2:	04000613          	li	a2,64
    80002bc6:	4581                	li	a1,0
    80002bc8:	854e                	mv	a0,s3
    80002bca:	ffffd097          	auipc	ra,0xffffd
    80002bce:	5ae080e7          	jalr	1454(ra) # 80000178 <memset>
      dip->type = type;
    80002bd2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	c84080e7          	jalr	-892(ra) # 8000385c <log_write>
      brelse(bp);
    80002be0:	854a                	mv	a0,s2
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	9f6080e7          	jalr	-1546(ra) # 800025d8 <brelse>
      return iget(dev, inum);
    80002bea:	85da                	mv	a1,s6
    80002bec:	8556                	mv	a0,s5
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	d9c080e7          	jalr	-612(ra) # 8000298a <iget>
    80002bf6:	bf5d                	j	80002bac <ialloc+0x86>

0000000080002bf8 <iupdate>:
{
    80002bf8:	1101                	addi	sp,sp,-32
    80002bfa:	ec06                	sd	ra,24(sp)
    80002bfc:	e822                	sd	s0,16(sp)
    80002bfe:	e426                	sd	s1,8(sp)
    80002c00:	e04a                	sd	s2,0(sp)
    80002c02:	1000                	addi	s0,sp,32
    80002c04:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c06:	415c                	lw	a5,4(a0)
    80002c08:	0047d79b          	srliw	a5,a5,0x4
    80002c0c:	00019597          	auipc	a1,0x19
    80002c10:	0845a583          	lw	a1,132(a1) # 8001bc90 <sb+0x18>
    80002c14:	9dbd                	addw	a1,a1,a5
    80002c16:	4108                	lw	a0,0(a0)
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	890080e7          	jalr	-1904(ra) # 800024a8 <bread>
    80002c20:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c22:	05850793          	addi	a5,a0,88
    80002c26:	40c8                	lw	a0,4(s1)
    80002c28:	893d                	andi	a0,a0,15
    80002c2a:	051a                	slli	a0,a0,0x6
    80002c2c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c2e:	04449703          	lh	a4,68(s1)
    80002c32:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c36:	04649703          	lh	a4,70(s1)
    80002c3a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c3e:	04849703          	lh	a4,72(s1)
    80002c42:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c46:	04a49703          	lh	a4,74(s1)
    80002c4a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c4e:	44f8                	lw	a4,76(s1)
    80002c50:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c52:	03400613          	li	a2,52
    80002c56:	05048593          	addi	a1,s1,80
    80002c5a:	0531                	addi	a0,a0,12
    80002c5c:	ffffd097          	auipc	ra,0xffffd
    80002c60:	57c080e7          	jalr	1404(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c64:	854a                	mv	a0,s2
    80002c66:	00001097          	auipc	ra,0x1
    80002c6a:	bf6080e7          	jalr	-1034(ra) # 8000385c <log_write>
  brelse(bp);
    80002c6e:	854a                	mv	a0,s2
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	968080e7          	jalr	-1688(ra) # 800025d8 <brelse>
}
    80002c78:	60e2                	ld	ra,24(sp)
    80002c7a:	6442                	ld	s0,16(sp)
    80002c7c:	64a2                	ld	s1,8(sp)
    80002c7e:	6902                	ld	s2,0(sp)
    80002c80:	6105                	addi	sp,sp,32
    80002c82:	8082                	ret

0000000080002c84 <idup>:
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	e426                	sd	s1,8(sp)
    80002c8c:	1000                	addi	s0,sp,32
    80002c8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c90:	00019517          	auipc	a0,0x19
    80002c94:	00850513          	addi	a0,a0,8 # 8001bc98 <itable>
    80002c98:	00003097          	auipc	ra,0x3
    80002c9c:	6e0080e7          	jalr	1760(ra) # 80006378 <acquire>
  ip->ref++;
    80002ca0:	449c                	lw	a5,8(s1)
    80002ca2:	2785                	addiw	a5,a5,1
    80002ca4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ca6:	00019517          	auipc	a0,0x19
    80002caa:	ff250513          	addi	a0,a0,-14 # 8001bc98 <itable>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	77e080e7          	jalr	1918(ra) # 8000642c <release>
}
    80002cb6:	8526                	mv	a0,s1
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret

0000000080002cc2 <ilock>:
{
    80002cc2:	1101                	addi	sp,sp,-32
    80002cc4:	ec06                	sd	ra,24(sp)
    80002cc6:	e822                	sd	s0,16(sp)
    80002cc8:	e426                	sd	s1,8(sp)
    80002cca:	e04a                	sd	s2,0(sp)
    80002ccc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cce:	c115                	beqz	a0,80002cf2 <ilock+0x30>
    80002cd0:	84aa                	mv	s1,a0
    80002cd2:	451c                	lw	a5,8(a0)
    80002cd4:	00f05f63          	blez	a5,80002cf2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cd8:	0541                	addi	a0,a0,16
    80002cda:	00001097          	auipc	ra,0x1
    80002cde:	ca2080e7          	jalr	-862(ra) # 8000397c <acquiresleep>
  if(ip->valid == 0){
    80002ce2:	40bc                	lw	a5,64(s1)
    80002ce4:	cf99                	beqz	a5,80002d02 <ilock+0x40>
}
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6902                	ld	s2,0(sp)
    80002cee:	6105                	addi	sp,sp,32
    80002cf0:	8082                	ret
    panic("ilock");
    80002cf2:	00006517          	auipc	a0,0x6
    80002cf6:	8ae50513          	addi	a0,a0,-1874 # 800085a0 <syscalls+0x190>
    80002cfa:	00003097          	auipc	ra,0x3
    80002cfe:	0d8080e7          	jalr	216(ra) # 80005dd2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d02:	40dc                	lw	a5,4(s1)
    80002d04:	0047d79b          	srliw	a5,a5,0x4
    80002d08:	00019597          	auipc	a1,0x19
    80002d0c:	f885a583          	lw	a1,-120(a1) # 8001bc90 <sb+0x18>
    80002d10:	9dbd                	addw	a1,a1,a5
    80002d12:	4088                	lw	a0,0(s1)
    80002d14:	fffff097          	auipc	ra,0xfffff
    80002d18:	794080e7          	jalr	1940(ra) # 800024a8 <bread>
    80002d1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d1e:	05850593          	addi	a1,a0,88
    80002d22:	40dc                	lw	a5,4(s1)
    80002d24:	8bbd                	andi	a5,a5,15
    80002d26:	079a                	slli	a5,a5,0x6
    80002d28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d2a:	00059783          	lh	a5,0(a1)
    80002d2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d32:	00259783          	lh	a5,2(a1)
    80002d36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d3a:	00459783          	lh	a5,4(a1)
    80002d3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d42:	00659783          	lh	a5,6(a1)
    80002d46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d4a:	459c                	lw	a5,8(a1)
    80002d4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d4e:	03400613          	li	a2,52
    80002d52:	05b1                	addi	a1,a1,12
    80002d54:	05048513          	addi	a0,s1,80
    80002d58:	ffffd097          	auipc	ra,0xffffd
    80002d5c:	480080e7          	jalr	1152(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d60:	854a                	mv	a0,s2
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	876080e7          	jalr	-1930(ra) # 800025d8 <brelse>
    ip->valid = 1;
    80002d6a:	4785                	li	a5,1
    80002d6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d6e:	04449783          	lh	a5,68(s1)
    80002d72:	fbb5                	bnez	a5,80002ce6 <ilock+0x24>
      panic("ilock: no type");
    80002d74:	00006517          	auipc	a0,0x6
    80002d78:	83450513          	addi	a0,a0,-1996 # 800085a8 <syscalls+0x198>
    80002d7c:	00003097          	auipc	ra,0x3
    80002d80:	056080e7          	jalr	86(ra) # 80005dd2 <panic>

0000000080002d84 <iunlock>:
{
    80002d84:	1101                	addi	sp,sp,-32
    80002d86:	ec06                	sd	ra,24(sp)
    80002d88:	e822                	sd	s0,16(sp)
    80002d8a:	e426                	sd	s1,8(sp)
    80002d8c:	e04a                	sd	s2,0(sp)
    80002d8e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d90:	c905                	beqz	a0,80002dc0 <iunlock+0x3c>
    80002d92:	84aa                	mv	s1,a0
    80002d94:	01050913          	addi	s2,a0,16
    80002d98:	854a                	mv	a0,s2
    80002d9a:	00001097          	auipc	ra,0x1
    80002d9e:	c7e080e7          	jalr	-898(ra) # 80003a18 <holdingsleep>
    80002da2:	cd19                	beqz	a0,80002dc0 <iunlock+0x3c>
    80002da4:	449c                	lw	a5,8(s1)
    80002da6:	00f05d63          	blez	a5,80002dc0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002daa:	854a                	mv	a0,s2
    80002dac:	00001097          	auipc	ra,0x1
    80002db0:	c28080e7          	jalr	-984(ra) # 800039d4 <releasesleep>
}
    80002db4:	60e2                	ld	ra,24(sp)
    80002db6:	6442                	ld	s0,16(sp)
    80002db8:	64a2                	ld	s1,8(sp)
    80002dba:	6902                	ld	s2,0(sp)
    80002dbc:	6105                	addi	sp,sp,32
    80002dbe:	8082                	ret
    panic("iunlock");
    80002dc0:	00005517          	auipc	a0,0x5
    80002dc4:	7f850513          	addi	a0,a0,2040 # 800085b8 <syscalls+0x1a8>
    80002dc8:	00003097          	auipc	ra,0x3
    80002dcc:	00a080e7          	jalr	10(ra) # 80005dd2 <panic>

0000000080002dd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dd0:	7179                	addi	sp,sp,-48
    80002dd2:	f406                	sd	ra,40(sp)
    80002dd4:	f022                	sd	s0,32(sp)
    80002dd6:	ec26                	sd	s1,24(sp)
    80002dd8:	e84a                	sd	s2,16(sp)
    80002dda:	e44e                	sd	s3,8(sp)
    80002ddc:	e052                	sd	s4,0(sp)
    80002dde:	1800                	addi	s0,sp,48
    80002de0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002de2:	05050493          	addi	s1,a0,80
    80002de6:	08050913          	addi	s2,a0,128
    80002dea:	a021                	j	80002df2 <itrunc+0x22>
    80002dec:	0491                	addi	s1,s1,4
    80002dee:	01248d63          	beq	s1,s2,80002e08 <itrunc+0x38>
    if(ip->addrs[i]){
    80002df2:	408c                	lw	a1,0(s1)
    80002df4:	dde5                	beqz	a1,80002dec <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002df6:	0009a503          	lw	a0,0(s3)
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	8f4080e7          	jalr	-1804(ra) # 800026ee <bfree>
      ip->addrs[i] = 0;
    80002e02:	0004a023          	sw	zero,0(s1)
    80002e06:	b7dd                	j	80002dec <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e08:	0809a583          	lw	a1,128(s3)
    80002e0c:	e185                	bnez	a1,80002e2c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e0e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e12:	854e                	mv	a0,s3
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	de4080e7          	jalr	-540(ra) # 80002bf8 <iupdate>
}
    80002e1c:	70a2                	ld	ra,40(sp)
    80002e1e:	7402                	ld	s0,32(sp)
    80002e20:	64e2                	ld	s1,24(sp)
    80002e22:	6942                	ld	s2,16(sp)
    80002e24:	69a2                	ld	s3,8(sp)
    80002e26:	6a02                	ld	s4,0(sp)
    80002e28:	6145                	addi	sp,sp,48
    80002e2a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e2c:	0009a503          	lw	a0,0(s3)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	678080e7          	jalr	1656(ra) # 800024a8 <bread>
    80002e38:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e3a:	05850493          	addi	s1,a0,88
    80002e3e:	45850913          	addi	s2,a0,1112
    80002e42:	a811                	j	80002e56 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e44:	0009a503          	lw	a0,0(s3)
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	8a6080e7          	jalr	-1882(ra) # 800026ee <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e50:	0491                	addi	s1,s1,4
    80002e52:	01248563          	beq	s1,s2,80002e5c <itrunc+0x8c>
      if(a[j])
    80002e56:	408c                	lw	a1,0(s1)
    80002e58:	dde5                	beqz	a1,80002e50 <itrunc+0x80>
    80002e5a:	b7ed                	j	80002e44 <itrunc+0x74>
    brelse(bp);
    80002e5c:	8552                	mv	a0,s4
    80002e5e:	fffff097          	auipc	ra,0xfffff
    80002e62:	77a080e7          	jalr	1914(ra) # 800025d8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e66:	0809a583          	lw	a1,128(s3)
    80002e6a:	0009a503          	lw	a0,0(s3)
    80002e6e:	00000097          	auipc	ra,0x0
    80002e72:	880080e7          	jalr	-1920(ra) # 800026ee <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e76:	0809a023          	sw	zero,128(s3)
    80002e7a:	bf51                	j	80002e0e <itrunc+0x3e>

0000000080002e7c <iput>:
{
    80002e7c:	1101                	addi	sp,sp,-32
    80002e7e:	ec06                	sd	ra,24(sp)
    80002e80:	e822                	sd	s0,16(sp)
    80002e82:	e426                	sd	s1,8(sp)
    80002e84:	e04a                	sd	s2,0(sp)
    80002e86:	1000                	addi	s0,sp,32
    80002e88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e8a:	00019517          	auipc	a0,0x19
    80002e8e:	e0e50513          	addi	a0,a0,-498 # 8001bc98 <itable>
    80002e92:	00003097          	auipc	ra,0x3
    80002e96:	4e6080e7          	jalr	1254(ra) # 80006378 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e9a:	4498                	lw	a4,8(s1)
    80002e9c:	4785                	li	a5,1
    80002e9e:	02f70363          	beq	a4,a5,80002ec4 <iput+0x48>
  ip->ref--;
    80002ea2:	449c                	lw	a5,8(s1)
    80002ea4:	37fd                	addiw	a5,a5,-1
    80002ea6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ea8:	00019517          	auipc	a0,0x19
    80002eac:	df050513          	addi	a0,a0,-528 # 8001bc98 <itable>
    80002eb0:	00003097          	auipc	ra,0x3
    80002eb4:	57c080e7          	jalr	1404(ra) # 8000642c <release>
}
    80002eb8:	60e2                	ld	ra,24(sp)
    80002eba:	6442                	ld	s0,16(sp)
    80002ebc:	64a2                	ld	s1,8(sp)
    80002ebe:	6902                	ld	s2,0(sp)
    80002ec0:	6105                	addi	sp,sp,32
    80002ec2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ec4:	40bc                	lw	a5,64(s1)
    80002ec6:	dff1                	beqz	a5,80002ea2 <iput+0x26>
    80002ec8:	04a49783          	lh	a5,74(s1)
    80002ecc:	fbf9                	bnez	a5,80002ea2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ece:	01048913          	addi	s2,s1,16
    80002ed2:	854a                	mv	a0,s2
    80002ed4:	00001097          	auipc	ra,0x1
    80002ed8:	aa8080e7          	jalr	-1368(ra) # 8000397c <acquiresleep>
    release(&itable.lock);
    80002edc:	00019517          	auipc	a0,0x19
    80002ee0:	dbc50513          	addi	a0,a0,-580 # 8001bc98 <itable>
    80002ee4:	00003097          	auipc	ra,0x3
    80002ee8:	548080e7          	jalr	1352(ra) # 8000642c <release>
    itrunc(ip);
    80002eec:	8526                	mv	a0,s1
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	ee2080e7          	jalr	-286(ra) # 80002dd0 <itrunc>
    ip->type = 0;
    80002ef6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002efa:	8526                	mv	a0,s1
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	cfc080e7          	jalr	-772(ra) # 80002bf8 <iupdate>
    ip->valid = 0;
    80002f04:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f08:	854a                	mv	a0,s2
    80002f0a:	00001097          	auipc	ra,0x1
    80002f0e:	aca080e7          	jalr	-1334(ra) # 800039d4 <releasesleep>
    acquire(&itable.lock);
    80002f12:	00019517          	auipc	a0,0x19
    80002f16:	d8650513          	addi	a0,a0,-634 # 8001bc98 <itable>
    80002f1a:	00003097          	auipc	ra,0x3
    80002f1e:	45e080e7          	jalr	1118(ra) # 80006378 <acquire>
    80002f22:	b741                	j	80002ea2 <iput+0x26>

0000000080002f24 <iunlockput>:
{
    80002f24:	1101                	addi	sp,sp,-32
    80002f26:	ec06                	sd	ra,24(sp)
    80002f28:	e822                	sd	s0,16(sp)
    80002f2a:	e426                	sd	s1,8(sp)
    80002f2c:	1000                	addi	s0,sp,32
    80002f2e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	e54080e7          	jalr	-428(ra) # 80002d84 <iunlock>
  iput(ip);
    80002f38:	8526                	mv	a0,s1
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	f42080e7          	jalr	-190(ra) # 80002e7c <iput>
}
    80002f42:	60e2                	ld	ra,24(sp)
    80002f44:	6442                	ld	s0,16(sp)
    80002f46:	64a2                	ld	s1,8(sp)
    80002f48:	6105                	addi	sp,sp,32
    80002f4a:	8082                	ret

0000000080002f4c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f4c:	1141                	addi	sp,sp,-16
    80002f4e:	e422                	sd	s0,8(sp)
    80002f50:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f52:	411c                	lw	a5,0(a0)
    80002f54:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f56:	415c                	lw	a5,4(a0)
    80002f58:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f5a:	04451783          	lh	a5,68(a0)
    80002f5e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f62:	04a51783          	lh	a5,74(a0)
    80002f66:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f6a:	04c56783          	lwu	a5,76(a0)
    80002f6e:	e99c                	sd	a5,16(a1)
}
    80002f70:	6422                	ld	s0,8(sp)
    80002f72:	0141                	addi	sp,sp,16
    80002f74:	8082                	ret

0000000080002f76 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f76:	457c                	lw	a5,76(a0)
    80002f78:	0ed7e963          	bltu	a5,a3,8000306a <readi+0xf4>
{
    80002f7c:	7159                	addi	sp,sp,-112
    80002f7e:	f486                	sd	ra,104(sp)
    80002f80:	f0a2                	sd	s0,96(sp)
    80002f82:	eca6                	sd	s1,88(sp)
    80002f84:	e8ca                	sd	s2,80(sp)
    80002f86:	e4ce                	sd	s3,72(sp)
    80002f88:	e0d2                	sd	s4,64(sp)
    80002f8a:	fc56                	sd	s5,56(sp)
    80002f8c:	f85a                	sd	s6,48(sp)
    80002f8e:	f45e                	sd	s7,40(sp)
    80002f90:	f062                	sd	s8,32(sp)
    80002f92:	ec66                	sd	s9,24(sp)
    80002f94:	e86a                	sd	s10,16(sp)
    80002f96:	e46e                	sd	s11,8(sp)
    80002f98:	1880                	addi	s0,sp,112
    80002f9a:	8b2a                	mv	s6,a0
    80002f9c:	8bae                	mv	s7,a1
    80002f9e:	8a32                	mv	s4,a2
    80002fa0:	84b6                	mv	s1,a3
    80002fa2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002fa4:	9f35                	addw	a4,a4,a3
    return 0;
    80002fa6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fa8:	0ad76063          	bltu	a4,a3,80003048 <readi+0xd2>
  if(off + n > ip->size)
    80002fac:	00e7f463          	bgeu	a5,a4,80002fb4 <readi+0x3e>
    n = ip->size - off;
    80002fb0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb4:	0a0a8963          	beqz	s5,80003066 <readi+0xf0>
    80002fb8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fbe:	5c7d                	li	s8,-1
    80002fc0:	a82d                	j	80002ffa <readi+0x84>
    80002fc2:	020d1d93          	slli	s11,s10,0x20
    80002fc6:	020ddd93          	srli	s11,s11,0x20
    80002fca:	05890613          	addi	a2,s2,88
    80002fce:	86ee                	mv	a3,s11
    80002fd0:	963a                	add	a2,a2,a4
    80002fd2:	85d2                	mv	a1,s4
    80002fd4:	855e                	mv	a0,s7
    80002fd6:	fffff097          	auipc	ra,0xfffff
    80002fda:	9d4080e7          	jalr	-1580(ra) # 800019aa <either_copyout>
    80002fde:	05850d63          	beq	a0,s8,80003038 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	5f4080e7          	jalr	1524(ra) # 800025d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fec:	013d09bb          	addw	s3,s10,s3
    80002ff0:	009d04bb          	addw	s1,s10,s1
    80002ff4:	9a6e                	add	s4,s4,s11
    80002ff6:	0559f763          	bgeu	s3,s5,80003044 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ffa:	00a4d59b          	srliw	a1,s1,0xa
    80002ffe:	855a                	mv	a0,s6
    80003000:	00000097          	auipc	ra,0x0
    80003004:	8a2080e7          	jalr	-1886(ra) # 800028a2 <bmap>
    80003008:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000300c:	cd85                	beqz	a1,80003044 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000300e:	000b2503          	lw	a0,0(s6)
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	496080e7          	jalr	1174(ra) # 800024a8 <bread>
    8000301a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301c:	3ff4f713          	andi	a4,s1,1023
    80003020:	40ec87bb          	subw	a5,s9,a4
    80003024:	413a86bb          	subw	a3,s5,s3
    80003028:	8d3e                	mv	s10,a5
    8000302a:	2781                	sext.w	a5,a5
    8000302c:	0006861b          	sext.w	a2,a3
    80003030:	f8f679e3          	bgeu	a2,a5,80002fc2 <readi+0x4c>
    80003034:	8d36                	mv	s10,a3
    80003036:	b771                	j	80002fc2 <readi+0x4c>
      brelse(bp);
    80003038:	854a                	mv	a0,s2
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	59e080e7          	jalr	1438(ra) # 800025d8 <brelse>
      tot = -1;
    80003042:	59fd                	li	s3,-1
  }
  return tot;
    80003044:	0009851b          	sext.w	a0,s3
}
    80003048:	70a6                	ld	ra,104(sp)
    8000304a:	7406                	ld	s0,96(sp)
    8000304c:	64e6                	ld	s1,88(sp)
    8000304e:	6946                	ld	s2,80(sp)
    80003050:	69a6                	ld	s3,72(sp)
    80003052:	6a06                	ld	s4,64(sp)
    80003054:	7ae2                	ld	s5,56(sp)
    80003056:	7b42                	ld	s6,48(sp)
    80003058:	7ba2                	ld	s7,40(sp)
    8000305a:	7c02                	ld	s8,32(sp)
    8000305c:	6ce2                	ld	s9,24(sp)
    8000305e:	6d42                	ld	s10,16(sp)
    80003060:	6da2                	ld	s11,8(sp)
    80003062:	6165                	addi	sp,sp,112
    80003064:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003066:	89d6                	mv	s3,s5
    80003068:	bff1                	j	80003044 <readi+0xce>
    return 0;
    8000306a:	4501                	li	a0,0
}
    8000306c:	8082                	ret

000000008000306e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000306e:	457c                	lw	a5,76(a0)
    80003070:	10d7e863          	bltu	a5,a3,80003180 <writei+0x112>
{
    80003074:	7159                	addi	sp,sp,-112
    80003076:	f486                	sd	ra,104(sp)
    80003078:	f0a2                	sd	s0,96(sp)
    8000307a:	eca6                	sd	s1,88(sp)
    8000307c:	e8ca                	sd	s2,80(sp)
    8000307e:	e4ce                	sd	s3,72(sp)
    80003080:	e0d2                	sd	s4,64(sp)
    80003082:	fc56                	sd	s5,56(sp)
    80003084:	f85a                	sd	s6,48(sp)
    80003086:	f45e                	sd	s7,40(sp)
    80003088:	f062                	sd	s8,32(sp)
    8000308a:	ec66                	sd	s9,24(sp)
    8000308c:	e86a                	sd	s10,16(sp)
    8000308e:	e46e                	sd	s11,8(sp)
    80003090:	1880                	addi	s0,sp,112
    80003092:	8aaa                	mv	s5,a0
    80003094:	8bae                	mv	s7,a1
    80003096:	8a32                	mv	s4,a2
    80003098:	8936                	mv	s2,a3
    8000309a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000309c:	00e687bb          	addw	a5,a3,a4
    800030a0:	0ed7e263          	bltu	a5,a3,80003184 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030a4:	00043737          	lui	a4,0x43
    800030a8:	0ef76063          	bltu	a4,a5,80003188 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ac:	0c0b0863          	beqz	s6,8000317c <writei+0x10e>
    800030b0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030b6:	5c7d                	li	s8,-1
    800030b8:	a091                	j	800030fc <writei+0x8e>
    800030ba:	020d1d93          	slli	s11,s10,0x20
    800030be:	020ddd93          	srli	s11,s11,0x20
    800030c2:	05848513          	addi	a0,s1,88
    800030c6:	86ee                	mv	a3,s11
    800030c8:	8652                	mv	a2,s4
    800030ca:	85de                	mv	a1,s7
    800030cc:	953a                	add	a0,a0,a4
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	934080e7          	jalr	-1740(ra) # 80001a02 <either_copyin>
    800030d6:	07850263          	beq	a0,s8,8000313a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030da:	8526                	mv	a0,s1
    800030dc:	00000097          	auipc	ra,0x0
    800030e0:	780080e7          	jalr	1920(ra) # 8000385c <log_write>
    brelse(bp);
    800030e4:	8526                	mv	a0,s1
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	4f2080e7          	jalr	1266(ra) # 800025d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ee:	013d09bb          	addw	s3,s10,s3
    800030f2:	012d093b          	addw	s2,s10,s2
    800030f6:	9a6e                	add	s4,s4,s11
    800030f8:	0569f663          	bgeu	s3,s6,80003144 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030fc:	00a9559b          	srliw	a1,s2,0xa
    80003100:	8556                	mv	a0,s5
    80003102:	fffff097          	auipc	ra,0xfffff
    80003106:	7a0080e7          	jalr	1952(ra) # 800028a2 <bmap>
    8000310a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000310e:	c99d                	beqz	a1,80003144 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003110:	000aa503          	lw	a0,0(s5)
    80003114:	fffff097          	auipc	ra,0xfffff
    80003118:	394080e7          	jalr	916(ra) # 800024a8 <bread>
    8000311c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000311e:	3ff97713          	andi	a4,s2,1023
    80003122:	40ec87bb          	subw	a5,s9,a4
    80003126:	413b06bb          	subw	a3,s6,s3
    8000312a:	8d3e                	mv	s10,a5
    8000312c:	2781                	sext.w	a5,a5
    8000312e:	0006861b          	sext.w	a2,a3
    80003132:	f8f674e3          	bgeu	a2,a5,800030ba <writei+0x4c>
    80003136:	8d36                	mv	s10,a3
    80003138:	b749                	j	800030ba <writei+0x4c>
      brelse(bp);
    8000313a:	8526                	mv	a0,s1
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	49c080e7          	jalr	1180(ra) # 800025d8 <brelse>
  }

  if(off > ip->size)
    80003144:	04caa783          	lw	a5,76(s5)
    80003148:	0127f463          	bgeu	a5,s2,80003150 <writei+0xe2>
    ip->size = off;
    8000314c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003150:	8556                	mv	a0,s5
    80003152:	00000097          	auipc	ra,0x0
    80003156:	aa6080e7          	jalr	-1370(ra) # 80002bf8 <iupdate>

  return tot;
    8000315a:	0009851b          	sext.w	a0,s3
}
    8000315e:	70a6                	ld	ra,104(sp)
    80003160:	7406                	ld	s0,96(sp)
    80003162:	64e6                	ld	s1,88(sp)
    80003164:	6946                	ld	s2,80(sp)
    80003166:	69a6                	ld	s3,72(sp)
    80003168:	6a06                	ld	s4,64(sp)
    8000316a:	7ae2                	ld	s5,56(sp)
    8000316c:	7b42                	ld	s6,48(sp)
    8000316e:	7ba2                	ld	s7,40(sp)
    80003170:	7c02                	ld	s8,32(sp)
    80003172:	6ce2                	ld	s9,24(sp)
    80003174:	6d42                	ld	s10,16(sp)
    80003176:	6da2                	ld	s11,8(sp)
    80003178:	6165                	addi	sp,sp,112
    8000317a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000317c:	89da                	mv	s3,s6
    8000317e:	bfc9                	j	80003150 <writei+0xe2>
    return -1;
    80003180:	557d                	li	a0,-1
}
    80003182:	8082                	ret
    return -1;
    80003184:	557d                	li	a0,-1
    80003186:	bfe1                	j	8000315e <writei+0xf0>
    return -1;
    80003188:	557d                	li	a0,-1
    8000318a:	bfd1                	j	8000315e <writei+0xf0>

000000008000318c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000318c:	1141                	addi	sp,sp,-16
    8000318e:	e406                	sd	ra,8(sp)
    80003190:	e022                	sd	s0,0(sp)
    80003192:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003194:	4639                	li	a2,14
    80003196:	ffffd097          	auipc	ra,0xffffd
    8000319a:	0ba080e7          	jalr	186(ra) # 80000250 <strncmp>
}
    8000319e:	60a2                	ld	ra,8(sp)
    800031a0:	6402                	ld	s0,0(sp)
    800031a2:	0141                	addi	sp,sp,16
    800031a4:	8082                	ret

00000000800031a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031a6:	7139                	addi	sp,sp,-64
    800031a8:	fc06                	sd	ra,56(sp)
    800031aa:	f822                	sd	s0,48(sp)
    800031ac:	f426                	sd	s1,40(sp)
    800031ae:	f04a                	sd	s2,32(sp)
    800031b0:	ec4e                	sd	s3,24(sp)
    800031b2:	e852                	sd	s4,16(sp)
    800031b4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031b6:	04451703          	lh	a4,68(a0)
    800031ba:	4785                	li	a5,1
    800031bc:	00f71a63          	bne	a4,a5,800031d0 <dirlookup+0x2a>
    800031c0:	892a                	mv	s2,a0
    800031c2:	89ae                	mv	s3,a1
    800031c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c6:	457c                	lw	a5,76(a0)
    800031c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031cc:	e79d                	bnez	a5,800031fa <dirlookup+0x54>
    800031ce:	a8a5                	j	80003246 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031d0:	00005517          	auipc	a0,0x5
    800031d4:	3f050513          	addi	a0,a0,1008 # 800085c0 <syscalls+0x1b0>
    800031d8:	00003097          	auipc	ra,0x3
    800031dc:	bfa080e7          	jalr	-1030(ra) # 80005dd2 <panic>
      panic("dirlookup read");
    800031e0:	00005517          	auipc	a0,0x5
    800031e4:	3f850513          	addi	a0,a0,1016 # 800085d8 <syscalls+0x1c8>
    800031e8:	00003097          	auipc	ra,0x3
    800031ec:	bea080e7          	jalr	-1046(ra) # 80005dd2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f0:	24c1                	addiw	s1,s1,16
    800031f2:	04c92783          	lw	a5,76(s2)
    800031f6:	04f4f763          	bgeu	s1,a5,80003244 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031fa:	4741                	li	a4,16
    800031fc:	86a6                	mv	a3,s1
    800031fe:	fc040613          	addi	a2,s0,-64
    80003202:	4581                	li	a1,0
    80003204:	854a                	mv	a0,s2
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	d70080e7          	jalr	-656(ra) # 80002f76 <readi>
    8000320e:	47c1                	li	a5,16
    80003210:	fcf518e3          	bne	a0,a5,800031e0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003214:	fc045783          	lhu	a5,-64(s0)
    80003218:	dfe1                	beqz	a5,800031f0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000321a:	fc240593          	addi	a1,s0,-62
    8000321e:	854e                	mv	a0,s3
    80003220:	00000097          	auipc	ra,0x0
    80003224:	f6c080e7          	jalr	-148(ra) # 8000318c <namecmp>
    80003228:	f561                	bnez	a0,800031f0 <dirlookup+0x4a>
      if(poff)
    8000322a:	000a0463          	beqz	s4,80003232 <dirlookup+0x8c>
        *poff = off;
    8000322e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003232:	fc045583          	lhu	a1,-64(s0)
    80003236:	00092503          	lw	a0,0(s2)
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	750080e7          	jalr	1872(ra) # 8000298a <iget>
    80003242:	a011                	j	80003246 <dirlookup+0xa0>
  return 0;
    80003244:	4501                	li	a0,0
}
    80003246:	70e2                	ld	ra,56(sp)
    80003248:	7442                	ld	s0,48(sp)
    8000324a:	74a2                	ld	s1,40(sp)
    8000324c:	7902                	ld	s2,32(sp)
    8000324e:	69e2                	ld	s3,24(sp)
    80003250:	6a42                	ld	s4,16(sp)
    80003252:	6121                	addi	sp,sp,64
    80003254:	8082                	ret

0000000080003256 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003256:	711d                	addi	sp,sp,-96
    80003258:	ec86                	sd	ra,88(sp)
    8000325a:	e8a2                	sd	s0,80(sp)
    8000325c:	e4a6                	sd	s1,72(sp)
    8000325e:	e0ca                	sd	s2,64(sp)
    80003260:	fc4e                	sd	s3,56(sp)
    80003262:	f852                	sd	s4,48(sp)
    80003264:	f456                	sd	s5,40(sp)
    80003266:	f05a                	sd	s6,32(sp)
    80003268:	ec5e                	sd	s7,24(sp)
    8000326a:	e862                	sd	s8,16(sp)
    8000326c:	e466                	sd	s9,8(sp)
    8000326e:	1080                	addi	s0,sp,96
    80003270:	84aa                	mv	s1,a0
    80003272:	8b2e                	mv	s6,a1
    80003274:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003276:	00054703          	lbu	a4,0(a0)
    8000327a:	02f00793          	li	a5,47
    8000327e:	02f70363          	beq	a4,a5,800032a4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003282:	ffffe097          	auipc	ra,0xffffe
    80003286:	c30080e7          	jalr	-976(ra) # 80000eb2 <myproc>
    8000328a:	28853503          	ld	a0,648(a0)
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	9f6080e7          	jalr	-1546(ra) # 80002c84 <idup>
    80003296:	89aa                	mv	s3,a0
  while(*path == '/')
    80003298:	02f00913          	li	s2,47
  len = path - s;
    8000329c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000329e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032a0:	4c05                	li	s8,1
    800032a2:	a865                	j	8000335a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032a4:	4585                	li	a1,1
    800032a6:	4505                	li	a0,1
    800032a8:	fffff097          	auipc	ra,0xfffff
    800032ac:	6e2080e7          	jalr	1762(ra) # 8000298a <iget>
    800032b0:	89aa                	mv	s3,a0
    800032b2:	b7dd                	j	80003298 <namex+0x42>
      iunlockput(ip);
    800032b4:	854e                	mv	a0,s3
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	c6e080e7          	jalr	-914(ra) # 80002f24 <iunlockput>
      return 0;
    800032be:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032c0:	854e                	mv	a0,s3
    800032c2:	60e6                	ld	ra,88(sp)
    800032c4:	6446                	ld	s0,80(sp)
    800032c6:	64a6                	ld	s1,72(sp)
    800032c8:	6906                	ld	s2,64(sp)
    800032ca:	79e2                	ld	s3,56(sp)
    800032cc:	7a42                	ld	s4,48(sp)
    800032ce:	7aa2                	ld	s5,40(sp)
    800032d0:	7b02                	ld	s6,32(sp)
    800032d2:	6be2                	ld	s7,24(sp)
    800032d4:	6c42                	ld	s8,16(sp)
    800032d6:	6ca2                	ld	s9,8(sp)
    800032d8:	6125                	addi	sp,sp,96
    800032da:	8082                	ret
      iunlock(ip);
    800032dc:	854e                	mv	a0,s3
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	aa6080e7          	jalr	-1370(ra) # 80002d84 <iunlock>
      return ip;
    800032e6:	bfe9                	j	800032c0 <namex+0x6a>
      iunlockput(ip);
    800032e8:	854e                	mv	a0,s3
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	c3a080e7          	jalr	-966(ra) # 80002f24 <iunlockput>
      return 0;
    800032f2:	89d2                	mv	s3,s4
    800032f4:	b7f1                	j	800032c0 <namex+0x6a>
  len = path - s;
    800032f6:	40b48633          	sub	a2,s1,a1
    800032fa:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032fe:	094cd463          	bge	s9,s4,80003386 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003302:	4639                	li	a2,14
    80003304:	8556                	mv	a0,s5
    80003306:	ffffd097          	auipc	ra,0xffffd
    8000330a:	ed2080e7          	jalr	-302(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000330e:	0004c783          	lbu	a5,0(s1)
    80003312:	01279763          	bne	a5,s2,80003320 <namex+0xca>
    path++;
    80003316:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003318:	0004c783          	lbu	a5,0(s1)
    8000331c:	ff278de3          	beq	a5,s2,80003316 <namex+0xc0>
    ilock(ip);
    80003320:	854e                	mv	a0,s3
    80003322:	00000097          	auipc	ra,0x0
    80003326:	9a0080e7          	jalr	-1632(ra) # 80002cc2 <ilock>
    if(ip->type != T_DIR){
    8000332a:	04499783          	lh	a5,68(s3)
    8000332e:	f98793e3          	bne	a5,s8,800032b4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003332:	000b0563          	beqz	s6,8000333c <namex+0xe6>
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	d3cd                	beqz	a5,800032dc <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000333c:	865e                	mv	a2,s7
    8000333e:	85d6                	mv	a1,s5
    80003340:	854e                	mv	a0,s3
    80003342:	00000097          	auipc	ra,0x0
    80003346:	e64080e7          	jalr	-412(ra) # 800031a6 <dirlookup>
    8000334a:	8a2a                	mv	s4,a0
    8000334c:	dd51                	beqz	a0,800032e8 <namex+0x92>
    iunlockput(ip);
    8000334e:	854e                	mv	a0,s3
    80003350:	00000097          	auipc	ra,0x0
    80003354:	bd4080e7          	jalr	-1068(ra) # 80002f24 <iunlockput>
    ip = next;
    80003358:	89d2                	mv	s3,s4
  while(*path == '/')
    8000335a:	0004c783          	lbu	a5,0(s1)
    8000335e:	05279763          	bne	a5,s2,800033ac <namex+0x156>
    path++;
    80003362:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003364:	0004c783          	lbu	a5,0(s1)
    80003368:	ff278de3          	beq	a5,s2,80003362 <namex+0x10c>
  if(*path == 0)
    8000336c:	c79d                	beqz	a5,8000339a <namex+0x144>
    path++;
    8000336e:	85a6                	mv	a1,s1
  len = path - s;
    80003370:	8a5e                	mv	s4,s7
    80003372:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003374:	01278963          	beq	a5,s2,80003386 <namex+0x130>
    80003378:	dfbd                	beqz	a5,800032f6 <namex+0xa0>
    path++;
    8000337a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000337c:	0004c783          	lbu	a5,0(s1)
    80003380:	ff279ce3          	bne	a5,s2,80003378 <namex+0x122>
    80003384:	bf8d                	j	800032f6 <namex+0xa0>
    memmove(name, s, len);
    80003386:	2601                	sext.w	a2,a2
    80003388:	8556                	mv	a0,s5
    8000338a:	ffffd097          	auipc	ra,0xffffd
    8000338e:	e4e080e7          	jalr	-434(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003392:	9a56                	add	s4,s4,s5
    80003394:	000a0023          	sb	zero,0(s4)
    80003398:	bf9d                	j	8000330e <namex+0xb8>
  if(nameiparent){
    8000339a:	f20b03e3          	beqz	s6,800032c0 <namex+0x6a>
    iput(ip);
    8000339e:	854e                	mv	a0,s3
    800033a0:	00000097          	auipc	ra,0x0
    800033a4:	adc080e7          	jalr	-1316(ra) # 80002e7c <iput>
    return 0;
    800033a8:	4981                	li	s3,0
    800033aa:	bf19                	j	800032c0 <namex+0x6a>
  if(*path == 0)
    800033ac:	d7fd                	beqz	a5,8000339a <namex+0x144>
  while(*path != '/' && *path != 0)
    800033ae:	0004c783          	lbu	a5,0(s1)
    800033b2:	85a6                	mv	a1,s1
    800033b4:	b7d1                	j	80003378 <namex+0x122>

00000000800033b6 <dirlink>:
{
    800033b6:	7139                	addi	sp,sp,-64
    800033b8:	fc06                	sd	ra,56(sp)
    800033ba:	f822                	sd	s0,48(sp)
    800033bc:	f426                	sd	s1,40(sp)
    800033be:	f04a                	sd	s2,32(sp)
    800033c0:	ec4e                	sd	s3,24(sp)
    800033c2:	e852                	sd	s4,16(sp)
    800033c4:	0080                	addi	s0,sp,64
    800033c6:	892a                	mv	s2,a0
    800033c8:	8a2e                	mv	s4,a1
    800033ca:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033cc:	4601                	li	a2,0
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	dd8080e7          	jalr	-552(ra) # 800031a6 <dirlookup>
    800033d6:	e93d                	bnez	a0,8000344c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d8:	04c92483          	lw	s1,76(s2)
    800033dc:	c49d                	beqz	s1,8000340a <dirlink+0x54>
    800033de:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e0:	4741                	li	a4,16
    800033e2:	86a6                	mv	a3,s1
    800033e4:	fc040613          	addi	a2,s0,-64
    800033e8:	4581                	li	a1,0
    800033ea:	854a                	mv	a0,s2
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	b8a080e7          	jalr	-1142(ra) # 80002f76 <readi>
    800033f4:	47c1                	li	a5,16
    800033f6:	06f51163          	bne	a0,a5,80003458 <dirlink+0xa2>
    if(de.inum == 0)
    800033fa:	fc045783          	lhu	a5,-64(s0)
    800033fe:	c791                	beqz	a5,8000340a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003400:	24c1                	addiw	s1,s1,16
    80003402:	04c92783          	lw	a5,76(s2)
    80003406:	fcf4ede3          	bltu	s1,a5,800033e0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000340a:	4639                	li	a2,14
    8000340c:	85d2                	mv	a1,s4
    8000340e:	fc240513          	addi	a0,s0,-62
    80003412:	ffffd097          	auipc	ra,0xffffd
    80003416:	e7a080e7          	jalr	-390(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000341a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000341e:	4741                	li	a4,16
    80003420:	86a6                	mv	a3,s1
    80003422:	fc040613          	addi	a2,s0,-64
    80003426:	4581                	li	a1,0
    80003428:	854a                	mv	a0,s2
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	c44080e7          	jalr	-956(ra) # 8000306e <writei>
    80003432:	1541                	addi	a0,a0,-16
    80003434:	00a03533          	snez	a0,a0
    80003438:	40a00533          	neg	a0,a0
}
    8000343c:	70e2                	ld	ra,56(sp)
    8000343e:	7442                	ld	s0,48(sp)
    80003440:	74a2                	ld	s1,40(sp)
    80003442:	7902                	ld	s2,32(sp)
    80003444:	69e2                	ld	s3,24(sp)
    80003446:	6a42                	ld	s4,16(sp)
    80003448:	6121                	addi	sp,sp,64
    8000344a:	8082                	ret
    iput(ip);
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	a30080e7          	jalr	-1488(ra) # 80002e7c <iput>
    return -1;
    80003454:	557d                	li	a0,-1
    80003456:	b7dd                	j	8000343c <dirlink+0x86>
      panic("dirlink read");
    80003458:	00005517          	auipc	a0,0x5
    8000345c:	19050513          	addi	a0,a0,400 # 800085e8 <syscalls+0x1d8>
    80003460:	00003097          	auipc	ra,0x3
    80003464:	972080e7          	jalr	-1678(ra) # 80005dd2 <panic>

0000000080003468 <namei>:

struct inode*
namei(char *path)
{
    80003468:	1101                	addi	sp,sp,-32
    8000346a:	ec06                	sd	ra,24(sp)
    8000346c:	e822                	sd	s0,16(sp)
    8000346e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003470:	fe040613          	addi	a2,s0,-32
    80003474:	4581                	li	a1,0
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	de0080e7          	jalr	-544(ra) # 80003256 <namex>
}
    8000347e:	60e2                	ld	ra,24(sp)
    80003480:	6442                	ld	s0,16(sp)
    80003482:	6105                	addi	sp,sp,32
    80003484:	8082                	ret

0000000080003486 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003486:	1141                	addi	sp,sp,-16
    80003488:	e406                	sd	ra,8(sp)
    8000348a:	e022                	sd	s0,0(sp)
    8000348c:	0800                	addi	s0,sp,16
    8000348e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003490:	4585                	li	a1,1
    80003492:	00000097          	auipc	ra,0x0
    80003496:	dc4080e7          	jalr	-572(ra) # 80003256 <namex>
}
    8000349a:	60a2                	ld	ra,8(sp)
    8000349c:	6402                	ld	s0,0(sp)
    8000349e:	0141                	addi	sp,sp,16
    800034a0:	8082                	ret

00000000800034a2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034a2:	1101                	addi	sp,sp,-32
    800034a4:	ec06                	sd	ra,24(sp)
    800034a6:	e822                	sd	s0,16(sp)
    800034a8:	e426                	sd	s1,8(sp)
    800034aa:	e04a                	sd	s2,0(sp)
    800034ac:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034ae:	0001a917          	auipc	s2,0x1a
    800034b2:	29290913          	addi	s2,s2,658 # 8001d740 <log>
    800034b6:	01892583          	lw	a1,24(s2)
    800034ba:	02892503          	lw	a0,40(s2)
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	fea080e7          	jalr	-22(ra) # 800024a8 <bread>
    800034c6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034c8:	02c92683          	lw	a3,44(s2)
    800034cc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034ce:	02d05763          	blez	a3,800034fc <write_head+0x5a>
    800034d2:	0001a797          	auipc	a5,0x1a
    800034d6:	29e78793          	addi	a5,a5,670 # 8001d770 <log+0x30>
    800034da:	05c50713          	addi	a4,a0,92
    800034de:	36fd                	addiw	a3,a3,-1
    800034e0:	1682                	slli	a3,a3,0x20
    800034e2:	9281                	srli	a3,a3,0x20
    800034e4:	068a                	slli	a3,a3,0x2
    800034e6:	0001a617          	auipc	a2,0x1a
    800034ea:	28e60613          	addi	a2,a2,654 # 8001d774 <log+0x34>
    800034ee:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034f0:	4390                	lw	a2,0(a5)
    800034f2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034f4:	0791                	addi	a5,a5,4
    800034f6:	0711                	addi	a4,a4,4
    800034f8:	fed79ce3          	bne	a5,a3,800034f0 <write_head+0x4e>
  }
  bwrite(buf);
    800034fc:	8526                	mv	a0,s1
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	09c080e7          	jalr	156(ra) # 8000259a <bwrite>
  brelse(buf);
    80003506:	8526                	mv	a0,s1
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	0d0080e7          	jalr	208(ra) # 800025d8 <brelse>
}
    80003510:	60e2                	ld	ra,24(sp)
    80003512:	6442                	ld	s0,16(sp)
    80003514:	64a2                	ld	s1,8(sp)
    80003516:	6902                	ld	s2,0(sp)
    80003518:	6105                	addi	sp,sp,32
    8000351a:	8082                	ret

000000008000351c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000351c:	0001a797          	auipc	a5,0x1a
    80003520:	2507a783          	lw	a5,592(a5) # 8001d76c <log+0x2c>
    80003524:	0af05d63          	blez	a5,800035de <install_trans+0xc2>
{
    80003528:	7139                	addi	sp,sp,-64
    8000352a:	fc06                	sd	ra,56(sp)
    8000352c:	f822                	sd	s0,48(sp)
    8000352e:	f426                	sd	s1,40(sp)
    80003530:	f04a                	sd	s2,32(sp)
    80003532:	ec4e                	sd	s3,24(sp)
    80003534:	e852                	sd	s4,16(sp)
    80003536:	e456                	sd	s5,8(sp)
    80003538:	e05a                	sd	s6,0(sp)
    8000353a:	0080                	addi	s0,sp,64
    8000353c:	8b2a                	mv	s6,a0
    8000353e:	0001aa97          	auipc	s5,0x1a
    80003542:	232a8a93          	addi	s5,s5,562 # 8001d770 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003546:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003548:	0001a997          	auipc	s3,0x1a
    8000354c:	1f898993          	addi	s3,s3,504 # 8001d740 <log>
    80003550:	a035                	j	8000357c <install_trans+0x60>
      bunpin(dbuf);
    80003552:	8526                	mv	a0,s1
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	15e080e7          	jalr	350(ra) # 800026b2 <bunpin>
    brelse(lbuf);
    8000355c:	854a                	mv	a0,s2
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	07a080e7          	jalr	122(ra) # 800025d8 <brelse>
    brelse(dbuf);
    80003566:	8526                	mv	a0,s1
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	070080e7          	jalr	112(ra) # 800025d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003570:	2a05                	addiw	s4,s4,1
    80003572:	0a91                	addi	s5,s5,4
    80003574:	02c9a783          	lw	a5,44(s3)
    80003578:	04fa5963          	bge	s4,a5,800035ca <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000357c:	0189a583          	lw	a1,24(s3)
    80003580:	014585bb          	addw	a1,a1,s4
    80003584:	2585                	addiw	a1,a1,1
    80003586:	0289a503          	lw	a0,40(s3)
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	f1e080e7          	jalr	-226(ra) # 800024a8 <bread>
    80003592:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003594:	000aa583          	lw	a1,0(s5)
    80003598:	0289a503          	lw	a0,40(s3)
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	f0c080e7          	jalr	-244(ra) # 800024a8 <bread>
    800035a4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035a6:	40000613          	li	a2,1024
    800035aa:	05890593          	addi	a1,s2,88
    800035ae:	05850513          	addi	a0,a0,88
    800035b2:	ffffd097          	auipc	ra,0xffffd
    800035b6:	c26080e7          	jalr	-986(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035ba:	8526                	mv	a0,s1
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	fde080e7          	jalr	-34(ra) # 8000259a <bwrite>
    if(recovering == 0)
    800035c4:	f80b1ce3          	bnez	s6,8000355c <install_trans+0x40>
    800035c8:	b769                	j	80003552 <install_trans+0x36>
}
    800035ca:	70e2                	ld	ra,56(sp)
    800035cc:	7442                	ld	s0,48(sp)
    800035ce:	74a2                	ld	s1,40(sp)
    800035d0:	7902                	ld	s2,32(sp)
    800035d2:	69e2                	ld	s3,24(sp)
    800035d4:	6a42                	ld	s4,16(sp)
    800035d6:	6aa2                	ld	s5,8(sp)
    800035d8:	6b02                	ld	s6,0(sp)
    800035da:	6121                	addi	sp,sp,64
    800035dc:	8082                	ret
    800035de:	8082                	ret

00000000800035e0 <initlog>:
{
    800035e0:	7179                	addi	sp,sp,-48
    800035e2:	f406                	sd	ra,40(sp)
    800035e4:	f022                	sd	s0,32(sp)
    800035e6:	ec26                	sd	s1,24(sp)
    800035e8:	e84a                	sd	s2,16(sp)
    800035ea:	e44e                	sd	s3,8(sp)
    800035ec:	1800                	addi	s0,sp,48
    800035ee:	892a                	mv	s2,a0
    800035f0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035f2:	0001a497          	auipc	s1,0x1a
    800035f6:	14e48493          	addi	s1,s1,334 # 8001d740 <log>
    800035fa:	00005597          	auipc	a1,0x5
    800035fe:	ffe58593          	addi	a1,a1,-2 # 800085f8 <syscalls+0x1e8>
    80003602:	8526                	mv	a0,s1
    80003604:	00003097          	auipc	ra,0x3
    80003608:	ce4080e7          	jalr	-796(ra) # 800062e8 <initlock>
  log.start = sb->logstart;
    8000360c:	0149a583          	lw	a1,20(s3)
    80003610:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003612:	0109a783          	lw	a5,16(s3)
    80003616:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003618:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000361c:	854a                	mv	a0,s2
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	e8a080e7          	jalr	-374(ra) # 800024a8 <bread>
  log.lh.n = lh->n;
    80003626:	4d3c                	lw	a5,88(a0)
    80003628:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000362a:	02f05563          	blez	a5,80003654 <initlog+0x74>
    8000362e:	05c50713          	addi	a4,a0,92
    80003632:	0001a697          	auipc	a3,0x1a
    80003636:	13e68693          	addi	a3,a3,318 # 8001d770 <log+0x30>
    8000363a:	37fd                	addiw	a5,a5,-1
    8000363c:	1782                	slli	a5,a5,0x20
    8000363e:	9381                	srli	a5,a5,0x20
    80003640:	078a                	slli	a5,a5,0x2
    80003642:	06050613          	addi	a2,a0,96
    80003646:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003648:	4310                	lw	a2,0(a4)
    8000364a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000364c:	0711                	addi	a4,a4,4
    8000364e:	0691                	addi	a3,a3,4
    80003650:	fef71ce3          	bne	a4,a5,80003648 <initlog+0x68>
  brelse(buf);
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	f84080e7          	jalr	-124(ra) # 800025d8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000365c:	4505                	li	a0,1
    8000365e:	00000097          	auipc	ra,0x0
    80003662:	ebe080e7          	jalr	-322(ra) # 8000351c <install_trans>
  log.lh.n = 0;
    80003666:	0001a797          	auipc	a5,0x1a
    8000366a:	1007a323          	sw	zero,262(a5) # 8001d76c <log+0x2c>
  write_head(); // clear the log
    8000366e:	00000097          	auipc	ra,0x0
    80003672:	e34080e7          	jalr	-460(ra) # 800034a2 <write_head>
}
    80003676:	70a2                	ld	ra,40(sp)
    80003678:	7402                	ld	s0,32(sp)
    8000367a:	64e2                	ld	s1,24(sp)
    8000367c:	6942                	ld	s2,16(sp)
    8000367e:	69a2                	ld	s3,8(sp)
    80003680:	6145                	addi	sp,sp,48
    80003682:	8082                	ret

0000000080003684 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	e04a                	sd	s2,0(sp)
    8000368e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003690:	0001a517          	auipc	a0,0x1a
    80003694:	0b050513          	addi	a0,a0,176 # 8001d740 <log>
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	ce0080e7          	jalr	-800(ra) # 80006378 <acquire>
  while(1){
    if(log.committing){
    800036a0:	0001a497          	auipc	s1,0x1a
    800036a4:	0a048493          	addi	s1,s1,160 # 8001d740 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036a8:	4979                	li	s2,30
    800036aa:	a039                	j	800036b8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036ac:	85a6                	mv	a1,s1
    800036ae:	8526                	mv	a0,s1
    800036b0:	ffffe097          	auipc	ra,0xffffe
    800036b4:	eda080e7          	jalr	-294(ra) # 8000158a <sleep>
    if(log.committing){
    800036b8:	50dc                	lw	a5,36(s1)
    800036ba:	fbed                	bnez	a5,800036ac <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036bc:	509c                	lw	a5,32(s1)
    800036be:	0017871b          	addiw	a4,a5,1
    800036c2:	0007069b          	sext.w	a3,a4
    800036c6:	0027179b          	slliw	a5,a4,0x2
    800036ca:	9fb9                	addw	a5,a5,a4
    800036cc:	0017979b          	slliw	a5,a5,0x1
    800036d0:	54d8                	lw	a4,44(s1)
    800036d2:	9fb9                	addw	a5,a5,a4
    800036d4:	00f95963          	bge	s2,a5,800036e6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036d8:	85a6                	mv	a1,s1
    800036da:	8526                	mv	a0,s1
    800036dc:	ffffe097          	auipc	ra,0xffffe
    800036e0:	eae080e7          	jalr	-338(ra) # 8000158a <sleep>
    800036e4:	bfd1                	j	800036b8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036e6:	0001a517          	auipc	a0,0x1a
    800036ea:	05a50513          	addi	a0,a0,90 # 8001d740 <log>
    800036ee:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	d3c080e7          	jalr	-708(ra) # 8000642c <release>
      break;
    }
  }
}
    800036f8:	60e2                	ld	ra,24(sp)
    800036fa:	6442                	ld	s0,16(sp)
    800036fc:	64a2                	ld	s1,8(sp)
    800036fe:	6902                	ld	s2,0(sp)
    80003700:	6105                	addi	sp,sp,32
    80003702:	8082                	ret

0000000080003704 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003704:	7139                	addi	sp,sp,-64
    80003706:	fc06                	sd	ra,56(sp)
    80003708:	f822                	sd	s0,48(sp)
    8000370a:	f426                	sd	s1,40(sp)
    8000370c:	f04a                	sd	s2,32(sp)
    8000370e:	ec4e                	sd	s3,24(sp)
    80003710:	e852                	sd	s4,16(sp)
    80003712:	e456                	sd	s5,8(sp)
    80003714:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003716:	0001a497          	auipc	s1,0x1a
    8000371a:	02a48493          	addi	s1,s1,42 # 8001d740 <log>
    8000371e:	8526                	mv	a0,s1
    80003720:	00003097          	auipc	ra,0x3
    80003724:	c58080e7          	jalr	-936(ra) # 80006378 <acquire>
  log.outstanding -= 1;
    80003728:	509c                	lw	a5,32(s1)
    8000372a:	37fd                	addiw	a5,a5,-1
    8000372c:	0007891b          	sext.w	s2,a5
    80003730:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003732:	50dc                	lw	a5,36(s1)
    80003734:	efb9                	bnez	a5,80003792 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003736:	06091663          	bnez	s2,800037a2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000373a:	0001a497          	auipc	s1,0x1a
    8000373e:	00648493          	addi	s1,s1,6 # 8001d740 <log>
    80003742:	4785                	li	a5,1
    80003744:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003746:	8526                	mv	a0,s1
    80003748:	00003097          	auipc	ra,0x3
    8000374c:	ce4080e7          	jalr	-796(ra) # 8000642c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003750:	54dc                	lw	a5,44(s1)
    80003752:	06f04763          	bgtz	a5,800037c0 <end_op+0xbc>
    acquire(&log.lock);
    80003756:	0001a497          	auipc	s1,0x1a
    8000375a:	fea48493          	addi	s1,s1,-22 # 8001d740 <log>
    8000375e:	8526                	mv	a0,s1
    80003760:	00003097          	auipc	ra,0x3
    80003764:	c18080e7          	jalr	-1000(ra) # 80006378 <acquire>
    log.committing = 0;
    80003768:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000376c:	8526                	mv	a0,s1
    8000376e:	ffffe097          	auipc	ra,0xffffe
    80003772:	e82080e7          	jalr	-382(ra) # 800015f0 <wakeup>
    release(&log.lock);
    80003776:	8526                	mv	a0,s1
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	cb4080e7          	jalr	-844(ra) # 8000642c <release>
}
    80003780:	70e2                	ld	ra,56(sp)
    80003782:	7442                	ld	s0,48(sp)
    80003784:	74a2                	ld	s1,40(sp)
    80003786:	7902                	ld	s2,32(sp)
    80003788:	69e2                	ld	s3,24(sp)
    8000378a:	6a42                	ld	s4,16(sp)
    8000378c:	6aa2                	ld	s5,8(sp)
    8000378e:	6121                	addi	sp,sp,64
    80003790:	8082                	ret
    panic("log.committing");
    80003792:	00005517          	auipc	a0,0x5
    80003796:	e6e50513          	addi	a0,a0,-402 # 80008600 <syscalls+0x1f0>
    8000379a:	00002097          	auipc	ra,0x2
    8000379e:	638080e7          	jalr	1592(ra) # 80005dd2 <panic>
    wakeup(&log);
    800037a2:	0001a497          	auipc	s1,0x1a
    800037a6:	f9e48493          	addi	s1,s1,-98 # 8001d740 <log>
    800037aa:	8526                	mv	a0,s1
    800037ac:	ffffe097          	auipc	ra,0xffffe
    800037b0:	e44080e7          	jalr	-444(ra) # 800015f0 <wakeup>
  release(&log.lock);
    800037b4:	8526                	mv	a0,s1
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	c76080e7          	jalr	-906(ra) # 8000642c <release>
  if(do_commit){
    800037be:	b7c9                	j	80003780 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037c0:	0001aa97          	auipc	s5,0x1a
    800037c4:	fb0a8a93          	addi	s5,s5,-80 # 8001d770 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037c8:	0001aa17          	auipc	s4,0x1a
    800037cc:	f78a0a13          	addi	s4,s4,-136 # 8001d740 <log>
    800037d0:	018a2583          	lw	a1,24(s4)
    800037d4:	012585bb          	addw	a1,a1,s2
    800037d8:	2585                	addiw	a1,a1,1
    800037da:	028a2503          	lw	a0,40(s4)
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	cca080e7          	jalr	-822(ra) # 800024a8 <bread>
    800037e6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037e8:	000aa583          	lw	a1,0(s5)
    800037ec:	028a2503          	lw	a0,40(s4)
    800037f0:	fffff097          	auipc	ra,0xfffff
    800037f4:	cb8080e7          	jalr	-840(ra) # 800024a8 <bread>
    800037f8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037fa:	40000613          	li	a2,1024
    800037fe:	05850593          	addi	a1,a0,88
    80003802:	05848513          	addi	a0,s1,88
    80003806:	ffffd097          	auipc	ra,0xffffd
    8000380a:	9d2080e7          	jalr	-1582(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000380e:	8526                	mv	a0,s1
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	d8a080e7          	jalr	-630(ra) # 8000259a <bwrite>
    brelse(from);
    80003818:	854e                	mv	a0,s3
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	dbe080e7          	jalr	-578(ra) # 800025d8 <brelse>
    brelse(to);
    80003822:	8526                	mv	a0,s1
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	db4080e7          	jalr	-588(ra) # 800025d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000382c:	2905                	addiw	s2,s2,1
    8000382e:	0a91                	addi	s5,s5,4
    80003830:	02ca2783          	lw	a5,44(s4)
    80003834:	f8f94ee3          	blt	s2,a5,800037d0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003838:	00000097          	auipc	ra,0x0
    8000383c:	c6a080e7          	jalr	-918(ra) # 800034a2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003840:	4501                	li	a0,0
    80003842:	00000097          	auipc	ra,0x0
    80003846:	cda080e7          	jalr	-806(ra) # 8000351c <install_trans>
    log.lh.n = 0;
    8000384a:	0001a797          	auipc	a5,0x1a
    8000384e:	f207a123          	sw	zero,-222(a5) # 8001d76c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003852:	00000097          	auipc	ra,0x0
    80003856:	c50080e7          	jalr	-944(ra) # 800034a2 <write_head>
    8000385a:	bdf5                	j	80003756 <end_op+0x52>

000000008000385c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000385c:	1101                	addi	sp,sp,-32
    8000385e:	ec06                	sd	ra,24(sp)
    80003860:	e822                	sd	s0,16(sp)
    80003862:	e426                	sd	s1,8(sp)
    80003864:	e04a                	sd	s2,0(sp)
    80003866:	1000                	addi	s0,sp,32
    80003868:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000386a:	0001a917          	auipc	s2,0x1a
    8000386e:	ed690913          	addi	s2,s2,-298 # 8001d740 <log>
    80003872:	854a                	mv	a0,s2
    80003874:	00003097          	auipc	ra,0x3
    80003878:	b04080e7          	jalr	-1276(ra) # 80006378 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000387c:	02c92603          	lw	a2,44(s2)
    80003880:	47f5                	li	a5,29
    80003882:	06c7c563          	blt	a5,a2,800038ec <log_write+0x90>
    80003886:	0001a797          	auipc	a5,0x1a
    8000388a:	ed67a783          	lw	a5,-298(a5) # 8001d75c <log+0x1c>
    8000388e:	37fd                	addiw	a5,a5,-1
    80003890:	04f65e63          	bge	a2,a5,800038ec <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003894:	0001a797          	auipc	a5,0x1a
    80003898:	ecc7a783          	lw	a5,-308(a5) # 8001d760 <log+0x20>
    8000389c:	06f05063          	blez	a5,800038fc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038a0:	4781                	li	a5,0
    800038a2:	06c05563          	blez	a2,8000390c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038a6:	44cc                	lw	a1,12(s1)
    800038a8:	0001a717          	auipc	a4,0x1a
    800038ac:	ec870713          	addi	a4,a4,-312 # 8001d770 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038b0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038b2:	4314                	lw	a3,0(a4)
    800038b4:	04b68c63          	beq	a3,a1,8000390c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038b8:	2785                	addiw	a5,a5,1
    800038ba:	0711                	addi	a4,a4,4
    800038bc:	fef61be3          	bne	a2,a5,800038b2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038c0:	0621                	addi	a2,a2,8
    800038c2:	060a                	slli	a2,a2,0x2
    800038c4:	0001a797          	auipc	a5,0x1a
    800038c8:	e7c78793          	addi	a5,a5,-388 # 8001d740 <log>
    800038cc:	963e                	add	a2,a2,a5
    800038ce:	44dc                	lw	a5,12(s1)
    800038d0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038d2:	8526                	mv	a0,s1
    800038d4:	fffff097          	auipc	ra,0xfffff
    800038d8:	da2080e7          	jalr	-606(ra) # 80002676 <bpin>
    log.lh.n++;
    800038dc:	0001a717          	auipc	a4,0x1a
    800038e0:	e6470713          	addi	a4,a4,-412 # 8001d740 <log>
    800038e4:	575c                	lw	a5,44(a4)
    800038e6:	2785                	addiw	a5,a5,1
    800038e8:	d75c                	sw	a5,44(a4)
    800038ea:	a835                	j	80003926 <log_write+0xca>
    panic("too big a transaction");
    800038ec:	00005517          	auipc	a0,0x5
    800038f0:	d2450513          	addi	a0,a0,-732 # 80008610 <syscalls+0x200>
    800038f4:	00002097          	auipc	ra,0x2
    800038f8:	4de080e7          	jalr	1246(ra) # 80005dd2 <panic>
    panic("log_write outside of trans");
    800038fc:	00005517          	auipc	a0,0x5
    80003900:	d2c50513          	addi	a0,a0,-724 # 80008628 <syscalls+0x218>
    80003904:	00002097          	auipc	ra,0x2
    80003908:	4ce080e7          	jalr	1230(ra) # 80005dd2 <panic>
  log.lh.block[i] = b->blockno;
    8000390c:	00878713          	addi	a4,a5,8
    80003910:	00271693          	slli	a3,a4,0x2
    80003914:	0001a717          	auipc	a4,0x1a
    80003918:	e2c70713          	addi	a4,a4,-468 # 8001d740 <log>
    8000391c:	9736                	add	a4,a4,a3
    8000391e:	44d4                	lw	a3,12(s1)
    80003920:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003922:	faf608e3          	beq	a2,a5,800038d2 <log_write+0x76>
  }
  release(&log.lock);
    80003926:	0001a517          	auipc	a0,0x1a
    8000392a:	e1a50513          	addi	a0,a0,-486 # 8001d740 <log>
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	afe080e7          	jalr	-1282(ra) # 8000642c <release>
}
    80003936:	60e2                	ld	ra,24(sp)
    80003938:	6442                	ld	s0,16(sp)
    8000393a:	64a2                	ld	s1,8(sp)
    8000393c:	6902                	ld	s2,0(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret

0000000080003942 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003942:	1101                	addi	sp,sp,-32
    80003944:	ec06                	sd	ra,24(sp)
    80003946:	e822                	sd	s0,16(sp)
    80003948:	e426                	sd	s1,8(sp)
    8000394a:	e04a                	sd	s2,0(sp)
    8000394c:	1000                	addi	s0,sp,32
    8000394e:	84aa                	mv	s1,a0
    80003950:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003952:	00005597          	auipc	a1,0x5
    80003956:	cf658593          	addi	a1,a1,-778 # 80008648 <syscalls+0x238>
    8000395a:	0521                	addi	a0,a0,8
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	98c080e7          	jalr	-1652(ra) # 800062e8 <initlock>
  lk->name = name;
    80003964:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003968:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000396c:	0204a423          	sw	zero,40(s1)
}
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6902                	ld	s2,0(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret

000000008000397c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	e426                	sd	s1,8(sp)
    80003984:	e04a                	sd	s2,0(sp)
    80003986:	1000                	addi	s0,sp,32
    80003988:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000398a:	00850913          	addi	s2,a0,8
    8000398e:	854a                	mv	a0,s2
    80003990:	00003097          	auipc	ra,0x3
    80003994:	9e8080e7          	jalr	-1560(ra) # 80006378 <acquire>
  while (lk->locked) {
    80003998:	409c                	lw	a5,0(s1)
    8000399a:	cb89                	beqz	a5,800039ac <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000399c:	85ca                	mv	a1,s2
    8000399e:	8526                	mv	a0,s1
    800039a0:	ffffe097          	auipc	ra,0xffffe
    800039a4:	bea080e7          	jalr	-1046(ra) # 8000158a <sleep>
  while (lk->locked) {
    800039a8:	409c                	lw	a5,0(s1)
    800039aa:	fbed                	bnez	a5,8000399c <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ac:	4785                	li	a5,1
    800039ae:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	502080e7          	jalr	1282(ra) # 80000eb2 <myproc>
    800039b8:	16852783          	lw	a5,360(a0)
    800039bc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039be:	854a                	mv	a0,s2
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	a6c080e7          	jalr	-1428(ra) # 8000642c <release>
}
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6902                	ld	s2,0(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039d4:	1101                	addi	sp,sp,-32
    800039d6:	ec06                	sd	ra,24(sp)
    800039d8:	e822                	sd	s0,16(sp)
    800039da:	e426                	sd	s1,8(sp)
    800039dc:	e04a                	sd	s2,0(sp)
    800039de:	1000                	addi	s0,sp,32
    800039e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039e2:	00850913          	addi	s2,a0,8
    800039e6:	854a                	mv	a0,s2
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	990080e7          	jalr	-1648(ra) # 80006378 <acquire>
  lk->locked = 0;
    800039f0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039f4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039f8:	8526                	mv	a0,s1
    800039fa:	ffffe097          	auipc	ra,0xffffe
    800039fe:	bf6080e7          	jalr	-1034(ra) # 800015f0 <wakeup>
  release(&lk->lk);
    80003a02:	854a                	mv	a0,s2
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	a28080e7          	jalr	-1496(ra) # 8000642c <release>
}
    80003a0c:	60e2                	ld	ra,24(sp)
    80003a0e:	6442                	ld	s0,16(sp)
    80003a10:	64a2                	ld	s1,8(sp)
    80003a12:	6902                	ld	s2,0(sp)
    80003a14:	6105                	addi	sp,sp,32
    80003a16:	8082                	ret

0000000080003a18 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a18:	7179                	addi	sp,sp,-48
    80003a1a:	f406                	sd	ra,40(sp)
    80003a1c:	f022                	sd	s0,32(sp)
    80003a1e:	ec26                	sd	s1,24(sp)
    80003a20:	e84a                	sd	s2,16(sp)
    80003a22:	e44e                	sd	s3,8(sp)
    80003a24:	1800                	addi	s0,sp,48
    80003a26:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a28:	00850913          	addi	s2,a0,8
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	94a080e7          	jalr	-1718(ra) # 80006378 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a36:	409c                	lw	a5,0(s1)
    80003a38:	ef99                	bnez	a5,80003a56 <holdingsleep+0x3e>
    80003a3a:	4481                	li	s1,0
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	9ee080e7          	jalr	-1554(ra) # 8000642c <release>
  return r;
}
    80003a46:	8526                	mv	a0,s1
    80003a48:	70a2                	ld	ra,40(sp)
    80003a4a:	7402                	ld	s0,32(sp)
    80003a4c:	64e2                	ld	s1,24(sp)
    80003a4e:	6942                	ld	s2,16(sp)
    80003a50:	69a2                	ld	s3,8(sp)
    80003a52:	6145                	addi	sp,sp,48
    80003a54:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a56:	0284a983          	lw	s3,40(s1)
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	458080e7          	jalr	1112(ra) # 80000eb2 <myproc>
    80003a62:	16852483          	lw	s1,360(a0)
    80003a66:	413484b3          	sub	s1,s1,s3
    80003a6a:	0014b493          	seqz	s1,s1
    80003a6e:	b7f9                	j	80003a3c <holdingsleep+0x24>

0000000080003a70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a70:	1141                	addi	sp,sp,-16
    80003a72:	e406                	sd	ra,8(sp)
    80003a74:	e022                	sd	s0,0(sp)
    80003a76:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a78:	00005597          	auipc	a1,0x5
    80003a7c:	be058593          	addi	a1,a1,-1056 # 80008658 <syscalls+0x248>
    80003a80:	0001a517          	auipc	a0,0x1a
    80003a84:	e0850513          	addi	a0,a0,-504 # 8001d888 <ftable>
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	860080e7          	jalr	-1952(ra) # 800062e8 <initlock>
}
    80003a90:	60a2                	ld	ra,8(sp)
    80003a92:	6402                	ld	s0,0(sp)
    80003a94:	0141                	addi	sp,sp,16
    80003a96:	8082                	ret

0000000080003a98 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a98:	1101                	addi	sp,sp,-32
    80003a9a:	ec06                	sd	ra,24(sp)
    80003a9c:	e822                	sd	s0,16(sp)
    80003a9e:	e426                	sd	s1,8(sp)
    80003aa0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aa2:	0001a517          	auipc	a0,0x1a
    80003aa6:	de650513          	addi	a0,a0,-538 # 8001d888 <ftable>
    80003aaa:	00003097          	auipc	ra,0x3
    80003aae:	8ce080e7          	jalr	-1842(ra) # 80006378 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ab2:	0001a497          	auipc	s1,0x1a
    80003ab6:	dee48493          	addi	s1,s1,-530 # 8001d8a0 <ftable+0x18>
    80003aba:	0001b717          	auipc	a4,0x1b
    80003abe:	d8670713          	addi	a4,a4,-634 # 8001e840 <disk>
    if(f->ref == 0){
    80003ac2:	40dc                	lw	a5,4(s1)
    80003ac4:	cf99                	beqz	a5,80003ae2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ac6:	02848493          	addi	s1,s1,40
    80003aca:	fee49ce3          	bne	s1,a4,80003ac2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ace:	0001a517          	auipc	a0,0x1a
    80003ad2:	dba50513          	addi	a0,a0,-582 # 8001d888 <ftable>
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	956080e7          	jalr	-1706(ra) # 8000642c <release>
  return 0;
    80003ade:	4481                	li	s1,0
    80003ae0:	a819                	j	80003af6 <filealloc+0x5e>
      f->ref = 1;
    80003ae2:	4785                	li	a5,1
    80003ae4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ae6:	0001a517          	auipc	a0,0x1a
    80003aea:	da250513          	addi	a0,a0,-606 # 8001d888 <ftable>
    80003aee:	00003097          	auipc	ra,0x3
    80003af2:	93e080e7          	jalr	-1730(ra) # 8000642c <release>
}
    80003af6:	8526                	mv	a0,s1
    80003af8:	60e2                	ld	ra,24(sp)
    80003afa:	6442                	ld	s0,16(sp)
    80003afc:	64a2                	ld	s1,8(sp)
    80003afe:	6105                	addi	sp,sp,32
    80003b00:	8082                	ret

0000000080003b02 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b02:	1101                	addi	sp,sp,-32
    80003b04:	ec06                	sd	ra,24(sp)
    80003b06:	e822                	sd	s0,16(sp)
    80003b08:	e426                	sd	s1,8(sp)
    80003b0a:	1000                	addi	s0,sp,32
    80003b0c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b0e:	0001a517          	auipc	a0,0x1a
    80003b12:	d7a50513          	addi	a0,a0,-646 # 8001d888 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	862080e7          	jalr	-1950(ra) # 80006378 <acquire>
  if(f->ref < 1)
    80003b1e:	40dc                	lw	a5,4(s1)
    80003b20:	02f05263          	blez	a5,80003b44 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b24:	2785                	addiw	a5,a5,1
    80003b26:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b28:	0001a517          	auipc	a0,0x1a
    80003b2c:	d6050513          	addi	a0,a0,-672 # 8001d888 <ftable>
    80003b30:	00003097          	auipc	ra,0x3
    80003b34:	8fc080e7          	jalr	-1796(ra) # 8000642c <release>
  return f;
}
    80003b38:	8526                	mv	a0,s1
    80003b3a:	60e2                	ld	ra,24(sp)
    80003b3c:	6442                	ld	s0,16(sp)
    80003b3e:	64a2                	ld	s1,8(sp)
    80003b40:	6105                	addi	sp,sp,32
    80003b42:	8082                	ret
    panic("filedup");
    80003b44:	00005517          	auipc	a0,0x5
    80003b48:	b1c50513          	addi	a0,a0,-1252 # 80008660 <syscalls+0x250>
    80003b4c:	00002097          	auipc	ra,0x2
    80003b50:	286080e7          	jalr	646(ra) # 80005dd2 <panic>

0000000080003b54 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b54:	7139                	addi	sp,sp,-64
    80003b56:	fc06                	sd	ra,56(sp)
    80003b58:	f822                	sd	s0,48(sp)
    80003b5a:	f426                	sd	s1,40(sp)
    80003b5c:	f04a                	sd	s2,32(sp)
    80003b5e:	ec4e                	sd	s3,24(sp)
    80003b60:	e852                	sd	s4,16(sp)
    80003b62:	e456                	sd	s5,8(sp)
    80003b64:	0080                	addi	s0,sp,64
    80003b66:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b68:	0001a517          	auipc	a0,0x1a
    80003b6c:	d2050513          	addi	a0,a0,-736 # 8001d888 <ftable>
    80003b70:	00003097          	auipc	ra,0x3
    80003b74:	808080e7          	jalr	-2040(ra) # 80006378 <acquire>
  if(f->ref < 1)
    80003b78:	40dc                	lw	a5,4(s1)
    80003b7a:	06f05163          	blez	a5,80003bdc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b7e:	37fd                	addiw	a5,a5,-1
    80003b80:	0007871b          	sext.w	a4,a5
    80003b84:	c0dc                	sw	a5,4(s1)
    80003b86:	06e04363          	bgtz	a4,80003bec <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b8a:	0004a903          	lw	s2,0(s1)
    80003b8e:	0094ca83          	lbu	s5,9(s1)
    80003b92:	0104ba03          	ld	s4,16(s1)
    80003b96:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b9a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b9e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ba2:	0001a517          	auipc	a0,0x1a
    80003ba6:	ce650513          	addi	a0,a0,-794 # 8001d888 <ftable>
    80003baa:	00003097          	auipc	ra,0x3
    80003bae:	882080e7          	jalr	-1918(ra) # 8000642c <release>

  if(ff.type == FD_PIPE){
    80003bb2:	4785                	li	a5,1
    80003bb4:	04f90d63          	beq	s2,a5,80003c0e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bb8:	3979                	addiw	s2,s2,-2
    80003bba:	4785                	li	a5,1
    80003bbc:	0527e063          	bltu	a5,s2,80003bfc <fileclose+0xa8>
    begin_op();
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	ac4080e7          	jalr	-1340(ra) # 80003684 <begin_op>
    iput(ff.ip);
    80003bc8:	854e                	mv	a0,s3
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	2b2080e7          	jalr	690(ra) # 80002e7c <iput>
    end_op();
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	b32080e7          	jalr	-1230(ra) # 80003704 <end_op>
    80003bda:	a00d                	j	80003bfc <fileclose+0xa8>
    panic("fileclose");
    80003bdc:	00005517          	auipc	a0,0x5
    80003be0:	a8c50513          	addi	a0,a0,-1396 # 80008668 <syscalls+0x258>
    80003be4:	00002097          	auipc	ra,0x2
    80003be8:	1ee080e7          	jalr	494(ra) # 80005dd2 <panic>
    release(&ftable.lock);
    80003bec:	0001a517          	auipc	a0,0x1a
    80003bf0:	c9c50513          	addi	a0,a0,-868 # 8001d888 <ftable>
    80003bf4:	00003097          	auipc	ra,0x3
    80003bf8:	838080e7          	jalr	-1992(ra) # 8000642c <release>
  }
}
    80003bfc:	70e2                	ld	ra,56(sp)
    80003bfe:	7442                	ld	s0,48(sp)
    80003c00:	74a2                	ld	s1,40(sp)
    80003c02:	7902                	ld	s2,32(sp)
    80003c04:	69e2                	ld	s3,24(sp)
    80003c06:	6a42                	ld	s4,16(sp)
    80003c08:	6aa2                	ld	s5,8(sp)
    80003c0a:	6121                	addi	sp,sp,64
    80003c0c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c0e:	85d6                	mv	a1,s5
    80003c10:	8552                	mv	a0,s4
    80003c12:	00000097          	auipc	ra,0x0
    80003c16:	34c080e7          	jalr	844(ra) # 80003f5e <pipeclose>
    80003c1a:	b7cd                	j	80003bfc <fileclose+0xa8>

0000000080003c1c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c1c:	715d                	addi	sp,sp,-80
    80003c1e:	e486                	sd	ra,72(sp)
    80003c20:	e0a2                	sd	s0,64(sp)
    80003c22:	fc26                	sd	s1,56(sp)
    80003c24:	f84a                	sd	s2,48(sp)
    80003c26:	f44e                	sd	s3,40(sp)
    80003c28:	0880                	addi	s0,sp,80
    80003c2a:	84aa                	mv	s1,a0
    80003c2c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c2e:	ffffd097          	auipc	ra,0xffffd
    80003c32:	284080e7          	jalr	644(ra) # 80000eb2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c36:	409c                	lw	a5,0(s1)
    80003c38:	37f9                	addiw	a5,a5,-2
    80003c3a:	4705                	li	a4,1
    80003c3c:	04f76763          	bltu	a4,a5,80003c8a <filestat+0x6e>
    80003c40:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c42:	6c88                	ld	a0,24(s1)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	07e080e7          	jalr	126(ra) # 80002cc2 <ilock>
    stati(f->ip, &st);
    80003c4c:	fb840593          	addi	a1,s0,-72
    80003c50:	6c88                	ld	a0,24(s1)
    80003c52:	fffff097          	auipc	ra,0xfffff
    80003c56:	2fa080e7          	jalr	762(ra) # 80002f4c <stati>
    iunlock(f->ip);
    80003c5a:	6c88                	ld	a0,24(s1)
    80003c5c:	fffff097          	auipc	ra,0xfffff
    80003c60:	128080e7          	jalr	296(ra) # 80002d84 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c64:	46e1                	li	a3,24
    80003c66:	fb840613          	addi	a2,s0,-72
    80003c6a:	85ce                	mv	a1,s3
    80003c6c:	18893503          	ld	a0,392(s2)
    80003c70:	ffffd097          	auipc	ra,0xffffd
    80003c74:	eca080e7          	jalr	-310(ra) # 80000b3a <copyout>
    80003c78:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c7c:	60a6                	ld	ra,72(sp)
    80003c7e:	6406                	ld	s0,64(sp)
    80003c80:	74e2                	ld	s1,56(sp)
    80003c82:	7942                	ld	s2,48(sp)
    80003c84:	79a2                	ld	s3,40(sp)
    80003c86:	6161                	addi	sp,sp,80
    80003c88:	8082                	ret
  return -1;
    80003c8a:	557d                	li	a0,-1
    80003c8c:	bfc5                	j	80003c7c <filestat+0x60>

0000000080003c8e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c8e:	7179                	addi	sp,sp,-48
    80003c90:	f406                	sd	ra,40(sp)
    80003c92:	f022                	sd	s0,32(sp)
    80003c94:	ec26                	sd	s1,24(sp)
    80003c96:	e84a                	sd	s2,16(sp)
    80003c98:	e44e                	sd	s3,8(sp)
    80003c9a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c9c:	00854783          	lbu	a5,8(a0)
    80003ca0:	c3d5                	beqz	a5,80003d44 <fileread+0xb6>
    80003ca2:	84aa                	mv	s1,a0
    80003ca4:	89ae                	mv	s3,a1
    80003ca6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca8:	411c                	lw	a5,0(a0)
    80003caa:	4705                	li	a4,1
    80003cac:	04e78963          	beq	a5,a4,80003cfe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb0:	470d                	li	a4,3
    80003cb2:	04e78d63          	beq	a5,a4,80003d0c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb6:	4709                	li	a4,2
    80003cb8:	06e79e63          	bne	a5,a4,80003d34 <fileread+0xa6>
    ilock(f->ip);
    80003cbc:	6d08                	ld	a0,24(a0)
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	004080e7          	jalr	4(ra) # 80002cc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cc6:	874a                	mv	a4,s2
    80003cc8:	5094                	lw	a3,32(s1)
    80003cca:	864e                	mv	a2,s3
    80003ccc:	4585                	li	a1,1
    80003cce:	6c88                	ld	a0,24(s1)
    80003cd0:	fffff097          	auipc	ra,0xfffff
    80003cd4:	2a6080e7          	jalr	678(ra) # 80002f76 <readi>
    80003cd8:	892a                	mv	s2,a0
    80003cda:	00a05563          	blez	a0,80003ce4 <fileread+0x56>
      f->off += r;
    80003cde:	509c                	lw	a5,32(s1)
    80003ce0:	9fa9                	addw	a5,a5,a0
    80003ce2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ce4:	6c88                	ld	a0,24(s1)
    80003ce6:	fffff097          	auipc	ra,0xfffff
    80003cea:	09e080e7          	jalr	158(ra) # 80002d84 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cee:	854a                	mv	a0,s2
    80003cf0:	70a2                	ld	ra,40(sp)
    80003cf2:	7402                	ld	s0,32(sp)
    80003cf4:	64e2                	ld	s1,24(sp)
    80003cf6:	6942                	ld	s2,16(sp)
    80003cf8:	69a2                	ld	s3,8(sp)
    80003cfa:	6145                	addi	sp,sp,48
    80003cfc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cfe:	6908                	ld	a0,16(a0)
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	3ce080e7          	jalr	974(ra) # 800040ce <piperead>
    80003d08:	892a                	mv	s2,a0
    80003d0a:	b7d5                	j	80003cee <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d0c:	02451783          	lh	a5,36(a0)
    80003d10:	03079693          	slli	a3,a5,0x30
    80003d14:	92c1                	srli	a3,a3,0x30
    80003d16:	4725                	li	a4,9
    80003d18:	02d76863          	bltu	a4,a3,80003d48 <fileread+0xba>
    80003d1c:	0792                	slli	a5,a5,0x4
    80003d1e:	0001a717          	auipc	a4,0x1a
    80003d22:	aca70713          	addi	a4,a4,-1334 # 8001d7e8 <devsw>
    80003d26:	97ba                	add	a5,a5,a4
    80003d28:	639c                	ld	a5,0(a5)
    80003d2a:	c38d                	beqz	a5,80003d4c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d2c:	4505                	li	a0,1
    80003d2e:	9782                	jalr	a5
    80003d30:	892a                	mv	s2,a0
    80003d32:	bf75                	j	80003cee <fileread+0x60>
    panic("fileread");
    80003d34:	00005517          	auipc	a0,0x5
    80003d38:	94450513          	addi	a0,a0,-1724 # 80008678 <syscalls+0x268>
    80003d3c:	00002097          	auipc	ra,0x2
    80003d40:	096080e7          	jalr	150(ra) # 80005dd2 <panic>
    return -1;
    80003d44:	597d                	li	s2,-1
    80003d46:	b765                	j	80003cee <fileread+0x60>
      return -1;
    80003d48:	597d                	li	s2,-1
    80003d4a:	b755                	j	80003cee <fileread+0x60>
    80003d4c:	597d                	li	s2,-1
    80003d4e:	b745                	j	80003cee <fileread+0x60>

0000000080003d50 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d50:	715d                	addi	sp,sp,-80
    80003d52:	e486                	sd	ra,72(sp)
    80003d54:	e0a2                	sd	s0,64(sp)
    80003d56:	fc26                	sd	s1,56(sp)
    80003d58:	f84a                	sd	s2,48(sp)
    80003d5a:	f44e                	sd	s3,40(sp)
    80003d5c:	f052                	sd	s4,32(sp)
    80003d5e:	ec56                	sd	s5,24(sp)
    80003d60:	e85a                	sd	s6,16(sp)
    80003d62:	e45e                	sd	s7,8(sp)
    80003d64:	e062                	sd	s8,0(sp)
    80003d66:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d68:	00954783          	lbu	a5,9(a0)
    80003d6c:	10078663          	beqz	a5,80003e78 <filewrite+0x128>
    80003d70:	892a                	mv	s2,a0
    80003d72:	8aae                	mv	s5,a1
    80003d74:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d76:	411c                	lw	a5,0(a0)
    80003d78:	4705                	li	a4,1
    80003d7a:	02e78263          	beq	a5,a4,80003d9e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d7e:	470d                	li	a4,3
    80003d80:	02e78663          	beq	a5,a4,80003dac <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d84:	4709                	li	a4,2
    80003d86:	0ee79163          	bne	a5,a4,80003e68 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d8a:	0ac05d63          	blez	a2,80003e44 <filewrite+0xf4>
    int i = 0;
    80003d8e:	4981                	li	s3,0
    80003d90:	6b05                	lui	s6,0x1
    80003d92:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d96:	6b85                	lui	s7,0x1
    80003d98:	c00b8b9b          	addiw	s7,s7,-1024
    80003d9c:	a861                	j	80003e34 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d9e:	6908                	ld	a0,16(a0)
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	22e080e7          	jalr	558(ra) # 80003fce <pipewrite>
    80003da8:	8a2a                	mv	s4,a0
    80003daa:	a045                	j	80003e4a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dac:	02451783          	lh	a5,36(a0)
    80003db0:	03079693          	slli	a3,a5,0x30
    80003db4:	92c1                	srli	a3,a3,0x30
    80003db6:	4725                	li	a4,9
    80003db8:	0cd76263          	bltu	a4,a3,80003e7c <filewrite+0x12c>
    80003dbc:	0792                	slli	a5,a5,0x4
    80003dbe:	0001a717          	auipc	a4,0x1a
    80003dc2:	a2a70713          	addi	a4,a4,-1494 # 8001d7e8 <devsw>
    80003dc6:	97ba                	add	a5,a5,a4
    80003dc8:	679c                	ld	a5,8(a5)
    80003dca:	cbdd                	beqz	a5,80003e80 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dcc:	4505                	li	a0,1
    80003dce:	9782                	jalr	a5
    80003dd0:	8a2a                	mv	s4,a0
    80003dd2:	a8a5                	j	80003e4a <filewrite+0xfa>
    80003dd4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	8ac080e7          	jalr	-1876(ra) # 80003684 <begin_op>
      ilock(f->ip);
    80003de0:	01893503          	ld	a0,24(s2)
    80003de4:	fffff097          	auipc	ra,0xfffff
    80003de8:	ede080e7          	jalr	-290(ra) # 80002cc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dec:	8762                	mv	a4,s8
    80003dee:	02092683          	lw	a3,32(s2)
    80003df2:	01598633          	add	a2,s3,s5
    80003df6:	4585                	li	a1,1
    80003df8:	01893503          	ld	a0,24(s2)
    80003dfc:	fffff097          	auipc	ra,0xfffff
    80003e00:	272080e7          	jalr	626(ra) # 8000306e <writei>
    80003e04:	84aa                	mv	s1,a0
    80003e06:	00a05763          	blez	a0,80003e14 <filewrite+0xc4>
        f->off += r;
    80003e0a:	02092783          	lw	a5,32(s2)
    80003e0e:	9fa9                	addw	a5,a5,a0
    80003e10:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e14:	01893503          	ld	a0,24(s2)
    80003e18:	fffff097          	auipc	ra,0xfffff
    80003e1c:	f6c080e7          	jalr	-148(ra) # 80002d84 <iunlock>
      end_op();
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	8e4080e7          	jalr	-1820(ra) # 80003704 <end_op>

      if(r != n1){
    80003e28:	009c1f63          	bne	s8,s1,80003e46 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e2c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e30:	0149db63          	bge	s3,s4,80003e46 <filewrite+0xf6>
      int n1 = n - i;
    80003e34:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e38:	84be                	mv	s1,a5
    80003e3a:	2781                	sext.w	a5,a5
    80003e3c:	f8fb5ce3          	bge	s6,a5,80003dd4 <filewrite+0x84>
    80003e40:	84de                	mv	s1,s7
    80003e42:	bf49                	j	80003dd4 <filewrite+0x84>
    int i = 0;
    80003e44:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e46:	013a1f63          	bne	s4,s3,80003e64 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e4a:	8552                	mv	a0,s4
    80003e4c:	60a6                	ld	ra,72(sp)
    80003e4e:	6406                	ld	s0,64(sp)
    80003e50:	74e2                	ld	s1,56(sp)
    80003e52:	7942                	ld	s2,48(sp)
    80003e54:	79a2                	ld	s3,40(sp)
    80003e56:	7a02                	ld	s4,32(sp)
    80003e58:	6ae2                	ld	s5,24(sp)
    80003e5a:	6b42                	ld	s6,16(sp)
    80003e5c:	6ba2                	ld	s7,8(sp)
    80003e5e:	6c02                	ld	s8,0(sp)
    80003e60:	6161                	addi	sp,sp,80
    80003e62:	8082                	ret
    ret = (i == n ? n : -1);
    80003e64:	5a7d                	li	s4,-1
    80003e66:	b7d5                	j	80003e4a <filewrite+0xfa>
    panic("filewrite");
    80003e68:	00005517          	auipc	a0,0x5
    80003e6c:	82050513          	addi	a0,a0,-2016 # 80008688 <syscalls+0x278>
    80003e70:	00002097          	auipc	ra,0x2
    80003e74:	f62080e7          	jalr	-158(ra) # 80005dd2 <panic>
    return -1;
    80003e78:	5a7d                	li	s4,-1
    80003e7a:	bfc1                	j	80003e4a <filewrite+0xfa>
      return -1;
    80003e7c:	5a7d                	li	s4,-1
    80003e7e:	b7f1                	j	80003e4a <filewrite+0xfa>
    80003e80:	5a7d                	li	s4,-1
    80003e82:	b7e1                	j	80003e4a <filewrite+0xfa>

0000000080003e84 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e84:	7179                	addi	sp,sp,-48
    80003e86:	f406                	sd	ra,40(sp)
    80003e88:	f022                	sd	s0,32(sp)
    80003e8a:	ec26                	sd	s1,24(sp)
    80003e8c:	e84a                	sd	s2,16(sp)
    80003e8e:	e44e                	sd	s3,8(sp)
    80003e90:	e052                	sd	s4,0(sp)
    80003e92:	1800                	addi	s0,sp,48
    80003e94:	84aa                	mv	s1,a0
    80003e96:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e98:	0005b023          	sd	zero,0(a1)
    80003e9c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	bf8080e7          	jalr	-1032(ra) # 80003a98 <filealloc>
    80003ea8:	e088                	sd	a0,0(s1)
    80003eaa:	c551                	beqz	a0,80003f36 <pipealloc+0xb2>
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	bec080e7          	jalr	-1044(ra) # 80003a98 <filealloc>
    80003eb4:	00aa3023          	sd	a0,0(s4)
    80003eb8:	c92d                	beqz	a0,80003f2a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003eba:	ffffc097          	auipc	ra,0xffffc
    80003ebe:	25e080e7          	jalr	606(ra) # 80000118 <kalloc>
    80003ec2:	892a                	mv	s2,a0
    80003ec4:	c125                	beqz	a0,80003f24 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ec6:	4985                	li	s3,1
    80003ec8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ecc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ed0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ed4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ed8:	00004597          	auipc	a1,0x4
    80003edc:	7c058593          	addi	a1,a1,1984 # 80008698 <syscalls+0x288>
    80003ee0:	00002097          	auipc	ra,0x2
    80003ee4:	408080e7          	jalr	1032(ra) # 800062e8 <initlock>
  (*f0)->type = FD_PIPE;
    80003ee8:	609c                	ld	a5,0(s1)
    80003eea:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eee:	609c                	ld	a5,0(s1)
    80003ef0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ef4:	609c                	ld	a5,0(s1)
    80003ef6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003efa:	609c                	ld	a5,0(s1)
    80003efc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f00:	000a3783          	ld	a5,0(s4)
    80003f04:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f08:	000a3783          	ld	a5,0(s4)
    80003f0c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f10:	000a3783          	ld	a5,0(s4)
    80003f14:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f18:	000a3783          	ld	a5,0(s4)
    80003f1c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f20:	4501                	li	a0,0
    80003f22:	a025                	j	80003f4a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f24:	6088                	ld	a0,0(s1)
    80003f26:	e501                	bnez	a0,80003f2e <pipealloc+0xaa>
    80003f28:	a039                	j	80003f36 <pipealloc+0xb2>
    80003f2a:	6088                	ld	a0,0(s1)
    80003f2c:	c51d                	beqz	a0,80003f5a <pipealloc+0xd6>
    fileclose(*f0);
    80003f2e:	00000097          	auipc	ra,0x0
    80003f32:	c26080e7          	jalr	-986(ra) # 80003b54 <fileclose>
  if(*f1)
    80003f36:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f3a:	557d                	li	a0,-1
  if(*f1)
    80003f3c:	c799                	beqz	a5,80003f4a <pipealloc+0xc6>
    fileclose(*f1);
    80003f3e:	853e                	mv	a0,a5
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	c14080e7          	jalr	-1004(ra) # 80003b54 <fileclose>
  return -1;
    80003f48:	557d                	li	a0,-1
}
    80003f4a:	70a2                	ld	ra,40(sp)
    80003f4c:	7402                	ld	s0,32(sp)
    80003f4e:	64e2                	ld	s1,24(sp)
    80003f50:	6942                	ld	s2,16(sp)
    80003f52:	69a2                	ld	s3,8(sp)
    80003f54:	6a02                	ld	s4,0(sp)
    80003f56:	6145                	addi	sp,sp,48
    80003f58:	8082                	ret
  return -1;
    80003f5a:	557d                	li	a0,-1
    80003f5c:	b7fd                	j	80003f4a <pipealloc+0xc6>

0000000080003f5e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f5e:	1101                	addi	sp,sp,-32
    80003f60:	ec06                	sd	ra,24(sp)
    80003f62:	e822                	sd	s0,16(sp)
    80003f64:	e426                	sd	s1,8(sp)
    80003f66:	e04a                	sd	s2,0(sp)
    80003f68:	1000                	addi	s0,sp,32
    80003f6a:	84aa                	mv	s1,a0
    80003f6c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f6e:	00002097          	auipc	ra,0x2
    80003f72:	40a080e7          	jalr	1034(ra) # 80006378 <acquire>
  if(writable){
    80003f76:	02090d63          	beqz	s2,80003fb0 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f7a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f7e:	21848513          	addi	a0,s1,536
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	66e080e7          	jalr	1646(ra) # 800015f0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f8a:	2204b783          	ld	a5,544(s1)
    80003f8e:	eb95                	bnez	a5,80003fc2 <pipeclose+0x64>
    release(&pi->lock);
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	49a080e7          	jalr	1178(ra) # 8000642c <release>
    kfree((char*)pi);
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	ffffc097          	auipc	ra,0xffffc
    80003fa0:	080080e7          	jalr	128(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fa4:	60e2                	ld	ra,24(sp)
    80003fa6:	6442                	ld	s0,16(sp)
    80003fa8:	64a2                	ld	s1,8(sp)
    80003faa:	6902                	ld	s2,0(sp)
    80003fac:	6105                	addi	sp,sp,32
    80003fae:	8082                	ret
    pi->readopen = 0;
    80003fb0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fb4:	21c48513          	addi	a0,s1,540
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	638080e7          	jalr	1592(ra) # 800015f0 <wakeup>
    80003fc0:	b7e9                	j	80003f8a <pipeclose+0x2c>
    release(&pi->lock);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	468080e7          	jalr	1128(ra) # 8000642c <release>
}
    80003fcc:	bfe1                	j	80003fa4 <pipeclose+0x46>

0000000080003fce <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fce:	7159                	addi	sp,sp,-112
    80003fd0:	f486                	sd	ra,104(sp)
    80003fd2:	f0a2                	sd	s0,96(sp)
    80003fd4:	eca6                	sd	s1,88(sp)
    80003fd6:	e8ca                	sd	s2,80(sp)
    80003fd8:	e4ce                	sd	s3,72(sp)
    80003fda:	e0d2                	sd	s4,64(sp)
    80003fdc:	fc56                	sd	s5,56(sp)
    80003fde:	f85a                	sd	s6,48(sp)
    80003fe0:	f45e                	sd	s7,40(sp)
    80003fe2:	f062                	sd	s8,32(sp)
    80003fe4:	ec66                	sd	s9,24(sp)
    80003fe6:	1880                	addi	s0,sp,112
    80003fe8:	84aa                	mv	s1,a0
    80003fea:	8aae                	mv	s5,a1
    80003fec:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	ec4080e7          	jalr	-316(ra) # 80000eb2 <myproc>
    80003ff6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	00002097          	auipc	ra,0x2
    80003ffe:	37e080e7          	jalr	894(ra) # 80006378 <acquire>
  while(i < n){
    80004002:	0d405463          	blez	s4,800040ca <pipewrite+0xfc>
    80004006:	8ba6                	mv	s7,s1
  int i = 0;
    80004008:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000400a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000400c:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004010:	21c48c13          	addi	s8,s1,540
    80004014:	a08d                	j	80004076 <pipewrite+0xa8>
      release(&pi->lock);
    80004016:	8526                	mv	a0,s1
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	414080e7          	jalr	1044(ra) # 8000642c <release>
      return -1;
    80004020:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004022:	854a                	mv	a0,s2
    80004024:	70a6                	ld	ra,104(sp)
    80004026:	7406                	ld	s0,96(sp)
    80004028:	64e6                	ld	s1,88(sp)
    8000402a:	6946                	ld	s2,80(sp)
    8000402c:	69a6                	ld	s3,72(sp)
    8000402e:	6a06                	ld	s4,64(sp)
    80004030:	7ae2                	ld	s5,56(sp)
    80004032:	7b42                	ld	s6,48(sp)
    80004034:	7ba2                	ld	s7,40(sp)
    80004036:	7c02                	ld	s8,32(sp)
    80004038:	6ce2                	ld	s9,24(sp)
    8000403a:	6165                	addi	sp,sp,112
    8000403c:	8082                	ret
      wakeup(&pi->nread);
    8000403e:	8566                	mv	a0,s9
    80004040:	ffffd097          	auipc	ra,0xffffd
    80004044:	5b0080e7          	jalr	1456(ra) # 800015f0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004048:	85de                	mv	a1,s7
    8000404a:	8562                	mv	a0,s8
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	53e080e7          	jalr	1342(ra) # 8000158a <sleep>
    80004054:	a839                	j	80004072 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004056:	21c4a783          	lw	a5,540(s1)
    8000405a:	0017871b          	addiw	a4,a5,1
    8000405e:	20e4ae23          	sw	a4,540(s1)
    80004062:	1ff7f793          	andi	a5,a5,511
    80004066:	97a6                	add	a5,a5,s1
    80004068:	f9f44703          	lbu	a4,-97(s0)
    8000406c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004070:	2905                	addiw	s2,s2,1
  while(i < n){
    80004072:	05495063          	bge	s2,s4,800040b2 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004076:	2204a783          	lw	a5,544(s1)
    8000407a:	dfd1                	beqz	a5,80004016 <pipewrite+0x48>
    8000407c:	854e                	mv	a0,s3
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	7c8080e7          	jalr	1992(ra) # 80001846 <killed>
    80004086:	f941                	bnez	a0,80004016 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004088:	2184a783          	lw	a5,536(s1)
    8000408c:	21c4a703          	lw	a4,540(s1)
    80004090:	2007879b          	addiw	a5,a5,512
    80004094:	faf705e3          	beq	a4,a5,8000403e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004098:	4685                	li	a3,1
    8000409a:	01590633          	add	a2,s2,s5
    8000409e:	f9f40593          	addi	a1,s0,-97
    800040a2:	1889b503          	ld	a0,392(s3)
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	b54080e7          	jalr	-1196(ra) # 80000bfa <copyin>
    800040ae:	fb6514e3          	bne	a0,s6,80004056 <pipewrite+0x88>
  wakeup(&pi->nread);
    800040b2:	21848513          	addi	a0,s1,536
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	53a080e7          	jalr	1338(ra) # 800015f0 <wakeup>
  release(&pi->lock);
    800040be:	8526                	mv	a0,s1
    800040c0:	00002097          	auipc	ra,0x2
    800040c4:	36c080e7          	jalr	876(ra) # 8000642c <release>
  return i;
    800040c8:	bfa9                	j	80004022 <pipewrite+0x54>
  int i = 0;
    800040ca:	4901                	li	s2,0
    800040cc:	b7dd                	j	800040b2 <pipewrite+0xe4>

00000000800040ce <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040ce:	715d                	addi	sp,sp,-80
    800040d0:	e486                	sd	ra,72(sp)
    800040d2:	e0a2                	sd	s0,64(sp)
    800040d4:	fc26                	sd	s1,56(sp)
    800040d6:	f84a                	sd	s2,48(sp)
    800040d8:	f44e                	sd	s3,40(sp)
    800040da:	f052                	sd	s4,32(sp)
    800040dc:	ec56                	sd	s5,24(sp)
    800040de:	e85a                	sd	s6,16(sp)
    800040e0:	0880                	addi	s0,sp,80
    800040e2:	84aa                	mv	s1,a0
    800040e4:	892e                	mv	s2,a1
    800040e6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	dca080e7          	jalr	-566(ra) # 80000eb2 <myproc>
    800040f0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040f2:	8b26                	mv	s6,s1
    800040f4:	8526                	mv	a0,s1
    800040f6:	00002097          	auipc	ra,0x2
    800040fa:	282080e7          	jalr	642(ra) # 80006378 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040fe:	2184a703          	lw	a4,536(s1)
    80004102:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004106:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000410a:	02f71763          	bne	a4,a5,80004138 <piperead+0x6a>
    8000410e:	2244a783          	lw	a5,548(s1)
    80004112:	c39d                	beqz	a5,80004138 <piperead+0x6a>
    if(killed(pr)){
    80004114:	8552                	mv	a0,s4
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	730080e7          	jalr	1840(ra) # 80001846 <killed>
    8000411e:	e941                	bnez	a0,800041ae <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004120:	85da                	mv	a1,s6
    80004122:	854e                	mv	a0,s3
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	466080e7          	jalr	1126(ra) # 8000158a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000412c:	2184a703          	lw	a4,536(s1)
    80004130:	21c4a783          	lw	a5,540(s1)
    80004134:	fcf70de3          	beq	a4,a5,8000410e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004138:	09505263          	blez	s5,800041bc <piperead+0xee>
    8000413c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000413e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004140:	2184a783          	lw	a5,536(s1)
    80004144:	21c4a703          	lw	a4,540(s1)
    80004148:	02f70d63          	beq	a4,a5,80004182 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000414c:	0017871b          	addiw	a4,a5,1
    80004150:	20e4ac23          	sw	a4,536(s1)
    80004154:	1ff7f793          	andi	a5,a5,511
    80004158:	97a6                	add	a5,a5,s1
    8000415a:	0187c783          	lbu	a5,24(a5)
    8000415e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004162:	4685                	li	a3,1
    80004164:	fbf40613          	addi	a2,s0,-65
    80004168:	85ca                	mv	a1,s2
    8000416a:	188a3503          	ld	a0,392(s4)
    8000416e:	ffffd097          	auipc	ra,0xffffd
    80004172:	9cc080e7          	jalr	-1588(ra) # 80000b3a <copyout>
    80004176:	01650663          	beq	a0,s6,80004182 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417a:	2985                	addiw	s3,s3,1
    8000417c:	0905                	addi	s2,s2,1
    8000417e:	fd3a91e3          	bne	s5,s3,80004140 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004182:	21c48513          	addi	a0,s1,540
    80004186:	ffffd097          	auipc	ra,0xffffd
    8000418a:	46a080e7          	jalr	1130(ra) # 800015f0 <wakeup>
  release(&pi->lock);
    8000418e:	8526                	mv	a0,s1
    80004190:	00002097          	auipc	ra,0x2
    80004194:	29c080e7          	jalr	668(ra) # 8000642c <release>
  return i;
}
    80004198:	854e                	mv	a0,s3
    8000419a:	60a6                	ld	ra,72(sp)
    8000419c:	6406                	ld	s0,64(sp)
    8000419e:	74e2                	ld	s1,56(sp)
    800041a0:	7942                	ld	s2,48(sp)
    800041a2:	79a2                	ld	s3,40(sp)
    800041a4:	7a02                	ld	s4,32(sp)
    800041a6:	6ae2                	ld	s5,24(sp)
    800041a8:	6b42                	ld	s6,16(sp)
    800041aa:	6161                	addi	sp,sp,80
    800041ac:	8082                	ret
      release(&pi->lock);
    800041ae:	8526                	mv	a0,s1
    800041b0:	00002097          	auipc	ra,0x2
    800041b4:	27c080e7          	jalr	636(ra) # 8000642c <release>
      return -1;
    800041b8:	59fd                	li	s3,-1
    800041ba:	bff9                	j	80004198 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041bc:	4981                	li	s3,0
    800041be:	b7d1                	j	80004182 <piperead+0xb4>

00000000800041c0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041c0:	1141                	addi	sp,sp,-16
    800041c2:	e422                	sd	s0,8(sp)
    800041c4:	0800                	addi	s0,sp,16
    800041c6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041c8:	8905                	andi	a0,a0,1
    800041ca:	c111                	beqz	a0,800041ce <flags2perm+0xe>
      perm = PTE_X;
    800041cc:	4521                	li	a0,8
    if(flags & 0x2)
    800041ce:	8b89                	andi	a5,a5,2
    800041d0:	c399                	beqz	a5,800041d6 <flags2perm+0x16>
      perm |= PTE_W;
    800041d2:	00456513          	ori	a0,a0,4
    return perm;
}
    800041d6:	6422                	ld	s0,8(sp)
    800041d8:	0141                	addi	sp,sp,16
    800041da:	8082                	ret

00000000800041dc <exec>:

int
exec(char *path, char **argv)
{
    800041dc:	df010113          	addi	sp,sp,-528
    800041e0:	20113423          	sd	ra,520(sp)
    800041e4:	20813023          	sd	s0,512(sp)
    800041e8:	ffa6                	sd	s1,504(sp)
    800041ea:	fbca                	sd	s2,496(sp)
    800041ec:	f7ce                	sd	s3,488(sp)
    800041ee:	f3d2                	sd	s4,480(sp)
    800041f0:	efd6                	sd	s5,472(sp)
    800041f2:	ebda                	sd	s6,464(sp)
    800041f4:	e7de                	sd	s7,456(sp)
    800041f6:	e3e2                	sd	s8,448(sp)
    800041f8:	ff66                	sd	s9,440(sp)
    800041fa:	fb6a                	sd	s10,432(sp)
    800041fc:	f76e                	sd	s11,424(sp)
    800041fe:	0c00                	addi	s0,sp,528
    80004200:	84aa                	mv	s1,a0
    80004202:	dea43c23          	sd	a0,-520(s0)
    80004206:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000420a:	ffffd097          	auipc	ra,0xffffd
    8000420e:	ca8080e7          	jalr	-856(ra) # 80000eb2 <myproc>
    80004212:	892a                	mv	s2,a0

  begin_op();
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	470080e7          	jalr	1136(ra) # 80003684 <begin_op>

  if((ip = namei(path)) == 0){
    8000421c:	8526                	mv	a0,s1
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	24a080e7          	jalr	586(ra) # 80003468 <namei>
    80004226:	c92d                	beqz	a0,80004298 <exec+0xbc>
    80004228:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	a98080e7          	jalr	-1384(ra) # 80002cc2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004232:	04000713          	li	a4,64
    80004236:	4681                	li	a3,0
    80004238:	e5040613          	addi	a2,s0,-432
    8000423c:	4581                	li	a1,0
    8000423e:	8526                	mv	a0,s1
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	d36080e7          	jalr	-714(ra) # 80002f76 <readi>
    80004248:	04000793          	li	a5,64
    8000424c:	00f51a63          	bne	a0,a5,80004260 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004250:	e5042703          	lw	a4,-432(s0)
    80004254:	464c47b7          	lui	a5,0x464c4
    80004258:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000425c:	04f70463          	beq	a4,a5,800042a4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004260:	8526                	mv	a0,s1
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	cc2080e7          	jalr	-830(ra) # 80002f24 <iunlockput>
    end_op();
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	49a080e7          	jalr	1178(ra) # 80003704 <end_op>
  }
  return -1;
    80004272:	557d                	li	a0,-1
}
    80004274:	20813083          	ld	ra,520(sp)
    80004278:	20013403          	ld	s0,512(sp)
    8000427c:	74fe                	ld	s1,504(sp)
    8000427e:	795e                	ld	s2,496(sp)
    80004280:	79be                	ld	s3,488(sp)
    80004282:	7a1e                	ld	s4,480(sp)
    80004284:	6afe                	ld	s5,472(sp)
    80004286:	6b5e                	ld	s6,464(sp)
    80004288:	6bbe                	ld	s7,456(sp)
    8000428a:	6c1e                	ld	s8,448(sp)
    8000428c:	7cfa                	ld	s9,440(sp)
    8000428e:	7d5a                	ld	s10,432(sp)
    80004290:	7dba                	ld	s11,424(sp)
    80004292:	21010113          	addi	sp,sp,528
    80004296:	8082                	ret
    end_op();
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	46c080e7          	jalr	1132(ra) # 80003704 <end_op>
    return -1;
    800042a0:	557d                	li	a0,-1
    800042a2:	bfc9                	j	80004274 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042a4:	854a                	mv	a0,s2
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	cd4080e7          	jalr	-812(ra) # 80000f7a <proc_pagetable>
    800042ae:	8baa                	mv	s7,a0
    800042b0:	d945                	beqz	a0,80004260 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b2:	e7042983          	lw	s3,-400(s0)
    800042b6:	e8845783          	lhu	a5,-376(s0)
    800042ba:	c7ad                	beqz	a5,80004324 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042bc:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042be:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800042c0:	6c85                	lui	s9,0x1
    800042c2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042c6:	def43823          	sd	a5,-528(s0)
    800042ca:	ac0d                	j	800044fc <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042cc:	00004517          	auipc	a0,0x4
    800042d0:	3d450513          	addi	a0,a0,980 # 800086a0 <syscalls+0x290>
    800042d4:	00002097          	auipc	ra,0x2
    800042d8:	afe080e7          	jalr	-1282(ra) # 80005dd2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042dc:	8756                	mv	a4,s5
    800042de:	012d86bb          	addw	a3,s11,s2
    800042e2:	4581                	li	a1,0
    800042e4:	8526                	mv	a0,s1
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	c90080e7          	jalr	-880(ra) # 80002f76 <readi>
    800042ee:	2501                	sext.w	a0,a0
    800042f0:	1aaa9a63          	bne	s5,a0,800044a4 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042f4:	6785                	lui	a5,0x1
    800042f6:	0127893b          	addw	s2,a5,s2
    800042fa:	77fd                	lui	a5,0xfffff
    800042fc:	01478a3b          	addw	s4,a5,s4
    80004300:	1f897563          	bgeu	s2,s8,800044ea <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004304:	02091593          	slli	a1,s2,0x20
    80004308:	9181                	srli	a1,a1,0x20
    8000430a:	95ea                	add	a1,a1,s10
    8000430c:	855e                	mv	a0,s7
    8000430e:	ffffc097          	auipc	ra,0xffffc
    80004312:	1fc080e7          	jalr	508(ra) # 8000050a <walkaddr>
    80004316:	862a                	mv	a2,a0
    if(pa == 0)
    80004318:	d955                	beqz	a0,800042cc <exec+0xf0>
      n = PGSIZE;
    8000431a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000431c:	fd9a70e3          	bgeu	s4,s9,800042dc <exec+0x100>
      n = sz - i;
    80004320:	8ad2                	mv	s5,s4
    80004322:	bf6d                	j	800042dc <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004324:	4a01                	li	s4,0
  iunlockput(ip);
    80004326:	8526                	mv	a0,s1
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	bfc080e7          	jalr	-1028(ra) # 80002f24 <iunlockput>
  end_op();
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	3d4080e7          	jalr	980(ra) # 80003704 <end_op>
  p = myproc();
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	b7a080e7          	jalr	-1158(ra) # 80000eb2 <myproc>
    80004340:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004342:	18053d03          	ld	s10,384(a0)
  sz = PGROUNDUP(sz);
    80004346:	6785                	lui	a5,0x1
    80004348:	17fd                	addi	a5,a5,-1
    8000434a:	9a3e                	add	s4,s4,a5
    8000434c:	757d                	lui	a0,0xfffff
    8000434e:	00aa77b3          	and	a5,s4,a0
    80004352:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004356:	4691                	li	a3,4
    80004358:	6609                	lui	a2,0x2
    8000435a:	963e                	add	a2,a2,a5
    8000435c:	85be                	mv	a1,a5
    8000435e:	855e                	mv	a0,s7
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	582080e7          	jalr	1410(ra) # 800008e2 <uvmalloc>
    80004368:	8b2a                	mv	s6,a0
  ip = 0;
    8000436a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000436c:	12050c63          	beqz	a0,800044a4 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004370:	75f9                	lui	a1,0xffffe
    80004372:	95aa                	add	a1,a1,a0
    80004374:	855e                	mv	a0,s7
    80004376:	ffffc097          	auipc	ra,0xffffc
    8000437a:	792080e7          	jalr	1938(ra) # 80000b08 <uvmclear>
  stackbase = sp - PGSIZE;
    8000437e:	7c7d                	lui	s8,0xfffff
    80004380:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004382:	e0043783          	ld	a5,-512(s0)
    80004386:	6388                	ld	a0,0(a5)
    80004388:	c535                	beqz	a0,800043f4 <exec+0x218>
    8000438a:	e9040993          	addi	s3,s0,-368
    8000438e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004392:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	f68080e7          	jalr	-152(ra) # 800002fc <strlen>
    8000439c:	2505                	addiw	a0,a0,1
    8000439e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043a2:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043a6:	13896663          	bltu	s2,s8,800044d2 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043aa:	e0043d83          	ld	s11,-512(s0)
    800043ae:	000dba03          	ld	s4,0(s11)
    800043b2:	8552                	mv	a0,s4
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	f48080e7          	jalr	-184(ra) # 800002fc <strlen>
    800043bc:	0015069b          	addiw	a3,a0,1
    800043c0:	8652                	mv	a2,s4
    800043c2:	85ca                	mv	a1,s2
    800043c4:	855e                	mv	a0,s7
    800043c6:	ffffc097          	auipc	ra,0xffffc
    800043ca:	774080e7          	jalr	1908(ra) # 80000b3a <copyout>
    800043ce:	10054663          	bltz	a0,800044da <exec+0x2fe>
    ustack[argc] = sp;
    800043d2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043d6:	0485                	addi	s1,s1,1
    800043d8:	008d8793          	addi	a5,s11,8
    800043dc:	e0f43023          	sd	a5,-512(s0)
    800043e0:	008db503          	ld	a0,8(s11)
    800043e4:	c911                	beqz	a0,800043f8 <exec+0x21c>
    if(argc >= MAXARG)
    800043e6:	09a1                	addi	s3,s3,8
    800043e8:	fb3c96e3          	bne	s9,s3,80004394 <exec+0x1b8>
  sz = sz1;
    800043ec:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f0:	4481                	li	s1,0
    800043f2:	a84d                	j	800044a4 <exec+0x2c8>
  sp = sz;
    800043f4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043f6:	4481                	li	s1,0
  ustack[argc] = 0;
    800043f8:	00349793          	slli	a5,s1,0x3
    800043fc:	f9040713          	addi	a4,s0,-112
    80004400:	97ba                	add	a5,a5,a4
    80004402:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004406:	00148693          	addi	a3,s1,1
    8000440a:	068e                	slli	a3,a3,0x3
    8000440c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004410:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004414:	01897663          	bgeu	s2,s8,80004420 <exec+0x244>
  sz = sz1;
    80004418:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000441c:	4481                	li	s1,0
    8000441e:	a059                	j	800044a4 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004420:	e9040613          	addi	a2,s0,-368
    80004424:	85ca                	mv	a1,s2
    80004426:	855e                	mv	a0,s7
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	712080e7          	jalr	1810(ra) # 80000b3a <copyout>
    80004430:	0a054963          	bltz	a0,800044e2 <exec+0x306>
  p->trapframe->a1 = sp;
    80004434:	190ab783          	ld	a5,400(s5)
    80004438:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000443c:	df843783          	ld	a5,-520(s0)
    80004440:	0007c703          	lbu	a4,0(a5)
    80004444:	cf11                	beqz	a4,80004460 <exec+0x284>
    80004446:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004448:	02f00693          	li	a3,47
    8000444c:	a039                	j	8000445a <exec+0x27e>
      last = s+1;
    8000444e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004452:	0785                	addi	a5,a5,1
    80004454:	fff7c703          	lbu	a4,-1(a5)
    80004458:	c701                	beqz	a4,80004460 <exec+0x284>
    if(*s == '/')
    8000445a:	fed71ce3          	bne	a4,a3,80004452 <exec+0x276>
    8000445e:	bfc5                	j	8000444e <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004460:	4641                	li	a2,16
    80004462:	df843583          	ld	a1,-520(s0)
    80004466:	290a8513          	addi	a0,s5,656
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	e60080e7          	jalr	-416(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004472:	188ab503          	ld	a0,392(s5)
  p->pagetable = pagetable;
    80004476:	197ab423          	sd	s7,392(s5)
  p->sz = sz;
    8000447a:	196ab023          	sd	s6,384(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000447e:	190ab783          	ld	a5,400(s5)
    80004482:	e6843703          	ld	a4,-408(s0)
    80004486:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004488:	190ab783          	ld	a5,400(s5)
    8000448c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004490:	85ea                	mv	a1,s10
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	b84080e7          	jalr	-1148(ra) # 80001016 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000449a:	0004851b          	sext.w	a0,s1
    8000449e:	bbd9                	j	80004274 <exec+0x98>
    800044a0:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044a4:	e0843583          	ld	a1,-504(s0)
    800044a8:	855e                	mv	a0,s7
    800044aa:	ffffd097          	auipc	ra,0xffffd
    800044ae:	b6c080e7          	jalr	-1172(ra) # 80001016 <proc_freepagetable>
  if(ip){
    800044b2:	da0497e3          	bnez	s1,80004260 <exec+0x84>
  return -1;
    800044b6:	557d                	li	a0,-1
    800044b8:	bb75                	j	80004274 <exec+0x98>
    800044ba:	e1443423          	sd	s4,-504(s0)
    800044be:	b7dd                	j	800044a4 <exec+0x2c8>
    800044c0:	e1443423          	sd	s4,-504(s0)
    800044c4:	b7c5                	j	800044a4 <exec+0x2c8>
    800044c6:	e1443423          	sd	s4,-504(s0)
    800044ca:	bfe9                	j	800044a4 <exec+0x2c8>
    800044cc:	e1443423          	sd	s4,-504(s0)
    800044d0:	bfd1                	j	800044a4 <exec+0x2c8>
  sz = sz1;
    800044d2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044d6:	4481                	li	s1,0
    800044d8:	b7f1                	j	800044a4 <exec+0x2c8>
  sz = sz1;
    800044da:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044de:	4481                	li	s1,0
    800044e0:	b7d1                	j	800044a4 <exec+0x2c8>
  sz = sz1;
    800044e2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044e6:	4481                	li	s1,0
    800044e8:	bf75                	j	800044a4 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044ea:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ee:	2b05                	addiw	s6,s6,1
    800044f0:	0389899b          	addiw	s3,s3,56
    800044f4:	e8845783          	lhu	a5,-376(s0)
    800044f8:	e2fb57e3          	bge	s6,a5,80004326 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044fc:	2981                	sext.w	s3,s3
    800044fe:	03800713          	li	a4,56
    80004502:	86ce                	mv	a3,s3
    80004504:	e1840613          	addi	a2,s0,-488
    80004508:	4581                	li	a1,0
    8000450a:	8526                	mv	a0,s1
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	a6a080e7          	jalr	-1430(ra) # 80002f76 <readi>
    80004514:	03800793          	li	a5,56
    80004518:	f8f514e3          	bne	a0,a5,800044a0 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    8000451c:	e1842783          	lw	a5,-488(s0)
    80004520:	4705                	li	a4,1
    80004522:	fce796e3          	bne	a5,a4,800044ee <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004526:	e4043903          	ld	s2,-448(s0)
    8000452a:	e3843783          	ld	a5,-456(s0)
    8000452e:	f8f966e3          	bltu	s2,a5,800044ba <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004532:	e2843783          	ld	a5,-472(s0)
    80004536:	993e                	add	s2,s2,a5
    80004538:	f8f964e3          	bltu	s2,a5,800044c0 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    8000453c:	df043703          	ld	a4,-528(s0)
    80004540:	8ff9                	and	a5,a5,a4
    80004542:	f3d1                	bnez	a5,800044c6 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004544:	e1c42503          	lw	a0,-484(s0)
    80004548:	00000097          	auipc	ra,0x0
    8000454c:	c78080e7          	jalr	-904(ra) # 800041c0 <flags2perm>
    80004550:	86aa                	mv	a3,a0
    80004552:	864a                	mv	a2,s2
    80004554:	85d2                	mv	a1,s4
    80004556:	855e                	mv	a0,s7
    80004558:	ffffc097          	auipc	ra,0xffffc
    8000455c:	38a080e7          	jalr	906(ra) # 800008e2 <uvmalloc>
    80004560:	e0a43423          	sd	a0,-504(s0)
    80004564:	d525                	beqz	a0,800044cc <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004566:	e2843d03          	ld	s10,-472(s0)
    8000456a:	e2042d83          	lw	s11,-480(s0)
    8000456e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004572:	f60c0ce3          	beqz	s8,800044ea <exec+0x30e>
    80004576:	8a62                	mv	s4,s8
    80004578:	4901                	li	s2,0
    8000457a:	b369                	j	80004304 <exec+0x128>

000000008000457c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000457c:	7179                	addi	sp,sp,-48
    8000457e:	f406                	sd	ra,40(sp)
    80004580:	f022                	sd	s0,32(sp)
    80004582:	ec26                	sd	s1,24(sp)
    80004584:	e84a                	sd	s2,16(sp)
    80004586:	1800                	addi	s0,sp,48
    80004588:	892e                	mv	s2,a1
    8000458a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000458c:	fdc40593          	addi	a1,s0,-36
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	b06080e7          	jalr	-1274(ra) # 80002096 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004598:	fdc42703          	lw	a4,-36(s0)
    8000459c:	47bd                	li	a5,15
    8000459e:	02e7eb63          	bltu	a5,a4,800045d4 <argfd+0x58>
    800045a2:	ffffd097          	auipc	ra,0xffffd
    800045a6:	910080e7          	jalr	-1776(ra) # 80000eb2 <myproc>
    800045aa:	fdc42703          	lw	a4,-36(s0)
    800045ae:	04070793          	addi	a5,a4,64
    800045b2:	078e                	slli	a5,a5,0x3
    800045b4:	953e                	add	a0,a0,a5
    800045b6:	651c                	ld	a5,8(a0)
    800045b8:	c385                	beqz	a5,800045d8 <argfd+0x5c>
    return -1;
  if(pfd)
    800045ba:	00090463          	beqz	s2,800045c2 <argfd+0x46>
    *pfd = fd;
    800045be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045c2:	4501                	li	a0,0
  if(pf)
    800045c4:	c091                	beqz	s1,800045c8 <argfd+0x4c>
    *pf = f;
    800045c6:	e09c                	sd	a5,0(s1)
}
    800045c8:	70a2                	ld	ra,40(sp)
    800045ca:	7402                	ld	s0,32(sp)
    800045cc:	64e2                	ld	s1,24(sp)
    800045ce:	6942                	ld	s2,16(sp)
    800045d0:	6145                	addi	sp,sp,48
    800045d2:	8082                	ret
    return -1;
    800045d4:	557d                	li	a0,-1
    800045d6:	bfcd                	j	800045c8 <argfd+0x4c>
    800045d8:	557d                	li	a0,-1
    800045da:	b7fd                	j	800045c8 <argfd+0x4c>

00000000800045dc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045dc:	1101                	addi	sp,sp,-32
    800045de:	ec06                	sd	ra,24(sp)
    800045e0:	e822                	sd	s0,16(sp)
    800045e2:	e426                	sd	s1,8(sp)
    800045e4:	1000                	addi	s0,sp,32
    800045e6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045e8:	ffffd097          	auipc	ra,0xffffd
    800045ec:	8ca080e7          	jalr	-1846(ra) # 80000eb2 <myproc>
    800045f0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045f2:	20850793          	addi	a5,a0,520 # fffffffffffff208 <end+0xffffffff7ffd8648>
    800045f6:	4501                	li	a0,0
    800045f8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045fa:	6398                	ld	a4,0(a5)
    800045fc:	cb19                	beqz	a4,80004612 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045fe:	2505                	addiw	a0,a0,1
    80004600:	07a1                	addi	a5,a5,8
    80004602:	fed51ce3          	bne	a0,a3,800045fa <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004606:	557d                	li	a0,-1
}
    80004608:	60e2                	ld	ra,24(sp)
    8000460a:	6442                	ld	s0,16(sp)
    8000460c:	64a2                	ld	s1,8(sp)
    8000460e:	6105                	addi	sp,sp,32
    80004610:	8082                	ret
      p->ofile[fd] = f;
    80004612:	04050793          	addi	a5,a0,64
    80004616:	078e                	slli	a5,a5,0x3
    80004618:	963e                	add	a2,a2,a5
    8000461a:	e604                	sd	s1,8(a2)
      return fd;
    8000461c:	b7f5                	j	80004608 <fdalloc+0x2c>

000000008000461e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000461e:	715d                	addi	sp,sp,-80
    80004620:	e486                	sd	ra,72(sp)
    80004622:	e0a2                	sd	s0,64(sp)
    80004624:	fc26                	sd	s1,56(sp)
    80004626:	f84a                	sd	s2,48(sp)
    80004628:	f44e                	sd	s3,40(sp)
    8000462a:	f052                	sd	s4,32(sp)
    8000462c:	ec56                	sd	s5,24(sp)
    8000462e:	e85a                	sd	s6,16(sp)
    80004630:	0880                	addi	s0,sp,80
    80004632:	8b2e                	mv	s6,a1
    80004634:	89b2                	mv	s3,a2
    80004636:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004638:	fb040593          	addi	a1,s0,-80
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	e4a080e7          	jalr	-438(ra) # 80003486 <nameiparent>
    80004644:	84aa                	mv	s1,a0
    80004646:	16050063          	beqz	a0,800047a6 <create+0x188>
    return 0;

  ilock(dp);
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	678080e7          	jalr	1656(ra) # 80002cc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004652:	4601                	li	a2,0
    80004654:	fb040593          	addi	a1,s0,-80
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	b4c080e7          	jalr	-1204(ra) # 800031a6 <dirlookup>
    80004662:	8aaa                	mv	s5,a0
    80004664:	c931                	beqz	a0,800046b8 <create+0x9a>
    iunlockput(dp);
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	8bc080e7          	jalr	-1860(ra) # 80002f24 <iunlockput>
    ilock(ip);
    80004670:	8556                	mv	a0,s5
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	650080e7          	jalr	1616(ra) # 80002cc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000467a:	000b059b          	sext.w	a1,s6
    8000467e:	4789                	li	a5,2
    80004680:	02f59563          	bne	a1,a5,800046aa <create+0x8c>
    80004684:	044ad783          	lhu	a5,68(s5)
    80004688:	37f9                	addiw	a5,a5,-2
    8000468a:	17c2                	slli	a5,a5,0x30
    8000468c:	93c1                	srli	a5,a5,0x30
    8000468e:	4705                	li	a4,1
    80004690:	00f76d63          	bltu	a4,a5,800046aa <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004694:	8556                	mv	a0,s5
    80004696:	60a6                	ld	ra,72(sp)
    80004698:	6406                	ld	s0,64(sp)
    8000469a:	74e2                	ld	s1,56(sp)
    8000469c:	7942                	ld	s2,48(sp)
    8000469e:	79a2                	ld	s3,40(sp)
    800046a0:	7a02                	ld	s4,32(sp)
    800046a2:	6ae2                	ld	s5,24(sp)
    800046a4:	6b42                	ld	s6,16(sp)
    800046a6:	6161                	addi	sp,sp,80
    800046a8:	8082                	ret
    iunlockput(ip);
    800046aa:	8556                	mv	a0,s5
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	878080e7          	jalr	-1928(ra) # 80002f24 <iunlockput>
    return 0;
    800046b4:	4a81                	li	s5,0
    800046b6:	bff9                	j	80004694 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046b8:	85da                	mv	a1,s6
    800046ba:	4088                	lw	a0,0(s1)
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	46a080e7          	jalr	1130(ra) # 80002b26 <ialloc>
    800046c4:	8a2a                	mv	s4,a0
    800046c6:	c921                	beqz	a0,80004716 <create+0xf8>
  ilock(ip);
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	5fa080e7          	jalr	1530(ra) # 80002cc2 <ilock>
  ip->major = major;
    800046d0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046d4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046d8:	4785                	li	a5,1
    800046da:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800046de:	8552                	mv	a0,s4
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	518080e7          	jalr	1304(ra) # 80002bf8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046e8:	000b059b          	sext.w	a1,s6
    800046ec:	4785                	li	a5,1
    800046ee:	02f58b63          	beq	a1,a5,80004724 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f2:	004a2603          	lw	a2,4(s4)
    800046f6:	fb040593          	addi	a1,s0,-80
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	cba080e7          	jalr	-838(ra) # 800033b6 <dirlink>
    80004704:	06054f63          	bltz	a0,80004782 <create+0x164>
  iunlockput(dp);
    80004708:	8526                	mv	a0,s1
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	81a080e7          	jalr	-2022(ra) # 80002f24 <iunlockput>
  return ip;
    80004712:	8ad2                	mv	s5,s4
    80004714:	b741                	j	80004694 <create+0x76>
    iunlockput(dp);
    80004716:	8526                	mv	a0,s1
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	80c080e7          	jalr	-2036(ra) # 80002f24 <iunlockput>
    return 0;
    80004720:	8ad2                	mv	s5,s4
    80004722:	bf8d                	j	80004694 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004724:	004a2603          	lw	a2,4(s4)
    80004728:	00004597          	auipc	a1,0x4
    8000472c:	f9858593          	addi	a1,a1,-104 # 800086c0 <syscalls+0x2b0>
    80004730:	8552                	mv	a0,s4
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	c84080e7          	jalr	-892(ra) # 800033b6 <dirlink>
    8000473a:	04054463          	bltz	a0,80004782 <create+0x164>
    8000473e:	40d0                	lw	a2,4(s1)
    80004740:	00004597          	auipc	a1,0x4
    80004744:	f8858593          	addi	a1,a1,-120 # 800086c8 <syscalls+0x2b8>
    80004748:	8552                	mv	a0,s4
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	c6c080e7          	jalr	-916(ra) # 800033b6 <dirlink>
    80004752:	02054863          	bltz	a0,80004782 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004756:	004a2603          	lw	a2,4(s4)
    8000475a:	fb040593          	addi	a1,s0,-80
    8000475e:	8526                	mv	a0,s1
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	c56080e7          	jalr	-938(ra) # 800033b6 <dirlink>
    80004768:	00054d63          	bltz	a0,80004782 <create+0x164>
    dp->nlink++;  // for ".."
    8000476c:	04a4d783          	lhu	a5,74(s1)
    80004770:	2785                	addiw	a5,a5,1
    80004772:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004776:	8526                	mv	a0,s1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	480080e7          	jalr	1152(ra) # 80002bf8 <iupdate>
    80004780:	b761                	j	80004708 <create+0xea>
  ip->nlink = 0;
    80004782:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004786:	8552                	mv	a0,s4
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	470080e7          	jalr	1136(ra) # 80002bf8 <iupdate>
  iunlockput(ip);
    80004790:	8552                	mv	a0,s4
    80004792:	ffffe097          	auipc	ra,0xffffe
    80004796:	792080e7          	jalr	1938(ra) # 80002f24 <iunlockput>
  iunlockput(dp);
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	788080e7          	jalr	1928(ra) # 80002f24 <iunlockput>
  return 0;
    800047a4:	bdc5                	j	80004694 <create+0x76>
    return 0;
    800047a6:	8aaa                	mv	s5,a0
    800047a8:	b5f5                	j	80004694 <create+0x76>

00000000800047aa <sys_dup>:
{
    800047aa:	7179                	addi	sp,sp,-48
    800047ac:	f406                	sd	ra,40(sp)
    800047ae:	f022                	sd	s0,32(sp)
    800047b0:	ec26                	sd	s1,24(sp)
    800047b2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b4:	fd840613          	addi	a2,s0,-40
    800047b8:	4581                	li	a1,0
    800047ba:	4501                	li	a0,0
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	dc0080e7          	jalr	-576(ra) # 8000457c <argfd>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047c6:	02054363          	bltz	a0,800047ec <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047ca:	fd843503          	ld	a0,-40(s0)
    800047ce:	00000097          	auipc	ra,0x0
    800047d2:	e0e080e7          	jalr	-498(ra) # 800045dc <fdalloc>
    800047d6:	84aa                	mv	s1,a0
    return -1;
    800047d8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047da:	00054963          	bltz	a0,800047ec <sys_dup+0x42>
  filedup(f);
    800047de:	fd843503          	ld	a0,-40(s0)
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	320080e7          	jalr	800(ra) # 80003b02 <filedup>
  return fd;
    800047ea:	87a6                	mv	a5,s1
}
    800047ec:	853e                	mv	a0,a5
    800047ee:	70a2                	ld	ra,40(sp)
    800047f0:	7402                	ld	s0,32(sp)
    800047f2:	64e2                	ld	s1,24(sp)
    800047f4:	6145                	addi	sp,sp,48
    800047f6:	8082                	ret

00000000800047f8 <sys_read>:
{
    800047f8:	7179                	addi	sp,sp,-48
    800047fa:	f406                	sd	ra,40(sp)
    800047fc:	f022                	sd	s0,32(sp)
    800047fe:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004800:	fd840593          	addi	a1,s0,-40
    80004804:	4505                	li	a0,1
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	8b0080e7          	jalr	-1872(ra) # 800020b6 <argaddr>
  argint(2, &n);
    8000480e:	fe440593          	addi	a1,s0,-28
    80004812:	4509                	li	a0,2
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	882080e7          	jalr	-1918(ra) # 80002096 <argint>
  if(argfd(0, 0, &f) < 0)
    8000481c:	fe840613          	addi	a2,s0,-24
    80004820:	4581                	li	a1,0
    80004822:	4501                	li	a0,0
    80004824:	00000097          	auipc	ra,0x0
    80004828:	d58080e7          	jalr	-680(ra) # 8000457c <argfd>
    8000482c:	87aa                	mv	a5,a0
    return -1;
    8000482e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004830:	0007cc63          	bltz	a5,80004848 <sys_read+0x50>
  return fileread(f, p, n);
    80004834:	fe442603          	lw	a2,-28(s0)
    80004838:	fd843583          	ld	a1,-40(s0)
    8000483c:	fe843503          	ld	a0,-24(s0)
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	44e080e7          	jalr	1102(ra) # 80003c8e <fileread>
}
    80004848:	70a2                	ld	ra,40(sp)
    8000484a:	7402                	ld	s0,32(sp)
    8000484c:	6145                	addi	sp,sp,48
    8000484e:	8082                	ret

0000000080004850 <sys_write>:
{
    80004850:	7179                	addi	sp,sp,-48
    80004852:	f406                	sd	ra,40(sp)
    80004854:	f022                	sd	s0,32(sp)
    80004856:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004858:	fd840593          	addi	a1,s0,-40
    8000485c:	4505                	li	a0,1
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	858080e7          	jalr	-1960(ra) # 800020b6 <argaddr>
  argint(2, &n);
    80004866:	fe440593          	addi	a1,s0,-28
    8000486a:	4509                	li	a0,2
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	82a080e7          	jalr	-2006(ra) # 80002096 <argint>
  if(argfd(0, 0, &f) < 0)
    80004874:	fe840613          	addi	a2,s0,-24
    80004878:	4581                	li	a1,0
    8000487a:	4501                	li	a0,0
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	d00080e7          	jalr	-768(ra) # 8000457c <argfd>
    80004884:	87aa                	mv	a5,a0
    return -1;
    80004886:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004888:	0007cc63          	bltz	a5,800048a0 <sys_write+0x50>
  return filewrite(f, p, n);
    8000488c:	fe442603          	lw	a2,-28(s0)
    80004890:	fd843583          	ld	a1,-40(s0)
    80004894:	fe843503          	ld	a0,-24(s0)
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	4b8080e7          	jalr	1208(ra) # 80003d50 <filewrite>
}
    800048a0:	70a2                	ld	ra,40(sp)
    800048a2:	7402                	ld	s0,32(sp)
    800048a4:	6145                	addi	sp,sp,48
    800048a6:	8082                	ret

00000000800048a8 <sys_close>:
{
    800048a8:	1101                	addi	sp,sp,-32
    800048aa:	ec06                	sd	ra,24(sp)
    800048ac:	e822                	sd	s0,16(sp)
    800048ae:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048b0:	fe040613          	addi	a2,s0,-32
    800048b4:	fec40593          	addi	a1,s0,-20
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	cc2080e7          	jalr	-830(ra) # 8000457c <argfd>
    return -1;
    800048c2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048c4:	02054563          	bltz	a0,800048ee <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	5ea080e7          	jalr	1514(ra) # 80000eb2 <myproc>
    800048d0:	fec42783          	lw	a5,-20(s0)
    800048d4:	04078793          	addi	a5,a5,64
    800048d8:	078e                	slli	a5,a5,0x3
    800048da:	97aa                	add	a5,a5,a0
    800048dc:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800048e0:	fe043503          	ld	a0,-32(s0)
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	270080e7          	jalr	624(ra) # 80003b54 <fileclose>
  return 0;
    800048ec:	4781                	li	a5,0
}
    800048ee:	853e                	mv	a0,a5
    800048f0:	60e2                	ld	ra,24(sp)
    800048f2:	6442                	ld	s0,16(sp)
    800048f4:	6105                	addi	sp,sp,32
    800048f6:	8082                	ret

00000000800048f8 <sys_fstat>:
{
    800048f8:	1101                	addi	sp,sp,-32
    800048fa:	ec06                	sd	ra,24(sp)
    800048fc:	e822                	sd	s0,16(sp)
    800048fe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004900:	fe040593          	addi	a1,s0,-32
    80004904:	4505                	li	a0,1
    80004906:	ffffd097          	auipc	ra,0xffffd
    8000490a:	7b0080e7          	jalr	1968(ra) # 800020b6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000490e:	fe840613          	addi	a2,s0,-24
    80004912:	4581                	li	a1,0
    80004914:	4501                	li	a0,0
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	c66080e7          	jalr	-922(ra) # 8000457c <argfd>
    8000491e:	87aa                	mv	a5,a0
    return -1;
    80004920:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004922:	0007ca63          	bltz	a5,80004936 <sys_fstat+0x3e>
  return filestat(f, st);
    80004926:	fe043583          	ld	a1,-32(s0)
    8000492a:	fe843503          	ld	a0,-24(s0)
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	2ee080e7          	jalr	750(ra) # 80003c1c <filestat>
}
    80004936:	60e2                	ld	ra,24(sp)
    80004938:	6442                	ld	s0,16(sp)
    8000493a:	6105                	addi	sp,sp,32
    8000493c:	8082                	ret

000000008000493e <sys_link>:
{
    8000493e:	7169                	addi	sp,sp,-304
    80004940:	f606                	sd	ra,296(sp)
    80004942:	f222                	sd	s0,288(sp)
    80004944:	ee26                	sd	s1,280(sp)
    80004946:	ea4a                	sd	s2,272(sp)
    80004948:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494a:	08000613          	li	a2,128
    8000494e:	ed040593          	addi	a1,s0,-304
    80004952:	4501                	li	a0,0
    80004954:	ffffd097          	auipc	ra,0xffffd
    80004958:	782080e7          	jalr	1922(ra) # 800020d6 <argstr>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000495e:	10054e63          	bltz	a0,80004a7a <sys_link+0x13c>
    80004962:	08000613          	li	a2,128
    80004966:	f5040593          	addi	a1,s0,-176
    8000496a:	4505                	li	a0,1
    8000496c:	ffffd097          	auipc	ra,0xffffd
    80004970:	76a080e7          	jalr	1898(ra) # 800020d6 <argstr>
    return -1;
    80004974:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004976:	10054263          	bltz	a0,80004a7a <sys_link+0x13c>
  begin_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	d0a080e7          	jalr	-758(ra) # 80003684 <begin_op>
  if((ip = namei(old)) == 0){
    80004982:	ed040513          	addi	a0,s0,-304
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	ae2080e7          	jalr	-1310(ra) # 80003468 <namei>
    8000498e:	84aa                	mv	s1,a0
    80004990:	c551                	beqz	a0,80004a1c <sys_link+0xde>
  ilock(ip);
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	330080e7          	jalr	816(ra) # 80002cc2 <ilock>
  if(ip->type == T_DIR){
    8000499a:	04449703          	lh	a4,68(s1)
    8000499e:	4785                	li	a5,1
    800049a0:	08f70463          	beq	a4,a5,80004a28 <sys_link+0xea>
  ip->nlink++;
    800049a4:	04a4d783          	lhu	a5,74(s1)
    800049a8:	2785                	addiw	a5,a5,1
    800049aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ae:	8526                	mv	a0,s1
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	248080e7          	jalr	584(ra) # 80002bf8 <iupdate>
  iunlock(ip);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	3ca080e7          	jalr	970(ra) # 80002d84 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049c2:	fd040593          	addi	a1,s0,-48
    800049c6:	f5040513          	addi	a0,s0,-176
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	abc080e7          	jalr	-1348(ra) # 80003486 <nameiparent>
    800049d2:	892a                	mv	s2,a0
    800049d4:	c935                	beqz	a0,80004a48 <sys_link+0x10a>
  ilock(dp);
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	2ec080e7          	jalr	748(ra) # 80002cc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049de:	00092703          	lw	a4,0(s2)
    800049e2:	409c                	lw	a5,0(s1)
    800049e4:	04f71d63          	bne	a4,a5,80004a3e <sys_link+0x100>
    800049e8:	40d0                	lw	a2,4(s1)
    800049ea:	fd040593          	addi	a1,s0,-48
    800049ee:	854a                	mv	a0,s2
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	9c6080e7          	jalr	-1594(ra) # 800033b6 <dirlink>
    800049f8:	04054363          	bltz	a0,80004a3e <sys_link+0x100>
  iunlockput(dp);
    800049fc:	854a                	mv	a0,s2
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	526080e7          	jalr	1318(ra) # 80002f24 <iunlockput>
  iput(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	474080e7          	jalr	1140(ra) # 80002e7c <iput>
  end_op();
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	cf4080e7          	jalr	-780(ra) # 80003704 <end_op>
  return 0;
    80004a18:	4781                	li	a5,0
    80004a1a:	a085                	j	80004a7a <sys_link+0x13c>
    end_op();
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	ce8080e7          	jalr	-792(ra) # 80003704 <end_op>
    return -1;
    80004a24:	57fd                	li	a5,-1
    80004a26:	a891                	j	80004a7a <sys_link+0x13c>
    iunlockput(ip);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	4fa080e7          	jalr	1274(ra) # 80002f24 <iunlockput>
    end_op();
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	cd2080e7          	jalr	-814(ra) # 80003704 <end_op>
    return -1;
    80004a3a:	57fd                	li	a5,-1
    80004a3c:	a83d                	j	80004a7a <sys_link+0x13c>
    iunlockput(dp);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	4e4080e7          	jalr	1252(ra) # 80002f24 <iunlockput>
  ilock(ip);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	278080e7          	jalr	632(ra) # 80002cc2 <ilock>
  ip->nlink--;
    80004a52:	04a4d783          	lhu	a5,74(s1)
    80004a56:	37fd                	addiw	a5,a5,-1
    80004a58:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	19a080e7          	jalr	410(ra) # 80002bf8 <iupdate>
  iunlockput(ip);
    80004a66:	8526                	mv	a0,s1
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	4bc080e7          	jalr	1212(ra) # 80002f24 <iunlockput>
  end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	c94080e7          	jalr	-876(ra) # 80003704 <end_op>
  return -1;
    80004a78:	57fd                	li	a5,-1
}
    80004a7a:	853e                	mv	a0,a5
    80004a7c:	70b2                	ld	ra,296(sp)
    80004a7e:	7412                	ld	s0,288(sp)
    80004a80:	64f2                	ld	s1,280(sp)
    80004a82:	6952                	ld	s2,272(sp)
    80004a84:	6155                	addi	sp,sp,304
    80004a86:	8082                	ret

0000000080004a88 <sys_unlink>:
{
    80004a88:	7151                	addi	sp,sp,-240
    80004a8a:	f586                	sd	ra,232(sp)
    80004a8c:	f1a2                	sd	s0,224(sp)
    80004a8e:	eda6                	sd	s1,216(sp)
    80004a90:	e9ca                	sd	s2,208(sp)
    80004a92:	e5ce                	sd	s3,200(sp)
    80004a94:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a96:	08000613          	li	a2,128
    80004a9a:	f3040593          	addi	a1,s0,-208
    80004a9e:	4501                	li	a0,0
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	636080e7          	jalr	1590(ra) # 800020d6 <argstr>
    80004aa8:	18054163          	bltz	a0,80004c2a <sys_unlink+0x1a2>
  begin_op();
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	bd8080e7          	jalr	-1064(ra) # 80003684 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ab4:	fb040593          	addi	a1,s0,-80
    80004ab8:	f3040513          	addi	a0,s0,-208
    80004abc:	fffff097          	auipc	ra,0xfffff
    80004ac0:	9ca080e7          	jalr	-1590(ra) # 80003486 <nameiparent>
    80004ac4:	84aa                	mv	s1,a0
    80004ac6:	c979                	beqz	a0,80004b9c <sys_unlink+0x114>
  ilock(dp);
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	1fa080e7          	jalr	506(ra) # 80002cc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad0:	00004597          	auipc	a1,0x4
    80004ad4:	bf058593          	addi	a1,a1,-1040 # 800086c0 <syscalls+0x2b0>
    80004ad8:	fb040513          	addi	a0,s0,-80
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	6b0080e7          	jalr	1712(ra) # 8000318c <namecmp>
    80004ae4:	14050a63          	beqz	a0,80004c38 <sys_unlink+0x1b0>
    80004ae8:	00004597          	auipc	a1,0x4
    80004aec:	be058593          	addi	a1,a1,-1056 # 800086c8 <syscalls+0x2b8>
    80004af0:	fb040513          	addi	a0,s0,-80
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	698080e7          	jalr	1688(ra) # 8000318c <namecmp>
    80004afc:	12050e63          	beqz	a0,80004c38 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b00:	f2c40613          	addi	a2,s0,-212
    80004b04:	fb040593          	addi	a1,s0,-80
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	69c080e7          	jalr	1692(ra) # 800031a6 <dirlookup>
    80004b12:	892a                	mv	s2,a0
    80004b14:	12050263          	beqz	a0,80004c38 <sys_unlink+0x1b0>
  ilock(ip);
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	1aa080e7          	jalr	426(ra) # 80002cc2 <ilock>
  if(ip->nlink < 1)
    80004b20:	04a91783          	lh	a5,74(s2)
    80004b24:	08f05263          	blez	a5,80004ba8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b28:	04491703          	lh	a4,68(s2)
    80004b2c:	4785                	li	a5,1
    80004b2e:	08f70563          	beq	a4,a5,80004bb8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b32:	4641                	li	a2,16
    80004b34:	4581                	li	a1,0
    80004b36:	fc040513          	addi	a0,s0,-64
    80004b3a:	ffffb097          	auipc	ra,0xffffb
    80004b3e:	63e080e7          	jalr	1598(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b42:	4741                	li	a4,16
    80004b44:	f2c42683          	lw	a3,-212(s0)
    80004b48:	fc040613          	addi	a2,s0,-64
    80004b4c:	4581                	li	a1,0
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	51e080e7          	jalr	1310(ra) # 8000306e <writei>
    80004b58:	47c1                	li	a5,16
    80004b5a:	0af51563          	bne	a0,a5,80004c04 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b5e:	04491703          	lh	a4,68(s2)
    80004b62:	4785                	li	a5,1
    80004b64:	0af70863          	beq	a4,a5,80004c14 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b68:	8526                	mv	a0,s1
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	3ba080e7          	jalr	954(ra) # 80002f24 <iunlockput>
  ip->nlink--;
    80004b72:	04a95783          	lhu	a5,74(s2)
    80004b76:	37fd                	addiw	a5,a5,-1
    80004b78:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b7c:	854a                	mv	a0,s2
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	07a080e7          	jalr	122(ra) # 80002bf8 <iupdate>
  iunlockput(ip);
    80004b86:	854a                	mv	a0,s2
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	39c080e7          	jalr	924(ra) # 80002f24 <iunlockput>
  end_op();
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	b74080e7          	jalr	-1164(ra) # 80003704 <end_op>
  return 0;
    80004b98:	4501                	li	a0,0
    80004b9a:	a84d                	j	80004c4c <sys_unlink+0x1c4>
    end_op();
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	b68080e7          	jalr	-1176(ra) # 80003704 <end_op>
    return -1;
    80004ba4:	557d                	li	a0,-1
    80004ba6:	a05d                	j	80004c4c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ba8:	00004517          	auipc	a0,0x4
    80004bac:	b2850513          	addi	a0,a0,-1240 # 800086d0 <syscalls+0x2c0>
    80004bb0:	00001097          	auipc	ra,0x1
    80004bb4:	222080e7          	jalr	546(ra) # 80005dd2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb8:	04c92703          	lw	a4,76(s2)
    80004bbc:	02000793          	li	a5,32
    80004bc0:	f6e7f9e3          	bgeu	a5,a4,80004b32 <sys_unlink+0xaa>
    80004bc4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc8:	4741                	li	a4,16
    80004bca:	86ce                	mv	a3,s3
    80004bcc:	f1840613          	addi	a2,s0,-232
    80004bd0:	4581                	li	a1,0
    80004bd2:	854a                	mv	a0,s2
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	3a2080e7          	jalr	930(ra) # 80002f76 <readi>
    80004bdc:	47c1                	li	a5,16
    80004bde:	00f51b63          	bne	a0,a5,80004bf4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004be2:	f1845783          	lhu	a5,-232(s0)
    80004be6:	e7a1                	bnez	a5,80004c2e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004be8:	29c1                	addiw	s3,s3,16
    80004bea:	04c92783          	lw	a5,76(s2)
    80004bee:	fcf9ede3          	bltu	s3,a5,80004bc8 <sys_unlink+0x140>
    80004bf2:	b781                	j	80004b32 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bf4:	00004517          	auipc	a0,0x4
    80004bf8:	af450513          	addi	a0,a0,-1292 # 800086e8 <syscalls+0x2d8>
    80004bfc:	00001097          	auipc	ra,0x1
    80004c00:	1d6080e7          	jalr	470(ra) # 80005dd2 <panic>
    panic("unlink: writei");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	afc50513          	addi	a0,a0,-1284 # 80008700 <syscalls+0x2f0>
    80004c0c:	00001097          	auipc	ra,0x1
    80004c10:	1c6080e7          	jalr	454(ra) # 80005dd2 <panic>
    dp->nlink--;
    80004c14:	04a4d783          	lhu	a5,74(s1)
    80004c18:	37fd                	addiw	a5,a5,-1
    80004c1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	fd8080e7          	jalr	-40(ra) # 80002bf8 <iupdate>
    80004c28:	b781                	j	80004b68 <sys_unlink+0xe0>
    return -1;
    80004c2a:	557d                	li	a0,-1
    80004c2c:	a005                	j	80004c4c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c2e:	854a                	mv	a0,s2
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	2f4080e7          	jalr	756(ra) # 80002f24 <iunlockput>
  iunlockput(dp);
    80004c38:	8526                	mv	a0,s1
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	2ea080e7          	jalr	746(ra) # 80002f24 <iunlockput>
  end_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	ac2080e7          	jalr	-1342(ra) # 80003704 <end_op>
  return -1;
    80004c4a:	557d                	li	a0,-1
}
    80004c4c:	70ae                	ld	ra,232(sp)
    80004c4e:	740e                	ld	s0,224(sp)
    80004c50:	64ee                	ld	s1,216(sp)
    80004c52:	694e                	ld	s2,208(sp)
    80004c54:	69ae                	ld	s3,200(sp)
    80004c56:	616d                	addi	sp,sp,240
    80004c58:	8082                	ret

0000000080004c5a <sys_open>:

uint64
sys_open(void)
{
    80004c5a:	7131                	addi	sp,sp,-192
    80004c5c:	fd06                	sd	ra,184(sp)
    80004c5e:	f922                	sd	s0,176(sp)
    80004c60:	f526                	sd	s1,168(sp)
    80004c62:	f14a                	sd	s2,160(sp)
    80004c64:	ed4e                	sd	s3,152(sp)
    80004c66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c68:	f4c40593          	addi	a1,s0,-180
    80004c6c:	4505                	li	a0,1
    80004c6e:	ffffd097          	auipc	ra,0xffffd
    80004c72:	428080e7          	jalr	1064(ra) # 80002096 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c76:	08000613          	li	a2,128
    80004c7a:	f5040593          	addi	a1,s0,-176
    80004c7e:	4501                	li	a0,0
    80004c80:	ffffd097          	auipc	ra,0xffffd
    80004c84:	456080e7          	jalr	1110(ra) # 800020d6 <argstr>
    80004c88:	87aa                	mv	a5,a0
    return -1;
    80004c8a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c8c:	0a07c963          	bltz	a5,80004d3e <sys_open+0xe4>

  begin_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	9f4080e7          	jalr	-1548(ra) # 80003684 <begin_op>

  if(omode & O_CREATE){
    80004c98:	f4c42783          	lw	a5,-180(s0)
    80004c9c:	2007f793          	andi	a5,a5,512
    80004ca0:	cfc5                	beqz	a5,80004d58 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ca2:	4681                	li	a3,0
    80004ca4:	4601                	li	a2,0
    80004ca6:	4589                	li	a1,2
    80004ca8:	f5040513          	addi	a0,s0,-176
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	972080e7          	jalr	-1678(ra) # 8000461e <create>
    80004cb4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cb6:	c959                	beqz	a0,80004d4c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cb8:	04449703          	lh	a4,68(s1)
    80004cbc:	478d                	li	a5,3
    80004cbe:	00f71763          	bne	a4,a5,80004ccc <sys_open+0x72>
    80004cc2:	0464d703          	lhu	a4,70(s1)
    80004cc6:	47a5                	li	a5,9
    80004cc8:	0ce7ed63          	bltu	a5,a4,80004da2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	dcc080e7          	jalr	-564(ra) # 80003a98 <filealloc>
    80004cd4:	89aa                	mv	s3,a0
    80004cd6:	10050363          	beqz	a0,80004ddc <sys_open+0x182>
    80004cda:	00000097          	auipc	ra,0x0
    80004cde:	902080e7          	jalr	-1790(ra) # 800045dc <fdalloc>
    80004ce2:	892a                	mv	s2,a0
    80004ce4:	0e054763          	bltz	a0,80004dd2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ce8:	04449703          	lh	a4,68(s1)
    80004cec:	478d                	li	a5,3
    80004cee:	0cf70563          	beq	a4,a5,80004db8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cf2:	4789                	li	a5,2
    80004cf4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cf8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cfc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d00:	f4c42783          	lw	a5,-180(s0)
    80004d04:	0017c713          	xori	a4,a5,1
    80004d08:	8b05                	andi	a4,a4,1
    80004d0a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d0e:	0037f713          	andi	a4,a5,3
    80004d12:	00e03733          	snez	a4,a4
    80004d16:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d1a:	4007f793          	andi	a5,a5,1024
    80004d1e:	c791                	beqz	a5,80004d2a <sys_open+0xd0>
    80004d20:	04449703          	lh	a4,68(s1)
    80004d24:	4789                	li	a5,2
    80004d26:	0af70063          	beq	a4,a5,80004dc6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	058080e7          	jalr	88(ra) # 80002d84 <iunlock>
  end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	9d0080e7          	jalr	-1584(ra) # 80003704 <end_op>

  return fd;
    80004d3c:	854a                	mv	a0,s2
}
    80004d3e:	70ea                	ld	ra,184(sp)
    80004d40:	744a                	ld	s0,176(sp)
    80004d42:	74aa                	ld	s1,168(sp)
    80004d44:	790a                	ld	s2,160(sp)
    80004d46:	69ea                	ld	s3,152(sp)
    80004d48:	6129                	addi	sp,sp,192
    80004d4a:	8082                	ret
      end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	9b8080e7          	jalr	-1608(ra) # 80003704 <end_op>
      return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	b7e5                	j	80004d3e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d58:	f5040513          	addi	a0,s0,-176
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	70c080e7          	jalr	1804(ra) # 80003468 <namei>
    80004d64:	84aa                	mv	s1,a0
    80004d66:	c905                	beqz	a0,80004d96 <sys_open+0x13c>
    ilock(ip);
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	f5a080e7          	jalr	-166(ra) # 80002cc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d70:	04449703          	lh	a4,68(s1)
    80004d74:	4785                	li	a5,1
    80004d76:	f4f711e3          	bne	a4,a5,80004cb8 <sys_open+0x5e>
    80004d7a:	f4c42783          	lw	a5,-180(s0)
    80004d7e:	d7b9                	beqz	a5,80004ccc <sys_open+0x72>
      iunlockput(ip);
    80004d80:	8526                	mv	a0,s1
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	1a2080e7          	jalr	418(ra) # 80002f24 <iunlockput>
      end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	97a080e7          	jalr	-1670(ra) # 80003704 <end_op>
      return -1;
    80004d92:	557d                	li	a0,-1
    80004d94:	b76d                	j	80004d3e <sys_open+0xe4>
      end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	96e080e7          	jalr	-1682(ra) # 80003704 <end_op>
      return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	bf79                	j	80004d3e <sys_open+0xe4>
    iunlockput(ip);
    80004da2:	8526                	mv	a0,s1
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	180080e7          	jalr	384(ra) # 80002f24 <iunlockput>
    end_op();
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	958080e7          	jalr	-1704(ra) # 80003704 <end_op>
    return -1;
    80004db4:	557d                	li	a0,-1
    80004db6:	b761                	j	80004d3e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004db8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dbc:	04649783          	lh	a5,70(s1)
    80004dc0:	02f99223          	sh	a5,36(s3)
    80004dc4:	bf25                	j	80004cfc <sys_open+0xa2>
    itrunc(ip);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	008080e7          	jalr	8(ra) # 80002dd0 <itrunc>
    80004dd0:	bfa9                	j	80004d2a <sys_open+0xd0>
      fileclose(f);
    80004dd2:	854e                	mv	a0,s3
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	d80080e7          	jalr	-640(ra) # 80003b54 <fileclose>
    iunlockput(ip);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	146080e7          	jalr	326(ra) # 80002f24 <iunlockput>
    end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	91e080e7          	jalr	-1762(ra) # 80003704 <end_op>
    return -1;
    80004dee:	557d                	li	a0,-1
    80004df0:	b7b9                	j	80004d3e <sys_open+0xe4>

0000000080004df2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004df2:	7175                	addi	sp,sp,-144
    80004df4:	e506                	sd	ra,136(sp)
    80004df6:	e122                	sd	s0,128(sp)
    80004df8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	88a080e7          	jalr	-1910(ra) # 80003684 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e02:	08000613          	li	a2,128
    80004e06:	f7040593          	addi	a1,s0,-144
    80004e0a:	4501                	li	a0,0
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	2ca080e7          	jalr	714(ra) # 800020d6 <argstr>
    80004e14:	02054963          	bltz	a0,80004e46 <sys_mkdir+0x54>
    80004e18:	4681                	li	a3,0
    80004e1a:	4601                	li	a2,0
    80004e1c:	4585                	li	a1,1
    80004e1e:	f7040513          	addi	a0,s0,-144
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	7fc080e7          	jalr	2044(ra) # 8000461e <create>
    80004e2a:	cd11                	beqz	a0,80004e46 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	0f8080e7          	jalr	248(ra) # 80002f24 <iunlockput>
  end_op();
    80004e34:	fffff097          	auipc	ra,0xfffff
    80004e38:	8d0080e7          	jalr	-1840(ra) # 80003704 <end_op>
  return 0;
    80004e3c:	4501                	li	a0,0
}
    80004e3e:	60aa                	ld	ra,136(sp)
    80004e40:	640a                	ld	s0,128(sp)
    80004e42:	6149                	addi	sp,sp,144
    80004e44:	8082                	ret
    end_op();
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	8be080e7          	jalr	-1858(ra) # 80003704 <end_op>
    return -1;
    80004e4e:	557d                	li	a0,-1
    80004e50:	b7fd                	j	80004e3e <sys_mkdir+0x4c>

0000000080004e52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e52:	7135                	addi	sp,sp,-160
    80004e54:	ed06                	sd	ra,152(sp)
    80004e56:	e922                	sd	s0,144(sp)
    80004e58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	82a080e7          	jalr	-2006(ra) # 80003684 <begin_op>
  argint(1, &major);
    80004e62:	f6c40593          	addi	a1,s0,-148
    80004e66:	4505                	li	a0,1
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	22e080e7          	jalr	558(ra) # 80002096 <argint>
  argint(2, &minor);
    80004e70:	f6840593          	addi	a1,s0,-152
    80004e74:	4509                	li	a0,2
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	220080e7          	jalr	544(ra) # 80002096 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e7e:	08000613          	li	a2,128
    80004e82:	f7040593          	addi	a1,s0,-144
    80004e86:	4501                	li	a0,0
    80004e88:	ffffd097          	auipc	ra,0xffffd
    80004e8c:	24e080e7          	jalr	590(ra) # 800020d6 <argstr>
    80004e90:	02054b63          	bltz	a0,80004ec6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e94:	f6841683          	lh	a3,-152(s0)
    80004e98:	f6c41603          	lh	a2,-148(s0)
    80004e9c:	458d                	li	a1,3
    80004e9e:	f7040513          	addi	a0,s0,-144
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	77c080e7          	jalr	1916(ra) # 8000461e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eaa:	cd11                	beqz	a0,80004ec6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	078080e7          	jalr	120(ra) # 80002f24 <iunlockput>
  end_op();
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	850080e7          	jalr	-1968(ra) # 80003704 <end_op>
  return 0;
    80004ebc:	4501                	li	a0,0
}
    80004ebe:	60ea                	ld	ra,152(sp)
    80004ec0:	644a                	ld	s0,144(sp)
    80004ec2:	610d                	addi	sp,sp,160
    80004ec4:	8082                	ret
    end_op();
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	83e080e7          	jalr	-1986(ra) # 80003704 <end_op>
    return -1;
    80004ece:	557d                	li	a0,-1
    80004ed0:	b7fd                	j	80004ebe <sys_mknod+0x6c>

0000000080004ed2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ed2:	7135                	addi	sp,sp,-160
    80004ed4:	ed06                	sd	ra,152(sp)
    80004ed6:	e922                	sd	s0,144(sp)
    80004ed8:	e526                	sd	s1,136(sp)
    80004eda:	e14a                	sd	s2,128(sp)
    80004edc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ede:	ffffc097          	auipc	ra,0xffffc
    80004ee2:	fd4080e7          	jalr	-44(ra) # 80000eb2 <myproc>
    80004ee6:	892a                	mv	s2,a0
  
  begin_op();
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	79c080e7          	jalr	1948(ra) # 80003684 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ef0:	08000613          	li	a2,128
    80004ef4:	f6040593          	addi	a1,s0,-160
    80004ef8:	4501                	li	a0,0
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	1dc080e7          	jalr	476(ra) # 800020d6 <argstr>
    80004f02:	04054b63          	bltz	a0,80004f58 <sys_chdir+0x86>
    80004f06:	f6040513          	addi	a0,s0,-160
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	55e080e7          	jalr	1374(ra) # 80003468 <namei>
    80004f12:	84aa                	mv	s1,a0
    80004f14:	c131                	beqz	a0,80004f58 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	dac080e7          	jalr	-596(ra) # 80002cc2 <ilock>
  if(ip->type != T_DIR){
    80004f1e:	04449703          	lh	a4,68(s1)
    80004f22:	4785                	li	a5,1
    80004f24:	04f71063          	bne	a4,a5,80004f64 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f28:	8526                	mv	a0,s1
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	e5a080e7          	jalr	-422(ra) # 80002d84 <iunlock>
  iput(p->cwd);
    80004f32:	28893503          	ld	a0,648(s2)
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	f46080e7          	jalr	-186(ra) # 80002e7c <iput>
  end_op();
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	7c6080e7          	jalr	1990(ra) # 80003704 <end_op>
  p->cwd = ip;
    80004f46:	28993423          	sd	s1,648(s2)
  return 0;
    80004f4a:	4501                	li	a0,0
}
    80004f4c:	60ea                	ld	ra,152(sp)
    80004f4e:	644a                	ld	s0,144(sp)
    80004f50:	64aa                	ld	s1,136(sp)
    80004f52:	690a                	ld	s2,128(sp)
    80004f54:	610d                	addi	sp,sp,160
    80004f56:	8082                	ret
    end_op();
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	7ac080e7          	jalr	1964(ra) # 80003704 <end_op>
    return -1;
    80004f60:	557d                	li	a0,-1
    80004f62:	b7ed                	j	80004f4c <sys_chdir+0x7a>
    iunlockput(ip);
    80004f64:	8526                	mv	a0,s1
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	fbe080e7          	jalr	-66(ra) # 80002f24 <iunlockput>
    end_op();
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	796080e7          	jalr	1942(ra) # 80003704 <end_op>
    return -1;
    80004f76:	557d                	li	a0,-1
    80004f78:	bfd1                	j	80004f4c <sys_chdir+0x7a>

0000000080004f7a <sys_exec>:

uint64
sys_exec(void)
{
    80004f7a:	7145                	addi	sp,sp,-464
    80004f7c:	e786                	sd	ra,456(sp)
    80004f7e:	e3a2                	sd	s0,448(sp)
    80004f80:	ff26                	sd	s1,440(sp)
    80004f82:	fb4a                	sd	s2,432(sp)
    80004f84:	f74e                	sd	s3,424(sp)
    80004f86:	f352                	sd	s4,416(sp)
    80004f88:	ef56                	sd	s5,408(sp)
    80004f8a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f8c:	e3840593          	addi	a1,s0,-456
    80004f90:	4505                	li	a0,1
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	124080e7          	jalr	292(ra) # 800020b6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f9a:	08000613          	li	a2,128
    80004f9e:	f4040593          	addi	a1,s0,-192
    80004fa2:	4501                	li	a0,0
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	132080e7          	jalr	306(ra) # 800020d6 <argstr>
    80004fac:	87aa                	mv	a5,a0
    return -1;
    80004fae:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fb0:	0c07c263          	bltz	a5,80005074 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fb4:	10000613          	li	a2,256
    80004fb8:	4581                	li	a1,0
    80004fba:	e4040513          	addi	a0,s0,-448
    80004fbe:	ffffb097          	auipc	ra,0xffffb
    80004fc2:	1ba080e7          	jalr	442(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fc6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fca:	89a6                	mv	s3,s1
    80004fcc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fce:	02000a13          	li	s4,32
    80004fd2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fd6:	00391513          	slli	a0,s2,0x3
    80004fda:	e3040593          	addi	a1,s0,-464
    80004fde:	e3843783          	ld	a5,-456(s0)
    80004fe2:	953e                	add	a0,a0,a5
    80004fe4:	ffffd097          	auipc	ra,0xffffd
    80004fe8:	00e080e7          	jalr	14(ra) # 80001ff2 <fetchaddr>
    80004fec:	02054a63          	bltz	a0,80005020 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ff0:	e3043783          	ld	a5,-464(s0)
    80004ff4:	c3b9                	beqz	a5,8000503a <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ff6:	ffffb097          	auipc	ra,0xffffb
    80004ffa:	122080e7          	jalr	290(ra) # 80000118 <kalloc>
    80004ffe:	85aa                	mv	a1,a0
    80005000:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005004:	cd11                	beqz	a0,80005020 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005006:	6605                	lui	a2,0x1
    80005008:	e3043503          	ld	a0,-464(s0)
    8000500c:	ffffd097          	auipc	ra,0xffffd
    80005010:	03c080e7          	jalr	60(ra) # 80002048 <fetchstr>
    80005014:	00054663          	bltz	a0,80005020 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005018:	0905                	addi	s2,s2,1
    8000501a:	09a1                	addi	s3,s3,8
    8000501c:	fb491be3          	bne	s2,s4,80004fd2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005020:	10048913          	addi	s2,s1,256
    80005024:	6088                	ld	a0,0(s1)
    80005026:	c531                	beqz	a0,80005072 <sys_exec+0xf8>
    kfree(argv[i]);
    80005028:	ffffb097          	auipc	ra,0xffffb
    8000502c:	ff4080e7          	jalr	-12(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	04a1                	addi	s1,s1,8
    80005032:	ff2499e3          	bne	s1,s2,80005024 <sys_exec+0xaa>
  return -1;
    80005036:	557d                	li	a0,-1
    80005038:	a835                	j	80005074 <sys_exec+0xfa>
      argv[i] = 0;
    8000503a:	0a8e                	slli	s5,s5,0x3
    8000503c:	fc040793          	addi	a5,s0,-64
    80005040:	9abe                	add	s5,s5,a5
    80005042:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005046:	e4040593          	addi	a1,s0,-448
    8000504a:	f4040513          	addi	a0,s0,-192
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	18e080e7          	jalr	398(ra) # 800041dc <exec>
    80005056:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005058:	10048993          	addi	s3,s1,256
    8000505c:	6088                	ld	a0,0(s1)
    8000505e:	c901                	beqz	a0,8000506e <sys_exec+0xf4>
    kfree(argv[i]);
    80005060:	ffffb097          	auipc	ra,0xffffb
    80005064:	fbc080e7          	jalr	-68(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005068:	04a1                	addi	s1,s1,8
    8000506a:	ff3499e3          	bne	s1,s3,8000505c <sys_exec+0xe2>
  return ret;
    8000506e:	854a                	mv	a0,s2
    80005070:	a011                	j	80005074 <sys_exec+0xfa>
  return -1;
    80005072:	557d                	li	a0,-1
}
    80005074:	60be                	ld	ra,456(sp)
    80005076:	641e                	ld	s0,448(sp)
    80005078:	74fa                	ld	s1,440(sp)
    8000507a:	795a                	ld	s2,432(sp)
    8000507c:	79ba                	ld	s3,424(sp)
    8000507e:	7a1a                	ld	s4,416(sp)
    80005080:	6afa                	ld	s5,408(sp)
    80005082:	6179                	addi	sp,sp,464
    80005084:	8082                	ret

0000000080005086 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005086:	7139                	addi	sp,sp,-64
    80005088:	fc06                	sd	ra,56(sp)
    8000508a:	f822                	sd	s0,48(sp)
    8000508c:	f426                	sd	s1,40(sp)
    8000508e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005090:	ffffc097          	auipc	ra,0xffffc
    80005094:	e22080e7          	jalr	-478(ra) # 80000eb2 <myproc>
    80005098:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000509a:	fd840593          	addi	a1,s0,-40
    8000509e:	4501                	li	a0,0
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	016080e7          	jalr	22(ra) # 800020b6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050a8:	fc840593          	addi	a1,s0,-56
    800050ac:	fd040513          	addi	a0,s0,-48
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	dd4080e7          	jalr	-556(ra) # 80003e84 <pipealloc>
    return -1;
    800050b8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050ba:	0c054963          	bltz	a0,8000518c <sys_pipe+0x106>
  fd0 = -1;
    800050be:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050c2:	fd043503          	ld	a0,-48(s0)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	516080e7          	jalr	1302(ra) # 800045dc <fdalloc>
    800050ce:	fca42223          	sw	a0,-60(s0)
    800050d2:	0a054063          	bltz	a0,80005172 <sys_pipe+0xec>
    800050d6:	fc843503          	ld	a0,-56(s0)
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	502080e7          	jalr	1282(ra) # 800045dc <fdalloc>
    800050e2:	fca42023          	sw	a0,-64(s0)
    800050e6:	06054c63          	bltz	a0,8000515e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ea:	4691                	li	a3,4
    800050ec:	fc440613          	addi	a2,s0,-60
    800050f0:	fd843583          	ld	a1,-40(s0)
    800050f4:	1884b503          	ld	a0,392(s1)
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	a42080e7          	jalr	-1470(ra) # 80000b3a <copyout>
    80005100:	02054163          	bltz	a0,80005122 <sys_pipe+0x9c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005104:	4691                	li	a3,4
    80005106:	fc040613          	addi	a2,s0,-64
    8000510a:	fd843583          	ld	a1,-40(s0)
    8000510e:	0591                	addi	a1,a1,4
    80005110:	1884b503          	ld	a0,392(s1)
    80005114:	ffffc097          	auipc	ra,0xffffc
    80005118:	a26080e7          	jalr	-1498(ra) # 80000b3a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000511c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511e:	06055763          	bgez	a0,8000518c <sys_pipe+0x106>
    p->ofile[fd0] = 0;
    80005122:	fc442783          	lw	a5,-60(s0)
    80005126:	04078793          	addi	a5,a5,64
    8000512a:	078e                	slli	a5,a5,0x3
    8000512c:	97a6                	add	a5,a5,s1
    8000512e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005132:	fc042503          	lw	a0,-64(s0)
    80005136:	04050513          	addi	a0,a0,64
    8000513a:	050e                	slli	a0,a0,0x3
    8000513c:	94aa                	add	s1,s1,a0
    8000513e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005142:	fd043503          	ld	a0,-48(s0)
    80005146:	fffff097          	auipc	ra,0xfffff
    8000514a:	a0e080e7          	jalr	-1522(ra) # 80003b54 <fileclose>
    fileclose(wf);
    8000514e:	fc843503          	ld	a0,-56(s0)
    80005152:	fffff097          	auipc	ra,0xfffff
    80005156:	a02080e7          	jalr	-1534(ra) # 80003b54 <fileclose>
    return -1;
    8000515a:	57fd                	li	a5,-1
    8000515c:	a805                	j	8000518c <sys_pipe+0x106>
    if(fd0 >= 0)
    8000515e:	fc442783          	lw	a5,-60(s0)
    80005162:	0007c863          	bltz	a5,80005172 <sys_pipe+0xec>
      p->ofile[fd0] = 0;
    80005166:	04078793          	addi	a5,a5,64
    8000516a:	078e                	slli	a5,a5,0x3
    8000516c:	94be                	add	s1,s1,a5
    8000516e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005172:	fd043503          	ld	a0,-48(s0)
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	9de080e7          	jalr	-1570(ra) # 80003b54 <fileclose>
    fileclose(wf);
    8000517e:	fc843503          	ld	a0,-56(s0)
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	9d2080e7          	jalr	-1582(ra) # 80003b54 <fileclose>
    return -1;
    8000518a:	57fd                	li	a5,-1
}
    8000518c:	853e                	mv	a0,a5
    8000518e:	70e2                	ld	ra,56(sp)
    80005190:	7442                	ld	s0,48(sp)
    80005192:	74a2                	ld	s1,40(sp)
    80005194:	6121                	addi	sp,sp,64
    80005196:	8082                	ret
	...

00000000800051a0 <kernelvec>:
    800051a0:	7111                	addi	sp,sp,-256
    800051a2:	e006                	sd	ra,0(sp)
    800051a4:	e40a                	sd	sp,8(sp)
    800051a6:	e80e                	sd	gp,16(sp)
    800051a8:	ec12                	sd	tp,24(sp)
    800051aa:	f016                	sd	t0,32(sp)
    800051ac:	f41a                	sd	t1,40(sp)
    800051ae:	f81e                	sd	t2,48(sp)
    800051b0:	fc22                	sd	s0,56(sp)
    800051b2:	e0a6                	sd	s1,64(sp)
    800051b4:	e4aa                	sd	a0,72(sp)
    800051b6:	e8ae                	sd	a1,80(sp)
    800051b8:	ecb2                	sd	a2,88(sp)
    800051ba:	f0b6                	sd	a3,96(sp)
    800051bc:	f4ba                	sd	a4,104(sp)
    800051be:	f8be                	sd	a5,112(sp)
    800051c0:	fcc2                	sd	a6,120(sp)
    800051c2:	e146                	sd	a7,128(sp)
    800051c4:	e54a                	sd	s2,136(sp)
    800051c6:	e94e                	sd	s3,144(sp)
    800051c8:	ed52                	sd	s4,152(sp)
    800051ca:	f156                	sd	s5,160(sp)
    800051cc:	f55a                	sd	s6,168(sp)
    800051ce:	f95e                	sd	s7,176(sp)
    800051d0:	fd62                	sd	s8,184(sp)
    800051d2:	e1e6                	sd	s9,192(sp)
    800051d4:	e5ea                	sd	s10,200(sp)
    800051d6:	e9ee                	sd	s11,208(sp)
    800051d8:	edf2                	sd	t3,216(sp)
    800051da:	f1f6                	sd	t4,224(sp)
    800051dc:	f5fa                	sd	t5,232(sp)
    800051de:	f9fe                	sd	t6,240(sp)
    800051e0:	cd1fc0ef          	jal	ra,80001eb0 <kerneltrap>
    800051e4:	6082                	ld	ra,0(sp)
    800051e6:	6122                	ld	sp,8(sp)
    800051e8:	61c2                	ld	gp,16(sp)
    800051ea:	7282                	ld	t0,32(sp)
    800051ec:	7322                	ld	t1,40(sp)
    800051ee:	73c2                	ld	t2,48(sp)
    800051f0:	7462                	ld	s0,56(sp)
    800051f2:	6486                	ld	s1,64(sp)
    800051f4:	6526                	ld	a0,72(sp)
    800051f6:	65c6                	ld	a1,80(sp)
    800051f8:	6666                	ld	a2,88(sp)
    800051fa:	7686                	ld	a3,96(sp)
    800051fc:	7726                	ld	a4,104(sp)
    800051fe:	77c6                	ld	a5,112(sp)
    80005200:	7866                	ld	a6,120(sp)
    80005202:	688a                	ld	a7,128(sp)
    80005204:	692a                	ld	s2,136(sp)
    80005206:	69ca                	ld	s3,144(sp)
    80005208:	6a6a                	ld	s4,152(sp)
    8000520a:	7a8a                	ld	s5,160(sp)
    8000520c:	7b2a                	ld	s6,168(sp)
    8000520e:	7bca                	ld	s7,176(sp)
    80005210:	7c6a                	ld	s8,184(sp)
    80005212:	6c8e                	ld	s9,192(sp)
    80005214:	6d2e                	ld	s10,200(sp)
    80005216:	6dce                	ld	s11,208(sp)
    80005218:	6e6e                	ld	t3,216(sp)
    8000521a:	7e8e                	ld	t4,224(sp)
    8000521c:	7f2e                	ld	t5,232(sp)
    8000521e:	7fce                	ld	t6,240(sp)
    80005220:	6111                	addi	sp,sp,256
    80005222:	10200073          	sret
    80005226:	00000013          	nop
    8000522a:	00000013          	nop
    8000522e:	0001                	nop

0000000080005230 <timervec>:
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	e10c                	sd	a1,0(a0)
    80005236:	e510                	sd	a2,8(a0)
    80005238:	e914                	sd	a3,16(a0)
    8000523a:	6d0c                	ld	a1,24(a0)
    8000523c:	7110                	ld	a2,32(a0)
    8000523e:	6194                	ld	a3,0(a1)
    80005240:	96b2                	add	a3,a3,a2
    80005242:	e194                	sd	a3,0(a1)
    80005244:	4589                	li	a1,2
    80005246:	14459073          	csrw	sip,a1
    8000524a:	6914                	ld	a3,16(a0)
    8000524c:	6510                	ld	a2,8(a0)
    8000524e:	610c                	ld	a1,0(a0)
    80005250:	34051573          	csrrw	a0,mscratch,a0
    80005254:	30200073          	mret
	...

000000008000525a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000525a:	1141                	addi	sp,sp,-16
    8000525c:	e422                	sd	s0,8(sp)
    8000525e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005260:	0c0007b7          	lui	a5,0xc000
    80005264:	4705                	li	a4,1
    80005266:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005268:	c3d8                	sw	a4,4(a5)
}
    8000526a:	6422                	ld	s0,8(sp)
    8000526c:	0141                	addi	sp,sp,16
    8000526e:	8082                	ret

0000000080005270 <plicinithart>:

void
plicinithart(void)
{
    80005270:	1141                	addi	sp,sp,-16
    80005272:	e406                	sd	ra,8(sp)
    80005274:	e022                	sd	s0,0(sp)
    80005276:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	c0e080e7          	jalr	-1010(ra) # 80000e86 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005280:	0085171b          	slliw	a4,a0,0x8
    80005284:	0c0027b7          	lui	a5,0xc002
    80005288:	97ba                	add	a5,a5,a4
    8000528a:	40200713          	li	a4,1026
    8000528e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005292:	00d5151b          	slliw	a0,a0,0xd
    80005296:	0c2017b7          	lui	a5,0xc201
    8000529a:	953e                	add	a0,a0,a5
    8000529c:	00052023          	sw	zero,0(a0)
}
    800052a0:	60a2                	ld	ra,8(sp)
    800052a2:	6402                	ld	s0,0(sp)
    800052a4:	0141                	addi	sp,sp,16
    800052a6:	8082                	ret

00000000800052a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052a8:	1141                	addi	sp,sp,-16
    800052aa:	e406                	sd	ra,8(sp)
    800052ac:	e022                	sd	s0,0(sp)
    800052ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b0:	ffffc097          	auipc	ra,0xffffc
    800052b4:	bd6080e7          	jalr	-1066(ra) # 80000e86 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052b8:	00d5179b          	slliw	a5,a0,0xd
    800052bc:	0c201537          	lui	a0,0xc201
    800052c0:	953e                	add	a0,a0,a5
  return irq;
}
    800052c2:	4148                	lw	a0,4(a0)
    800052c4:	60a2                	ld	ra,8(sp)
    800052c6:	6402                	ld	s0,0(sp)
    800052c8:	0141                	addi	sp,sp,16
    800052ca:	8082                	ret

00000000800052cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052cc:	1101                	addi	sp,sp,-32
    800052ce:	ec06                	sd	ra,24(sp)
    800052d0:	e822                	sd	s0,16(sp)
    800052d2:	e426                	sd	s1,8(sp)
    800052d4:	1000                	addi	s0,sp,32
    800052d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	bae080e7          	jalr	-1106(ra) # 80000e86 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052e0:	00d5151b          	slliw	a0,a0,0xd
    800052e4:	0c2017b7          	lui	a5,0xc201
    800052e8:	97aa                	add	a5,a5,a0
    800052ea:	c3c4                	sw	s1,4(a5)
}
    800052ec:	60e2                	ld	ra,24(sp)
    800052ee:	6442                	ld	s0,16(sp)
    800052f0:	64a2                	ld	s1,8(sp)
    800052f2:	6105                	addi	sp,sp,32
    800052f4:	8082                	ret

00000000800052f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052f6:	1141                	addi	sp,sp,-16
    800052f8:	e406                	sd	ra,8(sp)
    800052fa:	e022                	sd	s0,0(sp)
    800052fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052fe:	479d                	li	a5,7
    80005300:	04a7cc63          	blt	a5,a0,80005358 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005304:	00019797          	auipc	a5,0x19
    80005308:	53c78793          	addi	a5,a5,1340 # 8001e840 <disk>
    8000530c:	97aa                	add	a5,a5,a0
    8000530e:	0187c783          	lbu	a5,24(a5)
    80005312:	ebb9                	bnez	a5,80005368 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005314:	00451613          	slli	a2,a0,0x4
    80005318:	00019797          	auipc	a5,0x19
    8000531c:	52878793          	addi	a5,a5,1320 # 8001e840 <disk>
    80005320:	6394                	ld	a3,0(a5)
    80005322:	96b2                	add	a3,a3,a2
    80005324:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005328:	6398                	ld	a4,0(a5)
    8000532a:	9732                	add	a4,a4,a2
    8000532c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005330:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005334:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005338:	953e                	add	a0,a0,a5
    8000533a:	4785                	li	a5,1
    8000533c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005340:	00019517          	auipc	a0,0x19
    80005344:	51850513          	addi	a0,a0,1304 # 8001e858 <disk+0x18>
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	2a8080e7          	jalr	680(ra) # 800015f0 <wakeup>
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret
    panic("free_desc 1");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	3b850513          	addi	a0,a0,952 # 80008710 <syscalls+0x300>
    80005360:	00001097          	auipc	ra,0x1
    80005364:	a72080e7          	jalr	-1422(ra) # 80005dd2 <panic>
    panic("free_desc 2");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	3b850513          	addi	a0,a0,952 # 80008720 <syscalls+0x310>
    80005370:	00001097          	auipc	ra,0x1
    80005374:	a62080e7          	jalr	-1438(ra) # 80005dd2 <panic>

0000000080005378 <virtio_disk_init>:
{
    80005378:	1101                	addi	sp,sp,-32
    8000537a:	ec06                	sd	ra,24(sp)
    8000537c:	e822                	sd	s0,16(sp)
    8000537e:	e426                	sd	s1,8(sp)
    80005380:	e04a                	sd	s2,0(sp)
    80005382:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005384:	00003597          	auipc	a1,0x3
    80005388:	3ac58593          	addi	a1,a1,940 # 80008730 <syscalls+0x320>
    8000538c:	00019517          	auipc	a0,0x19
    80005390:	5dc50513          	addi	a0,a0,1500 # 8001e968 <disk+0x128>
    80005394:	00001097          	auipc	ra,0x1
    80005398:	f54080e7          	jalr	-172(ra) # 800062e8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	4398                	lw	a4,0(a5)
    800053a2:	2701                	sext.w	a4,a4
    800053a4:	747277b7          	lui	a5,0x74727
    800053a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053ac:	14f71e63          	bne	a4,a5,80005508 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053b0:	100017b7          	lui	a5,0x10001
    800053b4:	43dc                	lw	a5,4(a5)
    800053b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b8:	4709                	li	a4,2
    800053ba:	14e79763          	bne	a5,a4,80005508 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053be:	100017b7          	lui	a5,0x10001
    800053c2:	479c                	lw	a5,8(a5)
    800053c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053c6:	14e79163          	bne	a5,a4,80005508 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053ca:	100017b7          	lui	a5,0x10001
    800053ce:	47d8                	lw	a4,12(a5)
    800053d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d2:	554d47b7          	lui	a5,0x554d4
    800053d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053da:	12f71763          	bne	a4,a5,80005508 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053de:	100017b7          	lui	a5,0x10001
    800053e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e6:	4705                	li	a4,1
    800053e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ea:	470d                	li	a4,3
    800053ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053ee:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053f0:	c7ffe737          	lui	a4,0xc7ffe
    800053f4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd7b9f>
    800053f8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053fa:	2701                	sext.w	a4,a4
    800053fc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fe:	472d                	li	a4,11
    80005400:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005402:	0707a903          	lw	s2,112(a5)
    80005406:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005408:	00897793          	andi	a5,s2,8
    8000540c:	10078663          	beqz	a5,80005518 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005410:	100017b7          	lui	a5,0x10001
    80005414:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005418:	43fc                	lw	a5,68(a5)
    8000541a:	2781                	sext.w	a5,a5
    8000541c:	10079663          	bnez	a5,80005528 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005420:	100017b7          	lui	a5,0x10001
    80005424:	5bdc                	lw	a5,52(a5)
    80005426:	2781                	sext.w	a5,a5
  if(max == 0)
    80005428:	10078863          	beqz	a5,80005538 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000542c:	471d                	li	a4,7
    8000542e:	10f77d63          	bgeu	a4,a5,80005548 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005432:	ffffb097          	auipc	ra,0xffffb
    80005436:	ce6080e7          	jalr	-794(ra) # 80000118 <kalloc>
    8000543a:	00019497          	auipc	s1,0x19
    8000543e:	40648493          	addi	s1,s1,1030 # 8001e840 <disk>
    80005442:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005444:	ffffb097          	auipc	ra,0xffffb
    80005448:	cd4080e7          	jalr	-812(ra) # 80000118 <kalloc>
    8000544c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000544e:	ffffb097          	auipc	ra,0xffffb
    80005452:	cca080e7          	jalr	-822(ra) # 80000118 <kalloc>
    80005456:	87aa                	mv	a5,a0
    80005458:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000545a:	6088                	ld	a0,0(s1)
    8000545c:	cd75                	beqz	a0,80005558 <virtio_disk_init+0x1e0>
    8000545e:	00019717          	auipc	a4,0x19
    80005462:	3ea73703          	ld	a4,1002(a4) # 8001e848 <disk+0x8>
    80005466:	cb6d                	beqz	a4,80005558 <virtio_disk_init+0x1e0>
    80005468:	cbe5                	beqz	a5,80005558 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000546a:	6605                	lui	a2,0x1
    8000546c:	4581                	li	a1,0
    8000546e:	ffffb097          	auipc	ra,0xffffb
    80005472:	d0a080e7          	jalr	-758(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005476:	00019497          	auipc	s1,0x19
    8000547a:	3ca48493          	addi	s1,s1,970 # 8001e840 <disk>
    8000547e:	6605                	lui	a2,0x1
    80005480:	4581                	li	a1,0
    80005482:	6488                	ld	a0,8(s1)
    80005484:	ffffb097          	auipc	ra,0xffffb
    80005488:	cf4080e7          	jalr	-780(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000548c:	6605                	lui	a2,0x1
    8000548e:	4581                	li	a1,0
    80005490:	6888                	ld	a0,16(s1)
    80005492:	ffffb097          	auipc	ra,0xffffb
    80005496:	ce6080e7          	jalr	-794(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000549a:	100017b7          	lui	a5,0x10001
    8000549e:	4721                	li	a4,8
    800054a0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054a2:	4098                	lw	a4,0(s1)
    800054a4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054a8:	40d8                	lw	a4,4(s1)
    800054aa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054ae:	6498                	ld	a4,8(s1)
    800054b0:	0007069b          	sext.w	a3,a4
    800054b4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054b8:	9701                	srai	a4,a4,0x20
    800054ba:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054be:	6898                	ld	a4,16(s1)
    800054c0:	0007069b          	sext.w	a3,a4
    800054c4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054c8:	9701                	srai	a4,a4,0x20
    800054ca:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054ce:	4685                	li	a3,1
    800054d0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800054d2:	4705                	li	a4,1
    800054d4:	00d48c23          	sb	a3,24(s1)
    800054d8:	00e48ca3          	sb	a4,25(s1)
    800054dc:	00e48d23          	sb	a4,26(s1)
    800054e0:	00e48da3          	sb	a4,27(s1)
    800054e4:	00e48e23          	sb	a4,28(s1)
    800054e8:	00e48ea3          	sb	a4,29(s1)
    800054ec:	00e48f23          	sb	a4,30(s1)
    800054f0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054f4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f8:	0727a823          	sw	s2,112(a5)
}
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6902                	ld	s2,0(sp)
    80005504:	6105                	addi	sp,sp,32
    80005506:	8082                	ret
    panic("could not find virtio disk");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	23850513          	addi	a0,a0,568 # 80008740 <syscalls+0x330>
    80005510:	00001097          	auipc	ra,0x1
    80005514:	8c2080e7          	jalr	-1854(ra) # 80005dd2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005518:	00003517          	auipc	a0,0x3
    8000551c:	24850513          	addi	a0,a0,584 # 80008760 <syscalls+0x350>
    80005520:	00001097          	auipc	ra,0x1
    80005524:	8b2080e7          	jalr	-1870(ra) # 80005dd2 <panic>
    panic("virtio disk should not be ready");
    80005528:	00003517          	auipc	a0,0x3
    8000552c:	25850513          	addi	a0,a0,600 # 80008780 <syscalls+0x370>
    80005530:	00001097          	auipc	ra,0x1
    80005534:	8a2080e7          	jalr	-1886(ra) # 80005dd2 <panic>
    panic("virtio disk has no queue 0");
    80005538:	00003517          	auipc	a0,0x3
    8000553c:	26850513          	addi	a0,a0,616 # 800087a0 <syscalls+0x390>
    80005540:	00001097          	auipc	ra,0x1
    80005544:	892080e7          	jalr	-1902(ra) # 80005dd2 <panic>
    panic("virtio disk max queue too short");
    80005548:	00003517          	auipc	a0,0x3
    8000554c:	27850513          	addi	a0,a0,632 # 800087c0 <syscalls+0x3b0>
    80005550:	00001097          	auipc	ra,0x1
    80005554:	882080e7          	jalr	-1918(ra) # 80005dd2 <panic>
    panic("virtio disk kalloc");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	28850513          	addi	a0,a0,648 # 800087e0 <syscalls+0x3d0>
    80005560:	00001097          	auipc	ra,0x1
    80005564:	872080e7          	jalr	-1934(ra) # 80005dd2 <panic>

0000000080005568 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005568:	7159                	addi	sp,sp,-112
    8000556a:	f486                	sd	ra,104(sp)
    8000556c:	f0a2                	sd	s0,96(sp)
    8000556e:	eca6                	sd	s1,88(sp)
    80005570:	e8ca                	sd	s2,80(sp)
    80005572:	e4ce                	sd	s3,72(sp)
    80005574:	e0d2                	sd	s4,64(sp)
    80005576:	fc56                	sd	s5,56(sp)
    80005578:	f85a                	sd	s6,48(sp)
    8000557a:	f45e                	sd	s7,40(sp)
    8000557c:	f062                	sd	s8,32(sp)
    8000557e:	ec66                	sd	s9,24(sp)
    80005580:	e86a                	sd	s10,16(sp)
    80005582:	1880                	addi	s0,sp,112
    80005584:	892a                	mv	s2,a0
    80005586:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005588:	00c52c83          	lw	s9,12(a0)
    8000558c:	001c9c9b          	slliw	s9,s9,0x1
    80005590:	1c82                	slli	s9,s9,0x20
    80005592:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005596:	00019517          	auipc	a0,0x19
    8000559a:	3d250513          	addi	a0,a0,978 # 8001e968 <disk+0x128>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	dda080e7          	jalr	-550(ra) # 80006378 <acquire>
  for(int i = 0; i < 3; i++){
    800055a6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800055aa:	00019b17          	auipc	s6,0x19
    800055ae:	296b0b13          	addi	s6,s6,662 # 8001e840 <disk>
  for(int i = 0; i < 3; i++){
    800055b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055b4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b6:	00019c17          	auipc	s8,0x19
    800055ba:	3b2c0c13          	addi	s8,s8,946 # 8001e968 <disk+0x128>
    800055be:	a8b5                	j	8000563a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800055c0:	00fb06b3          	add	a3,s6,a5
    800055c4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055c8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055ca:	0207c563          	bltz	a5,800055f4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800055ce:	2485                	addiw	s1,s1,1
    800055d0:	0711                	addi	a4,a4,4
    800055d2:	1f548a63          	beq	s1,s5,800057c6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800055d6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055d8:	00019697          	auipc	a3,0x19
    800055dc:	26868693          	addi	a3,a3,616 # 8001e840 <disk>
    800055e0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055e2:	0186c583          	lbu	a1,24(a3)
    800055e6:	fde9                	bnez	a1,800055c0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800055e8:	2785                	addiw	a5,a5,1
    800055ea:	0685                	addi	a3,a3,1
    800055ec:	ff779be3          	bne	a5,s7,800055e2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055f0:	57fd                	li	a5,-1
    800055f2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055f4:	02905a63          	blez	s1,80005628 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055f8:	f9042503          	lw	a0,-112(s0)
    800055fc:	00000097          	auipc	ra,0x0
    80005600:	cfa080e7          	jalr	-774(ra) # 800052f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005604:	4785                	li	a5,1
    80005606:	0297d163          	bge	a5,s1,80005628 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000560a:	f9442503          	lw	a0,-108(s0)
    8000560e:	00000097          	auipc	ra,0x0
    80005612:	ce8080e7          	jalr	-792(ra) # 800052f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005616:	4789                	li	a5,2
    80005618:	0097d863          	bge	a5,s1,80005628 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000561c:	f9842503          	lw	a0,-104(s0)
    80005620:	00000097          	auipc	ra,0x0
    80005624:	cd6080e7          	jalr	-810(ra) # 800052f6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005628:	85e2                	mv	a1,s8
    8000562a:	00019517          	auipc	a0,0x19
    8000562e:	22e50513          	addi	a0,a0,558 # 8001e858 <disk+0x18>
    80005632:	ffffc097          	auipc	ra,0xffffc
    80005636:	f58080e7          	jalr	-168(ra) # 8000158a <sleep>
  for(int i = 0; i < 3; i++){
    8000563a:	f9040713          	addi	a4,s0,-112
    8000563e:	84ce                	mv	s1,s3
    80005640:	bf59                	j	800055d6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005642:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005646:	00479693          	slli	a3,a5,0x4
    8000564a:	00019797          	auipc	a5,0x19
    8000564e:	1f678793          	addi	a5,a5,502 # 8001e840 <disk>
    80005652:	97b6                	add	a5,a5,a3
    80005654:	4685                	li	a3,1
    80005656:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005658:	00019597          	auipc	a1,0x19
    8000565c:	1e858593          	addi	a1,a1,488 # 8001e840 <disk>
    80005660:	00a60793          	addi	a5,a2,10
    80005664:	0792                	slli	a5,a5,0x4
    80005666:	97ae                	add	a5,a5,a1
    80005668:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000566c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005670:	f6070693          	addi	a3,a4,-160
    80005674:	619c                	ld	a5,0(a1)
    80005676:	97b6                	add	a5,a5,a3
    80005678:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000567a:	6188                	ld	a0,0(a1)
    8000567c:	96aa                	add	a3,a3,a0
    8000567e:	47c1                	li	a5,16
    80005680:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005682:	4785                	li	a5,1
    80005684:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005688:	f9442783          	lw	a5,-108(s0)
    8000568c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005690:	0792                	slli	a5,a5,0x4
    80005692:	953e                	add	a0,a0,a5
    80005694:	05890693          	addi	a3,s2,88
    80005698:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000569a:	6188                	ld	a0,0(a1)
    8000569c:	97aa                	add	a5,a5,a0
    8000569e:	40000693          	li	a3,1024
    800056a2:	c794                	sw	a3,8(a5)
  if(write)
    800056a4:	100d0d63          	beqz	s10,800057be <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056a8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056ac:	00c7d683          	lhu	a3,12(a5)
    800056b0:	0016e693          	ori	a3,a3,1
    800056b4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800056b8:	f9842583          	lw	a1,-104(s0)
    800056bc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056c0:	00019697          	auipc	a3,0x19
    800056c4:	18068693          	addi	a3,a3,384 # 8001e840 <disk>
    800056c8:	00260793          	addi	a5,a2,2
    800056cc:	0792                	slli	a5,a5,0x4
    800056ce:	97b6                	add	a5,a5,a3
    800056d0:	587d                	li	a6,-1
    800056d2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056d6:	0592                	slli	a1,a1,0x4
    800056d8:	952e                	add	a0,a0,a1
    800056da:	f9070713          	addi	a4,a4,-112
    800056de:	9736                	add	a4,a4,a3
    800056e0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800056e2:	6298                	ld	a4,0(a3)
    800056e4:	972e                	add	a4,a4,a1
    800056e6:	4585                	li	a1,1
    800056e8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056ea:	4509                	li	a0,2
    800056ec:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800056f0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056f4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800056f8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056fc:	6698                	ld	a4,8(a3)
    800056fe:	00275783          	lhu	a5,2(a4)
    80005702:	8b9d                	andi	a5,a5,7
    80005704:	0786                	slli	a5,a5,0x1
    80005706:	97ba                	add	a5,a5,a4
    80005708:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000570c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005710:	6698                	ld	a4,8(a3)
    80005712:	00275783          	lhu	a5,2(a4)
    80005716:	2785                	addiw	a5,a5,1
    80005718:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000571c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005728:	00492703          	lw	a4,4(s2)
    8000572c:	4785                	li	a5,1
    8000572e:	02f71163          	bne	a4,a5,80005750 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005732:	00019997          	auipc	s3,0x19
    80005736:	23698993          	addi	s3,s3,566 # 8001e968 <disk+0x128>
  while(b->disk == 1) {
    8000573a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000573c:	85ce                	mv	a1,s3
    8000573e:	854a                	mv	a0,s2
    80005740:	ffffc097          	auipc	ra,0xffffc
    80005744:	e4a080e7          	jalr	-438(ra) # 8000158a <sleep>
  while(b->disk == 1) {
    80005748:	00492783          	lw	a5,4(s2)
    8000574c:	fe9788e3          	beq	a5,s1,8000573c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005750:	f9042903          	lw	s2,-112(s0)
    80005754:	00290793          	addi	a5,s2,2
    80005758:	00479713          	slli	a4,a5,0x4
    8000575c:	00019797          	auipc	a5,0x19
    80005760:	0e478793          	addi	a5,a5,228 # 8001e840 <disk>
    80005764:	97ba                	add	a5,a5,a4
    80005766:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000576a:	00019997          	auipc	s3,0x19
    8000576e:	0d698993          	addi	s3,s3,214 # 8001e840 <disk>
    80005772:	00491713          	slli	a4,s2,0x4
    80005776:	0009b783          	ld	a5,0(s3)
    8000577a:	97ba                	add	a5,a5,a4
    8000577c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005780:	854a                	mv	a0,s2
    80005782:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005786:	00000097          	auipc	ra,0x0
    8000578a:	b70080e7          	jalr	-1168(ra) # 800052f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000578e:	8885                	andi	s1,s1,1
    80005790:	f0ed                	bnez	s1,80005772 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005792:	00019517          	auipc	a0,0x19
    80005796:	1d650513          	addi	a0,a0,470 # 8001e968 <disk+0x128>
    8000579a:	00001097          	auipc	ra,0x1
    8000579e:	c92080e7          	jalr	-878(ra) # 8000642c <release>
}
    800057a2:	70a6                	ld	ra,104(sp)
    800057a4:	7406                	ld	s0,96(sp)
    800057a6:	64e6                	ld	s1,88(sp)
    800057a8:	6946                	ld	s2,80(sp)
    800057aa:	69a6                	ld	s3,72(sp)
    800057ac:	6a06                	ld	s4,64(sp)
    800057ae:	7ae2                	ld	s5,56(sp)
    800057b0:	7b42                	ld	s6,48(sp)
    800057b2:	7ba2                	ld	s7,40(sp)
    800057b4:	7c02                	ld	s8,32(sp)
    800057b6:	6ce2                	ld	s9,24(sp)
    800057b8:	6d42                	ld	s10,16(sp)
    800057ba:	6165                	addi	sp,sp,112
    800057bc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057be:	4689                	li	a3,2
    800057c0:	00d79623          	sh	a3,12(a5)
    800057c4:	b5e5                	j	800056ac <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057c6:	f9042603          	lw	a2,-112(s0)
    800057ca:	00a60713          	addi	a4,a2,10
    800057ce:	0712                	slli	a4,a4,0x4
    800057d0:	00019517          	auipc	a0,0x19
    800057d4:	07850513          	addi	a0,a0,120 # 8001e848 <disk+0x8>
    800057d8:	953a                	add	a0,a0,a4
  if(write)
    800057da:	e60d14e3          	bnez	s10,80005642 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057de:	00a60793          	addi	a5,a2,10
    800057e2:	00479693          	slli	a3,a5,0x4
    800057e6:	00019797          	auipc	a5,0x19
    800057ea:	05a78793          	addi	a5,a5,90 # 8001e840 <disk>
    800057ee:	97b6                	add	a5,a5,a3
    800057f0:	0007a423          	sw	zero,8(a5)
    800057f4:	b595                	j	80005658 <virtio_disk_rw+0xf0>

00000000800057f6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057f6:	1101                	addi	sp,sp,-32
    800057f8:	ec06                	sd	ra,24(sp)
    800057fa:	e822                	sd	s0,16(sp)
    800057fc:	e426                	sd	s1,8(sp)
    800057fe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005800:	00019497          	auipc	s1,0x19
    80005804:	04048493          	addi	s1,s1,64 # 8001e840 <disk>
    80005808:	00019517          	auipc	a0,0x19
    8000580c:	16050513          	addi	a0,a0,352 # 8001e968 <disk+0x128>
    80005810:	00001097          	auipc	ra,0x1
    80005814:	b68080e7          	jalr	-1176(ra) # 80006378 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005818:	10001737          	lui	a4,0x10001
    8000581c:	533c                	lw	a5,96(a4)
    8000581e:	8b8d                	andi	a5,a5,3
    80005820:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005822:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005826:	689c                	ld	a5,16(s1)
    80005828:	0204d703          	lhu	a4,32(s1)
    8000582c:	0027d783          	lhu	a5,2(a5)
    80005830:	04f70863          	beq	a4,a5,80005880 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005834:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005838:	6898                	ld	a4,16(s1)
    8000583a:	0204d783          	lhu	a5,32(s1)
    8000583e:	8b9d                	andi	a5,a5,7
    80005840:	078e                	slli	a5,a5,0x3
    80005842:	97ba                	add	a5,a5,a4
    80005844:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005846:	00278713          	addi	a4,a5,2
    8000584a:	0712                	slli	a4,a4,0x4
    8000584c:	9726                	add	a4,a4,s1
    8000584e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005852:	e721                	bnez	a4,8000589a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005854:	0789                	addi	a5,a5,2
    80005856:	0792                	slli	a5,a5,0x4
    80005858:	97a6                	add	a5,a5,s1
    8000585a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000585c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005860:	ffffc097          	auipc	ra,0xffffc
    80005864:	d90080e7          	jalr	-624(ra) # 800015f0 <wakeup>

    disk.used_idx += 1;
    80005868:	0204d783          	lhu	a5,32(s1)
    8000586c:	2785                	addiw	a5,a5,1
    8000586e:	17c2                	slli	a5,a5,0x30
    80005870:	93c1                	srli	a5,a5,0x30
    80005872:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005876:	6898                	ld	a4,16(s1)
    80005878:	00275703          	lhu	a4,2(a4)
    8000587c:	faf71ce3          	bne	a4,a5,80005834 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005880:	00019517          	auipc	a0,0x19
    80005884:	0e850513          	addi	a0,a0,232 # 8001e968 <disk+0x128>
    80005888:	00001097          	auipc	ra,0x1
    8000588c:	ba4080e7          	jalr	-1116(ra) # 8000642c <release>
}
    80005890:	60e2                	ld	ra,24(sp)
    80005892:	6442                	ld	s0,16(sp)
    80005894:	64a2                	ld	s1,8(sp)
    80005896:	6105                	addi	sp,sp,32
    80005898:	8082                	ret
      panic("virtio_disk_intr status");
    8000589a:	00003517          	auipc	a0,0x3
    8000589e:	f5e50513          	addi	a0,a0,-162 # 800087f8 <syscalls+0x3e8>
    800058a2:	00000097          	auipc	ra,0x0
    800058a6:	530080e7          	jalr	1328(ra) # 80005dd2 <panic>

00000000800058aa <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058aa:	1141                	addi	sp,sp,-16
    800058ac:	e422                	sd	s0,8(sp)
    800058ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058b0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058b4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b8:	0037979b          	slliw	a5,a5,0x3
    800058bc:	02004737          	lui	a4,0x2004
    800058c0:	97ba                	add	a5,a5,a4
    800058c2:	0200c737          	lui	a4,0x200c
    800058c6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058ca:	000f4637          	lui	a2,0xf4
    800058ce:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058d2:	95b2                	add	a1,a1,a2
    800058d4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058d6:	00269713          	slli	a4,a3,0x2
    800058da:	9736                	add	a4,a4,a3
    800058dc:	00371693          	slli	a3,a4,0x3
    800058e0:	00019717          	auipc	a4,0x19
    800058e4:	0a070713          	addi	a4,a4,160 # 8001e980 <timer_scratch>
    800058e8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058ea:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058ec:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ee:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058f2:	00000797          	auipc	a5,0x0
    800058f6:	93e78793          	addi	a5,a5,-1730 # 80005230 <timervec>
    800058fa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fe:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005902:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005906:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000590a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000590e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005912:	30479073          	csrw	mie,a5
}
    80005916:	6422                	ld	s0,8(sp)
    80005918:	0141                	addi	sp,sp,16
    8000591a:	8082                	ret

000000008000591c <start>:
{
    8000591c:	1141                	addi	sp,sp,-16
    8000591e:	e406                	sd	ra,8(sp)
    80005920:	e022                	sd	s0,0(sp)
    80005922:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005924:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005928:	7779                	lui	a4,0xffffe
    8000592a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd7c3f>
    8000592e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005930:	6705                	lui	a4,0x1
    80005932:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005936:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005938:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000593c:	ffffb797          	auipc	a5,0xffffb
    80005940:	9ea78793          	addi	a5,a5,-1558 # 80000326 <main>
    80005944:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005948:	4781                	li	a5,0
    8000594a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000594e:	67c1                	lui	a5,0x10
    80005950:	17fd                	addi	a5,a5,-1
    80005952:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005956:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000595a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000595e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005962:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005966:	57fd                	li	a5,-1
    80005968:	83a9                	srli	a5,a5,0xa
    8000596a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000596e:	47bd                	li	a5,15
    80005970:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005974:	00000097          	auipc	ra,0x0
    80005978:	f36080e7          	jalr	-202(ra) # 800058aa <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000597c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005980:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005982:	823e                	mv	tp,a5
  asm volatile("mret");
    80005984:	30200073          	mret
}
    80005988:	60a2                	ld	ra,8(sp)
    8000598a:	6402                	ld	s0,0(sp)
    8000598c:	0141                	addi	sp,sp,16
    8000598e:	8082                	ret

0000000080005990 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005990:	715d                	addi	sp,sp,-80
    80005992:	e486                	sd	ra,72(sp)
    80005994:	e0a2                	sd	s0,64(sp)
    80005996:	fc26                	sd	s1,56(sp)
    80005998:	f84a                	sd	s2,48(sp)
    8000599a:	f44e                	sd	s3,40(sp)
    8000599c:	f052                	sd	s4,32(sp)
    8000599e:	ec56                	sd	s5,24(sp)
    800059a0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059a2:	04c05663          	blez	a2,800059ee <consolewrite+0x5e>
    800059a6:	8a2a                	mv	s4,a0
    800059a8:	84ae                	mv	s1,a1
    800059aa:	89b2                	mv	s3,a2
    800059ac:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059ae:	5afd                	li	s5,-1
    800059b0:	4685                	li	a3,1
    800059b2:	8626                	mv	a2,s1
    800059b4:	85d2                	mv	a1,s4
    800059b6:	fbf40513          	addi	a0,s0,-65
    800059ba:	ffffc097          	auipc	ra,0xffffc
    800059be:	048080e7          	jalr	72(ra) # 80001a02 <either_copyin>
    800059c2:	01550c63          	beq	a0,s5,800059da <consolewrite+0x4a>
      break;
    uartputc(c);
    800059c6:	fbf44503          	lbu	a0,-65(s0)
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	7f0080e7          	jalr	2032(ra) # 800061ba <uartputc>
  for(i = 0; i < n; i++){
    800059d2:	2905                	addiw	s2,s2,1
    800059d4:	0485                	addi	s1,s1,1
    800059d6:	fd299de3          	bne	s3,s2,800059b0 <consolewrite+0x20>
  }

  return i;
}
    800059da:	854a                	mv	a0,s2
    800059dc:	60a6                	ld	ra,72(sp)
    800059de:	6406                	ld	s0,64(sp)
    800059e0:	74e2                	ld	s1,56(sp)
    800059e2:	7942                	ld	s2,48(sp)
    800059e4:	79a2                	ld	s3,40(sp)
    800059e6:	7a02                	ld	s4,32(sp)
    800059e8:	6ae2                	ld	s5,24(sp)
    800059ea:	6161                	addi	sp,sp,80
    800059ec:	8082                	ret
  for(i = 0; i < n; i++){
    800059ee:	4901                	li	s2,0
    800059f0:	b7ed                	j	800059da <consolewrite+0x4a>

00000000800059f2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059f2:	7119                	addi	sp,sp,-128
    800059f4:	fc86                	sd	ra,120(sp)
    800059f6:	f8a2                	sd	s0,112(sp)
    800059f8:	f4a6                	sd	s1,104(sp)
    800059fa:	f0ca                	sd	s2,96(sp)
    800059fc:	ecce                	sd	s3,88(sp)
    800059fe:	e8d2                	sd	s4,80(sp)
    80005a00:	e4d6                	sd	s5,72(sp)
    80005a02:	e0da                	sd	s6,64(sp)
    80005a04:	fc5e                	sd	s7,56(sp)
    80005a06:	f862                	sd	s8,48(sp)
    80005a08:	f466                	sd	s9,40(sp)
    80005a0a:	f06a                	sd	s10,32(sp)
    80005a0c:	ec6e                	sd	s11,24(sp)
    80005a0e:	0100                	addi	s0,sp,128
    80005a10:	8b2a                	mv	s6,a0
    80005a12:	8aae                	mv	s5,a1
    80005a14:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a16:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a1a:	00021517          	auipc	a0,0x21
    80005a1e:	0a650513          	addi	a0,a0,166 # 80026ac0 <cons>
    80005a22:	00001097          	auipc	ra,0x1
    80005a26:	956080e7          	jalr	-1706(ra) # 80006378 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a2a:	00021497          	auipc	s1,0x21
    80005a2e:	09648493          	addi	s1,s1,150 # 80026ac0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a32:	89a6                	mv	s3,s1
    80005a34:	00021917          	auipc	s2,0x21
    80005a38:	12490913          	addi	s2,s2,292 # 80026b58 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005a3c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a40:	4da9                	li	s11,10
  while(n > 0){
    80005a42:	07405b63          	blez	s4,80005ab8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005a46:	0984a783          	lw	a5,152(s1)
    80005a4a:	09c4a703          	lw	a4,156(s1)
    80005a4e:	02f71763          	bne	a4,a5,80005a7c <consoleread+0x8a>
      if(killed(myproc())){
    80005a52:	ffffb097          	auipc	ra,0xffffb
    80005a56:	460080e7          	jalr	1120(ra) # 80000eb2 <myproc>
    80005a5a:	ffffc097          	auipc	ra,0xffffc
    80005a5e:	dec080e7          	jalr	-532(ra) # 80001846 <killed>
    80005a62:	e535                	bnez	a0,80005ace <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005a64:	85ce                	mv	a1,s3
    80005a66:	854a                	mv	a0,s2
    80005a68:	ffffc097          	auipc	ra,0xffffc
    80005a6c:	b22080e7          	jalr	-1246(ra) # 8000158a <sleep>
    while(cons.r == cons.w){
    80005a70:	0984a783          	lw	a5,152(s1)
    80005a74:	09c4a703          	lw	a4,156(s1)
    80005a78:	fcf70de3          	beq	a4,a5,80005a52 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a7c:	0017871b          	addiw	a4,a5,1
    80005a80:	08e4ac23          	sw	a4,152(s1)
    80005a84:	07f7f713          	andi	a4,a5,127
    80005a88:	9726                	add	a4,a4,s1
    80005a8a:	01874703          	lbu	a4,24(a4)
    80005a8e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a92:	079c0663          	beq	s8,s9,80005afe <consoleread+0x10c>
    cbuf = c;
    80005a96:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a9a:	4685                	li	a3,1
    80005a9c:	f8f40613          	addi	a2,s0,-113
    80005aa0:	85d6                	mv	a1,s5
    80005aa2:	855a                	mv	a0,s6
    80005aa4:	ffffc097          	auipc	ra,0xffffc
    80005aa8:	f06080e7          	jalr	-250(ra) # 800019aa <either_copyout>
    80005aac:	01a50663          	beq	a0,s10,80005ab8 <consoleread+0xc6>
    dst++;
    80005ab0:	0a85                	addi	s5,s5,1
    --n;
    80005ab2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005ab4:	f9bc17e3          	bne	s8,s11,80005a42 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ab8:	00021517          	auipc	a0,0x21
    80005abc:	00850513          	addi	a0,a0,8 # 80026ac0 <cons>
    80005ac0:	00001097          	auipc	ra,0x1
    80005ac4:	96c080e7          	jalr	-1684(ra) # 8000642c <release>

  return target - n;
    80005ac8:	414b853b          	subw	a0,s7,s4
    80005acc:	a811                	j	80005ae0 <consoleread+0xee>
        release(&cons.lock);
    80005ace:	00021517          	auipc	a0,0x21
    80005ad2:	ff250513          	addi	a0,a0,-14 # 80026ac0 <cons>
    80005ad6:	00001097          	auipc	ra,0x1
    80005ada:	956080e7          	jalr	-1706(ra) # 8000642c <release>
        return -1;
    80005ade:	557d                	li	a0,-1
}
    80005ae0:	70e6                	ld	ra,120(sp)
    80005ae2:	7446                	ld	s0,112(sp)
    80005ae4:	74a6                	ld	s1,104(sp)
    80005ae6:	7906                	ld	s2,96(sp)
    80005ae8:	69e6                	ld	s3,88(sp)
    80005aea:	6a46                	ld	s4,80(sp)
    80005aec:	6aa6                	ld	s5,72(sp)
    80005aee:	6b06                	ld	s6,64(sp)
    80005af0:	7be2                	ld	s7,56(sp)
    80005af2:	7c42                	ld	s8,48(sp)
    80005af4:	7ca2                	ld	s9,40(sp)
    80005af6:	7d02                	ld	s10,32(sp)
    80005af8:	6de2                	ld	s11,24(sp)
    80005afa:	6109                	addi	sp,sp,128
    80005afc:	8082                	ret
      if(n < target){
    80005afe:	000a071b          	sext.w	a4,s4
    80005b02:	fb777be3          	bgeu	a4,s7,80005ab8 <consoleread+0xc6>
        cons.r--;
    80005b06:	00021717          	auipc	a4,0x21
    80005b0a:	04f72923          	sw	a5,82(a4) # 80026b58 <cons+0x98>
    80005b0e:	b76d                	j	80005ab8 <consoleread+0xc6>

0000000080005b10 <consputc>:
{
    80005b10:	1141                	addi	sp,sp,-16
    80005b12:	e406                	sd	ra,8(sp)
    80005b14:	e022                	sd	s0,0(sp)
    80005b16:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b18:	10000793          	li	a5,256
    80005b1c:	00f50a63          	beq	a0,a5,80005b30 <consputc+0x20>
    uartputc_sync(c);
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	5c0080e7          	jalr	1472(ra) # 800060e0 <uartputc_sync>
}
    80005b28:	60a2                	ld	ra,8(sp)
    80005b2a:	6402                	ld	s0,0(sp)
    80005b2c:	0141                	addi	sp,sp,16
    80005b2e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b30:	4521                	li	a0,8
    80005b32:	00000097          	auipc	ra,0x0
    80005b36:	5ae080e7          	jalr	1454(ra) # 800060e0 <uartputc_sync>
    80005b3a:	02000513          	li	a0,32
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	5a2080e7          	jalr	1442(ra) # 800060e0 <uartputc_sync>
    80005b46:	4521                	li	a0,8
    80005b48:	00000097          	auipc	ra,0x0
    80005b4c:	598080e7          	jalr	1432(ra) # 800060e0 <uartputc_sync>
    80005b50:	bfe1                	j	80005b28 <consputc+0x18>

0000000080005b52 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b52:	1101                	addi	sp,sp,-32
    80005b54:	ec06                	sd	ra,24(sp)
    80005b56:	e822                	sd	s0,16(sp)
    80005b58:	e426                	sd	s1,8(sp)
    80005b5a:	e04a                	sd	s2,0(sp)
    80005b5c:	1000                	addi	s0,sp,32
    80005b5e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b60:	00021517          	auipc	a0,0x21
    80005b64:	f6050513          	addi	a0,a0,-160 # 80026ac0 <cons>
    80005b68:	00001097          	auipc	ra,0x1
    80005b6c:	810080e7          	jalr	-2032(ra) # 80006378 <acquire>

  switch(c){
    80005b70:	47d5                	li	a5,21
    80005b72:	0af48663          	beq	s1,a5,80005c1e <consoleintr+0xcc>
    80005b76:	0297ca63          	blt	a5,s1,80005baa <consoleintr+0x58>
    80005b7a:	47a1                	li	a5,8
    80005b7c:	0ef48763          	beq	s1,a5,80005c6a <consoleintr+0x118>
    80005b80:	47c1                	li	a5,16
    80005b82:	10f49a63          	bne	s1,a5,80005c96 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b86:	ffffc097          	auipc	ra,0xffffc
    80005b8a:	ed4080e7          	jalr	-300(ra) # 80001a5a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b8e:	00021517          	auipc	a0,0x21
    80005b92:	f3250513          	addi	a0,a0,-206 # 80026ac0 <cons>
    80005b96:	00001097          	auipc	ra,0x1
    80005b9a:	896080e7          	jalr	-1898(ra) # 8000642c <release>
}
    80005b9e:	60e2                	ld	ra,24(sp)
    80005ba0:	6442                	ld	s0,16(sp)
    80005ba2:	64a2                	ld	s1,8(sp)
    80005ba4:	6902                	ld	s2,0(sp)
    80005ba6:	6105                	addi	sp,sp,32
    80005ba8:	8082                	ret
  switch(c){
    80005baa:	07f00793          	li	a5,127
    80005bae:	0af48e63          	beq	s1,a5,80005c6a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bb2:	00021717          	auipc	a4,0x21
    80005bb6:	f0e70713          	addi	a4,a4,-242 # 80026ac0 <cons>
    80005bba:	0a072783          	lw	a5,160(a4)
    80005bbe:	09872703          	lw	a4,152(a4)
    80005bc2:	9f99                	subw	a5,a5,a4
    80005bc4:	07f00713          	li	a4,127
    80005bc8:	fcf763e3          	bltu	a4,a5,80005b8e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bcc:	47b5                	li	a5,13
    80005bce:	0cf48763          	beq	s1,a5,80005c9c <consoleintr+0x14a>
      consputc(c);
    80005bd2:	8526                	mv	a0,s1
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	f3c080e7          	jalr	-196(ra) # 80005b10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bdc:	00021797          	auipc	a5,0x21
    80005be0:	ee478793          	addi	a5,a5,-284 # 80026ac0 <cons>
    80005be4:	0a07a683          	lw	a3,160(a5)
    80005be8:	0016871b          	addiw	a4,a3,1
    80005bec:	0007061b          	sext.w	a2,a4
    80005bf0:	0ae7a023          	sw	a4,160(a5)
    80005bf4:	07f6f693          	andi	a3,a3,127
    80005bf8:	97b6                	add	a5,a5,a3
    80005bfa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005bfe:	47a9                	li	a5,10
    80005c00:	0cf48563          	beq	s1,a5,80005cca <consoleintr+0x178>
    80005c04:	4791                	li	a5,4
    80005c06:	0cf48263          	beq	s1,a5,80005cca <consoleintr+0x178>
    80005c0a:	00021797          	auipc	a5,0x21
    80005c0e:	f4e7a783          	lw	a5,-178(a5) # 80026b58 <cons+0x98>
    80005c12:	9f1d                	subw	a4,a4,a5
    80005c14:	08000793          	li	a5,128
    80005c18:	f6f71be3          	bne	a4,a5,80005b8e <consoleintr+0x3c>
    80005c1c:	a07d                	j	80005cca <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c1e:	00021717          	auipc	a4,0x21
    80005c22:	ea270713          	addi	a4,a4,-350 # 80026ac0 <cons>
    80005c26:	0a072783          	lw	a5,160(a4)
    80005c2a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c2e:	00021497          	auipc	s1,0x21
    80005c32:	e9248493          	addi	s1,s1,-366 # 80026ac0 <cons>
    while(cons.e != cons.w &&
    80005c36:	4929                	li	s2,10
    80005c38:	f4f70be3          	beq	a4,a5,80005b8e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c3c:	37fd                	addiw	a5,a5,-1
    80005c3e:	07f7f713          	andi	a4,a5,127
    80005c42:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c44:	01874703          	lbu	a4,24(a4)
    80005c48:	f52703e3          	beq	a4,s2,80005b8e <consoleintr+0x3c>
      cons.e--;
    80005c4c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c50:	10000513          	li	a0,256
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	ebc080e7          	jalr	-324(ra) # 80005b10 <consputc>
    while(cons.e != cons.w &&
    80005c5c:	0a04a783          	lw	a5,160(s1)
    80005c60:	09c4a703          	lw	a4,156(s1)
    80005c64:	fcf71ce3          	bne	a4,a5,80005c3c <consoleintr+0xea>
    80005c68:	b71d                	j	80005b8e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c6a:	00021717          	auipc	a4,0x21
    80005c6e:	e5670713          	addi	a4,a4,-426 # 80026ac0 <cons>
    80005c72:	0a072783          	lw	a5,160(a4)
    80005c76:	09c72703          	lw	a4,156(a4)
    80005c7a:	f0f70ae3          	beq	a4,a5,80005b8e <consoleintr+0x3c>
      cons.e--;
    80005c7e:	37fd                	addiw	a5,a5,-1
    80005c80:	00021717          	auipc	a4,0x21
    80005c84:	eef72023          	sw	a5,-288(a4) # 80026b60 <cons+0xa0>
      consputc(BACKSPACE);
    80005c88:	10000513          	li	a0,256
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	e84080e7          	jalr	-380(ra) # 80005b10 <consputc>
    80005c94:	bded                	j	80005b8e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c96:	ee048ce3          	beqz	s1,80005b8e <consoleintr+0x3c>
    80005c9a:	bf21                	j	80005bb2 <consoleintr+0x60>
      consputc(c);
    80005c9c:	4529                	li	a0,10
    80005c9e:	00000097          	auipc	ra,0x0
    80005ca2:	e72080e7          	jalr	-398(ra) # 80005b10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ca6:	00021797          	auipc	a5,0x21
    80005caa:	e1a78793          	addi	a5,a5,-486 # 80026ac0 <cons>
    80005cae:	0a07a703          	lw	a4,160(a5)
    80005cb2:	0017069b          	addiw	a3,a4,1
    80005cb6:	0006861b          	sext.w	a2,a3
    80005cba:	0ad7a023          	sw	a3,160(a5)
    80005cbe:	07f77713          	andi	a4,a4,127
    80005cc2:	97ba                	add	a5,a5,a4
    80005cc4:	4729                	li	a4,10
    80005cc6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cca:	00021797          	auipc	a5,0x21
    80005cce:	e8c7a923          	sw	a2,-366(a5) # 80026b5c <cons+0x9c>
        wakeup(&cons.r);
    80005cd2:	00021517          	auipc	a0,0x21
    80005cd6:	e8650513          	addi	a0,a0,-378 # 80026b58 <cons+0x98>
    80005cda:	ffffc097          	auipc	ra,0xffffc
    80005cde:	916080e7          	jalr	-1770(ra) # 800015f0 <wakeup>
    80005ce2:	b575                	j	80005b8e <consoleintr+0x3c>

0000000080005ce4 <consoleinit>:

void
consoleinit(void)
{
    80005ce4:	1141                	addi	sp,sp,-16
    80005ce6:	e406                	sd	ra,8(sp)
    80005ce8:	e022                	sd	s0,0(sp)
    80005cea:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cec:	00003597          	auipc	a1,0x3
    80005cf0:	b2458593          	addi	a1,a1,-1244 # 80008810 <syscalls+0x400>
    80005cf4:	00021517          	auipc	a0,0x21
    80005cf8:	dcc50513          	addi	a0,a0,-564 # 80026ac0 <cons>
    80005cfc:	00000097          	auipc	ra,0x0
    80005d00:	5ec080e7          	jalr	1516(ra) # 800062e8 <initlock>

  uartinit();
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	38c080e7          	jalr	908(ra) # 80006090 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d0c:	00018797          	auipc	a5,0x18
    80005d10:	adc78793          	addi	a5,a5,-1316 # 8001d7e8 <devsw>
    80005d14:	00000717          	auipc	a4,0x0
    80005d18:	cde70713          	addi	a4,a4,-802 # 800059f2 <consoleread>
    80005d1c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d1e:	00000717          	auipc	a4,0x0
    80005d22:	c7270713          	addi	a4,a4,-910 # 80005990 <consolewrite>
    80005d26:	ef98                	sd	a4,24(a5)
}
    80005d28:	60a2                	ld	ra,8(sp)
    80005d2a:	6402                	ld	s0,0(sp)
    80005d2c:	0141                	addi	sp,sp,16
    80005d2e:	8082                	ret

0000000080005d30 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d30:	7179                	addi	sp,sp,-48
    80005d32:	f406                	sd	ra,40(sp)
    80005d34:	f022                	sd	s0,32(sp)
    80005d36:	ec26                	sd	s1,24(sp)
    80005d38:	e84a                	sd	s2,16(sp)
    80005d3a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d3c:	c219                	beqz	a2,80005d42 <printint+0x12>
    80005d3e:	08054663          	bltz	a0,80005dca <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d42:	2501                	sext.w	a0,a0
    80005d44:	4881                	li	a7,0
    80005d46:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d4a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d4c:	2581                	sext.w	a1,a1
    80005d4e:	00003617          	auipc	a2,0x3
    80005d52:	b0a60613          	addi	a2,a2,-1270 # 80008858 <digits>
    80005d56:	883a                	mv	a6,a4
    80005d58:	2705                	addiw	a4,a4,1
    80005d5a:	02b577bb          	remuw	a5,a0,a1
    80005d5e:	1782                	slli	a5,a5,0x20
    80005d60:	9381                	srli	a5,a5,0x20
    80005d62:	97b2                	add	a5,a5,a2
    80005d64:	0007c783          	lbu	a5,0(a5)
    80005d68:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d6c:	0005079b          	sext.w	a5,a0
    80005d70:	02b5553b          	divuw	a0,a0,a1
    80005d74:	0685                	addi	a3,a3,1
    80005d76:	feb7f0e3          	bgeu	a5,a1,80005d56 <printint+0x26>

  if(sign)
    80005d7a:	00088b63          	beqz	a7,80005d90 <printint+0x60>
    buf[i++] = '-';
    80005d7e:	fe040793          	addi	a5,s0,-32
    80005d82:	973e                	add	a4,a4,a5
    80005d84:	02d00793          	li	a5,45
    80005d88:	fef70823          	sb	a5,-16(a4)
    80005d8c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d90:	02e05763          	blez	a4,80005dbe <printint+0x8e>
    80005d94:	fd040793          	addi	a5,s0,-48
    80005d98:	00e784b3          	add	s1,a5,a4
    80005d9c:	fff78913          	addi	s2,a5,-1
    80005da0:	993a                	add	s2,s2,a4
    80005da2:	377d                	addiw	a4,a4,-1
    80005da4:	1702                	slli	a4,a4,0x20
    80005da6:	9301                	srli	a4,a4,0x20
    80005da8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dac:	fff4c503          	lbu	a0,-1(s1)
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	d60080e7          	jalr	-672(ra) # 80005b10 <consputc>
  while(--i >= 0)
    80005db8:	14fd                	addi	s1,s1,-1
    80005dba:	ff2499e3          	bne	s1,s2,80005dac <printint+0x7c>
}
    80005dbe:	70a2                	ld	ra,40(sp)
    80005dc0:	7402                	ld	s0,32(sp)
    80005dc2:	64e2                	ld	s1,24(sp)
    80005dc4:	6942                	ld	s2,16(sp)
    80005dc6:	6145                	addi	sp,sp,48
    80005dc8:	8082                	ret
    x = -xx;
    80005dca:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dce:	4885                	li	a7,1
    x = -xx;
    80005dd0:	bf9d                	j	80005d46 <printint+0x16>

0000000080005dd2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dd2:	1101                	addi	sp,sp,-32
    80005dd4:	ec06                	sd	ra,24(sp)
    80005dd6:	e822                	sd	s0,16(sp)
    80005dd8:	e426                	sd	s1,8(sp)
    80005dda:	1000                	addi	s0,sp,32
    80005ddc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dde:	00021797          	auipc	a5,0x21
    80005de2:	da07a123          	sw	zero,-606(a5) # 80026b80 <pr+0x18>
  printf("panic: ");
    80005de6:	00003517          	auipc	a0,0x3
    80005dea:	a3250513          	addi	a0,a0,-1486 # 80008818 <syscalls+0x408>
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	02e080e7          	jalr	46(ra) # 80005e1c <printf>
  printf(s);
    80005df6:	8526                	mv	a0,s1
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	024080e7          	jalr	36(ra) # 80005e1c <printf>
  printf("\n");
    80005e00:	00002517          	auipc	a0,0x2
    80005e04:	24850513          	addi	a0,a0,584 # 80008048 <etext+0x48>
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	014080e7          	jalr	20(ra) # 80005e1c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e10:	4785                	li	a5,1
    80005e12:	00003717          	auipc	a4,0x3
    80005e16:	b2f72523          	sw	a5,-1238(a4) # 8000893c <panicked>
  for(;;)
    80005e1a:	a001                	j	80005e1a <panic+0x48>

0000000080005e1c <printf>:
{
    80005e1c:	7131                	addi	sp,sp,-192
    80005e1e:	fc86                	sd	ra,120(sp)
    80005e20:	f8a2                	sd	s0,112(sp)
    80005e22:	f4a6                	sd	s1,104(sp)
    80005e24:	f0ca                	sd	s2,96(sp)
    80005e26:	ecce                	sd	s3,88(sp)
    80005e28:	e8d2                	sd	s4,80(sp)
    80005e2a:	e4d6                	sd	s5,72(sp)
    80005e2c:	e0da                	sd	s6,64(sp)
    80005e2e:	fc5e                	sd	s7,56(sp)
    80005e30:	f862                	sd	s8,48(sp)
    80005e32:	f466                	sd	s9,40(sp)
    80005e34:	f06a                	sd	s10,32(sp)
    80005e36:	ec6e                	sd	s11,24(sp)
    80005e38:	0100                	addi	s0,sp,128
    80005e3a:	8a2a                	mv	s4,a0
    80005e3c:	e40c                	sd	a1,8(s0)
    80005e3e:	e810                	sd	a2,16(s0)
    80005e40:	ec14                	sd	a3,24(s0)
    80005e42:	f018                	sd	a4,32(s0)
    80005e44:	f41c                	sd	a5,40(s0)
    80005e46:	03043823          	sd	a6,48(s0)
    80005e4a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e4e:	00021d97          	auipc	s11,0x21
    80005e52:	d32dad83          	lw	s11,-718(s11) # 80026b80 <pr+0x18>
  if(locking)
    80005e56:	020d9b63          	bnez	s11,80005e8c <printf+0x70>
  if (fmt == 0)
    80005e5a:	040a0263          	beqz	s4,80005e9e <printf+0x82>
  va_start(ap, fmt);
    80005e5e:	00840793          	addi	a5,s0,8
    80005e62:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e66:	000a4503          	lbu	a0,0(s4)
    80005e6a:	16050263          	beqz	a0,80005fce <printf+0x1b2>
    80005e6e:	4481                	li	s1,0
    if(c != '%'){
    80005e70:	02500a93          	li	s5,37
    switch(c){
    80005e74:	07000b13          	li	s6,112
  consputc('x');
    80005e78:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e7a:	00003b97          	auipc	s7,0x3
    80005e7e:	9deb8b93          	addi	s7,s7,-1570 # 80008858 <digits>
    switch(c){
    80005e82:	07300c93          	li	s9,115
    80005e86:	06400c13          	li	s8,100
    80005e8a:	a82d                	j	80005ec4 <printf+0xa8>
    acquire(&pr.lock);
    80005e8c:	00021517          	auipc	a0,0x21
    80005e90:	cdc50513          	addi	a0,a0,-804 # 80026b68 <pr>
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	4e4080e7          	jalr	1252(ra) # 80006378 <acquire>
    80005e9c:	bf7d                	j	80005e5a <printf+0x3e>
    panic("null fmt");
    80005e9e:	00003517          	auipc	a0,0x3
    80005ea2:	98a50513          	addi	a0,a0,-1654 # 80008828 <syscalls+0x418>
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	f2c080e7          	jalr	-212(ra) # 80005dd2 <panic>
      consputc(c);
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	c62080e7          	jalr	-926(ra) # 80005b10 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eb6:	2485                	addiw	s1,s1,1
    80005eb8:	009a07b3          	add	a5,s4,s1
    80005ebc:	0007c503          	lbu	a0,0(a5)
    80005ec0:	10050763          	beqz	a0,80005fce <printf+0x1b2>
    if(c != '%'){
    80005ec4:	ff5515e3          	bne	a0,s5,80005eae <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ec8:	2485                	addiw	s1,s1,1
    80005eca:	009a07b3          	add	a5,s4,s1
    80005ece:	0007c783          	lbu	a5,0(a5)
    80005ed2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ed6:	cfe5                	beqz	a5,80005fce <printf+0x1b2>
    switch(c){
    80005ed8:	05678a63          	beq	a5,s6,80005f2c <printf+0x110>
    80005edc:	02fb7663          	bgeu	s6,a5,80005f08 <printf+0xec>
    80005ee0:	09978963          	beq	a5,s9,80005f72 <printf+0x156>
    80005ee4:	07800713          	li	a4,120
    80005ee8:	0ce79863          	bne	a5,a4,80005fb8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005eec:	f8843783          	ld	a5,-120(s0)
    80005ef0:	00878713          	addi	a4,a5,8
    80005ef4:	f8e43423          	sd	a4,-120(s0)
    80005ef8:	4605                	li	a2,1
    80005efa:	85ea                	mv	a1,s10
    80005efc:	4388                	lw	a0,0(a5)
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	e32080e7          	jalr	-462(ra) # 80005d30 <printint>
      break;
    80005f06:	bf45                	j	80005eb6 <printf+0x9a>
    switch(c){
    80005f08:	0b578263          	beq	a5,s5,80005fac <printf+0x190>
    80005f0c:	0b879663          	bne	a5,s8,80005fb8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f10:	f8843783          	ld	a5,-120(s0)
    80005f14:	00878713          	addi	a4,a5,8
    80005f18:	f8e43423          	sd	a4,-120(s0)
    80005f1c:	4605                	li	a2,1
    80005f1e:	45a9                	li	a1,10
    80005f20:	4388                	lw	a0,0(a5)
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	e0e080e7          	jalr	-498(ra) # 80005d30 <printint>
      break;
    80005f2a:	b771                	j	80005eb6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f2c:	f8843783          	ld	a5,-120(s0)
    80005f30:	00878713          	addi	a4,a5,8
    80005f34:	f8e43423          	sd	a4,-120(s0)
    80005f38:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f3c:	03000513          	li	a0,48
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	bd0080e7          	jalr	-1072(ra) # 80005b10 <consputc>
  consputc('x');
    80005f48:	07800513          	li	a0,120
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	bc4080e7          	jalr	-1084(ra) # 80005b10 <consputc>
    80005f54:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f56:	03c9d793          	srli	a5,s3,0x3c
    80005f5a:	97de                	add	a5,a5,s7
    80005f5c:	0007c503          	lbu	a0,0(a5)
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	bb0080e7          	jalr	-1104(ra) # 80005b10 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f68:	0992                	slli	s3,s3,0x4
    80005f6a:	397d                	addiw	s2,s2,-1
    80005f6c:	fe0915e3          	bnez	s2,80005f56 <printf+0x13a>
    80005f70:	b799                	j	80005eb6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f72:	f8843783          	ld	a5,-120(s0)
    80005f76:	00878713          	addi	a4,a5,8
    80005f7a:	f8e43423          	sd	a4,-120(s0)
    80005f7e:	0007b903          	ld	s2,0(a5)
    80005f82:	00090e63          	beqz	s2,80005f9e <printf+0x182>
      for(; *s; s++)
    80005f86:	00094503          	lbu	a0,0(s2)
    80005f8a:	d515                	beqz	a0,80005eb6 <printf+0x9a>
        consputc(*s);
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	b84080e7          	jalr	-1148(ra) # 80005b10 <consputc>
      for(; *s; s++)
    80005f94:	0905                	addi	s2,s2,1
    80005f96:	00094503          	lbu	a0,0(s2)
    80005f9a:	f96d                	bnez	a0,80005f8c <printf+0x170>
    80005f9c:	bf29                	j	80005eb6 <printf+0x9a>
        s = "(null)";
    80005f9e:	00003917          	auipc	s2,0x3
    80005fa2:	88290913          	addi	s2,s2,-1918 # 80008820 <syscalls+0x410>
      for(; *s; s++)
    80005fa6:	02800513          	li	a0,40
    80005faa:	b7cd                	j	80005f8c <printf+0x170>
      consputc('%');
    80005fac:	8556                	mv	a0,s5
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	b62080e7          	jalr	-1182(ra) # 80005b10 <consputc>
      break;
    80005fb6:	b701                	j	80005eb6 <printf+0x9a>
      consputc('%');
    80005fb8:	8556                	mv	a0,s5
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	b56080e7          	jalr	-1194(ra) # 80005b10 <consputc>
      consputc(c);
    80005fc2:	854a                	mv	a0,s2
    80005fc4:	00000097          	auipc	ra,0x0
    80005fc8:	b4c080e7          	jalr	-1204(ra) # 80005b10 <consputc>
      break;
    80005fcc:	b5ed                	j	80005eb6 <printf+0x9a>
  if(locking)
    80005fce:	020d9163          	bnez	s11,80005ff0 <printf+0x1d4>
}
    80005fd2:	70e6                	ld	ra,120(sp)
    80005fd4:	7446                	ld	s0,112(sp)
    80005fd6:	74a6                	ld	s1,104(sp)
    80005fd8:	7906                	ld	s2,96(sp)
    80005fda:	69e6                	ld	s3,88(sp)
    80005fdc:	6a46                	ld	s4,80(sp)
    80005fde:	6aa6                	ld	s5,72(sp)
    80005fe0:	6b06                	ld	s6,64(sp)
    80005fe2:	7be2                	ld	s7,56(sp)
    80005fe4:	7c42                	ld	s8,48(sp)
    80005fe6:	7ca2                	ld	s9,40(sp)
    80005fe8:	7d02                	ld	s10,32(sp)
    80005fea:	6de2                	ld	s11,24(sp)
    80005fec:	6129                	addi	sp,sp,192
    80005fee:	8082                	ret
    release(&pr.lock);
    80005ff0:	00021517          	auipc	a0,0x21
    80005ff4:	b7850513          	addi	a0,a0,-1160 # 80026b68 <pr>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	434080e7          	jalr	1076(ra) # 8000642c <release>
}
    80006000:	bfc9                	j	80005fd2 <printf+0x1b6>

0000000080006002 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006002:	1101                	addi	sp,sp,-32
    80006004:	ec06                	sd	ra,24(sp)
    80006006:	e822                	sd	s0,16(sp)
    80006008:	e426                	sd	s1,8(sp)
    8000600a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000600c:	00021497          	auipc	s1,0x21
    80006010:	b5c48493          	addi	s1,s1,-1188 # 80026b68 <pr>
    80006014:	00003597          	auipc	a1,0x3
    80006018:	82458593          	addi	a1,a1,-2012 # 80008838 <syscalls+0x428>
    8000601c:	8526                	mv	a0,s1
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	2ca080e7          	jalr	714(ra) # 800062e8 <initlock>
  pr.locking = 1;
    80006026:	4785                	li	a5,1
    80006028:	cc9c                	sw	a5,24(s1)
}
    8000602a:	60e2                	ld	ra,24(sp)
    8000602c:	6442                	ld	s0,16(sp)
    8000602e:	64a2                	ld	s1,8(sp)
    80006030:	6105                	addi	sp,sp,32
    80006032:	8082                	ret

0000000080006034 <backtrace>:

void
backtrace() //new!
{
    80006034:	7179                	addi	sp,sp,-48
    80006036:	f406                	sd	ra,40(sp)
    80006038:	f022                	sd	s0,32(sp)
    8000603a:	ec26                	sd	s1,24(sp)
    8000603c:	e84a                	sd	s2,16(sp)
    8000603e:	e44e                	sd	s3,8(sp)
    80006040:	e052                	sd	s4,0(sp)
    80006042:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80006044:	00002517          	auipc	a0,0x2
    80006048:	7fc50513          	addi	a0,a0,2044 # 80008840 <syscalls+0x430>
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	dd0080e7          	jalr	-560(ra) # 80005e1c <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    80006054:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  uint64 temp = PGROUNDDOWN(fp);
    80006056:	797d                	lui	s2,0xfffff
    80006058:	0124f933          	and	s2,s1,s2
  while(PGROUNDDOWN(fp)==temp)
  {
    printf("%p\n",*(uint64*)(fp-8));
    8000605c:	00002a17          	auipc	s4,0x2
    80006060:	7f4a0a13          	addi	s4,s4,2036 # 80008850 <syscalls+0x440>
  while(PGROUNDDOWN(fp)==temp)
    80006064:	79fd                	lui	s3,0xfffff
    printf("%p\n",*(uint64*)(fp-8));
    80006066:	ff84b583          	ld	a1,-8(s1)
    8000606a:	8552                	mv	a0,s4
    8000606c:	00000097          	auipc	ra,0x0
    80006070:	db0080e7          	jalr	-592(ra) # 80005e1c <printf>
    fp = *(uint64*)(fp-16);
    80006074:	ff04b483          	ld	s1,-16(s1)
  while(PGROUNDDOWN(fp)==temp)
    80006078:	0134f7b3          	and	a5,s1,s3
    8000607c:	ff2785e3          	beq	a5,s2,80006066 <backtrace+0x32>
  }
}
    80006080:	70a2                	ld	ra,40(sp)
    80006082:	7402                	ld	s0,32(sp)
    80006084:	64e2                	ld	s1,24(sp)
    80006086:	6942                	ld	s2,16(sp)
    80006088:	69a2                	ld	s3,8(sp)
    8000608a:	6a02                	ld	s4,0(sp)
    8000608c:	6145                	addi	sp,sp,48
    8000608e:	8082                	ret

0000000080006090 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006090:	1141                	addi	sp,sp,-16
    80006092:	e406                	sd	ra,8(sp)
    80006094:	e022                	sd	s0,0(sp)
    80006096:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006098:	100007b7          	lui	a5,0x10000
    8000609c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060a0:	f8000713          	li	a4,-128
    800060a4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060a8:	470d                	li	a4,3
    800060aa:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060ae:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060b2:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060b6:	469d                	li	a3,7
    800060b8:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060bc:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060c0:	00002597          	auipc	a1,0x2
    800060c4:	7b058593          	addi	a1,a1,1968 # 80008870 <digits+0x18>
    800060c8:	00021517          	auipc	a0,0x21
    800060cc:	ac050513          	addi	a0,a0,-1344 # 80026b88 <uart_tx_lock>
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	218080e7          	jalr	536(ra) # 800062e8 <initlock>
}
    800060d8:	60a2                	ld	ra,8(sp)
    800060da:	6402                	ld	s0,0(sp)
    800060dc:	0141                	addi	sp,sp,16
    800060de:	8082                	ret

00000000800060e0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060e0:	1101                	addi	sp,sp,-32
    800060e2:	ec06                	sd	ra,24(sp)
    800060e4:	e822                	sd	s0,16(sp)
    800060e6:	e426                	sd	s1,8(sp)
    800060e8:	1000                	addi	s0,sp,32
    800060ea:	84aa                	mv	s1,a0
  push_off();
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	240080e7          	jalr	576(ra) # 8000632c <push_off>

  if(panicked){
    800060f4:	00003797          	auipc	a5,0x3
    800060f8:	8487a783          	lw	a5,-1976(a5) # 8000893c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060fc:	10000737          	lui	a4,0x10000
  if(panicked){
    80006100:	c391                	beqz	a5,80006104 <uartputc_sync+0x24>
    for(;;)
    80006102:	a001                	j	80006102 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006104:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006108:	0ff7f793          	andi	a5,a5,255
    8000610c:	0207f793          	andi	a5,a5,32
    80006110:	dbf5                	beqz	a5,80006104 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006112:	0ff4f793          	andi	a5,s1,255
    80006116:	10000737          	lui	a4,0x10000
    8000611a:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	2ae080e7          	jalr	686(ra) # 800063cc <pop_off>
}
    80006126:	60e2                	ld	ra,24(sp)
    80006128:	6442                	ld	s0,16(sp)
    8000612a:	64a2                	ld	s1,8(sp)
    8000612c:	6105                	addi	sp,sp,32
    8000612e:	8082                	ret

0000000080006130 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006130:	00003717          	auipc	a4,0x3
    80006134:	81073703          	ld	a4,-2032(a4) # 80008940 <uart_tx_r>
    80006138:	00003797          	auipc	a5,0x3
    8000613c:	8107b783          	ld	a5,-2032(a5) # 80008948 <uart_tx_w>
    80006140:	06e78c63          	beq	a5,a4,800061b8 <uartstart+0x88>
{
    80006144:	7139                	addi	sp,sp,-64
    80006146:	fc06                	sd	ra,56(sp)
    80006148:	f822                	sd	s0,48(sp)
    8000614a:	f426                	sd	s1,40(sp)
    8000614c:	f04a                	sd	s2,32(sp)
    8000614e:	ec4e                	sd	s3,24(sp)
    80006150:	e852                	sd	s4,16(sp)
    80006152:	e456                	sd	s5,8(sp)
    80006154:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006156:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000615a:	00021a17          	auipc	s4,0x21
    8000615e:	a2ea0a13          	addi	s4,s4,-1490 # 80026b88 <uart_tx_lock>
    uart_tx_r += 1;
    80006162:	00002497          	auipc	s1,0x2
    80006166:	7de48493          	addi	s1,s1,2014 # 80008940 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000616a:	00002997          	auipc	s3,0x2
    8000616e:	7de98993          	addi	s3,s3,2014 # 80008948 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006172:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006176:	0ff7f793          	andi	a5,a5,255
    8000617a:	0207f793          	andi	a5,a5,32
    8000617e:	c785                	beqz	a5,800061a6 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006180:	01f77793          	andi	a5,a4,31
    80006184:	97d2                	add	a5,a5,s4
    80006186:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000618a:	0705                	addi	a4,a4,1
    8000618c:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000618e:	8526                	mv	a0,s1
    80006190:	ffffb097          	auipc	ra,0xffffb
    80006194:	460080e7          	jalr	1120(ra) # 800015f0 <wakeup>
    
    WriteReg(THR, c);
    80006198:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000619c:	6098                	ld	a4,0(s1)
    8000619e:	0009b783          	ld	a5,0(s3)
    800061a2:	fce798e3          	bne	a5,a4,80006172 <uartstart+0x42>
  }
}
    800061a6:	70e2                	ld	ra,56(sp)
    800061a8:	7442                	ld	s0,48(sp)
    800061aa:	74a2                	ld	s1,40(sp)
    800061ac:	7902                	ld	s2,32(sp)
    800061ae:	69e2                	ld	s3,24(sp)
    800061b0:	6a42                	ld	s4,16(sp)
    800061b2:	6aa2                	ld	s5,8(sp)
    800061b4:	6121                	addi	sp,sp,64
    800061b6:	8082                	ret
    800061b8:	8082                	ret

00000000800061ba <uartputc>:
{
    800061ba:	7179                	addi	sp,sp,-48
    800061bc:	f406                	sd	ra,40(sp)
    800061be:	f022                	sd	s0,32(sp)
    800061c0:	ec26                	sd	s1,24(sp)
    800061c2:	e84a                	sd	s2,16(sp)
    800061c4:	e44e                	sd	s3,8(sp)
    800061c6:	e052                	sd	s4,0(sp)
    800061c8:	1800                	addi	s0,sp,48
    800061ca:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061cc:	00021517          	auipc	a0,0x21
    800061d0:	9bc50513          	addi	a0,a0,-1604 # 80026b88 <uart_tx_lock>
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	1a4080e7          	jalr	420(ra) # 80006378 <acquire>
  if(panicked){
    800061dc:	00002797          	auipc	a5,0x2
    800061e0:	7607a783          	lw	a5,1888(a5) # 8000893c <panicked>
    800061e4:	e7c9                	bnez	a5,8000626e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e6:	00002797          	auipc	a5,0x2
    800061ea:	7627b783          	ld	a5,1890(a5) # 80008948 <uart_tx_w>
    800061ee:	00002717          	auipc	a4,0x2
    800061f2:	75273703          	ld	a4,1874(a4) # 80008940 <uart_tx_r>
    800061f6:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800061fa:	00021a17          	auipc	s4,0x21
    800061fe:	98ea0a13          	addi	s4,s4,-1650 # 80026b88 <uart_tx_lock>
    80006202:	00002497          	auipc	s1,0x2
    80006206:	73e48493          	addi	s1,s1,1854 # 80008940 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000620a:	00002917          	auipc	s2,0x2
    8000620e:	73e90913          	addi	s2,s2,1854 # 80008948 <uart_tx_w>
    80006212:	00f71f63          	bne	a4,a5,80006230 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006216:	85d2                	mv	a1,s4
    80006218:	8526                	mv	a0,s1
    8000621a:	ffffb097          	auipc	ra,0xffffb
    8000621e:	370080e7          	jalr	880(ra) # 8000158a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006222:	00093783          	ld	a5,0(s2)
    80006226:	6098                	ld	a4,0(s1)
    80006228:	02070713          	addi	a4,a4,32
    8000622c:	fef705e3          	beq	a4,a5,80006216 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006230:	00021497          	auipc	s1,0x21
    80006234:	95848493          	addi	s1,s1,-1704 # 80026b88 <uart_tx_lock>
    80006238:	01f7f713          	andi	a4,a5,31
    8000623c:	9726                	add	a4,a4,s1
    8000623e:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006242:	0785                	addi	a5,a5,1
    80006244:	00002717          	auipc	a4,0x2
    80006248:	70f73223          	sd	a5,1796(a4) # 80008948 <uart_tx_w>
  uartstart();
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	ee4080e7          	jalr	-284(ra) # 80006130 <uartstart>
  release(&uart_tx_lock);
    80006254:	8526                	mv	a0,s1
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	1d6080e7          	jalr	470(ra) # 8000642c <release>
}
    8000625e:	70a2                	ld	ra,40(sp)
    80006260:	7402                	ld	s0,32(sp)
    80006262:	64e2                	ld	s1,24(sp)
    80006264:	6942                	ld	s2,16(sp)
    80006266:	69a2                	ld	s3,8(sp)
    80006268:	6a02                	ld	s4,0(sp)
    8000626a:	6145                	addi	sp,sp,48
    8000626c:	8082                	ret
    for(;;)
    8000626e:	a001                	j	8000626e <uartputc+0xb4>

0000000080006270 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006270:	1141                	addi	sp,sp,-16
    80006272:	e422                	sd	s0,8(sp)
    80006274:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006276:	100007b7          	lui	a5,0x10000
    8000627a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000627e:	8b85                	andi	a5,a5,1
    80006280:	cb91                	beqz	a5,80006294 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006282:	100007b7          	lui	a5,0x10000
    80006286:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000628a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000628e:	6422                	ld	s0,8(sp)
    80006290:	0141                	addi	sp,sp,16
    80006292:	8082                	ret
    return -1;
    80006294:	557d                	li	a0,-1
    80006296:	bfe5                	j	8000628e <uartgetc+0x1e>

0000000080006298 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006298:	1101                	addi	sp,sp,-32
    8000629a:	ec06                	sd	ra,24(sp)
    8000629c:	e822                	sd	s0,16(sp)
    8000629e:	e426                	sd	s1,8(sp)
    800062a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062a2:	54fd                	li	s1,-1
    int c = uartgetc();
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	fcc080e7          	jalr	-52(ra) # 80006270 <uartgetc>
    if(c == -1)
    800062ac:	00950763          	beq	a0,s1,800062ba <uartintr+0x22>
      break;
    consoleintr(c);
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	8a2080e7          	jalr	-1886(ra) # 80005b52 <consoleintr>
  while(1){
    800062b8:	b7f5                	j	800062a4 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062ba:	00021497          	auipc	s1,0x21
    800062be:	8ce48493          	addi	s1,s1,-1842 # 80026b88 <uart_tx_lock>
    800062c2:	8526                	mv	a0,s1
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	0b4080e7          	jalr	180(ra) # 80006378 <acquire>
  uartstart();
    800062cc:	00000097          	auipc	ra,0x0
    800062d0:	e64080e7          	jalr	-412(ra) # 80006130 <uartstart>
  release(&uart_tx_lock);
    800062d4:	8526                	mv	a0,s1
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	156080e7          	jalr	342(ra) # 8000642c <release>
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret

00000000800062e8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062e8:	1141                	addi	sp,sp,-16
    800062ea:	e422                	sd	s0,8(sp)
    800062ec:	0800                	addi	s0,sp,16
  lk->name = name;
    800062ee:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062f0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062f4:	00053823          	sd	zero,16(a0)
}
    800062f8:	6422                	ld	s0,8(sp)
    800062fa:	0141                	addi	sp,sp,16
    800062fc:	8082                	ret

00000000800062fe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062fe:	411c                	lw	a5,0(a0)
    80006300:	e399                	bnez	a5,80006306 <holding+0x8>
    80006302:	4501                	li	a0,0
  return r;
}
    80006304:	8082                	ret
{
    80006306:	1101                	addi	sp,sp,-32
    80006308:	ec06                	sd	ra,24(sp)
    8000630a:	e822                	sd	s0,16(sp)
    8000630c:	e426                	sd	s1,8(sp)
    8000630e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006310:	6904                	ld	s1,16(a0)
    80006312:	ffffb097          	auipc	ra,0xffffb
    80006316:	b84080e7          	jalr	-1148(ra) # 80000e96 <mycpu>
    8000631a:	40a48533          	sub	a0,s1,a0
    8000631e:	00153513          	seqz	a0,a0
}
    80006322:	60e2                	ld	ra,24(sp)
    80006324:	6442                	ld	s0,16(sp)
    80006326:	64a2                	ld	s1,8(sp)
    80006328:	6105                	addi	sp,sp,32
    8000632a:	8082                	ret

000000008000632c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000632c:	1101                	addi	sp,sp,-32
    8000632e:	ec06                	sd	ra,24(sp)
    80006330:	e822                	sd	s0,16(sp)
    80006332:	e426                	sd	s1,8(sp)
    80006334:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006336:	100024f3          	csrr	s1,sstatus
    8000633a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000633e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006340:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006344:	ffffb097          	auipc	ra,0xffffb
    80006348:	b52080e7          	jalr	-1198(ra) # 80000e96 <mycpu>
    8000634c:	5d3c                	lw	a5,120(a0)
    8000634e:	cf89                	beqz	a5,80006368 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	b46080e7          	jalr	-1210(ra) # 80000e96 <mycpu>
    80006358:	5d3c                	lw	a5,120(a0)
    8000635a:	2785                	addiw	a5,a5,1
    8000635c:	dd3c                	sw	a5,120(a0)
}
    8000635e:	60e2                	ld	ra,24(sp)
    80006360:	6442                	ld	s0,16(sp)
    80006362:	64a2                	ld	s1,8(sp)
    80006364:	6105                	addi	sp,sp,32
    80006366:	8082                	ret
    mycpu()->intena = old;
    80006368:	ffffb097          	auipc	ra,0xffffb
    8000636c:	b2e080e7          	jalr	-1234(ra) # 80000e96 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006370:	8085                	srli	s1,s1,0x1
    80006372:	8885                	andi	s1,s1,1
    80006374:	dd64                	sw	s1,124(a0)
    80006376:	bfe9                	j	80006350 <push_off+0x24>

0000000080006378 <acquire>:
{
    80006378:	1101                	addi	sp,sp,-32
    8000637a:	ec06                	sd	ra,24(sp)
    8000637c:	e822                	sd	s0,16(sp)
    8000637e:	e426                	sd	s1,8(sp)
    80006380:	1000                	addi	s0,sp,32
    80006382:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006384:	00000097          	auipc	ra,0x0
    80006388:	fa8080e7          	jalr	-88(ra) # 8000632c <push_off>
  if(holding(lk))
    8000638c:	8526                	mv	a0,s1
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	f70080e7          	jalr	-144(ra) # 800062fe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006396:	4705                	li	a4,1
  if(holding(lk))
    80006398:	e115                	bnez	a0,800063bc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000639a:	87ba                	mv	a5,a4
    8000639c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063a0:	2781                	sext.w	a5,a5
    800063a2:	ffe5                	bnez	a5,8000639a <acquire+0x22>
  __sync_synchronize();
    800063a4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063a8:	ffffb097          	auipc	ra,0xffffb
    800063ac:	aee080e7          	jalr	-1298(ra) # 80000e96 <mycpu>
    800063b0:	e888                	sd	a0,16(s1)
}
    800063b2:	60e2                	ld	ra,24(sp)
    800063b4:	6442                	ld	s0,16(sp)
    800063b6:	64a2                	ld	s1,8(sp)
    800063b8:	6105                	addi	sp,sp,32
    800063ba:	8082                	ret
    panic("acquire");
    800063bc:	00002517          	auipc	a0,0x2
    800063c0:	4bc50513          	addi	a0,a0,1212 # 80008878 <digits+0x20>
    800063c4:	00000097          	auipc	ra,0x0
    800063c8:	a0e080e7          	jalr	-1522(ra) # 80005dd2 <panic>

00000000800063cc <pop_off>:

void
pop_off(void)
{
    800063cc:	1141                	addi	sp,sp,-16
    800063ce:	e406                	sd	ra,8(sp)
    800063d0:	e022                	sd	s0,0(sp)
    800063d2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063d4:	ffffb097          	auipc	ra,0xffffb
    800063d8:	ac2080e7          	jalr	-1342(ra) # 80000e96 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063dc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063e0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063e2:	e78d                	bnez	a5,8000640c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063e4:	5d3c                	lw	a5,120(a0)
    800063e6:	02f05b63          	blez	a5,8000641c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063ea:	37fd                	addiw	a5,a5,-1
    800063ec:	0007871b          	sext.w	a4,a5
    800063f0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063f2:	eb09                	bnez	a4,80006404 <pop_off+0x38>
    800063f4:	5d7c                	lw	a5,124(a0)
    800063f6:	c799                	beqz	a5,80006404 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006400:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006404:	60a2                	ld	ra,8(sp)
    80006406:	6402                	ld	s0,0(sp)
    80006408:	0141                	addi	sp,sp,16
    8000640a:	8082                	ret
    panic("pop_off - interruptible");
    8000640c:	00002517          	auipc	a0,0x2
    80006410:	47450513          	addi	a0,a0,1140 # 80008880 <digits+0x28>
    80006414:	00000097          	auipc	ra,0x0
    80006418:	9be080e7          	jalr	-1602(ra) # 80005dd2 <panic>
    panic("pop_off");
    8000641c:	00002517          	auipc	a0,0x2
    80006420:	47c50513          	addi	a0,a0,1148 # 80008898 <digits+0x40>
    80006424:	00000097          	auipc	ra,0x0
    80006428:	9ae080e7          	jalr	-1618(ra) # 80005dd2 <panic>

000000008000642c <release>:
{
    8000642c:	1101                	addi	sp,sp,-32
    8000642e:	ec06                	sd	ra,24(sp)
    80006430:	e822                	sd	s0,16(sp)
    80006432:	e426                	sd	s1,8(sp)
    80006434:	1000                	addi	s0,sp,32
    80006436:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	ec6080e7          	jalr	-314(ra) # 800062fe <holding>
    80006440:	c115                	beqz	a0,80006464 <release+0x38>
  lk->cpu = 0;
    80006442:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006446:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000644a:	0f50000f          	fence	iorw,ow
    8000644e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006452:	00000097          	auipc	ra,0x0
    80006456:	f7a080e7          	jalr	-134(ra) # 800063cc <pop_off>
}
    8000645a:	60e2                	ld	ra,24(sp)
    8000645c:	6442                	ld	s0,16(sp)
    8000645e:	64a2                	ld	s1,8(sp)
    80006460:	6105                	addi	sp,sp,32
    80006462:	8082                	ret
    panic("release");
    80006464:	00002517          	auipc	a0,0x2
    80006468:	43c50513          	addi	a0,a0,1084 # 800088a0 <digits+0x48>
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	966080e7          	jalr	-1690(ra) # 80005dd2 <panic>
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
