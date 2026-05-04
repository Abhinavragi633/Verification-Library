class uart_agnt extends uvm_agent;
	`uvm_component_utils(uart_agnt);
	uvm_sequencer #(uart_seq) uart_seqnr0;
	uart_drv uart_drv0;
	uart_mntr uart_mntr0;

	function new( string name, uvm_component parent);
		super.new();
	endfunction

	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		uart_seqnr0 = uvm_sequencer#(uart_seq)::type_id::create("uart_seqnr0",this);
		uart_drv0 = uart_drv::type_id::create("uart_drv0",this);
		uart_mntr0 = uart_mntr::type_id::create("uart_mntr0",this);
	endfunction

	virtual function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		uart_drv0.seq_item_port.connect(uart_seqnr0.seq_item_export);
	endfunction
endclass
