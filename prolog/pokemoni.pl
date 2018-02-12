%uključenje modula potrebnih za funkcioniranje igre 
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(odbc)).
:- use_module(library(pce)).

%definicija dinamičkih predikata/varijabli 
:-dynamic
	moja_pozicija/1,
	lokacija/2,
	lokacija_pokemon/2,
	inventar/1,	
	kolicina_poke_lopti/1,
	dzep/1,
	healt/2,
	br_napada/1,
	damage/1,
	iskustvo/2,
	retracted/1.
	
%inicijalizacija varijabli 
kolicina_poke_lopti(0).
br_napada(0).	
damage(0).
dzep(prazan).
inventar([]).
retracted([]).
	
%stats(napad, obrana,posebni napad, posebna obrana, osnovna snaga, razina, vrsta)
%potrebno za izračun jačine napada 	
stats(pikachu, 55, 30, 50, 40, 50, 1, struja).
stats(charmander, 52, 43, 60, 50, 50, 1, vatra).
stats(squirtle, 48, 65, 50, 64, 50, 1, voda).
stats(bulbasaur, 49, 49, 65, 65, 65, 1, trava).
stats(poliwag, 50, 40, 40, 40, 40, 1, voda).

%iskustvo koje pokemon sječe kroz igru i početna inicijalizacija
iskustvo(pikachu, 0).
iskustvo(charmander, 0).
iskustvo(squirtle, 0).
iskustvo(bulbasaur, 0).

%zdravlje pokemona
healt(pikachu, 35).
healt(charmander, 39).
healt(squirtle, 44).
healt(bulbasaur, 45).
healt(poliwag, 40).

%služi za izracun jacine napada i da pokemoni neke vrste budu jači od pokemona neke druge vrste
%npr da vodeni pokemon uvijek bude jači od vatrenog
obrana_napadac(voda,struja,2).
obrana_napadac(voda,vatra,0.5).
obrana_napadac(voda,trava,2).
obrana_napadac(voda,voda,0.5).
obrana_napadac(vatra,struja,1).
obrana_napadac(vatra,vatra,0.5).
obrana_napadac(vatra,trava,0.5).
obrana_napadac(vatra,voda,2).
obrana_napadac(struja,struja,0.5).
obrana_napadac(struja,vatra,1).
obrana_napadac(struja,trava,1).
obrana_napadac(struja,voda,1).
obrana_napadac(trava,struja,0.5).
obrana_napadac(trava,vatra,2).
obrana_napadac(trava,trava,0.25).
obrana_napadac(trava,voda,0.5).

%služi za određivanje lokacije pojedinih objekata i prolaza 	
lokacija(pocetni_svijet, kuca).
lokacija(vatreni_svijet, pocetni_svijet).
lokacija(vodeni_svijet, pocetni_svijet).
lokacija(travnati_svijet, pocetni_svijet).
lokacija(elektricni_svijet, pocetni_svijet).
lokacija(poke_lopta, vatreni_svijet).
lokacija(poke_lopta, vodeni_svijet).
lokacija(poke_lopta, kuca).
lokacija(pokedex, kuca).
lokacija(dvorana, vodeni_svijet).
lokacija(voditelj_dvorane, dvorana).
lokacija(poliwag, dvorana).

%gdje se koji pokemon nalazi
lokacija_pokemon(pikachu, elektricni_svijet).
lokacija_pokemon(charmander, vatreni_svijet).
lokacija_pokemon(squirtle, vodeni_svijet).
lokacija_pokemon(bulbasaur, travnati_svijet).
lokacija_pokemon(poliwag, dvorana).

%inicijalizacija početne pozicije
moja_pozicija(kuca).

%određivanje prolaza između lokacija
prolaz(kuca, pocetni_svijet).
prolaz(pocetni_svijet, vatreni_svijet).
prolaz(pocetni_svijet, vodeni_svijet).
prolaz(pocetni_svijet, travnati_svijet).
prolaz(pocetni_svijet, elektricni_svijet).
prolaz(vodeni_svijet, dvorana).

%ako postoji prolaz između lokacija
put(X,Y) :- prolaz(X,Y).
put(X,Y) :- prolaz(Y,X).

%dodavanje elemenata E u listu 
dodaj_el( E, Lu, Li ) :- Li = [ E | Lu ].

%provjera kamo se može ići iz poziciji X
mogucnost_prolaza(X) :-	prolaz(X,Y),writeln(Y).	


%picture je prozor za mogucnosti skrolanja
%kreira novi objekt picture prikazauje ga na zaslonu 
%send-prvi argument je naziv objekta, a drugi naziv metoda	
start :- new(@p, picture('Igra Pokemoni')),send(@p, open), moja_pozicija(L),	prikaz_lokacije(L).	

%služi za grafički prikaz borbe između 2 pokemona
prikaz_borbe(Pokemon) :-
	healt(poliwag, HP1),
	inventar(I),
	(member(Pokemon, I) -> true; fail),	healt(Pokemon, HP2),iskustvo(Pokemon, Is),
	send(@p, clear),	
	send(@p, display, bitmap('dvorana.gif')),
	send(@p, display,new(_, bitmap('poliwag.gif')), point(100,300)),
	(Pokemon == 'pikachu' ->send(@p, display,new(_, bitmap('pikachu.gif')), point(500,300));
	Pokemon == 'charmander' ->send(@p, display,new(_, bitmap('charmander.gif')), point(500,300));
	Pokemon == 'squirtle' ->send(@p, display,new(_, bitmap('squirtle.gif')), point(500,300));
	Pokemon == 'bulbasaur' ->send(@p, display,new(_, bitmap('bulbasaur.gif')), point(500,300))	
	),
	(HP1 =< 0 ->	
		send(@p, display,new(_, text('DOBIVENO ISKUSTVO:')), point(300,50)),
		send(@p, display,new(_, text(Is)), point(450,50));
		true
	),
	send(@p, display,new(_, text(HP2)), point(550,250)),
	send(@p, display,new(_, text(HP1)), point(150,250)).

%grafički prikaz pokedexa i pojedinih podataka o odabranom pokemonu Pokemon	
prikaz_pokedex(Pokemon) :-
	healt(Pokemon, HP),	
	stats(Pokemon,B,C,D,E,F,G,H),
	send(@p, clear),	
	send(@p, display, bitmap('pokedex.gif')),
	send(@p, display,new(_, text('Zdravlje:')), point(110,65)),
	send(@p, display,new(_, text(HP)), point(225,65)),
	send(@p, display,new(_, text('Napad:')), point(110,80)),
	send(@p, display,new(_, text(B)), point(225,80)),
	send(@p, display,new(_, text('Obrana:')), point(110,95)),
	send(@p, display,new(_, text(C)), point(225,95)),
	send(@p, display,new(_, text('Posebni napad:')), point(110,110)),
	send(@p, display,new(_, text(D)), point(225,110)),
	send(@p, display,new(_, text('Posebna obrana:')), point(110,125)),
	send(@p, display,new(_, text(E)), point(225,125)),
	send(@p, display,new(_, text('Osnovna snaga:')), point(110,140)),
	send(@p, display,new(_, text(F)), point(225,140)),
	send(@p, display,new(_, text('Razina:')), point(110,155)),
	send(@p, display,new(_, text(G)), point(225,155)),	
	send(@p, display,new(_, text('Vrsta:')), point(110,170)),
	send(@p, display,new(_, text(H)), point(225,170)).

%zatvara grafički prikaz pokedexa i grafički prikazuje trenutnu lokaciju
zatvori_pokedex :-	moja_pozicija(L),prikaz_lokacije(L).

%služi za grafički prikaz trenutne lokacija s objektima koji se u njoj nalaze		
prikaz_lokacije(Lokacija) :-
	kolicina_poke_lopti(Kol),
	moja_pozicija(L),
	send(@p, clear),
	(Lokacija == 'kuca' ->	
		send(@p, display, bitmap('kuca.gif')),
		(lokacija(poke_lopta, kuca)->send(@p, display,new(_, bitmap('lopta.gif')), point(500,525));	true),
		(lokacija(pokedex, kuca)->	send(@p, display,new(_, bitmap('pokedex_mini.gif')), point(325,50));true),	
		send(@p, display,new(_, text('Broj poke lopti:')), point(30,25)),
		send(@p, display,new(_, text(Kol)), point(120,25)),
		send(@p, display,new(_, text(L)), point(680,25)),
		send(@p, display, new(_,bitmap('trainer.gif')),point(100,300));
	Lokacija == 'pocetni_svijet' ->	
		send(@p, display, bitmap('pocetni_svijet.gif')),	
		send(@p, display,new(_, text('Broj poke lopti:')), point(30,25)),
		send(@p, display,new(_, text(Kol)), point(120,25)),
		send(@p, display,new(_, text(L)), point(680,25)),
		send(@p, display,new(_,bitmap('trainer.gif')),point(200,300));
	Lokacija == 'vatreni_svijet' ->	
		send(@p, display, bitmap('vatreni_svijet.gif')),
		(lokacija(poke_lopta, vatreni_svijet)->		
			send(@p, display,new(_, bitmap('lopta.gif')), point(500,525));		
			true),
		(lokacija_pokemon(charmander, vatreni_svijet)->	
			send(@p, display,new(_, bitmap('charmander.gif')), point(300,300));
			true),	
		send(@p, display,new(_, text('Broj poke lopti:')), point(30,25)),
		send(@p, display,new(_, text(Kol)), point(120,25)),
		send(@p, display,new(_, text(L)), point(680,25)),
		send(@p, display,new(_,bitmap('trainer.gif')),point(100,300));
	Lokacija == 'vodeni_svijet' ->	
		send(@p, display, bitmap('vodeni_svijet.gif')),
		(lokacija(poke_lopta, vodeni_svijet)->		
			send(@p, display,new(_, bitmap('lopta.gif')), point(500,525));		
			true),
		(lokacija_pokemon(squirtle, vodeni_svijet)->	
			send(@p, display,new(_, bitmap('squirtle.gif')), point(300,300));
			true),	
		send(@p, display,new(_, text('Broj poke lopti:')), point(30,25)),
		send(@p, display,new(_, text(Kol)), point(120,25)),
		send(@p, display,new(_, text(L)), point(680,25)),
		send(@p, display,new(_,bitmap('trainer.gif')),point(100,300));
	Lokacija == 'travnati_svijet' ->	
		send(@p, display, bitmap('travnati_svijet.gif')),
		(lokacija_pokemon(bulbasaur, travnati_svijet)->	
			send(@p, display,new(_, bitmap('bulbasaur.gif')), point(300,300));
			true),
		send(@p, display,new(_, text('Broj poke lopti:')), point(30,25)),
		send(@p, display,new(_, text(Kol)), point(120,25)),
		send(@p, display,new(_, text(L)), point(680,25)),
		send(@p, display,new(_,bitmap('trainer.gif')),point(100,300));
	Lokacija == 'elektricni_svijet' ->	
		send(@p, display, bitmap('elektricni_svijet.gif')),
		(lokacija_pokemon(pikachu, elektricni_svijet)->	
			send(@p, display,new(_, bitmap('pikachu.gif')), point(300,300));
			true),
		send(@p, display,new(_, text('Broj poke lopti:')), point(30,25)),
		send(@p, display,new(_, text(Kol)), point(120,25)),
		send(@p, display,new(_, text(L)), point(680,25)),
		send(@p, display,new(_,bitmap('trainer.gif')),point(100,300));
	Lokacija == 'dvorana' ->	
		send(@p, display, bitmap('dvorana.gif')),	
		send(@p, display,new(_, text('Broj poke lopti:')), point(40,35)),
		send(@p, display,new(_, text(Kol)), point(130,35)),
		send(@p, display,new(_, text(L)), point(680,35)),
		send(@p, display,new(_, bitmap('trainer2.gif')), point(500,100)),
		send(@p, display,new(_, bitmap('poliwag.gif')), point(400,300)),
		send(@p, display,new(_,bitmap('trainer.gif')),point(100,300));
	true).
	
%ako postoji put do lokacije X da igrač ide na tu lokaciju i grafički prikaz	
idi(X) :- 
	moja_pozicija(L),
	(put(L,X) ->	
	retract(moja_pozicija(L)),
	assert(moja_pozicija(X)),	
	prikaz_lokacije(X),
	write('Sada ste u: '), writeln(X);
	L == X ->
	writeln('To je trenutna lokacija');
	writeln('Ne mogu do tamo! ')).

%mogućnost uzimanja poke lopte i pokedexa, ako se nalaze na poziciji na kojoj je igrač	
uzmi(Objekt) :-
	(Objekt == 'poke_lopta' -> 
		moja_pozicija(L),
		lokacija(poke_lopta, L),
		retracted(R),
		retract(kolicina_poke_lopti(X)),
		Y is X + 1,		
		assert(kolicina_poke_lopti(Y)),
		retract(lokacija(poke_lopta, L)),
		retract(retracted(R)),
		dodaj_el(L,R,List),
		assert(retracted(List)),
		prikaz_lokacije(L),
		writeln('Uzeli ste poke loptu! ');
	Objekt == 'pokedex' -> 
		moja_pozicija(L),
		lokacija(pokedex, L),
		retracted(R),
		retract(dzep(_)),
		assert(dzep(Objekt)),
		retract(lokacija(pokedex, L)),
		retract(retracted(R)),
		dodaj_el(pokedex,R,List),
		assert(retracted(List)),
		prikaz_lokacije(L),
		writeln('Uzeli ste pokedex');
	writeln('Nema ovdje tog objekta!')
	).

%prikaz pojedinih detalja o pokemonu Pokemon i grafički prikaz	
analiza_pokemona(Pokemon) :-	
	(dzep(pokedex) ->
		prikaz_pokedex(Pokemon),
		healt(Pokemon, HP),	
		stats(Pokemon,B,C,D,E,F,G,H),
		write('Zdravlje: '), writeln(HP),
		write('Napad: '), writeln(B),
		write('Obrana: '), writeln(C),
		write('Posebni napad: '), writeln(D),
		write('Posebna obrana: '), writeln(E),		
		write('Osnovna snaga: '),writeln(F),
		write('Razina: '),writeln(G),
		write('Vrsta: '),writeln(H);	
	writeln('Nemate pokedex!')
	).

%mogućnost hvatanja pokemona ako igrač ima više od 0 poke lopti 
%i ako se pokemon nalazi na lokaciji na kojoj je igrač	
uhvati_pokemona(Pokemon) :-
	kolicina_poke_lopti(Y),
	inventar(P),
	( Y > 0, Pokemon \= 'poliwag' ->
		moja_pozicija(L),
		lokacija_pokemon(Pokemon,L),
		retract(kolicina_poke_lopti(Y)),
		Z is Y - 1,	
		assert(kolicina_poke_lopti(Z)),
		retract(inventar(P)),	
		dodaj_el(Pokemon, P, I),			
		assert(inventar(I)),
		retract(lokacija_pokemon(Pokemon,L)),
		retracted(R),
		retract(retracted(R)),
		dodaj_el(Pokemon,R,List),
		assert(retracted(List)),
		prikaz_lokacije(L),
		write('Uhvatili ste '), writeln(Pokemon);
		writeln('Nemate poke lopte!')
	).
uhvati_pokemona(Pokemon) :-
	writeln('Nema tog pokemona!').
		
%izračunavanje jačine napada
izracunaj_damage(Type,X6,X7,VN,VO) :-
	STAB is 1.5,		
	Critical is 1.5,
	Other is 1,
	random(0.85, 1.00, Random_number),	
	Modifier is STAB * Type * Critical * Other * Random_number,		
	Damage_not is (((2 * X7 + 10) / 250) * (VN / VO) * X6 + 2) * Modifier,
	Damage is floor(Damage_not),
	retract(damage(_)),
	assert(damage(Damage)).

%odabir pokemona Pokemon1 -napadača, Vrste napada koji može biti obični ili posebni i
%odabir pokemona Pokemon2 koji se brani
%nakon što Pokemon1 napadne Pokemon2, tada se ovaj predikat ponovno poziva
%te se zamijene argumenti kod poziva pa je Pokemon2 napadač, a Pokemon1 obrambeni
%nakon toga se prekida napadanje	
napad(Pokemon1, Vrsta_napada, Pokemon2) :-		
	stats(Pokemon1, X1, X2, X3, X4, X5, X6, X7),
	stats(Pokemon2, Y1, Y2, Y3, Y4, Y5, Y6, Y7),	
	healt(Pokemon1, HP1),
	healt(Pokemon2, HP2),
	(HP2 > 0, HP1 > 0 ->	
		(Vrsta_napada =='obicni' ->
			VN is X1,
			VO is Y2;
		Vrsta_napada =='posebni' ->
			VN is X3,
			VO is Y4;
		fail	
		),		
		obrana_napadac(Y7,X7,Type),	
		izracunaj_damage(Type,X5,X6,VN,VO),		
		damage(Damage),
		writeln(Damage),		
		Health_after_damage is HP2 - Damage,		
		writeln(healt(Pokemon2, Health_after_damage)),							
		
		(Health_after_damage	=< 0 ->
			retract(healt(Pokemon2,_)),
			assert(healt(Pokemon2, 0)),
			retract(br_napada(_)),
			assert(br_napada(0)),
			retract(iskustvo(Pokemon1,_)),
			assert(iskustvo(Pokemon1,5)),
			write(Pokemon2), writeln('  HP je manji od 0'),
			fail;
		Health_after_damage	> 0 ->
			retract(healt(Pokemon2,_)),
			assert(healt(Pokemon2, Health_after_damage)),
			retract(br_napada(Broj)),
			Br is Broj + 1,
			writeln(Br),
			assert(br_napada(Br)),		
			( Br < 2 ->	
				napad(Pokemon2, Vrsta_napada, Pokemon1);
			Br == 2 ->
				retract(br_napada(_)),
				assert(br_napada(0)),
				writeln('napadanje gotovo')		
			)
		);		
	HP1 =< 0 ->
		retract(br_napada(_)),
		assert(br_napada(0)),
		write(Pokemon1), writeln('  HP je manji od 0');
	HP2 =< 0 ->
		retract(br_napada(_)),
		assert(br_napada(0)),
		retract(iskustvo(Pokemon1,_)),
		assert(iskustvo(Pokemon1,5)),
		write(Pokemon2), writeln('  HP je manji od 0')		
).

%odabir pokemona i vrste napada za borbu i grafički prikaz
odabir_pokemona(Pokemon1, Vrsta_napada) :-
	moja_pozicija(MPOZ),	
	inventar(List),
	healt(Pokemon1, HP1),
	(member(Pokemon1, List) ->
		true;
		writeln('Nemate tog pokemona u invetaru!'),
		fail		
	),
	(HP1 =< 0 ->
		prikaz_borbe(Pokemon1);
		true
	),
	(MPOZ == 'dvorana' ->
	lokacija_pokemon(Pokemon2, MPOZ),
	healt(Pokemon2, HP2),
	(HP2 =< 0 ->
		prikaz_borbe(Pokemon1);
		true
	),
	napad(Pokemon1, Vrsta_napada, Pokemon2);
	writeln('Nema protivnika')),
	prikaz_borbe(Pokemon1).

%uspostavljanje konekcije s bazom podataka	
connection :- odbc_connect('MSProlog', _,	[user(root),password(''),alias(prolog),	open(once)]).

%zatvaranje konekcije prema bazi podataka
disconnect :-odbc_disconnect('prolog').


%spremanje u bazu podataka	
spremi :- 
	moja_pozicija(P),
	kolicina_poke_lopti(Kol),
	dzep(D),
	healt(pikachu, Hpi),
	healt(charmander, Hc),
	healt(squirtle, Hs),
	healt(bulbasaur, Hb),	
	healt(poliwag, Hpo),
	iskustvo(pikachu, Ip),
	iskustvo(charmander, Ic),
	iskustvo(squirtle, Is),
	iskustvo(bulbasaur, Ib),
	br_napada(Bn),	
	damage(Dam),
	inventar(I),
	retracted(R),	
	connection,	
	(member(pikachu, R) -> 	Pikachu = pikachu;	Pikachu = 0),
	(member(charmander, R) -> 	Charmander = charmander;Charmander = 0),
	(member(squirtle, R) -> 	Squirtle = squirtle;Squirtle = 0),
	(member(bulbasaur, R) -> 	Bulbasaur = bulbasaur;Bulbasaur = 0),
	(member(kuca, R) -> 	Kuca = kuca;Kuca = 0),
	(member(vodeni_svijet, R) -> 	Vodeni_svijet = vodeni_svijet;Vodeni_svijet = 0),
	(member(vatreni_svijet, R) -> 	Vatreni_svijet = vatreni_svijet;Vatreni_svijet = 0),
	(member(pokedex, R) -> 	Pokedex = pokedex;Pokedex = 0),
	swritef(SQL,'UPDATE `pokemoni` SET `pozicija`=\'%t\',`kol_pok_lopti`=\'%t\',`dzep`=\'%t\',
	`pikachuHp`=\'%t\',`charmanderHp`=\'%t\',`squirtleHp`=\'%t\',`bulbasaurHp`=\'%t\',`poliwagHp`=\'%t\',
	`pikachuE`=\'%t\',`charmanderE`=\'%t\',`squirtleE`=\'%t\',`bulbasaurE`=\'%t\',
	`br_napada`=\'%t\',`damage`=\'%t\',`inventar`=\'%t\',`pikachu`=\'%t\',
	`charmander`=\'%t\',`squirtle`=\'%t\',`bulbasaur`=\'%t\',`vatreni_svijet`=\'%t\',
	`vodeni_svijet`=\'%t\',`kuca`=\'%t\', `pokedex`=\'%t\',`retracted`=\'%t\'	WHERE `ID`= 1', 
	[P,Kol,D,Hpi,Hc,Hs,Hb,Hpo,Ip,Ic,Is,Ib,Bn,Dam, I, Pikachu, Charmander, Squirtle, Bulbasaur, Vatreni_svijet,Vodeni_svijet, Kuca, Pokedex,R]),	
	odbc_query('prolog', SQL, affected(_)),
	disconnect.
	
%ucitavanje iz baze
ucitaj:-
	connection,
	odbc_query('prolog','SELECT * FROM pokemoni',	
				 row(Id,P,Kol,D,Hpi,Hc,Hs,Hb,Hpo,Ip,Ic,Is,Ib,Bn,Dam, I,Pika,Cha, Sq, Bul, Vas, Vos, Ku, Px, R)), 
	retract(moja_pozicija(_)),	assert(moja_pozicija(P)),
	retract(kolicina_poke_lopti(_)), assert(kolicina_poke_lopti(Kol)),
	retract(dzep(_)), assert(dzep(D)),
	retract(healt(pikachu, _)),	assert(healt(pikachu, Hpi)),
	retract(healt(charmander, _)),	assert(healt(charmander, Hc)),
	retract(healt(squirtle, _)),	assert(healt(squirtle, Hs)),
	retract(healt(bulbasaur, _)),	assert(healt(bulbasaur, Hb)),
	retract(healt(poliwag, _)), 	assert(healt(poliwag, Hpo)),
	retract(iskustvo(pikachu, _)),	assert(iskustvo(pikachu, Ip)),
	retract(iskustvo(charmander, _)),	assert(iskustvo(charmander, Ic)),
	retract(iskustvo(squirtle, _)),	assert(iskustvo(squirtle, Is)),
	retract(iskustvo(bulbasaur, _)),	assert(iskustvo(bulbasaur, Ib)),
	retract(br_napada(_)),	assert(br_napada(Bn)),
	retract(damage(_)),	assert(damage(Dam)),
	term_to_atom(A,I),	retract(inventar(_)),	assert(inventar(A)),
	term_to_atom(At,R),	retract(retracted(_)),	assert(retracted(At)),
	(Pika \= '0' ->	retract(lokacija_pokemon(pikachu, elektricni_svijet));
		assert(lokacija_pokemon(pikachu, elektricni_svijet))),
	(Cha \= '0' -> retract(lokacija_pokemon(charmander, vatreni_svijet));
		assert(lokacija_pokemon(charmander, vatreni_svijet))),
	(Sq \= '0' ->	retract(lokacija_pokemon(squirtle, vodeni_svijet));
		assert(lokacija_pokemon(squirtle, vodeni_svijet))),
	(Bul \= '0' ->	retract(lokacija_pokemon(bulbasaur, travnati_svijet));
		assert(lokacija_pokemon(bulbasaur, travnati_svijet))),
	(Vas \= '0' ->	retract(lokacija(poke_lopta, vatreni_svijet));
		assert(lokacija(poke_lopta, vatreni_svijet))),
	(Vos \= '0' ->	retract(lokacija(poke_lopta, vodeni_svijet));
		assert(lokacija(poke_lopta, vodeni_svijet))),
	(Ku \= '0' ->	retract(lokacija(poke_lopta, kuca));
		assert(lokacija(poke_lopta, kuca))),
	(Px \= '0' -> 	retract(lokacija(pokedex, kuca));
		assert(lokacija(pokedex, kuca))),	
	prikaz_lokacije(P).	
	
	