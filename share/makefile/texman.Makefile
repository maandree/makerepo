## Texman manpage msection

.PHONY: doc
all: doc
doc: man

.PHONY: man
man: $(PROGRAM).$(MANSECTION).gz

%.$(MANSECTION): $(TEXMAN_DIR)/%.texman:
	texman < "$<" > "$@"

.PHONY: install-man
install: install-man
install-man: $(PROGRAM).$(MANSECTION).gz
	install -Dm644 "$<" -- "$(DESTDIR)$(PREFIX)$(DATA)/man/man$(MANSECTION)/$(COMMAND).$(MANSECTION).gz"

.PHONY: uninstall-man
uninstall: uninstall-man
uninstall-man:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/man/man$(MANSECTION)/$(COMMAND).$(MANSECTION).gz"

.PHONY: clean-man
clean: clean-man
clean-man:
	-rm -- *.$(MANSECTION){,.gz,.bz2,.xz}

