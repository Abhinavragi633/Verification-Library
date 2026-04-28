class drvr extends uvm_driver #(seq_item);
  `uvm_component_utils(drvr)

  function new(string name = "drvr", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual uart_itf v_itf;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_itf)::get(this, "", "uart_itf", v_itf)) begin
      `uvm_fatal("DRIVER", "Could not find virtual interface.")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item sqn_itm;
      `uvm_info("DRIVER", $sformatf("Waiting for item from Sequencer"), UVM_HIGH)
      seq_item_port.get_next_item(sqn_itm);
      drive_item(sqn_itm);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(seq_item sqn_itm);
    @(v_itf.cb);
    v_itf.cb.addr <= sqn_itm.addr;
    v_itf.cb.write_en <= sqn_itm.write_en;
    v_itf.cb.read_en <= sqn_itm.read_en;
    v_itf.cb.wdata <= sqn_itm.wdata;
    v_itf.cb.rx <= sqn_itm.rx;
    v_itf.rst_n <= sqn_itm.rst_n;
  endtask
endclass
