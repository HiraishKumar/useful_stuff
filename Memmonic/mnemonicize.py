from random import shuffle

class mnemonicize:
    """Takes in a Dict input in the format { "PMSHFR": "Perception Error" } and produces
    a randomized sequence and list of the indexes of the mnemonic for rivision pourposes,
    in the format ""[3, 1, 6, 2, 5, 4]        | PMSHFR  | Perception Error""
    where the key is the first letters of the mnemoinic in all caps no spaces
    and the value is the theme of the mnemonic"""
    def __init__(self,mnem_dic:dict):
        self.mnem_dic = mnem_dic

    def unique_numbers_string(start:int,end:int)->list[int]:
        """Generates a list of int of all non-duplicate integers in a given range."""
        if end < start:
            raise ValueError("End can not be Greater than Start")
        if end == start:
            return [end]
        numbers = list(range(start, end + 1))  
        shuffle(numbers)  
        return numbers  

    def print_random(self,index = True,mnemonic = True,theme=True)->None:
        """Prints The Indexes of the mnemonic, theme AND the mnemonic itself in a single line.
        each of the three attributes (index,theme and mnemonic) are ON by default and Can be Turned OFF by
        declaring these attributes false in the argumnet of the function"""
        mnem_keys = list(self.mnem_dic.keys())
        key_list = list(range(0,len(mnem_keys)))
        shuffle(key_list)
        for key_index in key_list:
            _index = str(mnemonicize.unique_numbers_string(1,len(mnem_keys[key_index])))
            print_str_array = []
            if index:
                print_str_array.append(f"{_index:<25}") 
            if mnemonic:
                print_str_array.append(f"{mnem_keys[key_index]:7}")
            if theme:
                print_str_array.append(f"{self.mnem_dic[mnem_keys[key_index]]:<40}")
            # formatted_output = f"{_index:<25} | {key_index:<1} | {self.mnem_dic[mnem_keys[key_index]]:<40}"
            # print(formatted_output)
            print_str = " | ".join(print_str_array)
            print(print_str)

if __name__ == "__main__":
    from constants import MI_mnemonics
    print("This is activating the Mnemonics class as a demnonstration")
    test = mnemonicize(MI_mnemonics)
    test.print_random()

