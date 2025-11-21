`timescale 1ns/1ps

module sng #(
	parameter gen_type = 0,
	parameter bsl = 255,
	parameter reg_width = $clog2(bsl),
	lfsr_seed = 16'd244
)(
	input		rst, clk,
	input		[reg_width-1:0]	a,
	output reg	[bsl-1:0] a_sbs,
	output 		done
);

	reg en = 1'b1;
	assign done = ~en;
	wire [reg_width-1:0] rev_cnt;
	reg [reg_width-1:0] counter = {reg_width{1'b0}};
	reg [reg_width-1:0] lfsr = lfsr_seed;
	genvar i;
	generate
		for(i=0; i<reg_width; i=i+1) begin
			assign rev_cnt[reg_width-i-1] = counter[i];
		end
	endgenerate

	generate
		if(gen_type==0) begin
			always @(posedge clk) begin
				if(~rst) begin
					en <= 1'b1;
					counter <= {reg_width{1'b0}};
				end	
				
				if(en) begin
					if(counter == bsl) begin
						en <= 1'b0;
					end
					else begin
						// $display("%d", counter);
						counter <= counter + 1;
						// lfsr <= {lfsr[14:0], lfsr[15]^lfsr[11]^lfsr[2]^lfsr[0]};
						lfsr <= {lfsr[6:0], lfsr[7]^lfsr[3]^lfsr[2]^lfsr[1]};
						a_sbs[counter] <= (a>=lfsr?1:0);
					end

				end
			end
		end
		else if(gen_type==1) begin
			always @(posedge clk) begin
				if(~rst) begin
					en <= 1'b1;
					counter <= {reg_width{1'b0}};
				end
				if(en) begin
					if(counter == bsl) begin
						counter <= 0;
						en <= 1'b0;
					end
					else begin
						counter <= counter + 1;
						a_sbs[counter] <= (a>rev_cnt?1:0);
						$display("%d %d", a, rev_cnt);
					end

				end
			end
		end	
	endgenerate

endmodule