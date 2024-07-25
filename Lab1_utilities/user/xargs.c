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
    int paraNum = 0; //��������
    char* newarg[MAXARG];
    for (int i = 1; i < argc; ++i) {
        newarg[paraNum++] = argv[i]; //��ȡxargs��ָ��
    }
    char ch; //��Ŵӻ�������ȡ���ַ�
    char* para; //��Ų���
    char temp[MAXARG][100]; 
    para = temp[0]; 
    int chNum = 0; //�ַ�����
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
                exec(argv[1], newarg); //ִ����Ӳ������ָ��
            }
        }
        else if (ch == ' ') 
        {
            para[chNum] = '\0'; 
            chNum = 0; 
            newarg[paraNum++] = para; // Ϊָ����Ӳ���
            para = temp[paraNum];
        }
        else
        {
            para[chNum++] = ch;
        }
    }
    exit(0);
}