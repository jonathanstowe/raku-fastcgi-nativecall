#include <stdlib.h>
#include <string.h>
#include "fcgiapp.h"

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
