/* ----------------------------------------------------------------
 * Arquivo   : hexa7seg.v
 * Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
 *--------------------------------------------------------------
 * Descricao : decodificador hexadecimal para 
 *             display de 7 segmentos 
 * 
 * entrada : hexa - codigo binario de 4 bits hexadecimal
 * saida   : sseg - codigo de 7 bits para display de 7 segmentos
 *
 * baseado no componente bcd7seg.v da Intel FPGA
 *--------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. sseg(6) -> HEX0[6] ou HEX06
 *--------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/12/2023  1.0     Edson Midorikawa  criacao
 *--------------------------------------------------------------
 */

module hexa7seg_ent8bit (hexa, display);
    input      [7:0] hexa;
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
        8'b00000001:    display = 7'b1000000;
        8'b00000010:    display = 7'b1111001;
        8'b00000100:    display = 7'b0100100;
        8'b00001000:    display = 7'b0110000;
        8'b00010000:    display = 7'b0011001;
        8'b00100000:    display = 7'b0010010;
        8'b01000000:    display = 7'b0000010;
        8'b10000000:    display = 7'b1111000;
        default: display = 7'b1111111;
    endcase
endmodule
