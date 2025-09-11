# Zaawansowane Architektury Komputerów

Ten przedmiot poświęcony jest działaniu i budowie procesorów - w bardzo niskopoziomowym ujęciu. Dowiecie się na przykład, jak wygląda proces technologiczny produkcji układów scalonych (litografia, wafle krzemowe i te sprawy), czym jest maszyna Turinga, czym jest potok, czym jest mikrokod, a także jak skonstruować ALU (jednostkę arytmetyczno logiczną). Na wykładzie z tego przedmiotu po raz pierwszy od 2. semestru usłyszycie o Tablicach Karnaugh (to z Układów Cyfrowych). 

Zależnie od tego czy kogoś interesują tego typu rzeczy, będzie to dla was albo najlepszy przedmiot na tym semestrze (to jeśli ktoś np. lubił AKO oraz wykłady Kokota ze SWIM), albo wasze największe przekleństwo.

### Wykład 

Wykład prowadzi prof. Demkowicz, który jest jednym z najbardziej charakterystycznych/specyficznych członków kadry akademickiej na naszym wydziale.

Na plus jest jego szczera pasja do zagadnień o których mówi. 

Na minus jest spora chaotyczność tych wykładów, oraz jego tendencja do używania bardzo abstrakcyjnych sformułowań (*Nie ma różnicy między hardware'm, a software'm*), bez uprzedniego wyjaśnienia o co w zasadzie chodzi oraz o czym mówi. Do tego dochodzi ogromna liczba dygresji. 

Przez to wszystko często naprawdę ciężko go zrozumieć. 

Mniej więcej w tej kolejności tematyka wykładów wygląda następująco:

1. Jak produkuje się układy scalone
2. Czym jest Maszyna Turinga i dlaczego jest taka wyjątkowa.
3. Jak działa rdzeń procesora (TL;DR: Bazową operacją matematyczną jest dodawanie, mając tylko dodawanie możemy wykonać dowlolne obliczenie. Sercem ALU budujemy układ dodający (addery), a potem aby uzyskać inne operacje (odejmowanie, mnożenie, zmiana znaku itd) dodajemy inne układy np. przerabiające wejście do dodawania. Oprócz ALU w procesorze jest CU/dekoder instrukcji, który jest automatem skończonym).
4. Kilka faktów o architekturze ARM
5. Procesory typu VLIW (Very Long Instruction Word) - to taki pipieline na sterydach, jest kilka równoległych potoków i programista musi np. sam pilnować żeby potok jednej instrukcji się skończył, zanim inna instrukcja spróbuje wykorzystać jej wynik. Będziecie mieli okazję spróbować na laborkach. Powodzenia...
6. Kilka przykładów procesorów z dedykowanymi modułami do konkretnych zastosowań (np. NEON do obliczeń wektorowych na ARM).

Obecność na wykładach nie jest sprawdzana, a sam Demkowicz przyznaje że jego wykłady są nieobowiązkowe. 

#### Zaliczenie wykładu

Są dwa alternatywne sposoby na uzyskanie zaliczenia. 

###### Projekty

Tzw mikroprojekty - robione samodzielnie lub w niewielkich grupach. Powinny w jakiś sposób poruszać zagadnienia niskopoziomowe, ale jeśli się Demkowicza ładnie poprosi to zrobi wyjątek. 

Przykłady tematów w naszym roku: Sieć neuronowa do liczenia statystyk z meczów piłkarskich na podstawie nagrań, Implementacja transformacji Fouriera na ARM i porównanie wydajności z instrukcjami NEON i bez nich, Implementacja od podstaw procesora w VHDL, Aplikacja internetowa do rezerwacji wykorzystująca mikroserwisy. Konfiguracja TORa. 

Jest lista propozycji tematów od Demkowicza, można też układać własne. Należy zaimplementować to co jest tematem projektu, napisać dokumentację (w tym koniecznie instrukcję uruchomienia projektu) oraz zrobić 20-min prezentację na wykładzie.

Jest to według mnie najbardziej bezstresowa metoda na zaliczenie wykładu, o ile trochę pracochłonna. Jeśli akurat się zdarzy, że pracujecie nad jakimś własnym projektem - jest szansa że Demkowicz pozwoli ,,zrobić" z tego mikroprojekt i zaliczyć w ten sposób przedmiot. 


###### Kolokwia 

Są 2 kolokwia, z których łącznie trzeba uzyskać min. 50%. 

Pierwsze kolokwium dotyczy wykładów. Są to pytania otwarte na temat przypadkowo wybranych faktów z wykładu. Na pewno można się spodziewać pytań na temat ARM (jest to ulubiona architektura Demkowicza), na przykład *Ile rejestrów ma ARM?* lub *Narysuj schemat rdzenia ARM*. 

Do pewnego stopnia pomaga obecność na wykładach oraz przeczytanie slajdów. 

Natomiast nawet jeśli ktoś był na wszystkich wykładach i przeczytał wszystkie slajdy, kolokwium to można uznać za niezdawalne (liczba faktów do zapamiętania jest zbyt duża, nie wspominając już o zrozumieniu co Demkowicz mówi). Najelpszy wynik na naszym roku to było 5.6/10. 

Na szczęście jest drugie kolokwium. Pytania na nim dotyczą projektów i są układane przez studentów którzy robili projekty. Co oczywiście oznacza, że cały rok zna z góry listę pytań, z czego Demkowicz doskonale zdaje sobie sprawę (cytując: *A wy ułożycie pytania, które ,,w sekrecie" prześlecie międy sobą.*)

### Laborki

Jest 5 laborek, po 5 punktów każda. Wymagane jest łącznie 13 punktów do zaliczenia (nie trzeba oddawać wszystkich laborek). Praca wygląda w ten sposób, że na zajęciach dostajecie zadane i możecie zacząć nad nim pracę, a oddawanie jest na kolejnej laborce. Laborki są co 2 tygodnie, na każde zadanie są więc 2 tygodnie (wyjątkiem jest zadanie 4, na które były 4 tygodnie, oraz zad. 5 którego oddawanie było w trakcie sesji, w indywidualnie ustalonym terminie). 

Pierwsze 3 laborki polegają na implementacji jednego algorytmu (filtr o skończonej odpowiedzi impulsowej), za każdym razem w innym asemblerze. Dostajecie kod algorytmu napisany w C. Zaimplementowanie działającego algorytmu daje 3 punkty. Jeśli chcemy za dane zadanie uzyskać więcej punktów, należy algorytm zoptymalizować aby zajmował mniej cykli procesora (ocena ściśle zależy od liczby cykli)

- Lab 1: Piszecie w emulatorze Eclipse (który swoją drogą jest pracą magisterską jednego z laborantów), w tybie z mikrokodem (w tym zadaniu możecie edytować mikrokod oraz tworzyć własne instrukcje, aby było szybciej).
- Lab 2: Piszecie również w emulatorze Eclipe, w trybie potokowym.
- Lab 3: Piszecie w emulatorze procesora VLIW.

Kolejne 2 laborki polegają na napisaniu programu wykonującego kompilację JIT (Just in Time), kodu z laborki 1 lub 2 (dostajecie kod już częściowo napisany w postaci projektu w Visual Studio):

- Lab 4: Kompilacja na x86
- Lab 5: Kompilacja na ARM

Ogólnie laborki te są dosyć trudne, w szczególności ogarnięcie jak działają te emulatory. Szczególnie w zad. 2 nie pomagają bugi w emulatorze Eclipse (nie działa instrukcje BRLE - potok nie czeka na zakończenie poprzedniej instrukcji, nie działają również niektó©e rejestry procesora - więc jeśli coś wam w dziwny sposób nie działa to polecam zmianę używanego rejestru).

Natomiast dla mnie przynajmniej była to praca dosyć satysfakcjonująca. 
