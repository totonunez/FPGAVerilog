
module ALU(
    input CLK100MHZ,
    input [3:0] Num1, Num2,
    input [1:0] Op,
    output [3:0] LED1, LED2,
    output [1:0] LED_Op,
    output reg [7:0] AN,
    output reg [6:0] display
    );
    reg [7:0] result;
    reg [3:0] digito;
    reg [18:0] refresh;
    wire [2:0] active_display;
    
    assign LED1 = Num1;
    assign LED2 = Num2;
    assign LED_Op = Op;
    
    always @(*)
    begin
        case(Op)
        2'b00: // Suma
            result = Num1 + Num2;
        2'b01: // Resta
            result = (Num1 > Num2)?(Num1 - Num2):(Num2 - Num1);
        2'b10: // Multiplicacion
            result = Num1 * Num2;
        2'b11: // Division
            result = Num1 / Num2;    
        default:
            result = Num1 + Num2;
        endcase
    end
    
    always @(posedge CLK100MHZ)
    begin
        if(refresh >= 500000)
            refresh <= 0;
        else
            refresh <= refresh + 1;
    end
    assign active_display = refresh[18:16];
    
    always @(*)
    begin
        case(active_display)
            3'b000: begin
                AN = 8'b11111110;
                begin
                  if (Op==3 & Num2 == 0)
                    digito = 8;
                  else
                    digito = result%100%10;
                end
                
                   end
            3'b001: begin
                AN = 8'b11111101;
                begin
                  if (Op==3 & Num2==0)
                    digito = 8;
                  else
                    digito = result%100/10;
                end
                    
                   end
            3'b010: begin                                
                AN = 8'b11111011;
                begin
                  if (Op==1 & Num2 > Num1)
                    digito = 10;
                  else
                    digito = result/100;
                end
                
                   end
            3'b011: begin
                AN = 8'b11110111;
                digito = Op;
                   end
            3'b100: begin
                AN = 8'b11101111;
                digito = Num2%100%10;
                   end 
            3'b101: begin
                AN = 8'b11011111;
                 digito = Num2%100/10;
                   end                    
            3'b110: begin
                 AN = 8'b10111111;
                 digito = Num1%100%10;
                   end  
            3'b111: begin
                 AN = 8'b01111111;
                 digito = Num1%100/10;
                   end                            
        endcase
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

