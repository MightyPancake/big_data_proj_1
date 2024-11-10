# wget http://www.cs.put.poznan.pl/kjankiewicz/bigdata/projekty/zestaw3.zip
# unzip zestaw3
# rm zestaw3.zip
# hadoop fs -mkdir -p input
# hadoop fs -put ./input/* input

# Init airflow
export AIRFLOW_HOME=~/airflow
pip install apache-airflow
export PATH=$PATH:~/.local/bin
airflow db migrate

mkdir -p ~/airflow/dags/project_files
mv projekt1.py ~/airflow/dags/
mv *.* ~/airflow/dags/project_files

airflow standalone