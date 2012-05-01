`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:38:21 05/01/2012 
// Design Name: 
// Module Name:    smash 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module smash(
    clock, 
    start,
    reset,
    switch,
    led,
	curr_state,
	next_state
);

	input clock;
	input start;
	input reset;
	input [3:0] switch;

	output [7:0] led;
	output [3:0] curr_state;
	output [3:0] next_state;

	reg [7:0] led;
	
	reg [3:0] curr_state;
	reg [3:0] next_state;
	
	reg [31:0] duration_left;
	reg [31:0] times_left;
	
	// FLASH
    parameter FLASHt    = 16;
    parameter FLASHd    = 3;
	reg flashon;
	
	// GAME
	reg [31:0] seed     = 0;
	reg [1:0] rand      = 0;
    parameter GAMEt     = 4;
	parameter GAMEd     = 10;	
	reg answer          = 0;
	
    parameter IDLE      = 0;
    parameter RESET     = 1;
    parameter FLASH     = 2;
    
    parameter GAME      = 3;    
    parameter POP       = 4;    
    
    parameter SCORE     = 12;
	
	// next stage
	always @ (*) begin
	    case (curr_state)
	        IDLE    :   if (start) begin                // start = 1 : IDLE => FLASH
	        
                            $display("IDLE -> FLASH");                            
	                        next_state = FLASH;
	                        	     
	                        // FLASH init
	                        flashon = 1;           
	                        times_left = FLASHt;
	                        duration_left = FLASHd;
	                        
                        end                       
                        
                        
                        
            FLASH   :   if (reset) begin                // reset = 1 : FLASH => IDLE
            
                            $display("FLASH -> IDLE");
                            next_state = IDLE;
                            
                        end else if (times_left == 0) begin      //  FLASH => GAME
            
                            $display("FLASH -> GAME");                            
	                        next_state = GAME;
	                        
	                        // GAME init
	                        times_left = 4;
	                        duration_left = 3;
	                        
	                        
	                        
	                    end else if (duration_left == 0) begin
                            
                            // ON -> OFF
                            flashon = ~flashon;
                            
	                        times_left = times_left - 1;
	                        duration_left = FLASHd;
	                    end
	       
	       
            POP     :   if (reset) begin                // reset = 1 : POP => IDLE
            
                            $display("POP -> IDLE");
                            
                            
                            
                            next_state = IDLE;
                            
                            
                        end else if (switch == 0) begin          // pop back
                           
                            $display("POP BACK!");
                            
                            
                            next_state = GAME;
                             
                        end
	       
            GAME    :   if (reset) begin                // reset = 1 : GAME => IDLE
            
                            $display("GAME -> IDLE");
                            
                            
                            
                            next_state = IDLE;
                        
                        end else if (switch != 0) begin          // pop!
                        
                            $display("POP");
                            
                            next_state = POP;
                            
                        
                            case (switch)
                                1   :   answer = 1;
                                2   :   answer = 2;
                                4   :   answer = 3;
                                8   :   answer = 4;
                            endcase
                            
                            $display(answer);
                        
                        
                        
                            
                        
                        
                        
                        end else if (times_left == 0) begin      // GAME => IDLE
                            $display("DONE");                           
	                        next_state = IDLE;
                            
                            
                            
                            
            
	                    end else if (duration_left == 0) begin     
                            
	                        times_left = times_left - 1;
	                        duration_left = 5;
	                        rand = seed % 4;
	                    end
	                    
            default :   next_state = IDLE;
	    endcase
	end
	
	
	
	// state reg
	
	always @ (negedge clock) begin
	    curr_state <= next_state;
	    
	    if (duration_left > 0)
	        duration_left <= duration_left - 1;      
	        
	    // SEED	    
	    if (seed == 0)
	        seed <= 100;
	    seed <= seed + 1;
	    
	        
	        
	end
	
	// output
	always @ (*) begin
	    case (curr_state)
	        IDLE    :   led = 8'b00000000;
	        FLASH   :   if (flashon)    led = 8'b11111111;
	                    else            led = 8'b00000000;  
	        GAME    :   case (rand % 4)
	                        0:          led = 8'b00000011;
	                        1:          led = 8'b00001100;
	                        2:          led = 8'b00110000;
	                        3:          led = 8'b11000000;
	                        default:    led = 8'b01010101;
	                    endcase
	       POP      :   case (rand % 4)
	                        0:          led = 8'b11111100;
	                        1:          led = 8'b11110011;
	                        2:          led = 8'b11001111;
	                        3:          led = 8'b00111111;
	                        default:    led = 8'b01010101;
	                    endcase
	    endcase
	end
	


endmodule
