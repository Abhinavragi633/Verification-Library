class seqnc extends uvm_sequence #(seq_item);   // Without Parameterization Driver/Sequence Hand Shake Breaks.
  `uvm_object_utils(seqnc)

  function new(string name = "seqnc");
    super.new(name);
  endfunction

  int num = 5;

  virtual task body();
    for (int i = 0; i < num; i++) begin
      seq_item sqn_itm = seq_item::type_id::create("sqn_itm_%0d",i);
      start_item(sqn_itm);
      sqn_itm.randomize();
      if (!sqn_itm.randomize()) `uvm_error("SEQUENCE", "Randomization failed")
      `uvm_info("SEQUENCE", $sformatf("Generated New Sequence Item (%0d/%0d): %s",i, num, sqn_itm.convert2string()) , UVM_HIGH)
      finish_item(sqn_itm);
    end

    `uvm_info("SEQUENCE", $sformatf("Done Generation of %0d th Sequence", num), UVM_LOW)
  endtask
endclass
