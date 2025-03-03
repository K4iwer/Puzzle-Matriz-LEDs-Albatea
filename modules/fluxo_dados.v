/*
 * ------------------------------------------------------------------
 *  Arquivo   : exp3_fluxo_dados.v
 *  Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
 * ------------------------------------------------------------------
 *  Descricao : Fluxo de dados da atividade 3
 * ------------------------------------------------------------------
 */


module fluxo_dados (
  input clock,
  input registraR,
  input limpaR,
  input registraM,
  input limpaM,
  input contaL,
  input zeraL,
  input contaE,
  input zeraE,
  input contaTMR,
  input botao_coringa_in, //
  input zeraTMR,
  input reset_timer,
  input [3:0] botoes,
  input [1:0] BotoesOuMemoria,
  input nivel,
  output chavesIgualMemoria,
  output enderecoMenorOuIgualLimite,
  output enderecoIgualLimite,
  output fimE,
  output fimL,
  output fimTMR,
  output jogada_feita,
  output botao_coringa_out,  //
  output db_tem_jogada,
  output [3:0]  db_contagem,
  output [3:0]  db_memoria,
  output [3:0]  db_jogada,
  output [3:0]  db_limite,
  output [12:0] db_segundos,
  output timeout,
  output [3:0] leds
);

  // sinais internos para interligacao dos componentes
  wire   [3:0] s_limite;
  wire   [3:0] s_endereco;
  wire   [3:0] s_jogada;
  wire   [3:0] s_dado;
  wire   [12:0] s_segundos;
  wire         sinal_det;
  wire [3:0] s_leds;
  wire s_fim;
  wire s_meio;

  // contador_163 Limite
  contador_m #( .M (16), .N(4) ) contador_limt (
    .clock    ( clock ),
    .zera_as  ( zeraL ),
	 .zera_s   ( zeraL ),
    .conta    ( contaL ),
    .Q        ( s_limite ),
    .fim      ( s_fim ),
	 .meio     ( s_meio )
  );

  // contador_163 End
  contador_163 contador_End (
    .clock( clock ),
    .clr  ( ~zeraE ),
    .ld   ( 1'b1 ),
    .ent  ( 1'b1 ),
    .enp  ( contaE ),
    .D    ( 4'b0000 ),
    .Q    ( s_endereco ),
    .rco  ( fimE )
  );

  // comparador_85 Jogada
  comparador_85 comparador_Jog (
    .A   ( s_dado ),
    .B   ( s_jogada ),
    .ALBi( 1'b0 ),
    .AGBi( 1'b0 ),
    .AEBi( 1'b1 ),
    .ALBo(  ),                        // Não utilizado
    .AGBo(  ),                        // Não utilizado
    .AEBo( chavesIgualMemoria )
  );

  // comparador_85 Limite
  comparador_85 comparador_Lmt (
    .A   ( s_limite ),
    .B   ( s_endereco ),
    .ALBi( 1'b0 ),
    .AGBi( 1'b0 ),
    .AEBi( 1'b1 ),
    .ALBo(  ),                        // Não utilizado
    .AGBo( enderecoMenorOuIgualLimite ),             
    .AEBo( enderecoIgualLimite )
  );

  // memória Jogada
  sync_rom_16x4 memoria_jogada (            // na imagem do fluxo de dados tem mais sinal do q a memória consegue receber
    .clock    ( clock ),
    .address  ( s_endereco ),
    .data_out ( s_dado )
  );

  // registrador botoes
  registrador_4 regBotoes (
    .clock  ( clock ),
    .clear  ( limpaR ),
    .enable ( registraR ),
    .D      ( botoes ),
    .Q      ( s_jogada )
  );

  // registrador mem
  registrador_4 regMem (                      // Teve que acrescentar esse reg
    .clock  ( clock ),
    .clear  ( limpaM ),
    .enable ( registraM ),
    .D      ( s_dado ),
    .Q      ( db_memoria )
  );

  // contador m timeout
  contador_m #(5000, 13) contador_timeout (                  // Teve que acrescentar esse conatdor pro timeout
    .clock   ( clock ),
    .zera_as ( 1'b0 ),
    .zera_s  ( reset_timer ),
    .conta   ( 1'b1 ),
    .Q       ( s_segundos ), 
    .fim     ( timeout ),
    .meio    (  )
  );

  // contador m Timer
  contador_m #(500, 13) timer_500ms (           // Teve q acrescentar esse timer
    .clock   ( clock ),
    .zera_as ( 1'b0 ),
    .zera_s  ( zeraTMR ),
    .conta   ( contaTMR ),
    .Q       (  ), 
    .fim     ( fimTMR ),
    .meio    (  )
  );
  
  // Mux
  mux2x1 muxMeioOuFim(
	.D0  ( s_meio ),
	.D1  ( s_fim ),
	.SEL ( nivel ),
	.OUT ( fimL )
  );

  // edge detector
  edge_detector detector (               // n tá na imagem do fluxo de dados, mas acho q ainda é importante manter ele
    .clock ( clock ),
    .reset ( zeraL ),                    // teve q mudar isso
    .sinal ( sinal_det ),           
    .pulso ( jogada_feita )
  );

  // edge detector
  edge_detector detector_coringa (            //novo
    .clock ( clock ),
    .reset ( zeraL ),               
    .sinal ( botao_coringa_in ),           
    .pulso ( botao_coringa_out )
  );

  // WideOr0
  assign sinal_det = |botoes;

  // MUX pra botoes/memoria
  assign s_leds = BotoesOuMemoria == 2'b01 ? s_dado : 
						BotoesOuMemoria == 2'b00 ? botoes : 4'b0000;


  assign leds = s_leds;

  // saida de depuracao
  assign db_contagem = s_endereco;
  assign db_jogada = s_jogada;
  assign db_tem_jogada = sinal_det;   
  assign db_limite = s_limite;
  assign db_segundos = s_segundos;

endmodule
