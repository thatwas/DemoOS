
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba c8 89 11 00       	mov    $0x1189c8,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 49 60 00 00       	call   10609f <memset>

    cons_init();                // init the console
  100056:	e8 7c 15 00 00       	call   1015d7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 40 62 10 00 	movl   $0x106240,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 5c 62 10 00 	movl   $0x10625c,(%esp)
  100070:	e8 d2 02 00 00       	call   100347 <cprintf>

    print_kerninfo();
  100075:	e8 01 08 00 00       	call   10087b <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 ac 44 00 00       	call   104530 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b7 16 00 00       	call   101740 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 09 18 00 00       	call   101897 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 fa 0c 00 00       	call   100d8d <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 16 16 00 00       	call   1016ae <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 03 0c 00 00       	call   100cbf <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 61 62 10 00 	movl   $0x106261,(%esp)
  10015c:	e8 e6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 6f 62 10 00 	movl   $0x10626f,(%esp)
  10017c:	e8 c6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 7d 62 10 00 	movl   $0x10627d,(%esp)
  10019c:	e8 a6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1001bc:	e8 86 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 99 62 10 00 	movl   $0x106299,(%esp)
  1001dc:	e8 66 01 00 00       	call   100347 <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001f3:	83 ec 08             	sub    $0x8,%esp
  1001f6:	cd 78                	int    $0x78
  1001f8:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001fa:	5d                   	pop    %ebp
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001ff:	cd 79                	int    $0x79
  100201:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
  100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020b:	e8 1a ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100210:	c7 04 24 a8 62 10 00 	movl   $0x1062a8,(%esp)
  100217:	e8 2b 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_user();
  10021c:	e8 cf ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100221:	e8 04 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100226:	c7 04 24 c8 62 10 00 	movl   $0x1062c8,(%esp)
  10022d:	e8 15 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_kernel();
  100232:	e8 c5 ff ff ff       	call   1001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100237:	e8 ee fe ff ff       	call   10012a <lab1_print_cur_status>
}
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100248:	74 13                	je     10025d <readline+0x1f>
        cprintf("%s", prompt);
  10024a:	8b 45 08             	mov    0x8(%ebp),%eax
  10024d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100251:	c7 04 24 e7 62 10 00 	movl   $0x1062e7,(%esp)
  100258:	e8 ea 00 00 00       	call   100347 <cprintf>
    }
    int i = 0, c;
  10025d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100264:	e8 66 01 00 00       	call   1003cf <getchar>
  100269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100270:	79 07                	jns    100279 <readline+0x3b>
            return NULL;
  100272:	b8 00 00 00 00       	mov    $0x0,%eax
  100277:	eb 79                	jmp    1002f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100279:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027d:	7e 28                	jle    1002a7 <readline+0x69>
  10027f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100286:	7f 1f                	jg     1002a7 <readline+0x69>
            cputchar(c);
  100288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 da 00 00 00       	call   10036d <cputchar>
            buf[i ++] = c;
  100293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100296:	8d 50 01             	lea    0x1(%eax),%edx
  100299:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10029f:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  1002a5:	eb 46                	jmp    1002ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ab:	75 17                	jne    1002c4 <readline+0x86>
  1002ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b1:	7e 11                	jle    1002c4 <readline+0x86>
            cputchar(c);
  1002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b6:	89 04 24             	mov    %eax,(%esp)
  1002b9:	e8 af 00 00 00       	call   10036d <cputchar>
            i --;
  1002be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c2:	eb 29                	jmp    1002ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c8:	74 06                	je     1002d0 <readline+0x92>
  1002ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002ce:	75 1d                	jne    1002ed <readline+0xaf>
            cputchar(c);
  1002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d3:	89 04 24             	mov    %eax,(%esp)
  1002d6:	e8 92 00 00 00       	call   10036d <cputchar>
            buf[i] = '\0';
  1002db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002de:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e6:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002eb:	eb 05                	jmp    1002f2 <readline+0xb4>
        }
    }
  1002ed:	e9 72 ff ff ff       	jmp    100264 <readline+0x26>
}
  1002f2:	c9                   	leave  
  1002f3:	c3                   	ret    

001002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fd:	89 04 24             	mov    %eax,(%esp)
  100300:	e8 fe 12 00 00       	call   101603 <cons_putc>
    (*cnt) ++;
  100305:	8b 45 0c             	mov    0xc(%ebp),%eax
  100308:	8b 00                	mov    (%eax),%eax
  10030a:	8d 50 01             	lea    0x1(%eax),%edx
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	89 10                	mov    %edx,(%eax)
}
  100312:	c9                   	leave  
  100313:	c3                   	ret    

00100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100321:	8b 45 0c             	mov    0xc(%ebp),%eax
  100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100332:	89 44 24 04          	mov    %eax,0x4(%esp)
  100336:	c7 04 24 f4 02 10 00 	movl   $0x1002f4,(%esp)
  10033d:	e8 76 55 00 00       	call   1058b8 <vprintfmt>
    return cnt;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100347:	55                   	push   %ebp
  100348:	89 e5                	mov    %esp,%ebp
  10034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100356:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035a:	8b 45 08             	mov    0x8(%ebp),%eax
  10035d:	89 04 24             	mov    %eax,(%esp)
  100360:	e8 af ff ff ff       	call   100314 <vcprintf>
  100365:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036b:	c9                   	leave  
  10036c:	c3                   	ret    

0010036d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036d:	55                   	push   %ebp
  10036e:	89 e5                	mov    %esp,%ebp
  100370:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100373:	8b 45 08             	mov    0x8(%ebp),%eax
  100376:	89 04 24             	mov    %eax,(%esp)
  100379:	e8 85 12 00 00       	call   101603 <cons_putc>
}
  10037e:	c9                   	leave  
  10037f:	c3                   	ret    

00100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100380:	55                   	push   %ebp
  100381:	89 e5                	mov    %esp,%ebp
  100383:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038d:	eb 13                	jmp    1003a2 <cputs+0x22>
        cputch(c, &cnt);
  10038f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100393:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100396:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039a:	89 04 24             	mov    %eax,(%esp)
  10039d:	e8 52 ff ff ff       	call   1002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a5:	8d 50 01             	lea    0x1(%eax),%edx
  1003a8:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ab:	0f b6 00             	movzbl (%eax),%eax
  1003ae:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b5:	75 d8                	jne    10038f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003be:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c5:	e8 2a ff ff ff       	call   1002f4 <cputch>
    return cnt;
  1003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003cd:	c9                   	leave  
  1003ce:	c3                   	ret    

001003cf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003cf:	55                   	push   %ebp
  1003d0:	89 e5                	mov    %esp,%ebp
  1003d2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d5:	e8 65 12 00 00       	call   10163f <cons_getc>
  1003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e1:	74 f2                	je     1003d5 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e6:	c9                   	leave  
  1003e7:	c3                   	ret    

001003e8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e8:	55                   	push   %ebp
  1003e9:	89 e5                	mov    %esp,%ebp
  1003eb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f1:	8b 00                	mov    (%eax),%eax
  1003f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f9:	8b 00                	mov    (%eax),%eax
  1003fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100405:	e9 d2 00 00 00       	jmp    1004dc <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100410:	01 d0                	add    %edx,%eax
  100412:	89 c2                	mov    %eax,%edx
  100414:	c1 ea 1f             	shr    $0x1f,%edx
  100417:	01 d0                	add    %edx,%eax
  100419:	d1 f8                	sar    %eax
  10041b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100421:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100424:	eb 04                	jmp    10042a <stab_binsearch+0x42>
            m --;
  100426:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100430:	7c 1f                	jl     100451 <stab_binsearch+0x69>
  100432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100435:	89 d0                	mov    %edx,%eax
  100437:	01 c0                	add    %eax,%eax
  100439:	01 d0                	add    %edx,%eax
  10043b:	c1 e0 02             	shl    $0x2,%eax
  10043e:	89 c2                	mov    %eax,%edx
  100440:	8b 45 08             	mov    0x8(%ebp),%eax
  100443:	01 d0                	add    %edx,%eax
  100445:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100449:	0f b6 c0             	movzbl %al,%eax
  10044c:	3b 45 14             	cmp    0x14(%ebp),%eax
  10044f:	75 d5                	jne    100426 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100457:	7d 0b                	jge    100464 <stab_binsearch+0x7c>
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100462:	eb 78                	jmp    1004dc <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100464:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046e:	89 d0                	mov    %edx,%eax
  100470:	01 c0                	add    %eax,%eax
  100472:	01 d0                	add    %edx,%eax
  100474:	c1 e0 02             	shl    $0x2,%eax
  100477:	89 c2                	mov    %eax,%edx
  100479:	8b 45 08             	mov    0x8(%ebp),%eax
  10047c:	01 d0                	add    %edx,%eax
  10047e:	8b 40 08             	mov    0x8(%eax),%eax
  100481:	3b 45 18             	cmp    0x18(%ebp),%eax
  100484:	73 13                	jae    100499 <stab_binsearch+0xb1>
            *region_left = m;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100491:	83 c0 01             	add    $0x1,%eax
  100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100497:	eb 43                	jmp    1004dc <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049c:	89 d0                	mov    %edx,%eax
  10049e:	01 c0                	add    %eax,%eax
  1004a0:	01 d0                	add    %edx,%eax
  1004a2:	c1 e0 02             	shl    $0x2,%eax
  1004a5:	89 c2                	mov    %eax,%edx
  1004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004aa:	01 d0                	add    %edx,%eax
  1004ac:	8b 40 08             	mov    0x8(%eax),%eax
  1004af:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b2:	76 16                	jbe    1004ca <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1004bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c2:	83 e8 01             	sub    $0x1,%eax
  1004c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c8:	eb 12                	jmp    1004dc <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d0:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e2:	0f 8e 22 ff ff ff    	jle    10040a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ec:	75 0f                	jne    1004fd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f1:	8b 00                	mov    (%eax),%eax
  1004f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f9:	89 10                	mov    %edx,(%eax)
  1004fb:	eb 3f                	jmp    10053c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100500:	8b 00                	mov    (%eax),%eax
  100502:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100505:	eb 04                	jmp    10050b <stab_binsearch+0x123>
  100507:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050e:	8b 00                	mov    (%eax),%eax
  100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100513:	7d 1f                	jge    100534 <stab_binsearch+0x14c>
  100515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100518:	89 d0                	mov    %edx,%eax
  10051a:	01 c0                	add    %eax,%eax
  10051c:	01 d0                	add    %edx,%eax
  10051e:	c1 e0 02             	shl    $0x2,%eax
  100521:	89 c2                	mov    %eax,%edx
  100523:	8b 45 08             	mov    0x8(%ebp),%eax
  100526:	01 d0                	add    %edx,%eax
  100528:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052c:	0f b6 c0             	movzbl %al,%eax
  10052f:	3b 45 14             	cmp    0x14(%ebp),%eax
  100532:	75 d3                	jne    100507 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053a:	89 10                	mov    %edx,(%eax)
    }
}
  10053c:	c9                   	leave  
  10053d:	c3                   	ret    

0010053e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053e:	55                   	push   %ebp
  10053f:	89 e5                	mov    %esp,%ebp
  100541:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 00 ec 62 10 00    	movl   $0x1062ec,(%eax)
    info->eip_line = 0;
  10054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 40 08 ec 62 10 00 	movl   $0x1062ec,0x8(%eax)
    info->eip_fn_namelen = 9;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056e:	8b 55 08             	mov    0x8(%ebp),%edx
  100571:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057e:	c7 45 f4 4c 75 10 00 	movl   $0x10754c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100585:	c7 45 f0 0c 24 11 00 	movl   $0x11240c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058c:	c7 45 ec 0d 24 11 00 	movl   $0x11240d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100593:	c7 45 e8 97 4e 11 00 	movl   $0x114e97,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a0:	76 0d                	jbe    1005af <debuginfo_eip+0x71>
  1005a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a5:	83 e8 01             	sub    $0x1,%eax
  1005a8:	0f b6 00             	movzbl (%eax),%eax
  1005ab:	84 c0                	test   %al,%al
  1005ad:	74 0a                	je     1005b9 <debuginfo_eip+0x7b>
        return -1;
  1005af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b4:	e9 c0 02 00 00       	jmp    100879 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c6:	29 c2                	sub    %eax,%edx
  1005c8:	89 d0                	mov    %edx,%eax
  1005ca:	c1 f8 02             	sar    $0x2,%eax
  1005cd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d3:	83 e8 01             	sub    $0x1,%eax
  1005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e7:	00 
  1005e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005f9:	89 04 24             	mov    %eax,(%esp)
  1005fc:	e8 e7 fd ff ff       	call   1003e8 <stab_binsearch>
    if (lfile == 0)
  100601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100604:	85 c0                	test   %eax,%eax
  100606:	75 0a                	jne    100612 <debuginfo_eip+0xd4>
        return -1;
  100608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060d:	e9 67 02 00 00       	jmp    100879 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100615:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061e:	8b 45 08             	mov    0x8(%ebp),%eax
  100621:	89 44 24 10          	mov    %eax,0x10(%esp)
  100625:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062c:	00 
  10062d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100630:	89 44 24 08          	mov    %eax,0x8(%esp)
  100634:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100637:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	89 04 24             	mov    %eax,(%esp)
  100641:	e8 a2 fd ff ff       	call   1003e8 <stab_binsearch>

    if (lfun <= rfun) {
  100646:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	7f 7c                	jg     1006cc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066d:	29 c1                	sub    %eax,%ecx
  10066f:	89 c8                	mov    %ecx,%eax
  100671:	39 c2                	cmp    %eax,%edx
  100673:	73 22                	jae    100697 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	89 d0                	mov    %edx,%eax
  10067c:	01 c0                	add    %eax,%eax
  10067e:	01 d0                	add    %edx,%eax
  100680:	c1 e0 02             	shl    $0x2,%eax
  100683:	89 c2                	mov    %eax,%edx
  100685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100688:	01 d0                	add    %edx,%eax
  10068a:	8b 10                	mov    (%eax),%edx
  10068c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10068f:	01 c2                	add    %eax,%edx
  100691:	8b 45 0c             	mov    0xc(%ebp),%eax
  100694:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	89 d0                	mov    %edx,%eax
  10069e:	01 c0                	add    %eax,%eax
  1006a0:	01 d0                	add    %edx,%eax
  1006a2:	c1 e0 02             	shl    $0x2,%eax
  1006a5:	89 c2                	mov    %eax,%edx
  1006a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006aa:	01 d0                	add    %edx,%eax
  1006ac:	8b 50 08             	mov    0x8(%eax),%edx
  1006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b8:	8b 40 10             	mov    0x10(%eax),%eax
  1006bb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006ca:	eb 15                	jmp    1006e1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e4:	8b 40 08             	mov    0x8(%eax),%eax
  1006e7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ee:	00 
  1006ef:	89 04 24             	mov    %eax,(%esp)
  1006f2:	e8 1c 58 00 00       	call   105f13 <strfind>
  1006f7:	89 c2                	mov    %eax,%edx
  1006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fc:	8b 40 08             	mov    0x8(%eax),%eax
  1006ff:	29 c2                	sub    %eax,%edx
  100701:	8b 45 0c             	mov    0xc(%ebp),%eax
  100704:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100707:	8b 45 08             	mov    0x8(%ebp),%eax
  10070a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100715:	00 
  100716:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100719:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100720:	89 44 24 04          	mov    %eax,0x4(%esp)
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	89 04 24             	mov    %eax,(%esp)
  10072a:	e8 b9 fc ff ff       	call   1003e8 <stab_binsearch>
    if (lline <= rline) {
  10072f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100732:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100735:	39 c2                	cmp    %eax,%edx
  100737:	7f 24                	jg     10075d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	89 d0                	mov    %edx,%eax
  100740:	01 c0                	add    %eax,%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	c1 e0 02             	shl    $0x2,%eax
  100747:	89 c2                	mov    %eax,%edx
  100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074c:	01 d0                	add    %edx,%eax
  10074e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100752:	0f b7 d0             	movzwl %ax,%edx
  100755:	8b 45 0c             	mov    0xc(%ebp),%eax
  100758:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075b:	eb 13                	jmp    100770 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100762:	e9 12 01 00 00       	jmp    100879 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	83 e8 01             	sub    $0x1,%eax
  10076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100770:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	39 c2                	cmp    %eax,%edx
  100778:	7c 56                	jl     1007d0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	89 d0                	mov    %edx,%eax
  100781:	01 c0                	add    %eax,%eax
  100783:	01 d0                	add    %edx,%eax
  100785:	c1 e0 02             	shl    $0x2,%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078d:	01 d0                	add    %edx,%eax
  10078f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100793:	3c 84                	cmp    $0x84,%al
  100795:	74 39                	je     1007d0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	89 d0                	mov    %edx,%eax
  10079e:	01 c0                	add    %eax,%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	c1 e0 02             	shl    $0x2,%eax
  1007a5:	89 c2                	mov    %eax,%edx
  1007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007aa:	01 d0                	add    %edx,%eax
  1007ac:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b0:	3c 64                	cmp    $0x64,%al
  1007b2:	75 b3                	jne    100767 <debuginfo_eip+0x229>
  1007b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	89 d0                	mov    %edx,%eax
  1007bb:	01 c0                	add    %eax,%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	c1 e0 02             	shl    $0x2,%eax
  1007c2:	89 c2                	mov    %eax,%edx
  1007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c7:	01 d0                	add    %edx,%eax
  1007c9:	8b 40 08             	mov    0x8(%eax),%eax
  1007cc:	85 c0                	test   %eax,%eax
  1007ce:	74 97                	je     100767 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	7c 46                	jl     100820 <debuginfo_eip+0x2e2>
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f7:	29 c1                	sub    %eax,%ecx
  1007f9:	89 c8                	mov    %ecx,%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 4a                	jge    100874 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	83 c0 01             	add    $0x1,%eax
  100830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100833:	eb 18                	jmp    10084d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100835:	8b 45 0c             	mov    0xc(%ebp),%eax
  100838:	8b 40 14             	mov    0x14(%eax),%eax
  10083b:	8d 50 01             	lea    0x1(%eax),%edx
  10083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100841:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100847:	83 c0 01             	add    $0x1,%eax
  10084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100850:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100853:	39 c2                	cmp    %eax,%edx
  100855:	7d 1d                	jge    100874 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	89 d0                	mov    %edx,%eax
  10085e:	01 c0                	add    %eax,%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	c1 e0 02             	shl    $0x2,%eax
  100865:	89 c2                	mov    %eax,%edx
  100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086a:	01 d0                	add    %edx,%eax
  10086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100870:	3c a0                	cmp    $0xa0,%al
  100872:	74 c1                	je     100835 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100879:	c9                   	leave  
  10087a:	c3                   	ret    

0010087b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087b:	55                   	push   %ebp
  10087c:	89 e5                	mov    %esp,%ebp
  10087e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100881:	c7 04 24 f6 62 10 00 	movl   $0x1062f6,(%esp)
  100888:	e8 ba fa ff ff       	call   100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088d:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100894:	00 
  100895:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  10089c:	e8 a6 fa ff ff       	call   100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a1:	c7 44 24 04 28 62 10 	movl   $0x106228,0x4(%esp)
  1008a8:	00 
  1008a9:	c7 04 24 27 63 10 00 	movl   $0x106327,(%esp)
  1008b0:	e8 92 fa ff ff       	call   100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b5:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bc:	00 
  1008bd:	c7 04 24 3f 63 10 00 	movl   $0x10633f,(%esp)
  1008c4:	e8 7e fa ff ff       	call   100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c9:	c7 44 24 04 c8 89 11 	movl   $0x1189c8,0x4(%esp)
  1008d0:	00 
  1008d1:	c7 04 24 57 63 10 00 	movl   $0x106357,(%esp)
  1008d8:	e8 6a fa ff ff       	call   100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008dd:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  1008e2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e8:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008ed:	29 c2                	sub    %eax,%edx
  1008ef:	89 d0                	mov    %edx,%eax
  1008f1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	0f 48 c2             	cmovs  %edx,%eax
  1008fc:	c1 f8 0a             	sar    $0xa,%eax
  1008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100903:	c7 04 24 70 63 10 00 	movl   $0x106370,(%esp)
  10090a:	e8 38 fa ff ff       	call   100347 <cprintf>
}
  10090f:	c9                   	leave  
  100910:	c3                   	ret    

00100911 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100911:	55                   	push   %ebp
  100912:	89 e5                	mov    %esp,%ebp
  100914:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100921:	8b 45 08             	mov    0x8(%ebp),%eax
  100924:	89 04 24             	mov    %eax,(%esp)
  100927:	e8 12 fc ff ff       	call   10053e <debuginfo_eip>
  10092c:	85 c0                	test   %eax,%eax
  10092e:	74 15                	je     100945 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100930:	8b 45 08             	mov    0x8(%ebp),%eax
  100933:	89 44 24 04          	mov    %eax,0x4(%esp)
  100937:	c7 04 24 9a 63 10 00 	movl   $0x10639a,(%esp)
  10093e:	e8 04 fa ff ff       	call   100347 <cprintf>
  100943:	eb 6d                	jmp    1009b2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094c:	eb 1c                	jmp    10096a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100954:	01 d0                	add    %edx,%eax
  100956:	0f b6 00             	movzbl (%eax),%eax
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100962:	01 ca                	add    %ecx,%edx
  100964:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100966:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100970:	7f dc                	jg     10094e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100972:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097b:	01 d0                	add    %edx,%eax
  10097d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100980:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100983:	8b 55 08             	mov    0x8(%ebp),%edx
  100986:	89 d1                	mov    %edx,%ecx
  100988:	29 c1                	sub    %eax,%ecx
  10098a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100990:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100994:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099e:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a6:	c7 04 24 b6 63 10 00 	movl   $0x1063b6,(%esp)
  1009ad:	e8 95 f9 ff ff       	call   100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b2:	c9                   	leave  
  1009b3:	c3                   	ret    

001009b4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b4:	55                   	push   %ebp
  1009b5:	89 e5                	mov    %esp,%ebp
  1009b7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009ba:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c3:	c9                   	leave  
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
  1009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cb:	89 e8                	mov    %ebp,%eax
  1009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009d6:	e8 d9 ff ff ff       	call   1009b4 <read_eip>
  1009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e5:	e9 88 00 00 00       	jmp    100a72 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 c8 63 10 00 	movl   $0x1063c8,(%esp)
  1009ff:	e8 43 f9 ff ff       	call   100347 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 08             	add    $0x8,%eax
  100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a14:	eb 25                	jmp    100a3b <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	8b 00                	mov    (%eax),%eax
  100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2b:	c7 04 24 e4 63 10 00 	movl   $0x1063e4,(%esp)
  100a32:	e8 10 f9 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3f:	7e d5                	jle    100a16 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a41:	c7 04 24 ec 63 10 00 	movl   $0x1063ec,(%esp)
  100a48:	e8 fa f8 ff ff       	call   100347 <cprintf>
        print_debuginfo(eip - 1);
  100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a50:	83 e8 01             	sub    $0x1,%eax
  100a53:	89 04 24             	mov    %eax,(%esp)
  100a56:	e8 b6 fe ff ff       	call   100911 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	83 c0 04             	add    $0x4,%eax
  100a61:	8b 00                	mov    (%eax),%eax
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	8b 00                	mov    (%eax),%eax
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a76:	74 0a                	je     100a82 <print_stackframe+0xbd>
  100a78:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a7c:	0f 8e 68 ff ff ff    	jle    1009ea <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a82:	c9                   	leave  
  100a83:	c3                   	ret    

00100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a91:	eb 0c                	jmp    100a9f <parse+0x1b>
            *buf ++ = '\0';
  100a93:	8b 45 08             	mov    0x8(%ebp),%eax
  100a96:	8d 50 01             	lea    0x1(%eax),%edx
  100a99:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	0f b6 00             	movzbl (%eax),%eax
  100aa5:	84 c0                	test   %al,%al
  100aa7:	74 1d                	je     100ac6 <parse+0x42>
  100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aac:	0f b6 00             	movzbl (%eax),%eax
  100aaf:	0f be c0             	movsbl %al,%eax
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 70 64 10 00 	movl   $0x106470,(%esp)
  100abd:	e8 1e 54 00 00       	call   105ee0 <strchr>
  100ac2:	85 c0                	test   %eax,%eax
  100ac4:	75 cd                	jne    100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	0f b6 00             	movzbl (%eax),%eax
  100acc:	84 c0                	test   %al,%al
  100ace:	75 02                	jne    100ad2 <parse+0x4e>
            break;
  100ad0:	eb 67                	jmp    100b39 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad6:	75 14                	jne    100aec <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adf:	00 
  100ae0:	c7 04 24 75 64 10 00 	movl   $0x106475,(%esp)
  100ae7:	e8 5b f8 ff ff       	call   100347 <cprintf>
        }
        argv[argc ++] = buf;
  100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aef:	8d 50 01             	lea    0x1(%eax),%edx
  100af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aff:	01 c2                	add    %eax,%edx
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b06:	eb 04                	jmp    100b0c <parse+0x88>
            buf ++;
  100b08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0f:	0f b6 00             	movzbl (%eax),%eax
  100b12:	84 c0                	test   %al,%al
  100b14:	74 1d                	je     100b33 <parse+0xaf>
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	0f b6 00             	movzbl (%eax),%eax
  100b1c:	0f be c0             	movsbl %al,%eax
  100b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b23:	c7 04 24 70 64 10 00 	movl   $0x106470,(%esp)
  100b2a:	e8 b1 53 00 00       	call   105ee0 <strchr>
  100b2f:	85 c0                	test   %eax,%eax
  100b31:	74 d5                	je     100b08 <parse+0x84>
            buf ++;
        }
    }
  100b33:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b34:	e9 66 ff ff ff       	jmp    100a9f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3c:	c9                   	leave  
  100b3d:	c3                   	ret    

00100b3e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3e:	55                   	push   %ebp
  100b3f:	89 e5                	mov    %esp,%ebp
  100b41:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b44:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4e:	89 04 24             	mov    %eax,(%esp)
  100b51:	e8 2e ff ff ff       	call   100a84 <parse>
  100b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5d:	75 0a                	jne    100b69 <runcmd+0x2b>
        return 0;
  100b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b64:	e9 85 00 00 00       	jmp    100bee <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b70:	eb 5c                	jmp    100bce <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b72:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b78:	89 d0                	mov    %edx,%eax
  100b7a:	01 c0                	add    %eax,%eax
  100b7c:	01 d0                	add    %edx,%eax
  100b7e:	c1 e0 02             	shl    $0x2,%eax
  100b81:	05 20 70 11 00       	add    $0x117020,%eax
  100b86:	8b 00                	mov    (%eax),%eax
  100b88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8c:	89 04 24             	mov    %eax,(%esp)
  100b8f:	e8 ad 52 00 00       	call   105e41 <strcmp>
  100b94:	85 c0                	test   %eax,%eax
  100b96:	75 32                	jne    100bca <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9b:	89 d0                	mov    %edx,%eax
  100b9d:	01 c0                	add    %eax,%eax
  100b9f:	01 d0                	add    %edx,%eax
  100ba1:	c1 e0 02             	shl    $0x2,%eax
  100ba4:	05 20 70 11 00       	add    $0x117020,%eax
  100ba9:	8b 40 08             	mov    0x8(%eax),%eax
  100bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100baf:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb5:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb9:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bbc:	83 c2 04             	add    $0x4,%edx
  100bbf:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc3:	89 0c 24             	mov    %ecx,(%esp)
  100bc6:	ff d0                	call   *%eax
  100bc8:	eb 24                	jmp    100bee <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd1:	83 f8 02             	cmp    $0x2,%eax
  100bd4:	76 9c                	jbe    100b72 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdd:	c7 04 24 93 64 10 00 	movl   $0x106493,(%esp)
  100be4:	e8 5e f7 ff ff       	call   100347 <cprintf>
    return 0;
  100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bee:	c9                   	leave  
  100bef:	c3                   	ret    

00100bf0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf0:	55                   	push   %ebp
  100bf1:	89 e5                	mov    %esp,%ebp
  100bf3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf6:	c7 04 24 ac 64 10 00 	movl   $0x1064ac,(%esp)
  100bfd:	e8 45 f7 ff ff       	call   100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c02:	c7 04 24 d4 64 10 00 	movl   $0x1064d4,(%esp)
  100c09:	e8 39 f7 ff ff       	call   100347 <cprintf>

    if (tf != NULL) {
  100c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c12:	74 0b                	je     100c1f <kmonitor+0x2f>
        print_trapframe(tf);
  100c14:	8b 45 08             	mov    0x8(%ebp),%eax
  100c17:	89 04 24             	mov    %eax,(%esp)
  100c1a:	e8 30 0e 00 00       	call   101a4f <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1f:	c7 04 24 f9 64 10 00 	movl   $0x1064f9,(%esp)
  100c26:	e8 13 f6 ff ff       	call   10023e <readline>
  100c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c32:	74 18                	je     100c4c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c34:	8b 45 08             	mov    0x8(%ebp),%eax
  100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3e:	89 04 24             	mov    %eax,(%esp)
  100c41:	e8 f8 fe ff ff       	call   100b3e <runcmd>
  100c46:	85 c0                	test   %eax,%eax
  100c48:	79 02                	jns    100c4c <kmonitor+0x5c>
                break;
  100c4a:	eb 02                	jmp    100c4e <kmonitor+0x5e>
            }
        }
    }
  100c4c:	eb d1                	jmp    100c1f <kmonitor+0x2f>
}
  100c4e:	c9                   	leave  
  100c4f:	c3                   	ret    

00100c50 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c50:	55                   	push   %ebp
  100c51:	89 e5                	mov    %esp,%ebp
  100c53:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5d:	eb 3f                	jmp    100c9e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c62:	89 d0                	mov    %edx,%eax
  100c64:	01 c0                	add    %eax,%eax
  100c66:	01 d0                	add    %edx,%eax
  100c68:	c1 e0 02             	shl    $0x2,%eax
  100c6b:	05 20 70 11 00       	add    $0x117020,%eax
  100c70:	8b 48 04             	mov    0x4(%eax),%ecx
  100c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c76:	89 d0                	mov    %edx,%eax
  100c78:	01 c0                	add    %eax,%eax
  100c7a:	01 d0                	add    %edx,%eax
  100c7c:	c1 e0 02             	shl    $0x2,%eax
  100c7f:	05 20 70 11 00       	add    $0x117020,%eax
  100c84:	8b 00                	mov    (%eax),%eax
  100c86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8e:	c7 04 24 fd 64 10 00 	movl   $0x1064fd,(%esp)
  100c95:	e8 ad f6 ff ff       	call   100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca1:	83 f8 02             	cmp    $0x2,%eax
  100ca4:	76 b9                	jbe    100c5f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cab:	c9                   	leave  
  100cac:	c3                   	ret    

00100cad <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cad:	55                   	push   %ebp
  100cae:	89 e5                	mov    %esp,%ebp
  100cb0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb3:	e8 c3 fb ff ff       	call   10087b <print_kerninfo>
    return 0;
  100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbd:	c9                   	leave  
  100cbe:	c3                   	ret    

00100cbf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbf:	55                   	push   %ebp
  100cc0:	89 e5                	mov    %esp,%ebp
  100cc2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc5:	e8 fb fc ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccf:	c9                   	leave  
  100cd0:	c3                   	ret    

00100cd1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd1:	55                   	push   %ebp
  100cd2:	89 e5                	mov    %esp,%ebp
  100cd4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd7:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cdc:	85 c0                	test   %eax,%eax
  100cde:	74 02                	je     100ce2 <__panic+0x11>
        goto panic_dead;
  100ce0:	eb 48                	jmp    100d2a <__panic+0x59>
    }
    is_panic = 1;
  100ce2:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cec:	8d 45 14             	lea    0x14(%ebp),%eax
  100cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d00:	c7 04 24 06 65 10 00 	movl   $0x106506,(%esp)
  100d07:	e8 3b f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d13:	8b 45 10             	mov    0x10(%ebp),%eax
  100d16:	89 04 24             	mov    %eax,(%esp)
  100d19:	e8 f6 f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d1e:	c7 04 24 22 65 10 00 	movl   $0x106522,(%esp)
  100d25:	e8 1d f6 ff ff       	call   100347 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d2a:	e8 85 09 00 00       	call   1016b4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d36:	e8 b5 fe ff ff       	call   100bf0 <kmonitor>
    }
  100d3b:	eb f2                	jmp    100d2f <__panic+0x5e>

00100d3d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d43:	8d 45 14             	lea    0x14(%ebp),%eax
  100d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d50:	8b 45 08             	mov    0x8(%ebp),%eax
  100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d57:	c7 04 24 24 65 10 00 	movl   $0x106524,(%esp)
  100d5e:	e8 e4 f5 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6d:	89 04 24             	mov    %eax,(%esp)
  100d70:	e8 9f f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d75:	c7 04 24 22 65 10 00 	movl   $0x106522,(%esp)
  100d7c:	e8 c6 f5 ff ff       	call   100347 <cprintf>
    va_end(ap);
}
  100d81:	c9                   	leave  
  100d82:	c3                   	ret    

00100d83 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d83:	55                   	push   %ebp
  100d84:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d86:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d8b:	5d                   	pop    %ebp
  100d8c:	c3                   	ret    

00100d8d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8d:	55                   	push   %ebp
  100d8e:	89 e5                	mov    %esp,%ebp
  100d90:	83 ec 28             	sub    $0x28,%esp
  100d93:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d99:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d9d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
  100da6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dac:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db8:	ee                   	out    %al,(%dx)
  100db9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dcb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dcc:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dd3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd6:	c7 04 24 42 65 10 00 	movl   $0x106542,(%esp)
  100ddd:	e8 65 f5 ff ff       	call   100347 <cprintf>
    pic_enable(IRQ_TIMER);
  100de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de9:	e8 24 09 00 00       	call   101712 <pic_enable>
}
  100dee:	c9                   	leave  
  100def:	c3                   	ret    

00100df0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df0:	55                   	push   %ebp
  100df1:	89 e5                	mov    %esp,%ebp
  100df3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df6:	9c                   	pushf  
  100df7:	58                   	pop    %eax
  100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfe:	25 00 02 00 00       	and    $0x200,%eax
  100e03:	85 c0                	test   %eax,%eax
  100e05:	74 0c                	je     100e13 <__intr_save+0x23>
        intr_disable();
  100e07:	e8 a8 08 00 00       	call   1016b4 <intr_disable>
        return 1;
  100e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  100e11:	eb 05                	jmp    100e18 <__intr_save+0x28>
    }
    return 0;
  100e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e18:	c9                   	leave  
  100e19:	c3                   	ret    

00100e1a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e1a:	55                   	push   %ebp
  100e1b:	89 e5                	mov    %esp,%ebp
  100e1d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e24:	74 05                	je     100e2b <__intr_restore+0x11>
        intr_enable();
  100e26:	e8 83 08 00 00       	call   1016ae <intr_enable>
    }
}
  100e2b:	c9                   	leave  
  100e2c:	c3                   	ret    

00100e2d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2d:	55                   	push   %ebp
  100e2e:	89 e5                	mov    %esp,%ebp
  100e30:	83 ec 10             	sub    $0x10,%esp
  100e33:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e39:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3d:	89 c2                	mov    %eax,%edx
  100e3f:	ec                   	in     (%dx),%al
  100e40:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e43:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e49:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e53:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e63:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e69:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e73:	c9                   	leave  
  100e74:	c3                   	ret    

00100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e75:	55                   	push   %ebp
  100e76:	89 e5                	mov    %esp,%ebp
  100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e85:	0f b7 00             	movzwl (%eax),%eax
  100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 00             	movzwl (%eax),%eax
  100e9a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9e:	74 12                	je     100eb2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea7:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eae:	b4 03 
  100eb0:	eb 13                	jmp    100ec5 <cga_init+0x50>
    } else {
        *cp = was;
  100eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ebc:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ec3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ed3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100edb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee0:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee7:	83 c0 01             	add    $0x1,%eax
  100eea:	0f b7 c0             	movzwl %ax,%eax
  100eed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef5:	89 c2                	mov    %eax,%edx
  100ef7:	ec                   	in     (%dx),%al
  100ef8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100efb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eff:	0f b6 c0             	movzbl %al,%eax
  100f02:	c1 e0 08             	shl    $0x8,%eax
  100f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f08:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0f:	0f b7 c0             	movzwl %ax,%eax
  100f12:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f16:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f1a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f22:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f23:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f2a:	83 c0 01             	add    $0x1,%eax
  100f2d:	0f b7 c0             	movzwl %ax,%eax
  100f30:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f34:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f38:	89 c2                	mov    %eax,%edx
  100f3a:	ec                   	in     (%dx),%al
  100f3b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f42:	0f b6 c0             	movzbl %al,%eax
  100f45:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f4b:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f53:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f59:	c9                   	leave  
  100f5a:	c3                   	ret    

00100f5b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f5b:	55                   	push   %ebp
  100f5c:	89 e5                	mov    %esp,%ebp
  100f5e:	83 ec 48             	sub    $0x48,%esp
  100f61:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f67:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f6b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f7a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f82:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f86:	ee                   	out    %al,(%dx)
  100f87:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f8d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f99:	ee                   	out    %al,(%dx)
  100f9a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fac:	ee                   	out    %al,(%dx)
  100fad:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fb3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fbb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
  100fc0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fce:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd2:	ee                   	out    %al,(%dx)
  100fd3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fdd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe5:	ee                   	out    %al,(%dx)
  100fe6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fec:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ff0:	89 c2                	mov    %eax,%edx
  100ff2:	ec                   	in     (%dx),%al
  100ff3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ffa:	3c ff                	cmp    $0xff,%al
  100ffc:	0f 95 c0             	setne  %al
  100fff:	0f b6 c0             	movzbl %al,%eax
  101002:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101007:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101011:	89 c2                	mov    %eax,%edx
  101013:	ec                   	in     (%dx),%al
  101014:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101017:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10101d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101021:	89 c2                	mov    %eax,%edx
  101023:	ec                   	in     (%dx),%al
  101024:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101027:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10102c:	85 c0                	test   %eax,%eax
  10102e:	74 0c                	je     10103c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101030:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101037:	e8 d6 06 00 00       	call   101712 <pic_enable>
    }
}
  10103c:	c9                   	leave  
  10103d:	c3                   	ret    

0010103e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103e:	55                   	push   %ebp
  10103f:	89 e5                	mov    %esp,%ebp
  101041:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10104b:	eb 09                	jmp    101056 <lpt_putc_sub+0x18>
        delay();
  10104d:	e8 db fd ff ff       	call   100e2d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101052:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101056:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10105c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101060:	89 c2                	mov    %eax,%edx
  101062:	ec                   	in     (%dx),%al
  101063:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101066:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10106a:	84 c0                	test   %al,%al
  10106c:	78 09                	js     101077 <lpt_putc_sub+0x39>
  10106e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101075:	7e d6                	jle    10104d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101077:	8b 45 08             	mov    0x8(%ebp),%eax
  10107a:	0f b6 c0             	movzbl %al,%eax
  10107d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101083:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101086:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10108a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108e:	ee                   	out    %al,(%dx)
  10108f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101095:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101099:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10109d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a1:	ee                   	out    %al,(%dx)
  1010a2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b5:	c9                   	leave  
  1010b6:	c3                   	ret    

001010b7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b7:	55                   	push   %ebp
  1010b8:	89 e5                	mov    %esp,%ebp
  1010ba:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010bd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c1:	74 0d                	je     1010d0 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c6:	89 04 24             	mov    %eax,(%esp)
  1010c9:	e8 70 ff ff ff       	call   10103e <lpt_putc_sub>
  1010ce:	eb 24                	jmp    1010f4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010d0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d7:	e8 62 ff ff ff       	call   10103e <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010dc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e3:	e8 56 ff ff ff       	call   10103e <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ef:	e8 4a ff ff ff       	call   10103e <lpt_putc_sub>
    }
}
  1010f4:	c9                   	leave  
  1010f5:	c3                   	ret    

001010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f6:	55                   	push   %ebp
  1010f7:	89 e5                	mov    %esp,%ebp
  1010f9:	53                   	push   %ebx
  1010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	b0 00                	mov    $0x0,%al
  101102:	85 c0                	test   %eax,%eax
  101104:	75 07                	jne    10110d <cga_putc+0x17>
        c |= 0x0700;
  101106:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	0f b6 c0             	movzbl %al,%eax
  101113:	83 f8 0a             	cmp    $0xa,%eax
  101116:	74 4c                	je     101164 <cga_putc+0x6e>
  101118:	83 f8 0d             	cmp    $0xd,%eax
  10111b:	74 57                	je     101174 <cga_putc+0x7e>
  10111d:	83 f8 08             	cmp    $0x8,%eax
  101120:	0f 85 88 00 00 00    	jne    1011ae <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101126:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112d:	66 85 c0             	test   %ax,%ax
  101130:	74 30                	je     101162 <cga_putc+0x6c>
            crt_pos --;
  101132:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101139:	83 e8 01             	sub    $0x1,%eax
  10113c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101142:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101147:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10114e:	0f b7 d2             	movzwl %dx,%edx
  101151:	01 d2                	add    %edx,%edx
  101153:	01 c2                	add    %eax,%edx
  101155:	8b 45 08             	mov    0x8(%ebp),%eax
  101158:	b0 00                	mov    $0x0,%al
  10115a:	83 c8 20             	or     $0x20,%eax
  10115d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101160:	eb 72                	jmp    1011d4 <cga_putc+0xde>
  101162:	eb 70                	jmp    1011d4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101164:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10116b:	83 c0 50             	add    $0x50,%eax
  10116e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101174:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10117b:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101182:	0f b7 c1             	movzwl %cx,%eax
  101185:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10118b:	c1 e8 10             	shr    $0x10,%eax
  10118e:	89 c2                	mov    %eax,%edx
  101190:	66 c1 ea 06          	shr    $0x6,%dx
  101194:	89 d0                	mov    %edx,%eax
  101196:	c1 e0 02             	shl    $0x2,%eax
  101199:	01 d0                	add    %edx,%eax
  10119b:	c1 e0 04             	shl    $0x4,%eax
  10119e:	29 c1                	sub    %eax,%ecx
  1011a0:	89 ca                	mov    %ecx,%edx
  1011a2:	89 d8                	mov    %ebx,%eax
  1011a4:	29 d0                	sub    %edx,%eax
  1011a6:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011ac:	eb 26                	jmp    1011d4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ae:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011b4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011bb:	8d 50 01             	lea    0x1(%eax),%edx
  1011be:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c5:	0f b7 c0             	movzwl %ax,%eax
  1011c8:	01 c0                	add    %eax,%eax
  1011ca:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d0:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011db:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011df:	76 5b                	jbe    10123c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ec:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f8:	00 
  1011f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011fd:	89 04 24             	mov    %eax,(%esp)
  101200:	e8 d9 4e 00 00       	call   1060de <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101205:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120c:	eb 15                	jmp    101223 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101216:	01 d2                	add    %edx,%edx
  101218:	01 d0                	add    %edx,%eax
  10121a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10122a:	7e e2                	jle    10120e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10122c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101233:	83 e8 50             	sub    $0x50,%eax
  101236:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10123c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101243:	0f b7 c0             	movzwl %ax,%eax
  101246:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10124a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101252:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101257:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10125e:	66 c1 e8 08          	shr    $0x8,%ax
  101262:	0f b6 c0             	movzbl %al,%eax
  101265:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10126c:	83 c2 01             	add    $0x1,%edx
  10126f:	0f b7 d2             	movzwl %dx,%edx
  101272:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101276:	88 45 ed             	mov    %al,-0x13(%ebp)
  101279:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10127d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101282:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101289:	0f b7 c0             	movzwl %ax,%eax
  10128c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101290:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101294:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101298:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10129c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a4:	0f b6 c0             	movzbl %al,%eax
  1012a7:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012ae:	83 c2 01             	add    $0x1,%edx
  1012b1:	0f b7 d2             	movzwl %dx,%edx
  1012b4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b8:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c3:	ee                   	out    %al,(%dx)
}
  1012c4:	83 c4 34             	add    $0x34,%esp
  1012c7:	5b                   	pop    %ebx
  1012c8:	5d                   	pop    %ebp
  1012c9:	c3                   	ret    

001012ca <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ca:	55                   	push   %ebp
  1012cb:	89 e5                	mov    %esp,%ebp
  1012cd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d7:	eb 09                	jmp    1012e2 <serial_putc_sub+0x18>
        delay();
  1012d9:	e8 4f fb ff ff       	call   100e2d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ec:	89 c2                	mov    %eax,%edx
  1012ee:	ec                   	in     (%dx),%al
  1012ef:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f6:	0f b6 c0             	movzbl %al,%eax
  1012f9:	83 e0 20             	and    $0x20,%eax
  1012fc:	85 c0                	test   %eax,%eax
  1012fe:	75 09                	jne    101309 <serial_putc_sub+0x3f>
  101300:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101307:	7e d0                	jle    1012d9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101309:	8b 45 08             	mov    0x8(%ebp),%eax
  10130c:	0f b6 c0             	movzbl %al,%eax
  10130f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101315:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101318:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10131c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101320:	ee                   	out    %al,(%dx)
}
  101321:	c9                   	leave  
  101322:	c3                   	ret    

00101323 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101323:	55                   	push   %ebp
  101324:	89 e5                	mov    %esp,%ebp
  101326:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101329:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10132d:	74 0d                	je     10133c <serial_putc+0x19>
        serial_putc_sub(c);
  10132f:	8b 45 08             	mov    0x8(%ebp),%eax
  101332:	89 04 24             	mov    %eax,(%esp)
  101335:	e8 90 ff ff ff       	call   1012ca <serial_putc_sub>
  10133a:	eb 24                	jmp    101360 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10133c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101343:	e8 82 ff ff ff       	call   1012ca <serial_putc_sub>
        serial_putc_sub(' ');
  101348:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134f:	e8 76 ff ff ff       	call   1012ca <serial_putc_sub>
        serial_putc_sub('\b');
  101354:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10135b:	e8 6a ff ff ff       	call   1012ca <serial_putc_sub>
    }
}
  101360:	c9                   	leave  
  101361:	c3                   	ret    

00101362 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101362:	55                   	push   %ebp
  101363:	89 e5                	mov    %esp,%ebp
  101365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101368:	eb 33                	jmp    10139d <cons_intr+0x3b>
        if (c != 0) {
  10136a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136e:	74 2d                	je     10139d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101370:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101375:	8d 50 01             	lea    0x1(%eax),%edx
  101378:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101381:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101387:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10138c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101391:	75 0a                	jne    10139d <cons_intr+0x3b>
                cons.wpos = 0;
  101393:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10139a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10139d:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a0:	ff d0                	call   *%eax
  1013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a9:	75 bf                	jne    10136a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 10             	sub    $0x10,%esp
  1013b3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bd:	89 c2                	mov    %eax,%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	83 e0 01             	and    $0x1,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	75 07                	jne    1013d8 <serial_proc_data+0x2b>
        return -1;
  1013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d6:	eb 2a                	jmp    101402 <serial_proc_data+0x55>
  1013d8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013de:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e2:	89 c2                	mov    %eax,%edx
  1013e4:	ec                   	in     (%dx),%al
  1013e5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ec:	0f b6 c0             	movzbl %al,%eax
  1013ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f6:	75 07                	jne    1013ff <serial_proc_data+0x52>
        c = '\b';
  1013f8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101402:	c9                   	leave  
  101403:	c3                   	ret    

00101404 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101404:	55                   	push   %ebp
  101405:	89 e5                	mov    %esp,%ebp
  101407:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10140a:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140f:	85 c0                	test   %eax,%eax
  101411:	74 0c                	je     10141f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101413:	c7 04 24 ad 13 10 00 	movl   $0x1013ad,(%esp)
  10141a:	e8 43 ff ff ff       	call   101362 <cons_intr>
    }
}
  10141f:	c9                   	leave  
  101420:	c3                   	ret    

00101421 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101421:	55                   	push   %ebp
  101422:	89 e5                	mov    %esp,%ebp
  101424:	83 ec 38             	sub    $0x38,%esp
  101427:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101431:	89 c2                	mov    %eax,%edx
  101433:	ec                   	in     (%dx),%al
  101434:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101437:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10143b:	0f b6 c0             	movzbl %al,%eax
  10143e:	83 e0 01             	and    $0x1,%eax
  101441:	85 c0                	test   %eax,%eax
  101443:	75 0a                	jne    10144f <kbd_proc_data+0x2e>
        return -1;
  101445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10144a:	e9 59 01 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
  10144f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101455:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101459:	89 c2                	mov    %eax,%edx
  10145b:	ec                   	in     (%dx),%al
  10145c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101463:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101466:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10146a:	75 17                	jne    101483 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10146c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101471:	83 c8 40             	or     $0x40,%eax
  101474:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101479:	b8 00 00 00 00       	mov    $0x0,%eax
  10147e:	e9 25 01 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101487:	84 c0                	test   %al,%al
  101489:	79 47                	jns    1014d2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10148b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101490:	83 e0 40             	and    $0x40,%eax
  101493:	85 c0                	test   %eax,%eax
  101495:	75 09                	jne    1014a0 <kbd_proc_data+0x7f>
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	83 e0 7f             	and    $0x7f,%eax
  10149e:	eb 04                	jmp    1014a4 <kbd_proc_data+0x83>
  1014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014b2:	83 c8 40             	or     $0x40,%eax
  1014b5:	0f b6 c0             	movzbl %al,%eax
  1014b8:	f7 d0                	not    %eax
  1014ba:	89 c2                	mov    %eax,%edx
  1014bc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c1:	21 d0                	and    %edx,%eax
  1014c3:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cd:	e9 d6 00 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d7:	83 e0 40             	and    $0x40,%eax
  1014da:	85 c0                	test   %eax,%eax
  1014dc:	74 11                	je     1014ef <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014de:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e7:	83 e0 bf             	and    $0xffffffbf,%eax
  1014ea:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f3:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014fa:	0f b6 d0             	movzbl %al,%edx
  1014fd:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101502:	09 d0                	or     %edx,%eax
  101504:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150d:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101514:	0f b6 d0             	movzbl %al,%edx
  101517:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151c:	31 d0                	xor    %edx,%eax
  10151e:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101523:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101528:	83 e0 03             	and    $0x3,%eax
  10152b:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101532:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101536:	01 d0                	add    %edx,%eax
  101538:	0f b6 00             	movzbl (%eax),%eax
  10153b:	0f b6 c0             	movzbl %al,%eax
  10153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101541:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101546:	83 e0 08             	and    $0x8,%eax
  101549:	85 c0                	test   %eax,%eax
  10154b:	74 22                	je     10156f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10154d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101551:	7e 0c                	jle    10155f <kbd_proc_data+0x13e>
  101553:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101557:	7f 06                	jg     10155f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101559:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10155d:	eb 10                	jmp    10156f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101563:	7e 0a                	jle    10156f <kbd_proc_data+0x14e>
  101565:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101569:	7f 04                	jg     10156f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10156b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101574:	f7 d0                	not    %eax
  101576:	83 e0 06             	and    $0x6,%eax
  101579:	85 c0                	test   %eax,%eax
  10157b:	75 28                	jne    1015a5 <kbd_proc_data+0x184>
  10157d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101584:	75 1f                	jne    1015a5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101586:	c7 04 24 5d 65 10 00 	movl   $0x10655d,(%esp)
  10158d:	e8 b5 ed ff ff       	call   100347 <cprintf>
  101592:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101598:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10159c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a8:	c9                   	leave  
  1015a9:	c3                   	ret    

001015aa <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015aa:	55                   	push   %ebp
  1015ab:	89 e5                	mov    %esp,%ebp
  1015ad:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b0:	c7 04 24 21 14 10 00 	movl   $0x101421,(%esp)
  1015b7:	e8 a6 fd ff ff       	call   101362 <cons_intr>
}
  1015bc:	c9                   	leave  
  1015bd:	c3                   	ret    

001015be <kbd_init>:

static void
kbd_init(void) {
  1015be:	55                   	push   %ebp
  1015bf:	89 e5                	mov    %esp,%ebp
  1015c1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c4:	e8 e1 ff ff ff       	call   1015aa <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d0:	e8 3d 01 00 00       	call   101712 <pic_enable>
}
  1015d5:	c9                   	leave  
  1015d6:	c3                   	ret    

001015d7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d7:	55                   	push   %ebp
  1015d8:	89 e5                	mov    %esp,%ebp
  1015da:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015dd:	e8 93 f8 ff ff       	call   100e75 <cga_init>
    serial_init();
  1015e2:	e8 74 f9 ff ff       	call   100f5b <serial_init>
    kbd_init();
  1015e7:	e8 d2 ff ff ff       	call   1015be <kbd_init>
    if (!serial_exists) {
  1015ec:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015f1:	85 c0                	test   %eax,%eax
  1015f3:	75 0c                	jne    101601 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f5:	c7 04 24 69 65 10 00 	movl   $0x106569,(%esp)
  1015fc:	e8 46 ed ff ff       	call   100347 <cprintf>
    }
}
  101601:	c9                   	leave  
  101602:	c3                   	ret    

00101603 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101603:	55                   	push   %ebp
  101604:	89 e5                	mov    %esp,%ebp
  101606:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101609:	e8 e2 f7 ff ff       	call   100df0 <__intr_save>
  10160e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 9b fa ff ff       	call   1010b7 <lpt_putc>
        cga_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 cf fa ff ff       	call   1010f6 <cga_putc>
        serial_putc(c);
  101627:	8b 45 08             	mov    0x8(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 f1 fc ff ff       	call   101323 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101635:	89 04 24             	mov    %eax,(%esp)
  101638:	e8 dd f7 ff ff       	call   100e1a <__intr_restore>
}
  10163d:	c9                   	leave  
  10163e:	c3                   	ret    

0010163f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163f:	55                   	push   %ebp
  101640:	89 e5                	mov    %esp,%ebp
  101642:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10164c:	e8 9f f7 ff ff       	call   100df0 <__intr_save>
  101651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101654:	e8 ab fd ff ff       	call   101404 <serial_intr>
        kbd_intr();
  101659:	e8 4c ff ff ff       	call   1015aa <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165e:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101664:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101669:	39 c2                	cmp    %eax,%edx
  10166b:	74 31                	je     10169e <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10166d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101672:	8d 50 01             	lea    0x1(%eax),%edx
  101675:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10167b:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101682:	0f b6 c0             	movzbl %al,%eax
  101685:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101688:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10168d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101692:	75 0a                	jne    10169e <cons_getc+0x5f>
                cons.rpos = 0;
  101694:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10169b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016a1:	89 04 24             	mov    %eax,(%esp)
  1016a4:	e8 71 f7 ff ff       	call   100e1a <__intr_restore>
    return c;
  1016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016ac:	c9                   	leave  
  1016ad:	c3                   	ret    

001016ae <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016b1:	fb                   	sti    
    sti();
}
  1016b2:	5d                   	pop    %ebp
  1016b3:	c3                   	ret    

001016b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b7:	fa                   	cli    
    cli();
}
  1016b8:	5d                   	pop    %ebp
  1016b9:	c3                   	ret    

001016ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
  1016bd:	83 ec 14             	sub    $0x14,%esp
  1016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016cb:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016d1:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d6:	85 c0                	test   %eax,%eax
  1016d8:	74 36                	je     101710 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016da:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016ea:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ee:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f7:	66 c1 e8 08          	shr    $0x8,%ax
  1016fb:	0f b6 c0             	movzbl %al,%eax
  1016fe:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101704:	88 45 f9             	mov    %al,-0x7(%ebp)
  101707:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10170b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
    }
}
  101710:	c9                   	leave  
  101711:	c3                   	ret    

00101712 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101712:	55                   	push   %ebp
  101713:	89 e5                	mov    %esp,%ebp
  101715:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101718:	8b 45 08             	mov    0x8(%ebp),%eax
  10171b:	ba 01 00 00 00       	mov    $0x1,%edx
  101720:	89 c1                	mov    %eax,%ecx
  101722:	d3 e2                	shl    %cl,%edx
  101724:	89 d0                	mov    %edx,%eax
  101726:	f7 d0                	not    %eax
  101728:	89 c2                	mov    %eax,%edx
  10172a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101731:	21 d0                	and    %edx,%eax
  101733:	0f b7 c0             	movzwl %ax,%eax
  101736:	89 04 24             	mov    %eax,(%esp)
  101739:	e8 7c ff ff ff       	call   1016ba <pic_setmask>
}
  10173e:	c9                   	leave  
  10173f:	c3                   	ret    

00101740 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101740:	55                   	push   %ebp
  101741:	89 e5                	mov    %esp,%ebp
  101743:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101746:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10174d:	00 00 00 
  101750:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101756:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10175a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101769:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10176d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101771:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10177c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101780:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101784:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101793:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101797:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017bd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
  1017c2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017cc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d4:	ee                   	out    %al,(%dx)
  1017d5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017db:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017df:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e7:	ee                   	out    %al,(%dx)
  1017e8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ee:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017fa:	ee                   	out    %al,(%dx)
  1017fb:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101801:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101805:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101809:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10180d:	ee                   	out    %al,(%dx)
  10180e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101814:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101818:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10181c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101820:	ee                   	out    %al,(%dx)
  101821:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101827:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10182b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101833:	ee                   	out    %al,(%dx)
  101834:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10183a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101842:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101846:	ee                   	out    %al,(%dx)
  101847:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10184d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101851:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101855:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101859:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10185a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101861:	66 83 f8 ff          	cmp    $0xffff,%ax
  101865:	74 12                	je     101879 <pic_init+0x139>
        pic_setmask(irq_mask);
  101867:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10186e:	0f b7 c0             	movzwl %ax,%eax
  101871:	89 04 24             	mov    %eax,(%esp)
  101874:	e8 41 fe ff ff       	call   1016ba <pic_setmask>
    }
}
  101879:	c9                   	leave  
  10187a:	c3                   	ret    

0010187b <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10187b:	55                   	push   %ebp
  10187c:	89 e5                	mov    %esp,%ebp
  10187e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101881:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101888:	00 
  101889:	c7 04 24 a0 65 10 00 	movl   $0x1065a0,(%esp)
  101890:	e8 b2 ea ff ff       	call   100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101895:	c9                   	leave  
  101896:	c3                   	ret    

00101897 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101897:	55                   	push   %ebp
  101898:	89 e5                	mov    %esp,%ebp
  10189a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10189d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018a4:	e9 c3 00 00 00       	jmp    10196c <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ac:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018b3:	89 c2                	mov    %eax,%edx
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018bf:	00 
  1018c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c3:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018ca:	00 08 00 
  1018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d0:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018d7:	00 
  1018d8:	83 e2 e0             	and    $0xffffffe0,%edx
  1018db:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e5:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018ec:	00 
  1018ed:	83 e2 1f             	and    $0x1f,%edx
  1018f0:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fa:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101901:	00 
  101902:	83 e2 f0             	and    $0xfffffff0,%edx
  101905:	83 ca 0e             	or     $0xe,%edx
  101908:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101912:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101919:	00 
  10191a:	83 e2 ef             	and    $0xffffffef,%edx
  10191d:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101924:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101927:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10192e:	00 
  10192f:	83 e2 9f             	and    $0xffffff9f,%edx
  101932:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101939:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101943:	00 
  101944:	83 ca 80             	or     $0xffffff80,%edx
  101947:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101951:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101958:	c1 e8 10             	shr    $0x10,%eax
  10195b:	89 c2                	mov    %eax,%edx
  10195d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101960:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101967:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101968:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101974:	0f 86 2f ff ff ff    	jbe    1018a9 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10197a:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  10197f:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101985:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  10198c:	08 00 
  10198e:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101995:	83 e0 e0             	and    $0xffffffe0,%eax
  101998:	a2 8c 84 11 00       	mov    %al,0x11848c
  10199d:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019a4:	83 e0 1f             	and    $0x1f,%eax
  1019a7:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019ac:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019b3:	83 e0 f0             	and    $0xfffffff0,%eax
  1019b6:	83 c8 0e             	or     $0xe,%eax
  1019b9:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019be:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c5:	83 e0 ef             	and    $0xffffffef,%eax
  1019c8:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019cd:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d4:	83 c8 60             	or     $0x60,%eax
  1019d7:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019dc:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019e3:	83 c8 80             	or     $0xffffff80,%eax
  1019e6:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019eb:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019f0:	c1 e8 10             	shr    $0x10,%eax
  1019f3:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019f9:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a03:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a06:	c9                   	leave  
  101a07:	c3                   	ret    

00101a08 <trapname>:

static const char *
trapname(int trapno) {
  101a08:	55                   	push   %ebp
  101a09:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0e:	83 f8 13             	cmp    $0x13,%eax
  101a11:	77 0c                	ja     101a1f <trapname+0x17>
        return excnames[trapno];
  101a13:	8b 45 08             	mov    0x8(%ebp),%eax
  101a16:	8b 04 85 00 69 10 00 	mov    0x106900(,%eax,4),%eax
  101a1d:	eb 18                	jmp    101a37 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a1f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a23:	7e 0d                	jle    101a32 <trapname+0x2a>
  101a25:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a29:	7f 07                	jg     101a32 <trapname+0x2a>
        return "Hardware Interrupt";
  101a2b:	b8 aa 65 10 00       	mov    $0x1065aa,%eax
  101a30:	eb 05                	jmp    101a37 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a32:	b8 bd 65 10 00       	mov    $0x1065bd,%eax
}
  101a37:	5d                   	pop    %ebp
  101a38:	c3                   	ret    

00101a39 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a39:	55                   	push   %ebp
  101a3a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a43:	66 83 f8 08          	cmp    $0x8,%ax
  101a47:	0f 94 c0             	sete   %al
  101a4a:	0f b6 c0             	movzbl %al,%eax
}
  101a4d:	5d                   	pop    %ebp
  101a4e:	c3                   	ret    

00101a4f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a4f:	55                   	push   %ebp
  101a50:	89 e5                	mov    %esp,%ebp
  101a52:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5c:	c7 04 24 fe 65 10 00 	movl   $0x1065fe,(%esp)
  101a63:	e8 df e8 ff ff       	call   100347 <cprintf>
    print_regs(&tf->tf_regs);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	89 04 24             	mov    %eax,(%esp)
  101a6e:	e8 a1 01 00 00       	call   101c14 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a73:	8b 45 08             	mov    0x8(%ebp),%eax
  101a76:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a7a:	0f b7 c0             	movzwl %ax,%eax
  101a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a81:	c7 04 24 0f 66 10 00 	movl   $0x10660f,(%esp)
  101a88:	e8 ba e8 ff ff       	call   100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a94:	0f b7 c0             	movzwl %ax,%eax
  101a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9b:	c7 04 24 22 66 10 00 	movl   $0x106622,(%esp)
  101aa2:	e8 a0 e8 ff ff       	call   100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaa:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aae:	0f b7 c0             	movzwl %ax,%eax
  101ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab5:	c7 04 24 35 66 10 00 	movl   $0x106635,(%esp)
  101abc:	e8 86 e8 ff ff       	call   100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac8:	0f b7 c0             	movzwl %ax,%eax
  101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acf:	c7 04 24 48 66 10 00 	movl   $0x106648,(%esp)
  101ad6:	e8 6c e8 ff ff       	call   100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101adb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ade:	8b 40 30             	mov    0x30(%eax),%eax
  101ae1:	89 04 24             	mov    %eax,(%esp)
  101ae4:	e8 1f ff ff ff       	call   101a08 <trapname>
  101ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  101aec:	8b 52 30             	mov    0x30(%edx),%edx
  101aef:	89 44 24 08          	mov    %eax,0x8(%esp)
  101af3:	89 54 24 04          	mov    %edx,0x4(%esp)
  101af7:	c7 04 24 5b 66 10 00 	movl   $0x10665b,(%esp)
  101afe:	e8 44 e8 ff ff       	call   100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	8b 40 34             	mov    0x34(%eax),%eax
  101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0d:	c7 04 24 6d 66 10 00 	movl   $0x10666d,(%esp)
  101b14:	e8 2e e8 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	8b 40 38             	mov    0x38(%eax),%eax
  101b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b23:	c7 04 24 7c 66 10 00 	movl   $0x10667c,(%esp)
  101b2a:	e8 18 e8 ff ff       	call   100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b36:	0f b7 c0             	movzwl %ax,%eax
  101b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3d:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  101b44:	e8 fe e7 ff ff       	call   100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b49:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4c:	8b 40 40             	mov    0x40(%eax),%eax
  101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b53:	c7 04 24 9e 66 10 00 	movl   $0x10669e,(%esp)
  101b5a:	e8 e8 e7 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b66:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b6d:	eb 3e                	jmp    101bad <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	8b 50 40             	mov    0x40(%eax),%edx
  101b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b78:	21 d0                	and    %edx,%eax
  101b7a:	85 c0                	test   %eax,%eax
  101b7c:	74 28                	je     101ba6 <print_trapframe+0x157>
  101b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b81:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b88:	85 c0                	test   %eax,%eax
  101b8a:	74 1a                	je     101ba6 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b8f:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9a:	c7 04 24 ad 66 10 00 	movl   $0x1066ad,(%esp)
  101ba1:	e8 a1 e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101baa:	d1 65 f0             	shll   -0x10(%ebp)
  101bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb0:	83 f8 17             	cmp    $0x17,%eax
  101bb3:	76 ba                	jbe    101b6f <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb8:	8b 40 40             	mov    0x40(%eax),%eax
  101bbb:	25 00 30 00 00       	and    $0x3000,%eax
  101bc0:	c1 e8 0c             	shr    $0xc,%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 b1 66 10 00 	movl   $0x1066b1,(%esp)
  101bce:	e8 74 e7 ff ff       	call   100347 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd6:	89 04 24             	mov    %eax,(%esp)
  101bd9:	e8 5b fe ff ff       	call   101a39 <trap_in_kernel>
  101bde:	85 c0                	test   %eax,%eax
  101be0:	75 30                	jne    101c12 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	8b 40 44             	mov    0x44(%eax),%eax
  101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bec:	c7 04 24 ba 66 10 00 	movl   $0x1066ba,(%esp)
  101bf3:	e8 4f e7 ff ff       	call   100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bff:	0f b7 c0             	movzwl %ax,%eax
  101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c06:	c7 04 24 c9 66 10 00 	movl   $0x1066c9,(%esp)
  101c0d:	e8 35 e7 ff ff       	call   100347 <cprintf>
    }
}
  101c12:	c9                   	leave  
  101c13:	c3                   	ret    

00101c14 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c14:	55                   	push   %ebp
  101c15:	89 e5                	mov    %esp,%ebp
  101c17:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1d:	8b 00                	mov    (%eax),%eax
  101c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c23:	c7 04 24 dc 66 10 00 	movl   $0x1066dc,(%esp)
  101c2a:	e8 18 e7 ff ff       	call   100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c32:	8b 40 04             	mov    0x4(%eax),%eax
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  101c40:	e8 02 e7 ff ff       	call   100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c45:	8b 45 08             	mov    0x8(%ebp),%eax
  101c48:	8b 40 08             	mov    0x8(%eax),%eax
  101c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4f:	c7 04 24 fa 66 10 00 	movl   $0x1066fa,(%esp)
  101c56:	e8 ec e6 ff ff       	call   100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5e:	8b 40 0c             	mov    0xc(%eax),%eax
  101c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c65:	c7 04 24 09 67 10 00 	movl   $0x106709,(%esp)
  101c6c:	e8 d6 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 10             	mov    0x10(%eax),%eax
  101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7b:	c7 04 24 18 67 10 00 	movl   $0x106718,(%esp)
  101c82:	e8 c0 e6 ff ff       	call   100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c87:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8a:	8b 40 14             	mov    0x14(%eax),%eax
  101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c91:	c7 04 24 27 67 10 00 	movl   $0x106727,(%esp)
  101c98:	e8 aa e6 ff ff       	call   100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca0:	8b 40 18             	mov    0x18(%eax),%eax
  101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca7:	c7 04 24 36 67 10 00 	movl   $0x106736,(%esp)
  101cae:	e8 94 e6 ff ff       	call   100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb6:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbd:	c7 04 24 45 67 10 00 	movl   $0x106745,(%esp)
  101cc4:	e8 7e e6 ff ff       	call   100347 <cprintf>
}
  101cc9:	c9                   	leave  
  101cca:	c3                   	ret    

00101ccb <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ccb:	55                   	push   %ebp
  101ccc:	89 e5                	mov    %esp,%ebp
  101cce:	57                   	push   %edi
  101ccf:	56                   	push   %esi
  101cd0:	53                   	push   %ebx
  101cd1:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	8b 40 30             	mov    0x30(%eax),%eax
  101cda:	83 f8 2f             	cmp    $0x2f,%eax
  101cdd:	77 21                	ja     101d00 <trap_dispatch+0x35>
  101cdf:	83 f8 2e             	cmp    $0x2e,%eax
  101ce2:	0f 83 ec 01 00 00    	jae    101ed4 <trap_dispatch+0x209>
  101ce8:	83 f8 21             	cmp    $0x21,%eax
  101ceb:	0f 84 8a 00 00 00    	je     101d7b <trap_dispatch+0xb0>
  101cf1:	83 f8 24             	cmp    $0x24,%eax
  101cf4:	74 5c                	je     101d52 <trap_dispatch+0x87>
  101cf6:	83 f8 20             	cmp    $0x20,%eax
  101cf9:	74 1c                	je     101d17 <trap_dispatch+0x4c>
  101cfb:	e9 9c 01 00 00       	jmp    101e9c <trap_dispatch+0x1d1>
  101d00:	83 f8 78             	cmp    $0x78,%eax
  101d03:	0f 84 9b 00 00 00    	je     101da4 <trap_dispatch+0xd9>
  101d09:	83 f8 79             	cmp    $0x79,%eax
  101d0c:	0f 84 11 01 00 00    	je     101e23 <trap_dispatch+0x158>
  101d12:	e9 85 01 00 00       	jmp    101e9c <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d17:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d1c:	83 c0 01             	add    $0x1,%eax
  101d1f:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101d24:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d2a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d2f:	89 c8                	mov    %ecx,%eax
  101d31:	f7 e2                	mul    %edx
  101d33:	89 d0                	mov    %edx,%eax
  101d35:	c1 e8 05             	shr    $0x5,%eax
  101d38:	6b c0 64             	imul   $0x64,%eax,%eax
  101d3b:	29 c1                	sub    %eax,%ecx
  101d3d:	89 c8                	mov    %ecx,%eax
  101d3f:	85 c0                	test   %eax,%eax
  101d41:	75 0a                	jne    101d4d <trap_dispatch+0x82>
            print_ticks();
  101d43:	e8 33 fb ff ff       	call   10187b <print_ticks>
        }
        break;
  101d48:	e9 88 01 00 00       	jmp    101ed5 <trap_dispatch+0x20a>
  101d4d:	e9 83 01 00 00       	jmp    101ed5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d52:	e8 e8 f8 ff ff       	call   10163f <cons_getc>
  101d57:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d5a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d5e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d62:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6a:	c7 04 24 54 67 10 00 	movl   $0x106754,(%esp)
  101d71:	e8 d1 e5 ff ff       	call   100347 <cprintf>
        break;
  101d76:	e9 5a 01 00 00       	jmp    101ed5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d7b:	e8 bf f8 ff ff       	call   10163f <cons_getc>
  101d80:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d83:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d87:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d93:	c7 04 24 66 67 10 00 	movl   $0x106766,(%esp)
  101d9a:	e8 a8 e5 ff ff       	call   100347 <cprintf>
        break;
  101d9f:	e9 31 01 00 00       	jmp    101ed5 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101da4:	8b 45 08             	mov    0x8(%ebp),%eax
  101da7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dab:	66 83 f8 1b          	cmp    $0x1b,%ax
  101daf:	74 6d                	je     101e1e <trap_dispatch+0x153>
            switchk2u = *tf;
  101db1:	8b 45 08             	mov    0x8(%ebp),%eax
  101db4:	ba 60 89 11 00       	mov    $0x118960,%edx
  101db9:	89 c3                	mov    %eax,%ebx
  101dbb:	b8 13 00 00 00       	mov    $0x13,%eax
  101dc0:	89 d7                	mov    %edx,%edi
  101dc2:	89 de                	mov    %ebx,%esi
  101dc4:	89 c1                	mov    %eax,%ecx
  101dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101dc8:	66 c7 05 9c 89 11 00 	movw   $0x1b,0x11899c
  101dcf:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101dd1:	66 c7 05 a8 89 11 00 	movw   $0x23,0x1189a8
  101dd8:	23 00 
  101dda:	0f b7 05 a8 89 11 00 	movzwl 0x1189a8,%eax
  101de1:	66 a3 88 89 11 00    	mov    %ax,0x118988
  101de7:	0f b7 05 88 89 11 00 	movzwl 0x118988,%eax
  101dee:	66 a3 8c 89 11 00    	mov    %ax,0x11898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101df4:	8b 45 08             	mov    0x8(%ebp),%eax
  101df7:	83 c0 44             	add    $0x44,%eax
  101dfa:	a3 a4 89 11 00       	mov    %eax,0x1189a4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101dff:	a1 a0 89 11 00       	mov    0x1189a0,%eax
  101e04:	80 cc 30             	or     $0x30,%ah
  101e07:	a3 a0 89 11 00       	mov    %eax,0x1189a0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0f:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e12:	b8 60 89 11 00       	mov    $0x118960,%eax
  101e17:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e19:	e9 b7 00 00 00       	jmp    101ed5 <trap_dispatch+0x20a>
  101e1e:	e9 b2 00 00 00       	jmp    101ed5 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e23:	8b 45 08             	mov    0x8(%ebp),%eax
  101e26:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e2a:	66 83 f8 08          	cmp    $0x8,%ax
  101e2e:	74 6a                	je     101e9a <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
  101e30:	8b 45 08             	mov    0x8(%ebp),%eax
  101e33:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e39:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e42:	8b 45 08             	mov    0x8(%ebp),%eax
  101e45:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e49:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e50:	8b 45 08             	mov    0x8(%ebp),%eax
  101e53:	8b 40 40             	mov    0x40(%eax),%eax
  101e56:	80 e4 cf             	and    $0xcf,%ah
  101e59:	89 c2                	mov    %eax,%edx
  101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5e:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e61:	8b 45 08             	mov    0x8(%ebp),%eax
  101e64:	8b 40 44             	mov    0x44(%eax),%eax
  101e67:	83 e8 44             	sub    $0x44,%eax
  101e6a:	a3 ac 89 11 00       	mov    %eax,0x1189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e6f:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101e74:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e7b:	00 
  101e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  101e7f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e83:	89 04 24             	mov    %eax,(%esp)
  101e86:	e8 53 42 00 00       	call   1060de <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8e:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e91:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101e96:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e98:	eb 3b                	jmp    101ed5 <trap_dispatch+0x20a>
  101e9a:	eb 39                	jmp    101ed5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea3:	0f b7 c0             	movzwl %ax,%eax
  101ea6:	83 e0 03             	and    $0x3,%eax
  101ea9:	85 c0                	test   %eax,%eax
  101eab:	75 28                	jne    101ed5 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101ead:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb0:	89 04 24             	mov    %eax,(%esp)
  101eb3:	e8 97 fb ff ff       	call   101a4f <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101eb8:	c7 44 24 08 75 67 10 	movl   $0x106775,0x8(%esp)
  101ebf:	00 
  101ec0:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101ec7:	00 
  101ec8:	c7 04 24 91 67 10 00 	movl   $0x106791,(%esp)
  101ecf:	e8 fd ed ff ff       	call   100cd1 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ed4:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ed5:	83 c4 2c             	add    $0x2c,%esp
  101ed8:	5b                   	pop    %ebx
  101ed9:	5e                   	pop    %esi
  101eda:	5f                   	pop    %edi
  101edb:	5d                   	pop    %ebp
  101edc:	c3                   	ret    

00101edd <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101edd:	55                   	push   %ebp
  101ede:	89 e5                	mov    %esp,%ebp
  101ee0:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee6:	89 04 24             	mov    %eax,(%esp)
  101ee9:	e8 dd fd ff ff       	call   101ccb <trap_dispatch>
}
  101eee:	c9                   	leave  
  101eef:	c3                   	ret    

00101ef0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ef0:	1e                   	push   %ds
    pushl %es
  101ef1:	06                   	push   %es
    pushl %fs
  101ef2:	0f a0                	push   %fs
    pushl %gs
  101ef4:	0f a8                	push   %gs
    pushal
  101ef6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ef7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101efc:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101efe:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f00:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f01:	e8 d7 ff ff ff       	call   101edd <trap>

    # pop the pushed stack pointer
    popl %esp
  101f06:	5c                   	pop    %esp

00101f07 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f07:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f08:	0f a9                	pop    %gs
    popl %fs
  101f0a:	0f a1                	pop    %fs
    popl %es
  101f0c:	07                   	pop    %es
    popl %ds
  101f0d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f0e:	83 c4 08             	add    $0x8,%esp
    iret
  101f11:	cf                   	iret   

00101f12 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $0
  101f14:	6a 00                	push   $0x0
  jmp __alltraps
  101f16:	e9 d5 ff ff ff       	jmp    101ef0 <__alltraps>

00101f1b <vector1>:
.globl vector1
vector1:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $1
  101f1d:	6a 01                	push   $0x1
  jmp __alltraps
  101f1f:	e9 cc ff ff ff       	jmp    101ef0 <__alltraps>

00101f24 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $2
  101f26:	6a 02                	push   $0x2
  jmp __alltraps
  101f28:	e9 c3 ff ff ff       	jmp    101ef0 <__alltraps>

00101f2d <vector3>:
.globl vector3
vector3:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $3
  101f2f:	6a 03                	push   $0x3
  jmp __alltraps
  101f31:	e9 ba ff ff ff       	jmp    101ef0 <__alltraps>

00101f36 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $4
  101f38:	6a 04                	push   $0x4
  jmp __alltraps
  101f3a:	e9 b1 ff ff ff       	jmp    101ef0 <__alltraps>

00101f3f <vector5>:
.globl vector5
vector5:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $5
  101f41:	6a 05                	push   $0x5
  jmp __alltraps
  101f43:	e9 a8 ff ff ff       	jmp    101ef0 <__alltraps>

00101f48 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $6
  101f4a:	6a 06                	push   $0x6
  jmp __alltraps
  101f4c:	e9 9f ff ff ff       	jmp    101ef0 <__alltraps>

00101f51 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $7
  101f53:	6a 07                	push   $0x7
  jmp __alltraps
  101f55:	e9 96 ff ff ff       	jmp    101ef0 <__alltraps>

00101f5a <vector8>:
.globl vector8
vector8:
  pushl $8
  101f5a:	6a 08                	push   $0x8
  jmp __alltraps
  101f5c:	e9 8f ff ff ff       	jmp    101ef0 <__alltraps>

00101f61 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f61:	6a 09                	push   $0x9
  jmp __alltraps
  101f63:	e9 88 ff ff ff       	jmp    101ef0 <__alltraps>

00101f68 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f68:	6a 0a                	push   $0xa
  jmp __alltraps
  101f6a:	e9 81 ff ff ff       	jmp    101ef0 <__alltraps>

00101f6f <vector11>:
.globl vector11
vector11:
  pushl $11
  101f6f:	6a 0b                	push   $0xb
  jmp __alltraps
  101f71:	e9 7a ff ff ff       	jmp    101ef0 <__alltraps>

00101f76 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f76:	6a 0c                	push   $0xc
  jmp __alltraps
  101f78:	e9 73 ff ff ff       	jmp    101ef0 <__alltraps>

00101f7d <vector13>:
.globl vector13
vector13:
  pushl $13
  101f7d:	6a 0d                	push   $0xd
  jmp __alltraps
  101f7f:	e9 6c ff ff ff       	jmp    101ef0 <__alltraps>

00101f84 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f84:	6a 0e                	push   $0xe
  jmp __alltraps
  101f86:	e9 65 ff ff ff       	jmp    101ef0 <__alltraps>

00101f8b <vector15>:
.globl vector15
vector15:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $15
  101f8d:	6a 0f                	push   $0xf
  jmp __alltraps
  101f8f:	e9 5c ff ff ff       	jmp    101ef0 <__alltraps>

00101f94 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $16
  101f96:	6a 10                	push   $0x10
  jmp __alltraps
  101f98:	e9 53 ff ff ff       	jmp    101ef0 <__alltraps>

00101f9d <vector17>:
.globl vector17
vector17:
  pushl $17
  101f9d:	6a 11                	push   $0x11
  jmp __alltraps
  101f9f:	e9 4c ff ff ff       	jmp    101ef0 <__alltraps>

00101fa4 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $18
  101fa6:	6a 12                	push   $0x12
  jmp __alltraps
  101fa8:	e9 43 ff ff ff       	jmp    101ef0 <__alltraps>

00101fad <vector19>:
.globl vector19
vector19:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $19
  101faf:	6a 13                	push   $0x13
  jmp __alltraps
  101fb1:	e9 3a ff ff ff       	jmp    101ef0 <__alltraps>

00101fb6 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $20
  101fb8:	6a 14                	push   $0x14
  jmp __alltraps
  101fba:	e9 31 ff ff ff       	jmp    101ef0 <__alltraps>

00101fbf <vector21>:
.globl vector21
vector21:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $21
  101fc1:	6a 15                	push   $0x15
  jmp __alltraps
  101fc3:	e9 28 ff ff ff       	jmp    101ef0 <__alltraps>

00101fc8 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $22
  101fca:	6a 16                	push   $0x16
  jmp __alltraps
  101fcc:	e9 1f ff ff ff       	jmp    101ef0 <__alltraps>

00101fd1 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $23
  101fd3:	6a 17                	push   $0x17
  jmp __alltraps
  101fd5:	e9 16 ff ff ff       	jmp    101ef0 <__alltraps>

00101fda <vector24>:
.globl vector24
vector24:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $24
  101fdc:	6a 18                	push   $0x18
  jmp __alltraps
  101fde:	e9 0d ff ff ff       	jmp    101ef0 <__alltraps>

00101fe3 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $25
  101fe5:	6a 19                	push   $0x19
  jmp __alltraps
  101fe7:	e9 04 ff ff ff       	jmp    101ef0 <__alltraps>

00101fec <vector26>:
.globl vector26
vector26:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $26
  101fee:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ff0:	e9 fb fe ff ff       	jmp    101ef0 <__alltraps>

00101ff5 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $27
  101ff7:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ff9:	e9 f2 fe ff ff       	jmp    101ef0 <__alltraps>

00101ffe <vector28>:
.globl vector28
vector28:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $28
  102000:	6a 1c                	push   $0x1c
  jmp __alltraps
  102002:	e9 e9 fe ff ff       	jmp    101ef0 <__alltraps>

00102007 <vector29>:
.globl vector29
vector29:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $29
  102009:	6a 1d                	push   $0x1d
  jmp __alltraps
  10200b:	e9 e0 fe ff ff       	jmp    101ef0 <__alltraps>

00102010 <vector30>:
.globl vector30
vector30:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $30
  102012:	6a 1e                	push   $0x1e
  jmp __alltraps
  102014:	e9 d7 fe ff ff       	jmp    101ef0 <__alltraps>

00102019 <vector31>:
.globl vector31
vector31:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $31
  10201b:	6a 1f                	push   $0x1f
  jmp __alltraps
  10201d:	e9 ce fe ff ff       	jmp    101ef0 <__alltraps>

00102022 <vector32>:
.globl vector32
vector32:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $32
  102024:	6a 20                	push   $0x20
  jmp __alltraps
  102026:	e9 c5 fe ff ff       	jmp    101ef0 <__alltraps>

0010202b <vector33>:
.globl vector33
vector33:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $33
  10202d:	6a 21                	push   $0x21
  jmp __alltraps
  10202f:	e9 bc fe ff ff       	jmp    101ef0 <__alltraps>

00102034 <vector34>:
.globl vector34
vector34:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $34
  102036:	6a 22                	push   $0x22
  jmp __alltraps
  102038:	e9 b3 fe ff ff       	jmp    101ef0 <__alltraps>

0010203d <vector35>:
.globl vector35
vector35:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $35
  10203f:	6a 23                	push   $0x23
  jmp __alltraps
  102041:	e9 aa fe ff ff       	jmp    101ef0 <__alltraps>

00102046 <vector36>:
.globl vector36
vector36:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $36
  102048:	6a 24                	push   $0x24
  jmp __alltraps
  10204a:	e9 a1 fe ff ff       	jmp    101ef0 <__alltraps>

0010204f <vector37>:
.globl vector37
vector37:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $37
  102051:	6a 25                	push   $0x25
  jmp __alltraps
  102053:	e9 98 fe ff ff       	jmp    101ef0 <__alltraps>

00102058 <vector38>:
.globl vector38
vector38:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $38
  10205a:	6a 26                	push   $0x26
  jmp __alltraps
  10205c:	e9 8f fe ff ff       	jmp    101ef0 <__alltraps>

00102061 <vector39>:
.globl vector39
vector39:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $39
  102063:	6a 27                	push   $0x27
  jmp __alltraps
  102065:	e9 86 fe ff ff       	jmp    101ef0 <__alltraps>

0010206a <vector40>:
.globl vector40
vector40:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $40
  10206c:	6a 28                	push   $0x28
  jmp __alltraps
  10206e:	e9 7d fe ff ff       	jmp    101ef0 <__alltraps>

00102073 <vector41>:
.globl vector41
vector41:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $41
  102075:	6a 29                	push   $0x29
  jmp __alltraps
  102077:	e9 74 fe ff ff       	jmp    101ef0 <__alltraps>

0010207c <vector42>:
.globl vector42
vector42:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $42
  10207e:	6a 2a                	push   $0x2a
  jmp __alltraps
  102080:	e9 6b fe ff ff       	jmp    101ef0 <__alltraps>

00102085 <vector43>:
.globl vector43
vector43:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $43
  102087:	6a 2b                	push   $0x2b
  jmp __alltraps
  102089:	e9 62 fe ff ff       	jmp    101ef0 <__alltraps>

0010208e <vector44>:
.globl vector44
vector44:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $44
  102090:	6a 2c                	push   $0x2c
  jmp __alltraps
  102092:	e9 59 fe ff ff       	jmp    101ef0 <__alltraps>

00102097 <vector45>:
.globl vector45
vector45:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $45
  102099:	6a 2d                	push   $0x2d
  jmp __alltraps
  10209b:	e9 50 fe ff ff       	jmp    101ef0 <__alltraps>

001020a0 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $46
  1020a2:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020a4:	e9 47 fe ff ff       	jmp    101ef0 <__alltraps>

001020a9 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $47
  1020ab:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020ad:	e9 3e fe ff ff       	jmp    101ef0 <__alltraps>

001020b2 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $48
  1020b4:	6a 30                	push   $0x30
  jmp __alltraps
  1020b6:	e9 35 fe ff ff       	jmp    101ef0 <__alltraps>

001020bb <vector49>:
.globl vector49
vector49:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $49
  1020bd:	6a 31                	push   $0x31
  jmp __alltraps
  1020bf:	e9 2c fe ff ff       	jmp    101ef0 <__alltraps>

001020c4 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $50
  1020c6:	6a 32                	push   $0x32
  jmp __alltraps
  1020c8:	e9 23 fe ff ff       	jmp    101ef0 <__alltraps>

001020cd <vector51>:
.globl vector51
vector51:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $51
  1020cf:	6a 33                	push   $0x33
  jmp __alltraps
  1020d1:	e9 1a fe ff ff       	jmp    101ef0 <__alltraps>

001020d6 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $52
  1020d8:	6a 34                	push   $0x34
  jmp __alltraps
  1020da:	e9 11 fe ff ff       	jmp    101ef0 <__alltraps>

001020df <vector53>:
.globl vector53
vector53:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $53
  1020e1:	6a 35                	push   $0x35
  jmp __alltraps
  1020e3:	e9 08 fe ff ff       	jmp    101ef0 <__alltraps>

001020e8 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $54
  1020ea:	6a 36                	push   $0x36
  jmp __alltraps
  1020ec:	e9 ff fd ff ff       	jmp    101ef0 <__alltraps>

001020f1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $55
  1020f3:	6a 37                	push   $0x37
  jmp __alltraps
  1020f5:	e9 f6 fd ff ff       	jmp    101ef0 <__alltraps>

001020fa <vector56>:
.globl vector56
vector56:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $56
  1020fc:	6a 38                	push   $0x38
  jmp __alltraps
  1020fe:	e9 ed fd ff ff       	jmp    101ef0 <__alltraps>

00102103 <vector57>:
.globl vector57
vector57:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $57
  102105:	6a 39                	push   $0x39
  jmp __alltraps
  102107:	e9 e4 fd ff ff       	jmp    101ef0 <__alltraps>

0010210c <vector58>:
.globl vector58
vector58:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $58
  10210e:	6a 3a                	push   $0x3a
  jmp __alltraps
  102110:	e9 db fd ff ff       	jmp    101ef0 <__alltraps>

00102115 <vector59>:
.globl vector59
vector59:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $59
  102117:	6a 3b                	push   $0x3b
  jmp __alltraps
  102119:	e9 d2 fd ff ff       	jmp    101ef0 <__alltraps>

0010211e <vector60>:
.globl vector60
vector60:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $60
  102120:	6a 3c                	push   $0x3c
  jmp __alltraps
  102122:	e9 c9 fd ff ff       	jmp    101ef0 <__alltraps>

00102127 <vector61>:
.globl vector61
vector61:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $61
  102129:	6a 3d                	push   $0x3d
  jmp __alltraps
  10212b:	e9 c0 fd ff ff       	jmp    101ef0 <__alltraps>

00102130 <vector62>:
.globl vector62
vector62:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $62
  102132:	6a 3e                	push   $0x3e
  jmp __alltraps
  102134:	e9 b7 fd ff ff       	jmp    101ef0 <__alltraps>

00102139 <vector63>:
.globl vector63
vector63:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $63
  10213b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10213d:	e9 ae fd ff ff       	jmp    101ef0 <__alltraps>

00102142 <vector64>:
.globl vector64
vector64:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $64
  102144:	6a 40                	push   $0x40
  jmp __alltraps
  102146:	e9 a5 fd ff ff       	jmp    101ef0 <__alltraps>

0010214b <vector65>:
.globl vector65
vector65:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $65
  10214d:	6a 41                	push   $0x41
  jmp __alltraps
  10214f:	e9 9c fd ff ff       	jmp    101ef0 <__alltraps>

00102154 <vector66>:
.globl vector66
vector66:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $66
  102156:	6a 42                	push   $0x42
  jmp __alltraps
  102158:	e9 93 fd ff ff       	jmp    101ef0 <__alltraps>

0010215d <vector67>:
.globl vector67
vector67:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $67
  10215f:	6a 43                	push   $0x43
  jmp __alltraps
  102161:	e9 8a fd ff ff       	jmp    101ef0 <__alltraps>

00102166 <vector68>:
.globl vector68
vector68:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $68
  102168:	6a 44                	push   $0x44
  jmp __alltraps
  10216a:	e9 81 fd ff ff       	jmp    101ef0 <__alltraps>

0010216f <vector69>:
.globl vector69
vector69:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $69
  102171:	6a 45                	push   $0x45
  jmp __alltraps
  102173:	e9 78 fd ff ff       	jmp    101ef0 <__alltraps>

00102178 <vector70>:
.globl vector70
vector70:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $70
  10217a:	6a 46                	push   $0x46
  jmp __alltraps
  10217c:	e9 6f fd ff ff       	jmp    101ef0 <__alltraps>

00102181 <vector71>:
.globl vector71
vector71:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $71
  102183:	6a 47                	push   $0x47
  jmp __alltraps
  102185:	e9 66 fd ff ff       	jmp    101ef0 <__alltraps>

0010218a <vector72>:
.globl vector72
vector72:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $72
  10218c:	6a 48                	push   $0x48
  jmp __alltraps
  10218e:	e9 5d fd ff ff       	jmp    101ef0 <__alltraps>

00102193 <vector73>:
.globl vector73
vector73:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $73
  102195:	6a 49                	push   $0x49
  jmp __alltraps
  102197:	e9 54 fd ff ff       	jmp    101ef0 <__alltraps>

0010219c <vector74>:
.globl vector74
vector74:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $74
  10219e:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021a0:	e9 4b fd ff ff       	jmp    101ef0 <__alltraps>

001021a5 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $75
  1021a7:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021a9:	e9 42 fd ff ff       	jmp    101ef0 <__alltraps>

001021ae <vector76>:
.globl vector76
vector76:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $76
  1021b0:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021b2:	e9 39 fd ff ff       	jmp    101ef0 <__alltraps>

001021b7 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $77
  1021b9:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021bb:	e9 30 fd ff ff       	jmp    101ef0 <__alltraps>

001021c0 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $78
  1021c2:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021c4:	e9 27 fd ff ff       	jmp    101ef0 <__alltraps>

001021c9 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $79
  1021cb:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021cd:	e9 1e fd ff ff       	jmp    101ef0 <__alltraps>

001021d2 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $80
  1021d4:	6a 50                	push   $0x50
  jmp __alltraps
  1021d6:	e9 15 fd ff ff       	jmp    101ef0 <__alltraps>

001021db <vector81>:
.globl vector81
vector81:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $81
  1021dd:	6a 51                	push   $0x51
  jmp __alltraps
  1021df:	e9 0c fd ff ff       	jmp    101ef0 <__alltraps>

001021e4 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $82
  1021e6:	6a 52                	push   $0x52
  jmp __alltraps
  1021e8:	e9 03 fd ff ff       	jmp    101ef0 <__alltraps>

001021ed <vector83>:
.globl vector83
vector83:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $83
  1021ef:	6a 53                	push   $0x53
  jmp __alltraps
  1021f1:	e9 fa fc ff ff       	jmp    101ef0 <__alltraps>

001021f6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $84
  1021f8:	6a 54                	push   $0x54
  jmp __alltraps
  1021fa:	e9 f1 fc ff ff       	jmp    101ef0 <__alltraps>

001021ff <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $85
  102201:	6a 55                	push   $0x55
  jmp __alltraps
  102203:	e9 e8 fc ff ff       	jmp    101ef0 <__alltraps>

00102208 <vector86>:
.globl vector86
vector86:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $86
  10220a:	6a 56                	push   $0x56
  jmp __alltraps
  10220c:	e9 df fc ff ff       	jmp    101ef0 <__alltraps>

00102211 <vector87>:
.globl vector87
vector87:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $87
  102213:	6a 57                	push   $0x57
  jmp __alltraps
  102215:	e9 d6 fc ff ff       	jmp    101ef0 <__alltraps>

0010221a <vector88>:
.globl vector88
vector88:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $88
  10221c:	6a 58                	push   $0x58
  jmp __alltraps
  10221e:	e9 cd fc ff ff       	jmp    101ef0 <__alltraps>

00102223 <vector89>:
.globl vector89
vector89:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $89
  102225:	6a 59                	push   $0x59
  jmp __alltraps
  102227:	e9 c4 fc ff ff       	jmp    101ef0 <__alltraps>

0010222c <vector90>:
.globl vector90
vector90:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $90
  10222e:	6a 5a                	push   $0x5a
  jmp __alltraps
  102230:	e9 bb fc ff ff       	jmp    101ef0 <__alltraps>

00102235 <vector91>:
.globl vector91
vector91:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $91
  102237:	6a 5b                	push   $0x5b
  jmp __alltraps
  102239:	e9 b2 fc ff ff       	jmp    101ef0 <__alltraps>

0010223e <vector92>:
.globl vector92
vector92:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $92
  102240:	6a 5c                	push   $0x5c
  jmp __alltraps
  102242:	e9 a9 fc ff ff       	jmp    101ef0 <__alltraps>

00102247 <vector93>:
.globl vector93
vector93:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $93
  102249:	6a 5d                	push   $0x5d
  jmp __alltraps
  10224b:	e9 a0 fc ff ff       	jmp    101ef0 <__alltraps>

00102250 <vector94>:
.globl vector94
vector94:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $94
  102252:	6a 5e                	push   $0x5e
  jmp __alltraps
  102254:	e9 97 fc ff ff       	jmp    101ef0 <__alltraps>

00102259 <vector95>:
.globl vector95
vector95:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $95
  10225b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10225d:	e9 8e fc ff ff       	jmp    101ef0 <__alltraps>

00102262 <vector96>:
.globl vector96
vector96:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $96
  102264:	6a 60                	push   $0x60
  jmp __alltraps
  102266:	e9 85 fc ff ff       	jmp    101ef0 <__alltraps>

0010226b <vector97>:
.globl vector97
vector97:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $97
  10226d:	6a 61                	push   $0x61
  jmp __alltraps
  10226f:	e9 7c fc ff ff       	jmp    101ef0 <__alltraps>

00102274 <vector98>:
.globl vector98
vector98:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $98
  102276:	6a 62                	push   $0x62
  jmp __alltraps
  102278:	e9 73 fc ff ff       	jmp    101ef0 <__alltraps>

0010227d <vector99>:
.globl vector99
vector99:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $99
  10227f:	6a 63                	push   $0x63
  jmp __alltraps
  102281:	e9 6a fc ff ff       	jmp    101ef0 <__alltraps>

00102286 <vector100>:
.globl vector100
vector100:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $100
  102288:	6a 64                	push   $0x64
  jmp __alltraps
  10228a:	e9 61 fc ff ff       	jmp    101ef0 <__alltraps>

0010228f <vector101>:
.globl vector101
vector101:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $101
  102291:	6a 65                	push   $0x65
  jmp __alltraps
  102293:	e9 58 fc ff ff       	jmp    101ef0 <__alltraps>

00102298 <vector102>:
.globl vector102
vector102:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $102
  10229a:	6a 66                	push   $0x66
  jmp __alltraps
  10229c:	e9 4f fc ff ff       	jmp    101ef0 <__alltraps>

001022a1 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $103
  1022a3:	6a 67                	push   $0x67
  jmp __alltraps
  1022a5:	e9 46 fc ff ff       	jmp    101ef0 <__alltraps>

001022aa <vector104>:
.globl vector104
vector104:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $104
  1022ac:	6a 68                	push   $0x68
  jmp __alltraps
  1022ae:	e9 3d fc ff ff       	jmp    101ef0 <__alltraps>

001022b3 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $105
  1022b5:	6a 69                	push   $0x69
  jmp __alltraps
  1022b7:	e9 34 fc ff ff       	jmp    101ef0 <__alltraps>

001022bc <vector106>:
.globl vector106
vector106:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $106
  1022be:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022c0:	e9 2b fc ff ff       	jmp    101ef0 <__alltraps>

001022c5 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $107
  1022c7:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022c9:	e9 22 fc ff ff       	jmp    101ef0 <__alltraps>

001022ce <vector108>:
.globl vector108
vector108:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $108
  1022d0:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022d2:	e9 19 fc ff ff       	jmp    101ef0 <__alltraps>

001022d7 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $109
  1022d9:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022db:	e9 10 fc ff ff       	jmp    101ef0 <__alltraps>

001022e0 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $110
  1022e2:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022e4:	e9 07 fc ff ff       	jmp    101ef0 <__alltraps>

001022e9 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $111
  1022eb:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022ed:	e9 fe fb ff ff       	jmp    101ef0 <__alltraps>

001022f2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $112
  1022f4:	6a 70                	push   $0x70
  jmp __alltraps
  1022f6:	e9 f5 fb ff ff       	jmp    101ef0 <__alltraps>

001022fb <vector113>:
.globl vector113
vector113:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $113
  1022fd:	6a 71                	push   $0x71
  jmp __alltraps
  1022ff:	e9 ec fb ff ff       	jmp    101ef0 <__alltraps>

00102304 <vector114>:
.globl vector114
vector114:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $114
  102306:	6a 72                	push   $0x72
  jmp __alltraps
  102308:	e9 e3 fb ff ff       	jmp    101ef0 <__alltraps>

0010230d <vector115>:
.globl vector115
vector115:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $115
  10230f:	6a 73                	push   $0x73
  jmp __alltraps
  102311:	e9 da fb ff ff       	jmp    101ef0 <__alltraps>

00102316 <vector116>:
.globl vector116
vector116:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $116
  102318:	6a 74                	push   $0x74
  jmp __alltraps
  10231a:	e9 d1 fb ff ff       	jmp    101ef0 <__alltraps>

0010231f <vector117>:
.globl vector117
vector117:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $117
  102321:	6a 75                	push   $0x75
  jmp __alltraps
  102323:	e9 c8 fb ff ff       	jmp    101ef0 <__alltraps>

00102328 <vector118>:
.globl vector118
vector118:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $118
  10232a:	6a 76                	push   $0x76
  jmp __alltraps
  10232c:	e9 bf fb ff ff       	jmp    101ef0 <__alltraps>

00102331 <vector119>:
.globl vector119
vector119:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $119
  102333:	6a 77                	push   $0x77
  jmp __alltraps
  102335:	e9 b6 fb ff ff       	jmp    101ef0 <__alltraps>

0010233a <vector120>:
.globl vector120
vector120:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $120
  10233c:	6a 78                	push   $0x78
  jmp __alltraps
  10233e:	e9 ad fb ff ff       	jmp    101ef0 <__alltraps>

00102343 <vector121>:
.globl vector121
vector121:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $121
  102345:	6a 79                	push   $0x79
  jmp __alltraps
  102347:	e9 a4 fb ff ff       	jmp    101ef0 <__alltraps>

0010234c <vector122>:
.globl vector122
vector122:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $122
  10234e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102350:	e9 9b fb ff ff       	jmp    101ef0 <__alltraps>

00102355 <vector123>:
.globl vector123
vector123:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $123
  102357:	6a 7b                	push   $0x7b
  jmp __alltraps
  102359:	e9 92 fb ff ff       	jmp    101ef0 <__alltraps>

0010235e <vector124>:
.globl vector124
vector124:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $124
  102360:	6a 7c                	push   $0x7c
  jmp __alltraps
  102362:	e9 89 fb ff ff       	jmp    101ef0 <__alltraps>

00102367 <vector125>:
.globl vector125
vector125:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $125
  102369:	6a 7d                	push   $0x7d
  jmp __alltraps
  10236b:	e9 80 fb ff ff       	jmp    101ef0 <__alltraps>

00102370 <vector126>:
.globl vector126
vector126:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $126
  102372:	6a 7e                	push   $0x7e
  jmp __alltraps
  102374:	e9 77 fb ff ff       	jmp    101ef0 <__alltraps>

00102379 <vector127>:
.globl vector127
vector127:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $127
  10237b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10237d:	e9 6e fb ff ff       	jmp    101ef0 <__alltraps>

00102382 <vector128>:
.globl vector128
vector128:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $128
  102384:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102389:	e9 62 fb ff ff       	jmp    101ef0 <__alltraps>

0010238e <vector129>:
.globl vector129
vector129:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $129
  102390:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102395:	e9 56 fb ff ff       	jmp    101ef0 <__alltraps>

0010239a <vector130>:
.globl vector130
vector130:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $130
  10239c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023a1:	e9 4a fb ff ff       	jmp    101ef0 <__alltraps>

001023a6 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $131
  1023a8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023ad:	e9 3e fb ff ff       	jmp    101ef0 <__alltraps>

001023b2 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $132
  1023b4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023b9:	e9 32 fb ff ff       	jmp    101ef0 <__alltraps>

001023be <vector133>:
.globl vector133
vector133:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $133
  1023c0:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023c5:	e9 26 fb ff ff       	jmp    101ef0 <__alltraps>

001023ca <vector134>:
.globl vector134
vector134:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $134
  1023cc:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023d1:	e9 1a fb ff ff       	jmp    101ef0 <__alltraps>

001023d6 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $135
  1023d8:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023dd:	e9 0e fb ff ff       	jmp    101ef0 <__alltraps>

001023e2 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $136
  1023e4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023e9:	e9 02 fb ff ff       	jmp    101ef0 <__alltraps>

001023ee <vector137>:
.globl vector137
vector137:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $137
  1023f0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023f5:	e9 f6 fa ff ff       	jmp    101ef0 <__alltraps>

001023fa <vector138>:
.globl vector138
vector138:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $138
  1023fc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102401:	e9 ea fa ff ff       	jmp    101ef0 <__alltraps>

00102406 <vector139>:
.globl vector139
vector139:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $139
  102408:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10240d:	e9 de fa ff ff       	jmp    101ef0 <__alltraps>

00102412 <vector140>:
.globl vector140
vector140:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $140
  102414:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102419:	e9 d2 fa ff ff       	jmp    101ef0 <__alltraps>

0010241e <vector141>:
.globl vector141
vector141:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $141
  102420:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102425:	e9 c6 fa ff ff       	jmp    101ef0 <__alltraps>

0010242a <vector142>:
.globl vector142
vector142:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $142
  10242c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102431:	e9 ba fa ff ff       	jmp    101ef0 <__alltraps>

00102436 <vector143>:
.globl vector143
vector143:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $143
  102438:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10243d:	e9 ae fa ff ff       	jmp    101ef0 <__alltraps>

00102442 <vector144>:
.globl vector144
vector144:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $144
  102444:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102449:	e9 a2 fa ff ff       	jmp    101ef0 <__alltraps>

0010244e <vector145>:
.globl vector145
vector145:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $145
  102450:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102455:	e9 96 fa ff ff       	jmp    101ef0 <__alltraps>

0010245a <vector146>:
.globl vector146
vector146:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $146
  10245c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102461:	e9 8a fa ff ff       	jmp    101ef0 <__alltraps>

00102466 <vector147>:
.globl vector147
vector147:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $147
  102468:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10246d:	e9 7e fa ff ff       	jmp    101ef0 <__alltraps>

00102472 <vector148>:
.globl vector148
vector148:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $148
  102474:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102479:	e9 72 fa ff ff       	jmp    101ef0 <__alltraps>

0010247e <vector149>:
.globl vector149
vector149:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $149
  102480:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102485:	e9 66 fa ff ff       	jmp    101ef0 <__alltraps>

0010248a <vector150>:
.globl vector150
vector150:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $150
  10248c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102491:	e9 5a fa ff ff       	jmp    101ef0 <__alltraps>

00102496 <vector151>:
.globl vector151
vector151:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $151
  102498:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10249d:	e9 4e fa ff ff       	jmp    101ef0 <__alltraps>

001024a2 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $152
  1024a4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024a9:	e9 42 fa ff ff       	jmp    101ef0 <__alltraps>

001024ae <vector153>:
.globl vector153
vector153:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $153
  1024b0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024b5:	e9 36 fa ff ff       	jmp    101ef0 <__alltraps>

001024ba <vector154>:
.globl vector154
vector154:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $154
  1024bc:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024c1:	e9 2a fa ff ff       	jmp    101ef0 <__alltraps>

001024c6 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $155
  1024c8:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024cd:	e9 1e fa ff ff       	jmp    101ef0 <__alltraps>

001024d2 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $156
  1024d4:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024d9:	e9 12 fa ff ff       	jmp    101ef0 <__alltraps>

001024de <vector157>:
.globl vector157
vector157:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $157
  1024e0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024e5:	e9 06 fa ff ff       	jmp    101ef0 <__alltraps>

001024ea <vector158>:
.globl vector158
vector158:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $158
  1024ec:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024f1:	e9 fa f9 ff ff       	jmp    101ef0 <__alltraps>

001024f6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $159
  1024f8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024fd:	e9 ee f9 ff ff       	jmp    101ef0 <__alltraps>

00102502 <vector160>:
.globl vector160
vector160:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $160
  102504:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102509:	e9 e2 f9 ff ff       	jmp    101ef0 <__alltraps>

0010250e <vector161>:
.globl vector161
vector161:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $161
  102510:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102515:	e9 d6 f9 ff ff       	jmp    101ef0 <__alltraps>

0010251a <vector162>:
.globl vector162
vector162:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $162
  10251c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102521:	e9 ca f9 ff ff       	jmp    101ef0 <__alltraps>

00102526 <vector163>:
.globl vector163
vector163:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $163
  102528:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10252d:	e9 be f9 ff ff       	jmp    101ef0 <__alltraps>

00102532 <vector164>:
.globl vector164
vector164:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $164
  102534:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102539:	e9 b2 f9 ff ff       	jmp    101ef0 <__alltraps>

0010253e <vector165>:
.globl vector165
vector165:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $165
  102540:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102545:	e9 a6 f9 ff ff       	jmp    101ef0 <__alltraps>

0010254a <vector166>:
.globl vector166
vector166:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $166
  10254c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102551:	e9 9a f9 ff ff       	jmp    101ef0 <__alltraps>

00102556 <vector167>:
.globl vector167
vector167:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $167
  102558:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10255d:	e9 8e f9 ff ff       	jmp    101ef0 <__alltraps>

00102562 <vector168>:
.globl vector168
vector168:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $168
  102564:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102569:	e9 82 f9 ff ff       	jmp    101ef0 <__alltraps>

0010256e <vector169>:
.globl vector169
vector169:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $169
  102570:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102575:	e9 76 f9 ff ff       	jmp    101ef0 <__alltraps>

0010257a <vector170>:
.globl vector170
vector170:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $170
  10257c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102581:	e9 6a f9 ff ff       	jmp    101ef0 <__alltraps>

00102586 <vector171>:
.globl vector171
vector171:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $171
  102588:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10258d:	e9 5e f9 ff ff       	jmp    101ef0 <__alltraps>

00102592 <vector172>:
.globl vector172
vector172:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $172
  102594:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102599:	e9 52 f9 ff ff       	jmp    101ef0 <__alltraps>

0010259e <vector173>:
.globl vector173
vector173:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $173
  1025a0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025a5:	e9 46 f9 ff ff       	jmp    101ef0 <__alltraps>

001025aa <vector174>:
.globl vector174
vector174:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $174
  1025ac:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025b1:	e9 3a f9 ff ff       	jmp    101ef0 <__alltraps>

001025b6 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $175
  1025b8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025bd:	e9 2e f9 ff ff       	jmp    101ef0 <__alltraps>

001025c2 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $176
  1025c4:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025c9:	e9 22 f9 ff ff       	jmp    101ef0 <__alltraps>

001025ce <vector177>:
.globl vector177
vector177:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $177
  1025d0:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025d5:	e9 16 f9 ff ff       	jmp    101ef0 <__alltraps>

001025da <vector178>:
.globl vector178
vector178:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $178
  1025dc:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025e1:	e9 0a f9 ff ff       	jmp    101ef0 <__alltraps>

001025e6 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $179
  1025e8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025ed:	e9 fe f8 ff ff       	jmp    101ef0 <__alltraps>

001025f2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $180
  1025f4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025f9:	e9 f2 f8 ff ff       	jmp    101ef0 <__alltraps>

001025fe <vector181>:
.globl vector181
vector181:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $181
  102600:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102605:	e9 e6 f8 ff ff       	jmp    101ef0 <__alltraps>

0010260a <vector182>:
.globl vector182
vector182:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $182
  10260c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102611:	e9 da f8 ff ff       	jmp    101ef0 <__alltraps>

00102616 <vector183>:
.globl vector183
vector183:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $183
  102618:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10261d:	e9 ce f8 ff ff       	jmp    101ef0 <__alltraps>

00102622 <vector184>:
.globl vector184
vector184:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $184
  102624:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102629:	e9 c2 f8 ff ff       	jmp    101ef0 <__alltraps>

0010262e <vector185>:
.globl vector185
vector185:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $185
  102630:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102635:	e9 b6 f8 ff ff       	jmp    101ef0 <__alltraps>

0010263a <vector186>:
.globl vector186
vector186:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $186
  10263c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102641:	e9 aa f8 ff ff       	jmp    101ef0 <__alltraps>

00102646 <vector187>:
.globl vector187
vector187:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $187
  102648:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10264d:	e9 9e f8 ff ff       	jmp    101ef0 <__alltraps>

00102652 <vector188>:
.globl vector188
vector188:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $188
  102654:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102659:	e9 92 f8 ff ff       	jmp    101ef0 <__alltraps>

0010265e <vector189>:
.globl vector189
vector189:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $189
  102660:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102665:	e9 86 f8 ff ff       	jmp    101ef0 <__alltraps>

0010266a <vector190>:
.globl vector190
vector190:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $190
  10266c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102671:	e9 7a f8 ff ff       	jmp    101ef0 <__alltraps>

00102676 <vector191>:
.globl vector191
vector191:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $191
  102678:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10267d:	e9 6e f8 ff ff       	jmp    101ef0 <__alltraps>

00102682 <vector192>:
.globl vector192
vector192:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $192
  102684:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102689:	e9 62 f8 ff ff       	jmp    101ef0 <__alltraps>

0010268e <vector193>:
.globl vector193
vector193:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $193
  102690:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102695:	e9 56 f8 ff ff       	jmp    101ef0 <__alltraps>

0010269a <vector194>:
.globl vector194
vector194:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $194
  10269c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026a1:	e9 4a f8 ff ff       	jmp    101ef0 <__alltraps>

001026a6 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $195
  1026a8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026ad:	e9 3e f8 ff ff       	jmp    101ef0 <__alltraps>

001026b2 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $196
  1026b4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026b9:	e9 32 f8 ff ff       	jmp    101ef0 <__alltraps>

001026be <vector197>:
.globl vector197
vector197:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $197
  1026c0:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026c5:	e9 26 f8 ff ff       	jmp    101ef0 <__alltraps>

001026ca <vector198>:
.globl vector198
vector198:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $198
  1026cc:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026d1:	e9 1a f8 ff ff       	jmp    101ef0 <__alltraps>

001026d6 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $199
  1026d8:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026dd:	e9 0e f8 ff ff       	jmp    101ef0 <__alltraps>

001026e2 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $200
  1026e4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026e9:	e9 02 f8 ff ff       	jmp    101ef0 <__alltraps>

001026ee <vector201>:
.globl vector201
vector201:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $201
  1026f0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026f5:	e9 f6 f7 ff ff       	jmp    101ef0 <__alltraps>

001026fa <vector202>:
.globl vector202
vector202:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $202
  1026fc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102701:	e9 ea f7 ff ff       	jmp    101ef0 <__alltraps>

00102706 <vector203>:
.globl vector203
vector203:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $203
  102708:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10270d:	e9 de f7 ff ff       	jmp    101ef0 <__alltraps>

00102712 <vector204>:
.globl vector204
vector204:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $204
  102714:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102719:	e9 d2 f7 ff ff       	jmp    101ef0 <__alltraps>

0010271e <vector205>:
.globl vector205
vector205:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $205
  102720:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102725:	e9 c6 f7 ff ff       	jmp    101ef0 <__alltraps>

0010272a <vector206>:
.globl vector206
vector206:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $206
  10272c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102731:	e9 ba f7 ff ff       	jmp    101ef0 <__alltraps>

00102736 <vector207>:
.globl vector207
vector207:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $207
  102738:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10273d:	e9 ae f7 ff ff       	jmp    101ef0 <__alltraps>

00102742 <vector208>:
.globl vector208
vector208:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $208
  102744:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102749:	e9 a2 f7 ff ff       	jmp    101ef0 <__alltraps>

0010274e <vector209>:
.globl vector209
vector209:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $209
  102750:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102755:	e9 96 f7 ff ff       	jmp    101ef0 <__alltraps>

0010275a <vector210>:
.globl vector210
vector210:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $210
  10275c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102761:	e9 8a f7 ff ff       	jmp    101ef0 <__alltraps>

00102766 <vector211>:
.globl vector211
vector211:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $211
  102768:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10276d:	e9 7e f7 ff ff       	jmp    101ef0 <__alltraps>

00102772 <vector212>:
.globl vector212
vector212:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $212
  102774:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102779:	e9 72 f7 ff ff       	jmp    101ef0 <__alltraps>

0010277e <vector213>:
.globl vector213
vector213:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $213
  102780:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102785:	e9 66 f7 ff ff       	jmp    101ef0 <__alltraps>

0010278a <vector214>:
.globl vector214
vector214:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $214
  10278c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102791:	e9 5a f7 ff ff       	jmp    101ef0 <__alltraps>

00102796 <vector215>:
.globl vector215
vector215:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $215
  102798:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10279d:	e9 4e f7 ff ff       	jmp    101ef0 <__alltraps>

001027a2 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $216
  1027a4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027a9:	e9 42 f7 ff ff       	jmp    101ef0 <__alltraps>

001027ae <vector217>:
.globl vector217
vector217:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $217
  1027b0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027b5:	e9 36 f7 ff ff       	jmp    101ef0 <__alltraps>

001027ba <vector218>:
.globl vector218
vector218:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $218
  1027bc:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027c1:	e9 2a f7 ff ff       	jmp    101ef0 <__alltraps>

001027c6 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $219
  1027c8:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027cd:	e9 1e f7 ff ff       	jmp    101ef0 <__alltraps>

001027d2 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $220
  1027d4:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027d9:	e9 12 f7 ff ff       	jmp    101ef0 <__alltraps>

001027de <vector221>:
.globl vector221
vector221:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $221
  1027e0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027e5:	e9 06 f7 ff ff       	jmp    101ef0 <__alltraps>

001027ea <vector222>:
.globl vector222
vector222:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $222
  1027ec:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027f1:	e9 fa f6 ff ff       	jmp    101ef0 <__alltraps>

001027f6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $223
  1027f8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027fd:	e9 ee f6 ff ff       	jmp    101ef0 <__alltraps>

00102802 <vector224>:
.globl vector224
vector224:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $224
  102804:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102809:	e9 e2 f6 ff ff       	jmp    101ef0 <__alltraps>

0010280e <vector225>:
.globl vector225
vector225:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $225
  102810:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102815:	e9 d6 f6 ff ff       	jmp    101ef0 <__alltraps>

0010281a <vector226>:
.globl vector226
vector226:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $226
  10281c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102821:	e9 ca f6 ff ff       	jmp    101ef0 <__alltraps>

00102826 <vector227>:
.globl vector227
vector227:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $227
  102828:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10282d:	e9 be f6 ff ff       	jmp    101ef0 <__alltraps>

00102832 <vector228>:
.globl vector228
vector228:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $228
  102834:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102839:	e9 b2 f6 ff ff       	jmp    101ef0 <__alltraps>

0010283e <vector229>:
.globl vector229
vector229:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $229
  102840:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102845:	e9 a6 f6 ff ff       	jmp    101ef0 <__alltraps>

0010284a <vector230>:
.globl vector230
vector230:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $230
  10284c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102851:	e9 9a f6 ff ff       	jmp    101ef0 <__alltraps>

00102856 <vector231>:
.globl vector231
vector231:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $231
  102858:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10285d:	e9 8e f6 ff ff       	jmp    101ef0 <__alltraps>

00102862 <vector232>:
.globl vector232
vector232:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $232
  102864:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102869:	e9 82 f6 ff ff       	jmp    101ef0 <__alltraps>

0010286e <vector233>:
.globl vector233
vector233:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $233
  102870:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102875:	e9 76 f6 ff ff       	jmp    101ef0 <__alltraps>

0010287a <vector234>:
.globl vector234
vector234:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $234
  10287c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102881:	e9 6a f6 ff ff       	jmp    101ef0 <__alltraps>

00102886 <vector235>:
.globl vector235
vector235:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $235
  102888:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10288d:	e9 5e f6 ff ff       	jmp    101ef0 <__alltraps>

00102892 <vector236>:
.globl vector236
vector236:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $236
  102894:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102899:	e9 52 f6 ff ff       	jmp    101ef0 <__alltraps>

0010289e <vector237>:
.globl vector237
vector237:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $237
  1028a0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028a5:	e9 46 f6 ff ff       	jmp    101ef0 <__alltraps>

001028aa <vector238>:
.globl vector238
vector238:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $238
  1028ac:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028b1:	e9 3a f6 ff ff       	jmp    101ef0 <__alltraps>

001028b6 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $239
  1028b8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028bd:	e9 2e f6 ff ff       	jmp    101ef0 <__alltraps>

001028c2 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $240
  1028c4:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028c9:	e9 22 f6 ff ff       	jmp    101ef0 <__alltraps>

001028ce <vector241>:
.globl vector241
vector241:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $241
  1028d0:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028d5:	e9 16 f6 ff ff       	jmp    101ef0 <__alltraps>

001028da <vector242>:
.globl vector242
vector242:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $242
  1028dc:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028e1:	e9 0a f6 ff ff       	jmp    101ef0 <__alltraps>

001028e6 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $243
  1028e8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028ed:	e9 fe f5 ff ff       	jmp    101ef0 <__alltraps>

001028f2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $244
  1028f4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028f9:	e9 f2 f5 ff ff       	jmp    101ef0 <__alltraps>

001028fe <vector245>:
.globl vector245
vector245:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $245
  102900:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102905:	e9 e6 f5 ff ff       	jmp    101ef0 <__alltraps>

0010290a <vector246>:
.globl vector246
vector246:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $246
  10290c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102911:	e9 da f5 ff ff       	jmp    101ef0 <__alltraps>

00102916 <vector247>:
.globl vector247
vector247:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $247
  102918:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10291d:	e9 ce f5 ff ff       	jmp    101ef0 <__alltraps>

00102922 <vector248>:
.globl vector248
vector248:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $248
  102924:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102929:	e9 c2 f5 ff ff       	jmp    101ef0 <__alltraps>

0010292e <vector249>:
.globl vector249
vector249:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $249
  102930:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102935:	e9 b6 f5 ff ff       	jmp    101ef0 <__alltraps>

0010293a <vector250>:
.globl vector250
vector250:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $250
  10293c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102941:	e9 aa f5 ff ff       	jmp    101ef0 <__alltraps>

00102946 <vector251>:
.globl vector251
vector251:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $251
  102948:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10294d:	e9 9e f5 ff ff       	jmp    101ef0 <__alltraps>

00102952 <vector252>:
.globl vector252
vector252:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $252
  102954:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102959:	e9 92 f5 ff ff       	jmp    101ef0 <__alltraps>

0010295e <vector253>:
.globl vector253
vector253:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $253
  102960:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102965:	e9 86 f5 ff ff       	jmp    101ef0 <__alltraps>

0010296a <vector254>:
.globl vector254
vector254:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $254
  10296c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102971:	e9 7a f5 ff ff       	jmp    101ef0 <__alltraps>

00102976 <vector255>:
.globl vector255
vector255:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $255
  102978:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10297d:	e9 6e f5 ff ff       	jmp    101ef0 <__alltraps>

00102982 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102982:	55                   	push   %ebp
  102983:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102985:	8b 55 08             	mov    0x8(%ebp),%edx
  102988:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  10298d:	29 c2                	sub    %eax,%edx
  10298f:	89 d0                	mov    %edx,%eax
  102991:	c1 f8 02             	sar    $0x2,%eax
  102994:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10299a:	5d                   	pop    %ebp
  10299b:	c3                   	ret    

0010299c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10299c:	55                   	push   %ebp
  10299d:	89 e5                	mov    %esp,%ebp
  10299f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a5:	89 04 24             	mov    %eax,(%esp)
  1029a8:	e8 d5 ff ff ff       	call   102982 <page2ppn>
  1029ad:	c1 e0 0c             	shl    $0xc,%eax
}
  1029b0:	c9                   	leave  
  1029b1:	c3                   	ret    

001029b2 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1029b2:	55                   	push   %ebp
  1029b3:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b8:	8b 00                	mov    (%eax),%eax
}
  1029ba:	5d                   	pop    %ebp
  1029bb:	c3                   	ret    

001029bc <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029bc:	55                   	push   %ebp
  1029bd:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029c5:	89 10                	mov    %edx,(%eax)
}
  1029c7:	5d                   	pop    %ebp
  1029c8:	c3                   	ret    

001029c9 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1029c9:	55                   	push   %ebp
  1029ca:	89 e5                	mov    %esp,%ebp
  1029cc:	83 ec 10             	sub    $0x10,%esp
  1029cf:	c7 45 fc b0 89 11 00 	movl   $0x1189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1029d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1029dc:	89 50 04             	mov    %edx,0x4(%eax)
  1029df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e2:	8b 50 04             	mov    0x4(%eax),%edx
  1029e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e8:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1029ea:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  1029f1:	00 00 00 
}
  1029f4:	c9                   	leave  
  1029f5:	c3                   	ret    

001029f6 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1029f6:	55                   	push   %ebp
  1029f7:	89 e5                	mov    %esp,%ebp
  1029f9:	83 ec 48             	sub    $0x48,%esp
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    list_add(&free_list, &(base->page_link));
#endif
    assert(n > 0);
  1029fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a00:	75 24                	jne    102a26 <default_init_memmap+0x30>
  102a02:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  102a09:	00 
  102a0a:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102a11:	00 
  102a12:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  102a19:	00 
  102a1a:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102a21:	e8 ab e2 ff ff       	call   100cd1 <__panic>
    struct Page* p = base;
  102a26:	8b 45 08             	mov    0x8(%ebp),%eax
  102a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    for (; p != base + n; p++)
  102a2c:	eb 7b                	jmp    102aa9 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p));
  102a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a31:	83 c0 04             	add    $0x4,%eax
  102a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a44:	0f a3 10             	bt     %edx,(%eax)
  102a47:	19 c0                	sbb    %eax,%eax
  102a49:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102a4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a50:	0f 95 c0             	setne  %al
  102a53:	0f b6 c0             	movzbl %al,%eax
  102a56:	85 c0                	test   %eax,%eax
  102a58:	75 24                	jne    102a7e <default_init_memmap+0x88>
  102a5a:	c7 44 24 0c 81 69 10 	movl   $0x106981,0xc(%esp)
  102a61:	00 
  102a62:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102a69:	00 
  102a6a:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  102a71:	00 
  102a72:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102a79:	e8 53 e2 ff ff       	call   100cd1 <__panic>
	p->flags = 0;
  102a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	p->property = 0;
  102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	set_page_ref(p, 0);
  102a92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a99:	00 
  102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9d:	89 04 24             	mov    %eax,(%esp)
  102aa0:	e8 17 ff ff ff       	call   1029bc <set_page_ref>
    list_add(&free_list, &(base->page_link));
#endif
    assert(n > 0);
    struct Page* p = base;
    
    for (; p != base + n; p++)
  102aa5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aac:	89 d0                	mov    %edx,%eax
  102aae:	c1 e0 02             	shl    $0x2,%eax
  102ab1:	01 d0                	add    %edx,%eax
  102ab3:	c1 e0 02             	shl    $0x2,%eax
  102ab6:	89 c2                	mov    %eax,%edx
  102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  102abb:	01 d0                	add    %edx,%eax
  102abd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ac0:	0f 85 68 ff ff ff    	jne    102a2e <default_init_memmap+0x38>
	p->flags = 0;
	p->property = 0;
	set_page_ref(p, 0);
    }
    
    SetPageProperty(base);
  102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac9:	83 c0 04             	add    $0x4,%eax
  102acc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102ad3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ad6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ad9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102adc:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102adf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ae5:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102ae8:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af1:	01 d0                	add    %edx,%eax
  102af3:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    list_add_before(&free_list, &(base->page_link));
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	83 c0 0c             	add    $0xc,%eax
  102afe:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
  102b05:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b0b:	8b 00                	mov    (%eax),%eax
  102b0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b19:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b22:	89 10                	mov    %edx,(%eax)
  102b24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b27:	8b 10                	mov    (%eax),%edx
  102b29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b32:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b35:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b3e:	89 10                	mov    %edx,(%eax)
}
  102b40:	c9                   	leave  
  102b41:	c3                   	ret    

00102b42 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102b42:	55                   	push   %ebp
  102b43:	89 e5                	mov    %esp,%ebp
  102b45:	83 ec 78             	sub    $0x78,%esp
        nr_free -= n;
        ClearPageProperty(page);
    }
    return page;
#endif
    assert(n > 0);
  102b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b4c:	75 24                	jne    102b72 <default_alloc_pages+0x30>
  102b4e:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  102b55:	00 
  102b56:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102b5d:	00 
  102b5e:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  102b65:	00 
  102b66:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102b6d:	e8 5f e1 ff ff       	call   100cd1 <__panic>
    int i;
    if (n > nr_free)
  102b72:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102b77:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b7a:	73 0a                	jae    102b86 <default_alloc_pages+0x44>
    {
	return NULL;
  102b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  102b81:	e9 9b 01 00 00       	jmp    102d21 <default_alloc_pages+0x1df>
    }
    struct Page* page = NULL;
  102b86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t* le = &free_list;
  102b8d:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)

    while ((le = list_next(le)) != &free_list)
  102b94:	eb 1c                	jmp    102bb2 <default_alloc_pages+0x70>
    {
	struct Page* p = le2page(le, page_link);
  102b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b99:	83 e8 0c             	sub    $0xc,%eax
  102b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (p->property >= n)
  102b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ba2:	8b 40 08             	mov    0x8(%eax),%eax
  102ba5:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ba8:	72 08                	jb     102bb2 <default_alloc_pages+0x70>
	{
	    page = p;
  102baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    break;
  102bb0:	eb 18                	jmp    102bca <default_alloc_pages+0x88>
  102bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bbb:	8b 40 04             	mov    0x4(%eax),%eax
	return NULL;
    }
    struct Page* page = NULL;
    list_entry_t* le = &free_list;

    while ((le = list_next(le)) != &free_list)
  102bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bc1:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  102bc8:	75 cc                	jne    102b96 <default_alloc_pages+0x54>
	    page = p;
	    break;
	}
    }

    if (page != NULL)
  102bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102bce:	0f 84 4a 01 00 00    	je     102d1e <default_alloc_pages+0x1dc>
    {
	if (page->property > n) 
  102bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bd7:	8b 40 08             	mov    0x8(%eax),%eax
  102bda:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bdd:	0f 86 98 00 00 00    	jbe    102c7b <default_alloc_pages+0x139>
	{
            struct Page *p = page + n;
  102be3:	8b 55 08             	mov    0x8(%ebp),%edx
  102be6:	89 d0                	mov    %edx,%eax
  102be8:	c1 e0 02             	shl    $0x2,%eax
  102beb:	01 d0                	add    %edx,%eax
  102bed:	c1 e0 02             	shl    $0x2,%eax
  102bf0:	89 c2                	mov    %eax,%edx
  102bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bf5:	01 d0                	add    %edx,%eax
  102bf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
  102bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bfd:	8b 40 08             	mov    0x8(%eax),%eax
  102c00:	2b 45 08             	sub    0x8(%ebp),%eax
  102c03:	89 c2                	mov    %eax,%edx
  102c05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c08:	89 50 08             	mov    %edx,0x8(%eax)
	    SetPageProperty(p);
  102c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c0e:	83 c0 04             	add    $0x4,%eax
  102c11:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102c18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102c1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c21:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
  102c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c27:	83 c0 0c             	add    $0xc,%eax
  102c2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c2d:	83 c2 0c             	add    $0xc,%edx
  102c30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c33:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c39:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102c3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102c42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c45:	8b 40 04             	mov    0x4(%eax),%eax
  102c48:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c4b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102c4e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c51:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102c54:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c57:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c5a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c5d:	89 10                	mov    %edx,(%eax)
  102c5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c62:	8b 10                	mov    (%eax),%edx
  102c64:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102c67:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c6d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102c70:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c73:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c76:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102c79:	89 10                	mov    %edx,(%eax)
    	}

	list_del(&(page->page_link));
  102c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c7e:	83 c0 0c             	add    $0xc,%eax
  102c81:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102c84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102c87:	8b 40 04             	mov    0x4(%eax),%eax
  102c8a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c8d:	8b 12                	mov    (%edx),%edx
  102c8f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  102c92:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c98:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c9b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ca1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ca4:	89 10                	mov    %edx,(%eax)

	for (i = 0; i < n; i++)
  102ca6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102cad:	eb 2e                	jmp    102cdd <default_alloc_pages+0x19b>
	{
	    SetPageReserved(page + i);
  102caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cb2:	89 d0                	mov    %edx,%eax
  102cb4:	c1 e0 02             	shl    $0x2,%eax
  102cb7:	01 d0                	add    %edx,%eax
  102cb9:	c1 e0 02             	shl    $0x2,%eax
  102cbc:	89 c2                	mov    %eax,%edx
  102cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cc1:	01 d0                	add    %edx,%eax
  102cc3:	83 c0 04             	add    $0x4,%eax
  102cc6:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  102ccd:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102cd0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102cd3:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102cd6:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
    	}

	list_del(&(page->page_link));

	for (i = 0; i < n; i++)
  102cd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce0:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ce3:	72 ca                	jb     102caf <default_alloc_pages+0x16d>
	{
	    SetPageReserved(page + i);
	}
		
	set_page_ref(page, 0);
  102ce5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cec:	00 
  102ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cf0:	89 04 24             	mov    %eax,(%esp)
  102cf3:	e8 c4 fc ff ff       	call   1029bc <set_page_ref>
        nr_free -= n;
  102cf8:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102cfd:	2b 45 08             	sub    0x8(%ebp),%eax
  102d00:	a3 b8 89 11 00       	mov    %eax,0x1189b8
		
        ClearPageProperty(page);
  102d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d08:	83 c0 04             	add    $0x4,%eax
  102d0b:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  102d12:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d15:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102d18:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102d1b:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d21:	c9                   	leave  
  102d22:	c3                   	ret    

00102d23 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102d23:	55                   	push   %ebp
  102d24:	89 e5                	mov    %esp,%ebp
  102d26:	81 ec 98 00 00 00    	sub    $0x98,%esp
        }
    }
    nr_free += n;
    list_add(&free_list, &(base->page_link));
#endif
    assert(n > 0);
  102d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d30:	75 24                	jne    102d56 <default_free_pages+0x33>
  102d32:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  102d39:	00 
  102d3a:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102d41:	00 
  102d42:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  102d49:	00 
  102d4a:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102d51:	e8 7b df ff ff       	call   100cd1 <__panic>
	
    struct Page *p = base;
  102d56:	8b 45 08             	mov    0x8(%ebp),%eax
  102d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page *p1 = NULL;
  102d5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    //标志位应该是为0的
    assert(!PageProperty(base));
  102d63:	8b 45 08             	mov    0x8(%ebp),%eax
  102d66:	83 c0 04             	add    $0x4,%eax
  102d69:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  102d70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102d79:	0f a3 10             	bt     %edx,(%eax)
  102d7c:	19 c0                	sbb    %eax,%eax
  102d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  102d81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102d85:	0f 95 c0             	setne  %al
  102d88:	0f b6 c0             	movzbl %al,%eax
  102d8b:	85 c0                	test   %eax,%eax
  102d8d:	74 24                	je     102db3 <default_free_pages+0x90>
  102d8f:	c7 44 24 0c 91 69 10 	movl   $0x106991,0xc(%esp)
  102d96:	00 
  102d97:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102d9e:	00 
  102d9f:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  102da6:	00 
  102da7:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102dae:	e8 1e df ff ff       	call   100cd1 <__panic>

    //所有的页面应该是使用的
    for (; p != base + n; p ++) 
  102db3:	eb 71                	jmp    102e26 <default_free_pages+0x103>
    {		
        assert(PageReserved(p));
  102db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db8:	83 c0 04             	add    $0x4,%eax
  102dbb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102dc2:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102dc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102dc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dcb:	0f a3 10             	bt     %edx,(%eax)
  102dce:	19 c0                	sbb    %eax,%eax
  102dd0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102dd3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102dd7:	0f 95 c0             	setne  %al
  102dda:	0f b6 c0             	movzbl %al,%eax
  102ddd:	85 c0                	test   %eax,%eax
  102ddf:	75 24                	jne    102e05 <default_free_pages+0xe2>
  102de1:	c7 44 24 0c 81 69 10 	movl   $0x106981,0xc(%esp)
  102de8:	00 
  102de9:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102df0:	00 
  102df1:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  102df8:	00 
  102df9:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102e00:	e8 cc de ff ff       	call   100cd1 <__panic>
        p->flags = 0;
  102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	//引用次数为0
        set_page_ref(p, 0);
  102e0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e16:	00 
  102e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e1a:	89 04 24             	mov    %eax,(%esp)
  102e1d:	e8 9a fb ff ff       	call   1029bc <set_page_ref>

    //标志位应该是为0的
    assert(!PageProperty(base));

    //所有的页面应该是使用的
    for (; p != base + n; p ++) 
  102e22:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e29:	89 d0                	mov    %edx,%eax
  102e2b:	c1 e0 02             	shl    $0x2,%eax
  102e2e:	01 d0                	add    %edx,%eax
  102e30:	c1 e0 02             	shl    $0x2,%eax
  102e33:	89 c2                	mov    %eax,%edx
  102e35:	8b 45 08             	mov    0x8(%ebp),%eax
  102e38:	01 d0                	add    %edx,%eax
  102e3a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e3d:	0f 85 72 ff ff ff    	jne    102db5 <default_free_pages+0x92>
	//引用次数为0
        set_page_ref(p, 0);
    }

    //新的空闲块
    base->property = n;
  102e43:	8b 45 08             	mov    0x8(%ebp),%eax
  102e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e49:	89 50 08             	mov    %edx,0x8(%eax)
    //新的头部标志,因为传进来的可能不是头部
    SetPageProperty(base);
  102e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4f:	83 c0 04             	add    $0x4,%eax
  102e52:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102e59:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102e5f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102e62:	0f ab 10             	bts    %edx,(%eax)
  102e65:	c7 45 c8 b0 89 11 00 	movl   $0x1189b0,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102e6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e6f:	8b 40 04             	mov    0x4(%eax),%eax

//版本二
	
    list_entry_t *le = list_next(&free_list);
  102e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
    p = le2page(le, page_link);
  102e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e78:	83 e8 0c             	sub    $0xc,%eax
  102e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
    while (le != &free_list && p < base)
  102e7e:	eb 18                	jmp    102e98 <default_free_pages+0x175>
  102e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e83:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102e86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e89:	8b 40 04             	mov    0x4(%eax),%eax
    {
	le = list_next(le);
  102e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le, page_link);
  102e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e92:	83 e8 0c             	sub    $0xc,%eax
  102e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
    list_entry_t *le = list_next(&free_list);
	
    p = le2page(le, page_link);
	
    while (le != &free_list && p < base)
  102e98:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102e9f:	74 08                	je     102ea9 <default_free_pages+0x186>
  102ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ea7:	72 d7                	jb     102e80 <default_free_pages+0x15d>
	p = le2page(le, page_link);
    }
    //p的地址大于base的地址

    //三种特殊情况：头部 base 头部， 头部 base 普通， 普通 base 头部
    list_add_before(le, &(base->page_link));
  102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eac:	8d 50 0c             	lea    0xc(%eax),%edx
  102eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eb2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102eb5:	89 55 bc             	mov    %edx,-0x44(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102eb8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ebb:	8b 00                	mov    (%eax),%eax
  102ebd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ec0:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102ec3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102ec6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ec9:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ecc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ecf:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102ed2:	89 10                	mov    %edx,(%eax)
  102ed4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ed7:	8b 10                	mov    (%eax),%edx
  102ed9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102edc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102edf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ee2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102ee5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ee8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102eeb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102eee:	89 10                	mov    %edx,(%eax)
  102ef0:	c7 45 ac b0 89 11 00 	movl   $0x1189b0,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ef7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102efa:	8b 40 04             	mov    0x4(%eax),%eax

    //进行合并
    le = list_next(&free_list);
  102efd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
    p = le2page(le, page_link);
  102f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f03:	83 e8 0c             	sub    $0xc,%eax
  102f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
   	
         list_del(&(p->page_link));
	}
    }
#endif
    while (le != &free_list)
  102f09:	e9 1c 01 00 00       	jmp    10302a <default_free_pages+0x307>
    {		
	p = le2page(le, page_link);
  102f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f11:	83 e8 0c             	sub    $0xc,%eax
  102f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//与前面的合并
	if (p + p->property == base) {
  102f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f1a:	8b 50 08             	mov    0x8(%eax),%edx
  102f1d:	89 d0                	mov    %edx,%eax
  102f1f:	c1 e0 02             	shl    $0x2,%eax
  102f22:	01 d0                	add    %edx,%eax
  102f24:	c1 e0 02             	shl    $0x2,%eax
  102f27:	89 c2                	mov    %eax,%edx
  102f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2c:	01 d0                	add    %edx,%eax
  102f2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102f31:	75 6a                	jne    102f9d <default_free_pages+0x27a>
	    p->property += base->property;
  102f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f36:	8b 50 08             	mov    0x8(%eax),%edx
  102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3c:	8b 40 08             	mov    0x8(%eax),%eax
  102f3f:	01 c2                	add    %eax,%edx
  102f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f44:	89 50 08             	mov    %edx,0x8(%eax)
	    base->property = 0;
  102f47:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ClearPageProperty(base);
  102f51:	8b 45 08             	mov    0x8(%ebp),%eax
  102f54:	83 c0 04             	add    $0x4,%eax
  102f57:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  102f5e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f61:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f64:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f67:	0f b3 10             	btr    %edx,(%eax)
	    list_del(&(base->page_link));
  102f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6d:	83 c0 0c             	add    $0xc,%eax
  102f70:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102f73:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f76:	8b 40 04             	mov    0x4(%eax),%eax
  102f79:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102f7c:	8b 12                	mov    (%edx),%edx
  102f7e:	89 55 9c             	mov    %edx,-0x64(%ebp)
  102f81:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102f84:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f87:	8b 55 98             	mov    -0x68(%ebp),%edx
  102f8a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f8d:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f90:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102f93:	89 10                	mov    %edx,(%eax)
	    base = p;
  102f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f98:	89 45 08             	mov    %eax,0x8(%ebp)
  102f9b:	eb 7e                	jmp    10301b <default_free_pages+0x2f8>
	}
	//与后面的合并
	else if (base + base->property == p) {
  102f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa0:	8b 50 08             	mov    0x8(%eax),%edx
  102fa3:	89 d0                	mov    %edx,%eax
  102fa5:	c1 e0 02             	shl    $0x2,%eax
  102fa8:	01 d0                	add    %edx,%eax
  102faa:	c1 e0 02             	shl    $0x2,%eax
  102fad:	89 c2                	mov    %eax,%edx
  102faf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb2:	01 d0                	add    %edx,%eax
  102fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102fb7:	75 62                	jne    10301b <default_free_pages+0x2f8>
            base->property += p->property;
  102fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbc:	8b 50 08             	mov    0x8(%eax),%edx
  102fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fc2:	8b 40 08             	mov    0x8(%eax),%eax
  102fc5:	01 c2                	add    %eax,%edx
  102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fca:	89 50 08             	mov    %edx,0x8(%eax)
	    p->property = 0;
  102fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
  102fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fda:	83 c0 04             	add    $0x4,%eax
  102fdd:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  102fe4:	89 45 90             	mov    %eax,-0x70(%ebp)
  102fe7:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fea:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102fed:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ff3:	83 c0 0c             	add    $0xc,%eax
  102ff6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102ff9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ffc:	8b 40 04             	mov    0x4(%eax),%eax
  102fff:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103002:	8b 12                	mov    (%edx),%edx
  103004:	89 55 88             	mov    %edx,-0x78(%ebp)
  103007:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10300a:	8b 45 88             	mov    -0x78(%ebp),%eax
  10300d:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103010:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103013:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103016:	8b 55 88             	mov    -0x78(%ebp),%edx
  103019:	89 10                	mov    %edx,(%eax)
  10301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10301e:	89 45 80             	mov    %eax,-0x80(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103021:	8b 45 80             	mov    -0x80(%ebp),%eax
  103024:	8b 40 04             	mov    0x4(%eax),%eax
        }
		
	le = list_next(le);
  103027:	89 45 f0             	mov    %eax,-0x10(%ebp)
   	
         list_del(&(p->page_link));
	}
    }
#endif
    while (le != &free_list)
  10302a:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  103031:	0f 85 d7 fe ff ff    	jne    102f0e <default_free_pages+0x1eb>
        }
		
	le = list_next(le);
        
    }
    nr_free += n;
  103037:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  10303d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103040:	01 d0                	add    %edx,%eax
  103042:	a3 b8 89 11 00       	mov    %eax,0x1189b8
}
  103047:	c9                   	leave  
  103048:	c3                   	ret    

00103049 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  103049:	55                   	push   %ebp
  10304a:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10304c:	a1 b8 89 11 00       	mov    0x1189b8,%eax
}
  103051:	5d                   	pop    %ebp
  103052:	c3                   	ret    

00103053 <basic_check>:

static void
basic_check(void) {
  103053:	55                   	push   %ebp
  103054:	89 e5                	mov    %esp,%ebp
  103056:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  103059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103069:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10306c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103073:	e8 a8 0e 00 00       	call   103f20 <alloc_pages>
  103078:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10307b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10307f:	75 24                	jne    1030a5 <basic_check+0x52>
  103081:	c7 44 24 0c a5 69 10 	movl   $0x1069a5,0xc(%esp)
  103088:	00 
  103089:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103090:	00 
  103091:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  103098:	00 
  103099:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1030a0:	e8 2c dc ff ff       	call   100cd1 <__panic>
#if 0
	//调试分配的第一个物理页
	assert(!PageReserved(p0));

#endif
    assert((p1 = alloc_page()) != NULL);
  1030a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030ac:	e8 6f 0e 00 00       	call   103f20 <alloc_pages>
  1030b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030b8:	75 24                	jne    1030de <basic_check+0x8b>
  1030ba:	c7 44 24 0c c1 69 10 	movl   $0x1069c1,0xc(%esp)
  1030c1:	00 
  1030c2:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1030c9:	00 
  1030ca:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  1030d1:	00 
  1030d2:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1030d9:	e8 f3 db ff ff       	call   100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030e5:	e8 36 0e 00 00       	call   103f20 <alloc_pages>
  1030ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030f1:	75 24                	jne    103117 <basic_check+0xc4>
  1030f3:	c7 44 24 0c dd 69 10 	movl   $0x1069dd,0xc(%esp)
  1030fa:	00 
  1030fb:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103102:	00 
  103103:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  10310a:	00 
  10310b:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103112:	e8 ba db ff ff       	call   100cd1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103117:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10311a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10311d:	74 10                	je     10312f <basic_check+0xdc>
  10311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103122:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103125:	74 08                	je     10312f <basic_check+0xdc>
  103127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10312d:	75 24                	jne    103153 <basic_check+0x100>
  10312f:	c7 44 24 0c fc 69 10 	movl   $0x1069fc,0xc(%esp)
  103136:	00 
  103137:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10313e:	00 
  10313f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  103146:	00 
  103147:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10314e:	e8 7e db ff ff       	call   100cd1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103153:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103156:	89 04 24             	mov    %eax,(%esp)
  103159:	e8 54 f8 ff ff       	call   1029b2 <page_ref>
  10315e:	85 c0                	test   %eax,%eax
  103160:	75 1e                	jne    103180 <basic_check+0x12d>
  103162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103165:	89 04 24             	mov    %eax,(%esp)
  103168:	e8 45 f8 ff ff       	call   1029b2 <page_ref>
  10316d:	85 c0                	test   %eax,%eax
  10316f:	75 0f                	jne    103180 <basic_check+0x12d>
  103171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103174:	89 04 24             	mov    %eax,(%esp)
  103177:	e8 36 f8 ff ff       	call   1029b2 <page_ref>
  10317c:	85 c0                	test   %eax,%eax
  10317e:	74 24                	je     1031a4 <basic_check+0x151>
  103180:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  103187:	00 
  103188:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10318f:	00 
  103190:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  103197:	00 
  103198:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10319f:	e8 2d db ff ff       	call   100cd1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1031a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031a7:	89 04 24             	mov    %eax,(%esp)
  1031aa:	e8 ed f7 ff ff       	call   10299c <page2pa>
  1031af:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1031b5:	c1 e2 0c             	shl    $0xc,%edx
  1031b8:	39 d0                	cmp    %edx,%eax
  1031ba:	72 24                	jb     1031e0 <basic_check+0x18d>
  1031bc:	c7 44 24 0c 5c 6a 10 	movl   $0x106a5c,0xc(%esp)
  1031c3:	00 
  1031c4:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1031cb:	00 
  1031cc:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  1031d3:	00 
  1031d4:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1031db:	e8 f1 da ff ff       	call   100cd1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e3:	89 04 24             	mov    %eax,(%esp)
  1031e6:	e8 b1 f7 ff ff       	call   10299c <page2pa>
  1031eb:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1031f1:	c1 e2 0c             	shl    $0xc,%edx
  1031f4:	39 d0                	cmp    %edx,%eax
  1031f6:	72 24                	jb     10321c <basic_check+0x1c9>
  1031f8:	c7 44 24 0c 79 6a 10 	movl   $0x106a79,0xc(%esp)
  1031ff:	00 
  103200:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103207:	00 
  103208:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  10320f:	00 
  103210:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103217:	e8 b5 da ff ff       	call   100cd1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10321f:	89 04 24             	mov    %eax,(%esp)
  103222:	e8 75 f7 ff ff       	call   10299c <page2pa>
  103227:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10322d:	c1 e2 0c             	shl    $0xc,%edx
  103230:	39 d0                	cmp    %edx,%eax
  103232:	72 24                	jb     103258 <basic_check+0x205>
  103234:	c7 44 24 0c 96 6a 10 	movl   $0x106a96,0xc(%esp)
  10323b:	00 
  10323c:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103243:	00 
  103244:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  10324b:	00 
  10324c:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103253:	e8 79 da ff ff       	call   100cd1 <__panic>

    list_entry_t free_list_store = free_list;
  103258:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  10325d:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  103263:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103266:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103269:	c7 45 e0 b0 89 11 00 	movl   $0x1189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103270:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103273:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103276:	89 50 04             	mov    %edx,0x4(%eax)
  103279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10327c:	8b 50 04             	mov    0x4(%eax),%edx
  10327f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103282:	89 10                	mov    %edx,(%eax)
  103284:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10328b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10328e:	8b 40 04             	mov    0x4(%eax),%eax
  103291:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103294:	0f 94 c0             	sete   %al
  103297:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10329a:	85 c0                	test   %eax,%eax
  10329c:	75 24                	jne    1032c2 <basic_check+0x26f>
  10329e:	c7 44 24 0c b3 6a 10 	movl   $0x106ab3,0xc(%esp)
  1032a5:	00 
  1032a6:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1032ad:	00 
  1032ae:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  1032b5:	00 
  1032b6:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1032bd:	e8 0f da ff ff       	call   100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
  1032c2:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1032c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032ca:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  1032d1:	00 00 00 

    assert(alloc_page() == NULL);
  1032d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032db:	e8 40 0c 00 00       	call   103f20 <alloc_pages>
  1032e0:	85 c0                	test   %eax,%eax
  1032e2:	74 24                	je     103308 <basic_check+0x2b5>
  1032e4:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  1032eb:	00 
  1032ec:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1032f3:	00 
  1032f4:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  1032fb:	00 
  1032fc:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103303:	e8 c9 d9 ff ff       	call   100cd1 <__panic>

    free_page(p0);
  103308:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10330f:	00 
  103310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103313:	89 04 24             	mov    %eax,(%esp)
  103316:	e8 3d 0c 00 00       	call   103f58 <free_pages>

    free_page(p1);
  10331b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103322:	00 
  103323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103326:	89 04 24             	mov    %eax,(%esp)
  103329:	e8 2a 0c 00 00       	call   103f58 <free_pages>
    free_page(p2);
  10332e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103335:	00 
  103336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103339:	89 04 24             	mov    %eax,(%esp)
  10333c:	e8 17 0c 00 00       	call   103f58 <free_pages>


    assert(nr_free == 3);
  103341:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103346:	83 f8 03             	cmp    $0x3,%eax
  103349:	74 24                	je     10336f <basic_check+0x31c>
  10334b:	c7 44 24 0c df 6a 10 	movl   $0x106adf,0xc(%esp)
  103352:	00 
  103353:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10335a:	00 
  10335b:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  103362:	00 
  103363:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10336a:	e8 62 d9 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10336f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103376:	e8 a5 0b 00 00       	call   103f20 <alloc_pages>
  10337b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10337e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103382:	75 24                	jne    1033a8 <basic_check+0x355>
  103384:	c7 44 24 0c a5 69 10 	movl   $0x1069a5,0xc(%esp)
  10338b:	00 
  10338c:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103393:	00 
  103394:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
  10339b:	00 
  10339c:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1033a3:	e8 29 d9 ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1033a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033af:	e8 6c 0b 00 00       	call   103f20 <alloc_pages>
  1033b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033bb:	75 24                	jne    1033e1 <basic_check+0x38e>
  1033bd:	c7 44 24 0c c1 69 10 	movl   $0x1069c1,0xc(%esp)
  1033c4:	00 
  1033c5:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1033cc:	00 
  1033cd:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
  1033d4:	00 
  1033d5:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1033dc:	e8 f0 d8 ff ff       	call   100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033e8:	e8 33 0b 00 00       	call   103f20 <alloc_pages>
  1033ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033f4:	75 24                	jne    10341a <basic_check+0x3c7>
  1033f6:	c7 44 24 0c dd 69 10 	movl   $0x1069dd,0xc(%esp)
  1033fd:	00 
  1033fe:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103405:	00 
  103406:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  10340d:	00 
  10340e:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103415:	e8 b7 d8 ff ff       	call   100cd1 <__panic>

    assert(alloc_page() == NULL);
  10341a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103421:	e8 fa 0a 00 00       	call   103f20 <alloc_pages>
  103426:	85 c0                	test   %eax,%eax
  103428:	74 24                	je     10344e <basic_check+0x3fb>
  10342a:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  103431:	00 
  103432:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103439:	00 
  10343a:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  103441:	00 
  103442:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103449:	e8 83 d8 ff ff       	call   100cd1 <__panic>

    free_page(p0);
  10344e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103455:	00 
  103456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103459:	89 04 24             	mov    %eax,(%esp)
  10345c:	e8 f7 0a 00 00       	call   103f58 <free_pages>
  103461:	c7 45 d8 b0 89 11 00 	movl   $0x1189b0,-0x28(%ebp)
  103468:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10346b:	8b 40 04             	mov    0x4(%eax),%eax
  10346e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103471:	0f 94 c0             	sete   %al
  103474:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103477:	85 c0                	test   %eax,%eax
  103479:	74 24                	je     10349f <basic_check+0x44c>
  10347b:	c7 44 24 0c ec 6a 10 	movl   $0x106aec,0xc(%esp)
  103482:	00 
  103483:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10348a:	00 
  10348b:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
  103492:	00 
  103493:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10349a:	e8 32 d8 ff ff       	call   100cd1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10349f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034a6:	e8 75 0a 00 00       	call   103f20 <alloc_pages>
  1034ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034b4:	74 24                	je     1034da <basic_check+0x487>
  1034b6:	c7 44 24 0c 04 6b 10 	movl   $0x106b04,0xc(%esp)
  1034bd:	00 
  1034be:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1034c5:	00 
  1034c6:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
  1034cd:	00 
  1034ce:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1034d5:	e8 f7 d7 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  1034da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034e1:	e8 3a 0a 00 00       	call   103f20 <alloc_pages>
  1034e6:	85 c0                	test   %eax,%eax
  1034e8:	74 24                	je     10350e <basic_check+0x4bb>
  1034ea:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  1034f1:	00 
  1034f2:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1034f9:	00 
  1034fa:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
  103501:	00 
  103502:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103509:	e8 c3 d7 ff ff       	call   100cd1 <__panic>

    assert(nr_free == 0);
  10350e:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103513:	85 c0                	test   %eax,%eax
  103515:	74 24                	je     10353b <basic_check+0x4e8>
  103517:	c7 44 24 0c 1d 6b 10 	movl   $0x106b1d,0xc(%esp)
  10351e:	00 
  10351f:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103526:	00 
  103527:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
  10352e:	00 
  10352f:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103536:	e8 96 d7 ff ff       	call   100cd1 <__panic>
    free_list = free_list_store;
  10353b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10353e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103541:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  103546:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    nr_free = nr_free_store;
  10354c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10354f:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_page(p);
  103554:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10355b:	00 
  10355c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10355f:	89 04 24             	mov    %eax,(%esp)
  103562:	e8 f1 09 00 00       	call   103f58 <free_pages>
    free_page(p1);
  103567:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10356e:	00 
  10356f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103572:	89 04 24             	mov    %eax,(%esp)
  103575:	e8 de 09 00 00       	call   103f58 <free_pages>
    free_page(p2);
  10357a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103581:	00 
  103582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103585:	89 04 24             	mov    %eax,(%esp)
  103588:	e8 cb 09 00 00       	call   103f58 <free_pages>
}
  10358d:	c9                   	leave  
  10358e:	c3                   	ret    

0010358f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10358f:	55                   	push   %ebp
  103590:	89 e5                	mov    %esp,%ebp
  103592:	53                   	push   %ebx
  103593:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035a7:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
#if 1
    while ((le = list_next(le)) != &free_list) {
  1035ae:	eb 6b                	jmp    10361b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1035b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035b3:	83 e8 0c             	sub    $0xc,%eax
  1035b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1035b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035bc:	83 c0 04             	add    $0x4,%eax
  1035bf:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035cc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035cf:	0f a3 10             	bt     %edx,(%eax)
  1035d2:	19 c0                	sbb    %eax,%eax
  1035d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035db:	0f 95 c0             	setne  %al
  1035de:	0f b6 c0             	movzbl %al,%eax
  1035e1:	85 c0                	test   %eax,%eax
  1035e3:	75 24                	jne    103609 <default_check+0x7a>
  1035e5:	c7 44 24 0c 2a 6b 10 	movl   $0x106b2a,0xc(%esp)
  1035ec:	00 
  1035ed:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1035f4:	00 
  1035f5:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
  1035fc:	00 
  1035fd:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103604:	e8 c8 d6 ff ff       	call   100cd1 <__panic>
        count ++, total += p->property;
  103609:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10360d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103610:	8b 50 08             	mov    0x8(%eax),%edx
  103613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103616:	01 d0                	add    %edx,%eax
  103618:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10361b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10361e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103621:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103624:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
#if 1
    while ((le = list_next(le)) != &free_list) {
  103627:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10362a:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  103631:	0f 85 79 ff ff ff    	jne    1035b0 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103637:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10363a:	e8 4b 09 00 00       	call   103f8a <nr_free_pages>
  10363f:	39 c3                	cmp    %eax,%ebx
  103641:	74 24                	je     103667 <default_check+0xd8>
  103643:	c7 44 24 0c 3a 6b 10 	movl   $0x106b3a,0xc(%esp)
  10364a:	00 
  10364b:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103652:	00 
  103653:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
  10365a:	00 
  10365b:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103662:	e8 6a d6 ff ff       	call   100cd1 <__panic>
    basic_check();
  103667:	e8 e7 f9 ff ff       	call   103053 <basic_check>
#endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10366c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103673:	e8 a8 08 00 00       	call   103f20 <alloc_pages>
  103678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10367b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10367f:	75 24                	jne    1036a5 <default_check+0x116>
  103681:	c7 44 24 0c 53 6b 10 	movl   $0x106b53,0xc(%esp)
  103688:	00 
  103689:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103690:	00 
  103691:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
  103698:	00 
  103699:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1036a0:	e8 2c d6 ff ff       	call   100cd1 <__panic>
    assert(!PageProperty(p0));
  1036a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036a8:	83 c0 04             	add    $0x4,%eax
  1036ab:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1036b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1036b8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1036bb:	0f a3 10             	bt     %edx,(%eax)
  1036be:	19 c0                	sbb    %eax,%eax
  1036c0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036c3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036c7:	0f 95 c0             	setne  %al
  1036ca:	0f b6 c0             	movzbl %al,%eax
  1036cd:	85 c0                	test   %eax,%eax
  1036cf:	74 24                	je     1036f5 <default_check+0x166>
  1036d1:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  1036d8:	00 
  1036d9:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1036e0:	00 
  1036e1:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
  1036e8:	00 
  1036e9:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1036f0:	e8 dc d5 ff ff       	call   100cd1 <__panic>

    list_entry_t free_list_store = free_list;
  1036f5:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  1036fa:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  103700:	89 45 80             	mov    %eax,-0x80(%ebp)
  103703:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103706:	c7 45 b4 b0 89 11 00 	movl   $0x1189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10370d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103710:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103713:	89 50 04             	mov    %edx,0x4(%eax)
  103716:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103719:	8b 50 04             	mov    0x4(%eax),%edx
  10371c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10371f:	89 10                	mov    %edx,(%eax)
  103721:	c7 45 b0 b0 89 11 00 	movl   $0x1189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103728:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10372b:	8b 40 04             	mov    0x4(%eax),%eax
  10372e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103731:	0f 94 c0             	sete   %al
  103734:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103737:	85 c0                	test   %eax,%eax
  103739:	75 24                	jne    10375f <default_check+0x1d0>
  10373b:	c7 44 24 0c b3 6a 10 	movl   $0x106ab3,0xc(%esp)
  103742:	00 
  103743:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10374a:	00 
  10374b:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  103752:	00 
  103753:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10375a:	e8 72 d5 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  10375f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103766:	e8 b5 07 00 00       	call   103f20 <alloc_pages>
  10376b:	85 c0                	test   %eax,%eax
  10376d:	74 24                	je     103793 <default_check+0x204>
  10376f:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  103776:	00 
  103777:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10377e:	00 
  10377f:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
  103786:	00 
  103787:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10378e:	e8 3e d5 ff ff       	call   100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
  103793:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103798:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10379b:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  1037a2:	00 00 00 

    free_pages(p0 + 2, 3);
  1037a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037a8:	83 c0 28             	add    $0x28,%eax
  1037ab:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037b2:	00 
  1037b3:	89 04 24             	mov    %eax,(%esp)
  1037b6:	e8 9d 07 00 00       	call   103f58 <free_pages>
    assert(alloc_pages(4) == NULL);
  1037bb:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037c2:	e8 59 07 00 00       	call   103f20 <alloc_pages>
  1037c7:	85 c0                	test   %eax,%eax
  1037c9:	74 24                	je     1037ef <default_check+0x260>
  1037cb:	c7 44 24 0c 70 6b 10 	movl   $0x106b70,0xc(%esp)
  1037d2:	00 
  1037d3:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1037da:	00 
  1037db:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
  1037e2:	00 
  1037e3:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1037ea:	e8 e2 d4 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037f2:	83 c0 28             	add    $0x28,%eax
  1037f5:	83 c0 04             	add    $0x4,%eax
  1037f8:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1037ff:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103802:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103805:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103808:	0f a3 10             	bt     %edx,(%eax)
  10380b:	19 c0                	sbb    %eax,%eax
  10380d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103810:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103814:	0f 95 c0             	setne  %al
  103817:	0f b6 c0             	movzbl %al,%eax
  10381a:	85 c0                	test   %eax,%eax
  10381c:	74 0e                	je     10382c <default_check+0x29d>
  10381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103821:	83 c0 28             	add    $0x28,%eax
  103824:	8b 40 08             	mov    0x8(%eax),%eax
  103827:	83 f8 03             	cmp    $0x3,%eax
  10382a:	74 24                	je     103850 <default_check+0x2c1>
  10382c:	c7 44 24 0c 88 6b 10 	movl   $0x106b88,0xc(%esp)
  103833:	00 
  103834:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10383b:	00 
  10383c:	c7 44 24 04 83 01 00 	movl   $0x183,0x4(%esp)
  103843:	00 
  103844:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10384b:	e8 81 d4 ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103850:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103857:	e8 c4 06 00 00       	call   103f20 <alloc_pages>
  10385c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10385f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103863:	75 24                	jne    103889 <default_check+0x2fa>
  103865:	c7 44 24 0c b4 6b 10 	movl   $0x106bb4,0xc(%esp)
  10386c:	00 
  10386d:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103874:	00 
  103875:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
  10387c:	00 
  10387d:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103884:	e8 48 d4 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  103889:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103890:	e8 8b 06 00 00       	call   103f20 <alloc_pages>
  103895:	85 c0                	test   %eax,%eax
  103897:	74 24                	je     1038bd <default_check+0x32e>
  103899:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  1038a0:	00 
  1038a1:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1038a8:	00 
  1038a9:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
  1038b0:	00 
  1038b1:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1038b8:	e8 14 d4 ff ff       	call   100cd1 <__panic>
    assert(p0 + 2 == p1);
  1038bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038c0:	83 c0 28             	add    $0x28,%eax
  1038c3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1038c6:	74 24                	je     1038ec <default_check+0x35d>
  1038c8:	c7 44 24 0c d2 6b 10 	movl   $0x106bd2,0xc(%esp)
  1038cf:	00 
  1038d0:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1038d7:	00 
  1038d8:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
  1038df:	00 
  1038e0:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1038e7:	e8 e5 d3 ff ff       	call   100cd1 <__panic>

    p2 = p0 + 1;
  1038ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038ef:	83 c0 14             	add    $0x14,%eax
  1038f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1038f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038fc:	00 
  1038fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103900:	89 04 24             	mov    %eax,(%esp)
  103903:	e8 50 06 00 00       	call   103f58 <free_pages>
    free_pages(p1, 3);
  103908:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10390f:	00 
  103910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103913:	89 04 24             	mov    %eax,(%esp)
  103916:	e8 3d 06 00 00       	call   103f58 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10391b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10391e:	83 c0 04             	add    $0x4,%eax
  103921:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103928:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10392b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10392e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103931:	0f a3 10             	bt     %edx,(%eax)
  103934:	19 c0                	sbb    %eax,%eax
  103936:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103939:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10393d:	0f 95 c0             	setne  %al
  103940:	0f b6 c0             	movzbl %al,%eax
  103943:	85 c0                	test   %eax,%eax
  103945:	74 0b                	je     103952 <default_check+0x3c3>
  103947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10394a:	8b 40 08             	mov    0x8(%eax),%eax
  10394d:	83 f8 01             	cmp    $0x1,%eax
  103950:	74 24                	je     103976 <default_check+0x3e7>
  103952:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  103959:	00 
  10395a:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103961:	00 
  103962:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
  103969:	00 
  10396a:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103971:	e8 5b d3 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103976:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103979:	83 c0 04             	add    $0x4,%eax
  10397c:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103983:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103986:	8b 45 90             	mov    -0x70(%ebp),%eax
  103989:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10398c:	0f a3 10             	bt     %edx,(%eax)
  10398f:	19 c0                	sbb    %eax,%eax
  103991:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103994:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103998:	0f 95 c0             	setne  %al
  10399b:	0f b6 c0             	movzbl %al,%eax
  10399e:	85 c0                	test   %eax,%eax
  1039a0:	74 0b                	je     1039ad <default_check+0x41e>
  1039a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039a5:	8b 40 08             	mov    0x8(%eax),%eax
  1039a8:	83 f8 03             	cmp    $0x3,%eax
  1039ab:	74 24                	je     1039d1 <default_check+0x442>
  1039ad:	c7 44 24 0c 08 6c 10 	movl   $0x106c08,0xc(%esp)
  1039b4:	00 
  1039b5:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1039bc:	00 
  1039bd:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
  1039c4:	00 
  1039c5:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1039cc:	e8 00 d3 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039d8:	e8 43 05 00 00       	call   103f20 <alloc_pages>
  1039dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1039e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039e3:	83 e8 14             	sub    $0x14,%eax
  1039e6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1039e9:	74 24                	je     103a0f <default_check+0x480>
  1039eb:	c7 44 24 0c 2e 6c 10 	movl   $0x106c2e,0xc(%esp)
  1039f2:	00 
  1039f3:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1039fa:	00 
  1039fb:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
  103a02:	00 
  103a03:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103a0a:	e8 c2 d2 ff ff       	call   100cd1 <__panic>
    free_page(p0);
  103a0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a16:	00 
  103a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a1a:	89 04 24             	mov    %eax,(%esp)
  103a1d:	e8 36 05 00 00       	call   103f58 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a22:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a29:	e8 f2 04 00 00       	call   103f20 <alloc_pages>
  103a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a31:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a34:	83 c0 14             	add    $0x14,%eax
  103a37:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a3a:	74 24                	je     103a60 <default_check+0x4d1>
  103a3c:	c7 44 24 0c 4c 6c 10 	movl   $0x106c4c,0xc(%esp)
  103a43:	00 
  103a44:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103a4b:	00 
  103a4c:	c7 44 24 04 90 01 00 	movl   $0x190,0x4(%esp)
  103a53:	00 
  103a54:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103a5b:	e8 71 d2 ff ff       	call   100cd1 <__panic>

    free_pages(p0, 2);
  103a60:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a67:	00 
  103a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a6b:	89 04 24             	mov    %eax,(%esp)
  103a6e:	e8 e5 04 00 00       	call   103f58 <free_pages>
    free_page(p2);
  103a73:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a7a:	00 
  103a7b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a7e:	89 04 24             	mov    %eax,(%esp)
  103a81:	e8 d2 04 00 00       	call   103f58 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a86:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a8d:	e8 8e 04 00 00       	call   103f20 <alloc_pages>
  103a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103a99:	75 24                	jne    103abf <default_check+0x530>
  103a9b:	c7 44 24 0c 6c 6c 10 	movl   $0x106c6c,0xc(%esp)
  103aa2:	00 
  103aa3:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103aaa:	00 
  103aab:	c7 44 24 04 95 01 00 	movl   $0x195,0x4(%esp)
  103ab2:	00 
  103ab3:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103aba:	e8 12 d2 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  103abf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103ac6:	e8 55 04 00 00       	call   103f20 <alloc_pages>
  103acb:	85 c0                	test   %eax,%eax
  103acd:	74 24                	je     103af3 <default_check+0x564>
  103acf:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  103ad6:	00 
  103ad7:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103ade:	00 
  103adf:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
  103ae6:	00 
  103ae7:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103aee:	e8 de d1 ff ff       	call   100cd1 <__panic>

    assert(nr_free == 0);
  103af3:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103af8:	85 c0                	test   %eax,%eax
  103afa:	74 24                	je     103b20 <default_check+0x591>
  103afc:	c7 44 24 0c 1d 6b 10 	movl   $0x106b1d,0xc(%esp)
  103b03:	00 
  103b04:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103b0b:	00 
  103b0c:	c7 44 24 04 98 01 00 	movl   $0x198,0x4(%esp)
  103b13:	00 
  103b14:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103b1b:	e8 b1 d1 ff ff       	call   100cd1 <__panic>
    nr_free = nr_free_store;
  103b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b23:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_list = free_list_store;
  103b28:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b2b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b2e:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  103b33:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    free_pages(p0, 5);
  103b39:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b40:	00 
  103b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b44:	89 04 24             	mov    %eax,(%esp)
  103b47:	e8 0c 04 00 00       	call   103f58 <free_pages>

    le = &free_list;
  103b4c:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b53:	eb 1d                	jmp    103b72 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b58:	83 e8 0c             	sub    $0xc,%eax
  103b5b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103b5e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103b62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103b68:	8b 40 08             	mov    0x8(%eax),%eax
  103b6b:	29 c2                	sub    %eax,%edx
  103b6d:	89 d0                	mov    %edx,%eax
  103b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b75:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103b78:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b7b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b81:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  103b88:	75 cb                	jne    103b55 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b8e:	74 24                	je     103bb4 <default_check+0x625>
  103b90:	c7 44 24 0c 8a 6c 10 	movl   $0x106c8a,0xc(%esp)
  103b97:	00 
  103b98:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103b9f:	00 
  103ba0:	c7 44 24 04 a3 01 00 	movl   $0x1a3,0x4(%esp)
  103ba7:	00 
  103ba8:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103baf:	e8 1d d1 ff ff       	call   100cd1 <__panic>
    assert(total == 0);
  103bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bb8:	74 24                	je     103bde <default_check+0x64f>
  103bba:	c7 44 24 0c 95 6c 10 	movl   $0x106c95,0xc(%esp)
  103bc1:	00 
  103bc2:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103bc9:	00 
  103bca:	c7 44 24 04 a4 01 00 	movl   $0x1a4,0x4(%esp)
  103bd1:	00 
  103bd2:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103bd9:	e8 f3 d0 ff ff       	call   100cd1 <__panic>
}
  103bde:	81 c4 94 00 00 00    	add    $0x94,%esp
  103be4:	5b                   	pop    %ebx
  103be5:	5d                   	pop    %ebp
  103be6:	c3                   	ret    

00103be7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103be7:	55                   	push   %ebp
  103be8:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103bea:	8b 55 08             	mov    0x8(%ebp),%edx
  103bed:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  103bf2:	29 c2                	sub    %eax,%edx
  103bf4:	89 d0                	mov    %edx,%eax
  103bf6:	c1 f8 02             	sar    $0x2,%eax
  103bf9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103bff:	5d                   	pop    %ebp
  103c00:	c3                   	ret    

00103c01 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103c01:	55                   	push   %ebp
  103c02:	89 e5                	mov    %esp,%ebp
  103c04:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c07:	8b 45 08             	mov    0x8(%ebp),%eax
  103c0a:	89 04 24             	mov    %eax,(%esp)
  103c0d:	e8 d5 ff ff ff       	call   103be7 <page2ppn>
  103c12:	c1 e0 0c             	shl    $0xc,%eax
}
  103c15:	c9                   	leave  
  103c16:	c3                   	ret    

00103c17 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103c17:	55                   	push   %ebp
  103c18:	89 e5                	mov    %esp,%ebp
  103c1a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  103c20:	c1 e8 0c             	shr    $0xc,%eax
  103c23:	89 c2                	mov    %eax,%edx
  103c25:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c2a:	39 c2                	cmp    %eax,%edx
  103c2c:	72 1c                	jb     103c4a <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c2e:	c7 44 24 08 d0 6c 10 	movl   $0x106cd0,0x8(%esp)
  103c35:	00 
  103c36:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c3d:	00 
  103c3e:	c7 04 24 ef 6c 10 00 	movl   $0x106cef,(%esp)
  103c45:	e8 87 d0 ff ff       	call   100cd1 <__panic>
    }
    return &pages[PPN(pa)];
  103c4a:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  103c50:	8b 45 08             	mov    0x8(%ebp),%eax
  103c53:	c1 e8 0c             	shr    $0xc,%eax
  103c56:	89 c2                	mov    %eax,%edx
  103c58:	89 d0                	mov    %edx,%eax
  103c5a:	c1 e0 02             	shl    $0x2,%eax
  103c5d:	01 d0                	add    %edx,%eax
  103c5f:	c1 e0 02             	shl    $0x2,%eax
  103c62:	01 c8                	add    %ecx,%eax
}
  103c64:	c9                   	leave  
  103c65:	c3                   	ret    

00103c66 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103c66:	55                   	push   %ebp
  103c67:	89 e5                	mov    %esp,%ebp
  103c69:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  103c6f:	89 04 24             	mov    %eax,(%esp)
  103c72:	e8 8a ff ff ff       	call   103c01 <page2pa>
  103c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c7d:	c1 e8 0c             	shr    $0xc,%eax
  103c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c83:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c88:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103c8b:	72 23                	jb     103cb0 <page2kva+0x4a>
  103c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c94:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  103c9b:	00 
  103c9c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103ca3:	00 
  103ca4:	c7 04 24 ef 6c 10 00 	movl   $0x106cef,(%esp)
  103cab:	e8 21 d0 ff ff       	call   100cd1 <__panic>
  103cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cb8:	c9                   	leave  
  103cb9:	c3                   	ret    

00103cba <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103cba:	55                   	push   %ebp
  103cbb:	89 e5                	mov    %esp,%ebp
  103cbd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  103cc3:	83 e0 01             	and    $0x1,%eax
  103cc6:	85 c0                	test   %eax,%eax
  103cc8:	75 1c                	jne    103ce6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103cca:	c7 44 24 08 24 6d 10 	movl   $0x106d24,0x8(%esp)
  103cd1:	00 
  103cd2:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cd9:	00 
  103cda:	c7 04 24 ef 6c 10 00 	movl   $0x106cef,(%esp)
  103ce1:	e8 eb cf ff ff       	call   100cd1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  103ce9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cee:	89 04 24             	mov    %eax,(%esp)
  103cf1:	e8 21 ff ff ff       	call   103c17 <pa2page>
}
  103cf6:	c9                   	leave  
  103cf7:	c3                   	ret    

00103cf8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103cf8:	55                   	push   %ebp
  103cf9:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  103cfe:	8b 00                	mov    (%eax),%eax
}
  103d00:	5d                   	pop    %ebp
  103d01:	c3                   	ret    

00103d02 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103d02:	55                   	push   %ebp
  103d03:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d05:	8b 45 08             	mov    0x8(%ebp),%eax
  103d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0b:	89 10                	mov    %edx,(%eax)
}
  103d0d:	5d                   	pop    %ebp
  103d0e:	c3                   	ret    

00103d0f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d0f:	55                   	push   %ebp
  103d10:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d12:	8b 45 08             	mov    0x8(%ebp),%eax
  103d15:	8b 00                	mov    (%eax),%eax
  103d17:	8d 50 01             	lea    0x1(%eax),%edx
  103d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d1d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  103d22:	8b 00                	mov    (%eax),%eax
}
  103d24:	5d                   	pop    %ebp
  103d25:	c3                   	ret    

00103d26 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d26:	55                   	push   %ebp
  103d27:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d29:	8b 45 08             	mov    0x8(%ebp),%eax
  103d2c:	8b 00                	mov    (%eax),%eax
  103d2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d31:	8b 45 08             	mov    0x8(%ebp),%eax
  103d34:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d36:	8b 45 08             	mov    0x8(%ebp),%eax
  103d39:	8b 00                	mov    (%eax),%eax
}
  103d3b:	5d                   	pop    %ebp
  103d3c:	c3                   	ret    

00103d3d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103d3d:	55                   	push   %ebp
  103d3e:	89 e5                	mov    %esp,%ebp
  103d40:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d43:	9c                   	pushf  
  103d44:	58                   	pop    %eax
  103d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d4b:	25 00 02 00 00       	and    $0x200,%eax
  103d50:	85 c0                	test   %eax,%eax
  103d52:	74 0c                	je     103d60 <__intr_save+0x23>
        intr_disable();
  103d54:	e8 5b d9 ff ff       	call   1016b4 <intr_disable>
        return 1;
  103d59:	b8 01 00 00 00       	mov    $0x1,%eax
  103d5e:	eb 05                	jmp    103d65 <__intr_save+0x28>
    }
    return 0;
  103d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d65:	c9                   	leave  
  103d66:	c3                   	ret    

00103d67 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103d67:	55                   	push   %ebp
  103d68:	89 e5                	mov    %esp,%ebp
  103d6a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103d6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103d71:	74 05                	je     103d78 <__intr_restore+0x11>
        intr_enable();
  103d73:	e8 36 d9 ff ff       	call   1016ae <intr_enable>
    }
}
  103d78:	c9                   	leave  
  103d79:	c3                   	ret    

00103d7a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103d7a:	55                   	push   %ebp
  103d7b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d80:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103d83:	b8 23 00 00 00       	mov    $0x23,%eax
  103d88:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103d8a:	b8 23 00 00 00       	mov    $0x23,%eax
  103d8f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103d91:	b8 10 00 00 00       	mov    $0x10,%eax
  103d96:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103d98:	b8 10 00 00 00       	mov    $0x10,%eax
  103d9d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103d9f:	b8 10 00 00 00       	mov    $0x10,%eax
  103da4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103da6:	ea ad 3d 10 00 08 00 	ljmp   $0x8,$0x103dad
}
  103dad:	5d                   	pop    %ebp
  103dae:	c3                   	ret    

00103daf <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103daf:	55                   	push   %ebp
  103db0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103db2:	8b 45 08             	mov    0x8(%ebp),%eax
  103db5:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103dba:	5d                   	pop    %ebp
  103dbb:	c3                   	ret    

00103dbc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103dbc:	55                   	push   %ebp
  103dbd:	89 e5                	mov    %esp,%ebp
  103dbf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103dc2:	b8 00 70 11 00       	mov    $0x117000,%eax
  103dc7:	89 04 24             	mov    %eax,(%esp)
  103dca:	e8 e0 ff ff ff       	call   103daf <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103dcf:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103dd6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103dd8:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103ddf:	68 00 
  103de1:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103de6:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103dec:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103df1:	c1 e8 10             	shr    $0x10,%eax
  103df4:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103df9:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e00:	83 e0 f0             	and    $0xfffffff0,%eax
  103e03:	83 c8 09             	or     $0x9,%eax
  103e06:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e0b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e12:	83 e0 ef             	and    $0xffffffef,%eax
  103e15:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e1a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e21:	83 e0 9f             	and    $0xffffff9f,%eax
  103e24:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e29:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e30:	83 c8 80             	or     $0xffffff80,%eax
  103e33:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e38:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e3f:	83 e0 f0             	and    $0xfffffff0,%eax
  103e42:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e47:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e4e:	83 e0 ef             	and    $0xffffffef,%eax
  103e51:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e56:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e5d:	83 e0 df             	and    $0xffffffdf,%eax
  103e60:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e65:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e6c:	83 c8 40             	or     $0x40,%eax
  103e6f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e74:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e7b:	83 e0 7f             	and    $0x7f,%eax
  103e7e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e83:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103e88:	c1 e8 18             	shr    $0x18,%eax
  103e8b:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103e90:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103e97:	e8 de fe ff ff       	call   103d7a <lgdt>
  103e9c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103ea2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103ea6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103ea9:	c9                   	leave  
  103eaa:	c3                   	ret    

00103eab <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103eab:	55                   	push   %ebp
  103eac:	89 e5                	mov    %esp,%ebp
  103eae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103eb1:	c7 05 bc 89 11 00 b4 	movl   $0x106cb4,0x1189bc
  103eb8:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ebb:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103ec0:	8b 00                	mov    (%eax),%eax
  103ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ec6:	c7 04 24 50 6d 10 00 	movl   $0x106d50,(%esp)
  103ecd:	e8 75 c4 ff ff       	call   100347 <cprintf>
    pmm_manager->init();
  103ed2:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103ed7:	8b 40 04             	mov    0x4(%eax),%eax
  103eda:	ff d0                	call   *%eax
}
  103edc:	c9                   	leave  
  103edd:	c3                   	ret    

00103ede <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103ede:	55                   	push   %ebp
  103edf:	89 e5                	mov    %esp,%ebp
  103ee1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s in %s n is %d\n",  __func__, __FILE__, n);
  103ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ee7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103eeb:	c7 44 24 08 67 6d 10 	movl   $0x106d67,0x8(%esp)
  103ef2:	00 
  103ef3:	c7 44 24 04 41 73 10 	movl   $0x107341,0x4(%esp)
  103efa:	00 
  103efb:	c7 04 24 75 6d 10 00 	movl   $0x106d75,(%esp)
  103f02:	e8 40 c4 ff ff       	call   100347 <cprintf>
    pmm_manager->init_memmap(base, n);
  103f07:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103f0c:	8b 40 08             	mov    0x8(%eax),%eax
  103f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f12:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f16:	8b 55 08             	mov    0x8(%ebp),%edx
  103f19:	89 14 24             	mov    %edx,(%esp)
  103f1c:	ff d0                	call   *%eax
}
  103f1e:	c9                   	leave  
  103f1f:	c3                   	ret    

00103f20 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f20:	55                   	push   %ebp
  103f21:	89 e5                	mov    %esp,%ebp
  103f23:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f2d:	e8 0b fe ff ff       	call   103d3d <__intr_save>
  103f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f35:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  103f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  103f40:	89 14 24             	mov    %edx,(%esp)
  103f43:	ff d0                	call   *%eax
  103f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f4b:	89 04 24             	mov    %eax,(%esp)
  103f4e:	e8 14 fe ff ff       	call   103d67 <__intr_restore>
    return page;
  103f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f56:	c9                   	leave  
  103f57:	c3                   	ret    

00103f58 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f58:	55                   	push   %ebp
  103f59:	89 e5                	mov    %esp,%ebp
  103f5b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f5e:	e8 da fd ff ff       	call   103d3d <__intr_save>
  103f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f66:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103f6b:	8b 40 10             	mov    0x10(%eax),%eax
  103f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f71:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f75:	8b 55 08             	mov    0x8(%ebp),%edx
  103f78:	89 14 24             	mov    %edx,(%esp)
  103f7b:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f80:	89 04 24             	mov    %eax,(%esp)
  103f83:	e8 df fd ff ff       	call   103d67 <__intr_restore>
}
  103f88:	c9                   	leave  
  103f89:	c3                   	ret    

00103f8a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103f8a:	55                   	push   %ebp
  103f8b:	89 e5                	mov    %esp,%ebp
  103f8d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103f90:	e8 a8 fd ff ff       	call   103d3d <__intr_save>
  103f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103f98:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103f9d:	8b 40 14             	mov    0x14(%eax),%eax
  103fa0:	ff d0                	call   *%eax
  103fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fa8:	89 04 24             	mov    %eax,(%esp)
  103fab:	e8 b7 fd ff ff       	call   103d67 <__intr_restore>
    return ret;
  103fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103fb3:	c9                   	leave  
  103fb4:	c3                   	ret    

00103fb5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103fb5:	55                   	push   %ebp
  103fb6:	89 e5                	mov    %esp,%ebp
  103fb8:	57                   	push   %edi
  103fb9:	56                   	push   %esi
  103fba:	53                   	push   %ebx
  103fbb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103fc1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103fc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103fcf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103fd6:	c7 04 24 87 6d 10 00 	movl   $0x106d87,(%esp)
  103fdd:	e8 65 c3 ff ff       	call   100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103fe2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fe9:	e9 15 01 00 00       	jmp    104103 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ff4:	89 d0                	mov    %edx,%eax
  103ff6:	c1 e0 02             	shl    $0x2,%eax
  103ff9:	01 d0                	add    %edx,%eax
  103ffb:	c1 e0 02             	shl    $0x2,%eax
  103ffe:	01 c8                	add    %ecx,%eax
  104000:	8b 50 08             	mov    0x8(%eax),%edx
  104003:	8b 40 04             	mov    0x4(%eax),%eax
  104006:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104009:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10400c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10400f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104012:	89 d0                	mov    %edx,%eax
  104014:	c1 e0 02             	shl    $0x2,%eax
  104017:	01 d0                	add    %edx,%eax
  104019:	c1 e0 02             	shl    $0x2,%eax
  10401c:	01 c8                	add    %ecx,%eax
  10401e:	8b 48 0c             	mov    0xc(%eax),%ecx
  104021:	8b 58 10             	mov    0x10(%eax),%ebx
  104024:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104027:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10402a:	01 c8                	add    %ecx,%eax
  10402c:	11 da                	adc    %ebx,%edx
  10402e:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104031:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104034:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10403a:	89 d0                	mov    %edx,%eax
  10403c:	c1 e0 02             	shl    $0x2,%eax
  10403f:	01 d0                	add    %edx,%eax
  104041:	c1 e0 02             	shl    $0x2,%eax
  104044:	01 c8                	add    %ecx,%eax
  104046:	83 c0 14             	add    $0x14,%eax
  104049:	8b 00                	mov    (%eax),%eax
  10404b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104051:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104054:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104057:	83 c0 ff             	add    $0xffffffff,%eax
  10405a:	83 d2 ff             	adc    $0xffffffff,%edx
  10405d:	89 c6                	mov    %eax,%esi
  10405f:	89 d7                	mov    %edx,%edi
  104061:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104064:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104067:	89 d0                	mov    %edx,%eax
  104069:	c1 e0 02             	shl    $0x2,%eax
  10406c:	01 d0                	add    %edx,%eax
  10406e:	c1 e0 02             	shl    $0x2,%eax
  104071:	01 c8                	add    %ecx,%eax
  104073:	8b 48 0c             	mov    0xc(%eax),%ecx
  104076:	8b 58 10             	mov    0x10(%eax),%ebx
  104079:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  10407f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104083:	89 74 24 14          	mov    %esi,0x14(%esp)
  104087:	89 7c 24 18          	mov    %edi,0x18(%esp)
  10408b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10408e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104091:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104095:	89 54 24 10          	mov    %edx,0x10(%esp)
  104099:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10409d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040a1:	c7 04 24 94 6d 10 00 	movl   $0x106d94,(%esp)
  1040a8:	e8 9a c2 ff ff       	call   100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040ad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040b3:	89 d0                	mov    %edx,%eax
  1040b5:	c1 e0 02             	shl    $0x2,%eax
  1040b8:	01 d0                	add    %edx,%eax
  1040ba:	c1 e0 02             	shl    $0x2,%eax
  1040bd:	01 c8                	add    %ecx,%eax
  1040bf:	83 c0 14             	add    $0x14,%eax
  1040c2:	8b 00                	mov    (%eax),%eax
  1040c4:	83 f8 01             	cmp    $0x1,%eax
  1040c7:	75 36                	jne    1040ff <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  1040c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040cf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1040d2:	77 2b                	ja     1040ff <page_init+0x14a>
  1040d4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1040d7:	72 05                	jb     1040de <page_init+0x129>
  1040d9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  1040dc:	73 21                	jae    1040ff <page_init+0x14a>
  1040de:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1040e2:	77 1b                	ja     1040ff <page_init+0x14a>
  1040e4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1040e8:	72 09                	jb     1040f3 <page_init+0x13e>
  1040ea:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  1040f1:	77 0c                	ja     1040ff <page_init+0x14a>
                maxpa = end;
  1040f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1040f6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1040f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1040fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1040ff:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104103:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104106:	8b 00                	mov    (%eax),%eax
  104108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10410b:	0f 8f dd fe ff ff    	jg     103fee <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104111:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104115:	72 1d                	jb     104134 <page_init+0x17f>
  104117:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10411b:	77 09                	ja     104126 <page_init+0x171>
  10411d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  104124:	76 0e                	jbe    104134 <page_init+0x17f>
        maxpa = KMEMSIZE;
  104126:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10412d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];
//    cprintf("the maxpa is: %08llx\n", maxpa);
    npage = maxpa / PGSIZE;
  104134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104137:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10413a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10413e:	c1 ea 0c             	shr    $0xc,%edx
  104141:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104146:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  10414d:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  104152:	8d 50 ff             	lea    -0x1(%eax),%edx
  104155:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104158:	01 d0                	add    %edx,%eax
  10415a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10415d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104160:	ba 00 00 00 00       	mov    $0x0,%edx
  104165:	f7 75 ac             	divl   -0x54(%ebp)
  104168:	89 d0                	mov    %edx,%eax
  10416a:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10416d:	29 c2                	sub    %eax,%edx
  10416f:	89 d0                	mov    %edx,%eax
  104171:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    for (i = 0; i < npage; i ++) {
  104176:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10417d:	eb 2f                	jmp    1041ae <page_init+0x1f9>
        SetPageReserved(pages + i);
  10417f:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  104185:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104188:	89 d0                	mov    %edx,%eax
  10418a:	c1 e0 02             	shl    $0x2,%eax
  10418d:	01 d0                	add    %edx,%eax
  10418f:	c1 e0 02             	shl    $0x2,%eax
  104192:	01 c8                	add    %ecx,%eax
  104194:	83 c0 04             	add    $0x4,%eax
  104197:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  10419e:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1041a1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1041a4:	8b 55 90             	mov    -0x70(%ebp),%edx
  1041a7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];
//    cprintf("the maxpa is: %08llx\n", maxpa);
    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  1041aa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041b1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1041b6:	39 c2                	cmp    %eax,%edx
  1041b8:	72 c5                	jb     10417f <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041ba:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1041c0:	89 d0                	mov    %edx,%eax
  1041c2:	c1 e0 02             	shl    $0x2,%eax
  1041c5:	01 d0                	add    %edx,%eax
  1041c7:	c1 e0 02             	shl    $0x2,%eax
  1041ca:	89 c2                	mov    %eax,%edx
  1041cc:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1041d1:	01 d0                	add    %edx,%eax
  1041d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1041d6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1041dd:	77 23                	ja     104202 <page_init+0x24d>
  1041df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041e6:	c7 44 24 08 c4 6d 10 	movl   $0x106dc4,0x8(%esp)
  1041ed:	00 
  1041ee:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1041f5:	00 
  1041f6:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1041fd:	e8 cf ca ff ff       	call   100cd1 <__panic>
  104202:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104205:	05 00 00 00 40       	add    $0x40000000,%eax
  10420a:	89 45 a0             	mov    %eax,-0x60(%ebp)
//    cprintf("the freemem is: %08llx\n", freemem);
    for (i = 0; i < memmap->nr_map; i ++) {
  10420d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104214:	e9 74 01 00 00       	jmp    10438d <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104219:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10421c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10421f:	89 d0                	mov    %edx,%eax
  104221:	c1 e0 02             	shl    $0x2,%eax
  104224:	01 d0                	add    %edx,%eax
  104226:	c1 e0 02             	shl    $0x2,%eax
  104229:	01 c8                	add    %ecx,%eax
  10422b:	8b 50 08             	mov    0x8(%eax),%edx
  10422e:	8b 40 04             	mov    0x4(%eax),%eax
  104231:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104234:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104237:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10423a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10423d:	89 d0                	mov    %edx,%eax
  10423f:	c1 e0 02             	shl    $0x2,%eax
  104242:	01 d0                	add    %edx,%eax
  104244:	c1 e0 02             	shl    $0x2,%eax
  104247:	01 c8                	add    %ecx,%eax
  104249:	8b 48 0c             	mov    0xc(%eax),%ecx
  10424c:	8b 58 10             	mov    0x10(%eax),%ebx
  10424f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104252:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104255:	01 c8                	add    %ecx,%eax
  104257:	11 da                	adc    %ebx,%edx
  104259:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10425c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10425f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104262:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104265:	89 d0                	mov    %edx,%eax
  104267:	c1 e0 02             	shl    $0x2,%eax
  10426a:	01 d0                	add    %edx,%eax
  10426c:	c1 e0 02             	shl    $0x2,%eax
  10426f:	01 c8                	add    %ecx,%eax
  104271:	83 c0 14             	add    $0x14,%eax
  104274:	8b 00                	mov    (%eax),%eax
  104276:	83 f8 01             	cmp    $0x1,%eax
  104279:	0f 85 0a 01 00 00    	jne    104389 <page_init+0x3d4>
            if (begin < freemem) {
  10427f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104282:	ba 00 00 00 00       	mov    $0x0,%edx
  104287:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10428a:	72 17                	jb     1042a3 <page_init+0x2ee>
  10428c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10428f:	77 05                	ja     104296 <page_init+0x2e1>
  104291:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104294:	76 0d                	jbe    1042a3 <page_init+0x2ee>
                begin = freemem;
  104296:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104299:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10429c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1042a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1042a7:	72 1d                	jb     1042c6 <page_init+0x311>
  1042a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1042ad:	77 09                	ja     1042b8 <page_init+0x303>
  1042af:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1042b6:	76 0e                	jbe    1042c6 <page_init+0x311>
                end = KMEMSIZE;
  1042b8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042bf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042cc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042cf:	0f 87 b4 00 00 00    	ja     104389 <page_init+0x3d4>
  1042d5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042d8:	72 09                	jb     1042e3 <page_init+0x32e>
  1042da:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042dd:	0f 83 a6 00 00 00    	jae    104389 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1042e3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1042ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1042f0:	01 d0                	add    %edx,%eax
  1042f2:	83 e8 01             	sub    $0x1,%eax
  1042f5:	89 45 98             	mov    %eax,-0x68(%ebp)
  1042f8:	8b 45 98             	mov    -0x68(%ebp),%eax
  1042fb:	ba 00 00 00 00       	mov    $0x0,%edx
  104300:	f7 75 9c             	divl   -0x64(%ebp)
  104303:	89 d0                	mov    %edx,%eax
  104305:	8b 55 98             	mov    -0x68(%ebp),%edx
  104308:	29 c2                	sub    %eax,%edx
  10430a:	89 d0                	mov    %edx,%eax
  10430c:	ba 00 00 00 00       	mov    $0x0,%edx
  104311:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104314:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104317:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10431a:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10431d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104320:	ba 00 00 00 00       	mov    $0x0,%edx
  104325:	89 c7                	mov    %eax,%edi
  104327:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10432d:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104330:	89 d0                	mov    %edx,%eax
  104332:	83 e0 00             	and    $0x0,%eax
  104335:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104338:	8b 45 80             	mov    -0x80(%ebp),%eax
  10433b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10433e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104341:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104344:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104347:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10434a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10434d:	77 3a                	ja     104389 <page_init+0x3d4>
  10434f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104352:	72 05                	jb     104359 <page_init+0x3a4>
  104354:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104357:	73 30                	jae    104389 <page_init+0x3d4>
//		    cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
//			memmap->map[i].size, begin, end - 1, memmap->map[i].type);
//		    cprintf("the pages is %d\n", (end - begin) / PGSIZE);
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104359:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10435c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10435f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104362:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104365:	29 c8                	sub    %ecx,%eax
  104367:	19 da                	sbb    %ebx,%edx
  104369:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10436d:	c1 ea 0c             	shr    $0xc,%edx
  104370:	89 c3                	mov    %eax,%ebx
  104372:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104375:	89 04 24             	mov    %eax,(%esp)
  104378:	e8 9a f8 ff ff       	call   103c17 <pa2page>
  10437d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104381:	89 04 24             	mov    %eax,(%esp)
  104384:	e8 55 fb ff ff       	call   103ede <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
//    cprintf("the freemem is: %08llx\n", freemem);
    for (i = 0; i < memmap->nr_map; i ++) {
  104389:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10438d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104390:	8b 00                	mov    (%eax),%eax
  104392:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104395:	0f 8f 7e fe ff ff    	jg     104219 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10439b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1043a1:	5b                   	pop    %ebx
  1043a2:	5e                   	pop    %esi
  1043a3:	5f                   	pop    %edi
  1043a4:	5d                   	pop    %ebp
  1043a5:	c3                   	ret    

001043a6 <enable_paging>:

static void
enable_paging(void) {
  1043a6:	55                   	push   %ebp
  1043a7:	89 e5                	mov    %esp,%ebp
  1043a9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1043ac:	a1 c0 89 11 00       	mov    0x1189c0,%eax
  1043b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1043b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1043b7:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1043ba:	0f 20 c0             	mov    %cr0,%eax
  1043bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1043c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1043c6:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1043cd:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1043d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1043d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043da:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1043dd:	c9                   	leave  
  1043de:	c3                   	ret    

001043df <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043df:	55                   	push   %ebp
  1043e0:	89 e5                	mov    %esp,%ebp
  1043e2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1043e5:	8b 45 14             	mov    0x14(%ebp),%eax
  1043e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043eb:	31 d0                	xor    %edx,%eax
  1043ed:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043f2:	85 c0                	test   %eax,%eax
  1043f4:	74 24                	je     10441a <boot_map_segment+0x3b>
  1043f6:	c7 44 24 0c e8 6d 10 	movl   $0x106de8,0xc(%esp)
  1043fd:	00 
  1043fe:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104405:	00 
  104406:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  10440d:	00 
  10440e:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104415:	e8 b7 c8 ff ff       	call   100cd1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10441a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104421:	8b 45 0c             	mov    0xc(%ebp),%eax
  104424:	25 ff 0f 00 00       	and    $0xfff,%eax
  104429:	89 c2                	mov    %eax,%edx
  10442b:	8b 45 10             	mov    0x10(%ebp),%eax
  10442e:	01 c2                	add    %eax,%edx
  104430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104433:	01 d0                	add    %edx,%eax
  104435:	83 e8 01             	sub    $0x1,%eax
  104438:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10443b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10443e:	ba 00 00 00 00       	mov    $0x0,%edx
  104443:	f7 75 f0             	divl   -0x10(%ebp)
  104446:	89 d0                	mov    %edx,%eax
  104448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10444b:	29 c2                	sub    %eax,%edx
  10444d:	89 d0                	mov    %edx,%eax
  10444f:	c1 e8 0c             	shr    $0xc,%eax
  104452:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104455:	8b 45 0c             	mov    0xc(%ebp),%eax
  104458:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10445b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10445e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104463:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104466:	8b 45 14             	mov    0x14(%ebp),%eax
  104469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10446c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10446f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104474:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104477:	eb 6b                	jmp    1044e4 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104480:	00 
  104481:	8b 45 0c             	mov    0xc(%ebp),%eax
  104484:	89 44 24 04          	mov    %eax,0x4(%esp)
  104488:	8b 45 08             	mov    0x8(%ebp),%eax
  10448b:	89 04 24             	mov    %eax,(%esp)
  10448e:	e8 cc 01 00 00       	call   10465f <get_pte>
  104493:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10449a:	75 24                	jne    1044c0 <boot_map_segment+0xe1>
  10449c:	c7 44 24 0c 14 6e 10 	movl   $0x106e14,0xc(%esp)
  1044a3:	00 
  1044a4:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  1044ab:	00 
  1044ac:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1044b3:	00 
  1044b4:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1044bb:	e8 11 c8 ff ff       	call   100cd1 <__panic>
        *ptep = pa | PTE_P | perm;
  1044c0:	8b 45 18             	mov    0x18(%ebp),%eax
  1044c3:	8b 55 14             	mov    0x14(%ebp),%edx
  1044c6:	09 d0                	or     %edx,%eax
  1044c8:	83 c8 01             	or     $0x1,%eax
  1044cb:	89 c2                	mov    %eax,%edx
  1044cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044d0:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1044d6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044dd:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044e8:	75 8f                	jne    104479 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1044ea:	c9                   	leave  
  1044eb:	c3                   	ret    

001044ec <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044ec:	55                   	push   %ebp
  1044ed:	89 e5                	mov    %esp,%ebp
  1044ef:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044f9:	e8 22 fa ff ff       	call   103f20 <alloc_pages>
  1044fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104505:	75 1c                	jne    104523 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104507:	c7 44 24 08 21 6e 10 	movl   $0x106e21,0x8(%esp)
  10450e:	00 
  10450f:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  104516:	00 
  104517:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10451e:	e8 ae c7 ff ff       	call   100cd1 <__panic>
    }
    return page2kva(p);
  104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104526:	89 04 24             	mov    %eax,(%esp)
  104529:	e8 38 f7 ff ff       	call   103c66 <page2kva>
}
  10452e:	c9                   	leave  
  10452f:	c3                   	ret    

00104530 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104530:	55                   	push   %ebp
  104531:	89 e5                	mov    %esp,%ebp
  104533:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104536:	e8 70 f9 ff ff       	call   103eab <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10453b:	e8 75 fa ff ff       	call   103fb5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104540:	e8 f1 04 00 00       	call   104a36 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104545:	e8 a2 ff ff ff       	call   1044ec <boot_alloc_page>
  10454a:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10454f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104554:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10455b:	00 
  10455c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104563:	00 
  104564:	89 04 24             	mov    %eax,(%esp)
  104567:	e8 33 1b 00 00       	call   10609f <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10456c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104574:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10457b:	77 23                	ja     1045a0 <pmm_init+0x70>
  10457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104580:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104584:	c7 44 24 08 c4 6d 10 	movl   $0x106dc4,0x8(%esp)
  10458b:	00 
  10458c:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  104593:	00 
  104594:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10459b:	e8 31 c7 ff ff       	call   100cd1 <__panic>
  1045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a3:	05 00 00 00 40       	add    $0x40000000,%eax
  1045a8:	a3 c0 89 11 00       	mov    %eax,0x1189c0

    check_pgdir();
  1045ad:	e8 a2 04 00 00       	call   104a54 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1045b2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045b7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1045bd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045c5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1045cc:	77 23                	ja     1045f1 <pmm_init+0xc1>
  1045ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045d5:	c7 44 24 08 c4 6d 10 	movl   $0x106dc4,0x8(%esp)
  1045dc:	00 
  1045dd:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  1045e4:	00 
  1045e5:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1045ec:	e8 e0 c6 ff ff       	call   100cd1 <__panic>
  1045f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045f4:	05 00 00 00 40       	add    $0x40000000,%eax
  1045f9:	83 c8 03             	or     $0x3,%eax
  1045fc:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045fe:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104603:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10460a:	00 
  10460b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104612:	00 
  104613:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10461a:	38 
  10461b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104622:	c0 
  104623:	89 04 24             	mov    %eax,(%esp)
  104626:	e8 b4 fd ff ff       	call   1043df <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10462b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104630:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104636:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10463c:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10463e:	e8 63 fd ff ff       	call   1043a6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104643:	e8 74 f7 ff ff       	call   103dbc <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104648:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10464d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104653:	e8 97 0a 00 00       	call   1050ef <check_boot_pgdir>

    print_pgdir();
  104658:	e8 24 0f 00 00       	call   105581 <print_pgdir>

}
  10465d:	c9                   	leave  
  10465e:	c3                   	ret    

0010465f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10465f:	55                   	push   %ebp
  104660:	89 e5                	mov    %esp,%ebp
  104662:	83 ec 48             	sub    $0x48,%esp
//一级页表项
    pde_t *pdep = boot_pgdir + PDX(la);
  104665:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10466a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10466d:	c1 ea 16             	shr    $0x16,%edx
  104670:	c1 e2 02             	shl    $0x2,%edx
  104673:	01 d0                	add    %edx,%eax
  104675:	89 45 f4             	mov    %eax,-0xc(%ebp)
//    cprintf("the PDX is %d\n", PDX(la));

    pte_t *res = NULL;
  104678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    //如果里面是空的，
    if (!(*pdep))
  10467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104682:	8b 00                	mov    (%eax),%eax
  104684:	85 c0                	test   %eax,%eax
  104686:	0f 85 16 01 00 00    	jne    1047a2 <get_pte+0x143>
    {
		//如果为空的。并且需要创造一个页面
	if (create)
  10468c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104690:	0f 84 07 01 00 00    	je     10479d <get_pte+0x13e>
	{
	    //分配一个物理页面
	    struct Page *p = alloc_page();
  104696:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10469d:	e8 7e f8 ff ff       	call   103f20 <alloc_pages>
  1046a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    set_page_ref(p,1);
  1046a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046ac:	00 
  1046ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046b0:	89 04 24             	mov    %eax,(%esp)
  1046b3:	e8 4a f6 ff ff       	call   103d02 <set_page_ref>
	    //转换得到物理地址
	    pte_t pa = page2pa(p);
  1046b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046bb:	89 04 24             	mov    %eax,(%esp)
  1046be:	e8 3e f5 ff ff       	call   103c01 <page2pa>
  1046c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
//	    cprintf("the alloc page in get_pte's addr is %d\n", pa);
	    //在得到虚拟地址
	    memset(KADDR(pa), 0, PGSIZE);
  1046c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1046cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046cf:	c1 e8 0c             	shr    $0xc,%eax
  1046d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1046d5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046da:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1046dd:	72 23                	jb     104702 <get_pte+0xa3>
  1046df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046e6:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  1046ed:	00 
  1046ee:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  1046f5:	00 
  1046f6:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1046fd:	e8 cf c5 ff ff       	call   100cd1 <__panic>
  104702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104705:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10470a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104711:	00 
  104712:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104719:	00 
  10471a:	89 04 24             	mov    %eax,(%esp)
  10471d:	e8 7d 19 00 00       	call   10609f <memset>
	    //往页目录里写入第二级目录的地址，以及访问权限。
//问题1：这里面的地址是物理地址还是虚拟地址？按照前面的代码是物理地址
    	    *pdep = (pa & ~0x0FFF) | PTE_P | PTE_W | PTE_U;
  104722:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104725:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10472a:	83 c8 07             	or     $0x7,%eax
  10472d:	89 c2                	mov    %eax,%edx
  10472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104732:	89 10                	mov    %edx,(%eax)
//	    cprintf("the KADDR is %d\n", KADDR(pa));

	    //现在返回二级页表项
	    pte_t* tmp = (pte_t *)KADDR(pa);
  104734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104737:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10473a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10473d:	c1 e8 0c             	shr    $0xc,%eax
  104740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104743:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104748:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10474b:	72 23                	jb     104770 <get_pte+0x111>
  10474d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104750:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104754:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  10475b:	00 
  10475c:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
  104763:	00 
  104764:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10476b:	e8 61 c5 ff ff       	call   100cd1 <__panic>
  104770:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104773:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104778:	89 45 d4             	mov    %eax,-0x2c(%ebp)
//	    cprintf("the tmp in the get_pte is %d\n", tmp);
	    res = tmp + PTX(la);
  10477b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10477e:	c1 e8 0c             	shr    $0xc,%eax
  104781:	25 ff 03 00 00       	and    $0x3ff,%eax
  104786:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10478d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104790:	01 d0                	add    %edx,%eax
  104792:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	    cprintf("the pte addr is %d\n", res);
	    return res;			
  104795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104798:	e9 83 00 00 00       	jmp    104820 <get_pte+0x1c1>
	}
	else
	    return res;
  10479d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047a0:	eb 7e                	jmp    104820 <get_pte+0x1c1>
    }
    else
    {
	pte_t* tmp = (pte_t*)(boot_pgdir[PDX(la)] & ~0x0FFF);
  1047a2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047aa:	c1 ea 16             	shr    $0x16,%edx
  1047ad:	c1 e2 02             	shl    $0x2,%edx
  1047b0:	01 d0                	add    %edx,%eax
  1047b2:	8b 00                	mov    (%eax),%eax
  1047b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1047b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	res = tmp + PTX(la);
  1047bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047bf:	c1 e8 0c             	shr    $0xc,%eax
  1047c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  1047c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1047ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1047d1:	01 d0                	add    %edx,%eax
  1047d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
//        cprintf("the pte addr is %d\n", res);
		
        res = (pte_t*)KADDR((uintptr_t)res);
  1047d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  1047dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1047df:	c1 e8 0c             	shr    $0xc,%eax
  1047e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1047e5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1047ea:	39 45 c8             	cmp    %eax,-0x38(%ebp)
  1047ed:	72 23                	jb     104812 <get_pte+0x1b3>
  1047ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1047f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047f6:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  1047fd:	00 
  1047fe:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
  104805:	00 
  104806:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10480d:	e8 bf c4 ff ff       	call   100cd1 <__panic>
  104812:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104815:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10481a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return res;
  10481d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
}
  104820:	c9                   	leave  
  104821:	c3                   	ret    

00104822 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104822:	55                   	push   %ebp
  104823:	89 e5                	mov    %esp,%ebp
  104825:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104828:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10482f:	00 
  104830:	8b 45 0c             	mov    0xc(%ebp),%eax
  104833:	89 44 24 04          	mov    %eax,0x4(%esp)
  104837:	8b 45 08             	mov    0x8(%ebp),%eax
  10483a:	89 04 24             	mov    %eax,(%esp)
  10483d:	e8 1d fe ff ff       	call   10465f <get_pte>
  104842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104845:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104849:	74 08                	je     104853 <get_page+0x31>
        *ptep_store = ptep;
  10484b:	8b 45 10             	mov    0x10(%ebp),%eax
  10484e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104851:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104857:	74 1b                	je     104874 <get_page+0x52>
  104859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485c:	8b 00                	mov    (%eax),%eax
  10485e:	83 e0 01             	and    $0x1,%eax
  104861:	85 c0                	test   %eax,%eax
  104863:	74 0f                	je     104874 <get_page+0x52>
        return pa2page(*ptep);
  104865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104868:	8b 00                	mov    (%eax),%eax
  10486a:	89 04 24             	mov    %eax,(%esp)
  10486d:	e8 a5 f3 ff ff       	call   103c17 <pa2page>
  104872:	eb 05                	jmp    104879 <get_page+0x57>
    }
    return NULL;
  104874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104879:	c9                   	leave  
  10487a:	c3                   	ret    

0010487b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10487b:	55                   	push   %ebp
  10487c:	89 e5                	mov    %esp,%ebp
  10487e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
  104881:	8b 45 10             	mov    0x10(%ebp),%eax
  104884:	8b 00                	mov    (%eax),%eax
  104886:	83 e0 01             	and    $0x1,%eax
  104889:	85 c0                	test   %eax,%eax
  10488b:	74 4d                	je     1048da <page_remove_pte+0x5f>
	{
		struct Page* p = pte2page(*ptep);
  10488d:	8b 45 10             	mov    0x10(%ebp),%eax
  104890:	8b 00                	mov    (%eax),%eax
  104892:	89 04 24             	mov    %eax,(%esp)
  104895:	e8 20 f4 ff ff       	call   103cba <pte2page>
  10489a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (page_ref_dec(p) == 0)
  10489d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048a0:	89 04 24             	mov    %eax,(%esp)
  1048a3:	e8 7e f4 ff ff       	call   103d26 <page_ref_dec>
  1048a8:	85 c0                	test   %eax,%eax
  1048aa:	75 13                	jne    1048bf <page_remove_pte+0x44>
			free_page(p);
  1048ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1048b3:	00 
  1048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b7:	89 04 24             	mov    %eax,(%esp)
  1048ba:	e8 99 f6 ff ff       	call   103f58 <free_pages>
		//清空
		*ptep = 0;
  1048bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1048c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		tlb_invalidate(pgdir, la);
  1048c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d2:	89 04 24             	mov    %eax,(%esp)
  1048d5:	e8 ff 00 00 00       	call   1049d9 <tlb_invalidate>
		
	}
}
  1048da:	c9                   	leave  
  1048db:	c3                   	ret    

001048dc <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1048dc:	55                   	push   %ebp
  1048dd:	89 e5                	mov    %esp,%ebp
  1048df:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1048e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048e9:	00 
  1048ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f4:	89 04 24             	mov    %eax,(%esp)
  1048f7:	e8 63 fd ff ff       	call   10465f <get_pte>
  1048fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1048ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104903:	74 19                	je     10491e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104908:	89 44 24 08          	mov    %eax,0x8(%esp)
  10490c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10490f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104913:	8b 45 08             	mov    0x8(%ebp),%eax
  104916:	89 04 24             	mov    %eax,(%esp)
  104919:	e8 5d ff ff ff       	call   10487b <page_remove_pte>
    }
}
  10491e:	c9                   	leave  
  10491f:	c3                   	ret    

00104920 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104920:	55                   	push   %ebp
  104921:	89 e5                	mov    %esp,%ebp
  104923:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104926:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10492d:	00 
  10492e:	8b 45 10             	mov    0x10(%ebp),%eax
  104931:	89 44 24 04          	mov    %eax,0x4(%esp)
  104935:	8b 45 08             	mov    0x8(%ebp),%eax
  104938:	89 04 24             	mov    %eax,(%esp)
  10493b:	e8 1f fd ff ff       	call   10465f <get_pte>
  104940:	89 45 f4             	mov    %eax,-0xc(%ebp)
//    cprintf("the ptep in insert is %d\n", ptep);
    if (ptep == NULL) {
  104943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104947:	75 0a                	jne    104953 <page_insert+0x33>
//	cprintf("what the fuck\n");
        return -E_NO_MEM;
  104949:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10494e:	e9 84 00 00 00       	jmp    1049d7 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104953:	8b 45 0c             	mov    0xc(%ebp),%eax
  104956:	89 04 24             	mov    %eax,(%esp)
  104959:	e8 b1 f3 ff ff       	call   103d0f <page_ref_inc>
    if (*ptep & PTE_P) {
  10495e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104961:	8b 00                	mov    (%eax),%eax
  104963:	83 e0 01             	and    $0x1,%eax
  104966:	85 c0                	test   %eax,%eax
  104968:	74 3e                	je     1049a8 <page_insert+0x88>
//	cprintf("NO Way\n");
        struct Page *p = pte2page(*ptep);
  10496a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10496d:	8b 00                	mov    (%eax),%eax
  10496f:	89 04 24             	mov    %eax,(%esp)
  104972:	e8 43 f3 ff ff       	call   103cba <pte2page>
  104977:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10497a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10497d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104980:	75 0d                	jne    10498f <page_insert+0x6f>
            page_ref_dec(page);
  104982:	8b 45 0c             	mov    0xc(%ebp),%eax
  104985:	89 04 24             	mov    %eax,(%esp)
  104988:	e8 99 f3 ff ff       	call   103d26 <page_ref_dec>
  10498d:	eb 19                	jmp    1049a8 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10498f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104992:	89 44 24 08          	mov    %eax,0x8(%esp)
  104996:	8b 45 10             	mov    0x10(%ebp),%eax
  104999:	89 44 24 04          	mov    %eax,0x4(%esp)
  10499d:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a0:	89 04 24             	mov    %eax,(%esp)
  1049a3:	e8 d3 fe ff ff       	call   10487b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1049a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049ab:	89 04 24             	mov    %eax,(%esp)
  1049ae:	e8 4e f2 ff ff       	call   103c01 <page2pa>
  1049b3:	0b 45 14             	or     0x14(%ebp),%eax
  1049b6:	83 c8 01             	or     $0x1,%eax
  1049b9:	89 c2                	mov    %eax,%edx
  1049bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049be:	89 10                	mov    %edx,(%eax)
//    cprintf("*ptep is %d\n", *ptep);
    tlb_invalidate(pgdir, la);
  1049c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1049c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1049ca:	89 04 24             	mov    %eax,(%esp)
  1049cd:	e8 07 00 00 00       	call   1049d9 <tlb_invalidate>
    return 0;
  1049d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1049d7:	c9                   	leave  
  1049d8:	c3                   	ret    

001049d9 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1049d9:	55                   	push   %ebp
  1049da:	89 e5                	mov    %esp,%ebp
  1049dc:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1049df:	0f 20 d8             	mov    %cr3,%eax
  1049e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1049e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1049e8:	89 c2                	mov    %eax,%edx
  1049ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1049ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1049f0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1049f7:	77 23                	ja     104a1c <tlb_invalidate+0x43>
  1049f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a00:	c7 44 24 08 c4 6d 10 	movl   $0x106dc4,0x8(%esp)
  104a07:	00 
  104a08:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104a0f:	00 
  104a10:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104a17:	e8 b5 c2 ff ff       	call   100cd1 <__panic>
  104a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a1f:	05 00 00 00 40       	add    $0x40000000,%eax
  104a24:	39 c2                	cmp    %eax,%edx
  104a26:	75 0c                	jne    104a34 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a31:	0f 01 38             	invlpg (%eax)
    }
}
  104a34:	c9                   	leave  
  104a35:	c3                   	ret    

00104a36 <check_alloc_page>:

static void
check_alloc_page(void) {
  104a36:	55                   	push   %ebp
  104a37:	89 e5                	mov    %esp,%ebp
  104a39:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104a3c:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104a41:	8b 40 18             	mov    0x18(%eax),%eax
  104a44:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104a46:	c7 04 24 3c 6e 10 00 	movl   $0x106e3c,(%esp)
  104a4d:	e8 f5 b8 ff ff       	call   100347 <cprintf>
}
  104a52:	c9                   	leave  
  104a53:	c3                   	ret    

00104a54 <check_pgdir>:

static void
check_pgdir(void) {
  104a54:	55                   	push   %ebp
  104a55:	89 e5                	mov    %esp,%ebp
  104a57:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104a5a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104a5f:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104a64:	76 24                	jbe    104a8a <check_pgdir+0x36>
  104a66:	c7 44 24 0c 5b 6e 10 	movl   $0x106e5b,0xc(%esp)
  104a6d:	00 
  104a6e:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104a75:	00 
  104a76:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104a7d:	00 
  104a7e:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104a85:	e8 47 c2 ff ff       	call   100cd1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104a8a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a8f:	85 c0                	test   %eax,%eax
  104a91:	74 0e                	je     104aa1 <check_pgdir+0x4d>
  104a93:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a98:	25 ff 0f 00 00       	and    $0xfff,%eax
  104a9d:	85 c0                	test   %eax,%eax
  104a9f:	74 24                	je     104ac5 <check_pgdir+0x71>
  104aa1:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104aa8:	00 
  104aa9:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104ab0:	00 
  104ab1:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104ab8:	00 
  104ab9:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104ac0:	e8 0c c2 ff ff       	call   100cd1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104ac5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ad1:	00 
  104ad2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ad9:	00 
  104ada:	89 04 24             	mov    %eax,(%esp)
  104add:	e8 40 fd ff ff       	call   104822 <get_page>
  104ae2:	85 c0                	test   %eax,%eax
  104ae4:	74 24                	je     104b0a <check_pgdir+0xb6>
  104ae6:	c7 44 24 0c b0 6e 10 	movl   $0x106eb0,0xc(%esp)
  104aed:	00 
  104aee:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104af5:	00 
  104af6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104afd:	00 
  104afe:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104b05:	e8 c7 c1 ff ff       	call   100cd1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b11:	e8 0a f4 ff ff       	call   103f20 <alloc_pages>
  104b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
//    cprintf("the p1 is %d\n", page2pa(p1));
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104b19:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b1e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b25:	00 
  104b26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b2d:	00 
  104b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b35:	89 04 24             	mov    %eax,(%esp)
  104b38:	e8 e3 fd ff ff       	call   104920 <page_insert>
  104b3d:	85 c0                	test   %eax,%eax
  104b3f:	74 24                	je     104b65 <check_pgdir+0x111>
  104b41:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104b48:	00 
  104b49:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104b50:	00 
  104b51:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104b58:	00 
  104b59:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104b60:	e8 6c c1 ff ff       	call   100cd1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104b65:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b71:	00 
  104b72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b79:	00 
  104b7a:	89 04 24             	mov    %eax,(%esp)
  104b7d:	e8 dd fa ff ff       	call   10465f <get_pte>
  104b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b89:	75 24                	jne    104baf <check_pgdir+0x15b>
  104b8b:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  104b92:	00 
  104b93:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104b9a:	00 
  104b9b:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104ba2:	00 
  104ba3:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104baa:	e8 22 c1 ff ff       	call   100cd1 <__panic>
//    cprintf("the *ptep is %d in check\n", *ptep);
    assert(pa2page(*ptep) == p1);
  104baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bb2:	8b 00                	mov    (%eax),%eax
  104bb4:	89 04 24             	mov    %eax,(%esp)
  104bb7:	e8 5b f0 ff ff       	call   103c17 <pa2page>
  104bbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104bbf:	74 24                	je     104be5 <check_pgdir+0x191>
  104bc1:	c7 44 24 0c 31 6f 10 	movl   $0x106f31,0xc(%esp)
  104bc8:	00 
  104bc9:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104bd0:	00 
  104bd1:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104bd8:	00 
  104bd9:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104be0:	e8 ec c0 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p1) == 1);
  104be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be8:	89 04 24             	mov    %eax,(%esp)
  104beb:	e8 08 f1 ff ff       	call   103cf8 <page_ref>
  104bf0:	83 f8 01             	cmp    $0x1,%eax
  104bf3:	74 24                	je     104c19 <check_pgdir+0x1c5>
  104bf5:	c7 44 24 0c 46 6f 10 	movl   $0x106f46,0xc(%esp)
  104bfc:	00 
  104bfd:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104c04:	00 
  104c05:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104c0c:	00 
  104c0d:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104c14:	e8 b8 c0 ff ff       	call   100cd1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104c19:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c1e:	8b 00                	mov    (%eax),%eax
  104c20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c2b:	c1 e8 0c             	shr    $0xc,%eax
  104c2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104c31:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104c36:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104c39:	72 23                	jb     104c5e <check_pgdir+0x20a>
  104c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104c42:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  104c49:	00 
  104c4a:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104c51:	00 
  104c52:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104c59:	e8 73 c0 ff ff       	call   100cd1 <__panic>
  104c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c61:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104c66:	83 c0 04             	add    $0x4,%eax
  104c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104c6c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c71:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c78:	00 
  104c79:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c80:	00 
  104c81:	89 04 24             	mov    %eax,(%esp)
  104c84:	e8 d6 f9 ff ff       	call   10465f <get_pte>
  104c89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104c8c:	74 24                	je     104cb2 <check_pgdir+0x25e>
  104c8e:	c7 44 24 0c 58 6f 10 	movl   $0x106f58,0xc(%esp)
  104c95:	00 
  104c96:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104c9d:	00 
  104c9e:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104ca5:	00 
  104ca6:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104cad:	e8 1f c0 ff ff       	call   100cd1 <__panic>

    p2 = alloc_page();
  104cb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cb9:	e8 62 f2 ff ff       	call   103f20 <alloc_pages>
  104cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104cc1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cc6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104ccd:	00 
  104cce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104cd5:	00 
  104cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104cd9:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cdd:	89 04 24             	mov    %eax,(%esp)
  104ce0:	e8 3b fc ff ff       	call   104920 <page_insert>
  104ce5:	85 c0                	test   %eax,%eax
  104ce7:	74 24                	je     104d0d <check_pgdir+0x2b9>
  104ce9:	c7 44 24 0c 80 6f 10 	movl   $0x106f80,0xc(%esp)
  104cf0:	00 
  104cf1:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104cf8:	00 
  104cf9:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104d00:	00 
  104d01:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104d08:	e8 c4 bf ff ff       	call   100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104d0d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d19:	00 
  104d1a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d21:	00 
  104d22:	89 04 24             	mov    %eax,(%esp)
  104d25:	e8 35 f9 ff ff       	call   10465f <get_pte>
  104d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d31:	75 24                	jne    104d57 <check_pgdir+0x303>
  104d33:	c7 44 24 0c b8 6f 10 	movl   $0x106fb8,0xc(%esp)
  104d3a:	00 
  104d3b:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104d42:	00 
  104d43:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104d4a:	00 
  104d4b:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104d52:	e8 7a bf ff ff       	call   100cd1 <__panic>
    assert(*ptep & PTE_U);
  104d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d5a:	8b 00                	mov    (%eax),%eax
  104d5c:	83 e0 04             	and    $0x4,%eax
  104d5f:	85 c0                	test   %eax,%eax
  104d61:	75 24                	jne    104d87 <check_pgdir+0x333>
  104d63:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  104d6a:	00 
  104d6b:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104d72:	00 
  104d73:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d7a:	00 
  104d7b:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104d82:	e8 4a bf ff ff       	call   100cd1 <__panic>
    assert(*ptep & PTE_W);
  104d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d8a:	8b 00                	mov    (%eax),%eax
  104d8c:	83 e0 02             	and    $0x2,%eax
  104d8f:	85 c0                	test   %eax,%eax
  104d91:	75 24                	jne    104db7 <check_pgdir+0x363>
  104d93:	c7 44 24 0c f6 6f 10 	movl   $0x106ff6,0xc(%esp)
  104d9a:	00 
  104d9b:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104da2:	00 
  104da3:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104daa:	00 
  104dab:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104db2:	e8 1a bf ff ff       	call   100cd1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104db7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dbc:	8b 00                	mov    (%eax),%eax
  104dbe:	83 e0 04             	and    $0x4,%eax
  104dc1:	85 c0                	test   %eax,%eax
  104dc3:	75 24                	jne    104de9 <check_pgdir+0x395>
  104dc5:	c7 44 24 0c 04 70 10 	movl   $0x107004,0xc(%esp)
  104dcc:	00 
  104dcd:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104dd4:	00 
  104dd5:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104ddc:	00 
  104ddd:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104de4:	e8 e8 be ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 1);
  104de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dec:	89 04 24             	mov    %eax,(%esp)
  104def:	e8 04 ef ff ff       	call   103cf8 <page_ref>
  104df4:	83 f8 01             	cmp    $0x1,%eax
  104df7:	74 24                	je     104e1d <check_pgdir+0x3c9>
  104df9:	c7 44 24 0c 1a 70 10 	movl   $0x10701a,0xc(%esp)
  104e00:	00 
  104e01:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104e08:	00 
  104e09:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104e10:	00 
  104e11:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104e18:	e8 b4 be ff ff       	call   100cd1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104e1d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e22:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104e29:	00 
  104e2a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104e31:	00 
  104e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e35:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e39:	89 04 24             	mov    %eax,(%esp)
  104e3c:	e8 df fa ff ff       	call   104920 <page_insert>
  104e41:	85 c0                	test   %eax,%eax
  104e43:	74 24                	je     104e69 <check_pgdir+0x415>
  104e45:	c7 44 24 0c 2c 70 10 	movl   $0x10702c,0xc(%esp)
  104e4c:	00 
  104e4d:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104e54:	00 
  104e55:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104e5c:	00 
  104e5d:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104e64:	e8 68 be ff ff       	call   100cd1 <__panic>
    assert(page_ref(p1) == 2);
  104e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e6c:	89 04 24             	mov    %eax,(%esp)
  104e6f:	e8 84 ee ff ff       	call   103cf8 <page_ref>
  104e74:	83 f8 02             	cmp    $0x2,%eax
  104e77:	74 24                	je     104e9d <check_pgdir+0x449>
  104e79:	c7 44 24 0c 58 70 10 	movl   $0x107058,0xc(%esp)
  104e80:	00 
  104e81:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104e88:	00 
  104e89:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104e90:	00 
  104e91:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104e98:	e8 34 be ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  104e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ea0:	89 04 24             	mov    %eax,(%esp)
  104ea3:	e8 50 ee ff ff       	call   103cf8 <page_ref>
  104ea8:	85 c0                	test   %eax,%eax
  104eaa:	74 24                	je     104ed0 <check_pgdir+0x47c>
  104eac:	c7 44 24 0c 6a 70 10 	movl   $0x10706a,0xc(%esp)
  104eb3:	00 
  104eb4:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104ebb:	00 
  104ebc:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104ec3:	00 
  104ec4:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104ecb:	e8 01 be ff ff       	call   100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ed0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ed5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104edc:	00 
  104edd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ee4:	00 
  104ee5:	89 04 24             	mov    %eax,(%esp)
  104ee8:	e8 72 f7 ff ff       	call   10465f <get_pte>
  104eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ef4:	75 24                	jne    104f1a <check_pgdir+0x4c6>
  104ef6:	c7 44 24 0c b8 6f 10 	movl   $0x106fb8,0xc(%esp)
  104efd:	00 
  104efe:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104f05:	00 
  104f06:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104f0d:	00 
  104f0e:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104f15:	e8 b7 bd ff ff       	call   100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
  104f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f1d:	8b 00                	mov    (%eax),%eax
  104f1f:	89 04 24             	mov    %eax,(%esp)
  104f22:	e8 f0 ec ff ff       	call   103c17 <pa2page>
  104f27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f2a:	74 24                	je     104f50 <check_pgdir+0x4fc>
  104f2c:	c7 44 24 0c 31 6f 10 	movl   $0x106f31,0xc(%esp)
  104f33:	00 
  104f34:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104f3b:	00 
  104f3c:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104f43:	00 
  104f44:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104f4b:	e8 81 bd ff ff       	call   100cd1 <__panic>
    assert((*ptep & PTE_U) == 0);
  104f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f53:	8b 00                	mov    (%eax),%eax
  104f55:	83 e0 04             	and    $0x4,%eax
  104f58:	85 c0                	test   %eax,%eax
  104f5a:	74 24                	je     104f80 <check_pgdir+0x52c>
  104f5c:	c7 44 24 0c 7c 70 10 	movl   $0x10707c,0xc(%esp)
  104f63:	00 
  104f64:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104f6b:	00 
  104f6c:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104f73:	00 
  104f74:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104f7b:	e8 51 bd ff ff       	call   100cd1 <__panic>

    page_remove(boot_pgdir, 0x0);
  104f80:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f8c:	00 
  104f8d:	89 04 24             	mov    %eax,(%esp)
  104f90:	e8 47 f9 ff ff       	call   1048dc <page_remove>
    assert(page_ref(p1) == 1);
  104f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f98:	89 04 24             	mov    %eax,(%esp)
  104f9b:	e8 58 ed ff ff       	call   103cf8 <page_ref>
  104fa0:	83 f8 01             	cmp    $0x1,%eax
  104fa3:	74 24                	je     104fc9 <check_pgdir+0x575>
  104fa5:	c7 44 24 0c 46 6f 10 	movl   $0x106f46,0xc(%esp)
  104fac:	00 
  104fad:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104fb4:	00 
  104fb5:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104fbc:	00 
  104fbd:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104fc4:	e8 08 bd ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  104fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fcc:	89 04 24             	mov    %eax,(%esp)
  104fcf:	e8 24 ed ff ff       	call   103cf8 <page_ref>
  104fd4:	85 c0                	test   %eax,%eax
  104fd6:	74 24                	je     104ffc <check_pgdir+0x5a8>
  104fd8:	c7 44 24 0c 6a 70 10 	movl   $0x10706a,0xc(%esp)
  104fdf:	00 
  104fe0:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  104fe7:	00 
  104fe8:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104fef:	00 
  104ff0:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  104ff7:	e8 d5 bc ff ff       	call   100cd1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104ffc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105001:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105008:	00 
  105009:	89 04 24             	mov    %eax,(%esp)
  10500c:	e8 cb f8 ff ff       	call   1048dc <page_remove>
    assert(page_ref(p1) == 0);
  105011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105014:	89 04 24             	mov    %eax,(%esp)
  105017:	e8 dc ec ff ff       	call   103cf8 <page_ref>
  10501c:	85 c0                	test   %eax,%eax
  10501e:	74 24                	je     105044 <check_pgdir+0x5f0>
  105020:	c7 44 24 0c 91 70 10 	movl   $0x107091,0xc(%esp)
  105027:	00 
  105028:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  10502f:	00 
  105030:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  105037:	00 
  105038:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10503f:	e8 8d bc ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  105044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105047:	89 04 24             	mov    %eax,(%esp)
  10504a:	e8 a9 ec ff ff       	call   103cf8 <page_ref>
  10504f:	85 c0                	test   %eax,%eax
  105051:	74 24                	je     105077 <check_pgdir+0x623>
  105053:	c7 44 24 0c 6a 70 10 	movl   $0x10706a,0xc(%esp)
  10505a:	00 
  10505b:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  105062:	00 
  105063:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  10506a:	00 
  10506b:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  105072:	e8 5a bc ff ff       	call   100cd1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  105077:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10507c:	8b 00                	mov    (%eax),%eax
  10507e:	89 04 24             	mov    %eax,(%esp)
  105081:	e8 91 eb ff ff       	call   103c17 <pa2page>
  105086:	89 04 24             	mov    %eax,(%esp)
  105089:	e8 6a ec ff ff       	call   103cf8 <page_ref>
  10508e:	83 f8 01             	cmp    $0x1,%eax
  105091:	74 24                	je     1050b7 <check_pgdir+0x663>
  105093:	c7 44 24 0c a4 70 10 	movl   $0x1070a4,0xc(%esp)
  10509a:	00 
  10509b:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  1050a2:	00 
  1050a3:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  1050aa:	00 
  1050ab:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1050b2:	e8 1a bc ff ff       	call   100cd1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  1050b7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050bc:	8b 00                	mov    (%eax),%eax
  1050be:	89 04 24             	mov    %eax,(%esp)
  1050c1:	e8 51 eb ff ff       	call   103c17 <pa2page>
  1050c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050cd:	00 
  1050ce:	89 04 24             	mov    %eax,(%esp)
  1050d1:	e8 82 ee ff ff       	call   103f58 <free_pages>
    boot_pgdir[0] = 0;
  1050d6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1050e1:	c7 04 24 ca 70 10 00 	movl   $0x1070ca,(%esp)
  1050e8:	e8 5a b2 ff ff       	call   100347 <cprintf>
}
  1050ed:	c9                   	leave  
  1050ee:	c3                   	ret    

001050ef <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1050ef:	55                   	push   %ebp
  1050f0:	89 e5                	mov    %esp,%ebp
  1050f2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1050f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1050fc:	e9 ca 00 00 00       	jmp    1051cb <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105104:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10510a:	c1 e8 0c             	shr    $0xc,%eax
  10510d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105110:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  105115:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105118:	72 23                	jb     10513d <check_boot_pgdir+0x4e>
  10511a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10511d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105121:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  105128:	00 
  105129:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  105130:	00 
  105131:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  105138:	e8 94 bb ff ff       	call   100cd1 <__panic>
  10513d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105140:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105145:	89 c2                	mov    %eax,%edx
  105147:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10514c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105153:	00 
  105154:	89 54 24 04          	mov    %edx,0x4(%esp)
  105158:	89 04 24             	mov    %eax,(%esp)
  10515b:	e8 ff f4 ff ff       	call   10465f <get_pte>
  105160:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105163:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105167:	75 24                	jne    10518d <check_boot_pgdir+0x9e>
  105169:	c7 44 24 0c e4 70 10 	movl   $0x1070e4,0xc(%esp)
  105170:	00 
  105171:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  105178:	00 
  105179:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  105180:	00 
  105181:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  105188:	e8 44 bb ff ff       	call   100cd1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10518d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105190:	8b 00                	mov    (%eax),%eax
  105192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105197:	89 c2                	mov    %eax,%edx
  105199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10519c:	39 c2                	cmp    %eax,%edx
  10519e:	74 24                	je     1051c4 <check_boot_pgdir+0xd5>
  1051a0:	c7 44 24 0c 21 71 10 	movl   $0x107121,0xc(%esp)
  1051a7:	00 
  1051a8:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  1051af:	00 
  1051b0:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  1051b7:	00 
  1051b8:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1051bf:	e8 0d bb ff ff       	call   100cd1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1051c4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1051cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1051ce:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1051d3:	39 c2                	cmp    %eax,%edx
  1051d5:	0f 82 26 ff ff ff    	jb     105101 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1051db:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051e0:	05 ac 0f 00 00       	add    $0xfac,%eax
  1051e5:	8b 00                	mov    (%eax),%eax
  1051e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1051ec:	89 c2                	mov    %eax,%edx
  1051ee:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1051f6:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1051fd:	77 23                	ja     105222 <check_boot_pgdir+0x133>
  1051ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105202:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105206:	c7 44 24 08 c4 6d 10 	movl   $0x106dc4,0x8(%esp)
  10520d:	00 
  10520e:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105215:	00 
  105216:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10521d:	e8 af ba ff ff       	call   100cd1 <__panic>
  105222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105225:	05 00 00 00 40       	add    $0x40000000,%eax
  10522a:	39 c2                	cmp    %eax,%edx
  10522c:	74 24                	je     105252 <check_boot_pgdir+0x163>
  10522e:	c7 44 24 0c 38 71 10 	movl   $0x107138,0xc(%esp)
  105235:	00 
  105236:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  10523d:	00 
  10523e:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105245:	00 
  105246:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10524d:	e8 7f ba ff ff       	call   100cd1 <__panic>

    assert(boot_pgdir[0] == 0);
  105252:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105257:	8b 00                	mov    (%eax),%eax
  105259:	85 c0                	test   %eax,%eax
  10525b:	74 24                	je     105281 <check_boot_pgdir+0x192>
  10525d:	c7 44 24 0c 6c 71 10 	movl   $0x10716c,0xc(%esp)
  105264:	00 
  105265:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  10526c:	00 
  10526d:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  105274:	00 
  105275:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10527c:	e8 50 ba ff ff       	call   100cd1 <__panic>

    struct Page *p;
    p = alloc_page();
  105281:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105288:	e8 93 ec ff ff       	call   103f20 <alloc_pages>
  10528d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105290:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105295:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10529c:	00 
  10529d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1052a4:	00 
  1052a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052ac:	89 04 24             	mov    %eax,(%esp)
  1052af:	e8 6c f6 ff ff       	call   104920 <page_insert>
  1052b4:	85 c0                	test   %eax,%eax
  1052b6:	74 24                	je     1052dc <check_boot_pgdir+0x1ed>
  1052b8:	c7 44 24 0c 80 71 10 	movl   $0x107180,0xc(%esp)
  1052bf:	00 
  1052c0:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  1052c7:	00 
  1052c8:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  1052cf:	00 
  1052d0:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1052d7:	e8 f5 b9 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p) == 1);
  1052dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052df:	89 04 24             	mov    %eax,(%esp)
  1052e2:	e8 11 ea ff ff       	call   103cf8 <page_ref>
  1052e7:	83 f8 01             	cmp    $0x1,%eax
  1052ea:	74 24                	je     105310 <check_boot_pgdir+0x221>
  1052ec:	c7 44 24 0c ae 71 10 	movl   $0x1071ae,0xc(%esp)
  1052f3:	00 
  1052f4:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  1052fb:	00 
  1052fc:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  105303:	00 
  105304:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10530b:	e8 c1 b9 ff ff       	call   100cd1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105310:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105315:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10531c:	00 
  10531d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105324:	00 
  105325:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105328:	89 54 24 04          	mov    %edx,0x4(%esp)
  10532c:	89 04 24             	mov    %eax,(%esp)
  10532f:	e8 ec f5 ff ff       	call   104920 <page_insert>
  105334:	85 c0                	test   %eax,%eax
  105336:	74 24                	je     10535c <check_boot_pgdir+0x26d>
  105338:	c7 44 24 0c c0 71 10 	movl   $0x1071c0,0xc(%esp)
  10533f:	00 
  105340:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  105347:	00 
  105348:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
  10534f:	00 
  105350:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  105357:	e8 75 b9 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p) == 2);
  10535c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10535f:	89 04 24             	mov    %eax,(%esp)
  105362:	e8 91 e9 ff ff       	call   103cf8 <page_ref>
  105367:	83 f8 02             	cmp    $0x2,%eax
  10536a:	74 24                	je     105390 <check_boot_pgdir+0x2a1>
  10536c:	c7 44 24 0c f7 71 10 	movl   $0x1071f7,0xc(%esp)
  105373:	00 
  105374:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  10537b:	00 
  10537c:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  105383:	00 
  105384:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  10538b:	e8 41 b9 ff ff       	call   100cd1 <__panic>

    const char *str = "ucore: Hello world!!";
  105390:	c7 45 dc 08 72 10 00 	movl   $0x107208,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105397:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10539a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10539e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1053a5:	e8 1e 0a 00 00       	call   105dc8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1053aa:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1053b1:	00 
  1053b2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1053b9:	e8 83 0a 00 00       	call   105e41 <strcmp>
  1053be:	85 c0                	test   %eax,%eax
  1053c0:	74 24                	je     1053e6 <check_boot_pgdir+0x2f7>
  1053c2:	c7 44 24 0c 20 72 10 	movl   $0x107220,0xc(%esp)
  1053c9:	00 
  1053ca:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  1053d1:	00 
  1053d2:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
  1053d9:	00 
  1053da:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  1053e1:	e8 eb b8 ff ff       	call   100cd1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1053e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053e9:	89 04 24             	mov    %eax,(%esp)
  1053ec:	e8 75 e8 ff ff       	call   103c66 <page2kva>
  1053f1:	05 00 01 00 00       	add    $0x100,%eax
  1053f6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1053f9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105400:	e8 6b 09 00 00       	call   105d70 <strlen>
  105405:	85 c0                	test   %eax,%eax
  105407:	74 24                	je     10542d <check_boot_pgdir+0x33e>
  105409:	c7 44 24 0c 58 72 10 	movl   $0x107258,0xc(%esp)
  105410:	00 
  105411:	c7 44 24 08 ff 6d 10 	movl   $0x106dff,0x8(%esp)
  105418:	00 
  105419:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
  105420:	00 
  105421:	c7 04 24 67 6d 10 00 	movl   $0x106d67,(%esp)
  105428:	e8 a4 b8 ff ff       	call   100cd1 <__panic>

    free_page(p);
  10542d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105434:	00 
  105435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105438:	89 04 24             	mov    %eax,(%esp)
  10543b:	e8 18 eb ff ff       	call   103f58 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105440:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105445:	8b 00                	mov    (%eax),%eax
  105447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10544c:	89 04 24             	mov    %eax,(%esp)
  10544f:	e8 c3 e7 ff ff       	call   103c17 <pa2page>
  105454:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10545b:	00 
  10545c:	89 04 24             	mov    %eax,(%esp)
  10545f:	e8 f4 ea ff ff       	call   103f58 <free_pages>
    boot_pgdir[0] = 0;
  105464:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10546f:	c7 04 24 7c 72 10 00 	movl   $0x10727c,(%esp)
  105476:	e8 cc ae ff ff       	call   100347 <cprintf>
}
  10547b:	c9                   	leave  
  10547c:	c3                   	ret    

0010547d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10547d:	55                   	push   %ebp
  10547e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105480:	8b 45 08             	mov    0x8(%ebp),%eax
  105483:	83 e0 04             	and    $0x4,%eax
  105486:	85 c0                	test   %eax,%eax
  105488:	74 07                	je     105491 <perm2str+0x14>
  10548a:	b8 75 00 00 00       	mov    $0x75,%eax
  10548f:	eb 05                	jmp    105496 <perm2str+0x19>
  105491:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105496:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  10549b:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1054a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a5:	83 e0 02             	and    $0x2,%eax
  1054a8:	85 c0                	test   %eax,%eax
  1054aa:	74 07                	je     1054b3 <perm2str+0x36>
  1054ac:	b8 77 00 00 00       	mov    $0x77,%eax
  1054b1:	eb 05                	jmp    1054b8 <perm2str+0x3b>
  1054b3:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1054b8:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1054bd:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1054c4:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1054c9:	5d                   	pop    %ebp
  1054ca:	c3                   	ret    

001054cb <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1054cb:	55                   	push   %ebp
  1054cc:	89 e5                	mov    %esp,%ebp
  1054ce:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1054d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1054d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054d7:	72 0a                	jb     1054e3 <get_pgtable_items+0x18>
        return 0;
  1054d9:	b8 00 00 00 00       	mov    $0x0,%eax
  1054de:	e9 9c 00 00 00       	jmp    10557f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1054e3:	eb 04                	jmp    1054e9 <get_pgtable_items+0x1e>
        start ++;
  1054e5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1054e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1054ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054ef:	73 18                	jae    105509 <get_pgtable_items+0x3e>
  1054f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1054f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1054fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1054fe:	01 d0                	add    %edx,%eax
  105500:	8b 00                	mov    (%eax),%eax
  105502:	83 e0 01             	and    $0x1,%eax
  105505:	85 c0                	test   %eax,%eax
  105507:	74 dc                	je     1054e5 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105509:	8b 45 10             	mov    0x10(%ebp),%eax
  10550c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10550f:	73 69                	jae    10557a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105511:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105515:	74 08                	je     10551f <get_pgtable_items+0x54>
            *left_store = start;
  105517:	8b 45 18             	mov    0x18(%ebp),%eax
  10551a:	8b 55 10             	mov    0x10(%ebp),%edx
  10551d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10551f:	8b 45 10             	mov    0x10(%ebp),%eax
  105522:	8d 50 01             	lea    0x1(%eax),%edx
  105525:	89 55 10             	mov    %edx,0x10(%ebp)
  105528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10552f:	8b 45 14             	mov    0x14(%ebp),%eax
  105532:	01 d0                	add    %edx,%eax
  105534:	8b 00                	mov    (%eax),%eax
  105536:	83 e0 07             	and    $0x7,%eax
  105539:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10553c:	eb 04                	jmp    105542 <get_pgtable_items+0x77>
            start ++;
  10553e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105542:	8b 45 10             	mov    0x10(%ebp),%eax
  105545:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105548:	73 1d                	jae    105567 <get_pgtable_items+0x9c>
  10554a:	8b 45 10             	mov    0x10(%ebp),%eax
  10554d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105554:	8b 45 14             	mov    0x14(%ebp),%eax
  105557:	01 d0                	add    %edx,%eax
  105559:	8b 00                	mov    (%eax),%eax
  10555b:	83 e0 07             	and    $0x7,%eax
  10555e:	89 c2                	mov    %eax,%edx
  105560:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105563:	39 c2                	cmp    %eax,%edx
  105565:	74 d7                	je     10553e <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105567:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10556b:	74 08                	je     105575 <get_pgtable_items+0xaa>
            *right_store = start;
  10556d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105570:	8b 55 10             	mov    0x10(%ebp),%edx
  105573:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105575:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105578:	eb 05                	jmp    10557f <get_pgtable_items+0xb4>
    }
    return 0;
  10557a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10557f:	c9                   	leave  
  105580:	c3                   	ret    

00105581 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105581:	55                   	push   %ebp
  105582:	89 e5                	mov    %esp,%ebp
  105584:	57                   	push   %edi
  105585:	56                   	push   %esi
  105586:	53                   	push   %ebx
  105587:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10558a:	c7 04 24 9c 72 10 00 	movl   $0x10729c,(%esp)
  105591:	e8 b1 ad ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
  105596:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10559d:	e9 fa 00 00 00       	jmp    10569c <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1055a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055a5:	89 04 24             	mov    %eax,(%esp)
  1055a8:	e8 d0 fe ff ff       	call   10547d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1055ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1055b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1055b3:	29 d1                	sub    %edx,%ecx
  1055b5:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1055b7:	89 d6                	mov    %edx,%esi
  1055b9:	c1 e6 16             	shl    $0x16,%esi
  1055bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1055bf:	89 d3                	mov    %edx,%ebx
  1055c1:	c1 e3 16             	shl    $0x16,%ebx
  1055c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1055c7:	89 d1                	mov    %edx,%ecx
  1055c9:	c1 e1 16             	shl    $0x16,%ecx
  1055cc:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1055cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1055d2:	29 d7                	sub    %edx,%edi
  1055d4:	89 fa                	mov    %edi,%edx
  1055d6:	89 44 24 14          	mov    %eax,0x14(%esp)
  1055da:	89 74 24 10          	mov    %esi,0x10(%esp)
  1055de:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1055e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055ea:	c7 04 24 cd 72 10 00 	movl   $0x1072cd,(%esp)
  1055f1:	e8 51 ad ff ff       	call   100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1055f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055f9:	c1 e0 0a             	shl    $0xa,%eax
  1055fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1055ff:	eb 54                	jmp    105655 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105604:	89 04 24             	mov    %eax,(%esp)
  105607:	e8 71 fe ff ff       	call   10547d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10560c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10560f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105612:	29 d1                	sub    %edx,%ecx
  105614:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105616:	89 d6                	mov    %edx,%esi
  105618:	c1 e6 0c             	shl    $0xc,%esi
  10561b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10561e:	89 d3                	mov    %edx,%ebx
  105620:	c1 e3 0c             	shl    $0xc,%ebx
  105623:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105626:	c1 e2 0c             	shl    $0xc,%edx
  105629:	89 d1                	mov    %edx,%ecx
  10562b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10562e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105631:	29 d7                	sub    %edx,%edi
  105633:	89 fa                	mov    %edi,%edx
  105635:	89 44 24 14          	mov    %eax,0x14(%esp)
  105639:	89 74 24 10          	mov    %esi,0x10(%esp)
  10563d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105641:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105645:	89 54 24 04          	mov    %edx,0x4(%esp)
  105649:	c7 04 24 ec 72 10 00 	movl   $0x1072ec,(%esp)
  105650:	e8 f2 ac ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105655:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10565a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10565d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105660:	89 ce                	mov    %ecx,%esi
  105662:	c1 e6 0a             	shl    $0xa,%esi
  105665:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105668:	89 cb                	mov    %ecx,%ebx
  10566a:	c1 e3 0a             	shl    $0xa,%ebx
  10566d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105670:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105674:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105677:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10567b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10567f:	89 44 24 08          	mov    %eax,0x8(%esp)
  105683:	89 74 24 04          	mov    %esi,0x4(%esp)
  105687:	89 1c 24             	mov    %ebx,(%esp)
  10568a:	e8 3c fe ff ff       	call   1054cb <get_pgtable_items>
  10568f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105696:	0f 85 65 ff ff ff    	jne    105601 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10569c:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1056a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056a4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1056a7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1056ab:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1056ae:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1056b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1056b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056ba:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1056c1:	00 
  1056c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1056c9:	e8 fd fd ff ff       	call   1054cb <get_pgtable_items>
  1056ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056d5:	0f 85 c7 fe ff ff    	jne    1055a2 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1056db:	c7 04 24 10 73 10 00 	movl   $0x107310,(%esp)
  1056e2:	e8 60 ac ff ff       	call   100347 <cprintf>
}
  1056e7:	83 c4 4c             	add    $0x4c,%esp
  1056ea:	5b                   	pop    %ebx
  1056eb:	5e                   	pop    %esi
  1056ec:	5f                   	pop    %edi
  1056ed:	5d                   	pop    %ebp
  1056ee:	c3                   	ret    

001056ef <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1056ef:	55                   	push   %ebp
  1056f0:	89 e5                	mov    %esp,%ebp
  1056f2:	83 ec 58             	sub    $0x58,%esp
  1056f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1056f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1056fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1056fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105701:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105704:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105707:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10570a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10570d:	8b 45 18             	mov    0x18(%ebp),%eax
  105710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105716:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105719:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10571c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10571f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105725:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105729:	74 1c                	je     105747 <printnum+0x58>
  10572b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10572e:	ba 00 00 00 00       	mov    $0x0,%edx
  105733:	f7 75 e4             	divl   -0x1c(%ebp)
  105736:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10573c:	ba 00 00 00 00       	mov    $0x0,%edx
  105741:	f7 75 e4             	divl   -0x1c(%ebp)
  105744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10574a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10574d:	f7 75 e4             	divl   -0x1c(%ebp)
  105750:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105759:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10575c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10575f:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105762:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105765:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105768:	8b 45 18             	mov    0x18(%ebp),%eax
  10576b:	ba 00 00 00 00       	mov    $0x0,%edx
  105770:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105773:	77 56                	ja     1057cb <printnum+0xdc>
  105775:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105778:	72 05                	jb     10577f <printnum+0x90>
  10577a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10577d:	77 4c                	ja     1057cb <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10577f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105782:	8d 50 ff             	lea    -0x1(%eax),%edx
  105785:	8b 45 20             	mov    0x20(%ebp),%eax
  105788:	89 44 24 18          	mov    %eax,0x18(%esp)
  10578c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105790:	8b 45 18             	mov    0x18(%ebp),%eax
  105793:	89 44 24 10          	mov    %eax,0x10(%esp)
  105797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10579a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10579d:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1057a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1057af:	89 04 24             	mov    %eax,(%esp)
  1057b2:	e8 38 ff ff ff       	call   1056ef <printnum>
  1057b7:	eb 1c                	jmp    1057d5 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1057b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c0:	8b 45 20             	mov    0x20(%ebp),%eax
  1057c3:	89 04 24             	mov    %eax,(%esp)
  1057c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c9:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1057cb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1057cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1057d3:	7f e4                	jg     1057b9 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1057d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1057d8:	05 d0 73 10 00       	add    $0x1073d0,%eax
  1057dd:	0f b6 00             	movzbl (%eax),%eax
  1057e0:	0f be c0             	movsbl %al,%eax
  1057e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057ea:	89 04 24             	mov    %eax,(%esp)
  1057ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f0:	ff d0                	call   *%eax
}
  1057f2:	c9                   	leave  
  1057f3:	c3                   	ret    

001057f4 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1057f4:	55                   	push   %ebp
  1057f5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1057f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1057fb:	7e 14                	jle    105811 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1057fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105800:	8b 00                	mov    (%eax),%eax
  105802:	8d 48 08             	lea    0x8(%eax),%ecx
  105805:	8b 55 08             	mov    0x8(%ebp),%edx
  105808:	89 0a                	mov    %ecx,(%edx)
  10580a:	8b 50 04             	mov    0x4(%eax),%edx
  10580d:	8b 00                	mov    (%eax),%eax
  10580f:	eb 30                	jmp    105841 <getuint+0x4d>
    }
    else if (lflag) {
  105811:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105815:	74 16                	je     10582d <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105817:	8b 45 08             	mov    0x8(%ebp),%eax
  10581a:	8b 00                	mov    (%eax),%eax
  10581c:	8d 48 04             	lea    0x4(%eax),%ecx
  10581f:	8b 55 08             	mov    0x8(%ebp),%edx
  105822:	89 0a                	mov    %ecx,(%edx)
  105824:	8b 00                	mov    (%eax),%eax
  105826:	ba 00 00 00 00       	mov    $0x0,%edx
  10582b:	eb 14                	jmp    105841 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10582d:	8b 45 08             	mov    0x8(%ebp),%eax
  105830:	8b 00                	mov    (%eax),%eax
  105832:	8d 48 04             	lea    0x4(%eax),%ecx
  105835:	8b 55 08             	mov    0x8(%ebp),%edx
  105838:	89 0a                	mov    %ecx,(%edx)
  10583a:	8b 00                	mov    (%eax),%eax
  10583c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105841:	5d                   	pop    %ebp
  105842:	c3                   	ret    

00105843 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105843:	55                   	push   %ebp
  105844:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105846:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10584a:	7e 14                	jle    105860 <getint+0x1d>
        return va_arg(*ap, long long);
  10584c:	8b 45 08             	mov    0x8(%ebp),%eax
  10584f:	8b 00                	mov    (%eax),%eax
  105851:	8d 48 08             	lea    0x8(%eax),%ecx
  105854:	8b 55 08             	mov    0x8(%ebp),%edx
  105857:	89 0a                	mov    %ecx,(%edx)
  105859:	8b 50 04             	mov    0x4(%eax),%edx
  10585c:	8b 00                	mov    (%eax),%eax
  10585e:	eb 28                	jmp    105888 <getint+0x45>
    }
    else if (lflag) {
  105860:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105864:	74 12                	je     105878 <getint+0x35>
        return va_arg(*ap, long);
  105866:	8b 45 08             	mov    0x8(%ebp),%eax
  105869:	8b 00                	mov    (%eax),%eax
  10586b:	8d 48 04             	lea    0x4(%eax),%ecx
  10586e:	8b 55 08             	mov    0x8(%ebp),%edx
  105871:	89 0a                	mov    %ecx,(%edx)
  105873:	8b 00                	mov    (%eax),%eax
  105875:	99                   	cltd   
  105876:	eb 10                	jmp    105888 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105878:	8b 45 08             	mov    0x8(%ebp),%eax
  10587b:	8b 00                	mov    (%eax),%eax
  10587d:	8d 48 04             	lea    0x4(%eax),%ecx
  105880:	8b 55 08             	mov    0x8(%ebp),%edx
  105883:	89 0a                	mov    %ecx,(%edx)
  105885:	8b 00                	mov    (%eax),%eax
  105887:	99                   	cltd   
    }
}
  105888:	5d                   	pop    %ebp
  105889:	c3                   	ret    

0010588a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10588a:	55                   	push   %ebp
  10588b:	89 e5                	mov    %esp,%ebp
  10588d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105890:	8d 45 14             	lea    0x14(%ebp),%eax
  105893:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105899:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10589d:	8b 45 10             	mov    0x10(%ebp),%eax
  1058a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ae:	89 04 24             	mov    %eax,(%esp)
  1058b1:	e8 02 00 00 00       	call   1058b8 <vprintfmt>
    va_end(ap);
}
  1058b6:	c9                   	leave  
  1058b7:	c3                   	ret    

001058b8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1058b8:	55                   	push   %ebp
  1058b9:	89 e5                	mov    %esp,%ebp
  1058bb:	56                   	push   %esi
  1058bc:	53                   	push   %ebx
  1058bd:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058c0:	eb 18                	jmp    1058da <vprintfmt+0x22>
            if (ch == '\0') {
  1058c2:	85 db                	test   %ebx,%ebx
  1058c4:	75 05                	jne    1058cb <vprintfmt+0x13>
                return;
  1058c6:	e9 d1 03 00 00       	jmp    105c9c <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1058cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d2:	89 1c 24             	mov    %ebx,(%esp)
  1058d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d8:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058da:	8b 45 10             	mov    0x10(%ebp),%eax
  1058dd:	8d 50 01             	lea    0x1(%eax),%edx
  1058e0:	89 55 10             	mov    %edx,0x10(%ebp)
  1058e3:	0f b6 00             	movzbl (%eax),%eax
  1058e6:	0f b6 d8             	movzbl %al,%ebx
  1058e9:	83 fb 25             	cmp    $0x25,%ebx
  1058ec:	75 d4                	jne    1058c2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1058ee:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1058f2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1058f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1058ff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105906:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105909:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10590c:	8b 45 10             	mov    0x10(%ebp),%eax
  10590f:	8d 50 01             	lea    0x1(%eax),%edx
  105912:	89 55 10             	mov    %edx,0x10(%ebp)
  105915:	0f b6 00             	movzbl (%eax),%eax
  105918:	0f b6 d8             	movzbl %al,%ebx
  10591b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10591e:	83 f8 55             	cmp    $0x55,%eax
  105921:	0f 87 44 03 00 00    	ja     105c6b <vprintfmt+0x3b3>
  105927:	8b 04 85 f4 73 10 00 	mov    0x1073f4(,%eax,4),%eax
  10592e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105930:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105934:	eb d6                	jmp    10590c <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105936:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10593a:	eb d0                	jmp    10590c <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10593c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105946:	89 d0                	mov    %edx,%eax
  105948:	c1 e0 02             	shl    $0x2,%eax
  10594b:	01 d0                	add    %edx,%eax
  10594d:	01 c0                	add    %eax,%eax
  10594f:	01 d8                	add    %ebx,%eax
  105951:	83 e8 30             	sub    $0x30,%eax
  105954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105957:	8b 45 10             	mov    0x10(%ebp),%eax
  10595a:	0f b6 00             	movzbl (%eax),%eax
  10595d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105960:	83 fb 2f             	cmp    $0x2f,%ebx
  105963:	7e 0b                	jle    105970 <vprintfmt+0xb8>
  105965:	83 fb 39             	cmp    $0x39,%ebx
  105968:	7f 06                	jg     105970 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10596a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10596e:	eb d3                	jmp    105943 <vprintfmt+0x8b>
            goto process_precision;
  105970:	eb 33                	jmp    1059a5 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105972:	8b 45 14             	mov    0x14(%ebp),%eax
  105975:	8d 50 04             	lea    0x4(%eax),%edx
  105978:	89 55 14             	mov    %edx,0x14(%ebp)
  10597b:	8b 00                	mov    (%eax),%eax
  10597d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105980:	eb 23                	jmp    1059a5 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105982:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105986:	79 0c                	jns    105994 <vprintfmt+0xdc>
                width = 0;
  105988:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10598f:	e9 78 ff ff ff       	jmp    10590c <vprintfmt+0x54>
  105994:	e9 73 ff ff ff       	jmp    10590c <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105999:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1059a0:	e9 67 ff ff ff       	jmp    10590c <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1059a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059a9:	79 12                	jns    1059bd <vprintfmt+0x105>
                width = precision, precision = -1;
  1059ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1059b8:	e9 4f ff ff ff       	jmp    10590c <vprintfmt+0x54>
  1059bd:	e9 4a ff ff ff       	jmp    10590c <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1059c2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1059c6:	e9 41 ff ff ff       	jmp    10590c <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1059cb:	8b 45 14             	mov    0x14(%ebp),%eax
  1059ce:	8d 50 04             	lea    0x4(%eax),%edx
  1059d1:	89 55 14             	mov    %edx,0x14(%ebp)
  1059d4:	8b 00                	mov    (%eax),%eax
  1059d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059dd:	89 04 24             	mov    %eax,(%esp)
  1059e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e3:	ff d0                	call   *%eax
            break;
  1059e5:	e9 ac 02 00 00       	jmp    105c96 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1059ea:	8b 45 14             	mov    0x14(%ebp),%eax
  1059ed:	8d 50 04             	lea    0x4(%eax),%edx
  1059f0:	89 55 14             	mov    %edx,0x14(%ebp)
  1059f3:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1059f5:	85 db                	test   %ebx,%ebx
  1059f7:	79 02                	jns    1059fb <vprintfmt+0x143>
                err = -err;
  1059f9:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1059fb:	83 fb 06             	cmp    $0x6,%ebx
  1059fe:	7f 0b                	jg     105a0b <vprintfmt+0x153>
  105a00:	8b 34 9d b4 73 10 00 	mov    0x1073b4(,%ebx,4),%esi
  105a07:	85 f6                	test   %esi,%esi
  105a09:	75 23                	jne    105a2e <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105a0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105a0f:	c7 44 24 08 e1 73 10 	movl   $0x1073e1,0x8(%esp)
  105a16:	00 
  105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a21:	89 04 24             	mov    %eax,(%esp)
  105a24:	e8 61 fe ff ff       	call   10588a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105a29:	e9 68 02 00 00       	jmp    105c96 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105a2e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105a32:	c7 44 24 08 ea 73 10 	movl   $0x1073ea,0x8(%esp)
  105a39:	00 
  105a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a41:	8b 45 08             	mov    0x8(%ebp),%eax
  105a44:	89 04 24             	mov    %eax,(%esp)
  105a47:	e8 3e fe ff ff       	call   10588a <printfmt>
            }
            break;
  105a4c:	e9 45 02 00 00       	jmp    105c96 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105a51:	8b 45 14             	mov    0x14(%ebp),%eax
  105a54:	8d 50 04             	lea    0x4(%eax),%edx
  105a57:	89 55 14             	mov    %edx,0x14(%ebp)
  105a5a:	8b 30                	mov    (%eax),%esi
  105a5c:	85 f6                	test   %esi,%esi
  105a5e:	75 05                	jne    105a65 <vprintfmt+0x1ad>
                p = "(null)";
  105a60:	be ed 73 10 00       	mov    $0x1073ed,%esi
            }
            if (width > 0 && padc != '-') {
  105a65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a69:	7e 3e                	jle    105aa9 <vprintfmt+0x1f1>
  105a6b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105a6f:	74 38                	je     105aa9 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a71:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105a74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a7b:	89 34 24             	mov    %esi,(%esp)
  105a7e:	e8 15 03 00 00       	call   105d98 <strnlen>
  105a83:	29 c3                	sub    %eax,%ebx
  105a85:	89 d8                	mov    %ebx,%eax
  105a87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a8a:	eb 17                	jmp    105aa3 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105a8c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a93:	89 54 24 04          	mov    %edx,0x4(%esp)
  105a97:	89 04 24             	mov    %eax,(%esp)
  105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9d:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a9f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105aa3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105aa7:	7f e3                	jg     105a8c <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105aa9:	eb 38                	jmp    105ae3 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105aab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105aaf:	74 1f                	je     105ad0 <vprintfmt+0x218>
  105ab1:	83 fb 1f             	cmp    $0x1f,%ebx
  105ab4:	7e 05                	jle    105abb <vprintfmt+0x203>
  105ab6:	83 fb 7e             	cmp    $0x7e,%ebx
  105ab9:	7e 15                	jle    105ad0 <vprintfmt+0x218>
                    putch('?', putdat);
  105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ac2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  105acc:	ff d0                	call   *%eax
  105ace:	eb 0f                	jmp    105adf <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ad7:	89 1c 24             	mov    %ebx,(%esp)
  105ada:	8b 45 08             	mov    0x8(%ebp),%eax
  105add:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105adf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105ae3:	89 f0                	mov    %esi,%eax
  105ae5:	8d 70 01             	lea    0x1(%eax),%esi
  105ae8:	0f b6 00             	movzbl (%eax),%eax
  105aeb:	0f be d8             	movsbl %al,%ebx
  105aee:	85 db                	test   %ebx,%ebx
  105af0:	74 10                	je     105b02 <vprintfmt+0x24a>
  105af2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105af6:	78 b3                	js     105aab <vprintfmt+0x1f3>
  105af8:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105afc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105b00:	79 a9                	jns    105aab <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105b02:	eb 17                	jmp    105b1b <vprintfmt+0x263>
                putch(' ', putdat);
  105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b0b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105b12:	8b 45 08             	mov    0x8(%ebp),%eax
  105b15:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105b17:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b1f:	7f e3                	jg     105b04 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105b21:	e9 70 01 00 00       	jmp    105c96 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b2d:	8d 45 14             	lea    0x14(%ebp),%eax
  105b30:	89 04 24             	mov    %eax,(%esp)
  105b33:	e8 0b fd ff ff       	call   105843 <getint>
  105b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b44:	85 d2                	test   %edx,%edx
  105b46:	79 26                	jns    105b6e <vprintfmt+0x2b6>
                putch('-', putdat);
  105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b4f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105b56:	8b 45 08             	mov    0x8(%ebp),%eax
  105b59:	ff d0                	call   *%eax
                num = -(long long)num;
  105b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b61:	f7 d8                	neg    %eax
  105b63:	83 d2 00             	adc    $0x0,%edx
  105b66:	f7 da                	neg    %edx
  105b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105b6e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b75:	e9 a8 00 00 00       	jmp    105c22 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b81:	8d 45 14             	lea    0x14(%ebp),%eax
  105b84:	89 04 24             	mov    %eax,(%esp)
  105b87:	e8 68 fc ff ff       	call   1057f4 <getuint>
  105b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105b92:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b99:	e9 84 00 00 00       	jmp    105c22 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  105ba8:	89 04 24             	mov    %eax,(%esp)
  105bab:	e8 44 fc ff ff       	call   1057f4 <getuint>
  105bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105bb6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105bbd:	eb 63                	jmp    105c22 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bc6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd0:	ff d0                	call   *%eax
            putch('x', putdat);
  105bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bd9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105be0:	8b 45 08             	mov    0x8(%ebp),%eax
  105be3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105be5:	8b 45 14             	mov    0x14(%ebp),%eax
  105be8:	8d 50 04             	lea    0x4(%eax),%edx
  105beb:	89 55 14             	mov    %edx,0x14(%ebp)
  105bee:	8b 00                	mov    (%eax),%eax
  105bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105bfa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105c01:	eb 1f                	jmp    105c22 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c0a:	8d 45 14             	lea    0x14(%ebp),%eax
  105c0d:	89 04 24             	mov    %eax,(%esp)
  105c10:	e8 df fb ff ff       	call   1057f4 <getuint>
  105c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105c1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105c22:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c29:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c30:	89 54 24 14          	mov    %edx,0x14(%esp)
  105c34:	89 44 24 10          	mov    %eax,0x10(%esp)
  105c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c42:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c50:	89 04 24             	mov    %eax,(%esp)
  105c53:	e8 97 fa ff ff       	call   1056ef <printnum>
            break;
  105c58:	eb 3c                	jmp    105c96 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c61:	89 1c 24             	mov    %ebx,(%esp)
  105c64:	8b 45 08             	mov    0x8(%ebp),%eax
  105c67:	ff d0                	call   *%eax
            break;
  105c69:	eb 2b                	jmp    105c96 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c72:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105c79:	8b 45 08             	mov    0x8(%ebp),%eax
  105c7c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105c7e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c82:	eb 04                	jmp    105c88 <vprintfmt+0x3d0>
  105c84:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c88:	8b 45 10             	mov    0x10(%ebp),%eax
  105c8b:	83 e8 01             	sub    $0x1,%eax
  105c8e:	0f b6 00             	movzbl (%eax),%eax
  105c91:	3c 25                	cmp    $0x25,%al
  105c93:	75 ef                	jne    105c84 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105c95:	90                   	nop
        }
    }
  105c96:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c97:	e9 3e fc ff ff       	jmp    1058da <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105c9c:	83 c4 40             	add    $0x40,%esp
  105c9f:	5b                   	pop    %ebx
  105ca0:	5e                   	pop    %esi
  105ca1:	5d                   	pop    %ebp
  105ca2:	c3                   	ret    

00105ca3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105ca3:	55                   	push   %ebp
  105ca4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ca9:	8b 40 08             	mov    0x8(%eax),%eax
  105cac:	8d 50 01             	lea    0x1(%eax),%edx
  105caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb8:	8b 10                	mov    (%eax),%edx
  105cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cbd:	8b 40 04             	mov    0x4(%eax),%eax
  105cc0:	39 c2                	cmp    %eax,%edx
  105cc2:	73 12                	jae    105cd6 <sprintputch+0x33>
        *b->buf ++ = ch;
  105cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc7:	8b 00                	mov    (%eax),%eax
  105cc9:	8d 48 01             	lea    0x1(%eax),%ecx
  105ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ccf:	89 0a                	mov    %ecx,(%edx)
  105cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  105cd4:	88 10                	mov    %dl,(%eax)
    }
}
  105cd6:	5d                   	pop    %ebp
  105cd7:	c3                   	ret    

00105cd8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105cd8:	55                   	push   %ebp
  105cd9:	89 e5                	mov    %esp,%ebp
  105cdb:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105cde:	8d 45 14             	lea    0x14(%ebp),%eax
  105ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ce7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  105cee:	89 44 24 08          	mov    %eax,0x8(%esp)
  105cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfc:	89 04 24             	mov    %eax,(%esp)
  105cff:	e8 08 00 00 00       	call   105d0c <vsnprintf>
  105d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d0a:	c9                   	leave  
  105d0b:	c3                   	ret    

00105d0c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105d0c:	55                   	push   %ebp
  105d0d:	89 e5                	mov    %esp,%ebp
  105d0f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105d12:	8b 45 08             	mov    0x8(%ebp),%eax
  105d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d21:	01 d0                	add    %edx,%eax
  105d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105d2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105d31:	74 0a                	je     105d3d <vsnprintf+0x31>
  105d33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d39:	39 c2                	cmp    %eax,%edx
  105d3b:	76 07                	jbe    105d44 <vsnprintf+0x38>
        return -E_INVAL;
  105d3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105d42:	eb 2a                	jmp    105d6e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105d44:	8b 45 14             	mov    0x14(%ebp),%eax
  105d47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  105d4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d52:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d59:	c7 04 24 a3 5c 10 00 	movl   $0x105ca3,(%esp)
  105d60:	e8 53 fb ff ff       	call   1058b8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d68:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d6e:	c9                   	leave  
  105d6f:	c3                   	ret    

00105d70 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105d70:	55                   	push   %ebp
  105d71:	89 e5                	mov    %esp,%ebp
  105d73:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105d7d:	eb 04                	jmp    105d83 <strlen+0x13>
        cnt ++;
  105d7f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105d83:	8b 45 08             	mov    0x8(%ebp),%eax
  105d86:	8d 50 01             	lea    0x1(%eax),%edx
  105d89:	89 55 08             	mov    %edx,0x8(%ebp)
  105d8c:	0f b6 00             	movzbl (%eax),%eax
  105d8f:	84 c0                	test   %al,%al
  105d91:	75 ec                	jne    105d7f <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d96:	c9                   	leave  
  105d97:	c3                   	ret    

00105d98 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105d98:	55                   	push   %ebp
  105d99:	89 e5                	mov    %esp,%ebp
  105d9b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105da5:	eb 04                	jmp    105dab <strnlen+0x13>
        cnt ++;
  105da7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105db1:	73 10                	jae    105dc3 <strnlen+0x2b>
  105db3:	8b 45 08             	mov    0x8(%ebp),%eax
  105db6:	8d 50 01             	lea    0x1(%eax),%edx
  105db9:	89 55 08             	mov    %edx,0x8(%ebp)
  105dbc:	0f b6 00             	movzbl (%eax),%eax
  105dbf:	84 c0                	test   %al,%al
  105dc1:	75 e4                	jne    105da7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105dc6:	c9                   	leave  
  105dc7:	c3                   	ret    

00105dc8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105dc8:	55                   	push   %ebp
  105dc9:	89 e5                	mov    %esp,%ebp
  105dcb:	57                   	push   %edi
  105dcc:	56                   	push   %esi
  105dcd:	83 ec 20             	sub    $0x20,%esp
  105dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105de2:	89 d1                	mov    %edx,%ecx
  105de4:	89 c2                	mov    %eax,%edx
  105de6:	89 ce                	mov    %ecx,%esi
  105de8:	89 d7                	mov    %edx,%edi
  105dea:	ac                   	lods   %ds:(%esi),%al
  105deb:	aa                   	stos   %al,%es:(%edi)
  105dec:	84 c0                	test   %al,%al
  105dee:	75 fa                	jne    105dea <strcpy+0x22>
  105df0:	89 fa                	mov    %edi,%edx
  105df2:	89 f1                	mov    %esi,%ecx
  105df4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105df7:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105dfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105e00:	83 c4 20             	add    $0x20,%esp
  105e03:	5e                   	pop    %esi
  105e04:	5f                   	pop    %edi
  105e05:	5d                   	pop    %ebp
  105e06:	c3                   	ret    

00105e07 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105e07:	55                   	push   %ebp
  105e08:	89 e5                	mov    %esp,%ebp
  105e0a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105e13:	eb 21                	jmp    105e36 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e18:	0f b6 10             	movzbl (%eax),%edx
  105e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e1e:	88 10                	mov    %dl,(%eax)
  105e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e23:	0f b6 00             	movzbl (%eax),%eax
  105e26:	84 c0                	test   %al,%al
  105e28:	74 04                	je     105e2e <strncpy+0x27>
            src ++;
  105e2a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105e2e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e3a:	75 d9                	jne    105e15 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e3f:	c9                   	leave  
  105e40:	c3                   	ret    

00105e41 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105e41:	55                   	push   %ebp
  105e42:	89 e5                	mov    %esp,%ebp
  105e44:	57                   	push   %edi
  105e45:	56                   	push   %esi
  105e46:	83 ec 20             	sub    $0x20,%esp
  105e49:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e5b:	89 d1                	mov    %edx,%ecx
  105e5d:	89 c2                	mov    %eax,%edx
  105e5f:	89 ce                	mov    %ecx,%esi
  105e61:	89 d7                	mov    %edx,%edi
  105e63:	ac                   	lods   %ds:(%esi),%al
  105e64:	ae                   	scas   %es:(%edi),%al
  105e65:	75 08                	jne    105e6f <strcmp+0x2e>
  105e67:	84 c0                	test   %al,%al
  105e69:	75 f8                	jne    105e63 <strcmp+0x22>
  105e6b:	31 c0                	xor    %eax,%eax
  105e6d:	eb 04                	jmp    105e73 <strcmp+0x32>
  105e6f:	19 c0                	sbb    %eax,%eax
  105e71:	0c 01                	or     $0x1,%al
  105e73:	89 fa                	mov    %edi,%edx
  105e75:	89 f1                	mov    %esi,%ecx
  105e77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e7a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105e7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105e83:	83 c4 20             	add    $0x20,%esp
  105e86:	5e                   	pop    %esi
  105e87:	5f                   	pop    %edi
  105e88:	5d                   	pop    %ebp
  105e89:	c3                   	ret    

00105e8a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105e8a:	55                   	push   %ebp
  105e8b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e8d:	eb 0c                	jmp    105e9b <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105e8f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105e93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e9f:	74 1a                	je     105ebb <strncmp+0x31>
  105ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea4:	0f b6 00             	movzbl (%eax),%eax
  105ea7:	84 c0                	test   %al,%al
  105ea9:	74 10                	je     105ebb <strncmp+0x31>
  105eab:	8b 45 08             	mov    0x8(%ebp),%eax
  105eae:	0f b6 10             	movzbl (%eax),%edx
  105eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb4:	0f b6 00             	movzbl (%eax),%eax
  105eb7:	38 c2                	cmp    %al,%dl
  105eb9:	74 d4                	je     105e8f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ebf:	74 18                	je     105ed9 <strncmp+0x4f>
  105ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec4:	0f b6 00             	movzbl (%eax),%eax
  105ec7:	0f b6 d0             	movzbl %al,%edx
  105eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ecd:	0f b6 00             	movzbl (%eax),%eax
  105ed0:	0f b6 c0             	movzbl %al,%eax
  105ed3:	29 c2                	sub    %eax,%edx
  105ed5:	89 d0                	mov    %edx,%eax
  105ed7:	eb 05                	jmp    105ede <strncmp+0x54>
  105ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ede:	5d                   	pop    %ebp
  105edf:	c3                   	ret    

00105ee0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105ee0:	55                   	push   %ebp
  105ee1:	89 e5                	mov    %esp,%ebp
  105ee3:	83 ec 04             	sub    $0x4,%esp
  105ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ee9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105eec:	eb 14                	jmp    105f02 <strchr+0x22>
        if (*s == c) {
  105eee:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef1:	0f b6 00             	movzbl (%eax),%eax
  105ef4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ef7:	75 05                	jne    105efe <strchr+0x1e>
            return (char *)s;
  105ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  105efc:	eb 13                	jmp    105f11 <strchr+0x31>
        }
        s ++;
  105efe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105f02:	8b 45 08             	mov    0x8(%ebp),%eax
  105f05:	0f b6 00             	movzbl (%eax),%eax
  105f08:	84 c0                	test   %al,%al
  105f0a:	75 e2                	jne    105eee <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f11:	c9                   	leave  
  105f12:	c3                   	ret    

00105f13 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105f13:	55                   	push   %ebp
  105f14:	89 e5                	mov    %esp,%ebp
  105f16:	83 ec 04             	sub    $0x4,%esp
  105f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f1c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f1f:	eb 11                	jmp    105f32 <strfind+0x1f>
        if (*s == c) {
  105f21:	8b 45 08             	mov    0x8(%ebp),%eax
  105f24:	0f b6 00             	movzbl (%eax),%eax
  105f27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105f2a:	75 02                	jne    105f2e <strfind+0x1b>
            break;
  105f2c:	eb 0e                	jmp    105f3c <strfind+0x29>
        }
        s ++;
  105f2e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105f32:	8b 45 08             	mov    0x8(%ebp),%eax
  105f35:	0f b6 00             	movzbl (%eax),%eax
  105f38:	84 c0                	test   %al,%al
  105f3a:	75 e5                	jne    105f21 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105f3f:	c9                   	leave  
  105f40:	c3                   	ret    

00105f41 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105f41:	55                   	push   %ebp
  105f42:	89 e5                	mov    %esp,%ebp
  105f44:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105f47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105f4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f55:	eb 04                	jmp    105f5b <strtol+0x1a>
        s ++;
  105f57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5e:	0f b6 00             	movzbl (%eax),%eax
  105f61:	3c 20                	cmp    $0x20,%al
  105f63:	74 f2                	je     105f57 <strtol+0x16>
  105f65:	8b 45 08             	mov    0x8(%ebp),%eax
  105f68:	0f b6 00             	movzbl (%eax),%eax
  105f6b:	3c 09                	cmp    $0x9,%al
  105f6d:	74 e8                	je     105f57 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f72:	0f b6 00             	movzbl (%eax),%eax
  105f75:	3c 2b                	cmp    $0x2b,%al
  105f77:	75 06                	jne    105f7f <strtol+0x3e>
        s ++;
  105f79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f7d:	eb 15                	jmp    105f94 <strtol+0x53>
    }
    else if (*s == '-') {
  105f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f82:	0f b6 00             	movzbl (%eax),%eax
  105f85:	3c 2d                	cmp    $0x2d,%al
  105f87:	75 0b                	jne    105f94 <strtol+0x53>
        s ++, neg = 1;
  105f89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f98:	74 06                	je     105fa0 <strtol+0x5f>
  105f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105f9e:	75 24                	jne    105fc4 <strtol+0x83>
  105fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa3:	0f b6 00             	movzbl (%eax),%eax
  105fa6:	3c 30                	cmp    $0x30,%al
  105fa8:	75 1a                	jne    105fc4 <strtol+0x83>
  105faa:	8b 45 08             	mov    0x8(%ebp),%eax
  105fad:	83 c0 01             	add    $0x1,%eax
  105fb0:	0f b6 00             	movzbl (%eax),%eax
  105fb3:	3c 78                	cmp    $0x78,%al
  105fb5:	75 0d                	jne    105fc4 <strtol+0x83>
        s += 2, base = 16;
  105fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105fc2:	eb 2a                	jmp    105fee <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105fc8:	75 17                	jne    105fe1 <strtol+0xa0>
  105fca:	8b 45 08             	mov    0x8(%ebp),%eax
  105fcd:	0f b6 00             	movzbl (%eax),%eax
  105fd0:	3c 30                	cmp    $0x30,%al
  105fd2:	75 0d                	jne    105fe1 <strtol+0xa0>
        s ++, base = 8;
  105fd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105fd8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105fdf:	eb 0d                	jmp    105fee <strtol+0xad>
    }
    else if (base == 0) {
  105fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105fe5:	75 07                	jne    105fee <strtol+0xad>
        base = 10;
  105fe7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105fee:	8b 45 08             	mov    0x8(%ebp),%eax
  105ff1:	0f b6 00             	movzbl (%eax),%eax
  105ff4:	3c 2f                	cmp    $0x2f,%al
  105ff6:	7e 1b                	jle    106013 <strtol+0xd2>
  105ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ffb:	0f b6 00             	movzbl (%eax),%eax
  105ffe:	3c 39                	cmp    $0x39,%al
  106000:	7f 11                	jg     106013 <strtol+0xd2>
            dig = *s - '0';
  106002:	8b 45 08             	mov    0x8(%ebp),%eax
  106005:	0f b6 00             	movzbl (%eax),%eax
  106008:	0f be c0             	movsbl %al,%eax
  10600b:	83 e8 30             	sub    $0x30,%eax
  10600e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106011:	eb 48                	jmp    10605b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  106013:	8b 45 08             	mov    0x8(%ebp),%eax
  106016:	0f b6 00             	movzbl (%eax),%eax
  106019:	3c 60                	cmp    $0x60,%al
  10601b:	7e 1b                	jle    106038 <strtol+0xf7>
  10601d:	8b 45 08             	mov    0x8(%ebp),%eax
  106020:	0f b6 00             	movzbl (%eax),%eax
  106023:	3c 7a                	cmp    $0x7a,%al
  106025:	7f 11                	jg     106038 <strtol+0xf7>
            dig = *s - 'a' + 10;
  106027:	8b 45 08             	mov    0x8(%ebp),%eax
  10602a:	0f b6 00             	movzbl (%eax),%eax
  10602d:	0f be c0             	movsbl %al,%eax
  106030:	83 e8 57             	sub    $0x57,%eax
  106033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106036:	eb 23                	jmp    10605b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106038:	8b 45 08             	mov    0x8(%ebp),%eax
  10603b:	0f b6 00             	movzbl (%eax),%eax
  10603e:	3c 40                	cmp    $0x40,%al
  106040:	7e 3d                	jle    10607f <strtol+0x13e>
  106042:	8b 45 08             	mov    0x8(%ebp),%eax
  106045:	0f b6 00             	movzbl (%eax),%eax
  106048:	3c 5a                	cmp    $0x5a,%al
  10604a:	7f 33                	jg     10607f <strtol+0x13e>
            dig = *s - 'A' + 10;
  10604c:	8b 45 08             	mov    0x8(%ebp),%eax
  10604f:	0f b6 00             	movzbl (%eax),%eax
  106052:	0f be c0             	movsbl %al,%eax
  106055:	83 e8 37             	sub    $0x37,%eax
  106058:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10605b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10605e:	3b 45 10             	cmp    0x10(%ebp),%eax
  106061:	7c 02                	jl     106065 <strtol+0x124>
            break;
  106063:	eb 1a                	jmp    10607f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  106065:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10606c:	0f af 45 10          	imul   0x10(%ebp),%eax
  106070:	89 c2                	mov    %eax,%edx
  106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106075:	01 d0                	add    %edx,%eax
  106077:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10607a:	e9 6f ff ff ff       	jmp    105fee <strtol+0xad>

    if (endptr) {
  10607f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106083:	74 08                	je     10608d <strtol+0x14c>
        *endptr = (char *) s;
  106085:	8b 45 0c             	mov    0xc(%ebp),%eax
  106088:	8b 55 08             	mov    0x8(%ebp),%edx
  10608b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10608d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106091:	74 07                	je     10609a <strtol+0x159>
  106093:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106096:	f7 d8                	neg    %eax
  106098:	eb 03                	jmp    10609d <strtol+0x15c>
  10609a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10609d:	c9                   	leave  
  10609e:	c3                   	ret    

0010609f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10609f:	55                   	push   %ebp
  1060a0:	89 e5                	mov    %esp,%ebp
  1060a2:	57                   	push   %edi
  1060a3:	83 ec 24             	sub    $0x24,%esp
  1060a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060a9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1060ac:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1060b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1060b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1060b6:	88 45 f7             	mov    %al,-0x9(%ebp)
  1060b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1060bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1060bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1060c2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1060c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1060c9:	89 d7                	mov    %edx,%edi
  1060cb:	f3 aa                	rep stos %al,%es:(%edi)
  1060cd:	89 fa                	mov    %edi,%edx
  1060cf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1060d2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1060d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1060d8:	83 c4 24             	add    $0x24,%esp
  1060db:	5f                   	pop    %edi
  1060dc:	5d                   	pop    %ebp
  1060dd:	c3                   	ret    

001060de <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1060de:	55                   	push   %ebp
  1060df:	89 e5                	mov    %esp,%ebp
  1060e1:	57                   	push   %edi
  1060e2:	56                   	push   %esi
  1060e3:	53                   	push   %ebx
  1060e4:	83 ec 30             	sub    $0x30,%esp
  1060e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1060f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1060f6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1060f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1060ff:	73 42                	jae    106143 <memmove+0x65>
  106101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106107:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10610a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10610d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106110:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106113:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106116:	c1 e8 02             	shr    $0x2,%eax
  106119:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10611b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10611e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106121:	89 d7                	mov    %edx,%edi
  106123:	89 c6                	mov    %eax,%esi
  106125:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106127:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10612a:	83 e1 03             	and    $0x3,%ecx
  10612d:	74 02                	je     106131 <memmove+0x53>
  10612f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106131:	89 f0                	mov    %esi,%eax
  106133:	89 fa                	mov    %edi,%edx
  106135:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106138:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10613b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10613e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106141:	eb 36                	jmp    106179 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106146:	8d 50 ff             	lea    -0x1(%eax),%edx
  106149:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10614c:	01 c2                	add    %eax,%edx
  10614e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106151:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106157:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10615a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10615d:	89 c1                	mov    %eax,%ecx
  10615f:	89 d8                	mov    %ebx,%eax
  106161:	89 d6                	mov    %edx,%esi
  106163:	89 c7                	mov    %eax,%edi
  106165:	fd                   	std    
  106166:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106168:	fc                   	cld    
  106169:	89 f8                	mov    %edi,%eax
  10616b:	89 f2                	mov    %esi,%edx
  10616d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106170:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106173:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  106176:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106179:	83 c4 30             	add    $0x30,%esp
  10617c:	5b                   	pop    %ebx
  10617d:	5e                   	pop    %esi
  10617e:	5f                   	pop    %edi
  10617f:	5d                   	pop    %ebp
  106180:	c3                   	ret    

00106181 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106181:	55                   	push   %ebp
  106182:	89 e5                	mov    %esp,%ebp
  106184:	57                   	push   %edi
  106185:	56                   	push   %esi
  106186:	83 ec 20             	sub    $0x20,%esp
  106189:	8b 45 08             	mov    0x8(%ebp),%eax
  10618c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10618f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106192:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106195:	8b 45 10             	mov    0x10(%ebp),%eax
  106198:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10619b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10619e:	c1 e8 02             	shr    $0x2,%eax
  1061a1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1061a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1061a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061a9:	89 d7                	mov    %edx,%edi
  1061ab:	89 c6                	mov    %eax,%esi
  1061ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1061af:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1061b2:	83 e1 03             	and    $0x3,%ecx
  1061b5:	74 02                	je     1061b9 <memcpy+0x38>
  1061b7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1061b9:	89 f0                	mov    %esi,%eax
  1061bb:	89 fa                	mov    %edi,%edx
  1061bd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1061c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1061c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1061c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1061c9:	83 c4 20             	add    $0x20,%esp
  1061cc:	5e                   	pop    %esi
  1061cd:	5f                   	pop    %edi
  1061ce:	5d                   	pop    %ebp
  1061cf:	c3                   	ret    

001061d0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1061d0:	55                   	push   %ebp
  1061d1:	89 e5                	mov    %esp,%ebp
  1061d3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1061d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1061d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1061dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061df:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1061e2:	eb 30                	jmp    106214 <memcmp+0x44>
        if (*s1 != *s2) {
  1061e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1061e7:	0f b6 10             	movzbl (%eax),%edx
  1061ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1061ed:	0f b6 00             	movzbl (%eax),%eax
  1061f0:	38 c2                	cmp    %al,%dl
  1061f2:	74 18                	je     10620c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1061f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1061f7:	0f b6 00             	movzbl (%eax),%eax
  1061fa:	0f b6 d0             	movzbl %al,%edx
  1061fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106200:	0f b6 00             	movzbl (%eax),%eax
  106203:	0f b6 c0             	movzbl %al,%eax
  106206:	29 c2                	sub    %eax,%edx
  106208:	89 d0                	mov    %edx,%eax
  10620a:	eb 1a                	jmp    106226 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10620c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106210:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106214:	8b 45 10             	mov    0x10(%ebp),%eax
  106217:	8d 50 ff             	lea    -0x1(%eax),%edx
  10621a:	89 55 10             	mov    %edx,0x10(%ebp)
  10621d:	85 c0                	test   %eax,%eax
  10621f:	75 c3                	jne    1061e4 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106226:	c9                   	leave  
  106227:	c3                   	ret    
