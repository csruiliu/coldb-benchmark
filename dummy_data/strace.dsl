create(db,"db_ahjdas")
create(tbl,"tbl_jfahbsfjkhasbfkja",db_ahjdas,1)
create(col,"col1",db_ahjdas.tbl_jfahbsfjkhasbfkja)
load("/home/cs165/cs165-management-scripts/dummy_data/e3253700922c4df975671420ac1b12cb")
s1=select(db_ahjdas.tbl_jfahbsfjkhasbfkja.col1,0,100)
f1=fetch(db_ahjdas.tbl_jfahbsfjkhasbfkja.col1,s1)
print(f1)
shutdown

