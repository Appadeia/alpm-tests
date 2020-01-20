# Test One — Simple Dependency Solving (pacman -S | dnf install)

Install `base` and `browser` from baseline.

Packages installed should be: base, filesystem, linux, shell, browser, glibc, readline.

# Test Two - Simple Upgrade (pacman -Syu | dnf... distro-sync?)

Start off where Test One left off.

Replace baseline repository with simple_upgrade repository.

Start a system update.

Packages updated should be: browser, linux

# Test Three - Provides ( pacman -S | dnf install )

Start off where Test One left off.

Replace baseline repository with provides repository.

Install `appstore` from provides.

Packages installed should be: appstore, package that provides appstore-backend.

# Test Four - Replaces ( pacman -Syu | dnf... distro-sync?)

Start off where Test One left off.

Replace baseline repository with replaces repository.

Start a system update.

Package browser should be replaced with browser-better.

# Test Five - Optdepends ( pacman -S | dnf install )

Start off where Test One left off.

Replace baseline repository with optdepends repository.

Install `pear-browser`.

TODO: should behave like RPM recommends or suggestions? pacman just displays name and provided reason at the end of transaction.

# Test Six - What provides capability? ( nonexistent | dnf repoquery --whatprovides )

Start off where Test Three left off.

Query repository to find out packages that provide `appstore-backend`.

Packages should be `appstore-backends-flatpak` and `appstore-backends-snap`.

# Test Seven - What owns file? ( pacman -F | dnf repoquery -f )

Start off where Test One left off.

Replace baseline repository with filequery repository.

Query repository to find out packages with the file `/usr/bin/zsh`.

Package should be `why-cant-i-feel-my-legs`.

# Test Eight - ooh yes downgrade me daddy ( pacman -U | dnf downgrade | dnf install )

Note: this is an unlikely scenario to be encountered using Arch packages.

Start off where Test One left off.

Install older linux pkg.tar.gz found in downgrade repository.

Package linux should be downgraded.

# Test Nine - Removal ( pacman -R[bajillion solver combinations] | dnf remove)

Start where Test One left off.

Remove `base`.

`pacman -R` -> Unable to complete transaction.

`pacman -Rs` -> Completes transaction.

Base and unused dependencies of it should be removed.

Remaining packages should be `glibc`, `readline`, and `browser`.