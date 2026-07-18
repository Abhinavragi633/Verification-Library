# TESTS STATUS

## TOTAL : 0 ; PASS : 0 ; FAIL : 0 ; NEED TO CHECK : 0

## TEST Category 1: Inputs & Outputs Tests

### io_check
Check all inputs and output signals and their widths are matched with spec.

## TEST Category 2: Clock & Reset Tests
### clk_rst

## TEST Category 3: Register Tests

                    +----------------+
                    |   base_test    |
                    +-------+--------+
                            |
                     +------+------+
                     |   uart_env   |
                     +------+------+
                            |
      ---------------------------------------------------
      |           |            |             |           |
      |           |            |             |           |
 clk_agent    rst_agent   bus_agent    uart_line_agent scoreboard
                              |               |
                           Driver         Driver/Monitor
                              |               |
                       Register IF        tx/rx pins
                              \             /
                               \           /
                                ---- DUT ----

uart_rst_test
    ├── Reset sequence
    ├── Register defaults
    ├── UART output defaults
    └── Interrupt defaults

uart_reg_test
    ├── Register R/W
    ├── RO registers
    ├── RW1C registers
    └── Illegal accesses

uart_tx_test
    ├── TX enable
    ├── Frame generation
    ├── Parity
    └── Stop bit

uart_rx_test
    ├── RX reception
    ├── FIFO updates
    └── Status bits

uart_irq_test
    ├── TX empty interrupt
    ├── RX full interrupt
    ├── Interrupt enable
    └── Interrupt clear

uart_random_test
    ├── Constrained random traffic
    ├── Random resets
    └── Long regression
