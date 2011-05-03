[ $# -lt 1 ] && exit 1
rm -f pcs.txt pcs_shapes.txt
cpsa +RTS -N4 -M512m -RTS -o pcs.txt pcs.scm
cpsashapes -o pcs_shapes.txt pcs.txt
cpsagraph -o "$1" pcs_shapes.txt && \
google-chrome "$1"
