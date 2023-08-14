// #include <stdio.h>

// int summer(int n) {
//     int num = 0;
//     int sum = 0;
    
//     while (num <= n) {
//         sum += num;
//         num++;
//     }
    
//     return sum;
// }

// int main() {
//     printf("%d\n", summer(100000));
//     return 0;
// }

#include <stdio.h>

long int summer(long int n) {
    long int num = 0;
    long long int sum = 0;
    
    while (num <= n) {
        sum += num;
        num++;
    }
    
    return sum;
}

long long int main() {
    printf("%ld\n", summer(1000000));
    return 0;
}