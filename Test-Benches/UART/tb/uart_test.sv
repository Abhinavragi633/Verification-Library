//--------------------------------------------------
// Test Class
//--------------------------------------------------
class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  //--------------------------------------------------
  // Environment handle
  //--------------------------------------------------
  uart_env env;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);

    `uvm_info("base_test",
      $sformatf("Test %s is constructed", name),
      UVM_MEDIUM)
  endfunction


  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("base_test", "Build phase started", UVM_MEDIUM)

    // Create environment
    `uvm_info("base_test","Constructing new environment env ............",UVM_MEDIUM)
    env = uart_env::type_id::create("env", this);

    //--------------------------------------------------
    // Configure agent mode
    //--------------------------------------------------
    uvm_config_db#(uvm_active_passive_enum)::set(
      this,
      "env.clk_agent_0",
      "is_active",
      UVM_ACTIVE
    );
    `uvm_info("base_test","clk_agent_0 is set as active in UVM Config DB.",UVM_MEDIUM)

    /*uvm_config_db#(uvm_active_passive_enum)::set(
      this,
      "env.rst_agent_0",
      "is_active",
      UVM_ACTIVE
    );
    `uvm_info("base_test","rst_agent_0 is set as active in UVM Config DB.",UVM_MEDIUM)

    uvm_config_db#(uvm_active_passive_enum)::set(
  this,
  "env.uart_agent_0",
  "is_active",
  UVM_ACTIVE
);*/

  endfunction

  virtual function void end_of_elaboration_phase (uvm_phase phase);
  `uvm_info("base_test","end_of_elaboration phase started. printing testbench topology ...........",UVM_MEDIUM)
         uvm_top.print_topology ();
  endfunction


  //--------------------------------------------------
  // Run Phase
  //--------------------------------------------------
task run_phase(uvm_phase phase);

  base_clk_seq clk_seq;
  //base_rst_seq rst_seq;

  phase.raise_objection(this);

  clk_seq = base_clk_seq::type_id::create("clk_seq");
  //rst_seq = base_rst_seq::type_id::create("rst_seq");

  //------------------------------------------
  // Start CLOCK (background)
  //------------------------------------------
  fork
    begin
      `uvm_info("base_test","Starting clock sequence",UVM_MEDIUM)
      clk_seq.start(env.clk_agent_0.clk_seqr_0);
    end
  join_none

  //------------------------------------------
  // Apply RESET after clock starts
  //------------------------------------------
  #10;

  //`uvm_info("base_test","Starting reset sequence",UVM_MEDIUM)
  //rst_seq.start(env.rst_agent_0.rst_seqr_0);

  //------------------------------------------
  #1000ns;

  phase.drop_objection(this);

endtask
  
endclass

/*class uart_reg_reset_test extends base_test;

  `uvm_component_utils(uart_reg_reset_test)

  function new(string name="uart_reg_reset_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    uart_reg_reset_seq seq;

    super.run_phase(phase); // runs clk + reset


    phase.raise_objection(this);

    //------------------------------------------
    // Wait after reset
    //------------------------------------------
    #250;

    //------------------------------------------
    // Run RAL reset check
    //------------------------------------------
    seq = uart_reg_reset_seq::type_id::create("seq");

    seq.regmodel = env.regmodel;

    seq.start(null); // IMPORTANT for RAL

    //------------------------------------------
    phase.drop_objection(this);

  endtask

endclass*/


