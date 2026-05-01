class rst_seq_item extends uvm_sequence_item;
	`uvm_object_utils(rst_seq_item)
	logic rst_n;
	function new (string name = rst_seq_item);
		super.new(name);
		`uvm_info("RST_SEQ_ITEM(new)",$sformatf("Instantiated new %s created.",name))
	endfunction
endclass
