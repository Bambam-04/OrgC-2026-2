#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define BIT_N 0
#define BIT_O 1
#define BIT_T 2
#define BIT_G 3
#define BIT_D 4
#define BIT_U 5

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

void update_temp(int *temps)
{
    int i;
    for (i = 0; i < 2; i++) {
        int delta = (rand() % 11) - 5;
        temps[i] += delta;
    }
}

void update_flags(int *temps, int *last_temps, unsigned char *flags)
{
    int i;
    for (i = 0; i < 2; i++) {
        int diff = temps[i] - last_temps[i];
        int mag = diff < 0 ? -diff : diff;

        flags[i] = 0;

        if (diff == 0) {
            set_bit(&flags[i], BIT_N);
        } else {
            if (diff > 0)
                set_bit(&flags[i], BIT_U);
            else
                set_bit(&flags[i], BIT_D);

            if (mag == 1)
                set_bit(&flags[i], BIT_O);
            else if (mag == 2)
                set_bit(&flags[i], BIT_T);
            else
                set_bit(&flags[i], BIT_G);
        }

        last_temps[i] = temps[i];
    }
}

void print_flags(unsigned char flags)
{
    char simbolo;
    int cantidad;
    int i;

    if (get_bit(flags, BIT_N)) {
        printf("-");
        return;
    }

    simbolo = get_bit(flags, BIT_U) ? '>' : '<';

    if (get_bit(flags, BIT_O))
        cantidad = 1;
    else if (get_bit(flags, BIT_T))
        cantidad = 2;
    else
        cantidad = 3;

    for (i = 0; i < cantidad; i++)
        putchar(simbolo);
}

void print_menu(int *temps, unsigned char *flags)
{
    int i;
    for (i = 0; i < 2; i++) {
        printf("SENSOR %d: ~ %d °C ", i + 1, temps[i]);
        print_flags(flags[i]);
        printf("\n");
    }
    printf("[1] Actualizar\n");
    printf("[2] Salir\n");
    printf("Seleccionar opción: ");
}

int main(void)
{
    unsigned char banderas[2];
    int ultima_lectura[2];
    int tem_sensores[2];
    int opcion = 0;
    int i;

    srand((unsigned int)time(NULL));

    for (i = 0; i < 2; i++) {
        tem_sensores[i] = 25;
        ultima_lectura[i] = 25;
        banderas[i] = 0;
        set_bit(&banderas[i], BIT_N);
    }

    do {
        print_menu(tem_sensores, banderas);

        if (scanf("%d", &opcion) != 1) {
            int c;
            while ((c = getchar()) != '\n' && c != EOF)
                ;
            opcion = 0;
        }

        printf("\n");

        if (opcion == 1) {
            update_temp(tem_sensores);
            update_flags(tem_sensores, ultima_lectura, banderas);
        }
    } while (opcion != 2);

    return 0;
}
