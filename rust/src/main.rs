#![no_std]
#![no_main]

extern crate panic_halt;

use riscv_rt::entry;

const TTY: usize = 0x80000000;
const KEY: usize = 0xC0000000;

const TTY_WRITE: *mut u8 = (TTY + 0) as _;

const KEY_NEXTC: *mut u8 = (KEY + 0) as _;
const KEY_HAS_C: *const u8 = (KEY + 0) as _;
const KEY_READC: *const u8 = (KEY + 1) as _;

fn print_char(c: u8) {
    unsafe {
        TTY_WRITE.write_volatile(c);
    }
}

fn print_str(s: &str) {
    for c in s.bytes() {
        print_char(c);
    }
}

fn has_char() -> bool {
    unsafe { KEY_HAS_C.read_volatile() != 0 }
}

fn get_char() -> Option<u8> {
    if has_char() {
        let c = unsafe { KEY_READC.read_volatile() };

        unsafe {
            KEY_NEXTC.write_volatile(0);
        }

        Some(c)
    } else {
        None
    }
}

#[entry]
fn main() -> ! {
    print_str("Hello from Rust!\n");

    loop {
        if let Some(c) = get_char() {
            print_char(c);
        }
    }
}
