
def main():
    args = getinput()
    mpg = calculate(args)
    print("Miles per gallon = ", mpg)


def getinput():
    miles = int(input("Number of miles at 1st stop :"))
    miles2 = int(input("Number of miles at 2nd stop :"))
    gallons = float(input("Gallons filled :"))
    args = miles, miles2, gallons
    return args


def calculate(args):
    traveled = args[1]-args[0]
    mpg = traveled/args[2]
    return mpg


if __name__ == "__main__":
    main()


