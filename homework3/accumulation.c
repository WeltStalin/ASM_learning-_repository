#include <stdio.h>

int main() {
    int sum = 0;

    for (int i = 1; i <= 100; i++) {
        sum += i;
    }

    printf("累加和：%d\n", sum);

    //输入输出
    int number = 0;
    printf("请输入数字（1~100）：");
    scanf("%d", &number);

    printf("十进制输出：%d\n", number);

    return 0;
}