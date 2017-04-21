debug = True
def main():
    vowels = "*aeiou"
    name = input("What is your name? ")
    if bfm(name.upper()):
        print(cat(name))

    name = split(name, vowels)
    print(name)
def cat(name):
    letter = name[0].upper()
    if letter == "B":
        catname = "Bo-b"+name[1:]
        return catname
    elif letter == "F":
        catname = "Fo-f" + name[1:]
        return catname
    elif letter == "M":
        catname = "Mo-m"+name[1:]
        return catname


def split(string, divs):
    for d in divs[1:]:
        string = string.replace(d, divs[0])
    strings = string.split(divs[0])
    if strings[0] == '':
        strings = strings[1:]
    return strings


def bfm(name):
    if (name[0] == "B") or (name[0] == "F") or (name[0] == "M"):
        return True
    else:
        return False

if __name__ == "__main__":
    main()
