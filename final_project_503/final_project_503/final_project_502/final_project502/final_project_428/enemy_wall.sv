module enemy_wall( input [9:0] enemyX, enemyY,
						 input [9:0] playerX, playerY,
                   input [9:0] Bullet_X_Pos, Bullet_Y_Pos,
						 input enable, draw_boom, draw_bullet,
						 input enable_other,
						 input [9:0] otherX, otherY,
						 output stop_enemy_right, stop_enemy_up, stop_enemy_left, stop_enemy_down,
//						 output stop_enemy_hit_right, stop_enemy_hit_up, stop_enemy_hit_left, stop_enemy_hit_down,
						 output stop_bullet, 
						 output player_hit
						);
						
parameter [9:0] size = 10'd19;
int x_func_down, x_func_up, y_func_down, y_func_up;
int bx_func_up, bx_func_down, by_func_up, by_func_down;
logic boom_flag;
parameter [9:0] b_size = 10'd5;
always_comb
begin
	stop_enemy_right = 1'd0;
	stop_enemy_up = 1'd0;
	stop_enemy_left = 1'd0;
	stop_enemy_down = 1'd0;
//	stop_enemy_hit_right = 1'd0;
//	stop_enemy_hit_up = 1'd0;
//	stop_enemy_hit_left = 1'd0;
//	stop_enemy_hit_down = 1'd0;
	stop_bullet = 1'd0;
	player_hit = 1'd0;
	
	x_func_down = (enemyY + 10'd470) >> 2;
	x_func_up = (enemyY + 10'd490) >> 2;
	y_func_down = (enemyX + size) * 4 - 470;
	y_func_up = (enemyX) * 4 - 490;
	bx_func_down = (Bullet_Y_Pos + 10'd470) >> 2;
	bx_func_up = (Bullet_Y_Pos + 10'd490) >> 2;
	by_func_down = (Bullet_X_Pos + b_size) * 4 - 470;
	by_func_up = (Bullet_X_Pos) * 4 - 490;
	
	if (enable)
	begin
	// Rightcheck
	if ((enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd80 && enemyY < 10'd100 || enemyX + size >= 10'd95 && enemyX + size <= 10'd97 && enemyY + size >= 10'd100 && enemyY < 10'd200 || enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd200 && enemyY < 10'd220) ||
		 (enemyX + size >= 10'd169 && enemyX + size <= 10'd171 && enemyY + size >= 10'd80 && enemyY < 10'd220) ||
    	 (enemyX + size >= 10'd259 && enemyX + size <= 10'd261 && enemyY + size >= 10'd80 && enemyY < 10'd220) ||
		 (enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX + size >= 10'd95 && enemyX + size <= 10'd97 && enemyY + size >= 10'd270 && enemyY < 10'd370 || enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd370 && enemyY < 10'd390) ||
		 (enemyX + size >= 10'd169 && enemyX + size <= 10'd171 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX + size >= x_func_down - 1 && enemyX + size <= x_func_down + 1 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX + size >= 10'd213 && enemyX + size <= 10'd217 && enemyY + size >= 10'd250 && enemyY < 10'd390) ||
		 (enemyX + size >= 10'd259 && enemyX + size <= 10'd261 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX + size >= 10'd275 && enemyX + size <= 10'd305 && enemyY + size >= 10'd270 && enemyY < 10'd370 || enemyX + size >= 10'd259 && enemyX + size <= 10'd261 && enemyY + size >= 10'd370 && enemyY < 10'd390)
		)
		begin
		stop_enemy_right = 1'b1;
		end
	
	// Upcheck
	if ((enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY >= 10'd217 && enemyY <= 10'd223 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY >=  10'd97 && enemyY <= 10'd103 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY >= 10'd97 && enemyY <= 10'd103) ||
		 (enemyX + size >= 10'd170 && enemyX < 10'd230 && enemyY >= 10'd217 && enemyY <= 10'd223)||
		 (enemyX + size >= 10'd260 && enemyX < 10'd320 && enemyY >= 10'd217 && enemyY <= 10'd223) ||
		 (enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY >= 10'd387 && enemyY <= 10'd393 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY >=  10'd267 && enemyY <= 10'd273 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY >= 10'd267 && enemyY <= 10'd273) ||
    	 (enemyX + size >= 10'd170 && enemyX < 10'd185 && enemyY >= 10'd387 && enemyY <= 10'd393 || enemyX + size >= 10'd215 && enemyX < 10'd230 && enemyY >= 10'd387 && enemyY <= 10'd393 ) || 
		 (enemyX + size >= 10'd260 && enemyX < 10'd320 && enemyY >= 10'd387 && enemyY <= 10'd393 || enemyX + size >= 10'd260 && enemyX < 10'd275 && enemyY >=  10'd267 && enemyY <= 10'd273 || enemyX + size >= 10'd305 && enemyX < 10'd320 && enemyY >= 10'd267 && enemyY <= 10'd273)
	)
		begin
		stop_enemy_up = 1'b1;
		end
	
	if (enemyX >= 10'd185 && enemyX <= 10'd195 && enemyY >= y_func_down - 3 && enemyY <= y_func_down+3)
		begin 
		stop_enemy_up = 1'b1;
		end
		
	// Left Check.
	if ((enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd80 && enemyY < 10'd100 || enemyX >= 10'd123 && enemyX <= 10'd127 && enemyY + size >= 10'd100 && enemyY < 10'd200 || enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd200 && enemyY < 10'd220) ||
		 (enemyX >= 10'd188 && enemyX <= 10'd192 && enemyY + size >= 10'd80 && enemyY < 10'd200 || enemyX >= 10'd228 && enemyX <= 10'd232 && enemyY + size >= 10'd200 && enemyY < 10'd220) ||
		 (enemyX >= 10'd278 && enemyX <= 10'd282 && enemyY + size >= 10'd80 && enemyY < 10'd200 || enemyX >= 10'd318 && enemyX <= 10'd322 && enemyY + size >= 10'd200 && enemyY < 10'd220)
		)
		begin
		stop_enemy_left = 1'b1;
		end
	
	if ((enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX >= 10'd123 && enemyX <= 10'd127 && enemyY + size >= 10'd270 && enemyY <= 10'd370 || enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd370 && enemyY < 10'd390)||
		 (enemyX >= 10'd228 && enemyX <= 10'd232 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX >= x_func_up - 2 && enemyX <= x_func_up + 2 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX >= 10'd183 && enemyX <= 10'd187 && enemyY + size >= 10'd250 && enemyY < 10'd390) ||
		 (enemyX >= 10'd318 && enemyX <= 10'd322 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX >= 10'd303 && enemyX <= 10'd307 && enemyY + size >= 10'd270 && enemyY < 10'd370 || enemyX >= 10'd318 && enemyX <= 10'd322 && enemyY + size >= 10'd371 && enemyY < 10'd390)
		)
		begin
		stop_enemy_left = 1'b1;
		end
		
	// Down Check.
	if ((enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY + size >= 10'd79 && enemyY + size <= 10'd81 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201) ||
		 (enemyX + size >= 10'd170 && enemyX < 10'd190 && enemyY + size >= 10'd79 && enemyY + size <= 10'd81 || enemyX + size >= 10'd190 && enemyX < 10'd230 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201) ||
		 (enemyX + size >= 10'd260 && enemyX < 10'd280 && enemyY + size >= 10'd79 && enemyY + size <= 10'd81 || enemyX + size >=  10'd280 && enemyX < 10'd320 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201)
		)
		begin
		stop_enemy_down = 1'b1;
		end
	
	if ((enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY + size >= 10'd369 && enemyY + size <= 10'd371 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY + size >= 10'd369 && enemyY + size <= 10'd371) ||
		 (enemyX + size >= 10'd170 && enemyX < 10'd185 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251 || enemyX + size >= 10'd185 && enemyX < 10'd215 && enemyY + size >= y_func_up - 1 && enemyY + size <= y_func_up + 1 || enemyX + size >= 10'd215 && enemyX + size < 10'd230 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251) ||
		 (enemyX + size >= 10'd260 && enemyX < 10'd320 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251 || enemyX + size >= 10'd260 && enemyX < 10'd275 && enemyY + size >=  10'd369 && enemyY + size <= 10'd371 || enemyX + size >= 10'd305 && enemyX < 10'd320 && enemyY + size >= 10'd369 && enemyY + size <= 10'd371)
		)
		begin
		stop_enemy_down = 1'b1;
		end
	
   if (enemyX + size >= playerX - 1 && enemyX + size <= playerX && enemyY + size >= playerY && enemyY <= playerY + size)
		begin 
			stop_enemy_right = 1'b1;
		end
		
		if (enemyX + size >= playerX && enemyX <= playerX + size && enemyY >= playerY + size - 1 && enemyY <= playerY + size + 1)
		begin
			stop_enemy_up = 1'b1;
		end
		
		if (enemyX >= playerX + size - 1 && enemyX <= playerX + size + 1 && enemyY + size >= playerY && enemyY <= playerY + size )
		begin
			stop_enemy_left = 1'b1;
		end
		
		if (enemyX + size >= playerX && enemyX <= playerX + size && enemyY + size >= playerY -1 && enemyY + size <= playerY + 1)
		begin
			stop_enemy_down = 1'b1;
		end
	

	if (enable_other)
	begin
		if (enemyX + size >= otherX - 4 && enemyX + size <= otherX + 4 && enemyY + size >= otherY && enemyY <= otherY + size)
		begin 
			stop_enemy_right = 1'b1;
		end
		
		if (enemyX + size >= otherX && enemyX <= otherX + size && enemyY >= otherY + size - 4 && enemyY <= otherY + size + 4)
		begin
			stop_enemy_up = 1'b1;
		end
		
		if (enemyX >= otherX + size - 4 && enemyX <= otherX + size + 4 && enemyY + size >= otherY && enemyY <= otherY + size )
		begin
			stop_enemy_left = 1'b1;
		end
		
		if (enemyX + size >= otherX && enemyX <= otherX + size && enemyY + size >= otherY - 4 && enemyY + size <= otherY + 4)
		begin
			stop_enemy_down = 1'b1;
		end
	end
	
	
	if (Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd100 || Bullet_X_Pos >= 10'd95 && Bullet_X_Pos < 10'd125 && Bullet_Y_Pos >= 10'd100 && Bullet_Y_Pos < 10'd200 || Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd230 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220 || Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd190 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220 || Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd280 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd270 || Bullet_X_Pos >= 10'd95 && Bullet_X_Pos < 10'd125 && Bullet_Y_Pos >= 10'd270 && Bullet_Y_Pos < 10'd370 || Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd370 && Bullet_Y_Pos < 10'd390)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd185 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd390 || Bullet_X_Pos >= 10'd215 && Bullet_X_Pos < 10'd230 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd390 || Bullet_X_Pos >= 10'd185 && Bullet_X_Pos < 10'd215 && Bullet_Y_Pos >= by_func_up && Bullet_Y_Pos < by_func_down)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd270 || Bullet_X_Pos >= 10'd275 && Bullet_X_Pos < 10'd305 && Bullet_Y_Pos >= 10'd270 && Bullet_Y_Pos < 10'd370 || Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd370 && Bullet_Y_Pos < 10'd390)
		begin
		stop_bullet = 1'b1;
		end
	
	// If this block is executed, the first player is obviously hit by the enemy!!!
	if (Bullet_X_Pos >= playerX && Bullet_X_Pos < playerX + size && Bullet_Y_Pos >= playerY && Bullet_Y_Pos < playerY + size)
		begin
		stop_bullet = 1'b1;
		if (draw_boom == 1'b0 && draw_bullet == 1'b0)
			player_hit = 1'b1;
		end
	end
end
endmodule

module enemy_bullets (
							 input [1:0] is_enemy_in,
							 input Clk, frame_clk, Reset,
							 input [9:0] DrawX, DrawY,
							 input [9:0]  Right_mid_X, Right_mid_Y, 
							 input [9:0]  Up_mid_X, Up_mid_Y,
							 input [9:0]  Left_mid_X, Left_mid_Y,
					       input [9:0]  Down_mid_X, Down_mid_Y,
							 output [9:0] Bullet_X_Pos, Bullet_Y_Pos,
							 output is_bullet, is_boom,
							 output [1:0] is_bullet_out, 
							 output [19:0] Dist_X_boom, Dist_Y_boom,
							 input stop_bullet, enable, 
							 output draw_boom, draw_bullet
							);

												
logic [9:0] Bullet_X_Start;  					  // Center position on the X axis
logic [9:0] Bullet_Y_Start;  					  // Center position on the Y axis
parameter [9:0] Bullet_X_Min = 10'd2;       // Leftmost point on the X axis
parameter [9:0] Bullet_X_Max = 10'd478;     // Rightmost point on the X axis
parameter [9:0] Bullet_Y_Min = 10'd20;      // Topmost point on the Y axis
parameter [9:0] Bullet_Y_Max = 10'd478;     // Bottommost point on the Y axis
parameter [9:0] Bullet_X_Step = 10'd6;      // Step size on the X axis
parameter [9:0] Bullet_Y_Step = 10'd6;      // Step size on the Y axis
parameter [9:0] Bullet_Size = 10'd3;        // Bullet size
parameter [9:0] Boom_Size = 10'd19;         // Boom size

logic [25:0] counter, counter_in, b_counter, b_counter_in;
logic [1:0] is_bullet_out_in;
logic [9:0] Bullet_X_Pos_in, Bullet_Y_Pos_in, Bullet_X_Motion_in, Bullet_Y_Motion_in;
//logic [9:0] Bullet_X_Pos, Bullet_Y_Pos, Bullet_X_Motion, Bullet_Y_Motion;
logic [9:0] Bullet_X_Motion, Bullet_Y_Motion;
logic bullet_load;
                                //shoot is when player press "space" for tank 1 


always_ff @ (posedge Clk)
begin 
	if (Reset)
		begin
		counter <= 26'd0;
		b_counter <= 26'd0;
		is_bullet_out <= 2'b00; //00 Right, 01 up, 10 left, 11 down
		end
	else 
		begin
		counter <= counter_in;
		b_counter <= b_counter_in;
		is_bullet_out <= is_bullet_out_in;
		end
end

logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end

always_comb
begin
		unique case (is_bullet_out)
			2'b00: begin
						Bullet_X_Start = Right_mid_X;
						Bullet_Y_Start = Right_mid_Y;
						Bullet_X_Motion_in = Bullet_X_Step;
						Bullet_Y_Motion_in = 10'b0;
					 end
			2'b01: begin
						Bullet_X_Start = Up_mid_X;
						Bullet_Y_Start = Up_mid_Y;
						Bullet_X_Motion_in = 10'b0;
						Bullet_Y_Motion_in = ((~Bullet_Y_Step)+1'b1); // 2's complement.
			       end
			2'b10: begin
						Bullet_X_Start = Left_mid_X; 
						Bullet_Y_Start = Left_mid_Y;
						Bullet_X_Motion_in = ((~Bullet_X_Step)+1'b1);
						Bullet_Y_Motion_in = 10'b0;
					 end
			2'b11: begin
						Bullet_X_Start = Down_mid_X;
						Bullet_Y_Start = Down_mid_Y;
						Bullet_X_Motion_in = 10'b0;
						Bullet_Y_Motion_in = Bullet_Y_Step;
					 end
			default:begin
						Bullet_X_Start = 10'd320;
						Bullet_Y_Start = 10'd240;
						Bullet_X_Motion_in = Bullet_X_Motion;
						Bullet_Y_Motion_in = Bullet_X_Motion;
					  end
		endcase
end
// Update registers
always_ff @ (posedge Clk)
begin
if (Reset || bullet_load == 1'b1)
   begin
	Bullet_X_Pos <= Bullet_X_Start;
   Bullet_Y_Pos <= Bullet_Y_Start;
   Bullet_X_Motion <= Bullet_X_Motion_in;
   Bullet_Y_Motion <= Bullet_Y_Motion_in;
   end
	else
   begin
      Bullet_X_Pos <= Bullet_X_Pos_in;
      Bullet_Y_Pos <= Bullet_Y_Pos_in;
      Bullet_X_Motion <= Bullet_X_Motion;
      Bullet_Y_Motion <= Bullet_Y_Motion;
   end
end


enum logic [2:0] {NOBULLET, NOBULLET_WAIT, BULLET_LOAD, BULLET, BULLET_WAIT, BULLET_BOOM, BOOM_WAIT} State, Next_State;

always_ff @ (posedge Clk) 
begin
	if (Reset) 
		State <= NOBULLET;
	else
		State <= Next_State;
end


always_comb
begin 
	is_bullet_out_in = is_bullet_out;
	bullet_load = 1'b1;
	counter_in = counter;
	b_counter_in = b_counter;
	draw_bullet = 1'b0;
	draw_boom = 1'b0;
	unique case (State)
	NOBULLET:
		begin
			Next_State = NOBULLET_WAIT;
		end
	NOBULLET_WAIT:
		begin
//		if (keycode[7:0] == 8'h00 || keycode[15:8] == 8'h00) 
			Next_State = BULLET;
//		else
//			Next_State = NOBULLET_WAIT;
		end
	BULLET_LOAD:
		Next_State = BULLET;
	BULLET:
		begin
		if (counter == 26'b01100000000000000000000000)
			Next_State = BULLET_WAIT;
		else if (interrupt == 1'b1)
			Next_State = BULLET_BOOM;
		else
			Next_State = BULLET;
		end
	BULLET_WAIT:
		begin
//		if (keycode[7:0] == 8'h00)
			Next_State = NOBULLET;
//		else 
//			Next_State = BULLET_WAIT;
		end
	BULLET_BOOM:
		begin
		if (b_counter == 26'b00001111000000000000000000)
			Next_State = BOOM_WAIT;
		else
			Next_State = BULLET_BOOM;
		end
	BOOM_WAIT:
//		begin 
//		if (keycode[7:0] == 8'h00)
			Next_State = NOBULLET;
//		else 
//			Next_State = BOOM_WAIT;
//		end
	endcase
	
	case (State) 
	NOBULLET:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		is_bullet_out_in = is_enemy_in;
		end
	NOBULLET_WAIT:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		is_bullet_out_in = is_enemy_in;
		end
	BULLET_LOAD:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		end
	BULLET:
		begin
		counter_in = counter_in + 26'd1;
		b_counter_in = 26'd0;
		draw_bullet = 1'b1;
		bullet_load = 1'b0;
		end
	BULLET_WAIT:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		end
	BULLET_BOOM:
		begin
		counter_in = 26'd0;
		draw_boom = 1'b1;
		bullet_load = 1'b0;
		b_counter_in = b_counter + 26'd1;
		end
	BOOM_WAIT:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		end
	endcase
end

logic interrupt;
always_comb
    begin
        // By default, keep motion and position unchanged
        Bullet_X_Pos_in = Bullet_X_Pos;
        Bullet_Y_Pos_in = Bullet_Y_Pos;
		  interrupt = 1'b0;
//        Bullet_X_Motion_in = Bullet_X_Motion;
//        Bullet_Y_Motion_in = Bullet_Y_Motion;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Bullet_Y_Pos - Bullet_Size <= Bullet_Y_Min 
            // If Bullet_Y_Pos is 0, then Bullet_Y_Pos - Bullet_Size will not be -4, but rather a large positive number.
				if (draw_bullet == 1'b1)
				begin
            // Update the Bullet's position with its motion
					if (Bullet_X_Pos + Bullet_Size < Bullet_X_Max && Bullet_X_Pos > Bullet_X_Min && Bullet_Y_Pos + Bullet_Size < Bullet_Y_Max && Bullet_Y_Pos > Bullet_Y_Min && ~stop_bullet)
					begin
						Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
						Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
					end
					else 
						begin
						interrupt = 1'b1;
						end
				end
        end
	 end
	 
int DistX, DistY, Size, b_size;
always_comb 
begin
	DistX = DrawX - Bullet_X_Pos;
	DistY = DrawY - Bullet_Y_Pos;
	Dist_X_boom[19:10] = {10{1'b0}};
	Dist_X_boom[9:0] = DistX[9:0];
	Dist_Y_boom[19:10] = {10{1'b0}};
	Dist_Y_boom[9:0] = DistY[9:0];
	Size = Bullet_Size;
	b_size = Boom_Size >> 1;
end
always_comb
begin
	is_bullet = 1'b0;
	is_boom = 1'b0;
	if (enable == 1'b1 && draw_bullet == 1'b1)
	begin 
		if ((DistX*DistX + DistY*DistY) <= (Size*Size))
			is_bullet = 1'b1;
	end
	else if (enable == 1'b1 && draw_boom == 1'b1)
	begin
		if (DistX >= -1 * b_size && DistX < b_size && DistY >= -1 * b_size && DistY < b_size)
			is_boom = 1'b1;
	end
end		  
							
							
endmodule 

module enemy_wall2( input [9:0] enemyX, enemyY,
						 input [9:0] playerX, playerY,
                   input [9:0] Bullet_X_Pos, Bullet_Y_Pos,
						 input enable, draw_boom, draw_bullet,
						 input enable_other,
						 input [9:0] otherX, otherY,
						 output stop_enemy_right, stop_enemy_up, stop_enemy_left, stop_enemy_down,
//						 output stop_enemy_hit_right, stop_enemy_hit_up, stop_enemy_hit_left, stop_enemy_hit_down,
						 output stop_bullet, 
						 output player_hit
						);
						
parameter [9:0] size = 10'd19;
int x_func_down, x_func_up, y_func_down, y_func_up;
int bx_func_up, bx_func_down, by_func_up, by_func_down;
logic boom_flag;
parameter [9:0] b_size = 10'd5;
always_comb
begin
	stop_enemy_right = 1'd0;
	stop_enemy_up = 1'd0;
	stop_enemy_left = 1'd0;
	stop_enemy_down = 1'd0;
//	stop_enemy_hit_right = 1'd0;
//	stop_enemy_hit_up = 1'd0;
//	stop_enemy_hit_left = 1'd0;
//	stop_enemy_hit_down = 1'd0;
	stop_bullet = 1'd0;
	player_hit = 1'd0;
	
	x_func_down = (enemyY + 10'd470) >> 2;
	x_func_up = (enemyY + 10'd490) >> 2;
	y_func_down = (enemyX + size) * 4 - 470;
	y_func_up = (enemyX) * 4 - 490;
	bx_func_down = (Bullet_Y_Pos + 10'd470) >> 2;
	bx_func_up = (Bullet_Y_Pos + 10'd490) >> 2;
	by_func_down = (Bullet_X_Pos + b_size) * 4 - 470;
	by_func_up = (Bullet_X_Pos) * 4 - 490;
	
	if (enable)
	begin
	// Rightcheck
	if ((enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd80 && enemyY < 10'd100 || enemyX + size >= 10'd95 && enemyX + size <= 10'd97 && enemyY + size >= 10'd100 && enemyY < 10'd200 || enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd200 && enemyY < 10'd220) ||
		 (enemyX + size >= 10'd169 && enemyX + size <= 10'd171 && enemyY + size >= 10'd80 && enemyY < 10'd220) ||
    	 (enemyX + size >= 10'd259 && enemyX + size <= 10'd261 && enemyY + size >= 10'd80 && enemyY < 10'd220) ||
		 (enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX + size >= 10'd95 && enemyX + size <= 10'd97 && enemyY + size >= 10'd270 && enemyY < 10'd370 || enemyX + size >= 10'd79 && enemyX + size <= 10'd81 && enemyY + size >= 10'd370 && enemyY < 10'd390) ||
		 (enemyX + size >= 10'd169 && enemyX + size <= 10'd171 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX + size >= x_func_down - 1 && enemyX + size <= x_func_down + 1 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX + size >= 10'd213 && enemyX + size <= 10'd217 && enemyY + size >= 10'd250 && enemyY < 10'd390) ||
		 (enemyX + size >= 10'd259 && enemyX + size <= 10'd261 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX + size >= 10'd275 && enemyX + size <= 10'd305 && enemyY + size >= 10'd270 && enemyY < 10'd370 || enemyX + size >= 10'd259 && enemyX + size <= 10'd261 && enemyY + size >= 10'd370 && enemyY < 10'd390)
		)
		begin
		stop_enemy_right = 1'b1;
		end
	
	// Upcheck
	if ((enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY >= 10'd217 && enemyY <= 10'd223 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY >=  10'd97 && enemyY <= 10'd103 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY >= 10'd97 && enemyY <= 10'd103) ||
		 (enemyX + size >= 10'd170 && enemyX < 10'd230 && enemyY >= 10'd217 && enemyY <= 10'd223)||
		 (enemyX + size >= 10'd260 && enemyX < 10'd320 && enemyY >= 10'd217 && enemyY <= 10'd223) ||
		 (enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY >= 10'd387 && enemyY <= 10'd393 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY >=  10'd267 && enemyY <= 10'd273 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY >= 10'd267 && enemyY <= 10'd273) ||
    	 (enemyX + size >= 10'd170 && enemyX < 10'd185 && enemyY >= 10'd387 && enemyY <= 10'd393 || enemyX + size >= 10'd215 && enemyX < 10'd230 && enemyY >= 10'd387 && enemyY <= 10'd393 ) || 
		 (enemyX + size >= 10'd260 && enemyX < 10'd320 && enemyY >= 10'd387 && enemyY <= 10'd393 || enemyX + size >= 10'd260 && enemyX < 10'd275 && enemyY >=  10'd267 && enemyY <= 10'd273 || enemyX + size >= 10'd305 && enemyX < 10'd320 && enemyY >= 10'd267 && enemyY <= 10'd273)
	)
		begin
		stop_enemy_up = 1'b1;
		end
	
	if (enemyX >= 10'd185 && enemyX <= 10'd195 && enemyY >= y_func_down - 3 && enemyY <= y_func_down+3)
		begin 
		stop_enemy_up = 1'b1;
		end
		
	// Left Check.
	if ((enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd80 && enemyY < 10'd100 || enemyX >= 10'd123 && enemyX <= 10'd127 && enemyY + size >= 10'd100 && enemyY < 10'd200 || enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd200 && enemyY < 10'd220) ||
		 (enemyX >= 10'd188 && enemyX <= 10'd192 && enemyY + size >= 10'd80 && enemyY < 10'd200 || enemyX >= 10'd228 && enemyX <= 10'd232 && enemyY + size >= 10'd200 && enemyY < 10'd220) ||
		 (enemyX >= 10'd278 && enemyX <= 10'd282 && enemyY + size >= 10'd80 && enemyY < 10'd200 || enemyX >= 10'd318 && enemyX <= 10'd322 && enemyY + size >= 10'd200 && enemyY < 10'd220)
		)
		begin
		stop_enemy_left = 1'b1;
		end
	
	if ((enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX >= 10'd123 && enemyX <= 10'd127 && enemyY + size >= 10'd270 && enemyY <= 10'd370 || enemyX >= 10'd138 && enemyX <= 10'd142 && enemyY + size >= 10'd370 && enemyY < 10'd390)||
		 (enemyX >= 10'd228 && enemyX <= 10'd232 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX >= x_func_up - 2 && enemyX <= x_func_up + 2 && enemyY + size >= 10'd250 && enemyY < 10'd390 || enemyX >= 10'd183 && enemyX <= 10'd187 && enemyY + size >= 10'd250 && enemyY < 10'd390) ||
		 (enemyX >= 10'd318 && enemyX <= 10'd322 && enemyY + size >= 10'd250 && enemyY < 10'd270 || enemyX >= 10'd303 && enemyX <= 10'd307 && enemyY + size >= 10'd270 && enemyY < 10'd370 || enemyX >= 10'd318 && enemyX <= 10'd322 && enemyY + size >= 10'd371 && enemyY < 10'd390)
		)
		begin
		stop_enemy_left = 1'b1;
		end
		
	// Down Check.
	if ((enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY + size >= 10'd79 && enemyY + size <= 10'd81 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201) ||
		 (enemyX + size >= 10'd170 && enemyX < 10'd190 && enemyY + size >= 10'd79 && enemyY + size <= 10'd81 || enemyX + size >= 10'd190 && enemyX < 10'd230 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201) ||
		 (enemyX + size >= 10'd260 && enemyX < 10'd280 && enemyY + size >= 10'd79 && enemyY + size <= 10'd81 || enemyX + size >=  10'd280 && enemyX < 10'd320 && enemyY + size >= 10'd199 && enemyY + size <= 10'd201)
		)
		begin
		stop_enemy_down = 1'b1;
		end
	
	if ((enemyX + size >= 10'd80 && enemyX < 10'd140 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251 || enemyX + size >= 10'd80 && enemyX < 10'd95 && enemyY + size >= 10'd369 && enemyY + size <= 10'd371 || enemyX + size >= 10'd125 && enemyX < 10'd140 && enemyY + size >= 10'd369 && enemyY + size <= 10'd371) ||
		 (enemyX + size >= 10'd170 && enemyX < 10'd185 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251 || enemyX + size >= 10'd185 && enemyX < 10'd215 && enemyY + size >= y_func_up - 1 && enemyY + size <= y_func_up + 1 || enemyX + size >= 10'd215 && enemyX + size < 10'd230 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251) ||
		 (enemyX + size >= 10'd260 && enemyX < 10'd320 && enemyY + size >= 10'd249 && enemyY + size <= 10'd251 || enemyX + size >= 10'd260 && enemyX < 10'd275 && enemyY + size >=  10'd369 && enemyY + size <= 10'd371 || enemyX + size >= 10'd305 && enemyX < 10'd320 && enemyY + size >= 10'd369 && enemyY + size <= 10'd371)
		)
		begin
		stop_enemy_down = 1'b1;
		end
	
   if (enemyX + size >= playerX - 1 && enemyX + size <= playerX && enemyY + size >= playerY && enemyY <= playerY + size)
		begin 
			stop_enemy_right = 1'b1;
		end
		
		if (enemyX + size >= playerX && enemyX <= playerX + size && enemyY >= playerY + size - 1 && enemyY <= playerY + size + 1)
		begin
			stop_enemy_up = 1'b1;
		end
		
		if (enemyX >= playerX + size - 1 && enemyX <= playerX + size + 1 && enemyY + size >= playerY && enemyY <= playerY + size )
		begin
			stop_enemy_left = 1'b1;
		end
		
		if (enemyX + size >= playerX && enemyX <= playerX + size && enemyY + size >= playerY -1 && enemyY + size <= playerY + 1)
		begin
			stop_enemy_down = 1'b1;
		end
	
	if (enable_other)
	begin
		if (enemyX + size >= otherX - 4 && enemyX + size <= otherX && enemyY + size >= otherY && enemyY <= otherY + size)
		begin 
			stop_enemy_right = 1'b1;
		end
		
		if (enemyX + size >= otherX && enemyX <= otherX + size && enemyY >= otherY + size - 4 && enemyY <= otherY + size + 4)
		begin
			stop_enemy_up = 1'b1;
		end
		
		if (enemyX >= otherX + size - 4 && enemyX <= otherX + size + 4 && enemyY + size >= otherY && enemyY <= otherY + size )
		begin
			stop_enemy_left = 1'b1;
		end
		
		if (enemyX + size >= otherX && enemyX <= otherX + size && enemyY + size >= otherY - 4 && enemyY + size <= otherY + 4)
		begin
			stop_enemy_down = 1'b1;
		end
	end

	
	
	if (Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd100 || Bullet_X_Pos >= 10'd95 && Bullet_X_Pos < 10'd125 && Bullet_Y_Pos >= 10'd100 && Bullet_Y_Pos < 10'd200 || Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd230 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220 || Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd190 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220 || Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd280 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd270 || Bullet_X_Pos >= 10'd95 && Bullet_X_Pos < 10'd125 && Bullet_Y_Pos >= 10'd270 && Bullet_Y_Pos < 10'd370 || Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd370 && Bullet_Y_Pos < 10'd390)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd185 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd390 || Bullet_X_Pos >= 10'd215 && Bullet_X_Pos < 10'd230 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd390 || Bullet_X_Pos >= 10'd185 && Bullet_X_Pos < 10'd215 && Bullet_Y_Pos >= by_func_up && Bullet_Y_Pos < by_func_down)
		begin
		stop_bullet = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd270 || Bullet_X_Pos >= 10'd275 && Bullet_X_Pos < 10'd305 && Bullet_Y_Pos >= 10'd270 && Bullet_Y_Pos < 10'd370 || Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd370 && Bullet_Y_Pos < 10'd390)
		begin
		stop_bullet = 1'b1;
		end
	
	// If this block is executed, the first player is obviously hit by the enemy!!!
	if (Bullet_X_Pos >= playerX && Bullet_X_Pos < playerX + size && Bullet_Y_Pos >= playerY && Bullet_Y_Pos < playerY + size)
		begin
		stop_bullet = 1'b1;
		if (draw_boom == 1'b0 && draw_bullet == 1'b0)
			player_hit = 1'b1;
		end
	end
end
endmodule






