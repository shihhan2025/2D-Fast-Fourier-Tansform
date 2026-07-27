
`define CYCLE_TIME 4.6

module PATTERN(
                clk,
                rst_n,
                IN_VALID,
                FFT2D_IN,
                OUT_VALID,
                FFT2D_OUT_R,
                FFT2D_OUT_I
);
output reg clk, rst_n, IN_VALID;
output reg [7:0] FFT2D_IN;

input        OUT_VALID;
input  [18:0] FFT2D_OUT_R, FFT2D_OUT_I;

//================================================================
//   PARAMETER
//================================================================
real CYCLE = `CYCLE_TIME;
integer x,lat,total_latency,patcount,file_input,file_output_real,file_output_imag,i,k;
parameter PATNUM = 10;
integer SEED = 23;
//================================================================
// wire & registers 
//================================================================
//================================================================
// clock
//================================================================
initial 
begin
	clk = 0;
end
always #(CYCLE/2.0) clk = ~clk;
//================================================================
// initial
//================================================================
initial 
begin
	file_input = $fopen("../00_TESTBED/inputs.txt", "r");
	file_output_real = $fopen("../00_TESTBED/output_real.txt", "w");
	file_output_imag = $fopen("../00_TESTBED/output_imag.txt", "w");
	if ((file_input == 0) || (file_output_real == 0) || (file_output_imag == 0)) begin
		$display ("Error in opening the files");
		$finish;
	end	
	
	rst_n = 1'b1;
	IN_VALID = 1'b0;
	FFT2D_IN = 'dx;
	force clk = 0;
 	total_latency = 0;
 	
	reset_signal_task;
	repeat(2)@(negedge clk);
	for(patcount=1; patcount<=PATNUM; patcount=patcount+1) 
	begin
		input_task;
		wait_OUT_VALID;
		check_ans;
	end
	
  	YOU_PASS_task;
	$fclose(file_input);
	$fclose(file_output_real);
	$fclose(file_output_imag);
end
//================================================================
// task
//================================================================
task reset_signal_task;	
begin
	#(0.5);	rst_n=0;
	#(CYCLE/2.0);
	if((OUT_VALID !== 'd0)||(FFT2D_OUT_R !== 'd0||(FFT2D_OUT_I !== 'd0))) begin
		$display("************************************************************");
		$display("*     		SPEC 4 IS \033[0;31mFail\033[m                       *");
		$display("*Output signal should be 0 after initial RESET at %t    *",$time);
		$display("************************************************************");
		$finish;
	end
	#(10);  rst_n=1;
	#(4);  release clk;
end 
endtask
task input_task; begin
	IN_VALID = 1;
	for(i=0;i<1024;i=i+1)begin
		k = $fscanf(file_input, "%d\n", FFT2D_IN);
		@(negedge clk);
	end
	IN_VALID = 0;
	FFT2D_IN = 'dx;
end endtask
task wait_OUT_VALID; begin
  lat = -1;
  while(!OUT_VALID) begin
	lat = lat + 1;
	if(lat == 100000) begin
		$display("***************************************************************");
		$display("*                      SPEC 6 IS \033[0;31mFail\033[m                          *");
		$display("*         The execution latency are over 100000 cycles.           *");
		$display("***************************************************************");
		repeat(2)@(negedge clk);
		$finish;
	end
	@(negedge clk);
  end
  total_latency = total_latency + lat;
end endtask
task check_ans; begin
	x=0;
	while(OUT_VALID)
	begin
		$fwrite(file_output_imag, "%d\n",$signed(FFT2D_OUT_I));
		$fwrite(file_output_real, "%d\n",$signed(FFT2D_OUT_R));
		if(x>=1024)
			begin
			$display ("----------------------------------------------------------------------------------------");
			$display ("                                         \033[0;31mFail\033[m                                    ");
			$display ("                           Outvalid should be raised for only 1024 cycle 		   ");
			$display ("----------------------------------------------------------------------------------------");
			repeat(2) @(negedge clk);
			$finish;
			end		
		@(negedge clk);	
		x=x+1;
	end	
	if(x<1024) begin
			$display ("---------------------------------------------------------------------------------------------------");
			$display ("                         \033[0;31mFail\033[m                                                               ");
			$display ("                Outvalid is less than 1024 cycles                                                   ");
			$display ("---------------------------------------------------------------------------------------------------");
			repeat(2) @(negedge clk);
			$finish;
	end
	$display("\033[0;36mPass Pattern No.%4d,\033[m \033[0;33mExecution cycle : %3d\033[m",patcount ,lat);
end endtask
task YOU_PASS_task;begin
	  $display ("-------------------------------------------------------------------");
	  $display ("                         Congratulations!                          ");
	  $display ("                  You have passed all patterns!                    ");
	  $display ("                 Your execution cycles = %5d cycles                ", total_latency);
	  $display ("                    Your clock period = %.1f ns                    ", CYCLE);
	  $display ("                    Your total latency = %.1f ns                   ", total_latency*CYCLE);
	  $display ("-------------------------------------------------------------------");    
	  $finish;
end endtask
endmodule

