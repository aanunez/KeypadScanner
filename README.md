Keypad Scanner
==============
Verilog code for scanning and debouncing a four by four matrix keypad.
Implemented on an Altera Cyclone FPGA development board.

The key pad decoder module assumes a normal telephone layout plus an additional column for A - D. 

    1 2 3 A
    4 5 6 B
    7 8 9 C
    * 0 # D

Each key has a 4-bit address of the form Col:Row.

|Key|1|2|3|A|4|5|6|B|
|---|---|---|---|---|---|---|---|---|
|Address|0000|0001|0010|0011|0100|0101|0110|0111|

Additionally, it is assumed in the scanning (debouncing) module that the keys are normally disconnected and are pulled low when pressed (i.e. that they keyboard is not powered).

Usage
-------
The keypad interpreter module has three outputs and one input, 

**Ouputs**
* KeyReady goes high when a key is ready to be read and does not go down until KeyRead goes high.
* PressCout is the single hexadigit value describing the number of times the current key has been pressed, it is used to reaffirm the DataOut value if KeyReady is not being watched.
* DataOut is the single hexadecimal digit (0 to F) value describing the button most recently pressed. Star is valued as "F" and Pound as "E".

**Inputs**
* KeyRead must be asserted high for the scanner to continue. The KeyRead signal may only stay high for 8ms at most, it is recommended that the signal not remain high for longer than 4ms.

Contact
-------
If you have questions, concerns, or comments please feel free to contact me via 

    adam.a.nunez@gmail.com
License
-------
Copyright (C) 2014  Adam Nunez
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See theGNU General Public License for more details.
