
    #@defines
	PREFIX = /usr
	BIN_DIR = $(PREFIX)/bin
	BASH_CDIR = /etc/bash_completion.d
	POLICY_DIR = $(PREFIX)/share/polkit-1/actions
	# set name
	NAME = nosuspend
	VER = 0.01
	# invoke build files
	OBJECTS = $(NAME).c
	BASHCOM = no_suspend
	POLICY = com.ubuntu.pkexec.inhibit.policy

.PHONY : all clean install uninstall 

all : $(NAME)

clean :
	@rm -f $(NAME)
	@echo ". ., clean"

install : all 
	@mkdir -p $(DESTDIR)$(BIN_DIR)
	@mkdir -p $(DESTDIR)$(BASH_CDIR)
	@cp $(NAME) $(DESTDIR)$(BIN_DIR)
	@cp $(BASHCOM) $(BASH_CDIR)
ifeq (,$(wildcard /usr/share/polkit-1/actions/com.ubuntu.pkexec.inhibit.policy))
	@cp $(POLICY) $(POLICY_DIR)
	@systemctl restart polkitd
endif
	@echo ". ., installed"

uninstall :
	@rm -rf $(BIN_DIR)/$(NAME)
	@rm -rf $(BASH_CDIR)/$(BASHCOM)
	@rm -rf $(POLICY_DIR)/$(POLICY)
	@echo ". ., uninstalled"

$(NAME) : $(OBJECTS)
	gcc $(OBJECTS) -o $(NAME)
