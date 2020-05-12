module wall2( input[9:0] DrawX, DrawY,
				 input[9:0] Ball_X_Pos, Ball_Y_Pos,
				 input[9:0] Bullet_X_Pos, Bullet_Y_Pos,
				 input [9:0] bulletx1, bullety1, ballx, bally,
				 input enable2,
				 input draw_bullet, draw_boom,
				 output stop_tank_right, stop_tank_up, stop_tank_left, stop_tank_down, 
				 output stop_bullet,
				 output stop_bullet21, player1_hit
				);
				
int func_up, func_down, x_func_up, x_func_down, y_func_up, y_func_down;
int bx_func_up, bx_func_down, by_func_up, by_func_down;
parameter [9:0] size = 10'd19;
parameter [9:0] b_size = 10'd5;
always_comb
begin 
	stop_tank_right = 1'd0;
	stop_tank_up = 1'd0;
	stop_tank_left = 1'd0;
	stop_tank_down = 1'd0;
	stop_bullet = 1'd0;
	stop_bullet21 = 1'd0;
	player1_hit = 1'd0;

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
	

	if (bulletx1 >= Ball_X_Pos && bulletx1 < Ball_X_Pos + size && bullety1 >= Ball_Y_Pos && bullety1 < Ball_Y_Pos + size)
		begin
			stop_bullet21 = 1'b1;
		end
		
	if (Bullet_X_Pos >= ballx && Bullet_X_Pos < ballx + size && Bullet_Y_Pos >= bally 
			&& Bullet_Y_Pos < bally + size && draw_boom == 1'b0 && draw_bullet == 1'b0)
		begin
			player1_hit = 1'b1;
		end
		
	if (Ball_X_Pos + size >= ballx - 4 && Ball_X_Pos + size <= ballx + 4 && Ball_Y_Pos + size >= bally && Ball_Y_Pos <= bally + size)
		begin 
			stop_tank_right = 1'b1;
		end
		
	if (Ball_X_Pos + size >= ballx && Ball_X_Pos <= ballx + size && Ball_Y_Pos >= bally + size - 4 && Ball_Y_Pos <= bally + size + 4)
		begin
			stop_tank_up = 1'b1;
		end
		
	if (Ball_X_Pos >= ballx + size - 4 && Ball_X_Pos <= ballx + size + 4 && Ball_Y_Pos + size >= bally && Ball_Y_Pos <= bally + size )
		begin
			stop_tank_left = 1'b1;
		end
		
	if (Ball_X_Pos + size >= ballx && Ball_X_Pos <= ballx + size && Ball_Y_Pos + size >= bally - 4 && Ball_Y_Pos + size <= bally + 4)
		begin
			stop_tank_down = 1'b1;
		end

		
	func_up = DrawX * 4 - 480 - 10;
	func_down = DrawX * 4 - 480 + 10;
	// stop_tank[0] barrier on right.
	// stop_tank[1] barrier on top.
	// stop_tank[2] barrier on left.
	// stop_tank[3] barrier on down.
	x_func_down = (Ball_Y_Pos + 10'd470) >> 2;
	x_func_up = (Ball_Y_Pos + 10'd490) >> 2;
	y_func_down = (Ball_X_Pos + size) * 4 - 470;
	y_func_up = (Ball_X_Pos) * 4 - 490;
	bx_func_down = (Bullet_Y_Pos + 10'd470) >> 2;
	bx_func_up = (Bullet_Y_Pos + 10'd490) >> 2;
	by_func_down = (Bullet_X_Pos + b_size) * 4 - 470;
	by_func_up = (Bullet_X_Pos) * 4 - 490;
	
	
	// Rightcheck
	if ((Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd100 || Ball_X_Pos + size >= 10'd95 && Ball_X_Pos + size <= 10'd97 && Ball_Y_Pos + size >= 10'd100 && Ball_Y_Pos < 10'd200 || Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos + size >= 10'd169 && Ball_X_Pos + size <= 10'd171 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd220) ||
    	 (Ball_X_Pos + size >= 10'd259 && Ball_X_Pos + size <= 10'd261 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos + size >= 10'd95 && Ball_X_Pos + size <= 10'd97 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos < 10'd370 || Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd370 && Ball_Y_Pos < 10'd390) ||
		 (Ball_X_Pos + size >= 10'd169 && Ball_X_Pos + size <= 10'd171 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos + size >= x_func_down - 1 && Ball_X_Pos + size <= x_func_down + 1 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos + size >= 10'd213 && Ball_X_Pos + size <= 10'd217 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390) ||
		 (Ball_X_Pos + size >= 10'd259 && Ball_X_Pos + size <= 10'd261 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos + size >= 10'd275 && Ball_X_Pos + size <= 10'd305 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos < 10'd370 || Ball_X_Pos + size >= 10'd259 && Ball_X_Pos + size <= 10'd261 && Ball_Y_Pos + size >= 10'd370 && Ball_Y_Pos < 10'd390)
		)
		begin
		stop_tank_right = 1'b1;
		end
	
	// Upcheck
	if ((Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd217 && Ball_Y_Pos <= 10'd223 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos >=  10'd97 && Ball_Y_Pos <= 10'd103 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd97 && Ball_Y_Pos <= 10'd103) ||
		 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd230 && Ball_Y_Pos >= 10'd217 && Ball_Y_Pos <= 10'd223)||
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd320 && Ball_Y_Pos >= 10'd217 && Ball_Y_Pos <= 10'd223) ||
		 (Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos >=  10'd267 && Ball_Y_Pos <= 10'd273 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd267 && Ball_Y_Pos <= 10'd273) ||
    	 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd185 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 || Ball_X_Pos + size >= 10'd215 && Ball_X_Pos < 10'd230 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 ) || 
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd320 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 || Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd275 && Ball_Y_Pos >=  10'd267 && Ball_Y_Pos <= 10'd273 || Ball_X_Pos + size >= 10'd305 && Ball_X_Pos < 10'd320 && Ball_Y_Pos >= 10'd267 && Ball_Y_Pos <= 10'd273)
	)
		begin
		stop_tank_up = 1'b1;
		end
	
	if (Ball_X_Pos >= 10'd185 && Ball_X_Pos <= 10'd195 && Ball_Y_Pos >= y_func_down - 3 && Ball_Y_Pos <= y_func_down+3)
		begin 
		stop_tank_up = 1'b1;
		end
		
	// Left Check.
	if ((Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd100 || Ball_X_Pos >= 10'd123 && Ball_X_Pos <= 10'd127 && Ball_Y_Pos + size >= 10'd100 && Ball_Y_Pos < 10'd200 || Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos >= 10'd188 && Ball_X_Pos <= 10'd192 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd200 || Ball_X_Pos >= 10'd228 && Ball_X_Pos <= 10'd232 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos >= 10'd278 && Ball_X_Pos <= 10'd282 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd200 || Ball_X_Pos >= 10'd318 && Ball_X_Pos <= 10'd322 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220)
		)
		begin
		stop_tank_left = 1'b1;
		end
	
	if ((Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos >= 10'd123 && Ball_X_Pos <= 10'd127 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos <= 10'd370 || Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd370 && Ball_Y_Pos < 10'd390)||
		 (Ball_X_Pos >= 10'd228 && Ball_X_Pos <= 10'd232 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos >= x_func_up - 2 && Ball_X_Pos <= x_func_up + 2 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos >= 10'd183 && Ball_X_Pos <= 10'd187 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390) ||
		 (Ball_X_Pos >= 10'd318 && Ball_X_Pos <= 10'd322 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos >= 10'd303 && Ball_X_Pos <= 10'd307 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos < 10'd370 || Ball_X_Pos >= 10'd318 && Ball_X_Pos <= 10'd322 && Ball_Y_Pos + size >= 10'd371 && Ball_Y_Pos < 10'd390)
		)
		begin
		stop_tank_left = 1'b1;
		end
		
	// Down Check.
	if ((Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd79 && Ball_Y_Pos + size <= 10'd81 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201) ||
		 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd190 && Ball_Y_Pos + size >= 10'd79 && Ball_Y_Pos + size <= 10'd81 || Ball_X_Pos + size >= 10'd190 && Ball_X_Pos < 10'd230 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201) ||
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd280 && Ball_Y_Pos + size >= 10'd79 && Ball_Y_Pos + size <= 10'd81 || Ball_X_Pos + size >=  10'd280 && Ball_X_Pos < 10'd320 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201)
		)
		begin
		stop_tank_down = 1'b1;
		end
	
	if ((Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos + size >= 10'd369 && Ball_Y_Pos + size <= 10'd371 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd369 && Ball_Y_Pos + size <= 10'd371) ||
		 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd185 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251 || Ball_X_Pos + size >= 10'd185 && Ball_X_Pos < 10'd215 && Ball_Y_Pos + size >= y_func_up - 1 && Ball_Y_Pos + size <= y_func_up + 1 || Ball_X_Pos + size >= 10'd215 && Ball_X_Pos + size < 10'd230 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251) ||
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd320 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251 || Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd275 && Ball_Y_Pos + size >=  10'd369 && Ball_Y_Pos + size <= 10'd371 || Ball_X_Pos + size >= 10'd305 && Ball_X_Pos < 10'd320 && Ball_Y_Pos + size >= 10'd369 && Ball_Y_Pos + size <= 10'd371)
		)
		begin
		stop_tank_down = 1'b1;
		end
	
//	// Rightcheck bullet
//	if ((Bullet_X_Pos + b_size >= 10'd76 && Bullet_X_Pos <= 10'd82 && Bullet_Y_Pos + b_size >= 10'd80 && Bullet_Y_Pos < 10'd100 + b_size || Bullet_X_Pos + b_size >= 10'd91 && Ball_X_Pos + b_size <= 10'd97 && Bullet_Y_Pos + b_size >= 10'd100 && Bullet_Y_Pos < 10'd200 + b_size || Bullet_X_Pos + b_size >= 10'd78 && Bullet_X_Pos <= 10'd82 && Bullet_Y_Pos + b_size >= 10'd200 && Bullet_Y_Pos < 10'd220 + b_size) ||
//		 (Bullet_X_Pos + b_size >= 10'd166 && Bullet_X_Pos <= 10'd172 && Bullet_Y_Pos + b_size >= 10'd80 && Ball_Y_Pos < 10'd220 + b_size) ||
//    	 (Bullet_X_Pos + b_size >= 10'd256 && Bullet_X_Pos <= 10'd262 && Bullet_Y_Pos + b_size >= 10'd80 && Ball_Y_Pos < 10'd220 + b_size)
//	)
//		begin
//		stop_bullet_right = 1'b1;
//		end
//	if ((Bullet_X_Pos + b_size >= 10'd76 && Bullet_X_Pos <= 10'd82 && Bullet_Y_Pos + b_size >= 10'd250 && Bullet_Y_Pos < 10'd270 + b_size || Bullet_X_Pos + b_size >= 10'd91 && Bullet_X_Pos <= 10'd97 && Bullet_Y_Pos + b_size >= 10'd270 && Bullet_Y_Pos < 10'd370 + b_size || Bullet_X_Pos + b_size >= 10'd76 && Bullet_X_Pos <= 10'd82 && Bullet_Y_Pos + b_size >= 10'd370 && Bullet_Y_Pos < 10'd390 + b_size) ||
//		 (Bullet_X_Pos + b_size >= 10'd166 && Bullet_X_Pos <= 10'd172 && Bullet_Y_Pos + b_size >= 10'd250 && Bullet_Y_Pos < 10'd390 + b_size || Bullet_X_Pos + b_size >= bx_func_down - 4 && Bullet_X_Pos <= bx_func_down + 2 && Bullet_Y_Pos + b_size >= 10'd250 && Bullet_Y_Pos < 10'd390 + b_size|| Bullet_X_Pos + b_size >= 10'd211 && Bullet_X_Pos <= 10'd217 && Bullet_Y_Pos + b_size >= 10'd250 && Bullet_Y_Pos < 10'd390 + b_size) ||
//		 (Bullet_X_Pos + b_size >= 10'd256 && Bullet_X_Pos <= 10'd262 && Bullet_Y_Pos + b_size >= 10'd250 && Ball_Y_Pos < 10'd270 + b_size || Bullet_X_Pos + b_size >= 10'd271 && Bullet_X_Pos <= 10'd277 && Bullet_Y_Pos + b_size >= 10'd270 && Ball_Y_Pos < 10'd370 + b_size|| Bullet_X_Pos + b_size >= 10'd256 && Bullet_X_Pos <= 10'd262 && Bullet_Y_Pos + b_size >= 10'd370 && Bullet_Y_Pos < 10'd390 + b_size)
//	)
//		begin
//		stop_bullet_right = 1'b1;
//		end
		
	// Upcheck
//	if ((Bullet_X_Pos + b_size >= 10'd80 && Bullet_X_Pos < 10'd140 + b_size && Bullet_Y_Pos >= 10'd217 && Bullet_Y_Pos <= 10'd226 + b_size || Bullet_X_Pos + b_size >= 10'd80 && Bullet_X_Pos < 10'd95 + b_size && Bullet_Y_Pos >=  10'd97 && Bullet_Y_Pos <= 10'd106 + b_size|| Bullet_X_Pos + size >= 10'd125 && Bullet_X_Pos < 10'd140 + b_size && Bullet_Y_Pos >= 10'd97 && Bullet_Y_Pos <= 10'd106 + b_size) ||
//		 (Bullet_X_Pos + b_size >= 10'd170 && Bullet_X_Pos < 10'd230 + b_size && Bullet_Y_Pos >= 10'd217 && Bullet_Y_Pos <= 10'd226 + b_size )||
//		 (Bullet_X_Pos + b_size >= 10'd260 && Bullet_X_Pos < 10'd320 + b_size && Bullet_Y_Pos >= 10'd217 && Bullet_Y_Pos <= 10'd226 + b_size) 
//		)
//		begin
//		stop_tank_up = 1'b1;
//		end
//    if (Bullet_X_Pos + b_size >= 10'd80 && Bullet_X_Pos < 10'd140 + b_size && Bullet_Y_Pos >= 10'd220 && Bullet_Y_Pos <= 10'd232)
//		begin 
//		stop_tank_up = 1'b1;
//		end
	
//	if ((Bullet_X_Pos + b_size >= 10'd80 && Bullet_X_Pos < 10'd140 + b_size && Bullet_Y_Pos >= 10'd387 && Bullet_Y_Pos <= 10'd396 + b_size || Bullet_X_Pos + b_size >= 10'd80 && Bullet_X_Pos < 10'd95 + b_size && Bullet_Y_Pos >=  10'd267 && Bullet_Y_Pos <= 10'd276 + b_size || Bullet_X_Pos + size >= 10'd125 && Bullet_X_Pos < 10'd140 + b_size && Bullet_Y_Pos >= 10'd267 && Bullet_Y_Pos <= 10'd276 + b_size) ||
//    	 (Bullet_X_Pos + b_size >= 10'd170 && Ball_X_Pos < 10'd185 + b_size && Bullet_Y_Pos >= 10'd387 && Bullet_Y_Pos <= 10'd396 + b_size || Bullet_X_Pos + b_size >= 10'd215 && Bullet_X_Pos < 10'd230 + b_size && Bullet_Y_Pos >= 10'd387 && Bullet_Y_Pos <= 10'd396 + b_size || Bullet_X_Pos + b_size >= 10'd185 && Bullet_X_Pos <= 10'd195 + b_size && Bullet_Y_Pos >= by_func_down - 3 && Bullet_Y_Pos <= by_func_down+6 + b_size) || 
//		 (Bullet_X_Pos + b_size >= 10'd260 && Ball_X_Pos < 10'd320 + b_size && Bullet_Y_Pos >= 10'd387 && Bullet_Y_Pos <= 10'd396 + b_size || Bullet_X_Pos + b_size >= 10'd260 && Bullet_X_Pos < 10'd275 + b_size && Bullet_Y_Pos >=  10'd267 && Bullet_Y_Pos <= 10'd276 + b_size || Bullet_X_Pos + size >= 10'd305 && Bullet_X_Pos < 10'd320 + b_size && Bullet_Y_Pos >= 10'd267 && Bullet_Y_Pos <= 10'd276 + b_size)
//	   )
//		begin 
//		stop_tank_up = 1'b1;
//		end

	
end
endmodule