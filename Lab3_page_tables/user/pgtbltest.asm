
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	ff293903          	ld	s2,-14(s2) # 1000 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	528080e7          	jalr	1320(ra) # 53e <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	9cc50513          	addi	a0,a0,-1588 # 9f0 <malloc+0xec>
  2c:	00001097          	auipc	ra,0x1
  30:	81a080e7          	jalr	-2022(ra) # 846 <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	488080e7          	jalr	1160(ra) # 4be <exit>

000000000000003e <ugetpid_test>:
}

void
ugetpid_test()
{
  3e:	7179                	addi	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9d050513          	addi	a0,a0,-1584 # a18 <malloc+0x114>
  50:	00000097          	auipc	ra,0x0
  54:	7f6080e7          	jalr	2038(ra) # 846 <printf>
  testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	9d878793          	addi	a5,a5,-1576 # a30 <malloc+0x12c>
  60:	00001717          	auipc	a4,0x1
  64:	faf73023          	sd	a5,-96(a4) # 1000 <testname>
  68:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	44a080e7          	jalr	1098(ra) # 4b6 <fork>
  74:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
      wait(&ret);
  7a:	fdc40513          	addi	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	448080e7          	jalr	1096(ra) # 4c6 <wait>
      if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
  for (i = 0; i < 64; i++) {
  8c:	34fd                	addiw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	9c050513          	addi	a0,a0,-1600 # a50 <malloc+0x14c>
  98:	00000097          	auipc	ra,0x0
  9c:	7ae080e7          	jalr	1966(ra) # 846 <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	addi	sp,sp,48
  a8:	8082                	ret
        exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	412080e7          	jalr	1042(ra) # 4be <exit>
    if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	48a080e7          	jalr	1162(ra) # 53e <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3e2080e7          	jalr	994(ra) # 4a0 <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
      err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	97650513          	addi	a0,a0,-1674 # a40 <malloc+0x13c>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3e2080e7          	jalr	994(ra) # 4be <exit>

00000000000000e4 <pgaccess_test>:

void
pgaccess_test()
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	97a50513          	addi	a0,a0,-1670 # a68 <malloc+0x164>
  f6:	00000097          	auipc	ra,0x0
  fa:	750080e7          	jalr	1872(ra) # 846 <printf>
  testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	98278793          	addi	a5,a5,-1662 # a80 <malloc+0x17c>
 106:	00001717          	auipc	a4,0x1
 10a:	eef73d23          	sd	a5,-262(a4) # 1000 <testname>
  buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7f2080e7          	jalr	2034(ra) # 904 <malloc>
 11a:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	addi	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	442080e7          	jalr	1090(ra) # 566 <pgaccess>
 12c:	08054563          	bltz	a0,1b6 <pgaccess_test+0xd2>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <testname>
 138:	2705                	addiw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <base+0xfe0>
 146:	2705                	addiw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <base+0x1cfe0>
 154:	2705                	addiw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	addi	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	402080e7          	jalr	1026(ra) # 566 <pgaccess>
 16c:	04054d63          	bltz	a0,1c6 <pgaccess_test+0xe2>
    err("pgaccess failed");
  printf("%p\n", abits);
 170:	fdc42583          	lw	a1,-36(s0)
 174:	00001517          	auipc	a0,0x1
 178:	92c50513          	addi	a0,a0,-1748 # aa0 <malloc+0x19c>
 17c:	00000097          	auipc	ra,0x0
 180:	6ca080e7          	jalr	1738(ra) # 846 <printf>
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 184:	fdc42703          	lw	a4,-36(s0)
 188:	400007b7          	lui	a5,0x40000
 18c:	0799                	addi	a5,a5,6
 18e:	04f71463          	bne	a4,a5,1d6 <pgaccess_test+0xf2>
    err("incorrect access bits set");
  free(buf);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	6e8080e7          	jalr	1768(ra) # 87c <free>
  printf("pgaccess_test: OK\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	92c50513          	addi	a0,a0,-1748 # ac8 <malloc+0x1c4>
 1a4:	00000097          	auipc	ra,0x0
 1a8:	6a2080e7          	jalr	1698(ra) # 846 <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6145                	addi	sp,sp,48
 1b4:	8082                	ret
    err("pgaccess failed");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	8da50513          	addi	a0,a0,-1830 # a90 <malloc+0x18c>
 1be:	00000097          	auipc	ra,0x0
 1c2:	e42080e7          	jalr	-446(ra) # 0 <err>
    err("pgaccess failed");
 1c6:	00001517          	auipc	a0,0x1
 1ca:	8ca50513          	addi	a0,a0,-1846 # a90 <malloc+0x18c>
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e32080e7          	jalr	-462(ra) # 0 <err>
    err("incorrect access bits set");
 1d6:	00001517          	auipc	a0,0x1
 1da:	8d250513          	addi	a0,a0,-1838 # aa8 <malloc+0x1a4>
 1de:	00000097          	auipc	ra,0x0
 1e2:	e22080e7          	jalr	-478(ra) # 0 <err>

00000000000001e6 <main>:
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e406                	sd	ra,8(sp)
 1ea:	e022                	sd	s0,0(sp)
 1ec:	0800                	addi	s0,sp,16
  ugetpid_test();
 1ee:	00000097          	auipc	ra,0x0
 1f2:	e50080e7          	jalr	-432(ra) # 3e <ugetpid_test>
  pgaccess_test();
 1f6:	00000097          	auipc	ra,0x0
 1fa:	eee080e7          	jalr	-274(ra) # e4 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	8e250513          	addi	a0,a0,-1822 # ae0 <malloc+0x1dc>
 206:	00000097          	auipc	ra,0x0
 20a:	640080e7          	jalr	1600(ra) # 846 <printf>
  exit(0);
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	2ae080e7          	jalr	686(ra) # 4be <exit>

0000000000000218 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 220:	00000097          	auipc	ra,0x0
 224:	fc6080e7          	jalr	-58(ra) # 1e6 <main>
  exit(0);
 228:	4501                	li	a0,0
 22a:	00000097          	auipc	ra,0x0
 22e:	294080e7          	jalr	660(ra) # 4be <exit>

0000000000000232 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 238:	87aa                	mv	a5,a0
 23a:	0585                	addi	a1,a1,1
 23c:	0785                	addi	a5,a5,1
 23e:	fff5c703          	lbu	a4,-1(a1)
 242:	fee78fa3          	sb	a4,-1(a5) # 3fffffff <base+0x3fffefdf>
 246:	fb75                	bnez	a4,23a <strcpy+0x8>
    ;
  return os;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 254:	00054783          	lbu	a5,0(a0)
 258:	cb91                	beqz	a5,26c <strcmp+0x1e>
 25a:	0005c703          	lbu	a4,0(a1)
 25e:	00f71763          	bne	a4,a5,26c <strcmp+0x1e>
    p++, q++;
 262:	0505                	addi	a0,a0,1
 264:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 266:	00054783          	lbu	a5,0(a0)
 26a:	fbe5                	bnez	a5,25a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 26c:	0005c503          	lbu	a0,0(a1)
}
 270:	40a7853b          	subw	a0,a5,a0
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <strlen>:

uint
strlen(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 280:	00054783          	lbu	a5,0(a0)
 284:	cf91                	beqz	a5,2a0 <strlen+0x26>
 286:	0505                	addi	a0,a0,1
 288:	87aa                	mv	a5,a0
 28a:	4685                	li	a3,1
 28c:	9e89                	subw	a3,a3,a0
 28e:	00f6853b          	addw	a0,a3,a5
 292:	0785                	addi	a5,a5,1
 294:	fff7c703          	lbu	a4,-1(a5)
 298:	fb7d                	bnez	a4,28e <strlen+0x14>
    ;
  return n;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  for(n = 0; s[n]; n++)
 2a0:	4501                	li	a0,0
 2a2:	bfe5                	j	29a <strlen+0x20>

00000000000002a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2aa:	ce09                	beqz	a2,2c4 <memset+0x20>
 2ac:	87aa                	mv	a5,a0
 2ae:	fff6071b          	addiw	a4,a2,-1
 2b2:	1702                	slli	a4,a4,0x20
 2b4:	9301                	srli	a4,a4,0x20
 2b6:	0705                	addi	a4,a4,1
 2b8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2be:	0785                	addi	a5,a5,1
 2c0:	fee79de3          	bne	a5,a4,2ba <memset+0x16>
  }
  return dst;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret

00000000000002ca <strchr>:

char*
strchr(const char *s, char c)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2d0:	00054783          	lbu	a5,0(a0)
 2d4:	cb99                	beqz	a5,2ea <strchr+0x20>
    if(*s == c)
 2d6:	00f58763          	beq	a1,a5,2e4 <strchr+0x1a>
  for(; *s; s++)
 2da:	0505                	addi	a0,a0,1
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	fbfd                	bnez	a5,2d6 <strchr+0xc>
      return (char*)s;
  return 0;
 2e2:	4501                	li	a0,0
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  return 0;
 2ea:	4501                	li	a0,0
 2ec:	bfe5                	j	2e4 <strchr+0x1a>

00000000000002ee <gets>:

char*
gets(char *buf, int max)
{
 2ee:	711d                	addi	sp,sp,-96
 2f0:	ec86                	sd	ra,88(sp)
 2f2:	e8a2                	sd	s0,80(sp)
 2f4:	e4a6                	sd	s1,72(sp)
 2f6:	e0ca                	sd	s2,64(sp)
 2f8:	fc4e                	sd	s3,56(sp)
 2fa:	f852                	sd	s4,48(sp)
 2fc:	f456                	sd	s5,40(sp)
 2fe:	f05a                	sd	s6,32(sp)
 300:	ec5e                	sd	s7,24(sp)
 302:	1080                	addi	s0,sp,96
 304:	8baa                	mv	s7,a0
 306:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 308:	892a                	mv	s2,a0
 30a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 30c:	4aa9                	li	s5,10
 30e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 310:	89a6                	mv	s3,s1
 312:	2485                	addiw	s1,s1,1
 314:	0344d863          	bge	s1,s4,344 <gets+0x56>
    cc = read(0, &c, 1);
 318:	4605                	li	a2,1
 31a:	faf40593          	addi	a1,s0,-81
 31e:	4501                	li	a0,0
 320:	00000097          	auipc	ra,0x0
 324:	1b6080e7          	jalr	438(ra) # 4d6 <read>
    if(cc < 1)
 328:	00a05e63          	blez	a0,344 <gets+0x56>
    buf[i++] = c;
 32c:	faf44783          	lbu	a5,-81(s0)
 330:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 334:	01578763          	beq	a5,s5,342 <gets+0x54>
 338:	0905                	addi	s2,s2,1
 33a:	fd679be3          	bne	a5,s6,310 <gets+0x22>
  for(i=0; i+1 < max; ){
 33e:	89a6                	mv	s3,s1
 340:	a011                	j	344 <gets+0x56>
 342:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 344:	99de                	add	s3,s3,s7
 346:	00098023          	sb	zero,0(s3)
  return buf;
}
 34a:	855e                	mv	a0,s7
 34c:	60e6                	ld	ra,88(sp)
 34e:	6446                	ld	s0,80(sp)
 350:	64a6                	ld	s1,72(sp)
 352:	6906                	ld	s2,64(sp)
 354:	79e2                	ld	s3,56(sp)
 356:	7a42                	ld	s4,48(sp)
 358:	7aa2                	ld	s5,40(sp)
 35a:	7b02                	ld	s6,32(sp)
 35c:	6be2                	ld	s7,24(sp)
 35e:	6125                	addi	sp,sp,96
 360:	8082                	ret

0000000000000362 <stat>:

int
stat(const char *n, struct stat *st)
{
 362:	1101                	addi	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	e426                	sd	s1,8(sp)
 36a:	e04a                	sd	s2,0(sp)
 36c:	1000                	addi	s0,sp,32
 36e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 370:	4581                	li	a1,0
 372:	00000097          	auipc	ra,0x0
 376:	18c080e7          	jalr	396(ra) # 4fe <open>
  if(fd < 0)
 37a:	02054563          	bltz	a0,3a4 <stat+0x42>
 37e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 380:	85ca                	mv	a1,s2
 382:	00000097          	auipc	ra,0x0
 386:	194080e7          	jalr	404(ra) # 516 <fstat>
 38a:	892a                	mv	s2,a0
  close(fd);
 38c:	8526                	mv	a0,s1
 38e:	00000097          	auipc	ra,0x0
 392:	158080e7          	jalr	344(ra) # 4e6 <close>
  return r;
}
 396:	854a                	mv	a0,s2
 398:	60e2                	ld	ra,24(sp)
 39a:	6442                	ld	s0,16(sp)
 39c:	64a2                	ld	s1,8(sp)
 39e:	6902                	ld	s2,0(sp)
 3a0:	6105                	addi	sp,sp,32
 3a2:	8082                	ret
    return -1;
 3a4:	597d                	li	s2,-1
 3a6:	bfc5                	j	396 <stat+0x34>

00000000000003a8 <atoi>:

int
atoi(const char *s)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ae:	00054603          	lbu	a2,0(a0)
 3b2:	fd06079b          	addiw	a5,a2,-48
 3b6:	0ff7f793          	andi	a5,a5,255
 3ba:	4725                	li	a4,9
 3bc:	02f76963          	bltu	a4,a5,3ee <atoi+0x46>
 3c0:	86aa                	mv	a3,a0
  n = 0;
 3c2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3c4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3c6:	0685                	addi	a3,a3,1
 3c8:	0025179b          	slliw	a5,a0,0x2
 3cc:	9fa9                	addw	a5,a5,a0
 3ce:	0017979b          	slliw	a5,a5,0x1
 3d2:	9fb1                	addw	a5,a5,a2
 3d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d8:	0006c603          	lbu	a2,0(a3)
 3dc:	fd06071b          	addiw	a4,a2,-48
 3e0:	0ff77713          	andi	a4,a4,255
 3e4:	fee5f1e3          	bgeu	a1,a4,3c6 <atoi+0x1e>
  return n;
}
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret
  n = 0;
 3ee:	4501                	li	a0,0
 3f0:	bfe5                	j	3e8 <atoi+0x40>

00000000000003f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3f8:	02b57663          	bgeu	a0,a1,424 <memmove+0x32>
    while(n-- > 0)
 3fc:	02c05163          	blez	a2,41e <memmove+0x2c>
 400:	fff6079b          	addiw	a5,a2,-1
 404:	1782                	slli	a5,a5,0x20
 406:	9381                	srli	a5,a5,0x20
 408:	0785                	addi	a5,a5,1
 40a:	97aa                	add	a5,a5,a0
  dst = vdst;
 40c:	872a                	mv	a4,a0
      *dst++ = *src++;
 40e:	0585                	addi	a1,a1,1
 410:	0705                	addi	a4,a4,1
 412:	fff5c683          	lbu	a3,-1(a1)
 416:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 41a:	fee79ae3          	bne	a5,a4,40e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
    dst += n;
 424:	00c50733          	add	a4,a0,a2
    src += n;
 428:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 42a:	fec05ae3          	blez	a2,41e <memmove+0x2c>
 42e:	fff6079b          	addiw	a5,a2,-1
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	fff7c793          	not	a5,a5
 43a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 43c:	15fd                	addi	a1,a1,-1
 43e:	177d                	addi	a4,a4,-1
 440:	0005c683          	lbu	a3,0(a1)
 444:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 448:	fee79ae3          	bne	a5,a4,43c <memmove+0x4a>
 44c:	bfc9                	j	41e <memmove+0x2c>

000000000000044e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 454:	ca05                	beqz	a2,484 <memcmp+0x36>
 456:	fff6069b          	addiw	a3,a2,-1
 45a:	1682                	slli	a3,a3,0x20
 45c:	9281                	srli	a3,a3,0x20
 45e:	0685                	addi	a3,a3,1
 460:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 462:	00054783          	lbu	a5,0(a0)
 466:	0005c703          	lbu	a4,0(a1)
 46a:	00e79863          	bne	a5,a4,47a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 46e:	0505                	addi	a0,a0,1
    p2++;
 470:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 472:	fed518e3          	bne	a0,a3,462 <memcmp+0x14>
  }
  return 0;
 476:	4501                	li	a0,0
 478:	a019                	j	47e <memcmp+0x30>
      return *p1 - *p2;
 47a:	40e7853b          	subw	a0,a5,a4
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  return 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <memcmp+0x30>

0000000000000488 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e406                	sd	ra,8(sp)
 48c:	e022                	sd	s0,0(sp)
 48e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 490:	00000097          	auipc	ra,0x0
 494:	f62080e7          	jalr	-158(ra) # 3f2 <memmove>
}
 498:	60a2                	ld	ra,8(sp)
 49a:	6402                	ld	s0,0(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret

00000000000004a0 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e422                	sd	s0,8(sp)
 4a4:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 4a6:	040007b7          	lui	a5,0x4000
}
 4aa:	17f5                	addi	a5,a5,-3
 4ac:	07b2                	slli	a5,a5,0xc
 4ae:	4388                	lw	a0,0(a5)
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b6:	4885                	li	a7,1
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exit>:
.global exit
exit:
 li a7, SYS_exit
 4be:	4889                	li	a7,2
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c6:	488d                	li	a7,3
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ce:	4891                	li	a7,4
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <read>:
.global read
read:
 li a7, SYS_read
 4d6:	4895                	li	a7,5
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <write>:
.global write
write:
 li a7, SYS_write
 4de:	48c1                	li	a7,16
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <close>:
.global close
close:
 li a7, SYS_close
 4e6:	48d5                	li	a7,21
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ee:	4899                	li	a7,6
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f6:	489d                	li	a7,7
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <open>:
.global open
open:
 li a7, SYS_open
 4fe:	48bd                	li	a7,15
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 506:	48c5                	li	a7,17
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50e:	48c9                	li	a7,18
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 516:	48a1                	li	a7,8
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <link>:
.global link
link:
 li a7, SYS_link
 51e:	48cd                	li	a7,19
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 526:	48d1                	li	a7,20
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52e:	48a5                	li	a7,9
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <dup>:
.global dup
dup:
 li a7, SYS_dup
 536:	48a9                	li	a7,10
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53e:	48ad                	li	a7,11
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 546:	48b1                	li	a7,12
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54e:	48b5                	li	a7,13
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 556:	48b9                	li	a7,14
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <connect>:
.global connect
connect:
 li a7, SYS_connect
 55e:	48f5                	li	a7,29
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 566:	48f9                	li	a7,30
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56e:	1101                	addi	sp,sp,-32
 570:	ec06                	sd	ra,24(sp)
 572:	e822                	sd	s0,16(sp)
 574:	1000                	addi	s0,sp,32
 576:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57a:	4605                	li	a2,1
 57c:	fef40593          	addi	a1,s0,-17
 580:	00000097          	auipc	ra,0x0
 584:	f5e080e7          	jalr	-162(ra) # 4de <write>
}
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	6105                	addi	sp,sp,32
 58e:	8082                	ret

0000000000000590 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	7139                	addi	sp,sp,-64
 592:	fc06                	sd	ra,56(sp)
 594:	f822                	sd	s0,48(sp)
 596:	f426                	sd	s1,40(sp)
 598:	f04a                	sd	s2,32(sp)
 59a:	ec4e                	sd	s3,24(sp)
 59c:	0080                	addi	s0,sp,64
 59e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a0:	c299                	beqz	a3,5a6 <printint+0x16>
 5a2:	0805c863          	bltz	a1,632 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a6:	2581                	sext.w	a1,a1
  neg = 0;
 5a8:	4881                	li	a7,0
 5aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b0:	2601                	sext.w	a2,a2
 5b2:	00000517          	auipc	a0,0x0
 5b6:	55e50513          	addi	a0,a0,1374 # b10 <digits>
 5ba:	883a                	mv	a6,a4
 5bc:	2705                	addiw	a4,a4,1
 5be:	02c5f7bb          	remuw	a5,a1,a2
 5c2:	1782                	slli	a5,a5,0x20
 5c4:	9381                	srli	a5,a5,0x20
 5c6:	97aa                	add	a5,a5,a0
 5c8:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffefe0>
 5cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d0:	0005879b          	sext.w	a5,a1
 5d4:	02c5d5bb          	divuw	a1,a1,a2
 5d8:	0685                	addi	a3,a3,1
 5da:	fec7f0e3          	bgeu	a5,a2,5ba <printint+0x2a>
  if(neg)
 5de:	00088b63          	beqz	a7,5f4 <printint+0x64>
    buf[i++] = '-';
 5e2:	fd040793          	addi	a5,s0,-48
 5e6:	973e                	add	a4,a4,a5
 5e8:	02d00793          	li	a5,45
 5ec:	fef70823          	sb	a5,-16(a4)
 5f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f4:	02e05863          	blez	a4,624 <printint+0x94>
 5f8:	fc040793          	addi	a5,s0,-64
 5fc:	00e78933          	add	s2,a5,a4
 600:	fff78993          	addi	s3,a5,-1
 604:	99ba                	add	s3,s3,a4
 606:	377d                	addiw	a4,a4,-1
 608:	1702                	slli	a4,a4,0x20
 60a:	9301                	srli	a4,a4,0x20
 60c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 610:	fff94583          	lbu	a1,-1(s2)
 614:	8526                	mv	a0,s1
 616:	00000097          	auipc	ra,0x0
 61a:	f58080e7          	jalr	-168(ra) # 56e <putc>
  while(--i >= 0)
 61e:	197d                	addi	s2,s2,-1
 620:	ff3918e3          	bne	s2,s3,610 <printint+0x80>
}
 624:	70e2                	ld	ra,56(sp)
 626:	7442                	ld	s0,48(sp)
 628:	74a2                	ld	s1,40(sp)
 62a:	7902                	ld	s2,32(sp)
 62c:	69e2                	ld	s3,24(sp)
 62e:	6121                	addi	sp,sp,64
 630:	8082                	ret
    x = -xx;
 632:	40b005bb          	negw	a1,a1
    neg = 1;
 636:	4885                	li	a7,1
    x = -xx;
 638:	bf8d                	j	5aa <printint+0x1a>

000000000000063a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63a:	7119                	addi	sp,sp,-128
 63c:	fc86                	sd	ra,120(sp)
 63e:	f8a2                	sd	s0,112(sp)
 640:	f4a6                	sd	s1,104(sp)
 642:	f0ca                	sd	s2,96(sp)
 644:	ecce                	sd	s3,88(sp)
 646:	e8d2                	sd	s4,80(sp)
 648:	e4d6                	sd	s5,72(sp)
 64a:	e0da                	sd	s6,64(sp)
 64c:	fc5e                	sd	s7,56(sp)
 64e:	f862                	sd	s8,48(sp)
 650:	f466                	sd	s9,40(sp)
 652:	f06a                	sd	s10,32(sp)
 654:	ec6e                	sd	s11,24(sp)
 656:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 658:	0005c903          	lbu	s2,0(a1)
 65c:	18090f63          	beqz	s2,7fa <vprintf+0x1c0>
 660:	8aaa                	mv	s5,a0
 662:	8b32                	mv	s6,a2
 664:	00158493          	addi	s1,a1,1
  state = 0;
 668:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 66a:	02500a13          	li	s4,37
      if(c == 'd'){
 66e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 672:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 676:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 67a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	492b8b93          	addi	s7,s7,1170 # b10 <digits>
 686:	a839                	j	6a4 <vprintf+0x6a>
        putc(fd, c);
 688:	85ca                	mv	a1,s2
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	ee2080e7          	jalr	-286(ra) # 56e <putc>
 694:	a019                	j	69a <vprintf+0x60>
    } else if(state == '%'){
 696:	01498f63          	beq	s3,s4,6b4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 69a:	0485                	addi	s1,s1,1
 69c:	fff4c903          	lbu	s2,-1(s1)
 6a0:	14090d63          	beqz	s2,7fa <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a8:	fe0997e3          	bnez	s3,696 <vprintf+0x5c>
      if(c == '%'){
 6ac:	fd479ee3          	bne	a5,s4,688 <vprintf+0x4e>
        state = '%';
 6b0:	89be                	mv	s3,a5
 6b2:	b7e5                	j	69a <vprintf+0x60>
      if(c == 'd'){
 6b4:	05878063          	beq	a5,s8,6f4 <vprintf+0xba>
      } else if(c == 'l') {
 6b8:	05978c63          	beq	a5,s9,710 <vprintf+0xd6>
      } else if(c == 'x') {
 6bc:	07a78863          	beq	a5,s10,72c <vprintf+0xf2>
      } else if(c == 'p') {
 6c0:	09b78463          	beq	a5,s11,748 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6c4:	07300713          	li	a4,115
 6c8:	0ce78663          	beq	a5,a4,794 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cc:	06300713          	li	a4,99
 6d0:	0ee78e63          	beq	a5,a4,7cc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6d4:	11478863          	beq	a5,s4,7e4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d8:	85d2                	mv	a1,s4
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e92080e7          	jalr	-366(ra) # 56e <putc>
        putc(fd, c);
 6e4:	85ca                	mv	a1,s2
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e86080e7          	jalr	-378(ra) # 56e <putc>
      }
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b765                	j	69a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6f4:	008b0913          	addi	s2,s6,8
 6f8:	4685                	li	a3,1
 6fa:	4629                	li	a2,10
 6fc:	000b2583          	lw	a1,0(s6)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e8e080e7          	jalr	-370(ra) # 590 <printint>
 70a:	8b4a                	mv	s6,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b771                	j	69a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 710:	008b0913          	addi	s2,s6,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000b2583          	lw	a1,0(s6)
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e72080e7          	jalr	-398(ra) # 590 <printint>
 726:	8b4a                	mv	s6,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	bf85                	j	69a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 72c:	008b0913          	addi	s2,s6,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000b2583          	lw	a1,0(s6)
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e56080e7          	jalr	-426(ra) # 590 <printint>
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bf91                	j	69a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 748:	008b0793          	addi	a5,s6,8
 74c:	f8f43423          	sd	a5,-120(s0)
 750:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 754:	03000593          	li	a1,48
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	e14080e7          	jalr	-492(ra) # 56e <putc>
  putc(fd, 'x');
 762:	85ea                	mv	a1,s10
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e08080e7          	jalr	-504(ra) # 56e <putc>
 76e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 770:	03c9d793          	srli	a5,s3,0x3c
 774:	97de                	add	a5,a5,s7
 776:	0007c583          	lbu	a1,0(a5)
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	df2080e7          	jalr	-526(ra) # 56e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 784:	0992                	slli	s3,s3,0x4
 786:	397d                	addiw	s2,s2,-1
 788:	fe0914e3          	bnez	s2,770 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 78c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 790:	4981                	li	s3,0
 792:	b721                	j	69a <vprintf+0x60>
        s = va_arg(ap, char*);
 794:	008b0993          	addi	s3,s6,8
 798:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 79c:	02090163          	beqz	s2,7be <vprintf+0x184>
        while(*s != 0){
 7a0:	00094583          	lbu	a1,0(s2)
 7a4:	c9a1                	beqz	a1,7f4 <vprintf+0x1ba>
          putc(fd, *s);
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	dc6080e7          	jalr	-570(ra) # 56e <putc>
          s++;
 7b0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7b2:	00094583          	lbu	a1,0(s2)
 7b6:	f9e5                	bnez	a1,7a6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7b8:	8b4e                	mv	s6,s3
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bdf9                	j	69a <vprintf+0x60>
          s = "(null)";
 7be:	00000917          	auipc	s2,0x0
 7c2:	34a90913          	addi	s2,s2,842 # b08 <malloc+0x204>
        while(*s != 0){
 7c6:	02800593          	li	a1,40
 7ca:	bff1                	j	7a6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7cc:	008b0913          	addi	s2,s6,8
 7d0:	000b4583          	lbu	a1,0(s6)
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d98080e7          	jalr	-616(ra) # 56e <putc>
 7de:	8b4a                	mv	s6,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bd65                	j	69a <vprintf+0x60>
        putc(fd, c);
 7e4:	85d2                	mv	a1,s4
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	d86080e7          	jalr	-634(ra) # 56e <putc>
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	b565                	j	69a <vprintf+0x60>
        s = va_arg(ap, char*);
 7f4:	8b4e                	mv	s6,s3
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b54d                	j	69a <vprintf+0x60>
    }
  }
}
 7fa:	70e6                	ld	ra,120(sp)
 7fc:	7446                	ld	s0,112(sp)
 7fe:	74a6                	ld	s1,104(sp)
 800:	7906                	ld	s2,96(sp)
 802:	69e6                	ld	s3,88(sp)
 804:	6a46                	ld	s4,80(sp)
 806:	6aa6                	ld	s5,72(sp)
 808:	6b06                	ld	s6,64(sp)
 80a:	7be2                	ld	s7,56(sp)
 80c:	7c42                	ld	s8,48(sp)
 80e:	7ca2                	ld	s9,40(sp)
 810:	7d02                	ld	s10,32(sp)
 812:	6de2                	ld	s11,24(sp)
 814:	6109                	addi	sp,sp,128
 816:	8082                	ret

0000000000000818 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 818:	715d                	addi	sp,sp,-80
 81a:	ec06                	sd	ra,24(sp)
 81c:	e822                	sd	s0,16(sp)
 81e:	1000                	addi	s0,sp,32
 820:	e010                	sd	a2,0(s0)
 822:	e414                	sd	a3,8(s0)
 824:	e818                	sd	a4,16(s0)
 826:	ec1c                	sd	a5,24(s0)
 828:	03043023          	sd	a6,32(s0)
 82c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 830:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 834:	8622                	mv	a2,s0
 836:	00000097          	auipc	ra,0x0
 83a:	e04080e7          	jalr	-508(ra) # 63a <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <printf>:

void
printf(const char *fmt, ...)
{
 846:	711d                	addi	sp,sp,-96
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e40c                	sd	a1,8(s0)
 850:	e810                	sd	a2,16(s0)
 852:	ec14                	sd	a3,24(s0)
 854:	f018                	sd	a4,32(s0)
 856:	f41c                	sd	a5,40(s0)
 858:	03043823          	sd	a6,48(s0)
 85c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	00840613          	addi	a2,s0,8
 864:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 868:	85aa                	mv	a1,a0
 86a:	4505                	li	a0,1
 86c:	00000097          	auipc	ra,0x0
 870:	dce080e7          	jalr	-562(ra) # 63a <vprintf>
}
 874:	60e2                	ld	ra,24(sp)
 876:	6442                	ld	s0,16(sp)
 878:	6125                	addi	sp,sp,96
 87a:	8082                	ret

000000000000087c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87c:	1141                	addi	sp,sp,-16
 87e:	e422                	sd	s0,8(sp)
 880:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 882:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	00000797          	auipc	a5,0x0
 88a:	78a7b783          	ld	a5,1930(a5) # 1010 <freep>
 88e:	a805                	j	8be <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 890:	4618                	lw	a4,8(a2)
 892:	9db9                	addw	a1,a1,a4
 894:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	6318                	ld	a4,0(a4)
 89c:	fee53823          	sd	a4,-16(a0)
 8a0:	a091                	j	8e4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9e39                	addw	a2,a2,a4
 8a8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053703          	ld	a4,-16(a0)
 8ae:	e398                	sd	a4,0(a5)
 8b0:	a099                	j	8f6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	6398                	ld	a4,0(a5)
 8b4:	00e7e463          	bltu	a5,a4,8bc <free+0x40>
 8b8:	00e6ea63          	bltu	a3,a4,8cc <free+0x50>
{
 8bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	fed7fae3          	bgeu	a5,a3,8b2 <free+0x36>
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e6e463          	bltu	a3,a4,8cc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	fee7eae3          	bltu	a5,a4,8bc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8cc:	ff852583          	lw	a1,-8(a0)
 8d0:	6390                	ld	a2,0(a5)
 8d2:	02059713          	slli	a4,a1,0x20
 8d6:	9301                	srli	a4,a4,0x20
 8d8:	0712                	slli	a4,a4,0x4
 8da:	9736                	add	a4,a4,a3
 8dc:	fae60ae3          	beq	a2,a4,890 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e4:	4790                	lw	a2,8(a5)
 8e6:	02061713          	slli	a4,a2,0x20
 8ea:	9301                	srli	a4,a4,0x20
 8ec:	0712                	slli	a4,a4,0x4
 8ee:	973e                	add	a4,a4,a5
 8f0:	fae689e3          	beq	a3,a4,8a2 <free+0x26>
  } else
    p->s.ptr = bp;
 8f4:	e394                	sd	a3,0(a5)
  freep = p;
 8f6:	00000717          	auipc	a4,0x0
 8fa:	70f73d23          	sd	a5,1818(a4) # 1010 <freep>
}
 8fe:	6422                	ld	s0,8(sp)
 900:	0141                	addi	sp,sp,16
 902:	8082                	ret

0000000000000904 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 904:	7139                	addi	sp,sp,-64
 906:	fc06                	sd	ra,56(sp)
 908:	f822                	sd	s0,48(sp)
 90a:	f426                	sd	s1,40(sp)
 90c:	f04a                	sd	s2,32(sp)
 90e:	ec4e                	sd	s3,24(sp)
 910:	e852                	sd	s4,16(sp)
 912:	e456                	sd	s5,8(sp)
 914:	e05a                	sd	s6,0(sp)
 916:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 918:	02051493          	slli	s1,a0,0x20
 91c:	9081                	srli	s1,s1,0x20
 91e:	04bd                	addi	s1,s1,15
 920:	8091                	srli	s1,s1,0x4
 922:	0014899b          	addiw	s3,s1,1
 926:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 928:	00000517          	auipc	a0,0x0
 92c:	6e853503          	ld	a0,1768(a0) # 1010 <freep>
 930:	c515                	beqz	a0,95c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 934:	4798                	lw	a4,8(a5)
 936:	02977f63          	bgeu	a4,s1,974 <malloc+0x70>
 93a:	8a4e                	mv	s4,s3
 93c:	0009871b          	sext.w	a4,s3
 940:	6685                	lui	a3,0x1
 942:	00d77363          	bgeu	a4,a3,948 <malloc+0x44>
 946:	6a05                	lui	s4,0x1
 948:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 950:	00000917          	auipc	s2,0x0
 954:	6c090913          	addi	s2,s2,1728 # 1010 <freep>
  if(p == (char*)-1)
 958:	5afd                	li	s5,-1
 95a:	a88d                	j	9cc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 95c:	00000797          	auipc	a5,0x0
 960:	6c478793          	addi	a5,a5,1732 # 1020 <base>
 964:	00000717          	auipc	a4,0x0
 968:	6af73623          	sd	a5,1708(a4) # 1010 <freep>
 96c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 972:	b7e1                	j	93a <malloc+0x36>
      if(p->s.size == nunits)
 974:	02e48b63          	beq	s1,a4,9aa <malloc+0xa6>
        p->s.size -= nunits;
 978:	4137073b          	subw	a4,a4,s3
 97c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97e:	1702                	slli	a4,a4,0x20
 980:	9301                	srli	a4,a4,0x20
 982:	0712                	slli	a4,a4,0x4
 984:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 986:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98a:	00000717          	auipc	a4,0x0
 98e:	68a73323          	sd	a0,1670(a4) # 1010 <freep>
      return (void*)(p + 1);
 992:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 996:	70e2                	ld	ra,56(sp)
 998:	7442                	ld	s0,48(sp)
 99a:	74a2                	ld	s1,40(sp)
 99c:	7902                	ld	s2,32(sp)
 99e:	69e2                	ld	s3,24(sp)
 9a0:	6a42                	ld	s4,16(sp)
 9a2:	6aa2                	ld	s5,8(sp)
 9a4:	6b02                	ld	s6,0(sp)
 9a6:	6121                	addi	sp,sp,64
 9a8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9aa:	6398                	ld	a4,0(a5)
 9ac:	e118                	sd	a4,0(a0)
 9ae:	bff1                	j	98a <malloc+0x86>
  hp->s.size = nu;
 9b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b4:	0541                	addi	a0,a0,16
 9b6:	00000097          	auipc	ra,0x0
 9ba:	ec6080e7          	jalr	-314(ra) # 87c <free>
  return freep;
 9be:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c2:	d971                	beqz	a0,996 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c6:	4798                	lw	a4,8(a5)
 9c8:	fa9776e3          	bgeu	a4,s1,974 <malloc+0x70>
    if(p == freep)
 9cc:	00093703          	ld	a4,0(s2)
 9d0:	853e                	mv	a0,a5
 9d2:	fef719e3          	bne	a4,a5,9c4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9d6:	8552                	mv	a0,s4
 9d8:	00000097          	auipc	ra,0x0
 9dc:	b6e080e7          	jalr	-1170(ra) # 546 <sbrk>
  if(p == (char*)-1)
 9e0:	fd5518e3          	bne	a0,s5,9b0 <malloc+0xac>
        return 0;
 9e4:	4501                	li	a0,0
 9e6:	bf45                	j	996 <malloc+0x92>
