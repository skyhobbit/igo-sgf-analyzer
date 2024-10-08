# igo-sgf-analyzer

## winrate_black_white.sh

print winrate black or white turn from sgf files


## extract_japanese_name.xslt

translate english name to Japanese name using GoGoD Name file.

Need NamesXML-XSD/NamesXML.xml

How to use

 % xsltproc --stringparam inputName "Abe no Nakamaro" extract_japanese_name.xslt NamesXML-XSD/NamesXML.xml
阿部仲麻郎

need xslt processor. for example xsltproc.
if you want to install on MacOS

% brew install libxslt
