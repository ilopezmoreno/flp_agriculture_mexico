* Data transformation 

clear 

/*
global enoe_data "C:\Users\d57917il\Documents\1paper1\5_ENOE_databases\Bases ENOE"
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"
*/

global raw "$main_folder/data/final_datasets/raw"
global tidy "$main_folder/data/final_datasets/tidy"

cd "$raw"


/* 
Data transformation 

Agricultural machinery ratio at the national level 
Agricultural machinery ratio at the state level 

Labour demand at the national level (urban and rural)
Labour demand at the national level (only rural)
Labour demand at the state level (urban and rural)
Labour demand at the state level (only rural)

NATIONAL - Percentage of women working in agriculture as a proportion of all economically active women  
STATE - - Percentage of women working in agriculture as a proportion of all economically active women

NATIONAL - Percentage of women working in agriculture as a proportion of all people working in agriculture 
STATE - - Percentage of women working in agriculture as a proportion of all people working in agriculture

*/







/////////////////////////////////////////////////////// 
* Agricultural machinery ratio at the national level  *
///////////////////////////////////////////////////////

use national_agri_mach_ratio_2005_2019_storecollapse

gen agri_machinery = (100 * agri_mach_ratio) // Transform the estimation from decimals to percentual points.
drop agri_mach_ratio

label drop per
tostring per, generate(year_q) 
generate year = substr(year_q,2,2) // Obtain the year of the survey using the last two digits of the variable "per"
generate quarter = substr(year_q,1,1) // Obtain the quarter of the survey using the last two digits of the 
drop per year_q
destring quarter, replace
destring year, replace 
forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}
forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}	

generate entity_name=. 
replace entity_name=50
label var entity_name "National identificator"
label define entity_name 50 "National average"
label value entity_name entity_name

order year quarter entity_name agri_machinery 
sort  year quarter

////////////////////
* Data quality check
////////////////////
 
/* The dataset shows that from the 1st quarter of 2005 to the 2nd quarter of 2012, there is no information 
about operators of agricultural machinery. Therefore, I will drop everything froom 2005 to 2012 and keep only 
the data from 2013 to 2019 */ 
forvalues i=5(1)9 {
drop if year==200`i'
}
forvalues i=10(1)12 {
drop if year==20`i'
}

save "$tidy/national_agri_mach_ratio_2005_2019.dta", replace
clear




	
/////////////////////////////////////////////////// 
* Agricultural machinery ratio at the state level *
///////////////////////////////////////////////////

use state_agri_mach_ratio_2005_2019_storecollapse

gen agri_machinery = (100 * agri_mach_ratio) // Transform the estimation from decimals to percentual points.
drop agri_mach_ratio

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

* Specify labels for each state in Mexico.
label define entity_name 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" /// 
4 "Campeche" 5 "Coahuila" 6 "Colima" 7 "Chiapas" 8 "Chihuahua" 9 "Mexico City"  /// 
11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" 15 "Edo. Mex" 16 "Michoacan" /// 
17 "Morelos" 18 "Nayarit" 19 "Nuevo Leon"  21 "Puebla" 22 "Queretaro" 23 "Quintana Roo" /// 
24 "San Luis Potosi" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" /// 
29 "Tlaxcala" 31 "Yucatan" 32 "Zacatecas" /// 
10 "Durango" 20 "Oaxaca" 30 "Veracruz", replace 
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

order year quarter entity_name agri_machinery 
sort  year quarter
drop per_ent per 

////////////////////
* Data quality check
////////////////////
 
/* The dataset shows that from the 1st quarter of 2005 to the 2nd quarter of 2012, there is no information 
about operators of agricultural machinery. Therefore, I will drop everything froom 2005 to 2012 and keep only 
the data from 2013 to 2019 */ 
forvalues i=5(1)9 {
drop if year==200`i'
}
forvalues i=10(1)12 {
drop if year==20`i'
}

save "$tidy/state_agri_mach_ratio_2005_2019.dta", replace















///////////////////////////////////////////////////
* 1: LABOR DEMAND - STATE (INCLUDING RURAL & URBAN)
///////////////////////////////////////////////////

use state_labor_demand_2005_2019_storecollapse

gen pct_w_state_labor_demand = (100 * w_labor_demand) // Transform the estimation from decimals to percentual points. 
drop w_labor_demand
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

* Specify labels for each state in Mexico.
label define entity_name 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" /// 
4 "Campeche" 5 "Coahuila" 6 "Colima" 7 "Chiapas" 8 "Chihuahua" 9 "Mexico City"  /// 
11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" 15 "Edo. Mex" 16 "Michoacan" /// 
17 "Morelos" 18 "Nayarit" 19 "Nuevo Leon"  21 "Puebla" 22 "Queretaro" 23 "Quintana Roo" /// 
24 "San Luis Potosi" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" /// 
29 "Tlaxcala" 31 "Yucatan" 32 "Zacatecas" /// 
10 "Durango" 20 "Oaxaca" 30 "Veracruz", replace 
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

order entity_name year quarter pct_w_state_labor_demand 
sort entity_name year quarter

egen max = max(pct_w_state_labor_demand), by(per_ent) 
egen min = min(pct_w_state_labor_demand), by(per_ent) 
egen max_id=diff(pct_w_state_labor_demand max)
egen min_id=diff(pct_w_state_labor_demand min)
drop per per_ent

save "$tidy/state_labor_demand_2005_2019.dta", replace






/////////////////////////////////////
* 2: LABOR DEMAND - STATE, ONLY RURAL 
/////////////////////////////////////

clear 
use state_rural_labor_demand_2005_2019_storecollapse

gen pct_w_state_rural_labor_demand = (100 * rural_labor_demand) // Transform the estimation from decimals to percentual points. 
drop rural_labor_demand

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

* Specify labels for each state in Mexico.
label define entity_name 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" /// 
4 "Campeche" 5 "Coahuila" 6 "Colima" 7 "Chiapas" 8 "Chihuahua" 9 "Mexico City"  /// 
11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" 15 "Edo. Mex" 16 "Michoacan" /// 
17 "Morelos" 18 "Nayarit" 19 "Nuevo Leon"  21 "Puebla" 22 "Queretaro" 23 "Quintana Roo" /// 
24 "San Luis Potosi" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" /// 
29 "Tlaxcala" 31 "Yucatan" 32 "Zacatecas" /// 
10 "Durango" 20 "Oaxaca" 30 "Veracruz", replace 
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

order entity_name year quarter pct_w_state_rural_labor_demand 
sort entity_name year quarter

egen max = max(pct_w_state_rural_labor_demand), by(per_ent) 
egen min = min(pct_w_state_rural_labor_demand), by(per_ent) 
egen max_id=diff(pct_w_state_rural_labor_demand max)
egen min_id=diff(pct_w_state_rural_labor_demand min)
drop per per_ent

save "$tidy/state_rural_labor_demand_2005_2019.dta", replace






//////////////////////////////////////////////////////
* 3: LABOR DEMAND - NATIONAL (INCLUDING RURAL & URBAN)
//////////////////////////////////////////////////////
  
clear 
use national_labor_demand_2005_2019_storecollapse

gen country_labor_demand = (100 * w_labor_demand) // Transform the estimation from decimals to percentual points. 
drop w_labor_demand

label drop per
tostring per, generate(year_q) 
generate year = substr(year_q,2,2) // Obtain the year of the survey using the last two digits of the variable "per"
generate quarter = substr(year_q,1,1) // Obtain the quarter of the survey using the last two digits of the 
drop per year_q
destring quarter, replace
destring year, replace 
forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}
forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}	

generate entity_name=. 
replace entity_name=50
label var entity_name "National identificator"
label define entity_name 50 "National average"
label value entity_name entity_name

egen year_q = concat(year quarter), punct(.) 
order year quarter year_q entity_name country_labor_demand 
sort  year quarter

save "$tidy/national_labor_demand_2005_2019.dta", replace






////////////////////////////////////////
* 4: LABOR DEMAND - NATIONAL, ONLY RURAL 
////////////////////////////////////////

clear 
use national_rural_labor_demand_2005_2019_storecollapse

gen country_rural_labor_demand = (100 * rural_labor_demand) // Transform the estimation from decimals to percentual points. 
drop rural_labor_demand

label drop per
tostring per, generate(year_q) 
generate year = substr(year_q,2,2) // Obtain the year of the survey using the last two digits of the variable "per"
generate quarter = substr(year_q,1,1) // Obtain the quarter of the survey using the last two digits of the 
drop per year_q
destring quarter, replace
destring year, replace 
forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}
forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}	

generate entity_name=. 
replace entity_name=50
label var entity_name "National identificator"
label define entity_name 50 "National average"
label value entity_name entity_name

egen year_q = concat(year quarter), punct(.) 
order year quarter year_q entity_name country_rural_labor_demand 
sort  year quarter

save "$tidy/national_rural_labor_demand_2005_2019.dta", replace







////////////////////////////////////////////////////////////////////////////////////////////////////////
* NATIONAL - Percentage of women working in agriculture as a proportion of all economically active women
////////////////////////////////////////////////////////////////////////////////////////////////////////
  
use national_agriflp_2005_2019_storecollapse
gen agri_activewomen = (100 * agri_flp) // Transform the estimation from decimals to percentual points.
drop agri_flp

label drop per
tostring per, generate(year_q) 
generate year = substr(year_q,2,2) // Obtain the year of the survey using the last two digits of the variable "per"
generate quarter = substr(year_q,1,1) // Obtain the quarter of the survey using the last two digits of the 
drop per year_q
destring quarter, replace
destring year, replace 

forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}

forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}	

generate entity_name=. 
replace entity_name=50
label var entity_name "National identificator"
label define entity_name 50 "National average"
label value entity_name entity_name
order year quarter entity_name agri_activewomen 
sort  year quarter
save "$tidy/national_agri_activewomen_2005_2019.dta", replace
clear

/////////////////////////////////////////////////////////////////////////////////////////////////////
* STATE - Percentage of women working in agriculture as a proportion of all economically active women
/////////////////////////////////////////////////////////////////////////////////////////////////////
  
use state_agriflp_2005_2019_storecollapse
gen agri_activewomen = (100 * agri_flp) // Transform the estimation from decimals to percentual points.
drop agri_flp

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

* Specify labels for each state in Mexico.
label define entity_name 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" /// 
4 "Campeche" 5 "Coahuila" 6 "Colima" 7 "Chiapas" 8 "Chihuahua" 9 "Mexico City"  /// 
11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" 15 "Edo. Mex" 16 "Michoacan" /// 
17 "Morelos" 18 "Nayarit" 19 "Nuevo Leon"  21 "Puebla" 22 "Queretaro" 23 "Quintana Roo" /// 
24 "San Luis Potosi" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" /// 
29 "Tlaxcala" 31 "Yucatan" 32 "Zacatecas" /// 
10 "Durango" 20 "Oaxaca" 30 "Veracruz", replace 
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

order entity_name year quarter agri_activewomen 
sort entity_name year quarter

// Data quality check 
egen max = max(agri_activewomen), by(per_ent) 
egen min = min(agri_activewomen), by(per_ent) 
egen max_id=diff(agri_activewomen max)
egen min_id=diff(agri_activewomen min)
tab max_id // There is no difference between the max and min value. Therefore, data was created correctly 
tab min_id // There is no difference between the max and min value. Therefore, data was created correctly
drop max_id min_id per max min 
* drop per per_ent

save "$tidy/state_agri_activewomen_2005_2019.dta", replace
clear
	



////////////////////////////////////////////////////////////////////////////////////////////////////////////
* NATIONAL - Percentage of women working in agriculture as a proportion of all people working in agriculture
////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
use national_sexagri_2005_2019_storecollapse
gen sexagri = (100 * sex_agri) // Transform the estimation from decimals to percentual points.
drop sex_agri

label drop per
tostring per, generate(year_q) 
generate year = substr(year_q,2,2) // Obtain the year of the survey using the last two digits of the variable "per"
generate quarter = substr(year_q,1,1) // Obtain the quarter of the survey using the last two digits of the 
drop per year_q
destring quarter, replace
destring year, replace 

forvalues i=5(1)9 {
replace year=200`i' if year==`i' 		
}

forvalues i=10(1)19 {
replace year=20`i' if year==`i' 		
}	

generate entity_name=. 
replace entity_name=50
label var entity_name "National identificator"
label define entity_name 50 "National average"
label value entity_name entity_name

order year quarter entity_name sexagri 
sort  year quarter
save "$tidy/national_sex_agri_2005_2019.dta", replace
clear		



/////////////////////////////////////////////////////////////////////////////////////////////////////////
* STATE - Percentage of women working in agriculture as a proportion of all people working in agriculture 
/////////////////////////////////////////////////////////////////////////////////////////////////////////

use state_sexagri_2005_2019_storecollapse
gen sexagri = (100 * sex_agri) // Transform the estimation from decimals to percentual points.
drop sex_agri

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

* Specify labels for each state in Mexico.
label define entity_name 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" /// 
4 "Campeche" 5 "Coahuila" 6 "Colima" 7 "Chiapas" 8 "Chihuahua" 9 "Mexico City"  /// 
11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" 15 "Edo. Mex" 16 "Michoacan" /// 
17 "Morelos" 18 "Nayarit" 19 "Nuevo Leon"  21 "Puebla" 22 "Queretaro" 23 "Quintana Roo" /// 
24 "San Luis Potosi" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" /// 
29 "Tlaxcala" 31 "Yucatan" 32 "Zacatecas" /// 
10 "Durango" 20 "Oaxaca" 30 "Veracruz", replace 
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

* Data quality check 
egen max = max(sexagri), by(per_ent) 
egen min = min(sexagri), by(per_ent) 
egen max_id=diff(sexagri max)
egen min_id=diff(sexagri min)
tab max_id // There is no difference between the max and min value. Therefore, data was created correctly 
tab min_id // There is no difference between the max and min value. Therefore, data was created correctly
drop max_id min_id max min per 

order entity_name year quarter sexagri 
sort entity_name year quarter

save "$tidy/state_sex_agri_2005_2019.dta", replace
clear