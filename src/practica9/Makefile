build: 
	gcc -m32 -c main.c
	nasm -f elf funciones.asm
	gcc -m32 funciones.o main.o -L ../../lib -lpc_io -no-pie -z noexecstack -o ../../bin/practica9.exe
run:
	./../../bin/practica9.exe