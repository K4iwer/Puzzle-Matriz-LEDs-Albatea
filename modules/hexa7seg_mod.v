module hexa7seg_mod (hexa, display);
    input      [4:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        5'h0:    display = 7'b1000000;
        5'h1:    display = 7'b1111001;
        5'h2:    display = 7'b0100100;
        5'h3:    display = 7'b0110000;
        5'h4:    display = 7'b0011001;
        5'h5:    display = 7'b0010010;
        5'h6:    display = 7'b0000010;
        5'h7:    display = 7'b1111000;
        5'h8:    display = 7'b0000000;
        5'h9:    display = 7'b0010000;
        5'ha:    display = 7'b0001000;
        5'hb:    display = 7'b0000011;
        5'hc:    display = 7'b1000110;
        5'hd:    display = 7'b1000111;       // Alterado para "L" por motivos de liberdade poética, originalmente 7'b0100001
        5'he:    display = 7'b0000110;
        5'hf:    display = 7'b0001110;
        5'h10:   display = 7'b1111110;  
        5'h11:   display = 7'b1111101;  
        5'h12:   display = 7'b1111011;  
        5'h13:   display = 7'b1110111; 
        5'h14:   display = 7'b1101111;
        5'h15:   display = 7'b1011111;
        5'h16:   display = 7'b0111111;
        5'h17:   display = 7'b1111100;
        5'h18:   display = 7'b0111100;
        5'h19:   display = 7'b0011100;
        5'h1a:   display = 7'b1110011;
        5'h1b:   display = 7'b1100011;
        5'h1c:   display = 7'b0100011;
        5'h1d:   display = 7'b1011101;
        5'h1e:   display = 7'b1101011;
        5'h1f:   display = 7'b1001001;
        default: display = 7'b1111111;
    endcase
endmodule
