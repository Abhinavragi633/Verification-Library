class rst_drv extends uvm_driver #(rst_seq_item);
	`uvm_component_utils(rst_drv)

	virtual rst_interface rst_v_itf; // virtual is not present then driver can't get interface from config DB.
	virtual clk_interface clk_v_itf;
	
	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual rst_interface)::get(this,"","rst_v_itf",rst_v_itf)) begin
			`uvm_fatal("RST_DRV(Build Phase)","Could not get virtual reset interface from UVM Config DB.")
		end else begin
			`uvm_info("RST_DRV(Build Phase)","Got virtual reset interface from UVM Config DB.")
		end
		if(!uvm_config_db#(virtual clk_interface)::get(this,"","clk_v_itf",clk_v_itf)) begin
			`uvm_fatal("RST_DRV(Build Phase)","Could not get virtual clock interface from UVM Config DB.")
		end else begin
			`uvm_info("RST_DRV(Build Phase)","Got virtual clock interface from UVM Config DB.")
		end
	endfunction

	virtual task void run_phase(uvm_phase phase);
		rst_seq_item item_received;
		rst_v_itf.rst_n <= 0;

		forever begin
			seq_item_port.get_next_item(item_received);

			@(negedge clk_v_itf.clk);
			rst_v_itf.rst_n <= item_received.rst_n;
			
			seq_item_port.item_done();
		end
	endtask
endclass 
