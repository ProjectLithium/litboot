bits 16
org 0x7C00

main:
    ; segments setup
    mov ax, 0
    mov ds, ax
    mov es, ax
    
    ; stack setup
    mov ss, ax
    mov sp, 0x7C00 ; put the stack before bootloader, we don't wanna overwrite ourself

    mov [drive_num], dl

    mov ah, 0x41
    mov bx, 0x55AA
    mov dl, 0x80
    int 0x13
    jnc .extension_present
    cmp bx, 0xAA55
    je .extension_present

    mov si, msg_extension_not_supported
    call puts

.extension_present:
    ; search for stage 2 partition
    ; check boot flag
    mov al, [mbr_table]   ; boot flag at offset 0
    cmp al, 0x80
    jne .not_found

    ; check sectors count at offset 12 (4 bytes)
    mov ax, [mbr_table + 12]
    mov dx, [mbr_table + 14]
    cmp dx, 0
    jne .not_found
    cmp ax, 128
    jne .not_found

    ; load starting LBA (4 bytes) at offset 8
    mov ax, [mbr_table + 8]      ; low word (first 2 bytes) of starting LBA
    mov [dap_lba_low], ax

    mov word [dap_sectors_count], 128

    mov word [dap_offset], 0x7E00

    mov word [dap_lba_mid_low], 0
    mov word [dap_lba_mid_high], 0
    mov word [dap_lba_high], 0

    call read_disk

    push 0x7E00
    ret

.not_found:
    mov si, msg_partition_not_found
    call puts

    jmp halt

halt:
    cli
    hlt

.loop
    jmp .loop

; ds:si - pointer to string
puts:
    push ax
    push bx
    push si

.loop:
    lodsb ; load byte from ds:si to al and increment si
    or al, al
    jz .done

    mov bh, 0
    mov ah, 0x0E
    int 0x10

    jmp .loop

.done:
    pop si
    pop bx
    pop ax
    ret

read_disk:
    push ax
    push dx
    push si

    mov si, dap_size
    mov ah, 0x42
    mov dl, [drive_num]
    int 0x13
    jc .disk_error

    pop si
    pop dx
    pop ax
    ret

.disk_error:
    mov si, msg_disk_error
    call puts
    jmp halt

msg_extension_not_supported: db "Extension not supported!", 0
msg_disk_error: db "Disk read error!", 0
msg_partition_not_found: db "Boot partition not found!", 0

; DAP
dap_size: db 0x10
dap_reserved: db 0
dap_sectors_count: dw 0
dap_offset: dw 0
dap_segment: dw 0
dap_lba_low: dw 0
dap_lba_mid_low: dw 0
dap_lba_mid_high: dw 0
dap_lba_high: dw 0

drive_num: db 0

times 446-($-$$) db 0

mbr_table: