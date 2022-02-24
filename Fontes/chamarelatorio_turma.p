DEF VAR vtur_ini        LIKE Turma.Tur_codigo.
DEF VAR vtur_fin        LIKE Turma.Tur_codigo.
DEF VAR vretorna AS   CHARACTER.

FORM vtur_ini COLON 20 "até ==>" vtur_fin COLON 40 NO-LABEL
     WITH FRAME f-parametros THREE-D WIDTH 80 SIDE-LABELS
                             TITLE "Parâmetros do Relatório".
                             
REPEAT:

    ASSIGN vtur_ini = 0
           vtur_fin = 99999.
           
    UPDATE vtur_ini 
           vtur_fin VALIDATE(vtur_fin >= vtur_ini,
           "Erro: Valor inicial não pode ser maior que o valor final.")
           WITH FRAME f-parametros.
           
    RUN C:\provaProgress\Fontes\relatorio_turma.p (vtur_ini,
                                                                        vtur_fin,
                                                                        OUTPUT vretorna).       
           
    IF vretorna = "NOK" THEN
            MESSAGE "Problemas na geração do relatório!" VIEW-AS ALERT-BOX ERROR.
        ELSE 
            MESSAGE "Relatório gerado com sucesso!" VIEW-AS ALERT-BOX INFORMATION.
END.
