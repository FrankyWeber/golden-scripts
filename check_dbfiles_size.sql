-- Criado por Franky Weber Faust 15/02/2010
-- http://loredata.com.br
-- Mostra o tamanho do banco de dados somando seus arquivos.
SELECT D.INSTANCE_NAME,
       F.NAME DBNAME,
       E.HOST_NAME,
       (A.BYTES + B.BYTES + C.BYTES) / 1024 / 1024 / 1024
          AS "DATABASE SIZE (GB)"
  FROM (SELECT SUM (BYTES) AS BYTES FROM DBA_DATA_FILES) A,
       (SELECT SUM (BYTES) AS BYTES FROM DBA_TEMP_FILES) B,
       (SELECT SUM (BYTES) AS BYTES FROM V$LOG) C,
       (SELECT INSTANCE_NAME FROM V$INSTANCE) D,
       (SELECT HOST_NAME FROM V$INSTANCE) E,
       (SELECT NAME FROM V$DATABASE) F;
