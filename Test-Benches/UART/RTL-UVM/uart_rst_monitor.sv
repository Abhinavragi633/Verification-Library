class rst_mntr extends uvm_monitor;
  `uvm_component_utils(rst_mntr)

  function new(string name = "rst_mntr", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  uvm_analysis_port #(rst_seq_item) rst_montr_ana_port;
  
  virtual rst_interface rst_v_itf;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual rst_interface)::get(this, "", "rst_v_itf", rst_v_itf)) begin
      `uvm_fatal("MONITOR", "Could not find the virtual rst interface.")
    end
    rst_montr_ana_port = new("rst_montr_ana_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        rst_seq_item seqn_itm = rst_seq_item::type_id::create("seqn_itm");
        seqn_itm.rst_n = rst_v_itf.rst_n;
        
        rst_montr_ana_port.write(seqn_itm);
        
      `uvm_info("MONITOR", $sformatf("Observed transaction:\n%0d",seqn_itm.rst_n),UVM_HIGH)

    end
  endtask
endclass
