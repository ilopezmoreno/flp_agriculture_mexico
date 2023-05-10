clear
* Define the main working directory 
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"
* Define data location (The data location is outside of the main folder)
global enoe_data "C:\Users\d57917il\Documents\1paper1\5_ENOE_databases\Bases ENOE"



* Run do files 
cd "$main_folder/dofiles"
do "folder_creation.do" // To create all the folders 

//////////////// LABOR DEMAND ////////////////
cd "$main_folder/dofiles"
do "data-estimation_labor-demand.do"
cd "$main_folder/dofiles"
do "data-transformation_labor-demand.do"

////////////////// AGRI MACHINERY //////////////////
cd "$main_folder/dofiles"
do "data-estimation_agri-machinery.do"
cd "$main_folder/dofiles"
do "data-transformation_agri-machinery.do"

////////////// FEMALE LABOUR PARTICIPATION //////////////
cd "$main_folder/dofiles"
do "data-estimation_flp.do"

////////// GRAPHS //////////
* STATE RURAL LABOR DEMAND 
cd "$main_folder/dofiles"
do "graph-state_rural_labor_demand.do"
* STATE AGRICULTURAL MACHINERY 
cd "$main_folder/dofiles"
do "graph-state_agri_machinery.do"


* NATIONAL AVERAGE OF AGRICULTURAL MACHINERY OPERATORS
* This do file includes: 
* 1) Agricultural Machinery ratio at the National level (2013-2019)
* 2) Percentage of women at the national level that indicating that they are not working due to lack of labor demand (both urban+rural, and only rural)
cd "$main_folder/dofiles"
do "graph-national"




