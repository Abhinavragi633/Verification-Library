module tb_top;
  import uvm_pkg::*;   // This Package contains all UVM features and functions.
  
  // bit clk;
  // always #10 clk <= !clk;  ----> this way can't manage clk dynamically during simulation. Sol: use another agent for clock.

  uart_itf itf_0 ();                            // Interface Instantiation
  uart_top DUT ( .clk(itf_0.clk),                      // DUT Instanstiation
                  .rst_n(itf_0.rst_n),
                  .irq(itf_0.irq),
                  .addr(itf_0.addr),
                  .write_en(itf_0.write_en),
                  .read_en(itf_0.read_en),
                  .wdata(itf_0.wdata),
                  .rdata(itf_0.rdata),
                  .tx(itf_0.tx),
                  .rx(itf_0.rx) );
  
  
  initial begin
    // Storing the interfacing in UVM Config DB with search scope as uvm_root (global scope) and this value applies to all components.
    // Accessable by key "uart_vitf" and value to be stored is itf_0.
    // This IF handle can be retrieved in the test using the get() method. 
    // Interface is static. So, classes can't access interface directly. that is why it is set as virtual.
    // A virtual interface is just a pointer/handle to the actual interface. Interface instances exist in module hierarchy.
    `uvm_info("tb_top","Storing interface as virtual interface in UVM Config DB.", UVM_HIGH)
    uvm_config_db #(virtual uart_itf)::set (null, "uvm_test_top", "uart_vitf", itf_0);

    // Test names can be passed through +UVM_TESTNAME=base_test command line option or can be directly passed as run_test("base_test");
    // run_test() is pre-defined in uvm_root. Takes testname as the test class. this is the entry point for the simulation.
    `uvm_info("tb_top","Starting the test ........... ", UVM_HIGH)
    run_test();
  end

  initial begin
    // Code for Waveform Dump.
    $dumpvars;
    $dumpfile("dump.vcd");           
  end
endmodule
