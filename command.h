#ifndef _COMMAND_H
#define _COMMAND_H

extern int fdin, fdout;

void oomtest(const void *ptr, const char *str);
void openin(char *file);
void openout(char *file);
void issuecmd(char *name, char **argv, char **envp);
int arraylen(char **array);
char **newargv(void);
char **addarg(char **argv, char *arg);
char **newenvp(void);
char **addvar(char **envp, char *var);

#endif
