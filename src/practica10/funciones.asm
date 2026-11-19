section .text
global set_bit
global get_bit

set_bit:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    mov cl, [ebp+12]
    mov dl, 1
    shl dl, cl
    or [eax], dl
    pop ebp
    ret

get_bit:
    push ebp
    mov ebp, esp
    movzx eax, byte [ebp+8]
    mov cl, [ebp+12]
    shr eax, cl
    and eax, 1
    pop ebp
    ret