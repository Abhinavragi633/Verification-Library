// uvm_object declaration for clk_cfg_obj for clk_agent
class clk_cfg_obj extends uvm_object;
  `uvm_object_utils(clk_cfg_obj)
  
  real clk_freq;
  bit clk_en;
  
  virtual function new (string name = "clk_cfg_obj");	      // Objects cannot pass parent in new() constructor
    super.new(name);
  endfunction
endclass
