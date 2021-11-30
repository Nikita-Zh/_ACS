; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern SPHERE
extern PARALLELEPIPED
extern TETRAHEDRON

;----------------------------------------------
; // Ввод параметров прямоугольника из файла
; void InSPHERE(void *r, FILE *ifst) {
;     fscanf(ifst, "%d%d", (int*)r, (int*)(r+intSize));
; }
global InSPHERE
InSPHERE:
section .data
    .infmt db "%d%d",0

section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .sphere  resq    1   ; адрес прямоугольника

section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.sphere], rdi          ; сохраняется адрес cферы
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.sphere]       ; &x
    mov     rcx, [.sphere]
    add     rcx, 4          ; &density
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

    ;mov     rdi, [.FILE]
    ;mov     rsi, .infmt         ; Формат - 1-й аргумент
    ;mov     rdx, [.sphere]       ; &x
    ;movsd   xmm0, [.sphere]
    ;xadd   xmm0, 8
    ;mov     rcx, [.sphere]
    ;add     rcx, 4          ; &density
    ;cvtsi2sd xmm1, rcx
   ; mov     rax, 1            ; нет чисел с плавающей точкой
    ;call    fscanf

    
    ;lea rdx, .x
    ;push rdx
    ;lea rdx, .density
    ;push rdx
    ;lea rdx, .infmt
    ;push rdx
    ;mov rdx, 0
    ;push rdx
    ;call    fscanf

leave
ret

; // Ввод параметров треугольника из файла
; void InPARALLELEPIPED(void *t, FILE *ifst) {
;     fscanf(ifst, "%d%d%d", (int*)t,
;            (int*)(t+intSize), (int*)(t+2*intSize));
; }
global InPARALLELEPIPED
InPARALLELEPIPED:
section .data
    .infmt db "%d%d%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .parall  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.parall], rdi          ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод треугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент

    mov     rdx, [.parall]       ; &a

    mov     rcx, [.parall]
    add     rcx, 4              ; &b = &a + 4

    mov     r8, [.parall]
    add     r8, 8               ; &c = &a + 8

    mov     r9, [.parall]
    add     r9, 12
    ;movsd     xmm1, [.trian]
    ;add     xmm1, 12
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

global InTETRAHEDRON
InTETRAHEDRON:
section .data
    .infmt db "%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .tetrah  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.tetrah], rdi          ; сохраняется адрес cферы
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt        
    mov     rdx, [.tetrah]   
    mov     rcx, [.tetrah]
    add     rcx, 4        
    mov     rax, 0   
    call    fscanf

leave
ret


global InShape
InShape:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pshape     resq    1   ; адрес фигуры
    .shapeTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pshape], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pshape]      ; адрес начала фигуры (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    ; Тестовый вывод признака фигуры
    ;mov     rdi, .tagOutFmt
    ;mov     rax, [.pshape]
    ;mov     esi, [rax]
    ;call    printf

    mov rcx, [.pshape]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [SPHERE]
    je .sphereIn
    cmp eax, [PARALLELEPIPED]
    je .parallelepipedIn
    cmp eax, [TETRAHEDRON]
    je .tetrahedronIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return

.sphereIn:
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InSPHERE
    mov     rax, 1  ; Код возврата - true
    jmp     .return

.parallelepipedIn:
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InPARALLELEPIPED
    mov     rax, 1  ; Код возврата - true
    jmp     .return

.tetrahedronIn:
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InTETRAHEDRON
    mov     rax, 1  ; Код возврата - true

.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InShape(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InShape     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

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

