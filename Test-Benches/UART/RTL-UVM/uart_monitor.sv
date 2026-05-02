class uart_mntr extends uvm_monitor;
  `uvm_component_utils(uart_mntr)

  function new(string name = "uart_mntr", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  uvm_analysis_port #(uart_seq_item) montr_ana_port;
  virtual uart_interface uart_v_itf;
  virtual clk_interface clk_v_itf;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_interface)::get(this, "", "uart_v_itf", uart_v_itf)) begin
      `uvm_fatal("MONITOR", "Could not find the virtual uart interface.")
    end
    if (!uvm_config_db#(virtual clk_interface)::get(this, "", "clk_v_itf", clk_v_itf)) begin
      `uvm_fatal("MONITOR", "Could not find the virtual clock interface.")
    end
    montr_ana_port = new("montr_ana_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      @(posedge clk_v_itf.clk);
        uart_seq_item sqn_itm = uart_seq_item::type_id::create("sqn_itm",this);
        sqn_itm.addr = uart_v_itf.cb.addr;
        sqn_itm.write_en = uart_v_itf.cb.write_en;
        sqn_itm.read_en = uart_v_itf.cb.read_en;
        sqn_itm.wdata = uart_v_itf.cb.wdata;
        sqn_itm.rdata = uart_v_itf.cb.rdata;
        sqn_itm.rx = uart_v_itf.cb.rx;
        sqn_itm.tx = uart_v_itf.cb.tx;
        sqn_itm.irq = uart_v_itf.cb.irq;

        montr_ana_port.write(sqn_itm);
        
        `uvm_info("MONITOR", $sformatf("Observed transaction:\n%s",sqn_itm.convert2string()),UVM_HIGH)

    end
  endtask
endclass
