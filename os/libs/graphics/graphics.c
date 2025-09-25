#include "graphics.h"
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <linux/fb.h>
#include <unistd.h>
#include <string.h>

static graphics_context_t g_ctx;

int graphics_init(void) {
    // Открываем фреймбуфер
    int fbfd = open("/dev/fb0", O_RDWR);
    if (fbfd == -1) {
        perror("Cannot open framebuffer device");
        return -1;
    }

    // Получаем информацию о фреймбуфере
    struct fb_var_screeninfo vinfo;
    struct fb_fix_screeninfo finfo;

    if (ioctl(fbfd, FBIOGET_FSCREENINFO, &finfo)) {
        perror("Error reading fixed information");
        close(fbfd);
        return -1;
    }

    if (ioctl(fbfd, FBIOGET_VSCREENINFO, &vinfo)) {
        perror("Error reading variable information");
        close(fbfd);
        return -1;
    }

    // Сохраняем параметры
    g_ctx.width = vinfo.xres;
    g_ctx.height = vinfo.yres;
    g_ctx.bpp = vinfo.bits_per_pixel;
    g_ctx.pitch = finfo.line_length;
    g_ctx.screen_size = vinfo.yres_virtual * finfo.line_length;

    printf("Framebuffer: %dx%d, %dbpp, pitch: %d\n", 
           g_ctx.width, g_ctx.height, g_ctx.bpp, g_ctx.pitch);

    // Memory-map фреймбуфер
    g_ctx.framebuffer = mmap(0, g_ctx.screen_size, 
                            PROT_READ | PROT_WRITE, MAP_SHARED, fbfd, 0);
    
    if ((long)g_ctx.framebuffer == -1) {
        perror("Failed to map framebuffer device to memory");
        close(fbfd);
        return -1;
    }

    g_ctx.back_framebuffer = malloc(g_ctx.screen_size);
    if (!g_ctx.back_framebuffer) {
        perror("Failed to alloc back framebuffer");
        munmap(g_ctx.framebuffer, g_ctx.screen_size);
        return -1;
    }

    close(fbfd); // Фреймбуфер больше не нужен, т.к. он отображен в память
    return 0;
}

void graphics_cleanup(void) {
    if (g_ctx.framebuffer) {
        munmap(g_ctx.framebuffer, g_ctx.screen_size);
        g_ctx.framebuffer = NULL;
    }

    if (g_ctx.back_framebuffer) {
        //free(g_ctx.back_framebuffer, g_ctx.screen_size);
        g_ctx.back_framebuffer = NULL;
    }
}

void graphics_clear(uint32_t color) {
    if (!g_ctx.back_framebuffer) return;

    uint32_t *fb = (uint32_t*)g_ctx.back_framebuffer;
    size_t total_pixels = g_ctx.width * g_ctx.height;

    
    for (int y = 0; y < g_ctx.height; y++) {
        uint32_t *line = (uint32_t*)(g_ctx.back_framebuffer + y * g_ctx.pitch);
        for (int x = 0; x < g_ctx.width; x++) {
            line[x] = color;
        }
    }
}

void graphics_draw_pixel(int x, int y, uint32_t color) {
    if (!g_ctx.back_framebuffer || x < 0 || x >= g_ctx.width || y < 0 || y >= g_ctx.height) 
        return;
    
    size_t location = (size_t)y * g_ctx.pitch + (size_t)x * (g_ctx.bpp / 8);
    *((uint32_t*)((char*)g_ctx.back_framebuffer + location)) = color;
}

void graphics_draw_rect(int x, int y, int w, int h, uint32_t color) {
    if (!g_ctx.back_framebuffer) return;
    
    // Жесткое обрезание
    int start_x = (x < 0) ? 0 : x;
    int start_y = (y < 0) ? 0 : y;
    int end_x = (x + w > g_ctx.width) ? g_ctx.width : x + w;
    int end_y = (y + h > g_ctx.height) ? g_ctx.height : y + h;
    
    if (start_x >= end_x || start_y >= end_y) return;
    
    // Безопасная отрисовка
    for (int i = start_y; i < end_y; i++) {
        for (int j = start_x; j < end_x; j++) {
            graphics_draw_pixel(j, i, color);
        }
    }
}

void graphics_draw_line(int x1, int y1, int x2, int y2, uint32_t color) {
    // Простая реализация алгоритма Брезенхема
    int dx = abs(x2 - x1);
    int dy = abs(y2 - y1);
    int sx = (x1 < x2) ? 1 : -1;
    int sy = (y1 < y2) ? 1 : -1;
    int err = dx - dy;

    while (1) {
        graphics_draw_pixel(x1, y1, color);
        if (x1 == x2 && y1 == y2) break;
        
        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x1 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y1 += sy;
        }
    }
}

void graphics_swap_buffers(void) {
    if (g_ctx.framebuffer && g_ctx.back_framebuffer) {
        memcpy(g_ctx.framebuffer, g_ctx.back_framebuffer, g_ctx.screen_size);
    }
    else {
        perror("one of framebuffer isn't allocate");
    }
}

int graphics_get_width(void) { return g_ctx.width; }
int graphics_get_height(void) { return g_ctx.height; }