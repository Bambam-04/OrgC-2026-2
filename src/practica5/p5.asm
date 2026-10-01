%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena
    mov byte[msg], 'Z' ;a)
    call puts
    

    mov ebx, msg ;b)
    add ebx, 23
    mov byte[ebx], 'X'
    call puts

    mov ebx, msg ;c)
    mov byte[ebx+26], '@'
    call puts

    mov eax, 25 ;d)
    mov ebx, msg
    mov byte[ebx+eax], 'Z'
    call puts

    mov eax, 14 ;e)
    mov ebx, msg
    mov byte[ebx+eax+1], 'P'
    call puts

    mov eax, 9 ;f)
    mov ebx, msg
    add ebx, 1
    mov byte[ebx + eax * 2], '%'
    call puts



    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa