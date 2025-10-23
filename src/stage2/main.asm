bits 16
org 0x7E00

main:
    mov si, msg_hello
    call puts

halt:
    cli
    hlt

.loop
    jmp .loop

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

msg_hello: db "Hello from stage 2!", 0x0A, 0x0D, 0