# CFG-Assignment2
print(pokemon["name"])

for ability in pokemon["abilities"]:
    print(ability["ability"]["name"], ability["is_hidden"]);

print(ability["is_hidden"]) == False;


print(ability in pokemon["abilities"]);

print(pokemon["abilities"]);

def get_visible_abilities(pokemon_data):
    visible = [];
    for ability in pokemon_data["abilities"]:
        if ability["is_hidden"] == False:
            visible.append(ability["name"]);

C:\Users\aisha\AppData\Local\Programs\Python\Python314\python.exe C:\Users\aisha\CFG-Assignements\main.py 
ditto
limber False
imposter True
True
True
[{'ability': {'name': 'limber', 'url': 'https://pokeapi.co/api/v2/ability/7/'}, 'is_hidden': False, 'slot': 1}, {'ability': {'name': 'imposter', 'url': 'https://pokeapi.co/api/v2/ability/150/'}, 'is_hidden': True, 'slot': 3}]

Process finished with exit code 0

