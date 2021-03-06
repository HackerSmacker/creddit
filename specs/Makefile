CC ?= gcc

MAIN := specs-gen

COGUTILS_DIR ?= ../cog-utils

WDIR   := specs-code

JSON := $(sort $(wildcard */*.json))
APIS := $(sort $(patsubst %/, %, $(dir $(JSON))))

DEPS := $(COGUTILS_DIR)/cog-utils.c   \
        $(COGUTILS_DIR)/json-actor.c  \
        $(COGUTILS_DIR)/ntl.c         \
        $(COGUTILS_DIR)/json-string.c \
        $(COGUTILS_DIR)/log.c

# default CFLAGS
CFLAGS  += -O0 -g -Wall -Wno-unused-function -I$(COGUTILS_DIR)

blank :=
define \n

$(blank)
endef

define generate_source
	# Generate source files (specs-code/%/*.c)
	$(foreach VAR, $(JSON), ./$(MAIN) \
	  -c \
	  -o $(patsubst %, $(WDIR)/%, $(VAR:%.json=%.c)) \
	  -i $(filter $(APIS), $(subst /, ,$(dir $(VAR)))).h \
	  $(VAR)$(\n))
endef

define generate_headers
	# Generate header files (specs-code/%/*.h)
	$(foreach VAR, $(JSON), ./$(MAIN) \
	  -h \
	  -o $(patsubst %, $(WDIR)/%, $(VAR:%.json=%.h)) \
	  $(VAR)$(\n))
endef

define generate_headers_amalgamation
	@ rm -rf $(WDIR)/*/one-specs.h
	# Generate single header (specs-code/%/one-specs.h)
	$(foreach VAR, $(JSON), ./$(MAIN) \
	  -O \
	  -a \
	  -o $(patsubst %, $(WDIR)/%, $(dir $(VAR))one-specs.h) \
	  $(VAR)$(\n))
	$(foreach VAR, $(JSON), ./$(MAIN) \
	  -E \
	  -a \
	  -o $(patsubst %, $(WDIR)/%, $(dir $(VAR))one-specs.h) \
	  $(VAR)$(\n))
	$(foreach VAR, $(JSON), ./$(MAIN) \
	  -S \
	  -a \
	  -o $(patsubst %, $(WDIR)/%, $(dir $(VAR))one-specs.h) \
	  $(VAR)$(\n))
	$(foreach VAR, $(JSON), ./$(MAIN) \
	  -F \
	  -a \
	  -o $(patsubst %, $(WDIR)/%, $(dir $(VAR))one-specs.h) \
	  $(VAR)$(\n))
endef

all: $(COGUTILS_DIR) 
	$(MAKE) gen_source gen_headers gen_headers_amalgamation

gen_source: | $(WDIR)
	$(generate_source)

gen_headers: | $(WDIR)
	$(generate_headers)

gen_headers_amalgamation: | $(WDIR)
	$(generate_headers_amalgamation)

$(WDIR): $(APIS) | $(MAIN)
	mkdir -p $(addprefix $(WDIR)/, $(APIS))

$(APIS): ;

$(MAIN): $(MAIN).c $(DEPS)
	$(CC) $(CFLAGS) -o $@ $^ -lm

echo:
	@ echo -e 'JSON: $(JSON)\n'
	@ echo -e 'APIS: $(APIS)\n'
	@ echo -e 'MAIN: $(MAIN)\n'
	@ echo -e 'CFLAGS: $(CFLAGS)\n'
	@ echo -e 'LDFLAGS: $(LDFLAGS)\n'

clean:
	rm -rf $(WDIR) $(MAIN)

.PHONY : all echo clean
