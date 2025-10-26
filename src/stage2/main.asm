bits 16

section .entry

global entry
extern cstart

entry:
    cli

    xor dh, dh
    mov [boot_drive], dl

    call enableA20
    call loadGDT

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp dword 08h:.pmode

.pmode:
    [bits 32]
    mov ax, 0x10
    mov ds, ax
    mov ss, ax

    xor edx, edx
    mov dl, [boot_drive]
    push edx
    call cstart

halt:
    hlt
.loop
    jmp .loop


enableA20:
    [bits 16]
    call a20wait_input
    mov al, kbd_disable
    out kbd_cmd, al

    call a20wait_input
    mov al, kbd_read_ctrl
    out kbd_cmd, al

    call a20wait_output
    in al, kbd_data
    push eax

    call a20wait_input
    pop eax
    or al, 2
    out kbd_data, al

    call a20wait_input
    mov al, kbd_enable
    out kbd_cmd, al

    call a20wait_input

    ret

a20wait_input:
    [bits 16]
    in al, kbd_cmd
    test al, 2
    jnz a20wait_input
    ret

a20wait_output:
    [bits 16]
    in al, kbd_cmd
    test al, 1
    jz a20wait_output
    ret

loadGDT:
    [bits 16]
    lgdt [GDTDesc]
    ret

section .data

boot_drive: db 0

GDT:        ; NULL descriptor
            dq 0

            ; 32-bit code segment
            dw 0FFFFh                   ; limit (bits 0-15) = 0xFFFFF for full 32-bit range
            dw 0                        ; base (bits 0-15) = 0x0
            db 0                        ; base (bits 16-23)
            db 10011010b                ; access (present, ring 0, code segment, executable, direction 0, readable)
            db 11001111b                ; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
            db 0                        ; base high

            ; 32-bit data segment
            dw 0FFFFh                   ; limit (bits 0-15) = 0xFFFFF for full 32-bit range
            dw 0                        ; base (bits 0-15) = 0x0
            db 0                        ; base (bits 16-23)
            db 10010010b                ; access (present, ring 0, data segment, executable, direction 0, writable)
            db 11001111b                ; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
            db 0                        ; base high

            ; 16-bit code segment
            dw 0FFFFh                   ; limit (bits 0-15) = 0xFFFFF
            dw 0                        ; base (bits 0-15) = 0x0
            db 0                        ; base (bits 16-23)
            db 10011010b                ; access (present, ring 0, code segment, executable, direction 0, readable)
            db 00001111b                ; granularity (1b pages, 16-bit pmode) + limit (bits 16-19)
            db 0                        ; base high

            ; 16-bit data segment
            dw 0FFFFh                   ; limit (bits 0-15) = 0xFFFFF
            dw 0                        ; base (bits 0-15) = 0x0
            db 0                        ; base (bits 16-23)
            db 10010010b                ; access (present, ring 0, data segment, executable, direction 0, writable)
            db 00001111b                ; granularity (1b pages, 16-bit pmode) + limit (bits 16-19)
            db 0                        ; base high

GDTDesc:  dw GDTDesc - GDT - 1
          dd GDT

kbd_cmd equ 0x64
kbd_data equ 0x60
kbd_disable equ 0xAD
kbd_enable equ 0xAE
kbd_read_ctrl equ 0xD0
kbd_write_ctrl equ 0xD1