#!/bin/bash

function create_branch {
    local repo_path=$1
    local branch_name=$2
    local base_branch=$3
    local tag_point=$4
    
    if [[ ! -d $repo_path/.git ]]; then
        echo "Error: $repo_path is not a Git repository" >&2
        return 1
    fi
    
    if git -C "$repo_path" branch --list "$branch_name"; then
        echo "Branch $branch_name already exists in $repo_path"
        return
    fi
    
    if [[ ! -z $base_branch ]]; then
        base=$(git -C "$repo_path" rev-parse --verify "refs/heads/$base_branch") || return 1
    elif [[ ! -z $tag_point ]]; then
        base=$(git -C "$repo_path" rev-parse --verify "refs/tags/$tag_point") || return 1
    else
        echo "Error: missing input value for base branch or tag point" >&2
        return 1
    fi
    
    git -C "$repo_path" checkout "$base" || return 1
    git -C "$repo_path" branch "$branch_name" || return 1
    echo "Branch $branch_name created in $repo_path"
}

function create_branches {
    local repos=("$@")
    local branch_name=$1
    local base_branch=$2
    local tag_point=$3
    
    for repo_path in "${repos[@]}"; do
        create_branch "$repo_path" "$branch_name" "$base_branch" "$tag_point"
    done
}

repos=('/path/to/repo1' '/path/to/repo2' '/path/to/repo3')
branch_name='rel/hcl_release_1'
base_branch='master'
tag_point='rel_hcl.1.1'

create_branches "${repos[@]}" "$branch_name" "$base_branch" "$tag_point"
