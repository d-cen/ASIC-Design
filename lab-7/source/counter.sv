// $Id: $
// File name:   counter.sv
// Created:     3/11/2021
// Author:      Ti-Wei Chen
// Lab Section: 337-06
// Version:     1.0  Initial Design Entry
// Description: Counter Design

module counter
(
	input wire clk,
	input wire n_rst,
	input wire cnt_up,
	input wire clear,
	output reg one_k_samples
);

	reg [9:0] count_out_val;

	flex_counter #(.NUM_CNT_BITS(10))
	COUNT
	(
		.clk(clk),
		.n_rst(n_rst),
		.clear(clear),
		.count_enable(cnt_up),
		.rollover_val(10'd1000),
		.count_out(count_out_val),
		.rollover_flag(one_k_samples)
	);
endmodule
