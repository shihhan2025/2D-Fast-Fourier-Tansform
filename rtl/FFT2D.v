module FFT2D(
             clk,
             rst_n,
             IN_VALID,
             FFT2D_IN,
             OUT_VALID,
             FFT2D_OUT_R,
             FFT2D_OUT_I
);
input         clk, rst_n, IN_VALID;
input   [7:0] FFT2D_IN;

output reg       OUT_VALID;
output reg [18:0] FFT2D_OUT_R, FFT2D_OUT_I;
//---------------------------------------------------------------------------
//define twiddle factors
parameter real_w0 = 'b011111111;
parameter real_w1 = 'b011111011;
parameter real_w2 = 'b011101100;
parameter real_w3 = 'b011010100;
parameter real_w4 = 'b010110101;		
parameter real_w5 = 'b010001110;		
parameter real_w6 = 'b001100001;		
parameter real_w7 = 'b000110001;		
parameter real_w8 = 'b000000000;		
parameter real_w9 = 'b111001110;		
parameter real_w10 = 'b110011110;		
parameter real_w11 = 'b101110001;		
parameter real_w12 = 'b101001010;		
parameter real_w13 = 'b100101011;		
parameter real_w14 = 'b100010011;		
parameter real_w15 = 'b100000100;		
parameter imag_w0 = 'b000000000;		
parameter imag_w1 = 'b111001110;		
parameter imag_w2 = 'b110011110;		
parameter imag_w3 = 'b101110001;		
parameter imag_w4 = 'b101001010;		
parameter imag_w5 = 'b100101011;		
parameter imag_w6 = 'b100010011;		
parameter imag_w7 = 'b100000100;		
parameter imag_w8 = 'b100000000;		
parameter imag_w9 = 'b100000100;		
parameter imag_w10 = 'b100010011;		
parameter imag_w11 = 'b100101011;		
parameter imag_w12 = 'b101001010;		
parameter imag_w13 = 'b101110001;		
parameter imag_w14 = 'b110011110;		
parameter imag_w15 = 'b111001110;		


parameter s_idle = 0;
parameter s_input = 1;
parameter s_stage1 = 2;
parameter s_stage2 = 3;
parameter s_stage3 = 4;
parameter s_stage4 = 5;
parameter s_stage5 = 6;
parameter s_stage6 = 7;
parameter s_stage7 = 8;
parameter s_stage8 = 9;
parameter s_stage9 = 10;
parameter s_stage10 = 11;
parameter s_out = 12;

reg [3:0] current_state, next_state;
reg [10:0] cnt;
reg [4:0] cnt3;
reg [1:0] cnt2;
reg [4:0] cnt4;
reg WEN;
reg [9:0] A;
reg signed [37:0] D;
wire signed [37:0] Q;
reg signed [17:0] node1_real,node2_real,node1_imag,node2_imag;
reg signed [18:0] real_part,imag_part;
reg signed [8:0] twiddle_real,twiddle_imag;
reg signed [26:0] mul_out1,mul_out2;
reg signed [18:0] add1,add2;
reg [3:0] stage;
reg [4:0] s;

// RTL
RA1SH U1(.Q(Q), .CLK(clk), .CEN(1'b0), .WEN(WEN), .A(A), .D(D), .OEN(1'b0));
//----------------------------------------------------------------------------
// FSM
//----------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		current_state <= s_idle;
	else
		current_state <= next_state;
end

always @(*) begin
	case (current_state)
		s_idle: if (IN_VALID) next_state = s_input;
				  else          next_state = s_idle;
		s_input: if (cnt=='d1023) next_state = s_stage1;
					else             next_state = s_input;
		s_stage1: if (cnt3=='d15 && cnt2=='d3 && cnt=='d31) next_state = s_stage2;
					else                                       next_state = s_stage1;
		s_stage2: if (cnt3=='d7 && cnt4=='d1 && cnt2=='d3 && cnt=='d31) next_state = s_stage3;
					 else                                                 next_state = s_stage2;
		s_stage3: if (cnt3=='d3 && cnt4=='d3 && cnt2=='d3 && cnt=='d31) next_state = s_stage4;
					 else                                                 next_state = s_stage3;
		s_stage4: if (cnt3=='d1 && cnt4=='d7 && cnt2=='d3 && cnt=='d31) next_state = s_stage5;
					 else                                                  next_state = s_stage4;
		s_stage5: if (cnt4=='d15 && cnt2=='d3 && cnt=='d31) next_state = s_stage6;
					 else                                      next_state = s_stage5;
		s_stage6: if (cnt3=='d15 && cnt2=='d3 && cnt=='d31) next_state = s_stage7;
					else                                       next_state = s_stage6;
		s_stage7: if (cnt3=='d7 && cnt4=='d1 && cnt2=='d3 && cnt=='d31) next_state = s_stage8;
					 else                                                  next_state = s_stage7;
		s_stage8: if (cnt3=='d3 && cnt4=='d3 && cnt2=='d3 && cnt=='d31) next_state = s_stage9;
					 else                                                  next_state = s_stage8;
		s_stage9: if (cnt3=='d1 && cnt4=='d7 && cnt2=='d3&& cnt=='d31) next_state = s_stage10;
					 else                                                  next_state = s_stage9;
		s_stage10: if (cnt4=='d15 && cnt2=='d3 && cnt=='d31) next_state = s_out;
					 else                                       next_state = s_stage10;
		s_out: if (cnt=='d1024) next_state = s_idle;
				 else             next_state = s_out;
		default: next_state = current_state;
	endcase
end
// cnt
always @(posedge clk) begin
	case (current_state)
		//s_idle: cnt<='d0;
		s_input: begin 
					if (cnt=='d1023) cnt<='d0;
					else             cnt<=cnt+1;
					cnt3<='d0;
					cnt4<='d0;
					end
		s_stage1,s_stage6: begin 
					if (cnt=='d31 && cnt3=='d15 && cnt2=='d3) cnt<='d0;
					else if (cnt3=='d15 && cnt2=='d3) cnt<=cnt+1;
					if (cnt3=='d15&&cnt2=='d3) cnt3<='d0;
					else if (cnt2=='d3) cnt3<=cnt3 + 'd1;
					cnt4<='d0;
		end			 
		s_stage2,s_stage7: begin 
					if (cnt3=='d7 && cnt4=='d1 && cnt2=='d3&& cnt=='d31) cnt<='d0;
					else if (cnt3=='d7 && cnt4=='d1 && cnt2=='d3) cnt<=cnt+1;
					if (cnt3=='d7&&cnt2=='d3) cnt3<='d0;
					else if (cnt2=='d3) cnt3<=cnt3 + 'd1;
					if(cnt4=='d1 && cnt3=='d7 && cnt2=='d3) cnt4<='d0;
					else if (cnt3=='d7 && cnt2=='d3) cnt4<=cnt4+'d1;
		end	 
		s_stage3,s_stage8: begin 
					if (cnt3=='d3 && cnt4=='d3 && cnt2=='d3 && cnt=='d31) cnt<='d0;
					else if (cnt3=='d3 && cnt4=='d3 && cnt2=='d3) cnt<=cnt+1;
					if (cnt3=='d3&&cnt2=='d3) cnt3<='d0;
					else if (cnt2=='d3) cnt3<=cnt3 + 'd1;
					if(cnt4=='d3 && cnt3=='d3 && cnt2=='d3) cnt4<='d0;
					else if (cnt3=='d3 && cnt2=='d3) cnt4<=cnt4+'d1;
		end			 
		s_stage4,s_stage9: begin 
					if (cnt3=='d1 && cnt4=='d7 && cnt2=='d3 && cnt=='d31) cnt<='d0;
					else if (cnt3=='d1 && cnt4=='d7 && cnt2=='d3) cnt<=cnt+1;
					if (cnt3=='d1&&cnt2=='d3) cnt3<='d0;
					else if (cnt2=='d3) cnt3<=cnt3 + 'd1;
					if(cnt4=='d7 && cnt3=='d1 && cnt2=='d3) cnt4<='d0;
					else if (cnt3=='d1 && cnt2=='d3) cnt4<=cnt4+'d1;
		end			 
		s_stage5,s_stage10: begin 
					if (cnt4=='d15 && cnt2=='d3 && cnt=='d31) cnt<='d0;
					else if (cnt4=='d15 && cnt2=='d3) cnt<=cnt+1;
					cnt3<='d0;
					if(cnt4=='d15 && cnt2=='d3) cnt4<='d0;
					else if (cnt2=='d3) cnt4<=cnt4+'d1;
		end			 
		s_out: begin 
				if (cnt=='d1024) cnt<='d0;	
				else            cnt<=cnt+'d1;
				if(cnt3=='d31) cnt3<='d0;
				else           cnt3<=cnt3+'d1;
				if (cnt4=='d31 && cnt3=='d31) cnt4<='d0;
				else if (cnt3=='d31) cnt4<=cnt4+'d1;
		end
		default: begin cnt<='d0; cnt3<='d0; cnt4<='d0; end
	endcase
end

always @(posedge clk ) begin
	case (current_state)
		s_idle,s_input,s_out: cnt2<='d0;
		default: if (cnt2=='d3) cnt2<='d0;
					else           cnt2<=cnt2+1;
	endcase
end

/*always @(posedge clk) begin
	case (current_state)
		s_stage1,s_stage6: if (cnt3=='d15&&cnt2=='d4) cnt3<='d0;
					 else if (cnt2=='d4) cnt3<=cnt3 + 'd1;
		s_stage2,s_stage7: if (cnt3=='d7&&cnt2=='d4) cnt3<='d0;
					 else if (cnt2=='d4) cnt3<=cnt3 + 'd1;
		s_stage3,s_stage8: if (cnt3=='d3&&cnt2=='d4) cnt3<='d0;
					 else if (cnt2=='d4) cnt3<=cnt3 + 'd1;
		s_stage4,s_stage9: if (cnt3=='d1&&cnt2=='d4) cnt3<='d0;
					 else if (cnt2=='d4) cnt3<=cnt3 + 'd1;
		s_out: if(cnt3=='d31) cnt3<='d0;
				 else           cnt3<=cnt3+'d1;
		default: cnt3<='d0;			 
	endcase
end

always @(posedge clk) begin
	case(current_state)
		s_stage2,s_stage7: if(cnt4=='d1 && cnt3=='d7 && cnt2=='d4) cnt4<='d0;
					 else if (cnt3=='d7 && cnt2=='d4) cnt4<=cnt4+'d1;
		s_stage3,s_stage8: if(cnt4=='d3 && cnt3=='d3 && cnt2=='d4) cnt4<='d0;
					 else if (cnt3=='d3 && cnt2=='d4) cnt4<=cnt4+'d1;
		s_stage4,s_stage9: if(cnt4=='d7 && cnt3=='d1 && cnt2=='d4) cnt4<='d0;
					 else if (cnt3=='d1 && cnt2=='d4) cnt4<=cnt4+'d1;
		s_stage5,s_stage10: if(cnt4=='d15 && cnt2=='d4) cnt4<='d0;
					 else if (cnt2=='d4) cnt4<=cnt4+'d1;
		s_out: if (cnt4=='d31 && cnt3=='d31) cnt4<='d0;
				 else if (cnt3=='d31) cnt4<=cnt4+'d1;
		default: cnt4<='d0;
	endcase
end*/
// RA1SH
always @(*) begin
	if (next_state==s_input)
		WEN = 'd0;
	else if (current_state==s_out)
		WEN = 'd1;
	else if (cnt2 >'d1)
		WEN = 'd0;
	else
		WEN = 'd1;
end

always @(*) begin
	case (current_state)
		s_stage1,s_stage6: s = 'd16;
		s_stage2,s_stage7: s = 'd8;
		s_stage3,s_stage8: s = 'd4;
		s_stage4,s_stage9: s = 'd2;
		s_stage5,s_stage10: s = 'd1;
		default: s = 'd0;
	endcase	
end

always @(*) begin
	if (current_state==s_idle) 
		A = 'd0;
	else if (next_state==s_input)
		A = cnt+'d1;
		
	else if (current_state==s_stage1 || current_state==s_stage2 || current_state==s_stage3 || current_state==s_stage4 || current_state==s_stage5) begin
		case (cnt2)
			1,3: A = cnt3*'d32 + 'd32*s + 'd64*(s)*cnt4 + cnt;
			default: A = cnt3*'d32 + 'd64*(s)*cnt4 + cnt;
		endcase
	end
	else if (current_state==s_stage6 || current_state==s_stage7 || current_state==s_stage8 || current_state==s_stage9 || current_state==s_stage10) begin
		case (cnt2)
			1,3: A = cnt3 + s + 'd2*s*cnt4 + 'd32*cnt;
			default: A = cnt3 + 'd2*s*cnt4 + 'd32*cnt;
		endcase
	end
	else if (current_state==s_out)
		A = 'd32*{cnt4[0],cnt4[1],cnt4[2],cnt4[3],cnt4[4]} + {cnt3[0],cnt3[1],cnt3[2],cnt3[3],cnt3[4]};
	else A = 0;
end

always @(*) begin
	if (next_state==s_input)
		D = {1'b0,FFT2D_IN,29'b0};
	else if (current_state!=s_idle && current_state!=s_out && cnt2>'d1 )
		D = {real_part, imag_part};
	else
		D = 0;
end
// calculate
always @(posedge clk) begin
	if (cnt2=='d1) begin
		node1_real <= Q[37:20];
		node1_imag <= Q[18:1];
	end
end
always @(*) begin
	if (cnt2=='d2) begin
		node2_real = Q[37:20];
		node2_imag = Q[18:1];
	end
	else begin
		node2_real = 0;
		node2_imag = 0;
	end
end
always @(*) begin
	if (cnt2=='d2) begin
		real_part = node1_real + node2_real;
		imag_part = node1_imag + node2_imag;
	end
	else if (cnt2=='d3) begin
		real_part = mul_out1[26:8];
		imag_part = mul_out2[26:8];
	end
	else begin
		real_part = 'd0;
		imag_part = 'd0;
	end
end
always @(posedge clk) begin
	if (cnt2=='d2) begin
		add1 <= (node1_real - node2_real);
		add2 <= (node1_imag - node2_imag);
	end
end
always @(*) begin
	if (cnt2=='d3) begin
		mul_out1 = add1 * twiddle_real - add2 * twiddle_imag;
		mul_out2 = add2 * twiddle_real + add1 * twiddle_imag;
	end
	else begin
		mul_out1 = 'd0;
		mul_out2 = 'd0;
	end
end
// chose twiddle factors
always @(posedge clk) begin
	case(current_state)
		s_idle: stage <= 'd0;
		s_stage1,s_stage6: stage <= 'd1;
		s_stage2,s_stage7: stage <= 'd2;
		s_stage3,s_stage8: stage <= 'd4;
		s_stage4,s_stage9: stage <= 'd8;
		default: stage <= 'd0;
	endcase
end
always @(posedge clk) begin	
	case (cnt3*stage)
		0:  begin twiddle_real = real_w0;  twiddle_imag = imag_w0; end
		1:  begin twiddle_real = real_w1;  twiddle_imag = imag_w1; end
		2:  begin twiddle_real = real_w2;  twiddle_imag = imag_w2; end
		3:  begin twiddle_real = real_w3;  twiddle_imag = imag_w3; end
		4:  begin twiddle_real = real_w4;  twiddle_imag = imag_w4; end
		5:  begin twiddle_real = real_w5;  twiddle_imag = imag_w5; end
		6:  begin twiddle_real = real_w6;  twiddle_imag = imag_w6; end
		7:  begin twiddle_real = real_w7;  twiddle_imag = imag_w7; end
		8:  begin twiddle_real = real_w8;  twiddle_imag = imag_w8; end
		9:  begin twiddle_real = real_w9;  twiddle_imag = imag_w9; end
		10: begin twiddle_real = real_w10; twiddle_imag = imag_w10; end
		11: begin twiddle_real = real_w11; twiddle_imag = imag_w11; end
		12: begin twiddle_real = real_w12; twiddle_imag = imag_w12; end
		13: begin twiddle_real = real_w13; twiddle_imag = imag_w13; end
		14: begin twiddle_real = real_w14; twiddle_imag = imag_w14; end
		15: begin twiddle_real = real_w15; twiddle_imag = imag_w15; end
		default: begin twiddle_real = 'd0; twiddle_imag = 'd0; end
	endcase
end
// out
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		OUT_VALID <= 'd0;
	else if (current_state==s_out && cnt>0)
		OUT_VALID <= 'd1;
	else
		OUT_VALID <= 'd0;	
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		FFT2D_OUT_I <= 'd0;
	else if (current_state==s_out && cnt>0)
		FFT2D_OUT_I <= Q[18:0];
	else
		FFT2D_OUT_I <= 'd0;
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		FFT2D_OUT_R <= 'd0;
	else if (current_state==s_out && cnt>0)
		FFT2D_OUT_R <= Q[37:19];
	else
		FFT2D_OUT_R <= 'd0;
end

endmodule

