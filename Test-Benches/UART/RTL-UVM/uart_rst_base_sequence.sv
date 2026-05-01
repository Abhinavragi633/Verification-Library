class base_rst_seq extends uvm_sequence #(rst_seq_item);
	`uvm_object_utils(base_rst_seq);

	task body();
		rst_seq_item rst_seq;
		rst_seq = rst_seq_item::type_id::create("rst_seq");
		rst_seq.rst_n = 0;
		start_item(rst_seq);
		finish_item(rst_seq);
	endtask
endclass
