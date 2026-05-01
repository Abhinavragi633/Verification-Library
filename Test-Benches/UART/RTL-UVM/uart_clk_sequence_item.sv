// clk_seq_item declaration for clk_agent
class clk_seq_item extends uvm_sequence_item;
  `uvm_object_utils(clk_seq_item)
  
  real clk_freq;
  bit clk_en;
  
  virtual function new (string name = "clk_seq_item");	      // uvm_objects cannot pass parent in new() constructor
    super.new(name);
  endfunction
endclass
