def main():
    filename = "output.txt"

    # perams = getinput()
    # sentence = format(perams)
    # tofile(sentence, filename)
    # output(filename)
    rawpu = getpu(filename)
    print(rawpu)
    print(type(rawpu))


def getpu(filename):
    file = open(filename, 'r')
    index = file.read().find("pushup")
    file.seek(index-2)
    data = file.read()[0:2]
    file.close()
    return data


def getpus(filename):
    file = open(filename, 'r')
    information = (file.read().split('\n')[1])
    index = information.find("pushup")
    # print(index)
    pu = information[index-3:index]
    file.close()
    return int(pu)


def tofile(sentence, filename):
    file = open(filename, 'w+')
    file.write(sentence)
    file.close()


def output(filename):
    file = open(filename, 'r')
    information = (file.read().split('\n')[1])
    # print(information)
    index = information.find("Year")
    age = information[index-3:index]
    if information.rfind("female") < 0:
        gender = "male"
    else:
        gender = "female"
    index = information.find("pushups")
    pu = information[index - 3:index]
    print("age : "+age)
    print("gender : "+gender)
    print("raw pushups : "+pu)
    file.close()


def format(perams):
    sentence = "The user entered the following:\nA " + perams[0] + " Year old " + perams[1] + " performed " + perams[2] + " pushups on the APFT"
    return sentence


def getinput():
    age = input("Age :")
    gender = input("Male or Female (M/F) :")
    rawpu = input("Raw Pushup Score :")
    if gender.upper() == "M":
        gender = "male"
    else:
        gender = "female"
    args = age, gender, rawpu
    return args

if __name__ == "__main__":
    main()