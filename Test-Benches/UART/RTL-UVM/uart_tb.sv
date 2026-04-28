module tb_top;
  import uvm_pkg::*;   // This Package contains all UVM features and functions.
  
  // bit clk;
  // always #10 clk <= !clk;  ----> this way can't manage clk dynamically during simulation. Sol: use another agent for clock.

  uart_itf itf_0 ();                            // Interface Instantiation
  uart_top dut_0 ( .clk(itf_0.clk),                      // DUT Instanstiation
                  .rst_n(itf_0.rst_n),
                  .irq(itf_0.irq),
                  .addr(itf_0.addr),
                  .write_en(itf_0.write_en),
                  .read_en(itf_0.read.en),
                  .wdata(itf_0.wdata),
                  .rdata(itf_0.rdata),
                  .tx(itf_0.tx),
                  .rx(itf_0.rx) );
  // At start of simulation, set the interface handle as a config object in UVM database. 
  // This IF handle can be retrieved in the test using the get() method run_test () accepts the test name as argument. 
  // In this case, base_test will be run for simulation.
  initial begin
    uvm_config_db #(virtual uart_itf)::set (null, "uvm_test_top", "uart_itf", itf_0);
    run_test("reg_test");
  end

  initial begin
    $dumpvars;
    $dumfile("dump.vcd");           
  end
endmodule
