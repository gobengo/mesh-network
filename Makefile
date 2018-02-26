GIT=git

.PHONY: default git-submodules

default: git-submodules
git-submodules: lib/gobengo/exitnode

# ./lib/* should only have git submodules
lib/%: .gitmodules
	$(GIT) submodule update --init
	touch "$@"

