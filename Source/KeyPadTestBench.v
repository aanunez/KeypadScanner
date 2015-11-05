// Author: Adam Nunez, adam.a.nunez@gmail.com
// Copyright (C) 2015  Adam Nunez
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

`timescale 1ns/1ns
module KeyPadTestBench();

reg flag;
//Inputs to KeyPadInterpreter
reg Clock;
reg ResetButton;
reg KeyRead;
reg [3:0] RowDataIn;
//Outputs from KeyPadInterpreter
wire KeyReady;
wire [3:0] DataOut;
wire [3:0] ColDataOut;
wire [3:0] PressCount;

//Clock Setup
initial begin
	Clock = 0;
end

always begin 
	#1 Clock = ~Clock;
end
//End Clock Setup

//Keypad Emulator, 
// returns that "5" is pressed after flag goes high
always @(ColDataOut) begin
	if(flag==1) begin
		case(ColDataOut) 
			4'bzzz0: RowDataIn = 4'b1111;
			4'bzz0z: RowDataIn = 4'b1111;
			4'bz0zz: RowDataIn = 4'b1101;
			4'b0zzz: RowDataIn = 4'b1111;
		endcase
	end
	else begin
		case(ColDataOut) 
			4'bzzz0: RowDataIn = 4'b1111;
			4'bzz0z: RowDataIn = 4'b1111;
			4'bz0zz: RowDataIn = 4'b1111;
			4'b0zzz: RowDataIn = 4'b1111;
		endcase
	end
end
//End Keypad Emulator

//Actual Testing
initial begin
	#0 flag = 0;
	#0 ResetButton = 0;
	#3 ResetButton = 1;
	#10000000; //Wait a long time
	flag = 1;
	#10000000; //Wait a little more
	if(DataOut == 4'b0110) 
		$display("CorrectKey");
	else
		$display("Wrong DataOut");
end
//End of Testing

//Module to be tested
KeyPadInterpreter test(Clock,ResetButton,KeyRead,RowDataIn,KeyReady,DataOut,ColDataOut,PressCount);

endmodule