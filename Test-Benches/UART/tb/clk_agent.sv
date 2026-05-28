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
		real half_period;

		forever
			begin
				seq_item_port.get_item
			end
		
		`uvm_info("clk_drv",$sformatf("Run Phase for %s has completed.",this.get_full_name()),UVM_FULL)
		
	
	
		
	
