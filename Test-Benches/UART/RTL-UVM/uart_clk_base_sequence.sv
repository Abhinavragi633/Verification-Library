// Class Declaration for Base Clock Control Sequence for Clk Agent
class clk_base_seq extends uvm_sequence #(clk_seq_item);
	// UVM Factory Registration for Automation.
	`uvm_object_utils(clk_base_seq);

	function new (string name = "clk_base_seq");
		super.new(name);
		`uvm_info("CLK_BASE_SEQ -> new()",$sformatf("Constructed a new clk_base_seq with name %s",name),UVM_HIGH)
	endfunction

	task body();
		// Transaction 1: Clock is Off.
		clk_seq_item clk_seq;
		// Constructing a new clock sequence item
		`uvm_info("CLK_BASE_SEQ -> body()","Creating new clk_seq_item", UVM_HIGH)
		clk_seq = clk_seq_item::type_id::create("clk_seq_0");
		
		// TLM Transaction
		`uvm_info("CLK_BASE_SEQ -> body()","Starting the TLM transaction item .........",UVM_HIGH)
		start_item(clk_seq);    //  Tells the driver to get ready for the sequence item.

		`uvm_info("CLK_BASE_SEQ -> body()","Setting clk_freq & clk_en seq objects ........", UVM_HIGH)
		clk_seq.clk_freq = 0;	//  Clock Frequency Set to 0 MHz.
		clk_seq.clk_en = 0;       //  Clock is Disabled.

		finish_item(clk_seq);   //  Sends the sequence item to driver.
		`uvm_info("CLK_BASE_SEQ -> body()","Finished the TLM transaction item .........",UVM_MEDIUM)

		`uvm_info("CLK_BASE_SEQ -> body()","Sequence Item sent to Driver is ........", UVM_LOW)
		clk_seq.print();  // Prints the sequence item using UVM Factory Automation.

		#100

		//Transaction 2: Clock is ON @ 100MHz.
		// Constructing a new clock sequence item
		`uvm_info("CLK_BASE_SEQ -> body()","Creating new clk_seq_item", UVM_HIGH)
		clk_seq = clk_seq_item::type_id::create("clk_seq_1");
		
		// TLM Transaction
		`uvm_info("CLK_BASE_SEQ -> body()","Starting the TLM transaction item .........",UVM_HIGH)
		start_item(clk_seq);    //  Tells the driver to get ready for the sequence item.

		
		`uvm_info("CLK_BASE_SEQ -> body()","Setting clk_freq & clk_en seq objects ........", UVM_HIGH)
		clk_seq.clk_freq = 100;	//  Clock Frequency Set to 100 MHz.
		clk_seq.clk_en = 1;       //  Clock is Enabled.

		finish_item(clk_seq);   //  Sends the sequence item to driver.
		`uvm_info("CLK_BASE_SEQ -> body()","Finished the TLM transaction item .........",UVM_MEDIUM)

		`uvm_info("CLK_BASE_SEQ -> body()","Sequence Item sent to Driver is ........", UVM_LOW)
		clk_seq.print();  // Prints the sequence item using UVM Factory Automation.
	endtask
endclass
