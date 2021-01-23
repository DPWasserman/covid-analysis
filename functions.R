
get_info <- function(data, var_name, FUNC, icon) {
  FUNC_name = as.character(substitute(FUNC))
  value = FUNC(data[var_name], na.rm=T)
  
  if (FUNC_name %in% c('min','max')) {
    state = sort(data$'State Abbr'[data[,var_name]==value])
    state = paste(state, collapse = "/")
  } else {
    state = paste(toTitleCase(FUNC_name), var_name)
  }
  
  colFormat = value_formats[value_formats$col==var_name,'format']
  valueStr = ifelse(colFormat==1,
                    formatC(value,format="f", big.mark = ",",digits=0),
                    paste0(formatC(value*100,format="f",big.mark=",",digits=2), '%'))
  return (infoBox(state, valueStr, icon = icon, fill=T))
}