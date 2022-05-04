docs:
	R -e "devtools::document()"
	R -e "devtools::build_readme()"
