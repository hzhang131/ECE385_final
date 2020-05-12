module enemy1 (input Clk, Reset, frame_clk, 
					input [9:0] DrawX, DrawY, 
					input [9:0] playerX, playerY, 
					input enable1, enable12,
					input [9:0] Enemy2_X_Pos_out, Enemy2_Y_Pos_out,
 					output [9:0] Right_mid_X_en1, Right_mid_Y_en1, Up_mid_X_en1, Up_mid_Y_en1, Left_mid_X_en1, Left_mid_Y_en1, Down_mid_X_en1, Down_mid_Y_en1,
					output [9:0] Enemy1_X_Pos_out, Enemy1_Y_Pos_out,
					output [19:0] Enemy1_DisX, Enemy1_DisY,
					output is_enemy1, 
					output [1:0] is_enemy1_out,
					output [9:0] Bullet_X_Pos, Bullet_Y_Pos, 
					output is_bullet, is_boom,
					output [19:0] Dist_X_boom_en1, Dist_Y_boom_en1,
					output player_hit
				  );

parameter [9:0] Enemy_X_Start = 10'd458;  // Center position on the X axis
parameter [9:0] Enemy_Y_Start = 10'd23;  // Center position on the Y axis
parameter [9:0] Enemy_X_Min = 10'd2;       // Leftmost point on the X axis
parameter [9:0] Enemy_X_Max = 10'd476;     // Rightmost point on the X axis
parameter [9:0] Enemy_Y_Min = 10'd22;       // Topmost point on the Y axis
parameter [9:0] Enemy_Y_Max = 10'd478;     // Bottommost point on the Y axis
parameter [9:0] Enemy_X_Step = 10'd1;      // Step size on the X axis
parameter [9:0] Enemy_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Enemy_Size = 10'd19;        // Enemy size
	
// temporary code... Will be modified...
logic [9:0] Enemy1_X_Pos, Enemy1_Y_Pos;
logic [9:0] Enemy1_X_Motion, Enemy1_Y_Motion;
logic [9:0] Enemy1_X_Pos_in, Enemy1_X_Motion_in, Enemy1_Y_Pos_in, Enemy1_Y_Motion_in;

logic [1:0] is_enemy1_in, is_bullet_out_en1;
logic [25:0] counter, counter_in;
logic stop_enemy_right, stop_enemy_up, stop_enemy_left, stop_enemy_down;
//logic stop_enemy_hit_right, stop_enemy_hit_up, stop_enemy_hit_left, stop_enemy_hit_down;
logic stop_bullet;
logic draw_boom, draw_bullet;

enemy_wall enw1(.enemyX(Enemy1_X_Pos), .enemyY(Enemy1_Y_Pos), .enable(enable1), .enable_other(enable12), .otherX(Enemy2_X_Pos_out), .otherY(Enemy2_Y_Pos_out), .*);
enemy_bullets enb1(.is_enemy_in(is_enemy1_out), .Clk, .frame_clk, .Reset,
						 .DrawX, .DrawY,
				       .Right_mid_X(Right_mid_X_en1), .Right_mid_Y(Right_mid_Y_en1),
						 .Up_mid_X(Up_mid_X_en1), .Up_mid_Y(Up_mid_Y_en1),
						 .Left_mid_X(Left_mid_X_en1), .Left_mid_Y(Left_mid_Y_en1),
						 .Down_mid_X(Down_mid_X_en1), .Down_mid_Y(Right_mid_Y_en1),
						 .Bullet_X_Pos, .Bullet_Y_Pos, .is_bullet, .is_boom, .is_bullet_out(is_bullet_out_en1),
						 .Dist_X_boom(Dist_X_boom_en1), .Dist_Y_boom(Dist_Y_boom_en1), .stop_bullet,
						 .enable(enable1), .draw_boom, .draw_bullet);

 //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Enemy1_X_Pos <= Enemy_X_Start;
            Enemy1_Y_Pos <= Enemy_Y_Start;
            Enemy1_X_Motion <= 10'd0;
            Enemy1_Y_Motion <= 10'd0;
				is_enemy1_out <= 2'b10; //00 Right, 01 up, 10 left, 11 down
//				counter <= 10'd0;
        end
        else
        begin
            Enemy1_X_Pos <= Enemy1_X_Pos_in;
            Enemy1_Y_Pos <= Enemy1_Y_Pos_in;
            Enemy1_X_Motion <= Enemy1_X_Motion_in;
            Enemy1_Y_Motion <= Enemy1_Y_Motion_in;
				is_enemy1_out <= is_enemy1_in;
//				counter <= counter_in;
        end
    end

always_comb
begin
	Enemy1_X_Pos_in = Enemy1_X_Pos;
	Enemy1_Y_Pos_in = Enemy1_Y_Pos; 
	Enemy1_X_Motion_in = 10'b0;
	Enemy1_Y_Motion_in = 10'b0;
	is_enemy1_in = is_enemy1_out;
	if (frame_clk_rising_edge )
	begin
		if (idx == 3'b000)
				begin
							Enemy1_Y_Motion_in = 10'b0;  // 2's complement.  
							Enemy1_X_Motion_in = 10'b0;
							
							if (playerX + 2 >= Enemy1_X_Pos && playerX - 2 <= Enemy1_X_Pos)
							begin
								if (playerY > Enemy1_Y_Pos)
									is_enemy1_in = 2'b11; // Down.
								else if (playerY < Enemy1_Y_Pos)
									is_enemy1_in = 2'b01;
							end
							
							if (playerY + 2 >= Enemy1_Y_Pos && playerY - 2 <= Enemy1_Y_Pos)
							begin
								if (playerX > Enemy1_X_Pos)
									is_enemy1_in = 2'b00; // Right.
								else if (playerX < Enemy1_X_Pos)
									is_enemy1_in = 2'b10; // Left.
							end
				end
				else if( idx == 3'b010 )  // W (Up) Code 2'b01
				begin
					is_enemy1_in = 2'b01;
					if (Enemy1_Y_Pos > Enemy_Y_Min)
					begin
						Enemy1_Y_Motion_in = (~(Enemy_Y_Step) + 1'b1);  // 2's complement.  
						Enemy1_X_Motion_in = 10'b0;
					end
					else
					begin
						Enemy1_Y_Motion_in = 10'b0;  // 2's complement.  
						Enemy1_X_Motion_in = 10'b0;
					end
				end
            else if ( idx == 3'b100 )
				begin 														// S (Down) Code 2'b11
					is_enemy1_in = 2'b11;
					if (Enemy1_Y_Pos + Enemy_Size < Enemy_Y_Max )
					begin
						Enemy1_Y_Motion_in = Enemy_Y_Step;
						Enemy1_X_Motion_in = 10'b0;
					end 
					else 
					begin
						Enemy1_Y_Motion_in = 10'b0;  // 2's complement.  
						Enemy1_X_Motion_in = 10'b0;
					end
				end
				else if( idx == 3'b011 )  // A (Left) Code 2'b10
				begin
					is_enemy1_in = 2'b10;
					if (Enemy1_X_Pos > Enemy_X_Min)
					begin
						Enemy1_X_Motion_in = (~(Enemy_X_Step) + 1'b1);  // 2's complement.
						Enemy1_Y_Motion_in = 10'b0;
					end
					else 
					begin
						Enemy1_Y_Motion_in = 10'b0;  // 2's complement.  
						Enemy1_X_Motion_in = 10'b0;
					end
				end
            else if ( idx == 3'b001 )  // D (Right) Code 2'b00;
				begin
					is_enemy1_in = 2'b00;
					if (Enemy1_X_Pos + Enemy_Size < Enemy_X_Max)
						begin
							Enemy1_X_Motion_in = Enemy_X_Step;
							Enemy1_Y_Motion_in = 10'b0;
						end
					else
						begin
							Enemy1_Y_Motion_in = 10'b0;  // 2's complement.  
							Enemy1_X_Motion_in = 10'b0;
						end
				end
	end
	Enemy1_X_Pos_in = Enemy1_X_Pos + Enemy1_X_Motion;
	Enemy1_Y_Pos_in = Enemy1_Y_Pos + Enemy1_Y_Motion;
end

//logic all_off, w_on, s_on, a_on, d_on;
//logic all_off_in, w_on_in, s_on_in, a_on_in, d_on_in;
logic [2:0] idx, idx_in;
// Extended for multiplication.
logic [19:0] Exp_ext, Eyp_ext, px_ext, py_ext;
assign Exp_ext[19:10] = {10{1'b0}};
assign Exp_ext[9:0] = Enemy1_X_Pos;
assign Eyp_ext[19:10] = {10{1'b0}};
assign Eyp_ext[9:0] = Enemy1_Y_Pos;
assign px_ext[19:10] = {10{1'b0}};
assign px_ext[9:0] = playerX;
assign py_ext[19:10] = {10{1'b0}};
assign py_ext[9:0] = playerY;
int res_right, res_up, res_left, res_down; 

//res_right distance from enemy to player if were to go right.
always_comb
begin
	res_right = (Exp_ext + 20'd2 - px_ext) * (Exp_ext + 20'd2 - px_ext) + (Eyp_ext - py_ext) * (Eyp_ext - py_ext);
	res_up = (Exp_ext - px_ext) * (Exp_ext - px_ext) + (Eyp_ext - 20'd2 - py_ext) * (Eyp_ext - 20'd2 - py_ext);
	res_left = (Exp_ext - 20'd2 - px_ext) * (Exp_ext - 20'd2 - px_ext) + (Eyp_ext - py_ext) * (Eyp_ext - py_ext);
	res_down = (Exp_ext - px_ext) * (Exp_ext - px_ext) + (Eyp_ext + 20'd2 - py_ext) * (Eyp_ext + 20'd2 - py_ext);
	if (stop_enemy_right == 1'b1 || Enemy1_X_Pos >= Enemy_X_Max)
		res_right = 20'b11111111111111111111;
	if (stop_enemy_up == 1'b1 || Enemy1_Y_Pos <= Enemy_Y_Min)
		res_up = 20'b11111111111111111111;
	if (stop_enemy_left == 1'b1 || Enemy1_X_Pos <= Enemy_X_Min)
		res_left = 20'b11111111111111111111;
	if (stop_enemy_down == 1'b1 || Enemy1_Y_Pos >= Enemy_Y_Max)
		res_down = 20'b11111111111111111111;
end
always_comb 
begin
	// If the shortest distance between enemy and hometank is less than 90, stop moving.
	idx_in = idx;
	if (res_right < 20'd900 || res_up < 20'd900 || res_left < 20'd900 || res_down < 20'd900)
		begin
		if (playerX + 2 >= Enemy1_X_Pos && playerX - 2 <= Enemy1_X_Pos || playerY + 2 >= Enemy1_Y_Pos && playerY - 2 <= Enemy1_Y_Pos)
			idx_in = 3'b000;
		end
//   if (playerX + 5 >= Enemy1_X_Pos && playerX - 5 <= Enemy1_X_Pos && playerY + Enemy_Size >= Enemy1_Y_Pos && playerY - Enemy_Size <= Enemy1_Y_Pos)
//		idx_in = 3'b000;
//	else if (playerY + 5 >= Enemy1_Y_Pos && playerY - 5 <= Enemy1_Y_Pos && playerX + Enemy_Size >= Enemy1_X_Pos && playerX - Enemy_Size <= Enemy1_X_Pos)
//		idx_in = 3'b000;
//	else if (stop_enemy_hit_right || stop_enemy_hit_up || stop_enemy_hit_left || stop_enemy_hit_down)
//		begin
//		if (playerX + 2 >= Enemy1_X_Pos && playerX - 2 <= Enemy1_X_Pos || playerY + 2 >= Enemy1_Y_Pos && playerY - 2 <= Enemy1_Y_Pos)
//			idx_in = 3'b000;
//		end
		
	else if (res_right <= res_up && res_right <= res_left && res_right <= res_down)
		idx_in = 3'b001;
	else if (res_up <= res_right && res_up <= res_down && res_up <= res_left)
		idx_in = 3'b010;
	else if (res_left <= res_right && res_left <= res_down && res_left <= res_up)
		idx_in = 3'b011;
	else if (res_down <= res_right && res_down <= res_up && res_down <= res_left)
		idx_in = 3'b100;
end

always_ff @ (posedge Clk)
begin
	if (counter == 26'b01000000000000000000000000)
	begin
		idx <= idx_in;
	end
	else if (idx == 3'b001 && stop_enemy_right == 1'b1 || idx == 3'b010 && stop_enemy_up == 1'b1 || idx == 3'b011 && stop_enemy_left == 1'b1 || idx == 3'b100 && stop_enemy_down == 1'b1)
	begin
		idx <= 3'b000;
	end
	
end

always_ff @ (posedge Clk)
begin
	if (Reset)
	counter <= 26'd0;
	else 
	counter <= counter_in;
end

always_comb 
begin
	counter_in = counter;
	if (counter == 26'b01000000000000000000000001)
		counter_in = 26'd0;
	else 
		counter_in = counter + 26'd1;
end

int DistX, DistY, Size;
assign DistX = DrawX - Enemy1_X_Pos;
assign DistY = DrawY - Enemy1_Y_Pos;
assign Size = Enemy_Size;
assign Right_mid_X_en1 = Enemy1_X_Pos + Enemy_Size;
assign Right_mid_Y_en1 = Enemy1_Y_Pos + (Enemy_Size >> 1);
assign Up_mid_X_en1 = Enemy1_X_Pos + (Enemy_Size >> 1);	
assign Up_mid_Y_en1 = Enemy1_Y_Pos;
assign Left_mid_X_en1 = Enemy1_X_Pos;
assign Left_mid_Y_en1 = Enemy1_Y_Pos + (Enemy_Size >> 1);
assign Down_mid_X_en1 = Enemy1_X_Pos + (Enemy_Size >> 1);
assign Down_mid_Y_en1 = Enemy1_Y_Pos + Enemy_Size;
assign Enemy1_X_Pos_out = Enemy1_X_Pos;
assign Enemy1_Y_Pos_out = Enemy1_Y_Pos;
assign Enemy1_DisX = DistX;
assign Enemy1_DisY = DistY;


always_comb begin
   if ( DistX >= 0 && DistX < Size && DistY >= 0 && DistY < Size) 
        is_enemy1 = 1'b1;
   else
        is_enemy1 = 1'b0;
   end	
	
endmodule 






module enemy2 (input Clk, Reset, frame_clk, 
					input [9:0] DrawX, DrawY, 
					input [9:0] playerX, playerY, 
					input enable12,
					input enable1,
					input [9:0] Enemy1_X_Pos_out, Enemy1_Y_Pos_out,
					output [9:0] Right_mid_X_en2, Right_mid_Y_en2, Up_mid_X_en2, Up_mid_Y_en2, Left_mid_X_en2, Left_mid_Y_en2, Down_mid_X_en2, Down_mid_Y_en2,
					output [9:0] Enemy2_X_Pos_out, Enemy2_Y_Pos_out,
					output [19:0] Enemy2_DisX, Enemy2_DisY,
					output is_enemy2, 
					output [1:0] is_enemy2_out,
					output [9:0] Bullet_X_Pos, Bullet_Y_Pos, 
					output is_bullet, is_boom,
					output [19:0] Dist_X_boom_en2, Dist_Y_boom_en2,
					output player_hit
				  );
				  
parameter [9:0] Enemy_X_Start = 10'd23;  // Center position on the X axis
parameter [9:0] Enemy_Y_Start = 10'd23;  // Center position on the Y axis
parameter [9:0] Enemy_X_Min = 10'd2;       // Leftmost point on the X axis
parameter [9:0] Enemy_X_Max = 10'd476;     // Rightmost point on the X axis
parameter [9:0] Enemy_Y_Min = 10'd22;       // Topmost point on the Y axis
parameter [9:0] Enemy_Y_Max = 10'd478;     // Bottommost point on the Y axis
parameter [9:0] Enemy_X_Step = 10'd1;      // Step size on the X axis
parameter [9:0] Enemy_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Enemy_Size = 10'd19;        // Enemy size
	
// temporary code... Will be modified...
logic [9:0] Enemy2_X_Pos, Enemy2_Y_Pos;
logic [9:0] Enemy2_X_Motion, Enemy2_Y_Motion;
logic [9:0] Enemy2_X_Pos_in, Enemy2_X_Motion_in, Enemy2_Y_Pos_in, Enemy2_Y_Motion_in;
logic [1:0] is_enemy2_in, is_bullet_out_en2;
logic [25:0] counter, counter_in;
logic stop_enemy_right, stop_enemy_up, stop_enemy_left, stop_enemy_down;
//logic stop_enemy_hit_right, stop_enemy_hit_up, stop_enemy_hit_left, stop_enemy_hit_down;
logic stop_bullet;
logic draw_boom, draw_bullet;

enemy_wall2 enw2(.enemyX(Enemy2_X_Pos), .enemyY(Enemy2_Y_Pos), .enable(enable12), .enable_other(enable1), .otherX(Enemy1_X_Pos_out), .otherY(Enemy1_Y_Pos_out), .*);
enemy_bullets enb2(.is_enemy_in(is_enemy2_out), .Clk, .frame_clk, .Reset,
						 .DrawX, .DrawY,
				       .Right_mid_X(Right_mid_X_en2), .Right_mid_Y(Right_mid_Y_en2),
						 .Up_mid_X(Up_mid_X_en2), .Up_mid_Y(Up_mid_Y_en2),
						 .Left_mid_X(Left_mid_X_en2), .Left_mid_Y(Left_mid_Y_en2),
						 .Down_mid_X(Down_mid_X_en2), .Down_mid_Y(Right_mid_Y_en2),
						 .Bullet_X_Pos, .Bullet_Y_Pos, .is_bullet, .is_boom, .is_bullet_out(is_bullet_out_en2),
						 .Dist_X_boom(Dist_X_boom_en2), .Dist_Y_boom(Dist_Y_boom_en2), .stop_bullet,
						 .enable(enable12), .draw_boom, .draw_bullet);

 //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Enemy2_X_Pos <= Enemy_X_Start;
            Enemy2_Y_Pos <= Enemy_Y_Start;
            Enemy2_X_Motion <= 10'd0;
            Enemy2_Y_Motion <= 10'd0;
				is_enemy2_out <= 2'b00; //00 Right, 01 up, 10 left, 11 down
//				counter <= 10'd0;
        end
        else
        begin
            Enemy2_X_Pos <= Enemy2_X_Pos_in;
            Enemy2_Y_Pos <= Enemy2_Y_Pos_in;
            Enemy2_X_Motion <= Enemy2_X_Motion_in;
            Enemy2_Y_Motion <= Enemy2_Y_Motion_in;
				is_enemy2_out <= is_enemy2_in;
//				counter <= counter_in;
        end
    end

always_comb
begin
	Enemy2_X_Pos_in = Enemy2_X_Pos;
	Enemy2_Y_Pos_in = Enemy2_Y_Pos; 
	Enemy2_X_Motion_in = 10'b0;
	Enemy2_Y_Motion_in = 10'b0;
	is_enemy2_in = is_enemy2_out;
	if (frame_clk_rising_edge )
	begin
		if (idx == 3'b000)
				begin
							Enemy2_Y_Motion_in = 10'b0;  // 2's complement.  
							Enemy2_X_Motion_in = 10'b0;
							if (playerX + 2 >= Enemy2_X_Pos && playerX - 2 <= Enemy2_X_Pos)
							begin
								if (playerY > Enemy2_Y_Pos)
									is_enemy2_in = 2'b11; // Down.
								else if (playerY < Enemy2_Y_Pos)
									is_enemy2_in = 2'b01;
							end
							
							if (playerY + 2 >= Enemy2_Y_Pos && playerY - 2 <= Enemy2_Y_Pos)
							begin
								if (playerX > Enemy2_X_Pos)
									is_enemy2_in = 2'b00; // Right.
								else if (playerX < Enemy2_X_Pos)
									is_enemy2_in = 2'b10; // Left.
							end
				end
				else if( idx == 3'b010 )  // W (Up) Code 2'b01
				begin
					is_enemy2_in = 2'b01;
					if (Enemy2_Y_Pos > Enemy_Y_Min)
					begin
						Enemy2_Y_Motion_in = (~(Enemy_Y_Step) + 1'b1);  // 2's complement.  
						Enemy2_X_Motion_in = 10'b0;
					end
					else
					begin
						Enemy2_Y_Motion_in = 10'b0;  // 2's complement.  
						Enemy2_X_Motion_in = 10'b0;
					end
				end
            else if ( idx == 3'b100 )
				begin 														// S (Down) Code 2'b11
					is_enemy2_in = 2'b11;
					if (Enemy2_Y_Pos + Enemy_Size < Enemy_Y_Max )
					begin
						Enemy2_Y_Motion_in = Enemy_Y_Step;
						Enemy2_X_Motion_in = 10'b0;
					end 
					else 
					begin
						Enemy2_Y_Motion_in = 10'b0;  // 2's complement.  
						Enemy2_X_Motion_in = 10'b0;
					end
				end
				else if( idx == 3'b011 )  // A (Left) Code 2'b10
				begin
					is_enemy2_in = 2'b10;
					if (Enemy2_X_Pos > Enemy_X_Min)
					begin
						Enemy2_X_Motion_in = (~(Enemy_X_Step) + 1'b1);  // 2's complement.
						Enemy2_Y_Motion_in = 10'b0;
					end
					else 
					begin
						Enemy2_Y_Motion_in = 10'b0;  // 2's complement.  
						Enemy2_X_Motion_in = 10'b0;
					end
				end
            else if ( idx == 3'b001 )  // D (Right) Code 2'b00;
				begin
					is_enemy2_in = 2'b00;
					if (Enemy2_X_Pos + Enemy_Size < Enemy_X_Max)
						begin
							Enemy2_X_Motion_in = Enemy_X_Step;
							Enemy2_Y_Motion_in = 10'b0;
						end
					else
						begin
							Enemy2_Y_Motion_in = 10'b0;  // 2's complement.  
							Enemy2_X_Motion_in = 10'b0;
						end
				end
	end
	Enemy2_X_Pos_in = Enemy2_X_Pos + Enemy2_X_Motion;
	Enemy2_Y_Pos_in = Enemy2_Y_Pos + Enemy2_Y_Motion;
end

//logic all_off, w_on, s_on, a_on, d_on;
//logic all_off_in, w_on_in, s_on_in, a_on_in, d_on_in;
logic [2:0] idx, idx_in;
// Extended for multiplication.
logic [19:0] Exp_ext, Eyp_ext, px_ext, py_ext;
assign Exp_ext[19:10] = {10{1'b0}};
assign Exp_ext[9:0] = Enemy2_X_Pos;
assign Eyp_ext[19:10] = {10{1'b0}};
assign Eyp_ext[9:0] = Enemy2_Y_Pos;
assign px_ext[19:10] = {10{1'b0}};
assign px_ext[9:0] = playerX;
assign py_ext[19:10] = {10{1'b0}};
assign py_ext[9:0] = playerY;
int res_right, res_up, res_left, res_down; 

//res_right distance from enemy to player if were to go right.
always_comb
begin
	res_right = (Exp_ext + 20'd2 - px_ext) * (Exp_ext + 20'd2 - px_ext) + (Eyp_ext - py_ext) * (Eyp_ext - py_ext);
	res_up = (Exp_ext - px_ext) * (Exp_ext - px_ext) + (Eyp_ext - 20'd2 - py_ext) * (Eyp_ext - 20'd2 - py_ext);
	res_left = (Exp_ext - 20'd2 - px_ext) * (Exp_ext - 20'd2 - px_ext) + (Eyp_ext - py_ext) * (Eyp_ext - py_ext);
	res_down = (Exp_ext - px_ext) * (Exp_ext - px_ext) + (Eyp_ext + 20'd2 - py_ext) * (Eyp_ext + 20'd2 - py_ext);
	if (stop_enemy_right == 1'b1 || Enemy2_X_Pos >= Enemy_X_Max)
		res_right = 20'b11111111111111111111;
	if (stop_enemy_up == 1'b1 || Enemy2_Y_Pos <= Enemy_Y_Min)
		res_up = 20'b11111111111111111111;
	if (stop_enemy_left == 1'b1 || Enemy2_X_Pos <= Enemy_X_Min)
		res_left = 20'b11111111111111111111;
	if (stop_enemy_down == 1'b1 || Enemy2_Y_Pos >= Enemy_Y_Max)
		res_down = 20'b11111111111111111111;
end
always_comb 
begin
	// If the shortest distance between enemy and hometank is less than 90, stop moving.
	idx_in = idx;
	if (res_right < 20'd900 || res_up < 20'd900 || res_left < 20'd900 || res_down < 20'd900)
	begin
		if (playerX + 2 >= Enemy2_X_Pos && playerX - 2 <= Enemy2_X_Pos || playerY + 2 >= Enemy2_Y_Pos && playerY - 2 <= Enemy2_Y_Pos)
			idx_in = 3'b000;
	end

//	if (playerX + 5 >= Enemy2_X_Pos && playerX - 5 <= Enemy2_X_Pos && playerY + Enemy_Size >= Enemy2_Y_Pos && playerY - Enemy_Size <= Enemy2_Y_Pos)
//		idx_in = 3'b000;
//	else if (playerY + 5 >= Enemy2_Y_Pos && playerY - 5 <= Enemy2_Y_Pos && playerX + Enemy_Size >= Enemy2_X_Pos && playerX - Enemy_Size <= Enemy2_X_Pos)
//		idx_in = 3'b000;
//   else if (stop_enemy_hit_right || stop_enemy_hit_up || stop_enemy_hit_left || stop_enemy_hit_down)
//		begin
//		if (playerX + 2 >= Enemy2_X_Pos && playerX - 2 <= Enemy2_X_Pos || playerY + 2 >= Enemy2_Y_Pos && playerY - 2 <= Enemy2_Y_Pos)
//			idx_in = 3'b000;
//		end
	else if (res_right <= res_up && res_right <= res_left && res_right <= res_down)
		idx_in = 3'b001;
	else if (res_up <= res_right && res_up <= res_down && res_up <= res_left)
		idx_in = 3'b010;
	else if (res_left <= res_right && res_left <= res_down && res_left <= res_up)
		idx_in = 3'b011;
	else if (res_down <= res_right && res_down <= res_up && res_down <= res_left)
		idx_in = 3'b100;
end

always_ff @ (posedge Clk)
begin
	if (counter == 26'b01000000000000000000000000)
	begin
		idx <= idx_in;
	end
	else if (idx == 3'b001 && stop_enemy_right == 1'b1 || idx == 3'b010 && stop_enemy_up == 1'b1 || idx == 3'b011 && stop_enemy_left == 1'b1 || idx == 3'b100 && stop_enemy_down == 1'b1)
	begin
		idx <= 3'b000;
	end
	
end

always_ff @ (posedge Clk)
begin
	if (Reset)
	counter <= 26'd0;
	else 
	counter <= counter_in;
end

always_comb 
begin
	counter_in = counter;
	if (counter == 26'b01000000000000000000000001)
		counter_in = 26'd0;
	else 
		counter_in = counter + 26'd1;
end

int DistX, DistY, Size;
assign DistX = DrawX - Enemy2_X_Pos;
assign DistY = DrawY - Enemy2_Y_Pos;
assign Size = Enemy_Size;
assign Right_mid_X_en2 = Enemy2_X_Pos + Enemy_Size;
assign Right_mid_Y_en2 = Enemy2_Y_Pos + (Enemy_Size >> 1);
assign Up_mid_X_en2 = Enemy2_X_Pos + (Enemy_Size >> 1);	
assign Up_mid_Y_en2 = Enemy2_Y_Pos;
assign Left_mid_X_en2 = Enemy2_X_Pos;
assign Left_mid_Y_en2 = Enemy2_Y_Pos + (Enemy_Size >> 1);
assign Down_mid_X_en2 = Enemy2_X_Pos + (Enemy_Size >> 1);
assign Down_mid_Y_en2 = Enemy2_Y_Pos + Enemy_Size;
assign Enemy2_X_Pos_out = Enemy2_X_Pos;
assign Enemy2_Y_Pos_out = Enemy2_Y_Pos;
assign Enemy2_DisX = DistX;
assign Enemy2_DisY = DistY;


always_comb begin
   if ( DistX >= 0 && DistX < Size && DistY >= 0 && DistY < Size) 
        is_enemy2 = 1'b1;
   else
        is_enemy2 = 1'b0;
   end	
				  
				  
endmodule 