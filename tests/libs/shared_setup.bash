#!/bin/bash

set -e
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

if [ -z $LOCAL_CI_TESTS_CACHEDIR ]; then
    echo "Please define LOCAL_CI_TESTS_CACHEDIR" >&2
    exit 1;
fi

if [ ! -d $LOCAL_CI_TESTS_CACHEDIR ]; then
    echo "Please ensure LOCAL_CI_TESTS_CACHEDIR is a directory" >&2
    exit 1
fi

if [ -z $LOCAL_CI_TESTS_GITDIR ]; then
    echo "Please define LOCAL_CI_TESTS_GITDIR. It should be a git clone of moodle.git." >&2
    echo "IT WILL CAUSE DESTRUCTIVE CHANGES TO THE GIT REPO, DO NOT SHARE IT WITH YOUR CODE!" >&2
    exit 1;
fi

export WORKSPACE=$BATS_TMPDIR/workspace
mkdir -p $WORKSPACE
export gitcmd=git
export phpcmd=php
export npmcmd=npm
export npmbase=$LOCAL_CI_TESTS_CACHEDIR/npmbase
mkdir -p $npmbase
export gitdir=$LOCAL_CI_TESTS_GITDIR

create_git_branch () {
    branch=$1
    resetto=$2

    cd $gitdir
    $gitcmd checkout . -q
    $gitcmd clean -fd -q
    $gitcmd checkout -B $branch -q
    $gitcmd reset --hard $resetto -q

    export gitbranch=$branch
    cd $BATS_TEST_DIRNAME
}
