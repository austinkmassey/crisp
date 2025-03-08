source crisp/scripts/index.sh
index_file="$CRISP_DOC/test_index.md"
cat <<EOF > "$index_file"
- [001.md](docs/backlog/001.md)
- [002.md](docs/backlog/002.md)
EOF

#declare -A index_data
parse_current_index "docs/test_index.md" index_data
#[[ "${index_data[001.md]}" == "- [001.md](docs/backlog/001.md)\n" ]]
#[[ "${index_data[002.md]}" == "- [002.md](docs/backlog/002.md)\n" ]]

