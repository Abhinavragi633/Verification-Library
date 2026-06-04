// TestBench Top declaration for UART Block Verification.
/*		Steps:
			1) Import UVM Package & Macros.
			2) Include UVM Class files.
			3) Instantiate Interface.
			4) Instantiate DUT.
			5) Initial Block
				a. Store interface inside UVM Config DB as virtual interface.
				b. Start UVM Test using run_test().		*/
`include "uart_interface.sv"  // This makes uart_itf visible to tb_top Module. Should be called outside module.

module tb_top;
	import uvm_pkg::*;  // This imports all UVM Defined HDL constructs to your TB.
	`include "uvm_macros.svh" // Required for getting UVM Macro functions.

	// Include Files containing UVM TB Components and Objects Classes. Order is Mandatory.
	`include "clk_agent.sv"
    //`include ".sv"
    `include "uart_scoreboard.sv"
    `include "uart_env.sv"
    `include "clk_sequence.sv"
    `include "uart_test.sv"
	//`include "rst_agent.sv"
	//`include "uart_agent.sv"

	// Instantiation of UART Interface.
	uart_itf uart_itf_0;

	// Instantiation of UART DUT.
	uart_top uart_dut ( .clk(uart_itf_0.clk),
					   .rst_n(uart_itf_0.rst_n),
					   .tx(uart_itf_0.tx),
					   .rx(uart_itf_0.rx),
					   .irq(uart_itf_0.irq),
					   .addr(uart_itf_0.addr),
					   .write_en(uart_itf_0.write_en),
					   .read_en(uart_itf_0.read_en),
					   .wdata(uart_itf_0.wdata),
					   .rdata(uart_itf_0.rdata)		);
	
	// Don't use normal initial block for clock signal generation. Add a seperate clock agent to control frequency and enable of clk dynamically.
	// Don't hard code reset sequence use a reset agent to create different reset sequences according to test.
	initial
		begin
			`uvm_info("tb_top","Starting UART TB execution ...........",UVM_LOW)

			/* Storing the interfacing in UVM Config DB with search scope as uvm_root (global scope) and this value applies to all components.
    			Accessable by key "uart_vitf" and value to be stored is itf_0. This IF handle can be retrieved in the test using the get() method. 
				Interface is static. So, classes can't access interface directly. that is why it is set as virtual.
				A virtual interface is just a pointer/handle to the actual interface. Interface instances exist in module hierarchy.*/
			`uvm_info("tb_top","Storing UART Interface in UVM Config DB ...........",UVM_MEDIUM)
			// set(<scope>,<instances>,<key>,<value_to_be_stored>);
			uvm_config_db #(virtual uart_itf)::set(null,"uvm_test_top.*","uart_vitf",uart_itf_0);	// null set the scope to uvm_root.

			 // Test names can be passed through +UVM_TESTNAME=base_test command line option or can be directly passed as run_test("base_test");
			`uvm_info("tb_top","Starting Test using run_test() .....................",UVM_LOW)
			run_test();
		end
endmodule
