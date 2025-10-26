bits 32

; void outb(uint16_t port, uint8_t value);
global outb
outb:
    mov dx, [esp + 4]
    mov al, [esp + 8]
    out dx, al
    ret