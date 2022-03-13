PREFIX ?= /usr/local
CC     ?= gcc

OBJDIR        := obj
LIBDIR        := lib
SPECS_DIR     := specs
SPECSCODE_DIR := specs-code
COGUTILS_DIR  := cog-utils
COMMON_DIR    := common
THIRDP_DIR    := $(COMMON_DIR)/third-party
EXAMPLES_DIR  := examples
TEST_DIR      := test
ORCADOCS_DIR  := orca-docs

COGUTILS_SRC := $(COGUTILS_DIR)/cog-utils.c        \
                $(COGUTILS_DIR)/json-actor.c       \
                $(COGUTILS_DIR)/json-actor-boxed.c \
                $(COGUTILS_DIR)/json-string.c      \
                $(COGUTILS_DIR)/log.c              \
                $(COGUTILS_DIR)/logconf.c          \
                $(COGUTILS_DIR)/ntl.c

COMMON_SRC   := $(COMMON_DIR)/common.c     \
                $(COMMON_DIR)/work.c       \
                $(COMMON_DIR)/user-agent.c \
                $(COMMON_DIR)/websockets.c

THIRDP_SRC   := $(THIRDP_DIR)/sha1.c           \
                $(THIRDP_DIR)/curl-websocket.c \
                $(THIRDP_DIR)/threadpool.c

SRC  := $(COGUTILS_SRC) $(COMMON_SRC) $(THIRDP_SRC)
OBJS := $(SRC:%.c=$(OBJDIR)/%.o)

# APIs src
REDDIT_SRC  := $(wildcard reddit-*.c $(SPECSCODE_DIR)/reddit/*.c)

# APIs objs
REDDIT_OBJS  := $(REDDIT_SRC:%.c=$(OBJDIR)/%.o)

# API libs
LIBREDDIT  := $(LIBDIR)/libreddit.a

CFLAGS += -std=c99 -O0 -g -pthread -D_XOPEN_SOURCE=600          \
          -I. -I$(COGUTILS_DIR) -I$(COMMON_DIR) -I$(THIRDP_DIR) \
          -DLOG_USE_COLOR

WFLAGS += -Wall -Wextra -pedantic

ifeq (,$(findstring $(CC),stensal-c sfc)) # ifneq stensal-c AND sfc
	CFLAGS  += -fPIC
endif

$(OBJDIR)/$(COGUTILS_DIR)/%.o : $(COGUTILS_DIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<
$(OBJDIR)/$(THIRDP_DIR)/%.o : $(THIRDP_DIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<
$(OBJDIR)/%.o : %.c
	$(CC) $(CFLAGS) $(WFLAGS) -c -o $@ $<

all: | $(SPECSCODE_DIR)
	$(MAKE) reddit

specs_gen: | $(COGUTILS_DIR)
	@ $(MAKE) -C $(SPECS_DIR) clean
	@ $(MAKE) -C $(SPECS_DIR) gen_source gen_headers_amalgamation
	@ rm -rf $(SPECSCODE_DIR)
	mv $(SPECS_DIR)/specs-code $(SPECSCODE_DIR)

cog_utils:
	./scripts/get-cog-utils.sh

examples: all
	@ $(MAKE) -C $(EXAMPLES_DIR)

discord: $(LIBDISCORD) | $(SPECSCODE_DIR)
github: $(LIBGITHUB) | $(SPECSCODE_DIR)
reddit: $(LIBREDDIT) | $(SPECSCODE_DIR)
slack: $(LIBSLACK) | $(SPECSCODE_DIR)

# API libraries compilation
$(LIBREDDIT): $(REDDIT_OBJS) $(OBJS) | $(LIBDIR)
	$(AR) -cqsv $@ $?

$(LIBDIR):
	@ mkdir -p $(LIBDIR)
$(SPECSCODE_DIR):
	@ $(MAKE) specs_gen
$(COGUTILS_DIR):
	@ $(MAKE) cog_utils

$(REDDIT_OBJS): $(OBJS)
$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@ mkdir -p $(OBJDIR)/$(THIRDP_DIR)                                 \
	           $(OBJDIR)/$(COGUTILS_DIR)                               \
	           $(addprefix $(OBJDIR)/, $(wildcard $(SPECSCODE_DIR)/*))

install:
	@ mkdir -p $(PREFIX)/lib/
	@ mkdir -p $(PREFIX)/include/orca
	install -d $(PREFIX)/lib/
	install -d $(PREFIX)/include/orca/
	install -m 644 *.h $(COGUTILS_DIR)/*.h $(COMMON_DIR)/*.h             \
	               $(THIRDP_DIR)/*.h $(PREFIX)/include/orca/

echo:
	@ echo -e 'CC: $(CC)\n'
	@ echo -e 'PREFIX: $(PREFIX)\n'
	@ echo -e 'CFLAGS: $(CFLAGS)\n'
	@ echo -e 'OBJS: $(OBJS)\n'
	@ echo -e 'SPECS DIRS: $(wildcard $(SPECSCODE_DIR)/*)\n'

clean: 
	rm -rf $(OBJDIR)
	rm -rf $(LIBDIR)
	@ $(MAKE) -C $(EXAMPLES_DIR) clean

purge: clean
	rm -rf $(LIBDIR)
	rm -rf $(COGUTILS_DIR)
	rm -rf $(SPECSCODE_DIR)

docs: | $(ORCADOCS_DIR)
	@ $(MAKE) -C $(SPECS_DIR) clean
	@ $(MAKE) -C $(SPECS_DIR) gen_headers
	@ rm -rf $(SPECSCODE_DIR)
	@ mv $(SPECS_DIR)/specs-code $(SPECSCODE_DIR)

$(ORCADOCS_DIR):
	git clone https://github.com/cog-studio/orca-docs
	cp $(ORCADOCS_DIR)/Doxyfile Doxyfile

.PHONY: all test examples install echo clean purge docs
