module palette (
               input logic [11:0] RGB_12,
               output logic [7:0] R, G, B,
					input logic [9:0] DrawX
               );
					
logic [23:0] out;
assign R = out[23:16];
assign G = out[15:8];
assign B = out[7:0];

always_comb
    begin
        unique case (RGB_12)
             12'h000:  out = 24'h3f007f - DrawX[9:3];
             12'hb40:  out = 24'hb04000;
             12'hfff:  out = 24'hf0f0f0;
				 12'h222:  out = 24'h3f007f - DrawX[9:3];
				 12'h6af:  out = 24'h60a0f0;
				 12'h603:  out = 24'h3f007f - DrawX[9:3];
				 12'hee9:  out = 24'he0e090;
				 12'hb27:  out = 24'hb02070;
				 12'h16d:  out = 24'h1060d0;
				 12'hf87:  out = 24'hf08070;
				 12'h666:  out = 24'h606060;
				 12'hbbb:  out = 24'hb0b0b0;
				 12'hc7f:  out = 24'hc070f0;
				 12'h4cd:  out = 24'h40c0d0;
				 12'h8d0:  out = 24'h80d000;
				 12'h380:  out = 24'h308000;
				 12'h916:  out = 24'h901060;
				 12'hd29:  out = 24'hd02090;
				 12'h72f:  out = 24'h7020f0;
				 12'h660:  out = 24'h606000;
				 12'hbb0:  out = 24'hb0b000;
				 12'h5ef:  out = 24'h50e0f0;
				 12'hfa9:  out = 24'hf0a090;
				 12'hf76:  out = 24'hf07060;
				 12'h777:  out = 24'h707070;
				 12'h555:  out = 24'h505050;
				 12'h999:  out = 24'h909090;
				 12'hf00:  out = 24'hf00000;
				 12'hd00:  out = 24'hd00000;    //new color in the choose enemy background
				 12'h900:  out = 24'h900000;    //new color in the choose enemy background
				 12'hccc:  out = 24'hc0c0c0;
				 12'he42:  out = 24'he84a27;
				 12'h124:  out = 24'h13294b;
				 12'hfe3:  out = 24'hf0e030;    //new color in the choose enemy background
				 12'h110:  out = 24'hf0e030;    //new color in the choose enemy background
				 12'h0af:  out = 24'h00a0f0;    //new color in the choose enemy background
				 12'h011:  out = 24'h3f007f - DrawX[9:3];    //new color in the choose enemy background
				 12'hc22:  out = 24'hc02020;    //new color in the choose enemy background
				 default:  out = 24'h000000;    //new color in the choose enemy background		
        endcase
    end

endmodule