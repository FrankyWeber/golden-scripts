-- Criado por Franky Weber Faust 19/04/2011
-- http://loredata.com.br
-- Apresenta o uso de PGA por sessao no Oracle
SET LINESIZE 300;
SET PAGESIZE 30000;
SET LONG 999999;
COLUMN username FORMAT A18;
COLUMN machine FORMAT A18;
COLUMN sid FORMAT 99999;
COLUMN serial# FORMAT 999999;
COLUMN sql_id FORMAT a15;
COLUMN event FORMAT a33;
COLUMN status FORMAT a13;
COLUMN "%Complete" FORMAT a10;
COLUMN "TempUsedSpaceInMB" FORMAT a20;
ALTER SESSION SET nls_date_format = 'dd-mm-yy hh24:mi:ss';

  SELECT DISTINCT
         s.sid,
         s.serial#,
         s.username,
         REGEXP_SUBSTR (s.machine,
                        '[^.]+',
                        1,
                        1)
            AS machine,
         s.status,
         s.event,
         s.sql_id,
         ROUND (p.pga_used_mem / (1024 * 1024), 2) PGA_MB_USED,
         ROUND (p.pga_alloc_mem / (1024 * 1024), 2) PGA_MB_ALLOC,
         u.tablespace || ' - ' || ROUND (u.blocks * 8 / 1024)
            AS "TempUsedSpaceInMB",
         ROUND (sl.sofar / sl.totalwork * 100, 0) || '%' AS "%Complete"
    FROM v$session s
         INNER JOIN v$sql q ON s.sql_id = q.sql_id
         LEFT JOIN v$session_longops sl
            ON s.sid = sl.sid AND s.serial# = sl.serial#
         INNER JOIN v$process p ON s.PADDR = p.ADDR
         LEFT JOIN v$sort_usage u ON s.saddr = u.session_addr
   WHERE     s.sid <> SYS_CONTEXT ('userenv', 'sid')
         AND s.username NOT IN ('SYS', 'SYSTEM')
ORDER BY PGA_MB_ALLOC DESC, PGA_MB_USED DESC;
