clear
global enoe_data "C:\Users\d57917il\Documents\1paper1\5_ENOE_databases\Bases ENOE"
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"


global store_collapse "$main_folder\data\store_collapse\pct_flp_agri"


local X /// 
105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 /// datasets from the 1st quarter of 2005 to 2019 
205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 /// datasets from the 2nd quarter of 2005 to 2019
305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 /// datasets from the 3rd quarter of 2005 to 2019
405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 // datasets from the 4th quarter of 2005 to 2019 

foreach year_quarter of local X {

* Open SDEM dataset for the respective year_quarter
use "$enoe_data/enoe_`year_quarter'/SDEMT`year_quarter'.dta"

* Clean it based on INEGI criteria,
drop if eda<=11 // Drop all kids below 12 years old because they weren't interviewed in the employment survey
drop if eda==99 // INEGI indicates that with age 99 should be dropped from the sample. 
drop if r_def!=00 // INEGI recommends to drop all the individual that didn't complete the interview. "00" in "r_def" indicates that they finished the interview
drop if c_res==2 // INEGI recommends to drop all the interviews of people who were absent during the interview, "2" in "c_res" is for definitive absentees. 
 
* Merge it with COE1 dataset for the respective year_quarter
quietly merge 1:1 cd_a ent con v_sel n_hog h_mud n_ren using "$enoe_data/enoe_`year_quarter'/COE1T`year_quarter'.dta", force
keep if _merge==3

* Keep relevant variables 
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
p2g2 /// Variable that asks the non-economically active people why they are not working apart from being students, retired, dedicated to domestic chores, etc. 
p3 // Variable to identify specific occupations or jobs from the interviewed individuals.   

* Change values of states that end with 0. If you don't do this, during the creation of the variable "ent_mun", those entities that end with 0 will be confused to those that doesn't end with 0. i.e. 1&10 2&20 3&30  
replace ent=33 if ent==10 // Durango, with entity code 10, will now have the entity code 33 
replace ent=34 if ent==20 // Oaxaca, with entity code 20, will now have the entity code 34
replace ent=35 if ent==30 // Veracruz, with entity code 30, will now have the entity code 35

* Generate a unique identification variable for each mexican municipality 
egen per_ent = concat(per ent), punct(.) // unique_id for each municipality where "ent" represents entity and "mun" represents municipality. 

* Generate a categorical variable to identify if the person works in the primary, secondary or terciary sector. 
generate P4A_Sector=.
rename p4a P4A 
replace P4A_Sector=1 if P4A>=1100 & P4A<=1199 // If values in P4A are between 1100 & 1199 classify as PRIMARY SECTOR
replace P4A_Sector=2 if P4A>=2100 & P4A<=3399 // If values in P4A are between 2100 & 2399 classify as SECONDARY SECTOR
replace P4A_Sector=3 if P4A>=4300 & P4A<=9399 // If values in P4A are between 4300 & 9399 classify as TERCIARY SECTOR
replace P4A_Sector=4 if P4A>=9700 & P4A<=9999 // *If values in P4A are between 9700 & 9999 classify as UNSPECIFIED ACTIVITIES
label var P4A_Sector "Economic Sector Categories"
label define P4A_Sector 1 "Primary Sector" 2 "Secondary Sector" 3 "Terciary Sector" 4 "Unspecified Sector"
label value P4A_Sector P4A_Sector
tab P4A_Sector // Data quality check. Result: 0 missing values

* Generate dummy variables to identify those woman that are working in the agricultural sector  
generate agri_sector=.
replace agri_sector=1 if P4A>=1100 & P4A<=1199 & sex==2 // If values in P4A are between 1100 & 1199 classify as PRIMARY SECTOR
replace agri_sector=0 if P4A>=2100 & P4A<=9999 & sex==2 // If values in P4A are between 9700 & 9999 do not classify as PRIMARY SECTOR


* Estimate the percentage of women working in agriculture as a share of all economically active women. NATIONAL LEVEL
preserve
collapse (mean) agri_sector [fweight=fac], by (per)
rename agri_sector agri_flp
save "$store_collapse\national\national_agriflp_`year_quarter'.dta", replace
restore	

* Estimate the percentage of women working in agriculture as a share of all economically active women. STATE LEVEL
preserve
collapse (mean) agri_sector [fweight=fac], by (per_ent)
rename agri_sector agri_flp
save "$store_collapse\state\state_agriflp_`year_quarter'.dta", replace
restore

clear		
}



* Append the NATIONAL datasets to create one dataset per year_quarter

clear 
use "$store_collapse\national\national_agriflp_105.dta"

forvalues i=106(1)119 {
append using "$store_collapse\national\national_agriflp_`i'.dta"	
}

forvalues i=205(1)219 {
append using "$store_collapse\national\national_agriflp_`i'.dta"	
}

forvalues i=305(1)319 {
append using "$store_collapse\national\national_agriflp_`i'.dta"	
}

forvalues i=405(1)419 {
append using "$store_collapse\national\national_agriflp_`i'.dta"	
}

save "$main_folder/data/final_datasets/raw/national_agriflp_2005_2019.dta", replace


* Append the STATE datasets to create one dataset per year_quarter

clear 
use "$store_collapse\state\state_agriflp_105.dta"

forvalues i=106(1)119 {
append using "$store_collapse\state\state_agriflp_`i'.dta"	
}

forvalues i=205(1)219 {
append using "$store_collapse\state\state_agriflp_`i'.dta"	
}

forvalues i=305(1)319 {
append using "$store_collapse\state\state_agriflp_`i'.dta"	
}

forvalues i=405(1)419 {
append using "$store_collapse\state\state_agriflp_`i'.dta"	
}


save "$main_folder/data/final_datasets/raw/state_agriflp_2005_2019.dta", replace



/*

* Transform the estimation from decimals to percentual points. 

gen agri_flp = (100 * women_agri_sector)
drop women_agri_sector

* 	13) Data transformation 
tostring per, generate(year_q) 
drop per
generate year = substr(year_q,2,2) // Obtain the year of the survey by using the last two digits of the variable "per"
generate quarter = substr(year_q,1,1) // Obtain the quarter of the survey by using the last two digits of the 
drop year_q

destring quarter, replace
destring year, replace
forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}
forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}

sort year quarter

generate entity_name=33
label define entity_name 33 "National"
label value entity_name entity_name
tab entity_name
order year quarter entity_name agri_flp

save "$store_collapse\w_agri_2005_2019.dta", replace


































/*


* 	12)  Data Transformation 

gen agri_flp = (100 * women_agri_sector) // Transform the estimation from decimals to percentual points.
drop women_agri_sector // Drop unnecessary variables 
split per_ent, parse(.) // Split variable pet_ent_mun into three variables 
rename per_ent1 per // First split variable refers to year_quarter
rename per_ent2 entity_name // Second split variable referes to federal entity, also known as State
generate year = substr(per,2,2) // Obtain the year of the survey using the last two digits of the variable "per"
generate quarter = substr(per,1,1) // Obtain the quarter of the survey using the last two digits of the 

destring entity_name, replace
* Return entity codes to their original values. 
replace entity_name=10 if entity_name==33 // Durango, with entity code 10, will now have the entity code 33 
replace entity_name=20 if entity_name==34 // Oaxaca, with entity code 20, will now have the entity code 34
replace entity_name=30 if entity_name==35 // Veracruz, with entity code 30, will now have the entity code 35
label value entity_name entity_name
tab entity_name

* Transform quarters and years 
destring quarter, replace
destring year, replace 
forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}
forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}

drop per per_ent
order year quarter entity_name agri_flp 

save "$store_collapse/w_state_agri_2005_2019.dta", replace



append using "$store_collapse\w_agri_2005_2019.dta"	




* Specify labels for each state in Mexico.
label define entity_name 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" /// 
4 "Campeche" 5 "Coahuila" 6 "Colima" 7 "Chiapas" 8 "Chihuahua" 9 "Mexico City"  /// 
11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" 15 "Edo. Mex" 16 "Michoacan" /// 
17 "Morelos" 18 "Nayarit" 19 "Nuevo Leon"  21 "Puebla" 22 "Queretaro" 23 "Quintana Roo" /// 
24 "San Luis Potosi" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" /// 
29 "Tlaxcala" 31 "Yucatan" 32 "Zacatecas" /// 
10 "Durango" 20 "Oaxaca" 30 "Veracruz" 33 "National", replace 
label value entity_name entity_name
tab entity_name


sort year quarter entity_name



egen state_year = concat(entity_name year), punct(.) 
egen max = max(agri_flp), by(state_year) 
egen min = min(agri_flp), by(state_year) 
egen max_id=diff(agri_flp max)
egen min_id=diff(agri_flp min)
drop max min 

save "$store_collapse/final_agri_flp_2005_2019.dta", replace






bysort state_year: egen min=min(agri_flp)
bysort state_year: egen max=max(agri_flp)

bysort state_year: egen min_id= agri_flp == min
bysort state_year: egen max=max(agri_flp)
