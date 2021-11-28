; file.asm - использование файлов в NASM
extern printf
extern rand

extern SPHERE
extern PARALLELEPIPED


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 20
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i20     dq      20
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

;----------------------------------------------
;// Случайный ввод параметров прямоугольника
;void InRndSPHERE(void *r) {
    ;int x = Random();
    ;*((int*)r) = x;
    ;int y = Random();
    ;*((int*)(r+intSize)) = y;
;//     printf("    SPHERE %d %d\n", *((int*)r), *((int*)r+1));
;}
global InRndSPHERE
InRndSPHERE:
section .bss
    .prect  resq 1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov     [.prect], rdi
    ; Генерация сторон прямоугольника
    call    Random
    mov     rbx, [.prect]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.prect]
    mov     [rbx+4], eax

leave
ret

;----------------------------------------------
;// Случайный ввод параметров треугольника
;void InRndPARALLELEPIPED(void *t) {
    ;int a, b, c;
    ;a = *((int*)t) = Random();
    ;b = *((int*)(t+intSize)) = Random();
    ;do {
        ;c = *((int*)(t+2*intSize)) = Random();
    ;} while((c >= a + b) || (a >= c + b) || (b >= c + a));
;//     printf("    PARALLELEPIPED %d %d %d\n", *((int*)t), *((int*)t+1), *((int*)t+2));
;}
global InRndPARALLELEPIPED
InRndPARALLELEPIPED:
section .bss
    .ptrian  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.ptrian], rdi
    ; Генерация сторон треугольника
    call    Random
    mov     rbx, [.ptrian]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.ptrian]
    mov     [rbx+4], eax
.repeat:
    call    Random
    mov     rbx, [.ptrian]
    mov     [rbx+8], eax    ; c
    ; Проверка корректности сторон
    mov     ecx, [rbx]      ; a
    mov     edx, [rbx+4]      ; b
    mov     ebx, eax        ; c
    add     eax, ecx        ; c+a
    cmp     edx, eax        ; b - (c+a)
    jge     .repeat
    mov     eax, ecx
    add     eax, edx        ; a+b
    cmp     ebx, eax        ; c - (a+b)
    jge     .repeat
    mov     eax, edx
    add     eax, ebx        ; b+c
    cmp     ecx, eax        ; a - (b+c)
    jge     .repeat

leave
ret

;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InRndShape(void *s) {
    ;int k = rand() % 2 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = SPHERE;
            ;InRndSPHERE(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = PARALLELEPIPED;
            ;InRndPARALLELEPIPED(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
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

    ; В rdi адрес фигуры
    mov [.pshape], rdi

    ; Формирование признака фигуры
    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    and     eax, 1      ; очистка результата кроме младшего разряда (0 или 1)
    inc     eax         ; фомирование признака фигуры (1 или 2)

    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pshape]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [SPHERE]
    je .rectInrnd
    cmp eax, [PARALLELEPIPED]
    je .trianInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.rectInrnd:
    ; Генерация прямоугольника
    add     rdi, 4
    call    InRndSPHERE
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.trianInRnd:
    ; Генерация треугольника
    add     rdi, 4
    call    InRndPARALLELEPIPED
    mov     eax, 1      ;код возврата = 1
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndShape(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
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
    add rdi, 16             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
