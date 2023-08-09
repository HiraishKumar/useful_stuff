# def isAnagram(s: str, t: str) -> bool:
#     if len(s) != len(t):
#         return False
#     sorted_s = sorted(s)
#     sorted_t = sorted(t)
    
#     return sorted_s == sorted_t  

def isAnagram( s: str, t: str) -> bool:
    if len(s) != len(t):
        return False
    s2= t[::-1]                
    return s == s2
        
        
print(isAnagram('anagram','nagaram'))