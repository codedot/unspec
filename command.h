#ifndef _COMMAND_H
#define _COMMAND_H

struct cmd {
	char **argv;
};

void oomtest(const void *ptr, const char *str);
void issuecmd(char *name, struct cmd *cmd);
struct cmd *newcmd(void);
struct cmd *addarg(struct cmd *cmd, char *arg);

#endif
