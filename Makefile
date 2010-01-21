# Language preferences
DEFAULT_LANGUAGE=en
SUPPORTED_LANGUAGES=en es it ja ru zh-cn

CC=cc
DEBUG=
#DEBUG=-g3

all: accept-language accept-language.vcl

accept-language: accept-language.c
	$(CC) -Wall -pedantic $(DEBUG) -o accept-language accept-language.c

accept-language.vcl: Makefile accept-language.c gen_vcl.pl
	./gen_vcl.pl $(DEFAULT_LANGUAGE) $(SUPPORTED_LANGUAGES) > accept-language.vcl

test:
	prove -I./t -v ./t

