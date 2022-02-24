DEF VAR vopcao AS CHARACTER FORMAT "x(9)" EXTENT 6
INITIAL ["Inclusão","Alteração","Exclusão","Consulta","Browse","Relatório"].

FORM vopcao[1] COLON 10
     vopcao[2] COLON 34
     vopcao[3] COLON 58
     vopcao[4] COLON 10
     vopcao[5] COLON 34
     vopcao[6] COLON 58
WITH FRAME f-opcao NO-LABELS WIDTH 80 THREE-D.

REPEAT:
    MESSAGE "Escolha a opção desejada".
    DISPLAY vopcao WITH FRAME f-opcao.
    CHOOSE FIELD vopcao AUTO-RETURN WITH FRAME f-opcao.

    IF FRAME-INDEX = 1 THEN RUN C:\provaProgress\Fontes\inclusao_turma.p.
    IF FRAME-INDEX = 2 THEN RUN C:\provaProgress\Fontes\alteracao_turma.p.
    IF FRAME-INDEX = 3 THEN RUN C:\provaProgress\Fontes\delete_turma.p.
    IF FRAME-INDEX = 4 THEN RUN C:\provaProgress\Fontes\consulta_turma.p.
    IF FRAME-INDEX = 5 THEN RUN C:\provaProgress\Fontes\browse_turma.p.
    IF FRAME-INDEX = 6 THEN RUN C:\provaProgress\Fontes\chamarelatorio_turma.p.
END.
