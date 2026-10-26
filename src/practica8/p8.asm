extern canonical_off
extern canonical_on

bskey       equ 127
bskey2      equ 8
lencadena   equ 20

section .data
    msg_ent db "Ingrese una cadena: ", 0
    msg_may db "Mayusculas: ", 0
    msg_min db "Minusculas: ", 0
    nl      db 10, 0

section .bss
    cadena  resb lencadena

section .text
    global _start         ; referencia para inicio de programa

_start:
    mov edx, msg_ent
    call puts

    mov edx, cadena
    mov ax, lencadena
    call captura

    mov edx, nl
    call puts

    mov edx, cadena
    call mayusculas
    mov edx, msg_may
    call puts
    mov edx, cadena
    call puts
    mov edx, nl
    call puts

    mov edx, cadena
    call minusculas
    mov edx, msg_min
    call puts
    mov edx, cadena
    call puts
    mov edx, nl
    call puts

    ; --- FIN DE PROGRAMA ---
    .fin_programa:
        mov eax, 1            ; Llamada sys_exit
        xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

    putchar:
        push eax
        push ebx
        push ecx
        push edx

        push eax
        mov eax, 4
        mov ebx, 1
        mov ecx, esp
        mov edx, 1
        int 0x80
        add esp, 4

        pop edx
        pop ecx
        pop ebx
        pop eax
        ret

    puts:
        ;SE USA putchar
        push eax
        push esi

        mov esi, edx
    .sigue:
        mov al, [esi]
        cmp al, 0
        je .fin
        call putchar
        inc esi
        jmp .sigue
    .fin:
        pop esi
        pop eax
        ret

    getch:
        push ebx
        push ecx
        push edx

        call canonical_off
        push eax
        mov eax, 3
        mov ebx, 0
        mov ecx, esp
        mov edx, 1
        int 0x80
        pop eax
        call canonical_on

        pop edx
        pop ecx
        pop ebx
        ret

    getche:
        call getch
        call putchar
        ret

    borrar:
        push eax
        mov al, 8
        call putchar
        mov al, ' '
        call putchar
        mov al, 8
        call putchar
        pop eax
        ret

    captura:
        push ebx
        push ecx
        push esi
        push eax

        mov esi, edx
        xor ebx, ebx
        movzx ecx, ax
        cmp ecx, 1
        jbe .fin
        dec ecx

    .ciclo:
        call getch
        cmp al, 10
        je .fin
        cmp al, 13
        je .fin
        cmp al, bskey
        je .retro
        cmp al, bskey2
        je .retro
        cmp al, 32
        jb .ciclo
        cmp ebx, ecx
        jae .ciclo

        mov [esi + ebx], al
        inc ebx
        call putchar
        jmp .ciclo

    .retro:
        test ebx, ebx
        jz .ciclo
        dec ebx
        call borrar
        jmp .ciclo

    .fin:
        mov byte [esi + ebx], 0

        pop eax
        pop esi
        pop ecx
        pop ebx
        ret

    mayusculas:
        push eax
        push edx
    .ciclo:
        mov al, [edx]
        cmp al, 0
        je .fin
        cmp al, 'a'
        jb .sig
        cmp al, 'z'
        ja .sig
        sub al, 32
        mov [edx], al
    .sig:
        inc edx
        jmp .ciclo
    .fin:
        pop edx
        pop eax
        ret

    minusculas:
        push eax
        push edx
    .ciclo:
        mov al, [edx]
        cmp al, 0
        je .fin
        cmp al, 'A'
        jb .sig
        cmp al, 'Z'
        ja .sig
        add al, 32
        mov [edx], al
    .sig:
        inc edx
        jmp .ciclo
    .fin:
        pop edx
        pop eax
        ret