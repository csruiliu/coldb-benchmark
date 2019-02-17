#! /bin/bash

files=`find . -name "*dsl"`

for f in $files
do
	new_f=`basename -s .dsl $f`.sql
	echo $f to  $new_f

	cat $f | grep -E "SELECT|INSERT|DELETE|UPDATE" | sed 's/--//g' > $new_f
done


