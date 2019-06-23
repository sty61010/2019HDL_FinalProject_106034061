`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2017 18:23:40
// Design Name: 
// Module Name: PaddleBallBricks
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PaddleBallBricks(
    input clock, reset,
    input[9:0] pixelX, pixelY,    
    
    inout PS2_CLK, PS2_DATA,
    
    output reg [15:0] LED,
    output [3:0] objRed,
    output [3:0] objGreen,
    output [3:0] objBlue,
  
    input btnL,
    input btnR,
    //output ballWire
    output [6:0] display,///////////
    output [3:0] digit////////////////
    );
    
    //=======================keyboard=========//
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    
    
    parameter [8:0] KEY_CODES [0:1] = 
        {
            9'b0_0110_1011,//direct_left
            9'b0_0111_0100 //direct_right
        };
        
        reg [1:0]number;
        reg [1:0]key_num;
        reg [15:0]LED_next;
        KeyboardDecoder ke (.key_down(key_down),.last_change(last_change),.key_valid(been_ready),.PS2_DATA(PS2_DATA),.PS2_CLK(PS2_CLK),.rst(reset),.clk(clock));
    
        reg keyleft, keyright;
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                keyleft <= 0;
            end 
            else begin
                if ((!been_ready && key_down[9'b1_0110_1011] == 1'b1)||(!been_ready && key_down[9'b0_0110_1011] == 1'b1))keyleft<=1;
                else keyleft <= 0;
                end
        end
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                keyright <= 0;
            end 
            else begin
                if ((!been_ready && key_down[9'b1_0111_0100] == 1'b1)||(!been_ready && key_down[9'b0_0111_0100] == 1'b1))keyright<=1;
                else keyright <= 0;
                end
        end
        always @ (*) begin
            case (last_change)
                KEY_CODES[0] : key_num = 2'b01;
                KEY_CODES[1] : key_num = 2'b10;
                default          : key_num = 2'b11;
            endcase
        end
    reg [3:0]count;
//    always@(posedge clock , posedge reset)begin
//        count<=count;
//        if(reset)count<=0;
//        else if(number==2'b10)count<=count+1;
//        else if(number==2'b01)count<=count-1;
//        else if(count==16)count<=0;
//    end
    
//    always@(*)begin
//        LED_next=LED;
//        case(count)
//            00:LED_next[0]=1;
//            01:LED_next[1]=1;
//            02:LED_next[2]=1;
//            03:LED_next[3]=1;
//            04:LED_next[4]=1;
//            05:LED_next[5]=1;
//            06:LED_next[6]=1;
//        endcase
//    end
    
    //=======================keyboard=========//
    wire sixtyHzTick;   //to get the 60Hz refresh rate.
    wire[9:0] left, right, top, bottom;//These are kinda coordinates of the square ball.
    wire brick1, brick2, brick3, brick4, brick5, brick6, brick7, brick8;
    reg brick1_ON = 1, brick2_ON = 1, brick3_ON = 1, brick4_ON = 1, brick5_ON = 1, brick6_ON = 1, brick7_ON = 1, brick8_ON = 1;
    /* The above parameters(registers) tell whether a brick is to be displayed or not.
    Their value becomes 0 when the ball hits the corresponding brick. */
     
    wire borderL, borderT, borderR, borderD;
    reg[3:0] redWire, greenWire, blueWire;
    
    //5 bricks
    parameter brickBottom = 62;
    
    parameter brick1_L=60, brick1_R=130;
    parameter brick2_L=180, brick2_R=250;
    parameter brick3_L=300, brick3_R=370;
    parameter brick4_L=420, brick4_R=490;
    parameter brick5_L=540, brick5_R=610;
    parameter brick6_L=180, brick6_R=250;
    parameter brick7_L=300, brick7_R=370;
    parameter brick8_L=420, brick8_R=490;
    /* The left and right coordintes of all the 5 bricks. */
    
    assign brick1 = (pixelX>=60 && pixelX<=130 && pixelY>=52 && pixelY<=62);
    assign brick2 = (pixelX>=180 && pixelX<=250 && pixelY>=52 && pixelY<=62);
    assign brick3 = (pixelX>=300 && pixelX<=370 && pixelY>=52 && pixelY<=62);
    assign brick4 = (pixelX>=420 && pixelX<=490 && pixelY>=52 && pixelY<=62);
    assign brick5 = (pixelX>=540 && pixelX<=610 && pixelY>=52 && pixelY<=62);
    assign brick6 = (pixelX>=180 && pixelX<=250 && pixelY>=252 && pixelY<=262);
    assign brick7 = (pixelX>=300 && pixelX<=370 && pixelY>=252 && pixelY<=262);
    assign brick8 = (pixelX>=420 && pixelX<=490 && pixelY>=252 && pixelY<=262);
    
    reg[26:0]clk_div;//////////////////////////////
    //4 borders
    assign borderL = (pixelX>=42 && pixelX<=51 && pixelY>=42 && pixelY<=471);
    assign borderT = (pixelX>=42 && pixelX<=631 && pixelY>=32 && pixelY<=42);
    assign borderR = (pixelX>=631 && pixelX<=640 && pixelY>=32 && pixelY<=480);
    assign borderD = (pixelX>=42 && pixelX<=631 && pixelY>=471 && pixelY<=480);
    ///////////////////////////////////////////////////////////////////////////////////////////
//    assign lava_o=clk_div[2]==1?(pixelX>=40 && pixelX<=90 && pixelX>=160 && pixelX<=210 && pixelX>=260 && pixelX <=370 && pixelX >=400 && pixelY>=460):(pixelX<=40 && pixelX>=90 && pixelX<=160 && pixelX>=210 && pixelX<=260 && pixelX >=370 && pixelX <=400 && pixelY>=470);
//    assign lava_r=clk_div[2]==1?(pixelX<=40 && pixelX>=90 && pixelX<=160 && pixelX>=210 && pixelX<=260 && pixelX >=370 && pixelX <=400 && pixelY>=470):(pixelX>=40 && pixelX<=90 && pixelX>=160 && pixelX<=210 && pixelX>=260 && pixelX <=370 && pixelX >=400 && pixelY>=460);
    ///////////////////////////////////////////////////////////////////////////////////////////
    wire brick1_Hit, brick2_Hit, brick3_Hit, brick4_Hit, brick5_Hit, brick6_Hit, brick7_Hit, brick8_Hit;//weather a brick was hit or not.
    reg gameOver;
      ///////////////////////////////
      reg [15:0]n_led;/////////////
      wire value;
   
      //////////////////////////////////////////////////////////    
      clock_divider #(.n(26))cd1(.clk(clock), .clk_div(clk26));
      
    always@(posedge clk26 or posedge reset)begin
      if(reset)begin
          LED<=16'b1111_1111_1111_1111;
          gameOver <= 0;
       end
       else LED<=n_led;
    end
    always@*begin
        n_led=LED;
        if(!value)n_led=2*LED;
        if(bottom>=470)begin
          n_led=LED>>1;
//            gameOver=0;
       end
    end
      
      reg [3:0]b1r,b1g,b1b;
      reg [3:0]b2r,b2g,b2b;
      reg [3:0]b3r,b3g,b3b;
      reg [3:0]b4r,b4g,b4b;
      reg [3:0]b5r,b5g,b5b;
      reg [3:0]b6r,b6g,b6b;
      reg [3:0]b7r,b7g,b7b;
      reg [3:0]b8r,b8g,b8b;
      ////////////////////////////////////////////////////////////
      always@*begin
          if(reset)begin
              b1r=4'b1111;
              b1g=4'b0000;
              b1b=4'b0000;
              b2r=4'b0000;
              b2g=4'b1111;
              b2b=4'b0000;
              b3r=4'b0000;
              b3g=4'b0000;
              b3g=4'b1111;
              b4r=4'b1111;
              b4g=4'b1111;
              b4b=4'b0000;
              b5r=4'b0000;
              b5g=4'b1111;
              b5b=4'b1111;
              b6r=4'b1000;
              b6g=4'b1111;
              b6b=4'b0011;
              b7r=4'b0100;
              b7g=4'b1001;
              b7b=4'b1111;
              b8r=4'b0001;
              b8g=4'b0011;
              b8b=4'b1111;
              
          end
          else if(brick1_Hit)begin
              b1r=b1r+1;
              b1g=b1g+1;
              b1b=b1b+1;
          end
          else if(brick2_Hit)begin
              b2r=b2r+1;
              b2g=b2g+1;
              b2b=b2b+1;
          end
          else if(brick3_Hit)begin
              b3r=b3r+1;
              b3g=b3g+1;
              b3b=b3b+1;
          end
          else if(brick4_Hit)begin
              b4r=b4r+1;
              b4g=b4g+1;
              b4b=b4b+1;
          end
          else if(brick5_Hit)begin
              b5r=b5r+1;
              b5g=b5g+1;
              b5b=b5b+1;
          end
          else if(brick6_Hit)begin
               b6r=b6r+1;
               b6g=b6g+1;
               b6b=b6b+1;
          end
          else if(brick7_Hit)begin
               b7r=b7r+1;
               b7g=b7g+1;
               b7b=b7b+1;
          end
          else if(brick8_Hit)begin
               b8r=b8r+1;
               b8g=b8g+1;
               b8b=b8b+1;
            end
          
      end
      //////////////////////////////////////////////////////////////////////////////
      always@(posedge clock)
      begin
          if(borderL | borderT | borderR | borderD)//Border region detected while scanning.
          begin
              if(value)begin
                  redWire <= 4'b0000;
                  greenWire <= 4'b1111;
                  blueWire <= 4'b0000;
              end
              else begin
                  redWire <= 4'b1111;
                  greenWire <= 4'b1100;
                  blueWire <= 4'b0100;
              end
          end
          else if(brick1 & !gameOver)//if brick1 region detected while scanning AND brick1 has NOT been hit by the ball.
          begin
              redWire <= b1r;
              greenWire <= b1g;
              blueWire <= b1b;
         end
          else if(brick2  & !gameOver)
          begin
              redWire <= b2r;
              greenWire <= b2g;
              blueWire <= b2b;
          end
          else if(brick3 & !gameOver)
          begin
              redWire <= b3r;
              greenWire <= b3g;
              blueWire <= b3b;
          end
          else if(brick4 & !gameOver)
          begin
              redWire <= b4r;
              greenWire <= b4g;
              blueWire <= b4b;
          end
          else if(brick5  & !gameOver)
          begin
          
              redWire <= b5r;
              greenWire <= b5g;
              blueWire <= b5b;
          end
          else if(brick6  & !gameOver)
          begin
            
              redWire <= b6r;
              greenWire <= b6g;
              blueWire <= b6b;
          end
          else if(brick7  & !gameOver)
          begin
          
              redWire <= b7r;
              greenWire <= b7g;
              blueWire <= b7b;
          end
          else if(brick8  & !gameOver)
          begin
            
              redWire <= b8r;
              greenWire <= b8g;
              blueWire <= b8b;
          end
          else if(ballWire & !gameOver)
          begin
              redWire <= 4'b1111;
              greenWire <= 4'b0000;
              blueWire <= 4'b0000;
          end
          else if(barWire & !gameOver)
          begin
              if(!value)begin
                  redWire <= 4'b0001;
                  greenWire <= 4'b1100;
                  blueWire <= 4'b0010;
              end
              else begin
                  redWire <= 4'b1111;
                  greenWire <= 4'b0000;
                  blueWire <= 4'b0100;
              end
          end
//          else if(lava_r&&!gameOver)begin
//            redWire <= 4'b1111;
//            greenWire <= 4'b0000;
//            blueWire <= 4'b0000;
//          end
//          else if(lava_o&&!gameOver)begin
//            redWire <= 4'b1111;
//            greenWire <= 4'b0011;
//            blueWire <= 4'b0001;
//          end          
          else 
          begin
              redWire <= 4'b0000;
              greenWire <= 4'b0000;
              blueWire <= 4'b0000;
              //black background
          end
      end
     ///////////////////////////////////////////////////////////
    assign objRed = redWire;
    assign objGreen = greenWire;
    assign objBlue = blueWire;
    
    
    
    /*------------------------------------------------------------------------------*/
    /*----------------------------BALL LOGIC----------------------------------------*/
    /*------------------------------------------------------------------------------*/
    
    
    localparam SPEED_POS = 1;
    localparam SPEED_NEG = -1;
    /* Used to change the DIRECTION of motion of the ball by adding the above in
    x as well as y coordinate */
    
    /*---------------------------------------*/
    /* Ball variables */
    reg [9:0] ballRegX, ballRegY;
    wire [9:0] ballWireX, ballWireY;
    /* To store the x and y coordintes of the moving object, more precisely, the top
    and the left sides of the moving square */
    
    /*---------------------------------------*/
    
    /* left and top are same as ballRegX and ballRegY, respectively. right and bottom
    get the modified values from the same RegX variables. */
    
    /*---------------------------------------*/
    reg[9:0] incrementRegX, incrementRegY;
    reg[9:0] incrementWireX, incrementWireY;
    /* Change in x or y coordiates. Value determines the speed. Sign determines the
    direction...will either have SPEED_POS or SPEED_NEG as their value, depending
    on the current trajectory and place of deflection of the ball. */
    /*---------------------------------------*/
    
    /*---------------------------------------*/
    always@(posedge clock or posedge reset)
    begin
        if(reset)   //reset button was presed...
        begin
            ballRegX <= 0;
            ballRegY <= 0;
            gameOver <= 0;
            incrementRegX <= SPEED_POS;
            incrementRegY <= SPEED_POS;
        end
        else
        begin
            ballRegX <= ballWireX;
            ballRegY <= ballWireY;
            incrementRegX <= incrementWireX;
            incrementRegY <= incrementWireY;
        end
    end 
    
   /*---------------------------------------*/
        reg[30:0]clk_div_2;
        always@(posedge clock, posedge reset)begin
            if(reset)clk_div_2<=0;
            else  clk_div_2<=clk_div_2+1;
        end
        
    //    reg[]
    //    always@(posedge clk_div_2[27], posedge reset)begin
    //        if(reset)
    //    end
        assign sixtyHzTick = (pixelY==39) && (pixelX==0);
        reg tick;
        wire tick_onepulse;
        reg[4:0]speed, freq;
        OnePulse (
                .signal_single_pulse(tick_onepulse),
                .signal(tick),
                .clock(clock)
                );
        always@(posedge clk_div_2[28], posedge reset)begin
            if(reset)freq<=4;
            else if(freq==1)freq<=4;
            else freq<=freq-1;
        end
        always@(posedge clk_div_2[15], posedge reset)begin
            if(reset)speed<=0;
            else if(speed==freq)speed<=0;
            else speed<=speed+1;
        end
        always@(posedge clock, posedge reset)begin
            if(reset)tick<=0;
            else if(speed==1)tick<=1;
            else tick<=0;
        end
        /* Scanning had reached the end of screen...To get the refresh rate of 60Hz. */
        /*---------------------------------------*/
        
        assign left = ballRegX;
        assign right = left + 10 - 1;   //10 is the size of the ball;
        assign top = ballRegY;
        assign bottom = top + 10 - 1;
        
        wire ball;   //will hold the signal for when the ball is to be displayed.
        
        assign ball = ( (pixelX >= left) && (pixelX <=right) && (pixelY >= top) && (pixelY <= bottom) );
        
        assign ballWireX = (tick_onepulse)? (ballRegX + incrementRegX) : (ballRegX);
        //assign ballWireX = (sixtyHzTick)? (ballRegX + incrementRegX) : (ballRegX);
        assign ballWireY = (tick_onepulse)? (ballRegY + incrementRegY) : (ballRegY);
    
    assign brick1_Hit = (top<brickBottom && (left>brick1_L && right<brick1_R));
    assign brick2_Hit = (top<brickBottom && (left>brick2_L && right<brick2_R));
    assign brick3_Hit = (top<brickBottom && (left>brick3_L && right<brick3_R));
    assign brick4_Hit = (top<brickBottom && (left>brick4_L && right<brick4_R));
    assign brick5_Hit = (top<brickBottom && (left>brick5_L && right<brick5_R));
    assign brick6_Hit = (top==brickBottom+200 && (left>brick6_L && right<brick6_R));
    assign brick7_Hit = (top==brickBottom+200 && (left>brick7_L && right<brick7_R));
    assign brick8_Hit = (top==brickBottom+200 && (left>brick8_L && right<brick8_R));
    //reg dummy;

    assign value = (brick1_Hit|brick2_Hit|brick3_Hit|brick4_Hit|brick5_Hit|brick6_Hit|brick7_Hit|brick8_Hit)?(0):(1);
    always@(*)
    begin
        
        if(brick1_Hit)
        begin
            brick1_ON <= value;
        end
        else if(brick2_Hit)
        begin
            brick2_ON <= value;
        end 
        else if(brick3_Hit)
        begin
            brick3_ON <= value;
        end
        else if(brick4_Hit)
        begin
            brick4_ON <= value;
        end
        else if(brick5_Hit)
        begin
            brick5_ON <= value;
        end
        else if(brick6_Hit)
        begin
            brick6_ON <= value;
        end
        else if(brick7_Hit)
        begin
            brick7_ON <= value;
        end
        else if(brick8_Hit)
        begin
            brick8_ON <= value;
        end
        else
        begin
            //dummy <= 1;
//            brick1_ON <= 1;
//            brick2_ON <= 1;
//            brick3_ON <= 1;
//            brick4_ON <= 1;
//            brick5_ON <= 1;
        end
    end
    
    reg cold_down, cold_down_next;
    always@(posedge clock, posedge reset)begin
        clk_div<=0;
        if(reset)clk_div<=0;
        else if(cold_down) clk_div<=clk_div+1;
    end
    always@(posedge clock, posedge reset)begin
        if(reset)cold_down<=0;
        else cold_down<=cold_down_next;
    end
    always@*begin
        cold_down_next = cold_down;
        if(brick6_Hit|brick7_Hit|brick8_Hit)cold_down_next=1;
        else if(clk_div[23]) cold_down_next=0;
    end
    wire[9:0] leftWireBar, rightWireBar;//from the paddle logic(see them after lines below)
    always@(*)
    begin
        incrementWireX <= incrementRegX;
        incrementWireY <= incrementRegY;
        
        if(left<=52)
        incrementWireX <= SPEED_POS;
        else if(right>=630)
        incrementWireX <= SPEED_NEG;
        else if(top<=42)//
        incrementWireY <= SPEED_POS;
        else if(bottom>=460 && left>=leftWireBar && right<=rightWireBar)
        incrementWireY <=SPEED_NEG;
//        else if(bottom>=470)
//        gameOver <= 1;
        else if(brick1_Hit|brick2_Hit|brick3_Hit|brick4_Hit|brick5_Hit)
        incrementWireY<=SPEED_POS;
        else if((brick6_Hit|brick7_Hit|brick8_Hit)&(cold_down==0))
        begin
            if(incrementRegY==SPEED_POS)incrementWireY<=SPEED_NEG;
            else incrementWireY<=SPEED_POS;
        end
//        incrementWireY<=~incrementRegY;//{incrementRegY[9:1], ~incrementRegY[0]};
    end
//    wire brick1_hit_bottom = (pixelX>=60 && pixelX<=130 && pixelY>=52 && pixelY<=62);
//    wire brick2_hit_bottom = (pixelX>=180 && pixelX<=250 && pixelY>=52 && pixelY<=62);
//    wire brick3_hit_bottom = (pixelX>=300 && pixelX<=370 && pixelY>=52 && pixelY<=62);
//    wire brick4_hit_bottom = (pixelX>=420 && pixelX<=490 && pixelY>=52 && pixelY<=62);
//    wire brick5_hit_bottom = (pixelX>=540 && pixelX<=610 && pixelY>=52 && pixelY<=62);
    assign ballWire = ball;
    
    
    
    /*------------------------------------------------------------------------------*/
    /*----------------------------PADDLE LOGIC----------------------------------------*/
    /*------------------------------------------------------------------------------*/
    
    localparam BAR_TOP = 460; //(top bundary)
    localparam BAR_BOTTOM = 465; //(bottom boundary)
    localparam BAR_SIZE = 64; //(Paddle Size)
    localparam BAR_STEP = 1; //Bar moving velocity when the button is pressed
    localparam MAX_X = 640;
    localparam MAX_Y = 480;

    // Paddle left and right boundary
    wire [9:0] LeftBar, rightBar;
    //Register to track the next x coordinate of the paddle
    reg[9:0] barRegX = 10'b0000000000;
    reg[9:0] barWireX;
    //Boundary of the paddle
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            barRegX <= 10'b0000000000;
        end
        else
        begin
            barRegX <= barWireX;
        end
    end
    
    
    
    
    assign leftWireBar = barRegX;
    assign rightWireBar = barRegX + BAR_SIZE;
    /*Left and right coordintes of the paddle*/
    
    //wire barWire;   //wheather scanning cursor is within the bar area or not.
    
    assign barWire = (pixelX>=leftWireBar && pixelX<=rightWireBar && pixelY>=BAR_TOP && pixelY<=BAR_BOTTOM);
    
    //assign barWireX = (sixtyHzTick && btnL && leftWireBar>(0))? (barRegX - BAR_STEP):(barRegX);
    //assign barWireX = (sixtyHzTick && btnR && rightWireBar<(MAX_X - BAR_STEP))? (barRegX + BAR_STEP):(barRegX);
    
//    9'b0_0110_1011,//direct_left
//                9'b0_0111_0100 //direct_right

//=================modyfy keyboard============//
//    always@*
//=================modyfy keyboard============//

    always@(*)
    begin
        //barWireX = barRegX;
        if(sixtyHzTick)
        begin
//            if((been_ready && key_down[9'b0_0110_1011] == 1'b1) & (leftWireBar > (0)))//btnL
            if(keyleft & (leftWireBar > (0)))
            begin
                barWireX <= barRegX - BAR_STEP; 
            end
//            else if((been_ready && key_down[9'b0_0111_0100] == 1'b1) & (rightWireBar < (MAX_X - BAR_STEP)))
            else if(keyright & (rightWireBar < (MAX_X - BAR_STEP)))
            begin
                barWireX <= barRegX + BAR_STEP;
            end
            else barWireX <= barRegX;//No button pressed, drive the current value to the wire again.
        end
        
    end 
    ////seven segment
    ////////////////////////////////////////////////////////////////////////////////////////////
    wire [15:0]nums;
    assign Hit=(brick1_Hit|brick2_Hit|brick3_Hit|brick4_Hit|brick5_Hit|brick6_Hit|brick7_Hit|brick8_Hit)?1:0;
    reg [3:0]score1, score2, score3, score4;
    reg [3:0]n_score1, n_score2, n_score3, n_score4;
    always@(posedge reset or posedge clk_div[17])begin
        if(reset)begin
            score1<=0;
            score2<=0;
            score3<=0;
            score4<=0;
        end
        else begin
            score1=n_score1;
            score2=n_score2;
            score3=n_score3;
            score4=n_score4;
        end
    end
    always@*begin
        n_score1=score1;
        n_score2=score2;
        n_score3=score3;
        n_score4=score4;
        if(Hit)begin
            n_score1=(score1==9)?0:score1+1;
            n_score2=(score1==9)?(score2==9?0:score2+1):score2;
            n_score3=(score2==9)?(score3==9?0:score3+1):score3;
            n_score4=(score3==9)?(score4==9?0:score4+1):score4;
        end
    end
    assign nums=(LED==0)?{{4'd13},{4'd11},{4'd14},{4'd15}}:{score4,score3,score2,score1};
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    SevenSegment seven_seg (
            .display(display),
            .digit(digit),
            .nums(nums),
            .rst(reset),
            .clk(clock)
        );
    
    //////////////////////////////////////////////////////////////////////////////////////////
    
endmodule



module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule
module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule
module SevenSegment(
	output reg [6:0] display,
	output reg [3:0] digit,
	input wire [15:0] nums,
	input wire rst,
	input wire clk
    );
    
    reg [15:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		clk_divider <= 15'b0;
    	end else begin
    		clk_divider <= clk_divider + 15'b1;
    	end
    end
    
    always @ (posedge clk_divider[15], posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
    					display_num <= nums[7:4];
    					digit <= 4'b1101;
    				end
    			4'b1101 : begin
						display_num <= nums[11:8];
						digit <= 4'b1011;
					end
    			4'b1011 : begin
						display_num <= nums[15:12];
						digit <= 4'b0111;
					end
    			4'b0111 : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end
    			default : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end				
    		endcase
    	end
    end
    parameter CH_G = 10;
    parameter CH_O = 11;
    parameter CH_A = 12;
    parameter CH_L = 13;
    parameter CH_S = 14;
    parameter CH_E = 15;
    always @ (*) begin
    	case (display_num)
    		0 : display = 7'b1000000;	//0000
			1 : display = 7'b1111001;   //0001                                                
			2 : display = 7'b0100100;   //0010                                                
			3 : display = 7'b0110000;   //0011                                             
			4 : display = 7'b0011001;   //0100                                               
			5 : display = 7'b0010010;   //0101                                               
			6 : display = 7'b0000010;   //0110
			7 : display = 7'b1111000;   //0111
			8 : display = 7'b0000000;   //1000
			9 : display = 7'b0010000;	//1001
            CH_G: display = 7'b0000010;
            CH_O: display = 7'b1000000;
            CH_A: display = 7'b0001000;
            CH_L: display = 7'b1000111;
            CH_S: display = 7'b0010010;
            CH_E: display = 7'b0000110;
			default : display = 7'b1111111;
    	endcase
    end
    
endmodule


module clock_divider #(parameter n = 26)(clk, clk_div);
    input clk;
    output clk_div;
    reg[n-1:0]num;
    wire[n-1:0]next_num;
    always@(posedge clk)begin
        num<=next_num;
    end
    assign next_num=num+1;
    assign clk_div=num[n-1];
endmodule