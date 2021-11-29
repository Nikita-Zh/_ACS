extern SPHERE
extern PARALLELEPIPED
extern TETRAHEDRON


global SquareSPHERE
SquareSPHERE:
section .data
    PI dq 3.14 ;11,00100011b ; 3,14
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
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

    ; В rdi адрес треугольника
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

    ; В rdi адрес прямоугольника
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
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    SquareSPHERE
    jmp     return
parallelSquare:
    ; Вычисление периметра треугольника
    add     rdi, 4
    call    SquarePARALLELEPIPED
    jmp     return

tetrahSquare:
    add     rdi, 4
    call    SquareTETRAHEDRON

return:
leave
ret

;----------------------------------------------
;// Вычисление суммы периметров всех фигур в контейнере
;double PerimeterSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += SquareShape(tmp);
;        tmp = tmp + shapeSize;
;    }
;    return sum;
;}
global PerimeterSumContainer
PerimeterSumContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov ebx, esi            ; число фигур
    xor ecx, ecx            ; счетчик фигур
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call SquareShape     ; Получение периметра первой фигуры
    addsd xmm1, xmm0        ; накопление суммы
    inc rcx                 ; индекс следующей фигуры
    add r10, 32           ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd xmm0, xmm1
leave
ret

global InsertionSort
InsertionSort:
section .data
    .sum    dq  0.0
    .current dq 0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov ebx, esi            ; число фигур
    xor ecx, ecx            ; счетчик фигур
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
    movsd xmm2, [.current]
.loop1:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    mov r11, r10 
    call SquareShape     ; Получение периметра первой фигуры
    mov xmm2, xmm0           ; current shape.square
    jmp .while
        
         ; накопление суммы
    inc rcx                 ; индекс следующей фигуры
    add r10, 32           ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop1

.while:
    call SquareShape     ; Получение периметра первой фигуры
    addsd xmm1, xmm0   


.return:
    movsd xmm0, xmm1
leave
ret
