`timescale 1ns/1ps

module sng_tb();
	reg [7:0] a = 8'd77;
	wire [254:0] a_sbs;
	reg clk = 1'b1;
	reg rst = 1'b1;
	wire done;
	integer one_count = 0;

	sng #(.gen_type(0)) dut(.a(a), .a_sbs(a_sbs), .clk(clk), .rst(rst), .done(done));

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
		$display("a: %d\ta_sbs: %b", a, a_sbs);
		for(integer i=0; i<255; i=i+1) begin
			one_count = one_count + a_sbs[i];
		end
		$display("Number of 1s: %d", one_count);
		$finish;
	end

endmodule