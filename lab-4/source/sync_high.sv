// $Id: $
// File name:   sync_high.sv
// Version:     1.0  Initial Design Entry
// Description: Reset to Logic Synchronizer

module sync_high
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
			out <= 1'b1;
			sync_out <= 1'b1;
		end
		else begin
			out <= async_in;
			sync_out <= out;
		end
	end

endmodule
