`timescale 1ns/1ps

module sng #(
	parameter gen_type = 0,
	parameter bsl = 255,
	parameter reg_width = $clog2(bsl),
	lfsr_seed = 244
)(
	input		rst, clk,
	input		[reg_width-1:0]	a,
	output reg	[bsl-1:0] a_sbs,
	output 		done
);

	reg en = 1'b1;
	assign done = ~en;

	reg [reg_width-1:0] counter = {reg_width{1'b0}};
	reg [reg_width-1:0] lfsr = lfsr_seed;

	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			en <= 1'b1;
			counter <= {reg_width{1'b0}};
		end
		
		if(en) begin
			if(counter == 255) begin
				counter <= 0;
				en <= 1'b0;
			end
			else begin
				counter <= counter + 1;
				lfsr <= {lfsr[6:0], lfsr[7]^lfsr[3]^lfsr[2]^lfsr[1]};
				a_sbs[counter] <= (a>lfsr?1:0);
			end

		end
	end

endmodule