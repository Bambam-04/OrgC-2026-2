%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 64
    lenbuffer equ 12
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    msg3 db ln,'ATOI: ', 0
    msg4 db ln,'ITOA: ', 0
    
section .bss
    cadena resb lencadena
    buffer resb lenbuffer

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ;CAPTURAR LOS NUMEROS   
    mov edx, msg1        
    call puts   

    mov edx, cadena
    mov ax, lencadena
    call captura

    mov edx, msg2
    call puts
    mov edx, cadena
    call puts

    ;AQUI TERMINA

    ;EJERCICIO ATOI
    mov edx , cadena
    call atoi
    push edx
    mov edx, msg3
    call puts
    pop edx
    call puts

    ;AÑADIRLE CANTIDAD
    add eax, 65


    ;EJERCICIO ITOA
    mov edx, buffer
    mov ecx, lenbuffer
    call itoa
    push edx
    mov edx, msg4
    call puts
    pop edx
    call puts
    

    jmp .fin_programa  

    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        mov eax, 1            ; Llamada sys_exit
        xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

   ;-----------------------------------------------1- CAPTURAR-------------------------------------------
    captura:
    pushad
    mov ebx, edx
    mov cx, ax
    dec cx
    mov esi, 0

    .bucle_leer:
    call getch

    ;¿Presionó ENTER?
    cmp al, 0x0D                ; ¿Es Enter?
    je .fin_captura
    cmp al, 0x0A                ; ¿Es Enter (Salto de línea)?
    je .fin_captura

    ; ¿Presionó BACKSPACE (Borrar)?
    cmp al, bskey               ; Compara con 0x7F (o 0x08)
    je .es_backspace
    cmp al, 0x08
    je .es_backspace

    ; Caracter normal: Verificar límite
    cmp si, cx                  ; ¿Llegamos al límite de caracteres?
    jge .bucle_leer

    ; --- Guardar e imprimir caracter ---
    mov [ebx + esi], al
    call putchar
    inc esi
    jmp .bucle_leer

    ;borra caracter de la terminal 
    .es_backspace:
    cmp esi, 0                  ; ¿Hemos escrito al menos 1 letra?
    jz .bucle_leer

    dec esi
    call borrar
    jmp .bucle_leer

    .fin_captura:
    mov byte [ebx + esi], 0
    popad
    ret

    borrar:
        push ax 
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        ret 

;------------------------------------------------- 2 - ATOI ----------------------------------------------------
    atoi:
    push ebx
    push ecx
    push edx
    push esi

    mov ebx, edx
    xor esi, esi
    xor eax, eax
    xor ecx, ecx

.espacios:
    movzx edx, byte [ebx + esi]
    cmp dl, ' '
    je .saltar
    cmp dl, 0x09
    jne .signo
.saltar:
    inc esi
    jmp .espacios

.signo:
    cmp dl, '-'
    jne .mas
    mov ecx, 1              ; es negativo
    inc esi
    jmp .digitos
.mas:
    cmp dl, '+'
    jne .digitos
    inc esi

.digitos:
    movzx edx, byte [ebx + esi]
    cmp dl, '0'
    jb .fin
    cmp dl, '9'
    ja .fin
    sub dl, '0'             ; ASCII -> valor
    imul eax, eax, 10       ; resultado *= 10
    add eax, edx            ; resultado += dígito
    inc esi
    jmp .digitos

.fin:
    test ecx, ecx
    jz .salir
    neg eax                 ; aplicar signo negativo

.salir:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret



;---------------------------------- ITOA ---------------------------------------

itoa:
    
    push ebx
    push ecx
    push esi
    push edi
    push ebp
 
    mov ebp, ecx
    mov edi, edx
    mov esi, edx
    mov ebx, 10
    xor ecx, ecx               
 
    test eax, eax
    jns .extraer
    mov byte [esi], '-'         ; espacio para el signo en la primera posicion
    inc esi
    neg eax
 
.extraer:                       ; divisiones base 10 (do-while, sirve para 0)
    xor edx, edx
    div ebx                     ; eax = cociente, edx = residuo
    push edx                    ; los digitos salen al reves
    inc ecx
    test eax, eax
    jnz .extraer
 
    ; verificar que quepa: (signo) + digitos + nulo <= longitud
    mov eax, esi
    sub eax, edi
    add eax, ecx
    inc eax
    cmp eax, ebp
    ja .no_cabe
 
.escribir:
    pop edx
    add dl, '0'                 ; valor -> ASCII
    mov [esi], dl
    inc esi
    loop .escribir
    jmp .cerrar
 
.no_cabe:
    lea esp, [esp + ecx*4]      ; descarta los digitos de la pila
    mov esi, edi                ; cadena vacia
 
.cerrar:
    mov byte [esi], 0
    mov edx, edi                ; retorno: direccion de inicio
 
    pop ebp
    pop edi
    pop esi
    pop ecx
    pop ebx
    ret