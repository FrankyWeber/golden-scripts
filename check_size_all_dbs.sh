#!/bin/bash

#set -x

#Replace the list of DB instances below.
inst="prodcdb1 prod2cdb1 prod3cdb1"

for i in $inst
do
   echo "****************  ${i}  ********  $(date)  ****************"
   ORACLE_SID=${i};  ORAENV_ASK=NO; . /usr/local/bin/oraenv > /dev/null
   echo "
   set pages 1500 lin 250
   col name for a30
   col \"(P)DB_NAME\" for a20
   col owner for a30
   col segment_type for a20
   select c.name \"(P)DB_NAME\", owner, segment_type, round(sum(bytes/1024/1024),2) SIZE_MB from cdb_segments cs, v\$containers c where cs.con_id=c.con_id group by rollup (c.name, owner, segment_type) order by c.name;

   " | sqlplus -s / as sysdba
done
