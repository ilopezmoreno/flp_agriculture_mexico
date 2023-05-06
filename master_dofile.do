* Define the main working directory 
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"

* Define data location (The data location is outside of the main folder)
global enoe_data "C:\Users\d57917il\Documents\1paper1\5_ENOE_databases\Bases ENOE"



* Run do files 

clear

cd "$main_folder/dofiles"
do "folder_creation.do" // To create all the folders 

cd "$main_folder/dofiles"
do "data-estimation_labor-demand.do"
	
cd "$main_folder/dofiles"
do "data-transformation_labor-demand.do"

do "data-estimation_agri-machinery.do"
do "data-transformation_agri-machinery.do"














