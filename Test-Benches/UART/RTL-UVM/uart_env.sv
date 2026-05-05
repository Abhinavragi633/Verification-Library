class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  uart_agnt uart_agnt0;
  clk_agent clk_agnt0;
  rst_agent rst_agnt0;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    uart_agnt0 = uart_agnt::type_id::create("uart_agnt0",this);
    clk_agent = clk_agent::type_id::create("clk_agnt0", this);
    rst_agent = rst_agent::type_id::create("rst_agnt0", this);
  endfunction
endclass
