module sp_addr_lookup(
								input is_one_tank, are_two_tanks, 
										is_tank_final, is_tank_final2,
										is_enemy1_final, is_enemy2_final,
										en_tank, en_count, en_number, 
										is_ennumber, is_boom, is_boom2,
										is_boom_en1, is_boom_en2,
										is_player1, is_player2, one_player_mode,
										is_player_en2,
								input [1:0] is_tank_out, is_tank_out2, is_enemy1_out, is_enemy2_out,
								input [1:0] mode,
								input [5:0] player_lives, enemy1_lives, enemy2_lives,
								input [5:0] player1_lives, player2_lives,
								input [9:0] DrawX, DrawY,
								input [19:0] DistX, DistY, DistX2, DistY2,
								input [19:0] Enemy1_DisX, Enemy1_DisY,
								input [19:0] Enemy2_DisX, Enemy2_DisY,
								input [19:0] Dist_X_boom, Dist_Y_boom,
								input [19:0] Dist_X_boom2, Dist_Y_boom2,
								input [19:0] Dist_X_boom_en1, Dist_Y_boom_en1,
								input [19:0] Dist_X_boom_en2, Dist_Y_boom_en2,
								input [3:0] en_num,
								output [19:0] Addr_out
							);
							
logic [19:0] DrawX_ext, DrawY_ext, DrawX_shf, DrawY_shf;

always_comb 
begin
	Addr_out = 20'b0;
	DrawX_ext[19:10] = {10{1'b0}};
	DrawX_ext[9:0] = DrawX;
	DrawY_ext[19:10] = {10{1'b0}};
	DrawY_ext[9:0] = DrawY;
	DrawX_shf[19:0] = DrawX_ext >> 2;
	DrawY_shf[19:0] = DrawY_ext >> 2;
	if (is_one_tank == 1)
		Addr_out = (DrawY_ext - 20'd285 + 20'd155) * 20'd320 + (DrawX_ext - 20'd195);
	else if (are_two_tanks == 1)
		Addr_out = (DrawY_ext - 20'd315 + 20'd155) * 20'd320 + (DrawX_ext - 20'd195);
		
	if (en_tank == 1)
		Addr_out = (DrawY_ext - 20'd458 + 20'd155) * 20'd320 + (DrawX_ext - 20'd2);
	else if (en_count == 1)
		Addr_out = (DrawY_ext - 20'd428 + 20'd190) * 20'd320 + (DrawX_ext - 20'd567 + 20'd245);
	else if (en_number == 1)
		Addr_out = (DrawY_ext - 20'd442 + 20'd201) * 20'd320 + (DrawX_ext - 20'd408);
	else if (is_ennumber == 1)
		unique case (en_num)
			4'b0000: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd414 + 20'd114);
			4'b0001: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd426 + 20'd114);
			4'b0010: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd438 + 20'd114);
//			4'b0011: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd452 + 20'd114);
//			4'b0100: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd466 + 20'd114);
//			4'b0101: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd480 + 20'd114);
//			4'b0110: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd495 + 20'd114);
//			4'b0111: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd510 + 20'd114);
//			4'b1000: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd524 + 20'd114);
//			4'b1001: Addr_out = (DrawY_ext - 20'd416) * 20'd320 + (DrawX_ext - 20'd539 + 20'd114);
		endcase
	
	if(is_player1 == 1)
	begin
		Addr_out = (DrawY_ext - 20'd190 + 20'd155) * 20'd320 + (DrawX_ext - 20'd510);
	end
	else if(is_player2 == 1)
	begin
		Addr_out = (DrawY_ext - 20'd310) * 20'd320 + (DrawX_ext - 20'd510);
	end
	else if(is_player_en2 == 1)
	begin
		Addr_out = (DrawY_ext - 20'd310 + 20'd104) * 20'd320 + (DrawX_ext - 20'd530);
	end
	
	if(is_enemy1_final == 1 && is_boom_en1 == 0)
	begin
		unique case (is_enemy1_out)
		2'b00: Addr_out = (Enemy1_DisY ) * 20'd320 + Enemy1_DisX;
		2'b01: Addr_out = (Enemy1_DisY ) * 20'd320 + Enemy1_DisX + 20'd37;
		2'b10: Addr_out = (Enemy1_DisY ) * 20'd320 + Enemy1_DisX + 20'd91;
		2'b11: Addr_out = (Enemy1_DisY ) * 20'd320 + Enemy1_DisX + 20'd110;
		endcase
	end
	
	else if (is_enemy1_final == 0 && is_boom_en1 == 1)
	begin
		Addr_out = (Dist_Y_boom_en1 + 20'd183) * 20'd320 + Dist_X_boom_en1 + 20'd19;
	end
	
	// second enemy!!!
	if (is_enemy2_final && is_boom_en2 == 0)
	begin
		unique case (is_enemy2_out)
		2'b00: Addr_out = (Enemy2_DisY + 20'd104) * 20'd320 + Enemy2_DisX;
		2'b01: Addr_out = (Enemy2_DisY + 20'd104) * 20'd320 + Enemy2_DisX + 20'd37;
		2'b10: Addr_out = (Enemy2_DisY + 20'd104) * 20'd320 + Enemy2_DisX + 20'd91;
		2'b11: Addr_out = (Enemy2_DisY + 20'd104) * 20'd320 + Enemy2_DisX + 20'd110;
		endcase
	end
	
	else if (is_enemy2_final == 0 && is_boom_en2 == 1)
	begin
		Addr_out = (Dist_Y_boom_en2 + 20'd183) * 20'd320 + Dist_X_boom_en2 + 20'd19;
	end
	
	if(is_tank_final2 == 1 && is_boom2 == 0)
	begin
		unique case (is_tank_out2)
		2'b00: Addr_out = (DistY2 ) * 20'd320 + DistX2;
		2'b01: Addr_out = (DistY2 ) * 20'd320 + DistX2 + 20'd37;
		2'b10: Addr_out = (DistY2 ) * 20'd320 + DistX2 + 20'd91;
		2'b11: Addr_out = (DistY2 ) * 20'd320 + DistX2 + 20'd110;
		endcase
	end
	
	else if (is_tank_final2 == 0 && is_boom2 == 1)
	begin
		Addr_out = (Dist_Y_boom2 + 20'd183) * 20'd320 + Dist_X_boom2 + 20'd19;
	end
		
	if (is_tank_final == 1 && is_boom == 0)
		unique case (is_tank_out)
		2'b00: Addr_out = (DistY + 20'd155) * 20'd320 + DistX;
		2'b01: Addr_out = (DistY + 20'd155) * 20'd320 + DistX + 20'd37;
		2'b10: Addr_out = (DistY + 20'd155) * 20'd320 + DistX + 20'd91;
		2'b11: Addr_out = (DistY + 20'd155) * 20'd320 + DistX + 20'd110;
		endcase
	else if (is_tank_final == 0 && is_boom == 1)
		Addr_out = (Dist_Y_boom + 20'd183) * 20'd320 + Dist_X_boom + 20'd19;
		
	if (mode == 2'b11 && en_num == 4'b0000 && one_player_mode)
		Addr_out = (DrawY_shf) * 20'd320 + DrawX_shf;
	else if(enemy1_lives == 0 && mode == 2'b11 && en_num == 4'b0001)
		Addr_out = (DrawY_shf) * 20'd320 + DrawX_shf;
	else if (enemy1_lives + enemy2_lives == 0 && mode == 2'b11 && en_num == 4'b0010)
		Addr_out = (DrawY_shf) * 20'd320 + DrawX_shf;
	else if(player_lives == 0 && mode == 2'b11)
		Addr_out = (DrawY_shf + 20'd120) * 20'd320 + (DrawX_shf + 20'd170);
	else if(player1_lives == 0 && mode == 2'b11)
		Addr_out = (DrawY_shf + 20'd120) * 20'd320 + (DrawX_shf + 20'd10);
	else if(player2_lives == 0 && mode == 2'b11)
		Addr_out = (DrawY_shf ) * 20'd320 + (DrawX_shf + 20'd173);
end
	
endmodule 