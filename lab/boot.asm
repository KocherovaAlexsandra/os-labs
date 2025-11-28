org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; set text mode 80x25 (clear screen)
    mov ax, 0x0003
    int 0x10

    ; print logo lines
    mov si, logo1
    call print_string
    mov si, logo2
    call print_string
    mov si, logo3
    call print_string

main_loop:
    mov si, menu
    call print_string

    ; wait for key (no echo)
    mov ah, 0
    int 0x16        ; AL = char

    cmp al, '1'
    je do_1
    cmp al, '2'
    je do_2
    cmp al, '3'
    je do_3
    cmp al, 'q'
    je do_quit
    cmp al, 'Q'
    je do_quit

    jmp main_loop

do_1:
    mov si, msg_1
    call print_string
    call wait_key
    jmp main_loop

do_2:
    mov si, msg_2
    call print_string
    call wait_key
    jmp main_loop

do_3:
    mov si, msg_3
    call print_string
    call wait_key
    jmp main_loop

do_quit:
    int 0x19        ; reboot

; -------------------------
; print nul-terminated string at SI
; LF (10) -> CR+LF
; -------------------------
print_string:
    lodsb
    or al, al
    jz .ret
    cmp al, 10
    jne .char
    mov ah, 0x0E
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    jmp print_string
.char:
    mov ah, 0x0E
    int 0x10
    jmp print_string
.ret:
    ret

wait_key:
    mov ah, 0
    int 0x16
    ret

; -------------------------
; data (ASCII only)
; -------------------------
logo1 db " __   __        __   ___          __   __  ",10,0
logo2 db "|__) /  \ |    / _` |__  |\ |    /  \ /__`",10,0
logo3 db "|__) \__/ |___ \__> |___ | \|    \__/ .__/",10,10,0

menu db "Menu:",10
     db "1) Show message 1",10
     db "2) Show message 2",10
     db "3) Show message 3",10
     db "q) Reboot",10,0

msg_1 db "You pressed 1",10,0
msg_2 db "You pressed 2",10,0
msg_3 db "You pressed 3",10,0

buffer times 32 db 0

times 510-($-$$) db 0
dw 0xAA55
