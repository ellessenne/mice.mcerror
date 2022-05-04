docs:
	R -e "styler::style_dir(filetype = c('r', 'rmd'))"
	R -e "devtools::document()"
	R -e "devtools::build_readme()"
