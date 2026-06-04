
class base_clk_seq extends uvm_sequence #(clk_cntrl_seq_item);
  `uvm_object_utils(clk_base_seq)

  function new(string name="base_clk_seq");
    super.new(name);
  endfunction
  
  virtual task body();
      clk_cntrl_seq_item req;
  
      req = clk_cntrl_seq_item::type_id::create("req");
  
      `uvm_info(get_type_name(), "Starting Low Frequency Sequence", UVM_MEDIUM)
  
      start_item(req);
      req.clk_freq = 100;   // Outside expected range
      req.clk_en = 1;
      finish_item(req);
  endtask
endclass
