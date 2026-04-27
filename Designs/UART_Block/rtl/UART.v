module uart_top (
    input         clk,
    input         rst_n,

    input  [4:0]  addr,
    input         write_en,
    input         read_en,
    input  [7:0]  wdata,
    output reg [7:0] rdata,

    input         rx,
    output        tx,

    output        irq
);

    reg [7:0] control;
    reg [7:0] baud;
    reg [7:0] int_status;
    reg [7:0] int_enable;

    reg [7:0] tx_fifo [0:3];
    reg [7:0] rx_fifo [0:3];

    reg [1:0] tx_wr_ptr, tx_rd_ptr;
    reg [1:0] rx_wr_ptr, rx_rd_ptr;

    reg [2:0] tx_count;
    reg [2:0] rx_count;

    reg [7:0] baud_cnt;
    reg       baud_tick;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            baud_cnt  <= 0;
            baud_tick <= 0;
        end else begin
            if (baud_cnt == baud) begin
                baud_cnt  <= 0;
                baud_tick <= 1;
            end else begin
                baud_cnt  <= baud_cnt + 1;
                baud_tick <= 0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control    <= 0;
            baud       <= 8'd16;
            int_enable <= 0;
        end else if (write_en) begin
            case (addr)
                5'h08: control <= wdata;
                5'h0C: baud    <= wdata;
                5'h14: int_enable <= wdata;
                5'h10: int_status <= int_status & ~wdata;
                5'h00: begin
                    if (tx_count < 4) begin
                        tx_fifo[tx_wr_ptr] <= wdata;
                        tx_wr_ptr <= tx_wr_ptr + 1;
                        tx_count  <= tx_count + 1;
                    end
                end
            endcase
        end
    end

    reg [4:0] addr_d;
    always @(posedge clk) addr_d <= addr;

    always @(posedge clk) begin
        if (read_en) begin
            case (addr_d)
                5'h00: begin
                    if (rx_count > 0) begin
                        rdata <= rx_fifo[rx_rd_ptr];
                        rx_rd_ptr <= rx_rd_ptr + 1;
                        rx_count  <= rx_count - 1;
                    end
                end
                5'h04: rdata <= {4'b0,
                                 (rx_count==4),
                                 (rx_count==0),
                                 (tx_count==4),
                                 (tx_count==0)};
                5'h08: rdata <= control;
                5'h0C: rdata <= baud;
                5'h10: rdata <= int_status;
                5'h14: rdata <= int_enable;
                default: rdata <= 0;
            endcase
        end
    end

    reg [3:0] tx_state;
    reg [7:0] tx_shift;
    reg [2:0] tx_bit_cnt;
    reg       tx_reg;
    reg       parity_bit;

    assign tx = tx_reg;

    localparam TX_IDLE=0, TX_START=1, TX_DATA=2, TX_PAR=3, TX_STOP=4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_state <= TX_IDLE;
            tx_reg   <= 1;
        end else if (baud_tick && control[0]) begin
            case (tx_state)
                TX_IDLE: if (tx_count > 0) begin
                    tx_shift <= tx_fifo[tx_rd_ptr];
                    tx_rd_ptr <= tx_rd_ptr + 1;
                    tx_count  <= tx_count - 1;
                    parity_bit <= ^tx_fifo[tx_rd_ptr];
                    tx_state <= TX_START;
                end
                TX_START: begin tx_reg <= 0; tx_bit_cnt <= 0; tx_state <= TX_DATA; end
                TX_DATA: begin
                    tx_reg <= tx_shift[tx_bit_cnt];
                    tx_bit_cnt <= tx_bit_cnt + 1;
                    if (tx_bit_cnt == 7)
                        tx_state <= control[2] ? TX_PAR : TX_STOP;
                end
                TX_PAR: begin
                    tx_reg <= control[3] ? ~parity_bit : parity_bit;
                    tx_state <= TX_STOP;
                end
                TX_STOP: begin
                    tx_reg <= 1;
                    tx_state <= TX_IDLE;
                end
            endcase
        end
    end

    reg [3:0] rx_state;
    reg [7:0] rx_shift;
    reg [2:0] rx_bit_cnt;

    localparam RX_IDLE=0, RX_START=1, RX_DATA=2, RX_PAR=3, RX_STOP=4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_state <= RX_IDLE;
            rx_count <= 0;
        end else if (baud_tick && control[1]) begin
            case (rx_state)
                RX_IDLE: if (rx == 0) rx_state <= RX_START;
                RX_START: begin rx_bit_cnt <= 0; rx_state <= RX_DATA; end
                RX_DATA: begin
                    rx_shift[rx_bit_cnt] <= rx;
                    rx_bit_cnt <= rx_bit_cnt + 1;
                    if (rx_bit_cnt == 7)
                        rx_state <= control[2] ? RX_PAR : RX_STOP;
                end
                RX_PAR: rx_state <= RX_STOP;
                RX_STOP: begin
                    if (rx_count < 4) begin
                        rx_fifo[rx_wr_ptr] <= rx_shift;
                        rx_wr_ptr <= rx_wr_ptr + 1;
                        rx_count  <= rx_count + 1;
                    end
                    rx_state <= RX_IDLE;
                end
            endcase
        end
    end

    reg tx_empty_d, rx_full_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            int_status <= 0;
            tx_empty_d <= 1;
            rx_full_d  <= 0;
        end else begin
            tx_empty_d <= (tx_count == 0);
            rx_full_d  <= (rx_count == 4);

            if (!tx_empty_d && (tx_count == 0))
                int_status[0] <= 1;

            if (!rx_full_d && (rx_count == 4))
                int_status[1] <= 1;
        end
    end

    assign irq = |(int_status & int_enable);

endmodule
