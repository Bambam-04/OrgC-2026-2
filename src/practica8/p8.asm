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
    termios resb 36

section .text
    global _start

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

    mov eax, 1
    xor ebx, ebx
    int 0x80

getch:
    push ebx
    push ecx
    push edx

    call canonical_off

    push dword 0
    mov eax, 3
    mov ebx, 0
    mov ecx, esp
    mov edx, 1
    int 0x80

    call canonical_on
    pop eax

    pop edx
    pop ecx
    pop ebx
    ret

getche:
    call getch
    call putchar
    ret

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
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, edx
    xor edx, edx
.largo:
    cmp byte [ecx + edx], 0
    je .escribir
    inc edx
    jmp .largo

.escribir:
    mov eax, 4
    mov ebx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
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

canonical_off:
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5401
    mov edx, termios
    int 0x80
    and dword [termios + 12], ~(2 | 8)
    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5402
    mov edx, termios
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

canonical_on:
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5401
    mov edx, termios
    int 0x80
    or dword [termios + 12], (2 | 8)
    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5402
    mov edx, termios
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret