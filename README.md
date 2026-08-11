# ARM Pipelined Processor — Computer Architecture Lab

A Verilog implementation and simulation of a **5-stage pipelined ARM processor**.

The processor implements the main stages of a classic pipeline:

* Instruction Fetch (IF)
* Instruction Decode (ID)
* Execute (EXE)
* Memory Access (MEM)
* Write-Back (WB)

The project also includes **Hazard Detection** and **Data Forwarding** mechanisms to maintain correct execution and improve pipeline performance.

## Processor Architecture

The processor follows a 5-stage pipelined architecture:

Each stage communicates with the next stage through pipeline registers.

## 1. Instruction Fetch — IF

The IF stage is responsible for maintaining the **Program Counter (PC)**, fetching instructions from instruction memory, calculating the next instruction address, and handling branch redirection.

Main components:

* Program Counter Register
* Address Incrementer
* Branch Selection Logic
* Instruction Memory
* IF/ID Pipeline Register

The instruction memory contains **2048 locations**, with each location storing a **32-bit instruction**. The PC advances by one instruction location:

```text
PC_next = PC + 1
```

#### Branch instructions can redirect the PC to a target address, while the IF/ID register can be flushed to remove incorrectly fetched instructions.


## 2. Instruction Decode — ID

The ID stage decodes the fetched instruction and generates the data and control signals required by the Execute stage.

Main components:

* Control Unit
* Register File
* Immediate / Sign Extend Unit
* Destination Register Selection
* Condition Field Extraction
* ID/EXE Pipeline Register

Important ARM instruction fields include:

```text
Cond      = instruction[31:28]
Opcode    = instruction[24:21]
Rn        = instruction[19:16]
Rd        = instruction[15:12]
Rm        = instruction[3:0]
```

#### The stage also extracts source registers and provides the required information to the Hazard Detection Unit.

## 3. Execute — EXE

The EXE stage is the computational core of the processor.

It contains:

* Operand Generation Unit (`Val2Generate`)
* Arithmetic Logic Unit (ALU)
* Branch Address Generator
* Status Register
* Forwarding logic

The ALU supports the following operations:

| EXE_CMD | Operation              |
| ------- | ---------------------- |
| MOV     | Move                   |
| ADD     | Addition               |
| ADC     | Addition with Carry    |
| SUB     | Subtraction            |
| SBC     | Subtraction with Carry |
| AND     | Logical AND            |
| ORR     | Logical OR             |
| EOR     | Logical XOR            |
| MVN     | Logical NOT            |

The ALU generates the ARM condition flags:

```text
N — Negative
Z — Zero
C — Carry
V — Overflow
```

The Status Register stores these flags and updates them when the `S` control signal is asserted.
The Execute stage also supports ARM immediate rotation and register-based shift operations including:

* LSL
* LSR
* ASR
* ROR

## 4. Memory — MEM

The MEM stage handles data-memory operations.

### Load

For an instruction such as:

```asm
LDR R1, [R2, #4]
```

the EXE stage calculates:

```text
Address = R2 + 4
```

and the MEM stage reads the corresponding memory location.

### Store

For:

```asm
STR R1, [R2, #4]
```

the calculated address is used to store the value of `R1`.

The Data Memory is implemented as:

```verilog
reg [31:0] mem [0:2047];
```

Therefore, it contains **2048 × 32-bit words**.

The MEM/WB pipeline register transfers memory data, ALU results, destination registers, and write-back control signals to the WB stage.

## 5. Write-Back — WB

The WB stage is the final stage of the pipeline.

It selects the value that should be written into the Register File.

The selection is controlled by `MEM_R_EN`:

* `MEM_R_EN = 1` → Memory data is written back
* `MEM_R_EN = 0` → ALU result is written back

The WB stage also propagates:

* Destination register
* Register write-enable
* Selected result value


# Hazard Detection Unit

Pipeline execution introduces data dependencies between instructions.

For example:

```asm
ADD R1, R2, R3
SUB R4, R1, R5
```

The second instruction depends on the result produced by the first instruction.

The Hazard Detection Unit compares source registers in the ID stage with destination registers in later stages.

A hazard can be detected using conditions such as:

```text
Src1 == EXE_Dest
Src2 == EXE_Dest
Src1 == MEM_Dest
Src2 == MEM_Dest
```

while considering whether the later instruction actually writes to the Register File.
When a hazard requires a stall:

```text
PC_Write   = 0
IF_ID_Write = 0
Hazard     = 1
```

A bubble can also be inserted into the pipeline to prevent incorrect execution.

# Forwarding Unit

To reduce unnecessary stalls, the processor implements a **Forwarding Unit**.

Instead of waiting for a value to be written back to the Register File, the result can be directly forwarded from later pipeline stages to the EXE stage.

The forwarding selection is:

| Selection | Source        |
| --------- | ------------- |
| `2'b00`   | Register File |
| `2'b01`   | MEM Stage     |
| `2'b10`   | WB Stage      |

MEM forwarding has higher priority than WB forwarding because it contains the more recent result.

Forwarding can be enabled or disabled using:

```text
forward_en
```

When forwarding is enabled, arithmetic and logical RAW hazards can be resolved without unnecessary stalls. However, **Load-Use hazards still require stalling** because the loaded data is not immediately available.

# Simulation & Verification

The complete processor was simulated using a testbench.

The verification checks include:

* Register File values
* Data Memory values
* ARM condition flags
* Pipeline behavior
* Hazard detection
* Forwarding behavior

# Performance Comparison

The processor was simulated with forwarding both **disabled** and **enabled**.

| Forwarding | Total Runtime |
| ---------- | ------------: |
| OFF        |       5640 ns |
| ON         |       3900 ns |

With forwarding enabled, the total simulation runtime decreased from **5640 ns to 3900 ns**, demonstrating the performance benefit of bypassing data directly between pipeline stages.

### Speedup

The measured speedup is approximately:

```text
Speedup = 5640 / 3900 ≈ 1.45×
```

Thus, enabling forwarding resulted in approximately a **45% higher simulation throughput relative to the measured runtime**.

# Technologies

* **Verilog HDL**
* ARM instruction-set concepts
* 5-stage pipelined processor architecture
* Hazard Detection
* Data Forwarding
* Digital Logic Design
* Simulation & Waveform Analysis

# Main Features

* 5-stage ARM pipeline
* Instruction Fetch
* Instruction Decode
* Execute / ALU
* Memory Access
* Write-Back
* ARM condition flags (`N`, `Z`, `C`, `V`)
* Branch handling
* Data Hazard Detection
* Pipeline Stall / Bubble insertion
* MEM → EXE forwarding
* WB → EXE forwarding
* Configurable forwarding enable
* Instruction and data memory
* Complete processor simulation
* Performance comparison with and without forwarding

# Project Report

The complete technical report contains detailed descriptions of each pipeline stage, hazard detection, forwarding implementation, and simulation results.

**Authors:**  Parsa Darban & Rouja Aghajani
