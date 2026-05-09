# 6-bit Signed/Unsigned Comparator (Structural Verilog Design)

## 📌 Description
This project implements a **6-bit comparator** in Verilog that supports both **signed (2’s complement)** and **unsigned** number comparison.

The design is fully **structural**, built using basic logic gates from a predefined library, and is verified using a behavioral reference model.

A synchronous version is also implemented using clocked registers.

---

## ⚙️ Features

- 6-bit input operands (A, B)
- Mode selection:
  - `S = 0` → Unsigned comparison
  - `S = 1` → Signed comparison
- Outputs:
  - `GT` → A > B
  - `EQ` → A = B
  - `LW` → A < B

---

## 🧱 Modules Description

### 1️⃣ Unsigned Comparator (Structural)
- Built using logic gates (AND, OR, XOR, XNOR, NOT)
- Performs bit-level magnitude comparison
- Generates GT, EQ, LW signals

---

### 2️⃣ Signed Comparator
- Uses MSB (sign bit) interpretation
- Handles:
  - Positive vs Negative cases
  - Same-sign comparison using unsigned logic
- Combines results into final signed output

---

### 3️⃣ Multiplexer (2×1)
- Selects between:
  - Signed result
  - Unsigned result
- Controlled by input `S`

---

### 4️⃣ Structural Top Module
- Integrates:
  - Signed comparator
  - Unsigned comparator
  - MUX selection logic
- Adds **clocked registers** for synchronous output

---

### 5️⃣ Behavioral Model
- Implements the same functionality using high-level Verilog
- Serves as a **golden reference model**
- Used for verification comparison

---

### 6️⃣ Testbench
- Exhaustive input testing
- Compares structural vs behavioral outputs
- Automatically detects mismatches
- Stops simulation on failure

---

## ⏱️ Clocking
- Synchronous design using `posedge CLK`
- Outputs are registered
- Ensures stable and timed outputs

---

## 🧪 Verification Strategy

- Structural model is compared against behavioral model
- All input combinations are tested
- Automatic check:

```verilog
if (GT != sGT || EQ != sEQ || LW != sLW)
    $display("FAIL");

    Simulation stops on mismatch

    📊 Key Concepts Used
Structural Verilog design
Behavioral modeling
Signed vs unsigned arithmetic (2’s complement)
Digital comparator design
Multiplexer design
Clocked sequential circuits
Functional verification
Exhaustive testbench simulation

📁 Project Structure
comparator-project/
│
├── unsignedm.v
├── signedm.v
├── structural.v
├── behavioral.v
├── mux.v
├── testbench.v
└── README.md

🚀 How to Run

Using Icarus Verilog:

iverilog -o sim testbench.v
vvp sim

Optional waveform viewing:

gtkwave dump.vcd
🎯 Learning Outcomes
Designing hardware using structural Verilog
Understanding signed vs unsigned binary representation
Building combinational and sequential systems
Verification using behavioral models
Debugging hardware logic designs
Working with clocked systems
