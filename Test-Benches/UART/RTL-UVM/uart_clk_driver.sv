// Class Declaration of clk Driver.
class clk_drv extends uvm_driver #(clk_seq_item);
	// For UVM Factory Registration.
	`uvm_component_utils(clk_drv)

	virtual uart_itf vitf;  // Declared as virtual as classes cannot access HDL Constructs directly.
	
	virtual function new(string name,uvm_component parent);
		super.new(name,parent);
		`uvm_info("CLK_DRV -> new()",$sformatf("Constructed a new clk_drv with name %s in parent %s",name,parent.get_name()), UVM_HIGH)
	endfunction

	virtual function void build_phase(uvm_phase phase);
		`uvm_info("CLK_DRV -> build_phase()",$sformatf("Build Phase for %s has been started.",this.name),UVM_HIGH)
		super.build_phase(phase);
		
		// Starting from this component, key is searched in upwards heirarchy. If found assigned to vitf.
		if(!uvm_config_db#(virtual uart_itf)::get(this,"","uart_vitf",vitf)) begin
			`uvm_fatal("CLK_DRV -> build_phase()","Could not get virtual clock interface from UVM Config DB.")
		end else begin
			`uvm_info("CLK_DRV -> build_phase()","Got virtual clock interface from UVM Config DB.", UVM_HIGH)
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info("CLK_DRV -> run_phase()",$sformatf("Run Phase for %s has been started.",this.name),UVM_HIGH)
		clk_seq_item clk_item_frm_seqr;
		real half_period;

		//  Clk is initialized to Z.
		vitf.clk <= 'z;
		`uvm_info("CLK_DRV(Run Phase)",$sformatf("vitf.clk is Initialized to %0b", vitf.clk),UVM_LOW)

		forever begin
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("Requesting clock sequence item from sequencer........"),UVM_MEDIUM)
			seq_item_port.get_next_item(clk_item_frm_seqr);
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("Received clock sequence item from sequencer."),UVM_MEDIUM)
			`uvm_info("CLK_DRV(Run Phase)",$sformatf("item_frm_seqr.clk_en = %0b item_frm_seqr.clk_freq = %0f MHz",clk_item_frm_seqr.clk_en,clk_item_frm_seqr.clk_freq),UVM_LOW)

			if(clk_item_frm_seqr.clk_en != 1) begin
				vitf.clk <= 'z;
				`uvm_info("CLK_DRV(Run Phase)","clk_item_frm_seqr.clk_en is not HIGH. So, Driving Hi-Z into interface clk signal.", UVM_MEDIUM)
				`uvm_info("CLK_DRV(Run Phase)","item_done is invoked for handshake with sequencer.",UVM_MEDIUM)
				seq_item_port.item_done();
				`uvm_info("CLK_DRV(Run Phase)","item_done is returned for handshake with sequencer.",UVM_LOW)
				continue;
			end

			if(clk_item_frm_seqr.clk_freq == 0) begin
				`uvm_warning("CLK_DRV(Run Phase)","Clock Frequency is 0. So, Driving 0 into interface clk signal.",UVM_LOW)
				vitf.clk <= 1'b0;
				`uvm_info("CLK_DRV(Run Phase)","item_done is invoked for handshake with sequencer.",UVM_MEDIUM)
				seq_item_port.item_done();
				`uvm_info("CLK_DRV(Run Phase)","item_done is returned for handshake with sequencer.",UVM_LOW)
				continue;
			end

			half_period = (1000.0/clk_item_frm_seqr.clk_freq)/2.0;
			`uvm_info("CLK_DRV(Run Phase)","item_done is invoked for handshake with sequencer.",UVM_MEDIUM)
			seq_item_port.item_done();
			`uvm_info("CLK_DRV(Run Phase)","item_done is returned for handshake with sequencer.",UVM_LOW)
			
			while (!seq_item_port.has_do_available()) begin
				vitf.clk <= 0;
				#(half_period);
				vitf.clk <= 1;
				#(half_period);
			end
		end
	endtask
endclass
