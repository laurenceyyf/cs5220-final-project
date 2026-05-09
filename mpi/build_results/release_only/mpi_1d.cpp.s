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
	cmpl	%r9d, %r8d
	movl	%r9d, 32(%rsp)
	jge	.L1
	cmpl	$2, %esi
	jle	.L1
	leaq	1(%rdi), %rbp
	movl	%r8d, %eax
	movslq	%esi, %r15
	leal	-3(%rsi), %r9d
	movl	%r8d, %r12d
	movq	%rbp, %rdi
	imull	%esi, %eax
	subq	%r15, %rdi
	leaq	(%rdi,%r9), %rbp
	notq	%r9
	movq	%r9, 24(%rsp)
	cltq
	addq	%rax, %rbp
	leaq	-8(,%r15,4), %rax
	movq	%rax, 16(%rsp)
	leal	-2(%rsi), %eax
	leal	-1(%r8), %esi
	imull	%esi, %eax
	cltq
	salq	$2, %rax
	leaq	(%rdx,%rax), %rdi
	addq	%rcx, %rax
	movq	%rax, (%rsp)
	movq	%rdi, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L7:
	movq	24(%rsp), %rax
	movq	(%rsp), %r14
	movq	8(%rsp), %r13
	leaq	(%rax,%rbp), %rbx
	.p2align 4,,10
	.p2align 3
.L3:
	movzbl	2(%rbx), %r8d
	movzbl	(%rbx), %eax
	movzbl	(%rbx,%r15), %ecx
	movzbl	(%rbx,%r15,2), %edi
	movzbl	2(%rbx,%r15,2), %esi
	pxor	%xmm0, %xmm0
	pxor	%xmm2, %xmm2
	movl	%r8d, %edx
	subl	%eax, %edx
	addl	%ecx, %ecx
	negl	%eax
	subl	%ecx, %edx
	movzbl	2(%rbx,%r15), %ecx
	leal	(%rdx,%rcx,2), %edx
	movzbl	1(%rbx), %ecx
	subl	%edi, %edx
	addl	%esi, %edx
	addl	%ecx, %ecx
	subl	%ecx, %eax
	movzbl	1(%rbx,%r15,2), %ecx
	subl	%r8d, %eax
	addl	%edi, %eax
	leal	(%rax,%rcx,2), %eax
	movl	%edx, %ecx
	imull	%edx, %ecx
	addl	%esi, %eax
	movl	%eax, %esi
	imull	%eax, %esi
	addl	%esi, %ecx
	cvtsi2ss	%ecx, %xmm0
	ucomiss	%xmm0, %xmm2
	sqrtss	%xmm0, %xmm1
	ja	.L13
	pxor	%xmm0, %xmm0
	movss	%xmm1, 0(%r13)
	cvtsi2ss	%eax, %xmm0
.L11:
	addq	$1, %rbx
	addq	$4, %r13
	addq	$4, %r14
	pxor	%xmm1, %xmm1
	cvtsi2ss	%edx, %xmm1
	call	atan2f
	movss	%xmm0, -4(%r14)
	cmpq	%rbx, %rbp
	jne	.L3
	movq	16(%rsp), %rdi
	addl	$1, %r12d
	addq	%r15, %rbp
	addq	%rdi, 8(%rsp)
	addq	%rdi, (%rsp)
	cmpl	%r12d, 32(%rsp)
	jne	.L7
.L1:
	addq	$56, %rsp
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
.L13:
	.cfi_restore_state
	movss	%xmm1, 44(%rsp)
	movl	%eax, 40(%rsp)
	movl	%edx, 36(%rsp)
	call	sqrtf
	movl	40(%rsp), %eax
	pxor	%xmm0, %xmm0
	movss	44(%rsp), %xmm1
	movl	36(%rsp), %edx
	movss	%xmm1, 0(%r13)
	cvtsi2ss	%eax, %xmm0
	jmp	.L11
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
	movl	%r8d, %r11d
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
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	cmpl	%r9d, %r11d
	movl	%r8d, 32(%rsp)
	movl	%r9d, 36(%rsp)
	movl	160(%rsp), %eax
	movl	168(%rsp), %r8d
	jge	.L14
	cmpl	%r8d, %eax
	jge	.L14
	subl	$1, %r8d
	movslq	%esi, %r9
	movl	%r8d, %r10d
	movslq	%eax, %r8
	movq	%r9, 56(%rsp)
	subl	%eax, %r10d
	movl	%r11d, %eax
	leaq	2(%rdi,%r8), %rbx
	imull	%esi, %eax
	movq	%r10, 48(%rsp)
	addq	%r10, %rbx
	cltq
	addq	%rbx, %rax
	movq	%rax, 8(%rsp)
	leaq	-8(,%r9,4), %rax
	movq	%rax, 40(%rsp)
	leal	-2(%rsi), %eax
	leal	-1(%r11), %esi
	imull	%eax, %esi
	movslq	%esi, %rax
	addq	%r8, %rax
	leaq	-4(,%rax,4), %r12
	leaq	(%rdx,%r12), %rax
	movq	%rax, 24(%rsp)
	leaq	(%rcx,%r12), %rax
	movq	%rax, 16(%rsp)
	movq	%r10, %rax
	notq	%rax
	movq	%rax, 72(%rsp)
	leaq	-2(%r9), %rax
	movq	%rax, 80(%rsp)
	movq	$-3, %rax
	subq	%r9, %rax
	subq	%r10, %rax
	movq	%rax, 64(%rsp)
	.p2align 4,,10
	.p2align 3
.L20:
	movq	80(%rsp), %r15
	subq	48(%rsp), %r15
	movq	8(%rsp), %rax
	movq	72(%rsp), %rbx
	movq	64(%rsp), %r13
	movq	16(%rsp), %r12
	movq	24(%rsp), %rbp
	addq	%rax, %rbx
	addq	%rax, %r15
	addq	%rax, %r13
	.p2align 4,,10
	.p2align 3
.L16:
	movzbl	2(%r13), %edi
	movzbl	0(%r13), %eax
	movzbl	-2(%rbx), %r8d
	movzbl	-1(%r15), %esi
	movzbl	1(%r15), %ecx
	pxor	%xmm0, %xmm0
	pxor	%xmm2, %xmm2
	movl	%edi, %edx
	subl	%eax, %edx
	addl	%r8d, %r8d
	negl	%eax
	subl	%r8d, %edx
	movzbl	(%rbx), %r8d
	leal	(%rdx,%r8,2), %r14d
	movzbl	1(%r13), %edx
	subl	%esi, %r14d
	addl	%ecx, %r14d
	addl	%edx, %edx
	subl	%edx, %eax
	movzbl	(%r15), %edx
	subl	%edi, %eax
	addl	%esi, %eax
	leal	(%rax,%rdx,2), %eax
	movl	%r14d, %edx
	imull	%r14d, %edx
	addl	%ecx, %eax
	movl	%eax, %ecx
	imull	%eax, %ecx
	addl	%ecx, %edx
	cvtsi2ss	%edx, %xmm0
	ucomiss	%xmm0, %xmm2
	sqrtss	%xmm0, %xmm1
	ja	.L23
	movss	%xmm1, 0(%rbp)
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	addq	$1, %rbx
	addq	$1, %r15
	addq	$4, %rbp
	addq	$4, %r12
	cvtsi2ss	%eax, %xmm0
	addq	$1, %r13
	cvtsi2ss	%r14d, %xmm1
	call	atan2f
	movss	%xmm0, -4(%r12)
	cmpq	%rbx, 8(%rsp)
	jne	.L16
.L18:
	addl	$1, 32(%rsp)
	movq	40(%rsp), %rdi
	movl	32(%rsp), %eax
	movq	56(%rsp), %rsi
	addq	%rdi, 24(%rsp)
	addq	%rsi, 8(%rsp)
	addq	%rdi, 16(%rsp)
	cmpl	%eax, 36(%rsp)
	jne	.L20
.L14:
	addq	$104, %rsp
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
.L23:
	.cfi_restore_state
	movss	%xmm1, 92(%rsp)
	movl	%eax, 88(%rsp)
	addq	$1, %rbx
	call	sqrtf
	movss	92(%rsp), %xmm1
	addq	$1, %r15
	movss	%xmm1, 0(%rbp)
	movl	88(%rsp), %eax
	addq	$4, %rbp
	pxor	%xmm0, %xmm0
	addq	$4, %r12
	pxor	%xmm1, %xmm1
	addq	$1, %r13
	cvtsi2ss	%eax, %xmm0
	cvtsi2ss	%r14d, %xmm1
	call	atan2f
	movss	%xmm0, -4(%r12)
	cmpq	8(%rsp), %rbx
	jne	.L16
	jmp	.L18
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
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r14
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdx, %rbp
	movq	%rcx, %r12
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movl	%r8d, 12(%rsp)
	call	__errno_location
	movl	12(%rsp), %r8d
	movl	(%rax), %r13d
	movq	%rax, %rbx
	movl	$0, (%rax)
	leaq	24(%rsp), %rsi
	movq	%rbp, %rdi
	movl	%r8d, %edx
.LEHB0:
	call	*%r15
	movq	24(%rsp), %rdx
	cmpq	%rbp, %rdx
	je	.L40
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L26
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L26
	testq	%r12, %r12
	je	.L28
	subq	%rbp, %rdx
	movq	%rdx, (%r12)
.L28:
	testl	%esi, %esi
	jne	.L24
	movl	%r13d, (%rbx)
.L24:
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
.L26:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZSt20__throw_out_of_rangePKc
.LEHE0:
.L32:
	cmpl	$0, (%rbx)
	jne	.L31
	movl	%r13d, (%rbx)
.L31:
	movq	%rax, %rdi
.LEHB1:
	call	_Unwind_Resume
.LEHE1:
.L40:
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
	.uleb128 .L32-.LFB2696
	.uleb128 0
	.uleb128 .LEHB1-.LFB2696
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB2696
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L32-.LFB2696
	.uleb128 0
.LLSDACSE2696:
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.size	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, .-_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.section	.rodata._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
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
	testq	%rsi, %rsi
	movq	%r12, (%rdi)
	je	.L42
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movq	%rsi, %r13
	call	strlen
	cmpq	$15, %rax
	movq	%rax, %rbx
	ja	.L53
	cmpq	$1, %rax
	je	.L54
	testq	%rax, %rax
	jne	.L45
.L47:
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
	.p2align 4,,10
	.p2align 3
.L54:
	.cfi_restore_state
	movzbl	0(%r13), %eax
	movb	%al, 16(%rbp)
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L53:
	leaq	1(%rax), %rdi
	call	_Znwm
	movq	%rbx, 16(%rbp)
	movq	%rax, %r12
	movq	%rax, 0(%rbp)
.L45:
	movq	%r12, %rdi
	movq	%rbx, %rdx
	movq	%r13, %rsi
	call	memcpy
	movq	0(%rbp), %r12
	jmp	.L47
.L42:
	movl	$.LC1, %edi
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
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	testq	%rsi, %rsi
	movq	$0, (%rdi)
	movq	$0, 8(%rdi)
	movq	$0, 16(%rdi)
	je	.L56
	movabsq	$4611686018427387903, %rax
	movq	%rsi, %rbx
	cmpq	%rax, %rsi
	ja	.L89
	leaq	0(,%rsi,4), %r12
	movq	%rdx, %r13
	movq	%r12, %rdi
	call	_Znwm
	movq	%rax, %rdx
	leaq	-1(%rbx), %r8
	movl	$5, %r9d
	shrq	$2, %rdx
	leaq	(%rax,%r12), %rdi
	movq	%rax, 0(%rbp)
	negq	%rdx
	movss	0(%r13), %xmm0
	andl	$3, %edx
	movq	%rdi, 16(%rbp)
	movq	%r8, %rsi
	leaq	3(%rdx), %rcx
	cmpq	$5, %rcx
	cmovb	%r9, %rcx
	cmpq	%rcx, %r8
	jb	.L58
	testq	%rdx, %rdx
	je	.L64
	cmpq	$1, %rdx
	movss	%xmm0, (%rax)
	leaq	4(%rax), %r10
	je	.L59
	cmpq	$2, %rdx
	movss	%xmm0, 4(%rax)
	leaq	-2(%rbx), %rsi
	leaq	8(%rax), %r10
	je	.L59
	movss	%xmm0, 8(%rax)
	leaq	-3(%rbx), %rsi
	leaq	12(%rax), %r10
.L59:
	subq	%rdx, %rbx
	movaps	%xmm0, %xmm1
	leaq	-4(%rbx), %r8
	leaq	(%rax,%rdx,4), %rcx
	movq	%rbx, %r9
	shufps	$0, %xmm1, %xmm1
	xorl	%edx, %edx
	shrq	$2, %r8
	addq	$1, %r8
	.p2align 4,,10
	.p2align 3
.L61:
	addq	$1, %rdx
	addq	$16, %rcx
	movaps	%xmm1, -16(%rcx)
	cmpq	%r8, %rdx
	jb	.L61
	leaq	0(,%r8,4), %rdx
	salq	$4, %r8
	leaq	(%r10,%r8), %rax
	subq	%rdx, %rsi
	cmpq	%rdx, %r9
	movq	%rsi, %rbx
	je	.L63
	leaq	-1(%rsi), %r8
.L58:
	testq	%r8, %r8
	movss	%xmm0, (%rax)
	je	.L63
	cmpq	$2, %rbx
	movss	%xmm0, 4(%rax)
	je	.L63
	cmpq	$3, %rbx
	movss	%xmm0, 8(%rax)
	je	.L63
	cmpq	$4, %rbx
	movss	%xmm0, 12(%rax)
	je	.L63
	cmpq	$5, %rbx
	movss	%xmm0, 16(%rax)
	je	.L63
	movss	%xmm0, 20(%rax)
.L63:
	movq	%rdi, 8(%rbp)
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
	.p2align 4,,10
	.p2align 3
.L64:
	.cfi_restore_state
	movq	%rax, %r10
	movq	%rbx, %rsi
	jmp	.L59
	.p2align 4,,10
	.p2align 3
.L56:
	xorl	%edi, %edi
	jmp	.L63
.L89:
	call	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE2939:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_, .-_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_
	.weak	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_
	.set	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_,_ZNSt6vectorIfSaIfEEC2EmRKfRKS0_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"stoi"
.LC4:
	.string	"Setup"
.LC5:
	.string	"Read file"
.LC6:
	.string	"Send requests"
.LC7:
	.string	"Local comp"
.LC8:
	.string	"Wait on resps"
.LC9:
	.string	"Compute received"
.LC10:
	.string	"Write out"
.LC11:
	.string	"Total"
.LC12:
	.string	"Avg(s)"
.LC13:
	.string	"Max(s)"
.LC14:
	.string	"Min(s)"
.LC15:
	.string	"Section"
.LC16:
	.string	"%-20s;%10s;%10s;%10s\n"
.LC17:
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
	movsd	%xmm0, -520(%rbp)
	call	MPI_Comm_rank
	leaq	-472(%rbp), %rsi
	movl	$1140850688, %edi
	call	MPI_Comm_size
	movq	-496(%rbp), %rax
	leaq	-176(%rbp), %rdx
	leaq	-112(%rbp), %rdi
	movq	24(%rax), %rsi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
.LEHE3:
	movq	-112(%rbp), %rdx
	movl	$10, %r8d
	xorl	%ecx, %ecx
	movl	$.LC2, %esi
	movl	$__isoc23_strtol, %edi
.LEHB4:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE4:
	movl	%eax, -488(%rbp)
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L91
	call	_ZdlPv
.L91:
	movq	-496(%rbp), %rax
	leaq	-176(%rbp), %rdx
	leaq	-112(%rbp), %rdi
	movq	32(%rax), %rsi
.LEHB5:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
.LEHE5:
	movq	-112(%rbp), %rdx
	movl	$10, %r8d
	xorl	%ecx, %ecx
	movl	$.LC2, %esi
	movl	$__isoc23_strtol, %edi
.LEHB6:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE6:
	movl	%eax, %r13d
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L92
	call	_ZdlPv
.L92:
	movl	-488(%rbp), %eax
	movl	-488(%rbp), %esi
	movl	$1431655766, %edx
	movl	-472(%rbp), %ebx
	movl	-476(%rbp), %ecx
	imull	%edx
	movl	%esi, %eax
	sarl	$31, %eax
	movl	%ecx, -504(%rbp)
	subl	%eax, %edx
	movl	%esi, %eax
	cmpl	%ebx, %edx
	cmovle	%edx, %ebx
	cltd
	idivl	%ebx
	cmpl	%ebx, %ecx
	movl	%eax, -528(%rbp)
	jge	.L93
	xorl	%r12d, %r12d
	movl	%ecx, %r14d
	cmpl	%edx, %ecx
	setl	%r12b
	imull	%eax, %r14d
	addl	%eax, %r12d
	cmpl	%edx, %ecx
	cmovle	%ecx, %edx
	leal	(%r14,%rdx), %eax
	leal	2(%r12), %r14d
	imull	%r13d, %r14d
	movl	%eax, -524(%rbp)
	movslq	%r14d, %r14
	testq	%r14, %r14
	je	.L132
	movq	%r14, %rdi
.LEHB7:
	call	_Znwm
.LEHE7:
	movq	%r14, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, -512(%rbp)
	call	memset
	jmp	.L94
.L93:
	movq	$0, -512(%rbp)
	movl	$0, -524(%rbp)
	xorl	%r12d, %r12d
.L94:
	leal	-2(%r13), %eax
	leaq	-176(%rbp), %rcx
	leaq	-112(%rbp), %rdx
	leaq	-432(%rbp), %rdi
	movl	$0x7fc00000, -112(%rbp)
	movl	%eax, %r15d
	movl	%eax, -544(%rbp)
	imull	%r12d, %r15d
	movslq	%r15d, %r14
	movq	%r14, %rsi
.LEHB8:
	call	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_
.LEHE8:
	leaq	-176(%rbp), %rcx
	leaq	-112(%rbp), %rdx
	leaq	-400(%rbp), %rdi
	movq	%r14, %rsi
	movl	$0x7fc00000, -112(%rbp)
.LEHB9:
	call	_ZNSt6vectorIfSaIfEEC1EmRKfRKS0_
.LEHE9:
.LEHB10:
	call	MPI_Wtime
	subsd	-520(%rbp), %xmm0
	movsd	%xmm0, -368(%rbp)
	call	MPI_Wtime
	movq	-496(%rbp), %rax
	leaq	-456(%rbp), %r8
	movl	$469762048, %ecx
	movl	$2, %edx
	movl	$1140850688, %edi
	movsd	%xmm0, -536(%rbp)
	movq	8(%rax), %rsi
	call	MPI_File_open
	cmpl	%ebx, -504(%rbp)
	leal	(%r12,%r12), %ecx
	jge	.L97
	movslq	-524(%rbp), %rsi
	movslq	%r13d, %rax
	movq	-512(%rbp), %rdx
	movq	-456(%rbp), %rdi
	addl	%r15d, %ecx
	movl	$1, %r9d
	movl	$1275068731, %r8d
	addq	%rax, %rdx
	imulq	%rax, %rsi
	call	MPI_File_read_at
.L97:
	leaq	-456(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	subsd	-536(%rbp), %xmm0
	movsd	%xmm0, -360(%rbp)
	call	MPI_Wtime
	cmpl	%ebx, -504(%rbp)
	movsd	%xmm0, -536(%rbp)
	jge	.L133
	movl	-476(%rbp), %r14d
	xorl	%r15d, %r15d
	leal	1(%r14), %eax
	subl	$1, %r14d
	movl	%eax, -540(%rbp)
	jns	.L175
.L99:
	cmpl	%ebx, -540(%rbp)
	jl	.L176
.L98:
	call	MPI_Wtime
	subsd	-536(%rbp), %xmm0
	movsd	%xmm0, -352(%rbp)
	call	MPI_Wtime
	cmpl	$2, %r12d
	movsd	%xmm0, -536(%rbp)
	jle	.L100
	cmpl	%ebx, -504(%rbp)
	jl	.L177
.L100:
	call	MPI_Wtime
	subsd	-536(%rbp), %xmm0
	movsd	%xmm0, -344(%rbp)
	call	MPI_Wtime
	leaq	-448(%rbp), %rsi
	movl	$1, %edx
	movl	%r15d, %edi
	movsd	%xmm0, -536(%rbp)
	call	MPI_Waitall
	call	MPI_Wtime
	subsd	-536(%rbp), %xmm0
	movsd	%xmm0, -336(%rbp)
	call	MPI_Wtime
	cmpl	%ebx, -504(%rbp)
	movsd	%xmm0, -536(%rbp)
	jge	.L102
	cmpl	$0, -476(%rbp)
	jg	.L178
.L103:
	movl	-476(%rbp), %eax
	addl	$1, %eax
	cmpl	%ebx, %eax
	jl	.L179
.L102:
	call	MPI_Wtime
	subsd	-536(%rbp), %xmm0
	movsd	%xmm0, -328(%rbp)
	call	MPI_Wtime
	movq	-496(%rbp), %rax
	leaq	-456(%rbp), %r8
	movl	$469762048, %ecx
	movl	$5, %edx
	movl	$1140850688, %edi
	movsd	%xmm0, -536(%rbp)
	movq	16(%rax), %rsi
	call	MPI_File_open
	cmpl	%ebx, -504(%rbp)
	jge	.L110
	movl	-476(%rbp), %eax
	movslq	-544(%rbp), %r13
	testl	%eax, %eax
	leal	1(%rax), %edx
	je	.L180
	cmpl	%ebx, %edx
	je	.L181
	movslq	-528(%rbp), %r12
	imulq	%r13, %r12
.L130:
	movl	-524(%rbp), %eax
	leaq	0(,%r13,4), %r14
	movq	-432(%rbp), %rdx
	subl	$1, %eax
	cltq
	imulq	%rax, %r14
	xorl	%eax, %eax
.L128:
	movq	-400(%rbp), %r15
	movq	-456(%rbp), %rdi
	addq	%rax, %rdx
	movl	$1, %r9d
	movl	$1275069450, %r8d
	movl	%r12d, %ecx
	movq	%r14, %rsi
	addq	%rax, %r15
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
.L110:
	leaq	-456(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	subsd	-536(%rbp), %xmm0
	movl	$1140850688, %edi
	movsd	%xmm0, -320(%rbp)
	call	MPI_Barrier
	call	MPI_Wtime
	subsd	-520(%rbp), %xmm0
	movl	-504(%rbp), %r15d
	movl	$-32766, %esi
	movl	-476(%rbp), %edx
	movl	$0, %eax
	leaq	-468(%rbp), %rcx
	movl	$1140850688, %edi
	cmpl	%ebx, %r15d
	cmovl	%eax, %esi
	movsd	%xmm0, -312(%rbp)
	call	MPI_Comm_split
	cmpl	%ebx, %r15d
	jge	.L112
	movl	-468(%rbp), %edi
	leaq	-464(%rbp), %rsi
	call	MPI_Comm_size
	movl	-468(%rbp), %eax
	subq	$8, %rsp
	leaq	-304(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395010, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	pushq	%rax
	.cfi_escape 0x2e,0x10
	call	MPI_Reduce
	movl	-468(%rbp), %eax
	leaq	-240(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395009, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	movl	%eax, (%rsp)
	call	MPI_Reduce
	movl	-468(%rbp), %eax
	leaq	-176(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395011, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	movl	%eax, (%rsp)
	call	MPI_Reduce
	popq	%rax
	popq	%rdx
	movl	-468(%rbp), %edi
	leaq	-460(%rbp), %rsi
	.cfi_escape 0x2e,0
	call	MPI_Comm_rank
	cmpl	$0, -460(%rbp)
	je	.L182
.L113:
	leaq	-468(%rbp), %rdi
	call	MPI_Comm_free
.L112:
	call	MPI_Finalize
	movq	-400(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L115
	call	_ZdlPv
.L115:
	movq	-432(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L116
	call	_ZdlPv
.L116:
	movq	-512(%rbp), %rax
	testq	%rax, %rax
	je	.L149
	movq	%rax, %rdi
	call	_ZdlPv
.L149:
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
.L180:
	.cfi_restore_state
	movl	-528(%rbp), %eax
	cmpl	$1, %ebx
	leal	-1(%rax), %r12d
	jne	.L171
	movl	-528(%rbp), %r12d
	subl	$2, %r12d
.L171:
	movslq	-524(%rbp), %r14
	leaq	0(,%r13,4), %rax
	movslq	%r12d, %r12
	imulq	%r13, %r12
	movq	-432(%rbp), %rdx
	imulq	%rax, %r14
	jmp	.L128
.L175:
	leaq	-448(%rbp), %r15
	subq	$8, %rsp
	movq	-512(%rbp), %rdi
	movl	$1140850688, %r9d
	movl	$1, %r8d
	movl	%r14d, %ecx
	pushq	%r15
	movl	$1275068731, %edx
	movl	%r13d, %esi
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	movslq	%r13d, %rdi
	addq	-512(%rbp), %rdi
	movq	%r15, %rax
	addq	$4, %rax
	movl	$1140850688, %r9d
	xorl	%r8d, %r8d
	movl	%r14d, %ecx
	movl	$1275068731, %edx
	movl	%r13d, %esi
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%r15
	movl	$2, %r15d
	popq	%rax
	jmp	.L99
.L182:
	movq	$.LC4, -504(%rbp)
	movl	$.LC12, %r8d
	movl	$.LC13, %ecx
	movq	-504(%rbp), %xmm0
	movq	$.LC6, -504(%rbp)
	movhps	.LC18(%rip), %xmm0
	movl	$.LC14, %edx
	movl	$.LC15, %esi
	movl	$.LC16, %edi
	xorl	%eax, %eax
	movaps	%xmm0, -112(%rbp)
	movq	-504(%rbp), %xmm0
	movq	$.LC8, -504(%rbp)
	movhps	.LC19(%rip), %xmm0
	movaps	%xmm0, -96(%rbp)
	movq	-504(%rbp), %xmm0
	movq	$.LC10, -504(%rbp)
	movhps	.LC20(%rip), %xmm0
	movaps	%xmm0, -80(%rbp)
	movq	-504(%rbp), %xmm0
	movhps	.LC21(%rip), %xmm0
	movaps	%xmm0, -64(%rbp)
	.cfi_escape 0x2e,0
	call	printf
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L114:
	pxor	%xmm0, %xmm0
	movl	$.LC17, %edi
	movl	$3, %eax
	movsd	-176(%rbp,%rbx), %xmm2
	movq	-112(%rbp,%rbx), %rsi
	movsd	-304(%rbp,%rbx), %xmm3
	cvtsi2sd	-464(%rbp), %xmm0
	divsd	%xmm0, %xmm2
	movapd	%xmm3, %xmm0
	movsd	%xmm3, -504(%rbp)
	movsd	-240(%rbp,%rbx), %xmm1
	call	printf
	addq	$8, %rbx
	cmpq	$64, %rbx
	jne	.L114
	jmp	.L113
.L178:
	leal	-1(%r13), %eax
	movq	-512(%rbp), %rdi
	movq	-400(%rbp), %rcx
	movq	-432(%rbp), %rdx
	movl	$1, %r8d
	movl	$2, %r9d
	pushq	%rax
	pushq	$1
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L103
.L176:
	leal	1(%r12), %edi
	leaq	-448(%rbp), %rcx
	movslq	%r15d, %r14
	salq	$2, %r14
	subq	$8, %rsp
	movl	$1140850688, %r9d
	imull	%r13d, %edi
	leaq	(%rcx,%r14), %rax
	movq	%rcx, -560(%rbp)
	movl	-540(%rbp), %ecx
	xorl	%r8d, %r8d
	movl	$1275068731, %edx
	pushq	%rax
	movl	%r13d, %esi
	movl	%edi, -548(%rbp)
	movslq	%edi, %rdi
	addq	-512(%rbp), %rdi
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	movl	-548(%rbp), %edi
	movq	-560(%rbp), %rax
	movl	$1140850688, %r9d
	movl	-540(%rbp), %ecx
	movl	$1, %r8d
	movl	$1275068731, %edx
	movl	%r13d, %esi
	addl	$2, %r15d
	subl	%r13d, %edi
	leaq	4(%rax,%r14), %rax
	movslq	%edi, %rdi
	addq	-512(%rbp), %rdi
	movq	%rax, (%rsp)
	call	MPI_Isend
.LEHE10:
	popq	%r11
	popq	%r14
	jmp	.L98
.L133:
	xorl	%r15d, %r15d
	jmp	.L98
.L132:
	movq	$0, -512(%rbp)
	jmp	.L94
.L179:
	leal	-1(%r13), %eax
	movq	-400(%rbp), %rcx
	movq	-432(%rbp), %rdx
	movq	-512(%rbp), %rdi
	leal	1(%r12), %r9d
	leal	-1(%r12), %r8d
	pushq	%rax
	pushq	$1
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
	jmp	.L102
.L177:
	leal	-1(%r13), %eax
	movq	-400(%rbp), %rcx
	movq	-432(%rbp), %rdx
	movq	-512(%rbp), %rdi
	movl	%r12d, %r9d
	movl	$2, %r8d
	pushq	%rax
	pushq	$1
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L100
.L140:
	movq	-400(%rbp), %rdi
	movq	%rax, %rbx
	testq	%rdi, %rdi
	je	.L124
	call	_ZdlPv
.L124:
	movq	-432(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L126
	call	_ZdlPv
.L126:
	movq	-512(%rbp), %rax
	testq	%rax, %rax
	je	.L127
	movq	%rax, %rdi
.L172:
	call	_ZdlPv
.L127:
	movq	%rbx, %rdi
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L139:
	movq	%rax, %rbx
	jmp	.L124
.L138:
	movq	%rax, %rbx
	jmp	.L126
.L136:
.L174:
	movq	%rax, %rbx
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	jne	.L172
	jmp	.L127
.L181:
	movl	-528(%rbp), %r12d
	subl	$1, %r12d
	movslq	%r12d, %r12
	imulq	%r13, %r12
	jmp	.L130
.L137:
	jmp	.L174
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
	.uleb128 .L136-.LFB2629
	.uleb128 0
	.uleb128 .LEHB5-.LFB2629
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB2629
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L137-.LFB2629
	.uleb128 0
	.uleb128 .LEHB7-.LFB2629
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB8-.LFB2629
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L138-.LFB2629
	.uleb128 0
	.uleb128 .LEHB9-.LFB2629
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L139-.LFB2629
	.uleb128 0
	.uleb128 .LEHB10-.LFB2629
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L140-.LFB2629
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
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC18:
	.quad	.LC5
	.align 8
.LC19:
	.quad	.LC7
	.align 8
.LC20:
	.quad	.LC9
	.align 8
.LC21:
	.quad	.LC11
	.hidden	__dso_handle
	.ident	"GCC: (SUSE Linux) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
