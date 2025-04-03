module debounce (
    input wire clk,       // Clock do sistema
    input wire [7:0] btn,       // Entrada do botão
    output reg [7:0] btn_clean  // Saída filtrada
);
    reg [23:0] count;    // Contador de debounce
    reg [7:0] btn_reg;         // Estado anterior do botão

    always @(posedge clk) begin
        if (btn == btn_reg) begin
            if (count < 5_000_000)   // Ajuste o valor conforme necessário
                count <= count + 1'b1;
        end else begin
            count <= 0;
        end
        
        if (count == 5_000_000)
            btn_clean <= btn;

        btn_reg <= btn;
    end
endmodule
