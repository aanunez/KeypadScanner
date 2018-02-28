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

module LFSR25000(
input Clock,
input Reset,
output reg Out
);

// This module accepts 1 input plus a clock and returns 1
// on output after 25000 clock cycles have passed.

reg [14:0] LFSR;

always @(posedge Clock, negedge Reset) begin
	if(Reset==0) begin
		Out <= 0;
		LFSR <= 15'b111111111111111;
	end
	else begin
		LFSR[0] <= LFSR[13] ^ LFSR[14];
		LFSR[14:1] <= LFSR[13:0];
		if(LFSR==15'b001000010001100) Out <= 1;
	end
end

endmodule