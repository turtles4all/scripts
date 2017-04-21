
def convert(basevar, convertvar, innitvar):
    # Create a symbol-to-value table.
    SY2VA = {'0': 0,
             '1': 1,
             '2': 2,
             '3': 3,
             '4': 4,
             '5': 5,
             '6': 6,
             '7': 7,
             '8': 8,
             '9': 9,
             'A': 10,
             'B': 11,
             'C': 12,
             'D': 13,
             'E': 14,
             'F': 15,
             'G': 16,
             'H': 17,
             'I': 18,
             'J': 19,
             'K': 20,
             'L': 21,
             'M': 22,
             'N': 23,
             'O': 24,
             'P': 25,
             'Q': 26,
             'R': 27,
             'S': 28,
             'T': 29,
             'U': 30,
             'V': 31,
             'W': 32,
             'X': 33,
             'Y': 34,
             'Z': 35,
             'a': 36,
             'b': 37,
             'c': 38,
             'd': 39,
             'e': 40,
             'f': 41,
             'g': 42,
             'h': 43,
             'i': 44,
             'j': 45,
             'k': 46,
             'l': 47,
             'm': 48,
             'n': 49,
             'o': 50,
             'p': 51,
             'q': 52,
             'r': 53,
             's': 54,
             't': 55,
             'u': 56,
             'v': 57,
             'w': 58,
             'x': 59,
             'y': 60,
             'z': 61,
             '!': 62,
             '"': 63,
             '#': 64,
             '$': 65,
             '%': 66,
             '&': 67,
             "'": 68,
             '(': 69,
             ')': 70,
             '*': 71,
             '+': 72,
             ',': 73,
             '-': 74,
             '.': 75,
             '/': 76,
             ':': 77,
             ';': 78,
             '<': 79,
             '=': 80,
             '>': 81,
             '?': 82,
             '@': 83,
             '[': 84,
             '\\': 85,
             ']': 86,
             '^': 87,
             '_': 88,
             '`': 89,
             '{': 90,
             '|': 91,
             '}': 92,
             '~': 93}

    # Take a string and base to convert to.
    # Allocate space to store your number.
    # For each character in your string:
    #     Ensure character is in your table.
    #     Find the value of your character.
    #     Ensure value is within your base.
    #     Self-multiply your number with the base.
    #     Self-add your number with the digit's value.
    # Return the number.

    integer = 0
    for character in innitvar:
        assert character in SY2VA, 'Found unknown character!'
        value = SY2VA[character]
        assert value < basevar, 'Found digit outside base!'
        integer *= basevar
        integer += value

    # Create a value-to-symbol table.
    VA2SY = dict(map(reversed, SY2VA.items()))

    # Take a integer and base to convert to.
    # Create an array to store the digits in.
    # While the integer is not zero:
    #     Divide the integer by the base to:
    #         (1) Find the "last" digit in your number (value).
    #         (2) Store remaining number not "chopped" (integer).
    #     Save the digit in your storage array.
    # Return your joined digits after putting them in the right order.

    array = []
    while integer:
        integer, value = divmod(integer, convertvar)
        array.append(VA2SY[value])
    answer = ''.join(reversed(array))

    # Display the results of the calculations.
    return answer
basevar = 10
# basevar = int(input("Please enter the base that your number is in: "))
convertvar = int(input("Please enter the base that you would like to convert to: "))
filename = input("File to encode :")
reading = True
f = open("test.txt", 'rb')
base64 = ""
while reading:
    data = f.read(1)
    # print(data)
    data = int.from_bytes(data, 'big')
    # print(data, type(data))
    # exit()
    if data:
        innitvar = data
        base64 = base64 + convert(basevar, convertvar, str(innitvar))
    else:
        reading = False
    # input('cont?')
f.close()
print("encoded =", base64)
outfile = "encoded-"+filename
out = open(outfile, 'w+b')
out.write(str.encode(base64))
out.close()
# innitvar = input("Please enter a number: ")
# print(convert(basevar, convertvar, innitvar))
