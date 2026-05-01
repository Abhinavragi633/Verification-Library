// Class Declaration for Base Clock Control Sequence for Clk Agent
class base_clk_seq extends uvm_sequence;
	`uvm_object_utils(base_clk_seq);
	clk_cfg_obj clk_cfg0;

	task body();
		
		if(!uvm_config_db #(clk_cfg_obj)::get(null,"*","clk_cfg_obj",clk_cfg0)) begin
			`uvm_fatal("CLK_SEQ-body"," Unable to get clk_cfg_obj from UVM Config DB.")
		end else begin
			`uvm_info("CLK_SEQ-body","Got clk_cfg_obj from UVM Config DB Successfully.")
		end

		clk_cfg0.clk_freq = 100;	//  Clock Frequency Set to 100 MHz.
		clk_cfg0.clk_en = 1;
	endtask
endclass
