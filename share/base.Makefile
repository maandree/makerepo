PROGRAM = £(PROGRAM)
PKGNAME = £(PROGRAM)
COMMAND = £(PROGRAM)
MANSECTION = £(MANSECTION)
TEXINFO_DIR = info
TEXMAN_DIR = man
MAN_DIR = man
COMPLETION_DIR = .

PREFIX = /usr
DATA = /share
BIN = /bin
SBIN = /sbin
LIB = /lib
LIBEXEC = $(LIB)/$(PKGNAME)
SYSCONF = /etc



.PHONY: all
all:


%.gz: %
	gzip -9c < "$<" > "$@"

%.bz2: %
	bzip2 -9c < "$<" > "$@"

%.xz: %
	xz -e9 < "$<" > "$@"


.PHONY: install
install:

.PHONY: uninstall
uninstall:

.PHONY: clean
clean:
	-rn -r -- bin obj

