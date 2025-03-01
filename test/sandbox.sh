source crisp/scripts/index.sh
  

  #tempfile=$(mktemp -d)
  index_file="/tmp/tmp.31JQpPawo8/test_index.md"
  CRISP_DOC="/tmp/tmp.31JQpPawo8"
  echo $CRISP_DOC

  #local index_file="$CRISP_DOC/test_index.md"
  declare -A index_data=(
    ["file1.txt"]="- [file1.txt](docs/file1.txt)"
    ["file2.txt"]="- [file2.txt](docs/file2.txt)"
  )

  write_index_file "$index_file" index_data

  # Check that the file contains the expected entries
  grep -F -- "- [file1.txt](docs/file1.txt)" "$index_file"
  #[ "$status" -eq 0 ] # Assert the exit status is 0 (match found)

  grep -F -- "- [file2.txt](docs/file2.txt)" "$index_file"
  #[ "$status" -eq 0 ] # Assert the exit status is 0 (match found)
