// -----------------------------
// Módulo de edge detector 
// para todos os botões
// ----------------------------- 

module edge_detector_global (
    input  clock,
    input  reset,
    input  [7:0] botoes,
    output reg [7:0] edge_detected
);

    reg [7:0] botoes_anterior;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            botoes_anterior <= 8'b00000000;  // Zera valores
            edge_detected   <= 8'b00000000;  // Zera saida
        end else begin
            edge_detected   <= (botoes & ~botoes_anterior); // Detecta borda de subida para todos os botões
            botoes_anterior <= botoes; // Atualiza o estado anterior
        end
    end
endmodule

