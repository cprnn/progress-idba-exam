DEF VAR vtur_ini LIKE Turma.Tur_codigo.
DEF VAR vtur_fin LIKE Turma.Tur_codigo.

DEF QUERY q-browse FOR Turma, CursoCurriculo, SitTurma, Sala.

DEF BROWSE b-browse QUERY q-browse
    DISPLAY Turma.Tur_codigo                COLUMN-LABEL "Cód Turma"
            Turma.Tur_descricao             COLUMN-LABEL "Desc Turma"
            Turma.Cur_codigo                COLUMN-LABEL "Cód Curso"
            CursoCurriculo.Cur_descricao    COLUMN-LABEL "Desc Curso"
            Turma.Tur_inicio                COLUMN-LABEL "Data início"
            Turma.Tur_fin                   COLUMN-LABEL "Data final"
            Turma.Tst_codigo                COLUMN-LABEL "Cód Sit Turma"
            SitTurma.Tst_descricao          COLUMN-LABEL "Dsc Sit Turma"
            Turma.Sal_codigo                COLUMN-LABEL "Cód Sala"
            Sala.Sal_desc                   COLUMN-LABEL "Desc Sala"
            WITH SEPARATORS TITLE " Cadastro de Turma " WIDTH 80 18 DOWN THREE-D.

FORM vtur_ini
     vtur_fin
     WITH FRAME f-parametros WIDTH 80 SIDE-LABELS TITLE " Parâmetros da Turma " THREE-D.
     
FORM b-browse  
     WITH FRAME f-browse WIDTH 80 NO-BOX OVERLAY ROW 4.
     
REPEAT:
    ASSIGN vtur_ini = 0
           vtur_fin = 99999.
           
    UPDATE vtur_ini
           vtur_fin
           WITH FRAME f-parametros. 
    
    RUN pro-open-query.
    
END.

PROCEDURE pro-open-query:

    OPEN QUERY q-browse
        FOR EACH Turma WHERE
                 Turma.Tur_codigo >= vtur_ini AND
                 Turma.Tur_codigo <= vtur_fin
                 NO-LOCK,
            EACH CursoCurriculo OF Turma WHERE
                 CursoCurriculo.Cur_codigo = Turma.Cur_Codigo
                 NO-LOCK,
            EACH SitTurma OF Turma WHERE
                 SitTurma.Tst_codigo = Turma.Tst_Codigo
                 NO-LOCK,
            EACH Sala OF Turma WHERE
                 Sala.Sal_codigo = Turma.Sal_Codigo
                 NO-LOCK.
        ENABLE b-browse WITH FRAME f-browse.
        WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
END.
