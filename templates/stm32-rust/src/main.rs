#![no_std]
#![no_main]

use defmt_rtt as _;
use panic_probe as _;

#[cortex_m_rt::entry]
fn main() -> ! {
    defmt::info!("hello");
    loop {
        cortex_m::asm::wfi();
    }
}
