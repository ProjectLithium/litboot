#include "vga.h"
#include "io.h"

volatile uint16_t* buffer = (uint16_t*)(0xB8000);

void vga_putc(char c, uint8_t x, uint8_t y, uint8_t fg, uint8_t bg)
{
    uint16_t attr = (bg << 4) | (fg & 0x0F);
    buffer[y * VGA_TTY_WIDTH + x] = c | (attr << 8);
}

void vga_clear()
{
    for (int y = 0; y < VGA_TTY_HEIGHT; y++)
    {
        for (int x = 0; x < VGA_TTY_WIDTH; x++)
        {
            buffer[y * VGA_TTY_WIDTH + x] = (0x07 << 8);
        }
    }
}

void vga_disable_cursor()
{
    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);
}