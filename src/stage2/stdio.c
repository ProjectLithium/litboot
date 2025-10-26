#include "stdio.h"
#include "vga.h"
#include <stdint.h>

uint8_t screenX, screenY;

void putc(char c)
{
    switch (c)
    {
        case '\t':
            for (int i = 0; i < (4 - (screenX % 4)); i++)
            {
                vga_putc(' ', screenX, screenY, 0x07, 0x00);
                screenX++;
                if (screenX >= VGA_TTY_WIDTH)
                {
                    screenX = 0;
                    screenY++;
                    break;
                }
            }
            break;
        case '\r':
            screenX = 0;
            break;
        case '\n':
            screenX = 0;
            screenY++;
            break;
        default:
            vga_putc(c, screenX, screenY, 0x07, 0x00);
            screenX++;
            if (screenX >= VGA_TTY_WIDTH)
            {
                screenX = 0;
                screenY++;
                break;
            }
            break;
    }
}

void puts(char* str)
{
    while (*str)
    {
        putc(*str);
        str++;
    }
}

void clear()
{
    vga_clear();
    screenX = 0;
    screenY = 0;
}