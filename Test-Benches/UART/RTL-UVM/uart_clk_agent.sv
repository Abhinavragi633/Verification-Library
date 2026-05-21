// Class Declaration for clk agent
class clk_agent extends uvm_agent;
	`uvm_component_utils(clk_agent)   // Factory Registration
	
	uvm_sequencer #(clk_seq_item) clk_seqnr_0;
	clk_drv clk_drv_0;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
		`uvm_info("CLK_AGENT -> new()",$sformat("A new clk_agent is constructed in %s by %s",(parent != null) ? parent.get_name() : "null",name),UVM_HIGH)
	endfunction

	virtual function void build_phase(uvm_phase phase);
		`uvm_info("CLK_AGENT -> build_phase()"," Build_phase has started.", UVM_HIGH)
		super.build_phase(phase);
		
		clk_seqnr_0 = uvm_sequencer#(clk_seq_item)::type_id::create("clk_seqnr_0",this);
		clk_drv_0 = clk_drv::type_id::create("clk_drv_0",this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		`uvm_info("CLK_AGENT -> connect_phase","Connect Phase has Started.",UVM_HIGH)
		super.connect_phase(phase);

		`uvm_info("CLK_AGENT -> connect_phase","Connecting clk driver port to clk Sequencer's export.",UVM_MEDIUM)
		clk_drv_0.seq_item_port.connect(clk_seqnr_0.seq_item_export);
	endfunction
endclass
