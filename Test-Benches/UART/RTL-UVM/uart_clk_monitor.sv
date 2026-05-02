class clk_obj extends uvm_sequence_item;
    logic clk;
    function new(string name = clk_obj);
        super.new();
    endfunction
endclass

class clk_mntr extends uvm_monitor;
  `uvm_component_utils(clk_mntr)

  function new(string name = "clk_mntr", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  uvm_analysis_port #(clk_obj) clk_montr_ana_port;
  
  virtual clk_interface clk_v_itf;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual clk_interface)::get(this, "", "clk_v_itf", clk_v_itf)) begin
      `uvm_fatal("MONITOR", "Could not find the virtual clock interface.")
    end
    clk_montr_ana_port = new("clk_montr_ana_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        clk_obj seqn_itm = clk_obj::type_id::create("seqn_itm");
        seqn_itm.clk = clk_v_itf.clk;
        
        clk_montr_ana_port.write(seqn_itm);
        
        `uvm_info("MONITOR", $sformatf("Observed transaction:\n%s",seqn_itm.clk),UVM_HIGH)

    end
  endtask
endclass
