CC = aarch64-linux-gnu-gcc
CFLAGS = -I../libs/graphics -Wall -Wextra -std=c99
LDFLAGS = -static
TARGET = namios-compositor

SRCS = main.c
OBJS = $(SRCS:.c=.o)

# Путь к графической библиотеке
GRAPHICS_LIB = ../libs/graphics/libgraphics.a
INPUT_LIB = ../libs/input/libinput.a

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS) $(GRAPHICS_LIB) $(INPUT_LIB)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(GRAPHICS_LIB) $(INPUT_LIB)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)

install: $(TARGET)
	install -d $(DESTDIR)/usr/bin
	install -m 755 $(TARGET) $(DESTDIR)/usr/bin/