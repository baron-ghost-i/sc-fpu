`timescale 1ns / 1ps

module multiplier #(
	// 0: lfsr, 1: ld, 2: deterministic (to be made)
	parameter gen_type = 0,
	parameter bsl = 255,
	parameter reg_width = $clog2(bsl)
)(
	input clk, rst,
	input		[reg_width-1:0] a,
	input		[reg_width-1:0] b,
	output reg	[reg_width-1:0] x = 0,
	output	 	[reg_width-1:0] lfsr1_dbg,
	output	 	[reg_width-1:0] lfsr2_dbg,
	output				done
);

	reg en = 1'b1;
	assign done = ~en;

	reg[reg_width-1:0] counter = {reg_width{1'b0}};

	reg [reg_width-1:0] lfsr1 = 8'd1;
	reg [reg_width-1:0] lfsr2 = 8'd244;

	reg a_sc = 1'b0, b_sc =1'b0;
	wire x_sc;

	assign x_sc = a_sc & b_sc;
	assign lfsr1_dbg = lfsr1;
	assign lfsr2_dbg = lfsr2;

	generate
		if(gen_type == 0) begin
			always @(posedge clk or negedge rst) begin
				if(!rst) begin
					counter <= 0;
					en <= 1'b1;
				end
				else begin
					if(counter == 255) begin
						en <= 1'b0;
					end

					if(en) begin
						counter <= counter+1;
						lfsr1 <= {lfsr1[6:0], lfsr1[7]^lfsr1[3]^lfsr1[2]^lfsr1[1]};
						lfsr2 <= {lfsr2[6:0], lfsr2[7]^lfsr2[4]^lfsr2[2]^lfsr2[0]};
						a_sc <= (a>lfsr1)?1:0;
						b_sc <= (b>lfsr2)?1:0;
						x <= x+x_sc;
					end
				end
			end
		end
		// else if(gen_type == 1) begin
			
		// end
		// else begin
			
		// end
	endgenerate
endmodule

