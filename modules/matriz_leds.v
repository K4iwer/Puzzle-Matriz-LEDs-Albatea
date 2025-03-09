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
                estado_leds[1][1] <= ~estado_leds[1][1];
            end 

            if (botoes[1]) begin
                estado_leds[2][3] <= ~estado_leds[2][3];
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
