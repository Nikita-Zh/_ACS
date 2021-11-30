extern printf
extern rand

extern SPHERE
extern PARALLELEPIPED
extern TETRAHEDRON


global Random
Random:
section .data
    .i20     dq      20
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax   
    call    rand      
    xor     rdx, rdx   
    idiv    qword[.i20]       
    mov     rax, rdx
    inc     rax       
leave
ret


global InRndSPHERE
InRndSPHERE:
section .bss
    .sphere  resq 1   ;
section .text
push rbp
mov rbp, rsp


    mov     [.sphere], rdi
    call    Random
    mov     rbx, [.sphere]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.sphere]
    mov     [rbx+4], eax

leave
ret


global InRndTETRAHEDRON
InRndTETRAHEDRON:
section .bss
    .tetrah  resq 1   
section .text
push rbp
mov rbp, rsp


    mov     [.tetrah], rdi
    call    Random
    mov     rbx, [.tetrah]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.tetrah]
    mov     [rbx+4], eax

leave
ret

global InRndPARALLELEPIPED
InRndPARALLELEPIPED:
section .bss
    .parallel  resq 1 
section .text
push rbp
mov rbp, rsp

    mov     [.parallel], rdi

    call    Random
    mov     rbx, [.parallel]
    mov     [rbx], eax

    call    Random
    mov     rbx, [.parallel]
    mov     [rbx+4], eax

    call    Random
    mov     rbx, [.parallel]
    mov     [rbx+8], eax   

    call    Random
    mov     rbx, [.parallel]
    mov     [rbx+12], eax 
leave
ret

global InRndShape
InRndShape:
section .data
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pshape     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp
    mov [.pshape], rdi

    rdtsc
    xor edx, edx
    mov ecx, 3
    div ecx
    mov eax, edx
    add eax, 1

    mov     rdi, [.pshape]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [SPHERE]
    je .sphereInrnd
    cmp eax, [PARALLELEPIPED]
    je .parallelepipedInRnd
    cmp eax, [TETRAHEDRON]
    je .tetrahedronInRnd

    xor eax, eax        ; код возврата = 0
    jmp     .return

.sphereInrnd:
    add     rdi, 4
    call    InRndSPHERE
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.parallelepipedInRnd:
    add     rdi, 4
    call    InRndPARALLELEPIPED
    mov     eax, 1      ;код возврата = 1
    jmp     .return

.tetrahedronInRnd:
    add     rdi, 4
    call    InRndTETRAHEDRON
    mov     eax, 1      ;код возврата = 1

.return:
leave
ret

global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndShape     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 32             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
