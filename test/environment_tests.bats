#!/usr/bin/env bats

# Crisp BATS Environment Tests
# Verify basic Crisp functionality for environment operations

 # Setup function
 setup() {
   if [ -n "$CRISP_TEST_DIR" ]; then
     cd "$CRISP_TEST_DIR"
   else
     echo "CRISP_TEST_DIR not set" >&2
     exit 1
   fi
 }

 # Teardown function
 teardown() {
   cd -
 }

 @test "Environment is set" {
   [ -n "$CRISP_TEST_DIR" ]
 }

 @test "Crisp can activate a valid environment" {
   run bash -c "source .crisp/activate.sh .crisp/config.yaml"
   [[ "$status" -eq 0 ]]
 }

 @test "Crisp returns error for invalid config file" {
   run bash -c "source .crisp/activate.sh does_not_exist/config.yaml'"
   [[ "$status" -ne 0 ]]
 }

 @test "Crisp returns error on double activation" {
   run bash -c "source .crisp/activate.sh .crisp/config.yaml && source .crisp/activate.sh .crisp/config.yaml"
   [[ "$status" -ne 0 ]]
   [[ "$output" == *"A crisp environment, is already active in this shell."* ]]
 }

 @test "Crisp status command output check" {
   run bash -c "source .crisp/activate.sh .crisp/config.yaml && crisp status"
   [ "$status" -eq 0 ]
   [[ "$output" =~ Activated:[[:space:]]*true ]]
   [[ "$output" =~ Parent:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
   [[ "$output" =~ Docs:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
   [[ "$output" =~ Crisp:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
   [[ "$output" =~ Scripts:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
 }
