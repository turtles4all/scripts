set -f
CHARS=(\! \@ \# \$ \% \^ \& \\* \( \))
for x in ${CHARS[@]}; do
echo -e {A..Z}-$x-{0..9}-{a..z}"\n" | tr -d ' ' 
done
set +f
