section .text
global maximo, _maximo
global minimo, _minimo
global sumatoria, _sumatoria

%macro PROTOENTRADA 0
    push ebp
    mov ebp, esp
%endmacro

%macro PROTOSALIDA 0
    mov esp, ebp
    pop ebp
%endmacro

%macro WHILE 4
%1:
    cmp %3, %4
    jge %2
%endmacro

%macro ENDWHILE 2
    jmp %1
%2:
%endmacro

maximo:
_maximo:
    PROTOENTRADA
    push ebx
    push esi
    mov ebx, [ebp+8]        ; arr
    mov ecx, [ebp+12]       ; len
    mov eax, [ebx]          ; max = arr[0]
    mov esi, 1              ; i = 1
    WHILE .inicio, .fin, esi, ecx   ; while (i < len)
        mov edx, [ebx+esi*4]
        cmp edx, eax
        jle .no_cambia_max
        mov eax, edx        ; max = arr[i]
.no_cambia_max:
        inc esi
    ENDWHILE .inicio, .fin
    pop esi
    pop ebx
    PROTOSALIDA
    ret

minimo:
_minimo:
    PROTOENTRADA
    push ebx
    push esi
    mov ebx, [ebp+8]        ; arr
    mov ecx, [ebp+12]       ; len
    mov eax, [ebx]          ; min = arr[0]
    mov esi, 1              ; i = 1
    WHILE .inicio, .fin, esi, ecx   ; while (i < len)
        mov edx, [ebx+esi*4]
        cmp edx, eax
        jge .no_cambia_min
        mov eax, edx        ; min = arr[i]
.no_cambia_min:
        inc esi
    ENDWHILE .inicio, .fin
    pop esi
    pop ebx
    PROTOSALIDA
    ret

sumatoria:
_sumatoria:
    PROTOENTRADA
    push ebx
    push esi
    mov ebx, [ebp+8]        ; arr
    mov ecx, [ebp+12]       ; len
    xor eax, eax            ; suma = 0
    xor esi, esi            ; i = 0
    WHILE .inicio, .fin, esi, ecx   ; while (i < len)
        add eax, [ebx+esi*4]
        inc esi
    ENDWHILE .inicio, .fin
    pop esi
    pop ebx
    PROTOSALIDA
    ret