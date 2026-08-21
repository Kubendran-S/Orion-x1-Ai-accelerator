#  Orion-X1 AI Accelerator

A SystemVerilog RTL implementation of a hardware accelerator architecture targeting AI/ML matrix-computation workloads, with a focus on **parallel computation, systolic-array dataflow, mixed-precision processing, RTL verification, and FPGA implementation**.

> **Project Focus:** RTL Design + Functional Verification + FPGA Synthesis

---

## 📌 Project Overview

AI and neural-network workloads require a large number of matrix multiplication and Multiply-Accumulate (MAC) operations.

Orion-X1 explores a hardware-oriented solution using a **parallel systolic-array architecture**, where multiple Processing Elements (PEs) operate concurrently and exchange data through structured dataflow.

The project was developed from **SystemVerilog RTL through functional simulation, synthesis, implementation, and timing analysis using Xilinx Vivado**.

---

## 🎯 Problem Statement

General-purpose processors are not always optimized for highly parallel AI matrix operations.

The objective of this project is to explore a dedicated RTL accelerator architecture that can:

* Perform parallel matrix computations
* Reduce repeated computation through dedicated hardware
* Support structured systolic dataflow
* Explore mixed-precision computation
* Provide programmable control through an AXI4-Lite interface
* Be verified at RTL level
* Be synthesized and analyzed on FPGA hardware

---

## 🏗️ Architecture

The major RTL blocks include:

```text
                    ┌───────────────────────┐
                    │      AXI4-Lite        │
                    │   Control Interface   │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │    Array Controller   │
                    │       / Control FSM   │
                    └───────────┬───────────┘
                                │
             ┌──────────────────▼──────────────────┐
             │          Systolic Array             │
             │                                     │
             │   PE ─ PE ─ PE ─ PE ─ ...          │
             │   │    │    │    │                  │
             │   PE ─ PE ─ PE ─ PE ─ ...          │
             │   │    │    │    │                  │
             │   PE ─ PE ─ PE ─ PE ─ ...          │
             │                                     │
             └──────────────────┬──────────────────┘
                                │
                    ┌───────────▼───────────┐
                    │   Output / Accumulation│
                    │        Logic           │
                    └────────────────────────┘
```

---

## 🔧 RTL Design

The design is implemented using **SystemVerilog**.

### Major Components

* Systolic Array
* Mixed-Precision Processing Element
* Array Controller
* Control FSM
* Dataflow Logic
* Memory/Buffer Logic
* AXI4-Lite Interface
* Top-Level Integration

The RTL is organized into modular components to make the architecture easier to verify, debug, and extend.

---

## 🧮 Compute Architecture

The accelerator uses a systolic-style architecture for parallel matrix computation.

Instead of repeatedly using a single computational unit:

```text
Input → MAC → MAC → MAC → Output
```

multiple Processing Elements operate concurrently:

```text
          PE → PE → PE → PE
          ↓    ↓    ↓    ↓
          PE → PE → PE → PE
          ↓    ↓    ↓    ↓
          PE → PE → PE → PE
```

This structure is suitable for workloads containing large numbers of repeated MAC operations.

---

## 🧪 Verification

The RTL was functionally verified using a **SystemVerilog testbench** and **Vivado/XSim behavioral simulation**.

### Verification activities

* Reset verification
* Clock/control verification
* AXI-Lite interface behavior
* Data-path verification
* Control FSM verification
* Systolic-array operation
* Output behavior checking
* Waveform-based debugging

The verification environment was used to identify RTL-level issues before synthesis and implementation.

---

## ⚙️ FPGA Implementation

### Target Device

**Xilinx Artix-7 XC7A200T**

### Tool

**Xilinx Vivado**

Flow:

```text
SystemVerilog RTL
       ↓
Behavioral Simulation
       ↓
RTL Verification
       ↓
Synthesis
       ↓
Implementation
       ↓
Timing Analysis
       ↓
Resource / Power Analysis
```

---

## 📊 Implementation Results

The current implementation produced the following reported results:

| Metric               |    Result |
| -------------------- | --------: |
| LUT Utilization      |       ~2% |
| FF Utilization       |       ~1% |
| I/O Utilization      |      ~18% |
| BUFG Utilization     |       ~3% |
| Total Reported Power |   0.175 W |
| WNS                  | +2.238 ns |
| WHS                  | +0.114 ns |

Positive WNS/WHS values indicate that the reported timing checks met the analyzed constraints.

> Results are implementation-specific and depend on the selected FPGA device, constraints, Vivado version, synthesis settings, and RTL configuration.

---

## 📷 Project Evidence

### RTL Implementation
<img width="1626" height="972" alt="code" src="https://github.com/user-attachments/assets/585d134c-3e36-4e80-b666-77512891c59a" />



### Generated Schematic
<img width="1631" height="978" alt="synthesis schematic" src="https://github.com/user-attachments/assets/90ecea68-5832-4824-8fdc-49ce95621b78" />
<img width="1913" height="1075" alt="inmplement schematic" src="https://github.com/user-attachments/assets/0fda918d-a95b-43b5-9f59-f027e99c5eb7" />


### Functional Simulation

<img width="1625" height="970" alt="wave from" src="https://github.com/user-attachments/assets/98a7004b-b206-4c5d-924b-dd1f87ab9c3d" />


### Vivado Implementation Results

<img width="1628" height="977" alt="Report" src="https://github.com/user-attachments/assets/81de0cab-363c-400d-a990-c01e1b6f761e" />


---

## 🛠️ Technologies

* SystemVerilog
* RTL Design
* Digital Design
* Functional Verification
* FPGA Design
* Xilinx Vivado
* XSim
* AXI4-Lite
* Systolic Arrays
* Mixed-Precision Computing
* Hardware Architecture
* Timing Analysis

---

## 📚 Key Learning Outcomes

This project provided practical experience with:

1. Translating an accelerator architecture into synthesizable RTL
2. Designing modular SystemVerilog components
3. Building and debugging a systolic dataflow
4. Creating RTL-level verification environments
5. Debugging functional behavior using waveforms
6. Understanding synthesis results
7. Analyzing FPGA resource utilization
8. Interpreting timing reports
9. Understanding the relationship between RTL architecture and hardware implementation

---

## 🚀 Future Improvements

Potential extensions include:

* UVM-based verification
* Functional coverage enhancement
* Assertion-based verification using SVA
* AXI4-Lite verification improvements
* PPA optimization
* Improved memory architecture
* Sparse computation support
* Larger systolic-array configurations
* ASIC-oriented synthesis
* Open-source physical-design exploration

---

## 👨‍💻 Project Focus

This project demonstrates hands-on experience in:

**RTL Design | SystemVerilog | Design Verification | FPGA | Vivado | Digital Design | AI Hardware**

---

## ⚠️ Disclaimer

Orion-X1 is an educational/research-oriented hardware architecture project.

The architecture is an original implementation developed for learning and experimentation. Any architectural concepts inspired by publicly available AI-accelerator research are used for educational purposes and should not be interpreted as an implementation of proprietary commercial hardware.

---

## ⭐ Feedback

If you work in **VLSI, RTL Design, FPGA, ASIC, or Design Verification**, feedback on the architecture, verification methodology, timing optimization, and PPA improvement is welcome.
