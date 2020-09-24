// $Id: $
// File name:   adder_nbit.sv
// Created:     9/9/2020
// Author:      Ti-Wei Chen
// Lab Section: 337-09
// Version:     1.0  Initial Design Entry
// Description: n-bit Full Adder Design

`timescale 1ns / 100ps

module adder_nbit
#(
	parameter BIT_WIDTH = 4
)
(
	input wire [BIT_WIDTH-1:0] a,
	input wire [BIT_WIDTH-1:0] b,
	input wire carry_in,
	output wire [BIT_WIDTH-1:0] sum,
	output wire overflow
);

	// Input Validation
	genvar j;
	genvar k;

	generate
		for (j = 0; j <= BIT_WIDTH-1; j = j + 1)
		begin
			always @ (a, b, carry_in)
			begin
				assert((a[j] == 1'b1) || (a[j] == 1'b0))
				else $error ("Input 'a' of component is not a digital logic value");

				assert((b[j] == 1'b1) || (b[j] == 1'b0))
				else $error ("Input 'b' of component is not a digital logic value");

				assert((carry_in == 1'b1) || (carry_in == 1'b0))
				else $error ("Input 'carry_in' of component is not a digital logic value");
			end
		end
	endgenerate

	// Adder
	wire [BIT_WIDTH:0] carrys;
	genvar i;

	assign carrys[0] = carry_in;

	generate
		for (i = 0; i <= BIT_WIDTH-1; i = i + 1)
		begin
			adder_1bit ADDX(.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
		end
	endgenerate


	// Output Validation
	generate
		for (k = 0; k <= BIT_WIDTH-1; k = k + 1)
		begin
			always @ (a, b, carrys)
			begin
				#(2) assert(((a[k] + b[k] + carrys[k]) % 2) == sum[k])
				else $error ("Output 's' of 1 bit adder is not correct");
			end
		end
	endgenerate

	assign overflow = carrys[BIT_WIDTH];

endmodule
