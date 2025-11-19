[org 0x7c00]              ; Указываем, что код загружается по адресу 0x7c00

; Настройка сегментов
mov ax, 0x0000
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

; Очистка экрана
mov ax, 0x0003
int 0x10

; Установка видеорежима 80x25
mov ah, 0x00
mov al, 0x03
int 0x10

; Вывод названия ОС
mov si, os_name
call print_string

; Вывод логотипа в ASCII
mov si, logo
call print_string

; Вывод меню
mov si, menu
call print_string

; Ожидание ввода пользователя
wait_for_input:
    mov ah, 0x00        ; Функция чтения клавиши
    int 0x16            ; Прерывание клавиатуры
    
    ; Проверка нажатой клавиши
    cmp al, '1'
    je calculator
    cmp al, '2'
    je name_input
    cmp al, '3'
    je game
    cmp al, 'q'
    je reboot
    jmp wait_for_input

; Калькулятор
calculator:
    call clear_screen
    mov si, calc_prompt1
    call print_string
    
    ; Чтение первого числа
    call read_number
    mov [num1], ax
    
    mov si, calc_prompt2
    call print_string
    
    ; Чтение оператора
    mov ah, 0x00
    int 0x16
    mov [operator], al
    mov ah, 0x0e
    int 0x10
    call new_line
    
    mov si, calc_prompt3
    call print_string
    
    ; Чтение второго числа
    call read_number
    mov [num2], ax
    
    ; Выполнение операции
    mov ax, [num1]
    mov bx, [num2]
    
    mov cl, [operator]
    cmp cl, '+'
    je addition
    cmp cl, '-'
    je subtraction
    cmp cl, '*'
    je multiplication
    
addition:
    add ax, bx
    jmp show_result
    
subtraction:
    sub ax, bx
    jmp show_result
    
multiplication:
    mul bx
    jmp show_result

show_result:
    mov si, result_msg
    call print_string
    
    ; Вывод результата
    mov bx, 10
    mov cx, 0
    
convert_loop:
    mov dx, 0
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_loop
    
print_loop:
    pop ax
    add al, '0'
    mov ah, 0x0e
    int 0x10
    loop print_loop
    
    call new_line
    mov si, press_any_key
    call print_string
    mov ah, 0x00
    int 0x16
    jmp main_screen

; Ввод имени
name_input:
    call clear_screen
    mov si, name_prompt
    call print_string
    
    mov di, name_buffer
    mov cx, 0
    
read_name:
    mov ah, 0x00
    int 0x16
    
    cmp al, 0x0d        ; Enter
    je name_done
    cmp al, 0x08        ; Backspace
    je backspace
    cmp cx, 19          ; Максимальная длина имени
    jge read_name
    
    mov [di], al
    inc di
    inc cx
    
    ; Вывод символа
    mov ah, 0x0e
    int 0x10
    jmp read_name

backspace:
    cmp cx, 0
    je read_name
    dec di
    dec cx
    mov byte [di], 0
    
    ; Удаление символа с экрана
    mov ah, 0x0e
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp read_name

name_done:
    call new_line
    mov si, hello_msg
    call print_string
    mov si, name_buffer
    call print_string
    mov si, exclamation
    call print_string
    call new_line
    
    mov si, press_any_key
    call print_string
    mov ah, 0x00
    int 0x16
    jmp main_screen

; Простая игра - угадай число
game:
    call clear_screen
    mov si, game_welcome
    call print_string
    
    ; Генерация случайного числа (1-10)
    mov ah, 0x00        ; Функция чтения таймера
    int 0x1a            ; Прерывание системного таймера
    mov ax, dx
    xor dx, dx
    mov cx, 10
    div cx
    inc dx              ; Число от 1 до 10
    mov [secret_number], dl
    
game_loop:
    mov si, game_prompt
    call print_string
    
    call read_number
    cmp al, [secret_number]
    je game_win
    jl game_lower
    jg game_higher

game_lower:
    mov si, too_low
    call print_string
    jmp game_loop

game_higher:
    mov si, too_high
    call print_string
    jmp game_loop

game_win:
    mov si, correct
    call print_string
    mov si, press_any_key
    call print_string
    mov ah, 0x00
    int 0x16
    jmp main_screen

; Перезагрузка
reboot:
    mov si, reboot_msg
    call print_string
    mov ax, 0
    int 0x19

; Возврат на главный экран
main_screen:
    call clear_screen
    mov si, os_name
    call print_string
    mov si, logo
    call print_string
    mov si, menu
    call print_string
    jmp wait_for_input

; Функция очистки экрана
clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

; Функция вывода строки
print_string:
    mov ah, 0x0e        ; Функция телетайпа
.print_char:
    lodsb               ; Загрузка символа из SI в AL
    cmp al, 0           ; Конец строки?
    je .done
    int 0x10            ; Вывод символа
    jmp .print_char
.done:
    ret

; Функция перевода строки
new_line:
    mov ah, 0x0e
    mov al, 0x0d        ; Возврат каретки
    int 0x10
    mov al, 0x0a        ; Перевод строки
    int 0x10
    ret

; Функция чтения числа
read_number:
    push bx
    push cx
    push dx
    
    mov bx, 0           ; Накопленное число
    mov cx, 0           ; Счетчик цифр
    
.read_digit:
    mov ah, 0x00
    int 0x16
    
    cmp al, 0x0d        ; Enter
    je .done
    cmp al, '0'
    jb .read_digit
    cmp al, '9'
    ja .read_digit
    
    ; Вывод цифры
    mov ah, 0x0e
    int 0x10
    
    ; Преобразование в число
    sub al, '0'
    mov cl, al
    mov ax, bx
    mov bx, 10
    mul bx
    mov bx, ax
    add bl, cl
    adc bh, 0
    
    jmp .read_digit
    
.done:
    mov ax, bx
    pop dx
    pop cx
    pop bx
    ret

; Данные
os_name db 'MyOS v1.0 - Simple Operating System', 0x0d, 0x0a, 0

logo db '  __  __     ____   _____ ', 0x0d, 0x0a,\
       ' |  \/  |   / __ \ / ____|', 0x0d, 0x0a,\
       ' | \  / |  | |  | | (___  ', 0x0d, 0x0a,\
       ' | |\/| |  | |  | |\___ \ ', 0x0d, 0x0a,\
       ' | |  | |  | |__| |____) |', 0x0d, 0x0a,\
       ' |_|  |_|   \____/|_____/ ', 0x0d, 0x0a, 0x0d, 0x0a, 0

menu db 'Menu:', 0x0d, 0x0a,\
     '1 - Calculator', 0x0d, 0x0a,\
     '2 - Enter Name', 0x0d, 0x0a,\
     '3 - Number Guessing Game', 0x0d, 0x0a,\
     'q - Reboot', 0x0d, 0x0a,\
     'Choose option: ', 0

calc_prompt1 db 'Enter first number: ', 0
calc_prompt2 db 'Enter operator (+, -, *): ', 0
calc_prompt3 db 'Enter second number: ', 0
result_msg db 'Result: ', 0

name_prompt db 'Enter your name: ', 0
hello_msg db 'Hello, ', 0
exclamation db '!', 0x0d, 0x0a, 0

game_welcome db 'Guess the number (1-10)!', 0x0d, 0x0a, 0
game_prompt db 'Your guess: ', 0
too_low db 'Too low! Try again.', 0x0d, 0x0a, 0
too_high db 'Too high! Try again.', 0x0d, 0x0a, 0
correct db 'Correct! You win!', 0x0d, 0x0a, 0

press_any_key db 'Press any key to continue...', 0x0d, 0x0a, 0
reboot_msg db 'Rebooting...', 0x0d, 0x0a, 0

; Переменные
num1 dw 0
num2 dw 0
operator db 0
name_buffer times 20 db 0
secret_number db 0

; Заполнение до 512 байт и сигнатура загрузочного сектора
times 510-($-$$) db 0
dw 0xaa55