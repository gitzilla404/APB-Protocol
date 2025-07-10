# AMBA APB Protocol in Verilog

## Overview
The Advanced Peripheral Bus (APB) is a part of ARM’s AMBA (Advanced Microcontroller Bus Architecture) specification. AMBA is a set of interconnect protocols widely adopted in System-on-Chip (SoC) design for enabling communication between processors, memories, and peripherals. APB is specifically designed for connecting low-speed peripherals in the system where simplicity and low power consumption are crucial.

Unlike its high-performance siblings AHB (Advanced High-performance Bus) and AXI (Advanced eXtensible Interface), the APB protocol does not support pipelining or burst transfers. Instead, it offers a simple and straightforward interface, making it ideal for connecting peripheral devices such as:

* General Purpose Input/Output (GPIO)

* UART (Universal Asynchronous Receiver Transmitter)

* Timers

* Watchdog modules

* SPI/I2C controllers

## Key features of the APB protocol:

* Simple and low-latency interface.

* Designed for low-bandwidth communication.

* Uses a 3-phase transfer: IDLE → SETUP → ACCESS.

* Does not support pipelining, making it suitable for control-oriented interfaces.

* Works with signals like PADDR, PWDATA, PWRITE, PSEL, PENABLE, PRDATA, PREADY, and PSLVERR.

## Project Description
This repository provides a Verilog implementation of the APB protocol including:

* A 3-state finite state machine (IDLE, SETUP, ACCESS) modeling APB master logic.

* A 32-location memory block acting as a slave device.

* Valid read/write operations based on APB timing requirements.

* Error handling for out-of-bound addresses (PSLVERR).

* A busy signal to track access phase activity.

## Testbench Description
The testbench APB_Test performs:

* Clock generation with a 10ns period.

* Proper reset initialization.

* Defined APB read/write tasks (apb_write, apb_read) to simulate real transactions.

* Write and read from valid addresses (e.g., 0x01, 0x10).

* Read from an invalid address (0x20) to trigger an error (PSLVERR).

* Waveform dump using $dumpfile and $dumpvars for analysis in GTKWave.

## Files Included
* apb.v – Main APB Verilog module (slave-side behavior and FSM logic).

* testbench.v – Testbench to simulate and validate APB functionality.

* apb_test.vcd – Waveform dump file for GTKWave (generated after simulation).

## How to Run
`1` Copy both apb.v and testbench.v into your simulator (e.g., EDA Playground, ModelSim, or Icarus Verilog).

`2` Compile and run the testbench.

`3` Open apb_test.vcd in GTKWave to visualize signal transitions and verify correctness.


