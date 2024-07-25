#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void redirect(int num, int pip[]) //输入或输出重定向
{
    close(num);
    dup(pip[num]);
    close(pip[0]);
    close(pip[1]);
}

void drop(int prime) //筛除非质数
{
    int num;
    while (read(0, &num, sizeof(num)))
    {
        if (num % prime != 0)
        {
            write(1, &num, sizeof(num));
        }
    }
}

void deep() //下一层搜索
{
    int prime;
    int pip[2];
    if (read(0, &prime, sizeof(prime)))
    {
        printf("prime %d\n", prime);
        pipe(pip);
        if (fork() == 0)
        {
            redirect(1, pip);
            drop(prime);
        }
        else
        {
            redirect(0, pip);
            deep();
        }
    }
}

int main(int argc, char* argv[])
{
    int pip[2];
    pipe(pip);
    if (fork() == 0) 
    {
        redirect(1, pip);
        for (int i = 2; i < 36; i++)
            write(1, &i, sizeof(i));
    }
    else
    {
        redirect(0, pip);
        deep();
    }
    exit(0);
}