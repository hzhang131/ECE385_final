To do list:
1. Two player state already reserved for you in lab8.sv. 
   Please implement the following functionalities:
   
   a. Stop bullet once it hits another tank. (Look at enemy_wall.sv from line 153 to 157 for reference.) (check)
   b. Stop tank once it hits another tank. (Look at enemy_wall.sv from line 98 to 116 for reference. ) (check)
   c. Setup lives counter in lab8.sv and decrement counter when necessary (Look at lab8.sv from line 197 to 226 for reference).(check)
   d. send a signal whenever a tank is hit by a bullet. This should be implemented in a tank's own wall module. (check)
   e. draw number of hearts on the right status bar. (Look at heart.sv for reference.) (check)
   f. exits the game state once one tank runs out of lives. (check)
   g. Please draw two cute tanks on the right tank for both modes. Thank you! (check) (you are welcome)
   h. load the end screens. (check)

# Note:
1. heart.txt has two colors and it is 20x20.
2. Don't draw hearts too close to each other, it will crash the vga_controller for some reason.

Happy coding!!!

is_enemy1                                // logic to draw the first enemy tank
is_enemy1_final                          // logic to draw the first enemy tank in the game mode.
enable1                                  // enable logic for the one enemy one player mode.
is_enemy1_out                            // direction vector for the enemy1 tank. Unused.
Right_*, Left_*, Up_*, .Down_* 		 // 8 coordinates to be used by enemy_bullets.
is_bullet_en1 				 // is_bullet for en1.
is_boom_en1 				 // is_boom for en1.
en1_hit_player    			 // signal for en1 hitting the player, to be used to decrement lives.
Dist_X_boom_en1, Dist_Y_boom_en1 	 // Boom graphic for enemy 1, to be used by sp_addr_lookup
bulletx_en1, bullety_en1 		 // x y position of enemy1 bullet.
player_lives, player_lives_in 		 // lives register and lives register input.
lives_activate  			 // initialise lives to be 5.
ballx, bally, ballx2, bally2 		 // positions for two players in two player mode.
bulletx, bullety, bulletx2, bullety2 	 // positions for two bullets in two player mode.
enemy1_lives, enemy1_lives_in 		 // self explanatory.
draw_bullet_p1, draw_boom_p1 		 // bullet / boom ready signal for player one in both modes.
player_hit_en1 				 // self explanatory
heart_enable 				 // enable signal to draw hearts on the right bar.
is_heart 				 // similar to is_tank.
heart_code 				 // 12 bit rob value for hearts.