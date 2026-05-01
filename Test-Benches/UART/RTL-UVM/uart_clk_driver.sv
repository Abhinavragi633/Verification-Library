class clk_drv extends uvm_driver #(clk_seq_item);
	`uvm_component_utils(clk_drv)

	virtual clk_interface clk_v_itf;
	
	virtual function new(string name,uvm_component parent);
		super.new(name,parent);
		`uvm_info("CLK_DRV(new)",$sformatf("Instantiated new %s in parent %s",name,parent.get_name()))
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
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("Requesting clock sequence item from sequencer........"))
			seq_item_port.get_next_item(item_frm_seqr);
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("Received clock sequence item from sequencer."))
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("item_frm_seqr.clk_en = %0b item_frm_seqr.clk_freq = %0f MHz",item_frm_seqr.clk_en,item_frm_seqr.clk_freq))

			if(!item_frm_seqr.clk_en) begin
				clk_v_itf.clk <= 'z;
				`uvm_info("CLK_DRV(Run Phase)","item_frm_seqr.clk_en is not HIGH. So, Driving Hi-Z into clock interface.")
				`uvm_info("CLK_DRV(Run Phase)","item_done is invoked for handshake with sequencer.")
				seq_item_port.item_done();
				`uvm_info("CLK_DRV(Run Phase)","item_done is returned for handshake with sequencer.")
				continue;
			end

			half_period = (1000.0/item_frm_seqr.clk_freq)/2.0;
			seq_item_port.item_done();
			
			while (!seq_item_port.has_do_available()) begin
				clk_v_itf.clk <= 0;
				#(half_period);
				clk_v_itf.clk <= 1;
				#(half_period);
			end
		end
	endtask
endclass
