/*
 * ------------------------------------------------------------------
 *  Arquivo   : fluxo_dados.v
 *  Projeto   : Projeto de jogo com matriz de leds
 * ------------------------------------------------------------------
 *  Descricao : Fluxo de dados do projeto
 * ------------------------------------------------------------------
 */


module fluxo_dados (
  input  clock,
  input  contaN,  
  input  zeraN,   
  input  zeraM,   
  input  [7:0] botoes,
  output nivel_concluido,
  output [7:0] colunas,
  output [7:0] linhas,
  output nivelIgualUltimoNivel,
  output nivelMenorOuIgualUltimoNivel,
  output [2:0] db_nivel,
  output [7:0] db_botoes
);

  // sinais internos para interligacao dos componentes
  wire [2:0] s_nivel;
  wire [7:0] s_botoes;
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
    .botoes          ( s_botoes ),     
    .nivel           ( s_nivel ),      
    .nivel_concluido ( nivel_concluido ), 
    .colunas         ( colunas ),   
    .linhas          ( linhas )     
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
    .botoes        ( botoes ),
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
    .enable        ( s_reg_enable  ),
    .D             ( botoes ),
    .Q             ( db_botoes )
  );

  // entrada edger
  assign s_sinal = |botoes;

  // saida de depuracao
  assign db_nivel  = s_nivel;

endmodule
