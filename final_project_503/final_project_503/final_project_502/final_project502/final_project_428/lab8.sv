//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 input logic 			AUD_DACLRCK,  //all the following logic are used for audio
											AUD_ADCLRCK, 
											AUD_BCLK,
				 output logic 			AUD_DACDAT, 
											AUD_XCK, 
											I2C_SCLK, 
											I2C_SDAT
                    );
    
    logic Reset_h, Reset_hi, Clk;
    logic [31:0] keycode;
   
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_hi <= ~(KEY[0]);        // The push buttons are active low
    end
    
	 assign Reset_h = Reset_hi || (keycode == 8'h14);
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
	 
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     final_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
									);
    
	 logic [9:0] DrawX, DrawY;
	 logic is_tank, is_tank2, en_number;             //is_tank from tank1, is_tank2 from tank2, en_number is to draw the number of enemy play would like to choose;
	 logic [19:0] DrawX_ext, DrawY_ext;
	 logic [19:0] DistX_out, DistY_out;
	 logic [19:0] DistX_out2, DistY_out2;
	 logic [19:0] read_address;
	 logic [19:0] sp_address;
	 logic [11:0] bg_data, str_data, code;
	 logic [11:0] en_data, lt_data;
	 logic [1:0] mode;
	 logic Reset_tank;
	 logic [9:0] Right_mid_X, Right_mid_Y, Up_mid_X, Up_mid_Y, Left_mid_X, Left_mid_Y, Down_mid_X, Down_mid_Y;
	 logic [9:0] Right_mid_X2, Right_mid_Y2, Up_mid_X2, Up_mid_Y2, Left_mid_X2, Left_mid_Y2, Down_mid_X2, Down_mid_Y2;
	 logic is_tank_final, is_tank_final2;
	 logic [1:0] is_tank_out;
	 logic [1:0] is_tank_out2;                      //tank2 direction
	 logic is_bullet, is_boom;
	 logic is_bullet2, is_boom2;                    //variable for tank2
	 logic is_ennumber;                             //this is pointer to the enemy number
	 logic [1:0] is_bullet_out;
	 logic [1:0] is_bullet_out2;                    //variable for tank2
	 logic is_one_tank, are_two_tanks, en_tank, en_state, en_count;
	 logic one_player_mode, two_players_mode;
	 logic chosen;                                  //chosen indicates whether I finished choose or not
	 logic [3:0] en_num;                            //number of enemy chosen in en_state
	 logic en_back;                                 //signal of choosing the background in the enemy state
	 logic en_tank_final;
	 logic [19:0] Dist_X_boom, Dist_Y_boom;
	 logic [19:0] Dist_X_boom2, Dist_Y_boom2;       //vairbale for tank2
	 logic draw_wall, draw_wall_o, draw_wall_b;
	 logic stop_tank_right, stop_tank_up, stop_tank_left, stop_tank_down;
	 logic stop_tank_right2, stop_tank_up2, stop_tank_left2, stop_tank_down2;        //stop variable for tank2
//	 logic stop_bullet_right, stop_bullet_up, stop_bullet_left, stop_bullet_down;
	 logic stop_bullet;
//	 logic stop_bullet_right2, stop_bullet_up2, stop_bullet_left2, stop_bullet_down2;//stope variable for bullet2
	 logic stop_bullet_2;
//	 logic [3:0] stop_tank, stop_bullet;
//	 logic [3:0] stop_tank2 = 0;                    //initialize the stop_tank2 to zero for testing
	 logic is_enemy1, is_enemy1_final;
	 logic [9:0] Enemy1_X_Pos_out, Enemy1_Y_Pos_out;
	 logic enable1, enable2;
	 logic [1:0] is_enemy1_out;
//	 logic stop_enemy1_right, stop_enemy1_up, stop_enemy1_left, stop_enemy1_down;
	 logic [9:0] Right_mid_X_en1, Right_mid_Y_en1, Up_mid_X_en1, Up_mid_Y_en1, Left_mid_X_en1, Left_mid_Y_en1, Down_mid_X_en1, Down_mid_Y_en1; 
	 logic [19:0] Enemy1_DisX, Enemy1_DisY;
	 logic is_bullet_en1, is_boom_en1, en1_hit_player;
	 logic [19:0] Dist_X_boom_en1, Dist_Y_boom_en1;
	 logic [9:0] bulletx_en1, bullety_en1;
	 logic [5:0] player_lives, player_lives_in;
	 logic lives_activate;
	 logic [9:0] ballx, bally, ballx2, bally2;
	 logic [9:0] bulletx, bullety, bulletx2, bullety2;
	 logic [5:0] enemy1_lives, enemy1_lives_in;
	 logic draw_bullet_p1, draw_boom_p1, player_hit_en1, player_hit_en2; // player_hit_en1.******
	 logic draw_bullet_p2, draw_boom_p2;
	 logic heart_enable, is_heart;
	 logic heart_enable2, is_heart2;
	 logic [11:0] heart_code, heart_code2;
	 logic [11:0] end_data;
	 logic stop_bullet21, stop_bullet22;                                //stop_signal for 2 player mode tank 2 on tank1
	 logic [9:0] bulletx1, bullety1;
	 logic player1_hit, player2_hit;
	 logic [5:0] player1_lives, player1_lives_in, player2_lives, player2_lives_in;
	 logic game_mode;
	 logic is_player1, is_player2;
	 logic enable12;
	 logic is_enemy2, is_enemy2_final;
	 logic [9:0] Enemy2_X_Pos_out, Enemy2_Y_Pos_out;
	 logic [1:0] is_enemy2_out; 
	 logic is_bullet_en2, is_boom_en2; 
	 logic [9:0] bulletx_en2, byllety_en2;
	 logic en2_hit_player;
	 logic [9:0] Right_mid_X_en2, Right_mid_Y_en2, Up_mid_X_en2, Up_mid_Y_en2, Left_mid_X_en2, Left_mid_Y_en2, Down_mid_X_en2, Down_mid_Y_en2; 
	 logic [19:0] Enemy2_DisX, Enemy2_DisY;
	 logic [19:0] Dist_X_boom_en2, Dist_Y_boom_en2;
	 logic [5:0] enemy2_lives, enemy2_lives_in;
	 logic [5:0] enemy_lives;
	 logic is_player_en2;
	 assign heart_enable = one_player_mode && (mode == 2'b10);
	 assign heart_enable2 = two_players_mode && (mode == 2'b10);
	 assign game_mode = (enable1 | enable2 | enable12);
	 
	 audio_controller ac(.Clk, .Reset(Reset_h),  .AUD_DACLRCK, .AUD_ADCLRCK,  .AUD_BCLK, 
							  .AUD_DACDAT, 			   .AUD_XCK, 	  .I2C_SCLK, 	  .I2C_SDAT
							 );
	 
	 sp_addr_lookup sal(.is_one_tank, .are_two_tanks, .is_tank_final, .is_tank_final2,
							  .is_tank_out, .is_tank_out2, .DistX(DistX_out), .DistY(DistY_out), .DistX2(DistX_out2), .DistY2(DistY_out2),
							  .DrawX, .DrawY, .Addr_out(sp_address), .en_number, .is_ennumber, .en_num, .is_boom, .is_player1, .is_player2,
							  .player_lives, .enemy1_lives, .mode, .player1_lives, .player2_lives,
							  .*);
 	 
	 bgROM bg(.read_address, .Clk, .data_Out(bg_data));
	 
	 spROM sp(.read_address(sp_address), .Clk, .data_Out(str_data));
	 
	 ennumROM en(.read_address(enemy_address), .Clk, .data_Out(en_data));
	 
	 endROM endrom(.read_address(sp_address), .Clk, .data_Out(end_data));
	 
	 vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

	 tanks_selector ts(.keycode, .Reset(Reset_h), .*);                            //in the backgorund page
	 
	 en_draw es(.Reset(Reset_h), .keycode, .is_tank(en_tank), .is_count(en_count), 
					.en_state, .is_number(en_number), .chosen, .en_num, .is_ennumber,
					.*);
	 
	 en_game eg(.keycode, .VGA_CLK, .Reset(Reset_h), .game_mode, .DrawX, .DrawY, .is_player1, .is_player2, .is_player_en2, .en_num);

    VGA_controller vga_controller_instance(.VGA_CLK(VGA_CLK), .Reset(Reset_h), .Clk(Clk), .*);
	
    tank1 tank1(.frame_clk(VGA_VS), .Reset(Reset_tank), .is_tank, .Ball_X_Pos_out(ballx), .Ball_Y_Pos_out(bally), .*);
	 
	 tank2 tank2(.Clk, .frame_clk(VGA_VS), .Reset(Reset_tank), .two_players_mode, .is_tank(is_tank2), .keycode, 
					 .DrawX, .DrawY,  .Right_mid_X(Right_mid_X2), .Right_mid_Y(Right_mid_Y2), .Up_mid_X(Up_mid_X2), 
					 .Up_mid_Y(Up_mid_Y2), .Left_mid_X(Left_mid_X2), .Left_mid_Y(Left_mid_Y2), .Down_mid_X(Down_mid_X2), .Down_mid_Y(Down_mid_Y2), 
					 .DistX_out(DistX_out2), .DistY_out(DistY_out2), .tank_X_Pos_out(ballx2), .tank_Y_Pos_out(bally2), 
					 .is_tank_out(is_tank_out2), .stop_tank_right(stop_tank_right2), .stop_tank_up(stop_tank_up2), 
					 .stop_tank_left(stop_tank_left2), .stop_tank_down(stop_tank_down2));
    
	 
	 enemy1 en1(.frame_clk(VGA_VS), .Reset(Reset_tank), .is_enemy1, .Enemy1_X_Pos_out, .Enemy1_Y_Pos_out, 
					.enable1, .is_enemy1_out, .DrawX, .DrawY, .playerX(ballx), .playerY(bally), 
					.is_bullet(is_bullet_en1), .is_boom(is_boom_en1), .Bullet_X_Pos(bulletx_en1), 
					.Bullet_Y_Pos(bullety_en1), .player_hit(en1_hit_player), .*);	 
	 
	 enemy2 en2(.frame_clk(VGA_VS), .Reset(Reset_tank), .is_enemy2, .Enemy2_X_Pos_out, .Enemy2_Y_Pos_out, 
	            .enable12, .is_enemy2_out, .DrawX, .DrawY, .playerX(ballx), .playerY(bally), 
					.is_bullet(is_bullet_en2), .is_boom(is_boom_en2), .Bullet_X_Pos(bulletx_en2), 
					.Bullet_Y_Pos(bullety_en2), .player_hit(en2_hit_player), .*);
	 
	 
	 bullets1 bts1(.frame_clk(VGA_VS), .Reset(Reset_tank), .is_tank_in(is_tank_out), .Bullet_X_Pos(bulletx), .Bullet_Y_Pos(bullety), 
					   .draw_bullet(draw_bullet_p1), .draw_boom(draw_boom_p1), .stop_bullet(stop_bullet | stop_bullet21), .*);
	 
	 bullets2 bts2(.is_tank_in(is_tank_out2),  .Clk,                          .frame_clk(VGA_VS),        .Reset(Reset_tank),
				      .is_tank_final2,            .keycode,                      .DrawX,                    .DrawY, 
						.Right_mid_X(Right_mid_X2), .Right_mid_Y(Right_mid_Y2),    .Up_mid_X(Up_mid_X2),      .Up_mid_Y(Up_mid_Y2), 
						.Left_mid_X(Left_mid_X2),   .Left_mid_Y(Left_mid_Y2),      .Down_mid_X(Down_mid_X2),  .Down_mid_Y(Down_mid_Y2),
                  .Dist_X_boom(Dist_X_boom2), .Dist_Y_boom(Dist_Y_boom2),    .is_bullet(is_bullet2), 
						.is_boom(is_boom2),         .is_bullet_out(is_bullet_out2), .stop_bullet(stop_bullet2 | stop_bullet22),
						.Bullet_X_Pos(bulletx2), 	 .Bullet_Y_Pos(bullety2),       .two_players_mode,
					   .draw_bullet(draw_bullet_p2),                              .draw_boom(draw_boom_p2)	
					  );
    
	 color_mapper color_instance(.*, .is_tank_final2, .code(code));
	 

	 heart_mapper1 hm1(.Clk, .heart_enable, .DrawX, .DrawY, .is_heart, .code(heart_code), 
						  .remaining_hearts(player_lives), .remaining_hearts_en(enemy1_lives), .enable12, .remaining_hearts_en2(enemy2_lives));
	 // lives chooser.
	 
	 heart_mapper_2p hm2(.Clk, .heart_enable(heart_enable2), .DrawX, .DrawY, .is_heart(is_heart2), .code(heart_code2), 
						  .remaining_hearts(player1_lives), .remaining_hearts_en(player2_lives));

	 wall wl(.DrawX, .DrawY, .draw_wall, .draw_wall_o, .draw_wall_b, .Ball_X_Pos(ballx), 
				.Ball_Y_Pos(bally), .Bullet_X_Pos(bulletx), .Bullet_Y_Pos(bullety), 
				.enemy1_X_Pos(Enemy1_X_Pos_out), .enemy1_Y_Pos(Enemy1_Y_Pos_out), 
				.enemy2_X_Pos(Enemy2_X_Pos_out), .enemy2_Y_Pos(Enemy2_Y_Pos_out),
				.enable1, 
				.draw_bullet(draw_bullet_p1), .draw_boom(draw_boom_p1), .enable2, .enable12,
				.bulletx2, .bullety2, .stop_bullet2(stop_bullet22), .player2_hit,
				.*
			  );
			  
	 wall2 wl2(.DrawX,                              .DrawY,                              .Ball_X_Pos(ballx2),              .Ball_Y_Pos(bally2),
				 .Bullet_X_Pos(bulletx2),             .Bullet_Y_Pos(bullety2),  
				 .stop_tank_right(stop_tank_right2),  .stop_tank_up(stop_tank_up2),        .stop_tank_left(stop_tank_left2), .stop_tank_down(stop_tank_down2), 
				 .stop_bullet(stop_bullet2),          .stop_bullet21,                      .bulletx1,                         .bullety1,
				 .ballx,                              .bally,                              .player1_hit, 
				 .draw_bullet(draw_bullet_p2),        .draw_boom(draw_boom_p2)
				);
	 
	 
	 HexDriver hex_inst_4 (keycode[15:12], HEX3);
	 HexDriver hex_inst_3 (keycode[11:8], HEX2);
	 HexDriver hex_inst_2 (keycode[7:4], HEX1);
	 HexDriver hex_inst_1 (keycode[3:0], HEX0);
	 
//	 always_comb 
//	 begin
//		enemy_lives = enemy1_lives;
//		if (en_num == 4'b0010)
//		enemy_lives = enemy1_lives + enemy2_lives;
//	 end
	 
	 // Lives register for enemy in single player mode!!!
	 always_ff @ (posedge Clk)
	 begin
	 if (Reset_h || lives_activate)
		enemy1_lives <= 6'd5;
	 else 
		enemy1_lives <= enemy1_lives_in;
	 end 
	 
	 always_comb
	 begin
		enemy1_lives_in = enemy1_lives;
		if (one_player_mode && player_hit_en1)
			enemy1_lives_in = enemy1_lives - 1;
	 end
	 
	 always_ff @ (posedge Clk) 
	 begin
	 if (Reset_h || lives_activate)
		player_lives <= 6'd5;
	 else 
		player_lives <= player_lives_in;
	 end
	  
	 always_comb 
	 begin
		player_lives_in = player_lives;
		if (one_player_mode && en1_hit_player)
			player_lives_in = player_lives - 1;
		if (one_player_mode && en2_hit_player)
			player_lives_in = player_lives - 1;
	 end
	 
	 always_ff @ (posedge Clk) 
	 begin
	 if (Reset_h || lives_activate)
	 
		enemy2_lives <= 6'd5;
	 else
		enemy2_lives <= enemy2_lives_in;
	 end
	 
	 always_comb 
	 begin
		enemy2_lives_in = enemy2_lives;
		if (one_player_mode && player_hit_en2)
			enemy2_lives_in = enemy2_lives - 1;
	 end
	 
	 ///////////////////two player mode HPs////////////////////////
	 
	 always_ff @ (posedge Clk)
	 begin
	 if (Reset_h || lives_activate)
		player1_lives <= 6'd5;
	 else 
		player1_lives <= player1_lives_in;
	 end 
	 
	 always_comb
	 begin
		player1_lives_in = player1_lives;
		if (enable2 && player1_hit)
			player1_lives_in = player1_lives - 1;
	 end
	 
	 always_ff @ (posedge Clk) 
	 begin
	 if (Reset_h || lives_activate)
		player2_lives <= 6'd5;
	 else 
		player2_lives <= player2_lives_in;
	 end
	  
	 always_comb 
	 begin
		player2_lives_in = player2_lives;
		if (enable2 && player2_hit)
			player2_lives_in = player2_lives - 3'd1;
	 end
	 
	 logic [19:0] enemy_address;
	 assign enemy_address = ((DrawY_ext >> 3) * 20'd80 + (DrawX_ext >> 3));
	 
	 always_comb 
	 begin
		DrawX_ext[19:10] = {10{1'b0}};
		DrawX_ext[9:0] = DrawX;
		DrawY_ext[19:10] = {10{1'b0}};
		DrawY_ext[9:0] = DrawY;
		read_address = ((DrawY_ext >> 1) * 20'd320 + (DrawX_ext >> 1));
		
	 end

	 always_comb 
	 begin
		bulletx1 = 10'b0; 
		bullety1 = 10'b0;
		if(enable2)
			bulletx1 = bulletx;
			bullety1 = bullety;
	 end
	 
	 always_comb                             //for tank1
	 begin
		if (is_tank == 1'b1 && mode == 2'b10)
			is_tank_final = 1'b1;
		else 
			is_tank_final = 1'b0;
	 end
	 
	 always_comb
	 begin
		if (is_tank2 == 1'b1 && mode == 2'b10 && two_players_mode == 1'b1)
			is_tank_final2 = 1'b1;
		else
			is_tank_final2 = 1'b0;
	 end
// Enemies block!!!!!
// enemy 1 block!!!!!
	 always_comb
	 begin
//		if (is_enemy1 == 1'b1 && mode == 2'b10 && one_player_mode == 1'b1)
//			is_enemy1_final = 1'b1;
//		else
//			is_enemy1_final = 1'b0;
		if ((en_num == 4'b0001 || en_num == 4'b0010) && mode == 2'b10 && enable1 == 1'b1)
			is_enemy1_final = is_enemy1;
		else 
			is_enemy1_final = 1'b0;
	 end
	 
// enemy 2 block!!!!!!
    always_comb
	 begin
		if (en_num == 4'b0010 && mode == 2'b10 && enable12 == 1'b1)
			is_enemy2_final = is_enemy2;
		else
			is_enemy2_final = 1'b0;
	 end
// enemy2 block ends.

	 always_comb
	 begin
		if (en_tank == 1'b1 && mode == 2'b01)
			en_tank_final = 1'b1;
		else
			en_tank_final = 1'b0;
	end
	 
	 always_comb 
	 begin
		if (mode == 2'b00 && is_one_tank == 0 && are_two_tanks == 0)
			code = bg_data;
		else if (is_one_tank == 1 || are_two_tanks == 1 || is_tank_final == 1'b1 || en_number == 1 || en_tank_final == 1 
				   || is_ennumber == 1|| en_count == 1 || is_boom == 1 || is_boom2 == 1 || is_tank_final2 == 1'b1 )
			code = str_data;
	   else if (is_enemy1_final || is_enemy2_final || is_boom_en1 || is_boom_en2)
			code = str_data;
		else if (is_heart)
			code = heart_code;
		else if (is_heart2)
			code = heart_code2;
		else if (is_player1 == 1 || is_player2 == 1 || is_player_en2 == 1)
			code = str_data;
		else if(en_state == 1)
			code = en_data;
		else if(mode == 2'b11)
			code = end_data;
		else 
			code = 12'h000;
	 end
		
	 enum logic [3:0] {BG, BG_WAIT, EN, EN_WAIT, GAME_RST1, GAME1, GAME_RST2, GAME2, END} State, Next_State;
	 
	 always_ff @ (posedge Clk) 
	 begin
		if (Reset_h) 
			State <= BG;
		else
			State <= Next_State;
	 end
	 
	 always_comb
		begin
		mode = 2'b00;
		Reset_tank = 1'b0;
		en_state = 1'b0;
		enable1 = 1'b0;
		enable2 = 1'b0;
		enable12 = 1'b0;
		lives_activate = 1'b0;
		unique case (State)
			BG:
				begin
				if ((one_player_mode == 1 || two_players_mode == 1) && (keycode[7:0] == 8'h2c || keycode[7:0] == 8'h28))
					Next_State = BG_WAIT;
				else 
					Next_State = BG;
				end
			BG_WAIT:
				begin 
				if ((one_player_mode == 1 || two_players_mode == 1) && (keycode[7:0] == 8'h2c || keycode[7:0] == 8'h28))
					Next_State = BG_WAIT;
				else if (one_player_mode)
					Next_State = EN;
				else 
					Next_State = GAME_RST2;
				end
			EN: 
				begin
					if ( ( keycode[7:0] == 8'h2c || keycode[7:0] == 8'h28) && (chosen == 1))
						Next_State = EN_WAIT;
					else
						Next_State = EN;
				end
			EN_WAIT:
				begin
					if (keycode[7:0] == 8'h00)
						Next_State = GAME_RST1;
					else
						Next_State = EN_WAIT;
				end
			GAME_RST1:
				begin
					if (keycode[7:0] == 8'h00)
						Next_State = GAME1;
					else 
						Next_State = GAME_RST1;
				end
			GAME1:
				begin
					if (en_num == 4'b0000)
						Next_State = END;
					else if ((player_lives == 6'd0 || enemy1_lives == 6'd0 ) && en_num == 4'b0001)
						Next_State = END;
//					else if ((player_lives == 6'd0 || enemy1_lives + enemy2_lives == 6'd0) && en_num == 4'b0010)
//						Next_State = END;
					else if (en_num == 4'b0010)
					begin
						if (player_lives == 6'd0 || enemy1_lives + enemy2_lives == 0)
							Next_State = END;
						else 
							Next_State = GAME1;
					end
					else
						Next_State = GAME1;
				end
			GAME_RST2:
				begin
					if (keycode[7:0] == 8'h00)
						Next_State = GAME2;
					else 
						Next_State = GAME_RST2;
				end
			GAME2: 
				begin
					if (player1_lives == 6'd0 ||player2_lives == 6'd0)
						Next_State = END;
					else 
						Next_State = GAME2;
				end
			END:
			begin
				if (keycode[7:0] == 8'h14)
					Next_State = BG;
				else
					Next_State = END;
			end
		endcase
		
		case (State) 
			BG: mode = 2'b00;
			BG_WAIT: mode = 2'b00;
			EN:
			begin
				mode = 2'b01;
				en_state = 1'b1;
			end
			EN_WAIT: 
			begin
				mode = 2'b01;
				en_state = 1'b1;
			end
			GAME_RST1: 
				begin
					Reset_tank = 1'b1;
					mode = 2'b10;
					lives_activate = 1'b1;
					if (en_num == 4'b0001)
					enable1 = 1'b1;
					if (en_num == 4'b0010)
					begin
						enable1 = 1'b1;
						enable12 = 1'b1;
					end
				end	
			GAME1:
				  begin
				  mode = 2'b10;
				  if (en_num == 4'b0001)
					enable1 = 1'b1;
				  if (en_num == 4'b0010)
				  begin
					if (enemy2_lives > 0 && enemy2_lives <= 5)
						enable12 = 1'b1;
					if (enemy1_lives > 0 && enemy2_lives <= 5)
						enable1 = 1'b1;
				  end
				  end
			GAME_RST2: 
				begin
					Reset_tank = 1'b1;
					mode = 2'b10;
					lives_activate = 1'b1;
					enable2 = 1'b1;
				end	
			GAME2:
			begin
				  mode = 2'b10;
				  enable2 = 1'b1;
			end
			END: mode = 2'b11;
		endcase
end
	 
endmodule
