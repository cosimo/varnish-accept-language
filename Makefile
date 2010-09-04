#
# Set your language preferences here
#
DEFAULT_LANGUAGE ?= en
SUPPORTED_LANGUAGES ?= bg cs da de en es fi fy hu it ja no pl ru sq sk tr uk vn xx-lol zh-cn

CC=cc
CPP=cpp -C -P -E
DEBUG=
#DEBUG=-g3

all: accept-language accept-language.vcl

accept-language: accept-language.c
	$(CC) -Wall -pedantic $(DEBUG) -o accept-language accept-language.c

accept-language.vcl: Makefile accept-language.c gen_vcl.pl
	./gen_vcl.pl $(DEFAULT_LANGUAGE) $(SUPPORTED_LANGUAGES) < accept-language.c > accept-language.vcl

test:
	prove -I./t -v ./t

clean:
	$(RM) $(shell cat .gitignore)
