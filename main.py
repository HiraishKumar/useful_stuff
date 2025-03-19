from random import randint

ans = []
while len(ans)<12:
    num = randint(1,12)
    if num not in ans:
        ans.append(num)

print(ans)