class uart_scbd extends uvm_scoreboard;

  `uvm_component_utils(uart_scbd)

  //--------------------------------------------------
  // Analysis port (from monitor)
  //--------------------------------------------------
  uvm_analysis_imp #(clk_obj , uart_scbd) clk_imp_port;

  // Variables to measure time
  time t_prev = 0;
  time t_curr;
  real period;
  real freq;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------
  function new(string name = "uart_scbd", uvm_component parent = null);
    super.new(name,parent);

    `uvm_info("SCOREBOARD",
      $sformatf("Scoreboard created : %s in %s",
        name,
        (parent!=null)?parent.get_name():"null"),
      UVM_MEDIUM)
  endfunction

  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("SCOREBOARD","Build Phase Started",UVM_HIGH)

    clk_imp_port = new("clk_imp_port", this);
  endfunction


  //--------------------------------------------------
  // Write function (called from monitor)
  //--------------------------------------------------
  virtual function void write(clk_obj t);

    // Capture current time
    t_curr = $time;

    // Skip first sample (no previous edge available)
    if (t_prev == 0) begin
      t_prev = t_curr;
      return;
    end

    //--------------------------------------------------
    // Calculate period
    //--------------------------------------------------
    period = t_curr - t_prev;   // in ns

    //--------------------------------------------------
    // Calculate frequency
    //--------------------------------------------------
    if (period != 0)
      freq = 1000.0 / period;   // MHz
    else
      freq = 0;

    //--------------------------------------------------
    // Display result
    //--------------------------------------------------
    `uvm_info("CLK_SCOREBOARD",
      $sformatf("Period = %0f ns, Frequency = %0.2f MHz",
                period, freq),
      UVM_LOW)

    //--------------------------------------------------
    // Example check (optional)
    //--------------------------------------------------
    real expected_freq = 100;

    if (freq inside {[expected_freq-1 : expected_freq+1]}) begin
      `uvm_info("CLK_SCOREBOARD",
        "Frequency is within expected range",
        UVM_LOW)
    end
    else begin
      `uvm_error("CLK_SCOREBOARD",
        $sformatf("Frequency mismatch! Expected ~%0f MHz, Got %0.2f MHz",
                  expected_freq, freq))
    end

    // Update previous time
    t_prev = t_curr;

  endfunction

endclass
``
