class uart_env extends uvm_env;
	`uvm_component_utils(uart_env)

	clk_agent clk_agent_0;
	uart_scbd uart_scbd_0;

	function new (string name = "uart_env", uvm_component parent = null);
		`uvm_info("uart_env",$sformatf("new() constructor is called for uvm_component %s from uvm_component %s",this.get_name(),parent.get_full_name()),UVM_DEBUG)
		super.new(name,parent);
		`uvm_info("uart_env",$sformatf("new() constructor is completed for uvm_component %s.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual function void build_phase(uvm_phase phase);
		`uvm_info("uart_env",$sformatf("Build Phase for %s has started.",this.get_full_name()),UVM_FULL)

		super.build_phase(phase);
		
		`uvm_info("uart_env","Creating new clk_agent ...........",UVM_MEDIUM)
		clk_agent_0 = clk_agent::type_id::create("clk_agent_0",this);

		`uvm_info("uart_env","Creating new uart_scbd ...........",UVM_MEDIUM)
		uart_scbd_0 = uart_scbd::type_id::create("uart_scbd_0",this);

		`uvm_info("uart_env",$sformatf("Build Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual function void connect_phase (uvm_phase phase);
		`uvm_info("uart_env",$sformatf("Connect Phase for %s has started.",this.get_full_name()),UVM_FULL)

		super.connect_phase(phase);

		`uvm_info("uart_env","Connecting clk_monitor AP to scoreboard IMP",UVM_MEDIUM)
		clk_agent_0.clk_mntr_0.clk_mntr_ap.connect(uart_scbd_0.clk_ana_imp);
		`uvm_info("uart_env",$sformatf("Connect Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction
endclass
