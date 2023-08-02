SUBFOLDERS = folder-1 folder-2 folder-3

define compile
	echo $(1)
	$(MAKE) -C $(1)
endef

all:  
	$(foreach folder, $(SUBFOLDERS), $(call compile,$(folder)))

clean:
	$(MAKE) clean -C folder-1
	$(MAKE) clean -C folder-2
	$(MAKE) clean -C folder-3
	
