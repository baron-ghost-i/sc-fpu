`timescale 1ns/1ps

module multiplier_tb();
	function logic [31:0] shortrealtobits;
		input shortreal r;
		logic sign;
		integer iexp;
		logic [7:0] exp;
		logic [22:0] frac;
		shortreal temp, ffrac;
		sign = 1 ? r < 0 : 0;
		temp = sign ? -1*r : r;
		iexp  = $floor($ln(temp) / $ln(2));
		ffrac = temp / $pow(2, iexp);
		ffrac = ffrac - 1;
		frac = ffrac * 8388608.0;
		exp = 127 + iexp;
		shortrealtobits = {sign, exp, frac};
	endfunction

	reg [31:0] a = shortrealtobits(256.01); //32'b0_10000001_10100000000000000000000;
	reg [31:0] b = shortrealtobits(16.01);
	wire [31:0] x;
	reg clk = 1'b1;
	reg rst = 1'b1;
	wire done;

	shortreal a_r, b_r, x_r;

	multiplier dut(.A(a), .B(b), .P(x), .clk(clk), .rst(rst), .done(done));

	initial begin
		forever #0.5 clk = ~clk;
	end

	always @(*) begin
		a_r = (-1.0**a[31])*(2.0**(a[30:23]-127))*(1+(a[22:0]/(2.0**23)));
		b_r = (-1.0**b[31])*(2.0**(b[30:23]-127))*(1+(b[22:0]/(2.0**23)));
		x_r = (-1.0**x[31])*(2.0**(x[30:23]-127))*(1+(x[22:0]/(2.0**23)));
	end

	initial begin
		@(posedge clk) rst = 1'b0;
		@(posedge clk) rst = 1'b1;
		wait(done);
		
		$display("a: %b_%b_%b\nb: %b_%b_%b\np: %b_%b_%b", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], x[31], x[30:23], x[22:0]);
		$display("a: %f\nb: %f\np_sc: %f\np_ac: %f\nerror: %f%%", a_r, b_r, x_r, (a_r*b_r), (x_r - a_r*b_r)/(a_r*b_r)*100);
		// $display("%f\t%f\t%f\t%f", a/255.0, b/255.0, (a/255.0)*(b/255.0), x/255.0);
		// $display("%d\t%d\t%d\tError: %f%%", a, b, x, (((a/255.0)*(b/255.0))-(x/255.0))*100/(((a/255.0)*(b/255.0))));
		$finish;
	end

endmodule