extern printf
extern fprintf

extern SquareSPHERE
extern SquarePARALLELEPIPED
extern SquareTETRAHEDRON

extern SPHERE
extern PARALLELEPIPED
extern TETRAHEDRON


global OutSPHERE
OutSPHERE:
section .data
    .outfmt db "It is SPHERE: x = %d, density = %d. Square = %f",10,0
section .bss
    .prect  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.prect], rdi          
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    
    call    SquareSPHERE
    movsd   [.p], xmm0          


    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.prect]      
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4] 
    ;movsd   xmm1, [.prect]       ; density
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret


global OutPARALLELEPIPED
OutPARALLELEPIPED:
section .data
    .outfmt db "It is PARALLELEPIPED: a = %d, b = %d, c = %d, density = %d. Square = %f",10,0
section .bss
    .ptrian  resq  1
    .FILE   resq  1       
    .p      resq  1       
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.ptrian], rdi        ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    call    SquarePARALLELEPIPED
    movsd   [.p], xmm0          ; сохранение (может лишнее) 


    ; Вывод информации о треугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        
    mov     rax, [.ptrian]      
    mov     edx, [rax]          ; a
    mov     ecx, [rax+4]        ; b
    mov      r8, [rax+8]        ; c
    mov     r9, [rax+12]        ; density
    ;movsd   xmm1, [rax+12]
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

global OutTETRAHEDRON
OutTETRAHEDRON:
section .data
    .outfmt db "It is TETRAHEDRON: x = %d, density = %d. Square = %f",10,0
section .bss
    .tetrah  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1      
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.tetrah], rdi         
    mov     [.FILE], rsi          ; сохраняется указатель на файл

  
    call    SquareTETRAHEDRON
    movsd   [.p], xmm0          

    mov     rdi, [.FILE]
    mov     rsi, .outfmt        
    mov     rax, [.tetrah]       
    mov     edx, [rax]         
    mov     ecx, [rax+4] 
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret


global OutShape
OutShape:
section .data
    .erShape db "Incorrect figure!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je sphereOut
    cmp eax, [PARALLELEPIPED]
    je parallelOut
    cmp eax, [TETRAHEDRON]
    je tetrahOut
    mov rdi, .erShape
    mov rax, 0
    call fprintf
    jmp     return
sphereOut:
    add     rdi, 4
    call    OutSPHERE
    jmp     return

parallelOut:
    add     rdi, 4
    call    OutPARALLELEPIPED
    jmp     return

tetrahOut:
    add     rdi, 4
    call    OutTETRAHEDRON
return:
leave
ret


global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor ecx, ecx            ; счетчик фигур = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutShape    

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.pcont]
    add     rax, 32        ; адрес следующей фигуры
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret

