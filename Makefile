GIT=git

.PHONY: default git-submodules

default: git-submodules

git-submodules:
	$(GIT) submodule update --init
