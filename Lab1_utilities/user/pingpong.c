#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char* argv[])
{
    int fd1[2];
    int fd2[2];
    pipe(fd1);
    pipe(fd2);
    char buf[10];
    if (fork() == 0) { //child
        close(fd2[0]);
        close(fd1[1]);
        read(fd1[0], buf, 1);
        printf("%d: received ping\n", getpid());
        write(fd2[1], "p", 1);
    }
    else { //parent
        close(fd1[0]);
        close(fd2[1]);
        write(fd1[1], "p", 1);
        read(fd2[0], buf, 1);
        printf("%d: received pong\n", getpid());
    }
    exit(0);
}
