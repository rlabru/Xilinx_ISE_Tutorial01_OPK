`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:53:09 06/26/2022
// Design Name:   OPK_verilog_a7_system
// Module Name:   D:/xilinx_prj/OPK_verilog_a7/OPK_verilog_a7_test.v
// Project Name:  OPK_verilog_a7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: OPK_verilog_a7_system
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module OPK_verilog_a7_test;

	// Inputs
	reg key;
	reg clkg;
	reg rst;

	// Outputs
	wire [1:0] LEDS;

	// Instantiate the Unit Under Test (UUT)
	OPK_verilog_a7_system uut (
		.LEDS(LEDS), 
		.key(key), 
		.clkg(clkg), 
		.rst(rst)
	);
	initial begin
		clkg = 1'b0;
		forever #10 clkg = ~clkg;
	end

	initial begin
		// Initialize Inputs
		key = 1;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#20;
		key = 0;
		#100;
		key = 1;
		#2000;

	end
      
endmodule

