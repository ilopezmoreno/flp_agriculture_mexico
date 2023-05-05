cd "$main_folder"

global store_labor_demand = "$main_folder/data/store_collapse/labor_demand"
global tempfile_labor_demand = "$main_folder/data/tempfiles/labor_demand"

local X /// 
105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 /// datasets from the 1st quarter of 2005 to 2019 
205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 /// datasets from the 2nd quarter of 2005 to 2019
305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 /// datasets from the 3rd quarter of 2005 to 2019
405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 // datasets from the 4th quarter of 2005 to 2019


foreach year_quarter of local X {
	
	* 1) Open SDEM dataset for the respective year_quarter
use "$enoe_data/enoe_`year_quarter'/SDEMT`year_quarter'.dta"

	* 2) Clean it based on INEGI criteria,
drop if eda<=11 // Drop all kids below 12 years old because they weren't interviewed in the employment survey
drop if eda==99 // INEGI also indicates that with age 99 should be dropped from the sample. 
drop if r_def!=00 // INEGI recommends to drop all the individual that didn't complete the interview. "00" in "r_def" indicates that they finished the interview
drop if c_res==2 // INEGI recommends to drop all the interviews of people who were absent during the interview, "2" in "c_res" is for definitive absentees. 
 
	* 3) Merge it with COE1 dataset for the respective year_quarter
quietly merge 1:1 cd_a ent con v_sel n_hog h_mud n_ren using "$enoe_data/enoe_`year_quarter'/COE1T`year_quarter'.dta", force
keep if _merge==3


	* 4) Keep relevant variables 
keep ///
ent /// "ent" is the ID for the 32 states of Mexico
per /// "per" identifies the year and quarter when the survey was done
fac /// This is the weight variable
sex /// Variable to identify men and women
eda /// Variable that identifies the age of the individual
ur /// Variable that identifies if the individual is living in rural or urban areas
t_loc /// Variable that identifies the number of people living in the locality where the survey was done
clase1 /// Variable to identify economically active population and non-economically active population 
p3 /// Variable to identify the occupation of the individual that was interviewed, based on SINCO classification. 
p4a /// Variable that identifies if the company where they work is dedicated to agriculture, industry or services
p2e /// Variable that asks that identify if the people that are non-economically active are: students, retired, dedicated to domestic chores, or someone with a physical or mental limitation.
p2g2 // Variable that asks the non-economically active people why they are not working apart from being students, retired, dedicated to domestic chores, etc. 
  

	* 5) Change values of states that end with 0. If you don't do this, during the creation of the variable "ent_mun", those entities that end with 0 will be confused to those that doesn't end with 0. i.e. 1&10 2&20 3&30  
replace ent=33 if ent==10 // Durango, with entity code 10, will now have the entity code 33 
replace ent=34 if ent==20 // Oaxaca, with entity code 20, will now have the entity code 34
replace ent=35 if ent==30 // Veracruz, with entity code 30, will now have the entity code 35

	* 6) Generate a unique identification variable for each mexican municipality 
egen per_ent = concat(per ent), punct(.) // unique_id for each municipality where "ent" represents entity and "mun" represents municipality. 


	* 7) Generate variable to identify working age women that are not working because there is no labor demand in their locality.   
	* Women / that are non-economically active / who reported being dedicated to domestic chores / in working ages (20-65) / and that indicated that they are not working because... 
	* 1) because the are no jobs in the locality where they live, or they are only available during certain seasons of the year.
	* 0) because any other reason 
generate w_labor_demand=. 
replace w_labor_demand=1 if sex==2 & eda>17 & eda<66 & p2e==4 & p2g2==5
replace w_labor_demand=0 if sex==2 & eda>17 & eda<66 & p2e==4 & p2g2!=5
replace w_labor_demand=. if p2g2==.
label var w_labor_demand "Woman not working due to lack of Labour Demand"
label define w_labor_demand 0 "Any other reason" 1 "Due to lack of labor demand" 
label value w_labor_demand w_labor_demand	

	* 8) Generate a variable to identify women LIVING IN RURAL areas that are not working because there is a lack of labor demand in their locality. 
generate ur_labor_demand=. 
replace ur_labor_demand=1 if sex==2 & eda>17 & eda<66 & p2e==4 & p2g2==5 & ur==2 // ur==2 is rural
replace ur_labor_demand=0 if sex==2 & eda>17 & eda<66 & p2e==4 & p2g2!=5 & ur==2 // ur==2 is rural
replace ur_labor_demand=. if p2g2==.
label var ur_labor_demand "Woman in rural areas not working due to lack of Labour Demand"
label define ur_labor_demand 0 "Any other reason" 1 "Due to lack of labor demand" 
label value ur_labor_demand ur_labor_demand
	
	* 9) Variable to answer the following question: 
	* Of the women who do not work due to lack of labor demand, what percentage lives in rural areas?
preserve
collapse (mean) ur_labor_demand [fweight=fac], by(per)
save "$store_labor_demand\national_rur_labor_demand_`year_quarter'.dta", replace
restore 	
	
	* 10) Estimate the percentage of women in each state that are not workin due to lack of labour demand. 
preserve
collapse (mean) w_labor_demand [fweight=fac], by(per_ent)
save "$store_labor_demand\state_rur_labor_demand_`year_quarter'.dta", replace
tempfile state_rur_labor_demand_`year_quarter'
save "`state_rur_labor_demand_`year_quarter''"
restore

	* 11) Estimate the percentage of women LIVING IN RURAL AREAS that are not working due to lack of labour demand. (Differentiating by states)
collapse (mean) ur_labor_demand [fweight=fac], by(per_ent)
save "$store_labor_demand\state_rur_labor_demand_`year_quarter'.dta", replace
tempfile state_rur_labor_demand_`year_quarter'
save "`state_rur_labor_demand_`year_quarter''"

}





**********************************
* Append datasets to identify the percentage of working age women that are not working because there is no labor demand in their locality.
*********************************

* First option: Append using tempfiles 
* NOTE TO MYSELF: 
* Para que puedes hacer hacer o merge usando documentos temporales (tempfiles) es importante recordar 
* que solamente se puede usar los tempfiles antes de que Stata indique "End of Do file" 
* Por lo tanto, solo se puede hacer uso de tempfiles si se corre todo el codigo a la vez. 
* Es decir, si corres el bucle (loop) de arriba sin correr al mismo tiempo el append que se incluye a continuacion, el codigo no funcionara. 
* Para que el codigo funcione, debe correrse el bucle de arriba y el append de abajo de forma simultanea. De lo contrario marcara error.
* Esto debido a que si corres unicamente el loop, cuando termine de correrse Stata mostrara "fin del do-file" y debido a eso se borraran los archivos temporales.

use "`state_rur_labor_demand_105'", clear	

forvalues i=106(1)119 {
append using "`state_rur_labor_demand_`i''"	
}

forvalues i=205(1)219 {
append using "`state_rur_labor_demand_`i''"	
}

forvalues i=305(1)319 {
append using "`state_rur_labor_demand_`i''"
}

forvalues i=405(1)419 {
append using "`state_rur_labor_demand_`i''"	
}	

save "$main_folder/data/final_datasets/labor_demand_2005_2019_tempfiles.dta", replace




* Second option
* Append the datasets using the store_collapse data saved in the computer


/*

clear 
use "$store_collapse\state_rur_labor_demand_105.dta"

forvalues i=106(1)119 {
append using "$store_collapse\state_rur_labor_demand_`i'.dta"	
}

forvalues i=205(1)219 {
append using "$store_collapse\state_rur_labor_demand_`i'.dta"	
}

forvalues i=305(1)319 {
append using "$store_collapse\state_rur_labor_demand_`i'.dta"	
}

forvalues i=405(1)419 {
append using "$store_collapse\state_rur_labor_demand_`i'.dta"	
}

save "$main_folder/data/final_datasets/labor_demand_2005_2019_storecollapse.dta", replace


*/