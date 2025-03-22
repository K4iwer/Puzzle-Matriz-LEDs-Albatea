// -------------------------------------------
// Modulo principal que conecta a UC com o FD
// -------------------------------------------

module jogo_desafio_memoria (
    input  clock,
    input  reset,
    input  jogar,
    input  [7:0] botoes,
    output [7:0] colunas,
    output [7:0] linhas,
    output ganhou,
    output [6:0] db_estado,
    output [6:0] db_nivel,
    output [6:0] db_botoes
);

    // Sinais internos para interligacao dos componentes
    wire s_nivel_concluido;
    wire s_nivelIgualUltimoNivel;
    wire s_nivelMenorOuIgualUltimoNivel;
    wire s_contaN;
    wire s_zeraN;
    wire s_zeraM;
    wire s_contaT;
    wire s_zeraT;
    wire s_contaP;
    wire s_zeraP;
    wire s_ganhou;
    wire s_passou_nivel;
    wire s_fimT;
    wire s_fimP;
    wire [4:0] s_estado;
    wire [2:0] s_nivel;
    wire [7:0] s_botoes;

    // Unidade de controle
    unidade_controle unidade_controle (
        .clock                        ( clock ),    
        .reset                        ( reset ),
        .iniciar                      ( jogar ),
        .fimT                         ( s_fimT ),
        .fimP                         ( s_fimP ),
        .nivel_concluido              ( s_nivel_concluido ),
        .nivelIgualUltimoNivel        ( s_nivelIgualUltimoNivel ),
        .nivelMenorOuIgualUltimoNivel ( s_nivelMenorOuIgualUltimoNivel ),
        .ganhou                       ( s_ganhou ),
        .passou_nivel                 ( s_passou_nivel ),
        .contaN                       ( s_contaN ),
        .zeraN                        ( s_zeraN ),
        .contaT                       ( s_contaT ),
        .zeraT                        ( s_zeraT ), 
        .contaP                       ( s_contaP ),
        .zeraP                        ( s_zeraP ), 
        .zeraM                        ( s_zeraM ),
        .db_estado                    ( s_estado )
    );

    // Fluxo de dados
    fluxo_dados fluxo_dados (
        .clock                        ( clock ),        
        .contaN                       ( s_contaN ),  
        .zeraN                        ( s_zeraN ), 
        .contaT                       ( s_contaT ),
        .zeraT                        ( s_zeraT ), 
        .contaP                       ( s_contaP ),
        .zeraP                        ( s_zeraP ),   
        .zeraM                        ( s_zeraM ),   
        .ganhou                       ( s_ganhou ),
        .passou_nivel                 ( s_passou_nivel ),
        .botoes                       ( botoes ),
        .fimT                         ( s_fimT ),
        .fimP                         ( s_fimP ),
        .nivel_concluido              ( s_nivel_concluido ),
        .colunas                      ( colunas ),
        .linhas                       ( linhas ),
        .nivelIgualUltimoNivel        ( s_nivelIgualUltimoNivel ),
        .nivelMenorOuIgualUltimoNivel ( s_nivelMenorOuIgualUltimoNivel ),
        .db_nivel                     ( s_nivel ),
        .db_botoes                    ( s_botoes )
    );

    // Display dos niveis
    hexa7seg_ent3bit HEX0 (
        .hexa    ( s_nivel ), 
        .display ( db_nivel )
    );

    // Display dos botões
    hexa7seg_ent8bit HEX1 (
        .hexa    ( s_botoes ), 
        .display ( db_botoes )
    );

    // Display dos estados
    hexa7seg_mod HEX2 (
        .hexa    ( s_estado ),
        .display ( db_estado )
    );

    // Saida depuração
    assign ganhou = s_ganhou;

endmodule
