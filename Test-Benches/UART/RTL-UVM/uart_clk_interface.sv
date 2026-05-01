// Interface for driving clock signal to DUT
interface clk_interface ();
  
  // Signals Declaration
  logic clk;

  // Describing who is Drivers and Load using Mod ports.
  modport DUT (input clk);
  
endinterface
