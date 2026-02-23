VERSION=$(shell git rev-parse --short HEAD)
CFLAGS=`pkg-config gstreamer-1.0 gstreamer-app-1.0 srt --cflags` -O2 -Wall -DVERSION=\"$(VERSION)\"
LDFLAGS=`pkg-config gstreamer-1.0 gstreamer-app-1.0 srt --libs`

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  OBJS = belacoder.o
  all: belacoder
else
  LDFLAGS += -ldl
  OBJS = belacoder.o camlink_workaround/camlink.o
  all: submodule belacoder
endif

submodule:
	git submodule init
	git submodule update

belacoder: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f belacoder *.o camlink_workaround/*.o
