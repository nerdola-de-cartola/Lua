ultimaCopa = {
    ["ano"] = 2002,
    sede = "Japão",
    jogadores = {"Cafu", "Ronaldo"},
    imprime = function(self) 
        for i, v in ipairs(self.jogadores) do
            print(i, v)
        end
    end
}

ultimaCopa.capitao = ultimaCopa.jogadores[1]
print(ultimaCopa.ano)
print(ultimaCopa["sede"])
print(ultimaCopa.jogadores[1])
print(ultimaCopa.jogadores[2])
print(ultimaCopa.capitao)

print()

for i, v in pairs(ultimaCopa) do
    print(i, v)
end

print()

table.insert(ultimaCopa.jogadores, "Rivaldo")
table.insert(ultimaCopa.jogadores, "Rivaldo")
table.remove(ultimaCopa.jogadores, #ultimaCopa.jogadores)
ultimaCopa:imprime()
