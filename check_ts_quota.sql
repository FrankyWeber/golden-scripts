-- Criado por Franky Weber Faust 25/09/2010
-- http://loredata.com.br
-- Verifica a cota dos usuários nas tablespaces
SELECT TABLESPACE_NAME,
       USERNAME,
       BYTES / 1024 / 1024 MB,
       MAX_BYTES / 1024 / 1024 MAX_MB,
       BLOCKS,
       MAX_BLOCKS,
       DROPPED
  FROM dba_ts_quotas
 WHERE username = 'USER';
