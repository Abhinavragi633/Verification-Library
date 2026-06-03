class uart_scbd extends uvm_scoreboard;
	`uvm_component_utils(uart_scbd)

	`uvm_analysis_imp_decl(_clk);

	uvm_analysis_imp_clk #(clk_seq_item, uart_scbd) clk_ana_imp;

	function new(string name="uart_scbd", uvm_component parent=null);
		`uvm_info("uart_scbd",$sformatf("new() constructor is called for uvm_component %s from uvm_component %s",this.get_name(),parent.get_full_name()),UVM_DEBUG)
    	super.new(name,parent);
		`uvm_info("uart_scbd",$sformatf("new() constructor is completed for uvm_component %s.",this.get_full_name()),UVM_FULL)
  	endfunction

	virtual void function build_phase (uvm_phase phase);
		`uvm_info("uart_scbd",$sformatf("Build Phase for %s has started.",this.get_full_name()),UVM_FULL)

		super.build_phase(phase);
		
		`uvm_info("uart_scbd","Creating new clk_imp_port...........",UVM_MEDIUM)
		clk_imp_port = new("clk_ana_imp", this);

		`uvm_info("uart_scbd",$sformatf("Build Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual function void write_clk(clk_cntrl_seq clk_cntrl);
		`uvm_info("uart_scbd","clk_cntrl_seq_item received from clk_mntr.",UVM_LOW)
		clk_cntrl.print();
		//  DECLARATIONS MUST BE FIRST
    	real expected_freq = 100;

    	//--------------------------------------------------
    	// CHECK
    	//--------------------------------------------------
		if (clk_cntrl.clk_freq inside {[expected_freq-1 : expected_freq+1]}) begin
			`uvm_info("uart_scbd", "Frequency OK", UVM_LOW)
    	end else begin
			`uvm_error("uart_scbd",$sformatf("Mismatch! Expected %0f MHz, got %0.2f",expected_freq, clk_cntrl.clk_freq))
    	end
  	endfunction
endclass
