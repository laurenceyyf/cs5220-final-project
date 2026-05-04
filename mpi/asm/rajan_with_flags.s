	.file	"mpi_2d.cpp"
	.text
	.align 2
	.p2align 4,,15
	.type	_ZZ4mainENKUliiE_clEii, @function
_ZZ4mainENKUliiE_clEii:
.LFB7613:
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
.LFE7613:
	.size	_ZZ4mainENKUliiE_clEii, .-_ZZ4mainENKUliiE_clEii
	.p2align 4,,15
	.globl	_Z5sobelPKhiPfS1_iiii
	.type	_Z5sobelPKhiPfS1_iiii, @function
_Z5sobelPKhiPfS1_iiii:
.LFB7610:
	.cfi_startproc
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp
	movl	%r8d, %eax
	pushq	-8(%r10)
	pushq	%rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	pushq	%rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	movq	%rdx, %rbx
	movq	%rcx, %rdx
	subq	$160, %rsp
	movl	%r8d, -92(%rbp)
	movl	8(%r10), %ecx
	movl	(%r10), %r8d
	movq	%rdi, -112(%rbp)
	movl	%esi, -140(%rbp)
	movl	%r9d, -144(%rbp)
	movl	%r8d, -104(%rbp)
	movl	%ecx, -148(%rbp)
	cmpl	%r9d, %eax
	jge	.L21
	movslq	%esi, %r14
	movl	%eax, %r11d
	decl	%eax
	leal	-7(%rcx), %r15d
	leal	-2(%r14), %r13d
	vmovaps	.LC0(%rip), %ymm5
	imull	%r14d, %r11d
	movl	%ecx, %r10d
	imull	%r13d, %eax
	leaq	1(%rdi,%r14), %rdi
	movl	%r15d, -152(%rbp)
	movl	%r13d, -160(%rbp)
	movq	%rbx, %r12
	movl	%r11d, -100(%rbp)
	leal	-1(%r10), %r11d
	movl	%eax, -96(%rbp)
	leal	-8(%rcx), %eax
	subl	%r8d, %eax
	shrl	$3, %eax
	movl	%eax, %ecx
	leal	8(%r8,%rax,8), %r9d
	salq	$3, %rcx
	cmpl	%r15d, %r8d
	cmovge	%r8d, %r9d
	movq	%rcx, -168(%rbp)
	movslq	%r9d, %r8
	subl	%r8d, %r11d
	addq	%r8, %rdi
	movl	%r8d, -156(%rbp)
	movq	%r8, -176(%rbp)
	addq	%rdi, %r11
	movq	%r11, -184(%rbp)
	movq	%rdx, %r11
	.p2align 4,,15
.L17:
	movl	-152(%rbp), %ebx
	cmpl	%ebx, -104(%rbp)
	jge	.L14
	movslq	-104(%rbp), %rsi
	movslq	-100(%rbp), %rdx
	movq	%r14, %r13
	vxorps	%xmm6, %xmm6, %xmm6
	vmovaps	.LC5(%rip), %ymm7
	notq	%r13
	movq	-168(%rbp), %rcx
	movslq	-96(%rbp), %r10
	addq	%rsi, %r13
	addq	%rdx, %r13
	addq	-112(%rbp), %r13
	leaq	8(%rcx,%rsi), %r9
	leaq	(%r10,%rsi), %rax
	addq	%r10, %r9
	salq	$2, %rax
	salq	$2, %r9
	.p2align 4,,15
.L15:
	vxorps	%xmm3, %xmm3, %xmm3
	vpinsrq	$0, 0(%r13), %xmm3, %xmm4
	vpinsrq	$0, 0(%r13,%r14), %xmm3, %xmm2
	vpinsrq	$0, 2(%r13,%r14), %xmm3, %xmm0
	vpinsrq	$0, 1(%r13), %xmm3, %xmm10
	vpinsrq	$0, 2(%r13), %xmm3, %xmm1
	vpinsrq	$0, 0(%r13,%r14,2), %xmm3, %xmm9
	vpmovzxbd	%xmm4, %ymm11
	vpinsrq	$0, 1(%r13,%r14,2), %xmm3, %xmm4
	vpinsrq	$0, 2(%r13,%r14,2), %xmm3, %xmm3
	vpmovzxbd	%xmm2, %ymm8
	vpmovzxbd	%xmm0, %ymm14
	vpmovzxbd	%xmm10, %ymm12
	addq	$8, %r13
	vpsubd	%ymm8, %ymm14, %ymm10
	vpmovzxbd	%xmm1, %ymm13
	vpmovzxbd	%xmm9, %ymm15
	vpslld	$1, %ymm12, %ymm12
	vpslld	$1, %ymm10, %ymm2
	vpaddd	%ymm13, %ymm2, %ymm0
	vpmovzxbd	%xmm3, %ymm9
	vpmovzxbd	%xmm4, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm14
	vpslld	$1, %ymm1, %ymm8
	vpsubd	%ymm11, %ymm14, %ymm4
	vpsubd	%ymm11, %ymm15, %ymm11
	vpsubd	%ymm15, %ymm4, %ymm1
	vpaddd	%ymm9, %ymm8, %ymm15
	vcvtdq2ps	%ymm1, %ymm10
	vpaddd	%ymm15, %ymm11, %ymm3
	vmovaps	.LC1(%rip), %ymm1
	vpsubd	%ymm12, %ymm3, %ymm9
	vpsubd	%ymm13, %ymm9, %ymm13
	vcvtdq2ps	%ymm13, %ymm12
	vmulps	%ymm10, %ymm10, %ymm2
	vandnps	%ymm10, %ymm5, %ymm0
	vcmpps	$17, %ymm6, %ymm10, %ymm10
	vandnps	%ymm12, %ymm5, %ymm14
	vfmadd231ps	%ymm12, %ymm12, %ymm2
	vandps	%ymm5, %ymm12, %ymm12
	vcmpps	$30, %ymm0, %ymm14, %ymm11
	vblendvps	%ymm11, %ymm14, %ymm0, %ymm3
	vblendvps	%ymm11, %ymm0, %ymm14, %ymm15
	vcmpps	$12, %ymm6, %ymm3, %ymm4
	vblendvps	%ymm4, %ymm3, %ymm1, %ymm9
	vmovaps	.LC2(%rip), %ymm3
	vmovaps	.LC4(%rip), %ymm4
	vrcpps	%ymm9, %ymm13
	vsqrtps	%ymm2, %ymm8
	vaddps	%ymm13, %ymm13, %ymm0
	vmovups	%xmm8, -4(%r12,%rax)
	vmulps	%ymm9, %ymm13, %ymm2
	vextractf128	$0x1, %ymm8, 12(%r12,%rax)
	vmulps	%ymm2, %ymm13, %ymm8
	vsubps	%ymm8, %ymm0, %ymm14
	vmulps	%ymm14, %ymm15, %ymm15
	vfmadd213ps	.LC3(%rip), %ymm15, %ymm3
	vmulps	%ymm3, %ymm15, %ymm1
	vsubps	%ymm1, %ymm4, %ymm9
	vblendvps	%ymm11, %ymm9, %ymm1, %ymm11
	vsubps	%ymm11, %ymm7, %ymm13
	vblendvps	%ymm10, %ymm13, %ymm11, %ymm10
	vxorps	%ymm12, %ymm10, %ymm2
	vmovups	%xmm2, -4(%r11,%rax)
	vextractf128	$0x1, %ymm2, 12(%r11,%rax)
	addq	$32, %rax
	cmpq	%rax, %r9
	jne	.L15
.L14:
	movl	-156(%rbp), %r8d
	cmpl	%r8d, -148(%rbp)
	jle	.L12
	movq	-176(%rbp), %rdx
	movslq	-96(%rbp), %r15
	movq	%r12, -120(%rbp)
	movq	%r14, -136(%rbp)
	movq	%r11, -128(%rbp)
	movslq	-100(%rbp), %rsi
	movq	-112(%rbp), %rdi
	addq	%rdx, %r15
	leaq	(%r14,%rdx), %r13
	leaq	-4(,%r15,4), %r10
	movq	%r14, %r15
	notq	%r15
	leaq	1(%rsi,%rdx), %rbx
	addq	%rsi, %r13
	leaq	(%r12,%r10), %rax
	addq	%rdx, %r15
	addq	%r11, %r10
	addq	%rdi, %rbx
	addq	%rdi, %r13
	addq	%rsi, %r15
	addq	-184(%rbp), %rsi
	movq	%r10, %r12
	movq	%rax, %r14
	addq	%rdi, %r15
	movq	%rsi, -88(%rbp)
	.p2align 4,,15
.L16:
	movzbl	2(%r15), %r11d
	vmovaps	%ymm5, -80(%rbp)
	vxorps	%xmm0, %xmm0, %xmm0
	vxorps	%xmm5, %xmm5, %xmm5
	movzbl	(%r15), %ecx
	vxorps	%xmm1, %xmm1, %xmm1
	movzbl	1(%r15), %eax
	movzbl	-2(%rbx), %esi
	movzbl	(%rbx), %edi
	movzbl	-1(%r13), %r9d
	movl	%r11d, %edx
	movzbl	1(%r13), %r8d
	subl	%ecx, %edx
	negl	%ecx
	addl	%eax, %eax
	addl	%esi, %esi
	subl	%eax, %ecx
	subl	%esi, %edx
	subl	%r11d, %ecx
	movzbl	0(%r13), %r11d
	leal	(%rdx,%rdi,2), %r10d
	subl	%r9d, %r10d
	addl	%ecx, %r9d
	addl	%r8d, %r10d
	vcvtsi2ss	%r10d, %xmm1, %xmm1
	leal	(%r9,%r11,2), %ecx
	movl	%r10d, %r9d
	addl	%ecx, %r8d
	imull	%r10d, %r9d
	movl	%r8d, %edx
	vcvtsi2ss	%r8d, %xmm0, %xmm0
	imull	%r8d, %edx
	addl	%edx, %r9d
	vcvtsi2ss	%r9d, %xmm5, %xmm5
	vsqrtss	%xmm5, %xmm7, %xmm7
	vmovss	%xmm7, (%r14)
	vzeroupper
	call	atan2f
	incq	%rbx
	incq	%r13
	addq	$4, %r14
	vmovss	%xmm0, (%r12)
	incq	%r15
	addq	$4, %r12
	cmpq	%r13, -88(%rbp)
	vmovaps	-80(%rbp), %ymm5
	jne	.L16
	movq	-120(%rbp), %r12
	movq	-128(%rbp), %r11
	movq	-136(%rbp), %r14
.L12:
	incl	-92(%rbp)
	movl	-140(%rbp), %r13d
	movl	-160(%rbp), %r15d
	addl	%r13d, -100(%rbp)
	movl	-92(%rbp), %ebx
	addl	%r15d, -96(%rbp)
	cmpl	%ebx, -144(%rbp)
	jne	.L17
	vzeroupper
.L21:
	addq	$160, %rsp
	popq	%rbx
	popq	%r8
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	leaq	-8(%r8), %rsp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7610:
	.size	_Z5sobelPKhiPfS1_iiii, .-_Z5sobelPKhiPfS1_iiii
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.p2align 4,,15
	.weak	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.type	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, @function
_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_:
.LFB7680:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7680
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
	je	.L40
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L25
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L25
	testq	%r12, %r12
	je	.L27
	subq	%rbp, %r8
	movq	%r8, (%r12)
.L27:
	testl	%esi, %esi
	jne	.L38
	movl	%r13d, (%rbx)
.L38:
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
.L25:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZSt20__throw_out_of_rangePKc
.LEHE0:
.L31:
	cmpl	$0, (%rbx)
	jne	.L30
	movl	%r13d, (%rbx)
.L30:
	movq	%rax, %rdi
	vzeroupper
.LEHB1:
	call	_Unwind_Resume
.LEHE1:
.L40:
	movq	%r14, %rdi
.LEHB2:
	call	_ZSt24__throw_invalid_argumentPKc
.LEHE2:
	.cfi_endproc
.LFE7680:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"aG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
.LLSDA7680:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7680-.LLSDACSB7680
.LLSDACSB7680:
	.uleb128 .LEHB0-.LFB7680
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L31-.LFB7680
	.uleb128 0
	.uleb128 .LEHB1-.LFB7680
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB7680
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L31-.LFB7680
	.uleb128 0
.LLSDACSE7680:
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.size	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, .-_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.section	.rodata._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.str1.8,"aMS",@progbits,1
	.align 8
.LC6:
	.string	"basic_string::_M_construct null not valid"
	.section	.text._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_,"axG",@progbits,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC5EPKcRKS3_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_, @function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_:
.LFB7902:
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
	je	.L42
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movq	%rsi, %r13
	call	strlen
	movq	%rax, %rbx
	cmpq	$15, %rax
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
	.p2align 4,,15
.L54:
	.cfi_restore_state
	movzbl	0(%r13), %eax
	movb	%al, 16(%rbp)
	jmp	.L47
	.p2align 4,,15
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
	movl	$.LC6, %edi
	call	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE7902:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_, .-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_
	.set	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1EPKcRKS3_,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_
	.section	.text._ZNSt6vectorIfSaIfEEC2EmRKS0_,"axG",@progbits,_ZNSt6vectorIfSaIfEEC5EmRKS0_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.type	_ZNSt6vectorIfSaIfEEC2EmRKS0_, @function
_ZNSt6vectorIfSaIfEEC2EmRKS0_:
.LFB7923:
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
	je	.L56
	movabsq	$4611686018427387903, %rax
	cmpq	%rax, %rsi
	ja	.L62
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
.L58:
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
.L56:
	.cfi_restore_state
	xorl	%r12d, %r12d
	jmp	.L58
.L62:
	call	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE7923:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKS0_, .-_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.weak	_ZNSt6vectorIfSaIfEEC1EmRKS0_
	.set	_ZNSt6vectorIfSaIfEEC1EmRKS0_,_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"stoi"
.LC8:
	.string	"native"
.LC9:
	.string	"Setup"
.LC10:
	.string	"Read file"
.LC11:
	.string	"Send requests"
.LC12:
	.string	"Local comp"
.LC13:
	.string	"Wait on resps"
.LC14:
	.string	"Compute received"
.LC15:
	.string	"Write out"
.LC16:
	.string	"Total"
.LC17:
	.string	"Avg(s)"
.LC18:
	.string	"Max(s)"
.LC19:
	.string	"Min(s)"
.LC20:
	.string	"Section"
.LC21:
	.string	"%-20s;%10s;%10s;%10s\n"
.LC22:
	.string	"%-20s;%10.6f;%10.6f;%10.6f\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB7612:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7612
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
	movl	$.LC7, %esi
	movl	$__isoc23_strtol, %edi
.LEHB4:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE4:
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rdx
	movl	%eax, -616(%rbp)
	addq	$16, %rdx
	cmpq	%rdx, %rdi
	je	.L64
	call	_ZdlPv
.L64:
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
	movl	$.LC7, %esi
	movl	$__isoc23_strtol, %edi
.LEHB6:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE6:
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rbx
	movl	%eax, -612(%rbp)
	addq	$16, %rbx
	cmpq	%rbx, %rdi
	je	.L65
	call	_ZdlPv
.L65:
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
	jge	.L248
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
	jg	.L249
	imull	%r15d, %esi
	movl	%esi, %edi
.L129:
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
	jle	.L130
	incl	%r14d
	movl	%r13d, %edx
.L130:
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
	je	.L145
	movq	%r12, %rdi
	call	_Znwm
	movq	%r12, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, -600(%rbp)
	call	memset
	movl	$0, -628(%rbp)
	jmp	.L69
	.p2align 4,,15
.L248:
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
.L69:
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
	jge	.L70
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
	movl	$.LC8, %r8d
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
.L70:
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
	jl	.L250
.L71:
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm2
	vmovsd	%xmm2, -416(%rbp)
	call	MPI_Wtime
	movl	-584(%rbp), %esi
	vmovsd	%xmm0, -648(%rbp)
	cmpl	%esi, -608(%rbp)
	jge	.L80
	cmpl	$2, %r15d
	jle	.L80
	cmpl	$2, %r14d
	jle	.L80
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
.L80:
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
	jge	.L81
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
	je	.L82
	testb	%r9b, %r9b
	jne	.L251
.L82:
	cmpl	$-1, %ebx
	jne	.L252
.L86:
	cmpl	$-1, -680(%rbp)
	je	.L89
.L141:
	cmpl	$-1, -640(%rbp)
	movl	%r15d, %r9d
	jne	.L90
	leal	1(%r15), %r9d
.L90:
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
	je	.L92
.L131:
	cmpl	$-1, -640(%rbp)
	leal	1(%r14), %edi
	movl	%r15d, %r9d
	movl	%edi, -672(%rbp)
	jne	.L93
	leal	1(%r15), %r9d
.L93:
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
	je	.L95
	cmpb	$0, -664(%rbp)
	je	.L95
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
.L96:
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
	je	.L98
	cmpb	$0, -681(%rbp)
	jne	.L144
.L98:
	leaq	-556(%rbp), %rdi
	call	MPI_Type_free
.L81:
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
	jge	.L100
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
	je	.L253
	cmpl	%edi, -664(%rbp)
	jne	.L254
	movl	-612(%rbp), %edi
	movl	-616(%rbp), %ecx
	leal	-1(%r15), %r13d
	movl	%ebx, -512(%rbp)
	movl	%r13d, -640(%rbp)
	movl	%r13d, -504(%rbp)
	movl	%edi, -508(%rbp)
	movl	%ecx, -500(%rbp)
.L135:
	movl	-632(%rbp), %edi
	decl	%edi
.L138:
	movl	%edi, -304(%rbp)
	xorl	%r13d, %r13d
	testl	%r12d, %r12d
	je	.L106
	movl	-636(%rbp), %r13d
	decl	%r13d
.L106:
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
	movl	$.LC8, %r8d
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
	movl	$.LC8, %r8d
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
.L100:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-648(%rbp), %xmm0, %xmm6
	cmpl	$67108864, -568(%rbp)
	vmovsd	%xmm6, -384(%rbp)
	jne	.L107
.L110:
	cmpl	$67108864, -564(%rbp)
	je	.L109
	movq	-656(%rbp), %rdi
	call	MPI_Comm_free
.L109:
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
	jge	.L112
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
	je	.L255
.L113:
	leaq	-548(%rbp), %rdi
	call	MPI_Comm_free
.L112:
	call	MPI_Finalize
	movq	-464(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L115
	call	_ZdlPv
.L115:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L116
	call	_ZdlPv
.L116:
	movq	-600(%rbp), %r15
	testq	%r15, %r15
	je	.L241
	movq	%r15, %rdi
	call	_ZdlPv
.L241:
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
.L253:
	.cfi_restore_state
	leal	-1(%r15), %eax
	movl	%eax, -640(%rbp)
	testl	%edi, %edi
	je	.L256
	movl	-612(%rbp), %edx
	leal	-1(%r15), %esi
	movl	%ebx, -512(%rbp)
	xorl	%edi, %edi
	movl	-616(%rbp), %r8d
	movl	%esi, -504(%rbp)
	movl	%edx, -508(%rbp)
	movl	%r8d, -500(%rbp)
	jmp	.L138
.L249:
	movl	%esi, %edi
	incl	%r15d
	movl	%esi, %edx
	imull	%eax, %edi
	jmp	.L129
.L255:
	movq	$.LC9, -608(%rbp)
	movl	$.LC16, %edi
	movl	$.LC10, %r11d
	movl	$.LC12, %r13d
	vmovq	-608(%rbp), %xmm8
	movq	$.LC11, -608(%rbp)
	movl	$.LC14, %ebx
	vpinsrq	$1, %r11, %xmm8, %xmm9
	vmovq	-608(%rbp), %xmm10
	movq	$.LC13, -608(%rbp)
	vpinsrq	$1, %r13, %xmm10, %xmm11
	movl	$.LC17, %r8d
	vmovq	-608(%rbp), %xmm12
	movq	$.LC15, -608(%rbp)
	vpinsrq	$1, %rbx, %xmm12, %xmm13
	movl	$.LC18, %ecx
	vmovq	-608(%rbp), %xmm14
	movl	$.LC19, %edx
	vpinsrq	$1, %rdi, %xmm14, %xmm15
	movl	$.LC20, %esi
	movl	$.LC21, %edi
	xorl	%eax, %eax
	vmovaps	%xmm9, -112(%rbp)
	vmovaps	%xmm11, -96(%rbp)
	vmovaps	%xmm13, -80(%rbp)
	vmovaps	%xmm15, -64(%rbp)
	call	printf
	xorl	%r14d, %r14d
	.p2align 4,,15
.L114:
	vmovsd	-176(%rbp,%r14), %xmm1
	vxorps	%xmm0, %xmm0, %xmm0
	vmovsd	-304(%rbp,%r14), %xmm3
	movl	$.LC22, %edi
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
	jne	.L114
	jmp	.L113
.L92:
	cmpb	$0, -668(%rbp)
	je	.L95
	cmpb	$0, -664(%rbp)
	jne	.L142
.L95:
	cmpl	$-1, -640(%rbp)
	je	.L98
	incl	%r12d
	je	.L244
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
.L144:
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
	jmp	.L98
.L107:
	leaq	-568(%rbp), %rdi
	call	MPI_Comm_free
	jmp	.L110
.L250:
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
	je	.L72
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
.L72:
	movl	-304(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L73
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
.L73:
	movl	-240(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L74
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
.L74:
	movl	-176(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L75
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
.L75:
	movl	-664(%rbp), %edx
	cmpl	$-1, %edx
	je	.L76
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
.L76:
	cmpl	$-1, %r12d
	je	.L77
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
.L77:
	movl	-640(%rbp), %r11d
	cmpl	$-1, %r11d
	je	.L78
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
.L78:
	movl	-668(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L71
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
	jmp	.L71
.L251:
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
	je	.L84
	pushq	%r14
	pushq	$2
.L243:
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
	jmp	.L86
.L252:
	cmpl	$-1, %r12d
	je	.L84
	pushq	%r14
	pushq	$1
	jmp	.L243
.L89:
	cmpl	$-1, %r12d
	jne	.L131
.L236:
	cmpl	$-1, -640(%rbp)
	je	.L98
.L244:
	leal	1(%r15), %ebx
.L134:
	xorl	%r8d, %r8d
	cmpl	$-1, -680(%rbp)
	leal	1(%r14), %edx
	movl	%edx, -672(%rbp)
	movl	%edx, %esi
	setne	%r8b
	incl	%r8d
	jmp	.L96
.L145:
	movq	$0, -600(%rbp)
	movl	$0, -628(%rbp)
	jmp	.L69
.L84:
	cmpl	$-1, -680(%rbp)
	leal	1(%r14), %r10d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	je	.L257
	movq	-600(%rbp), %rdi
	pushq	%r10
	movl	$2, %r9d
	movl	$1, %r8d
	pushq	$2
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L141
.L254:
	movl	-612(%rbp), %r10d
	movl	-616(%rbp), %r11d
	movl	%ebx, -512(%rbp)
	movl	%r15d, -504(%rbp)
	movl	%r15d, -640(%rbp)
	movl	%r10d, -508(%rbp)
	movl	%r11d, -500(%rbp)
	jmp	.L135
.L257:
	movq	-600(%rbp), %rdi
	pushq	%r10
	movl	$2, %r9d
	movl	$1, %r8d
	pushq	$1
	movl	%r13d, %esi
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
	jmp	.L236
.L142:
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
	jmp	.L134
.L159:
	movq	-464(%rbp), %rdi
	movq	%rax, %r12
	testq	%rdi, %rdi
	je	.L240
	vzeroupper
	call	_ZdlPv
.L124:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L126
	call	_ZdlPv
.L126:
	movq	-600(%rbp), %rcx
	testq	%rcx, %rcx
	je	.L127
	movq	%rcx, %rdi
	call	_ZdlPv
.L127:
	movq	%r12, %rdi
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L240:
	vzeroupper
	jmp	.L124
.L156:
.L247:
	movq	-112(%rbp), %rdi
	movq	%rax, %r12
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L239
	vzeroupper
	call	_ZdlPv
	jmp	.L127
.L155:
	jmp	.L247
.L157:
	movq	%rax, %r12
	vzeroupper
	jmp	.L126
.L256:
	movl	-612(%rbp), %r10d
	movl	-616(%rbp), %r11d
	leal	-2(%r15), %r9d
	movl	%ebx, -512(%rbp)
	movl	%r9d, -640(%rbp)
	movl	%r9d, -504(%rbp)
	movl	%r10d, -508(%rbp)
	movl	%r11d, -500(%rbp)
	jmp	.L138
.L158:
	movq	%rax, %r12
	vzeroupper
	jmp	.L124
.L239:
	vzeroupper
	jmp	.L127
	.cfi_endproc
.LFE7612:
	.section	.gcc_except_table,"a",@progbits
.LLSDA7612:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7612-.LLSDACSB7612
.LLSDACSB7612:
	.uleb128 .LEHB3-.LFB7612
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB4-.LFB7612
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L155-.LFB7612
	.uleb128 0
	.uleb128 .LEHB5-.LFB7612
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB7612
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L156-.LFB7612
	.uleb128 0
	.uleb128 .LEHB7-.LFB7612
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB8-.LFB7612
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L157-.LFB7612
	.uleb128 0
	.uleb128 .LEHB9-.LFB7612
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L158-.LFB7612
	.uleb128 0
	.uleb128 .LEHB10-.LFB7612
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L159-.LFB7612
	.uleb128 0
	.uleb128 .LEHB11-.LFB7612
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
.LLSDACSE7612:
	.section	.text.startup
	.size	main, .-main
	.p2align 4,,15
	.type	_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii, @function
_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii:
.LFB8371:
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
.LFE8371:
	.size	_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii, .-_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__Z5sobelPKhiPfS1_iiii
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC0:
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.align 32
.LC1:
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.align 32
.LC2:
	.long	3196831400
	.long	3196831400
	.long	3196831400
	.long	3196831400
	.long	3196831400
	.long	3196831400
	.long	3196831400
	.long	3196831400
	.align 32
.LC3:
	.long	1065843096
	.long	1065843096
	.long	1065843096
	.long	1065843096
	.long	1065843096
	.long	1065843096
	.long	1065843096
	.long	1065843096
	.align 32
.LC4:
	.long	1070141403
	.long	1070141403
	.long	1070141403
	.long	1070141403
	.long	1070141403
	.long	1070141403
	.long	1070141403
	.long	1070141403
	.align 32
.LC5:
	.long	1078530011
	.long	1078530011
	.long	1078530011
	.long	1078530011
	.long	1078530011
	.long	1078530011
	.long	1078530011
	.long	1078530011
	.hidden	__dso_handle
	.ident	"GCC: (SUSE Linux) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
