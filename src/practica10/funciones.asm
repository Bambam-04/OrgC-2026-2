%macro PROTOENTRADA 0
	push ebp
	mov ebp,esp
%endmacro

%macro PROTOSALIDA 0
	mov esp,ebp
	pop ebp
%endmacro

section	.text
    global _setbit
    global _getbit

    _setbit:
        PROTOENTRADA
        mov eax,[ebp+8]
        mov cl,[ebp+12]
        mov dl,1
        shl dl,cl
        or [eax],dl
		PROTOSALIDA
		ret

    _getbit:
        PROTOENTRADA
        movzx eax,byte [ebp+8]
        mov cl,[ebp+12]
        shr eax,cl
        and eax,1
		PROTOSALIDA
		ret