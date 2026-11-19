#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 0
#define O 1
#define T 2
#define G 3
#define D 4
#define U 5

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

void update_temp(int *temps)
{
    temps[0] = temps[0] + rand() % 11 - 5;
    temps[1] = temps[1] + rand() % 11 - 5;
}

void flags_sensor(int temp, int last, unsigned char *flag)
{
    int dif = temp - last;
    if (dif < 0) dif = -dif;

    *flag = 0;

    if (temp == last) set_bit(flag, N);
    if (temp > last)  set_bit(flag, U);
    if (temp < last)  set_bit(flag, D);

    if (dif == 1) set_bit(flag, O);
    if (dif == 2) set_bit(flag, T);
    if (dif > 2)  set_bit(flag, G);
}

void update_flags(int *temps, int *last_temps, unsigned char *flags)
{
    flags_sensor(temps[0], last_temps[0], &flags[0]);
    flags_sensor(temps[1], last_temps[1], &flags[1]);

    last_temps[0] = temps[0];
    last_temps[1] = temps[1];
}

void mostrar(unsigned char flag)
{
    if (get_bit(flag, N)) printf("-");

    if (get_bit(flag, U)) {
        if (get_bit(flag, O)) printf(">");
        if (get_bit(flag, T)) printf(">>");
        if (get_bit(flag, G)) printf(">>>");
    }

    if (get_bit(flag, D)) {
        if (get_bit(flag, O)) printf("<");
        if (get_bit(flag, T)) printf("<<");
        if (get_bit(flag, G)) printf("<<<");
    }
}

int main()
{
    unsigned char banderas[2] = {1, 1};
    int ultima_lectura[2] = {25, 25};
    int tem_sensores[2] = {25, 25};
    int opcion;

    srand(time(NULL));

    do {
        printf("SENSOR 1: ~ %d °C ", tem_sensores[0]);
        mostrar(banderas[0]);
        printf("\nSENSOR 2: ~ %d °C ", tem_sensores[1]);
        mostrar(banderas[1]);

        printf("\n[1] Actualizar\n[2] Salir\nSeleccionar opción: ");
        scanf("%d", &opcion);
        printf("\n");

        if (opcion == 1) {
            update_temp(tem_sensores);
            update_flags(tem_sensores, ultima_lectura, banderas);
        }
    } while (opcion != 2);

    return 0;
}