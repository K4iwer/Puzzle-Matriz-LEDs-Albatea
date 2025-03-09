/*
    Este módulo é o controlador de uma matriz de leds. Ele trata as linhas da matriz como terra e as 
    colunas como fase, logo, para ativar algo na linha 5, ele faz linhas = 01111 e ativa o que quiser
    nas colunas. 


    */

module matriz_leds (
    input wire clk,              // Clock principal da FPGA
    input wire rst,              // Botão de reset
    input wire [5:0] botoes,     // Entrada dos botões físicos
    input wire [2:0] nivel,      // Nivel atual do jogador
    output reg nivel_concluido, // Output que avisa a UC se venceu
    output wire [7:0] colunas,   // Sinais para as colunas da matriz de LEDs
    output wire [7:0] linhas     // Sinais para ativar linhas da matriz
);

    reg [7:0] estado_leds [7:0]; // Matriz virtual para armazenar estado das LEDs
    reg [2:0] linha_atual; // Variável para escanear as linhas
    integer i, j;

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
    always @(posedge clk or posedge rst) begin
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
                estadoleds[4][2] <= ~estado_leds[4][2];
                estadoleds[5][2] <= ~estado_leds[5][2];
                estadoleds[5][3] <= ~estado_leds[5][3];
                estadoleds[6][2] <= ~estado_leds[6][2];
                estadoleds[6][3] <= ~estado_leds[6][3];
                estadoleds[7][0] <= ~estado_leds[7][0];
                estadoleds[7][1] <= ~estado_leds[7][1];
                estadoleds[7][2] <= ~estado_leds[7][2];
                estadoleds[7][3] <= ~estado_leds[7][3];
            end
        
            if (botoes[3]) begin
                estadoleds[5][3] <= ~estado_leds[5][3];
                estadoleds[5][4] <= ~estado_leds[5][4];
                estadoleds[5][5] <= ~estado_leds[5][5];
                estadoleds[6][3] <= ~estado_leds[6][3];
                estadoleds[6][4] <= ~estado_leds[6][4];
                estadoleds[6][5] <= ~estado_leds[6][5];
                estadoleds[7][3] <= ~estado_leds[7][3];
                estadoleds[7][4] <= ~estado_leds[7][4];
                estadoleds[7][5] <= ~estado_leds[7][5];
            end
            if (botoes[4]) begin
                estadoleds[0][3] <= ~estado_leds[0][3];
                estadoleds[0][4] <= ~estado_leds[0][4];
                estadoleds[1][3] <= ~estado_leds[1][3];
                estadoleds[1][4] <= ~estado_leds[1][4];
                estadoleds[2][3] <= ~estado_leds[2][3];
                estadoleds[2][4] <= ~estado_leds[2][4];
                estadoleds[3][3] <= ~estado_leds[3][3];
                estadoleds[3][4] <= ~estado_leds[3][4];
                estadoleds[4][3] <= ~estado_leds[4][3];
            end
            if (botoes[5]) begin
                estadoleds[0][5] <= ~estado_leds[0][5];
                estadoleds[1][5] <= ~estado_leds[1][5];
                estadoleds[2][5] <= ~estado_leds[2][5];
                estadoleds[2][6] <= ~estado_leds[2][6];
                estadoleds[3][5] <= ~estado_leds[3][5];
                estadoleds[3][6] <= ~estado_leds[3][6];
                estadoleds[4][4] <= ~estado_leds[4][4];
                estadoleds[4][5] <= ~estado_leds[4][5];
                estadoleds[4][6] <= ~estado_leds[4][6];
            end
            if (botoes[6]) begin
                estadoleds[5][5] <= ~estado_leds[5][5];
                estadoleds[5][6] <= ~estado_leds[5][6];
                estadoleds[5][7] <= ~estado_leds[5][7];
                estadoleds[6][5] <= ~estado_leds[6][5];
                estadoleds[6][6] <= ~estado_leds[6][6];
                estadoleds[6][7] <= ~estado_leds[6][7];
                estadoleds[7][5] <= ~estado_leds[7][5];
                estadoleds[7][6] <= ~estado_leds[7][6];
                estadoleds[7][7] <= ~estado_leds[7][7];
            end
            if (botoes[7]) begin
                estadoleds[0][6] <= ~estado_leds[0][6];
                estadoleds[0][7] <= ~estado_leds[0][7];
                estadoleds[1][6] <= ~estado_leds[1][6];
                estadoleds[1][7] <= ~estado_leds[1][7];
                estadoleds[2][6] <= ~estado_leds[2][6];
                estadoleds[2][7] <= ~estado_leds[2][7];
                estadoleds[3][6] <= ~estado_leds[3][6];
                estadoleds[3][7] <= ~estado_leds[3][7];
                estadoleds[4][7] <= ~estado_leds[4][7];
            end
        end
    end

    // Ciclo para alternar entre as linhas da matriz
    always @(posedge clk) begin
        linha_atual <= linha_atual + 1; // Muda a linha ativa
    end

    // Ativação da linha atual (apenas uma linha por vez)
    assign linhas = ~(1 << linha_atual);

    // Colunas recebem valores da linha ativa
    assign colunas = estado_leds[linha_atual];  

endmodule
