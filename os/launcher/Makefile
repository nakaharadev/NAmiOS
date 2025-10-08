TARGET = namios-launcher
SRCS = main.c bmp_loader.c
OBJS = $(SRCS:.c=.o)

CC ?= gcc
CFLAGS ?= -O2 -Wall -I.

.PHONY: all clean force

all: $(TARGET)

# Явно указываем что target зависит от объектных файлов
$(TARGET): $(OBJS)
	@echo "Linking $(TARGET)..."
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)

# Явные правила для каждого объектного файла
main.o: main.c
	@echo "Compiling main.c..."
	$(CC) $(CFLAGS) -c -o $@ $<

bmp_loader.o: bmp_loader.c bmp_loader.h
	@echo "Compiling bmp_loader.c..."
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@echo "Cleaning..."
	rm -f $(TARGET) $(OBJS)

# Принудительная пересборка
force: clean all