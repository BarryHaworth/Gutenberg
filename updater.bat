:: Update the LIbrivox files
r -e "source('librivox_get.R')"       > librivox_get.log
r -e "source('librivox_parse.R')"     > librivox_parse.log
r -e "source('librivox_gutenberg.R')" > librivox_gutenberg.log
:: Update the Gutenberg files
r -e "source('getfiles.R')"       > getfiles.log
r -e "source('readfiles.R')"      > readfiles.log