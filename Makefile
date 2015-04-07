LIBS=-lpcre -lcrypto -lm -lpthread
CFLAGS=-ggdb -O3 -Wall -isystem/opt/local/include -D WHITH_PKCS5_PBKDF2_HMAC=1 
OBJS=vanitygen.o oclvanitygen.o oclvanityminer.o oclengine.o keyconv.o pattern.o util.o
PROGS=vanitygen keyconv oclvanitygen oclvanityminer

PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),Darwin)
OPENCL_LIBS=-framework OpenCL
$(CFLAGS)=$(CFLAGS) -D MAVERICKS=1
else
OPENCL_LIBS=-lOpenCL
$(CFLAGS)=$(CFLAGS) -D MAVERICKS=0
endif


most: vanitygen keyconv

all: $(PROGS)

vanitygen: vanitygen.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

oclvanitygen: oclvanitygen.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS)

oclvanityminer: oclvanityminer.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS) -lcurl

keyconv: keyconv.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) $(PROGS) $(TESTS)
