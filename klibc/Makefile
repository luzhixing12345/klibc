
rwildcard = $(foreach d, $(wildcard $1*), $(call rwildcard,$d/,$2) \
					$(filter $2, $d))
klibc_SRC_PATH := $(shell pwd)
klibc_SRC_EXT = c
klibc_src := $(call rwildcard, $(klibc_SRC_PATH), %.$(klibc_SRC_EXT))
klibc_obj := $(klibc_src:$(klibc_SRC_EXT)=o)

$(klibc_obj): %.o: %.c

clean:
	@rm -f *.ko *.o *.mod.o *.symvers *.mod.c *.order .*.cmd .cache.mk
