:: Update the LIbrivox files
r -e "source('librivox_get.R')"   > librivox_get.log
r -e "source('librivox_parse.R')" > librivox_parse.log
:: Update the Gutenberg files
r -e "source('getfiles.R')"       > getfiles.log
r -e "source('readfiles.R')"      > readfiles.log