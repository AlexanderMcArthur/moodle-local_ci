#!/usr/bin/env bash
# $gitcmd: Path to the git CLI executable
# $gitdir: Directory containing git repo
# $phpcmd: Path to php CLI exectuable
# $validator: (optional) url for validator - defaults to https://html5.validator.nu
#
# Based on GIT_PREVIOUS_COMMIT and GIT_COMMIT will list all changed php
# files and run lint on them.
#
set -e

validator=${validator:-'https://html5.validator.nu/'}
# Verify everything is set
required="gitcmd gitdir phpcmd GIT_PREVIOUS_COMMIT GIT_COMMIT"
for var in $required; do
    if [ -z "${!var}" ]; then
        echo "Error: ${var} environment variable is not defined. See the script comments."
        exit 1
    fi
done

# calculate some variables
mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export initialcommit=${GIT_PREVIOUS_COMMIT}
export finalcommit=${GIT_COMMIT}
if mfiles=$(${mydir}/../list_changed_files/list_changed_files.sh)
then
    echo "Running mustache lint from $initialcommit to $finalcommit:"
else
    echo "Problems getting the list of changed files."
    exit 1;
fi

# Verify all the changed files.
errorfound=0
for mfile in ${mfiles} ; do
    # Only run on mustache files.
    if [[ "${mfile}" =~ ".mustache" ]] ; then
        fullpath=$gitdir/$mfile

        if [ -e $fullpath ] ; then
            if ! $phpcmd $mydir/mustache_lint.php --filename=$fullpath --validator=$validator
            then
                errorfound=1
            fi
        else
            # This is a bit of a hack, we should really be using git to
            # get actual file contents from the latest commit to avoid
            # this situation. But in the end we are checking against the
            # current state of the codebase, so its no bad thing..
            echo "$fullpath - SKIPPED (file no longer exists)"
        fi
    fi
done

if [[ ${errorfound} -eq 0 ]]; then
    # No syntax errors found, all good.
    echo "No mustache problems found"
    exit 0
fi

echo "Mustache lint problems found"
exit 1
