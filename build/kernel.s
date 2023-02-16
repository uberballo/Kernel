	.file	"kernel.c"
	.text
	.p2align 4
	.globl	vga_entry
	.type	vga_entry, @function
vga_entry:
.LFB0:
	.cfi_startproc
	endbr64
	sall	$4, %edx
	movzbl	%dil, %eax
	orl	%esi, %edx
	sall	$8, %edx
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE0:
	.size	vga_entry, .-vga_entry
	.p2align 4
	.globl	clear_vga_buffer
	.type	clear_vga_buffer, @function
clear_vga_buffer:
.LFB1:
	.cfi_startproc
	endbr64
	sall	$4, %edx
	movq	(%rdi), %rax
	orl	%esi, %edx
	sall	$8, %edx
	movd	%edx, %xmm0
	leaq	4400(%rax), %rdx
	punpcklwd	%xmm0, %xmm0
	pshufd	$0, %xmm0, %xmm0
	.p2align 4,,10
	.p2align 3
.L4:
	movups	%xmm0, (%rax)
	addq	$16, %rax
	cmpq	%rax, %rdx
	jne	.L4
	movl	$1, next_line_index(%rip)
	movl	$0, vga_index(%rip)
	ret
	.cfi_endproc
.LFE1:
	.size	clear_vga_buffer, .-clear_vga_buffer
	.p2align 4
	.globl	init_vga
	.type	init_vga, @function
init_vga:
.LFB2:
	.cfi_startproc
	endbr64
	movl	%esi, %edx
	movl	$753664, %eax
	movq	$753664, vga_buffer(%rip)
	sall	$4, %edx
	orl	%edi, %edx
	sall	$8, %edx
	.p2align 4,,10
	.p2align 3
.L7:
	movw	%dx, (%rax)
	addq	$2, %rax
	cmpq	$758064, %rax
	jne	.L7
	movl	$1, next_line_index(%rip)
	movl	$0, vga_index(%rip)
	movb	%dil, g_fore_color(%rip)
	movb	%sil, g_back_color(%rip)
	ret
	.cfi_endproc
.LFE2:
	.size	init_vga, .-init_vga
	.p2align 4
	.globl	print_new_line
	.type	print_new_line, @function
print_new_line:
.LFB3:
	.cfi_startproc
	endbr64
	movl	next_line_index(%rip), %eax
	cmpl	$54, %eax
	ja	.L10
	leal	(%rax,%rax,4), %edx
	addl	$1, %eax
	sall	$4, %edx
	movl	%eax, next_line_index(%rip)
	movl	%edx, vga_index(%rip)
	ret
.L10:
	movzbl	g_back_color(%rip), %eax
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	sall	$8, %eax
	movd	%eax, %xmm0
	movq	vga_buffer(%rip), %rax
	punpcklwd	%xmm0, %xmm0
	pshufd	$0, %xmm0, %xmm0
	leaq	4400(%rax), %rdx
	.p2align 4,,10
	.p2align 3
.L12:
	movups	%xmm0, (%rax)
	addq	$16, %rax
	cmpq	%rax, %rdx
	jne	.L12
	movl	$2, %eax
	movl	$80, %edx
	movl	%edx, vga_index(%rip)
	movl	%eax, next_line_index(%rip)
	ret
	.cfi_endproc
.LFE3:
	.size	print_new_line, .-print_new_line
	.p2align 4
	.globl	print_char
	.type	print_char, @function
print_char:
.LFB4:
	.cfi_startproc
	endbr64
	movzbl	g_back_color(%rip), %eax
	movl	vga_index(%rip), %ecx
	movzbl	%dil, %edi
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	movq	%rcx, %rdx
	sall	$8, %eax
	addl	$1, %edx
	orl	%eax, %edi
	movq	vga_buffer(%rip), %rax
	movw	%di, (%rax,%rcx,2)
	movl	%edx, vga_index(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	print_char, .-print_char
	.p2align 4
	.globl	strlen
	.type	strlen, @function
strlen:
.LFB5:
	.cfi_startproc
	endbr64
	xorl	%eax, %eax
	cmpb	$0, (%rdi)
	je	.L18
	.p2align 4,,10
	.p2align 3
.L17:
	leal	1(%rax), %edx
	cmpb	$0, (%rdi,%rdx)
	movq	%rdx, %rax
	jne	.L17
	ret
	.p2align 4,,10
	.p2align 3
.L18:
	ret
	.cfi_endproc
.LFE5:
	.size	strlen, .-strlen
	.p2align 4
	.globl	digit_count
	.type	digit_count, @function
digit_count:
.LFB6:
	.cfi_startproc
	endbr64
	movl	$1, %r8d
	testl	%edi, %edi
	je	.L20
	movl	$0, %r8d
	jle	.L20
	movl	$3435973837, %edx
	.p2align 4,,10
	.p2align 3
.L22:
	movl	%edi, %edi
	addl	$1, %r8d
	movq	%rdi, %rax
	imulq	%rdx, %rdi
	shrq	$35, %rdi
	cmpl	$9, %eax
	jg	.L22
.L20:
	movl	%r8d, %eax
	ret
	.cfi_endproc
.LFE6:
	.size	digit_count, .-digit_count
	.p2align 4
	.globl	itoa
	.type	itoa, @function
itoa:
.LFB7:
	.cfi_startproc
	endbr64
	movl	%edi, %eax
	testl	%edi, %edi
	je	.L28
	jle	.L33
	movl	%edi, %edx
	xorl	%ecx, %ecx
	movl	$3435973837, %r9d
	.p2align 4,,10
	.p2align 3
.L30:
	movl	%edx, %edx
	movslq	%ecx, %r8
	addl	$1, %ecx
	movq	%rdx, %rdi
	imulq	%r9, %rdx
	shrq	$35, %rdx
	cmpl	$9, %edi
	jg	.L30
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
.L29:
	addq	%r8, %rsi
	.p2align 4,,10
	.p2align 3
.L31:
	movslq	%eax, %rdx
	movl	%eax, %edi
	subq	$1, %rsi
	imulq	$1717986919, %rdx, %rdx
	sarl	$31, %edi
	sarq	$34, %rdx
	subl	%edi, %edx
	leal	(%rdx,%rdx,4), %edi
	addl	%edi, %edi
	subl	%edi, %eax
	addl	$48, %eax
	movb	%al, 1(%rsi)
	movl	%edx, %eax
	testl	%edx, %edx
	jne	.L31
	movb	$0, (%rcx)
	ret
	.p2align 4,,10
	.p2align 3
.L28:
	movb	$0, (%rsi)
	ret
	.p2align 4,,10
	.p2align 3
.L33:
	movq	%rsi, %rcx
	movq	$-1, %r8
	jmp	.L29
	.cfi_endproc
.LFE7:
	.size	itoa, .-itoa
	.p2align 4
	.globl	print_string
	.type	print_string, @function
print_string:
.LFB8:
	.cfi_startproc
	endbr64
	movzbl	(%rdi), %edx
	testb	%dl, %dl
	je	.L36
	movq	vga_buffer(%rip), %r9
	movl	vga_index(%rip), %ecx
	xorl	%esi, %esi
	.p2align 4,,10
	.p2align 3
.L38:
	movzbl	g_back_color(%rip), %eax
	movl	%ecx, %r8d
	addl	$1, %ecx
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	sall	$8, %eax
	orl	%eax, %edx
	leal	1(%rsi), %eax
	movw	%dx, (%r9,%r8,2)
	movq	%rax, %rsi
	movl	%ecx, vga_index(%rip)
	movzbl	(%rdi,%rax), %edx
	testb	%dl, %dl
	jne	.L38
.L36:
	ret
	.cfi_endproc
.LFE8:
	.size	print_string, .-print_string
	.p2align 4
	.globl	print_int
	.type	print_int, @function
print_int:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rdx
	movq	%rdx, -8(%rbp)
	xorl	%edx, %edx
	testl	%edi, %edi
	je	.L41
	movl	%edi, %eax
	jle	.L55
	movl	%edi, %edx
	xorl	%ecx, %ecx
	movl	$3435973837, %r8d
	.p2align 4,,10
	.p2align 3
.L45:
	movl	%edx, %edx
	movl	%ecx, %edi
	addl	$1, %ecx
	movq	%rdx, %rsi
	imulq	%r8, %rdx
	shrq	$35, %rdx
	cmpl	$9, %esi
	jg	.L45
	leal	2(%rdi), %edx
	movq	%rsp, %rcx
	addq	$15, %rdx
	shrq	$4, %rdx
	salq	$4, %rdx
	movq	%rdx, %rsi
	andq	$-4096, %rsi
	subq	%rsi, %rcx
	cmpq	%rcx, %rsp
	je	.L52
.L68:
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	cmpq	%rcx, %rsp
	jne	.L68
.L52:
	andl	$4095, %edx
	subq	%rdx, %rsp
	testq	%rdx, %rdx
	je	.L53
	orq	$0, -8(%rsp,%rdx)
.L53:
	movq	%rsp, %rcx
	movl	%eax, %edx
	xorl	%edi, %edi
	movl	$3435973837, %r9d
	.p2align 4,,10
	.p2align 3
.L47:
	movl	%edx, %edx
	movslq	%edi, %rsi
	addl	$1, %edi
	movq	%rdx, %r8
	imulq	%r9, %rdx
	shrq	$35, %rdx
	cmpl	$9, %r8d
	jg	.L47
	movslq	%edi, %rdi
	addq	%rcx, %rdi
.L44:
	addq	%rcx, %rsi
	.p2align 4,,10
	.p2align 3
.L48:
	movslq	%eax, %rdx
	movl	%eax, %r8d
	subq	$1, %rsi
	imulq	$1717986919, %rdx, %rdx
	sarl	$31, %r8d
	sarq	$34, %rdx
	subl	%r8d, %edx
	leal	(%rdx,%rdx,4), %r8d
	addl	%r8d, %r8d
	subl	%r8d, %eax
	addl	$48, %eax
	movb	%al, 1(%rsi)
	movl	%edx, %eax
	testl	%edx, %edx
	jne	.L48
	movb	$0, (%rdi)
	movzbl	(%rcx), %edx
	testb	%dl, %dl
	je	.L41
	movq	vga_buffer(%rip), %r9
	movl	vga_index(%rip), %esi
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L50:
	movzbl	g_back_color(%rip), %eax
	movl	%esi, %r8d
	addl	$1, %esi
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	sall	$8, %eax
	orl	%eax, %edx
	leal	1(%rdi), %eax
	movw	%dx, (%r9,%r8,2)
	movzbl	(%rcx,%rax), %edx
	movq	%rax, %rdi
	testb	%dl, %dl
	jne	.L50
	movl	%esi, vga_index(%rip)
.L41:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L69
	leave
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L55:
	.cfi_restore_state
	leaq	-9(%rbp), %rdi
	movq	$-1, %rsi
	movq	%rdi, %rcx
	jmp	.L44
.L69:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE9:
	.size	print_int, .-print_int
	.p2align 4
	.globl	inb
	.type	inb, @function
inb:
.LFB10:
	.cfi_startproc
	endbr64
	movl	%edi, %edx
#APP
# 129 "src/kernel.c" 1
	inb %dx, %al
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE10:
	.size	inb, .-inb
	.p2align 4
	.globl	outb
	.type	outb, @function
outb:
.LFB11:
	.cfi_startproc
	endbr64
	movl	%edi, %edx
#APP
# 135 "src/kernel.c" 1
	outb %al, %dx
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE11:
	.size	outb, .-outb
	.p2align 4
	.globl	get_input_keycode
	.type	get_input_keycode, @function
get_input_keycode:
.LFB12:
	.cfi_startproc
	endbr64
	movl	$96, %edx
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L75:
	jg	.L72
.L73:
#APP
# 129 "src/kernel.c" 1
	inb %dx, %al
# 0 "" 2
#NO_APP
	testb	%al, %al
	jne	.L75
.L72:
	ret
	.cfi_endproc
.LFE12:
	.size	get_input_keycode, .-get_input_keycode
	.p2align 4
	.globl	wait_for_io
	.type	wait_for_io, @function
wait_for_io:
.LFB13:
	.cfi_startproc
	endbr64
	.p2align 4,,10
	.p2align 3
.L77:
#APP
# 151 "src/kernel.c" 1
	nop
# 0 "" 2
#NO_APP
	subl	$1, %edi
	jne	.L77
	ret
	.cfi_endproc
.LFE13:
	.size	wait_for_io, .-wait_for_io
	.p2align 4
	.globl	sleep
	.type	sleep, @function
sleep:
.LFB19:
	.cfi_startproc
	endbr64
	.p2align 4,,10
	.p2align 3
.L80:
#APP
# 151 "src/kernel.c" 1
	nop
# 0 "" 2
#NO_APP
	subl	$1, %edi
	jne	.L80
	ret
	.cfi_endproc
.LFE19:
	.size	sleep, .-sleep
	.p2align 4
	.globl	test_input
	.type	test_input, @function
test_input:
.LFB15:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%ecx, %ecx
	movl	$96, %edx
	jmp	.L83
	.p2align 4,,10
	.p2align 3
.L98:
	jg	.L84
.L83:
#APP
# 129 "src/kernel.c" 1
	inb %dx, %al
# 0 "" 2
#NO_APP
	xorl	%edi, %edi
	testb	%al, %al
	jne	.L98
.L86:
	movl	%edx, 12(%rsp)
	call	get_ascii_char@PLT
	movl	vga_index(%rip), %r8d
	movl	12(%rsp), %edx
	movzbl	%al, %edi
	movzbl	g_back_color(%rip), %eax
	movl	%edi, %ecx
	movq	%r8, %rsi
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	addl	$1, %esi
	sall	$8, %eax
	orl	%edi, %eax
	movq	vga_buffer(%rip), %rdi
	movw	%ax, (%rdi,%r8,2)
	movl	%esi, vga_index(%rip)
.L91:
	movl	$50331647, %eax
	.p2align 4,,10
	.p2align 3
.L92:
#APP
# 151 "src/kernel.c" 1
	nop
# 0 "" 2
#NO_APP
	subl	$1, %eax
	jne	.L92
	testb	%cl, %cl
	jg	.L83
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L84:
	.cfi_restore_state
	movsbl	%al, %edi
	cmpb	$28, %al
	jne	.L86
	movl	next_line_index(%rip), %eax
	cmpl	$54, %eax
	ja	.L88
	leal	(%rax,%rax,4), %esi
	addl	$1, %eax
	sall	$4, %esi
.L89:
	movl	%esi, vga_index(%rip)
	movl	%eax, next_line_index(%rip)
	jmp	.L91
.L88:
	movzbl	g_back_color(%rip), %eax
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	sall	$8, %eax
	movd	%eax, %xmm0
	movq	vga_buffer(%rip), %rax
	punpcklwd	%xmm0, %xmm0
	pshufd	$0, %xmm0, %xmm0
	leaq	4400(%rax), %rsi
	.p2align 4,,10
	.p2align 3
.L90:
	movups	%xmm0, (%rax)
	addq	$16, %rax
	cmpq	%rsi, %rax
	jne	.L90
	movl	$2, %eax
	movl	$80, %esi
	jmp	.L89
	.cfi_endproc
.LFE15:
	.size	test_input, .-test_input
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"hello world!"
	.text
	.p2align 4
	.globl	kernel_entry
	.type	kernel_entry, @function
kernel_entry:
.LFB16:
	.cfi_startproc
	endbr64
	movq	$753664, vga_buffer(%rip)
	movl	$753664, %eax
	.p2align 4,,10
	.p2align 3
.L100:
	movl	$3840, %edx
	addq	$2, %rax
	movw	%dx, -2(%rax)
	cmpq	$758064, %rax
	jne	.L100
	movl	$3944, %eax
	movl	$1, %esi
	movl	$101, %edx
	movb	$15, g_fore_color(%rip)
	movb	$0, g_back_color(%rip)
	movl	$1, %ecx
	leaq	.LC0(%rip), %rdi
	movw	%ax, 753664
	.p2align 4,,10
	.p2align 3
.L101:
	movzbl	g_back_color(%rip), %eax
	sall	$4, %eax
	orb	g_fore_color(%rip), %al
	sall	$8, %eax
	orl	%eax, %edx
	movw	%dx, 753664(%rcx,%rcx)
	leal	1(%rsi), %ecx
	movzbl	(%rdi,%rcx), %edx
	movq	%rcx, %rsi
	testb	%dl, %dl
	jne	.L101
	movl	$80, vga_index(%rip)
	xorl	%eax, %eax
	movl	$2, next_line_index(%rip)
	jmp	test_input
	.cfi_endproc
.LFE16:
	.size	kernel_entry, .-kernel_entry
	.globl	digit_ascii_codes
	.data
	.align 32
	.type	digit_ascii_codes, @object
	.size	digit_ascii_codes, 40
digit_ascii_codes:
	.long	48
	.long	49
	.long	50
	.long	51
	.long	52
	.long	53
	.long	54
	.long	55
	.long	56
	.long	57
	.globl	g_back_color
	.type	g_back_color, @object
	.size	g_back_color, 1
g_back_color:
	.byte	1
	.globl	g_fore_color
	.type	g_fore_color, @object
	.size	g_fore_color, 1
g_fore_color:
	.byte	15
	.align 4
	.type	next_line_index, @object
	.size	next_line_index, 4
next_line_index:
	.long	1
	.globl	vga_index
	.bss
	.align 4
	.type	vga_index, @object
	.size	vga_index, 4
vga_index:
	.zero	4
	.globl	vga_buffer
	.align 8
	.type	vga_buffer, @object
	.size	vga_buffer, 8
vga_buffer:
	.zero	8
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
