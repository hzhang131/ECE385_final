//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  tank1( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [31:0]   keycode,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input stop_tank_right, stop_tank_up, stop_tank_left, stop_tank_down,
					output [9:0]  Right_mid_X, Right_mid_Y, 
				   output [9:0]  Up_mid_X, Up_mid_Y,
					output [9:0]  Left_mid_X, Left_mid_Y,
					output [9:0]  Down_mid_X, Down_mid_Y,
					output [19:0] DistX_out, DistY_out,
					output [9:0] Ball_X_Pos_out, Ball_Y_Pos_out,
               output logic  is_tank,             // Whether current pixel belongs to ball or background
					output [1:0] is_tank_out           //direction of the tank
              );
    
    parameter [9:0] Ball_X_Start = 10'd2;  // Center position on the X axis
    parameter [9:0] Ball_Y_Start = 10'd458;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd2;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd476;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd22;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd478;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd2;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd19;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 logic [1:0] is_tank_dir, is_tank_in;
	 assign is_tank_out = is_tank_dir;
    logic new_instance;
	 logic all_off, w_on, a_on, s_on, d_on;
	 enum logic [1:0] {FIRST, FIRST_WAIT, OTHER} State, Next_State;
	 
	 assign all_off = (!w_on && !a_on &&  !s_on && !d_on);
	 
	 assign w_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
 
    assign a_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
	 
	 assign s_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
	 
	 assign d_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);
	 
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
            Ball_X_Pos <= Ball_X_Start;
            Ball_Y_Pos <= Ball_Y_Start;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
				is_tank_dir <= 2'b00; //00 Right, 01 up, 10 left, 11 down
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
				is_tank_dir <= is_tank_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        is_tank_in = is_tank_dir;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				if (all_off)
				begin
							Ball_Y_Motion_in = 10'b0;  // 2's complement.  
							Ball_X_Motion_in = 10'b0;
				end
				else if( w_on )  // W (Up) Code 2'b01
				begin
					is_tank_in = 2'b01;
					if (Ball_Y_Pos > Ball_Y_Min && stop_tank_up == 1'b0)
					begin
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
						Ball_X_Motion_in = 10'b0;
					end
					else
					begin
						Ball_Y_Motion_in = 10'b0;  // 2's complement.  
						Ball_X_Motion_in = 10'b0;
					end
				end
            else if ( s_on )
				begin 														// S (Down) Code 2'b11
					is_tank_in = 2'b11;
					if (Ball_Y_Pos + Ball_Size < Ball_Y_Max && stop_tank_down == 1'b0)
					begin
						Ball_Y_Motion_in = Ball_Y_Step;
						Ball_X_Motion_in = 10'b0;
					end 
					else 
					begin
						Ball_Y_Motion_in = 10'b0;  // 2's complement.  
						Ball_X_Motion_in = 10'b0;
					end
				end
				else if( a_on )  // A (Left) Code 2'b10
				begin
					is_tank_in = 2'b10;
					if (Ball_X_Pos > Ball_X_Min && stop_tank_left == 1'b0)
					begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
						Ball_Y_Motion_in = 10'b0;
					end
					else 
					begin
						Ball_Y_Motion_in = 10'b0;  // 2's complement.  
						Ball_X_Motion_in = 10'b0;
					end
				end
            else if ( d_on )  // D (Right) Code 2'b00;
				begin
					is_tank_in = 2'b00;
					if (Ball_X_Pos + Ball_Size < Ball_X_Max && stop_tank_right == 1'b0)
						begin
							Ball_X_Motion_in = Ball_X_Step;
							Ball_Y_Motion_in = 10'b0;
						end
					else
						begin
							Ball_Y_Motion_in = 10'b0;  // 2's complement.  
							Ball_X_Motion_in = 10'b0;
						end
				end
	
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
			

            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
	 //logic [19:0] DistX_out, DistY_out;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
	 assign DistX_out = DistX;
	 assign DistY_out = DistY;
    assign Size = Ball_Size;
	 assign Right_mid_X = Ball_X_Pos + Ball_Size;
	 assign Right_mid_Y = Ball_Y_Pos + (Ball_Size >> 1);
	 assign Up_mid_X = Ball_X_Pos + (Ball_Size >> 1);	
	 assign Up_mid_Y = Ball_Y_Pos;
	 assign Left_mid_X = Ball_X_Pos;
	 assign Left_mid_Y = Ball_Y_Pos + (Ball_Size >> 1);
	 assign Down_mid_X = Ball_X_Pos + (Ball_Size >> 1);
	 assign Down_mid_Y = Ball_Y_Pos + Ball_Size;
	 assign Ball_X_Pos_out = Ball_X_Pos;
	 assign Ball_Y_Pos_out = Ball_Y_Pos;
    always_comb begin
        if ( DistX >= 0 && DistX < Size && DistY >= 0 && DistY < Size) 
            is_tank = 1'b1;
        else
            is_tank = 1'b0;
    end
    
endmodule
