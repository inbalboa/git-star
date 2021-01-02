ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif


install: git-star.sh
	@printf "==> Installing...\n"
	@install -d $(DESTDIR)$(PREFIX)/bin/
	@install -m 777 git-star.sh $(DESTDIR)$(PREFIX)/bin/git-star

uninstall:
	@printf "==> Uninstalling...\n"
	@sudo rm -f $(DESTDIR)$(PREFIX)/bin/git-star

all: install
	
.PHONY: install uninstall all
