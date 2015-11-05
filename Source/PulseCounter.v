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

module PulseCounter(
input Reset,
input Clock,
input In, 
output [3:0] Out
);

reg [3:0] Counter;
reg toggle;

// This module takes a bit input
// and returns the number of times 
// that input has been pulsed.
// It has an active low reset.
  
always @(posedge Clock, negedge Reset) begin
	if ( Reset == 0 ) 
		Counter <= 4'b0000;
	else begin
		if ((In==1) & (toggle==0)) begin
			Counter <= Counter + 1'b1;
			toggle <= 1;
	    end
		else if (In==0) begin
			toggle <= 0;
		end
	end
end
	
assign Out = Counter;

endmodule