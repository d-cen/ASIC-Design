// $Id: $
// File name:   flex_pts_sr.sv
// Created:     9/30/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: Flexible Parallel-to-Serial Shift Register Design


module flex_pts_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input reg [NUM_BITS-1:0] parallel_in,
	output reg serial_out
);

	reg [NUM_BITS-1:0] cur_parallel_in;
	reg [NUM_BITS-1:0] nxt_parallel_in;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (n_rst == 0)
		begin
			cur_parallel_in <= '1;
		end
		else begin
			cur_parallel_in <= nxt_parallel_in;
		end
	end

	always_comb
	begin
		if (load_enable == 1)
		begin
			nxt_parallel_in = parallel_in;
		end
		else if (shift_enable == 1)
		begin
			if (SHIFT_MSB == 1)
			begin
				nxt_parallel_in = {cur_parallel_in[NUM_BITS-2:0], 1'b1};
			end
			else begin
				nxt_parallel_in = {1'b1, cur_parallel_in[NUM_BITS-1:1]};
			end
		end
		else begin
			nxt_parallel_in = cur_parallel_in;
		end
	end

	assign serial_out = SHIFT_MSB? cur_parallel_in[NUM_BITS-1]:cur_parallel_in[0];

endmodule
