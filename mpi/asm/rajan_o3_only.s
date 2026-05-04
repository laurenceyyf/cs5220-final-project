	.file	"mpi_2d.cpp"
	.text
	.p2align 4,,15
	.type	_ZL13avx2_atan2_psDv8_fS_, @function
_ZL13avx2_atan2_psDv8_fS_:
.LFB7609:
	.cfi_startproc
	vmovaps	.LC0(%rip), %ymm6
	vxorps	%xmm5, %xmm5, %xmm5
	vmovaps	.LC1(%rip), %ymm2
	vandnps	%ymm1, %ymm6, %ymm4
	vandnps	%ymm0, %ymm6, %ymm8
	vcmpps	$17, %ymm5, %ymm1, %ymm1
	vandps	%ymm6, %ymm0, %ymm0
	vcmpps	$30, %ymm4, %ymm8, %ymm7
	vblendvps	%ymm7, %ymm4, %ymm8, %ymm3
	vblendvps	%ymm7, %ymm8, %ymm4, %ymm4
	vcmpps	$12, %ymm5, %ymm4, %ymm5
	vblendvps	%ymm5, %ymm4, %ymm2, %ymm2
	vdivps	%ymm2, %ymm3, %ymm2
	vmovaps	.LC2(%rip), %ymm3
	vfmadd213ps	.LC3(%rip), %ymm2, %ymm3
	vmulps	%ymm3, %ymm2, %ymm2
	vmovaps	.LC4(%rip), %ymm3
	vsubps	%ymm2, %ymm3, %ymm3
	vblendvps	%ymm7, %ymm3, %ymm2, %ymm2
	vmovaps	.LC5(%rip), %ymm3
	vsubps	%ymm2, %ymm3, %ymm3
	vblendvps	%ymm1, %ymm3, %ymm2, %ymm2
	vxorps	%ymm0, %ymm2, %ymm0
	ret
	.cfi_endproc
.LFE7609:
	.size	_ZL13avx2_atan2_psDv8_fS_, .-_ZL13avx2_atan2_psDv8_fS_
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
	testl	%esi, %esi
	movl	%edx, 12(%rsp)
	js	.L7
	movq	8(%rdi), %rax
	cmpl	(%rax), %esi
	jge	.L7
	testl	%edx, %edx
	js	.L7
	cmpl	4(%rax), %edx
	jge	.L7
	movq	16(%rdi), %rax
	leaq	4(%rsp), %rdx
	leaq	8(%rsp), %rsi
	movl	(%rax), %edi
	call	MPI_Cart_rank
	movl	4(%rsp), %eax
.L8:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore_state
	orl	$-1, %eax
	jmp	.L8
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
	subq	$160, %rsp
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	movq	%rdi, -88(%rbp)
	movl	(%r10), %ebx
	movl	8(%r10), %edi
	cmpl	%r9d, %r8d
	movl	%esi, -80(%rbp)
	movq	%rdx, -96(%rbp)
	movq	%rcx, -104(%rbp)
	movl	%r8d, -68(%rbp)
	movl	%r9d, -116(%rbp)
	movl	%ebx, -120(%rbp)
	movl	%edi, -124(%rbp)
	jge	.L24
	movslq	%esi, %r12
	movl	%r8d, %edx
	movl	%r8d, %eax
	imull	%r12d, %edx
	subl	$1, %eax
	leal	-7(%rdi), %r11d
	movq	%r12, -112(%rbp)
	movl	%r11d, -128(%rbp)
	movl	%edx, -76(%rbp)
	leal	-2(%r12), %edx
	imull	%edx, %eax
	movl	%edx, -136(%rbp)
	movl	%eax, -72(%rbp)
	leal	-8(%rdi), %eax
	subl	%ebx, %eax
	shrl	$3, %eax
	movl	%eax, %edx
	leal	8(%rbx,%rax,8), %eax
	salq	$3, %rdx
	cmpl	%r11d, %ebx
	cmovge	%ebx, %eax
	movq	%rdx, -144(%rbp)
	cltq
	movq	%rax, %rdx
	movl	%eax, -132(%rbp)
	movq	%rax, -160(%rbp)
	leal	-1(%rdi), %eax
	movl	%eax, %edi
	movq	%r12, %rax
	subl	%edx, %edi
	notq	%rax
	movslq	%ebx, %rdx
	movq	%rax, -176(%rbp)
	addq	%rdx, %rax
	movq	%rdi, -152(%rbp)
	movq	%rdx, -168(%rbp)
	movq	%rax, -184(%rbp)
	.p2align 4,,10
	.p2align 3
.L21:
	movl	-128(%rbp), %ebx
	cmpl	%ebx, -120(%rbp)
	jge	.L16
	movslq	-72(%rbp), %r8
	movq	-168(%rbp), %rbx
	movq	-96(%rbp), %rsi
	movq	-144(%rbp), %rdi
	movq	-112(%rbp), %r13
	leaq	(%r8,%rbx), %rax
	addq	%rbx, %rdi
	addq	%r8, %rdi
	leaq	-4(,%rax,4), %rcx
	movslq	-76(%rbp), %rax
	leaq	28(%rsi,%rdi,4), %rdi
	addq	-184(%rbp), %rax
	leaq	(%rsi,%rcx), %rdx
	addq	-88(%rbp), %rax
	addq	-104(%rbp), %rcx
	.p2align 4,,10
	.p2align 3
.L17:
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpinsrq	$0, (%rax,%r13), %xmm7, %xmm7
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm0, %xmm0, %xmm0
	vpmovzxbd	%xmm7, %ymm8
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm7, %xmm7, %xmm7
	vpinsrq	$0, (%rax), %xmm4, %xmm4
	vpinsrq	$0, 1(%rax), %xmm6, %xmm6
	vpinsrq	$0, 2(%rax), %xmm2, %xmm2
	vpmovzxbd	%xmm4, %ymm4
	vpinsrq	$0, 2(%rax,%r13), %xmm7, %xmm7
	vpmovzxbd	%xmm6, %ymm6
	vpinsrq	$0, 1(%rax,%r13,2), %xmm0, %xmm0
	vpmovzxbd	%xmm2, %ymm2
	vpslld	$1, %ymm6, %ymm6
	vpinsrq	$0, (%rax,%r13,2), %xmm5, %xmm5
	vpmovzxbd	%xmm7, %ymm7
	vpinsrq	$0, 2(%rax,%r13,2), %xmm3, %xmm3
	vpmovzxbd	%xmm0, %ymm1
	vpsubd	%ymm8, %ymm7, %ymm7
	vpslld	$1, %ymm7, %ymm7
	vpmovzxbd	%xmm5, %ymm5
	vpslld	$1, %ymm1, %ymm0
	vpaddd	%ymm2, %ymm7, %ymm1
	vpmovzxbd	%xmm3, %ymm3
	vpaddd	%ymm3, %ymm1, %ymm1
	vpaddd	%ymm3, %ymm0, %ymm3
	vpsubd	%ymm4, %ymm1, %ymm1
	vpsubd	%ymm4, %ymm5, %ymm4
	vpsubd	%ymm5, %ymm1, %ymm1
	vpaddd	%ymm3, %ymm4, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vpsubd	%ymm6, %ymm0, %ymm0
	vpsubd	%ymm2, %ymm0, %ymm0
	vmulps	%ymm1, %ymm1, %ymm2
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	%ymm0, %ymm0, %ymm3
	vaddps	%ymm2, %ymm3, %ymm2
	vsqrtps	%ymm2, %ymm2
	vmovups	%xmm2, (%rdx)
	vextractf128	$0x1, %ymm2, 16(%rdx)
	call	_ZL13avx2_atan2_psDv8_fS_
	addq	$32, %rdx
	vextractf128	$0x1, %ymm0, 16(%rcx)
	vmovups	%xmm0, (%rcx)
	addq	$8, %rax
	addq	$32, %rcx
	cmpq	%rdx, %rdi
	jne	.L17
.L16:
	movl	-132(%rbp), %ebx
	cmpl	%ebx, -124(%rbp)
	jle	.L14
	movslq	-72(%rbp), %rdx
	movq	-160(%rbp), %rcx
	movq	-88(%rbp), %rsi
	movq	-112(%rbp), %r11
	movq	-96(%rbp), %rbx
	movslq	-76(%rbp), %rax
	movq	-176(%rbp), %r12
	addq	%rcx, %rdx
	movq	%r11, %r15
	leaq	-4(,%rdx,4), %r9
	movq	-104(%rbp), %rdx
	addq	%rcx, %r15
	leaq	1(%rcx,%rax), %rdi
	addq	%rcx, %r12
	addq	%rax, %r15
	leaq	(%rbx,%r9), %r10
	addq	%rax, %r12
	addq	%rsi, %r15
	leaq	(%rdx,%r9), %rbx
	leaq	1(%rsi,%r11), %rdx
	addq	%rsi, %rdi
	addq	%rsi, %r12
	addq	%rcx, %rdx
	addq	-152(%rbp), %rdx
	movq	%rbx, %r13
	movq	%rdi, %rbx
	addq	%rdx, %rax
	movq	%rax, -64(%rbp)
	vzeroupper
	.p2align 4,,10
	.p2align 3
.L18:
	movzbl	2(%r12), %r8d
	movzbl	(%r12), %eax
	movzbl	-2(%rbx), %r9d
	movzbl	-1(%r15), %edi
	movzbl	1(%r15), %ecx
	vxorps	%xmm0, %xmm0, %xmm0
	vxorps	%xmm5, %xmm5, %xmm5
	movl	%r8d, %esi
	subl	%eax, %esi
	addl	%r9d, %r9d
	negl	%eax
	subl	%r9d, %esi
	movzbl	(%rbx), %r9d
	leal	(%rsi,%r9,2), %r14d
	movzbl	1(%r12), %esi
	subl	%edi, %r14d
	addl	%ecx, %r14d
	addl	%esi, %esi
	subl	%esi, %eax
	movzbl	(%r15), %esi
	subl	%r8d, %eax
	addl	%edi, %eax
	leal	(%rax,%rsi,2), %eax
	addl	%ecx, %eax
	movl	%r14d, %ecx
	movl	%eax, %esi
	imull	%r14d, %ecx
	imull	%eax, %esi
	addl	%esi, %ecx
	vcvtsi2ss	%ecx, %xmm0, %xmm0
	vucomiss	%xmm0, %xmm5
	vsqrtss	%xmm0, %xmm1, %xmm1
	ja	.L28
	vmovss	%xmm1, (%r10)
	movq	%r10, -56(%rbp)
.L27:
	vxorps	%xmm0, %xmm0, %xmm0
	addq	$1, %rbx
	addq	$1, %r15
	vxorps	%xmm1, %xmm1, %xmm1
	addq	$4, %r13
	addq	$1, %r12
	vcvtsi2ss	%eax, %xmm0, %xmm0
	vcvtsi2ss	%r14d, %xmm1, %xmm1
	call	atan2f
	movq	-56(%rbp), %r10
	vmovss	%xmm0, -4(%r13)
	addq	$4, %r10
	cmpq	%r15, -64(%rbp)
	jne	.L18
.L14:
	addl	$1, -68(%rbp)
	movl	-80(%rbp), %edx
	movl	-68(%rbp), %eax
	addl	%edx, -76(%rbp)
	movl	-136(%rbp), %edi
	addl	%edi, -72(%rbp)
	cmpl	%eax, -116(%rbp)
	jne	.L21
	vzeroupper
.L24:
	addq	$160, %rsp
	popq	%rbx
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
.L28:
	.cfi_restore_state
	movq	%r10, -200(%rbp)
	vmovss	%xmm1, -56(%rbp)
	movl	%eax, -188(%rbp)
	call	sqrtf
	movq	-200(%rbp), %r10
	vmovss	-56(%rbp), %xmm1
	movl	-188(%rbp), %eax
	vmovss	%xmm1, (%r10)
	movq	%r10, -56(%rbp)
	jmp	.L27
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
	je	.L46
	movl	(%rbx), %esi
	cmpl	$34, %esi
	je	.L31
	movl	$2147483648, %ecx
	movl	$4294967295, %edi
	addq	%rax, %rcx
	cmpq	%rdi, %rcx
	ja	.L31
	testq	%r12, %r12
	je	.L33
	subq	%rbp, %rdx
	movq	%rdx, (%r12)
.L33:
	testl	%esi, %esi
	jne	.L44
	movl	%r13d, (%rbx)
.L44:
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
.L31:
	.cfi_restore_state
	movq	%r14, %rdi
	call	_ZSt20__throw_out_of_rangePKc
.LEHE0:
.L37:
	cmpl	$0, (%rbx)
	jne	.L36
	movl	%r13d, (%rbx)
.L36:
	movq	%rax, %rdi
	vzeroupper
.LEHB1:
	call	_Unwind_Resume
.LEHE1:
.L46:
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
	.uleb128 .L37-.LFB7680
	.uleb128 0
	.uleb128 .LEHB1-.LFB7680
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB7680
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L37-.LFB7680
	.uleb128 0
.LLSDACSE7680:
	.section	.text._ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,"axG",@progbits,_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_,comdat
	.size	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_, .-_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
	.section	.rodata._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2EPKcRKS3_.str1.8,"aMS",@progbits,1
	.align 8
.LC7:
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
	testq	%rsi, %rsi
	movq	%r12, (%rdi)
	je	.L48
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movq	%rsi, %r13
	call	strlen
	cmpq	$15, %rax
	movq	%rax, %rbx
	ja	.L59
	cmpq	$1, %rax
	je	.L60
	testq	%rax, %rax
	jne	.L51
.L53:
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
.L60:
	.cfi_restore_state
	movzbl	0(%r13), %eax
	movb	%al, 16(%rbp)
	jmp	.L53
	.p2align 4,,10
	.p2align 3
.L59:
	leaq	1(%rax), %rdi
	call	_Znwm
	movq	%rbx, 16(%rbp)
	movq	%rax, %r12
	movq	%rax, 0(%rbp)
.L51:
	movq	%r12, %rdi
	movq	%rbx, %rdx
	movq	%r13, %rsi
	call	memcpy
	movq	0(%rbp), %r12
	jmp	.L53
.L48:
	movl	$.LC7, %edi
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
	je	.L62
	movabsq	$4611686018427387903, %rax
	cmpq	%rax, %rsi
	ja	.L68
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
.L64:
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
.L62:
	.cfi_restore_state
	xorl	%r12d, %r12d
	jmp	.L64
.L68:
	call	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE7923:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKS0_, .-_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.weak	_ZNSt6vectorIfSaIfEEC1EmRKS0_
	.set	_ZNSt6vectorIfSaIfEEC1EmRKS0_,_ZNSt6vectorIfSaIfEEC2EmRKS0_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC8:
	.string	"stoi"
.LC9:
	.string	"native"
.LC10:
	.string	"Setup"
.LC11:
	.string	"Read file"
.LC12:
	.string	"Send requests"
.LC13:
	.string	"Local comp"
.LC14:
	.string	"Wait on resps"
.LC15:
	.string	"Compute received"
.LC16:
	.string	"Write out"
.LC17:
	.string	"Total"
.LC18:
	.string	"Avg(s)"
.LC19:
	.string	"Max(s)"
.LC20:
	.string	"Min(s)"
.LC21:
	.string	"Section"
.LC22:
	.string	"%-20s;%10s;%10s;%10s\n"
.LC23:
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
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp
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
	subq	$640, %rsp
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
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
	vmovsd	%xmm0, -632(%rbp)
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
	movl	$.LC8, %esi
	movl	$__isoc23_strtol, %edi
.LEHB4:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE4:
	movl	%eax, -624(%rbp)
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L70
	call	_ZdlPv
.L70:
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
	movl	$.LC8, %esi
	movl	$__isoc23_strtol, %edi
.LEHB6:
	call	_ZN9__gnu_cxx6__stoaIlicJiEEET0_PFT_PKT1_PPS3_DpT2_EPKcS5_PmS9_
.LEHE6:
	movl	%eax, -620(%rbp)
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L71
	call	_ZdlPv
.L71:
	movl	-624(%rbp), %eax
	movl	$1431655766, %ebx
	leaq	-536(%rbp), %r13
	movl	$2, %esi
	movq	$0, -536(%rbp)
	imull	%ebx
	movl	-624(%rbp), %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	-620(%rbp), %eax
	movl	%edx, %r12d
	movl	%r12d, %edi
	imull	%ebx
	movl	-620(%rbp), %eax
	movl	%edx, %ebx
	sarl	$31, %eax
	movq	%r13, %rdx
	subl	%eax, %ebx
	movl	-572(%rbp), %eax
	imull	%ebx, %edi
	cmpl	%eax, %edi
	cmovg	%eax, %edi
.LEHB7:
	call	MPI_Dims_create
	cmpl	%r12d, -536(%rbp)
	movl	-576(%rbp), %ecx
	cmovle	-536(%rbp), %r12d
	cmpl	%ebx, -532(%rbp)
	cmovle	-532(%rbp), %ebx
	movl	$67108864, -568(%rbp)
	movl	%ecx, -608(%rbp)
	movq	$0, -528(%rbp)
	movl	%r12d, %eax
	movl	%r12d, -536(%rbp)
	imull	%ebx, %eax
	movl	%ebx, -532(%rbp)
	cmpl	%eax, %ecx
	movl	%eax, -612(%rbp)
	jge	.L253
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
	movq	%r13, %rdx
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
	movl	-624(%rbp), %eax
	cltd
	idivl	-536(%rbp)
	movl	%eax, -584(%rbp)
	movl	-520(%rbp), %eax
	cmpl	%eax, %edx
	jg	.L254
	imull	-584(%rbp), %eax
	movl	%eax, %ecx
.L135:
	leal	(%rdx,%rcx), %eax
	movl	%eax, -644(%rbp)
	movl	-620(%rbp), %eax
	cltd
	idivl	-532(%rbp)
	movl	%eax, %r15d
	movl	-516(%rbp), %eax
	movl	%eax, %ecx
	imull	%r15d, %ecx
	cmpl	%eax, %edx
	jle	.L136
	addl	$1, %r15d
	movl	%eax, %edx
.L136:
	leal	(%rdx,%rcx), %eax
	leal	2(%r15), %ecx
	movl	%eax, -636(%rbp)
	movl	-584(%rbp), %eax
	movl	%ecx, %r12d
	movl	%ecx, -616(%rbp)
	leal	2(%rax), %r14d
	imull	%r15d, %eax
	imull	%r14d, %r12d
	movslq	%eax, %rbx
	movslq	%r12d, %r12
	testq	%r12, %r12
	je	.L151
	movq	%r12, %rdi
	call	_Znwm
	movq	%r12, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, -600(%rbp)
	call	memset
	movl	$0, -640(%rbp)
	jmp	.L75
	.p2align 4,,10
	.p2align 3
.L253:
	leaq	-564(%rbp), %rax
	movl	%ecx, %edx
	movl	$-32766, %esi
	movl	$1140850688, %edi
	xorl	%ebx, %ebx
	movl	$2, %r14d
	movq	%rax, %rcx
	movq	%rax, -664(%rbp)
	xorl	%r15d, %r15d
	call	MPI_Comm_split
.LEHE7:
	movq	$0, -520(%rbp)
	movq	$0, -600(%rbp)
	movl	$2, -616(%rbp)
	movl	$-32766, -640(%rbp)
	movl	$0, -636(%rbp)
	movl	$0, -644(%rbp)
	movl	$0, -584(%rbp)
.L75:
	leaq	-112(%rbp), %rdx
	leaq	-496(%rbp), %rdi
	movq	%rbx, %rsi
.LEHB8:
	call	_ZNSt6vectorIfSaIfEEC1EmRKS0_
.LEHE8:
	leaq	-112(%rbp), %rdx
	leaq	-464(%rbp), %rdi
	movq	%rbx, %rsi
.LEHB9:
	call	_ZNSt6vectorIfSaIfEEC1EmRKS0_
.LEHE9:
.LEHB10:
	call	MPI_Wtime
	vsubsd	-632(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -368(%rbp)
	call	MPI_Wtime
	movq	-592(%rbp), %rax
	leaq	-544(%rbp), %r8
	movl	$469762048, %ecx
	movl	-568(%rbp), %edi
	movl	$2, %edx
	vmovsd	%xmm0, -656(%rbp)
	movq	8(%rax), %rsi
	call	MPI_File_open
	movl	-612(%rbp), %ebx
	cmpl	%ebx, -608(%rbp)
	jge	.L76
	movl	-624(%rbp), %eax
	movl	-644(%rbp), %ebx
	leaq	-548(%rbp), %r12
	subq	$8, %rsp
	leaq	-304(%rbp), %rcx
	leaq	-504(%rbp), %rsi
	pushq	%r12
	movl	$1275068731, %r9d
	movl	$56, %r8d
	movl	%eax, -504(%rbp)
	movl	%ebx, -304(%rbp)
	movl	$2, %edi
	movl	-620(%rbp), %eax
	movl	-636(%rbp), %ebx
	movl	%r15d, -428(%rbp)
	movl	%eax, -500(%rbp)
	movl	%ebx, -300(%rbp)
	leaq	-432(%rbp), %rbx
	movl	-584(%rbp), %eax
	movq	%rbx, %rdx
	movl	%eax, -432(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r11
	popq	%rbx
	movq	%r12, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-616(%rbp), %ebx
	movl	-584(%rbp), %eax
	subq	$8, %rsp
	leaq	-112(%rbp), %rcx
	leaq	-176(%rbp), %rdx
	leaq	-240(%rbp), %rsi
	movl	$1275068731, %r9d
	movl	$56, %r8d
	movl	$2, %edi
	movl	%ebx, -236(%rbp)
	leaq	-512(%rbp), %rbx
	movl	%eax, -176(%rbp)
	movabsq	$4294967297, %rax
	movl	%r14d, -240(%rbp)
	movl	%r15d, -172(%rbp)
	pushq	%rbx
	movq	%rax, -112(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r9
	popq	%r10
	movq	%rbx, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-548(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC9, %r8d
	movl	$1275068731, %edx
	xorl	%esi, %esi
	call	MPI_File_set_view
	movl	-512(%rbp), %ecx
	movq	-600(%rbp), %rsi
	movl	$1, %r8d
	movq	-544(%rbp), %rdi
	movl	$1, %edx
	call	MPI_File_read_all
	movq	%r12, %rdi
	call	MPI_Type_free
	movq	%rbx, %rdi
	call	MPI_Type_free
.L76:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-656(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -360(%rbp)
	call	MPI_Wtime
	xorl	%r12d, %r12d
	movl	-612(%rbp), %ecx
	vmovsd	%xmm0, -656(%rbp)
	cmpl	%ecx, -608(%rbp)
	movl	$201326592, -556(%rbp)
	jl	.L255
.L77:
	call	MPI_Wtime
	vsubsd	-656(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -352(%rbp)
	call	MPI_Wtime
	movl	-612(%rbp), %ebx
	vmovsd	%xmm0, -656(%rbp)
	cmpl	%ebx, -608(%rbp)
	jge	.L86
	movl	-584(%rbp), %eax
	cmpl	$2, %eax
	jle	.L86
	cmpl	$2, %r15d
	jle	.L86
	movq	-496(%rbp), %rdx
	movq	-464(%rbp), %rcx
	movl	%eax, %r9d
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	movl	$2, %r8d
	pushq	%r15
	pushq	$2
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
.L86:
	call	MPI_Wtime
	vsubsd	-656(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -344(%rbp)
	call	MPI_Wtime
	leaq	-304(%rbp), %rsi
	movl	$1, %edx
	movl	%r12d, %edi
	vmovsd	%xmm0, -656(%rbp)
	call	MPI_Waitall
	call	MPI_Wtime
	vsubsd	-656(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -336(%rbp)
	call	MPI_Wtime
	movl	-612(%rbp), %ecx
	vmovsd	%xmm0, -656(%rbp)
	cmpl	%ecx, -608(%rbp)
	jge	.L87
	leaq	-432(%rbp), %rbx
	movl	-568(%rbp), %edi
	leaq	-240(%rbp), %r8
	movl	$1, %edx
	xorl	%esi, %esi
	movq	%rbx, %rcx
	call	MPI_Cart_shift
	movl	-568(%rbp), %edi
	leaq	-112(%rbp), %r8
	leaq	-176(%rbp), %rcx
	movl	$1, %edx
	movl	$1, %esi
	call	MPI_Cart_shift
	movl	-240(%rbp), %r13d
	movl	-176(%rbp), %eax
	movl	-112(%rbp), %r12d
	movl	-432(%rbp), %ebx
	cmpl	$-1, %r13d
	movl	%eax, -676(%rbp)
	setne	-648(%rbp)
	addl	$1, %eax
	setne	-672(%rbp)
	cmpl	$-1, %r12d
	movzbl	-672(%rbp), %eax
	setne	-688(%rbp)
	cmpl	$-1, %ebx
	je	.L88
	testb	%al, %al
	jne	.L256
.L88:
	cmpl	$-1, %ebx
	jne	.L257
.L92:
	cmpl	$-1, -676(%rbp)
	je	.L95
.L147:
	cmpl	$-1, %r13d
	movl	-584(%rbp), %r9d
	jne	.L96
	leal	1(%r9), %r9d
.L96:
	xorl	%eax, %eax
	cmpl	$-1, %ebx
	movq	-464(%rbp), %rcx
	setne	%al
	movl	-616(%rbp), %esi
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	pushq	$2
	leal	1(%rax), %r8d
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	cmpl	$-1, %r12d
	popq	%rcx
	popq	%rsi
	je	.L98
.L137:
	cmpl	$-1, %r13d
	leal	1(%r15), %r14d
	movl	-584(%rbp), %r9d
	jne	.L99
	leal	1(%r9), %r9d
.L99:
	xorl	%edx, %edx
	addl	$1, %ebx
	movq	-464(%rbp), %rcx
	setne	%dl
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	leal	1(%rdx), %r8d
	movq	-496(%rbp), %rdx
	pushq	%r14
	pushq	%r15
	call	_Z5sobelPKhiPfS1_iiii
	cmpb	$0, -648(%rbp)
	popq	%rax
	popq	%rdx
	je	.L101
	cmpb	$0, -672(%rbp)
	je	.L101
	movl	-584(%rbp), %r8d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	pushq	$2
	leal	1(%r8), %ebx
	pushq	$1
	movl	%ebx, %r9d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r11
	popq	%r12
	movl	%r15d, %ecx
	movl	$2, %edx
.L102:
	pushq	%rcx
	movl	-584(%rbp), %r8d
	movl	%ebx, %r9d
	pushq	%rdx
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	call	_Z5sobelPKhiPfS1_iiii
	cmpb	$0, -648(%rbp)
	popq	%r9
	popq	%r10
	je	.L104
	cmpb	$0, -688(%rbp)
	jne	.L150
.L104:
	leaq	-556(%rbp), %rdi
	call	MPI_Type_free
.L87:
	call	MPI_Wtime
	vsubsd	-656(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -328(%rbp)
	call	MPI_Wtime
	movq	-592(%rbp), %rax
	leaq	-544(%rbp), %r8
	movl	$469762048, %ecx
	movl	-568(%rbp), %edi
	movl	$5, %edx
	vmovsd	%xmm0, -656(%rbp)
	movq	16(%rax), %rsi
	call	MPI_File_open
	movl	-612(%rbp), %ebx
	cmpl	%ebx, -608(%rbp)
	jge	.L106
	movl	-532(%rbp), %ebx
	movl	-516(%rbp), %r13d
	movl	%r15d, %r12d
	movl	-536(%rbp), %eax
	movl	-520(%rbp), %ecx
	leal	-1(%rbx), %edx
	movl	-624(%rbp), %ebx
	subl	$1, %eax
	movl	%ecx, -672(%rbp)
	subl	$2, %ebx
	movl	%ebx, -616(%rbp)
	movl	-620(%rbp), %ebx
	subl	$2, %ebx
	cmpl	$1, %r13d
	sbbl	$0, %r12d
	cmpl	%edx, %r13d
	movl	%ebx, -620(%rbp)
	sete	%dl
	movzbl	%dl, %edx
	subl	%edx, %r12d
	testl	%ecx, %ecx
	je	.L258
	cmpl	%eax, -672(%rbp)
	jne	.L259
	movl	-616(%rbp), %ebx
	movl	-584(%rbp), %eax
	movl	%r12d, -500(%rbp)
	movl	%ebx, -512(%rbp)
	movl	-620(%rbp), %ebx
	subl	$1, %eax
	movl	%eax, -624(%rbp)
	movl	%eax, -504(%rbp)
	movl	%ebx, -508(%rbp)
.L141:
	movl	-644(%rbp), %eax
	subl	$1, %eax
.L144:
	movl	-636(%rbp), %edx
	movl	%eax, -432(%rbp)
	leaq	-552(%rbp), %r14
	movl	$0, %eax
	leaq	-432(%rbp), %rbx
	leaq	-512(%rbp), %rsi
	movl	$1275069450, %r9d
	movl	$56, %r8d
	movl	$2, %edi
	subl	$1, %edx
	testl	%r13d, %r13d
	movq	%rbx, %rcx
	cmove	%eax, %edx
	subq	$8, %rsp
	movl	%edx, -428(%rbp)
	pushq	%r14
	leaq	-504(%rbp), %rdx
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%rcx
	popq	%rsi
	movq	%r14, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movslq	-620(%rbp), %rax
	movslq	-616(%rbp), %rbx
	leaq	-112(%rbp), %rcx
	movl	-672(%rbp), %edx
	movl	%r12d, -172(%rbp)
	leaq	-548(%rbp), %r12
	leaq	-240(%rbp), %rsi
	movl	$1275069450, %r9d
	movl	$56, %r8d
	movl	$2, %edi
	movl	%r15d, -236(%rbp)
	imulq	%rax, %rbx
	movl	-584(%rbp), %eax
	movl	%eax, -240(%rbp)
	movl	-624(%rbp), %eax
	salq	$2, %rbx
	movl	%eax, -176(%rbp)
	xorl	%eax, %eax
	testl	%edx, %edx
	sete	%al
	leaq	-176(%rbp), %rdx
	movl	%eax, -112(%rbp)
	xorl	%eax, %eax
	testl	%r13d, %r13d
	sete	%al
	subq	$8, %rsp
	pushq	%r12
	movl	%eax, -108(%rbp)
	.cfi_escape 0x2e,0x10
	call	MPI_Type_create_subarray
	popq	%r13
	popq	%r15
	movq	%r12, %rdi
	.cfi_escape 0x2e,0
	call	MPI_Type_commit
	movl	-552(%rbp), %ecx
	movq	-544(%rbp), %rdi
	movl	$469762048, %r9d
	movl	$.LC9, %r8d
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
	movl	$.LC9, %r8d
	movl	$1275069450, %edx
	movq	%rbx, %rsi
	call	MPI_File_set_view
	movl	-548(%rbp), %ecx
	movq	-464(%rbp), %rsi
	movl	$1, %r8d
	movq	-544(%rbp), %rdi
	movl	$1, %edx
	call	MPI_File_write_all
	movq	%r14, %rdi
	call	MPI_Type_free
	movq	%r12, %rdi
	call	MPI_Type_free
.L106:
	leaq	-544(%rbp), %rdi
	call	MPI_File_close
	call	MPI_Wtime
	vsubsd	-656(%rbp), %xmm0, %xmm0
	cmpl	$67108864, -568(%rbp)
	vmovsd	%xmm0, -320(%rbp)
	jne	.L113
.L116:
	cmpl	$67108864, -564(%rbp)
	je	.L115
	movq	-664(%rbp), %rdi
	call	MPI_Comm_free
.L115:
	movl	$1140850688, %edi
	call	MPI_Barrier
	call	MPI_Wtime
	vsubsd	-632(%rbp), %xmm0, %xmm0
	leaq	-548(%rbp), %r12
	movl	-576(%rbp), %edx
	movl	-640(%rbp), %esi
	movl	$1140850688, %edi
	movq	%r12, %rcx
	vmovsd	%xmm0, -312(%rbp)
	call	MPI_Comm_split
	movl	-612(%rbp), %ecx
	cmpl	%ecx, -608(%rbp)
	jge	.L118
	movl	-548(%rbp), %edi
	leaq	-512(%rbp), %rsi
	call	MPI_Comm_size
	movl	-548(%rbp), %eax
	subq	$8, %rsp
	leaq	-240(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395010, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	pushq	%rax
	.cfi_escape 0x2e,0x10
	call	MPI_Reduce
	movl	-548(%rbp), %eax
	leaq	-176(%rbp), %rsi
	leaq	-368(%rbp), %rdi
	xorl	%r9d, %r9d
	movl	$1476395009, %r8d
	movl	$1275070475, %ecx
	movl	$8, %edx
	movl	%eax, (%rsp)
	call	MPI_Reduce
	movl	-548(%rbp), %eax
	leaq	-112(%rbp), %rsi
	leaq	-368(%rbp), %rdi
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
	je	.L260
.L119:
	movq	%r12, %rdi
	call	MPI_Comm_free
.L118:
	call	MPI_Finalize
	movq	-464(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L121
	call	_ZdlPv
.L121:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L122
	call	_ZdlPv
.L122:
	movq	-600(%rbp), %rax
	testq	%rax, %rax
	je	.L246
	movq	%rax, %rdi
	call	_ZdlPv
.L246:
	leaq	-48(%rbp), %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
.L258:
	.cfi_restore_state
	movl	-584(%rbp), %ebx
	subl	$1, %ebx
	testl	%eax, %eax
	movl	%ebx, -624(%rbp)
	je	.L261
	movl	-616(%rbp), %eax
	movl	%r12d, -500(%rbp)
	movl	%eax, -512(%rbp)
	movl	-620(%rbp), %eax
	movl	%eax, -508(%rbp)
	movl	-624(%rbp), %eax
	movl	%eax, -504(%rbp)
	xorl	%eax, %eax
	jmp	.L144
.L254:
	movl	-584(%rbp), %ebx
	movl	%eax, %edx
	movl	%ebx, %ecx
	addl	$1, %ebx
	imull	%eax, %ecx
	movl	%ebx, -584(%rbp)
	jmp	.L135
.L260:
	movq	$.LC12, -608(%rbp)
	movl	$.LC13, %eax
	movl	$.LC18, %r8d
	vmovq	-608(%rbp), %xmm0
	movq	$.LC10, -608(%rbp)
	vpinsrq	$1, %rax, %xmm0, %xmm1
	movl	$.LC11, %eax
	vmovq	-608(%rbp), %xmm0
	movq	$.LC16, -608(%rbp)
	vpinsrq	$1, %rax, %xmm0, %xmm0
	movl	$.LC17, %eax
	movl	$.LC19, %ecx
	movl	$.LC20, %edx
	movl	$.LC21, %esi
	movl	$.LC22, %edi
	vinserti128	$0x1, %xmm1, %ymm0, %ymm0
	vmovdqa	%ymm0, -432(%rbp)
	vmovq	-608(%rbp), %xmm0
	movq	$.LC14, -608(%rbp)
	vpinsrq	$1, %rax, %xmm0, %xmm1
	movl	$.LC15, %eax
	vmovq	-608(%rbp), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	xorl	%eax, %eax
	vinserti128	$0x1, %xmm1, %ymm0, %ymm0
	vmovdqa	%ymm0, -400(%rbp)
	vzeroupper
	call	printf
	leaq	-432(%rbp), %rbx
	xorl	%r13d, %r13d
	.p2align 4,,10
	.p2align 3
.L120:
	vxorpd	%xmm0, %xmm0, %xmm0
	movq	(%rbx,%r13), %rsi
	movl	$.LC23, %edi
	vmovsd	-112(%rbp,%r13), %xmm2
	movl	$3, %eax
	vmovsd	-240(%rbp,%r13), %xmm3
	vcvtsi2sd	-512(%rbp), %xmm0, %xmm0
	vdivsd	%xmm0, %xmm2, %xmm2
	vmovapd	%xmm3, %xmm0
	vmovsd	%xmm3, -608(%rbp)
	vmovsd	-176(%rbp,%r13), %xmm1
	call	printf
	addq	$8, %r13
	cmpq	$64, %r13
	jne	.L120
	jmp	.L119
.L98:
	cmpb	$0, -648(%rbp)
	je	.L101
	cmpb	$0, -672(%rbp)
	jne	.L148
.L101:
	addl	$1, %r13d
	je	.L104
	addl	$1, %r12d
	je	.L249
	movl	-584(%rbp), %r8d
	movq	-464(%rbp), %rcx
	leal	1(%r15), %r14d
	movl	-616(%rbp), %esi
	movq	-496(%rbp), %rdx
	movq	-600(%rbp), %rdi
	pushq	%r15
	leal	1(%r8), %ebx
	pushq	$1
	movl	%ebx, %r9d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rcx
	popq	%rsi
.L150:
	movl	-584(%rbp), %r8d
	movq	-600(%rbp), %rdi
	movl	%ebx, %r9d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	-616(%rbp), %esi
	pushq	%r14
	pushq	%r15
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L104
.L113:
	leaq	-568(%rbp), %rdi
	call	MPI_Comm_free
	jmp	.L116
.L255:
	movl	-616(%rbp), %edx
	movl	-584(%rbp), %edi
	leaq	-556(%rbp), %r8
	movl	$1275068731, %ecx
	movl	$1, %esi
	call	MPI_Type_vector
	leaq	-556(%rbp), %rdi
	call	MPI_Type_commit
	movl	-568(%rbp), %edi
	leaq	-432(%rbp), %r8
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
	movq	%rax, -672(%rbp)
	leaq	-568(%rbp), %rax
	vmovq	-672(%rbp), %xmm1
	vpinsrq	$1, %r13, %xmm1, %xmm0
	movq	%rax, -96(%rbp)
	vmovaps	%xmm0, -112(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	leaq	-112(%rbp), %rdi
	movl	$1, %edx
	orl	$-1, %esi
	movl	%eax, %r14d
	call	_ZZ4mainENKUliiE_clEii
	leaq	-112(%rbp), %rdi
	orl	$-1, %edx
	movl	$1, %esi
	movl	%eax, -676(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	leaq	-112(%rbp), %rdi
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, -672(%rbp)
	call	_ZZ4mainENKUliiE_clEii
	movl	-504(%rbp), %ecx
	movl	%eax, -648(%rbp)
	cmpl	$-1, %ecx
	je	.L78
	movq	-600(%rbp), %rbx
	leaq	-304(%rbp), %r13
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$10, %r8d
	movl	$1275068731, %edx
	pushq	%r13
	movl	%r15d, %esi
	leaq	1(%rbx), %rdi
	.cfi_escape 0x2e,0x10
	call	MPI_Irecv
	leal	3(%r15), %edi
	movl	-568(%rbp), %r9d
	movl	-504(%rbp), %ecx
	addq	$4, %r13
	movl	$11, %r8d
	movl	$1275068731, %edx
	movslq	%edi, %rdi
	movl	%r15d, %esi
	movq	%r13, (%rsp)
	addq	%rbx, %rdi
	call	MPI_Isend
	popq	%rdi
	popq	%r8
	movl	$2, %r12d
.L78:
	movl	-432(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L79
	movl	-584(%rbp), %ebx
	movslq	%r12d, %rax
	leaq	-304(%rbp), %r13
	salq	$2, %rax
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movq	%rax, -688(%rbp)
	addq	%r13, %rax
	movl	$11, %r8d
	addl	$1, %ebx
	pushq	%rax
	movl	$1275068731, %edx
	imull	-616(%rbp), %ebx
	movl	%r15d, %esi
	leal	1(%rbx), %edi
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	subl	-616(%rbp), %ebx
	movq	-688(%rbp), %rax
	movl	$10, %r8d
	movl	-568(%rbp), %r9d
	movl	-432(%rbp), %ecx
	movl	$1275068731, %edx
	movl	%r15d, %esi
	addl	$2, %r12d
	leaq	4(%r13,%rax), %rax
	leal	1(%rbx), %edi
	movq	%rax, (%rsp)
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Isend
	popq	%rcx
	popq	%rsi
.L79:
	movl	-240(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L80
	movslq	%r12d, %rbx
	leaq	-304(%rbp), %r13
	movslq	-616(%rbp), %rdi
	salq	$2, %rbx
	addq	-600(%rbp), %rdi
	subq	$8, %rsp
	leaq	0(%r13,%rbx), %rax
	movl	-568(%rbp), %r9d
	movl	-556(%rbp), %edx
	movl	$20, %r8d
	movl	$1, %esi
	pushq	%rax
	call	MPI_Irecv
	leal	3(%r15), %edi
	movl	-568(%rbp), %r9d
	movl	-240(%rbp), %ecx
	movl	-556(%rbp), %edx
	leaq	4(%r13,%rbx), %rax
	movl	$21, %r8d
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	addl	$2, %r12d
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%rax
	popq	%rdx
.L80:
	movl	-176(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L81
	movl	-616(%rbp), %eax
	movslq	%r12d, %rbx
	leaq	-304(%rbp), %r13
	salq	$2, %rbx
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	-556(%rbp), %edx
	movl	$21, %r8d
	movl	$1, %esi
	leal	1(%rax,%r15), %edi
	leaq	0(%r13,%rbx), %rax
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	pushq	%rax
	call	MPI_Irecv
	movl	-616(%rbp), %eax
	movl	-568(%rbp), %r9d
	movl	$20, %r8d
	movl	-176(%rbp), %ecx
	movl	-556(%rbp), %edx
	movl	$1, %esi
	addl	$2, %r12d
	leal	(%r15,%rax), %edi
	leaq	4(%r13,%rbx), %rax
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%r13
	popq	%rax
.L81:
	cmpl	$-1, %r14d
	je	.L82
	movslq	%r12d, %rbx
	leaq	-304(%rbp), %r13
	subq	$8, %rsp
	salq	$2, %rbx
	movl	-568(%rbp), %r9d
	movq	-600(%rbp), %rdi
	leaq	0(%r13,%rbx), %rax
	movl	$30, %r8d
	movl	%r14d, %ecx
	movl	$1275068731, %edx
	movl	$1, %esi
	pushq	%rax
	call	MPI_Irecv
	leal	3(%r15), %edi
	movl	-568(%rbp), %r9d
	leaq	4(%r13,%rbx), %rax
	movl	$33, %r8d
	movl	%r14d, %ecx
	movl	$1275068731, %edx
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	movl	$1, %esi
	addl	$2, %r12d
	movq	%rax, (%rsp)
	call	MPI_Isend
	popq	%r11
	popq	%rbx
.L82:
	movl	-676(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L83
	leal	1(%r15), %r14d
	movslq	%r12d, %rbx
	leaq	-304(%rbp), %r13
	salq	$2, %rbx
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movslq	%r14d, %rdi
	leaq	0(%r13,%rbx), %rax
	addq	-600(%rbp), %rdi
	movl	$31, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	pushq	%rax
	movl	%ecx, %r14d
	call	MPI_Irecv
	movl	-616(%rbp), %edx
	movl	-568(%rbp), %r9d
	leaq	4(%r13,%rbx), %rax
	movl	$32, %r8d
	movl	%r14d, %ecx
	movl	$1, %esi
	addl	$2, %r12d
	movq	%rax, (%rsp)
	leal	(%r15,%rdx), %edi
	movl	$1275068731, %edx
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Isend
	popq	%r9
	popq	%r10
.L83:
	movl	-672(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L84
	movl	-584(%rbp), %eax
	movslq	%r12d, %r14
	leaq	-304(%rbp), %r13
	salq	$2, %r14
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$32, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	leal	1(%rax), %ebx
	leaq	0(%r13,%r14), %rax
	imull	-616(%rbp), %ebx
	pushq	%rax
	movslq	%ebx, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	subl	-616(%rbp), %ebx
	movl	-568(%rbp), %r9d
	leaq	4(%r13,%r14), %rax
	movl	-672(%rbp), %ecx
	movl	$31, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$2, %r12d
	movq	%rax, (%rsp)
	leal	1(%rbx), %edi
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Isend
	popq	%rdi
	popq	%r8
.L84:
	movl	-648(%rbp), %ecx
	cmpl	$-1, %ecx
	je	.L77
	movl	-584(%rbp), %eax
	movslq	%r12d, %r14
	leaq	-304(%rbp), %r13
	salq	$2, %r14
	subq	$8, %rsp
	movl	-568(%rbp), %r9d
	movl	$33, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	leal	1(%rax), %ebx
	leaq	0(%r13,%r14), %rax
	imull	-616(%rbp), %ebx
	pushq	%rax
	leal	1(%rbx,%r15), %edi
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Irecv
	subl	-616(%rbp), %ebx
	movl	-568(%rbp), %r9d
	leaq	4(%r13,%r14), %rax
	movl	-648(%rbp), %ecx
	movl	$30, %r8d
	movl	$1275068731, %edx
	movl	$1, %esi
	addl	$2, %r12d
	movq	%rax, (%rsp)
	leal	(%rbx,%r15), %edi
	movslq	%edi, %rdi
	addq	-600(%rbp), %rdi
	call	MPI_Isend
.LEHE10:
	popq	%rcx
	popq	%rsi
	jmp	.L77
.L256:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	$2, %r9d
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	movl	$1, %r8d
	pushq	$2
	pushq	$1
	call	_Z5sobelPKhiPfS1_iiii
	cmpl	$-1, %r12d
	popq	%r11
	popq	%r14
	je	.L90
	pushq	%r15
	pushq	$2
.L248:
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	$2, %r9d
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	movl	$1, %r8d
	leal	1(%r15), %r14d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	$2, %r9d
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	movl	$1, %r8d
	pushq	%r14
	pushq	%r15
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L92
.L257:
	cmpl	$-1, %r12d
	je	.L90
	pushq	%r15
	pushq	$1
	jmp	.L248
.L95:
	cmpl	$-1, %r12d
	jne	.L137
.L241:
	addl	$1, %r13d
	je	.L104
.L249:
	movl	-584(%rbp), %eax
	leal	1(%rax), %ebx
.L140:
	xorl	%edx, %edx
	cmpl	$-1, -676(%rbp)
	leal	1(%r15), %r14d
	movl	%r14d, %ecx
	setne	%dl
	addl	$1, %edx
	jmp	.L102
.L151:
	movq	$0, -600(%rbp)
	movl	$0, -640(%rbp)
	jmp	.L75
.L90:
	cmpl	$-1, -676(%rbp)
	leal	1(%r15), %r14d
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	je	.L262
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	movl	$2, %r9d
	pushq	%r14
	pushq	$2
	movl	$1, %r8d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%r9
	popq	%r10
	jmp	.L147
.L259:
	movl	-616(%rbp), %eax
	movl	%r12d, -500(%rbp)
	movl	%eax, -512(%rbp)
	movl	-620(%rbp), %eax
	movl	%eax, -508(%rbp)
	movl	-584(%rbp), %eax
	movl	%eax, -504(%rbp)
	movl	%eax, -624(%rbp)
	jmp	.L141
.L262:
	movl	-616(%rbp), %esi
	movq	-600(%rbp), %rdi
	movl	$2, %r9d
	pushq	%r14
	pushq	$1
	movl	$1, %r8d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rax
	popq	%rdx
	jmp	.L241
.L148:
	movl	-584(%rbp), %r8d
	movq	-600(%rbp), %rdi
	movq	-464(%rbp), %rcx
	movq	-496(%rbp), %rdx
	movl	-616(%rbp), %esi
	pushq	$2
	leal	1(%r8), %ebx
	pushq	$1
	movl	%ebx, %r9d
	call	_Z5sobelPKhiPfS1_iiii
	popq	%rdi
	popq	%r8
	jmp	.L140
.L165:
	movq	-464(%rbp), %rdi
	movq	%rax, %rbx
	testq	%rdi, %rdi
	je	.L245
	vzeroupper
	call	_ZdlPv
.L130:
	movq	-496(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L132
	call	_ZdlPv
.L132:
	movq	-600(%rbp), %rax
	testq	%rax, %rax
	je	.L133
	movq	%rax, %rdi
	call	_ZdlPv
.L133:
	movq	%rbx, %rdi
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L245:
	vzeroupper
	jmp	.L130
.L162:
.L252:
	movq	%rax, %rbx
	movq	-112(%rbp), %rdi
	leaq	-112(%rbp), %rax
	addq	$16, %rax
	cmpq	%rax, %rdi
	je	.L244
	vzeroupper
	call	_ZdlPv
	jmp	.L133
.L161:
	jmp	.L252
.L163:
	movq	%rax, %rbx
	vzeroupper
	jmp	.L132
.L261:
	movl	-616(%rbp), %edx
	movl	-584(%rbp), %ebx
	movl	%r12d, -500(%rbp)
	movl	%edx, -512(%rbp)
	movl	-620(%rbp), %edx
	subl	$2, %ebx
	movl	%ebx, -624(%rbp)
	movl	%ebx, -504(%rbp)
	movl	%edx, -508(%rbp)
	jmp	.L144
.L164:
	movq	%rax, %rbx
	vzeroupper
	jmp	.L130
.L244:
	vzeroupper
	jmp	.L133
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
	.uleb128 .L161-.LFB7612
	.uleb128 0
	.uleb128 .LEHB5-.LFB7612
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB7612
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L162-.LFB7612
	.uleb128 0
	.uleb128 .LEHB7-.LFB7612
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB8-.LFB7612
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L163-.LFB7612
	.uleb128 0
	.uleb128 .LEHB9-.LFB7612
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L164-.LFB7612
	.uleb128 0
	.uleb128 .LEHB10-.LFB7612
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L165-.LFB7612
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
