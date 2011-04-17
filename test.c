#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	char buf[BUFSIZ];
	extern char **environ;
	int i;

	for (i = 0; environ[i]; i++)
		printf("environ[%d] == %s\n", i, environ[i]);

	for (i = 0; i < argc; i++)
		printf("argv[%d] == %s\n", i, argv[i]);

	printf("stdin:\n");
	while (fgets(buf, BUFSIZ, stdin))
		printf("\t%s", buf);

	return 0;
}
