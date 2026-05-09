	.file	"mpi_1d.cpp"
	.text
	.p2align 4,,15
	.globl	_Z5sobelPKhiPfS1_ii
	.type	_Z5sobelPKhiPfS1_ii, @function
_Z5sobelPKhiPfS1_ii:
.LFB2626:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movl	%r8d, 24(%rsp)
	movl	%r9d, 28(%rsp)
	cmpl	%r9d, %r8d
	jge	.L7
	cmpl	$2, %esi
	jle	.L7
	movslq	%esi, %r13
	movl	%r8d, %r12d
	leal	-1(%r8), %r14d
	leaq	-8(,%r13,4), %rax
	imull	%esi, %r12d
	movq	%rax, 32(%rsp)
	leal	-2(%rsi), %eax
	imull	%r14d, %eax
	movslq	%r12d, %r12
	subq	%r13, %r12
	cltq
	addq	%rdi, %r12
	salq	$2, %rax
	leaq	(%rdx,%rax), %rdi
	leal	-3(%rsi), %edx
	addq	%rcx, %rax
	incq	%rdx
	movq	%rdi, 16(%rsp)
	movq	%rax, 8(%rsp)
	movq	%rdx, 40(%rsp)
	.p2align 4,,15
.L4:
	movq	40(%rsp), %rcx
	movq	%r12, %rbx
	movq	8(%rsp), %r15
	movq	16(%rsp), %r14
	leaq	(%rcx,%r12), %rbp
	.p2align 4,,15
.L3:
	movzbl	2(%rbx), %r8d
	movzbl	(%rbx), %r9d
	vxorps	%xmm0, %xmm0, %xmm0
	addq	$4, %r14
	movzbl	1(%rbx), %ecx
	movzbl	(%rbx,%r13), %eax
	addq	$4, %r15
	movzbl	(%rbx,%r13,2), %r10d
	movzbl	2(%rbx,%r13), %edi
	movzbl	2(%rbx,%r13,2), %esi
	movl	%r8d, %r11d
	subl	%r9d, %r11d
	addl	%ecx, %ecx
	negl	%r9d
	addl	%eax, %eax
	subl	%ecx, %r9d
	subl	%eax, %r11d
	subl	%r8d, %r9d
	movzbl	1(%rbx,%r13,2), %r8d
	leal	(%r11,%rdi,2), %edx
	incq	%rbx
	addl	%r10d, %r9d
	subl	%r10d, %edx
	addl	%esi, %edx
	movl	%edx, %r10d
	leal	(%r9,%r8,2), %r9d
	imull	%edx, %r10d
	addl	%esi, %r9d
	movl	%r9d, %esi
	imull	%r9d, %esi
	addl	%esi, %r10d
	vcvtsi2ss	%r10d, %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm1, %xmm1
	vxorps	%xmm0, %xmm0, %xmm0
	vmovss	%xmm1, -4(%r14)
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2ss	%r9d, %xmm0, %xmm0
	vcvtsi2ss	%edx, %xmm1, %xmm1
	call	atan2f
	vmovss	%xmm0, -4(%r15)
	cmpq	%rbx, %rbp
	jne	.L3
	incl	24(%rsp)
	addq	%r13, %r12
	movq	32(%rsp), %r15
	movl	24(%rsp), %ebp
	addq	%r15, 16(%rsp)
	addq	%r15, 8(%rsp)
	cmpl	%ebp, 28(%rsp)
	jne	.L4
.L7:
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE2626:
	.size	_Z5sobelPKhiPfS1_ii, .-_Z5sobelPKhiPfS1_ii
	.p2align 4,,15
	.globl	_Z5sobelPKhiPfS1_iiii
	.type	_Z5sobelPKhiPfS1_iiii, @function
_Z5sobelPKhiPfS1_iiii:
.LFB2627:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%r9d, %eax
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%r8d, %ebx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	%r8d, 32(%rsp)
	movl	%r9d, 36(%rsp)
	movl	144(%rsp), %r8d
	movl	152(%rsp), %r9d
	cmpl	%eax, %ebx
	jge	.L16
	cmpl	%r9d, %r8d
	jge	.L16
	movl	%ebx, %eax
	movslq	%esi, %r11
	leal	-2(%rsi), %r13d
	movslq	%r8d, %r10
	imull	%esi, %eax
	leal	-1(%rbx), %esi
	leal	-1(%r9), %ebx
	movq	$-2, %r9
	imull	%r13d, %esi
	subl	%r8d, %ebx
	leaq	-8(,%r11,4), %r12
	subq	%r11, %r9
	incq	%rbx
	movq	%r11, 48(%rsp)
	movq	%r12, 40(%rsp)
	cltq
	movq	%r9, 56(%rsp)
	movq	%rbx, 64(%rsp)
	movslq	%esi, %r14
	leaq	1(%r10,%rax), %rbp
	addq	%r10, %r14
	leaq	(%rdi,%rbp), %rdi
	leaq	-4(,%r14,4), %r15
	movq	%rdi, 24(%rsp)
	leaq	(%rdx,%r15), %rdx
	addq	%rcx, %r15
	leaq	-1(%r11), %rcx
	movq	%rdx, 16(%rsp)
	movq	%r15, 8(%rsp)
	movq	%rcx, 72(%rsp)
	.p2align 4,,15
.L13:
	movq	24(%rsp), %r14
	movq	72(%rsp), %rbp
	movq	56(%rsp), %r15
	movq	64(%rsp), %rbx
	movq	8(%rsp), %r13
	movq	16(%rsp), %r12
	addq	%r14, %rbp
	addq	%r14, %r15
	addq	%r14, %rbx
	.p2align 4,,15
.L12:
	movzbl	2(%r15), %r8d
	movzbl	(%r15), %r10d
	vxorps	%xmm0, %xmm0, %xmm0
	incq	%r14
	movzbl	1(%r15), %ecx
	movzbl	-3(%r14), %esi
	incq	%rbp
	addq	$4, %r12
	movzbl	-2(%rbp), %eax
	movzbl	-1(%r14), %edx
	addq	$4, %r13
	incq	%r15
	movzbl	0(%rbp), %edi
	movl	%r8d, %r11d
	subl	%r10d, %r11d
	addl	%ecx, %ecx
	negl	%r10d
	addl	%esi, %esi
	subl	%ecx, %r10d
	subl	%esi, %r11d
	subl	%r8d, %r10d
	movzbl	-1(%rbp), %r8d
	leal	(%r11,%rdx,2), %r9d
	addl	%eax, %r10d
	subl	%eax, %r9d
	addl	%edi, %r9d
	movl	%r9d, %eax
	leal	(%r10,%r8,2), %r10d
	imull	%r9d, %eax
	addl	%edi, %r10d
	movl	%r10d, %edi
	imull	%r10d, %edi
	addl	%edi, %eax
	vcvtsi2ss	%eax, %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm1, %xmm1
	vxorps	%xmm0, %xmm0, %xmm0
	vmovss	%xmm1, -4(%r12)
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2ss	%r10d, %xmm0, %xmm0
	vcvtsi2ss	%r9d, %xmm1, %xmm1
	call	atan2f
	vmovss	%xmm0, -4(%r13)
	cmpq	%r14, %rbx
	jne	.L12
	incl	32(%rsp)
	movq	40(%rsp), %r15
	movq	48(%rsp), %r14
	movl	32(%rsp), %ebp
	addq	%r14, 24(%rsp)
	addq	%r15, 16(%rsp)
	addq	%r15, 8(%rsp)
	cmpl	%ebp, 36(%rsp)
	jne	.L13
.L16:
	addq	$88, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE2627:
	.size	_Z5sobelPKhiPfS1_iiii, .-_Z5sobelPKhiPfS1_iiii
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.p2align 4,,15
	.weak	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.type	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, @function
_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_:
.LFB2696:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2696
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r15
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdx, %rbp
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movl	%r8d, 12(%rsp)
	call	__errno_location
	movl	12(%rsp), %edx
	leaq	24(%rsp), %rsi
	movl	(%rax), %r13d
	movq	%rax, %rbx
	movl	$0, (%rax)
	movq	%rbp, %rdi
.LEHB0:
	call	*%r15
	movq	24(%rsp), %r8
	cmpq	%rbp, %r8
	je	.L35
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L20
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L20
	testq	%r12, %r12
	je	.L22
	subq	%rbp, %r8
	movq	%r8, (%r12)
.L22:
	testl	%esi, %esi
	jne	.L33
	movl	%r13d, (%rbx)
.L33:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L20:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZSt20__throw_out_of_rangePKc
.LEHE0:
.L26:
	cmpl	$0, (%rbx)
	jne	.L25
	movl	%r13d, (%rbx)
.L25:
	movq	%rax, %rdi
	vzeroupper
.LEHB1:
	call	_Unwind_Resume
.LEHE1:
.L35:
	movq	%r14, %rdi
.LEHB2:
	call	_ZSt24__throw_invalid_argumentPKc
.LEHE2:
	.cfi_endproc
.LFE2696:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"aG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
.LLSDA2696:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2696-.LLSDACSB2696
.LLSDACSB2696:
	.uleb128 .LEHB0-.LFB2696
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L26-.LFB2696
	.uleb128 0
	.uleb128 .LEHB1-.LFB2696
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB2696
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L26-.LFB2696
	.uleb128 0
.LLSDACSE2696:
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.size	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, .-_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.section	.rodata._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"basic_string::_M_construct null not valid"
	.section	.text._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_,"axG",@progbits,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC5EPKcRKS3_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_, @function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_:
.LFB2918:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	leaq	16(%rdi), %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%r12, (%rdi)
	testq	%rsi, %rsi
	je	.L37
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movq	%rsi, %r13
	call	strlen
	movq	%rax, %rbx
	cmpq	$15, %rax
	ja	.L48
	cmpq	$1, %rax
	je	.L49
	testq	%rax, %rax
	jne	.L40
.L42:
	movq	%rbx, 8(%rbp)
	movb	$0, (%r12,%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,15
.L49:
	.cfi_restore_state
	movzbl	0(%r13), %eax
	movb	%al, 16(%rbp)
	jmp	.L42
	.p2align 4,,15
.L48:
	leaq	1(%rax), %rdi
	call	_Znwm
	movq	%rbx, 16(%rbp)
	movq	%rax, %r12
	movq	%rax, 0(%rbp)
.L40:
	movq	%r12, %rdi
	movq	%rbx, %rdx
	movq	%r13, %rsi
	call	memcpy
	movq	0(%rbp), %r12
	jmp	.L42
.L37:
	movl	$.LC0, %edi
	call	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE2918:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_, .-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
	.set	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.section	.text._ZNSt6vectorIfSaIfEEC2EmRKfRKS0_,"axG",@progbits,_ZNSt6vectorIfSaIfEEC5EmRKfRKS0_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_
	.type	_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_, @function
_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_:
.LFB2939:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	vxorps	%xmm0, %xmm0, %xmm0
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	vmovups	%xmm0, (%rdi)
	movq	$0, 16(%rdi)
	testq	%rsi, %rsi
	je	.L51
	movabsq	$4611686018427387903, %rax
	movq	%rsi, %rbp
	cmpq	%rax, %rsi
	ja	.L122
	leaq	0(,%rsi,4), %r12
	movq	%rdx, %r13
	movq	%r12, %rdi
	call	_Znwm
	movl	$4, %r9d
	leaq	-1(%rbp), %rsi
	vmovss	0(%r13), %xmm1
	movq	%rax, %rdx
	leaq	(%rax,%r12), %rdi
	movq	%rax, (%rbx)
	shrq	$2, %rdx
	movq	%rdi, 16(%rbx)
	movq	%rsi, %r8
	negq	%rdx
	andl	$3, %edx
	leaq	3(%rdx), %rcx
	cmpq	$4, %rcx
	cmovb	%r9, %rcx
	cmpq	%rcx, %rsi
	jb	.L53
	testq	%rdx, %rdx
	je	.L59
	vmovss	%xmm1, (%rax)
	leaq	4(%rax), %r10
	cmpq	$1, %rdx
	je	.L54
	vmovss	%xmm1, 4(%rax)
	leaq	-2(%rbp), %r8
	leaq	8(%rax), %r10
	cmpq	$2, %rdx
	je	.L54
	vmovss	%xmm1, 8(%rax)
	leaq	-3(%rbp), %r8
	leaq	12(%rax), %r10
.L54:
	movq	%rbp, %r12
	leaq	(%rax,%rdx,4), %r11
	vshufps	$0, %xmm1, %xmm1, %xmm2
	movl	$1, %ebp
	subq	%rdx, %r12
	vmovaps	%xmm2, (%r11)
	leaq	16(%r11), %r13
	leaq	-4(%r12), %rsi
	shrq	$2, %rsi
	leaq	1(%rsi), %rax
	andl	$7, %esi
	cmpq	%rax, %rbp
	jnb	.L118
	testq	%rsi, %rsi
	je	.L56
	cmpq	$1, %rsi
	je	.L98
	cmpq	$2, %rsi
	je	.L99
	cmpq	$3, %rsi
	je	.L100
	cmpq	$4, %rsi
	je	.L101
	cmpq	$5, %rsi
	je	.L102
	cmpq	$6, %rsi
	je	.L103
	vmovaps	%xmm2, 0(%r13)
	movl	$2, %ebp
	leaq	32(%r11), %r13
.L103:
	vmovaps	%xmm2, 0(%r13)
	incq	%rbp
	addq	$16, %r13
.L102:
	vmovaps	%xmm2, 0(%r13)
	incq	%rbp
	addq	$16, %r13
.L101:
	vmovaps	%xmm2, 0(%r13)
	incq	%rbp
	addq	$16, %r13
.L100:
	vmovaps	%xmm2, 0(%r13)
	incq	%rbp
	addq	$16, %r13
.L99:
	vmovaps	%xmm2, 0(%r13)
	incq	%rbp
	addq	$16, %r13
.L98:
	incq	%rbp
	vmovaps	%xmm2, 0(%r13)
	addq	$16, %r13
	cmpq	%rax, %rbp
	jnb	.L118
.L56:
	addq	$8, %rbp
	vmovaps	%xmm2, 0(%r13)
	vmovaps	%xmm2, 16(%r13)
	subq	$-128, %r13
	vmovaps	%xmm2, -96(%r13)
	vmovaps	%xmm2, -80(%r13)
	vmovaps	%xmm2, -64(%r13)
	vmovaps	%xmm2, -48(%r13)
	vmovaps	%xmm2, -32(%r13)
	vmovaps	%xmm2, -16(%r13)
	cmpq	%rax, %rbp
	jb	.L56
.L118:
	leaq	0(,%rax,4), %rdx
	salq	$4, %rax
	subq	%rdx, %r8
	addq	%r10, %rax
	movq	%r8, %rbp
	cmpq	%rdx, %r12
	je	.L58
	leaq	-1(%r8), %rsi
.L53:
	vmovss	%xmm1, (%rax)
	testq	%rsi, %rsi
	je	.L58
	vmovss	%xmm1, 4(%rax)
	cmpq	$2, %rbp
	je	.L58
	vmovss	%xmm1, 8(%rax)
	cmpq	$3, %rbp
	je	.L58
	vmovss	%xmm1, 12(%rax)
	cmpq	$4, %rbp
	je	.L58
	vmovss	%xmm1, 16(%rax)
	cmpq	$5, %rbp
	je	.L58
	vmovss	%xmm1, 20(%rax)
.L58:
	movq	%rdi, 8(%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,15
.L59:
	.cfi_restore_state
	movq	%rax, %r10
	movq	%rbp, %r8
	jmp	.L54
	.p2align 4,,15
.L51:
	xorl	%edi, %edi
	jmp	.L58
.L122:
	call	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE2939:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_, .-_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_
	.weak	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_
	.set	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_,_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"stoi"
.LC3:
	.string	"Setup"
.LC4:
	.string	"Read file"
.LC5:
	.string	"Send requests"
.LC6:
	.string	"Local comp"
.LC7:
	.string	"Wait on resps"
.LC8:
	.string	"Compute received"
.LC9:
	.string	"Write out"
.LC10:
	.string	"Total"
.LC11:
	.string	"Avg(s)"
.LC12:
	.string	"Max(s)"
.LC13:
	.string	"Min(s)"
.LC14:
	.string	"Section"
.LC15:
	.string	"%-20s;%10s;%10s;%10s\n"
.LC16:
	.string	"%-20s;%10.6f;%10.6f;%10.6f\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB2629:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2629
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$520, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, -484(%rbp)
	movq	%rsi, -496(%rbp)
	leaq	-484(%rbp), %rdi
	leaq	-496(%rbp), %rsi
.LEHB3:
	call	MPI_Init
	movl	$1140850688, %edi
	call	MPI_Barrier
	call	MPI_Wtime
	leaq	-476(%rbp), %rsi
	movl	$1140850688, %edi
	vmovsd	%xmm0, -520(%rbp)
	call	MPI_Comm_rank
	leaq	-472(%rbp), %rsi
	movl	$1140850688, %edi
	call	MPI_Comm_size
	leaq	-176(%rbp), %rdx
	leaq	-112(%rbp), %rdi
	movq	-496(%rbp), %rax
	movq	24(%rax), %rsi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
.LEHE3:
	movq	-112(%rbp), %rdx
	movl	$10, %r8d
	xorl	%ecx, %ecx
	movl	$.LC1, %esi
	movl	$__isoc23_strtol, %edi
.LEHB4:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE4:
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rdx
	movl	%eax, -488(%rbp)
	addq	$16, %rdx
	cmpq	%rdx, %rdi
	je	.L124
	call	_ZdlPv
.L124:
	movq	-496(%rbp), %rcx
	leaq	-176(%rbp), %rdx
	leaq	-112(%rbp), %rdi
	movq	32(%rcx), %rsi
.LEHB5:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
.LEHE5:
	movq	-112(%rbp), %rdx
	movl	$10, %r8d
	xorl	%ecx, %ecx
	movl	$.LC1, %esi
	movl	$__isoc23_strtol, %edi
.LEHB6:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE6:
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rbx
	movl	%eax, %r13d
	addq	$16, %rbx
	cmpq	%rbx, %rdi
	je	.L125
	call	_ZdlPv
.L125:
	movl	-488(%rbp), %eax
	movl	-488(%rbp), %edi
	movl	$1431655766, %esi
	movl	-472(%rbp), %ebx
	movl	-476(%rbp), %r9d
	imull	%esi
	movl	%edi, %r8d
	movl	%edi, %eax
	sarl	$31, %r8d
	movl	%r9d, -504(%rbp)
	subl	%r8d, %edx
	cmpl	%ebx, %edx
	cmovle	%edx, %ebx
	cltd
	idivl	%ebx
	movl	%eax, -528(%rbp)
	cmpl	%ebx, %r9d
	jge	.L126
	xorl	%r12d, %r12d
	cmpl	%edx, %r9d
	movl	%r9d, %r14d
	setl	%r12b
	imull	%eax, %r14d
	addl	%eax, %r12d
	cmpl	%edx, %r9d
	leal	2(%r12), %r11d
	cmovle	%r9d, %edx
	imull	%r13d, %r11d
	leal	(%r14,%rdx), %r10d
	movl	%r10d, -524(%rbp)
	movslq	%r11d, %r15
	testq	%r15, %r15
	je	.L165
	movq	%r15, %rdi
.LEHB7:
	call	_Znwm
.LEHE7:
	movq	%r15, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, -512(%rbp)
	call	memset
	jmp	.L127
.L126:
	movq	$0, -512(%rbp)
	movl	$0, -524(%rbp)
	xorl	%r12d, %r12d
.L127:
	leal	-2(%r13), %r15d
	leaq	-176(%rbp), %rcx
	leaq	-112(%rbp), %rdx
	leaq	-432(%rbp), %rdi
	movl	%r15d, -544(%rbp)
	imull	%r12d, %r15d
	movl	$0x7fc00000, -112(%rbp)
	movslq	%r15d, %r14
	movq	%r14, %rsi
.LEHB8:
	call	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_
.LEHE8:
	leaq	-176(%rbp), %rcx
	leaq	-112(%rbp), %rdx
	movq	%r14, %rsi
	leaq	-400(%rbp), %rdi
	movl	$0x7fc00000, -112(%rbp)
.LEHB9:
	call	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_
.LEHE9:
.LEHB10:
	call	MPI_Wtime
	vsubsd	-520(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -368(%rbp)
	call	MPI_Wtime
	movq	-496(%rbp), %rcx
	leaq	-456(%rbp), %r8
	movl	$2, %edx
	movl	$1140850688, %edi
	vmovsd	%xmm0, -536(%rbp)
	movq	8(%rcx), %rsi
	movl	$469762048, %ecx
	call	MPI_File_open
	leal	(%r12,%r12), %ecx
	cmpl	%ebx, -504(%rbp)
	jge	.L130
	movq	-512(%rbp), %rdx
	movslq	-524(%rbp), %rsi
	movslq	%r13d, %rdi
	addl	%r15d, %ecx
	movl	$1, %r9d
	movl	$1275068731, %r8d
	addq	%rdi, %rdx
	imulq	%rdi, %rsi
	movq	-456(%rbp), %rdi
	call	MPI_File_read_at
.L130:
	leaq	-456(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-536(%rbp), %xmm0, %xmm1
	vmovsd	%xmm1, -360(%rbp)
	call	MPI_Wtime
	vmovsd	%xmm0, -536(%rbp)
	cmpl	%ebx, -504(%rbp)
	jge	.L166
	movl	-476(%rbp), %r15d
	xorl	%r14d, %r14d
	leal	1(%r15), %esi
	decl	%r15d
	movl	%esi, -540(%rbp)
	jns	.L212
.L132:
	cmpl	%ebx, -540(%rbp)
	jl	.L213
.L131:
	call	MPI_Wtime
	vsubsd	-536(%rbp), %xmm0, %xmm2
	vmovsd	%xmm2, -352(%rbp)
	call	MPI_Wtime
	vmovsd	%xmm0, -536(%rbp)
	cmpl	$2, %r12d
	jle	.L133
	cmpl	%ebx, -504(%rbp)
	jl	.L214
.L133:
	call	MPI_Wtime
	vsubsd	-536(%rbp), %xmm0, %xmm3
	vmovsd	%xmm3, -344(%rbp)
	call	MPI_Wtime
	movl	$1, %edx
	leaq	-448(%rbp), %rsi
	movl	%r14d, %edi
	vmovsd	%xmm0, -536(%rbp)
	call	MPI_Waitall
	call	MPI_Wtime
	vsubsd	-536(%rbp), %xmm0, %xmm4
	vmovsd	%xmm4, -336(%rbp)
	call	MPI_Wtime
	vmovsd	%xmm0, -536(%rbp)
	cmpl	%ebx, -504(%rbp)
	jge	.L135
	cmpl	$0, -476(%rbp)
	jg	.L215
.L136:
	movl	-476(%rbp), %edi
	incl	%edi
	cmpl	%ebx, %edi
	jl	.L216
.L135:
	call	MPI_Wtime
	vsubsd	-536(%rbp), %xmm0, %xmm5
	vmovsd	%xmm5, -328(%rbp)
	call	MPI_Wtime
	movq	-496(%rbp), %r13
	leaq	-456(%rbp), %r8
	movl	$469762048, %ecx
	movl	$5, %edx
	movl	$1140850688, %edi
	vmovsd	%xmm0, -536(%rbp)
	movq	16(%r13), %rsi
	call	MPI_File_open
	cmpl	%ebx, -504(%rbp)
	jge	.L143
	movl	-476(%rbp), %r12d
	movslq	-544(%rbp), %r13
	leal	1(%r12), %r14d
	testl	%r12d, %r12d
	je	.L217
	cmpl	%ebx, %r14d
	je	.L218
	movslq	-528(%rbp), %r12
	imulq	%r13, %r12
.L163:
	movl	-524(%rbp), %eax
	leaq	0(,%r13,4), %r14
	movq	-432(%rbp), %rdx
	xorl	%r10d, %r10d
	decl	%eax
	cltq
	imulq	%rax, %r14
.L161:
	movq	-400(%rbp), %r15
	movq	-456(%rbp), %rdi
	addq	%r10, %rdx
	movl	$1, %r9d
	movl	$1275069450, %r8d
	movl	%r12d, %ecx
	movq	%r14, %rsi
	addq	%r10, %r15
	call	MPI_File_write_at
	movl	-488(%rbp), %eax
	movq	-456(%rbp), %rdi
	movl	$1, %r9d
	movl	$1275069450, %r8d
	movl	%r12d, %ecx
	movq	%r15, %rdx
	subl	$2, %eax
	cltq
	imulq	%rax, %r13
	leaq	(%r14,%r13,4), %rsi
	call	MPI_File_write_at
.L143:
	leaq	-456(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-536(%rbp), %xmm0, %xmm6
	movl	$1140850688, %edi
	vmovsd	%xmm6, -320(%rbp)
	call	MPI_Barrier
	call	MPI_Wtime
	vsubsd	-520(%rbp), %xmm0, %xmm7
	movl	-504(%rbp), %r13d
	movl	$0, %edx
	movl	$-32766, %esi
	leaq	-468(%rbp), %rcx
	movl	$1140850688, %edi
	cmpl	%ebx, %r13d
	cmovl	%edx, %esi
	movl	-476(%rbp), %edx
	vmovsd	%xmm7, -312(%rbp)
	call	MPI_Comm_split
	cmpl	%ebx, %r13d
	jge	.L145
	movl	-468(%rbp), %edi
	leaq	-464(%rbp), %rsi
	call	MPI_Comm_size
	movl	-468(%rbp), %r11d
	subq	$8, %rsp
	xorl	%r9d, %r9d
	movl	$1476395010, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	leaq	-304(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	pushq	%r11
	.cfi_escape 0x2e,0x10
	call	MPI_Reduce
	movl	-468(%rbp), %ecx
	xorl	%r9d, %r9d
	movl	$1476395009, %r8d
	movl	$8, %edx
	leaq	-240(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	movl	%ecx, (%rsp)
	movl	$1275070475, %ecx
	call	MPI_Reduce
	movl	-468(%rbp), %edi
	xorl	%r9d, %r9d
	movl	$1476395011, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	leaq	-176(%rbp), %rsi
	movl	%edi, (%rsp)
	leaq	-368(%rbp), %rdi
	call	MPI_Reduce
	popq	%rax
	movl	-468(%rbp), %edi
	leaq	-460(%rbp), %rsi
	popq	%rdx
	.cfi_escape 0x2e,0
	call	MPI_Comm_rank
	cmpl	$0, -460(%rbp)
	je	.L219
.L146:
	leaq	-468(%rbp), %rdi
	call	MPI_Comm_free
.L145:
	call	MPI_Finalize
	movq	-400(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L148
	call	_ZdlPv
.L148:
	movq	-432(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L149
	call	_ZdlPv
.L149:
	movq	-512(%rbp), %r10
	testq	%r10, %r10
	je	.L206
	movq	%r10, %rdi
	call	_ZdlPv
.L206:
	leaq	-40(%rbp), %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L217:
	.cfi_restore_state
	movl	-528(%rbp), %r8d
	leal	-1(%r8), %r9d
	cmpl	$1, %ebx
	jne	.L208
	movl	-528(%rbp), %r9d
	subl	$2, %r9d
.L208:
	movslq	-524(%rbp), %r14
	movslq	%r9d, %r12
	leaq	0(,%r13,4), %r10
	movq	-432(%rbp), %rdx
	imulq	%r13, %r12
	imulq	%r10, %r14
	jmp	.L161
.L212:
	movq	-512(%rbp), %rdi
	subq	$8, %rsp
	leaq	-448(%rbp), %r14
	movl	$1140850688, %r9d
	pushq	%r14
	movl	$1, %r8d
	movl	%r15d, %ecx
	movl	$1275068731, %edx
	movl	%r13d, %esi
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	movslq	%r13d, %rdi
	addq	-512(%rbp), %rdi
	addq	$4, %r14
	movl	$1140850688, %r9d
	xorl	%r8d, %r8d
	movl	%r15d, %ecx
	movl	$1275068731, %edx
	movl	%r13d, %esi
	movq	%r14, (%rsp)
	call	MPI_Isend
	popq	%rax
	movl	$2, %r14d
	popq	%rdx
	jmp	.L132
.L219:
	movq	$.LC3, -504(%rbp)
	movl	$.LC4, %esi
	movl	$.LC8, %r8d
	movl	$.LC6, %ebx
	vmovq	-504(%rbp), %xmm8
	movq	$.LC5, -504(%rbp)
	movl	$.LC10, %r9d
	vpinsrq	$1, %rsi, %xmm8, %xmm9
	vmovq	-504(%rbp), %xmm10
	movq	$.LC7, -504(%rbp)
	vpinsrq	$1, %rbx, %xmm10, %xmm11
	movl	$.LC12, %ecx
	vmovq	-504(%rbp), %xmm12
	movq	$.LC9, -504(%rbp)
	vpinsrq	$1, %r8, %xmm12, %xmm13
	movl	$.LC13, %edx
	vmovq	-504(%rbp), %xmm14
	movl	$.LC11, %r8d
	vpinsrq	$1, %r9, %xmm14, %xmm15
	movl	$.LC14, %esi
	movl	$.LC15, %edi
	xorl	%eax, %eax
	vmovaps	%xmm9, -112(%rbp)
	vmovaps	%xmm11, -96(%rbp)
	vmovaps	%xmm13, -80(%rbp)
	vmovaps	%xmm15, -64(%rbp)
	.cfi_escape 0x2e,0
	call	printf
	xorl	%r12d, %r12d
	.p2align 4,,15
.L147:
	vmovsd	-176(%rbp,%r12), %xmm1
	vxorps	%xmm0, %xmm0, %xmm0
	vmovsd	-304(%rbp,%r12), %xmm3
	movl	$.LC16, %edi
	vcvtsi2sd	-464(%rbp), %xmm0, %xmm0
	movq	-112(%rbp,%r12), %rsi
	movl	$3, %eax
	vdivsd	%xmm0, %xmm1, %xmm2
	vmovsd	-240(%rbp,%r12), %xmm1
	vmovaps	%xmm3, %xmm0
	vmovsd	%xmm3, -504(%rbp)
	call	printf
	addq	$8, %r12
	cmpq	$64, %r12
	jne	.L147
	jmp	.L146
.L215:
	leal	-1(%r13), %ecx
	movq	-512(%rbp), %rdi
	movq	-432(%rbp), %rdx
	movl	$1, %r8d
	pushq	%rcx
	movq	-400(%rbp), %rcx
	movl	$2, %r9d
	movl	%r13d, %esi
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L136
.L213:
	leal	1(%r12), %r8d
	movslq	%r14d, %r15
	movl	-540(%rbp), %ecx
	leaq	-448(%rbp), %r9
	imull	%r13d, %r8d
	salq	$2, %r15
	subq	$8, %rsp
	movl	$1275068731, %edx
	leaq	(%r9,%r15), %rax
	movl	%r13d, %esi
	movl	$1140850688, %r9d
	pushq	%rax
	movslq	%r8d, %rdi
	addq	-512(%rbp), %rdi
	movl	%r8d, -548(%rbp)
	xorl	%r8d, %r8d
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	movl	-548(%rbp), %edx
	movl	-540(%rbp), %ecx
	leaq	-444(%rbp,%r15), %r10
	movl	$1140850688, %r9d
	movl	$1, %r8d
	movl	%r13d, %esi
	addl	$2, %r14d
	movq	%r10, (%rsp)
	subl	%r13d, %edx
	movslq	%edx, %rdi
	addq	-512(%rbp), %rdi
	movl	$1275068731, %edx
	call	MPI_Isend
.LEHE10:
	popq	%r11
	popq	%r15
	jmp	.L131
.L166:
	xorl	%r14d, %r14d
	jmp	.L131
.L165:
	movq	$0, -512(%rbp)
	jmp	.L127
.L216:
	movq	-400(%rbp), %rcx
	movq	-432(%rbp), %rdx
	leal	-1(%r13), %esi
	leal	1(%r12), %r9d
	movq	-512(%rbp), %rdi
	pushq	%rsi
	leal	-1(%r12), %r8d
	movl	%r13d, %esi
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
	jmp	.L135
.L214:
	movq	-400(%rbp), %rcx
	movq	-432(%rbp), %rdx
	leal	-1(%r13), %r11d
	movl	%r12d, %r9d
	movq	-512(%rbp), %rdi
	pushq	%r11
	movl	$2, %r8d
	movl	%r13d, %esi
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L133
.L173:
	movq	-400(%rbp), %rdi
	movq	%rax, %r14
	testq	%rdi, %rdi
	je	.L205
	vzeroupper
	call	_ZdlPv
.L157:
	movq	-432(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L159
	call	_ZdlPv
.L159:
	movq	-512(%rbp), %r15
	testq	%r15, %r15
	je	.L160
	movq	%r15, %rdi
	call	_ZdlPv
.L160:
	movq	%r14, %rdi
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L205:
	vzeroupper
	jmp	.L157
.L172:
	movq	%rax, %r14
	vzeroupper
	jmp	.L157
.L171:
	movq	%rax, %r14
	vzeroupper
	jmp	.L159
.L169:
.L211:
	movq	-112(%rbp), %rdi
	movq	%rax, %r14
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L204
	vzeroupper
	call	_ZdlPv
	jmp	.L160
.L218:
	movl	-528(%rbp), %r15d
	decl	%r15d
	movslq	%r15d, %r12
	imulq	%r13, %r12
	jmp	.L163
.L170:
	jmp	.L211
.L204:
	vzeroupper
	jmp	.L160
	.cfi_endproc
.LFE2629:
	.section	.gcc_except_table,"a",@progbits
.LLSDA2629:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2629-.LLSDACSB2629
.LLSDACSB2629:
	.uleb128 .LEHB3-.LFB2629
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB4-.LFB2629
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L169-.LFB2629
	.uleb128 0
	.uleb128 .LEHB5-.LFB2629
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB2629
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L170-.LFB2629
	.uleb128 0
	.uleb128 .LEHB7-.LFB2629
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB8-.LFB2629
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L171-.LFB2629
	.uleb128 0
	.uleb128 .LEHB9-.LFB2629
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L172-.LFB2629
	.uleb128 0
	.uleb128 .LEHB10-.LFB2629
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L173-.LFB2629
	.uleb128 0
	.uleb128 .LEHB11-.LFB2629
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
.LLSDACSE2629:
	.section	.text.startup
	.size	main, .-main
	.p2align 4,,15
	.type	_GLOBAL__sub_I__Z5sobelPKhiPfS1_ii, @function
_GLOBAL__sub_I__Z5sobelPKhiPfS1_ii:
.LFB3386:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$_ZStL8__ioinit, %edi
	call	_ZNSt8ios_base4InitC1Ev
	movl	$__dso_handle, %edx
	movl	$_ZStL8__ioinit, %esi
	movl	$_ZNSt8ios_base4InitD1Ev, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__cxa_atexit
	.cfi_endproc
.LFE3386:
	.size	_GLOBAL__sub_I__Z5sobelPKhiPfS1_ii, .-_GLOBAL__sub_I__Z5sobelPKhiPfS1_ii
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__Z5sobelPKhiPfS1_ii
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.hidden	__dso_handle
	.ident	"GCC: (SUSE Linux) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
