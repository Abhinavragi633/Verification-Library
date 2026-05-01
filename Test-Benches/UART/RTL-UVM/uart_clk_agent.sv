// Class Declaration for clk agent
class clk_agent extends uvm_agent;
	`uvm_component_utils(clk_agent)
	
	uvm_sequencer #(clk_seq_item) clk_seqnr;
	clk_drv clk_drv0;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		clk_seqnr = uvm_sequencer#(clk_seq_item)::type_id::create("clk_seqnr",this);
		clk_drv0 = clk_drv::type_id::create("clk_drv0",this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		clk_drv0.seq_item_port.connect(clk_seqnr.seq_item_export);
	endfunction
endclass
