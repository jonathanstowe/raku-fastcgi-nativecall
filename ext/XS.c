#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "fcgiapp.h"

void (* populate_env_callback)(char *, char *);

FCGX_Request *
XS_Init(int sock)
{
	FCGX_Request *request;
	request = calloc(1, sizeof(FCGX_Request));
	if (!request)
		abort();
	FCGX_Init();
	FCGX_InitRequest(request, sock, 0);
	return request;
}

int
XS_Print(const char *str, FCGX_Request *request)
{
	int ret;
	ret = FCGX_PutStr(str, strlen(str), request->out);
	return ret;
}

void
XS_set_populate_env_callback(void (* callback)(char *, char *))
{
	populate_env_callback = callback;
}

void
XS_populate_env(FCGX_Request *request)
{
	int i;
	char *p, *p1;
	char **envp = request->envp;
	for(i = 0; ; i++) {
		if((p = envp[i]) == NULL)
			break;
		p1 = strchr(p, '=');
		assert(p1 != NULL);
		*p1++ = '\0';
		populate_env_callback(p, p1);
	}
}

void
XS_Finish(FCGX_Request *request)
{
	FCGX_Finish_r(request);
	free(request);
}
