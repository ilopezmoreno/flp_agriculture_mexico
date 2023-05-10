
global main_folder "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico"

global graphs_gph "$main_folder\outputs\graphs\gph"
global graphs_jpg "$main_folder\outputs\graphs\jpg"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* GRAPH - Percentage of women working in agriculture as a proportion of all people working in Agriculture (STATE LEVEL)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

cd "$main_folder\data\final_datasets\tidy"
use state_agri_activewomen_2005_2019

graph bar (mean) agri_activewomen, over(quarter) over(year) yscale(range(0 40)) by(entity_name, noedgelabel compact rows(4))

gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy // Change background to white 
*gr_edit .note.draw_view.setstyle, style(no) // To eliminate note at the bottom left corner 
gr_edit .l1title.draw_view.setstyle, style(no) // To remove the label of the y axis 

// To edit title
gr_edit .title.text = {} 
gr_edit .title.text.Arrpush `"Percentage of women working in agriculture as a proportion"'
gr_edit .title.text.Arrpush `"of all economically active women. (32 Mexican States, 2005 - 2019)"'
gr_edit .title.style.editstyle size(medsmall) editcopy

// To edit the size and position of years and quarters in the x axis. 
gr_edit .plotregion1.grpaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(tiny)))) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .plotregion1.supaxis[25].style.editstyle majorstyle(tickangle(vertical)) editcopy

// To remove x axis from the first 3 rows, and keep only the last row. 
forvalues i=1(1)24 {
gr_edit .plotregion1.grpaxis[`i'].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[`i'].draw_view.setstyle, style(no)
}

graph save "Graph" "$graphs_gph\states_agri_activewomen.gph", replace
graph export "$graphs_jpg\states_agri_activewomen.png", replace