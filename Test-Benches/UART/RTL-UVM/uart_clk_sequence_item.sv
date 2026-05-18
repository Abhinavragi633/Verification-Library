// clk_seq_item declaration for clk_agent
class clk_seq_item extends uvm_sequence_item;
  // Register seq_item in UVM Factory for resuse and flexibility. Enables Factory Automation.
  // functions like do_copy(), do_print(), do_compare(), & etc.
  `uvm_object_utils_begin(clk_seq_item)
    `uvm_field_real(clk_freq,UVM_ALL_ON)
    `uvm_field_int(clk_en,UVM_ALL_ON)
  `uvm_object_utils_end
  
  real clk_freq;
  bit clk_en;

  // In SV, only behavioral constructs are declared as virtual. So, new() should not be declared as virtual function.
  function new (string name = "clk_seq_item");	      // uvm_objects cannot pass parent in new() constructor
    super.new(name);
    `uvm_info("CLK_SEQ_ITEM -> new()",$sformatf("Constructed a new clk_seq_item with name %s .",name),UVM_HIGH)
  endfunction
endclass
