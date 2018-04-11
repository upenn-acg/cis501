/*
 * FlappyBird.c : Camillo J. Taylor - Oct. 27, 2015
 */

#include "lc4libc.h"
#include "stdio.h"


/*
 * #############  DATA STRUCTURES THAT STORE THE GAME STATE ######################
 */

#define BIRD_X_START    35
#define BIRD_Y_START    62

// Maximum vertical velocity of the bird
#define MAX_VY           5

// Height of the gap in each pipe in pixels
#define GAP_HEIGHT      60

// Minimum value of gap_start parameter
#define GAP_START_MIN    5

// Maximum value of gap_start parameter
#define GAP_START_MAX   58

// Width of each pipe in pixels
#define PIPE_WIDTH      10


// These values include the position and velocity of the bird on the screen.
// Note that the x position and velocity do not change

// bird_x and bird_y denote the position of the upper left corner of the bird which is modeled
// as an 8x8 block of pixels.
int bird_x = BIRD_X_START;
int bird_y = BIRD_Y_START;

int bird_vx = 1;
int bird_vy = 0;

int ay = 0;
int counter = 0;

typedef struct {
  int xpos;  // current x position of left side of pipe
  int gap_start; // row on which gap starts
  int gap_end;  // row on which gap ends
} pipe_struct;

// Array containing all of the information on the pipes
pipe_struct the_pipes[4];

// Score contains the number of pipes that you have successfully traversed
int score = -1;

/*
 * #############  UTILITY ROUTINES ######################
 */


//
// routine for printing out 2C 16 bit numbers on the ASCII display
//
void printnum (int n) {
  int abs_n;
  char str[10], *ptr;

  // Corner case (n == 0)
  if (n == 0) {
    lc4_puts ((lc4uint*)"0");
    return;
  }
 
  abs_n = (n < 0) ? -n : n;

  // Corner case (n == -32768) no corresponding +ve value
  if (abs_n < 0) {
    lc4_puts ((lc4uint*)"-32768");
    return;
  }

  ptr = str + 10; // beyond last character in string

  *(--ptr) = 0; // null termination

  while (abs_n) {
    *(--ptr) = (abs_n % 10) + 48; // generate ascii code for digit
    abs_n /= 10;
  }

  // Handle -ve numbers by adding - sign
  if (n < 0) *(--ptr) = '-';

  lc4_puts((lc4uint*)ptr);
}

void endl () {
  lc4_puts((lc4uint*)"\n");
}

// rand16 returns a pseudo-random between 0 and 128 by simulating the action of a 16 bit Linear Feedback Shift Register.
int rand16 ()
{
  int lfsr;

  // Advance the lfsr seven times
  lfsr = lc4_lfsr();
  lfsr = lc4_lfsr();
  lfsr = lc4_lfsr();
  lfsr = lc4_lfsr();
  lfsr = lc4_lfsr();
  lfsr = lc4_lfsr();
  lfsr = lc4_lfsr();

  // return the last 7 bits
  return (lfsr & 0x7F);
}

/*
 * #############  CODE THAT DRAWS THE SCENE ######################
 */

// Define the bird sprite - an array of 64 words specifying the sprite colors in row major order
lc4uint bird_sprite [] = {
  RED, RED, BLACK, RED, RED, RED, BLACK, BLACK,
  RED, RED, RED, RED, WHITE, WHITE, RED, BLACK,
  BLACK, RED, RED, RED, WHITE, WHITE, RED, RED,
  BLACK, BLACK, RED, RED, RED, RED, RED, RED,
  BLACK, BLACK, RED, RED, RED, RED, RED, RED,
  BLACK, BLACK, RED, RED, RED, RED, RED, RED,
  BLACK, BLACK, YELLOW, RED, RED, YELLOW, RED, BLACK,
  BLACK, BLACK, YELLOW, YELLOW, BLACK, YELLOW, YELLOW, BLACK
};

lc4uint bird_sprite2 [] = {
  BLACK, BLACK, BLACK, RED, RED, RED, BLACK, BLACK,
  BLACK, BLACK, RED, RED, WHITE, WHITE, RED, BLACK,
  RED, BLACK, RED, RED, WHITE, WHITE, RED, RED,
  RED, RED, RED, RED, RED, RED, RED, RED,
  RED, RED, RED, RED, RED, RED, RED, RED,
  BLACK, RED, RED, RED, RED, RED, RED, RED,
  BLACK, BLACK, YELLOW, RED, RED, YELLOW, RED, BLACK,
  BLACK, BLACK, YELLOW, YELLOW, BLACK, YELLOW, YELLOW, BLACK
};

// Score Sprites
lc4uint s_zero [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_one [] = {
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_two [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, BLACK, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_three [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_four [] = {
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
};

lc4uint s_five [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, BLACK, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_six [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, BLACK, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_seven [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_eight [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
};

lc4uint s_nine [] = {
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
  BLACK, BLACK, BLACK, BLACK, BLACK, WHITE, BLACK, BLACK,
};



void draw_pipes ()
{
  /**
     draw_pipes should draw all of the pipe elements based on their current position using the lc4_draw_rect function. Notice that you should use this
     function to draw the borders of the pipe as opposed to just drawing filled pipes. This approach is more efficient since you don't need to fill in as many pixels.
     note that the constant PIPE_WIDTH specifies the width of each pipe in pixels.
   **/
  
  /// YOUR CODE HERE
  int c;
  for(c=0; c <4; c=c+1){
    lc4_draw_rect(the_pipes[c].xpos, 0, 1, the_pipes[c].gap_start, GREEN);
    lc4_draw_rect(the_pipes[c].xpos, the_pipes[c].gap_end, 1, 124-the_pipes[c].gap_end, GREEN);
    lc4_draw_rect(the_pipes[c].xpos+PIPE_WIDTH, 0, 1, the_pipes[c].gap_start, GREEN);
    lc4_draw_rect(the_pipes[c].xpos+PIPE_WIDTH, the_pipes[c].gap_end, 1, 124-the_pipes[c].gap_end, GREEN);
    lc4_draw_rect(the_pipes[c].xpos, the_pipes[c].gap_start, PIPE_WIDTH+1, 1, GREEN);
    lc4_draw_rect(the_pipes[c].xpos, the_pipes[c].gap_end, PIPE_WIDTH, 1, GREEN);
  }

}

void draw_bird ()
{
  /**
     draw_bird should use the lc4_draw_sprite command to draw an 8x8 sprite at the birds current position
     Note the bird_x and bird_y denote the upper left corner of the bird
  **/

  /// YOUR CODE HERE
  if(counter < 2){
    lc4_draw_sprite(bird_x, bird_y, bird_sprite);
  } else {
    lc4_draw_sprite(bird_x, bird_y, bird_sprite2);
  }
}

void redraw ()
{
  // This function assumes that PennSim is being run in double buffered mode
  // In this mode we first clear the video memory buffer with lc4_reset_vmem,
  // then draw the scene, then call lc4_blt_vmem to swap the buffer to the screen
  // NOTE that you need to run PennSim with the following command:
  // java -jar PennSim.jar -d

  lc4_reset_vmem();

  draw_pipes ();
  draw_bird ();

  if(score<10){
    lc4_draw_sprite(0, 0, s_zero);
  } else if (score<20){
    lc4_draw_sprite(0, 0, s_one);
  } else if (score<30){
    lc4_draw_sprite(0, 0, s_two);
  } else if (score<40){
    lc4_draw_sprite(0, 0, s_three);
  } else if (score<50){
    lc4_draw_sprite(0, 0, s_four);
  } else if (score<70){
    lc4_draw_sprite(0, 0, s_five);
  } else if (score<70){
    lc4_draw_sprite(0, 0, s_six);
  } else if (score<80){
    lc4_draw_sprite(0, 0, s_seven);
  } else if (score<90){
    lc4_draw_sprite(0, 0, s_eight);
  } else if (score<100){
    lc4_draw_sprite(0, 0, s_nine);
  } 
 
  if (score%10 == -1){
    lc4_draw_sprite(6, 0, s_zero);
  } else if(score%10 == 1){
    lc4_draw_sprite(6, 0, s_one);
  } else if (score%10 == 2){
    lc4_draw_sprite(6, 0, s_two);
  } else if (score%10 == 3){
    lc4_draw_sprite(6, 0, s_three);
  } else if (score%10 == 4){
    lc4_draw_sprite(6, 0, s_four);
  } else if (score%10 == 5){
    lc4_draw_sprite(6, 0, s_five);
  } else if (score%10 == 6){
    lc4_draw_sprite(6, 0, s_six);
  } else if (score%10 == 7){
    lc4_draw_sprite(6, 0, s_seven);
  } else if (score%10 == 8){
    lc4_draw_sprite(6, 0, s_eight);
  } else if (score%10 == 9){
    lc4_draw_sprite(6, 0, s_nine);
  } else if (score%10 == 0){
    lc4_draw_sprite(6, 0, s_zero);
  }
			      
  lc4_blt_vmem();
}

/*
 * #############  CODE THAT HANDLES GAME PLAY ######################
 */

void reset_game_state ()
{
  /**
     This function needs to do a few things.

     0) reset the score to 0     
     1) Reset the position of the bird
     2) Reset the velocity of the bird to 0
     3) Reset the positions and gaps of all of the pipes. The left edges of the pipes should occur every 32 pixels
     the you can use the rand16 function to select an appropriate value for gap_start note that gap_start must be between
     GAP_START_MIN and GAP_START_MAX. Note that the difference between gap_start and gap_end must be exactly GAP_HEIGHT.

  **/
  
  /// YOUR CODE HERE

  int c;
	
  score = -1;

  bird_x = BIRD_X_START;
  bird_y = BIRD_Y_START;

  bird_vx = 1;
  bird_vy = 0;

  for(c=0; c <4; c=c+1){
    the_pipes[c].xpos = (32)*(c)+70;
    the_pipes[c].gap_start = (rand16()%(GAP_START_MAX-GAP_START_MIN)) + GAP_START_MIN;
    the_pipes[c].gap_end = the_pipes[c].gap_start + GAP_HEIGHT;
  }


  
  

  
}

void update_pipes ()
{
  /**

     On every iteration of the game update_pipes is called to update the state of all of the pipes. Basically we model the motion of the bird
     by moving all of the pipes bird_vy pixels to the left on every iteration while the bird_x stays fixed. When a pipe has moved completely off screen it
     needs to be reinitialized by choosing appropriate values for gap_start and gap_end and reinitializing its xpos to 128 so a new pipe appears on the right side
     of the screen. 

     This routine is also responsible for score keeping. When a bird has completely cleared a pipe we increment the score to reflect the fact that you have 
     cleared another pipe.

  **/
  
  
  /// YOUR CODE HERE
  int c;
  for(c=0; c <4; c=c+1){
    if(the_pipes[c].xpos > 0){
      the_pipes[c].xpos = the_pipes[c].xpos - bird_vx;
    } else {
      score = score + 1;
      the_pipes[c].xpos = 128;
      the_pipes[c].gap_start = (rand16()%(GAP_START_MAX - GAP_START_MIN)) + GAP_START_MIN;
      the_pipes[c].gap_end = the_pipes[c].gap_start + GAP_HEIGHT;
    }
    if(the_pipes[c].xpos == 129){
      score = score + 1;
    }
  }


  
}

void update_bird (lc4int key)
{
  /***

      On every iteration the code calls this function to update the position and velocity of the bird. This function is called with a parameter key which is 0 if
      no keypress was detected and more than 0 if it was. Based on the key value you should set the bird acceleration, ay to +1 if no key was detected and -1 if it was 
      detected. You should then update the bird_y position by adding the current value of bird_vy and you should update bird_vy by adding the ay value mentioned 
      earlier. You should also make sure that bird_vy doesn't exceed MAX_VY or fall below -MAX_VY.
  
  ***/
 
  /// YOUR CODE HERE

  if(key == 0){
    ay = 1;
  } else{
    ay = -1;
  }
  bird_y = bird_y + bird_vy;
  bird_vy = bird_vy + ay;
  if(bird_vy > MAX_VY){
    bird_vy = MAX_VY;
  } else if(bird_vy < -MAX_VY){
    bird_vy = -MAX_VY;
  }

}

int dead_bird ()
{
  /***

      This routine checks the status of the bird and returns a non-zero value if it detects that any part of the 8x8 bird sprite is below row 124 or above row 0. It also
      checks whether any part of the 8x8 bird sprite overlaps any part of a pipe. If no collision is detected the routine must return 0.

   ***/
  
  /// YOUR CODE HERE
  int c;
  for(c=0; c <4; c=c+1){
    if(the_pipes[c].xpos > 27 && the_pipes[c].xpos < 43){
      if(bird_y < the_pipes[c].gap_start || bird_y + 8 > the_pipes[c].gap_end){
        return 1;
      }
    } 
  }

  if(bird_y < 0 || bird_y + 8 > 124){
    return 1;
  } else{
    return 0;
  }
}



/*
 * #############  MAIN PROGRAM ######################
 */

int main ()
{
  lc4int key;
  
  lc4_puts ((lc4uint*)"!!! Welcome to FlappyBird !!!\n");

  // Init game state
  reset_game_state();
  redraw();

  while (1) {
    
    lc4_puts ((lc4uint*)"Press r to reset\n");

    // Sit and wait for a r
    while (lc4_check_kbd() != 'r');

    reset_game_state();
    redraw();
  
    // Main loop

    while (1) {
      counter = (counter + 1) % 4;
      // Check keyboard for input
      // key = lc4_check_kbd();
      key = lc4_get_event();
      
      // Update the pipe states - this also updates the score if needed
      update_pipes ();

      // Update the bird position
      update_bird (key);

      redraw();

      // Check for collisions
      if (dead_bird()) {
	lc4_puts ((lc4uint*)"**** GAME OVER ****\n");
	break;
      }
    
    }
  }

  return 0;
}
