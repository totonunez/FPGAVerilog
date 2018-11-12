module ALU4bits(
	input [9:0] SW,
	input [3:0] A,B,
	input [2:0] LogicOperation,
	output [9:0] LED,
	output reg [7:0] AN,
        output reg [6:0] OUT
	);
	reg [3:0] DISPLAY; // Numero que mostrara el display.Cantidad de Bits por que por display
	reg [26:0] CONTADOR_SEG; // Contador para generar segundos segun el CLK de la placa. 134.217.728 (ms) para generar CLK
        wire SEGUNDO; // Indicador que paso un segundo.
    
	assign LED[0] = SW[0];
	assign LED[1] = SW[1];
	assign LED[2] = SW[2];
	assign LED[3] = SW[3];
	assign LED[4] = SW[4];
	assign LED[5] = SW[5];
	assign LED[6] = SW[6];
	assign LED[7] = SW[7];
	assign LED[8] = SW[8];
	assign LED[9] = SW[9];
	
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
		    case(LogicOperation)
			4'b00: // Suma	
			        DISPLAY = A + B ;
        		4'b01: // Subtraction
				if(A > B)
					DISPLAY = A - B ;
			        else
					DISPLAY = -(A-B)
			4'b10: // Multiplication
				DISPLAY = A * B;
			4'b11: // Division
				DISPLAY = A/B;
			default : DISPLAY = A+B
		    endcase  
	    end
    
always @(*)
    begin
        case(DISPLAY)
		for (i=0;i<4;i++)
			begin
				4'b0000: OUT[i] = 7'b0000001; // "0"     
				4'b0001: OUT[i] = 7'b1001111; // "1" 
				4'b0010: OUT[i] = 7'b0010010; // "2" 
				4'b0011: OUT[i] = 7'b0000110; // "3" 
				4'b0100: OUT[i] = 7'b1001100; // "4" 
				4'b0101: OUT[i] = 7'b0100100; // "5" 
				4'b0110: OUT[i] = 7'b0100000; // "6" 
				4'b0111: OUT[i] = 7'b0001111; // "7" 
				4'b1000: OUT[i] = 7'b0000000; // "8"     
				4'b1001: OUT[i] = 7'b0000100; // "9"
				4'b1001: OUT[i] = 7'b1111110; // "-"
				default: OUT[i] = 7'b0000001; // "0"
			end
        
        endcase
        AN = 8'b11111110; // El display que está activo será el último dado que es el que está en cero
    end
endmodule
