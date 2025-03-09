module matriz_leds (
    input logic clk,  // Clock principal da FPGA
    input logic rst,  // Botão de reset
    input logic [5:0] botoes, // Entrada dos botões físicos
    input logic [7:0] nivel_requerido, // Máscara da linha necessária para vencer
    input logic [2:0] linha_verificada, // Linha a ser verificada para a vitória
    output logic nivel_concluido, // Output que avisa a UC se venceu
    output logic [7:0] colunas, // Sinais para as colunas da matriz de LEDs
    output logic [7:0] linhas   // Sinais para ativar linhas da matriz
);

    logic [7:0] estado_leds [7:0]; // Matriz virtual para armazenar estado das LEDs
    logic [2:0] linha_atual; // Variável para escanear as linhas

    // Reset: Apaga todas as LEDs no início
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i, j;
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
    always_ff @(posedge clk) begin
        linha_atual <= linha_atual + 1; // Muda a linha ativa
    end

    // Ativação da linha atual (apenas uma linha por vez)
    assign linhas = ~(1 << linha_atual);

    // Colunas recebem valores da linha ativa
    assign colunas = estado_leds[linha_atual];

    // Verificação de vitória: se a linha_verificada está toda acesa como o esperado
    assign nivel_concluido = (estado_leds[linha_verificada] == nivel_requerido);

endmodule
