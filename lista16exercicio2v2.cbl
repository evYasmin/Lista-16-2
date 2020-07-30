      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "lista16exercicio2v2".
       author. "Evelyn Yasmin Pereira".
       installation. "PC".
       date-written. 23/07/2020.
       date-compiled. 23/07/2020.



      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

      *> Declaração do arquivo

           select arqEstados assign to "arqEstadosRel.txt"
           organization is relative
           access mode is dynamic
           lock mode is automatic
           relative is ws-rk-arqEstados
           file status is ws-fs-arqEstados.
      *>______________________________________________________________________________
       *>select adiona nome ao arquivo> assing vai estar assossiando o arquivo fisico.
       *> forma de como sao organizados os dados.
       *> o access vc acessa o aquivo/dados.
       *> o lock mode serve para travar o arquivo.
       *> o relative é a chave relativa para acesso randomico (acesso direto).
       *> file status é utilizado uma variavel da working-storage para retorno correto do aqruivo.
      *>_______________________________________________________________________________

       i-o-control.


      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqEstados.
       01 fd-estados.
           05 fd-estado                            pic x(25).
           05 fd-capital                           pic x(25).



      *>----Variaveis de trabalho
       working-storage section.

       77 ws-rk-arqEstados                         pic 9(02).
       77 ws-fs-arqEstados                         pic 9(02).

       01  ws-estados occurs 26.
           05 ws-estado                            pic x(25).
           05 ws-capital                           pic x(25).

       01 ws-jogadores occurs 4.
          05 ws-nome-jog                           pic x(25).
          05 ws-pontos                             pic 9(02) value zero.

       01 ws-jogadores-aux.
          05 ws-nome-jog-aux                       pic x(25).
          05 ws-pontos-aux                         pic 9(02) value zero.

       01 ws-indices.
          05 ws-ind-est                            pic 9(02).
          05 ws-ind-jog                            pic 9(01).

       01 ws-tela-menu.
          05 ws-cadastro-jogadores                 pic x(01).
          05 ws-jogar                              pic x(01).


       01 ws-tela-jogo.
          05 ws-capital-jog                        pic x(25).
          05 ws-estado-sorteado                    pic x(25).
          05 ws-pontos-jogador                     pic 9(02).


       01 ws-uso-comum.
          05 ws-sair                               pic x(01).
          05 ws-msn                                pic x(50).
          05 ws-nome-jogador                       pic x(25).
          05 ws-msn-erro.
             10 ws-msn-erro-ofsset                 pic 9(04).
             10 filler                             pic X(01) value "-".
             10 ws-msn-erro-cod                    pic 9(02).
             10 filler                             pic X(01) value space.
             10 ws-msn-erro-text                   pic X(42).

       01 sorteio.
          05  semente                              pic  9(08).
          05  num_random                           pic  9(01)V9999999.


       01 controle                                 pic x(1).
          88  trocou                               value "1".
          88  nao_trocou                           value "5".


      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.
       01  sc-tela-menu.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Tela Principal                                   ".
           05 line 03 col 01 value "      MENU                                                                       ".
           05 line 04 col 01 value "        [ ]Cadastro de Jogadores                                                 ".
           05 line 05 col 01 value "        [ ]Jogar                                                                 ".


           05 sc-sair-menu            line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-cadastro-jogadores   line 04  col 10 pic x(01)
           using ws-cadastro-jogadores foreground-color 15.

           05 sc-jogar                line 05  col 10 pic x(01)
           using ws-jogar foreground-color 15.

       01  sc-tela-cad-jogador.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Cadastro de Jogadores                            ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "      Jogador  :                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-cad-jog            line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-nome-jog-cad-jog        line 04  col 17 pic x(25)
           using ws-nome-jogador foreground-color 12.

           05 sc-msn-cad-jog             line 22  col 16 pic x(50)
           from ws-msn  foreground-color 12.

       01  sc-tela-jogar.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                           Quiz Estados Brasileiros                              ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "      Jogador  :                                   Pontos Acumulados:            ".
           05 line 06 col 01 value "      Qual e a capital do estado:                                                ".
           05 line 07 col 01 value "      Resposta :                                                                 ".


           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-jog                line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-nome-jog                line 04  col 17 pic x(25)
           from ws-nome-jogador foreground-color 12.

           05 sc-pontos-jog              line 04  col 71 pic 9(02)
           from ws-pontos-jogador foreground-color 12.

           05 sc-estado-sorteado-jog     line 06  col 34 pic x(25)
           from ws-estado-sorteado foreground-color 12.


           05 sc-resposta-jog            line 07  col 17 pic x(25)
           using ws-capital-jog  foreground-color 12.


           05 sc-msn-jog                 line 22  col 16 pic x(50)
           from ws-msn  foreground-color 12.


       01  sc-tela-relatorio.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Resultados finais                                ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "  Quarto colocado  :                                        Pontos:              ".
           05 line 05 col 01 value "  Terceiro colocado:                                        Pontos:              ".
           05 line 06 col 01 value "  Segundo colocado :                                        Pontos:              ".
           05 line 07 col 01 value "  Vencedor         :                                        Pontos:              ".
           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-rel                line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-nome-jog4-rel           line 04  col 21 pic x(25)
           from ws-nome-jog(4) foreground-color 12.

           05 sc-pontos-jog4-rel         line 04  col 68 pic 9(02)
           from ws-pontos(4) foreground-color 12.


           05 sc-nome-jog3-rel           line 05  col 21 pic x(25)
           from ws-nome-jog(3) foreground-color 12.

           05 sc-pontos-jog3-rel         line 05  col 68 pic 9(02)
           from ws-pontos(3) foreground-color 12.



           05 sc-nome-jog2-rel           line 06  col 21 pic x(25)
           from ws-nome-jog(2) foreground-color 12.

           05 sc-pontos-jog2-rel         line 06  col 68 pic 9(02)
           from ws-pontos(2) foreground-color 12.

           05 sc-nome-jog1-rel           line 07  col 21 pic x(25)
           from ws-nome-jog(1) foreground-color 12.

           05 sc-pontos-jog1-rel         line 07  col 68 pic 9(02)
           from ws-pontos(1) foreground-color 12.

           05 sc-msn-rel                 line 22  col 16 pic x(50)
           from ws-msn  foreground-color 12.





      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>________________________________________________________________________
      *>  Procedimentos de inicialização
      *>________________________________________________________________________
       inicializa section.

      *>    _______inicialização da tabela de estados_________

           open input arqEstados.
           if ws-fs-arqEstados <> 0 then
               move "1"                              to ws-msn-erro-ofsset
               move ws-fs-arqEstados                 to ws-msn-erro-cod
               move "Erro ao abrir arq. arqEstados " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           move  11             to   ws-rk-arqEstados
           start arqEstados key is = ws-rk-arqEstados

           perform varying ws-ind-est from 1 by 1 until ws-fs-arqEstados = 10
                                                     or ws-ind-est > 26

               read arqEstados into ws-estados(ws-ind-est)
               if  ws-fs-arqEstados <> 0
               and ws-fs-arqEstados <> 10 then
                   move "2"                               to ws-msn-erro-ofsset
                   move ws-fs-arqEstados                  to ws-msn-erro-cod
                   move "Erro ao ler arq. arqEstados "    to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

           end-perform

           close arqEstados.
           if ws-fs-arqEstados <> 0 then
               move "3"                               to ws-msn-erro-ofsset
               move ws-fs-arqEstados                  to ws-msn-erro-cod
               move "Erro ao fechar arq. arqEstados " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           .
       inicializa-exit.
           exit.

      *>________________________________________________________________________
      *>  Procedimentos de processamento
      *>________________________________________________________________________
       processamento section.

      *>    menu do sistema
           perform until ws-sair = "X"
                      or ws-sair = "x"

               move space  to ws-cadastro-jogadores
               move space  to ws-jogar
               move space  to ws-sair

               display sc-tela-menu
               accept sc-tela-menu

               if  ws-cadastro-jogadores  = "X"
               or  ws-cadastro-jogadores  = "x"  then
                    perform cadastrar-jogadores
               end-if

               if  ws-jogar = "X"
               or  ws-jogar = "x" then
                    perform jogar
               end-if

           end-perform
      *>  ______ chamar a section para dar a impressao de relatorio ______
           perform relatorio-final


           .
       processamento-exit.
           exit.
      *>________________________________________________________________________
      *>  Cadastro de jogadores, sao admitidos até 4 jogadores
      *>________________________________________________________________________
       cadastrar-jogadores section.

           perform until ws-sair = "V"
                      or ws-sair = "v"

               move space  to ws-nome-jogador

               display sc-tela-cad-jogador
               accept sc-tela-cad-jogador

               move space     to   ws-msn

               if ws-nome-jogador <> space then  *> Consistindo a digitação do User, nomes = spaces  são ignorados
                   perform descobrir-prox-ind-jog
                   if ws-ind-jog <= 4 then  *> Consistencia da quantidade de jogadores para evitar estouro de tabela

      *>               salvar jogador na tabela de jogadores
                       move ws-nome-jogador   to  ws-nome-jog(ws-ind-jog)
                   else
                       move "Quantidade de jogadores completa" to ws-msn
                   end-if
               end-if

           end-perform
           .
       cadastrar-jogadores-exit.
           exit.


      *>________________________________________________________________________
      *>  Motor do jogo
      *>________________________________________________________________________
       jogar section.

           perform until ws-sair = "V"
                      or ws-sair = "v"

               perform varying  ws-ind-jog  from 1 by 1 until ws-ind-jog > 4
                                                          or  ws-nome-jog(ws-ind-jog) = spaces
                                                          or  ws-sair = "V"
                                                          or  ws-sair = "v"
      *>          ________ Jogador da rodada...
                   move ws-nome-jog(ws-ind-jog)   to   ws-nome-jogador
                   move ws-pontos(ws-ind-jog)     to   ws-pontos-jogador

                   perform sorteia-estado
                   move ws-estado(ws-ind-est)     to   ws-estado-sorteado

                   move space                     to   ws-capital-jog
                   move space                     to   ws-msn

                   display sc-tela-jogar
                   accept sc-tela-jogar


      *>          __________ Testa se jogador acertou a resposta
                   if ws-capital-jog = ws-capital(ws-ind-est) then
                         add 1 to ws-pontos(ws-ind-jog)
                         move "Acertou!!!"  to ws-msn
                   else
                         move "Errou!!!"    to ws-msn
                   end-if

                   display sc-tela-jogar
                   accept sc-tela-jogar

               end-perform



           end-perform

           .
       jogar-exit.
           exit.

      *>________________________________________________________________________
      *>   Descobrir a proxima posição livre dentro da tabela de jogadores
      *>________________________________________________________________________
       descobrir-prox-ind-jog section.
           perform varying ws-ind-jog from 1 by 1 until ws-ind-jog > 4
                                                     or ws-nome-jog(ws-ind-jog) = space
               continue
           end-perform
           .
       descobrir-prox-ind-jog-exit.
           exit.

      *>________________________________________________________________________
      *>  Sorteia o estado
      *>________________________________________________________________________
       sorteia-estado section.

            move zero   to   ws-ind-est
            perform until ws-ind-est <> 0
               accept semente from time

               compute num_random = function random(semente)

               multiply num_random by 6 giving ws-ind-est
            end-perform
           .
       sorteia-estado-exit.
           exit.


      *>________________________________________________________________________
      *>  Imprime o resultado final.
      *>________________________________________________________________________
       relatorio-final section.

           perform until ws-sair = "X"
                      or ws-sair = "x"

               perform ordenar-jogadores

               move space to ws-msn
               move space to ws-sair

               display sc-tela-relatorio
               accept sc-tela-relatorio

           end-perform

           .
       relatorio-final-exit.
           exit.

      *>_______________________________________________________________________
      *>   Ordenação da tabela de jogadores
      *>_______________________________________________________________________
       ordenar-jogadores section.
           set trocou  to true

           perform until nao_trocou
               move 1           to     ws-ind-jog

               set nao_trocou   to true

               perform until ws-ind-jog = 4
                       or    ws-nome-jog(ws-ind-jog + 1) = space
      *>
                   if ws-pontos(ws-ind-jog) < ws-pontos(ws-ind-jog + 1) then  *> critério de ordenação é "pontos do jogador"
      *>                FAZ TROCA...
                       move ws-jogadores(ws-ind-jog + 1)  to  ws-jogadores-aux
                       move ws-jogadores(ws-ind-jog)      to  ws-jogadores(ws-ind-jog + 1)
                       move ws-jogadores-aux              to  ws-jogadores(ws-ind-jog)

                       set trocou         to  true

                   end-if
                   add  1   to ws-ind-jog
               end-perform
           end-perform

           .
       ordenar-jogadores-exit.
           exit.
      *>________________________________________________________________________
      *>   finalização anormal - erro
      *>________________________________________________________________________
       finaliza-anormal section.

           display erase
           display ws-msn-erro

           Stop run
           .
       finaliza-anormal-exit.
           exit.

      *>________________________________________________________________________
      *>   finalização normal
      *>________________________________________________________________________
       finaliza section.
           Stop run
           .
       finaliza-exit.
           exit.















