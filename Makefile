MODULE_NAME = hello
FILES = hellox.c func.c

# klibc modification
rwildcard = $(foreach d, $(wildcard $1*), $(call rwildcard,$d/,$2) \
					$(filter $2, $d))
klibc_SRC_PATH = $(M)/klibc
klibc_src = $(call rwildcard, $(klibc_SRC_PATH), %.c)
klibc_o = $(klibc_src:c=o)
klibc_obj = $(subst $(M)/,,$(klibc_o))
# end

MODULE_OBJS = $(FILES:c=o) $(klibc_obj)
ifneq ($(KERNELRELEASE),)
obj-m := $(MODULE_NAME).o
$(MODULE_NAME)-objs := $(MODULE_OBJS)
else
KDIR := /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)
all:
	make -C klibc
	make -C $(KDIR) M=$(PWD) modules 
clean:
	$(MAKE) -C klibc clean
	@rm -f *.ko *.o *.mod.o *.symvers *.mod.c *.order .*.cmd .cache.mk
	@echo "finish clean"
endif
