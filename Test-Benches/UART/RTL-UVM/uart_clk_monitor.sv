// Class Declaration of Clock Object for Clk Monitor.
class clk_obj extends uvm_sequence_item;
    // Factory Registration
    `uvm_object_utils_begin(clk_obj)
        `uvm_field_int(clk, UVM_ALL_ON)
    `uvm_object_utils_end
    
    logic clk;
    
    function new(string name = "clk_obj");
        super.new(name);
        `uvm_info("CLK_OBJ -> new()",$sformatf("A new clk object is created by the name %s",name), UVM_HIGH)
    endfunction
endclass

// Class Declaration for Clcok Monitor to monitor clk signal of the interface.
class clk_mntr extends uvm_monitor;
  `uvm_component_utils(clk_mntr)

  function new(string name = "clk_mntr", uvm_component parent=null);
    super.new(name,parent);
      // Print can crash if parent_name returns a null value. So Null is handles using conditional string formatting.
      `uvm_info("CLK_MNTR -> new()",$sformat("A new clock monitor is constructed in %s by %s",(parent != null) ? parent.get_name() : "null",name),UVM_HIGH)
  endfunction

    uvm_analysis_port #(clk_obj) clk_montr_ana_port;  // Declaration of a Analysis Port for Subscriber and Scoreboard.
  
  virtual uart_itf vitf;

  virtual function void build_phase(uvm_phase phase);
      `uvm_info("CLK_MNTR -> build_phase()","Build Phase is Started.",UVM_HIGH)
    super.build_phase(phase);
    
      if (!uvm_config_db#(virtual uart_itf)::get(this,"", "uart_vitf", vitf)) begin
      `uvm_fatal("CLK_MNTR -> build_phase()", "Could not find the virtual clock interface.")
    end
      else begin
          `uvm_info("CLK_MNTR -> build_phase()","Found the virtual interface from UVM Config DB.", UVM_MEDIUM)
      end
      `uvm_info("CLK_MNTR -> build_phase()","Constructing a New Analysis Port ...........", UVM_MEDIUM)
      // clk_montr_ana_port = uvm_analysis_port#(clk_obj)::type_id::create("clk_montr_ana_port", this);   This is wrong because Analysis Port is not a factory object.
      clk_montr_ana_port = new("clk_montr_ana_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
      `uvm_info("CLK_MNTR -> run_phase()","Run Phase has started.",UVM_HIGH)
    super.run_phase(phase);

    forever begin
        `uvm_info("CLK_MNTR -> run_phase()","Constructing a New Clk object ...........", UVM_MEDIUM)
        clk_obj seqn_itm = clk_obj::type_id::create("seqn_itm");
        
        @(vitf.clk);
        seqn_itm.clk = vitf.clk;
        
        clk_montr_ana_port.write(seqn_itm);
        `uvm_info("CLK_MNTR -> run_phase()","Observed transaction in Clock Montor is : ",UVM_LOW)
        seqn_itm.print();

    end
  endtask
endclass
