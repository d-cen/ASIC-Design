// $Id: $
// File name:   rcv_block.sv
// Version:     1.0  Initial Design Entry
// Description: Receiver Block

module rcv_block
(
	input wire clk,
	input wire n_rst,
	input wire serial_in,
	input wire data_read,
	output reg [7:0] rx_data,
	output reg data_ready,
	output reg overrun_error,
	output reg framing_error
);

	reg start_bit_detected;
	reg new_package_detected;
	reg packet_done;
	reg sbc_clear;
	reg sbc_enable;
	reg load_buffer;
	reg enable_timer;
	reg shift_enable;
	reg [7:0] packet_data;
	reg stop_bit;
	

	start_bit_det START
	(
		.clk(clk),
		.n_rst(n_rst),
		.serial_in(serial_in),
		.start_bit_detected(start_bit_detected),
		.new_package_detected(new_package_detected)
	);

	rcu RCU
	(
		.clk(clk),
		.n_rst(n_rst),
		.start_bit_detected(start_bit_detected),
		.packet_done(packet_done),
		.framing_error(framing_error),
		.sbc_clear(sbc_clear),
		.sbc_enable(sbc_enable),
		.load_buffer(load_buffer),
		.enable_timer(enable_timer)
	);

	timer TIMER
	(
		.clk(clk),
		.n_rst(n_rst),
		.enable_timer(enable_timer),
		.shift_enable(shift_enable),
		.packet_done(packet_done)
	);

	sr_9bit SR9BITS
	(
		.clk(clk),
		.n_rst(n_rst),
		.shift_strobe(shift_enable),
		.serial_in(serial_in),
		.packet_data(packet_data),
		.stop_bit(stop_bit)
	);

	stop_bit_chk STOP
	(
		.clk(clk),
		.n_rst(n_rst),
		.sbc_clear(sbc_clear),
		.sbc_enable(sbc_enable),
		.stop_bit(stop_bit),
		.framing_error(framing_error)
	);

	rx_data_buff RXBUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.load_buffer(load_buffer),
		.packet_data(packet_data),
		.data_read(data_read),
		.rx_data(rx_data),
		.data_ready(data_ready),
		.overrun_error(overrun_error)
	);

endmodule
