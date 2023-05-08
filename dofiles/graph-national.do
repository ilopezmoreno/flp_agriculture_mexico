clear 
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"

global graphs_gph "$main_folder\outputs\graphs\gph"
global graphs_jpg "$main_folder\outputs\graphs\jpg"


////////////////////////////////////////////////////
* GRAPH - National Agricultural Machinery Operators 
////////////////////////////////////////////////////



* Agri machinery ratio at the national level from 2013 to 2019 
cd "$main_folder\data\final_datasets\tidy"
use national_agri_mach_ratio_2005_2019
graph bar (mean) agri_machinery, over(quarter) over(year) yscale(range(0 2)) blabel(total, format(%8.2f))
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy // Change background to white
gr_edit .scaleaxis.title.draw_view.setstyle, style(no) // title edits
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Percentage of agricultural machinery operators as a proportion of"'
gr_edit .title.text.Arrpush `"total number of people working in agriculture. (National Average, 2013 - 2019)"'
gr_edit .title.style.editstyle size(small) editcopy // Change size of the title
gr_edit .plotregion1.barlabels[1].style.editstyle size(vsmall) editcopy // Change size of data labels in each bar graph 
gr_edit .plotregion1.barlabels[6].DragBy -.0327758053870391 0 // barlabels[6] reposition
gr_edit .plotregion1.barlabels[13].DragBy -.0327758053870405 -.2989148352537588 // barlabels[13] reposition
graph save "Graph" "$graphs_gph\agrimachinery_national.gph", replace
graph export "$graphs_jpg\agrimachinery_national.png", replace
clear 




* Average Agri machinery ratio at the state level from 2013 to 2019. 
* (Including national average to see which states are above or below)
cd "$main_folder\data\final_datasets\tidy"
use state_agri_mach_ratio_2005_2019
append using national_agri_mach_ratio_2005_2019
collapse (mean) agri_machinery, by(entity_name)
sort agri_machinery
label define entity_name 50 "National Average", modify 

graph hbar (mean) agri_machinery, over(entity_name, sort(agri_machinery)) blabel(total, format(%8.2f))
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy // Change background to white
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Percentage of agricultural machinery operators as a proportion of total"'
gr_edit .title.text.Arrpush `"number of people working in agriculture (Average from 2013 to 2019)"'
gr_edit .title.style.editstyle size(small) editcopy // Change size of the title
gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .scaleaxis.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.barlabels[33].style.editstyle size(vsmall) editcopy
gr_edit .plotregion1.bars[15].EditCustomStyle , j(-1) style(shadestyle(color(red)))
gr_edit .plotregion1.bars[15].EditCustomStyle , j(-1) style(linestyle(color(red)))

graph save "Graph" "$graphs_gph\agrimachinery_state-average.gph", replace
graph export "$graphs_jpg\agrimachinery_state-average.png", replace



/////////////////////////////////////////////////////////////
* GRAPH - National Labour Demand (Urban & Rural / Only Rural) 
/////////////////////////////////////////////////////////////

clear 
cd "$main_folder\data\final_datasets\tidy"
use national_labor_demand_2005_2019

merge 1:1 year_q using national_rural_labor_demand_2005_2019
drop _merge 
drop if year==2005
drop if year==2006

destring year_q, replace

graph bar (mean) country_labor_demand (mean) country_rural_labor_demand, over(quarter) over(year)

gr_edit .legend.plotregion1.label[1].text = {}
gr_edit .legend.plotregion1.label[1].text.Arrpush Considering urban and rural areas
gr_edit .legend.plotregion1.label[2].DragBy 0 -4.088912825254764
gr_edit .legend.plotregion1.label[2].text = {}
gr_edit .legend.plotregion1.label[2].text.Arrpush Considering only rural areas
gr_edit .legend.plotregion1.label[1].style.editstyle size(vsmall) editcopy
gr_edit .legend.plotregion1.label[2].style.editstyle size(vsmall) editcopy
gr_edit .legend.plotregion1.label[2].DragBy .1168260807215666 3.738434583090099
gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .supaxis.style.editstyle majorstyle(tickstyle(textstyle(size(medsmall)))) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Percentage of women who indicated that they are not working due to lack of labour demand"'
gr_edit .title.text.Arrpush `"as a proportion of women indicating any other reason why they are not working (National Average)"'
gr_edit .title.style.editstyle size(small) editcopy
gr_edit .title.DragBy .4673043228862547 1.401912968658771

graph save "Graph" "$graphs_gph\national_labordemand.gph", replace
graph export "$graphs_jpg\national_labordemand.png", replace

