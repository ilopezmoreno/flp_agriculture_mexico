global state_rural_labor_demand "$main_folder\data\final_datasets\tidy"
global graphs_gph "$main_folder\outputs\graphs\gph"
global graphs_jpg "$main_folder\outputs\graphs\jpg"

////////////////////////////////////
* GRAPH - State Rural Labor Demand *
////////////////////////////////////

cd "$state_rural_labor_demand"
use state_rural_labor_demand_2005_2019

graph bar (mean) pct_w_state_rural_labor_demand, over(quarter) over(year) yscale(range(0 100)) by(entity_name, noedgelabel compact rows(4))

forvalues i=1(1)24 {
gr_edit .plotregion1.grpaxis[`i'].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[`i'].draw_view.setstyle, style(no)
}

gr_edit .plotregion1.grpaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(tiny)))) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickangle(vertical)) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .note.draw_view.setstyle, style(no)
gr_edit .l1title.text = {}
gr_edit .l1title.text.Arrpush `"Percentage of working age women living in rural areas"'
gr_edit .l1title.text.Arrpush `"that are not working due to lack of labour demand"'
gr_edit .l1title.style.editstyle size(vsmall) editcopy


graph save "Graph" "$graphs_gph\states_rural_labor_demand.gph", replace
graph export "$graphs_jpg\states_rural_labor_demand.png", replace

