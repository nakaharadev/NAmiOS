#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include "../namios-graphics-lib-1.0/graphics.h"
#include "../namios-input-lib-1.0/input.h"

static int running = 1;
static int touch_active = 0;
static int last_x = -1, last_y = -1;

void signal_handler(int sig) {
    running = 0;
}

void normalize_touch_input(input_touch_event_range_t input_range, int w, int h, int *x, int *y) {
    int scaled_x = (*x - input_range.min_x) * w / (input_range.max_x - input_range.min_x);
    int scaled_y = (*y - input_range.min_y) * h / (input_range.max_y - input_range.min_y);

    if (scaled_x < 0) scaled_x = 0;
    if (scaled_x >= w) scaled_x = w - 1;
    if (scaled_y < 0) scaled_y = 0;
    if (scaled_y >= h) scaled_y = h - 1;

    *x = scaled_x;
    *y = scaled_y;
}

int init_compositor(void) {
    printf("=== Init OS Compositor ===");

    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);

    if (graphics_init() < 0) {
        printf("Failed to init graphics\n");
        return -1;
    }

    if (input_init() < 0) {
        printf("Input init failed (continuing without input)\n");
    }

    printf("System initialized: %dx%d\n", 
        graphics_get_width(), graphics_get_height());

    touch_event_t touch;
    int last_x = -1, last_y = -1;

    while (running) {
        graphics_clear(0xFF333333);

        int screen_width = graphics_get_width();
        int screen_height = graphics_get_height();

        while (input_poll_event(&touch)) {
            if (touch.type == TOUCH_DOWN) {
                int normalized_x = touch.x;
                int normalized_y = touch.y;
                normalize_touch_input(
                    input_get_range(),
                    screen_width, screen_height,
                    &normalized_x, &normalized_y
                );
                
                printf("Touch DOWN at: %d, %d -> %d, %d\n", 
                       touch.x, touch.y, normalized_x, normalized_y);
                
                last_x = normalized_x;
                last_y = normalized_y;
                touch_active = 1;
                
            } else if (touch.type == TOUCH_UP) {
                printf("Touch UP at: %d, %d\n", touch.x, touch.y);
                
                touch_active = 0;
            }
        }

        if (touch_active && last_x != -1 && last_y != -1) {
            int square_x = last_x - 25;
            int square_y = last_y - 25;
            int square_size = 50;
            
            if (square_x < 0) square_x = 0;
            if (square_y < 0) square_y = 0;
            if (square_x + square_size > screen_width) 
                square_x = screen_width - square_size;
            if (square_y + square_size > screen_height) 
                square_y = screen_height - square_size;
            
            printf("Drawing active square at: %d, %d\n", last_x, last_y);
            graphics_draw_rect(square_x, square_y, square_size, square_size, 0xFFFF0000);
        } else if (!touch_active) {
            last_x = -1;
            last_y = -1;
        }

        graphics_swap_buffers();
    }

    input_cleanup();
    graphics_cleanup();
    printf("Compositor shutdown complete\n");
    
    return 0;
}