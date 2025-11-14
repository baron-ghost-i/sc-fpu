`timescale 1ns/1ps

module multiplier_tb();
	reg [7:0] a = 8'd192, b = 8'd227;
	wire [7:0] x, l1, l2;
	reg clk = 1'b1;
	reg rst = 1'b1;
	wire done;

	multiplier dut(.a(a), .b(b), .x(x), .clk(clk), .rst(rst), .done(done), .lfsr1_dbg(l1), .lfsr2_dbg(l2));

	initial begin
		forever #0.5 clk = ~clk;
	end

	// always @(posedge clk) begin
	// 	$display("lfsr1: %d lfsr2: %d", l1, l2);
	// end

	initial begin
		#1 rst = 1'b0;
		#1 rst = 1'b1;
		wait(done);
		$display("%f\t%f\t%f\t%f", a/255.0, b/255.0, (a/255.0)*(b/255.0), x/255.0);
		$display("%d\t%d\t%d\tError: %f%%", a, b, x, (((a/255.0)*(b/255.0))-(x/255.0))*100/(((a/255.0)*(b/255.0))));
		$finish;
	end

endmodule