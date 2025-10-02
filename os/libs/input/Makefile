TARGET = libinput.a
SRCS = input.c
OBJS = $(SRCS:.c=.o)

CC ?= aarch64-linux-gnu-gcc
AR ?= ar
CFLAGS += -I.

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJS)