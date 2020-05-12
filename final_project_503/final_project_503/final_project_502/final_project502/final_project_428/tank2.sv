//-------------------------------------------------------------------------
//    Tank2.sv                                                            --
//    Heyi Tao                                                        --
//    Spring 2020                                                      --
//                                                                       --
//    Hongshuo Zhang niu bi                                        --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  tank2( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  two_players_mode,   // Two_players_mode
					input  [31:0] keycode,
               input  [9:0]  DrawX, DrawY,       // Current pixel coordinates
					input  stop_tank_right, stop_tank_up, stop_tank_left, stop_tank_down,
					output [9:0]  Right_mid_X, Right_mid_Y, 
				   output [9:0]  Up_mid_X, Up_mid_Y,
					output [9:0]  Left_mid_X, Left_mid_Y,
					output [9:0]  Down_mid_X, Down_mid_Y,
					output [19:0] DistX_out, DistY_out,
					output [9:0]  tank_X_Pos_out, tank_Y_Pos_out,
               output logic  is_tank,             // Whether current pixel belongs to tank or background
					output [1:0]  is_tank_out
              );
    
    parameter [9:0] tank_X_Start = 10'd2;    // top_left corner x coordinate of the tank
    parameter [9:0] tank_Y_Start = 10'd30;     // top_left corner y coordinate of the tank
    parameter [9:0] tank_X_Min = 10'd2;      // Leftmost point on the X axis
    parameter [9:0] tank_X_Max = 10'd476;    // Rightmost point on the X axis
    parameter [9:0] tank_Y_Min = 10'd22;     // Topmost point on the Y axis
    parameter [9:0] tank_Y_Max = 10'd478;    // Bottommost point on the Y axis
    parameter [9:0] tank_X_Step = 10'd2;     // Step size on the X axis
    parameter [9:0] tank_Y_Step = 10'd2;     // Step size on the Y axis
    parameter [9:0] tank_Size = 10'd19;      // tank size
    
    logic [9:0] tank_X_Pos, tank_X_Motion, tank_Y_Pos, tank_Y_Motion;
    logic [9:0] tank_X_Pos_in, tank_X_Motion_in, tank_Y_Pos_in, tank_Y_Motion_in;
	 logic [1:0] is_tank_dir, is_tank_in;
	 logic u_on, l_on, d_on, r_on, all_off;
	 assign is_tank_out = is_tank_dir;
    logic new_instance;
	 
	 assign u_on = (keycode[31:24] == 8'h25 | keycode[23:16] == 8'h25 | keycode[15: 8] == 8'h25 | keycode[ 7: 0] == 8'h25); //up 8:25
 
    assign l_on = (keycode[31:24] == 8'h18 | keycode[23:16] == 8'h18 | keycode[15: 8] == 8'h18 | keycode[ 7: 0] == 8'h18); //left u:18
	 
	 assign d_on = (keycode[31:24] == 8'h0c | keycode[23:16] == 8'h0c | keycode[15: 8] == 8'h0c | keycode[ 7: 0] == 8'h0c); //down i:0c
	 
	 assign r_on = (keycode[31:24] == 8'h12 | keycode[23:16] == 8'h12 | keycode[15: 8] == 8'h12 | keycode[ 7: 0] == 8'h12); //right o:12
	 
	 assign all_off = (!u_on && !l_on &&  !d_on && !r_on);
	 
	 
	 
	 enum logic [1:0] {FIRST, FIRST_WAIT, OTHER} State, Next_State;
	 always_ff @ (posedge Clk) 
	 begin
		if (Reset)	
			State <= FIRST;
		else 
			State <= Next_State;
	 end
	 
	 always_comb 
	 begin
	 new_instance = 1'b1;
	 unique case (State)
		FIRST: 
			if (~two_players_mode)
				Next_State = FIRST;
			else
			Next_State = FIRST_WAIT;
		FIRST_WAIT:
			if (keycode == 8'h00)
				Next_State = OTHER;
			else 
				Next_State = FIRST_WAIT;
		OTHER:
			Next_State = OTHER;
		endcase
		
	 case (State)
		FIRST: 
			new_instance = 1'b1;
		FIRST_WAIT:
			new_instance = 1'b1;
		OTHER: 
			new_instance = 1'b0;
	 endcase
	 end
	 
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
        if (Reset || new_instance)
        begin
            tank_X_Pos <= tank_X_Start;
            tank_Y_Pos <= tank_Y_Start;
            tank_X_Motion <= 10'd0;
            tank_Y_Motion <= tank_Y_Step;
				is_tank_dir <= 2'b00; //00 Right, 01 up, 10 left, 11 down
        end
        else
        begin
            tank_X_Pos <= tank_X_Pos_in;
            tank_Y_Pos <= tank_Y_Pos_in;
            tank_X_Motion <= tank_X_Motion_in;
            tank_Y_Motion <= tank_Y_Motion_in;
				is_tank_dir <= is_tank_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        tank_X_Pos_in = tank_X_Pos;
        tank_Y_Pos_in = tank_Y_Pos;
        tank_X_Motion_in = tank_X_Motion;
        tank_Y_Motion_in = tank_Y_Motion;
        is_tank_in = is_tank_dir;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				if (all_off)
				begin
							tank_Y_Motion_in = 10'b0;  // 2's complement.  
							tank_X_Motion_in = 10'b0;
				end
				else if( u_on )  // W (Up) Code 2'b01
				begin
					is_tank_in = 2'b01;
					if (tank_Y_Pos > tank_Y_Min && stop_tank_up == 1'b0)
					begin
						tank_Y_Motion_in = (~(tank_Y_Step) + 1'b1);  // 2's complement.  
						tank_X_Motion_in = 10'b0;
					end
					else
					begin
						tank_Y_Motion_in = 10'b0;  // 2's complement.  
						tank_X_Motion_in = 10'b0;
					end
				end
            else if ( d_on )
				begin 														// S (Down) Code 2'b11
					is_tank_in = 2'b11;
					if (tank_Y_Pos + tank_Size < tank_Y_Max && stop_tank_down == 1'b0)
					begin
						tank_Y_Motion_in = tank_Y_Step;
						tank_X_Motion_in = 10'b0;
					end 
					else 
					begin
						tank_Y_Motion_in = 10'b0;  // 2's complement.  
						tank_X_Motion_in = 10'b0;
					end
				end
				else if( l_on )  // A (Left) Code 2'b10
				begin
					is_tank_in = 2'b10;
					if (tank_X_Pos > tank_X_Min && stop_tank_left == 1'b0)
					begin
						tank_X_Motion_in = (~(tank_X_Step) + 1'b1);  // 2's complement.
						tank_Y_Motion_in = 10'b0;
					end
					else 
					begin
						tank_Y_Motion_in = 10'b0;  // 2's complement.  
						tank_X_Motion_in = 10'b0;
					end
				end
            else if ( r_on )  // D (Right) Code 2'b00;
				begin
					is_tank_in = 2'b00;
					if (tank_X_Pos + tank_Size < tank_X_Max && stop_tank_right == 1'b0)
						begin
							tank_X_Motion_in = tank_X_Step;
							tank_Y_Motion_in = 10'b0;
						end
					else
						begin
							tank_Y_Motion_in = 10'b0;  // 2's complement.  
							tank_X_Motion_in = 10'b0;
						end
				end
	
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. tank_Y_Pos - tank_Size <= tank_Y_Min 
            // If tank_Y_Pos is 0, then tank_Y_Pos - tank_Size will not be -4, but rather a large positive number.
			

            // Update the tank's position with its motion
            tank_X_Pos_in = tank_X_Pos + tank_X_Motion;
            tank_Y_Pos_in = tank_Y_Pos + tank_Y_Motion;
        end
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that tank_Y_Pos is updated using tank_Y_Motion. 
              Will the new value of tank_Y_Motion be used when tank_Y_Pos is updated, or the old? 
              What is the difference between writing
                "tank_Y_Pos_in = tank_Y_Pos + tank_Y_Motion;" and 
                "tank_Y_Pos_in = tank_Y_Pos + tank_Y_Motion_in;"?
              How will this impact behavior of the tank during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    
    // Compute whether the pixel corresponds to tank or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
	 //logic [19:0] DistX_out, DistY_out;
    assign DistX = DrawX - tank_X_Pos;
    assign DistY = DrawY - tank_Y_Pos;
	 assign DistX_out = DistX;
	 assign DistY_out = DistY;
    assign Size = tank_Size;
	 assign Right_mid_X = tank_X_Pos + tank_Size;
	 assign Right_mid_Y = tank_Y_Pos + (tank_Size >> 1);
	 assign Up_mid_X = tank_X_Pos + (tank_Size >> 1);	
	 assign Up_mid_Y = tank_Y_Pos;
	 assign Left_mid_X = tank_X_Pos;
	 assign Left_mid_Y = tank_Y_Pos + (tank_Size >> 1);
	 assign Down_mid_X = tank_X_Pos + (tank_Size >> 1);
	 assign Down_mid_Y = tank_Y_Pos + tank_Size;
	 assign tank_X_Pos_out = tank_X_Pos;
	 assign tank_Y_Pos_out = tank_Y_Pos;
	 
    always_comb begin
        if ( DistX >= 0 && DistX < Size && DistY >= 0 && DistY < Size) 
            is_tank = 1'b1;
        else
            is_tank = 1'b0;
    end
    
endmodule
