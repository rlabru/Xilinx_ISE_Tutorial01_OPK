`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:42 06/26/2022 
// Design Name: 
// Module Name:    OPK_verilog_a7_system 
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
module OPK_verilog_a7_system(
	output [1:0] LEDS,
	input key,
	input clkg,
	input rst
    );

localparam [1:0]
	opkwait = 0,
	opk_t1 = 1,
	opk_t2 = 2,
	opk_t3 = 3;

reg[1:0] state_reg, state_next;

wire clk;
wire rst_n;
reg pulse;
reg key_block;
reg rewind;
reg key_pause;
reg [31:0] count;

assign rst_n = ~rst;

always @(posedge clk, posedge rst_n) begin
	if(rst_n) begin
		state_reg <= opkwait;
	end
	else begin
		state_reg <= state_next;
	end
end

always @(key, rewind, state_reg) begin
	state_next = state_reg; // default state_next
	case (state_reg)
		opkwait: begin
				if( key == 1'b0 ) begin
					state_next = opk_t1;
				end
				else begin
					state_next = opkwait;
				end
			end
		opk_t1: begin
			state_next = opk_t2;
		end
		opk_t2: begin
			if (rewind == 1'b1) begin
				state_next = opkwait;
			end
			else begin
				state_next = opk_t2;
			end
		end
	endcase
end

always @(state_reg) begin
	// default
	pulse = 1'b1;
	key_block = 1'b0;
	case (state_reg)
		opkwait: begin
			pulse = 1'b1;
			key_block = 1'b0;
		end
		opk_t1: begin
			pulse = 1'b0;
			key_block = 1'b1;
		end
		opk_t2: begin
			pulse = 1'b1;
			key_block = 1'b1;
		end
	endcase	
end

always @(posedge clk, posedge rst_n) begin
	if(rst_n) begin
		count = 0;
		key_pause <= 1'b1;
	end
	else begin
		if( key_block ) begin
			count = count + 1;
			key_pause <= 1'b0;
		end
		else begin
			count = 0;
			key_pause <= 1'b1;			
		end
	end
end

always @(posedge clk, posedge rst_n) begin
	if(rst_n) begin
		rewind <= 1'b0;
	end
	else begin
		if( count == 99 ) begin
			rewind <= 1'b1;
		end
		else begin
			rewind <= 1'b0;
		end
	end
end

assign LEDS[0] = pulse;
assign LEDS[1] = key_pause;

parameter C_TRIG0_SIZE = 1;

wire [35:0] control0;
wire [4:0] data;
wire [C_TRIG0_SIZE-1:0] trig;

BUFR #(
	.BUFR_DIVIDE("2"),
	.SIM_DEVICE("7SERIES")
)
BUFR_inst (
	.O(clk),
	.CE(1'b1),
	.CLR(1'b0),
	.I(clkg)
);

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
icon U_ICON (
    .CONTROL0(control0) // INOUT BUS [35:0]
);

ila ILA_inst (
    .CONTROL(control0), // INOUT BUS [35:0]
    .CLK(clkg), // IN
    .DATA(data), // IN BUS [4:0]
    .TRIG0(trig) // IN BUS [0:0]
);

assign data[0] = clk;
assign data[1] = pulse;
assign data[2] = rewind;
assign data[3] = key_block;
assign data[4] = key;

assign trig[0] = key;

endmodule
