// $Id: $
// File name:   magnitude.sv
// Version:     1.0  Initial Design Entry
// Description: Magnitude Design

module magnitude
(
	input wire [16:0] in,
	output reg [15:0] out
);

	reg [16:0] mid_in;

	always_comb
	begin
		if (in[16] == 1)
		begin
			mid_in = ~in[15:0];
			out = mid_in + 1;
		end
		else begin
			out = in[15:0];
		end
	end

endmodule
