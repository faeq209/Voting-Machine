`timescale 1ns/1ps

module votingmachine(input clock,input reset,input mode,input button1,input button2,input button3,input button4,output [7:0] led);
wire valid_vote_1,valid_vote_2,valid_vote_3,valid_vote_4;
wire[7:0] cand1_vote,cand2_vote,cand3_vote,cand4_vote;
wire anyvote;
assign anyvote=valid_vote_1|valid_vote_2|valid_vote_3|valid_vote_4;
buttonControl bc1(.clock(clock),.reset(reset),.button(button1),.valid_vote(valid_vote_1));
buttonControl bc2(.clock(clock),.reset(reset),.button(button2),.valid_vote(valid_vote_2));
buttonControl bc3(.clock(clock),.reset(reset),.button(button3),.valid_vote(valid_vote_3));
buttonControl bc4(.clock(clock),.reset(reset),.button(button4),.valid_vote(valid_vote_4));
votelogger vl(.clock(clock),.reset(reset),.mode(mode),.cand1_valid_vote(valid_vote_1),.cand2_valid_vote(valid_vote_2),.cand3_valid_vote(valid_vote_3),.cand4_valid_vote(valid_vote_4),.cand1_vote_recieved(cand1_vote),.cand2_vote_recieved(cand2_vote),.cand3_vote_recieved(cand3_vote),.cand4_vote_recieved(cand4_vote));
LedControl LC(.clock(clock),.reset(reset),.mode(mode),.valid_vote(anyvote),.cand1_vote(cand1_vote),.cand2_vote(cand2_vote),.cand3_vote(cand3_vote),.cand4_vote(cand4_vote),.cand1_button_press(valid_vote_1),.cand2_button_press(valid_vote_2),.cand3_button_press(valid_vote_3),.cand4_button_press(valid_vote_4),.leds(led));
endmodule

module buttonControl(input clock,input reset,input button,output reg valid_vote);
reg[3:0]counter;
always@(posedge clock)
begin
    if(reset)
        counter<=0;
    else
    begin
        if(button&(counter<11))
        counter<=counter+1;
    else
        counter<=0;
    end
end

always@(posedge clock)
    begin
        if(reset)
        valid_vote<=0;
        else
            begin
            if(counter==10)
            valid_vote<=1;
            else
            valid_vote=0;
            end
    end
endmodule

module votelogger(input clock,input reset,input mode,input cand1_valid_vote,input cand2_valid_vote,input cand3_valid_vote,input cand4_valid_vote,output reg[7:0]cand1_vote_recieved,output reg[7:0]cand2_vote_recieved,output reg[7:0]cand3_vote_recieved,output reg[7:0]cand4_vote_recieved);
always@(posedge clock)
    begin
    if(reset)
    begin
    cand1_vote_recieved<=0;
    cand2_vote_recieved<=0;
    cand3_vote_recieved<=0;
    cand4_vote_recieved<=0;
    end
    else
    begin
    if(cand1_valid_vote & mode==0)
    cand1_vote_recieved<=cand1_vote_recieved+1;
    else if(cand2_valid_vote & mode==0)
    cand2_vote_recieved<=cand2_vote_recieved+1;
    else if(cand3_valid_vote & mode==0)
    cand3_vote_recieved<=cand3_vote_recieved+1;
    else if(cand4_valid_vote & mode==0)
    cand4_vote_recieved<=cand4_vote_recieved+1;
    end
    end
endmodule


module LedControl(input clock,input reset,input mode,input valid_vote,input[7:0]cand1_vote,input[7:0]cand2_vote,input[7:0]cand3_vote,input[7:0]cand4_vote,input cand1_button_press,input cand2_button_press,input cand3_button_press,input cand4_button_press,output reg[7:0]leds);
always@(posedge clock)
begin
if(reset)
leds<=0;
else
    begin
    if(mode==0 & valid_vote)
    leds<=8'hFF;
   else if(mode==1 & valid_vote)      
        begin
        if(cand1_button_press)
        leds<=cand1_vote;
        else if(cand2_button_press)
        leds<=cand2_vote;
        else if(cand3_button_press)
        leds<=cand3_vote;
        else if(cand4_button_press)
        leds<=cand4_vote;
        end
    else
    leds<=8'h00;
    end
end
endmodule





