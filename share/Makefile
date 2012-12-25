# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]

SHELL=bash

NODES=3

VERSION := 0.999

all: OPTIMISE ?= -O3
OPTIMISE ?= -O0
CPPFLAGS ?= -DDEBUG
CXXFLAGS ?= $(OPTIMISE) -g -std=gnu++11 -pedantic -W{all,extra} -iquotedir=src/
CFLAGS ?= $(OPTIMISE) -g -std=gnu++11 -pedantic -W{all,extra} -iquotedir=src/
LDFLAGS ?=

PROGRAM=??????????????
EXEC=bin/$(PROGRAM)
BOOK=$(PROGRAM)
BOOKDIR=doc/
LANG=en_GB-ise-w_accents-only

LEAKS=full
LOST=yes
RESOLUTION=high
REACHABLE=yes
UNDEF=yes
ORIGINS=yes
PARTIAL_OK=no
X_MEMCHECK=
USE_MEMCHECK=1

CACHE=yes
BRANCH=yes
X_CACHEGRIND=
USE_CACHEGRIND=0

X_CALLGRIND=
USE_CALLGRIND=0
X_HELGRIND=
USE_HELGRIND=0
X_DRD=
USE_DRD=0
X_MASSIF=
USE_MASSIF=0
X_SGCHECK=
USE_SGCHECK=0
X_LACKEY=
USE_LACKEY=0

STRIP=
install-strip: STRIP = -s

DESTDIR=
PREFIX=/usr
GAMEDIR=/game
BINDIR=/bin
LIBDIR=/lib
LIBEXECDIR=/libexec
DATADIR=/share
DOCDIR=/doc
INFODIR=$(DATADIR)/info
SYSCONFDIR=/etc
prefix=$(PREFIX)
gamedir=$(GAMEDIR)
bindir=$(BINDIR)
libdir=$(LIBDIR)
libexecdir=$(LIBEXECDIR)
datadir=$(DATADIR)/$(PROGRAM)
docdir=$(DOCDIR)/$(PROGRAM)
infodir=$(INFODIR)
sysconfdir=$(SYSCONFDIR)

TAGSFLAGS=
TAGSFLAGS_C=
TAGSFLAGS_H=
TAGSFLAGS_CPP=
TAGSFLAGS_CC=
TAGSFLAGS_HPP=
TAGSFLAGS_PY=
TAGSFLAGS_JAVA=
TAGSFLAGS_PL=
TAGSFLAGS_SH=
TAGSFLAGS_LUA=
TAGSFLAGS_TEXI=
TAGSFLAGS_MAKE=
CPP_LANG=c

SOURCE :=
SOURCE += $(shell find src | grep \\.cc\$$  | sort)
SOURCE += $(shell find src | grep \\.c\$$   | sort)
SOURCE += $(shell find src | grep \\.h\$$   | sort)
SOURCE += $(shell find src | grep \\.hpp\$$ | sort)

TEST :=
TEST += $(shell find test | grep \\.cc\$$   | sort)
TEST += $(shell find test | grep \\.c\$$    | sort)
TEST += $(shell find test | grep \\.h\$$    | sort)
TEST += $(shell find test | grep \\.hpp\$$  | sort)
TEST += $(shell find test | grep \\.text\$$ | sort)

OBJS := $(shell (diff                                                                                                             \
	<(      find  src | grep -v '~$$'                     | grep '\.c' | sed -e 's/\.c$$//g' | sed -e 's/\.cc$$//g'  | sort)  \
	<(diff <(find src | grep -v '~$$'                     | grep '\.c' | sed -e 's/\.c$$//g' | sed -e 's/\.cc$$//g'  | sort)  \
	       <(find src | grep -v '~$$' | grep -v '\.gch$$' | grep '\.h' | sed -e 's/\.h$$//g' | sed -e 's/\.hpp$$//g' | sort)  \
	       | sed -e 's/>/</g' | grep '^< ' | sed -e 's/< //g' | sort)                                                         \
	| grep '^< ' | sed -e 's/^< //g' | sed -e 's/^src\///g' -e 's/$$/\.o/g') || echo -n)

GCHS :=
GCHS += $(shell find src | grep '\.hpp$$' | sort | sed -e 's/$$/\.gch/g')
GCHS += $(shell find src | grep '\.h$$'   | sort | sed -e 's/$$/\.gch/g')

MISC_FILES=compiledependencies COPYING LICENSE Makefile __order tools/paramake.py tools/vargen.py

AR_FILES=$(SOURCE) $(TEST) $(MISC_FILES)


## BUILD BINARIES ##

# DEFAULT
all: parallel tests info pdf
.PHONY: all


$(EXEC) program: src/program.cc $(OBJS)
	@echo -e "\e[01;35m$(EXEC)\e[0m";
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o "$(EXEC)" -- $^

program.sa: src/program.cc
	@echo -e "\e[01;35m$(EXEC)\e[0m";
	$(Q)[ ! -d bin ] ||  mkdir bin
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o "$(EXEC)" -- $^ $(OBJS)

all-at-once: $(SOURCE)
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o "$(EXEC)" -- $^

.PHONY: parallel
parallel: parallel. program
parallel.:
	$(Q)if [ ! -d  bin ]; then  mkdir bin;  fi
	$(Q)if [   -f .tmp ]; then  rm   .tmp;  fi
	$(Q)((time ((echo $(NODES) ; cat compiledependencies __order) |                                     \
	        (tools/paramake.py OPTIMISE="$(OPTIMISE)" CPPFLAGS="$(CPPFLAGS)" ; echo $$? > .tmp))) |&    \
	sed -e 's/$$/\x1b\[0m/g' -e 's/^real\x09/\x1b\[2mreal\x09/g'                                        \
	-e 's/^user\x09/\x1b\[2muser\x09/g' -e 's/^sys\x09/\x1b\[2msys\x09/g'                               \
	-e 's/^make\[1\]: Entering directory /\x1b\[2mmake\[1\]: Entering directory /g'                     \
	-e 's/^make\[1\]: Leaving directory /\x1b\[2mmake\[1\]: Leaving directory /g') ; exit $$(cat .tmp)

.PHONY: sequencial
sequencial: sequencial. program
sequencial.:
	$(Q)if [ ! -d bin ]; then  mkdir bin;  fi
	$(Q)cat compiledependencies __order | sort | uniq | tsort | tac > .tmp1
	$(Q)ls -1 --color=no src/ | grep \\.hpp\$ | sed -e s/\\.hpp\$//g | sort > .tmp
	$(Q)$(SHELL) -c 'diff <(sort < .tmp1 | uniq) .tmp > .tmp2 || echo -n'
	$(Q)((grep '> ' < .tmp2 | sed -e 's/> //g') ; cat .tmp1) > .tmp
	$(Q)time (count=$$(cat .tmp | wc -l);                                                         \
	index=0;                                                                                      \
	cat .tmp | while read file; do                                                                \
	    (( index++ ));                                                                            \
	    echo -e '\033[01;34m'"$$file"' ('$$index'/'$$count')\033[21;39m';                         \
	    if [ -f "src/$$file.c" ]; then                                                            \
	        make OPTIMISE="$(OPTIMISE)" CPPFLAGS="$(CPPFLAGS)" "$$file.o" || exit 100;            \
	    elif [ -f "src/$$file.cc" ]; then                                                         \
	        make OPTIMISE="$(OPTIMISE)" CPPFLAGS="$(CPPFLAGS)" "$$file.o" || exit 100;            \
	    elif [ -f "src/$$file.hpp" ]; then                                                        \
	        make OPTIMISE="$(OPTIMISE)" CPPFLAGS="$(CPPFLAGS)" "src/$$file.hpp.gch" || exit 100;  \
	    else                                                                                      \
	        make OPTIMISE="$(OPTIMISE)" CPPFLAGS="$(CPPFLAGS)" "src/$$file.h.gch" || exit 100;    \
	    fi;                                                                                       \
	done)


## BUILD C++ ##

%.o src/%.hpp.gch: src/%.cc src/%.hpp
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)[ -e "/dev/shm/$(PROGRAM)" ] ||  mkdir "/dev/shm/$(PROGRAM)"
	$(Q)if [ ! -L "src/$*.hpp.gch" ]; then                                \
	      if [ -e "src/$*.hpp.gch" ]; then  $(RM) "src/$*.hpp.gch";  fi;  \
	      ln -s "/dev/shm/$(PROGRAM)/$*.hpp.gch" "src/$*.hpp.gch";        \
	    fi
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -c -- $^

%.o: src/%.cc
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -c -- $^

src/%.hpp.gch: src/%.hpp
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)[ -e "/dev/shm/$(PROGRAM)" ] ||  mkdir "/dev/shm/$(PROGRAM)"
	$(Q)if [ ! -L "$@" ]; then                       \
	      if [ -e "$@" ]; then  $(RM) "$@";  fi;   \
	      ln -s "/dev/shm/$(PROGRAM)/$*.hpp.gch" "$@";  \
	    fi
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -c -- $^


## BUILD C ##

%.o src/%.h.gch: src/%.c src/%.h
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)[ -e "/dev/shm/$(PROGRAM)" ] ||  mkdir "/dev/shm/$(PROGRAM)"
	$(Q)if [ ! -L "src/$*.h.gch" ]; then                              \
	      if [ -e "src/$*.h.gch" ]; then  $(RM) "src/$*.h.gch";  fi;  \
	      ln -s "/dev/shm/$(PROGRAM)/$*.h.gch" "src/$*.h.gch";             \
	    fi
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -c -- $^

%.o: src/%.c
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)time $(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -c -- $^

src/%.h.gch: src/%.h
	$(Q)[ -d bin ] ||  mkdir bin
	$(Q)[ -e "/dev/shm/$(PROGRAM)" ] ||  mkdir "/dev/shm/$(PROGRAM)"
	$(Q)if [ ! -L "$@" ]; then                      \
	      if [ -e "$@" ]; then  $(RM) "$@";  fi;  \
	      ln -s "/dev/shm/$(PROGRAM)/$*.h.gch" "$@";   \
	    fi
	$(Q)time $(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -c -- $^


## BASIC INSTALLATION AND UNINSTALLATION METHODS ##

.PHONY: install
install: install-bin

.PHONY: install-strip
install-strip: install-bin

.PHONY: install-info
install-info: $(BOOK).info.gz
	$(Q)install -d -- "$(DESTDIR)$(prefix)$(infodir)"
	$(Q)install -m 644 -- "$(BOOK).info.gz" "$(DESTDIR)$(prefix)$(infodir)"

.PHONY: installdirs
installdirs:
	$(Q)[ "$(DESTDIR)" = "" ] || install -d -- "$(DESTDIR)"
	$(Q)install -d -- "$(DESTDIR)$(prefix)"
	$(Q)install -d -- "$(DESTDIR)$(prefix)$(gamedir)"
	$(Q)install -d -- "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: uninstalldirs
uninstalldirs: uninstalldir/$(prefix)$(gamedir)  \
	       uninstalldir/$(prefix)$(docdir)

uninstall/%:
	$(Q)[ ! -f "$*" ] || $(RM) -- "$(DESTDIR)$*"

uninstalldir/%:
	$(Q)[ ! -d "$*" ] || \
	  [ ! $$(ls -A1 -- "$*" | wc -l) = 0 ] || \
	    rmdir -- "$*"

.PHONY: uninstalldoc
uninstalldoc: \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).dvi       \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).ps        \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).pdf       \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).dvi.gz    \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).ps.gz     \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).pdf.gz    \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).dvi.xz    \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).ps.xz     \
	uninstall/$(prefix)$(docdir)/$(PROGRAM).pdf.xz    \
	uninstall/$(prefix)$(infodir)/$(PROGRAM).info     \
	uninstall/$(prefix)$(infodir)/$(PROGRAM).info.gz  \
	uninstall/$(prefix)$(infodir)/$(PROGRAM).info.xz  \
	uninstalldir/$(prefix)$(docdir)


## INSTALL GRAPHICAL DOCUMENTATION ##

.PHONY: install-dvi
install-dvi: $(BOOK).dvi
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-ps
install-ps: $(BOOK).ps
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-pdf
install-pdf: $(BOOK).pdf
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-dvi.gz
install-dvi.gz: $(BOOK).dvi.gz
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-ps.gz
install-ps.gz: $(BOOK).ps.gz
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-pdf.gz
install-pdf.gz: $(BOOK).pdf.gz
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-dvi.xz
install-dvi.xz: $(BOOK).dvi.xz
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-ps.xz
install-ps.xz: $(BOOK).ps.xz
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"

.PHONY: install-pdf.xz
install-pdf.xz: $(BOOK).pdf.xz
	$(Q)install -m 644 -- "$<" "$(DESTDIR)$(prefix)$(docdir)"


## MAKE DOCUMENTATION ##

info: $(BOOK).info.gz
%.info: $(BOOKDIR)%.texinfo
	$(Q)$(MAKEINFO) "$<"
%.info.gz: %.info
	$(Q)gzip -9c < "$<" > "$@"

pdf: $(BOOK).pdf
%.pdf: $(BOOKDIR)%.texinfo 
	$(Q)texi2pdf "$<"
	$(Q)make clean-tex clean.bak-

pdf.gz: $(BOOK).pdf.gz
%.pdf.gz: %.pdf
	$(Q)gzip -9c < "$<" > "$@"

pdf.xz: $(BOOK).pdf.xz
%.pdf.xz: %.pdf
	$(Q)xz -e9 < "$<" > "$@"

dvi: $(BOOK).dvi
%.dvi: $(BOOKDIR)%.texinfo 
	$(TEXI2DVI) "$<"
	$(Q)make clean-tex clean.bak-

dvi.gz: $(BOOK).dvi.gz
%.dvi.gz: %.dvi
	$(Q)gzip -9c < "$<" > "$@"

dvi.xz: $(BOOK).dvi.xz
%.dvi.xz: %.dvi
	$(Q)xz -e9 < "$<" > "$@"


## MODIFY DOCUMENTATION ##

.PHONY: soft
soft: ; $(Q)pdfjam --pagecolor 249,249,249 -o "$(BOOK).pdf" -- "$(BOOK).pdf"

.PHONY: softer
softer: ; $(Q)pdfjam --pagecolor 249,246,240 -o "$(BOOK).pdf" -- "$(BOOK).pdf"


## FIND SPELLING AND GRAMMAR ERRORS ##

.PHONY: spell
spell: ; $(Q)aspell --lang="$(LANG)" check -- "$(BOOKDIR)$(BOOK).texinfo"

.PHONY: grammar
grammar: ; $(Q)link-parser < "$(BOOK).texinfo" 2>&1 | sed -e  \
	   s/'No complete linkages found'/'\x1b[1;31mNo complete linkage found\x1b[m'/g | less -r


## EXECUTE PROGRAM ##

.PHONY: run
run: $(EXEC) ; $(Q)"$(EXEC)"


## TESTING AND DEBUGGING WITH VALGRIND ##

.PHONY: valgrind
valgrind: valgrind-memcheck valgrind-cachegrind valgrind-callgrind \
	  valgrind-helgrind valgrind-drd valgrind-massif           \
	  valgrind-sgcheck valgrind-lackey

.PHONY: valgrind-memcheck
valgrind-memcheck: $(EXEC)
	[ ! $(USE_MEMCHECK) = 1 ] || \
	valgrind --tool=memcheck --leak-check=$(LEAKS) --show-possibly-lost=$(LOST)  \
	         --leak-resolution=$(RESOLUTION) --show-reachable=$(REACHABLE)       \
	         --undef-value-errors=$(UNDEF) --track-origins=$(ORIGINS)            \
	         --partial-loads-ok=$(PARTIAL_OK) $(X_MEMCHECK) -- "$(EXEC)"

.PHONY: valgrind-cachegrind
valgrind-cachegrind: $(EXEC)
	[ ! $(USE_CACHEGRIND) = 1 ] || \
	valgrind --tool=cachegrind --cache-sim=$(CACHE) --branch-sim=$(BRANCH) $(X_CACHEGRIND) -- "$(EXEC)"

.PHONY: valgrind-callgrind
valgrind-callgrind: $(EXEC)
	[ !$(USE_CALLGRIND) = 1 ] || \
	valgrind --tool=callgrind $(X_CALLGRIND) -- "$(EXEC)"

.PHONY: valgrind-helgrind
valgrind-helgrind: $(EXEC)
	[ ! $(USE_HELGRIND) = 1 ] || \
	valgrind --tool=helgrind $(X_HELGRIND) -- "$(EXEC)"

.PHONY: valgrind-drd
valgrind-drd: $(EXEC)
	[ ! $(USE_DRD) = 1 ] ||  \
	valgrind --tool=drd $(X_DRD) -- "$(EXEC)"

.PHONY: valgrind-massif
valgrind-massif: $(EXEC)
	[ ! $(USE_MASSIF) = 1 ] || \
	valgrind --tool=massif $(X_MASSIF) -- "$(EXEC)"

.PHONY: valgrind-sgcheck
valgrind-sgcheck: $(EXEC)
	[ ! $(USE_SGCHECK) = 1 ] || \
	valgrind --tool=sgcheck $(X_SGCHECK) -- "$(EXEC)"

.PHONY: valgrind-lackey
valgrind-lackey: $(EXEC)
	[ ! $(USE_LACKEY) = 1 ] || \
	valgrind --tool=lackey $(X_LACKEY) -- "$(EXEC)"


## CLEANING ##

.PHONY: maintainer-clean
maintainer-clean: clean

.PHONY: distclean realclean clobber
distclean: realclean
realclean: clobber
clobber: clean

.PHONY: mostlyclean
mostlyclean: clean-bak clean.bak- clean-doc clean-tex clean-doc

.PHONY: clean
clean: mostlyclean clean-bin

.PHONY: clean-bak
clean-bak: clean.cpio- clean.cpio.gz- clean.cpio.xz- clean.cpio.bz2-  \
	   clean.shar- clean.shar.gz- clean.shar.xz- clean.shar.bz2-  \
	   clean.tar-  clean.tar.gz-  clean.tar.xz-  clean.tar.bz2-   \
	   clean.ar-   clean.ar.gz-   clean.ar.xz-   clean.ar.bz2-

.PHONY: clean-bin
clean-bin: clean.a- clean.a.gz- clean.a.xz- clean.a.bz2- clean.o- clean.gch- clean.out-
	@echo -e 'Cleaning \e[35mbin\e[m'
	$(Q)if [ -d "bin" ]; then  $(RM) -r "bin";  fi
	$(Q)find ./test | grep -v '\.cc$$' | grep -v '\.text$$' | while read file; do  \
	    if [ -L "$$file" ]; then  file="$$(realpath -- "$$file")";  fi;            \
	    if [ -f "$$file" ]; then  $(RM) "$$file";  fi;                             \
	done

.PHONY: clean-tmp
clean-doc:
	@echo -e 'Cleaning \e[35mtmp\e[m'
	$(Q)[ ! -f "$$(realpath -- ".tmp")" ] ||  $(RM)    -- "$$(realpath -- ".tmp")"
	$(Q)[ ! -d "$$(realpath -- ".tmp")" ] ||  $(RM) -r -- "$$(realpath -- ".tmp")"

.PHONY: clean-doc
clean-doc: clean.ps-    clean.pdf-    clean.dvi-    clean.info-     \
	   clean.ps.gz- clean.pdf.gz- clean.dvi.gz- clean.info.gz-  \
	   clean.ps.xz- clean.pdf.xz- clean.dvi.xz- clean.info.xz-

.PHONY: clean-tex
clean-tex: clean.t2d- clean.aux- clean.cp-  clean.cps- clean.fn-  \
	   clean.ky-  clean.log- clean.pg-  clean.pgs- clean.toc- \
	   clean.tp-  clean.vr-  clean.vrs- clean.op-  clean.ops-

.PHONY: clean.%-
clean.%-:
	@echo -e 'Cleaning \e[34m.$*\e[m'
	$(Q)find ./ | grep '\.$*$$' | while read file; do            \
	    ( [ ! -L "$$file" ] ||  file="$$(realpath "$$file")" );  \
	    ( [ ! -f "$$file" ] ||  $(RM)    -- "$$file" );          \
	    ( [ ! -d "$$file" ] ||  $(RM) -r -- "$$file" );          \
	done

.PHONY: clean.%
clean.%: clean.%-

.PHONY: clean/%
clean/%:
	@echo -e 'Cleaning \e[36m$*\e[m'
	$(Q)[ ! -f     "$*.pyc"      ] ||  $(RM) --     "$*.pyc"
	$(Q)[ ! -f     "$*.o"        ] ||  $(RM) --     "$*.o"
	$(Q)[ ! -f "src/$*.h.gch"    ] ||  $(RM) -- "src/$*.h.gch"
	$(Q)[ ! -f "src/$*.hpp.gch"  ] ||  $(RM) -- "src/$*.hpp.gch"
	$(Q)[ ! -e "/dev/shm/$(PROGRAM)/$*.h.gch"    ] ||  $(RM) -- "/dev/shm/$(PROGRAM)/$*.h.gch"
	$(Q)[ ! -e "/dev/shm/$(PROGRAM)/$*.hpp.gch"  ] ||  $(RM) -- "/dev/shm/$(PROGRAM)/$*.hpp.gch"


## VIEW PDF DOCUMENTATION ##

.PHONY: view
view: $(BOOK).pdf
	$(Q)if [ ! "$$PDF_VIEWER" = '' ]; then  \
	    "$$PDF_VIEWER" -- "$<";             \
	else                                    \
	    xpdf -- "$<";                       \
	fi

.PHONY: atril
atril: $(BOOK).pdf ; $(Q)atril -- "$<"

.PHONY: evince
evince: $(BOOK).pdf ; $(Q)evince -- "$<"

.PHONY: xpdf
xpdf: $(BOOK).pdf ; $(Q)xpdf -- "$<"

.PHONY: okular
okular: $(BOOK).pdf ; $(Q)okular -- "$<"

.PHONY: gs
gs: $(BOOK).pdf ; $(Q)gs -- "$<"

.PHONY: jfbview
jfbview: $(BOOK).pdf
	$(Q)jfbview -- "$<"
	$(Q)echo -en '\e[H\e[2J'


## TAG FOR EDITORS ##

.PHONY: TAGS
TAGS:
	$(Q)find ./ | grep    '\.c$$'       | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_C)    --language=c --
	$(Q)find ./ | grep    '\.h$$'       | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_H)    --language=c --
	$(Q)find ./ | grep    '\.cpp$$'     | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_CPP)  --language=$(CPP_LANG) --
	$(Q)find ./ | grep    '\.cc$$'      | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_CC)   --language=c++ --
	$(Q)find ./ | grep    '\.hpp$$'     | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_HPP)  --language=c++ --
	$(Q)find ./ | grep    '\.py$$'      | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_PY)   --language=python --
	$(Q)find ./ | grep    '\.jav$$'     | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_JAVA) --language=java --
	$(Q)find ./ | grep    '\.java$$'    | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_JAVA) --language=java --
	$(Q)find ./ | grep    '\.pl$$'      | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_PL)   --language=perl --
	$(Q)find ./ | grep    '\.lua$$'     | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_LUA)  --language=lua --
	$(Q)find ./ | grep    '\.texinfo$$' | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_TEXI) --language=texinfo --
	$(Q)find ./ | grep    '\.texi$$'    | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_TEXI) --language=texinfo --
	$(Q)find ./ | grep    '\.sh$$'      | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_SH)   --language=shell-script --
	$(Q)find ./ | grep -i 'makefile$$'  | xargs -d \\n -r etags $(TAGSFLAGS) $(TAGSFLAGS_MAKE) --language=gnumakefile --


## PRINT SOURCE LINE COUNT ##

.PHONY: LINES
LINES:
	$(Q)(find .) | \
	egrep '\.(cc|hpp|c|h|cpp|py|jav|sh|java|lua|texinfo|texi)$$' | \
	xargs cat -- Makefile | \
	wc -l


## FILE NAME PRINTING ##

.PHONY: echo-src
echo-src:
	@echo -- "$(SOURCE)"

.PHONY: echo-test
echo-test:
	@echo -- "$(TEST)"

.PHONY: echo-obj
echo-obj:
	@echo -- "$(OBJS)"

.PHONY: echo-gch
echo-gch:
	@echo -- "$(GCHS)"

.PHONY: print
print: $(SOURCE)
	$(Q)for file in $?; do  echo -- "$$file";  done


## CREATE ARCHIVES ##

ar: $(PROGRAM).a($(OBJS))
$(PROGRAM).a($(OBJS)):
	$(Q)$(AR) rcs "$@" "$%"

.PHONY: $(PROGRAM).tar
tar: $(PROGRAM).tar
$(PROGRAM).tar:
	$(Q)tar -c -- $(AR_FILES) > "$@"

tar.gz: $(PROGRAM).tar.gz
$(PROGRAM).tar.gz: $(PROGRAM).tar
	$(Q)gzip -9c < "$<" > "$@"

tar.xz: $(PROGRAM).tar.xz
$(PROGRAM).tar.xz: $(PROGRAM).tar
	$(Q)xz -e9 < "$<" > "$@"

.PHONY: $(PROGRAM).shar
shar: $(PROGRAM).shar
$(PROGRAM).shar:
	$(Q)shar -- $(AR_FILES) > "$@"

.PHONY: dist
dist: $(PROGRAM)-$(VERSION).tar.xz
$(PROGRAM)-$(VERSION).tar.xz:
	$(Q)tar -c -- $(AR_FILES) | xz -e9 > "$@"


#### SHOULD BE CUSTOMISED ####


## TESTING ##

.PHONY: installcheck
installcheck:
	@echo Not implemented

.PHONY: test check
check: test
test:
	@echo 'Not yet implemented'


## INSTALLING AND UNINSTALLING ##

.PHONY: install-bin
install-bin: $(EXEC) installdirs install-pdf.gz install-info
	$(Q)install -m 755 $(STRIP) -- "$(EXEC)" "$(DESTDIR)$(prefix)$(bindir)"

.PHONY: install-html
install-html:
	@echo Not implemented  FIXME

.PHONY: uninstall
uninstall: uninstalldirs uninstalldoc             \
	uninstall/$(prefix)$(bindir)/$(PROGRAM)


## MAKE TESTS

test/%: test/%.cc $(OBJS)
	@echo -e "\e[01;34m$@\e[0m";
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o "$@" -- $^

test/%.sa: test/%.cc
	@echo -e "\e[01;34mtest/$*\e[0m";
	$(Q)time $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o test/"$*" -- $^ $(OBJS)

test/%: test/%.c $(OBJS)
	@echo -e "\e[01;34m$@\e[0m";
	$(Q)time $(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o "$@" -- $^

test/%.sa: test/%.c
	@echo -e "\e[01;34mtest/$*\e[0m";
	$(Q)time $(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o test/"$*" -- $^ $(OBJS)

.PHONY: tests
tests:
	$(Q)ls -1 --color=no test | grep '\.cc$$' | sed -e 's/\.cc$$//g' |  \
	while read test; do                                                 \
	    make test/"$$test";                                             \
	done
	$(Q)ls -1 --color=no test | grep '\.c$$' | sed -e 's/\.c$$//g' |  \
	while read test; do                                               \
	    make test/"$$test";                                           \
	done
