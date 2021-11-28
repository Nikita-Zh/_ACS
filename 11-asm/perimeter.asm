;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------

extern SPHERE
extern PARALLELEPIPED

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterSPHERE(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}
global PerimeterSPHERE
PerimeterSPHERE:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov eax, [rdi]
    add eax, [rdi+4]
    shl eax, 1
    cvtsi2sd    xmm0, eax

leave
ret

;----------------------------------------------
; double PerimeterPARALLELEPIPED(void *t) {
;    return (double)(*((int*)t)
;       + *((int*)(t+intSize))
;       + *((int*)(t+2*intSize)));
;}
global PerimeterPARALLELEPIPED
PerimeterPARALLELEPIPED:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov eax, [rdi]
    add eax, [rdi+4]
    add eax, [rdi+8]
    cvtsi2sd    xmm0, eax

leave
ret

;----------------------------------------------
; Вычисление периметра фигуры
;double PerimeterShape(void *s) {
;    int k = *((int*)s);
;    if(k == SPHERE) {
;        return PerimeterSPHERE(s+intSize);
;    }
;    else if(k == PARALLELEPIPED) {
;        return PerimeterPARALLELEPIPED(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global PerimeterShape
PerimeterShape:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je rectPerimeter
    cmp eax, [PARALLELEPIPED]
    je trianPerimeter
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
rectPerimeter:
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    PerimeterSPHERE
    jmp     return
trianPerimeter:
    ; Вычисление периметра треугольника
    add     rdi, 4
    call    PerimeterPARALLELEPIPED
return:
leave
ret

;----------------------------------------------
;// Вычисление суммы периметров всех фигур в контейнере
;double PerimeterSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += PerimeterShape(tmp);
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
    call PerimeterShape     ; Получение периметра первой фигуры
    addsd xmm1, xmm0        ; накопление суммы
    inc rcx                 ; индекс следующей фигуры
    add r10, 16             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd xmm0, xmm1
leave
ret
