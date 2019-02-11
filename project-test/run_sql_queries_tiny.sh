#! /bin/bash

./make_sql_queries.sh

#files=`find . -name "test*sql"`
files=`ls -l test*sql | awk '{print $NF}'`


sudo -u postgres psql cs165 -f load-data-tiny.sql

files=`ls -l test*sql | awk '{print $NF}'`
for f in $files
do
	new_f=`basename -s .sql $f`.exp
	echo $f to  $new_f

        sudo -u postgres psql cs165 -f $f | grep -v -E "DELETE|INSERT|UPDATE|sum|min|max|avg|row|col|--|^$" | awk -F "|" '{for (i=1;i<=NF;i++){printf("%s ",$i);}printf("\n");}' | awk '{printf("%s",$1);for (i=2;i<=NF;i++){printf(",%s",$i);}printf("\n");}' | awk -F, '{  if ($1 ~ /\./) { printf("%0.2f",$1); } else { printf("%s",$1); } for(i=2;i<=NF;i++){ if ($i ~ /\./) { printf(",%0.2f",$i) } else { printf(",%s",$i); } } printf("\n"); }' > $new_f


done




