section .text
global set_bit
global get_bit

set_bit:
    push ebp
    mov ebp, esp
    mov edx, [ebp+8]
    movzx ecx, byte [ebp+12]
    and ecx, 7
    mov eax, 1
    shl eax, cl
    or [edx], al
    pop ebp
    ret

get_bit:
    push ebp
    mov ebp, esp
    movzx eax, byte [ebp+8]
    movzx ecx, byte [ebp+12]
    and ecx, 7
    shr eax, cl
    and eax, 1
    pop ebp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
