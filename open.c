#include "command.h"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int fdin = -1;
int fdout = -1;

void openin(char *file)
{
	if (-1 != fdin) {
		if (close(fdin)) {
			perror("close");
			exit(EXIT_FAILURE);
		}
		fdin = -1;
	}

	fdin = open(file, O_RDONLY);
	if (-1 == fdin) {
		perror("open");
		exit(EXIT_FAILURE);
	}

	free(file);
}

void openout(char *file)
{
	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;

	if (-1 != fdout) {
		if (close(fdout)) {
			perror("close");
			exit(EXIT_FAILURE);
		}
		fdout = -1;
	}

	fdout = creat(file, mode);
	if (-1 == fdout) {
		perror("creat");
		exit(EXIT_FAILURE);
	}

	free(file);
}
