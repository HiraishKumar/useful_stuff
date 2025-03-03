import random

def unique_numbers_string(start, end):
    """Generates a string of all non-duplicate integers in a given range."""
    numbers = list(range(start, end + 1))  # Create a list of unique numbers in range
    random.shuffle(numbers)  # Shuffle to add randomness (optional)
    return ' '.join(map(str, numbers))  # Convert to space-separated string
mnemonics = {
    "PMSHFR": "Perception Error",
    "BPFCS": "Personality dterminants",
    "ECEMIP": "Personality traints in OB environment",
    "KMMRR": "Parts of Emotional Intelligence",
    "EACEO": "Big Personality traits",
    "STEP": "Elements OF OB",
    "ISHCS" : "Key Approaches to OB",
    "MISCLC" : "Need For Studying OB",
    "PRIMEIC": "Challanges to OB",
    "RSOIA": "Perceptual Process"
}

ansmnemonics = {
    "P M S H F R": "Please Make Sure He Feels Right",
    "B P F C S": "Big Parrots Fly Carrying Seeds",
    "E, C, E, M, I, P": "Every Character Evolves, Molding Inner Personality",
    "K, M, M, R, R": "Keen Minds Manage Reactions Responsibly",
    "E, A, C, E, O": "EA CEO",
    "R S O I A":"Red Snakes Observe Interesting Apples"
}

mnemon_keys = list(mnemonics.keys())
ans = list(range(0,len(mnemon_keys)))
random.shuffle(ans)
# Define range
start, end = 1, 6  # Example range
for i in ans:
    result = unique_numbers_string(start,len(mnemon_keys[i]))
    print(result,mnemonics[mnemon_keys[i]])
