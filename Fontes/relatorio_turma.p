DEF INPUT  PARAM vtur_ini        LIKE Turma.Tur_codigo.
DEF INPUT  PARAM vtur_fin        LIKE Turma.Tur_codigo.
DEF OUTPUT PARAM vretorna AS   CHARACTER.

DEF TEMP-TABLE tt-turma LIKE Turma

    FIELD     tt-turcod     LIKE Turma.Tur_codigo                                               FORMAT "zz9"
    FIELD     tt-turdesc    LIKE Turma.Tur_descricao                                            FORMAT "x(30)"
    FIELD     tt-curcod     LIKE Turma.Cur_codigo               COLUMN-LABEL "Cód"              FORMAT "zz9"
    FIELD     tt-curdesc    LIKE CursoCurriculo.Cur_descricao   COLUMN-LABEL "Curso"            FORMAT "x(30)"
    FIELD     tt-turini     LIKE Turma.Tur_inicio               COLUMN-LABEL "Data Início"      FORMAT "99/99/9999"
    FIELD     tt-turfin     LIKE Turma.Tur_fin                  COLUMN-LABEL "Data Fim"         FORMAT "99/99/9999"
    FIELD     tt-salacod    LIKE Turma.Sal_codigo               COLUMN-LABEL "Cód Sala"         FORMAT "zz9"
    FIELD     tt-saladesc   LIKE Sala.Sal_desc                  COLUMN-LABEL "Sala"             FORMAT "x(10)"
    FIELD     tt-sitcod     LIKE Turma.Tst_codigo               COLUMN-LABEL "Cód Situação"     FORMAT "zz9"
    FIELD     tt-sitdesc    LIKE SitTurma.Tst_descricao         COLUMN-LABEL "Sit Turma"        FORMAT "x(20)"
    INDEX primario AS PRIMARY tt-turcod.
    
    
FORM tt-curcod     
     tt-curdesc
     tt-turini    
     tt-turfin    
     tt-saladesc
     tt-sitdesc
     WITH FRAME f-relatorio WIDTH 150 STREAM-IO DOWN.
     
ASSIGN vretorna = "NOK".

EMPTY TEMP-TABLE tt-turma.

FOR EACH Turma                   WHERE
         Turma.Tur_codigo   >= vtur_ini AND
         Turma.Tur_codigo   <= vtur_fin
         NO-LOCK,
    EACH CursoCurriculo OF Turma WHERE
         CursoCurriculo.Cur_codigo = Turma.Cur_Codigo
         NO-LOCK,
    EACH SitTurma OF Turma WHERE
                 SitTurma.Tst_codigo = Turma.Tst_Codigo
                 NO-LOCK,
    EACH Sala OF Turma WHERE
         Sala.Sal_codigo = Turma.Sal_Codigo
         NO-LOCK
    BREAK BY Turma.Tur_codigo:     
     
    CREATE tt-turma.
    ASSIGN tt-turcod    = Turma.Tur_codigo            
           tt-turdesc   = Turma.Tur_descricao         
           tt-curcod    = Turma.Cur_codigo            
           tt-curdesc   = CursoCurriculo.Cur_descricao
           tt-turini    = Turma.Tur_inicio            
           tt-turfin    = Turma.Tur_fin               
           tt-salacod   = Turma.Sal_codigo            
           tt-saladesc  = Sala.Sal_desc               
           tt-sitcod    = Turma.Tst_codigo                           
           tt-sitdesc   = SitTurma.Tst_descricao.  

END.
    
OUTPUT TO C:\provaProgress\Relatorio\relatorio.lst.
    
FOR EACH tt-turma
    BREAK BY tt-turcod:
          
    IF FIRST-OF (tt-turcod) THEN
        PUT SKIP (1)
        "Turma: "
        tt-turcod
        " - "
        tt-turdesc
        SKIP.
        
    DISPLAY tt-curcod  
            tt-curdesc 
            tt-turini  
            tt-turfin  
            tt-salacod 
            tt-saladesc
            tt-sitcod  
            tt-sitdesc 
            WITH FRAME f-relatorio.
    
    DOWN WITH FRAME f-relatorio.
     
END.  

OUTPUT CLOSE.

ASSIGN vretorna = "OK".
