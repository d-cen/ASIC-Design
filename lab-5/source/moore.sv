// $Id: $
// File name:   moore.sv
// Created:     09/30/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: Moore Machine '1101' Detector Design

module moore
(
	input wire clk,
	input wire n_rst,
	input wire i,
	output reg o
);

	typedef enum bit[2:0] {IDLE, state1, state11, state110, state1101} stateType;
	stateType state;
	stateType nxt_state;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (n_rst == 1'b0)
		begin
			state <= IDLE;
		end
		else begin
			state <= nxt_state;
		end
	end

	always_comb
	begin
		nxt_state = state;
		case (state)
			IDLE:
			begin
				if (i == 1'b1)
				begin
					nxt_state = state1;
				end
				else begin
					nxt_state = IDLE;
				end
			end

			state1:
			begin
				if (i == 1'b1)
				begin
					nxt_state = state11;
				end
				else begin
					nxt_state = IDLE;
				end
			end

			state11:
			begin
				if (i == 1'b0)
				begin
					nxt_state = state110;
				end
				else begin
					nxt_state = state11;
				end
			end

			state110:
			begin
				if (i == 1'b1)
				begin
					nxt_state = state1101;
				end
				else begin
					nxt_state = IDLE;
				end
			end

			state1101:
			begin
				if (i == 1'b1)
				begin
					nxt_state = state11;
				end
				else begin
					nxt_state = IDLE;
				end
			end
		endcase
	end

	always_comb
	begin
		if (state == state1101)
		begin
			o = 1'b1;
		end
		else begin
			o = 1'b0;
		end
	end

endmodule