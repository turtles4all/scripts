import re

fileName = "pg100.txt"
searchfor = "Some achieve greatness"
regex = r"\b[A-Z]+\b"

def greatness():
    matchedLineNames = {}
    file = open(fileName, 'r')
    lines = file.read().split('\n')
    listofnames = list
    file.close()
    for idx, line in enumerate(lines):
        upper = line.upper()
        exists = upper.find(searchfor.upper())
        if exists > 0:
            matches = re.finditer(regex, line)
            for match in matches:
                try:
                    matchedLineNames[match.group()] += 1
                except:
                    matchedLineNames[match.group()] = 1
            print("line #{index} :\"{linecont}\"".format(index=idx, linecont=line))
    print(matchedLineNames)

def nameCount():
    namesToSearchFor = ["Bianca", "Caesar", "Cymbeline", "Hamlet", "Henry", "Juliet", "Macbeth", "Ophelia", "Othello",
                        "Romeo", "Rosalind", "Viola"]
    matchedNames = {}
    file = open(fileName, 'r')
    lines = file.read().split('\n')
    file.close()
    for line in lines:
        upper = line.upper()
        for idx, name in enumerate(namesToSearchFor):
            exists = upper.find(namesToSearchFor[idx].upper())
            if exists > 0:
                try:
                    matchedNames[name] += 1
                except:
                    matchedNames[name] = 1

    for value in sorted(matchedNames.values()):
        print(list(matchedNames.keys())[list(matchedNames.values()).index(value)], "--",value)

# greatness()
nameCount()
