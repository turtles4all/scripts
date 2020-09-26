def check(r, f):
    if f == 'F':
        if r >= 10:
            return 0
        else:
            return r
    if f == 'R':
        if r < 0:
            return 9
        else:
            return r
    
def rotateF():
    global r1,r2,r3
    r1 = r1 + 1
    r2 = r2 + 1
    r3 = r3 + 1
    r1 = check(r1, 'F')
    r2 = check(r2, 'F')
    r3 = check(r3, 'F')

def rotateR():
    global data,r1,r2,r3
    r1 = r1 - 1
    r2 = r2 - 1
    r3 = r3 - 1
    r1 = check(r1, 'R')
    r2 = check(r2, 'R')
    r3 = check(r3, 'R')
    
def shiftF(data):
    dataL = list(data)
    i = 0
    for x in data:
        dataL[i]=chr(ord(x) + r1)
        dataL[i]=chr(ord(x) + r2)
        dataL[i]=chr(ord(x) + r3)
        i = i + 1
        rotateF()
    return "".join(dataL)
    
def shiftR(data):
    dataL = list(data)
    i = 0
  
    
    for x in data[::-1]:
        rotateR()
        dataL[i]=chr(ord(x) - r1)
        dataL[i]=chr(ord(x) - r2)
        dataL[i]=chr(ord(x) - r3)
        i = i + 1
       
    return "".join(dataL[::-1])
    
r1=1
r2=5
r3=9

data = "stuff"
ittr = len(data)
x = 0

    
print ("R1:"+str(r1)+" R2:"+str(r2)+" R3:"+str(r3))
print("before:"+data)
scr = shiftF(data)
print("scr:"+scr)

uscr =shiftR(scr)
print("u:"+uscr)
