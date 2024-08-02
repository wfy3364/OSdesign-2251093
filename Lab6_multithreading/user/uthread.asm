
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);

void
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule(). It needs a stack so that the first thread_switch() can
  // save thread 0's state.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d6a78793          	addi	a5,a5,-662 # d70 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d4f73923          	sd	a5,-686(a4) # d60 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d4f72c23          	sw	a5,-680(a4) # 2d70 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d3233303          	ld	t1,-718(t1) # d60 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb37>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f1080813          	addi	a6,a6,-240 # 8f50 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb37>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d0a58593          	addi	a1,a1,-758 # d70 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	bb850513          	addi	a0,a0,-1096 # c28 <malloc+0xe8>
  78:	00001097          	auipc	ra,0x1
  7c:	a0a080e7          	jalr	-1526(ra) # a82 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	688080e7          	jalr	1672(ra) # 70a <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	ccb7b423          	sd	a1,-824(a5) # d60 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64)&t->thread_context, (uint64)&next_thread->thread_context);
  a0:	0521                	addi	a0,a0,8
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	36a080e7          	jalr	874(ra) # 410 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	cb478793          	addi	a5,a5,-844 # d70 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb37>
  ca:	00009617          	auipc	a2,0x9
  ce:	e8660613          	addi	a2,a2,-378 # 8f50 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	97ba                	add	a5,a5,a4
  e4:	4709                	li	a4,2
  e6:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
  t->thread_context.ra = (uint64)func;
  e8:	e788                	sd	a0,8(a5)
  t->thread_context.sp = (uint64)(t->stack + STACK_SIZE);
  ea:	eb9c                	sd	a5,16(a5)
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <thread_yield>:

void 
thread_yield(void)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  fa:	00001797          	auipc	a5,0x1
  fe:	c667b783          	ld	a5,-922(a5) # d60 <current_thread>
 102:	6709                	lui	a4,0x2
 104:	97ba                	add	a5,a5,a4
 106:	4709                	li	a4,2
 108:	c398                	sw	a4,0(a5)
  thread_schedule();
 10a:	00000097          	auipc	ra,0x0
 10e:	f1c080e7          	jalr	-228(ra) # 26 <thread_schedule>
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	b2650513          	addi	a0,a0,-1242 # c50 <malloc+0x110>
 132:	00001097          	auipc	ra,0x1
 136:	950080e7          	jalr	-1712(ra) # a82 <printf>
  a_started = 1;
 13a:	4785                	li	a5,1
 13c:	00001717          	auipc	a4,0x1
 140:	c2f72023          	sw	a5,-992(a4) # d5c <a_started>
  while(b_started == 0 || c_started == 0)
 144:	00001497          	auipc	s1,0x1
 148:	c1448493          	addi	s1,s1,-1004 # d58 <b_started>
 14c:	00001917          	auipc	s2,0x1
 150:	c0890913          	addi	s2,s2,-1016 # d54 <c_started>
 154:	a029                	j	15e <thread_a+0x44>
    thread_yield();
 156:	00000097          	auipc	ra,0x0
 15a:	f9c080e7          	jalr	-100(ra) # f2 <thread_yield>
  while(b_started == 0 || c_started == 0)
 15e:	409c                	lw	a5,0(s1)
 160:	2781                	sext.w	a5,a5
 162:	dbf5                	beqz	a5,156 <thread_a+0x3c>
 164:	00092783          	lw	a5,0(s2)
 168:	2781                	sext.w	a5,a5
 16a:	d7f5                	beqz	a5,156 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 16c:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 16e:	00001a17          	auipc	s4,0x1
 172:	afaa0a13          	addi	s4,s4,-1286 # c68 <malloc+0x128>
    a_n += 1;
 176:	00001917          	auipc	s2,0x1
 17a:	bda90913          	addi	s2,s2,-1062 # d50 <a_n>
  for (i = 0; i < 100; i++) {
 17e:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 182:	85a6                	mv	a1,s1
 184:	8552                	mv	a0,s4
 186:	00001097          	auipc	ra,0x1
 18a:	8fc080e7          	jalr	-1796(ra) # a82 <printf>
    a_n += 1;
 18e:	00092783          	lw	a5,0(s2)
 192:	2785                	addiw	a5,a5,1
 194:	00f92023          	sw	a5,0(s2)
    thread_yield();
 198:	00000097          	auipc	ra,0x0
 19c:	f5a080e7          	jalr	-166(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a0:	2485                	addiw	s1,s1,1
 1a2:	ff3490e3          	bne	s1,s3,182 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1a6:	00001597          	auipc	a1,0x1
 1aa:	baa5a583          	lw	a1,-1110(a1) # d50 <a_n>
 1ae:	00001517          	auipc	a0,0x1
 1b2:	aca50513          	addi	a0,a0,-1334 # c78 <malloc+0x138>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	8cc080e7          	jalr	-1844(ra) # a82 <printf>

  current_thread->state = FREE;
 1be:	00001797          	auipc	a5,0x1
 1c2:	ba27b783          	ld	a5,-1118(a5) # d60 <current_thread>
 1c6:	6709                	lui	a4,0x2
 1c8:	97ba                	add	a5,a5,a4
 1ca:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e58080e7          	jalr	-424(ra) # 26 <thread_schedule>
}
 1d6:	70a2                	ld	ra,40(sp)
 1d8:	7402                	ld	s0,32(sp)
 1da:	64e2                	ld	s1,24(sp)
 1dc:	6942                	ld	s2,16(sp)
 1de:	69a2                	ld	s3,8(sp)
 1e0:	6a02                	ld	s4,0(sp)
 1e2:	6145                	addi	sp,sp,48
 1e4:	8082                	ret

00000000000001e6 <thread_b>:

void 
thread_b(void)
{
 1e6:	7179                	addi	sp,sp,-48
 1e8:	f406                	sd	ra,40(sp)
 1ea:	f022                	sd	s0,32(sp)
 1ec:	ec26                	sd	s1,24(sp)
 1ee:	e84a                	sd	s2,16(sp)
 1f0:	e44e                	sd	s3,8(sp)
 1f2:	e052                	sd	s4,0(sp)
 1f4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	aa250513          	addi	a0,a0,-1374 # c98 <malloc+0x158>
 1fe:	00001097          	auipc	ra,0x1
 202:	884080e7          	jalr	-1916(ra) # a82 <printf>
  b_started = 1;
 206:	4785                	li	a5,1
 208:	00001717          	auipc	a4,0x1
 20c:	b4f72823          	sw	a5,-1200(a4) # d58 <b_started>
  while(a_started == 0 || c_started == 0)
 210:	00001497          	auipc	s1,0x1
 214:	b4c48493          	addi	s1,s1,-1204 # d5c <a_started>
 218:	00001917          	auipc	s2,0x1
 21c:	b3c90913          	addi	s2,s2,-1220 # d54 <c_started>
 220:	a029                	j	22a <thread_b+0x44>
    thread_yield();
 222:	00000097          	auipc	ra,0x0
 226:	ed0080e7          	jalr	-304(ra) # f2 <thread_yield>
  while(a_started == 0 || c_started == 0)
 22a:	409c                	lw	a5,0(s1)
 22c:	2781                	sext.w	a5,a5
 22e:	dbf5                	beqz	a5,222 <thread_b+0x3c>
 230:	00092783          	lw	a5,0(s2)
 234:	2781                	sext.w	a5,a5
 236:	d7f5                	beqz	a5,222 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 238:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 23a:	00001a17          	auipc	s4,0x1
 23e:	a76a0a13          	addi	s4,s4,-1418 # cb0 <malloc+0x170>
    b_n += 1;
 242:	00001917          	auipc	s2,0x1
 246:	b0a90913          	addi	s2,s2,-1270 # d4c <b_n>
  for (i = 0; i < 100; i++) {
 24a:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 24e:	85a6                	mv	a1,s1
 250:	8552                	mv	a0,s4
 252:	00001097          	auipc	ra,0x1
 256:	830080e7          	jalr	-2000(ra) # a82 <printf>
    b_n += 1;
 25a:	00092783          	lw	a5,0(s2)
 25e:	2785                	addiw	a5,a5,1
 260:	00f92023          	sw	a5,0(s2)
    thread_yield();
 264:	00000097          	auipc	ra,0x0
 268:	e8e080e7          	jalr	-370(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 26c:	2485                	addiw	s1,s1,1
 26e:	ff3490e3          	bne	s1,s3,24e <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 272:	00001597          	auipc	a1,0x1
 276:	ada5a583          	lw	a1,-1318(a1) # d4c <b_n>
 27a:	00001517          	auipc	a0,0x1
 27e:	a4650513          	addi	a0,a0,-1466 # cc0 <malloc+0x180>
 282:	00001097          	auipc	ra,0x1
 286:	800080e7          	jalr	-2048(ra) # a82 <printf>

  current_thread->state = FREE;
 28a:	00001797          	auipc	a5,0x1
 28e:	ad67b783          	ld	a5,-1322(a5) # d60 <current_thread>
 292:	6709                	lui	a4,0x2
 294:	97ba                	add	a5,a5,a4
 296:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 29a:	00000097          	auipc	ra,0x0
 29e:	d8c080e7          	jalr	-628(ra) # 26 <thread_schedule>
}
 2a2:	70a2                	ld	ra,40(sp)
 2a4:	7402                	ld	s0,32(sp)
 2a6:	64e2                	ld	s1,24(sp)
 2a8:	6942                	ld	s2,16(sp)
 2aa:	69a2                	ld	s3,8(sp)
 2ac:	6a02                	ld	s4,0(sp)
 2ae:	6145                	addi	sp,sp,48
 2b0:	8082                	ret

00000000000002b2 <thread_c>:

void 
thread_c(void)
{
 2b2:	7179                	addi	sp,sp,-48
 2b4:	f406                	sd	ra,40(sp)
 2b6:	f022                	sd	s0,32(sp)
 2b8:	ec26                	sd	s1,24(sp)
 2ba:	e84a                	sd	s2,16(sp)
 2bc:	e44e                	sd	s3,8(sp)
 2be:	e052                	sd	s4,0(sp)
 2c0:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	a1e50513          	addi	a0,a0,-1506 # ce0 <malloc+0x1a0>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	7b8080e7          	jalr	1976(ra) # a82 <printf>
  c_started = 1;
 2d2:	4785                	li	a5,1
 2d4:	00001717          	auipc	a4,0x1
 2d8:	a8f72023          	sw	a5,-1408(a4) # d54 <c_started>
  while(a_started == 0 || b_started == 0)
 2dc:	00001497          	auipc	s1,0x1
 2e0:	a8048493          	addi	s1,s1,-1408 # d5c <a_started>
 2e4:	00001917          	auipc	s2,0x1
 2e8:	a7490913          	addi	s2,s2,-1420 # d58 <b_started>
 2ec:	a029                	j	2f6 <thread_c+0x44>
    thread_yield();
 2ee:	00000097          	auipc	ra,0x0
 2f2:	e04080e7          	jalr	-508(ra) # f2 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2f6:	409c                	lw	a5,0(s1)
 2f8:	2781                	sext.w	a5,a5
 2fa:	dbf5                	beqz	a5,2ee <thread_c+0x3c>
 2fc:	00092783          	lw	a5,0(s2)
 300:	2781                	sext.w	a5,a5
 302:	d7f5                	beqz	a5,2ee <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 304:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 306:	00001a17          	auipc	s4,0x1
 30a:	9f2a0a13          	addi	s4,s4,-1550 # cf8 <malloc+0x1b8>
    c_n += 1;
 30e:	00001917          	auipc	s2,0x1
 312:	a3a90913          	addi	s2,s2,-1478 # d48 <c_n>
  for (i = 0; i < 100; i++) {
 316:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31a:	85a6                	mv	a1,s1
 31c:	8552                	mv	a0,s4
 31e:	00000097          	auipc	ra,0x0
 322:	764080e7          	jalr	1892(ra) # a82 <printf>
    c_n += 1;
 326:	00092783          	lw	a5,0(s2)
 32a:	2785                	addiw	a5,a5,1
 32c:	00f92023          	sw	a5,0(s2)
    thread_yield();
 330:	00000097          	auipc	ra,0x0
 334:	dc2080e7          	jalr	-574(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 338:	2485                	addiw	s1,s1,1
 33a:	ff3490e3          	bne	s1,s3,31a <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 33e:	00001597          	auipc	a1,0x1
 342:	a0a5a583          	lw	a1,-1526(a1) # d48 <c_n>
 346:	00001517          	auipc	a0,0x1
 34a:	9c250513          	addi	a0,a0,-1598 # d08 <malloc+0x1c8>
 34e:	00000097          	auipc	ra,0x0
 352:	734080e7          	jalr	1844(ra) # a82 <printf>

  current_thread->state = FREE;
 356:	00001797          	auipc	a5,0x1
 35a:	a0a7b783          	ld	a5,-1526(a5) # d60 <current_thread>
 35e:	6709                	lui	a4,0x2
 360:	97ba                	add	a5,a5,a4
 362:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 366:	00000097          	auipc	ra,0x0
 36a:	cc0080e7          	jalr	-832(ra) # 26 <thread_schedule>
}
 36e:	70a2                	ld	ra,40(sp)
 370:	7402                	ld	s0,32(sp)
 372:	64e2                	ld	s1,24(sp)
 374:	6942                	ld	s2,16(sp)
 376:	69a2                	ld	s3,8(sp)
 378:	6a02                	ld	s4,0(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <main>:

int 
main(int argc, char *argv[]) 
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 386:	00001797          	auipc	a5,0x1
 38a:	9c07a723          	sw	zero,-1586(a5) # d54 <c_started>
 38e:	00001797          	auipc	a5,0x1
 392:	9c07a523          	sw	zero,-1590(a5) # d58 <b_started>
 396:	00001797          	auipc	a5,0x1
 39a:	9c07a323          	sw	zero,-1594(a5) # d5c <a_started>
  a_n = b_n = c_n = 0;
 39e:	00001797          	auipc	a5,0x1
 3a2:	9a07a523          	sw	zero,-1622(a5) # d48 <c_n>
 3a6:	00001797          	auipc	a5,0x1
 3aa:	9a07a323          	sw	zero,-1626(a5) # d4c <b_n>
 3ae:	00001797          	auipc	a5,0x1
 3b2:	9a07a123          	sw	zero,-1630(a5) # d50 <a_n>
  thread_init();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	c4a080e7          	jalr	-950(ra) # 0 <thread_init>
  thread_create(thread_a);
 3be:	00000517          	auipc	a0,0x0
 3c2:	d5c50513          	addi	a0,a0,-676 # 11a <thread_a>
 3c6:	00000097          	auipc	ra,0x0
 3ca:	cf0080e7          	jalr	-784(ra) # b6 <thread_create>
  thread_create(thread_b);
 3ce:	00000517          	auipc	a0,0x0
 3d2:	e1850513          	addi	a0,a0,-488 # 1e6 <thread_b>
 3d6:	00000097          	auipc	ra,0x0
 3da:	ce0080e7          	jalr	-800(ra) # b6 <thread_create>
  thread_create(thread_c);
 3de:	00000517          	auipc	a0,0x0
 3e2:	ed450513          	addi	a0,a0,-300 # 2b2 <thread_c>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	cd0080e7          	jalr	-816(ra) # b6 <thread_create>
  current_thread->state = FREE;
 3ee:	00001797          	auipc	a5,0x1
 3f2:	9727b783          	ld	a5,-1678(a5) # d60 <current_thread>
 3f6:	6709                	lui	a4,0x2
 3f8:	97ba                	add	a5,a5,a4
 3fa:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 3fe:	00000097          	auipc	ra,0x0
 402:	c28080e7          	jalr	-984(ra) # 26 <thread_schedule>
  exit(0);
 406:	4501                	li	a0,0
 408:	00000097          	auipc	ra,0x0
 40c:	302080e7          	jalr	770(ra) # 70a <exit>

0000000000000410 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
        sd ra, 0(a0)
 410:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
 414:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
 418:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
 41a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
 41c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
 420:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
 424:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
 428:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
 42c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
 430:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
 434:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
 438:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
 43c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
 440:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
 444:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
 448:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
 44c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
 44e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
 450:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
 454:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
 458:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
 45c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
 460:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
 464:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
 468:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
 46c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
 470:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
 474:	0685bd83          	ld	s11,104(a1)
        ret    /* return to ra */
 478:	8082                	ret

000000000000047a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e406                	sd	ra,8(sp)
 47e:	e022                	sd	s0,0(sp)
 480:	0800                	addi	s0,sp,16
  extern int main();
  main();
 482:	00000097          	auipc	ra,0x0
 486:	efc080e7          	jalr	-260(ra) # 37e <main>
  exit(0);
 48a:	4501                	li	a0,0
 48c:	00000097          	auipc	ra,0x0
 490:	27e080e7          	jalr	638(ra) # 70a <exit>

0000000000000494 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 49a:	87aa                	mv	a5,a0
 49c:	0585                	addi	a1,a1,1
 49e:	0785                	addi	a5,a5,1
 4a0:	fff5c703          	lbu	a4,-1(a1)
 4a4:	fee78fa3          	sb	a4,-1(a5)
 4a8:	fb75                	bnez	a4,49c <strcpy+0x8>
    ;
  return os;
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret

00000000000004b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4b6:	00054783          	lbu	a5,0(a0)
 4ba:	cb91                	beqz	a5,4ce <strcmp+0x1e>
 4bc:	0005c703          	lbu	a4,0(a1)
 4c0:	00f71763          	bne	a4,a5,4ce <strcmp+0x1e>
    p++, q++;
 4c4:	0505                	addi	a0,a0,1
 4c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	fbe5                	bnez	a5,4bc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4ce:	0005c503          	lbu	a0,0(a1)
}
 4d2:	40a7853b          	subw	a0,a5,a0
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret

00000000000004dc <strlen>:

uint
strlen(const char *s)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	cf91                	beqz	a5,502 <strlen+0x26>
 4e8:	0505                	addi	a0,a0,1
 4ea:	87aa                	mv	a5,a0
 4ec:	4685                	li	a3,1
 4ee:	9e89                	subw	a3,a3,a0
 4f0:	00f6853b          	addw	a0,a3,a5
 4f4:	0785                	addi	a5,a5,1
 4f6:	fff7c703          	lbu	a4,-1(a5)
 4fa:	fb7d                	bnez	a4,4f0 <strlen+0x14>
    ;
  return n;
}
 4fc:	6422                	ld	s0,8(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret
  for(n = 0; s[n]; n++)
 502:	4501                	li	a0,0
 504:	bfe5                	j	4fc <strlen+0x20>

0000000000000506 <memset>:

void*
memset(void *dst, int c, uint n)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 50c:	ce09                	beqz	a2,526 <memset+0x20>
 50e:	87aa                	mv	a5,a0
 510:	fff6071b          	addiw	a4,a2,-1
 514:	1702                	slli	a4,a4,0x20
 516:	9301                	srli	a4,a4,0x20
 518:	0705                	addi	a4,a4,1
 51a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 51c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 520:	0785                	addi	a5,a5,1
 522:	fee79de3          	bne	a5,a4,51c <memset+0x16>
  }
  return dst;
}
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret

000000000000052c <strchr>:

char*
strchr(const char *s, char c)
{
 52c:	1141                	addi	sp,sp,-16
 52e:	e422                	sd	s0,8(sp)
 530:	0800                	addi	s0,sp,16
  for(; *s; s++)
 532:	00054783          	lbu	a5,0(a0)
 536:	cb99                	beqz	a5,54c <strchr+0x20>
    if(*s == c)
 538:	00f58763          	beq	a1,a5,546 <strchr+0x1a>
  for(; *s; s++)
 53c:	0505                	addi	a0,a0,1
 53e:	00054783          	lbu	a5,0(a0)
 542:	fbfd                	bnez	a5,538 <strchr+0xc>
      return (char*)s;
  return 0;
 544:	4501                	li	a0,0
}
 546:	6422                	ld	s0,8(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret
  return 0;
 54c:	4501                	li	a0,0
 54e:	bfe5                	j	546 <strchr+0x1a>

0000000000000550 <gets>:

char*
gets(char *buf, int max)
{
 550:	711d                	addi	sp,sp,-96
 552:	ec86                	sd	ra,88(sp)
 554:	e8a2                	sd	s0,80(sp)
 556:	e4a6                	sd	s1,72(sp)
 558:	e0ca                	sd	s2,64(sp)
 55a:	fc4e                	sd	s3,56(sp)
 55c:	f852                	sd	s4,48(sp)
 55e:	f456                	sd	s5,40(sp)
 560:	f05a                	sd	s6,32(sp)
 562:	ec5e                	sd	s7,24(sp)
 564:	1080                	addi	s0,sp,96
 566:	8baa                	mv	s7,a0
 568:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 56a:	892a                	mv	s2,a0
 56c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 56e:	4aa9                	li	s5,10
 570:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 572:	89a6                	mv	s3,s1
 574:	2485                	addiw	s1,s1,1
 576:	0344d863          	bge	s1,s4,5a6 <gets+0x56>
    cc = read(0, &c, 1);
 57a:	4605                	li	a2,1
 57c:	faf40593          	addi	a1,s0,-81
 580:	4501                	li	a0,0
 582:	00000097          	auipc	ra,0x0
 586:	1a0080e7          	jalr	416(ra) # 722 <read>
    if(cc < 1)
 58a:	00a05e63          	blez	a0,5a6 <gets+0x56>
    buf[i++] = c;
 58e:	faf44783          	lbu	a5,-81(s0)
 592:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 596:	01578763          	beq	a5,s5,5a4 <gets+0x54>
 59a:	0905                	addi	s2,s2,1
 59c:	fd679be3          	bne	a5,s6,572 <gets+0x22>
  for(i=0; i+1 < max; ){
 5a0:	89a6                	mv	s3,s1
 5a2:	a011                	j	5a6 <gets+0x56>
 5a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5a6:	99de                	add	s3,s3,s7
 5a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 5ac:	855e                	mv	a0,s7
 5ae:	60e6                	ld	ra,88(sp)
 5b0:	6446                	ld	s0,80(sp)
 5b2:	64a6                	ld	s1,72(sp)
 5b4:	6906                	ld	s2,64(sp)
 5b6:	79e2                	ld	s3,56(sp)
 5b8:	7a42                	ld	s4,48(sp)
 5ba:	7aa2                	ld	s5,40(sp)
 5bc:	7b02                	ld	s6,32(sp)
 5be:	6be2                	ld	s7,24(sp)
 5c0:	6125                	addi	sp,sp,96
 5c2:	8082                	ret

00000000000005c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 5c4:	1101                	addi	sp,sp,-32
 5c6:	ec06                	sd	ra,24(sp)
 5c8:	e822                	sd	s0,16(sp)
 5ca:	e426                	sd	s1,8(sp)
 5cc:	e04a                	sd	s2,0(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5d2:	4581                	li	a1,0
 5d4:	00000097          	auipc	ra,0x0
 5d8:	176080e7          	jalr	374(ra) # 74a <open>
  if(fd < 0)
 5dc:	02054563          	bltz	a0,606 <stat+0x42>
 5e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5e2:	85ca                	mv	a1,s2
 5e4:	00000097          	auipc	ra,0x0
 5e8:	17e080e7          	jalr	382(ra) # 762 <fstat>
 5ec:	892a                	mv	s2,a0
  close(fd);
 5ee:	8526                	mv	a0,s1
 5f0:	00000097          	auipc	ra,0x0
 5f4:	142080e7          	jalr	322(ra) # 732 <close>
  return r;
}
 5f8:	854a                	mv	a0,s2
 5fa:	60e2                	ld	ra,24(sp)
 5fc:	6442                	ld	s0,16(sp)
 5fe:	64a2                	ld	s1,8(sp)
 600:	6902                	ld	s2,0(sp)
 602:	6105                	addi	sp,sp,32
 604:	8082                	ret
    return -1;
 606:	597d                	li	s2,-1
 608:	bfc5                	j	5f8 <stat+0x34>

000000000000060a <atoi>:

int
atoi(const char *s)
{
 60a:	1141                	addi	sp,sp,-16
 60c:	e422                	sd	s0,8(sp)
 60e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 610:	00054603          	lbu	a2,0(a0)
 614:	fd06079b          	addiw	a5,a2,-48
 618:	0ff7f793          	andi	a5,a5,255
 61c:	4725                	li	a4,9
 61e:	02f76963          	bltu	a4,a5,650 <atoi+0x46>
 622:	86aa                	mv	a3,a0
  n = 0;
 624:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 626:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 628:	0685                	addi	a3,a3,1
 62a:	0025179b          	slliw	a5,a0,0x2
 62e:	9fa9                	addw	a5,a5,a0
 630:	0017979b          	slliw	a5,a5,0x1
 634:	9fb1                	addw	a5,a5,a2
 636:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 63a:	0006c603          	lbu	a2,0(a3)
 63e:	fd06071b          	addiw	a4,a2,-48
 642:	0ff77713          	andi	a4,a4,255
 646:	fee5f1e3          	bgeu	a1,a4,628 <atoi+0x1e>
  return n;
}
 64a:	6422                	ld	s0,8(sp)
 64c:	0141                	addi	sp,sp,16
 64e:	8082                	ret
  n = 0;
 650:	4501                	li	a0,0
 652:	bfe5                	j	64a <atoi+0x40>

0000000000000654 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 654:	1141                	addi	sp,sp,-16
 656:	e422                	sd	s0,8(sp)
 658:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 65a:	02b57663          	bgeu	a0,a1,686 <memmove+0x32>
    while(n-- > 0)
 65e:	02c05163          	blez	a2,680 <memmove+0x2c>
 662:	fff6079b          	addiw	a5,a2,-1
 666:	1782                	slli	a5,a5,0x20
 668:	9381                	srli	a5,a5,0x20
 66a:	0785                	addi	a5,a5,1
 66c:	97aa                	add	a5,a5,a0
  dst = vdst;
 66e:	872a                	mv	a4,a0
      *dst++ = *src++;
 670:	0585                	addi	a1,a1,1
 672:	0705                	addi	a4,a4,1
 674:	fff5c683          	lbu	a3,-1(a1)
 678:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xabe>
    while(n-- > 0)
 67c:	fee79ae3          	bne	a5,a4,670 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 680:	6422                	ld	s0,8(sp)
 682:	0141                	addi	sp,sp,16
 684:	8082                	ret
    dst += n;
 686:	00c50733          	add	a4,a0,a2
    src += n;
 68a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 68c:	fec05ae3          	blez	a2,680 <memmove+0x2c>
 690:	fff6079b          	addiw	a5,a2,-1
 694:	1782                	slli	a5,a5,0x20
 696:	9381                	srli	a5,a5,0x20
 698:	fff7c793          	not	a5,a5
 69c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 69e:	15fd                	addi	a1,a1,-1
 6a0:	177d                	addi	a4,a4,-1
 6a2:	0005c683          	lbu	a3,0(a1)
 6a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6aa:	fee79ae3          	bne	a5,a4,69e <memmove+0x4a>
 6ae:	bfc9                	j	680 <memmove+0x2c>

00000000000006b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6b0:	1141                	addi	sp,sp,-16
 6b2:	e422                	sd	s0,8(sp)
 6b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6b6:	ca05                	beqz	a2,6e6 <memcmp+0x36>
 6b8:	fff6069b          	addiw	a3,a2,-1
 6bc:	1682                	slli	a3,a3,0x20
 6be:	9281                	srli	a3,a3,0x20
 6c0:	0685                	addi	a3,a3,1
 6c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6c4:	00054783          	lbu	a5,0(a0)
 6c8:	0005c703          	lbu	a4,0(a1)
 6cc:	00e79863          	bne	a5,a4,6dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6d0:	0505                	addi	a0,a0,1
    p2++;
 6d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6d4:	fed518e3          	bne	a0,a3,6c4 <memcmp+0x14>
  }
  return 0;
 6d8:	4501                	li	a0,0
 6da:	a019                	j	6e0 <memcmp+0x30>
      return *p1 - *p2;
 6dc:	40e7853b          	subw	a0,a5,a4
}
 6e0:	6422                	ld	s0,8(sp)
 6e2:	0141                	addi	sp,sp,16
 6e4:	8082                	ret
  return 0;
 6e6:	4501                	li	a0,0
 6e8:	bfe5                	j	6e0 <memcmp+0x30>

00000000000006ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6ea:	1141                	addi	sp,sp,-16
 6ec:	e406                	sd	ra,8(sp)
 6ee:	e022                	sd	s0,0(sp)
 6f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6f2:	00000097          	auipc	ra,0x0
 6f6:	f62080e7          	jalr	-158(ra) # 654 <memmove>
}
 6fa:	60a2                	ld	ra,8(sp)
 6fc:	6402                	ld	s0,0(sp)
 6fe:	0141                	addi	sp,sp,16
 700:	8082                	ret

0000000000000702 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 702:	4885                	li	a7,1
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <exit>:
.global exit
exit:
 li a7, SYS_exit
 70a:	4889                	li	a7,2
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <wait>:
.global wait
wait:
 li a7, SYS_wait
 712:	488d                	li	a7,3
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 71a:	4891                	li	a7,4
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <read>:
.global read
read:
 li a7, SYS_read
 722:	4895                	li	a7,5
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <write>:
.global write
write:
 li a7, SYS_write
 72a:	48c1                	li	a7,16
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <close>:
.global close
close:
 li a7, SYS_close
 732:	48d5                	li	a7,21
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <kill>:
.global kill
kill:
 li a7, SYS_kill
 73a:	4899                	li	a7,6
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <exec>:
.global exec
exec:
 li a7, SYS_exec
 742:	489d                	li	a7,7
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <open>:
.global open
open:
 li a7, SYS_open
 74a:	48bd                	li	a7,15
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 752:	48c5                	li	a7,17
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 75a:	48c9                	li	a7,18
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 762:	48a1                	li	a7,8
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <link>:
.global link
link:
 li a7, SYS_link
 76a:	48cd                	li	a7,19
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 772:	48d1                	li	a7,20
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 77a:	48a5                	li	a7,9
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <dup>:
.global dup
dup:
 li a7, SYS_dup
 782:	48a9                	li	a7,10
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 78a:	48ad                	li	a7,11
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 792:	48b1                	li	a7,12
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 79a:	48b5                	li	a7,13
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7a2:	48b9                	li	a7,14
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7aa:	1101                	addi	sp,sp,-32
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7b6:	4605                	li	a2,1
 7b8:	fef40593          	addi	a1,s0,-17
 7bc:	00000097          	auipc	ra,0x0
 7c0:	f6e080e7          	jalr	-146(ra) # 72a <write>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6105                	addi	sp,sp,32
 7ca:	8082                	ret

00000000000007cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7cc:	7139                	addi	sp,sp,-64
 7ce:	fc06                	sd	ra,56(sp)
 7d0:	f822                	sd	s0,48(sp)
 7d2:	f426                	sd	s1,40(sp)
 7d4:	f04a                	sd	s2,32(sp)
 7d6:	ec4e                	sd	s3,24(sp)
 7d8:	0080                	addi	s0,sp,64
 7da:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7dc:	c299                	beqz	a3,7e2 <printint+0x16>
 7de:	0805c863          	bltz	a1,86e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7e2:	2581                	sext.w	a1,a1
  neg = 0;
 7e4:	4881                	li	a7,0
 7e6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7ec:	2601                	sext.w	a2,a2
 7ee:	00000517          	auipc	a0,0x0
 7f2:	54250513          	addi	a0,a0,1346 # d30 <digits>
 7f6:	883a                	mv	a6,a4
 7f8:	2705                	addiw	a4,a4,1
 7fa:	02c5f7bb          	remuw	a5,a1,a2
 7fe:	1782                	slli	a5,a5,0x20
 800:	9381                	srli	a5,a5,0x20
 802:	97aa                	add	a5,a5,a0
 804:	0007c783          	lbu	a5,0(a5)
 808:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 80c:	0005879b          	sext.w	a5,a1
 810:	02c5d5bb          	divuw	a1,a1,a2
 814:	0685                	addi	a3,a3,1
 816:	fec7f0e3          	bgeu	a5,a2,7f6 <printint+0x2a>
  if(neg)
 81a:	00088b63          	beqz	a7,830 <printint+0x64>
    buf[i++] = '-';
 81e:	fd040793          	addi	a5,s0,-48
 822:	973e                	add	a4,a4,a5
 824:	02d00793          	li	a5,45
 828:	fef70823          	sb	a5,-16(a4)
 82c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 830:	02e05863          	blez	a4,860 <printint+0x94>
 834:	fc040793          	addi	a5,s0,-64
 838:	00e78933          	add	s2,a5,a4
 83c:	fff78993          	addi	s3,a5,-1
 840:	99ba                	add	s3,s3,a4
 842:	377d                	addiw	a4,a4,-1
 844:	1702                	slli	a4,a4,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 84c:	fff94583          	lbu	a1,-1(s2)
 850:	8526                	mv	a0,s1
 852:	00000097          	auipc	ra,0x0
 856:	f58080e7          	jalr	-168(ra) # 7aa <putc>
  while(--i >= 0)
 85a:	197d                	addi	s2,s2,-1
 85c:	ff3918e3          	bne	s2,s3,84c <printint+0x80>
}
 860:	70e2                	ld	ra,56(sp)
 862:	7442                	ld	s0,48(sp)
 864:	74a2                	ld	s1,40(sp)
 866:	7902                	ld	s2,32(sp)
 868:	69e2                	ld	s3,24(sp)
 86a:	6121                	addi	sp,sp,64
 86c:	8082                	ret
    x = -xx;
 86e:	40b005bb          	negw	a1,a1
    neg = 1;
 872:	4885                	li	a7,1
    x = -xx;
 874:	bf8d                	j	7e6 <printint+0x1a>

0000000000000876 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 876:	7119                	addi	sp,sp,-128
 878:	fc86                	sd	ra,120(sp)
 87a:	f8a2                	sd	s0,112(sp)
 87c:	f4a6                	sd	s1,104(sp)
 87e:	f0ca                	sd	s2,96(sp)
 880:	ecce                	sd	s3,88(sp)
 882:	e8d2                	sd	s4,80(sp)
 884:	e4d6                	sd	s5,72(sp)
 886:	e0da                	sd	s6,64(sp)
 888:	fc5e                	sd	s7,56(sp)
 88a:	f862                	sd	s8,48(sp)
 88c:	f466                	sd	s9,40(sp)
 88e:	f06a                	sd	s10,32(sp)
 890:	ec6e                	sd	s11,24(sp)
 892:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 894:	0005c903          	lbu	s2,0(a1)
 898:	18090f63          	beqz	s2,a36 <vprintf+0x1c0>
 89c:	8aaa                	mv	s5,a0
 89e:	8b32                	mv	s6,a2
 8a0:	00158493          	addi	s1,a1,1
  state = 0;
 8a4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8a6:	02500a13          	li	s4,37
      if(c == 'd'){
 8aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8ae:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 8b2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 8b6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ba:	00000b97          	auipc	s7,0x0
 8be:	476b8b93          	addi	s7,s7,1142 # d30 <digits>
 8c2:	a839                	j	8e0 <vprintf+0x6a>
        putc(fd, c);
 8c4:	85ca                	mv	a1,s2
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	ee2080e7          	jalr	-286(ra) # 7aa <putc>
 8d0:	a019                	j	8d6 <vprintf+0x60>
    } else if(state == '%'){
 8d2:	01498f63          	beq	s3,s4,8f0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8d6:	0485                	addi	s1,s1,1
 8d8:	fff4c903          	lbu	s2,-1(s1)
 8dc:	14090d63          	beqz	s2,a36 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8e0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8e4:	fe0997e3          	bnez	s3,8d2 <vprintf+0x5c>
      if(c == '%'){
 8e8:	fd479ee3          	bne	a5,s4,8c4 <vprintf+0x4e>
        state = '%';
 8ec:	89be                	mv	s3,a5
 8ee:	b7e5                	j	8d6 <vprintf+0x60>
      if(c == 'd'){
 8f0:	05878063          	beq	a5,s8,930 <vprintf+0xba>
      } else if(c == 'l') {
 8f4:	05978c63          	beq	a5,s9,94c <vprintf+0xd6>
      } else if(c == 'x') {
 8f8:	07a78863          	beq	a5,s10,968 <vprintf+0xf2>
      } else if(c == 'p') {
 8fc:	09b78463          	beq	a5,s11,984 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 900:	07300713          	li	a4,115
 904:	0ce78663          	beq	a5,a4,9d0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 908:	06300713          	li	a4,99
 90c:	0ee78e63          	beq	a5,a4,a08 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 910:	11478863          	beq	a5,s4,a20 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 914:	85d2                	mv	a1,s4
 916:	8556                	mv	a0,s5
 918:	00000097          	auipc	ra,0x0
 91c:	e92080e7          	jalr	-366(ra) # 7aa <putc>
        putc(fd, c);
 920:	85ca                	mv	a1,s2
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	e86080e7          	jalr	-378(ra) # 7aa <putc>
      }
      state = 0;
 92c:	4981                	li	s3,0
 92e:	b765                	j	8d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 930:	008b0913          	addi	s2,s6,8
 934:	4685                	li	a3,1
 936:	4629                	li	a2,10
 938:	000b2583          	lw	a1,0(s6)
 93c:	8556                	mv	a0,s5
 93e:	00000097          	auipc	ra,0x0
 942:	e8e080e7          	jalr	-370(ra) # 7cc <printint>
 946:	8b4a                	mv	s6,s2
      state = 0;
 948:	4981                	li	s3,0
 94a:	b771                	j	8d6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 94c:	008b0913          	addi	s2,s6,8
 950:	4681                	li	a3,0
 952:	4629                	li	a2,10
 954:	000b2583          	lw	a1,0(s6)
 958:	8556                	mv	a0,s5
 95a:	00000097          	auipc	ra,0x0
 95e:	e72080e7          	jalr	-398(ra) # 7cc <printint>
 962:	8b4a                	mv	s6,s2
      state = 0;
 964:	4981                	li	s3,0
 966:	bf85                	j	8d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 968:	008b0913          	addi	s2,s6,8
 96c:	4681                	li	a3,0
 96e:	4641                	li	a2,16
 970:	000b2583          	lw	a1,0(s6)
 974:	8556                	mv	a0,s5
 976:	00000097          	auipc	ra,0x0
 97a:	e56080e7          	jalr	-426(ra) # 7cc <printint>
 97e:	8b4a                	mv	s6,s2
      state = 0;
 980:	4981                	li	s3,0
 982:	bf91                	j	8d6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 984:	008b0793          	addi	a5,s6,8
 988:	f8f43423          	sd	a5,-120(s0)
 98c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 990:	03000593          	li	a1,48
 994:	8556                	mv	a0,s5
 996:	00000097          	auipc	ra,0x0
 99a:	e14080e7          	jalr	-492(ra) # 7aa <putc>
  putc(fd, 'x');
 99e:	85ea                	mv	a1,s10
 9a0:	8556                	mv	a0,s5
 9a2:	00000097          	auipc	ra,0x0
 9a6:	e08080e7          	jalr	-504(ra) # 7aa <putc>
 9aa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ac:	03c9d793          	srli	a5,s3,0x3c
 9b0:	97de                	add	a5,a5,s7
 9b2:	0007c583          	lbu	a1,0(a5)
 9b6:	8556                	mv	a0,s5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	df2080e7          	jalr	-526(ra) # 7aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c0:	0992                	slli	s3,s3,0x4
 9c2:	397d                	addiw	s2,s2,-1
 9c4:	fe0914e3          	bnez	s2,9ac <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9c8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	b721                	j	8d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 9d0:	008b0993          	addi	s3,s6,8
 9d4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9d8:	02090163          	beqz	s2,9fa <vprintf+0x184>
        while(*s != 0){
 9dc:	00094583          	lbu	a1,0(s2)
 9e0:	c9a1                	beqz	a1,a30 <vprintf+0x1ba>
          putc(fd, *s);
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	dc6080e7          	jalr	-570(ra) # 7aa <putc>
          s++;
 9ec:	0905                	addi	s2,s2,1
        while(*s != 0){
 9ee:	00094583          	lbu	a1,0(s2)
 9f2:	f9e5                	bnez	a1,9e2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9f4:	8b4e                	mv	s6,s3
      state = 0;
 9f6:	4981                	li	s3,0
 9f8:	bdf9                	j	8d6 <vprintf+0x60>
          s = "(null)";
 9fa:	00000917          	auipc	s2,0x0
 9fe:	32e90913          	addi	s2,s2,814 # d28 <malloc+0x1e8>
        while(*s != 0){
 a02:	02800593          	li	a1,40
 a06:	bff1                	j	9e2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a08:	008b0913          	addi	s2,s6,8
 a0c:	000b4583          	lbu	a1,0(s6)
 a10:	8556                	mv	a0,s5
 a12:	00000097          	auipc	ra,0x0
 a16:	d98080e7          	jalr	-616(ra) # 7aa <putc>
 a1a:	8b4a                	mv	s6,s2
      state = 0;
 a1c:	4981                	li	s3,0
 a1e:	bd65                	j	8d6 <vprintf+0x60>
        putc(fd, c);
 a20:	85d2                	mv	a1,s4
 a22:	8556                	mv	a0,s5
 a24:	00000097          	auipc	ra,0x0
 a28:	d86080e7          	jalr	-634(ra) # 7aa <putc>
      state = 0;
 a2c:	4981                	li	s3,0
 a2e:	b565                	j	8d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 a30:	8b4e                	mv	s6,s3
      state = 0;
 a32:	4981                	li	s3,0
 a34:	b54d                	j	8d6 <vprintf+0x60>
    }
  }
}
 a36:	70e6                	ld	ra,120(sp)
 a38:	7446                	ld	s0,112(sp)
 a3a:	74a6                	ld	s1,104(sp)
 a3c:	7906                	ld	s2,96(sp)
 a3e:	69e6                	ld	s3,88(sp)
 a40:	6a46                	ld	s4,80(sp)
 a42:	6aa6                	ld	s5,72(sp)
 a44:	6b06                	ld	s6,64(sp)
 a46:	7be2                	ld	s7,56(sp)
 a48:	7c42                	ld	s8,48(sp)
 a4a:	7ca2                	ld	s9,40(sp)
 a4c:	7d02                	ld	s10,32(sp)
 a4e:	6de2                	ld	s11,24(sp)
 a50:	6109                	addi	sp,sp,128
 a52:	8082                	ret

0000000000000a54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a54:	715d                	addi	sp,sp,-80
 a56:	ec06                	sd	ra,24(sp)
 a58:	e822                	sd	s0,16(sp)
 a5a:	1000                	addi	s0,sp,32
 a5c:	e010                	sd	a2,0(s0)
 a5e:	e414                	sd	a3,8(s0)
 a60:	e818                	sd	a4,16(s0)
 a62:	ec1c                	sd	a5,24(s0)
 a64:	03043023          	sd	a6,32(s0)
 a68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a6c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a70:	8622                	mv	a2,s0
 a72:	00000097          	auipc	ra,0x0
 a76:	e04080e7          	jalr	-508(ra) # 876 <vprintf>
}
 a7a:	60e2                	ld	ra,24(sp)
 a7c:	6442                	ld	s0,16(sp)
 a7e:	6161                	addi	sp,sp,80
 a80:	8082                	ret

0000000000000a82 <printf>:

void
printf(const char *fmt, ...)
{
 a82:	711d                	addi	sp,sp,-96
 a84:	ec06                	sd	ra,24(sp)
 a86:	e822                	sd	s0,16(sp)
 a88:	1000                	addi	s0,sp,32
 a8a:	e40c                	sd	a1,8(s0)
 a8c:	e810                	sd	a2,16(s0)
 a8e:	ec14                	sd	a3,24(s0)
 a90:	f018                	sd	a4,32(s0)
 a92:	f41c                	sd	a5,40(s0)
 a94:	03043823          	sd	a6,48(s0)
 a98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a9c:	00840613          	addi	a2,s0,8
 aa0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 aa4:	85aa                	mv	a1,a0
 aa6:	4505                	li	a0,1
 aa8:	00000097          	auipc	ra,0x0
 aac:	dce080e7          	jalr	-562(ra) # 876 <vprintf>
}
 ab0:	60e2                	ld	ra,24(sp)
 ab2:	6442                	ld	s0,16(sp)
 ab4:	6125                	addi	sp,sp,96
 ab6:	8082                	ret

0000000000000ab8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab8:	1141                	addi	sp,sp,-16
 aba:	e422                	sd	s0,8(sp)
 abc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 abe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac2:	00000797          	auipc	a5,0x0
 ac6:	2a67b783          	ld	a5,678(a5) # d68 <freep>
 aca:	a805                	j	afa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 acc:	4618                	lw	a4,8(a2)
 ace:	9db9                	addw	a1,a1,a4
 ad0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad4:	6398                	ld	a4,0(a5)
 ad6:	6318                	ld	a4,0(a4)
 ad8:	fee53823          	sd	a4,-16(a0)
 adc:	a091                	j	b20 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ade:	ff852703          	lw	a4,-8(a0)
 ae2:	9e39                	addw	a2,a2,a4
 ae4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ae6:	ff053703          	ld	a4,-16(a0)
 aea:	e398                	sd	a4,0(a5)
 aec:	a099                	j	b32 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aee:	6398                	ld	a4,0(a5)
 af0:	00e7e463          	bltu	a5,a4,af8 <free+0x40>
 af4:	00e6ea63          	bltu	a3,a4,b08 <free+0x50>
{
 af8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afa:	fed7fae3          	bgeu	a5,a3,aee <free+0x36>
 afe:	6398                	ld	a4,0(a5)
 b00:	00e6e463          	bltu	a3,a4,b08 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b04:	fee7eae3          	bltu	a5,a4,af8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b08:	ff852583          	lw	a1,-8(a0)
 b0c:	6390                	ld	a2,0(a5)
 b0e:	02059713          	slli	a4,a1,0x20
 b12:	9301                	srli	a4,a4,0x20
 b14:	0712                	slli	a4,a4,0x4
 b16:	9736                	add	a4,a4,a3
 b18:	fae60ae3          	beq	a2,a4,acc <free+0x14>
    bp->s.ptr = p->s.ptr;
 b1c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b20:	4790                	lw	a2,8(a5)
 b22:	02061713          	slli	a4,a2,0x20
 b26:	9301                	srli	a4,a4,0x20
 b28:	0712                	slli	a4,a4,0x4
 b2a:	973e                	add	a4,a4,a5
 b2c:	fae689e3          	beq	a3,a4,ade <free+0x26>
  } else
    p->s.ptr = bp;
 b30:	e394                	sd	a3,0(a5)
  freep = p;
 b32:	00000717          	auipc	a4,0x0
 b36:	22f73b23          	sd	a5,566(a4) # d68 <freep>
}
 b3a:	6422                	ld	s0,8(sp)
 b3c:	0141                	addi	sp,sp,16
 b3e:	8082                	ret

0000000000000b40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b40:	7139                	addi	sp,sp,-64
 b42:	fc06                	sd	ra,56(sp)
 b44:	f822                	sd	s0,48(sp)
 b46:	f426                	sd	s1,40(sp)
 b48:	f04a                	sd	s2,32(sp)
 b4a:	ec4e                	sd	s3,24(sp)
 b4c:	e852                	sd	s4,16(sp)
 b4e:	e456                	sd	s5,8(sp)
 b50:	e05a                	sd	s6,0(sp)
 b52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b54:	02051493          	slli	s1,a0,0x20
 b58:	9081                	srli	s1,s1,0x20
 b5a:	04bd                	addi	s1,s1,15
 b5c:	8091                	srli	s1,s1,0x4
 b5e:	0014899b          	addiw	s3,s1,1
 b62:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b64:	00000517          	auipc	a0,0x0
 b68:	20453503          	ld	a0,516(a0) # d68 <freep>
 b6c:	c515                	beqz	a0,b98 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b70:	4798                	lw	a4,8(a5)
 b72:	02977f63          	bgeu	a4,s1,bb0 <malloc+0x70>
 b76:	8a4e                	mv	s4,s3
 b78:	0009871b          	sext.w	a4,s3
 b7c:	6685                	lui	a3,0x1
 b7e:	00d77363          	bgeu	a4,a3,b84 <malloc+0x44>
 b82:	6a05                	lui	s4,0x1
 b84:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b88:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b8c:	00000917          	auipc	s2,0x0
 b90:	1dc90913          	addi	s2,s2,476 # d68 <freep>
  if(p == (char*)-1)
 b94:	5afd                	li	s5,-1
 b96:	a88d                	j	c08 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b98:	00008797          	auipc	a5,0x8
 b9c:	3b878793          	addi	a5,a5,952 # 8f50 <base>
 ba0:	00000717          	auipc	a4,0x0
 ba4:	1cf73423          	sd	a5,456(a4) # d68 <freep>
 ba8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 baa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bae:	b7e1                	j	b76 <malloc+0x36>
      if(p->s.size == nunits)
 bb0:	02e48b63          	beq	s1,a4,be6 <malloc+0xa6>
        p->s.size -= nunits;
 bb4:	4137073b          	subw	a4,a4,s3
 bb8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bba:	1702                	slli	a4,a4,0x20
 bbc:	9301                	srli	a4,a4,0x20
 bbe:	0712                	slli	a4,a4,0x4
 bc0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bc2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bc6:	00000717          	auipc	a4,0x0
 bca:	1aa73123          	sd	a0,418(a4) # d68 <freep>
      return (void*)(p + 1);
 bce:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bd2:	70e2                	ld	ra,56(sp)
 bd4:	7442                	ld	s0,48(sp)
 bd6:	74a2                	ld	s1,40(sp)
 bd8:	7902                	ld	s2,32(sp)
 bda:	69e2                	ld	s3,24(sp)
 bdc:	6a42                	ld	s4,16(sp)
 bde:	6aa2                	ld	s5,8(sp)
 be0:	6b02                	ld	s6,0(sp)
 be2:	6121                	addi	sp,sp,64
 be4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 be6:	6398                	ld	a4,0(a5)
 be8:	e118                	sd	a4,0(a0)
 bea:	bff1                	j	bc6 <malloc+0x86>
  hp->s.size = nu;
 bec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bf0:	0541                	addi	a0,a0,16
 bf2:	00000097          	auipc	ra,0x0
 bf6:	ec6080e7          	jalr	-314(ra) # ab8 <free>
  return freep;
 bfa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bfe:	d971                	beqz	a0,bd2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c00:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c02:	4798                	lw	a4,8(a5)
 c04:	fa9776e3          	bgeu	a4,s1,bb0 <malloc+0x70>
    if(p == freep)
 c08:	00093703          	ld	a4,0(s2)
 c0c:	853e                	mv	a0,a5
 c0e:	fef719e3          	bne	a4,a5,c00 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c12:	8552                	mv	a0,s4
 c14:	00000097          	auipc	ra,0x0
 c18:	b7e080e7          	jalr	-1154(ra) # 792 <sbrk>
  if(p == (char*)-1)
 c1c:	fd5518e3          	bne	a0,s5,bec <malloc+0xac>
        return 0;
 c20:	4501                	li	a0,0
 c22:	bf45                	j	bd2 <malloc+0x92>
