all:
	./prepare_data.sh
	./make_sql_queries.sh
	./run_sql_queries.sh

tiny:
	
	./prepare_tiny_data.sh
	./make_sql_queries.sh
	./run_sql_queries_tiny.sh

clean:
	
	rm -rf test*.sql
	rm -rf test*.exp
	rm -rf bench*.sql
	rm -rf bench*.exp
	rm -rf data*.csv
