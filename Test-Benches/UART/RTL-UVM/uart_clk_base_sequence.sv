// Class Declaration for Base Clock Control Sequence for Clk Agent
class base_clk_seq extends uvm_sequence #(clk_seq_item);
	`uvm_object_utils(base_clk_seq);

	task body();
		clk_seq_item clk_seq0;
		
		clk_seq0 = clk_seq_item::type_id::create("clk_seq0");
		clk_cfg0.clk_freq = 100;	//  Clock Frequency Set to 100 MHz.
		clk_cfg0.clk_en = 0;
		start_item(clk_seq0);
		finish_item(clk_seq0);
		
	endtask
endclass
