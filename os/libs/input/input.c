#include "input.h"
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>

static int input_fd = -1;
static int last_x = 0, last_y = 0;
static int touch_down = 0;

input_touch_event_range_t event_input_range = {0};

int input_init(void) {
    input_fd = open("/dev/input/event0", O_RDONLY | O_NONBLOCK);
    if (input_fd == -1) {
        input_fd = open("/dev/input/event1", O_RDONLY | O_NONBLOCK);
    }

    if (input_fd == -1) {
        perror("Cannot open input device");
        return -1;
    }

    struct input_absinfo abs_info;
    if (ioctl(input_fd, EVIOCGABS(ABS_X), &abs_info) >= 0) {
        event_input_range.min_x = abs_info.minimum;
        event_input_range.max_x = abs_info.maximum;
        printf("X range: %d to %d\n", event_input_range.min_x, event_input_range.max_x);
    } else {
        perror("Failed to get X range");
        // Устанавливаем дефолтные значения на случай ошибки
        event_input_range.min_x = 0;
        event_input_range.max_x = 8192;
    }

    if (ioctl(input_fd, EVIOCGABS(ABS_Y), &abs_info) >= 0) {
        event_input_range.min_y = abs_info.minimum;
        event_input_range.max_y = abs_info.maximum;
        printf("Y range: %d to %d\n", event_input_range.min_y, event_input_range.max_y);
    } else {
        perror("Failed to get Y range");
        event_input_range.min_y = 0;
        event_input_range.max_y = 8192;
    }

    printf("Input device opened successfully\n");

    return 0;
}

void input_cleanup(void) {
    if (input_fd != -1) {
        close(input_fd);
        input_fd = -1;
    }
}

int input_poll_event(touch_event_t *event) {
    if (input_fd == -1) return 0;

    struct input_event ev;
    int bytes_read;

    while ((bytes_read = read(input_fd, &ev, sizeof(ev))) == sizeof(ev)) {
        if (ev.type == EV_ABS) {
            if (ev.code == ABS_X) {
                last_x = ev.value;
            }
            if (ev.code == ABS_Y) {
                last_y = ev.value;
            }
        } else if (ev.type == EV_KEY) {
            if (ev.value) {
                // Touch DOWN
                event->x = last_x;
                event->y = last_y;
                event->type = TOUCH_DOWN;
                touch_down = 1;
                return 1;
            } else {
                // Touch UP
                event->x = last_x;
                event->y = last_y;
                event->type = TOUCH_UP;
                touch_down = 0;
                return 1;
            }
        }
    }
    return 0;
}

input_touch_event_range_t input_get_range(void) { return event_input_range; }