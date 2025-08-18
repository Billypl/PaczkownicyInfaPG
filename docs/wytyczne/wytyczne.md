# Wytyczne

## Spis treści
1. [Ogólne](#ogólne)
2. [Przykład uniwersalny](#przykład-uniwersalny)
3. [Przykład konkretny](#przykład-konkretny-na-przykładzie-podstaw-programowania)
4. [Przykład pisania tutoriali](#przykład-pisania-tutoriali-na-semestr)
5. [Pomysły na przyszłość - przeniesione do issues](https://github.com/Billypl/PaczkownicyInfaPG/issues)

## Ogólne

- **Do folderu "stara paczka" nie wrzucamy paczki z poprzednich lat!! - tylko przedawnione / nieaktualne rzeczy.**  

- Stosujemy rok akademicki - tzn. jeżeli semestr jest nieparzysty i egzamin jest "w następnym roku", to używamy roku akademickiego (dotyczy również poprawek i trzecich terminów).   
*Np. jeżeli przedmiot zaczął się w **październiku 2022**, a egzamin był w **lutym 2023**, to używamy daty **2022**.*

- W nazwach folderów stosujemy snake_case, polskie znaki i zaczynamy je od małej litery (wyjątkiem są akronimy przedmiotów). Na samym początku umieszczamy akronim (AKO, WAI)

- Spis skrótów:  
    - zadanie -> zad  
    - domowe -> dom  
    - ćwiczenia -> cw  
    - laboratorium -> lab  

- Jeżeli nie znamy jakiejś informacji, np. roku pisania kolokwium, to zaznaczamy to placeholderem:  
    - rok -> xxxx, np. xxxx_grupa_a.pdf  
    - grupa -> x, np. 2024_grupa_x.pdf  
    - prowadzący -> x  

- Jeżeli mamy kilka np. zdjęć jednego egzaminu, to łączymy je w jednego pdfa, żeby uniknąć bałaganu. 
Najlepiej w takim wypadku dodać OCRa dla lepszego wyszukiwania / przepisać do anek / uzupełnić do sprawozdania. 

- Niezależnie od tego, czy kod mieści się w jednym pliku czy potrzebnych jest kilka, wrzucamy je w folder nazwany np. `lab0[numer]`

- Preferowanym formatem pliku jest *.pdf i należy go używać wszędzie, gdzie jest to możliwe, najlepiej z OCRem.
Wyjątek stanowią pliki czysto tekstowe, jak np. linki - przy nich stosujemy rozszerzenie *.txt.
Drugim wyjątkiem są pliki typu szablon sprawozdania, gdzie wygodny jest np. format *.docx albo *.xlsx.

- Przy opracowaniach, które zostały skompilowane z np. *.tex lub *.typ w folderze sources/ wrzucamy źródło, a kompilowanego *.pdf'a wrzucamy do normalnego folderu. Struktura wtedy powinna wyglądać tak:  

```
opracowania/
├── [SKRÓT_PRZEDMIOTU]_[rok]_[temat_opracowania].pdf
└── sources/
    └── [SKRÓT_PRZEDMIOTU]_[rok]_[temat_opracowania]/
        ├── image1.png
        ├── image2.png
        └── main.tex / main.md / main.typ
```

- I jeszcze raz ważna rzecz - **jeśli jakieś materiały się przedawniły** (zmiana zakresu przedmiotu, zmiana jego nazwy, zmiana prowadzącego, zmiana systemu oceniania, zmiana wymagane materiału) to NIE USUWAMY ich, tylko dajemy w folder stara_paczka/ **W KAŻDYM PRZEDMIOCIE Z OSOBNA**

## Przykład uniwersalny
Struktura folderu:
```
[(SKRÓT_PRZEDMIOTU)_Nazwa_Przedmiotu]/
│
├── wykład/
│    ├── [SKRÓT_PRZEDMIOTU]_[rok]_merge.pdf
│    ├── [SKRÓT_PRZEDMIOTU]_[rok]_wykład_0[nr_wykladu]-[temat_wykladu].pdf
│    └── egzamin/
│       └── [SKROT_PRZEDMIOTU]_[rok]_egzamin_grupa_[nr_grupy].png
│
├── kolokwia/
│   └── kol_0[nr_kolosa]/
│       └── [SKRÓT_PRZEDMIOTU]_[rok]_kol_[nr_kol]_[prowadzący]_grupa_[nr_grupa].pdf
│
├── opracowania/
│   ├── [SKRÓT_PRZEDMIOTU]_[rok]_[temat_notatki].pdf
│   ├── [SKRÓT_PRZEDMIOTU]_[rok]_[temat_opracowania].pdf
│   ├── [SKRÓT_PRZEDMIOTU]_[rok]_anki.apkg
│   └── sources/
│       └── [SKRÓT_PRZEDMIOTU]_[rok]_[temat_opracowania]/
│           ├── image1.png
│           ├── image2.png
│           └── main.tex / main.md / main.typ
│
├── laboratoria/
│   ├── wspólne/
│   │   └── lab_0[nr_laby]/
│   │      ├── [SKRÓT_PRZEDMIOTU]_[rok]_lab_0[nr_laby]_instrukcja.pdf
│   │      └── [SKRÓT_PRZEDMIOTU]_[rok]_lab_0[nr_laby]_rozw/
│   │           └── main.cpp / matma.png
│   └── [nazwisko_prowadzacego]/
│       └── lab_0[nr_laby]
│          └── [SKRÓT_PRZEDMIOTU]_[rok]_lab_0[nr_laby]_instrukcja-[nazwisko_prowadzącego].pdf
│
├── ćwiczenia/
│    └── [nazwisko_prowadzącego] 
│        └── [SKRÓT_PRZEDMIOTU]_[rok]_cw_0[nr_ćwiczeń]-[temat].pdf
│
├── projekt/
│   └── [rok]_[nr_projektu]/
│       ├── [SKRÓT_PRZEDMIOTU]_[rok]_projekt_instrukcja-[nazwa_projektu].pdf
│       └── [SKRÓT_PRZEDMIOTU]_[rok]_projekt_rozw_[nr_rozwiazania]/
│           └── pliki.cpp # itp
│
├── książki/
│   ├── polecana_literatura_linki.txt
│   └── łagodne_wprowadzenie_2026.pdf
│
├── inne/
│   └── nagrania.txt # linki do nagrań
│
└── stara_paczka/
    └── # podział jak wyżej, tylko wrzucamy tam już NIEAKTUALNE PLIKI (tzn. gdy wykłady się zmieniły albo forma egzaminu) (żeby zachować historię, ale nie zaśmiecać paczki)
```

## Przykład konkretny (na przykładzie Podstaw Programowania)
Struktura folderu:
```
(PP)_Podstawy_Programowania/
│
├── wykład/
│    ├── PP_2022_wyklad_merge.pdf
│    ├── PP_2022_wyklad_01-instrukcje_warunkowe.pdf
│    └── egzamin/
│       └── PP_2022_egzamin_grupa_a.png
│
├── kolokwia/
│   └── kol_01/
│       └── PP_2022_kol_1_ostrowski_grupa_a.pdf
│
├── opracowania/
|   ├── PP_2022_anki.apkg
│   ├── PP_2022_przed_egzaminem_pawiłojć.pdf
│   └── sources/
│       └── PP_2022_przed_egzaminem_pawiłojć/
│           ├── image1.png
│           ├── image2.png
│           └── main.tex / main.md / main.typ
│
├── laboratoria/
│   ├── wspólne/
│   │   └── lab_01/
│   │      ├── PP_2022_lab_01_instrukcja.pdf
│   │      └── PP_2022_lab_01_rozw/
│   │          └── pliki.cpp # itp
│   └── ostrowski/
│       └── lab_01/
│           ├── PP_2022_lab_01_instrukcja-ostrowski.pdf
│           └── PP_2022_lab_01_rozw_ostrowski/
│               └── zad1.cpp
│
├── ćwiczenia/
│    └── ostrowski
│        ├── PP_2022_cw_01-wskazniki.pdf
│        └── PP_2022_cw_01_rozw-wskazniki/
│            └── zad1.cpp
│
├── projekt/
│   └── 2022_1/
│       ├── PP_2022_projekt_instrukcja-jumping_frog.pdf
│       └── PP_2022_projekt_rozw_1-jumping_frog
│           └── pliki.cpp # itp
│
├── książki/
│   ├── polecana_literatura_linki.txt
│   ├── polecana_literatura_skan.pdf
│   ├── skrypt_prowadzącego.pdf
│   └── łagodne_wprowadzenie_2026.pdf
│
├── inne/
│   ├── nagrania.txt # w środku np. PP - [link_do_playlisty_z_PP]
│   └── przydatne_linki.txt
│
└── stara_paczka/
    └── # podział jak wyżej, tylko wrzucamy tam już NIEAKTUALNE PLIKI (tzn. gdy wykłady się zmieniły albo forma egzaminu) (żeby zachować historię, ale nie zaśmiecać paczki)
```

## Przykład pisania tutoriali na semestr
```
1. Overall podsumowanie sema w kilku zdaniach  
2. Tabelka ujebywalności  
3. Nazwa Przedmiotu  
    3.1. Spis prowadzących i opinie o nich  
    3.2. Ogólny zarys przedmiotu  
        3.2.1. Opinie studentów  
    3.3. Wylistowane składowe przedmiotu wraz ze sposobem zaliczenia  
    3.4. Wykład  
    3.5. Ćwiczenia  
    3.6. Laboratorium  
    3.7. Projekt  
5. Sekcja podsumowująca jak zdać i na co zwrócić największą uwagę + protipy  
```
