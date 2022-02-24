DEF TEMP-TABLE tt-turma LIKE Turma.

DEF VAR vcur_desc       LIKE CursoCurriculo.Cur_descricao.
DEF VAR vtst_desc       LIKE SitTurma.Tst_desc.
DEF VAR vsal_desc       LIKE Sala.Sal_desc.
DEF VAR vconfirma       AS LOGICAL FORMAT "Sim/Não".
    
FORM tt-turma.Tur_codigo
     WITH FRAME f-chave SIDE-LABELS THREE-D WIDTH 80.      
    
FORM tt-turma.Tur_descricao      COLON 18 LABEL "Descrição"
     tt-turma.Cur_codigo         COLON 18 LABEL "Cod. Curso"
     vcur_desc                   NO-LABEL FORMAT "x(40)"
     tt-turma.Tur_inicio         COLON 18 LABEL "Data de início"
     tt-turma.Tur_fin            COLON 54 LABEL "Data do fim"
     tt-turma.Tst_codigo         COLON 18 LABEL "Tipo de situação"
     vtst_desc                   NO-LABEL FORMAT "x(40)"
     tt-turma.Sal_codigo         COLON 18 LABEL "Nº Sala"
     vsal_desc                   NO-LABEL FORMAT "x(40)"
     WITH FRAME f-dados SIDE-LABELS THREE-D WIDTH 80.
              
        ON LEAVE OF tt-turma.Cur_codigo
             DO:
                FIND CursoCurriculo WHERE
                     CursoCurriculo.Cur_codigo = INPUT tt-turma.Cur_codigo
                     SHARE-LOCK NO-ERROR.
                     
                IF AVAIL CursoCurriculo THEN
                     DISPLAY CursoCurriculo.Cur_descricao @ vcur_desc WITH FRAME f-dados.
                ELSE
                     DISPLAY "Curso não cadastrado!" @ vcur_desc WITH FRAME f-dados.
             END.               
         
         ON LEAVE OF tt-turma.Tst_codigo
             DO:
                FIND SitTurma WHERE
                     SitTurma.Tst_codigo = INPUT tt-turma.Tst_codigo
                     SHARE-LOCK NO-ERROR.
                     
                IF AVAIL SitTurma THEN
                     DISPLAY SitTurma.Tst_desc @ vtst_desc WITH FRAME f-dados.
                ELSE
                     DISPLAY "Situação não cadastrada!" @ vtst_desc WITH FRAME f-dados.
             END.
         
         ON LEAVE OF tt-turma.Sal_codigo
             DO:
                FIND Sala WHERE
                     Sala.Sal_codigo = INPUT tt-turma.Sal_codigo
                     SHARE-LOCK NO-ERROR.
                     
                IF AVAIL Sala THEN
                     DISPLAY Sala.Sal_desc @ vsal_desc WITH FRAME f-dados.
                ELSE
                     DISPLAY "Sala não cadastrada!" @ vsal_desc WITH FRAME f-dados.
             END.
         
REPEAT:

    EMPTY TEMP-TABLE tt-turma.
    
    CREATE tt-turma.
    
    ASSIGN vconfirma = NO.
    
    DISPLAY tt-turma.Tur_codigo WITH FRAME f-chave.
    DISPLAY vtst_desc
            vsal_desc
            WITH FRAME f-dados.
            
    
    UPDATE  tt-turma.Tur_descricao
            tt-turma.Cur_codigo VALIDATE(CAN-FIND(FIRST CursoCurriculo WHERE 
                                CursoCurriculo.Cur_codigo = tt-turma.Cur_codigo),
                                "Curso não cadastrado!") 
                                
           tt-turma.Tur_inicio
           tt-turma.Tur_fin 
            
           tt-turma.Tst_codigo  VALIDATE(CAN-FIND(FIRST SitTurma WHERE
                                SitTurma.Tst_codigo = tt-turma.Tst_codigo),
                                "Situação não cadastrada!")
                                
           tt-turma.Sal_codigo  VALIDATE(CAN-FIND(FIRST Sala WHERE                    
                                Sala.Sal_codigo = tt-turma.Sal_codigo),
                                "Sala não cadastrada!")                
           WITH FRAME f-dados.      

      UPDATE vconfirma LABEL "Deseja incluir a Turma (Sim/Não)?"
        WITH FRAME f-confirma SIDE-LABELS ROW 21 NO-BOX THREE-D WIDTH 80.
        
      IF vconfirma = NO THEN
         UNDO.
            
      ASSIGN  tt-turma.Tur_codigo = NEXT-VALUE(Tur_codigo).
      DISPLAY tt-turma.Tur_codigo WITH FRAME f-chave.
      
      CREATE Turma.
      ASSIGN Turma.Tur_codigo                  = tt-turma.Tur_codigo
             Turma.Tur_descricao               = tt-turma.Tur_descricao
             Turma.Cur_codigo                  = tt-turma.Cur_codigo
             Turma.Tur_inicio                  = tt-turma.Tur_inicio
             Turma.Tur_fin                     = tt-turma.Tur_fin
             Turma.Tst_codigo                  = tt-turma.Tst_codigo
             Turma.Sal_codigo                  = tt-turma.Sal_codigo.
      MESSAGE "Turma: " tt-turma.Tur_codigo "criado com sucesso"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
