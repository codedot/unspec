#ifndef _COMMAND_H
#define _COMMAND_H

struct cmd {
	char **argv, **envp;
};

void oomtest(const void *ptr, const char *str);
void issuecmd(char *path, struct cmd *cmd);
struct cmd *firstarg(char *arg);
struct cmd *lastarg(struct cmd *cmd, char *arg);

#endif
