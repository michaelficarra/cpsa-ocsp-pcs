rm -f pcs.txt pcs.xhtml
cpsa +RTS -M512m -RTS -o pcs.txt pcs.scm
cpsagraph -o pcs.xhtml pcs.txt && \
google-chrome "`pwd`/pcs.xhtml"
