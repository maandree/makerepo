## Shell-completion section

.PHONY: shell bash fish zsh
all: shell
shell: bash fish zsh

bash: $(PROGRAM).bash-completion
fish: $(PROGRAM).fish-completion
zsh: $(PROGRAM).zsh-completion

$(PROGRAM).%sh-completion: $(COMPLETION_DIR)/$(PROGRAM).auto-completion
	auto-auto-complete $*sh --source "$<" --output "$@"



.PHONY: install-shell install-bash install-fish install-zsh
install: install-shell
install-shell: install-bash install-fish install-zsh

install-bash: bash
	install -d -- "$(DESTDIR)$(PREFIX)$(DATA)/bash-completion/completions"
	install -m644 $(PROGRAM).bash-completion -- "$(DESTDIR)$(PREFIX)$(DATA)/bash-completion/completions/$(COMMAND)"

install-fish: fish
	install -d -- "$(DESTDIR)$(PREFIX)$(DATA)/fish-completion/completions"
	install -m644 $(PROGRAM).fish-completion -- "$(DESTDIR)$(PREFIX)$(DATA)/fish-completion/completions/$(COMMAND).fish"

install-zsh: zsh
	install -d -- "$(DESTDIR)$(PREFIX)$(DATA)/zsh/site-functions"
	install -m644 $(PROGRAM).zsh-completion -- "$(DESTDIR)$(PREFIX)$(DATA)/zsh/site-functions/_$(COMMAND)"



.PHONY: uninstall-shell uninstall-bash uninstall-fish uninstall-zsh
uninstall: uninstall-shell
uninstall-shell: uninstall-bash uninstall-fish uninstall-zsh

uninstall-bash:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/bash-completion/completions/$(COMMAND)"

uninstall-fish:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/fish-completion/completions/$(COMMAND).fish"

uninstall-zsh:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/zsh/site-functions/_$(COMMAND)"



.PHONY: clean-shell clean-bash clean-fish clean-zsh
clean: clean-shell
clean-shell: clean-bash clean-fish clean-zsh

clean-bash:
	-rm -- *.bash-completion

clean-fish:
	-rm -- *.fish-completion

clean-zsh:
	-rm -- *.zsh-completion


