// $Id: $
// File name:   sync_low.sv
// Created:     9/17/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: Reset to Logic Low Synchronizer

module sync_low
(
	input wire clk,
	input wire n_rst,
	input wire async_in,
	output reg sync_out
);

	reg out;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (1'b0 == n_rst)
		begin
			out <= 1'b0;
			sync_out <= 1'b0;
		end
		else begin
			out <= async_in;
			sync_out <= out;
		end
	end

endmodule
