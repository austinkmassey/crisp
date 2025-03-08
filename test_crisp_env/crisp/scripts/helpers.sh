#!/usr/bin/env bash

# Helpers for path resolution in the Crisp project

# Get the directory containing the current script
function get_crisp_root() {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
}

# Get the project root directory
# The project the
function get_parent_project() {
    local crisp_root
    crisp_root=$(get_crisp_root)
    echo "$(cd "$crisp_root/.." && pwd)"
}

# Get the scripts directory
function get_scripts_dir() {
    local crisp_root
    crisp_root=$(get_crisp_root)
    echo "$crisp_root/scripts"
}

# Get the templates directory
function get_template_dir() {
    local crisp_root
    crisp_root=$(get_crisp_root)
    echo "$crisp_root/template"
}

# Get the output directory from config.yaml
function get_output_dir() {
    local crisp_root
    crisp_root=$(get_crisp_root)
    local project_root
    project_root=$(get_parent_project)
    local output
    output=$(yq -r -e '.crisp.output_directory' "$crisp_root/config.yaml")
    echo "$project_root/$output"
}

# Get the sprint directory
function get_sprint_dir() {
    local output_dir
    output_dir=$(get_output_dir)
    echo "$output_dir/sprint"
}

# Get the backlog directory
function get_backlog_dir() {
    local output_dir
    output_dir=$(get_output_dir)
    echo "$output_dir/backlog"
}

