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

  clocking cb @(posedge
endinterface
