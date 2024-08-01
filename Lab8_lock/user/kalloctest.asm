
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test3();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	00050513          	mv	a0,a0
  18:	00001097          	auipc	ra,0x1
  1c:	bd4080e7          	jalr	-1068(ra) # bec <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	fe850513          	addi	a0,a0,-24 # 1010 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	4c4080e7          	jalr	1220(ra) # 4f4 <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	598080e7          	jalr	1432(ra) # 5d2 <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	c2a58593          	addi	a1,a1,-982 # c80 <statistics+0x94>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	9bc080e7          	jalr	-1604(ra) # a1c <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	fa658593          	addi	a1,a1,-90 # 1010 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	c1e50513          	addi	a0,a0,-994 # c90 <statistics+0xa4>
  7a:	00001097          	auipc	ra,0x1
  7e:	9d0080e7          	jalr	-1584(ra) # a4a <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

// Test concurrent kallocs and kfrees
void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	c0650513          	addi	a0,a0,-1018 # c98 <statistics+0xac>
  9a:	00001097          	auipc	ra,0x1
  9e:	9b0080e7          	jalr	-1616(ra) # a4a <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	61c080e7          	jalr	1564(ra) # 6ca <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	60e080e7          	jalr	1550(ra) # 6ca <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	60e080e7          	jalr	1550(ra) # 6da <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	604080e7          	jalr	1540(ra) # 6da <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	bea50513          	addi	a0,a0,-1046 # cc8 <statistics+0xdc>
  e6:	00001097          	auipc	ra,0x1
  ea:	964080e7          	jalr	-1692(ra) # a4a <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	bd850513          	addi	a0,a0,-1064 # cd8 <statistics+0xec>
 108:	00001097          	auipc	ra,0x1
 10c:	942080e7          	jalr	-1726(ra) # a4a <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	b8a50513          	addi	a0,a0,-1142 # ca8 <statistics+0xbc>
 126:	00001097          	auipc	ra,0x1
 12a:	924080e7          	jalr	-1756(ra) # a4a <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	5a2080e7          	jalr	1442(ra) # 6d2 <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <base+0x16690>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	618080e7          	jalr	1560(ra) # 75a <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <freep+0x4>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	608080e7          	jalr	1544(ra) # 75a <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	568080e7          	jalr	1384(ra) # 6d2 <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	b4650513          	addi	a0,a0,-1210 # cb8 <statistics+0xcc>
 17a:	00001097          	auipc	ra,0x1
 17e:	8d0080e7          	jalr	-1840(ra) # a4a <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	54e080e7          	jalr	1358(ra) # 6d2 <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	b5c50513          	addi	a0,a0,-1188 # ce8 <statistics+0xfc>
 194:	00001097          	auipc	ra,0x1
 198:	8b6080e7          	jalr	-1866(ra) # a4a <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	5aa080e7          	jalr	1450(ra) # 75a <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
    uint64 a = (uint64) sbrk(4096);
 1c0:	6505                	lui	a0,0x1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	598080e7          	jalr	1432(ra) # 75a <sbrk>
    if(a == 0xffffffffffffffff){
 1ca:	01250863          	beq	a0,s2,1da <countfree+0x3c>
    *(char *)(a + 4096 - 1) = 1;
 1ce:	6785                	lui	a5,0x1
 1d0:	953e                	add	a0,a0,a5
 1d2:	ff350fa3          	sb	s3,-1(a0) # fff <digits+0x227>
    n += 1;
 1d6:	2485                	addiw	s1,s1,1
  while(1){
 1d8:	b7e5                	j	1c0 <countfree+0x22>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	57e080e7          	jalr	1406(ra) # 75a <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	572080e7          	jalr	1394(ra) # 75a <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

// Test stealing
void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	e062                	sd	s8,0(sp)
 218:	0880                	addi	s0,sp,80
  int free0 = countfree();
 21a:	00000097          	auipc	ra,0x0
 21e:	f84080e7          	jalr	-124(ra) # 19e <countfree>
 222:	8a2a                	mv	s4,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 224:	00001517          	auipc	a0,0x1
 228:	ad450513          	addi	a0,a0,-1324 # cf8 <statistics+0x10c>
 22c:	00001097          	auipc	ra,0x1
 230:	81e080e7          	jalr	-2018(ra) # a4a <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 234:	6621                	lui	a2,0x8
 236:	85d2                	mv	a1,s4
 238:	00001517          	auipc	a0,0x1
 23c:	ad050513          	addi	a0,a0,-1328 # d08 <statistics+0x11c>
 240:	00001097          	auipc	ra,0x1
 244:	80a080e7          	jalr	-2038(ra) # a4a <printf>
  if(n - free0 > 1000) {
 248:	67a1                	lui	a5,0x8
 24a:	414787bb          	subw	a5,a5,s4
 24e:	3e800713          	li	a4,1000
 252:	02f74163          	blt	a4,a5,274 <test2+0x72>
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
 256:	00000097          	auipc	ra,0x0
 25a:	f48080e7          	jalr	-184(ra) # 19e <countfree>
 25e:	892a                	mv	s2,a0
  for (int i = 0; i < 50; i++) {
 260:	4981                	li	s3,0
 262:	03200a93          	li	s5,50
    if(i % 10 == 9)
 266:	4ba9                	li	s7,10
 268:	4b25                	li	s6,9
      printf(".");
 26a:	00001c17          	auipc	s8,0x1
 26e:	afec0c13          	addi	s8,s8,-1282 # d68 <statistics+0x17c>
 272:	a01d                	j	298 <test2+0x96>
    printf("test2 FAILED: cannot allocate enough memory");
 274:	00001517          	auipc	a0,0x1
 278:	ac450513          	addi	a0,a0,-1340 # d38 <statistics+0x14c>
 27c:	00000097          	auipc	ra,0x0
 280:	7ce080e7          	jalr	1998(ra) # a4a <printf>
    exit(-1);
 284:	557d                	li	a0,-1
 286:	00000097          	auipc	ra,0x0
 28a:	44c080e7          	jalr	1100(ra) # 6d2 <exit>
      printf(".");
 28e:	8562                	mv	a0,s8
 290:	00000097          	auipc	ra,0x0
 294:	7ba080e7          	jalr	1978(ra) # a4a <printf>
    if(free1 != free0) {
 298:	032a1263          	bne	s4,s2,2bc <test2+0xba>
  for (int i = 0; i < 50; i++) {
 29c:	0019849b          	addiw	s1,s3,1
 2a0:	0004899b          	sext.w	s3,s1
 2a4:	03598963          	beq	s3,s5,2d6 <test2+0xd4>
    free1 = countfree();
 2a8:	00000097          	auipc	ra,0x0
 2ac:	ef6080e7          	jalr	-266(ra) # 19e <countfree>
 2b0:	892a                	mv	s2,a0
    if(i % 10 == 9)
 2b2:	0374e4bb          	remw	s1,s1,s7
 2b6:	ff6491e3          	bne	s1,s6,298 <test2+0x96>
 2ba:	bfd1                	j	28e <test2+0x8c>
      printf("test2 FAIL: losing pages\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	ab450513          	addi	a0,a0,-1356 # d70 <statistics+0x184>
 2c4:	00000097          	auipc	ra,0x0
 2c8:	786080e7          	jalr	1926(ra) # a4a <printf>
      exit(-1);
 2cc:	557d                	li	a0,-1
 2ce:	00000097          	auipc	ra,0x0
 2d2:	404080e7          	jalr	1028(ra) # 6d2 <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2d6:	00001517          	auipc	a0,0x1
 2da:	aba50513          	addi	a0,a0,-1350 # d90 <statistics+0x1a4>
 2de:	00000097          	auipc	ra,0x0
 2e2:	76c080e7          	jalr	1900(ra) # a4a <printf>
}
 2e6:	60a6                	ld	ra,72(sp)
 2e8:	6406                	ld	s0,64(sp)
 2ea:	74e2                	ld	s1,56(sp)
 2ec:	7942                	ld	s2,48(sp)
 2ee:	79a2                	ld	s3,40(sp)
 2f0:	7a02                	ld	s4,32(sp)
 2f2:	6ae2                	ld	s5,24(sp)
 2f4:	6b42                	ld	s6,16(sp)
 2f6:	6ba2                	ld	s7,8(sp)
 2f8:	6c02                	ld	s8,0(sp)
 2fa:	6161                	addi	sp,sp,80
 2fc:	8082                	ret

00000000000002fe <test3>:

// Test concurrent kalloc/kfree and stealing
void test3(void)
{
 2fe:	7179                	addi	sp,sp,-48
 300:	f406                	sd	ra,40(sp)
 302:	f022                	sd	s0,32(sp)
 304:	ec26                	sd	s1,24(sp)
 306:	e84a                	sd	s2,16(sp)
 308:	e44e                	sd	s3,8(sp)
 30a:	e052                	sd	s4,0(sp)
 30c:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test3\n");  
 30e:	00001517          	auipc	a0,0x1
 312:	a9250513          	addi	a0,a0,-1390 # da0 <statistics+0x1b4>
 316:	00000097          	auipc	ra,0x0
 31a:	734080e7          	jalr	1844(ra) # a4a <printf>
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
 31e:	00000097          	auipc	ra,0x0
 322:	3ac080e7          	jalr	940(ra) # 6ca <fork>
    if(pid < 0){
 326:	04054963          	bltz	a0,378 <test3+0x7a>
 32a:	892a                	mv	s2,a0
    }
    if(pid == 0){
      if (i == 0) {
        for(i = 0; i < N; i++) {
          a = sbrk(4096);
          *(int *)(a+4) = 1;
 32c:	4a05                	li	s4,1
        for(i = 0; i < N; i++) {
 32e:	69e1                	lui	s3,0x18
 330:	6a098993          	addi	s3,s3,1696 # 186a0 <base+0x16690>
    if(pid == 0){
 334:	cd39                	beqz	a0,392 <test3+0x94>
    int pid = fork();
 336:	00000097          	auipc	ra,0x0
 33a:	394080e7          	jalr	916(ra) # 6ca <fork>
    if(pid < 0){
 33e:	02054d63          	bltz	a0,378 <test3+0x7a>
    if(pid == 0){
 342:	c94d                	beqz	a0,3f4 <test3+0xf6>
      }
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 344:	4501                	li	a0,0
 346:	00000097          	auipc	ra,0x0
 34a:	394080e7          	jalr	916(ra) # 6da <wait>
 34e:	4501                	li	a0,0
 350:	00000097          	auipc	ra,0x0
 354:	38a080e7          	jalr	906(ra) # 6da <wait>
  }
  printf("test3 OK\n");
 358:	00001517          	auipc	a0,0x1
 35c:	a6850513          	addi	a0,a0,-1432 # dc0 <statistics+0x1d4>
 360:	00000097          	auipc	ra,0x0
 364:	6ea080e7          	jalr	1770(ra) # a4a <printf>
}
 368:	70a2                	ld	ra,40(sp)
 36a:	7402                	ld	s0,32(sp)
 36c:	64e2                	ld	s1,24(sp)
 36e:	6942                	ld	s2,16(sp)
 370:	69a2                	ld	s3,8(sp)
 372:	6a02                	ld	s4,0(sp)
 374:	6145                	addi	sp,sp,48
 376:	8082                	ret
      printf("fork failed");
 378:	00001517          	auipc	a0,0x1
 37c:	93050513          	addi	a0,a0,-1744 # ca8 <statistics+0xbc>
 380:	00000097          	auipc	ra,0x0
 384:	6ca080e7          	jalr	1738(ra) # a4a <printf>
      exit(-1);
 388:	557d                	li	a0,-1
 38a:	00000097          	auipc	ra,0x0
 38e:	348080e7          	jalr	840(ra) # 6d2 <exit>
          a = sbrk(4096);
 392:	6505                	lui	a0,0x1
 394:	00000097          	auipc	ra,0x0
 398:	3c6080e7          	jalr	966(ra) # 75a <sbrk>
 39c:	84aa                	mv	s1,a0
          *(int *)(a+4) = 1;
 39e:	01452223          	sw	s4,4(a0) # 1004 <freep+0x4>
          a1 = sbrk(-4096);
 3a2:	757d                	lui	a0,0xfffff
 3a4:	00000097          	auipc	ra,0x0
 3a8:	3b6080e7          	jalr	950(ra) # 75a <sbrk>
          if (a1 != a + 4096) {
 3ac:	6785                	lui	a5,0x1
 3ae:	94be                	add	s1,s1,a5
 3b0:	02951563          	bne	a0,s1,3da <test3+0xdc>
        for(i = 0; i < N; i++) {
 3b4:	2905                	addiw	s2,s2,1
 3b6:	fd391ee3          	bne	s2,s3,392 <test3+0x94>
        printf("child done %d\n", i);
 3ba:	65e1                	lui	a1,0x18
 3bc:	6a058593          	addi	a1,a1,1696 # 186a0 <base+0x16690>
 3c0:	00001517          	auipc	a0,0x1
 3c4:	9f050513          	addi	a0,a0,-1552 # db0 <statistics+0x1c4>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	682080e7          	jalr	1666(ra) # a4a <printf>
        exit(0);
 3d0:	4501                	li	a0,0
 3d2:	00000097          	auipc	ra,0x0
 3d6:	300080e7          	jalr	768(ra) # 6d2 <exit>
            printf("wrong sbrk\n");
 3da:	00001517          	auipc	a0,0x1
 3de:	8de50513          	addi	a0,a0,-1826 # cb8 <statistics+0xcc>
 3e2:	00000097          	auipc	ra,0x0
 3e6:	668080e7          	jalr	1640(ra) # a4a <printf>
            exit(-1);
 3ea:	557d                	li	a0,-1
 3ec:	00000097          	auipc	ra,0x0
 3f0:	2e6080e7          	jalr	742(ra) # 6d2 <exit>
        countfree();
 3f4:	00000097          	auipc	ra,0x0
 3f8:	daa080e7          	jalr	-598(ra) # 19e <countfree>
        printf("child done %d\n", i);
 3fc:	4585                	li	a1,1
 3fe:	00001517          	auipc	a0,0x1
 402:	9b250513          	addi	a0,a0,-1614 # db0 <statistics+0x1c4>
 406:	00000097          	auipc	ra,0x0
 40a:	644080e7          	jalr	1604(ra) # a4a <printf>
        exit(0);
 40e:	4501                	li	a0,0
 410:	00000097          	auipc	ra,0x0
 414:	2c2080e7          	jalr	706(ra) # 6d2 <exit>

0000000000000418 <main>:
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  test1();
 420:	00000097          	auipc	ra,0x0
 424:	c64080e7          	jalr	-924(ra) # 84 <test1>
  test2();
 428:	00000097          	auipc	ra,0x0
 42c:	dda080e7          	jalr	-550(ra) # 202 <test2>
  test3();
 430:	00000097          	auipc	ra,0x0
 434:	ece080e7          	jalr	-306(ra) # 2fe <test3>
  exit(0);
 438:	4501                	li	a0,0
 43a:	00000097          	auipc	ra,0x0
 43e:	298080e7          	jalr	664(ra) # 6d2 <exit>

0000000000000442 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
  extern int main();
  main();
 44a:	00000097          	auipc	ra,0x0
 44e:	fce080e7          	jalr	-50(ra) # 418 <main>
  exit(0);
 452:	4501                	li	a0,0
 454:	00000097          	auipc	ra,0x0
 458:	27e080e7          	jalr	638(ra) # 6d2 <exit>

000000000000045c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e422                	sd	s0,8(sp)
 460:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 462:	87aa                	mv	a5,a0
 464:	0585                	addi	a1,a1,1
 466:	0785                	addi	a5,a5,1
 468:	fff5c703          	lbu	a4,-1(a1)
 46c:	fee78fa3          	sb	a4,-1(a5) # fff <digits+0x227>
 470:	fb75                	bnez	a4,464 <strcpy+0x8>
    ;
  return os;
}
 472:	6422                	ld	s0,8(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret

0000000000000478 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 47e:	00054783          	lbu	a5,0(a0)
 482:	cb91                	beqz	a5,496 <strcmp+0x1e>
 484:	0005c703          	lbu	a4,0(a1)
 488:	00f71763          	bne	a4,a5,496 <strcmp+0x1e>
    p++, q++;
 48c:	0505                	addi	a0,a0,1
 48e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 490:	00054783          	lbu	a5,0(a0)
 494:	fbe5                	bnez	a5,484 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 496:	0005c503          	lbu	a0,0(a1)
}
 49a:	40a7853b          	subw	a0,a5,a0
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret

00000000000004a4 <strlen>:

uint
strlen(const char *s)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4aa:	00054783          	lbu	a5,0(a0)
 4ae:	cf91                	beqz	a5,4ca <strlen+0x26>
 4b0:	0505                	addi	a0,a0,1
 4b2:	87aa                	mv	a5,a0
 4b4:	4685                	li	a3,1
 4b6:	9e89                	subw	a3,a3,a0
 4b8:	00f6853b          	addw	a0,a3,a5
 4bc:	0785                	addi	a5,a5,1
 4be:	fff7c703          	lbu	a4,-1(a5)
 4c2:	fb7d                	bnez	a4,4b8 <strlen+0x14>
    ;
  return n;
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
  for(n = 0; s[n]; n++)
 4ca:	4501                	li	a0,0
 4cc:	bfe5                	j	4c4 <strlen+0x20>

00000000000004ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e422                	sd	s0,8(sp)
 4d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4d4:	ce09                	beqz	a2,4ee <memset+0x20>
 4d6:	87aa                	mv	a5,a0
 4d8:	fff6071b          	addiw	a4,a2,-1
 4dc:	1702                	slli	a4,a4,0x20
 4de:	9301                	srli	a4,a4,0x20
 4e0:	0705                	addi	a4,a4,1
 4e2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 4e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4e8:	0785                	addi	a5,a5,1
 4ea:	fee79de3          	bne	a5,a4,4e4 <memset+0x16>
  }
  return dst;
}
 4ee:	6422                	ld	s0,8(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <strchr>:

char*
strchr(const char *s, char c)
{
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e422                	sd	s0,8(sp)
 4f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4fa:	00054783          	lbu	a5,0(a0)
 4fe:	cb99                	beqz	a5,514 <strchr+0x20>
    if(*s == c)
 500:	00f58763          	beq	a1,a5,50e <strchr+0x1a>
  for(; *s; s++)
 504:	0505                	addi	a0,a0,1
 506:	00054783          	lbu	a5,0(a0)
 50a:	fbfd                	bnez	a5,500 <strchr+0xc>
      return (char*)s;
  return 0;
 50c:	4501                	li	a0,0
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret
  return 0;
 514:	4501                	li	a0,0
 516:	bfe5                	j	50e <strchr+0x1a>

0000000000000518 <gets>:

char*
gets(char *buf, int max)
{
 518:	711d                	addi	sp,sp,-96
 51a:	ec86                	sd	ra,88(sp)
 51c:	e8a2                	sd	s0,80(sp)
 51e:	e4a6                	sd	s1,72(sp)
 520:	e0ca                	sd	s2,64(sp)
 522:	fc4e                	sd	s3,56(sp)
 524:	f852                	sd	s4,48(sp)
 526:	f456                	sd	s5,40(sp)
 528:	f05a                	sd	s6,32(sp)
 52a:	ec5e                	sd	s7,24(sp)
 52c:	1080                	addi	s0,sp,96
 52e:	8baa                	mv	s7,a0
 530:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 532:	892a                	mv	s2,a0
 534:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 536:	4aa9                	li	s5,10
 538:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 53a:	89a6                	mv	s3,s1
 53c:	2485                	addiw	s1,s1,1
 53e:	0344d863          	bge	s1,s4,56e <gets+0x56>
    cc = read(0, &c, 1);
 542:	4605                	li	a2,1
 544:	faf40593          	addi	a1,s0,-81
 548:	4501                	li	a0,0
 54a:	00000097          	auipc	ra,0x0
 54e:	1a0080e7          	jalr	416(ra) # 6ea <read>
    if(cc < 1)
 552:	00a05e63          	blez	a0,56e <gets+0x56>
    buf[i++] = c;
 556:	faf44783          	lbu	a5,-81(s0)
 55a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 55e:	01578763          	beq	a5,s5,56c <gets+0x54>
 562:	0905                	addi	s2,s2,1
 564:	fd679be3          	bne	a5,s6,53a <gets+0x22>
  for(i=0; i+1 < max; ){
 568:	89a6                	mv	s3,s1
 56a:	a011                	j	56e <gets+0x56>
 56c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 56e:	99de                	add	s3,s3,s7
 570:	00098023          	sb	zero,0(s3)
  return buf;
}
 574:	855e                	mv	a0,s7
 576:	60e6                	ld	ra,88(sp)
 578:	6446                	ld	s0,80(sp)
 57a:	64a6                	ld	s1,72(sp)
 57c:	6906                	ld	s2,64(sp)
 57e:	79e2                	ld	s3,56(sp)
 580:	7a42                	ld	s4,48(sp)
 582:	7aa2                	ld	s5,40(sp)
 584:	7b02                	ld	s6,32(sp)
 586:	6be2                	ld	s7,24(sp)
 588:	6125                	addi	sp,sp,96
 58a:	8082                	ret

000000000000058c <stat>:

int
stat(const char *n, struct stat *st)
{
 58c:	1101                	addi	sp,sp,-32
 58e:	ec06                	sd	ra,24(sp)
 590:	e822                	sd	s0,16(sp)
 592:	e426                	sd	s1,8(sp)
 594:	e04a                	sd	s2,0(sp)
 596:	1000                	addi	s0,sp,32
 598:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 59a:	4581                	li	a1,0
 59c:	00000097          	auipc	ra,0x0
 5a0:	176080e7          	jalr	374(ra) # 712 <open>
  if(fd < 0)
 5a4:	02054563          	bltz	a0,5ce <stat+0x42>
 5a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5aa:	85ca                	mv	a1,s2
 5ac:	00000097          	auipc	ra,0x0
 5b0:	17e080e7          	jalr	382(ra) # 72a <fstat>
 5b4:	892a                	mv	s2,a0
  close(fd);
 5b6:	8526                	mv	a0,s1
 5b8:	00000097          	auipc	ra,0x0
 5bc:	142080e7          	jalr	322(ra) # 6fa <close>
  return r;
}
 5c0:	854a                	mv	a0,s2
 5c2:	60e2                	ld	ra,24(sp)
 5c4:	6442                	ld	s0,16(sp)
 5c6:	64a2                	ld	s1,8(sp)
 5c8:	6902                	ld	s2,0(sp)
 5ca:	6105                	addi	sp,sp,32
 5cc:	8082                	ret
    return -1;
 5ce:	597d                	li	s2,-1
 5d0:	bfc5                	j	5c0 <stat+0x34>

00000000000005d2 <atoi>:

int
atoi(const char *s)
{
 5d2:	1141                	addi	sp,sp,-16
 5d4:	e422                	sd	s0,8(sp)
 5d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5d8:	00054603          	lbu	a2,0(a0)
 5dc:	fd06079b          	addiw	a5,a2,-48
 5e0:	0ff7f793          	andi	a5,a5,255
 5e4:	4725                	li	a4,9
 5e6:	02f76963          	bltu	a4,a5,618 <atoi+0x46>
 5ea:	86aa                	mv	a3,a0
  n = 0;
 5ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 5ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 5f0:	0685                	addi	a3,a3,1
 5f2:	0025179b          	slliw	a5,a0,0x2
 5f6:	9fa9                	addw	a5,a5,a0
 5f8:	0017979b          	slliw	a5,a5,0x1
 5fc:	9fb1                	addw	a5,a5,a2
 5fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 602:	0006c603          	lbu	a2,0(a3)
 606:	fd06071b          	addiw	a4,a2,-48
 60a:	0ff77713          	andi	a4,a4,255
 60e:	fee5f1e3          	bgeu	a1,a4,5f0 <atoi+0x1e>
  return n;
}
 612:	6422                	ld	s0,8(sp)
 614:	0141                	addi	sp,sp,16
 616:	8082                	ret
  n = 0;
 618:	4501                	li	a0,0
 61a:	bfe5                	j	612 <atoi+0x40>

000000000000061c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 61c:	1141                	addi	sp,sp,-16
 61e:	e422                	sd	s0,8(sp)
 620:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 622:	02b57663          	bgeu	a0,a1,64e <memmove+0x32>
    while(n-- > 0)
 626:	02c05163          	blez	a2,648 <memmove+0x2c>
 62a:	fff6079b          	addiw	a5,a2,-1
 62e:	1782                	slli	a5,a5,0x20
 630:	9381                	srli	a5,a5,0x20
 632:	0785                	addi	a5,a5,1
 634:	97aa                	add	a5,a5,a0
  dst = vdst;
 636:	872a                	mv	a4,a0
      *dst++ = *src++;
 638:	0585                	addi	a1,a1,1
 63a:	0705                	addi	a4,a4,1
 63c:	fff5c683          	lbu	a3,-1(a1)
 640:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 644:	fee79ae3          	bne	a5,a4,638 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 648:	6422                	ld	s0,8(sp)
 64a:	0141                	addi	sp,sp,16
 64c:	8082                	ret
    dst += n;
 64e:	00c50733          	add	a4,a0,a2
    src += n;
 652:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 654:	fec05ae3          	blez	a2,648 <memmove+0x2c>
 658:	fff6079b          	addiw	a5,a2,-1
 65c:	1782                	slli	a5,a5,0x20
 65e:	9381                	srli	a5,a5,0x20
 660:	fff7c793          	not	a5,a5
 664:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 666:	15fd                	addi	a1,a1,-1
 668:	177d                	addi	a4,a4,-1
 66a:	0005c683          	lbu	a3,0(a1)
 66e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 672:	fee79ae3          	bne	a5,a4,666 <memmove+0x4a>
 676:	bfc9                	j	648 <memmove+0x2c>

0000000000000678 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 678:	1141                	addi	sp,sp,-16
 67a:	e422                	sd	s0,8(sp)
 67c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 67e:	ca05                	beqz	a2,6ae <memcmp+0x36>
 680:	fff6069b          	addiw	a3,a2,-1
 684:	1682                	slli	a3,a3,0x20
 686:	9281                	srli	a3,a3,0x20
 688:	0685                	addi	a3,a3,1
 68a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 68c:	00054783          	lbu	a5,0(a0)
 690:	0005c703          	lbu	a4,0(a1)
 694:	00e79863          	bne	a5,a4,6a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 698:	0505                	addi	a0,a0,1
    p2++;
 69a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 69c:	fed518e3          	bne	a0,a3,68c <memcmp+0x14>
  }
  return 0;
 6a0:	4501                	li	a0,0
 6a2:	a019                	j	6a8 <memcmp+0x30>
      return *p1 - *p2;
 6a4:	40e7853b          	subw	a0,a5,a4
}
 6a8:	6422                	ld	s0,8(sp)
 6aa:	0141                	addi	sp,sp,16
 6ac:	8082                	ret
  return 0;
 6ae:	4501                	li	a0,0
 6b0:	bfe5                	j	6a8 <memcmp+0x30>

00000000000006b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6b2:	1141                	addi	sp,sp,-16
 6b4:	e406                	sd	ra,8(sp)
 6b6:	e022                	sd	s0,0(sp)
 6b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6ba:	00000097          	auipc	ra,0x0
 6be:	f62080e7          	jalr	-158(ra) # 61c <memmove>
}
 6c2:	60a2                	ld	ra,8(sp)
 6c4:	6402                	ld	s0,0(sp)
 6c6:	0141                	addi	sp,sp,16
 6c8:	8082                	ret

00000000000006ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ca:	4885                	li	a7,1
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6d2:	4889                	li	a7,2
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <wait>:
.global wait
wait:
 li a7, SYS_wait
 6da:	488d                	li	a7,3
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6e2:	4891                	li	a7,4
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <read>:
.global read
read:
 li a7, SYS_read
 6ea:	4895                	li	a7,5
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <write>:
.global write
write:
 li a7, SYS_write
 6f2:	48c1                	li	a7,16
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <close>:
.global close
close:
 li a7, SYS_close
 6fa:	48d5                	li	a7,21
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <kill>:
.global kill
kill:
 li a7, SYS_kill
 702:	4899                	li	a7,6
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <exec>:
.global exec
exec:
 li a7, SYS_exec
 70a:	489d                	li	a7,7
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <open>:
.global open
open:
 li a7, SYS_open
 712:	48bd                	li	a7,15
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 71a:	48c5                	li	a7,17
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 722:	48c9                	li	a7,18
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 72a:	48a1                	li	a7,8
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <link>:
.global link
link:
 li a7, SYS_link
 732:	48cd                	li	a7,19
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 73a:	48d1                	li	a7,20
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 742:	48a5                	li	a7,9
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <dup>:
.global dup
dup:
 li a7, SYS_dup
 74a:	48a9                	li	a7,10
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 752:	48ad                	li	a7,11
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 75a:	48b1                	li	a7,12
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 762:	48b5                	li	a7,13
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 76a:	48b9                	li	a7,14
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 772:	1101                	addi	sp,sp,-32
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 77e:	4605                	li	a2,1
 780:	fef40593          	addi	a1,s0,-17
 784:	00000097          	auipc	ra,0x0
 788:	f6e080e7          	jalr	-146(ra) # 6f2 <write>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6105                	addi	sp,sp,32
 792:	8082                	ret

0000000000000794 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 794:	7139                	addi	sp,sp,-64
 796:	fc06                	sd	ra,56(sp)
 798:	f822                	sd	s0,48(sp)
 79a:	f426                	sd	s1,40(sp)
 79c:	f04a                	sd	s2,32(sp)
 79e:	ec4e                	sd	s3,24(sp)
 7a0:	0080                	addi	s0,sp,64
 7a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a4:	c299                	beqz	a3,7aa <printint+0x16>
 7a6:	0805c863          	bltz	a1,836 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7aa:	2581                	sext.w	a1,a1
  neg = 0;
 7ac:	4881                	li	a7,0
 7ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7b4:	2601                	sext.w	a2,a2
 7b6:	00000517          	auipc	a0,0x0
 7ba:	62250513          	addi	a0,a0,1570 # dd8 <digits>
 7be:	883a                	mv	a6,a4
 7c0:	2705                	addiw	a4,a4,1
 7c2:	02c5f7bb          	remuw	a5,a1,a2
 7c6:	1782                	slli	a5,a5,0x20
 7c8:	9381                	srli	a5,a5,0x20
 7ca:	97aa                	add	a5,a5,a0
 7cc:	0007c783          	lbu	a5,0(a5)
 7d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7d4:	0005879b          	sext.w	a5,a1
 7d8:	02c5d5bb          	divuw	a1,a1,a2
 7dc:	0685                	addi	a3,a3,1
 7de:	fec7f0e3          	bgeu	a5,a2,7be <printint+0x2a>
  if(neg)
 7e2:	00088b63          	beqz	a7,7f8 <printint+0x64>
    buf[i++] = '-';
 7e6:	fd040793          	addi	a5,s0,-48
 7ea:	973e                	add	a4,a4,a5
 7ec:	02d00793          	li	a5,45
 7f0:	fef70823          	sb	a5,-16(a4)
 7f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7f8:	02e05863          	blez	a4,828 <printint+0x94>
 7fc:	fc040793          	addi	a5,s0,-64
 800:	00e78933          	add	s2,a5,a4
 804:	fff78993          	addi	s3,a5,-1
 808:	99ba                	add	s3,s3,a4
 80a:	377d                	addiw	a4,a4,-1
 80c:	1702                	slli	a4,a4,0x20
 80e:	9301                	srli	a4,a4,0x20
 810:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 814:	fff94583          	lbu	a1,-1(s2)
 818:	8526                	mv	a0,s1
 81a:	00000097          	auipc	ra,0x0
 81e:	f58080e7          	jalr	-168(ra) # 772 <putc>
  while(--i >= 0)
 822:	197d                	addi	s2,s2,-1
 824:	ff3918e3          	bne	s2,s3,814 <printint+0x80>
}
 828:	70e2                	ld	ra,56(sp)
 82a:	7442                	ld	s0,48(sp)
 82c:	74a2                	ld	s1,40(sp)
 82e:	7902                	ld	s2,32(sp)
 830:	69e2                	ld	s3,24(sp)
 832:	6121                	addi	sp,sp,64
 834:	8082                	ret
    x = -xx;
 836:	40b005bb          	negw	a1,a1
    neg = 1;
 83a:	4885                	li	a7,1
    x = -xx;
 83c:	bf8d                	j	7ae <printint+0x1a>

000000000000083e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 83e:	7119                	addi	sp,sp,-128
 840:	fc86                	sd	ra,120(sp)
 842:	f8a2                	sd	s0,112(sp)
 844:	f4a6                	sd	s1,104(sp)
 846:	f0ca                	sd	s2,96(sp)
 848:	ecce                	sd	s3,88(sp)
 84a:	e8d2                	sd	s4,80(sp)
 84c:	e4d6                	sd	s5,72(sp)
 84e:	e0da                	sd	s6,64(sp)
 850:	fc5e                	sd	s7,56(sp)
 852:	f862                	sd	s8,48(sp)
 854:	f466                	sd	s9,40(sp)
 856:	f06a                	sd	s10,32(sp)
 858:	ec6e                	sd	s11,24(sp)
 85a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 85c:	0005c903          	lbu	s2,0(a1)
 860:	18090f63          	beqz	s2,9fe <vprintf+0x1c0>
 864:	8aaa                	mv	s5,a0
 866:	8b32                	mv	s6,a2
 868:	00158493          	addi	s1,a1,1
  state = 0;
 86c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 86e:	02500a13          	li	s4,37
      if(c == 'd'){
 872:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 876:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 87a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 87e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 882:	00000b97          	auipc	s7,0x0
 886:	556b8b93          	addi	s7,s7,1366 # dd8 <digits>
 88a:	a839                	j	8a8 <vprintf+0x6a>
        putc(fd, c);
 88c:	85ca                	mv	a1,s2
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	ee2080e7          	jalr	-286(ra) # 772 <putc>
 898:	a019                	j	89e <vprintf+0x60>
    } else if(state == '%'){
 89a:	01498f63          	beq	s3,s4,8b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 89e:	0485                	addi	s1,s1,1
 8a0:	fff4c903          	lbu	s2,-1(s1)
 8a4:	14090d63          	beqz	s2,9fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8ac:	fe0997e3          	bnez	s3,89a <vprintf+0x5c>
      if(c == '%'){
 8b0:	fd479ee3          	bne	a5,s4,88c <vprintf+0x4e>
        state = '%';
 8b4:	89be                	mv	s3,a5
 8b6:	b7e5                	j	89e <vprintf+0x60>
      if(c == 'd'){
 8b8:	05878063          	beq	a5,s8,8f8 <vprintf+0xba>
      } else if(c == 'l') {
 8bc:	05978c63          	beq	a5,s9,914 <vprintf+0xd6>
      } else if(c == 'x') {
 8c0:	07a78863          	beq	a5,s10,930 <vprintf+0xf2>
      } else if(c == 'p') {
 8c4:	09b78463          	beq	a5,s11,94c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8c8:	07300713          	li	a4,115
 8cc:	0ce78663          	beq	a5,a4,998 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8d0:	06300713          	li	a4,99
 8d4:	0ee78e63          	beq	a5,a4,9d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8d8:	11478863          	beq	a5,s4,9e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8dc:	85d2                	mv	a1,s4
 8de:	8556                	mv	a0,s5
 8e0:	00000097          	auipc	ra,0x0
 8e4:	e92080e7          	jalr	-366(ra) # 772 <putc>
        putc(fd, c);
 8e8:	85ca                	mv	a1,s2
 8ea:	8556                	mv	a0,s5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e86080e7          	jalr	-378(ra) # 772 <putc>
      }
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	b765                	j	89e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 8f8:	008b0913          	addi	s2,s6,8
 8fc:	4685                	li	a3,1
 8fe:	4629                	li	a2,10
 900:	000b2583          	lw	a1,0(s6)
 904:	8556                	mv	a0,s5
 906:	00000097          	auipc	ra,0x0
 90a:	e8e080e7          	jalr	-370(ra) # 794 <printint>
 90e:	8b4a                	mv	s6,s2
      state = 0;
 910:	4981                	li	s3,0
 912:	b771                	j	89e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 914:	008b0913          	addi	s2,s6,8
 918:	4681                	li	a3,0
 91a:	4629                	li	a2,10
 91c:	000b2583          	lw	a1,0(s6)
 920:	8556                	mv	a0,s5
 922:	00000097          	auipc	ra,0x0
 926:	e72080e7          	jalr	-398(ra) # 794 <printint>
 92a:	8b4a                	mv	s6,s2
      state = 0;
 92c:	4981                	li	s3,0
 92e:	bf85                	j	89e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 930:	008b0913          	addi	s2,s6,8
 934:	4681                	li	a3,0
 936:	4641                	li	a2,16
 938:	000b2583          	lw	a1,0(s6)
 93c:	8556                	mv	a0,s5
 93e:	00000097          	auipc	ra,0x0
 942:	e56080e7          	jalr	-426(ra) # 794 <printint>
 946:	8b4a                	mv	s6,s2
      state = 0;
 948:	4981                	li	s3,0
 94a:	bf91                	j	89e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 94c:	008b0793          	addi	a5,s6,8
 950:	f8f43423          	sd	a5,-120(s0)
 954:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 958:	03000593          	li	a1,48
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	e14080e7          	jalr	-492(ra) # 772 <putc>
  putc(fd, 'x');
 966:	85ea                	mv	a1,s10
 968:	8556                	mv	a0,s5
 96a:	00000097          	auipc	ra,0x0
 96e:	e08080e7          	jalr	-504(ra) # 772 <putc>
 972:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 974:	03c9d793          	srli	a5,s3,0x3c
 978:	97de                	add	a5,a5,s7
 97a:	0007c583          	lbu	a1,0(a5)
 97e:	8556                	mv	a0,s5
 980:	00000097          	auipc	ra,0x0
 984:	df2080e7          	jalr	-526(ra) # 772 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 988:	0992                	slli	s3,s3,0x4
 98a:	397d                	addiw	s2,s2,-1
 98c:	fe0914e3          	bnez	s2,974 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 990:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 994:	4981                	li	s3,0
 996:	b721                	j	89e <vprintf+0x60>
        s = va_arg(ap, char*);
 998:	008b0993          	addi	s3,s6,8
 99c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9a0:	02090163          	beqz	s2,9c2 <vprintf+0x184>
        while(*s != 0){
 9a4:	00094583          	lbu	a1,0(s2)
 9a8:	c9a1                	beqz	a1,9f8 <vprintf+0x1ba>
          putc(fd, *s);
 9aa:	8556                	mv	a0,s5
 9ac:	00000097          	auipc	ra,0x0
 9b0:	dc6080e7          	jalr	-570(ra) # 772 <putc>
          s++;
 9b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 9b6:	00094583          	lbu	a1,0(s2)
 9ba:	f9e5                	bnez	a1,9aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 9bc:	8b4e                	mv	s6,s3
      state = 0;
 9be:	4981                	li	s3,0
 9c0:	bdf9                	j	89e <vprintf+0x60>
          s = "(null)";
 9c2:	00000917          	auipc	s2,0x0
 9c6:	40e90913          	addi	s2,s2,1038 # dd0 <statistics+0x1e4>
        while(*s != 0){
 9ca:	02800593          	li	a1,40
 9ce:	bff1                	j	9aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9d0:	008b0913          	addi	s2,s6,8
 9d4:	000b4583          	lbu	a1,0(s6)
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	d98080e7          	jalr	-616(ra) # 772 <putc>
 9e2:	8b4a                	mv	s6,s2
      state = 0;
 9e4:	4981                	li	s3,0
 9e6:	bd65                	j	89e <vprintf+0x60>
        putc(fd, c);
 9e8:	85d2                	mv	a1,s4
 9ea:	8556                	mv	a0,s5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	d86080e7          	jalr	-634(ra) # 772 <putc>
      state = 0;
 9f4:	4981                	li	s3,0
 9f6:	b565                	j	89e <vprintf+0x60>
        s = va_arg(ap, char*);
 9f8:	8b4e                	mv	s6,s3
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	b54d                	j	89e <vprintf+0x60>
    }
  }
}
 9fe:	70e6                	ld	ra,120(sp)
 a00:	7446                	ld	s0,112(sp)
 a02:	74a6                	ld	s1,104(sp)
 a04:	7906                	ld	s2,96(sp)
 a06:	69e6                	ld	s3,88(sp)
 a08:	6a46                	ld	s4,80(sp)
 a0a:	6aa6                	ld	s5,72(sp)
 a0c:	6b06                	ld	s6,64(sp)
 a0e:	7be2                	ld	s7,56(sp)
 a10:	7c42                	ld	s8,48(sp)
 a12:	7ca2                	ld	s9,40(sp)
 a14:	7d02                	ld	s10,32(sp)
 a16:	6de2                	ld	s11,24(sp)
 a18:	6109                	addi	sp,sp,128
 a1a:	8082                	ret

0000000000000a1c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1c:	715d                	addi	sp,sp,-80
 a1e:	ec06                	sd	ra,24(sp)
 a20:	e822                	sd	s0,16(sp)
 a22:	1000                	addi	s0,sp,32
 a24:	e010                	sd	a2,0(s0)
 a26:	e414                	sd	a3,8(s0)
 a28:	e818                	sd	a4,16(s0)
 a2a:	ec1c                	sd	a5,24(s0)
 a2c:	03043023          	sd	a6,32(s0)
 a30:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a34:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a38:	8622                	mv	a2,s0
 a3a:	00000097          	auipc	ra,0x0
 a3e:	e04080e7          	jalr	-508(ra) # 83e <vprintf>
}
 a42:	60e2                	ld	ra,24(sp)
 a44:	6442                	ld	s0,16(sp)
 a46:	6161                	addi	sp,sp,80
 a48:	8082                	ret

0000000000000a4a <printf>:

void
printf(const char *fmt, ...)
{
 a4a:	711d                	addi	sp,sp,-96
 a4c:	ec06                	sd	ra,24(sp)
 a4e:	e822                	sd	s0,16(sp)
 a50:	1000                	addi	s0,sp,32
 a52:	e40c                	sd	a1,8(s0)
 a54:	e810                	sd	a2,16(s0)
 a56:	ec14                	sd	a3,24(s0)
 a58:	f018                	sd	a4,32(s0)
 a5a:	f41c                	sd	a5,40(s0)
 a5c:	03043823          	sd	a6,48(s0)
 a60:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a64:	00840613          	addi	a2,s0,8
 a68:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a6c:	85aa                	mv	a1,a0
 a6e:	4505                	li	a0,1
 a70:	00000097          	auipc	ra,0x0
 a74:	dce080e7          	jalr	-562(ra) # 83e <vprintf>
}
 a78:	60e2                	ld	ra,24(sp)
 a7a:	6442                	ld	s0,16(sp)
 a7c:	6125                	addi	sp,sp,96
 a7e:	8082                	ret

0000000000000a80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a80:	1141                	addi	sp,sp,-16
 a82:	e422                	sd	s0,8(sp)
 a84:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a86:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8a:	00000797          	auipc	a5,0x0
 a8e:	5767b783          	ld	a5,1398(a5) # 1000 <freep>
 a92:	a805                	j	ac2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a94:	4618                	lw	a4,8(a2)
 a96:	9db9                	addw	a1,a1,a4
 a98:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9c:	6398                	ld	a4,0(a5)
 a9e:	6318                	ld	a4,0(a4)
 aa0:	fee53823          	sd	a4,-16(a0)
 aa4:	a091                	j	ae8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa6:	ff852703          	lw	a4,-8(a0)
 aaa:	9e39                	addw	a2,a2,a4
 aac:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 aae:	ff053703          	ld	a4,-16(a0)
 ab2:	e398                	sd	a4,0(a5)
 ab4:	a099                	j	afa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab6:	6398                	ld	a4,0(a5)
 ab8:	00e7e463          	bltu	a5,a4,ac0 <free+0x40>
 abc:	00e6ea63          	bltu	a3,a4,ad0 <free+0x50>
{
 ac0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac2:	fed7fae3          	bgeu	a5,a3,ab6 <free+0x36>
 ac6:	6398                	ld	a4,0(a5)
 ac8:	00e6e463          	bltu	a3,a4,ad0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 acc:	fee7eae3          	bltu	a5,a4,ac0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ad0:	ff852583          	lw	a1,-8(a0)
 ad4:	6390                	ld	a2,0(a5)
 ad6:	02059713          	slli	a4,a1,0x20
 ada:	9301                	srli	a4,a4,0x20
 adc:	0712                	slli	a4,a4,0x4
 ade:	9736                	add	a4,a4,a3
 ae0:	fae60ae3          	beq	a2,a4,a94 <free+0x14>
    bp->s.ptr = p->s.ptr;
 ae4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae8:	4790                	lw	a2,8(a5)
 aea:	02061713          	slli	a4,a2,0x20
 aee:	9301                	srli	a4,a4,0x20
 af0:	0712                	slli	a4,a4,0x4
 af2:	973e                	add	a4,a4,a5
 af4:	fae689e3          	beq	a3,a4,aa6 <free+0x26>
  } else
    p->s.ptr = bp;
 af8:	e394                	sd	a3,0(a5)
  freep = p;
 afa:	00000717          	auipc	a4,0x0
 afe:	50f73323          	sd	a5,1286(a4) # 1000 <freep>
}
 b02:	6422                	ld	s0,8(sp)
 b04:	0141                	addi	sp,sp,16
 b06:	8082                	ret

0000000000000b08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b08:	7139                	addi	sp,sp,-64
 b0a:	fc06                	sd	ra,56(sp)
 b0c:	f822                	sd	s0,48(sp)
 b0e:	f426                	sd	s1,40(sp)
 b10:	f04a                	sd	s2,32(sp)
 b12:	ec4e                	sd	s3,24(sp)
 b14:	e852                	sd	s4,16(sp)
 b16:	e456                	sd	s5,8(sp)
 b18:	e05a                	sd	s6,0(sp)
 b1a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b1c:	02051493          	slli	s1,a0,0x20
 b20:	9081                	srli	s1,s1,0x20
 b22:	04bd                	addi	s1,s1,15
 b24:	8091                	srli	s1,s1,0x4
 b26:	0014899b          	addiw	s3,s1,1
 b2a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b2c:	00000517          	auipc	a0,0x0
 b30:	4d453503          	ld	a0,1236(a0) # 1000 <freep>
 b34:	c515                	beqz	a0,b60 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	02977f63          	bgeu	a4,s1,b78 <malloc+0x70>
 b3e:	8a4e                	mv	s4,s3
 b40:	0009871b          	sext.w	a4,s3
 b44:	6685                	lui	a3,0x1
 b46:	00d77363          	bgeu	a4,a3,b4c <malloc+0x44>
 b4a:	6a05                	lui	s4,0x1
 b4c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b50:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b54:	00000917          	auipc	s2,0x0
 b58:	4ac90913          	addi	s2,s2,1196 # 1000 <freep>
  if(p == (char*)-1)
 b5c:	5afd                	li	s5,-1
 b5e:	a88d                	j	bd0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b60:	00001797          	auipc	a5,0x1
 b64:	4b078793          	addi	a5,a5,1200 # 2010 <base>
 b68:	00000717          	auipc	a4,0x0
 b6c:	48f73c23          	sd	a5,1176(a4) # 1000 <freep>
 b70:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b72:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b76:	b7e1                	j	b3e <malloc+0x36>
      if(p->s.size == nunits)
 b78:	02e48b63          	beq	s1,a4,bae <malloc+0xa6>
        p->s.size -= nunits;
 b7c:	4137073b          	subw	a4,a4,s3
 b80:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b82:	1702                	slli	a4,a4,0x20
 b84:	9301                	srli	a4,a4,0x20
 b86:	0712                	slli	a4,a4,0x4
 b88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b8a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b8e:	00000717          	auipc	a4,0x0
 b92:	46a73923          	sd	a0,1138(a4) # 1000 <freep>
      return (void*)(p + 1);
 b96:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b9a:	70e2                	ld	ra,56(sp)
 b9c:	7442                	ld	s0,48(sp)
 b9e:	74a2                	ld	s1,40(sp)
 ba0:	7902                	ld	s2,32(sp)
 ba2:	69e2                	ld	s3,24(sp)
 ba4:	6a42                	ld	s4,16(sp)
 ba6:	6aa2                	ld	s5,8(sp)
 ba8:	6b02                	ld	s6,0(sp)
 baa:	6121                	addi	sp,sp,64
 bac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bae:	6398                	ld	a4,0(a5)
 bb0:	e118                	sd	a4,0(a0)
 bb2:	bff1                	j	b8e <malloc+0x86>
  hp->s.size = nu;
 bb4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bb8:	0541                	addi	a0,a0,16
 bba:	00000097          	auipc	ra,0x0
 bbe:	ec6080e7          	jalr	-314(ra) # a80 <free>
  return freep;
 bc2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bc6:	d971                	beqz	a0,b9a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bca:	4798                	lw	a4,8(a5)
 bcc:	fa9776e3          	bgeu	a4,s1,b78 <malloc+0x70>
    if(p == freep)
 bd0:	00093703          	ld	a4,0(s2)
 bd4:	853e                	mv	a0,a5
 bd6:	fef719e3          	bne	a4,a5,bc8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 bda:	8552                	mv	a0,s4
 bdc:	00000097          	auipc	ra,0x0
 be0:	b7e080e7          	jalr	-1154(ra) # 75a <sbrk>
  if(p == (char*)-1)
 be4:	fd5518e3          	bne	a0,s5,bb4 <malloc+0xac>
        return 0;
 be8:	4501                	li	a0,0
 bea:	bf45                	j	b9a <malloc+0x92>

0000000000000bec <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 bec:	7179                	addi	sp,sp,-48
 bee:	f406                	sd	ra,40(sp)
 bf0:	f022                	sd	s0,32(sp)
 bf2:	ec26                	sd	s1,24(sp)
 bf4:	e84a                	sd	s2,16(sp)
 bf6:	e44e                	sd	s3,8(sp)
 bf8:	e052                	sd	s4,0(sp)
 bfa:	1800                	addi	s0,sp,48
 bfc:	8a2a                	mv	s4,a0
 bfe:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 c00:	4581                	li	a1,0
 c02:	00000517          	auipc	a0,0x0
 c06:	1ee50513          	addi	a0,a0,494 # df0 <digits+0x18>
 c0a:	00000097          	auipc	ra,0x0
 c0e:	b08080e7          	jalr	-1272(ra) # 712 <open>
  if(fd < 0) {
 c12:	04054263          	bltz	a0,c56 <statistics+0x6a>
 c16:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 c18:	4481                	li	s1,0
 c1a:	03205063          	blez	s2,c3a <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 c1e:	4099063b          	subw	a2,s2,s1
 c22:	009a05b3          	add	a1,s4,s1
 c26:	854e                	mv	a0,s3
 c28:	00000097          	auipc	ra,0x0
 c2c:	ac2080e7          	jalr	-1342(ra) # 6ea <read>
 c30:	00054563          	bltz	a0,c3a <statistics+0x4e>
      break;
    }
    i += n;
 c34:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 c36:	ff24c4e3          	blt	s1,s2,c1e <statistics+0x32>
  }
  close(fd);
 c3a:	854e                	mv	a0,s3
 c3c:	00000097          	auipc	ra,0x0
 c40:	abe080e7          	jalr	-1346(ra) # 6fa <close>
  return i;
}
 c44:	8526                	mv	a0,s1
 c46:	70a2                	ld	ra,40(sp)
 c48:	7402                	ld	s0,32(sp)
 c4a:	64e2                	ld	s1,24(sp)
 c4c:	6942                	ld	s2,16(sp)
 c4e:	69a2                	ld	s3,8(sp)
 c50:	6a02                	ld	s4,0(sp)
 c52:	6145                	addi	sp,sp,48
 c54:	8082                	ret
      fprintf(2, "stats: open failed\n");
 c56:	00000597          	auipc	a1,0x0
 c5a:	1aa58593          	addi	a1,a1,426 # e00 <digits+0x28>
 c5e:	4509                	li	a0,2
 c60:	00000097          	auipc	ra,0x0
 c64:	dbc080e7          	jalr	-580(ra) # a1c <fprintf>
      exit(1);
 c68:	4505                	li	a0,1
 c6a:	00000097          	auipc	ra,0x0
 c6e:	a68080e7          	jalr	-1432(ra) # 6d2 <exit>
