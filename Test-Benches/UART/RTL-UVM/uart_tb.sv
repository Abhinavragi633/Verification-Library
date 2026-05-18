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
                  .read_en(itf_0.read_en),
                  .wdata(itf_0.wdata),
                  .rdata(itf_0.rdata),
                  .tx(itf_0.tx),
                  .rx(itf_0.rx) );
  // At start of simulation, set the interface handle as a config object in UVM database. 
  // This IF handle can be retrieved in the test using the get() method run_test () accepts the test name as argument. 
  // In this case, base_test will be run for simulation.
  initial begin
    // Storing the interfacing in UVM Config DB with search scope as uvm_root (global scope) and this value applies to all components.
    // Accessable by key "uart_vitf" and value to be stored is itf_0
    `uvm_info("tb_top","Storing interface as virtual interface in UVM Config DB.", UVM_HIGH)
    uvm_config_db #(virtual uart_itf)::set (null, "*", "uart_vitf", itf_0);
    run_test("base_test");
  end

  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");           
  end
endmodule
