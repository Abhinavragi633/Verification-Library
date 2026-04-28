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
    montr_ana_port = new("montr_ana_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      @(v_itf.cb);
      if (v_itf.cb.rst_n) begin
        seq_item sqn_itm = seq_item::type_id::create("sqn_itm",this);
        sqn_itm.addr = v_itf.cb.addr;
        sqn_itm.write_en = v_itf.cb.write_en;
        sqn_itm.read_en = v_itf.cb.read_en;
        sqn_itm.wdata = v_itf.cb.wdata;
        sqn_itm.rdata = v_itf.cb.rdata;
        sqn_itm.rx = v_itf.cb.rx;
        sqn_itm.tx = v_itf.cb.tx;
        sqn_itm.irq = v_itf.cb.irq;
        sqn_itm.rst_n = v_itf.cb.rst_n;

        montr_ana_port.write(sqn_itm);
        
        `uvm_info("MONITOR", $sformatf("Observed transaction:\n%s",sqn_itm.convert2string()),UVM_HIGH)

      end
    end
  endtask
endclass
