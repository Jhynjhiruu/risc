#include <stdint.h>
#include <stdbool.h>

#define TTY (0x80000000)

#define KEY (0xC0000000)

#define TTY_WRITE (*(volatile char *)(TTY + 0))

#define KEY_NEXTC (*(volatile uint8_t *)(KEY + 0))
#define KEY_HAS_C (*(volatile uint8_t *)(KEY + 0))
#define KEY_READC (*(volatile char *)(KEY + 1))

void print_char(char c) {
    TTY_WRITE = c;
}

void print_string(char const * str) {
    char c;
    while (({c = *str++;}) != 0) {
        print_char(c);
    }
}

int main(void) {
    print_string("Hello from C!\n");
}
