// $Id: $
// File name:   flex_counter.sv
// Created:     2/15/2021
// Author:      Ti-Wei Chen
// Lab Section: 337-06
// Version:     1.0  Initial Design Entry
// Description: Flex Counter

module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [NUM_CNT_BITS-1:0] rollover_val,
	output reg [NUM_CNT_BITS-1:0] count_out,
	output reg rollover_flag
);

	reg [NUM_CNT_BITS-1:0] nxt_count_out;
	reg nxt_rollover_flag;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (1'b0 == n_rst)
		begin
			count_out <= 1'b0;
			rollover_flag <= 1'b0;
		end
		else begin
			count_out <= nxt_count_out;
			rollover_flag <= nxt_rollover_flag;
		end
	end

	always_comb
	begin
		nxt_count_out = count_out;
		nxt_rollover_flag = 1'b0;

		if (clear == 1)
		begin
			nxt_count_out = 1'b0;
			nxt_rollover_flag = 1'b0;
		end
		else begin
			if (count_enable == 1'b1)
			begin
				if (rollover_val == count_out)
				begin
					nxt_count_out = 1;
				end
				else begin
					nxt_count_out = count_out + 1;
				end		
			end
			if (rollover_val == nxt_count_out)
			begin
				nxt_rollover_flag = 1;
			end	
		end
	end

endmodule
