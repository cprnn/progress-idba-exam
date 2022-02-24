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
   
REPEAT:

    ASSIGN vconfirma = NO.

    EMPTY TEMP-TABLE tt-turma.
    
    CREATE tt-turma.
    
    UPDATE tt-turma.Tur_codigo WITH FRAME f-chave.
        
    FIND Turma WHERE
         Turma.Tur_codigo = tt-turma.Tur_codigo
         EXCLUSIVE-LOCK NO-ERROR.
         
    IF NOT AVAIL Turma THEN
        DO:
            MESSAGE "Turma não cadastrada!" VIEW-AS ALERT-BOX INFORMATION.
            UNDO.
        END.
    
     ASSIGN tt-turma.Tur_codigo      =   Turma.Tur_codigo
            tt-turma.Tur_descricao   =   Turma.Tur_descricao         
            tt-turma.Cur_codigo      =   Turma.Cur_codigo            
            tt-turma.Tur_inicio      =   Turma.Tur_inicio            
            tt-turma.Tur_fin         =   Turma.Tur_fin               
            tt-turma.Tst_codigo      =   Turma.Tst_codigo            
            tt-turma.Sal_codigo      =   Turma.Sal_codigo.            
           
    DISPLAY tt-turma.Cur_codigo
            tt-turma.Tur_descricao
            tt-turma.Tur_inicio
            tt-turma.Tur_fin 
            tt-turma.Tst_codigo
            tt-turma.Sal_codigo
            WITH FRAME f-dados.  
          
    FIND CursoCurriculo WHERE
         CursoCurriculo.Cur_codigo = tt-turma.Cur_codigo
         NO-LOCK NO-ERROR.
                     
      IF NOT AVAIL CursoCurriculo THEN
            DO:
                MESSAGE "Curso não cadastrado!" VIEW-AS ALERT-BOX ERROR.
                UNDO.
            END.
            
    DISPLAY CursoCurriculo.Cur_descricao @ vcur_desc WITH FRAME f-dados.
           

    FIND SitTurma WHERE
         SitTurma.Tst_codigo = tt-turma.Tst_codigo
         NO-LOCK NO-ERROR.
         
        IF NOT AVAIL SitTurma THEN
             DO:
                MESSAGE "Situação não cadastrada!" VIEW-AS ALERT-BOX ERROR.
                UNDO.
             END.
             
    DISPLAY SitTurma.Tst_descricao @ vtst_desc WITH FRAME f-dados.
                
                
    FIND Sala WHERE
             Sala.Sal_codigo = tt-turma.Sal_codigo
             NO-LOCK NO-ERROR.
             
        IF NOT AVAIL Sala THEN
             DO:
                MESSAGE "Sala não cadastrada!" VIEW-AS ALERT-BOX ERROR.
                UNDO.
             END.
             
    DISPLAY Sala.Sal_desc @ vsal_desc WITH FRAME f-dados.   

     PAUSE.
END.
