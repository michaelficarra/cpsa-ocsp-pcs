cpsa +RTS -M512m -RTS -o pcs.txt pcs.scm && \
cpsagraph -o pcs.xhtml pcs.txt && \
firefox -remote "openFile(`pwd`/pcs.xhtml)"
