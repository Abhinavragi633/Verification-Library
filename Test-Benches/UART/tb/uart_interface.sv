interface uart_itf ;  // SV doesn't allow empty port list. So don't use uart_itf ();
	logic clk;
	logic rst_n;
	
	logic tx;
	logic rx;
	logic irq;
	
	logic write_en;
	logic read_en;
	logic [4:0] addr;
	logic [7:0] wdata;
	logic [7:0] rdata;
endinterface
