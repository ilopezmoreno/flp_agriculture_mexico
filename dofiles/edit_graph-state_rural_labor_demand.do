cd "$main_folder\outputs\graphs\gph"

graph use "C:\Users\d57917il\Documents\GitHub\flp_agriculture_mexico\outputs\graphs\gph\states_rural_labor_demand.gph"


forvalues i=17(1)24 {

gr_edit .plotregion1.grpaxis[`i'].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[`i'].draw_view.setstyle, style(no)

}

forvalues i=1(1)8 {

gr_edit .plotregion1.grpaxis[`i'].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[`i'].draw_view.setstyle, style(no)

}

gr_edit .plotregion1.grpaxis[2].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[2].draw_view.setstyle, style(no)
gr_edit .plotregion1.grpaxis[3].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[3].draw_view.setstyle, style(no)
gr_edit .plotregion1.grpaxis[4].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[4].draw_view.setstyle, style(no)
gr_edit .plotregion1.grpaxis[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[5].draw_view.setstyle, style(no)
gr_edit .plotregion1.grpaxis[6].draw_view.setstyle, style(no)
gr_edit .plotregion1.supaxis[6].draw_view.setstyle, style(no)