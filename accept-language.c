/*
 * Accept-language header normalization
 *
 * Cosimo, 21/01/2010
 *
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h> /* qsort */

#define DEFAULT_LANGUAGE "en"
#define SUPPORTED_LANGUAGES ":bg:cs:da:en:fi:fy:hu:it:ja:no:pl:ru:tr:uk:xx-lol:vn:zh-cn:"

#define vcl_string char
#define LANG_LIST_SIZE 10
#define LANG_MAXLEN 10
#define RETURN_LANG(x) { \
    strncpy(lang, x, LANG_MAXLEN); \
    return; \
}
#define RETURN_DEFAULT_LANG RETURN_LANG(DEFAULT_LANGUAGE)
#define PUSH_LANG(x,y) { \
    pl[curr_lang].lang = x;    \
    pl[curr_lang].q = y;       \
    curr_lang++;               \
}

struct lang_list {
    vcl_string *lang;
    float q;
};

/* Checks if a given language is in the static list of the ones we support */
int is_supported(vcl_string *lang) {
    vcl_string *supported_languages = SUPPORTED_LANGUAGES;
    vcl_string match_str[LANG_MAXLEN + 3] = "";  /* :, :, \0 = 3 */
    int is_supported = 0;

    /* Search ":<lang>:" in supported languages string */
    strncpy(match_str, ":", 1);
    strncat(match_str, lang, LANG_MAXLEN);
    strncat(match_str, ":\0", 2);

    if (strstr(supported_languages, match_str)) {
        is_supported = 1;
    }

    return is_supported;
}

/* Used by qsort() below */
int sort_by_q(const void *x, const void *y) {
    struct lang_list *a = (struct lang_list *)x;
    struct lang_list *b = (struct lang_list *)y;
    if (a->q > b->q) return -1;
    if (a->q < b->q) return 1;
    return 0;
}

/* Reads Accept-Language, parses it, and finds the first match
   among the supported languages. In case of no match,
   returns the default language.
*/
void select_language(const vcl_string *incoming_header, char *lang) {

    struct lang_list pl[LANG_LIST_SIZE];
    vcl_string *lang_tok = NULL;
    vcl_string *header;
    vcl_string *pos = NULL;
    vcl_string *q_spec = NULL;
    unsigned int curr_lang = 0, i = 0;
    float q;

    /* Empty string, return default language immediately */
    if (! incoming_header || (0 == strcmp(incoming_header, ""))) {
        RETURN_DEFAULT_LANG;
    }

    /* Tokenize Accept-Language */
    header = (vcl_string *) incoming_header;

    while ((lang_tok = strtok_r(header, " ,", &pos))) {
        q = 1.0;
        if ((q_spec = strstr(lang_tok, ";q="))) {
            /* Truncate language name before ';' */
            *q_spec = '\0';
            /* Get q value */
            sscanf(q_spec + 3, "%f", &q);
        }
        /* Wildcard language '*' should be last in list */
        if ((*lang_tok) == '*') q = 0.0;
        /* Push in the prioritized list */
        PUSH_LANG(lang_tok, q);
        /* For strtok_r() to proceed from where it left off */
        header = NULL;
        /* Break out if stored max no. of languages */
        if (curr_lang >= LANG_MAXLEN) break;
    }

    /* Sort by priority */
    qsort(pl, curr_lang, sizeof(struct lang_list), &sort_by_q);

    /* Match with supported languages */
    for (i = 0; i < curr_lang; i++) {
        if (! is_supported(pl[i].lang)) continue;
        RETURN_LANG(pl[i].lang);
    }

    RETURN_DEFAULT_LANG;
}

int main(int argc, char **argv) {
    vcl_string lang[LANG_MAXLEN] = "";
    if (argc != 2 || ! argv[1]) {
        strncpy(lang, "en", 2);
    }
    else {
        select_language(argv[1], lang);
    }
    printf("%s\n", lang);
    return 0;
}

/* vim: syn=c ts=4 et sts=4 sw=4 tw=0
*/
