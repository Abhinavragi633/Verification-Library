class montr extends uvm_monitor;
  `uvm_component_utils(montr)

  function new(string name = "montr", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  uvm_analysis_port #(seq_item) montr_ana_port;
  virtual uart_itf v_itf;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_itf)::get(this, "", "uart_itf", v_itf)) begin
      `uvm_fatal("MONITOR", "Could not find the virtual interface v_itf")
    end
    montr_ana_port = new("mon_ana_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.new(phase);

    forever begin
      @(v_itf_cb);
      if (v_itf.cb.rstn) begin
        seq_item sqn_itm = seq_item::type_id::create("sqn_itm");
        sqn_itm.addr = v_itf.addr;
        sqn_itm.write_en = v_itf.write_en;
        sqn_itm.read_en = v_itf.read_en;
        sqn_itm.wdata = v_itf.wdata;
        sqn_itm.rdata = v_itf.cb.rdata;
        sqn_itm.rx = v_itf.rx;
        sqn_itm.tx = v_itf.cb.tx;
        sqn_itm.irq = v_itf.cb.irq;
        sqn_itm.rst_n = v_itf.rst_n;
      end
    end
  endtask
endclass
