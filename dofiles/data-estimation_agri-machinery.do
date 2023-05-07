cd "$main_folder"

global store_machinery = "$main_folder\data\store_collapse\agri_machinery"
global state "$store_machinery\state"
global national "$store_machinery\national"

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
drop if eda==99 // INEGI also indicates that with age 99 should be dropped from the sample. 
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


* ////////////////////////////////////////////////////////////////////////////////////////////////////// * 
* Identify Agricultural Machinery Operators and estimate agricultural machinery ratio at the state level * 
* ////////////////////////////////////////////////////////////////////////////////////////////////////// *  

* Generate dummy variable to identify people working in agriculture and people working as operators of agricultural machinery
generate agri_mach_ratio=.
replace agri_mach_ratio=0 if P4A_Sector==1 & p3!=6311 // This command identifies all the people working in agriculture, but not as agricultural machinery operators. 
replace agri_mach_ratio=1 if P4A_Sector==1 & p3==6311 
label define agri_mach_ratio 0 "Agricultural Workers" 1 "Operators of agricultural machinery"
label value agri_mach_ratio agri_mach_ratio	

* Estimate the agricultural machinery ratio at the STATE level. 
preserve
collapse (mean) agri_mach_ratio [fweight=fac], by(per_ent)
save "$state/state_agri_mach_ratio_`year_quarter'.dta", replace
restore

* Estimate the agricultural machinery ratio at the NATIONAL level. 
preserve
collapse (mean) agri_mach_ratio [fweight=fac], by(per)
save "$national/national_agri_mach_ratio_`year_quarter'.dta", replace
restore 

clear
}


*******************
* Append datasets *
*******************

* State level 

clear
use "$state\state_agri_mach_ratio_105.dta"
forvalues i=106(1)119 {
append using "$state\state_agri_mach_ratio_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$state\state_agri_mach_ratio_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$state\state_agri_mach_ratio_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$state\state_agri_mach_ratio_`i'.dta"	
}
save "$main_folder/data/final_datasets/raw/state_agri_mach_ratio_2005_2019_storecollapse.dta", replace



* National level 

clear
use "$national\national_agri_mach_ratio_105.dta"
forvalues i=106(1)119 {
append using "$state\national_agri_mach_ratio_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$state\national_agri_mach_ratio_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$state\national_agri_mach_ratio_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$state\national_agri_mach_ratio_`i'.dta"	
}
save "$main_folder/data/final_datasets/raw/national_agri_mach_ratio_2005_2019_storecollapse.dta", replace

