class clk_drv extends uvm_driver #(clk_seq_item);
	`uvm_component_utils(clk_drv)

	virtual clk_interface clk_v_itf;
	
	virtual function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual clk_interface)::get(this,"","clk_v_itf",clk_v_itf)) begin
			`uvm_fatal("CLK_DRV(Build Phase)","Could not get virtual clock interface from UVM Config DB.")
		end else begin
			`uvm_info("CLK_DRV(Build Phase)","Got virtual clock interface from UVM Config DB.")
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		clk_seq_item item_frm_seqr;
		real half_period;

		clk_v_itf.clk <= 'z;
		`uvm_info("CLK_DRV(Run Phase)",$sformatf("clk_v_itf.clk is Initialized to %0b", clk_v_itf.clk))

		forever begin
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("Requesting sequence from sequencer........", clk_v_itf.clk))
			seq_item_port.get_next_item(item_frm_seqr);
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("", clk_v_itf.clk))

			if(!item_frm_seqr.clk_en) begin
				clk_v_itf.clk <= 'z;
				seq_item_port.item_done();
				continue;
			end

			half_period = (1000.0/item_frm_seqr)/2.0;
			seq_item_port.item_done();
			
			while (item_frm_seqr.clk_en) begin
				clk_v_itf.clk <= 0;
				#(half_period);
				clk_v_itf.clk <= 1;
				#(half_period);
			end
		end
	endtask
endclass
