// Interface for Driving reset signal to DUT.
interface rst_interface ();
  
  // Signal Declaration
  logic rst_n;

  // Mod Ports.
  modport DUT (input rst_n);
  modport tb_top (output rst_n);
  
endinterface
