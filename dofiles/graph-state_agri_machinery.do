global graphs_gph "$main_folder\outputs\graphs\gph"
global graphs_jpg "$main_folder\outputs\graphs\jpg"

////////////////////////////////////
* GRAPH - State Rural Labor Demand *
////////////////////////////////////

cd "$main_folder\data\final_datasets\tidy"
use state_agri_mach_ratio_2005_2019

graph bar (mean) agri_machinery, over(quarter) over(year) yscale(range(0 15)) by(entity_name, noedgelabel compact rows(4))

forvalues i=1(1)24 {
gr_edit .plotregion1.grpaxis[`i'].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[`i'].draw_view.setstyle, style(no)
}

gr_edit .plotregion1.grpaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(tiny)))) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickangle(vertical)) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(large)))) editcopy
gr_edit .note.draw_view.setstyle, style(no)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy // Change background to white 
gr_edit .title.text = {}
gr_edit .title.text.Arrpush `"Percentage of agricultural machinery operations as a proportion"'
gr_edit .title.text.Arrpush `"of people working in agriculture. (32 Mexican States, 2013 - 2019)"'
gr_edit .title.DragBy .116826080721591 2.803825937317551
gr_edit .title.style.editstyle size(medsmall) editcopy

graph save "Graph" "$graphs_gph\states_agri_machinery.gph", replace
graph export "$graphs_jpg\states_agri_machinery.png", replace

