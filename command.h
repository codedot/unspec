#ifndef _COMMAND_H
#define _COMMAND_H

struct command {
	char **argv, **envp;
};

void cmdname(char *path);
void firstarg(char *arg);
void lastarg(char *arg);

#endif
