NAME = net-snmp-lvs-module
VERSION=$(shell cat VERSION)
VERSDIR := $(NAME)-$(VERSION)
TARFILE := $(NAME)-$(VERSION).tar.gz
CC := gcc 
CFLAGS := `net-snmp-config --cflags` -Ilibipvs -I/usr/src/linux/include -Wall -g -fPIC
DEFINES := -DHAVE_NET_IP_VS_H
DLFLAGS := -fPIC -shared -g
LIBS := `net-snmp-config --netsnmp-libs`
LIBIPVS := libipvs/libipvs.a
DLFLAGS := -fPIC -shared -lnl-genl-3  

all: libipvs/libipvs.a lvs.so

$(LIBIPVS):
	make -C libipvs

%.o: %.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

%.so: %.o $(LIBIPVS)
	$(LD) $(DLFLAGS) $(LIBS) -o $@ $< $(LIBIPVS)

clean:
	make -C libipvs clean
	rm -f lvs.o lvs.so

tar: clean
	cd ..; \
	ln -s $(NAME) $(VERSDIR); \
	tar czf $(TARFILE) --exclude CVS --dereference $(VERSDIR); \
	rm $(VERSDIR)
