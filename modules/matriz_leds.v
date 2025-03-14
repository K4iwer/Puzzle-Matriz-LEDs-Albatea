/*
    Este módulo é o controlador de uma matriz de leds. Ele trata as linhas da matriz como terra e as 
    colunas como fase, logo, para ativar algo na linha 5, ele faz linhas = 01111 e ativa o que quiser
    nas colunas. 


*/

module matriz_leds (
    input clk,              // Clock principal da FPGA
    input rst,              // Botão de reset
    input [7:0] botoes,     // Entrada dos botões físicos
    input [2:0] nivel,      // Nivel atual do jogador
    output nivel_concluido,  // Output que avisa a UC se venceu
    output [7:0] colunas,   // Sinais para as colunas da matriz de LEDs
    output [7:0] linhas,     // Sinais para ativar linhas da matriz
    output [2:0] db_linha,
    output db_clock,
    output db_reset
);

    reg [7:0] estado_leds [7:0]; // Matriz virtual para armazenar estado das LEDs
    reg [2:0] linha_atual; // Variável para escanear as linhas
    integer i, j;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                    estado_leds[i][j] <= 0; // Desliga todas as LEDs
            end 
        end 
        linha_atual = 0;
    end

    // Checa condição de vitória com base no nível atual
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            nivel_concluido <= 0;
        end else begin
            case (nivel) 
                3'b000 : nivel_concluido <= (estado_leds[0] == 8'b11111111);
                3'b001: nivel_concluido <= (estado_leds[0] == 8'b11111111) && (estado_leds[1] == 8'b11111111) && (estado_leds[2] == 8'b11111111);
                3'b010: nivel_concluido <= (estado_leds[0] == 8'b11111111) && (estado_leds[1] == 8'b11111111) && (estado_leds[2] == 8'b11111111) && (estado_leds[3] == 8'b11111111) && (estado_leds[4] == 8'b11111111);
                3'b011: nivel_concluido <= (estado_leds[0] == 8'b11111111) && (estado_leds[1] == 8'b11111111) && (estado_leds[2] == 8'b11111111) && (estado_leds[3] == 8'b11111111) && (estado_leds[4] == 8'b11111111) && (estado_leds[5] == 8'b11111111) && (estado_leds[6] == 8'b11111111);
                3'b100: nivel_concluido <= (estado_leds[0] == 8'b11111111) && (estado_leds[1] == 8'b11111111) && (estado_leds[2] == 8'b11111111) && (estado_leds[3] == 8'b11111111) && (estado_leds[4] == 8'b11111111) && (estado_leds[5] == 8'b11111111) && (estado_leds[6] == 8'b11111111) && (estado_leds[7] == 8'b11111111);
                default: nivel_concluido <= 0;
            endcase
        end
    end

    // Reset: Apaga todas as LEDs no início
    always @* begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                for (j = 0; j < 8; j = j + 1)
                    estado_leds[i][j] <= 0; // Desliga todas as LEDs
        end else begin
            // Controle das LEDs pelos botões
            if (botoes[0]) begin 
                estado_leds[0][0] <= ~estado_leds[0][0];
                estado_leds[0][1] <= ~estado_leds[0][1];
                estado_leds[0][2] <= ~estado_leds[0][2];
                estado_leds[1][0] <= ~estado_leds[1][0];
                estado_leds[1][1] <= ~estado_leds[1][1];
                estado_leds[1][2] <= ~estado_leds[1][2];
                estado_leds[2][0] <= ~estado_leds[2][0];
                estado_leds[2][1] <= ~estado_leds[2][1];
                estado_leds[2][2] <= ~estado_leds[2][2];
            end 

            if (botoes[1]) begin
                estado_leds[3][0] <= ~estado_leds[3][0];
                estado_leds[3][1] <= ~estado_leds[3][1];
                estado_leds[3][2] <= ~estado_leds[3][2];
                estado_leds[4][0] <= ~estado_leds[4][0];
                estado_leds[4][1] <= ~estado_leds[4][1];
                estado_leds[5][0] <= ~estado_leds[5][0];
                estado_leds[5][1] <= ~estado_leds[5][1];
                estado_leds[6][0] <= ~estado_leds[6][0];
                estado_leds[6][1] <= ~estado_leds[6][1];
            end
            if (botoes[2]) begin
                estado_leds[4][2] <= ~estado_leds[4][2];
                estado_leds[5][2] <= ~estado_leds[5][2];
                estado_leds[5][3] <= ~estado_leds[5][3];
                estado_leds[6][2] <= ~estado_leds[6][2];
                estado_leds[6][3] <= ~estado_leds[6][3];
                estado_leds[7][0] <= ~estado_leds[7][0];
                estado_leds[7][1] <= ~estado_leds[7][1];
                estado_leds[7][2] <= ~estado_leds[7][2];
                estado_leds[7][3] <= ~estado_leds[7][3];
            end
        
            if (botoes[3]) begin
                estado_leds[5][3] <= ~estado_leds[5][3];
                estado_leds[5][4] <= ~estado_leds[5][4];
                estado_leds[5][5] <= ~estado_leds[5][5];
                estado_leds[6][3] <= ~estado_leds[6][3];
                estado_leds[6][4] <= ~estado_leds[6][4];
                estado_leds[6][5] <= ~estado_leds[6][5];
                estado_leds[7][3] <= ~estado_leds[7][3];
                estado_leds[7][4] <= ~estado_leds[7][4];
                estado_leds[7][5] <= ~estado_leds[7][5];
            end
            if (botoes[4]) begin
                estado_leds[0][3] <= ~estado_leds[0][3];
                estado_leds[0][4] <= ~estado_leds[0][4];
                estado_leds[1][3] <= ~estado_leds[1][3];
                estado_leds[1][4] <= ~estado_leds[1][4];
                estado_leds[2][3] <= ~estado_leds[2][3];
                estado_leds[2][4] <= ~estado_leds[2][4];
                estado_leds[3][3] <= ~estado_leds[3][3];
                estado_leds[3][4] <= ~estado_leds[3][4];
                estado_leds[4][3] <= ~estado_leds[4][3];
            end
            if (botoes[5]) begin
                estado_leds[0][5] <= ~estado_leds[0][5];
                estado_leds[1][5] <= ~estado_leds[1][5];
                estado_leds[2][5] <= ~estado_leds[2][5];
                estado_leds[2][6] <= ~estado_leds[2][6];
                estado_leds[3][5] <= ~estado_leds[3][5];
                estado_leds[3][6] <= ~estado_leds[3][6];
                estado_leds[4][4] <= ~estado_leds[4][4];
                estado_leds[4][5] <= ~estado_leds[4][5];
                estado_leds[4][6] <= ~estado_leds[4][6];
            end
            if (botoes[6]) begin
                estado_leds[5][5] <= ~estado_leds[5][5];
                estado_leds[5][6] <= ~estado_leds[5][6];
                estado_leds[5][7] <= ~estado_leds[5][7];
                estado_leds[6][5] <= ~estado_leds[6][5];
                estado_leds[6][6] <= ~estado_leds[6][6];
                estado_leds[6][7] <= ~estado_leds[6][7];
                estado_leds[7][5] <= ~estado_leds[7][5];
                estado_leds[7][6] <= ~estado_leds[7][6];
                estado_leds[7][7] <= ~estado_leds[7][7];
            end
            if (botoes[7]) begin
                estado_leds[0][6] <= ~estado_leds[0][6];
                estado_leds[0][7] <= ~estado_leds[0][7];
                estado_leds[1][6] <= ~estado_leds[1][6];
                estado_leds[1][7] <= ~estado_leds[1][7];
                estado_leds[2][6] <= ~estado_leds[2][6];
                estado_leds[2][7] <= ~estado_leds[2][7];
                estado_leds[3][6] <= ~estado_leds[3][6];
                estado_leds[3][7] <= ~estado_leds[3][7];
                estado_leds[4][7] <= ~estado_leds[4][7];
            end
        end
    end

    // Ciclo para alternar entre as linhas da matriz
    always @(posedge clk) begin
        linha_atual <= linha_atual + 1; // Soma 1 a cada pulso de clock 
    end

    // Ativação da linha atual (apenas uma linha por vez)
    assign linhas = linha_atual;
    

    // Colunas recebem valores da linha ativa
    assign colunas = estado_leds[linha_atual];  

    assign db_linha = linha_atual;
    assign db_clock = clk;
    assign db_reset = rst; 

endmodule
