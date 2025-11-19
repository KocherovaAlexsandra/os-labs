# Makefile for MyOS

# Компилятор и настройки
ASM=nasm
ASM_FLAGS=-f bin

# Исходные файлы
BOOT_SRC=boot.asm
BOOT_IMG=myos.img

# Цели по умолчанию
all: $(BOOT_IMG)

# Сборка загрузочного образа
$(BOOT_IMG): $(BOOT_SRC)
	$(ASM) $(ASM_FLAGS) $(BOOT_SRC) -o $(BOOT_IMG)

# Запуск в QEMU
run: $(BOOT_IMG)
	qemu-system-x86_64 -drive format=raw,file=$(BOOT_IMG)

# Очистка
clean:
	rm -f $(BOOT_IMG) *.o

.PHONY: all run clean