#pragma once
#include <stdint.h>

#define VGA_TTY_WIDTH 80
#define VGA_TTY_HEIGHT 25

void vga_putc(char c, uint8_t x, uint8_t y, uint8_t fg, uint8_t bg);
void vga_clear();
void vga_disable_cursor();