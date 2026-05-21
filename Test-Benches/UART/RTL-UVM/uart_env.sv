class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  function new(string name ="uart_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  //uart_agnt uart_agnt0;
  clk_agent clk_agent_0;
  //rst_agent rst_agnt0;

  uart_scbd uart_scbd_0;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    //uart_agnt0 = uart_agnt::type_id::create("uart_agnt0",this);
    clk_agent_0 = clk_agent::type_id::create("clk_agent_0", this);
    //rst_agent = rst_agent::type_id::create("rst_agnt0", this);

    uart_scbd_0 = uart_scbd::type_id::create("uart_scbd_0",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    clk_agent_0.clk_mntr_0.clk_montr_ana_port.connect(uart_scbd_0.clk_imp_port);
  endfunction
endclass
