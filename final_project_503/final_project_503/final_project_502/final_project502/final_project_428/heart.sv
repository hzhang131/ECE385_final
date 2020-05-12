module heartRom(
					 input [8:0] read_address,
					 input Clk,
					 output [11:0] data_Out

					);
					
logic [11:0] mem [0:399];

initial

begin

	 $readmemh("heart.txt", mem);

end

always_ff @ (posedge Clk) begin


	data_Out<= mem[read_address];
	

end



endmodule

module heart_mapper(
							input Clk,
							input heart_enable,
							input [9:0] DrawX, DrawY,
							input [5:0] remaining_hearts,
							input [5:0] remaining_hearts_en,
							output is_heart,
							output [11:0] code
						 );

logic [8:0] read_address;
logic	[11:0] data_Out;					 
heartRom hr(.*);	
int DistX1, DistX2, DistX3, DistX4, DistX5;
int DistY, DistY1;			 
always_comb
begin
	is_heart = 1'b0;
	code = 12'h000;
	read_address = 9'd0;
	DistX1 = DrawX - 10'd510;
	DistX2 = DrawX - 10'd530;
	DistX3 = DrawX - 10'd550;
	DistX4 = DrawX - 10'd570;
	DistX5 = DrawX - 10'd590;
	DistY = DrawY - 10'd220;
	DistY1 = DrawY - 10'd260;
	if (DrawX >= 10'd510 && DrawX < 10'd530 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd1 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY * 20 + DistX1;
			code = data_Out;
		end
	if (DrawX >= 10'd530 && DrawX < 10'd550 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd2 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY * 20 + DistX2;
			code = data_Out;
		end
	if (DrawX >= 10'd550 && DrawX < 10'd570 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd3 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY * 20 + DistX3;
			code = data_Out;
		end
	if (DrawX >= 10'd570 && DrawX < 10'd590 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd4 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY * 20 + DistX4;
			code = data_Out;
		end
	if (DrawX >= 10'd590 && DrawX < 10'd610 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd5 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY * 20 + DistX5;
			code = data_Out;
		end
		
	if (DrawX >= 10'd510 && DrawX < 10'd530 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd1 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX1;
			code = data_Out;
		end
	if (DrawX >= 10'd530 && DrawX < 10'd550 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd2 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX2;
			code = data_Out;
		end
	if (DrawX >= 10'd550 && DrawX < 10'd570 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd3 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX3;
			code = data_Out;
		end
	if (DrawX >= 10'd570 && DrawX < 10'd590 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd4 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX4;
			code = data_Out;
		end
	if (DrawX >= 10'd590 && DrawX < 10'd610 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd5 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX5;
			code = data_Out;
		end
end
endmodule 


module heart_mapper1(
							input Clk,
							input heart_enable, enable12,
							input [9:0] DrawX, DrawY,
							input [5:0] remaining_hearts,
							input [5:0] remaining_hearts_en,
							input [5:0] remaining_hearts_en2,
							output is_heart,
							output [11:0] code
						 );

logic [8:0] read_address;
logic	[11:0] data_Out;					 
heartRom hr(.*);	
int DistX1, DistX2, DistX3, DistX4, DistX5;
int DistY, DistY1, DistY2;			 
always_comb
begin
	is_heart = 1'b0;
	code = 12'h000;
	read_address = 9'd0;
	DistX1 = DrawX - 10'd510;
	DistX2 = DrawX - 10'd530;
	DistX3 = DrawX - 10'd550;
	DistX4 = DrawX - 10'd570;
	DistX5 = DrawX - 10'd590;
	DistY = DrawY - 10'd220;
	DistY1 = DrawY - 10'd260;
	DistY2 = DrawY - 10'd290;
	if (DrawX >= 10'd510 && DrawX < 10'd530 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd1 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY * 20 + DistX1;
			code = data_Out;
		end
	if (DrawX >= 10'd530 && DrawX < 10'd550 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd2 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY * 20 + DistX2;
			code = data_Out;
		end
	if (DrawX >= 10'd550 && DrawX < 10'd570 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd3 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY * 20 + DistX3;
			code = data_Out;
		end
	if (DrawX >= 10'd570 && DrawX < 10'd590 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd4 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY * 20 + DistX4;
			code = data_Out;
		end
	if (DrawX >= 10'd590 && DrawX < 10'd610 && DrawY >= 10'd220 && DrawY < 10'd240)
		begin
		if (remaining_hearts >= 6'd5 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY * 20 + DistX5;
			code = data_Out;
		end
		
	if (DrawX >= 10'd510 && DrawX < 10'd530 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd1 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX1;
			code = data_Out;
		end
	if (DrawX >= 10'd530 && DrawX < 10'd550 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd2 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX2;
			code = data_Out;
		end
	if (DrawX >= 10'd550 && DrawX < 10'd570 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd3 && heart_enable)
			is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX3;
			code = data_Out;
		end
	if (DrawX >= 10'd570 && DrawX < 10'd590 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd4 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX4;
			code = data_Out;
		end
	if (DrawX >= 10'd590 && DrawX < 10'd610 && DrawY >= 10'd260 && DrawY < 10'd280)
		begin
		if (remaining_hearts_en >= 6'd5 && heart_enable)
		   is_heart = 1'b1;
			read_address = DistY1 * 20 + DistX5;
			code = data_Out;
		end
		
	if (DrawX >= 10'd510 && DrawX < 10'd530 && DrawY >= 10'd290 && DrawY < 10'd310)
		begin
		if (remaining_hearts_en2 >= 6'd1 && enable12)
			is_heart = 1'b1;
			read_address = DistY2 * 20 + DistX1;
			code = data_Out;
		end
	if (DrawX >= 10'd530 && DrawX < 10'd550 && DrawY >= 10'd290 && DrawY < 10'd310)
		begin
		if (remaining_hearts_en2 >= 6'd2 && enable12)
			is_heart = 1'b1;
			read_address = DistY2 * 20 + DistX2;
			code = data_Out;
		end
	if (DrawX >= 10'd550 && DrawX < 10'd570 && DrawY >= 10'd290 && DrawY < 10'd310)
		begin
		if (remaining_hearts_en2 >= 6'd3 && enable12)
			is_heart = 1'b1;
			read_address = DistY2 * 20 + DistX3;
			code = data_Out;
		end
	if (DrawX >= 10'd570 && DrawX < 10'd590 && DrawY >= 10'd290 && DrawY < 10'd310)
		begin
		if (remaining_hearts_en2 >= 6'd4 && enable12)
		   is_heart = 1'b1;
			read_address = DistY2 * 20 + DistX4;
			code = data_Out;
		end
	if (DrawX >= 10'd590 && DrawX < 10'd610 && DrawY >= 10'd290 && DrawY < 10'd310)
		begin
		if (remaining_hearts_en2 >= 6'd5 && enable12)
		   is_heart = 1'b1;
			read_address = DistY2 * 20 + DistX5;
			code = data_Out;
		end
end
endmodule 