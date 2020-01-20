#!/usr/bin/env bash

function directory::clean { # $1 is the directory to remove and rebuild.
    rm -rf "$1"
    mkdir -p "$1"
}

function makepkg::silent {
    makepkg -d -f 2>&1 &>/dev/null
    return $?
}

function repoadd::silent {
    repo-add "$@" 2>&1 &>/dev/null
    return $?
}

function echo::status {
    echo -e "$(tput setaf 2)$(tput bold)==>$(tput sgr0)\t$@"
}

function echo::error {
    echo -e "$(tput setaf 1)$(tput bold)==>$(tput sgr0)\t$@"
    exit 1
}

root="$PWD"

alpmroot="$PWD/dnf-ci-alpm"
alpmroot_baseline="$alpmroot/baseline"

reporoot="$root/repo"
reporoot_baseline="$reporoot/baseline"

subdirs=(
    simple_upgrade provides replaces pear-browser
)

echo::status "Generating repository folders..."
# Generate some folders...
directory::clean "$reporoot"
mkdir "$reporoot/baseline"
for subdir in "${subdirs[@]}"; do
    mkdir "$reporoot/$subdir"
done

echo::status "Generating base repository..."
# Generate our base repository...
cd "$alpmroot_baseline"
for directory in */; do
    cd "$alpmroot_baseline"; cd "$directory"
    makepkg::silent || echo::error "Failed to build package $PWD/PKGBUILD! Aborting..."
    mv *.pkg.tar.gz "$reporoot_baseline"
    rm -rf pkg src
done
echo::status "Building repo database..."
repoadd::silent "$reporoot_baseline/repo.db.tar.gz" "$reporoot_baseline/"*.pkg.tar.gz || echo::error "Failed to build repository database! Aborting..."

echo::status "Generating extra repositories..."
# Now let's generate the additional repositories...
for subdir in "${subdirs[@]}"; do
    echo::status "Generating repo $subdir..."
    # Copy the baseline repository...
    cp -r "$reporoot_baseline"/* "$reporoot/$subdir"

    # Iterate over the packages here
    cd "$alpmroot/$subdir"
    for directory in */; do
        cd "$alpmroot/$subdir"; cd "$directory"
        makepkg::silent || echo::error "Failed to build package $PWD/PKGBUILD! Aborting..."
        mv *.pkg.tar.gz "$reporoot/$subdir"
        rm -rf pkg src
    done

    echo::status "Building repo $subdir database..."
    repoadd::silent "$reporoot/$subdir/repo.db.tar.gz" "$reporoot/$subdir/"*.pkg.tar.gz || echo::error "Failed to build repository $subdir database! Aborting..."
done