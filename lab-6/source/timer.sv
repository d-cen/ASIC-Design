// $Id: $
// File name:   timer.sv
// Created:     10/7/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: Timing Controller

module timer
(
	input wire clk, 
	input wire n_rst, 
	input wire enable_timer,
	output reg shift_enable,
	output reg packet_done
);

	flex_counter #(
			.NUM_CNT_BITS(4)
	)
	COUNT_CLK
	(
		.clk(clk),
		.n_rst(n_rst),
		.clear(!enable_timer),
		.count_enable(enable_timer),
		.rollover_val(4'd10),
		.count_out(),
		.rollover_flag(shift_enable)
	);

	flex_counter #(
			.NUM_CNT_BITS(4)
	)
	COUNT_BIT
	(
		.clk(clk),
		.n_rst(n_rst),
		.clear(!enable_timer),
		.count_enable(shift_enable),
		.rollover_val(4'd9),
		.count_out(),
		.rollover_flag(packet_done)
	);

endmodule