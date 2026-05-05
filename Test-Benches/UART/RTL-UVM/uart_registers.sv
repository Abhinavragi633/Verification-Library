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
		data_regf.configure(this,8,0,"RW",0,8'h00,1,1,1);
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
		`uvm_info("STATUS_REG -> build_reg",$sformatf("Created rx_full_regf from class %s .",rx_full_regf.get_type_name()), UVM_DEBUG)
		
		tx_empty_regf.configure(this,1,0,"RO",1,1'h0,1,0,1);
		tx_full_regf.configure(this,1,1,"RO",1,1'h0,1,0,1);
		rx_empty_regf.configure(this,1,2,"RO",1,1'h0,1,0,1);
		rx_full_regf.configure(this,1,3,"RO",1,1'h0,1,0,1);
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
		`uvm_info("CNTRL_REG -> build_reg",$sformatf("Created par_odd_regf from class %s .",par_odd_regf.get_type_name()), UVM_DEBUG)
		
		tx_en_regf.configure(this,1,0,"RW",0,1'h0,1,1,1);
		rx_en_regf.configure(this,1,1,"RW",0,1'h0,1,1,1);
		par_en_regf.configure(this,1,2,"RW",0,1'h0,1,1,1);
		par_odd_regf.configure(this,1,3,"RW",0,1'h0,1,1,1);
		`uvm_info("CNTRL_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass

// CLass Declaration for UART BAUD Register.
class uart_baud_reg extends uvm_reg;
	`uvm_object_utils(uart_baud_reg)

	function new(string name = "uart_baud_reg");
		super.new(name , 8, UVM_NO_COVERAGE);
		`uvm_info("BAUD_REG -> new","uart_baud_reg is created.", UVM_FULL);
	endfunction

	rand uvm_reg_field baud_div_regf;

	// User Defined custom function for Instantiating Reg Fields.
	virtual function void build_reg();
		this.baud_div_regf = uvm_reg_field::type_id::create("baud_div_regf");
		`uvm_info("BAUD_REG -> build_reg",$sformatf("Created baud_div_regf from class %s .",baud_div_regf.get_type_name()), UVM_DEBUG)
			
		baud_div_regf.configure(this,8,0,"RW",0,8'h00,1,1,1);
		`uvm_info("BAUD_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass

// CLass Declaration for UART Interrupt Status (ISR) Register.
class uart_isr_reg extends uvm_reg;
	`uvm_object_utils(uart_isr_reg)

	function new(string name = "uart_isr_reg");
		super.new(name , 8, UVM_NO_COVERAGE);
		`uvm_info("ISR_REG -> new","uart_isr_reg is created.", UVM_FULL);
	endfunction

	uvm_reg_field txe_regf;
	uvm_reg_field rxnf_regf;

	// User Defined custom function for Instantiating Reg Fields.
	virtual function void build_reg();
		this.txe_regf = uvm_reg_field::type_id::create("txe_regf");
		`uvm_info("ISR_REG -> build_reg",$sformatf("Created txe_regf from class %s .",txe_regf.get_type_name()), UVM_DEBUG)
		this.rxnf_regf = uvm_reg_field::type_id::create("rxnf_regf");
		`uvm_info("ISR_REG -> build_reg",$sformatf("Created rxnf_regf from class %s .",rxnf_regf.get_type_name()), UVM_DEBUG)
			
		txe_regf.configure(this,1,0,"RO",1,1'h0,1,0,1);
		rxnf_regf.configure(this,1,1,"RO",1,1'h0,1,0,1);
		`uvm_info("ISR_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass

// CLass Declaration for UART Interrupt Enable (IER) Register.
class uart_ier_reg extends uvm_reg;
	`uvm_object_utils(uart_ier_reg)

	function new(string name = "uart_ier_reg");
		super.new(name , 8, UVM_NO_COVERAGE);
		`uvm_info("ISR_REG -> new","uart_ier_reg is created.", UVM_FULL);
	endfunction

	rand uvm_reg_field txeie_regf;
	rand uvm_reg_field rxnfie_regf;

	// User Defined custom function for Instantiating Reg Fields.
	virtual function void build_reg();
		this.txeie_regf = uvm_reg_field::type_id::create("txeie_regf");
		`uvm_info("IER_REG -> build_reg",$sformatf("Created txeie_regf from class %s .",txeie_regf.get_type_name()), UVM_DEBUG)
		this.rxnfie_regf = uvm_reg_field::type_id::create("rxnfie_regf");
		`uvm_info("IER_REG -> build_reg",$sformatf("Created rxnfie_regf from class %s .",rxnfie_regf.get_type_name()), UVM_DEBUG)
			
		txeie_regf.configure(this,1,0,"RW",0,1'h0,1,0,1);
		rxnfie_regf.configure(this,1,1,"RW",0,1'h0,1,0,1);
		`uvm_info("IER_REG -> build_reg","register fields are configured and exiting build_reg() function.", UVM_FULL)
	endfunction
endclass

class uart_reg_block extends uvm_reg_block;
	`uvm_object_utils(uart_reg_block)

	rand uart_data_reg uart_DATAR;
	uart_status_reg uart_STAR;
	rand uart_cntrl_reg uart_CNTLR;
	rand uart_baud_reg uart_BAUDR;
	uart_isr_reg uart_ISR;
	rand uart_ier_reg uart_IER;

	uvm_reg_map uart_reg_map;

	function new(string name = "uart_reg_block");
		super.new(name);
		`uvm_info("REG_BLOCK -> new", "Created new register block.", UVM_FULL);
	endfunction

	virtual function void build_reg_block();
		this.uart_reg_map = create_map("uart_reg_map",8'h00,1,UVM_LITTLE_ENDIAN,1);
		`uvm_info("REG_BLOCK -> build_reg_block", "Created new register map uart_reg_map.", UVM_FULL);
		
		`uvm_info("REG_BLOCK -> build_reg_block", "Instantiating all Registers..........   ", UVM_FULL);
		this.uart_DATAR = uart_data_reg::type_id::create("uart_DATAR");
		this.uart_STAR = uart_status_reg::type_id::create("uart_STAR");
		this.uart_CNTLR = uart_cntrl_reg::type_id::create("uart_CNTLR");
		this.uart_BAUDR = uart_baud_reg::type_id::create("uart_BAUDR");
		this.uart_ISR = uart_isr_reg::type_id::create("uart_ISR");
		this.uart_IER = uart_ier_reg::type_id::create("uart_IER");
	endfunction
endclass
