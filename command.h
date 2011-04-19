#ifndef _COMMAND_H
#define _COMMAND_H

enum {
	INPUT, OUTPUT, APPEND, FORCEOUT, INOUTPUT,
	HEREDOC, HEREIND, DUPIN, DUPOUT
};

extern int fdin, fdout;

int veclen(char **vec);
void oomtest(const void *ptr, const char *str);
char *copyword(const char *word);

char **newargv(void);
char **addarg(char **argv, char *arg);
char **newenvp(void);
char **addvar(char **envp, char *var);

void openio(int num, int redir, char *file);

void issuecmd(char *name, char **argv, char **envp);

#endif
