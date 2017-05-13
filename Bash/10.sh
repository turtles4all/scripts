echo 'function body() {
IFS= read -r header
printf '%s\n' "$header"
"$@"
}' >>./.bashrc


#df -h | body sort -k 5
