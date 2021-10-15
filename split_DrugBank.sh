#identify the lines where every Nth drug item ends
grep -n ^"</drug>" DrugBank_full_database_v5_1_8_24_02_2021.xml | awk 'NR % 22 == 0' | sed "s/\:/ /g" | awk '{print $1}' | sed -e '1i\2' > tmp.txt1
tail -n +2 tmp.txt1 > tmp.txt2
paste tmp.txt1 tmp.txt2 | awk '(NF==2)' > tmp.txt
rm tmp.txt1 tmp.txt2

#create single xml files
N=`awk 'END{print NR}' tmp.txt`
for (( i = 1; i <= N ; ++i)); do
	echo $i;
	a=`awk '(NR=='$i'){print $1}' tmp.txt`;
	b=`awk '(NR=='$i'){print $2}' tmp.txt`;
	tag=`printf "%03d\n" $i`;
	awk -F: '(NR>'$a' && NR<='$b')' DrugBank_full_database_v5_1_8_24_02_2021.xml | sed -e '1i\<drugbank xmlns="http://www.drugbank.ca" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.drugbank.ca http://www.drugbank.ca/docs/drugbank.xsd" version="5.1" exported-on="2018-04-02">' | sed -e '1i\<?xml version="1.0" encoding="UTF-8"?>' > DrugBank_full_database_v5/$tag.xml;
done

rm tmp.txt