// $Id: $
// File name:   controller.sv
// Created:     3/11/2021
// Author:      Ti-Wei Chen
// Lab Section: 337-06
// Version:     1.0  Initial Design Entry
// Description: Controller Unit Design

module controller
(
	input wire clk,
	input wire n_rst,
	input wire dr,
	input wire lc,
	input wire overflow,
	output reg cnt_up,
	output reg clear,
	output reg modwait,
	output reg [2:0] op,
	output reg [3:0] src1,
	output reg [3:0] src2,
	output reg [3:0] dest,
	output reg err
);

	typedef enum bit [4:0] {IDLE, STORE, ZERO, SORT1, SORT2, SORT3, SORT4, 
				MUL1, ADD1, MUL2, SUB2, MUL3, ADD3, MUL4, SUB4,
				EIDLE, LOAD1, WAIT1, LOAD2, WAIT2, LOAD3, WAIT3, LOAD4
				} stateType;

	stateType state;
	stateType nxt_state;
	reg nxt_modwait;

	always_ff @(posedge clk, negedge n_rst)
	begin
		if (n_rst == 0)
		begin
			state <= IDLE;
			modwait <= 0;
		end
		else begin
			state <= nxt_state;
			modwait <= nxt_modwait;
		end
	end

	always_comb
	begin

		op = 3'b000;
		src1 = 4'd0;
		src2 = 4'd0;
		dest = 4'd0;
		err = 0;
		cnt_up = 0;
		clear = 0;
		
		nxt_modwait = modwait;
		nxt_state = state;

		case (state)

			IDLE:
			begin
				op = 3'b000;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 0;

				if (dr == 1)
				begin
					nxt_state = STORE;
				end
				else if (lc == 1)
				begin
 					nxt_state = LOAD1;
				end
				else begin
					nxt_state = IDLE;
				end
			end

			STORE:
			begin
				op = 3'b010;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd5;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;
		
				if (dr == 0)
				begin
 					nxt_state = EIDLE;
				end
				else begin
					nxt_state = ZERO;
				end
			end

			ZERO:
			begin
				op = 3'b101;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd0;
				err = 0;
				cnt_up = 1;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = SORT1;
			end

			SORT1:
			begin
				op = 3'b001;
				src1 = 4'd2;
				src2 = 4'd0;
				dest = 4'd1;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = SORT2;
			end

			SORT2:
			begin
				op = 3'b001;
				src1 = 4'd3;
				src2 = 4'd0;
				dest = 4'd2;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = SORT3;
			end

			SORT3:
			begin
				op = 3'b001;
				src1 = 4'd4;
				src2 = 4'd0;
				dest = 4'd3;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = SORT4;
			end

			SORT4:
			begin
				op = 3'b001;
				src1 = 4'd5;
				src2 = 4'd0;
				dest = 4'd4;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = MUL1;
			end

			MUL1:
			begin
				op = 3'b110;
				src1 = 4'd1;
				src2 = 4'd6;
				dest = 4'd10;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = ADD1;
			end

			ADD1:
			begin
				op = 3'b100;
				src1 = 4'd0;
				src2 = 4'd10;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				if (overflow == 1)
				begin
					nxt_state = EIDLE;
				end
				else begin
					nxt_state = MUL2;
				end
			end

			MUL2:
			begin
				op = 3'b110;
				src1 = 4'd2;
				src2 = 4'd7;
				dest = 4'd10;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = SUB2;
			end

			SUB2:
			begin
				op = 3'b101;
				src1 = 4'd0;
				src2 = 4'd10;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				if (overflow == 1)
				begin
					nxt_state = EIDLE;
				end
				else begin
					nxt_state = MUL3;
				end
			end

			MUL3:
			begin
				op = 3'b110;
				src1 = 4'd3;
				src2 = 4'd8;
				dest = 4'd10;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = ADD3;
			end

			ADD3:
			begin
				op = 3'b100;
				src1 = 4'd0;
				src2 = 4'd10;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				if (overflow == 1)
				begin
					nxt_state = EIDLE;
				end
				else begin
					nxt_state = MUL4;
				end
			end

			MUL4:
			begin
				op = 3'b110;
				src1 = 4'd4;
				src2 = 4'd9;
				dest = 4'd10;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = SUB4;
			end

			SUB4:
			begin
				op = 3'b101;
				src1 = 4'd0;
				src2 = 4'd10;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				if (overflow == 1)
				begin
					nxt_state = EIDLE;
				end
				else begin
					nxt_state = IDLE;
				end
			end

			LOAD1:
			begin
				op = 3'b011;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd6;
				err = 0;
				cnt_up = 0;
				clear = 1;
				nxt_modwait = 1;

				nxt_state = WAIT1;
			end

			WAIT1:
			begin
				op = 3'b000;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 0;

				if (lc == 1)
				begin
					nxt_state = LOAD2;
				end
				else begin
					nxt_state = WAIT1;
				end
			end

			LOAD2:
			begin
				op = 3'b011;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd7;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = WAIT2;
			end

			WAIT2:
			begin
				op = 3'b000;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 0;

				if (lc == 1)
				begin
					nxt_state = LOAD3;
				end
				else begin
					nxt_state = WAIT2;
				end
			end

			LOAD3:
			begin
				op = 3'b011;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd8;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = WAIT3;
			end

			WAIT3:
			begin
				op = 3'b000;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd0;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 0;

				if (lc == 1)
				begin
					nxt_state = LOAD4;
				end
				else begin
					nxt_state = WAIT3;
				end
			end

			LOAD4:
			begin
				op = 3'b011;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd9;
				err = 0;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 1;

				nxt_state = IDLE;
			end

			EIDLE:
			begin
				op = 3'b000;
				src1 = 4'd0;
				src2 = 4'd0;
				dest = 4'd0;
				err = 1;
				cnt_up = 0;
				clear = 0;
				nxt_modwait = 0;

				if (dr == 1)
				begin
					nxt_state = STORE;
				end
				else begin
					nxt_state = EIDLE;
				end
			end
		endcase
	end
endmodule