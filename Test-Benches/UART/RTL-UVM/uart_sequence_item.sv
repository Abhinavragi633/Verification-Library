class uart_seq_item extends uvm_sequence_item;

  `uvm_object_utils_begin(uart_seq_item)
    `uvm_field_int(addr,     UVM_ALL_ON)
    `uvm_field_int(write_en, UVM_ALL_ON)
    `uvm_field_int(read_en,  UVM_ALL_ON)
    `uvm_field_int(wdata,    UVM_ALL_ON)
    `uvm_field_int(rdata,    UVM_ALL_ON)
    `uvm_field_int(rx,       UVM_ALL_ON)
    `uvm_field_int(tx,       UVM_ALL_ON)
    `uvm_field_int(irq,      UVM_ALL_ON)
  `uvm_object_utils_end

  rand bit [7:0] addr;
  rand bit write_en;
  rand bit read_en;
  rand bit [7:0] wdata;
  rand bit rx;

  bit [7:0] rdata;
  bit tx;
  bit irq;

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  constraint c1 { write_en ^ read_en; }
  constraint c2 { addr inside {8'h00,8'h04,8'h08,8'h0C,8'h10,8'h14}; }

  function string convert2string();
    return $sformatf(
      "\n\tSEQ_ITEM (REG) addr=%0h w_en=%0d wdata=%0h r_en=%0d rdata=%0h"
      "\n\tSEQ_ITEM (SERIAL) rx=%0d tx=%0d irq=%0d rst_n=%0d",
      addr, write_en, wdata, read_en, rdata, rx, tx, irq, rst_n
    );
  endfunction

endclass
