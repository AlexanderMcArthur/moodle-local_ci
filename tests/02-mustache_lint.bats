#!/usr/bin/env bats

load libs/shared_setup

setup () {
    create_git_branch MOODLE_31_STABLE v3.1.2
}

@test "mustache_lint: Good mustache file" {
    # Set up.
    git_apply_fixture 31-mustache_lint-ok.patch
    export GIT_PREVIOUS_COMMIT=$FIXTURE_HASH_BEFORE
    export GIT_COMMIT=$FIXTURE_HASH_AFTER

    ci_run mustache_lint/mustache_lint.sh

    # Assert result
    assert_success
    assert_output --partial "Running mustache lint from $GIT_PREVIOUS_COMMIT to $GIT_COMMIT"
    assert_output --partial "lib/templates/linting_ok.mustache - OK: Mustache rendered html succesfully"
    assert_output --partial "No mustache problems found"
}

@test "mustache_lint: No example content" {
    # Set up.
    git_apply_fixture 31-mustache_lint-no-example.patch
    export GIT_PREVIOUS_COMMIT=$FIXTURE_HASH_BEFORE
    export GIT_COMMIT=$FIXTURE_HASH_AFTER

    ci_run mustache_lint/mustache_lint.sh

    # Assert result
    assert_failure
    assert_output --partial "Running mustache lint from $GIT_PREVIOUS_COMMIT to $GIT_COMMIT"
    assert_output --partial "lib/templates/linting.mustache - WARNING: Example context missing."
    assert_output --partial "Mustache lint problems found"
}

@test "mustache_lint: Example content invalid json" {
    # Set up.
    git_apply_fixture 31-mustache_lint-invalid-json.patch
    export GIT_PREVIOUS_COMMIT=$FIXTURE_HASH_BEFORE
    export GIT_COMMIT=$FIXTURE_HASH_AFTER

    ci_run mustache_lint/mustache_lint.sh

    # Assert result
    assert_failure
    assert_output --partial "Running mustache lint from $GIT_PREVIOUS_COMMIT to $GIT_COMMIT"
    assert_output --partial "lib/templates/linting.mustache - ERROR: Mustache syntax exception: Example context JSON is unparsable, fails with: Syntax error"
    assert_output --partial "Mustache lint problems found"
}

@test "mustache_lint: Mustache syntax error" {
    # Set up.
    git_apply_fixture 31-mustache_lint-mustache-syntax-error.patch
    export GIT_PREVIOUS_COMMIT=$FIXTURE_HASH_BEFORE
    export GIT_COMMIT=$FIXTURE_HASH_AFTER

    ci_run mustache_lint/mustache_lint.sh

    # Assert result
    assert_failure
    assert_output --partial "Running mustache lint from $GIT_PREVIOUS_COMMIT to $GIT_COMMIT"
    assert_output --partial "lib/templates/linting.mustache - ERROR: Mustache syntax exception: Missing closing tag: test opened on line 2"
    assert_output --partial "Mustache lint problems found"
}

@test "mustache_lint: HTML validation issue" {
    # Set up.
    git_apply_fixture 31-mustache_lint-html-validator-fail.patch
    export GIT_PREVIOUS_COMMIT=$FIXTURE_HASH_BEFORE
    export GIT_COMMIT=$FIXTURE_HASH_AFTER

    ci_run mustache_lint/mustache_lint.sh

    # Assert result
    assert_failure
    assert_output --partial "Running mustache lint from $GIT_PREVIOUS_COMMIT to $GIT_COMMIT"
    assert_output --partial "lib/templates/linting.mustache - WARNING: HTML Validation error, line 2: End tag “p” seen, but there were open elements. (ello World</p></bo)"
    assert_output --partial "lib/templates/linting.mustache - WARNING: HTML Validation error, line 2: Unclosed element “span”. (<body><p><span>Hello )"
    assert_output --partial "Mustache lint problems found"
}

@test "mustache_lint: Partials are loaded" {
    # Set up.
    git_apply_fixture 31-mustache_lint-partials-loaded.patch
    export GIT_PREVIOUS_COMMIT=$FIXTURE_HASH_BEFORE
    export GIT_COMMIT=$FIXTURE_HASH_AFTER

    ci_run mustache_lint/mustache_lint.sh

    # Assert result
    assert_success
    # If the partial was not loaded we'd produce this info message:
    refute_output --partial "test_partial_loading.mustache - INFO: Template produced no content"

    assert_output --partial "blocks/lp/templates/test_partial_loading.mustache - OK: Mustache rendered html succesfully"
    assert_output --partial "No mustache problems found"
}
