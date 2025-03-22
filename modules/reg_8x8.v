//------------------------------------------------------------------
// Arquivo   : reg_8x8
// Projeto   : Jogo matriz de leds
//------------------------------------------------------------------
// Função    : Armazenar o desenho de vitória e 
//             mostrar todas as leds acesas para 
//             permitir a animação de passar de 
//             nivel
//
module reg_8x8 (clock, reset, indice, vitoria, coluna_sel);
    input        clock;
    input        reset;
    input  [2:0] indice;
    input        vitoria;
    output reg [7:0] coluna_sel;

    // Registrador para guardar desenho
    reg [7:0] desenho_vitoria [0:7]; // 8 linhas de 8 bits (desenho fixo)

    always @(posedge reset) begin
        desenho_vitoria[0] <= 8'b00011000;
        desenho_vitoria[1] <= 8'b00011000;
        desenho_vitoria[2] <= 8'b00100100;
        desenho_vitoria[3] <= 8'b00100100;
        desenho_vitoria[4] <= 8'b01000010;
        desenho_vitoria[5] <= 8'b01000010;
        desenho_vitoria[6] <= 8'b10000001;
        desenho_vitoria[7] <= 8'b10000001;
    end

    // Seleciona qual padrão será mostrado
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            coluna_sel <= 8'b00000000;
        end else if (vitoria) begin
            coluna_sel <= desenho_vitoria[indice]; // Seleciona a linha do desenho
        end else begin
            coluna_sel <= 8'b00000000; // Todas as colunas acesas
        end
    end

endmodule

