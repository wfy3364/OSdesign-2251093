#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        fprintf(2, "error: too less arguments in the instruction \"xargs\"");
        exit(1);
    }
    int paraNum = 0; //参数数量
    char* newarg[MAXARG];
    for (int i = 1; i < argc; ++i) {
        newarg[paraNum++] = argv[i]; //提取xargs后指令
    }
    char ch; //存放从缓冲流读取的字符
    char* para; //存放参数
    char temp[MAXARG][100]; 
    para = temp[0]; 
    int chNum = 0; //字符数量
    while (read(0, &ch, 1) > 0) 
    {
        if (ch == '\n' || ch == '\0')
        {
            para[chNum] = '\0';
            chNum = 0;
            newarg[paraNum++] = para;
            newarg[paraNum] = 0;
            if (fork() != 0)
            {
                wait(0); 
                paraNum = argc - 1;
            }
            else 
            {
                exec(argv[1], newarg); //执行添加参数后的指令
            }
        }
        else if (ch == ' ') 
        {
            para[chNum] = '\0'; 
            chNum = 0; 
            newarg[paraNum++] = para; // 为指令添加参数
            para = temp[paraNum];
        }
        else
        {
            para[chNum++] = ch;
        }
    }
    exit(0);
}