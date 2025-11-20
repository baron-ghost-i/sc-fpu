`timescale 1ns/1ps

module multiplier_tb();
	reg [31:0] a = 32'b0_10000001_10100000000000000000000;
	reg [31:0] b = 32'b0_10000011_10100000000000000000000;
	wire [31:0] x;//, l1, l2;
	reg clk = 1'b1;
	reg rst = 1'b1;
	wire done;

	multiplier dut(.A(a), .B(b), .P(x), .clk(clk), .rst(rst), .done(done));

	initial begin
		forever #0.5 clk = ~clk;
	end

	// always @(posedge clk) begin
	// 	$display("lfsr1: %d lfsr2: %d", l1, l2);
	// end

	initial begin
		@(posedge clk) rst = 1'b0;
		@(posedge clk) rst = 1'b1;
		wait(done);
		$display("a: %b_%b_%b\nb: %b_%b_%b\np: %b_%b_%b", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], x[31], x[30:23], x[22:0]);
		// $display("%f\t%f\t%f\t%f", a/255.0, b/255.0, (a/255.0)*(b/255.0), x/255.0);
		// $display("%d\t%d\t%d\tError: %f%%", a, b, x, (((a/255.0)*(b/255.0))-(x/255.0))*100/(((a/255.0)*(b/255.0))));
		$finish;
	end

endmodule