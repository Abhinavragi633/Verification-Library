class rst_agent extends uvm_agent;
	`uvm_component_utils(rst_agent)
	
	uvm_sequencer #(rst_seq_item) rst_seqnr;
	rst_drv rst_drv0;

	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_seqnr = uvm_sequencer#(rst_seq_item)::type_id::create("rst_seqnr",this);
		rst_drv0 = rst_drv::type_id::create("rst_drv0",this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect(phase);

		rst_drv0.seq_item_port.connect(rst_seqnr.seq_item_export);
	endfunction
endclass
