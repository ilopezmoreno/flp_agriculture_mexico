* Define the main working directory 
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"
 
* Create folders 
cd "$main_folder"
capture mkdir documentation 
capture mkdir data 
capture mkdir dofiles 
capture mkdir outputs

cd "$main_folder/documentation"
capture mkdir codebooks
capture mkdir dictionaries

cd "$main_folder/data"
capture mkdir store_collapse 
capture mkdir tempfiles 

cd "$main_folder/data/store_collapse"
capture mkdir agri_machinery 
capture mkdir labor_demand 
capture mkdir count_flp_agri
capture mkdir pct_flp_agri
capture mkdir final_datasets

cd "$main_folder/outputs"
capture mkdir graphs
capture mkdir tables 
capture mkdir tabulations  
capture mkdir regressions 
  
cd "$main_folder/outputs/graphs"
capture mkdir gph
capture mkdir jpg 


* Run do files 














