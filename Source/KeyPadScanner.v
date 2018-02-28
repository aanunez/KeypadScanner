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

module KeyPadScanner(
input Reset,
input Clock, 
input [3:0] RowIn, 
output [3:0] ColOut, 
output reg LFSRReset, 
input LFSRFlg, 
output reg [3:0] RowColVector, 
output reg KeyRdy, 
input KeyRd
);

// This module assumes an 8-pin 4 by 4 matrix keypad is connected
// with its input pins on ColOut and output pin on RowIn. The
// Scanner flips through columns on the key pad checking if a key is
// depressed, when one is found the KeyRdy signal is set high, the
// key data is placed on RowColVector and the scanner waits for KeyRd
// to continue scanning.

parameter Scan=2'b00, Calculate=2'b01, Analyize=2'b10, WaitForRead=2'b11;
reg [1:0] State;
reg [2:0] Counter;
reg [15:0] Data;
reg [3:0] Col;
reg [3:0] Sum;
reg ZeroChecker;
reg waitbit;

assign ColOut[0] = Col[0] ? 1'bz : 1'b0; 
assign ColOut[1] = Col[1] ? 1'bz : 1'b0; 
assign ColOut[2] = Col[2] ? 1'bz : 1'b0; 
assign ColOut[3] = Col[3] ? 1'bz : 1'b0; 
  
always @(posedge Clock, negedge Reset) begin
	if (Reset == 0) begin
		State <= Scan;
		Col <= 4'b0111;
		LFSRReset <= 0;
		KeyRdy <= 0;
		RowColVector <= 4'b1101;
		Counter <= 0;
		Data <= 16'hFFFF;
		Sum <= 0;
		ZeroChecker <= 0;
		waitbit <= 0;
	end
	else begin
		case(State)
			Scan: begin
				if(LFSRFlg == 1) begin
					case(Col)
						4'b0111: begin 
							if(waitbit == 1) begin
								Data[15:12] <= RowIn;
								Col <= 4'b1011;
								waitbit <= 0;
							end
							else waitbit <= 1;
						end
						4'b1011: begin
							if(waitbit == 1) begin
								Data[11:8] <= RowIn;
								Col <= 4'b1101;
								waitbit <= 0;
							end
							else waitbit <= 1;
						end
						4'b1101: begin
							if(waitbit == 1) begin
								Data[7:4] <= RowIn;
								Col <= 4'b1110;
								waitbit <= 0;
							end
							else waitbit <= 1;
						end
						4'b1110: begin
							if(waitbit == 1) begin
								Data[3:0] <= RowIn;
								Col <= 4'b0111;
								State <= Calculate;	
								waitbit <= 0;
							end
							else waitbit <= 1;
						end
						default: begin
							Col <= 4'b1110;
							Counter <= 0;
						end
					endcase
					LFSRReset <= 0;
				end
				else begin
					LFSRReset <= 1;
				end
			end
			Calculate: begin
				Sum <= ~Data[0] + ~Data[1] + ~Data[2] + ~Data[3]
					 + ~Data[4] + ~Data[5] + ~Data[6] + ~Data[7]
					 + ~Data[8] + ~Data[9] + ~Data[10] + ~Data[11]
					 + ~Data[12] + ~Data[13] + ~Data[14] + ~Data[15]; 
				State <= Analyize;
			end
			Analyize: begin
				if (ZeroChecker== 1'b1) begin
					if(Sum == 4'b0001) begin
						Counter <= Counter + 1'b1;
						if(Counter == 3'b100) begin
							case(Data)
								16'hFFFE : RowColVector <= 4'b0000; 
								16'hFFFD : RowColVector <= 4'b0100; 
								16'hFFFB : RowColVector <= 4'b1000; 
								16'hFFF7 : RowColVector <= 4'b1100; 
								16'hFFEF : RowColVector <= 4'b0001; 
								16'hFFDF : RowColVector <= 4'b0101; 
								16'hFFBF : RowColVector <= 4'b1001; 
								16'hFF7F : RowColVector <= 4'b1101; 
								16'hFEFF : RowColVector <= 4'b0010; 
								16'hFDFF : RowColVector <= 4'b0110; 
								16'hFBFF : RowColVector <= 4'b1010; 
								16'hF7FF : RowColVector <= 4'b1110; 
								16'hEFFF : RowColVector <= 4'b0011; 
								16'hDFFF : RowColVector <= 4'b0111; 
								16'hBFFF : RowColVector <= 4'b1011; 
								16'h7FFF : RowColVector <= 4'b1111; 
								default  : RowColVector <= 4'b0000; 
							endcase
							KeyRdy <= 1;
							State <= WaitForRead;
							Counter <= 0;
							ZeroChecker <= 0;
						end
					end
					else if (Sum == 4'b0000) begin 
						Counter <= 0;
						State <= Scan;
					end
					else begin 
						ZeroChecker <= 1'b0; 
						Counter <= 0; 
						State <= Scan;
					end
				end
				else if (Sum == 4'b0000) begin
					ZeroChecker <= 1'b1;
					State <= Scan;
				end
				else State <= Scan;
			end
			WaitForRead: begin
				if(KeyRd == 1) begin
					KeyRdy <= 0;
					LFSRReset <= 0;
					State <= Scan;
				end
			end 
			default: begin 
				State <= Scan;
				Col <= 4'b1110;
				LFSRReset <= 0;
				KeyRdy <= 1;
				RowColVector <= 4'b1111;
				Counter <= 0;
				Data <= 16'hFFFF;
				Sum <= 0;
			end
		endcase
	end
end
endmodule