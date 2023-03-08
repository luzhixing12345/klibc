# klibc

lib C for linux kernel module

## Usage

### Single function

1. find the function you want in [glibc](https://www.gnu.org/software/libc/manual/html_node/Function-Index.html), such as `strlen`
2. add `k` to the function name, such as `kstrlen`
3. search `kstrlen` in [klibc](.) and copy the code

### Total klibc

**You need to be aware that the module size will be very large in this way, the first way is recommended**

1. copy `klibc/` to your workspace
2. modify your Makefile to make them all linked

   For example your module name is `hello`, and your file is `hellox.c` and `func.c`

   Modify your Makefile like below, then run `make`

   ```Makefile
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
   ```

## Reference

- [glibc](https://www.gnu.org/software/libc/manual/html_node/Function-Index.html)