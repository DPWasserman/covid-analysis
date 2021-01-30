
get_info <- function(data, var_name, FUNC, icon) {
  
  value = FUNC(data[[var_name]], na.rm=T)
  
  FUNC_name = toTitleCase(as.character(substitute(FUNC)))
  title = paste(FUNC_name, var_name)
  
  if (FUNC_name %in% c('Min','Max')) {
    state = sort(data$'State Abbr'[data[,var_name]==value])
    state = paste(state, collapse = "/")
  } else {
    state=NULL
  }
  
  colFormat = value_formats[value_formats$col==var_name,'format']
  valueStr = ifelse(colFormat==1,
                    formatC(value,format="f", big.mark = ",",digits=0),
                    paste0(formatC(value*100,format="f",big.mark=",",digits=2), '%'))
  return (infoBox(title=title, subtitle=state, value=valueStr, icon = icon, fill=T))
}

get_axis <- function(var_name) {
  colFormat = value_formats[value_formats$col==var_name,'format']
  
  if (colFormat==1){
    y_axis_format = scale_y_continuous(labels = scales::comma)
  } else {
    y_axis_format = scale_y_continuous(labels = scales::percent)
  }
  
  return (y_axis_format)
}