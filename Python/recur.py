def fun(number):
    if number > 1:
        return number * fun(number - 1)
    else:
        return 1


num = int(input("Enter a number :"))
print(fun(num))
