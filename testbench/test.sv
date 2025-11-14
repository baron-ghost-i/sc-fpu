`timescale 1ns/1ps

module sc_test();
	reg [7:0] a = 8'd224;
	reg [7:0] b = 8'd239;
	reg [7:0] c = 8'd000;
	reg a_sc=0, b_sc=0;
	wire c_sc;
	reg [7:0] i = 0;

	reg [7:0] lfsr1 = 8'd1;
	reg [7:0] lfsr2 = 8'd244;

	reg clk;

	initial begin
		clk = 0;
		forever begin
			#0.5 clk = ~clk;
		end
	end

	initial begin
		forever begin
			#1 i=i+1;
		end
	end

	initial begin
		#256
		$display("%f\t%f\t%f\t%f", a/255.0, b/255.0, (a/255.0)*(b/255.0), c/255.0);
		$display("%d\t%d\t%d\tError: %f%%", a, b, c, (((a/255.0)*(b/255.0))-(c/255.0))*100/(((a/255.0)*(b/255.0))));
		$finish;
	end

	assign c_sc = a_sc & b_sc;

	always @(posedge clk) begin
		$display("%d\t%d\t%d\t%b\t%b\t%b", i, lfsr1, lfsr2, a_sc, b_sc, c_sc);
		lfsr1 <= {lfsr1[14:0], lfsr1[7]^lfsr1[3]^lfsr1[2]^lfsr1[1]};
		// lfsr2 <= {lfsr2[6:0], lfsr2[7]^lfsr2[5]^lfsr2[4]^lfsr2[3]};
		lfsr2 <= {lfsr2[14:0], lfsr2[7]^lfsr2[4]^lfsr2[2]^lfsr2[0]};
		a_sc <= (a>lfsr1)?1:0;
		b_sc <= (b>lfsr2)?1:0;
		c <= c+c_sc;
	end


endmodule