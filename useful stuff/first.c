#include <stdio.h>

int summer(int n) {
    int num = 0;
    int sum = 0;
    
    while (num <= n) {
        sum += num;
        num++;
    }
    
    return sum;
}

int main() {
    printf("%d\n", summer(1000000));
    return 0;
}
