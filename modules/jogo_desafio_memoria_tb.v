/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp4_tb-MODELO.v
 * Projeto   : Experiencia 4 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog MODELO para circuito da Experiencia 5 
 *
 *             1) Plano de teste com 4 jogadas certas  
 *                e erro na quinta jogada
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     27/01/2024  1.0     Edson Midorikawa  versao inicial
 *     16/01/2024  1.1     Edson Midorikawa  revisao
 * --------------------------------------------------------------------
 */

`timescale 1ns/1ns

module jogo_desafio_memoria_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in = 0;
    reg        nivel_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;

    wire       acertou_out;
    wire       errou_out  ;
    wire       pronto_out ;
    wire       timeout_out;
    wire [3:0] leds_out   ;

    wire       db_igual_out      ;
    wire [6:0] db_contagem_out   ;
    wire [6:0] db_memoria_out    ;
    wire [6:0] db_estado_out     ;
    wire [6:0] db_jogadafeita_out;
    wire [6:0] db_sequencia_out  ;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;
    reg [3:0] sequencia [0:15];
    integer i, round;      // Contadores

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    jogo_desafio_memoria dut (
      .clock          ( clock_in ),
      .reset          ( reset_in ),
      .jogar          ( jogar_in ),
      .botoes         ( botoes_in ),
      .nivel          ( nivel_in ),
      .leds           ( leds_out ),
      .pronto         ( pronto_out ),
      .ganhou         ( acertou_out ),
      .perdeu         ( errou_out ),
      .timeout        ( timeout_out ),
      .db_tem_jogada  ( db_tem_jogada_out ),
      .db_jogadafeita ( db_jogadafeita_out ),
      .db_contagem    ( db_contagem_out    ),
      .db_memoria     ( db_memoria_out     ),
      .db_estado      ( db_estado_out      ),
      .db_sequencia   ( db_sequencia_out )
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      jogar_in = 0;
      nivel_in = 1;
      botoes_in  = 4'b0000;
      #clockPeriod;

      // Inicializa sequência do jogo
      sequencia[0] = 4'b0001;  // 1ª rodada
      sequencia[1] = 4'b0010;  // 2ª rodada
      sequencia[2] = 4'b0100;  // 3ª rodada
      sequencia[3] = 4'b1000;  // 4ª rodada
      sequencia[4] = 4'b0100;  // Continua crescendo...
      sequencia[5] = 4'b0010;
      sequencia[6] = 4'b0001;
      sequencia[7] = 4'b0001;
      sequencia[8] = 4'b0010;
      sequencia[9] = 4'b0010;
      sequencia[10] = 4'b0100;
      sequencia[11] = 4'b0100;
      sequencia[12] = 4'b1000;
      sequencia[13] = 4'b1000;
      sequencia[14] = 4'b0001;
      sequencia[15] = 4'b0100;

      /*
       * Cenario de Teste - acerta todas as jogadas
       */

      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      // espera
      #(10*clockPeriod);

      for (round = 1; round <= 16; round = round + 1) begin
          $display("Rodada %d", round);

          // Mostra os leds de acordo com a rodada atual
          for (i = 0; i < round; i = i + 1) begin
              caso = (2 + i);
              #(1100*clockPeriod);
          end

          // Joga de acordo com a rodada atual
          for (i = 0; i < round; i = i + 1) begin
              caso = (2 + i);
              botoes_in = sequencia[i];
              #(10*clockPeriod);
              botoes_in = 4'b0000;
              #(10*clockPeriod);
          end

          #(10*clockPeriod);  // Tempo extra entre rodadas
      end

      #(1100*clockPeriod);

      /*
       * Cenario de Teste -  ganha fácil
       */

      caso = 1;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      nivel_in = 0;
      // espera
      #(10*clockPeriod);

      for (round = 1; round <= 8; round = round + 1) begin
          $display("Rodada %d", round);

          // Mostra os leds de acordo com a rodada atual
          for (i = 0; i < round; i = i + 1) begin
              caso = (2 + i);
              #(1100*clockPeriod);
          end

          // Joga de acordo com a rodada atual
          for (i = 0; i < round; i = i + 1) begin
              caso = (2 + i);
              botoes_in = sequencia[i];
              #(10*clockPeriod);
              botoes_in = 4'b0000;
              #(10*clockPeriod);
          end

          #(10*clockPeriod);  // Tempo extra entre rodadas
      end

      #(1100*clockPeriod);

      /*
       * Cenario de Teste - erra jogada
       */

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      // espera
      #(10*clockPeriod);


      // Teste 3
      caso = 3;
      // espera
      #(2000*clockPeriod);
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 4
      caso = 4;
      // espera
      #(4000*clockPeriod);
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      #(10*clockPeriod);
      // espera entre jogadas

      // Teste 5
      caso = 5;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 6
      caso = 6;
      // espera
      #(8000*clockPeriod);
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      caso = 7;
      @(negedge clock_in);
      botoes_in = 4'b1000;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);



      #(1100*clockPeriod);

      /*
       * Cenario de Teste - timeout
       */

      // Teste 1. iniciar=1 até timeout
      caso = 2;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      // espera
      #(500000*clockPeriod);
      #(50000*clockPeriod);
      #(50000*clockPeriod);

      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
