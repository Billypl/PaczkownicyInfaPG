# Wstęp
Poniższa Obszerna Notatka™ jest zbiorem materiałów z wykładów i eKursów

Duża jej część to po prostu skopiowane(bądź zescreenowane materiały) z wykładów, jednakże w wielu miejscach(np. Windowsy) jest rozszerzona o dodatkową wiedzę

Z e-kursów nie tylko przepisałem tekst, który Wróbel wyświetla, ale też jego słowa - ułatwia to naukę

Ta notatka zawiera znacznie więcej materiału niż egzamin - jednakże zapoznanie się z nią raz czy dwa na pewno pomoże w dalszej nauce

Miłej nauki! 
~ Undercoverfemboy
# Wprowadzenie
Wydajność procesora jest podawana w MIPSach - Millions Instructions Per Second

Do internetu jest obecnie podłączone ok. 23mld urządzeń

![[Pasted image 20250523171713.png]]

Przykładowe managery okien na linuxie - Gnome(ubuntu na labach z SO), Cinnamon

# Shell

## Ważne
Polecenie "kill" nie zabija procesu, polecenie "kill" wysyła sygnał do procesu

## KATALOGI - Było na egzaminach

![[Pasted image 20250523194652.png]]

Przekierowanie strumieni
\> out,
< in,
| przekierowuje stdout na stdin*
2> do stderr

Sekwencyjne wykonywanie poleceń:
1. *;* jedno po drugim
2. *&&* gdy poprzednie zakończyło się sukcesem
3. *||* gdy poprzednie nie zakończyło się sukcesem

![[Pasted image 20250523203539.png]]
![[Pasted image 20250523203630.png]]

# Skrypty
## Prawa dostępu - było na egzaminach

![[Pasted image 20250525105653.png]]

- chmod ugo plik -> owner, group, others

![[Pasted image 20250525110618.png]]

## Bash - misc

![[Pasted image 20250525113516.png]]
![[Pasted image 20250525113617.png]]


# Open Source
Gates jak zawsze niszczy wszystko co dobre
![[Pasted image 20250525115510.png]]

Ten Stallman zmodyfikował kod poprzedniej drukarki w zespole w którym pracował, aby kiedy ich papier się wydrukował dostawali wiadomość. Po zmianie drukarki nie dostali dostępu do kodu źródłowego i nie mogli tego zmienić, co go bardzo wkurzyło - tak mniej więcej powstało GNU(w 1983 ogłosił pracę nad GNU).
A i Stallman był hakerem, razem ze swoją grupą koleżków z tego zespołu - AI Lab w MIT

![[Pasted image 20250525115751.png]]

Jakieś tam daty, idk czy potrzebne:
![[Pasted image 20250525115812.png]]
![[Pasted image 20250525115826.png]]

Jest jakaś lista Wolności - znowu wszyscy kopiują Gdańsk:
- Wolność 0: Brak ograniczeń w uruchamianiu programów
- Wolność 1: Możliwość studiowania działania programu
- Wolność 2: Prawo do rozpowszechniania kopii programu
- Wolność 3: Dowolność poprawiania programu

Na wykładzie jest wstawione mnóstwo różnych open-sourceowych licencji, np. BSD, MIT czy Apache. *Raczej* tego nie będzie, ale:
- MIT: Zostaw licencję, brak odpowiedzialności za szkody, brak ograniczeń, jedna z najstarszych
- BSD: Ma 4 wersje, 4-klauzulowa, 3 i 2-klauzulowa itd itp. **Można zamknąć kod, np. MacOS**
- Apache: Podobna do BSD, ale daje ochronę patentową

Licencje **NIE** open-source:
- Freeware - za darmo korzystasz, ale nie możesz nic z tym zrobić. Wolność 0
- Public domain - Czyli komunizm
- Jest ich więcej, np. Shareware, ale na wykładzie o tym nie wspomina

Na koniec wykładu jest gadanie o robieniu w open source, jakiś googlach itd itp. Taka tam fascynacja Wróbla

# Kaczmarkowe Windowsy

*Na wykładzie powiedział, że na egzaminie może pojawić się pytanie "różnica między procesem, usługą a aplikacją"*

![[Pasted image 20250525151208.png]]

Ma literówkę - powinno być kernel mode

## User mode
Ważne - procesy i usług są uruchamiane nawet jeśli użytkownik nie jest zalogowany
1. Procesy systemowe:
	- Np.: proces logowania(logon process) lub menedżer sesji(session manager)
	- Menedżer sesji jest **pierwszym** procesem uruchamianym w trybie użytkownika. Aktywuje kolejne podsystemy, kopiuje konfigurację z rejestru itd itp.
	- Proces to instancja danego .exe. Dana aplikacja może mieć wiele procesów
	- Procesy mogą wymagać interakcji z userem
	- Zawsze się uruchamia
2. Usługi systemowe:
	- Odpowiednik linuksowego demona
	- Uruchamia się zawsze, nie ważne czy user jest zalogowany czy nie
	- Usługi nie wymagają interakcji z userem
	- "Przeznaczone do specjalnych funkcji"
	- Np. Harmonogram Zadań("Task Scheduler") albo Bufor wydruku("Print Spooler")
3. Aplikacje:
	- To po prostu programy
	- Np. Chrome jest programem
	- Chrome jest aplikacją, która ma wiele procesów. Każda karta w chromie to osobny proces, z osobnym pid itd. itp.
4. Podsystemy środowisk:
	- Windows to podsystem? Nie jest to jasne na wykładzie
	- Według Wikipedii: Podsystemy to centralne komponenty windowsowych OSów. Pozwalają oprogramowaniu działać na zaprojektowanej dla nich platformie. 
	- Przykłady takich podsystemów: POSIX, Win32, OS/2
	- Nie kojarzę tego na egzaminach
5. Podsystem bibliotek DLL
	- DLL - Dynamic Link Library
	- DLL to libki które zawierają kod, dane i/lub zasoby używane przez więcej niż jedną aplikację jednocześnie
	- Interfejs WinAPI składa się z DLLek, np:
	  - Kernel32.dll
	  - Advapi32.dll
	  - User32.dll
	  - Gdi32.dll
	- ntdll.dll - eksportuje natywne api windowsa. Natywne api jest używane przez komponenty user-mode, które muszą działać bez wsparcia win32 albo innych api
	- "Zamiana funkcji udokumentowanych na nieudokumentowane" - zakładam, że odnosi się do ntdl, bo source wina jest zamknięty
## Kernel mode
1. Warstwa wykonalna(executive layer):
   - Zarządzanie wątkami i procesami
   - Zarządzanie pamięcią
   - Bezpieczeństwo
   - Obsługa I/O
   - Obsługa sieci
   - Komunikacja między procesami
2. Jądro systemu - Kernel:
	- Szeregowanie procesów
	- Obsługa przerwań i wyjątków
	- Synchronizacja procesów
	- Procedury i funkcje wykorzystywane przez warstwy wyższe
3. Sterowniki urządzeń:
	- Sterowniki sprzętu(konwersja wywołań I/O)
	- System plików
	- Sterowniki sieciowe
	- W zasadzie interfejs między sprzętem a softwarem
	- Zazwyczaj zapewniają obsługę przerwań
	- Sterują sprzętem poprzez szynę
4. Warstwa Abstrakcji Jądra - HAL:
	- W zasadzie to o czym Wróbel dużo mówił na e-kursach - niezależnie od fizycznego sprzętu programy, jądro, usługi itd. zawsze będą działały identycznie
	- HAL.dll
5. Sterowniki i interfejsy graficzne:
	- Sterowniki GPU
	- Implementacje GUI
	- Systemy okienkowe, kontrola interfejsu użytkownika, rysowanie
## Wersje Windowsów
- Home(domyślna)
- Professional(Pro)
	- Elementy Win Server
	- Remote desktop
- Enterprise
	- Microsoft Software Assurance - aby prawnicy, księgowi i reszta C-suite mogła się cieszyć. Możliwość rozłożenia opłat na kilka lat i ciągłe cieszenie się "darmowymi" aktualizacjami np. office'a
- Wersje lepsze zawierają to, co gorsze
- Windows Server
## Logowanie
1. Logowanie lokalne:
	- login
	- NAZWA_KOMPUTERA\login
	- .\login
2. Logowanie do domeny:
	- NAZWA_DOMENY\login

Sam wygląd tego wiele nie zmienia, dopiero przy Active Directory/innych rozwiązaniach zaczyna coś się zmieniac

## Domeny
- Scentralizowane zarządzanie:
	- Komputery
	- Użytkownicy
	- Inne urządzenia
- Konfiguracja profili użytkowników
	- Ta sama konfiguracja na każdym komputerze w domenie - tapeta, dokumenty, apki
- Kontrolery domeny
	- Windows Server, różne wersje
	- Serwery usług sieciowych, plików lub drukarek
W zasadzie to istnieje jedna centralna baza danych - kontroler domeny - w której są kopiowane dane userów. Zmiany lokalne są na bieżąco synchronizowane z kontrolerem - w taki sposób, że lokalny komputer pulluje dane z kontrolera zamiast do niego pushować
## Grupa robocza
- Prostsze niż domena
- Lokalne, w zasadzie kilka komputerów na lanie
## Konfiguracja
- CMD, Powershell, panel sterowania, narzędzia administracyjne i inne bajery
- Czemu cmd nie może być normalne
- Komendy z wykładu:
	- dir - ls
	- cd - normalne
	- wmic - CLI zarządzania WMI. Czym jest WMI? 
	  Windows Management Instrumentation (WMI) is the infrastructure for management data and operations on Windows-based operating systems.
	- net - Zarządzanie konfiguracją sieciową
	- ipconfig - aktualna konfiguracja sieciowa, np. ip, **odświeża** dhcp
	- nestat - Aktywne połączenia tcp i otwarte porty
	- ping - normalne
	- pathping - łączy ping i tracert
	- tracert - pokazuje trasę pakietu
## Rejestr
- Struktura hierarchiczna
- Zawiera dane dotyczące m.in.:
	- Sprzętu
	- Jądra systemu
	- Usług
	- Interfejsu użytkownika
	- Aplikacji zainstalowanych na komputerze
- Dwa podstawowe rodzaje elementów:
	- Klucze (funkcja podobna do katalogów)
	- Wartości (funkcja podobna do plików)
- Klucze zawsze występujące w korzeniu struktury
	- HKEY_CLASSES_ROOT (nazywany HKCR)
		- Powiązania plików i aplikacji
	- HKEY_CURRENT_USER (nazywany HKCU)
		- Dane aktualnie zalogowanego użytkownika
		- AppEvents – dźwięki, powiądania zdarzeń
		- Console – Konfiguracja paska poleceń (wysokość, szerokość, kolory)
		- Control Panel – wygaszacz ekranu, pulpit, ustawienia klawiatury i myszy
		- Environment – zmienne środowiskowe
		- Keyboard Layout – układ klawiatury (np. PL)
		- Network – ustawienia sieci
		- Printers – Konfiguracja drukarek
		- Software – Konfiguracja aplikacji dla użytkownika
	- HKEY_LOCAL_MACHINE (nazywany HKLM)
		- Dane zainstalowanego systemu operacyjnego
	- HKEY_USERS (nazywany HKU)
		- Dane dotyczące wszystkich użytkowników
- Klucze, które występują w zależności od wersji systemu
	- HKEY_CURRENT_CONFIG (nazywany HKCC)
		- Część informacji związanych z dostępnym sprzętem
	- HKEY_PERFORMANCE_DATA
		- Wydajność
	- HKEY_DYN_DATA (Windows 95,98,ME)
		- Dane dotyczące urządzeń
- Nie można tworzyć nowych kluczy w korzeniu
- Typy danych w rejestrze:
	- REG_NONE – brak typu
	- REG_SZ – ciąg znaków o określonej długości (Unicode)
	- REG_EXPAND_SZ – ciąg znaków o zmiennej długości
	- REG_BINARY – Dane binarne o określonej długości
	- REG_DWORD – liczba 32-bitowa
	- REG_LINK – odsyłacz
	- REG_MULTI_SZ – ciąg znaków Unicode zakończony NULL
	- REG_RESOURCE_LIST – lista zasobów sprzętu
	- REG_QWORD – liczba 64-bitowa
## PowerShell
![[Pasted image 20250525190933.png]]
## Win Api
- Napisane w C, można używać w innych językach
- Funkcje
	- Systemu plików
	- Urządzeń
	- Wątków i procesów
	- Interfejsu użytkownika
	- Sieci
	- Inne
- Typy danych:
	- Notacja węgierska, np.:
		- LPSTR - long pointer to string
		- UINT - 32 bitowy int
	- TCHAR - W zasadzie wide char xD 
	- \_T - konwersja na unicode, np. \_T("Tekst")
## Windows Server
Funkcjonalność:
- IIS (Internet Information Services)
	- Udostępnia funkcjonalność serwera FTP, HTTP, HTTPS, NNTP oraz SMTP.
	- Dostępny zarówno na wersjach Windows Server, jak i innych m.in. Windows 7 Professional (ograniczenia na wersji Windows 7 Home), Windows 8 i innych.
	- Konieczność zainstalowania przez narzędzie Dodaj lub usuń
	- programy → Włącz lub wyłącz funkcje systemu Windows
- ASP (Active Server Pages)
	- .NET, Visual Studio (język C#, C++/CLI, inne)
- PHP – konieczność dodatkowej instalacji
- Tworzenie domen
- Funkcje routera i translatora adresów sieciowych NAT(Network Address Translation)
- Serwer WWW, FTP, DHCP
- Serwer dokumentów i drukarek
- Serwer usług sieciowych (ang. Web Services)
- Serwer aplikacji
- Obsługa maszyn wirtualnych – Hyper-V
- Bazy danych (SQL Server)

Na wykładzie jest lista wersji

## Windows Azure
- Platforma chmurowa
- Przetwarzanie w chmurze obliczeniowej, praca w oparciu o usługi dostarczane za pośrednictwem sieci
- Funkcje:
	- Tworzenie i uruchamianie aplikacji w chmurze
	- Dostęp do danych
	- Automatyczna archiwizacja
	- Maszyny wirtualne
	- Chmurowe bazy danych
## Cloud
- Trzy kategorie usług:
	- IaaS (Infrastructure as a service)
	- PaaS (Platform as a service)
	- SaaS (Software as a service)
- Zalety i wady przetwarzania w chmurze
	- Zalety: Szeroka dostępność, szybkość, łatwość obsługi, konfigurowalność, dostosowanie do potrzeb użytkownika
	- Wady: Udostępnianie danych, mniejsze możliwości kontroli zmian oprogramowania, konieczność posiadania prawidłowo funkcjonującego połączenia sieciowego
## Podsumowanie
![[Pasted image 20250525192351.png]]

# Administracja
## Pakiet oprogramowania
- W skład pakietu wchodzą:
	- pliki programu
	- metadane:
		- nazwa pakietu,
		- opis,
		- wersja,
		- zależności.
- System zarządzania pakietami przechowuje informację o:
	- zainstalowanych pakietach i ich wersjach,
	- dostępnych pakietach i ich wersjach.
### Repozytoria
- Współczesne distros korzystają z repozytoriów
- Opisane za pomocą metadanych
- Repo jednej wersji debiana ma ponad 25k pakietów
### Zależności
- Korzystanie z tych samych libek
- Brak powtórnego pobierania
- Problemy:
	- Konflikt zależności - Kolejne programy potrzebują różnych wersji tej samej libki
	- Łańcuch zależności - Kolejne zależności wymagają kolejnych zależności
	- Koło zależności - Kolejne zależności potrzebują zależności poprzednich
### Systemy zarządzania pakietami
- Sprawdzają sumy kontrolne
- Weryfikują cyfrowe podpisy
- Są cudowne
## Serwer WWW
- Program udostępniający dane, np. strony, z pomocą protokołu HTTP
	- Apache czy NGINX
## Wirtualizacja
- Jednoczesne uruchamianie wielu systemów operacyjnych na jednym komputerze
- VMki monitoruje Hipernadzorca
	- Gospodarz(native/bare-metal hypervisor) - działa bezpośrednio na sprzęcie
	- Gość(hosted hypervisor) - działa na innym istniejącym systemie - przykład Virtual Box
## Konteneryzacja
- Lepsza wydajność i zarządzanie zasobami niż w przypadku VMki
- Kontener zawiera apkę i niezbędne pliki
- Izolacja apek w kontenerach
- Apki dalej mogą się komunikować
- Brak OSu w kontenerze
- **DOCKER**
	- Obraz - po prostu .iso
	- Kontener - instancja obrazu
	- Albo Dockerfile albo docker-compose(labki pamiętamy \[\*\])
# Systemy plików
## Informacje ogólne
- System plików – reguły zapisu danych na nośniku danych
- Cele stosowania systemów plików
	- Przechowywanie danych, szybki dostęp do danych, umożliwienie modyfikacji danych (m.in. dodawanie i usuwanie plików), kontrola błędów, dostarczanie informacji o zapisanych plikach
- Wirtualny system plików
	- W zasadzie to samo co HAL - różne procesy w ten sam sposób zapisują, a OS, poprzez wykorzystanie VFS, zapisze dane w odpowiednim systemie
	- W systemie operacyjnym Linux operacje na systemie plików (tj. otwarcie pliku, odczytanie zawartości pliku) odwołują się do VFS
	- Wirtualny system plików (VFS) - warstwa pośrednicząca pomiędzy rzeczywistym systemem plików, a funkcjami użytkownika odnoszącymi się do operacji na systemie plików
	- VFS realizuje funkcje użytkownika za pomocą funkcji rzeczywistego systemu plików zastosowanego na nośniku danych
- Przykłady systemów:
	- ![[Pasted image 20250525195428.png]]
## Działanie
- Bloki, inaczej klastry
	- Sekwencja bajtów lub bitów
	- Stosowane na:
		- Dyskach
		- Płytach CD/DVD
		- Pamięciach USB
		- Pliki zajmują bloki w całości
	- Przeznaczenie
		- Redukcja liczby odczytów i zapisów na dysku
		- Podczas jednej tego rodzaju operacji odczytywany jest cały blok
	- Przykładowe rozmiary: 1KB, 2KB, 4KB, ...
- Porównanie systemów windosowych:
	- ![[Pasted image 20250525195630.png]]
- Fat16:
	- Plik zapisywany w wolnych klastrach nie musi być cały ciągły
	- W części pliku brak znaku końca pliku EOF ale jest numer kolejnego klastra w którym jest dalsza część pliku
	- W wersji podstawowej nazwy na ośmiu bajtach dlatego muszą być krótkie - osiem znaków
- Fat32:
	- Zwykle stosowany wraz z implementacją LFN (Long filenames) pozwalającą na długie nazwy plików ze spacjami i polskimi literami
- NTFS:
	- Wywodzi się z systemu plików HPFS opracowanego dla systemu operacyjnego OS/2
	- Metadane plików
	- Prawa dostępu do plików (jak w UNIX)
	- Zwiększone bezpieczeństwo danych na dysku
	- Rozróżnia małe i duże litery
	- Dla każdego pliku Master File Table indeks 2KB
	- Schemat partycji z systemem plików NTFS:
		- NTFS Boot Sector
		- Master File Table
		- File System Data
		- Master File Table Copy
## Linux
- Na linuxie/unixie plikiem jest:
	- Zwykły plik
	- Katalog
	- Urządzenie (np. drukarka)
	- Dowiązanie symboliczne(symlink)
	- Inne
- Plik na linuxie jest zbudowany z 
	- Węzła informacyjnego, np. i-node
	- bloku danych
	- Więcej info w e-kursie
- Porównanie linuxowych systemów:
	- ![[Pasted image 20250525195955.png]]
- ext2
	- Rozwiązał problemy z fragmentacją występujące w exctcie
	- Wciąż używany np. na USB
	- Brak journalingu - nie zawsze jest to wada
	- Naprawa plików i katalogów programem **e2fsck**
	- Posiada mechanizmy odzyskiwania utraconych plików i katalogów (katalog lost+found)
- ext3
	- Kompatybilne z ext2
	- Utrudnione odzyskiwanie(zerowanie wskaźników do węzłów)
	- Journaling, zapis danych do dziennika przed zapisem na dysku
	- Trzy tryby journalingu:
		- Dziennik (ang. journal), najbezpieczniejszy – zarówno metadane pliku jak i jego zawartość są zapisywane w dzienniku
		- Uporządkowany (ang. ordered), domyślny – zapis do dziennika tylko  metadanych, dostępne informacje o nieprawidłowo zapisanych plikach
		- Opóźniony zapis (ang. writeback), najmniej bezpieczny – zapis do dziennika tylko metadanych, dziennik jest okresowo aktualizowany
- ext4
	- Zwiększenie wydajności dla dużych plików
	- Opóźniona alokacja przy zapisie, zmniejsza fragmentację
	- Stosowanie sum kontrolnych w dziennikach
	- Znaczniki czasu liczone z dokładnością do nanosekund
	- **e2fsck** działa szybciej
- Podstawy ext2, 3 i 4:
	- Blok identyfikacyjny (ang. superblock)
		- **Zawsze offset 1024 bajtów**
		- Zawiera m.in.: liczbę i-węzłów i bloków, liczba pustych i-węzłów i bloków (dla wszystkich grup bloków), lokalizacja pierwszego bloku danych, inne.
	- Tablica deskryptorów grupy bloków (ang. block group descriptor table)
		- Określa lokalizację mapy bitowej i-węzłów i bloków, lokalizację tablicy i-węzłów, liczbę wolnych bloków i i-węzłów, inne.
	- Mapa bitowa bloków (ang. block bitmap)
		- Każdy bit odpowiada jednemu blokowi w grupie bloków
		- Wartości są niżej
	- Mapa bitowa i-węzów (ang. inode bitmap)
		- Każdy bit odpowiada i-węzłowi w tablicy i-węzłów
		- Wartość:
			- 0 oznacza – i-węzłowi/blokowi pusty
			- 1 oznacza – i-węzłowi/blokowi pełny
	- Tablica i-węzłów (ang. inode table)
	- Bloki danych (ang. data blocks)
	- Na wykładzie przykład
- I-Węzły:
	- Zawierają informacje dotyczące plików
		- Typ pliku (zwykły plik, katalog, dowiązanie symboliczne,urządzenie itp.)
		- Identyfikator właściciela pliku
		- Prawa dostępu do pliku
		- Czas ostatniego dostępu do pliku
		- Czas ostatniej modyfikacji i-węzła
		- Czas ostatniej modyfikacji zawartości pliku
		- Liczbę dowiązań
		- Rozmiar pliku w bajtach
		- Liczba bloków danych pliku
		- Bloki danych
	- i-węzły NIE zawierają nazw plików
		- Nazwy plików zapisywane są w plikach będących katalogami
### Systemy plików HSF+, Btrfs, ZFS 
Jest na wykładzie 
## RAID:
- Macierz dyskowa
- Redundant Array of Independent Disks
- Zbiór od kilku do kilkuset dysków
- Zwiększenie:
	- Pojemności
	- Prędkości transmisji
	- Odporność na błędy
- Konfiguracje
## MBR
- MBR - Master Boot Record
	- Zawiera program rozruchowy i tablicę partycji
	- Programy do wyboru systemu operacyjnego: LILO, GRUB
- Partycje
	- Podstawowe – maksymalnie 4
	- Rozszerzona – maksymalnie 1, służy do tworzenia partycji logicznych
	- Logiczne – dowolnie dużo
	- Partycja logiczna - znowu wirtualizacja
- Sektory i klastry dysku
- Na wykładzie jest więcej przykładów co do bootloadera
## Partycje
- Wydzielony logiczny obszar dysku, który może zostać sformatowany przez OS w odpowiednim systemie plików
- Konieczność posiadania LiveCD (CDLinux, Knoppix, inne)
	- Zmiana rodzaj systemu plików programem cfdisk partycji: Type
	- Najważniejsze rodzaje partycji:
		- 07 HPFS/NTFS — system plików NTFS,
		- 0C W95 FAT32 (LBA) — system plików FAT32,
		- 82 Linux swap — partycja wymiany,
		- 83 Linux — system plików dla Linux.
- Na istniejącej partycji można utworzyć system plików
	- \# mkfs.ext3 /dev/hda2
	- \# mkfs.vfat /dev/hda5
	- \# mkfs.vfat /dev/fd0
- Zalety:
	- Uszkodzenie danych na jednej partycji nie ma wpływu na inne partycje
	- Zapełnienie jednej nie wpływa na możliwość zapisu na innych partycjach
	- Każda partycja może mieć być dostosowana do konkretnych wymagań
	- Na różnych partycjach można zainstalować kilka systemów operacyjnych.
# Procesy
## Informacje ogólne
- Program – zbiór instrukcji
- Proces – uruchomiany i wykonywany program (lub część programu)
	- Wątek - w ramach jednego procesu występować może wiele wątków, wątki wykonują się współbieżnie, lecz współdzielą zasoby procesu tj. pamięć systemową
- Program – statyczny
- Proces – dynamiczny
## Stany procesów
- Nowy
	- Został utworzony
- Gotowy
	- Czeka na przydział procka
- Aktywny
	- Wykonuje się
- Oczekujący(uśpiony)
	- Między gotowym a aktywnym
	- Czeka na zdarzenie, np. koniec odczytu z dysku
- Zakończony
- Procesy w stanie Gotowy i Oczekujący mogą być zapisywane na partycji wymiany SWAP / w pamięci wirtualnej
## Lista procesów
- Na Windowsie procesy można zobaczyć:
	- W Menedżerze Zadań
	- tasklist w cmd 
	- WMIC, np.
		- "WMIC process get Caption, ProcessId, Priority /format:htable > listaProcesow.html"
- Na Linuxie:
	- komenda ps
	- komenda top
## Zakończenie procesu
- Na Linuxie jest to kill (numer)
- Dodatkowe opcje powodują np. wymuszenie zakończenia
- Na Windowsie:
	- CMD
		- taskkill /F /IM firefox.exe
		- taskkill /PID 1234 /F
	- Task Manager
## Części procesu
- Kod programu
- Zasoby 
- Stan procesu
- Atrybuty, np. priorytet
- Informacje są przechowywane w bloku kontrolnym
	- ![[Pasted image 20250525202036.png]]
## Identyfikatory procesu na linuxie
- PID - Process ID
- PPID - PID procesu macierzystego
- UID - ID twórcy procesu. Tylko twórca może zmienić stan procesu
- GID - ID grupy procesów, przejmuje GID rodzica
## Tworzenie procesów
- EKURS
- Fork
	- Tworzy nowy proces
	- Tworzy kopię procesu macierzystego
		- Identyczne środowisko procesu, ustawienia zmiennych, priorytet procesu, itp.
	- Proces potomny jest powiązany z procesem macierzystym
	- W Linuxie wszystkie procesy są potomkami procesu o nazwie init posiadającym identyfikator PID równy 1
- Exec
	- Program zawarty w przestrzeni adresowej procesu dziecka ulega wymianie na program, który ma być wykonany w ramach danego procesu
	- Czyli - obecny program znika i pojawia się nowy
- Exit
	- Zamyka otwarte pliki
	- Zwalnia inne zasoby
	- Zapisuje statystyki
	- Budzi rodzica (jeśli czeka)
	- Proces staje się procesem mumia (ang. zombie)
## Komunikacja 
- EKURS
- Pamięć współdzielona (metoda powszechnie stosowana do komunikacji między wątkami)
- Pliki
- Sygnały (ang. signals) np. sygnał zakończenia procesu
- Potok (ang. pipe)
	- w Bash'u znak: |, w języku C: pipe()
- Kolejki komunikatów (ang. messages)
- inne
## Obsługa wielu procesów
- Ekurs
- Liczba procesów
- Różny czas wykonania procesów
- Różne priorytety procesów
- Planista (ang. scheduler)
	- Kolejkowanie zadań
	- Przydzielanie czasu procesora różnym procesom
	- Zmiana stanu procesów (gotowy, aktywny, ...)
	- Planista długoterminowy
	- Planista krótkoterminowy
- Kolejki procesów
### Rodzaje kolejek
- Będzie w sekcji Ekurs
- FIFO
- FCFS
- SJF
- STCF
- MLFQ
- Stride
- Round-Robin
- MLQ

# Zaawansowane aspekty systemów operacyjnych

System operacyjny:
- Powinien zapewniać:
	- Abstrakcję
	- Wydajność
	- Ochronę
	- Niezawodność
- Zarządza uruchamianiem programów:
	- jednoczesne działanie wielu programów
	- współdzielenie pamięci
	- dostęp do zasobów sprzętowych
	- zapewnia bezpieczeństwo
- Dostarcza abstrakcyjną warstwę dla zasobów sprzętowych
	- Fizyczne zasoby są odwzorowywane na urządzenia wirtualne, które są:
		- ustandaryzowane
		- elastyczne
		- łatwe do użycia
Pamięć operacyjna:
- W zasadzie tablica bajtów
- Do odczytu adres
- Do zapisu adres i zawartość
- Stale używana przez programy
- **Każda instancja programu otrzymuje własną wirtualną przestrzeń adresową - modyfikacja pamięci przez jeden program nie wpływa na drugi**
Procek:
- Dlaczego? Bo fizyczne ograniczenia ilość rdzeni a zapotrzebowanie jest duże
- Iluzja nieograniczonej liczby procesorów
- Struktura do przechowywania:
	- licznika
	- stosu
	- rejestru
- Przełączanie między procesami
- Wyzwalanie przełączenia:
	- Timer
	- I/O
- Dużo problemów ze współbieżnością 
Proces:
- Program to plik zawierający:
	- Zbiór instrukcji
	- Statyczne dane
- Pamięć
	- Instrukcje
	- Pamięć(przestrzeń adresowa)
	- Rejestry
		- Licznik progamu
		- Wskaźnik stosu
Mechanizm a polityka:
- Mechanizm opisuje w jaki sposób realizowane jest zadanie
- Polityka opisuje w jaki sposób korzystać z mechanizmu
API procesów:
- Create
- Destroy
- Wait - Wstrzymanie
- Resume
- Status(stan + czas trwania)
Ładowanie procesu:
- Zachłanne(eager) - stare, wszystko przed uruchomieniem
- Leniwe(lazy) - obecne, kod i dane są ładowane, gdy są potrzebne
- System tworzy w trakcie ładowania:
	- Stos - do zmiennych, parametrów funkcji czy adresów powrotów
	- Sterta - do dynamicznie alokowanych danych
- SO mapuje też wymagane I/O
![[Pasted image 20250528194229.png]]
Przykład:
![[Pasted image 20250528194358.png]]
![[Pasted image 20250528194517.png]]
Zombie - nigdy się nie zmieni na gotowy!

## Fork, exec i wait 
Fork i exec do **tworzenia** procesu, wait do jego **kontroli**

Fork tworzy kopię samego siebie, ```
```c++
int rc = fork()
// rc == 0 dla dziecka, < 0 dla błędu i > 0 dla rodzica
```

![[Pasted image 20250528195046.png]]

Wait:
Czeka aż potomek zakończy swoje działanie![[Pasted image 20250528195246.png]]
Efekt:
![[Pasted image 20250528195358.png]]

Exec:
![[Pasted image 20250528195940.png]]
Exec nadpisuje aktualne segmenty kodu i danych, tworzy nowy stos i stertę, uruchamia kod
**NIE TWORZY NOWEGO PROCESU**
W praktyce exec łączy się z forkiem, np![[Pasted image 20250528200810.png]]

![[Pasted image 20250528200923.png]]

# Wielozadaniowość
![[Pasted image 20250528201128.png]]

Współcześnie jest ograniczone bezpośrednie wywołanie:
- "Limited Direct Execution"
- Umożliwia systemowi odzyskanie kontroli nad CPU
- Umożliwia wykonanie groźnych operacji, ale pod kontrolą:
	- I/O, dostęp do pamięci
	- Ograniczenia po stronie systemu i sprzętu
Dwa tryby pracy procka:
- Usera:
	- Kod ma ograniczone możliwości
	- Brak dostępu do I/O
	- Dostęp do zasobów tylko przez wywołania systemowe
	- Te wywołania są pod kontrolą systemu operacyjnego
	- Wywołania są pod kontrolą SO
- Jądra(Kernel):
	- Brak ograniczeń
	- Tylko kernel działa w tym trybie
![[Pasted image 20250528201906.png]]
![[Pasted image 20250528202011.png]]
![[Pasted image 20250528202144.png]]

Najprostsza polityka:
Wielozadaniowość bez wywłaszczania
- SO ufa procesom
- Procesy które długo działają oddają sterowanie jądru
- System zawsze odzyskuje kontrolę podczas wywołań systemowych
- Przy niedozwolonych operacjach procesor wykonuje wywołanie systemowe
![[Pasted image 20250528202356.png]]

Przerwania zegarowe - z określonym taktem przerywają proces i wywołują wywołanie systemowe

Przełączanie kontekstu
- Planista
- CPU zachowuje część rejestrów procesu na **jego** stosie jądra - są one konieczne do ponownego przywrócenia procesu
- Przełączenie na stos jądra nowego procesu

Uruchamianie systemu operacyjnego:
![[Pasted image 20250528202729.png]]

Przełączanie procesów:
![[Pasted image 20250528202829.png]]

Return-from-trap przywraca sterowanie procesorowi

Jak często jest przełączany kontekst?
Często
Ile trwa przełączenie kontekstu?
Linux z 1996, 200MHz ~ 4 mikrosekund
Obecnie ułamki mikrosekund

# Planista

1. FIFO
	- Metryka "czas cyklu przetwarzania"(turnaround time)
	- Czas od przedłożenia zadania do wykonania
	- Nie korzysta się z FIFO
2. SJF
	- Najkrótsze zadanie pierwsze
	- Nie korzysta się
	- Skąd mamy znać czas wykonania przed wykonaniem?
3. STCF - Shortest Time To Completion First
	- Procesor wywłaszcza procesy, gdy zostaną przedłożone nowe procesy
	- Do tamtych procesów wraca dopiero po wykonaniu wszystkich później przedłożonych procesów
	- Nowa metryka - czas reakcji
	- Ile czasu od przedłożenia do uruchomienia
4. RoundRobin - rotacyjne
	- Przydzielamy kwant czasu, po kwancie kończymy zadanie i na koniec kolejki
5.  MLFQ - Wielopoziomowa kolejka ze sprzężeniem zwrotnym, Multi-Level Feedback Queue
	- Kilka niezależnych kolejek, np:
		- Kolejka pierwszoplanowa(interaktywna)
		- Kolejka drugorzędna
	- Wszystkie idą do jednej kolejki
	- Scheduler przesuwa zadania do kolejek
	- Każda kolejek inny scheduler
	- Zawsze wykonuje się zadanie w kolejce o najwyższym priorytecie
	- MLFQ zmienia priorytety zadań na podstawie obserwacji ich zachowania
		- Zadania intensywnie wykorzystujące CPU mają zmniejszany priorytet
		- Zadania interaktywne, czekające na input usera pozostają bez zmian
	- ![[Pasted image 20250528210336.png]]
	- MLFQ jest podatne na zagłodzenie - dużo zadań interaktywnych nie dopuści do uruchomienia zadań niższych
	- Oszukiwanie planisty - program co ma takie I/O, aby zawsze był wysoko
	- Zadanie może zmienić swoje zachowanie
	- PriorityBoost - co jakiś czas wszystkie zadania do kolejki 1
	- Przykład:![[Pasted image 20250528212655.png]]
6. Sprawiedliwe szeregowanie - losowanie:
	- ![[Pasted image 20250528212951.png]]
	- ![[Pasted image 20250528213203.png]]
	- Problem nie jest rozstrzygnięty
7. Stride Scheduler - sprawiedliwe, deterministyczne
	- Każdy proces ma jakiś krok, zależny od priorytetu - wyższy priorytet = niższy krok
	- Po zakończeniu kwantu do licznika dodawany jest krok
	- Bierze się zadanie z najmniejszym licznikiem

Operacje I/O
- Gdy czekamy na I/O kolejny proces jest aktywny
![[Pasted image 20250528205651.png]]
W przypadku gdy zadanie nie wykorzystuje całego kwantu czasu(np. bo IO) to zostaje w kolejce 1 więc mamy optymalny czas reakcji
![[Pasted image 20250528212253.png]]

Dodatkowo, wykracza poza wiedzę
![[Pasted image 20250528213547.png]]

BF Scheduler - Brain Fuck Scheduler

# Komunikacja w przetwarzaniu współbieżnym

Problem wyścigów, nadpisywania danych czy synchronizacji
Dane są przechowywane we wspólnej przestrzeni adresowej

Zasób, do którego może mieć tylko jeden wątek jednocześnie jest zasobem krytycznym

Semafory:
- Ma dwie funkcje - wait i post(zmniejsza i zwiększa wartość o 1)
- Wait, gdy jest < 0, czeka
- Post, gdy jakiś wątek czeka, budzi go
- SO dba o atomowość operacji modyfikacji semafora
- Wartość semafora to liczba operacji które czekają na wykonanie
- ![[Pasted image 20250528215124.png]]

Komunikacja między procesowa(IPC, Inter-process communication):
- Wymiana danych
- Z reguły architektura klient-serwera
- Wykorzystanie:
	- Współdzielenia danych
	- Dystrybucji zadań
	- Separacji uprawnień
Sygnały:
- Najprostszy sposób komunikacji
- Inaczej "przerwania programowe"
- Przekazują informacje o stanie zadania i sterują procesami
- Ctrl+c/kill to sygnał
- Ograniczone zastosowanie(bo ograniczone jest wielkością słowa bitowego)
Potoki:
- Komunikacja typu producent-konsument
- Procesy muszą mieć wspólnego przodka
- Używanie analogiczne do pliku
- Przekazuje dane
- Są jednokierunkowe
Pliki FIFO:
- Potoki nazwane
- Specjalny plik (-p)
- Dostępny dla każdego procesu
- Komenda mkfifo
Pamięć dzielona:
- Zaalokowana przez proces część pamięci
- Mogą z niej korzystać inne procesy jak z własnej przestrzeni
- Problem synchronizacji, jak z współdzieloną pamięcią
Sockety(gniazda):
- Nie tylko między procesowa, a też między systemowa
- Z pomocą API tworzone są gniazda - punkty końcowe
- Komunikacja dwukierunkowa
- Po warstwie sieciowej
- ![[Pasted image 20250529092625.png]]
Kolejka komunikatów:
- Dodatkowa warstwa, do której przekazywane są w dane w formie komunikatów
- Proces może wysyłać i odbierać dane
- Komunikacja asynchroniczna
- Komunikaty pozostają w kolejce nawet gdy nadawca się wyłączy
- Usunięcie z kolejki dopiero po odebraniu
- Proces może oczekiwać na pierwszy komunikat określonego typu lub na pierwszy komunikat
## Problem pięciu filozofów
- Bardzo dobre wyjaśnienie znajduje się w eKursie, zachęcam do obejrzenia
- Z tego co kojarzę pytanie o ten problem nigdy nie pojawiło się na egzaminie

# Zarządzanie pamięcią
Kiedyś cała pamięć = system + program
Obecnie każdy proces dostaje część RAMu

Przestrzeń adresowa:
- Wyznaczona dla procesu przestrzeń pamięci
- Dla procesu widoczna jako cała pamięć
Wirtualizacja pamięci:
![[Pasted image 20250529210144.png]]
System operacyjny przechowuje swoje dane o procesie:
### UObszar, u-obszar - jak zwał tak zwał
![[Pasted image 20250529210422.png]]

Znajdują się tam dane na temat procesu, ważne z punktu widzenia procesu
Jest tam np. lista otwartych plików, bieżący katalog, tablica obsługi sygnałów itd
Proces nie ma dostępu do uObszaru

![[Pasted image 20250529211132.png]]

Granica to rozmiar
Przechowywane w MMU
To część procesora albo osobny chip
![[Pasted image 20250529211235.png]]

Zadania systemu operacyjnego:
- Przydział pamięci procesom
	- Struktura zwana "free list" zawiera mapę pamięci, zaznacza czy jest ona wolna czy nie
- Zwalnianie pamięci
- Przy przełączaniu kontekstu:
	- Tylko jedna para rejestrów bazy i granicy w CPU
	- Możliwe fizyczne przeniesienie przestrzeni adresowej
- Obsługa wyjątków

Wyzwania w zarządzaniu pamięcią:
- Wydajność
	- Czasowa - szybkość dostępu do danych
	- Pojemność - optymalne zarządzanie ograniczonym miejscem
- Ochrona
	- Ochrona procesu przed dostępem z innych procesów/dostępem do SO
	- Izolacja
Segmentacja:
- Para rejestrów na każdy segment
- Segment to ciągły obszar pamięci
- Dzięki segmentacji rozdziela się pamięć
- Wsparcie sprzętowe w MMU, rozdział na pamięć:
	- Kodu
	- Sterty
	- Stosu
Fragmentacja
- Wolne obszary pamięci, które są zbyt małe by je do czegoś przydzielić
Rozwiązania:
- Kompaktowanie, co jakiś czas układać segmenty w ciągły obszar
- Dopasowanie segmentu, best fit: Na podstawie tablicy wolnych regionów pamięci wyszukiwane są obszary o najbardziej zbliżonym obszarze
- Niedopasowanie segmentu: Zostawiaj możliwe największe wolne obszary pamięci
- Next fit: Kolejny pasujący fragment pamięci
Fragmentacja występuje zawsze!

# Stronicowanie pamięci
Strony nie są układane w sposób ciągły
Zalety:
- Podział pamięci na bloki stałej wielkości
- Wydajność systemu(przechowywanie danych tylko o zajętości ramki)
- Do ramek wstawiane są fragmenty pamięci procesu - strony
Tablica stron:
- Umożliwia translację adresów
- Każdy proces posiada swoją
- Tablica zwiera informację w którym miejscu fizycznej pamięci znajdują się strony przestrzeni adresowej procesu
- Adres wirtualny:
	- ![[Pasted image 20250529213359.png]]
Proces translacji:
![[Pasted image 20250529213604.png]]

Tablice stron, oprócz fizycznego adresu zawierają też:
- Bit poprawności - czy strona jest poprawna(czy została zaalokowana dla niej pamięć)
- Bit ochrony - czy proces ma dostęp do pisania, czytania lub wykonywania danej strony
- Bit obecności - czy strona znajduje się w fizycznej pamięci(patrz: Pamięć wymiany)
- Bit modyfikacji - czy została zmodyfikowana(patrz: Dirty bit)
- Bit użycia - czy strona była używana

Wydajność tablicy:
- Dla każdego dostępu do pamięci wykonywane są dodatkowe operacje(wspierane sprzętowo)
- MMU zawiera TLB - Translation-lookaside buffer
- TLB zapamiętuje ostatnio obliczone translacje
- Przy odwołaniu do pamięci wpierw sprawdzane jest TLB
- Gdy nie ma dane są odczytane z tablicy stron
	- Dla x86 MMU wykonuje translację
- Przy zmianie kontekstu TLB jest czyszczone
	- Niektóre systemy ustawiają bit poprawności na 0

Rozmiar tablicy stron:
- ![[Pasted image 20250529214919.png]]
- Jak zmniejszyć problem dużej tablicy?
- ![[Pasted image 20250529215127.png]]

Segmentacja ze stronicowaniem:
- Jedna strona na logiczny segment, np. stosu
- Rejestr bazy(MMU) przechowuje fizyczny adres tablicy stron
- Rejestr granicy(MMU) rozmiar tablicy stron - wielkość
- Zmniejszenie rozmiaru tablicy stron
- ![[Pasted image 20250529215334.png]]
- Tablica segmentów decyduje o tym, na którą z tablic stron patrzymy? 
  Tak to rozumiem

Wielopoziomowe tablice stron
- Hierarchiczna, drzewiasta struktura
- Cała tablica stron podzielona na części wielkości jednej strony pamięci(page-table entries, PTE)
- Jeśli wszystkie pozycje w PTE są niepoprawne(strony są puste), system nie alokuje pamięci
- Wskaźniki do poszczególnych stron z fragmentami tablic stron znajdują się w Katalogu Stron(PDE, Page Directory Entries)
- ![[Pasted image 20250531134627.png]]
- ![[Pasted image 20250531134700.png]]
- Można tworzyć takie katalogi, katalogi katalogów tak długo, jak to jest potrzebne

Pamięć wymiany:
- Przestrzeń adresowa procesów większa, niż fizyczny RAM
- Dysk wykorzystywany jako rozszerzenie pamięci
- Dostęp dużo wolniejszy
	- ![[Pasted image 20250531134835.png]]
- System rezerwuje przestrzeń wymiany:
	- Linux - partycja wymiany
	- Windows - plik wymiany, ukryty
- Proces zawsze uzyskjuje dostęp do przestrzeni adresowej z pamięci operacyjnej
- W przypadku gdy strona znajduje się na dysku jest "wymieniana"(swap) ze stroną w pamięci
- ![[Pasted image 20250531134956.png]]
Page fault:
- ![[Pasted image 20250531135051.png]]
Polityka wymiany stron:
- W przypadku braku miejsca w pamięci wymiana stron
- Zły wybór strony skutkuje spadkiem wydajności
- Polityka:
	- FIFO
	- Losowa
	- Least-Frequently-Used(LFU)
	- Least-Recently-Used(LRU)

Dirty pages:
- Wymiana strony wymaga:
	- Odczytu nowej strony z dysku
	- Zapisu starej na dysku
-  Jeśli strona nie była zmieniona nie trzeba jej zapisać
- Bit modyfikacji(dirty bit) w tablicy stron jest ustawiany na 1 przy zmianach
	
Stronicowanie na żądanie:
- Szybki start programów
- Ładowanie tylko strony działających procesów
- Wymiana stron następuje tylko w przypadku odwołania się do strony
- Podejście "leniwe"

Szamotanie:
- Ang: Trashing
- Proces ma mniej ramek w pamięci niż aktywnych stron
- Ciągła wymiana stron
- Konieczne zakończenie procesów
- Może doprowadzić do zawieszenia systemów