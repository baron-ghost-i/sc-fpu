`timescale 1ns / 1ps

module multiplier (
	input	clk, rst,
	input	[31:0]	A, B,
	output	[31:0] 	P,
	output	done
);
	// bit widths for each
	localparam integer sign_bit = 1;
	localparam integer exponent = 8;
	localparam integer mantissa = 23;

	reg en = 1'b1;
	assign done = ~en;

	wire done_A_h, done_B_h, done_A_m, done_B_m;
	wire done_all = ((done_A_h)&(done_B_h));//&((done_A_m)&(done_B_m));
	wire [254:0] A_h_sbs, B_h_sbs, prod_hi;//, A_m_sbs, B_m_sbs, prod_mid, prod_hi_mid, prod_mid_hi;

	reg [7:0] accumulator = 8'b0;
	reg [7:0] counter = 8'b0;

	assign P[31] = A[31]^B[31];
	// multiplication happens in the form of 0.1a * 0.1b, with resultant's first 1 being either at MSB or MSB-1. We thus decrement from exponent accordingly
	assign P[30:23] = (A[30:23]+1)+(B[30:23]+1)-127-{6'b0, (~accumulator[7])&accumulator[6], accumulator[7]};
	
	assign P[22:16] = accumulator[7]?accumulator[6:0]:{accumulator[5:0], 1'b0};
	assign P[15:0] = 16'b0;

	wire [7:0] sng_in_a, sng_in_b;
	assign sng_in_a[7] = 1'b1;
	assign sng_in_b[7] = 1'b1;
	genvar i;
	generate
		for(i=0; i<7; i=i+1) begin
			assign sng_in_a[i] = A[16+i];
			assign sng_in_b[i] = B[16+i];
		end
	endgenerate

	// perform 16-bit SC multiplication with 8-bit multipliers
	sng sng_A_h(.rst(rst), .clk(clk), .a({1'b1, A[22:16]}), .a_sbs(A_h_sbs), .done(done_A_h));
	// sng sng_A_m(.rst(rst), .clk(clk), .a(A[15:08]), .a_sbs(A_m_sbs), .done(done_A_m));

	sng #(.lfsr_seed(1)) sng_B_h(.rst(rst), .clk(clk), .a({1'b1, B[22:16]}), .a_sbs(B_h_sbs), .done(done_B_h));
	// sng sng_B_m(.rst(rst), .clk(clk), .a(B[15:08]), .a_sbs(B_m_sbs), .done(done_B_m));

	assign prod_hi = A_h_sbs & B_h_sbs;
	// assign prod_mid    = A_m_sbs & B_m_sbs;
	// assign prod_hi_mid = A_h_sbs & B_m_sbs;
	// assign prod_mid_hi = A_m_sbs & B_h_sbs;

	always @(posedge clk) begin
		if(~rst) begin
			en <= 1'b1;
			accumulator <= 8'b0;
			counter <= 8'b0;
		end
		if(en && done_all) begin
			if(counter==8'b1111_1111) begin
				en <= 1'b0;
				$display("%d %d %d", accumulator, sng_in_a, sng_in_b);
			end
			else begin
				// $display("%d", counter);
				accumulator <= accumulator + prod_hi[counter];
				counter <= counter+1;
			end
		end
	end
endmodule