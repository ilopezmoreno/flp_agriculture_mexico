clear

/*
global enoe_data "C:\Users\d57917il\Documents\1paper1\5_ENOE_databases\Bases ENOE"
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"
*/

global agri_machinery "$main_folder\data\store_collapse\agri_machinery"
global labor_demand "$main_folder\data\store_collapse\labor_demand"
global agri_flp "$main_folder\data\store_collapse\pct_flp_agri"
global raw "$main_folder\data\final_datasets\raw"


////////// APPEND AGRIMACHINERY - 1ST DATASET: Agri Machinery Ratio at the STATE LEVEL

* 1ST DATASET: Agri Machinery Ratio at the STATE LEVEL 
clear
use "$agri_machinery\state\state_agri_mach_ratio_105.dta"
forvalues i=106(1)119 {
append using "$agri_machinery\state\state_agri_mach_ratio_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$agri_machinery\state\state_agri_mach_ratio_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$agri_machinery\state\state_agri_mach_ratio_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$agri_machinery\state\state_agri_mach_ratio_`i'.dta"	
}
save "$raw\state_agri_mach_ratio_2005_2019_storecollapse.dta", replace

* 2ND DATASET: Agri Machinery Ratio at the NATIONAL LEVEL 
clear
use "$agri_machinery\national\national_agri_mach_ratio_105.dta"
forvalues i=106(1)119 {
append using "$agri_machinery\national\national_agri_mach_ratio_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$agri_machinery\national\national_agri_mach_ratio_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$agri_machinery\national\national_agri_mach_ratio_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$agri_machinery\national\national_agri_mach_ratio_`i'.dta"	
}
save "$raw\national_agri_mach_ratio_2005_2019_storecollapse.dta", replace


///////////////// APPEND LABOUR DEMAND /////////////////

* 1st dataset: STATE - RURAL & URBAN AREAS
clear
use "$labor_demand\state\state_labor_demand_105.dta"
forvalues i=106(1)119 {
append using "$labor_demand\state\state_labor_demand_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$labor_demand\state\state_labor_demand_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$labor_demand\state\state_labor_demand_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$labor_demand\state\state_labor_demand_`i'.dta"	
}
save "$raw/state_labor_demand_2005_2019_storecollapse.dta", replace

* 2nd dataset: STATE - ONLY RURAL AREAS
clear
use "$labor_demand\state_rural\state_rural_labor_demand_105.dta"
forvalues i=106(1)119 {
append using "$labor_demand\state_rural\state_rural_labor_demand_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$labor_demand\state_rural\state_rural_labor_demand_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$labor_demand\state_rural\state_rural_labor_demand_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$labor_demand\state_rural\state_rural_labor_demand_`i'.dta"	
}
save "$raw/state_rural_labor_demand_2005_2019_storecollapse.dta", replace

* 3rd dataset: NATIONAL - RURAL & URBAN AREAS
clear
use "$labor_demand\national\national_labor_demand_105.dta"
forvalues i=106(1)119 {
append using "$labor_demand\national\national_labor_demand_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$labor_demand\national\national_labor_demand_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$labor_demand\national\national_labor_demand_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$labor_demand\national\national_labor_demand_`i'.dta"	
}
save "$raw/national_labor_demand_2005_2019_storecollapse.dta", replace

* 4th dataset: NATIONAL - ONLY RURAL AREAS 
clear
use "$labor_demand\national_rural\national_rural_labor_demand_105.dta"
forvalues i=106(1)119 {
append using "$labor_demand\national_rural\national_rural_labor_demand_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$labor_demand\national_rural\national_rural_labor_demand_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$labor_demand\national_rural\national_rural_labor_demand_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$labor_demand\national_rural\national_rural_labor_demand_`i'.dta"	
}
save "$raw/national_rural_labor_demand_2005_2019_storecollapse.dta", replace


///////////////// APPEND AGRI FLP /////////////////


* SEX_AGRI - NATIONAL 
clear 
use "$agri_flp\national\national_sex_agri_105.dta"
forvalues i=106(1)119 {
append using "$agri_flp\national\national_sex_agri_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$agri_flp\national\national_sex_agri_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$agri_flp\national\national_sex_agri_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$agri_flp\national\national_sex_agri_`i'.dta"	
}
save "$raw/national_sexagri_2005_2019_storecollapse.dta", replace

* SEX_AGRI - STATE 
clear 
use "$agri_flp\state\state_sex_agri_105.dta"
forvalues i=106(1)119 {
append using "$agri_flp\state\state_sex_agri_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$agri_flp\state\state_sex_agri_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$agri_flp\state\state_sex_agri_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$agri_flp\state\state_sex_agri_`i'.dta"	
}
save "$raw/state_sexagri_2005_2019_storecollapse.dta", replace

* AGRI_FLP - NATIONAL 
clear 
use "$agri_flp\national\national_agriflp_105.dta"
forvalues i=106(1)119 {
append using "$agri_flp\national\national_agriflp_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$agri_flp\national\national_agriflp_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$agri_flp\national\national_agriflp_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$agri_flp\national\national_agriflp_`i'.dta"	
}
save "$raw/national_agriflp_2005_2019_storecollapse.dta", replace

* AGRI_FLP - STATE
clear 
use "$agri_flp\state\state_agriflp_105.dta"
forvalues i=106(1)119 {
append using "$agri_flp\state\state_agriflp_`i'.dta"	
}
forvalues i=205(1)219 {
append using "$agri_flp\state\state_agriflp_`i'.dta"	
}
forvalues i=305(1)319 {
append using "$agri_flp\state\state_agriflp_`i'.dta"	
}
forvalues i=405(1)419 {
append using "$agri_flp\state\state_agriflp_`i'.dta"	
}
save "$raw/state_agriflp_2005_2019_storecollapse.dta", replace






/*

clear 

global enoe_data "C:\Users\d57917il\Documents\1paper1\5_ENOE_databases\Bases ENOE"
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"

global agri_machinery "$main_folder\data\store_collapse\agri_machinery"
global labor_demand "$main_folder\data\store_collapse\labor_demand"
global agri_flp "$main_folder\data\store_collapse\pct_flp_agri"
global raw "$main_folder\data\final_datasets\raw"


local X /// 
105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 /// datasets from the 1st quarter of 2005 to 2019 
205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 /// datasets from the 2nd quarter of 2005 to 2019
305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 /// datasets from the 3rd quarter of 2005 to 2019
405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 // datasets from the 4th quarter of 2005 to 2019 

////////// APPEND AGRIMACHINERY - 1ST DATASET: Agri Machinery Ratio at the STATE LEVEL
foreach year_quarter of local X {
use "$agri_machinery\state\state_agri_mach_ratio_105.dta"
append using "$agri_machinery\state\state_agri_mach_ratio_`year_quarter'.dta"	
}
save "$raw/state_agri_mach_ratio_2005_2019_storecollapse.dta", replace

////////// APPEND AGRIMACHINERY - 2ND DATASET: Agri Machinery Ratio at the NATIONAL LEVEL 
foreach year_quarter of local X {
use "$agri_machinery\national\national_agri_mach_ratio_105.dta"
append using "$agri_machinery\national\national_agri_mach_ratio_`i'.dta"	
}
save "$raw/national_agri_mach_ratio_2005_2019_storecollapse.dta", replace

////////// APPEND LABOUR DEMAND - 1st dataset: STATE - RURAL & URBAN AREAS
foreach year_quarter of local X {
use "$labor_demand\state\state_labor_demand_105.dta"
append using "$labor_demand\state\state_labor_demand_`i'.dta"
}
save "$raw/state_labor_demand_2005_2019_storecollapse.dta", replace

////////// APPEND LABOUR DEMAND - 2nd dataset: STATE - ONLY RURAL
foreach year_quarter of local X {
use "$labor_demand\state_rural\state_rural_labor_demand_105.dta"
append using "$labor_demand\state_rural\state_rural_labor_demand_`i'.dta"
}
save "$raw/state_rural_labor_demand_2005_2019_storecollapse.dta", replace

////////// APPEND LABOUR DEMAND - 3rd dataset: NATIONAL - RURAL & URBAN AREAS
foreach year_quarter of local X {
use "$labor_demand\national\national_labor_demand_105.dta"
append using "$labor_demand\national\national_labor_demand_`i'.dta"	
}
save "$raw/national_labor_demand_2005_2019_storecollapse.dta", replace

////////// APPEND LABOUR DEMAND - 4th dataset: NATIONAL - ONLY RURAL
foreach year_quarter of local X {
use "$labor_demand\national_rural\national_rural_labor_demand_105.dta"
append using "$labor_demand\national_rural\national_rural_labor_demand_`i'.dta"	
}
save "$raw/national_rural_labor_demand_2005_2019_storecollapse.dta", replace

////////// APPEND AGRI FLP - 1st dataset: NATIONAL 
foreach year_quarter of local X {
use "$agri_flp\national\national_agriflp_105.dta"
append using "$agri_flp\national\national_agriflp_`i'.dta"	
}
save "$raw/national_agriflp_2005_2019.dta", replace

////////// APPEND AGRI FLP - 1st dataset: STATE 
foreach year_quarter of local X {
use "$agri_flp\state\state_agriflp_105.dta"
append using "$agri_flp\state\state_agriflp_`i'.dta"	
}
save "$raw/state_agriflp_2005_2019.dta", replace


*/
