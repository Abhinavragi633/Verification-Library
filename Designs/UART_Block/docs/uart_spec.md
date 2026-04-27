# UART Specification (Verification-Oriented)

## 1. Overview
This document defines a memory-mapped UART with:
- Full-duplex TX/RX
- Programmable baud rate
- FIFO buffering (depth = 4)
- Interrupt support
- Configurable parity

---

## 2. Interface

### Clock & Reset
- clk   : System clock
- rst_n : Active-low reset

Reset behavior:
- Registers cleared
- FIFOs cleared
- TX = 1 (idle)

---

### Register Interface

| Signal     | Description |
|------------|------------|
| addr[4:0]  | Address |
| write_en   | Write enable |
| read_en    | Read enable |
| wdata[7:0] | Write data |
| rdata[7:0] | Read data |

Rules:
- Read latency = 1 cycle
- Read & write mutually exclusive

---

### UART Signals

| Signal | Description |
|--------|------------|
| tx     | Serial output |
| rx     | Serial input |

---

### Interrupt
- irq = OR(INT_STATUS & INT_ENABLE)

---

## 3. Frame Format

| Field | Bits |
|------|------|
| Start | 1 (0) |
| Data  | 8 (LSB first) |
| Parity | Optional |
| Stop | 1 (1) |

---

## 4. Baud Rate

baud_rate = clk / baud_divisor

- BAUD register defines divisor
- Minimum = 1

---

## 5. FIFO

Depth = 4 entries

### TX FIFO
- Write via DATA register
- Read by TX engine

### RX FIFO
- Written by RX engine
- Read via DATA register

### Behavior

| Condition | Behavior |
|----------|---------|
| TX full  | Ignore writes |
| RX full  | Drop data |
| RX empty read | No change |

---

## 6. Register Map

| Addr | Name |
|------|------|
| 0x00 | DATA |
| 0x04 | STATUS |
| 0x08 | CONTROL |
| 0x0C | BAUD |
| 0x10 | INT_STATUS |
| 0x14 | INT_ENABLE |

---

### DATA (0x00)
- Write: push TX FIFO
- Read: pop RX FIFO

---

### STATUS (0x04)

| Bit | Name |
|-----|------|
| 0 | TX_EMPTY |
| 1 | TX_FULL |
| 2 | RX_EMPTY |
| 3 | RX_FULL |

---

### CONTROL (0x08)

| Bit | Name |
|-----|------|
| 0 | TX_EN |
| 1 | RX_EN |
| 2 | PARITY_EN |
| 3 | PARITY_ODD |

---

### BAUD (0x0C)
- Baud divisor

---

### INT_STATUS (0x10)
RW1C

| Bit | Name |
|-----|------|
| 0 | TX_EMPTY_INT |
| 1 | RX_FULL_INT |

---

### INT_ENABLE (0x14)

| Bit | Name |
|-----|------|
| 0 | TX_EMPTY_EN |
| 1 | RX_FULL_EN |

---

## 7. Interrupt Behavior

- TX_EMPTY_INT: Trigger when FIFO becomes empty
- RX_FULL_INT: Trigger when FIFO becomes full
- Cleared by writing 1

---

## 8. TX Operation

Sequence:
1. Start bit
2. 8 data bits
3. Optional parity
4. Stop bit

Each bit = baud_divisor cycles

---

## 9. RX Operation

- Detect start bit
- Sample mid-bit
- Shift 8 bits
- Optional parity
- Push to FIFO

---

## 10. Reset Values

| Register | Value |
|---------|------|
| CONTROL | 0x00 |
| BAUD    | 0x10 |
| INT_ENABLE | 0x00 |
| INT_STATUS | 0x00 |

---

## 11. Corner Cases

- TX write when full → ignored
- RX read when empty → no change
- Disable TX mid-frame → completes frame
- Disable RX mid-frame → drop frame

---

## 12. Verification Targets

- FIFO overflow/underflow
- Interrupt correctness
- Parity modes
- Back-to-back frames
- Reset during transfer
