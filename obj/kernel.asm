
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba c8 89 11 c0       	mov    $0xc01189c8,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 49 60 00 00       	call   c010609f <memset>

    cons_init();                // init the console
c0100056:	e8 7c 15 00 00       	call   c01015d7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 40 62 10 c0 	movl   $0xc0106240,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 5c 62 10 c0 	movl   $0xc010625c,(%esp)
c0100070:	e8 d2 02 00 00       	call   c0100347 <cprintf>

    print_kerninfo();
c0100075:	e8 01 08 00 00       	call   c010087b <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 ac 44 00 00       	call   c0104530 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b7 16 00 00       	call   c0101740 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 09 18 00 00       	call   c0101897 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 fa 0c 00 00       	call   c0100d8d <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 16 16 00 00       	call   c01016ae <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 03 0c 00 00       	call   c0100cbf <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 61 62 10 c0 	movl   $0xc0106261,(%esp)
c010015c:	e8 e6 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 6f 62 10 c0 	movl   $0xc010626f,(%esp)
c010017c:	e8 c6 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 7d 62 10 c0 	movl   $0xc010627d,(%esp)
c010019c:	e8 a6 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01001bc:	e8 86 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 99 62 10 c0 	movl   $0xc0106299,(%esp)
c01001dc:	e8 66 01 00 00       	call   c0100347 <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
c01001f3:	83 ec 08             	sub    $0x8,%esp
c01001f6:	cd 78                	int    $0x78
c01001f8:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c01001fa:	5d                   	pop    %ebp
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
c01001ff:	cd 79                	int    $0x79
c0100201:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
c0100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020b:	e8 1a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100210:	c7 04 24 a8 62 10 c0 	movl   $0xc01062a8,(%esp)
c0100217:	e8 2b 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_user();
c010021c:	e8 cf ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100221:	e8 04 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100226:	c7 04 24 c8 62 10 c0 	movl   $0xc01062c8,(%esp)
c010022d:	e8 15 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_kernel();
c0100232:	e8 c5 ff ff ff       	call   c01001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100237:	e8 ee fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100248:	74 13                	je     c010025d <readline+0x1f>
        cprintf("%s", prompt);
c010024a:	8b 45 08             	mov    0x8(%ebp),%eax
c010024d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100251:	c7 04 24 e7 62 10 c0 	movl   $0xc01062e7,(%esp)
c0100258:	e8 ea 00 00 00       	call   c0100347 <cprintf>
    }
    int i = 0, c;
c010025d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100264:	e8 66 01 00 00       	call   c01003cf <getchar>
c0100269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100270:	79 07                	jns    c0100279 <readline+0x3b>
            return NULL;
c0100272:	b8 00 00 00 00       	mov    $0x0,%eax
c0100277:	eb 79                	jmp    c01002f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100279:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027d:	7e 28                	jle    c01002a7 <readline+0x69>
c010027f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100286:	7f 1f                	jg     c01002a7 <readline+0x69>
            cputchar(c);
c0100288:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028b:	89 04 24             	mov    %eax,(%esp)
c010028e:	e8 da 00 00 00       	call   c010036d <cputchar>
            buf[i ++] = c;
c0100293:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100296:	8d 50 01             	lea    0x1(%eax),%edx
c0100299:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010029f:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c01002a5:	eb 46                	jmp    c01002ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ab:	75 17                	jne    c01002c4 <readline+0x86>
c01002ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b1:	7e 11                	jle    c01002c4 <readline+0x86>
            cputchar(c);
c01002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b6:	89 04 24             	mov    %eax,(%esp)
c01002b9:	e8 af 00 00 00       	call   c010036d <cputchar>
            i --;
c01002be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c2:	eb 29                	jmp    c01002ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c8:	74 06                	je     c01002d0 <readline+0x92>
c01002ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002ce:	75 1d                	jne    c01002ed <readline+0xaf>
            cputchar(c);
c01002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d3:	89 04 24             	mov    %eax,(%esp)
c01002d6:	e8 92 00 00 00       	call   c010036d <cputchar>
            buf[i] = '\0';
c01002db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002de:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e6:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002eb:	eb 05                	jmp    c01002f2 <readline+0xb4>
        }
    }
c01002ed:	e9 72 ff ff ff       	jmp    c0100264 <readline+0x26>
}
c01002f2:	c9                   	leave  
c01002f3:	c3                   	ret    

c01002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f4:	55                   	push   %ebp
c01002f5:	89 e5                	mov    %esp,%ebp
c01002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 fe 12 00 00       	call   c0101603 <cons_putc>
    (*cnt) ++;
c0100305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100308:	8b 00                	mov    (%eax),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100310:	89 10                	mov    %edx,(%eax)
}
c0100312:	c9                   	leave  
c0100313:	c3                   	ret    

c0100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100314:	55                   	push   %ebp
c0100315:	89 e5                	mov    %esp,%ebp
c0100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100328:	8b 45 08             	mov    0x8(%ebp),%eax
c010032b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100336:	c7 04 24 f4 02 10 c0 	movl   $0xc01002f4,(%esp)
c010033d:	e8 76 55 00 00       	call   c01058b8 <vprintfmt>
    return cnt;
c0100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100345:	c9                   	leave  
c0100346:	c3                   	ret    

c0100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100347:	55                   	push   %ebp
c0100348:	89 e5                	mov    %esp,%ebp
c010034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100356:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035a:	8b 45 08             	mov    0x8(%ebp),%eax
c010035d:	89 04 24             	mov    %eax,(%esp)
c0100360:	e8 af ff ff ff       	call   c0100314 <vcprintf>
c0100365:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036b:	c9                   	leave  
c010036c:	c3                   	ret    

c010036d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036d:	55                   	push   %ebp
c010036e:	89 e5                	mov    %esp,%ebp
c0100370:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100373:	8b 45 08             	mov    0x8(%ebp),%eax
c0100376:	89 04 24             	mov    %eax,(%esp)
c0100379:	e8 85 12 00 00       	call   c0101603 <cons_putc>
}
c010037e:	c9                   	leave  
c010037f:	c3                   	ret    

c0100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100380:	55                   	push   %ebp
c0100381:	89 e5                	mov    %esp,%ebp
c0100383:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038d:	eb 13                	jmp    c01003a2 <cputs+0x22>
        cputch(c, &cnt);
c010038f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100393:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100396:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039a:	89 04 24             	mov    %eax,(%esp)
c010039d:	e8 52 ff ff ff       	call   c01002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a5:	8d 50 01             	lea    0x1(%eax),%edx
c01003a8:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ab:	0f b6 00             	movzbl (%eax),%eax
c01003ae:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b5:	75 d8                	jne    c010038f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003be:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c5:	e8 2a ff ff ff       	call   c01002f4 <cputch>
    return cnt;
c01003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003cd:	c9                   	leave  
c01003ce:	c3                   	ret    

c01003cf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003cf:	55                   	push   %ebp
c01003d0:	89 e5                	mov    %esp,%ebp
c01003d2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d5:	e8 65 12 00 00       	call   c010163f <cons_getc>
c01003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e1:	74 f2                	je     c01003d5 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e6:	c9                   	leave  
c01003e7:	c3                   	ret    

c01003e8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e8:	55                   	push   %ebp
c01003e9:	89 e5                	mov    %esp,%ebp
c01003eb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f1:	8b 00                	mov    (%eax),%eax
c01003f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01003f9:	8b 00                	mov    (%eax),%eax
c01003fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100405:	e9 d2 00 00 00       	jmp    c01004dc <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100410:	01 d0                	add    %edx,%eax
c0100412:	89 c2                	mov    %eax,%edx
c0100414:	c1 ea 1f             	shr    $0x1f,%edx
c0100417:	01 d0                	add    %edx,%eax
c0100419:	d1 f8                	sar    %eax
c010041b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100421:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100424:	eb 04                	jmp    c010042a <stab_binsearch+0x42>
            m --;
c0100426:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100430:	7c 1f                	jl     c0100451 <stab_binsearch+0x69>
c0100432:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100435:	89 d0                	mov    %edx,%eax
c0100437:	01 c0                	add    %eax,%eax
c0100439:	01 d0                	add    %edx,%eax
c010043b:	c1 e0 02             	shl    $0x2,%eax
c010043e:	89 c2                	mov    %eax,%edx
c0100440:	8b 45 08             	mov    0x8(%ebp),%eax
c0100443:	01 d0                	add    %edx,%eax
c0100445:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100449:	0f b6 c0             	movzbl %al,%eax
c010044c:	3b 45 14             	cmp    0x14(%ebp),%eax
c010044f:	75 d5                	jne    c0100426 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100457:	7d 0b                	jge    c0100464 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045c:	83 c0 01             	add    $0x1,%eax
c010045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100462:	eb 78                	jmp    c01004dc <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100464:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046e:	89 d0                	mov    %edx,%eax
c0100470:	01 c0                	add    %eax,%eax
c0100472:	01 d0                	add    %edx,%eax
c0100474:	c1 e0 02             	shl    $0x2,%eax
c0100477:	89 c2                	mov    %eax,%edx
c0100479:	8b 45 08             	mov    0x8(%ebp),%eax
c010047c:	01 d0                	add    %edx,%eax
c010047e:	8b 40 08             	mov    0x8(%eax),%eax
c0100481:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100484:	73 13                	jae    c0100499 <stab_binsearch+0xb1>
            *region_left = m;
c0100486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100491:	83 c0 01             	add    $0x1,%eax
c0100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100497:	eb 43                	jmp    c01004dc <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 d0                	mov    %edx,%eax
c010049e:	01 c0                	add    %eax,%eax
c01004a0:	01 d0                	add    %edx,%eax
c01004a2:	c1 e0 02             	shl    $0x2,%eax
c01004a5:	89 c2                	mov    %eax,%edx
c01004a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01004aa:	01 d0                	add    %edx,%eax
c01004ac:	8b 40 08             	mov    0x8(%eax),%eax
c01004af:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b2:	76 16                	jbe    c01004ca <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01004bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c2:	83 e8 01             	sub    $0x1,%eax
c01004c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c8:	eb 12                	jmp    c01004dc <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d0:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e2:	0f 8e 22 ff ff ff    	jle    c010040a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ec:	75 0f                	jne    c01004fd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f1:	8b 00                	mov    (%eax),%eax
c01004f3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f9:	89 10                	mov    %edx,(%eax)
c01004fb:	eb 3f                	jmp    c010053c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100500:	8b 00                	mov    (%eax),%eax
c0100502:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100505:	eb 04                	jmp    c010050b <stab_binsearch+0x123>
c0100507:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050e:	8b 00                	mov    (%eax),%eax
c0100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100513:	7d 1f                	jge    c0100534 <stab_binsearch+0x14c>
c0100515:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100518:	89 d0                	mov    %edx,%eax
c010051a:	01 c0                	add    %eax,%eax
c010051c:	01 d0                	add    %edx,%eax
c010051e:	c1 e0 02             	shl    $0x2,%eax
c0100521:	89 c2                	mov    %eax,%edx
c0100523:	8b 45 08             	mov    0x8(%ebp),%eax
c0100526:	01 d0                	add    %edx,%eax
c0100528:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052c:	0f b6 c0             	movzbl %al,%eax
c010052f:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100532:	75 d3                	jne    c0100507 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100534:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053a:	89 10                	mov    %edx,(%eax)
    }
}
c010053c:	c9                   	leave  
c010053d:	c3                   	ret    

c010053e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053e:	55                   	push   %ebp
c010053f:	89 e5                	mov    %esp,%ebp
c0100541:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	c7 00 ec 62 10 c0    	movl   $0xc01062ec,(%eax)
    info->eip_line = 0;
c010054d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055a:	c7 40 08 ec 62 10 c0 	movl   $0xc01062ec,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100561:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100564:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056e:	8b 55 08             	mov    0x8(%ebp),%edx
c0100571:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057e:	c7 45 f4 4c 75 10 c0 	movl   $0xc010754c,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100585:	c7 45 f0 0c 24 11 c0 	movl   $0xc011240c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058c:	c7 45 ec 0d 24 11 c0 	movl   $0xc011240d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100593:	c7 45 e8 97 4e 11 c0 	movl   $0xc0114e97,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a0:	76 0d                	jbe    c01005af <debuginfo_eip+0x71>
c01005a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a5:	83 e8 01             	sub    $0x1,%eax
c01005a8:	0f b6 00             	movzbl (%eax),%eax
c01005ab:	84 c0                	test   %al,%al
c01005ad:	74 0a                	je     c01005b9 <debuginfo_eip+0x7b>
        return -1;
c01005af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b4:	e9 c0 02 00 00       	jmp    c0100879 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c6:	29 c2                	sub    %eax,%edx
c01005c8:	89 d0                	mov    %edx,%eax
c01005ca:	c1 f8 02             	sar    $0x2,%eax
c01005cd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d3:	83 e8 01             	sub    $0x1,%eax
c01005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dc:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e7:	00 
c01005e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005eb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 e7 fd ff ff       	call   c01003e8 <stab_binsearch>
    if (lfile == 0)
c0100601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100604:	85 c0                	test   %eax,%eax
c0100606:	75 0a                	jne    c0100612 <debuginfo_eip+0xd4>
        return -1;
c0100608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060d:	e9 67 02 00 00       	jmp    c0100879 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100615:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100618:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100621:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100625:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062c:	00 
c010062d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100630:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100634:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100637:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063e:	89 04 24             	mov    %eax,(%esp)
c0100641:	e8 a2 fd ff ff       	call   c01003e8 <stab_binsearch>

    if (lfun <= rfun) {
c0100646:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100649:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064c:	39 c2                	cmp    %eax,%edx
c010064e:	7f 7c                	jg     c01006cc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	89 d0                	mov    %edx,%eax
c0100657:	01 c0                	add    %eax,%eax
c0100659:	01 d0                	add    %edx,%eax
c010065b:	c1 e0 02             	shl    $0x2,%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100663:	01 d0                	add    %edx,%eax
c0100665:	8b 10                	mov    (%eax),%edx
c0100667:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066d:	29 c1                	sub    %eax,%ecx
c010066f:	89 c8                	mov    %ecx,%eax
c0100671:	39 c2                	cmp    %eax,%edx
c0100673:	73 22                	jae    c0100697 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100675:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	89 d0                	mov    %edx,%eax
c010067c:	01 c0                	add    %eax,%eax
c010067e:	01 d0                	add    %edx,%eax
c0100680:	c1 e0 02             	shl    $0x2,%eax
c0100683:	89 c2                	mov    %eax,%edx
c0100685:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100688:	01 d0                	add    %edx,%eax
c010068a:	8b 10                	mov    (%eax),%edx
c010068c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010068f:	01 c2                	add    %eax,%edx
c0100691:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100694:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100697:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	89 d0                	mov    %edx,%eax
c010069e:	01 c0                	add    %eax,%eax
c01006a0:	01 d0                	add    %edx,%eax
c01006a2:	c1 e0 02             	shl    $0x2,%eax
c01006a5:	89 c2                	mov    %eax,%edx
c01006a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006aa:	01 d0                	add    %edx,%eax
c01006ac:	8b 50 08             	mov    0x8(%eax),%edx
c01006af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b8:	8b 40 10             	mov    0x10(%eax),%eax
c01006bb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ca:	eb 15                	jmp    c01006e1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e4:	8b 40 08             	mov    0x8(%eax),%eax
c01006e7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ee:	00 
c01006ef:	89 04 24             	mov    %eax,(%esp)
c01006f2:	e8 1c 58 00 00       	call   c0105f13 <strfind>
c01006f7:	89 c2                	mov    %eax,%edx
c01006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fc:	8b 40 08             	mov    0x8(%eax),%eax
c01006ff:	29 c2                	sub    %eax,%edx
c0100701:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100704:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100707:	8b 45 08             	mov    0x8(%ebp),%eax
c010070a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100715:	00 
c0100716:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100719:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100720:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100727:	89 04 24             	mov    %eax,(%esp)
c010072a:	e8 b9 fc ff ff       	call   c01003e8 <stab_binsearch>
    if (lline <= rline) {
c010072f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100732:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100735:	39 c2                	cmp    %eax,%edx
c0100737:	7f 24                	jg     c010075d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	89 d0                	mov    %edx,%eax
c0100740:	01 c0                	add    %eax,%eax
c0100742:	01 d0                	add    %edx,%eax
c0100744:	c1 e0 02             	shl    $0x2,%eax
c0100747:	89 c2                	mov    %eax,%edx
c0100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074c:	01 d0                	add    %edx,%eax
c010074e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100752:	0f b7 d0             	movzwl %ax,%edx
c0100755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100758:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075b:	eb 13                	jmp    c0100770 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100762:	e9 12 01 00 00       	jmp    c0100879 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076a:	83 e8 01             	sub    $0x1,%eax
c010076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100770:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100776:	39 c2                	cmp    %eax,%edx
c0100778:	7c 56                	jl     c01007d0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	89 d0                	mov    %edx,%eax
c0100781:	01 c0                	add    %eax,%eax
c0100783:	01 d0                	add    %edx,%eax
c0100785:	c1 e0 02             	shl    $0x2,%eax
c0100788:	89 c2                	mov    %eax,%edx
c010078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078d:	01 d0                	add    %edx,%eax
c010078f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100793:	3c 84                	cmp    $0x84,%al
c0100795:	74 39                	je     c01007d0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	89 d0                	mov    %edx,%eax
c010079e:	01 c0                	add    %eax,%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	c1 e0 02             	shl    $0x2,%eax
c01007a5:	89 c2                	mov    %eax,%edx
c01007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007aa:	01 d0                	add    %edx,%eax
c01007ac:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b0:	3c 64                	cmp    $0x64,%al
c01007b2:	75 b3                	jne    c0100767 <debuginfo_eip+0x229>
c01007b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	89 d0                	mov    %edx,%eax
c01007bb:	01 c0                	add    %eax,%eax
c01007bd:	01 d0                	add    %edx,%eax
c01007bf:	c1 e0 02             	shl    $0x2,%eax
c01007c2:	89 c2                	mov    %eax,%edx
c01007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c7:	01 d0                	add    %edx,%eax
c01007c9:	8b 40 08             	mov    0x8(%eax),%eax
c01007cc:	85 c0                	test   %eax,%eax
c01007ce:	74 97                	je     c0100767 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d6:	39 c2                	cmp    %eax,%edx
c01007d8:	7c 46                	jl     c0100820 <debuginfo_eip+0x2e2>
c01007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	89 d0                	mov    %edx,%eax
c01007e1:	01 c0                	add    %eax,%eax
c01007e3:	01 d0                	add    %edx,%eax
c01007e5:	c1 e0 02             	shl    $0x2,%eax
c01007e8:	89 c2                	mov    %eax,%edx
c01007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ed:	01 d0                	add    %edx,%eax
c01007ef:	8b 10                	mov    (%eax),%edx
c01007f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f7:	29 c1                	sub    %eax,%ecx
c01007f9:	89 c8                	mov    %ecx,%eax
c01007fb:	39 c2                	cmp    %eax,%edx
c01007fd:	73 21                	jae    c0100820 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	89 d0                	mov    %edx,%eax
c0100806:	01 c0                	add    %eax,%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	c1 e0 02             	shl    $0x2,%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100812:	01 d0                	add    %edx,%eax
c0100814:	8b 10                	mov    (%eax),%edx
c0100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100819:	01 c2                	add    %eax,%edx
c010081b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100826:	39 c2                	cmp    %eax,%edx
c0100828:	7d 4a                	jge    c0100874 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082d:	83 c0 01             	add    $0x1,%eax
c0100830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100833:	eb 18                	jmp    c010084d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100838:	8b 40 14             	mov    0x14(%eax),%eax
c010083b:	8d 50 01             	lea    0x1(%eax),%edx
c010083e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100841:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100847:	83 c0 01             	add    $0x1,%eax
c010084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100850:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100853:	39 c2                	cmp    %eax,%edx
c0100855:	7d 1d                	jge    c0100874 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	89 d0                	mov    %edx,%eax
c010085e:	01 c0                	add    %eax,%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	c1 e0 02             	shl    $0x2,%eax
c0100865:	89 c2                	mov    %eax,%edx
c0100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086a:	01 d0                	add    %edx,%eax
c010086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100870:	3c a0                	cmp    $0xa0,%al
c0100872:	74 c1                	je     c0100835 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100874:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100879:	c9                   	leave  
c010087a:	c3                   	ret    

c010087b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087b:	55                   	push   %ebp
c010087c:	89 e5                	mov    %esp,%ebp
c010087e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100881:	c7 04 24 f6 62 10 c0 	movl   $0xc01062f6,(%esp)
c0100888:	e8 ba fa ff ff       	call   c0100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088d:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100894:	c0 
c0100895:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c010089c:	e8 a6 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a1:	c7 44 24 04 28 62 10 	movl   $0xc0106228,0x4(%esp)
c01008a8:	c0 
c01008a9:	c7 04 24 27 63 10 c0 	movl   $0xc0106327,(%esp)
c01008b0:	e8 92 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b5:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008bc:	c0 
c01008bd:	c7 04 24 3f 63 10 c0 	movl   $0xc010633f,(%esp)
c01008c4:	e8 7e fa ff ff       	call   c0100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c9:	c7 44 24 04 c8 89 11 	movl   $0xc01189c8,0x4(%esp)
c01008d0:	c0 
c01008d1:	c7 04 24 57 63 10 c0 	movl   $0xc0106357,(%esp)
c01008d8:	e8 6a fa ff ff       	call   c0100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008dd:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c01008e2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e8:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008ed:	29 c2                	sub    %eax,%edx
c01008ef:	89 d0                	mov    %edx,%eax
c01008f1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f7:	85 c0                	test   %eax,%eax
c01008f9:	0f 48 c2             	cmovs  %edx,%eax
c01008fc:	c1 f8 0a             	sar    $0xa,%eax
c01008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100903:	c7 04 24 70 63 10 c0 	movl   $0xc0106370,(%esp)
c010090a:	e8 38 fa ff ff       	call   c0100347 <cprintf>
}
c010090f:	c9                   	leave  
c0100910:	c3                   	ret    

c0100911 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100911:	55                   	push   %ebp
c0100912:	89 e5                	mov    %esp,%ebp
c0100914:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100921:	8b 45 08             	mov    0x8(%ebp),%eax
c0100924:	89 04 24             	mov    %eax,(%esp)
c0100927:	e8 12 fc ff ff       	call   c010053e <debuginfo_eip>
c010092c:	85 c0                	test   %eax,%eax
c010092e:	74 15                	je     c0100945 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100930:	8b 45 08             	mov    0x8(%ebp),%eax
c0100933:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100937:	c7 04 24 9a 63 10 c0 	movl   $0xc010639a,(%esp)
c010093e:	e8 04 fa ff ff       	call   c0100347 <cprintf>
c0100943:	eb 6d                	jmp    c01009b2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094c:	eb 1c                	jmp    c010096a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100954:	01 d0                	add    %edx,%eax
c0100956:	0f b6 00             	movzbl (%eax),%eax
c0100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100962:	01 ca                	add    %ecx,%edx
c0100964:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100966:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100970:	7f dc                	jg     c010094e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100972:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097b:	01 d0                	add    %edx,%eax
c010097d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100980:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100983:	8b 55 08             	mov    0x8(%ebp),%edx
c0100986:	89 d1                	mov    %edx,%ecx
c0100988:	29 c1                	sub    %eax,%ecx
c010098a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100990:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100994:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099e:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a6:	c7 04 24 b6 63 10 c0 	movl   $0xc01063b6,(%esp)
c01009ad:	e8 95 f9 ff ff       	call   c0100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b2:	c9                   	leave  
c01009b3:	c3                   	ret    

c01009b4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b4:	55                   	push   %ebp
c01009b5:	89 e5                	mov    %esp,%ebp
c01009b7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009ba:	8b 45 04             	mov    0x4(%ebp),%eax
c01009bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c3:	c9                   	leave  
c01009c4:	c3                   	ret    

c01009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c5:	55                   	push   %ebp
c01009c6:	89 e5                	mov    %esp,%ebp
c01009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cb:	89 e8                	mov    %ebp,%eax
c01009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009d6:	e8 d9 ff ff ff       	call   c01009b4 <read_eip>
c01009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e5:	e9 88 00 00 00       	jmp    c0100a72 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 c8 63 10 c0 	movl   $0xc01063c8,(%esp)
c01009ff:	e8 43 f9 ff ff       	call   c0100347 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a07:	83 c0 08             	add    $0x8,%eax
c0100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a14:	eb 25                	jmp    c0100a3b <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a23:	01 d0                	add    %edx,%eax
c0100a25:	8b 00                	mov    (%eax),%eax
c0100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2b:	c7 04 24 e4 63 10 c0 	movl   $0xc01063e4,(%esp)
c0100a32:	e8 10 f9 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3f:	7e d5                	jle    c0100a16 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a41:	c7 04 24 ec 63 10 c0 	movl   $0xc01063ec,(%esp)
c0100a48:	e8 fa f8 ff ff       	call   c0100347 <cprintf>
        print_debuginfo(eip - 1);
c0100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a50:	83 e8 01             	sub    $0x1,%eax
c0100a53:	89 04 24             	mov    %eax,(%esp)
c0100a56:	e8 b6 fe ff ff       	call   c0100911 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	83 c0 04             	add    $0x4,%eax
c0100a61:	8b 00                	mov    (%eax),%eax
c0100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a69:	8b 00                	mov    (%eax),%eax
c0100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a76:	74 0a                	je     c0100a82 <print_stackframe+0xbd>
c0100a78:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7c:	0f 8e 68 ff ff ff    	jle    c01009ea <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a82:	c9                   	leave  
c0100a83:	c3                   	ret    

c0100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a84:	55                   	push   %ebp
c0100a85:	89 e5                	mov    %esp,%ebp
c0100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a91:	eb 0c                	jmp    c0100a9f <parse+0x1b>
            *buf ++ = '\0';
c0100a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a96:	8d 50 01             	lea    0x1(%eax),%edx
c0100a99:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	0f b6 00             	movzbl (%eax),%eax
c0100aa5:	84 c0                	test   %al,%al
c0100aa7:	74 1d                	je     c0100ac6 <parse+0x42>
c0100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aac:	0f b6 00             	movzbl (%eax),%eax
c0100aaf:	0f be c0             	movsbl %al,%eax
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 70 64 10 c0 	movl   $0xc0106470,(%esp)
c0100abd:	e8 1e 54 00 00       	call   c0105ee0 <strchr>
c0100ac2:	85 c0                	test   %eax,%eax
c0100ac4:	75 cd                	jne    c0100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac9:	0f b6 00             	movzbl (%eax),%eax
c0100acc:	84 c0                	test   %al,%al
c0100ace:	75 02                	jne    c0100ad2 <parse+0x4e>
            break;
c0100ad0:	eb 67                	jmp    c0100b39 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad6:	75 14                	jne    c0100aec <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adf:	00 
c0100ae0:	c7 04 24 75 64 10 c0 	movl   $0xc0106475,(%esp)
c0100ae7:	e8 5b f8 ff ff       	call   c0100347 <cprintf>
        }
        argv[argc ++] = buf;
c0100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aef:	8d 50 01             	lea    0x1(%eax),%edx
c0100af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100aff:	01 c2                	add    %eax,%edx
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b06:	eb 04                	jmp    c0100b0c <parse+0x88>
            buf ++;
c0100b08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0f:	0f b6 00             	movzbl (%eax),%eax
c0100b12:	84 c0                	test   %al,%al
c0100b14:	74 1d                	je     c0100b33 <parse+0xaf>
c0100b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b19:	0f b6 00             	movzbl (%eax),%eax
c0100b1c:	0f be c0             	movsbl %al,%eax
c0100b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b23:	c7 04 24 70 64 10 c0 	movl   $0xc0106470,(%esp)
c0100b2a:	e8 b1 53 00 00       	call   c0105ee0 <strchr>
c0100b2f:	85 c0                	test   %eax,%eax
c0100b31:	74 d5                	je     c0100b08 <parse+0x84>
            buf ++;
        }
    }
c0100b33:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b34:	e9 66 ff ff ff       	jmp    c0100a9f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3c:	c9                   	leave  
c0100b3d:	c3                   	ret    

c0100b3e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3e:	55                   	push   %ebp
c0100b3f:	89 e5                	mov    %esp,%ebp
c0100b41:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b44:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4e:	89 04 24             	mov    %eax,(%esp)
c0100b51:	e8 2e ff ff ff       	call   c0100a84 <parse>
c0100b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5d:	75 0a                	jne    c0100b69 <runcmd+0x2b>
        return 0;
c0100b5f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b64:	e9 85 00 00 00       	jmp    c0100bee <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b70:	eb 5c                	jmp    c0100bce <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b72:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b78:	89 d0                	mov    %edx,%eax
c0100b7a:	01 c0                	add    %eax,%eax
c0100b7c:	01 d0                	add    %edx,%eax
c0100b7e:	c1 e0 02             	shl    $0x2,%eax
c0100b81:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b86:	8b 00                	mov    (%eax),%eax
c0100b88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8c:	89 04 24             	mov    %eax,(%esp)
c0100b8f:	e8 ad 52 00 00       	call   c0105e41 <strcmp>
c0100b94:	85 c0                	test   %eax,%eax
c0100b96:	75 32                	jne    c0100bca <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9b:	89 d0                	mov    %edx,%eax
c0100b9d:	01 c0                	add    %eax,%eax
c0100b9f:	01 d0                	add    %edx,%eax
c0100ba1:	c1 e0 02             	shl    $0x2,%eax
c0100ba4:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba9:	8b 40 08             	mov    0x8(%eax),%eax
c0100bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100baf:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb9:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bbc:	83 c2 04             	add    $0x4,%edx
c0100bbf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc3:	89 0c 24             	mov    %ecx,(%esp)
c0100bc6:	ff d0                	call   *%eax
c0100bc8:	eb 24                	jmp    c0100bee <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd1:	83 f8 02             	cmp    $0x2,%eax
c0100bd4:	76 9c                	jbe    c0100b72 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdd:	c7 04 24 93 64 10 c0 	movl   $0xc0106493,(%esp)
c0100be4:	e8 5e f7 ff ff       	call   c0100347 <cprintf>
    return 0;
c0100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bee:	c9                   	leave  
c0100bef:	c3                   	ret    

c0100bf0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf0:	55                   	push   %ebp
c0100bf1:	89 e5                	mov    %esp,%ebp
c0100bf3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf6:	c7 04 24 ac 64 10 c0 	movl   $0xc01064ac,(%esp)
c0100bfd:	e8 45 f7 ff ff       	call   c0100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c02:	c7 04 24 d4 64 10 c0 	movl   $0xc01064d4,(%esp)
c0100c09:	e8 39 f7 ff ff       	call   c0100347 <cprintf>

    if (tf != NULL) {
c0100c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c12:	74 0b                	je     c0100c1f <kmonitor+0x2f>
        print_trapframe(tf);
c0100c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c17:	89 04 24             	mov    %eax,(%esp)
c0100c1a:	e8 30 0e 00 00       	call   c0101a4f <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1f:	c7 04 24 f9 64 10 c0 	movl   $0xc01064f9,(%esp)
c0100c26:	e8 13 f6 ff ff       	call   c010023e <readline>
c0100c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c32:	74 18                	je     c0100c4c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3e:	89 04 24             	mov    %eax,(%esp)
c0100c41:	e8 f8 fe ff ff       	call   c0100b3e <runcmd>
c0100c46:	85 c0                	test   %eax,%eax
c0100c48:	79 02                	jns    c0100c4c <kmonitor+0x5c>
                break;
c0100c4a:	eb 02                	jmp    c0100c4e <kmonitor+0x5e>
            }
        }
    }
c0100c4c:	eb d1                	jmp    c0100c1f <kmonitor+0x2f>
}
c0100c4e:	c9                   	leave  
c0100c4f:	c3                   	ret    

c0100c50 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c50:	55                   	push   %ebp
c0100c51:	89 e5                	mov    %esp,%ebp
c0100c53:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5d:	eb 3f                	jmp    c0100c9e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c62:	89 d0                	mov    %edx,%eax
c0100c64:	01 c0                	add    %eax,%eax
c0100c66:	01 d0                	add    %edx,%eax
c0100c68:	c1 e0 02             	shl    $0x2,%eax
c0100c6b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c70:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c76:	89 d0                	mov    %edx,%eax
c0100c78:	01 c0                	add    %eax,%eax
c0100c7a:	01 d0                	add    %edx,%eax
c0100c7c:	c1 e0 02             	shl    $0x2,%eax
c0100c7f:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c84:	8b 00                	mov    (%eax),%eax
c0100c86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8e:	c7 04 24 fd 64 10 c0 	movl   $0xc01064fd,(%esp)
c0100c95:	e8 ad f6 ff ff       	call   c0100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca1:	83 f8 02             	cmp    $0x2,%eax
c0100ca4:	76 b9                	jbe    c0100c5f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cab:	c9                   	leave  
c0100cac:	c3                   	ret    

c0100cad <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cad:	55                   	push   %ebp
c0100cae:	89 e5                	mov    %esp,%ebp
c0100cb0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb3:	e8 c3 fb ff ff       	call   c010087b <print_kerninfo>
    return 0;
c0100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbd:	c9                   	leave  
c0100cbe:	c3                   	ret    

c0100cbf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbf:	55                   	push   %ebp
c0100cc0:	89 e5                	mov    %esp,%ebp
c0100cc2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc5:	e8 fb fc ff ff       	call   c01009c5 <print_stackframe>
    return 0;
c0100cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccf:	c9                   	leave  
c0100cd0:	c3                   	ret    

c0100cd1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd1:	55                   	push   %ebp
c0100cd2:	89 e5                	mov    %esp,%ebp
c0100cd4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd7:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cdc:	85 c0                	test   %eax,%eax
c0100cde:	74 02                	je     c0100ce2 <__panic+0x11>
        goto panic_dead;
c0100ce0:	eb 48                	jmp    c0100d2a <__panic+0x59>
    }
    is_panic = 1;
c0100ce2:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cec:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d00:	c7 04 24 06 65 10 c0 	movl   $0xc0106506,(%esp)
c0100d07:	e8 3b f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d13:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d16:	89 04 24             	mov    %eax,(%esp)
c0100d19:	e8 f6 f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d1e:	c7 04 24 22 65 10 c0 	movl   $0xc0106522,(%esp)
c0100d25:	e8 1d f6 ff ff       	call   c0100347 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d2a:	e8 85 09 00 00       	call   c01016b4 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d36:	e8 b5 fe ff ff       	call   c0100bf0 <kmonitor>
    }
c0100d3b:	eb f2                	jmp    c0100d2f <__panic+0x5e>

c0100d3d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d3d:	55                   	push   %ebp
c0100d3e:	89 e5                	mov    %esp,%ebp
c0100d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d43:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d57:	c7 04 24 24 65 10 c0 	movl   $0xc0106524,(%esp)
c0100d5e:	e8 e4 f5 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d6d:	89 04 24             	mov    %eax,(%esp)
c0100d70:	e8 9f f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d75:	c7 04 24 22 65 10 c0 	movl   $0xc0106522,(%esp)
c0100d7c:	e8 c6 f5 ff ff       	call   c0100347 <cprintf>
    va_end(ap);
}
c0100d81:	c9                   	leave  
c0100d82:	c3                   	ret    

c0100d83 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d83:	55                   	push   %ebp
c0100d84:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d86:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d8b:	5d                   	pop    %ebp
c0100d8c:	c3                   	ret    

c0100d8d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d8d:	55                   	push   %ebp
c0100d8e:	89 e5                	mov    %esp,%ebp
c0100d90:	83 ec 28             	sub    $0x28,%esp
c0100d93:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d99:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da5:	ee                   	out    %al,(%dx)
c0100da6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dac:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db8:	ee                   	out    %al,(%dx)
c0100db9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dcb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dcc:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dd3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd6:	c7 04 24 42 65 10 c0 	movl   $0xc0106542,(%esp)
c0100ddd:	e8 65 f5 ff ff       	call   c0100347 <cprintf>
    pic_enable(IRQ_TIMER);
c0100de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de9:	e8 24 09 00 00       	call   c0101712 <pic_enable>
}
c0100dee:	c9                   	leave  
c0100def:	c3                   	ret    

c0100df0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df0:	55                   	push   %ebp
c0100df1:	89 e5                	mov    %esp,%ebp
c0100df3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df6:	9c                   	pushf  
c0100df7:	58                   	pop    %eax
c0100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfe:	25 00 02 00 00       	and    $0x200,%eax
c0100e03:	85 c0                	test   %eax,%eax
c0100e05:	74 0c                	je     c0100e13 <__intr_save+0x23>
        intr_disable();
c0100e07:	e8 a8 08 00 00       	call   c01016b4 <intr_disable>
        return 1;
c0100e0c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e11:	eb 05                	jmp    c0100e18 <__intr_save+0x28>
    }
    return 0;
c0100e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e18:	c9                   	leave  
c0100e19:	c3                   	ret    

c0100e1a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e1a:	55                   	push   %ebp
c0100e1b:	89 e5                	mov    %esp,%ebp
c0100e1d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e24:	74 05                	je     c0100e2b <__intr_restore+0x11>
        intr_enable();
c0100e26:	e8 83 08 00 00       	call   c01016ae <intr_enable>
    }
}
c0100e2b:	c9                   	leave  
c0100e2c:	c3                   	ret    

c0100e2d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2d:	55                   	push   %ebp
c0100e2e:	89 e5                	mov    %esp,%ebp
c0100e30:	83 ec 10             	sub    $0x10,%esp
c0100e33:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e39:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e3d:	89 c2                	mov    %eax,%edx
c0100e3f:	ec                   	in     (%dx),%al
c0100e40:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e43:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e49:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4d:	89 c2                	mov    %eax,%edx
c0100e4f:	ec                   	in     (%dx),%al
c0100e50:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e53:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5d:	89 c2                	mov    %eax,%edx
c0100e5f:	ec                   	in     (%dx),%al
c0100e60:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e63:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e69:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e6d:	89 c2                	mov    %eax,%edx
c0100e6f:	ec                   	in     (%dx),%al
c0100e70:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e73:	c9                   	leave  
c0100e74:	c3                   	ret    

c0100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e75:	55                   	push   %ebp
c0100e76:	89 e5                	mov    %esp,%ebp
c0100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e85:	0f b7 00             	movzwl (%eax),%eax
c0100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 00             	movzwl (%eax),%eax
c0100e9a:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9e:	74 12                	je     c0100eb2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea7:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eae:	b4 03 
c0100eb0:	eb 13                	jmp    c0100ec5 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ebc:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ec3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ecc:	0f b7 c0             	movzwl %ax,%eax
c0100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100edb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee0:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee7:	83 c0 01             	add    $0x1,%eax
c0100eea:	0f b7 c0             	movzwl %ax,%eax
c0100eed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef5:	89 c2                	mov    %eax,%edx
c0100ef7:	ec                   	in     (%dx),%al
c0100ef8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100efb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100eff:	0f b6 c0             	movzbl %al,%eax
c0100f02:	c1 e0 08             	shl    $0x8,%eax
c0100f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f08:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0f:	0f b7 c0             	movzwl %ax,%eax
c0100f12:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f16:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f22:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f23:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f2a:	83 c0 01             	add    $0x1,%eax
c0100f2d:	0f b7 c0             	movzwl %ax,%eax
c0100f30:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f34:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f38:	89 c2                	mov    %eax,%edx
c0100f3a:	ec                   	in     (%dx),%al
c0100f3b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f42:	0f b6 c0             	movzbl %al,%eax
c0100f45:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4b:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f53:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f59:	c9                   	leave  
c0100f5a:	c3                   	ret    

c0100f5b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f5b:	55                   	push   %ebp
c0100f5c:	89 e5                	mov    %esp,%ebp
c0100f5e:	83 ec 48             	sub    $0x48,%esp
c0100f61:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f67:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f73:	ee                   	out    %al,(%dx)
c0100f74:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f7a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f82:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f86:	ee                   	out    %al,(%dx)
c0100f87:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f8d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f99:	ee                   	out    %al,(%dx)
c0100f9a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fac:	ee                   	out    %al,(%dx)
c0100fad:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbf:	ee                   	out    %al,(%dx)
c0100fc0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fce:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd2:	ee                   	out    %al,(%dx)
c0100fd3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fdd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe5:	ee                   	out    %al,(%dx)
c0100fe6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fec:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff0:	89 c2                	mov    %eax,%edx
c0100ff2:	ec                   	in     (%dx),%al
c0100ff3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ffa:	3c ff                	cmp    $0xff,%al
c0100ffc:	0f 95 c0             	setne  %al
c0100fff:	0f b6 c0             	movzbl %al,%eax
c0101002:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101007:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101011:	89 c2                	mov    %eax,%edx
c0101013:	ec                   	in     (%dx),%al
c0101014:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101017:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010101d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101021:	89 c2                	mov    %eax,%edx
c0101023:	ec                   	in     (%dx),%al
c0101024:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101027:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010102c:	85 c0                	test   %eax,%eax
c010102e:	74 0c                	je     c010103c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101030:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101037:	e8 d6 06 00 00       	call   c0101712 <pic_enable>
    }
}
c010103c:	c9                   	leave  
c010103d:	c3                   	ret    

c010103e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103e:	55                   	push   %ebp
c010103f:	89 e5                	mov    %esp,%ebp
c0101041:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104b:	eb 09                	jmp    c0101056 <lpt_putc_sub+0x18>
        delay();
c010104d:	e8 db fd ff ff       	call   c0100e2d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101052:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101056:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101060:	89 c2                	mov    %eax,%edx
c0101062:	ec                   	in     (%dx),%al
c0101063:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101066:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010106a:	84 c0                	test   %al,%al
c010106c:	78 09                	js     c0101077 <lpt_putc_sub+0x39>
c010106e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101075:	7e d6                	jle    c010104d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101077:	8b 45 08             	mov    0x8(%ebp),%eax
c010107a:	0f b6 c0             	movzbl %al,%eax
c010107d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101083:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101086:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010108a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108e:	ee                   	out    %al,(%dx)
c010108f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101095:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101099:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a1:	ee                   	out    %al,(%dx)
c01010a2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b5:	c9                   	leave  
c01010b6:	c3                   	ret    

c01010b7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b7:	55                   	push   %ebp
c01010b8:	89 e5                	mov    %esp,%ebp
c01010ba:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010bd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c1:	74 0d                	je     c01010d0 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c6:	89 04 24             	mov    %eax,(%esp)
c01010c9:	e8 70 ff ff ff       	call   c010103e <lpt_putc_sub>
c01010ce:	eb 24                	jmp    c01010f4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d7:	e8 62 ff ff ff       	call   c010103e <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010dc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e3:	e8 56 ff ff ff       	call   c010103e <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ef:	e8 4a ff ff ff       	call   c010103e <lpt_putc_sub>
    }
}
c01010f4:	c9                   	leave  
c01010f5:	c3                   	ret    

c01010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f6:	55                   	push   %ebp
c01010f7:	89 e5                	mov    %esp,%ebp
c01010f9:	53                   	push   %ebx
c01010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101100:	b0 00                	mov    $0x0,%al
c0101102:	85 c0                	test   %eax,%eax
c0101104:	75 07                	jne    c010110d <cga_putc+0x17>
        c |= 0x0700;
c0101106:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010110d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101110:	0f b6 c0             	movzbl %al,%eax
c0101113:	83 f8 0a             	cmp    $0xa,%eax
c0101116:	74 4c                	je     c0101164 <cga_putc+0x6e>
c0101118:	83 f8 0d             	cmp    $0xd,%eax
c010111b:	74 57                	je     c0101174 <cga_putc+0x7e>
c010111d:	83 f8 08             	cmp    $0x8,%eax
c0101120:	0f 85 88 00 00 00    	jne    c01011ae <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101126:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112d:	66 85 c0             	test   %ax,%ax
c0101130:	74 30                	je     c0101162 <cga_putc+0x6c>
            crt_pos --;
c0101132:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101139:	83 e8 01             	sub    $0x1,%eax
c010113c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101142:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101147:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010114e:	0f b7 d2             	movzwl %dx,%edx
c0101151:	01 d2                	add    %edx,%edx
c0101153:	01 c2                	add    %eax,%edx
c0101155:	8b 45 08             	mov    0x8(%ebp),%eax
c0101158:	b0 00                	mov    $0x0,%al
c010115a:	83 c8 20             	or     $0x20,%eax
c010115d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101160:	eb 72                	jmp    c01011d4 <cga_putc+0xde>
c0101162:	eb 70                	jmp    c01011d4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101164:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010116b:	83 c0 50             	add    $0x50,%eax
c010116e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101174:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010117b:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101182:	0f b7 c1             	movzwl %cx,%eax
c0101185:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010118b:	c1 e8 10             	shr    $0x10,%eax
c010118e:	89 c2                	mov    %eax,%edx
c0101190:	66 c1 ea 06          	shr    $0x6,%dx
c0101194:	89 d0                	mov    %edx,%eax
c0101196:	c1 e0 02             	shl    $0x2,%eax
c0101199:	01 d0                	add    %edx,%eax
c010119b:	c1 e0 04             	shl    $0x4,%eax
c010119e:	29 c1                	sub    %eax,%ecx
c01011a0:	89 ca                	mov    %ecx,%edx
c01011a2:	89 d8                	mov    %ebx,%eax
c01011a4:	29 d0                	sub    %edx,%eax
c01011a6:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011ac:	eb 26                	jmp    c01011d4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ae:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011b4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011bb:	8d 50 01             	lea    0x1(%eax),%edx
c01011be:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011c5:	0f b7 c0             	movzwl %ax,%eax
c01011c8:	01 c0                	add    %eax,%eax
c01011ca:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d0:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011db:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011df:	76 5b                	jbe    c010123c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ec:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011f1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f8:	00 
c01011f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011fd:	89 04 24             	mov    %eax,(%esp)
c0101200:	e8 d9 4e 00 00       	call   c01060de <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101205:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120c:	eb 15                	jmp    c0101223 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120e:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101213:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101216:	01 d2                	add    %edx,%edx
c0101218:	01 d0                	add    %edx,%eax
c010121a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122a:	7e e2                	jle    c010120e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010122c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101233:	83 e8 50             	sub    $0x50,%eax
c0101236:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101243:	0f b7 c0             	movzwl %ax,%eax
c0101246:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010124a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101252:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101257:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010125e:	66 c1 e8 08          	shr    $0x8,%ax
c0101262:	0f b6 c0             	movzbl %al,%eax
c0101265:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010126c:	83 c2 01             	add    $0x1,%edx
c010126f:	0f b7 d2             	movzwl %dx,%edx
c0101272:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101276:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101279:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010127d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101282:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101289:	0f b7 c0             	movzwl %ax,%eax
c010128c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101290:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101294:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101298:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010129d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012a4:	0f b6 c0             	movzbl %al,%eax
c01012a7:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012ae:	83 c2 01             	add    $0x1,%edx
c01012b1:	0f b7 d2             	movzwl %dx,%edx
c01012b4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c3:	ee                   	out    %al,(%dx)
}
c01012c4:	83 c4 34             	add    $0x34,%esp
c01012c7:	5b                   	pop    %ebx
c01012c8:	5d                   	pop    %ebp
c01012c9:	c3                   	ret    

c01012ca <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ca:	55                   	push   %ebp
c01012cb:	89 e5                	mov    %esp,%ebp
c01012cd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d7:	eb 09                	jmp    c01012e2 <serial_putc_sub+0x18>
        delay();
c01012d9:	e8 4f fb ff ff       	call   c0100e2d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ec:	89 c2                	mov    %eax,%edx
c01012ee:	ec                   	in     (%dx),%al
c01012ef:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f6:	0f b6 c0             	movzbl %al,%eax
c01012f9:	83 e0 20             	and    $0x20,%eax
c01012fc:	85 c0                	test   %eax,%eax
c01012fe:	75 09                	jne    c0101309 <serial_putc_sub+0x3f>
c0101300:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101307:	7e d0                	jle    c01012d9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101309:	8b 45 08             	mov    0x8(%ebp),%eax
c010130c:	0f b6 c0             	movzbl %al,%eax
c010130f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101315:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101318:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010131c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101320:	ee                   	out    %al,(%dx)
}
c0101321:	c9                   	leave  
c0101322:	c3                   	ret    

c0101323 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101323:	55                   	push   %ebp
c0101324:	89 e5                	mov    %esp,%ebp
c0101326:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101329:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010132d:	74 0d                	je     c010133c <serial_putc+0x19>
        serial_putc_sub(c);
c010132f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101332:	89 04 24             	mov    %eax,(%esp)
c0101335:	e8 90 ff ff ff       	call   c01012ca <serial_putc_sub>
c010133a:	eb 24                	jmp    c0101360 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010133c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101343:	e8 82 ff ff ff       	call   c01012ca <serial_putc_sub>
        serial_putc_sub(' ');
c0101348:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134f:	e8 76 ff ff ff       	call   c01012ca <serial_putc_sub>
        serial_putc_sub('\b');
c0101354:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135b:	e8 6a ff ff ff       	call   c01012ca <serial_putc_sub>
    }
}
c0101360:	c9                   	leave  
c0101361:	c3                   	ret    

c0101362 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101362:	55                   	push   %ebp
c0101363:	89 e5                	mov    %esp,%ebp
c0101365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101368:	eb 33                	jmp    c010139d <cons_intr+0x3b>
        if (c != 0) {
c010136a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136e:	74 2d                	je     c010139d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101370:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101375:	8d 50 01             	lea    0x1(%eax),%edx
c0101378:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101381:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101387:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010138c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101391:	75 0a                	jne    c010139d <cons_intr+0x3b>
                cons.wpos = 0;
c0101393:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010139a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010139d:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a0:	ff d0                	call   *%eax
c01013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a9:	75 bf                	jne    c010136a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013ab:	c9                   	leave  
c01013ac:	c3                   	ret    

c01013ad <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ad:	55                   	push   %ebp
c01013ae:	89 e5                	mov    %esp,%ebp
c01013b0:	83 ec 10             	sub    $0x10,%esp
c01013b3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bd:	89 c2                	mov    %eax,%edx
c01013bf:	ec                   	in     (%dx),%al
c01013c0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c7:	0f b6 c0             	movzbl %al,%eax
c01013ca:	83 e0 01             	and    $0x1,%eax
c01013cd:	85 c0                	test   %eax,%eax
c01013cf:	75 07                	jne    c01013d8 <serial_proc_data+0x2b>
        return -1;
c01013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d6:	eb 2a                	jmp    c0101402 <serial_proc_data+0x55>
c01013d8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013de:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e2:	89 c2                	mov    %eax,%edx
c01013e4:	ec                   	in     (%dx),%al
c01013e5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ec:	0f b6 c0             	movzbl %al,%eax
c01013ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f6:	75 07                	jne    c01013ff <serial_proc_data+0x52>
        c = '\b';
c01013f8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101402:	c9                   	leave  
c0101403:	c3                   	ret    

c0101404 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101404:	55                   	push   %ebp
c0101405:	89 e5                	mov    %esp,%ebp
c0101407:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010140a:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010140f:	85 c0                	test   %eax,%eax
c0101411:	74 0c                	je     c010141f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101413:	c7 04 24 ad 13 10 c0 	movl   $0xc01013ad,(%esp)
c010141a:	e8 43 ff ff ff       	call   c0101362 <cons_intr>
    }
}
c010141f:	c9                   	leave  
c0101420:	c3                   	ret    

c0101421 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101421:	55                   	push   %ebp
c0101422:	89 e5                	mov    %esp,%ebp
c0101424:	83 ec 38             	sub    $0x38,%esp
c0101427:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101431:	89 c2                	mov    %eax,%edx
c0101433:	ec                   	in     (%dx),%al
c0101434:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101437:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010143b:	0f b6 c0             	movzbl %al,%eax
c010143e:	83 e0 01             	and    $0x1,%eax
c0101441:	85 c0                	test   %eax,%eax
c0101443:	75 0a                	jne    c010144f <kbd_proc_data+0x2e>
        return -1;
c0101445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144a:	e9 59 01 00 00       	jmp    c01015a8 <kbd_proc_data+0x187>
c010144f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101455:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101459:	89 c2                	mov    %eax,%edx
c010145b:	ec                   	in     (%dx),%al
c010145c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101463:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101466:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010146a:	75 17                	jne    c0101483 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101471:	83 c8 40             	or     $0x40,%eax
c0101474:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101479:	b8 00 00 00 00       	mov    $0x0,%eax
c010147e:	e9 25 01 00 00       	jmp    c01015a8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101487:	84 c0                	test   %al,%al
c0101489:	79 47                	jns    c01014d2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010148b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101490:	83 e0 40             	and    $0x40,%eax
c0101493:	85 c0                	test   %eax,%eax
c0101495:	75 09                	jne    c01014a0 <kbd_proc_data+0x7f>
c0101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149b:	83 e0 7f             	and    $0x7f,%eax
c010149e:	eb 04                	jmp    c01014a4 <kbd_proc_data+0x83>
c01014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ab:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014b2:	83 c8 40             	or     $0x40,%eax
c01014b5:	0f b6 c0             	movzbl %al,%eax
c01014b8:	f7 d0                	not    %eax
c01014ba:	89 c2                	mov    %eax,%edx
c01014bc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c1:	21 d0                	and    %edx,%eax
c01014c3:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cd:	e9 d6 00 00 00       	jmp    c01015a8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d7:	83 e0 40             	and    $0x40,%eax
c01014da:	85 c0                	test   %eax,%eax
c01014dc:	74 11                	je     c01014ef <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014de:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e7:	83 e0 bf             	and    $0xffffffbf,%eax
c01014ea:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f3:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014fa:	0f b6 d0             	movzbl %al,%edx
c01014fd:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101502:	09 d0                	or     %edx,%eax
c0101504:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150d:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101514:	0f b6 d0             	movzbl %al,%edx
c0101517:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151c:	31 d0                	xor    %edx,%eax
c010151e:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101523:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101528:	83 e0 03             	and    $0x3,%eax
c010152b:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101532:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101536:	01 d0                	add    %edx,%eax
c0101538:	0f b6 00             	movzbl (%eax),%eax
c010153b:	0f b6 c0             	movzbl %al,%eax
c010153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101541:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101546:	83 e0 08             	and    $0x8,%eax
c0101549:	85 c0                	test   %eax,%eax
c010154b:	74 22                	je     c010156f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101551:	7e 0c                	jle    c010155f <kbd_proc_data+0x13e>
c0101553:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101557:	7f 06                	jg     c010155f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101559:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155d:	eb 10                	jmp    c010156f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101563:	7e 0a                	jle    c010156f <kbd_proc_data+0x14e>
c0101565:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101569:	7f 04                	jg     c010156f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010156b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101574:	f7 d0                	not    %eax
c0101576:	83 e0 06             	and    $0x6,%eax
c0101579:	85 c0                	test   %eax,%eax
c010157b:	75 28                	jne    c01015a5 <kbd_proc_data+0x184>
c010157d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101584:	75 1f                	jne    c01015a5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101586:	c7 04 24 5d 65 10 c0 	movl   $0xc010655d,(%esp)
c010158d:	e8 b5 ed ff ff       	call   c0100347 <cprintf>
c0101592:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101598:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a8:	c9                   	leave  
c01015a9:	c3                   	ret    

c01015aa <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015aa:	55                   	push   %ebp
c01015ab:	89 e5                	mov    %esp,%ebp
c01015ad:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b0:	c7 04 24 21 14 10 c0 	movl   $0xc0101421,(%esp)
c01015b7:	e8 a6 fd ff ff       	call   c0101362 <cons_intr>
}
c01015bc:	c9                   	leave  
c01015bd:	c3                   	ret    

c01015be <kbd_init>:

static void
kbd_init(void) {
c01015be:	55                   	push   %ebp
c01015bf:	89 e5                	mov    %esp,%ebp
c01015c1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c4:	e8 e1 ff ff ff       	call   c01015aa <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d0:	e8 3d 01 00 00       	call   c0101712 <pic_enable>
}
c01015d5:	c9                   	leave  
c01015d6:	c3                   	ret    

c01015d7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d7:	55                   	push   %ebp
c01015d8:	89 e5                	mov    %esp,%ebp
c01015da:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015dd:	e8 93 f8 ff ff       	call   c0100e75 <cga_init>
    serial_init();
c01015e2:	e8 74 f9 ff ff       	call   c0100f5b <serial_init>
    kbd_init();
c01015e7:	e8 d2 ff ff ff       	call   c01015be <kbd_init>
    if (!serial_exists) {
c01015ec:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015f1:	85 c0                	test   %eax,%eax
c01015f3:	75 0c                	jne    c0101601 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f5:	c7 04 24 69 65 10 c0 	movl   $0xc0106569,(%esp)
c01015fc:	e8 46 ed ff ff       	call   c0100347 <cprintf>
    }
}
c0101601:	c9                   	leave  
c0101602:	c3                   	ret    

c0101603 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101603:	55                   	push   %ebp
c0101604:	89 e5                	mov    %esp,%ebp
c0101606:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101609:	e8 e2 f7 ff ff       	call   c0100df0 <__intr_save>
c010160e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 9b fa ff ff       	call   c01010b7 <lpt_putc>
        cga_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 cf fa ff ff       	call   c01010f6 <cga_putc>
        serial_putc(c);
c0101627:	8b 45 08             	mov    0x8(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 f1 fc ff ff       	call   c0101323 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101632:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 dd f7 ff ff       	call   c0100e1a <__intr_restore>
}
c010163d:	c9                   	leave  
c010163e:	c3                   	ret    

c010163f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163f:	55                   	push   %ebp
c0101640:	89 e5                	mov    %esp,%ebp
c0101642:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164c:	e8 9f f7 ff ff       	call   c0100df0 <__intr_save>
c0101651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101654:	e8 ab fd ff ff       	call   c0101404 <serial_intr>
        kbd_intr();
c0101659:	e8 4c ff ff ff       	call   c01015aa <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165e:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101664:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101669:	39 c2                	cmp    %eax,%edx
c010166b:	74 31                	je     c010169e <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010166d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101672:	8d 50 01             	lea    0x1(%eax),%edx
c0101675:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010167b:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101682:	0f b6 c0             	movzbl %al,%eax
c0101685:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101688:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010168d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101692:	75 0a                	jne    c010169e <cons_getc+0x5f>
                cons.rpos = 0;
c0101694:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010169b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a1:	89 04 24             	mov    %eax,(%esp)
c01016a4:	e8 71 f7 ff ff       	call   c0100e1a <__intr_restore>
    return c;
c01016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ac:	c9                   	leave  
c01016ad:	c3                   	ret    

c01016ae <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016b1:	fb                   	sti    
    sti();
}
c01016b2:	5d                   	pop    %ebp
c01016b3:	c3                   	ret    

c01016b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b4:	55                   	push   %ebp
c01016b5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b7:	fa                   	cli    
    cli();
}
c01016b8:	5d                   	pop    %ebp
c01016b9:	c3                   	ret    

c01016ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 14             	sub    $0x14,%esp
c01016c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cb:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016d1:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d6:	85 c0                	test   %eax,%eax
c01016d8:	74 36                	je     c0101710 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016da:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016de:	0f b6 c0             	movzbl %al,%eax
c01016e1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016ea:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ee:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016f2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f7:	66 c1 e8 08          	shr    $0x8,%ax
c01016fb:	0f b6 c0             	movzbl %al,%eax
c01016fe:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101704:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101707:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010170b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170f:	ee                   	out    %al,(%dx)
    }
}
c0101710:	c9                   	leave  
c0101711:	c3                   	ret    

c0101712 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101712:	55                   	push   %ebp
c0101713:	89 e5                	mov    %esp,%ebp
c0101715:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101718:	8b 45 08             	mov    0x8(%ebp),%eax
c010171b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101720:	89 c1                	mov    %eax,%ecx
c0101722:	d3 e2                	shl    %cl,%edx
c0101724:	89 d0                	mov    %edx,%eax
c0101726:	f7 d0                	not    %eax
c0101728:	89 c2                	mov    %eax,%edx
c010172a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101731:	21 d0                	and    %edx,%eax
c0101733:	0f b7 c0             	movzwl %ax,%eax
c0101736:	89 04 24             	mov    %eax,(%esp)
c0101739:	e8 7c ff ff ff       	call   c01016ba <pic_setmask>
}
c010173e:	c9                   	leave  
c010173f:	c3                   	ret    

c0101740 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101740:	55                   	push   %ebp
c0101741:	89 e5                	mov    %esp,%ebp
c0101743:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101746:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010174d:	00 00 00 
c0101750:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101756:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010175a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101762:	ee                   	out    %al,(%dx)
c0101763:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101769:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010176d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101771:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101775:	ee                   	out    %al,(%dx)
c0101776:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010177c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101780:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101784:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101788:	ee                   	out    %al,(%dx)
c0101789:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101793:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101797:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010179b:	ee                   	out    %al,(%dx)
c010179c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017a2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ae:	ee                   	out    %al,(%dx)
c01017af:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017bd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017c1:	ee                   	out    %al,(%dx)
c01017c2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017cc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017d0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d4:	ee                   	out    %al,(%dx)
c01017d5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017db:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017df:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017e3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e7:	ee                   	out    %al,(%dx)
c01017e8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ee:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017f2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017fa:	ee                   	out    %al,(%dx)
c01017fb:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101801:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101805:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101809:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010180d:	ee                   	out    %al,(%dx)
c010180e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101814:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101818:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010181c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101820:	ee                   	out    %al,(%dx)
c0101821:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101827:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010182b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101833:	ee                   	out    %al,(%dx)
c0101834:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010183a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101842:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101846:	ee                   	out    %al,(%dx)
c0101847:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010184d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101851:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101855:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101859:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010185a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101861:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101865:	74 12                	je     c0101879 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101867:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010186e:	0f b7 c0             	movzwl %ax,%eax
c0101871:	89 04 24             	mov    %eax,(%esp)
c0101874:	e8 41 fe ff ff       	call   c01016ba <pic_setmask>
    }
}
c0101879:	c9                   	leave  
c010187a:	c3                   	ret    

c010187b <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
c010187b:	55                   	push   %ebp
c010187c:	89 e5                	mov    %esp,%ebp
c010187e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101881:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101888:	00 
c0101889:	c7 04 24 a0 65 10 c0 	movl   $0xc01065a0,(%esp)
c0101890:	e8 b2 ea ff ff       	call   c0100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101895:	c9                   	leave  
c0101896:	c3                   	ret    

c0101897 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101897:	55                   	push   %ebp
c0101898:	89 e5                	mov    %esp,%ebp
c010189a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010189d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a4:	e9 c3 00 00 00       	jmp    c010196c <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ac:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018b3:	89 c2                	mov    %eax,%edx
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018bf:	c0 
c01018c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c3:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018ca:	c0 08 00 
c01018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d0:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018d7:	c0 
c01018d8:	83 e2 e0             	and    $0xffffffe0,%edx
c01018db:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e5:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018ec:	c0 
c01018ed:	83 e2 1f             	and    $0x1f,%edx
c01018f0:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fa:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101901:	c0 
c0101902:	83 e2 f0             	and    $0xfffffff0,%edx
c0101905:	83 ca 0e             	or     $0xe,%edx
c0101908:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101912:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101919:	c0 
c010191a:	83 e2 ef             	and    $0xffffffef,%edx
c010191d:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101924:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101927:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192e:	c0 
c010192f:	83 e2 9f             	and    $0xffffff9f,%edx
c0101932:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101939:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101943:	c0 
c0101944:	83 ca 80             	or     $0xffffff80,%edx
c0101947:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101951:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101958:	c1 e8 10             	shr    $0x10,%eax
c010195b:	89 c2                	mov    %eax,%edx
c010195d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101960:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101967:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101968:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196f:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101974:	0f 86 2f ff ff ff    	jbe    c01018a9 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010197a:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c010197f:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101985:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c010198c:	08 00 
c010198e:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101995:	83 e0 e0             	and    $0xffffffe0,%eax
c0101998:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c010199d:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019a4:	83 e0 1f             	and    $0x1f,%eax
c01019a7:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019ac:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019b3:	83 e0 f0             	and    $0xfffffff0,%eax
c01019b6:	83 c8 0e             	or     $0xe,%eax
c01019b9:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019be:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c5:	83 e0 ef             	and    $0xffffffef,%eax
c01019c8:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019cd:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d4:	83 c8 60             	or     $0x60,%eax
c01019d7:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019dc:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019e3:	83 c8 80             	or     $0xffffff80,%eax
c01019e6:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019eb:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019f0:	c1 e8 10             	shr    $0x10,%eax
c01019f3:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019f9:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a03:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
c0101a06:	c9                   	leave  
c0101a07:	c3                   	ret    

c0101a08 <trapname>:

static const char *
trapname(int trapno) {
c0101a08:	55                   	push   %ebp
c0101a09:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0e:	83 f8 13             	cmp    $0x13,%eax
c0101a11:	77 0c                	ja     c0101a1f <trapname+0x17>
        return excnames[trapno];
c0101a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a16:	8b 04 85 00 69 10 c0 	mov    -0x3fef9700(,%eax,4),%eax
c0101a1d:	eb 18                	jmp    c0101a37 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a1f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a23:	7e 0d                	jle    c0101a32 <trapname+0x2a>
c0101a25:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a29:	7f 07                	jg     c0101a32 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a2b:	b8 aa 65 10 c0       	mov    $0xc01065aa,%eax
c0101a30:	eb 05                	jmp    c0101a37 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a32:	b8 bd 65 10 c0       	mov    $0xc01065bd,%eax
}
c0101a37:	5d                   	pop    %ebp
c0101a38:	c3                   	ret    

c0101a39 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a39:	55                   	push   %ebp
c0101a3a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a43:	66 83 f8 08          	cmp    $0x8,%ax
c0101a47:	0f 94 c0             	sete   %al
c0101a4a:	0f b6 c0             	movzbl %al,%eax
}
c0101a4d:	5d                   	pop    %ebp
c0101a4e:	c3                   	ret    

c0101a4f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a4f:	55                   	push   %ebp
c0101a50:	89 e5                	mov    %esp,%ebp
c0101a52:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a5c:	c7 04 24 fe 65 10 c0 	movl   $0xc01065fe,(%esp)
c0101a63:	e8 df e8 ff ff       	call   c0100347 <cprintf>
    print_regs(&tf->tf_regs);
c0101a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6b:	89 04 24             	mov    %eax,(%esp)
c0101a6e:	e8 a1 01 00 00       	call   c0101c14 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a76:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a7a:	0f b7 c0             	movzwl %ax,%eax
c0101a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a81:	c7 04 24 0f 66 10 c0 	movl   $0xc010660f,(%esp)
c0101a88:	e8 ba e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a90:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a94:	0f b7 c0             	movzwl %ax,%eax
c0101a97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9b:	c7 04 24 22 66 10 c0 	movl   $0xc0106622,(%esp)
c0101aa2:	e8 a0 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aaa:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aae:	0f b7 c0             	movzwl %ax,%eax
c0101ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab5:	c7 04 24 35 66 10 c0 	movl   $0xc0106635,(%esp)
c0101abc:	e8 86 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ac8:	0f b7 c0             	movzwl %ax,%eax
c0101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101acf:	c7 04 24 48 66 10 c0 	movl   $0xc0106648,(%esp)
c0101ad6:	e8 6c e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ade:	8b 40 30             	mov    0x30(%eax),%eax
c0101ae1:	89 04 24             	mov    %eax,(%esp)
c0101ae4:	e8 1f ff ff ff       	call   c0101a08 <trapname>
c0101ae9:	8b 55 08             	mov    0x8(%ebp),%edx
c0101aec:	8b 52 30             	mov    0x30(%edx),%edx
c0101aef:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101af3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101af7:	c7 04 24 5b 66 10 c0 	movl   $0xc010665b,(%esp)
c0101afe:	e8 44 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b06:	8b 40 34             	mov    0x34(%eax),%eax
c0101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0d:	c7 04 24 6d 66 10 c0 	movl   $0xc010666d,(%esp)
c0101b14:	e8 2e e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1c:	8b 40 38             	mov    0x38(%eax),%eax
c0101b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b23:	c7 04 24 7c 66 10 c0 	movl   $0xc010667c,(%esp)
c0101b2a:	e8 18 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b36:	0f b7 c0             	movzwl %ax,%eax
c0101b39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3d:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0101b44:	e8 fe e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4c:	8b 40 40             	mov    0x40(%eax),%eax
c0101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b53:	c7 04 24 9e 66 10 c0 	movl   $0xc010669e,(%esp)
c0101b5a:	e8 e8 e7 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b66:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b6d:	eb 3e                	jmp    c0101bad <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b72:	8b 50 40             	mov    0x40(%eax),%edx
c0101b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b78:	21 d0                	and    %edx,%eax
c0101b7a:	85 c0                	test   %eax,%eax
c0101b7c:	74 28                	je     c0101ba6 <print_trapframe+0x157>
c0101b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b81:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b88:	85 c0                	test   %eax,%eax
c0101b8a:	74 1a                	je     c0101ba6 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b8f:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9a:	c7 04 24 ad 66 10 c0 	movl   $0xc01066ad,(%esp)
c0101ba1:	e8 a1 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101baa:	d1 65 f0             	shll   -0x10(%ebp)
c0101bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb0:	83 f8 17             	cmp    $0x17,%eax
c0101bb3:	76 ba                	jbe    c0101b6f <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb8:	8b 40 40             	mov    0x40(%eax),%eax
c0101bbb:	25 00 30 00 00       	and    $0x3000,%eax
c0101bc0:	c1 e8 0c             	shr    $0xc,%eax
c0101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc7:	c7 04 24 b1 66 10 c0 	movl   $0xc01066b1,(%esp)
c0101bce:	e8 74 e7 ff ff       	call   c0100347 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd6:	89 04 24             	mov    %eax,(%esp)
c0101bd9:	e8 5b fe ff ff       	call   c0101a39 <trap_in_kernel>
c0101bde:	85 c0                	test   %eax,%eax
c0101be0:	75 30                	jne    c0101c12 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be5:	8b 40 44             	mov    0x44(%eax),%eax
c0101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bec:	c7 04 24 ba 66 10 c0 	movl   $0xc01066ba,(%esp)
c0101bf3:	e8 4f e7 ff ff       	call   c0100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bff:	0f b7 c0             	movzwl %ax,%eax
c0101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c06:	c7 04 24 c9 66 10 c0 	movl   $0xc01066c9,(%esp)
c0101c0d:	e8 35 e7 ff ff       	call   c0100347 <cprintf>
    }
}
c0101c12:	c9                   	leave  
c0101c13:	c3                   	ret    

c0101c14 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c14:	55                   	push   %ebp
c0101c15:	89 e5                	mov    %esp,%ebp
c0101c17:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1d:	8b 00                	mov    (%eax),%eax
c0101c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c23:	c7 04 24 dc 66 10 c0 	movl   $0xc01066dc,(%esp)
c0101c2a:	e8 18 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c32:	8b 40 04             	mov    0x4(%eax),%eax
c0101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c39:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0101c40:	e8 02 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c48:	8b 40 08             	mov    0x8(%eax),%eax
c0101c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4f:	c7 04 24 fa 66 10 c0 	movl   $0xc01066fa,(%esp)
c0101c56:	e8 ec e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5e:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c65:	c7 04 24 09 67 10 c0 	movl   $0xc0106709,(%esp)
c0101c6c:	e8 d6 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c74:	8b 40 10             	mov    0x10(%eax),%eax
c0101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7b:	c7 04 24 18 67 10 c0 	movl   $0xc0106718,(%esp)
c0101c82:	e8 c0 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8a:	8b 40 14             	mov    0x14(%eax),%eax
c0101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c91:	c7 04 24 27 67 10 c0 	movl   $0xc0106727,(%esp)
c0101c98:	e8 aa e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca0:	8b 40 18             	mov    0x18(%eax),%eax
c0101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca7:	c7 04 24 36 67 10 c0 	movl   $0xc0106736,(%esp)
c0101cae:	e8 94 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb6:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbd:	c7 04 24 45 67 10 c0 	movl   $0xc0106745,(%esp)
c0101cc4:	e8 7e e6 ff ff       	call   c0100347 <cprintf>
}
c0101cc9:	c9                   	leave  
c0101cca:	c3                   	ret    

c0101ccb <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ccb:	55                   	push   %ebp
c0101ccc:	89 e5                	mov    %esp,%ebp
c0101cce:	57                   	push   %edi
c0101ccf:	56                   	push   %esi
c0101cd0:	53                   	push   %ebx
c0101cd1:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd7:	8b 40 30             	mov    0x30(%eax),%eax
c0101cda:	83 f8 2f             	cmp    $0x2f,%eax
c0101cdd:	77 21                	ja     c0101d00 <trap_dispatch+0x35>
c0101cdf:	83 f8 2e             	cmp    $0x2e,%eax
c0101ce2:	0f 83 ec 01 00 00    	jae    c0101ed4 <trap_dispatch+0x209>
c0101ce8:	83 f8 21             	cmp    $0x21,%eax
c0101ceb:	0f 84 8a 00 00 00    	je     c0101d7b <trap_dispatch+0xb0>
c0101cf1:	83 f8 24             	cmp    $0x24,%eax
c0101cf4:	74 5c                	je     c0101d52 <trap_dispatch+0x87>
c0101cf6:	83 f8 20             	cmp    $0x20,%eax
c0101cf9:	74 1c                	je     c0101d17 <trap_dispatch+0x4c>
c0101cfb:	e9 9c 01 00 00       	jmp    c0101e9c <trap_dispatch+0x1d1>
c0101d00:	83 f8 78             	cmp    $0x78,%eax
c0101d03:	0f 84 9b 00 00 00    	je     c0101da4 <trap_dispatch+0xd9>
c0101d09:	83 f8 79             	cmp    $0x79,%eax
c0101d0c:	0f 84 11 01 00 00    	je     c0101e23 <trap_dispatch+0x158>
c0101d12:	e9 85 01 00 00       	jmp    c0101e9c <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d17:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d1c:	83 c0 01             	add    $0x1,%eax
c0101d1f:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101d24:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d2a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d2f:	89 c8                	mov    %ecx,%eax
c0101d31:	f7 e2                	mul    %edx
c0101d33:	89 d0                	mov    %edx,%eax
c0101d35:	c1 e8 05             	shr    $0x5,%eax
c0101d38:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d3b:	29 c1                	sub    %eax,%ecx
c0101d3d:	89 c8                	mov    %ecx,%eax
c0101d3f:	85 c0                	test   %eax,%eax
c0101d41:	75 0a                	jne    c0101d4d <trap_dispatch+0x82>
            print_ticks();
c0101d43:	e8 33 fb ff ff       	call   c010187b <print_ticks>
        }
        break;
c0101d48:	e9 88 01 00 00       	jmp    c0101ed5 <trap_dispatch+0x20a>
c0101d4d:	e9 83 01 00 00       	jmp    c0101ed5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d52:	e8 e8 f8 ff ff       	call   c010163f <cons_getc>
c0101d57:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d5a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d5e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d62:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6a:	c7 04 24 54 67 10 c0 	movl   $0xc0106754,(%esp)
c0101d71:	e8 d1 e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101d76:	e9 5a 01 00 00       	jmp    c0101ed5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d7b:	e8 bf f8 ff ff       	call   c010163f <cons_getc>
c0101d80:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d83:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d87:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d93:	c7 04 24 66 67 10 c0 	movl   $0xc0106766,(%esp)
c0101d9a:	e8 a8 e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101d9f:	e9 31 01 00 00       	jmp    c0101ed5 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dab:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101daf:	74 6d                	je     c0101e1e <trap_dispatch+0x153>
            switchk2u = *tf;
c0101db1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db4:	ba 60 89 11 c0       	mov    $0xc0118960,%edx
c0101db9:	89 c3                	mov    %eax,%ebx
c0101dbb:	b8 13 00 00 00       	mov    $0x13,%eax
c0101dc0:	89 d7                	mov    %edx,%edi
c0101dc2:	89 de                	mov    %ebx,%esi
c0101dc4:	89 c1                	mov    %eax,%ecx
c0101dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
c0101dc8:	66 c7 05 9c 89 11 c0 	movw   $0x1b,0xc011899c
c0101dcf:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101dd1:	66 c7 05 a8 89 11 c0 	movw   $0x23,0xc01189a8
c0101dd8:	23 00 
c0101dda:	0f b7 05 a8 89 11 c0 	movzwl 0xc01189a8,%eax
c0101de1:	66 a3 88 89 11 c0    	mov    %ax,0xc0118988
c0101de7:	0f b7 05 88 89 11 c0 	movzwl 0xc0118988,%eax
c0101dee:	66 a3 8c 89 11 c0    	mov    %ax,0xc011898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101df4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df7:	83 c0 44             	add    $0x44,%eax
c0101dfa:	a3 a4 89 11 c0       	mov    %eax,0xc01189a4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101dff:	a1 a0 89 11 c0       	mov    0xc01189a0,%eax
c0101e04:	80 cc 30             	or     $0x30,%ah
c0101e07:	a3 a0 89 11 c0       	mov    %eax,0xc01189a0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0f:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101e12:	b8 60 89 11 c0       	mov    $0xc0118960,%eax
c0101e17:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101e19:	e9 b7 00 00 00       	jmp    c0101ed5 <trap_dispatch+0x20a>
c0101e1e:	e9 b2 00 00 00       	jmp    c0101ed5 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e26:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e2a:	66 83 f8 08          	cmp    $0x8,%ax
c0101e2e:	74 6a                	je     c0101e9a <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
c0101e30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e33:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101e39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101e42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e45:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e53:	8b 40 40             	mov    0x40(%eax),%eax
c0101e56:	80 e4 cf             	and    $0xcf,%ah
c0101e59:	89 c2                	mov    %eax,%edx
c0101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5e:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101e61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e64:	8b 40 44             	mov    0x44(%eax),%eax
c0101e67:	83 e8 44             	sub    $0x44,%eax
c0101e6a:	a3 ac 89 11 c0       	mov    %eax,0xc01189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101e6f:	a1 ac 89 11 c0       	mov    0xc01189ac,%eax
c0101e74:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101e7b:	00 
c0101e7c:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e7f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101e83:	89 04 24             	mov    %eax,(%esp)
c0101e86:	e8 53 42 00 00       	call   c01060de <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8e:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101e91:	a1 ac 89 11 c0       	mov    0xc01189ac,%eax
c0101e96:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101e98:	eb 3b                	jmp    c0101ed5 <trap_dispatch+0x20a>
c0101e9a:	eb 39                	jmp    c0101ed5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ea3:	0f b7 c0             	movzwl %ax,%eax
c0101ea6:	83 e0 03             	and    $0x3,%eax
c0101ea9:	85 c0                	test   %eax,%eax
c0101eab:	75 28                	jne    c0101ed5 <trap_dispatch+0x20a>
            print_trapframe(tf);
c0101ead:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb0:	89 04 24             	mov    %eax,(%esp)
c0101eb3:	e8 97 fb ff ff       	call   c0101a4f <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101eb8:	c7 44 24 08 75 67 10 	movl   $0xc0106775,0x8(%esp)
c0101ebf:	c0 
c0101ec0:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0101ec7:	00 
c0101ec8:	c7 04 24 91 67 10 c0 	movl   $0xc0106791,(%esp)
c0101ecf:	e8 fd ed ff ff       	call   c0100cd1 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101ed4:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101ed5:	83 c4 2c             	add    $0x2c,%esp
c0101ed8:	5b                   	pop    %ebx
c0101ed9:	5e                   	pop    %esi
c0101eda:	5f                   	pop    %edi
c0101edb:	5d                   	pop    %ebp
c0101edc:	c3                   	ret    

c0101edd <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101edd:	55                   	push   %ebp
c0101ede:	89 e5                	mov    %esp,%ebp
c0101ee0:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee6:	89 04 24             	mov    %eax,(%esp)
c0101ee9:	e8 dd fd ff ff       	call   c0101ccb <trap_dispatch>
}
c0101eee:	c9                   	leave  
c0101eef:	c3                   	ret    

c0101ef0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101ef0:	1e                   	push   %ds
    pushl %es
c0101ef1:	06                   	push   %es
    pushl %fs
c0101ef2:	0f a0                	push   %fs
    pushl %gs
c0101ef4:	0f a8                	push   %gs
    pushal
c0101ef6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101ef7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101efc:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101efe:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f00:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f01:	e8 d7 ff ff ff       	call   c0101edd <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f06:	5c                   	pop    %esp

c0101f07 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f07:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f08:	0f a9                	pop    %gs
    popl %fs
c0101f0a:	0f a1                	pop    %fs
    popl %es
c0101f0c:	07                   	pop    %es
    popl %ds
c0101f0d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f0e:	83 c4 08             	add    $0x8,%esp
    iret
c0101f11:	cf                   	iret   

c0101f12 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f12:	6a 00                	push   $0x0
  pushl $0
c0101f14:	6a 00                	push   $0x0
  jmp __alltraps
c0101f16:	e9 d5 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f1b <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f1b:	6a 00                	push   $0x0
  pushl $1
c0101f1d:	6a 01                	push   $0x1
  jmp __alltraps
c0101f1f:	e9 cc ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f24 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f24:	6a 00                	push   $0x0
  pushl $2
c0101f26:	6a 02                	push   $0x2
  jmp __alltraps
c0101f28:	e9 c3 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f2d <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $3
c0101f2f:	6a 03                	push   $0x3
  jmp __alltraps
c0101f31:	e9 ba ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f36 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $4
c0101f38:	6a 04                	push   $0x4
  jmp __alltraps
c0101f3a:	e9 b1 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f3f <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  pushl $5
c0101f41:	6a 05                	push   $0x5
  jmp __alltraps
c0101f43:	e9 a8 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f48 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f48:	6a 00                	push   $0x0
  pushl $6
c0101f4a:	6a 06                	push   $0x6
  jmp __alltraps
c0101f4c:	e9 9f ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f51 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $7
c0101f53:	6a 07                	push   $0x7
  jmp __alltraps
c0101f55:	e9 96 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f5a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f5a:	6a 08                	push   $0x8
  jmp __alltraps
c0101f5c:	e9 8f ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f61 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f61:	6a 09                	push   $0x9
  jmp __alltraps
c0101f63:	e9 88 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f68 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f68:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f6a:	e9 81 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f6f <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f6f:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f71:	e9 7a ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f76 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f76:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f78:	e9 73 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f7d <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f7d:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f7f:	e9 6c ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f84 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f84:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f86:	e9 65 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f8b <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f8b:	6a 00                	push   $0x0
  pushl $15
c0101f8d:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f8f:	e9 5c ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f94 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f94:	6a 00                	push   $0x0
  pushl $16
c0101f96:	6a 10                	push   $0x10
  jmp __alltraps
c0101f98:	e9 53 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101f9d <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f9d:	6a 11                	push   $0x11
  jmp __alltraps
c0101f9f:	e9 4c ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fa4 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101fa4:	6a 00                	push   $0x0
  pushl $18
c0101fa6:	6a 12                	push   $0x12
  jmp __alltraps
c0101fa8:	e9 43 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fad <vector19>:
.globl vector19
vector19:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $19
c0101faf:	6a 13                	push   $0x13
  jmp __alltraps
c0101fb1:	e9 3a ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fb6 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $20
c0101fb8:	6a 14                	push   $0x14
  jmp __alltraps
c0101fba:	e9 31 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fbf <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $21
c0101fc1:	6a 15                	push   $0x15
  jmp __alltraps
c0101fc3:	e9 28 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fc8 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fc8:	6a 00                	push   $0x0
  pushl $22
c0101fca:	6a 16                	push   $0x16
  jmp __alltraps
c0101fcc:	e9 1f ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fd1 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fd1:	6a 00                	push   $0x0
  pushl $23
c0101fd3:	6a 17                	push   $0x17
  jmp __alltraps
c0101fd5:	e9 16 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fda <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fda:	6a 00                	push   $0x0
  pushl $24
c0101fdc:	6a 18                	push   $0x18
  jmp __alltraps
c0101fde:	e9 0d ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fe3 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fe3:	6a 00                	push   $0x0
  pushl $25
c0101fe5:	6a 19                	push   $0x19
  jmp __alltraps
c0101fe7:	e9 04 ff ff ff       	jmp    c0101ef0 <__alltraps>

c0101fec <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $26
c0101fee:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ff0:	e9 fb fe ff ff       	jmp    c0101ef0 <__alltraps>

c0101ff5 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ff5:	6a 00                	push   $0x0
  pushl $27
c0101ff7:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ff9:	e9 f2 fe ff ff       	jmp    c0101ef0 <__alltraps>

c0101ffe <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $28
c0102000:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102002:	e9 e9 fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102007 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $29
c0102009:	6a 1d                	push   $0x1d
  jmp __alltraps
c010200b:	e9 e0 fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102010 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $30
c0102012:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102014:	e9 d7 fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102019 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $31
c010201b:	6a 1f                	push   $0x1f
  jmp __alltraps
c010201d:	e9 ce fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102022 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $32
c0102024:	6a 20                	push   $0x20
  jmp __alltraps
c0102026:	e9 c5 fe ff ff       	jmp    c0101ef0 <__alltraps>

c010202b <vector33>:
.globl vector33
vector33:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $33
c010202d:	6a 21                	push   $0x21
  jmp __alltraps
c010202f:	e9 bc fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102034 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $34
c0102036:	6a 22                	push   $0x22
  jmp __alltraps
c0102038:	e9 b3 fe ff ff       	jmp    c0101ef0 <__alltraps>

c010203d <vector35>:
.globl vector35
vector35:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $35
c010203f:	6a 23                	push   $0x23
  jmp __alltraps
c0102041:	e9 aa fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102046 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $36
c0102048:	6a 24                	push   $0x24
  jmp __alltraps
c010204a:	e9 a1 fe ff ff       	jmp    c0101ef0 <__alltraps>

c010204f <vector37>:
.globl vector37
vector37:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $37
c0102051:	6a 25                	push   $0x25
  jmp __alltraps
c0102053:	e9 98 fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102058 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $38
c010205a:	6a 26                	push   $0x26
  jmp __alltraps
c010205c:	e9 8f fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102061 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $39
c0102063:	6a 27                	push   $0x27
  jmp __alltraps
c0102065:	e9 86 fe ff ff       	jmp    c0101ef0 <__alltraps>

c010206a <vector40>:
.globl vector40
vector40:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $40
c010206c:	6a 28                	push   $0x28
  jmp __alltraps
c010206e:	e9 7d fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102073 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $41
c0102075:	6a 29                	push   $0x29
  jmp __alltraps
c0102077:	e9 74 fe ff ff       	jmp    c0101ef0 <__alltraps>

c010207c <vector42>:
.globl vector42
vector42:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $42
c010207e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102080:	e9 6b fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102085 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $43
c0102087:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102089:	e9 62 fe ff ff       	jmp    c0101ef0 <__alltraps>

c010208e <vector44>:
.globl vector44
vector44:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $44
c0102090:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102092:	e9 59 fe ff ff       	jmp    c0101ef0 <__alltraps>

c0102097 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $45
c0102099:	6a 2d                	push   $0x2d
  jmp __alltraps
c010209b:	e9 50 fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020a0 <vector46>:
.globl vector46
vector46:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $46
c01020a2:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020a4:	e9 47 fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020a9 <vector47>:
.globl vector47
vector47:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $47
c01020ab:	6a 2f                	push   $0x2f
  jmp __alltraps
c01020ad:	e9 3e fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020b2 <vector48>:
.globl vector48
vector48:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $48
c01020b4:	6a 30                	push   $0x30
  jmp __alltraps
c01020b6:	e9 35 fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020bb <vector49>:
.globl vector49
vector49:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $49
c01020bd:	6a 31                	push   $0x31
  jmp __alltraps
c01020bf:	e9 2c fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020c4 <vector50>:
.globl vector50
vector50:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $50
c01020c6:	6a 32                	push   $0x32
  jmp __alltraps
c01020c8:	e9 23 fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020cd <vector51>:
.globl vector51
vector51:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $51
c01020cf:	6a 33                	push   $0x33
  jmp __alltraps
c01020d1:	e9 1a fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020d6 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $52
c01020d8:	6a 34                	push   $0x34
  jmp __alltraps
c01020da:	e9 11 fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020df <vector53>:
.globl vector53
vector53:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $53
c01020e1:	6a 35                	push   $0x35
  jmp __alltraps
c01020e3:	e9 08 fe ff ff       	jmp    c0101ef0 <__alltraps>

c01020e8 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $54
c01020ea:	6a 36                	push   $0x36
  jmp __alltraps
c01020ec:	e9 ff fd ff ff       	jmp    c0101ef0 <__alltraps>

c01020f1 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $55
c01020f3:	6a 37                	push   $0x37
  jmp __alltraps
c01020f5:	e9 f6 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01020fa <vector56>:
.globl vector56
vector56:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $56
c01020fc:	6a 38                	push   $0x38
  jmp __alltraps
c01020fe:	e9 ed fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102103 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $57
c0102105:	6a 39                	push   $0x39
  jmp __alltraps
c0102107:	e9 e4 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010210c <vector58>:
.globl vector58
vector58:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $58
c010210e:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102110:	e9 db fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102115 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $59
c0102117:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102119:	e9 d2 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010211e <vector60>:
.globl vector60
vector60:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $60
c0102120:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102122:	e9 c9 fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102127 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $61
c0102129:	6a 3d                	push   $0x3d
  jmp __alltraps
c010212b:	e9 c0 fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102130 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $62
c0102132:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102134:	e9 b7 fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102139 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $63
c010213b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010213d:	e9 ae fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102142 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $64
c0102144:	6a 40                	push   $0x40
  jmp __alltraps
c0102146:	e9 a5 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010214b <vector65>:
.globl vector65
vector65:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $65
c010214d:	6a 41                	push   $0x41
  jmp __alltraps
c010214f:	e9 9c fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102154 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $66
c0102156:	6a 42                	push   $0x42
  jmp __alltraps
c0102158:	e9 93 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010215d <vector67>:
.globl vector67
vector67:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $67
c010215f:	6a 43                	push   $0x43
  jmp __alltraps
c0102161:	e9 8a fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102166 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $68
c0102168:	6a 44                	push   $0x44
  jmp __alltraps
c010216a:	e9 81 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010216f <vector69>:
.globl vector69
vector69:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $69
c0102171:	6a 45                	push   $0x45
  jmp __alltraps
c0102173:	e9 78 fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102178 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $70
c010217a:	6a 46                	push   $0x46
  jmp __alltraps
c010217c:	e9 6f fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102181 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $71
c0102183:	6a 47                	push   $0x47
  jmp __alltraps
c0102185:	e9 66 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010218a <vector72>:
.globl vector72
vector72:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $72
c010218c:	6a 48                	push   $0x48
  jmp __alltraps
c010218e:	e9 5d fd ff ff       	jmp    c0101ef0 <__alltraps>

c0102193 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $73
c0102195:	6a 49                	push   $0x49
  jmp __alltraps
c0102197:	e9 54 fd ff ff       	jmp    c0101ef0 <__alltraps>

c010219c <vector74>:
.globl vector74
vector74:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $74
c010219e:	6a 4a                	push   $0x4a
  jmp __alltraps
c01021a0:	e9 4b fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021a5 <vector75>:
.globl vector75
vector75:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $75
c01021a7:	6a 4b                	push   $0x4b
  jmp __alltraps
c01021a9:	e9 42 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021ae <vector76>:
.globl vector76
vector76:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $76
c01021b0:	6a 4c                	push   $0x4c
  jmp __alltraps
c01021b2:	e9 39 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021b7 <vector77>:
.globl vector77
vector77:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $77
c01021b9:	6a 4d                	push   $0x4d
  jmp __alltraps
c01021bb:	e9 30 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021c0 <vector78>:
.globl vector78
vector78:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $78
c01021c2:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021c4:	e9 27 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021c9 <vector79>:
.globl vector79
vector79:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $79
c01021cb:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021cd:	e9 1e fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021d2 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $80
c01021d4:	6a 50                	push   $0x50
  jmp __alltraps
c01021d6:	e9 15 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021db <vector81>:
.globl vector81
vector81:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $81
c01021dd:	6a 51                	push   $0x51
  jmp __alltraps
c01021df:	e9 0c fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021e4 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $82
c01021e6:	6a 52                	push   $0x52
  jmp __alltraps
c01021e8:	e9 03 fd ff ff       	jmp    c0101ef0 <__alltraps>

c01021ed <vector83>:
.globl vector83
vector83:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $83
c01021ef:	6a 53                	push   $0x53
  jmp __alltraps
c01021f1:	e9 fa fc ff ff       	jmp    c0101ef0 <__alltraps>

c01021f6 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $84
c01021f8:	6a 54                	push   $0x54
  jmp __alltraps
c01021fa:	e9 f1 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01021ff <vector85>:
.globl vector85
vector85:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $85
c0102201:	6a 55                	push   $0x55
  jmp __alltraps
c0102203:	e9 e8 fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102208 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $86
c010220a:	6a 56                	push   $0x56
  jmp __alltraps
c010220c:	e9 df fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102211 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $87
c0102213:	6a 57                	push   $0x57
  jmp __alltraps
c0102215:	e9 d6 fc ff ff       	jmp    c0101ef0 <__alltraps>

c010221a <vector88>:
.globl vector88
vector88:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $88
c010221c:	6a 58                	push   $0x58
  jmp __alltraps
c010221e:	e9 cd fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102223 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $89
c0102225:	6a 59                	push   $0x59
  jmp __alltraps
c0102227:	e9 c4 fc ff ff       	jmp    c0101ef0 <__alltraps>

c010222c <vector90>:
.globl vector90
vector90:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $90
c010222e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102230:	e9 bb fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102235 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $91
c0102237:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102239:	e9 b2 fc ff ff       	jmp    c0101ef0 <__alltraps>

c010223e <vector92>:
.globl vector92
vector92:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $92
c0102240:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102242:	e9 a9 fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102247 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $93
c0102249:	6a 5d                	push   $0x5d
  jmp __alltraps
c010224b:	e9 a0 fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102250 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $94
c0102252:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102254:	e9 97 fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102259 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $95
c010225b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010225d:	e9 8e fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102262 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $96
c0102264:	6a 60                	push   $0x60
  jmp __alltraps
c0102266:	e9 85 fc ff ff       	jmp    c0101ef0 <__alltraps>

c010226b <vector97>:
.globl vector97
vector97:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $97
c010226d:	6a 61                	push   $0x61
  jmp __alltraps
c010226f:	e9 7c fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102274 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $98
c0102276:	6a 62                	push   $0x62
  jmp __alltraps
c0102278:	e9 73 fc ff ff       	jmp    c0101ef0 <__alltraps>

c010227d <vector99>:
.globl vector99
vector99:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $99
c010227f:	6a 63                	push   $0x63
  jmp __alltraps
c0102281:	e9 6a fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102286 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $100
c0102288:	6a 64                	push   $0x64
  jmp __alltraps
c010228a:	e9 61 fc ff ff       	jmp    c0101ef0 <__alltraps>

c010228f <vector101>:
.globl vector101
vector101:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $101
c0102291:	6a 65                	push   $0x65
  jmp __alltraps
c0102293:	e9 58 fc ff ff       	jmp    c0101ef0 <__alltraps>

c0102298 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $102
c010229a:	6a 66                	push   $0x66
  jmp __alltraps
c010229c:	e9 4f fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022a1 <vector103>:
.globl vector103
vector103:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $103
c01022a3:	6a 67                	push   $0x67
  jmp __alltraps
c01022a5:	e9 46 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022aa <vector104>:
.globl vector104
vector104:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $104
c01022ac:	6a 68                	push   $0x68
  jmp __alltraps
c01022ae:	e9 3d fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022b3 <vector105>:
.globl vector105
vector105:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $105
c01022b5:	6a 69                	push   $0x69
  jmp __alltraps
c01022b7:	e9 34 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022bc <vector106>:
.globl vector106
vector106:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $106
c01022be:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022c0:	e9 2b fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022c5 <vector107>:
.globl vector107
vector107:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $107
c01022c7:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022c9:	e9 22 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022ce <vector108>:
.globl vector108
vector108:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $108
c01022d0:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022d2:	e9 19 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022d7 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $109
c01022d9:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022db:	e9 10 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022e0 <vector110>:
.globl vector110
vector110:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $110
c01022e2:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022e4:	e9 07 fc ff ff       	jmp    c0101ef0 <__alltraps>

c01022e9 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $111
c01022eb:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022ed:	e9 fe fb ff ff       	jmp    c0101ef0 <__alltraps>

c01022f2 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $112
c01022f4:	6a 70                	push   $0x70
  jmp __alltraps
c01022f6:	e9 f5 fb ff ff       	jmp    c0101ef0 <__alltraps>

c01022fb <vector113>:
.globl vector113
vector113:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $113
c01022fd:	6a 71                	push   $0x71
  jmp __alltraps
c01022ff:	e9 ec fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102304 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $114
c0102306:	6a 72                	push   $0x72
  jmp __alltraps
c0102308:	e9 e3 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010230d <vector115>:
.globl vector115
vector115:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $115
c010230f:	6a 73                	push   $0x73
  jmp __alltraps
c0102311:	e9 da fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102316 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $116
c0102318:	6a 74                	push   $0x74
  jmp __alltraps
c010231a:	e9 d1 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010231f <vector117>:
.globl vector117
vector117:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $117
c0102321:	6a 75                	push   $0x75
  jmp __alltraps
c0102323:	e9 c8 fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102328 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $118
c010232a:	6a 76                	push   $0x76
  jmp __alltraps
c010232c:	e9 bf fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102331 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $119
c0102333:	6a 77                	push   $0x77
  jmp __alltraps
c0102335:	e9 b6 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010233a <vector120>:
.globl vector120
vector120:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $120
c010233c:	6a 78                	push   $0x78
  jmp __alltraps
c010233e:	e9 ad fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102343 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $121
c0102345:	6a 79                	push   $0x79
  jmp __alltraps
c0102347:	e9 a4 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010234c <vector122>:
.globl vector122
vector122:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $122
c010234e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102350:	e9 9b fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102355 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $123
c0102357:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102359:	e9 92 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010235e <vector124>:
.globl vector124
vector124:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $124
c0102360:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102362:	e9 89 fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102367 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $125
c0102369:	6a 7d                	push   $0x7d
  jmp __alltraps
c010236b:	e9 80 fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102370 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $126
c0102372:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102374:	e9 77 fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102379 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $127
c010237b:	6a 7f                	push   $0x7f
  jmp __alltraps
c010237d:	e9 6e fb ff ff       	jmp    c0101ef0 <__alltraps>

c0102382 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $128
c0102384:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102389:	e9 62 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010238e <vector129>:
.globl vector129
vector129:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $129
c0102390:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102395:	e9 56 fb ff ff       	jmp    c0101ef0 <__alltraps>

c010239a <vector130>:
.globl vector130
vector130:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $130
c010239c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01023a1:	e9 4a fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023a6 <vector131>:
.globl vector131
vector131:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $131
c01023a8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01023ad:	e9 3e fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023b2 <vector132>:
.globl vector132
vector132:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $132
c01023b4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01023b9:	e9 32 fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023be <vector133>:
.globl vector133
vector133:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $133
c01023c0:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023c5:	e9 26 fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023ca <vector134>:
.globl vector134
vector134:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $134
c01023cc:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023d1:	e9 1a fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023d6 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $135
c01023d8:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023dd:	e9 0e fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023e2 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $136
c01023e4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023e9:	e9 02 fb ff ff       	jmp    c0101ef0 <__alltraps>

c01023ee <vector137>:
.globl vector137
vector137:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $137
c01023f0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023f5:	e9 f6 fa ff ff       	jmp    c0101ef0 <__alltraps>

c01023fa <vector138>:
.globl vector138
vector138:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $138
c01023fc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102401:	e9 ea fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102406 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $139
c0102408:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010240d:	e9 de fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102412 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $140
c0102414:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102419:	e9 d2 fa ff ff       	jmp    c0101ef0 <__alltraps>

c010241e <vector141>:
.globl vector141
vector141:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $141
c0102420:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102425:	e9 c6 fa ff ff       	jmp    c0101ef0 <__alltraps>

c010242a <vector142>:
.globl vector142
vector142:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $142
c010242c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102431:	e9 ba fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102436 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $143
c0102438:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010243d:	e9 ae fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102442 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $144
c0102444:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102449:	e9 a2 fa ff ff       	jmp    c0101ef0 <__alltraps>

c010244e <vector145>:
.globl vector145
vector145:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $145
c0102450:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102455:	e9 96 fa ff ff       	jmp    c0101ef0 <__alltraps>

c010245a <vector146>:
.globl vector146
vector146:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $146
c010245c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102461:	e9 8a fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102466 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $147
c0102468:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010246d:	e9 7e fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102472 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $148
c0102474:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102479:	e9 72 fa ff ff       	jmp    c0101ef0 <__alltraps>

c010247e <vector149>:
.globl vector149
vector149:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $149
c0102480:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102485:	e9 66 fa ff ff       	jmp    c0101ef0 <__alltraps>

c010248a <vector150>:
.globl vector150
vector150:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $150
c010248c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102491:	e9 5a fa ff ff       	jmp    c0101ef0 <__alltraps>

c0102496 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $151
c0102498:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010249d:	e9 4e fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024a2 <vector152>:
.globl vector152
vector152:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $152
c01024a4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01024a9:	e9 42 fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024ae <vector153>:
.globl vector153
vector153:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $153
c01024b0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01024b5:	e9 36 fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024ba <vector154>:
.globl vector154
vector154:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $154
c01024bc:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024c1:	e9 2a fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024c6 <vector155>:
.globl vector155
vector155:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $155
c01024c8:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024cd:	e9 1e fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024d2 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $156
c01024d4:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024d9:	e9 12 fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024de <vector157>:
.globl vector157
vector157:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $157
c01024e0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024e5:	e9 06 fa ff ff       	jmp    c0101ef0 <__alltraps>

c01024ea <vector158>:
.globl vector158
vector158:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $158
c01024ec:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024f1:	e9 fa f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01024f6 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $159
c01024f8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024fd:	e9 ee f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102502 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $160
c0102504:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102509:	e9 e2 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010250e <vector161>:
.globl vector161
vector161:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $161
c0102510:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102515:	e9 d6 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010251a <vector162>:
.globl vector162
vector162:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $162
c010251c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102521:	e9 ca f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102526 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $163
c0102528:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010252d:	e9 be f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102532 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $164
c0102534:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102539:	e9 b2 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010253e <vector165>:
.globl vector165
vector165:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $165
c0102540:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102545:	e9 a6 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010254a <vector166>:
.globl vector166
vector166:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $166
c010254c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102551:	e9 9a f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102556 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $167
c0102558:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010255d:	e9 8e f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102562 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $168
c0102564:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102569:	e9 82 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010256e <vector169>:
.globl vector169
vector169:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $169
c0102570:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102575:	e9 76 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010257a <vector170>:
.globl vector170
vector170:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $170
c010257c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102581:	e9 6a f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102586 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $171
c0102588:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010258d:	e9 5e f9 ff ff       	jmp    c0101ef0 <__alltraps>

c0102592 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $172
c0102594:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102599:	e9 52 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c010259e <vector173>:
.globl vector173
vector173:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $173
c01025a0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025a5:	e9 46 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01025aa <vector174>:
.globl vector174
vector174:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $174
c01025ac:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01025b1:	e9 3a f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01025b6 <vector175>:
.globl vector175
vector175:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $175
c01025b8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025bd:	e9 2e f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01025c2 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $176
c01025c4:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025c9:	e9 22 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01025ce <vector177>:
.globl vector177
vector177:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $177
c01025d0:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025d5:	e9 16 f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01025da <vector178>:
.globl vector178
vector178:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $178
c01025dc:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025e1:	e9 0a f9 ff ff       	jmp    c0101ef0 <__alltraps>

c01025e6 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $179
c01025e8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025ed:	e9 fe f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01025f2 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $180
c01025f4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025f9:	e9 f2 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01025fe <vector181>:
.globl vector181
vector181:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $181
c0102600:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102605:	e9 e6 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010260a <vector182>:
.globl vector182
vector182:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $182
c010260c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102611:	e9 da f8 ff ff       	jmp    c0101ef0 <__alltraps>

c0102616 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $183
c0102618:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010261d:	e9 ce f8 ff ff       	jmp    c0101ef0 <__alltraps>

c0102622 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $184
c0102624:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102629:	e9 c2 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010262e <vector185>:
.globl vector185
vector185:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $185
c0102630:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102635:	e9 b6 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010263a <vector186>:
.globl vector186
vector186:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $186
c010263c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102641:	e9 aa f8 ff ff       	jmp    c0101ef0 <__alltraps>

c0102646 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $187
c0102648:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010264d:	e9 9e f8 ff ff       	jmp    c0101ef0 <__alltraps>

c0102652 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $188
c0102654:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102659:	e9 92 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010265e <vector189>:
.globl vector189
vector189:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $189
c0102660:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102665:	e9 86 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010266a <vector190>:
.globl vector190
vector190:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $190
c010266c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102671:	e9 7a f8 ff ff       	jmp    c0101ef0 <__alltraps>

c0102676 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $191
c0102678:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010267d:	e9 6e f8 ff ff       	jmp    c0101ef0 <__alltraps>

c0102682 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $192
c0102684:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102689:	e9 62 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010268e <vector193>:
.globl vector193
vector193:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $193
c0102690:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102695:	e9 56 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c010269a <vector194>:
.globl vector194
vector194:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $194
c010269c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01026a1:	e9 4a f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026a6 <vector195>:
.globl vector195
vector195:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $195
c01026a8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01026ad:	e9 3e f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026b2 <vector196>:
.globl vector196
vector196:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $196
c01026b4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01026b9:	e9 32 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026be <vector197>:
.globl vector197
vector197:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $197
c01026c0:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026c5:	e9 26 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026ca <vector198>:
.globl vector198
vector198:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $198
c01026cc:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026d1:	e9 1a f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026d6 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $199
c01026d8:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026dd:	e9 0e f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026e2 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $200
c01026e4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026e9:	e9 02 f8 ff ff       	jmp    c0101ef0 <__alltraps>

c01026ee <vector201>:
.globl vector201
vector201:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $201
c01026f0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026f5:	e9 f6 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01026fa <vector202>:
.globl vector202
vector202:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $202
c01026fc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102701:	e9 ea f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102706 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $203
c0102708:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010270d:	e9 de f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102712 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $204
c0102714:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102719:	e9 d2 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c010271e <vector205>:
.globl vector205
vector205:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $205
c0102720:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102725:	e9 c6 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c010272a <vector206>:
.globl vector206
vector206:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $206
c010272c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102731:	e9 ba f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102736 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $207
c0102738:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010273d:	e9 ae f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102742 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $208
c0102744:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102749:	e9 a2 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c010274e <vector209>:
.globl vector209
vector209:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $209
c0102750:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102755:	e9 96 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c010275a <vector210>:
.globl vector210
vector210:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $210
c010275c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102761:	e9 8a f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102766 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $211
c0102768:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010276d:	e9 7e f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102772 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $212
c0102774:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102779:	e9 72 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c010277e <vector213>:
.globl vector213
vector213:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $213
c0102780:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102785:	e9 66 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c010278a <vector214>:
.globl vector214
vector214:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $214
c010278c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102791:	e9 5a f7 ff ff       	jmp    c0101ef0 <__alltraps>

c0102796 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $215
c0102798:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010279d:	e9 4e f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027a2 <vector216>:
.globl vector216
vector216:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $216
c01027a4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01027a9:	e9 42 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027ae <vector217>:
.globl vector217
vector217:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $217
c01027b0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01027b5:	e9 36 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027ba <vector218>:
.globl vector218
vector218:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $218
c01027bc:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027c1:	e9 2a f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027c6 <vector219>:
.globl vector219
vector219:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $219
c01027c8:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027cd:	e9 1e f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027d2 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $220
c01027d4:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027d9:	e9 12 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027de <vector221>:
.globl vector221
vector221:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $221
c01027e0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027e5:	e9 06 f7 ff ff       	jmp    c0101ef0 <__alltraps>

c01027ea <vector222>:
.globl vector222
vector222:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $222
c01027ec:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027f1:	e9 fa f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01027f6 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $223
c01027f8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027fd:	e9 ee f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102802 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $224
c0102804:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102809:	e9 e2 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010280e <vector225>:
.globl vector225
vector225:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $225
c0102810:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102815:	e9 d6 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010281a <vector226>:
.globl vector226
vector226:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $226
c010281c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102821:	e9 ca f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102826 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $227
c0102828:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010282d:	e9 be f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102832 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $228
c0102834:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102839:	e9 b2 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010283e <vector229>:
.globl vector229
vector229:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $229
c0102840:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102845:	e9 a6 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010284a <vector230>:
.globl vector230
vector230:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $230
c010284c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102851:	e9 9a f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102856 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102856:	6a 00                	push   $0x0
  pushl $231
c0102858:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010285d:	e9 8e f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102862 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $232
c0102864:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102869:	e9 82 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010286e <vector233>:
.globl vector233
vector233:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $233
c0102870:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102875:	e9 76 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010287a <vector234>:
.globl vector234
vector234:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $234
c010287c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102881:	e9 6a f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102886 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $235
c0102888:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010288d:	e9 5e f6 ff ff       	jmp    c0101ef0 <__alltraps>

c0102892 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $236
c0102894:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102899:	e9 52 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c010289e <vector237>:
.globl vector237
vector237:
  pushl $0
c010289e:	6a 00                	push   $0x0
  pushl $237
c01028a0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028a5:	e9 46 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01028aa <vector238>:
.globl vector238
vector238:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $238
c01028ac:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01028b1:	e9 3a f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01028b6 <vector239>:
.globl vector239
vector239:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $239
c01028b8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028bd:	e9 2e f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01028c2 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $240
c01028c4:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028c9:	e9 22 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01028ce <vector241>:
.globl vector241
vector241:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $241
c01028d0:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028d5:	e9 16 f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01028da <vector242>:
.globl vector242
vector242:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $242
c01028dc:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028e1:	e9 0a f6 ff ff       	jmp    c0101ef0 <__alltraps>

c01028e6 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $243
c01028e8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028ed:	e9 fe f5 ff ff       	jmp    c0101ef0 <__alltraps>

c01028f2 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $244
c01028f4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028f9:	e9 f2 f5 ff ff       	jmp    c0101ef0 <__alltraps>

c01028fe <vector245>:
.globl vector245
vector245:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $245
c0102900:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102905:	e9 e6 f5 ff ff       	jmp    c0101ef0 <__alltraps>

c010290a <vector246>:
.globl vector246
vector246:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $246
c010290c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102911:	e9 da f5 ff ff       	jmp    c0101ef0 <__alltraps>

c0102916 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $247
c0102918:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010291d:	e9 ce f5 ff ff       	jmp    c0101ef0 <__alltraps>

c0102922 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $248
c0102924:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102929:	e9 c2 f5 ff ff       	jmp    c0101ef0 <__alltraps>

c010292e <vector249>:
.globl vector249
vector249:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $249
c0102930:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102935:	e9 b6 f5 ff ff       	jmp    c0101ef0 <__alltraps>

c010293a <vector250>:
.globl vector250
vector250:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $250
c010293c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102941:	e9 aa f5 ff ff       	jmp    c0101ef0 <__alltraps>

c0102946 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $251
c0102948:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010294d:	e9 9e f5 ff ff       	jmp    c0101ef0 <__alltraps>

c0102952 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $252
c0102954:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102959:	e9 92 f5 ff ff       	jmp    c0101ef0 <__alltraps>

c010295e <vector253>:
.globl vector253
vector253:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $253
c0102960:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102965:	e9 86 f5 ff ff       	jmp    c0101ef0 <__alltraps>

c010296a <vector254>:
.globl vector254
vector254:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $254
c010296c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102971:	e9 7a f5 ff ff       	jmp    c0101ef0 <__alltraps>

c0102976 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $255
c0102978:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010297d:	e9 6e f5 ff ff       	jmp    c0101ef0 <__alltraps>

c0102982 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102982:	55                   	push   %ebp
c0102983:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102985:	8b 55 08             	mov    0x8(%ebp),%edx
c0102988:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010298d:	29 c2                	sub    %eax,%edx
c010298f:	89 d0                	mov    %edx,%eax
c0102991:	c1 f8 02             	sar    $0x2,%eax
c0102994:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010299a:	5d                   	pop    %ebp
c010299b:	c3                   	ret    

c010299c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010299c:	55                   	push   %ebp
c010299d:	89 e5                	mov    %esp,%ebp
c010299f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01029a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a5:	89 04 24             	mov    %eax,(%esp)
c01029a8:	e8 d5 ff ff ff       	call   c0102982 <page2ppn>
c01029ad:	c1 e0 0c             	shl    $0xc,%eax
}
c01029b0:	c9                   	leave  
c01029b1:	c3                   	ret    

c01029b2 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01029b2:	55                   	push   %ebp
c01029b3:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01029b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b8:	8b 00                	mov    (%eax),%eax
}
c01029ba:	5d                   	pop    %ebp
c01029bb:	c3                   	ret    

c01029bc <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029bc:	55                   	push   %ebp
c01029bd:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029c5:	89 10                	mov    %edx,(%eax)
}
c01029c7:	5d                   	pop    %ebp
c01029c8:	c3                   	ret    

c01029c9 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01029c9:	55                   	push   %ebp
c01029ca:	89 e5                	mov    %esp,%ebp
c01029cc:	83 ec 10             	sub    $0x10,%esp
c01029cf:	c7 45 fc b0 89 11 c0 	movl   $0xc01189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01029d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029dc:	89 50 04             	mov    %edx,0x4(%eax)
c01029df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029e2:	8b 50 04             	mov    0x4(%eax),%edx
c01029e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029e8:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01029ea:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c01029f1:	00 00 00 
}
c01029f4:	c9                   	leave  
c01029f5:	c3                   	ret    

c01029f6 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01029f6:	55                   	push   %ebp
c01029f7:	89 e5                	mov    %esp,%ebp
c01029f9:	83 ec 48             	sub    $0x48,%esp
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    list_add(&free_list, &(base->page_link));
#endif
    assert(n > 0);
c01029fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a00:	75 24                	jne    c0102a26 <default_init_memmap+0x30>
c0102a02:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c0102a09:	c0 
c0102a0a:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102a11:	c0 
c0102a12:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0102a19:	00 
c0102a1a:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102a21:	e8 ab e2 ff ff       	call   c0100cd1 <__panic>
    struct Page* p = base;
c0102a26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    for (; p != base + n; p++)
c0102a2c:	eb 7b                	jmp    c0102aa9 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p));
c0102a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a31:	83 c0 04             	add    $0x4,%eax
c0102a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a41:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a44:	0f a3 10             	bt     %edx,(%eax)
c0102a47:	19 c0                	sbb    %eax,%eax
c0102a49:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102a4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102a50:	0f 95 c0             	setne  %al
c0102a53:	0f b6 c0             	movzbl %al,%eax
c0102a56:	85 c0                	test   %eax,%eax
c0102a58:	75 24                	jne    c0102a7e <default_init_memmap+0x88>
c0102a5a:	c7 44 24 0c 81 69 10 	movl   $0xc0106981,0xc(%esp)
c0102a61:	c0 
c0102a62:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102a69:	c0 
c0102a6a:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0102a71:	00 
c0102a72:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102a79:	e8 53 e2 ff ff       	call   c0100cd1 <__panic>
	p->flags = 0;
c0102a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	p->property = 0;
c0102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	set_page_ref(p, 0);
c0102a92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a99:	00 
c0102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a9d:	89 04 24             	mov    %eax,(%esp)
c0102aa0:	e8 17 ff ff ff       	call   c01029bc <set_page_ref>
    list_add(&free_list, &(base->page_link));
#endif
    assert(n > 0);
    struct Page* p = base;
    
    for (; p != base + n; p++)
c0102aa5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aac:	89 d0                	mov    %edx,%eax
c0102aae:	c1 e0 02             	shl    $0x2,%eax
c0102ab1:	01 d0                	add    %edx,%eax
c0102ab3:	c1 e0 02             	shl    $0x2,%eax
c0102ab6:	89 c2                	mov    %eax,%edx
c0102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102abb:	01 d0                	add    %edx,%eax
c0102abd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ac0:	0f 85 68 ff ff ff    	jne    c0102a2e <default_init_memmap+0x38>
	p->flags = 0;
	p->property = 0;
	set_page_ref(p, 0);
    }
    
    SetPageProperty(base);
c0102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac9:	83 c0 04             	add    $0x4,%eax
c0102acc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102ad3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ad6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ad9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102adc:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ae5:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102ae8:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0102aee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102af1:	01 d0                	add    %edx,%eax
c0102af3:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    list_add_before(&free_list, &(base->page_link));
c0102af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afb:	83 c0 0c             	add    $0xc,%eax
c0102afe:	c7 45 dc b0 89 11 c0 	movl   $0xc01189b0,-0x24(%ebp)
c0102b05:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b0b:	8b 00                	mov    (%eax),%eax
c0102b0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b19:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b22:	89 10                	mov    %edx,(%eax)
c0102b24:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b27:	8b 10                	mov    (%eax),%edx
c0102b29:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b32:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b35:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b3e:	89 10                	mov    %edx,(%eax)
}
c0102b40:	c9                   	leave  
c0102b41:	c3                   	ret    

c0102b42 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102b42:	55                   	push   %ebp
c0102b43:	89 e5                	mov    %esp,%ebp
c0102b45:	83 ec 78             	sub    $0x78,%esp
        nr_free -= n;
        ClearPageProperty(page);
    }
    return page;
#endif
    assert(n > 0);
c0102b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b4c:	75 24                	jne    c0102b72 <default_alloc_pages+0x30>
c0102b4e:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c0102b55:	c0 
c0102b56:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102b5d:	c0 
c0102b5e:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0102b65:	00 
c0102b66:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102b6d:	e8 5f e1 ff ff       	call   c0100cd1 <__panic>
    int i;
    if (n > nr_free)
c0102b72:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102b77:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b7a:	73 0a                	jae    c0102b86 <default_alloc_pages+0x44>
    {
	return NULL;
c0102b7c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102b81:	e9 9b 01 00 00       	jmp    c0102d21 <default_alloc_pages+0x1df>
    }
    struct Page* page = NULL;
c0102b86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t* le = &free_list;
c0102b8d:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)

    while ((le = list_next(le)) != &free_list)
c0102b94:	eb 1c                	jmp    c0102bb2 <default_alloc_pages+0x70>
    {
	struct Page* p = le2page(le, page_link);
c0102b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b99:	83 e8 0c             	sub    $0xc,%eax
c0102b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (p->property >= n)
c0102b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ba2:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba5:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ba8:	72 08                	jb     c0102bb2 <default_alloc_pages+0x70>
	{
	    page = p;
c0102baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    break;
c0102bb0:	eb 18                	jmp    c0102bca <default_alloc_pages+0x88>
c0102bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bbb:	8b 40 04             	mov    0x4(%eax),%eax
	return NULL;
    }
    struct Page* page = NULL;
    list_entry_t* le = &free_list;

    while ((le = list_next(le)) != &free_list)
c0102bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102bc1:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c0102bc8:	75 cc                	jne    c0102b96 <default_alloc_pages+0x54>
	    page = p;
	    break;
	}
    }

    if (page != NULL)
c0102bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102bce:	0f 84 4a 01 00 00    	je     c0102d1e <default_alloc_pages+0x1dc>
    {
	if (page->property > n) 
c0102bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bd7:	8b 40 08             	mov    0x8(%eax),%eax
c0102bda:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bdd:	0f 86 98 00 00 00    	jbe    c0102c7b <default_alloc_pages+0x139>
	{
            struct Page *p = page + n;
c0102be3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102be6:	89 d0                	mov    %edx,%eax
c0102be8:	c1 e0 02             	shl    $0x2,%eax
c0102beb:	01 d0                	add    %edx,%eax
c0102bed:	c1 e0 02             	shl    $0x2,%eax
c0102bf0:	89 c2                	mov    %eax,%edx
c0102bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bf5:	01 d0                	add    %edx,%eax
c0102bf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
c0102bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bfd:	8b 40 08             	mov    0x8(%eax),%eax
c0102c00:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c03:	89 c2                	mov    %eax,%edx
c0102c05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c08:	89 50 08             	mov    %edx,0x8(%eax)
	    SetPageProperty(p);
c0102c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c0e:	83 c0 04             	add    $0x4,%eax
c0102c11:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102c18:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102c1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c21:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
c0102c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c27:	83 c0 0c             	add    $0xc,%eax
c0102c2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102c2d:	83 c2 0c             	add    $0xc,%edx
c0102c30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c33:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c39:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102c3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102c42:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c45:	8b 40 04             	mov    0x4(%eax),%eax
c0102c48:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c4b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102c4e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c51:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102c54:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c57:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c5a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c5d:	89 10                	mov    %edx,(%eax)
c0102c5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c62:	8b 10                	mov    (%eax),%edx
c0102c64:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102c67:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c6d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c70:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c73:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c76:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102c79:	89 10                	mov    %edx,(%eax)
    	}

	list_del(&(page->page_link));
c0102c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c7e:	83 c0 0c             	add    $0xc,%eax
c0102c81:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102c84:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102c87:	8b 40 04             	mov    0x4(%eax),%eax
c0102c8a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c8d:	8b 12                	mov    (%edx),%edx
c0102c8f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0102c92:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c98:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c9b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ca1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ca4:	89 10                	mov    %edx,(%eax)

	for (i = 0; i < n; i++)
c0102ca6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102cad:	eb 2e                	jmp    c0102cdd <default_alloc_pages+0x19b>
	{
	    SetPageReserved(page + i);
c0102caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102cb2:	89 d0                	mov    %edx,%eax
c0102cb4:	c1 e0 02             	shl    $0x2,%eax
c0102cb7:	01 d0                	add    %edx,%eax
c0102cb9:	c1 e0 02             	shl    $0x2,%eax
c0102cbc:	89 c2                	mov    %eax,%edx
c0102cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cc1:	01 d0                	add    %edx,%eax
c0102cc3:	83 c0 04             	add    $0x4,%eax
c0102cc6:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
c0102ccd:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102cd0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102cd3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102cd6:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
    	}

	list_del(&(page->page_link));

	for (i = 0; i < n; i++)
c0102cd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ce3:	72 ca                	jb     c0102caf <default_alloc_pages+0x16d>
	{
	    SetPageReserved(page + i);
	}
		
	set_page_ref(page, 0);
c0102ce5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cec:	00 
c0102ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cf0:	89 04 24             	mov    %eax,(%esp)
c0102cf3:	e8 c4 fc ff ff       	call   c01029bc <set_page_ref>
        nr_free -= n;
c0102cf8:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102cfd:	2b 45 08             	sub    0x8(%ebp),%eax
c0102d00:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
		
        ClearPageProperty(page);
c0102d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d08:	83 c0 04             	add    $0x4,%eax
c0102d0b:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102d12:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d15:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d18:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102d1b:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d21:	c9                   	leave  
c0102d22:	c3                   	ret    

c0102d23 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102d23:	55                   	push   %ebp
c0102d24:	89 e5                	mov    %esp,%ebp
c0102d26:	81 ec 98 00 00 00    	sub    $0x98,%esp
        }
    }
    nr_free += n;
    list_add(&free_list, &(base->page_link));
#endif
    assert(n > 0);
c0102d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d30:	75 24                	jne    c0102d56 <default_free_pages+0x33>
c0102d32:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c0102d39:	c0 
c0102d3a:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102d41:	c0 
c0102d42:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0102d49:	00 
c0102d4a:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102d51:	e8 7b df ff ff       	call   c0100cd1 <__panic>
	
    struct Page *p = base;
c0102d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page *p1 = NULL;
c0102d5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    //标志位应该是为0的
    assert(!PageProperty(base));
c0102d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d66:	83 c0 04             	add    $0x4,%eax
c0102d69:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0102d70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102d79:	0f a3 10             	bt     %edx,(%eax)
c0102d7c:	19 c0                	sbb    %eax,%eax
c0102d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0102d81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102d85:	0f 95 c0             	setne  %al
c0102d88:	0f b6 c0             	movzbl %al,%eax
c0102d8b:	85 c0                	test   %eax,%eax
c0102d8d:	74 24                	je     c0102db3 <default_free_pages+0x90>
c0102d8f:	c7 44 24 0c 91 69 10 	movl   $0xc0106991,0xc(%esp)
c0102d96:	c0 
c0102d97:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102d9e:	c0 
c0102d9f:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0102da6:	00 
c0102da7:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102dae:	e8 1e df ff ff       	call   c0100cd1 <__panic>

    //所有的页面应该是使用的
    for (; p != base + n; p ++) 
c0102db3:	eb 71                	jmp    c0102e26 <default_free_pages+0x103>
    {		
        assert(PageReserved(p));
c0102db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db8:	83 c0 04             	add    $0x4,%eax
c0102dbb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102dc2:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102dc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102dc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dcb:	0f a3 10             	bt     %edx,(%eax)
c0102dce:	19 c0                	sbb    %eax,%eax
c0102dd0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102dd3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102dd7:	0f 95 c0             	setne  %al
c0102dda:	0f b6 c0             	movzbl %al,%eax
c0102ddd:	85 c0                	test   %eax,%eax
c0102ddf:	75 24                	jne    c0102e05 <default_free_pages+0xe2>
c0102de1:	c7 44 24 0c 81 69 10 	movl   $0xc0106981,0xc(%esp)
c0102de8:	c0 
c0102de9:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102df0:	c0 
c0102df1:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0102df8:	00 
c0102df9:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102e00:	e8 cc de ff ff       	call   c0100cd1 <__panic>
        p->flags = 0;
c0102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	//引用次数为0
        set_page_ref(p, 0);
c0102e0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102e16:	00 
c0102e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e1a:	89 04 24             	mov    %eax,(%esp)
c0102e1d:	e8 9a fb ff ff       	call   c01029bc <set_page_ref>

    //标志位应该是为0的
    assert(!PageProperty(base));

    //所有的页面应该是使用的
    for (; p != base + n; p ++) 
c0102e22:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102e26:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e29:	89 d0                	mov    %edx,%eax
c0102e2b:	c1 e0 02             	shl    $0x2,%eax
c0102e2e:	01 d0                	add    %edx,%eax
c0102e30:	c1 e0 02             	shl    $0x2,%eax
c0102e33:	89 c2                	mov    %eax,%edx
c0102e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e38:	01 d0                	add    %edx,%eax
c0102e3a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e3d:	0f 85 72 ff ff ff    	jne    c0102db5 <default_free_pages+0x92>
	//引用次数为0
        set_page_ref(p, 0);
    }

    //新的空闲块
    base->property = n;
c0102e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e46:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e49:	89 50 08             	mov    %edx,0x8(%eax)
    //新的头部标志,因为传进来的可能不是头部
    SetPageProperty(base);
c0102e4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4f:	83 c0 04             	add    $0x4,%eax
c0102e52:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102e59:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102e5f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102e62:	0f ab 10             	bts    %edx,(%eax)
c0102e65:	c7 45 c8 b0 89 11 c0 	movl   $0xc01189b0,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e6f:	8b 40 04             	mov    0x4(%eax),%eax

//版本二
	
    list_entry_t *le = list_next(&free_list);
c0102e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
    p = le2page(le, page_link);
c0102e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e78:	83 e8 0c             	sub    $0xc,%eax
c0102e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
    while (le != &free_list && p < base)
c0102e7e:	eb 18                	jmp    c0102e98 <default_free_pages+0x175>
c0102e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e83:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102e86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e89:	8b 40 04             	mov    0x4(%eax),%eax
    {
	le = list_next(le);
c0102e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le, page_link);
c0102e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e92:	83 e8 0c             	sub    $0xc,%eax
c0102e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
    list_entry_t *le = list_next(&free_list);
	
    p = le2page(le, page_link);
	
    while (le != &free_list && p < base)
c0102e98:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102e9f:	74 08                	je     c0102ea9 <default_free_pages+0x186>
c0102ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ea7:	72 d7                	jb     c0102e80 <default_free_pages+0x15d>
	p = le2page(le, page_link);
    }
    //p的地址大于base的地址

    //三种特殊情况：头部 base 头部， 头部 base 普通， 普通 base 头部
    list_add_before(le, &(base->page_link));
c0102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eac:	8d 50 0c             	lea    0xc(%eax),%edx
c0102eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eb2:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102eb5:	89 55 bc             	mov    %edx,-0x44(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102eb8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ebb:	8b 00                	mov    (%eax),%eax
c0102ebd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ec0:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102ec3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102ec6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ec9:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ecc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ecf:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102ed2:	89 10                	mov    %edx,(%eax)
c0102ed4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ed7:	8b 10                	mov    (%eax),%edx
c0102ed9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102edc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102edf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102ee2:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102ee5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ee8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102eeb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102eee:	89 10                	mov    %edx,(%eax)
c0102ef0:	c7 45 ac b0 89 11 c0 	movl   $0xc01189b0,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102ef7:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102efa:	8b 40 04             	mov    0x4(%eax),%eax

    //进行合并
    le = list_next(&free_list);
c0102efd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
    p = le2page(le, page_link);
c0102f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f03:	83 e8 0c             	sub    $0xc,%eax
c0102f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
   	
         list_del(&(p->page_link));
	}
    }
#endif
    while (le != &free_list)
c0102f09:	e9 1c 01 00 00       	jmp    c010302a <default_free_pages+0x307>
    {		
	p = le2page(le, page_link);
c0102f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f11:	83 e8 0c             	sub    $0xc,%eax
c0102f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//与前面的合并
	if (p + p->property == base) {
c0102f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f1a:	8b 50 08             	mov    0x8(%eax),%edx
c0102f1d:	89 d0                	mov    %edx,%eax
c0102f1f:	c1 e0 02             	shl    $0x2,%eax
c0102f22:	01 d0                	add    %edx,%eax
c0102f24:	c1 e0 02             	shl    $0x2,%eax
c0102f27:	89 c2                	mov    %eax,%edx
c0102f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2c:	01 d0                	add    %edx,%eax
c0102f2e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102f31:	75 6a                	jne    c0102f9d <default_free_pages+0x27a>
	    p->property += base->property;
c0102f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f36:	8b 50 08             	mov    0x8(%eax),%edx
c0102f39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f3c:	8b 40 08             	mov    0x8(%eax),%eax
c0102f3f:	01 c2                	add    %eax,%edx
c0102f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f44:	89 50 08             	mov    %edx,0x8(%eax)
	    base->property = 0;
c0102f47:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ClearPageProperty(base);
c0102f51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f54:	83 c0 04             	add    $0x4,%eax
c0102f57:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0102f5e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f61:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f64:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f67:	0f b3 10             	btr    %edx,(%eax)
	    list_del(&(base->page_link));
c0102f6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f6d:	83 c0 0c             	add    $0xc,%eax
c0102f70:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102f73:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f76:	8b 40 04             	mov    0x4(%eax),%eax
c0102f79:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102f7c:	8b 12                	mov    (%edx),%edx
c0102f7e:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0102f81:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102f84:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f87:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102f8a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f8d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f90:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102f93:	89 10                	mov    %edx,(%eax)
	    base = p;
c0102f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f98:	89 45 08             	mov    %eax,0x8(%ebp)
c0102f9b:	eb 7e                	jmp    c010301b <default_free_pages+0x2f8>
	}
	//与后面的合并
	else if (base + base->property == p) {
c0102f9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fa0:	8b 50 08             	mov    0x8(%eax),%edx
c0102fa3:	89 d0                	mov    %edx,%eax
c0102fa5:	c1 e0 02             	shl    $0x2,%eax
c0102fa8:	01 d0                	add    %edx,%eax
c0102faa:	c1 e0 02             	shl    $0x2,%eax
c0102fad:	89 c2                	mov    %eax,%edx
c0102faf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fb2:	01 d0                	add    %edx,%eax
c0102fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fb7:	75 62                	jne    c010301b <default_free_pages+0x2f8>
            base->property += p->property;
c0102fb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fbc:	8b 50 08             	mov    0x8(%eax),%edx
c0102fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fc2:	8b 40 08             	mov    0x8(%eax),%eax
c0102fc5:	01 c2                	add    %eax,%edx
c0102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fca:	89 50 08             	mov    %edx,0x8(%eax)
	    p->property = 0;
c0102fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c0102fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fda:	83 c0 04             	add    $0x4,%eax
c0102fdd:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0102fe4:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102fe7:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fea:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102fed:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ff3:	83 c0 0c             	add    $0xc,%eax
c0102ff6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102ff9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ffc:	8b 40 04             	mov    0x4(%eax),%eax
c0102fff:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103002:	8b 12                	mov    (%edx),%edx
c0103004:	89 55 88             	mov    %edx,-0x78(%ebp)
c0103007:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010300a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010300d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103010:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103013:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103016:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103019:	89 10                	mov    %edx,(%eax)
c010301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010301e:	89 45 80             	mov    %eax,-0x80(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103021:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103024:	8b 40 04             	mov    0x4(%eax),%eax
        }
		
	le = list_next(le);
c0103027:	89 45 f0             	mov    %eax,-0x10(%ebp)
   	
         list_del(&(p->page_link));
	}
    }
#endif
    while (le != &free_list)
c010302a:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0103031:	0f 85 d7 fe ff ff    	jne    c0102f0e <default_free_pages+0x1eb>
        }
		
	le = list_next(le);
        
    }
    nr_free += n;
c0103037:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c010303d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103040:	01 d0                	add    %edx,%eax
c0103042:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
}
c0103047:	c9                   	leave  
c0103048:	c3                   	ret    

c0103049 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103049:	55                   	push   %ebp
c010304a:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010304c:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
}
c0103051:	5d                   	pop    %ebp
c0103052:	c3                   	ret    

c0103053 <basic_check>:

static void
basic_check(void) {
c0103053:	55                   	push   %ebp
c0103054:	89 e5                	mov    %esp,%ebp
c0103056:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103060:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103063:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103066:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103069:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010306c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103073:	e8 a8 0e 00 00       	call   c0103f20 <alloc_pages>
c0103078:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010307b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010307f:	75 24                	jne    c01030a5 <basic_check+0x52>
c0103081:	c7 44 24 0c a5 69 10 	movl   $0xc01069a5,0xc(%esp)
c0103088:	c0 
c0103089:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103090:	c0 
c0103091:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0103098:	00 
c0103099:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01030a0:	e8 2c dc ff ff       	call   c0100cd1 <__panic>
#if 0
	//调试分配的第一个物理页
	assert(!PageReserved(p0));

#endif
    assert((p1 = alloc_page()) != NULL);
c01030a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030ac:	e8 6f 0e 00 00       	call   c0103f20 <alloc_pages>
c01030b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030b8:	75 24                	jne    c01030de <basic_check+0x8b>
c01030ba:	c7 44 24 0c c1 69 10 	movl   $0xc01069c1,0xc(%esp)
c01030c1:	c0 
c01030c2:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01030c9:	c0 
c01030ca:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01030d1:	00 
c01030d2:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01030d9:	e8 f3 db ff ff       	call   c0100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030e5:	e8 36 0e 00 00       	call   c0103f20 <alloc_pages>
c01030ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030f1:	75 24                	jne    c0103117 <basic_check+0xc4>
c01030f3:	c7 44 24 0c dd 69 10 	movl   $0xc01069dd,0xc(%esp)
c01030fa:	c0 
c01030fb:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103102:	c0 
c0103103:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c010310a:	00 
c010310b:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103112:	e8 ba db ff ff       	call   c0100cd1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103117:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010311a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010311d:	74 10                	je     c010312f <basic_check+0xdc>
c010311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103122:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103125:	74 08                	je     c010312f <basic_check+0xdc>
c0103127:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010312a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010312d:	75 24                	jne    c0103153 <basic_check+0x100>
c010312f:	c7 44 24 0c fc 69 10 	movl   $0xc01069fc,0xc(%esp)
c0103136:	c0 
c0103137:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010313e:	c0 
c010313f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0103146:	00 
c0103147:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010314e:	e8 7e db ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103153:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103156:	89 04 24             	mov    %eax,(%esp)
c0103159:	e8 54 f8 ff ff       	call   c01029b2 <page_ref>
c010315e:	85 c0                	test   %eax,%eax
c0103160:	75 1e                	jne    c0103180 <basic_check+0x12d>
c0103162:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103165:	89 04 24             	mov    %eax,(%esp)
c0103168:	e8 45 f8 ff ff       	call   c01029b2 <page_ref>
c010316d:	85 c0                	test   %eax,%eax
c010316f:	75 0f                	jne    c0103180 <basic_check+0x12d>
c0103171:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103174:	89 04 24             	mov    %eax,(%esp)
c0103177:	e8 36 f8 ff ff       	call   c01029b2 <page_ref>
c010317c:	85 c0                	test   %eax,%eax
c010317e:	74 24                	je     c01031a4 <basic_check+0x151>
c0103180:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c0103187:	c0 
c0103188:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010318f:	c0 
c0103190:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0103197:	00 
c0103198:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010319f:	e8 2d db ff ff       	call   c0100cd1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01031a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031a7:	89 04 24             	mov    %eax,(%esp)
c01031aa:	e8 ed f7 ff ff       	call   c010299c <page2pa>
c01031af:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01031b5:	c1 e2 0c             	shl    $0xc,%edx
c01031b8:	39 d0                	cmp    %edx,%eax
c01031ba:	72 24                	jb     c01031e0 <basic_check+0x18d>
c01031bc:	c7 44 24 0c 5c 6a 10 	movl   $0xc0106a5c,0xc(%esp)
c01031c3:	c0 
c01031c4:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01031cb:	c0 
c01031cc:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01031d3:	00 
c01031d4:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01031db:	e8 f1 da ff ff       	call   c0100cd1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031e3:	89 04 24             	mov    %eax,(%esp)
c01031e6:	e8 b1 f7 ff ff       	call   c010299c <page2pa>
c01031eb:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01031f1:	c1 e2 0c             	shl    $0xc,%edx
c01031f4:	39 d0                	cmp    %edx,%eax
c01031f6:	72 24                	jb     c010321c <basic_check+0x1c9>
c01031f8:	c7 44 24 0c 79 6a 10 	movl   $0xc0106a79,0xc(%esp)
c01031ff:	c0 
c0103200:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103207:	c0 
c0103208:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c010320f:	00 
c0103210:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103217:	e8 b5 da ff ff       	call   c0100cd1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010321f:	89 04 24             	mov    %eax,(%esp)
c0103222:	e8 75 f7 ff ff       	call   c010299c <page2pa>
c0103227:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010322d:	c1 e2 0c             	shl    $0xc,%edx
c0103230:	39 d0                	cmp    %edx,%eax
c0103232:	72 24                	jb     c0103258 <basic_check+0x205>
c0103234:	c7 44 24 0c 96 6a 10 	movl   $0xc0106a96,0xc(%esp)
c010323b:	c0 
c010323c:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103243:	c0 
c0103244:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c010324b:	00 
c010324c:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103253:	e8 79 da ff ff       	call   c0100cd1 <__panic>

    list_entry_t free_list_store = free_list;
c0103258:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c010325d:	8b 15 b4 89 11 c0    	mov    0xc01189b4,%edx
c0103263:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103266:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103269:	c7 45 e0 b0 89 11 c0 	movl   $0xc01189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103270:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103273:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103276:	89 50 04             	mov    %edx,0x4(%eax)
c0103279:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010327c:	8b 50 04             	mov    0x4(%eax),%edx
c010327f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103282:	89 10                	mov    %edx,(%eax)
c0103284:	c7 45 dc b0 89 11 c0 	movl   $0xc01189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010328b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010328e:	8b 40 04             	mov    0x4(%eax),%eax
c0103291:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103294:	0f 94 c0             	sete   %al
c0103297:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010329a:	85 c0                	test   %eax,%eax
c010329c:	75 24                	jne    c01032c2 <basic_check+0x26f>
c010329e:	c7 44 24 0c b3 6a 10 	movl   $0xc0106ab3,0xc(%esp)
c01032a5:	c0 
c01032a6:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01032ad:	c0 
c01032ae:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c01032b5:	00 
c01032b6:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01032bd:	e8 0f da ff ff       	call   c0100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
c01032c2:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c01032c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032ca:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c01032d1:	00 00 00 

    assert(alloc_page() == NULL);
c01032d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032db:	e8 40 0c 00 00       	call   c0103f20 <alloc_pages>
c01032e0:	85 c0                	test   %eax,%eax
c01032e2:	74 24                	je     c0103308 <basic_check+0x2b5>
c01032e4:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c01032eb:	c0 
c01032ec:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01032f3:	c0 
c01032f4:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01032fb:	00 
c01032fc:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103303:	e8 c9 d9 ff ff       	call   c0100cd1 <__panic>

    free_page(p0);
c0103308:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010330f:	00 
c0103310:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103313:	89 04 24             	mov    %eax,(%esp)
c0103316:	e8 3d 0c 00 00       	call   c0103f58 <free_pages>

    free_page(p1);
c010331b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103322:	00 
c0103323:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103326:	89 04 24             	mov    %eax,(%esp)
c0103329:	e8 2a 0c 00 00       	call   c0103f58 <free_pages>
    free_page(p2);
c010332e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103335:	00 
c0103336:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103339:	89 04 24             	mov    %eax,(%esp)
c010333c:	e8 17 0c 00 00       	call   c0103f58 <free_pages>


    assert(nr_free == 3);
c0103341:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103346:	83 f8 03             	cmp    $0x3,%eax
c0103349:	74 24                	je     c010336f <basic_check+0x31c>
c010334b:	c7 44 24 0c df 6a 10 	movl   $0xc0106adf,0xc(%esp)
c0103352:	c0 
c0103353:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010335a:	c0 
c010335b:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c0103362:	00 
c0103363:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010336a:	e8 62 d9 ff ff       	call   c0100cd1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010336f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103376:	e8 a5 0b 00 00       	call   c0103f20 <alloc_pages>
c010337b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010337e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103382:	75 24                	jne    c01033a8 <basic_check+0x355>
c0103384:	c7 44 24 0c a5 69 10 	movl   $0xc01069a5,0xc(%esp)
c010338b:	c0 
c010338c:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103393:	c0 
c0103394:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
c010339b:	00 
c010339c:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01033a3:	e8 29 d9 ff ff       	call   c0100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01033a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033af:	e8 6c 0b 00 00       	call   c0103f20 <alloc_pages>
c01033b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033bb:	75 24                	jne    c01033e1 <basic_check+0x38e>
c01033bd:	c7 44 24 0c c1 69 10 	movl   $0xc01069c1,0xc(%esp)
c01033c4:	c0 
c01033c5:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01033cc:	c0 
c01033cd:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
c01033d4:	00 
c01033d5:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01033dc:	e8 f0 d8 ff ff       	call   c0100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033e8:	e8 33 0b 00 00       	call   c0103f20 <alloc_pages>
c01033ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033f4:	75 24                	jne    c010341a <basic_check+0x3c7>
c01033f6:	c7 44 24 0c dd 69 10 	movl   $0xc01069dd,0xc(%esp)
c01033fd:	c0 
c01033fe:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103405:	c0 
c0103406:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c010340d:	00 
c010340e:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103415:	e8 b7 d8 ff ff       	call   c0100cd1 <__panic>

    assert(alloc_page() == NULL);
c010341a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103421:	e8 fa 0a 00 00       	call   c0103f20 <alloc_pages>
c0103426:	85 c0                	test   %eax,%eax
c0103428:	74 24                	je     c010344e <basic_check+0x3fb>
c010342a:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c0103431:	c0 
c0103432:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103439:	c0 
c010343a:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c0103441:	00 
c0103442:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103449:	e8 83 d8 ff ff       	call   c0100cd1 <__panic>

    free_page(p0);
c010344e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103455:	00 
c0103456:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103459:	89 04 24             	mov    %eax,(%esp)
c010345c:	e8 f7 0a 00 00       	call   c0103f58 <free_pages>
c0103461:	c7 45 d8 b0 89 11 c0 	movl   $0xc01189b0,-0x28(%ebp)
c0103468:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010346b:	8b 40 04             	mov    0x4(%eax),%eax
c010346e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103471:	0f 94 c0             	sete   %al
c0103474:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103477:	85 c0                	test   %eax,%eax
c0103479:	74 24                	je     c010349f <basic_check+0x44c>
c010347b:	c7 44 24 0c ec 6a 10 	movl   $0xc0106aec,0xc(%esp)
c0103482:	c0 
c0103483:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010348a:	c0 
c010348b:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0103492:	00 
c0103493:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010349a:	e8 32 d8 ff ff       	call   c0100cd1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010349f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034a6:	e8 75 0a 00 00       	call   c0103f20 <alloc_pages>
c01034ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034b4:	74 24                	je     c01034da <basic_check+0x487>
c01034b6:	c7 44 24 0c 04 6b 10 	movl   $0xc0106b04,0xc(%esp)
c01034bd:	c0 
c01034be:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01034c5:	c0 
c01034c6:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c01034cd:	00 
c01034ce:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01034d5:	e8 f7 d7 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c01034da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034e1:	e8 3a 0a 00 00       	call   c0103f20 <alloc_pages>
c01034e6:	85 c0                	test   %eax,%eax
c01034e8:	74 24                	je     c010350e <basic_check+0x4bb>
c01034ea:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c01034f1:	c0 
c01034f2:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01034f9:	c0 
c01034fa:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
c0103501:	00 
c0103502:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103509:	e8 c3 d7 ff ff       	call   c0100cd1 <__panic>

    assert(nr_free == 0);
c010350e:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103513:	85 c0                	test   %eax,%eax
c0103515:	74 24                	je     c010353b <basic_check+0x4e8>
c0103517:	c7 44 24 0c 1d 6b 10 	movl   $0xc0106b1d,0xc(%esp)
c010351e:	c0 
c010351f:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103526:	c0 
c0103527:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
c010352e:	00 
c010352f:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103536:	e8 96 d7 ff ff       	call   c0100cd1 <__panic>
    free_list = free_list_store;
c010353b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010353e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103541:	a3 b0 89 11 c0       	mov    %eax,0xc01189b0
c0103546:	89 15 b4 89 11 c0    	mov    %edx,0xc01189b4
    nr_free = nr_free_store;
c010354c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010354f:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    free_page(p);
c0103554:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010355b:	00 
c010355c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010355f:	89 04 24             	mov    %eax,(%esp)
c0103562:	e8 f1 09 00 00       	call   c0103f58 <free_pages>
    free_page(p1);
c0103567:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010356e:	00 
c010356f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103572:	89 04 24             	mov    %eax,(%esp)
c0103575:	e8 de 09 00 00       	call   c0103f58 <free_pages>
    free_page(p2);
c010357a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103581:	00 
c0103582:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103585:	89 04 24             	mov    %eax,(%esp)
c0103588:	e8 cb 09 00 00       	call   c0103f58 <free_pages>
}
c010358d:	c9                   	leave  
c010358e:	c3                   	ret    

c010358f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010358f:	55                   	push   %ebp
c0103590:	89 e5                	mov    %esp,%ebp
c0103592:	53                   	push   %ebx
c0103593:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035a7:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)
#if 1
    while ((le = list_next(le)) != &free_list) {
c01035ae:	eb 6b                	jmp    c010361b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01035b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035b3:	83 e8 0c             	sub    $0xc,%eax
c01035b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01035b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035bc:	83 c0 04             	add    $0x4,%eax
c01035bf:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035cc:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035cf:	0f a3 10             	bt     %edx,(%eax)
c01035d2:	19 c0                	sbb    %eax,%eax
c01035d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035db:	0f 95 c0             	setne  %al
c01035de:	0f b6 c0             	movzbl %al,%eax
c01035e1:	85 c0                	test   %eax,%eax
c01035e3:	75 24                	jne    c0103609 <default_check+0x7a>
c01035e5:	c7 44 24 0c 2a 6b 10 	movl   $0xc0106b2a,0xc(%esp)
c01035ec:	c0 
c01035ed:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01035f4:	c0 
c01035f5:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
c01035fc:	00 
c01035fd:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103604:	e8 c8 d6 ff ff       	call   c0100cd1 <__panic>
        count ++, total += p->property;
c0103609:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010360d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103610:	8b 50 08             	mov    0x8(%eax),%edx
c0103613:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103616:	01 d0                	add    %edx,%eax
c0103618:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010361b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010361e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103621:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103624:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
#if 1
    while ((le = list_next(le)) != &free_list) {
c0103627:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010362a:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c0103631:	0f 85 79 ff ff ff    	jne    c01035b0 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103637:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010363a:	e8 4b 09 00 00       	call   c0103f8a <nr_free_pages>
c010363f:	39 c3                	cmp    %eax,%ebx
c0103641:	74 24                	je     c0103667 <default_check+0xd8>
c0103643:	c7 44 24 0c 3a 6b 10 	movl   $0xc0106b3a,0xc(%esp)
c010364a:	c0 
c010364b:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103652:	c0 
c0103653:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c010365a:	00 
c010365b:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103662:	e8 6a d6 ff ff       	call   c0100cd1 <__panic>
    basic_check();
c0103667:	e8 e7 f9 ff ff       	call   c0103053 <basic_check>
#endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010366c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103673:	e8 a8 08 00 00       	call   c0103f20 <alloc_pages>
c0103678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010367b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010367f:	75 24                	jne    c01036a5 <default_check+0x116>
c0103681:	c7 44 24 0c 53 6b 10 	movl   $0xc0106b53,0xc(%esp)
c0103688:	c0 
c0103689:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103690:	c0 
c0103691:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c0103698:	00 
c0103699:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01036a0:	e8 2c d6 ff ff       	call   c0100cd1 <__panic>
    assert(!PageProperty(p0));
c01036a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036a8:	83 c0 04             	add    $0x4,%eax
c01036ab:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01036b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01036b8:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036bb:	0f a3 10             	bt     %edx,(%eax)
c01036be:	19 c0                	sbb    %eax,%eax
c01036c0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036c3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036c7:	0f 95 c0             	setne  %al
c01036ca:	0f b6 c0             	movzbl %al,%eax
c01036cd:	85 c0                	test   %eax,%eax
c01036cf:	74 24                	je     c01036f5 <default_check+0x166>
c01036d1:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c01036d8:	c0 
c01036d9:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01036e0:	c0 
c01036e1:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
c01036e8:	00 
c01036e9:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01036f0:	e8 dc d5 ff ff       	call   c0100cd1 <__panic>

    list_entry_t free_list_store = free_list;
c01036f5:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c01036fa:	8b 15 b4 89 11 c0    	mov    0xc01189b4,%edx
c0103700:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103703:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103706:	c7 45 b4 b0 89 11 c0 	movl   $0xc01189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010370d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103710:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103713:	89 50 04             	mov    %edx,0x4(%eax)
c0103716:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103719:	8b 50 04             	mov    0x4(%eax),%edx
c010371c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010371f:	89 10                	mov    %edx,(%eax)
c0103721:	c7 45 b0 b0 89 11 c0 	movl   $0xc01189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103728:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010372b:	8b 40 04             	mov    0x4(%eax),%eax
c010372e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103731:	0f 94 c0             	sete   %al
c0103734:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103737:	85 c0                	test   %eax,%eax
c0103739:	75 24                	jne    c010375f <default_check+0x1d0>
c010373b:	c7 44 24 0c b3 6a 10 	movl   $0xc0106ab3,0xc(%esp)
c0103742:	c0 
c0103743:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010374a:	c0 
c010374b:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
c0103752:	00 
c0103753:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010375a:	e8 72 d5 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c010375f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103766:	e8 b5 07 00 00       	call   c0103f20 <alloc_pages>
c010376b:	85 c0                	test   %eax,%eax
c010376d:	74 24                	je     c0103793 <default_check+0x204>
c010376f:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c0103776:	c0 
c0103777:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010377e:	c0 
c010377f:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
c0103786:	00 
c0103787:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010378e:	e8 3e d5 ff ff       	call   c0100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103793:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103798:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010379b:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c01037a2:	00 00 00 

    free_pages(p0 + 2, 3);
c01037a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037a8:	83 c0 28             	add    $0x28,%eax
c01037ab:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037b2:	00 
c01037b3:	89 04 24             	mov    %eax,(%esp)
c01037b6:	e8 9d 07 00 00       	call   c0103f58 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037bb:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037c2:	e8 59 07 00 00       	call   c0103f20 <alloc_pages>
c01037c7:	85 c0                	test   %eax,%eax
c01037c9:	74 24                	je     c01037ef <default_check+0x260>
c01037cb:	c7 44 24 0c 70 6b 10 	movl   $0xc0106b70,0xc(%esp)
c01037d2:	c0 
c01037d3:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01037da:	c0 
c01037db:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c01037e2:	00 
c01037e3:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01037ea:	e8 e2 d4 ff ff       	call   c0100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037f2:	83 c0 28             	add    $0x28,%eax
c01037f5:	83 c0 04             	add    $0x4,%eax
c01037f8:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037ff:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103802:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103805:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103808:	0f a3 10             	bt     %edx,(%eax)
c010380b:	19 c0                	sbb    %eax,%eax
c010380d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103810:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103814:	0f 95 c0             	setne  %al
c0103817:	0f b6 c0             	movzbl %al,%eax
c010381a:	85 c0                	test   %eax,%eax
c010381c:	74 0e                	je     c010382c <default_check+0x29d>
c010381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103821:	83 c0 28             	add    $0x28,%eax
c0103824:	8b 40 08             	mov    0x8(%eax),%eax
c0103827:	83 f8 03             	cmp    $0x3,%eax
c010382a:	74 24                	je     c0103850 <default_check+0x2c1>
c010382c:	c7 44 24 0c 88 6b 10 	movl   $0xc0106b88,0xc(%esp)
c0103833:	c0 
c0103834:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010383b:	c0 
c010383c:	c7 44 24 04 83 01 00 	movl   $0x183,0x4(%esp)
c0103843:	00 
c0103844:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010384b:	e8 81 d4 ff ff       	call   c0100cd1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103850:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103857:	e8 c4 06 00 00       	call   c0103f20 <alloc_pages>
c010385c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010385f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103863:	75 24                	jne    c0103889 <default_check+0x2fa>
c0103865:	c7 44 24 0c b4 6b 10 	movl   $0xc0106bb4,0xc(%esp)
c010386c:	c0 
c010386d:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103874:	c0 
c0103875:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
c010387c:	00 
c010387d:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103884:	e8 48 d4 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0103889:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103890:	e8 8b 06 00 00       	call   c0103f20 <alloc_pages>
c0103895:	85 c0                	test   %eax,%eax
c0103897:	74 24                	je     c01038bd <default_check+0x32e>
c0103899:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c01038a0:	c0 
c01038a1:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01038a8:	c0 
c01038a9:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c01038b0:	00 
c01038b1:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01038b8:	e8 14 d4 ff ff       	call   c0100cd1 <__panic>
    assert(p0 + 2 == p1);
c01038bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038c0:	83 c0 28             	add    $0x28,%eax
c01038c3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01038c6:	74 24                	je     c01038ec <default_check+0x35d>
c01038c8:	c7 44 24 0c d2 6b 10 	movl   $0xc0106bd2,0xc(%esp)
c01038cf:	c0 
c01038d0:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01038d7:	c0 
c01038d8:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c01038df:	00 
c01038e0:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01038e7:	e8 e5 d3 ff ff       	call   c0100cd1 <__panic>

    p2 = p0 + 1;
c01038ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038ef:	83 c0 14             	add    $0x14,%eax
c01038f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01038f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038fc:	00 
c01038fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103900:	89 04 24             	mov    %eax,(%esp)
c0103903:	e8 50 06 00 00       	call   c0103f58 <free_pages>
    free_pages(p1, 3);
c0103908:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010390f:	00 
c0103910:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103913:	89 04 24             	mov    %eax,(%esp)
c0103916:	e8 3d 06 00 00       	call   c0103f58 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010391b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010391e:	83 c0 04             	add    $0x4,%eax
c0103921:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103928:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010392b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010392e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103931:	0f a3 10             	bt     %edx,(%eax)
c0103934:	19 c0                	sbb    %eax,%eax
c0103936:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103939:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010393d:	0f 95 c0             	setne  %al
c0103940:	0f b6 c0             	movzbl %al,%eax
c0103943:	85 c0                	test   %eax,%eax
c0103945:	74 0b                	je     c0103952 <default_check+0x3c3>
c0103947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010394a:	8b 40 08             	mov    0x8(%eax),%eax
c010394d:	83 f8 01             	cmp    $0x1,%eax
c0103950:	74 24                	je     c0103976 <default_check+0x3e7>
c0103952:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c0103959:	c0 
c010395a:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103961:	c0 
c0103962:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c0103969:	00 
c010396a:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103971:	e8 5b d3 ff ff       	call   c0100cd1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103976:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103979:	83 c0 04             	add    $0x4,%eax
c010397c:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103983:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103986:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103989:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010398c:	0f a3 10             	bt     %edx,(%eax)
c010398f:	19 c0                	sbb    %eax,%eax
c0103991:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103994:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103998:	0f 95 c0             	setne  %al
c010399b:	0f b6 c0             	movzbl %al,%eax
c010399e:	85 c0                	test   %eax,%eax
c01039a0:	74 0b                	je     c01039ad <default_check+0x41e>
c01039a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039a5:	8b 40 08             	mov    0x8(%eax),%eax
c01039a8:	83 f8 03             	cmp    $0x3,%eax
c01039ab:	74 24                	je     c01039d1 <default_check+0x442>
c01039ad:	c7 44 24 0c 08 6c 10 	movl   $0xc0106c08,0xc(%esp)
c01039b4:	c0 
c01039b5:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01039bc:	c0 
c01039bd:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
c01039c4:	00 
c01039c5:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01039cc:	e8 00 d3 ff ff       	call   c0100cd1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039d8:	e8 43 05 00 00       	call   c0103f20 <alloc_pages>
c01039dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01039e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039e3:	83 e8 14             	sub    $0x14,%eax
c01039e6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01039e9:	74 24                	je     c0103a0f <default_check+0x480>
c01039eb:	c7 44 24 0c 2e 6c 10 	movl   $0xc0106c2e,0xc(%esp)
c01039f2:	c0 
c01039f3:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01039fa:	c0 
c01039fb:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
c0103a02:	00 
c0103a03:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103a0a:	e8 c2 d2 ff ff       	call   c0100cd1 <__panic>
    free_page(p0);
c0103a0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a16:	00 
c0103a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a1a:	89 04 24             	mov    %eax,(%esp)
c0103a1d:	e8 36 05 00 00       	call   c0103f58 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a22:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a29:	e8 f2 04 00 00       	call   c0103f20 <alloc_pages>
c0103a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a31:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a34:	83 c0 14             	add    $0x14,%eax
c0103a37:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a3a:	74 24                	je     c0103a60 <default_check+0x4d1>
c0103a3c:	c7 44 24 0c 4c 6c 10 	movl   $0xc0106c4c,0xc(%esp)
c0103a43:	c0 
c0103a44:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103a4b:	c0 
c0103a4c:	c7 44 24 04 90 01 00 	movl   $0x190,0x4(%esp)
c0103a53:	00 
c0103a54:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103a5b:	e8 71 d2 ff ff       	call   c0100cd1 <__panic>

    free_pages(p0, 2);
c0103a60:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a67:	00 
c0103a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a6b:	89 04 24             	mov    %eax,(%esp)
c0103a6e:	e8 e5 04 00 00       	call   c0103f58 <free_pages>
    free_page(p2);
c0103a73:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a7a:	00 
c0103a7b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a7e:	89 04 24             	mov    %eax,(%esp)
c0103a81:	e8 d2 04 00 00       	call   c0103f58 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a86:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a8d:	e8 8e 04 00 00       	call   c0103f20 <alloc_pages>
c0103a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103a99:	75 24                	jne    c0103abf <default_check+0x530>
c0103a9b:	c7 44 24 0c 6c 6c 10 	movl   $0xc0106c6c,0xc(%esp)
c0103aa2:	c0 
c0103aa3:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103aaa:	c0 
c0103aab:	c7 44 24 04 95 01 00 	movl   $0x195,0x4(%esp)
c0103ab2:	00 
c0103ab3:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103aba:	e8 12 d2 ff ff       	call   c0100cd1 <__panic>
    assert(alloc_page() == NULL);
c0103abf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ac6:	e8 55 04 00 00       	call   c0103f20 <alloc_pages>
c0103acb:	85 c0                	test   %eax,%eax
c0103acd:	74 24                	je     c0103af3 <default_check+0x564>
c0103acf:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c0103ad6:	c0 
c0103ad7:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103ade:	c0 
c0103adf:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0103ae6:	00 
c0103ae7:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103aee:	e8 de d1 ff ff       	call   c0100cd1 <__panic>

    assert(nr_free == 0);
c0103af3:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103af8:	85 c0                	test   %eax,%eax
c0103afa:	74 24                	je     c0103b20 <default_check+0x591>
c0103afc:	c7 44 24 0c 1d 6b 10 	movl   $0xc0106b1d,0xc(%esp)
c0103b03:	c0 
c0103b04:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103b0b:	c0 
c0103b0c:	c7 44 24 04 98 01 00 	movl   $0x198,0x4(%esp)
c0103b13:	00 
c0103b14:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103b1b:	e8 b1 d1 ff ff       	call   c0100cd1 <__panic>
    nr_free = nr_free_store;
c0103b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b23:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    free_list = free_list_store;
c0103b28:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b2b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b2e:	a3 b0 89 11 c0       	mov    %eax,0xc01189b0
c0103b33:	89 15 b4 89 11 c0    	mov    %edx,0xc01189b4
    free_pages(p0, 5);
c0103b39:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b40:	00 
c0103b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b44:	89 04 24             	mov    %eax,(%esp)
c0103b47:	e8 0c 04 00 00       	call   c0103f58 <free_pages>

    le = &free_list;
c0103b4c:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b53:	eb 1d                	jmp    c0103b72 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b58:	83 e8 0c             	sub    $0xc,%eax
c0103b5b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103b5e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103b62:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103b68:	8b 40 08             	mov    0x8(%eax),%eax
c0103b6b:	29 c2                	sub    %eax,%edx
c0103b6d:	89 d0                	mov    %edx,%eax
c0103b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b75:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103b78:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b7b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b81:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c0103b88:	75 cb                	jne    c0103b55 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b8e:	74 24                	je     c0103bb4 <default_check+0x625>
c0103b90:	c7 44 24 0c 8a 6c 10 	movl   $0xc0106c8a,0xc(%esp)
c0103b97:	c0 
c0103b98:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103b9f:	c0 
c0103ba0:	c7 44 24 04 a3 01 00 	movl   $0x1a3,0x4(%esp)
c0103ba7:	00 
c0103ba8:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103baf:	e8 1d d1 ff ff       	call   c0100cd1 <__panic>
    assert(total == 0);
c0103bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bb8:	74 24                	je     c0103bde <default_check+0x64f>
c0103bba:	c7 44 24 0c 95 6c 10 	movl   $0xc0106c95,0xc(%esp)
c0103bc1:	c0 
c0103bc2:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103bc9:	c0 
c0103bca:	c7 44 24 04 a4 01 00 	movl   $0x1a4,0x4(%esp)
c0103bd1:	00 
c0103bd2:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103bd9:	e8 f3 d0 ff ff       	call   c0100cd1 <__panic>
}
c0103bde:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103be4:	5b                   	pop    %ebx
c0103be5:	5d                   	pop    %ebp
c0103be6:	c3                   	ret    

c0103be7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103be7:	55                   	push   %ebp
c0103be8:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103bea:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bed:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0103bf2:	29 c2                	sub    %eax,%edx
c0103bf4:	89 d0                	mov    %edx,%eax
c0103bf6:	c1 f8 02             	sar    $0x2,%eax
c0103bf9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103bff:	5d                   	pop    %ebp
c0103c00:	c3                   	ret    

c0103c01 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103c01:	55                   	push   %ebp
c0103c02:	89 e5                	mov    %esp,%ebp
c0103c04:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c0a:	89 04 24             	mov    %eax,(%esp)
c0103c0d:	e8 d5 ff ff ff       	call   c0103be7 <page2ppn>
c0103c12:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c15:	c9                   	leave  
c0103c16:	c3                   	ret    

c0103c17 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103c17:	55                   	push   %ebp
c0103c18:	89 e5                	mov    %esp,%ebp
c0103c1a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c20:	c1 e8 0c             	shr    $0xc,%eax
c0103c23:	89 c2                	mov    %eax,%edx
c0103c25:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c2a:	39 c2                	cmp    %eax,%edx
c0103c2c:	72 1c                	jb     c0103c4a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c2e:	c7 44 24 08 d0 6c 10 	movl   $0xc0106cd0,0x8(%esp)
c0103c35:	c0 
c0103c36:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c3d:	00 
c0103c3e:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0103c45:	e8 87 d0 ff ff       	call   c0100cd1 <__panic>
    }
    return &pages[PPN(pa)];
c0103c4a:	8b 0d c4 89 11 c0    	mov    0xc01189c4,%ecx
c0103c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c53:	c1 e8 0c             	shr    $0xc,%eax
c0103c56:	89 c2                	mov    %eax,%edx
c0103c58:	89 d0                	mov    %edx,%eax
c0103c5a:	c1 e0 02             	shl    $0x2,%eax
c0103c5d:	01 d0                	add    %edx,%eax
c0103c5f:	c1 e0 02             	shl    $0x2,%eax
c0103c62:	01 c8                	add    %ecx,%eax
}
c0103c64:	c9                   	leave  
c0103c65:	c3                   	ret    

c0103c66 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103c66:	55                   	push   %ebp
c0103c67:	89 e5                	mov    %esp,%ebp
c0103c69:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6f:	89 04 24             	mov    %eax,(%esp)
c0103c72:	e8 8a ff ff ff       	call   c0103c01 <page2pa>
c0103c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c7d:	c1 e8 0c             	shr    $0xc,%eax
c0103c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c83:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c88:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103c8b:	72 23                	jb     c0103cb0 <page2kva+0x4a>
c0103c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c90:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c94:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0103c9b:	c0 
c0103c9c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103ca3:	00 
c0103ca4:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0103cab:	e8 21 d0 ff ff       	call   c0100cd1 <__panic>
c0103cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cb8:	c9                   	leave  
c0103cb9:	c3                   	ret    

c0103cba <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103cba:	55                   	push   %ebp
c0103cbb:	89 e5                	mov    %esp,%ebp
c0103cbd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103cc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cc3:	83 e0 01             	and    $0x1,%eax
c0103cc6:	85 c0                	test   %eax,%eax
c0103cc8:	75 1c                	jne    c0103ce6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103cca:	c7 44 24 08 24 6d 10 	movl   $0xc0106d24,0x8(%esp)
c0103cd1:	c0 
c0103cd2:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cd9:	00 
c0103cda:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0103ce1:	e8 eb cf ff ff       	call   c0100cd1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cee:	89 04 24             	mov    %eax,(%esp)
c0103cf1:	e8 21 ff ff ff       	call   c0103c17 <pa2page>
}
c0103cf6:	c9                   	leave  
c0103cf7:	c3                   	ret    

c0103cf8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103cf8:	55                   	push   %ebp
c0103cf9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cfe:	8b 00                	mov    (%eax),%eax
}
c0103d00:	5d                   	pop    %ebp
c0103d01:	c3                   	ret    

c0103d02 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103d02:	55                   	push   %ebp
c0103d03:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0b:	89 10                	mov    %edx,(%eax)
}
c0103d0d:	5d                   	pop    %ebp
c0103d0e:	c3                   	ret    

c0103d0f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d0f:	55                   	push   %ebp
c0103d10:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d15:	8b 00                	mov    (%eax),%eax
c0103d17:	8d 50 01             	lea    0x1(%eax),%edx
c0103d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d1d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d22:	8b 00                	mov    (%eax),%eax
}
c0103d24:	5d                   	pop    %ebp
c0103d25:	c3                   	ret    

c0103d26 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d26:	55                   	push   %ebp
c0103d27:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d2c:	8b 00                	mov    (%eax),%eax
c0103d2e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d34:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d39:	8b 00                	mov    (%eax),%eax
}
c0103d3b:	5d                   	pop    %ebp
c0103d3c:	c3                   	ret    

c0103d3d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103d3d:	55                   	push   %ebp
c0103d3e:	89 e5                	mov    %esp,%ebp
c0103d40:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d43:	9c                   	pushf  
c0103d44:	58                   	pop    %eax
c0103d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d4b:	25 00 02 00 00       	and    $0x200,%eax
c0103d50:	85 c0                	test   %eax,%eax
c0103d52:	74 0c                	je     c0103d60 <__intr_save+0x23>
        intr_disable();
c0103d54:	e8 5b d9 ff ff       	call   c01016b4 <intr_disable>
        return 1;
c0103d59:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d5e:	eb 05                	jmp    c0103d65 <__intr_save+0x28>
    }
    return 0;
c0103d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d65:	c9                   	leave  
c0103d66:	c3                   	ret    

c0103d67 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103d67:	55                   	push   %ebp
c0103d68:	89 e5                	mov    %esp,%ebp
c0103d6a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103d6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103d71:	74 05                	je     c0103d78 <__intr_restore+0x11>
        intr_enable();
c0103d73:	e8 36 d9 ff ff       	call   c01016ae <intr_enable>
    }
}
c0103d78:	c9                   	leave  
c0103d79:	c3                   	ret    

c0103d7a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103d7a:	55                   	push   %ebp
c0103d7b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d80:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103d83:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d88:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103d8a:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d8f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103d91:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d96:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103d98:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d9d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103d9f:	b8 10 00 00 00       	mov    $0x10,%eax
c0103da4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103da6:	ea ad 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103dad
}
c0103dad:	5d                   	pop    %ebp
c0103dae:	c3                   	ret    

c0103daf <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103daf:	55                   	push   %ebp
c0103db0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db5:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103dba:	5d                   	pop    %ebp
c0103dbb:	c3                   	ret    

c0103dbc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103dbc:	55                   	push   %ebp
c0103dbd:	89 e5                	mov    %esp,%ebp
c0103dbf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103dc2:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103dc7:	89 04 24             	mov    %eax,(%esp)
c0103dca:	e8 e0 ff ff ff       	call   c0103daf <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103dcf:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103dd6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103dd8:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103ddf:	68 00 
c0103de1:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103de6:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103dec:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103df1:	c1 e8 10             	shr    $0x10,%eax
c0103df4:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103df9:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e00:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e03:	83 c8 09             	or     $0x9,%eax
c0103e06:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e0b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e12:	83 e0 ef             	and    $0xffffffef,%eax
c0103e15:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e1a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e21:	83 e0 9f             	and    $0xffffff9f,%eax
c0103e24:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e29:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e30:	83 c8 80             	or     $0xffffff80,%eax
c0103e33:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e38:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e3f:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e42:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e47:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e4e:	83 e0 ef             	and    $0xffffffef,%eax
c0103e51:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e56:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e5d:	83 e0 df             	and    $0xffffffdf,%eax
c0103e60:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e65:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e6c:	83 c8 40             	or     $0x40,%eax
c0103e6f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e74:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e7b:	83 e0 7f             	and    $0x7f,%eax
c0103e7e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e83:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103e88:	c1 e8 18             	shr    $0x18,%eax
c0103e8b:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103e90:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103e97:	e8 de fe ff ff       	call   c0103d7a <lgdt>
c0103e9c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103ea2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103ea6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103ea9:	c9                   	leave  
c0103eaa:	c3                   	ret    

c0103eab <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103eab:	55                   	push   %ebp
c0103eac:	89 e5                	mov    %esp,%ebp
c0103eae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103eb1:	c7 05 bc 89 11 c0 b4 	movl   $0xc0106cb4,0xc01189bc
c0103eb8:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ebb:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103ec0:	8b 00                	mov    (%eax),%eax
c0103ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ec6:	c7 04 24 50 6d 10 c0 	movl   $0xc0106d50,(%esp)
c0103ecd:	e8 75 c4 ff ff       	call   c0100347 <cprintf>
    pmm_manager->init();
c0103ed2:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103ed7:	8b 40 04             	mov    0x4(%eax),%eax
c0103eda:	ff d0                	call   *%eax
}
c0103edc:	c9                   	leave  
c0103edd:	c3                   	ret    

c0103ede <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ede:	55                   	push   %ebp
c0103edf:	89 e5                	mov    %esp,%ebp
c0103ee1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s in %s n is %d\n",  __func__, __FILE__, n);
c0103ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ee7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103eeb:	c7 44 24 08 67 6d 10 	movl   $0xc0106d67,0x8(%esp)
c0103ef2:	c0 
c0103ef3:	c7 44 24 04 41 73 10 	movl   $0xc0107341,0x4(%esp)
c0103efa:	c0 
c0103efb:	c7 04 24 75 6d 10 c0 	movl   $0xc0106d75,(%esp)
c0103f02:	e8 40 c4 ff ff       	call   c0100347 <cprintf>
    pmm_manager->init_memmap(base, n);
c0103f07:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103f0c:	8b 40 08             	mov    0x8(%eax),%eax
c0103f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f12:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f16:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f19:	89 14 24             	mov    %edx,(%esp)
c0103f1c:	ff d0                	call   *%eax
}
c0103f1e:	c9                   	leave  
c0103f1f:	c3                   	ret    

c0103f20 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f20:	55                   	push   %ebp
c0103f21:	89 e5                	mov    %esp,%ebp
c0103f23:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f2d:	e8 0b fe ff ff       	call   c0103d3d <__intr_save>
c0103f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f35:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103f3a:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f3d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f40:	89 14 24             	mov    %edx,(%esp)
c0103f43:	ff d0                	call   *%eax
c0103f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f4b:	89 04 24             	mov    %eax,(%esp)
c0103f4e:	e8 14 fe ff ff       	call   c0103d67 <__intr_restore>
    return page;
c0103f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f56:	c9                   	leave  
c0103f57:	c3                   	ret    

c0103f58 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f58:	55                   	push   %ebp
c0103f59:	89 e5                	mov    %esp,%ebp
c0103f5b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f5e:	e8 da fd ff ff       	call   c0103d3d <__intr_save>
c0103f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f66:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103f6b:	8b 40 10             	mov    0x10(%eax),%eax
c0103f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f71:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f75:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f78:	89 14 24             	mov    %edx,(%esp)
c0103f7b:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f80:	89 04 24             	mov    %eax,(%esp)
c0103f83:	e8 df fd ff ff       	call   c0103d67 <__intr_restore>
}
c0103f88:	c9                   	leave  
c0103f89:	c3                   	ret    

c0103f8a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103f8a:	55                   	push   %ebp
c0103f8b:	89 e5                	mov    %esp,%ebp
c0103f8d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f90:	e8 a8 fd ff ff       	call   c0103d3d <__intr_save>
c0103f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103f98:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103f9d:	8b 40 14             	mov    0x14(%eax),%eax
c0103fa0:	ff d0                	call   *%eax
c0103fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fa8:	89 04 24             	mov    %eax,(%esp)
c0103fab:	e8 b7 fd ff ff       	call   c0103d67 <__intr_restore>
    return ret;
c0103fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103fb3:	c9                   	leave  
c0103fb4:	c3                   	ret    

c0103fb5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103fb5:	55                   	push   %ebp
c0103fb6:	89 e5                	mov    %esp,%ebp
c0103fb8:	57                   	push   %edi
c0103fb9:	56                   	push   %esi
c0103fba:	53                   	push   %ebx
c0103fbb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103fc1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103fc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fcf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103fd6:	c7 04 24 87 6d 10 c0 	movl   $0xc0106d87,(%esp)
c0103fdd:	e8 65 c3 ff ff       	call   c0100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fe2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fe9:	e9 15 01 00 00       	jmp    c0104103 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ff4:	89 d0                	mov    %edx,%eax
c0103ff6:	c1 e0 02             	shl    $0x2,%eax
c0103ff9:	01 d0                	add    %edx,%eax
c0103ffb:	c1 e0 02             	shl    $0x2,%eax
c0103ffe:	01 c8                	add    %ecx,%eax
c0104000:	8b 50 08             	mov    0x8(%eax),%edx
c0104003:	8b 40 04             	mov    0x4(%eax),%eax
c0104006:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104009:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010400c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010400f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104012:	89 d0                	mov    %edx,%eax
c0104014:	c1 e0 02             	shl    $0x2,%eax
c0104017:	01 d0                	add    %edx,%eax
c0104019:	c1 e0 02             	shl    $0x2,%eax
c010401c:	01 c8                	add    %ecx,%eax
c010401e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104021:	8b 58 10             	mov    0x10(%eax),%ebx
c0104024:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104027:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010402a:	01 c8                	add    %ecx,%eax
c010402c:	11 da                	adc    %ebx,%edx
c010402e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104031:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104034:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010403a:	89 d0                	mov    %edx,%eax
c010403c:	c1 e0 02             	shl    $0x2,%eax
c010403f:	01 d0                	add    %edx,%eax
c0104041:	c1 e0 02             	shl    $0x2,%eax
c0104044:	01 c8                	add    %ecx,%eax
c0104046:	83 c0 14             	add    $0x14,%eax
c0104049:	8b 00                	mov    (%eax),%eax
c010404b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104051:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104054:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104057:	83 c0 ff             	add    $0xffffffff,%eax
c010405a:	83 d2 ff             	adc    $0xffffffff,%edx
c010405d:	89 c6                	mov    %eax,%esi
c010405f:	89 d7                	mov    %edx,%edi
c0104061:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104064:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104067:	89 d0                	mov    %edx,%eax
c0104069:	c1 e0 02             	shl    $0x2,%eax
c010406c:	01 d0                	add    %edx,%eax
c010406e:	c1 e0 02             	shl    $0x2,%eax
c0104071:	01 c8                	add    %ecx,%eax
c0104073:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104076:	8b 58 10             	mov    0x10(%eax),%ebx
c0104079:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010407f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104083:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104087:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010408b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010408e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104091:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104095:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104099:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010409d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040a1:	c7 04 24 94 6d 10 c0 	movl   $0xc0106d94,(%esp)
c01040a8:	e8 9a c2 ff ff       	call   c0100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040ad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040b3:	89 d0                	mov    %edx,%eax
c01040b5:	c1 e0 02             	shl    $0x2,%eax
c01040b8:	01 d0                	add    %edx,%eax
c01040ba:	c1 e0 02             	shl    $0x2,%eax
c01040bd:	01 c8                	add    %ecx,%eax
c01040bf:	83 c0 14             	add    $0x14,%eax
c01040c2:	8b 00                	mov    (%eax),%eax
c01040c4:	83 f8 01             	cmp    $0x1,%eax
c01040c7:	75 36                	jne    c01040ff <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01040c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040cf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01040d2:	77 2b                	ja     c01040ff <page_init+0x14a>
c01040d4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01040d7:	72 05                	jb     c01040de <page_init+0x129>
c01040d9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01040dc:	73 21                	jae    c01040ff <page_init+0x14a>
c01040de:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040e2:	77 1b                	ja     c01040ff <page_init+0x14a>
c01040e4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040e8:	72 09                	jb     c01040f3 <page_init+0x13e>
c01040ea:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01040f1:	77 0c                	ja     c01040ff <page_init+0x14a>
                maxpa = end;
c01040f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01040f6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01040f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01040ff:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104103:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104106:	8b 00                	mov    (%eax),%eax
c0104108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010410b:	0f 8f dd fe ff ff    	jg     c0103fee <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104111:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104115:	72 1d                	jb     c0104134 <page_init+0x17f>
c0104117:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010411b:	77 09                	ja     c0104126 <page_init+0x171>
c010411d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104124:	76 0e                	jbe    c0104134 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104126:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010412d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];
//    cprintf("the maxpa is: %08llx\n", maxpa);
    npage = maxpa / PGSIZE;
c0104134:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104137:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010413a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010413e:	c1 ea 0c             	shr    $0xc,%edx
c0104141:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104146:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010414d:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c0104152:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104155:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104158:	01 d0                	add    %edx,%eax
c010415a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010415d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104160:	ba 00 00 00 00       	mov    $0x0,%edx
c0104165:	f7 75 ac             	divl   -0x54(%ebp)
c0104168:	89 d0                	mov    %edx,%eax
c010416a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010416d:	29 c2                	sub    %eax,%edx
c010416f:	89 d0                	mov    %edx,%eax
c0104171:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    for (i = 0; i < npage; i ++) {
c0104176:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010417d:	eb 2f                	jmp    c01041ae <page_init+0x1f9>
        SetPageReserved(pages + i);
c010417f:	8b 0d c4 89 11 c0    	mov    0xc01189c4,%ecx
c0104185:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104188:	89 d0                	mov    %edx,%eax
c010418a:	c1 e0 02             	shl    $0x2,%eax
c010418d:	01 d0                	add    %edx,%eax
c010418f:	c1 e0 02             	shl    $0x2,%eax
c0104192:	01 c8                	add    %ecx,%eax
c0104194:	83 c0 04             	add    $0x4,%eax
c0104197:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010419e:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01041a1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01041a4:	8b 55 90             	mov    -0x70(%ebp),%edx
c01041a7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];
//    cprintf("the maxpa is: %08llx\n", maxpa);
    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01041aa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041b1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01041b6:	39 c2                	cmp    %eax,%edx
c01041b8:	72 c5                	jb     c010417f <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041ba:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01041c0:	89 d0                	mov    %edx,%eax
c01041c2:	c1 e0 02             	shl    $0x2,%eax
c01041c5:	01 d0                	add    %edx,%eax
c01041c7:	c1 e0 02             	shl    $0x2,%eax
c01041ca:	89 c2                	mov    %eax,%edx
c01041cc:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01041d1:	01 d0                	add    %edx,%eax
c01041d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01041d6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01041dd:	77 23                	ja     c0104202 <page_init+0x24d>
c01041df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041e6:	c7 44 24 08 c4 6d 10 	movl   $0xc0106dc4,0x8(%esp)
c01041ed:	c0 
c01041ee:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01041f5:	00 
c01041f6:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01041fd:	e8 cf ca ff ff       	call   c0100cd1 <__panic>
c0104202:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104205:	05 00 00 00 40       	add    $0x40000000,%eax
c010420a:	89 45 a0             	mov    %eax,-0x60(%ebp)
//    cprintf("the freemem is: %08llx\n", freemem);
    for (i = 0; i < memmap->nr_map; i ++) {
c010420d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104214:	e9 74 01 00 00       	jmp    c010438d <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104219:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010421c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010421f:	89 d0                	mov    %edx,%eax
c0104221:	c1 e0 02             	shl    $0x2,%eax
c0104224:	01 d0                	add    %edx,%eax
c0104226:	c1 e0 02             	shl    $0x2,%eax
c0104229:	01 c8                	add    %ecx,%eax
c010422b:	8b 50 08             	mov    0x8(%eax),%edx
c010422e:	8b 40 04             	mov    0x4(%eax),%eax
c0104231:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104234:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104237:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010423a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010423d:	89 d0                	mov    %edx,%eax
c010423f:	c1 e0 02             	shl    $0x2,%eax
c0104242:	01 d0                	add    %edx,%eax
c0104244:	c1 e0 02             	shl    $0x2,%eax
c0104247:	01 c8                	add    %ecx,%eax
c0104249:	8b 48 0c             	mov    0xc(%eax),%ecx
c010424c:	8b 58 10             	mov    0x10(%eax),%ebx
c010424f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104252:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104255:	01 c8                	add    %ecx,%eax
c0104257:	11 da                	adc    %ebx,%edx
c0104259:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010425c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010425f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104262:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104265:	89 d0                	mov    %edx,%eax
c0104267:	c1 e0 02             	shl    $0x2,%eax
c010426a:	01 d0                	add    %edx,%eax
c010426c:	c1 e0 02             	shl    $0x2,%eax
c010426f:	01 c8                	add    %ecx,%eax
c0104271:	83 c0 14             	add    $0x14,%eax
c0104274:	8b 00                	mov    (%eax),%eax
c0104276:	83 f8 01             	cmp    $0x1,%eax
c0104279:	0f 85 0a 01 00 00    	jne    c0104389 <page_init+0x3d4>
            if (begin < freemem) {
c010427f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104282:	ba 00 00 00 00       	mov    $0x0,%edx
c0104287:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010428a:	72 17                	jb     c01042a3 <page_init+0x2ee>
c010428c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010428f:	77 05                	ja     c0104296 <page_init+0x2e1>
c0104291:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104294:	76 0d                	jbe    c01042a3 <page_init+0x2ee>
                begin = freemem;
c0104296:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104299:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010429c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01042a7:	72 1d                	jb     c01042c6 <page_init+0x311>
c01042a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01042ad:	77 09                	ja     c01042b8 <page_init+0x303>
c01042af:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01042b6:	76 0e                	jbe    c01042c6 <page_init+0x311>
                end = KMEMSIZE;
c01042b8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042bf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042cc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042cf:	0f 87 b4 00 00 00    	ja     c0104389 <page_init+0x3d4>
c01042d5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042d8:	72 09                	jb     c01042e3 <page_init+0x32e>
c01042da:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042dd:	0f 83 a6 00 00 00    	jae    c0104389 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01042e3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01042ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042f0:	01 d0                	add    %edx,%eax
c01042f2:	83 e8 01             	sub    $0x1,%eax
c01042f5:	89 45 98             	mov    %eax,-0x68(%ebp)
c01042f8:	8b 45 98             	mov    -0x68(%ebp),%eax
c01042fb:	ba 00 00 00 00       	mov    $0x0,%edx
c0104300:	f7 75 9c             	divl   -0x64(%ebp)
c0104303:	89 d0                	mov    %edx,%eax
c0104305:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104308:	29 c2                	sub    %eax,%edx
c010430a:	89 d0                	mov    %edx,%eax
c010430c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104311:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104314:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104317:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010431a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010431d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104320:	ba 00 00 00 00       	mov    $0x0,%edx
c0104325:	89 c7                	mov    %eax,%edi
c0104327:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010432d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104330:	89 d0                	mov    %edx,%eax
c0104332:	83 e0 00             	and    $0x0,%eax
c0104335:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104338:	8b 45 80             	mov    -0x80(%ebp),%eax
c010433b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010433e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104341:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104344:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104347:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010434a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010434d:	77 3a                	ja     c0104389 <page_init+0x3d4>
c010434f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104352:	72 05                	jb     c0104359 <page_init+0x3a4>
c0104354:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104357:	73 30                	jae    c0104389 <page_init+0x3d4>
//		    cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
//			memmap->map[i].size, begin, end - 1, memmap->map[i].type);
//		    cprintf("the pages is %d\n", (end - begin) / PGSIZE);
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104359:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010435c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010435f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104362:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104365:	29 c8                	sub    %ecx,%eax
c0104367:	19 da                	sbb    %ebx,%edx
c0104369:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010436d:	c1 ea 0c             	shr    $0xc,%edx
c0104370:	89 c3                	mov    %eax,%ebx
c0104372:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104375:	89 04 24             	mov    %eax,(%esp)
c0104378:	e8 9a f8 ff ff       	call   c0103c17 <pa2page>
c010437d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104381:	89 04 24             	mov    %eax,(%esp)
c0104384:	e8 55 fb ff ff       	call   c0103ede <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
//    cprintf("the freemem is: %08llx\n", freemem);
    for (i = 0; i < memmap->nr_map; i ++) {
c0104389:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010438d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104390:	8b 00                	mov    (%eax),%eax
c0104392:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104395:	0f 8f 7e fe ff ff    	jg     c0104219 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010439b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043a1:	5b                   	pop    %ebx
c01043a2:	5e                   	pop    %esi
c01043a3:	5f                   	pop    %edi
c01043a4:	5d                   	pop    %ebp
c01043a5:	c3                   	ret    

c01043a6 <enable_paging>:

static void
enable_paging(void) {
c01043a6:	55                   	push   %ebp
c01043a7:	89 e5                	mov    %esp,%ebp
c01043a9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01043ac:	a1 c0 89 11 c0       	mov    0xc01189c0,%eax
c01043b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01043b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01043b7:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01043ba:	0f 20 c0             	mov    %cr0,%eax
c01043bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01043c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01043c6:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01043cd:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01043d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01043d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043da:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01043dd:	c9                   	leave  
c01043de:	c3                   	ret    

c01043df <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043df:	55                   	push   %ebp
c01043e0:	89 e5                	mov    %esp,%ebp
c01043e2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01043e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043eb:	31 d0                	xor    %edx,%eax
c01043ed:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043f2:	85 c0                	test   %eax,%eax
c01043f4:	74 24                	je     c010441a <boot_map_segment+0x3b>
c01043f6:	c7 44 24 0c e8 6d 10 	movl   $0xc0106de8,0xc(%esp)
c01043fd:	c0 
c01043fe:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104405:	c0 
c0104406:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010440d:	00 
c010440e:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104415:	e8 b7 c8 ff ff       	call   c0100cd1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010441a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104421:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104424:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104429:	89 c2                	mov    %eax,%edx
c010442b:	8b 45 10             	mov    0x10(%ebp),%eax
c010442e:	01 c2                	add    %eax,%edx
c0104430:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104433:	01 d0                	add    %edx,%eax
c0104435:	83 e8 01             	sub    $0x1,%eax
c0104438:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010443b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010443e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104443:	f7 75 f0             	divl   -0x10(%ebp)
c0104446:	89 d0                	mov    %edx,%eax
c0104448:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010444b:	29 c2                	sub    %eax,%edx
c010444d:	89 d0                	mov    %edx,%eax
c010444f:	c1 e8 0c             	shr    $0xc,%eax
c0104452:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104455:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104458:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010445b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010445e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104463:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104466:	8b 45 14             	mov    0x14(%ebp),%eax
c0104469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010446c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010446f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104474:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104477:	eb 6b                	jmp    c01044e4 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104480:	00 
c0104481:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104484:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104488:	8b 45 08             	mov    0x8(%ebp),%eax
c010448b:	89 04 24             	mov    %eax,(%esp)
c010448e:	e8 cc 01 00 00       	call   c010465f <get_pte>
c0104493:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010449a:	75 24                	jne    c01044c0 <boot_map_segment+0xe1>
c010449c:	c7 44 24 0c 14 6e 10 	movl   $0xc0106e14,0xc(%esp)
c01044a3:	c0 
c01044a4:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c01044ab:	c0 
c01044ac:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01044b3:	00 
c01044b4:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01044bb:	e8 11 c8 ff ff       	call   c0100cd1 <__panic>
        *ptep = pa | PTE_P | perm;
c01044c0:	8b 45 18             	mov    0x18(%ebp),%eax
c01044c3:	8b 55 14             	mov    0x14(%ebp),%edx
c01044c6:	09 d0                	or     %edx,%eax
c01044c8:	83 c8 01             	or     $0x1,%eax
c01044cb:	89 c2                	mov    %eax,%edx
c01044cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044d0:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01044d6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044dd:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044e8:	75 8f                	jne    c0104479 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01044ea:	c9                   	leave  
c01044eb:	c3                   	ret    

c01044ec <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044ec:	55                   	push   %ebp
c01044ed:	89 e5                	mov    %esp,%ebp
c01044ef:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044f9:	e8 22 fa ff ff       	call   c0103f20 <alloc_pages>
c01044fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104505:	75 1c                	jne    c0104523 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104507:	c7 44 24 08 21 6e 10 	movl   $0xc0106e21,0x8(%esp)
c010450e:	c0 
c010450f:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104516:	00 
c0104517:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010451e:	e8 ae c7 ff ff       	call   c0100cd1 <__panic>
    }
    return page2kva(p);
c0104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104526:	89 04 24             	mov    %eax,(%esp)
c0104529:	e8 38 f7 ff ff       	call   c0103c66 <page2kva>
}
c010452e:	c9                   	leave  
c010452f:	c3                   	ret    

c0104530 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104530:	55                   	push   %ebp
c0104531:	89 e5                	mov    %esp,%ebp
c0104533:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104536:	e8 70 f9 ff ff       	call   c0103eab <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010453b:	e8 75 fa ff ff       	call   c0103fb5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104540:	e8 f1 04 00 00       	call   c0104a36 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104545:	e8 a2 ff ff ff       	call   c01044ec <boot_alloc_page>
c010454a:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010454f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104554:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010455b:	00 
c010455c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104563:	00 
c0104564:	89 04 24             	mov    %eax,(%esp)
c0104567:	e8 33 1b 00 00       	call   c010609f <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010456c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104571:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104574:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010457b:	77 23                	ja     c01045a0 <pmm_init+0x70>
c010457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104580:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104584:	c7 44 24 08 c4 6d 10 	movl   $0xc0106dc4,0x8(%esp)
c010458b:	c0 
c010458c:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0104593:	00 
c0104594:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010459b:	e8 31 c7 ff ff       	call   c0100cd1 <__panic>
c01045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a3:	05 00 00 00 40       	add    $0x40000000,%eax
c01045a8:	a3 c0 89 11 c0       	mov    %eax,0xc01189c0

    check_pgdir();
c01045ad:	e8 a2 04 00 00       	call   c0104a54 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01045b2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045b7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01045bd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045c5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01045cc:	77 23                	ja     c01045f1 <pmm_init+0xc1>
c01045ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045d5:	c7 44 24 08 c4 6d 10 	movl   $0xc0106dc4,0x8(%esp)
c01045dc:	c0 
c01045dd:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c01045e4:	00 
c01045e5:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01045ec:	e8 e0 c6 ff ff       	call   c0100cd1 <__panic>
c01045f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045f4:	05 00 00 00 40       	add    $0x40000000,%eax
c01045f9:	83 c8 03             	or     $0x3,%eax
c01045fc:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045fe:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104603:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010460a:	00 
c010460b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104612:	00 
c0104613:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010461a:	38 
c010461b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104622:	c0 
c0104623:	89 04 24             	mov    %eax,(%esp)
c0104626:	e8 b4 fd ff ff       	call   c01043df <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010462b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104630:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104636:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010463c:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010463e:	e8 63 fd ff ff       	call   c01043a6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104643:	e8 74 f7 ff ff       	call   c0103dbc <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104648:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010464d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104653:	e8 97 0a 00 00       	call   c01050ef <check_boot_pgdir>

    print_pgdir();
c0104658:	e8 24 0f 00 00       	call   c0105581 <print_pgdir>

}
c010465d:	c9                   	leave  
c010465e:	c3                   	ret    

c010465f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010465f:	55                   	push   %ebp
c0104660:	89 e5                	mov    %esp,%ebp
c0104662:	83 ec 48             	sub    $0x48,%esp
//一级页表项
    pde_t *pdep = boot_pgdir + PDX(la);
c0104665:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010466a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010466d:	c1 ea 16             	shr    $0x16,%edx
c0104670:	c1 e2 02             	shl    $0x2,%edx
c0104673:	01 d0                	add    %edx,%eax
c0104675:	89 45 f4             	mov    %eax,-0xc(%ebp)
//    cprintf("the PDX is %d\n", PDX(la));

    pte_t *res = NULL;
c0104678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    //如果里面是空的，
    if (!(*pdep))
c010467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104682:	8b 00                	mov    (%eax),%eax
c0104684:	85 c0                	test   %eax,%eax
c0104686:	0f 85 16 01 00 00    	jne    c01047a2 <get_pte+0x143>
    {
		//如果为空的。并且需要创造一个页面
	if (create)
c010468c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104690:	0f 84 07 01 00 00    	je     c010479d <get_pte+0x13e>
	{
	    //分配一个物理页面
	    struct Page *p = alloc_page();
c0104696:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010469d:	e8 7e f8 ff ff       	call   c0103f20 <alloc_pages>
c01046a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    set_page_ref(p,1);
c01046a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046ac:	00 
c01046ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046b0:	89 04 24             	mov    %eax,(%esp)
c01046b3:	e8 4a f6 ff ff       	call   c0103d02 <set_page_ref>
	    //转换得到物理地址
	    pte_t pa = page2pa(p);
c01046b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046bb:	89 04 24             	mov    %eax,(%esp)
c01046be:	e8 3e f5 ff ff       	call   c0103c01 <page2pa>
c01046c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
//	    cprintf("the alloc page in get_pte's addr is %d\n", pa);
	    //在得到虚拟地址
	    memset(KADDR(pa), 0, PGSIZE);
c01046c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046cf:	c1 e8 0c             	shr    $0xc,%eax
c01046d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01046d5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046da:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01046dd:	72 23                	jb     c0104702 <get_pte+0xa3>
c01046df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046e6:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c01046ed:	c0 
c01046ee:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c01046f5:	00 
c01046f6:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01046fd:	e8 cf c5 ff ff       	call   c0100cd1 <__panic>
c0104702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104705:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010470a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104711:	00 
c0104712:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104719:	00 
c010471a:	89 04 24             	mov    %eax,(%esp)
c010471d:	e8 7d 19 00 00       	call   c010609f <memset>
	    //往页目录里写入第二级目录的地址，以及访问权限。
//问题1：这里面的地址是物理地址还是虚拟地址？按照前面的代码是物理地址
    	    *pdep = (pa & ~0x0FFF) | PTE_P | PTE_W | PTE_U;
c0104722:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104725:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010472a:	83 c8 07             	or     $0x7,%eax
c010472d:	89 c2                	mov    %eax,%edx
c010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104732:	89 10                	mov    %edx,(%eax)
//	    cprintf("the KADDR is %d\n", KADDR(pa));

	    //现在返回二级页表项
	    pte_t* tmp = (pte_t *)KADDR(pa);
c0104734:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104737:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010473a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010473d:	c1 e8 0c             	shr    $0xc,%eax
c0104740:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104743:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104748:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010474b:	72 23                	jb     c0104770 <get_pte+0x111>
c010474d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104750:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104754:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c010475b:	c0 
c010475c:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
c0104763:	00 
c0104764:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010476b:	e8 61 c5 ff ff       	call   c0100cd1 <__panic>
c0104770:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104773:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104778:	89 45 d4             	mov    %eax,-0x2c(%ebp)
//	    cprintf("the tmp in the get_pte is %d\n", tmp);
	    res = tmp + PTX(la);
c010477b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010477e:	c1 e8 0c             	shr    $0xc,%eax
c0104781:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104786:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010478d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104790:	01 d0                	add    %edx,%eax
c0104792:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	    cprintf("the pte addr is %d\n", res);
	    return res;			
c0104795:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104798:	e9 83 00 00 00       	jmp    c0104820 <get_pte+0x1c1>
	}
	else
	    return res;
c010479d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047a0:	eb 7e                	jmp    c0104820 <get_pte+0x1c1>
    }
    else
    {
	pte_t* tmp = (pte_t*)(boot_pgdir[PDX(la)] & ~0x0FFF);
c01047a2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047a7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047aa:	c1 ea 16             	shr    $0x16,%edx
c01047ad:	c1 e2 02             	shl    $0x2,%edx
c01047b0:	01 d0                	add    %edx,%eax
c01047b2:	8b 00                	mov    (%eax),%eax
c01047b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01047b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	res = tmp + PTX(la);
c01047bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047bf:	c1 e8 0c             	shr    $0xc,%eax
c01047c2:	25 ff 03 00 00       	and    $0x3ff,%eax
c01047c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01047ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01047d1:	01 d0                	add    %edx,%eax
c01047d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
//        cprintf("the pte addr is %d\n", res);
		
        res = (pte_t*)KADDR((uintptr_t)res);
c01047d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01047dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01047df:	c1 e8 0c             	shr    $0xc,%eax
c01047e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01047e5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01047ea:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c01047ed:	72 23                	jb     c0104812 <get_pte+0x1b3>
c01047ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01047f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047f6:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c01047fd:	c0 
c01047fe:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c0104805:	00 
c0104806:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010480d:	e8 bf c4 ff ff       	call   c0100cd1 <__panic>
c0104812:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104815:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010481a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return res;
c010481d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
}
c0104820:	c9                   	leave  
c0104821:	c3                   	ret    

c0104822 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104822:	55                   	push   %ebp
c0104823:	89 e5                	mov    %esp,%ebp
c0104825:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104828:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010482f:	00 
c0104830:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104833:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104837:	8b 45 08             	mov    0x8(%ebp),%eax
c010483a:	89 04 24             	mov    %eax,(%esp)
c010483d:	e8 1d fe ff ff       	call   c010465f <get_pte>
c0104842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104845:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104849:	74 08                	je     c0104853 <get_page+0x31>
        *ptep_store = ptep;
c010484b:	8b 45 10             	mov    0x10(%ebp),%eax
c010484e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104851:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104857:	74 1b                	je     c0104874 <get_page+0x52>
c0104859:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485c:	8b 00                	mov    (%eax),%eax
c010485e:	83 e0 01             	and    $0x1,%eax
c0104861:	85 c0                	test   %eax,%eax
c0104863:	74 0f                	je     c0104874 <get_page+0x52>
        return pa2page(*ptep);
c0104865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104868:	8b 00                	mov    (%eax),%eax
c010486a:	89 04 24             	mov    %eax,(%esp)
c010486d:	e8 a5 f3 ff ff       	call   c0103c17 <pa2page>
c0104872:	eb 05                	jmp    c0104879 <get_page+0x57>
    }
    return NULL;
c0104874:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104879:	c9                   	leave  
c010487a:	c3                   	ret    

c010487b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010487b:	55                   	push   %ebp
c010487c:	89 e5                	mov    %esp,%ebp
c010487e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
c0104881:	8b 45 10             	mov    0x10(%ebp),%eax
c0104884:	8b 00                	mov    (%eax),%eax
c0104886:	83 e0 01             	and    $0x1,%eax
c0104889:	85 c0                	test   %eax,%eax
c010488b:	74 4d                	je     c01048da <page_remove_pte+0x5f>
	{
		struct Page* p = pte2page(*ptep);
c010488d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104890:	8b 00                	mov    (%eax),%eax
c0104892:	89 04 24             	mov    %eax,(%esp)
c0104895:	e8 20 f4 ff ff       	call   c0103cba <pte2page>
c010489a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (page_ref_dec(p) == 0)
c010489d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a0:	89 04 24             	mov    %eax,(%esp)
c01048a3:	e8 7e f4 ff ff       	call   c0103d26 <page_ref_dec>
c01048a8:	85 c0                	test   %eax,%eax
c01048aa:	75 13                	jne    c01048bf <page_remove_pte+0x44>
			free_page(p);
c01048ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01048b3:	00 
c01048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b7:	89 04 24             	mov    %eax,(%esp)
c01048ba:	e8 99 f6 ff ff       	call   c0103f58 <free_pages>
		//清空
		*ptep = 0;
c01048bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01048c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		tlb_invalidate(pgdir, la);
c01048c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d2:	89 04 24             	mov    %eax,(%esp)
c01048d5:	e8 ff 00 00 00       	call   c01049d9 <tlb_invalidate>
		
	}
}
c01048da:	c9                   	leave  
c01048db:	c3                   	ret    

c01048dc <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01048dc:	55                   	push   %ebp
c01048dd:	89 e5                	mov    %esp,%ebp
c01048df:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01048e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048e9:	00 
c01048ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f4:	89 04 24             	mov    %eax,(%esp)
c01048f7:	e8 63 fd ff ff       	call   c010465f <get_pte>
c01048fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01048ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104903:	74 19                	je     c010491e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104905:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104908:	89 44 24 08          	mov    %eax,0x8(%esp)
c010490c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010490f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104913:	8b 45 08             	mov    0x8(%ebp),%eax
c0104916:	89 04 24             	mov    %eax,(%esp)
c0104919:	e8 5d ff ff ff       	call   c010487b <page_remove_pte>
    }
}
c010491e:	c9                   	leave  
c010491f:	c3                   	ret    

c0104920 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104920:	55                   	push   %ebp
c0104921:	89 e5                	mov    %esp,%ebp
c0104923:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104926:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010492d:	00 
c010492e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104931:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104935:	8b 45 08             	mov    0x8(%ebp),%eax
c0104938:	89 04 24             	mov    %eax,(%esp)
c010493b:	e8 1f fd ff ff       	call   c010465f <get_pte>
c0104940:	89 45 f4             	mov    %eax,-0xc(%ebp)
//    cprintf("the ptep in insert is %d\n", ptep);
    if (ptep == NULL) {
c0104943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104947:	75 0a                	jne    c0104953 <page_insert+0x33>
//	cprintf("what the fuck\n");
        return -E_NO_MEM;
c0104949:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010494e:	e9 84 00 00 00       	jmp    c01049d7 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104953:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104956:	89 04 24             	mov    %eax,(%esp)
c0104959:	e8 b1 f3 ff ff       	call   c0103d0f <page_ref_inc>
    if (*ptep & PTE_P) {
c010495e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104961:	8b 00                	mov    (%eax),%eax
c0104963:	83 e0 01             	and    $0x1,%eax
c0104966:	85 c0                	test   %eax,%eax
c0104968:	74 3e                	je     c01049a8 <page_insert+0x88>
//	cprintf("NO Way\n");
        struct Page *p = pte2page(*ptep);
c010496a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010496d:	8b 00                	mov    (%eax),%eax
c010496f:	89 04 24             	mov    %eax,(%esp)
c0104972:	e8 43 f3 ff ff       	call   c0103cba <pte2page>
c0104977:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010497a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010497d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104980:	75 0d                	jne    c010498f <page_insert+0x6f>
            page_ref_dec(page);
c0104982:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104985:	89 04 24             	mov    %eax,(%esp)
c0104988:	e8 99 f3 ff ff       	call   c0103d26 <page_ref_dec>
c010498d:	eb 19                	jmp    c01049a8 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010498f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104992:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104996:	8b 45 10             	mov    0x10(%ebp),%eax
c0104999:	89 44 24 04          	mov    %eax,0x4(%esp)
c010499d:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a0:	89 04 24             	mov    %eax,(%esp)
c01049a3:	e8 d3 fe ff ff       	call   c010487b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01049a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049ab:	89 04 24             	mov    %eax,(%esp)
c01049ae:	e8 4e f2 ff ff       	call   c0103c01 <page2pa>
c01049b3:	0b 45 14             	or     0x14(%ebp),%eax
c01049b6:	83 c8 01             	or     $0x1,%eax
c01049b9:	89 c2                	mov    %eax,%edx
c01049bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049be:	89 10                	mov    %edx,(%eax)
//    cprintf("*ptep is %d\n", *ptep);
    tlb_invalidate(pgdir, la);
c01049c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01049c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01049ca:	89 04 24             	mov    %eax,(%esp)
c01049cd:	e8 07 00 00 00       	call   c01049d9 <tlb_invalidate>
    return 0;
c01049d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01049d7:	c9                   	leave  
c01049d8:	c3                   	ret    

c01049d9 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01049d9:	55                   	push   %ebp
c01049da:	89 e5                	mov    %esp,%ebp
c01049dc:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01049df:	0f 20 d8             	mov    %cr3,%eax
c01049e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01049e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01049e8:	89 c2                	mov    %eax,%edx
c01049ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01049ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049f0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01049f7:	77 23                	ja     c0104a1c <tlb_invalidate+0x43>
c01049f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a00:	c7 44 24 08 c4 6d 10 	movl   $0xc0106dc4,0x8(%esp)
c0104a07:	c0 
c0104a08:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104a0f:	00 
c0104a10:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104a17:	e8 b5 c2 ff ff       	call   c0100cd1 <__panic>
c0104a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a1f:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a24:	39 c2                	cmp    %eax,%edx
c0104a26:	75 0c                	jne    c0104a34 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104a28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a31:	0f 01 38             	invlpg (%eax)
    }
}
c0104a34:	c9                   	leave  
c0104a35:	c3                   	ret    

c0104a36 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104a36:	55                   	push   %ebp
c0104a37:	89 e5                	mov    %esp,%ebp
c0104a39:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104a3c:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104a41:	8b 40 18             	mov    0x18(%eax),%eax
c0104a44:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104a46:	c7 04 24 3c 6e 10 c0 	movl   $0xc0106e3c,(%esp)
c0104a4d:	e8 f5 b8 ff ff       	call   c0100347 <cprintf>
}
c0104a52:	c9                   	leave  
c0104a53:	c3                   	ret    

c0104a54 <check_pgdir>:

static void
check_pgdir(void) {
c0104a54:	55                   	push   %ebp
c0104a55:	89 e5                	mov    %esp,%ebp
c0104a57:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104a5a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104a5f:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104a64:	76 24                	jbe    c0104a8a <check_pgdir+0x36>
c0104a66:	c7 44 24 0c 5b 6e 10 	movl   $0xc0106e5b,0xc(%esp)
c0104a6d:	c0 
c0104a6e:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104a75:	c0 
c0104a76:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104a7d:	00 
c0104a7e:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104a85:	e8 47 c2 ff ff       	call   c0100cd1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104a8a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a8f:	85 c0                	test   %eax,%eax
c0104a91:	74 0e                	je     c0104aa1 <check_pgdir+0x4d>
c0104a93:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a98:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a9d:	85 c0                	test   %eax,%eax
c0104a9f:	74 24                	je     c0104ac5 <check_pgdir+0x71>
c0104aa1:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c0104aa8:	c0 
c0104aa9:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104ab0:	c0 
c0104ab1:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104ab8:	00 
c0104ab9:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104ac0:	e8 0c c2 ff ff       	call   c0100cd1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104ac5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ad1:	00 
c0104ad2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ad9:	00 
c0104ada:	89 04 24             	mov    %eax,(%esp)
c0104add:	e8 40 fd ff ff       	call   c0104822 <get_page>
c0104ae2:	85 c0                	test   %eax,%eax
c0104ae4:	74 24                	je     c0104b0a <check_pgdir+0xb6>
c0104ae6:	c7 44 24 0c b0 6e 10 	movl   $0xc0106eb0,0xc(%esp)
c0104aed:	c0 
c0104aee:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104af5:	c0 
c0104af6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104afd:	00 
c0104afe:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104b05:	e8 c7 c1 ff ff       	call   c0100cd1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b11:	e8 0a f4 ff ff       	call   c0103f20 <alloc_pages>
c0104b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
//    cprintf("the p1 is %d\n", page2pa(p1));
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104b19:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b1e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b25:	00 
c0104b26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b2d:	00 
c0104b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b31:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b35:	89 04 24             	mov    %eax,(%esp)
c0104b38:	e8 e3 fd ff ff       	call   c0104920 <page_insert>
c0104b3d:	85 c0                	test   %eax,%eax
c0104b3f:	74 24                	je     c0104b65 <check_pgdir+0x111>
c0104b41:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104b48:	c0 
c0104b49:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104b50:	c0 
c0104b51:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104b58:	00 
c0104b59:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104b60:	e8 6c c1 ff ff       	call   c0100cd1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104b65:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b71:	00 
c0104b72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b79:	00 
c0104b7a:	89 04 24             	mov    %eax,(%esp)
c0104b7d:	e8 dd fa ff ff       	call   c010465f <get_pte>
c0104b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b89:	75 24                	jne    c0104baf <check_pgdir+0x15b>
c0104b8b:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c0104b92:	c0 
c0104b93:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104b9a:	c0 
c0104b9b:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ba2:	00 
c0104ba3:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104baa:	e8 22 c1 ff ff       	call   c0100cd1 <__panic>
//    cprintf("the *ptep is %d in check\n", *ptep);
    assert(pa2page(*ptep) == p1);
c0104baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb2:	8b 00                	mov    (%eax),%eax
c0104bb4:	89 04 24             	mov    %eax,(%esp)
c0104bb7:	e8 5b f0 ff ff       	call   c0103c17 <pa2page>
c0104bbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bbf:	74 24                	je     c0104be5 <check_pgdir+0x191>
c0104bc1:	c7 44 24 0c 31 6f 10 	movl   $0xc0106f31,0xc(%esp)
c0104bc8:	c0 
c0104bc9:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104bd0:	c0 
c0104bd1:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104bd8:	00 
c0104bd9:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104be0:	e8 ec c0 ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p1) == 1);
c0104be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be8:	89 04 24             	mov    %eax,(%esp)
c0104beb:	e8 08 f1 ff ff       	call   c0103cf8 <page_ref>
c0104bf0:	83 f8 01             	cmp    $0x1,%eax
c0104bf3:	74 24                	je     c0104c19 <check_pgdir+0x1c5>
c0104bf5:	c7 44 24 0c 46 6f 10 	movl   $0xc0106f46,0xc(%esp)
c0104bfc:	c0 
c0104bfd:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104c04:	c0 
c0104c05:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104c0c:	00 
c0104c0d:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104c14:	e8 b8 c0 ff ff       	call   c0100cd1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104c19:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c1e:	8b 00                	mov    (%eax),%eax
c0104c20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c2b:	c1 e8 0c             	shr    $0xc,%eax
c0104c2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c31:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104c36:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104c39:	72 23                	jb     c0104c5e <check_pgdir+0x20a>
c0104c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c42:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0104c49:	c0 
c0104c4a:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104c51:	00 
c0104c52:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104c59:	e8 73 c0 ff ff       	call   c0100cd1 <__panic>
c0104c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c61:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104c66:	83 c0 04             	add    $0x4,%eax
c0104c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104c6c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c71:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c78:	00 
c0104c79:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c80:	00 
c0104c81:	89 04 24             	mov    %eax,(%esp)
c0104c84:	e8 d6 f9 ff ff       	call   c010465f <get_pte>
c0104c89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104c8c:	74 24                	je     c0104cb2 <check_pgdir+0x25e>
c0104c8e:	c7 44 24 0c 58 6f 10 	movl   $0xc0106f58,0xc(%esp)
c0104c95:	c0 
c0104c96:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104c9d:	c0 
c0104c9e:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104ca5:	00 
c0104ca6:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104cad:	e8 1f c0 ff ff       	call   c0100cd1 <__panic>

    p2 = alloc_page();
c0104cb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cb9:	e8 62 f2 ff ff       	call   c0103f20 <alloc_pages>
c0104cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104cc1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cc6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104ccd:	00 
c0104cce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104cd5:	00 
c0104cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104cd9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cdd:	89 04 24             	mov    %eax,(%esp)
c0104ce0:	e8 3b fc ff ff       	call   c0104920 <page_insert>
c0104ce5:	85 c0                	test   %eax,%eax
c0104ce7:	74 24                	je     c0104d0d <check_pgdir+0x2b9>
c0104ce9:	c7 44 24 0c 80 6f 10 	movl   $0xc0106f80,0xc(%esp)
c0104cf0:	c0 
c0104cf1:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104cf8:	c0 
c0104cf9:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104d00:	00 
c0104d01:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104d08:	e8 c4 bf ff ff       	call   c0100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104d0d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d19:	00 
c0104d1a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d21:	00 
c0104d22:	89 04 24             	mov    %eax,(%esp)
c0104d25:	e8 35 f9 ff ff       	call   c010465f <get_pte>
c0104d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d31:	75 24                	jne    c0104d57 <check_pgdir+0x303>
c0104d33:	c7 44 24 0c b8 6f 10 	movl   $0xc0106fb8,0xc(%esp)
c0104d3a:	c0 
c0104d3b:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104d42:	c0 
c0104d43:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104d4a:	00 
c0104d4b:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104d52:	e8 7a bf ff ff       	call   c0100cd1 <__panic>
    assert(*ptep & PTE_U);
c0104d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d5a:	8b 00                	mov    (%eax),%eax
c0104d5c:	83 e0 04             	and    $0x4,%eax
c0104d5f:	85 c0                	test   %eax,%eax
c0104d61:	75 24                	jne    c0104d87 <check_pgdir+0x333>
c0104d63:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c0104d6a:	c0 
c0104d6b:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104d72:	c0 
c0104d73:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104d7a:	00 
c0104d7b:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104d82:	e8 4a bf ff ff       	call   c0100cd1 <__panic>
    assert(*ptep & PTE_W);
c0104d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d8a:	8b 00                	mov    (%eax),%eax
c0104d8c:	83 e0 02             	and    $0x2,%eax
c0104d8f:	85 c0                	test   %eax,%eax
c0104d91:	75 24                	jne    c0104db7 <check_pgdir+0x363>
c0104d93:	c7 44 24 0c f6 6f 10 	movl   $0xc0106ff6,0xc(%esp)
c0104d9a:	c0 
c0104d9b:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104da2:	c0 
c0104da3:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104daa:	00 
c0104dab:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104db2:	e8 1a bf ff ff       	call   c0100cd1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104db7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dbc:	8b 00                	mov    (%eax),%eax
c0104dbe:	83 e0 04             	and    $0x4,%eax
c0104dc1:	85 c0                	test   %eax,%eax
c0104dc3:	75 24                	jne    c0104de9 <check_pgdir+0x395>
c0104dc5:	c7 44 24 0c 04 70 10 	movl   $0xc0107004,0xc(%esp)
c0104dcc:	c0 
c0104dcd:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104dd4:	c0 
c0104dd5:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104ddc:	00 
c0104ddd:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104de4:	e8 e8 be ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 1);
c0104de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dec:	89 04 24             	mov    %eax,(%esp)
c0104def:	e8 04 ef ff ff       	call   c0103cf8 <page_ref>
c0104df4:	83 f8 01             	cmp    $0x1,%eax
c0104df7:	74 24                	je     c0104e1d <check_pgdir+0x3c9>
c0104df9:	c7 44 24 0c 1a 70 10 	movl   $0xc010701a,0xc(%esp)
c0104e00:	c0 
c0104e01:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104e08:	c0 
c0104e09:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104e10:	00 
c0104e11:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104e18:	e8 b4 be ff ff       	call   c0100cd1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104e1d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e22:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e29:	00 
c0104e2a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e31:	00 
c0104e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e35:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e39:	89 04 24             	mov    %eax,(%esp)
c0104e3c:	e8 df fa ff ff       	call   c0104920 <page_insert>
c0104e41:	85 c0                	test   %eax,%eax
c0104e43:	74 24                	je     c0104e69 <check_pgdir+0x415>
c0104e45:	c7 44 24 0c 2c 70 10 	movl   $0xc010702c,0xc(%esp)
c0104e4c:	c0 
c0104e4d:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104e54:	c0 
c0104e55:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104e5c:	00 
c0104e5d:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104e64:	e8 68 be ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p1) == 2);
c0104e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e6c:	89 04 24             	mov    %eax,(%esp)
c0104e6f:	e8 84 ee ff ff       	call   c0103cf8 <page_ref>
c0104e74:	83 f8 02             	cmp    $0x2,%eax
c0104e77:	74 24                	je     c0104e9d <check_pgdir+0x449>
c0104e79:	c7 44 24 0c 58 70 10 	movl   $0xc0107058,0xc(%esp)
c0104e80:	c0 
c0104e81:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104e88:	c0 
c0104e89:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104e90:	00 
c0104e91:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104e98:	e8 34 be ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 0);
c0104e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ea0:	89 04 24             	mov    %eax,(%esp)
c0104ea3:	e8 50 ee ff ff       	call   c0103cf8 <page_ref>
c0104ea8:	85 c0                	test   %eax,%eax
c0104eaa:	74 24                	je     c0104ed0 <check_pgdir+0x47c>
c0104eac:	c7 44 24 0c 6a 70 10 	movl   $0xc010706a,0xc(%esp)
c0104eb3:	c0 
c0104eb4:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104ebb:	c0 
c0104ebc:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104ec3:	00 
c0104ec4:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104ecb:	e8 01 be ff ff       	call   c0100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ed0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ed5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104edc:	00 
c0104edd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ee4:	00 
c0104ee5:	89 04 24             	mov    %eax,(%esp)
c0104ee8:	e8 72 f7 ff ff       	call   c010465f <get_pte>
c0104eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ef4:	75 24                	jne    c0104f1a <check_pgdir+0x4c6>
c0104ef6:	c7 44 24 0c b8 6f 10 	movl   $0xc0106fb8,0xc(%esp)
c0104efd:	c0 
c0104efe:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104f05:	c0 
c0104f06:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104f0d:	00 
c0104f0e:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104f15:	e8 b7 bd ff ff       	call   c0100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
c0104f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1d:	8b 00                	mov    (%eax),%eax
c0104f1f:	89 04 24             	mov    %eax,(%esp)
c0104f22:	e8 f0 ec ff ff       	call   c0103c17 <pa2page>
c0104f27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f2a:	74 24                	je     c0104f50 <check_pgdir+0x4fc>
c0104f2c:	c7 44 24 0c 31 6f 10 	movl   $0xc0106f31,0xc(%esp)
c0104f33:	c0 
c0104f34:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104f3b:	c0 
c0104f3c:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104f43:	00 
c0104f44:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104f4b:	e8 81 bd ff ff       	call   c0100cd1 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f53:	8b 00                	mov    (%eax),%eax
c0104f55:	83 e0 04             	and    $0x4,%eax
c0104f58:	85 c0                	test   %eax,%eax
c0104f5a:	74 24                	je     c0104f80 <check_pgdir+0x52c>
c0104f5c:	c7 44 24 0c 7c 70 10 	movl   $0xc010707c,0xc(%esp)
c0104f63:	c0 
c0104f64:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104f6b:	c0 
c0104f6c:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104f73:	00 
c0104f74:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104f7b:	e8 51 bd ff ff       	call   c0100cd1 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104f80:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f8c:	00 
c0104f8d:	89 04 24             	mov    %eax,(%esp)
c0104f90:	e8 47 f9 ff ff       	call   c01048dc <page_remove>
    assert(page_ref(p1) == 1);
c0104f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f98:	89 04 24             	mov    %eax,(%esp)
c0104f9b:	e8 58 ed ff ff       	call   c0103cf8 <page_ref>
c0104fa0:	83 f8 01             	cmp    $0x1,%eax
c0104fa3:	74 24                	je     c0104fc9 <check_pgdir+0x575>
c0104fa5:	c7 44 24 0c 46 6f 10 	movl   $0xc0106f46,0xc(%esp)
c0104fac:	c0 
c0104fad:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104fb4:	c0 
c0104fb5:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104fbc:	00 
c0104fbd:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104fc4:	e8 08 bd ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 0);
c0104fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fcc:	89 04 24             	mov    %eax,(%esp)
c0104fcf:	e8 24 ed ff ff       	call   c0103cf8 <page_ref>
c0104fd4:	85 c0                	test   %eax,%eax
c0104fd6:	74 24                	je     c0104ffc <check_pgdir+0x5a8>
c0104fd8:	c7 44 24 0c 6a 70 10 	movl   $0xc010706a,0xc(%esp)
c0104fdf:	c0 
c0104fe0:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0104fe7:	c0 
c0104fe8:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104fef:	00 
c0104ff0:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0104ff7:	e8 d5 bc ff ff       	call   c0100cd1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104ffc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105001:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105008:	00 
c0105009:	89 04 24             	mov    %eax,(%esp)
c010500c:	e8 cb f8 ff ff       	call   c01048dc <page_remove>
    assert(page_ref(p1) == 0);
c0105011:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105014:	89 04 24             	mov    %eax,(%esp)
c0105017:	e8 dc ec ff ff       	call   c0103cf8 <page_ref>
c010501c:	85 c0                	test   %eax,%eax
c010501e:	74 24                	je     c0105044 <check_pgdir+0x5f0>
c0105020:	c7 44 24 0c 91 70 10 	movl   $0xc0107091,0xc(%esp)
c0105027:	c0 
c0105028:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c010502f:	c0 
c0105030:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105037:	00 
c0105038:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010503f:	e8 8d bc ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p2) == 0);
c0105044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105047:	89 04 24             	mov    %eax,(%esp)
c010504a:	e8 a9 ec ff ff       	call   c0103cf8 <page_ref>
c010504f:	85 c0                	test   %eax,%eax
c0105051:	74 24                	je     c0105077 <check_pgdir+0x623>
c0105053:	c7 44 24 0c 6a 70 10 	movl   $0xc010706a,0xc(%esp)
c010505a:	c0 
c010505b:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0105062:	c0 
c0105063:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c010506a:	00 
c010506b:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0105072:	e8 5a bc ff ff       	call   c0100cd1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105077:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010507c:	8b 00                	mov    (%eax),%eax
c010507e:	89 04 24             	mov    %eax,(%esp)
c0105081:	e8 91 eb ff ff       	call   c0103c17 <pa2page>
c0105086:	89 04 24             	mov    %eax,(%esp)
c0105089:	e8 6a ec ff ff       	call   c0103cf8 <page_ref>
c010508e:	83 f8 01             	cmp    $0x1,%eax
c0105091:	74 24                	je     c01050b7 <check_pgdir+0x663>
c0105093:	c7 44 24 0c a4 70 10 	movl   $0xc01070a4,0xc(%esp)
c010509a:	c0 
c010509b:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c01050a2:	c0 
c01050a3:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c01050aa:	00 
c01050ab:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01050b2:	e8 1a bc ff ff       	call   c0100cd1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c01050b7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050bc:	8b 00                	mov    (%eax),%eax
c01050be:	89 04 24             	mov    %eax,(%esp)
c01050c1:	e8 51 eb ff ff       	call   c0103c17 <pa2page>
c01050c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050cd:	00 
c01050ce:	89 04 24             	mov    %eax,(%esp)
c01050d1:	e8 82 ee ff ff       	call   c0103f58 <free_pages>
    boot_pgdir[0] = 0;
c01050d6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01050e1:	c7 04 24 ca 70 10 c0 	movl   $0xc01070ca,(%esp)
c01050e8:	e8 5a b2 ff ff       	call   c0100347 <cprintf>
}
c01050ed:	c9                   	leave  
c01050ee:	c3                   	ret    

c01050ef <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01050ef:	55                   	push   %ebp
c01050f0:	89 e5                	mov    %esp,%ebp
c01050f2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01050f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01050fc:	e9 ca 00 00 00       	jmp    c01051cb <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105101:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105104:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105107:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010510a:	c1 e8 0c             	shr    $0xc,%eax
c010510d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105110:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0105115:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105118:	72 23                	jb     c010513d <check_boot_pgdir+0x4e>
c010511a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010511d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105121:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0105128:	c0 
c0105129:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105130:	00 
c0105131:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0105138:	e8 94 bb ff ff       	call   c0100cd1 <__panic>
c010513d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105140:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105145:	89 c2                	mov    %eax,%edx
c0105147:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010514c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105153:	00 
c0105154:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105158:	89 04 24             	mov    %eax,(%esp)
c010515b:	e8 ff f4 ff ff       	call   c010465f <get_pte>
c0105160:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105163:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105167:	75 24                	jne    c010518d <check_boot_pgdir+0x9e>
c0105169:	c7 44 24 0c e4 70 10 	movl   $0xc01070e4,0xc(%esp)
c0105170:	c0 
c0105171:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0105178:	c0 
c0105179:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105180:	00 
c0105181:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0105188:	e8 44 bb ff ff       	call   c0100cd1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010518d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105190:	8b 00                	mov    (%eax),%eax
c0105192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105197:	89 c2                	mov    %eax,%edx
c0105199:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010519c:	39 c2                	cmp    %eax,%edx
c010519e:	74 24                	je     c01051c4 <check_boot_pgdir+0xd5>
c01051a0:	c7 44 24 0c 21 71 10 	movl   $0xc0107121,0xc(%esp)
c01051a7:	c0 
c01051a8:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c01051af:	c0 
c01051b0:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c01051b7:	00 
c01051b8:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01051bf:	e8 0d bb ff ff       	call   c0100cd1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01051c4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01051cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051ce:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01051d3:	39 c2                	cmp    %eax,%edx
c01051d5:	0f 82 26 ff ff ff    	jb     c0105101 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01051db:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051e0:	05 ac 0f 00 00       	add    $0xfac,%eax
c01051e5:	8b 00                	mov    (%eax),%eax
c01051e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01051ec:	89 c2                	mov    %eax,%edx
c01051ee:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01051f6:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01051fd:	77 23                	ja     c0105222 <check_boot_pgdir+0x133>
c01051ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105202:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105206:	c7 44 24 08 c4 6d 10 	movl   $0xc0106dc4,0x8(%esp)
c010520d:	c0 
c010520e:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105215:	00 
c0105216:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010521d:	e8 af ba ff ff       	call   c0100cd1 <__panic>
c0105222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105225:	05 00 00 00 40       	add    $0x40000000,%eax
c010522a:	39 c2                	cmp    %eax,%edx
c010522c:	74 24                	je     c0105252 <check_boot_pgdir+0x163>
c010522e:	c7 44 24 0c 38 71 10 	movl   $0xc0107138,0xc(%esp)
c0105235:	c0 
c0105236:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c010523d:	c0 
c010523e:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105245:	00 
c0105246:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010524d:	e8 7f ba ff ff       	call   c0100cd1 <__panic>

    assert(boot_pgdir[0] == 0);
c0105252:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105257:	8b 00                	mov    (%eax),%eax
c0105259:	85 c0                	test   %eax,%eax
c010525b:	74 24                	je     c0105281 <check_boot_pgdir+0x192>
c010525d:	c7 44 24 0c 6c 71 10 	movl   $0xc010716c,0xc(%esp)
c0105264:	c0 
c0105265:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c010526c:	c0 
c010526d:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105274:	00 
c0105275:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010527c:	e8 50 ba ff ff       	call   c0100cd1 <__panic>

    struct Page *p;
    p = alloc_page();
c0105281:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105288:	e8 93 ec ff ff       	call   c0103f20 <alloc_pages>
c010528d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105290:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105295:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010529c:	00 
c010529d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01052a4:	00 
c01052a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052ac:	89 04 24             	mov    %eax,(%esp)
c01052af:	e8 6c f6 ff ff       	call   c0104920 <page_insert>
c01052b4:	85 c0                	test   %eax,%eax
c01052b6:	74 24                	je     c01052dc <check_boot_pgdir+0x1ed>
c01052b8:	c7 44 24 0c 80 71 10 	movl   $0xc0107180,0xc(%esp)
c01052bf:	c0 
c01052c0:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c01052c7:	c0 
c01052c8:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c01052cf:	00 
c01052d0:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01052d7:	e8 f5 b9 ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p) == 1);
c01052dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052df:	89 04 24             	mov    %eax,(%esp)
c01052e2:	e8 11 ea ff ff       	call   c0103cf8 <page_ref>
c01052e7:	83 f8 01             	cmp    $0x1,%eax
c01052ea:	74 24                	je     c0105310 <check_boot_pgdir+0x221>
c01052ec:	c7 44 24 0c ae 71 10 	movl   $0xc01071ae,0xc(%esp)
c01052f3:	c0 
c01052f4:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c01052fb:	c0 
c01052fc:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105303:	00 
c0105304:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010530b:	e8 c1 b9 ff ff       	call   c0100cd1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105310:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105315:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010531c:	00 
c010531d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105324:	00 
c0105325:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105328:	89 54 24 04          	mov    %edx,0x4(%esp)
c010532c:	89 04 24             	mov    %eax,(%esp)
c010532f:	e8 ec f5 ff ff       	call   c0104920 <page_insert>
c0105334:	85 c0                	test   %eax,%eax
c0105336:	74 24                	je     c010535c <check_boot_pgdir+0x26d>
c0105338:	c7 44 24 0c c0 71 10 	movl   $0xc01071c0,0xc(%esp)
c010533f:	c0 
c0105340:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0105347:	c0 
c0105348:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c010534f:	00 
c0105350:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0105357:	e8 75 b9 ff ff       	call   c0100cd1 <__panic>
    assert(page_ref(p) == 2);
c010535c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010535f:	89 04 24             	mov    %eax,(%esp)
c0105362:	e8 91 e9 ff ff       	call   c0103cf8 <page_ref>
c0105367:	83 f8 02             	cmp    $0x2,%eax
c010536a:	74 24                	je     c0105390 <check_boot_pgdir+0x2a1>
c010536c:	c7 44 24 0c f7 71 10 	movl   $0xc01071f7,0xc(%esp)
c0105373:	c0 
c0105374:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c010537b:	c0 
c010537c:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105383:	00 
c0105384:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010538b:	e8 41 b9 ff ff       	call   c0100cd1 <__panic>

    const char *str = "ucore: Hello world!!";
c0105390:	c7 45 dc 08 72 10 c0 	movl   $0xc0107208,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105397:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010539a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010539e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01053a5:	e8 1e 0a 00 00       	call   c0105dc8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01053aa:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01053b1:	00 
c01053b2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01053b9:	e8 83 0a 00 00       	call   c0105e41 <strcmp>
c01053be:	85 c0                	test   %eax,%eax
c01053c0:	74 24                	je     c01053e6 <check_boot_pgdir+0x2f7>
c01053c2:	c7 44 24 0c 20 72 10 	movl   $0xc0107220,0xc(%esp)
c01053c9:	c0 
c01053ca:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c01053d1:	c0 
c01053d2:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c01053d9:	00 
c01053da:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c01053e1:	e8 eb b8 ff ff       	call   c0100cd1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01053e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053e9:	89 04 24             	mov    %eax,(%esp)
c01053ec:	e8 75 e8 ff ff       	call   c0103c66 <page2kva>
c01053f1:	05 00 01 00 00       	add    $0x100,%eax
c01053f6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01053f9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105400:	e8 6b 09 00 00       	call   c0105d70 <strlen>
c0105405:	85 c0                	test   %eax,%eax
c0105407:	74 24                	je     c010542d <check_boot_pgdir+0x33e>
c0105409:	c7 44 24 0c 58 72 10 	movl   $0xc0107258,0xc(%esp)
c0105410:	c0 
c0105411:	c7 44 24 08 ff 6d 10 	movl   $0xc0106dff,0x8(%esp)
c0105418:	c0 
c0105419:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0105420:	00 
c0105421:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c0105428:	e8 a4 b8 ff ff       	call   c0100cd1 <__panic>

    free_page(p);
c010542d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105434:	00 
c0105435:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105438:	89 04 24             	mov    %eax,(%esp)
c010543b:	e8 18 eb ff ff       	call   c0103f58 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105440:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105445:	8b 00                	mov    (%eax),%eax
c0105447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010544c:	89 04 24             	mov    %eax,(%esp)
c010544f:	e8 c3 e7 ff ff       	call   c0103c17 <pa2page>
c0105454:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010545b:	00 
c010545c:	89 04 24             	mov    %eax,(%esp)
c010545f:	e8 f4 ea ff ff       	call   c0103f58 <free_pages>
    boot_pgdir[0] = 0;
c0105464:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010546f:	c7 04 24 7c 72 10 c0 	movl   $0xc010727c,(%esp)
c0105476:	e8 cc ae ff ff       	call   c0100347 <cprintf>
}
c010547b:	c9                   	leave  
c010547c:	c3                   	ret    

c010547d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010547d:	55                   	push   %ebp
c010547e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105480:	8b 45 08             	mov    0x8(%ebp),%eax
c0105483:	83 e0 04             	and    $0x4,%eax
c0105486:	85 c0                	test   %eax,%eax
c0105488:	74 07                	je     c0105491 <perm2str+0x14>
c010548a:	b8 75 00 00 00       	mov    $0x75,%eax
c010548f:	eb 05                	jmp    c0105496 <perm2str+0x19>
c0105491:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105496:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c010549b:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01054a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a5:	83 e0 02             	and    $0x2,%eax
c01054a8:	85 c0                	test   %eax,%eax
c01054aa:	74 07                	je     c01054b3 <perm2str+0x36>
c01054ac:	b8 77 00 00 00       	mov    $0x77,%eax
c01054b1:	eb 05                	jmp    c01054b8 <perm2str+0x3b>
c01054b3:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01054b8:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01054bd:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01054c4:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01054c9:	5d                   	pop    %ebp
c01054ca:	c3                   	ret    

c01054cb <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01054cb:	55                   	push   %ebp
c01054cc:	89 e5                	mov    %esp,%ebp
c01054ce:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01054d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01054d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054d7:	72 0a                	jb     c01054e3 <get_pgtable_items+0x18>
        return 0;
c01054d9:	b8 00 00 00 00       	mov    $0x0,%eax
c01054de:	e9 9c 00 00 00       	jmp    c010557f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01054e3:	eb 04                	jmp    c01054e9 <get_pgtable_items+0x1e>
        start ++;
c01054e5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01054e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01054ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054ef:	73 18                	jae    c0105509 <get_pgtable_items+0x3e>
c01054f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01054f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054fb:	8b 45 14             	mov    0x14(%ebp),%eax
c01054fe:	01 d0                	add    %edx,%eax
c0105500:	8b 00                	mov    (%eax),%eax
c0105502:	83 e0 01             	and    $0x1,%eax
c0105505:	85 c0                	test   %eax,%eax
c0105507:	74 dc                	je     c01054e5 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105509:	8b 45 10             	mov    0x10(%ebp),%eax
c010550c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010550f:	73 69                	jae    c010557a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105511:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105515:	74 08                	je     c010551f <get_pgtable_items+0x54>
            *left_store = start;
c0105517:	8b 45 18             	mov    0x18(%ebp),%eax
c010551a:	8b 55 10             	mov    0x10(%ebp),%edx
c010551d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010551f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105522:	8d 50 01             	lea    0x1(%eax),%edx
c0105525:	89 55 10             	mov    %edx,0x10(%ebp)
c0105528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010552f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105532:	01 d0                	add    %edx,%eax
c0105534:	8b 00                	mov    (%eax),%eax
c0105536:	83 e0 07             	and    $0x7,%eax
c0105539:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010553c:	eb 04                	jmp    c0105542 <get_pgtable_items+0x77>
            start ++;
c010553e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105542:	8b 45 10             	mov    0x10(%ebp),%eax
c0105545:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105548:	73 1d                	jae    c0105567 <get_pgtable_items+0x9c>
c010554a:	8b 45 10             	mov    0x10(%ebp),%eax
c010554d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105554:	8b 45 14             	mov    0x14(%ebp),%eax
c0105557:	01 d0                	add    %edx,%eax
c0105559:	8b 00                	mov    (%eax),%eax
c010555b:	83 e0 07             	and    $0x7,%eax
c010555e:	89 c2                	mov    %eax,%edx
c0105560:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105563:	39 c2                	cmp    %eax,%edx
c0105565:	74 d7                	je     c010553e <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105567:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010556b:	74 08                	je     c0105575 <get_pgtable_items+0xaa>
            *right_store = start;
c010556d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105570:	8b 55 10             	mov    0x10(%ebp),%edx
c0105573:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105575:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105578:	eb 05                	jmp    c010557f <get_pgtable_items+0xb4>
    }
    return 0;
c010557a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010557f:	c9                   	leave  
c0105580:	c3                   	ret    

c0105581 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105581:	55                   	push   %ebp
c0105582:	89 e5                	mov    %esp,%ebp
c0105584:	57                   	push   %edi
c0105585:	56                   	push   %esi
c0105586:	53                   	push   %ebx
c0105587:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010558a:	c7 04 24 9c 72 10 c0 	movl   $0xc010729c,(%esp)
c0105591:	e8 b1 ad ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
c0105596:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010559d:	e9 fa 00 00 00       	jmp    c010569c <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01055a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055a5:	89 04 24             	mov    %eax,(%esp)
c01055a8:	e8 d0 fe ff ff       	call   c010547d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01055ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01055b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01055b3:	29 d1                	sub    %edx,%ecx
c01055b5:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01055b7:	89 d6                	mov    %edx,%esi
c01055b9:	c1 e6 16             	shl    $0x16,%esi
c01055bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01055bf:	89 d3                	mov    %edx,%ebx
c01055c1:	c1 e3 16             	shl    $0x16,%ebx
c01055c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01055c7:	89 d1                	mov    %edx,%ecx
c01055c9:	c1 e1 16             	shl    $0x16,%ecx
c01055cc:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01055cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01055d2:	29 d7                	sub    %edx,%edi
c01055d4:	89 fa                	mov    %edi,%edx
c01055d6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01055da:	89 74 24 10          	mov    %esi,0x10(%esp)
c01055de:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01055e6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055ea:	c7 04 24 cd 72 10 c0 	movl   $0xc01072cd,(%esp)
c01055f1:	e8 51 ad ff ff       	call   c0100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01055f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055f9:	c1 e0 0a             	shl    $0xa,%eax
c01055fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01055ff:	eb 54                	jmp    c0105655 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105604:	89 04 24             	mov    %eax,(%esp)
c0105607:	e8 71 fe ff ff       	call   c010547d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010560c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010560f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105612:	29 d1                	sub    %edx,%ecx
c0105614:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105616:	89 d6                	mov    %edx,%esi
c0105618:	c1 e6 0c             	shl    $0xc,%esi
c010561b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010561e:	89 d3                	mov    %edx,%ebx
c0105620:	c1 e3 0c             	shl    $0xc,%ebx
c0105623:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105626:	c1 e2 0c             	shl    $0xc,%edx
c0105629:	89 d1                	mov    %edx,%ecx
c010562b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010562e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105631:	29 d7                	sub    %edx,%edi
c0105633:	89 fa                	mov    %edi,%edx
c0105635:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105639:	89 74 24 10          	mov    %esi,0x10(%esp)
c010563d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105641:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105645:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105649:	c7 04 24 ec 72 10 c0 	movl   $0xc01072ec,(%esp)
c0105650:	e8 f2 ac ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105655:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010565a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010565d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105660:	89 ce                	mov    %ecx,%esi
c0105662:	c1 e6 0a             	shl    $0xa,%esi
c0105665:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105668:	89 cb                	mov    %ecx,%ebx
c010566a:	c1 e3 0a             	shl    $0xa,%ebx
c010566d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105670:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105674:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105677:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010567b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010567f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105683:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105687:	89 1c 24             	mov    %ebx,(%esp)
c010568a:	e8 3c fe ff ff       	call   c01054cb <get_pgtable_items>
c010568f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105696:	0f 85 65 ff ff ff    	jne    c0105601 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010569c:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01056a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056a4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01056a7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01056ab:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01056ae:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01056b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01056b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056ba:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01056c1:	00 
c01056c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01056c9:	e8 fd fd ff ff       	call   c01054cb <get_pgtable_items>
c01056ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056d5:	0f 85 c7 fe ff ff    	jne    c01055a2 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01056db:	c7 04 24 10 73 10 c0 	movl   $0xc0107310,(%esp)
c01056e2:	e8 60 ac ff ff       	call   c0100347 <cprintf>
}
c01056e7:	83 c4 4c             	add    $0x4c,%esp
c01056ea:	5b                   	pop    %ebx
c01056eb:	5e                   	pop    %esi
c01056ec:	5f                   	pop    %edi
c01056ed:	5d                   	pop    %ebp
c01056ee:	c3                   	ret    

c01056ef <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01056ef:	55                   	push   %ebp
c01056f0:	89 e5                	mov    %esp,%ebp
c01056f2:	83 ec 58             	sub    $0x58,%esp
c01056f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01056f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01056fb:	8b 45 14             	mov    0x14(%ebp),%eax
c01056fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105701:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105704:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105707:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010570a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010570d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105713:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105716:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105719:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010571c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010571f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105722:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105725:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105729:	74 1c                	je     c0105747 <printnum+0x58>
c010572b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010572e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105733:	f7 75 e4             	divl   -0x1c(%ebp)
c0105736:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105739:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010573c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105741:	f7 75 e4             	divl   -0x1c(%ebp)
c0105744:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105747:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010574a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010574d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105750:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105753:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105756:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105759:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010575c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010575f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105762:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105765:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105768:	8b 45 18             	mov    0x18(%ebp),%eax
c010576b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105770:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105773:	77 56                	ja     c01057cb <printnum+0xdc>
c0105775:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105778:	72 05                	jb     c010577f <printnum+0x90>
c010577a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010577d:	77 4c                	ja     c01057cb <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010577f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105782:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105785:	8b 45 20             	mov    0x20(%ebp),%eax
c0105788:	89 44 24 18          	mov    %eax,0x18(%esp)
c010578c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105790:	8b 45 18             	mov    0x18(%ebp),%eax
c0105793:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105797:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010579a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010579d:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01057a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01057af:	89 04 24             	mov    %eax,(%esp)
c01057b2:	e8 38 ff ff ff       	call   c01056ef <printnum>
c01057b7:	eb 1c                	jmp    c01057d5 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01057b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c0:	8b 45 20             	mov    0x20(%ebp),%eax
c01057c3:	89 04 24             	mov    %eax,(%esp)
c01057c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c9:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01057cb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01057cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01057d3:	7f e4                	jg     c01057b9 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01057d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01057d8:	05 d0 73 10 c0       	add    $0xc01073d0,%eax
c01057dd:	0f b6 00             	movzbl (%eax),%eax
c01057e0:	0f be c0             	movsbl %al,%eax
c01057e3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057e6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ea:	89 04 24             	mov    %eax,(%esp)
c01057ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f0:	ff d0                	call   *%eax
}
c01057f2:	c9                   	leave  
c01057f3:	c3                   	ret    

c01057f4 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01057f4:	55                   	push   %ebp
c01057f5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01057f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01057fb:	7e 14                	jle    c0105811 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01057fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105800:	8b 00                	mov    (%eax),%eax
c0105802:	8d 48 08             	lea    0x8(%eax),%ecx
c0105805:	8b 55 08             	mov    0x8(%ebp),%edx
c0105808:	89 0a                	mov    %ecx,(%edx)
c010580a:	8b 50 04             	mov    0x4(%eax),%edx
c010580d:	8b 00                	mov    (%eax),%eax
c010580f:	eb 30                	jmp    c0105841 <getuint+0x4d>
    }
    else if (lflag) {
c0105811:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105815:	74 16                	je     c010582d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105817:	8b 45 08             	mov    0x8(%ebp),%eax
c010581a:	8b 00                	mov    (%eax),%eax
c010581c:	8d 48 04             	lea    0x4(%eax),%ecx
c010581f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105822:	89 0a                	mov    %ecx,(%edx)
c0105824:	8b 00                	mov    (%eax),%eax
c0105826:	ba 00 00 00 00       	mov    $0x0,%edx
c010582b:	eb 14                	jmp    c0105841 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010582d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105830:	8b 00                	mov    (%eax),%eax
c0105832:	8d 48 04             	lea    0x4(%eax),%ecx
c0105835:	8b 55 08             	mov    0x8(%ebp),%edx
c0105838:	89 0a                	mov    %ecx,(%edx)
c010583a:	8b 00                	mov    (%eax),%eax
c010583c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105841:	5d                   	pop    %ebp
c0105842:	c3                   	ret    

c0105843 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105843:	55                   	push   %ebp
c0105844:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105846:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010584a:	7e 14                	jle    c0105860 <getint+0x1d>
        return va_arg(*ap, long long);
c010584c:	8b 45 08             	mov    0x8(%ebp),%eax
c010584f:	8b 00                	mov    (%eax),%eax
c0105851:	8d 48 08             	lea    0x8(%eax),%ecx
c0105854:	8b 55 08             	mov    0x8(%ebp),%edx
c0105857:	89 0a                	mov    %ecx,(%edx)
c0105859:	8b 50 04             	mov    0x4(%eax),%edx
c010585c:	8b 00                	mov    (%eax),%eax
c010585e:	eb 28                	jmp    c0105888 <getint+0x45>
    }
    else if (lflag) {
c0105860:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105864:	74 12                	je     c0105878 <getint+0x35>
        return va_arg(*ap, long);
c0105866:	8b 45 08             	mov    0x8(%ebp),%eax
c0105869:	8b 00                	mov    (%eax),%eax
c010586b:	8d 48 04             	lea    0x4(%eax),%ecx
c010586e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105871:	89 0a                	mov    %ecx,(%edx)
c0105873:	8b 00                	mov    (%eax),%eax
c0105875:	99                   	cltd   
c0105876:	eb 10                	jmp    c0105888 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105878:	8b 45 08             	mov    0x8(%ebp),%eax
c010587b:	8b 00                	mov    (%eax),%eax
c010587d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105880:	8b 55 08             	mov    0x8(%ebp),%edx
c0105883:	89 0a                	mov    %ecx,(%edx)
c0105885:	8b 00                	mov    (%eax),%eax
c0105887:	99                   	cltd   
    }
}
c0105888:	5d                   	pop    %ebp
c0105889:	c3                   	ret    

c010588a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010588a:	55                   	push   %ebp
c010588b:	89 e5                	mov    %esp,%ebp
c010588d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105890:	8d 45 14             	lea    0x14(%ebp),%eax
c0105893:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105896:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105899:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010589d:	8b 45 10             	mov    0x10(%ebp),%eax
c01058a0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ae:	89 04 24             	mov    %eax,(%esp)
c01058b1:	e8 02 00 00 00       	call   c01058b8 <vprintfmt>
    va_end(ap);
}
c01058b6:	c9                   	leave  
c01058b7:	c3                   	ret    

c01058b8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01058b8:	55                   	push   %ebp
c01058b9:	89 e5                	mov    %esp,%ebp
c01058bb:	56                   	push   %esi
c01058bc:	53                   	push   %ebx
c01058bd:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058c0:	eb 18                	jmp    c01058da <vprintfmt+0x22>
            if (ch == '\0') {
c01058c2:	85 db                	test   %ebx,%ebx
c01058c4:	75 05                	jne    c01058cb <vprintfmt+0x13>
                return;
c01058c6:	e9 d1 03 00 00       	jmp    c0105c9c <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01058cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d2:	89 1c 24             	mov    %ebx,(%esp)
c01058d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d8:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058da:	8b 45 10             	mov    0x10(%ebp),%eax
c01058dd:	8d 50 01             	lea    0x1(%eax),%edx
c01058e0:	89 55 10             	mov    %edx,0x10(%ebp)
c01058e3:	0f b6 00             	movzbl (%eax),%eax
c01058e6:	0f b6 d8             	movzbl %al,%ebx
c01058e9:	83 fb 25             	cmp    $0x25,%ebx
c01058ec:	75 d4                	jne    c01058c2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01058ee:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01058f2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01058f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01058ff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105906:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105909:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010590c:	8b 45 10             	mov    0x10(%ebp),%eax
c010590f:	8d 50 01             	lea    0x1(%eax),%edx
c0105912:	89 55 10             	mov    %edx,0x10(%ebp)
c0105915:	0f b6 00             	movzbl (%eax),%eax
c0105918:	0f b6 d8             	movzbl %al,%ebx
c010591b:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010591e:	83 f8 55             	cmp    $0x55,%eax
c0105921:	0f 87 44 03 00 00    	ja     c0105c6b <vprintfmt+0x3b3>
c0105927:	8b 04 85 f4 73 10 c0 	mov    -0x3fef8c0c(,%eax,4),%eax
c010592e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105930:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105934:	eb d6                	jmp    c010590c <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105936:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010593a:	eb d0                	jmp    c010590c <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010593c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105946:	89 d0                	mov    %edx,%eax
c0105948:	c1 e0 02             	shl    $0x2,%eax
c010594b:	01 d0                	add    %edx,%eax
c010594d:	01 c0                	add    %eax,%eax
c010594f:	01 d8                	add    %ebx,%eax
c0105951:	83 e8 30             	sub    $0x30,%eax
c0105954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105957:	8b 45 10             	mov    0x10(%ebp),%eax
c010595a:	0f b6 00             	movzbl (%eax),%eax
c010595d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105960:	83 fb 2f             	cmp    $0x2f,%ebx
c0105963:	7e 0b                	jle    c0105970 <vprintfmt+0xb8>
c0105965:	83 fb 39             	cmp    $0x39,%ebx
c0105968:	7f 06                	jg     c0105970 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010596a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010596e:	eb d3                	jmp    c0105943 <vprintfmt+0x8b>
            goto process_precision;
c0105970:	eb 33                	jmp    c01059a5 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105972:	8b 45 14             	mov    0x14(%ebp),%eax
c0105975:	8d 50 04             	lea    0x4(%eax),%edx
c0105978:	89 55 14             	mov    %edx,0x14(%ebp)
c010597b:	8b 00                	mov    (%eax),%eax
c010597d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105980:	eb 23                	jmp    c01059a5 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105982:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105986:	79 0c                	jns    c0105994 <vprintfmt+0xdc>
                width = 0;
c0105988:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010598f:	e9 78 ff ff ff       	jmp    c010590c <vprintfmt+0x54>
c0105994:	e9 73 ff ff ff       	jmp    c010590c <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105999:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01059a0:	e9 67 ff ff ff       	jmp    c010590c <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01059a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059a9:	79 12                	jns    c01059bd <vprintfmt+0x105>
                width = precision, precision = -1;
c01059ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01059b8:	e9 4f ff ff ff       	jmp    c010590c <vprintfmt+0x54>
c01059bd:	e9 4a ff ff ff       	jmp    c010590c <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01059c2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01059c6:	e9 41 ff ff ff       	jmp    c010590c <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01059cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01059ce:	8d 50 04             	lea    0x4(%eax),%edx
c01059d1:	89 55 14             	mov    %edx,0x14(%ebp)
c01059d4:	8b 00                	mov    (%eax),%eax
c01059d6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059dd:	89 04 24             	mov    %eax,(%esp)
c01059e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e3:	ff d0                	call   *%eax
            break;
c01059e5:	e9 ac 02 00 00       	jmp    c0105c96 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01059ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01059ed:	8d 50 04             	lea    0x4(%eax),%edx
c01059f0:	89 55 14             	mov    %edx,0x14(%ebp)
c01059f3:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01059f5:	85 db                	test   %ebx,%ebx
c01059f7:	79 02                	jns    c01059fb <vprintfmt+0x143>
                err = -err;
c01059f9:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01059fb:	83 fb 06             	cmp    $0x6,%ebx
c01059fe:	7f 0b                	jg     c0105a0b <vprintfmt+0x153>
c0105a00:	8b 34 9d b4 73 10 c0 	mov    -0x3fef8c4c(,%ebx,4),%esi
c0105a07:	85 f6                	test   %esi,%esi
c0105a09:	75 23                	jne    c0105a2e <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105a0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105a0f:	c7 44 24 08 e1 73 10 	movl   $0xc01073e1,0x8(%esp)
c0105a16:	c0 
c0105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a21:	89 04 24             	mov    %eax,(%esp)
c0105a24:	e8 61 fe ff ff       	call   c010588a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105a29:	e9 68 02 00 00       	jmp    c0105c96 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105a2e:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105a32:	c7 44 24 08 ea 73 10 	movl   $0xc01073ea,0x8(%esp)
c0105a39:	c0 
c0105a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a44:	89 04 24             	mov    %eax,(%esp)
c0105a47:	e8 3e fe ff ff       	call   c010588a <printfmt>
            }
            break;
c0105a4c:	e9 45 02 00 00       	jmp    c0105c96 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105a51:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a54:	8d 50 04             	lea    0x4(%eax),%edx
c0105a57:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a5a:	8b 30                	mov    (%eax),%esi
c0105a5c:	85 f6                	test   %esi,%esi
c0105a5e:	75 05                	jne    c0105a65 <vprintfmt+0x1ad>
                p = "(null)";
c0105a60:	be ed 73 10 c0       	mov    $0xc01073ed,%esi
            }
            if (width > 0 && padc != '-') {
c0105a65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a69:	7e 3e                	jle    c0105aa9 <vprintfmt+0x1f1>
c0105a6b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105a6f:	74 38                	je     c0105aa9 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a71:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105a74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a7b:	89 34 24             	mov    %esi,(%esp)
c0105a7e:	e8 15 03 00 00       	call   c0105d98 <strnlen>
c0105a83:	29 c3                	sub    %eax,%ebx
c0105a85:	89 d8                	mov    %ebx,%eax
c0105a87:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a8a:	eb 17                	jmp    c0105aa3 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105a8c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105a90:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a93:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a97:	89 04 24             	mov    %eax,(%esp)
c0105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9d:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a9f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105aa3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105aa7:	7f e3                	jg     c0105a8c <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105aa9:	eb 38                	jmp    c0105ae3 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105aab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105aaf:	74 1f                	je     c0105ad0 <vprintfmt+0x218>
c0105ab1:	83 fb 1f             	cmp    $0x1f,%ebx
c0105ab4:	7e 05                	jle    c0105abb <vprintfmt+0x203>
c0105ab6:	83 fb 7e             	cmp    $0x7e,%ebx
c0105ab9:	7e 15                	jle    c0105ad0 <vprintfmt+0x218>
                    putch('?', putdat);
c0105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acc:	ff d0                	call   *%eax
c0105ace:	eb 0f                	jmp    c0105adf <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ad7:	89 1c 24             	mov    %ebx,(%esp)
c0105ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0105add:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105adf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105ae3:	89 f0                	mov    %esi,%eax
c0105ae5:	8d 70 01             	lea    0x1(%eax),%esi
c0105ae8:	0f b6 00             	movzbl (%eax),%eax
c0105aeb:	0f be d8             	movsbl %al,%ebx
c0105aee:	85 db                	test   %ebx,%ebx
c0105af0:	74 10                	je     c0105b02 <vprintfmt+0x24a>
c0105af2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105af6:	78 b3                	js     c0105aab <vprintfmt+0x1f3>
c0105af8:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105afc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b00:	79 a9                	jns    c0105aab <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105b02:	eb 17                	jmp    c0105b1b <vprintfmt+0x263>
                putch(' ', putdat);
c0105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b0b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b15:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105b17:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b1f:	7f e3                	jg     c0105b04 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105b21:	e9 70 01 00 00       	jmp    c0105c96 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b2d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b30:	89 04 24             	mov    %eax,(%esp)
c0105b33:	e8 0b fd ff ff       	call   c0105843 <getint>
c0105b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b44:	85 d2                	test   %edx,%edx
c0105b46:	79 26                	jns    c0105b6e <vprintfmt+0x2b6>
                putch('-', putdat);
c0105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b4f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b59:	ff d0                	call   *%eax
                num = -(long long)num;
c0105b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b61:	f7 d8                	neg    %eax
c0105b63:	83 d2 00             	adc    $0x0,%edx
c0105b66:	f7 da                	neg    %edx
c0105b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105b6e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b75:	e9 a8 00 00 00       	jmp    c0105c22 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b81:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b84:	89 04 24             	mov    %eax,(%esp)
c0105b87:	e8 68 fc ff ff       	call   c01057f4 <getuint>
c0105b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105b92:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b99:	e9 84 00 00 00       	jmp    c0105c22 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ba5:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ba8:	89 04 24             	mov    %eax,(%esp)
c0105bab:	e8 44 fc ff ff       	call   c01057f4 <getuint>
c0105bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105bb6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105bbd:	eb 63                	jmp    c0105c22 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bc6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd0:	ff d0                	call   *%eax
            putch('x', putdat);
c0105bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bd9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105be5:	8b 45 14             	mov    0x14(%ebp),%eax
c0105be8:	8d 50 04             	lea    0x4(%eax),%edx
c0105beb:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bee:	8b 00                	mov    (%eax),%eax
c0105bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105bfa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105c01:	eb 1f                	jmp    c0105c22 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c0a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c0d:	89 04 24             	mov    %eax,(%esp)
c0105c10:	e8 df fb ff ff       	call   c01057f4 <getuint>
c0105c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105c1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105c22:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c29:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105c2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c30:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105c34:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c3e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c42:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105c46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c50:	89 04 24             	mov    %eax,(%esp)
c0105c53:	e8 97 fa ff ff       	call   c01056ef <printnum>
            break;
c0105c58:	eb 3c                	jmp    c0105c96 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c61:	89 1c 24             	mov    %ebx,(%esp)
c0105c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c67:	ff d0                	call   *%eax
            break;
c0105c69:	eb 2b                	jmp    c0105c96 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c72:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105c7e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c82:	eb 04                	jmp    c0105c88 <vprintfmt+0x3d0>
c0105c84:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c88:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c8b:	83 e8 01             	sub    $0x1,%eax
c0105c8e:	0f b6 00             	movzbl (%eax),%eax
c0105c91:	3c 25                	cmp    $0x25,%al
c0105c93:	75 ef                	jne    c0105c84 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105c95:	90                   	nop
        }
    }
c0105c96:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c97:	e9 3e fc ff ff       	jmp    c01058da <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105c9c:	83 c4 40             	add    $0x40,%esp
c0105c9f:	5b                   	pop    %ebx
c0105ca0:	5e                   	pop    %esi
c0105ca1:	5d                   	pop    %ebp
c0105ca2:	c3                   	ret    

c0105ca3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105ca3:	55                   	push   %ebp
c0105ca4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ca9:	8b 40 08             	mov    0x8(%eax),%eax
c0105cac:	8d 50 01             	lea    0x1(%eax),%edx
c0105caf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb8:	8b 10                	mov    (%eax),%edx
c0105cba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cbd:	8b 40 04             	mov    0x4(%eax),%eax
c0105cc0:	39 c2                	cmp    %eax,%edx
c0105cc2:	73 12                	jae    c0105cd6 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc7:	8b 00                	mov    (%eax),%eax
c0105cc9:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ccf:	89 0a                	mov    %ecx,(%edx)
c0105cd1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cd4:	88 10                	mov    %dl,(%eax)
    }
}
c0105cd6:	5d                   	pop    %ebp
c0105cd7:	c3                   	ret    

c0105cd8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105cd8:	55                   	push   %ebp
c0105cd9:	89 e5                	mov    %esp,%ebp
c0105cdb:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105cde:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ceb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cee:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfc:	89 04 24             	mov    %eax,(%esp)
c0105cff:	e8 08 00 00 00       	call   c0105d0c <vsnprintf>
c0105d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d0a:	c9                   	leave  
c0105d0b:	c3                   	ret    

c0105d0c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105d0c:	55                   	push   %ebp
c0105d0d:	89 e5                	mov    %esp,%ebp
c0105d0f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d1b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d21:	01 d0                	add    %edx,%eax
c0105d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105d2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105d31:	74 0a                	je     c0105d3d <vsnprintf+0x31>
c0105d33:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d39:	39 c2                	cmp    %eax,%edx
c0105d3b:	76 07                	jbe    c0105d44 <vsnprintf+0x38>
        return -E_INVAL;
c0105d3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105d42:	eb 2a                	jmp    c0105d6e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105d44:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d47:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d4e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d52:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d59:	c7 04 24 a3 5c 10 c0 	movl   $0xc0105ca3,(%esp)
c0105d60:	e8 53 fb ff ff       	call   c01058b8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d68:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d6e:	c9                   	leave  
c0105d6f:	c3                   	ret    

c0105d70 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105d70:	55                   	push   %ebp
c0105d71:	89 e5                	mov    %esp,%ebp
c0105d73:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105d76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105d7d:	eb 04                	jmp    c0105d83 <strlen+0x13>
        cnt ++;
c0105d7f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d86:	8d 50 01             	lea    0x1(%eax),%edx
c0105d89:	89 55 08             	mov    %edx,0x8(%ebp)
c0105d8c:	0f b6 00             	movzbl (%eax),%eax
c0105d8f:	84 c0                	test   %al,%al
c0105d91:	75 ec                	jne    c0105d7f <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105d96:	c9                   	leave  
c0105d97:	c3                   	ret    

c0105d98 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105d98:	55                   	push   %ebp
c0105d99:	89 e5                	mov    %esp,%ebp
c0105d9b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105d9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105da5:	eb 04                	jmp    c0105dab <strnlen+0x13>
        cnt ++;
c0105da7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dae:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105db1:	73 10                	jae    c0105dc3 <strnlen+0x2b>
c0105db3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db6:	8d 50 01             	lea    0x1(%eax),%edx
c0105db9:	89 55 08             	mov    %edx,0x8(%ebp)
c0105dbc:	0f b6 00             	movzbl (%eax),%eax
c0105dbf:	84 c0                	test   %al,%al
c0105dc1:	75 e4                	jne    c0105da7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105dc6:	c9                   	leave  
c0105dc7:	c3                   	ret    

c0105dc8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105dc8:	55                   	push   %ebp
c0105dc9:	89 e5                	mov    %esp,%ebp
c0105dcb:	57                   	push   %edi
c0105dcc:	56                   	push   %esi
c0105dcd:	83 ec 20             	sub    $0x20,%esp
c0105dd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105de2:	89 d1                	mov    %edx,%ecx
c0105de4:	89 c2                	mov    %eax,%edx
c0105de6:	89 ce                	mov    %ecx,%esi
c0105de8:	89 d7                	mov    %edx,%edi
c0105dea:	ac                   	lods   %ds:(%esi),%al
c0105deb:	aa                   	stos   %al,%es:(%edi)
c0105dec:	84 c0                	test   %al,%al
c0105dee:	75 fa                	jne    c0105dea <strcpy+0x22>
c0105df0:	89 fa                	mov    %edi,%edx
c0105df2:	89 f1                	mov    %esi,%ecx
c0105df4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105df7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105dfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105e00:	83 c4 20             	add    $0x20,%esp
c0105e03:	5e                   	pop    %esi
c0105e04:	5f                   	pop    %edi
c0105e05:	5d                   	pop    %ebp
c0105e06:	c3                   	ret    

c0105e07 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105e07:	55                   	push   %ebp
c0105e08:	89 e5                	mov    %esp,%ebp
c0105e0a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105e13:	eb 21                	jmp    c0105e36 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105e15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e18:	0f b6 10             	movzbl (%eax),%edx
c0105e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e1e:	88 10                	mov    %dl,(%eax)
c0105e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e23:	0f b6 00             	movzbl (%eax),%eax
c0105e26:	84 c0                	test   %al,%al
c0105e28:	74 04                	je     c0105e2e <strncpy+0x27>
            src ++;
c0105e2a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105e2e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e3a:	75 d9                	jne    c0105e15 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e3f:	c9                   	leave  
c0105e40:	c3                   	ret    

c0105e41 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105e41:	55                   	push   %ebp
c0105e42:	89 e5                	mov    %esp,%ebp
c0105e44:	57                   	push   %edi
c0105e45:	56                   	push   %esi
c0105e46:	83 ec 20             	sub    $0x20,%esp
c0105e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e5b:	89 d1                	mov    %edx,%ecx
c0105e5d:	89 c2                	mov    %eax,%edx
c0105e5f:	89 ce                	mov    %ecx,%esi
c0105e61:	89 d7                	mov    %edx,%edi
c0105e63:	ac                   	lods   %ds:(%esi),%al
c0105e64:	ae                   	scas   %es:(%edi),%al
c0105e65:	75 08                	jne    c0105e6f <strcmp+0x2e>
c0105e67:	84 c0                	test   %al,%al
c0105e69:	75 f8                	jne    c0105e63 <strcmp+0x22>
c0105e6b:	31 c0                	xor    %eax,%eax
c0105e6d:	eb 04                	jmp    c0105e73 <strcmp+0x32>
c0105e6f:	19 c0                	sbb    %eax,%eax
c0105e71:	0c 01                	or     $0x1,%al
c0105e73:	89 fa                	mov    %edi,%edx
c0105e75:	89 f1                	mov    %esi,%ecx
c0105e77:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e7a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105e83:	83 c4 20             	add    $0x20,%esp
c0105e86:	5e                   	pop    %esi
c0105e87:	5f                   	pop    %edi
c0105e88:	5d                   	pop    %ebp
c0105e89:	c3                   	ret    

c0105e8a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105e8a:	55                   	push   %ebp
c0105e8b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105e8d:	eb 0c                	jmp    c0105e9b <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105e8f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105e93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e9f:	74 1a                	je     c0105ebb <strncmp+0x31>
c0105ea1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea4:	0f b6 00             	movzbl (%eax),%eax
c0105ea7:	84 c0                	test   %al,%al
c0105ea9:	74 10                	je     c0105ebb <strncmp+0x31>
c0105eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eae:	0f b6 10             	movzbl (%eax),%edx
c0105eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eb4:	0f b6 00             	movzbl (%eax),%eax
c0105eb7:	38 c2                	cmp    %al,%dl
c0105eb9:	74 d4                	je     c0105e8f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ebf:	74 18                	je     c0105ed9 <strncmp+0x4f>
c0105ec1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec4:	0f b6 00             	movzbl (%eax),%eax
c0105ec7:	0f b6 d0             	movzbl %al,%edx
c0105eca:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ecd:	0f b6 00             	movzbl (%eax),%eax
c0105ed0:	0f b6 c0             	movzbl %al,%eax
c0105ed3:	29 c2                	sub    %eax,%edx
c0105ed5:	89 d0                	mov    %edx,%eax
c0105ed7:	eb 05                	jmp    c0105ede <strncmp+0x54>
c0105ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ede:	5d                   	pop    %ebp
c0105edf:	c3                   	ret    

c0105ee0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105ee0:	55                   	push   %ebp
c0105ee1:	89 e5                	mov    %esp,%ebp
c0105ee3:	83 ec 04             	sub    $0x4,%esp
c0105ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ee9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105eec:	eb 14                	jmp    c0105f02 <strchr+0x22>
        if (*s == c) {
c0105eee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef1:	0f b6 00             	movzbl (%eax),%eax
c0105ef4:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ef7:	75 05                	jne    c0105efe <strchr+0x1e>
            return (char *)s;
c0105ef9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efc:	eb 13                	jmp    c0105f11 <strchr+0x31>
        }
        s ++;
c0105efe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f05:	0f b6 00             	movzbl (%eax),%eax
c0105f08:	84 c0                	test   %al,%al
c0105f0a:	75 e2                	jne    c0105eee <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f11:	c9                   	leave  
c0105f12:	c3                   	ret    

c0105f13 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105f13:	55                   	push   %ebp
c0105f14:	89 e5                	mov    %esp,%ebp
c0105f16:	83 ec 04             	sub    $0x4,%esp
c0105f19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f1c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f1f:	eb 11                	jmp    c0105f32 <strfind+0x1f>
        if (*s == c) {
c0105f21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f24:	0f b6 00             	movzbl (%eax),%eax
c0105f27:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105f2a:	75 02                	jne    c0105f2e <strfind+0x1b>
            break;
c0105f2c:	eb 0e                	jmp    c0105f3c <strfind+0x29>
        }
        s ++;
c0105f2e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105f32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f35:	0f b6 00             	movzbl (%eax),%eax
c0105f38:	84 c0                	test   %al,%al
c0105f3a:	75 e5                	jne    c0105f21 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105f3f:	c9                   	leave  
c0105f40:	c3                   	ret    

c0105f41 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105f41:	55                   	push   %ebp
c0105f42:	89 e5                	mov    %esp,%ebp
c0105f44:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105f47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105f4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f55:	eb 04                	jmp    c0105f5b <strtol+0x1a>
        s ++;
c0105f57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5e:	0f b6 00             	movzbl (%eax),%eax
c0105f61:	3c 20                	cmp    $0x20,%al
c0105f63:	74 f2                	je     c0105f57 <strtol+0x16>
c0105f65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f68:	0f b6 00             	movzbl (%eax),%eax
c0105f6b:	3c 09                	cmp    $0x9,%al
c0105f6d:	74 e8                	je     c0105f57 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105f6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f72:	0f b6 00             	movzbl (%eax),%eax
c0105f75:	3c 2b                	cmp    $0x2b,%al
c0105f77:	75 06                	jne    c0105f7f <strtol+0x3e>
        s ++;
c0105f79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f7d:	eb 15                	jmp    c0105f94 <strtol+0x53>
    }
    else if (*s == '-') {
c0105f7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f82:	0f b6 00             	movzbl (%eax),%eax
c0105f85:	3c 2d                	cmp    $0x2d,%al
c0105f87:	75 0b                	jne    c0105f94 <strtol+0x53>
        s ++, neg = 1;
c0105f89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f98:	74 06                	je     c0105fa0 <strtol+0x5f>
c0105f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105f9e:	75 24                	jne    c0105fc4 <strtol+0x83>
c0105fa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa3:	0f b6 00             	movzbl (%eax),%eax
c0105fa6:	3c 30                	cmp    $0x30,%al
c0105fa8:	75 1a                	jne    c0105fc4 <strtol+0x83>
c0105faa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fad:	83 c0 01             	add    $0x1,%eax
c0105fb0:	0f b6 00             	movzbl (%eax),%eax
c0105fb3:	3c 78                	cmp    $0x78,%al
c0105fb5:	75 0d                	jne    c0105fc4 <strtol+0x83>
        s += 2, base = 16;
c0105fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105fc2:	eb 2a                	jmp    c0105fee <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fc8:	75 17                	jne    c0105fe1 <strtol+0xa0>
c0105fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fcd:	0f b6 00             	movzbl (%eax),%eax
c0105fd0:	3c 30                	cmp    $0x30,%al
c0105fd2:	75 0d                	jne    c0105fe1 <strtol+0xa0>
        s ++, base = 8;
c0105fd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105fd8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105fdf:	eb 0d                	jmp    c0105fee <strtol+0xad>
    }
    else if (base == 0) {
c0105fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fe5:	75 07                	jne    c0105fee <strtol+0xad>
        base = 10;
c0105fe7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105fee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff1:	0f b6 00             	movzbl (%eax),%eax
c0105ff4:	3c 2f                	cmp    $0x2f,%al
c0105ff6:	7e 1b                	jle    c0106013 <strtol+0xd2>
c0105ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ffb:	0f b6 00             	movzbl (%eax),%eax
c0105ffe:	3c 39                	cmp    $0x39,%al
c0106000:	7f 11                	jg     c0106013 <strtol+0xd2>
            dig = *s - '0';
c0106002:	8b 45 08             	mov    0x8(%ebp),%eax
c0106005:	0f b6 00             	movzbl (%eax),%eax
c0106008:	0f be c0             	movsbl %al,%eax
c010600b:	83 e8 30             	sub    $0x30,%eax
c010600e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106011:	eb 48                	jmp    c010605b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0106013:	8b 45 08             	mov    0x8(%ebp),%eax
c0106016:	0f b6 00             	movzbl (%eax),%eax
c0106019:	3c 60                	cmp    $0x60,%al
c010601b:	7e 1b                	jle    c0106038 <strtol+0xf7>
c010601d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106020:	0f b6 00             	movzbl (%eax),%eax
c0106023:	3c 7a                	cmp    $0x7a,%al
c0106025:	7f 11                	jg     c0106038 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0106027:	8b 45 08             	mov    0x8(%ebp),%eax
c010602a:	0f b6 00             	movzbl (%eax),%eax
c010602d:	0f be c0             	movsbl %al,%eax
c0106030:	83 e8 57             	sub    $0x57,%eax
c0106033:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106036:	eb 23                	jmp    c010605b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0106038:	8b 45 08             	mov    0x8(%ebp),%eax
c010603b:	0f b6 00             	movzbl (%eax),%eax
c010603e:	3c 40                	cmp    $0x40,%al
c0106040:	7e 3d                	jle    c010607f <strtol+0x13e>
c0106042:	8b 45 08             	mov    0x8(%ebp),%eax
c0106045:	0f b6 00             	movzbl (%eax),%eax
c0106048:	3c 5a                	cmp    $0x5a,%al
c010604a:	7f 33                	jg     c010607f <strtol+0x13e>
            dig = *s - 'A' + 10;
c010604c:	8b 45 08             	mov    0x8(%ebp),%eax
c010604f:	0f b6 00             	movzbl (%eax),%eax
c0106052:	0f be c0             	movsbl %al,%eax
c0106055:	83 e8 37             	sub    $0x37,%eax
c0106058:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010605b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010605e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0106061:	7c 02                	jl     c0106065 <strtol+0x124>
            break;
c0106063:	eb 1a                	jmp    c010607f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0106065:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106069:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010606c:	0f af 45 10          	imul   0x10(%ebp),%eax
c0106070:	89 c2                	mov    %eax,%edx
c0106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106075:	01 d0                	add    %edx,%eax
c0106077:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010607a:	e9 6f ff ff ff       	jmp    c0105fee <strtol+0xad>

    if (endptr) {
c010607f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106083:	74 08                	je     c010608d <strtol+0x14c>
        *endptr = (char *) s;
c0106085:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106088:	8b 55 08             	mov    0x8(%ebp),%edx
c010608b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010608d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106091:	74 07                	je     c010609a <strtol+0x159>
c0106093:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106096:	f7 d8                	neg    %eax
c0106098:	eb 03                	jmp    c010609d <strtol+0x15c>
c010609a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010609d:	c9                   	leave  
c010609e:	c3                   	ret    

c010609f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010609f:	55                   	push   %ebp
c01060a0:	89 e5                	mov    %esp,%ebp
c01060a2:	57                   	push   %edi
c01060a3:	83 ec 24             	sub    $0x24,%esp
c01060a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060a9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01060ac:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01060b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01060b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01060b6:	88 45 f7             	mov    %al,-0x9(%ebp)
c01060b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01060bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01060bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01060c2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01060c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01060c9:	89 d7                	mov    %edx,%edi
c01060cb:	f3 aa                	rep stos %al,%es:(%edi)
c01060cd:	89 fa                	mov    %edi,%edx
c01060cf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01060d2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01060d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01060d8:	83 c4 24             	add    $0x24,%esp
c01060db:	5f                   	pop    %edi
c01060dc:	5d                   	pop    %ebp
c01060dd:	c3                   	ret    

c01060de <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01060de:	55                   	push   %ebp
c01060df:	89 e5                	mov    %esp,%ebp
c01060e1:	57                   	push   %edi
c01060e2:	56                   	push   %esi
c01060e3:	53                   	push   %ebx
c01060e4:	83 ec 30             	sub    $0x30,%esp
c01060e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01060f6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01060f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01060ff:	73 42                	jae    c0106143 <memmove+0x65>
c0106101:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106107:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010610a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010610d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106110:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106113:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106116:	c1 e8 02             	shr    $0x2,%eax
c0106119:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010611b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010611e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106121:	89 d7                	mov    %edx,%edi
c0106123:	89 c6                	mov    %eax,%esi
c0106125:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106127:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010612a:	83 e1 03             	and    $0x3,%ecx
c010612d:	74 02                	je     c0106131 <memmove+0x53>
c010612f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106131:	89 f0                	mov    %esi,%eax
c0106133:	89 fa                	mov    %edi,%edx
c0106135:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106138:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010613b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010613e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106141:	eb 36                	jmp    c0106179 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106143:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106146:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106149:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010614c:	01 c2                	add    %eax,%edx
c010614e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106151:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106154:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106157:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010615a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010615d:	89 c1                	mov    %eax,%ecx
c010615f:	89 d8                	mov    %ebx,%eax
c0106161:	89 d6                	mov    %edx,%esi
c0106163:	89 c7                	mov    %eax,%edi
c0106165:	fd                   	std    
c0106166:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106168:	fc                   	cld    
c0106169:	89 f8                	mov    %edi,%eax
c010616b:	89 f2                	mov    %esi,%edx
c010616d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106170:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106173:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0106176:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106179:	83 c4 30             	add    $0x30,%esp
c010617c:	5b                   	pop    %ebx
c010617d:	5e                   	pop    %esi
c010617e:	5f                   	pop    %edi
c010617f:	5d                   	pop    %ebp
c0106180:	c3                   	ret    

c0106181 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0106181:	55                   	push   %ebp
c0106182:	89 e5                	mov    %esp,%ebp
c0106184:	57                   	push   %edi
c0106185:	56                   	push   %esi
c0106186:	83 ec 20             	sub    $0x20,%esp
c0106189:	8b 45 08             	mov    0x8(%ebp),%eax
c010618c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010618f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106192:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106195:	8b 45 10             	mov    0x10(%ebp),%eax
c0106198:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010619b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010619e:	c1 e8 02             	shr    $0x2,%eax
c01061a1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01061a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061a9:	89 d7                	mov    %edx,%edi
c01061ab:	89 c6                	mov    %eax,%esi
c01061ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01061af:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01061b2:	83 e1 03             	and    $0x3,%ecx
c01061b5:	74 02                	je     c01061b9 <memcpy+0x38>
c01061b7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01061b9:	89 f0                	mov    %esi,%eax
c01061bb:	89 fa                	mov    %edi,%edx
c01061bd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01061c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01061c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01061c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01061c9:	83 c4 20             	add    $0x20,%esp
c01061cc:	5e                   	pop    %esi
c01061cd:	5f                   	pop    %edi
c01061ce:	5d                   	pop    %ebp
c01061cf:	c3                   	ret    

c01061d0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01061d0:	55                   	push   %ebp
c01061d1:	89 e5                	mov    %esp,%ebp
c01061d3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01061d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01061d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01061dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061df:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01061e2:	eb 30                	jmp    c0106214 <memcmp+0x44>
        if (*s1 != *s2) {
c01061e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01061e7:	0f b6 10             	movzbl (%eax),%edx
c01061ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01061ed:	0f b6 00             	movzbl (%eax),%eax
c01061f0:	38 c2                	cmp    %al,%dl
c01061f2:	74 18                	je     c010620c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01061f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01061f7:	0f b6 00             	movzbl (%eax),%eax
c01061fa:	0f b6 d0             	movzbl %al,%edx
c01061fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106200:	0f b6 00             	movzbl (%eax),%eax
c0106203:	0f b6 c0             	movzbl %al,%eax
c0106206:	29 c2                	sub    %eax,%edx
c0106208:	89 d0                	mov    %edx,%eax
c010620a:	eb 1a                	jmp    c0106226 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010620c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106210:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106214:	8b 45 10             	mov    0x10(%ebp),%eax
c0106217:	8d 50 ff             	lea    -0x1(%eax),%edx
c010621a:	89 55 10             	mov    %edx,0x10(%ebp)
c010621d:	85 c0                	test   %eax,%eax
c010621f:	75 c3                	jne    c01061e4 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0106221:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106226:	c9                   	leave  
c0106227:	c3                   	ret    
