#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define SENSORS 2

#define N 0
#define O 1
#define T 2
#define G 3
#define D 4
#define U 5

extern void _setbit(unsigned char*,unsigned char);
extern unsigned char _getbit(unsigned char,unsigned char);
void update_temp( int *temps);
void update_flags( int *temps,int *last_temps, unsigned char *flags);
void print_flag(unsigned char flags);

int main(void)
{
	srand(time(NULL));
	int temps[SENSORS] = {25,25};
	int last_temps[SENSORS] = {25,25};
	unsigned char flags[SENSORS] = {0b00000001,0b00000001};
	int opcion;

	do
	{
		printf("\n\r SENSOR 1: ~ %d °C ",temps[0]);
		print_flag(flags[0]);
		printf("\n\r SENSOR 2: ~ %d °C ",temps[1]);
		print_flag(flags[1]);

		printf("\n\r [1] Actualizar");
		printf("\n\r [2] Salir");
		printf("\n\r Seleccionar opción: ");
		scanf("%d",&opcion);

		if(opcion == 1)
		{
			update_temp(temps);
			update_flags(temps,last_temps,flags);
		}
	} while(opcion != 2);

	printf("\n\rFIN DE PROGRAMA\n\n\r");
	return 0;
}

void update_temp( int *temps)
{
	int min = -5,max = 5;
	for(int i = 0 ; i < SENSORS; i++)
	{
		temps[i]+=rand() % (max - min + 1) + min;
	}
}

void update_flags( int *temps,int *last_temps, unsigned char *flags)
{
	for(int i = 0 ; i < SENSORS; i++)
	{
		int dif = temps[i] - last_temps[i];
		if(dif < 0) dif = -dif;

		flags[i] = 0;

		if(temps[i] == last_temps[i]) _setbit(&flags[i],N);
		if(temps[i] > last_temps[i])  _setbit(&flags[i],U);
		if(temps[i] < last_temps[i])  _setbit(&flags[i],D);

		if(dif == 1) _setbit(&flags[i],O);
		if(dif == 2) _setbit(&flags[i],T);
		if(dif > 2)  _setbit(&flags[i],G);

		last_temps[i] = temps[i];
	}
}

void print_flag(unsigned char flag)
{
	if(_getbit(flag,N)) printf("-");

	if(_getbit(flag,U))
	{
		if(_getbit(flag,O)) printf(">");
		if(_getbit(flag,T)) printf(">>");
		if(_getbit(flag,G)) printf(">>>");
	}

	if(_getbit(flag,D))
	{
		if(_getbit(flag,O)) printf("<");
		if(_getbit(flag,T)) printf("<<");
		if(_getbit(flag,G)) printf("<<<");
	}
}