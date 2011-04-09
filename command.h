#ifndef _COMMAND_H
#define _COMMAND_H

struct command {
	char **argv, **envp;
};

void issuecmd(char *path, struct command *command);
struct command *firstarg(char *arg);
struct command *lastarg(struct command *command, char *arg);

#endif
