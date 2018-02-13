# Pokemon-game-prolog

# Requirements:

  - [Connector/ODBC] (http://dev.mysql.com/downloads/connector/odbc/) 
  
  - [SWI-Prolog] (http://www.swi-prolog.org/)
  
  - Database(optional). If u want to save your current position and stats u should install it. I have used [XAMPP] with MariaDB:        (https://www.apachefriends.org/index.html)
 
# Database setup:

# Game setup:
 - put pictures in your SWI-Prolog instalation folder(\swipl\xpce\bitmaps)
 - start pokemon.pl

# List of predicates: 
|Predicate|Description|
|start|initialize new window|
|uzmi(O)|get object O into inventory. Object O can be *poke_lopta*(pokeball) or *pokedex*|
|idi(X)|go onto location X|
|analiza_pokemona(P)|analize pokemon P with pokedex|
|zatvori_pokedex|close pokedex|
|uhvati_pokemona(P)|get pokemon P into invetory. P is pokemon name|
|odabir_pokemona(P1, V)|P1 is pokemon in inventory. V is type of attack, can be *obicni*(regular) or *posebni*(special)|
|spremi|save location and stats into database|
|ucitaj|get saved location and stats from database|

# List of locations:
  - kuca
  - pocetni_svijet
  - vatreni_svijet
  - vodeni_svijet
  - travnati_svijet
  - elektricni_svijet
  - dvorana
  
