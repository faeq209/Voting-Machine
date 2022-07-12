module test;
reg clock;
reg reset;
reg mode;
reg button1;
reg button2;
reg button3;
reg button4;
wire[7:0]led;
wire v1,v2,v3,v4;
votingmachine vm(.clock(clock),.reset(reset),.mode(mode),.button1(button1),.button2(button2),.button3(button3),.button4(button4),.led(led));
always
    #5clock=~clock;
initial
    begin
    clock=0;
    $monitor($time," mode=%b,button1=%b,button2=%b,button3=%b,button4=%b ,leds=%b",mode,button1,button2,button3,button4,led);
    $dumpfile("voting.vcd");
    $dumpvars(0,test);
    reset=1;mode=0;button1=0;button2=0;button3=0;button4=0;
    
    #10  reset=0;mode=0;button1=1;button2=0;button3=0;button4=0;
    #150  reset=0;mode=0;button1=0;button2=0;button3=0;button4=0;
     #10  reset=0;mode=0;button1=1;button2=0;button3=0;button4=0;
    #150  reset=0;mode=0;button1=0;button2=0;button3=0;button4=0;
     #10  reset=0;mode=0;button1=1;button2=0;button3=0;button4=0;
     #150  reset=0;mode=0;button1=0;button2=0;button3=0;button4=0;
    #10  reset=0;mode=1;button1=1;button2=0;button3=0;button4=0;
    #200  reset=0;mode=1;button1=0;button2=0;button3=0;button4=0;
    
    
   
    $finish;
    end
    endmodule