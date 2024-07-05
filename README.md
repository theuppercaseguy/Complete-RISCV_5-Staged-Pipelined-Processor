# 5-Staged Pipelined Processor

![Processor Diagram](processor_diagram.png)

## Overview

This project implements a 5-staged pipelined processor capable of executing instructions for a RISC-V 32-bit architecture. The processor design adheres to the basic principles of pipelining, enhancing throughput and performance by overlapping instruction execution stages.

## Features

- **5-Staged Pipeline:** Fetch, Decode, Execute, Memory, Writeback stages.
- **Supports RISC-V I-type Instructions:** Including arithmetic, logical, load, store, and branch instructions.
- **Data and Control Hazards Handling:** Forwarding and stalling mechanisms implemented.
- **Instruction and Data Memory:** Separate instruction and data memory units.
- **Instruction Tracing:** Verified with an IP tracer to validate instruction execution flow.

## Components

### 1. Fetch Stage
Responsible for fetching instructions from memory.

### 2. Decode Stage
Decodes fetched instructions and reads required registers.

### 3. Execute Stage
Executes arithmetic, logical, and branch instructions.

### 4. Memory Stage
Handles load/store operations and accesses data memory.

### 5. Writeback Stage
Writes results back to registers.

### Installation

1. Clone the repository: `git clone https://github.com/theuppercaseguy/Complete-RISCV_5-Staged-Pipelined-Processor.git`
2. add all source and simulation files to Vivado.
3. set TOP_TB as your Top simulation module.
4. Run simulations.
5. Use Venus to write assembly code and dump it all into the instruction memory file in rtl/Inst_mem.sv.

## Contributing

We'd like to make contributions to improve the processor. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

Please ensure your code adheres to our coding standards.

## Contact

For questions or feedback, don't hesitate to get in touch with Saad Khan at saadan060@gmail.com

