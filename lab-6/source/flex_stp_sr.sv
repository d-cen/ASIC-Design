// $Id: $
// File name:   flex_stp_sr
// Created:     9/30/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: Flexible Serial-to-Parallel Shift Register Design

module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output reg [NUM_BITS-1:0] parallel_out
);

	reg [NUM_BITS-1:0] nxt_parallel_out;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (n_rst == 0)
		begin
			parallel_out <= '1;
		end
		else begin
			parallel_out <= nxt_parallel_out;
		end
	end

	always_comb
	begin
		nxt_parallel_out = parallel_out;
		if (shift_enable == 1)
		begin
			if (SHIFT_MSB == 1)
			begin
				nxt_parallel_out = {parallel_out[NUM_BITS-2:0], serial_in};
			end
			else begin
				nxt_parallel_out = {serial_in, parallel_out[NUM_BITS-1:1]};
			end
		end
	end

endmodule