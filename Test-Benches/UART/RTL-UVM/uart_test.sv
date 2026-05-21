//--------------------------------------------------
// Test Class
//--------------------------------------------------
class uart_test extends uvm_test;

  `uvm_component_utils(uart_test)

  //--------------------------------------------------
  // Environment handle
  //--------------------------------------------------
  uart_env env;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------
  function new(string name = "uart_test", uvm_component parent = null);
    super.new(name, parent);

    `uvm_info("UART_TEST",
      $sformatf("Test %s constructed", name),
      UVM_MEDIUM)
  endfunction


  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("UART_TEST", "Build phase started", UVM_MEDIUM)

    // Create environment
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

  endfunction


  //--------------------------------------------------
  // Run Phase
  //--------------------------------------------------
  task run_phase(uvm_phase phase);

    clk_base_seq clk_seq;

    `uvm_info("UART_TEST", "Run phase started", UVM_MEDIUM)

    // Raise objection to keep simulation alive
    phase.raise_objection(this);

    //--------------------------------------------------
    // Create sequence
    //--------------------------------------------------
    clk_seq = clk_base_seq::type_id::create("clk_seq");

    //--------------------------------------------------
    // Start sequence on sequencer
    //--------------------------------------------------
    clk_seq.start(env.clk_agent_0.clk_seqnr_0);

    //--------------------------------------------------
    // Wait for some time (optional)
    //--------------------------------------------------
    #1000ns;

    // Drop objection → simulation ends
    phase.drop_objection(this);

    `uvm_info("UART_TEST", "Run phase completed", UVM_MEDIUM)

  endtask

endclass
