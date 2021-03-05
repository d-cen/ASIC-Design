// $Id: $
// File name:   mealy.sv
// Version:     1.0  Initial Design Entry
// Description: Mealy Machine '1101' Detector Design

module mealy
(
	input wire clk,
	input wire n_rst,
	input wire i,
	output reg o
);

	typedef enum bit[2:0] {IDLE, state1, state11, state110} stateType;
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
					nxt_state = state1;
				end
				else begin
					nxt_state = IDLE;
				end
			end
		endcase
	end

	always_comb
	begin
		if (state == state110 && i == 1'b1)
		begin
			o = 1'b1;
		end
		else begin
			o = 1'b0;
		end
	end

endmodule
