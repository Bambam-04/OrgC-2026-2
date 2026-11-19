build:
	rm -f *.o
	gcc -m32 -c main.c
	nasm -f elf funciones.asm
	gcc -m32 funciones.o main.o -no-pie -z noexecstack -o ../../bin/practica10.exe

run:
	./../../bin/practica10.exe
