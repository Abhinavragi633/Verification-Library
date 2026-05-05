// Class Declaration for UART DATA Register.
class uart_data_reg extends uvm_reg;
	`uvm_object_utils(uart_data_reg)

	function new(string name = "uart_data_reg");
		super.new(name , 8, UVM_NO_COVERAGE);
		`uvm_info("DATA_REG -> new","uart_data_reg is created.", UVM_FULL);
	endfunction

	rand uvm_reg_field data_regf;

	// User Defined custom function for Instantiating Reg Fields.
	virtual function void build_reg();
		this.data_regf = uvm_reg_field::type_id::create("data_regf");
		`uvm_info("DATA_REG -> build_reg",$sformatf("Created data_regf from class %s .",data_regf.get_type_name()), UVM_DEBUG)
		data_regf.configure(this,8,0,"RW",1,8'h,1,1,1);
		`uvm_info("DATA_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass

// CLass Declaration for UART STATUS Register.
class uart_status_reg extends uvm_reg;
	`uvm_object_utils(uart_status_reg)

	function new(string name = "uart_status_reg");
		super.new(name , 8, UVM_NO_COVERAGE);
		`uvm_info("DATA_REG -> new","uart_status_reg is created.", UVM_FULL);
	endfunction

	uvm_reg_field tx_empty_regf;
	uvm_reg_field tx_full_regf;
	uvm_reg_field rx_empty_regf;
	uvm_reg_field rx_full_regf;

	// User Defined custom function for Instantiating Reg Fields.
	virtual function void build_reg();
		this.tx_empty_regf = uvm_reg_field::type_id::create("tx_empty_regf");
		`uvm_info("STATUS_REG -> build_reg",$sformatf("Created tx_empty_regf from class %s .",tx_empty_regf.get_type_name()), UVM_DEBUG)
		this.tx_full_regf = uvm_reg_field::type_id::create("tx_full_regf");
		`uvm_info("STATUS_REG -> build_reg",$sformatf("Created tx_full_regf from class %s .",tx_full_regf.get_type_name()), UVM_DEBUG)
		this.rx_empty_regf = uvm_reg_field::type_id::create("rx_empty_regf");
		`uvm_info("STATUS_REG -> build_reg",$sformatf("Created rx_empty_regf from class %s .",rx_empty_regf.get_type_name()), UVM_DEBUG)
		this.rx_full_regf = uvm_reg_field::type_id::create("rx_full_regf");
		`uvm_info("STATUS_REG -> build_reg",$sformatf("Created rx_full_regf from class %s .",data_regf.get_type_name()), UVM_DEBUG)
		
		tx_empty_regf.configure(this,1,0,"RO",1,1'h,1,0,1);
		tx_full_regf.configure(this,1,1,"RO",1,1'h,1,0,1);
		rx_empty_regf.configure(this,1,2,"RO",1,1'h,1,0,1);
		rx_full_regf.configure(this,1,3,"RO",1,1'h,1,0,1);
		`uvm_info("STATUS_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass

// CLass Declaration for UART CNTRL Register.
class uart_cntrl_reg extends uvm_reg;
	`uvm_object_utils(uart_cntrl_reg)

	function new(string name = "uart_cntrl_reg");
		super.new(name , 8, UVM_NO_COVERAGE);
		`uvm_info("CNTRL_REG -> new","uart_cntrl_reg is created.", UVM_FULL);
	endfunction

	rand uvm_reg_field tx_en_regf;
	rand uvm_reg_field rx_en_regf;
	rand uvm_reg_field par_en_regf;
	rand uvm_reg_field par_odd_regf;

	// User Defined custom function for Instantiating Reg Fields.
	virtual function void build_reg();
		this.tx_en_regf = uvm_reg_field::type_id::create("tx_en_regf");
		`uvm_info("CNTRL_REG -> build_reg",$sformatf("Created tx_en_regf from class %s .",tx_en_regf.get_type_name()), UVM_DEBUG)
		this.rx_en_regf = uvm_reg_field::type_id::create("rx_en_regf");
		`uvm_info("CNTRL_REG -> build_reg",$sformatf("Created rx_en_regf from class %s .",rx_en_regf.get_type_name()), UVM_DEBUG)
		this.par_en_regf = uvm_reg_field::type_id::create("par_en_regf");
		`uvm_info("CNTRL_REG -> build_reg",$sformatf("Created par_en_regf from class %s .",par_en_regf.get_type_name()), UVM_DEBUG)
		this.par_odd_regf = uvm_reg_field::type_id::create("par_odd_regf");
		`uvm_info("CNTRL_REG -> build_reg",$sformatf("Created par_odd_regf from class %s .",par_oddregf.get_type_name()), UVM_DEBUG)
		
		tx_empty_regf.configure(this,1,0,"RO",1,1'h,1,0,1);
		tx_full_regf.configure(this,1,1,"RO",1,1'h,1,0,1);
		rx_empty_regf.configure(this,1,2,"RO",1,1'h,1,0,1);
		rx_full_regf.configure(this,1,3,"RO",1,1'h,1,0,1);
		`uvm_info("STATUS_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass
