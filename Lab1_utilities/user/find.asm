
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char* path) //获取文件名
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    char* p;
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	2c6080e7          	jalr	710(ra) # 2d2 <strlen>
  14:	1502                	slli	a0,a0,0x20
  16:	9101                	srli	a0,a0,0x20
  18:	9526                	add	a0,a0,s1
  1a:	02f00713          	li	a4,47
  1e:	00956963          	bltu	a0,s1,30 <fmtname+0x30>
  22:	00054783          	lbu	a5,0(a0)
  26:	00e78563          	beq	a5,a4,30 <fmtname+0x30>
  2a:	157d                	addi	a0,a0,-1
  2c:	fe957be3          	bgeu	a0,s1,22 <fmtname+0x22>
        ;
    p++;
    return p;
}
  30:	0505                	addi	a0,a0,1
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	64a2                	ld	s1,8(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret

000000000000003c <find>:

void find(char* path, char* target_name)
{
  3c:	d8010113          	addi	sp,sp,-640
  40:	26113c23          	sd	ra,632(sp)
  44:	26813823          	sd	s0,624(sp)
  48:	26913423          	sd	s1,616(sp)
  4c:	27213023          	sd	s2,608(sp)
  50:	25313c23          	sd	s3,600(sp)
  54:	25413823          	sd	s4,592(sp)
  58:	25513423          	sd	s5,584(sp)
  5c:	25613023          	sd	s6,576(sp)
  60:	23713c23          	sd	s7,568(sp)
  64:	0500                	addi	s0,sp,640
  66:	892a                	mv	s2,a0
  68:	89ae                	mv	s3,a1
    char buf[512], * p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0) {
  6a:	4581                	li	a1,0
  6c:	00000097          	auipc	ra,0x0
  70:	4d4080e7          	jalr	1236(ra) # 540 <open>
  74:	06054d63          	bltz	a0,ee <find+0xb2>
  78:	84aa                	mv	s1,a0
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }
    if (fstat(fd, &st) < 0) {
  7a:	d8840593          	addi	a1,s0,-632
  7e:	00000097          	auipc	ra,0x0
  82:	4da080e7          	jalr	1242(ra) # 558 <fstat>
  86:	06054f63          	bltz	a0,104 <find+0xc8>
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type) {
  8a:	d9041783          	lh	a5,-624(s0)
  8e:	0007869b          	sext.w	a3,a5
  92:	4705                	li	a4,1
  94:	0ae68263          	beq	a3,a4,138 <find+0xfc>
  98:	37f9                	addiw	a5,a5,-2
  9a:	17c2                	slli	a5,a5,0x30
  9c:	93c1                	srli	a5,a5,0x30
  9e:	00f76e63          	bltu	a4,a5,ba <find+0x7e>
    case T_DEVICE:
    case T_FILE: //文件类型
        if (strcmp(target_name, fmtname(path)) == 0) { //检查当前文件是否为目标文件
  a2:	854a                	mv	a0,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <fmtname>
  ac:	85aa                	mv	a1,a0
  ae:	854e                	mv	a0,s3
  b0:	00000097          	auipc	ra,0x0
  b4:	1f6080e7          	jalr	502(ra) # 2a6 <strcmp>
  b8:	c535                	beqz	a0,124 <find+0xe8>
                continue;
            find(buf, target_name); //进入该目录递归查找
        }
        break;
    }
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	00000097          	auipc	ra,0x0
  c0:	46c080e7          	jalr	1132(ra) # 528 <close>
}
  c4:	27813083          	ld	ra,632(sp)
  c8:	27013403          	ld	s0,624(sp)
  cc:	26813483          	ld	s1,616(sp)
  d0:	26013903          	ld	s2,608(sp)
  d4:	25813983          	ld	s3,600(sp)
  d8:	25013a03          	ld	s4,592(sp)
  dc:	24813a83          	ld	s5,584(sp)
  e0:	24013b03          	ld	s6,576(sp)
  e4:	23813b83          	ld	s7,568(sp)
  e8:	28010113          	addi	sp,sp,640
  ec:	8082                	ret
        fprintf(2, "ls: cannot open %s\n", path);
  ee:	864a                	mv	a2,s2
  f0:	00001597          	auipc	a1,0x1
  f4:	93058593          	addi	a1,a1,-1744 # a20 <malloc+0xea>
  f8:	4509                	li	a0,2
  fa:	00000097          	auipc	ra,0x0
  fe:	750080e7          	jalr	1872(ra) # 84a <fprintf>
        return;
 102:	b7c9                	j	c4 <find+0x88>
        fprintf(2, "ls: cannot stat %s\n", path);
 104:	864a                	mv	a2,s2
 106:	00001597          	auipc	a1,0x1
 10a:	93258593          	addi	a1,a1,-1742 # a38 <malloc+0x102>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	73a080e7          	jalr	1850(ra) # 84a <fprintf>
        close(fd);
 118:	8526                	mv	a0,s1
 11a:	00000097          	auipc	ra,0x0
 11e:	40e080e7          	jalr	1038(ra) # 528 <close>
        return;
 122:	b74d                	j	c4 <find+0x88>
            printf("%s\n", path);
 124:	85ca                	mv	a1,s2
 126:	00001517          	auipc	a0,0x1
 12a:	90a50513          	addi	a0,a0,-1782 # a30 <malloc+0xfa>
 12e:	00000097          	auipc	ra,0x0
 132:	74a080e7          	jalr	1866(ra) # 878 <printf>
 136:	b751                	j	ba <find+0x7e>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 138:	854a                	mv	a0,s2
 13a:	00000097          	auipc	ra,0x0
 13e:	198080e7          	jalr	408(ra) # 2d2 <strlen>
 142:	2541                	addiw	a0,a0,16
 144:	20000793          	li	a5,512
 148:	00a7fb63          	bgeu	a5,a0,15e <find+0x122>
            printf("ls: path too long\n");
 14c:	00001517          	auipc	a0,0x1
 150:	90450513          	addi	a0,a0,-1788 # a50 <malloc+0x11a>
 154:	00000097          	auipc	ra,0x0
 158:	724080e7          	jalr	1828(ra) # 878 <printf>
            break;
 15c:	bfb9                	j	ba <find+0x7e>
        strcpy(buf, path);
 15e:	85ca                	mv	a1,s2
 160:	db040513          	addi	a0,s0,-592
 164:	00000097          	auipc	ra,0x0
 168:	126080e7          	jalr	294(ra) # 28a <strcpy>
        p = buf + strlen(buf);
 16c:	db040513          	addi	a0,s0,-592
 170:	00000097          	auipc	ra,0x0
 174:	162080e7          	jalr	354(ra) # 2d2 <strlen>
 178:	02051913          	slli	s2,a0,0x20
 17c:	02095913          	srli	s2,s2,0x20
 180:	db040793          	addi	a5,s0,-592
 184:	993e                	add	s2,s2,a5
        *p++ = '/';
 186:	00190a13          	addi	s4,s2,1
 18a:	02f00793          	li	a5,47
 18e:	00f90023          	sb	a5,0(s2)
            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) //排除问题中要求的的.和..文件
 192:	00001a97          	auipc	s5,0x1
 196:	8eea8a93          	addi	s5,s5,-1810 # a80 <malloc+0x14a>
 19a:	00001b17          	auipc	s6,0x1
 19e:	8eeb0b13          	addi	s6,s6,-1810 # a88 <malloc+0x152>
                printf("find2: cannot stat %s\n", buf);
 1a2:	00001b97          	auipc	s7,0x1
 1a6:	8c6b8b93          	addi	s7,s7,-1850 # a68 <malloc+0x132>
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1aa:	4641                	li	a2,16
 1ac:	da040593          	addi	a1,s0,-608
 1b0:	8526                	mv	a0,s1
 1b2:	00000097          	auipc	ra,0x0
 1b6:	366080e7          	jalr	870(ra) # 518 <read>
 1ba:	47c1                	li	a5,16
 1bc:	eef51fe3          	bne	a0,a5,ba <find+0x7e>
            if (de.inum == 0)
 1c0:	da045783          	lhu	a5,-608(s0)
 1c4:	d3fd                	beqz	a5,1aa <find+0x16e>
            memmove(p, de.name, DIRSIZ);
 1c6:	4639                	li	a2,14
 1c8:	da240593          	addi	a1,s0,-606
 1cc:	8552                	mv	a0,s4
 1ce:	00000097          	auipc	ra,0x0
 1d2:	27c080e7          	jalr	636(ra) # 44a <memmove>
            p[DIRSIZ] = 0;
 1d6:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0) {
 1da:	d8840593          	addi	a1,s0,-632
 1de:	db040513          	addi	a0,s0,-592
 1e2:	00000097          	auipc	ra,0x0
 1e6:	1d8080e7          	jalr	472(ra) # 3ba <stat>
 1ea:	02054a63          	bltz	a0,21e <find+0x1e2>
            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) //排除问题中要求的的.和..文件
 1ee:	85d6                	mv	a1,s5
 1f0:	da240513          	addi	a0,s0,-606
 1f4:	00000097          	auipc	ra,0x0
 1f8:	0b2080e7          	jalr	178(ra) # 2a6 <strcmp>
 1fc:	d55d                	beqz	a0,1aa <find+0x16e>
 1fe:	85da                	mv	a1,s6
 200:	da240513          	addi	a0,s0,-606
 204:	00000097          	auipc	ra,0x0
 208:	0a2080e7          	jalr	162(ra) # 2a6 <strcmp>
 20c:	dd59                	beqz	a0,1aa <find+0x16e>
            find(buf, target_name); //进入该目录递归查找
 20e:	85ce                	mv	a1,s3
 210:	db040513          	addi	a0,s0,-592
 214:	00000097          	auipc	ra,0x0
 218:	e28080e7          	jalr	-472(ra) # 3c <find>
 21c:	b779                	j	1aa <find+0x16e>
                printf("find2: cannot stat %s\n", buf);
 21e:	db040593          	addi	a1,s0,-592
 222:	855e                	mv	a0,s7
 224:	00000097          	auipc	ra,0x0
 228:	654080e7          	jalr	1620(ra) # 878 <printf>
                continue;
 22c:	bfbd                	j	1aa <find+0x16e>

000000000000022e <main>:

int main(int argc, char* argv[])
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
    if (argc != 3) //参数数量错误
 236:	470d                	li	a4,3
 238:	02e50063          	beq	a0,a4,258 <main+0x2a>
    {
        fprintf(2, "error: wrong argument number in the instruction \"find\"\n");
 23c:	00001597          	auipc	a1,0x1
 240:	85458593          	addi	a1,a1,-1964 # a90 <malloc+0x15a>
 244:	4509                	li	a0,2
 246:	00000097          	auipc	ra,0x0
 24a:	604080e7          	jalr	1540(ra) # 84a <fprintf>
        exit(1);
 24e:	4505                	li	a0,1
 250:	00000097          	auipc	ra,0x0
 254:	2b0080e7          	jalr	688(ra) # 500 <exit>
 258:	87ae                	mv	a5,a1
    }
    find(argv[1], argv[2]);
 25a:	698c                	ld	a1,16(a1)
 25c:	6788                	ld	a0,8(a5)
 25e:	00000097          	auipc	ra,0x0
 262:	dde080e7          	jalr	-546(ra) # 3c <find>
    exit(0);
 266:	4501                	li	a0,0
 268:	00000097          	auipc	ra,0x0
 26c:	298080e7          	jalr	664(ra) # 500 <exit>

0000000000000270 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  extern int main();
  main();
 278:	00000097          	auipc	ra,0x0
 27c:	fb6080e7          	jalr	-74(ra) # 22e <main>
  exit(0);
 280:	4501                	li	a0,0
 282:	00000097          	auipc	ra,0x0
 286:	27e080e7          	jalr	638(ra) # 500 <exit>

000000000000028a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 290:	87aa                	mv	a5,a0
 292:	0585                	addi	a1,a1,1
 294:	0785                	addi	a5,a5,1
 296:	fff5c703          	lbu	a4,-1(a1)
 29a:	fee78fa3          	sb	a4,-1(a5)
 29e:	fb75                	bnez	a4,292 <strcpy+0x8>
    ;
  return os;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	cb91                	beqz	a5,2c4 <strcmp+0x1e>
 2b2:	0005c703          	lbu	a4,0(a1)
 2b6:	00f71763          	bne	a4,a5,2c4 <strcmp+0x1e>
    p++, q++;
 2ba:	0505                	addi	a0,a0,1
 2bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	fbe5                	bnez	a5,2b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2c4:	0005c503          	lbu	a0,0(a1)
}
 2c8:	40a7853b          	subw	a0,a5,a0
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <strlen>:

uint
strlen(const char *s)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2d8:	00054783          	lbu	a5,0(a0)
 2dc:	cf91                	beqz	a5,2f8 <strlen+0x26>
 2de:	0505                	addi	a0,a0,1
 2e0:	87aa                	mv	a5,a0
 2e2:	4685                	li	a3,1
 2e4:	9e89                	subw	a3,a3,a0
 2e6:	00f6853b          	addw	a0,a3,a5
 2ea:	0785                	addi	a5,a5,1
 2ec:	fff7c703          	lbu	a4,-1(a5)
 2f0:	fb7d                	bnez	a4,2e6 <strlen+0x14>
    ;
  return n;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  for(n = 0; s[n]; n++)
 2f8:	4501                	li	a0,0
 2fa:	bfe5                	j	2f2 <strlen+0x20>

00000000000002fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 302:	ce09                	beqz	a2,31c <memset+0x20>
 304:	87aa                	mv	a5,a0
 306:	fff6071b          	addiw	a4,a2,-1
 30a:	1702                	slli	a4,a4,0x20
 30c:	9301                	srli	a4,a4,0x20
 30e:	0705                	addi	a4,a4,1
 310:	972a                	add	a4,a4,a0
    cdst[i] = c;
 312:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 316:	0785                	addi	a5,a5,1
 318:	fee79de3          	bne	a5,a4,312 <memset+0x16>
  }
  return dst;
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <strchr>:

char*
strchr(const char *s, char c)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  for(; *s; s++)
 328:	00054783          	lbu	a5,0(a0)
 32c:	cb99                	beqz	a5,342 <strchr+0x20>
    if(*s == c)
 32e:	00f58763          	beq	a1,a5,33c <strchr+0x1a>
  for(; *s; s++)
 332:	0505                	addi	a0,a0,1
 334:	00054783          	lbu	a5,0(a0)
 338:	fbfd                	bnez	a5,32e <strchr+0xc>
      return (char*)s;
  return 0;
 33a:	4501                	li	a0,0
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <strchr+0x1a>

0000000000000346 <gets>:

char*
gets(char *buf, int max)
{
 346:	711d                	addi	sp,sp,-96
 348:	ec86                	sd	ra,88(sp)
 34a:	e8a2                	sd	s0,80(sp)
 34c:	e4a6                	sd	s1,72(sp)
 34e:	e0ca                	sd	s2,64(sp)
 350:	fc4e                	sd	s3,56(sp)
 352:	f852                	sd	s4,48(sp)
 354:	f456                	sd	s5,40(sp)
 356:	f05a                	sd	s6,32(sp)
 358:	ec5e                	sd	s7,24(sp)
 35a:	1080                	addi	s0,sp,96
 35c:	8baa                	mv	s7,a0
 35e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 360:	892a                	mv	s2,a0
 362:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 364:	4aa9                	li	s5,10
 366:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 368:	89a6                	mv	s3,s1
 36a:	2485                	addiw	s1,s1,1
 36c:	0344d863          	bge	s1,s4,39c <gets+0x56>
    cc = read(0, &c, 1);
 370:	4605                	li	a2,1
 372:	faf40593          	addi	a1,s0,-81
 376:	4501                	li	a0,0
 378:	00000097          	auipc	ra,0x0
 37c:	1a0080e7          	jalr	416(ra) # 518 <read>
    if(cc < 1)
 380:	00a05e63          	blez	a0,39c <gets+0x56>
    buf[i++] = c;
 384:	faf44783          	lbu	a5,-81(s0)
 388:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 38c:	01578763          	beq	a5,s5,39a <gets+0x54>
 390:	0905                	addi	s2,s2,1
 392:	fd679be3          	bne	a5,s6,368 <gets+0x22>
  for(i=0; i+1 < max; ){
 396:	89a6                	mv	s3,s1
 398:	a011                	j	39c <gets+0x56>
 39a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 39c:	99de                	add	s3,s3,s7
 39e:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a2:	855e                	mv	a0,s7
 3a4:	60e6                	ld	ra,88(sp)
 3a6:	6446                	ld	s0,80(sp)
 3a8:	64a6                	ld	s1,72(sp)
 3aa:	6906                	ld	s2,64(sp)
 3ac:	79e2                	ld	s3,56(sp)
 3ae:	7a42                	ld	s4,48(sp)
 3b0:	7aa2                	ld	s5,40(sp)
 3b2:	7b02                	ld	s6,32(sp)
 3b4:	6be2                	ld	s7,24(sp)
 3b6:	6125                	addi	sp,sp,96
 3b8:	8082                	ret

00000000000003ba <stat>:

int
stat(const char *n, struct stat *st)
{
 3ba:	1101                	addi	sp,sp,-32
 3bc:	ec06                	sd	ra,24(sp)
 3be:	e822                	sd	s0,16(sp)
 3c0:	e426                	sd	s1,8(sp)
 3c2:	e04a                	sd	s2,0(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c8:	4581                	li	a1,0
 3ca:	00000097          	auipc	ra,0x0
 3ce:	176080e7          	jalr	374(ra) # 540 <open>
  if(fd < 0)
 3d2:	02054563          	bltz	a0,3fc <stat+0x42>
 3d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d8:	85ca                	mv	a1,s2
 3da:	00000097          	auipc	ra,0x0
 3de:	17e080e7          	jalr	382(ra) # 558 <fstat>
 3e2:	892a                	mv	s2,a0
  close(fd);
 3e4:	8526                	mv	a0,s1
 3e6:	00000097          	auipc	ra,0x0
 3ea:	142080e7          	jalr	322(ra) # 528 <close>
  return r;
}
 3ee:	854a                	mv	a0,s2
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	64a2                	ld	s1,8(sp)
 3f6:	6902                	ld	s2,0(sp)
 3f8:	6105                	addi	sp,sp,32
 3fa:	8082                	ret
    return -1;
 3fc:	597d                	li	s2,-1
 3fe:	bfc5                	j	3ee <stat+0x34>

0000000000000400 <atoi>:

int
atoi(const char *s)
{
 400:	1141                	addi	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 406:	00054603          	lbu	a2,0(a0)
 40a:	fd06079b          	addiw	a5,a2,-48
 40e:	0ff7f793          	andi	a5,a5,255
 412:	4725                	li	a4,9
 414:	02f76963          	bltu	a4,a5,446 <atoi+0x46>
 418:	86aa                	mv	a3,a0
  n = 0;
 41a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 41c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 41e:	0685                	addi	a3,a3,1
 420:	0025179b          	slliw	a5,a0,0x2
 424:	9fa9                	addw	a5,a5,a0
 426:	0017979b          	slliw	a5,a5,0x1
 42a:	9fb1                	addw	a5,a5,a2
 42c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 430:	0006c603          	lbu	a2,0(a3)
 434:	fd06071b          	addiw	a4,a2,-48
 438:	0ff77713          	andi	a4,a4,255
 43c:	fee5f1e3          	bgeu	a1,a4,41e <atoi+0x1e>
  return n;
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  n = 0;
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <atoi+0x40>

000000000000044a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 450:	02b57663          	bgeu	a0,a1,47c <memmove+0x32>
    while(n-- > 0)
 454:	02c05163          	blez	a2,476 <memmove+0x2c>
 458:	fff6079b          	addiw	a5,a2,-1
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	0785                	addi	a5,a5,1
 462:	97aa                	add	a5,a5,a0
  dst = vdst;
 464:	872a                	mv	a4,a0
      *dst++ = *src++;
 466:	0585                	addi	a1,a1,1
 468:	0705                	addi	a4,a4,1
 46a:	fff5c683          	lbu	a3,-1(a1)
 46e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 472:	fee79ae3          	bne	a5,a4,466 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret
    dst += n;
 47c:	00c50733          	add	a4,a0,a2
    src += n;
 480:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 482:	fec05ae3          	blez	a2,476 <memmove+0x2c>
 486:	fff6079b          	addiw	a5,a2,-1
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	fff7c793          	not	a5,a5
 492:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 494:	15fd                	addi	a1,a1,-1
 496:	177d                	addi	a4,a4,-1
 498:	0005c683          	lbu	a3,0(a1)
 49c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4a0:	fee79ae3          	bne	a5,a4,494 <memmove+0x4a>
 4a4:	bfc9                	j	476 <memmove+0x2c>

00000000000004a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ac:	ca05                	beqz	a2,4dc <memcmp+0x36>
 4ae:	fff6069b          	addiw	a3,a2,-1
 4b2:	1682                	slli	a3,a3,0x20
 4b4:	9281                	srli	a3,a3,0x20
 4b6:	0685                	addi	a3,a3,1
 4b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ba:	00054783          	lbu	a5,0(a0)
 4be:	0005c703          	lbu	a4,0(a1)
 4c2:	00e79863          	bne	a5,a4,4d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4c6:	0505                	addi	a0,a0,1
    p2++;
 4c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ca:	fed518e3          	bne	a0,a3,4ba <memcmp+0x14>
  }
  return 0;
 4ce:	4501                	li	a0,0
 4d0:	a019                	j	4d6 <memcmp+0x30>
      return *p1 - *p2;
 4d2:	40e7853b          	subw	a0,a5,a4
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret
  return 0;
 4dc:	4501                	li	a0,0
 4de:	bfe5                	j	4d6 <memcmp+0x30>

00000000000004e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e406                	sd	ra,8(sp)
 4e4:	e022                	sd	s0,0(sp)
 4e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f62080e7          	jalr	-158(ra) # 44a <memmove>
}
 4f0:	60a2                	ld	ra,8(sp)
 4f2:	6402                	ld	s0,0(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret

00000000000004f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f8:	4885                	li	a7,1
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <exit>:
.global exit
exit:
 li a7, SYS_exit
 500:	4889                	li	a7,2
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <wait>:
.global wait
wait:
 li a7, SYS_wait
 508:	488d                	li	a7,3
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 510:	4891                	li	a7,4
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <read>:
.global read
read:
 li a7, SYS_read
 518:	4895                	li	a7,5
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <write>:
.global write
write:
 li a7, SYS_write
 520:	48c1                	li	a7,16
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <close>:
.global close
close:
 li a7, SYS_close
 528:	48d5                	li	a7,21
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <kill>:
.global kill
kill:
 li a7, SYS_kill
 530:	4899                	li	a7,6
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <exec>:
.global exec
exec:
 li a7, SYS_exec
 538:	489d                	li	a7,7
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <open>:
.global open
open:
 li a7, SYS_open
 540:	48bd                	li	a7,15
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 548:	48c5                	li	a7,17
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 550:	48c9                	li	a7,18
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 558:	48a1                	li	a7,8
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <link>:
.global link
link:
 li a7, SYS_link
 560:	48cd                	li	a7,19
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 568:	48d1                	li	a7,20
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 570:	48a5                	li	a7,9
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <dup>:
.global dup
dup:
 li a7, SYS_dup
 578:	48a9                	li	a7,10
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 580:	48ad                	li	a7,11
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 588:	48b1                	li	a7,12
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 590:	48b5                	li	a7,13
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 598:	48b9                	li	a7,14
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a0:	1101                	addi	sp,sp,-32
 5a2:	ec06                	sd	ra,24(sp)
 5a4:	e822                	sd	s0,16(sp)
 5a6:	1000                	addi	s0,sp,32
 5a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ac:	4605                	li	a2,1
 5ae:	fef40593          	addi	a1,s0,-17
 5b2:	00000097          	auipc	ra,0x0
 5b6:	f6e080e7          	jalr	-146(ra) # 520 <write>
}
 5ba:	60e2                	ld	ra,24(sp)
 5bc:	6442                	ld	s0,16(sp)
 5be:	6105                	addi	sp,sp,32
 5c0:	8082                	ret

00000000000005c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c2:	7139                	addi	sp,sp,-64
 5c4:	fc06                	sd	ra,56(sp)
 5c6:	f822                	sd	s0,48(sp)
 5c8:	f426                	sd	s1,40(sp)
 5ca:	f04a                	sd	s2,32(sp)
 5cc:	ec4e                	sd	s3,24(sp)
 5ce:	0080                	addi	s0,sp,64
 5d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d2:	c299                	beqz	a3,5d8 <printint+0x16>
 5d4:	0805c863          	bltz	a1,664 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d8:	2581                	sext.w	a1,a1
  neg = 0;
 5da:	4881                	li	a7,0
 5dc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e2:	2601                	sext.w	a2,a2
 5e4:	00000517          	auipc	a0,0x0
 5e8:	4ec50513          	addi	a0,a0,1260 # ad0 <digits>
 5ec:	883a                	mv	a6,a4
 5ee:	2705                	addiw	a4,a4,1
 5f0:	02c5f7bb          	remuw	a5,a1,a2
 5f4:	1782                	slli	a5,a5,0x20
 5f6:	9381                	srli	a5,a5,0x20
 5f8:	97aa                	add	a5,a5,a0
 5fa:	0007c783          	lbu	a5,0(a5)
 5fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 602:	0005879b          	sext.w	a5,a1
 606:	02c5d5bb          	divuw	a1,a1,a2
 60a:	0685                	addi	a3,a3,1
 60c:	fec7f0e3          	bgeu	a5,a2,5ec <printint+0x2a>
  if(neg)
 610:	00088b63          	beqz	a7,626 <printint+0x64>
    buf[i++] = '-';
 614:	fd040793          	addi	a5,s0,-48
 618:	973e                	add	a4,a4,a5
 61a:	02d00793          	li	a5,45
 61e:	fef70823          	sb	a5,-16(a4)
 622:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 626:	02e05863          	blez	a4,656 <printint+0x94>
 62a:	fc040793          	addi	a5,s0,-64
 62e:	00e78933          	add	s2,a5,a4
 632:	fff78993          	addi	s3,a5,-1
 636:	99ba                	add	s3,s3,a4
 638:	377d                	addiw	a4,a4,-1
 63a:	1702                	slli	a4,a4,0x20
 63c:	9301                	srli	a4,a4,0x20
 63e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 642:	fff94583          	lbu	a1,-1(s2)
 646:	8526                	mv	a0,s1
 648:	00000097          	auipc	ra,0x0
 64c:	f58080e7          	jalr	-168(ra) # 5a0 <putc>
  while(--i >= 0)
 650:	197d                	addi	s2,s2,-1
 652:	ff3918e3          	bne	s2,s3,642 <printint+0x80>
}
 656:	70e2                	ld	ra,56(sp)
 658:	7442                	ld	s0,48(sp)
 65a:	74a2                	ld	s1,40(sp)
 65c:	7902                	ld	s2,32(sp)
 65e:	69e2                	ld	s3,24(sp)
 660:	6121                	addi	sp,sp,64
 662:	8082                	ret
    x = -xx;
 664:	40b005bb          	negw	a1,a1
    neg = 1;
 668:	4885                	li	a7,1
    x = -xx;
 66a:	bf8d                	j	5dc <printint+0x1a>

000000000000066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66c:	7119                	addi	sp,sp,-128
 66e:	fc86                	sd	ra,120(sp)
 670:	f8a2                	sd	s0,112(sp)
 672:	f4a6                	sd	s1,104(sp)
 674:	f0ca                	sd	s2,96(sp)
 676:	ecce                	sd	s3,88(sp)
 678:	e8d2                	sd	s4,80(sp)
 67a:	e4d6                	sd	s5,72(sp)
 67c:	e0da                	sd	s6,64(sp)
 67e:	fc5e                	sd	s7,56(sp)
 680:	f862                	sd	s8,48(sp)
 682:	f466                	sd	s9,40(sp)
 684:	f06a                	sd	s10,32(sp)
 686:	ec6e                	sd	s11,24(sp)
 688:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68a:	0005c903          	lbu	s2,0(a1)
 68e:	18090f63          	beqz	s2,82c <vprintf+0x1c0>
 692:	8aaa                	mv	s5,a0
 694:	8b32                	mv	s6,a2
 696:	00158493          	addi	s1,a1,1
  state = 0;
 69a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69c:	02500a13          	li	s4,37
      if(c == 'd'){
 6a0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6a4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6a8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6ac:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b0:	00000b97          	auipc	s7,0x0
 6b4:	420b8b93          	addi	s7,s7,1056 # ad0 <digits>
 6b8:	a839                	j	6d6 <vprintf+0x6a>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	ee2080e7          	jalr	-286(ra) # 5a0 <putc>
 6c6:	a019                	j	6cc <vprintf+0x60>
    } else if(state == '%'){
 6c8:	01498f63          	beq	s3,s4,6e6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6cc:	0485                	addi	s1,s1,1
 6ce:	fff4c903          	lbu	s2,-1(s1)
 6d2:	14090d63          	beqz	s2,82c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6da:	fe0997e3          	bnez	s3,6c8 <vprintf+0x5c>
      if(c == '%'){
 6de:	fd479ee3          	bne	a5,s4,6ba <vprintf+0x4e>
        state = '%';
 6e2:	89be                	mv	s3,a5
 6e4:	b7e5                	j	6cc <vprintf+0x60>
      if(c == 'd'){
 6e6:	05878063          	beq	a5,s8,726 <vprintf+0xba>
      } else if(c == 'l') {
 6ea:	05978c63          	beq	a5,s9,742 <vprintf+0xd6>
      } else if(c == 'x') {
 6ee:	07a78863          	beq	a5,s10,75e <vprintf+0xf2>
      } else if(c == 'p') {
 6f2:	09b78463          	beq	a5,s11,77a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6f6:	07300713          	li	a4,115
 6fa:	0ce78663          	beq	a5,a4,7c6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fe:	06300713          	li	a4,99
 702:	0ee78e63          	beq	a5,a4,7fe <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 706:	11478863          	beq	a5,s4,816 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70a:	85d2                	mv	a1,s4
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e92080e7          	jalr	-366(ra) # 5a0 <putc>
        putc(fd, c);
 716:	85ca                	mv	a1,s2
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	e86080e7          	jalr	-378(ra) # 5a0 <putc>
      }
      state = 0;
 722:	4981                	li	s3,0
 724:	b765                	j	6cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 726:	008b0913          	addi	s2,s6,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000b2583          	lw	a1,0(s6)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e8e080e7          	jalr	-370(ra) # 5c2 <printint>
 73c:	8b4a                	mv	s6,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	b771                	j	6cc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	008b0913          	addi	s2,s6,8
 746:	4681                	li	a3,0
 748:	4629                	li	a2,10
 74a:	000b2583          	lw	a1,0(s6)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e72080e7          	jalr	-398(ra) # 5c2 <printint>
 758:	8b4a                	mv	s6,s2
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bf85                	j	6cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 75e:	008b0913          	addi	s2,s6,8
 762:	4681                	li	a3,0
 764:	4641                	li	a2,16
 766:	000b2583          	lw	a1,0(s6)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e56080e7          	jalr	-426(ra) # 5c2 <printint>
 774:	8b4a                	mv	s6,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	bf91                	j	6cc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 77a:	008b0793          	addi	a5,s6,8
 77e:	f8f43423          	sd	a5,-120(s0)
 782:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 786:	03000593          	li	a1,48
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	e14080e7          	jalr	-492(ra) # 5a0 <putc>
  putc(fd, 'x');
 794:	85ea                	mv	a1,s10
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	e08080e7          	jalr	-504(ra) # 5a0 <putc>
 7a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a2:	03c9d793          	srli	a5,s3,0x3c
 7a6:	97de                	add	a5,a5,s7
 7a8:	0007c583          	lbu	a1,0(a5)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	df2080e7          	jalr	-526(ra) # 5a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b6:	0992                	slli	s3,s3,0x4
 7b8:	397d                	addiw	s2,s2,-1
 7ba:	fe0914e3          	bnez	s2,7a2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7be:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b721                	j	6cc <vprintf+0x60>
        s = va_arg(ap, char*);
 7c6:	008b0993          	addi	s3,s6,8
 7ca:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ce:	02090163          	beqz	s2,7f0 <vprintf+0x184>
        while(*s != 0){
 7d2:	00094583          	lbu	a1,0(s2)
 7d6:	c9a1                	beqz	a1,826 <vprintf+0x1ba>
          putc(fd, *s);
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	dc6080e7          	jalr	-570(ra) # 5a0 <putc>
          s++;
 7e2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7e4:	00094583          	lbu	a1,0(s2)
 7e8:	f9e5                	bnez	a1,7d8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7ea:	8b4e                	mv	s6,s3
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bdf9                	j	6cc <vprintf+0x60>
          s = "(null)";
 7f0:	00000917          	auipc	s2,0x0
 7f4:	2d890913          	addi	s2,s2,728 # ac8 <malloc+0x192>
        while(*s != 0){
 7f8:	02800593          	li	a1,40
 7fc:	bff1                	j	7d8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7fe:	008b0913          	addi	s2,s6,8
 802:	000b4583          	lbu	a1,0(s6)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	d98080e7          	jalr	-616(ra) # 5a0 <putc>
 810:	8b4a                	mv	s6,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	bd65                	j	6cc <vprintf+0x60>
        putc(fd, c);
 816:	85d2                	mv	a1,s4
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	d86080e7          	jalr	-634(ra) # 5a0 <putc>
      state = 0;
 822:	4981                	li	s3,0
 824:	b565                	j	6cc <vprintf+0x60>
        s = va_arg(ap, char*);
 826:	8b4e                	mv	s6,s3
      state = 0;
 828:	4981                	li	s3,0
 82a:	b54d                	j	6cc <vprintf+0x60>
    }
  }
}
 82c:	70e6                	ld	ra,120(sp)
 82e:	7446                	ld	s0,112(sp)
 830:	74a6                	ld	s1,104(sp)
 832:	7906                	ld	s2,96(sp)
 834:	69e6                	ld	s3,88(sp)
 836:	6a46                	ld	s4,80(sp)
 838:	6aa6                	ld	s5,72(sp)
 83a:	6b06                	ld	s6,64(sp)
 83c:	7be2                	ld	s7,56(sp)
 83e:	7c42                	ld	s8,48(sp)
 840:	7ca2                	ld	s9,40(sp)
 842:	7d02                	ld	s10,32(sp)
 844:	6de2                	ld	s11,24(sp)
 846:	6109                	addi	sp,sp,128
 848:	8082                	ret

000000000000084a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84a:	715d                	addi	sp,sp,-80
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e010                	sd	a2,0(s0)
 854:	e414                	sd	a3,8(s0)
 856:	e818                	sd	a4,16(s0)
 858:	ec1c                	sd	a5,24(s0)
 85a:	03043023          	sd	a6,32(s0)
 85e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 866:	8622                	mv	a2,s0
 868:	00000097          	auipc	ra,0x0
 86c:	e04080e7          	jalr	-508(ra) # 66c <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6161                	addi	sp,sp,80
 876:	8082                	ret

0000000000000878 <printf>:

void
printf(const char *fmt, ...)
{
 878:	711d                	addi	sp,sp,-96
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e40c                	sd	a1,8(s0)
 882:	e810                	sd	a2,16(s0)
 884:	ec14                	sd	a3,24(s0)
 886:	f018                	sd	a4,32(s0)
 888:	f41c                	sd	a5,40(s0)
 88a:	03043823          	sd	a6,48(s0)
 88e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 892:	00840613          	addi	a2,s0,8
 896:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 89a:	85aa                	mv	a1,a0
 89c:	4505                	li	a0,1
 89e:	00000097          	auipc	ra,0x0
 8a2:	dce080e7          	jalr	-562(ra) # 66c <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6125                	addi	sp,sp,96
 8ac:	8082                	ret

00000000000008ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ae:	1141                	addi	sp,sp,-16
 8b0:	e422                	sd	s0,8(sp)
 8b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	00000797          	auipc	a5,0x0
 8bc:	7487b783          	ld	a5,1864(a5) # 1000 <freep>
 8c0:	a805                	j	8f0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c2:	4618                	lw	a4,8(a2)
 8c4:	9db9                	addw	a1,a1,a4
 8c6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ca:	6398                	ld	a4,0(a5)
 8cc:	6318                	ld	a4,0(a4)
 8ce:	fee53823          	sd	a4,-16(a0)
 8d2:	a091                	j	916 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d4:	ff852703          	lw	a4,-8(a0)
 8d8:	9e39                	addw	a2,a2,a4
 8da:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8dc:	ff053703          	ld	a4,-16(a0)
 8e0:	e398                	sd	a4,0(a5)
 8e2:	a099                	j	928 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e7e463          	bltu	a5,a4,8ee <free+0x40>
 8ea:	00e6ea63          	bltu	a3,a4,8fe <free+0x50>
{
 8ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	fed7fae3          	bgeu	a5,a3,8e4 <free+0x36>
 8f4:	6398                	ld	a4,0(a5)
 8f6:	00e6e463          	bltu	a3,a4,8fe <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	fee7eae3          	bltu	a5,a4,8ee <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8fe:	ff852583          	lw	a1,-8(a0)
 902:	6390                	ld	a2,0(a5)
 904:	02059713          	slli	a4,a1,0x20
 908:	9301                	srli	a4,a4,0x20
 90a:	0712                	slli	a4,a4,0x4
 90c:	9736                	add	a4,a4,a3
 90e:	fae60ae3          	beq	a2,a4,8c2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 912:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 916:	4790                	lw	a2,8(a5)
 918:	02061713          	slli	a4,a2,0x20
 91c:	9301                	srli	a4,a4,0x20
 91e:	0712                	slli	a4,a4,0x4
 920:	973e                	add	a4,a4,a5
 922:	fae689e3          	beq	a3,a4,8d4 <free+0x26>
  } else
    p->s.ptr = bp;
 926:	e394                	sd	a3,0(a5)
  freep = p;
 928:	00000717          	auipc	a4,0x0
 92c:	6cf73c23          	sd	a5,1752(a4) # 1000 <freep>
}
 930:	6422                	ld	s0,8(sp)
 932:	0141                	addi	sp,sp,16
 934:	8082                	ret

0000000000000936 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 936:	7139                	addi	sp,sp,-64
 938:	fc06                	sd	ra,56(sp)
 93a:	f822                	sd	s0,48(sp)
 93c:	f426                	sd	s1,40(sp)
 93e:	f04a                	sd	s2,32(sp)
 940:	ec4e                	sd	s3,24(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
 948:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94a:	02051493          	slli	s1,a0,0x20
 94e:	9081                	srli	s1,s1,0x20
 950:	04bd                	addi	s1,s1,15
 952:	8091                	srli	s1,s1,0x4
 954:	0014899b          	addiw	s3,s1,1
 958:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 95a:	00000517          	auipc	a0,0x0
 95e:	6a653503          	ld	a0,1702(a0) # 1000 <freep>
 962:	c515                	beqz	a0,98e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 966:	4798                	lw	a4,8(a5)
 968:	02977f63          	bgeu	a4,s1,9a6 <malloc+0x70>
 96c:	8a4e                	mv	s4,s3
 96e:	0009871b          	sext.w	a4,s3
 972:	6685                	lui	a3,0x1
 974:	00d77363          	bgeu	a4,a3,97a <malloc+0x44>
 978:	6a05                	lui	s4,0x1
 97a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 982:	00000917          	auipc	s2,0x0
 986:	67e90913          	addi	s2,s2,1662 # 1000 <freep>
  if(p == (char*)-1)
 98a:	5afd                	li	s5,-1
 98c:	a88d                	j	9fe <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 98e:	00000797          	auipc	a5,0x0
 992:	68278793          	addi	a5,a5,1666 # 1010 <base>
 996:	00000717          	auipc	a4,0x0
 99a:	66f73523          	sd	a5,1642(a4) # 1000 <freep>
 99e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a4:	b7e1                	j	96c <malloc+0x36>
      if(p->s.size == nunits)
 9a6:	02e48b63          	beq	s1,a4,9dc <malloc+0xa6>
        p->s.size -= nunits;
 9aa:	4137073b          	subw	a4,a4,s3
 9ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b0:	1702                	slli	a4,a4,0x20
 9b2:	9301                	srli	a4,a4,0x20
 9b4:	0712                	slli	a4,a4,0x4
 9b6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9bc:	00000717          	auipc	a4,0x0
 9c0:	64a73223          	sd	a0,1604(a4) # 1000 <freep>
      return (void*)(p + 1);
 9c4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c8:	70e2                	ld	ra,56(sp)
 9ca:	7442                	ld	s0,48(sp)
 9cc:	74a2                	ld	s1,40(sp)
 9ce:	7902                	ld	s2,32(sp)
 9d0:	69e2                	ld	s3,24(sp)
 9d2:	6a42                	ld	s4,16(sp)
 9d4:	6aa2                	ld	s5,8(sp)
 9d6:	6b02                	ld	s6,0(sp)
 9d8:	6121                	addi	sp,sp,64
 9da:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9dc:	6398                	ld	a4,0(a5)
 9de:	e118                	sd	a4,0(a0)
 9e0:	bff1                	j	9bc <malloc+0x86>
  hp->s.size = nu;
 9e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e6:	0541                	addi	a0,a0,16
 9e8:	00000097          	auipc	ra,0x0
 9ec:	ec6080e7          	jalr	-314(ra) # 8ae <free>
  return freep;
 9f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f4:	d971                	beqz	a0,9c8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f8:	4798                	lw	a4,8(a5)
 9fa:	fa9776e3          	bgeu	a4,s1,9a6 <malloc+0x70>
    if(p == freep)
 9fe:	00093703          	ld	a4,0(s2)
 a02:	853e                	mv	a0,a5
 a04:	fef719e3          	bne	a4,a5,9f6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a08:	8552                	mv	a0,s4
 a0a:	00000097          	auipc	ra,0x0
 a0e:	b7e080e7          	jalr	-1154(ra) # 588 <sbrk>
  if(p == (char*)-1)
 a12:	fd5518e3          	bne	a0,s5,9e2 <malloc+0xac>
        return 0;
 a16:	4501                	li	a0,0
 a18:	bf45                	j	9c8 <malloc+0x92>
