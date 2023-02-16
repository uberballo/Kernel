	.file	"char.c"
	.text
	.p2align 4
	.globl	get_ascii_char
	.type	get_ascii_char, @function
get_ascii_char:
.LFB0:
	.cfi_startproc
	endbr64
	subl	$2, %edi
	xorl	%eax, %eax
	cmpb	$55, %dil
	ja	.L1
	movzbl	%dil, %edi
	leaq	CSWTCH.1(%rip), %rax
	movzbl	(%rax,%rdi), %eax
.L1:
	ret
	.cfi_endproc
.LFE0:
	.size	get_ascii_char, .-get_ascii_char
	.section	.rodata
	.align 32
	.type	CSWTCH.1, @object
	.size	CSWTCH.1, 56
CSWTCH.1:
	.byte	49
	.byte	50
	.byte	51
	.byte	52
	.byte	53
	.byte	54
	.byte	55
	.byte	56
	.byte	57
	.byte	48
	.byte	45
	.byte	61
	.byte	0
	.byte	0
	.byte	81
	.byte	87
	.byte	69
	.byte	82
	.byte	84
	.byte	89
	.byte	85
	.byte	73
	.byte	79
	.byte	80
	.byte	91
	.byte	93
	.byte	0
	.byte	0
	.byte	65
	.byte	83
	.byte	68
	.byte	70
	.byte	71
	.byte	72
	.byte	74
	.byte	75
	.byte	76
	.byte	59
	.byte	0
	.byte	0
	.byte	0
	.byte	92
	.byte	90
	.byte	88
	.byte	67
	.byte	86
	.byte	66
	.byte	78
	.byte	77
	.byte	44
	.byte	46
	.byte	47
	.byte	0
	.byte	0
	.byte	0
	.byte	32
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
