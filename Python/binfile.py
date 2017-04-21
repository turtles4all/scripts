file = open('pg100.txt', 'br')
byte = file.read(1)
while byte:
    newbyte = byte^20
    print(byte.hex())
    print(newbyte)

file.close()

print(type(data))
print(len(data))
