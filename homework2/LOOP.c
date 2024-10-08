#include <stdio.h>

int main() {
    char letter = 'A'; // 初始化字母为'A'
    int count = 0;      // 初始化计数器

    for (int i = 0; i < 26; i++) {
        printf("%c", letter++);
        if (++count == 13) { // 每输出13个字母
            printf("\n");  // 换行
            count = 0;     // 重置计数器
        }
    }

    return 0;
}