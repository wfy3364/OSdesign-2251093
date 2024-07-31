
user/_nettests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:

// Decode a DNS name
static void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
       0:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
       2:	02e00813          	li	a6,46
    if(qn >= qnMax){
       6:	02b56963          	bltu	a0,a1,38 <decode_qname+0x38>
{
       a:	1141                	addi	sp,sp,-16
       c:	e406                	sd	ra,8(sp)
       e:	e022                	sd	s0,0(sp)
      10:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
      12:	00001517          	auipc	a0,0x1
      16:	07e50513          	addi	a0,a0,126 # 1090 <malloc+0xf0>
      1a:	00001097          	auipc	ra,0x1
      1e:	ec8080e7          	jalr	-312(ra) # ee2 <printf>
      exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	b36080e7          	jalr	-1226(ra) # b5a <exit>
    *qn++ = '.';
      2c:	0609                	addi	a2,a2,2
      2e:	9532                	add	a0,a0,a2
      30:	01068023          	sb	a6,0(a3)
    if(qn >= qnMax){
      34:	fcb57be3          	bgeu	a0,a1,a <decode_qname+0xa>
    int l = *qn;
      38:	00054783          	lbu	a5,0(a0)
    if(l == 0)
      3c:	c38d                	beqz	a5,5e <decode_qname+0x5e>
    for(int i = 0; i < l; i++) {
      3e:	37fd                	addiw	a5,a5,-1
      40:	02079613          	slli	a2,a5,0x20
      44:	9201                	srli	a2,a2,0x20
      46:	00160693          	addi	a3,a2,1
      4a:	96aa                	add	a3,a3,a0
    if(l == 0)
      4c:	87aa                	mv	a5,a0
      *qn = *(qn+1);
      4e:	0017c703          	lbu	a4,1(a5)
      52:	00e78023          	sb	a4,0(a5)
      qn++;
      56:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
      58:	fed79be3          	bne	a5,a3,4e <decode_qname+0x4e>
      5c:	bfc1                	j	2c <decode_qname+0x2c>
      5e:	8082                	ret

0000000000000060 <ping>:
{
      60:	7171                	addi	sp,sp,-176
      62:	f506                	sd	ra,168(sp)
      64:	f122                	sd	s0,160(sp)
      66:	ed26                	sd	s1,152(sp)
      68:	e94a                	sd	s2,144(sp)
      6a:	e54e                	sd	s3,136(sp)
      6c:	e152                	sd	s4,128(sp)
      6e:	1900                	addi	s0,sp,176
      70:	8a32                	mv	s4,a2
  if((fd = connect(dst, sport, dport)) < 0){
      72:	862e                	mv	a2,a1
      74:	85aa                	mv	a1,a0
      76:	0a000537          	lui	a0,0xa000
      7a:	20250513          	addi	a0,a0,514 # a000202 <base+0x9ffe1f2>
      7e:	00001097          	auipc	ra,0x1
      82:	b7c080e7          	jalr	-1156(ra) # bfa <connect>
      86:	08054563          	bltz	a0,110 <ping+0xb0>
      8a:	89aa                	mv	s3,a0
  for(int i = 0; i < attempts; i++) {
      8c:	4481                	li	s1,0
    if(write(fd, obuf, strlen(obuf)) < 0){
      8e:	00001917          	auipc	s2,0x1
      92:	03290913          	addi	s2,s2,50 # 10c0 <malloc+0x120>
  for(int i = 0; i < attempts; i++) {
      96:	03405463          	blez	s4,be <ping+0x5e>
    if(write(fd, obuf, strlen(obuf)) < 0){
      9a:	854a                	mv	a0,s2
      9c:	00001097          	auipc	ra,0x1
      a0:	890080e7          	jalr	-1904(ra) # 92c <strlen>
      a4:	0005061b          	sext.w	a2,a0
      a8:	85ca                	mv	a1,s2
      aa:	854e                	mv	a0,s3
      ac:	00001097          	auipc	ra,0x1
      b0:	ace080e7          	jalr	-1330(ra) # b7a <write>
      b4:	06054c63          	bltz	a0,12c <ping+0xcc>
  for(int i = 0; i < attempts; i++) {
      b8:	2485                	addiw	s1,s1,1
      ba:	fe9a10e3          	bne	s4,s1,9a <ping+0x3a>
  int cc = read(fd, ibuf, sizeof(ibuf)-1);
      be:	07f00613          	li	a2,127
      c2:	f5040593          	addi	a1,s0,-176
      c6:	854e                	mv	a0,s3
      c8:	00001097          	auipc	ra,0x1
      cc:	aaa080e7          	jalr	-1366(ra) # b72 <read>
      d0:	84aa                	mv	s1,a0
  if(cc < 0){
      d2:	06054b63          	bltz	a0,148 <ping+0xe8>
  close(fd);
      d6:	854e                	mv	a0,s3
      d8:	00001097          	auipc	ra,0x1
      dc:	aaa080e7          	jalr	-1366(ra) # b82 <close>
  ibuf[cc] = '\0';
      e0:	fd040793          	addi	a5,s0,-48
      e4:	94be                	add	s1,s1,a5
      e6:	f8048023          	sb	zero,-128(s1)
  if(strcmp(ibuf, "this is the host!") != 0){
      ea:	00001597          	auipc	a1,0x1
      ee:	01e58593          	addi	a1,a1,30 # 1108 <malloc+0x168>
      f2:	f5040513          	addi	a0,s0,-176
      f6:	00001097          	auipc	ra,0x1
      fa:	80a080e7          	jalr	-2038(ra) # 900 <strcmp>
      fe:	e13d                	bnez	a0,164 <ping+0x104>
}
     100:	70aa                	ld	ra,168(sp)
     102:	740a                	ld	s0,160(sp)
     104:	64ea                	ld	s1,152(sp)
     106:	694a                	ld	s2,144(sp)
     108:	69aa                	ld	s3,136(sp)
     10a:	6a0a                	ld	s4,128(sp)
     10c:	614d                	addi	sp,sp,176
     10e:	8082                	ret
    fprintf(2, "ping: connect() failed\n");
     110:	00001597          	auipc	a1,0x1
     114:	f9858593          	addi	a1,a1,-104 # 10a8 <malloc+0x108>
     118:	4509                	li	a0,2
     11a:	00001097          	auipc	ra,0x1
     11e:	d9a080e7          	jalr	-614(ra) # eb4 <fprintf>
    exit(1);
     122:	4505                	li	a0,1
     124:	00001097          	auipc	ra,0x1
     128:	a36080e7          	jalr	-1482(ra) # b5a <exit>
      fprintf(2, "ping: send() failed\n");
     12c:	00001597          	auipc	a1,0x1
     130:	fac58593          	addi	a1,a1,-84 # 10d8 <malloc+0x138>
     134:	4509                	li	a0,2
     136:	00001097          	auipc	ra,0x1
     13a:	d7e080e7          	jalr	-642(ra) # eb4 <fprintf>
      exit(1);
     13e:	4505                	li	a0,1
     140:	00001097          	auipc	ra,0x1
     144:	a1a080e7          	jalr	-1510(ra) # b5a <exit>
    fprintf(2, "ping: recv() failed\n");
     148:	00001597          	auipc	a1,0x1
     14c:	fa858593          	addi	a1,a1,-88 # 10f0 <malloc+0x150>
     150:	4509                	li	a0,2
     152:	00001097          	auipc	ra,0x1
     156:	d62080e7          	jalr	-670(ra) # eb4 <fprintf>
    exit(1);
     15a:	4505                	li	a0,1
     15c:	00001097          	auipc	ra,0x1
     160:	9fe080e7          	jalr	-1538(ra) # b5a <exit>
    fprintf(2, "ping didn't receive correct payload\n");
     164:	00001597          	auipc	a1,0x1
     168:	fbc58593          	addi	a1,a1,-68 # 1120 <malloc+0x180>
     16c:	4509                	li	a0,2
     16e:	00001097          	auipc	ra,0x1
     172:	d46080e7          	jalr	-698(ra) # eb4 <fprintf>
    exit(1);
     176:	4505                	li	a0,1
     178:	00001097          	auipc	ra,0x1
     17c:	9e2080e7          	jalr	-1566(ra) # b5a <exit>

0000000000000180 <dns>:
  }
}

static void
dns()
{
     180:	7119                	addi	sp,sp,-128
     182:	fc86                	sd	ra,120(sp)
     184:	f8a2                	sd	s0,112(sp)
     186:	f4a6                	sd	s1,104(sp)
     188:	f0ca                	sd	s2,96(sp)
     18a:	ecce                	sd	s3,88(sp)
     18c:	e8d2                	sd	s4,80(sp)
     18e:	e4d6                	sd	s5,72(sp)
     190:	e0da                	sd	s6,64(sp)
     192:	fc5e                	sd	s7,56(sp)
     194:	f862                	sd	s8,48(sp)
     196:	f466                	sd	s9,40(sp)
     198:	f06a                	sd	s10,32(sp)
     19a:	ec6e                	sd	s11,24(sp)
     19c:	0100                	addi	s0,sp,128
     19e:	83010113          	addi	sp,sp,-2000
  uint8 ibuf[N];
  uint32 dst;
  int fd;
  int len;

  memset(obuf, 0, N);
     1a2:	3e800613          	li	a2,1000
     1a6:	4581                	li	a1,0
     1a8:	ba840513          	addi	a0,s0,-1112
     1ac:	00000097          	auipc	ra,0x0
     1b0:	7aa080e7          	jalr	1962(ra) # 956 <memset>
  memset(ibuf, 0, N);
     1b4:	3e800613          	li	a2,1000
     1b8:	4581                	li	a1,0
     1ba:	77fd                	lui	a5,0xfffff
     1bc:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     1c0:	00f40533          	add	a0,s0,a5
     1c4:	00000097          	auipc	ra,0x0
     1c8:	792080e7          	jalr	1938(ra) # 956 <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  if((fd = connect(dst, 10000, 53)) < 0){
     1cc:	03500613          	li	a2,53
     1d0:	6589                	lui	a1,0x2
     1d2:	71058593          	addi	a1,a1,1808 # 2710 <base+0x700>
     1d6:	08081537          	lui	a0,0x8081
     1da:	80850513          	addi	a0,a0,-2040 # 8080808 <base+0x807e7f8>
     1de:	00001097          	auipc	ra,0x1
     1e2:	a1c080e7          	jalr	-1508(ra) # bfa <connect>
     1e6:	02054d63          	bltz	a0,220 <dns+0xa0>
     1ea:	89aa                	mv	s3,a0
  hdr->id = htons(6828);
     1ec:	77ed                	lui	a5,0xffffb
     1ee:	c1a7879b          	addiw	a5,a5,-998
     1f2:	baf41423          	sh	a5,-1112(s0)
  hdr->rd = 1;
     1f6:	baa45783          	lhu	a5,-1110(s0)
     1fa:	0017e793          	ori	a5,a5,1
     1fe:	baf41523          	sh	a5,-1110(s0)
  hdr->qdcount = htons(1);
     202:	10000793          	li	a5,256
     206:	baf41623          	sh	a5,-1108(s0)
  for(char *c = host; c < host+strlen(host)+1; c++) {
     20a:	00001497          	auipc	s1,0x1
     20e:	f3e48493          	addi	s1,s1,-194 # 1148 <malloc+0x1a8>
  char *l = host; 
     212:	8a26                	mv	s4,s1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     214:	bb440913          	addi	s2,s0,-1100
     218:	8aa6                	mv	s5,s1
    if(*c == '.') {
     21a:	02e00b13          	li	s6,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     21e:	a82d                	j	258 <dns+0xd8>
    fprintf(2, "ping: connect() failed\n");
     220:	00001597          	auipc	a1,0x1
     224:	e8858593          	addi	a1,a1,-376 # 10a8 <malloc+0x108>
     228:	4509                	li	a0,2
     22a:	00001097          	auipc	ra,0x1
     22e:	c8a080e7          	jalr	-886(ra) # eb4 <fprintf>
    exit(1);
     232:	4505                	li	a0,1
     234:	00001097          	auipc	ra,0x1
     238:	926080e7          	jalr	-1754(ra) # b5a <exit>
        *qn++ = *d;
     23c:	0705                	addi	a4,a4,1
     23e:	0007c603          	lbu	a2,0(a5) # ffffffffffffb000 <base+0xffffffffffff8ff0>
     242:	fec70fa3          	sb	a2,-1(a4)
      for(char *d = l; d < c; d++) {
     246:	0785                	addi	a5,a5,1
     248:	fef49ae3          	bne	s1,a5,23c <dns+0xbc>
     24c:	41448933          	sub	s2,s1,s4
     250:	9936                	add	s2,s2,a3
      l = c+1; // skip .
     252:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     256:	0485                	addi	s1,s1,1
     258:	8556                	mv	a0,s5
     25a:	00000097          	auipc	ra,0x0
     25e:	6d2080e7          	jalr	1746(ra) # 92c <strlen>
     262:	1502                	slli	a0,a0,0x20
     264:	9101                	srli	a0,a0,0x20
     266:	0505                	addi	a0,a0,1
     268:	9556                	add	a0,a0,s5
     26a:	02a4f363          	bgeu	s1,a0,290 <dns+0x110>
    if(*c == '.') {
     26e:	0004c783          	lbu	a5,0(s1)
     272:	ff6792e3          	bne	a5,s6,256 <dns+0xd6>
      *qn++ = (char) (c-l);
     276:	00190693          	addi	a3,s2,1
     27a:	414487b3          	sub	a5,s1,s4
     27e:	00f90023          	sb	a5,0(s2)
      for(char *d = l; d < c; d++) {
     282:	009a7563          	bgeu	s4,s1,28c <dns+0x10c>
     286:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     288:	8736                	mv	a4,a3
     28a:	bf4d                	j	23c <dns+0xbc>
     28c:	8936                	mv	s2,a3
     28e:	b7d1                	j	252 <dns+0xd2>
  *qn = '\0';
     290:	00090023          	sb	zero,0(s2)
  len += strlen(qname) + 1;
     294:	bb440513          	addi	a0,s0,-1100
     298:	00000097          	auipc	ra,0x0
     29c:	694080e7          	jalr	1684(ra) # 92c <strlen>
     2a0:	0005049b          	sext.w	s1,a0
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     2a4:	bb440513          	addi	a0,s0,-1100
     2a8:	00000097          	auipc	ra,0x0
     2ac:	684080e7          	jalr	1668(ra) # 92c <strlen>
     2b0:	02051793          	slli	a5,a0,0x20
     2b4:	9381                	srli	a5,a5,0x20
     2b6:	0785                	addi	a5,a5,1
     2b8:	bb440713          	addi	a4,s0,-1100
     2bc:	97ba                	add	a5,a5,a4
  h->qtype = htons(0x1);
     2be:	00078023          	sb	zero,0(a5)
     2c2:	4705                	li	a4,1
     2c4:	00e780a3          	sb	a4,1(a5)
  h->qclass = htons(0x1);
     2c8:	00078123          	sb	zero,2(a5)
     2cc:	00e781a3          	sb	a4,3(a5)
  }

  len = dns_req(obuf);
  
  if(write(fd, obuf, len) < 0){
     2d0:	0114861b          	addiw	a2,s1,17
     2d4:	ba840593          	addi	a1,s0,-1112
     2d8:	854e                	mv	a0,s3
     2da:	00001097          	auipc	ra,0x1
     2de:	8a0080e7          	jalr	-1888(ra) # b7a <write>
     2e2:	12054d63          	bltz	a0,41c <dns+0x29c>
    fprintf(2, "dns: send() failed\n");
    exit(1);
  }
  int cc = read(fd, ibuf, sizeof(ibuf));
     2e6:	3e800613          	li	a2,1000
     2ea:	77fd                	lui	a5,0xfffff
     2ec:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     2f0:	00f405b3          	add	a1,s0,a5
     2f4:	854e                	mv	a0,s3
     2f6:	00001097          	auipc	ra,0x1
     2fa:	87c080e7          	jalr	-1924(ra) # b72 <read>
     2fe:	892a                	mv	s2,a0
  if(cc < 0){
     300:	12054c63          	bltz	a0,438 <dns+0x2b8>
  if(cc < sizeof(struct dns)){
     304:	0005079b          	sext.w	a5,a0
     308:	472d                	li	a4,11
     30a:	14f77563          	bgeu	a4,a5,454 <dns+0x2d4>
  if(!hdr->qr) {
     30e:	77fd                	lui	a5,0xfffff
     310:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <base+0xffffffffffffd7b2>
     314:	97a2                	add	a5,a5,s0
     316:	00078783          	lb	a5,0(a5)
     31a:	1407da63          	bgez	a5,46e <dns+0x2ee>
  if(hdr->id != htons(6828)){
     31e:	77fd                	lui	a5,0xfffff
     320:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     324:	97a2                	add	a5,a5,s0
     326:	0007d703          	lhu	a4,0(a5)
     32a:	0007069b          	sext.w	a3,a4
     32e:	67ad                	lui	a5,0xb
     330:	c1a78793          	addi	a5,a5,-998 # ac1a <base+0x8c0a>
     334:	16f69963          	bne	a3,a5,4a6 <dns+0x326>
  if(hdr->rcode != 0) {
     338:	777d                	lui	a4,0xfffff
     33a:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <base+0xffffffffffffd7b3>
     33e:	97a2                	add	a5,a5,s0
     340:	0007c783          	lbu	a5,0(a5)
     344:	8bbd                	andi	a5,a5,15
     346:	18079463          	bnez	a5,4ce <dns+0x34e>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     34a:	7c470793          	addi	a5,a4,1988
     34e:	97a2                	add	a5,a5,s0
     350:	0007d783          	lhu	a5,0(a5)
     354:	0087d713          	srli	a4,a5,0x8
     358:	0087979b          	slliw	a5,a5,0x8
     35c:	0ff77713          	andi	a4,a4,255
     360:	8fd9                	or	a5,a5,a4
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     362:	17c2                	slli	a5,a5,0x30
     364:	93c1                	srli	a5,a5,0x30
     366:	4a81                	li	s5,0
  len = sizeof(struct dns);
     368:	44b1                	li	s1,12
  char *qname = 0;
     36a:	4a01                	li	s4,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     36c:	c7b1                	beqz	a5,3b8 <dns+0x238>
    char *qn = (char *) (ibuf+len);
     36e:	7b7d                	lui	s6,0xfffff
     370:	7c0b0793          	addi	a5,s6,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     374:	97a2                	add	a5,a5,s0
     376:	00978a33          	add	s4,a5,s1
    decode_qname(qn, cc - len);
     37a:	409905bb          	subw	a1,s2,s1
     37e:	8552                	mv	a0,s4
     380:	00000097          	auipc	ra,0x0
     384:	c80080e7          	jalr	-896(ra) # 0 <decode_qname>
    len += strlen(qn)+1;
     388:	8552                	mv	a0,s4
     38a:	00000097          	auipc	ra,0x0
     38e:	5a2080e7          	jalr	1442(ra) # 92c <strlen>
    len += sizeof(struct dns_question);
     392:	2515                	addiw	a0,a0,5
     394:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     396:	2a85                	addiw	s5,s5,1
     398:	7c4b0793          	addi	a5,s6,1988
     39c:	97a2                	add	a5,a5,s0
     39e:	0007d783          	lhu	a5,0(a5)
     3a2:	0087d713          	srli	a4,a5,0x8
     3a6:	0087979b          	slliw	a5,a5,0x8
     3aa:	0ff77713          	andi	a4,a4,255
     3ae:	8fd9                	or	a5,a5,a4
     3b0:	17c2                	slli	a5,a5,0x30
     3b2:	93c1                	srli	a5,a5,0x30
     3b4:	fafacde3          	blt	s5,a5,36e <dns+0x1ee>
     3b8:	77fd                	lui	a5,0xfffff
     3ba:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <base+0xffffffffffffd7b6>
     3be:	97a2                	add	a5,a5,s0
     3c0:	0007d783          	lhu	a5,0(a5)
     3c4:	0087d713          	srli	a4,a5,0x8
     3c8:	0087979b          	slliw	a5,a5,0x8
     3cc:	0ff77713          	andi	a4,a4,255
     3d0:	8fd9                	or	a5,a5,a4
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3d2:	17c2                	slli	a5,a5,0x30
     3d4:	93c1                	srli	a5,a5,0x30
     3d6:	26078963          	beqz	a5,648 <dns+0x4c8>
    if(len >= cc){
     3da:	1124de63          	bge	s1,s2,4f6 <dns+0x376>
     3de:	00001797          	auipc	a5,0x1
     3e2:	eaa78793          	addi	a5,a5,-342 # 1288 <malloc+0x2e8>
     3e6:	000a0363          	beqz	s4,3ec <dns+0x26c>
     3ea:	87d2                	mv	a5,s4
     3ec:	76fd                	lui	a3,0xfffff
     3ee:	7b068713          	addi	a4,a3,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     3f2:	9722                	add	a4,a4,s0
     3f4:	e31c                	sd	a5,0(a4)
  int record = 0;
     3f6:	7b868793          	addi	a5,a3,1976
     3fa:	97a2                	add	a5,a5,s0
     3fc:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     400:	4a01                	li	s4,0
    if((int) qn[0] > 63) {  // compression?
     402:	03f00d93          	li	s11,63
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     406:	4a85                	li	s5,1
     408:	4d11                	li	s10,4
      printf("DNS arecord for %s is ", qname ? qname : "" );
     40a:	00001c97          	auipc	s9,0x1
     40e:	de6c8c93          	addi	s9,s9,-538 # 11f0 <malloc+0x250>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     412:	08000c13          	li	s8,128
     416:	03400b93          	li	s7,52
     41a:	aa99                	j	570 <dns+0x3f0>
    fprintf(2, "dns: send() failed\n");
     41c:	00001597          	auipc	a1,0x1
     420:	d4458593          	addi	a1,a1,-700 # 1160 <malloc+0x1c0>
     424:	4509                	li	a0,2
     426:	00001097          	auipc	ra,0x1
     42a:	a8e080e7          	jalr	-1394(ra) # eb4 <fprintf>
    exit(1);
     42e:	4505                	li	a0,1
     430:	00000097          	auipc	ra,0x0
     434:	72a080e7          	jalr	1834(ra) # b5a <exit>
    fprintf(2, "dns: recv() failed\n");
     438:	00001597          	auipc	a1,0x1
     43c:	d4058593          	addi	a1,a1,-704 # 1178 <malloc+0x1d8>
     440:	4509                	li	a0,2
     442:	00001097          	auipc	ra,0x1
     446:	a72080e7          	jalr	-1422(ra) # eb4 <fprintf>
    exit(1);
     44a:	4505                	li	a0,1
     44c:	00000097          	auipc	ra,0x0
     450:	70e080e7          	jalr	1806(ra) # b5a <exit>
    printf("DNS reply too short\n");
     454:	00001517          	auipc	a0,0x1
     458:	d3c50513          	addi	a0,a0,-708 # 1190 <malloc+0x1f0>
     45c:	00001097          	auipc	ra,0x1
     460:	a86080e7          	jalr	-1402(ra) # ee2 <printf>
    exit(1);
     464:	4505                	li	a0,1
     466:	00000097          	auipc	ra,0x0
     46a:	6f4080e7          	jalr	1780(ra) # b5a <exit>
     46e:	77fd                	lui	a5,0xfffff
     470:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     474:	97a2                	add	a5,a5,s0
     476:	0007d783          	lhu	a5,0(a5)
     47a:	0087d593          	srli	a1,a5,0x8
     47e:	0087979b          	slliw	a5,a5,0x8
     482:	0ff5f593          	andi	a1,a1,255
     486:	8ddd                	or	a1,a1,a5
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     488:	15c2                	slli	a1,a1,0x30
     48a:	91c1                	srli	a1,a1,0x30
     48c:	00001517          	auipc	a0,0x1
     490:	d1c50513          	addi	a0,a0,-740 # 11a8 <malloc+0x208>
     494:	00001097          	auipc	ra,0x1
     498:	a4e080e7          	jalr	-1458(ra) # ee2 <printf>
    exit(1);
     49c:	4505                	li	a0,1
     49e:	00000097          	auipc	ra,0x0
     4a2:	6bc080e7          	jalr	1724(ra) # b5a <exit>
     4a6:	0087559b          	srliw	a1,a4,0x8
     4aa:	0087171b          	slliw	a4,a4,0x8
     4ae:	8dd9                	or	a1,a1,a4
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
     4b0:	15c2                	slli	a1,a1,0x30
     4b2:	91c1                	srli	a1,a1,0x30
     4b4:	00001517          	auipc	a0,0x1
     4b8:	d0c50513          	addi	a0,a0,-756 # 11c0 <malloc+0x220>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	a26080e7          	jalr	-1498(ra) # ee2 <printf>
    exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00000097          	auipc	ra,0x0
     4ca:	694080e7          	jalr	1684(ra) # b5a <exit>
    printf("DNS rcode error: %x\n", hdr->rcode);
     4ce:	77fd                	lui	a5,0xfffff
     4d0:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <base+0xffffffffffffd7b3>
     4d4:	97a2                	add	a5,a5,s0
     4d6:	0007c583          	lbu	a1,0(a5)
     4da:	89bd                	andi	a1,a1,15
     4dc:	00001517          	auipc	a0,0x1
     4e0:	cfc50513          	addi	a0,a0,-772 # 11d8 <malloc+0x238>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	9fe080e7          	jalr	-1538(ra) # ee2 <printf>
    exit(1);
     4ec:	4505                	li	a0,1
     4ee:	00000097          	auipc	ra,0x0
     4f2:	66c080e7          	jalr	1644(ra) # b5a <exit>
      printf("invalid DNS reply\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	b9a50513          	addi	a0,a0,-1126 # 1090 <malloc+0xf0>
     4fe:	00001097          	auipc	ra,0x1
     502:	9e4080e7          	jalr	-1564(ra) # ee2 <printf>
      exit(1);
     506:	4505                	li	a0,1
     508:	00000097          	auipc	ra,0x0
     50c:	652080e7          	jalr	1618(ra) # b5a <exit>
      decode_qname(qn, cc - len);
     510:	409905bb          	subw	a1,s2,s1
     514:	855a                	mv	a0,s6
     516:	00000097          	auipc	ra,0x0
     51a:	aea080e7          	jalr	-1302(ra) # 0 <decode_qname>
      len += strlen(qn)+1;
     51e:	855a                	mv	a0,s6
     520:	00000097          	auipc	ra,0x0
     524:	40c080e7          	jalr	1036(ra) # 92c <strlen>
     528:	2485                	addiw	s1,s1,1
     52a:	9ca9                	addw	s1,s1,a0
     52c:	a8a9                	j	586 <dns+0x406>
        printf("wrong ip address");
     52e:	00001517          	auipc	a0,0x1
     532:	cea50513          	addi	a0,a0,-790 # 1218 <malloc+0x278>
     536:	00001097          	auipc	ra,0x1
     53a:	9ac080e7          	jalr	-1620(ra) # ee2 <printf>
        exit(1);
     53e:	4505                	li	a0,1
     540:	00000097          	auipc	ra,0x0
     544:	61a080e7          	jalr	1562(ra) # b5a <exit>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     548:	2a05                	addiw	s4,s4,1
     54a:	77fd                	lui	a5,0xfffff
     54c:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <base+0xffffffffffffd7b6>
     550:	97a2                	add	a5,a5,s0
     552:	0007d783          	lhu	a5,0(a5)
     556:	0087d713          	srli	a4,a5,0x8
     55a:	0087979b          	slliw	a5,a5,0x8
     55e:	0ff77713          	andi	a4,a4,255
     562:	8fd9                	or	a5,a5,a4
     564:	17c2                	slli	a5,a5,0x30
     566:	93c1                	srli	a5,a5,0x30
     568:	0efa5663          	bge	s4,a5,654 <dns+0x4d4>
    if(len >= cc){
     56c:	f924d5e3          	bge	s1,s2,4f6 <dns+0x376>
    char *qn = (char *) (ibuf+len);
     570:	77fd                	lui	a5,0xfffff
     572:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     576:	97a2                	add	a5,a5,s0
     578:	00978b33          	add	s6,a5,s1
    if((int) qn[0] > 63) {  // compression?
     57c:	000b4783          	lbu	a5,0(s6)
     580:	f8fdf8e3          	bgeu	s11,a5,510 <dns+0x390>
      len += 2;
     584:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     586:	77fd                	lui	a5,0xfffff
     588:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     58c:	97a2                	add	a5,a5,s0
     58e:	009786b3          	add	a3,a5,s1
    len += sizeof(struct dns_data);
     592:	00048b1b          	sext.w	s6,s1
     596:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     598:	0006c783          	lbu	a5,0(a3)
     59c:	0016c703          	lbu	a4,1(a3)
     5a0:	0722                	slli	a4,a4,0x8
     5a2:	8fd9                	or	a5,a5,a4
     5a4:	0087979b          	slliw	a5,a5,0x8
     5a8:	8321                	srli	a4,a4,0x8
     5aa:	8fd9                	or	a5,a5,a4
     5ac:	17c2                	slli	a5,a5,0x30
     5ae:	93c1                	srli	a5,a5,0x30
     5b0:	f9579ce3          	bne	a5,s5,548 <dns+0x3c8>
     5b4:	0086c783          	lbu	a5,8(a3)
     5b8:	0096c703          	lbu	a4,9(a3)
     5bc:	0722                	slli	a4,a4,0x8
     5be:	8fd9                	or	a5,a5,a4
     5c0:	0087979b          	slliw	a5,a5,0x8
     5c4:	8321                	srli	a4,a4,0x8
     5c6:	8fd9                	or	a5,a5,a4
     5c8:	17c2                	slli	a5,a5,0x30
     5ca:	93c1                	srli	a5,a5,0x30
     5cc:	f7a79ee3          	bne	a5,s10,548 <dns+0x3c8>
      printf("DNS arecord for %s is ", qname ? qname : "" );
     5d0:	77fd                	lui	a5,0xfffff
     5d2:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     5d6:	97a2                	add	a5,a5,s0
     5d8:	638c                	ld	a1,0(a5)
     5da:	8566                	mv	a0,s9
     5dc:	00001097          	auipc	ra,0x1
     5e0:	906080e7          	jalr	-1786(ra) # ee2 <printf>
      uint8 *ip = (ibuf+len);
     5e4:	77fd                	lui	a5,0xfffff
     5e6:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     5ea:	97a2                	add	a5,a5,s0
     5ec:	94be                	add	s1,s1,a5
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     5ee:	0034c703          	lbu	a4,3(s1)
     5f2:	0024c683          	lbu	a3,2(s1)
     5f6:	0014c603          	lbu	a2,1(s1)
     5fa:	0004c583          	lbu	a1,0(s1)
     5fe:	00001517          	auipc	a0,0x1
     602:	c0a50513          	addi	a0,a0,-1014 # 1208 <malloc+0x268>
     606:	00001097          	auipc	ra,0x1
     60a:	8dc080e7          	jalr	-1828(ra) # ee2 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     60e:	0004c783          	lbu	a5,0(s1)
     612:	f1879ee3          	bne	a5,s8,52e <dns+0x3ae>
     616:	0014c783          	lbu	a5,1(s1)
     61a:	f1779ae3          	bne	a5,s7,52e <dns+0x3ae>
     61e:	0024c703          	lbu	a4,2(s1)
     622:	08100793          	li	a5,129
     626:	f0f714e3          	bne	a4,a5,52e <dns+0x3ae>
     62a:	0034c703          	lbu	a4,3(s1)
     62e:	07e00793          	li	a5,126
     632:	eef71ee3          	bne	a4,a5,52e <dns+0x3ae>
      len += 4;
     636:	00eb049b          	addiw	s1,s6,14
      record = 1;
     63a:	77fd                	lui	a5,0xfffff
     63c:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     640:	97a2                	add	a5,a5,s0
     642:	0157b023          	sd	s5,0(a5)
     646:	b709                	j	548 <dns+0x3c8>
  int record = 0;
     648:	77fd                	lui	a5,0xfffff
     64a:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     64e:	97a2                	add	a5,a5,s0
     650:	0007b023          	sd	zero,0(a5)
     654:	77fd                	lui	a5,0xfffff
     656:	7ca78793          	addi	a5,a5,1994 # fffffffffffff7ca <base+0xffffffffffffd7ba>
     65a:	97a2                	add	a5,a5,s0
     65c:	0007d783          	lhu	a5,0(a5)
     660:	0087d693          	srli	a3,a5,0x8
     664:	0087971b          	slliw	a4,a5,0x8
     668:	0ff6f793          	andi	a5,a3,255
     66c:	8f5d                	or	a4,a4,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     66e:	1742                	slli	a4,a4,0x30
     670:	9341                	srli	a4,a4,0x30
     672:	06e05363          	blez	a4,6d8 <dns+0x558>
     676:	4581                	li	a1,0
    if(ntohs(d->type) != 41) {
     678:	02900513          	li	a0,41
    if(*qn != 0) {
     67c:	f9040793          	addi	a5,s0,-112
     680:	97a6                	add	a5,a5,s1
     682:	8307c783          	lbu	a5,-2000(a5)
     686:	e7d9                	bnez	a5,714 <dns+0x594>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     688:	0014869b          	addiw	a3,s1,1
     68c:	77fd                	lui	a5,0xfffff
     68e:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     692:	97a2                	add	a5,a5,s0
     694:	96be                	add	a3,a3,a5
    len += sizeof(struct dns_data);
     696:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
     698:	0006c783          	lbu	a5,0(a3)
     69c:	0016c603          	lbu	a2,1(a3)
     6a0:	0622                	slli	a2,a2,0x8
     6a2:	8fd1                	or	a5,a5,a2
     6a4:	0087979b          	slliw	a5,a5,0x8
     6a8:	8221                	srli	a2,a2,0x8
     6aa:	8fd1                	or	a5,a5,a2
     6ac:	17c2                	slli	a5,a5,0x30
     6ae:	93c1                	srli	a5,a5,0x30
     6b0:	06a79f63          	bne	a5,a0,72e <dns+0x5ae>
    len += ntohs(d->len);
     6b4:	0086c783          	lbu	a5,8(a3)
     6b8:	0096c683          	lbu	a3,9(a3)
     6bc:	06a2                	slli	a3,a3,0x8
     6be:	8fd5                	or	a5,a5,a3
     6c0:	0087979b          	slliw	a5,a5,0x8
     6c4:	82a1                	srli	a3,a3,0x8
     6c6:	8fd5                	or	a5,a5,a3
     6c8:	0107979b          	slliw	a5,a5,0x10
     6cc:	0107d79b          	srliw	a5,a5,0x10
     6d0:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     6d2:	2585                	addiw	a1,a1,1
     6d4:	fab714e3          	bne	a4,a1,67c <dns+0x4fc>
  if(len != cc) {
     6d8:	06991863          	bne	s2,s1,748 <dns+0x5c8>
  if(!record) {
     6dc:	77fd                	lui	a5,0xfffff
     6de:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     6e2:	97a2                	add	a5,a5,s0
     6e4:	639c                	ld	a5,0(a5)
     6e6:	c3c1                	beqz	a5,766 <dns+0x5e6>
  }
  dns_rep(ibuf, cc);

  close(fd);
     6e8:	854e                	mv	a0,s3
     6ea:	00000097          	auipc	ra,0x0
     6ee:	498080e7          	jalr	1176(ra) # b82 <close>
}  
     6f2:	7d010113          	addi	sp,sp,2000
     6f6:	70e6                	ld	ra,120(sp)
     6f8:	7446                	ld	s0,112(sp)
     6fa:	74a6                	ld	s1,104(sp)
     6fc:	7906                	ld	s2,96(sp)
     6fe:	69e6                	ld	s3,88(sp)
     700:	6a46                	ld	s4,80(sp)
     702:	6aa6                	ld	s5,72(sp)
     704:	6b06                	ld	s6,64(sp)
     706:	7be2                	ld	s7,56(sp)
     708:	7c42                	ld	s8,48(sp)
     70a:	7ca2                	ld	s9,40(sp)
     70c:	7d02                	ld	s10,32(sp)
     70e:	6de2                	ld	s11,24(sp)
     710:	6109                	addi	sp,sp,128
     712:	8082                	ret
      printf("invalid name for EDNS\n");
     714:	00001517          	auipc	a0,0x1
     718:	b1c50513          	addi	a0,a0,-1252 # 1230 <malloc+0x290>
     71c:	00000097          	auipc	ra,0x0
     720:	7c6080e7          	jalr	1990(ra) # ee2 <printf>
      exit(1);
     724:	4505                	li	a0,1
     726:	00000097          	auipc	ra,0x0
     72a:	434080e7          	jalr	1076(ra) # b5a <exit>
      printf("invalid type for EDNS\n");
     72e:	00001517          	auipc	a0,0x1
     732:	b1a50513          	addi	a0,a0,-1254 # 1248 <malloc+0x2a8>
     736:	00000097          	auipc	ra,0x0
     73a:	7ac080e7          	jalr	1964(ra) # ee2 <printf>
      exit(1);
     73e:	4505                	li	a0,1
     740:	00000097          	auipc	ra,0x0
     744:	41a080e7          	jalr	1050(ra) # b5a <exit>
    printf("Processed %d data bytes but received %d\n", len, cc);
     748:	864a                	mv	a2,s2
     74a:	85a6                	mv	a1,s1
     74c:	00001517          	auipc	a0,0x1
     750:	b1450513          	addi	a0,a0,-1260 # 1260 <malloc+0x2c0>
     754:	00000097          	auipc	ra,0x0
     758:	78e080e7          	jalr	1934(ra) # ee2 <printf>
    exit(1);
     75c:	4505                	li	a0,1
     75e:	00000097          	auipc	ra,0x0
     762:	3fc080e7          	jalr	1020(ra) # b5a <exit>
    printf("Didn't receive an arecord\n");
     766:	00001517          	auipc	a0,0x1
     76a:	b2a50513          	addi	a0,a0,-1238 # 1290 <malloc+0x2f0>
     76e:	00000097          	auipc	ra,0x0
     772:	774080e7          	jalr	1908(ra) # ee2 <printf>
    exit(1);
     776:	4505                	li	a0,1
     778:	00000097          	auipc	ra,0x0
     77c:	3e2080e7          	jalr	994(ra) # b5a <exit>

0000000000000780 <main>:

int
main(int argc, char *argv[])
{
     780:	7179                	addi	sp,sp,-48
     782:	f406                	sd	ra,40(sp)
     784:	f022                	sd	s0,32(sp)
     786:	ec26                	sd	s1,24(sp)
     788:	e84a                	sd	s2,16(sp)
     78a:	1800                	addi	s0,sp,48
  int i, ret;
  uint16 dport = NET_TESTS_PORT;

  printf("nettests running on port %d\n", dport);
     78c:	6499                	lui	s1,0x6
     78e:	5f348593          	addi	a1,s1,1523 # 65f3 <base+0x45e3>
     792:	00001517          	auipc	a0,0x1
     796:	b1e50513          	addi	a0,a0,-1250 # 12b0 <malloc+0x310>
     79a:	00000097          	auipc	ra,0x0
     79e:	748080e7          	jalr	1864(ra) # ee2 <printf>
  
  printf("testing ping: ");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	b2e50513          	addi	a0,a0,-1234 # 12d0 <malloc+0x330>
     7aa:	00000097          	auipc	ra,0x0
     7ae:	738080e7          	jalr	1848(ra) # ee2 <printf>
  ping(2000, dport, 1);
     7b2:	4605                	li	a2,1
     7b4:	5f348593          	addi	a1,s1,1523
     7b8:	7d000513          	li	a0,2000
     7bc:	00000097          	auipc	ra,0x0
     7c0:	8a4080e7          	jalr	-1884(ra) # 60 <ping>
  printf("OK\n");
     7c4:	00001517          	auipc	a0,0x1
     7c8:	b1c50513          	addi	a0,a0,-1252 # 12e0 <malloc+0x340>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	716080e7          	jalr	1814(ra) # ee2 <printf>
  
  printf("testing single-process pings: ");
     7d4:	00001517          	auipc	a0,0x1
     7d8:	b1450513          	addi	a0,a0,-1260 # 12e8 <malloc+0x348>
     7dc:	00000097          	auipc	ra,0x0
     7e0:	706080e7          	jalr	1798(ra) # ee2 <printf>
     7e4:	06400493          	li	s1,100
  for (i = 0; i < 100; i++)
    ping(2000, dport, 1);
     7e8:	6919                	lui	s2,0x6
     7ea:	5f390913          	addi	s2,s2,1523 # 65f3 <base+0x45e3>
     7ee:	4605                	li	a2,1
     7f0:	85ca                	mv	a1,s2
     7f2:	7d000513          	li	a0,2000
     7f6:	00000097          	auipc	ra,0x0
     7fa:	86a080e7          	jalr	-1942(ra) # 60 <ping>
  for (i = 0; i < 100; i++)
     7fe:	34fd                	addiw	s1,s1,-1
     800:	f4fd                	bnez	s1,7ee <main+0x6e>
  printf("OK\n");
     802:	00001517          	auipc	a0,0x1
     806:	ade50513          	addi	a0,a0,-1314 # 12e0 <malloc+0x340>
     80a:	00000097          	auipc	ra,0x0
     80e:	6d8080e7          	jalr	1752(ra) # ee2 <printf>
  
  printf("testing multi-process pings: ");
     812:	00001517          	auipc	a0,0x1
     816:	af650513          	addi	a0,a0,-1290 # 1308 <malloc+0x368>
     81a:	00000097          	auipc	ra,0x0
     81e:	6c8080e7          	jalr	1736(ra) # ee2 <printf>
  for (i = 0; i < 10; i++){
     822:	4929                	li	s2,10
    int pid = fork();
     824:	00000097          	auipc	ra,0x0
     828:	32e080e7          	jalr	814(ra) # b52 <fork>
    if (pid == 0){
     82c:	c92d                	beqz	a0,89e <main+0x11e>
  for (i = 0; i < 10; i++){
     82e:	2485                	addiw	s1,s1,1
     830:	ff249ae3          	bne	s1,s2,824 <main+0xa4>
     834:	44a9                	li	s1,10
      ping(2000 + i + 1, dport, 1);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++){
    wait(&ret);
     836:	fdc40513          	addi	a0,s0,-36
     83a:	00000097          	auipc	ra,0x0
     83e:	328080e7          	jalr	808(ra) # b62 <wait>
    if (ret != 0)
     842:	fdc42783          	lw	a5,-36(s0)
     846:	efad                	bnez	a5,8c0 <main+0x140>
  for (i = 0; i < 10; i++){
     848:	34fd                	addiw	s1,s1,-1
     84a:	f4f5                	bnez	s1,836 <main+0xb6>
      exit(1);
  }
  printf("OK\n");
     84c:	00001517          	auipc	a0,0x1
     850:	a9450513          	addi	a0,a0,-1388 # 12e0 <malloc+0x340>
     854:	00000097          	auipc	ra,0x0
     858:	68e080e7          	jalr	1678(ra) # ee2 <printf>
  
  printf("testing DNS\n");
     85c:	00001517          	auipc	a0,0x1
     860:	acc50513          	addi	a0,a0,-1332 # 1328 <malloc+0x388>
     864:	00000097          	auipc	ra,0x0
     868:	67e080e7          	jalr	1662(ra) # ee2 <printf>
  dns();
     86c:	00000097          	auipc	ra,0x0
     870:	914080e7          	jalr	-1772(ra) # 180 <dns>
  printf("DNS OK\n");
     874:	00001517          	auipc	a0,0x1
     878:	ac450513          	addi	a0,a0,-1340 # 1338 <malloc+0x398>
     87c:	00000097          	auipc	ra,0x0
     880:	666080e7          	jalr	1638(ra) # ee2 <printf>
  
  printf("all tests passed.\n");
     884:	00001517          	auipc	a0,0x1
     888:	abc50513          	addi	a0,a0,-1348 # 1340 <malloc+0x3a0>
     88c:	00000097          	auipc	ra,0x0
     890:	656080e7          	jalr	1622(ra) # ee2 <printf>
  exit(0);
     894:	4501                	li	a0,0
     896:	00000097          	auipc	ra,0x0
     89a:	2c4080e7          	jalr	708(ra) # b5a <exit>
      ping(2000 + i + 1, dport, 1);
     89e:	7d14851b          	addiw	a0,s1,2001
     8a2:	4605                	li	a2,1
     8a4:	6599                	lui	a1,0x6
     8a6:	5f358593          	addi	a1,a1,1523 # 65f3 <base+0x45e3>
     8aa:	1542                	slli	a0,a0,0x30
     8ac:	9141                	srli	a0,a0,0x30
     8ae:	fffff097          	auipc	ra,0xfffff
     8b2:	7b2080e7          	jalr	1970(ra) # 60 <ping>
      exit(0);
     8b6:	4501                	li	a0,0
     8b8:	00000097          	auipc	ra,0x0
     8bc:	2a2080e7          	jalr	674(ra) # b5a <exit>
      exit(1);
     8c0:	4505                	li	a0,1
     8c2:	00000097          	auipc	ra,0x0
     8c6:	298080e7          	jalr	664(ra) # b5a <exit>

00000000000008ca <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     8ca:	1141                	addi	sp,sp,-16
     8cc:	e406                	sd	ra,8(sp)
     8ce:	e022                	sd	s0,0(sp)
     8d0:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8d2:	00000097          	auipc	ra,0x0
     8d6:	eae080e7          	jalr	-338(ra) # 780 <main>
  exit(0);
     8da:	4501                	li	a0,0
     8dc:	00000097          	auipc	ra,0x0
     8e0:	27e080e7          	jalr	638(ra) # b5a <exit>

00000000000008e4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8e4:	1141                	addi	sp,sp,-16
     8e6:	e422                	sd	s0,8(sp)
     8e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8ea:	87aa                	mv	a5,a0
     8ec:	0585                	addi	a1,a1,1
     8ee:	0785                	addi	a5,a5,1
     8f0:	fff5c703          	lbu	a4,-1(a1)
     8f4:	fee78fa3          	sb	a4,-1(a5)
     8f8:	fb75                	bnez	a4,8ec <strcpy+0x8>
    ;
  return os;
}
     8fa:	6422                	ld	s0,8(sp)
     8fc:	0141                	addi	sp,sp,16
     8fe:	8082                	ret

0000000000000900 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     900:	1141                	addi	sp,sp,-16
     902:	e422                	sd	s0,8(sp)
     904:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     906:	00054783          	lbu	a5,0(a0)
     90a:	cb91                	beqz	a5,91e <strcmp+0x1e>
     90c:	0005c703          	lbu	a4,0(a1)
     910:	00f71763          	bne	a4,a5,91e <strcmp+0x1e>
    p++, q++;
     914:	0505                	addi	a0,a0,1
     916:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     918:	00054783          	lbu	a5,0(a0)
     91c:	fbe5                	bnez	a5,90c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     91e:	0005c503          	lbu	a0,0(a1)
}
     922:	40a7853b          	subw	a0,a5,a0
     926:	6422                	ld	s0,8(sp)
     928:	0141                	addi	sp,sp,16
     92a:	8082                	ret

000000000000092c <strlen>:

uint
strlen(const char *s)
{
     92c:	1141                	addi	sp,sp,-16
     92e:	e422                	sd	s0,8(sp)
     930:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     932:	00054783          	lbu	a5,0(a0)
     936:	cf91                	beqz	a5,952 <strlen+0x26>
     938:	0505                	addi	a0,a0,1
     93a:	87aa                	mv	a5,a0
     93c:	4685                	li	a3,1
     93e:	9e89                	subw	a3,a3,a0
     940:	00f6853b          	addw	a0,a3,a5
     944:	0785                	addi	a5,a5,1
     946:	fff7c703          	lbu	a4,-1(a5)
     94a:	fb7d                	bnez	a4,940 <strlen+0x14>
    ;
  return n;
}
     94c:	6422                	ld	s0,8(sp)
     94e:	0141                	addi	sp,sp,16
     950:	8082                	ret
  for(n = 0; s[n]; n++)
     952:	4501                	li	a0,0
     954:	bfe5                	j	94c <strlen+0x20>

0000000000000956 <memset>:

void*
memset(void *dst, int c, uint n)
{
     956:	1141                	addi	sp,sp,-16
     958:	e422                	sd	s0,8(sp)
     95a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     95c:	ce09                	beqz	a2,976 <memset+0x20>
     95e:	87aa                	mv	a5,a0
     960:	fff6071b          	addiw	a4,a2,-1
     964:	1702                	slli	a4,a4,0x20
     966:	9301                	srli	a4,a4,0x20
     968:	0705                	addi	a4,a4,1
     96a:	972a                	add	a4,a4,a0
    cdst[i] = c;
     96c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     970:	0785                	addi	a5,a5,1
     972:	fee79de3          	bne	a5,a4,96c <memset+0x16>
  }
  return dst;
}
     976:	6422                	ld	s0,8(sp)
     978:	0141                	addi	sp,sp,16
     97a:	8082                	ret

000000000000097c <strchr>:

char*
strchr(const char *s, char c)
{
     97c:	1141                	addi	sp,sp,-16
     97e:	e422                	sd	s0,8(sp)
     980:	0800                	addi	s0,sp,16
  for(; *s; s++)
     982:	00054783          	lbu	a5,0(a0)
     986:	cb99                	beqz	a5,99c <strchr+0x20>
    if(*s == c)
     988:	00f58763          	beq	a1,a5,996 <strchr+0x1a>
  for(; *s; s++)
     98c:	0505                	addi	a0,a0,1
     98e:	00054783          	lbu	a5,0(a0)
     992:	fbfd                	bnez	a5,988 <strchr+0xc>
      return (char*)s;
  return 0;
     994:	4501                	li	a0,0
}
     996:	6422                	ld	s0,8(sp)
     998:	0141                	addi	sp,sp,16
     99a:	8082                	ret
  return 0;
     99c:	4501                	li	a0,0
     99e:	bfe5                	j	996 <strchr+0x1a>

00000000000009a0 <gets>:

char*
gets(char *buf, int max)
{
     9a0:	711d                	addi	sp,sp,-96
     9a2:	ec86                	sd	ra,88(sp)
     9a4:	e8a2                	sd	s0,80(sp)
     9a6:	e4a6                	sd	s1,72(sp)
     9a8:	e0ca                	sd	s2,64(sp)
     9aa:	fc4e                	sd	s3,56(sp)
     9ac:	f852                	sd	s4,48(sp)
     9ae:	f456                	sd	s5,40(sp)
     9b0:	f05a                	sd	s6,32(sp)
     9b2:	ec5e                	sd	s7,24(sp)
     9b4:	1080                	addi	s0,sp,96
     9b6:	8baa                	mv	s7,a0
     9b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9ba:	892a                	mv	s2,a0
     9bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9be:	4aa9                	li	s5,10
     9c0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9c2:	89a6                	mv	s3,s1
     9c4:	2485                	addiw	s1,s1,1
     9c6:	0344d863          	bge	s1,s4,9f6 <gets+0x56>
    cc = read(0, &c, 1);
     9ca:	4605                	li	a2,1
     9cc:	faf40593          	addi	a1,s0,-81
     9d0:	4501                	li	a0,0
     9d2:	00000097          	auipc	ra,0x0
     9d6:	1a0080e7          	jalr	416(ra) # b72 <read>
    if(cc < 1)
     9da:	00a05e63          	blez	a0,9f6 <gets+0x56>
    buf[i++] = c;
     9de:	faf44783          	lbu	a5,-81(s0)
     9e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9e6:	01578763          	beq	a5,s5,9f4 <gets+0x54>
     9ea:	0905                	addi	s2,s2,1
     9ec:	fd679be3          	bne	a5,s6,9c2 <gets+0x22>
  for(i=0; i+1 < max; ){
     9f0:	89a6                	mv	s3,s1
     9f2:	a011                	j	9f6 <gets+0x56>
     9f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9f6:	99de                	add	s3,s3,s7
     9f8:	00098023          	sb	zero,0(s3)
  return buf;
}
     9fc:	855e                	mv	a0,s7
     9fe:	60e6                	ld	ra,88(sp)
     a00:	6446                	ld	s0,80(sp)
     a02:	64a6                	ld	s1,72(sp)
     a04:	6906                	ld	s2,64(sp)
     a06:	79e2                	ld	s3,56(sp)
     a08:	7a42                	ld	s4,48(sp)
     a0a:	7aa2                	ld	s5,40(sp)
     a0c:	7b02                	ld	s6,32(sp)
     a0e:	6be2                	ld	s7,24(sp)
     a10:	6125                	addi	sp,sp,96
     a12:	8082                	ret

0000000000000a14 <stat>:

int
stat(const char *n, struct stat *st)
{
     a14:	1101                	addi	sp,sp,-32
     a16:	ec06                	sd	ra,24(sp)
     a18:	e822                	sd	s0,16(sp)
     a1a:	e426                	sd	s1,8(sp)
     a1c:	e04a                	sd	s2,0(sp)
     a1e:	1000                	addi	s0,sp,32
     a20:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	00000097          	auipc	ra,0x0
     a28:	176080e7          	jalr	374(ra) # b9a <open>
  if(fd < 0)
     a2c:	02054563          	bltz	a0,a56 <stat+0x42>
     a30:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a32:	85ca                	mv	a1,s2
     a34:	00000097          	auipc	ra,0x0
     a38:	17e080e7          	jalr	382(ra) # bb2 <fstat>
     a3c:	892a                	mv	s2,a0
  close(fd);
     a3e:	8526                	mv	a0,s1
     a40:	00000097          	auipc	ra,0x0
     a44:	142080e7          	jalr	322(ra) # b82 <close>
  return r;
}
     a48:	854a                	mv	a0,s2
     a4a:	60e2                	ld	ra,24(sp)
     a4c:	6442                	ld	s0,16(sp)
     a4e:	64a2                	ld	s1,8(sp)
     a50:	6902                	ld	s2,0(sp)
     a52:	6105                	addi	sp,sp,32
     a54:	8082                	ret
    return -1;
     a56:	597d                	li	s2,-1
     a58:	bfc5                	j	a48 <stat+0x34>

0000000000000a5a <atoi>:

int
atoi(const char *s)
{
     a5a:	1141                	addi	sp,sp,-16
     a5c:	e422                	sd	s0,8(sp)
     a5e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a60:	00054603          	lbu	a2,0(a0)
     a64:	fd06079b          	addiw	a5,a2,-48
     a68:	0ff7f793          	andi	a5,a5,255
     a6c:	4725                	li	a4,9
     a6e:	02f76963          	bltu	a4,a5,aa0 <atoi+0x46>
     a72:	86aa                	mv	a3,a0
  n = 0;
     a74:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     a76:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     a78:	0685                	addi	a3,a3,1
     a7a:	0025179b          	slliw	a5,a0,0x2
     a7e:	9fa9                	addw	a5,a5,a0
     a80:	0017979b          	slliw	a5,a5,0x1
     a84:	9fb1                	addw	a5,a5,a2
     a86:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a8a:	0006c603          	lbu	a2,0(a3)
     a8e:	fd06071b          	addiw	a4,a2,-48
     a92:	0ff77713          	andi	a4,a4,255
     a96:	fee5f1e3          	bgeu	a1,a4,a78 <atoi+0x1e>
  return n;
}
     a9a:	6422                	ld	s0,8(sp)
     a9c:	0141                	addi	sp,sp,16
     a9e:	8082                	ret
  n = 0;
     aa0:	4501                	li	a0,0
     aa2:	bfe5                	j	a9a <atoi+0x40>

0000000000000aa4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     aa4:	1141                	addi	sp,sp,-16
     aa6:	e422                	sd	s0,8(sp)
     aa8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aaa:	02b57663          	bgeu	a0,a1,ad6 <memmove+0x32>
    while(n-- > 0)
     aae:	02c05163          	blez	a2,ad0 <memmove+0x2c>
     ab2:	fff6079b          	addiw	a5,a2,-1
     ab6:	1782                	slli	a5,a5,0x20
     ab8:	9381                	srli	a5,a5,0x20
     aba:	0785                	addi	a5,a5,1
     abc:	97aa                	add	a5,a5,a0
  dst = vdst;
     abe:	872a                	mv	a4,a0
      *dst++ = *src++;
     ac0:	0585                	addi	a1,a1,1
     ac2:	0705                	addi	a4,a4,1
     ac4:	fff5c683          	lbu	a3,-1(a1)
     ac8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     acc:	fee79ae3          	bne	a5,a4,ac0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ad0:	6422                	ld	s0,8(sp)
     ad2:	0141                	addi	sp,sp,16
     ad4:	8082                	ret
    dst += n;
     ad6:	00c50733          	add	a4,a0,a2
    src += n;
     ada:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     adc:	fec05ae3          	blez	a2,ad0 <memmove+0x2c>
     ae0:	fff6079b          	addiw	a5,a2,-1
     ae4:	1782                	slli	a5,a5,0x20
     ae6:	9381                	srli	a5,a5,0x20
     ae8:	fff7c793          	not	a5,a5
     aec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     aee:	15fd                	addi	a1,a1,-1
     af0:	177d                	addi	a4,a4,-1
     af2:	0005c683          	lbu	a3,0(a1)
     af6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     afa:	fee79ae3          	bne	a5,a4,aee <memmove+0x4a>
     afe:	bfc9                	j	ad0 <memmove+0x2c>

0000000000000b00 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b00:	1141                	addi	sp,sp,-16
     b02:	e422                	sd	s0,8(sp)
     b04:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b06:	ca05                	beqz	a2,b36 <memcmp+0x36>
     b08:	fff6069b          	addiw	a3,a2,-1
     b0c:	1682                	slli	a3,a3,0x20
     b0e:	9281                	srli	a3,a3,0x20
     b10:	0685                	addi	a3,a3,1
     b12:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b14:	00054783          	lbu	a5,0(a0)
     b18:	0005c703          	lbu	a4,0(a1)
     b1c:	00e79863          	bne	a5,a4,b2c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b20:	0505                	addi	a0,a0,1
    p2++;
     b22:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b24:	fed518e3          	bne	a0,a3,b14 <memcmp+0x14>
  }
  return 0;
     b28:	4501                	li	a0,0
     b2a:	a019                	j	b30 <memcmp+0x30>
      return *p1 - *p2;
     b2c:	40e7853b          	subw	a0,a5,a4
}
     b30:	6422                	ld	s0,8(sp)
     b32:	0141                	addi	sp,sp,16
     b34:	8082                	ret
  return 0;
     b36:	4501                	li	a0,0
     b38:	bfe5                	j	b30 <memcmp+0x30>

0000000000000b3a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b3a:	1141                	addi	sp,sp,-16
     b3c:	e406                	sd	ra,8(sp)
     b3e:	e022                	sd	s0,0(sp)
     b40:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b42:	00000097          	auipc	ra,0x0
     b46:	f62080e7          	jalr	-158(ra) # aa4 <memmove>
}
     b4a:	60a2                	ld	ra,8(sp)
     b4c:	6402                	ld	s0,0(sp)
     b4e:	0141                	addi	sp,sp,16
     b50:	8082                	ret

0000000000000b52 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b52:	4885                	li	a7,1
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <exit>:
.global exit
exit:
 li a7, SYS_exit
     b5a:	4889                	li	a7,2
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b62:	488d                	li	a7,3
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b6a:	4891                	li	a7,4
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <read>:
.global read
read:
 li a7, SYS_read
     b72:	4895                	li	a7,5
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <write>:
.global write
write:
 li a7, SYS_write
     b7a:	48c1                	li	a7,16
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <close>:
.global close
close:
 li a7, SYS_close
     b82:	48d5                	li	a7,21
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <kill>:
.global kill
kill:
 li a7, SYS_kill
     b8a:	4899                	li	a7,6
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b92:	489d                	li	a7,7
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <open>:
.global open
open:
 li a7, SYS_open
     b9a:	48bd                	li	a7,15
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ba2:	48c5                	li	a7,17
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     baa:	48c9                	li	a7,18
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bb2:	48a1                	li	a7,8
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <link>:
.global link
link:
 li a7, SYS_link
     bba:	48cd                	li	a7,19
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bc2:	48d1                	li	a7,20
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bca:	48a5                	li	a7,9
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bd2:	48a9                	li	a7,10
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bda:	48ad                	li	a7,11
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     be2:	48b1                	li	a7,12
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bea:	48b5                	li	a7,13
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bf2:	48b9                	li	a7,14
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <connect>:
.global connect
connect:
 li a7, SYS_connect
     bfa:	48f5                	li	a7,29
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     c02:	48f9                	li	a7,30
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c0a:	1101                	addi	sp,sp,-32
     c0c:	ec06                	sd	ra,24(sp)
     c0e:	e822                	sd	s0,16(sp)
     c10:	1000                	addi	s0,sp,32
     c12:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c16:	4605                	li	a2,1
     c18:	fef40593          	addi	a1,s0,-17
     c1c:	00000097          	auipc	ra,0x0
     c20:	f5e080e7          	jalr	-162(ra) # b7a <write>
}
     c24:	60e2                	ld	ra,24(sp)
     c26:	6442                	ld	s0,16(sp)
     c28:	6105                	addi	sp,sp,32
     c2a:	8082                	ret

0000000000000c2c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c2c:	7139                	addi	sp,sp,-64
     c2e:	fc06                	sd	ra,56(sp)
     c30:	f822                	sd	s0,48(sp)
     c32:	f426                	sd	s1,40(sp)
     c34:	f04a                	sd	s2,32(sp)
     c36:	ec4e                	sd	s3,24(sp)
     c38:	0080                	addi	s0,sp,64
     c3a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c3c:	c299                	beqz	a3,c42 <printint+0x16>
     c3e:	0805c863          	bltz	a1,cce <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c42:	2581                	sext.w	a1,a1
  neg = 0;
     c44:	4881                	li	a7,0
     c46:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c4a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c4c:	2601                	sext.w	a2,a2
     c4e:	00000517          	auipc	a0,0x0
     c52:	71250513          	addi	a0,a0,1810 # 1360 <digits>
     c56:	883a                	mv	a6,a4
     c58:	2705                	addiw	a4,a4,1
     c5a:	02c5f7bb          	remuw	a5,a1,a2
     c5e:	1782                	slli	a5,a5,0x20
     c60:	9381                	srli	a5,a5,0x20
     c62:	97aa                	add	a5,a5,a0
     c64:	0007c783          	lbu	a5,0(a5)
     c68:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c6c:	0005879b          	sext.w	a5,a1
     c70:	02c5d5bb          	divuw	a1,a1,a2
     c74:	0685                	addi	a3,a3,1
     c76:	fec7f0e3          	bgeu	a5,a2,c56 <printint+0x2a>
  if(neg)
     c7a:	00088b63          	beqz	a7,c90 <printint+0x64>
    buf[i++] = '-';
     c7e:	fd040793          	addi	a5,s0,-48
     c82:	973e                	add	a4,a4,a5
     c84:	02d00793          	li	a5,45
     c88:	fef70823          	sb	a5,-16(a4)
     c8c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c90:	02e05863          	blez	a4,cc0 <printint+0x94>
     c94:	fc040793          	addi	a5,s0,-64
     c98:	00e78933          	add	s2,a5,a4
     c9c:	fff78993          	addi	s3,a5,-1
     ca0:	99ba                	add	s3,s3,a4
     ca2:	377d                	addiw	a4,a4,-1
     ca4:	1702                	slli	a4,a4,0x20
     ca6:	9301                	srli	a4,a4,0x20
     ca8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cac:	fff94583          	lbu	a1,-1(s2)
     cb0:	8526                	mv	a0,s1
     cb2:	00000097          	auipc	ra,0x0
     cb6:	f58080e7          	jalr	-168(ra) # c0a <putc>
  while(--i >= 0)
     cba:	197d                	addi	s2,s2,-1
     cbc:	ff3918e3          	bne	s2,s3,cac <printint+0x80>
}
     cc0:	70e2                	ld	ra,56(sp)
     cc2:	7442                	ld	s0,48(sp)
     cc4:	74a2                	ld	s1,40(sp)
     cc6:	7902                	ld	s2,32(sp)
     cc8:	69e2                	ld	s3,24(sp)
     cca:	6121                	addi	sp,sp,64
     ccc:	8082                	ret
    x = -xx;
     cce:	40b005bb          	negw	a1,a1
    neg = 1;
     cd2:	4885                	li	a7,1
    x = -xx;
     cd4:	bf8d                	j	c46 <printint+0x1a>

0000000000000cd6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cd6:	7119                	addi	sp,sp,-128
     cd8:	fc86                	sd	ra,120(sp)
     cda:	f8a2                	sd	s0,112(sp)
     cdc:	f4a6                	sd	s1,104(sp)
     cde:	f0ca                	sd	s2,96(sp)
     ce0:	ecce                	sd	s3,88(sp)
     ce2:	e8d2                	sd	s4,80(sp)
     ce4:	e4d6                	sd	s5,72(sp)
     ce6:	e0da                	sd	s6,64(sp)
     ce8:	fc5e                	sd	s7,56(sp)
     cea:	f862                	sd	s8,48(sp)
     cec:	f466                	sd	s9,40(sp)
     cee:	f06a                	sd	s10,32(sp)
     cf0:	ec6e                	sd	s11,24(sp)
     cf2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cf4:	0005c903          	lbu	s2,0(a1)
     cf8:	18090f63          	beqz	s2,e96 <vprintf+0x1c0>
     cfc:	8aaa                	mv	s5,a0
     cfe:	8b32                	mv	s6,a2
     d00:	00158493          	addi	s1,a1,1
  state = 0;
     d04:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d06:	02500a13          	li	s4,37
      if(c == 'd'){
     d0a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     d0e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     d12:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     d16:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d1a:	00000b97          	auipc	s7,0x0
     d1e:	646b8b93          	addi	s7,s7,1606 # 1360 <digits>
     d22:	a839                	j	d40 <vprintf+0x6a>
        putc(fd, c);
     d24:	85ca                	mv	a1,s2
     d26:	8556                	mv	a0,s5
     d28:	00000097          	auipc	ra,0x0
     d2c:	ee2080e7          	jalr	-286(ra) # c0a <putc>
     d30:	a019                	j	d36 <vprintf+0x60>
    } else if(state == '%'){
     d32:	01498f63          	beq	s3,s4,d50 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d36:	0485                	addi	s1,s1,1
     d38:	fff4c903          	lbu	s2,-1(s1)
     d3c:	14090d63          	beqz	s2,e96 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     d40:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d44:	fe0997e3          	bnez	s3,d32 <vprintf+0x5c>
      if(c == '%'){
     d48:	fd479ee3          	bne	a5,s4,d24 <vprintf+0x4e>
        state = '%';
     d4c:	89be                	mv	s3,a5
     d4e:	b7e5                	j	d36 <vprintf+0x60>
      if(c == 'd'){
     d50:	05878063          	beq	a5,s8,d90 <vprintf+0xba>
      } else if(c == 'l') {
     d54:	05978c63          	beq	a5,s9,dac <vprintf+0xd6>
      } else if(c == 'x') {
     d58:	07a78863          	beq	a5,s10,dc8 <vprintf+0xf2>
      } else if(c == 'p') {
     d5c:	09b78463          	beq	a5,s11,de4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     d60:	07300713          	li	a4,115
     d64:	0ce78663          	beq	a5,a4,e30 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     d68:	06300713          	li	a4,99
     d6c:	0ee78e63          	beq	a5,a4,e68 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     d70:	11478863          	beq	a5,s4,e80 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     d74:	85d2                	mv	a1,s4
     d76:	8556                	mv	a0,s5
     d78:	00000097          	auipc	ra,0x0
     d7c:	e92080e7          	jalr	-366(ra) # c0a <putc>
        putc(fd, c);
     d80:	85ca                	mv	a1,s2
     d82:	8556                	mv	a0,s5
     d84:	00000097          	auipc	ra,0x0
     d88:	e86080e7          	jalr	-378(ra) # c0a <putc>
      }
      state = 0;
     d8c:	4981                	li	s3,0
     d8e:	b765                	j	d36 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     d90:	008b0913          	addi	s2,s6,8
     d94:	4685                	li	a3,1
     d96:	4629                	li	a2,10
     d98:	000b2583          	lw	a1,0(s6)
     d9c:	8556                	mv	a0,s5
     d9e:	00000097          	auipc	ra,0x0
     da2:	e8e080e7          	jalr	-370(ra) # c2c <printint>
     da6:	8b4a                	mv	s6,s2
      state = 0;
     da8:	4981                	li	s3,0
     daa:	b771                	j	d36 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dac:	008b0913          	addi	s2,s6,8
     db0:	4681                	li	a3,0
     db2:	4629                	li	a2,10
     db4:	000b2583          	lw	a1,0(s6)
     db8:	8556                	mv	a0,s5
     dba:	00000097          	auipc	ra,0x0
     dbe:	e72080e7          	jalr	-398(ra) # c2c <printint>
     dc2:	8b4a                	mv	s6,s2
      state = 0;
     dc4:	4981                	li	s3,0
     dc6:	bf85                	j	d36 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     dc8:	008b0913          	addi	s2,s6,8
     dcc:	4681                	li	a3,0
     dce:	4641                	li	a2,16
     dd0:	000b2583          	lw	a1,0(s6)
     dd4:	8556                	mv	a0,s5
     dd6:	00000097          	auipc	ra,0x0
     dda:	e56080e7          	jalr	-426(ra) # c2c <printint>
     dde:	8b4a                	mv	s6,s2
      state = 0;
     de0:	4981                	li	s3,0
     de2:	bf91                	j	d36 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     de4:	008b0793          	addi	a5,s6,8
     de8:	f8f43423          	sd	a5,-120(s0)
     dec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     df0:	03000593          	li	a1,48
     df4:	8556                	mv	a0,s5
     df6:	00000097          	auipc	ra,0x0
     dfa:	e14080e7          	jalr	-492(ra) # c0a <putc>
  putc(fd, 'x');
     dfe:	85ea                	mv	a1,s10
     e00:	8556                	mv	a0,s5
     e02:	00000097          	auipc	ra,0x0
     e06:	e08080e7          	jalr	-504(ra) # c0a <putc>
     e0a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e0c:	03c9d793          	srli	a5,s3,0x3c
     e10:	97de                	add	a5,a5,s7
     e12:	0007c583          	lbu	a1,0(a5)
     e16:	8556                	mv	a0,s5
     e18:	00000097          	auipc	ra,0x0
     e1c:	df2080e7          	jalr	-526(ra) # c0a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e20:	0992                	slli	s3,s3,0x4
     e22:	397d                	addiw	s2,s2,-1
     e24:	fe0914e3          	bnez	s2,e0c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     e28:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e2c:	4981                	li	s3,0
     e2e:	b721                	j	d36 <vprintf+0x60>
        s = va_arg(ap, char*);
     e30:	008b0993          	addi	s3,s6,8
     e34:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     e38:	02090163          	beqz	s2,e5a <vprintf+0x184>
        while(*s != 0){
     e3c:	00094583          	lbu	a1,0(s2)
     e40:	c9a1                	beqz	a1,e90 <vprintf+0x1ba>
          putc(fd, *s);
     e42:	8556                	mv	a0,s5
     e44:	00000097          	auipc	ra,0x0
     e48:	dc6080e7          	jalr	-570(ra) # c0a <putc>
          s++;
     e4c:	0905                	addi	s2,s2,1
        while(*s != 0){
     e4e:	00094583          	lbu	a1,0(s2)
     e52:	f9e5                	bnez	a1,e42 <vprintf+0x16c>
        s = va_arg(ap, char*);
     e54:	8b4e                	mv	s6,s3
      state = 0;
     e56:	4981                	li	s3,0
     e58:	bdf9                	j	d36 <vprintf+0x60>
          s = "(null)";
     e5a:	00000917          	auipc	s2,0x0
     e5e:	4fe90913          	addi	s2,s2,1278 # 1358 <malloc+0x3b8>
        while(*s != 0){
     e62:	02800593          	li	a1,40
     e66:	bff1                	j	e42 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     e68:	008b0913          	addi	s2,s6,8
     e6c:	000b4583          	lbu	a1,0(s6)
     e70:	8556                	mv	a0,s5
     e72:	00000097          	auipc	ra,0x0
     e76:	d98080e7          	jalr	-616(ra) # c0a <putc>
     e7a:	8b4a                	mv	s6,s2
      state = 0;
     e7c:	4981                	li	s3,0
     e7e:	bd65                	j	d36 <vprintf+0x60>
        putc(fd, c);
     e80:	85d2                	mv	a1,s4
     e82:	8556                	mv	a0,s5
     e84:	00000097          	auipc	ra,0x0
     e88:	d86080e7          	jalr	-634(ra) # c0a <putc>
      state = 0;
     e8c:	4981                	li	s3,0
     e8e:	b565                	j	d36 <vprintf+0x60>
        s = va_arg(ap, char*);
     e90:	8b4e                	mv	s6,s3
      state = 0;
     e92:	4981                	li	s3,0
     e94:	b54d                	j	d36 <vprintf+0x60>
    }
  }
}
     e96:	70e6                	ld	ra,120(sp)
     e98:	7446                	ld	s0,112(sp)
     e9a:	74a6                	ld	s1,104(sp)
     e9c:	7906                	ld	s2,96(sp)
     e9e:	69e6                	ld	s3,88(sp)
     ea0:	6a46                	ld	s4,80(sp)
     ea2:	6aa6                	ld	s5,72(sp)
     ea4:	6b06                	ld	s6,64(sp)
     ea6:	7be2                	ld	s7,56(sp)
     ea8:	7c42                	ld	s8,48(sp)
     eaa:	7ca2                	ld	s9,40(sp)
     eac:	7d02                	ld	s10,32(sp)
     eae:	6de2                	ld	s11,24(sp)
     eb0:	6109                	addi	sp,sp,128
     eb2:	8082                	ret

0000000000000eb4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eb4:	715d                	addi	sp,sp,-80
     eb6:	ec06                	sd	ra,24(sp)
     eb8:	e822                	sd	s0,16(sp)
     eba:	1000                	addi	s0,sp,32
     ebc:	e010                	sd	a2,0(s0)
     ebe:	e414                	sd	a3,8(s0)
     ec0:	e818                	sd	a4,16(s0)
     ec2:	ec1c                	sd	a5,24(s0)
     ec4:	03043023          	sd	a6,32(s0)
     ec8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ecc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ed0:	8622                	mv	a2,s0
     ed2:	00000097          	auipc	ra,0x0
     ed6:	e04080e7          	jalr	-508(ra) # cd6 <vprintf>
}
     eda:	60e2                	ld	ra,24(sp)
     edc:	6442                	ld	s0,16(sp)
     ede:	6161                	addi	sp,sp,80
     ee0:	8082                	ret

0000000000000ee2 <printf>:

void
printf(const char *fmt, ...)
{
     ee2:	711d                	addi	sp,sp,-96
     ee4:	ec06                	sd	ra,24(sp)
     ee6:	e822                	sd	s0,16(sp)
     ee8:	1000                	addi	s0,sp,32
     eea:	e40c                	sd	a1,8(s0)
     eec:	e810                	sd	a2,16(s0)
     eee:	ec14                	sd	a3,24(s0)
     ef0:	f018                	sd	a4,32(s0)
     ef2:	f41c                	sd	a5,40(s0)
     ef4:	03043823          	sd	a6,48(s0)
     ef8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     efc:	00840613          	addi	a2,s0,8
     f00:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f04:	85aa                	mv	a1,a0
     f06:	4505                	li	a0,1
     f08:	00000097          	auipc	ra,0x0
     f0c:	dce080e7          	jalr	-562(ra) # cd6 <vprintf>
}
     f10:	60e2                	ld	ra,24(sp)
     f12:	6442                	ld	s0,16(sp)
     f14:	6125                	addi	sp,sp,96
     f16:	8082                	ret

0000000000000f18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f18:	1141                	addi	sp,sp,-16
     f1a:	e422                	sd	s0,8(sp)
     f1c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f1e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f22:	00001797          	auipc	a5,0x1
     f26:	0de7b783          	ld	a5,222(a5) # 2000 <freep>
     f2a:	a805                	j	f5a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f2c:	4618                	lw	a4,8(a2)
     f2e:	9db9                	addw	a1,a1,a4
     f30:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f34:	6398                	ld	a4,0(a5)
     f36:	6318                	ld	a4,0(a4)
     f38:	fee53823          	sd	a4,-16(a0)
     f3c:	a091                	j	f80 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f3e:	ff852703          	lw	a4,-8(a0)
     f42:	9e39                	addw	a2,a2,a4
     f44:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
     f46:	ff053703          	ld	a4,-16(a0)
     f4a:	e398                	sd	a4,0(a5)
     f4c:	a099                	j	f92 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f4e:	6398                	ld	a4,0(a5)
     f50:	00e7e463          	bltu	a5,a4,f58 <free+0x40>
     f54:	00e6ea63          	bltu	a3,a4,f68 <free+0x50>
{
     f58:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f5a:	fed7fae3          	bgeu	a5,a3,f4e <free+0x36>
     f5e:	6398                	ld	a4,0(a5)
     f60:	00e6e463          	bltu	a3,a4,f68 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f64:	fee7eae3          	bltu	a5,a4,f58 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
     f68:	ff852583          	lw	a1,-8(a0)
     f6c:	6390                	ld	a2,0(a5)
     f6e:	02059713          	slli	a4,a1,0x20
     f72:	9301                	srli	a4,a4,0x20
     f74:	0712                	slli	a4,a4,0x4
     f76:	9736                	add	a4,a4,a3
     f78:	fae60ae3          	beq	a2,a4,f2c <free+0x14>
    bp->s.ptr = p->s.ptr;
     f7c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f80:	4790                	lw	a2,8(a5)
     f82:	02061713          	slli	a4,a2,0x20
     f86:	9301                	srli	a4,a4,0x20
     f88:	0712                	slli	a4,a4,0x4
     f8a:	973e                	add	a4,a4,a5
     f8c:	fae689e3          	beq	a3,a4,f3e <free+0x26>
  } else
    p->s.ptr = bp;
     f90:	e394                	sd	a3,0(a5)
  freep = p;
     f92:	00001717          	auipc	a4,0x1
     f96:	06f73723          	sd	a5,110(a4) # 2000 <freep>
}
     f9a:	6422                	ld	s0,8(sp)
     f9c:	0141                	addi	sp,sp,16
     f9e:	8082                	ret

0000000000000fa0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fa0:	7139                	addi	sp,sp,-64
     fa2:	fc06                	sd	ra,56(sp)
     fa4:	f822                	sd	s0,48(sp)
     fa6:	f426                	sd	s1,40(sp)
     fa8:	f04a                	sd	s2,32(sp)
     faa:	ec4e                	sd	s3,24(sp)
     fac:	e852                	sd	s4,16(sp)
     fae:	e456                	sd	s5,8(sp)
     fb0:	e05a                	sd	s6,0(sp)
     fb2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fb4:	02051493          	slli	s1,a0,0x20
     fb8:	9081                	srli	s1,s1,0x20
     fba:	04bd                	addi	s1,s1,15
     fbc:	8091                	srli	s1,s1,0x4
     fbe:	0014899b          	addiw	s3,s1,1
     fc2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     fc4:	00001517          	auipc	a0,0x1
     fc8:	03c53503          	ld	a0,60(a0) # 2000 <freep>
     fcc:	c515                	beqz	a0,ff8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fd0:	4798                	lw	a4,8(a5)
     fd2:	02977f63          	bgeu	a4,s1,1010 <malloc+0x70>
     fd6:	8a4e                	mv	s4,s3
     fd8:	0009871b          	sext.w	a4,s3
     fdc:	6685                	lui	a3,0x1
     fde:	00d77363          	bgeu	a4,a3,fe4 <malloc+0x44>
     fe2:	6a05                	lui	s4,0x1
     fe4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     fe8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fec:	00001917          	auipc	s2,0x1
     ff0:	01490913          	addi	s2,s2,20 # 2000 <freep>
  if(p == (char*)-1)
     ff4:	5afd                	li	s5,-1
     ff6:	a88d                	j	1068 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
     ff8:	00001797          	auipc	a5,0x1
     ffc:	01878793          	addi	a5,a5,24 # 2010 <base>
    1000:	00001717          	auipc	a4,0x1
    1004:	00f73023          	sd	a5,0(a4) # 2000 <freep>
    1008:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    100a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    100e:	b7e1                	j	fd6 <malloc+0x36>
      if(p->s.size == nunits)
    1010:	02e48b63          	beq	s1,a4,1046 <malloc+0xa6>
        p->s.size -= nunits;
    1014:	4137073b          	subw	a4,a4,s3
    1018:	c798                	sw	a4,8(a5)
        p += p->s.size;
    101a:	1702                	slli	a4,a4,0x20
    101c:	9301                	srli	a4,a4,0x20
    101e:	0712                	slli	a4,a4,0x4
    1020:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1022:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1026:	00001717          	auipc	a4,0x1
    102a:	fca73d23          	sd	a0,-38(a4) # 2000 <freep>
      return (void*)(p + 1);
    102e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1032:	70e2                	ld	ra,56(sp)
    1034:	7442                	ld	s0,48(sp)
    1036:	74a2                	ld	s1,40(sp)
    1038:	7902                	ld	s2,32(sp)
    103a:	69e2                	ld	s3,24(sp)
    103c:	6a42                	ld	s4,16(sp)
    103e:	6aa2                	ld	s5,8(sp)
    1040:	6b02                	ld	s6,0(sp)
    1042:	6121                	addi	sp,sp,64
    1044:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1046:	6398                	ld	a4,0(a5)
    1048:	e118                	sd	a4,0(a0)
    104a:	bff1                	j	1026 <malloc+0x86>
  hp->s.size = nu;
    104c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1050:	0541                	addi	a0,a0,16
    1052:	00000097          	auipc	ra,0x0
    1056:	ec6080e7          	jalr	-314(ra) # f18 <free>
  return freep;
    105a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    105e:	d971                	beqz	a0,1032 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1060:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1062:	4798                	lw	a4,8(a5)
    1064:	fa9776e3          	bgeu	a4,s1,1010 <malloc+0x70>
    if(p == freep)
    1068:	00093703          	ld	a4,0(s2)
    106c:	853e                	mv	a0,a5
    106e:	fef719e3          	bne	a4,a5,1060 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1072:	8552                	mv	a0,s4
    1074:	00000097          	auipc	ra,0x0
    1078:	b6e080e7          	jalr	-1170(ra) # be2 <sbrk>
  if(p == (char*)-1)
    107c:	fd5518e3          	bne	a0,s5,104c <malloc+0xac>
        return 0;
    1080:	4501                	li	a0,0
    1082:	bf45                	j	1032 <malloc+0x92>
