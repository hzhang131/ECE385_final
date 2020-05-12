module tanks_selector(
					       input [31:0] keycode,
					       input VGA_CLK,
					       input[9:0] DrawX, DrawY,
					       output are_two_tanks,
					       output is_one_tank,
					       output one_player_mode,
					       output two_players_mode,
					       input Reset
			            );
			
enum logic [2:0] {OPM, TPM, OPM_WAIT, TPM_WAIT, OPM_DONE, TPM_DONE} State, Next_State;

always_ff @ (posedge VGA_CLK)
begin 
	if (Reset)
		State <= OPM;
	else
		State <= Next_State;
end 			

always_comb
begin 
	is_one_tank = 1'b0;
	are_two_tanks = 1'b0;
	one_player_mode = 1'b0;
	two_players_mode = 1'b0;
	unique case (State)
		OPM:
			begin
				if (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h51 || keycode[7:0] == 8'h1a || keycode[7:0] == 8'h16)
					Next_State = OPM_WAIT;
				else if (keycode[7:0] == 8'h28 ||  keycode[7:0] == 8'h2c)
					Next_State = OPM_DONE;
				else
					Next_State = OPM;
			end
		OPM_WAIT:
			begin
				if (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h51 || keycode[7:0] == 8'h1a || keycode[7:0] == 8'h16)
					Next_State = OPM_WAIT;
				else
					Next_State = TPM;
			end
		TPM:
			begin
				if (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h51 || keycode[7:0] == 8'h1a || keycode[7:0] == 8'h16)
					Next_State = TPM_WAIT;
				else if (keycode[7:0] == 8'h28 ||  keycode[7:0] == 8'h2c)
					Next_State = TPM_DONE;
				else 
					Next_State = TPM;
			end
		TPM_WAIT:
			begin
				if (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h51 || keycode[7:0] == 8'h1a || keycode[7:0] == 8'h16)
					Next_State = TPM_WAIT;
				else
					Next_State = OPM;
			end
		TPM_DONE: 
			Next_State = TPM_DONE;
		OPM_DONE:
			Next_State = OPM_DONE;
	endcase
	
	
	case (State)
		OPM_WAIT:	
			begin 
				if (DrawX > 195 && DrawX < 215 && DrawY > 285 && DrawY < 302)
					begin
						is_one_tank = 1'b1;
						are_two_tanks = 1'b0;
					end
				else
					begin
						is_one_tank = 1'b0;
						are_two_tanks = 1'b0;
					end
			end
		TPM_WAIT:	
			begin 
				if (DrawX > 195 && DrawX < 215 && DrawY > 315 && DrawY < 332)
					begin
						is_one_tank = 1'b0;
						are_two_tanks = 1'b1;
					end
				else
					begin
						is_one_tank = 1'b0;
						are_two_tanks = 1'b0;
					end
					
			end
		OPM:	
			begin 
				if (DrawX > 195 && DrawX < 215 && DrawY > 285 && DrawY < 302)
					begin
						is_one_tank = 1'b1;
						are_two_tanks = 1'b0;
					end
				else
					begin
						is_one_tank = 1'b0;
						are_two_tanks = 1'b0;
					end
			end
		TPM:
			begin
				if (DrawX > 195 && DrawX < 215 && DrawY > 315 && DrawY < 332)
					begin
						is_one_tank = 1'b0;
						are_two_tanks = 1'b1;
					end
				else 
					begin 
						is_one_tank = 1'b0;
						are_two_tanks = 1'b0;
					end
			   end
		TPM_DONE:
			begin
				is_one_tank = 1'b0;
				are_two_tanks = 1'b0;
				two_players_mode = 1'b1;
			end
		OPM_DONE:
			begin
				is_one_tank = 1'b0;
				are_two_tanks = 1'b0;
				one_player_mode = 1'b1;
			end
	endcase
				
end
					
endmodule 


module en_draw (input [31:0] keycode,
					 input VGA_CLK, Reset, en_state,
					 input [9:0] DrawX, DrawY,
					 output is_tank, is_count, is_number, chosen, is_ennumber,
					 output[3:0] en_num
					 );
					 
always_comb
begin
	if(en_state == 1'b1 && DrawX > 2 && DrawX < 22 && DrawY > 458 && DrawY < 478)
	begin
		is_tank = 1'b1;
		is_count = 1'b0;
		is_number = 1'b0;
	end
	else if(en_state == 1'b1 && DrawX > 567 && DrawX < 639 && DrawY > 428 && DrawY < 479)
	begin
		is_tank = 1'b0;
		is_count = 1'b1;
		is_number = 1'b0;
	end
	else if(en_state == 1'b1 && DrawX > 408 && DrawX < 454 && DrawY < 479 && DrawY > 441)
	begin
		is_tank = 1'b0;
		is_count = 1'b0;
		is_number = 1'b1;
	end
	else
	begin
		is_tank = 1'b0;
		is_count = 1'b0;
		is_number = 1'b0;
	end
end

enum logic [5:0] {state0, state1, state2, /*state3, state4, state5, state6, state7, state8, state9,*/
						state0_wait, state1_wait, state2_wait, /*state3_wait, state4_wait, state5_wait, state6_wait,
						state7_wait, state8_wait, state9_wait,*/ done_state} State, Next_State;

logic flag;
logic chosen_in;
logic [3:0] enemy;
assign chosen = chosen_in;
				
always_ff @(posedge VGA_CLK)
begin 
	if (Reset)
	begin
		State <= state0;
		en_num <= 4'b0;
	end
	else if(flag)
	begin
		State <= Next_State;
		en_num <= enemy;
	end
	else
	begin
		State <= Next_State;
		en_num <= en_num;
	end
end 

always_comb
begin
	chosen_in = 1'b0;
	flag = 1'b0;
	enemy = 4'b0;
	is_ennumber = 1'b0;
	unique case (State)
		state0:
			begin
				if(en_state == 1'b1 && (keycode[7:0] == 8'h51 || keycode[7:0] == 8'h16))
				begin
					Next_State = state0_wait;                                   //change back to state8_wait
					enemy = 4'b0000;
				   flag = 1'b1;
				end
				else if(en_state == 1'b1 && (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h1A))
				begin
					Next_State = state1_wait;
					enemy = 4'b0000;
					flag = 1'b1;
				end
				else if(en_state == 1'b1 && (keycode[7:0] == 8'h2C || keycode[7:0] == 8'h28))
				begin
					Next_State = done_state;
					enemy = 4'b0000;
					flag = 1'b1;
				end
				else
				begin
					Next_State = state0;
					enemy = 4'b0000;
					flag = 1'b1;
				end
			end
		state0_wait: //go to state 1
			begin
				if (en_state == 1'b1 && (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h51 || keycode[7:0] == 8'h1a || keycode[7:0] == 8'h16))
				begin
					Next_State = state0_wait;
					enemy = 4'b0000;
					flag = 1'b1;
				end
				else
				begin
					Next_State = state1; //change it back to 1 after testing
					enemy = 4'b0001;
					flag = 1'b1;
				end
			end
		state1:
			begin
				if(en_state == 1'b1 && (keycode[7:0] == 8'h51 || keycode[7:0] == 8'h16))
				begin
					Next_State = state1_wait;
					enemy = 4'b0001;
					flag = 1'b1;
				end
				else if(en_state == 1'b1 && (keycode[7:0] == 8'h52 || keycode[7:0] == 8'h1A))
				begin
					Next_State = state2_wait;
					enemy = 4'b0001;
					flag = 1'b1;
				end
				else if(en_state == 1'b1 && (keycode[7:0] == 8'h2C || keycode[7:0] == 8'h28))
				begin
					Next_State = done_state;
					enemy = 4'b0001;
					flag = 1'b1;
				end
				else
				begin
					Next_State = state1;
					enemy = 4'b0001;
					flag = 1'b1;
				end
			end
		state1_wait://go to state 2
			begin
				if ( en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
				begin
					Next_State = state1_wait;
					enemy = 4'b0001;
					flag = 1'b1;
				end
				else
				begin
					Next_State = state2;
					enemy = 4'b0010;
					flag = 1'b1;
				end
			end
		state2:
			begin
				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
				begin
					Next_State = state2_wait;				
					enemy = 4'b0010;
					flag = 1'b1;
				end
				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
				begin
					Next_State = state0_wait;
					enemy = 4'b0010;
					flag = 1'b1;
				end
				else if(en_state == 1'b1 && (keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
				begin
					Next_State = done_state;
					enemy = 4'b0010;
					flag = 1'b1;
				end
				else
				begin
					Next_State = state2;
					enemy = 4'b0010;
					flag = 1'b1;
				end
			end
		state2_wait:
			begin
				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
				begin
					Next_State = state2_wait;
					enemy = 4'b0010;
					flag = 1'b1;
				end
				else
				begin
					Next_State = state0;
					enemy = 4'b0000;
					flag = 1'b1;
				end
			end
//		state3:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state3_wait;
//					enemy = 4'b0011;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state1_wait;
//					enemy = 4'b0011;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
//				begin
//					Next_State = done_state;
//					enemy = 4'b0011;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state3;
//					enemy = 4'b0011;
//					flag = 1'b1;
//				end
//			end
//		state3_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state3_wait;
//					enemy = 4'b0011;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state4;
//					enemy = 4'b0100;
//					flag = 1'b1;
//				end
//			end
//		state4:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state4_wait;
//					enemy = 4'b0100;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state2_wait;
//					enemy = 4'b0100;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
//				begin
//					Next_State = done_state;
//					enemy = 4'b0100;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state4;
//					enemy = 4'b0100;
//					flag = 1'b1;
//				end
//			end
//		state4_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state4_wait;
//					enemy = 4'b0100;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state5;
//					enemy = 4'b0101;
//					flag = 1'b1;
//				end
//			end
//		state5:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state5_wait;
//					enemy = 4'b0101;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state3_wait;
//					enemy = 4'b0101;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28)
//				begin
//					Next_State = done_state;
//					enemy = 4'b0101;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state5;
//					enemy = 4'b0101;
//					flag = 1'b1;
//				end
//			end
//		state5_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state5_wait;
//					enemy = 4'b0101;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state6;
//					enemy = 4'b0110;
//					flag = 1'b1;
//				end
//			end
//		state6:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state6_wait;
//					enemy = 4'b0110;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state4_wait;
//					enemy = 4'b0110;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 &&(keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
//				begin
//					Next_State = done_state;
//					enemy = 4'b0110;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state6;
//					enemy = 4'b0110;
//					flag = 1'b1;
//				end
//			end
//		state6_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state6_wait;
//					enemy = 4'b0110;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state7;
//					enemy = 4'b0111;
//					flag = 1'b1;
//				end
//			end
//		state7:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state7_wait;
//					enemy = 4'b0111;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state5_wait;
//					enemy = 4'b0111;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
//				begin
//					Next_State = done_state;
//					enemy = 4'b0111;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state7;
//					enemy = 4'b0111;
//					flag = 1'b1;
//				end
//			end
//		state7_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state7_wait;
//					enemy = 4'b0111;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state8;
//					enemy = 4'b1000;
//					flag = 1'b1;
//				end
//			end
//		state8:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state8_wait;
//					enemy = 4'b1000;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state6_wait;
//					enemy = 4'b1000;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
//				begin
//					Next_State = done_state;
//					enemy = 4'b1000;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state8;
//					enemy = 4'b1000;
//					flag = 1'b1;
//				end
//			end
//		state8_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state8_wait;
//					enemy = 4'b1000;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state9;
//					enemy = 4'b1001;
//					flag = 1'b1;
//				end
//			end
//		state9:
//			begin
//				if(en_state == 1'b1 && (keycode [7:0] ==8'h51 || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state9_wait;
//					enemy = 4'b1001;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h1A))
//				begin
//					Next_State = state7_wait;
//					enemy = 4'b1001;
//					flag = 1'b1;
//				end
//				else if(en_state == 1'b1 && (keycode [7:0] ==8'h2C || keycode [7:0] ==8'h28))
//				begin
//					Next_State = done_state;
//					enemy = 4'b1001;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state9;
//					enemy = 4'b1001;
//					flag = 1'b1;
//				end
//			end
//		state9_wait:
//			begin
//				if (en_state == 1'b1 && (keycode [7:0] ==8'h52 || keycode [7:0] ==8'h51 || keycode [7:0] ==8'h1a || keycode [7:0] ==8'h16))
//				begin
//					Next_State = state9_wait;
//					enemy = 4'b1001;
//					flag = 1'b1;
//				end
//				else
//				begin
//					Next_State = state0;
//					enemy = 4'b0000;
//					flag = 1'b1;
//				end
//			end
		
		done_state:
			begin
				Next_State = done_state;
				enemy = 4'b0000;
				flag = 1'b0;
				chosen_in = 1'b1;
			end
	endcase
	
	case (State)
		state0:	
			begin
				if (en_state == 1'b1 && (DrawX > 414 && DrawX < 425 && DrawY > 416 && DrawY < 435))
					begin
						is_ennumber = 1'b1;
					end
				else
					begin
						chosen_in = 1'b0;
					end
			end
		state1:	
			begin
				if (en_state == 1'b1 && (DrawX > 426 && DrawX < 436 && DrawY > 416 && DrawY < 435))
					begin
						is_ennumber = 1'b1;
					end
				else
					begin
						chosen_in = 1'b0;
					end
			end
		state2:	
			begin
				if (en_state == 1'b1 && (DrawX > 438 && DrawX < 449 && DrawY > 416 && DrawY < 435))
					begin
						is_ennumber = 1'b1;
					end
				else
					begin
						chosen_in = 1'b0;
					end
			end
//		state3:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 452 && DrawX < 462 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
//		state4:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 466 && DrawX < 477 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
//		state5:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 480 && DrawX < 491 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
//		state6:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 495 && DrawX < 506 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
//		state7:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 510 && DrawX < 521 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
//		state8:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 524 && DrawX < 535 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
//		state9:	
//			begin
//				if (en_state == 1'b1 && (DrawX > 539 && DrawX < 550 && DrawY > 416 && DrawY < 435))
//					begin
//						is_ennumber = 1'b1;
//					end
//				else
//					begin
//						chosen_in = 1'b0;
//					end
//			end
	endcase
end

endmodule

			
//////////////////////////////////////////////////////////////////////////////////////////////////////////

module en_game (input [31:0] keycode,
					 input VGA_CLK, Reset, game_mode,
					 input [9:0] DrawX, DrawY,
					 input [3:0] en_num,
					 output is_player1, is_player2, is_player_en2
					 );
					 
always_comb
begin
	if(game_mode == 1'b1 && DrawX > 510 && DrawX < 530 && DrawY > 190 && DrawY < 210)
	begin
		is_player1 = 1'b1;
		is_player2 = 1'b0;
		is_player_en2 = 1'b0;
	end
	else if(game_mode == 1'b1 && DrawX > 510 && DrawX < 530 && DrawY > 310 && DrawY < 330)
	begin
		is_player1 = 1'b0;
		is_player2 = 1'b1;
		is_player_en2 = 1'b0;
	end
	else if(game_mode == 1'b1 && DrawX > 550 && DrawX < 570 && DrawY > 310 && DrawY < 330)
	begin
		is_player1 = 1'b0;
		is_player2 = 1'b0;
		if (en_num == 4'b0010)
			is_player_en2 = 1'b1;
		else 
			is_player_en2 = 1'b0;
	end
	else
	begin
		is_player1 = 1'b0;
		is_player2 = 1'b0;
		is_player_en2 = 1'b0;
	end
end

endmodule