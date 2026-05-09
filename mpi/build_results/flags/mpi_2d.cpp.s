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
	movl	%edx, 12(%rsp)
	testl	%esi, %esi
	js	.L5
	movq	8(%rdi), %rcx
	cmpl	(%rcx), %esi
	jge	.L5
	testl	%edx, %edx
	js	.L5
	cmpl	4(%rcx), %edx
	jge	.L5
	movq	16(%rdi), %rdi
	leaq	4(%rsp), %rdx
	leaq	8(%rsp), %rsi
	movl	(%rdi), %edi
	call	MPI_Cart_rank
	movl	4(%rsp), %eax
.L6:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L5:
	.cfi_restore_state
	orl	$-1, %eax
	jmp	.L6
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
	jge	.L15
	cmpl	%r9d, %r8d
	jge	.L15
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
.L12:
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
.L11:
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
	jne	.L11
	incl	32(%rsp)
	movq	40(%rsp), %r15
	movq	48(%rsp), %r14
	movl	32(%rsp), %ebp
	addq	%r14, 24(%rsp)
	addq	%r15, 16(%rsp)
	addq	%r15, 8(%rsp)
	cmpl	%ebp, 36(%rsp)
	jne	.L12
.L15:
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
	je	.L34
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L19
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L19
	testq	%r12, %r12
	je	.L21
	subq	%rbp, %r8
	movq	%r8, (%r12)
.L21:
	testl	%esi, %esi
	jne	.L32
	movl	%r13d, (%rbx)
.L32:
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
.L19:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZSt20__throw_out_of_rangePKc
.LEHE0:
.L25:
	cmpl	$0, (%rbx)
	jne	.L24
	movl	%r13d, (%rbx)
.L24:
	movq	%rax, %rdi
	vzeroupper
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
	.uleb128 .L25-.LFB2938
	.uleb128 0
	.uleb128 .LEHB1-.LFB2938
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB2938
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L25-.LFB2938
	.uleb128 0
.LLSDACSE2938:
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
	movq	%r12, (%rdi)
	testq	%rsi, %rsi
	je	.L36
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movq	%rsi, %r13
	call	strlen
	movq	%rax, %rbx
	cmpq	$15, %rax
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
	.p2align 4,,15
.L48:
	.cfi_restore_state
	movzbl	0(%r13), %eax
	movb	%al, 16(%rbp)
	jmp	.L41
	.p2align 4,,15
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
	movl	$.LC0, %edi
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
	vxorps	%xmm0, %xmm0, %xmm0
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
	vmovups	%xmm0, (%rdi)
	movq	$0, 16(%rdi)
	testq	%rsi, %rsi
	je	.L50
	movabsq	$4611686018427387903, %rax
	cmpq	%rax, %rsi
	ja	.L56
	leaq	0(,%rsi,4), %rbx
	movq	%rbx, %rdi
	call	_Znwm
	movq	%rbx, %rdx
	xorl	%esi, %esi
	leaq	(%rax,%rbx), %r12
	movq	%rax, 0(%rbp)
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
	.p2align 4,,15
.L50:
	.cfi_restore_state
	xorl	%r12d, %r12d
	jmp	.L52
.L56:
	call	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE3181:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKS0_, .-_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.weak	_ZNSt6vectorIfSaIfEEC1EmRKS0_
	.set	_ZNSt6vectorIfSaIfEEC1EmRKS0_,_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"stoi"
.LC2:
	.string	"native"
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
	vmovsd	%xmm0, -624(%rbp)
	call	MPI_Comm_rank
	leaq	-572(%rbp), %rsi
	movl	$1140850688, %edi
	call	MPI_Comm_size
	leaq	-176(%rbp), %rdx
	leaq	-112(%rbp), %rdi
	movq	-592(%rbp), %rax
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
	movl	%eax, -616(%rbp)
	addq	$16, %rdx
	cmpq	%rdx, %rdi
	je	.L58
	call	_ZdlPv
.L58:
	movq	-592(%rbp), %rcx
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
	movl	%eax, -612(%rbp)
	addq	$16, %rbx
	cmpq	%rbx, %rdi
	je	.L59
	call	_ZdlPv
.L59:
	movl	-616(%rbp), %eax
	movl	$1431655766, %esi
	movl	-616(%rbp), %edi
	movq	$0, -536(%rbp)
	movl	-612(%rbp), %r8d
	movl	-572(%rbp), %r9d
	imull	%esi
	movl	-612(%rbp), %eax
	sarl	$31, %edi
	sarl	$31, %r8d
	movl	%edx, %r15d
	imull	%esi
	subl	%edi, %r15d
	movl	$2, %esi
	movl	%r15d, %edi
	movl	%r15d, %r12d
	movl	%edx, %r13d
	leaq	-536(%rbp), %rdx
	subl	%r8d, %r13d
	imull	%r13d, %edi
	cmpl	%r9d, %edi
	cmovg	%r9d, %edi
.LEHB7:
	call	MPI_Dims_create
	cmpl	%r15d, -536(%rbp)
	movl	$67108864, -568(%rbp)
	movq	$0, -528(%rbp)
	cmovle	-536(%rbp), %r12d
	cmpl	%r13d, -532(%rbp)
	movl	-576(%rbp), %r14d
	cmovle	-532(%rbp), %r13d
	movl	%r12d, -536(%rbp)
	movl	%r14d, -608(%rbp)
	movl	%r13d, %r11d
	movl	%r13d, -532(%rbp)
	imull	%r12d, %r11d
	movl	%r11d, -584(%rbp)
	cmpl	%r11d, %r14d
	jge	.L242
	movl	-608(%rbp), %edx
	leaq	-564(%rbp), %rcx
	xorl	%esi, %esi
	movl	$1140850688, %edi
	movq	%rcx, -656(%rbp)
	call	MPI_Comm_split
	movl	-564(%rbp), %edi
	leaq	-568(%rbp), %r9
	xorl	%r8d, %r8d
	leaq	-528(%rbp), %rcx
	leaq	-536(%rbp), %rdx
	movl	$2, %esi
	movq	$0, -520(%rbp)
	call	MPI_Cart_create
	movl	-568(%rbp), %edi
	leaq	-560(%rbp), %rsi
	call	MPI_Comm_rank
	movl	-560(%rbp), %esi
	movl	$2, %edx
	leaq	-520(%rbp), %rcx
	movl	-568(%rbp), %edi
	call	MPI_Cart_coords
	movl	-616(%rbp), %eax
	movl	-520(%rbp), %esi
	cltd
	idivl	-536(%rbp)
	movl	%eax, %r15d
	cmpl	%esi, %edx
	jg	.L243
	imull	%r15d, %esi
	movl	%esi, %edi
.L123:
	movl	-612(%rbp), %eax
	leal	(%rdx,%rdi), %r12d
	movl	-516(%rbp), %r13d
	movl	%r12d, -632(%rbp)
	cltd
	movl	%r13d, %r8d
	idivl	-532(%rbp)
	movl	%eax, %r14d
	imull	%eax, %r8d
	cmpl	%r13d, %edx
	jle	.L124
	incl	%r14d
	movl	%r13d, %edx
.L124:
	leal	2(%r15), %r12d
	leal	2(%r14), %r13d
	movl	%r15d, %r11d
	leal	(%rdx,%r8), %r9d
	movl	%r12d, %r10d
	imull	%r14d, %r11d
	movl	%r12d, -664(%rbp)
	movl	%r9d, -636(%rbp)
	imull	%r13d, %r10d
	movslq	%r11d, %rbx
	movslq	%r10d, %r12
	testq	%r12, %r12
	je	.L139
	movq	%r12, %rdi
	call	_Znwm
	movq	%r12, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, -600(%rbp)
	call	memset
	movl	$0, -628(%rbp)
	jmp	.L63
	.p2align 4,,15
.L242:
	movl	%r14d, %edx
	leaq	-564(%rbp), %rcx
	movl	$-32766, %esi
	movl	$1140850688, %edi
	movq	%rcx, -656(%rbp)
	xorl	%ebx, %ebx
	call	MPI_Comm_split
.LEHE7:
	movl	$2, %r13d
	movq	$0, -520(%rbp)
	movq	$0, -600(%rbp)
	xorl	%r14d, %r14d
	movl	$2, -664(%rbp)
	movl	$-32766, -628(%rbp)
	xorl	%r15d, %r15d
	movl	$0, -636(%rbp)
	movl	$0, -632(%rbp)
.L63:
	leaq	-112(%rbp), %rdx
	movq	%rbx, %rsi
	leaq	-496(%rbp), %rdi
.LEHB8:
	call	_ZNSt6vectorIfSaIfEEC1EmRKS0_
.LEHE8:
	leaq	-112(%rbp), %rdx
	movq	%rbx, %rsi
	leaq	-464(%rbp), %rdi
.LEHB9:
	call	_ZNSt6vectorIfSaIfEEC1EmRKS0_
.LEHE9:
.LEHB10:
	call	MPI_Wtime
	vsubsd	-624(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -432(%rbp)
	call	MPI_Wtime
	movq	-592(%rbp), %rbx
	leaq	-544(%rbp), %r8
	movl	$469762048, %ecx
	movl	$2, %edx
	movl	-568(%rbp), %edi
	vmovsd	%xmm0, -648(%rbp)
	movq	8(%rbx), %rsi
	call	MPI_File_open
	movl	-584(%rbp), %ecx
	cmpl	%ecx, -608(%rbp)
	jge	.L64
	movl	-616(%rbp), %esi
	movl	-612(%rbp), %edi
	subq	$8, %rsp
	leaq	-548(%rbp), %rbx
	movl	-636(%rbp), %r8d
	movl	-632(%rbp), %eax
	movl	$1275068731, %r9d
	leaq	-304(%rbp), %rcx
	pushq	%rbx
	leaq	-368(%rbp), %rdx
	movl	%r15d, -368(%rbp)
	movl	%r14d, -364(%rbp)
	movl	%esi, -504(%rbp)
	movl	%edi, -500(%rbp)
	leaq	-504(%rbp), %rsi
	movl	$2, %edi
	movl	%r8d, -300(%rbp)
	movl	$56, %r8d
	movl	%eax, -304(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r11
	popq	%r12
	movq	%rbx, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-664(%rbp), %edx
	movabsq	$4294967297, %r9
	subq	$8, %rsp
	leaq	-512(%rbp), %r10
	movq	%r9, -112(%rbp)
	pushq	%r10
	movl	$1275068731, %r9d
	movl	$56, %r8d
	leaq	-112(%rbp), %rcx
	leaq	-240(%rbp), %rsi
	movl	$2, %edi
	movl	%r13d, -236(%rbp)
	movl	%r15d, -176(%rbp)
	movl	%r14d, -172(%rbp)
	movl	%edx, -240(%rbp)
	leaq	-176(%rbp), %rdx
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r9
	popq	%r10
	leaq	-512(%rbp), %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-548(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC2, %r8d
	movl	$1275068731, %edx
	xorl	%esi, %esi
	call	MPI_File_set_view
	movl	-512(%rbp), %ecx
	movq	-600(%rbp), %rsi
	movl	$1, %r8d
	movl	$1, %edx
	movq	-544(%rbp), %rdi
	call	MPI_File_read_all
	movq	%rbx, %rdi
	call	MPI_Type_free
	leaq	-512(%rbp), %rdi
	call	MPI_Type_free
.L64:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm1
	vmovsd	%xmm1, -424(%rbp)
	call	MPI_Wtime
	movl	-584(%rbp), %r12d
	vmovsd	%xmm0, -648(%rbp)
	movl	$201326592, -556(%rbp)
	xorl	%ebx, %ebx
	cmpl	%r12d, -608(%rbp)
	jl	.L244
.L65:
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm2
	vmovsd	%xmm2, -416(%rbp)
	call	MPI_Wtime
	movl	-584(%rbp), %esi
	vmovsd	%xmm0, -648(%rbp)
	cmpl	%esi, -608(%rbp)
	jge	.L74
	cmpl	$2, %r15d
	jle	.L74
	cmpl	$2, %r14d
	jg	.L245
	.p2align 4,,15
.L74:
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm3
	vmovsd	%xmm3, -408(%rbp)
	call	MPI_Wtime
	movl	$1, %edx
	leaq	-368(%rbp), %rsi
	movl	%ebx, %edi
	vmovsd	%xmm0, -648(%rbp)
	call	MPI_Waitall
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm4
	vmovsd	%xmm4, -400(%rbp)
	call	MPI_Wtime
	movl	-584(%rbp), %ebx
	vmovsd	%xmm0, -648(%rbp)
	cmpl	%ebx, -608(%rbp)
	jge	.L75
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
	movl	-240(%rbp), %r8d
	movl	-176(%rbp), %r12d
	movl	-304(%rbp), %ebx
	movl	%r8d, -640(%rbp)
	incl	%r8d
	movl	%r12d, -680(%rbp)
	setne	-668(%rbp)
	incl	%r12d
	movl	-112(%rbp), %r12d
	setne	-664(%rbp)
	movzbl	-664(%rbp), %r9d
	cmpl	$-1, %r12d
	setne	-681(%rbp)
	cmpl	$-1, %ebx
	je	.L76
	testb	%r9b, %r9b
	jne	.L246
.L76:
	cmpl	$-1, %ebx
	jne	.L247
.L80:
	cmpl	$-1, -680(%rbp)
	je	.L83
.L135:
	cmpl	$-1, -640(%rbp)
	movl	%r15d, %r9d
	jne	.L84
	leal	1(%r15), %r9d
.L84:
	xorl	%edx, %edx
	cmpl	$-1, %ebx
	movq	-464(%rbp), %rcx
	movq	-600(%rbp), %rdi
	setne	%dl
	pushq	$2
	movl	%r13d, %esi
	pushq	$1
	leal	1(%rdx), %r8d
	movq	-496(%rbp), %rdx
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
	cmpl	$-1, %r12d
	je	.L86
.L125:
	cmpl	$-1, -640(%rbp)
	leal	1(%r14), %edi
	movl	%r15d, %r9d
	movl	%edi, -672(%rbp)
	jne	.L87
	leal	1(%r15), %r9d
.L87:
	xorl	%ecx, %ecx
	incl	%ebx
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	setne	%cl
	leal	1(%r14), %eax
	movl	%r13d, %esi
	leal	1(%rcx), %r8d
	movq	-464(%rbp), %rcx
	pushq	%rax
	pushq	%r14
	call	_Z5sobelPKhiPfS1_iiii
	cmpb	$0, -668(%rbp)
	popq	%r11
	popq	%rbx
	je	.L89
	cmpb	$0, -664(%rbp)
	je	.L89
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	leal	1(%r15), %ebx
	movl	%r15d, %r8d
	movq	-600(%rbp), %rdi
	pushq	$2
	movl	%ebx, %r9d
	movl	%r13d, %esi
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	movl	%r14d, %esi
	movl	$2, %r8d
	popq	%r10
.L90:
	movq	-600(%rbp), %rdi
	movq	-464(%rbp), %rcx
	movl	%ebx, %r9d
	movq	-496(%rbp), %rdx
	pushq	%rsi
	movl	%r13d, %esi
	pushq	%r8
	movl	%r15d, %r8d
	call	_Z5sobelPKhiPfS1_iiii
	cmpb	$0, -668(%rbp)
	popq	%rdi
	popq	%r8
	je	.L92
	cmpb	$0, -681(%rbp)
	jne	.L138
.L92:
	leaq	-556(%rbp), %rdi
	call	MPI_Type_free
.L75:
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm5
	vmovsd	%xmm5, -392(%rbp)
	call	MPI_Wtime
	movq	-592(%rbp), %r12
	leaq	-544(%rbp), %r8
	movl	$469762048, %ecx
	movl	$5, %edx
	movl	-568(%rbp), %edi
	vmovsd	%xmm0, -648(%rbp)
	movq	16(%r12), %rsi
	call	MPI_File_open
	movl	-584(%rbp), %r11d
	cmpl	%r11d, -608(%rbp)
	jge	.L94
	movl	-516(%rbp), %r12d
	movl	-616(%rbp), %ebx
	movl	%r14d, %esi
	movl	-612(%rbp), %edx
	movl	-536(%rbp), %edi
	movl	-532(%rbp), %ecx
	movl	-520(%rbp), %r13d
	subl	$2, %ebx
	subl	$2, %edx
	decl	%edi
	cmpl	$1, %r12d
	leal	-1(%rcx), %eax
	sbbl	$0, %esi
	movl	%r13d, -664(%rbp)
	movl	%edx, -612(%rbp)
	cmpl	%eax, %r12d
	sete	%r8b
	movzbl	%r8b, %r9d
	subl	%r9d, %esi
	movl	%esi, -616(%rbp)
	testl	%r13d, %r13d
	je	.L248
	cmpl	%edi, -664(%rbp)
	jne	.L249
	movl	-612(%rbp), %edi
	movl	-616(%rbp), %ecx
	leal	-1(%r15), %r13d
	movl	%ebx, -512(%rbp)
	movl	%r13d, -640(%rbp)
	movl	%r13d, -504(%rbp)
	movl	%edi, -508(%rbp)
	movl	%ecx, -500(%rbp)
.L129:
	movl	-632(%rbp), %edi
	decl	%edi
.L132:
	movl	%edi, -304(%rbp)
	xorl	%r13d, %r13d
	testl	%r12d, %r12d
	je	.L100
	movl	-636(%rbp), %r13d
	decl	%r13d
.L100:
	movl	%r13d, -300(%rbp)
	subq	$8, %rsp
	leaq	-552(%rbp), %r13
	movl	$1275069450, %r9d
	pushq	%r13
	movl	$56, %r8d
	leaq	-304(%rbp), %rcx
	leaq	-504(%rbp), %rdx
	leaq	-512(%rbp), %rsi
	movl	$2, %edi
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%rax
	popq	%rdx
	movq	%r13, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movslq	-612(%rbp), %rdi
	movslq	%ebx, %rbx
	movl	-664(%rbp), %eax
	xorl	%ecx, %ecx
	movl	%r15d, -240(%rbp)
	movl	%r14d, -236(%rbp)
	movl	-616(%rbp), %r15d
	movl	-640(%rbp), %r14d
	movl	$1275069450, %r9d
	movl	$56, %r8d
	leaq	-240(%rbp), %rsi
	imulq	%rdi, %rbx
	movl	$2, %edi
	movl	%r14d, -176(%rbp)
	movl	%r15d, -172(%rbp)
	salq	$2, %rbx
	testl	%eax, %eax
	sete	%cl
	xorl	%edx, %edx
	testl	%r12d, %r12d
	leaq	-548(%rbp), %r12
	sete	%dl
	subq	$8, %rsp
	movl	%ecx, -112(%rbp)
	leaq	-112(%rbp), %rcx
	movl	%edx, -108(%rbp)
	pushq	%r12
	leaq	-176(%rbp), %rdx
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r12
	popq	%r14
	leaq	-548(%rbp), %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-552(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC2, %r8d
	movl	$1275069450, %edx
	xorl	%esi, %esi
	call	MPI_File_set_view
	movl	-548(%rbp), %ecx
	movq	-496(%rbp), %rsi
	movl	$1, %r8d
	movl	$1, %edx
	movq	-544(%rbp), %rdi
	call	MPI_File_write_all
	movl	-552(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC2, %r8d
	movl	$1275069450, %edx
	movq	%rbx, %rsi
	call	MPI_File_set_view
	movl	-548(%rbp), %ecx
	movq	-464(%rbp), %rsi
	movl	$1, %r8d
	movl	$1, %edx
	movq	-544(%rbp), %rdi
	call	MPI_File_write_all
	movq	%r13, %rdi
	call	MPI_Type_free
	leaq	-548(%rbp), %rdi
	call	MPI_Type_free
.L94:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm6
	cmpl	$67108864, -568(%rbp)
	vmovsd	%xmm6, -384(%rbp)
	jne	.L101
.L104:
	cmpl	$67108864, -564(%rbp)
	je	.L103
	movq	-656(%rbp), %rdi
	call	MPI_Comm_free
.L103:
	movl	$1140850688, %edi
	call	MPI_Barrier
	call	MPI_Wtime
	vsubsd	-624(%rbp), %xmm0, %xmm7
	movl	-576(%rbp), %edx
	leaq	-548(%rbp), %rcx
	movl	$1140850688, %edi
	movl	-628(%rbp), %esi
	vmovsd	%xmm7, -376(%rbp)
	call	MPI_Comm_split
	movl	-584(%rbp), %esi
	cmpl	%esi, -608(%rbp)
	jge	.L106
	movl	-548(%rbp), %edi
	leaq	-512(%rbp), %rsi
	call	MPI_Comm_size
	movl	-548(%rbp), %r8d
	subq	$8, %rsp
	xorl	%r9d, %r9d
	movl	$1275070475, %ecx
	movl	$8, %edx
	leaq	-304(%rbp), %rsi
	leaq	-432(%rbp), %rdi
	pushq	%r8
	movl	$1476395010, %r8d
	.cfi_escape 0x2e,0x10
	call	MPI_Reduce
	movl	-548(%rbp), %r9d
	movl	$1476395009, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	leaq	-240(%rbp), %rsi
	leaq	-432(%rbp), %rdi
	movl	%r9d, (%rsp)
	xorl	%r9d, %r9d
	call	MPI_Reduce
	movl	-548(%rbp), %r10d
	xorl	%r9d, %r9d
	movl	$1476395011, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	leaq	-176(%rbp), %rsi
	leaq	-432(%rbp), %rdi
	movl	%r10d, (%rsp)
	call	MPI_Reduce
	popq	%r11
	leaq	-504(%rbp), %rsi
	popq	%rbx
	movl	-548(%rbp), %edi
	.cfi_escape 0x2e,0
	call	MPI_Comm_rank
	cmpl	$0, -504(%rbp)
	je	.L250
.L107:
	leaq	-548(%rbp), %rdi
	call	MPI_Comm_free
.L106:
	call	MPI_Finalize
	movq	-464(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L109
	call	_ZdlPv
.L109:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L110
	call	_ZdlPv
.L110:
	movq	-600(%rbp), %r15
	testq	%r15, %r15
	je	.L235
	movq	%r15, %rdi
	call	_ZdlPv
.L235:
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
.L248:
	.cfi_restore_state
	leal	-1(%r15), %eax
	movl	%eax, -640(%rbp)
	testl	%edi, %edi
	je	.L251
	movl	-612(%rbp), %edx
	leal	-1(%r15), %esi
	movl	%ebx, -512(%rbp)
	xorl	%edi, %edi
	movl	-616(%rbp), %r8d
	movl	%esi, -504(%rbp)
	movl	%edx, -508(%rbp)
	movl	%r8d, -500(%rbp)
	jmp	.L132
.L243:
	movl	%esi, %edi
	incl	%r15d
	movl	%esi, %edx
	imull	%eax, %edi
	jmp	.L123
.L250:
	movq	$.LC3, -608(%rbp)
	movl	$.LC10, %edi
	movl	$.LC4, %r11d
	movl	$.LC6, %r13d
	vmovq	-608(%rbp), %xmm8
	movq	$.LC5, -608(%rbp)
	movl	$.LC8, %ebx
	vpinsrq	$1, %r11, %xmm8, %xmm9
	vmovq	-608(%rbp), %xmm10
	movq	$.LC7, -608(%rbp)
	vpinsrq	$1, %r13, %xmm10, %xmm11
	movl	$.LC11, %r8d
	vmovq	-608(%rbp), %xmm12
	movq	$.LC9, -608(%rbp)
	vpinsrq	$1, %rbx, %xmm12, %xmm13
	movl	$.LC12, %ecx
	vmovq	-608(%rbp), %xmm14
	movl	$.LC13, %edx
	vpinsrq	$1, %rdi, %xmm14, %xmm15
	movl	$.LC14, %esi
	movl	$.LC15, %edi
	xorl	%eax, %eax
	vmovaps	%xmm9, -112(%rbp)
	vmovaps	%xmm11, -96(%rbp)
	vmovaps	%xmm13, -80(%rbp)
	vmovaps	%xmm15, -64(%rbp)
	call	printf
	xorl	%r14d, %r14d
	.p2align 4,,15
.L108:
	vmovsd	-176(%rbp,%r14), %xmm1
	vxorps	%xmm0, %xmm0, %xmm0
	vmovsd	-304(%rbp,%r14), %xmm3
	movl	$.LC16, %edi
	vcvtsi2sd	-512(%rbp), %xmm0, %xmm0
	movq	-112(%rbp,%r14), %rsi
	movl	$3, %eax
	vdivsd	%xmm0, %xmm1, %xmm2
	vmovsd	-240(%rbp,%r14), %xmm1
	vmovaps	%xmm3, %xmm0
	vmovsd	%xmm3, -608(%rbp)
	call	printf
	addq	$8, %r14
	cmpq	$64, %r14
	jne	.L108
	jmp	.L107
.L86:
	cmpb	$0, -668(%rbp)
	je	.L89
	cmpb	$0, -664(%rbp)
	jne	.L136
.L89:
	cmpl	$-1, -640(%rbp)
	je	.L92
	incl	%r12d
	je	.L238
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	leal	1(%r15), %ebx
	movl	%r13d, %esi
	movq	-600(%rbp), %rdi
	pushq	%r14
	movl	%ebx, %r9d
	movl	%r15d, %r8d
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	leal	1(%r14), %r9d
	popq	%rsi
	movl	%r9d, -672(%rbp)
.L138:
	movl	-672(%rbp), %r10d
	movl	%r13d, %esi
	movl	%ebx, %r9d
	movl	%r15d, %r8d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	pushq	%r10
	pushq	%r14
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
	jmp	.L92
.L101:
	leaq	-568(%rbp), %rdi
	call	MPI_Comm_free
	jmp	.L104
.L244:
	leaq	-556(%rbp), %r8
	movl	$1275068731, %ecx
	movl	%r13d, %edx
	movl	$1, %esi
	movl	%r15d, %edi
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
	leaq	-568(%rbp), %rsi
	orl	$-1, %edx
	leaq	-520(%rbp), %r11
	leaq	-536(%rbp), %rcx
	movq	%rsi, -96(%rbp)
	leaq	-112(%rbp), %rdi
	movl	%edx, %esi
	movq	%r11, -112(%rbp)
	movq	%rcx, -104(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	movl	$1, %edx
	orl	$-1, %esi
	leaq	-112(%rbp), %rdi
	movl	%eax, -664(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	orl	$-1, %edx
	movl	$1, %esi
	leaq	-112(%rbp), %rdi
	movl	%eax, %r12d
	call	_ZZ4mainENKUliiE_clEii
	movl	$1, %edx
	movl	$1, %esi
	leaq	-112(%rbp), %rdi
	movl	%eax, -640(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	movl	-504(%rbp), %ecx
	movl	%eax, -668(%rbp)
	cmpl	$-1, %ecx
	je	.L66
	movq	-600(%rbp), %rdi
	movl	-568(%rbp), %r9d
	subq	$8, %rsp
	leaq	-368(%rbp), %rbx
	pushq	%rbx
	movl	$10, %r8d
	movl	$1275068731, %edx
	movl	%r14d, %esi
	leaq	1(%rdi), %rdi
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	leal	3(%r14), %eax
	movl	-568(%rbp), %r9d
	movl	-504(%rbp), %ecx
	addq	$4, %rbx
	movslq	%eax, %rdi
	addq	-600(%rbp), %rdi
	movl	$11, %r8d
	movl	$1275068731, %edx
	movl	%r14d, %esi
	movq	%rbx, (%rsp)
	call	MPI_Isend
	popq	%rdi
	popq	%r8
	movl	$2, %ebx
.L66:
	movl	-304(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L67
	leal	1(%r15), %r9d
	movslq	%ebx, %r8
	leaq	-368(%rbp), %rax
	subq	$8, %rsp
	imull	%r13d, %r9d
	leaq	0(,%r8,4), %rdx
	movl	%r14d, %esi
	movl	$11, %r8d
	addq	%rdx, %rax
	movq	%rdx, -680(%rbp)
	movl	$1275068731, %edx
	pushq	%rax
	leal	1(%r9), %r10d
	movl	%r9d, -672(%rbp)
	movl	-568(%rbp), %r9d
	movslq	%r10d, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	movl	-672(%rbp), %ecx
	movq	-680(%rbp), %r8
	addl	$2, %ebx
	movl	-568(%rbp), %r9d
	subl	%r13d, %ecx
	leaq	-364(%rbp,%r8), %rdx
	movl	$10, %r8d
	leal	1(%rcx), %esi
	movl	-304(%rbp), %ecx
	movq	%rdx, (%rsp)
	movl	$1275068731, %edx
	movslq	%esi, %rdi
	addq	-600(%rbp), %rdi
	movl	%r14d, %esi
	call	MPI_Isend
	popq	%rcx
	popq	%rsi
.L67:
	movl	-240(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L68
	movslq	%ebx, %rdi
	leaq	-368(%rbp), %rax
	movl	-556(%rbp), %edx
	subq	$8, %rsp
	leaq	0(,%rdi,4), %r9
	movslq	%r13d, %rdi
	addq	-600(%rbp), %rdi
	movl	$20, %r8d
	addq	%r9, %rax
	movq	%r9, -680(%rbp)
	movl	-568(%rbp), %r9d
	movl	$1, %esi
	pushq	%rax
	call	MPI_Irecv
	movq	-680(%rbp), %rcx
	leal	3(%r14), %r11d
	movl	-568(%rbp), %r9d
	movl	$21, %r8d
	movslq	%r11d, %rdi
	addq	-600(%rbp), %rdi
	movl	-556(%rbp), %edx
	addl	$2, %ebx
	leaq	-364(%rbp,%rcx), %rsi
	movl	-240(%rbp), %ecx
	movq	%rsi, (%rsp)
	movl	$1, %esi
	call	MPI_Isend
	popq	%rax
	popq	%rdx
.L68:
	movl	-176(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L69
	movslq	%ebx, %r8
	leal	1(%r13,%r14), %edi
	leaq	-368(%rbp), %rax
	movl	-568(%rbp), %r9d
	leaq	0(,%r8,4), %rdx
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	subq	$8, %rsp
	addq	%rdx, %rax
	movq	%rdx, -680(%rbp)
	movl	-556(%rbp), %edx
	movl	$21, %r8d
	pushq	%rax
	movl	$1, %esi
	call	MPI_Irecv
	movq	-680(%rbp), %r11
	leal	(%r14,%r13), %r10d
	movl	-568(%rbp), %r9d
	movl	$20, %r8d
	movslq	%r10d, %rdi
	addq	-600(%rbp), %rdi
	movl	-556(%rbp), %edx
	movl	$1, %esi
	addl	$2, %ebx
	leaq	-364(%rbp,%r11), %rcx
	movq	%rcx, (%rsp)
	movl	-176(%rbp), %ecx
	call	MPI_Isend
	popq	%r11
	popq	%rax
.L69:
	movl	-664(%rbp), %edx
	cmpl	$-1, %edx
	je	.L70
	movslq	%ebx, %rcx
	movl	-568(%rbp), %r9d
	movq	-600(%rbp), %rdi
	leaq	-368(%rbp), %rax
	salq	$2, %rcx
	subq	$8, %rsp
	movl	$30, %r8d
	movl	$1, %esi
	addq	%rcx, %rax
	movq	%rcx, -680(%rbp)
	movl	%edx, %ecx
	movl	$1275068731, %edx
	pushq	%rax
	call	MPI_Irecv
	movq	-680(%rbp), %r9
	leal	3(%r14), %edi
	movl	-664(%rbp), %ecx
	movl	$33, %r8d
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$2, %ebx
	leaq	-364(%rbp,%r9), %r10
	movl	-568(%rbp), %r9d
	movq	%r10, (%rsp)
	call	MPI_Isend
	popq	%r9
	popq	%r10
.L70:
	cmpl	$-1, %r12d
	je	.L71
	leal	1(%r14), %ecx
	movslq	%ebx, %r11
	movl	-568(%rbp), %r9d
	leaq	-368(%rbp), %rax
	movslq	%ecx, %rdi
	addq	-600(%rbp), %rdi
	leaq	0(,%r11,4), %rdx
	subq	$8, %rsp
	addq	%rdx, %rax
	movq	%rdx, -664(%rbp)
	movl	$31, %r8d
	pushq	%rax
	movl	%r12d, %ecx
	movl	$1275068731, %edx
	movl	$1, %esi
	call	MPI_Irecv
	movq	-664(%rbp), %r9
	leal	(%r14,%r13), %r8d
	movl	%r12d, %ecx
	movl	$1275068731, %edx
	movslq	%r8d, %rdi
	addq	-600(%rbp), %rdi
	movl	$32, %r8d
	movl	$1, %esi
	addl	$2, %ebx
	leaq	-364(%rbp,%r9), %r10
	movl	-568(%rbp), %r9d
	movq	%r10, (%rsp)
	call	MPI_Isend
	popq	%rdi
	popq	%r8
.L71:
	movl	-640(%rbp), %r11d
	cmpl	$-1, %r11d
	je	.L72
	leal	1(%r15), %edi
	movslq	%ebx, %r12
	movl	-568(%rbp), %r9d
	leaq	-368(%rbp), %rdx
	imull	%r13d, %edi
	salq	$2, %r12
	subq	$8, %rsp
	movl	$32, %r8d
	leaq	(%rdx,%r12), %rcx
	movl	$1, %esi
	movl	$1275068731, %edx
	pushq	%rcx
	movl	%r11d, %ecx
	movl	%edi, -664(%rbp)
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	movl	-664(%rbp), %eax
	movl	-568(%rbp), %r9d
	leaq	-364(%rbp,%r12), %r8
	movl	$1275068731, %edx
	movl	-640(%rbp), %ecx
	movq	%r8, (%rsp)
	movl	$31, %r8d
	addl	$2, %ebx
	subl	%r13d, %eax
	leal	1(%rax), %esi
	movslq	%esi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	call	MPI_Isend
	popq	%rcx
	popq	%rsi
.L72:
	movl	-668(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L65
	leal	1(%r15), %r9d
	movslq	%ebx, %r12
	leaq	-368(%rbp), %r11
	subq	$8, %rsp
	imull	%r13d, %r9d
	salq	$2, %r12
	movl	$33, %r8d
	movl	$1, %esi
	leaq	(%r11,%r12), %rdx
	pushq	%rdx
	movl	$1275068731, %edx
	leal	1(%r9,%r14), %r10d
	movl	%r9d, -664(%rbp)
	movl	-568(%rbp), %r9d
	movslq	%r10d, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	movl	-664(%rbp), %edi
	movl	-568(%rbp), %r9d
	leaq	-364(%rbp,%r12), %rax
	movl	$30, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$2, %ebx
	movq	%rax, (%rsp)
	subl	%r13d, %edi
	leal	(%rdi,%r14), %ecx
	movslq	%ecx, %rdi
	addq	-600(%rbp), %rdi
	movl	-668(%rbp), %ecx
	call	MPI_Isend
.LEHE10:
	popq	%rax
	popq	%rdx
	jmp	.L65
.L246:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	$2, %r9d
	movl	$1, %r8d
	movq	-600(%rbp), %rdi
	pushq	$2
	movl	%r13d, %esi
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	cmpl	$-1, %r12d
	je	.L78
	pushq	%r14
	pushq	$2
.L237:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	$2, %r9d
	movl	$1, %r8d
	movq	-600(%rbp), %rdi
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	leal	1(%r14), %r11d
	movl	$1, %r8d
	popq	%rsi
	movq	-600(%rbp), %rdi
	movl	$2, %r9d
	movl	%r13d, %esi
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	pushq	%r11
	pushq	%r14
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L80
.L247:
	cmpl	$-1, %r12d
	je	.L78
	pushq	%r14
	pushq	$1
	jmp	.L237
.L245:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	%r15d, %r9d
	movl	$2, %r8d
	movq	-600(%rbp), %rdi
	pushq	%r14
	movl	%r13d, %esi
	pushq	$2
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r11
	popq	%r12
	jmp	.L74
.L83:
	cmpl	$-1, %r12d
	jne	.L125
.L230:
	cmpl	$-1, -640(%rbp)
	je	.L92
.L238:
	leal	1(%r15), %ebx
.L128:
	xorl	%r8d, %r8d
	cmpl	$-1, -680(%rbp)
	leal	1(%r14), %edx
	movl	%edx, -672(%rbp)
	movl	%edx, %esi
	setne	%r8b
	incl	%r8d
	jmp	.L90
.L139:
	movq	$0, -600(%rbp)
	movl	$0, -628(%rbp)
	jmp	.L63
.L78:
	cmpl	$-1, -680(%rbp)
	leal	1(%r14), %r10d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	je	.L252
	movq	-600(%rbp), %rdi
	pushq	%r10
	movl	$2, %r9d
	movl	$1, %r8d
	pushq	$2
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L135
.L249:
	movl	-612(%rbp), %r10d
	movl	-616(%rbp), %r11d
	movl	%ebx, -512(%rbp)
	movl	%r15d, -504(%rbp)
	movl	%r15d, -640(%rbp)
	movl	%r10d, -508(%rbp)
	movl	%r11d, -500(%rbp)
	jmp	.L129
.L252:
	movq	-600(%rbp), %rdi
	pushq	%r10
	movl	$2, %r9d
	movl	$1, %r8d
	pushq	$1
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
	jmp	.L230
.L136:
	movq	-600(%rbp), %rdi
	movq	-464(%rbp), %rcx
	leal	1(%r15), %ebx
	movl	%r15d, %r8d
	movq	-496(%rbp), %rdx
	pushq	$2
	movl	%ebx, %r9d
	movl	%r13d, %esi
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L128
.L153:
	movq	-464(%rbp), %rdi
	movq	%rax, %r12
	testq	%rdi, %rdi
	je	.L234
	vzeroupper
	call	_ZdlPv
.L118:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L120
	call	_ZdlPv
.L120:
	movq	-600(%rbp), %rcx
	testq	%rcx, %rcx
	je	.L121
	movq	%rcx, %rdi
	call	_ZdlPv
.L121:
	movq	%r12, %rdi
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L234:
	vzeroupper
	jmp	.L118
.L150:
.L241:
	movq	-112(%rbp), %rdi
	movq	%rax, %r12
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L233
	vzeroupper
	call	_ZdlPv
	jmp	.L121
.L151:
	movq	%rax, %r12
	vzeroupper
	jmp	.L120
.L149:
	jmp	.L241
.L152:
	movq	%rax, %r12
	vzeroupper
	jmp	.L118
.L251:
	movl	-612(%rbp), %r10d
	movl	-616(%rbp), %r11d
	leal	-2(%r15), %r9d
	movl	%ebx, -512(%rbp)
	movl	%r9d, -640(%rbp)
	movl	%r9d, -504(%rbp)
	movl	%r10d, -508(%rbp)
	movl	%r11d, -500(%rbp)
	jmp	.L132
.L233:
	vzeroupper
	jmp	.L121
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
	.uleb128 .L149-.LFB2870
	.uleb128 0
	.uleb128 .LEHB5-.LFB2870
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB2870
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L150-.LFB2870
	.uleb128 0
	.uleb128 .LEHB7-.LFB2870
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB8-.LFB2870
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L151-.LFB2870
	.uleb128 0
	.uleb128 .LEHB9-.LFB2870
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L152-.LFB2870
	.uleb128 0
	.uleb128 .LEHB10-.LFB2870
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L153-.LFB2870
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
	.hidden	__dso_handle
	.ident	"GCC: (SUSE Linux) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
