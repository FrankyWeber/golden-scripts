-- Criado por Franky Weber Faust 05/05/2010
-- http://loredata.com.br
-- Filtra as sessões no Oracle
SET LINESIZE 10000
SET PAGESIZE 2000
COL username FORMAT a7
COL program FORMAT a12
COL machine FORMAT a17
COL module FORMAT a10
COL event FORMAT a10
COL osuser FORMAT a8
COL SERVICE_NAME FOR a15
COL spid FORMAT a7
COL SECONDS_IN_WAIT FORMAT 999999
COL inst_id FORMAT 99

  SELECT s.sid,
         s.serial#,
         p.spid,                                                
         /*s.inst_id,*/
         s.machine,
         s.osuser,
         s.username,
         s.program,
         s.server,
         s.SERVICE_NAME,
         w.event,
         s.SECONDS_IN_WAIT,
         TO_CHAR (s.logon_time, 'YYYY-MM-DD HH24:MI:SS'), 
         /*s.sql_hash_value,*/
         s.sql_id,
         s.status
    FROM v$session s, v$session_wait w, v$process p
   WHERE s.sid = w.sid AND p.addr = s.paddr AND s.USERNAME IS NOT NULL
--and upper(osuser) like '%VRX_FFAUST%'
--and upper(s.machine) LIKE '%ORIGINAL%'
--and s.status = 'ACTIVE'
--and w.wait_class<>'Idle'
--and upper(w.event) like '%ENQ%'
--and s.sid IN (434, 3419, 292)
--and s.serial#=xxxxx
--and p.spid=21616
--and s.program like '%???%'
--and s.sql_id='67y9b1jstzt7k'
ORDER BY TO_CHAR (s.logon_time, 'YYYY-MM-DD HH24:MI:SS') DESC;
