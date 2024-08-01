
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
       0:	bd010113          	addi	sp,sp,-1072
       4:	42113423          	sd	ra,1064(sp)
       8:	42813023          	sd	s0,1056(sp)
       c:	40913c23          	sd	s1,1048(sp)
      10:	41213823          	sd	s2,1040(sp)
      14:	41313423          	sd	s3,1032(sp)
      18:	41413023          	sd	s4,1024(sp)
      1c:	43010413          	addi	s0,sp,1072
      20:	8a2a                	mv	s4,a0
      22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
      24:	20200593          	li	a1,514
      28:	00001097          	auipc	ra,0x1
      2c:	b80080e7          	jalr	-1152(ra) # ba8 <open>
  if(fd < 0){
      30:	04054a63          	bltz	a0,84 <createfile+0x84>
      34:	892a                	mv	s2,a0
    printf("createfile %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
      36:	4481                	li	s1,0
      38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      3c:	40000613          	li	a2,1024
      40:	bd040593          	addi	a1,s0,-1072
      44:	854a                	mv	a0,s2
      46:	00001097          	auipc	ra,0x1
      4a:	b42080e7          	jalr	-1214(ra) # b88 <write>
      4e:	40000793          	li	a5,1024
      52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
      56:	2485                	addiw	s1,s1,1
      58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
      5c:	854a                	mv	a0,s2
      5e:	00001097          	auipc	ra,0x1
      62:	b32080e7          	jalr	-1230(ra) # b90 <close>
}
      66:	42813083          	ld	ra,1064(sp)
      6a:	42013403          	ld	s0,1056(sp)
      6e:	41813483          	ld	s1,1048(sp)
      72:	41013903          	ld	s2,1040(sp)
      76:	40813983          	ld	s3,1032(sp)
      7a:	40013a03          	ld	s4,1024(sp)
      7e:	43010113          	addi	sp,sp,1072
      82:	8082                	ret
    printf("createfile %s failed\n", file);
      84:	85d2                	mv	a1,s4
      86:	00001517          	auipc	a0,0x1
      8a:	08a50513          	addi	a0,a0,138 # 1110 <statistics+0x8e>
      8e:	00001097          	auipc	ra,0x1
      92:	e52080e7          	jalr	-430(ra) # ee0 <printf>
    exit(-1);
      96:	557d                	li	a0,-1
      98:	00001097          	auipc	ra,0x1
      9c:	ad0080e7          	jalr	-1328(ra) # b68 <exit>
      printf("write %s failed\n", file);
      a0:	85d2                	mv	a1,s4
      a2:	00001517          	auipc	a0,0x1
      a6:	08650513          	addi	a0,a0,134 # 1128 <statistics+0xa6>
      aa:	00001097          	auipc	ra,0x1
      ae:	e36080e7          	jalr	-458(ra) # ee0 <printf>
      exit(-1);
      b2:	557d                	li	a0,-1
      b4:	00001097          	auipc	ra,0x1
      b8:	ab4080e7          	jalr	-1356(ra) # b68 <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
      bc:	bc010113          	addi	sp,sp,-1088
      c0:	42113c23          	sd	ra,1080(sp)
      c4:	42813823          	sd	s0,1072(sp)
      c8:	42913423          	sd	s1,1064(sp)
      cc:	43213023          	sd	s2,1056(sp)
      d0:	41313c23          	sd	s3,1048(sp)
      d4:	41413823          	sd	s4,1040(sp)
      d8:	41513423          	sd	s5,1032(sp)
      dc:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
      e0:	40000793          	li	a5,1024
      e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
      e8:	8aaa                	mv	s5,a0
      ea:	8a2e                	mv	s4,a1
      ec:	84b2                	mv	s1,a2
    printf("readfile: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
      ee:	4581                	li	a1,0
      f0:	00001097          	auipc	ra,0x1
      f4:	ab8080e7          	jalr	-1352(ra) # ba8 <open>
      f8:	89aa                	mv	s3,a0
      fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("readfile open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
      fe:	4901                	li	s2,0
     100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
     104:	8626                	mv	a2,s1
     106:	bc040593          	addi	a1,s0,-1088
     10a:	854e                	mv	a0,s3
     10c:	00001097          	auipc	ra,0x1
     110:	a74080e7          	jalr	-1420(ra) # b80 <read>
     114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
     118:	0124893b          	addw	s2,s1,s2
     11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
     120:	854e                	mv	a0,s3
     122:	00001097          	auipc	ra,0x1
     126:	a6e080e7          	jalr	-1426(ra) # b90 <close>
}
     12a:	43813083          	ld	ra,1080(sp)
     12e:	43013403          	ld	s0,1072(sp)
     132:	42813483          	ld	s1,1064(sp)
     136:	42013903          	ld	s2,1056(sp)
     13a:	41813983          	ld	s3,1048(sp)
     13e:	41013a03          	ld	s4,1040(sp)
     142:	40813a83          	ld	s5,1032(sp)
     146:	44010113          	addi	sp,sp,1088
     14a:	8082                	ret
    printf("readfile: inc too large\n");
     14c:	00001517          	auipc	a0,0x1
     150:	ff450513          	addi	a0,a0,-12 # 1140 <statistics+0xbe>
     154:	00001097          	auipc	ra,0x1
     158:	d8c080e7          	jalr	-628(ra) # ee0 <printf>
    exit(-1);
     15c:	557d                	li	a0,-1
     15e:	00001097          	auipc	ra,0x1
     162:	a0a080e7          	jalr	-1526(ra) # b68 <exit>
    printf("readfile open %s failed\n", file);
     166:	85d6                	mv	a1,s5
     168:	00001517          	auipc	a0,0x1
     16c:	ff850513          	addi	a0,a0,-8 # 1160 <statistics+0xde>
     170:	00001097          	auipc	ra,0x1
     174:	d70080e7          	jalr	-656(ra) # ee0 <printf>
    exit(-1);
     178:	557d                	li	a0,-1
     17a:	00001097          	auipc	ra,0x1
     17e:	9ee080e7          	jalr	-1554(ra) # b68 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
     182:	86d2                	mv	a3,s4
     184:	864a                	mv	a2,s2
     186:	85d6                	mv	a1,s5
     188:	00001517          	auipc	a0,0x1
     18c:	ff850513          	addi	a0,a0,-8 # 1180 <statistics+0xfe>
     190:	00001097          	auipc	ra,0x1
     194:	d50080e7          	jalr	-688(ra) # ee0 <printf>
      exit(-1);
     198:	557d                	li	a0,-1
     19a:	00001097          	auipc	ra,0x1
     19e:	9ce080e7          	jalr	-1586(ra) # b68 <exit>

00000000000001a2 <ntas>:

int ntas(int print)
{
     1a2:	1101                	addi	sp,sp,-32
     1a4:	ec06                	sd	ra,24(sp)
     1a6:	e822                	sd	s0,16(sp)
     1a8:	e426                	sd	s1,8(sp)
     1aa:	e04a                	sd	s2,0(sp)
     1ac:	1000                	addi	s0,sp,32
     1ae:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
     1b0:	6585                	lui	a1,0x1
     1b2:	00002517          	auipc	a0,0x2
     1b6:	e5e50513          	addi	a0,a0,-418 # 2010 <buf>
     1ba:	00001097          	auipc	ra,0x1
     1be:	ec8080e7          	jalr	-312(ra) # 1082 <statistics>
     1c2:	02a05b63          	blez	a0,1f8 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
     1c6:	03d00593          	li	a1,61
     1ca:	00002517          	auipc	a0,0x2
     1ce:	e4650513          	addi	a0,a0,-442 # 2010 <buf>
     1d2:	00000097          	auipc	ra,0x0
     1d6:	7b8080e7          	jalr	1976(ra) # 98a <strchr>
  n = atoi(c+2);
     1da:	0509                	addi	a0,a0,2
     1dc:	00001097          	auipc	ra,0x1
     1e0:	88c080e7          	jalr	-1908(ra) # a68 <atoi>
     1e4:	84aa                	mv	s1,a0
  if(print)
     1e6:	02091363          	bnez	s2,20c <ntas+0x6a>
    printf("%s", buf);
  return n;
}
     1ea:	8526                	mv	a0,s1
     1ec:	60e2                	ld	ra,24(sp)
     1ee:	6442                	ld	s0,16(sp)
     1f0:	64a2                	ld	s1,8(sp)
     1f2:	6902                	ld	s2,0(sp)
     1f4:	6105                	addi	sp,sp,32
     1f6:	8082                	ret
    fprintf(2, "ntas: no stats\n");
     1f8:	00001597          	auipc	a1,0x1
     1fc:	fb058593          	addi	a1,a1,-80 # 11a8 <statistics+0x126>
     200:	4509                	li	a0,2
     202:	00001097          	auipc	ra,0x1
     206:	cb0080e7          	jalr	-848(ra) # eb2 <fprintf>
     20a:	bf75                	j	1c6 <ntas+0x24>
    printf("%s", buf);
     20c:	00002597          	auipc	a1,0x2
     210:	e0458593          	addi	a1,a1,-508 # 2010 <buf>
     214:	00001517          	auipc	a0,0x1
     218:	fa450513          	addi	a0,a0,-92 # 11b8 <statistics+0x136>
     21c:	00001097          	auipc	ra,0x1
     220:	cc4080e7          	jalr	-828(ra) # ee0 <printf>
     224:	b7d9                	j	1ea <ntas+0x48>

0000000000000226 <test0>:

// Test reading small files concurrently
void
test0()
{
     226:	7139                	addi	sp,sp,-64
     228:	fc06                	sd	ra,56(sp)
     22a:	f822                	sd	s0,48(sp)
     22c:	f426                	sd	s1,40(sp)
     22e:	f04a                	sd	s2,32(sp)
     230:	ec4e                	sd	s3,24(sp)
     232:	0080                	addi	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 2 };
  int m, n;

  dir[0] = '0';
     234:	03000793          	li	a5,48
     238:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
     23c:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
     240:	04600793          	li	a5,70
     244:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
     248:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
     24c:	00001517          	auipc	a0,0x1
     250:	f7450513          	addi	a0,a0,-140 # 11c0 <statistics+0x13e>
     254:	00001097          	auipc	ra,0x1
     258:	c8c080e7          	jalr	-884(ra) # ee0 <printf>
     25c:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
     260:	00001997          	auipc	s3,0x1
     264:	f8098993          	addi	s3,s3,-128 # 11e0 <statistics+0x15e>
  for(int i = 0; i < NCHILD; i++){
     268:	03200913          	li	s2,50
    dir[0] = '0' + i;
     26c:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
     270:	fc040513          	addi	a0,s0,-64
     274:	00001097          	auipc	ra,0x1
     278:	95c080e7          	jalr	-1700(ra) # bd0 <mkdir>
    if (chdir(dir) < 0) {
     27c:	fc040513          	addi	a0,s0,-64
     280:	00001097          	auipc	ra,0x1
     284:	958080e7          	jalr	-1704(ra) # bd8 <chdir>
     288:	0c054263          	bltz	a0,34c <test0+0x126>
    unlink(file);
     28c:	fc840513          	addi	a0,s0,-56
     290:	00001097          	auipc	ra,0x1
     294:	928080e7          	jalr	-1752(ra) # bb8 <unlink>
    createfile(file, N);
     298:	45a9                	li	a1,10
     29a:	fc840513          	addi	a0,s0,-56
     29e:	00000097          	auipc	ra,0x0
     2a2:	d62080e7          	jalr	-670(ra) # 0 <createfile>
    if (chdir("..") < 0) {
     2a6:	854e                	mv	a0,s3
     2a8:	00001097          	auipc	ra,0x1
     2ac:	930080e7          	jalr	-1744(ra) # bd8 <chdir>
     2b0:	0a054b63          	bltz	a0,366 <test0+0x140>
  for(int i = 0; i < NCHILD; i++){
     2b4:	2485                	addiw	s1,s1,1
     2b6:	0ff4f493          	andi	s1,s1,255
     2ba:	fb2499e3          	bne	s1,s2,26c <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  m = ntas(0);
     2be:	4501                	li	a0,0
     2c0:	00000097          	auipc	ra,0x0
     2c4:	ee2080e7          	jalr	-286(ra) # 1a2 <ntas>
     2c8:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    dir[0] = '0' + i;
     2ca:	03000793          	li	a5,48
     2ce:	fcf40023          	sb	a5,-64(s0)
    int pid = fork();
     2d2:	00001097          	auipc	ra,0x1
     2d6:	88e080e7          	jalr	-1906(ra) # b60 <fork>
    if(pid < 0){
     2da:	0a054363          	bltz	a0,380 <test0+0x15a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
     2de:	cd55                	beqz	a0,39a <test0+0x174>
    dir[0] = '0' + i;
     2e0:	03100793          	li	a5,49
     2e4:	fcf40023          	sb	a5,-64(s0)
    int pid = fork();
     2e8:	00001097          	auipc	ra,0x1
     2ec:	878080e7          	jalr	-1928(ra) # b60 <fork>
    if(pid < 0){
     2f0:	08054863          	bltz	a0,380 <test0+0x15a>
    if(pid == 0){
     2f4:	c15d                	beqz	a0,39a <test0+0x174>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
     2f6:	4501                	li	a0,0
     2f8:	00001097          	auipc	ra,0x1
     2fc:	878080e7          	jalr	-1928(ra) # b70 <wait>
     300:	4501                	li	a0,0
     302:	00001097          	auipc	ra,0x1
     306:	86e080e7          	jalr	-1938(ra) # b70 <wait>
  }
  printf("test0 results:\n");
     30a:	00001517          	auipc	a0,0x1
     30e:	eee50513          	addi	a0,a0,-274 # 11f8 <statistics+0x176>
     312:	00001097          	auipc	ra,0x1
     316:	bce080e7          	jalr	-1074(ra) # ee0 <printf>
  n = ntas(1);
     31a:	4505                	li	a0,1
     31c:	00000097          	auipc	ra,0x0
     320:	e86080e7          	jalr	-378(ra) # 1a2 <ntas>
  if (n-m < 500)
     324:	9d05                	subw	a0,a0,s1
     326:	1f300793          	li	a5,499
     32a:	0aa7cc63          	blt	a5,a0,3e2 <test0+0x1bc>
    printf("test0: OK\n");
     32e:	00001517          	auipc	a0,0x1
     332:	eda50513          	addi	a0,a0,-294 # 1208 <statistics+0x186>
     336:	00001097          	auipc	ra,0x1
     33a:	baa080e7          	jalr	-1110(ra) # ee0 <printf>
  else
    printf("test0: FAIL\n");
}
     33e:	70e2                	ld	ra,56(sp)
     340:	7442                	ld	s0,48(sp)
     342:	74a2                	ld	s1,40(sp)
     344:	7902                	ld	s2,32(sp)
     346:	69e2                	ld	s3,24(sp)
     348:	6121                	addi	sp,sp,64
     34a:	8082                	ret
      printf("chdir failed\n");
     34c:	00001517          	auipc	a0,0x1
     350:	e8450513          	addi	a0,a0,-380 # 11d0 <statistics+0x14e>
     354:	00001097          	auipc	ra,0x1
     358:	b8c080e7          	jalr	-1140(ra) # ee0 <printf>
      exit(1);
     35c:	4505                	li	a0,1
     35e:	00001097          	auipc	ra,0x1
     362:	80a080e7          	jalr	-2038(ra) # b68 <exit>
      printf("chdir failed\n");
     366:	00001517          	auipc	a0,0x1
     36a:	e6a50513          	addi	a0,a0,-406 # 11d0 <statistics+0x14e>
     36e:	00001097          	auipc	ra,0x1
     372:	b72080e7          	jalr	-1166(ra) # ee0 <printf>
      exit(1);
     376:	4505                	li	a0,1
     378:	00000097          	auipc	ra,0x0
     37c:	7f0080e7          	jalr	2032(ra) # b68 <exit>
      printf("fork failed");
     380:	00001517          	auipc	a0,0x1
     384:	e6850513          	addi	a0,a0,-408 # 11e8 <statistics+0x166>
     388:	00001097          	auipc	ra,0x1
     38c:	b58080e7          	jalr	-1192(ra) # ee0 <printf>
      exit(-1);
     390:	557d                	li	a0,-1
     392:	00000097          	auipc	ra,0x0
     396:	7d6080e7          	jalr	2006(ra) # b68 <exit>
      if (chdir(dir) < 0) {
     39a:	fc040513          	addi	a0,s0,-64
     39e:	00001097          	auipc	ra,0x1
     3a2:	83a080e7          	jalr	-1990(ra) # bd8 <chdir>
     3a6:	02054163          	bltz	a0,3c8 <test0+0x1a2>
      readfile(file, N*BSIZE, 1);
     3aa:	4605                	li	a2,1
     3ac:	658d                	lui	a1,0x3
     3ae:	80058593          	addi	a1,a1,-2048 # 2800 <buf+0x7f0>
     3b2:	fc840513          	addi	a0,s0,-56
     3b6:	00000097          	auipc	ra,0x0
     3ba:	d06080e7          	jalr	-762(ra) # bc <readfile>
      exit(0);
     3be:	4501                	li	a0,0
     3c0:	00000097          	auipc	ra,0x0
     3c4:	7a8080e7          	jalr	1960(ra) # b68 <exit>
        printf("chdir failed\n");
     3c8:	00001517          	auipc	a0,0x1
     3cc:	e0850513          	addi	a0,a0,-504 # 11d0 <statistics+0x14e>
     3d0:	00001097          	auipc	ra,0x1
     3d4:	b10080e7          	jalr	-1264(ra) # ee0 <printf>
        exit(1);
     3d8:	4505                	li	a0,1
     3da:	00000097          	auipc	ra,0x0
     3de:	78e080e7          	jalr	1934(ra) # b68 <exit>
    printf("test0: FAIL\n");
     3e2:	00001517          	auipc	a0,0x1
     3e6:	e3650513          	addi	a0,a0,-458 # 1218 <statistics+0x196>
     3ea:	00001097          	auipc	ra,0x1
     3ee:	af6080e7          	jalr	-1290(ra) # ee0 <printf>
}
     3f2:	b7b1                	j	33e <test0+0x118>

00000000000003f4 <test1>:

// Test bcache evictions by reading a large file concurrently
void test1()
{
     3f4:	7179                	addi	sp,sp,-48
     3f6:	f406                	sd	ra,40(sp)
     3f8:	f022                	sd	s0,32(sp)
     3fa:	ec26                	sd	s1,24(sp)
     3fc:	e84a                	sd	s2,16(sp)
     3fe:	1800                	addi	s0,sp,48
  char file[3];
  enum { N = 200, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
     400:	00001517          	auipc	a0,0x1
     404:	e2850513          	addi	a0,a0,-472 # 1228 <statistics+0x1a6>
     408:	00001097          	auipc	ra,0x1
     40c:	ad8080e7          	jalr	-1320(ra) # ee0 <printf>
  file[0] = 'B';
     410:	04200793          	li	a5,66
     414:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
     418:	fc040d23          	sb	zero,-38(s0)
     41c:	4485                	li	s1,1
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
    unlink(file);
    if (i == 0) {
     41e:	4905                	li	s2,1
     420:	a811                	j	434 <test1+0x40>
      createfile(file, BIG);
     422:	06400593          	li	a1,100
     426:	fd840513          	addi	a0,s0,-40
     42a:	00000097          	auipc	ra,0x0
     42e:	bd6080e7          	jalr	-1066(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
     432:	2485                	addiw	s1,s1,1
    file[1] = '0' + i;
     434:	02f4879b          	addiw	a5,s1,47
     438:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
     43c:	fd840513          	addi	a0,s0,-40
     440:	00000097          	auipc	ra,0x0
     444:	778080e7          	jalr	1912(ra) # bb8 <unlink>
    if (i == 0) {
     448:	fd248de3          	beq	s1,s2,422 <test1+0x2e>
    } else {
      createfile(file, 1);
     44c:	85ca                	mv	a1,s2
     44e:	fd840513          	addi	a0,s0,-40
     452:	00000097          	auipc	ra,0x0
     456:	bae080e7          	jalr	-1106(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
     45a:	0004879b          	sext.w	a5,s1
     45e:	fcf95ae3          	bge	s2,a5,432 <test1+0x3e>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
     462:	03000793          	li	a5,48
     466:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
     46a:	00000097          	auipc	ra,0x0
     46e:	6f6080e7          	jalr	1782(ra) # b60 <fork>
    if(pid < 0){
     472:	04054663          	bltz	a0,4be <test1+0xca>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
     476:	c12d                	beqz	a0,4d8 <test1+0xe4>
    file[1] = '0' + i;
     478:	03100793          	li	a5,49
     47c:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
     480:	00000097          	auipc	ra,0x0
     484:	6e0080e7          	jalr	1760(ra) # b60 <fork>
    if(pid < 0){
     488:	02054b63          	bltz	a0,4be <test1+0xca>
    if(pid == 0){
     48c:	cd35                	beqz	a0,508 <test1+0x114>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
     48e:	4501                	li	a0,0
     490:	00000097          	auipc	ra,0x0
     494:	6e0080e7          	jalr	1760(ra) # b70 <wait>
     498:	4501                	li	a0,0
     49a:	00000097          	auipc	ra,0x0
     49e:	6d6080e7          	jalr	1750(ra) # b70 <wait>
  }
  printf("test1 OK\n");
     4a2:	00001517          	auipc	a0,0x1
     4a6:	d9650513          	addi	a0,a0,-618 # 1238 <statistics+0x1b6>
     4aa:	00001097          	auipc	ra,0x1
     4ae:	a36080e7          	jalr	-1482(ra) # ee0 <printf>
}
     4b2:	70a2                	ld	ra,40(sp)
     4b4:	7402                	ld	s0,32(sp)
     4b6:	64e2                	ld	s1,24(sp)
     4b8:	6942                	ld	s2,16(sp)
     4ba:	6145                	addi	sp,sp,48
     4bc:	8082                	ret
      printf("fork failed");
     4be:	00001517          	auipc	a0,0x1
     4c2:	d2a50513          	addi	a0,a0,-726 # 11e8 <statistics+0x166>
     4c6:	00001097          	auipc	ra,0x1
     4ca:	a1a080e7          	jalr	-1510(ra) # ee0 <printf>
      exit(-1);
     4ce:	557d                	li	a0,-1
     4d0:	00000097          	auipc	ra,0x0
     4d4:	698080e7          	jalr	1688(ra) # b68 <exit>
    if(pid == 0){
     4d8:	0c800493          	li	s1,200
          readfile(file, BIG*BSIZE, BSIZE);
     4dc:	40000613          	li	a2,1024
     4e0:	65e5                	lui	a1,0x19
     4e2:	fd840513          	addi	a0,s0,-40
     4e6:	00000097          	auipc	ra,0x0
     4ea:	bd6080e7          	jalr	-1066(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
     4ee:	34fd                	addiw	s1,s1,-1
     4f0:	f4f5                	bnez	s1,4dc <test1+0xe8>
        unlink(file);
     4f2:	fd840513          	addi	a0,s0,-40
     4f6:	00000097          	auipc	ra,0x0
     4fa:	6c2080e7          	jalr	1730(ra) # bb8 <unlink>
        exit(0);
     4fe:	4501                	li	a0,0
     500:	00000097          	auipc	ra,0x0
     504:	668080e7          	jalr	1640(ra) # b68 <exit>
     508:	6485                	lui	s1,0x1
     50a:	fa048493          	addi	s1,s1,-96 # fa0 <malloc+0x2>
          readfile(file, 1, BSIZE);
     50e:	40000613          	li	a2,1024
     512:	4585                	li	a1,1
     514:	fd840513          	addi	a0,s0,-40
     518:	00000097          	auipc	ra,0x0
     51c:	ba4080e7          	jalr	-1116(ra) # bc <readfile>
        for (i = 0; i < N*20; i++) {
     520:	34fd                	addiw	s1,s1,-1
     522:	f4f5                	bnez	s1,50e <test1+0x11a>
        unlink(file);
     524:	fd840513          	addi	a0,s0,-40
     528:	00000097          	auipc	ra,0x0
     52c:	690080e7          	jalr	1680(ra) # bb8 <unlink>
      exit(0);
     530:	4501                	li	a0,0
     532:	00000097          	auipc	ra,0x0
     536:	636080e7          	jalr	1590(ra) # b68 <exit>

000000000000053a <test2>:
//
// test concurrent creates.
//
void
test2()
{
     53a:	7159                	addi	sp,sp,-112
     53c:	f486                	sd	ra,104(sp)
     53e:	f0a2                	sd	s0,96(sp)
     540:	eca6                	sd	s1,88(sp)
     542:	e8ca                	sd	s2,80(sp)
     544:	e4ce                	sd	s3,72(sp)
     546:	e0d2                	sd	s4,64(sp)
     548:	fc56                	sd	s5,56(sp)
     54a:	f85a                	sd	s6,48(sp)
     54c:	f45e                	sd	s7,40(sp)
     54e:	1880                	addi	s0,sp,112
  int nc = 4;
  char file[16];

  printf("start test2\n");
     550:	00001517          	auipc	a0,0x1
     554:	cf850513          	addi	a0,a0,-776 # 1248 <statistics+0x1c6>
     558:	00001097          	auipc	ra,0x1
     55c:	988080e7          	jalr	-1656(ra) # ee0 <printf>
  
  mkdir("d2");
     560:	00001517          	auipc	a0,0x1
     564:	cf850513          	addi	a0,a0,-776 # 1258 <statistics+0x1d6>
     568:	00000097          	auipc	ra,0x0
     56c:	668080e7          	jalr	1640(ra) # bd0 <mkdir>

  file[0] = 'd';
     570:	06400793          	li	a5,100
     574:	faf40023          	sb	a5,-96(s0)
  file[1] = '2';
     578:	03200793          	li	a5,50
     57c:	faf400a3          	sb	a5,-95(s0)
  file[2] = '/';
     580:	02f00793          	li	a5,47
     584:	faf40123          	sb	a5,-94(s0)
     588:	03000913          	li	s2,48
{
     58c:	06100a93          	li	s5,97

  // remove any stale existing files.
  for(int i = 0; i < 50; i++){
    for(int ci = 0; ci < nc; ci++){
     590:	06500993          	li	s3,101
  for(int i = 0; i < 50; i++){
     594:	06200a13          	li	s4,98
     598:	a031                	j	5a4 <test2+0x6a>
     59a:	2905                	addiw	s2,s2,1
     59c:	0ff97913          	andi	s2,s2,255
     5a0:	03490563          	beq	s2,s4,5ca <test2+0x90>
{
     5a4:	84d6                	mv	s1,s5
      file[3] = 'a' + ci;
     5a6:	fa9401a3          	sb	s1,-93(s0)
      file[4] = '0' + i;
     5aa:	fb240223          	sb	s2,-92(s0)
      file[5] = '\0';
     5ae:	fa0402a3          	sb	zero,-91(s0)
      unlink(file);
     5b2:	fa040513          	addi	a0,s0,-96
     5b6:	00000097          	auipc	ra,0x0
     5ba:	602080e7          	jalr	1538(ra) # bb8 <unlink>
    for(int ci = 0; ci < nc; ci++){
     5be:	2485                	addiw	s1,s1,1
     5c0:	0ff4f493          	andi	s1,s1,255
     5c4:	ff3491e3          	bne	s1,s3,5a6 <test2+0x6c>
     5c8:	bfc9                	j	59a <test2+0x60>
    }
  }

  int pids[nc];
  for(int ci = 0; ci < nc; ci++){
     5ca:	4481                	li	s1,0
     5cc:	4991                	li	s3,4
    pids[ci] = fork();
     5ce:	00000097          	auipc	ra,0x0
     5d2:	592080e7          	jalr	1426(ra) # b60 <fork>
     5d6:	892a                	mv	s2,a0
    if(pids[ci] < 0){
     5d8:	00054d63          	bltz	a0,5f2 <test2+0xb8>
      printf("test2: fork failed\n");
      exit(1);
    }
    if(pids[ci] == 0){
     5dc:	c905                	beqz	a0,60c <test2+0xd2>
  for(int ci = 0; ci < nc; ci++){
     5de:	2485                	addiw	s1,s1,1
     5e0:	ff3497e3          	bne	s1,s3,5ce <test2+0x94>
     5e4:	4491                	li	s1,4

      exit(0);
    }
  }

  int ok = 1;
     5e6:	4905                	li	s2,1

  for(int ci = 0; ci < nc; ci++){
    int st = 0;
    int ret = wait(&st);
    if(ret <= 0){
      printf("test2: wait() failed\n");
     5e8:	00001997          	auipc	s3,0x1
     5ec:	d5898993          	addi	s3,s3,-680 # 1340 <statistics+0x2be>
     5f0:	a485                	j	850 <test2+0x316>
      printf("test2: fork failed\n");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	c6e50513          	addi	a0,a0,-914 # 1260 <statistics+0x1de>
     5fa:	00001097          	auipc	ra,0x1
     5fe:	8e6080e7          	jalr	-1818(ra) # ee0 <printf>
      exit(1);
     602:	4505                	li	a0,1
     604:	00000097          	auipc	ra,0x0
     608:	564080e7          	jalr	1380(ra) # b68 <exit>
      char me = "abcdefghijklmnop"[ci];
     60c:	00001797          	auipc	a5,0x1
     610:	d6c78793          	addi	a5,a5,-660 # 1378 <statistics+0x2f6>
     614:	97a6                	add	a5,a5,s1
     616:	0007c983          	lbu	s3,0(a5)
      int pid = getpid();
     61a:	00000097          	auipc	ra,0x0
     61e:	5ce080e7          	jalr	1486(ra) # be8 <getpid>
     622:	8b2a                	mv	s6,a0
      int nf = (ci == 0 ? 10 : 15);
     624:	4a29                	li	s4,10
     626:	c091                	beqz	s1,62a <test2+0xf0>
     628:	4a3d                	li	s4,15
        int xx = (pid << 16) | i;
     62a:	010b1b1b          	slliw	s6,s6,0x10
      for(int i = 0; i < nf; i++){
     62e:	8aca                	mv	s5,s2
     630:	a011                	j	634 <test2+0xfa>
     632:	8aa6                	mv	s5,s1
        file[3] = me;
     634:	fb3401a3          	sb	s3,-93(s0)
        file[4] = '0' + i;
     638:	030a879b          	addiw	a5,s5,48
     63c:	faf40223          	sb	a5,-92(s0)
        file[5] = '\0';
     640:	fa0402a3          	sb	zero,-91(s0)
        int fd = open(file, O_CREATE | O_RDWR);
     644:	20200593          	li	a1,514
     648:	fa040513          	addi	a0,s0,-96
     64c:	00000097          	auipc	ra,0x0
     650:	55c080e7          	jalr	1372(ra) # ba8 <open>
     654:	84aa                	mv	s1,a0
        if(fd < 0){
     656:	04054e63          	bltz	a0,6b2 <test2+0x178>
        int xx = (pid << 16) | i;
     65a:	015b67b3          	or	a5,s6,s5
     65e:	f8f42e23          	sw	a5,-100(s0)
          sleep(1);
     662:	4505                	li	a0,1
     664:	00000097          	auipc	ra,0x0
     668:	594080e7          	jalr	1428(ra) # bf8 <sleep>
          if(write(fd, &xx, sizeof(xx)) <= 0){
     66c:	4611                	li	a2,4
     66e:	f9c40593          	addi	a1,s0,-100
     672:	8526                	mv	a0,s1
     674:	00000097          	auipc	ra,0x0
     678:	514080e7          	jalr	1300(ra) # b88 <write>
     67c:	04a05a63          	blez	a0,6d0 <test2+0x196>
          sleep(1);
     680:	4505                	li	a0,1
     682:	00000097          	auipc	ra,0x0
     686:	576080e7          	jalr	1398(ra) # bf8 <sleep>
          if(write(fd, &xx, sizeof(xx)) <= 0){
     68a:	4611                	li	a2,4
     68c:	f9c40593          	addi	a1,s0,-100
     690:	8526                	mv	a0,s1
     692:	00000097          	auipc	ra,0x0
     696:	4f6080e7          	jalr	1270(ra) # b88 <write>
     69a:	02a05b63          	blez	a0,6d0 <test2+0x196>
        close(fd);
     69e:	8526                	mv	a0,s1
     6a0:	00000097          	auipc	ra,0x0
     6a4:	4f0080e7          	jalr	1264(ra) # b90 <close>
      for(int i = 0; i < nf; i++){
     6a8:	001a849b          	addiw	s1,s5,1
     6ac:	f89a13e3          	bne	s4,s1,632 <test2+0xf8>
     6b0:	a081                	j	6f0 <test2+0x1b6>
          printf("test2: create %s failed\n", file);
     6b2:	fa040593          	addi	a1,s0,-96
     6b6:	00001517          	auipc	a0,0x1
     6ba:	bc250513          	addi	a0,a0,-1086 # 1278 <statistics+0x1f6>
     6be:	00001097          	auipc	ra,0x1
     6c2:	822080e7          	jalr	-2014(ra) # ee0 <printf>
          exit(1);
     6c6:	4505                	li	a0,1
     6c8:	00000097          	auipc	ra,0x0
     6cc:	4a0080e7          	jalr	1184(ra) # b68 <exit>
            printf("test2: write %s failed\n", file);
     6d0:	fa040593          	addi	a1,s0,-96
     6d4:	00001517          	auipc	a0,0x1
     6d8:	bc450513          	addi	a0,a0,-1084 # 1298 <statistics+0x216>
     6dc:	00001097          	auipc	ra,0x1
     6e0:	804080e7          	jalr	-2044(ra) # ee0 <printf>
            exit(1);
     6e4:	4505                	li	a0,1
     6e6:	00000097          	auipc	ra,0x0
     6ea:	482080e7          	jalr	1154(ra) # b68 <exit>
      for(int i = 0; i < nf; i++){
     6ee:	893e                	mv	s2,a5
        file[3] = me;
     6f0:	fb3401a3          	sb	s3,-93(s0)
        file[4] = '0' + i;
     6f4:	0309079b          	addiw	a5,s2,48
     6f8:	faf40223          	sb	a5,-92(s0)
        file[5] = '\0';
     6fc:	fa0402a3          	sb	zero,-91(s0)
        int fd = open(file, O_RDWR);
     700:	4589                	li	a1,2
     702:	fa040513          	addi	a0,s0,-96
     706:	00000097          	auipc	ra,0x0
     70a:	4a2080e7          	jalr	1186(ra) # ba8 <open>
     70e:	8a2a                	mv	s4,a0
        if(fd < 0){
     710:	0a054763          	bltz	a0,7be <test2+0x284>
        int xx = (pid << 16) | i;
     714:	012b6bb3          	or	s7,s6,s2
     718:	2b81                	sext.w	s7,s7
          int z = 0;
     71a:	f8042e23          	sw	zero,-100(s0)
          sleep(1);
     71e:	4505                	li	a0,1
     720:	00000097          	auipc	ra,0x0
     724:	4d8080e7          	jalr	1240(ra) # bf8 <sleep>
          int n = read(fd, &z, sizeof(z));
     728:	4611                	li	a2,4
     72a:	f9c40593          	addi	a1,s0,-100
     72e:	8552                	mv	a0,s4
     730:	00000097          	auipc	ra,0x0
     734:	450080e7          	jalr	1104(ra) # b80 <read>
          if(n != sizeof(z)){
     738:	4791                	li	a5,4
     73a:	0af51163          	bne	a0,a5,7dc <test2+0x2a2>
          if(z != xx){
     73e:	f9c42603          	lw	a2,-100(s0)
     742:	0b761e63          	bne	a2,s7,7fe <test2+0x2c4>
          int z = 0;
     746:	f8042e23          	sw	zero,-100(s0)
          sleep(1);
     74a:	4505                	li	a0,1
     74c:	00000097          	auipc	ra,0x0
     750:	4ac080e7          	jalr	1196(ra) # bf8 <sleep>
          int n = read(fd, &z, sizeof(z));
     754:	4611                	li	a2,4
     756:	f9c40593          	addi	a1,s0,-100
     75a:	8552                	mv	a0,s4
     75c:	00000097          	auipc	ra,0x0
     760:	424080e7          	jalr	1060(ra) # b80 <read>
          if(n != sizeof(z)){
     764:	4791                	li	a5,4
     766:	06f51b63          	bne	a0,a5,7dc <test2+0x2a2>
          if(z != xx){
     76a:	f9c42603          	lw	a2,-100(s0)
     76e:	09761863          	bne	a2,s7,7fe <test2+0x2c4>
        close(fd);
     772:	8552                	mv	a0,s4
     774:	00000097          	auipc	ra,0x0
     778:	41c080e7          	jalr	1052(ra) # b90 <close>
      for(int i = 0; i < nf; i++){
     77c:	0019079b          	addiw	a5,s2,1
     780:	f72a97e3          	bne	s5,s2,6ee <test2+0x1b4>
     784:	0304849b          	addiw	s1,s1,48
     788:	0ff4f913          	andi	s2,s1,255
     78c:	03000493          	li	s1,48
        file[3] = me;
     790:	fb3401a3          	sb	s3,-93(s0)
        file[4] = '0' + i;
     794:	fa940223          	sb	s1,-92(s0)
        file[5] = '\0';
     798:	fa0402a3          	sb	zero,-91(s0)
        if(unlink(file) != 0){
     79c:	fa040513          	addi	a0,s0,-96
     7a0:	00000097          	auipc	ra,0x0
     7a4:	418080e7          	jalr	1048(ra) # bb8 <unlink>
     7a8:	e93d                	bnez	a0,81e <test2+0x2e4>
      for(int i = 0; i < nf; i++){
     7aa:	2485                	addiw	s1,s1,1
     7ac:	0ff4f493          	andi	s1,s1,255
     7b0:	ff2490e3          	bne	s1,s2,790 <test2+0x256>
      exit(0);
     7b4:	4501                	li	a0,0
     7b6:	00000097          	auipc	ra,0x0
     7ba:	3b2080e7          	jalr	946(ra) # b68 <exit>
          printf("test2: open %s failed\n", file);
     7be:	fa040593          	addi	a1,s0,-96
     7c2:	00001517          	auipc	a0,0x1
     7c6:	aee50513          	addi	a0,a0,-1298 # 12b0 <statistics+0x22e>
     7ca:	00000097          	auipc	ra,0x0
     7ce:	716080e7          	jalr	1814(ra) # ee0 <printf>
          exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00000097          	auipc	ra,0x0
     7d8:	394080e7          	jalr	916(ra) # b68 <exit>
            printf("test2: read %s returned %d, expected %d\n", file, n, sizeof(z));
     7dc:	4691                	li	a3,4
     7de:	862a                	mv	a2,a0
     7e0:	fa040593          	addi	a1,s0,-96
     7e4:	00001517          	auipc	a0,0x1
     7e8:	ae450513          	addi	a0,a0,-1308 # 12c8 <statistics+0x246>
     7ec:	00000097          	auipc	ra,0x0
     7f0:	6f4080e7          	jalr	1780(ra) # ee0 <printf>
            exit(1);
     7f4:	4505                	li	a0,1
     7f6:	00000097          	auipc	ra,0x0
     7fa:	372080e7          	jalr	882(ra) # b68 <exit>
            printf("test2: file %s contained %d, not %d\n", file, z, xx);
     7fe:	86de                	mv	a3,s7
     800:	fa040593          	addi	a1,s0,-96
     804:	00001517          	auipc	a0,0x1
     808:	af450513          	addi	a0,a0,-1292 # 12f8 <statistics+0x276>
     80c:	00000097          	auipc	ra,0x0
     810:	6d4080e7          	jalr	1748(ra) # ee0 <printf>
            exit(1);
     814:	4505                	li	a0,1
     816:	00000097          	auipc	ra,0x0
     81a:	352080e7          	jalr	850(ra) # b68 <exit>
          printf("test2: unlink %s failed\n", file);
     81e:	fa040593          	addi	a1,s0,-96
     822:	00001517          	auipc	a0,0x1
     826:	afe50513          	addi	a0,a0,-1282 # 1320 <statistics+0x29e>
     82a:	00000097          	auipc	ra,0x0
     82e:	6b6080e7          	jalr	1718(ra) # ee0 <printf>
          exit(1);
     832:	4505                	li	a0,1
     834:	00000097          	auipc	ra,0x0
     838:	334080e7          	jalr	820(ra) # b68 <exit>
      ok = 0;
    }
    if(st != 0)
     83c:	f9c42783          	lw	a5,-100(s0)
      ok = 0;
     840:	0017b793          	seqz	a5,a5
     844:	40f007b3          	neg	a5,a5
     848:	00f97933          	and	s2,s2,a5
  for(int ci = 0; ci < nc; ci++){
     84c:	34fd                	addiw	s1,s1,-1
     84e:	c095                	beqz	s1,872 <test2+0x338>
    int st = 0;
     850:	f8042e23          	sw	zero,-100(s0)
    int ret = wait(&st);
     854:	f9c40513          	addi	a0,s0,-100
     858:	00000097          	auipc	ra,0x0
     85c:	318080e7          	jalr	792(ra) # b70 <wait>
    if(ret <= 0){
     860:	fca04ee3          	bgtz	a0,83c <test2+0x302>
      printf("test2: wait() failed\n");
     864:	854e                	mv	a0,s3
     866:	00000097          	auipc	ra,0x0
     86a:	67a080e7          	jalr	1658(ra) # ee0 <printf>
      ok = 0;
     86e:	4901                	li	s2,0
     870:	b7f1                	j	83c <test2+0x302>
  }
  
  if(ok){
     872:	02090563          	beqz	s2,89c <test2+0x362>
    printf("test2 OK\n");
     876:	00001517          	auipc	a0,0x1
     87a:	ae250513          	addi	a0,a0,-1310 # 1358 <statistics+0x2d6>
     87e:	00000097          	auipc	ra,0x0
     882:	662080e7          	jalr	1634(ra) # ee0 <printf>
  } else {
    printf("test2 failed\n");
  }
}
     886:	70a6                	ld	ra,104(sp)
     888:	7406                	ld	s0,96(sp)
     88a:	64e6                	ld	s1,88(sp)
     88c:	6946                	ld	s2,80(sp)
     88e:	69a6                	ld	s3,72(sp)
     890:	6a06                	ld	s4,64(sp)
     892:	7ae2                	ld	s5,56(sp)
     894:	7b42                	ld	s6,48(sp)
     896:	7ba2                	ld	s7,40(sp)
     898:	6165                	addi	sp,sp,112
     89a:	8082                	ret
    printf("test2 failed\n");
     89c:	00001517          	auipc	a0,0x1
     8a0:	acc50513          	addi	a0,a0,-1332 # 1368 <statistics+0x2e6>
     8a4:	00000097          	auipc	ra,0x0
     8a8:	63c080e7          	jalr	1596(ra) # ee0 <printf>
}
     8ac:	bfe9                	j	886 <test2+0x34c>

00000000000008ae <main>:
{
     8ae:	1141                	addi	sp,sp,-16
     8b0:	e406                	sd	ra,8(sp)
     8b2:	e022                	sd	s0,0(sp)
     8b4:	0800                	addi	s0,sp,16
  test0();
     8b6:	00000097          	auipc	ra,0x0
     8ba:	970080e7          	jalr	-1680(ra) # 226 <test0>
  test1();
     8be:	00000097          	auipc	ra,0x0
     8c2:	b36080e7          	jalr	-1226(ra) # 3f4 <test1>
  test2();
     8c6:	00000097          	auipc	ra,0x0
     8ca:	c74080e7          	jalr	-908(ra) # 53a <test2>
  exit(0);
     8ce:	4501                	li	a0,0
     8d0:	00000097          	auipc	ra,0x0
     8d4:	298080e7          	jalr	664(ra) # b68 <exit>

00000000000008d8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     8d8:	1141                	addi	sp,sp,-16
     8da:	e406                	sd	ra,8(sp)
     8dc:	e022                	sd	s0,0(sp)
     8de:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8e0:	00000097          	auipc	ra,0x0
     8e4:	fce080e7          	jalr	-50(ra) # 8ae <main>
  exit(0);
     8e8:	4501                	li	a0,0
     8ea:	00000097          	auipc	ra,0x0
     8ee:	27e080e7          	jalr	638(ra) # b68 <exit>

00000000000008f2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f2:	1141                	addi	sp,sp,-16
     8f4:	e422                	sd	s0,8(sp)
     8f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8f8:	87aa                	mv	a5,a0
     8fa:	0585                	addi	a1,a1,1
     8fc:	0785                	addi	a5,a5,1
     8fe:	fff5c703          	lbu	a4,-1(a1) # 18fff <base+0x15fef>
     902:	fee78fa3          	sb	a4,-1(a5)
     906:	fb75                	bnez	a4,8fa <strcpy+0x8>
    ;
  return os;
}
     908:	6422                	ld	s0,8(sp)
     90a:	0141                	addi	sp,sp,16
     90c:	8082                	ret

000000000000090e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     90e:	1141                	addi	sp,sp,-16
     910:	e422                	sd	s0,8(sp)
     912:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     914:	00054783          	lbu	a5,0(a0)
     918:	cb91                	beqz	a5,92c <strcmp+0x1e>
     91a:	0005c703          	lbu	a4,0(a1)
     91e:	00f71763          	bne	a4,a5,92c <strcmp+0x1e>
    p++, q++;
     922:	0505                	addi	a0,a0,1
     924:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     926:	00054783          	lbu	a5,0(a0)
     92a:	fbe5                	bnez	a5,91a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     92c:	0005c503          	lbu	a0,0(a1)
}
     930:	40a7853b          	subw	a0,a5,a0
     934:	6422                	ld	s0,8(sp)
     936:	0141                	addi	sp,sp,16
     938:	8082                	ret

000000000000093a <strlen>:

uint
strlen(const char *s)
{
     93a:	1141                	addi	sp,sp,-16
     93c:	e422                	sd	s0,8(sp)
     93e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     940:	00054783          	lbu	a5,0(a0)
     944:	cf91                	beqz	a5,960 <strlen+0x26>
     946:	0505                	addi	a0,a0,1
     948:	87aa                	mv	a5,a0
     94a:	4685                	li	a3,1
     94c:	9e89                	subw	a3,a3,a0
     94e:	00f6853b          	addw	a0,a3,a5
     952:	0785                	addi	a5,a5,1
     954:	fff7c703          	lbu	a4,-1(a5)
     958:	fb7d                	bnez	a4,94e <strlen+0x14>
    ;
  return n;
}
     95a:	6422                	ld	s0,8(sp)
     95c:	0141                	addi	sp,sp,16
     95e:	8082                	ret
  for(n = 0; s[n]; n++)
     960:	4501                	li	a0,0
     962:	bfe5                	j	95a <strlen+0x20>

0000000000000964 <memset>:

void*
memset(void *dst, int c, uint n)
{
     964:	1141                	addi	sp,sp,-16
     966:	e422                	sd	s0,8(sp)
     968:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     96a:	ce09                	beqz	a2,984 <memset+0x20>
     96c:	87aa                	mv	a5,a0
     96e:	fff6071b          	addiw	a4,a2,-1
     972:	1702                	slli	a4,a4,0x20
     974:	9301                	srli	a4,a4,0x20
     976:	0705                	addi	a4,a4,1
     978:	972a                	add	a4,a4,a0
    cdst[i] = c;
     97a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     97e:	0785                	addi	a5,a5,1
     980:	fee79de3          	bne	a5,a4,97a <memset+0x16>
  }
  return dst;
}
     984:	6422                	ld	s0,8(sp)
     986:	0141                	addi	sp,sp,16
     988:	8082                	ret

000000000000098a <strchr>:

char*
strchr(const char *s, char c)
{
     98a:	1141                	addi	sp,sp,-16
     98c:	e422                	sd	s0,8(sp)
     98e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     990:	00054783          	lbu	a5,0(a0)
     994:	cb99                	beqz	a5,9aa <strchr+0x20>
    if(*s == c)
     996:	00f58763          	beq	a1,a5,9a4 <strchr+0x1a>
  for(; *s; s++)
     99a:	0505                	addi	a0,a0,1
     99c:	00054783          	lbu	a5,0(a0)
     9a0:	fbfd                	bnez	a5,996 <strchr+0xc>
      return (char*)s;
  return 0;
     9a2:	4501                	li	a0,0
}
     9a4:	6422                	ld	s0,8(sp)
     9a6:	0141                	addi	sp,sp,16
     9a8:	8082                	ret
  return 0;
     9aa:	4501                	li	a0,0
     9ac:	bfe5                	j	9a4 <strchr+0x1a>

00000000000009ae <gets>:

char*
gets(char *buf, int max)
{
     9ae:	711d                	addi	sp,sp,-96
     9b0:	ec86                	sd	ra,88(sp)
     9b2:	e8a2                	sd	s0,80(sp)
     9b4:	e4a6                	sd	s1,72(sp)
     9b6:	e0ca                	sd	s2,64(sp)
     9b8:	fc4e                	sd	s3,56(sp)
     9ba:	f852                	sd	s4,48(sp)
     9bc:	f456                	sd	s5,40(sp)
     9be:	f05a                	sd	s6,32(sp)
     9c0:	ec5e                	sd	s7,24(sp)
     9c2:	1080                	addi	s0,sp,96
     9c4:	8baa                	mv	s7,a0
     9c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9c8:	892a                	mv	s2,a0
     9ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9cc:	4aa9                	li	s5,10
     9ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9d0:	89a6                	mv	s3,s1
     9d2:	2485                	addiw	s1,s1,1
     9d4:	0344d863          	bge	s1,s4,a04 <gets+0x56>
    cc = read(0, &c, 1);
     9d8:	4605                	li	a2,1
     9da:	faf40593          	addi	a1,s0,-81
     9de:	4501                	li	a0,0
     9e0:	00000097          	auipc	ra,0x0
     9e4:	1a0080e7          	jalr	416(ra) # b80 <read>
    if(cc < 1)
     9e8:	00a05e63          	blez	a0,a04 <gets+0x56>
    buf[i++] = c;
     9ec:	faf44783          	lbu	a5,-81(s0)
     9f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9f4:	01578763          	beq	a5,s5,a02 <gets+0x54>
     9f8:	0905                	addi	s2,s2,1
     9fa:	fd679be3          	bne	a5,s6,9d0 <gets+0x22>
  for(i=0; i+1 < max; ){
     9fe:	89a6                	mv	s3,s1
     a00:	a011                	j	a04 <gets+0x56>
     a02:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a04:	99de                	add	s3,s3,s7
     a06:	00098023          	sb	zero,0(s3)
  return buf;
}
     a0a:	855e                	mv	a0,s7
     a0c:	60e6                	ld	ra,88(sp)
     a0e:	6446                	ld	s0,80(sp)
     a10:	64a6                	ld	s1,72(sp)
     a12:	6906                	ld	s2,64(sp)
     a14:	79e2                	ld	s3,56(sp)
     a16:	7a42                	ld	s4,48(sp)
     a18:	7aa2                	ld	s5,40(sp)
     a1a:	7b02                	ld	s6,32(sp)
     a1c:	6be2                	ld	s7,24(sp)
     a1e:	6125                	addi	sp,sp,96
     a20:	8082                	ret

0000000000000a22 <stat>:

int
stat(const char *n, struct stat *st)
{
     a22:	1101                	addi	sp,sp,-32
     a24:	ec06                	sd	ra,24(sp)
     a26:	e822                	sd	s0,16(sp)
     a28:	e426                	sd	s1,8(sp)
     a2a:	e04a                	sd	s2,0(sp)
     a2c:	1000                	addi	s0,sp,32
     a2e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a30:	4581                	li	a1,0
     a32:	00000097          	auipc	ra,0x0
     a36:	176080e7          	jalr	374(ra) # ba8 <open>
  if(fd < 0)
     a3a:	02054563          	bltz	a0,a64 <stat+0x42>
     a3e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a40:	85ca                	mv	a1,s2
     a42:	00000097          	auipc	ra,0x0
     a46:	17e080e7          	jalr	382(ra) # bc0 <fstat>
     a4a:	892a                	mv	s2,a0
  close(fd);
     a4c:	8526                	mv	a0,s1
     a4e:	00000097          	auipc	ra,0x0
     a52:	142080e7          	jalr	322(ra) # b90 <close>
  return r;
}
     a56:	854a                	mv	a0,s2
     a58:	60e2                	ld	ra,24(sp)
     a5a:	6442                	ld	s0,16(sp)
     a5c:	64a2                	ld	s1,8(sp)
     a5e:	6902                	ld	s2,0(sp)
     a60:	6105                	addi	sp,sp,32
     a62:	8082                	ret
    return -1;
     a64:	597d                	li	s2,-1
     a66:	bfc5                	j	a56 <stat+0x34>

0000000000000a68 <atoi>:

int
atoi(const char *s)
{
     a68:	1141                	addi	sp,sp,-16
     a6a:	e422                	sd	s0,8(sp)
     a6c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a6e:	00054603          	lbu	a2,0(a0)
     a72:	fd06079b          	addiw	a5,a2,-48
     a76:	0ff7f793          	andi	a5,a5,255
     a7a:	4725                	li	a4,9
     a7c:	02f76963          	bltu	a4,a5,aae <atoi+0x46>
     a80:	86aa                	mv	a3,a0
  n = 0;
     a82:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     a84:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     a86:	0685                	addi	a3,a3,1
     a88:	0025179b          	slliw	a5,a0,0x2
     a8c:	9fa9                	addw	a5,a5,a0
     a8e:	0017979b          	slliw	a5,a5,0x1
     a92:	9fb1                	addw	a5,a5,a2
     a94:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a98:	0006c603          	lbu	a2,0(a3)
     a9c:	fd06071b          	addiw	a4,a2,-48
     aa0:	0ff77713          	andi	a4,a4,255
     aa4:	fee5f1e3          	bgeu	a1,a4,a86 <atoi+0x1e>
  return n;
}
     aa8:	6422                	ld	s0,8(sp)
     aaa:	0141                	addi	sp,sp,16
     aac:	8082                	ret
  n = 0;
     aae:	4501                	li	a0,0
     ab0:	bfe5                	j	aa8 <atoi+0x40>

0000000000000ab2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ab2:	1141                	addi	sp,sp,-16
     ab4:	e422                	sd	s0,8(sp)
     ab6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ab8:	02b57663          	bgeu	a0,a1,ae4 <memmove+0x32>
    while(n-- > 0)
     abc:	02c05163          	blez	a2,ade <memmove+0x2c>
     ac0:	fff6079b          	addiw	a5,a2,-1
     ac4:	1782                	slli	a5,a5,0x20
     ac6:	9381                	srli	a5,a5,0x20
     ac8:	0785                	addi	a5,a5,1
     aca:	97aa                	add	a5,a5,a0
  dst = vdst;
     acc:	872a                	mv	a4,a0
      *dst++ = *src++;
     ace:	0585                	addi	a1,a1,1
     ad0:	0705                	addi	a4,a4,1
     ad2:	fff5c683          	lbu	a3,-1(a1)
     ad6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ada:	fee79ae3          	bne	a5,a4,ace <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ade:	6422                	ld	s0,8(sp)
     ae0:	0141                	addi	sp,sp,16
     ae2:	8082                	ret
    dst += n;
     ae4:	00c50733          	add	a4,a0,a2
    src += n;
     ae8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     aea:	fec05ae3          	blez	a2,ade <memmove+0x2c>
     aee:	fff6079b          	addiw	a5,a2,-1
     af2:	1782                	slli	a5,a5,0x20
     af4:	9381                	srli	a5,a5,0x20
     af6:	fff7c793          	not	a5,a5
     afa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     afc:	15fd                	addi	a1,a1,-1
     afe:	177d                	addi	a4,a4,-1
     b00:	0005c683          	lbu	a3,0(a1)
     b04:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b08:	fee79ae3          	bne	a5,a4,afc <memmove+0x4a>
     b0c:	bfc9                	j	ade <memmove+0x2c>

0000000000000b0e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b0e:	1141                	addi	sp,sp,-16
     b10:	e422                	sd	s0,8(sp)
     b12:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b14:	ca05                	beqz	a2,b44 <memcmp+0x36>
     b16:	fff6069b          	addiw	a3,a2,-1
     b1a:	1682                	slli	a3,a3,0x20
     b1c:	9281                	srli	a3,a3,0x20
     b1e:	0685                	addi	a3,a3,1
     b20:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b22:	00054783          	lbu	a5,0(a0)
     b26:	0005c703          	lbu	a4,0(a1)
     b2a:	00e79863          	bne	a5,a4,b3a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b2e:	0505                	addi	a0,a0,1
    p2++;
     b30:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b32:	fed518e3          	bne	a0,a3,b22 <memcmp+0x14>
  }
  return 0;
     b36:	4501                	li	a0,0
     b38:	a019                	j	b3e <memcmp+0x30>
      return *p1 - *p2;
     b3a:	40e7853b          	subw	a0,a5,a4
}
     b3e:	6422                	ld	s0,8(sp)
     b40:	0141                	addi	sp,sp,16
     b42:	8082                	ret
  return 0;
     b44:	4501                	li	a0,0
     b46:	bfe5                	j	b3e <memcmp+0x30>

0000000000000b48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b48:	1141                	addi	sp,sp,-16
     b4a:	e406                	sd	ra,8(sp)
     b4c:	e022                	sd	s0,0(sp)
     b4e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b50:	00000097          	auipc	ra,0x0
     b54:	f62080e7          	jalr	-158(ra) # ab2 <memmove>
}
     b58:	60a2                	ld	ra,8(sp)
     b5a:	6402                	ld	s0,0(sp)
     b5c:	0141                	addi	sp,sp,16
     b5e:	8082                	ret

0000000000000b60 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b60:	4885                	li	a7,1
 ecall
     b62:	00000073          	ecall
 ret
     b66:	8082                	ret

0000000000000b68 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b68:	4889                	li	a7,2
 ecall
     b6a:	00000073          	ecall
 ret
     b6e:	8082                	ret

0000000000000b70 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b70:	488d                	li	a7,3
 ecall
     b72:	00000073          	ecall
 ret
     b76:	8082                	ret

0000000000000b78 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b78:	4891                	li	a7,4
 ecall
     b7a:	00000073          	ecall
 ret
     b7e:	8082                	ret

0000000000000b80 <read>:
.global read
read:
 li a7, SYS_read
     b80:	4895                	li	a7,5
 ecall
     b82:	00000073          	ecall
 ret
     b86:	8082                	ret

0000000000000b88 <write>:
.global write
write:
 li a7, SYS_write
     b88:	48c1                	li	a7,16
 ecall
     b8a:	00000073          	ecall
 ret
     b8e:	8082                	ret

0000000000000b90 <close>:
.global close
close:
 li a7, SYS_close
     b90:	48d5                	li	a7,21
 ecall
     b92:	00000073          	ecall
 ret
     b96:	8082                	ret

0000000000000b98 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b98:	4899                	li	a7,6
 ecall
     b9a:	00000073          	ecall
 ret
     b9e:	8082                	ret

0000000000000ba0 <exec>:
.global exec
exec:
 li a7, SYS_exec
     ba0:	489d                	li	a7,7
 ecall
     ba2:	00000073          	ecall
 ret
     ba6:	8082                	ret

0000000000000ba8 <open>:
.global open
open:
 li a7, SYS_open
     ba8:	48bd                	li	a7,15
 ecall
     baa:	00000073          	ecall
 ret
     bae:	8082                	ret

0000000000000bb0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bb0:	48c5                	li	a7,17
 ecall
     bb2:	00000073          	ecall
 ret
     bb6:	8082                	ret

0000000000000bb8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bb8:	48c9                	li	a7,18
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bc0:	48a1                	li	a7,8
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <link>:
.global link
link:
 li a7, SYS_link
     bc8:	48cd                	li	a7,19
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bd0:	48d1                	li	a7,20
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bd8:	48a5                	li	a7,9
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     be0:	48a9                	li	a7,10
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     be8:	48ad                	li	a7,11
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bf0:	48b1                	li	a7,12
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bf8:	48b5                	li	a7,13
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c00:	48b9                	li	a7,14
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c08:	1101                	addi	sp,sp,-32
     c0a:	ec06                	sd	ra,24(sp)
     c0c:	e822                	sd	s0,16(sp)
     c0e:	1000                	addi	s0,sp,32
     c10:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c14:	4605                	li	a2,1
     c16:	fef40593          	addi	a1,s0,-17
     c1a:	00000097          	auipc	ra,0x0
     c1e:	f6e080e7          	jalr	-146(ra) # b88 <write>
}
     c22:	60e2                	ld	ra,24(sp)
     c24:	6442                	ld	s0,16(sp)
     c26:	6105                	addi	sp,sp,32
     c28:	8082                	ret

0000000000000c2a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c2a:	7139                	addi	sp,sp,-64
     c2c:	fc06                	sd	ra,56(sp)
     c2e:	f822                	sd	s0,48(sp)
     c30:	f426                	sd	s1,40(sp)
     c32:	f04a                	sd	s2,32(sp)
     c34:	ec4e                	sd	s3,24(sp)
     c36:	0080                	addi	s0,sp,64
     c38:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c3a:	c299                	beqz	a3,c40 <printint+0x16>
     c3c:	0805c863          	bltz	a1,ccc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c40:	2581                	sext.w	a1,a1
  neg = 0;
     c42:	4881                	li	a7,0
     c44:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c48:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c4a:	2601                	sext.w	a2,a2
     c4c:	00000517          	auipc	a0,0x0
     c50:	74c50513          	addi	a0,a0,1868 # 1398 <digits>
     c54:	883a                	mv	a6,a4
     c56:	2705                	addiw	a4,a4,1
     c58:	02c5f7bb          	remuw	a5,a1,a2
     c5c:	1782                	slli	a5,a5,0x20
     c5e:	9381                	srli	a5,a5,0x20
     c60:	97aa                	add	a5,a5,a0
     c62:	0007c783          	lbu	a5,0(a5)
     c66:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c6a:	0005879b          	sext.w	a5,a1
     c6e:	02c5d5bb          	divuw	a1,a1,a2
     c72:	0685                	addi	a3,a3,1
     c74:	fec7f0e3          	bgeu	a5,a2,c54 <printint+0x2a>
  if(neg)
     c78:	00088b63          	beqz	a7,c8e <printint+0x64>
    buf[i++] = '-';
     c7c:	fd040793          	addi	a5,s0,-48
     c80:	973e                	add	a4,a4,a5
     c82:	02d00793          	li	a5,45
     c86:	fef70823          	sb	a5,-16(a4)
     c8a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c8e:	02e05863          	blez	a4,cbe <printint+0x94>
     c92:	fc040793          	addi	a5,s0,-64
     c96:	00e78933          	add	s2,a5,a4
     c9a:	fff78993          	addi	s3,a5,-1
     c9e:	99ba                	add	s3,s3,a4
     ca0:	377d                	addiw	a4,a4,-1
     ca2:	1702                	slli	a4,a4,0x20
     ca4:	9301                	srli	a4,a4,0x20
     ca6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     caa:	fff94583          	lbu	a1,-1(s2)
     cae:	8526                	mv	a0,s1
     cb0:	00000097          	auipc	ra,0x0
     cb4:	f58080e7          	jalr	-168(ra) # c08 <putc>
  while(--i >= 0)
     cb8:	197d                	addi	s2,s2,-1
     cba:	ff3918e3          	bne	s2,s3,caa <printint+0x80>
}
     cbe:	70e2                	ld	ra,56(sp)
     cc0:	7442                	ld	s0,48(sp)
     cc2:	74a2                	ld	s1,40(sp)
     cc4:	7902                	ld	s2,32(sp)
     cc6:	69e2                	ld	s3,24(sp)
     cc8:	6121                	addi	sp,sp,64
     cca:	8082                	ret
    x = -xx;
     ccc:	40b005bb          	negw	a1,a1
    neg = 1;
     cd0:	4885                	li	a7,1
    x = -xx;
     cd2:	bf8d                	j	c44 <printint+0x1a>

0000000000000cd4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cd4:	7119                	addi	sp,sp,-128
     cd6:	fc86                	sd	ra,120(sp)
     cd8:	f8a2                	sd	s0,112(sp)
     cda:	f4a6                	sd	s1,104(sp)
     cdc:	f0ca                	sd	s2,96(sp)
     cde:	ecce                	sd	s3,88(sp)
     ce0:	e8d2                	sd	s4,80(sp)
     ce2:	e4d6                	sd	s5,72(sp)
     ce4:	e0da                	sd	s6,64(sp)
     ce6:	fc5e                	sd	s7,56(sp)
     ce8:	f862                	sd	s8,48(sp)
     cea:	f466                	sd	s9,40(sp)
     cec:	f06a                	sd	s10,32(sp)
     cee:	ec6e                	sd	s11,24(sp)
     cf0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cf2:	0005c903          	lbu	s2,0(a1)
     cf6:	18090f63          	beqz	s2,e94 <vprintf+0x1c0>
     cfa:	8aaa                	mv	s5,a0
     cfc:	8b32                	mv	s6,a2
     cfe:	00158493          	addi	s1,a1,1
  state = 0;
     d02:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d04:	02500a13          	li	s4,37
      if(c == 'd'){
     d08:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     d0c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     d10:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     d14:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d18:	00000b97          	auipc	s7,0x0
     d1c:	680b8b93          	addi	s7,s7,1664 # 1398 <digits>
     d20:	a839                	j	d3e <vprintf+0x6a>
        putc(fd, c);
     d22:	85ca                	mv	a1,s2
     d24:	8556                	mv	a0,s5
     d26:	00000097          	auipc	ra,0x0
     d2a:	ee2080e7          	jalr	-286(ra) # c08 <putc>
     d2e:	a019                	j	d34 <vprintf+0x60>
    } else if(state == '%'){
     d30:	01498f63          	beq	s3,s4,d4e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d34:	0485                	addi	s1,s1,1
     d36:	fff4c903          	lbu	s2,-1(s1)
     d3a:	14090d63          	beqz	s2,e94 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     d3e:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d42:	fe0997e3          	bnez	s3,d30 <vprintf+0x5c>
      if(c == '%'){
     d46:	fd479ee3          	bne	a5,s4,d22 <vprintf+0x4e>
        state = '%';
     d4a:	89be                	mv	s3,a5
     d4c:	b7e5                	j	d34 <vprintf+0x60>
      if(c == 'd'){
     d4e:	05878063          	beq	a5,s8,d8e <vprintf+0xba>
      } else if(c == 'l') {
     d52:	05978c63          	beq	a5,s9,daa <vprintf+0xd6>
      } else if(c == 'x') {
     d56:	07a78863          	beq	a5,s10,dc6 <vprintf+0xf2>
      } else if(c == 'p') {
     d5a:	09b78463          	beq	a5,s11,de2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     d5e:	07300713          	li	a4,115
     d62:	0ce78663          	beq	a5,a4,e2e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     d66:	06300713          	li	a4,99
     d6a:	0ee78e63          	beq	a5,a4,e66 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     d6e:	11478863          	beq	a5,s4,e7e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     d72:	85d2                	mv	a1,s4
     d74:	8556                	mv	a0,s5
     d76:	00000097          	auipc	ra,0x0
     d7a:	e92080e7          	jalr	-366(ra) # c08 <putc>
        putc(fd, c);
     d7e:	85ca                	mv	a1,s2
     d80:	8556                	mv	a0,s5
     d82:	00000097          	auipc	ra,0x0
     d86:	e86080e7          	jalr	-378(ra) # c08 <putc>
      }
      state = 0;
     d8a:	4981                	li	s3,0
     d8c:	b765                	j	d34 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     d8e:	008b0913          	addi	s2,s6,8
     d92:	4685                	li	a3,1
     d94:	4629                	li	a2,10
     d96:	000b2583          	lw	a1,0(s6)
     d9a:	8556                	mv	a0,s5
     d9c:	00000097          	auipc	ra,0x0
     da0:	e8e080e7          	jalr	-370(ra) # c2a <printint>
     da4:	8b4a                	mv	s6,s2
      state = 0;
     da6:	4981                	li	s3,0
     da8:	b771                	j	d34 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     daa:	008b0913          	addi	s2,s6,8
     dae:	4681                	li	a3,0
     db0:	4629                	li	a2,10
     db2:	000b2583          	lw	a1,0(s6)
     db6:	8556                	mv	a0,s5
     db8:	00000097          	auipc	ra,0x0
     dbc:	e72080e7          	jalr	-398(ra) # c2a <printint>
     dc0:	8b4a                	mv	s6,s2
      state = 0;
     dc2:	4981                	li	s3,0
     dc4:	bf85                	j	d34 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     dc6:	008b0913          	addi	s2,s6,8
     dca:	4681                	li	a3,0
     dcc:	4641                	li	a2,16
     dce:	000b2583          	lw	a1,0(s6)
     dd2:	8556                	mv	a0,s5
     dd4:	00000097          	auipc	ra,0x0
     dd8:	e56080e7          	jalr	-426(ra) # c2a <printint>
     ddc:	8b4a                	mv	s6,s2
      state = 0;
     dde:	4981                	li	s3,0
     de0:	bf91                	j	d34 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     de2:	008b0793          	addi	a5,s6,8
     de6:	f8f43423          	sd	a5,-120(s0)
     dea:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     dee:	03000593          	li	a1,48
     df2:	8556                	mv	a0,s5
     df4:	00000097          	auipc	ra,0x0
     df8:	e14080e7          	jalr	-492(ra) # c08 <putc>
  putc(fd, 'x');
     dfc:	85ea                	mv	a1,s10
     dfe:	8556                	mv	a0,s5
     e00:	00000097          	auipc	ra,0x0
     e04:	e08080e7          	jalr	-504(ra) # c08 <putc>
     e08:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e0a:	03c9d793          	srli	a5,s3,0x3c
     e0e:	97de                	add	a5,a5,s7
     e10:	0007c583          	lbu	a1,0(a5)
     e14:	8556                	mv	a0,s5
     e16:	00000097          	auipc	ra,0x0
     e1a:	df2080e7          	jalr	-526(ra) # c08 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e1e:	0992                	slli	s3,s3,0x4
     e20:	397d                	addiw	s2,s2,-1
     e22:	fe0914e3          	bnez	s2,e0a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     e26:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e2a:	4981                	li	s3,0
     e2c:	b721                	j	d34 <vprintf+0x60>
        s = va_arg(ap, char*);
     e2e:	008b0993          	addi	s3,s6,8
     e32:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     e36:	02090163          	beqz	s2,e58 <vprintf+0x184>
        while(*s != 0){
     e3a:	00094583          	lbu	a1,0(s2)
     e3e:	c9a1                	beqz	a1,e8e <vprintf+0x1ba>
          putc(fd, *s);
     e40:	8556                	mv	a0,s5
     e42:	00000097          	auipc	ra,0x0
     e46:	dc6080e7          	jalr	-570(ra) # c08 <putc>
          s++;
     e4a:	0905                	addi	s2,s2,1
        while(*s != 0){
     e4c:	00094583          	lbu	a1,0(s2)
     e50:	f9e5                	bnez	a1,e40 <vprintf+0x16c>
        s = va_arg(ap, char*);
     e52:	8b4e                	mv	s6,s3
      state = 0;
     e54:	4981                	li	s3,0
     e56:	bdf9                	j	d34 <vprintf+0x60>
          s = "(null)";
     e58:	00000917          	auipc	s2,0x0
     e5c:	53890913          	addi	s2,s2,1336 # 1390 <statistics+0x30e>
        while(*s != 0){
     e60:	02800593          	li	a1,40
     e64:	bff1                	j	e40 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     e66:	008b0913          	addi	s2,s6,8
     e6a:	000b4583          	lbu	a1,0(s6)
     e6e:	8556                	mv	a0,s5
     e70:	00000097          	auipc	ra,0x0
     e74:	d98080e7          	jalr	-616(ra) # c08 <putc>
     e78:	8b4a                	mv	s6,s2
      state = 0;
     e7a:	4981                	li	s3,0
     e7c:	bd65                	j	d34 <vprintf+0x60>
        putc(fd, c);
     e7e:	85d2                	mv	a1,s4
     e80:	8556                	mv	a0,s5
     e82:	00000097          	auipc	ra,0x0
     e86:	d86080e7          	jalr	-634(ra) # c08 <putc>
      state = 0;
     e8a:	4981                	li	s3,0
     e8c:	b565                	j	d34 <vprintf+0x60>
        s = va_arg(ap, char*);
     e8e:	8b4e                	mv	s6,s3
      state = 0;
     e90:	4981                	li	s3,0
     e92:	b54d                	j	d34 <vprintf+0x60>
    }
  }
}
     e94:	70e6                	ld	ra,120(sp)
     e96:	7446                	ld	s0,112(sp)
     e98:	74a6                	ld	s1,104(sp)
     e9a:	7906                	ld	s2,96(sp)
     e9c:	69e6                	ld	s3,88(sp)
     e9e:	6a46                	ld	s4,80(sp)
     ea0:	6aa6                	ld	s5,72(sp)
     ea2:	6b06                	ld	s6,64(sp)
     ea4:	7be2                	ld	s7,56(sp)
     ea6:	7c42                	ld	s8,48(sp)
     ea8:	7ca2                	ld	s9,40(sp)
     eaa:	7d02                	ld	s10,32(sp)
     eac:	6de2                	ld	s11,24(sp)
     eae:	6109                	addi	sp,sp,128
     eb0:	8082                	ret

0000000000000eb2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eb2:	715d                	addi	sp,sp,-80
     eb4:	ec06                	sd	ra,24(sp)
     eb6:	e822                	sd	s0,16(sp)
     eb8:	1000                	addi	s0,sp,32
     eba:	e010                	sd	a2,0(s0)
     ebc:	e414                	sd	a3,8(s0)
     ebe:	e818                	sd	a4,16(s0)
     ec0:	ec1c                	sd	a5,24(s0)
     ec2:	03043023          	sd	a6,32(s0)
     ec6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     eca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ece:	8622                	mv	a2,s0
     ed0:	00000097          	auipc	ra,0x0
     ed4:	e04080e7          	jalr	-508(ra) # cd4 <vprintf>
}
     ed8:	60e2                	ld	ra,24(sp)
     eda:	6442                	ld	s0,16(sp)
     edc:	6161                	addi	sp,sp,80
     ede:	8082                	ret

0000000000000ee0 <printf>:

void
printf(const char *fmt, ...)
{
     ee0:	711d                	addi	sp,sp,-96
     ee2:	ec06                	sd	ra,24(sp)
     ee4:	e822                	sd	s0,16(sp)
     ee6:	1000                	addi	s0,sp,32
     ee8:	e40c                	sd	a1,8(s0)
     eea:	e810                	sd	a2,16(s0)
     eec:	ec14                	sd	a3,24(s0)
     eee:	f018                	sd	a4,32(s0)
     ef0:	f41c                	sd	a5,40(s0)
     ef2:	03043823          	sd	a6,48(s0)
     ef6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     efa:	00840613          	addi	a2,s0,8
     efe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f02:	85aa                	mv	a1,a0
     f04:	4505                	li	a0,1
     f06:	00000097          	auipc	ra,0x0
     f0a:	dce080e7          	jalr	-562(ra) # cd4 <vprintf>
}
     f0e:	60e2                	ld	ra,24(sp)
     f10:	6442                	ld	s0,16(sp)
     f12:	6125                	addi	sp,sp,96
     f14:	8082                	ret

0000000000000f16 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f16:	1141                	addi	sp,sp,-16
     f18:	e422                	sd	s0,8(sp)
     f1a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f1c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f20:	00001797          	auipc	a5,0x1
     f24:	0e07b783          	ld	a5,224(a5) # 2000 <freep>
     f28:	a805                	j	f58 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f2a:	4618                	lw	a4,8(a2)
     f2c:	9db9                	addw	a1,a1,a4
     f2e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f32:	6398                	ld	a4,0(a5)
     f34:	6318                	ld	a4,0(a4)
     f36:	fee53823          	sd	a4,-16(a0)
     f3a:	a091                	j	f7e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f3c:	ff852703          	lw	a4,-8(a0)
     f40:	9e39                	addw	a2,a2,a4
     f42:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
     f44:	ff053703          	ld	a4,-16(a0)
     f48:	e398                	sd	a4,0(a5)
     f4a:	a099                	j	f90 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f4c:	6398                	ld	a4,0(a5)
     f4e:	00e7e463          	bltu	a5,a4,f56 <free+0x40>
     f52:	00e6ea63          	bltu	a3,a4,f66 <free+0x50>
{
     f56:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f58:	fed7fae3          	bgeu	a5,a3,f4c <free+0x36>
     f5c:	6398                	ld	a4,0(a5)
     f5e:	00e6e463          	bltu	a3,a4,f66 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f62:	fee7eae3          	bltu	a5,a4,f56 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
     f66:	ff852583          	lw	a1,-8(a0)
     f6a:	6390                	ld	a2,0(a5)
     f6c:	02059713          	slli	a4,a1,0x20
     f70:	9301                	srli	a4,a4,0x20
     f72:	0712                	slli	a4,a4,0x4
     f74:	9736                	add	a4,a4,a3
     f76:	fae60ae3          	beq	a2,a4,f2a <free+0x14>
    bp->s.ptr = p->s.ptr;
     f7a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f7e:	4790                	lw	a2,8(a5)
     f80:	02061713          	slli	a4,a2,0x20
     f84:	9301                	srli	a4,a4,0x20
     f86:	0712                	slli	a4,a4,0x4
     f88:	973e                	add	a4,a4,a5
     f8a:	fae689e3          	beq	a3,a4,f3c <free+0x26>
  } else
    p->s.ptr = bp;
     f8e:	e394                	sd	a3,0(a5)
  freep = p;
     f90:	00001717          	auipc	a4,0x1
     f94:	06f73823          	sd	a5,112(a4) # 2000 <freep>
}
     f98:	6422                	ld	s0,8(sp)
     f9a:	0141                	addi	sp,sp,16
     f9c:	8082                	ret

0000000000000f9e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f9e:	7139                	addi	sp,sp,-64
     fa0:	fc06                	sd	ra,56(sp)
     fa2:	f822                	sd	s0,48(sp)
     fa4:	f426                	sd	s1,40(sp)
     fa6:	f04a                	sd	s2,32(sp)
     fa8:	ec4e                	sd	s3,24(sp)
     faa:	e852                	sd	s4,16(sp)
     fac:	e456                	sd	s5,8(sp)
     fae:	e05a                	sd	s6,0(sp)
     fb0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fb2:	02051493          	slli	s1,a0,0x20
     fb6:	9081                	srli	s1,s1,0x20
     fb8:	04bd                	addi	s1,s1,15
     fba:	8091                	srli	s1,s1,0x4
     fbc:	0014899b          	addiw	s3,s1,1
     fc0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     fc2:	00001517          	auipc	a0,0x1
     fc6:	03e53503          	ld	a0,62(a0) # 2000 <freep>
     fca:	c515                	beqz	a0,ff6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fcc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fce:	4798                	lw	a4,8(a5)
     fd0:	02977f63          	bgeu	a4,s1,100e <malloc+0x70>
     fd4:	8a4e                	mv	s4,s3
     fd6:	0009871b          	sext.w	a4,s3
     fda:	6685                	lui	a3,0x1
     fdc:	00d77363          	bgeu	a4,a3,fe2 <malloc+0x44>
     fe0:	6a05                	lui	s4,0x1
     fe2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     fe6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fea:	00001917          	auipc	s2,0x1
     fee:	01690913          	addi	s2,s2,22 # 2000 <freep>
  if(p == (char*)-1)
     ff2:	5afd                	li	s5,-1
     ff4:	a88d                	j	1066 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
     ff6:	00002797          	auipc	a5,0x2
     ffa:	01a78793          	addi	a5,a5,26 # 3010 <base>
     ffe:	00001717          	auipc	a4,0x1
    1002:	00f73123          	sd	a5,2(a4) # 2000 <freep>
    1006:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1008:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    100c:	b7e1                	j	fd4 <malloc+0x36>
      if(p->s.size == nunits)
    100e:	02e48b63          	beq	s1,a4,1044 <malloc+0xa6>
        p->s.size -= nunits;
    1012:	4137073b          	subw	a4,a4,s3
    1016:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1018:	1702                	slli	a4,a4,0x20
    101a:	9301                	srli	a4,a4,0x20
    101c:	0712                	slli	a4,a4,0x4
    101e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1020:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1024:	00001717          	auipc	a4,0x1
    1028:	fca73e23          	sd	a0,-36(a4) # 2000 <freep>
      return (void*)(p + 1);
    102c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1030:	70e2                	ld	ra,56(sp)
    1032:	7442                	ld	s0,48(sp)
    1034:	74a2                	ld	s1,40(sp)
    1036:	7902                	ld	s2,32(sp)
    1038:	69e2                	ld	s3,24(sp)
    103a:	6a42                	ld	s4,16(sp)
    103c:	6aa2                	ld	s5,8(sp)
    103e:	6b02                	ld	s6,0(sp)
    1040:	6121                	addi	sp,sp,64
    1042:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1044:	6398                	ld	a4,0(a5)
    1046:	e118                	sd	a4,0(a0)
    1048:	bff1                	j	1024 <malloc+0x86>
  hp->s.size = nu;
    104a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    104e:	0541                	addi	a0,a0,16
    1050:	00000097          	auipc	ra,0x0
    1054:	ec6080e7          	jalr	-314(ra) # f16 <free>
  return freep;
    1058:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    105c:	d971                	beqz	a0,1030 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    105e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1060:	4798                	lw	a4,8(a5)
    1062:	fa9776e3          	bgeu	a4,s1,100e <malloc+0x70>
    if(p == freep)
    1066:	00093703          	ld	a4,0(s2)
    106a:	853e                	mv	a0,a5
    106c:	fef719e3          	bne	a4,a5,105e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1070:	8552                	mv	a0,s4
    1072:	00000097          	auipc	ra,0x0
    1076:	b7e080e7          	jalr	-1154(ra) # bf0 <sbrk>
  if(p == (char*)-1)
    107a:	fd5518e3          	bne	a0,s5,104a <malloc+0xac>
        return 0;
    107e:	4501                	li	a0,0
    1080:	bf45                	j	1030 <malloc+0x92>

0000000000001082 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
    1082:	7179                	addi	sp,sp,-48
    1084:	f406                	sd	ra,40(sp)
    1086:	f022                	sd	s0,32(sp)
    1088:	ec26                	sd	s1,24(sp)
    108a:	e84a                	sd	s2,16(sp)
    108c:	e44e                	sd	s3,8(sp)
    108e:	e052                	sd	s4,0(sp)
    1090:	1800                	addi	s0,sp,48
    1092:	8a2a                	mv	s4,a0
    1094:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
    1096:	4581                	li	a1,0
    1098:	00000517          	auipc	a0,0x0
    109c:	31850513          	addi	a0,a0,792 # 13b0 <digits+0x18>
    10a0:	00000097          	auipc	ra,0x0
    10a4:	b08080e7          	jalr	-1272(ra) # ba8 <open>
  if(fd < 0) {
    10a8:	04054263          	bltz	a0,10ec <statistics+0x6a>
    10ac:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
    10ae:	4481                	li	s1,0
    10b0:	03205063          	blez	s2,10d0 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
    10b4:	4099063b          	subw	a2,s2,s1
    10b8:	009a05b3          	add	a1,s4,s1
    10bc:	854e                	mv	a0,s3
    10be:	00000097          	auipc	ra,0x0
    10c2:	ac2080e7          	jalr	-1342(ra) # b80 <read>
    10c6:	00054563          	bltz	a0,10d0 <statistics+0x4e>
      break;
    }
    i += n;
    10ca:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
    10cc:	ff24c4e3          	blt	s1,s2,10b4 <statistics+0x32>
  }
  close(fd);
    10d0:	854e                	mv	a0,s3
    10d2:	00000097          	auipc	ra,0x0
    10d6:	abe080e7          	jalr	-1346(ra) # b90 <close>
  return i;
}
    10da:	8526                	mv	a0,s1
    10dc:	70a2                	ld	ra,40(sp)
    10de:	7402                	ld	s0,32(sp)
    10e0:	64e2                	ld	s1,24(sp)
    10e2:	6942                	ld	s2,16(sp)
    10e4:	69a2                	ld	s3,8(sp)
    10e6:	6a02                	ld	s4,0(sp)
    10e8:	6145                	addi	sp,sp,48
    10ea:	8082                	ret
      fprintf(2, "stats: open failed\n");
    10ec:	00000597          	auipc	a1,0x0
    10f0:	2d458593          	addi	a1,a1,724 # 13c0 <digits+0x28>
    10f4:	4509                	li	a0,2
    10f6:	00000097          	auipc	ra,0x0
    10fa:	dbc080e7          	jalr	-580(ra) # eb2 <fprintf>
      exit(1);
    10fe:	4505                	li	a0,1
    1100:	00000097          	auipc	ra,0x0
    1104:	a68080e7          	jalr	-1432(ra) # b68 <exit>
