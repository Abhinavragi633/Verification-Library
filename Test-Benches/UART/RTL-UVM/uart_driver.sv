class uart_drvr extends uvm_driver #(uart_seq_item);
  `uvm_component_utils(uart_drvr)

  function new(string name = "uart_drvr", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual uart_interface uart_v_itf;
  virtual clk_interface clk_v_itf;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_itf)::get(this, "", "uart_v_itf", uart_v_itf)) begin
      `uvm_fatal("DRIVER", "Could not find virtual uart interface.")
    end
    if (!uvm_config_db#(virtual clk_interface)::get(this, "", "clk_v_itf", clk_v_itf)) begin
      `uvm_fatal("DRIVER", "Could not find virtual clock interface.")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      uart_seq_item sqn_itm;
      `uvm_info("DRIVER", $sformatf("Waiting for item from Sequencer"), UVM_HIGH)
      seq_item_port.get_next_item(sqn_itm);
      drive_item(sqn_itm);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(seq_item sqn_itm);
    @(posedge clk_v_itf.clk);
    uart_v_itf.addr <= sqn_itm.addr;
    uart_v_itf.write_en <= sqn_itm.write_en;
    uart_v_itf.read_en <= sqn_itm.read_en;
    uart_v_itf.wdata <= sqn_itm.wdata;
    uart_v_itf.rx <= sqn_itm.rx;
  endtask
endclass
