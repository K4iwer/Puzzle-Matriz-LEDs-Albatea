


module jogo_desafio_memoria (
    input clock,
    input reset,
    input jogar,
    input [3:0] botoes,
	 input nivel,
    output [3:0] leds,
    output ganhou,
    output perdeu,
    output pronto,
    output timeout,
    output db_tem_jogada,
    output [6:0] db_jogadafeita, 
    output [6:0] db_contagem, 
    output [6:0] db_memoria,  
    output [6:0] db_estado,   
    output [6:0] db_sequencia
);

    // Sinais internos para interligacao dos componentes

    wire       s_chavesIgualMemoria;
    wire       s_enderecoMenorOuIgualLimite;
    wire       s_enderecoIgualLimite;
    wire       s_fimE;
    wire       s_fimL;
    wire       s_jogada_feita;
    wire       s_registraR;
    wire       s_limpaR;
    wire       s_contaL;
    wire       s_zeraL;
    wire       s_contaE;
    wire       s_zeraE;
    wire       s_contaTMR;
    wire       s_zeraTMR;
    wire       s_limpaM;
    wire       s_registraM;
    wire       s_timeout;
    wire       s_reset_timer;
    wire [4:0] s_estado;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_jogada;
    wire [3:0] s_limite;
    wire [12:0] s_segundos;
    wire [1:0] s_BotoesOuMemoria;
	 wire s_fimTMR;
    wire [3:0] s_leds;

    // Unidade de controle
    unidade_controle unidade_controle (
        .clock                      ( clock ),
        .reset                      ( reset ),
        .iniciar                    ( jogar ),
        .chavesIgualMemoria         ( s_chavesIgualMemoria ),
        .enderecoMenorOuIgualLimite ( s_enderecoMenorOuIgualLimite ),
        .enderecoIgualLimite        ( s_enderecoIgualLimite ),
        .fimE                       ( s_fimE ),
        .fimL                       ( s_fimL ),
        .fimTMR                     ( s_fimTMR ),
        .jogada_feita               ( s_jogada_feita ),
        .timeout_in                 ( s_timeout ),
        .registraR                  ( s_registraR ),
        .limpaR                     ( s_limpaR ),
        .registraM                  ( s_registraM ),
        .limpaM                     ( s_limpaM),
        .contaL                     ( s_contaL ), 
        .zeraL                      ( s_zeraL ),
        .contaE                     ( s_contaE ),
        .zeraE                      ( s_zeraE ),
        .contaTMR                   ( s_contaTMR ),
        .zeraTMR                    ( s_zeraTMR ),
        .acertou                    ( ganhou ),
        .errou                      ( perdeu ),
        .timeout                    ( timeout ),
        .pronto                     ( pronto ),
        .db_estado                  ( s_estado ),
        .reset_timer                ( s_reset_timer ),
        .BotoesOuMemoria            ( s_BotoesOuMemoria )
    );

    // Fluxo de dados
    fluxo_dados fluxo_dados (
        .clock                      ( clock ),
        .registraR                  ( s_registraR ),
        .limpaR                     ( s_limpaR ),
        .registraM                  ( s_registraM ),
        .limpaM                     ( s_limpaM ),
        .contaL                     ( s_contaL ),
        .zeraL                      ( s_zeraL ),
        .contaE                     ( s_contaE ),
        .zeraE                      ( s_zeraE ),
        .contaTMR                   ( s_contaTMR ),
        .zeraTMR                    ( s_zeraTMR ),
        .botoes                     ( botoes ),
        .chavesIgualMemoria         ( s_chavesIgualMemoria ),
        .enderecoMenorOuIgualLimite ( s_enderecoMenorOuIgualLimite ),
        .enderecoIgualLimite        ( s_enderecoIgualLimite ),
        .fimE                       ( s_fimE ),
        .fimL                       ( s_fimL ),
        .fimTMR                     ( s_fimTMR ),
		  .nivel                      (nivel),
        .jogada_feita               ( s_jogada_feita ),
        .db_tem_jogada              ( db_tem_jogada ),
        .db_contagem                ( s_contagem ),
        .db_memoria                 ( s_memoria ),
        .db_jogada                  ( s_jogada ),
        .db_limite                  ( s_limite ),
        .db_segundos                ( s_segundos ),
        .timeout                    ( s_timeout ),
        .reset_timer                ( s_reset_timer ),
        .BotoesOuMemoria            ( s_BotoesOuMemoria ),
        .leds                       ( s_leds )
    );

    // Display das jogadas
    hexa7seg HEX2 (
        .hexa    ( s_jogada ), 
        .display ( db_jogadafeita )
    );

    // Display da contagem
    hexa7seg HEX0 (
        .hexa    ( s_contagem ), 
        .display ( db_contagem )
    );

    // Display da memória
    hexa7seg HEX1 (
        .hexa    ( s_memoria ), 
        .display ( db_memoria )
    );

    // Display do limite
    hexa7seg HEX3 (
        .hexa    ( s_limite ), 
        .display ( db_sequencia )
    );

    // Display de estados
    hexa7seg_mod HEX5 (
        .hexa    ( s_estado ), 
        .display ( db_estado )
    );
    assign leds = s_leds;

endmodule
