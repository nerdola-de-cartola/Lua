copas = {1958, 1962, 1970, 1994, 2002}

print(copas[3])
print(copas[10])

copas[10] = 2022

for i = 1,#copas do 
    print(i, copas[i])
end

print()

for i,v in ipairs(copas) do
    print(i, v)
end