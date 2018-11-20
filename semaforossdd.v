`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 07:14:07 PM
// Design Name: 
// Module Name: semaforossdd
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


module semaforossdd(

    input CLK100MHZ,
    input RST,
    output reg [7:0] AN,
    output reg [6:0] display
    output G16,
    output G17,
    output R16,
    output R17,
    );
    reg [3:0] digito;
    reg [18:0] refresh;
    wire active_display;
    
    reg [26:0] CONTADOR_SEG; // Contador para generar segundos segun el CLK de la placa. 134.217.728 (ms) para generar CLK
    wire SEGUNDO; // Indicador que paso un segundo.
    reg [5:0] DISPLAY; //Monstrar el número que hay
    
    
    always @(posedge CLK100MHZ or posedge RST)
    begin
        if(RST==1)
            CONTADOR_SEG <= 0;
        else begin
            if(CONTADOR_SEG>=99999999) 
                 CONTADOR_SEG <= 0;
            else
                CONTADOR_SEG <= CONTADOR_SEG + 1;
        end
    end
    assign SEGUNDO = (CONTADOR_SEG==99999999)?1:0;
    
always @(posedge CLK100MHZ)
        begin
            if(refresh >= 500000)
                refresh <= 0;
            else
                refresh <= refresh + 1;
        end
        assign active_display = refresh[18];
        
    
always @( posedge CLK100MHZ or posedge RST) 
    
    begin 
        if (RST==1) 
            DISPLAY <= 0;
        else if (DISPLAY==1) 
            begin if (DISPLAY>=55) 
                DISPLAY <= 0; 
            else
                DISPLAY <= DISPLAY + 1; 
            end 
     end
     
     always @(*)
         begin
             case(active_display)
                 1'b0: begin
                     AN = 8'b11111110;
                     digito = DISPLAY%10;
                     end
               
                 1'b1: begin
                     AN = 8'b11111101;
                     digito = DISPLAY/10;    
                        end                         
             endcase
         end
    
    always @(*)
	begin
		begin
		if (DISPLAY >= 0 & DISPLAY < 20)
			R16=1;
            R17=0;
            G16=0;
            G17=0;
		else begin
			if (DISPLAY >= 20 & DISPLAY < 30)
				G16=G16^1;
			else begin
				if (DISPLAY >= 30 & DISPLAY < 35)
					R16 = R16^1;
				else begin
					if (DISPLAY >= 35 & DISPLAY < 40)
						G16=G16^1;
						R17=R17^1;
					else begin
						if (DISPLAY >= 40 & DISPLAY < 50)
							G17= G17^1;
						else begin
							if (DISPLAY >= 50 & DISPLAY < 55)
								R17 = R17^1;								end
						end
					end
			end
		end
	end

end
    
    always @(*)
    begin
        case(digito)
        4'b0000: display = 7'b0000001; // "0"     
        4'b0001: display = 7'b1001111; // "1" 
        4'b0010: display = 7'b0010010; // "2" 
        4'b0011: display = 7'b0000110; // "3" 
        4'b0100: display = 7'b1001100; // "4" 
        4'b0101: display = 7'b0100100; // "5" 
        4'b0110: display = 7'b0100000; // "6" 
        4'b0111: display = 7'b0001111; // "7" 
        4'b1000: display = 7'b0000000; // "8"     
        4'b1001: display = 7'b0000100; // "9"
        4'b1010: display = 7'b1111110; // "-"
        default: display = 7'b0000001; // "0"
        endcase 
    end
endmodule
