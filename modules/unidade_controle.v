//------------------------------------------------------------------
// Arquivo   : exp3_unidade_controle_desafio.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/01/2024  1.0     Edson Midorikawa  versao inicial
//     12/01/2025  1.1     Edson Midorikawa  revisao
//------------------------------------------------------------------
//
module unidade_controle (
    input clock,
    input reset,
    input iniciar,
    input nivel_concluido,
    input nivelIgualUltimoNivel,
    input nivelMenorOuIgualUltimoNivel,
    output reg ganhou,
    output reg contaN,
    output reg zeraN,
    output reg zeraM,
    output reg [4:0] db_estado
);

    // Define estados
    parameter inicial            = 5'b00000;  // 0
    parameter preparacao         = 5'b00001;  // 1
    parameter inic_nivel         = 5'b00010;  // 2
    parameter jogando            = 5'b00011;  // 3
    parameter checa_ultimo_nivel = 5'b00100;  // 4
    parameter proximo_nivel      = 5'b00101;  // 5
    parameter est_ganhou         = 5'b00110;  // 6 


    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:            Eprox = iniciar ? preparacao : inicial;
            preparacao:         Eprox = inic_nivel;
            inic_nivel:         Eprox = jogando;
            jogando:            Eprox = nivel_concluido ? checa_ultimo_nivel : jogando;
            checa_ultimo_nivel: 
            begin 
                if (nivelIgualUltimoNivel)
                    Eprox =  est_ganhou;
                else 
                    Eprox = proximo_nivel;
            end
            proximo_nivel:      Eprox = inic_nivel;
            est_ganhou:         Eprox = iniciar ? preparacao : est_ganhou;
            default:            Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        // Inicializa todas as saídas com valores padrão
        contaN       = 1'b0;
        zeraN        = 1'b0;
        zeraM        = 1'b0;
        ganhou       = 1'b0;

        // Define sinais de controle
        case (Eatual)
            inicial: begin
                zeraN = 1'b1;
                zeraM = 1'b1;
            end

            preparacao: begin
                zeraN = 1'b1;
                zeraM = 1'b1;
            end

            inic_nivel: begin
                zeraM = 1'b1;
            end

            proximo_nivel: begin
                contaN = 1'b1;
            end

            est_ganhou: begin
                ganhou = 1'b1;
            end

            default: begin
                // Mantém os sinais padrão
            end
        endcase

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:            db_estado = 5'b00000;  // 0 
            preparacao:         db_estado = 5'b00001;  // 1
            inic_nivel:         db_estado = 5'b00010;  // 2
            jogando:            db_estado = 5'b00011;  // 3
            checa_ultimo_nivel: db_estado = 5'b00100;  // 4
            proximo_nivel:      db_estado = 5'b00101;  // 5
            est_ganhou:         db_estado = 5'b00110;  // 6 
            default:            db_estado = 5'b11111;  // E (erro)
        endcase
    end

endmodule
