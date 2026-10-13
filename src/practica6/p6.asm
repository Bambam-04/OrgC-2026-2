%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 255
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    msg3 db ln,'MAYUS: ', 0
    msg4 db ln,'MINUS: ', 0
    
section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    mov edx, msg1        
    call puts   

    mov edx, cadena       ; EDX apunta a la variable donde guardaremos el texto
    mov ax, lencadena     ; AX almacena el tamaño máximo (255)
    call captura

    mov edx, msg2
    call puts

    mov edx, cadena       ; EDX apunta a la cadena que acabamos de capturar
    call puts             ; Imprime lo que el usuario escribió

    ;ejercicio 2
    mov edx, msg3
    call puts

    mov edx, cadena
    call mayus
    mov edx, cadena
    call puts
    
    ;ejercicio 3
    mov edx, msg4
    call puts

    mov edx, cadena
    call minus
    mov edx, cadena
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
    pushad                      ; Guardamos el estado de los registros en la pila
    mov ebx, edx                ; EBX guarda la dirección inicial de 'cadena'
    mov cx, ax                  ; CX guarda el tamaño máximo (255)
    dec cx                      ; CX = 254 (dejamos 1 byte libre para el nulo '0')
    mov esi, 0                  ; ESI será nuestro contador de caracteres (empieza en 0)

    .bucle_leer:
    call getch                  ; Lee una tecla presionada sin mostrarla aún (resultado en AL)

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
    jge .bucle_leer             ; Si se llenó, ignora la tecla y vuelve a esperar

    ; --- Guardar e imprimir caracter ---
    mov [ebx + esi], al         ; Guarda la letra en la posición 'cadena + ESI'
    call putchar                ; Imprime la letra en la pantalla
    inc esi                     ; Incrementa el contador (ESI = ESI + 1)
    jmp .bucle_leer             ; Vuelve a pedir otro caracter

    ;borra caracter de la terminal 
    .es_backspace:
    cmp esi, 0                  ; ¿Hemos escrito al menos 1 letra?
    jle .bucle_leer             ; Si ESI <= 0, no hay nada que borrar -> vuelve a pedir tecla

    dec esi                     ; Retrocedemos 1 posición en el buffer de memoria
    call borrar                 ; Borra visualmente el caracter de la terminal
    jmp .bucle_leer             ; Vuelve a pedir otro caracter

    .fin_captura:
    mov byte [ebx + esi], 0     ; Agrega el caracter nulo (0) al final de la cadena
    popad                       ; Restaura los registros a su estado original
    ret                         ; Regresa al programa principal (_start)

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

    ;----------------------------------------------- 2- MAYUSCULAS -------------------------------------------
    mayus:
    pushad                      ; Guardamos el estado de los registros en la pila
    mov ebx, edx                ; EBX guarda la dirección inicial de 'cadena'
    mov esi, 0                  ; ESI será nuestro contador de caracteres (empieza en 0)

    .bucle_mayus:
    mov al, byte [ebx + esi]
    
    cmp al, 0
    je .fin_mayus

    cmp al, 'a'
    jl .siguiente

    cmp al, 'z'
    jg .siguiente

    sub al, 32
    mov [ebx + esi], al

    .siguiente:
    inc esi
    jmp .bucle_mayus

    .fin_mayus:
    popad
    ret
    

    ;----------------------------------------------- 3- MINUSCULAS -------------------------------------------
    minus:
    pushad                     ; Guardamos el estado de los registros en la pila
    mov ebx, edx                ; EBX guarda la dirección inicial de 'cadena'
    mov esi, 0                  ; ESI será nuestro contador de caracteres (empieza en 0)

    .bucle_minus:
    mov al, byte[ebx + esi]
    
    cmp al, 0
    je .fin_minus

    cmp al, 'A'
    jl .siguiente

    cmp al, 'Z'
    jg .siguiente

    add al, 32
    mov [ebx + esi], al

    .siguiente:
    inc esi
    jmp .bucle_minus

    .fin_minus:
    popad
    ret