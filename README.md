# 6-bit Signed/Unsigned Comparator (Structural Verilog Design)

## 📌 Description
This project implements a **6-bit comparator** in Verilog that supports both **signed (2’s complement)** and **unsigned** number comparison.

The design is fully **structural**, built using basic logic gates, and verified using a behavioral model for correctness.

A synchronous version is also implemented using clocked registers.

---

## ⚙️ Features

- 6-bit inputs: A, B
- Mode selection:
  - S = 0 → Unsigned comparison
  - S = 1 → Signed comparison
- Outputs:
  - GT → A > B
  - EQ → A = B
  - LW → A < B
- Clocked synchronous outputs

---

## 🧱 Modules Overview

### 1️⃣ Unsigned Comparator
- Structural gate-level design
- Bitwise comparison logic
- Produces GT, EQ, LW

---

### 2️⃣ Signed Comparator
- Uses 2’s complement logic
- MSB-based sign detection
- Handles:
  - Positive vs negative cases
  - Same-sign comparison

---

### 3️⃣ Multiplexer (2×1)
- Selects between signed and unsigned outputs
- Controlled by signal S

---

### 4️⃣ Structural Top Module
- Integrates:
  - Signed comparator
  - Unsigned comparator
  - MUX selection
- Adds clocked registers for synchronization

---

### 5️⃣ Behavioral Model
- High-level Verilog implementation
- Acts as golden reference model
- Used for validation

---

### 6️⃣ Testbench
- Exhaustive input testing
- Compares structural vs behavioral outputs
- Automatic FAIL detection
- Stops simulation on mismatch

---

## ⏱️ Clocking
- Positive edge triggered system
- Outputs registered for stability
- Synchronous operation

---

## 🧪 Verification Strategy

- Structural model compared with behavioral model
- Full input space testing
- Automatic error detection:

```verilog
if (GT != sGT || EQ != sEQ || LW != sLW)
    $display("FAIL");


