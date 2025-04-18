valid_type() {
  local type="${1:-}"
  crisp=$(yq -r ".crisp.artifact_type.$1") < $CONFIG

}
create() {

}

parse() {

}

list_fields() {
  local file="${1:-}"
    echo "Template file does not exist"
    exit 1
  fi
  grep -o '\$.*' "$file" # returns the string following a `$`
}
