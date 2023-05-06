* Data transformation 

cd "$main_folder/data/final_datasets"
use labor_demand_2005_2019_storecollapse

gen pct_labor_demand = (100 * w_labor_demand) // Transform the estimation from decimals to percentual points. 
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

order entity_name year quarter pct_labor_demand 
sort entity_name year quarter
save "$store_collapse/labor_demand_2005_2019.dta", replace













egen max = max(pct_labor_demand), by(per_ent) 
egen min = min(pct_labor_demand), by(per_ent) 
egen max_id=diff(pct_labor_demand max)
egen min_id=diff(pct_labor_demand min)

drop per per_ent












**********************************
/* Append the datasets that identify the percentage of women living in rural areas that 
are not working because there is a lack of labour demand. */
*********************************

clear 
use "$store_collapse\national_ur_labor_demand_105.dta"

forvalues i=106(1)119 {
append using "$store_collapse\national_ur_labor_demand_`i'.dta"	
}

forvalues i=205(1)219 {
append using "$store_collapse\national_ur_labor_demand_`i'.dta"	
}

forvalues i=305(1)319 {
append using "$store_collapse\national_ur_labor_demand_`i'.dta"	
}

forvalues i=405(1)419 {
append using "$store_collapse\national_ur_labor_demand_`i'.dta"	
}


* Data transformation 
gen pct_ur_labor_demand = (100 * ur_labor_demand) // Transform the estimation from decimals to %  
drop ur_labor_demand

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

order year quarter pct_ur_labor_demand 
sort  year quarter

* Result: From 2007 onwards, usually more than 95% of women that answered that they were not working due to lack of labour demand, where living in rural areas. 
save "$root/national_ur_labor_demand_2005_2019.dta", replace





**********************************
/* Append the datasets that identify the percentage of women living in rural areas that 
are not working because there is a lack of labour demand AT THE STATE LEVEL */
*********************************


clear 
use "$store_collapse\state_ur_labor_demand_105.dta"

forvalues i=106(1)119 {
append using "$store_collapse\state_ur_labor_demand_`i'.dta"	
}

forvalues i=205(1)219 {
append using "$store_collapse\state_ur_labor_demand_`i'.dta"	
}

forvalues i=305(1)319 {
append using "$store_collapse\state_ur_labor_demand_`i'.dta"	
}

forvalues i=405(1)419 {
append using "$store_collapse\state_ur_labor_demand_`i'.dta"	
}




* Data transformation 
gen pct_ur_labor_demand = (100 * ur_labor_demand) // Transform the estimation from decimals to %  
drop ur_labor_demand
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
drop per 
order year quarter entity_name pct_ur_labor_demand 
sort  year quarter

save "$root/state_ur_labor_demand_2005_2019.dta", replace