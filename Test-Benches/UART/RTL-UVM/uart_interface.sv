interface uart_interface ();

  //--------- Registers Interface -----------//
  logic [4:0] addr;
  logic write_en;
  logic read_en;
  logic [7:0] wdata;
  logic [7:0] rdata;

  //----------- UART Pins ------------//
  logic tx;
  logic rx;

  // Mod port Declarations............
  modport DUT ( input addr,
               input write_en,
               input read_en,
               input wdata,
               input rx,
               output rdata,
               output tx );
  modport tb_top ( output addr,
                  output write_en,
                  output read_en,
                  output wdata,
                  output rx,
                  input rdata,
                  input tx );
endinterface
