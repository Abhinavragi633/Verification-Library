// Class Declaration for clk agent
class clk_agnt extends uvm_agent;
	`uvm_component_utils(clk_agnt)

	// Config and Interface Declaration
	virtual clk_interface clk_v_itf;
	clk_cfg_obj clk_cfg;
	
	// NEW Construct
	virtual function new(string name = "clk_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	virtual function build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Get clk config obj from uvm config db
		if (!uvm_config_db #(clk_cfg_obj)::get(this,"","clk_cfg_obj",clk_cfg)) begin
			`uvm_fatal("CLK_AGENT-build_phase", "Cannot get clk_cfg_obj from UVM Config DB.")
		end else begin
			`uvm_info("CLK_AGENT-build_phase", "Got clk_cfg_obj from UVM Config DB Successfully.")
		end
	endfunction

	// Run Phase
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);

		// Period Calculation from Frequency
		real half_period;
		half_period = (1000.0/clk_cfg.clk_freq) / 2.0; // in ns

		// Clock generation
		forever begin
			if(clk_cfg.clk_en) begin
				#(half_period) clk_v_itf.clk <= ~clk_v_itf.clk;
			end else begin
				clk_v_itf.clk <= 1'bz;
				@(posedge clk_cfg.clk_en)
				clk_v_itf.clk <= 0;
			end
		end
	endtask
endclass
