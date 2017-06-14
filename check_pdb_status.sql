-- Criado por Franky Weber Faust 13/08/2015
-- http://loredata.com.br
-- Verifica nome, status e tamanho dos PDBs.
SELECT
    p.name,
    p.open_mode,
    d.status,
    TO_CHAR(
        p.open_time,
        'DD/MM/YYYY HH24:MI:SS'
    ) open_time,
    p.total_size / 1024 / 1024 total_mb,
    p.max_size / 1024 / 1024 max_mb,
    p.local_undo,
    d.refresh_mode
FROM
    v$pdbs p,
    dba_pdbs d
WHERE
    p.name = d.pdb_name
ORDER BY 1;
