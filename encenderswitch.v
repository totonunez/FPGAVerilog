module encenderswitch(
    input CLK100MHZ,
	input RST,
	output reg [7:0] AN,
	output reg [6:0] OUT
	);
	reg [26:0] CONTADOR_SEG; // Contador para generar segundos segun el CLK de la placa. 134.217.728 (ms) para generar CLK
    wire SEGUNDO; // Indicador que paso un segundo.
    reg [3:0] DISPLAY; // Numero que mostrara el display.Cantidad de Bits por que por display
	
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
	
	always @(posedge CLK100MHZ or posedge RST)
	begin
		if(RST==1)
			DISPLAY <= 0;
		else if(SEGUNDO==1) begin
		    if(DISPLAY>=9)
		        DISPLAY <= 0;
		    else
		        DISPLAY <= DISPLAY + 1;
		end 
	end
	
	always @(*)
    begin
        case(DISPLAY)
        4'b0000: OUT = 7'b0000001; // "0"     
        4'b0001: OUT = 7'b1001111; // "1" 
        4'b0010: OUT = 7'b0010010; // "2" 
        4'b0011: OUT = 7'b0000110; // "3" 
        4'b0100: OUT = 7'b1001100; // "4" 
        4'b0101: OUT = 7'b0100100; // "5" 
        4'b0110: OUT = 7'b0100000; // "6" 
        4'b0111: OUT = 7'b0001111; // "7" 
        4'b1000: OUT = 7'b0000000; // "8"     
        4'b1001: OUT = 7'b0000100; // "9" 
        default: OUT = 7'b0000001; // "0"
        endcase
        AN = 8'b11111110; // El display que está activo será el último dado que es el que está en cero
    end
endmodule
