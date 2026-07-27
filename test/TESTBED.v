
`timescale 1ns/10ps

`include "PATTERN.v"
`ifdef RTL
  `include "FFT2D.v"
`endif

module TESTBED;

wire        clk, rst_n, IN_VALID;
wire  [7:0] FFT2D_IN;

wire        OUT_VALID;
wire [18:0] FFT2D_OUT_R, FFT2D_OUT_I;


initial begin
  `ifdef RTL
    $fsdbDumpfile("FFT2D.fsdb");
    $fsdbDumpvars(0,"+mda");
  `endif
end

FFT2D u_FFT2D(
    .clk(clk),
    .rst_n(rst_n),
    .IN_VALID(IN_VALID),
    .FFT2D_IN(FFT2D_IN),
    .OUT_VALID(OUT_VALID),
    .FFT2D_OUT_R(FFT2D_OUT_R),
    .FFT2D_OUT_I(FFT2D_OUT_I)
    );
	
PATTERN u_PATTERN(
    .clk(clk),
    .rst_n(rst_n),
    .IN_VALID(IN_VALID),
    .FFT2D_IN(FFT2D_IN),
    .OUT_VALID(OUT_VALID),
    .FFT2D_OUT_R(FFT2D_OUT_R),
    .FFT2D_OUT_I(FFT2D_OUT_I)
    );
  
 
endmodule
