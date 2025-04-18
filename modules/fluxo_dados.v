/*
 * ------------------------------------------------------------------
 *  Fluxo de dados do Albatea
 * ------------------------------------------------------------------
 */


module fluxo_dados (
  input  clock,
  input  contaN,  
  input  zeraN, 
  input  contaT,
  input  zeraT, 
  input  contaP,
  input  zeraP,   
  input  zeraM, 
  input  rst_niv,
  input  ganhou,
  input  passou_nivel,
  input  [7:0] botoes,
  output fimT,
  output fimP,
  output nivel_concluido,
  output [7:0] colunas,
  output [7:0] linhas,
  output nivelIgualUltimoNivel,
  output nivelMenorOuIgualUltimoNivel,
  output [2:0] db_nivel,
  output [7:0] db_botoes
);

  // sinais internos para interligacao dos componentes
  wire [7:0] balling;
  wire [2:0] s_nivel;
  wire [7:0] s_botoes;
  wire [2:0] s_indice;
  wire [7:0] s_col_reg;
  wire [7:0] s_col_mat;
  wire s_sinal;
  wire s_reg_enable;

  // contador_163 nivel
  contador_163 contador_nivel (
    .clock ( clock ),
    .clr   ( ~zeraN ),
    .ld    ( 1'b1 ),
    .ent   ( 1'b1 ),
    .enp   ( contaN ),
    .D     ( 3'b000 ),
    .Q     ( s_nivel ),
    .rco   (  )          // n precisa por enquanto
  );

  // Matriz de leds
  matriz_leds matriz (
    .clk             ( clock ),              
    .rst             ( zeraM ), 
    .rst_niv	      ( rst_niv ),
    .botoes          ( s_botoes ),     
    .nivel           ( s_nivel ),      
    .nivel_concluido ( nivel_concluido ), 
    .colunas         ( s_col_mat ),   
    .linhas          ( linhas ),
    .indice          ( s_indice )   
  );

  // comparador_85 nivel
  comparador_85 comparador_nivel (
    .A    ( s_nivel ),
    .B    ( 3'b100 ),
    .ALBi ( 1'b0 ),
    .AGBi ( 1'b0 ),
    .AEBi ( 1'b1 ),
    .ALBo (  ),                        // Não utilizado
    .AGBo ( nivelMenorOuIgualUltimoNivel ),                    
    .AEBo ( nivelIgualUltimoNivel )
  );

  // edge detector global
  edge_detector_global edging_geral (
    .clock         ( clock ),
    .reset         ( zeraM ),
    .botoes        ( balling ),
    .edge_detected ( s_botoes )
  );

  // edge detector
  edge_detector edging (
    .clock( clock ),
    .reset( zeraM ),
    .sinal( s_sinal ),
    .pulso( s_reg_enable )
  );

  // registrador do db_botões
  registrador_8 reg_botoes (
    .clock         ( clock ),
    .clear         ( zeraM ),
    .enable        ( s_reg_enable ),
    .D             ( botoes ),
    .Q             ( db_botoes )
  );

  // registrador para o desenho de vitória e todos acesos
  reg_8x8 reg_desenho (
    .clock       ( clock ),
    .reset       ( zeraM ),
    .indice      ( s_indice ),
    .vitoria     ( ganhou ),
    .coluna_sel  ( s_col_reg )
  );

  // timer da piscagem
  contador_m #(20_000_000, 25) timer_piscagem (             
    .clock   ( clock ),
    .zera_as ( 1'b0 ),
    .zera_s  ( zeraT ),
    .conta   ( contaT ),
    .Q       (  ), 
    .fim     ( fimT ),
    .meio    (  )
  );

  // contador da piscagem
  contador_m #(3, 2) contador_piscagem ( 
    .clock   ( clock ),
    .zera_as ( 1'b0 ),
    .zera_s  ( zeraP ),
    .conta   ( contaP ), 
    .Q       (  ),
    .fim     ( fimP ),
    .meio    (  )
  );

  debounce debouncer (
    .clk  ( clock ),
    .btn  ( botoes ),
    .btn_clean ( balling )
  );


  // entrada edger
  assign s_sinal = |balling;

  // saida da coluna
  assign colunas = passou_nivel ? s_col_reg : s_col_mat;

  // saida de depuracao
  assign db_nivel  = s_nivel;

endmodule
