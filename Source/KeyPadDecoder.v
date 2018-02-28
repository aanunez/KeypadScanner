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

module KeyPadDecoder(
input [3:0] In, 
output reg [3:0] Out
);
   
// This module accepts as input a four bit value that describes
// the row col vector and decodes into the value at that location
// for a 4 by 4 matrix keypad with layout ...   
// 1 2 3 A
// 4 5 6 B
// 7 8 9 C
// * 0 # D				
   
always @(In) begin
	case (In)
		4'b0000: Out = 4'h1;
		4'b0001: Out = 4'h2;
		4'b0010: Out = 4'h3;
		4'b0011: Out = 4'hA;
		4'b0100: Out = 4'h4;
		4'b0101: Out = 4'h5;
		4'b0110: Out = 4'h6;
		4'b0111: Out = 4'hB;
		4'b1000: Out = 4'h7;
		4'b1001: Out = 4'h8;
		4'b1010: Out = 4'h9;
		4'b1011: Out = 4'hC;
		4'b1100: Out = 4'hF;
		4'b1101: Out = 4'h0;
		4'b1110: Out = 4'hE;
		4'b1111: Out = 4'hD;
     default: Out = 4'h1;
	endcase
end

endmodule