
#
# Copyright (c) 2014 Jason L. Wright (jason@thought.net)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

# basic assembly math routines for DARPA Cyber Grand Challenge

.macro ENTER base
    .global \base, \base\()f, \base\()l
    .type \base, @function
    .type \base\()f, @function
    .type \base\()l, @function
.endm

.macro END base
    .size \base, . - \base
    .size \base\()f, . - \base\()f
    .size \base\()l, . - \base\()l
.endm

    ENTER	sin
sinl:
    fldt	0x8(%rsp)
    fsin
    fnstsw	%ax
    sahf
    jp	1f
    ret
1:	call	twopi_rem
    fsin
    ret

sinf:
    sub	$0x10, %rsp
    movss 	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fsin
    fnstsw	%ax
    sahf
    jp	2f
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
2:	call	twopi_rem
    fsin
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret

sin:
    sub	$0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    fsin
    fnstsw	%ax
    sahf
    jp	3f
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
3:	call	twopi_rem
    fsin
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
    END	sin

    ENTER	cos
cosl:
    fldt	0x8(%rsp)
    fcos
    fnstsw	%ax
    sahf
    jp	2f
    ret
2:	call	twopi_rem
    fcos
    ret

cosf:
    sub     $0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fcos
    fnstsw	%ax
    sahf
    jp	3f
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
3:	call	twopi_rem
    fcos
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
    
cos:
    sub     $0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    fcos
    fnstsw	%ax
    sahf
    jp	4f
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
4:	call	twopi_rem
    fcos
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
    END	cos

    ENTER	tan
tanl:
    fldt	0x8(%rsp)
    fptan
    fnstsw	%ax
    sahf
    jp	2f
    fstp	%st(0)
    ret
2:	call	twopi_rem
    fptan
    fstp	%st(0)
    ret

tanf:
    sub	$0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fptan
    fnstsw	%ax
    sahf
    jp	3f
    fstp	%st(0)
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
3:	call	twopi_rem
    fptan
    fstp	%st(0)
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret

tan:
    sub	$0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    fptan
    fnstsw	%ax
    sahf
    jp	4f
    fstp	%st(0)
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
4:	call	twopi_rem
    fptan
    fstp	%st(0)
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
    END	tan

    .type twopi_rem, @function
twopi_rem:
    fldpi
    fadd	%st(0)
    fxch	%st(1)
1:	fprem
    fnstsw	%ax
    sahf
    jp	1b
    fstp	%st(1)
    ret
    .size	twopi_rem, . - twopi_rem

    ENTER	remainder
remainderl:
    fldt	0x18(%rsp)
    fldt	0x8(%rsp)
1:	fprem1
    fstsw	%ax
    sahf
    jp	1b
    fstp	%st(1)
    ret

remainderf:
    sub	$0x18, %rsp
    movss	%xmm0, 0x0(%rsp)
    movss	%xmm1, 0x8(%rsp)
    flds	0x0(%rsp)
    flds	0x8(%rsp)
2:	fprem1
    fstsw	%ax
    sahf
    jp	2b
    fstp	%st(1)
    fstps	0x10(%rsp)
    movss	0x10(%rsp), %xmm0
    add	$0x18, %rsp
    ret

remainder:
    sub	$0x18, %rsp
    movsd	%xmm0, 0x0(%rsp)
    movsd	%xmm1, 0x8(%rsp)
    fldl	0x0(%rsp)
    fldl	0x8(%rsp)
3:	fprem1
    fstsw	%ax
    sahf
    jp	3b
    fstp	%st(1)
    fstpl	0x10(%rsp)
    movsd	0x10(%rsp), %xmm0
    add	$0x18, %rsp
    ret
    END	remainder

    ENTER	log
logl:
    fldt	0x8(%rsp)
    fldln2
    fxch	%st(1)
    fyl2x
    ret
logf:
    sub	$0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fldln2
    fxch	%st(1)
    fyl2x
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
log:
    sub	$0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl    0x0(%rsp)
    fldln2
    fxch	%st(1)
    fyl2x
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
    END	log

    ENTER	log10
log10l:
    fldt	0x8(%rsp)
    fldlg2
    fxch	%st(1)
    fyl2x
    ret
log10f:
    sub	$0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fldlg2
    fxch	%st(1)
    fyl2x
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret

log10:
    sub	$0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    fldlg2
    fxch	%st(1)
    fyl2x
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
    END	log10

    ENTER	significand
significandl:
    fldt	0x8(%rsp)
    fxtract
    fstp	%st(1)
    ret
significandf:
    sub	$0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fxtract
    fstp	%st(1)
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
significand:
    sub	$0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    fxtract
    fstp	%st(1)
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    ret
    END	significand

    ENTER	scalbn
    ENTER	scalbln
scalbnl:
scalblnl:
    fildl	16(%rsp)
    fldt	4(%rsp)
    jmp	1f
scalbnf:
scalblnf:
    fildl	8(%rsp)
    flds	4(%rsp)
    jmp	1f
scalbn:
scalbln:
    fildl	12(%rsp)
    fldl	4(%rsp)
1:	fscale
    fstp	%st(1)
    ret
    END	scalbn
    END	scalbln

    ENTER	rint
rintl:
    fldt    0x8(%rsp)
    frndint
    ret
rintf:
    sub    $0x10, %rsp
    movss    %xmm0, 0x0(%rsp)
    flds    0x0(%rsp)
    frndint
    fstps    0x8(%rsp)
    movss    0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
rint:
    sub    $0x10, %rsp
    movsd    %xmm0, 0x0(%rsp)
    fldl    0x0(%rsp)
    frndint
    fstpl    0x8(%rsp)
    movsd    0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
    END	rint

    ENTER	sqrt
sqrtl:
    fldt	0x8(%rsp)
	fsqrt
    ret
sqrtf:
    sub    $0x10, %rsp
    movss    %xmm0, 0x0(%rsp)
    flds    0x0(%rsp)
	fsqrt
    fstps    0x8(%rsp)
    movss    0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
sqrt:
    sub    $0x10, %rsp
    movsd    %xmm0, 0x0(%rsp)
    fldl    0x0(%rsp)
	fsqrt
    fstpl    0x8(%rsp)
    movsd    0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
    END	sqrt

    ENTER	fabs
fabsl:
    fldt	4(%rsp)
    fabs
    ret
fabsf:
    sub   $0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fabs
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
fabs:
    sub   $0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    fabs
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
    END	fabs

    ENTER	atan2
atan2l:
    fldt	0x8(%rsp)
    fldt	0x18(%rsp)
	fpatan
    ret
atan2f:
    sub	$0x18, %rsp
    movss	%xmm0, 0x0(%rsp)
    movss	%xmm1, 0x8(%rsp)
    flds	0x0(%rsp)
    flds	0x8(%rsp)
	fpatan
    fstps	0x10(%rsp)
    movss	0x10(%rsp), %xmm0
    add	$0x18, %rsp
    ret
atan2:
    sub	$0x18, %rsp
    movsd	%xmm0, 0x0(%rsp)
    movsd	%xmm1, 0x8(%rsp)
    fldl	0x0(%rsp)
    fldl	0x8(%rsp)
	fpatan
    fstpl	0x10(%rsp)
    movsd	0x10(%rsp), %xmm0
    add	$0x18, %rsp
    ret
    END	atan2

    ENTER	log2
log2l:
    fldt	0x8(%rsp)
    fld1
    fxch
    fyl2x
    ret
log2f:
    sub    $0x10, %rsp
    movss    %xmm0, 0x0(%rsp)
    flds    0x0(%rsp)
    fld1
    fxch
    fyl2x
    fstps    0x8(%rsp)
    movss    0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
log2:
    sub    $0x10, %rsp
    movsd    %xmm0, 0x0(%rsp)
    fldl    0x0(%rsp)
    fld1
    fxch
    fyl2x
    fstpl    0x8(%rsp)
    movsd    0x8(%rsp), %xmm0
    add    $0x10, %rsp
    ret
    END	log2

    ENTER	exp2
    .type	exp2x, @function
exp2l:
    fldt	0x8(%rsp)
    jmp	exp2x
exp2f:
    sub    $0x10, %rsp
    movss    %xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    call	exp2x
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
exp2:
    sub    $0x10, %rsp
    movsd    %xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
    call    exp2x
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret

exp2x:
    fld	%st(0)
    frndint
    fsubr	%st,%st(1)
    fxch
    f2xm1
    fld1
    faddp
    fscale
    fstp	%st(1)
    ret
    END	exp2
    .size	exp2x, . - exp2x

    ENTER	pow
powl:	fldt	0x18(%rsp)
    fldt	0x8(%rsp)
    fyl2x
    jmp exp2x
powf:
    sub	$0x18, %rsp
    movss	%xmm0, 0x0(%rsp)
    movss	%xmm1, 0x8(%rsp)
    flds	0x8(%rsp)
    flds	0x0(%rsp)
    fyl2x
    call	exp2x
    fstps	0x10(%rsp)
    movss	0x10(%rsp), %xmm0
    add	$0x18, %rsp
    ret

pow:
    sub	$0x18, %rsp
    movsd	%xmm0, 0x0(%rsp)
    movsd	%xmm1, 0x8(%rsp)
    fldl	0x8(%rsp)
    fldl	0x0(%rsp)
    fyl2x
    call	exp2x
    fstpl	0x10(%rsp)
    movsd	0x10(%rsp), %xmm0
    add	$0x18, %rsp
    ret

    END	pow

    ENTER	exp
expl:
    fldt	4(%rsp)
    fldl2e
    fmulp
    jmp	exp2x
expf:
    sub	$0x10, %rsp
    movss	%xmm0, 0x0(%rsp)
    flds	0x0(%rsp)
    fldl2e
    fmulp
    call	exp2x
    fstps	0x8(%rsp)
    movss	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
exp:
    sub	$0x10, %rsp
    movsd	%xmm0, 0x0(%rsp)
    fldl	0x0(%rsp)
	fldl2e
    fmulp
    call	exp2x
    fstpl	0x8(%rsp)
    movsd	0x8(%rsp), %xmm0
    add	$0x10, %rsp
    ret
    END	exp
