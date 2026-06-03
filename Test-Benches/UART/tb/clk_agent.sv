// Declartion of CLK Agent.
	/* Steps:
			1) Class Declaration for clock control sequence item.
				a. Declare signals of seq_item.
				b. Register clk_seq_item to UVM Factory and enable UVM Macros.
				c. Define new() constructor function.
			2) Class Declaration for clock driver.*/

// Sequence Item is the value which propagates inside the UVM TB Architecture.
class clk_cntrl_seq_item extends uvm_sequence_item;
	bit clk_en;
	real clk_freq;

	`uvm_object_utils_begin(clk_cntrl_seq_item)
		`uvm_field_int(clk_en,UVM_ALL_ON)
		`uvm_field_real(clk_freq,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "clk_cntrl_seq_item");
		`uvm_info("clk_seq_item",$sformatf("new() constructor is called for object %s.",name),UVM_DEBUG)
		super.new(name);
		`uvm_info("clk_seq_item",$sformatf("new() constructor is completed for object %s.",name),UVM_FULL)
	endfunction
endclass

// Driver is the UVM Component which controls when to drive the signals into virtual interface.
class clk_drv extends uvm_driver #(clk_cntrl_seq_item);	//	Parameterization is neccessary for Driver Class.
	virtual uart_itf uart_vitf_0;

	`uvm_component_utils(clk_drv)

	function new(string name = "clk_drv",uvm_component parent = null);
		`uvm_info("clk_drv",$sformatf("new() constructor is called for uvm_component %s from uvm_component %s",this.get_name(),parent.get_full_name()),UVM_DEBUG)
		super.new(name,parent);
		`uvm_info("clk_drv",$sformatf("new() constructor is completed for uvm_component %s.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual void function build_phase (uvm_phase phase);
		`uvm_info("clk_drv",$sformatf("Build Phase for %s has started.",this.get_full_name()),UVM_DEBUG)

		super.build_phase(phase);

		if(uvm_config_db #(virtual uart_itf)::get(this,"","uart_vitf",uart_vitf_0) begin
			`uvm_info("clk_drv","Successfully fetched virtual UART Inteface from UVM Config DB.",UVM_FULL)
		end
		else begin
			`uvm_fatal("clk_drv","Unable to fetch virtual UART Interface from UVM Config DB.")
		end

		   `uvm_info("clk_drv",$sformatf("Build Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info("clk_drv",$sformatf("Run Phase for %s has started.",this.get_full_name()),UVM_DEBUG)

		super.run_phase(phase);

		clk_cntrl_seq_item clk_cntrl;

		int i = 1;
		real half_period;

		forever begin
				seq_item_port.get_next_item(clk_cntrl);

				`uvm_info("clk_drv",$sformatf("Got clk_seq_item %d from clk sequencer.",i),UVM_HIGH)
				clk_cntrl.print();
				i++;

				if(clk_cntrl.clk_en == 0) begin
					uart_vitf_0.clk = 'bz;
					`uvm_info("clk_drv","Clock is Off.",UVM_MEDIUM)
					seq_item_port.item_done();
					continue;
				end else if(clk_cntrl.clk_freq == 0) begin
					uart_vitf_0.clk = 'b0;
					`uvm_info("clk_drv","Clock is On. But frequency is 0.",UVM_MEDIUM)
					seq_item_port.item_done();
					continue;
				end
				
				half_period = (1000/(clk_cntrl.clk_freq)) / 2;
				uart_vitf_0.clk = 'b0;
				`uvm_info("clk_drv",$sformatf("Clock is On @ %f Mhz.",clk_cntrl.clk_freq),UVM_MEDIUM)
				seq_item_port.item_done();
					
				while(!seq_item_port.has_do_available()) begin
					#(half_period) uart_vitf_0.clk = 'b1;
					#(half_period) uart_vitf_0.clk = 'b0;
				end	
		end	
		`uvm_info("clk_drv",$sformatf("Run Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endtask
endclass
class clk_mntr extends uvm_monitor;
	`uvm_component_utils(clk_mntr)
	
	virtual uart_itf uart_vitf_0;

	uvm_analysis_port #(clk_cntrl_seq_item) clk_mntr_ap;

	function new(string name = "clk_mntr",uvm_component parent = null);
		`uvm_info("clk_mntr",$sformatf("new() constructor is called for uvm_component %s from uvm_component %s",this.get_name(),parent.get_full_name()),UVM_DEBUG)
		super.new(name,parent);
		`uvm_info("clk_mntr",$sformatf("new() constructor is completed for uvm_component %s.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual void function build_phase (uvm_phase phase);
		`uvm_info("clk_mntr",$sformatf("Build Phase for %s has started.",this.get_full_name()),UVM_FULL)

		super.build_phase(phase);

		if(uvm_config_db #(virtual uart_itf)::get(this,"","uart_vitf",uart_vitf_0) begin
			`uvm_info("clk_mntr","Successfully fetched virtual UART Inteface from UVM Config DB.",UVM_FULL)
		end else begin
			`uvm_fatal("clk_mntr","Unable to fetch virtual UART Interface from UVM Config DB.")
		end

		   // clk_mntr_ap = uvm_analysis_port #(clk_cntrl_seq_item)::type_id::create("clk_mntr_ap"); ----->
		   // This is not use this type of instantiation is only used for UVM components and objects which needs Factory Instantiation and potentially overriden somewhere else.
		   clk_mntr_ap = new("clk_mntr_ap",this);
		   `uvm_info("clk_mntr",$sformatf("Build Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual task run_phase (uvm_phase phase);
		`uvm_info("clk_mntr",$sformatf("Run Phase for %s has started.",this.get_full_name()),UVM_DEBUG)
		time t0;
		real freq, f_temp;

		forever begin
			clk_cntrl_seq_item clk_cntrl;
			clk_cntrl = clk_cntrl_seq_item::type_id::create("clk_cntrl");
			
			if (uart_vitf_0.clk === 1'bx || uart_vitf_0.clk === 1'bz) begin
				`uvm_info("clk_mntr","Clk is Disabled.",UVM_FULL)
				clk_cntrl.clk_en = 0;
				clk_mntr_ap.write(clk_cntrl);
				@(uart_vitf_0.clk);
			end else begin
				@(posedge uart_vitf_0.clk) t0 = $time;
				@(posedge uart_vitf_0.clk) t0 = $time - t0;
				
				freq = (1000 / t0);
				f_temp = freq;
				clk_cntrl.clk_en = 1;
				clk_cntrl.clk_freq = freq;
				clk_mntr_ap.write(clk_cntrl);
				`uvm_info("clk_mntr",$sformatf("Clk is ON and running at frequency %f MHz.",clk_cntrl.clk_freq),UVM_FULL)
				while (f_temp == freq) begin
					t0 = $time;
					@(posedge uart_vitf_0.clk) t0 = $time - t0;
					freq = (1/(t0 * 1000));
				end
			end
		end
	endtask
endclass

class clk_agent extends uvm_agent;
	`uvm_component_utils(clk_agent)

	clk_drv clk_drv_0;
	clk_mntr clk_mntr_0;
	uvm_sequencer #(clk_cntrl_seq_item) clk_seqr_0;

	function new(string name = "clk_agent",uvm_component parent = null);
		`uvm_info("clk_agent",$sformatf("new() constructor is called for uvm_component %s from uvm_component %s",this.get_name(),parent.get_full_name()),UVM_DEBUG)
		super.new(name,parent);
		`uvm_info("clk_agent",$sformatf("new() constructor is completed for uvm_component %s.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual void function build_phase (uvm_phase phase);
		`uvm_info("clk_agent",$sformatf("Build Phase for %s has started.",this.get_full_name()),UVM_FULL)

		super.build_phase(phase);

		clk_mntr_0 = clk_mntr::type_id::create("clk_mntr_0",this);

		if(is_active == UVM_ACTIVE) begin
			clk_seqr_0 = uvm_sequencer#(clk_cntrl_seq_item)::type_id::create("clk_seqr_0", this);
      		clk_drv_0   = clk_drv::type_id::create("clk_drv_0", this);
    	end

		`uvm_info("clk_agent",$sformatf("Build Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction

	virtual void function connect_phase(uvm_phase phase);
		`uvm_info("clk_agent",$sformatf("Connect Phase for %s has started.",this.get_full_name()),UVM_FULL)

		super.connect_phase(phase);
		
		if(is_active == UVM_ACTIVE) begin
			clk_drv_0.seq_item_port.connect(clk_seqr_0.seq_item_export);
		end

		`uvm_info("clk_agent",$sformatf("Connect Phase for %s has completed.",this.get_full_name()),UVM_FULL)
	endfunction
endclass

