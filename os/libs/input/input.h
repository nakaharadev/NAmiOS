#ifndef INPUT_H
#define INPUT_H

typedef enum {
    TOUCH_DOWN = 1,
    TOUCH_UP = 2,
    TOUCH_MOVE = 3
} touch_event_type_t;

typedef struct {
    int x, y;
    int pressure;
    touch_event_type_t type;
} touch_event_t;

typedef struct {
    int min_x, min_y;
    int max_x, max_y;
} input_touch_event_range_t;

int input_init(void);
void input_cleanup(void);

int input_poll_event(touch_event_t *event);

input_touch_event_range_t input_get_range(void);


#endif // INPUT_H