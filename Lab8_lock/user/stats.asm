
user/_stats:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define SZ 4096
char buf[SZ];

int
main(void)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i, n;
  
  while (1) {
    n = statistics(buf, SZ);
  12:	00001a17          	auipc	s4,0x1
  16:	ffea0a13          	addi	s4,s4,-2 # 1010 <buf>
  1a:	00001a97          	auipc	s5,0x1
  1e:	ff7a8a93          	addi	s5,s5,-9 # 1011 <buf+0x1>
  22:	a021                	j	2a <main+0x2a>
    for (i = 0; i < n; i++) {
      write(1, buf+i, 1);
    }
    if (n != SZ)
  24:	6785                	lui	a5,0x1
  26:	04f99063          	bne	s3,a5,66 <main+0x66>
    n = statistics(buf, SZ);
  2a:	6585                	lui	a1,0x1
  2c:	8552                	mv	a0,s4
  2e:	00000097          	auipc	ra,0x0
  32:	7ec080e7          	jalr	2028(ra) # 81a <statistics>
  36:	89aa                	mv	s3,a0
    for (i = 0; i < n; i++) {
  38:	fea056e3          	blez	a0,24 <main+0x24>
  3c:	00001497          	auipc	s1,0x1
  40:	fd448493          	addi	s1,s1,-44 # 1010 <buf>
  44:	fff5091b          	addiw	s2,a0,-1
  48:	1902                	slli	s2,s2,0x20
  4a:	02095913          	srli	s2,s2,0x20
  4e:	9956                	add	s2,s2,s5
      write(1, buf+i, 1);
  50:	4605                	li	a2,1
  52:	85a6                	mv	a1,s1
  54:	4505                	li	a0,1
  56:	00000097          	auipc	ra,0x0
  5a:	2ca080e7          	jalr	714(ra) # 320 <write>
    for (i = 0; i < n; i++) {
  5e:	0485                	addi	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <main+0x50>
  64:	b7c1                	j	24 <main+0x24>
      break;
  }

  exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	298080e7          	jalr	664(ra) # 300 <exit>

0000000000000070 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  extern int main();
  main();
  78:	00000097          	auipc	ra,0x0
  7c:	f88080e7          	jalr	-120(ra) # 0 <main>
  exit(0);
  80:	4501                	li	a0,0
  82:	00000097          	auipc	ra,0x0
  86:	27e080e7          	jalr	638(ra) # 300 <exit>

000000000000008a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	87aa                	mv	a5,a0
  92:	0585                	addi	a1,a1,1
  94:	0785                	addi	a5,a5,1
  96:	fff5c703          	lbu	a4,-1(a1) # fff <digits+0x757>
  9a:	fee78fa3          	sb	a4,-1(a5) # fff <digits+0x757>
  9e:	fb75                	bnez	a4,92 <strcpy+0x8>
    ;
  return os;
}
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cb91                	beqz	a5,c4 <strcmp+0x1e>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	00f71763          	bne	a4,a5,c4 <strcmp+0x1e>
    p++, q++;
  ba:	0505                	addi	a0,a0,1
  bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	fbe5                	bnez	a5,b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c4:	0005c503          	lbu	a0,0(a1)
}
  c8:	40a7853b          	subw	a0,a5,a0
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strlen>:

uint
strlen(const char *s)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cf91                	beqz	a5,f8 <strlen+0x26>
  de:	0505                	addi	a0,a0,1
  e0:	87aa                	mv	a5,a0
  e2:	4685                	li	a3,1
  e4:	9e89                	subw	a3,a3,a0
  e6:	00f6853b          	addw	a0,a3,a5
  ea:	0785                	addi	a5,a5,1
  ec:	fff7c703          	lbu	a4,-1(a5)
  f0:	fb7d                	bnez	a4,e6 <strlen+0x14>
    ;
  return n;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  for(n = 0; s[n]; n++)
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strlen+0x20>

00000000000000fc <memset>:

void*
memset(void *dst, int c, uint n)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 102:	ce09                	beqz	a2,11c <memset+0x20>
 104:	87aa                	mv	a5,a0
 106:	fff6071b          	addiw	a4,a2,-1
 10a:	1702                	slli	a4,a4,0x20
 10c:	9301                	srli	a4,a4,0x20
 10e:	0705                	addi	a4,a4,1
 110:	972a                	add	a4,a4,a0
    cdst[i] = c;
 112:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 116:	0785                	addi	a5,a5,1
 118:	fee79de3          	bne	a5,a4,112 <memset+0x16>
  }
  return dst;
}
 11c:	6422                	ld	s0,8(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strchr>:

char*
strchr(const char *s, char c)
{
 122:	1141                	addi	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	addi	s0,sp,16
  for(; *s; s++)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cb99                	beqz	a5,142 <strchr+0x20>
    if(*s == c)
 12e:	00f58763          	beq	a1,a5,13c <strchr+0x1a>
  for(; *s; s++)
 132:	0505                	addi	a0,a0,1
 134:	00054783          	lbu	a5,0(a0)
 138:	fbfd                	bnez	a5,12e <strchr+0xc>
      return (char*)s;
  return 0;
 13a:	4501                	li	a0,0
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret
  return 0;
 142:	4501                	li	a0,0
 144:	bfe5                	j	13c <strchr+0x1a>

0000000000000146 <gets>:

char*
gets(char *buf, int max)
{
 146:	711d                	addi	sp,sp,-96
 148:	ec86                	sd	ra,88(sp)
 14a:	e8a2                	sd	s0,80(sp)
 14c:	e4a6                	sd	s1,72(sp)
 14e:	e0ca                	sd	s2,64(sp)
 150:	fc4e                	sd	s3,56(sp)
 152:	f852                	sd	s4,48(sp)
 154:	f456                	sd	s5,40(sp)
 156:	f05a                	sd	s6,32(sp)
 158:	ec5e                	sd	s7,24(sp)
 15a:	1080                	addi	s0,sp,96
 15c:	8baa                	mv	s7,a0
 15e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	892a                	mv	s2,a0
 162:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 164:	4aa9                	li	s5,10
 166:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 168:	89a6                	mv	s3,s1
 16a:	2485                	addiw	s1,s1,1
 16c:	0344d863          	bge	s1,s4,19c <gets+0x56>
    cc = read(0, &c, 1);
 170:	4605                	li	a2,1
 172:	faf40593          	addi	a1,s0,-81
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	1a0080e7          	jalr	416(ra) # 318 <read>
    if(cc < 1)
 180:	00a05e63          	blez	a0,19c <gets+0x56>
    buf[i++] = c;
 184:	faf44783          	lbu	a5,-81(s0)
 188:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18c:	01578763          	beq	a5,s5,19a <gets+0x54>
 190:	0905                	addi	s2,s2,1
 192:	fd679be3          	bne	a5,s6,168 <gets+0x22>
  for(i=0; i+1 < max; ){
 196:	89a6                	mv	s3,s1
 198:	a011                	j	19c <gets+0x56>
 19a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 19c:	99de                	add	s3,s3,s7
 19e:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a2:	855e                	mv	a0,s7
 1a4:	60e6                	ld	ra,88(sp)
 1a6:	6446                	ld	s0,80(sp)
 1a8:	64a6                	ld	s1,72(sp)
 1aa:	6906                	ld	s2,64(sp)
 1ac:	79e2                	ld	s3,56(sp)
 1ae:	7a42                	ld	s4,48(sp)
 1b0:	7aa2                	ld	s5,40(sp)
 1b2:	7b02                	ld	s6,32(sp)
 1b4:	6be2                	ld	s7,24(sp)
 1b6:	6125                	addi	sp,sp,96
 1b8:	8082                	ret

00000000000001ba <stat>:

int
stat(const char *n, struct stat *st)
{
 1ba:	1101                	addi	sp,sp,-32
 1bc:	ec06                	sd	ra,24(sp)
 1be:	e822                	sd	s0,16(sp)
 1c0:	e426                	sd	s1,8(sp)
 1c2:	e04a                	sd	s2,0(sp)
 1c4:	1000                	addi	s0,sp,32
 1c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c8:	4581                	li	a1,0
 1ca:	00000097          	auipc	ra,0x0
 1ce:	176080e7          	jalr	374(ra) # 340 <open>
  if(fd < 0)
 1d2:	02054563          	bltz	a0,1fc <stat+0x42>
 1d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d8:	85ca                	mv	a1,s2
 1da:	00000097          	auipc	ra,0x0
 1de:	17e080e7          	jalr	382(ra) # 358 <fstat>
 1e2:	892a                	mv	s2,a0
  close(fd);
 1e4:	8526                	mv	a0,s1
 1e6:	00000097          	auipc	ra,0x0
 1ea:	142080e7          	jalr	322(ra) # 328 <close>
  return r;
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	64a2                	ld	s1,8(sp)
 1f6:	6902                	ld	s2,0(sp)
 1f8:	6105                	addi	sp,sp,32
 1fa:	8082                	ret
    return -1;
 1fc:	597d                	li	s2,-1
 1fe:	bfc5                	j	1ee <stat+0x34>

0000000000000200 <atoi>:

int
atoi(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 206:	00054603          	lbu	a2,0(a0)
 20a:	fd06079b          	addiw	a5,a2,-48
 20e:	0ff7f793          	andi	a5,a5,255
 212:	4725                	li	a4,9
 214:	02f76963          	bltu	a4,a5,246 <atoi+0x46>
 218:	86aa                	mv	a3,a0
  n = 0;
 21a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 21c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 21e:	0685                	addi	a3,a3,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb1                	addw	a5,a5,a2
 22c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 230:	0006c603          	lbu	a2,0(a3)
 234:	fd06071b          	addiw	a4,a2,-48
 238:	0ff77713          	andi	a4,a4,255
 23c:	fee5f1e3          	bgeu	a1,a4,21e <atoi+0x1e>
  return n;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  n = 0;
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <atoi+0x40>

000000000000024a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 250:	02b57663          	bgeu	a0,a1,27c <memmove+0x32>
    while(n-- > 0)
 254:	02c05163          	blez	a2,276 <memmove+0x2c>
 258:	fff6079b          	addiw	a5,a2,-1
 25c:	1782                	slli	a5,a5,0x20
 25e:	9381                	srli	a5,a5,0x20
 260:	0785                	addi	a5,a5,1
 262:	97aa                	add	a5,a5,a0
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x2c>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x4a>
 2a4:	bfc9                	j	276 <memmove+0x2c>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addiw	a3,a2,-1
 2b2:	1682                	slli	a3,a3,0x20
 2b4:	9281                	srli	a3,a3,0x20
 2b6:	0685                	addi	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f62080e7          	jalr	-158(ra) # 24a <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	00000097          	auipc	ra,0x0
 3b6:	f6e080e7          	jalr	-146(ra) # 320 <write>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	6105                	addi	sp,sp,32
 3c0:	8082                	ret

00000000000003c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c2:	7139                	addi	sp,sp,-64
 3c4:	fc06                	sd	ra,56(sp)
 3c6:	f822                	sd	s0,48(sp)
 3c8:	f426                	sd	s1,40(sp)
 3ca:	f04a                	sd	s2,32(sp)
 3cc:	ec4e                	sd	s3,24(sp)
 3ce:	0080                	addi	s0,sp,64
 3d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d2:	c299                	beqz	a3,3d8 <printint+0x16>
 3d4:	0805c863          	bltz	a1,464 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d8:	2581                	sext.w	a1,a1
  neg = 0;
 3da:	4881                	li	a7,0
 3dc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e2:	2601                	sext.w	a2,a2
 3e4:	00000517          	auipc	a0,0x0
 3e8:	4c450513          	addi	a0,a0,1220 # 8a8 <digits>
 3ec:	883a                	mv	a6,a4
 3ee:	2705                	addiw	a4,a4,1
 3f0:	02c5f7bb          	remuw	a5,a1,a2
 3f4:	1782                	slli	a5,a5,0x20
 3f6:	9381                	srli	a5,a5,0x20
 3f8:	97aa                	add	a5,a5,a0
 3fa:	0007c783          	lbu	a5,0(a5)
 3fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 402:	0005879b          	sext.w	a5,a1
 406:	02c5d5bb          	divuw	a1,a1,a2
 40a:	0685                	addi	a3,a3,1
 40c:	fec7f0e3          	bgeu	a5,a2,3ec <printint+0x2a>
  if(neg)
 410:	00088b63          	beqz	a7,426 <printint+0x64>
    buf[i++] = '-';
 414:	fd040793          	addi	a5,s0,-48
 418:	973e                	add	a4,a4,a5
 41a:	02d00793          	li	a5,45
 41e:	fef70823          	sb	a5,-16(a4)
 422:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 426:	02e05863          	blez	a4,456 <printint+0x94>
 42a:	fc040793          	addi	a5,s0,-64
 42e:	00e78933          	add	s2,a5,a4
 432:	fff78993          	addi	s3,a5,-1
 436:	99ba                	add	s3,s3,a4
 438:	377d                	addiw	a4,a4,-1
 43a:	1702                	slli	a4,a4,0x20
 43c:	9301                	srli	a4,a4,0x20
 43e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 442:	fff94583          	lbu	a1,-1(s2)
 446:	8526                	mv	a0,s1
 448:	00000097          	auipc	ra,0x0
 44c:	f58080e7          	jalr	-168(ra) # 3a0 <putc>
  while(--i >= 0)
 450:	197d                	addi	s2,s2,-1
 452:	ff3918e3          	bne	s2,s3,442 <printint+0x80>
}
 456:	70e2                	ld	ra,56(sp)
 458:	7442                	ld	s0,48(sp)
 45a:	74a2                	ld	s1,40(sp)
 45c:	7902                	ld	s2,32(sp)
 45e:	69e2                	ld	s3,24(sp)
 460:	6121                	addi	sp,sp,64
 462:	8082                	ret
    x = -xx;
 464:	40b005bb          	negw	a1,a1
    neg = 1;
 468:	4885                	li	a7,1
    x = -xx;
 46a:	bf8d                	j	3dc <printint+0x1a>

000000000000046c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46c:	7119                	addi	sp,sp,-128
 46e:	fc86                	sd	ra,120(sp)
 470:	f8a2                	sd	s0,112(sp)
 472:	f4a6                	sd	s1,104(sp)
 474:	f0ca                	sd	s2,96(sp)
 476:	ecce                	sd	s3,88(sp)
 478:	e8d2                	sd	s4,80(sp)
 47a:	e4d6                	sd	s5,72(sp)
 47c:	e0da                	sd	s6,64(sp)
 47e:	fc5e                	sd	s7,56(sp)
 480:	f862                	sd	s8,48(sp)
 482:	f466                	sd	s9,40(sp)
 484:	f06a                	sd	s10,32(sp)
 486:	ec6e                	sd	s11,24(sp)
 488:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48a:	0005c903          	lbu	s2,0(a1)
 48e:	18090f63          	beqz	s2,62c <vprintf+0x1c0>
 492:	8aaa                	mv	s5,a0
 494:	8b32                	mv	s6,a2
 496:	00158493          	addi	s1,a1,1
  state = 0;
 49a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49c:	02500a13          	li	s4,37
      if(c == 'd'){
 4a0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4a4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4a8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ac:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4b0:	00000b97          	auipc	s7,0x0
 4b4:	3f8b8b93          	addi	s7,s7,1016 # 8a8 <digits>
 4b8:	a839                	j	4d6 <vprintf+0x6a>
        putc(fd, c);
 4ba:	85ca                	mv	a1,s2
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	ee2080e7          	jalr	-286(ra) # 3a0 <putc>
 4c6:	a019                	j	4cc <vprintf+0x60>
    } else if(state == '%'){
 4c8:	01498f63          	beq	s3,s4,4e6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4cc:	0485                	addi	s1,s1,1
 4ce:	fff4c903          	lbu	s2,-1(s1)
 4d2:	14090d63          	beqz	s2,62c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4da:	fe0997e3          	bnez	s3,4c8 <vprintf+0x5c>
      if(c == '%'){
 4de:	fd479ee3          	bne	a5,s4,4ba <vprintf+0x4e>
        state = '%';
 4e2:	89be                	mv	s3,a5
 4e4:	b7e5                	j	4cc <vprintf+0x60>
      if(c == 'd'){
 4e6:	05878063          	beq	a5,s8,526 <vprintf+0xba>
      } else if(c == 'l') {
 4ea:	05978c63          	beq	a5,s9,542 <vprintf+0xd6>
      } else if(c == 'x') {
 4ee:	07a78863          	beq	a5,s10,55e <vprintf+0xf2>
      } else if(c == 'p') {
 4f2:	09b78463          	beq	a5,s11,57a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4f6:	07300713          	li	a4,115
 4fa:	0ce78663          	beq	a5,a4,5c6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fe:	06300713          	li	a4,99
 502:	0ee78e63          	beq	a5,a4,5fe <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 506:	11478863          	beq	a5,s4,616 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 50a:	85d2                	mv	a1,s4
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e92080e7          	jalr	-366(ra) # 3a0 <putc>
        putc(fd, c);
 516:	85ca                	mv	a1,s2
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e86080e7          	jalr	-378(ra) # 3a0 <putc>
      }
      state = 0;
 522:	4981                	li	s3,0
 524:	b765                	j	4cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 526:	008b0913          	addi	s2,s6,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000b2583          	lw	a1,0(s6)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e8e080e7          	jalr	-370(ra) # 3c2 <printint>
 53c:	8b4a                	mv	s6,s2
      state = 0;
 53e:	4981                	li	s3,0
 540:	b771                	j	4cc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 542:	008b0913          	addi	s2,s6,8
 546:	4681                	li	a3,0
 548:	4629                	li	a2,10
 54a:	000b2583          	lw	a1,0(s6)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e72080e7          	jalr	-398(ra) # 3c2 <printint>
 558:	8b4a                	mv	s6,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	bf85                	j	4cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 55e:	008b0913          	addi	s2,s6,8
 562:	4681                	li	a3,0
 564:	4641                	li	a2,16
 566:	000b2583          	lw	a1,0(s6)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e56080e7          	jalr	-426(ra) # 3c2 <printint>
 574:	8b4a                	mv	s6,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	bf91                	j	4cc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 57a:	008b0793          	addi	a5,s6,8
 57e:	f8f43423          	sd	a5,-120(s0)
 582:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 586:	03000593          	li	a1,48
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e14080e7          	jalr	-492(ra) # 3a0 <putc>
  putc(fd, 'x');
 594:	85ea                	mv	a1,s10
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e08080e7          	jalr	-504(ra) # 3a0 <putc>
 5a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a2:	03c9d793          	srli	a5,s3,0x3c
 5a6:	97de                	add	a5,a5,s7
 5a8:	0007c583          	lbu	a1,0(a5)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	df2080e7          	jalr	-526(ra) # 3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b6:	0992                	slli	s3,s3,0x4
 5b8:	397d                	addiw	s2,s2,-1
 5ba:	fe0914e3          	bnez	s2,5a2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5be:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b721                	j	4cc <vprintf+0x60>
        s = va_arg(ap, char*);
 5c6:	008b0993          	addi	s3,s6,8
 5ca:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ce:	02090163          	beqz	s2,5f0 <vprintf+0x184>
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	c9a1                	beqz	a1,626 <vprintf+0x1ba>
          putc(fd, *s);
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	dc6080e7          	jalr	-570(ra) # 3a0 <putc>
          s++;
 5e2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5e4:	00094583          	lbu	a1,0(s2)
 5e8:	f9e5                	bnez	a1,5d8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5ea:	8b4e                	mv	s6,s3
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bdf9                	j	4cc <vprintf+0x60>
          s = "(null)";
 5f0:	00000917          	auipc	s2,0x0
 5f4:	2b090913          	addi	s2,s2,688 # 8a0 <statistics+0x86>
        while(*s != 0){
 5f8:	02800593          	li	a1,40
 5fc:	bff1                	j	5d8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5fe:	008b0913          	addi	s2,s6,8
 602:	000b4583          	lbu	a1,0(s6)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d98080e7          	jalr	-616(ra) # 3a0 <putc>
 610:	8b4a                	mv	s6,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bd65                	j	4cc <vprintf+0x60>
        putc(fd, c);
 616:	85d2                	mv	a1,s4
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	d86080e7          	jalr	-634(ra) # 3a0 <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	b565                	j	4cc <vprintf+0x60>
        s = va_arg(ap, char*);
 626:	8b4e                	mv	s6,s3
      state = 0;
 628:	4981                	li	s3,0
 62a:	b54d                	j	4cc <vprintf+0x60>
    }
  }
}
 62c:	70e6                	ld	ra,120(sp)
 62e:	7446                	ld	s0,112(sp)
 630:	74a6                	ld	s1,104(sp)
 632:	7906                	ld	s2,96(sp)
 634:	69e6                	ld	s3,88(sp)
 636:	6a46                	ld	s4,80(sp)
 638:	6aa6                	ld	s5,72(sp)
 63a:	6b06                	ld	s6,64(sp)
 63c:	7be2                	ld	s7,56(sp)
 63e:	7c42                	ld	s8,48(sp)
 640:	7ca2                	ld	s9,40(sp)
 642:	7d02                	ld	s10,32(sp)
 644:	6de2                	ld	s11,24(sp)
 646:	6109                	addi	sp,sp,128
 648:	8082                	ret

000000000000064a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 64a:	715d                	addi	sp,sp,-80
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	addi	s0,sp,32
 652:	e010                	sd	a2,0(s0)
 654:	e414                	sd	a3,8(s0)
 656:	e818                	sd	a4,16(s0)
 658:	ec1c                	sd	a5,24(s0)
 65a:	03043023          	sd	a6,32(s0)
 65e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 662:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 666:	8622                	mv	a2,s0
 668:	00000097          	auipc	ra,0x0
 66c:	e04080e7          	jalr	-508(ra) # 46c <vprintf>
}
 670:	60e2                	ld	ra,24(sp)
 672:	6442                	ld	s0,16(sp)
 674:	6161                	addi	sp,sp,80
 676:	8082                	ret

0000000000000678 <printf>:

void
printf(const char *fmt, ...)
{
 678:	711d                	addi	sp,sp,-96
 67a:	ec06                	sd	ra,24(sp)
 67c:	e822                	sd	s0,16(sp)
 67e:	1000                	addi	s0,sp,32
 680:	e40c                	sd	a1,8(s0)
 682:	e810                	sd	a2,16(s0)
 684:	ec14                	sd	a3,24(s0)
 686:	f018                	sd	a4,32(s0)
 688:	f41c                	sd	a5,40(s0)
 68a:	03043823          	sd	a6,48(s0)
 68e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 692:	00840613          	addi	a2,s0,8
 696:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 69a:	85aa                	mv	a1,a0
 69c:	4505                	li	a0,1
 69e:	00000097          	auipc	ra,0x0
 6a2:	dce080e7          	jalr	-562(ra) # 46c <vprintf>
}
 6a6:	60e2                	ld	ra,24(sp)
 6a8:	6442                	ld	s0,16(sp)
 6aa:	6125                	addi	sp,sp,96
 6ac:	8082                	ret

00000000000006ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ae:	1141                	addi	sp,sp,-16
 6b0:	e422                	sd	s0,8(sp)
 6b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b8:	00001797          	auipc	a5,0x1
 6bc:	9487b783          	ld	a5,-1720(a5) # 1000 <freep>
 6c0:	a805                	j	6f0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c2:	4618                	lw	a4,8(a2)
 6c4:	9db9                	addw	a1,a1,a4
 6c6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ca:	6398                	ld	a4,0(a5)
 6cc:	6318                	ld	a4,0(a4)
 6ce:	fee53823          	sd	a4,-16(a0)
 6d2:	a091                	j	716 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6d4:	ff852703          	lw	a4,-8(a0)
 6d8:	9e39                	addw	a2,a2,a4
 6da:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6dc:	ff053703          	ld	a4,-16(a0)
 6e0:	e398                	sd	a4,0(a5)
 6e2:	a099                	j	728 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	6398                	ld	a4,0(a5)
 6e6:	00e7e463          	bltu	a5,a4,6ee <free+0x40>
 6ea:	00e6ea63          	bltu	a3,a4,6fe <free+0x50>
{
 6ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f0:	fed7fae3          	bgeu	a5,a3,6e4 <free+0x36>
 6f4:	6398                	ld	a4,0(a5)
 6f6:	00e6e463          	bltu	a3,a4,6fe <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fa:	fee7eae3          	bltu	a5,a4,6ee <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6fe:	ff852583          	lw	a1,-8(a0)
 702:	6390                	ld	a2,0(a5)
 704:	02059713          	slli	a4,a1,0x20
 708:	9301                	srli	a4,a4,0x20
 70a:	0712                	slli	a4,a4,0x4
 70c:	9736                	add	a4,a4,a3
 70e:	fae60ae3          	beq	a2,a4,6c2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 712:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 716:	4790                	lw	a2,8(a5)
 718:	02061713          	slli	a4,a2,0x20
 71c:	9301                	srli	a4,a4,0x20
 71e:	0712                	slli	a4,a4,0x4
 720:	973e                	add	a4,a4,a5
 722:	fae689e3          	beq	a3,a4,6d4 <free+0x26>
  } else
    p->s.ptr = bp;
 726:	e394                	sd	a3,0(a5)
  freep = p;
 728:	00001717          	auipc	a4,0x1
 72c:	8cf73c23          	sd	a5,-1832(a4) # 1000 <freep>
}
 730:	6422                	ld	s0,8(sp)
 732:	0141                	addi	sp,sp,16
 734:	8082                	ret

0000000000000736 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 736:	7139                	addi	sp,sp,-64
 738:	fc06                	sd	ra,56(sp)
 73a:	f822                	sd	s0,48(sp)
 73c:	f426                	sd	s1,40(sp)
 73e:	f04a                	sd	s2,32(sp)
 740:	ec4e                	sd	s3,24(sp)
 742:	e852                	sd	s4,16(sp)
 744:	e456                	sd	s5,8(sp)
 746:	e05a                	sd	s6,0(sp)
 748:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74a:	02051493          	slli	s1,a0,0x20
 74e:	9081                	srli	s1,s1,0x20
 750:	04bd                	addi	s1,s1,15
 752:	8091                	srli	s1,s1,0x4
 754:	0014899b          	addiw	s3,s1,1
 758:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 75a:	00001517          	auipc	a0,0x1
 75e:	8a653503          	ld	a0,-1882(a0) # 1000 <freep>
 762:	c515                	beqz	a0,78e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 764:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 766:	4798                	lw	a4,8(a5)
 768:	02977f63          	bgeu	a4,s1,7a6 <malloc+0x70>
 76c:	8a4e                	mv	s4,s3
 76e:	0009871b          	sext.w	a4,s3
 772:	6685                	lui	a3,0x1
 774:	00d77363          	bgeu	a4,a3,77a <malloc+0x44>
 778:	6a05                	lui	s4,0x1
 77a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 77e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 782:	00001917          	auipc	s2,0x1
 786:	87e90913          	addi	s2,s2,-1922 # 1000 <freep>
  if(p == (char*)-1)
 78a:	5afd                	li	s5,-1
 78c:	a88d                	j	7fe <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 78e:	00002797          	auipc	a5,0x2
 792:	88278793          	addi	a5,a5,-1918 # 2010 <base>
 796:	00001717          	auipc	a4,0x1
 79a:	86f73523          	sd	a5,-1942(a4) # 1000 <freep>
 79e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a4:	b7e1                	j	76c <malloc+0x36>
      if(p->s.size == nunits)
 7a6:	02e48b63          	beq	s1,a4,7dc <malloc+0xa6>
        p->s.size -= nunits;
 7aa:	4137073b          	subw	a4,a4,s3
 7ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7b0:	1702                	slli	a4,a4,0x20
 7b2:	9301                	srli	a4,a4,0x20
 7b4:	0712                	slli	a4,a4,0x4
 7b6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7b8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7bc:	00001717          	auipc	a4,0x1
 7c0:	84a73223          	sd	a0,-1980(a4) # 1000 <freep>
      return (void*)(p + 1);
 7c4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7c8:	70e2                	ld	ra,56(sp)
 7ca:	7442                	ld	s0,48(sp)
 7cc:	74a2                	ld	s1,40(sp)
 7ce:	7902                	ld	s2,32(sp)
 7d0:	69e2                	ld	s3,24(sp)
 7d2:	6a42                	ld	s4,16(sp)
 7d4:	6aa2                	ld	s5,8(sp)
 7d6:	6b02                	ld	s6,0(sp)
 7d8:	6121                	addi	sp,sp,64
 7da:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	e118                	sd	a4,0(a0)
 7e0:	bff1                	j	7bc <malloc+0x86>
  hp->s.size = nu;
 7e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e6:	0541                	addi	a0,a0,16
 7e8:	00000097          	auipc	ra,0x0
 7ec:	ec6080e7          	jalr	-314(ra) # 6ae <free>
  return freep;
 7f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f4:	d971                	beqz	a0,7c8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	fa9776e3          	bgeu	a4,s1,7a6 <malloc+0x70>
    if(p == freep)
 7fe:	00093703          	ld	a4,0(s2)
 802:	853e                	mv	a0,a5
 804:	fef719e3          	bne	a4,a5,7f6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 808:	8552                	mv	a0,s4
 80a:	00000097          	auipc	ra,0x0
 80e:	b7e080e7          	jalr	-1154(ra) # 388 <sbrk>
  if(p == (char*)-1)
 812:	fd5518e3          	bne	a0,s5,7e2 <malloc+0xac>
        return 0;
 816:	4501                	li	a0,0
 818:	bf45                	j	7c8 <malloc+0x92>

000000000000081a <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 81a:	7179                	addi	sp,sp,-48
 81c:	f406                	sd	ra,40(sp)
 81e:	f022                	sd	s0,32(sp)
 820:	ec26                	sd	s1,24(sp)
 822:	e84a                	sd	s2,16(sp)
 824:	e44e                	sd	s3,8(sp)
 826:	e052                	sd	s4,0(sp)
 828:	1800                	addi	s0,sp,48
 82a:	8a2a                	mv	s4,a0
 82c:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 82e:	4581                	li	a1,0
 830:	00000517          	auipc	a0,0x0
 834:	09050513          	addi	a0,a0,144 # 8c0 <digits+0x18>
 838:	00000097          	auipc	ra,0x0
 83c:	b08080e7          	jalr	-1272(ra) # 340 <open>
  if(fd < 0) {
 840:	04054263          	bltz	a0,884 <statistics+0x6a>
 844:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 846:	4481                	li	s1,0
 848:	03205063          	blez	s2,868 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 84c:	4099063b          	subw	a2,s2,s1
 850:	009a05b3          	add	a1,s4,s1
 854:	854e                	mv	a0,s3
 856:	00000097          	auipc	ra,0x0
 85a:	ac2080e7          	jalr	-1342(ra) # 318 <read>
 85e:	00054563          	bltz	a0,868 <statistics+0x4e>
      break;
    }
    i += n;
 862:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 864:	ff24c4e3          	blt	s1,s2,84c <statistics+0x32>
  }
  close(fd);
 868:	854e                	mv	a0,s3
 86a:	00000097          	auipc	ra,0x0
 86e:	abe080e7          	jalr	-1346(ra) # 328 <close>
  return i;
}
 872:	8526                	mv	a0,s1
 874:	70a2                	ld	ra,40(sp)
 876:	7402                	ld	s0,32(sp)
 878:	64e2                	ld	s1,24(sp)
 87a:	6942                	ld	s2,16(sp)
 87c:	69a2                	ld	s3,8(sp)
 87e:	6a02                	ld	s4,0(sp)
 880:	6145                	addi	sp,sp,48
 882:	8082                	ret
      fprintf(2, "stats: open failed\n");
 884:	00000597          	auipc	a1,0x0
 888:	04c58593          	addi	a1,a1,76 # 8d0 <digits+0x28>
 88c:	4509                	li	a0,2
 88e:	00000097          	auipc	ra,0x0
 892:	dbc080e7          	jalr	-580(ra) # 64a <fprintf>
      exit(1);
 896:	4505                	li	a0,1
 898:	00000097          	auipc	ra,0x0
 89c:	a68080e7          	jalr	-1432(ra) # 300 <exit>
