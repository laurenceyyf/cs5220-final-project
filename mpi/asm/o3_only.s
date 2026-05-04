	.file	"mpi_2d.cpp"
	.text
	.align 2
	.p2align 4,,15
	.type	_ZZ4mainENKUliiE_clEii, @function
_ZZ4mainENKUliiE_clEii:
.LFB2871:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	(%rdi), %rax
	addl	(%rax), %esi
	movl	%esi, 8(%rsp)
	addl	4(%rax), %edx
	testl	%esi, %esi
	movl	%edx, 12(%rsp)
	js	.L5
	movq	8(%rdi), %rax
	cmpl	(%rax), %esi
	jge	.L5
	testl	%edx, %edx
	js	.L5
	cmpl	4(%rax), %edx
	jge	.L5
	movq	16(%rdi), %rax
	leaq	4(%rsp), %rdx
	leaq	8(%rsp), %rsi
	movl	(%rax), %edi
	call	MPI_Cart_rank
	movl	4(%rsp), %eax
.L1:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L5:
	.cfi_restore_state
	orl	$-1, %eax
	jmp	.L1
	.cfi_endproc
.LFE2871:
	.size	_ZZ4mainENKUliiE_clEii, .-_ZZ4mainENKUliiE_clEii
	.p2align 4,,15
	.globl	_Z5sobelPKhiPfS1_iiii
	.type	_Z5sobelPKhiPfS1_iiii, @function
_Z5sobelPKhiPfS1_iiii:
.LFB2868:
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
	jge	.L8
	cmpl	%r8d, %eax
	jge	.L8
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
.L14:
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
.L10:
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
	ja	.L17
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
	jne	.L10
.L12:
	addl	$1, 32(%rsp)
	movq	40(%rsp), %rdi
	movl	32(%rsp), %eax
	movq	56(%rsp), %rsi
	addq	%rdi, 24(%rsp)
	addq	%rsi, 8(%rsp)
	addq	%rdi, 16(%rsp)
	cmpl	%eax, 36(%rsp)
	jne	.L14
.L8:
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
.L17:
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
	jne	.L10
	jmp	.L12
	.cfi_endproc
.LFE2868:
	.size	_Z5sobelPKhiPfS1_iiii, .-_Z5sobelPKhiPfS1_iiii
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.p2align 4,,15
	.weak	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.type	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, @function
_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_:
.LFB2938:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2938
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
	je	.L34
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
	subq	%rbp, %rdx
	movq	%rdx, (%r12)
.L22:
	testl	%esi, %esi
	jne	.L18
	movl	%r13d, (%rbx)
.L18:
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
.LEHB1:
	call	_Unwind_Resume
.LEHE1:
.L34:
	movq	%r14, %rdi
.LEHB2:
	call	_ZSt24__throw_invalid_argumentPKc
.LEHE2:
	.cfi_endproc
.LFE2938:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"aG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
.LLSDA2938:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2938-.LLSDACSB2938
.LLSDACSB2938:
	.uleb128 .LEHB0-.LFB2938
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L26-.LFB2938
	.uleb128 0
	.uleb128 .LEHB1-.LFB2938
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB2938
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L26-.LFB2938
	.uleb128 0
.LLSDACSE2938:
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
.LFB3160:
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
	je	.L36
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movq	%rsi, %r13
	call	strlen
	cmpq	$15, %rax
	movq	%rax, %rbx
	ja	.L47
	cmpq	$1, %rax
	je	.L48
	testq	%rax, %rax
	jne	.L39
.L41:
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
.L48:
	.cfi_restore_state
	movzbl	0(%r13), %eax
	movb	%al, 16(%rbp)
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L47:
	leaq	1(%rax), %rdi
	call	_Znwm
	movq	%rbx, 16(%rbp)
	movq	%rax, %r12
	movq	%rax, 0(%rbp)
.L39:
	movq	%r12, %rdi
	movq	%rbx, %rdx
	movq	%r13, %rsi
	call	memcpy
	movq	0(%rbp), %r12
	jmp	.L41
.L36:
	movl	$.LC1, %edi
	call	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE3160:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_, .-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
	.set	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.section	.text._ZNSt6vectorIfSaIfEEC2EmRKS0_,"axG",@progbits,_ZNSt6vectorIfSaIfEEC5EmRKS0_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.type	_ZNSt6vectorIfSaIfEEC2EmRKS0_, @function
_ZNSt6vectorIfSaIfEEC2EmRKS0_:
.LFB3181:
	.cfi_startproc
	testq	%rsi, %rsi
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	$0, (%rdi)
	movq	$0, 8(%rdi)
	movq	$0, 16(%rdi)
	je	.L50
	movabsq	$4611686018427387903, %rax
	cmpq	%rax, %rsi
	ja	.L55
	leaq	0(,%rsi,4), %rbx
	movq	%rbx, %rdi
	call	_Znwm
	leaq	(%rax,%rbx), %r12
	movq	%rax, 0(%rbp)
	movq	%rbx, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%r12, 16(%rbp)
	call	memset
.L52:
	movq	%r12, 8(%rbp)
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L50:
	.cfi_restore_state
	xorl	%r12d, %r12d
	jmp	.L52
.L55:
	call	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE3181:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKS0_, .-_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.weak	_ZNSt6vectorIfSaIfEEC1EmRKS0_
	.set	_ZNSt6vectorIfSaIfEEC1EmRKS0_,_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"stoi"
.LC3:
	.string	"native"
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
.LFB2870:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2870
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
	subq	$648, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, -580(%rbp)
	movq	%rsi, -592(%rbp)
	leaq	-580(%rbp), %rdi
	leaq	-592(%rbp), %rsi
.LEHB3:
	call	MPI_Init
	movl	$1140850688, %edi
	call	MPI_Barrier
	call	MPI_Wtime
	leaq	-576(%rbp), %rsi
	movl	$1140850688, %edi
	movsd	%xmm0, -640(%rbp)
	call	MPI_Comm_rank
	leaq	-572(%rbp), %rsi
	movl	$1140850688, %edi
	call	MPI_Comm_size
	movq	-592(%rbp), %rax
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
	movl	%eax, -628(%rbp)
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L57
	call	_ZdlPv
.L57:
	movq	-592(%rbp), %rax
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
	movl	%eax, -616(%rbp)
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L58
	call	_ZdlPv
.L58:
	movl	-628(%rbp), %ecx
	movl	$1431655766, %eax
	movl	-616(%rbp), %ebx
	movl	$2, %esi
	movq	$0, -536(%rbp)
	imull	%ecx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	$1431655766, %eax
	movl	%edx, %r12d
	imull	%ebx
	movl	%ebx, %eax
	leaq	-536(%rbp), %rbx
	sarl	$31, %eax
	subl	%eax, %edx
	movl	-572(%rbp), %eax
	movl	%edx, %edi
	movl	%edx, %r14d
	movq	%rbx, %rdx
	imull	%r12d, %edi
	cmpl	%eax, %edi
	cmovg	%eax, %edi
.LEHB7:
	call	MPI_Dims_create
	cmpl	%r12d, -536(%rbp)
	movl	-576(%rbp), %ecx
	cmovle	-536(%rbp), %r12d
	cmpl	%r14d, -532(%rbp)
	cmovle	-532(%rbp), %r14d
	movl	$67108864, -568(%rbp)
	movl	%ecx, -608(%rbp)
	movq	$0, -528(%rbp)
	movl	%r12d, %eax
	movl	%r12d, -536(%rbp)
	imull	%r14d, %eax
	movl	%r14d, -532(%rbp)
	cmpl	%eax, %ecx
	movl	%eax, -612(%rbp)
	jge	.L236
	leaq	-564(%rbp), %rax
	movl	-608(%rbp), %edx
	xorl	%esi, %esi
	movl	$1140850688, %edi
	movq	%rax, %rcx
	movq	%rax, -664(%rbp)
	call	MPI_Comm_split
	movl	-564(%rbp), %edi
	leaq	-568(%rbp), %r9
	leaq	-528(%rbp), %rcx
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$2, %esi
	movq	$0, -520(%rbp)
	call	MPI_Cart_create
	movl	-568(%rbp), %edi
	leaq	-560(%rbp), %rsi
	call	MPI_Comm_rank
	movl	-560(%rbp), %esi
	movl	-568(%rbp), %edi
	leaq	-520(%rbp), %rcx
	movl	$2, %edx
	call	MPI_Cart_coords
	movl	-628(%rbp), %eax
	cltd
	idivl	-536(%rbp)
	movl	%eax, -584(%rbp)
	movl	-520(%rbp), %eax
	cmpl	%eax, %edx
	jg	.L237
	imull	-584(%rbp), %eax
	movl	%eax, %ecx
.L122:
	leal	(%rdx,%rcx), %eax
	movl	%eax, -648(%rbp)
	movl	-616(%rbp), %eax
	cltd
	idivl	-532(%rbp)
	movl	%eax, %r15d
	movl	-516(%rbp), %eax
	movl	%eax, %ecx
	imull	%r15d, %ecx
	cmpl	%eax, %edx
	jle	.L123
	addl	$1, %r15d
	movl	%eax, %edx
.L123:
	leal	(%rdx,%rcx), %eax
	leal	2(%r15), %r14d
	movl	%eax, -632(%rbp)
	movl	-584(%rbp), %eax
	leal	2(%rax), %r12d
	imull	%r15d, %eax
	movl	%r12d, %r13d
	imull	%r14d, %r13d
	cltq
	movq	%rax, -624(%rbp)
	movslq	%r13d, %r13
	testq	%r13, %r13
	je	.L138
	movq	%r13, %rdi
	call	_Znwm
	movq	%r13, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, -600(%rbp)
	call	memset
	movl	$0, -644(%rbp)
	movq	-624(%rbp), %r13
	jmp	.L62
	.p2align 4,,10
	.p2align 3
.L236:
	leaq	-564(%rbp), %rax
	movl	%ecx, %edx
	movl	$-32766, %esi
	movl	$1140850688, %edi
	movl	$2, %r14d
	movl	$2, %r12d
	movq	%rax, %rcx
	movq	%rax, -664(%rbp)
	xorl	%r15d, %r15d
	call	MPI_Comm_split
.LEHE7:
	movq	$0, -624(%rbp)
	movq	-624(%rbp), %r13
	movq	$0, -520(%rbp)
	movq	$0, -600(%rbp)
	movl	$-32766, -644(%rbp)
	movl	$0, -632(%rbp)
	movl	$0, -648(%rbp)
	movl	$0, -584(%rbp)
.L62:
	leaq	-112(%rbp), %rdx
	leaq	-496(%rbp), %rdi
	movq	%r13, %rsi
.LEHB8:
	call	_ZNSt6vectorIfSaIfEEC1EmRKS0_
.LEHE8:
	leaq	-112(%rbp), %rdx
	leaq	-464(%rbp), %rdi
	movq	%r13, %rsi
.LEHB9:
	call	_ZNSt6vectorIfSaIfEEC1EmRKS0_
.LEHE9:
.LEHB10:
	call	MPI_Wtime
	subsd	-640(%rbp), %xmm0
	movsd	%xmm0, -432(%rbp)
	call	MPI_Wtime
	movq	-592(%rbp), %rax
	leaq	-544(%rbp), %r8
	movl	$469762048, %ecx
	movl	-568(%rbp), %edi
	movl	$2, %edx
	movsd	%xmm0, -624(%rbp)
	movq	8(%rax), %rsi
	call	MPI_File_open
	movl	-612(%rbp), %ecx
	cmpl	%ecx, -608(%rbp)
	jge	.L63
	movl	-628(%rbp), %eax
	movl	-648(%rbp), %ecx
	leaq	-548(%rbp), %r13
	subq	$8, %rsp
	leaq	-368(%rbp), %rdx
	leaq	-504(%rbp), %rsi
	pushq	%r13
	movl	$1275068731, %r9d
	movl	$56, %r8d
	movl	%eax, -504(%rbp)
	movl	-616(%rbp), %eax
	movl	$2, %edi
	movl	%ecx, -304(%rbp)
	movl	-632(%rbp), %ecx
	movl	%r15d, -364(%rbp)
	movl	%eax, -500(%rbp)
	movl	-584(%rbp), %eax
	movl	%ecx, -300(%rbp)
	leaq	-304(%rbp), %rcx
	movl	%eax, -368(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%rcx
	popq	%rsi
	movq	%r13, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-584(%rbp), %eax
	movl	%r12d, -240(%rbp)
	leaq	-512(%rbp), %r12
	subq	$8, %rsp
	leaq	-112(%rbp), %rcx
	leaq	-176(%rbp), %rdx
	pushq	%r12
	leaq	-240(%rbp), %rsi
	movl	$1275068731, %r9d
	movl	%eax, -176(%rbp)
	movl	$56, %r8d
	movabsq	$4294967297, %rax
	movl	$2, %edi
	movl	%r14d, -236(%rbp)
	movl	%r15d, -172(%rbp)
	movq	%rax, -112(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%rax
	popq	%rdx
	movq	%r12, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-548(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC3, %r8d
	movl	$1275068731, %edx
	xorl	%esi, %esi
	call	MPI_File_set_view
	movl	-512(%rbp), %ecx
	movq	-600(%rbp), %rsi
	movl	$1, %r8d
	movq	-544(%rbp), %rdi
	movl	$1, %edx
	call	MPI_File_read_all
	movq	%r13, %rdi
	call	MPI_Type_free
	movq	%r12, %rdi
	call	MPI_Type_free
.L63:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	subsd	-624(%rbp), %xmm0
	movsd	%xmm0, -424(%rbp)
	call	MPI_Wtime
	movl	-612(%rbp), %ecx
	movsd	%xmm0, -656(%rbp)
	cmpl	%ecx, -608(%rbp)
	movl	$201326592, -556(%rbp)
	movl	$0, -624(%rbp)
	jl	.L238
.L64:
	call	MPI_Wtime
	subsd	-656(%rbp), %xmm0
	movsd	%xmm0, -416(%rbp)
	call	MPI_Wtime
	movl	-612(%rbp), %ebx
	movsd	%xmm0, -656(%rbp)
	cmpl	%ebx, -608(%rbp)
	jge	.L73
	movl	-584(%rbp), %eax
	cmpl	$2, %eax
	jle	.L73
	cmpl	$2, %r15d
	jg	.L239
	.p2align 4,,10
	.p2align 3
.L73:
	call	MPI_Wtime
	subsd	-656(%rbp), %xmm0
	movsd	%xmm0, -408(%rbp)
	call	MPI_Wtime
	movl	-624(%rbp), %edi
	leaq	-368(%rbp), %rsi
	movl	$1, %edx
	movsd	%xmm0, -656(%rbp)
	call	MPI_Waitall
	call	MPI_Wtime
	subsd	-656(%rbp), %xmm0
	movsd	%xmm0, -400(%rbp)
	call	MPI_Wtime
	movl	-612(%rbp), %ebx
	movsd	%xmm0, -624(%rbp)
	cmpl	%ebx, -608(%rbp)
	jge	.L74
	movl	-568(%rbp), %edi
	leaq	-240(%rbp), %r8
	leaq	-304(%rbp), %rcx
	movl	$1, %edx
	xorl	%esi, %esi
	call	MPI_Cart_shift
	movl	-568(%rbp), %edi
	leaq	-112(%rbp), %r8
	leaq	-176(%rbp), %rcx
	movl	$1, %edx
	movl	$1, %esi
	call	MPI_Cart_shift
	movl	-240(%rbp), %r12d
	movl	-176(%rbp), %eax
	movl	-112(%rbp), %r13d
	movl	-304(%rbp), %ebx
	cmpl	$-1, %r12d
	movl	%eax, -676(%rbp)
	setne	-672(%rbp)
	addl	$1, %eax
	movl	%r13d, -668(%rbp)
	setne	-656(%rbp)
	cmpl	$-1, %r13d
	movzbl	-656(%rbp), %eax
	setne	-688(%rbp)
	cmpl	$-1, %ebx
	je	.L75
	testb	%al, %al
	jne	.L240
.L75:
	cmpl	$-1, %ebx
	jne	.L241
.L79:
	cmpl	$-1, -676(%rbp)
	je	.L82
.L134:
	cmpl	$-1, %r12d
	movl	-584(%rbp), %r9d
	jne	.L83
	leal	1(%r9), %r9d
.L83:
	xorl	%eax, %eax
	cmpl	$-1, %ebx
	movq	-464(%rbp), %rcx
	setne	%al
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	pushq	$2
	leal	1(%rax), %r8d
	pushq	$1
	movl	%r14d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	cmpl	$-1, -668(%rbp)
	popq	%r13
	popq	%rax
	je	.L85
.L124:
	cmpl	$-1, %r12d
	leal	1(%r15), %r13d
	movl	-584(%rbp), %r9d
	jne	.L86
	leal	1(%r9), %r9d
.L86:
	xorl	%edx, %edx
	addl	$1, %ebx
	movq	-464(%rbp), %rcx
	setne	%dl
	movq	-600(%rbp), %rdi
	pushq	%r13
	leal	1(%rdx), %r8d
	movq	-496(%rbp), %rdx
	pushq	%r15
	movl	%r14d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	cmpb	$0, -672(%rbp)
	popq	%r11
	popq	%rbx
	je	.L88
	cmpb	$0, -656(%rbp)
	je	.L88
	movl	-584(%rbp), %r8d
	movq	-464(%rbp), %rcx
	movl	%r14d, %esi
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	pushq	$2
	pushq	$1
	leal	1(%r8), %ebx
	movl	%ebx, %r9d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	movl	%r15d, %ecx
	movl	$2, %edx
.L89:
	pushq	%rcx
	movl	-584(%rbp), %r8d
	movl	%ebx, %r9d
	pushq	%rdx
	movq	-600(%rbp), %rdi
	movl	%r14d, %esi
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	call	_Z5sobelPKhiPfS1_iiii
	cmpb	$0, -672(%rbp)
	popq	%rdi
	popq	%r8
	je	.L91
	cmpb	$0, -688(%rbp)
	jne	.L137
.L91:
	leaq	-556(%rbp), %rdi
	call	MPI_Type_free
.L74:
	call	MPI_Wtime
	subsd	-624(%rbp), %xmm0
	movsd	%xmm0, -392(%rbp)
	call	MPI_Wtime
	movq	-592(%rbp), %rax
	leaq	-544(%rbp), %r8
	movl	$469762048, %ecx
	movl	-568(%rbp), %edi
	movl	$5, %edx
	movsd	%xmm0, -656(%rbp)
	movq	16(%rax), %rsi
	call	MPI_File_open
	movl	-612(%rbp), %ebx
	cmpl	%ebx, -608(%rbp)
	jge	.L93
	movl	-532(%rbp), %ebx
	movl	-616(%rbp), %ecx
	movl	-516(%rbp), %r12d
	movl	-536(%rbp), %eax
	movl	-520(%rbp), %r14d
	leal	-1(%rbx), %edx
	movl	-628(%rbp), %ebx
	subl	$2, %ecx
	subl	$1, %eax
	movl	%ecx, -616(%rbp)
	movl	%r15d, %ecx
	subl	$2, %ebx
	cmpl	$1, %r12d
	sbbl	$0, %ecx
	cmpl	%edx, %r12d
	sete	%dl
	movzbl	%dl, %edx
	subl	%edx, %ecx
	testl	%r14d, %r14d
	movl	%ecx, -624(%rbp)
	je	.L242
	cmpl	%eax, %r14d
	jne	.L243
	movl	-584(%rbp), %eax
	movl	-616(%rbp), %esi
	movl	%ebx, -512(%rbp)
	subl	$1, %eax
	movl	%esi, -508(%rbp)
	movl	%eax, -628(%rbp)
	movl	%eax, -504(%rbp)
	movl	-624(%rbp), %eax
	movl	%eax, -500(%rbp)
.L128:
	movl	-648(%rbp), %eax
	subl	$1, %eax
.L131:
	movl	-632(%rbp), %edx
	movl	%eax, -304(%rbp)
	leaq	-552(%rbp), %r13
	movl	$0, %eax
	leaq	-304(%rbp), %rcx
	leaq	-512(%rbp), %rsi
	movl	$1275069450, %r9d
	movl	$56, %r8d
	movl	$2, %edi
	subl	$1, %edx
	testl	%r12d, %r12d
	cmove	%eax, %edx
	subq	$8, %rsp
	movl	%edx, -300(%rbp)
	pushq	%r13
	leaq	-504(%rbp), %rdx
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%rax
	popq	%rdx
	movq	%r13, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movslq	-616(%rbp), %rax
	movslq	%ebx, %rbx
	movl	%r15d, -236(%rbp)
	leaq	-548(%rbp), %r15
	leaq	-112(%rbp), %rcx
	leaq	-176(%rbp), %rdx
	leaq	-240(%rbp), %rsi
	movl	$1275069450, %r9d
	movl	$56, %r8d
	movl	$2, %edi
	imulq	%rax, %rbx
	movl	-584(%rbp), %eax
	movl	%eax, -240(%rbp)
	movl	-628(%rbp), %eax
	salq	$2, %rbx
	movl	%eax, -176(%rbp)
	movl	-624(%rbp), %eax
	movl	%eax, -172(%rbp)
	xorl	%eax, %eax
	testl	%r14d, %r14d
	sete	%al
	movl	%eax, -112(%rbp)
	xorl	%eax, %eax
	testl	%r12d, %r12d
	sete	%al
	subq	$8, %rsp
	pushq	%r15
	movl	%eax, -108(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r12
	popq	%r14
	movq	%r15, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-552(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC3, %r8d
	movl	$1275069450, %edx
	xorl	%esi, %esi
	call	MPI_File_set_view
	movl	-548(%rbp), %ecx
	movq	-496(%rbp), %rsi
	movl	$1, %r8d
	movq	-544(%rbp), %rdi
	movl	$1, %edx
	call	MPI_File_write_all
	movl	-552(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC3, %r8d
	movl	$1275069450, %edx
	movq	%rbx, %rsi
	call	MPI_File_set_view
	movl	-548(%rbp), %ecx
	movq	-464(%rbp), %rsi
	movl	$1, %r8d
	movq	-544(%rbp), %rdi
	movl	$1, %edx
	call	MPI_File_write_all
	movq	%r13, %rdi
	call	MPI_Type_free
	movq	%r15, %rdi
	call	MPI_Type_free
.L93:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	subsd	-656(%rbp), %xmm0
	cmpl	$67108864, -568(%rbp)
	movsd	%xmm0, -384(%rbp)
	jne	.L100
.L103:
	cmpl	$67108864, -564(%rbp)
	je	.L102
	movq	-664(%rbp), %rdi
	call	MPI_Comm_free
.L102:
	movl	$1140850688, %edi
	call	MPI_Barrier
	call	MPI_Wtime
	subsd	-640(%rbp), %xmm0
	leaq	-548(%rbp), %rax
	movl	-576(%rbp), %edx
	movl	-644(%rbp), %esi
	movl	$1140850688, %edi
	movq	%rax, %rcx
	movq	%rax, %r15
	movsd	%xmm0, -376(%rbp)
	call	MPI_Comm_split
	movl	-612(%rbp), %ebx
	cmpl	%ebx, -608(%rbp)
	jge	.L105
	movl	-548(%rbp), %edi
	leaq	-512(%rbp), %rsi
	call	MPI_Comm_size
	movl	-548(%rbp), %eax
	subq	$8, %rsp
	leaq	-304(%rbp), %rsi
	leaq	-432(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395010, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	pushq	%rax
	.cfi_escape 0x2e,0x10
	call	MPI_Reduce
	movl	-548(%rbp), %eax
	leaq	-240(%rbp), %rsi
	leaq	-432(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395009, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	movl	%eax, (%rsp)
	call	MPI_Reduce
	movl	-548(%rbp), %eax
	leaq	-176(%rbp), %rsi
	leaq	-432(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395011, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	movl	%eax, (%rsp)
	call	MPI_Reduce
	popq	%r11
	popq	%rbx
	movl	-548(%rbp), %edi
	leaq	-504(%rbp), %rsi
	.cfi_escape 0x2e,0
	call	MPI_Comm_rank
	cmpl	$0, -504(%rbp)
	je	.L244
.L106:
	movq	%r15, %rdi
	call	MPI_Comm_free
.L105:
	call	MPI_Finalize
	movq	-464(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L108
	call	_ZdlPv
.L108:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L109
	call	_ZdlPv
.L109:
	movq	-600(%rbp), %rax
	testq	%rax, %rax
	je	.L176
	movq	%rax, %rdi
	call	_ZdlPv
.L176:
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
.L242:
	.cfi_restore_state
	movl	-584(%rbp), %ecx
	subl	$1, %ecx
	testl	%eax, %eax
	movl	%ecx, -628(%rbp)
	je	.L245
	movl	-616(%rbp), %eax
	movl	%ebx, -512(%rbp)
	movl	%eax, -508(%rbp)
	movl	-628(%rbp), %eax
	movl	%eax, -504(%rbp)
	movl	-624(%rbp), %eax
	movl	%eax, -500(%rbp)
	xorl	%eax, %eax
	jmp	.L131
.L237:
	movl	-584(%rbp), %edx
	movl	%edx, %ecx
	addl	$1, %edx
	movl	%edx, -584(%rbp)
	movl	%eax, %edx
	imull	%eax, %ecx
	jmp	.L122
.L244:
	movq	$.LC4, -608(%rbp)
	movl	$.LC12, %r8d
	movl	$.LC13, %ecx
	movq	-608(%rbp), %xmm0
	movq	$.LC6, -608(%rbp)
	movhps	.LC18(%rip), %xmm0
	movl	$.LC14, %edx
	movl	$.LC15, %esi
	movl	$.LC16, %edi
	xorl	%eax, %eax
	movaps	%xmm0, -112(%rbp)
	movq	-608(%rbp), %xmm0
	movq	$.LC8, -608(%rbp)
	movhps	.LC19(%rip), %xmm0
	movaps	%xmm0, -96(%rbp)
	movq	-608(%rbp), %xmm0
	movq	$.LC10, -608(%rbp)
	movhps	.LC20(%rip), %xmm0
	movaps	%xmm0, -80(%rbp)
	movq	-608(%rbp), %xmm0
	movhps	.LC21(%rip), %xmm0
	movaps	%xmm0, -64(%rbp)
	call	printf
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L107:
	pxor	%xmm0, %xmm0
	movl	$.LC17, %edi
	movl	$3, %eax
	movsd	-176(%rbp,%rbx), %xmm2
	movq	-112(%rbp,%rbx), %rsi
	movsd	-304(%rbp,%rbx), %xmm3
	cvtsi2sd	-512(%rbp), %xmm0
	divsd	%xmm0, %xmm2
	movapd	%xmm3, %xmm0
	movsd	%xmm3, -608(%rbp)
	movsd	-240(%rbp,%rbx), %xmm1
	call	printf
	addq	$8, %rbx
	cmpq	$64, %rbx
	jne	.L107
	jmp	.L106
.L85:
	cmpb	$0, -672(%rbp)
	je	.L88
	cmpb	$0, -656(%rbp)
	jne	.L135
.L88:
	addl	$1, %r12d
	je	.L91
	cmpl	$-1, -668(%rbp)
	je	.L232
	movl	-584(%rbp), %r8d
	movq	-464(%rbp), %rcx
	movl	%r14d, %esi
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	leal	1(%r15), %r13d
	pushq	%r15
	pushq	$1
	leal	1(%r8), %ebx
	movl	%ebx, %r9d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
.L137:
	movq	-464(%rbp), %rcx
	movl	-584(%rbp), %r8d
	movl	%r14d, %esi
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	movl	%ebx, %r9d
	pushq	%r13
	pushq	%r15
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
	jmp	.L91
.L100:
	leaq	-568(%rbp), %rdi
	call	MPI_Comm_free
	jmp	.L103
.L238:
	movl	-584(%rbp), %edi
	leaq	-556(%rbp), %r8
	movl	$1275068731, %ecx
	movl	%r14d, %edx
	movl	$1, %esi
	call	MPI_Type_vector
	leaq	-556(%rbp), %rdi
	call	MPI_Type_commit
	movl	-568(%rbp), %edi
	leaq	-304(%rbp), %r8
	leaq	-504(%rbp), %rcx
	movl	$1, %edx
	xorl	%esi, %esi
	call	MPI_Cart_shift
	movl	-568(%rbp), %edi
	leaq	-176(%rbp), %r8
	leaq	-240(%rbp), %rcx
	movl	$1, %edx
	movl	$1, %esi
	call	MPI_Cart_shift
	leaq	-520(%rbp), %rax
	orl	$-1, %edx
	leaq	-112(%rbp), %rdi
	movl	%edx, %esi
	movq	%rax, -624(%rbp)
	leaq	-568(%rbp), %rax
	movq	-624(%rbp), %xmm0
	movq	%rbx, -624(%rbp)
	movhps	-624(%rbp), %xmm0
	movq	%rax, -96(%rbp)
	movaps	%xmm0, -112(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	leaq	-112(%rbp), %rdi
	movl	$1, %edx
	orl	$-1, %esi
	movl	%eax, %r13d
	call	_ZZ4mainENKUliiE_clEii
	leaq	-112(%rbp), %rdi
	orl	$-1, %edx
	movl	$1, %esi
	movl	%eax, -676(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	leaq	-112(%rbp), %rdi
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, -668(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	movl	-504(%rbp), %ecx
	movl	%eax, -672(%rbp)
	movl	$0, -624(%rbp)
	cmpl	$-1, %ecx
	je	.L65
	movq	-600(%rbp), %rbx
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$10, %r8d
	movl	$1275068731, %edx
	pushq	%r12
	movl	%r15d, %esi
	leaq	1(%rbx), %rdi
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	leal	3(%r15), %edi
	movl	-568(%rbp), %r9d
	movl	-504(%rbp), %ecx
	addq	$4, %r12
	movl	$11, %r8d
	movl	$1275068731, %edx
	movslq	%edi, %rdi
	movl	%r15d, %esi
	movq	%r12, (%rsp)
	addq	%rbx, %rdi
	call	MPI_Isend
	popq	%r12
	popq	%rax
	movl	$2, -624(%rbp)
.L65:
	movl	-304(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L66
	movl	-584(%rbp), %ebx
	movslq	-624(%rbp), %rax
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$11, %r8d
	movl	%r15d, %esi
	addl	$1, %ebx
	imull	%r14d, %ebx
	leaq	0(,%rax,4), %rdx
	leaq	(%r12,%rdx), %rax
	movq	%rdx, -688(%rbp)
	movl	$1275068731, %edx
	leal	1(%rbx), %edi
	pushq	%rax
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	subl	%r14d, %ebx
	movq	-688(%rbp), %rdx
	movl	-568(%rbp), %r9d
	leal	1(%rbx), %edi
	movl	-304(%rbp), %ecx
	movl	$10, %r8d
	movl	%r15d, %esi
	addl	$2, -624(%rbp)
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	leaq	4(%r12,%rdx), %rax
	movl	$1275068731, %edx
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%r11
	popq	%rbx
.L66:
	movl	-240(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L67
	movslq	-624(%rbp), %rbx
	leaq	-368(%rbp), %r12
	movslq	%r14d, %rdi
	addq	-600(%rbp), %rdi
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	-556(%rbp), %edx
	movl	$20, %r8d
	movl	$1, %esi
	salq	$2, %rbx
	leaq	(%r12,%rbx), %rax
	pushq	%rax
	call	MPI_Irecv
	leal	3(%r15), %edi
	movl	-568(%rbp), %r9d
	movl	-240(%rbp), %ecx
	movl	-556(%rbp), %edx
	leaq	4(%r12,%rbx), %rax
	movl	$21, %r8d
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	addl	$2, -624(%rbp)
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%r9
	popq	%r10
.L67:
	movl	-176(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L68
	movslq	-624(%rbp), %rbx
	leal	1(%r14,%r15), %edi
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	-556(%rbp), %edx
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$21, %r8d
	movl	$1, %esi
	salq	$2, %rbx
	leaq	(%r12,%rbx), %rax
	pushq	%rax
	call	MPI_Irecv
	leal	(%r15,%r14), %edi
	movl	-568(%rbp), %r9d
	movl	-176(%rbp), %ecx
	movl	-556(%rbp), %edx
	leaq	4(%r12,%rbx), %rax
	movl	$20, %r8d
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	addl	$2, -624(%rbp)
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%rdi
	popq	%r8
.L68:
	cmpl	$-1, %r13d
	je	.L69
	movslq	-624(%rbp), %rbx
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movq	-600(%rbp), %rdi
	movl	$30, %r8d
	movl	%r13d, %ecx
	movl	$1275068731, %edx
	movl	$1, %esi
	salq	$2, %rbx
	leaq	(%r12,%rbx), %rax
	pushq	%rax
	call	MPI_Irecv
	leal	3(%r15), %edi
	movl	-568(%rbp), %r9d
	leaq	4(%r12,%rbx), %rax
	movl	$33, %r8d
	movl	%r13d, %ecx
	movl	$1275068731, %edx
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	addl	$2, -624(%rbp)
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%rcx
	popq	%rsi
.L69:
	movl	-676(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L70
	movslq	-624(%rbp), %rbx
	leal	1(%r15), %r13d
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$31, %r8d
	movslq	%r13d, %rdi
	addq	-600(%rbp), %rdi
	movl	$1275068731, %edx
	movl	$1, %esi
	movl	%ecx, %r13d
	salq	$2, %rbx
	leaq	(%r12,%rbx), %rax
	pushq	%rax
	call	MPI_Irecv
	leal	(%r15,%r14), %edi
	movl	-568(%rbp), %r9d
	leaq	4(%r12,%rbx), %rax
	movl	$32, %r8d
	movl	%r13d, %ecx
	movl	$1275068731, %edx
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	addl	$2, -624(%rbp)
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%rax
	popq	%rdx
.L70:
	movl	-668(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L71
	movl	-584(%rbp), %ebx
	movslq	-624(%rbp), %r13
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$32, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$1, %ebx
	imull	%r14d, %ebx
	salq	$2, %r13
	leaq	(%r12,%r13), %rax
	movslq	%ebx, %rdi
	addq	-600(%rbp), %rdi
	pushq	%rax
	call	MPI_Irecv
	subl	%r14d, %ebx
	movl	-568(%rbp), %r9d
	movl	-668(%rbp), %ecx
	leal	1(%rbx), %edi
	leaq	4(%r12,%r13), %rax
	movl	$31, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$2, -624(%rbp)
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%r12
	popq	%r13
.L71:
	movl	-672(%rbp), %esi
	cmpl	$-1, %esi
	je	.L64
	movl	-584(%rbp), %ebx
	movslq	-624(%rbp), %r13
	leaq	-368(%rbp), %r12
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	%esi, %ecx
	movl	$33, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$1, %ebx
	imull	%r14d, %ebx
	salq	$2, %r13
	leaq	(%r12,%r13), %rax
	leal	1(%rbx,%r15), %edi
	pushq	%rax
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	subl	%r14d, %ebx
	movl	-568(%rbp), %r9d
	movl	-672(%rbp), %ecx
	leal	(%rbx,%r15), %edi
	leaq	4(%r12,%r13), %rax
	movl	$30, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$2, -624(%rbp)
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movq	%rax, (%rsp)
	call	MPI_Isend
.LEHE10:
	popq	%r11
	popq	%rbx
	jmp	.L64
.L240:
	movq	-600(%rbp), %rdi
	movq	-464(%rbp), %rcx
	movl	$1, %r8d
	movq	-496(%rbp), %rdx
	pushq	$2
	movl	$2, %r9d
	pushq	$1
	movl	%r14d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	addl	$1, %r13d
	popq	%rdi
	popq	%r8
	je	.L77
	pushq	%r15
	pushq	$2
.L231:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	$2, %r9d
	movq	-600(%rbp), %rdi
	movl	$1, %r8d
	movl	%r14d, %esi
	leal	1(%r15), %r13d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	%r14d, %esi
	movq	-600(%rbp), %rdi
	pushq	%r13
	movl	$2, %r9d
	pushq	%r15
	movl	$1, %r8d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
	jmp	.L79
.L241:
	cmpl	$-1, -668(%rbp)
	je	.L77
	pushq	%r15
	pushq	$1
	jmp	.L231
.L239:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	%eax, %r9d
	movq	-600(%rbp), %rdi
	pushq	%r15
	movl	$2, %r8d
	pushq	$2
	movl	%r14d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L73
.L82:
	cmpl	$-1, -668(%rbp)
	jne	.L124
.L228:
	addl	$1, %r12d
	je	.L91
.L232:
	movl	-584(%rbp), %eax
	leal	1(%rax), %ebx
.L127:
	xorl	%edx, %edx
	cmpl	$-1, -676(%rbp)
	leal	1(%r15), %r13d
	movl	%r13d, %ecx
	setne	%dl
	addl	$1, %edx
	jmp	.L89
.L138:
	movq	$0, -600(%rbp)
	movl	$0, -644(%rbp)
	movq	%rax, %r13
	jmp	.L62
.L77:
	cmpl	$-1, -676(%rbp)
	leal	1(%r15), %r13d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	je	.L246
	movq	-600(%rbp), %rdi
	pushq	%r13
	movl	$2, %r9d
	pushq	$2
	movl	$1, %r8d
	movl	%r14d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L134
.L243:
	movl	-616(%rbp), %eax
	movl	-624(%rbp), %ecx
	movl	%ebx, -512(%rbp)
	movl	%eax, -508(%rbp)
	movl	-584(%rbp), %eax
	movl	%ecx, -500(%rbp)
	movl	%eax, -504(%rbp)
	movl	%eax, -628(%rbp)
	jmp	.L128
.L246:
	movq	-600(%rbp), %rdi
	pushq	%r13
	movl	$2, %r9d
	pushq	$1
	movl	$1, %r8d
	movl	%r14d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
	jmp	.L228
.L135:
	movl	-584(%rbp), %r8d
	movq	-600(%rbp), %rdi
	movl	%r14d, %esi
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	pushq	$2
	pushq	$1
	leal	1(%r8), %ebx
	movl	%ebx, %r9d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L127
.L152:
	movq	-464(%rbp), %rdi
	movq	%rax, %rbx
	testq	%rdi, %rdi
	je	.L117
	call	_ZdlPv
.L117:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L119
	call	_ZdlPv
.L119:
	movq	-600(%rbp), %rax
	testq	%rax, %rax
	je	.L120
	movq	%rax, %rdi
.L233:
	call	_ZdlPv
.L120:
	movq	%rbx, %rdi
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L149:
.L235:
	movq	%rax, %rbx
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	jne	.L233
	jmp	.L120
.L150:
	movq	%rax, %rbx
	jmp	.L119
.L245:
	movl	-584(%rbp), %ecx
	movl	-616(%rbp), %edx
	movl	%ebx, -512(%rbp)
	subl	$2, %ecx
	movl	%edx, -508(%rbp)
	movl	%ecx, -628(%rbp)
	movl	%ecx, -504(%rbp)
	movl	-624(%rbp), %ecx
	movl	%ecx, -500(%rbp)
	jmp	.L131
.L148:
	jmp	.L235
.L151:
	movq	%rax, %rbx
	jmp	.L117
	.cfi_endproc
.LFE2870:
	.section	.gcc_except_table,"a",@progbits
.LLSDA2870:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2870-.LLSDACSB2870
.LLSDACSB2870:
	.uleb128 .LEHB3-.LFB2870
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB4-.LFB2870
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L148-.LFB2870
	.uleb128 0
	.uleb128 .LEHB5-.LFB2870
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB2870
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L149-.LFB2870
	.uleb128 0
	.uleb128 .LEHB7-.LFB2870
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB8-.LFB2870
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L150-.LFB2870
	.uleb128 0
	.uleb128 .LEHB9-.LFB2870
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L151-.LFB2870
	.uleb128 0
	.uleb128 .LEHB10-.LFB2870
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L152-.LFB2870
	.uleb128 0
	.uleb128 .LEHB11-.LFB2870
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
.LLSDACSE2870:
	.section	.text.startup
	.size	main, .-main
	.p2align 4,,15
	.type	_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii, @function
_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii:
.LFB3629:
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
.LFE3629:
	.size	_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii, .-_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii
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
