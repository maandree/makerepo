## Changelog section

.PHONY: install-changelog
install: install-changelog
install-changelog:
	install -Dm644 CHANGELOG -- "$(DESTDIR)$(PREFIX)$(DATA)/changelogs/$(PKGNAME)"

.PHONY: uninstall-changelog
uninstall: uninstall-changelog
uninstall-changelog:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/changelogs/$(PKGNAME)"

