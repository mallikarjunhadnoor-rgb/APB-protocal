# AMBA APB Protocol Verification using UVM

A complete Universal Verification Methodology (UVM) testbench environment designed to verify the AMBA APB (Advanced Peripheral Bus) protocol, ensuring reliable master-slave handshaking and data transfer accuracy.

## 🚀 Verification Architecture
* **Interface (`apb_if.sv`)**: Encapsulates APB signals (`P_addr`, `P_selx`, `P_enable`, `P_write`, `P_wdata`, `P_ready`, `P_rdata`) with clocking blocks for race-free driving.
* **Transaction & Sequence (`apb_transaction.sv`, `apb_seqs.sv`)**: Defines randomized transaction properties and stimulus sequences.
* **Agent & Driver/Monitor (`apb_agent.sv`, `apb_drv.sv`, `apb_mon.sv`)**: Manages pin-level protocol driving and monitors activity on the bus.
* **Scoreboard (`apb_sb.sv`)**: Compares actual results against expected outcomes for self-checking validation.

## 📂 Project Structure
```text
├── apb_if.sv          # APB Interface with clocking blocks
├── apb_transaction.sv # UVM Transaction item
├── apb_seqs.sv        # APB Sequences
├── apb_drv.sv         # UVM Driver
├── apb_mon.sv         # UVM Monitor
├── apb_agent.sv       # UVM Agent container
├── apb_sb.sv          # UVM Scoreboard
├── apb_env.sv         # UVM Environment
├── apb_test.sv        # UVM Test
├── testbench.sv       # Top module instantiating DUT and interface
└── README.md          # Project documentation

🛠️ Simulation & Protocol Focus
Validates APB state transitions (IDLE, SETUP, and ACCESS phases).

Ensures proper handling of the PREADY wait-state handshake signal.
