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

module KeyPadInterpreter(
input  Clock, 
input  ResetButton,
input  KeyRead, 			
input  [3:0] RowDataIn,
output KeyReady,			
output [3:0] DataOut,
output [3:0] ColDataOut,
output [3:0] PressCount
);

//The keypad interpreter accepts typical inputs...
//		Clock, Reset
//As well as KeyPad input/output connections...
//		RowDataIn, ColDataOut
//Important Outputs...
//		KeyReady, PressCount, DataOut
//		KeyReady goes high when a key is ready
//			to be read and does not go down
//			until KeyRead goes high.
//		PressCout is the single hexadigit
//			value describing the number of
//			times a key has been pressed
//		DataOut is the single hexadigit
//			value describing the button
//			most recently pressed.
//Important Inputs...
//		KeyRead must be asserted high for the
//			scanner to continue. The KeyRead
//			signal may only stay high for 8ms
//			at most, it is recommended that the
//			signal not remain high for longer
//			than 4ms.


wire [3:0] KeyCode;
wire LFSRRst;
wire LFSRFlg;

LFSR25000			LFSR     (Clock, LFSRRst, LFSRFlg);
KeyPadScanner       Scanner  (ResetButton, Clock, RowDataIn, ColDataOut, LFSRRst, LFSRFlg, KeyCode, KeyReady, KeyRead);
PulseCounter		Count	 (ResetButton, Clock, KeyReady, PressCount);
KeyPadDecoder       Decoder  (KeyCode , DataOut);


endmodule