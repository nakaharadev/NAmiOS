#ifndef GRAPHICS_H
#define GRAPHICS_H

#include <stdint.h>
#include <stddef.h>

typedef struct {
    int width, height;
    int bpp;
    int pitch;
    void *framebuffer;
    void *back_framebuffer;
    size_t screen_size;
} graphics_context_t;

// Инициализация графики
int graphics_init(void);
void graphics_cleanup(void);

// Базовые функции рисования
void graphics_clear(uint32_t color);
void graphics_draw_pixel(int x, int y, uint32_t color);
void graphics_draw_rect(int x, int y, int w, int h, uint32_t color);
void graphics_draw_line(int x1, int y1, int x2, int y2, uint32_t color);

// Управление дисплеем
void graphics_swap_buffers(void);
int graphics_get_width(void);
int graphics_get_height(void);

#endif