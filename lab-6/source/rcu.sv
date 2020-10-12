// $Id: $
// File name:   rcu.sv
// Created:     10/7/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: Receiver Control Unit (RCU)

module rcu
(
	input wire clk,
	input wire n_rst,
	input wire start_bit_detected,
	input wire packet_done,
	input wire framing_error,
	output reg sbc_clear,
	output reg sbc_enable,
	output reg load_buffer,
	output reg enable_timer
);

	typedef enum bit [2:0] {idle, sbcClear, sbcEnable, loadBuffer, enableTimer, sbcWait} stateType;
	stateType state;
	stateType next_state;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (n_rst == 0)
		begin
			state <= idle;
		end
		else begin
			state <= next_state;
		end
	end

	always_comb
	begin
		next_state = state;
		
		// Prevent latches
		sbc_clear = 0;
		sbc_enable = 0;
		load_buffer = 0;
		enable_timer = 0;

		case (state)
			idle:
			begin
				sbc_clear = 0;
				sbc_enable = 0;
				load_buffer = 0;
				enable_timer = 0;

				if (start_bit_detected == 1)
				begin
					next_state = sbcClear;
				end
				else begin
					next_state = idle;
				end
			end

			sbcClear:
			begin
				sbc_clear = 1;
				sbc_enable = 0;
				load_buffer = 0;
				enable_timer = 0;

				next_state = enableTimer;
			end

			enableTimer:
			begin
				sbc_clear = 0;
				sbc_enable = 0;
				load_buffer = 0;
				enable_timer = 1;

				if (packet_done == 1)
				begin
					next_state = sbcEnable;
				end
				else begin
					next_state = enableTimer;
				end
			end

			sbcEnable:
			begin
				sbc_clear = 0;
				sbc_enable = 1;
				load_buffer = 0;
				enable_timer = 0;

				next_state = sbcWait;
			end

			sbcWait:
			begin
				sbc_clear = 0;
				sbc_enable = 0;
				load_buffer = 0;
				enable_timer = 0;

				if (framing_error == 1)
				begin
					next_state = idle;
				end
				else begin
					next_state = loadBuffer;
				end
			end

			loadBuffer:
			begin
				sbc_clear = 0;
				sbc_enable = 0;
				load_buffer = 1;
				enable_timer = 0;

				next_state = idle;
			end
		endcase
	end

endmodule
