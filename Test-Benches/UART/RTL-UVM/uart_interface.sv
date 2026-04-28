interface uart_itf (input logic clk);
  logic rst_n;
  logic irq;
  
  //--------- Registers Interface -----------//
  logic [4:0] addr;
  logic write_en;
  logic read_en;
  logic [7:0] wdata;
  logic [7:0] rdata;

  //----------- UART Pins ------------//
  logic tx;
  logic rx;

  clocking cb @(posedge clk);
    default input #1step output #3ns;
    output addr;
    output write_en;
    output read_en;
    output wdata;
    output rx;
    output rst_n;
    input rdata;
    input tx;
    input irq;
  endclocking
endinterface
