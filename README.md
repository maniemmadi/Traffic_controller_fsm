# 6-State Fixed-Timer Traffic Light Controller (T-Intersection)

## Project Overview
This repository contains a synthesizable Verilog implementation of a standard T-intersection traffic light system using a synchronized Finite State Machine (FSM). The module manages transitions between a **Main Road** and a **Side Road** using fixed behavioral time intervals.

Unlike pure combinational circuits, this design demonstrates control over sequential logic, internal registers, and timing parameters in digital systems.

## Technical Specifications
* **HDL:** Verilog-2001
* **Architecture:** Moore Finite State Machine (Output depends solely on current state)
* **Status Outputs:** 3-bit vectors for Main Road and Side Road (Red = `3'b100`, Yellow = `3'b010`, Green = `3'b001`).
* **Timer Resolution:** 4-bit cycle counters.

---

## FSM Parameters & Time Durations
The controller moves sequentially through 6 distinct states (S0 to S5) using a modular behavioral function to define loop delays:

| State | Main Road | Side Road | Nominal Count | Total Clock Cycles |
| :---: | :--- | :--- | :---: | :---: |
| **S0** | Green | Red | 5 | 6 |
| **S1** | Yellow | Red | 2 | 3 |
| **S2** | Red | Green | 3 | 4 |
| **S3** | Red | Yellow | 2 | 3 |
| **S4** | Red | Red | 1 | 2 |
| **S5** | Green | Red | 1 | 2 |

*Note: Since the transition condition evaluates as `count >= state_duration`, the system stays in each state for exactly `duration + 1` clock cycles.*

---

## Design Architecture

### 1. State Transition Logic (Sequential)
Uses a single 4-bit behavioral register (`count`) to track elapsed cycles. It compares the current count against the `state_duration` function. When the threshold is met, the FSM transitions to the `next_state` and flushes the counter.

### 2. Next State Logic (Combinational)
Defines the hard-coded loop of transitions: $S0 \rightarrow S1 \rightarrow S2 \rightarrow S3 \rightarrow S4 \rightarrow S5 \rightarrow S0$.

### 3. Output Assignment Logic (Combinational)
Decodes the 3-bit active-high signal for LEDs based strictly on the `state` register.

---

## Design and Verification
* **Tools:** Xilinx Vivado 2023.2
* **Target Hardware:** 28nm Kintex-7 FPGA (XC7K70T)

### Verification Strategy
Functional verification was performed using a stimulus testbench driving a continuous clock. The simulation confirms exact edge transitions and state-synchronous output toggle.

#### Timing Waveforms
Waveforms demonstrate transitions with stable outputs and sequential flag updates.
![Traffic Waveform](./docs/traffic_waveform.png)

---

## Repository Organization
```text
├── rtl/        # Synthesizable Verilog modules (.v)
│   └── traffic_light_controller.v
├── tb/         # Testbench and stimulus files
│   └── tb_traffic_light.v
├── docs/       # FSM diagrams and simulation waveforms
└── LICENSE     # MIT License
