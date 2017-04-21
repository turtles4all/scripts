import random
nameD = {}
adjD = {}

def main():
    getInput()
    looping = True
    while looping:
        randoms = genRandom()
        sentence = nameD[randoms[0]] + " is " + adjD[randoms[1]]
        print(sentence)
        doExit = input("Do you want to continue (Y/N)?")
        if doExit.upper() == "N":
            looping = False
    exit()
def buildDictionary(names, adjs):
    for idx, item in enumerate(names):
        nameD[idx] = item
    # print(nameD)
    for idx, item in enumerate(adjs):
        adjD[idx] = item
    # print(adjD)

def genRandom():
    rName = random.randrange(0, len(nameD))
    rAdj = random.randrange(0, len(adjD))
    return rName, rAdj


def getInput():
    looping = True
    names = []
    adjs = []
    print("Use \"Q\" when done entering names")
    while looping:
        idx = 0
        name = input("Enter a Name :")
        if name.upper() == "Q":
            looping = False
        else:
            names.append(name)

    looping = True
    print("Use \"Q\" done entering adjectives")
    while looping:
        adj = input("Enter a adjective :")
        if adj.upper() == "Q":
            looping = False
        else:
            adjs.append(adj)
    buildDictionary(names, adjs)


if __name__ == "__main__":
    main()
