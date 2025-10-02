TARGET = namios-compositor
SRCS = main.c
OBJS = $(SRCS:.c=.o)

CC ?= aarch64-linux-gnu-gcc
CFLAGS += -I.

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJS)