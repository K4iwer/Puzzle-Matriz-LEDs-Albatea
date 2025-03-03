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
    input chavesIgualMemoria,
    input enderecoMenorOuIgualLimite,
    input enderecoIgualLimite,
    input fimE,
    input fimL,
    input fimTMR,
    input jogada_feita,
    input timeout_in,
    output reg registraR,
    output reg limpaR,
    output reg registraM,
    output reg limpaM,
    output reg contaL,
    output reg zeraL,
    output reg contaE,
    output reg zeraE,
    output reg contaTMR,
    output reg zeraTMR,
    output reg acertou,
    output reg errou,
    output reg timeout,
    output reg pronto,
    output reg [4:0] db_estado,
    output reg reset_timer,
    output reg [1:0] BotoesOuMemoria
);

    // Define estados
    parameter inicial           = 5'b00000;  // 0
    parameter preparacao        = 5'b00001;  // 1
    parameter inic_sequencia    = 5'b00010;  // 2
    parameter carrega_dado      = 5'b00011;  // 3
    parameter mostra_dado       = 5'b00100;  // 4
    parameter zera_led          = 5'b00101;  // 5
    parameter mostra_apagado    = 5'b00110;  // 6 passa pro jogo se ter terminado sequencia
    parameter proximo_led       = 5'b00111;  // 7
    parameter estabiliza_cont   = 5'b10010;  // 18
    parameter prepara_jogada    = 5'b01000;  // 8 Reinicia a sequencia do contador de memória
    parameter esp_jogada        = 5'b01001;  // 9
    parameter registra          = 5'b01010;  // 10
    parameter comparacao        = 5'b01011;  // 11
    parameter proximo           = 5'b01100;  // 12
    parameter checa_ultima_seq  = 5'b01110;  // 14
    parameter proxima_sequencia = 5'b01111;  // 15
    parameter final_acertou     = 5'b10000;  // 16
    parameter final_errou       = 5'b01101;  // D
    parameter est_timeout       = 5'b10001;  // 17


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
            inicial:           Eprox = iniciar ? preparacao : inicial;
            preparacao:        Eprox = inic_sequencia;
            inic_sequencia:    Eprox = carrega_dado;
            carrega_dado:      Eprox = mostra_dado;
            mostra_dado:       Eprox = fimTMR ? zera_led : mostra_dado;
            zera_led:          Eprox = mostra_apagado;
            mostra_apagado:    
            begin 
                if (!fimTMR)
                    Eprox =  mostra_apagado;
                else if (fimTMR && !enderecoIgualLimite)
                    Eprox = proximo_led; 
                else
                    Eprox = prepara_jogada;
            end
            proximo_led:       Eprox = estabiliza_cont;
            estabiliza_cont:   Eprox = carrega_dado;
            prepara_jogada:    Eprox = esp_jogada;
            esp_jogada:        
            begin 
                if (jogada_feita && !timeout_in)
                    Eprox =  registra;
                else if (timeout_in)
                    Eprox = est_timeout; 
                else
                    Eprox = esp_jogada;
            end    
            registra:          Eprox = comparacao;
            comparacao:  
            begin 
                if (chavesIgualMemoria && enderecoMenorOuIgualLimite && !enderecoIgualLimite)
                    Eprox =  proximo;
                else if (chavesIgualMemoria && enderecoIgualLimite)
                    Eprox = checa_ultima_seq; 
                else
                    Eprox = final_errou;
            end
            proximo:           Eprox = esp_jogada;
            checa_ultima_seq:  Eprox = fimL ? final_acertou : proxima_sequencia;
            proxima_sequencia: Eprox = inic_sequencia;
            final_acertou:     Eprox = iniciar ? preparacao : final_acertou;
            final_errou:       Eprox = iniciar ? preparacao : final_errou;
            est_timeout:       Eprox = iniciar ? preparacao : est_timeout;
            default:           Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        // Inicializa todas as saídas com valores padrão
        zeraL       = 1'b0;
        zeraE       = 1'b0;
        zeraTMR     = 1'b0;
        limpaR      = 1'b0;
        limpaM      = 1'b0;
        registraR   = 1'b0;
        registraM   = 1'b0;
        contaL      = 1'b0;
        contaE      = 1'b0;
        contaTMR    = 1'b0;
        pronto      = 1'b0;
        acertou     = 1'b0;
        errou       = 1'b0;
        timeout     = 1'b0;
        reset_timer = 1'b0;
        BotoesOuMemoria = 2'b11;

        // Define sinais de controle
        case (Eatual)
            inicial: begin
                zeraL = 1'b1;
            end

            preparacao: begin
                zeraL       = 1'b1;
                zeraE       = 1'b1;
                zeraTMR     = 1'b1;
                limpaR      = 1'b1;
                limpaM      = 1'b1;
            end

            inic_sequencia: begin
                zeraE       = 1'b1;
                limpaR      = 1'b1;
                limpaM      = 1'b1;
                reset_timer = 1'b1;
            end

            carrega_dado: begin
                zeraTMR     = 1'b1;
                registraM   = 1'b1;   //saida da memória mostra os leds
            end

            mostra_dado: begin
                BotoesOuMemoria = 2'b01;
                contaTMR    = 1'b1;
            end

            zera_led: begin
                zeraTMR     = 1'b1;
                limpaM      = 1'b1;
            end

            mostra_apagado: begin
                BotoesOuMemoria = 2'b11;
                contaTMR    = 1'b1;
            end

            proximo_led: begin
                contaE      = 1'b1;
            end


            prepara_jogada: begin
                zeraE       = 1'b1;
                limpaR      = 1'b1;
                limpaM      = 1'b1;
                reset_timer = 1'b1;
            end
            
            esp_jogada: begin
                    BotoesOuMemoria = 2'b00;
            end
				
            registra: begin
                registraR   = 1'b1;
				BotoesOuMemoria = 2'b00;
            end
				
			comparacao: begin 
				BotoesOuMemoria = 2'b00;
			end

            proxima_sequencia: begin
                contaL = 1'b1;
                zeraE  = 1'b1;
            end

            proximo: begin
                contaE      = 1'b1;
                reset_timer = 1'b1;
				BotoesOuMemoria = 2'b00;
            end

            final_acertou: begin
                pronto  = 1'b1;
                acertou = 1'b1;
            end

            final_errou: begin
                pronto = 1'b1;
                errou  = 1'b1;
            end

            est_timeout: begin
                pronto  = 1'b1;
                errou   = 1'b1;
                timeout = 1'b1;
            end

            default: begin
                // Mantém os sinais padrão
            end
        endcase

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:           db_estado = 5'b00000;  // 0
            preparacao:        db_estado = 5'b00001;  // 1
            inic_sequencia:    db_estado = 5'b00010;  // 2
            carrega_dado:      db_estado = 5'b00011;  // 3
            mostra_dado:       db_estado = 5'b00100;  // 4
            zera_led:          db_estado = 5'b00101;  // 5
            mostra_apagado:    db_estado = 5'b00110;  // 6 
            proximo_led:       db_estado = 5'b00111;  // 7
            estabiliza_cont:   db_estado = 5'b10010;  // 18
            prepara_jogada:    db_estado = 5'b01000;  // 8 
            esp_jogada:        db_estado = 5'b01001;  // 9
            registra:          db_estado = 5'b01010;  // 10
            comparacao:        db_estado = 5'b01011;  // 11
            proximo:           db_estado = 5'b01100;  // 12
            checa_ultima_seq:  db_estado = 5'b01110;  // 14
            proxima_sequencia: db_estado = 5'b01111;  // 15
            final_acertou:     db_estado = 5'b10000;  // 16
            final_errou:       db_estado = 5'b01101;  // D 13
            est_timeout:       db_estado = 5'b10001;  // 17
            default:           db_estado = 5'b11111;  // E (erro)
        endcase
    end

endmodule
