#include "command.h"

#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int fdin = -1;
int fdout = -1;

static void openin(char *file)
{
	if (-1 != fdin) {
		if (close(fdin)) {
			perror("close");
			exit(EXIT_FAILURE);
		}
		fdin = -1;
	}

	assert(file);
	fdin = open(file, O_RDONLY);
	if (-1 == fdin) {
		perror(file);
		exit(EXIT_FAILURE);
	}
	free(file);
}

static void openout(char *file)
{
	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;

	if (-1 != fdout) {
		if (close(fdout)) {
			perror("close");
			exit(EXIT_FAILURE);
		}
		fdout = -1;
	}

	assert(file);
	fdout = creat(file, mode);
	if (-1 == fdout) {
		perror(file);
		exit(EXIT_FAILURE);
	}
	free(file);
}

void openio(int num, int redir, char *file)
{
	if (OUTPUT == redir)
		openout(file);
	else if (INPUT == redir)
		openin(file);
}
