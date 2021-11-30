extern SPHERE
extern PARALLELEPIPED
extern TETRAHEDRON


global SquareSPHERE
SquareSPHERE:
section .data
    PI dq 3.14 
section .text
push rbp
mov rbp, rsp

    mov eax, [rdi]
    cvtsi2sd    xmm0, eax
    movsd xmm1, [PI]
    mulsd xmm0, xmm0
    mulsd xmm0, xmm1
    addsd xmm0, xmm0

leave
ret


global SquarePARALLELEPIPED
SquarePARALLELEPIPED:
section .text
push rbp
mov rbp, rsp


    mov ebx, [rdi]      ;x
    mov ecx, [rdi+4]    ;y  
    mov esi, [rdi+8]    ;z
    mov edi, ebx
    imul edi, ecx       ;x*y
    mov eax, edi
    mov edi, ebx
    imul edi, esi       ;x*z
    add eax, edi
    mov edi, ecx
    imul edi, esi       ;y*z
    add eax, edi
    add eax, eax

    cvtsi2sd    xmm0, eax

leave
ret


global SquareTETRAHEDRON
SquareTETRAHEDRON:
section .data
    sqrt_3 dq 1.7320508076

section .text
push rbp
mov rbp, rsp


    mov eax, [rdi]
    cvtsi2sd    xmm0, eax
    movsd xmm1, [sqrt_3]
    mulsd xmm0, xmm0
    mulsd xmm0, xmm1

leave
ret


global SquareShape
SquareShape:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je sphereSquare
    cmp eax, [PARALLELEPIPED]
    je parallelSquare
    cmp eax, [TETRAHEDRON]
    je tetrahSquare
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return

sphereSquare:
    add     rdi, 4
    call    SquareSPHERE
    jmp     return

parallelSquare:
    add     rdi, 4
    call    SquarePARALLELEPIPED
    jmp     return

tetrahSquare:
    add     rdi, 4
    call    SquareTETRAHEDRON
    movsd xmm0, xmm1

leave
ret

return:
leave
ret
