TARGET = libcompositor.a
SRCS = compositor.c
OBJS = $(SRCS:.c=.o)

CC ?= gcc
AR ?= ar
CFLAGS += -I.

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) rcs $@ $(OBJS) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJS)