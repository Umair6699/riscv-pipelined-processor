# RISC-V Pipelined Processor (RV32I + M-Extension)

This project implements a **5-stage pipelined RISC-V processor** supporting the **RV32I base instruction set** along with the **M-extension** (multiplication, division, and remainder).
The processor is designed in **SystemVerilog** and verified using **Vivado Design Suite (XSIM)**.

The design includes full **hazard detection**, **data forwarding**, and **multi-cycle execution** for non-pipelined division operations.

---

## Key Features

- 5-stage RISC-V pipeline:
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
- RV32I base ISA support
- M-extension support:
  - MUL
  - DIV (multi-cycle, non-pipelined)
  - REM
- Hazard detection unit for pipeline stalls
- Forwarding unit for data hazard resolution
- Branch comparison and control logic
- Modular and scalable RTL architecture
- Verified using comprehensive SystemVerilog testbenches

---

## Pipeline Overview

The processor follows a classic **5-stage RISC-V pipeline** architecture:

- **IF**: Program counter update and instruction fetch  
- **ID**: Instruction decode, register file access, immediate generation  
- **EX**: ALU operations, branch evaluation, M-extension execution  
- **MEM**: Data memory access for load/store instructions  
- **WB**: Write-back of results to the register file  

Pipeline registers are implemented between each stage to ensure correct data and control flow.

---

## M-Extension Implementation Details

- **MUL** instructions are executed directly in the ALU.
- **DIV** and **REM** instructions are implemented as **multi-cycle operations**.
- Division is **not pipelined**, which introduces controlled pipeline stalls.
- The hazard detection unit manages stalling during multi-cycle execution.
- This design choice favors **simplicity and correctness** over aggressive pipelining.

---

## Hazard Handling

- **Data hazards** are resolved using a forwarding unit.
- **Structural and control hazards** are managed through pipeline stalls.
- Multi-cycle DIV/REM instructions correctly stall the pipeline to preserve correctness.

---

## Verification & Testing

- Individual testbenches verify:
  - ALU functionality
  - Control unit behavior
  - Hazard detection logic
- A top-level testbench (`top_tb.sv`) verifies:
  - Correct execution of RV32I instructions
  - Proper pipeline behavior across all stages
  - Correct handling of M-extension instructions
  - Register file and memory updates

Instruction sequences are loaded using `.mem` files.

---

## Simulation Results

- Simulation performed using **Vivado XSIM**
- Top-level testbench: `top_tb.sv`
- Verified:
  - Correct pipeline flow (IF → WB)
  - Proper forwarding and hazard detection
  - Pipeline stalls during multi-cycle DIV/REM
  - Correct final register values

### Evidence
- Waveform screenshot: `simulation/timing1.jpeg`
- Waveform screenshot: `simulation/timing2.jpeg`

---

## Project Structure

