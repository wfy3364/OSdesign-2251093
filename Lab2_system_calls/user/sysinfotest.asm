
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	6e6080e7          	jalr	1766(ra) # 6ee <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	b6450513          	addi	a0,a0,-1180 # b80 <malloc+0xf4>
  24:	00001097          	auipc	ra,0x1
  28:	9aa080e7          	jalr	-1622(ra) # 9ce <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	620080e7          	jalr	1568(ra) # 64e <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	addi	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	68e080e7          	jalr	1678(ra) # 6d6 <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  58:	6505                	lui	a0,0x1
  5a:	00000097          	auipc	ra,0x0
  5e:	67c080e7          	jalr	1660(ra) # 6d6 <sbrk>
  62:	01250563          	beq	a0,s2,6c <countfree+0x36>
    n += PGSIZE;
  66:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  6a:	b7fd                	j	58 <countfree+0x22>
  }
  sinfo(&info);
  6c:	fc040513          	addi	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	656080e7          	jalr	1622(ra) # 6d6 <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	64a080e7          	jalr	1610(ra) # 6d6 <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	addi	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	af250513          	addi	a0,a0,-1294 # b98 <malloc+0x10c>
  ae:	00001097          	auipc	ra,0x1
  b2:	920080e7          	jalr	-1760(ra) # 9ce <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	596080e7          	jalr	1430(ra) # 64e <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	addi	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	addi	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	5ea080e7          	jalr	1514(ra) # 6d6 <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	addi	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	5c2080e7          	jalr	1474(ra) # 6d6 <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	addi	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	addi	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	a8c50513          	addi	a0,a0,-1396 # bd0 <malloc+0x144>
 14c:	00001097          	auipc	ra,0x1
 150:	882080e7          	jalr	-1918(ra) # 9ce <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	4f8080e7          	jalr	1272(ra) # 64e <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	aa250513          	addi	a0,a0,-1374 # c00 <malloc+0x174>
 166:	00001097          	auipc	ra,0x1
 16a:	868080e7          	jalr	-1944(ra) # 9ce <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	4de080e7          	jalr	1246(ra) # 64e <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	a5850513          	addi	a0,a0,-1448 # bd0 <malloc+0x144>
 180:	00001097          	auipc	ra,0x1
 184:	84e080e7          	jalr	-1970(ra) # 9ce <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	4c4080e7          	jalr	1220(ra) # 64e <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	a6e50513          	addi	a0,a0,-1426 # c00 <malloc+0x174>
 19a:	00001097          	auipc	ra,0x1
 19e:	834080e7          	jalr	-1996(ra) # 9ce <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	4aa080e7          	jalr	1194(ra) # 64e <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	a2250513          	addi	a0,a0,-1502 # bd0 <malloc+0x144>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	818080e7          	jalr	-2024(ra) # 9ce <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	48e080e7          	jalr	1166(ra) # 64e <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	addi	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	51a080e7          	jalr	1306(ra) # 6ee <sysinfo>
 1dc:	02054163          	bltz	a0,1fe <testcall+0x36>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001517          	auipc	a0,0x1
 1e4:	99053503          	ld	a0,-1648(a0) # b70 <malloc+0xe4>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	506080e7          	jalr	1286(ra) # 6ee <sysinfo>
 1f0:	57fd                	li	a5,-1
 1f2:	02f51363          	bne	a0,a5,218 <testcall+0x50>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	a1250513          	addi	a0,a0,-1518 # c10 <malloc+0x184>
 206:	00000097          	auipc	ra,0x0
 20a:	7c8080e7          	jalr	1992(ra) # 9ce <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	43e080e7          	jalr	1086(ra) # 64e <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 218:	00001517          	auipc	a0,0x1
 21c:	a1050513          	addi	a0,a0,-1520 # c28 <malloc+0x19c>
 220:	00000097          	auipc	ra,0x0
 224:	7ae080e7          	jalr	1966(ra) # 9ce <printf>
    exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	424080e7          	jalr	1060(ra) # 64e <exit>

0000000000000232 <testproc>:

void testproc() {
 232:	7139                	addi	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23c:	fd040513          	addi	a0,s0,-48
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <sinfo>
  nproc = info.nproc;
 248:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24c:	00000097          	auipc	ra,0x0
 250:	3fa080e7          	jalr	1018(ra) # 646 <fork>
  if(pid < 0){
 254:	02054c63          	bltz	a0,28c <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 258:	ed21                	bnez	a0,2b0 <testproc+0x7e>
    sinfo(&info);
 25a:	fd040513          	addi	a0,s0,-48
 25e:	00000097          	auipc	ra,0x0
 262:	da2080e7          	jalr	-606(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 266:	fd843583          	ld	a1,-40(s0)
 26a:	00148613          	addi	a2,s1,1
 26e:	02c58c63          	beq	a1,a2,2a6 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 272:	00001517          	auipc	a0,0x1
 276:	a0650513          	addi	a0,a0,-1530 # c78 <malloc+0x1ec>
 27a:	00000097          	auipc	ra,0x0
 27e:	754080e7          	jalr	1876(ra) # 9ce <printf>
      exit(1);
 282:	4505                	li	a0,1
 284:	00000097          	auipc	ra,0x0
 288:	3ca080e7          	jalr	970(ra) # 64e <exit>
    printf("sysinfotest: fork failed\n");
 28c:	00001517          	auipc	a0,0x1
 290:	9cc50513          	addi	a0,a0,-1588 # c58 <malloc+0x1cc>
 294:	00000097          	auipc	ra,0x0
 298:	73a080e7          	jalr	1850(ra) # 9ce <printf>
    exit(1);
 29c:	4505                	li	a0,1
 29e:	00000097          	auipc	ra,0x0
 2a2:	3b0080e7          	jalr	944(ra) # 64e <exit>
    }
    exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	3a6080e7          	jalr	934(ra) # 64e <exit>
  }
  wait(&status);
 2b0:	fcc40513          	addi	a0,s0,-52
 2b4:	00000097          	auipc	ra,0x0
 2b8:	3a2080e7          	jalr	930(ra) # 656 <wait>
  sinfo(&info);
 2bc:	fd040513          	addi	a0,s0,-48
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2c8:	fd843583          	ld	a1,-40(s0)
 2cc:	00959763          	bne	a1,s1,2da <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d0:	70e2                	ld	ra,56(sp)
 2d2:	7442                	ld	s0,48(sp)
 2d4:	74a2                	ld	s1,40(sp)
 2d6:	6121                	addi	sp,sp,64
 2d8:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2da:	8626                	mv	a2,s1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	99c50513          	addi	a0,a0,-1636 # c78 <malloc+0x1ec>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	6ea080e7          	jalr	1770(ra) # 9ce <printf>
      exit(1);
 2ec:	4505                	li	a0,1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	360080e7          	jalr	864(ra) # 64e <exit>

00000000000002f6 <testbad>:

void testbad() {
 2f6:	1101                	addi	sp,sp,-32
 2f8:	ec06                	sd	ra,24(sp)
 2fa:	e822                	sd	s0,16(sp)
 2fc:	1000                	addi	s0,sp,32
  int pid = fork();
 2fe:	00000097          	auipc	ra,0x0
 302:	348080e7          	jalr	840(ra) # 646 <fork>
  int xstatus;
  
  if(pid < 0){
 306:	00054c63          	bltz	a0,31e <testbad+0x28>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 30a:	e51d                	bnez	a0,338 <testbad+0x42>
      sinfo(0x0);
 30c:	00000097          	auipc	ra,0x0
 310:	cf4080e7          	jalr	-780(ra) # 0 <sinfo>
      exit(0);
 314:	4501                	li	a0,0
 316:	00000097          	auipc	ra,0x0
 31a:	338080e7          	jalr	824(ra) # 64e <exit>
    printf("sysinfotest: fork failed\n");
 31e:	00001517          	auipc	a0,0x1
 322:	93a50513          	addi	a0,a0,-1734 # c58 <malloc+0x1cc>
 326:	00000097          	auipc	ra,0x0
 32a:	6a8080e7          	jalr	1704(ra) # 9ce <printf>
    exit(1);
 32e:	4505                	li	a0,1
 330:	00000097          	auipc	ra,0x0
 334:	31e080e7          	jalr	798(ra) # 64e <exit>
  }
  wait(&xstatus);
 338:	fec40513          	addi	a0,s0,-20
 33c:	00000097          	auipc	ra,0x0
 340:	31a080e7          	jalr	794(ra) # 656 <wait>
  if(xstatus == -1)  // kernel killed child?
 344:	fec42583          	lw	a1,-20(s0)
 348:	57fd                	li	a5,-1
 34a:	02f58063          	beq	a1,a5,36a <testbad+0x74>
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
 34e:	00001517          	auipc	a0,0x1
 352:	95a50513          	addi	a0,a0,-1702 # ca8 <malloc+0x21c>
 356:	00000097          	auipc	ra,0x0
 35a:	678080e7          	jalr	1656(ra) # 9ce <printf>
    exit(xstatus);
 35e:	fec42503          	lw	a0,-20(s0)
 362:	00000097          	auipc	ra,0x0
 366:	2ec080e7          	jalr	748(ra) # 64e <exit>
    exit(0);
 36a:	4501                	li	a0,0
 36c:	00000097          	auipc	ra,0x0
 370:	2e2080e7          	jalr	738(ra) # 64e <exit>

0000000000000374 <main>:
  }
}

int
main(int argc, char *argv[])
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 37c:	00001517          	auipc	a0,0x1
 380:	95450513          	addi	a0,a0,-1708 # cd0 <malloc+0x244>
 384:	00000097          	auipc	ra,0x0
 388:	64a080e7          	jalr	1610(ra) # 9ce <printf>
  testcall();
 38c:	00000097          	auipc	ra,0x0
 390:	e3c080e7          	jalr	-452(ra) # 1c8 <testcall>
  testmem();
 394:	00000097          	auipc	ra,0x0
 398:	d2c080e7          	jalr	-724(ra) # c0 <testmem>
  testproc();
 39c:	00000097          	auipc	ra,0x0
 3a0:	e96080e7          	jalr	-362(ra) # 232 <testproc>
  printf("sysinfotest: OK\n");
 3a4:	00001517          	auipc	a0,0x1
 3a8:	94450513          	addi	a0,a0,-1724 # ce8 <malloc+0x25c>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	622080e7          	jalr	1570(ra) # 9ce <printf>
  exit(0);
 3b4:	4501                	li	a0,0
 3b6:	00000097          	auipc	ra,0x0
 3ba:	298080e7          	jalr	664(ra) # 64e <exit>

00000000000003be <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e406                	sd	ra,8(sp)
 3c2:	e022                	sd	s0,0(sp)
 3c4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c6:	00000097          	auipc	ra,0x0
 3ca:	fae080e7          	jalr	-82(ra) # 374 <main>
  exit(0);
 3ce:	4501                	li	a0,0
 3d0:	00000097          	auipc	ra,0x0
 3d4:	27e080e7          	jalr	638(ra) # 64e <exit>

00000000000003d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3de:	87aa                	mv	a5,a0
 3e0:	0585                	addi	a1,a1,1
 3e2:	0785                	addi	a5,a5,1
 3e4:	fff5c703          	lbu	a4,-1(a1) # ffffffffffffefff <base+0xffffffffffffdfef>
 3e8:	fee78fa3          	sb	a4,-1(a5)
 3ec:	fb75                	bnez	a4,3e0 <strcpy+0x8>
    ;
  return os;
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cb91                	beqz	a5,412 <strcmp+0x1e>
 400:	0005c703          	lbu	a4,0(a1)
 404:	00f71763          	bne	a4,a5,412 <strcmp+0x1e>
    p++, q++;
 408:	0505                	addi	a0,a0,1
 40a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 40c:	00054783          	lbu	a5,0(a0)
 410:	fbe5                	bnez	a5,400 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 412:	0005c503          	lbu	a0,0(a1)
}
 416:	40a7853b          	subw	a0,a5,a0
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <strlen>:

uint
strlen(const char *s)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 426:	00054783          	lbu	a5,0(a0)
 42a:	cf91                	beqz	a5,446 <strlen+0x26>
 42c:	0505                	addi	a0,a0,1
 42e:	87aa                	mv	a5,a0
 430:	4685                	li	a3,1
 432:	9e89                	subw	a3,a3,a0
 434:	00f6853b          	addw	a0,a3,a5
 438:	0785                	addi	a5,a5,1
 43a:	fff7c703          	lbu	a4,-1(a5)
 43e:	fb7d                	bnez	a4,434 <strlen+0x14>
    ;
  return n;
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  for(n = 0; s[n]; n++)
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <strlen+0x20>

000000000000044a <memset>:

void*
memset(void *dst, int c, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 450:	ce09                	beqz	a2,46a <memset+0x20>
 452:	87aa                	mv	a5,a0
 454:	fff6071b          	addiw	a4,a2,-1
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	0705                	addi	a4,a4,1
 45e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 460:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 464:	0785                	addi	a5,a5,1
 466:	fee79de3          	bne	a5,a4,460 <memset+0x16>
  }
  return dst;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret

0000000000000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  for(; *s; s++)
 476:	00054783          	lbu	a5,0(a0)
 47a:	cb99                	beqz	a5,490 <strchr+0x20>
    if(*s == c)
 47c:	00f58763          	beq	a1,a5,48a <strchr+0x1a>
  for(; *s; s++)
 480:	0505                	addi	a0,a0,1
 482:	00054783          	lbu	a5,0(a0)
 486:	fbfd                	bnez	a5,47c <strchr+0xc>
      return (char*)s;
  return 0;
 488:	4501                	li	a0,0
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  return 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <strchr+0x1a>

0000000000000494 <gets>:

char*
gets(char *buf, int max)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e4a6                	sd	s1,72(sp)
 49c:	e0ca                	sd	s2,64(sp)
 49e:	fc4e                	sd	s3,56(sp)
 4a0:	f852                	sd	s4,48(sp)
 4a2:	f456                	sd	s5,40(sp)
 4a4:	f05a                	sd	s6,32(sp)
 4a6:	ec5e                	sd	s7,24(sp)
 4a8:	1080                	addi	s0,sp,96
 4aa:	8baa                	mv	s7,a0
 4ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ae:	892a                	mv	s2,a0
 4b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4b2:	4aa9                	li	s5,10
 4b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4b6:	89a6                	mv	s3,s1
 4b8:	2485                	addiw	s1,s1,1
 4ba:	0344d863          	bge	s1,s4,4ea <gets+0x56>
    cc = read(0, &c, 1);
 4be:	4605                	li	a2,1
 4c0:	faf40593          	addi	a1,s0,-81
 4c4:	4501                	li	a0,0
 4c6:	00000097          	auipc	ra,0x0
 4ca:	1a0080e7          	jalr	416(ra) # 666 <read>
    if(cc < 1)
 4ce:	00a05e63          	blez	a0,4ea <gets+0x56>
    buf[i++] = c;
 4d2:	faf44783          	lbu	a5,-81(s0)
 4d6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4da:	01578763          	beq	a5,s5,4e8 <gets+0x54>
 4de:	0905                	addi	s2,s2,1
 4e0:	fd679be3          	bne	a5,s6,4b6 <gets+0x22>
  for(i=0; i+1 < max; ){
 4e4:	89a6                	mv	s3,s1
 4e6:	a011                	j	4ea <gets+0x56>
 4e8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ea:	99de                	add	s3,s3,s7
 4ec:	00098023          	sb	zero,0(s3) # 1000 <freep>
  return buf;
}
 4f0:	855e                	mv	a0,s7
 4f2:	60e6                	ld	ra,88(sp)
 4f4:	6446                	ld	s0,80(sp)
 4f6:	64a6                	ld	s1,72(sp)
 4f8:	6906                	ld	s2,64(sp)
 4fa:	79e2                	ld	s3,56(sp)
 4fc:	7a42                	ld	s4,48(sp)
 4fe:	7aa2                	ld	s5,40(sp)
 500:	7b02                	ld	s6,32(sp)
 502:	6be2                	ld	s7,24(sp)
 504:	6125                	addi	sp,sp,96
 506:	8082                	ret

0000000000000508 <stat>:

int
stat(const char *n, struct stat *st)
{
 508:	1101                	addi	sp,sp,-32
 50a:	ec06                	sd	ra,24(sp)
 50c:	e822                	sd	s0,16(sp)
 50e:	e426                	sd	s1,8(sp)
 510:	e04a                	sd	s2,0(sp)
 512:	1000                	addi	s0,sp,32
 514:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 516:	4581                	li	a1,0
 518:	00000097          	auipc	ra,0x0
 51c:	176080e7          	jalr	374(ra) # 68e <open>
  if(fd < 0)
 520:	02054563          	bltz	a0,54a <stat+0x42>
 524:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 526:	85ca                	mv	a1,s2
 528:	00000097          	auipc	ra,0x0
 52c:	17e080e7          	jalr	382(ra) # 6a6 <fstat>
 530:	892a                	mv	s2,a0
  close(fd);
 532:	8526                	mv	a0,s1
 534:	00000097          	auipc	ra,0x0
 538:	142080e7          	jalr	322(ra) # 676 <close>
  return r;
}
 53c:	854a                	mv	a0,s2
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	64a2                	ld	s1,8(sp)
 544:	6902                	ld	s2,0(sp)
 546:	6105                	addi	sp,sp,32
 548:	8082                	ret
    return -1;
 54a:	597d                	li	s2,-1
 54c:	bfc5                	j	53c <stat+0x34>

000000000000054e <atoi>:

int
atoi(const char *s)
{
 54e:	1141                	addi	sp,sp,-16
 550:	e422                	sd	s0,8(sp)
 552:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 554:	00054603          	lbu	a2,0(a0)
 558:	fd06079b          	addiw	a5,a2,-48
 55c:	0ff7f793          	andi	a5,a5,255
 560:	4725                	li	a4,9
 562:	02f76963          	bltu	a4,a5,594 <atoi+0x46>
 566:	86aa                	mv	a3,a0
  n = 0;
 568:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 56a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 56c:	0685                	addi	a3,a3,1
 56e:	0025179b          	slliw	a5,a0,0x2
 572:	9fa9                	addw	a5,a5,a0
 574:	0017979b          	slliw	a5,a5,0x1
 578:	9fb1                	addw	a5,a5,a2
 57a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 57e:	0006c603          	lbu	a2,0(a3)
 582:	fd06071b          	addiw	a4,a2,-48
 586:	0ff77713          	andi	a4,a4,255
 58a:	fee5f1e3          	bgeu	a1,a4,56c <atoi+0x1e>
  return n;
}
 58e:	6422                	ld	s0,8(sp)
 590:	0141                	addi	sp,sp,16
 592:	8082                	ret
  n = 0;
 594:	4501                	li	a0,0
 596:	bfe5                	j	58e <atoi+0x40>

0000000000000598 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 598:	1141                	addi	sp,sp,-16
 59a:	e422                	sd	s0,8(sp)
 59c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 59e:	02b57663          	bgeu	a0,a1,5ca <memmove+0x32>
    while(n-- > 0)
 5a2:	02c05163          	blez	a2,5c4 <memmove+0x2c>
 5a6:	fff6079b          	addiw	a5,a2,-1
 5aa:	1782                	slli	a5,a5,0x20
 5ac:	9381                	srli	a5,a5,0x20
 5ae:	0785                	addi	a5,a5,1
 5b0:	97aa                	add	a5,a5,a0
  dst = vdst;
 5b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5b4:	0585                	addi	a1,a1,1
 5b6:	0705                	addi	a4,a4,1
 5b8:	fff5c683          	lbu	a3,-1(a1)
 5bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5c0:	fee79ae3          	bne	a5,a4,5b4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5c4:	6422                	ld	s0,8(sp)
 5c6:	0141                	addi	sp,sp,16
 5c8:	8082                	ret
    dst += n;
 5ca:	00c50733          	add	a4,a0,a2
    src += n;
 5ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5d0:	fec05ae3          	blez	a2,5c4 <memmove+0x2c>
 5d4:	fff6079b          	addiw	a5,a2,-1
 5d8:	1782                	slli	a5,a5,0x20
 5da:	9381                	srli	a5,a5,0x20
 5dc:	fff7c793          	not	a5,a5
 5e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5e2:	15fd                	addi	a1,a1,-1
 5e4:	177d                	addi	a4,a4,-1
 5e6:	0005c683          	lbu	a3,0(a1)
 5ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5ee:	fee79ae3          	bne	a5,a4,5e2 <memmove+0x4a>
 5f2:	bfc9                	j	5c4 <memmove+0x2c>

00000000000005f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5f4:	1141                	addi	sp,sp,-16
 5f6:	e422                	sd	s0,8(sp)
 5f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5fa:	ca05                	beqz	a2,62a <memcmp+0x36>
 5fc:	fff6069b          	addiw	a3,a2,-1
 600:	1682                	slli	a3,a3,0x20
 602:	9281                	srli	a3,a3,0x20
 604:	0685                	addi	a3,a3,1
 606:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 608:	00054783          	lbu	a5,0(a0)
 60c:	0005c703          	lbu	a4,0(a1)
 610:	00e79863          	bne	a5,a4,620 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 614:	0505                	addi	a0,a0,1
    p2++;
 616:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 618:	fed518e3          	bne	a0,a3,608 <memcmp+0x14>
  }
  return 0;
 61c:	4501                	li	a0,0
 61e:	a019                	j	624 <memcmp+0x30>
      return *p1 - *p2;
 620:	40e7853b          	subw	a0,a5,a4
}
 624:	6422                	ld	s0,8(sp)
 626:	0141                	addi	sp,sp,16
 628:	8082                	ret
  return 0;
 62a:	4501                	li	a0,0
 62c:	bfe5                	j	624 <memcmp+0x30>

000000000000062e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e406                	sd	ra,8(sp)
 632:	e022                	sd	s0,0(sp)
 634:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 636:	00000097          	auipc	ra,0x0
 63a:	f62080e7          	jalr	-158(ra) # 598 <memmove>
}
 63e:	60a2                	ld	ra,8(sp)
 640:	6402                	ld	s0,0(sp)
 642:	0141                	addi	sp,sp,16
 644:	8082                	ret

0000000000000646 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 646:	4885                	li	a7,1
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <exit>:
.global exit
exit:
 li a7, SYS_exit
 64e:	4889                	li	a7,2
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <wait>:
.global wait
wait:
 li a7, SYS_wait
 656:	488d                	li	a7,3
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 65e:	4891                	li	a7,4
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <read>:
.global read
read:
 li a7, SYS_read
 666:	4895                	li	a7,5
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <write>:
.global write
write:
 li a7, SYS_write
 66e:	48c1                	li	a7,16
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <close>:
.global close
close:
 li a7, SYS_close
 676:	48d5                	li	a7,21
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <kill>:
.global kill
kill:
 li a7, SYS_kill
 67e:	4899                	li	a7,6
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <exec>:
.global exec
exec:
 li a7, SYS_exec
 686:	489d                	li	a7,7
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <open>:
.global open
open:
 li a7, SYS_open
 68e:	48bd                	li	a7,15
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 696:	48c5                	li	a7,17
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 69e:	48c9                	li	a7,18
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6a6:	48a1                	li	a7,8
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <link>:
.global link
link:
 li a7, SYS_link
 6ae:	48cd                	li	a7,19
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6b6:	48d1                	li	a7,20
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6be:	48a5                	li	a7,9
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c6:	48a9                	li	a7,10
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ce:	48ad                	li	a7,11
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d6:	48b1                	li	a7,12
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6de:	48b5                	li	a7,13
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e6:	48b9                	li	a7,14
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6ee:	48d9                	li	a7,22
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f6:	1101                	addi	sp,sp,-32
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	e822                	sd	s0,16(sp)
 6fc:	1000                	addi	s0,sp,32
 6fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 702:	4605                	li	a2,1
 704:	fef40593          	addi	a1,s0,-17
 708:	00000097          	auipc	ra,0x0
 70c:	f66080e7          	jalr	-154(ra) # 66e <write>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6105                	addi	sp,sp,32
 716:	8082                	ret

0000000000000718 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 718:	7139                	addi	sp,sp,-64
 71a:	fc06                	sd	ra,56(sp)
 71c:	f822                	sd	s0,48(sp)
 71e:	f426                	sd	s1,40(sp)
 720:	f04a                	sd	s2,32(sp)
 722:	ec4e                	sd	s3,24(sp)
 724:	0080                	addi	s0,sp,64
 726:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 728:	c299                	beqz	a3,72e <printint+0x16>
 72a:	0805c863          	bltz	a1,7ba <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 72e:	2581                	sext.w	a1,a1
  neg = 0;
 730:	4881                	li	a7,0
 732:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 736:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 738:	2601                	sext.w	a2,a2
 73a:	00000517          	auipc	a0,0x0
 73e:	5ce50513          	addi	a0,a0,1486 # d08 <digits>
 742:	883a                	mv	a6,a4
 744:	2705                	addiw	a4,a4,1
 746:	02c5f7bb          	remuw	a5,a1,a2
 74a:	1782                	slli	a5,a5,0x20
 74c:	9381                	srli	a5,a5,0x20
 74e:	97aa                	add	a5,a5,a0
 750:	0007c783          	lbu	a5,0(a5)
 754:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 758:	0005879b          	sext.w	a5,a1
 75c:	02c5d5bb          	divuw	a1,a1,a2
 760:	0685                	addi	a3,a3,1
 762:	fec7f0e3          	bgeu	a5,a2,742 <printint+0x2a>
  if(neg)
 766:	00088b63          	beqz	a7,77c <printint+0x64>
    buf[i++] = '-';
 76a:	fd040793          	addi	a5,s0,-48
 76e:	973e                	add	a4,a4,a5
 770:	02d00793          	li	a5,45
 774:	fef70823          	sb	a5,-16(a4)
 778:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 77c:	02e05863          	blez	a4,7ac <printint+0x94>
 780:	fc040793          	addi	a5,s0,-64
 784:	00e78933          	add	s2,a5,a4
 788:	fff78993          	addi	s3,a5,-1
 78c:	99ba                	add	s3,s3,a4
 78e:	377d                	addiw	a4,a4,-1
 790:	1702                	slli	a4,a4,0x20
 792:	9301                	srli	a4,a4,0x20
 794:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 798:	fff94583          	lbu	a1,-1(s2)
 79c:	8526                	mv	a0,s1
 79e:	00000097          	auipc	ra,0x0
 7a2:	f58080e7          	jalr	-168(ra) # 6f6 <putc>
  while(--i >= 0)
 7a6:	197d                	addi	s2,s2,-1
 7a8:	ff3918e3          	bne	s2,s3,798 <printint+0x80>
}
 7ac:	70e2                	ld	ra,56(sp)
 7ae:	7442                	ld	s0,48(sp)
 7b0:	74a2                	ld	s1,40(sp)
 7b2:	7902                	ld	s2,32(sp)
 7b4:	69e2                	ld	s3,24(sp)
 7b6:	6121                	addi	sp,sp,64
 7b8:	8082                	ret
    x = -xx;
 7ba:	40b005bb          	negw	a1,a1
    neg = 1;
 7be:	4885                	li	a7,1
    x = -xx;
 7c0:	bf8d                	j	732 <printint+0x1a>

00000000000007c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c2:	7119                	addi	sp,sp,-128
 7c4:	fc86                	sd	ra,120(sp)
 7c6:	f8a2                	sd	s0,112(sp)
 7c8:	f4a6                	sd	s1,104(sp)
 7ca:	f0ca                	sd	s2,96(sp)
 7cc:	ecce                	sd	s3,88(sp)
 7ce:	e8d2                	sd	s4,80(sp)
 7d0:	e4d6                	sd	s5,72(sp)
 7d2:	e0da                	sd	s6,64(sp)
 7d4:	fc5e                	sd	s7,56(sp)
 7d6:	f862                	sd	s8,48(sp)
 7d8:	f466                	sd	s9,40(sp)
 7da:	f06a                	sd	s10,32(sp)
 7dc:	ec6e                	sd	s11,24(sp)
 7de:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7e0:	0005c903          	lbu	s2,0(a1)
 7e4:	18090f63          	beqz	s2,982 <vprintf+0x1c0>
 7e8:	8aaa                	mv	s5,a0
 7ea:	8b32                	mv	s6,a2
 7ec:	00158493          	addi	s1,a1,1
  state = 0;
 7f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7f2:	02500a13          	li	s4,37
      if(c == 'd'){
 7f6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7fa:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7fe:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 802:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 806:	00000b97          	auipc	s7,0x0
 80a:	502b8b93          	addi	s7,s7,1282 # d08 <digits>
 80e:	a839                	j	82c <vprintf+0x6a>
        putc(fd, c);
 810:	85ca                	mv	a1,s2
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	ee2080e7          	jalr	-286(ra) # 6f6 <putc>
 81c:	a019                	j	822 <vprintf+0x60>
    } else if(state == '%'){
 81e:	01498f63          	beq	s3,s4,83c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 822:	0485                	addi	s1,s1,1
 824:	fff4c903          	lbu	s2,-1(s1)
 828:	14090d63          	beqz	s2,982 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 82c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 830:	fe0997e3          	bnez	s3,81e <vprintf+0x5c>
      if(c == '%'){
 834:	fd479ee3          	bne	a5,s4,810 <vprintf+0x4e>
        state = '%';
 838:	89be                	mv	s3,a5
 83a:	b7e5                	j	822 <vprintf+0x60>
      if(c == 'd'){
 83c:	05878063          	beq	a5,s8,87c <vprintf+0xba>
      } else if(c == 'l') {
 840:	05978c63          	beq	a5,s9,898 <vprintf+0xd6>
      } else if(c == 'x') {
 844:	07a78863          	beq	a5,s10,8b4 <vprintf+0xf2>
      } else if(c == 'p') {
 848:	09b78463          	beq	a5,s11,8d0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 84c:	07300713          	li	a4,115
 850:	0ce78663          	beq	a5,a4,91c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 854:	06300713          	li	a4,99
 858:	0ee78e63          	beq	a5,a4,954 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 85c:	11478863          	beq	a5,s4,96c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 860:	85d2                	mv	a1,s4
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	e92080e7          	jalr	-366(ra) # 6f6 <putc>
        putc(fd, c);
 86c:	85ca                	mv	a1,s2
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	e86080e7          	jalr	-378(ra) # 6f6 <putc>
      }
      state = 0;
 878:	4981                	li	s3,0
 87a:	b765                	j	822 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 87c:	008b0913          	addi	s2,s6,8
 880:	4685                	li	a3,1
 882:	4629                	li	a2,10
 884:	000b2583          	lw	a1,0(s6)
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	e8e080e7          	jalr	-370(ra) # 718 <printint>
 892:	8b4a                	mv	s6,s2
      state = 0;
 894:	4981                	li	s3,0
 896:	b771                	j	822 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 898:	008b0913          	addi	s2,s6,8
 89c:	4681                	li	a3,0
 89e:	4629                	li	a2,10
 8a0:	000b2583          	lw	a1,0(s6)
 8a4:	8556                	mv	a0,s5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	e72080e7          	jalr	-398(ra) # 718 <printint>
 8ae:	8b4a                	mv	s6,s2
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	bf85                	j	822 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8b4:	008b0913          	addi	s2,s6,8
 8b8:	4681                	li	a3,0
 8ba:	4641                	li	a2,16
 8bc:	000b2583          	lw	a1,0(s6)
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e56080e7          	jalr	-426(ra) # 718 <printint>
 8ca:	8b4a                	mv	s6,s2
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	bf91                	j	822 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8d0:	008b0793          	addi	a5,s6,8
 8d4:	f8f43423          	sd	a5,-120(s0)
 8d8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8dc:	03000593          	li	a1,48
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	e14080e7          	jalr	-492(ra) # 6f6 <putc>
  putc(fd, 'x');
 8ea:	85ea                	mv	a1,s10
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e08080e7          	jalr	-504(ra) # 6f6 <putc>
 8f6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8f8:	03c9d793          	srli	a5,s3,0x3c
 8fc:	97de                	add	a5,a5,s7
 8fe:	0007c583          	lbu	a1,0(a5)
 902:	8556                	mv	a0,s5
 904:	00000097          	auipc	ra,0x0
 908:	df2080e7          	jalr	-526(ra) # 6f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 90c:	0992                	slli	s3,s3,0x4
 90e:	397d                	addiw	s2,s2,-1
 910:	fe0914e3          	bnez	s2,8f8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 914:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 918:	4981                	li	s3,0
 91a:	b721                	j	822 <vprintf+0x60>
        s = va_arg(ap, char*);
 91c:	008b0993          	addi	s3,s6,8
 920:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 924:	02090163          	beqz	s2,946 <vprintf+0x184>
        while(*s != 0){
 928:	00094583          	lbu	a1,0(s2)
 92c:	c9a1                	beqz	a1,97c <vprintf+0x1ba>
          putc(fd, *s);
 92e:	8556                	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	dc6080e7          	jalr	-570(ra) # 6f6 <putc>
          s++;
 938:	0905                	addi	s2,s2,1
        while(*s != 0){
 93a:	00094583          	lbu	a1,0(s2)
 93e:	f9e5                	bnez	a1,92e <vprintf+0x16c>
        s = va_arg(ap, char*);
 940:	8b4e                	mv	s6,s3
      state = 0;
 942:	4981                	li	s3,0
 944:	bdf9                	j	822 <vprintf+0x60>
          s = "(null)";
 946:	00000917          	auipc	s2,0x0
 94a:	3ba90913          	addi	s2,s2,954 # d00 <malloc+0x274>
        while(*s != 0){
 94e:	02800593          	li	a1,40
 952:	bff1                	j	92e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 954:	008b0913          	addi	s2,s6,8
 958:	000b4583          	lbu	a1,0(s6)
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	d98080e7          	jalr	-616(ra) # 6f6 <putc>
 966:	8b4a                	mv	s6,s2
      state = 0;
 968:	4981                	li	s3,0
 96a:	bd65                	j	822 <vprintf+0x60>
        putc(fd, c);
 96c:	85d2                	mv	a1,s4
 96e:	8556                	mv	a0,s5
 970:	00000097          	auipc	ra,0x0
 974:	d86080e7          	jalr	-634(ra) # 6f6 <putc>
      state = 0;
 978:	4981                	li	s3,0
 97a:	b565                	j	822 <vprintf+0x60>
        s = va_arg(ap, char*);
 97c:	8b4e                	mv	s6,s3
      state = 0;
 97e:	4981                	li	s3,0
 980:	b54d                	j	822 <vprintf+0x60>
    }
  }
}
 982:	70e6                	ld	ra,120(sp)
 984:	7446                	ld	s0,112(sp)
 986:	74a6                	ld	s1,104(sp)
 988:	7906                	ld	s2,96(sp)
 98a:	69e6                	ld	s3,88(sp)
 98c:	6a46                	ld	s4,80(sp)
 98e:	6aa6                	ld	s5,72(sp)
 990:	6b06                	ld	s6,64(sp)
 992:	7be2                	ld	s7,56(sp)
 994:	7c42                	ld	s8,48(sp)
 996:	7ca2                	ld	s9,40(sp)
 998:	7d02                	ld	s10,32(sp)
 99a:	6de2                	ld	s11,24(sp)
 99c:	6109                	addi	sp,sp,128
 99e:	8082                	ret

00000000000009a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9a0:	715d                	addi	sp,sp,-80
 9a2:	ec06                	sd	ra,24(sp)
 9a4:	e822                	sd	s0,16(sp)
 9a6:	1000                	addi	s0,sp,32
 9a8:	e010                	sd	a2,0(s0)
 9aa:	e414                	sd	a3,8(s0)
 9ac:	e818                	sd	a4,16(s0)
 9ae:	ec1c                	sd	a5,24(s0)
 9b0:	03043023          	sd	a6,32(s0)
 9b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9bc:	8622                	mv	a2,s0
 9be:	00000097          	auipc	ra,0x0
 9c2:	e04080e7          	jalr	-508(ra) # 7c2 <vprintf>
}
 9c6:	60e2                	ld	ra,24(sp)
 9c8:	6442                	ld	s0,16(sp)
 9ca:	6161                	addi	sp,sp,80
 9cc:	8082                	ret

00000000000009ce <printf>:

void
printf(const char *fmt, ...)
{
 9ce:	711d                	addi	sp,sp,-96
 9d0:	ec06                	sd	ra,24(sp)
 9d2:	e822                	sd	s0,16(sp)
 9d4:	1000                	addi	s0,sp,32
 9d6:	e40c                	sd	a1,8(s0)
 9d8:	e810                	sd	a2,16(s0)
 9da:	ec14                	sd	a3,24(s0)
 9dc:	f018                	sd	a4,32(s0)
 9de:	f41c                	sd	a5,40(s0)
 9e0:	03043823          	sd	a6,48(s0)
 9e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9e8:	00840613          	addi	a2,s0,8
 9ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f0:	85aa                	mv	a1,a0
 9f2:	4505                	li	a0,1
 9f4:	00000097          	auipc	ra,0x0
 9f8:	dce080e7          	jalr	-562(ra) # 7c2 <vprintf>
}
 9fc:	60e2                	ld	ra,24(sp)
 9fe:	6442                	ld	s0,16(sp)
 a00:	6125                	addi	sp,sp,96
 a02:	8082                	ret

0000000000000a04 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a04:	1141                	addi	sp,sp,-16
 a06:	e422                	sd	s0,8(sp)
 a08:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a0a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0e:	00000797          	auipc	a5,0x0
 a12:	5f27b783          	ld	a5,1522(a5) # 1000 <freep>
 a16:	a805                	j	a46 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a18:	4618                	lw	a4,8(a2)
 a1a:	9db9                	addw	a1,a1,a4
 a1c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a20:	6398                	ld	a4,0(a5)
 a22:	6318                	ld	a4,0(a4)
 a24:	fee53823          	sd	a4,-16(a0)
 a28:	a091                	j	a6c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a2a:	ff852703          	lw	a4,-8(a0)
 a2e:	9e39                	addw	a2,a2,a4
 a30:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a32:	ff053703          	ld	a4,-16(a0)
 a36:	e398                	sd	a4,0(a5)
 a38:	a099                	j	a7e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3a:	6398                	ld	a4,0(a5)
 a3c:	00e7e463          	bltu	a5,a4,a44 <free+0x40>
 a40:	00e6ea63          	bltu	a3,a4,a54 <free+0x50>
{
 a44:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a46:	fed7fae3          	bgeu	a5,a3,a3a <free+0x36>
 a4a:	6398                	ld	a4,0(a5)
 a4c:	00e6e463          	bltu	a3,a4,a54 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a50:	fee7eae3          	bltu	a5,a4,a44 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a54:	ff852583          	lw	a1,-8(a0)
 a58:	6390                	ld	a2,0(a5)
 a5a:	02059713          	slli	a4,a1,0x20
 a5e:	9301                	srli	a4,a4,0x20
 a60:	0712                	slli	a4,a4,0x4
 a62:	9736                	add	a4,a4,a3
 a64:	fae60ae3          	beq	a2,a4,a18 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a68:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a6c:	4790                	lw	a2,8(a5)
 a6e:	02061713          	slli	a4,a2,0x20
 a72:	9301                	srli	a4,a4,0x20
 a74:	0712                	slli	a4,a4,0x4
 a76:	973e                	add	a4,a4,a5
 a78:	fae689e3          	beq	a3,a4,a2a <free+0x26>
  } else
    p->s.ptr = bp;
 a7c:	e394                	sd	a3,0(a5)
  freep = p;
 a7e:	00000717          	auipc	a4,0x0
 a82:	58f73123          	sd	a5,1410(a4) # 1000 <freep>
}
 a86:	6422                	ld	s0,8(sp)
 a88:	0141                	addi	sp,sp,16
 a8a:	8082                	ret

0000000000000a8c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a8c:	7139                	addi	sp,sp,-64
 a8e:	fc06                	sd	ra,56(sp)
 a90:	f822                	sd	s0,48(sp)
 a92:	f426                	sd	s1,40(sp)
 a94:	f04a                	sd	s2,32(sp)
 a96:	ec4e                	sd	s3,24(sp)
 a98:	e852                	sd	s4,16(sp)
 a9a:	e456                	sd	s5,8(sp)
 a9c:	e05a                	sd	s6,0(sp)
 a9e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa0:	02051493          	slli	s1,a0,0x20
 aa4:	9081                	srli	s1,s1,0x20
 aa6:	04bd                	addi	s1,s1,15
 aa8:	8091                	srli	s1,s1,0x4
 aaa:	0014899b          	addiw	s3,s1,1
 aae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ab0:	00000517          	auipc	a0,0x0
 ab4:	55053503          	ld	a0,1360(a0) # 1000 <freep>
 ab8:	c515                	beqz	a0,ae4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 abc:	4798                	lw	a4,8(a5)
 abe:	02977f63          	bgeu	a4,s1,afc <malloc+0x70>
 ac2:	8a4e                	mv	s4,s3
 ac4:	0009871b          	sext.w	a4,s3
 ac8:	6685                	lui	a3,0x1
 aca:	00d77363          	bgeu	a4,a3,ad0 <malloc+0x44>
 ace:	6a05                	lui	s4,0x1
 ad0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ad4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ad8:	00000917          	auipc	s2,0x0
 adc:	52890913          	addi	s2,s2,1320 # 1000 <freep>
  if(p == (char*)-1)
 ae0:	5afd                	li	s5,-1
 ae2:	a88d                	j	b54 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ae4:	00000797          	auipc	a5,0x0
 ae8:	52c78793          	addi	a5,a5,1324 # 1010 <base>
 aec:	00000717          	auipc	a4,0x0
 af0:	50f73a23          	sd	a5,1300(a4) # 1000 <freep>
 af4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 af6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 afa:	b7e1                	j	ac2 <malloc+0x36>
      if(p->s.size == nunits)
 afc:	02e48b63          	beq	s1,a4,b32 <malloc+0xa6>
        p->s.size -= nunits;
 b00:	4137073b          	subw	a4,a4,s3
 b04:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b06:	1702                	slli	a4,a4,0x20
 b08:	9301                	srli	a4,a4,0x20
 b0a:	0712                	slli	a4,a4,0x4
 b0c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b0e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b12:	00000717          	auipc	a4,0x0
 b16:	4ea73723          	sd	a0,1262(a4) # 1000 <freep>
      return (void*)(p + 1);
 b1a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b1e:	70e2                	ld	ra,56(sp)
 b20:	7442                	ld	s0,48(sp)
 b22:	74a2                	ld	s1,40(sp)
 b24:	7902                	ld	s2,32(sp)
 b26:	69e2                	ld	s3,24(sp)
 b28:	6a42                	ld	s4,16(sp)
 b2a:	6aa2                	ld	s5,8(sp)
 b2c:	6b02                	ld	s6,0(sp)
 b2e:	6121                	addi	sp,sp,64
 b30:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b32:	6398                	ld	a4,0(a5)
 b34:	e118                	sd	a4,0(a0)
 b36:	bff1                	j	b12 <malloc+0x86>
  hp->s.size = nu;
 b38:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b3c:	0541                	addi	a0,a0,16
 b3e:	00000097          	auipc	ra,0x0
 b42:	ec6080e7          	jalr	-314(ra) # a04 <free>
  return freep;
 b46:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b4a:	d971                	beqz	a0,b1e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b4e:	4798                	lw	a4,8(a5)
 b50:	fa9776e3          	bgeu	a4,s1,afc <malloc+0x70>
    if(p == freep)
 b54:	00093703          	ld	a4,0(s2)
 b58:	853e                	mv	a0,a5
 b5a:	fef719e3          	bne	a4,a5,b4c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b5e:	8552                	mv	a0,s4
 b60:	00000097          	auipc	ra,0x0
 b64:	b76080e7          	jalr	-1162(ra) # 6d6 <sbrk>
  if(p == (char*)-1)
 b68:	fd5518e3          	bne	a0,s5,b38 <malloc+0xac>
        return 0;
 b6c:	4501                	li	a0,0
 b6e:	bf45                	j	b1e <malloc+0x92>
