module slide_intf(clk, rst_n, cnt, cnv_cmplt, res, strt_cnv,
POT_LP, POT_B1, POT_B2, POT_B3, POT_HP, VOLUME);

input clk, rst_n, cnv_cmplt;
input [11:0] res;

output reg [11:0] POT_LP, POT_B1, POT_B2, POT_B3, POT_HP, VOLUME;
output reg [2:0] cnt;
output reg strt_cnv;

reg state, nxtstate;
wire [11:0] res;

localparam IDLE = 1'b0;
localparam CNV = 1'b1;

//Potentiometer outputs
always @(posedge clk) begin
 if(cnt==3'b000 & cnv_cmplt)
  POT_LP <= res;
 else
  POT_LP <= POT_LP;
end

always @(posedge clk) begin
 if(cnt==3'b001 & cnv_cmplt)
  POT_B1 <= res;
 else
  POT_B1 <= POT_B1;
end

always @(posedge clk) begin
 if(cnt==3'b010 & cnv_cmplt)
  POT_B2 <= res;
 else
  POT_B2 <= POT_B2;
end

always @(posedge clk) begin
 if(cnt==3'b011 & cnv_cmplt)
  POT_B3 <= res;
 else
  POT_B3 <= POT_B3;
end

always @(posedge clk) begin
 if(cnt==3'b100 & cnv_cmplt)
  POT_HP <= res;
 else
  POT_HP <= POT_HP;
end

always @(posedge clk) begin
 if(cnt==3'b111 & cnv_cmplt)
  VOLUME <= res;
 else
  VOLUME <= VOLUME;
end

//Next state logic
always_ff @(posedge clk, negedge rst_n)
 if(!rst_n)
  state <= IDLE;
 else
  state <= nxtstate;

//Implement cnt
always_ff @(posedge clk, negedge rst_n)
 if(!rst_n)
  cnt <= 3'b000;
  
//Implement state machine
always @(*) begin
	nxtstate = IDLE;
	strt_cnv = 1'b0;
	case(state)
		IDLE:  begin
			strt_cnv = 1'b1;
			nxtstate = CNV;	
			if(cnt == 3'b100)
				cnt = 3'b111;
		    else
				cnt = cnt + 1;		
		end
		CNV: if(!cnv_cmplt) begin
			nxtstate = CNV;			
		end else begin
			strt_cnv = 1'b0;
			nxtstate = IDLE;			
		
		end
		default : begin
			strt_cnv = 1'b1;
			nxtstate = CNV;
		end
	endcase
end
endmodule