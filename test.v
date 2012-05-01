`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:39:53 05/01/2012
// Design Name:   smash
// Module Name:   /home/elliot/smash/test.v
// Project Name:  smash
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: smash
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	reg start;
	reg reset;
	reg clock;
	reg [3:0] switch;
	
	wire [7:0] led;
	wire [3:0] curr_state;
	wire [3:0] next_state;

	always #(20) clock = ~clock;
	
	
	
	smash uut (
		.clock(clock), 
		.start(start),
		.reset(reset),
		.switch(switch),
		.led(led),
		.curr_state(curr_state), 
		.next_state(next_state)
	);

	
	initial begin
	
		// Initialize
		clock = 0;
		start = 0;
		reset = 0;
		switch = 4'b0000;
		
		#123
		start = 1;
		
		
		#123
		start = 0;


		#123
		reset = 1;
		
		
		#123
		reset = 0;

		#123
		start = 1;
		
		
		#123
		start = 0;
		
		#2000
		switch = 4'b0001;
		
		#123
		switch = 4'b0000;
		




	end
      
endmodule

