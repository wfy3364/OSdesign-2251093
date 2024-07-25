#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char* path) //获取文件名
{
    char* p;
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
        ;
    p++;
    return p;
}

void find(char* path, char* target_name)
{
    char buf[512], * p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0) {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }
    if (fstat(fd, &st) < 0) {
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type) {
    case T_DEVICE:
    case T_FILE: //文件类型
        if (strcmp(target_name, fmtname(path)) == 0) { //检查当前文件是否为目标文件
            printf("%s\n", path);
        }
        break;
    case T_DIR: //目录类型
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
            printf("ls: path too long\n");
            break;
        }
        strcpy(buf, path);
        p = buf + strlen(buf);
        *p++ = '/';
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
            if (de.inum == 0)
                continue;
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0;
            if (stat(buf, &st) < 0) {
                printf("find2: cannot stat %s\n", buf);
                continue;
            }
            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) //排除问题中要求的的.和..文件
                continue;
            find(buf, target_name); //进入该目录递归查找
        }
        break;
    }
    close(fd);
}

int main(int argc, char* argv[])
{
    if (argc != 3) //参数数量错误
    {
        fprintf(2, "error: wrong argument number in the instruction \"find\"\n");
        exit(1);
    }
    find(argv[1], argv[2]);
    exit(0);
}