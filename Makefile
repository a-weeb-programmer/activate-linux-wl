CFLAGS = -Wall -Wextra
LDFLAGS = -lwayland-client
SRCDIR = ./src
BUILDDIR = ./build
OBJDIR = $(BUILDDIR)/objs
vpath %.c ./src
vpath %.h ./src/include
SRCFILES = main.c \
					 shm.c
HEADERFILES = shm.h
OBJFILES = $(SRCFILES:%.c=$(OBJDIR)/%.o)

all: $(BUILDDIR)/activate-linux

$(BUILDDIR)/activate-linux: $(BUILDDIR) $(OBJFILES) 
	$(CC) $(LDFLAGS) $(OBJFILES) -o $@

$(BUILDDIR) $(OBJDIR):
	mkdir -p $@

$(OBJDIR)/%.o: %.c $(HEADERFILES) | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJDIR) $(BUILDDIR)

.PHONY: all clean
