#!/usr/bin/env sh

# Synopsis:
# Test the test runner by running it against a predefined set of solutions 
# with an expected output.

# Output:
# Outputs the diff of the expected test results against the actual test results
# generated by the test runner.

# Example:
# ./bin/run-tests.sh

exit_code=0

# Iterate over all test directories
for test_dir in tests/*; do
    test_dir_name=$(basename "${test_dir}")
    test_dir_path=$(realpath "${test_dir}")
    cpcache_dir="${test_dir_path}/.cpcache"
    cljs_test_runner_out_dir="${test_dir_path}/cljs-test-runner-out"
    results_file_path="${test_dir_path}/results.json"
    expected_results_file_path="${test_dir_path}/expected_results.json"

    # Clear cache as this influences the test output
    rm -rf "${cpcache_dir}" > /dev/null
    rm -rf "${cljs_test_runner_out_dir}" > /dev/null

    bin/run.sh "${test_dir_name}" "${test_dir_path}" "${test_dir_path}"

    # Normalize the results file
    sed -i -E \
      -e "s~${test_dir_path}~/solution~g" \
      "${results_file_path}"

    echo "${test_dir_name}: comparing results.json to expected_results.json"
    diff "${results_file_path}" "${expected_results_file_path}"

    if [ $? -ne 0 ]; then
        exit_code=1
    fi
done

exit ${exit_code}
