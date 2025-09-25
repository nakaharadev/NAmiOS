CC = aarch64-linux-gnu-gcc
CFLAGS = -I. -Wall -Wextra -std=c99 -fPIC
AR = aarch64-linux-gnu-ar
TARGET = libgraphics.a

SRCS = graphics.c
OBJS = $(SRCS:.c=.o)

.PHONY: all clean install

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) rcs $@ $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)

install: $(TARGET)
	install -d $(DESTDIR)/usr/lib
	install -d $(DESTDIR)/usr/include
	install -m 644 $(TARGET) $(DESTDIR)/usr/lib/
	install -m 644 graphics.h $(DESTDIR)/usr/include/