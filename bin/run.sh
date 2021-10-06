#!/usr/bin/env bash

# Synopsis:
# Run the test runner on a solution.

# Arguments:
# $1: exercise slug
# $2: absolute path to solution folder
# $3: absolute path to output directory

# Output:
# Writes the test results to a results.json file in the passed-in output directory.
# The test results are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/test-runners/interface.md

# Example:
# ./bin/run.sh two-fer /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/"
    exit 1
fi

slug="$1"
input_dir="${2%/}"
output_dir="${3%/}"
results_file="${output_dir}/results.json"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${slug}: testing..."

pushd "${input_dir}" > /dev/null

source_script=$(cat src/leap.cljs)
test_script=$(cat test/leap_test.cljs | sed 's/cljs.test/clojure.test/')
exit_on_failure_script="(defmethod t/report [:cljs.test/default :end-run-tests] [{:keys [fail error]}] (js/process.exit (if (pos? (+ fail error)) 1 0)))"
run_tests_script="(t/run-tests 'leap-test)"
test_script="${source_script} ${test_script} ${exit_on_failure_script} ${run_tests_script}"

# Run the tests for the provided implementation file and redirect stdout and
# stderr to capture it
test_output=$(nbb -e "${test_script}" 2>&1)
exit_code=$?
error=$(echo "${test_output}" | grep -c -E '\-\- Error \-\-')

popd > /dev/null

# Write the results.json file based on the exit code of the command that was
# just executed that tested the implementation file
if [ $exit_code -eq 0 ] && [ $error -eq 0 ]; then
    jq -n '{version: 1, status: "pass"}' > ${results_file}
else
    sanitized_test_output=$(echo "${test_output}" | sed -E -e 's/-+ Error -+//g' -e '/./,$!d' -e '/Phase: /q;p')

    jq -n --arg output "${sanitized_test_output}" '{version: 1, status: "fail", message: $output}' > ${results_file}
fi

echo "${slug}: done"
