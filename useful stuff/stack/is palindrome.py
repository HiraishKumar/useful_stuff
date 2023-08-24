# string="A man, a plan, a canal: Panama"
string='0P'

# def isPalindrome( s: str) -> bool:
#     test=''
#     for i in s :
#         if i.isalpha() or i.isdigit():
#             test+=i.lower()
#     test_rev=test[::-1]
#     index=0
#     leanth=len(test)
#     check=0
#     while index < leanth and test[index]==test_rev[index]:
#         index+=1
#         check+=1
#     if check==len(test):
#         return True
#     else:
#         return False

# print(isPalindrome(string))

class Solution:
    def isPalindrome(self, s: str) -> bool:
        test=''
        for i in s :
            if i.isalpha() or i.isdigit():
                test+=i.lower()
        test_rev=test[::-1]
        if test==test_rev:
            return True
        else:
            return False