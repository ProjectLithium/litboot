#include <stdint.h>
#include "stdio.h"
#include "vga.h"

void cstart(uint8_t boot_drive)
{
    vga_disable_cursor();
    clear();
    puts("Hello, World!");
}