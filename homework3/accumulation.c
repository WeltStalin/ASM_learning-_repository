#include <stdio.h>

int main() {
    int sum = 0;

    for (int i = 1; i <= 100; i++) {
        sum += i;
    }

    printf("�ۼӺͣ�%d\n", sum);

    //�������
    int number = 0;
    printf("���������֣�1~100����");
    scanf("%d", &number);

    printf("ʮ���������%d\n", number);

    return 0;
}